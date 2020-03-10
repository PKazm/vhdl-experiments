----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sat Mar  7 02:45:16 2020
-- Parameters for CORECORDIC
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant ARCHITECT : integer := 1;
    constant COARSE : integer := 0;
    constant DP_OPTION : integer := 0;
    constant DP_WIDTH : integer := 16;
    constant IN_BITS : integer := 10;
    constant ITERATIONS : integer := 48;
    constant MODE : integer := 2;
    constant OUT_BITS : integer := 10;
    constant ROUND : integer := 1;
    constant testbench : integer := 1;
end coreparameters;
