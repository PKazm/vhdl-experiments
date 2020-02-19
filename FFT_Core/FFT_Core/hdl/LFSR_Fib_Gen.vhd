--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: LFSR_Fib_Gen.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S010> <Package::144 TQ>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity LFSR_Fib_Gen is
generic (
    g_out_width : natural := 9
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;
    
    rand : out std_logic_vector(g_out_width - 1 downto 0)
);
end LFSR_Fib_Gen;
architecture architecture_LFSR_Fib_Gen of LFSR_Fib_Gen is
    --signal random_num : std_logic_vector(g_out_width - 1 downto 0);

    signal fib_reg : std_logic_vector(15 downto 0);
     
begin
    process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            fib_reg <= X"ACE1";
        elsif(rising_edge(PCLK)) then
            fib_reg(0) <= fib_reg(11) xor fib_reg(13) xor fib_reg(14) xor fib_reg(15);
            for I in 1 to fib_reg'high loop
                fib_reg(I) <= fib_reg(I - 1);
            end loop;
        end if;
    end process;

    rand <= fib_reg(rand'high downto 0);

   -- architecture body
end architecture_LFSR_Fib_Gen;
