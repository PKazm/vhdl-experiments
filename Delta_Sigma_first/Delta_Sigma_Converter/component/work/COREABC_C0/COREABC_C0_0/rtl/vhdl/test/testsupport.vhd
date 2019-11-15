-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  testsupport.vhd
--
-- Description: Simple APB Bus Controller
--              Support package for testbench
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 27715 $
-- SVN $Date: 2016-10-25 15:07:51 +0100 (Tue, 25 Oct 2016) $
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
use COREABC_LIB.COREABC_C0_COREABC_C0_0_textio.all;

package COREABC_C0_COREABC_C0_0_testsupport is

type TABCCONFIG is record
   ID          : integer range 0 to 9  ;
   FAMILY      : integer range 0 to 99  ;
   APB_AWIDTH  : integer range 1 to 16  ;
   APB_DWIDTH  : integer range 8 to 32  ;
   APB_SDEPTH  : integer range 1 to 16  ;
   ICWIDTH     : integer range 1 to 16  ;
   ZRWIDTH     : integer range 0 to 16  ;
   IIWIDTH     : integer range 1 to 32  ;
   IFWIDTH     : integer range 0 to 28  ;
   IOWIDTH     : integer range 1 to 32  ;
   STWIDTH     : integer range 1 to 8   ;
   EN_RAM      : integer range 0 to 1   ;
   EN_AND      : integer range 0 to 1   ;
   EN_XOR      : integer range 0 to 1   ;
   EN_OR       : integer range 0 to 1   ;
   EN_ADD      : integer range 0 to 1   ;
   EN_INC      : integer range 0 to 1   ;
   EN_SHL      : integer range 0 to 1   ;
   EN_SHR      : integer range 0 to 1   ;
   EN_CALL     : integer range 0 to 1   ;
   EN_PUSH     : integer range 0 to 1   ;
   EN_ACM      : integer range 0 to 1   ;
   EN_MULT     : integer range 0 to 3   ;
   EN_DATAM    : integer range 0 to 3   ;
   EN_INT      : integer range 0 to 2   ;
   ISRADDR     : integer range 0 to 65535;
   DEBUG       : integer range 0 to 1   ;
   INSMODE     : integer range 0 to 2   ;
   INITWIDTH   : integer range 1 to 16  ;
   TESTMODE    : integer range 0 to 99  ;
   EN_IOREAD   : integer range 0 to 1   ;
   EN_IOWRT    : integer range 0 to 1   ;
   EN_ALURAM   : integer range 0 to 1   ;
   EN_INDIRECT : integer range 0 to 1   ;
end record;


function  tostr( x : integer) return string;
function  log2( x: integer ) return integer;
function  log2z( x: integer ) return integer;
function  APBsetup ( TN,FAMILY,INSMODE : integer) return TABCCONFIG;
function  set_generic(TN,X,Y: integer ) return integer;
function  override(X,Y: integer ) return integer;
function  overrideP(X,Y: integer ) return integer;
procedure printerror ( ERRORS : inout integer; str : string);
procedure checksetup (su : TABCCONFIG);

component COREABC_C0_COREABC_C0_0_APBModel
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
end component;

--component COREABC_C0_COREABC_C0_0_MAKEHEX
--  generic ( ENABLE   : boolean;
--            ID       : integer range 0 to 9 ;
--            FAMILY   : integer range 0 to 99;
--		    AWIDTH   : integer range 1 to 16;
--            DWIDTH   : integer range 8 to 32;
--            SDEPTH   : integer range 1 to 16;
--            ICWIDTH  : integer range 1 to 16;
--            IIWIDTH  : integer range 1 to 32;
--            IFWIDTH  : integer range 0 to 28;
--            TESTMODE : integer range 0 to 99
--           );
--end component;

--component COREABC_C0_COREABC_C0_0_INITGEN
--  generic ( ENABLE    : boolean;
--            ID        : integer range 0 to 9 ;
--            AWIDTH    : integer range 1 to 16;
--            DWIDTH    : integer range 8 to 32;
--            SDEPTH    : integer range 1 to 16 ;
--            ICWIDTH   : integer range 1 to 16;
--			INITWIDTH : integer range 1 to 16
--           );
--  port ( PCLK        : in  std_logic;
--         PRESETN     : in  std_logic;
--
--         -- RAM Initialization Port
--         INITDATVAL  : out std_logic;
--         INITDONE    : out std_logic;
--         INITADDR    : out std_logic_vector(INITWIDTH-1 downto 0);
--         INITDATA    : out std_logic_vector(8 downto 0)
--        );
--end component;

end COREABC_C0_COREABC_C0_0_testsupport;


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.COREABC_C0_COREABC_C0_0_support.all;


package body COREABC_C0_COREABC_C0_0_testsupport is

function log2( x: integer ) return integer is
begin
 case x is
   when 1   => return(0);
   when 2   => return(1);
   when 4   => return(2);
   when 8   => return(3);
   when 16  => return(4);
   when 32  => return(5);
   when 64  => return(6);
   when 128 => return(7);
   when 256 => return(8);
   when 512 => return(9);
   when others => return(-1);
 end case;
end log2;


function log2z( x: integer ) return integer is
begin
 case x is
   when 1   => return(1);
   when 2   => return(1);
   when 4   => return(2);
   when 8   => return(3);
   when 16  => return(4);
   when 32  => return(5);
   when 64  => return(6);
   when 128 => return(7);
   when 256 => return(8);
   when others => return(-1);
 end case;
end log2z;


function set_generic(TN,X,Y: integer ) return integer is
begin
  if TN=0 then
    return(X);
  else
    return(Y);
  end if;
end set_generic;

function override(X,Y: integer ) return integer is
begin
  if X=-1 then
    return(Y);
  else
    return(X);
  end if;
end override;

function overrideP(X,Y: integer ) return integer is
begin
  case X is
    when 1 => return(0);
    when 2 => return(0);
    when 3 => return(1);
    when 4 => return(1);
    when 5 => return(2);
    when others => return(Y);
  end case;
end overrideP;


-- This function creates the core configuration based on the testmode
-- NOTES
--  Builds 0-6 match the Synthesis
function APBsetup ( TN,FAMILY,INSMODE : integer) return TABCCONFIG is
variable setup : TABCCONFIG;
begin
 setup.FAMILY    := FAMILY;
 setup.TESTMODE  := TN;
 setup.INSMODE   := INSMODE;
 setup.INITWIDTH := 8;
 setup.ID        := 0;
 setup.DEBUG     := 1;
 -- Default settings
 setup.ZRWIDTH    := 8;
 setup.IIWIDTH    := 4;
 setup.IFWIDTH    := 4;
 setup.IOWIDTH    := 8;
 setup.EN_CALL    := 1;
 setup.EN_MULT    := 1;
 setup.EN_INC     := 1;
 setup.EN_ADD     := 1;
 setup.EN_AND     := 1;
 setup.EN_OR      := 1;
 setup.EN_XOR     := 1;
 setup.EN_SHL     := 1;
 setup.EN_SHR     := 1;
 setup.EN_DATAM   := 2;
 setup.EN_RAM     := 1;
 setup.EN_ACM     := 1;
 setup.ICWIDTH    := 8;
 setup.STWIDTH    := 4;
 setup.EN_PUSH    := 1;
 setup.INITWIDTH  := 16;
 setup.EN_INT     := 0;
 setup.ISRADDR    := 0;
 setup.EN_IOREAD  := 0;
 setup.EN_IOWRT   := 1;
 setup.EN_ALURAM  := 0;
 setup.EN_MULT    := 0;
 setup.EN_INDIRECT:= 0;


 case TN is
     when 0 => -- Example for controlling CoreAI
              setup.APB_AWIDTH   := 8;
              setup.APB_DWIDTH   := 16;
              setup.APB_SDEPTH   := 1;
              setup.ICWIDTH      := 5;
              setup.ZRWIDTH      := 0;
              setup.IIWIDTH      := 1;
              setup.IOWIDTH      := 2;
              setup.STWIDTH      := 1;
              setup.EN_RAM       := 0;
              setup.EN_AND       := 1;
              setup.EN_XOR       := 0;
              setup.EN_OR        := 0;
              setup.EN_ADD       := 1;
              setup.EN_INC       := 0;
              setup.EN_SHL       := 0;
              setup.EN_SHR       := 0;
              setup.EN_CALL      := 0;
              setup.EN_ACM       := 1;
              setup.EN_DATAM     := 2;
              setup.EN_INT       := 0;
              setup.EN_PUSH      := 0  ;
              setup.ISRADDR      := 0;

     when 1 => -- Build: Small 8 bit no adder
              setup.APB_AWIDTH   := 8  ;
              setup.APB_DWIDTH   := 8  ;
              setup.APB_SDEPTH   := 1  ;
              setup.ICWIDTH      := 5  ;
              setup.ZRWIDTH      := 0  ;
              setup.IIWIDTH      := 4  ;
              setup.IOWIDTH      := 8  ;
              setup.STWIDTH      := 1  ;
              setup.EN_RAM       := 0  ;
              setup.EN_AND       := 1  ;
              setup.EN_XOR       := 1  ;
              setup.EN_OR        := 0  ;
              setup.EN_ADD       := 0  ;
              setup.EN_INC       := 1  ;
              setup.EN_SHL       := 0  ;
              setup.EN_SHR       := 0  ;
              setup.EN_CALL      := 0  ;
              setup.EN_ACM       := 0  ;
              setup.EN_DATAM     := 2  ;
              setup.EN_PUSH      := 0  ;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;

     when 2 => -- Build: Small 16 bit
              setup.APB_AWIDTH   := 8 ;
              setup.APB_DWIDTH   := 16 ;
              setup.APB_SDEPTH   := 1 ;
              setup.ICWIDTH      := 5 ;
              setup.ZRWIDTH      := 0 ;
              setup.IIWIDTH      := 4 ;
              setup.IOWIDTH      := 8 ;
              setup.STWIDTH      := 1 ;
              setup.EN_RAM       := 0 ;
              setup.EN_AND       := 1 ;
              setup.EN_XOR       := 1 ;
              setup.EN_OR        := 0 ;
              setup.EN_ADD       := 1 ;
              setup.EN_INC       := 0 ;
              setup.EN_SHL       := 0 ;
              setup.EN_SHR       := 0 ;
              setup.EN_CALL      := 0 ;
              setup.EN_ACM       := 0 ;
              setup.EN_DATAM     := 2 ;
              setup.EN_INT       := 0;
              setup.EN_PUSH      := 0  ;
              setup.ISRADDR      := 0;

     when 3 => --Build: Small 32 bit
              setup.APB_AWIDTH   := 8;
              setup.APB_DWIDTH   := 32 ;
              setup.APB_SDEPTH   := 1;
              setup.ICWIDTH      := 5;
              setup.ZRWIDTH      := 0;
              setup.IIWIDTH      := 4;
              setup.IOWIDTH      := 8;
              setup.STWIDTH      := 1;
              setup.EN_RAM       := 0;
              setup.EN_AND       := 1;
              setup.EN_XOR       := 1;
              setup.EN_OR        := 0;
              setup.EN_ADD       := 1;
              setup.EN_INC       := 0;
              setup.EN_SHL       := 0;
              setup.EN_SHR       := 0;
              setup.EN_CALL      := 0;
              setup.EN_ACM       := 0;
              setup.EN_DATAM     := 2;
              setup.EN_PUSH      := 0  ;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;

     when 4 => --Build: Complete 8 bit
              setup.APB_AWIDTH   := 8   ;
              setup.APB_DWIDTH   := 8   ;
              setup.APB_SDEPTH   := 1   ;
              setup.ICWIDTH      := 5   ;
              setup.ZRWIDTH      := 8   ;
              setup.IIWIDTH      := 4   ;
              setup.IOWIDTH      := 8   ;
              setup.STWIDTH      := 1   ;
              setup.EN_RAM       := 1   ;
              setup.EN_AND       := 1   ;
              setup.EN_XOR       := 1   ;
              setup.EN_OR        := 1   ;
              setup.EN_ADD       := 1   ;
              setup.EN_INC       := 1   ;
              setup.EN_SHL       := 1   ;
              setup.EN_SHR       := 1   ;
              setup.EN_CALL      := 1   ;
              setup.EN_ACM       := 0   ;
              setup.EN_DATAM     := 2   ;
              setup.EN_PUSH      := 0  ;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;


     when 5 => --Build: Complete 16 bit
              setup.APB_AWIDTH   := 8  ;
              setup.APB_DWIDTH   := 16  ;
              setup.APB_SDEPTH   := 1  ;
              setup.ICWIDTH      := 5  ;
              setup.ZRWIDTH      := 8  ;
              setup.IIWIDTH      := 4  ;
              setup.IOWIDTH      := 8  ;
              setup.STWIDTH      := 1  ;
              setup.EN_RAM       := 1  ;
              setup.EN_AND       := 1  ;
              setup.EN_XOR       := 1  ;
              setup.EN_OR        := 1  ;
              setup.EN_ADD       := 1  ;
              setup.EN_INC       := 1  ;
              setup.EN_SHL       := 1  ;
              setup.EN_SHR       := 1  ;
              setup.EN_CALL      := 1  ;
              setup.EN_ACM       := 0  ;
              setup.EN_DATAM     := 2   ;
              setup.EN_PUSH      := 0  ;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;

     when 6 => --Build: Complete 32 bit
              setup.APB_AWIDTH   := 8 ;
              setup.APB_DWIDTH   := 32  ;
              setup.APB_SDEPTH   := 1 ;
              setup.ICWIDTH      := 5 ;
              setup.ZRWIDTH      := 8 ;
              setup.IIWIDTH      := 4 ;
              setup.IOWIDTH      := 8 ;
              setup.STWIDTH      := 1 ;
              setup.EN_RAM       := 1 ;
              setup.EN_AND       := 1 ;
              setup.EN_XOR       := 1 ;
              setup.EN_OR        := 1 ;
              setup.EN_ADD       := 1 ;
              setup.EN_INC       := 1 ;
              setup.EN_SHL       := 1 ;
              setup.EN_SHR       := 1 ;
              setup.EN_CALL      := 1 ;
              setup.EN_ACM       := 0 ;
              setup.EN_DATAM     := 2 ;
              setup.EN_PUSH      := 0  ;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;

    when 11 => -- Fully Configured 8 Bit Configuration with v2.2 instructions
              setup.APB_AWIDTH  := 10;
              setup.APB_DWIDTH  := 8;
              setup.APB_SDEPTH  := 4;
              setup.ZRWIDTH     := 8;
              setup.IIWIDTH     := 8;
              setup.IOWIDTH     := 8;
              setup.EN_CALL     := 1;
              setup.EN_INC      := 1;
              setup.EN_ADD      := 1;
              setup.EN_AND      := 1;
              setup.EN_OR       := 1;
              setup.EN_XOR      := 1;
              setup.EN_SHL      := 1;
              setup.EN_SHR      := 1;
              setup.EN_DATAM    := 2;
              setup.EN_RAM      := 1;
              setup.EN_ACM      := 1;
              setup.EN_PUSH     := 1;
              setup.EN_INT      := 1;
			  setup.ISRADDR     := 400;
              setup.ICWIDTH     := 10;
              setup.STWIDTH     := 4;
              setup.EN_IOREAD   := 1;
              setup.EN_ALURAM   := 1;
              setup.EN_MULT     := 2;
              setup.EN_INDIRECT := 1;

    when 12 => -- Fully Configured 16 Bit Configuration
              setup.APB_AWIDTH  := 8;
              setup.APB_DWIDTH  := 16;
              setup.APB_SDEPTH  := 4;
              setup.ZRWIDTH     := 8;
              setup.IIWIDTH     := 4;
              setup.IOWIDTH     := 8;
              setup.EN_CALL     := 1;
              setup.EN_INC      := 1;
              setup.EN_ADD      := 1;
              setup.EN_AND      := 1;
              setup.EN_OR       := 1;
              setup.EN_XOR      := 1;
              setup.EN_SHL      := 1;
              setup.EN_SHR      := 1;
              setup.EN_DATAM    := 2;
              setup.EN_RAM      := 1;
              setup.EN_ACM      := 1;
              setup.ICWIDTH     := 8;
              setup.STWIDTH     := 4;
              setup.EN_PUSH     := 1  ;
              setup.EN_INT      := 0;
              setup.ISRADDR     := 0;
    when 13 => -- Fully Configured 32 Bit Configuration
              setup.APB_AWIDTH   := 8;
              setup.APB_DWIDTH   := 32;
              setup.APB_SDEPTH   := 4;
              setup.ZRWIDTH      := 8;
              setup.IIWIDTH      := 4;
              setup.IOWIDTH      := 8;
              setup.EN_CALL      := 1;
              setup.EN_INC       := 1;
              setup.EN_ADD       := 1;
              setup.EN_AND       := 1;
              setup.EN_OR        := 1;
              setup.EN_XOR       := 1;
              setup.EN_SHL       := 1;
              setup.EN_SHR       := 1;
              setup.EN_DATAM     := 2;
              setup.EN_RAM       := 1;
              setup.EN_ACM       := 1;
              setup.ICWIDTH      := 8;
              setup.STWIDTH      := 4;
              setup.EN_PUSH      := 1;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;
    when 14 => -- Small 8 Bit Configuration with call
              setup.APB_AWIDTH   := 8;
              setup.APB_DWIDTH   := 8;
              setup.APB_SDEPTH   := 4;
              setup.ZRWIDTH      := 8;
              setup.IIWIDTH      := 4;
              setup.IOWIDTH      := 8;
              setup.EN_CALL      := 1;
              setup.EN_INC       := 0;
              setup.EN_ADD       := 1;
              setup.EN_AND       := 1;
              setup.EN_OR        := 1;
              setup.EN_XOR       := 1;
              setup.EN_SHL       := 0;
              setup.EN_SHR       := 0;
              setup.EN_DATAM     := 1;
              setup.EN_RAM       := 0;
              setup.EN_ACM       := 0;
              setup.ICWIDTH      := 8;
              setup.STWIDTH      := 4;
              setup.EN_PUSH      := 1  ;
              setup.EN_INT       := 0;
              setup.ISRADDR      := 0;
    when 15 => -- Small 8 Bit Configuration no call and 1 slot
              setup.APB_AWIDTH  := 8;
              setup.APB_DWIDTH  := 8;
              setup.APB_SDEPTH  := 1;
              setup.ZRWIDTH     := 8;
              setup.IIWIDTH     := 4;
              setup.IOWIDTH     := 8;
              setup.EN_CALL     := 0;
              setup.EN_INC      := 1;
              setup.EN_ADD      := 0;
              setup.EN_AND      := 0;
              setup.EN_OR       := 0;
              setup.EN_XOR      := 1;
              setup.EN_SHL      := 0;
              setup.EN_SHR      := 0;
              setup.EN_DATAM    := 3;
              setup.EN_RAM      := 0;
              setup.EN_ACM      := 0;
              setup.ICWIDTH     := 8;
              setup.STWIDTH     := 1;
              setup.EN_PUSH     := 0;
              setup.EN_INT      := 0;
              setup.ISRADDR     := 0;
    when 16 => -- Full 8 bit configuration with RAM based Instructions
              setup.APB_AWIDTH := 8;
              setup.APB_DWIDTH := 8;
              setup.APB_SDEPTH := 4;
              setup.ZRWIDTH    := 8;
              setup.IIWIDTH    := 4;
              setup.IOWIDTH    := 8;
              setup.EN_CALL    := 1;
              setup.EN_INC     := 1;
              setup.EN_ADD     := 1;
              setup.EN_AND     := 1;
              setup.EN_OR      := 1;
              setup.EN_XOR     := 1;
              setup.EN_SHL     := 1;
              setup.EN_SHR     := 1;
              setup.EN_DATAM   := 2;
              setup.EN_RAM     := 1;
              setup.EN_ACM     := 1;
              setup.ICWIDTH    := 8;
              setup.STWIDTH    := 4;
              setup.EN_PUSH    := 1;
			  setup.INITWIDTH  := 2;
              setup.EN_INT     := 0;
              setup.ISRADDR    := 0;

       -- These test core with various generics effecting main widths
       when 20  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH := 8; setup.APB_SDEPTH := 16;  setup.ICWIDTH := 12;
       when 21  =>  setup.APB_AWIDTH := 8;  setup.APB_DWIDTH := 8; setup.APB_SDEPTH := 1;   setup.ICWIDTH := 8;
       when 22  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH :=32; setup.APB_SDEPTH := 16;  setup.ICWIDTH := 12;
       when 23  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH :=16; setup.APB_SDEPTH := 1 ;  setup.ICWIDTH := 7;
       when 24  =>  setup.APB_AWIDTH := 8;  setup.APB_DWIDTH :=16; setup.APB_SDEPTH := 1;   setup.ICWIDTH := 8;
       when 25  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH :=32; setup.APB_SDEPTH := 16;  setup.ICWIDTH := 12;
       when 26  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH :=16; setup.APB_SDEPTH := 16;  setup.ICWIDTH := 12;
       when 27  =>  setup.APB_AWIDTH := 10; setup.APB_DWIDTH :=32; setup.APB_SDEPTH := 1;   setup.ICWIDTH := 10;
       when 28  =>  setup.APB_AWIDTH := 9;  setup.APB_DWIDTH :=16; setup.APB_SDEPTH := 1;   setup.ICWIDTH := 8;
       when 29  =>  setup.APB_AWIDTH := 8;  setup.APB_DWIDTH := 8; setup.APB_SDEPTH := 1;   setup.ICWIDTH := 7;
       when 30  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH :=32; setup.APB_SDEPTH := 16;  setup.ICWIDTH := 15;
       when 31  =>  setup.APB_AWIDTH := 16; setup.APB_DWIDTH :=8 ; setup.APB_SDEPTH := 2 ;  setup.ICWIDTH := 16; -- 32 bit instruction

	   when others => assert FALSE
	                    report "Testbench not configured for the TESTMODE setting used"
	                    severity failure;
  end case;

  setup.INITWIDTH := calc_initwidth(setup.APB_AWIDTH,setup.APB_DWIDTH,setup.APB_SDEPTH,setup.ICWIDTH);

  return(setup);
end APBsetup;




function tostr( x : integer) return string is
begin
  if x=0 then return("Disabled");
         else return("Enabled");
  end if;
end tostr;


procedure printerror ( ERRORS : inout integer; str : string) is
begin
  ERRORS := ERRORS + 1;
  printf("ERROR: %s",fmt(str));
  assert FALSE
    report " Simulation stopped due to error"
    severity ERROR;
end printerror;



procedure checksetup (su : TABCCONFIG) is
variable ERR : BOOLEAN;
begin
  ERR := FALSE;
  if su.IIWIDTH > su.APB_DWIDTH    then
     printf("ERROR:IO IN width is greater than DWIDTH");
     ERR := TRUE;
  end if;
  if su.ZRWIDTH > su.APB_DWIDTH then
    printf("ERROR:Loop Count  width is greater than DWIDTH");
    ERR := TRUE;
  end if;
  if su.ICWIDTH > su.APB_AWIDTH then
    printf("Too many instructions for AWIDTH");
    ERR := TRUE;
  end if;

  if ERR then
    assert FALSE
      report "Simulation stopped due to core configuration error"
      severity FAILURE;
  end if;

end checksetup;


end COREABC_C0_COREABC_C0_0_testsupport;
