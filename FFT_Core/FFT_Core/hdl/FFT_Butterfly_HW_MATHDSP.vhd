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

library smartfusion2;
use smartfusion2.all;

entity FFT_Butterfly_HW_MATHDSP is
generic (
    g_adr_width : natural := 8;
    g_pipeline : natural := 1
);
port (

    PCLK : in std_logic;
    RSTn : in std_logic;

    do_calc : in std_logic;
    calc_done : out std_logic;

    twiddle_cos_real : in std_logic_vector(8 downto 0);
    twiddle_sin_imag : in std_logic_vector(8 downto 0);
    twiddle_sin_imag_1comp : in std_logic_vector(8 downto 0);

    adr_a_in : in std_logic_vector(g_adr_width - 1 downto 0);
    adr_a_out : out std_logic_vector(g_adr_width - 1 downto 0);
    adr_b_in : in std_logic_vector(g_adr_width - 1 downto 0);
    adr_b_out : out std_logic_vector(g_adr_width - 1 downto 0);
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

    -- pipeline relevant stuff
    signal do_calc_sig : std_logic;
    signal calc_done_sig : std_logic;

    signal do_calc_pipe1 : std_logic;

    signal adr_a_pipe1 : std_logic_vector(g_adr_width - 1 downto 0);
    signal adr_b_pipe1 : std_logic_vector(g_adr_width - 1 downto 0);
    signal real_a_pipe1 : std_logic_vector(8 downto 0);
    signal imag_a_pipe1 : std_logic_vector(8 downto 0);
    signal real_b_pipe1 : std_logic_vector(8 downto 0);
    signal imag_b_pipe1 : std_logic_vector(8 downto 0);
    -- pipeline relevant stuff


    signal twiddle_cos_real_sig : std_logic_vector(8 downto 0);
    signal twiddle_sin_imag_sig : std_logic_vector(8 downto 0);
    signal twiddle_sin_imag_1comp_sig : std_logic_vector(8 downto 0);

    signal adr_a_in_sig : std_logic_vector(g_adr_width - 1 downto 0);
    signal adr_b_in_sig : std_logic_vector(g_adr_width - 1 downto 0);

    signal real_a_in_sig : std_logic_vector(8 downto 0);
    signal imag_a_in_sig : std_logic_vector(8 downto 0);
    signal real_b_in_sig : std_logic_vector(8 downto 0);
    signal imag_b_in_sig : std_logic_vector(8 downto 0);

    signal real_a_1comp_extend : std_logic_vector(34 downto 0);
    --signal real_a_1comp_extend : signed(43 downto 0);

    signal temp_real : std_logic_vector(34 downto 0);
    signal temp_real_trunc : signed(8 downto 0);
    --signal temp_imag : signed(34 downto 0);
    signal temp_imag : std_logic_vector(34 downto 0);
    signal temp_imag_trunc : signed(8 downto 0);

    signal real_b_to_arith : std_logic_vector(9 downto 0);
    signal imag_b_to_arith : std_logic_vector(9 downto 0);

    signal adr_a_out_sig : std_logic_vector(g_adr_width - 1 downto 0);
    signal adr_b_out_sig : std_logic_vector(g_adr_width - 1 downto 0);

    signal real_a_out_sum : std_logic_vector(9 downto 0);
    signal imag_a_out_sum : std_logic_vector(9 downto 0);
    signal real_b_out_sum : std_logic_vector(9 downto 0);
    signal imag_b_out_sum : std_logic_vector(9 downto 0);

    signal real_a_out_sig : std_logic_vector(8 downto 0);
    signal imag_a_out_sig : std_logic_vector(8 downto 0);
    signal real_b_out_sig : std_logic_vector(8 downto 0);
    signal imag_b_out_sig : std_logic_vector(8 downto 0);

    component HARD_MULT_ADDSUB_C0
        -- Port list
        port(
            -- Inputs
            A0    : in  std_logic_vector(8 downto 0);
            A1    : in  std_logic_vector(8 downto 0);
            B0    : in  std_logic_vector(8 downto 0);
            B1    : in  std_logic_vector(8 downto 0);
            C     : in  std_logic_vector(34 downto 0);
            -- Outputs
            CDOUT : out std_logic_vector(43 downto 0);
            P     : out std_logic_vector(34 downto 0)
            );
    end component;

begin

    -- real
    HARD_MULT_ADDSUB_C0_0 : HARD_MULT_ADDSUB_C0
    port map( 
        -- Inputs
        A0    => imag_a_in_sig,
        B0    => twiddle_cos_real_sig,
        A1    => real_a_in_sig,
        B1    => twiddle_sin_imag_sig,
        C     => (others => '0'),
        -- Outputs
        CDOUT => OPEN,
        P     => temp_real
        );

    -- imag
    HARD_MULT_ADDSUB_C0_1 : HARD_MULT_ADDSUB_C0
    port map( 
        -- Inputs
        A0    => real_a_in_sig,
        B0    => twiddle_cos_real_sig,
        A1    => imag_a_in_sig,
        B1    => twiddle_sin_imag_1comp_sig,
        C     => real_a_1comp_extend,
        -- Outputs
        CDOUT => OPEN,
        P     => temp_imag
        );

    do_calc_sig <= do_calc;
    calc_done <= calc_done_sig;

    twiddle_cos_real_sig <= twiddle_cos_real;
    twiddle_sin_imag_sig <= twiddle_sin_imag;
    twiddle_sin_imag_1comp_sig <= twiddle_sin_imag_1comp;

    adr_a_in_sig <= adr_a_in;
    adr_b_in_sig <= adr_b_in;

    real_a_in_sig <= real_a_in;
    imag_a_in_sig <= imag_a_in;
    real_b_in_sig <= real_b_in;
    imag_b_in_sig <= imag_b_in;

    --temp_real <= (real_a_in_sig * signed(twiddle_cos_real_sig)) + (imag_a_in_sig * signed(twiddle_sin_imag_sig));
    -- real_a_1comp_extend is necessary as 2's complement of twiddle_sine is spread out across the MATH block
    real_a_1comp_extend <= (real_a_1comp_extend'high downto 9 => real_a_in_sig(8), 8 downto 0 => real_a_in_sig, others => '0');
    --real_a_1comp_extend <= (18 downto 10 => real_a_in_sig, others => '0');
    --temp_imag <= (imag_a_in_sig * signed(twiddle_cos_real_sig)) + (real_a_in_sig * signed(twiddle_sin_imag_1comp_sig)) + real_a_1comp_extend;
    --temp_real_trunc <= temp_real(17) & temp_real(16 downto 16 - temp_real_trunc'length + 2);
    --temp_imag_trunc <= temp_imag(34) & temp_imag(16 downto 16 - temp_imag_trunc'length + 2);
    
    real_a_out_sum <= std_logic_vector(signed(real_b_to_arith) - (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    imag_a_out_sum <= std_logic_vector(signed(imag_b_to_arith) - (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    real_b_out_sum <= std_logic_vector(signed(real_b_to_arith) + (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    imag_b_out_sum <= std_logic_vector(signed(imag_b_to_arith) + (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    

    gen_buffer_output_no : if(g_pipeline = 0) generate
        temp_real_trunc <= signed(temp_real(temp_real'high) & temp_real(16 downto 16 - temp_real_trunc'length + 2));
        temp_imag_trunc <= signed(temp_imag(temp_imag'high) & temp_imag(16 downto 16 - temp_imag_trunc'length + 2));

        real_b_to_arith <= real_b_in_sig(real_b_in_sig'high) & real_b_in_sig;
        imag_b_to_arith <= imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig;

        adr_a_out_sig <= adr_a_in_sig;
        adr_b_out_sig <= adr_b_in_sig;

        real_a_out_sig <= real_a_out_sum(9 downto 1);
        imag_a_out_sig <= imag_a_out_sum(9 downto 1);
        real_b_out_sig <= real_b_out_sum(9 downto 1);
        imag_b_out_sig <= imag_b_out_sum(9 downto 1);

        calc_done_sig <= '1';
    end generate gen_buffer_output_no;

    --=========================================================================

    gen_buffer_output_yes : if(g_pipeline /= 0) generate
        process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                real_a_out_sig <= (others => '0');
                imag_a_out_sig <= (others => '0');
                real_b_out_sig <= (others => '0');
                imag_b_out_sig <= (others => '0');
                temp_real_trunc <= (others => '0');
                temp_imag_trunc <= (others => '0');
                real_b_pipe1 <= (others => '0');
                imag_b_pipe1 <= (others => '0');
                do_calc_pipe1 <= '0';
                calc_done_sig <= '0';
            elsif(rising_edge(PCLK)) then
                -- result of stage 1
                do_calc_pipe1 <= do_calc_sig;

                temp_real_trunc <= signed(temp_real(temp_real'high) & temp_real(16 downto 16 - temp_real_trunc'length + 2));
                temp_imag_trunc <= signed(temp_imag(temp_imag'high) & temp_imag(16 downto 16 - temp_imag_trunc'length + 2));

                adr_a_pipe1 <= adr_a_in_sig;
                adr_b_pipe1 <= adr_b_in_sig;

                real_b_pipe1 <= real_b_in_sig;
                imag_b_pipe1 <= imag_b_in_sig;
                -- result of stage 1

                -- result of stage 2
                calc_done_sig <= do_calc_pipe1;

                adr_a_out_sig <= adr_a_pipe1;
                adr_b_out_sig <= adr_b_pipe1;

                real_a_out_sig <= real_a_out_sum(9 downto 1);
                imag_a_out_sig <= imag_a_out_sum(9 downto 1);
                real_b_out_sig <= real_b_out_sum(9 downto 1);
                imag_b_out_sig <= imag_b_out_sum(9 downto 1);
                -- result of stage 2
            end if;
        end process;

        
        real_b_to_arith <= real_b_pipe1(real_b_pipe1'high) & real_b_pipe1;
        imag_b_to_arith <= imag_b_pipe1(imag_b_pipe1'high) & imag_b_pipe1;
    end generate gen_buffer_output_yes;


    adr_a_out <= adr_a_out_sig;
    adr_b_out <= adr_b_out_sig;

    real_a_out <= real_a_out_sig;
    imag_a_out <= imag_a_out_sig;
    real_b_out <= real_b_out_sig;
    imag_b_out <= imag_b_out_sig;
   -- architecture body
end architecture_FFT_Butterfly_HW_MATHDSP;
