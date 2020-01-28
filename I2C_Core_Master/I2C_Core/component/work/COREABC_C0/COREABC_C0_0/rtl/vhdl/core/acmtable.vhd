-- *********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Solutions Group
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  acmtable.vhd
--
-- Description: Simple APB Bus Controller
--              ACM Lookup table
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 11061 $
-- SVN $Date: 2009-11-17 09:09:46 -0800 (Tue, 17 Nov 2009) $
--
-- Notes:
--
-- *********************************************************************/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library COREABC_LIB;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_support.all;
entity COREABC_C0_COREABC_C0_0_ACMTABLE is
    generic (
        TESTMODE    : integer range 0 to 99
    );
    port (
        ACMADDR     : in  std_logic_vector(7 downto 0);
        ACMDATA     : out std_logic_vector(7 downto 0);
        ACMDO       : out std_logic
    );
end COREABC_C0_COREABC_C0_0_ACMTABLE;
architecture RTL of COREABC_C0_COREABC_C0_0_ACMTABLE is
begin
-- This is dummy data used for testing
process(ACMADDR)
variable ADDRINT  : integer range 0 to 255;
begin
   ADDRINT := conv_integer(ACMADDR);
   ACMDO <= '1';
   if TESTMODE>0 then
     case ADDRINT is
       when 0   to 99  => ACMDATA <= not ACMADDR;
       when 101 to 255 => ACMDATA <= not ACMADDR;
       when others     => ACMDATA <= (others =>'-');  ACMDO <= '0';
     end case;
   end if;
   if TESTMODE=0 then
   -- CCDirective Insert code

   end if;
end process;
end RTL;
