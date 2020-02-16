----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sat Feb  8 19:10:46 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_tb.vhd
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

entity FFT_tb is
end FFT_tb;

architecture behavioral of FFT_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    signal setup_done : std_logic := '0';


    constant DATA_WIDTH : natural := 8;
    constant SAMPLES_EXP : natural := 5;
    constant SAMPLE_CNT : natural := (2**SAMPLES_EXP);


    -- in
    signal data_in : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal data_in_ready : std_logic;
    -- in
    -- out
    signal data_out_ready : std_logic;
    -- out

    -- spies
    signal data_in_ready_last_spy : std_logic;
    signal data_valid_spy : std_logic;

    type time_sample_mem is array (SAMPLE_CNT - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal time_samples_spy : time_sample_mem;
    signal time_samples_decomp_spy : time_sample_mem;
    -- spies

    component FFT
        generic (
            g_data_width : natural;
            g_samples_exp : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            data_in_ready : in std_logic;

            -- Outputs
            data_out_ready : out std_logic

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

    -- Instantiate Unit Under Test:  FFT
    FFT_0 : FFT
        generic map(
            g_data_width => DATA_WIDTH,
            g_samples_exp => SAMPLES_EXP
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            data_in => data_in,
            data_in_ready => data_in_ready,

            -- Outputs
            data_out_ready => data_out_ready

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("FFT_0/time_samples", "time_samples_spy", 1, -1);
        init_signal_spy("FFT_0/time_samples_decomp", "time_samples_decomp_spy", 1, -1);
        init_signal_spy("FFT_0/data_in_ready_last", "data_in_ready_last_spy", 1, -1);
        init_signal_spy("FFT_0/data_valid", "data_valid_spy", 1, -1);
        wait;
    end process;

    THE_STUFF : process
        variable seed1, seed2: positive := 1;
        variable rand : real;
        variable range_of_rand : real := (2.0 ** DATA_WIDTH);
    begin
        data_in <= (others => '0');
        data_in_ready <= '0';

        wait until (NSYSRESET = '1');

        --loop
        --    seed1 := seed1 + 1;
        --    seed2 := seed2 + 2;
        --    uniform(seed1, seed2, rand);
        --    data_in <= std_logic_vector(to_unsigned(integer(floor(rand * range_of_rand)), data_in'length));
        --    data_in_ready <= '1';
        --
        --    wait for ( SYSCLK_PERIOD * 1);
        --
        --    data_in_ready <= '0';
        --
        --    wait for ( SYSCLK_PERIOD * 1);
        --end loop;

        for i in 0 to SAMPLE_CNT - 1 loop
            data_in <= std_logic_vector(to_unsigned(i + 1, data_in'length));
            data_in_ready <= '1';
        
            wait for ( SYSCLK_PERIOD * 4);
        
            data_in_ready <= '0';
        
            wait for ( SYSCLK_PERIOD * 4);
        end loop;

        wait;
    end process;

end behavioral;

