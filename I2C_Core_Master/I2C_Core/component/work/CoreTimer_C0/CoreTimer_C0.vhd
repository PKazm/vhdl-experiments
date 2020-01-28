----------------------------------------------------------------------
-- Created by SmartDesign Sun Jan 26 17:25:48 2020
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library CORETIMER_LIB;
use CORETIMER_LIB.all;
----------------------------------------------------------------------
-- CoreTimer_C0 entity declaration
----------------------------------------------------------------------
entity CoreTimer_C0 is
    -- Port list
    port(
        -- Inputs
        PADDR   : in  std_logic_vector(4 downto 2);
        PCLK    : in  std_logic;
        PENABLE : in  std_logic;
        PRESETn : in  std_logic;
        PSEL    : in  std_logic;
        PWDATA  : in  std_logic_vector(31 downto 0);
        PWRITE  : in  std_logic;
        -- Outputs
        PRDATA  : out std_logic_vector(31 downto 0);
        TIMINT  : out std_logic
        );
end CoreTimer_C0;
----------------------------------------------------------------------
-- CoreTimer_C0 architecture body
----------------------------------------------------------------------
architecture RTL of CoreTimer_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CoreTimer   -   Actel:DirectCore:CoreTimer:2.0.103
component CoreTimer
    generic( 
        FAMILY     : integer := 19 ;
        INTACTIVEH : integer := 1 ;
        WIDTH      : integer := 16 
        );
    -- Port list
    port(
        -- Inputs
        PADDR   : in  std_logic_vector(4 downto 2);
        PCLK    : in  std_logic;
        PENABLE : in  std_logic;
        PRESETn : in  std_logic;
        PSEL    : in  std_logic;
        PWDATA  : in  std_logic_vector(31 downto 0);
        PWRITE  : in  std_logic;
        -- Outputs
        PRDATA  : out std_logic_vector(31 downto 0);
        TIMINT  : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal APBslave_PRDATA       : std_logic_vector(31 downto 0);
signal TIMINT_net_0          : std_logic;
signal TIMINT_net_1          : std_logic;
signal APBslave_PRDATA_net_0 : std_logic_vector(31 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 TIMINT_net_1          <= TIMINT_net_0;
 TIMINT                <= TIMINT_net_1;
 APBslave_PRDATA_net_0 <= APBslave_PRDATA;
 PRDATA(31 downto 0)   <= APBslave_PRDATA_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CoreTimer_C0_0   -   Actel:DirectCore:CoreTimer:2.0.103
CoreTimer_C0_0 : CoreTimer
    generic map( 
        FAMILY     => ( 19 ),
        INTACTIVEH => ( 1 ),
        WIDTH      => ( 16 )
        )
    port map( 
        -- Inputs
        PCLK    => PCLK,
        PRESETn => PRESETn,
        PSEL    => PSEL,
        PADDR   => PADDR,
        PWRITE  => PWRITE,
        PENABLE => PENABLE,
        PWDATA  => PWDATA,
        -- Outputs
        PRDATA  => APBslave_PRDATA,
        TIMINT  => TIMINT_net_0 
        );

end RTL;
