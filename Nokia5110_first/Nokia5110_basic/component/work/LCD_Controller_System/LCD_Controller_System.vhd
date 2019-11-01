----------------------------------------------------------------------
-- Created by SmartDesign Fri Nov  1 04:16:29 2019
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
-- LCD_Controller_System entity declaration
----------------------------------------------------------------------
entity LCD_Controller_System is
    -- Port list
    port(
        -- Inputs
        Board_Buttons : in  std_logic_vector(1 downto 0);
        DEVRST_N      : in  std_logic;
        -- Outputs
        Board_J10     : out std_logic;
        Board_J11     : out std_logic;
        Board_J7      : out std_logic_vector(4 downto 0);
        Board_J8      : out std_logic;
        Board_J9      : out std_logic;
        Board_LEDs    : out std_logic_vector(7 downto 0);
        Board_MOD1    : out std_logic_vector(5 downto 0)
        );
end LCD_Controller_System;
----------------------------------------------------------------------
-- LCD_Controller_System architecture body
----------------------------------------------------------------------
architecture RTL of LCD_Controller_System is
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
-- Nokia_Driver_Container
-- using entity instantiation for component Nokia_Driver_Container
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
signal Board_J7_net_0                                     : std_logic_vector(4 downto 0);
signal Board_J8_net_0                                     : std_logic;
signal Board_J9_net_0                                     : std_logic;
signal Board_J10_net_0                                    : std_logic;
signal Board_J11_net_0                                    : std_logic;
signal Board_LEDs_net_0                                   : std_logic_vector(7 downto 0);
signal Board_MOD1_net_0                                   : std_logic_vector(5 downto 0);
signal FCCC_C0_0_GL0                                      : std_logic;
signal FCCC_C0_0_GL1                                      : std_logic;
signal FCCC_C0_0_LOCK                                     : std_logic;
signal OSC_C0_0_RCOSC_25_50MHZ_CCC_OUT_RCOSC_25_50MHZ_CCC : std_logic;
signal SYSRESET_0_POWER_ON_RESET_N                        : std_logic;
signal Board_J11_net_1                                    : std_logic;
signal Board_J8_net_1                                     : std_logic;
signal Board_J9_net_1                                     : std_logic;
signal Board_J10_net_1                                    : std_logic;
signal Board_LEDs_net_1                                   : std_logic_vector(7 downto 0);
signal Board_MOD1_net_1                                   : std_logic_vector(5 downto 0);
signal Board_J7_net_1                                     : std_logic_vector(4 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 Board_J11_net_1        <= Board_J11_net_0;
 Board_J11              <= Board_J11_net_1;
 Board_J8_net_1         <= Board_J8_net_0;
 Board_J8               <= Board_J8_net_1;
 Board_J9_net_1         <= Board_J9_net_0;
 Board_J9               <= Board_J9_net_1;
 Board_J10_net_1        <= Board_J10_net_0;
 Board_J10              <= Board_J10_net_1;
 Board_LEDs_net_1       <= Board_LEDs_net_0;
 Board_LEDs(7 downto 0) <= Board_LEDs_net_1;
 Board_MOD1_net_1       <= Board_MOD1_net_0;
 Board_MOD1(5 downto 0) <= Board_MOD1_net_1;
 Board_J7_net_1         <= Board_J7_net_0;
 Board_J7(4 downto 0)   <= Board_J7_net_1;
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
-- Nokia_Driver_Container_0
Nokia_Driver_Container_0 : entity work.Nokia_Driver_Container
    generic map( 
        g_FPS => ( 5 )
        )
    port map( 
        -- Inputs
        CLK           => FCCC_C0_0_GL0,
        CLK_SPI       => FCCC_C0_0_GL1,
        RSTn          => AND2_0_Y,
        Board_Buttons => Board_Buttons,
        -- Outputs
        Board_LEDs    => Board_LEDs_net_0,
        Board_MOD1    => Board_MOD1_net_0,
        Board_J7      => Board_J7_net_0,
        Board_J8      => Board_J8_net_0,
        Board_J9      => Board_J9_net_0,
        Board_J10     => Board_J10_net_0,
        Board_J11     => Board_J11_net_0 
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
