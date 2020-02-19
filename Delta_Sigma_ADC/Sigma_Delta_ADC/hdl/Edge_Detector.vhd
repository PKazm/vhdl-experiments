--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Edge_Detector.vhd
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

entity Edge_Detector is
generic (
    g_data_in_bits : natural := 8
);
port (
    PCLK : in std_logic;      -- 100Mhz
    RSTn : in std_logic;

    Data_in_ready : in std_logic;
    Data_in : in std_logic_vector(g_data_in_bits - 1 downto 0);

    edge_pulse : out std_logic
);
end Edge_Detector;
architecture architecture_Edge_Detector of Edge_Detector is
    type mem_type is array (3 downto 0) of unsigned (g_data_in_bits - 1 downto 0);
    signal samples_mem : mem_type;

begin
    process(PCLK, RSTn)
    begin
        if(RSTn = '0') then

        elsif(rising_edge(PCLK)) then
            
        end if;
    end process;
   -- architecture body
end architecture_Edge_Detector;
