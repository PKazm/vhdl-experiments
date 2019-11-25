----------------------------------------------------------------------
-- Created by SmartDesign Mon Nov 25 01:13:06 2019
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
-- Delta_Sigma_Design entity declaration
----------------------------------------------------------------------
entity Delta_Sigma_Design is
    -- Port list
    port(
        -- Inputs
        DEVRST_N     : in  std_logic;
        PADN         : in  std_logic;
        PADP         : in  std_logic;
        -- Outputs
        ADC_feedback : out std_logic;
        ADC_out      : out std_logic;
        Board_J10    : out std_logic;
        Board_J11    : out std_logic;
        Board_J7     : out std_logic_vector(4 downto 0);
        Board_J9     : out std_logic;
        Board_LEDs   : out std_logic_vector(7 downto 0)
        );
end Delta_Sigma_Design;
----------------------------------------------------------------------
-- Delta_Sigma_Design architecture body
----------------------------------------------------------------------
architecture RTL of Delta_Sigma_Design is
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
        PRDATAS0  : in  std_logic_vector(31 downto 0);
        PRDATAS1  : in  std_logic_vector(31 downto 0);
        PREADYS0  : in  std_logic;
        PREADYS1  : in  std_logic;
        PSEL      : in  std_logic;
        PSLVERRS0 : in  std_logic;
        PSLVERRS1 : in  std_logic;
        PWDATA    : in  std_logic_vector(31 downto 0);
        PWRITE    : in  std_logic;
        -- Outputs
        PADDRS    : out std_logic_vector(31 downto 0);
        PENABLES  : out std_logic;
        PRDATA    : out std_logic_vector(31 downto 0);
        PREADY    : out std_logic;
        PSELS0    : out std_logic;
        PSELS1    : out std_logic;
        PSLVERR   : out std_logic;
        PWDATAS   : out std_logic_vector(31 downto 0);
        PWRITES   : out std_logic
        );
end component;
-- Delta_Sigma_Converter
-- using entity instantiation for component Delta_Sigma_Converter
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
-- INBUF_DIFF
component INBUF_DIFF
    generic( 
        IOSTD : string := "" 
        );
    -- Port list
    port(
        -- Inputs
        PADN : in  std_logic;
        PADP : in  std_logic;
        -- Outputs
        Y    : out std_logic
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
signal ADC_feedback_net_0                                 : std_logic;
signal AND2_0_Y                                           : std_logic;
signal Board_J7_0                                         : std_logic;
signal Board_J7_1                                         : std_logic;
signal Board_J7_2                                         : std_logic;
signal Board_J7_3                                         : std_logic;
signal Board_J7_4                                         : std_logic;
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
signal CoreAPB3_C0_0_APBmslave1_PREADY                    : std_logic;
signal CoreAPB3_C0_0_APBmslave1_PSELx                     : std_logic;
signal CoreAPB3_C0_0_APBmslave1_PSLVERR                   : std_logic;
signal Delta_Sigma_Converter_0_INT                        : std_logic;
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_GL1_1                                    : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal INBUF_DIFF_0_Y                                     : std_logic;
signal Nokia5110_Driver_0_driver_busy                     : std_logic;
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal SYSRESET_0_POWER_ON_RESET_N                        : std_logic;
signal ADC_feedback_net_1                                 : std_logic;
signal ADC_feedback_net_2                                 : std_logic;
signal Board_J7_0_net_0                                   : std_logic_vector(0 to 0);
signal Board_J7_1_net_0                                   : std_logic_vector(1 to 1);
signal Board_J7_2_net_0                                   : std_logic_vector(2 to 2);
signal Board_J7_3_net_0                                   : std_logic_vector(3 to 3);
signal Board_J7_4_net_0                                   : std_logic_vector(4 to 4);
signal IO_IN_net_0                                        : std_logic_vector(0 to 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net                                            : std_logic;
signal GND_net                                            : std_logic;
signal Board_LEDs_const_net_0                             : std_logic_vector(7 downto 0);
----------------------------------------------------------------------
-- Bus Interface Nets Declarations - Unequal Pin Widths
----------------------------------------------------------------------
signal COREABC_C0_0_APB3master_PADDR                      : std_logic_vector(19 downto 0);
signal COREABC_C0_0_APB3master_PADDR_0_31to20             : std_logic_vector(31 downto 20);
signal COREABC_C0_0_APB3master_PADDR_0_19to0              : std_logic_vector(19 downto 0);
signal COREABC_C0_0_APB3master_PADDR_0                    : std_logic_vector(31 downto 0);

signal COREABC_C0_0_APB3master_PRDATA_0_7to0              : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PRDATA_0                   : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PRDATA                     : std_logic_vector(31 downto 0);

signal COREABC_C0_0_APB3master_PWDATA                     : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PWDATA_0_31to8             : std_logic_vector(31 downto 8);
signal COREABC_C0_0_APB3master_PWDATA_0_7to0              : std_logic_vector(7 downto 0);
signal COREABC_C0_0_APB3master_PWDATA_0                   : std_logic_vector(31 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PADDR                     : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_1_7to0              : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_1                   : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0              : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PADDR_0                   : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PRDATA                    : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PRDATA_0                  : std_logic_vector(31 downto 0);

signal CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_0                  : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA                    : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_1_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave0_PWDATA_1                  : std_logic_vector(7 downto 0);

signal CoreAPB3_C0_0_APBmslave1_PRDATA_0_31to8            : std_logic_vector(31 downto 8);
signal CoreAPB3_C0_0_APBmslave1_PRDATA_0_7to0             : std_logic_vector(7 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PRDATA_0                  : std_logic_vector(31 downto 0);
signal CoreAPB3_C0_0_APBmslave1_PRDATA                    : std_logic_vector(7 downto 0);


begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net                <= '1';
 GND_net                <= '0';
 Board_LEDs_const_net_0 <= B"01010101";
----------------------------------------------------------------------
-- TieOff assignments
----------------------------------------------------------------------
 Board_J11              <= '1';
 Board_J9               <= '0';
 Board_J10              <= '0';
 Board_LEDs(7 downto 0) <= B"01010101";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 ADC_feedback_net_1     <= ADC_feedback_net_0;
 ADC_out                <= ADC_feedback_net_1;
 ADC_feedback_net_2     <= ADC_feedback_net_0;
 ADC_feedback           <= ADC_feedback_net_2;
 Board_J7_0_net_0(0)    <= Board_J7_0;
 Board_J7(0)            <= Board_J7_0_net_0(0);
 Board_J7_1_net_0(1)    <= Board_J7_1;
 Board_J7(1)            <= Board_J7_1_net_0(1);
 Board_J7_2_net_0(2)    <= Board_J7_2;
 Board_J7(2)            <= Board_J7_2_net_0(2);
 Board_J7_3_net_0(3)    <= Board_J7_3;
 Board_J7(3)            <= Board_J7_3_net_0(3);
 Board_J7_4_net_0(4)    <= Board_J7_4;
 Board_J7(4)            <= Board_J7_4_net_0(4);
----------------------------------------------------------------------
-- Concatenation assignments
----------------------------------------------------------------------
 IO_IN_net_0(0) <= ( Nokia5110_Driver_0_driver_busy );
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

 CoreAPB3_C0_0_APBmslave0_PADDR_1_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PADDR(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PADDR_1 <= ( CoreAPB3_C0_0_APBmslave0_PADDR_1_7to0(7 downto 0) );
 CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PADDR(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PADDR_0 <= ( CoreAPB3_C0_0_APBmslave0_PADDR_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave0_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave0_PRDATA_0_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PWDATA_0 <= ( CoreAPB3_C0_0_APBmslave0_PWDATA_0_7to0(7 downto 0) );
 CoreAPB3_C0_0_APBmslave0_PWDATA_1_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave0_PWDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave0_PWDATA_1 <= ( CoreAPB3_C0_0_APBmslave0_PWDATA_1_7to0(7 downto 0) );

 CoreAPB3_C0_0_APBmslave1_PRDATA_0_31to8(31 downto 8) <= B"000000000000000000000000";
 CoreAPB3_C0_0_APBmslave1_PRDATA_0_7to0(7 downto 0) <= CoreAPB3_C0_0_APBmslave1_PRDATA(7 downto 0);
 CoreAPB3_C0_0_APBmslave1_PRDATA_0 <= ( CoreAPB3_C0_0_APBmslave1_PRDATA_0_31to8(31 downto 8) & CoreAPB3_C0_0_APBmslave1_PRDATA_0_7to0(7 downto 0) );

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
-- COREABC_C0_0
COREABC_C0_0 : COREABC_C0
    port map( 
        -- Inputs
        NSYSRESET => AND2_0_Y,
        PCLK      => FCCC_C0_0_GL0,
        INTREQ    => Delta_Sigma_Converter_0_INT,
        PREADY_M  => COREABC_C0_0_APB3master_PREADY,
        PSLVERR_M => COREABC_C0_0_APB3master_PSLVERR,
        PRDATA_M  => COREABC_C0_0_APB3master_PRDATA_0,
        IO_IN     => IO_IN_net_0,
        -- Outputs
        PRESETN   => COREABC_C0_0_PRESETN,
        INTACT    => OPEN,
        PSEL_M    => COREABC_C0_0_APB3master_PSELx,
        PENABLE_M => COREABC_C0_0_APB3master_PENABLE,
        PWRITE_M  => COREABC_C0_0_APB3master_PWRITE,
        PADDR_M   => COREABC_C0_0_APB3master_PADDR,
        PWDATA_M  => COREABC_C0_0_APB3master_PWDATA,
        IO_OUT    => OPEN 
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
        PREADYS1  => CoreAPB3_C0_0_APBmslave1_PREADY,
        PSLVERRS1 => CoreAPB3_C0_0_APBmslave1_PSLVERR,
        PADDR     => COREABC_C0_0_APB3master_PADDR_0,
        PWDATA    => COREABC_C0_0_APB3master_PWDATA_0,
        PRDATAS0  => CoreAPB3_C0_0_APBmslave0_PRDATA_0,
        PRDATAS1  => CoreAPB3_C0_0_APBmslave1_PRDATA_0,
        -- Outputs
        PREADY    => COREABC_C0_0_APB3master_PREADY,
        PSLVERR   => COREABC_C0_0_APB3master_PSLVERR,
        PSELS0    => CoreAPB3_C0_0_APBmslave0_PSELx,
        PENABLES  => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITES   => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PSELS1    => CoreAPB3_C0_0_APBmslave1_PSELx,
        PRDATA    => COREABC_C0_0_APB3master_PRDATA,
        PADDRS    => CoreAPB3_C0_0_APBmslave0_PADDR,
        PWDATAS   => CoreAPB3_C0_0_APBmslave0_PWDATA 
        );
-- Delta_Sigma_Converter_0
Delta_Sigma_Converter_0 : entity work.Delta_Sigma_Converter
    generic map( 
        g_data_bits  => ( 12 ),
        g_sample_div => ( 2048 )
        )
    port map( 
        -- Inputs
        PCLK         => FCCC_C0_0_GL0,
        CLK_OSample  => FCCC_C0_0_GL1_1,
        RSTn         => COREABC_C0_0_PRESETN,
        Analog_in    => INBUF_DIFF_0_Y,
        PSEL         => CoreAPB3_C0_0_APBmslave1_PSELx,
        PENABLE      => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE       => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PADDR        => CoreAPB3_C0_0_APBmslave0_PADDR_1,
        PWDATA       => CoreAPB3_C0_0_APBmslave0_PWDATA_1,
        -- Outputs
        ADC_feedback => ADC_feedback_net_0,
        PREADY       => CoreAPB3_C0_0_APBmslave1_PREADY,
        PSLVERR      => CoreAPB3_C0_0_APBmslave1_PSLVERR,
        INT          => Delta_Sigma_Converter_0_INT,
        PRDATA       => CoreAPB3_C0_0_APBmslave1_PRDATA 
        );
-- FCCC_C0_0
FCCC_C0_0 : FCCC_C0
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        -- Outputs
        GL0            => FCCC_C0_0_GL0,
        LOCK           => FCCC_C0_0_LOCK,
        GL1            => FCCC_C0_0_GL1_1 
        );
-- INBUF_DIFF_0
INBUF_DIFF_0 : INBUF_DIFF
    port map( 
        -- Inputs
        PADP => PADP,
        PADN => PADN,
        -- Outputs
        Y    => INBUF_DIFF_0_Y 
        );
-- Nokia5110_Driver_0
Nokia5110_Driver_0 : entity work.Nokia5110_Driver
    generic map( 
        g_clk_period   => ( 10 ),
        g_clk_spi_div  => ( 50 ),
        g_frame_buffer => ( 1 ),
        g_frame_size   => ( 8 ),
        g_update_rate  => ( 1 )
        )
    port map( 
        -- Inputs
        CLK          => FCCC_C0_0_GL0,
        RSTn         => COREABC_C0_0_PRESETN,
        PSEL         => CoreAPB3_C0_0_APBmslave0_PSELx,
        PENABLE      => CoreAPB3_C0_0_APBmslave0_PENABLE,
        PWRITE       => CoreAPB3_C0_0_APBmslave0_PWRITE,
        PADDR        => CoreAPB3_C0_0_APBmslave0_PADDR_0,
        PWDATA       => CoreAPB3_C0_0_APBmslave0_PWDATA_0,
        -- Outputs
        driver_busy  => Nokia5110_Driver_0_driver_busy,
        SPIDO        => Board_J7_1,
        SPICLK       => Board_J7_0,
        data_command => Board_J7_2,
        chip_enable  => Board_J7_4,
        RSTout       => Board_J7_3,
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
-- SYSRESET_0
SYSRESET_0 : SYSRESET
    port map( 
        -- Inputs
        DEVRST_N         => DEVRST_N,
        -- Outputs
        POWER_ON_RESET_N => SYSRESET_0_POWER_ON_RESET_N 
        );

end RTL;
