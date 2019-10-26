-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  debugblk.vhd
--
-- Description: ABC State Machine
--              Debug Block
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 16742 $
-- SVN $Date: 2012-04-13 00:26:17 +0100 (Fri, 13 Apr 2012) $
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

-- synthesis translate_off
use COREABC_LIB.COREABC_C0_COREABC_C0_0_textio.all;
-- synthesis translate_on


entity COREABC_C0_COREABC_C0_0_DEBUGBLK is
 generic  ( DEBUG      : integer range 0 to 1;
            AWIDTH     : integer range 1 to 16;
            DWIDTH     : integer range 8 to 32;
            SWIDTH     : integer range 0 to 4;
            SDEPTH     : integer range 1 to 16;
            ICWIDTH    : integer range 1 to 16 ;
            ICDEPTH    : integer range 1 to 65536;
            ZRWIDTH    : integer range 0 to 16;
            IIWIDTH    : integer range 1 to 32;
            IOWIDTH    : integer range 1 to 32;
            IRWIDTH    : integer range 1 to 32;
			EN_MULT    : integer range 0 to 3
        );
 port     ( PCLK       : in std_logic;
            RESETN     : in std_logic;
		    ISR        : in std_logic;
            SMADDR     : in std_logic_vector(ICWIDTH-1 downto 0);
            INSTR_CMD  : in std_logic_vector(2 downto 0);
            INSTR_SCMD : in std_logic_vector(2 downto 0);
            INSTR_DATA : in std_logic_vector(DWIDTH-1 downto 0);
            INSTR_ADDR : in std_logic_vector(AWIDTH-1 downto 0);
            INSTR_SLOT : in std_logic_vector(SWIDTH   downto 0);
            PRDATA     : in std_logic_vector(DWIDTH-1 downto 0);
            PWDATA     : in std_logic_vector(DWIDTH-1 downto 0);
            ACCUM_OLD  : in std_logic_vector(DWIDTH-1 downto 0);
            ACCUM_NEW  : in std_logic_vector(DWIDTH-1 downto 0);
            ACCUM_ZERO : in std_logic;
            ACCUM_NEG  : in std_logic;
            FLAGS      : in std_logic;
            RAMDOUT    : in std_logic_vector(DWIDTH-1 downto 0);
            STKPTR     : in std_logic_vector(7 downto 0);
            ZREGISTER  : in std_logic_vector(ZRWIDTH  downto 0);
            ACMDO      : in std_logic;
            DEBUG1     : in std_logic;
            DEBUG2     : in std_logic
          );
end COREABC_C0_COREABC_C0_0_DEBUGBLK;


architecture RTL of COREABC_C0_COREABC_C0_0_DEBUGBLK is

-- synthesis translate_off

function bitpos( x : std_logic_vector; b: std_logic) return integer is
variable bp : integer;
begin
  for i in x'range loop
    if x(i)=b then
	  bp := i;
	end if;
  end loop;
  return(bp);
end bitpos;


function tostr_opcode0(accnew,accold : std_logic_vector;
                       scmd : integer range 0 to 7;
					   data : std_logic_vector;
					   muxc : std_logic;
					   addr: std_logic_vector
					   ) return string is
variable XSCMD : std_logic_vector(2 downto 0);
variable str : string(1 to 80);
variable sd : integer;
begin
 case data(1 downto 0) is
   when "00"   => sd := 0;
   when "01"   => sd := 1;
   when "10"   => sd := 14;
   when others => sd := 15;
 end case;
 if muxc/='1' then
   case scmd is
    when 0  => if EN_MULT=0 then
	             sprintf(str,"ACCUM %02x <= %02x INC"     ,fmt(accnew)&fmt(accold));
               else
			     sprintf(str,"ACCUM %02x <= %02x MULT %02x",fmt(accnew)&fmt(accold)&fmt(data));
			   end if;
    when 1  => sprintf(str,"ACCUM %02x <= %02x AND %02x",fmt(accnew)&fmt(accold)&fmt(data));
    when 2  => sprintf(str,"ACCUM %02x <= %02x OR  %02x",fmt(accnew)&fmt(accold)&fmt(data));
    when 3  => sprintf(str,"ACCUM %02x <= %02x XOR %02x",fmt(accnew)&fmt(accold)&fmt(data));
    when 4  => sprintf(str,"ACCUM %02x <= %02x ADD %02x",fmt(accnew)&fmt(accold)&fmt(data));
    when 5  => if sd=15 then
                 sprintf(str,"ACCUM %02x <= %02x ROL",fmt(accnew)&fmt(accold));
               else
  			   sprintf(str,"ACCUM %02x <= %02x SHL%x",fmt(accnew)&fmt(accold)&fmt(sd));
  			 end if;
    when 6  => if sd=15 then
                 sprintf(str,"ACCUM %02x <= %02x ROR",fmt(accnew)&fmt(accold));
               else
  			   sprintf(str,"ACCUM %02x <= %02x SHR%x",fmt(accnew)&fmt(accold)&fmt(sd));
  			 end if;
    when 7  => sprintf(str,"LOAD %02x",fmt(data));
    when others  => sprintf(str,"UNEXPECTED INSTRUCTION");
   end case;
 else
   case scmd is
    when 0  => if EN_MULT>0 then
	             sprintf(str,"ACCUM %02x <= %02x MULT RAM(%d) %02x",fmt(accnew)&fmt(accold)&fmt(addr)&fmt(data));
   			   end if;
    when 1  => sprintf(str,"ACCUM %02x <= %02x AND RAM(%d) %02x",fmt(accnew)&fmt(accold)&fmt(addr)&fmt(data));
    when 2  => sprintf(str,"ACCUM %02x <= %02x OR  RAM(%d) %02x",fmt(accnew)&fmt(accold)&fmt(addr)&fmt(data));
    when 3  => sprintf(str,"ACCUM %02x <= %02x XOR RAM(%d) %02x",fmt(accnew)&fmt(accold)&fmt(addr)&fmt(data));
    when 4  => sprintf(str,"ACCUM %02x <= %02x ADD RAM(%d) %02x",fmt(accnew)&fmt(accold)&fmt(addr)&fmt(data));
    when 7  => sprintf(str,"LOAD RAM(%d) %02x",fmt(addr)&fmt(data));
    when others  => sprintf(str,"UNEXPECTED INSTRUCTION");
   end case;
 end if;
 return(str);
end tostr_opcode0;


function tostr_opcode1(accnew,accold : std_logic_vector;
                       scmd : integer range 0 to 7;
					   data : std_logic_vector;
					   muxc : std_logic; addr: std_logic_vector  ) return string is
variable XSCMD : std_logic_vector(2 downto 0);
variable str : string(1 to 16);
variable sd : integer;
begin
 if muxc/='1' then
   case scmd is
    when 1  => sprintf(str,"BITTST (%02x) %d",fmt(accold)&fmt(bitpos(data,'1')));
    when 3  => sprintf(str,"CMP (%02x) to %02x",fmt(accold)&fmt(data));
    when 4  => sprintf(str,"CMPLEQ (%02x) %02x",fmt(accold)&fmt(data));
    when others  => sprintf(str,"UNEXPECTED INSTRUCTION");
   end case;
 else
   case scmd is
    when 3  => sprintf(str,"CMP (%02x) RAM(%d) %02x",fmt(accold)&fmt(addr)&fmt(data));
    when others  => sprintf(str,"UNEXPECTED INSTRUCTION");
   end case;
 end if;
 return(str);
end tostr_opcode1;

function tostr_condition(SDATA,SCMD : std_logic_vector; IIWIDTH : integer ) return string is
variable str : string (1 to 80);
begin
 if SDATA(0)='1' then
   if SCMD(0)='1' then
      sprintf(str,"ALWAYS");
   else
      sprintf(str,"NEVER");
   end if;
 else
   sprintf(str,"");
   if SCMD(0)='0' then
      sprintf(str,"NOTIF");
   else
      sprintf(str,"IF");
   end if;
   if SDATA(1)='1' then
     sprintf(str,"%s ZERO",fmt(str));
   end if;
   if SDATA(2)='1' then
     sprintf(str,"%s NEG",fmt(str));
   end if;
   if SDATA(3)='1' then
     sprintf(str,"%s LCZERO",fmt(str));
   end if;
   for i in 0 to min1(IIWIDTH,SDATA'left+1-4)-1 loop
    if SDATA(4+i)='1' then
      sprintf(str,"%s INPUT%d",fmt(str)&fmt(i));
    end if;
   end loop;
 end if;
 return(str);
end tostr_condition;


function flagvalue(acc: std_logic_vector ) return string is
variable str : string(1 to 4);
begin
  if acc=0 then
    str := "ZERO";
  elsif acc(DWIDTH-1)='1' then
    str := "NEG ";
  else
    str := "POS ";
  end if;
  return(str);
end flagvalue;

function tostr_taken(flags: std_logic; data: std_logic_vector ) return string is
variable str : string(1 to 4);
begin
  if data(0)='1' then
    return(" ");
  elsif flags='1' then
    return(" (taken)");
  else
    return(" (not taken)");
  end if;
end tostr_taken;

function disassemble( accnew,accold : std_logic_vector;
                      cmdi,scmdi,slot,addr,data,stkptr,ZREGISTER: std_logic_vector;
                      iiwdith: integer ;
					  acmdo : std_logic;
					  flags : std_logic ) return string	is
variable cmd,scmd : integer range 0 to 7;
variable str : string(1 to 40);
variable muxc : std_logic;
variable ndata : std_logic_vector(data'range);
variable ONE,MINUSONE : std_logic_vector(data'range);
begin
  ONE      := ( others => '0');
  ONE(0)   := '1';
  MINUSONE := ( others => '1');
  ndata    := 0 - clean(data);
  cmd := 0; scmd:=0;
  muxc := slot(0);
  for i in 0 to 2 loop
    if cmdi(i)='1'  then cmd := cmd + 2**i;	end if;
    if scmdi(i)='1' then scmd:= scmd + 2**i; end if;
  end loop;
  case CMD is
    when 0 =>  sprintf(str,"%s",fmt(tostr_opcode0(accnew,accold,scmd,data,muxc,addr)));
    when 1 =>  sprintf(str,"%s",fmt(tostr_opcode1(accnew,accold,scmd,data,muxc,addr)));
	when 2 =>  case scmd is
	            when 0 => sprintf(str,"APBWRT ACC %d:%02x = %02x",fmt(slot)&fmt(addr)&fmt(data));
	            when 1 => sprintf(str,"APBWRT DAT %d:%02x = %02x",fmt(slot)&fmt(addr)&fmt(data));
	            when 2 => if ACMDO='1' then
				             sprintf(str,"APBWRT ACM %d:%02x = %02x",fmt(slot)&fmt(addr)&fmt(data(7 downto 0)));
						  else
				             sprintf(str,"APBWRT ACM %d:%02x (No Write)",fmt(slot)&fmt(addr));
						  end if;
	            when 3 => sprintf(str,"APBREAD %d:%02x = %02x"   ,fmt(slot)&fmt(addr)&fmt(data));
	            when 4 => sprintf(str,"APBWRTZ ACC %d:Z(%02x) = %02x",fmt(slot)&fmt(ZREGISTER)&fmt(data));
	            when 5 => sprintf(str,"APBWRTZ DAT %d:Z(%02x) = %02x",fmt(slot)&fmt(ZREGISTER)&fmt(data));
	            when 6 => if ACMDO='1' then
				             sprintf(str,"APBWRTZ ACM %d:Z(%02x) = %02x",fmt(slot)&fmt(ZREGISTER)&fmt(data(7 downto 0)));
						  else
				             sprintf(str,"APBWRTZ ACM %d:Z(%02x) (No Write)",fmt(slot)&fmt(ZREGISTER));
						  end if;
	            when 7 => sprintf(str,"APBREADZ %d:Z(%02x) = %02x"   ,fmt(slot)&fmt(ZREGISTER)&fmt(data));
				when others => sprintf(str,"UNEXPECTED INSTRUCTION");
			   end case;
	when 3 =>  case scmd is
	            when 0 => if muxc/='1' then
				            sprintf(str,"LOADZ DAT %02x",fmt(data));
						  else
				            sprintf(str,"LOADZ ACC %02x",fmt(accold));
						  end if;
	            when 1 => if muxc='0' then
				             if data=ONE then
							   sprintf(str,"INCZ <= %02x +1 ",fmt(ZREGISTER));
				             elsif data=MINUSONE then
							   sprintf(str,"DECZ <= %02x -1",fmt(ZREGISTER));
				             elsif data(data'left)='0' then
							   sprintf(str,"ADDZ <= %02x + %02x",fmt(ZREGISTER)&fmt(data));
				             else
							   sprintf(str,"SUBZ <= %02x - %02x",fmt(ZREGISTER)&fmt(ndata));
							 end if;
				          else
						     sprintf(str,"ADDZ <= %02x + ACC(%02x)",fmt(ZREGISTER)&fmt(accold));
						  end if;
	            when 6 => sprintf(str,"IOREAD %02x ",fmt(accnew));
	            when 7 => if muxc/='1' then
				            sprintf(str,"IOWRT DAT %02x ",fmt(data));
				          else
						    sprintf(str,"IOWRT ACC %02x ",fmt(accold));
						  end if;
	            when 3 => sprintf(str,"RAMREAD %02x = %02x",fmt(addr)&fmt(accnew));
	            when 2 => if muxc/='1' then
                             sprintf(str,"RAMWRITE DAT %02x = %02x",fmt(addr)&fmt(data));
						  else
                             sprintf(str,"RAMWRITE ACC %02x = %02x",fmt(addr)&fmt(data));
						  end if;
	            when 4 => if muxc/='1' then
				             sprintf(str,"PUSH DAT %02x (SP=%02x)",fmt(data)&fmt(STKPTR));
				          else
						     sprintf(str,"PUSH ACC %02x (SP=%02x)",fmt(accold)&fmt(STKPTR));
						  end if;
	            when 5 => sprintf(str,"POP  %02x (SP=%02x)",fmt(accnew)&fmt(STKPTR));
				when others => sprintf(str,"UNEXPECTED INSTRUCTION");
			   end case;
	when 4 =>  if scmdi(1)='0' then
	              sprintf(str,"JUMP %s %d %s",fmt(tostr_condition(data,scmdi,iiwidth))&fmt(addr)&fmt(tostr_taken(flags,data)));
	           else
			      sprintf(str,"WAIT %s %s",fmt(tostr_condition(data,scmdi,iiwidth))&fmt(tostr_taken(flags,data)));
			   end if;
	when 5 =>  sprintf(str,"CALL %s %d %s (SP=%02x)",fmt(tostr_condition(data,scmdi,iiwidth))&fmt(addr)&fmt(tostr_taken(flags,data))&fmt(STKPTR));
	when 6 =>  if scmdi(1)='0' then
	             sprintf(str,"RETURN %s  %s (SP=%02x)",fmt(tostr_condition(data,scmdi,iiwidth))&fmt(tostr_taken(flags,data))&fmt(STKPTR));
	           else
			     sprintf(str,"RETISR %s  %s (SP=%02x)",fmt(tostr_condition(data,scmdi,iiwidth))&fmt(tostr_taken(flags,data))&fmt(STKPTR));
			   end if;
	when 7 =>  sprintf(str,"NOP");
	when others =>	sprintf(str,"NOT DONE");
  end case;
  return(str);
end disassemble;


function disphase( cmdi,scmdi,sloti : std_logic_vector ) return integer is
variable cmd,scmd : integer range 0 to 7;
variable phase : integer;
begin
  cmd := 0; scmd:=0;
  for i in 0 to 2 loop
    if cmdi(i)='1'  then cmd := cmd + 2**i;	end if;
    if scmdi(i)='1' then scmd:= scmd + 2**i; end if;
  end loop;
  phase := 1;
  case CMD is
    when 0 => if sloti(0)='1' then phase := 3; end if;
    when 1 => if sloti(0)='1' then phase := 3; end if;
    when 2 => if scmd=2 or scmd=6 then phase:=4; 	-- acm write
	            elsif scmd=3 or scmd=7 then phase:=2;  -- apb read
			  end if;
	when 3 => if scmd=3 or scmd=5 then phase:=3;  end if;  -- memory reads
	when others =>
  end case;
  return(phase);
end disphase;


function maskdata(DATA : std_logic_vector ) return std_logic_vector is
variable XDATA : std_logic_vector( data'range);
begin
  XDATA := ( others => '0');
  for i in XDATA'range loop
    if DATA(i)='1' then
      XDATA(i):='1';
    end if;
  end loop;
  return(XDATA);
end maskdata;



signal  STKPTRM1 : std_logic_vector(7 downto 0);
signal  STKPTRP1 : std_logic_vector(7 downto 0);

signal DEBUG1X : std_logic;

-- synthesis translate_on

begin

-- Debug Code is non synthesizeable
-- This process basically creates an instruction trace in the log window

-- synthesis translate_off


STKPTRM1 <= clean(STKPTR) -1;    -- helps verilog translation
STKPTRP1 <= clean(STKPTR) +1;


process
begin
  wait for 1 ns;
  printf("# INFO CoreABC VHDL Disassembler");
  wait;
end process;



process(PCLK)
variable  ACCNEW : std_logic_vector(DWIDTH-1 downto 0);
variable  ACCOLD : std_logic_vector(DWIDTH-1 downto 0);
variable  ISROLD : std_logic := '0';
variable  ISRNEW : std_logic := '0';
variable  ADDR   : std_logic_vector(AWIDTH-1 downto 0);
variable  DATA   : std_logic_vector(DWIDTH-1 downto 0);
variable  islot0 : std_logic;
variable  phase  : integer;
begin
  if PCLK'event and PCLK='1' and DEBUG=1 and RESETN='1' then
    DEBUG1X <= DEBUG1;
    ACCNEW  := ACCUM_NEW;
    ACCOLD  := ACCUM_OLD;
    ISROLD  := ISRNEW;
    ISRNEW  := ISR;
	islot0  := instr_slot(0);
    if instr_cmd(2 downto 1)="00" and islot0='1' then
	  DATA := maskdata(RAMDOUT);
	else
	  DATA := maskdata(INSTR_DATA);
    end if;
	ADDR    := maskdata(INSTR_ADDR);
	if ISRNEW='1' and ISROLD='0' then
	  printf("Entering ISR: (SP=%02x)",fmt(STKPTR));
	end if;
	if ISRNEW='0' and ISROLD='1' then
	  printf("Exiting ISR: (SP=%02x)",fmt(STKPTR));
	end if;
	phase :=  disphase(INSTR_CMD,INSTR_SCMD,INSTR_SLOT);
	--printf("INS:%d: Phase:%d",fmt(SMADDR)&fmt(phase));
    if DEBUG1='1' then
      if phase=1 then
        printf("INS:%d: %s",fmt(SMADDR)&fmt(disassemble(ACCNEW,ACCOLD,INSTR_CMD,INSTR_SCMD,INSTR_SLOT,ADDR,DATA,STKPTR,ZREGISTER,IIWIDTH,ACMDO,FLAGS)));
      end if;
    end if;
    if DEBUG1X='1'  then  -- Memory Reads
      if phase=3 then
        printf("INS:%d: %s",fmt(SMADDR)&fmt(disassemble(ACCNEW,ACCOLD,INSTR_CMD,INSTR_SCMD,INSTR_SLOT,ADDR,DATA,STKPTR,ZREGISTER,IIWIDTH,ACMDO,FLAGS)));
      end if;
      if phase=4 then -- ACM Write
        printf("INS:%d: %s",fmt(SMADDR)&fmt(disassemble(ACCNEW,ACCOLD,INSTR_CMD,INSTR_SCMD,INSTR_SLOT,ADDR,PWDATA,STKPTR,ZREGISTER,IIWIDTH,ACMDO,FLAGS)));
      end if;
    end if;
    if DEBUG2='1' then	-- APB READ
      if phase=2 then
        printf("INS:%d: %s",fmt(SMADDR)&fmt(disassemble(ACCNEW,ACCOLD,INSTR_CMD,INSTR_SCMD,INSTR_SLOT,ADDR,PRDATA,STKPTR,ZREGISTER,IIWIDTH,ACMDO,FLAGS)));
      end if;
    end if;
  end if;
end process;

-- synthesis translate_on


end RTL;
