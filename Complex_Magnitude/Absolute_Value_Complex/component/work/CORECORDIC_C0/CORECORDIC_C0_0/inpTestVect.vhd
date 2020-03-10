--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE 
--APPROVED IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Input test vector
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

-- CORDIC Input test vector for MODE 2
--  ----------------------  Conventions  -----------------------------------  
--        Mode    |     Inputs         |           Outputs                    
--  --------------|--------------------|------------------------------------  
--                    R O T A T I O N  M O D E S                              
--  General       | DIN_X: Abscissa X  | DOUT_X = K*(DIN_X*cosA - DIN_Y*sinA) 
--  Rotation      | DIN_Y: Ordinate Y  | DOUT_Y = K*(DIN_Y*cosA + DIN_X*sinA) 
--  (by Givens)   | DIN_A: Phase A     | DOUT_A   -                           
                                                                              
--  Polar to      | DIN_X: Magnitude R | DOUT_X = K*R*cosA                    
--  Rectangular   | DIN_Y: 0           | DOUT_Y = K*R*sinA                    
--                | DIN_A: Phase A     | DOUT_A   -                           
                                                                              
--  Sin, Cos  | DIN_X: 0 (1/g applies internally) | DOUT_X = sinA             
--            | DIN_Y: 0                          | DOUT_Y = cosA             
--            | DIN_A: Phase A                    | DOUT_A   -                
                                                                              
--                    V E C T O R I N G  M O D E S                            
--  Rectangular | DIN_X: Abscissa X  | DOUT_X = K*sqrt(X^2+Y^2)'Magnitude R' 
--  to Polar    | DIN_Y: Ordinate Y  | DOUT_Y     -                           
--              | DIN_A: 0           | DOUT_A = arctan(Y/X)'Phase A'         
                                                                              
--  Arctan        | DIN_X: Abscissa X  | DOUT_X     -                         
--                | DIN_Y: Ordinate Y  | DOUT_Y     -                         
--                | DIN_A: 0           | DOUT_A = arctan(Y/X)'Phase A'       
                                                                              
--  K - CORDIC gain                                                         

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;

ENTITY cordic_bhvInpVect IS 
  PORT (
    count   : IN integer;
    xin, yin, ain: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)  );
END ENTITY cordic_bhvInpVect;

ARCHITECTURE rtl_gen OF cordic_bhvInpVect IS 
BEGIN
  PROCESS (count) 
  BEGIN
    CASE count IS
      WHEN  0 => 
        xin <= "0100000000";   --    256
        yin <= "0100000000";   --    256
        ain <= "0000000000";   --    0
      WHEN  1 => 
        xin <= "0011110000";   --    240
        yin <= "0011110000";   --    240
        ain <= "0000000000";   --    0
      WHEN  2 => 
        xin <= "0011100000";   --    224
        yin <= "0011100000";   --    224
        ain <= "0000000000";   --    0
      WHEN  3 => 
        xin <= "0011010000";   --    208
        yin <= "0011010000";   --    208
        ain <= "0000000000";   --    0
      WHEN  4 => 
        xin <= "0011000000";   --    192
        yin <= "0011000000";   --    192
        ain <= "0000000000";   --    0
      WHEN  5 => 
        xin <= "0010110000";   --    176
        yin <= "0010110000";   --    176
        ain <= "0000000000";   --    0
      WHEN  6 => 
        xin <= "0010100000";   --    160
        yin <= "0010100000";   --    160
        ain <= "0000000000";   --    0
      WHEN  7 => 
        xin <= "0010010000";   --    144
        yin <= "0010010000";   --    144
        ain <= "0000000000";   --    0
      WHEN  8 => 
        xin <= "0010000000";   --    128
        yin <= "0010000000";   --    128
        ain <= "0000000000";   --    0
      WHEN  9 => 
        xin <= "0001110000";   --    112
        yin <= "0001110000";   --    112
        ain <= "0000000000";   --    0
      WHEN 10 => 
        xin <= "0001100000";   --    96
        yin <= "0001100000";   --    96
        ain <= "0000000000";   --    0
      WHEN 11 => 
        xin <= "0001010000";   --    80
        yin <= "0001010000";   --    80
        ain <= "0000000000";   --    0
      WHEN 12 => 
        xin <= "0001000000";   --    64
        yin <= "0001000000";   --    64
        ain <= "0000000000";   --    0
      WHEN 13 => 
        xin <= "0000110000";   --    48
        yin <= "0000110000";   --    48
        ain <= "0000000000";   --    0
      WHEN 14 => 
        xin <= "0000100000";   --    32
        yin <= "0000100000";   --    32
        ain <= "0000000000";   --    0
      WHEN 15 => 
        xin <= "0000010000";   --    16
        yin <= "0000010000";   --    16
        ain <= "0000000000";   --    0
      WHEN OTHERS => 
        xin <= (others=>'0');
        yin <= (others=>'0');
        ain <= (others=>'0');
    END CASE;
  END PROCESS;
END ARCHITECTURE;
