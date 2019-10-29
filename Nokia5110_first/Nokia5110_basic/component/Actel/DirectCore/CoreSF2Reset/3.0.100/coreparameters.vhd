----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Oct 28 20:23:40 2019
-- Parameters for CoreSF2Reset
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant DDR_WAIT : integer := 200;
    constant DEVICE_VOLTAGE : integer := 2;
    constant EXT_RESET_CFG : integer := 0;
    constant FDDR_IN_USE : integer := 0;
    constant HDL_license : string( 1 to 1 ) := "U";
    constant MDDR_IN_USE : integer := 0;
    constant SDIF0_IN_USE : integer := 0;
    constant SDIF1_IN_USE : integer := 0;
    constant SDIF2_IN_USE : integer := 0;
    constant SDIF3_IN_USE : integer := 0;
end coreparameters;
