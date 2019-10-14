--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Pull_Up.vhd
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

entity I2C_Pull_Up is
port (
    --<port_name> : <direction> <type>;
	I2C_SCL_IN : in std_logic_vector (1 downto 0);
	I2C_SDA_IN : in std_logic_vector (1 downto 0);

	I2C_SCL_OUT : out std_logic;
	I2C_SDA_OUT : out std_logic
    --<other_ports>;
);
end I2C_Pull_Up;
architecture architecture_I2C_Pull_Up of I2C_Pull_Up is
   -- signal, component etc. declarations

begin
	
	I2C_SCL_OUT <= '0' when I2C_SCL_IN(0) = '0' or I2C_SCL_IN(1) = '0' else '1';
	I2C_SDA_OUT <= '0' when I2C_SDA_IN(0) = '0' or I2C_SDA_IN(1) = '0' else '1';
   -- architecture body
end architecture_I2C_Pull_Up;
