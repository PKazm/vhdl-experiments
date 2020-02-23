--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Butterfly_HW_MATHDSP.vhd
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

entity FFT_Butterfly_HW_MATHDSP is
generic (
    g_buffer_output : natural := 0
);
port (

    PCLK : in std_logic;
    RSTn : in std_logic;

    do_calc : in std_logic;
    calc_done : out std_logic;

    A_done : out std_logic;
    B_done : out std_logic;

    twiddle_cos_real : in std_logic_vector(8 downto 0);
    twiddle_sin_imag : in std_logic_vector(8 downto 0);
    twiddle_sin_imag_1comp : in std_logic_vector(8 downto 0);

    --Complex_A_in : in std_logic_vector(17 downto 0);
	real_a_in : in std_logic_vector(8 downto 0);
	imag_a_in : in std_logic_vector(8 downto 0);
    --Complex_B_in : in std_logic_vector(17 downto 0);
	real_b_in : in std_logic_vector(8 downto 0);
	imag_b_in : in std_logic_vector(8 downto 0);

    --Complex_A_out : out std_logic_vector(17 downto 0);
	real_a_out : out std_logic_vector(8 downto 0);
	imag_a_out : out std_logic_vector(8 downto 0);
    --Complex_B_out : out std_logic_vector(17 downto 0)
	real_b_out : out std_logic_vector(8 downto 0);
	imag_b_out : out std_logic_vector(8 downto 0)
);
end FFT_Butterfly_HW_MATHDSP;
architecture architecture_FFT_Butterfly_HW_MATHDSP of FFT_Butterfly_HW_MATHDSP is

    signal do_calc_sig : std_logic;
    signal do_calc_last : std_logic;
    signal calc_done_sig : std_logic;

    signal twiddle_cos_real_sig : signed(8 downto 0);
    signal twiddle_sin_imag_sig : signed(8 downto 0);
    signal twiddle_sin_imag_1comp_sig : signed(8 downto 0);

    signal real_a_in_sig : signed(8 downto 0);
    signal imag_a_in_sig : signed(8 downto 0);
    signal real_b_in_sig : signed(8 downto 0);
    signal imag_b_in_sig : signed(8 downto 0);

    signal real_a_1comp_extend : signed(34 downto 0);

    signal temp_real : signed(17 downto 0);
    signal temp_real_trunc : signed(8 downto 0);
    signal temp_imag : signed(34 downto 0);
    signal temp_imag_trunc : signed(8 downto 0);

    signal real_a_out_sum : std_logic_vector(9 downto 0);
    signal imag_a_out_sum : std_logic_vector(9 downto 0);
    signal real_b_out_sum : std_logic_vector(9 downto 0);
    signal imag_b_out_sum : std_logic_vector(9 downto 0);

    signal real_a_out_sig : std_logic_vector(8 downto 0);
    signal imag_a_out_sig : std_logic_vector(8 downto 0);
    signal real_b_out_sig : std_logic_vector(8 downto 0);
    signal imag_b_out_sig : std_logic_vector(8 downto 0);

begin

    do_calc_sig <= do_calc;
    calc_done <= calc_done_sig;

    twiddle_cos_real_sig <= signed(twiddle_cos_real);
    twiddle_sin_imag_sig <= signed(twiddle_sin_imag);
    twiddle_sin_imag_1comp_sig <= signed(twiddle_sin_imag_1comp);

    real_a_in_sig <= signed(real_a_in);
    imag_a_in_sig <= signed(imag_a_in);
    real_b_in_sig <= signed(real_b_in);
    imag_b_in_sig <= signed(imag_b_in);

    temp_real <= (real_a_in_sig * signed(twiddle_cos_real_sig)) + (imag_a_in_sig * signed(twiddle_sin_imag_sig));
    -- real_a_1comp_extend is necessary as 2's complement of twiddle_sine is spread out across the MATH block
    real_a_1comp_extend <= (34 downto 9 => real_a_in_sig(8), 8 downto 0 => real_a_in_sig, others => '0');
    temp_imag <= (imag_a_in_sig * signed(twiddle_cos_real_sig)) + (real_a_in_sig * signed(twiddle_sin_imag_1comp_sig)) + real_a_1comp_extend;
    temp_real_trunc <= temp_real(17) & temp_real(15 downto 15 - temp_real_trunc'length + 2);
    temp_imag_trunc <= temp_imag(34) & temp_imag(15 downto 15 - temp_imag_trunc'length + 2);
    
    real_a_out_sum <= std_logic_vector((real_b_in_sig(real_b_in_sig'high) & real_b_in_sig) - (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    imag_a_out_sum <= std_logic_vector((imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig) - (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    real_b_out_sum <= std_logic_vector((real_b_in_sig(real_b_in_sig'high) & real_b_in_sig) + (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    imag_b_out_sum <= std_logic_vector((imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig) + (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    

    gen_buffer_output_no : if(g_buffer_output = 0) generate


        real_a_out_sig <= real_a_out_sum(9 downto 1);
        imag_a_out_sig <= imag_a_out_sum(9 downto 1);
        real_b_out_sig <= real_b_out_sum(9 downto 1);
        imag_b_out_sig <= imag_b_out_sum(9 downto 1);

        A_done <= '1';
        B_done <= '1';
    end generate gen_buffer_output_no;

    --=========================================================================

    gen_buffer_output_yes : if(g_buffer_output /= 0) generate
        process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                real_a_out_sig <= (others => '0');
                imag_a_out_sig <= (others => '0');
                real_b_out_sig <= (others => '0');
                imag_b_out_sig <= (others => '0');
                do_calc_last <= '0';
                A_done <= '0';
                B_done <= '0';
            elsif(rising_edge(PCLK)) then
                do_calc_last <= do_calc_sig;

                if(do_calc_last = '0' and do_calc_sig = '1') then
                    real_a_out_sig <= real_a_out_sum(9 downto 1);
                    imag_a_out_sig <= imag_a_out_sum(9 downto 1);
                    real_b_out_sig <= real_b_out_sum(9 downto 1);
                    imag_b_out_sig <= imag_b_out_sum(9 downto 1);

                    A_done <= '1';
                    B_done <= '1';
                elsif(do_calc_sig = '0') then
                    A_done <= '0';
                    B_done <= '0';
                end if;
            end if;
        end process;
    end generate gen_buffer_output_yes;


    real_a_out <= real_a_out_sig;
    imag_a_out <= imag_a_out_sig;
    real_b_out <= real_b_out_sig;
    imag_b_out <= imag_b_out_sig;

    calc_done_sig <= A_done and B_done;
   -- architecture body
end architecture_FFT_Butterfly_HW_MATHDSP;
