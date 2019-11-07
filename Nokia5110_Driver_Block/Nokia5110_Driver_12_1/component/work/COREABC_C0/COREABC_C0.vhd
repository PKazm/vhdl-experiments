----------------------------------------------------------------------
-- Created by SmartDesign Wed Nov  6 15:55:43 2019
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library COREABC_LIB;
use COREABC_LIB.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_components.all;
----------------------------------------------------------------------
-- COREABC_C0 entity declaration
----------------------------------------------------------------------
entity COREABC_C0 is
    -- Port list
    port(
        -- Inputs
        IO_IN     : in  std_logic_vector(0 to 0);
        NSYSRESET : in  std_logic;
        PCLK      : in  std_logic;
        PRDATA_M  : in  std_logic_vector(7 downto 0);
        PREADY_M  : in  std_logic;
        PSLVERR_M : in  std_logic;
        -- Outputs
        IO_OUT    : out std_logic_vector(0 to 0);
        PADDR_M   : out std_logic_vector(19 downto 0);
        PENABLE_M : out std_logic;
        PRESETN   : out std_logic;
        PSEL_M    : out std_logic;
        PWDATA_M  : out std_logic_vector(7 downto 0);
        PWRITE_M  : out std_logic
        );
end COREABC_C0;
----------------------------------------------------------------------
-- COREABC_C0 architecture body
----------------------------------------------------------------------
architecture RTL of COREABC_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- COREABC_C0_COREABC_C0_0_COREABC   -   Actel:DirectCore:COREABC:3.7.101
component COREABC_C0_COREABC_C0_0_COREABC
    generic( 
        ACT_CALIBRATIONDATA : integer := 1 ;
        APB_AWIDTH          : integer := 8 ;
        APB_DWIDTH          : integer := 8 ;
        APB_SDEPTH          : integer := 2 ;
        DEBUG               : integer := 1 ;
        EN_ACM              : integer := 0 ;
        EN_ADD              : integer := 0 ;
        EN_ALURAM           : integer := 0 ;
        EN_AND              : integer := 0 ;
        EN_CALL             : integer := 0 ;
        EN_DATAM            : integer := 2 ;
        EN_INC              : integer := 1 ;
        EN_INDIRECT         : integer := 0 ;
        EN_INT              : integer := 0 ;
        EN_IOREAD           : integer := 0 ;
        EN_IOWRT            : integer := 0 ;
        EN_MULT             : integer := 0 ;
        EN_OR               : integer := 0 ;
        EN_PUSH             : integer := 0 ;
        EN_RAM              : integer := 1 ;
        EN_SHL              : integer := 0 ;
        EN_SHR              : integer := 0 ;
        EN_XOR              : integer := 1 ;
        FAMILY              : integer := 19 ;
        ICWIDTH             : integer := 4 ;
        IFWIDTH             : integer := 0 ;
        IIWIDTH             : integer := 1 ;
        IMEM_APB_ACCESS     : integer := 0 ;
        INITWIDTH           : integer := 11 ;
        INSMODE             : integer := 0 ;
        IOWIDTH             : integer := 1 ;
        ISRADDR             : integer := 1 ;
        MAX_NVMDWIDTH       : integer := 32 ;
        STWIDTH             : integer := 4 ;
        TESTMODE            : integer := 0 ;
        UNIQ_STRING_LENGTH  : integer := 23 ;
        ZRWIDTH             : integer := 0 
        );
    -- Port list
    port(
        -- Inputs
        INITADDR   : in  std_logic_vector(10 downto 0);
        INITDATA   : in  std_logic_vector(8 downto 0);
        INITDATVAL : in  std_logic;
        INITDONE   : in  std_logic;
        INTREQ     : in  std_logic;
        IO_IN      : in  std_logic_vector(0 to 0);
        NSYSRESET  : in  std_logic;
        PADDR_S    : in  std_logic_vector(7 downto 0);
        PCLK       : in  std_logic;
        PENABLE_S  : in  std_logic;
        PRDATA_M   : in  std_logic_vector(7 downto 0);
        PREADY_M   : in  std_logic;
        PSEL_S     : in  std_logic;
        PSLVERR_M  : in  std_logic;
        PWDATA_S   : in  std_logic_vector(7 downto 0);
        PWRITE_S   : in  std_logic;
        -- Outputs
        INTACT     : out std_logic;
        IO_OUT     : out std_logic_vector(0 to 0);
        PADDR_M    : out std_logic_vector(19 downto 0);
        PENABLE_M  : out std_logic;
        PRDATA_S   : out std_logic_vector(7 downto 0);
        PREADY_S   : out std_logic;
        PRESETN    : out std_logic;
        PSEL_M     : out std_logic;
        PSLVERR_S  : out std_logic;
        PWDATA_M   : out std_logic_vector(7 downto 0);
        PWRITE_M   : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal APB3master_PADDR         : std_logic_vector(19 downto 0);
signal APB3master_PENABLE       : std_logic;
signal APB3master_PSELx         : std_logic;
signal APB3master_PWDATA        : std_logic_vector(7 downto 0);
signal APB3master_PWRITE        : std_logic;
signal IO_OUT_net_0             : std_logic_vector(0 to 0);
signal PRESETN_net_0            : std_logic;
signal PRESETN_net_1            : std_logic;
signal APB3master_PSELx_net_0   : std_logic;
signal APB3master_PENABLE_net_0 : std_logic;
signal APB3master_PWRITE_net_0  : std_logic;
signal IO_OUT_net_1             : std_logic_vector(0 to 0);
signal APB3master_PADDR_net_0   : std_logic_vector(19 downto 0);
signal APB3master_PWDATA_net_0  : std_logic_vector(7 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                  : std_logic;
signal VCC_net                  : std_logic;
signal INITADDR_const_net_0     : std_logic_vector(10 downto 0);
signal INITDATA_const_net_0     : std_logic_vector(8 downto 0);
signal PADDR_S_const_net_0      : std_logic_vector(7 downto 0);
signal PWDATA_S_const_net_0     : std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net              <= '0';
 VCC_net              <= '1';
 INITADDR_const_net_0 <= B"00000000000";
 INITDATA_const_net_0 <= B"000000000";
 PADDR_S_const_net_0  <= B"00000000";
 PWDATA_S_const_net_0 <= B"00000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 PRESETN_net_1            <= PRESETN_net_0;
 PRESETN                  <= PRESETN_net_1;
 APB3master_PSELx_net_0   <= APB3master_PSELx;
 PSEL_M                   <= APB3master_PSELx_net_0;
 APB3master_PENABLE_net_0 <= APB3master_PENABLE;
 PENABLE_M                <= APB3master_PENABLE_net_0;
 APB3master_PWRITE_net_0  <= APB3master_PWRITE;
 PWRITE_M                 <= APB3master_PWRITE_net_0;
 IO_OUT_net_1(0)          <= IO_OUT_net_0(0);
 IO_OUT(0)                <= IO_OUT_net_1(0);
 APB3master_PADDR_net_0   <= APB3master_PADDR;
 PADDR_M(19 downto 0)     <= APB3master_PADDR_net_0;
 APB3master_PWDATA_net_0  <= APB3master_PWDATA;
 PWDATA_M(7 downto 0)     <= APB3master_PWDATA_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- COREABC_C0_0   -   Actel:DirectCore:COREABC:3.7.101
COREABC_C0_0 : COREABC_C0_COREABC_C0_0_COREABC
    generic map( 
        ACT_CALIBRATIONDATA => ( 1 ),
        APB_AWIDTH          => ( 8 ),
        APB_DWIDTH          => ( 8 ),
        APB_SDEPTH          => ( 2 ),
        DEBUG               => ( 1 ),
        EN_ACM              => ( 0 ),
        EN_ADD              => ( 0 ),
        EN_ALURAM           => ( 0 ),
        EN_AND              => ( 0 ),
        EN_CALL             => ( 0 ),
        EN_DATAM            => ( 2 ),
        EN_INC              => ( 1 ),
        EN_INDIRECT         => ( 0 ),
        EN_INT              => ( 0 ),
        EN_IOREAD           => ( 0 ),
        EN_IOWRT            => ( 0 ),
        EN_MULT             => ( 0 ),
        EN_OR               => ( 0 ),
        EN_PUSH             => ( 0 ),
        EN_RAM              => ( 1 ),
        EN_SHL              => ( 0 ),
        EN_SHR              => ( 0 ),
        EN_XOR              => ( 1 ),
        FAMILY              => ( 19 ),
        ICWIDTH             => ( 4 ),
        IFWIDTH             => ( 0 ),
        IIWIDTH             => ( 1 ),
        IMEM_APB_ACCESS     => ( 0 ),
        INITWIDTH           => ( 11 ),
        INSMODE             => ( 0 ),
        IOWIDTH             => ( 1 ),
        ISRADDR             => ( 1 ),
        MAX_NVMDWIDTH       => ( 32 ),
        STWIDTH             => ( 4 ),
        TESTMODE            => ( 0 ),
        UNIQ_STRING_LENGTH  => ( 23 ),
        ZRWIDTH             => ( 0 )
        )
    port map( 
        -- Inputs
        INITDATVAL => GND_net, -- tied to '0' from definition
        INITDONE   => VCC_net, -- tied to '1' from definition
        INTREQ     => GND_net, -- tied to '0' from definition
        NSYSRESET  => NSYSRESET,
        PCLK       => PCLK,
        PREADY_M   => PREADY_M,
        PSLVERR_M  => PSLVERR_M,
        PSEL_S     => GND_net, -- tied to '0' from definition
        PENABLE_S  => GND_net, -- tied to '0' from definition
        PWRITE_S   => GND_net, -- tied to '0' from definition
        INITADDR   => INITADDR_const_net_0, -- tied to X"0" from definition
        INITDATA   => INITDATA_const_net_0, -- tied to X"0" from definition
        IO_IN      => IO_IN,
        PRDATA_M   => PRDATA_M,
        PADDR_S    => PADDR_S_const_net_0, -- tied to X"0" from definition
        PWDATA_S   => PWDATA_S_const_net_0, -- tied to X"0" from definition
        -- Outputs
        INTACT     => OPEN,
        PRESETN    => PRESETN_net_0,
        PENABLE_M  => APB3master_PENABLE,
        PSEL_M     => APB3master_PSELx,
        PWRITE_M   => APB3master_PWRITE,
        PREADY_S   => OPEN,
        PSLVERR_S  => OPEN,
        IO_OUT     => IO_OUT_net_0,
        PADDR_M    => APB3master_PADDR,
        PWDATA_M   => APB3master_PWDATA,
        PRDATA_S   => OPEN 
        );

end RTL;
