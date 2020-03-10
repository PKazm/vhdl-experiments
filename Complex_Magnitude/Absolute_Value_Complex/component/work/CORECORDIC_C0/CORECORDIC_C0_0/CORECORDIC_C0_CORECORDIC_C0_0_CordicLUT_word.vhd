--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
--APPROVED IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             CORDIC Word-serial Arctan LUT
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

-- CORDIC constant angle (arctan) LUT
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;

ENTITY CORECORDIC_C0_CORECORDIC_C0_0_word_cROM IS
  GENERIC(
    LOGITER   : integer:=6;
    IN_BITS   : integer:=10;
    DP_BITS   : integer:=12  );
  PORT (iterCount : IN std_logic_vector(LOGITER-1 DOWNTO 0);
        arctan    : OUT std_logic_vector(DP_BITS-1 DOWNTO 0);
        rcprGain_fx : OUT std_logic_vector(IN_BITS-1 DOWNTO 0)  );
END ENTITY CORECORDIC_C0_CORECORDIC_C0_0_word_cROM;

ARCHITECTURE gen_rtl OF CORECORDIC_C0_CORECORDIC_C0_0_word_cROM IS
BEGIN
  PROCESS (iterCount)
  BEGIN
    CASE to_integer(unsigned(iterCount)) IS
      WHEN  0 => arctan <= "000100000000";
      WHEN  1 => arctan <= "000010010111";
      WHEN  2 => arctan <= "000001010000";
      WHEN  3 => arctan <= "000000101001";
      WHEN  4 => arctan <= "000000010100";
      WHEN  5 => arctan <= "000000001010";
      WHEN  6 => arctan <= "000000000101";
      WHEN  7 => arctan <= "000000000011";
      WHEN  8 => arctan <= "000000000001";
      WHEN  9 => arctan <= "000000000001";
      WHEN 10 => arctan <= "000000000000";
      WHEN 11 => arctan <= "000000000000";
      WHEN 12 => arctan <= "000000000000";
      WHEN 13 => arctan <= "000000000000";
      WHEN 14 => arctan <= "000000000000";
      WHEN 15 => arctan <= "000000000000";
      WHEN 16 => arctan <= "000000000000";
      WHEN 17 => arctan <= "000000000000";
      WHEN 18 => arctan <= "000000000000";
      WHEN 19 => arctan <= "000000000000";
      WHEN 20 => arctan <= "000000000000";
      WHEN 21 => arctan <= "000000000000";
      WHEN 22 => arctan <= "000000000000";
      WHEN 23 => arctan <= "000000000000";
      WHEN 24 => arctan <= "000000000000";
      WHEN 25 => arctan <= "000000000000";
      WHEN 26 => arctan <= "000000000000";
      WHEN 27 => arctan <= "000000000000";
      WHEN 28 => arctan <= "000000000000";
      WHEN 29 => arctan <= "000000000000";
      WHEN 30 => arctan <= "000000000000";
      WHEN 31 => arctan <= "000000000000";
      WHEN 32 => arctan <= "000000000000";
      WHEN 33 => arctan <= "000000000000";
      WHEN 34 => arctan <= "000000000000";
      WHEN 35 => arctan <= "000000000000";
      WHEN 36 => arctan <= "000000000000";
      WHEN 37 => arctan <= "000000000000";
      WHEN 38 => arctan <= "000000000000";
      WHEN 39 => arctan <= "000000000000";
      WHEN 40 => arctan <= "000000000000";
      WHEN 41 => arctan <= "000000000000";
      WHEN 42 => arctan <= "000000000000";
      WHEN 43 => arctan <= "000000000000";
      WHEN 44 => arctan <= "000000000000";
      WHEN 45 => arctan <= "000000000000";
      WHEN 46 => arctan <= "000000000000";
      WHEN 47 => arctan <= "000000000000";
      WHEN OTHERS => arctan <= (OTHERS=>'0');
    END CASE;
  END PROCESS;

  rcprGain_fx <= "0010011011";

END ARCHITECTURE gen_rtl;

