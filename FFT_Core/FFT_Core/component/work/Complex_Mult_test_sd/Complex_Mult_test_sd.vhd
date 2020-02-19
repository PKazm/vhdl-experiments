----------------------------------------------------------------------
-- Created by SmartDesign Tue Feb 18 16:43:55 2020
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
-- Complex_Mult_test_sd entity declaration
----------------------------------------------------------------------
entity Complex_Mult_test_sd is
    -- Port list
    port(
        -- Inputs
        PCLK         : in  std_logic;
        RSTn         : in  std_logic;
        -- Outputs
        P_Imag_Trunc : out std_logic_vector(8 downto 0);
        P_Real_Trunc : out std_logic_vector(8 downto 0)
        );
end Complex_Mult_test_sd;
----------------------------------------------------------------------
-- Complex_Mult_test_sd architecture body
----------------------------------------------------------------------
architecture RTL of Complex_Mult_test_sd is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- bit_extender_8_to_35
component bit_extender_8_to_35
    -- Port list
    port(
        -- Inputs
        input  : in  std_logic_vector(8 downto 0);
        -- Outputs
        output : out std_logic_vector(34 downto 0)
        );
end component;
-- HARD_MULT_ADDSUB_C0
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
-- HARD_MULT_C0
component HARD_MULT_C0
    -- Port list
    port(
        -- Inputs
        A0    : in  std_logic_vector(8 downto 0);
        A1    : in  std_logic_vector(8 downto 0);
        B0    : in  std_logic_vector(8 downto 0);
        B1    : in  std_logic_vector(8 downto 0);
        -- Outputs
        CDOUT : out std_logic_vector(43 downto 0);
        P     : out std_logic_vector(18 downto 0)
        );
end component;
-- LFSR_Fib_Gen
-- using entity instantiation for component LFSR_Fib_Gen
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal bit_extender_8_to_35_0_output : std_logic_vector(34 downto 0);
signal LFSR_Fib_Gen_0_rand8to0       : std_logic_vector(8 downto 0);
signal LFSR_Fib_Gen_0_rand11to3      : std_logic_vector(11 downto 3);
signal LFSR_Fib_Gen_0_rand13to5      : std_logic_vector(13 downto 5);
signal LFSR_Fib_Gen_0_rand15to7      : std_logic_vector(15 downto 7);
signal P_Imag                        : std_logic_vector(34 downto 0);
signal P_Imag_Trunc_net_0            : std_logic_vector(15 downto 8);
signal P_Imag_Trunc_0                : std_logic_vector(34 to 34);
signal P_Real                        : std_logic_vector(18 downto 0);
signal P_Real_Trunc_net_0            : std_logic_vector(18 to 18);
signal P_Real_Trunc_0                : std_logic_vector(15 downto 8);
signal P_Real_Trunc_0_net_0          : std_logic_vector(7 downto 0);
signal P_Real_Trunc_net_1            : std_logic_vector(8 to 8);
signal P_Imag_Trunc_net_1            : std_logic_vector(7 downto 0);
signal P_Imag_Trunc_0_net_0          : std_logic_vector(8 to 8);
signal P_slice_0                     : std_logic_vector(33 downto 16);
signal P_slice_1                     : std_logic_vector(7 downto 0);
signal P_slice_2                     : std_logic_vector(17 downto 16);
signal P_slice_3                     : std_logic_vector(7 downto 0);
signal rand_net_0                    : std_logic_vector(15 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 P_Real_Trunc_0_net_0     <= P_Real_Trunc_0;
 P_Real_Trunc(7 downto 0) <= P_Real_Trunc_0_net_0;
 P_Real_Trunc_net_1(8)    <= P_Real_Trunc_net_0(18);
 P_Real_Trunc(8)          <= P_Real_Trunc_net_1(8);
 P_Imag_Trunc_net_1       <= P_Imag_Trunc_net_0;
 P_Imag_Trunc(7 downto 0) <= P_Imag_Trunc_net_1;
 P_Imag_Trunc_0_net_0(8)  <= P_Imag_Trunc_0(34);
 P_Imag_Trunc(8)          <= P_Imag_Trunc_0_net_0(8);
----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
 LFSR_Fib_Gen_0_rand8to0  <= rand_net_0(8 downto 0);
 LFSR_Fib_Gen_0_rand11to3 <= rand_net_0(11 downto 3);
 LFSR_Fib_Gen_0_rand13to5 <= rand_net_0(13 downto 5);
 LFSR_Fib_Gen_0_rand15to7 <= rand_net_0(15 downto 7);
 P_Imag_Trunc_net_0       <= P_Imag(15 downto 8);
 P_Imag_Trunc_0(34)       <= P_Imag(34);
 P_Real_Trunc_net_0(18)   <= P_Real(18);
 P_Real_Trunc_0           <= P_Real(15 downto 8);
 P_slice_0                <= P_Imag(33 downto 16);
 P_slice_1                <= P_Imag(7 downto 0);
 P_slice_2                <= P_Real(17 downto 16);
 P_slice_3                <= P_Real(7 downto 0);
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- bit_extender_8_to_35_0
bit_extender_8_to_35_0 : bit_extender_8_to_35
    port map( 
        -- Inputs
        input  => LFSR_Fib_Gen_0_rand8to0,
        -- Outputs
        output => bit_extender_8_to_35_0_output 
        );
-- HARD_MULT_ADDSUB_C0_0
HARD_MULT_ADDSUB_C0_0 : HARD_MULT_ADDSUB_C0
    port map( 
        -- Inputs
        A0    => LFSR_Fib_Gen_0_rand13to5,
        B0    => LFSR_Fib_Gen_0_rand11to3,
        A1    => LFSR_Fib_Gen_0_rand8to0,
        B1    => LFSR_Fib_Gen_0_rand15to7,
        C     => bit_extender_8_to_35_0_output,
        -- Outputs
        CDOUT => OPEN,
        P     => P_Imag 
        );
-- HARD_MULT_C0_1
HARD_MULT_C0_1 : HARD_MULT_C0
    port map( 
        -- Inputs
        A0    => LFSR_Fib_Gen_0_rand8to0,
        B0    => LFSR_Fib_Gen_0_rand11to3,
        A1    => LFSR_Fib_Gen_0_rand13to5,
        B1    => LFSR_Fib_Gen_0_rand15to7,
        -- Outputs
        CDOUT => OPEN,
        P     => P_Real 
        );
-- LFSR_Fib_Gen_0
LFSR_Fib_Gen_0 : entity work.LFSR_Fib_Gen
    generic map( 
        g_out_width => ( 16 )
        )
    port map( 
        -- Inputs
        PCLK => PCLK,
        RSTn => RSTn,
        -- Outputs
        rand => rand_net_0 
        );

end RTL;
