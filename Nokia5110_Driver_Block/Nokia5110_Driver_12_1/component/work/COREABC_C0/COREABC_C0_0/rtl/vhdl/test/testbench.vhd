-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  testbench.vhd
--
-- Description: Simple APB Bus Controller
--              Testbench
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 22329 $
-- SVN $Date: 2014-04-10 15:08:25 +0100 (Thu, 10 Apr 2014) $
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
use COREABC_LIB.COREABC_C0_COREABC_C0_0_misc.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_textio.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_testsupport.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_components.all;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_coreparameters_tgi.all;

entity TESTBENCH is
 generic ( SET_FAMILY   : integer range -1 to 99 := -1;  -- force family setting
           SET_DEBUG    : integer range -1 to 1  := -1;  -- force debug off/on
           SET_TM       : integer range -1 to 99 := -1;  -- force test instruction set
           SET_PROG     : integer range  0 to 5  :=  0   -- Core Program Mode
         );
end TESTBENCH;

--SET_PROG
-- 0: core operates as set up
-- 1: core forced to HARD mode
-- 2: core forced to HARD mode and RAM Image generated
-- 3: core forced to SOFT mode, initialisation by RAM models loading
-- 4: core forced to SOFT mode, initialisation from INITCFG interface
-- 5: core forced to NVM  mode


architecture TEST of TESTBENCH is

constant FAMILYX        : integer range 0 to 99 := override(SET_FAMILY,FAMILY);
constant DEBUGX         : integer range 0 to 1  := override(SET_DEBUG,DEBUG);
constant TESTMODEX      : integer range 0 to 99 := override(SET_TM,11);          -- By default testbench runs tests 11
--constant INSMODEX       : integer range 0 to 2  := overrideP(SET_PROG,INSMODE);
constant INSMODEX       : integer range 0 to 2  := 0;
--constant ENABLE_HEXFILE : boolean := ( SET_PROG=2);
--constant ENABLE_INIT    : boolean := ( SET_PROG=4);


-- When TESTMODE=0 the core parameters are extracted from coreparameters_tgi.vhd
--              >0 then the core parameters are taken from the testsupport package using TESTMODE
--                 to select the settings

constant  APBsetupX        : TABCCONFIG  := APBsetup(TESTMODEX,FAMILYX,INSMODEX);
constant  PARA_FAMILY      : integer  := set_generic(TESTMODEX,FAMILYX      ,APBsetupX.FAMILY);
constant  PARA_APB_AWIDTH  : integer  := set_generic(TESTMODEX,APB_AWIDTH   ,APBsetupX.APB_AWIDTH);
constant  PARA_APB_DWIDTH  : integer  := set_generic(TESTMODEX,APB_DWIDTH   ,APBsetupX.APB_DWIDTH);
constant  PARA_APB_SDEPTH  : integer  := set_generic(TESTMODEX,APB_SDEPTH   ,APBsetupX.APB_SDEPTH);
constant  PARA_ICWIDTH     : integer  := set_generic(TESTMODEX,ICWIDTH      ,APBsetupX.ICWIDTH);
constant  PARA_ZRWIDTH     : integer  := set_generic(TESTMODEX,ZRWIDTH      ,APBsetupX.ZRWIDTH);
constant  PARA_IIWIDTH     : integer  := set_generic(TESTMODEX,IIWIDTH      ,APBsetupX.IIWIDTH);
constant  PARA_IFWIDTH     : integer  := set_generic(TESTMODEX,IFWIDTH      ,APBsetupX.IFWIDTH);
constant  PARA_IOWIDTH     : integer  := set_generic(TESTMODEX,IOWIDTH      ,APBsetupX.IOWIDTH);
constant  PARA_STWIDTH     : integer  := set_generic(TESTMODEX,STWIDTH      ,APBsetupX.STWIDTH);
constant  PARA_EN_INC      : integer  := set_generic(TESTMODEX,EN_INC       ,APBsetupX.EN_INC);
constant  PARA_EN_ADD      : integer  := set_generic(TESTMODEX,EN_ADD       ,APBsetupX.EN_ADD);
constant  PARA_EN_AND      : integer  := set_generic(TESTMODEX,EN_AND       ,APBsetupX.EN_AND);
constant  PARA_EN_OR       : integer  := set_generic(TESTMODEX,EN_OR        ,APBsetupX.EN_OR);
constant  PARA_EN_XOR      : integer  := set_generic(TESTMODEX,EN_XOR       ,APBsetupX.EN_XOR);
constant  PARA_EN_SHL      : integer  := set_generic(TESTMODEX,EN_SHL       ,APBsetupX.EN_SHL);
constant  PARA_EN_SHR      : integer  := set_generic(TESTMODEX,EN_SHR       ,APBsetupX.EN_SHR);
constant  PARA_EN_CALL     : integer  := set_generic(TESTMODEX,EN_CALL      ,APBsetupX.EN_CALL);
constant  PARA_EN_RAM      : integer  := set_generic(TESTMODEX,EN_RAM       ,APBsetupX.EN_RAM);
constant  PARA_EN_ACM      : integer  := set_generic(TESTMODEX,EN_ACM       ,APBsetupX.EN_ACM);
constant  PARA_EN_MULT     : integer  := set_generic(TESTMODEX,EN_MULT      ,APBsetupX.EN_MULT);
constant  PARA_EN_PUSH     : integer  := set_generic(TESTMODEX,EN_PUSH      ,APBsetupX.EN_PUSH);
constant  PARA_EN_DATAM    : integer  := set_generic(TESTMODEX,EN_DATAM     ,APBsetupX.EN_DATAM);
constant  PARA_INITWIDTH   : integer  := set_generic(TESTMODEX,INITWIDTH    ,APBsetupX.INITWIDTH);
constant  PARA_EN_INT      : integer  := set_generic(TESTMODEX,EN_INT       ,APBsetupX.EN_INT);
constant  PARA_EN_IOREAD   : integer  := set_generic(TESTMODEX,EN_IOREAD    ,APBsetupX.EN_IOREAD  );
constant  PARA_EN_IOWRT    : integer  := set_generic(TESTMODEX,EN_IOWRT     ,APBsetupX.EN_IOWRT );
constant  PARA_EN_ALURAM   : integer  := set_generic(TESTMODEX,EN_ALURAM    ,APBsetupX.EN_ALURAM);
constant  PARA_ISRADDR     : integer  := set_generic(TESTMODEX,ISRADDR      ,APBsetupX.ISRADDR);
constant  PARA_TESTMODE    : integer  := set_generic(TESTMODEX,TESTMODEX    ,APBsetupX.TESTMODE);
constant  PARA_DEBUG       : integer  := DEBUGX;
constant  PARA_INSMODE     : integer  := set_generic(TESTMODEX,INSMODEX     ,APBsetupX.INSMODE);
constant  PARA_EN_INDIRECT : integer  := set_generic(TESTMODEX,EN_INDIRECT  ,APBsetupX.EN_INDIRECT);

type PDATA_ARRAY is array ( INTEGER range <>) of std_logic_vector(PARA_APB_DWIDTH-1 downto 0);
signal PRDATA       : PDATA_ARRAY(0 to 15);

signal  STATUSSTR   :  STRING(1 to 4);
signal  FINISHED    :  BOOLEAN := FALSE;
signal  STOPCLK     :  BOOLEAN := FALSE;
signal  CYCLES      :  INTEGER;
signal  PCLK        :  std_logic;
signal  PRESETN     :  std_logic;
signal  PENABLE     :  std_logic;
signal  PWRITE      :  std_logic;
signal  PSEL        :  std_logic;
signal  PSEL16      :  std_logic_vector( 15 downto 0);
signal  PADDR       :  std_logic_vector( 19 downto 0);
signal  PWDATA      :  std_logic_vector( PARA_APB_DWIDTH-1 downto 0);
signal  PRDATAMUX   :  std_logic_vector( PARA_APB_DWIDTH-1 downto 0);
signal  PREADY      :  std_logic;
signal  IO_IN       :  std_logic_vector( PARA_IIWIDTH-1 downto 0);
signal  IO_OUT      :  std_logic_vector( PARA_IOWIDTH-1 downto 0);

signal  INITDATVAL  :  std_logic := '0';
signal  INITDONE    :  std_logic := '1';
signal  INITADDR    :  std_logic_vector(PARA_INITWIDTH-1 downto 0) := (others => '0');
signal  INITDATA    :  std_logic_vector(8 downto 0) := (others => '0');

signal  INTREQ      :  std_logic;
signal  INTACT      :  std_logic;

signal  IOSWITCH    :  std_logic;
signal  IOWAITIN    :  std_logic;

signal  PADDR_UPPER : std_logic_vector(3 downto 0);

constant ZERO : std_logic_vector(31 downto 0) := ( others => '0');
constant ONES : std_logic_vector(31 downto 0) := ( others => '1');

begin

--------------------------------------------------------------------------------
--  Hex File Generation

--UHEX:  COREABC_C0_COREABC_C0_0_MAKEHEX
--  generic map ( ENABLE   =>  ENABLE_HEXFILE,
--                FAMILY   =>  PARA_FAMILY,
--                AWIDTH   =>  PARA_APB_AWIDTH,
--                DWIDTH   =>  PARA_APB_DWIDTH,
--                SDEPTH   =>  PARA_APB_SDEPTH,
--                ICWIDTH  =>  PARA_ICWIDTH,
--                IIWIDTH  =>  PARA_IIWIDTH,
--                IFWIDTH  =>  PARA_IFWIDTH,
--                TESTMODE =>  PARA_TESTMODE
--           );

------------------------------------------------------------------------------
-- Model the INITCFG Block loading the RAM
--

--UCFG:  COREABC_C0_COREABC_C0_0_INITGEN
--  generic map( ENABLE    => ENABLE_INIT,
--               AWIDTH    => PARA_APB_AWIDTH,
--               DWIDTH    => PARA_APB_DWIDTH,
--               SDEPTH    => PARA_APB_SDEPTH,
--               ICWIDTH   => PARA_ICWIDTH,
--               INITWIDTH => PARA_INITWIDTH
--              )
--  port map ( PCLK       => PCLK,
--             PRESETN    => PRESETN,
--             INITDATVAL => INITDATVAL,
--             INITDONE   => INITDONE,
--             INITADDR   => INITADDR,
--             INITDATA   => INITDATA
--            );

--------------------------------------------------------------------------------
-- Clock Generation

process
 begin
    PCLK <= '0';
    wait for 31250 ps;
    PCLK <= '1';
    wait for 31250 ps;
    if STOPCLK then
      wait;
    end if;
end process;

--------------------------------------------------------------------------------
-- The ABC Core

UUT : COREABC_C0_COREABC_C0_0_COREABC
  generic map ( FAMILY      => PARA_FAMILY,
                APB_AWIDTH  => PARA_APB_AWIDTH,
                APB_DWIDTH  => PARA_APB_DWIDTH,
                APB_SDEPTH  => PARA_APB_SDEPTH,
                ICWIDTH     => PARA_ICWIDTH,
                ZRWIDTH     => PARA_ZRWIDTH,
                IIWIDTH     => PARA_IIWIDTH,
                IFWIDTH     => PARA_IFWIDTH,
                IOWIDTH     => PARA_IOWIDTH,
                STWIDTH     => PARA_STWIDTH,
                ISRADDR     => PARA_ISRADDR,
                EN_INT      => PARA_EN_INT,
                EN_RAM      => PARA_EN_RAM,
                EN_INC      => PARA_EN_INC,
                EN_ADD      => PARA_EN_ADD,
                EN_AND      => PARA_EN_AND,
                EN_OR       => PARA_EN_OR,
                EN_XOR      => PARA_EN_XOR,
                EN_SHL      => PARA_EN_SHL,
                EN_SHR      => PARA_EN_SHR,
                EN_CALL     => PARA_EN_CALL,
                EN_PUSH     => PARA_EN_PUSH,
                EN_MULT     => PARA_EN_MULT,
                EN_ACM      => PARA_EN_ACM,
                EN_DATAM    => PARA_EN_DATAM,
                EN_IOREAD   => PARA_EN_IOREAD,
                EN_IOWRT    => PARA_EN_IOWRT,
                EN_ALURAM   => PARA_EN_ALURAM,
				EN_INDIRECT => PARA_EN_INDIRECT,
                DEBUG       => PARA_DEBUG,
                INSMODE     => PARA_INSMODE,
                INITWIDTH   => PARA_INITWIDTH,
                TESTMODE    => PARA_TESTMODE,
                ACT_CALIBRATIONDATA => 1,
                IMEM_APB_ACCESS     => 2,
                UNIQ_STRING_LENGTH  => UNIQ_STRING_LENGTH
               )
  port map ( NSYSRESET   => PRESETN,
             PCLK        => PCLK,
             PRESETN     => open,
             PENABLE_M   => PENABLE,
             PWRITE_M    => PWRITE,
             PSEL_M      => PSEL,
             PADDR_M     => PADDR,
             PWDATA_M    => PWDATA,
             PRDATA_M    => PRDATAMUX,
             PREADY_M    => '1',
             PSLVERR_M   => '0',
             IO_IN       => IO_IN,
             IO_OUT      => IO_OUT,
             INTREQ      => INTREQ,
             INTACT      => INTACT,
             INITDATVAL  => INITDATVAL,
             INITDONE    => INITDONE,
             INITADDR    => INITADDR,
             INITDATA    => INITDATA,
             PSEL_S      => '0',
             PENABLE_S   => '0',
             PWRITE_S    => '0',
             PADDR_S     => ZERO(PARA_APB_AWIDTH-1 downto 0),
             PWDATA_S    => ZERO(PARA_APB_DWIDTH-1 downto 0),
             PRDATA_S    => open,
             PSLVERR_S   => open,
             PREADY_S    => open
           );


------------------------------------------------------------------------------
-- APB Bus Mux
--

PADDR_UPPER <= PADDR(PARA_APB_AWIDTH+3 downto PARA_APB_AWIDTH);

process(PSEL,PADDR,PRDATA)
variable msel : std_logic_vector(3 downto 0);
variable mint : integer range 0 to 15;
begin
  PSEL16(15 downto 0) <= X"0000";
  if (PSEL = '1') then
    case PADDR_UPPER is
      when "0000" => PSEL16( 0) <= '1';
      when "0001" => PSEL16( 1) <= '1';
      when "0010" => PSEL16( 2) <= '1';
      when "0011" => PSEL16( 3) <= '1';
      when "0100" => PSEL16( 4) <= '1';
      when "0101" => PSEL16( 5) <= '1';
      when "0110" => PSEL16( 6) <= '1';
      when "0111" => PSEL16( 7) <= '1';
      when "1000" => PSEL16( 8) <= '1';
      when "1001" => PSEL16( 9) <= '1';
      when "1010" => PSEL16(10) <= '1';
      when "1011" => PSEL16(11) <= '1';
      when "1100" => PSEL16(12) <= '1';
      when "1101" => PSEL16(13) <= '1';
      when "1110" => PSEL16(14) <= '1';
      when "1111" => PSEL16(15) <= '1';
      when others => null;
    end case;
  end if;
  msel(0) := PSEL16(1) or PSEL16(3) or PSEL16(5)  or PSEL16(7)  or PSEL16(9)  or PSEL16(11) or PSEL16(13) or PSEL16(15);
  msel(1) := PSEL16(2) or PSEL16(3) or PSEL16(6)  or PSEL16(7)  or PSEL16(10) or PSEL16(11) or PSEL16(14) or PSEL16(15);
  msel(2) := PSEL16(4) or PSEL16(5) or PSEL16(6)  or PSEL16(7)  or PSEL16(12) or PSEL16(13) or PSEL16(14) or PSEL16(15);
  msel(3) := PSEL16(8) or PSEL16(9) or PSEL16(10) or PSEL16(11) or PSEL16(12) or PSEL16(13) or PSEL16(14) or PSEL16(15);
  mint := conv_integer(clean(msel));
  PRDATAMUX <= PRDATA(mint);
end process;


--------------------------------------------------------------------------------
-- The APB Models, one per active slot

UM: for i in 0 to PARA_APB_SDEPTH-1 generate
  UMOD:  COREABC_C0_COREABC_C0_0_APBModel
    generic map ( ID      => i,
	              DEBUG   => PARA_DEBUG,
                  AWIDTH  => PARA_APB_AWIDTH,
                  DWIDTH  => PARA_APB_DWIDTH
                 )
    port map ( PCLK       => PCLK,
               PRESETN    => PRESETN,
               PENABLE    => PENABLE,
               PWRITE     => PWRITE,
               PSEL       => PSEL16(i),
               PADDR      => PADDR(PARA_APB_AWIDTH-1 downto 0),
               PWDATA     => PWDATA,
               PRDATA     => PRDATA(i),
               PREADY     => PREADY
             );
end generate;


--------------------------------------------------------------------------------
-- Monitor IO_OUT for test conditions


process(IO_OUT,IOSWITCH,IOWAITIN,INTACT)
begin
  if IOSWITCH='0' then
    IO_IN <= IO_OUT(PARA_IIWIDTH-1 downto 0);
  else
    IO_IN(0) <= INTACT;
	IO_IN(1) <= IOWAITIN;
  end if;
end process;


process(PCLK,PRESETN)
variable status : integer;
variable icount : integer;
variable wcount : integer;
begin
  if PRESETN='0' then
     FINISHED <= FALSE;
     INTREQ   <= '0';
     ICOUNT   :=0;
	 WCOUNT   := 0;
     IOWAITIN <= '0';
	 IOSWITCH <= '0';
	 STATUSSTR   <= "FAIL";
  elsif PCLK'event and PCLK='1' then
    status := conv_integer(IO_OUT(7 downto 0));
    if INITDONE='1' then
      icount := icount +1;
    end if;
    case status is
	  when 249 =>  -- Switch IO_IO to monitor outputs, and assert WAITTST for 10 clocks
	               IOSWITCH <= '1';
                   if IOSWITCH='0' then
				     WCOUNT := 40;
				     printf("Info: IO_IN now monitoring test signals");
				   end if;
	  when 250 =>  -- Switch IO to normal mode
	               IOSWITCH <= '0';
                   if IOSWITCH='1' then
                     printf("Info: IO_IN now monitoring IO_OUT");
				   end if;
      when 251 =>  if INTREQ='0' then
                     printf("Info: ABC Asserting Interrupt Request");
                     INTREQ <= '1';
                   end if;
      when 252 =>  INTREQ <= '0';
      when 253 =>  if not FINISHED then
                     printf("Info: ABC Indicated that it has completed");
					 STATUSSTR <= "OKAY";
                     FINISHED <= TRUE;
                   end if;
      when 254 =>  printf("################################################################");
                   printf("Error: ABC Indicated that it had an error condition");
                    assert FALSE
                       report "APB Error Detected"
                       severity ERROR;
      when others =>
    end case;
	if WCOUNT>0 then
	  IOWAITIN <= '1';
	  WCOUNT := WCOUNT -1;
	else
	  IOWAITIN <= '0';
	end if;
	CYCLES <= icount;
    if icount= 4000 then
      printf("################################################################");
      printf("################################################################");
      assert FALSE
         report "Error: Simulation RUN To Long"
         severity ERROR;
    end if;
  end if;
end process;



--------------------------------------------------------------------------------
-- The Test Sequence


process
variable ERRORS : integer;
begin
  STOPCLK <= FALSE;
  PRESETN <= '0';
  ERRORS  := 0;
  wait for 1 ns;

  printf("################################################################");
  printf("CoreABC VHDL Testbench  v3.0  December 2009");
  printf("(c) Actel IP Engineering");
  printf(" ");

  if (PARA_TESTMODE=0 ) then
    printf(" ");
    printf("Testbench is being run with TESTMODE set to 0 enabling the User Instructions");
    printf("Operation of the testbench will be unpredictable");
    printf("Note. A memory image file may be created by typing do makehex.do at the ModelSim Prompt");
    printf(" ");
    assert FALSE
       report "Restart if required using run -all"
       severity WARNING;
  end if;
  if (INSMODE=2 and FAMILY/=17 ) then
    printf(" ");
    assert FALSE
	   report "Attempting to run in NVM mode in non Fusion Family - Reverting to hard mode"
	   severity WARNING;
  end if;

  printf("Configuration (TM:%d) ",fmt(PARA_TESTMODE));
  case PARA_TESTMODE is
   when 0  => printf("   Configuration as set by CoreConsole");
   when 1  => printf("   Small 8 bit");
   when 2  => printf("   Small 16 bit");
   when 3  => printf("   Small 32 bit");
   when 4  => printf("   Complete 8 bit");
   when 5  => printf("   Complete 16 bit");
   when 6  => printf("   Complete 32 bit");
   when 11 => printf("   Fully Configured 8 Bit Configuration");
   when 12 => printf("   Fully Configured 16 Bit Configuration");
   when 13 => printf("   Fully Configured 32 Bit Configuration");
   when 14 => printf("   Small 8 Bit Configuration with call");
   when 15 => printf("   Small 8 Bit Configuration no call and 1 slot");
   when 16 => printf("   Example for controlling CoreAI");
   when 20 to 31 => printf("   Corner case builds");
   when others => printf("Not a configured core ");
                  assert FALSE report "Unexpected testmode" severity FAILURE;
  end case;
  printf("   Family : %d"           ,fmt(PARA_FAMILY));
  printf("   APB Address Width: %d" ,fmt(PARA_APB_AWIDTH));
  printf("   APB Data Width: %d "   ,fmt(PARA_APB_DWIDTH));
  printf("   APB Slots: %d "        ,fmt(PARA_APB_SDEPTH));
  printf("   IO In Width: %d "      ,fmt(PARA_IIWIDTH));
  printf("   IO Flag Width: %d "    ,fmt(PARA_IFWIDTH));
  printf("   IO Out Width: %d "     ,fmt(PARA_IOWIDTH));
  printf("   Instructions: %d "     ,fmt(2**PARA_ICWIDTH));
  if PARA_INSMODE=0 then
    printf("   Instruction held in Tiles ");
  elsif PARA_INSMODE=1 then
    printf("   Instruction held in RAM ");
  elsif PARA_INSMODE=2 then
    printf("   Instruction held in NVM ");
  end if;
  printf("   Stack Depth: %d "      ,fmt(2**PARA_STWIDTH));
  printf("   Loop Counter Size %d"  ,fmt(2**PARA_ZRWIDTH));
  printf("   OR instruction %s"     ,fmt(tostr(PARA_EN_OR)));
  printf("   AND instruction %s"    ,fmt(tostr(PARA_EN_AND)));
  printf("   XOR instruction %s"    ,fmt(tostr(PARA_EN_XOR)));
  printf("   ADD instruction %s"    ,fmt(tostr(PARA_EN_ADD)));
  printf("   INC instruction %s"    ,fmt(tostr(PARA_EN_INC)));
  printf("   SHL instruction %s"    ,fmt(tostr(PARA_EN_SHL)));
  printf("   SHR instruction %s"    ,fmt(tostr(PARA_EN_SHR)));
  printf("   CALL instruction %s"   ,fmt(tostr(PARA_EN_CALL)));
  printf("   MULT instruction %s"   ,fmt(tostr(PARA_EN_MULT)));
  printf("   PUSH instruction %s"   ,fmt(tostr(PARA_EN_PUSH)));
  printf("   IOREAD instruction %s" ,fmt(tostr(PARA_EN_IOREAD)));
  printf("   IOWRT  instruction %s" ,fmt(tostr(PARA_EN_IOWRT)));
  printf("   Accumulator RAM operations %s",fmt(tostr(PARA_EN_ALURAM)));
  printf("   Indirect APB operations %s",fmt(tostr(PARA_EN_INDIRECT)));
  printf("   ACM lookup %s"                ,fmt(tostr(PARA_EN_ACM)));
  printf("   Multiplexer Mode %d"          ,fmt(PARA_EN_DATAM));
  printf("   Storage Registers %s "        ,fmt(tostr(PARA_EN_RAM)));
  if PARA_EN_INT=1 then
    printf("   Interrupt Enabled ISR at %04x" ,fmt(PARA_ISRADDR));
  else
    printf("   Interrupt Disabled");
  end if;
  printf(" ");
  case SET_DEBUG is
    when 0 => printf("  DEBUG forced off by the testbench");
    when 1 => printf("  DEBUG forced on by the testbench");
    when others =>
  end case;
  if  SET_TM>=0 then
    printf("  TESTMODE set to %d by the testbench",fmt(SET_TM));
  end if;
  printf(" ");


  checksetup(APBsetupX);


  wait for 400 ns;
--  if ENABLE_HEXFILE then
--    wait for (10 * 2**PARA_ICWIDTH) * 1 ns;
--  end if;
  wait until PCLK='0';
  printf("Releasing Reset and letting core operate");
  printf(" ");

  PRESETN <= '1';
  wait until FINISHED;
  STOPCLK <= TRUE;

  printf(" ");
  printf("################################################################");
  printf("Tests Complete TM=%d SP=%d CY=%d %s",fmt(PARA_TESTMODE)&fmt(SET_PROG)&fmt(CYCLES)&fmt(statusstr));
  printf("");
  printf("################################################################");
  wait;
end process;


end test;
