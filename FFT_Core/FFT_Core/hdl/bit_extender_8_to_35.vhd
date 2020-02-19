--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: bit_extender_8_to_35.vhd
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

entity bit_extender_8_to_35 is
port (
    input : in std_logic_vector(8 downto 0);
	output : out std_logic_vector(34 downto 0)
);
end bit_extender_8_to_35;
architecture architecture_bit_extender_8_to_35 of bit_extender_8_to_35 is
	constant IN_LENGTH : natural := 9;
	constant OUT_START : natural := 0;
begin
	output <= (34 downto OUT_START + IN_LENGTH => input(8), OUT_START + IN_LENGTH - 1 downto OUT_START => input, others => '0');

   -- architecture body
end architecture_bit_extender_8_to_35;
