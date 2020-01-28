LIBRARY ieee;
   USE ieee.std_logic_1164.all;
-- ********************************************************************/
-- Microsemi Corporation Proprietary and Confidential
-- Copyright 2015 Microsemi Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
--
-- CoreTimer User Testbench
--
--
-- SVN Revision Information:
-- SVN $Revision: 23512 $
-- SVN $Date: 2014-10-13 05:00:07 -0700 (Mon, 13 Oct 2014) $
--
-- Resolved SARs:
--
-- Notes:
--
-- *********************************************************************/
ENTITY testbench IS   
    GENERIC (
       APB_HALF_PERIOD          : TIME := 10 ns; -- Generates a 50MHz APB clock
       COUNTER_WIDTH            : INTEGER := 32;        
       INTERRUPT_LEVEL          : INTEGER := 1;
       FAMILY                   : INTEGER := 19
   );
END testbench;

ARCHITECTURE trans OF testbench IS
    COMPONENT BFM_APB is
        GENERIC ( 
                    VECTFILE         : STRING  := "TEST.VEC"                 
                );                                                   
        PORT (  SYSCLK      : in    STD_LOGIC;                     
                SYSRSTN     : in    STD_LOGIC;                     
                -- APB Interface                                       
                PCLK        : out   STD_LOGIC;                     
                PRESETN     : out   STD_LOGIC;                     
                PADDR       : out   STD_LOGIC_VECTOR(31 DOWNTO 0); 
                PENABLE     : out   STD_LOGIC;                     
                PWRITE      : out   STD_LOGIC;                     
                PWDATA      : out   STD_LOGIC_VECTOR(31 DOWNTO 0); 
                PRDATA      : in    STD_LOGIC_VECTOR(31 DOWNTO 0); 
                PREADY      : in    STD_LOGIC;                     
                PSLVERR     : in    STD_LOGIC;                     
                PSEL        : out   STD_LOGIC_VECTOR(15 DOWNTO 0); 
                --Control etc                                      
                INTERRUPT   : in    STD_LOGIC_VECTOR(255 DOWNTO 0);
                GP_OUT      : out   STD_LOGIC_VECTOR(31 DOWNTO 0); 
                GP_IN       : in    STD_LOGIC_VECTOR(31 DOWNTO 0); 
                EXT_WR      : out   STD_LOGIC;                     
                EXT_RD      : out   STD_LOGIC;                     
                EXT_ADDR    : out   STD_LOGIC_VECTOR(31 DOWNTO 0); 
                EXT_DATA    : inout STD_LOGIC_VECTOR(31 DOWNTO 0); 
                EXT_WAIT    : in    STD_LOGIC;                     
                FINISHED    : out   STD_LOGIC;                     
                FAILED      : out   STD_LOGIC                      
        );
    END COMPONENT;
    
    COMPONENT CoreTimer is
        GENERIC(
                    WIDTH       : integer := 32; -- Width can be 16 or 32
                    INTACTIVEH  : integer := 1;   -- 1 = active high interrupt, 0 = active low
                    FAMILY      : integer := 19
               );
        PORT(   PCLK        : in  std_logic;                    
                PRESETn     : in  std_logic;                    
                PENABLE     : in  std_logic;                    
                PSEL        : in  std_logic;                    
                PADDR       : in  std_logic_vector(4 downto 2); 
                PWRITE      : in  std_logic;                    
                PWDATA      : in  std_logic_vector(31 downto 0);
                PRDATA      : out std_logic_vector(31 downto 0);
                TIMINT      : out std_logic                     
        );
    END COMPONENT;

SIGNAL SYSCLK               : std_logic;      
SIGNAL SYSRSTN              : std_logic;     
SIGNAL PCLK                 : std_logic;        
SIGNAL PRESETN              : std_logic;     
SIGNAL PADDR                : std_logic_vector(31 downto 0);      
SIGNAL PENABLE              : std_logic;     
SIGNAL PWRITE               : std_logic;      
SIGNAL PWDATA               : std_logic_vector(31 downto 0);     
SIGNAL PRDATA               : std_logic_vector(31 downto 0);
SIGNAL PSEL                 : std_logic_vector(15 downto 0);
                           
SIGNAL TIMINT               : std_logic;
SIGNAL INTERRUPT            : std_logic_vector(255 downto 0); 
SIGNAL FINISHED             : std_logic;  
SIGNAL FAILED               : std_logic;
SIGNAL Logic0               : std_logic := '0';
SIGNAL Logic1               : std_logic := '1'; 
SIGNAL test_bit             : std_logic_vector(31 downto 0);
SIGNAL test_int             : std_logic_vector(31 downto 0);
SIGNAL stopsim              : STD_LOGIC;

-- *****************************************************************************
-- Clocks and Reset


BEGIN
   PROCESS 
   BEGIN
      stopsim <= '0';
      SYSRSTN <= '0';
      WAIT FOR 100 ns;
      SYSRSTN <= '1';
      WHILE (not(FINISHED = '1')) LOOP
        wait until rising_edge(SYSCLK);
      END LOOP;
      stopsim <= '1';
      wait;
   END PROCESS;
   
   PROCESS 
   BEGIN
      SYSCLK <= '0';
      WAIT FOR APB_HALF_PERIOD;
      SYSCLK <= '1';
      WAIT FOR APB_HALF_PERIOD;
      if (stopsim='1') then
        wait; -- end simulation
      end if;
   END PROCESS;
 
-- *****************************************************************************
-- APB Master  

test_int <= (0 => TIMINT, others => '0');

UBFM : BFM_APB
      GENERIC MAP (
         vectfile  => "user_tb.vec"
      )
      PORT MAP (
         sysclk     =>      SYSCLK,
         sysrstn    =>      SYSRSTN,
         pclk       =>      PCLK,
         presetn    =>      PRESETN,
         paddr      =>      PADDR,
         penable    =>      PENABLE,
         pwrite     =>      PWRITE,
         pwdata     =>      PWDATA,
         prdata     =>      PRDATA,
         pready     =>      Logic1,
         pslverr    =>      Logic0,
         psel       =>      PSEL,
         interrupt  =>      INTERRUPT,
         gp_out     =>      test_bit,
         gp_in      =>      test_int,
         ext_wr     =>      OPEN,                    
         ext_rd     =>      OPEN,                    
         ext_addr   =>      OPEN,                    
         ext_data   =>      OPEN,                    
         ext_wait   =>      Logic0,                 
         finished   =>      FINISHED,                
         failed     =>      FAILED                   
      );                    
   
-- *****************************************************************************
-- CoreTimer Instantiation
UTIM: CoreTimer
        GENERIC MAP(
                    WIDTH => COUNTER_WIDTH,
                    INTACTIVEH => INTERRUPT_LEVEL,
                    FAMILY  => FAMILY
               )
        PORT MAP(   
            PCLK    => PCLK,
            PRESETn => PRESETN,
            PENABLE => PENABLE,
            PSEL    => PSEL(0),
            PADDR   => PADDR(4 downto 2),
            PWRITE  => PWRITE,
            PWDATA  => PWDATA,
            PRDATA  => PRDATA,
            TIMINT  => TIMINT
        );
      
END trans;