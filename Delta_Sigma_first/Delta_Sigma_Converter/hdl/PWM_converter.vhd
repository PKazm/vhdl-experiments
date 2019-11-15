--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: PWM_converter.vhd
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

entity PWM_converter is
generic (
    value_bits : natural := 8;
    quantize_steps : natural := 8       -- how many counts for each PWM measurement
);
port (
    CLK : in std_logic;

    PWM_in : in std_logic;
    value_out : out std_logic_vector(value_bits - 1 downto 0)
);
end PWM_converter;
architecture architecture_PWM_converter of PWM_converter is
    signal value_out_count : unsigned(value_bits - 1 downto 0) := (others => '0');
    signal value_out_sig : unsigned(value_bits - 1 downto 0) := (others => '0');

    signal counter : natural range 0 to quantize_steps - 1 := 0;

begin

    process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(counter = quantize_steps - 1) then
                value_out_sig <= value_out_count;
                counter <= 0;
                value_out_count <= (value_out_count'high => '0', others => '1');
            else
                if(PWM_in = '1') then
                    value_out_count <= value_out_count + 1;
                else
                    value_out_count <= value_out_count - 1;
                end if;
                counter <= counter + 1;
            end if;
        end if;
    end process;

    value_out <= std_logic_vector(value_out_sig);
   -- architecture body
end architecture_PWM_converter;
