-- ********************************************************************/ 
-- Actel Corporation Proprietary and Confidential
-- Copyright 2008 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN 
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED 
-- IN ADVANCE IN WRITING.  
--  
-- Description: AMBA BFMs
--              AHB Lite BFM  
--
-- Revision Information:
-- Date     Description
-- 01Sep07  Initial Release 
-- 14Sep07  Updated for 1.2 functionality
-- 25Sep07  Updated for 1.3 functionality
-- 09Nov07  Updated for 1.4 functionality
-- 08May08  2.0 for Soft IP Usage
--
--
-- SVN Revision Information:
-- SVN $Revision: 23452 $
-- SVN $Date: 2014-09-22 15:29:48 -0700 (Mon, 22 Sep 2014) $
--
--
-- Resolved SARs
-- SAR      Date     Who  Description
--
--
-- Notes: 
--        
-- *********************************************************************/ 

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

use work.bfm_textio.all;
use work.bfm_misc.all;



package bfm_package is 

---------------------------------------------------------------------------------------------
-- Constants

constant C_VECTORS_VERSION : integer := 22;

-- Command Encodings in Vectors
constant C_NOP       : integer := 0;

constant C_WRITE     : integer := 4;
constant C_READ      : integer := 8;
constant C_RDCHK     : integer := 12;
constant C_RDMSK     : integer := 16;
constant C_POLL      : integer := 20;
constant C_POLLM     : integer := 24;
constant C_POLLB     : integer := 28;

constant C_WRTM      : integer := 32;
constant C_FILL      : integer := 36;
constant C_WRTT      : integer := 40;
constant C_RDM       : integer := 44;
constant C_RDMC      : integer := 48;
constant C_READF     : integer := 52;
constant C_READT     : integer := 56;

constant C_IOTST     : integer := 60;
constant C_IOWAIT    : integer := 64;
constant C_READS     : integer := 68;
constant C_AHBC      : integer := 72;
constant C_WRTA      : integer := 76;
constant C_READA     : integer := 80;


constant C_IOWR      : integer := 100;
constant C_IORD      : integer := 101;
constant C_IOCHK     : integer := 102;
constant C_IOMSK     : integer := 103;
constant C_IOSET     : integer := 104;
constant C_IOCLR     : integer := 105;
constant C_INTREQ    : integer := 106;
constant C_FIQ       : integer := 107;
constant C_IRQ       : integer := 108;

constant C_HRESP     : integer := 109;
constant C_EXTW      : integer := 110;
constant C_EXTR      : integer := 111;
constant C_EXTRC     : integer := 112;
constant C_EXTMSK    : integer := 113; 
constant C_EXTWT     : integer := 114; 
constant C_EXTWM     : integer := 115; 

constant C_LABEL     : integer := 128;
constant C_JMP       : integer := 129;
constant C_JMPZ      : integer := 130;
constant C_JMPNZ     : integer := 131;
constant C_CALL      : integer := 132;
constant C_CALLP     : integer := 133;
constant C_RET       : integer := 134;
constant C_LOOP      : integer := 135;
constant C_LOOPE     : integer := 136;

constant C_WAIT      : integer := 137;
constant C_STOP      : integer := 138;
constant C_QUIT      : integer := 139;
constant C_TOUT      : integer := 140;
constant C_TABLE     : integer := 141;
constant C_FLUSH     : integer := 142;

constant C_PRINT     : integer := 150;
constant C_HEAD      : integer := 151;
constant C_FILEN     : integer := 152;
constant C_MEMT      : integer := 153;
constant C_MEMT2     : integer := 154;

constant C_MODE      : integer := 160;
constant C_SETUP     : integer := 161;
constant C_DEBUG     : integer := 162;
constant C_PROT      : integer := 163;
constant C_LOCK      : integer := 164;
constant C_ERROR     : integer := 165;
constant C_BURST     : integer := 166;
constant C_CHKT      : integer := 167;
constant C_SFAIL     : integer := 168;
constant C_STTIM     : integer := 169;
constant C_CKTIM     : integer := 170;
constant C_RAND      : integer := 171;
constant C_CONPU     : integer := 172;
				     	

constant C_MMAP      : integer := 200;
constant C_SET       : integer := 201;
constant C_CONS      : integer := 202;
constant C_INT       : integer := 203;
constant C_CALC      : integer := 204;
constant C_CMP       : integer := 205;
constant C_RESET     : integer := 206;
constant C_CLKS      : integer := 207;
constant C_IF        : integer := 208;
constant C_IFNOT     : integer := 209;
constant C_WHILE     : integer := 210;
constant C_ELSE      : integer := 211;
constant C_ENDIF     : integer := 212;
constant C_ENDWHILE  : integer := 213;
constant C_CASE      : integer := 214;
constant C_WHEN      : integer := 215;
constant C_ENDCASE   : integer := 216;
constant C_DEFAULT   : integer := 217;
constant C_CMPR      : integer := 218;
constant C_RETV      : integer := 219;
constant C_WAITNS    : integer := 220;
constant C_WAITUS    : integer := 221;
constant C_DRVX      : integer := 222;

constant C_VERS      : integer := 250;
constant C_LOGF      : integer := 251;
constant C_LOGS      : integer := 252;
constant C_LOGE      : integer := 253;
constant C_ECHO      : integer := 254;
constant C_FAIL      : integer := 255;


constant OP_NONE  : integer := 1001;
constant OP_ADD   : integer := 1002;
constant OP_SUB   : integer := 1003;
constant OP_MULT  : integer := 1004;
constant OP_DIV   : integer := 1005;
constant OP_MOD   : integer := 1006;
constant OP_POW   : integer := 1007;
constant OP_AND   : integer := 1008;
constant OP_OR    : integer := 1009;
constant OP_XOR   : integer := 1010;
constant OP_CMP   : integer := 1011;
constant OP_SHL   : integer := 1012;
constant OP_SHR   : integer := 1013;
constant OP_EQ    : integer := 1014;
constant OP_NEQ   : integer := 1015;
constant OP_GR    : integer := 1016;
constant OP_LS    : integer := 1017;
constant OP_GRE   : integer := 1018;
constant OP_LSE   : integer := 1019;
constant OP_SETB  : integer := 1020;
constant OP_CLRB  : integer := 1021;
constant OP_INVB  : integer := 1022;
constant OP_TSTB  : integer := 1023;

constant D_NORMAL    : integer := 0;
constant D_ARGVALUE  : integer := 1;
constant D_RAND      : integer := 2;
constant D_RANDSET   : integer := 3;
constant D_RANDRESET : integer := 4;

constant D_RESERVED  : integer := 0;
constant D_RETVALUE  : integer := 1;
constant D_TIME      : integer := 2;
constant D_DEBUG     : integer := 3;
constant D_LINENO    : integer := 4;
constant D_ERRORS    : integer := 5;
constant D_TIMER     : integer := 6;
constant D_LTIMER    : integer := 7;
constant D_LICYCLES  : integer := 8;


constant E_DATA   : integer := 16#00000000#;   
constant E_ADDR   : integer := 16#00002000#;   
constant E_STACK  : integer := 16#00004000#;
constant E_CONST  : integer := 16#00006000#;   
constant E_ARRAY  : integer := 16#00008000#;   

              
type  Tcommand_s is  ( B,H,W,X);

---------------------------------------------------------------------------------------------
-- Function Calls

subtype SLV32    is std_logic_vector (31 downto 0);
type SLV32_ARRAY is array ( INTEGER range <>) of SLV32;

function align_data( size   : std_logic_vector(2 downto 0);
                     addr10 : std_logic_vector(1 downto 0);
                     datain : std_logic_vector(31 downto 0);
					 alignmode : integer
                    ) return std_logic_vector;

function align_mask( size   : std_logic_vector(2 downto 0);
                     addr10 : std_logic_vector(1 downto 0);
                     datain : std_logic_vector(31 downto 0);
					 alignmode : integer
                    ) return std_logic_vector;

function align_read( size   : std_logic_vector(2 downto 0);
                     addr10 : std_logic_vector(1 downto 0);
                     datain : std_logic_vector(31 downto 0);
					 alignmode : integer
                    ) return std_logic_vector;


function to_ascii( x : integer ) return character;
function to_char(size : integer) return character;
function to_char(size : std_logic_vector) return character;
function to_int( xlv : std_logic_vector ) return integer;
function to_slv32( x : integer ) return std_logic_vector;
function address_increment(size : integer; xainc : integer) return integer;
function xfer_size(size : integer; xsize : integer) return std_logic_vector;
function calculate( op: integer; x,y : integer;  debug : integer) return integer;
function clean( x : std_logic_vector ) return std_logic_vector;
function extract_string( cptr: integer; vectors : INTEGER_ARRAY; command : INTEGER_ARRAY) return string;
function len_string( len : integer) return integer;
function get_file(lineno,x : integer) return integer;
function get_line(lineno,x : integer) return integer;
function to_int_signed( xlv : std_logic_vector ) return integer;
function to_int_unsigned( xlv : std_logic_vector ) return integer;
function random( seed : integer) return integer;
function mask_randomN( seed :integer ; size : integer) return integer;
function mask_randomS( seed :integer ; size : integer) return integer;  

function bound1k( bmode: integer; addr : std_logic_vector) return boolean;

---------------------------------------------------------------------------------------------

component BFM_MAIN 
  generic ( OPMODE           : integer range 0 to 2 := 0;
            VECTFILE         : string  := "test.vec";
            MAX_INSTRUCTIONS : integer := 16384;
            MAX_STACK        : integer := 1024;
            MAX_MEMTEST      : integer := 65536;
            TPD              : integer range 0 to 1000 := 1;
            DEBUGLEVEL       : integer range -1 to 5 := -1;
			CON_SPULSE       : integer range 0 to 1 := 0;
            ARGVALUE0        : integer :=0; 
            ARGVALUE1        : integer :=0; 
            ARGVALUE2        : integer :=0; 
            ARGVALUE3        : integer :=0; 
            ARGVALUE4        : integer :=0; 
            ARGVALUE5        : integer :=0; 
            ARGVALUE6        : integer :=0; 
            ARGVALUE7        : integer :=0; 
            ARGVALUE8        : integer :=0; 
            ARGVALUE9        : integer :=0;
            ARGVALUE10       : integer :=0; 
            ARGVALUE11       : integer :=0; 
            ARGVALUE12       : integer :=0; 
            ARGVALUE13       : integer :=0; 
            ARGVALUE14       : integer :=0; 
            ARGVALUE15       : integer :=0; 
            ARGVALUE16       : integer :=0; 
            ARGVALUE17       : integer :=0; 
            ARGVALUE18       : integer :=0; 
            ARGVALUE19       : integer :=0; 
            ARGVALUE20       : integer :=0; 
            ARGVALUE21       : integer :=0; 
            ARGVALUE22       : integer :=0; 
            ARGVALUE23       : integer :=0; 
            ARGVALUE24       : integer :=0; 
            ARGVALUE25       : integer :=0; 
            ARGVALUE26       : integer :=0; 
            ARGVALUE27       : integer :=0; 
            ARGVALUE28       : integer :=0; 
            ARGVALUE29       : integer :=0;
            ARGVALUE30       : integer :=0; 
            ARGVALUE31       : integer :=0; 
            ARGVALUE32       : integer :=0; 
            ARGVALUE33       : integer :=0; 
            ARGVALUE34       : integer :=0; 
            ARGVALUE35       : integer :=0; 
            ARGVALUE36       : integer :=0; 
            ARGVALUE37       : integer :=0; 
            ARGVALUE38       : integer :=0; 
            ARGVALUE39       : integer :=0; 
            ARGVALUE40       : integer :=0; 
            ARGVALUE41       : integer :=0; 
            ARGVALUE42       : integer :=0; 
            ARGVALUE43       : integer :=0; 
            ARGVALUE44       : integer :=0; 
            ARGVALUE45       : integer :=0; 
            ARGVALUE46       : integer :=0; 
            ARGVALUE47       : integer :=0; 
            ARGVALUE48       : integer :=0; 
            ARGVALUE49       : integer :=0; 
            ARGVALUE50       : integer :=0; 
            ARGVALUE51       : integer :=0; 
            ARGVALUE52       : integer :=0; 
            ARGVALUE53       : integer :=0; 
            ARGVALUE54       : integer :=0; 
            ARGVALUE55       : integer :=0; 
            ARGVALUE56       : integer :=0; 
            ARGVALUE57       : integer :=0; 
            ARGVALUE58       : integer :=0; 
            ARGVALUE59       : integer :=0; 
            ARGVALUE60       : integer :=0; 
            ARGVALUE61       : integer :=0; 
            ARGVALUE62       : integer :=0; 
            ARGVALUE63       : integer :=0; 
            ARGVALUE64       : integer :=0; 
            ARGVALUE65       : integer :=0; 
            ARGVALUE66       : integer :=0; 
            ARGVALUE67       : integer :=0; 
            ARGVALUE68       : integer :=0; 
            ARGVALUE69       : integer :=0; 
            ARGVALUE70       : integer :=0; 
            ARGVALUE71       : integer :=0; 
            ARGVALUE72       : integer :=0; 
            ARGVALUE73       : integer :=0; 
            ARGVALUE74       : integer :=0; 
            ARGVALUE75       : integer :=0; 
            ARGVALUE76       : integer :=0; 
            ARGVALUE77       : integer :=0; 
            ARGVALUE78       : integer :=0; 
            ARGVALUE79       : integer :=0; 
            ARGVALUE80       : integer :=0; 
            ARGVALUE81       : integer :=0; 
            ARGVALUE82       : integer :=0; 
            ARGVALUE83       : integer :=0; 
            ARGVALUE84       : integer :=0; 
            ARGVALUE85       : integer :=0; 
            ARGVALUE86       : integer :=0; 
            ARGVALUE87       : integer :=0; 
            ARGVALUE88       : integer :=0; 
            ARGVALUE89       : integer :=0; 
            ARGVALUE90       : integer :=0; 
            ARGVALUE91       : integer :=0; 
            ARGVALUE92       : integer :=0; 
            ARGVALUE93       : integer :=0; 
            ARGVALUE94       : integer :=0; 
            ARGVALUE95       : integer :=0; 
            ARGVALUE96       : integer :=0; 
            ARGVALUE97       : integer :=0; 
            ARGVALUE98       : integer :=0; 
            ARGVALUE99       : integer :=0
           );
  port ( SYSCLK      : in    std_logic;
         SYSRSTN     : in    std_logic;
         -- AHB Interface
         PCLK        : out   std_logic;
         HCLK        : out   std_logic;
         HRESETN     : out   std_logic;
         HADDR       : out   std_logic_vector(31 downto 0);
         HBURST      : out   std_logic_vector( 2 downto 0);
         HMASTLOCK   : out   std_logic;
         HPROT       : out   std_logic_vector( 3 downto 0);
         HSIZE       : out   std_logic_vector( 2 downto 0);
         HTRANS      : out   std_logic_vector( 1 downto 0);
         HWRITE      : out   std_logic;
         HWDATA      : out   std_logic_vector(31 downto 0);
         HRDATA      : in    std_logic_vector(31 downto 0);
         HREADY      : in    std_logic;
         HRESP       : in    std_logic;
         HSEL        : out   std_logic_vector(15 downto 0);
         INTERRUPT   : in    std_logic_vector(255 downto 0);
         --Control etc
         GP_OUT      : out   std_logic_vector(31 downto 0);
         GP_IN       : in    std_logic_vector(31 downto 0);
         EXT_WR      : out   std_logic;
         EXT_RD      : out   std_logic;
         EXT_ADDR    : out   std_logic_vector(31 downto 0);
         EXT_DATA    : inout std_logic_vector(31 downto 0);
         EXT_WAIT    : in    std_logic;
	     CON_ADDR    : in    std_logic_vector(15 downto 0);
         CON_DATA    : inout std_logic_vector(31 downto 0);
         CON_RD      : in    std_logic;
         CON_WR      : in    std_logic;
         CON_BUSY    : out   std_logic;
         INSTR_OUT   : out   std_logic_vector(31 downto 0);
         INSTR_IN    : in    std_logic_vector(31 downto 0);
         FINISHED    : out   std_logic;
         FAILED      : out   std_logic
       );
end component;

component BFM_AHBSLAVEEXT
  generic ( AWIDTH    : integer range 1 to 32;
            DEPTH     : integer := 256; 
			EXT_SIZE  : integer range 0 to 2  := 2;
            INITFILE  : string  := "";
            ID        : integer := 0;
            TPD       : integer range 0 to 1000 := 1;
            ENFUNC    : integer := 0;
            ENFIFO    : integer range 0 to 1024 := 0;
            DEBUG     : integer range 0 to 1 :=0
          );
  port ( HCLK        : in    std_logic;
         HRESETN     : in    std_logic;
         HSEL        : in    std_logic;
         HWRITE      : in    std_logic;
         HADDR       : in    std_logic_vector( AWIDTH-1 downto 0);
         HWDATA      : in    std_logic_vector( 31 downto 0);
         HRDATA      : out   std_logic_vector( 31 downto 0);
         HREADYIN    : in    std_logic;
         HREADYOUT   : out   std_logic;
         HTRANS      : in    std_logic_vector(1 downto 0);
         HSIZE       : in    std_logic_vector(2 downto 0);
         HBURST      : in    std_logic_vector(2 downto 0);
         HMASTLOCK   : in    std_logic; 
         HPROT       : in    std_logic_vector(3 downto 0);
         HRESP       : out   std_logic;
		 EXT_EN      : in    std_logic;
		 EXT_WR      : in    std_logic;
         EXT_RD      : in    std_logic;
         EXT_ADDR    : in    std_logic_vector(AWIDTH-1 downto 0);
         EXT_DATA    : inout std_logic_vector(31 downto 0);
		 TXREADY     : out   std_logic;
		 RXREADY     : out   std_logic
       );
end component;



component BFM_AHBSLAVE
  generic ( AWIDTH    : integer range 1 to 32;
            DEPTH     : integer := 256; 
            INITFILE  : string  := "";
            ID        : integer := 0;
            TPD       : integer range 0 to 1000 := 1;
            ENFUNC    : integer := 0;
            DEBUG     : integer range 0 to 1 :=0
          );
  port ( HCLK        : in  std_logic;
         HRESETN     : in  std_logic;
         HSEL        : in  std_logic;
         HWRITE      : in  std_logic;
         HADDR       : in  std_logic_vector( AWIDTH-1 downto 0);
         HWDATA      : in  std_logic_vector( 31 downto 0);
         HRDATA      : out std_logic_vector( 31 downto 0);
         HREADYIN    : in  std_logic;
         HREADYOUT   : out std_logic;
         HTRANS      : in  std_logic_vector(1 downto 0);
         HSIZE       : in  std_logic_vector(2 downto 0);
         HBURST      : in  std_logic_vector(2 downto 0);
         HMASTLOCK   : in  std_logic; 
         HPROT       : in  std_logic_vector(3 downto 0);
         HRESP       : out std_logic
       );
end component;

component BFM_APBSLAVEEXT
  generic ( AWIDTH    : integer range 1 to 32;
            DEPTH     : integer := 256; 
            DWIDTH    : integer range 8 to 32 := 32; 
			EXT_SIZE  : integer range 0 to 2  := 2;
            INITFILE  : string  := "";
            ID        : integer := 0;
            TPD       : integer range 0 to 1000 := 1;
            ENFUNC    : integer := 0;
            DEBUG     : integer range 0 to 1 :=0
          );
  port ( PCLK        : in    std_logic;
         PRESETN     : in    std_logic;
         PENABLE     : in    std_logic;
         PWRITE      : in    std_logic;
         PSEL        : in    std_logic;
         PADDR       : in    std_logic_vector( AWIDTH-1 downto 0);
         PWDATA      : in    std_logic_vector( DWIDTH-1 downto 0);
         PRDATA      : out   std_logic_vector( DWIDTH-1 downto 0);
         PREADY      : out   std_logic;
         PSLVERR     : out   std_logic;
		 EXT_EN      : in    std_logic;
		 EXT_WR      : in    std_logic;
         EXT_RD      : in    std_logic;
         EXT_ADDR    : in    std_logic_vector(AWIDTH-1 downto 0);
         EXT_DATA    : inout std_logic_vector(DWIDTH-1 downto 0)
       );
end component;


component BFM_APBSLAVE
  generic ( AWIDTH    : integer range 1 to 32;
            DEPTH     : integer := 256; 
            DWIDTH    : integer range 8 to 32 := 32; 
            INITFILE  : string  := "";
            ID        : integer := 0;
            TPD       : integer range 0 to 1000 := 1;
            ENFUNC    : integer := 0;
            DEBUG     : integer range 0 to 1 :=0
          );
  port ( PCLK        : in  std_logic;
         PRESETN     : in  std_logic;
         PENABLE     : in  std_logic;
         PWRITE      : in  std_logic;
         PSEL        : in  std_logic;
         PADDR       : in  std_logic_vector( AWIDTH-1 downto 0);
         PWDATA      : in  std_logic_vector( DWIDTH-1 downto 0);
         PRDATA      : out std_logic_vector( DWIDTH-1 downto 0);
         PREADY      : out std_logic;
         PSLVERR     : out std_logic
       );
end component;


component BFM_AHBL 
  generic ( VECTFILE         : string  := "test.vec";
            MAX_INSTRUCTIONS : integer := 16384;
            TPD              : integer range 0 to 1000 := 1;
            MAX_STACK        : integer := 1024;
			MAX_MEMTEST      : integer := 65536;
            DEBUGLEVEL       : integer range -1 to 5 := -1;
            ARGVALUE0        : integer :=0; 
            ARGVALUE1        : integer :=0; 
            ARGVALUE2        : integer :=0; 
            ARGVALUE3        : integer :=0; 
            ARGVALUE4        : integer :=0; 
            ARGVALUE5        : integer :=0; 
            ARGVALUE6        : integer :=0; 
            ARGVALUE7        : integer :=0; 
            ARGVALUE8        : integer :=0; 
            ARGVALUE9        : integer :=0;
            ARGVALUE10       : integer :=0; 
            ARGVALUE11       : integer :=0; 
            ARGVALUE12       : integer :=0; 
            ARGVALUE13       : integer :=0; 
            ARGVALUE14       : integer :=0; 
            ARGVALUE15       : integer :=0; 
            ARGVALUE16       : integer :=0; 
            ARGVALUE17       : integer :=0; 
            ARGVALUE18       : integer :=0; 
            ARGVALUE19       : integer :=0; 
            ARGVALUE20       : integer :=0; 
            ARGVALUE21       : integer :=0; 
            ARGVALUE22       : integer :=0; 
            ARGVALUE23       : integer :=0; 
            ARGVALUE24       : integer :=0; 
            ARGVALUE25       : integer :=0; 
            ARGVALUE26       : integer :=0; 
            ARGVALUE27       : integer :=0; 
            ARGVALUE28       : integer :=0; 
            ARGVALUE29       : integer :=0;
            ARGVALUE30       : integer :=0; 
            ARGVALUE31       : integer :=0; 
            ARGVALUE32       : integer :=0; 
            ARGVALUE33       : integer :=0; 
            ARGVALUE34       : integer :=0; 
            ARGVALUE35       : integer :=0; 
            ARGVALUE36       : integer :=0; 
            ARGVALUE37       : integer :=0; 
            ARGVALUE38       : integer :=0; 
            ARGVALUE39       : integer :=0; 
            ARGVALUE40       : integer :=0; 
            ARGVALUE41       : integer :=0; 
            ARGVALUE42       : integer :=0; 
            ARGVALUE43       : integer :=0; 
            ARGVALUE44       : integer :=0; 
            ARGVALUE45       : integer :=0; 
            ARGVALUE46       : integer :=0; 
            ARGVALUE47       : integer :=0; 
            ARGVALUE48       : integer :=0; 
            ARGVALUE49       : integer :=0; 
            ARGVALUE50       : integer :=0; 
            ARGVALUE51       : integer :=0; 
            ARGVALUE52       : integer :=0; 
            ARGVALUE53       : integer :=0; 
            ARGVALUE54       : integer :=0; 
            ARGVALUE55       : integer :=0; 
            ARGVALUE56       : integer :=0; 
            ARGVALUE57       : integer :=0; 
            ARGVALUE58       : integer :=0; 
            ARGVALUE59       : integer :=0; 
            ARGVALUE60       : integer :=0; 
            ARGVALUE61       : integer :=0; 
            ARGVALUE62       : integer :=0; 
            ARGVALUE63       : integer :=0; 
            ARGVALUE64       : integer :=0; 
            ARGVALUE65       : integer :=0; 
            ARGVALUE66       : integer :=0; 
            ARGVALUE67       : integer :=0; 
            ARGVALUE68       : integer :=0; 
            ARGVALUE69       : integer :=0; 
            ARGVALUE70       : integer :=0; 
            ARGVALUE71       : integer :=0; 
            ARGVALUE72       : integer :=0; 
            ARGVALUE73       : integer :=0; 
            ARGVALUE74       : integer :=0; 
            ARGVALUE75       : integer :=0; 
            ARGVALUE76       : integer :=0; 
            ARGVALUE77       : integer :=0; 
            ARGVALUE78       : integer :=0; 
            ARGVALUE79       : integer :=0; 
            ARGVALUE80       : integer :=0; 
            ARGVALUE81       : integer :=0; 
            ARGVALUE82       : integer :=0; 
            ARGVALUE83       : integer :=0; 
            ARGVALUE84       : integer :=0; 
            ARGVALUE85       : integer :=0; 
            ARGVALUE86       : integer :=0; 
            ARGVALUE87       : integer :=0; 
            ARGVALUE88       : integer :=0; 
            ARGVALUE89       : integer :=0; 
            ARGVALUE90       : integer :=0; 
            ARGVALUE91       : integer :=0; 
            ARGVALUE92       : integer :=0; 
            ARGVALUE93       : integer :=0; 
            ARGVALUE94       : integer :=0; 
            ARGVALUE95       : integer :=0; 
            ARGVALUE96       : integer :=0; 
            ARGVALUE97       : integer :=0; 
            ARGVALUE98       : integer :=0; 
            ARGVALUE99       : integer :=0
           );
  port ( SYSCLK      : in   std_logic;
         SYSRSTN     : in   std_logic;
         HADDR       : out  std_logic_vector(31 downto 0);
         HCLK        : out  std_logic;
         HRESETN     : out  std_logic;
         -- AHB Interface
         HBURST      : out  std_logic_vector( 2 downto 0);
         HMASTLOCK   : out  std_logic;
         HPROT       : out  std_logic_vector( 3 downto 0);
         HSIZE       : out  std_logic_vector( 2 downto 0);
         HTRANS      : out  std_logic_vector( 1 downto 0);
         HWRITE      : out  std_logic;
         HWDATA      : out  std_logic_vector(31 downto 0);
         HRDATA      : in   std_logic_vector(31 downto 0);
         HREADY      : in   std_logic;
         HRESP       : in   std_logic;
         HSEL        : out  std_logic_vector(15 downto 0);
         INTERRUPT   : in   std_logic_vector(255 downto 0);
         --Control etc
         GP_OUT      : out  std_logic_vector(31 downto 0);
         GP_IN       : in   std_logic_vector(31 downto 0);
         EXT_WR      : out   std_logic;
         EXT_RD      : out   std_logic;
         EXT_ADDR    : out   std_logic_vector(31 downto 0);
         EXT_DATA    : inout std_logic_vector(31 downto 0);
         EXT_WAIT    : in    std_logic;
         FINISHED    : out  std_logic;
         FAILED      : out  std_logic
       );
end component;

component BFM_AHB2APB 
  generic ( TPD : integer range 0 to 1000 := 1);
  port ( HCLK        : in  std_logic;
         HRESETN     : in  std_logic;
         -- AHB Lite Interface
         HSEL        : in  std_logic;
         HWRITE      : in  std_logic;
         HADDR       : in  std_logic_vector( 31 downto 0);
         HWDATA      : in  std_logic_vector( 31 downto 0);
         HRDATA      : out std_logic_vector( 31 downto 0);
         HREADYIN    : in  std_logic;
         HREADYOUT   : out std_logic;
         HTRANS      : in  std_logic_vector(1 downto 0);
         HSIZE       : in  std_logic_vector(2 downto 0);
         HBURST      : in  std_logic_vector(2 downto 0);
         HMASTLOCK   : in  std_logic; 
         HPROT       : in  std_logic_vector(3 downto 0);
         HRESP       : out std_logic;
         -- APB Interface
         PSEL        : out std_logic_vector(15 downto 0);
         PADDR       : out std_logic_vector(31 downto 0);
         PWRITE      : out std_logic;
         PENABLE     : out std_logic;
         PWDATA      : out std_logic_vector(31 downto 0);
         PRDATA      : in  std_logic_vector(31 downto 0);
         PREADY      : in  std_logic;
         PSLVERR     : in  std_logic
       );
end component;

component BFM_AHBLAPB 
  generic ( VECTFILE         : string  := "test.vec";
            MAX_INSTRUCTIONS : integer := 16384;
            TPD              : integer range 0 to 1000 := 1;
            MAX_STACK        : integer := 1024;
			MAX_MEMTEST      : integer := 65536;
            DEBUGLEVEL       : integer range -1 to 5 := -1;
            ARGVALUE0        : integer :=0; 
            ARGVALUE1        : integer :=0; 
            ARGVALUE2        : integer :=0; 
            ARGVALUE3        : integer :=0; 
            ARGVALUE4        : integer :=0; 
            ARGVALUE5        : integer :=0; 
            ARGVALUE6        : integer :=0; 
            ARGVALUE7        : integer :=0; 
            ARGVALUE8        : integer :=0; 
            ARGVALUE9        : integer :=0;
            ARGVALUE10       : integer :=0; 
            ARGVALUE11       : integer :=0; 
            ARGVALUE12       : integer :=0; 
            ARGVALUE13       : integer :=0; 
            ARGVALUE14       : integer :=0; 
            ARGVALUE15       : integer :=0; 
            ARGVALUE16       : integer :=0; 
            ARGVALUE17       : integer :=0; 
            ARGVALUE18       : integer :=0; 
            ARGVALUE19       : integer :=0; 
            ARGVALUE20       : integer :=0; 
            ARGVALUE21       : integer :=0; 
            ARGVALUE22       : integer :=0; 
            ARGVALUE23       : integer :=0; 
            ARGVALUE24       : integer :=0; 
            ARGVALUE25       : integer :=0; 
            ARGVALUE26       : integer :=0; 
            ARGVALUE27       : integer :=0; 
            ARGVALUE28       : integer :=0; 
            ARGVALUE29       : integer :=0;
            ARGVALUE30       : integer :=0; 
            ARGVALUE31       : integer :=0; 
            ARGVALUE32       : integer :=0; 
            ARGVALUE33       : integer :=0; 
            ARGVALUE34       : integer :=0; 
            ARGVALUE35       : integer :=0; 
            ARGVALUE36       : integer :=0; 
            ARGVALUE37       : integer :=0; 
            ARGVALUE38       : integer :=0; 
            ARGVALUE39       : integer :=0; 
            ARGVALUE40       : integer :=0; 
            ARGVALUE41       : integer :=0; 
            ARGVALUE42       : integer :=0; 
            ARGVALUE43       : integer :=0; 
            ARGVALUE44       : integer :=0; 
            ARGVALUE45       : integer :=0; 
            ARGVALUE46       : integer :=0; 
            ARGVALUE47       : integer :=0; 
            ARGVALUE48       : integer :=0; 
            ARGVALUE49       : integer :=0; 
            ARGVALUE50       : integer :=0; 
            ARGVALUE51       : integer :=0; 
            ARGVALUE52       : integer :=0; 
            ARGVALUE53       : integer :=0; 
            ARGVALUE54       : integer :=0; 
            ARGVALUE55       : integer :=0; 
            ARGVALUE56       : integer :=0; 
            ARGVALUE57       : integer :=0; 
            ARGVALUE58       : integer :=0; 
            ARGVALUE59       : integer :=0; 
            ARGVALUE60       : integer :=0; 
            ARGVALUE61       : integer :=0; 
            ARGVALUE62       : integer :=0; 
            ARGVALUE63       : integer :=0; 
            ARGVALUE64       : integer :=0; 
            ARGVALUE65       : integer :=0; 
            ARGVALUE66       : integer :=0; 
            ARGVALUE67       : integer :=0; 
            ARGVALUE68       : integer :=0; 
            ARGVALUE69       : integer :=0; 
            ARGVALUE70       : integer :=0; 
            ARGVALUE71       : integer :=0; 
            ARGVALUE72       : integer :=0; 
            ARGVALUE73       : integer :=0; 
            ARGVALUE74       : integer :=0; 
            ARGVALUE75       : integer :=0; 
            ARGVALUE76       : integer :=0; 
            ARGVALUE77       : integer :=0; 
            ARGVALUE78       : integer :=0; 
            ARGVALUE79       : integer :=0; 
            ARGVALUE80       : integer :=0; 
            ARGVALUE81       : integer :=0; 
            ARGVALUE82       : integer :=0; 
            ARGVALUE83       : integer :=0; 
            ARGVALUE84       : integer :=0; 
            ARGVALUE85       : integer :=0; 
            ARGVALUE86       : integer :=0; 
            ARGVALUE87       : integer :=0; 
            ARGVALUE88       : integer :=0; 
            ARGVALUE89       : integer :=0; 
            ARGVALUE90       : integer :=0; 
            ARGVALUE91       : integer :=0; 
            ARGVALUE92       : integer :=0; 
            ARGVALUE93       : integer :=0; 
            ARGVALUE94       : integer :=0; 
            ARGVALUE95       : integer :=0; 
            ARGVALUE96       : integer :=0; 
            ARGVALUE97       : integer :=0; 
            ARGVALUE98       : integer :=0; 
            ARGVALUE99       : integer :=0
           );
  port ( SYSCLK      : in   std_logic;
         SYSRSTN     : in   std_logic;
         -- AHB Interface
         HCLK        : out  std_logic;
         HRESETN     : out  std_logic;
         HADDR       : out  std_logic_vector(31 downto 0);
         HBURST      : out  std_logic_vector( 2 downto 0);
         HMASTLOCK   : out  std_logic;
         HPROT       : out  std_logic_vector( 3 downto 0);
         HSIZE       : out  std_logic_vector( 2 downto 0);
         HTRANS      : out  std_logic_vector( 1 downto 0);
         HWRITE      : out  std_logic;
         HWDATA      : out  std_logic_vector(31 downto 0);
         HRDATA      : in   std_logic_vector(31 downto 0);
         HREADYIN    : in   std_logic;
         HREADYOUT   : out  std_logic;
         HRESP       : in   std_logic;
         HSEL        : out  std_logic_vector(15 downto 0);
         -- APB Interface
         PCLK        : out  std_logic;
         PRESETN     : out  std_logic;
         PADDR       : out  std_logic_vector(31 downto 0);
         PENABLE     : out  std_logic;
         PWRITE      : out  std_logic;
         PWDATA      : out  std_logic_vector(31 downto 0);
         PRDATA      : in   std_logic_vector(31 downto 0);
         PREADY      : in   std_logic;
         PSLVERR     : in   std_logic;
         PSEL        : out  std_logic_vector(15 downto 0);
         --Control etc
         INTERRUPT   : in   std_logic_vector(255 downto 0);
         GP_OUT      : out  std_logic_vector(31 downto 0);
         GP_IN       : in   std_logic_vector(31 downto 0);
         EXT_WR      : out   std_logic;
         EXT_RD      : out   std_logic;
         EXT_ADDR    : out   std_logic_vector(31 downto 0);
         EXT_DATA    : inout std_logic_vector(31 downto 0);
         EXT_WAIT    : in    std_logic;
         FINISHED    : out  std_logic;
         FAILED      : out  std_logic
       );
end component;

component BFM_APB 
  generic ( VECTFILE         : string  := "test.vec";
            MAX_INSTRUCTIONS : integer := 16384;
            TPD              : integer range 0 to 1000 := 1;
            MAX_STACK        : integer := 1024;
			MAX_MEMTEST      : integer := 65536;
            DEBUGLEVEL       : integer range -1 to 5 := -1;
            ARGVALUE0        : integer :=0; 
            ARGVALUE1        : integer :=0; 
            ARGVALUE2        : integer :=0; 
            ARGVALUE3        : integer :=0; 
            ARGVALUE4        : integer :=0; 
            ARGVALUE5        : integer :=0; 
            ARGVALUE6        : integer :=0; 
            ARGVALUE7        : integer :=0; 
            ARGVALUE8        : integer :=0; 
            ARGVALUE9        : integer :=0;
            ARGVALUE10       : integer :=0; 
            ARGVALUE11       : integer :=0; 
            ARGVALUE12       : integer :=0; 
            ARGVALUE13       : integer :=0; 
            ARGVALUE14       : integer :=0; 
            ARGVALUE15       : integer :=0; 
            ARGVALUE16       : integer :=0; 
            ARGVALUE17       : integer :=0; 
            ARGVALUE18       : integer :=0; 
            ARGVALUE19       : integer :=0; 
            ARGVALUE20       : integer :=0; 
            ARGVALUE21       : integer :=0; 
            ARGVALUE22       : integer :=0; 
            ARGVALUE23       : integer :=0; 
            ARGVALUE24       : integer :=0; 
            ARGVALUE25       : integer :=0; 
            ARGVALUE26       : integer :=0; 
            ARGVALUE27       : integer :=0; 
            ARGVALUE28       : integer :=0; 
            ARGVALUE29       : integer :=0;
            ARGVALUE30       : integer :=0; 
            ARGVALUE31       : integer :=0; 
            ARGVALUE32       : integer :=0; 
            ARGVALUE33       : integer :=0; 
            ARGVALUE34       : integer :=0; 
            ARGVALUE35       : integer :=0; 
            ARGVALUE36       : integer :=0; 
            ARGVALUE37       : integer :=0; 
            ARGVALUE38       : integer :=0; 
            ARGVALUE39       : integer :=0; 
            ARGVALUE40       : integer :=0; 
            ARGVALUE41       : integer :=0; 
            ARGVALUE42       : integer :=0; 
            ARGVALUE43       : integer :=0; 
            ARGVALUE44       : integer :=0; 
            ARGVALUE45       : integer :=0; 
            ARGVALUE46       : integer :=0; 
            ARGVALUE47       : integer :=0; 
            ARGVALUE48       : integer :=0; 
            ARGVALUE49       : integer :=0; 
            ARGVALUE50       : integer :=0; 
            ARGVALUE51       : integer :=0; 
            ARGVALUE52       : integer :=0; 
            ARGVALUE53       : integer :=0; 
            ARGVALUE54       : integer :=0; 
            ARGVALUE55       : integer :=0; 
            ARGVALUE56       : integer :=0; 
            ARGVALUE57       : integer :=0; 
            ARGVALUE58       : integer :=0; 
            ARGVALUE59       : integer :=0; 
            ARGVALUE60       : integer :=0; 
            ARGVALUE61       : integer :=0; 
            ARGVALUE62       : integer :=0; 
            ARGVALUE63       : integer :=0; 
            ARGVALUE64       : integer :=0; 
            ARGVALUE65       : integer :=0; 
            ARGVALUE66       : integer :=0; 
            ARGVALUE67       : integer :=0; 
            ARGVALUE68       : integer :=0; 
            ARGVALUE69       : integer :=0; 
            ARGVALUE70       : integer :=0; 
            ARGVALUE71       : integer :=0; 
            ARGVALUE72       : integer :=0; 
            ARGVALUE73       : integer :=0; 
            ARGVALUE74       : integer :=0; 
            ARGVALUE75       : integer :=0; 
            ARGVALUE76       : integer :=0; 
            ARGVALUE77       : integer :=0; 
            ARGVALUE78       : integer :=0; 
            ARGVALUE79       : integer :=0; 
            ARGVALUE80       : integer :=0; 
            ARGVALUE81       : integer :=0; 
            ARGVALUE82       : integer :=0; 
            ARGVALUE83       : integer :=0; 
            ARGVALUE84       : integer :=0; 
            ARGVALUE85       : integer :=0; 
            ARGVALUE86       : integer :=0; 
            ARGVALUE87       : integer :=0; 
            ARGVALUE88       : integer :=0; 
            ARGVALUE89       : integer :=0; 
            ARGVALUE90       : integer :=0; 
            ARGVALUE91       : integer :=0; 
            ARGVALUE92       : integer :=0; 
            ARGVALUE93       : integer :=0; 
            ARGVALUE94       : integer :=0; 
            ARGVALUE95       : integer :=0; 
            ARGVALUE96       : integer :=0; 
            ARGVALUE97       : integer :=0; 
            ARGVALUE98       : integer :=0; 
            ARGVALUE99       : integer :=0
           );
  port ( SYSCLK      : in    std_logic;
         SYSRSTN     : in    std_logic;
         -- APB Interface
         PCLK        : out   std_logic;
         PRESETN     : out   std_logic;
         PADDR       : out   std_logic_vector(31 downto 0);
         PENABLE     : out   std_logic;
         PWRITE      : out   std_logic;
         PWDATA      : out   std_logic_vector(31 downto 0);
         PRDATA      : in    std_logic_vector(31 downto 0);
         PREADY      : in    std_logic;
         PSLVERR     : in    std_logic;
         PSEL        : out   std_logic_vector(15 downto 0);
         --Control etc
         INTERRUPT   : in    std_logic_vector(255 downto 0);
         GP_OUT      : out   std_logic_vector(31 downto 0);
         GP_IN       : in    std_logic_vector(31 downto 0);
         EXT_WR      : out   std_logic;
         EXT_RD      : out   std_logic;
         EXT_ADDR    : out   std_logic_vector(31 downto 0);
         EXT_DATA    : inout std_logic_vector(31 downto 0);
         EXT_WAIT    : in    std_logic;
         FINISHED    : out   std_logic;
         FAILED      : out   std_logic
       );
end component;

component BFM_APB2APB 
  generic ( TPD     : integer range 0 to 1000 := 1
		  );
  port ( -- Primary APB Interface
         PCLK_PM       : in  std_logic;
         PRESETN_PM    : in  std_logic;
         PADDR_PM      : in  std_logic_vector(31 downto 0);
         PWRITE_PM     : in  std_logic;
         PENABLE_PM    : in  std_logic;
         PWDATA_PM     : in  std_logic_vector(31 downto 0);
         PRDATA_PM     : out std_logic_vector(31 downto 0);
         PREADY_PM     : out std_logic;
         PSLVERR_PM    : out std_logic;
         -- Secondary APB Interface
         PCLK_SC       : in  std_logic;
         PSEL_SC       : out std_logic_vector(15 downto 0);
         PADDR_SC      : out std_logic_vector(31 downto 0);
         PWRITE_SC     : out std_logic;
         PENABLE_SC    : out std_logic;
         PWDATA_SC     : out std_logic_vector(31 downto 0);
         PRDATA_SC     : in  std_logic_vector(31 downto 0);
         PREADY_SC     : in  std_logic;
         PSLVERR_SC    : in  std_logic
       );
end component;


end bfm_package;




package body bfm_package is 

function to_int( xlv : std_logic_vector ) return integer is
variable x : integer;
begin
   x:= to_integer(to_signed(xlv));
   return(x);
end to_int;

function to_int_unsigned( xlv : std_logic_vector ) return integer is
variable x : integer;
begin
   x:= to_integer(to_unsigned(xlv));
   return(x);
end to_int_unsigned;

function to_int_signed( xlv : std_logic_vector ) return integer is
variable x : integer;
begin
   x:= to_integer(to_signed(xlv));
   return(x);
end to_int_signed;


function to_slv32( x : integer ) return std_logic_vector is
variable xlv : std_logic_vector(31 downto 0);
begin
   xlv := to_std_logic(to_signed(x,32));
   return(xlv);
end to_slv32;



function align_data( size   : std_logic_vector(2 downto 0);
                     addr10 : std_logic_vector(1 downto 0);
                     datain : std_logic_vector(31 downto 0);
					 alignmode : integer
                    ) return std_logic_vector is
variable adata : std_logic_vector(31 downto 0);
variable addr1 : std_logic;
begin
 adata := ( others => '0');
 addr1 := addr10(1);
 case alignmode is
   when 0 => -- Normal operation, data is correctly aligned for a 32 bit bus 
            case size is
                when "000" => case addr10 is
                                when "00" => adata(7 downto 0)   := datain(7 downto 0);
                                when "01" => adata(15 downto 8)  := datain(7 downto 0);
                                when "10" => adata(23 downto 16) := datain(7 downto 0);
                                when "11" => adata(31 downto 24) := datain(7 downto 0);
                                when others =>
                              end case;
                when "001" => case addr10 is
                                when "00"  => adata(15 downto 0)   := datain(15 downto 0);
                                when "01"  => adata(15 downto 0)   := datain(15 downto 0);
								                assert FALSE report "BFM: Missaligned AHB Cycle(Half A10=01) ?" severity WARNING;
                                when "10"  => adata(31 downto 16)  := datain(15 downto 0);
                                when "11"  => adata(31 downto 16)  := datain(15 downto 0);
								                assert FALSE report "BFM: Missaligned AHB Cycle(Half A10=11) ?" severity WARNING;
                                when others =>
                              end case;
                when "010" => adata := datain;
				  				case addr10 is
                                when "00"  => 
                                when "01"  => assert FALSE report "BFM: Missaligned AHB Cycle(Word A10=01) ?" severity WARNING;
                                when "10"  => assert FALSE report "BFM: Missaligned AHB Cycle(Word A10=10) ?" severity WARNING;
                                when "11"  => assert FALSE report "BFM: Missaligned AHB Cycle(Word A10=11) ?" severity WARNING;
                                when others =>
                              end case;
                when others => assert FALSE report "Unexpected AHB Size setting" severity ERROR;
             end case;
   when 1 => -- Normal operation, data is correctly aligned for a 16 bit bus 
            case size is
                when "000" => case addr10 is
                                when "00" => adata(7 downto 0)   := datain(7 downto 0);
                                when "01" => adata(15 downto 8)  := datain(7 downto 0);
                                when "10" => adata(7 downto 0)   := datain(7 downto 0);
                                when "11" => adata(15 downto 8)  := datain(7 downto 0);
                                when others =>
                              end case;
                when "001" => adata(15 downto 0) := datain(15 downto 0);
				              case addr10 is
                                when "00"  => 
                                when "01"  => assert FALSE report "BFM: Missaligned AHB Cycle(Half A10=01) ?" severity WARNING;
                                when "10"  => assert FALSE report "BFM: Missaligned AHB Cycle(Half A10=10) ?" severity WARNING;
                                when "11"  => assert FALSE report "BFM: Missaligned AHB Cycle(Half A10=11) ?" severity WARNING;
                                when others =>
                              end case;
                when others => assert FALSE report "Unexpected AHB Size setting" severity ERROR;
             end case;
   when 2 => -- Normal operation, data is correctly aligned for a 8 bit bus 
		     case size is
               when "000" =>  adata(7 downto 0) := datain(7 downto 0);
               when others => assert FALSE report "Unexpected AHB Size setting" severity ERROR;
             end case;
   when 8 => -- No alignment takes place
             adata := datain;
   when others => assert FALSE report "Illegal Alignment mode" severity ERROR;
 end case;
 return(adata);
end align_data;


function align_mask( size   : std_logic_vector(2 downto 0);
                     addr10 : std_logic_vector(1 downto 0);
                     datain : std_logic_vector(31 downto 0);
					 alignmode : integer
                    ) return std_logic_vector is
variable adata : std_logic_vector(31 downto 0);
begin
  adata := align_data(size,addr10,datain,alignmode);
  return(adata);
end align_mask;


function align_read( size   : std_logic_vector(2 downto 0);
                     addr10 : std_logic_vector(1 downto 0);
                     datain : std_logic_vector(31 downto 0);
					 alignmode : integer
                    ) return std_logic_vector is
variable adata : std_logic_vector(31 downto 0);
variable addr1 : std_logic;
begin
 if alignmode=8 then
   adata := datain;
 else
   --NOTE THIS IS NOT CODED TO SUPPORT 8 AND 16 BIT BUSES
   adata := ( others => '0');
   addr1 := addr10(1);
   case size is
     when "000" => case addr10 is
                     when "00" => adata(7 downto 0) := datain( 7 downto 0 );
                     when "01" => adata(7 downto 0) := datain(15 downto 8 );
                     when "10" => adata(7 downto 0) := datain(23 downto 16);
                     when "11" => adata(7 downto 0) := datain(31 downto 24);
                     when others =>
                   end case;
     when "001" => case addr1 is
                     when '0'  => adata(15 downto 0) := datain(15 downto 0);
                     when '1'  => adata(15 downto 0) := datain(31 downto 16);
                     when others =>
                   end case;
     when "010" => adata   := datain;
     when others => assert FALSE report "Unexpected AHB Size setting" severity ERROR;
   end case;
 end if;
 return(adata);
end align_read;



function to_ascii( x : integer ) return character is
variable c  : character;
begin
  c := CHARACTER'VAL(x);
  return(c);
end to_ascii;



function to_char(size : integer) return character is
variable c : character;
begin
 case size is   
   when 0 => c := 'b';
   when 1 => c := 'h';
   when 2 => c := 'w';
   when 3 => c := 'x';
   when others => c := '?';
 end case;
 return(c);
end to_char;

function to_char(size : std_logic_vector) return character is
variable c : character;
variable sz : std_logic_vector(2 downto 0);
begin
 sz := size(2 downto 0);
 case sz is   
   when "000" => c := 'B';
   when "001" => c := 'H';
   when "010" => c := 'W';
   when "011" => c := 'X';
   when others => c := '?';
 end case;
 return(c);
end to_char;


function address_increment(size : integer; xainc : integer) return integer is
variable c : integer;
begin
 case size is   
   when 0   => c := 1;
   when 1   => c := 2;
   when 2   => c := 4;
   when 3   => c := xainc;
   when others => c := 0;
 end case;
 return(c);
end address_increment;


function xfer_size(size : integer;  xsize: integer) return std_logic_vector is
variable c : std_logic_vector(2 downto 0);
begin
 case size is   
   when 0   => c := "000";
   when 1   => c := "001";
   when 2   => c := "010";
   when 3   => c := to_std_logic(to_unsigned(xsize,3));
   when others => c := "XXX";
 end case;
 return(c);
end xfer_size;


function calculate( op: integer; x,y : integer; debug : integer) return integer is
variable Z : integer;
variable XS, YS, ZS : signed(31 downto 0);
variable YI : integer;
variable ZZS : signed(63 downto 0);
constant ZERO : signed(31 downto 0) := ( others => '0');
constant ONE  : signed(31 downto 0) := ( 0 => '1', others => '0');
begin
  XS := to_signed(X,32);
  YS := to_signed(Y,32);
  YI := Y;
  ZS := ( others => '0');
  case op is
    when OP_NONE=>  ZS := (others => '0');
    when OP_ADD =>  ZS := XS + YS;
    when OP_SUB =>  ZS := XS - YS;
    when OP_MULT=>  ZZS := XS * YS;
                    ZS := ZZS(31 downto 0);
    when OP_DIV =>  ZS := XS / YS;
    when OP_AND =>  ZS := XS AND YS;
    when OP_OR  =>  ZS := XS OR  YS;
    when OP_XOR =>  ZS := XS XOR YS;
    when OP_CMP =>  ZS := XS XOR YS;
    when OP_SHR =>  if YI=0 then
                      ZS := XS;
                    else
                      ZS := ZERO(YI downto 1) & XS(31 downto YI); 
                    end if;
    when OP_SHL =>  if YI=0 then
                      ZS := XS;
                    else
                      ZS := XS(31-YI downto 0) & ZERO(YI downto 1);
                    end if;
    when OP_POW =>  ZZS :=ZERO & ONE;
                    if YI>0 then
                      for i in 1 to YI loop 
                        ZZS := ZZS(31 downto 0) * XS;
                      end loop;
                    end if;
                    ZS := ZZS(31 downto 0);
    when OP_EQ  =>  if XS=YS  then ZS := ONE; end if;
    when OP_NEQ =>  if XS/=YS then ZS := ONE; end if;
    when OP_GR  =>  if XS>YS  then ZS := ONE; end if;
    when OP_LS  =>  if XS<YS  then ZS := ONE; end if;
    when OP_GRE =>  if XS>=YS then ZS := ONE; end if;
    when OP_LSE =>  if XS<=YS then ZS := ONE; end if;
    when OP_MOD =>  ZS := XS mod YS;
	when OP_SETB => if Y<=31 then
	                  ZS := XS;
					  ZS(Y) := '1';
					else
				      assert false report "Bit operation on bit >31" severity FAILURE;
					end if; 
	when OP_CLRB => if Y<=31 then
	                  ZS := XS;
					  ZS(Y) := '0';
					else
				      assert false report "Bit operation on bit >31" severity FAILURE;
					end if; 
	when OP_INVB => if Y<=31 then
	                  ZS := XS;
					  ZS(Y) := not ZS(Y);
					else
				      assert false report "Bit operation on bit >31" severity FAILURE;
					end if; 
	when OP_TSTB => if Y<=31 then
	                  ZS := ( others => '0');
					  ZS(0) := XS(Y);
					else
				      assert false report "Bit operation on bit >31" severity FAILURE;
					end if; 
    when others =>  assert false report "Illegal Maths Operator" severity FAILURE;
  end case;
  Z := to_integer(ZS);
  if (debug>=4) then
    printf("Calculated %d = %d (%d) %d",fmt(Z)&fmt(X)&fmt(op)&fmt(Y));
  end if;
  return(Z);
end calculate;   
   
function clean( x : std_logic_vector ) return std_logic_vector is
variable tmp : std_logic_vector(x'range);
begin
  tmp := x;
  tmp := ( others => '0');
  for i in tmp'range loop
    if x(i)='1' then
      tmp(i) := '1';
    end if;
  end loop;
  return(tmp);
end clean;
  
function  len_string( len : integer) return integer is
variable nparas : integer;
variable nchars : integer;
variable n : integer;
begin
  nchars := len / 65536;
  nparas := len  rem 65536;
  n := 2+nparas+ 1+((nchars-1)/4);
  return(n);
end len_string;


function extract_string(cptr: integer; vectors : INTEGER_ARRAY; command : INTEGER_ARRAY) return string is
variable pstr : string(1 to 256);
variable str  : string(1 to 256);
variable i,p,j : integer;
variable tmp_un : unsigned(31 downto 0);
variable nparas : integer;
variable nchars : integer;
variable len    : integer;
begin
  nchars := vectors(cptr+1)/65536;
  nparas := vectors(cptr+1) rem 65536;
  len    :=2+nparas+ 1+((nchars-1)/4);
 -- printf("Str nparas %d nchars %d PARA1 %08x length %d",fmt(nparas)&fmt(nchars)&fmt( vectors(cptr+1))&fmt(len));
  i:=cptr+2+nparas; j:=3;
  for p in 1 to nchars loop
    tmp_un := to_unsigned(vectors(i),32);
    pstr(p) := to_ascii( to_integer(tmp_un(j*8+7 downto j*8+0))); 
    if j=0 then
      i:=i+1; j:=4;
    end if;
    j:=j-1;
  end loop;
  pstr(nchars+1) := NUL;
  case nparas is
    when 0 => sprintf(str,pstr);
    when 1 => sprintf(str,pstr,fmt(command(2)));
    when 2 => sprintf(str,pstr,fmt(command(2))&fmt(command(3)));
    when 3 => sprintf(str,pstr,fmt(command(2))&fmt(command(3))&fmt(command(4)));
    when 4 => sprintf(str,pstr,fmt(command(2))&fmt(command(3))&fmt(command(4))&fmt(command(5)));
    when 5 => sprintf(str,pstr,fmt(command(2))&fmt(command(3))&fmt(command(4))&fmt(command(5))&fmt(command(6)));
    when 6 => sprintf(str,pstr,fmt(command(2))&fmt(command(3))&fmt(command(4))&fmt(command(5))&fmt(command(6))&fmt(command(7)));
    when 7 => sprintf(str,pstr,fmt(command(2))&fmt(command(3))&fmt(command(4))&fmt(command(5))&fmt(command(6))&fmt(command(7))&fmt(command(8)));
    when others => assert FALSE report "String Error" severity FAILURE;	  	  
  end case;																			  
  																					  
  return(str);
end extract_string;


function get_line(lineno,x : integer) return integer is
variable ln,fn : integer;
begin
 fn := lineno/x;
 ln := lineno - fn*x;
 return(ln); 
end get_line;

function get_file(lineno,x : integer) return integer is
variable ln,fn : integer;
begin
 fn := lineno/x;
 ln := lineno - fn*x;
 return(fn); 
end get_file;


function random( seed : integer) return integer is
variable d      : std_logic;
variable xrand   : integer;
variable regx   : std_logic_vector(31 downto 0);
variable regy   : std_logic_vector(31 downto 0);
begin
     regx := to_slv32(seed);
 	 d := '1';
	 
     regy(0)  := d xor regx(31);
     regy(1)  := d xor regx(31) xor regx(0);
     regy(2)  := d xor regx(31) xor regx(1);
     regy(3)  := regx(2);
     regy(4)  := d xor regx(31) xor regx(3);
     regy(5)  := d xor regx(31) xor regx(4);
     regy(6)  := regx(5);
     regy(7)  := d xor regx(31) xor regx(6);
     regy(8)  := d xor regx(31) xor regx(7);
     regy(9)  := regx(8);
     regy(10) := d xor regx(31) xor regx(9);
     regy(11) := d xor regx(31) xor regx(10);
     regy(12) := d xor regx(31) xor regx(11);
     regy(13) := regx(12);
     regy(14) := regx(13);
     regy(15) := regx(14);
     regy(16) := d xor regx(31) xor regx(15);
     regy(17) := regx(16);
     regy(18) := regx(17);
     regy(19) := regx(18);
     regy(20) := regx(19);
     regy(21) := regx(20);
     regy(22) := d xor regx(31) xor regx(21);
     regy(23) := d xor regx(31) xor regx(22);
     regy(24) := regx(23);
     regy(25) := regx(24);
     regy(26) := d xor regx(31) xor regx(25);
     regy(27) := regx(26);
     regy(28) := regx(27);
     regy(29) := regx(28);
     regy(30) := regx(29);
     regy(31) := regx(30);

 	 xrand := to_int_signed(regy);
	 return(xrand);
end random; 
 
function mask_randomN( seed :integer ; size : integer) return integer is
variable xrand   : integer;
variable regx   : std_logic_vector(31 downto 0);
begin
  regx := to_slv32(seed);
  if (size<31) then
    regx(31 downto size) := ( others => '0');
  end if;
  xrand := to_int_signed(regx);
  return(xrand);
end mask_randomN;
 
function mask_randomS( seed :integer ; size : integer) return integer is
variable xrand   : integer;
variable regx   : std_logic_vector(31 downto 0);
variable sn     : integer;
begin
  case size is
    when 1     => sn :=0;
    when 2     => sn :=1;
    when 4     => sn :=2;
    when 8     => sn :=3;
    when 16    => sn :=4;
    when 32    => sn :=5;
    when 64    => sn :=6;
    when 128   => sn :=7;
    when 256   => sn :=8;
    when 512   => sn :=9;
    when 1024  => sn :=10;
    when 2048  => sn :=11;
    when 4096  => sn :=12;
    when 8192  => sn :=13;
    when 16384 => sn :=14;
    when 32768 => sn :=15;
    when 65536 => sn :=16;
    when 131072   => sn := 17;
    when 262144   => sn := 18;
    when 524288   => sn := 19;
    when 1048576  => sn := 20;
    when 2097152  => sn := 21;
    when 4194304  => sn := 22;
    when 8388608  => sn := 23;
    when 16777216 => sn := 24;
    when 33554432 => sn := 25;
    when 67108864 => sn := 26;
    when 134217728  => sn := 27;
    when 268435456  => sn := 28;
    when 536870912  => sn := 29;
    when 1073741824 => sn := 30;
    when others => assert FALSE report "Random function error" severity FAILURE;
  end case;	
  regx := to_slv32(seed);
  if (sn<31) then
    regx(31 downto sn) := ( others => '0');
  end if;
  xrand := to_int_signed(regx);
  return(xrand);
end mask_randomS;


function bound1k ( bmode: integer; addr : std_logic_vector) return boolean is
variable boundary : boolean;
begin
  boundary := FALSE;
  case bmode is
   when 0 => if addr(9 downto 0)="0000000000" then
               boundary :=TRUE;
             end if;
   when 1 => boundary := TRUE;
   when 2 => -- return FALSE
   when others => assert FALSE report "Illegal Burst Boundary Set" severity FAILURE;
  end case; 
  return(boundary);
end bound1k;



end bfm_package;



