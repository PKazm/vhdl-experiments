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
-------------------------------------------------------------------------------
-- File       : fine_tdc_with_encoder.vhd
-- Author     : <h.a.r.homulle@tudelft.nl>
-- Company    : TU Delft
-- Last update: 2015-01-01
-- Platform   : FPGA (tested on Spartan 6 and Artix 7)
-------------------------------------------------------------------------------
-- Description: 
-- Single TDC with encoder, this block instantiated the carrychain TDC delay line
-- and adds the thermometer to binary decoder with counter on last stages. 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date			Version		Author		Description
-- 2006  		1.0      	Claudio		Created
-- 2014  		2.0      	Homulle		Rewrote core code and added the Therm2bin with counter
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

LIBRARY unisim;
USE unisim.vcomponents.ALL;

LIBRARY work;
USE work.tdc_library.ALL;

ENTITY fine_tdc_with_encoder IS
	GENERIC (
		STAGES		: INTEGER := 256;
		FINE_BITS	: INTEGER := 8;
		Xoff		: INTEGER := 8;
		Yoff		: INTEGER := 24);
	PORT (
		clock 			: IN  std_logic;
		reset 			: IN  std_logic;
		hit 			: IN  std_logic;
		value_fine		: OUT std_logic_vector((FINE_BITS-1) DOWNTO 0));
END fine_tdc_with_encoder;

ARCHITECTURE structure OF fine_tdc_with_encoder IS
	ATTRIBUTE keep_hierarchy 	: string;
	ATTRIBUTE keep_hierarchy OF structure	: ARCHITECTURE IS "true";

	SIGNAL fine_value_reg	: std_logic_vector((STAGES-1) DOWNTO 0);
	SIGNAL fine_value_bin 	: std_logic_vector((FINE_BITS-1) DOWNTO 0);
	
	SIGNAL filtered_hit_1 	: std_logic;
	SIGNAL filtered_hit_2 	: std_logic;
	SIGNAL filtered_hit 	: std_logic;
	SIGNAL fired 			: std_logic;
	SIGNAL valid 			: std_logic;
	
BEGIN
	
	input_filter1 : FDCE
		GENERIC MAP (
			INIT => '0')
		PORT MAP (
			Q    => filtered_hit_1,
			CLR  => filtered_hit_1,
			D    => '1',
			C    => hit,
			CE   => '1');
			
	input_filter2 : FDCE
		GENERIC MAP (
			INIT => '0')
		PORT MAP (
			Q    => filtered_hit_2,
			CLR  => filtered_hit_1,
			D    => '1',
			C    => clock,
			CE   => '1');

	filtered_hit <= NOT filtered_hit_2;

	input_filter_fired1 : FDCE
		GENERIC MAP (
			INIT => '0')
		PORT MAP (
			Q    => fired,
			CLR  => '0',
			D    => filtered_hit,
			C    => clock,
			CE   => '1');
			
	input_filter_fired2 : FDCE
		GENERIC MAP (
			INIT => '0')
		PORT MAP (
			Q    => valid,
			CLR  => '0',
			D    => fired,
			C    => clock,
			CE   => '1');

	fine : fine_tdc
		GENERIC MAP (
			STAGES 	=> STAGES,
			Xoff	=> Xoff,
			Yoff	=> Yoff)
		PORT MAP (
			trigger   		=> filtered_hit,
			clock    		=> clock,
			reset	 		=> reset,
			latched_output	=> fine_value_reg);

	t2b : therm2bin_pipeline_count
		GENERIC MAP (
			b 		=> FINE_BITS)
		PORT MAP (
			clock   => clock,
			reset	=> reset,
			valid 	=> valid, 
			thermo  => fine_value_reg,
			bin     => fine_value_bin);
	
	value_fine 		<= fine_value_bin;

END structure;
