-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  apbmodel.vhd
--
-- Description: Simple APB Bus Controller
--              Simple model of APB slave device
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 14578 $
-- SVN $Date: 2010-11-10 15:03:21 +0000 (Wed, 10 Nov 2010) $
--
-- Notes:
--
-- *********************************************************************/

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library COREABC_LIB;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_misc.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_textio.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_support.all;

entity COREABC_C0_COREABC_C0_0_APBModel is
  generic ( ID      : integer range 0 to 15;
            DEBUG   : integer range 0 to 1;
            AWIDTH  : integer range 1 to 16;
            DWIDTH  : integer range 8 to 32
           );

  port ( PCLK        : in  std_logic;
         PRESETN     : in  std_logic;

         -- APB Interface
         PENABLE     : in  std_logic;
         PWRITE      : in  std_logic;
         PSEL        : in  std_logic;
         PADDR       : in  std_logic_vector( AWIDTH-1 downto 0);
         PWDATA      : in  std_logic_vector( DWIDTH-1 downto 0);
         PRDATA      : out std_logic_vector( DWIDTH-1 downto 0);
         PREADY      : out std_logic
       );
end COREABC_C0_COREABC_C0_0_APBModel;


architecture Model of COREABC_C0_COREABC_C0_0_APBModel is

constant DEPTH : integer := (2 ** AWIDTH);
subtype RWORD     is std_logic_vector (DWIDTH-1 downto 0);
type RAM_ARRAY    is array ( INTEGER range <>) of RWORD;

signal PENABLE_D0 : std_logic;
signal PENABLE_D1 : std_logic;
signal PENABLE_D2 : std_logic;
signal PWRITE_D0  : std_logic;
signal PWRITE_D1  : std_logic;
signal PWRITE_D2  : std_logic;
signal PSEL_D0    : std_logic;
signal PSEL_D1    : std_logic;
signal PSEL_D2    : std_logic;
signal PADDR_D0   : std_logic_vector(AWIDTH-1 downto 0);
signal PADDR_D1   : std_logic_vector(AWIDTH-1 downto 0);
signal PADDR_D2   : std_logic_vector(AWIDTH-1 downto 0);
signal PWDATA_D0  : std_logic_vector(DWIDTH-1 downto 0);
signal PWDATA_D1  : std_logic_vector(DWIDTH-1 downto 0);
signal PWDATA_D2  : std_logic_vector(DWIDTH-1 downto 0);

begin

PREADY <= '1';   -- ready is not supported on APB

--------------------------------------------------------------------------------
-- The RAM block for storing data

PRAM:
process(PCLK)
variable RAM      : RAM_ARRAY( 0 to DEPTH-1);
variable iaddr    : INTEGER := 0;
variable RDATA    : RWORD;
begin
 if PCLK'event and PCLK='1' and PRESETN='1' then
    if PSEL='1' then
      iaddr := conv_integer(PADDR);
      if PENABLE='1' and PWRITE='1' then
          RAM(iaddr) := PWDATA;
          if debug>0 then
		    printf("APBM: Slot %d Write %04h=%04h ",fmt(ID)&fmt(iaddr)&fmt(PWDATA));
		  end if;
      end if;
      if PWRITE='0' then
        RDATA := RAM(iaddr);
        PRDATA <= RDATA;
        if PENABLE='1' and DEBUG>0 then
	      printf("APBM: Slot %d Read %04h=%04h ",fmt(ID)&fmt(iaddr)&fmt(RDATA));
        end if;
	  end if;
    end if;
 end if;
end process;

--------------------------------------------------------------------------------
-- APB Protocol Checks


PENABLE_D0  <= PENABLE;
PWRITE_D0   <= PWRITE;
PSEL_D0     <= PSEL;
PADDR_D0    <= clean(PADDR);
PWDATA_D0   <= clean(PWDATA);

process(PCLK)
variable ERR      : BOOLEAN;
begin
 if PCLK'event and PCLK='1' and PRESETN='1'  then
   PENABLE_D1  <=  PENABLE_D0;
   PENABLE_D2  <=  PENABLE_D1;
   PWRITE_D1   <=  PWRITE_D0;
   PWRITE_D2   <=  PWRITE_D1;
   PSEL_D1     <=  PSEL_D0;
   PSEL_D2     <=  PSEL_D1;
   PADDR_D1    <=  PADDR_D0;
   PADDR_D2    <=  PADDR_D1;
   PWDATA_D1   <=  PWDATA_D0;
   PWDATA_D2   <=  PWDATA_D1;

   ERR := FALSE;
   -- second cycle
   if PENABLE_D0='1' and PSEL_D0='1' then
     if PADDR_D0/=PADDR_D1 then
	   printf("APM:%d Address not stable in both cycles",fmt(ID));
	   ERR := TRUE;
	 end if;
     if PWRITE_D0/=PWRITE_D1 then
	   printf("APM:%d PWRITE not stable in both cycles",fmt(ID));
	   ERR := TRUE;
	 end if;
     if PSEL_D0/=PSEL_D1 then
	   printf("APM:%d PSEL not stable in both cycles",fmt(ID));
	   ERR := TRUE;
	 end if;
     if PWDATA_D0/=PWDATA_D1 and PWRITE_D0='1' then
	   printf("APM:%d PWDATA not stable in both cycles",fmt(ID));
	   ERR := TRUE;
	 end if;
     if PSEL_D1/='1' then
       printf("APM:%d PSEL was not active in cycle before PENABLE",fmt(ID));
       ERR := TRUE;
     end if;
   end if;
   -- General Checks
   if PENABLE_D0='1' and PENABLE_D1='1' then
     printf("APM:%d PENABLE active for more than one clocks",fmt(ID));
     ERR := TRUE;
   end if;
   if PSEL_D0='1' and PSEL_D1='1' and PSEL_D2='1'  then
     printf("APM:%d PSEL active for more than two clocks",fmt(ID));
     ERR := TRUE;
   end if;
   if ERR then
     assert FALSE
       report "APB Protocol violation"
       severity ERROR;
   end if;
 end if;
end process;



end Model;
