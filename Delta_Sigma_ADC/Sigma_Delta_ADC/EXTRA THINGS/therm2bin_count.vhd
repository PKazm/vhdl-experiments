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
-- File       : fine_tdc.vhd
-- Author     : <h.a.r.homulle@tudelft.nl>
-- Company    : TU Delft
-- Last update: 2015-01-01
-- Platform   : FPGA (tested on Spartan 6 and Artix 7)
-----------------------------------------------------------------------------
-- Description: 
-- The thermometer decoder, with on the last stage the use of a bitter counter
-- to come around the bubbles. 
-----------------------------------------------------------------------------
-- Revisions  :
-- Date			Version		Author		Description
-- 2006  		1.0      	Claudio		Created
-- 2014  		2.0      	Homulle		Rewrote core code and added the Therm2bin with counter
-----------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.tdc_library.ALL;

ENTITY therm2bin_pipeline_count IS
	GENERIC (
		b 		: INTEGER);
    PORT (
		clock   : IN  std_logic;
		reset 	: IN  std_logic;
		valid 	: IN  std_logic;
		thermo  : IN  std_logic_vector(((2**b)-1) DOWNTO 0);
		bin     : OUT std_logic_vector((b-1) DOWNTO 0));
END therm2bin_pipeline_count;

ARCHITECTURE behaviour OF therm2bin_pipeline_count IS

	ATTRIBUTE keep_hierarchy 	: string;
	ATTRIBUTE keep_hierarchy OF behaviour	: ARCHITECTURE IS "true";

	SIGNAL stage_final_bin 	: std_logic_vector((b-1) DOWNTO 0);
	SIGNAL stage_final 		: std_logic_vector(15 DOWNTO 0);
	SIGNAL data_valid 		: std_logic_vector((b-3) DOWNTO 0);
	
	TYPE decoder_array IS ARRAY (0 TO b-4) OF std_logic_vector(((2**b)-2) DOWNTO 0);
    SIGNAL decoding : decoder_array;
	
	TYPE binary_array IS ARRAY (0 TO b-4) OF std_logic_vector(b DOWNTO 0);
    SIGNAL binary : binary_array;

BEGIN

	decoding(0) 	<= thermo(((2**b)-2) DOWNTO 0);
	data_valid(0) 	<= valid;
	
	generate_stages : FOR i IN 0 TO b-5 GENERATE
	
		stage_proc : PROCESS (clock, reset)
		BEGIN
			IF reset = '1' THEN
				decoding(i+1) 	<= (OTHERS => '0');
				binary(i+1) 	<= (OTHERS => '0');
				data_valid(i+1) <= '0';
			ELSIF rising_edge(clock) THEN
				binary(i+1)(b DOWNTO b-1-i) <=  binary(i)(b DOWNTO b-i) & decoding(i)(((2**(b-i))-2)/2);
				data_valid(i+1) <= data_valid(i);
				IF decoding(i)(((2**(b-i))-2)/2) = '1' THEN
					decoding(i+1)(((2**(b-i))-2)/2-1 DOWNTO 0) 	<= decoding(i)(((2**(b-i))-2) DOWNTO ((2**(b-i))-2)/2+1);
				ELSE
					decoding(i+1)(((2**(b-i))-2)/2-1 DOWNTO 0) 	<= decoding(i)(((2**(b-i))-2)/2-1 DOWNTO 0);
				END IF;
			END IF;
		END PROCESS;
	END GENERATE;
	
	stage_final 	<= decoding(b-4)(15 DOWNTO 0);

	-- The final stage of the decoder is a bit counter for the remaining 16 bits
	stage_final_proc : PROCESS (clock, reset)
	BEGIN
		IF reset = '1' THEN
			stage_final_bin 	<= (OTHERS => '0');
			data_valid(b-3) 	<= '0';
		ELSIF rising_edge(clock) THEN
			stage_final_bin 	<=  binary(b-4)(b-1 DOWNTO 4) & std_logic_vector(to_unsigned(count_ones(stage_final), 4));
			data_valid(b-3) 	<= data_valid(b-4);
		END IF;
	END PROCESS;

	sync : PROCESS (clock)
	BEGIN
		IF rising_edge(clock) THEN
			IF data_valid(b-3) = '1' THEN
				bin <= stage_final_bin;
			ELSE 
				bin <= (OTHERS => '0');
			END IF;
		END IF; 
	END PROCESS;

END behaviour;
