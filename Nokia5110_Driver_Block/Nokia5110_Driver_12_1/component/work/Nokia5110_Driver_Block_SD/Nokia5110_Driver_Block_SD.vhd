----------------------------------------------------------------------
-- Created by SmartDesign Sat Nov  9 00:56:17 2019
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
-- Nokia5110_Driver_Block_SD entity declaration
----------------------------------------------------------------------
entity Nokia5110_Driver_Block_SD is
    -- Port list
    port(
        -- Outputs
        RSTout       : out std_logic;
        SPICLK       : out std_logic;
        SPIDO        : out std_logic;
        chip_enable  : out std_logic;
        data_command : out std_logic;
        driver_busy  : out std_logic
        );
end Nokia5110_Driver_Block_SD;
----------------------------------------------------------------------
-- Nokia5110_Driver_Block_SD architecture body
----------------------------------------------------------------------
architecture RTL of Nokia5110_Driver_Block_SD is
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
-- Nokia5110_Driver
-- using entity instantiation for component Nokia5110_Driver
-- OSC_C0
component OSC_C0
    -- Port list
    port(
        -- Outputs
        RCOSC_25_50MHZ_CCC : out std_logic
        );
end component;
-- URAM_C0
component URAM_C0
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
signal chip_enable_net_0                                  : std_logic;
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
signal data_command_net_0                                 : std_logic;
signal driver_busy_net_0                                  : std_logic;
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal Nokia5110_Driver_0_uSRAM_A_ADDR                    : std_logic_vector(8 downto 0);
signal Nokia5110_Driver_0_uSRAM_B_ADDR                    : std_logic_vector(8 downto 0);
signal Nokia5110_Driver_0_uSRAM_C_ADDR                    : std_logic_vector(8 downto 0);
signal Nokia5110_Driver_0_uSRAM_C_BLK                     : std_logic;
signal Nokia5110_Driver_0_uSRAM_C_DIN                     : std_logic_vector(7 downto 0);
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal RSTout_net_0                                       : std_logic;
signal SPICLK_net_0                                       : std_logic;
signal SPIDO_net_0                                        : std_logic;
signal URAM_C0_0_A_DOUT                                   : std_logic_vector(7 downto 0);
signal URAM_C0_0_B_DOUT                                   : std_logic_vector(7 downto 0);
signal RSTout_net_1                                       : std_logic;
signal driver_busy_net_1                                  : std_logic;
signal SPIDO_net_1                                        : std_logic;
signal SPICLK_net_1                                       : std_logic;
signal data_command_net_1                                 : std_logic;
signal chip_enable_net_1                                  : std_logic;
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal COREABC_C0_0_APB3master_PADDR                      : std_logic_vector(19 downto 0);
signal COREABC_C0_0_APB3master_PADDR_0_31to20             : std_logic_vector(31 downto 20);
signal COREABC_C0_0_APB3master_PADDR_0_19to0              : std_logic_vector(19 downto 0);
signal COREABC_C0_0_APB3master_PADDR_0                    : std_logic_vector(31 downto 0);

signal COREABC_C0_0_APB3master_PRDATA                     : std_logic_vector(31 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0_7to0              : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0                   : std_logic_vector(7 downto 0);

signal COREABC_C0_0_APB3master_PWDATA                     : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PWDATA_0_31to8             : std_logic_vector(31 downto 8);
signal COREABC_C0_0_APB3master_PWDATA_0_7to0              : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PWDATA_0                   : std_logic_vector(31 downto 0);

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
-- Top level output port assignments
----------------------------------------------------------------------
 RSTout_net_1       <= RSTout_net_0;
 RSTout             <= RSTout_net_1;
 driver_busy_net_1  <= driver_busy_net_0;
 driver_busy        <= driver_busy_net_1;
 SPIDO_net_1        <= SPIDO_net_0;
 SPIDO              <= SPIDO_net_1;
 SPICLK_net_1       <= SPICLK_net_0;
 SPICLK             <= SPICLK_net_1;
 data_command_net_1 <= data_command_net_0;
 data_command       <= data_command_net_1;
 chip_enable_net_1  <= chip_enable_net_0;
 chip_enable        <= chip_enable_net_1;
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
-- Nokia5110_Driver_0
Nokia5110_Driver_0 : entity work.Nokia5110_Driver
    generic map( 
        g_clk_period  => ( 10 ),
        g_clk_spi_div => ( 50 ),
        g_frame_size  => ( 8 ),
        g_update_rate => ( 1 )
        )
    port map( 
        -- Inputs
        CLK          => FCCC_C0_0_GL0,
        RSTn         => COREABC_C0_0_PRESETN,
        PADDR        => CoreAPB3_C0_0_APBmslave0_PADDR_0,
        PSEL         => CoreAPB3_C0_0_APBmslave0_PSELx,
        PENABLE      => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE       => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PWDATA       => CoreAPB3_C0_0_APBmslave0_PWDATA_0,
        uSRAM_A_DOUT => URAM_C0_0_A_DOUT,
        uSRAM_B_DOUT => URAM_C0_0_B_DOUT,
        -- Outputs
        driver_busy  => driver_busy_net_0,
        SPIDO        => SPIDO_net_0,
        SPICLK       => SPICLK_net_0,
        data_command => data_command_net_0,
        chip_enable  => chip_enable_net_0,
        RSTout       => RSTout_net_0,
        PREADY       => CoreAPB3_C0_0_APBmslave0_PREADY,
        PRDATA       => CoreAPB3_C0_0_APBmslave0_PRDATA,
        PSLVERR      => CoreAPB3_C0_0_APBmslave0_PSLVERR,
        uSRAM_A_ADDR => Nokia5110_Driver_0_uSRAM_A_ADDR,
        uSRAM_B_ADDR => Nokia5110_Driver_0_uSRAM_B_ADDR,
        uSRAM_C_BLK  => Nokia5110_Driver_0_uSRAM_C_BLK,
        uSRAM_C_ADDR => Nokia5110_Driver_0_uSRAM_C_ADDR,
        uSRAM_C_DIN  => Nokia5110_Driver_0_uSRAM_C_DIN 
        );
-- OSC_C0_0
OSC_C0_0 : OSC_C0
    port map( 
        -- Outputs
        RCOSC_25_50MHZ_CCC => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC 
        );
-- URAM_C0_0
URAM_C0_0 : URAM_C0
    port map( 
        -- Inputs
        C_BLK  => Nokia5110_Driver_0_uSRAM_C_BLK,
        CLK    => FCCC_C0_0_GL0,
        C_DIN  => Nokia5110_Driver_0_uSRAM_C_DIN,
        A_ADDR => Nokia5110_Driver_0_uSRAM_A_ADDR,
        B_ADDR => Nokia5110_Driver_0_uSRAM_B_ADDR,
        C_ADDR => Nokia5110_Driver_0_uSRAM_C_ADDR,
        -- Outputs
        A_DOUT => URAM_C0_0_A_DOUT,
        B_DOUT => URAM_C0_0_B_DOUT 
        );

end RTL;
