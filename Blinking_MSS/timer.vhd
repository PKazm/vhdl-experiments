library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is
generic(
    g_timer_count : natural := 500
);
port(
    CLK : in std_logic;

    timer_out : out std_logic
);
end timer;
architecture architecture_timer of timer is
    signal counter : natural range 0 to g_timer_count := 0;
    signal timer_sig : std_logic := '0';
begin
    process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(counter = g_timer_count - 1) then
                counter <= 0;
                timer_sig <= not timer_sig;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    timer_out <= timer_sig;
end architecture_timer;