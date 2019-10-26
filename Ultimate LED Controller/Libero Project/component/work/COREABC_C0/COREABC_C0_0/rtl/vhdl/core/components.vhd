-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  components.vhd
--
-- Description: Simple APB Bus Controller
--              Top level declaration
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


package COREABC_C0_COREABC_C0_0_components is


component COREABC_C0_COREABC_C0_0_COREABC
  generic ( FAMILY      : integer range 0 to 99  ;
            APB_AWIDTH  : integer range 8 to 16  ;
            APB_DWIDTH  : integer range 8 to 32  ;
            APB_SDEPTH  : integer range 1 to 16  ;
            ICWIDTH     : integer range 1 to 16  ;
            ZRWIDTH     : integer range 0 to 16  ;
            IFWIDTH     : integer range 0 to 28  ;
            IIWIDTH     : integer range 1 to 32  ;
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
            EN_MULT     : integer range 0 to 3   ;
            EN_ACM      : integer range 0 to 1   ;
            EN_DATAM    : integer range 0 to 3   ;
            EN_INT      : integer range 0 to 2   ;
            EN_IOREAD   : integer range 0 to 1   ;
            EN_IOWRT    : integer range 0 to 1   ;
            EN_ALURAM   : integer range 0 to 1   ;
            EN_INDIRECT : integer range 0 to 1   ;
            ISRADDR     : integer range 0 to 65535;
            DEBUG       : integer range 0 to 1   ;
            INSMODE     : integer range 0 to 2   ;
            INITWIDTH   : integer range 1 to 16  ;
            TESTMODE    : integer range 0 to 99 :=0;
            ACT_CALIBRATIONDATA : integer range 0 to 1 := 1;
            IMEM_APB_ACCESS     : integer range 0 to 2 := 2;
            UNIQ_STRING_LENGTH  : integer range 1 to 256 := 10
           );
   port ( PCLK        : in  std_logic;
         NSYSRESET   : in  std_logic;

         -- APB Interface
         PRESETN     : out std_logic;
         PENABLE_M   : out std_logic;
         PWRITE_M    : out std_logic;
         PSEL_M      : out std_logic;
         PADDR_M     : out std_logic_vector( 19 downto 0);
         PWDATA_M    : out std_logic_vector( APB_DWIDTH-1 downto 0);
         PRDATA_M    : in  std_logic_vector( APB_DWIDTH-1 downto 0);
         PREADY_M    : in  std_logic;
         PSLVERR_M   : in  std_logic;

         -- Misc IO
         IO_IN       : in  std_logic_vector( IIWIDTH-1 downto 0);
         IO_OUT      : out std_logic_vector( IOWIDTH-1 downto 0);

         -- Interrupt
         INTREQ      : in  std_logic;
         INTACT      : out std_logic;

         -- RAM Initialization Port
         INITDATVAL  : in  std_logic;
         INITDONE    : in  std_logic;
         INITADDR    : in  std_logic_vector(INITWIDTH-1 downto 0);
         INITDATA    : in  std_logic_vector(8 downto 0);

         -- APB slave interface
         PSEL_S      : in  std_logic;
         PENABLE_S   : in  std_logic;
         PWRITE_S    : in  std_logic;
         PADDR_S     : in  std_logic_vector(APB_AWIDTH-1 downto 0);
         PWDATA_S    : in  std_logic_vector(APB_DWIDTH-1 downto 0);
         PRDATA_S    : out std_logic_vector(APB_DWIDTH-1 downto 0);
         PSLVERR_S   : out std_logic;
         PREADY_S    : out std_logic
       );

end component;

end COREABC_C0_COREABC_C0_0_components;
