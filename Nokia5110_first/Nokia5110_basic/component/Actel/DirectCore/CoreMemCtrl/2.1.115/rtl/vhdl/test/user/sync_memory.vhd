-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
-- Copyright 2009 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
--
-- Description :
--          Simple model of synchronous type memory
--
--
-- SVN Revision Information:
-- SVN $Revision: 7336 $
-- SVN $Date: 2009-03-09 08:33:23 -0700 (Mon, 09 Mar 2009) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
--
-- Notes:
--
--
-- *********************************************************************/

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned."-";
use     ieee.numeric_std.all;

entity sync_memory is
    port (
        -- Inputs
        A       : in  std_logic_vector(18 downto 0);    -- Address bus
        CSN     : in  std_logic;                        -- Chip enable
        OEN     : in  std_logic;                        -- Output enable
        WEN     : in  std_logic;                        -- Write enable
        BYTEN   : in  std_logic_vector(1 downto 0);     -- Byte enables
        CLK     : in  std_logic;                        -- Clock
        FTN     : in  std_logic;                        -- Flow-through/pipeline mode
        -- Inout
        DQ      : inout std_logic_vector(15 downto 0)   -- Data bus
    );
end sync_memory;

architecture behav of sync_memory is
    type arr is array(0 to 1023) of std_logic_vector(15 downto 0);

    signal iDQ                  : std_logic_vector(15 downto 0);
    signal A_reg, A_reg2        : std_logic_vector(18 downto 0);
    signal mem                  : arr;

    signal OEN_reg, OEN_reg2    : std_logic;
    signal WEN_reg, WEN_reg2    : std_logic;
    signal CSN_reg              : std_logic;

begin
    DQ <= iDQ when (CSN_reg = '0' and OEN = '0') else "ZZZZZZZZZZZZZZZZ";

    process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            CSN_reg <= CSN;
        end if;
    end process;

    process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (CSN = '0') then
                A_reg   <= A;
                OEN_reg <= OEN;
                WEN_reg <= WEN;
            else
                A_reg   <= A_reg;
                OEN_reg <= '1';
                WEN_reg <= '1';
            end if;
            A_reg2   <= A_reg;
            OEN_reg2 <= OEN_reg;
            WEN_reg2 <= WEN_reg;
        end if;
    end process;

    process (FTN, A_reg, A_reg2)
    variable iA_reg  : integer;
    variable iA_reg2 : integer;
    begin
        iA_reg  := to_integer(unsigned(A_reg));
        iA_reg2 := to_integer(unsigned(A_reg2));
        if (FTN = '0') then
            iDQ <= mem(iA_reg);
        else
            iDQ <= mem(iA_reg2);
        end if;
    end process;

    process (CLK)
    variable iA : integer;
    begin
        iA := to_integer(unsigned(A));
        if (CLK'event and CLK = '1') then
            if (CSN = '0' and WEN = '0') then
                case BYTEN(1 downto 0) is
                    when "10" => mem(iA) <= mem(iA)(15 downto 8) & DQ(7 downto 0);
                    when "01" => mem(iA) <= DQ(15 downto 8) & mem(iA)(7 downto 0);
                    when "00" => mem(iA) <= DQ(15 downto 0);
                    when others => mem(iA) <= mem(iA);
                end case;
            end if;
        end if;
    end process;

end behav;
