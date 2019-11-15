-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  support.vhd
--
-- Description: Simple APB Bus Controller
--              Support routines mainly used for instruction encoding
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




package COREABC_C0_COREABC_C0_0_support is


---------------------------------------------------------------------
-- function Declarations

function clean( x : std_logic_vector ) return std_logic_vector;


function encode (vcmd, vscmd, vslot, vaddr, vdata : std_logic_vector ) return std_logic_vector;


function to_logic( tmp : integer ) return std_logic;
function to_logic( tmp : boolean ) return std_logic;

function log2r( x : integer ) return integer;
function calc_irwidth( en_ram,en_call,dwidth,icwidth : integer ) return integer;
function calc_swidth( x : integer ) return integer;
function calc_initwidth (AWIDTH,DWIDTH,SDEPTH,ICWIDTH : integer) return integer;

function max1( a, b : integer ) return integer;
function min1( a, b : integer ) return integer;

function doinsN ( N  : integer;
                  s1 : integer;
                  s2 : integer;
                  s3 : integer;
                  s4 : integer;
                  s5 : integer
              ) return std_logic_vector;

function doins  ( s1 : integer
              ) return std_logic_vector;

function doins  ( s1 : integer;
                  s2 : integer
              ) return std_logic_vector;

function doins  ( s1 : integer;
                  s2 : integer;
                  s3 : integer
              ) return std_logic_vector;

function doins  ( s1 : integer;
                  s2 : integer;
                  s3 : integer;
                  s4 : integer
              ) return std_logic_vector;

function doins  ( s1 : integer;
                  s2 : integer;
                  s3 : integer;
                  s4 : integer;
                  s5 : integer
              ) return std_logic_vector;

-- conversion routine, to help with CoreUART
function chartoint ( c : character ) return integer;

function conv_integer_to_flag_vector ( ionum : integer) return std_logic_vector;

--------------------------------------------------------------------------------------------------
-- Declare the components



component COREABC_C0_COREABC_C0_0_INSTRUCTRAM
  generic ( AWIDTH    : integer range 1 to 16;
            DWIDTH    : integer range 8 to 32;
            SWIDTH    : integer range 0 to 4;
            ICWIDTH   : integer range 1 to 16;
            ICDEPTH   : integer range 1 to 65536;
            IWWIDTH   : integer range 1 to 64;
            INITWIDTH : integer range 1 to 16;
            TESTMODE  : integer range 0 to 99;
            IMEM_APB_ACCESS : integer range 0 to 2;
            UNIQ_STRING_LENGTH : integer range 1 to 256
           );
  port(    CLK           : in  std_logic;
           RSTN          : in  std_logic;
           INITDATVAL    : in  std_logic;
           INITDONE      : in  std_logic;
           INITADDR      : in  std_logic_vector(INITWIDTH-1 downto 0);
           INITDATA      : in  std_logic_vector(8 downto 0);
           ADDRESS       : in  std_logic_vector(ICWIDTH-1 downto 0);
           INSTRUCTION   : out std_logic_vector(IWWIDTH-1 downto 0);
           PSEL          : in  std_logic;
           PENABLE       : in  std_logic;
           PWRITE        : in  std_logic;
           PADDR         : in  std_logic_vector(AWIDTH-1 downto 0);
           PWDATA        : in  std_logic_vector(DWIDTH-1 downto 0);
           PRDATA        : out std_logic_vector(DWIDTH-1 downto 0);
           PSLVERR       : out std_logic;
           PREADY        : out std_logic
          );
end component;

component COREABC_C0_COREABC_C0_0_INSTRUCTIONS
  generic ( AWIDTH   : integer range 1 to 16;
            DWIDTH   : integer range 8 to 32;
            SWIDTH   : integer range 0 to 4 ;
            ICWIDTH  : integer range 1 to 16;
            IIWIDTH  : integer range 1 to 32;
            IFWIDTH  : integer range 0 to 28;
            IWWIDTH  : integer range 1 to 64;
			EN_MULT  : integer range 0 to 3;
			EN_INC   : integer range 0 to 1;
            TESTMODE : integer range 0 to 99
           );
  port     ( ADDRESS     : in  std_logic_vector(ICWIDTH-1 downto 0);
             INSTRUCTION : out std_logic_vector(IWWIDTH-1 downto 0)
           );
end component;


component COREABC_C0_COREABC_C0_0_ACMTABLE
  generic  ( TESTMODE : integer range 0 to 99
            );
  port     ( ACMADDR : in  std_logic_vector(7 downto 0);
             ACMDATA : out std_logic_vector(7 downto 0);
             ACMDO   : out std_logic
           );
end component;


component COREABC_C0_COREABC_C0_0_RAMBLOCKS
     generic ( DWIDTH : integer range 8 to 32;
               FAMILY : integer range 0 to 99
             );
     port(CLK    : in  std_logic;
          RESETN : in  std_logic;
          WEN    : in  std_logic;
          ADDR   : in  std_logic_vector(7 downto 0);
          WD     : in  std_logic_vector(DWIDTH-1 downto 0);
          RD     : out std_logic_vector(DWIDTH-1 downto 0)
        ) ;
end component;

component COREABC_C0_COREABC_C0_0_RAM256X8 is
     port(RWCLK : in  std_logic;
          RESET : in  std_logic;
          WEN   : in  std_logic;
          REN   : in  std_logic;
          WADDR : in  std_logic_vector(7 downto 0);
          RADDR : in  std_logic_vector(7 downto 0);
          WD    : in  std_logic_vector(7 downto 0);
          RD    : out std_logic_vector(7 downto 0)
        ) ;
end component;

component COREABC_C0_COREABC_C0_0_RAM256X16 is
     port(RWCLK : in  std_logic;
          RESET : in  std_logic;
          WEN   : in  std_logic;
          REN   : in  std_logic;
          WADDR : in  std_logic_vector(7 downto 0);
          RADDR : in  std_logic_vector(7 downto 0);
          WD    : in  std_logic_vector(15 downto 0);
          RD    : out std_logic_vector(15 downto 0)
        ) ;
end component;

--component COREABC_C0_COREABC_C0_0_RAM512X32 is
--     port(RWCLK : in  std_logic;
--          RESET : in  std_logic;
--          WEN   : in  std_logic;
--          REN   : in  std_logic;
--          WADDR : in  std_logic_vector(8 downto 0);
--          RADDR : in  std_logic_vector(8 downto 0);
--          WD    : in  std_logic_vector(31 downto 0);
--          RD    : out std_logic_vector(31 downto 0)
--        ) ;
--end component;

--component RAM128X32 is
--     port(RWCLK : in  std_logic;
--          RESET : in  std_logic;
--          WEN   : in  std_logic;
--          REN   : in  std_logic;
--          WADDR : in  std_logic_vector(6 downto 0);
--          RADDR : in  std_logic_vector(6 downto 0);
--          WD    : in  std_logic_vector(31 downto 0);
--          RD    : out std_logic_vector(31 downto 0)
--        ) ;
--end component;

component COREABC_C0_COREABC_C0_0_RAM128X8 is
    port(
        WD      : in  std_logic_vector(7 downto 0);
        WADDR   : in  std_logic_vector(6 downto 0);
        RADDR   : in  std_logic_vector(6 downto 0);
        WEN     : in  std_logic;
        WCLK    : in  std_logic;
        RCLK    : in  std_logic;
        RESETN  : in  std_logic;
        RD      : out std_logic_vector(7 downto 0)
    );
end component;

component COREABC_C0_COREABC_C0_0_DEBUGBLK
 generic  ( DEBUG      : integer range 0 to 1;
            AWIDTH     : integer range 1 to 16;
            DWIDTH     : integer range 8 to 32;
            SWIDTH     : integer range 0 to 4;
            SDEPTH     : integer range 1 to 16;
            ICWIDTH    : integer range 1 to 16;
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
end component;


component COREABC_C0_COREABC_C0_0_IRAM512x9
    generic ( CID  : integer;   -- Indicates column of instruction word
              RID  : integer;   -- Indicates row of instruction word
              UNIQ_STRING_LENGTH : integer
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
end component;

component COREABC_C0_COREABC_C0_0_INSTRUCTNVM
  generic (
            MAX_NVMDWIDTH       : integer range 16 to 32;
            AWIDTH              : integer range 1 to 16;
            DWIDTH              : integer range 8 to 32;
            SWIDTH              : integer range 0 to 4;
            ICWIDTH             : integer range 1 to 16;
            ICDEPTH             : integer range 1 to 65536;
            IWWIDTH             : integer range 1 to 64;
            ACT_CALIBRATIONDATA : integer range 0 to 1;
            IMEM_APB_ACCESS     : integer range 0 to 2;
            UNIQ_STRING_LENGTH  : integer range 1 to 256
           );
  port(    CLK           : in  std_logic;
           RSTN          : in  std_logic;
		   START         : in  std_logic;
		   STALL         : out std_logic;
           ADDRESS       : in  std_logic_vector(ICWIDTH-1 downto 0);
           INSTRUCTION   : out std_logic_vector(IWWIDTH-1 downto 0);
           PSEL          : in  std_logic;
           PENABLE       : in  std_logic;
           PWRITE        : in  std_logic;
           PADDR         : in  std_logic_vector(AWIDTH-1 downto 0);
           PWDATA        : in  std_logic_vector(DWIDTH-1 downto 0);
           PRDATA        : out std_logic_vector(DWIDTH-1 downto 0);
           PSLVERR       : out std_logic;
           PREADY        : out std_logic
          );
end component;


constant  BLANK         : integer :=  -1;
constant  iNOP          : integer := 256* 1;
constant  iLOAD         : integer := 256* 2;
constant  iINCB         : integer := 256* 3;
constant  iAND          : integer := 256* 4;
constant  iOR           : integer := 256* 5;
constant  iXOR          : integer := 256* 6;
constant  iADD          : integer := 256* 7;
constant  iSUB          : integer := 256* 8;
constant  iSHL0         : integer := 256* 9;
constant  iSHL1         : integer := 256*10;
constant  iSHLE         : integer := 256*11;
constant  iROL          : integer := 256*12;
constant  iSHR0         : integer := 256*13;
constant  iSHR1         : integer := 256*14;
constant  iSHRE         : integer := 256*15;
constant  iROR          : integer := 256*16;
constant  iCMP          : integer := 256*17;
constant  iCMPLEQ       : integer := 256*18;
constant  iBITCLR       : integer := 256*19;
constant  iBITSET       : integer := 256*20;
constant  iBITTST       : integer := 256*21;
constant  iAPBREAD      : integer := 256*22;
constant  iAPBWRT       : integer := 256*23;
constant  iLOADZ        : integer := 256*24;
constant  iDECZ         : integer := 256*25;
constant  iINCZ         : integer := 256*26;
constant  iIOWRT        : integer := 256*27;
constant  iRAMREAD      : integer := 256*28;
constant  iRAMWRT       : integer := 256*29;
constant  iPUSH         : integer := 256*30;
constant  iPOP          : integer := 256*31;
constant  iIOREAD       : integer := 256*32;
constant  iUSER         : integer := 256*33;
constant  iJUMPB        : integer := 256*34;
constant  iCALLB        : integer := 256*35;
constant  iRETURNB      : integer := 256*36;
constant  iRETISRB      : integer := 256*37;
constant  iWAITB        : integer := 256*38;
constant  iHALTB        : integer := 256*38;  -- same as wait
constant  iMULT         : integer := 256*39;
constant  iDEC          : integer := 256*40;
constant  iAPBREADZ     : integer := 256*41;
constant  iAPBWRTZ      : integer := 256*42;
constant  iADDZ         : integer := 256*43;
constant  iSUBZ         : integer := 256*44;

constant  iDAT          : integer := 10;
constant  iDAT8         : integer := 11;
constant  iDAT16        : integer := 12;
constant  iDAT32        : integer := 13;
constant  iACM          : integer := 14;
constant  iACC          : integer := 15;
constant  iRAM          : integer := 16;

-- Some extra definitions
constant  DAT           : integer := 10;
constant  DAT8          : integer := 11;
constant  DAT16         : integer := 12;
constant  DAT32         : integer := 13;
constant  ACM           : integer := 14;
constant  ACC           : integer := 15;
constant  RAM           : integer := 16;

-- FLAG Constants
constant  iIFNOT    : integer := 0;
constant  iNOTIF    : integer := 0;
constant  iIF       : integer := 1;
constant  iUNTIL    : integer := 0;
constant  iNOTUNTIL : integer := 1;
constant  iUNTILNOT : integer := 1;
constant  iWHILE    : integer := 1;
constant  iZZERO    : integer := 16#08#;
constant  iNEGATIVE : integer := 16#04#;
constant  iZERO     : integer := 16#02#;
constant  iLTE_ZERO : integer := 16#06#;
constant  iALWAYS   : integer := 16#01#;
-- constant  iINPUT0   : integer := 16#010#;
-- constant  iINPUT1   : integer := 16#020#;
-- constant  iINPUT2   : integer := 16#040#;
-- constant  iINPUT3   : integer := 16#080#;
-- constant  iINPUT4   : integer := 16#100#;
-- constant  iINPUT5   : integer := 16#200#;
-- constant  iINPUT6   : integer := 16#400#;
-- constant  iINPUT7   : integer := 16#800#;
-- constant  iINPUT8   : integer := 16#1000#;
-- constant  iINPUT9   : integer := 16#2000#;
-- constant  iINPUT10  : integer := 16#4000#;
-- constant  iINPUT11  : integer := 16#8000#;
-- constant  iINPUT12  : integer := 16#10000#;
-- constant  iINPUT13  : integer := 16#20000#;
-- constant  iINPUT14  : integer := 16#40000#;
-- constant  iINPUT15  : integer := 16#80000#;
-- constant  iINPUT16  : integer := 16#100000#;
-- constant  iINPUT17  : integer := 16#200000#;
-- constant  iINPUT18  : integer := 16#400000#;
-- constant  iINPUT19  : integer := 16#800000#;
-- constant  iINPUT20  : integer := 16#1000000#;
-- constant  iINPUT21  : integer := 16#2000000#;
-- constant  iINPUT22  : integer := 16#4000000#;
-- constant  iINPUT23  : integer := 16#8000000#;
-- constant  iINPUT24  : integer := 16#10000000#;
-- constant  iINPUT25  : integer := 16#20000000#;
-- constant  iINPUT26  : integer := 16#40000000#;
-- constant  iINPUT27  : integer := 16#80000000#;
-- constant  iANYINPUT : integer := 16#7FFFFFF0#;
constant  iINPUT0   : integer := 100;
constant  iINPUT1   : integer := 101;
constant  iINPUT2   : integer := 102;
constant  iINPUT3   : integer := 103;
constant  iINPUT4   : integer := 104;
constant  iINPUT5   : integer := 105;
constant  iINPUT6   : integer := 106;
constant  iINPUT7   : integer := 107;
constant  iINPUT8   : integer := 108;
constant  iINPUT9   : integer := 109;
constant  iINPUT10  : integer := 110;
constant  iINPUT11  : integer := 111;
constant  iINPUT12  : integer := 112;
constant  iINPUT13  : integer := 113;
constant  iINPUT14  : integer := 114;
constant  iINPUT15  : integer := 115;
constant  iINPUT16  : integer := 116;
constant  iINPUT17  : integer := 117;
constant  iINPUT18  : integer := 118;
constant  iINPUT19  : integer := 119;
constant  iINPUT20  : integer := 120;
constant  iINPUT21  : integer := 121;
constant  iINPUT22  : integer := 122;
constant  iINPUT23  : integer := 123;
constant  iINPUT24  : integer := 124;
constant  iINPUT25  : integer := 125;
constant  iINPUT26  : integer := 126;
constant  iINPUT27  : integer := 127;
constant  iANYINPUT : integer := 200;

--Left as these are also allowed
constant  ALWAYS   : integer := 16#01#;
constant  ZZERO    : integer := 16#08#;
constant  NEGATIVE : integer := 16#04#;
constant  ZERO     : integer := 16#02#;
constant  LTE_ZERO : integer := 16#06#;
-- constant  INPUT0   : integer := 16#010#;
-- constant  INPUT1   : integer := 16#020#;
-- constant  INPUT2   : integer := 16#040#;
-- constant  INPUT3   : integer := 16#080#;
-- constant  INPUT4   : integer := 16#100#;
-- constant  INPUT5   : integer := 16#200#;
-- constant  INPUT6   : integer := 16#400#;
-- constant  INPUT7   : integer := 16#800#;
-- constant  INPUT8   : integer := 16#1000#;
-- constant  INPUT9   : integer := 16#2000#;
-- constant  INPUT10  : integer := 16#3000#;
-- constant  INPUT11  : integer := 16#8000#;
-- constant  INPUT12  : integer := 16#10000#;
-- constant  INPUT13  : integer := 16#20000#;
-- constant  INPUT14  : integer := 16#40000#;
-- constant  INPUT15  : integer := 16#80000#;
-- constant  INPUT16  : integer := 16#100000#;
-- constant  INPUT17  : integer := 16#200000#;
-- constant  INPUT18  : integer := 16#300000#;
-- constant  INPUT19  : integer := 16#800000#;
-- constant  INPUT20  : integer := 16#1000000#;
-- constant  INPUT21  : integer := 16#2000000#;
-- constant  INPUT22  : integer := 16#4000000#;
-- constant  INPUT23  : integer := 16#8000000#;
-- constant  INPUT24  : integer := 16#10000000#;
-- constant  INPUT25  : integer := 16#20000000#;
-- constant  INPUT26  : integer := 16#40000000#;
-- constant  INPUT27  : integer := 16#40000000#;
-- constant  ANYINPUT : integer := 16#7FFFFFF0#;
constant  INPUT0   : integer := 100;
constant  INPUT1   : integer := 101;
constant  INPUT2   : integer := 102;
constant  INPUT3   : integer := 103;
constant  INPUT4   : integer := 104;
constant  INPUT5   : integer := 105;
constant  INPUT6   : integer := 106;
constant  INPUT7   : integer := 107;
constant  INPUT8   : integer := 108;
constant  INPUT9   : integer := 109;
constant  INPUT10  : integer := 110;
constant  INPUT11  : integer := 111;
constant  INPUT12  : integer := 112;
constant  INPUT13  : integer := 113;
constant  INPUT14  : integer := 114;
constant  INPUT15  : integer := 115;
constant  INPUT16  : integer := 116;
constant  INPUT17  : integer := 117;
constant  INPUT18  : integer := 118;
constant  INPUT19  : integer := 119;
constant  INPUT20  : integer := 120;
constant  INPUT21  : integer := 121;
constant  INPUT22  : integer := 122;
constant  INPUT23  : integer := 123;
constant  INPUT24  : integer := 124;
constant  INPUT25  : integer := 125;
constant  INPUT26  : integer := 126;
constant  INPUT27  : integer := 127;
constant  ANYINPUT : integer := 200;

-- For compatability with older version
constant  iLOADLOOP     : integer := 256*24;
constant  iDECLOOP      : integer := 256*25;
constant  iINCLOOP      : integer := 256*26;
constant  iLOOPZ        : integer := 16#08#;
constant  LOOPZ         : integer := 16#08#;


-- This must be set to 1 when user instructions are inserted in the code
constant EN_USER : integer range 0 to 1 := 0;

end COREABC_C0_COREABC_C0_0_support;


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


package body COREABC_C0_COREABC_C0_0_support is

function conv_integer_to_flag_vector ( ionum : integer ) return std_logic_vector is
begin
    case ionum is
        -- lower integers are used for flags such as ALWAYS, ZERO, NEGATIVE, ZZERO
        when   0 => return X"00000000";
        when   1 => return X"00000001";
        when   2 => return X"00000002";
        when   3 => return X"00000003";
        when   4 => return X"00000004";
        when   5 => return X"00000005";
        when   6 => return X"00000006";
        when   7 => return X"00000007";
        when   8 => return X"00000008";
        when   9 => return X"00000009";
        when  10 => return X"0000000a";

        -- fill in more values as required

        -- integers 100 to 127 are used for inputs 0 to 27
        when 100 => return X"00000010";
        when 101 => return X"00000020";
        when 102 => return X"00000040";
        when 103 => return X"00000080";
        when 104 => return X"00000100";
        when 105 => return X"00000200";
        when 106 => return X"00000400";
        when 107 => return X"00000800";
        when 108 => return X"00001000";
        when 109 => return X"00002000";
        when 110 => return X"00004000";
        when 111 => return X"00008000";
        when 112 => return X"00010000";
        when 113 => return X"00020000";
        when 114 => return X"00040000";
        when 115 => return X"00080000";
        when 116 => return X"00100000";
        when 117 => return X"00200000";
        when 118 => return X"00400000";
        when 119 => return X"00800000";
        when 120 => return X"01000000";
        when 121 => return X"02000000";
        when 122 => return X"04000000";
        when 123 => return X"08000000";
        when 124 => return X"10000000";
        when 125 => return X"20000000";
        when 126 => return X"40000000";
        when 127 => return X"80000000";

        -- integer 200 used to indicate "any input"
        when 200 => return X"fffffff0";

        when others => return X"00000000";
    end case;
end conv_integer_to_flag_vector;

function doins  ( s1 : integer;
                  s2 : integer;
                  s3 : integer;
                  s4 : integer;
                  s5 : integer
              ) return std_logic_vector is
begin
  return( doinsN(5,s1,s2,s3,s4,s5));
end doins;

function doins  ( s1 : integer;
                  s2 : integer;
                  s3 : integer;
                  s4 : integer
              ) return std_logic_vector is
begin
  return( doinsN(4,s1,s2,s3,s4,-1));
end doins;

function doins  ( s1 : integer;
                  s2 : integer;
                  s3 : integer
                ) return std_logic_vector is
begin
  return( doinsN(3,s1,s2,s3,-1,-1));
end doins;

function doins  ( s1 : integer;
                  s2 : integer
                ) return std_logic_vector is
begin
  return( doinsN(2,s1,s2,-1,-1,-1));
end doins;

function doins  ( s1 : integer
                ) return std_logic_vector is
begin
  return( doinsN(1,s1,-1,-1,-1,-1));
end doins;


function chartoint ( c : character ) return integer is
begin
   return(character'pos(c));
end chartoint;


function encode (vcmd, vscmd, vslot, vaddr, vdata : std_logic_vector) return std_logic_vector is
variable instruction : std_logic_vector(32+16+4+6-1 downto 0);
begin
  instruction := vdata & vaddr & vslot & vscmd & vcmd;
  return( instruction );
end encode;


function doinsn( N  : integer;
                 s1 : integer;
                 s2 : integer;
                 s3 : integer;
                 s4 : integer;
                 s5 : integer
                 ) return std_logic_vector is
variable vcmd  : std_logic_vector(2  downto 0);
variable vscmd : std_logic_vector(2  downto 0);
variable vslot : std_logic_vector(3  downto 0);
variable vaddr : std_logic_vector(15 downto 0);
variable vdata : std_logic_vector(31 downto 0);
constant ONES  : std_logic_vector(31 downto 0) := ( others => '1');
constant ZERO  : std_logic_vector(31 downto 0) := ( others => '0');
variable instr : integer;
variable FFW   : integer;
begin
  vcmd  := "---";
  vscmd := "---";
  vslot := "---0";
  vaddr := ( others => '-');
  vdata := ( others => '-');
  instr := s1/256;	        -- Main instruction in top 8 bits
  FFW   := s1 - instr*256;	-- Extra information in bottom 8 bits
  instr := instr*256;		-- But back in top 8 bits for case branch
  case instr is
    when iLOAD     =>  vcmd := "000"; vscmd := "111"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iINCB     =>  if FFW>0  then
					   	 -- MAP to add instruction
						 vcmd := "000"; vscmd := "100"; vslot(0) := '0'; vdata := conv_std_logic_vector(1,32);
					   else
	                     vcmd := "000"; vscmd := "000"; vslot(0) := '0';
					   end if;
    when iDEC      =>  -- MAP to add instruction
					   vcmd := "000"; vscmd := "100"; vslot(0) := '0'; vdata := ( others => '1');
    when iAND      =>  vcmd := "000"; vscmd := "001"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iOR       =>  vcmd := "000"; vscmd := "010"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iXOR      =>  vcmd := "000"; vscmd := "011"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iADD      =>  vcmd := "000"; vscmd := "100"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iMULT     =>  vcmd := "000"; vscmd := "000"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iSUB      =>  vcmd := "000"; vscmd := "100"; vslot(0) := '0';
	                   vdata := not (conv_std_logic_vector( s2,32) -1);
                       if n>=3 then
					     vdata := not (conv_std_logic_vector( s3,32) -1);
                         case s2 is
                           when iDAT  =>
                           when iDAT8 => vdata(31 downto 8)  := ( others => '1');
                           when iDAT16=> vdata(31 downto 16) := ( others => '1');
                           when iDAT32=>
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iSHL0     =>  vcmd := "000"; vscmd := "101"; vdata(1 downto 0) := "00";  vslot(0) := '0';
    when iSHL1     =>  vcmd := "000"; vscmd := "101"; vdata(1 downto 0) := "01";  vslot(0) := '0';
    when iSHLE     =>  vcmd := "000"; vscmd := "101"; vdata(1 downto 0) := "10";  vslot(0) := '0';
    when iROL      =>  vcmd := "000"; vscmd := "101"; vdata(1 downto 0) := "11";  vslot(0) := '0';
    when iSHR0     =>  vcmd := "000"; vscmd := "110"; vdata(1 downto 0) := "00";  vslot(0) := '0';
    when iSHR1     =>  vcmd := "000"; vscmd := "110"; vdata(1 downto 0) := "01";  vslot(0) := '0';
    when iSHRE     =>  vcmd := "000"; vscmd := "110"; vdata(1 downto 0) := "10";  vslot(0) := '0';
    when iROR      =>  vcmd := "000"; vscmd := "110"; vdata(1 downto 0) := "11";  vslot(0) := '0';
    when iCMP      =>  vcmd := "001"; vscmd := "011"; vslot(0) := '0'; vdata := conv_std_logic_vector( s2,32);
                       if n>=3 then
                         case s2 is
                           when iDAT  => vdata := conv_std_logic_vector( s3,32);
                           when iDAT8 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16=> vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32=> vdata := conv_std_logic_vector( s3,32);
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iCMPLEQ   =>  vcmd := "001"; vscmd := "100"; vslot(0) := '0'; vdata := not (conv_std_logic_vector( s2,32) -1);
                       if n>=3 then
					     vdata := not (conv_std_logic_vector( s3,32) -1);
                         case s2 is
                           when iDAT  =>
                           when iDAT8 => vdata(31 downto 8)  := ( others => '1');
                           when iDAT16=> vdata(31 downto 16) := ( others => '1');
                           when iDAT32=>
                           when iRAM  => vaddr(7 downto 0) := conv_std_logic_vector( s3,8); vslot(0) := '1';  vdata := ( others => '-');
                           when others =>
                         end case;
                       end if;
    when iBITCLR   =>  vcmd := "000"; vscmd := "001"; vdata := ONES; vdata(s2) := '0'; vslot(0) := '0';
    when iBITSET   =>  vcmd := "000"; vscmd := "010"; vdata := ZERO; vdata(s2) := '1'; vslot(0) := '0';
    when iBITTST   =>  vcmd := "001"; vscmd := "001"; vdata := ZERO; vdata(s2) := '1'; vslot(0) := '0';
    when iAPBREADZ =>  vcmd := "010"; vscmd := "111"; vslot := conv_std_logic_vector( s2,4);
    when iAPBWRTZ  =>  vcmd := "010"; vscmd := "---"; vslot := conv_std_logic_vector( s3,4);
                       case s2 is
                         when iACM   => vscmd := "110";
                         when iACC   => vscmd := "100";
                         when iDAT   => vscmd := "101"; vdata := conv_std_logic_vector( s4,32);
                         when iDAT8  => vscmd := "101"; vdata := conv_std_logic_vector( s4,32); vdata(31 downto 8)  := ( others => '-');
                         when iDAT16 => vscmd := "101"; vdata := conv_std_logic_vector( s4,32); vdata(31 downto 16) := ( others => '-');
                         when iDAT32 => vscmd := "101"; vdata := conv_std_logic_vector( s4,32);
                         when others =>
                       end case;
    when iAPBREAD  =>  vcmd := "010"; vscmd := "011"; vslot := conv_std_logic_vector( s2,4);    vaddr := conv_std_logic_vector( s3,16);
    when iAPBWRT   =>  vcmd := "010"; vscmd := "---"; vslot := conv_std_logic_vector( s3,4);    vaddr := conv_std_logic_vector( s4,16);
                       case s2 is
                         when iACM   => vscmd := "010";
                         when iACC   => vscmd := "000";
                         when iDAT   => vscmd := "001"; vdata := conv_std_logic_vector( s5,32);
                         when iDAT8  => vscmd := "001"; vdata := conv_std_logic_vector( s5,32); vdata(31 downto 8)  := ( others => '-');
                         when iDAT16 => vscmd := "001"; vdata := conv_std_logic_vector( s5,32); vdata(31 downto 16) := ( others => '-');
                         when iDAT32 => vscmd := "001"; vdata := conv_std_logic_vector( s5,32);
                         when others =>
                       end case;
    when iLOADZ    =>  vcmd := "011"; vscmd := "000";  vslot(0) := '0';
                       case s2 is
                         when iACC   => vslot(0) := '1'; vdata := ( others => '-');
                         when iDAT   => vdata := conv_std_logic_vector( s3,32);
                         when iDAT8  => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                         when iDAT16 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                         when iDAT32 => vdata := conv_std_logic_vector( s3,32);
                         when others =>
                       end case;
    when iINCZ     =>  vcmd := "011"; vscmd := "001"; vslot(0) := '0'; vdata := conv_std_logic_vector( 1,32);
    when iDECZ     =>  vcmd := "011"; vscmd := "001"; vslot(0) := '0'; vdata := (others => '1');
    when iADDZ     =>  vcmd := "011"; vscmd := "001"; vslot(0) := '0';
                       case s2 is
                         when iACC   => vslot(0) := '1'; vdata := ( others => '-');
                         when iDAT   => vdata := conv_std_logic_vector( s3,32);
                         when iDAT8  => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                         when iDAT16 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                         when iDAT32 => vdata := conv_std_logic_vector( s3,32);
                         when others =>
					   end case;
    when iSUBZ     =>  vcmd := "011"; vscmd := "001"; vslot(0) := '0';
                       case s2 is
                         when iACC   => vslot(0) := '1'; vdata := ( others => '-');
                         when iDAT   => vdata := not (conv_std_logic_vector( s3,32) -1);
                         when iDAT8  => vdata := not (conv_std_logic_vector( s3,32) -1);
                         when iDAT16 => vdata := not (conv_std_logic_vector( s3,32) -1);
                         when iDAT32 => vdata := not (conv_std_logic_vector( s3,32) -1);
                         when others =>
                       end case;
    when iIOWRT    =>  vcmd := "011"; vscmd := "111"; vslot(0) := '0';
                       case s2 is
                         when iACC   => vslot(0) := '1'; vdata := ( others => '-');
                         when iDAT   => vdata := conv_std_logic_vector( s3,32);
                         when iDAT8  => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                         when iDAT16 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                         when iDAT32 => vdata := conv_std_logic_vector( s3,32);
                         when others =>
                       end case;
    when iIOREAD   =>  vcmd := "011"; vscmd := "110";
    when iRAMREAD  =>  vcmd := "011"; vscmd := "011"; vaddr := conv_std_logic_vector( s2,16);
    when iRAMWRT   =>  vcmd := "011"; vscmd := "010"; vaddr := conv_std_logic_vector( s2,16);  vslot(0) := '1';
                       if n>=3 then
					     vslot(0) := '0';
						 vaddr := conv_std_logic_vector( s2,16);
                         case s3 is
                           when iACC   =>  vslot(0) := '1'; vdata := ( others => '-');
                           when iDAT   =>  vdata := conv_std_logic_vector( s4,32);
                           when iDAT8  =>  vdata := conv_std_logic_vector( s4,32); vdata(31 downto 8)  := ( others => '-');
                           when iDAT16 =>  vdata := conv_std_logic_vector( s4,32); vdata(31 downto 16) := ( others => '-');
                           when iDAT32 =>  vdata := conv_std_logic_vector( s4,32);
                           when others =>
                         end case;
                       end if;
    when iPUSH     =>  vcmd := "011"; vscmd := "100";  vslot(0) := '0';
                       case s2 is
                         when BLANK  => vslot(0) := '1'; vdata := ( others => '-');
						 when iACC   => vslot(0) := '1'; vdata := ( others => '-');
                         when iDAT   => vdata := conv_std_logic_vector( s3,32);
                         when iDAT8  => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 8)  := ( others => '-');
                         when iDAT16 => vdata := conv_std_logic_vector( s3,32); vdata(31 downto 16) := ( others => '-');
                         when iDAT32 => vdata := conv_std_logic_vector( s3,32);
                         when others =>
                       end case;
    when iPOP      =>  vcmd := "011"; vscmd := "101";
    when iJUMPB    =>  vcmd := "100"; vscmd := "-01";
                       if n>=4 then
                         vscmd(0) := to_logic(s2);
                        --vdata := conv_std_logic_vector( s3,32);
                        vdata := conv_integer_to_flag_vector(s3);
                         vaddr := conv_std_logic_vector( s4,16);
                       else
                         vdata(0) := '1';
                         vaddr := conv_std_logic_vector( s2,16);
                       end if;
					   vdata(31 downto FFW+4) := ( others => '-'); -- no flag tests on these bits
    when iWAITB    =>  vcmd := "100"; vscmd := "-11";
                       if n>=3 then
                         vscmd(0) := to_logic(s2);
                        --vdata := conv_std_logic_vector( s3,32);
                        vdata := conv_integer_to_flag_vector(s3);
                       else
                         vdata(0) := '1';
                       end if;
					   vdata(31 downto FFW+4) := ( others => '-'); -- no flag tests on these bits
    when iCALLB     => vcmd := "101"; vscmd := "-01";
                       if n>=4 then
                         vscmd(0) := to_logic(s2);
                        --vdata := conv_std_logic_vector( s3,32);
                        vdata := conv_integer_to_flag_vector(s3);
                         vaddr := conv_std_logic_vector( s4,16);
                       else
                         vdata(0) := '1';
                         vaddr := conv_std_logic_vector( s2,16);
                       end if;
					   vdata(31 downto FFW+4) := ( others => '-'); -- no flag tests on these bits
    when iRETURNB  =>  vcmd := "110"; vscmd := "-01";
                       if n>=3 then
                         vscmd(0) := to_logic(s2);
                        --vdata := conv_std_logic_vector( s3,32);
                        vdata := conv_integer_to_flag_vector(s3);
                       else
                         vdata(0) := '1';
                       end if;
					   vdata(31 downto FFW+4) := ( others => '-'); -- no flag tests on these bits
    when iRETISRB  =>  vcmd := "110"; vscmd := "-11";
                       if n>=3 then
                         vscmd(0) := to_logic(s2);
                         --vdata := conv_std_logic_vector( s3,FFW);
                         vdata := conv_integer_to_flag_vector( s3);
                       else
                         vdata(0) := '1';
                       end if;
					   vdata(31 downto FFW+4) := ( others => '-'); -- no flag tests on these bits
    when iNOP      =>  vcmd := "111";
                       if EN_USER=1 then
                         vscmd := "000";
                       end if;
    -- The following branch should be modified as necessary to add any user functionality
    -- Plus the EN_USER constant must be set above
    -- Remember as many bits of the instruction word should be dont care as possible
    when iUSER     =>  vcmd := "111"; vscmd(0) := '1';
                       vscmd := conv_std_logic_vector(s2,3);
                       vdata := conv_std_logic_vector(s3,32);
                       vaddr := conv_std_logic_vector(s4,16);
                       vslot := conv_std_logic_vector(s5,4);
    when others =>
  end case;
  return( encode(vcmd,vscmd,vslot,vaddr,vdata ));
end  doinsn;


----------------------------------------------------------------------------
-- General routines

function max1( a, b : integer ) return integer is
 begin
   if a>b then return (a);
          else return (b);
   end if;
end max1;

function min1( a, b : integer ) return integer is
 begin
   if a<b then return (a);
          else return (b);
   end if;
end min1;

function to_logic( tmp : integer ) return std_logic is
 begin
   if tmp/=0 then return ('1');
             else return ('0');
   end if;
end to_logic;


function to_logic( tmp : boolean ) return std_logic is
 begin
   if tmp then return ('1');
          else return ('0');
   end if;
end to_logic;


function calc_irwidth( en_ram,en_call,dwidth,icwidth : integer ) return integer is
variable dw, iw : integer;
begin
  dw :=0;
  iw :=0;
  if en_call=1  then
    iw := 8;
    if icwidth>8 then
      iw := 16;
    end if;
  end if;
  if en_ram=1  then
    dw := dwidth;
  end if;
  if dw>iw then return(dw);
    elsif iw>0 then return(iw);
      else return(1);  -- set to 1 if no rams
  end if;
end calc_irwidth;

function calc_swidth( x : integer ) return integer is
begin
  if x>=9 then return(4);
   elsif x>=5 then return(3);
    elsif x>=3 then return(2);
     elsif x>=2 then return(1);
      else return(0);
  end if;
end calc_swidth;

function log2r( x : integer ) return integer is
begin

-- this does not translate to verilog cleanly
--   case x is
--     when 65536 to 131071 => return(17);
--     when 32768 to 65535  => return(16);
--     when 16384 to 32767  => return(15);
--     when 8192  to 16383  => return(14);
--     when 4096  to 8191   => return(13);
--     when 2048  to 4095   => return(12);
--     when 1024  to 2047   => return(11);
--     when 512   to 1023   => return(10);
--     when 256   to 511    => return(9);
--     when 128   to 255    => return(8);
--     when 64    to 127    => return(7);
--     when 32    to 63     => return(6);
--     when 16    to 31     => return(5);
--     when 8     to 15     => return(4);
--     when 4     to 7      => return(3);
--     when 2     to 3      => return(2);
--     when 1               => return(1);
--     when others          => return(1);
--   end case;

    if     x>=65536 then return(17);
     elsif x>=32768 then return(16);
     elsif x>=16384 then return(15);
     elsif x>=8192  then return(14);
     elsif x>=4096  then return(13);
     elsif x>=2048  then return(12);
     elsif x>=1024  then return(11);
     elsif x>=512   then return(10);
     elsif x>=256   then return(9);
     elsif x>=128   then return(8);
     elsif x>=64    then return(7);
     elsif x>=32    then return(6);
     elsif x>=16    then return(5);
     elsif x>=8     then return(4);
     elsif x>=4     then return(3);
     elsif x>=2     then return(2);
     elsif x>=1     then return(1);
     else                return(1);
   end if;

end log2r;

function calc_initwidth (AWIDTH,DWIDTH,SDEPTH,ICWIDTH : integer) return integer is
variable SWIDTH   : integer;
variable RAMDEPTH : integer;
variable RAMWIDTH : integer;
variable NROWS    : integer;
variable NCOLS    : integer;
variable NRAMS    : integer;
variable RIDEPTH  : integer;
variable RIWIDTH  : integer;
begin
  if SDEPTH=0 then
    SWIDTH :=  calc_swidth(SDEPTH);
  else
    SWIDTH := 1;
  end if;
  RAMDEPTH  := 2**ICWIDTH;
  RAMWIDTH  := AWIDTH+DWIDTH+SWIDTH+6;
  NROWS     := 1+ (RAMDEPTH-1)/512 ;
  NCOLS     := 1+ (RAMWIDTH-1)/9 ;
  NRAMS     :=  NCOLS*NROWS ;
  RIDEPTH   :=  NRAMS*512;
  RIWIDTH   :=  log2r(RIDEPTH);
  if RIWIDTH>16 then  -- limit size
    RIWIDTH := 16;	  -- Cores configured for NVM mode may be greater
  end if;
  return(RIWIDTH);
end calc_initwidth;


function clean( x : std_logic_vector ) return std_logic_vector is
variable tmp : std_logic_vector(x'range);
begin
  tmp := x;
  -- synthesis translate_off
  tmp := ( others => '0');
  for i in tmp'range loop
    if x(i)='1' then
      tmp(i) := '1';
    end if;
  end loop;
  -- synthesis translate_on
  return(tmp);
end clean;



end COREABC_C0_COREABC_C0_0_support;
