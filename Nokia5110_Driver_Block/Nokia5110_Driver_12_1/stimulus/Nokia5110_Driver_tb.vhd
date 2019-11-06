--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Nokia5110_Driver_tb.vhd
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


library ieee;
use ieee.std_logic_1164.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity Nokia5110_Driver_tb is
end Nokia5110_Driver_tb;

architecture behavioral of Nokia5110_Driver_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ
    --constant SPICLK_PERIOD : time := 500 ns;    -- 2MHz

    signal SYSCLK : std_logic := '0';
    --signal SPICLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    signal data_command : std_logic;
    signal chip_enable : std_logic;
    signal SPIDO : std_logic;
    signal SPICLK : std_logic;
    signal spy_timer_indicator_sig : std_logic;
    signal spy_frame_start : std_logic;
    signal spy_frame_get_bit : std_logic;
    signal spy_screen_send : std_logic;
    signal spy_screen_finished : std_logic;
    signal spy_SPIout_byte : std_logic_vector(7 downto 0);
    signal spy_uSRAM_B_ADDR_sig : std_logic_vector(8 downto 0);
    signal spy_uSRAM_B_DOUT_sig : std_logic_vector(7 downto 0);

    component Nokia5110_Driver_Block_SD
        -- ports
        port( 
            -- Inputs
            CLK : in std_logic;
            --CLK_SPI : in std_logic;
            RSTn : in std_logic;
            PADDR : in std_logic_vector(7 downto 0);
            PENABLE : in std_logic;
            PWRITE : in std_logic;
            PWDATA : in std_logic_vector(7 downto 0);
            PSEL : in std_logic;

            -- Outputs
            RSTout : out std_logic;
            driver_busy : out std_logic;
            SPIDO : out std_logic;
            SPICLK : out std_logic;
            data_command : out std_logic;
            chip_enable : out std_logic;
            PRDATA : out std_logic_vector(7 downto 0);
            PREADY : out std_logic;
            PSLVERR : out std_logic

            -- Inouts

        );
    end component;

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );
    --SPICLK <= not SPICLK after (SPICLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  Nokia5110_Driver_Block_SD
    Nokia5110_Driver_Block_SD_0 : Nokia5110_Driver_Block_SD
        -- port map
        port map( 
            -- Inputs
            CLK => SYSCLK,
            --CLK_SPI => SPICLK,
            RSTn => NSYSRESET,
            PADDR => (others=> '0'),
            PENABLE => '0',
            PWRITE => '0',
            PWDATA => (others=> '0'),
            PSEL => '0',

            -- Outputs
            RSTout =>  open,
            driver_busy =>  open,
            SPIDO => SPIDO,
            SPICLK => SPICLK,
            data_command => data_command,
            chip_enable => chip_enable,
            PRDATA => open,
            PREADY =>  open,
            PSLVERR =>  open

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/timer_indicator_sig", "spy_timer_indicator_sig", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/frame_start", "spy_frame_start", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/frame_get_bit", "spy_frame_get_bit", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/screen_send", "spy_screen_send", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/screen_finished", "spy_screen_finished", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/SPIout_byte", "spy_SPIout_byte", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/uSRAM_B_ADDR_sig", "spy_uSRAM_B_ADDR_sig", 1, -1);
        init_signal_spy("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/uSRAM_B_DOUT_sig", "spy_uSRAM_B_DOUT_sig", 1, -1);
        wait;
    end process;

    process
        variable driver_timer_indicator_sig_var : std_logic;
    begin
        wait for ( 10 us );

        signal_force("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/timer_indicator_sig", "1", 0 ns, deposit, 100 ns, 1);
        
        wait;
    end process;



end behavioral;

