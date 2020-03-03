--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Package.vhd
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

package FFT_package is

    constant SAMPLE_WIDTH_EXT : natural := 8;
    constant SAMPLE_WIDTH_INT : natural := 9;
    constant SAMPLE_CNT_EXP : natural := 5;
    constant SAMPLE_CNT : natural := 2**SAMPLE_CNT_EXP;
    constant SAMPLE_BLOCKS : natural := 3;
    constant PORT_CNT : natural := 2;

    constant IMAG_INIT : std_logic_vector(SAMPLE_WIDTH_INT - 1 downto 0) := (others => '0');

    -- RAM data arrays (should infer SRAM blocks based on control signal usages)
    type time_sample_mem is array (SAMPLE_CNT - 1 downto 0) of std_logic_vector(SAMPLE_WIDTH_INT * 2 - 1 downto 0);
    type ram_block_mem is array (SAMPLE_BLOCKS - 1 downto 0) of time_sample_mem;

    -- RAM control signal groupings
    type w_en_array_type is array(PORT_CNT - 1 downto 0) of std_logic;
    type r_en_array_type is array(PORT_CNT - 1 downto 0) of std_logic;
    type adr_array_type is array(PORT_CNT - 1 downto 0) of std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    type ram_dat_array_type is array(PORT_CNT - 1 downto 0) of std_logic_vector(SAMPLE_WIDTH_INT * 2 - 1 downto 0);

    function BIT_REV_FUNC (input_vector : in std_logic_vector)
        return std_logic_vector;

    function RND_HALF_TO_EVEN_BIAS_GEN (input_vector : in std_logic_vector; rnd_width : in natural)
        return std_logic_vector;

end package FFT_package;

package body FFT_package is

    function BIT_REV_FUNC (input_vector : in std_logic_vector) return std_logic_vector is
        variable bit_rev_result : std_logic_vector(input_vector'high downto 0);
    begin
        for i in 0 to (SAMPLE_CNT - 1) loop
            -- This loop reverses the bit order of input_vector
            for k in 1 to input_vector'length loop
                bit_rev_result(input_vector'length - k) := input_vector(k - 1);
            end loop;
        end loop;
        return bit_rev_result;
    end;

    function RND_HALF_TO_EVEN_BIAS_GEN (input_vector : in std_logic_vector; rnd_width : in natural) return std_logic_vector is
        variable leading_zeros : std_logic_vector(rnd_width - 1 downto 0);
        variable cutoff_bit : std_logic;
        variable lower_bits : std_logic_vector(input_vector'length - rnd_width - 2 downto 0);

        variable bias_vector : std_logic_vector(input_vector'high downto 0);
    begin
        leading_zeros := (others => '0');
        cutoff_bit := input_vector(input_vector'length - rnd_width);
        lower_bits := (others => not input_vector(input_vector'length - rnd_width));
        bias_vector := leading_zeros & cutoff_bit & lower_bits;
        return bias_vector;
    end;

end package body FFT_package;
