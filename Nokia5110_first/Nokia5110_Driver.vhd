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
    g_frame_size : natural := 8;
    g_clk_spi_spd : natural := 2000;       -- khz
    g_update_rate : natural := 1        -- updates per second, best results below 5 fps
);
port (
    CLK : in std_logic;     -- assumed to be 100Mhz
    CLK_SPI : in std_logic; -- Must be less than 4Mhz for Nokia5110
    RSTn : in std_logic;
    enable : in std_logic;

    driver_busy : out std_logic;

    SPIDO : out std_logic;
    SPICLK : out std_logic;
    data_command : out std_logic;
    chip_enable : out std_logic;
    RSTout : out std_logic
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


    constant disp_X_CON : natural := 84;
    constant disp_Y_CON : natural := 6;

    -- BEGIN LCD Register signals
    signal inverse_display : std_logic := '0';
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
    

    -- X address is 0 to 83, Y address is 0 to 5
    -- total LCD bytes is X * Y = max 503 = (84 * 6) - 1
    -- BEGIN display_mem_comp : Nokia5110_Memory signals
    signal disp_byte_X : natural range 0 to disp_X_CON - 1 := 0;
    signal disp_byte_Y : natural range 0 to disp_Y_CON - 1 := 0;
    signal disp_byte_out : std_logic_vector(7 downto 0) := (others => '0');
    -- END display_mem_comp : Nokia5110_Memory signals

    -- BEGIN LCD_timer : timer signals
    signal timer_indicator_sig : std_logic := '0';
    -- END LCD_timer : timer signals

    component Nokia5110_Memory
        port (
            CLK : in std_logic;     -- assumed to be 100Mhz
            RSTn : in std_logic;

            mem_addr_X : in natural range 0 to 83;
            mem_addr_Y : in natural range 0 to 5;
            display_byte : out std_logic_vector(7 downto 0)
        );
    end component;

    component timer
        generic(
            g_timer_count : natural := 200;
            g_repeat : std_logic := '1'
        );
        port(
            CLK : in std_logic;
            PRESETN : in std_logic;

            timer_indicator : out std_logic
        );
    end component;


begin

    display_mem_comp : Nokia5110_Memory
    port map (
        CLK => CLK,
        RSTn => RSTn,

        mem_addr_X => disp_byte_X,
        mem_addr_Y => disp_byte_Y,
        display_byte => disp_byte_out
    );

    LCD_timer : timer
    generic map (
        g_timer_count => (g_clk_spi_spd * 1000) / g_update_rate,
        g_repeat => '1'
    )
    port map (
        CLK => CLK_SPI,
        PRESETN => RSTn,

        timer_indicator => timer_indicator_sig
    );


    process(CLK, RSTn)
        variable send_Frame : std_logic := '0';
    begin
        if(RSTn = '0') then
            LCD_State <= init;
            init_step <= (others => '0');
            frame_count <= 0;
            frame_start <= '0';
            frame_get_bit <= '0';
            screen_send <= '0';
            screen_finished <= '0';

            disp_byte_X <= 0;
            disp_byte_Y <= 0;
            SPIout_byte <= (others => '0');
            inverse_display <= '0';

            SPIDO_sig <= '0';
            data_command_sig <= '0';
            data_command_queue_sig <= '0';
            chip_enable_sig <= '0';
        elsif(rising_edge(CLK)) then
            SPICLK_last_sig <= SPICLK_sig;
        
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
                                    SPIout_byte <= "00100011";      -- set H = 1
                                    init_step <= init_step + 1;
                                when 1 =>
                                    SPIout_byte <= "00010011";      -- set Bias
                                    init_step <= init_step + 1;
                                when 2 =>
                                    SPIout_byte <= "10111001";      -- set Vop
                                    init_step <= init_step + 1;
                                when 3 =>
                                    SPIout_byte <= "00100010";      -- set H = 0
                                    init_step <= init_step + 1;
                                when 4 =>
                                    SPIout_byte <= "10000000";      -- set X address
                                    init_step <= init_step + 1;
                                when 5 =>
                                    SPIout_byte <= "01000000";      -- set Y address
                                    init_step <= init_step + 1;
                                when 6 =>
                                    SPIout_byte <= "0000110" & inverse_display;      -- set display mode to normal
                                    inverse_display <= not inverse_display;
                                    init_step <= init_step + 1;
                                    
                                    LCD_State <= data;
                                    init_step <= (others => '0');
                                when others =>
                                    null;
                            end case;
                        when data =>
                            data_command_queue_sig <= '1';

                            SPIout_byte <= disp_byte_out;
                            -- iterate through (x, y) of screen memory
                            if(screen_finished = '0') then
                                if(disp_byte_Y = disp_Y_CON - 1) then
                                    disp_byte_Y <= 0;
                                    if(disp_byte_X = disp_X_CON - 1) then
                                        disp_byte_X <= 0;
                                        -- last screen byte is put in the buffer
                                        screen_finished <= '1';     -- send last byte
                                    else
                                        disp_byte_X <= disp_byte_X + 1;
                                    end if;
                                else
                                    disp_byte_Y <= disp_byte_Y + 1;
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
                if(timer_indicator_sig = '1') then
                    screen_send <= '1';
                end if;
            end if;
        end if;
    end process;

    SPICLK_sig <= CLK_SPI;

    driver_busy <= screen_send;

    RSTout <= RSTn;
    SPIDO <= SPIDO_sig when screen_send = '1' else '0';
    SPICLK <= SPICLK_sig when screen_send = '1' else '0';
    data_command <= data_command_sig;
    chip_enable <= not chip_enable_sig;     -- Nokie5110 SCE is active LOW, my brain is active HIGH

   -- architecture body
end architecture_Nokia5110_Driver;
