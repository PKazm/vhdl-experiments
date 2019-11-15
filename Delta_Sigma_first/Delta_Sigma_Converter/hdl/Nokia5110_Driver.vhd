--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Nokia5110_Driver.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S010> <Package::144 TQ>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Nokia5110_Driver is
generic (
    g_clk_period : natural := 10;     -- 10 ns = 100Mhz
    g_clk_spi_div : natural := 50;      -- (g_clk_period * g_clk_spi_div) should be > 250ns (4Mhz max SPI clock rate)
    g_frame_size : natural := 8;
    g_update_rate : natural := 1        -- updates per second, best results below 5 fps
);
port (
    CLK : in std_logic;     -- assumed to be 100Mhz
    --CLK_SPI : in std_logic; -- Must be less than 4Mhz for Nokia5110
    RSTn : in std_logic;
    --enable : in std_logic;
    driver_busy : out std_logic;

    -- SPI connections
    SPIDO : out std_logic;
    SPICLK : out std_logic;
    data_command : out std_logic;
    chip_enable : out std_logic;
    RSTout : out std_logic;
    -- SPI connections

    -- APB connections
    PADDR : in std_logic_vector(7 downto 0);
	PSEL : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(7 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(7 downto 0);
	PSLVERR : out std_logic;

	--INT : out std_logic;
    -- APB connections

    -- uSRAM connections
        -- A block is for reading out to APB
    uSRAM_A_ADDR : out std_logic_vector(8 downto 0);
    uSRAM_A_DOUT : in std_logic_vector(7 downto 0);

        -- B block is for reading out to LCD via SPI
    uSRAM_B_ADDR : out std_logic_vector(8 downto 0);
    uSRAM_B_DOUT : in std_logic_vector(7 downto 0);

        -- C block is for writing from APB
    uSRAM_C_BLK : out std_logic;
    uSRAM_C_ADDR : out std_logic_vector(8 downto 0);
    uSRAM_C_DIN : out std_logic_vector(7 downto 0)
    -- uSRAM connections
);
end Nokia5110_Driver;
architecture architecture_Nokia5110_Driver of Nokia5110_Driver is
    type LCD_state_machine is(init, newframe, data);
    signal LCD_State : LCD_state_machine;
    signal init_step : unsigned (3 downto 0) := (others => '0');    -- initialization state machine to write to each LCD register

    -- frame signals are used internally by the SPI output logic and are reset each frame
    signal frame_start : std_logic := '0';
    signal frame_get_bit : std_logic := '0';
    signal frame_count : natural range 0 to g_frame_size - 1 := 0;

    -- screen signals are used internally the SPI output logic and indicate when the whole screen should start being sent or is finished being sent
    signal screen_send : std_logic := '0';
    signal screen_finished : std_logic := '0';

    signal refresh_indicator : std_logic := '0';

    -- BEGIN LED Driver Register signals
    constant Driver_reg_ctrl_ADDR : std_logic_vector(7 downto 0) := X"00";

    signal Driver_reg_ctrl : std_logic_vector(7 downto 0) := X"00";
    -- END LED Driver Register signals
    -- BEGIN LCD Register signals
    constant LCD_reg_func_set_ADDR : std_logic_vector(7 downto 0) := X"01";
    constant LCD_reg_disp_ctrl_ADDR : std_logic_vector(7 downto 0) := X"02";
    constant LCD_reg_temp_ctrl_ADDR : std_logic_vector(7 downto 0) := X"03";
    constant LCD_reg_bias_sys_ADDR : std_logic_vector(7 downto 0) := X"04";
    constant LCD_reg_Vop_set_ADDR : std_logic_vector(7 downto 0) := X"05";
    constant LCD_reg_mem_data_ADDR : std_logic_vector(7 downto 0) := X"10";        -- read/write to this register will apply to display data at the X,Y position denoted by the mem_X and mem_Y registers
    constant LCD_reg_mem_X_ADDR : std_logic_vector(7 downto 0) := X"11";        -- stores X address of display data to be read/written (0 to  83)
    constant LCD_reg_mem_Y_ADDR : std_logic_vector(7 downto 0) := X"12";        -- stores Y address of display data to be read/written (0 to  5)

    signal LCD_reg_func_set : std_logic_vector(7 downto 0) := "00100010";
    signal LCD_reg_disp_ctrl : std_logic_vector(7 downto 0) := "00001100";
    signal LCD_reg_temp_ctrl : std_logic_vector(7 downto 0) := "00000100";
    signal LCD_reg_bias_sys : std_logic_vector(7 downto 0) := "00010011";
    signal LCD_reg_Vop_set : std_logic_vector(7 downto 0) := "10111001";
    signal LCD_reg_mem_data : std_logic_vector(7 downto 0) := X"00";
    signal LCD_reg_mem_X : std_logic_vector(7 downto 0) := X"00";
    signal LCD_reg_mem_Y : std_logic_vector(7 downto 0) := X"00";
    -- END LCD Register signals
    
    
    signal SPICLK_last_sig : std_logic := '0';

    -- BEGIN LCD output signals
    signal SPIDO_sig : std_logic := '0';
    signal SPICLK_sig : std_logic := '0';
    signal data_command_sig : std_logic := '0';
    signal data_command_queue_sig : std_logic := '0';
    signal chip_enable_sig : std_logic := '0';

    signal SPIout_byte : std_logic_vector(7 downto 0) := (others => '0');
    -- END LCD output signals

    -- BEGIN APB signals
    signal prdata_sig : std_logic_vector(7 downto 0) := (others => '0');
    --signal pready_sig : std_logic := '0';
    -- END APB signals

    constant disp_X_CON : natural := 84;        -- why use constants? because magic numbers are bad
    constant disp_Y_CON : natural := 6;         -- also debugging to with smaller "screen sizes" can be done by changing these
    constant disp_total_mem_CON : natural := 504;       -- total memory slots used by the display uSRAM
    signal mem_addr_updated : std_logic := '0';
    -- X address is 0 to 83, Y address is 0 to 5
    -- total LCD bytes is X * Y = max 503 = (84 * 6) - 1
    -- BEGIN uSRAM Connection signals
    signal uSRAM_A_ADDR_sig : std_logic_vector(8 downto 0) := (others => '0');      -- address from APB read
    signal uSRAM_A_DOUT_sig : std_logic_vector(7 downto 0) := (others => '0');      -- data to APB read

    signal uSRAM_B_ADDR_sig : unsigned(8 downto 0) := (others => '0');      -- address from SPI driver write to LCD
    signal uSRAM_B_DOUT_sig : std_logic_vector(7 downto 0) := (others => '0');      -- data to SPI driver write to LCD

    signal uSRAM_C_BLK_sig : std_logic := '0';      -- pulse each time APB write to display memory
    signal uSRAM_C_ADDR_sig : std_logic_vector(8 downto 0) := (others => '0');      -- address from APB write
    signal uSRAM_C_DIN_sig : std_logic_vector(7 downto 0) := (others => '0');      -- data write APB write
    -- END uSRAM Connection signals
    
    -- BEGIN SPI_timer : timer signals
    signal CLK_SPI_sig : std_logic := '0';
    -- END SPI_timer : timer signals

    -- BEGIN LCD_timer : timer signals
    signal timer_indicator_sig : std_logic := '0';
    signal timer_indicator_last_sig : std_logic := '0';
    -- END LCD_timer : timer signals

    component timer
        generic(
            g_timer_count : natural := 200;
            g_repeat : std_logic := '1'
        );
        port(
            CLK : in std_logic;
            PRESETN : in std_logic;

            timer_clock_out : out std_logic;
            timer_interrupt_pulse : out std_logic
        );
    end component;


begin

    SPI_timer : timer
    generic map (
        g_timer_count => g_clk_spi_div,
        g_repeat => '1'
    )
    port map (
        CLK => CLK,
        PRESETN => RSTn and Driver_reg_ctrl(0),

        timer_clock_out => CLK_SPI_sig,
        timer_interrupt_pulse => open
    );

    LCD_timer : timer
    generic map (
        g_timer_count => 1000000000 / (g_clk_period * g_clk_spi_div * g_update_rate),
        g_repeat => '1'
    )
    port map (
        CLK => CLK_SPI_sig,
        PRESETN => RSTn and Driver_reg_ctrl(0),

        timer_clock_out => open,
        timer_interrupt_pulse => timer_indicator_sig
    );


    --=========================================================================
    -- BEGIN APB Register Read logic
    APB_Reg_Read_process: process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            prdata_sig <= (others => '0');
        elsif(rising_edge(CLK)) then
            if(PWRITE = '0' and PSEL = '1') then
                case PADDR is
                    when Driver_reg_ctrl_ADDR =>
                        prdata_sig <= Driver_reg_ctrl;
                    when LCD_reg_func_set_ADDR =>
                        prdata_sig <= LCD_reg_func_set;
                    when LCD_reg_disp_ctrl_ADDR =>
                        prdata_sig <= LCD_reg_disp_ctrl;
                    when LCD_reg_temp_ctrl_ADDR =>
                        prdata_sig <= LCD_reg_temp_ctrl;
                    when LCD_reg_bias_sys_ADDR =>
                        prdata_sig <= LCD_reg_bias_sys;
                    when LCD_reg_Vop_set_ADDR =>
                        prdata_sig <= LCD_reg_Vop_set;
                    when LCD_reg_mem_data_ADDR =>
                        prdata_sig <= LCD_reg_mem_data;
                    when LCD_reg_mem_X_ADDR =>
                        prdata_sig <= LCD_reg_mem_X;
                    when LCD_reg_mem_Y_ADDR =>
                        prdata_sig <= LCD_reg_mem_Y;
                    when others =>
                        prdata_sig <= (others => '0');
                end case;
            else
                prdata_sig <= (others => '0');
            end if;
        end if;
    end process;

    -- BEGIN APB Return wires
    PRDATA <= prdata_sig;
    PREADY <= '1'; --pready_sig;
    PSLVERR <= '0';
    -- END APB Return wires

    -- END APB Register Read logic
    --=========================================================================
    -- BEGIN Register Write logic

    p_Driver_reg_ctrl : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            Driver_reg_ctrl <= "00000011";
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = Driver_reg_ctrl_ADDR) then
                -- 0bXXXXXX & refresh indicator & enable
                Driver_reg_ctrl <= PWDATA;
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    --p_LCD_reg_mem_write : process(CLK, RSTn)
    --begin
    --    if(RSTn = '0') then
    --        null;
    --    elsif(rising_edge(CLK)) then
    --        if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR(15 downto 12) = LCD_reg_mem_write_ADDR) then
    --            uSRAM_C_ADDR_sig <= PADDR(8 downto 0);
--
    --            uSRAM_C_DIN_sig <= PWDATA;
    --            uSRAM_C_BLK_sig <= '1';
    --        else
    --            uSRAM_C_BLK_sig <= '0';
    --        end if;
    --    end if;
    --end process;

    --=========================================================================

    p_LCD_reg_func_set : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_func_set <= "00100000";
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_func_set_ADDR) then
                -- 0b00100 & PD & V & H
                -- H is not used from the register and is instead controlled in the FSM of p_LCD_SPI_Control
                LCD_reg_func_set <= "00100" & PWDATA(2 downto 0);
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_disp_ctrl : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_disp_ctrl <= "00001100";
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_disp_ctrl_ADDR) then
                -- 0b00001 & D & 0 & E
                LCD_reg_disp_ctrl <= "00001" & PWDATA(2) & '0' & PWDATA(0);
            else
                -- timer_indicator_last_sig is updated in p_LCD_SPI_Control
                --if(timer_indicator_last_sig = '0' and timer_indicator_sig = '1') then
                --    LCD_reg_disp_ctrl(0) <= not LCD_reg_disp_ctrl(0);
                --end if;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_temp_ctrl : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_temp_ctrl <= "00000100";
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_temp_ctrl_ADDR) then
                -- 0b000001 & TC1 & TC0
                LCD_reg_temp_ctrl <= "000001" & PWDATA(1 downto 0);
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_bias_sys : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_bias_sys <= "00010011";
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_bias_sys_ADDR) then
                -- 0b00010 & BS2 & BS1 & BS0
                LCD_reg_bias_sys <= "00010" & PWDATA(2 downto 0);
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_Vop_set : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_Vop_set <= "10111001";
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_Vop_set_ADDR) then
                -- 0b1 & Vop6 & Vop5 & Vop4 & Vop3 & Vop2 & Vop1 & Vop0
                LCD_reg_Vop_set <= '1' & PWDATA(6 downto 0);
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_mem_data : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            uSRAM_C_DIN_sig <= (others => '0');
            uSRAM_C_BLK_sig <= '0';
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_mem_data_ADDR) then
                -- p_Calc_Mem_ADDR result determines uSRAM location
                uSRAM_C_DIN_sig <= PWDATA;
                uSRAM_C_BLK_sig <= '1';
            else
                uSRAM_C_BLK_sig <= '0';
                LCD_reg_mem_data <= uSRAM_A_DOUT_sig;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_mem_X : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_mem_X <= (others => '0');
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_mem_X_ADDR) then
                -- LCD_reg_mem_X is used in p_Calc_Mem_ADDR to calculate uSRAM location
                LCD_reg_mem_X <= '0' & PWDATA(6 downto 0);        -- 83 = 0b1010011
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    p_LCD_reg_mem_Y : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_reg_mem_Y <= (others => '0');
        elsif(rising_edge(CLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = LCD_reg_mem_Y_ADDR) then
                -- LCD_reg_mem_Y is used in p_Calc_Mem_ADDR to calculate uSRAM location
                LCD_reg_mem_Y <= "00000" & PWDATA(2 downto 0);        -- 5 = 0b101
            else
                null;
            end if;
        end if;
    end process;

    -- END Register Write logic
    --=========================================================================

    p_Calc_Mem_ADDR : process(CLK, RSTn)
        variable math_result : natural;
    begin
        if(RSTn = '0') then
            uSRAM_A_ADDR_sig <= (others => '0');
            uSRAM_C_ADDR_sig <= (others => '0');
        elsif(rising_edge(CLK)) then
            -- Calc uSRAM ADDR (0 to 503) based on X (0 to 83) and Y (0 to 5)
            -- This driver uses horizontal addressing to write to all X addresses in a Y row before moving to the next Y+1 row
            -- result is used by uSRAM_A for reading and uSRAM_C for writing

            -- mem_ADDR = LCD_reg_mem_Y * 84 + LCD_reg_mem_X
            case to_integer(unsigned(LCD_reg_mem_Y)) is
                when 0 =>
                    math_result := 0;
                when 1 =>
                    math_result := 84;
                when 2 =>
                    math_result := 168;
                when 3 =>
                    math_result := 252;
                when 4 =>
                    math_result := 336;
                when 5 =>
                    math_result := 420;
                when others =>
                    math_result := 0;
            end case;

            math_result := math_result + to_integer(unsigned(LCD_reg_mem_X));
            uSRAM_A_ADDR_sig <= std_logic_vector(to_unsigned(math_result, uSRAM_A_ADDR_sig'length));
            uSRAM_C_ADDR_sig <= std_logic_vector(to_unsigned(math_result, uSRAM_C_ADDR_sig'length));
        end if;

    end process;


    p_LCD_SPI_Control : process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_State <= init;
            init_step <= (others => '0');
            frame_count <= 0;
            frame_start <= '0';
            frame_get_bit <= '0';
            screen_send <= '0';
            screen_finished <= '0';

            refresh_indicator <= '0';
            uSRAM_B_ADDR_sig <= (others => '0');
            SPIout_byte <= (others => '0');

            SPIDO_sig <= '0';
            data_command_sig <= '0';
            data_command_queue_sig <= '0';
            chip_enable_sig <= '0';
        elsif(rising_edge(CLK)) then
            SPICLK_last_sig <= SPICLK_sig;
            timer_indicator_last_sig <= timer_indicator_sig;        -- Used by other processes as well (p_LCD_reg_disp_ctrl)
        
            if(screen_send = '1') then
                if(SPICLK_last_sig = '1' and SPICLK_sig = '0') then

                    if(frame_count = 0) then
                        -- first bit in frame
                        frame_count <= frame_count + 1;
                        frame_start <= '1';
                    elsif(frame_count = g_frame_size - 1)  then
                        -- last bit in frame
                        frame_count <= 0;
                    else
                        -- middle bits in frame
                        frame_count <= frame_count + 1;
                    end if;
                    
                    frame_get_bit <= '1';
                end if;

                if(frame_start = '1') then
                    -- this should occur on the first rising_edge(CLK) after falling_edge(CLK_SPI) if frame_start
                    -- this should occur only once per frame
                    -- determine next frame
                    frame_start <= '0';

                    case LCD_State is
                        when init =>
                            data_command_queue_sig <= '0';
                            case to_integer(init_step) is
                                when 0 =>
                                    SPIout_byte <= LCD_reg_func_set(7 downto 1) & "1";      -- set H = 1
                                    init_step <= init_step + 1;
                                when 1 =>
                                    SPIout_byte <= LCD_reg_bias_sys;      -- set Bias
                                    init_step <= init_step + 1;
                                when 2 =>
                                    SPIout_byte <= LCD_reg_Vop_set;      -- set Vop
                                    init_step <= init_step + 1;
                                when 3 =>
                                    SPIout_byte <= LCD_reg_func_set(7 downto 1) & "0";      -- set H = 0
                                    init_step <= init_step + 1;
                                when 4 =>
                                    SPIout_byte <= "10000000";      -- set X address
                                    init_step <= init_step + 1;
                                when 5 =>
                                    SPIout_byte <= "01000000";      -- set Y address
                                    init_step <= init_step + 1;
                                when 6 =>
                                    SPIout_byte <= LCD_reg_disp_ctrl;      -- set display mode
                                    init_step <= init_step + 1;
                                    
                                    LCD_State <= data;
                                    init_step <= (others => '0');
                                when others =>
                                    null;
                            end case;
                        when data =>
                            data_command_queue_sig <= '1';
                                
                            if(Driver_reg_ctrl(1) = '1' and uSRAM_B_ADDR_sig = 0 and refresh_indicator = '1') then
                                SPIout_byte <= not uSRAM_B_DOUT_sig;
                            else
                                SPIout_byte <= uSRAM_B_DOUT_sig;
                            end if;
                            -- iterate through (x, y) of screen memory
                            if(screen_finished = '0') then
                                if(uSRAM_B_ADDR_sig = disp_total_mem_CON - 1) then
                                    uSRAM_B_ADDR_sig <= (others => '0');
                                    -- last screen byte is put in the buffer
                                    screen_finished <= '1';     -- send last byte
                                    refresh_indicator <= not refresh_indicator;
                                else
                                    uSRAM_B_ADDR_sig <= uSRAM_B_ADDR_sig + 1;
                                end if;
                            else        -- screen_finished = '1'
                                screen_send <= '0';     -- This is the exit condition
                                screen_finished <= '0';
                                frame_count <= 0;
                                frame_get_bit <= '0';

                                LCD_State <= init;     -- redo init to accomodate poor connection or I/O timing.
                            end if;
                        when others =>
                            null;
                    end case;
                elsif(frame_get_bit = '1' and frame_start = '0') then
                    -- this should occur on the second rising_edge(CLK) after falling_edge(CLK_SPI) if frame_start
                    -- this should occur on the first rising_edge(CLK) after falling_edge(CLK_SPI) if middle/end of frame
                    frame_get_bit <= '0';
                    SPIDO_sig <= SPIout_byte(SPIout_byte'high);                         -- send bit out
                    SPIout_byte <= SPIout_byte(SPIout_byte'high - 1 downto 0) & '0';    -- shift output register
                    chip_enable_sig <= '1';                                             -- ensure chip_enable is... enabled
                    data_command_sig <= data_command_queue_sig;                         -- set data_command line based on output type
                end if;
            elsif(screen_send = '0') then
                chip_enable_sig <= '0';
                if(timer_indicator_last_sig = '0' and timer_indicator_sig = '1') then
                    screen_send <= '1';
                end if;
            end if;
        end if;
    end process;

    SPICLK_sig <= CLK_SPI_sig;

    uSRAM_A_ADDR <= uSRAM_A_ADDR_sig;
    uSRAM_A_DOUT_sig <= uSRAM_A_DOUT;

    uSRAM_B_ADDR <= std_logic_vector(uSRAM_B_ADDR_sig);
    uSRAM_B_DOUT_sig <= uSRAM_B_DOUT;

    uSRAM_C_BLK <= uSRAM_C_BLK_sig;
    uSRAM_C_ADDR <= uSRAM_C_ADDR_sig;
    uSRAM_C_DIN <= uSRAM_C_DIN_sig;

    driver_busy <= screen_send;

    RSTout <= RSTn;
    SPIDO <= SPIDO_sig when screen_send = '1' else '0';
    SPICLK <= SPICLK_sig when screen_send = '1' else '0';
    data_command <= data_command_sig;
    chip_enable <= not chip_enable_sig;     -- Nokie5110 SCE is active LOW, my brain is active HIGH

   -- architecture body
end architecture_Nokia5110_Driver;
