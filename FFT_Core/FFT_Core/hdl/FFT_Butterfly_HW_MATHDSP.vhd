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

use work.FFT_package.all;

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

    
    signal do_calc_sig : std_logic;
    signal calc_done_sig : std_logic;


    constant PIPELINE_LENGTH : natural := 4;

    -- pipeline relevant stuff

    signal do_calc_pipe : std_logic_vector(PIPELINE_LENGTH - 1 downto 0);

    type adr_pipe_type is array(PIPELINE_LENGTH - 1 downto 0) of std_logic_vector(g_adr_width - 1 downto 0);
    signal adr_a_pipe : adr_pipe_type;
    signal adr_b_pipe : adr_pipe_type;

    type data_pipe_type is array(PIPELINE_LENGTH - 3 downto 0) of std_logic_vector(8 downto 0);
    signal real_a_pipe : data_pipe_type;
    signal imag_a_pipe : data_pipe_type;
    --signal real_b_pipe : data_pipe_type;
    --signal imag_b_pipe : data_pipe_type;
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

    signal real_b_1comp_extend : std_logic_vector(34 downto 0);
    --signal real_b_1comp_extend : signed(43 downto 0);

    -- sets division of Math block output
    constant TRUNC_BIT_HIGH : natural := 16;

    signal temp_real : std_logic_vector(34 downto 0);
    signal temp_real_slice : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal temp_real_rnd_bias : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal temp_real_rnd_slice_bias : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal temp_real_trunc_rnd : signed(9 downto 0);
    --signal temp_real_trunc : signed(9 downto 0);
    --signal temp_imag : signed(34 downto 0);
    signal temp_imag : std_logic_vector(34 downto 0);
    signal temp_imag_slice : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal temp_imag_rnd_bias : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal temp_imag_rnd_slice_bias : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal temp_imag_trunc_rnd : signed(9 downto 0);
    --signal temp_imag_trunc : signed(9 downto 0);

    signal real_a_to_arith : std_logic_vector(9 downto 0);
    signal imag_a_to_arith : std_logic_vector(9 downto 0);

    signal adr_a_out_sig : std_logic_vector(g_adr_width - 1 downto 0);
    signal adr_b_out_sig : std_logic_vector(g_adr_width - 1 downto 0);

    signal real_a_out_sum : std_logic_vector(10 downto 0);
    signal imag_a_out_sum : std_logic_vector(10 downto 0);
    signal real_b_out_sum : std_logic_vector(10 downto 0);
    signal imag_b_out_sum : std_logic_vector(10 downto 0);
    signal real_a_out_sum_slice : std_logic_vector(10 downto 0);
    signal imag_a_out_sum_slice : std_logic_vector(10 downto 0);
    signal real_b_out_sum_slice : std_logic_vector(10 downto 0);
    signal imag_b_out_sum_slice : std_logic_vector(10 downto 0);
    signal real_a_out_sum_rnd_bias : std_logic_vector(10 downto 0);
    signal imag_a_out_sum_rnd_bias : std_logic_vector(10 downto 0);
    signal real_b_out_sum_rnd_bias : std_logic_vector(10 downto 0);
    signal imag_b_out_sum_rnd_bias : std_logic_vector(10 downto 0);
    signal real_a_out_sum_rnd_slice_bias : std_logic_vector(10 downto 0);
    signal imag_a_out_sum_rnd_slice_bias : std_logic_vector(10 downto 0);
    signal real_b_out_sum_rnd_slice_bias : std_logic_vector(10 downto 0);
    signal imag_b_out_sum_rnd_slice_bias : std_logic_vector(10 downto 0);
    signal real_a_out_sum_trunc_rnd : std_logic_vector(8 downto 0);
    signal imag_a_out_sum_trunc_rnd : std_logic_vector(8 downto 0);
    signal real_b_out_sum_trunc_rnd : std_logic_vector(8 downto 0);
    signal imag_b_out_sum_trunc_rnd : std_logic_vector(8 downto 0);

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

    --=========================================================================
    -- BEGIN - port to signal assignments
    --=========================================================================

    do_calc_sig <= do_calc;

    twiddle_cos_real_sig <= twiddle_cos_real;
    twiddle_sin_imag_sig <= twiddle_sin_imag;
    twiddle_sin_imag_1comp_sig <= twiddle_sin_imag_1comp;

    adr_a_in_sig <= adr_a_in;
    adr_b_in_sig <= adr_b_in;

    real_a_in_sig <= real_a_in;
    imag_a_in_sig <= imag_a_in;
    real_b_in_sig <= real_b_in;
    imag_b_in_sig <= imag_b_in;

    
    calc_done <= calc_done_sig;

    adr_a_out <= adr_a_out_sig;
    adr_b_out <= adr_b_out_sig;

    real_a_out <= real_a_out_sig;
    imag_a_out <= imag_a_out_sig;
    real_b_out <= real_b_out_sig;
    imag_b_out <= imag_b_out_sig;

    --=========================================================================
    -- END - port to signal assignments
    -- BEGIN - Hardware Multiplier; Stage 1
    --=========================================================================
    
    --temp_real <= (real_a_in_sig * signed(twiddle_cos_real_sig)) + (imag_a_in_sig * signed(twiddle_sin_imag_sig));
    --temp_imag <= (imag_a_in_sig * signed(twiddle_cos_real_sig)) + (real_a_in_sig * signed(twiddle_sin_imag_1comp_sig)) + real_a_1comp_extend;
    -- real_a_1comp_extend is necessary as 2's complement of twiddle_sine is spread out across the MATH block
    real_b_1comp_extend <= (real_b_1comp_extend'high downto 9 => real_b_in_sig(8), 8 downto 0 => real_b_in_sig, others => '0');

    -- real
    HARD_MULT_ADDSUB_C0_0 : HARD_MULT_ADDSUB_C0
    port map( 
        -- Inputs
        A0    => real_b_in_sig,
        B0    => twiddle_cos_real_sig,
        A1    => imag_b_in_sig,
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
        A0    => imag_b_in_sig,
        B0    => twiddle_cos_real_sig,
        A1    => real_b_in_sig,
        B1    => twiddle_sin_imag_1comp_sig,
        C     => real_b_1comp_extend,
        -- Outputs
        CDOUT => OPEN,
        P     => temp_imag
        );

        

    gen_pipeline_no_MACC : if(g_pipeline = 0) generate
        -- temp_real_slice = temp_real(sign) & temp_real(17 downto 0);
        -- final_trunc_rnd = temp_real(sign) & temp_real(17 downto 10);
        temp_real_slice <= temp_real(temp_real'high) & temp_real(temp_real_slice'length - 2 downto 0);
        temp_imag_slice <= temp_imag(temp_imag'high) & temp_imag(temp_imag_slice'length - 2 downto 0);

    end generate gen_pipeline_no_MACC;
    gen_pipeline_yes_MACC : if(g_pipeline /= 0) generate
        p_mult_result : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                do_calc_pipe(0) <= '0';
                adr_a_pipe(0) <= (others => '0');
                adr_b_pipe(0) <= (others => '0');
                real_a_pipe(0) <= (others => '0');
                imag_a_pipe(0) <= (others => '0');
                temp_real_slice <= (others => '0');
                temp_imag_slice <= (others => '0');
            elsif(rising_edge(PCLK)) then
                do_calc_pipe(0) <= do_calc_sig;
                adr_a_pipe(0) <= adr_a_in_sig;
                adr_b_pipe(0) <= adr_b_in_sig;
                real_a_pipe(0) <= real_a_in_sig;
                imag_a_pipe(0) <= imag_a_in_sig;
                temp_real_slice <= temp_real(temp_real'high) & temp_real(temp_real_slice'length - 2 downto 0);
                temp_imag_slice <= temp_imag(temp_imag'high) & temp_imag(temp_imag_slice'length - 2 downto 0);
            end if;
        end process;
    end generate gen_pipeline_yes_MACC;

    --=========================================================================
    -- END - Hardware Multiplier; Stage 1
    -- BEGIN - Multiplier Result Rounding; Stage 2
    --=========================================================================

    
    temp_real_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(temp_real_slice, 9);
    temp_imag_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(temp_imag_slice, 9);

    temp_real_rnd_slice_bias <= std_logic_vector(signed(temp_real_slice) + signed(temp_real_rnd_bias));
    temp_imag_rnd_slice_bias <= std_logic_vector(signed(temp_imag_slice) + signed(temp_imag_rnd_bias));

    gen_pipeline_no_MACC_rnd : if(g_pipeline = 0) generate
        temp_real_trunc_rnd <= signed(temp_real_rnd_slice_bias(temp_real_rnd_slice_bias'high downto temp_real_rnd_slice_bias'high - temp_real_trunc_rnd'length + 1));
        temp_imag_trunc_rnd <= signed(temp_imag_rnd_slice_bias(temp_imag_rnd_slice_bias'high downto temp_imag_rnd_slice_bias'high - temp_imag_trunc_rnd'length + 1));
        real_a_to_arith <= (real_a_in_sig'high downto 0 => real_a_in_sig, others => real_a_in_sig(real_a_in_sig'high));
        imag_a_to_arith <= (imag_a_in_sig'high downto 0 => imag_a_in_sig, others => imag_a_in_sig(imag_a_in_sig'high));
    end generate gen_pipeline_no_MACC_rnd;
    gen_pipeline_yes_MACC_rnd : if(g_pipeline /= 0) generate
        p_mult_result_round : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                do_calc_pipe(1) <= '0';
                adr_a_pipe(1) <= (others => '0');
                adr_b_pipe(1) <= (others => '0');
                real_a_pipe(1) <= (others => '0');
                imag_a_pipe(1) <= (others => '0');
                temp_real_trunc_rnd <= (others => '0');
                temp_imag_trunc_rnd <= (others => '0');
            elsif(rising_edge(PCLK)) then
                do_calc_pipe(1) <= do_calc_pipe(0);
                adr_a_pipe(1) <= adr_a_pipe(0);
                adr_b_pipe(1) <= adr_b_pipe(0);
                real_a_pipe(1) <= real_a_pipe(0);
                imag_a_pipe(1) <= imag_a_pipe(0);
                temp_real_trunc_rnd <= signed(temp_real_rnd_slice_bias(temp_real_rnd_slice_bias'high downto temp_real_rnd_slice_bias'high - temp_real_trunc_rnd'length + 1));
                temp_imag_trunc_rnd <= signed(temp_imag_rnd_slice_bias(temp_imag_rnd_slice_bias'high downto temp_imag_rnd_slice_bias'high - temp_imag_trunc_rnd'length + 1));
            end if;
        end process;

        real_a_to_arith <= (real_a_pipe(1)'high downto 0 => real_a_pipe(1), others => real_a_pipe(1)(real_a_pipe(1)'high));
        imag_a_to_arith <= (imag_a_pipe(1)'high downto 0 => imag_a_pipe(1), others => imag_a_pipe(1)(imag_a_pipe(1)'high));
    end generate gen_pipeline_yes_MACC_rnd;
    --=========================================================================
    -- END - Multiplier Result Rounding; Stage 2
    -- BEGIN - Final Sums; Stage 3
    --=========================================================================

    real_b_out_sum <= std_logic_vector(signed(real_a_to_arith) - (temp_real_trunc_rnd(temp_real_trunc_rnd'high) & temp_real_trunc_rnd));
    imag_b_out_sum <= std_logic_vector(signed(imag_a_to_arith) - (temp_imag_trunc_rnd(temp_imag_trunc_rnd'high) & temp_imag_trunc_rnd));
    real_a_out_sum <= std_logic_vector(signed(real_a_to_arith) + (temp_real_trunc_rnd(temp_real_trunc_rnd'high) & temp_real_trunc_rnd));
    imag_a_out_sum <= std_logic_vector(signed(imag_a_to_arith) + (temp_imag_trunc_rnd(temp_imag_trunc_rnd'high) & temp_imag_trunc_rnd));

    gen_pipeline_no_sums : if(g_pipeline = 0) generate
    
        real_a_out_sum_slice <= real_a_out_sum;
        imag_a_out_sum_slice <= imag_a_out_sum;
        real_b_out_sum_slice <= real_b_out_sum;
        imag_b_out_sum_slice <= imag_b_out_sum;

    end generate gen_pipeline_no_sums;
    gen_pipeline_yes_sums : if(g_pipeline /= 0) generate
        p_final_sums : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                do_calc_pipe(2) <= '0';
                adr_a_pipe(2) <= (others => '0');
                adr_b_pipe(2) <= (others => '0');
                real_a_out_sum_slice <= (others => '0');
                imag_a_out_sum_slice <= (others => '0');
                real_b_out_sum_slice <= (others => '0');
                imag_b_out_sum_slice <= (others => '0');
            elsif(rising_edge(PCLK)) then
                do_calc_pipe(2) <= do_calc_pipe(1);
                adr_a_pipe(2) <= adr_a_pipe(1);
                adr_b_pipe(2) <= adr_b_pipe(1);
                real_a_out_sum_slice <= real_a_out_sum;
                imag_a_out_sum_slice <= imag_a_out_sum;
                real_b_out_sum_slice <= real_b_out_sum;
                imag_b_out_sum_slice <= imag_b_out_sum;
            end if;
        end process;
    end generate gen_pipeline_yes_sums;
    --=========================================================================
    -- END - Final Sums; Stage 3
    -- BEGIN - Final Sums Result Rounding; Stage 4
    --=========================================================================

    real_a_out_sum_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(real_a_out_sum_slice, 10);
    imag_a_out_sum_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(imag_a_out_sum_slice, 10);
    real_b_out_sum_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(real_b_out_sum_slice, 10);
    imag_b_out_sum_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(imag_b_out_sum_slice, 10);

    real_a_out_sum_rnd_slice_bias <= std_logic_vector(signed(real_a_out_sum_slice) + signed(real_a_out_sum_rnd_bias));
    imag_a_out_sum_rnd_slice_bias <= std_logic_vector(signed(imag_a_out_sum_slice) + signed(imag_a_out_sum_rnd_bias));
    real_b_out_sum_rnd_slice_bias <= std_logic_vector(signed(real_b_out_sum_slice) + signed(real_b_out_sum_rnd_bias));
    imag_b_out_sum_rnd_slice_bias <= std_logic_vector(signed(imag_b_out_sum_slice) + signed(imag_b_out_sum_rnd_bias));

    gen_pipeline_no_sums_rnd : if(g_pipeline = 0) generate
        real_a_out_sum_trunc_rnd <= real_a_out_sum_rnd_slice_bias(real_a_out_sum_rnd_slice_bias'high downto real_a_out_sum_rnd_slice_bias'high - real_a_out_sum_trunc_rnd'length + 1);
        imag_a_out_sum_trunc_rnd <= imag_a_out_sum_rnd_slice_bias(imag_a_out_sum_rnd_slice_bias'high downto imag_a_out_sum_rnd_slice_bias'high - imag_a_out_sum_trunc_rnd'length + 1);
        real_b_out_sum_trunc_rnd <= real_b_out_sum_rnd_slice_bias(real_b_out_sum_rnd_slice_bias'high downto real_b_out_sum_rnd_slice_bias'high - real_b_out_sum_trunc_rnd'length + 1);
        imag_b_out_sum_trunc_rnd <= imag_b_out_sum_rnd_slice_bias(imag_b_out_sum_rnd_slice_bias'high downto imag_b_out_sum_rnd_slice_bias'high - imag_b_out_sum_trunc_rnd'length + 1);
    end generate gen_pipeline_no_sums_rnd;
    gen_pipeline_yes_sums_rnd : if(g_pipeline /= 0) generate
        p_final_sums_round : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                do_calc_pipe(3) <= '0';
                adr_a_pipe(3) <= (others => '0');
                adr_b_pipe(3) <= (others => '0');
                real_a_out_sum_trunc_rnd <= (others => '0');
                imag_a_out_sum_trunc_rnd <= (others => '0');
                real_b_out_sum_trunc_rnd <= (others => '0');
                imag_b_out_sum_trunc_rnd <= (others => '0');
            elsif(rising_edge(PCLK)) then
                do_calc_pipe(3) <= do_calc_pipe(2);
                adr_a_pipe(3) <= adr_a_pipe(2);
                adr_b_pipe(3) <= adr_b_pipe(2);
                real_a_out_sum_trunc_rnd <= real_a_out_sum_rnd_slice_bias(real_a_out_sum_rnd_slice_bias'high - 1 downto real_a_out_sum_rnd_slice_bias'high - real_a_out_sum_trunc_rnd'length);
                imag_a_out_sum_trunc_rnd <= imag_a_out_sum_rnd_slice_bias(imag_a_out_sum_rnd_slice_bias'high - 1 downto imag_a_out_sum_rnd_slice_bias'high - imag_a_out_sum_trunc_rnd'length);
                real_b_out_sum_trunc_rnd <= real_b_out_sum_rnd_slice_bias(real_b_out_sum_rnd_slice_bias'high - 1 downto real_b_out_sum_rnd_slice_bias'high - real_b_out_sum_trunc_rnd'length);
                imag_b_out_sum_trunc_rnd <= imag_b_out_sum_rnd_slice_bias(imag_b_out_sum_rnd_slice_bias'high - 1 downto imag_b_out_sum_rnd_slice_bias'high - imag_b_out_sum_trunc_rnd'length);
            end if;
        end process;
    end generate gen_pipeline_yes_sums_rnd;

    real_a_out_sig <= real_a_out_sum_trunc_rnd;
    imag_a_out_sig <= imag_a_out_sum_trunc_rnd;
    real_b_out_sig <= real_b_out_sum_trunc_rnd;
    imag_b_out_sig <= imag_b_out_sum_trunc_rnd;
    --=========================================================================
    -- END - Final Sums Result Rounding; Stage 4
    -- BEGIN - Output Assignments
    --=========================================================================

    gen_pipeline_no_assign : if(g_pipeline = 0) generate
        calc_done_sig <= '1';
        adr_a_out_sig <= adr_a_in_sig;
        adr_b_out_sig <= adr_b_in_sig;
    end generate gen_pipeline_no_assign;
    gen_pipeline_yes_assign : if(g_pipeline /= 0) generate
        calc_done_sig <= do_calc_pipe(3);
        adr_a_out_sig <= adr_a_pipe(3);
        adr_b_out_sig <= adr_b_pipe(3);
        p_mult_result : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                --calc_done_sig <= '0';
                --adr_a_out_sig <= (others => '0');
                --adr_b_out_sig <= (others => '0');
            elsif(rising_edge(PCLK)) then
                --calc_done_sig <= '1';
                --adr_a_out_sig <= ;
                --adr_b_out_sig <= ;
            end if;
        end process;
    end generate gen_pipeline_yes_assign;

    --=========================================================================
    -- END - Output Assignments
    --=========================================================================

    --temp_real <= (real_a_in_sig * signed(twiddle_cos_real_sig)) + (imag_a_in_sig * signed(twiddle_sin_imag_sig));
    -- real_a_1comp_extend is necessary as 2's complement of twiddle_sine is spread out across the MATH block
    --real_b_1comp_extend <= (real_b_1comp_extend'high downto 9 => real_b_in_sig(8), 8 downto 0 => real_b_in_sig, others => '0');
    ----real_a_1comp_extend <= (18 downto 10 => real_a_in_sig, others => '0');
    ----temp_imag <= (imag_a_in_sig * signed(twiddle_cos_real_sig)) + (real_a_in_sig * signed(twiddle_sin_imag_1comp_sig)) + real_a_1comp_extend;
    ----temp_real_trunc <= temp_real(17) & temp_real(16 downto 16 - temp_real_trunc'length + 2);
    ----temp_imag_trunc <= temp_imag(34) & temp_imag(16 downto 16 - temp_imag_trunc'length + 2);
    --
    ----real_b_out_sum <= std_logic_vector(signed(real_a_to_arith) - (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    ----imag_b_out_sum <= std_logic_vector(signed(imag_a_to_arith) - (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    ----real_a_out_sum <= std_logic_vector(signed(real_a_to_arith) + (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    ----imag_a_out_sum <= std_logic_vector(signed(imag_a_to_arith) + (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    --real_b_out_sum <= std_logic_vector(signed(real_a_to_arith) - (temp_real_rnd_fin(temp_real_rnd_fin'high) & temp_real_rnd_fin));
    --imag_b_out_sum <= std_logic_vector(signed(imag_a_to_arith) - (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    --real_a_out_sum <= std_logic_vector(signed(real_a_to_arith) + (temp_real_rnd_fin(temp_real_rnd_fin'high) & temp_real_rnd_fin));
    --imag_a_out_sum <= std_logic_vector(signed(imag_a_to_arith) + (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    --
--
    --gen_buffer_output_no : if(g_pipeline = 0) generate
    --    temp_real_rnd_pre <= temp_real(temp_real'high) & temp_real(temp_real_rnd_pre'length - 2 downto 0);
    --    temp_real_rnd_add <= (7 => temp_real_rnd_pre(8), 6 downto 0 => not temp_real_rnd_pre(8), others => '0');
--
    --    temp_real_rnd_fin <= signed(temp_real_rnd_pre) + signed(temp_real_rnd_add);
    --    -- 16 - 9 + 2 = div by 2^9; 15 - 9 + 2 = div by 2^8
    --    temp_imag_trunc <= signed(temp_imag(temp_imag'high) & temp_imag(TRUNC_BIT_HIGH downto TRUNC_BIT_HIGH - temp_imag_trunc'length + 2));
    --    temp_real_trunc <= signed(temp_real(temp_real'high) & temp_real(TRUNC_BIT_HIGH downto TRUNC_BIT_HIGH - temp_real_trunc'length + 2));
--
    --    real_a_to_arith <= (real_a_in_sig'high downto 0 => real_a_in_sig, others => real_a_in_sig(real_a_in_sig'high));
    --    imag_a_to_arith <= (imag_a_in_sig'high downto 0 => imag_a_in_sig, others => imag_a_in_sig(imag_a_in_sig'high));
--
    --    adr_a_out_sig <= adr_a_in_sig;
    --    adr_b_out_sig <= adr_b_in_sig;
--
    --    real_a_out_sig <= real_a_out_sum(real_a_out_sum'high downto real_a_out_sum'high - real_a_out_sig'length + 1);
    --    imag_a_out_sig <= imag_a_out_sum(imag_a_out_sum'high downto imag_a_out_sum'high - imag_a_out_sig'length + 1);
    --    real_b_out_sig <= real_b_out_sum(real_b_out_sum'high downto real_b_out_sum'high - real_b_out_sig'length + 1);
    --    imag_b_out_sig <= imag_b_out_sum(imag_b_out_sum'high downto imag_b_out_sum'high - imag_b_out_sig'length + 1);
--
    --    calc_done_sig <= '1';
    --end generate gen_buffer_output_no;
--
    ----=========================================================================
--
    --gen_buffer_output_yes : if(g_pipeline /= 0) generate
    --    process(PCLK, RSTn)
    --    begin
    --        if(RSTn = '0') then
    --            adr_a_out_sig <= (others => '0');
    --            adr_b_out_sig <= (others => '0');
    --            real_a_out_sig <= (others => '0');
    --            imag_a_out_sig <= (others => '0');
    --            real_b_out_sig <= (others => '0');
    --            imag_b_out_sig <= (others => '0');
    --            temp_real_trunc <= (others => '0');
    --            temp_imag_trunc <= (others => '0');
    --            adr_a_pipe1 <= (others => '0');
    --            adr_b_pipe1 <= (others => '0');
    --            real_a_pipe1 <= (others => '0');
    --            imag_a_pipe1 <= (others => '0');
    --            do_calc_pipe1 <= '0';
    --            calc_done_sig <= '0';
    --        elsif(rising_edge(PCLK)) then
    --            -- result of stage 1
    --            do_calc_pipe1 <= do_calc_sig;
--
--
    --            -- TODO: rounding, https://zipcpu.com/dsp/2017/07/22/rounding.html
    --            temp_real_rnd_pre <= temp_real(temp_real'high) & temp_real(temp_real_rnd_pre'length - 2 downto 0);
    --            temp_real_rnd_add <= (7 => temp_real_rnd_pre(8), 6 downto 0 => not temp_real_rnd_pre(8), others => '0');
--
    --            temp_real_rnd_fin <= signed(temp_real_rnd_pre) + signed(temp_real_rnd_add);
--
    --            temp_real_trunc <= signed(temp_real(temp_real'high) & temp_real(TRUNC_BIT_HIGH downto TRUNC_BIT_HIGH - temp_real_trunc'length + 2));
    --            temp_imag_trunc <= signed(temp_imag(temp_imag'high) & temp_imag(TRUNC_BIT_HIGH downto TRUNC_BIT_HIGH - temp_imag_trunc'length + 2));
--
    --            adr_a_pipe1 <= adr_a_in_sig;
    --            adr_b_pipe1 <= adr_b_in_sig;
--
    --            real_a_pipe1 <= real_a_in_sig;
    --            imag_a_pipe1 <= imag_a_in_sig;
    --            -- result of stage 1
--
    --            -- result of stage 2
    --            calc_done_sig <= do_calc_pipe1;
--
    --            adr_a_out_sig <= adr_a_pipe1;
    --            adr_b_out_sig <= adr_b_pipe1;
--
    --            real_a_out_sig <= real_a_out_sum(real_a_out_sum'high downto real_a_out_sum'high - real_a_out_sig'length + 1);
    --            imag_a_out_sig <= imag_a_out_sum(imag_a_out_sum'high downto imag_a_out_sum'high - imag_a_out_sig'length + 1);
    --            real_b_out_sig <= real_b_out_sum(real_b_out_sum'high downto real_b_out_sum'high - real_b_out_sig'length + 1);
    --            imag_b_out_sig <= imag_b_out_sum(imag_b_out_sum'high downto imag_b_out_sum'high - imag_b_out_sig'length + 1);
    --            -- result of stage 2
    --        end if;
    --    end process;
--
    --    
    --    real_a_to_arith <= (real_a_pipe1'high downto 0 => real_a_pipe1, others => real_a_pipe1(real_a_pipe1'high));
    --    imag_a_to_arith <= (imag_a_pipe1'high downto 0 => imag_a_pipe1, others => imag_a_pipe1(imag_a_pipe1'high));
    --end generate gen_buffer_output_yes;
--
--
    --adr_a_out <= adr_a_out_sig;
    --adr_b_out <= adr_b_out_sig;
--
    --real_a_out <= real_a_out_sig;
    --imag_a_out <= imag_a_out_sig;
    --real_b_out <= real_b_out_sig;
    --imag_b_out <= imag_b_out_sig;
   -- architecture body
end architecture_FFT_Butterfly_HW_MATHDSP;
