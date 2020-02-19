----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Wed Dec 11 16:23:54 2019
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Averaging_Filter_tb.vhd
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
use ieee.math_real.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity Averaging_Filter_tb is
end Averaging_Filter_tb;

architecture behavioral of Averaging_Filter_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    
    constant CON_SAMPLE_EXP : natural := 2;
    constant CON_DATA_BITS : natural := 8;


    -- BEGIN external signals
    signal data_in : std_logic_vector(CON_DATA_BITS - 1 downto 0) := (others => '0');
    signal data_in_ready : std_logic := '0';

    signal data_out : std_logic_vector(CON_DATA_BITS - 1 downto 0) := (others => '0');
    signal data_out_ready : std_logic := '0';
    -- END external signals

    -- BEGIN internal signals
    type states is(idle, step1, step2, done);
    signal spy_filter_state : states;
    type mem_type is array (2 ** CON_SAMPLE_EXP - 1 downto 0) of unsigned (CON_DATA_BITS - 1 downto 0);
    signal spy_samples_mem : mem_type;
    signal spy_running_sum : unsigned(CON_DATA_BITS + CON_SAMPLE_EXP - 1 downto 0);
    signal spy_filtered_value : unsigned(CON_DATA_BITS - 1 downto 0);
    -- END internal signals


    component Averaging_Filter
        generic (
            g_sample_window_exp : natural;
            g_data_bits : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            Data_in_ready : in std_logic;
            Data_in : in std_logic_vector(7 downto 0);

            -- Outputs
            Data_out : out std_logic_vector(7 downto 0);
            Data_out_ready : out std_logic

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

    -- Instantiate Unit Under Test:  Averaging_Filter
    Averaging_Filter_0 : Averaging_Filter
        -- generic map
        generic map(
            g_sample_window_exp => CON_SAMPLE_EXP,
            g_data_bits => CON_DATA_BITS
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            Data_in_ready => data_in_ready,
            Data_in => data_in,

            -- Outputs
            Data_out => data_out,
            Data_out_ready =>  data_out_ready

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("Averaging_Filter_0/filter_state", "spy_filter_state", 1, -1);
        init_signal_spy("Averaging_Filter_0/samples_mem", "spy_samples_mem", 1, -1);
        init_signal_spy("Averaging_Filter_0/running_sum", "spy_running_sum", 1, -1);
        init_signal_spy("Averaging_Filter_0/filtered_value", "spy_filtered_value", 1, -1);
        wait;
    end process;

    process
        variable seed1, seed2: positive := 1;
        variable rand : real;
        variable range_of_rand : real := (2.0 ** CON_DATA_BITS);
    begin

        data_in_ready <= '0';
		seed1 := seed1 + 1;
		seed2 := seed2 + 2;
        uniform(seed1, seed2, rand);
        data_in <= std_logic_vector(to_unsigned(integer(floor(rand * range_of_rand)), data_in'length));

        wait for ( SYSCLK_PERIOD * 1);

        data_in_ready <= '1';

        wait for ( SYSCLK_PERIOD * 2 ** CON_DATA_BITS );

    end process;

end behavioral;

