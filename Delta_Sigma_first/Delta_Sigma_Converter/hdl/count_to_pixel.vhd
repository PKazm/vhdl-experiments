--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: count_to_pixel.vhd
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
use IEEE.numeric_std.all;

entity count_to_pixel is
port (
    value_in : in std_logic_vector (7 downto 0);
    
    pixels_out : out std_logic_vector (31 downto 0)
);
end count_to_pixel;
architecture architecture_count_to_pixel of count_to_pixel is
   -- signal, component etc. declarations

begin

	process(value_in)
	begin
		for I in 0 to 31 loop
			if(to_integer(unsigned(value_in)) > (I * 2) + 1) then
				pixels_out(i) <= '1';
			else
				pixels_out(I) <= '0';
			end if;
		end loop;
	end process;

   -- architecture body
end architecture_count_to_pixel;
