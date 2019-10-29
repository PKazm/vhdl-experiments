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

use work.bfm_package.all;


entity BFM_AHBL is
  generic ( VECTFILE         : string  := "test.vec";
            MAX_INSTRUCTIONS : integer := 16384;
            MAX_STACK        : integer := 1024;
            MAX_MEMTEST      : integer := 65536;
            TPD              : integer range 0 to 1000 := 1;
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
         HADDR       : out   std_logic_vector(31 downto 0);
         HCLK        : out   std_logic;
         HRESETN     : out   std_logic;
         -- AHB Interface
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
         FINISHED    : out   std_logic;
         FAILED      : out   std_logic
       );
end BFM_AHBL;


architecture BFM of BFM_AHBL is

signal Logic0   : std_logic := '0'; 
signal INSTR_IN : std_logic_vector(31 downto 0) := ( others => '0');
signal CON_ADDR : std_logic_vector(15 downto 0) := ( others => '0');
signal CON_DATA : std_logic_vector(31 downto 0) := ( others => 'Z');

begin

    
UBFM: BFM_MAIN                            
 generic map ( OPMODE           => 0,
               CON_SPULSE       => 0,
			   VECTFILE         =>  VECTFILE,        
               MAX_INSTRUCTIONS =>  MAX_INSTRUCTIONS,
               TPD              =>  TPD,
               MAX_STACK        =>  MAX_STACK,       
               MAX_MEMTEST      =>  MAX_MEMTEST,       
               DEBUGLEVEL       =>  DEBUGLEVEL,
               ARGVALUE0        =>  ARGVALUE0, 
               ARGVALUE1        =>  ARGVALUE1, 
               ARGVALUE2        =>  ARGVALUE2, 
               ARGVALUE3        =>  ARGVALUE3, 
               ARGVALUE4        =>  ARGVALUE4, 
               ARGVALUE5        =>  ARGVALUE5, 
               ARGVALUE6        =>  ARGVALUE6, 
               ARGVALUE7        =>	ARGVALUE7, 
               ARGVALUE8        =>	ARGVALUE8, 
               ARGVALUE9        =>	ARGVALUE9, 
               ARGVALUE10       =>	ARGVALUE10,
               ARGVALUE11       =>	ARGVALUE11,
               ARGVALUE12       =>	ARGVALUE12,
               ARGVALUE13       =>	ARGVALUE13,
               ARGVALUE14       =>	ARGVALUE14,
               ARGVALUE15       =>	ARGVALUE15,
               ARGVALUE16       =>	ARGVALUE16,
               ARGVALUE17       =>	ARGVALUE17,
               ARGVALUE18       =>	ARGVALUE18,
               ARGVALUE19       =>	ARGVALUE19,
               ARGVALUE20       =>	ARGVALUE20,
               ARGVALUE21       =>	ARGVALUE21,
               ARGVALUE22       =>	ARGVALUE22,
               ARGVALUE23       =>	ARGVALUE23,
               ARGVALUE24       =>	ARGVALUE24,
               ARGVALUE25       =>	ARGVALUE25,
               ARGVALUE26       =>	ARGVALUE26,
               ARGVALUE27       =>	ARGVALUE27,
               ARGVALUE28       =>	ARGVALUE28,
               ARGVALUE29       =>	ARGVALUE29,
               ARGVALUE30       =>	ARGVALUE30,
               ARGVALUE31       =>	ARGVALUE31,
               ARGVALUE32       =>	ARGVALUE32,
               ARGVALUE33       =>	ARGVALUE33,
               ARGVALUE34       =>	ARGVALUE34,
               ARGVALUE35       =>	ARGVALUE35,
               ARGVALUE36       =>	ARGVALUE36,
               ARGVALUE37       =>	ARGVALUE37,
               ARGVALUE38       =>	ARGVALUE38,
               ARGVALUE39       =>	ARGVALUE39,
               ARGVALUE40       =>	ARGVALUE40,
               ARGVALUE41       =>	ARGVALUE41,
               ARGVALUE42       =>	ARGVALUE42,
               ARGVALUE43       =>	ARGVALUE43,
               ARGVALUE44       =>	ARGVALUE44,
               ARGVALUE45       =>	ARGVALUE45,
               ARGVALUE46       =>	ARGVALUE46,
               ARGVALUE47       =>	ARGVALUE47,
               ARGVALUE48       =>	ARGVALUE48,
               ARGVALUE49       =>	ARGVALUE49,
               ARGVALUE50       =>	ARGVALUE50,
               ARGVALUE51       =>	ARGVALUE51,
               ARGVALUE52       =>	ARGVALUE52,
               ARGVALUE53       =>	ARGVALUE53,
               ARGVALUE54       =>	ARGVALUE54,
               ARGVALUE55       =>	ARGVALUE55,
               ARGVALUE56       =>	ARGVALUE56,
               ARGVALUE57       =>	ARGVALUE57,
               ARGVALUE58       =>	ARGVALUE58,
               ARGVALUE59       =>	ARGVALUE59,
               ARGVALUE60       =>	ARGVALUE60,
               ARGVALUE61       =>	ARGVALUE61,
               ARGVALUE62       =>	ARGVALUE62,
               ARGVALUE63       =>	ARGVALUE63,
               ARGVALUE64       =>	ARGVALUE64,
               ARGVALUE65       =>	ARGVALUE65,
               ARGVALUE66       =>	ARGVALUE66,
               ARGVALUE67       =>	ARGVALUE67,
               ARGVALUE68       =>	ARGVALUE68,
               ARGVALUE69       =>	ARGVALUE69,
               ARGVALUE70       =>	ARGVALUE70,
               ARGVALUE71       =>	ARGVALUE71,
               ARGVALUE72       =>	ARGVALUE72,
               ARGVALUE73       =>	ARGVALUE73,
               ARGVALUE74       =>	ARGVALUE74,
               ARGVALUE75       =>	ARGVALUE75,
               ARGVALUE76       =>	ARGVALUE76,
               ARGVALUE77       =>	ARGVALUE77,
               ARGVALUE78       =>	ARGVALUE78,
               ARGVALUE79       =>	ARGVALUE79,
               ARGVALUE80       =>	ARGVALUE80,
               ARGVALUE81       =>	ARGVALUE81,
               ARGVALUE82       =>	ARGVALUE82,
               ARGVALUE83       =>	ARGVALUE83,
               ARGVALUE84       =>	ARGVALUE84,
               ARGVALUE85       =>	ARGVALUE85,
               ARGVALUE86       =>	ARGVALUE86,
               ARGVALUE87       =>	ARGVALUE87,
               ARGVALUE88       =>	ARGVALUE88,
               ARGVALUE89       =>	ARGVALUE89,
               ARGVALUE90       =>	ARGVALUE90,
               ARGVALUE91       =>	ARGVALUE91,
               ARGVALUE92       =>	ARGVALUE92,
               ARGVALUE93       =>	ARGVALUE93,
               ARGVALUE94       =>	ARGVALUE94,
               ARGVALUE95       =>	ARGVALUE95,
               ARGVALUE96       =>	ARGVALUE96,
               ARGVALUE97       =>	ARGVALUE97,
               ARGVALUE98       =>	ARGVALUE98,
               ARGVALUE99       => 	ARGVALUE99
             )        		
 port map  ( SYSCLK     => SYSCLK,    
             SYSRSTN    => SYSRSTN,   
             HADDR      => HADDR,     
             HCLK       => HCLK,   
             PCLK       => open,   
             HRESETN    => HRESETN,   
             HBURST     => HBURST,    
             HMASTLOCK  => HMASTLOCK, 
             HPROT      => HPROT,     
             HSIZE      => HSIZE,     
             HTRANS     => HTRANS,    
             HWRITE     => HWRITE,    
             HWDATA     => HWDATA,    
             HRDATA     => HRDATA,    
             HREADY     => HREADY,    
             HRESP      => HRESP,     
             HSEL       => HSEL,      
             INTERRUPT  => INTERRUPT, 
             GP_OUT     => GP_OUT,    
             GP_IN      => GP_IN,    
             EXT_WR     => EXT_WR,   
             EXT_RD     => EXT_RD,   
             EXT_ADDR   => EXT_ADDR, 
             EXT_DATA   => EXT_DATA, 
             EXT_WAIT   => EXT_WAIT, 
	         CON_ADDR   => CON_ADDR,
             CON_DATA   => CON_DATA,
             CON_RD     => Logic0,
             CON_WR     => Logic0,
             CON_BUSY   => open,
             INSTR_OUT  => open, 
             INSTR_IN   => INSTR_IN,  
             FINISHED   => FINISHED,  
             FAILED     => FAILED    
       );



end BFM;