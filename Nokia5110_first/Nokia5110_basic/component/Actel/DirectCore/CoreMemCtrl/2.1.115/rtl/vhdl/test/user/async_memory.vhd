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
--          Simple model of asynchronous type memory
--
--
-- SVN Revision Information:
-- SVN $Revision: 6822 $
-- SVN $Date: 2009-02-23 07:24:01 -0800 (Mon, 23 Feb 2009) $
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

entity async_memory is
    port (
        -- Inputs
        A       : in  std_logic_vector(18 downto 0);    -- Address bus
        CSN     : in  std_logic;                        -- Chip enable
        OEN     : in  std_logic;                        -- Output enable
        WEN     : in  std_logic;                        -- Write enable
        BYTEN   : in  std_logic_vector(1 downto 0);     -- Byte enables
        -- Inout
        DQ      : inout std_logic_vector(15 downto 0)   -- Data bus
    );
end async_memory;

architecture behav of async_memory is
    type arr is array(0 to 1023) of std_logic_vector(15 downto 0);

    signal iDQ              : std_logic_vector(15 downto 0);
    signal A_latch          : std_logic_vector(18 downto 0);
    signal mem              : arr;

    signal read             : std_logic;
    signal write            : std_logic;

begin
    read  <= not(CSN) and not(OEN) and   WEN   ;
    write <= not(CSN) and   OEN    and not(WEN);

    DQ <= iDQ when read = '1' else "ZZZZZZZZZZZZZZZZ";

    process (read, A)
    variable iA : integer;
    begin
        iA := to_integer(unsigned(A));
        if (read = '1') then
            iDQ <= mem(iA);
        else
            iDQ <= "ZZZZZZZZZZZZZZZZ";
        end if;
    end process;

    -- Latch address input on write rising edge
    process (write, A)
    begin
        if (write'event and write = '1') then
            A_latch <= A;
        end if;
    end process;

    -- Write data on write falling edge
    process (write, BYTEN, A_latch, DQ)
    variable iA_latch : integer;
    begin
        iA_latch := to_integer(unsigned(A_latch));
        if (write'event and write = '0') then
            case BYTEN(1 downto 0) is
                when "10" => mem(iA_latch) <= mem(iA_latch)(15 downto 8) & DQ(7 downto 0);
                when "01" => mem(iA_latch) <= DQ(15 downto 8) & mem(iA_latch)(7 downto 0);
                when "00" => mem(iA_latch) <= DQ(15 downto 0);
                when others => mem(iA_latch) <= mem(iA_latch);
            end case;
        end if;
    end process;

end behav;
