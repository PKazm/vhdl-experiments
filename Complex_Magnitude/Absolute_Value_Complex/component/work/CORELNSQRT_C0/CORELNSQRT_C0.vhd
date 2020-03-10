----------------------------------------------------------------------
-- Created by SmartDesign Thu Mar  5 18:03:32 2020
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
-- CORELNSQRT_C0 entity declaration
----------------------------------------------------------------------
entity CORELNSQRT_C0 is
    -- Port list
    port(
        -- Inputs
        INPUT_I   : in  std_logic_vector(18 downto 0);
        RESETN_I  : in  std_logic;
        START_I   : in  std_logic;
        SYS_CLK_I : in  std_logic;
        -- Outputs
        DONE_O    : out std_logic;
        LOG_O     : out std_logic_vector(23 downto 0);
        SQ_ROOT_O : out std_logic_vector(23 downto 0)
        );
end CORELNSQRT_C0;
----------------------------------------------------------------------
-- CORELNSQRT_C0 architecture body
----------------------------------------------------------------------
architecture RTL of CORELNSQRT_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CORELNSQRT   -   Actel:DirectCore:CORELNSQRT:2.0.104
component CORELNSQRT
    generic( 
        G_ARCHITECTURE     : integer := 0 ;
        G_INPUT_WIDTH      : integer := 19 ;
        G_NO_OF_ITERATIONS : integer := 25 ;
        G_OUTPUT_WIDTH     : integer := 24 
        );
    -- Port list
    port(
        -- Inputs
        INPUT_I   : in  std_logic_vector(18 downto 0);
        RESETN_I  : in  std_logic;
        START_I   : in  std_logic;
        SYS_CLK_I : in  std_logic;
        -- Outputs
        DONE_O    : out std_logic;
        LOG_O     : out std_logic_vector(23 downto 0);
        SQ_ROOT_O : out std_logic_vector(23 downto 0)
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal DONE_O_net_0      : std_logic;
signal LOG_O_0           : std_logic_vector(23 downto 0);
signal SQ_ROOT_O_0       : std_logic_vector(23 downto 0);
signal DONE_O_net_1      : std_logic;
signal LOG_O_0_net_0     : std_logic_vector(23 downto 0);
signal SQ_ROOT_O_0_net_0 : std_logic_vector(23 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 DONE_O_net_1           <= DONE_O_net_0;
 DONE_O                 <= DONE_O_net_1;
 LOG_O_0_net_0          <= LOG_O_0;
 LOG_O(23 downto 0)     <= LOG_O_0_net_0;
 SQ_ROOT_O_0_net_0      <= SQ_ROOT_O_0;
 SQ_ROOT_O(23 downto 0) <= SQ_ROOT_O_0_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CORELNSQRT_C0_0   -   Actel:DirectCore:CORELNSQRT:2.0.104
CORELNSQRT_C0_0 : CORELNSQRT
    generic map( 
        G_ARCHITECTURE     => ( 0 ),
        G_INPUT_WIDTH      => ( 19 ),
        G_NO_OF_ITERATIONS => ( 25 ),
        G_OUTPUT_WIDTH     => ( 24 )
        )
    port map( 
        -- Inputs
        RESETN_I  => RESETN_I,
        SYS_CLK_I => SYS_CLK_I,
        START_I   => START_I,
        INPUT_I   => INPUT_I,
        -- Outputs
        DONE_O    => DONE_O_net_0,
        LOG_O     => LOG_O_0,
        SQ_ROOT_O => SQ_ROOT_O_0 
        );

end RTL;
