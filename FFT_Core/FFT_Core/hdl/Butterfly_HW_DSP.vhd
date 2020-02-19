--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Butterfly_HW_DSP.vhd
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

entity Butterfly_HW_DSP is
generic (
    g_samples_exp : natural := 8
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    -- twiddle count is half of sample count
    twiddle_index : in std_logic_vector(g_samples_exp - 2 downto 0);

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
end Butterfly_HW_DSP;
architecture architecture_Butterfly_HW_DSP of Butterfly_HW_DSP is
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

    -- Twiddle Table signals
    signal twiddle_index_sig : std_logic_vector(g_samples_exp - 2 downto 0);
    signal cos_twid : std_logic_vector(8 downto 0);
    signal sin_twid : std_logic_vector(8 downto 0);
    signal sin_twid_1comp : std_logic_vector(8 downto 0);
    signal cos_twid_sig : std_logic_vector(8 downto 0);
    signal sin_twid_sig : std_logic_vector(8 downto 0);
    signal sin_twid_1comp_sig : std_logic_vector(8 downto 0);
    -- Twiddle Table signals

    component Twiddle_Table
    generic (
        g_data_samples_exp : natural
    );
    port (
        -- twiddle count is half of sample count
        twiddle_index : in std_logic_vector(g_data_samples_exp - 2 downto 0);
    
        cos_twid : out std_logic_vector(8 downto 0);
        cos_twid_1comp : out std_logic_vector(8 downto 0);
        sin_twid : out std_logic_vector(8 downto 0);
        sin_twid_1comp : out std_logic_vector(8 downto 0)
    );
    end component;

begin

    Twiddle_Table_0 : Twiddle_Table
        generic map(
            g_data_samples_exp => g_samples_exp
        )
        port map(
            -- twiddle count is half of sample count
            twiddle_index => twiddle_index_sig,
        
            cos_twid => cos_twid,
            cos_twid_1comp => open,
            sin_twid => sin_twid,
            sin_twid_1comp => sin_twid_1comp
        );

    --real_a_in_sig <= signed(Complex_A_in(8 downto 0));
    --imag_a_in_sig <= signed(Complex_A_in(17 downto 9));
    --real_b_in_sig <= signed(Complex_B_in(8 downto 0));
    --imag_b_in_sig <= signed(Complex_B_in(17 downto 9));
	real_a_in_sig <= signed(real_a_in);
    imag_a_in_sig <= signed(imag_a_in);
    real_b_in_sig <= signed(real_b_in);
    imag_b_in_sig <= signed(imag_b_in);
	twiddle_index_sig <= twiddle_index;
    --
    --temp_real <= (real_a_in_sig * signed(cos_twid)) + (imag_a_in_sig * signed(sin_twid));
    ---- real_a_1comp_extend is necessary to ensure C input receives the correct sign information
    --real_a_1comp_extend <= (34 downto 9 => real_a_in_sig(8), 8 downto 0 => real_a_in_sig, others => '0');
    --temp_imag <= (imag_a_in_sig * signed(cos_twid)) + (real_a_in_sig * signed(sin_twid_1comp)) + real_a_1comp_extend;
    --temp_real_trunc <= temp_real(17) & temp_real(15 downto 15 - temp_real_trunc'length + 2);
    --temp_imag_trunc <= temp_imag(34) & temp_imag(15 downto 15 - temp_imag_trunc'length + 2);
    --
    --real_a_out_sum <= std_logic_vector((real_b_in_sig(real_b_in_sig'high) & real_b_in_sig) - (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    --imag_a_out_sum <= std_logic_vector((imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig) - (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    --real_b_out_sum <= std_logic_vector((real_b_in_sig(real_b_in_sig'high) & real_b_in_sig) + (temp_real_trunc(temp_real_trunc'high) & temp_real_trunc));
    --imag_b_out_sum <= std_logic_vector((imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig) + (temp_imag_trunc(temp_imag_trunc'high) & temp_imag_trunc));
    --
    --real_a_out_sig <= real_a_out_sum(9 downto 1);
    --imag_a_out_sig <= imag_a_out_sum(9 downto 1);
    --real_b_out_sig <= real_b_out_sum(9 downto 1);
    --imag_b_out_sig <= imag_b_out_sum(9 downto 1);

    process(PCLK, RSTn)
        variable real_a_1comp_extend_var : signed(34 downto 0) := (others => '0');
        variable temp_real_var : signed(17 downto 0) := (others => '0');
        variable temp_imag_var : signed(34 downto 0) := (others => '0');
        variable temp_real_trunc_var : signed(8 downto 0) := (others => '0');
        variable temp_imag_trunc_var : signed(8 downto 0) := (others => '0');
        variable real_a_out_var : std_logic_vector(9 downto 0) := (others => '0');
        variable imag_a_out_var : std_logic_vector(9 downto 0) := (others => '0');
        variable real_b_out_var : std_logic_vector(9 downto 0) := (others => '0');
        variable imag_b_out_var : std_logic_vector(9 downto 0) := (others => '0');
    begin
        if(RSTn = '0') then
            real_a_1comp_extend_var := (others => '0');
            temp_real_var := (others => '0');
            temp_imag_var := (others => '0');
            temp_real_trunc_var := (others => '0');
            temp_imag_trunc_var := (others => '0');
            real_a_out_var := (others => '0');
            imag_a_out_var := (others => '0');
            real_b_out_var := (others => '0');
            imag_b_out_var := (others => '0');

            --real_a_in_sig <= (others => '0');
            --imag_a_in_sig <= (others => '0');
            --real_b_in_sig <= (others => '0');
            --imag_b_in_sig <= (others => '0');
            --twiddle_index_sig <= (others => '0');
            temp_real <= (others => '0');
            temp_imag <= (others => '0');
            temp_real_trunc <= (others => '0');
            temp_imag_trunc <= (others => '0');
            real_a_out_sig <= (others => '0');
            imag_a_out_sig <= (others => '0');
            real_b_out_sig <= (others => '0');
            imag_b_out_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then

            --real_a_in_sig <= signed(real_a_in);
            --imag_a_in_sig <= signed(imag_a_in);
            --real_b_in_sig <= signed(real_b_in);
            --imag_b_in_sig <= signed(imag_b_in);
            --twiddle_index_sig <= twiddle_index;

            --cos_twid_sig <= cos_twid;
            --sin_twid_sig <= sin_twid;
            --sin_twid_1comp_sig <= sin_twid_1comp;
            cos_twid_sig <= twiddle_index(3 downto 0) & twiddle_index(8 downto 4);
            sin_twid_sig <= twiddle_index;
            sin_twid_1comp_sig <= not twiddle_index;
            
            -- real_a_1comp_extend is necessary to ensure C input receives the correct sign information
            real_a_1comp_extend_var := (34 downto 9 => real_a_in_sig(8), 8 downto 0 => real_a_in_sig, others => '0');
            temp_real_var := (real_a_in_sig * signed(cos_twid_sig)) + (imag_a_in_sig * signed(sin_twid_sig));
            temp_imag_var := (imag_a_in_sig * signed(cos_twid_sig)) + (real_a_in_sig * signed(sin_twid_1comp_sig)) + real_a_1comp_extend_var;
            temp_real_trunc_var := temp_real_var(17) & temp_real_var(15 downto 15 - temp_real_trunc_var'length + 2);
            temp_imag_trunc_var := temp_imag_var(34) & temp_imag_var(15 downto 15 - temp_imag_trunc_var'length + 2);
            
            real_a_out_var := std_logic_vector((real_b_in_sig(real_b_in_sig'high) & real_b_in_sig) - (temp_real_trunc_var(temp_real_trunc_var'high) & temp_real_trunc_var));
            imag_a_out_var := std_logic_vector((imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig) - (temp_imag_trunc_var(temp_imag_trunc_var'high) & temp_imag_trunc_var));
            real_b_out_var := std_logic_vector((real_b_in_sig(real_b_in_sig'high) & real_b_in_sig) + (temp_real_trunc_var(temp_real_trunc_var'high) & temp_real_trunc_var));
            imag_b_out_var := std_logic_vector((imag_b_in_sig(imag_b_in_sig'high) & imag_b_in_sig) + (temp_imag_trunc_var(temp_imag_trunc_var'high) & temp_imag_trunc_var));

            real_a_out_sig <= real_a_out_var(9 downto 1);
            imag_a_out_sig <= imag_a_out_var(9 downto 1);
            real_b_out_sig <= real_b_out_var(9 downto 1);
            imag_b_out_sig <= imag_b_out_var(9 downto 1);
        end if;
    end process;

    real_a_out <= real_a_out_sig;
    imag_a_out <= imag_a_out_sig;
    real_b_out <= real_b_out_sig;
    imag_b_out <= imag_b_out_sig;


   -- architecture body
end architecture_Butterfly_HW_DSP;
