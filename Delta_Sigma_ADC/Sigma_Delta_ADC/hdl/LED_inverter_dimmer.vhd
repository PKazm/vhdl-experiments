--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: LED_inverter_dimmer.vhd
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

entity LED_inverter_dimmer is
port (
    CLK : in std_logic;
	LED_toggles : in std_logic_vector(7 downto 0);
    Board_LEDs : out std_logic_vector(7 downto 0)
);
end LED_inverter_dimmer;
architecture architecture_LED_inverter_dimmer of LED_inverter_dimmer is
	signal dim_cnt : unsigned(1 downto 0);

begin
	
	g_led_toggles : for i in 0 to 7 generate
		Board_LEDs(i) <= CLK when LED_toggles(i) = '1' else '1';
	end generate;
   -- architecture body
end architecture_LED_inverter_dimmer;
