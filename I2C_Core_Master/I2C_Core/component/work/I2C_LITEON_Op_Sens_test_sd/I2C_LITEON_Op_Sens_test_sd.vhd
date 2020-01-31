----------------------------------------------------------------------
-- Created by SmartDesign Thu Jan 30 23:47:41 2020
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
-- I2C_LITEON_Op_Sens_test_sd entity declaration
----------------------------------------------------------------------
entity I2C_LITEON_Op_Sens_test_sd is
    -- Port list
    port(
        -- Inputs
        Board_Buttons : in    std_logic_vector(1 downto 0);
        DEVRST_N      : in    std_logic;
        -- Outputs
        Board_J10     : out   std_logic;
        Board_J11     : out   std_logic;
        Board_J8      : out   std_logic;
        Board_J9      : out   std_logic;
        Board_LEDs    : out   std_logic_vector(7 downto 0);
        -- Inouts
        Light_SCL     : inout std_logic;
        Light_SDA     : inout std_logic
        );
end I2C_LITEON_Op_Sens_test_sd;
----------------------------------------------------------------------
-- I2C_LITEON_Op_Sens_test_sd architecture body
----------------------------------------------------------------------
architecture RTL of I2C_LITEON_Op_Sens_test_sd is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- AND4
component AND4
    -- Port list
    port(
        -- Inputs
        A : in  std_logic;
        B : in  std_logic;
        C : in  std_logic;
        D : in  std_logic;
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
        PRDATA_M  : in  std_logic_vector(15 downto 0);
        PREADY_M  : in  std_logic;
        PSLVERR_M : in  std_logic;
        -- Outputs
        INTACT    : out std_logic;
        IO_OUT    : out std_logic_vector(7 downto 0);
        PADDR_M   : out std_logic_vector(19 downto 0);
        PENABLE_M : out std_logic;
        PRESETN   : out std_logic;
        PSEL_M    : out std_logic;
        PWDATA_M  : out std_logic_vector(15 downto 0);
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
        PRDATAS1  : in  std_logic_vector(31 downto 0);
        PRDATAS2  : in  std_logic_vector(31 downto 0);
        PREADYS0  : in  std_logic;
        PREADYS1  : in  std_logic;
        PREADYS2  : in  std_logic;
        PSEL      : in  std_logic;
        PSLVERRS0 : in  std_logic;
        PSLVERRS1 : in  std_logic;
        PSLVERRS2 : in  std_logic;
        PWDATA    : in  std_logic_vector(31 downto 0);
        PWRITE    : in  std_logic;
        -- Outputs
        PADDRS    : out std_logic_vector(31 downto 0);
        PENABLES  : out std_logic;
        PRDATA    : out std_logic_vector(31 downto 0);
        PREADY    : out std_logic;
        PSELS0    : out std_logic;
        PSELS1    : out std_logic;
        PSELS2    : out std_logic;
        PSLVERR   : out std_logic;
        PWDATAS   : out std_logic_vector(31 downto 0);
        PWRITES   : out std_logic
        );
end component;
-- CoreTimer_C0
component CoreTimer_C0
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
-- I2C_Core_APB3
-- using entity instantiation for component I2C_Core_APB3
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
signal AND4_0_Y                                           : std_logic;
signal Board_Buttons_slice_0                              : std_logic_vector(1 to 1);
signal Board_Buttons_slice_1                              : std_logic_vector(0 to 0);
signal Board_J10_net_0                                    : std_logic;
signal Board_J11_net_0                                    : std_logic;
signal Board_LEDs_net_0                                   : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PENABLE                    : std_logic;
signal COREABC_C0_0_APB3master_PREADY                     : std_logic;
signal COREABC_C0_0_APB3master_PSELx                      : std_logic;
signal COREABC_C0_0_APB3master_PSLVERR                    : std_logic;
signal COREABC_C0_0_APB3master_PWRITE                     : std_logic;
signal COREABC_C0_0_PRESETN                               : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PENABLE                   : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PREADY                    : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PSLVERR                   : std_logic;
signal CoreAPB3_C0_0_APBmslave0_PWRITE                    : std_logic;
signal CoreAPB3_C0_0_APBmslave1_PRDATA                    : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave2_PREADY                    : std_logic;
signal CoreAPB3_C0_0_APBmslave2_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave2_PSLVERR                   : std_logic;
signal CoreTimer_C0_0_TIMINT                              : std_logic;
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_GL1                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal I2C_Core_APB3_0_INT                                : std_logic;
signal I2C_Core_APB3_0_SCLE                               : std_logic;
signal I2C_Core_APB3_0_SCLO                               : std_logic;
signal I2C_Core_APB3_0_SDAE                               : std_logic;
signal I2C_Core_APB3_0_SDAO                               : std_logic;
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal SYSRESET_0_POWER_ON_RESET_N                        : std_logic;
signal Board_J11_net_1                                    : std_logic;
signal Board_J10_net_1                                    : std_logic;
signal Board_LEDs_net_1                                   : std_logic_vector(7 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net                                            : std_logic;
signal Fabric_Int_const_net_0                             : std_logic_vector(7 downto 0);
signal Board_Buttons_const_net_0                          : std_logic_vector(1 downto 0);
signal VCC_net                                            : std_logic;
----------------------------------------------------------------------
-- Inverted Signals
----------------------------------------------------------------------
signal C_IN_POST_INV0_0                                   : std_logic;
signal D_IN_POST_INV1_0                                   : std_logic;
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal COREABC_C0_0_APB3master_PADDR_0_31to20             : std_logic_vector(31 downto 20);
signal COREABC_C0_0_APB3master_PADDR_0_19to0              : std_logic_vector(19 downto 0);
signal COREABC_C0_0_APB3master_PADDR_0                    : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PADDR                      : std_logic_vector(19 downto 0);

signal COREABC_C0_0_APB3master_PRDATA                     : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0_15to0             : std_logic_vector(15 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0                   : std_logic_vector(15 downto 0);

signal COREABC_C0_0_APB3master_PWDATA_0_31to16            : std_logic_vector(31 downto 16);
signal COREABC_C0_0_APB3master_PWDATA_0_15to0             : std_logic_vector(15 downto 0);
signal COREABC_C0_0_APB3master_PWDATA_0                   : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PWDATA                     : std_logic_vector(15 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PADDR                     : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_1_4to2              : std_logic_vector(4 downto 2);
signal CoreAPB3_C0_0_APBmslave0_PADDR_1                   : std_logic_vector(4 downto 2);
signal CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0              : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_0                   : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_2_7to0              : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_2                   : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0                  : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PRDATA                    : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PWDATA                    : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_0                  : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_1_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_1                  : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave2_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave2_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave2_PRDATA_0                  : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave2_PRDATA                    : std_logic_vector(7 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 GND_net                   <= '0';
 Fabric_Int_const_net_0    <= B"00000000";
 Board_Buttons_const_net_0 <= B"00";
 VCC_net                   <= '1';
----------------------------------------------------------------------
-- Inversions
----------------------------------------------------------------------
 C_IN_POST_INV0_0 <= NOT Board_Buttons_slice_0(1);
 D_IN_POST_INV1_0 <= NOT Board_Buttons_slice_1(0);
----------------------------------------------------------------------
-- TieOff assignments
----------------------------------------------------------------------
 Board_J9               <= '0';
 Board_J8               <= '0';
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 Board_J11_net_1        <= Board_J11_net_0;
 Board_J11              <= Board_J11_net_1;
 Board_J10_net_1        <= Board_J10_net_0;
 Board_J10              <= Board_J10_net_1;
 Board_LEDs_net_1       <= Board_LEDs_net_0;
 Board_LEDs(7 downto 0) <= Board_LEDs_net_1;
----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
 Board_Buttons_slice_0(1) <= Board_Buttons(1);
 Board_Buttons_slice_1(0) <= Board_Buttons(0);
----------------------------------------------------------------------
-- Bus Interface Nets Assignments - Unequal Pin Widths
----------------------------------------------------------------------
 COREABC_C0_0_APB3master_PADDR_0_31to20(31 downto 20) <= B"000000000000";
 COREABC_C0_0_APB3master_PADDR_0_19to0(19 downto 0) <= COREABC_C0_0_APB3master_PADDR(19 downto 0);
 COREABC_C0_0_APB3master_PADDR_0 <= ( COREABC_C0_0_APB3master_PADDR_0_31to20(31 downto 20) & COREABC_C0_0_APB3master_PADDR_0_19to0(19 downto 0) );

 COREABC_C0_0_APB3master_PRDATA_0_15to0(15 downto 0) <= COREABC_C0_0_APB3master_PRDATA(15 downto 0);
 COREABC_C0_0_APB3master_PRDATA_0 <= ( COREABC_C0_0_APB3master_PRDATA_0_15to0(15 downto 0) );

 COREABC_C0_0_APB3master_PWDATA_0_31to16(31 downto 16) <= B"0000000000000000";
 COREABC_C0_0_APB3master_PWDATA_0_15to0(15 downto 0) <= COREABC_C0_0_APB3master_PWDATA(15 downto 0);
 COREABC_C0_0_APB3master_PWDATA_0 <= ( COREABC_C0_0_APB3master_PWDATA_0_31to16(31 downto 16) & COREABC_C0_0_APB3master_PWDATA_0_15to0(15 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PADDR_1_4to2(4 downto 2) <= CoreAPB3_C0_0_APBmslave0_PADDR(4 downto 2);
 CoreAPB3_C0_0_APBmslave0_PADDR_1 <= ( CoreAPB3_C0_0_APBmslave0_PADDR_1_4to2(4 downto 2) );
 CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PADDR(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PADDR_0 <= ( CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0(7 downto 0) );
 CoreAPB3_C0_0_APBmslave0_PADDR_2_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PADDR(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PADDR_2 <= ( CoreAPB3_C0_0_APBmslave0_PADDR_2_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PWDATA_0 <= ( CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0(7 downto 0) );
 CoreAPB3_C0_0_APBmslave0_PWDATA_1_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PWDATA_1 <= ( CoreAPB3_C0_0_APBmslave0_PWDATA_1_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave2_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave2_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave2_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave2_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave2_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave2_PRDATA_0_7to0(7 downto 0) );

----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- AND4_0
AND4_0 : AND4
    port map( 
        -- Inputs
        A => FCCC_C0_0_LOCK,
        B => SYSRESET_0_POWER_ON_RESET_N,
        C => C_IN_POST_INV0_0,
        D => D_IN_POST_INV1_0,
        -- Outputs
        Y => AND4_0_Y 
        );
-- BIBUF_0
BIBUF_0 : BIBUF
    port map( 
        -- Inputs
        D   => I2C_Core_APB3_0_SDAO,
        E   => I2C_Core_APB3_0_SDAE,
        -- Outputs
        Y   => Board_J11_net_0,
        -- Inouts
        PAD => Light_SDA 
        );
-- BIBUF_1
BIBUF_1 : BIBUF
    port map( 
        -- Inputs
        D   => I2C_Core_APB3_0_SCLO,
        E   => I2C_Core_APB3_0_SCLE,
        -- Outputs
        Y   => Board_J10_net_0,
        -- Inouts
        PAD => Light_SCL 
        );
-- COREABC_C0_0
COREABC_C0_0 : COREABC_C0
    port map( 
        -- Inputs
        NSYSRESET => AND4_0_Y,
        PCLK      => FCCC_C0_0_GL0,
        INTREQ    => I2C_Core_APB3_0_INT,
        PREADY_M  => COREABC_C0_0_APB3master_PREADY,
        PSLVERR_M => COREABC_C0_0_APB3master_PSLVERR,
        PRDATA_M  => COREABC_C0_0_APB3master_PRDATA_0,
        IO_IN(0)  => CoreTimer_C0_0_TIMINT,
        -- Outputs
        PRESETN   => COREABC_C0_0_PRESETN,
        INTACT    => OPEN,
        PSEL_M    => COREABC_C0_0_APB3master_PSELx,
        PENABLE_M => COREABC_C0_0_APB3master_PENABLE,
        PWRITE_M  => COREABC_C0_0_APB3master_PWRITE,
        IO_OUT    => OPEN,
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
        PREADYS1  => VCC_net, -- tied to '1' from definition
        PSLVERRS1 => GND_net, -- tied to '0' from definition
        PREADYS2  => CoreAPB3_C0_0_APBmslave2_PREADY,
        PSLVERRS2 => CoreAPB3_C0_0_APBmslave2_PSLVERR,
        PADDR     => COREABC_C0_0_APB3master_PADDR_0,
        PWDATA    => COREABC_C0_0_APB3master_PWDATA_0,
        PRDATAS0  => CoreAPB3_C0_0_APBmslave0_PRDATA_0,
        PRDATAS1  => CoreAPB3_C0_0_APBmslave1_PRDATA,
        PRDATAS2  => CoreAPB3_C0_0_APBmslave2_PRDATA_0,
        -- Outputs
        PREADY    => COREABC_C0_0_APB3master_PREADY,
        PSLVERR   => COREABC_C0_0_APB3master_PSLVERR,
        PSELS0    => CoreAPB3_C0_0_APBmslave0_PSELx,
        PENABLES  => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITES   => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PSELS1    => CoreAPB3_C0_0_APBmslave1_PSELx,
        PSELS2    => CoreAPB3_C0_0_APBmslave2_PSELx,
        PRDATA    => COREABC_C0_0_APB3master_PRDATA,
        PADDRS    => CoreAPB3_C0_0_APBmslave0_PADDR,
        PWDATAS   => CoreAPB3_C0_0_APBmslave0_PWDATA 
        );
-- CoreTimer_C0_0
CoreTimer_C0_0 : CoreTimer_C0
    port map( 
        -- Inputs
        PCLK    => FCCC_C0_0_GL0,
        PRESETn => COREABC_C0_0_PRESETN,
        PSEL    => CoreAPB3_C0_0_APBmslave1_PSELx,
        PENABLE => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE  => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PADDR   => CoreAPB3_C0_0_APBmslave0_PADDR_1,
        PWDATA  => CoreAPB3_C0_0_APBmslave0_PWDATA,
        -- Outputs
        TIMINT  => CoreTimer_C0_0_TIMINT,
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
-- I2C_Core_APB3_0
I2C_Core_APB3_0 : entity work.I2C_Core_APB3
    generic map( 
        g_auto_reg_max  => ( 25 ),
        g_filter_length => ( 3 )
        )
    port map( 
        -- Inputs
        PCLK        => FCCC_C0_0_GL0,
        RSTn        => COREABC_C0_0_PRESETN,
        PSEL        => CoreAPB3_C0_0_APBmslave0_PSELx,
        PENABLE     => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE      => CoreAPB3_C0_0_APBmslave0_PWRITE,
        SDAI        => Board_J11_net_0,
        SCLI        => Board_J10_net_0,
        trigger_seq => CoreTimer_C0_0_TIMINT,
        PADDR       => CoreAPB3_C0_0_APBmslave0_PADDR_0,
        PWDATA      => CoreAPB3_C0_0_APBmslave0_PWDATA_0,
        -- Outputs
        PREADY      => CoreAPB3_C0_0_APBmslave0_PREADY,
        PSLVERR     => CoreAPB3_C0_0_APBmslave0_PSLVERR,
        INT         => I2C_Core_APB3_0_INT,
        SDAO        => I2C_Core_APB3_0_SDAO,
        SDAE        => I2C_Core_APB3_0_SDAE,
        SCLO        => I2C_Core_APB3_0_SCLO,
        SCLE        => I2C_Core_APB3_0_SCLE,
        PRDATA      => CoreAPB3_C0_0_APBmslave0_PRDATA 
        );
-- LED_Controller_0
LED_Controller_0 : entity work.LED_Controller
    port map( 
        -- Inputs
        PCLK100       => FCCC_C0_0_GL0,
        CLK0_5        => FCCC_C0_0_GL1,
        PRESETN       => COREABC_C0_0_PRESETN,
        I2C_Sniff_SCL => Board_J10_net_0,
        I2C_Sniff_SDA => Board_J11_net_0,
        PSEL          => CoreAPB3_C0_0_APBmslave2_PSELx,
        PENABLE       => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE        => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PADDR         => CoreAPB3_C0_0_APBmslave0_PADDR_2,
        PWDATA        => CoreAPB3_C0_0_APBmslave0_PWDATA_1,
        Fabric_Int    => Fabric_Int_const_net_0,
        Board_Buttons => Board_Buttons_const_net_0,
        -- Outputs
        RST_out       => OPEN,
        PREADY        => CoreAPB3_C0_0_APBmslave2_PREADY,
        PSLVERR       => CoreAPB3_C0_0_APBmslave2_PSLVERR,
        INT           => OPEN,
        Board_J8      => OPEN,
        Board_J9      => OPEN,
        Board_J10     => OPEN,
        Board_J11     => OPEN,
        PRDATA        => CoreAPB3_C0_0_APBmslave2_PRDATA,
        Board_LEDs    => Board_LEDs_net_0,
        Board_MOD1    => OPEN,
        Board_J7      => OPEN 
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
