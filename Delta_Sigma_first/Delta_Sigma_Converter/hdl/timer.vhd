library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is
generic(
    g_timer_count : natural := 500;
    g_repeat : std_logic := '1'
);
port(
    CLK : in std_logic;
    PRESETN : in std_logic;

    timer_clock_out : out std_logic;
    timer_interrupt_pulse : out std_logic
);
end timer;
architecture architecture_timer of timer is
    signal counter : natural range 0 to g_timer_count - 1 := 0;
    signal timer_clock_out_sig : std_logic := '0';
    signal timer_indic_sig : std_logic := '0';
begin
    process(CLK, PRESETN)
    begin
        if(PRESETN = '0') then
            counter <= 0;
            timer_indic_sig <= '0';
        elsif(rising_edge(CLK)) then
            if(g_repeat = '0' and timer_indic_sig  = '1') then
                --timer_indic_sig <= '0';
                -- if repeat = FALSE, leave timer_indicator(timer_indic_sig) high to say "I did the thing"
            elsif(counter = g_timer_count - 1) then
                counter <= 0;
                timer_clock_out_sig <= '1';
                timer_indic_sig <= '1';
            elsif(counter = g_timer_count / 2) then
                counter <= counter + 1;
                timer_clock_out_sig <= '0';
            else
                counter <= counter + 1;
                timer_indic_sig <= '0';
            end if;
        end if;
    end process;

    timer_clock_out <= timer_clock_out_sig;
    timer_interrupt_pulse <= timer_indic_sig;
end architecture_timer;