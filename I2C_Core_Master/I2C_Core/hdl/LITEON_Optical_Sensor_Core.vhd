--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: LITEON_Optical_Sensor_Core.vhd
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

entity LITEON_Optical_Sensor_Core is
generic (

);
port (
   CLK : in std_logic;
   RSTn : in std_logic;
   core_busy : out std_logic;
   
	-- I2C connections
	SDAO : out std_logic;
	SCLO : out std_logic;
	-- I2C connections

	-- APB connections
	PADDR : in std_logic_vector(7 downto 0);
	PSEL : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(7 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(7 downto 0);
	PSLVERR : out std_logic

	--INT : out std_logic;
    -- APB connections
);
end LITEON_Optical_Sensor_Core;
architecture architecture_LITEON_Optical_Sensor_Core of LITEON_Optical_Sensor_Core is
   -- signal, component etc. declarations
	signal signal_name1 : std_logic; -- example
	signal signal_name2 : std_logic_vector(1 downto 0) ; -- example

begin

   -- architecture body
end architecture_LITEON_Optical_Sensor_Core;
