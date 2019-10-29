-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
--
-- corememctrl.vhd
--
-- Description :
--          Memory Controller
--          AHB slave which is designed to interface to Flash and
--          either asynchronous or synchronous SRAM.
--
-- Revision Information:
-- Date         Description
-- ----         -----------------------------------------
--
--
-- SVN Revision Information:
-- SVN $Revision: 24455 $
-- SVN $Date: 2015-02-17 11:00:26 -0800 (Tue, 17 Feb 2015) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
-- Notes:
-- v2.1: Added wait states, by widening WS counter WSCouter
--       (fix for SAR 57873)
--
-- *********************************************************************/

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned."-";
use     work.corememctrl_core_pkg.all;


entity CoreMemCtrl is
    generic (
        -- Technology-specific device family
        --   9 -> RTSX-S
        --  10 -> EX
        --  11 -> AX
        --  12 -> RTAX-S
        --  15 -> ProASIC3
        --  16 -> ProASIC3E
        --  17 -> Fusion
        --  20 -> IGLOO
        --  21 -> IGLOOe
        --  22 -> ProASIC3L
        --  23 -> IGLOO PLUS
        --  Valid values: 9, 10, 11 ,12, 15, 16, 17, 20, 21, 22. 23
        FAMILY              : integer range 0 to 30 := 17;

        -- SYNC_SRAM parameter is used to select synchronous/asynchronous SRAM
        --  0 -> Asynchronous SRAM
        --  1 -> Synchronous SRAM
        SYNC_SRAM           : integer range 0 to 1  := 1;

        -- FLOW_THROUGH parameter is only applicable when SYNC_SRAM = 1 (synchronous SRAM)
        -- and should be set to match the mode of operation of the external synchronous
        -- SRAM device(s)
        --  1 -> External synchronous SRAM operating in flow-through mode
        --  0 -> External synchronous SRAM operating in pipeline mode
        FLOW_THROUGH        : integer range 0 to 1  := 0;

        -- Parameter used to select 16-bit/32-bit flash data bus
        --  0 -> 32 bit data bus connection to flash
        --  1 -> 16 bit data bus connection to flash
        FLASH_16BIT         : integer range 0 to 1  := 0;

        -- Parameters used to set the number of wait states that are inserted
        -- for memory reads and writes.
        -- Number of wait states for flash read/write.
        NUM_WS_FLASH_READ   : integer range 0 to 31  := 1;   -- range 0-3
        NUM_WS_FLASH_WRITE  : integer range 1 to 31  := 1;   -- range 1-3

        -- Number of wait states for asynchronous SRAM read/write.
        -- These parameter settings apply to asychronous SRAM only and are
        -- ignored when interfacing to synchronous SRAM (i.e. when SYNC_SRAM = 1)
        NUM_WS_SRAM_READ    : integer range 0 to 31  := 1;   -- range 0-3
        NUM_WS_SRAM_WRITE   : integer range 1 to 31  := 1;   -- range 1-3

        -- Set SHARED_RW to 1 if shared read and write enables (MEMREADN and
        -- MEMWRITEN) are used for SSRAM and Flash devices.
        -- Otherwise set to 0.
        SHARED_RW           : integer range 0 to 1  := 0;

        -- FLASH_ADDR_SEL is used select which address bits are routed to
        -- flash memory. It can take the following values:
        --  0 -> MEMADDR[27:0] to flash is driven by HADDR[27:0]
        --  1 -> MEMADDR[27:0] to flash is driven by {0, HADDR[27:1]}
        --  2 -> MEMADDR[27:0] to flash is driven by {0, 0, HADDR[27:2]}
        FLASH_ADDR_SEL      : integer range 0 to 2  := 2;

        -- SRAM_ADDR_SEL is used select which address bits are routed to
        -- flash memory. It can take the following values:
        --  0 -> MEMADDR[27:0] to SRAM is driven by HADDR[27:0]
        --  1 -> MEMADDR[27:0] to SRAM is driven by {0, HADDR[27:1]}
        --  2 -> MEMADDR[27:0] to SRAM is driven by {0, 0, HADDR[27:2]}
        SRAM_ADDR_SEL       : integer range 0 to 2  := 2
    );
    port (
        -- AHB interface
        -- Inputs
        HCLK            : in  std_logic;                        -- AHB Clock
        HRESETN         : in  std_logic;                        -- AHB Reset
        HSEL            : in  std_logic;                        -- AHB select
        HWRITE          : in  std_logic;                        -- AHB Write
        HREADYIN        : in  std_logic;                        -- AHB HREADY line
        HTRANS          : in  std_logic_vector(1 downto 0);     -- AHB HTRANS
        HSIZE           : in  std_logic_vector(2 downto 0);     -- AHB transfer size
        HWDATA          : in  std_logic_vector(31 downto 0);    -- AHB write data bus
        HADDR           : in  std_logic_vector(27 downto 0);    -- AHB address bus
        -- Outputs
        HREADY          : out std_logic;                        -- AHB ready signal
        HRESP           : out std_logic_vector(1 downto 0);     -- AHB transfer response
        HRDATA          : out std_logic_vector(31 downto 0);    -- AHB read data bus

        -- Remap control
        REMAP           : in  std_logic;

        -- Memory interface
        -- Flash interface
        FLASHCSN        : out std_logic;                        -- Flash chip select
        FLASHOEN        : out std_logic;                        -- Flash output enable
        FLASHWEN        : out std_logic;                        -- Flash write enable
        -- SRAM interface
        SRAMCLK         : out std_logic;                        -- Clock signal for synchronous SRAM
        SRAMCSN         : out std_logic;                        -- SRAM chip select
        SRAMOEN         : out std_logic;                        -- SRAM output enable
        SRAMWEN         : out std_logic;                        -- SRAM write enable
        SRAMBYTEN       : out std_logic_vector(3 downto 0);     -- SRAM byte enables
        -- Shared memory signals
        MEMREADN        : out std_logic;                        -- Flash/SRAM read enable
        MEMWRITEN       : out std_logic;                        -- Flash/SRAM write enable
        MEMADDR         : out std_logic_vector(27 downto 0);    -- Flash/SRAM address bus
        MEMDATA         : inout std_logic_vector(31 downto 0)   -- Bidirectional data bus to/from memory
    );
end entity CoreMemCtrl;

architecture rtl of CoreMemCtrl is

--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
    function to_stdlogic (
        val     : in boolean
    )
    return std_logic is
    begin
        if (val) then
            return('1');
        else
            return('0');
        end if;
    end to_stdlogic;

    function to_stdlogicvector (
        val     : in integer;
        len     : in integer
    )
    return std_logic_vector is
    variable rtn    : std_logic_vector(len-1 downto 0) := (others => '0');
    variable num    : integer := val;
    variable r      : integer;
    begin
        for index in 0 to len-1 loop
            r := num rem 2;
            num := num/2;
            if (r = 1) then
                rtn(index) := '1';
            else
                rtn(index) := '0';
            end if;
        end loop;
        return(rtn);
    end to_stdlogicvector;

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------

    -- State constant definitions
    constant ST_IDLE        : std_logic_vector(3 downto 0) := "0000";
    constant ST_FLASH_RD    : std_logic_vector(3 downto 0) := "0001";
    constant ST_FLASH_WR    : std_logic_vector(3 downto 0) := "0010";
    constant ST_ASRAM_RD    : std_logic_vector(3 downto 0) := "0011";
    constant ST_ASRAM_WR    : std_logic_vector(3 downto 0) := "0100";
    constant ST_WAIT        : std_logic_vector(3 downto 0) := "0101";
    constant ST_SSRAM_WR    : std_logic_vector(3 downto 0) := "0110";
    constant ST_SSRAM_RD1   : std_logic_vector(3 downto 0) := "0111";
    constant ST_SSRAM_RD2   : std_logic_vector(3 downto 0) := "1000";

    -- Wait state counter values
    -- AS: SAR 57873 fix
--    constant ZERO           : std_logic_vector(1 downto 0) := "00";
--    constant ONE            : std_logic_vector(1 downto 0) := "01";
--    constant MAX_WAIT       : std_logic_vector(1 downto 0) := "11";
    constant ZERO           : std_logic_vector(4 downto 0) := "00000";
    constant ONE            : std_logic_vector(4 downto 0) := "00001";
    constant MAX_WAIT       : std_logic_vector(4 downto 0) := "11111";

    -- AHB HTRANS constant definitions
    constant TRN_IDLE       : std_logic_vector(1 downto 0) := "00";
    constant TRN_BUSY       : std_logic_vector(1 downto 0) := "01";
    constant TRN_NSEQ       : std_logic_vector(1 downto 0) := "10";
    constant TRN_SEQU       : std_logic_vector(1 downto 0) := "11";

    -- AHB HRESP constant definitions
    constant RSP_OKAY       : std_logic_vector(1 downto 0) := "00";
    constant RSP_ERROR      : std_logic_vector(1 downto 0) := "01";
    constant RSP_RETRY      : std_logic_vector(1 downto 0) := "10";
    constant RSP_SPLIT      : std_logic_vector(1 downto 0) := "11";

    -- AHB HREADYOUT constant definitions
    constant H_WAIT         : std_logic := '0';
    constant H_READY        : std_logic := '1';

    -- AHB HSIZE constant definitions
    constant SZ_BYTE        : std_logic_vector(2 downto 0) := "000";
    constant SZ_HALF        : std_logic_vector(2 downto 0) := "001";
    constant SZ_WORD        : std_logic_vector(2 downto 0) := "010";

    -- SRAM byte enables encoding
    constant NONE           : std_logic_vector(3 downto 0) := "1111";
    constant WORD           : std_logic_vector(3 downto 0) := "0000";
    constant HALF1          : std_logic_vector(3 downto 0) := "0011";
    constant HALF0          : std_logic_vector(3 downto 0) := "1100";
    constant BYTE3          : std_logic_vector(3 downto 0) := "0111";
    constant BYTE2          : std_logic_vector(3 downto 0) := "1011";
    constant BYTE1          : std_logic_vector(3 downto 0) := "1101";
    constant BYTE0          : std_logic_vector(3 downto 0) := "1110";


--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

    signal MemCntlState     : std_logic_vector( 3 downto 0);
    signal NextMemCntlState : std_logic_vector( 3 downto 0);
    -- AS: SAR 57873 fix
--     signal CurrentWait      : std_logic_vector( 1 downto 0);
--     signal NextWait         : std_logic_vector( 1 downto 0);
--     signal WSCounterLoadVal : std_logic_vector( 1 downto 0);
    signal CurrentWait      : std_logic_vector( 4 downto 0);
    signal NextWait         : std_logic_vector( 4 downto 0);
    signal WSCounterLoadVal : std_logic_vector( 4 downto 0);
    signal LoadWSCounter    : std_logic;

    signal HselFlash        : std_logic;
    signal HselSram         : std_logic;
    signal HselReg          : std_logic;
    signal HselFlashReg     : std_logic;
    signal HselSramReg      : std_logic;

    signal MEMDATAIn        : std_logic_vector(31 downto 0);
    signal MEMDATAOut       : std_logic_vector(31 downto 0);
    signal MEMDATAOEN       : std_logic;

    signal MEMDATAInReg     : std_logic_vector(15 downto 0);
    signal iHRDATA          : std_logic_vector(31 downto 0);
    signal HRDATAreg        : std_logic_vector(31 downto 0);
    signal iHready          : std_logic;
    signal HaddrReg         : std_logic_vector(27 downto 0);
    signal HtransReg        : std_logic_vector( 1 downto 0);
    signal HwriteReg        : std_logic;
    signal HsizeReg         : std_logic_vector( 2 downto 0);

    signal SelHaddrReg,  NextSelHaddrReg    : std_logic;
    signal iMEMDATAOEN,  NextMEMDATAOEN     : std_logic;
    signal iFLASHCSN,    NextFLASHCSN       : std_logic;
    signal iFLASHWEN,    NextFLASHWEN       : std_logic;
    signal iFLASHOEN,    NextFLASHOEN       : std_logic;
    signal iSRAMCSN,     NextSRAMCSN        : std_logic;
    signal iSRAMWEN,     NextSRAMWEN        : std_logic;
    signal iSRAMOEN,     NextSRAMOEN        : std_logic;
    signal Flash2ndHalf, NextFlash2ndHalf   : std_logic;

    signal HoldHreadyLow    : std_logic;

    signal iMEMREADN        : std_logic;
    signal iMEMWRITEN       : std_logic;
    signal HreadyNext       : std_logic;
    signal Valid            : std_logic;
    signal ValidReg         : std_logic;
    signal ACRegEn          : std_logic;
    signal HreadyInternal   : std_logic;

    -- StateName is used for debug - intended to be displayed as ASCII in
    -- waveform viewer.
    signal StateName        : std_logic_vector(31 downto 0);

    --  AS: SAR 63160
    constant  SYNC_RESET : INTEGER := SYNC_MODE_SEL(FAMILY);

    signal    aresetn           : std_logic;
    signal    sresetn           : std_logic;
    
--------------------------------------------------------------------------------
-- Main body of code
--------------------------------------------------------------------------------
begin

    aresetn <= '1' WHEN (SYNC_RESET=1) ELSE HRESETN;
    sresetn <= HRESETN WHEN (SYNC_RESET=1) ELSE '1';

    -- Bidirectional memory data bus
    MEMDATA <= MEMDATAOut when (MEMDATAOEN = '0')
               else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    MEMDATAIn <= MEMDATA;

    -- Clock signal for synchronous SRAM is inverted HCLK
    SRAMCLK <= not(HCLK);

    -- Drive outputs to memories with internal signals
    MEMDATAOEN  <= iMEMDATAOEN;
    FLASHCSN    <= iFLASHCSN;
    FLASHWEN    <= iFLASHWEN;
    FLASHOEN    <= iFLASHOEN;
    SRAMCSN     <= iSRAMCSN;
    SRAMWEN     <= iSRAMWEN;
    SRAMOEN     <= iSRAMOEN;
    MEMWRITEN   <= iMEMWRITEN;
    MEMREADN    <= iMEMREADN;

    -- MEMWRITEN asserted if either flash or SRAM WEnN asserted
    iMEMWRITEN  <= '1' when ( (iFLASHWEN = '1') and (iSRAMWEN = '1') )
                   else '0';

    -- MEMREADN  asserted if either flash or SRAM OEnN asserted
    iMEMREADN   <= '1' when ( (iFLASHOEN = '1') and (iSRAMOEN = '1') )
                   else '0';

    -- When REMAP is asserted, flash appears at 0x08000000 and SRAM at 0x00000000.
    HselFlash <= (HSEL and     HADDR(27) ) when REMAP = '1' else (HSEL and not(HADDR(27)));
    HselSram  <= (HSEL and not(HADDR(27))) when REMAP = '1' else (HSEL and     HADDR(27) );

    --------------------------------------------------------------------------------
    -- Valid transfer detection
    --------------------------------------------------------------------------------
    -- The slave must only respond to a valid transfer, so this must be detected.
    process (aresetn, HCLK)
    begin
        if (aresetn = '0') then
            HselReg      <= '0';
            HselFlashReg <= '0';
            HselSramReg  <= '0';
        elsif (HCLK'event and HCLK = '1') then
          if (sresetn = '0') then
            HselReg      <= '0';
            HselFlashReg <= '0';
            HselSramReg  <= '0';
          else
            if HREADYIN = '1' then
                HselReg      <= HSEL;
                HselFlashReg <= HselFlash;
                HselSramReg  <= HselSram;
            end if;
          end if;
        end if;
    end process;

    -- Valid AHB transfers only take place when a non-sequential or sequential
    -- transfer is shown on HTRANS - an idle or busy transfer should be ignored.
    Valid <= '1' when (HSEL = '1' and HREADYIN = '1'
                       and (HTRANS = TRN_NSEQ or HTRANS = TRN_SEQU))
                else '0';

    ValidReg <= '1' when HselReg = '1'
                         and (HtransReg = TRN_NSEQ or HtransReg = TRN_SEQU)
                else '0';


    --------------------------------------------------------------------------------
    -- Address and control registers
    --------------------------------------------------------------------------------
    -- Registers are used to store the address and control signals from the address
    -- phase for use in the data phase of the transfer.
    -- Only enabled when the HREADYIN input is HIGH and the module is addressed.
    -- AS: SAR63820 fix
    -- ACRegEn <= HSEL and HREADYIN;
    ACRegEn <= HSEL and HREADYIN and HreadyInternal;
    
    process (aresetn, HCLK)
    begin
        if (aresetn = '0') then
            HaddrReg  <= (others => '0');
            HtransReg <= (others => '0');
            HwriteReg <= '0';
            HsizeReg  <= (others => '0');
        elsif (HCLK'event and HCLK = '1') then
          if (sresetn = '0') then
            HaddrReg  <= (others => '0');
            HtransReg <= (others => '0');
            HwriteReg <= '0';
            HsizeReg  <= (others => '0');
          else
            if ACRegEn = '1' then
                HaddrReg  <= HADDR;
                HtransReg <= HTRANS;
                HwriteReg <= HWRITE;
                HsizeReg  <= HSIZE;
            end if;
          end if;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Wait state counter
    --------------------------------------------------------------------------------
    -- Generates count signal depending on the type of memory access taking place.
    -- Counter decrements to zero.
    -- Wait states are inserted when CurrentWait is not equal to ZERO.

    -- Next counter value
    process (LoadWSCounter, WSCounterLoadVal, CurrentWait)
    begin
        if (LoadWSCounter = '1') then
            NextWait <= WSCounterLoadVal;
        elsif (CurrentWait = ZERO) then
            NextWait <= ZERO;
        else
            NextWait <= CurrentWait - "01";
        end if;
    end process;

    process (HCLK, aresetn)
    begin
        if (aresetn = '0') then
            CurrentWait <= ZERO;
        elsif (HCLK'event and HCLK = '1') then
          if (sresetn = '0') then
            CurrentWait <= ZERO;
          else
            CurrentWait <= NextWait;
          end if;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- HREADY generation
    --------------------------------------------------------------------------------
    -- HREADY is asserted when the wait state counter reaches zero.
    -- HoldHreadyLow can be used to negate HREADY during the first half of a
    -- word access when using 16-bit flash.
    HreadyNext <= '1' when NextWait = ZERO else '0';

    process (aresetn, HCLK)
    begin
        if (aresetn = '0') then
            iHready <= '1';
        elsif (HCLK'event and HCLK = '1') then
          if (sresetn = '0') then
            iHready <= '1';
          else
            iHready <= HreadyNext;
          end if;
        end if;
    end process;

    -- AS: modified to make use of HREADY internally
    HreadyInternal <= '0' when (HoldHreadyLow = '1') else iHready;
    HREADY <= HreadyInternal;
     
    
    --------------------------------------------------------------------------------
    -- MEMDATAOut generation
    --------------------------------------------------------------------------------
    process (HselReg, HwriteReg, iFLASHCSN, Flash2ndHalf, HWDATA)
    begin
        if ( HselReg = '1' and HwriteReg = '1' ) then
            if ( iFLASHCSN = '0' ) then     -- Flash access
                if ( FLASH_16BIT = 1 and FLASH_ADDR_SEL /= 2 ) then
                    if ( Flash2ndHalf = '1' ) then
                        MEMDATAOut <= ( HWDATA(31 downto 16) & HWDATA(31 downto 16) );
                    else
                        MEMDATAOut <= ( HWDATA(15 downto 0) & HWDATA(15 downto 0) );
                    end if;
                else
                    MEMDATAOut <= HWDATA(31 downto 0);
                end if;
            else    -- SRAM access
                MEMDATAOut <= HWDATA(31 downto 0);
            end if;
        else
            MEMDATAOut <= (others => '0');
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- StateName machine controlling memory access
    --------------------------------------------------------------------------------
    process (
        MemCntlState,
        Valid,
        HselFlash,
        HWRITE,
        Flash2ndHalf,
        CurrentWait,
        HsizeReg,
        HselFlashReg,
        HselSramReg,
        HwriteReg,
        iHready
    )
    begin
        NextMemCntlState    <= MemCntlState;
        NextMEMDATAOEN      <= '0';
        NextSelHaddrReg     <= '1';
        LoadWSCounter       <= '0';
        WSCounterLoadVal    <= ZERO;
        NextFLASHCSN        <= '1';
        NextFLASHWEN        <= '1';
        NextFLASHOEN        <= '1';
        NextSRAMCSN         <= '1';
        NextSRAMWEN         <= '1';
        NextSRAMOEN         <= '1';
        NextFlash2ndHalf    <= '0';
        HoldHreadyLow       <= '0';

        case MemCntlState is
            when ST_IDLE =>
                StateName <= X"49444c45";   -- For debug - ASCII value for "IDLE"
                NextMEMDATAOEN <= '0';      -- Drive memory data bus if remaining in IDLE state
                NextSelHaddrReg <= '1';     -- Drive memory address bus with registered address
                                            --  to prevent unnecessary toggling of address lines

                if (Valid = '1') then
                    if (HselFlash = '1') then
                        NextFLASHCSN <= '0';
                        NextSelHaddrReg <= '1';
                        if (HWRITE = '1') then
                            NextMemCntlState <= ST_FLASH_WR;
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_WRITE,5);
                        else
                            NextMemCntlState <= ST_FLASH_RD;
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                            NextMEMDATAOEN <= '1'; -- negate
                        end if;
                    else
                        if (SYNC_SRAM = 1) then
                            if (HWRITE = '1') then
                                NextMemCntlState <= ST_SSRAM_WR;
                                NextSRAMCSN <= '0';
                                NextSRAMWEN <= '0';
                                NextSelHaddrReg <= '1';
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= ZERO;
                            else -- asynchronous SRAM
                                if (FLOW_THROUGH = 1) then
                                    NextMemCntlState <= ST_SSRAM_RD2;
                                else
                                    NextMemCntlState <= ST_SSRAM_RD1;
                                end if;
                                NextMEMDATAOEN <= '1'; -- negate
                                NextSRAMCSN <= '0';
                                NextSelHaddrReg <= '1';
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= ONE;
                            end if;
                        else
                            if (HWRITE = '1') then
                                NextMemCntlState <= ST_ASRAM_WR;
                                NextSRAMCSN <= '0';
                                NextSelHaddrReg <= '1';
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_WRITE,5);
                            else
                                NextMemCntlState <= ST_ASRAM_RD;
                                NextMEMDATAOEN <= '1'; -- negate
                                NextSRAMCSN <= '0';
                                NextSelHaddrReg <= '1';
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_READ,5);
                            end if;
                        end if;
                    end if;
                else
                    NextMemCntlState <= ST_IDLE;
                    NextSelHaddrReg <= '0';
                end if;

            when ST_FLASH_WR =>
                StateName <= X"465f5752"; -- For debug - ASCII value for "F_WR"
                NextFLASHCSN <= '0';
                NextFLASHWEN <= '0';
                if (Flash2ndHalf = '1') then
                    NextFlash2ndHalf <= '1';
                end if;
                if (CurrentWait = ZERO) then  -- Wait state counter expired
                    if ( FLASH_16BIT = 1 and FLASH_ADDR_SEL /= 2 and (HsizeReg = SZ_WORD) and (Flash2ndHalf = '0') ) then
                        NextFlash2ndHalf <= '1';
                        HoldHreadyLow <= '1';   -- Not ready - another flash access is required
                        NextFLASHWEN <= '1';
                        NextMemCntlState <= ST_FLASH_WR;
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_WRITE,5);
                    else
                        NextFLASHCSN <= '1';
                        NextFLASHWEN <= '1';
                        NextFlash2ndHalf <= '0';

                        if (Valid = '1') then
                            if (HselFlash = '1') then
                                NextFLASHCSN <= '0';
                                if (HWRITE = '1') then
                                    NextMemCntlState <= ST_FLASH_WR;
                                    LoadWSCounter <= '1';
                                    WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_WRITE,5);
                                else
                                    NextMemCntlState <= ST_FLASH_RD;
                                    NextMEMDATAOEN <= '1'; -- negate
                                    LoadWSCounter <= '1';
                                    WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                                end if;
                            else
                                if (SYNC_SRAM = 1) then
                                    if (HWRITE = '1') then
                                        NextMemCntlState <= ST_SSRAM_WR;
                                        NextSRAMCSN <= '0';
                                        NextSRAMWEN <= '0';
                                        NextSelHaddrReg <= '1';
                                        LoadWSCounter <= '1';
                                        WSCounterLoadVal <= ZERO;
                                    else
                                        if (FLOW_THROUGH = 1) then
                                            NextMemCntlState <= ST_SSRAM_RD2;
                                        else
                                            NextMemCntlState <= ST_SSRAM_RD1;
                                        end if;
                                        NextMEMDATAOEN <= '1'; -- negate
                                        NextSRAMCSN <= '0';
                                        NextSelHaddrReg <= '1';
                                        LoadWSCounter <= '1';
                                        WSCounterLoadVal <= ONE;
                                    end if;
                                else -- asynchronous SRAM
                                    if (HWRITE = '1') then
                                        NextMemCntlState <= ST_ASRAM_WR;
                                        NextSRAMCSN <= '0';
                                        NextSelHaddrReg <= '1';
                                        LoadWSCounter <= '1';
                                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_WRITE,5);
                                    else
                                        NextMemCntlState <= ST_ASRAM_RD;
                                        NextMEMDATAOEN <= '1'; -- negate
                                        NextSRAMCSN <= '0';
                                        NextSelHaddrReg <= '1';
                                        LoadWSCounter <= '1';
                                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_READ,5);
                                    end if;
                                end if;
                            end if;
                        else
                            NextMemCntlState <= ST_IDLE;
                            NextSelHaddrReg <= '0';
                        end if;
                    end if;
                end if;

            when ST_FLASH_RD =>
                StateName <= X"465f5244"; -- For debug - ASCII value for "F_RD"
                NextFLASHCSN <= '0';
                NextFLASHOEN <= '0';
                NextMEMDATAOEN <= '1'; -- negate
                if (Flash2ndHalf = '1') then
                    NextFlash2ndHalf <= '1';
                end if;
                if (CurrentWait = ZERO) then  -- Wait state counter expired
                    if ( FLASH_16BIT = 1 and FLASH_ADDR_SEL /= 2 and (HsizeReg = SZ_WORD) and (Flash2ndHalf = '0') ) then
                        NextFlash2ndHalf <= '1';
                        HoldHreadyLow <= '1';   -- Not ready - another flash access is required
                        NextMemCntlState <= ST_FLASH_RD;
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                    else
                        NextFLASHCSN <= '1';
                        NextFlash2ndHalf <= '0';

                        if (Valid = '1') then
                            if (HselFlash = '1') then
                                NextFLASHCSN <= '0';
                                if (HWRITE = '1') then
                                    -- If moving from flash read to flash write, go to WAIT
                                    -- state for one cycle to allow time for changing driver
                                    -- of data bus.
                                    NextMemCntlState <= ST_WAIT;
                                    LoadWSCounter <= '1';
                                    WSCounterLoadVal <= MAX_WAIT; -- non-zero value to prevent assertion of HREADY
                                else
                                    NextMemCntlState <= ST_FLASH_RD;
                                    LoadWSCounter <= '1';
                                    WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                                end if;
                            else
                                if (SYNC_SRAM = 1) then
                                    if (HWRITE = '1') then
                                        NextMemCntlState <= ST_SSRAM_WR;
                                        NextSelHaddrReg <= '1';
                                        LoadWSCounter <= '1';
                                        WSCounterLoadVal <= ONE;
                                    else
                                        if (FLOW_THROUGH = 1) then
                                            NextMemCntlState <= ST_SSRAM_RD2;
                                        else
                                            NextMemCntlState <= ST_SSRAM_RD1;
                                        end if;
                                        NextMEMDATAOEN <= '1'; -- negate
                                        NextSRAMCSN <= '0';
                                        NextSelHaddrReg <= '1';
                                        LoadWSCounter <= '1';
                                        WSCounterLoadVal <= ONE;
                                    end if;
                                else -- asynchronous SRAM
                                    -- If moving from flash read to SRAM read/write, go to WAIT
                                    -- state for one cycle to allow time for changing driver
                                    -- of data bus.
                                    NextMemCntlState <= ST_WAIT;
                                    LoadWSCounter <= '1';
                                    WSCounterLoadVal <= MAX_WAIT; -- non-zero value to prevent assertion of HREADY
                                end if;
                            end if;
                        else
                            NextMemCntlState <= ST_IDLE;
                            NextSelHaddrReg <= '0';
                        end if;
                    end if;
                end if;

            when ST_ASRAM_WR =>
                StateName <= X"41535752"; -- For debug - ASCII value for "ASWR"
                NextSRAMCSN <= '0';
                NextSRAMWEN <= '0';
                if (CurrentWait = ZERO) then  -- Wait state counter expired
                    NextSRAMCSN <= '1';
                    NextSRAMWEN <= '1';

                    if (Valid = '1') then
                        if (HselFlash = '1') then
                            NextFLASHCSN <= '0';
                            if (HWRITE = '1') then
                                NextMemCntlState <= ST_FLASH_WR;
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_WRITE,5);
                            else
                                NextMemCntlState <= ST_FLASH_RD;
                                NextMEMDATAOEN <= '1'; -- negate
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                            end if;
                        else
                            NextSRAMCSN <= '0';
                            if (HWRITE = '1') then
                                NextMemCntlState <= ST_ASRAM_WR;
                                NextSRAMWEN <= '1';
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_WRITE,5);
                            else -- SRAM read
                                NextMemCntlState <= ST_ASRAM_RD;
                                NextMEMDATAOEN <= '1'; -- negate
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_READ,5);
                            end if;
                        end if;
                    else
                        NextMemCntlState <= ST_IDLE;
                        NextSRAMCSN <= '0';
                        NextSelHaddrReg <= '0';
                    end if;
                end if;

            when ST_ASRAM_RD =>
                StateName <= X"41535244"; -- For debug - ASCII value for "ASRD"
                NextSRAMCSN <= '0';
                NextSRAMOEN <= '0';
                NextMEMDATAOEN <= '1'; -- negate
                if (CurrentWait = ZERO) then   -- Wait state counter expired
                    NextSRAMCSN <= '1';

                    if (Valid = '1') then
                        if (HselFlash = '1') then
                            -- If moving from SRAM read to flash read/write, go to WAIT
                            -- state for one cycle to allow time for changing driver
                            -- of data bus.
                            NextMemCntlState <= ST_WAIT;
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= MAX_WAIT; -- non-zero value to prevent assertion of HREADY
                        else
                            NextSRAMCSN <= '0';
                            if (HWRITE = '1') then
                                -- If moving from SRAM read to SRAM write, go to WAIT
                                -- state for one cycle to allow time for changing driver
                                -- of data bus.
                                NextMemCntlState <= ST_WAIT;
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= MAX_WAIT; -- non-zero value to prevent assertion of HREADY
                            else
                                NextMemCntlState <= ST_ASRAM_RD;
                                NextSelHaddrReg <= '1';
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_READ,5);
                            end if;
                        end if;
                    else
                        NextMemCntlState <= ST_IDLE;
                        NextSRAMCSN <= '0';
                    end if;
                end if;

            when ST_SSRAM_WR =>
                StateName <= X"53535752"; -- For debug - ASCII value for "SSWR"
                if (iHready = '0') then -- May have a wait state at beginning of SSRAM read
                                        --  depending on previous state.
                    NextMemCntlState <= ST_SSRAM_WR;
                    NextSRAMCSN <= '0';
                    NextSRAMWEN <= '0';
                elsif (Valid = '1') then
                    if (HselFlash = '1') then
                        if (SHARED_RW = 1) then
                            -- If read and write enables are shared between SSRAM and Flash then insert
                            --  a wait state when moving from SSRAM write to Flash access to avoid any
                            --  spurious write to a Flash location.
                            NextMemCntlState <= ST_WAIT;
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= MAX_WAIT; -- non-zero value to prevent assertion of HREADY
                        else
                            NextFLASHCSN <= '0';
                            if (HWRITE = '1') then
                                NextMemCntlState <= ST_FLASH_WR;
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_WRITE,5);
                            else
                                NextMemCntlState <= ST_FLASH_RD;
                                NextMEMDATAOEN <= '1'; -- negate
                                LoadWSCounter <= '1';
                                WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                            end if;
                        end if;
                    else
                        if (HWRITE = '1') then
                            NextMemCntlState <= ST_SSRAM_WR;
                            NextSRAMCSN <= '0';
                            NextSRAMWEN <= '0';
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= ZERO;
                        else -- SRAM read
                            if (FLOW_THROUGH = 1) then
                                NextMemCntlState <= ST_SSRAM_RD2;
                            else
                                NextMemCntlState <= ST_SSRAM_RD1;
                            end if;
                            NextMEMDATAOEN <= '1'; -- negate
                            NextSRAMCSN <= '0';
                            NextSRAMWEN <= '1';
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= ONE;
                        end if;
                    end if;
                else
                    NextMemCntlState <= ST_IDLE;
                    NextSRAMCSN <= '1';
                    NextSRAMWEN <= '1';
                end if;

            when ST_SSRAM_RD1 =>
                StateName <= X"53535231"; -- For debug - ASCII value for "SSR1"
                NextMemCntlState <= ST_SSRAM_RD2;
                NextMEMDATAOEN <= '1'; -- negate
                NextSRAMCSN <= '0';
                NextSelHaddrReg <= '0';

            when ST_SSRAM_RD2 =>
                StateName <= X"53535232"; -- For debug - ASCII value for "SSR2"
                NextMEMDATAOEN <= '1'; -- negate
                NextSRAMOEN <= '0';

                if (Valid = '1') then
                    if (HselFlash = '1') then
                        NextMemCntlState <= ST_WAIT;
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= MAX_WAIT; -- non-zero value to prevent assertion of HREADY
                    else
                        if (HWRITE = '1') then
                            NextMemCntlState <= ST_SSRAM_WR;
                            NextSRAMCSN <= '0';
                            NextSelHaddrReg <= '1';
                            LoadWSCounter <= '1';
                            WSCounterLoadVal <= ONE;
                        else
                            NextMemCntlState <= ST_SSRAM_RD2;
                            NextSRAMCSN <= '0';
                            NextSelHaddrReg <= '0';
                        end if;
                    end if;
                else
                    NextMemCntlState <= ST_IDLE;
                    NextSRAMCSN <= '1';
                end if;

            when ST_WAIT =>
                StateName <= X"57414954"; -- For debug - ASCII value for "WAIT"
                if (HselFlashReg = '1') then
                    NextFLASHCSN <= '0';
                    if (HwriteReg = '1') then
                        NextMemCntlState <= ST_FLASH_WR;
                        NextMEMDATAOEN <= '0'; -- assert
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_WRITE,5);
                    else
                        NextMemCntlState <= ST_FLASH_RD;
                        NextMEMDATAOEN <= '1'; -- negate
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_FLASH_READ,5);
                    end if;
                elsif (HselSramReg = '1') then
                    NextSRAMCSN <= '0';
                    if (HwriteReg = '1') then
                        NextMemCntlState <= ST_ASRAM_WR;
                        NextMEMDATAOEN <= '0'; -- assert
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_WRITE,5);
                    else
                        NextMemCntlState <= ST_ASRAM_RD;
                        NextMEMDATAOEN <= '1'; -- negate
                        LoadWSCounter <= '1';
                        WSCounterLoadVal <= to_stdlogicvector(NUM_WS_SRAM_READ,5);
                    end if;
                else
                    NextMemCntlState <= ST_IDLE;
                end if;

            when others =>
                StateName <= X"64656674"; -- For debug - ASCII value for "deft"
                NextMemCntlState <= ST_IDLE;

        end case;
    end process;

    -- Synchronous part of state machine
    process (HCLK, aresetn)
    begin
        if ( aresetn = '0' ) then
            MemCntlState    <= ST_IDLE;
            SelHaddrReg     <= '0';
            iFLASHCSN       <= '1';
            iSRAMCSN        <= '1';
            iMEMDATAOEN     <= '0'; -- Driving memory data bus by default
            Flash2ndHalf    <= '0';
        elsif (HCLK'event and HCLK = '1') then
          if (sresetn = '0') then
            MemCntlState    <= ST_IDLE;
            SelHaddrReg     <= '0';
            iFLASHCSN       <= '1';
            iSRAMCSN        <= '1';
            iMEMDATAOEN     <= '0'; -- Driving memory data bus by default
            Flash2ndHalf    <= '0';
          else
            MemCntlState    <= NextMemCntlState;
            SelHaddrReg     <= NextSelHaddrReg;
            iFLASHCSN       <= NextFLASHCSN;
            iSRAMCSN        <= NextSRAMCSN;
            iMEMDATAOEN     <= NextMEMDATAOEN;
            Flash2ndHalf    <= NextFlash2ndHalf;
          end if;
        end if;
    end process;

    -- Signals clocked with falling edge of HCLK
    process (HCLK, aresetn)
    begin
        if ( aresetn = '0' ) then
            iFLASHOEN <= '1';
            iFLASHWEN <= '1';
            iSRAMOEN  <= '1';
        elsif (HCLK'event and HCLK = '0') then
          if (sresetn = '0') then
            iFLASHOEN <= '1';
            iFLASHWEN <= '1';
            iSRAMOEN  <= '1';
          else
            iFLASHOEN <= NextFLASHOEN;
            iFLASHWEN <= NextFLASHWEN;
            iSRAMOEN  <= NextSRAMOEN;
          end if;
        end if;
    end process;


    -- Clock SRAM write enable with rising edge of HCLK for sync. SRAM
    GenSSRAM : if (SYNC_SRAM = 1) generate
    begin
        process (HCLK, aresetn)
        begin
            if ( aresetn = '0' ) then
                iSRAMWEN  <= '1';
            elsif (HCLK'event and HCLK = '1') then
              if (sresetn = '0') then
                iSRAMWEN  <= '1';
              else
                iSRAMWEN  <= NextSRAMWEN;
              end if;
            end if;
        end process;
    end generate GenSSRAM;

    -- Clock SRAM write enable with falling edge of HCLK for async. SRAM
    GenASRAM : if (SYNC_SRAM = 0) generate
    begin
        process (HCLK, aresetn)
        begin
            if ( aresetn = '0' ) then
                iSRAMWEN  <= '1';
            elsif (HCLK'event and HCLK = '0') then
              if (sresetn = '0') then
                iSRAMWEN  <= '1';
              else
                iSRAMWEN  <= NextSRAMWEN;
              end if;
            end if;
        end process;
    end generate GenASRAM;


    --------------------------------------------------------------------------------
    -- Memory address mux
    --------------------------------------------------------------------------------
    -- AS: SAR64652 fix
    --process (HselFlashReg, Flash2ndHalf, SelHaddrReg, HaddrReg, HADDR)
    process (iFLASHCSN, Flash2ndHalf, SelHaddrReg, HaddrReg, HADDR)
    begin
        --if (HselFlashReg = '1') then -- Flash access
        if (iFLASHCSN = '0') then -- Flash access
            if (FLASH_ADDR_SEL = 0) then
                if (Flash2ndHalf = '1') then
                    MEMADDR <= HaddrReg(27 downto 2) & '1' & HaddrReg(0);
                else
                    MEMADDR <= HaddrReg(27 downto 0);
                end if;
            elsif (FLASH_ADDR_SEL = 1) then
                if (Flash2ndHalf = '1') then
                    MEMADDR <= '0' & HaddrReg(27 downto 2) & '1';
                else
                    MEMADDR <= '0' & HaddrReg(27 downto 1);
                end if;
            else
                MEMADDR <= "00" & HaddrReg(27 downto 2);
            end if;
        else -- SRAM access
            if (SRAM_ADDR_SEL = 0) then
                if (SelHaddrReg = '1') then
                    MEMADDR <= HaddrReg(27 downto 0);
                else
                    MEMADDR <= HADDR(27 downto 0);
                end if;
            elsif (SRAM_ADDR_SEL = 1) then
                if (SelHaddrReg = '1') then
                    MEMADDR <= '0' & HaddrReg(27 downto 1);
                else
                    MEMADDR <= '0' & HADDR(27 downto 1);
                end if;
            else
                if (SelHaddrReg = '1') then
                    MEMADDR <= "00" & HaddrReg(27 downto 2);
                else
                    MEMADDR <= "00" & HADDR(27 downto 2);
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Byte enables for RAM
    --------------------------------------------------------------------------------
    process ( iSRAMCSN, HsizeReg, HaddrReg )
    begin
        if ( iSRAMCSN = '0' ) then
            case  HsizeReg is
                when SZ_BYTE =>
                    case HaddrReg(1 downto 0) is
                        when "00" => SRAMBYTEN <= BYTE0;
                        when "01" => SRAMBYTEN <= BYTE1;
                        when "10" => SRAMBYTEN <= BYTE2;
                        when "11" => SRAMBYTEN <= BYTE3;
                        when others => SRAMBYTEN <= NONE;
                    end case;
                when SZ_HALF =>
                    case HaddrReg(1) is
                        when '0' =>  SRAMBYTEN <= HALF0;
                        when '1' =>  SRAMBYTEN <= HALF1;
                        when others => SRAMBYTEN <= NONE;
                    end case;
                when SZ_WORD =>
                    SRAMBYTEN <= WORD;
                when others =>
                    SRAMBYTEN <= NONE;
            end case;
        else
            SRAMBYTEN <= NONE;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Output AHB read data bus generation.
    --------------------------------------------------------------------------------
    -- Register lower half of MEMDATAIn to facilitate word reads when using 16-bit
    -- flash.
    process ( HCLK )
    begin
        if (HCLK'event and HCLK = '1') then
            if ( CurrentWait = ZERO ) then
                MEMDATAInReg <= MEMDATAIn(15 downto 0);
            end if;
        end if;
    end process;

    -- Replicate bytes and halfwords in read data sent to master
    process ( iFLASHCSN, HsizeReg, HaddrReg, MEMDATAIn, MEMDATAInReg )
    begin
        if ( iFLASHCSN = '0' and FLASH_16BIT = 1 and FLASH_ADDR_SEL /= 2 ) then -- Reading 16-bit Flash
            case HsizeReg is
                when SZ_BYTE =>
                    case HaddrReg(0) is
                        when '0' => iHRDATA <= ( MEMDATAIn(7 downto 0)  & MEMDATAIn(7 downto 0)  & MEMDATAIn(7 downto 0)  & MEMDATAIn(7 downto 0)  );
                        when '1' => iHRDATA <= ( MEMDATAIn(15 downto 8) & MEMDATAIn(15 downto 8) & MEMDATAIn(15 downto 8) & MEMDATAIn(15 downto 8) );
                        when others => iHRDATA <= MEMDATAIn(31 downto 0);
                    end case;
                when SZ_HALF =>
                    iHRDATA <= ( MEMDATAIn(15 downto 0) & MEMDATAIn(15 downto 0) );
                when SZ_WORD =>
                    iHRDATA <= ( MEMDATAIn(15 downto 0) & MEMDATAInReg(15 downto 0) );
                when others =>
                    iHRDATA <= ( MEMDATAIn(15 downto 0) & MEMDATAIn(15 downto 0) );
            end case;
        else
            case HsizeReg is
                when SZ_BYTE =>
                    case HaddrReg(1 downto 0) is
                        when "00" => iHRDATA <= ( MEMDATAIn(7 downto 0)   & MEMDATAIn(7 downto 0)   & MEMDATAIn(7 downto 0)   & MEMDATAIn(7 downto 0)   );
                        when "01" => iHRDATA <= ( MEMDATAIn(15 downto 8)  & MEMDATAIn(15 downto 8)  & MEMDATAIn(15 downto 8)  & MEMDATAIn(15 downto 8)  );
                        when "10" => iHRDATA <= ( MEMDATAIn(23 downto 16) & MEMDATAIn(23 downto 16) & MEMDATAIn(23 downto 16) & MEMDATAIn(23 downto 16) );
                        when "11" => iHRDATA <= ( MEMDATAIn(31 downto 24) & MEMDATAIn(31 downto 24) & MEMDATAIn(31 downto 24) & MEMDATAIn(31 downto 24) );
                        when others => iHRDATA <= MEMDATAIn(31 downto 0);
                    end case;
                when SZ_HALF =>
                    case HaddrReg(1) is
                        when '0' => iHRDATA <= ( MEMDATAIn(15 downto 0)  & MEMDATAIn(15 downto 0)  );
                        when '1' => iHRDATA <= ( MEMDATAIn(31 downto 16) & MEMDATAIn(31 downto 16) );
                        when others => iHRDATA <= MEMDATAIn(31 downto 0);
                    end case;
                when SZ_WORD =>
                    iHRDATA <= MEMDATAIn(31 downto 0);
                when others =>
                    iHRDATA <= MEMDATAIn(31 downto 0);
            end case;
        end if;
    end process;

    -- iHRDATA registered on negedge of clock
    process ( HCLK )
    begin
        if (HCLK'event and HCLK = '0') then
            HRDATAreg <= iHRDATA;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Read data back to AHB bus
    --------------------------------------------------------------------------------
    process ( HselSramReg, iHRDATA, HRDATAreg )
    begin
        if ( HselSramReg = '1' and SYNC_SRAM = 1 and FLOW_THROUGH = 1 ) then
            HRDATA  <= HRDATAreg;
        else
            HRDATA  <= iHRDATA;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Slave response
    --------------------------------------------------------------------------------
    -- Output response to AHB bus is always OKAY
    HRESP <= RSP_OKAY;

end rtl;

--================================= End ===================================--
