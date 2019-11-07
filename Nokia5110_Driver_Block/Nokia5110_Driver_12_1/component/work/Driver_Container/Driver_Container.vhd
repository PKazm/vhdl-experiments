----------------------------------------------------------------------
-- Created by SmartDesign Wed Nov  6 16:00:14 2019
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
-- Nokia5110_Driver_Block_SD
component Nokia5110_Driver_Block_SD
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
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal Board_J7_net_0   : std_logic;
signal Board_J7_0       : std_logic;
signal Board_J9_net_0   : std_logic;
signal Board_J10_net_0  : std_logic;
signal Board_J11_net_0  : std_logic;
signal Board_J11_net_1  : std_logic;
signal Board_J9_net_1   : std_logic;
signal Board_J10_net_1  : std_logic;
signal Board_J7_net_1   : std_logic_vector(1 to 1);
signal Board_J7_0_net_0 : std_logic_vector(4 to 4);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal GND_net          : std_logic;
signal VCC_net          : std_logic;

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
-- Component instances
----------------------------------------------------------------------
-- Nokia5110_Driver_Block_SD_0
Nokia5110_Driver_Block_SD_0 : Nokia5110_Driver_Block_SD
    port map( 
        -- Outputs
        RSTout       => Board_J7_net_0,
        driver_busy  => OPEN,
        SPIDO        => Board_J7_0,
        SPICLK       => Board_J9_net_0,
        data_command => Board_J10_net_0,
        chip_enable  => Board_J11_net_0 
        );

end RTL;
