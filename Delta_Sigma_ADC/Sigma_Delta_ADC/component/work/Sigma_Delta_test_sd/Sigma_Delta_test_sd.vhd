----------------------------------------------------------------------
-- Created by SmartDesign Mon Feb  3 20:24:58 2020
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
-- Sigma_Delta_test_sd entity declaration
----------------------------------------------------------------------
entity Sigma_Delta_test_sd is
    -- Port list
    port(
        -- Inputs
        DEVRST_N   : in  std_logic;
        PADN       : in  std_logic;
        PADP       : in  std_logic;
        -- Outputs
        Board_J9   : out std_logic;
        Board_LEDs : out std_logic_vector(7 downto 0);
        Board_MOD  : out std_logic_vector(3 downto 0)
        );
end Sigma_Delta_test_sd;
----------------------------------------------------------------------
-- Sigma_Delta_test_sd architecture body
----------------------------------------------------------------------
architecture RTL of Sigma_Delta_test_sd is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- FCCC_C1
component FCCC_C1
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
-- LED_inverter_dimmer
component LED_inverter_dimmer
    -- Port list
    port(
        -- Inputs
        CLK         : in  std_logic;
        LED_toggles : in  std_logic_vector(7 downto 0);
        -- Outputs
        Board_LEDs  : out std_logic_vector(7 downto 0)
        );
end component;
-- OSC_C1
component OSC_C1
    -- Port list
    port(
        -- Outputs
        RCOSC_25_50MHZ_CCC : out std_logic
        );
end component;
-- Pixelbar_Creator
-- using entity instantiation for component Pixelbar_Creator
-- Power_On_Reset_Delay
-- using entity instantiation for component Power_On_Reset_Delay
-- Sigma_Delta_system
component Sigma_Delta_system
    -- Port list
    port(
        -- Inputs
        PADN               : in  std_logic;
        PADP               : in  std_logic;
        PCLK               : in  std_logic;
        RSTn               : in  std_logic;
        -- Outputs
        Data_out           : out std_logic_vector(7 downto 0);
        Data_out_ready     : out std_logic;
        LVDS_PADN_feedback : out std_logic
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
signal Board_J9_net_0                                     : std_logic;
signal Board_LEDs_net_0                                   : std_logic;
signal Board_LEDs_0                                       : std_logic_vector(7 downto 0);
signal FCCC_C1_0_GL0                                      : std_logic;
signal FCCC_C1_0_GL1                                      : std_logic;
signal FCCC_C1_0_LOCK                                     : std_logic;
signal OSC_C1_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal Pixelbar_Creator_0_Pixel_bar_out                   : std_logic_vector(7 downto 0);
signal Sigma_Delta_system_0_Data_out                      : std_logic_vector(7 downto 0);
signal Sigma_Delta_system_0_Data_out_ready                : std_logic;
signal SYSRESET_0_POWER_ON_RESET_N                        : std_logic;
signal Board_J9_net_1                                     : std_logic;
signal Board_LEDs_0_net_0                                 : std_logic_vector(7 downto 0);
signal Board_J9_net_2                                     : std_logic_vector(0 to 0);
signal Board_J9_net_3                                     : std_logic_vector(1 to 1);
signal Board_J9_net_4                                     : std_logic_vector(2 to 2);
signal Board_J9_net_5                                     : std_logic_vector(3 to 3);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net                                            : std_logic;
signal PADDR_const_net_0                                  : std_logic_vector(7 downto 0);
signal GND_net                                            : std_logic;
signal PWDATA_const_net_0                                 : std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 VCC_net            <= '1';
 PADDR_const_net_0  <= B"00000000";
 GND_net            <= '0';
 PWDATA_const_net_0 <= B"00000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 Board_J9_net_1         <= Board_J9_net_0;
 Board_J9               <= Board_J9_net_1;
 Board_LEDs_0_net_0     <= Board_LEDs_0;
 Board_LEDs(7 downto 0) <= Board_LEDs_0_net_0;
 Board_J9_net_2(0)      <= Board_J9_net_0;
 Board_MOD(0)           <= Board_J9_net_2(0);
 Board_J9_net_3(1)      <= Board_J9_net_0;
 Board_MOD(1)           <= Board_J9_net_3(1);
 Board_J9_net_4(2)      <= Board_J9_net_0;
 Board_MOD(2)           <= Board_J9_net_4(2);
 Board_J9_net_5(3)      <= Board_J9_net_0;
 Board_MOD(3)           <= Board_J9_net_5(3);
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- FCCC_C1_0
FCCC_C1_0 : FCCC_C1
    port map( 
        -- Inputs
        RCOSC_25_50MHZ => OSC_C1_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC,
        -- Outputs
        GL0            => FCCC_C1_0_GL0,
        LOCK           => FCCC_C1_0_LOCK,
        GL1            => FCCC_C1_0_GL1 
        );
-- LED_inverter_dimmer_0
LED_inverter_dimmer_0 : LED_inverter_dimmer
    port map( 
        -- Inputs
        CLK         => FCCC_C1_0_GL1,
        LED_toggles => Pixelbar_Creator_0_Pixel_bar_out,
        -- Outputs
        Board_LEDs  => Board_LEDs_0 
        );
-- OSC_C1_0
OSC_C1_0 : OSC_C1
    port map( 
        -- Outputs
        RCOSC_25_50MHZ_CCC => OSC_C1_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC 
        );
-- Pixelbar_Creator_0
Pixelbar_Creator_0 : entity work.Pixelbar_Creator
    generic map( 
        g_data_in_bits        => ( 8 ),
        g_pixel_register_size => ( 8 ),
        g_pixel_registers     => ( 1 )
        )
    port map( 
        -- Inputs
        PCLK           => FCCC_C1_0_GL0,
        RSTn           => Board_LEDs_net_0,
        Data_in_ready  => Sigma_Delta_system_0_Data_out_ready,
        PSEL           => GND_net, -- tied to '0' from definition
        PENABLE        => GND_net, -- tied to '0' from definition
        PWRITE         => GND_net, -- tied to '0' from definition
        Data_in        => Sigma_Delta_system_0_Data_out,
        PADDR          => PADDR_const_net_0, -- tied to X"0" from definition
        PWDATA         => PWDATA_const_net_0, -- tied to X"0" from definition
        -- Outputs
        Data_out_ready => OPEN,
        PREADY         => OPEN,
        PSLVERR        => OPEN,
        INT            => OPEN,
        Pixel_bar_out  => Pixelbar_Creator_0_Pixel_bar_out,
        PRDATA         => OPEN 
        );
-- Power_On_Reset_Delay_0
Power_On_Reset_Delay_0 : entity work.Power_On_Reset_Delay
    generic map( 
        g_clk_cnt => ( 16384 )
        )
    port map( 
        -- Inputs
        CLK                  => FCCC_C1_0_GL0,
        POWER_ON_RESET_N     => SYSRESET_0_POWER_ON_RESET_N,
        EXT_RESET_IN_N       => VCC_net,
        FCCC_LOCK            => FCCC_C1_0_LOCK,
        USER_FAB_RESET_IN_N  => VCC_net,
        -- Outputs
        USER_FAB_RESET_OUT_N => Board_LEDs_net_0 
        );
-- Sigma_Delta_system_0
Sigma_Delta_system_0 : Sigma_Delta_system
    port map( 
        -- Inputs
        PADP               => PADP,
        PADN               => PADN,
        RSTn               => Board_LEDs_net_0,
        PCLK               => FCCC_C1_0_GL0,
        -- Outputs
        LVDS_PADN_feedback => Board_J9_net_0,
        Data_out_ready     => Sigma_Delta_system_0_Data_out_ready,
        Data_out           => Sigma_Delta_system_0_Data_out 
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
