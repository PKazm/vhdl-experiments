--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Butterfly_HW_DSP.vhd
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

entity Butterfly_HW_DSP is
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    A : in std_logic_vector(9 downto 0);
    B : in std_logic_vector(9 downto 0);

    P : out std_logic_vector(9 downto 0)
);
end Butterfly_HW_DSP;
architecture architecture_Butterfly_HW_DSP of Butterfly_HW_DSP is
    

begin

   -- architecture body
end architecture_Butterfly_HW_DSP;
