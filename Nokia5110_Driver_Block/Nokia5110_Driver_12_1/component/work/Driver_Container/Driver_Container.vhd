----------------------------------------------------------------------
-- Created by SmartDesign Fri Nov 15 23:08:20 2019
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
-- Driver_Container entity declaration
----------------------------------------------------------------------
entity Driver_Container is
    -- Port list
    port(
        -- Outputs
        Board_J10 : out std_logic;
        Board_J11 : out std_logic;
        Board_J7  : out std_logic_vector(0 to 4);
        Board_J9  : out std_logic
        );
end Driver_Container;
----------------------------------------------------------------------
-- Driver_Container architecture body
----------------------------------------------------------------------
architecture RTL of Driver_Container is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- COREABC_C0
component COREABC_C0
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
end component;
-- CoreAPB3_C0
component CoreAPB3_C0
    -- Port list
    port(
        -- Inputs
        PADDR     : in  std_logic_vector(31 downto 0);
        PENABLE   : in  std_logic;
        PRDATAS0  : in  std_logic_vector(31 downto 0);
        PREADYS0  : in  std_logic;
        PSEL      : in  std_logic;
        PSLVERRS0 : in  std_logic;
        PWDATA    : in  std_logic_vector(31 downto 0);
        PWRITE    : in  std_logic;
        -- Outputs
        PADDRS    : out std_logic_vector(31 downto 0);
        PENABLES  : out std_logic;
        PRDATA    : out std_logic_vector(31 downto 0);
        PREADY    : out std_logic;
        PSELS0    : out std_logic;
        PSLVERR   : out std_logic;
        PWDATAS   : out std_logic_vector(31 downto 0);
        PWRITES   : out std_logic
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
-- Nokia5110_Driver_Block_SD
component Nokia5110_Driver_Block_SD
    -- Port list
    port(
        -- Inputs
        CLK          : in  std_logic;
        PADDR        : in  std_logic_vector(7 downto 0);
        PENABLE      : in  std_logic;
        PSEL         : in  std_logic;
        PWDATA       : in  std_logic_vector(7 downto 0);
        PWRITE       : in  std_logic;
        RSTn         : in  std_logic;
        -- Outputs
        PRDATA       : out std_logic_vector(7 downto 0);
        PREADY       : out std_logic;
        PSLVERR      : out std_logic;
        RSTout       : out std_logic;
        SPICLK       : out std_logic;
        SPIDO        : out std_logic;
        chip_enable  : out std_logic;
        data_command : out std_logic;
        driver_busy  : out std_logic
        );
end component;
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
signal Board_J7_net_0                                     : std_logic;
signal Board_J7_0                                         : std_logic;
signal Board_J9_net_0                                     : std_logic;
signal Board_J10_net_0                                    : std_logic;
signal Board_J11_net_0                                    : std_logic;
signal COREABC_C0_0_APB3master_PENABLE                    : std_logic;
signal COREABC_C0_0_APB3master_PREADY                     : std_logic;
signal COREABC_C0_0_APB3master_PSELx                      : std_logic;
signal COREABC_C0_0_APB3master_PSLVERR                    : std_logic;
signal COREABC_C0_0_APB3master_PWRITE                     : std_logic;
signal COREABC_C0_0_IO_OUT                                : std_logic_vector(0 to 0);
signal COREABC_C0_0_PRESETN                               : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PENABLE                   : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PREADY                    : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PSLVERR                   : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PWRITE                    : std_logic;
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal Board_J11_net_1                                    : std_logic;
signal Board_J9_net_1                                     : std_logic;
signal Board_J10_net_1                                    : std_logic;
signal Board_J7_net_1                                     : std_logic_vector(1 to 1);
signal Board_J7_0_net_0                                   : std_logic_vector(4 to 4);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                                            : std_logic;
signal VCC_net                                            : std_logic;
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal COREABC_C0_0_APB3master_PADDR_0_31to20             : std_logic_vector(31 downto 20);
signal COREABC_C0_0_APB3master_PADDR_0_19to0              : std_logic_vector(19 downto 0);
signal COREABC_C0_0_APB3master_PADDR_0                    : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PADDR                      : std_logic_vector(19 downto 0);

signal COREABC_C0_0_APB3master_PRDATA                     : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0_7to0              : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0                   : std_logic_vector(7 downto 0);

signal COREABC_C0_0_APB3master_PWDATA_0_31to8             : std_logic_vector(31 downto 8);
signal COREABC_C0_0_APB3master_PWDATA_0_7to0              : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PWDATA_0                   : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PWDATA                     : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0              : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_0                   : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR                     : std_logic_vector(31 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PRDATA                    : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0                  : std_logic_vector(31 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_0                  : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA                    : std_logic_vector(31 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net    <= '0';
 VCC_net    <= '1';
----------------------------------------------------------------------
-- TieOff assignments
----------------------------------------------------------------------
 Board_J7(0)         <= '0';
 Board_J7(2)         <= '0';
 Board_J7(3)         <= '1';
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 Board_J11_net_1     <= Board_J11_net_0;
 Board_J11           <= Board_J11_net_1;
 Board_J9_net_1      <= Board_J9_net_0;
 Board_J9            <= Board_J9_net_1;
 Board_J10_net_1     <= Board_J10_net_0;
 Board_J10           <= Board_J10_net_1;
 Board_J7_net_1(1)   <= Board_J7_net_0;
 Board_J7(1)         <= Board_J7_net_1(1);
 Board_J7_0_net_0(4) <= Board_J7_0;
 Board_J7(4)         <= Board_J7_0_net_0(4);
----------------------------------------------------------------------
-- Bus Interface Nets Assignments - Unequal Pin Widths
----------------------------------------------------------------------
 COREABC_C0_0_APB3master_PADDR_0_31to20(31 downto 20) <= B"000000000000";
 COREABC_C0_0_APB3master_PADDR_0_19to0(19 downto 0) <= COREABC_C0_0_APB3master_PADDR(19 downto 0);
 COREABC_C0_0_APB3master_PADDR_0 <= ( COREABC_C0_0_APB3master_PADDR_0_31to20(31 downto 20) & COREABC_C0_0_APB3master_PADDR_0_19to0(19 downto 0) );

 COREABC_C0_0_APB3master_PRDATA_0_7to0(7 downto 0) <= COREABC_C0_0_APB3master_PRDATA(7 downto 0);
 COREABC_C0_0_APB3master_PRDATA_0 <= ( COREABC_C0_0_APB3master_PRDATA_0_7to0(7 downto 0) );

 COREABC_C0_0_APB3master_PWDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 COREABC_C0_0_APB3master_PWDATA_0_7to0(7 downto 0) <= COREABC_C0_0_APB3master_PWDATA(7 downto 0);
 COREABC_C0_0_APB3master_PWDATA_0 <= ( COREABC_C0_0_APB3master_PWDATA_0_31to8(31 downto 8) & COREABC_C0_0_APB3master_PWDATA_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PADDR(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PADDR_0 <= ( CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PWDATA_0 <= ( CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0(7 downto 0) );

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- COREABC_C0_0
COREABC_C0_0 : COREABC_C0
    port map( 
        -- Inputs
        NSYSRESET => FCCC_C0_0_LOCK,
        PCLK      => FCCC_C0_0_GL0,
        PREADY_M  => COREABC_C0_0_APB3master_PREADY,
        PSLVERR_M => COREABC_C0_0_APB3master_PSLVERR,
        IO_IN     => COREABC_C0_0_IO_OUT,
        PRDATA_M  => COREABC_C0_0_APB3master_PRDATA_0,
        -- Outputs
        PRESETN   => COREABC_C0_0_PRESETN,
        PSEL_M    => COREABC_C0_0_APB3master_PSELx,
        PENABLE_M => COREABC_C0_0_APB3master_PENABLE,
        PWRITE_M  => COREABC_C0_0_APB3master_PWRITE,
        IO_OUT    => COREABC_C0_0_IO_OUT,
        PADDR_M   => COREABC_C0_0_APB3master_PADDR,
        PWDATA_M  => COREABC_C0_0_APB3master_PWDATA 
        );
-- CoreAPB3_C0_0
CoreAPB3_C0_0 : CoreAPB3_C0
    port map( 
        -- Inputs
        PSEL      => COREABC_C0_0_APB3master_PSELx,
        PENABLE   => COREABC_C0_0_APB3master_PENABLE,
        PWRITE    => COREABC_C0_0_APB3master_PWRITE,
        PREADYS0  => CoreAPB3_C0_0_APBmslave0_PREADY,
        PSLVERRS0 => CoreAPB3_C0_0_APBmslave0_PSLVERR,
        PADDR     => COREABC_C0_0_APB3master_PADDR_0,
        PWDATA    => COREABC_C0_0_APB3master_PWDATA_0,
        PRDATAS0  => CoreAPB3_C0_0_APBmslave0_PRDATA_0,
        -- Outputs
        PREADY    => COREABC_C0_0_APB3master_PREADY,
        PSLVERR   => COREABC_C0_0_APB3master_PSLVERR,
        PSELS0    => CoreAPB3_C0_0_APBmslave0_PSELx,
        PENABLES  => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITES   => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PRDATA    => COREABC_C0_0_APB3master_PRDATA,
        PADDRS    => CoreAPB3_C0_0_APBmslave0_PADDR,
        PWDATAS   => CoreAPB3_C0_0_APBmslave0_PWDATA 
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
-- Nokia5110_Driver_Block_SD_0
Nokia5110_Driver_Block_SD_0 : Nokia5110_Driver_Block_SD
    port map( 
        -- Inputs
        PENABLE      => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE       => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PSEL         => CoreAPB3_C0_0_APBmslave0_PSELx,
        CLK          => FCCC_C0_0_GL0,
        RSTn         => COREABC_C0_0_PRESETN,
        PADDR        => CoreAPB3_C0_0_APBmslave0_PADDR_0,
        PWDATA       => CoreAPB3_C0_0_APBmslave0_PWDATA_0,
        -- Outputs
        RSTout       => Board_J7_net_0,
        driver_busy  => OPEN,
        SPIDO        => Board_J7_0,
        SPICLK       => Board_J9_net_0,
        data_command => Board_J10_net_0,
        chip_enable  => Board_J11_net_0,
        PREADY       => CoreAPB3_C0_0_APBmslave0_PREADY,
        PSLVERR      => CoreAPB3_C0_0_APBmslave0_PSLVERR,
        PRDATA       => CoreAPB3_C0_0_APBmslave0_PRDATA 
        );
-- OSC_C0_0
OSC_C0_0 : OSC_C0
    port map( 
        -- Outputs
        RCOSC_25_50MHZ_CCC => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC 
        );

end RTL;
