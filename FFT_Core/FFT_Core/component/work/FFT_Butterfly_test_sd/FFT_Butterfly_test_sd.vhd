----------------------------------------------------------------------
-- Created by SmartDesign Wed Feb 26 01:32:01 2020
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- FFT_Butterfly_test_sd entity declaration
----------------------------------------------------------------------
entity FFT_Butterfly_test_sd is
    -- Port list
    port(
        -- Outputs
        adr_a_out  : out std_logic_vector(4 downto 0);
        adr_b_out  : out std_logic_vector(4 downto 0);
        calc_done  : out std_logic;
        imag_a_out : out std_logic_vector(8 downto 0);
        imag_b_out : out std_logic_vector(8 downto 0);
        real_a_out : out std_logic_vector(8 downto 0);
        real_b_out : out std_logic_vector(8 downto 0)
        );
end FFT_Butterfly_test_sd;
----------------------------------------------------------------------
-- FFT_Butterfly_test_sd architecture body
----------------------------------------------------------------------
architecture RTL of FFT_Butterfly_test_sd is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- AND2
component AND2
    -- Port list
    port(
        -- Inputs
        A : in  std_logic;
        B : in  std_logic;
        -- Outputs
        Y : out std_logic
        );
end component;
-- FCCC_C0
component FCCC_C0
    -- Port list
    port(
        -- Inputs
        RCOSC_25_50MHZ : in  std_logic;
        -- Outputs
        GL0            : out std_logic;
        LOCK           : out std_logic
        );
end component;
-- FFT_Butterfly_HW_MATHDSP
-- using entity instantiation for component FFT_Butterfly_HW_MATHDSP
-- LFSR_Fib_Gen
-- using entity instantiation for component LFSR_Fib_Gen
-- OSC_C0
component OSC_C0
    -- Port list
    port(
        -- Outputs
        RCOSC_25_50MHZ_CCC : out std_logic
        );
end component;
-- Twiddle_table
-- using entity instantiation for component Twiddle_table
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal adr_a_out_net_0                                    : std_logic_vector(4 downto 0);
signal adr_b_out_net_0                                    : std_logic_vector(4 downto 0);
signal AND2_0_Y                                           : std_logic;
signal calc_done_net_0                                    : std_logic;
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal imag_a_out_net_0                                   : std_logic_vector(8 downto 0);
signal imag_b_out_net_0                                   : std_logic_vector(8 downto 0);
signal LFSR_Fib_Gen_0_rand4to0                            : std_logic_vector(4 downto 0);
signal LFSR_Fib_Gen_0_rand8to0                            : std_logic_vector(8 downto 0);
signal LFSR_Fib_Gen_0_rand9to7                            : std_logic_vector(9 downto 7);
signal LFSR_Fib_Gen_0_rand10to2                           : std_logic_vector(10 downto 2);
signal LFSR_Fib_Gen_0_rand13to5                           : std_logic_vector(13 downto 5);
signal LFSR_Fib_Gen_0_rand14to10                          : std_logic_vector(14 downto 10);
signal LFSR_Fib_Gen_0_rand15to7                           : std_logic_vector(15 downto 7);
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal real_a_out_net_0                                   : std_logic_vector(8 downto 0);
signal real_b_out_net_0                                   : std_logic_vector(8 downto 0);
signal Twiddle_table_0_cos_twid                           : std_logic_vector(8 downto 0);
signal Twiddle_table_0_sin_twid                           : std_logic_vector(8 downto 0);
signal Twiddle_table_0_sin_twid_1comp                     : std_logic_vector(8 downto 0);
signal Twiddle_table_0_twiddle_ready                      : std_logic;
signal calc_done_net_1                                    : std_logic;
signal imag_b_out_net_1                                   : std_logic_vector(8 downto 0);
signal real_a_out_net_1                                   : std_logic_vector(8 downto 0);
signal imag_a_out_net_1                                   : std_logic_vector(8 downto 0);
signal real_b_out_net_1                                   : std_logic_vector(8 downto 0);
signal adr_b_out_net_1                                    : std_logic_vector(4 downto 0);
signal adr_a_out_net_1                                    : std_logic_vector(4 downto 0);
signal rand_net_0                                         : std_logic_vector(15 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 calc_done_net_1        <= calc_done_net_0;
 calc_done              <= calc_done_net_1;
 imag_b_out_net_1       <= imag_b_out_net_0;
 imag_b_out(8 downto 0) <= imag_b_out_net_1;
 real_a_out_net_1       <= real_a_out_net_0;
 real_a_out(8 downto 0) <= real_a_out_net_1;
 imag_a_out_net_1       <= imag_a_out_net_0;
 imag_a_out(8 downto 0) <= imag_a_out_net_1;
 real_b_out_net_1       <= real_b_out_net_0;
 real_b_out(8 downto 0) <= real_b_out_net_1;
 adr_b_out_net_1        <= adr_b_out_net_0;
 adr_b_out(4 downto 0)  <= adr_b_out_net_1;
 adr_a_out_net_1        <= adr_a_out_net_0;
 adr_a_out(4 downto 0)  <= adr_a_out_net_1;
----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
 LFSR_Fib_Gen_0_rand4to0   <= rand_net_0(4 downto 0);
 LFSR_Fib_Gen_0_rand8to0   <= rand_net_0(8 downto 0);
 LFSR_Fib_Gen_0_rand9to7   <= rand_net_0(9 downto 7);
 LFSR_Fib_Gen_0_rand10to2  <= rand_net_0(10 downto 2);
 LFSR_Fib_Gen_0_rand13to5  <= rand_net_0(13 downto 5);
 LFSR_Fib_Gen_0_rand14to10 <= rand_net_0(14 downto 10);
 LFSR_Fib_Gen_0_rand15to7  <= rand_net_0(15 downto 7);
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- AND2_0
AND2_0 : AND2
    port map( 
        -- Inputs
        A => calc_done_net_0,
        B => Twiddle_table_0_twiddle_ready,
        -- Outputs
        Y => AND2_0_Y 
        );
-- FCCC_C0_0
FCCC_C0_0 : FCCC_C0
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        -- Outputs
        GL0            => FCCC_C0_0_GL0,
        LOCK           => FCCC_C0_0_LOCK 
        );
-- FFT_Butterfly_HW_MATHDSP_0
FFT_Butterfly_HW_MATHDSP_0 : entity work.FFT_Butterfly_HW_MATHDSP
    generic map( 
        g_adr_width => ( 5 ),
        g_pipeline  => ( 1 )
        )
    port map( 
        -- Inputs
        PCLK                   => FCCC_C0_0_GL0,
        RSTn                   => FCCC_C0_0_LOCK,
        do_calc                => AND2_0_Y,
        twiddle_cos_real       => Twiddle_table_0_cos_twid,
        twiddle_sin_imag       => Twiddle_table_0_sin_twid,
        twiddle_sin_imag_1comp => Twiddle_table_0_sin_twid_1comp,
        adr_a_in               => LFSR_Fib_Gen_0_rand14to10,
        adr_b_in               => LFSR_Fib_Gen_0_rand4to0,
        real_a_in              => LFSR_Fib_Gen_0_rand15to7,
        imag_a_in              => LFSR_Fib_Gen_0_rand13to5,
        real_b_in              => LFSR_Fib_Gen_0_rand10to2,
        imag_b_in              => LFSR_Fib_Gen_0_rand8to0,
        -- Outputs
        calc_done              => calc_done_net_0,
        adr_a_out              => adr_a_out_net_0,
        adr_b_out              => adr_b_out_net_0,
        real_a_out             => real_a_out_net_0,
        imag_a_out             => imag_a_out_net_0,
        real_b_out             => real_b_out_net_0,
        imag_b_out             => imag_b_out_net_0 
        );
-- LFSR_Fib_Gen_0
LFSR_Fib_Gen_0 : entity work.LFSR_Fib_Gen
    generic map( 
        g_out_width => ( 16 )
        )
    port map( 
        -- Inputs
        PCLK => FCCC_C0_0_GL0,
        RSTn => FCCC_C0_0_LOCK,
        -- Outputs
        rand => rand_net_0 
        );
-- OSC_C0_0
OSC_C0_0 : OSC_C0
    port map( 
        -- Outputs
        RCOSC_25_50MHZ_CCC => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC 
        );
-- Twiddle_table_0
Twiddle_table_0 : entity work.Twiddle_table
    generic map( 
        g_data_samples_exp => ( 4 ),
        g_use_BRAM         => ( 1 )
        )
    port map( 
        -- Inputs
        PCLK           => FCCC_C0_0_GL0,
        RSTn           => FCCC_C0_0_LOCK,
        twiddle_index  => LFSR_Fib_Gen_0_rand9to7,
        -- Outputs
        twiddle_ready  => Twiddle_table_0_twiddle_ready,
        cos_twid       => Twiddle_table_0_cos_twid,
        cos_twid_1comp => OPEN,
        sin_twid       => Twiddle_table_0_sin_twid,
        sin_twid_1comp => Twiddle_table_0_sin_twid_1comp 
        );

end RTL;
