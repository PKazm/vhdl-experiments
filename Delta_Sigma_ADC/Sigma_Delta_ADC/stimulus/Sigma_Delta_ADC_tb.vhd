----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Dec  9 16:36:49 2019
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Sigma_Delta_ADC_tb.vhd
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

entity Sigma_Delta_ADC_tb is
end Sigma_Delta_ADC_tb;

architecture behavioral of Sigma_Delta_ADC_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    signal LVDS_sig : std_logic := '0';


    constant CON_SAMPLE_DIV : natural := 100;
    constant CON_DATA_BITS : natural := 8;

    -- BEGIN external signals
    signal data_out : std_logic_vector(CON_DATA_BITS - 1 downto 0) := (others => '0');
    signal data_ready : std_logic := '0';
    -- END external signals

    -- BEGIN internal signals
    signal sample_CLK_spy : std_logic := '0';
    signal analog_FF_spy : std_logic := '0';
    signal SMPL_CNT_MAX_spy  : natural := (2 ** CON_DATA_BITS) - 1;
    signal sample_counter_spy : natural range 0 to SMPL_CNT_MAX_spy := 0;
    signal pwm_quantized_value_spy : unsigned(CON_DATA_BITS - 1 downto 0);
    signal pulse_accumulator_spy : unsigned(CON_DATA_BITS - 1 downto 0);
    -- END internal signals

    component Sigma_Delta_LVDS_ADC
        generic (
            g_sample_div : natural;
            g_data_bits : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            LVDS_in : in std_logic;

            -- Outputs
            LVDS_PADN_feedback : out std_logic;
            Data_out : out std_logic_vector(7 downto 0);
            Data_Ready : out std_logic

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

    -- Instantiate Unit Under Test:  Sigma_Delta_LVDS_ADC
    Sigma_Delta_LVDS_ADC_0 : Sigma_Delta_LVDS_ADC
        generic map(
            g_sample_div => CON_SAMPLE_DIV,
            g_data_bits => CON_DATA_BITS
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            LVDS_in => LVDS_sig,

            -- Outputs
            LVDS_PADN_feedback =>  open,
            Data_out => data_out,
            Data_Ready =>  data_ready

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("Sigma_Delta_LVDS_ADC_0/sample_CLK", "sample_CLK_spy", 1, -1);
        init_signal_spy("Sigma_Delta_LVDS_ADC_0/analog_FF", "analog_FF_spy", 1, -1);
        init_signal_spy("Sigma_Delta_LVDS_ADC_0/SMPL_CNT_MAX", "SMPL_CNT_MAX_spy", 1, -1);
        init_signal_spy("Sigma_Delta_LVDS_ADC_0/sample_counter", "sample_counter_spy", 1, -1);
        init_signal_spy("Sigma_Delta_LVDS_ADC_0/pwm_quantized_value", "pwm_quantized_value_spy", 1, -1);
        init_signal_spy("Sigma_Delta_LVDS_ADC_0/pulse_accumulator", "pulse_accumulator_spy", 1, -1);
        wait;
    end process;

    process
    begin
        -- this should give a frequency that is out of phase with the sample frequency
        -- negative CON_SAMPLE_DIV * 50 gives shorter period. positive gives longer period
        -- the pwm values will change "randomly" over time as a result. (its good enough for now)
        wait for ( SYSCLK_PERIOD * (CON_SAMPLE_DIV * (2 ** CON_DATA_BITS) + (CON_SAMPLE_DIV * 50)));

        LVDS_sig <= not LVDS_sig;
    end process;

end behavioral;

