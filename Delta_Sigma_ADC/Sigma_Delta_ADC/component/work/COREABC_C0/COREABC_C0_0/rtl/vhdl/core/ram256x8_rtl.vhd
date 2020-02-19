-- ********************************************************************/
-- Copyright 2006 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  Ram256x8_rtl.vhd
--
-- Description: Simple APB Bus Controller
--              Low Level RAM Model (Generic Family)
--
-- Rev: 2.0  31Oct06 IPB  : Production Release
--
-- Notes:
--
-- *********************************************************************/

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity COREABC_C0_COREABC_C0_0_RAM256X8 is
    port(  RWCLK    : in  std_logic;
           RESET    : in  std_logic;
           WEN      : in  std_logic;
           REN      : in  std_logic;
           WADDR    : in  std_logic_vector(7 downto 0);
           RADDR    : in  std_logic_vector(7 downto 0);
           WD       : in  std_logic_vector(7 downto 0);
           RD       : out std_logic_vector(7 downto 0)
      );
end COREABC_C0_COREABC_C0_0_RAM256X8;


architecture RTL of  COREABC_C0_COREABC_C0_0_RAM256X8 is

subtype RWORD     is std_logic_vector (7 downto 0);
type RAM_ARRAY    is array ( INTEGER range <>) of RWORD;

begin

 process(RWCLK)
 variable iaddr : integer;
 variable RAM  : RAM_ARRAY(0 to 255);
 begin
   if RWCLK'event and RWCLK='1' then

     if WEN='1' then
       iaddr := conv_integer(WADDR);
       RAM(iaddr)  := WD;
     end if;

     iaddr := conv_integer(RADDR);
     if REN='1' then
	   RD <= RAM(iaddr);
	 end if;
   end if;
 end process;



end RTL;
