----------------------------------------------------------------------
-- Created by SmartDesign Sun Dec  8 03:29:59 2019
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
-- FCCC_C0 entity declaration
----------------------------------------------------------------------
entity FCCC_C0 is
    -- Port list
    port(
        -- Inputs
        RCOSC_25_50MHZ : in  std_logic;
        -- Outputs
        GL0            : out std_logic;
        LOCK           : out std_logic
        );
end FCCC_C0;
----------------------------------------------------------------------
-- FCCC_C0 architecture body
----------------------------------------------------------------------
architecture RTL of FCCC_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- FCCC_C0_FCCC_C0_0_FCCC   -   Actel:SgCore:FCCC:2.0.201
component FCCC_C0_FCCC_C0_0_FCCC
    -- Port list
    port(
        -- Inputs
        RCOSC_25_50MHZ : in  std_logic;
        -- Outputs
        GL0            : out std_logic;
        LOCK           : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal GL0_net_0  : std_logic;
signal LOCK_net_0 : std_logic;
signal GL0_net_1  : std_logic;
signal LOCK_net_1 : std_logic;
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net    : std_logic;
signal PADDR_const_net_0: std_logic_vector(7 downto 2);
signal PWDATA_const_net_0: std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net            <= '0';
 PADDR_const_net_0  <= B"000000";
 PWDATA_const_net_0 <= B"00000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 GL0_net_1  <= GL0_net_0;
 GL0        <= GL0_net_1;
 LOCK_net_1 <= LOCK_net_0;
 LOCK       <= LOCK_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- FCCC_C0_0   -   Actel:SgCore:FCCC:2.0.201
FCCC_C0_0 : FCCC_C0_FCCC_C0_0_FCCC
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => RCOSC_25_50MHZ,
        -- Outputs
        GL0            => GL0_net_0,
        LOCK           => LOCK_net_0 
        );

end RTL;
