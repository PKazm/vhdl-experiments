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
-- 18Dec08  Updated for 1.5 functionality
-- 18Feb08  Updated for 1.6 functionality
-- 08May08  2.0 for Soft IP Usage
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
-- Release 2.0
--   Soft IP Release of Internal Hard IP Models
-- Release 2.1
--   Added else and case support
--

-- Requested Enhancements
--   Ability to do back-to-back single cycle checking of the IO_IN inputs 
-- 
--
--
-- *********************************************************************/ 

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

use work.bfm_textio.all;
use work.bfm_misc.all;
use work.bfm_package.all;
use std.textio.all;


entity BFM_MAIN is
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
end BFM_MAIN;


architecture BFM of BFM_MAIN is

constant BFM_VERSION : string(1 to 3) := "2.1";
constant BFM_DATE    : string(1 to 7) := "22Dec08";



signal  SCLK            : std_logic;
signal  HRESETN_P0      : std_logic;
signal  HBURST_P0       : std_logic_vector( 2 downto 0);
signal  HMASTLOCK_P0    : std_logic;
signal  HPROT_P0        : std_logic_vector( 3 downto 0);
signal  HTRANS_P0       : std_logic_vector( 1 downto 0);
signal  HWRITE_P0       : std_logic;
signal  HWDATA_P0       : std_logic_vector(31 downto 0);

signal  HADDR_P0        : std_logic_vector(31 downto 0) := ( others => '0');
signal  HADDR_P1        : std_logic_vector(31 downto 0) := ( others => '0');
signal  HSIZE_P0        : std_logic_vector(2 downto 0);
signal  HSIZE_P1        : std_logic_vector(2 downto 0);
signal  HSEL_P0         : std_logic_vector(15 downto 0);

signal  WRITE_P1        : std_logic;
signal  WRITE_P0        : std_logic;
signal  READ_P0         : std_logic;
signal  READ_P1         : std_logic;
signal  POLL_P0         : std_logic;
signal  POLL_P1         : std_logic;
signal  RDCHK_P0        : std_logic;
signal  RDCHK_P1        : std_logic;
signal  RDATA_P0        : std_logic_vector(31 downto 0);
signal  MDATA_P0        : std_logic_vector(31 downto 0);
signal  WDATA_P0        : std_logic_vector(31 downto 0);
signal  RDATA_P1        : std_logic_vector(31 downto 0);
signal  MDATA_P1        : std_logic_vector(31 downto 0);
signal  WDATA_P1        : std_logic_vector(31 downto 0);
        
signal  EIO_RDATA_P0    : std_logic_vector(31 downto 0);
signal  EIO_MDATA_P0    : std_logic_vector(31 downto 0);
signal  EIO_LINENO_P0   : integer;
signal  EIO_RDCHK_P0    : std_logic;
signal  EIO_RDCHK_P1    : std_logic;
signal  EIO_RDATA_P1    : std_logic_vector(31 downto 0);
signal  EIO_MDATA_P1    : std_logic_vector(31 downto 0);
signal  EIO_LINENO_P1   : integer;

signal  EXTWR_P0        : std_logic;
signal  EXTRD_P0        : std_logic;
signal  EXTRD_P1        : std_logic;
signal  GPIORD_P0       : std_logic;
signal  GPIOWR_P0       : std_logic;

signal  EXT_DIN         : std_logic_vector(31 downto 0);
signal  EXT_DOUT        : std_logic_vector(31 downto 0);
signal  EXTADDR_P0      : std_logic_vector(31 downto 0);
signal  EXTADDR_P1      : std_logic_vector(31 downto 0);

signal  CON_DIN         : std_logic_vector(31 downto 0);
signal  CON_DOUT        : std_logic_vector(31 downto 0);
signal  CON_RDP1        : std_logic;
signal  CON_WRP1        : std_logic;

signal  DEBUG           : integer;
signal  LINENO_P0       : integer;
signal  LINENO_P1       : integer;
signal  HCLK_STOP       : std_logic := '0';

signal  GPOUT_P0        : std_logic_vector(31 downto 0);
signal  FILENAME        : string(1 to 80);
    
signal  FINISHED_P0     : std_logic;
signal  FAILED_P0       : std_logic;
    
signal DRIVEX_CLK       : boolean;
signal DRIVEX_RST       : boolean;
signal DRIVEX_ADD       : boolean;    
signal DRIVEX_DAT       : boolean;
           
constant ZEROLV         : std_logic_vector(31 downto 0)  := ( others => '0');
constant ZERO256        : std_logic_vector(255 downto 0) := ( others => '0');

constant TPDns : time := TPD * 1 ns;

begin
 
    
SCLK    <= SYSCLK;
 
-- NOTE THIS IS IN ONE HUGE PROCESS FOR SIMULATION PERFORMANCE REASONS 
    
BFM:
process(SCLK,SYSRSTN)
file FSTR   : text; 
file FLOG   : text; 
subtype STR256    is STRING (1 to 256);
type THRESP_STATE is ( OK1,OK2);          
type STRING_ARRAY is array ( INTEGER range <>) of STR256; 
variable L                : LINE;
variable FSTATUS          : FILE_OPEN_STATUS;
variable initdone         : boolean;
variable command          : integer_array(0 to MAX_INSTRUCTIONS-1);
variable commandLV        : slv32_array(0 to MAX_INSTRUCTIONS-1);
variable vectors          : integer_array(0 to MAX_INSTRUCTIONS-1) := ( others => 0);
variable stack            : integer_array(0 to MAX_STACK-1);
variable Loopcmd          : integer_array(0 to 4);
variable Nvectors         : integer;
variable cptr             : integer;
variable lptr             : integer;
variable fptr             : integer;
variable stkptr           : integer;
variable loopcounter      : integer;
variable command0         : std_logic_vector(31 downto 0);
variable cmd_size         : integer range 0 to 3;
variable cmd_cmd          : integer;
variable cmd_cmdx4        : integer;
variable cmd_scmd         : integer;
variable command_length   : integer;
variable cmd_lineno       : integer;
variable command_timeout  : integer;
variable command_size     : std_logic_vector(2 downto 0);
variable command_address  : std_logic_vector(31 downto 0);
variable command_data     : std_logic_vector(31 downto 0);
variable command_mask     : std_logic_vector(31 downto 0);
variable do_case          : boolean;
variable do_read          : boolean;
variable do_bwrite        : boolean;
variable do_bread         : boolean;
variable do_write         : boolean;
variable do_poll          : boolean;
variable do_flush         : boolean;
variable do_idle          : boolean;
variable do_io            : boolean;
variable cmd_active       : boolean;
variable last_match       : boolean;
variable wait_counter     : integer;
variable bitn             : integer;
variable timer            : integer;
variable n                : integer;
variable i                : integer;
variable j                : integer;
variable x                : integer;
variable y                : integer;
variable v                : integer;
variable str              : string(1 to 256);
variable logstr           : string(1 to 256);
variable logfile          : string(1 to 256);
variable burst_address    : integer;
variable burst_length     : integer;
variable burst_count      : integer;
variable burst_addrinc    : integer;
variable burst_data       : integer_array(0 to 8191);
variable istr             : string( 1 to 8);
variable bfm_done         : boolean;
variable filedone         : boolean;
variable ch               : character;
variable tableid          : integer;
variable characters       : integer;
variable int_vector       : integer;
variable call_address     : integer;
variable return_address   : integer;
variable return_value     : integer;
variable jump_address     : integer;
variable nparas           : integer;
variable data_start       : integer;
variable data_inc         : integer;
variable hresp_mode       : integer;
variable bfm_mode         : integer;
variable instruct_cycles  : integer := 0;
variable instuct_count    : integer := 0;
variable setvar           : integer;
variable newvalue         : integer;
variable EXP              : std_logic_vector(31 downto 0);
variable GOT              : std_logic_vector(31 downto 0);
variable DATA_MATCH_AHB   : boolean;
variable DATA_MATCH_EXT   : boolean;
variable DATA_MATCH_IO    : boolean;
variable hresp_occured    : boolean;
variable HRESP_STATE      : THRESP_STATE;
variable ERRORS           : integer := 0;
variable tmpstr           : string (1 to 10);
variable ahb_lock         : std_logic;
variable ahb_prot         : std_logic_vector(3 downto 0);
variable ahb_burst        : std_logic_vector(2 downto 0);
variable storeaddr        : integer;
variable piped_activity   : boolean;
variable ahb_activity     : boolean;
variable filenames        : string_array(0 to 100);
variable NFILES           : integer := 0;
variable filemult         : integer := 65536;
variable su_xsize         : integer range 0 to 3;
variable su_xainc         : integer range 0 to 32;
variable su_xrate         : integer range 0 to 65536;
variable su_flush         : boolean;
variable su_noburst       : integer;
variable su_align         : integer;
variable bfm_run          : boolean;
variable bfm_single       : boolean;
variable int_active       : boolean;
variable count_xrate      : integer;
variable insert_busy      : boolean;
variable log_ahb          : boolean;
variable log_ext          : boolean;
variable log_gpio         : boolean;
variable log_bfm          : boolean;
variable bfmc_version     : integer;
variable cmpvalue         : integer;
variable vectors_version  : integer;
variable wait_time        : integer;
variable lastrandom       : integer;
variable setrandom        : integer;
variable reset_pulse      : integer :=0;
variable ahbc_hwrite      : std_logic;
variable ahbc_htrans      : std_logic_vector(1 downto 0);  
variable ahbc_burst       : std_logic_vector(2 downto 0); 
variable ahbc_lock        : std_logic; 
variable ahbc_prot        : std_logic_vector(3 downto 0); 
variable var_ltimer       : integer :=0;
variable var_licycles     : integer :=0;
variable passed           : integer_array(0 to 15);
variable npass            : integer;
variable returnstk        : integer_array(0 to 255);
variable wptr_cstk        : integer range 0 to 256;
variable rptr_cstk        : integer range 0 to 256;

variable  casedone        : boolean_array(1 to 255);
variable  casedepth       : integer range 0 to 256;


variable instructions_timer : integer;
type Tmtstate is (idle,init,active,done,fill,scan);
variable  mt_addr    : integer;
variable  mt_size    : integer;
variable  mt_align   : integer;
variable  mt_cycles  : integer;
variable  mt_seed    : integer;
variable  mt_state   : Tmtstate;
variable  mt_image   : integer_array(0 to MAX_MEMTEST-1);
variable  mt_ad      : integer;
variable  mt_op      : integer;
variable  mt_base    : integer;
variable  mt_base2   : integer;
variable  mt_readok  : boolean;
variable  mt_reads   : integer;
variable  mt_writes  : integer;
variable  mt_nops    : integer;
variable  zerocycle  : boolean;
variable  mt_dual    : boolean;
variable  mt_fill    : boolean;
variable  mt_scan    : boolean;
variable  mt_restart : boolean;
variable  mt_fillad  : integer;
variable  su_endsim  : integer;


impure function get_para_value( isvar : boolean; x : integer) return integer is
variable y     : integer;
variable x30x16: integer;
variable x14x13: integer;
variable x12x0 : integer;
variable x12x8 : integer;
variable x7x0  : integer;
variable xlv   : std_logic_vector(31 downto 0);
variable offset : integer;
begin
  if isvar then
     xlv    := to_slv32(x);
     x30x16 := to_int_unsigned(xlv(30 downto 16));
     x14x13 := to_int_unsigned(xlv(14 downto 13));
     x12x0  := to_int_unsigned(xlv(12 downto  0));
     x12x8  := to_int_unsigned(xlv(12 downto  8));
     x7x0   := to_int_unsigned(xlv( 7 downto  0));
     offset :=0;
     if xlv(15)='1' then -- ARRAY offset in upper 16 bits
       offset := get_para_value(TRUE,x30x16);
     end if;
     case x14x13 is  
       when 3 => case x12x8 is          -- E_CONST
                   when D_NORMAL    => case x7x0 is
                                         when D_RETVALUE  => y := return_value;
                                         when D_TIME      => y := ( NOW / 1 ns );
                                         when D_DEBUG     => y := DEBUG;
                                         when D_LINENO    => y := cmd_lineno;
                                         when D_ERRORS    => y := ERRORS;
                                         when D_TIMER     => y := instructions_timer-1;
                                         when D_LTIMER    => y := var_ltimer;
                                         when D_LICYCLES  => y := var_licycles;
                                         when others => assert FALSE report "Illegal Parameter P0" severity FAILURE;
                                       end case;
                   when D_ARGVALUE  => case x7x0 is
                                         when 0  => y := ARGVALUE0;
                                         when 1  => y := ARGVALUE1;
                                         when 2  => y := ARGVALUE2;
                                         when 3  => y := ARGVALUE3;
                                         when 4  => y := ARGVALUE4;
                                         when 5  => y := ARGVALUE5;
                                         when 6  => y := ARGVALUE6;
                                         when 7  => y := ARGVALUE7;
                                         when 8  => y := ARGVALUE8;
                                         when 9  => y := ARGVALUE9;
                                         when 10 => y := ARGVALUE10;
                                         when 11 => y := ARGVALUE11;
                                         when 12 => y := ARGVALUE12;
                                         when 13 => y := ARGVALUE13;
                                         when 14 => y := ARGVALUE14;
                                         when 15 => y := ARGVALUE15;
                                         when 16 => y := ARGVALUE16;
                                         when 17 => y := ARGVALUE17;
                                         when 18 => y := ARGVALUE18;
                                         when 19 => y := ARGVALUE19;
                                         when 20 => y := ARGVALUE20;
                                         when 21 => y := ARGVALUE21;
                                         when 22 => y := ARGVALUE22;
                                         when 23 => y := ARGVALUE23;
                                         when 24 => y := ARGVALUE24;
                                         when 25 => y := ARGVALUE25;
                                         when 26 => y := ARGVALUE26;
                                         when 27 => y := ARGVALUE27;
                                         when 28 => y := ARGVALUE28;
                                         when 29 => y := ARGVALUE29;
                                         when 30 => y := ARGVALUE30;
                                         when 31 => y := ARGVALUE31;
                                         when 32 => y := ARGVALUE32;
                                         when 33 => y := ARGVALUE33;
                                         when 34 => y := ARGVALUE34;
                                         when 35 => y := ARGVALUE35;
                                         when 36 => y := ARGVALUE36;
                                         when 37 => y := ARGVALUE37;
                                         when 38 => y := ARGVALUE38;
                                         when 39 => y := ARGVALUE39;
                                         when 40 => y := ARGVALUE40;
                                         when 41 => y := ARGVALUE41;
                                         when 42 => y := ARGVALUE42;
                                         when 43 => y := ARGVALUE43;
                                         when 44 => y := ARGVALUE44;
                                         when 45 => y := ARGVALUE45;
                                         when 46 => y := ARGVALUE46;
                                         when 47 => y := ARGVALUE47;
                                         when 48 => y := ARGVALUE48;
                                         when 49 => y := ARGVALUE49;
                                         when 50 => y := ARGVALUE50;
                                         when 51 => y := ARGVALUE51;
                                         when 52 => y := ARGVALUE52;
                                         when 53 => y := ARGVALUE53;
                                         when 54 => y := ARGVALUE54;
                                         when 55 => y := ARGVALUE55;
                                         when 56 => y := ARGVALUE56;
                                         when 57 => y := ARGVALUE57;
                                         when 58 => y := ARGVALUE58;
                                         when 59 => y := ARGVALUE59;
                                         when 60 => y := ARGVALUE60;
                                         when 61 => y := ARGVALUE61;
                                         when 62 => y := ARGVALUE62;
                                         when 63 => y := ARGVALUE63;
                                         when 64 => y := ARGVALUE64;
                                         when 65 => y := ARGVALUE65;
                                         when 66 => y := ARGVALUE66;
                                         when 67 => y := ARGVALUE67;
                                         when 68 => y := ARGVALUE68;
                                         when 69 => y := ARGVALUE69;
                                         when 70 => y := ARGVALUE70;
                                         when 71 => y := ARGVALUE71;
                                         when 72 => y := ARGVALUE72;
                                         when 73 => y := ARGVALUE73;
                                         when 74 => y := ARGVALUE74;
                                         when 75 => y := ARGVALUE75;
                                         when 76 => y := ARGVALUE76;
                                         when 77 => y := ARGVALUE77;
                                         when 78 => y := ARGVALUE78;
                                         when 79 => y := ARGVALUE79;
                                         when 80 => y := ARGVALUE80;
                                         when 81 => y := ARGVALUE81;
                                         when 82 => y := ARGVALUE82;
                                         when 83 => y := ARGVALUE83;
                                         when 84 => y := ARGVALUE84;
                                         when 85 => y := ARGVALUE85;
                                         when 86 => y := ARGVALUE86;
                                         when 87 => y := ARGVALUE87;
                                         when 88 => y := ARGVALUE88;
                                         when 89 => y := ARGVALUE89;
                                         when 90 => y := ARGVALUE90;
                                         when 91 => y := ARGVALUE91;
                                         when 92 => y := ARGVALUE92;
                                         when 93 => y := ARGVALUE93;
                                         when 94 => y := ARGVALUE94;
                                         when 95 => y := ARGVALUE95;
                                         when 96 => y := ARGVALUE96;
                                         when 97 => y := ARGVALUE97;
                                         when 98 => y := ARGVALUE98;
                                         when 99 => y := ARGVALUE99;
                                         when others => assert FALSE report "Illegal Parameter P1" severity FAILURE;
                                       end case;
                   when D_RAND      => lastrandom := random(lastrandom);
                                       y := mask_randomN(lastrandom,x7x0);
                   when D_RANDSET   => setrandom  := lastrandom;
                                       lastrandom := random(lastrandom);
                                       y := mask_randomN(lastrandom,x7x0);
                   when D_RANDRESET => lastrandom := setrandom;
                                       lastrandom := random(lastrandom);
                                       y := mask_randomN(lastrandom,x7x0);
                   when others      => assert FALSE report "Illegal Parameter P2" severity FAILURE;
                 end case;
         when 2 =>  y := stack(stkptr-x12x0+offset);     -- E_STACK
         when 1 =>  y := stack(x12x0+offset);            -- E_ADDR
         when 0 =>  y := x12x0;                          -- E_DATA
         when others => assert FALSE report "Illegal Parameter P3" severity FAILURE; 
     end case;
  else  -- immediate data
    y := x;
  end if;
  return(y);
end get_para_value;


impure function get_storeaddr(x : integer) return integer is
variable sa     : integer;
variable x30x16 : integer;
variable x14x13 : integer;
variable x12x0  : integer;
variable x12x8  : integer;
variable x7x0   : integer;
variable xlv    : std_logic_vector(31 downto 0);
variable offset : integer;
begin
  --printf("Store Addr %08x",fmt(x));
  xlv    := to_slv32(x);
  x30x16 := to_int_unsigned(xlv(30 downto 16));
  x14x13 := to_int_unsigned(xlv(14 downto 13));
  x12x0  := to_int_unsigned(xlv(12 downto  0));
  x12x8  := to_int_unsigned(xlv(12 downto  8));
  x7x0   := to_int_unsigned(xlv( 7 downto  0));
  offset :=0;
  if xlv(15)='1' then -- ARRAY offset in upper 16 bits
    offset := get_para_value(TRUE,x30x16);
  end if;
  case x14x13 is  
    when 3 =>  assert FALSE report "$Variables not allowed" severity FAILURE;
    when 2 =>  sa := stkptr-x12x0+offset;    -- E_STACK
    when 1 =>  sa := x12x0+offset;           -- E_ADDR
    when 0 =>  assert FALSE report "Immediate data not allowed" severity FAILURE;
    when others => assert FALSE report "Illegal Parameter P3" severity FAILURE; 
  end case;
  return(sa);
end get_storeaddr;


begin
  if SYSRSTN='0' then
     HCLK_STOP        <= '0';
     DEBUG            <=  DEBUGLEVEL;
     HADDR_P0         <= ( others => '0');
     HBURST_P0        <= ( others => '0');
     HMASTLOCK_P0     <= '0';
     HPROT_P0         <= ( others => '0');
     HSIZE_P0         <= ( others => '0');
     HTRANS_P0        <= ( others => '0');
     HWRITE_P0        <= '0';
     GPOUT_P0         <= ( others => '0');
     INSTR_OUT        <= ( others => '0');
     WRITE_P0         <= '0';
     READ_P0          <= '0';
     RDATA_P0         <= ( others => '0');
     MDATA_P0         <= ( others => '0');
     WDATA_P0         <= ( others => '0');
     GPIORD_P0        <= '0';
     EXTWR_P0         <= '0'; 
     EXTRD_P0         <= '0'; 
     EXTADDR_P0       <= ( others => '0');
     EXT_DOUT         <= ( others => '0');
     FINISHED_P0      <= '0';
     FILENAME(1 to 8) <= "UNKNOWN" & NUL; 
     READ_P1          <= '0';
     RDATA_P1         <= ( others => '0');
     MDATA_P1         <= ( others => '0');
     LINENO_P1        <= 0;
     HADDR_P1         <= ( others => '0');
     EIO_RDCHK_P1     <= '0';
     EIO_RDATA_P1     <= ( others =>  '0');
     EIO_MDATA_P1     <= ( others =>  '0');
     EIO_LINENO_P1    <= 0;
     FAILED_P0        <= '0';
     HRESETN_P0       <= '0';
     CON_BUSY         <= '0';
     LINENO_P1        <= 0;
     POLL_P0          <= '0';
     POLL_P1          <= '0';
     DRIVEX_CLK       <= FALSE;
     DRIVEX_RST       <= FALSE;
     DRIVEX_ADD       <= FALSE;
     DRIVEX_DAT       <= FALSE;
     HRESP_STATE      := OK1;
     initdone         := false;
     cptr             := 0;
     cmd_active       := false;
     bfm_mode         := 0;
     do_case          := false;
     do_flush         := false;
     do_write         := false; 
     do_read          := false; 
     do_bwrite        := false; 
     do_bread         := false; 
     do_poll          := false;
     do_idle          := false;
     stkptr           := 0;
     hresp_mode       := 0;
     command_timeout  := 512;
     piped_activity   := false;
     errors           := 0;
     hresp_occured    := false;
     ahb_lock         := '0';
     ahb_prot         := "0011";
     ahb_burst        := "001";
     bfm_done         := false;
     su_xsize         := 2;
     su_xainc         := 4;
     su_xrate         := 0;
     su_flush         := false;
     su_align         := 0;
     su_endsim        := 0;
     return_value     := 0;
     bfm_run          := false;
     count_xrate      := 0;
     log_ahb          := false;
     log_ext          := false;
     log_gpio         := false;
     log_bfm          := false;
     logfile(1)       := NUL;
     insert_busy      := false;
     wait_time        := 0;
     setrandom        := 1;
     lastrandom       := 1;
     reset_pulse      := 0;
     npass            := 0;
     wptr_cstk        := 0;
     rptr_cstk        := 0;
     casedepth        := 0;
	 su_noburst       := 0;
     instructions_timer :=0;
  elsif SCLK='1' and SCLK'event then
    CON_RDP1   <= CON_RD;
    CON_WRP1   <= CON_WR;
    EXTWR_P0   <= '0'; 
    EXTRD_P0   <= '0'; 
    GPIORD_P0  <= '0';
    GPIOWR_P0  <= '0';
    do_io := false;
    if not initdone then 
      printf(" ");
      printf("###########################################################################");
      printf("AMBA BFM Model");
      printf("Version %s  %s",fmt(BFM_VERSION)&fmt(BFM_DATE));
      printf(" ");
      printf("Opening BFM Script file %s",fmt(vectfile));
       -- RAM Initialisation                                                                               
      if not INITDONE and OPMODE/=2 then                                                                                
         file_open(fstatus,FSTR,vectfile);                                                                  
         if not (fstatus=open_ok) then                                                                     
           assert FALSE  report "FAILED to load script file " & vectfile severity FAILURE;                  
         else                                                                                              
           v:=0;
           filedone := false;
           while not filedone loop
             readline(FSTR,L);                                                                           
             for j in 1 to 8 loop                                                                    
               read(L,ch);  
               istr(j) := ch;                                                         
             end loop;                                                                                     
             vectors(v) := to_integer(to_dword_signed(istr));
             v:=v+1;
             filedone := endfile(FSTR);
           end loop;                                                                                       
           file_close(FSTR);                                                                               
        end if;                                                                                           
        initdone := TRUE;  
        NVectors := v;
        bfmc_version    := vectors(0) mod 65536;
        vectors_version := vectors(0) / 65536;
        printf("Read %d Vectors - Compiler Version %d.%d",fmt(Nvectors)&fmt(vectors_version)&fmt(bfmc_version));
        if  vectors_version /= C_VECTORS_VERSION then
           assert FALSE  report "Incorrect vectors file format for this BFM" & vectfile severity FAILURE;                  
        end if;
        cptr   := vectors(1);  
        fptr   := vectors(2);
        stkptr := vectors(3);   -- Start Stack after required global storage area
        stack(stkptr) :=0;      -- put a return address of zero on the stack
        stkptr := stkptr+1;
        if cptr=0 then
           assert FALSE  report "BFM Compiler reported errors" severity FAILURE;                  
        end if; 
        -- extract files names     
        printf("BFM:Filenames includes in Vectors");
        command0   := to_slv32(vectors(fptr));
        cmd_cmd    := vectors(fptr) rem 256;
        while cmd_cmd=C_FILEN loop
           command_length  := len_string(vectors(fptr+1));
           command := ( others => 0);
           str := extract_string(fptr,vectors(fptr to fptr+command_length-1),command);
           printf("  %s",fmt(str));
           for i in 1 to 256 loop
             filenames(NFILES)(i) := str(i);
           end loop;
           NFILES := NFILES+1;
           fptr := fptr + command_length;
           command0   := to_slv32(vectors(fptr));
           cmd_cmd    := vectors(fptr) rem 256;
        end loop;   
        filemult := 65536;
        if NFILES>1  then filemult:=32768; end if;
        if NFILES>2  then filemult:=16384; end if;
        if NFILES>4  then filemult:=8912; end if;
        if NFILES>8  then filemult:=4096; end if;
        if NFILES>16 then filemult:=2048; end if;
        if NFILES>32 then filemult:=1024; end if;
        bfm_run := (OPMODE=0);
      end if;                                                                                              
    end if;
    if OPMODE=2 and not INITDONE then
      filemult := 65536;
      initdone := true;
      bfm_run  := false;
      stkptr   := 0;
      stack(stkptr) :=0;
      stkptr := stkptr+1;
    end if;

    ------------------------------------------------------------------------------------------
    -- see whether reset needs deasserting
    if reset_pulse<=1 then
      HRESETN_P0 <= '1';
    else
      reset_pulse := reset_pulse -1;
    end if; 
  
    ------------------------------------------------------------------------------------------------------------
    -- HRESP Checker
    
    case HRESP_STATE is
      when OK1  => if HRESP='1' and HREADY='1' then
                     assert FALSE report "BFM: HRESP Signaling Protocol Error T2" severity ERROR;
                     ERRORS := ERRORS+1;
                   end if;
                   if HRESP='1' and HREADY='0' then
                      HRESP_STATE := OK2;
                   end if;
      when OK2  => if HRESP='0' or HREADY='0' then
                     assert FALSE report "BFM: HRESP Signaling Protocol Error T3" severity ERROR;
                     ERRORS := ERRORS+1;
                   end if;
                   if HRESP='1' and HREADY='1' then
                      HRESP_STATE := OK1;
                   end if;
                   case hresp_mode is
                     when 0 => -- should not have occured
                               assert FALSE report "BFM: Unexpected HRESP Signaling Occured" severity ERROR;
                               ERRORS := ERRORS+1;
                     when 1 => -- Ignore
                               hresp_occured := true;
                     when others =>  assert FALSE report "BFM: HRESP mode is not correctly set" severity ERROR;
                                     ERRORS := ERRORS+1;
                   end case;
    end case;
    
    ------------------------------------------------------------------------------------------
    -- Handle the external command interface
    if OPMODE>0 then
      if CON_WR='1' and (CON_WRP1='0' or CON_SPULSE=1) then
        n := to_int(con_addr);
        case n is
          when 0 =>   bfm_run    := (CON_DIN(0)='1');
                      bfm_single := (CON_DIN(1)='1');
                      bfm_done   := false;
                      if bfm_run and not bfm_single then
                        stack(stkptr) :=0;      -- null return address
                        stkptr := stkptr+1;
                      end if;
                      if debug>=2 and bfm_run and not bfm_single then 
                        printf("BFM: Starting script at %08x (%d parameters)",fmt(cptr)&fmt(npass));
                      end if;
                      if debug>=2 and bfm_run and bfm_single then 
                        printf("BFM: Starting instruction at %08x",fmt(cptr));
                      end if;
                      if bfm_run then
                        if npass>0 then   -- put the stored parameters on the stack
                          for i in 0 to npass-1 loop
                            stack(stkptr) := passed(i);     
                            stkptr := stkptr+1;
                          end loop;
                          npass := 0;
                        end if;
                        wptr_cstk :=0;
                        rptr_cstk :=0;
                      end if;
          when 1 =>   cptr := to_int_unsigned(CON_DIN);
          when 2 =>   passed(npass) := to_int_signed(CON_DIN);
                      npass := npass+1;
          when others => vectors(n) := to_int_signed(CON_DIN);
        end case;
      end if;
      if CON_RD='1' and (CON_RDP1='0' or CON_SPULSE=1) then  -- when reading there must be an idle cycle
        n := to_int(con_addr);
        case n is
          when 0 => CON_DOUT    <= ( others => '0');
                    CON_DOUT(2) <= to_std_logic(bfm_run);
                    CON_DOUT(3) <= to_std_logic(ERRORS>0);
          when 1 => CON_DOUT    <= to_std_logic(to_unsigned(cptr,32));
          when 2 => CON_DOUT    <= to_std_logic(to_unsigned(return_value,32));
                    npass := 0;
          when 3 => if wptr_cstk > rptr_cstk then
                      CON_DOUT <= to_std_logic(to_unsigned(returnstk(rptr_cstk),32));
                      rptr_cstk := rptr_cstk +1;
                    else
                      printf("BFM: Overread Control return stack");
                      CON_DOUT <= ( others => '0');
                    end if;
          when others => CON_DOUT <= to_std_logic(to_unsigned(vectors(n),32));
        end case;
      end if;
    end if;
    
    ------------------------------------------------------------------------------------------
    -- Decode the Commands and schedule activities
    -- Command Processing no requirement on HREADY
    instruct_cycles    := instruct_cycles + 1;
    instructions_timer := instructions_timer + 1;
    zerocycle := TRUE;
    while zerocycle loop
      zerocycle := false;
      if not cmd_active and bfm_run then
        command0     := to_slv32(vectors(cptr));
        cmd_size     := to_int_unsigned(command0(1 downto 0));
        cmd_cmd      := to_int_unsigned(command0(7 downto 0));
        cmd_scmd     := to_int_unsigned(command0(15 downto 8));
        cmd_lineno   := to_int_unsigned(command0(31 downto 16));
        timer        := command_timeout;
        instuct_count   := instuct_count + 1;
        command_length  := 1;
        storeaddr       := -1;
        count_xrate     :=0;
        ifprintf((DEBUG>=5),"BFM: Instruction %d Line Number %d Command %d",fmt(cptr)&fmt(cmd_lineno)&fmt(cmd_cmd));
        if LOG_BFM  then
          sprintf(logstr,"%05t BF %4d %4d %3d",fmt(cptr)&fmt(cmd_lineno)&fmt(cmd_cmd));
          write( L, logstr ); writeline(FLOG, L);
        end if;
        if cmd_cmd>=100 then
           cmd_cmdx4 := cmd_cmd;
        else
           cmd_cmdx4 := 4 * (cmd_cmd/4);
        end if;
        if cmd_cmd/=C_CHKT then
          instruct_cycles :=0; 
        end if;
        -- Move command from vectors to stack switching parameters if necessary
        case cmd_cmdx4 is
          when C_PRINT | C_HEAD | C_FILEN | C_LOGF => n:=8;
          when C_WRTM  | C_RDMC                    => n:=4+vectors(cptr+1);
          when C_CALLP                             => n:=3+vectors(cptr+2);
          when C_CALL                              => n:=3;
          when C_TABLE                             => n:=2+vectors(cptr+1);
          when C_CALC                              => n:=3+vectors(cptr+2);
          when C_ECHO                              => n:=2+vectors(cptr+1);
          when C_EXTWM                             => n:=3+vectors(cptr+1);
          when others                              => n:=8;
        end case;
        if n>0 then
          for i in 0 to n-1 loop
            if (i>=1 and i<=8) then
              command(i) := get_para_value( (command0(7+i)='1'),vectors(cptr+i));
            else
              command(i) := vectors(cptr+i);
            end if;
            commandlv(i) := to_slv32(command(i));
          end loop;
        end if;
        -- Main Command Processing
        case cmd_cmdx4 is
          when C_FAIL  => assert FALSE report "BFM Compiler reported an error" severity FAILURE;
                          ERRORS := ERRORS+1;
     
          when C_CONPU => command_length := 2;
                          zerocycle := TRUE; 
                          returnstk(wptr_cstk) := command(1);
                          wptr_cstk := wptr_cstk +1;     
                          ifprintf((DEBUG>=2),"BFM:%d:conifpush %d ",
                                            fmt(cmd_lineno)&fmt(command(1)));
                  
          when C_RESET => command_length := 2;
                          HRESETN_P0 <= '0';
                          reset_pulse := command(1);
                          ifprintf((DEBUG>=2),"BFM:%d:RESET %d",
                                              fmt(cmd_lineno)&fmt(command(1)));
      
          when C_CLKS  => command_length := 2;
                          HCLK_STOP <= commandLV(1)(0);
                          ifprintf((DEBUG>=2),"BFM:%d:STOPCLK %d ",
                                            fmt(cmd_lineno)&fmt(commandLV(1)(0)));
                          
          when C_MODE  => command_length := 2;
                          bfm_mode := command(1);     
                          ifprintf((DEBUG>=2),"BFM:%d:mode %d (No effect in this version)",
                                            fmt(cmd_lineno)&fmt(bfm_mode));

          when C_SETUP => zerocycle := TRUE;
                          command_length := 4;
                          n :=  command(1); 
                          x :=  command(2);
                          y :=  command(3);
                          ifprintf((DEBUG>=2),"BFM:%d:setup %d %d %d ",
                                               fmt(cmd_lineno)&fmt(n)&fmt(x)&fmt(y));
                          case n is
                            when 1 => command_length := 4;
                                      su_xsize := X;
                                      su_xainc := Y;
                                      ifprintf((DEBUG>=2),"BFM:%d:Setup- Memory Cycle Transfer Size %s %d",
                                                           fmt(cmd_lineno)&fmt(to_char(su_xsize))&fmt(su_xainc)); 
                            when 2 => command_length := 3;
                                      su_flush := to_boolean(X);          
                                      ifprintf((DEBUG>=2),"BFM:%d:Setup- Automatic Flush %d",
                                                           fmt(cmd_lineno)&fmt(su_flush)); 
                            when 3 => command_length := 3;
                                      su_xrate := x;          
                                      ifprintf((DEBUG>=2),"BFM:%d:Setup- XRATE %d",
                                                           fmt(cmd_lineno)&fmt(su_xrate)); 
                          
                            when 4 => command_length := 3;
                                      su_noburst := X;          
                                      ifprintf((DEBUG>=2),"BFM:%d:Setup- Burst Disable %d",
                                                           fmt(cmd_lineno)&fmt(su_noburst)); 
                            when 5 => command_length := 3;
                                      su_align := X;          
                                      ifprintf((DEBUG>=2),"BFM:%d:Setup- Alignment %d",
                                                           fmt(cmd_lineno)&fmt(su_align)); 
                                      if su_align=1 or su_align=2 then
                                        assert FALSE report "BFM: Untested 8 or 16 Bit alignment selected" severity WARNING;
                                      end if;
                         
                            when 6 => command_length := 3;
                                      su_endsim := X;          
                                      ifprintf((DEBUG>=2),"BFM:%d:Setup- End Sim Action %0d", fmt(cmd_lineno)&fmt(su_endsim)); 
                                      if ( su_endsim > 4) then
                                          printf("BFM: Unexpected End Simulation value (WARNING)"); 
                                      end if; 
                      
                            when 7 => command_length := 3;
                                      -- ignore verilog endsim command
                                       
                            when others =>  assert FALSE report "BFM Unknown Setup Command" severity FAILURE;

                          end case;
        
          when C_DRVX  => zerocycle := TRUE;
                          command_length := 2;
                          DRIVEX_ADD <= (commandLV(1)(0)='1');
                          DRIVEX_DAT <= (commandLV(1)(1)='1');
                          DRIVEX_RST <= (commandLV(1)(2)='1');
                          DRIVEX_CLK <= (commandLV(1)(3)='1');
        
                          ifprintf((DEBUG>=2),"BFM:%d:drivex %d ",
                                            fmt(cmd_lineno)&fmt(command(1)));
        
          when C_ERROR => zerocycle := TRUE;
                          command_length := 3;
                          ifprintf((DEBUG>=2),"BFM:%d:error %d %d (No effect in this version)",
                                            fmt(cmd_lineno)&fmt(command(1))&fmt(command(2)));

          when C_PROT  => zerocycle := TRUE;
                          command_length := 2;
                          ahb_prot := commandLV(1)(3 downto 0);
                          ifprintf((DEBUG>=2),"BFM:%d:prot %d ",
                                            fmt(cmd_lineno)&fmt(ahb_prot));
       
          when C_LOCK  => zerocycle := TRUE;
                          command_length := 2;
                          ahb_lock := commandLV(1)(0);
                          ifprintf((DEBUG>=2),"BFM:%d:lock %d ",
                                            fmt(cmd_lineno)&fmt(ahb_lock));
        
          when C_BURST => zerocycle := TRUE;
                          command_length := 2;
                          ahb_burst := commandLV(1)(2 downto 0);
                          ifprintf((DEBUG>=2),"BFM:%d:burst %d ",
                                            fmt(cmd_lineno)&fmt(ahb_burst));

          when C_WAIT  => command_length := 2;
                          wait_counter := command(1);     
                          ifprintf((DEBUG>=2),"BFM:%d:wait %d  starting at %t ns",
                                              fmt(cmd_lineno)&fmt(wait_counter));
                          do_case := true;
   
          when C_WAITUS=> command_length := 2;
                          wait_time := command(1) * 1000 + (NOW / 1 ns);     
                          ifprintf((DEBUG>=2),"BFM:%d:waitus %d  starting at %t ns",
                                              fmt(cmd_lineno)&fmt(command(1)));
                          do_case := true;
   
          when C_WAITNS=> command_length := 2;
                          wait_time := command(1) * 1 + (NOW / 1 ns);     
                          ifprintf((DEBUG>=2),"BFM:%d:waitns %d  starting at %t ns",
                                              fmt(cmd_lineno)&fmt(command(1)));
                          do_case := true;
                          
          when C_CHKT  => command_length := 3;
                          ifprintf((DEBUG>=2),"BFM:%d:checktime %d %d at %t ns ",
                                              fmt(cmd_lineno)&fmt(command(1))&fmt(command(2)));
                          do_case := TRUE;
              
          when C_STTIM => zerocycle := TRUE;
                          command_length := 1;
                          instructions_timer := 1;
                          ifprintf(DEBUG>=2, "BFM:%d:starttimer at %t ns", fmt(cmd_lineno));  
      
          when C_CKTIM => command_length := 3;
                          ifprintf((DEBUG>=2),"BFM:%d:checktimer %d %d at %t ns ",
                                             fmt(cmd_lineno)&fmt(command(1))&fmt(command(2)));
                          do_case := TRUE;
                                                  
                             
          when C_WRITE => command_length   := 4;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32(command(1)+ command(2));
                          command_data     := commandLV(3);
                          ifprintf((DEBUG>=2),"BFM:%d:write %c %08x %08x at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(command_data));  
                          do_write := TRUE;
         
          when C_AHBC  => command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32(command(1)+ command(2));
                          command_data     := commandLV(3);
                          ahbc_hwrite      := commandLV(4)(0);
                          ahbc_htrans      := commandLV(4)(5 downto 4);     
                          ahbc_burst       := commandLV(4)(10 downto 8);
                          ahbc_lock        := commandLV(4)(12);
                          ahbc_prot        := commandLV(4)(19 downto 16);
                          ifprintf((DEBUG>=2),"BFM:%d:ahbcycle %c %08x %08x %08x at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(command_data)&fmt(commandLV(4)));  
                          do_idle := TRUE;
                          
          when C_READ  => command_length   := 3;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := ( others => '0');
                          command_mask     := ( others => '0');
                          ifprintf((DEBUG>=2),"BFM:%d:read %c %08x  at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address));  
                          do_read  := TRUE; 
                     
          when C_READS => command_length   := 4;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := ( others => '0');
                          command_mask     := ( others => '0');
                          storeaddr        := get_storeaddr(vectors(cptr+3));   -- take pointer from vectors
                          ifprintf((DEBUG>=2),"BFM:%d:readstore %c %08x @%d at %t ns ",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)
                                              &fmt(storeaddr));  
                          do_read  := true; 
                          do_flush := true;
                      
          when C_RDCHK => command_length   := 4;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := commandLV(3);
                          command_mask     := (others => '1');
                          ifprintf((DEBUG>=2),"BFM:%d:readcheck %c %08x %08x at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(command_data));  
                          do_read := TRUE;
                          
          when C_RDMSK => command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := commandLV(3);
                          command_mask     := commandLV(4);
                          ifprintf((DEBUG>=2),"BFM:%d:readmask %c %08x %08x %08x at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(command_data)&fmt(command_mask));  
                          do_read  := TRUE;
                          
          when C_POLL =>  command_length   := 4;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := commandLV(3);
                          command_mask     := (others => '1');
                          ifprintf((DEBUG>=2),"BFM:%d:poll %c %08x %08x at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(command_data));                          cmd_active := TRUE; do_poll := TRUE;
                          do_poll := TRUE;
                          
          when C_POLLM=>  command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := commandLV(3);
                          command_mask     := commandLV(4);
                          ifprintf((DEBUG>=2),"BFM:%d:pollmask %c %08x %08x %08x at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(command_data)&fmt(command_mask));  
                          do_poll := TRUE;
                          
          when C_POLLB=>  command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_data     := ( others => '0');
                          command_mask     := ( others => '0');
                          bitn             := command(3);
                          command_mask(bitn) := '1';
                          command_data(bitn) := commandLV(4)(0);
                          ifprintf((DEBUG>=2),"BFM:%d:pollbit %c %08x %d %d at %t ns",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(bitn)&fmt(command_data(bitn)));                        
                          do_poll := TRUE;
          
          when C_WRTM =>  burst_length     := command(1);
                          command_length   := 4 + burst_length;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(2)+command(3));
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          for i in 0 to burst_length -1 loop
                            burst_data(i) := command(i+4);
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:writemultiple %c %08x %08x ... at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(burst_data(0)));  
                          do_bwrite := TRUE;
        
          when C_FILL =>  burst_length     := command(3);
                          command_length   := 6;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          data_start       := command(4);
                          data_inc         := command(5);
                          for i in 0 to burst_length -1 loop
                            burst_data(i) := data_start;
                            data_start := data_start +  data_inc;
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:fill %c %08x %d %d %d at %t ns",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(burst_length)&fmt(command(4))&fmt(command(4)));                        
                          do_bwrite := TRUE;
          
          when C_WRTT =>  burst_length     := command(4);
                          command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          tableid          := command(3);
                          for i in 0 to burst_length -1 loop
                            burst_data(i) := vectors(2+tableid+i);
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:writetable %c %08x %d %d at %t ns ",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(tableid)&fmt(burst_length));                       
                          do_bwrite := TRUE;
          
          when C_WRTA =>  burst_length     := command(4);
                          command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          setvar           := get_storeaddr(vectors(cptr+3));
                            for i in 0 to burst_length -1 loop
                            burst_data(i) := stack(setvar+i);
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:writearray %c %08x %d %d at %t ns ",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(setvar)&fmt(burst_length));                       
                          do_bwrite := TRUE;
            
          when C_RDM =>   burst_length     := command(3); -- note this is a fixed length instruction
                          command_length   := 4;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_mask     := ( others => '0');
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          command_mask     := ( others => '0');
                          ifprintf((DEBUG>=2),"BFM:%d:readmult %c %08x %d at %t ns",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(burst_length));                        
                          do_bread := TRUE;
                          
          when C_RDMC =>  burst_length     := command(1);
                          command_length   := 4 + burst_length;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(2)+command(3));
                          command_mask     := ( others => '1');
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          command_mask     := ( others => '1');
                          for i in 0 to burst_length-1 loop
                            burst_data(i) := command(i+4);
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:readmultchk %c %08x %08x ... at %t ns",
                                              fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(burst_data(0)));  
                          do_bread := TRUE;
                          
          when C_READF => burst_length     := command(3);
                          command_length   := 6;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_mask     := ( others => '1');
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          data_start       := command(4);
                          data_inc         := command(5);
                          for i in 0 to burst_length -1 loop
                            burst_data(i) := data_start;
                            data_start := data_start + data_inc;
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:fillcheck %c %08x %d %d %d at %t ns",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(burst_length)&fmt(command(4))&fmt(command(5)));                        
                          do_bread := TRUE;
                              
          when C_READA => burst_length     := command(4);
                          command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  := to_slv32( command(1)+command(2));
                          command_mask     := ( others => '1');
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          setvar           := get_storeaddr(vectors(cptr+3));
                          for i in 0 to burst_length -1 loop
                            burst_data(i) := stack(setvar+i);
                          end loop;                       
                          ifprintf((DEBUG>=2),"BFM:%d:readarray %c %08x %d %d at %t ns",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(setvar)&fmt(burst_length));                       
                          do_bread := TRUE;
        
          when C_READT=> burst_length     := command(4);
                          command_length   := 5;
                          command_size     := xfer_size(cmd_size,su_xsize);
                          command_address  :=to_slv32( command(1)+command(2));
                          command_mask     :=( others => '1');
                          burst_count      := 0;
                          burst_addrinc    := address_increment(cmd_size,su_xainc);
                          tableid := command(3);
                          for i in 0 to burst_length -1 loop
                             burst_data(i) := vectors(tableid+2+i);
                          end loop;
                          ifprintf((DEBUG>=2),"BFM:%d:readtable %c %08x %d %d at %t ns",
                                               fmt(cmd_lineno)&fmt(to_char(cmd_size))&fmt(command_address)&fmt(tableid)&fmt(burst_length));                       
                          do_bread := TRUE;
   
          when C_MEMT  => command_length   := 7;
                          do_case   := TRUE;
                          mt_state  := init; 
     
          when C_MEMT2 => command_length   := 7;
                          do_case   := TRUE;
                          mt_state  := init; 
                              
          when C_FIQ  =>  command_length := 1;
                          int_vector :=  0;
                          ifprintf((DEBUG>=2),"BFM:%d:waitfiq at %t ns ",
                                               fmt(cmd_lineno));                          
                          do_case := TRUE;  
                           
          when C_IRQ  =>  command_length := 1;
                          int_vector :=  1;
                          ifprintf((DEBUG>=2),"BFM:%d:waitirq at %t ns ",
                                               fmt(cmd_lineno));                          
                          do_case := TRUE; 
                            
          when C_INTREQ=> command_length := 2;
                          int_vector :=  command(1);
                          ifprintf((DEBUG>=2),"BFM:%d:waitint %d  at %t ns",
                                               fmt(cmd_lineno)&fmt(int_vector));                          
                          do_case := TRUE;   
                          
          when C_IOWR  => command_length := 2;
                          command_data   := commandLV(1);
                          GPOUT_P0       <= command_data;
                          GPIOWR_P0      <= '1';
                          ifprintf((DEBUG>=2),"BFM:%d:iowrite %08x  at %t ns ",
                                               fmt(cmd_lineno)&fmt(command_data));                        
      
          when C_IORD =>  command_length := 2;
                          command_data   := ( others => '0');
                          command_mask   := ( others => '0');
                          storeaddr        := get_storeaddr(vectors(cptr+1));   -- take pointer from vectors
                          ifprintf((DEBUG>=2),"BFM:%d:ioread @%d at %t ns",
                                               fmt(cmd_lineno)&fmt(storeaddr));                          
                          GPIORD_P0 <= '1';
                          do_case  := TRUE; 
                          do_flush := true; 
                          do_io    := true;
                          
          when C_IOCHK => command_length := 2;
                          command_data   := commandLV(1);
                          command_mask   := ( others => '1');
                          GPIORD_P0 <= '1';
                          ifprintf((DEBUG>=2),"BFM:%d:iocheck %08x  at %t ns ",
                                               fmt(cmd_lineno)&fmt(command_data));                        
                          do_case := TRUE;  
                           
          when C_IOMSK => command_length := 3;
                          command_data   := commandLV(1);
                          command_mask   := commandLV(2);
                          ifprintf((DEBUG>=2),"BFM:%d:iomask %08x %08x  at %t ns",
                                               fmt(cmd_lineno)&fmt(command_data)&fmt(command_mask));                          
                          GPIORD_P0 <= '1';
                          do_case := true;
                          
          when C_IOTST => command_length := 2;
                          command_data   := (others => '0');
                          command_mask   := (others => '0');
                          bitn := command(1);
                          command_data(bitn) := command0(0);
                          command_mask(bitn) := '1';
                          GPIORD_P0 <= '1';
                          ifprintf((DEBUG>=2),"BFM:%d:iotest %d %d  at %t ns",
                                               fmt(cmd_lineno)&fmt(bitn)&fmt(command0(0)));                         
                          do_case := TRUE;   
                          
          when C_IOSET => command_length := 2;
                          bitn := command(1);
                          GPOUT_P0(bitn) <= '1';
                          GPIOWR_P0      <= '1';
                          ifprintf((DEBUG>=2),"BFM:%d:ioset %d at %t ns",
                                               fmt(cmd_lineno)&fmt(bitn));                        
                          
          when C_IOCLR => command_length := 2;
                          bitn := command(1);
                          GPOUT_P0(bitn) <= '0';
                          GPIOWR_P0  <= '1';
                          ifprintf((DEBUG>=2),"BFM:%d:ioclr %d at %t ns",
                                               fmt(cmd_lineno)&fmt(bitn));                        
                          
          when C_IOWAIT=> command_length := 2;
                          command_data   := (others => '0');
                          command_mask   := (others => '0');
                          bitn := command(1);
                          command_data(bitn) := command0(0);
                          command_mask(bitn) := '1';
                          ifprintf((DEBUG>=2),"BFM:%d:iowait %d %d at %t ns ",
                                               fmt(cmd_lineno)&fmt(bitn)&fmt(command0(0)));                         
                          GPIORD_P0 <= '1';
                          do_case := true;
                               
          when C_EXTW  => command_length := 3;
                          command_address:= commandLV(1);
                          command_data   := commandLV(2);
                          ifprintf(DEBUG>=2, "BFM:%d:extwrite %08x %08x at %t ns",
                                               fmt(cmd_lineno)&fmt(command_address)&fmt(command_data));  
                          do_case := true;
            
          when C_EXTWM => burst_length   := command(1);
                          burst_address  := command(2);
                          command_length := burst_length+3;
                          for i in 0 to burst_length -1 loop
                            burst_data(i) := command(i+3);
                          end loop;                       
                   
                          ifprintf(DEBUG>=2, "BFM:%d:extwrite %08x %0d Words at %t ns",
                                               fmt(cmd_lineno)&fmt(command_address)&fmt(burst_length));  
                          burst_count := 0;
                          do_case := true;
                                                  
          when C_EXTR  => command_length := 3;
                          command_address:= commandLV(1);
                          command_data   := ( others => '0'); 
                          command_mask   := ( others => '0');
                          storeaddr      := get_storeaddr(vectors(cptr+2)); -- take pointer from vectors
                          EXTRD_P0       <= '1';
                          ifprintf(DEBUG>=2, "BFM:%d:extread @%d %08x at %t ns ",
                                               fmt(cmd_lineno)&fmt(storeaddr)&fmt(command_address));  
                          do_case  := true;
                          do_flush := true;
                          do_io    := true;
              
          when C_EXTRC => command_length := 3;
                          command_address:=  commandLV(1);
                          command_data   :=  commandLV(2);
                          command_mask   :=  ( others => '1');
                          cmd_active     := TRUE;   
                          EXTRD_P0       <= '1';
                          ifprintf(DEBUG>=2, "BFM:%d:extcheck %08x %08x at %t ns",
                                               fmt(cmd_lineno)&fmt(command_address)&fmt(command_data));  
                          do_case := true;
                          
          when C_EXTMSK => command_length := 4;
                          command_address:=  commandLV(1);
                          command_data   :=  commandLV(2);
                          command_mask   :=  commandLV(3);
                          EXTRD_P0 <= '1';
                          ifprintf(DEBUG>=2, "BFM:%d:extmask %08x %08x %08x at %t ns",
                                               fmt(cmd_lineno)&fmt(command_address)&fmt(command_data)&fmt(command_mask)); 
                          do_case := true;
                          
          when C_EXTWT=>  command_length := 1;
                          wait_counter := 1;
                          cmd_active := TRUE;  
                          ifprintf(DEBUG>=2, "BFM:%d:extwait ",
                                               fmt(cmd_lineno));  
                          do_case := true;
                          
          when C_LABEL => assert FALSE report "LABEL instructions not allowed in vector files" severity FAILURE;       
          
          when C_TABLE => zerocycle := TRUE;
                          command_length := 2 + command(1);
                          ifprintf((DEBUG>=2),"BFM:%d:table %08x ... (length=%d)",
                                               fmt(cmd_lineno)&fmt(command(2))&fmt(command_length-2));                        
           
          when C_JMP   => zerocycle := TRUE;
                          command_length := 2;
                          jump_address   := command(1);
                          command_length := jump_address - cptr;     -- point at new address
                          ifprintf((DEBUG>=2), "BFM:%d:jump",
                                               fmt(cmd_lineno));  

          when C_JMPZ  => zerocycle := TRUE;
                          command_length := 3;
                          jump_address   := command(1);
                          if command(2)=0 then
                            command_length := jump_address - cptr;     -- point at new address
                          end if;
                          ifprintf((DEBUG>=2), "BFM:%d:jumpz  %08x",
                                               fmt(cmd_lineno)&fmt(command(2)));  
          when C_IF    => zerocycle := TRUE;
                          command_length := 5;
                          jump_address   := command(1);
                          newvalue := calculate(command(3),command(2),command(4),debug);
						  if newvalue=0 then
                            command_length := jump_address + 2 - cptr;     -- point at new address
                          end if;
                          ifprintf((DEBUG>=2), "BFM:%d:if %08x func %08x",
                                               fmt(cmd_lineno)&fmt(command(2))&fmt(command(4)));  
	   
	      when C_IFNOT => zerocycle := TRUE;
                          command_length := 5;
                          jump_address   := command(1);
                          newvalue := calculate(command(3),command(2),command(4),debug);
						  if newvalue/=0 then
                            command_length := jump_address +2 - cptr;     -- point at new address
                          end if;
                          ifprintf((DEBUG>=2), "BFM:%d:ifnot %08x func %08x",
                                               fmt(cmd_lineno)&fmt(command(2))&fmt(command(4)));  
      
          when C_ELSE  => zerocycle := TRUE;
                          command_length := 2;
                          jump_address   := command(1);
                          command_length := jump_address + 2 - cptr;     -- point at new address
                          ifprintf((DEBUG>=2), "BFM:%d:else ",fmt(cmd_lineno));  
        
          when C_ENDIF => zerocycle := TRUE;      -- do nothing endif is pad instruction stream so +2 works
                          command_length := 2;
                          ifprintf((DEBUG>=2), "BFM:%d:endif ", fmt(cmd_lineno));  
    
	    
          when C_WHILE => zerocycle := TRUE;
                          command_length := 5;
                          jump_address   := command(1)+2;  -- after endwhile
                          newvalue := calculate(command(3),command(2),command(4),debug);
						  if newvalue=0 then
                            command_length := jump_address - cptr;     -- point at new address
                          end if;
                          ifprintf((DEBUG>=2), "BFM:%d:while %08x func %08x",
                                               fmt(cmd_lineno)&fmt(command(2))&fmt(command(4)));  
        
          when C_ENDWHILE => zerocycle := TRUE;
                             command_length := 2;
                             jump_address   := command(1);
                             command_length := jump_address - cptr;     -- point at new address
                             ifprintf((DEBUG>=2), "BFM:%d:endwhile",
                                                  fmt(cmd_lineno));  
         
          when C_WHEN  => zerocycle := TRUE;
                          command_length := 4;
                          jump_address   := command(3);
                          if command(1)/=command(2) then
                            command_length := jump_address - cptr;     -- point at new address ie next when/endcase
                          else
                            casedone(casedepth) := TRUE;              -- doing this branch
                          end if;
                          ifprintf((DEBUG>=2), "BFM:%d:when %08x=%08x %08x",
                                               fmt(cmd_lineno)&fmt(command(1))&fmt(command(2))&fmt(command(3)));  
 
          when C_DEFAULT=> zerocycle := TRUE;
                           command_length := 4;
                           jump_address   := command(3);
                           if casedone(casedepth) then                 -- if already done then branch
                             command_length := jump_address - cptr;     -- point at new address ie next when/endcase
                           else
                            casedone(casedepth) := FALSE;              -- doing this branch
                           end if;
                           ifprintf((DEBUG>=2), "BFM:%d:default %08x=%08x %08x",
                                               fmt(cmd_lineno)&fmt(command(1))&fmt(command(2))&fmt(command(3)));  

          when C_CASE  =>  zerocycle := TRUE;
                           command_length := 1;
                           casedepth := casedepth+1;
                           casedone(casedepth) := FALSE;
                           ifprintf((DEBUG>=2), "BFM:%d:case", fmt(cmd_lineno));  


          when C_ENDCASE=> zerocycle := TRUE;
                           command_length := 1;
                           casedepth := casedepth-1;
                           ifprintf((DEBUG>=2), "BFM:%d:endcase", fmt(cmd_lineno));  

         
          when C_JMPNZ =>  zerocycle := TRUE;
                           command_length := 3;
                           jump_address   := command(1);
                           if command(2)/=0 then
                             command_length := jump_address - cptr;     -- point at new address
                           end if;
                           ifprintf((DEBUG>=2), "BFM:%d:jumpnz  %08x",
                                                fmt(cmd_lineno)&fmt(command(2)));  
                     
          when C_CMP   => zerocycle := TRUE;
                          command_length := 4;
                          command_data := commandLV(2);
                          command_mask := commandLV(3);
                          cmpvalue     := to_int((commandLV(1) xor command_data) and command_mask); 
                          ifprintf(DEBUG>=2, "BFM:%d:compare  %08x==%08x Mask=%08x (RES=%08x) at %t ns",
                                               fmt(cmd_lineno)&fmt(command(1))&fmt(command_data)&fmt(command_mask)&fmt(cmpvalue)); 
                          if cmpvalue/=0 then
                             ERRORS := ERRORS + 1;

                             printf("ERROR:  compare failed %08x==%08x Mask=%08x (RES=%08x) ",
                                             fmt(command(1))&fmt(command_data)&fmt(command_mask)&fmt(cmpvalue));
                             printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(cmd_lineno,filemult)))&fmt(get_line(cmd_lineno,filemult)));
                             assert FALSE report "BFM Data Compare Error" severity ERROR ;
                          end if;  
   
          when C_CMPR  => zerocycle := TRUE;
                          command_length := 4;
                          command_data   := commandLV(2);
                          command_mask   := commandLV(3);
                          if command(1) >= command(2) and command(1) <= command(3) then
                              cmpvalue := 1;
                          else
                              cmpvalue := 0;
                          end if;
                          
                          ifprintf(DEBUG>=2, "BFM:%d:cmprange %d in %d to %d at %t ns",
                                               fmt(cmd_lineno)&fmt(command(1))&fmt(command(2))&fmt(command(3))); 
                       
                          if cmpvalue=0 then
                             ERRORS := ERRORS + 1;
                             printf("ERROR: cmprange failed %d in %d to %d",
                                               fmt(command(1))&fmt(command(2))&fmt(command(3)));
                             printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(cmd_lineno,filemult)))&fmt(get_line(cmd_lineno,filemult)));
                             assert FALSE report "BFM Data Compare Error" severity ERROR ;
                          end if;  
                                           
          when  C_INT  => zerocycle := TRUE;
                          command_length := 2;
                          nparas := command(1); 
                          stkptr := stkptr + nparas;
                          stack(stkptr)   := 0;
                          ifprintf((DEBUG>=2), "BFM:%d:int %d",
                                               fmt(cmd_lineno)&fmt(command(1)));  
                          
          when C_CALL | C_CALLP   => 
                   
                          zerocycle := TRUE;
                   
                          if cmd_cmd=C_CALL then
                            command_length := 2;
                            nparas :=0;
                          else
                            nparas := command(2);
                            command_length := 3+nparas;
                          end if;
                          call_address   := command(1);
                          return_address := cptr + command_length;
                          command_length := call_address - cptr;     -- point at new address
                          stack(stkptr)  :=  return_address;
                          stkptr   := stkptr+1;
                          if nparas>0 then
                            for i in 0 to nparas-1 loop
                              stack(stkptr) := command(3+i);
                              stkptr := stkptr+1;
                            end loop;
                          end if;
                          ifprintf((DEBUG>=2 and cmd_cmd=C_CALL), "BFM:%d:call %d",
                                                                      fmt(cmd_lineno)&fmt(call_address));  
                          ifprintf((DEBUG>=2 and cmd_cmd=C_CALLP),"BFM:%d:call %d %08x ... ",
                                                                      fmt(cmd_lineno)&fmt(call_address)&fmt(command(3)));  
                          
          when C_RET  =>  zerocycle := TRUE;
                          command_length := 2;
                          stkptr := stkptr-command(1);     -- no of values pushed
                          return_address :=0;
                          if stkptr>0 then
                            stkptr := stkptr -1;
                            return_address := stack(stkptr);
                          end if;
                          if return_address=0 then
                            bfm_done   := TRUE;
                            do_flush   := TRUE;
                            zerocycle  := FALSE;
                          else
                            command_length := return_address - cptr;   -- point at new address
                          end if;
                          
                          ifprintf((DEBUG>=2), "BFM:%d:return",
                                               fmt(cmd_lineno));  
                                                     
          when C_RETV  => zerocycle := TRUE;
                          command_length := 3;
                          stkptr := stkptr-command(1);     -- no of values pushed
                          return_address :=0;
                          if stkptr>0 then
                            stkptr := stkptr -1;
                            return_address := stack(stkptr);
                          end if;
                          return_value   := command(2);
                          if return_address=0 then
                            bfm_done   := TRUE;
                            do_flush   := TRUE;
                            zerocycle  := FALSE;
                          else
                            command_length := return_address - cptr;   -- point at new address
                          end if;
                          
                          ifprintf((DEBUG>=2), "BFM:%d:return %08x",
                                               fmt(cmd_lineno)&fmt(return_value));  
                 
             
          when C_LOOP =>  zerocycle := TRUE;
                          command_length := 5;
                          setvar   := get_storeaddr(vectors(cptr+1));
                          newvalue := command(2);
                          stack(setvar) := newvalue;
                          ifprintf(DEBUG>=2, "BFM:%d:loop %d %d %d %d ",
                                              fmt(cmd_lineno)&fmt(setvar)&fmt(command(2))&fmt(command(3))&fmt(command(4)));  
       
          when C_LOOPE=>  zerocycle := TRUE;
                          command_length := 2;
                          lptr   := command(1);           -- points at the loop commands
                          -- Get parameters from the loop command
                          for i in 2 to 4 loop
                            loopcmd(i) := get_para_value( (to_slv32(vectors(lptr))(7+i)='1'),vectors(lptr+i));
                          end loop;
                          setvar  := get_storeaddr(vectors(lptr+1));
                          n := loopcmd(4);
                          j := loopcmd(3);
                          loopcounter    := stack(setvar);
                          loopcounter    := loopcounter+n;
                          stack(setvar)  := loopcounter;
                          jump_address := lptr+5;
                          if (( n>=0 and loopcounter<=j) or (n<0 and loopcounter>=j))  then
                            command_length := jump_address - cptr;     -- point at new address
                            ifprintf(DEBUG>=2, "BFM:%d:endloop (Next Loop=%d)",
                                               fmt(cmd_lineno)&fmt(loopcounter));  
                          else
                            ifprintf(DEBUG>=2, "BFM:%d:endloop (Finished)",
                                               fmt(cmd_lineno));  
                          end if;
       
          when C_TOUT  => zerocycle := TRUE;
                          command_length := 2;
                          command_timeout := command(1);
                          ifprintf(DEBUG>=2, "BFM:%d:timeout %d",
                                               fmt(cmd_lineno)&fmt(command_timeout));  
       
          when C_RAND  => zerocycle := TRUE;
                          command_length := 2;
                          lastrandom := command(1);
                          ifprintf(DEBUG>=2, "BFM:%d:rand %d",
                                               fmt(cmd_lineno)&fmt(lastrandom));  
                              
          when C_PRINT => zerocycle := TRUE;
                          command_length  := len_string(command(1));
                          str := extract_string(cptr,vectors(cptr to cptr+command_length-1),command);
                          printf("BFM:%s",fmt(str));
                          
          when C_HEAD  => zerocycle := TRUE;
                          command_length  := len_string(command(1));
                          str := extract_string(cptr,vectors(cptr to cptr+command_length-1),command);
                          printf("################################################################");
                          printf("BFM:%s",fmt(str));
        
          when C_NOP   => command_length := 1;
                          ifprintf((DEBUG>=2),"BFM:%d:nop",
                                              fmt(cmd_lineno));
                           
          when C_FILEN => zerocycle := TRUE;
                          command_length  := len_string(command(1));

          when C_DEBUG => zerocycle := TRUE;
                          command_length := 2;
                          if DEBUGLEVEL>=0 and DEBUGLEVEL<=5 then
                            printf("BFM:%d: DEBUG - ignored due to DEBUGLEVEL generic setting",fmt(cmd_lineno));   
                          else
                            DEBUG  <= command(1);
                            printf("BFM:%d: DEBUG %d",fmt(cmd_lineno)&fmt(command(1)));   
                          end if;
                          
          when C_HRESP=>  zerocycle := FALSE;
                          command_length := 2;
                          hresp_mode :=  command(1);
                          tmpstr(1) :=  NUL;
                          if hresp_mode=2 then
                              if hresp_occured then
                                tmpstr(1 to 9) := "OCCURRED" & NUL;
                              else
                               assert FALSE report "BFM: HRESP Did Not Occur When Expected" severity ERROR;
                               ERRORS := ERRORS+1;
                              end if;
                              hresp_mode := 0;
                          end if;
                          hresp_occured := false;
                          ifprintf(DEBUG>=2, "BFM:%d:hresp %d %s",
                                              fmt(cmd_lineno)&fmt(hresp_mode)&fmt(tmpstr));  

          
          when C_STOP  => zerocycle := TRUE;
                          command_length := 2;
                          ifprintf(DEBUG>=2, "BFM:%d:stop %d",
                                               fmt(cmd_lineno)&fmt(command(1)));  
                          printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(cmd_lineno,filemult)))&fmt(get_line(cmd_lineno,filemult)));
                          case command(1) is
                            when 0 =>      assert FALSE report "BFM Script Stop Command" severity NOTE;
                            when 1 =>      assert FALSE report "BFM Script Stop Command" severity WARNING;
                            when 3 =>      assert FALSE report "BFM Script Stop Command" severity FAILURE;
                            when others => assert FALSE report "BFM Script Stop Command" severity ERROR;
                          end case; 
                          
          when C_QUIT  => bfm_done   := TRUE;
                          
          when C_ECHO  => zerocycle := TRUE;
                          ifprintf(DEBUG>=1, "BFM:%d:echo at %t ns",
                                              fmt(cmd_lineno)); 
                          command_length := 2+command(1); 
                          printf("BFM Parameter values are");
                          for i in 0 to command_length-3 loop
                            printf(" Para %d=0x%08x (%d)",fmt(i+1)&fmt(commandLV(2+i))&fmt(command(2+i)));
                          end loop;
          
          when C_FLUSH => command_length := 2;
                          wait_counter := command(1);     
                          ifprintf(DEBUG>=2, "BFM:%d:flush %d at %t ns",
                                              fmt(cmd_lineno)&fmt(wait_counter));  
                          do_flush := true;  do_case := TRUE;
                          
          when C_SFAIL => zerocycle := TRUE;
                          ERRORS := ERRORS+1;
                          ifprintf(DEBUG>=2, "BFM:%d:setfail",
                                               fmt(cmd_lineno));  
                          assert FALSE report "BFM: User Script detected ERROR" severity ERROR;
                          
          when C_SET   => zerocycle := TRUE;
                          command_length := 3;
                          setvar   := get_storeaddr(vectors(cptr+1));
                          newvalue := command(2);
                          stack(setvar) := newvalue;
                          ifprintf(DEBUG>=2, "BFM:%d:set %d= 0x%08x (%d)",
                                               fmt(cmd_lineno)&fmt(setvar)&fmt(newvalue)&fmt(newvalue));  
                                  
          when C_CALC  => zerocycle := TRUE;
                          command_length := command(2)+3;
                          setvar   := get_storeaddr(vectors(cptr+1));
                          newvalue := calculate(command(4),command(3),command(5),debug);
                          i := 6;
                          while (i<command_length) loop
                            newvalue := calculate(command(i),newvalue,command(i+1),debug);
                            i:=i+2;
                          end loop;
                          stack(setvar) := newvalue;
                          ifprintf(DEBUG>=2, "BFM:%d:set %d= 0x%08x (%d)",
                                               fmt(cmd_lineno)&fmt(setvar)&fmt(newvalue)&fmt(newvalue));  
        
          when C_LOGF  => zerocycle := TRUE;
                          characters := cmd_scmd;
                          command_length  := len_string(command(1));
                          if logfile(1)/=NUL then -- if previous file open
                             file_close(FLOG); 
                          end if;
                          logfile := extract_string(cptr,vectors(cptr to cptr+command_length-1),command);
                          printf("BFM:%d:LOGFILE %s",fmt(cmd_lineno)&fmt(logfile));
          
                          if logfile(1)/=NUL then
                            file_open(fstatus,FLOG,logfile,write_mode);
                            if fstatus=open_ok then
                            else
                              assert FALSE report "Logfile open FAILED" severity FAILURE;
                            end if;
                          end if;
                          
          when C_LOGS  => zerocycle := TRUE;
                          command_length  := 2;
                          printf("BFM:%d:LOGSTART %d",fmt(cmd_lineno)&fmt(command(1)));
                          if logfile(1)=NUL then
                            assert FALSE report "Logfile not defined, ignoring command" severity ERROR;
                          else
                            log_ahb  := (commandLV(1)(0)='1');
                            log_ext  := (commandLV(1)(1)='1');
                            log_gpio := (commandLV(1)(2)='1');
                            log_bfm  := (commandLV(1)(3)='1');
                          end if;
      
          when C_LOGE  => zerocycle := TRUE;
                          command_length  := 1;
                          printf("BFM:%d:LOGSTOP",fmt(cmd_lineno));
                          log_ahb  := false;
                          log_ext  := false;
                          log_gpio := false;
                          log_bfm  := false;
      
          when C_VERS =>  zerocycle := TRUE;
                          command_length  := 1;
                          printf("BFM:%d:VERSION",fmt(cmd_lineno));
                          printf("  BFM VHDL Version %s",fmt(BFM_VERSION));
                          printf("  BFM Date %s",fmt(BFM_DATE));
                          -- The two lines below will be autoupdated when file is commited to SubVersion
                          printf("  SVN Revision $Revision: 23452 $");
                          printf("  SVN Date $Date: 2014-09-22 15:29:48 -0700 (Mon, 22 Sep 2014) $");
                          printf("  Compiler Version %d",fmt(BFMC_VERSION));
                          printf("  Vectors Version %d",fmt(vectors_VERSION));
                          printf("  No of Vectors %d",fmt(Nvectors));
                          
                          if logfile(1)/=NUL then
                            sprintf(logstr,"%05t VR %s %s %d %d %d",fmt(BFM_VERSION)
                                                                   &fmt(BFM_DATE)
                                                                   &fmt(BFMC_VERSION)
                                                                   &fmt(vectors_version)
                                                                   &fmt(NVectors));
                            write( L, logstr ); writeline(FLOG, L);
                          end if;
       
       
          when others  => printf("BFM: Instruction %d Line Number %d Command %d",fmt(cptr)&fmt(cmd_lineno)&fmt(cmd_cmd));
                          printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(cmd_lineno,filemult)))&fmt(get_line(cmd_lineno,filemult)));
                          assert FALSE report "Instruction not yet implemented" severity ERROR;
        end case;
      end if;
      -- zero cycle was set indicating instruction does not require a clock! 
      if zerocycle then
        cmd_active := FALSE;
        cptr := cptr + command_length;
        command_length := 0;
      end if;
    end loop;
    
    
    ------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------
    -- Data Checker, needs to happen before multi cycle command processing
    
    
    DATA_MATCH_AHB := FALSE;
    DATA_MATCH_EXT := FALSE;
    DATA_MATCH_IO  := FALSE;
    if READ_P1='1' then
      EXP := RDATA_P1 and MDATA_P1;
      GOT := HRDATA and MDATA_P1;
      DATA_MATCH_AHB := (EXP=GOT);
    end if;
    if EXTRD_P1='1' then
      EXP := EIO_RDATA_P1 and EIO_MDATA_P1;
      GOT := EXT_DIN and EIO_MDATA_P1;
      DATA_MATCH_EXT := (EXP=GOT);
    end if;
    if GPIORD_P0='1' then
      EXP := EIO_RDATA_P0 and EIO_MDATA_P0;
      GOT := GP_IN and EIO_MDATA_P0;
      DATA_MATCH_IO  := (EXP=GOT);
    end if;
   
    ------------------------------------------------------------------------------------------------------------
  
  
    PIPED_ACTIVITY :=  do_read or do_write or do_bwrite or do_bread or do_poll or do_idle or do_io
                       or  to_boolean(READ_P1 or  READ_P0 or  WRITE_P0 or WRITE_P1 or EXTRD_P0 or EXTRD_P1 or GPIORD_P0);
  
    ------------------------------------------------------------------------------------------------------------
    -- Command Processing for multi cycle commands etc
    
    if do_case then
      case cmd_cmdx4 is
        when C_FLUSH => if not piped_activity then
                          if wait_counter<=1 then
                             do_case := false;
                          else
                             wait_counter := wait_counter -1;
                          end if;                      
                        end if;
                          
        when C_WAIT =>  if wait_counter<=1 then
                           do_case := FALSE;
                        else
                           wait_counter := wait_counter -1;
                        end if;
              
        when C_WAITNS | C_WAITUS =>  
                        if (NOW / 1 ns) >= wait_time then
                           do_case := FALSE;
                        end if;
                      
        when C_IRQ | C_FIQ | C_INTREQ => 
                        if int_vector=256 then
                          int_active := ( INTERRUPT/=ZERO256);
                        else
                          int_active := (INTERRUPT(int_vector)='1');
                        end if;
                        if int_active then
                          ifprintf((DEBUG>=2), "BFM:Interrupt Wait Time %d cycles",fmt(instruct_cycles));  
                          do_case := FALSE;
                        end if;
                      
        when C_EXTW  => EXTADDR_P0  <= command_address;
                        EXT_DOUT    <= command_data;
                        EXTWR_P0    <= '1';
                        do_case := FALSE;
       
        when C_EXTWM => EXTADDR_P0 <= to_slv32(burst_address+burst_count);
                        EXT_DOUT   <= to_slv32(burst_data(burst_count));
                        EXTWR_P0   <= '1';
                        burst_count := burst_count + 1;
                        if burst_count>=burst_length then
                          do_case := FALSE;
                        end if;
                        
        when C_EXTR | C_EXTRC | C_EXTMSK  => 
                        EXTADDR_P0      <= command_address;
                        EIO_RDATA_P0    <= command_data;
                        EIO_MDATA_P0    <= command_mask;
                        EIO_LINENO_P0   <= cmd_lineno;
                        EIO_RDCHK_P0    <= '1';
                        if EXTRD_P1='1' then  -- must wait until data on bus, cannot allow immediate write
                          do_case := FALSE;
                        end if;
                      
        when C_EXTWT => if EXT_WAIT='0' and wait_counter=0 then
                          ifprintf((DEBUG>=2), "BFM:Exteral Wait Time %d cycles",fmt(instruct_cycles));  
                          do_case := FALSE;
                        end if; 
                        if wait_counter>=1 then
                          wait_counter := wait_counter-1;
                        end if;
                      
        when C_IOCHK | C_IOMSK  |C_IOTST | C_IORD =>
                        EIO_RDCHK_P0  <= '1';
                        EIO_RDATA_P0  <= command_data;
                        EIO_MDATA_P0  <= command_mask;
                        EIO_LINENO_P0 <= cmd_lineno;
                        do_case := FALSE;
                      
        when C_IOWAIT=> EIO_RDATA_P0  <= command_data;
                        EIO_MDATA_P0  <= command_mask;
                        EIO_LINENO_P0 <= cmd_lineno;
                        GPIORD_P0 <= '1';
                        EIO_RDCHK_P0  <= '0';
                        if GPIORD_P0='1' and DATA_MATCH_IO then
                          GPIORD_P0 <= '0';
                          do_case := FALSE;
                          ifprintf((DEBUG>=2), "BFM:GP IO Wait Time %d cycles",fmt(instruct_cycles));  
                        end if;
                           
        --memtest resource addr size align cycles
         
        when C_MEMT | C_MEMT2 => 
                       case mt_state is
                          when idle =>   do_case := false;
                          
                          when init =>   mt_base   := command(1)+command(2);
                                         mt_base2  := 0;
                                         mt_size   := command(3);
                                         mt_align  := command(4) mod 65536;  
                                         mt_fill   := ( commandLV(4)(16)='1');            
                                         mt_scan   := ( commandLV(4)(17)='1');            
                                         mt_restart:= ( commandLV(4)(18)='1');            
                                         mt_cycles := command(5);
                                         mt_seed   := command(6);
                                         if not mt_restart then
                                           mt_image  := ( others => 0);
                                         end if;
                                         mt_reads  := 0;
                                         mt_writes := 0;
                                         mt_nops   := 0;
                                         mt_fillad := 0;
                                         mt_dual   := FALSE;
                                         if cmd_cmdx4=C_MEMT2 then   -- if two banks double size
                                           mt_base  := command(1);
                                           mt_base2 := command(2) - mt_size;
                                           mt_size  := 2 * mt_size;
                                           mt_dual  := TRUE;
                                         end if;
                                    
                                         if not mt_dual then
                                           printf("BFM:%d: memtest Started at %t ns",fmt(cmd_lineno));
                                           printf("BFM:  Address %08x Size %d Cycles %5d",fmt(mt_base)&fmt(mt_size)&fmt(mt_cycles));
                                         else
                                           printf("BFM:%d: dual memtest Started at %t ns",fmt(cmd_lineno));
                                           printf("BFM:  Address %08x & %08x Size %d Cycles %5d",fmt(mt_base)&fmt(mt_base2+mt_size/2)&fmt(mt_size/2)&fmt(mt_cycles));
                                         end if;
                                         case mt_align is
                                           when 0 => 
                                           when 1 => printf("BFM: Transfers are APB Byte aligned");
                                           when 2 => printf("BFM: Transfers are APB Half Word aligned");
                                           when 3 => printf("BFM: Transfers are APB Word aligned");
                                           when 4 => printf("BFM: Byte Writes Suppressed");
                                           when others => assert FALSE report "Illegal Align on memtest" severity FAILURE;  
                                         end case;
                                         if mt_restart then
                                           printf("BFM: memtest restarted");
                                         end if;
                                         if mt_fill then
                                           printf("BFM: Memtest Filling Memory");
                                           mt_state  := fill;
                                         elsif mt_cycles>0 then
                                           printf("BFM: Memtest Random Read Writes");
                                           mt_state  := active;
                                         elsif mt_scan then
                                           printf("BFM: Memtest Verifying Memory Content");
                                           mt_state  := scan;
                                         else
                                           mt_state  := done;
                                         end if;
                                         
                          when active | fill | scan =>  
                                         -- wait until previous cycle clears
                                         if not (do_write or do_read) then
                                           case mt_state is
                                             when active => mt_seed := random(mt_seed);
                                                            mt_ad   := mask_randomS(mt_seed,mt_size); 
                                                            mt_seed := random(mt_seed);
                                                            mt_op   := mask_randomS(mt_seed,8);
                                             when fill   => mt_ad   := mt_fillad;
                                                            mt_op   := 6;
                                             when scan   => mt_ad   := mt_fillad;
                                                            mt_op   := 2;
                                             when others =>
                                           end case;
                                           case mt_align is
                                             when 0 => -- full AHB operation, no modification required
                                             when 1 => -- byte wide APB
                                                       mt_ad := 4*(mt_ad/4);
                                                       case mt_op is
                                                         when 0 | 4 => mt_op := mt_op;      -- all to op 0 and 4
                                                         when 1 | 5 => mt_op := mt_op -1;
                                                         when 2 | 6 => mt_op := mt_op -2;
                                                         when others =>
                                                       end case; 
                                             when 2 => -- half wide APB
                                                       mt_ad := 4*(mt_ad/4);
                                                       case mt_op is
                                                         when 0 | 4 => mt_op := mt_op +1;   -- all to op 1 and 5
                                                         when 1 | 5 => mt_op := mt_op;
                                                         when 2 | 6 => mt_op := mt_op -1;
                                                         when others =>
                                                       end case; 
                                             when 3 => -- word wide APB
                                                       mt_ad := 4*(mt_ad/4);
                                                       case mt_op is
                                                         when 0 | 4 => mt_op := mt_op +2;   -- all to op 2 and 6
                                                         when 1 | 5 => mt_op := mt_op +1;
                                                         when 2 | 6 => mt_op := mt_op;
                                                         when others =>
                                                       end case;
                                             when 4 => -- Dont allow Byte writes
                                                       case mt_op is
                                                         when 4 => mt_ad := 2*(mt_ad/2);
                                                                   mt_op := 5;   -- stop a byte write, make a half write
                                                         when others =>
                                                       end case;
                                             when others =>  
                                           end case;
                                                                                           
                                           if mt_op>=0 and mt_op<=2 then -- do read
                                             case mt_op is -- see if valid data  also modify address to hold in the memory space
                                               when 0 => command_size := "000";
                                                         mt_ad := mt_ad;
                                                         mt_readok := (mt_image(mt_ad+0)>=256);
                                               when 1 => command_size := "001";
                                                         mt_ad := 2*(mt_ad/2);
                                                         mt_readok := ((mt_image(mt_ad+0)>=256) and (mt_image(mt_ad+1)>=256));
                                               when 2 => command_size := "010";
                                                         mt_ad := 4*(mt_ad/4);
                                                         mt_readok := (     (mt_image(mt_ad+0)>=256) and (mt_image(mt_ad+1)>=256)
                                                                        and (mt_image(mt_ad+2)>=256) and (mt_image(mt_ad+3)>=256));
                                               when others =>
                                             end case;
                                             
                                             if mt_readok then   -- do a read
                                               do_read  := true;
                                               mt_reads := mt_reads+1;
                                               if mt_dual and mt_ad>=mt_size/2 then
                                                 command_address := to_slv32(mt_base2+mt_ad);
                                               else
                                                 command_address := to_slv32(mt_base+mt_ad);
                                               end if;
                                               case mt_op is
                                                 when 0 => command_data := zerolv(31 downto 8)
                                                                           & to_slv32(mt_image(mt_ad+0))(7 downto 0);
                                                 when 1 => command_data := zerolv(31 downto 16)
                                                                           & to_slv32(mt_image(mt_ad+1))(7 downto 0)
                                                                           & to_slv32(mt_image(mt_ad+0))(7 downto 0);
                                                 when 2 => command_data :=   to_slv32(mt_image(mt_ad+3))(7 downto 0)
                                                                           & to_slv32(mt_image(mt_ad+2))(7 downto 0)
                                                                           & to_slv32(mt_image(mt_ad+1))(7 downto 0)
                                                                           & to_slv32(mt_image(mt_ad+0))(7 downto 0);
                                                 when others  => command_data :=  zerolv(31 downto 0);
                                               end case;
                                               command_mask := ( others => '1');
                                             else
                                               -- printf("Memtest read converted to write");
                                               mt_op := mt_op+4; -- force a write if not written
                                               -- if a byte read converted to byte write and byte
                                               -- writes not allowed make a half word write!
                                               if mt_op=4 and mt_align=4 then mt_op := 5;  end if;
                                             end if;
                                           end if;
                                    
                                           if mt_op>=4 and mt_op<=6 then -- do write
                                             do_write     := true;
                                             mt_writes    := mt_writes+1;
                                             mt_seed      := random(mt_seed);
                                             command_data := to_slv32(mt_seed);
                                             case mt_op is -- update image
                                               when 4 => command_size := "000";   -- byte
                                                         mt_ad := mt_ad;
                                                         mt_image(mt_ad+0) := 256 + to_int_unsigned(command_data(7 downto 0));
                                               when 5 => command_size := "001";   -- half
                                                         mt_ad := 2*(mt_ad/2);
                                                         mt_image(mt_ad+0) := 256 + to_int_unsigned(command_data(7 downto 0));
                                                         mt_image(mt_ad+1) := 256 + to_int_unsigned(command_data(15 downto 8));
                                               when 6 => command_size := "010";   -- word
                                                         mt_ad := 4*(mt_ad/4);
                                                         mt_image(mt_ad+0) := 256 + to_int_unsigned(command_data(7 downto 0));
                                                         mt_image(mt_ad+1) := 256 + to_int_unsigned(command_data(15 downto 8));
                                                         mt_image(mt_ad+2) := 256 + to_int_unsigned(command_data(23 downto 16));
                                                         mt_image(mt_ad+3) := 256 + to_int_unsigned(command_data(31 downto 24));                                           
                                               when others =>
                                             end case;
                                             if mt_dual and mt_ad>=mt_size/2 then
                                               command_address := to_slv32(mt_base2+mt_ad);
                                             else
                                               command_address := to_slv32(mt_base+mt_ad);
                                             end if;
                                           end if;
                                           
                                           if mt_op=3 or mt_op=7 then -- insert one wait cycle
                                             mt_nops := mt_nops + 1;
                                           end if;
                                           
                                           mt_fillad := mt_fillad+4;
                                           case mt_state is
                                             when active =>  if mt_cycles>0 then
                                                               mt_cycles := mt_cycles-1;
                                                             elsif  mt_scan then
                                                               mt_fillad :=0;
                                                               mt_state := scan;
                                                               printf("BFM: Memtest Verifying Memory Content");
                                                             else
                                                               mt_state := done;
                                                             end if;
                                             when fill   =>  if mt_fillad>=mt_size then
                                                               if mt_cycles=0 then
                                                                 if mt_scan then
                                                                   mt_fillad :=0;
                                                                   mt_state := scan;
                                                                   printf("BFM: Memtest Verifying Memory Content");
                                                                 else
                                                                   mt_state := done;
                                                                 end if;
                                                               else
                                                                 mt_state := active;
                                                                 printf("BFM: Memtest Random Read Writes");
                                                               end if;
                                                             end if;                
                                             when scan   =>  if mt_fillad>=mt_size then
                                                               mt_state := done;
                                                             end if;
                                             when others =>                         
                                           end case;
                                           timer := command_timeout; -- also reset the timer as we completed a cycle  
                                         end if;
                                         
                          when done => if not PIPED_ACTIVITY then
                                         mt_state := idle;
                                         printf("BFM: bfmtest complete  Writes %d  Reads %d  Nops %d",fmt(mt_writes)&fmt(mt_reads)&fmt(mt_nops)); 
                                       end if;               
                        end case;
        when others =>
      end case;
    end if;
  
  
    ------------------------------------------------------------------------------------------------------------
    -- AMBA Bus Cycles

    --- this inserts AHB BUSY cycles
    if count_xrate=0 then
      insert_busy := false;
      count_xrate := su_xrate;
    else
      count_xrate := count_xrate-1;
      insert_busy := true;
    end if;
    
    -----------
        
    if HREADY='1' then
      HTRANS_P0 <= "00";       -- IDLE
      HWRITE_P0 <= '0';
      -- AMBA Cycles
      WRITE_P0 <= '0';
      READ_P0  <= '0';
      POLL_P0  <= '0';
      if WRITE_P0='1' or READ_P0='1' then
        RDCHK_P0 <= '0';
      end if;
      if do_write and HREADY='1' then
        HADDR_P0     <= command_address;
        HWRITE_P0    <= '1';
        HBURST_P0    <= ahb_burst;
        HTRANS_P0    <= "10";
        HMASTLOCK_P0 <= ahb_lock;
        HPROT_P0     <= ahb_prot;
        HSIZE_P0     <= command_size;
        WDATA_P0     <= align_data(command_size,command_address(1 downto 0),command_data,su_align);
        WRITE_P0     <= '1';
        LINENO_P0    <= cmd_lineno;
        do_write     := false;
      end if;
      if do_read and HREADY='1' then
        HADDR_P0     <= command_address;
        HWRITE_P0    <= '0';
        HBURST_P0    <= ahb_burst;
        HTRANS_P0    <= "10";
        HMASTLOCK_P0 <= ahb_lock;
        HPROT_P0     <= ahb_prot;
        HSIZE_P0     <= command_size;
        RDATA_P0     <= align_data(command_size,command_address(1 downto 0),command_data,su_align);
        MDATA_P0     <= align_mask(command_size,command_address(1 downto 0),command_mask,su_align);
        LINENO_P0    <= cmd_lineno;
        READ_P0      <= '1';
        RDCHK_P0     <= '1';
        do_read      := false;
      end if;
      if do_idle and HREADY='1' then
        HADDR_P0     <= command_address;
        HWRITE_P0    <= ahbc_hwrite;
        HBURST_P0    <= ahbc_burst;
        HTRANS_P0    <= ahbc_htrans;
        HMASTLOCK_P0 <= ahbc_lock;
        HPROT_P0     <= ahbc_prot;
        HSIZE_P0     <= command_size;
        WDATA_P0     <= align_data(command_size,command_address(1 downto 0),command_data,su_align);
        WRITE_P0     <= '1';      -- use write pipe line to control timing
        LINENO_P0    <= cmd_lineno;
        do_idle      := false; 
      end if;
      if do_poll and HREADY='1' then
        HADDR_P0     <= command_address;
        HWRITE_P0    <= '0';
        HBURST_P0    <= ahb_burst;
        HMASTLOCK_P0 <= ahb_lock;
        HPROT_P0     <= ahb_prot;
        HSIZE_P0     <= command_size;
        RDATA_P0     <= align_data(command_size,command_address(1 downto 0),command_data,su_align);
        MDATA_P0     <= align_mask(command_size,command_address(1 downto 0),command_mask,su_align);
        LINENO_P0    <= cmd_lineno;
        if READ_P0='1' or READ_P1='1' then
          HTRANS_P0 <= "00";        -- No cycle, waiting to check data
        else
          HTRANS_P0 <= "10";
          READ_P0   <= '1';
          POLL_P0   <= '1';
        end if;
        if POLL_P1='1' and DATA_MATCH_AHB then
          do_poll := false;
        end if;
      end if;  
      if do_bwrite and HREADY='1' then
        HADDR_P0     <= command_address;
        HWRITE_P0    <= '1';
        HBURST_P0    <= ahb_burst;
        HMASTLOCK_P0 <= ahb_lock;
        HPROT_P0     <= ahb_prot;
        HSIZE_P0     <= command_size;
        LINENO_P0    <= cmd_lineno;
        if insert_busy then
          HTRANS_P0 <= "01";
        else
          WDATA_P0 <= align_data(command_size,command_address(1 downto 0),to_slv32(burst_data(burst_count)),su_align);
          WRITE_P0 <= '1';
          if burst_count=0 or cmd_size=3 or bound1k(su_noburst,command_address) then
            HTRANS_P0 <= "10";
          else
            HTRANS_P0 <= "11";
          end if;
          command_address := to_std_logic( to_unsigned(command_address) + burst_addrinc);
          burst_count := burst_count+1;
          if burst_count=burst_length then
            do_bwrite := false;
          end if;
        end if;
      end if;
      if do_bread and HREADY='1' then
        HADDR_P0     <= command_address;
        HWRITE_P0    <= '0';
        HBURST_P0    <= ahb_burst;
        HMASTLOCK_P0 <= ahb_lock;
        HPROT_P0     <= ahb_prot;
        HSIZE_P0     <= command_size;
        LINENO_P0    <= cmd_lineno;
        if insert_busy then
          HTRANS_P0 <= "01";
        else
          RDATA_P0   <= align_data(command_size,command_address(1 downto 0),to_slv32(burst_data(burst_count)),su_align);
          MDATA_P0   <= align_mask(command_size,command_address(1 downto 0),command_mask,su_align);
          READ_P0    <= '1';
          RDCHK_P0   <= '1';
          if burst_count=0 or cmd_size=3 or bound1k(su_noburst,command_address)  then
            HTRANS_P0 <= "10";
          else
            HTRANS_P0 <= "11";
          end if;
          command_address := to_std_logic( to_unsigned(command_address) + burst_addrinc);
          burst_count := burst_count+1;
          if burst_count=burst_length then
            do_bread := false;
          end if;
        end if;
      end if;
    
    end if; 
  
    ------------------------------------------------------------------------------------------------------------
    -- Read Pipelines
    
    if HREADY='1'  then
      WRITE_P1   <= WRITE_P0;
      READ_P1    <= READ_P0;
      POLL_P1    <= POLL_P0;
      RDCHK_P1   <= RDCHK_P0;
      RDATA_P1   <= RDATA_P0;
      MDATA_P1   <= MDATA_P0;
      LINENO_P1  <= LINENO_P0;
      HADDR_P1   <= HADDR_P0;
      HSIZE_P1   <= HSIZE_P0;
    end if;   
        
    EXTRD_P1       <= EXTRD_P0;
    EXTADDR_P1     <= EXTADDR_p0;
    EIO_RDCHK_P1   <= EIO_RDCHK_P0;
    EIO_RDATA_P1   <= EIO_RDATA_P0;
    EIO_MDATA_P1   <= EIO_MDATA_P0;
    EIO_LINENO_P1  <= EIO_LINENO_P0;
        
    ------------------------------------------------------------------------------------------------------------
    -- Write Data Pipeline and logger
 
    if HREADY='1' then
      if WRITE_P0='1' then
        WDATA_P1 <= WDATA_P0;
      else
        WDATA_P1 <= ( others => '0');
      end if;
      if WRITE_P1='1' and DEBUG>=3 then
        printf("BFM: Data Write %08x %08x",fmt(HADDR_P1)&fmt(WDATA_P1));
      end if;
      if LOG_AHB and WRITE_P1='1' then
        sprintf(logstr,"%05t AW %c %08x %08x",fmt(to_char(HSIZE_P1))&fmt(HADDR_P1)&fmt(WDATA_P1));
        write( L, logstr ); writeline(FLOG, L);
      end if;
    end if;
    
    if GPIOWR_P0='1' and LOG_GPIO then
      sprintf(logstr,"%05t GW   %08x ",fmt(GPOUT_P0));
      write( L, logstr ); writeline(FLOG, L);
    end if;
    
    if EXTWR_P0='1' and LOG_EXT then
      sprintf(logstr,"%05t EW   %08x %08x",fmt(EXTADDR_P0)&fmt(EXT_DOUT));
      write( L, logstr ); writeline(FLOG, L);
    end if;
   
    ------------------------------------------------------------------------------------------------------------
    -- Read Data Pipeline, Checker and logger
 
    -- AHB Read Checks
    if HREADY='1'  then
      if READ_P1='1' then
        if DEBUG>=3 then
          if MDATA_P1=ZEROLV then
            printf("BFM: Data Read %08x %08x",fmt(HADDR_P1)&fmt(HRDATA));
          else
            printf("BFM: Data Read %08x %08x MASK:%08x",fmt(HADDR_P1)&fmt(HRDATA)&fmt(MDATA_P1));
          end if;
        end if;
        if LOG_AHB then
          sprintf(logstr,"%05t AR %c %08x %08x",fmt(to_char(HSIZE_P1))&fmt(HADDR_P1)&fmt(HRDATA));
          write( L, logstr ); writeline(FLOG, L);
        end if;
        
        if storeaddr>=0 then
          stack(storeaddr) := to_int(align_read(HSIZE_P1,HADDR_P1(1 downto 0),HRDATA,su_align));
        end if;
        if RDCHK_P1='1' and not DATA_MATCH_AHB then
          ERRORS := ERRORS + 1;
          printf("ERROR: AHB Data Read Comparison failed Addr:%08x  Got:%08x  EXP:%08x  (MASK:%08x)",fmt(HADDR_P1)&fmt(HRDATA)&fmt(RDATA_P1)&fmt(MDATA_P1));
          printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(lineno_P1,filemult)))&fmt(get_line(lineno_P1,filemult)));
          assert FALSE report "BFM Data Compare Error" severity ERROR ;
          if LOG_AHB then
            sprintf(logstr,"%05t ERROR  Addr:%08x  Got:%08x  EXP:%08x  (MASK:%08x)",fmt(HADDR_P1)&fmt(HRDATA)&fmt(RDATA_P1)&fmt(MDATA_P1));
            write( L, logstr ); writeline(FLOG, L);
          end if;
        end if; 
      end if; 
    end if;
    
    
    -- IO Port Checker  Done on P0
    if GPIORD_P0='1' then
      if DEBUG>=3 then
        if EIO_MDATA_P0=ZEROLV then
          printf("BFM: GP IO Data Read %08x",fmt(GP_IN));
        else
          printf("BFM: GP IO Data Read %08x MASK:%08x",fmt(GP_IN)&fmt(EIO_MDATA_P0));
        end if;
      end if;
      if LOG_GPIO then
        sprintf(logstr,"%05t GR   %08x ",fmt(EIO_RDATA_P0));
        write( L, logstr ); writeline(FLOG, L);
      end if;
      if storeaddr>=0 then
        stack(storeaddr) := to_int(GP_IN);
      end if;
      if EIO_RDCHK_P0='1' and not DATA_MATCH_IO then
        ERRORS := ERRORS + 1;
        printf("GPIO input not as expected  Got:%08x  EXP:%08x  (MASK:%08x)",fmt(GP_IN)&fmt(EIO_RDATA_P0)&fmt(EIO_MDATA_P0));
        printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(EIO_lineno_P0,filemult)))&fmt(get_line(EIO_lineno_P0,filemult)));
        assert FALSE report "BFM GPIO Compare Error" severity ERROR ;
        if LOG_GPIO then
          sprintf(logstr,"ERROR  Got:%08x  EXP:%08x  (MASK:%08x)",fmt(GP_IN)&fmt(EIO_RDATA_P0)&fmt(EIO_MDATA_P0));
          write( L, logstr ); writeline(FLOG, L);
        end if;
      end if;
    end if;
    
    -- Extention Read Checks
    if EXTRD_P1='1' then
      if DEBUG>=3 then
        if EIO_MDATA_P1=ZEROLV then
          printf("BFM: Extention Data Read %08x %08x",fmt(EXTADDR_P1)&fmt(EXT_DIN));
        else
          printf("BFM: Extention Data Read %08x %08x MASK:%08x",fmt(EXTADDR_P1)&fmt(EXT_DIN)&fmt(EIO_MDATA_P1));
        end if;
      end if;
      if LOG_EXT then
        sprintf(logstr,"%05t ER   %08x %08x",fmt(EXTADDR_P1)&fmt(EIO_RDATA_P1));
        write( L, logstr ); writeline(FLOG, L);
      end if;
      
      if storeaddr>=0 then
        stack(storeaddr) := to_int(EXT_DIN);
      end if;
      if EIO_RDCHK_P1='1' and not DATA_MATCH_EXT then
        ERRORS := ERRORS + 1;
        printf("ERROR: Extention Data Read Comparison failed  Got:%08x  EXP:%08x  (MASK:%08x)",fmt(EXT_DIN)&fmt(EIO_RDATA_P1)&fmt(EIO_MDATA_P1));
        printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(EIO_lineno_P1,filemult)))&fmt(get_line(EIO_lineno_P1,filemult)));
        assert FALSE report "BFM Extention Data Compare Error" severity ERROR ;
        if LOG_EXT then
          sprintf(logstr,"ERROR  Got:%08x  EXP:%08x  (MASK:%08x)",fmt(EXT_DIN)&fmt(EIO_RDATA_P1)&fmt(EIO_MDATA_P1));
          write( L, logstr ); writeline(FLOG, L);
        end if;
      end if; 
    end if;
   
    ------------------------------------------------------------------------------------------------------------
    -- routines that require operation after AHB cycle completes

    AHB_ACTIVITY :=  do_read or do_write or do_bwrite or do_bread or do_poll or do_idle 
                     or to_boolean( READ_P0 or WRITE_P0 or EXTRD_P0 or GPIORD_P0)
                     or ( to_boolean( (READ_P1 or WRITE_P1) and not HREADY));

    if do_case then
      case cmd_cmdx4 is
        when C_CHKT  => if not AHB_ACTIVITY then
                          ifprintf((DEBUG>=2),"BFM:%d:checktime was %d cycles ",fmt(cmd_lineno)&fmt(instruct_cycles));
                          if instruct_cycles<command(1) or  instruct_cycles>command(2) then
                            printf("BFM: ERROR checktime %d %d Actual %d",fmt(command(1))&fmt(command(2))&fmt(instruct_cycles));
                            printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(cmd_lineno,filemult)))&fmt(get_line(cmd_lineno,filemult)));
                            assert FALSE report "BFM checktime failure" severity ERROR ; 
                            ERRORS := ERRORS+1;
                          end if;
                          do_case := false;
                          var_licycles :=  instruct_cycles;
                        end if; 
        when C_CKTIM => if not AHB_ACTIVITY then
                          instructions_timer := instructions_timer-1; -- need to allow for check instruction
                          ifprintf((DEBUG>=2),"BFM:%d:checktimer was %d cycles ",fmt(cmd_lineno)&fmt(instructions_timer));
                          if instructions_timer<command(1) or  instructions_timer>command(2) then
                            printf("BFM: ERROR checktimer %d %d Actual %d",fmt(command(1))&fmt(command(2))&fmt(instructions_timer));
                            printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(cmd_lineno,filemult)))&fmt(get_line(cmd_lineno,filemult)));
                            assert FALSE report "BFM checktimer failure" severity ERROR ; 
                            ERRORS := ERRORS+1;
                          end if;
                          do_case := false;
                          var_ltimer := instructions_timer;
                        end if; 
        when others =>
      end case;
    end if;
    
    
    ------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------
    -- Watchdog timer
    if bfm_run then
      if timer >0 then
        timer := timer-1;
      else
        timer := command_timeout;
        printf("       BFM Command Timeout Occured");
        printf("       Stimulus file %s  Line No %d",fmt(filenames(get_file(lineno_P1,filemult)))&fmt(get_line(lineno_P1,filemult)));
        
        assert     BFM_DONE  report "BFM Command timeout occured" severity ERROR;
        assert not BFM_DONE  report "BFM Completed and timeout occured" severity ERROR;
      end if;
    else
      timer := command_timeout;
    end if;
    
    if errors>0 then
      FAILED_P0 <= '1';
    end if;
   
    -- See if command done, if so allow next command to be started
    if do_case or do_read or do_write or do_bwrite or do_bread or do_poll or do_idle or ((do_flush or su_flush) and PIPED_ACTIVITY) then
      cmd_active := TRUE;
    else
      do_flush := false;
      if not bfm_done then
        cmd_active := FALSE;
      end if;
      cptr := cptr + command_length;
      command_length := 0;
      if OPMODE>0 then
        if bfm_single or bfm_done then
          bfm_run := false;
          cmd_active := false;
        end if;
      end if;
    end if;
 
    ------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------

      
    if FINISHED_P0='0' and OPMODE=0 and bfm_done and not piped_activity then
      printf("###########################################################");
      printf(" ");
      if ERRORS=0 then
         printf("BFM Simulation Complete - %d Instructions - NO ERRORS",fmt(instuct_count)); 
      else
         printf("BFM Simulation Complete - %d Instructions - %d ERRORS OCCURED",fmt(instuct_count)&fmt(ERRORS)); 
      end if;
      printf(" ");
      printf("###########################################################");
      printf(" ");
      FINISHED_P0 <= '1';
      cmd_active := true;
      bfm_run    := false;
          
      if logfile(1)/=NUL then   -- close log file
        file_close(FLOG); 
      end if;  
    
      case su_endsim is
        when 1 => assert FALSE report "BFM Completed" severity NOTE;
        when 2 => assert FALSE report "BFM Completed" severity WARNING;
        when 3 => assert FALSE report "BFM Completed" severity ERROR;
        when 4 => assert FALSE report "BFM Completed" severity FAILURE;
        when others => -- do nothing
      end case; 
    
    end if;
    
    CON_BUSY  <= to_std_logic(bfm_run or piped_activity) ;
    INSTR_OUT <= to_slv32(cptr);
  end if;
end process;    


GP_OUT   <= GPOUT_P0   after TPDns;
EXT_WR   <= EXTWR_P0   after TPDns; 
EXT_RD   <= EXTRD_P0   after TPDns; 
EXT_ADDR <= EXTADDR_P0 after TPDns;

EXT_DATA <= EXT_DOUT when EXTWR_P0='1' else ( others => 'Z')  after TPDns;
EXT_DIN  <= EXT_DATA;

process(HADDR_P0,SYSRSTN)
begin
  if SYSRSTN='0' then
    HSEL_P0 <= ( others => '0');
  else
    for i in 0 to 15 loop
      HSEL_P0(i) <= to_std_logic( to_integer((to_unsigned(HADDR_P0(31 downto 28)))) = i);
    end loop;
  end if;
end process;

HCLK       <= 'X'              when DRIVEX_CLK else (SYSCLK or HCLK_STOP);
PCLK       <= 'X'              when DRIVEX_CLK else (SYSCLK or HCLK_STOP);
HRESETN    <= 'X'              when DRIVEX_RST else HRESETN_P0   after TPDns;
HADDR      <= (others => 'X')  when DRIVEX_ADD else HADDR_P0     after TPDns;     
HWDATA     <= (others => 'X')  when DRIVEX_DAT else WDATA_P1     after TPDns;
HBURST     <= (others => 'X')  when DRIVEX_ADD else HBURST_P0    after TPDns;    
HMASTLOCK  <= 'X'              when DRIVEX_ADD else HMASTLOCK_P0 after TPDns; 
HPROT      <= (others => 'X')  when DRIVEX_ADD else HPROT_P0     after TPDns;     
HSIZE      <= (others => 'X')  when DRIVEX_ADD else HSIZE_P0     after TPDns;     
HTRANS     <= (others => 'X')  when DRIVEX_ADD else HTRANS_P0    after TPDns;    
HWRITE     <= 'X'              when DRIVEX_ADD else HWRITE_P0    after TPDns;    
HSEL       <= (others => 'X')  when DRIVEX_ADD else HSEL_P0      after TPDns;

CON_DATA <= CON_DOUT when CON_RDP1='1' else ( others => 'Z') after TPDns;

CON_DIN  <= CON_DATA;

FINISHED <= FINISHED_P0 after TPDns;
FAILED   <= FAILED_P0   after TPDns;

end BFM;




 