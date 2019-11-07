----------------------------------------------------------------------
-- Created by SmartDesign Wed Nov  6 14:50:53 2019
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
-- URAM_C0 entity declaration
----------------------------------------------------------------------
entity URAM_C0 is
    -- Port list
    port(
        -- Inputs
        A_ADDR : in  std_logic_vector(8 downto 0);
        B_ADDR : in  std_logic_vector(8 downto 0);
        CLK    : in  std_logic;
        C_ADDR : in  std_logic_vector(8 downto 0);
        C_BLK  : in  std_logic;
        C_DIN  : in  std_logic_vector(7 downto 0);
        -- Outputs
        A_DOUT : out std_logic_vector(7 downto 0);
        B_DOUT : out std_logic_vector(7 downto 0)
        );
end URAM_C0;
----------------------------------------------------------------------
-- URAM_C0 architecture body
----------------------------------------------------------------------
architecture RTL of URAM_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- URAM_C0_URAM_C0_0_URAM   -   Actel:SgCore:URAM:1.0.101
component URAM_C0_URAM_C0_0_URAM
    -- Port list
    port(
        -- Inputs
        A_ADDR : in  std_logic_vector(8 downto 0);
        B_ADDR : in  std_logic_vector(8 downto 0);
        CLK    : in  std_logic;
        C_ADDR : in  std_logic_vector(8 downto 0);
        C_BLK  : in  std_logic;
        C_DIN  : in  std_logic_vector(7 downto 0);
        -- Outputs
        A_DOUT : out std_logic_vector(7 downto 0);
        B_DOUT : out std_logic_vector(7 downto 0)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal A_DOUT_0       : std_logic_vector(7 downto 0);
signal B_DOUT_0       : std_logic_vector(7 downto 0);
signal A_DOUT_0_net_0 : std_logic_vector(7 downto 0);
signal B_DOUT_0_net_0 : std_logic_vector(7 downto 0);
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
 A_DOUT_0_net_0     <= A_DOUT_0;
 A_DOUT(7 downto 0) <= A_DOUT_0_net_0;
 B_DOUT_0_net_0     <= B_DOUT_0;
 B_DOUT(7 downto 0) <= B_DOUT_0_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- URAM_C0_0   -   Actel:SgCore:URAM:1.0.101
URAM_C0_0 : URAM_C0_URAM_C0_0_URAM
    port map( 
        -- Inputs
        C_BLK  => C_BLK,
        CLK    => CLK,
        C_DIN  => C_DIN,
        A_ADDR => A_ADDR,
        B_ADDR => B_ADDR,
        C_ADDR => C_ADDR,
        -- Outputs
        A_DOUT => A_DOUT_0,
        B_DOUT => B_DOUT_0 
        );

end RTL;
