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
-- File       : top.vhd
-- Author     : <h.a.r.homulle@tudelft.nl>
-- Company    : TU Delft
-- Last update: 2015-01-01
-- Platform   : FPGA (tested on Spartan 6 and Artix 7)
-----------------------------------------------------------------------------
-- Description: 
-- Top level file for ADC implementation
-----------------------------------------------------------------------------
-- Revisions  :
-- Date			Version		Author		Description
-- 2014  		1.0      	Homulle		First ADC toplevel file
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 
USE ieee.std_logic_misc.ALL;

LIBRARY unisim;
USE unisim.vcomponents.ALL;

LIBRARY work;
USE work.tdc_library.ALL;

ENTITY top IS
	GENERIC (
		STAGES		: INTEGER := 512;
		FINE_BITS	: INTEGER := 9;
		Xoff_TDC1	: INTEGER := 34;
		Xoff_TDC2	: INTEGER := 52;
		Yoff		: INTEGER := 32);
	PORT (
		user_reset 	: IN std_logic;
		clk_in	   	: IN std_logic; 	-- input 200 MHz clock
		clk_out		: OUT std_logic; 	-- clock to generate ramp	
		V_IN		: IN std_logic; 	-- the analog input signal
		V_REF		: IN std_logic; 	-- the reference input signal (ramp)
		digital_out	: OUT std_logic_vector(FINE_BITS DOWNTO 0));
END top;

ARCHITECTURE behaviour OF top IS
	
	SIGNAL comp_out			: std_logic;
	
	SIGNAL value_fine_1		: std_logic_vector(FINE_BITS DOWNTO 0);
	SIGNAL value_fine_2		: std_logic_vector(FINE_BITS DOWNTO 0);

	SIGNAL clock_200MHz		: std_logic;
	SIGNAL clock_200MHz_inv	: std_logic;
	
BEGIN

	digital_out 	<= 255 - value_fine_2 + value_fine_1;

	comparator : IBUFDS
		GENERIC MAP (
			DIFF_TERM 		=> FALSE,
			IBUF_LOW_PWR 	=> FALSE,
			IOSTANDARD 		=> "LVDS_33")
		PORT MAP (
			O 	=> comp_out, 	-- buffer output --> to TDC
			I 	=> V_REF, 		-- input for the reference signal (ramp)
			IB 	=> V_IN); 		-- input for analog signal
			
	---------------------------------------------

	TDC1 : fine_tdc_with_encoder
		GENERIC MAP (
			STAGES 		=> STAGES, 
			FINE_BITS	=> FINE_BITS,
			Xoff		=> Xoff_TDC1,
			Yoff		=> Yoff)
		PORT MAP (
			clock 			=> clock_200MHz,
			reset 			=> user_reset,
			hit 			=> comp_out,
			value_fine 		=> value_fine_1(FINE_BITS-1 DOWNTO 0));	

	TDC2 : fine_tdc_with_encoder
		GENERIC MAP (
			STAGES 		=> STAGES, 
			FINE_BITS	=> FINE_BITS,
			Xoff		=> Xoff_TDC2,
			Yoff		=> Yoff)
		PORT MAP (
			clock 			=> clock_200MHz_inv,
			reset 			=> user_reset,
			hit 			=> NOT comp_out,
			value_fine 		=> value_fine_2(FINE_BITS-1 DOWNTO 0));				
	
	---------------------------------------------
	
	clk_buf : ODDR2 -- ODDR buffer for the clock to create the reference ramp outside the FPGA
		PORT MAP (
			D0     => '1',                
			D1     => '0',
			C0     => clock_200MHz_inv,
			C1     => not clock_200MHz_inv,
			Q      => clk_out,
			CE     => OPEN,
			S      => OPEN,
			R      => OPEN);
			
	---------------------------------------------

	clk_mapping : clock_dcm
		PORT MAP (
			clk		 			=> clk_in,
			reset 				=> user_reset,
			clock_200MHz 		=> clock_200MHz,
			clock_200MHz_inv 	=> clock_200MHz_inv);

END behaviour;
