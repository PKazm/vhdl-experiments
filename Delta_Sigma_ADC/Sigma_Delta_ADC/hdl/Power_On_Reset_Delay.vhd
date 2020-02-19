--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Power_On_Reset_Delay.vhd
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

entity Power_On_Reset_Delay is
generic (
    g_clk_cnt : natural := 16384   -- 14 bits gives .163ms at 100Mhz. About 60ms measured power on I/O buffer
);
port (
    CLK : in std_logic;
    POWER_ON_RESET_N : in std_logic;
    EXT_RESET_IN_N : in std_logic;
    FCCC_LOCK : in std_logic;
    USER_FAB_RESET_IN_N : in std_logic;

    USER_FAB_RESET_OUT_N : out std_logic
);
end Power_On_Reset_Delay;
architecture architecture_Power_On_Reset_Delay of Power_On_Reset_Delay is
   signal delay_counter : natural range 0 to g_clk_cnt - 1 := 0;
   signal POR : std_logic;
begin

    process(CLK, POWER_ON_RESET_N)
    begin

        if(POWER_ON_RESET_N = '0') then
            delay_counter <= 0;
            POR <= '0';
        elsif(rising_edge(CLK)) then
            if(delay_counter = g_clk_cnt - 1) then
                POR <= '1';
            else
                delay_counter <= delay_counter + 1;
            end if;
        end if;
    end process;

    USER_FAB_RESET_OUT_N <= POR and
                            EXT_RESET_IN_N and
                            FCCC_LOCK and
                            USER_FAB_RESET_IN_N;

   -- architecture body
end architecture_Power_On_Reset_Delay;
