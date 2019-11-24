--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Base_Design.vhd
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

entity Base_Design is
port (
    CLK_in : in std_logic;		-- 100Mhz
	RSTn : in std_logic;

	Board_Buttons : in std_logic_vector(1 downto 0);
    Board_LEDs : out std_logic_vector(7 downto 0)
);
end Base_Design;
architecture architecture_Base_Design of Base_Design is

	signal Button_last : std_logic;
	signal button_sig : std_logic;

begin

	process(CLK_in, RSTn)
	begin
		if(RSTn = '0') then
			button_sig <= '0';
			Button_last <= '0';
		elsif(rising_edge(CLK_in)) then
			Button_last <= Board_Buttons(0);

			if(Button_last = '0' and Board_Buttons(0) = '1') then
				button_sig <= not button_sig;
			end if;
		end if;
    end process;

	-- BEGIN outputs directly to board pins
	Board_LEDs(0) <= not button_sig;
	-- END outputs directly to board pins
	-- architecture body
end architecture_Base_Design;
