----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sat Feb 22 19:54:47 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Butterfly_HW_MATHDSP_tb.vhd
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
use ieee.math_real.uniform;
use ieee.math_real.floor;

use work.FFT_package.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity FFT_Butterfly_HW_MATHDSP_tb is
end FFT_Butterfly_HW_MATHDSP_tb;

architecture behavioral of FFT_Butterfly_HW_MATHDSP_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    signal do_calc : std_logic;
    signal twiddle_cos_real : std_logic_vector(8 downto 0);
    signal twiddle_sin_imag : std_logic_vector(8 downto 0);
    signal twiddle_sin_imag_1comp : std_logic_vector(8 downto 0);
    signal real_a_in : std_logic_vector(8 downto 0);
    signal imag_a_in : std_logic_vector(8 downto 0);
    signal real_b_in : std_logic_vector(8 downto 0);
    signal imag_b_in : std_logic_vector(8 downto 0);
    signal calc_done : std_logic;
    signal A_done : std_logic;
    signal B_done : std_logic;
    signal real_a_out : std_logic_vector(8 downto 0);
    signal imag_a_out : std_logic_vector(8 downto 0);
    signal real_b_out : std_logic_vector(8 downto 0);
    signal imag_b_out : std_logic_vector(8 downto 0);

    component FFT_Butterfly_HW_MATHDSP
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            do_calc : in std_logic;
            twiddle_cos_real : in std_logic_vector(8 downto 0);
            twiddle_sin_imag : in std_logic_vector(8 downto 0);
            twiddle_sin_imag_1comp : in std_logic_vector(8 downto 0);
            real_a_in : in std_logic_vector(8 downto 0);
            imag_a_in : in std_logic_vector(8 downto 0);
            real_b_in : in std_logic_vector(8 downto 0);
            imag_b_in : in std_logic_vector(8 downto 0);

            -- Outputs
            calc_done : out std_logic;
            A_done : out std_logic;
            B_done : out std_logic;
            real_a_out : out std_logic_vector(8 downto 0);
            imag_a_out : out std_logic_vector(8 downto 0);
            real_b_out : out std_logic_vector(8 downto 0);
            imag_b_out : out std_logic_vector(8 downto 0)

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

    -- Instantiate Unit Under Test:  FFT_Butterfly_HW_MATHDSP
    FFT_Butterfly_HW_MATHDSP_0 : FFT_Butterfly_HW_MATHDSP
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            do_calc => do_calc,
            twiddle_cos_real => twiddle_cos_real,
            twiddle_sin_imag => twiddle_sin_imag,
            twiddle_sin_imag_1comp => twiddle_sin_imag_1comp,
            real_a_in => real_a_in,
            imag_a_in => imag_a_in,
            real_b_in => real_b_in,
            imag_b_in => imag_b_in,

            -- Outputs
            calc_done =>  calc_done,
            A_done =>  A_done,
            B_done =>  B_done,
            real_a_out => real_a_out,
            imag_a_out => imag_a_out,
            real_b_out => real_b_out,
            imag_b_out => imag_b_out

            -- Inouts

        );

    spy_process : process
    begin
        --init_signal_spy("FFT_Sample_Loader_0/load_state", "load_state_spy", 1, -1);
        --init_signal_spy("FFT_Sample_Loader_0/load_state_next", "load_state_next_spy", 1, -1);
        --init_signal_spy("FFT_Sample_Loader_0/input_w_en_sig", "input_w_en_sig_spy", 1, -1);
        --init_signal_spy("FFT_Sample_Loader_0/input_w_en_last", "input_w_en_last_spy", 1, -1);
        --init_signal_spy("FFT_Sample_Loader_0/input_w_dat_sig", "input_w_dat_sig_spy", 1, -1);
        --init_signal_spy("FFT_Sample_Loader_0/input_w_ready_sig", "input_w_ready_sig_spy", 1, -1);
        wait;
    end process;


    twiddle_sin_imag_1comp <= BIT_REV_FUNC(twiddle_sin_imag);

    process
        variable temp_real_var : integer;
        variable temp_imag_var : integer;
        variable real_a_out_var : integer;
        variable imag_a_out_var : integer;
        variable real_b_out_var : integer;
        variable imag_b_out_var : integer;

        variable seed1 : positive;
        variable seed2 : positive;
        variable x1 : real;
        variable x2 : real;
    begin
        do_calc <= '0';
        twiddle_cos_real <= (others => '0');
        twiddle_sin_imag <= (others => '0');
        real_a_in <= (others => '0');
        imag_a_in <= (others => '0');
        real_b_in <= (others => '0');
        imag_b_in <= (others => '0');

        wait until (NSYSRESET = '1');

        for i in 0 to 10 loop
            seed1 := (i+1);
            seed2 := (i+1) * 2;
            uniform(seed1, seed2, x1);
            uniform(seed2, seed1, x2);

            twiddle_cos_real <= std_logic_vector(to_signed(integer(floor(x1 * 2.0**8)), twiddle_cos_real'length));
            twiddle_sin_imag <= std_logic_vector(to_signed(integer(floor(x2 * 2.0**8)), twiddle_sin_imag'length));
            real_a_in <= std_logic_vector(to_signed(integer(floor(x1 * 2.0**9)), real_a_in'length));
            imag_a_in <= std_logic_vector(to_signed(integer(floor(x1 * 2.0**10)), imag_a_in'length));
            real_b_in <= std_logic_vector(to_signed(integer(floor(x2 * 2.0**9)), real_b_in'length));
            imag_b_in <= std_logic_vector(to_signed(integer(floor(x2 * 2.0**10)), imag_b_in'length));

            temp_real_var := to_integer(signed(real_a_in)) * to_integer(signed(twiddle_cos_real)) + to_integer(signed(imag_a_in)) * to_integer(signed(twiddle_sin_imag));
            temp_imag_var := to_integer(signed(imag_a_in)) * to_integer(signed(twiddle_cos_real)) + to_integer(signed(real_a_in)) * (-1) * to_integer(signed(twiddle_sin_imag));

            temp_real_var := temp_real_var / (2**8);
            temp_imag_var := temp_real_var / (2**8);

            real_a_out_var := (to_integer(signed(real_b_in)) - temp_real_var) / 2;
            imag_a_out_var := (to_integer(signed(imag_b_in)) - temp_imag_var) / 2;
            real_b_out_var := (to_integer(signed(real_b_in)) + temp_real_var) / 2;
            imag_b_out_var := (to_integer(signed(imag_b_in)) + temp_imag_var) / 2;

            
            wait for (SYSCLK_PERIOD * 1);

            assert (real_a_out = std_logic_vector(to_signed(real_a_out_var, real_a_out'length))) report "result error: real_a_out; " & integer'image(to_integer(signed(real_a_out))) & " /= " & integer'image(real_a_out_var);
            assert (imag_a_out = std_logic_vector(to_signed(imag_a_out_var, imag_a_out'length))) report "result error: imag_a_out; " & integer'image(to_integer(signed(imag_a_out))) & " /= " & integer'image(imag_a_out_var);
            assert (real_b_out = std_logic_vector(to_signed(real_b_out_var, real_b_out'length))) report "result error: real_b_out; " & integer'image(to_integer(signed(real_b_out))) & " /= " & integer'image(real_b_out_var);
            assert (imag_b_out = std_logic_vector(to_signed(imag_b_out_var, imag_b_out'length))) report "result error: imag_b_out; " & integer'image(to_integer(signed(imag_b_out))) & " /= " & integer'image(imag_b_out_var);
            wait for (SYSCLK_PERIOD * 1);
        end loop;

        wait;
    end process;

end behavioral;

