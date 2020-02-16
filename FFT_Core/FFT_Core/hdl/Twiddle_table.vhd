--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Twiddle_table.vhd
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
use IEEE.math_real.all;


entity Twiddle_table is
generic (
    g_data_samples_exp : natural := 8    --
    --g_bit_depth : natural := 9
);
port (
    -- twiddle count is half of sample count
    twiddle_index : in std_logic_vector(g_data_samples_exp - 2 downto 0);

    cos_twid : out std_logic_vector(8 downto 0);
    sin_twid : out std_logic_vector(8 downto 0)
);
end Twiddle_table;
architecture architecture_Twiddle_table of Twiddle_table is
    constant TWIDDLE_CNT_EXP : natural := g_data_samples_exp - 1;
    constant TWIDDLE_CNT : natural := 2**TWIDDLE_CNT_EXP;
    --type twiddle_table_type is array (TWIDDLE_CNT - 1 downto 0) of integer range -255 to 255;
    type twiddle_table_type is array (0 to TWIDDLE_CNT - 1) of signed(8 downto 0);
    
    function init_cos return twiddle_table_type is
        variable out_cos : twiddle_table_type;
    begin
        case g_data_samples_exp is
            when 2 =>
                out_cos := (
                    to_signed(255, 9), to_signed(0, 9)
                );
            when 3 =>
                out_cos := (
                    to_signed(255, 9), to_signed(180, 9), to_signed(0, 9), to_signed(-180, 9)
                );
            when 4 =>
                out_cos := (
                    to_signed(255, 9), to_signed(236, 9), to_signed(180, 9), to_signed(98, 9), to_signed(0, 9), to_signed(-98, 9), to_signed(-180, 9), to_signed(-236, 9)
                );
            when 5 =>
                out_cos := (
                    to_signed(255, 9), to_signed(250, 9), to_signed(236, 9), to_signed(212, 9), to_signed(180, 9), to_signed(142, 9), to_signed(98, 9), to_signed(50, 9), to_signed(0, 9), to_signed(-50, 9), to_signed(-98, 9), to_signed(-142, 9), to_signed(-180, 9), to_signed(-212, 9), to_signed(-236, 9), to_signed(-250, 9)
                );
            when 6 =>
                out_cos := (
                    to_signed(255, 9), to_signed(254, 9), to_signed(250, 9), to_signed(244, 9), to_signed(236, 9), to_signed(225, 9), to_signed(212, 9), to_signed(197, 9), to_signed(180, 9), to_signed(162, 9), to_signed(142, 9), to_signed(120, 9), to_signed(98, 9), to_signed(74, 9), to_signed(50, 9), to_signed(25, 9), to_signed(0, 9), to_signed(-25, 9), to_signed(-50, 9), to_signed(-74, 9), to_signed(-98, 9), to_signed(-120, 9), to_signed(-142, 9), to_signed(-162, 9), to_signed(-180, 9), to_signed(-197, 9), to_signed(-212, 9), to_signed(-225, 9), to_signed(-236, 9), to_signed(-244, 9), to_signed(-250, 9), to_signed(-254, 9)
                );
            when 7 =>
                out_cos := (
                    to_signed(255, 9), to_signed(255, 9), to_signed(254, 9), to_signed(252, 9), to_signed(250, 9), to_signed(247, 9), to_signed(244, 9), to_signed(240, 9), to_signed(236, 9), to_signed(231, 9), to_signed(225, 9), to_signed(219, 9), to_signed(212, 9), to_signed(205, 9), to_signed(197, 9), to_signed(189, 9), to_signed(180, 9), to_signed(171, 9), to_signed(162, 9), to_signed(152, 9), to_signed(142, 9), to_signed(131, 9), to_signed(120, 9), to_signed(109, 9), to_signed(98, 9), to_signed(86, 9), to_signed(74, 9), to_signed(62, 9), to_signed(50, 9), to_signed(37, 9), to_signed(25, 9), to_signed(13, 9), to_signed(0, 9), to_signed(-13, 9), to_signed(-25, 9), to_signed(-37, 9), to_signed(-50, 9), to_signed(-62, 9), to_signed(-74, 9), to_signed(-86, 9), to_signed(-98, 9), to_signed(-109, 9), to_signed(-120, 9), to_signed(-131, 9), to_signed(-142, 9), to_signed(-152, 9), to_signed(-162, 9), to_signed(-171, 9), to_signed(-180, 9), to_signed(-189, 9), to_signed(-197, 9), to_signed(-205, 9), to_signed(-212, 9), to_signed(-219, 9), to_signed(-225, 9), to_signed(-231, 9), to_signed(-236, 9), to_signed(-240, 9), to_signed(-244, 9), to_signed(-247, 9), to_signed(-250, 9), to_signed(-252, 9), to_signed(-254, 9), to_signed(-255, 9)
                );
            when 8 =>
                out_cos := (
                    to_signed(255, 9), to_signed(255, 9), to_signed(255, 9), to_signed(254, 9), to_signed(254, 9), to_signed(253, 9), to_signed(252, 9), to_signed(251, 9), to_signed(250, 9), to_signed(249, 9), to_signed(247, 9), to_signed(246, 9), to_signed(244, 9), to_signed(242, 9), to_signed(240, 9), to_signed(238, 9), to_signed(236, 9), to_signed(233, 9), to_signed(231, 9), to_signed(228, 9), to_signed(225, 9), to_signed(222, 9), to_signed(219, 9), to_signed(215, 9), to_signed(212, 9), to_signed(208, 9), to_signed(205, 9), to_signed(201, 9), to_signed(197, 9), to_signed(193, 9), to_signed(189, 9), to_signed(185, 9), to_signed(180, 9), to_signed(176, 9), to_signed(171, 9), to_signed(167, 9), to_signed(162, 9), to_signed(157, 9), to_signed(152, 9), to_signed(147, 9), to_signed(142, 9), to_signed(136, 9), to_signed(131, 9), to_signed(126, 9), to_signed(120, 9), to_signed(115, 9), to_signed(109, 9), to_signed(103, 9), to_signed(98, 9), to_signed(92, 9), to_signed(86, 9), to_signed(80, 9), to_signed(74, 9), to_signed(68, 9), to_signed(62, 9), to_signed(56, 9), to_signed(50, 9), to_signed(44, 9), to_signed(37, 9), to_signed(31, 9), to_signed(25, 9), to_signed(19, 9), to_signed(13, 9), to_signed(6, 9), to_signed(0, 9), to_signed(-6, 9), to_signed(-13, 9), to_signed(-19, 9), to_signed(-25, 9), to_signed(-31, 9), to_signed(-37, 9), to_signed(-44, 9), to_signed(-50, 9), to_signed(-56, 9), to_signed(-62, 9), to_signed(-68, 9), to_signed(-74, 9), to_signed(-80, 9), to_signed(-86, 9), to_signed(-92, 9), to_signed(-98, 9), to_signed(-103, 9), to_signed(-109, 9), to_signed(-115, 9), to_signed(-120, 9), to_signed(-126, 9), to_signed(-131, 9), to_signed(-136, 9), to_signed(-142, 9), to_signed(-147, 9), to_signed(-152, 9), to_signed(-157, 9), to_signed(-162, 9), to_signed(-167, 9), to_signed(-171, 9), to_signed(-176, 9), to_signed(-180, 9), to_signed(-185, 9), to_signed(-189, 9), to_signed(-193, 9), to_signed(-197, 9), to_signed(-201, 9), to_signed(-205, 9), to_signed(-208, 9), to_signed(-212, 9), to_signed(-215, 9), to_signed(-219, 9), to_signed(-222, 9), to_signed(-225, 9), to_signed(-228, 9), to_signed(-231, 9), to_signed(-233, 9), to_signed(-236, 9), to_signed(-238, 9), to_signed(-240, 9), to_signed(-242, 9), to_signed(-244, 9), to_signed(-246, 9), to_signed(-247, 9), to_signed(-249, 9), to_signed(-250, 9), to_signed(-251, 9), to_signed(-252, 9), to_signed(-253, 9), to_signed(-254, 9), to_signed(-254, 9), to_signed(-255, 9), to_signed(-255, 9)
                );
            when others =>
                out_cos := (others => "011111111");
        end case;
        return out_cos;
    end function init_cos;

    constant cosine_table : twiddle_table_type := init_cos;

    function init_sin return twiddle_table_type is
        variable out_sin : twiddle_table_type;
    begin
        case g_data_samples_exp is
            when 2 =>
                out_sin := (
                    to_signed(0, 9), to_signed(255, 9)
                );
            when 3 =>
                out_sin := (
                    to_signed(0, 9), to_signed(180, 9), to_signed(255, 9), to_signed(180, 9)
                );
            when 4 =>
                out_sin := (
                    to_signed(0, 9), to_signed(98, 9), to_signed(180, 9), to_signed(236, 9), to_signed(255, 9), to_signed(236, 9), to_signed(180, 9), to_signed(98, 9)
                );
            when 5 =>
                out_sin := (
                    to_signed(0, 9), to_signed(50, 9), to_signed(98, 9), to_signed(142, 9), to_signed(180, 9), to_signed(212, 9), to_signed(236, 9), to_signed(250, 9), to_signed(255, 9), to_signed(250, 9), to_signed(236, 9), to_signed(212, 9), to_signed(180, 9), to_signed(142, 9), to_signed(98, 9), to_signed(50, 9)
                );
            when 6 =>
                out_sin := (
                    to_signed(0, 9), to_signed(25, 9), to_signed(50, 9), to_signed(74, 9), to_signed(98, 9), to_signed(120, 9), to_signed(142, 9), to_signed(162, 9), to_signed(180, 9), to_signed(197, 9), to_signed(212, 9), to_signed(225, 9), to_signed(236, 9), to_signed(244, 9), to_signed(250, 9), to_signed(254, 9), to_signed(255, 9), to_signed(254, 9), to_signed(250, 9), to_signed(244, 9), to_signed(236, 9), to_signed(225, 9), to_signed(212, 9), to_signed(197, 9), to_signed(180, 9), to_signed(162, 9), to_signed(142, 9), to_signed(120, 9), to_signed(98, 9), to_signed(74, 9), to_signed(50, 9), to_signed(25, 9)
                );
            when 7 =>
                out_sin := (
                    to_signed(0, 9), to_signed(13, 9), to_signed(25, 9), to_signed(37, 9), to_signed(50, 9), to_signed(62, 9), to_signed(74, 9), to_signed(86, 9), to_signed(98, 9), to_signed(109, 9), to_signed(120, 9), to_signed(131, 9), to_signed(142, 9), to_signed(152, 9), to_signed(162, 9), to_signed(171, 9), to_signed(180, 9), to_signed(189, 9), to_signed(197, 9), to_signed(205, 9), to_signed(212, 9), to_signed(219, 9), to_signed(225, 9), to_signed(231, 9), to_signed(236, 9), to_signed(240, 9), to_signed(244, 9), to_signed(247, 9), to_signed(250, 9), to_signed(252, 9), to_signed(254, 9), to_signed(255, 9), to_signed(255, 9), to_signed(255, 9), to_signed(254, 9), to_signed(252, 9), to_signed(250, 9), to_signed(247, 9), to_signed(244, 9), to_signed(240, 9), to_signed(236, 9), to_signed(231, 9), to_signed(225, 9), to_signed(219, 9), to_signed(212, 9), to_signed(205, 9), to_signed(197, 9), to_signed(189, 9), to_signed(180, 9), to_signed(171, 9), to_signed(162, 9), to_signed(152, 9), to_signed(142, 9), to_signed(131, 9), to_signed(120, 9), to_signed(109, 9), to_signed(98, 9), to_signed(86, 9), to_signed(74, 9), to_signed(62, 9), to_signed(50, 9), to_signed(37, 9), to_signed(25, 9), to_signed(13, 9)
                );
            when 8 =>
                out_sin := (
                    to_signed(0, 9), to_signed(6, 9), to_signed(13, 9), to_signed(19, 9), to_signed(25, 9), to_signed(31, 9), to_signed(37, 9), to_signed(44, 9), to_signed(50, 9), to_signed(56, 9), to_signed(62, 9), to_signed(68, 9), to_signed(74, 9), to_signed(80, 9), to_signed(86, 9), to_signed(92, 9), to_signed(98, 9), to_signed(103, 9), to_signed(109, 9), to_signed(115, 9), to_signed(120, 9), to_signed(126, 9), to_signed(131, 9), to_signed(136, 9), to_signed(142, 9), to_signed(147, 9), to_signed(152, 9), to_signed(157, 9), to_signed(162, 9), to_signed(167, 9), to_signed(171, 9), to_signed(176, 9), to_signed(180, 9), to_signed(185, 9), to_signed(189, 9), to_signed(193, 9), to_signed(197, 9), to_signed(201, 9), to_signed(205, 9), to_signed(208, 9), to_signed(212, 9), to_signed(215, 9), to_signed(219, 9), to_signed(222, 9), to_signed(225, 9), to_signed(228, 9), to_signed(231, 9), to_signed(233, 9), to_signed(236, 9), to_signed(238, 9), to_signed(240, 9), to_signed(242, 9), to_signed(244, 9), to_signed(246, 9), to_signed(247, 9), to_signed(249, 9), to_signed(250, 9), to_signed(251, 9), to_signed(252, 9), to_signed(253, 9), to_signed(254, 9), to_signed(254, 9), to_signed(255, 9), to_signed(255, 9), to_signed(255, 9), to_signed(255, 9), to_signed(255, 9), to_signed(254, 9), to_signed(254, 9), to_signed(253, 9), to_signed(252, 9), to_signed(251, 9), to_signed(250, 9), to_signed(249, 9), to_signed(247, 9), to_signed(246, 9), to_signed(244, 9), to_signed(242, 9), to_signed(240, 9), to_signed(238, 9), to_signed(236, 9), to_signed(233, 9), to_signed(231, 9), to_signed(228, 9), to_signed(225, 9), to_signed(222, 9), to_signed(219, 9), to_signed(215, 9), to_signed(212, 9), to_signed(208, 9), to_signed(205, 9), to_signed(201, 9), to_signed(197, 9), to_signed(193, 9), to_signed(189, 9), to_signed(185, 9), to_signed(180, 9), to_signed(176, 9), to_signed(171, 9), to_signed(167, 9), to_signed(162, 9), to_signed(157, 9), to_signed(152, 9), to_signed(147, 9), to_signed(142, 9), to_signed(136, 9), to_signed(131, 9), to_signed(126, 9), to_signed(120, 9), to_signed(115, 9), to_signed(109, 9), to_signed(103, 9), to_signed(98, 9), to_signed(92, 9), to_signed(86, 9), to_signed(80, 9), to_signed(74, 9), to_signed(68, 9), to_signed(62, 9), to_signed(56, 9), to_signed(50, 9), to_signed(44, 9), to_signed(37, 9), to_signed(31, 9), to_signed(25, 9), to_signed(19, 9), to_signed(13, 9), to_signed(6, 9)
                );
            when others =>
                out_sin := (others => "000000000");
        end case;
        return out_sin;
    end function init_sin;

    constant sine_table : twiddle_table_type := init_sin;
begin
    cos_twid <= std_logic_vector(cosine_table(to_integer(unsigned(twiddle_index))));
    sin_twid <= std_logic_vector(sine_table(to_integer(unsigned(twiddle_index))));
   -- architecture body
end architecture_Twiddle_table;
