--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
--APPROVED IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Output test vector
--
--Rev:
--v4.0 12/2/2014  Porting in TGI framework
--
--SVN Revision Information:
--SVN$Revision:$
--SVN$Date:$
--
--Resolved SARS
--
--
--
--Notes:
--
--****************************************************************

-- This is an automatically generated file


-- CORDIC Output test vector for mode:  Vectoring (1)

--             In Rotation Mode    In Vectoring Mode
-- goldSample1  XN=gain*R*cosA    XN=gain*sqrt(X^2+Y^2)
-- goldSample2  YN=gain*R*sinA    AN=arctan(Y/X) 

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;

ENTITY cordic_bhvOutpVect IS 
  PORT (
    count   : IN integer;
    goldSample1, goldSample2: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)  );
END ENTITY cordic_bhvOutpVect;

ARCHITECTURE rtl_gen OF cordic_bhvOutpVect IS 
BEGIN
  PROCESS (count) 
  BEGIN
    CASE count IS
      WHEN  0 => 
        goldSample1 <= "0100101010";   --    298
        goldSample2 <= "0001000000";   --    64
      WHEN  1 => 
        goldSample1 <= "0100011000";   --    280
        goldSample2 <= "0001000000";   --    64
      WHEN  2 => 
        goldSample1 <= "0100001111";   --    271
        goldSample2 <= "0001000000";   --    64
      WHEN  3 => 
        goldSample1 <= "0011110010";   --    242
        goldSample2 <= "0001000000";   --    64
      WHEN  4 => 
        goldSample1 <= "0011100000";   --    224
        goldSample2 <= "0001000000";   --    64
      WHEN  5 => 
        goldSample1 <= "0011001101";   --    205
        goldSample2 <= "0001000000";   --    64
      WHEN  6 => 
        goldSample1 <= "0010111011";   --    187
        goldSample2 <= "0001000000";   --    64
      WHEN  7 => 
        goldSample1 <= "0010101000";   --    168
        goldSample2 <= "0001000000";   --    64
      WHEN  8 => 
        goldSample1 <= "0010010110";   --    150
        goldSample2 <= "0001000000";   --    64
      WHEN  9 => 
        goldSample1 <= "0010000011";   --    131
        goldSample2 <= "0001000000";   --    64
      WHEN 10 => 
        goldSample1 <= "0001110000";   --    112
        goldSample2 <= "0001000000";   --    64
      WHEN 11 => 
        goldSample1 <= "0001011110";   --    94
        goldSample2 <= "0001000000";   --    64
      WHEN 12 => 
        goldSample1 <= "0001001011";   --    75
        goldSample2 <= "0001000000";   --    64
      WHEN 13 => 
        goldSample1 <= "0000111000";   --    56
        goldSample2 <= "0001000000";   --    64
      WHEN 14 => 
        goldSample1 <= "0000100110";   --    38
        goldSample2 <= "0001000000";   --    64
      WHEN 15 => 
        goldSample1 <= "0000010011";   --    19
        goldSample2 <= "0001000000";   --    64
      WHEN OTHERS => 
        goldSample1 <= (others=>'0');
        goldSample2 <= (others=>'0');
    END CASE;
  END PROCESS;
END ARCHITECTURE;
