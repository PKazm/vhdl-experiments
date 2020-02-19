-----------------------------------------------------------------------------
-- Title      : FPGA TDC
-- Copyright © 2015 Harald Homulle / Edoardo Charbon
-----------------------------------------------------------------------------
-- This file is part of FPGA TDC.

-- FPGA TDC is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- FPGA TDC is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with FPGA TDC.  If not, see <http://www.gnu.org/licenses/>.
-----------------------------------------------------------------------------
-- File       : clock_manager_200MHz.vhd
-- Author     : <h.a.r.homulle@tudelft.nl>
-- Company    : TU Delft
-- Last update: 2015-01-01
-- Platform   : FPGA (tested on Spartan 6)
-----------------------------------------------------------------------------
-- Description: 
-- DCM clock manager for Spartan 6 to generate 
-- 200 MHz clock and inverted clock
-----------------------------------------------------------------------------
-- Revisions  :
-- Date			Version		Author		Description
-- 2014  		1.0      	Homulle		Clock manager
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;

LIBRARY unisim;
USE unisim.vcomponents.ALL;

ENTITY clock_dcm IS
	PORT (
		clk					: IN std_logic;
		reset				: IN std_logic;
		clock_200MHz		: OUT std_logic;
		clock_200MHz_inv	: OUT std_logic);
END clock_dcm;

ARCHITECTURE structure OF clock_dcm IS

	SIGNAL clk_200MHz_int 			: std_logic;
	SIGNAL clk_200MHz_fb 			: std_logic;
	SIGNAL clk_200MHz_dcm  			: std_logic;
	SIGNAL clk_200MHz_dcm_buf 		: std_logic;
	SIGNAL clk_200MHz_dcm_inv  		: std_logic;
	SIGNAL clk_200MHz_dcm_inv_buf 	: std_logic;

	SIGNAL locked		: std_logic;
	SIGNAL status		: std_logic_vector(7 DOWNTO 0);

BEGIN

	-- Input buffering of the clock
	clkin1_buf : IBUFG
		PORT MAP (
			O	=> clk_200MHz_int,
			I	=> clk);

	-- Generating the different clock frequencies
	dcm_sp_inst1: DCM_SP
		GENERIC MAP (
			CLKDV_DIVIDE          => 2.0,
			CLKFX_DIVIDE          => 2,
			CLKFX_MULTIPLY        => 8,
			CLKIN_DIVIDE_BY_2     => FALSE,
			CLKIN_PERIOD          => 5.0,
			CLKOUT_PHASE_SHIFT    => "NONE",
			CLK_FEEDBACK          => "1X",
			DESKEW_ADJUST         => "SYSTEM_SYNCHRONOUS",
			PHASE_SHIFT           => 0,
			STARTUP_WAIT          => TRUE)
		PORT MAP (
			-- Input clock
			CLKIN                 => clk_200MHz_int,
			CLKFB                 => clk_200MHz_fb,
			-- Output clocks
			CLK0                  => clk_200MHz_dcm,
			CLK90                 => OPEN,
			CLK180                => clk_200MHz_dcm_inv,
			CLK270                => OPEN,
			CLK2X                 => OPEN,
			CLK2X180              => OPEN,
			CLKFX                 => OPEN,
			CLKFX180              => OPEN,
			CLKDV                 => OPEN,
			-- Ports for dynamic phase shift
			PSCLK                 => '0',
			PSEN                  => '0',
			PSINCDEC              => '0',
			PSDONE                => OPEN,
			-- Other control and status signals
			LOCKED                => locked,
			STATUS                => status,
			RST                   => reset,
			-- Unused pin, tie low
			DSSEN                 => '0');

	-- Output buffering
	clk_200MHz_fb 		<= clk_200MHz_dcm_buf;
  
	clkout_200MHz_buf : BUFG
		PORT MAP (
			O   => clk_200MHz_dcm_buf,
			I   => clk_200MHz_dcm);
			
	clkout_200MHz_inv_buf : BUFG
		PORT MAP (
			O   => clk_200MHz_dcm_inv_buf,
			I   => clk_200MHz_dcm_inv);
	
	clock_200MHz 		<= clk_200MHz_dcm_buf;
	clock_200MHz_inv 	<= clk_200MHz_dcm_inv_buf;

END structure;