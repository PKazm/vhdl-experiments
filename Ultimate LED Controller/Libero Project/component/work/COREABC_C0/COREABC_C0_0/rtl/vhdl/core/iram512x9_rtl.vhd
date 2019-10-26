-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  iram512x9_rtl.vhd
--
-- Description: Simple APB Bus Controller
--              Instruction RAM model
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 11083 $
-- SVN $Date: 2009-11-18 18:12:53 +0000 (Wed, 18 Nov 2009) $
--
-- Notes:
--   Supports initialisation from interface and RAM file
--
--
-- *********************************************************************/


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use std.textio.all;

entity COREABC_C0_COREABC_C0_0_IRAM512X9 is
    generic ( CID  : integer;   -- Indicates column of instruction word
              RID  : integer;   -- Indicates row of instruction word
              UNIQ_STRING_LENGTH : integer range 1 to 256 := 10
            );
	 port( RWCLK      : in  std_logic;
		   RESET      : in  std_logic;
		   RENABLE    : in  std_logic;
		   RADDR      : in  std_logic_vector(8 downto 0);
	       RD         : out std_logic_vector(8 downto 0);
           INITADDR   : in  std_logic_vector(8 downto 0);
		   WENABLE    : in  std_logic;
           INITDATA   : in  std_logic_vector(8 downto 0)
          );
end COREABC_C0_COREABC_C0_0_IRAM512X9;


architecture RTL of COREABC_C0_COREABC_C0_0_IRAM512X9 is

subtype RWORD     is std_logic_vector (8 downto 0);
type RAM_ARRAY    is array ( INTEGER range <>) of RWORD;

constant RAMFILE : string (1 to (UNIQ_STRING_LENGTH+11)) :=  "COREABC_C0_COREABC_C0_0_RAM_" & CHARACTER'VAL(RID+48) & CHARACTER'VAL(CID+48) & ".mem";


begin


 process(RWCLK)
 variable RAM      : RAM_ARRAY(0 to 511);
 variable iaddr    : INTEGER range 0 to 511 := 0;
 variable INITDONE : boolean := FALSE;
 file     FSTR     : TEXT;
 variable L        : LINE;
 variable FSTATUS  : FILE_OPEN_STATUS;
 variable ch       : character;
 variable data     : std_logic_vector(8 downto 0);
 begin
   if RWCLK'event and RWCLK='1' then

       -- RAM Initialisation
       if not INITDONE then
         file_open(fstatus,FSTR,RAMFILE);
         if not (fstatus=open_ok) then
           assert FALSE  report "Failed to load memory file " & RAMFILE severity WARNING;
         else
 		  for i in 0 to 511 loop
             data := ( others => '0');
             readline(FSTR,L);
             for b in 8 downto 0 loop
               read(L,ch);
               case ch is
                 when '0' => data(b) := '0';
                 when '1' => data(b) := '1';
                 when others => assert FALSE report "Illegal Character in Memory File" severity FAILURE;
               end case;
             end loop;
             RAM(i) := data;
           end loop;
           file_close(FSTR);
         end if;
        INITDONE := TRUE;
      end if;

     if WENABLE='1' then
       iaddr := conv_integer(INITADDR);
       RAM(iaddr)  := INITDATA;
     end if;

     iaddr := conv_integer(RADDR);
     RD <= RAM(iaddr);

   end if;
 end process;




end RTL;
