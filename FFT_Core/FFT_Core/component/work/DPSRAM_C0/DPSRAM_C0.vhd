----------------------------------------------------------------------
-- Created by SmartDesign Fri Feb 28 00:46:36 2020
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
-- DPSRAM_C0 entity declaration
----------------------------------------------------------------------
entity DPSRAM_C0 is
    -- Port list
    port(
        -- Inputs
        A_ADDR : in  std_logic_vector(9 downto 0);
        A_DIN  : in  std_logic_vector(17 downto 0);
        A_WEN  : in  std_logic;
        B_ADDR : in  std_logic_vector(9 downto 0);
        B_DIN  : in  std_logic_vector(17 downto 0);
        B_WEN  : in  std_logic;
        CLK    : in  std_logic;
        -- Outputs
        A_DOUT : out std_logic_vector(17 downto 0);
        B_DOUT : out std_logic_vector(17 downto 0)
        );
end DPSRAM_C0;
----------------------------------------------------------------------
-- DPSRAM_C0 architecture body
----------------------------------------------------------------------
architecture RTL of DPSRAM_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- DPSRAM_C0_DPSRAM_C0_0_DPSRAM   -   Actel:SgCore:DPSRAM:1.0.101
component DPSRAM_C0_DPSRAM_C0_0_DPSRAM
    -- Port list
    port(
        -- Inputs
        A_ADDR : in  std_logic_vector(9 downto 0);
        A_DIN  : in  std_logic_vector(17 downto 0);
        A_WEN  : in  std_logic;
        B_ADDR : in  std_logic_vector(9 downto 0);
        B_DIN  : in  std_logic_vector(17 downto 0);
        B_WEN  : in  std_logic;
        CLK    : in  std_logic;
        -- Outputs
        A_DOUT : out std_logic_vector(17 downto 0);
        B_DOUT : out std_logic_vector(17 downto 0)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal A_DOUT_1       : std_logic_vector(17 downto 0);
signal B_DOUT_1       : std_logic_vector(17 downto 0);
signal A_DOUT_1_net_0 : std_logic_vector(17 downto 0);
signal B_DOUT_1_net_0 : std_logic_vector(17 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net        : std_logic;

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net <= '0';
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 A_DOUT_1_net_0      <= A_DOUT_1;
 A_DOUT(17 downto 0) <= A_DOUT_1_net_0;
 B_DOUT_1_net_0      <= B_DOUT_1;
 B_DOUT(17 downto 0) <= B_DOUT_1_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- DPSRAM_C0_0   -   Actel:SgCore:DPSRAM:1.0.101
DPSRAM_C0_0 : DPSRAM_C0_DPSRAM_C0_0_DPSRAM
    port map( 
        -- Inputs
        A_WEN  => A_WEN,
        B_WEN  => B_WEN,
        CLK    => CLK,
        A_DIN  => A_DIN,
        A_ADDR => A_ADDR,
        B_DIN  => B_DIN,
        B_ADDR => B_ADDR,
        -- Outputs
        A_DOUT => A_DOUT_1,
        B_DOUT => B_DOUT_1 
        );

end RTL;
