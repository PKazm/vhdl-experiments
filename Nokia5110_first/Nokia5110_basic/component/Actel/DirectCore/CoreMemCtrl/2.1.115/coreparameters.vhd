----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Oct 28 03:50:18 2019
-- Parameters for CoreMemCtrl
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant FAMILY : integer := 19;
    constant FLASH_16BIT : integer := 0;
    constant FLASH_ADDR_SEL : integer := 2;
    constant FLOW_THROUGH : integer := 0;
    constant HDL_license : string( 1 to 1 ) := "U";
    constant NUM_WS_FLASH_READ : integer := 1;
    constant NUM_WS_FLASH_WRITE : integer := 1;
    constant NUM_WS_SRAM_READ : integer := 1;
    constant NUM_WS_SRAM_WRITE : integer := 1;
    constant SHARED_RW : integer := 0;
    constant SRAM_ADDR_SEL : integer := 2;
    constant SYNC_SRAM : integer := 1;
    constant testbench : string( 1 to 4 ) := "User";
end coreparameters;
