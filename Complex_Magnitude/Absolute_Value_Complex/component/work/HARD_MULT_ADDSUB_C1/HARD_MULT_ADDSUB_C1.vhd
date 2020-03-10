----------------------------------------------------------------------
-- Created by SmartDesign Sat Mar  7 15:37:30 2020
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
-- HARD_MULT_ADDSUB_C1 entity declaration
----------------------------------------------------------------------
entity HARD_MULT_ADDSUB_C1 is
    -- Port list
    port(
        -- Inputs
        A0       : in  std_logic_vector(8 downto 0);
        A1       : in  std_logic_vector(8 downto 0);
        B0       : in  std_logic_vector(8 downto 0);
        B1       : in  std_logic_vector(8 downto 0);
        C        : in  std_logic_vector(34 downto 0);
        CLK      : in  std_logic;
        P_ACLR_N : in  std_logic;
        P_EN     : in  std_logic;
        P_SCLR_N : in  std_logic;
        -- Outputs
        CDOUT    : out std_logic_vector(43 downto 0);
        P        : out std_logic_vector(34 downto 0)
        );
end HARD_MULT_ADDSUB_C1;
----------------------------------------------------------------------
-- HARD_MULT_ADDSUB_C1 architecture body
----------------------------------------------------------------------
architecture RTL of HARD_MULT_ADDSUB_C1 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- HARD_MULT_ADDSUB_C1_HARD_MULT_ADDSUB_C1_0_HARD_MULT_ADDSUB   -   Actel:SgCore:HARD_MULT_ADDSUB:1.0.100
component HARD_MULT_ADDSUB_C1_HARD_MULT_ADDSUB_C1_0_HARD_MULT_ADDSUB
    -- Port list
    port(
        -- Inputs
        A0       : in  std_logic_vector(8 downto 0);
        A1       : in  std_logic_vector(8 downto 0);
        B0       : in  std_logic_vector(8 downto 0);
        B1       : in  std_logic_vector(8 downto 0);
        C        : in  std_logic_vector(34 downto 0);
        CLK      : in  std_logic;
        P_ACLR_N : in  std_logic;
        P_EN     : in  std_logic;
        P_SCLR_N : in  std_logic;
        -- Outputs
        CDOUT    : out std_logic_vector(43 downto 0);
        P        : out std_logic_vector(34 downto 0)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal CDOUT_net_0 : std_logic_vector(43 downto 0);
signal P_0         : std_logic_vector(34 downto 0);
signal CDOUT_net_1 : std_logic_vector(43 downto 0);
signal P_0_net_0   : std_logic_vector(34 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net     : std_logic;
signal CDIN_const_net_0: std_logic_vector(43 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net          <= '0';
 CDIN_const_net_0 <= B"00000000000000000000000000000000000000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 CDOUT_net_1        <= CDOUT_net_0;
 CDOUT(43 downto 0) <= CDOUT_net_1;
 P_0_net_0          <= P_0;
 P(34 downto 0)     <= P_0_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- HARD_MULT_ADDSUB_C1_0   -   Actel:SgCore:HARD_MULT_ADDSUB:1.0.100
HARD_MULT_ADDSUB_C1_0 : HARD_MULT_ADDSUB_C1_HARD_MULT_ADDSUB_C1_0_HARD_MULT_ADDSUB
    port map( 
        -- Inputs
        P_ACLR_N => P_ACLR_N,
        P_SCLR_N => P_SCLR_N,
        P_EN     => P_EN,
        CLK      => CLK,
        A0       => A0,
        B0       => B0,
        A1       => A1,
        B1       => B1,
        C        => C,
        -- Outputs
        P        => P_0,
        CDOUT    => CDOUT_net_0 
        );

end RTL;
