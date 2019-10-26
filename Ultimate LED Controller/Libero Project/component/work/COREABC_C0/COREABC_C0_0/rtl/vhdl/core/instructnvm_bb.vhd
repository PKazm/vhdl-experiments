-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  instructnvm.vhd (black box version)
--
-- Description: Simple APB Bus Controller
--              Contains the Instruction storage NVM block
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 14578 $
-- SVN $Date: 2010-11-10 15:03:21 +0000 (Wed, 10 Nov 2010) $
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

entity COREABC_C0_COREABC_C0_0_INSTRUCTNVM is
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
            UNIQ_STRING_LENGTH  : integer range 1 to 256 := 10
           );
  port( CLK         : in  std_logic;
        RSTN        : in  std_logic;
        START       : in  std_logic;
        STALL       : out std_logic;
        ADDRESS     : in  std_logic_vector(ICWIDTH-1 downto 0);
        INSTRUCTION : out std_logic_vector(IWWIDTH-1 downto 0);
        PSEL        : in  std_logic;
        PENABLE     : in  std_logic;
        PWRITE      : in  std_logic;
        PADDR       : in  std_logic_vector(AWIDTH-1 downto 0);
        PWDATA      : in  std_logic_vector(DWIDTH-1 downto 0);
        PRDATA      : out std_logic_vector(DWIDTH-1 downto 0);
        PSLVERR     : out std_logic;
        PREADY      : out std_logic
       );
end COREABC_C0_COREABC_C0_0_INSTRUCTNVM;


architecture bb of COREABC_C0_COREABC_C0_0_INSTRUCTNVM is
begin
end bb;
