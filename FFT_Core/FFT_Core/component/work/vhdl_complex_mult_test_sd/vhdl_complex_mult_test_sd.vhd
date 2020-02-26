----------------------------------------------------------------------
-- Created by SmartDesign Tue Feb 25 02:19:13 2020
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
-- vhdl_complex_mult_test_sd entity declaration
----------------------------------------------------------------------
entity vhdl_complex_mult_test_sd is
    -- Port list
    port(
        -- Outputs
        imag_a_out : out std_logic_vector(8 downto 0);
        imag_b_out : out std_logic_vector(8 downto 0);
        real_a_out : out std_logic_vector(8 downto 0);
        real_b_out : out std_logic_vector(8 downto 0)
        );
end vhdl_complex_mult_test_sd;
----------------------------------------------------------------------
-- vhdl_complex_mult_test_sd architecture body
----------------------------------------------------------------------
architecture RTL of vhdl_complex_mult_test_sd is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- Butterfly_HW_DSP
-- using entity instantiation for component Butterfly_HW_DSP
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
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal imag_a_out_net_0                                   : std_logic_vector(8 downto 0);
signal imag_b_out_net_0                                   : std_logic_vector(8 downto 0);
signal LFSR_Fib_Gen_0_rand8to0                            : std_logic_vector(8 downto 0);
signal LFSR_Fib_Gen_0_rand9to6                            : std_logic_vector(9 downto 6);
signal LFSR_Fib_Gen_0_rand10to2                           : std_logic_vector(10 downto 2);
signal LFSR_Fib_Gen_0_rand13to5                           : std_logic_vector(13 downto 5);
signal LFSR_Fib_Gen_0_rand15to7                           : std_logic_vector(15 downto 7);
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal real_a_out_net_0                                   : std_logic_vector(8 downto 0);
signal real_b_out_net_0                                   : std_logic_vector(8 downto 0);
signal real_a_out_net_1                                   : std_logic_vector(8 downto 0);
signal imag_a_out_net_1                                   : std_logic_vector(8 downto 0);
signal real_b_out_net_1                                   : std_logic_vector(8 downto 0);
signal imag_b_out_net_1                                   : std_logic_vector(8 downto 0);
signal rand_net_0                                         : std_logic_vector(15 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 real_a_out_net_1       <= real_a_out_net_0;
 real_a_out(8 downto 0) <= real_a_out_net_1;
 imag_a_out_net_1       <= imag_a_out_net_0;
 imag_a_out(8 downto 0) <= imag_a_out_net_1;
 real_b_out_net_1       <= real_b_out_net_0;
 real_b_out(8 downto 0) <= real_b_out_net_1;
 imag_b_out_net_1       <= imag_b_out_net_0;
 imag_b_out(8 downto 0) <= imag_b_out_net_1;
----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
 LFSR_Fib_Gen_0_rand8to0  <= rand_net_0(8 downto 0);
 LFSR_Fib_Gen_0_rand9to6  <= rand_net_0(9 downto 6);
 LFSR_Fib_Gen_0_rand10to2 <= rand_net_0(10 downto 2);
 LFSR_Fib_Gen_0_rand13to5 <= rand_net_0(13 downto 5);
 LFSR_Fib_Gen_0_rand15to7 <= rand_net_0(15 downto 7);
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- Butterfly_HW_DSP_0
Butterfly_HW_DSP_0 : entity work.Butterfly_HW_DSP
    generic map( 
        g_samples_exp => ( 5 )
        )
    port map( 
        -- Inputs
        PCLK          => FCCC_C0_0_GL0,
        RSTn          => FCCC_C0_0_LOCK,
        twiddle_index => LFSR_Fib_Gen_0_rand9to6,
        real_a_in     => LFSR_Fib_Gen_0_rand15to7,
        imag_a_in     => LFSR_Fib_Gen_0_rand13to5,
        real_b_in     => LFSR_Fib_Gen_0_rand10to2,
        imag_b_in     => LFSR_Fib_Gen_0_rand8to0,
        -- Outputs
        real_a_out    => real_a_out_net_0,
        imag_a_out    => imag_a_out_net_0,
        real_b_out    => real_b_out_net_0,
        imag_b_out    => imag_b_out_net_0 
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

end RTL;
