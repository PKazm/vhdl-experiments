----------------------------------------------------------------------
-- Created by SmartDesign Sat Oct 26 17:24:36 2019
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
-- Blinking_System entity declaration
----------------------------------------------------------------------
entity Blinking_System is
    -- Port list
    port(
        -- Inputs
        Board_Buttons : in    std_logic_vector(1 downto 0);
        DEVRST_N      : in    std_logic;
        -- Outputs
        Board_J7      : out   std_logic_vector(4 downto 0);
        Board_LEDs    : out   std_logic_vector(7 downto 0);
        Board_MOD1    : out   std_logic_vector(5 downto 0);
        -- Inouts
        Light_SCL     : inout std_logic;
        Light_SDA     : inout std_logic
        );
end Blinking_System;
----------------------------------------------------------------------
-- Blinking_System architecture body
----------------------------------------------------------------------
architecture RTL of Blinking_System is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- AND2
component AND2
    -- Port list
    port(
        -- Inputs
        A : in  std_logic;
        B : in  std_logic;
        -- Outputs
        Y : out std_logic
        );
end component;
-- BIBUF
component BIBUF
    generic( 
        IOSTD : string := "" 
        );
    -- Port list
    port(
        -- Inputs
        D   : in    std_logic;
        E   : in    std_logic;
        -- Outputs
        Y   : out   std_logic;
        -- Inouts
        PAD : inout std_logic
        );
end component;
-- COREABC_C0
component COREABC_C0
    -- Port list
    port(
        -- Inputs
        INTREQ    : in  std_logic;
        IO_IN     : in  std_logic_vector(0 to 0);
        NSYSRESET : in  std_logic;
        PCLK      : in  std_logic;
        PRDATA_M  : in  std_logic_vector(7 downto 0);
        PREADY_M  : in  std_logic;
        PSLVERR_M : in  std_logic;
        -- Outputs
        INTACT    : out std_logic;
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
        PRDATAS1  : in  std_logic_vector(31 downto 0);
        PRDATAS2  : in  std_logic_vector(31 downto 0);
        PREADYS1  : in  std_logic;
        PREADYS2  : in  std_logic;
        PSEL      : in  std_logic;
        PSLVERRS1 : in  std_logic;
        PSLVERRS2 : in  std_logic;
        PWDATA    : in  std_logic_vector(31 downto 0);
        PWRITE    : in  std_logic;
        -- Outputs
        PADDRS    : out std_logic_vector(31 downto 0);
        PENABLES  : out std_logic;
        PRDATA    : out std_logic_vector(31 downto 0);
        PREADY    : out std_logic;
        PSELS1    : out std_logic;
        PSELS2    : out std_logic;
        PSLVERR   : out std_logic;
        PWDATAS   : out std_logic_vector(31 downto 0);
        PWRITES   : out std_logic
        );
end component;
-- COREI2C_C0
component COREI2C_C0
    -- Port list
    port(
        -- Inputs
        PADDR   : in  std_logic_vector(8 downto 0);
        PCLK    : in  std_logic;
        PENABLE : in  std_logic;
        PRESETN : in  std_logic;
        PSEL    : in  std_logic;
        PWDATA  : in  std_logic_vector(7 downto 0);
        PWRITE  : in  std_logic;
        SCLI    : in  std_logic_vector(0 to 0);
        SDAI    : in  std_logic_vector(0 to 0);
        -- Outputs
        INT     : out std_logic_vector(0 to 0);
        PRDATA  : out std_logic_vector(7 downto 0);
        SCLO    : out std_logic_vector(0 to 0);
        SDAO    : out std_logic_vector(0 to 0)
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
        GL1            : out std_logic;
        LOCK           : out std_logic
        );
end component;
-- LED_Controller
-- using entity instantiation for component LED_Controller
-- OSC_C0
component OSC_C0
    -- Port list
    port(
        -- Outputs
        RCOSC_25_50MHZ_CCC : out std_logic
        );
end component;
-- SYSRESET
component SYSRESET
    -- Port list
    port(
        -- Inputs
        DEVRST_N         : in  std_logic;
        -- Outputs
        POWER_ON_RESET_N : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal AND2_0_Y                                           : std_logic;
signal BIBUF_0_Y                                          : std_logic;
signal BIBUF_1_Y                                          : std_logic;
signal Board_J7_net_0                                     : std_logic_vector(4 downto 0);
signal Board_LEDs_net_0                                   : std_logic_vector(7 downto 0);
signal Board_MOD1_net_0                                   : std_logic_vector(5 downto 0);
signal COREABC_C0_0_APB3master_PENABLE                    : std_logic;
signal COREABC_C0_0_APB3master_PREADY                     : std_logic;
signal COREABC_C0_0_APB3master_PSELx                      : std_logic;
signal COREABC_C0_0_APB3master_PSLVERR                    : std_logic;
signal COREABC_C0_0_APB3master_PWRITE                     : std_logic;
signal COREABC_C0_0_IO_OUT                                : std_logic_vector(0 to 0);
signal COREABC_C0_0_PRESETN                               : std_logic;
signal CoreAPB3_C0_0_APBmslave1_PENABLE                   : std_logic;
signal CoreAPB3_C0_0_APBmslave1_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave1_PWRITE                    : std_logic;
signal CoreAPB3_C0_0_APBmslave2_PREADY                    : std_logic;
signal CoreAPB3_C0_0_APBmslave2_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave2_PSLVERR                   : std_logic;
signal COREI2C_C0_0_INT                                   : std_logic_vector(0 to 0);
signal COREI2C_C0_0_SCLO                                  : std_logic_vector(0 to 0);
signal COREI2C_C0_0_SDAO                                  : std_logic_vector(0 to 0);
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_GL1                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal LED_Controller_0_INT                               : std_logic;
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal SYSRESET_0_POWER_ON_RESET_N                        : std_logic;
signal Board_J7_net_1                                     : std_logic_vector(4 downto 0);
signal Board_LEDs_net_1                                   : std_logic_vector(7 downto 0);
signal Board_MOD1_net_1                                   : std_logic_vector(5 downto 0);
signal Fabric_Int_net_0                                   : std_logic_vector(7 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                                            : std_logic;
signal VCC_net                                            : std_logic;
----------------------------------------------------------------------
-- Inverted Signals
----------------------------------------------------------------------
signal E_IN_POST_INV0_0                                   : std_logic;
signal E_IN_POST_INV1_0                                   : std_logic;
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

signal CoreAPB3_C0_0_APBmslave1_PADDR                     : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PADDR_0_8to0              : std_logic_vector(8 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PADDR_0                   : std_logic_vector(8 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PADDR_1_7to0              : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PADDR_1                   : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave1_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave1_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PRDATA_0                  : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PRDATA                    : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave1_PWDATA                    : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PWDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PWDATA_0                  : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PWDATA_1_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PWDATA_1                  : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave2_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave2_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave2_PRDATA_0                  : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave2_PRDATA                    : std_logic_vector(7 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net    <= '0';
 VCC_net    <= '1';
----------------------------------------------------------------------
-- Inversions
----------------------------------------------------------------------
 E_IN_POST_INV0_0 <= NOT COREI2C_C0_0_SCLO(0);
 E_IN_POST_INV1_0 <= NOT COREI2C_C0_0_SDAO(0);
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 Board_J7_net_1         <= Board_J7_net_0;
 Board_J7(4 downto 0)   <= Board_J7_net_1;
 Board_LEDs_net_1       <= Board_LEDs_net_0;
 Board_LEDs(7 downto 0) <= Board_LEDs_net_1;
 Board_MOD1_net_1       <= Board_MOD1_net_0;
 Board_MOD1(5 downto 0) <= Board_MOD1_net_1;
----------------------------------------------------------------------
-- Concatenation assignments
----------------------------------------------------------------------
 Fabric_Int_net_0 <= ( '0' & '0' & '0' & '0' & '0' & '0' & '0' & COREI2C_C0_0_INT(0) );
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

 CoreAPB3_C0_0_APBmslave1_PADDR_0_8to0(8 downto 0) <= CoreAPB3_C0_0_APBmslave1_PADDR(8 downto 0);
 CoreAPB3_C0_0_APBmslave1_PADDR_0 <= ( CoreAPB3_C0_0_APBmslave1_PADDR_0_8to0(8 downto 0) );
 CoreAPB3_C0_0_APBmslave1_PADDR_1_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave1_PADDR(7 downto 0);
 CoreAPB3_C0_0_APBmslave1_PADDR_1 <= ( CoreAPB3_C0_0_APBmslave1_PADDR_1_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave1_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave1_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave1_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave1_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave1_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave1_PRDATA_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave1_PWDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave1_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave1_PWDATA_0 <= ( CoreAPB3_C0_0_APBmslave1_PWDATA_0_7to0(7 downto 0) );
 CoreAPB3_C0_0_APBmslave1_PWDATA_1_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave1_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave1_PWDATA_1 <= ( CoreAPB3_C0_0_APBmslave1_PWDATA_1_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave2_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave2_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave2_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave2_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave2_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave2_PRDATA_0_7to0(7 downto 0) );

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- AND2_0
AND2_0 : AND2
    port map( 
        -- Inputs
        A => FCCC_C0_0_LOCK,
        B => SYSRESET_0_POWER_ON_RESET_N,
        -- Outputs
        Y => AND2_0_Y 
        );
-- BIBUF_0
BIBUF_0 : BIBUF
    port map( 
        -- Inputs
        D   => GND_net,
        E   => E_IN_POST_INV0_0,
        -- Outputs
        Y   => BIBUF_0_Y,
        -- Inouts
        PAD => Light_SCL 
        );
-- BIBUF_1
BIBUF_1 : BIBUF
    port map( 
        -- Inputs
        D   => GND_net,
        E   => E_IN_POST_INV1_0,
        -- Outputs
        Y   => BIBUF_1_Y,
        -- Inouts
        PAD => Light_SDA 
        );
-- COREABC_C0_0
COREABC_C0_0 : COREABC_C0
    port map( 
        -- Inputs
        NSYSRESET => AND2_0_Y,
        PCLK      => FCCC_C0_0_GL0,
        INTREQ    => LED_Controller_0_INT,
        PREADY_M  => COREABC_C0_0_APB3master_PREADY,
        PSLVERR_M => COREABC_C0_0_APB3master_PSLVERR,
        PRDATA_M  => COREABC_C0_0_APB3master_PRDATA_0,
        IO_IN     => COREABC_C0_0_IO_OUT,
        -- Outputs
        PRESETN   => COREABC_C0_0_PRESETN,
        INTACT    => OPEN,
        PADDR_M   => COREABC_C0_0_APB3master_PADDR,
        PSEL_M    => COREABC_C0_0_APB3master_PSELx,
        PENABLE_M => COREABC_C0_0_APB3master_PENABLE,
        PWRITE_M  => COREABC_C0_0_APB3master_PWRITE,
        PWDATA_M  => COREABC_C0_0_APB3master_PWDATA,
        IO_OUT    => COREABC_C0_0_IO_OUT 
        );
-- CoreAPB3_C0_0
CoreAPB3_C0_0 : CoreAPB3_C0
    port map( 
        -- Inputs
        PADDR     => COREABC_C0_0_APB3master_PADDR_0,
        PSEL      => COREABC_C0_0_APB3master_PSELx,
        PENABLE   => COREABC_C0_0_APB3master_PENABLE,
        PWRITE    => COREABC_C0_0_APB3master_PWRITE,
        PWDATA    => COREABC_C0_0_APB3master_PWDATA_0,
        PRDATAS1  => CoreAPB3_C0_0_APBmslave1_PRDATA_0,
        PREADYS1  => VCC_net, -- tied to '1' from definition
        PSLVERRS1 => GND_net, -- tied to '0' from definition
        PRDATAS2  => CoreAPB3_C0_0_APBmslave2_PRDATA_0,
        PREADYS2  => CoreAPB3_C0_0_APBmslave2_PREADY,
        PSLVERRS2 => CoreAPB3_C0_0_APBmslave2_PSLVERR,
        -- Outputs
        PRDATA    => COREABC_C0_0_APB3master_PRDATA,
        PREADY    => COREABC_C0_0_APB3master_PREADY,
        PSLVERR   => COREABC_C0_0_APB3master_PSLVERR,
        PADDRS    => CoreAPB3_C0_0_APBmslave1_PADDR,
        PSELS1    => CoreAPB3_C0_0_APBmslave1_PSELx,
        PENABLES  => CoreAPB3_C0_0_APBmslave1_PENABLE,
        PWRITES   => CoreAPB3_C0_0_APBmslave1_PWRITE,
        PWDATAS   => CoreAPB3_C0_0_APBmslave1_PWDATA,
        PSELS2    => CoreAPB3_C0_0_APBmslave2_PSELx 
        );
-- COREI2C_C0_0
COREI2C_C0_0 : COREI2C_C0
    port map( 
        -- Inputs
        PCLK    => FCCC_C0_0_GL0,
        PRESETN => COREABC_C0_0_PRESETN,
        SCLI(0) => BIBUF_0_Y,
        SDAI(0) => BIBUF_1_Y,
        PADDR   => CoreAPB3_C0_0_APBmslave1_PADDR_0,
        PENABLE => CoreAPB3_C0_0_APBmslave1_PENABLE,
        PSEL    => CoreAPB3_C0_0_APBmslave1_PSELx,
        PWDATA  => CoreAPB3_C0_0_APBmslave1_PWDATA_0,
        PWRITE  => CoreAPB3_C0_0_APBmslave1_PWRITE,
        -- Outputs
        INT     => COREI2C_C0_0_INT,
        SCLO    => COREI2C_C0_0_SCLO,
        SDAO    => COREI2C_C0_0_SDAO,
        PRDATA  => CoreAPB3_C0_0_APBmslave1_PRDATA 
        );
-- FCCC_C0_0
FCCC_C0_0 : FCCC_C0
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        -- Outputs
        GL0            => FCCC_C0_0_GL0,
        LOCK           => FCCC_C0_0_LOCK,
        GL1            => FCCC_C0_0_GL1 
        );
-- LED_Controller_0
LED_Controller_0 : entity work.LED_Controller
    port map( 
        -- Inputs
        PCLK100       => FCCC_C0_0_GL0,
        CLK0_5        => FCCC_C0_0_GL1,
        PRESETN       => COREABC_C0_0_PRESETN,
        I2C_Sniff_SCL => COREI2C_C0_0_SCLO(0),
        I2C_Sniff_SDA => COREI2C_C0_0_SDAO(0),
        PADDR         => CoreAPB3_C0_0_APBmslave1_PADDR_1,
        PSEL          => CoreAPB3_C0_0_APBmslave2_PSELx,
        PENABLE       => CoreAPB3_C0_0_APBmslave1_PENABLE,
        PWRITE        => CoreAPB3_C0_0_APBmslave1_PWRITE,
        PWDATA        => CoreAPB3_C0_0_APBmslave1_PWDATA_1,
        Fabric_Int    => Fabric_Int_net_0,
        Board_Buttons => Board_Buttons,
        -- Outputs
        RST_out       => OPEN,
        PREADY        => CoreAPB3_C0_0_APBmslave2_PREADY,
        PRDATA        => CoreAPB3_C0_0_APBmslave2_PRDATA,
        PSLVERR       => CoreAPB3_C0_0_APBmslave2_PSLVERR,
        INT           => LED_Controller_0_INT,
        Board_LEDs    => Board_LEDs_net_0,
        Board_MOD1    => Board_MOD1_net_0,
        Board_J7      => Board_J7_net_0 
        );
-- OSC_C0_0
OSC_C0_0 : OSC_C0
    port map( 
        -- Outputs
        RCOSC_25_50MHZ_CCC => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC 
        );
-- SYSRESET_0
SYSRESET_0 : SYSRESET
    port map( 
        -- Inputs
        DEVRST_N         => DEVRST_N,
        -- Outputs
        POWER_ON_RESET_N => SYSRESET_0_POWER_ON_RESET_N 
        );

end RTL;
