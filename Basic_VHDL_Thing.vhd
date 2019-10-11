--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Basic_VHDL_Thing.vhd
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

entity Basic_VHDL_Thing is
port (
    --<port_name> : <direction> <type>;
	CLK_in : in std_logic;		-- 100 kHz

	Board_Buttons : in std_logic_vector (1 downto 0);
	Board_LEDs : out std_logic_vector (7 downto 0);
	Board_MOD1 : out std_logic_vector (5 downto 0);
	Board_J7 : out std_logic_vector (4 downto 0)
    --<other_ports>;
);
end Basic_VHDL_Thing;
architecture architecture_Basic_VHDL_Thing of Basic_VHDL_Thing is
   -- signal, component etc. declarations
	signal state_counter : unsigned (4 downto 0) := (others => '0');
	signal Board_Buttons_last : std_logic_vector (1 downto 0) := (others => '0');
begin
	
	process(CLK_in)		-- Direct Test Signal with State Machine
	begin

		if(rising_edge(CLK_in)) then
			Board_Buttons_last <= Board_Buttons;
			
			if(Board_Buttons(0) = '1' and Board_Buttons_last(0) = '0') then
				if(state_counter >= 18) then
					state_counter <= to_unsigned(0, 5);
				else
					-- NEXT STATE
					state_counter <= state_counter + 1;
				end if;
			elsif(Board_Buttons(1) = '1' and Board_Buttons_last(1) = '0') then
				-- RESET STATE
				state_counter <= to_unsigned(0, 5);
			end if;
		end if;
	end process;

	Board_LEDs(0) <= CLK_in when to_integer(unsigned(state_counter)) = 0 else '1';
	Board_LEDs(1) <= CLK_in when to_integer(unsigned(state_counter)) = 1 else '1';
	Board_LEDs(2) <= CLK_in when to_integer(unsigned(state_counter)) = 2 else '1';
	Board_LEDs(3) <= CLK_in when to_integer(unsigned(state_counter)) = 3 else '1';
	Board_LEDs(4) <= CLK_in when to_integer(unsigned(state_counter)) = 4 else '1';
	Board_LEDs(5) <= CLK_in when to_integer(unsigned(state_counter)) = 5 else '1';
	Board_LEDs(6) <= CLK_in when to_integer(unsigned(state_counter)) = 6 else '1';
	Board_LEDs(7) <= CLK_in when to_integer(unsigned(state_counter)) = 7 else '1';

	Board_MOD1(0) <= CLK_in when to_integer(unsigned(state_counter)) = 8 else '0';
	Board_MOD1(1) <= CLK_in when to_integer(unsigned(state_counter)) = 9 else '0';
	Board_MOD1(2) <= CLK_in when to_integer(unsigned(state_counter)) = 10 else '0';
	Board_MOD1(3) <= CLK_in when to_integer(unsigned(state_counter)) = 11 else '0';
	Board_MOD1(4) <= CLK_in when to_integer(unsigned(state_counter)) = 12 else '0';
	Board_MOD1(5) <= CLK_in when to_integer(unsigned(state_counter)) = 13 else '0';

	Board_J7(0) <= CLK_in when to_integer(unsigned(state_counter)) = 14 else '0';
	Board_J7(1) <= CLK_in when to_integer(unsigned(state_counter)) = 15 else '0';
	Board_J7(2) <= CLK_in when to_integer(unsigned(state_counter)) = 16 else '0';
	Board_J7(3) <= CLK_in when to_integer(unsigned(state_counter)) = 17 else '0';
	Board_J7(4) <= CLK_in when to_integer(unsigned(state_counter)) = 18 else '0';

   -- architecture body
end architecture_Basic_VHDL_Thing;
