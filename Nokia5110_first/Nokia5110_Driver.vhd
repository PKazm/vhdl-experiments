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
    frame_size : natural := 8
);
port (
    CLK : in std_logic;     -- assumed to be 100Mhz
    CLK_SPI : in std_logic; -- Must be less than 4Mhz for Nokia5110
    RSTn : in std_logic;
    enable : in std_logic;

    SPIDO : out std_logic;
    SPICLK : out std_logic;
    data_command : out std_logic;
    chip_enable : out std_logic;
    RSTout : out std_logic
);
end Nokia5110_Driver;
architecture architecture_Nokia5110_Driver of Nokia5110_Driver is
    type LCD_state_machine is(init, data);
    signal LCD_State : LCD_state_machine;
    signal init_step : unsigned (3 downto 0) := (others => '0');

    signal getNewByte : std_logic := '1';
    -- when frame_count = 0; no data being sent, data will be sent when frame_count is set to 7 (frame size)
    signal frame_count : natural range 0 to frame_size - 1 := 0;
    signal frame_writing : std_logic := '0';


    constant disp_X_CON : natural := 84;
    constant disp_Y_CON : natural := 6;

    signal screen_sent : std_logic := '0';
    
    
    signal SPICLK_last_sig : std_logic := '0';

    -- BEGIN output signals
    signal SPIDO_sig : std_logic := '0';
    signal SPICLK_sig : std_logic := '0';
    signal data_command_sig : std_logic := '0';
    signal data_command_queue_sig : std_logic := '0';
    signal chip_enable_sig : std_logic := '0';

    signal SPIout_byte : std_logic_vector(7 downto 0) := (others => '0');
    -- END output signals
    

    -- X address is 0 to 83, Y address is 0 to 5
    -- LCD address is X * Y = max 503 = (84 * 6) - 1
    -- BEGIN display_mem_comp : Nokia5110_Memory signals
    signal disp_byte_X : natural range 0 to disp_X_CON - 1 := 0;
    signal disp_byte_Y : natural range 0 to disp_Y_CON - 1 := 0;
    signal disp_byte_out : std_logic_vector(7 downto 0) := (others => '0');
    -- END display_mem_comp : Nokia5110_Memory signals

    component Nokia5110_Memory
        port (
            CLK : in std_logic;     -- assumed to be 100Mhz
            RSTn : in std_logic;

            mem_addr_X : in natural range 0 to 83;
            mem_addr_Y : in natural range 0 to 5;
            display_byte : out std_logic_vector(7 downto 0)
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


    process(CLK, RSTn)
    begin
        if(RSTn = '0') then
            LCD_State <= init;
            init_step <= (others => '0');
            frame_count <= 0;
            frame_writing <= '0';
            screen_sent <= '0';

            disp_byte_X <= 0;
            disp_byte_Y <= 0;
            SPIout_byte <= (others => '0');

            SPIDO_sig <= '0';
            data_command_sig <= '0';
            data_command_queue_sig <= '0';
            chip_enable_sig <= '0';
        elsif(rising_edge(CLK)) then
            --if(screen_sent = '0' and enable = '1') then
            if(enable = '1') then
                SPICLK_last_sig <= SPICLK_sig;
                

                if(SPICLK_last_sig = '1' and SPICLK_sig = '0') then       -- Falling edge
                    if(frame_writing = '1') then
                        SPIDO_sig <= SPIout_byte(SPIout_byte'high);
                        SPIout_byte <= SPIout_byte(SPIout_byte'high - 1 downto 0) & '0';
                        chip_enable_sig <= '1';
                        data_command_sig <= data_command_queue_sig;
                        
                        if(frame_count = frame_size - 1)  then
                            frame_writing <= '0';
                        else
                            frame_count <= frame_count + 1;
                        end if;

                        
                    else
                        chip_enable_sig <= '0';
                    end if;
                end if;

                if(frame_writing = '0')then

                    frame_writing <= '1';
                    frame_count <= 0;

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
                                    SPIout_byte <= "00001100";      -- set display mode to normal
                                    init_step <= init_step + 1;
                                when others =>
                                    LCD_State <= data;
                            end case;
                        when data =>
                        
                            if(disp_byte_Y = disp_Y_CON - 1) then
                                disp_byte_Y <= 0;
                                if(disp_byte_X = disp_X_CON - 1) then
                                    disp_byte_X <= 0;
                                    screen_sent <= '1';
                                else
                                    disp_byte_X <= disp_byte_X + 1;
                                end if;
                            else
                                disp_byte_Y <= disp_byte_Y + 1;
                            end if;
                            data_command_queue_sig <= '1';
                            SPIout_byte <= disp_byte_out;
                        when others =>
                            null;
                    end case;
                end if;
            end if;
        end if;
    end process;

    SPICLK_sig <= CLK_SPI;

    RSTout <= RSTn;
    SPIDO <= SPIDO_sig;
    SPICLK <= SPICLK_sig;
    data_command <= data_command_sig;
    chip_enable <= not chip_enable_sig;     -- Nokie5110 SCE is active LOW, my brain is active HIGH

   -- architecture body
end architecture_Nokia5110_Driver;
