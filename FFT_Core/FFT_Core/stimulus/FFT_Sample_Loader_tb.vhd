----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Fri Feb 21 16:51:42 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Sample_Loader_tb.vhd
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

use work.FFT_package.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity FFT_Sample_Loader_tb is
end FFT_Sample_Loader_tb;

architecture behavioral of FFT_Sample_Loader_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant SYNC_INPUT : natural := 0;

    signal input_w_en : std_logic;
    signal input_w_dat : std_logic_vector(SAMPLE_WIDTH_EXT - 1 downto 0);
    signal input_w_ready : std_logic;

    signal ram_stable : std_logic;
    signal ram_ready : std_logic;
    signal ram_valid : std_logic;
    signal ram_w_en : w_en_array_type;
    signal ram_adr : adr_array_type;
    signal ram_dat_w : ram_dat_array_type;
    signal ram_dat_r : ram_dat_array_type;


    -- signal spies
    type load_states is (sreset, paused, ready, writing, incr);
    signal load_state_spy : load_states;
    signal load_state_next_spy : load_states;
    signal input_w_en_sig_spy : std_logic;
    signal input_w_en_last_spy : std_logic;
    signal input_w_dat_sig_spy : std_logic_vector(SAMPLE_WIDTH_EXT - 1 downto 0);
    signal input_w_ready_sig_spy : std_logic;
    -- signal spies

    component FFT_Sample_Loader
        generic (
            g_sync_input : natural
        );
        -- ports
        port(
            PCLK : in std_logic;
            RSTn : in std_logic;
            -- connections to sample generator
            input_w_en : in std_logic;
            input_w_dat : in std_logic_vector(SAMPLE_WIDTH_EXT - 1 downto 0);
            input_w_ready : out std_logic;
            -- connections to sample generator


            -- connections to FFT RAM block
            ram_stable : in std_logic;
            ram_ready : in std_logic;
            ram_valid : out std_logic;
            ram_w_en : out w_en_array_type;
            ram_adr : out adr_array_type;
            ram_dat_w : out ram_dat_array_type;
            ram_dat_r : in ram_dat_array_type
            -- connections to FFT RAM block

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

    -- Instantiate Unit Under Test:  FFT_Sample_Loader
    FFT_Sample_Loader_0 : FFT_Sample_Loader
        generic map(
            g_sync_input => SYNC_INPUT
        )
        -- port map
        port map( 
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            -- connections to sample generator
            input_w_en => input_w_en,
            input_w_dat => input_w_dat,

            input_w_ready => input_w_ready,
            -- connections to sample generator


            -- connections to FFT RAM block
            ram_stable => ram_stable,
            ram_ready => ram_ready,
            ram_valid => ram_valid,
            ram_w_en => ram_w_en,
            ram_adr => ram_adr,
            ram_dat_w => ram_dat_w,
            ram_dat_r => ram_dat_r

        );

    spy_process : process
    begin
        init_signal_spy("FFT_Sample_Loader_0/load_state", "load_state_spy", 1, -1);
        init_signal_spy("FFT_Sample_Loader_0/load_state_next", "load_state_next_spy", 1, -1);
        init_signal_spy("FFT_Sample_Loader_0/input_w_en_sig", "input_w_en_sig_spy", 1, -1);
        init_signal_spy("FFT_Sample_Loader_0/input_w_en_last", "input_w_en_last_spy", 1, -1);
        init_signal_spy("FFT_Sample_Loader_0/input_w_dat_sig", "input_w_dat_sig_spy", 1, -1);
        init_signal_spy("FFT_Sample_Loader_0/input_w_ready_sig", "input_w_ready_sig_spy", 1, -1);
        wait;
    end process;

    process
    begin
        input_w_en <= '0';
        input_w_dat <= (others => '0');
        ram_stable <= '0';
        ram_ready <= '0';
        ram_dat_r <= (others => (others =>'0'));
        
        wait until (NSYSRESET = '1');

        input_w_en <= '1';
        input_w_dat <= X"55";

        wait for (SYSCLK_PERIOD * 1);

        assert (ram_dat_w(0) = "00" & X"0000") report "RAM not stable error";

        ram_stable <= '1';

        wait for (SYSCLK_PERIOD * 1);

        assert (ram_dat_w(0) = "00" & X"0000") report "RAM not ready error";

        ram_ready <= '1';

        input_w_en <= '0';

        for i in 0 to SAMPLE_CNT loop
            
            wait until (input_w_ready = '1');
            input_w_en <= '1';
            input_w_dat <= std_logic_vector(to_unsigned(i, input_w_dat'length));
            wait until (input_w_en_sig_spy = '1');
            wait for (SYSCLK_PERIOD * 1);

            assert (ram_adr(0) = std_logic_vector(to_unsigned(i, ram_adr(0)'length))) report "RAM address error";
            assert (ram_dat_w(0) = IMAG_INIT & "0" & input_w_dat) report "RAM write error";

            
            wait until (input_w_ready = '0');
            input_w_en <= '0';

        end loop;



        wait;
    end process;

end behavioral;

