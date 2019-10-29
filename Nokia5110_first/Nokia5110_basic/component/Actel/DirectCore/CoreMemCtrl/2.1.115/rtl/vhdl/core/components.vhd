-- ********************************************************************
-- Actel Corporation Proprietary and Confidential
--  Copyright 2008 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description:	VHDL components for COREMEMCTRL
--
-- Revision Information:
-- Date         Description
-- ----         -----------------------------------------
--
--
-- SVN Revision Information:
-- SVN $Revision: 7427 $
-- SVN $Date: 2009-03-12 09:41:03 -0700 (Thu, 12 Mar 2009) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
-- Notes:
-- 1. best viewed with tabstops set to "4"
--
-- History:		11/17/08  - TFB created
--
-- *********************************************************************
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is

-----------------------------------------------------------------------------
-- components
-----------------------------------------------------------------------------
component CoreMemCtrl
    generic (
        -- Technology-specific device family
        -- 11 - Axcelerator
        -- 12 - RTAX-S
        -- 15 - ProASIC3
        -- 16 - ProASIC3E
        -- 17 - Fusion
        -- 20 - IGLOO
        -- 21 - IGLOOe
        -- 22 - ProASIC3L
        -- 23 - IGLOO PLUS
        -- Valid values: 11 ,12, 15, 16, 17, 20, 21, 22. 23
        FAMILY              : integer range 0 to 30 := 17;

        -- Parameter used to select synchronous/asynchronous SRAM
        SYNC_SRAM           : integer range 0 to 1 := 1;		-- 0 = async SRAM, 1 = sync SRAM

        -- FLOW_THROUGH is only applicable when SYNC_SRAM = 1 (synchronous SRAM)
        --  FLOW_THROUGH = 1 -> Flow-through mode
        --  FLOW_THROUGH = 0 -> Pipeline mode
        FLOW_THROUGH        : integer range 0 to 1 := 0;

        -- Parameter used to select 16-bit/32-bit flash data bus
        FLASH_16BIT         : integer range 0 to 1 := 0; 		-- 0 = 32-bit flash, 1 = 16-bit flash

        -- Parameters used to set the number of wait states that are inserted
        -- for memory reads and writes.
        -- Number of wait states for flash read/write.
        NUM_WS_FLASH_READ   : integer range 0 to 3 := 1;		-- range 0-3
        NUM_WS_FLASH_WRITE  : integer range 1 to 3 := 1;		-- range 1-3

        -- Number of wait states for asynchronous SRAM read/write.
        -- Zero wait states if using synchronous SRAM (i.e. SYNC_SRAM = 1'b1).
        NUM_WS_SRAM_READ    : integer range 0 to 3 := 1;		-- range 0-3
        NUM_WS_SRAM_WRITE   : integer range 1 to 3 := 1;		-- range 1-3

        -- Set SHARED_RW to 1 if shared read and write enables (MemReadN and
        -- MemWriteN) are used for SSRAM and Flash devices.
        -- Otherwise set to 0.
        SHARED_RW           : integer  range 0 to 1 := 0;

        -- FLASH_ADDR_SEL is used select which address bits are routed to
        -- flash memory. It can take the following values:
        --  0 -> MEMADDR[27:0] to flash is driven by HADDR[27:0]
        --  1 -> MEMADDR[27:0] to flash is driven by {0, HADDR[27:1]}
        --  2 -> MEMADDR[27:0] to flash is driven by {0, 0, HADDR[27:2]}
        FLASH_ADDR_SEL      : integer range 0 to 2 := 2;

        -- SRAM_ADDR_SEL is used select which address bits are routed to
        -- flash memory. It can take the following values:
        --  0 -> MEMADDR[27:0] to SRAM is driven by HADDR[27:0]
        --  1 -> MEMADDR[27:0] to SRAM is driven by {0, HADDR[27:1]}
        --  2 -> MEMADDR[27:0] to SRAM is driven by {0, 0, HADDR[27:2]}
        SRAM_ADDR_SEL       : integer range 0 to 2 := 2
    );
    port (
        -- AHB interface
        -- Inputs
        HCLK            : in std_logic;  			            -- AHB Clock
        HRESETN         : in std_logic;  			            -- AHB Reset
        HSEL            : in std_logic;   			            -- AHB select
        HWRITE          : in std_logic; 			            -- AHB Write
        HREADYIN        : in std_logic; 			            -- AHB HREADY line
        HTRANS          : in std_logic_vector(1 downto 0);      -- AHB HTRANS
        HSIZE           : in std_logic_vector(2 downto 0);      -- AHB transfer size
        HWDATA          : in std_logic_vector(31 downto 0);     -- AHB write data bus
        HADDR           : in std_logic_vector(27 downto 0);     -- AHB address bus
        -- Outputs
        HREADY          : out std_logic;     		            -- AHB ready signal
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
end component;

end components;
