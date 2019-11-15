--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Delta_Sigma_tb.vhd
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
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity Delta_Sigma_tb is
end Delta_Sigma_tb;

architecture behavioral of Delta_Sigma_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ
    constant g_data_bits : natural := 12;
    constant g_sample_div : natural := 256;

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    signal PCLK : std_logic := '0';
    signal CLK_OSample : std_logic := '0';
    signal APB_PSEL : std_logic := '0';
    signal APB_PENABLE : std_logic := '0';
    signal APB_PWDATA : std_logic_vector(7 downto 0) := (others => '0');
    signal APB_PWRITE : std_logic := '0';
    signal APB_PRDATA : std_logic_vector(7 downto 0) := (others => '0');
    signal INT : std_logic := '0';
    signal analog_FF : std_logic := '0';
    signal pwm_quantized_value : unsigned(g_data_bits - 1 downto 0) := (others => '0');
    signal pwm_quantized_counter : unsigned(g_data_bits - 1 downto 0) := (others => '0');
    signal pwm_counter : natural range 0 to g_sample_div - 1 := 0;
    signal pwm_interrupt : std_logic := '0';
    signal pwm_interrupt_last : std_logic := '0';
    signal pixel_sig : std_logic_vector(31 downto 0) := (others => '0');
    signal pixels_ready : std_logic := '0';
    signal DSC_ctrl_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data0_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data1_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data2_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data3_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');

    component Delta_Sigma_Design
        -- ports
        port( 
            -- Inputs
            DEVRST_N : in std_logic;
            PADP : in std_logic;
            PADN : in std_logic;

            -- Outputs
            Board_J11 : out std_logic;
            Board_J9 : out std_logic;
            Board_J10 : out std_logic;
            ADC_out : out std_logic;
            ADC_feedback : out std_logic;
            Board_LEDs : out std_logic_vector(7 downto 0);
            Board_J7 : out std_logic_vector(4 downto 0)

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

    -- Instantiate Unit Under Test:  Delta_Sigma_Design
    Delta_Sigma_Design_0 : Delta_Sigma_Design
        -- port map
        port map( 
            -- Inputs
            DEVRST_N => NSYSRESET,
            PADP => '1',
            PADN => '0',

            -- Outputs
            Board_J11 =>  open,
            Board_J9 =>  open,
            Board_J10 =>  open,
            ADC_out =>  open,
            ADC_feedback =>  open,
            Board_LEDs => open,
            Board_J7 => open

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/PCLK", "PCLK", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/CLK_OSample", "CLK_OSample", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/PSEL", "APB_PSEL", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/PENABLE", "APB_PENABLE", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/PWDATA", "APB_PWDATA", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/PWRITE", "APB_PWRITE", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/PRDATA", "APB_PRDATA", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/INT", "INT", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/analog_FF", "analog_FF", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pwm_quantized_value", "pwm_quantized_value", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pwm_quantized_counter", "pwm_quantized_counter", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pwm_counter", "pwm_counter", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pwm_interrupt", "pwm_interrupt", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pwm_interrupt_last", "pwm_interrupt_last", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pixel_sig", "pixel_sig", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/pixels_ready", "pixels_ready", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/DSC_ctrl_reg", "DSC_ctrl_reg", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/DSC_data0_pixels_reg", "DSC_data0_pixels_reg", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/DSC_data1_pixels_reg", "DSC_data1_pixels_reg", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/DSC_data2_pixels_reg", "DSC_data2_pixels_reg", 1, -1);
        init_signal_spy("Delta_Sigma_Design_0/Delta_Sigma_Converter_0/DSC_data3_pixels_reg", "DSC_data3_pixels_reg", 1, -1);
        wait;
    end process;

    drive_process : process
    begin
        if(rising_edge(NSYSRESET)) then

            --signal_force("Nokia5110_Driver_Block_SD_0/Nokia5110_Driver_0/timer_indicator_sig", "1", 0 ns, deposit, 100 ns, 1);
        end if;
        wait;
    end process;

end behavioral;

