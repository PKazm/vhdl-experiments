--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Averager.vhd
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

entity Averager is
generic (
    data_bits : natural := 8;
    total_values : natural := 8;
    power2_values : natural := 3        -- used as div2 shift value
);
port (
    CLK : in std_logic;

    data_in : in std_logic_vector(data_bits - 1 downto 0);
    data_out : out std_logic_vector(data_bits - 1 downto 0)
);
end Averager;
architecture architecture_Averager of Averager is
    signal data_counter : natural range 0 to total_values - 1 := 0;

    signal data_store : unsigned(data_bits + power2_values - 1 downto 0) := (others => '0');
    signal data_out_sig : unsigned(data_bits - 1 downto 0) := (others => '0');

begin

    process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(data_counter = total_values - 1) then
                data_out_sig <= shift_right(data_store, power2_values)(data_bits - 1 downto 0);
                data_counter <= 0;
                data_store <= unsigned((data_bits + power2_values - 1 downto data_bits => '0') & data_in);
            else
                data_store <= data_store + unsigned(data_in);
                data_counter <= data_counter + 1;
            end if;
        end if;
    end process;

    data_out <= std_logic_vector(data_out_sig);

   -- architecture body
end architecture_Averager;
