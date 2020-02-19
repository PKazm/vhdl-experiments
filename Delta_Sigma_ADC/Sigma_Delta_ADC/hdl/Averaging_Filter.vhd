--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Averaging_Filter.vhd
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

entity Averaging_Filter is
generic (
    --g_sample_window : natural := 2;
    g_sample_window_exp : natural := 1;
    g_data_bits : natural := 8;
    g_enable_data_out : natural := 1
);
port (
    PCLK : in std_logic;      -- 100Mhz
    RSTn : in std_logic;

    Data_in_ready : in std_logic;
    Data_in : in std_logic_vector(g_data_bits - 1 downto 0);
    Data_out : out std_logic_vector((g_data_bits - 1) * g_enable_data_out downto 0);
    Data_out_ready : out std_logic
    
);
end Averaging_Filter;
architecture architecture_Averaging_Filter of Averaging_Filter is
    type states is(idle, step1, step2, done);
    signal filter_state : states;

    constant SAMPLE_WINDOW : natural := 2 ** g_sample_window_exp;

    type mem_type is array (SAMPLE_WINDOW - 1 downto 0) of unsigned (g_data_bits - 1 downto 0);
    signal samples_mem : mem_type;

    signal data_in_ready_last : std_logic;
    signal Data_out_ready_sig : std_logic;
    
    signal running_sum : unsigned(g_data_bits + g_sample_window_exp - 1 downto 0);

    signal filtered_value : unsigned(g_data_bits - 1 downto 0);

begin

    process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            --data_in_ready_last <= '1';      -- just in case the data_in signal is high during reset and the data is garbage.
            data_in_ready_last <= '0';
        elsif(rising_edge(PCLK)) then
            data_in_ready_last <= Data_in_ready;
        end if;
    end process;

    process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            samples_mem <= (others => (others => '0'));
            Data_out_ready_sig <= '0';
            running_sum <= (others => '0');
            filtered_value <= (others => '0');

            filter_state <= idle;
        elsif(rising_edge(PCLK)) then
            if(data_in_ready_last = '0' and Data_in_ready = '1') then
                filter_state <= step1;
                Data_out_ready_sig <= '0';
                running_sum <= running_sum - samples_mem(samples_mem'high);
            end if;

            case filter_state is
                when idle =>
                    null;
                when step1 =>
                    filter_state <= step2;
                    running_sum <= running_sum + unsigned(Data_in);
                    samples_mem(0) <= unsigned(Data_in);
                    for i in 1 to samples_mem'length - 1 loop
                        samples_mem(i) <= samples_mem(i - 1);
                    end loop;
                when step2 =>
                    filter_state <= idle;
                    Data_out_ready_sig <= '1';
                    filtered_value <= running_sum(running_sum'high downto g_sample_window_exp);
                when others =>
                    filter_state <= idle;
            end case;
        end if;
    end process;

    Data_out <= std_logic_vector(filtered_value);
    Data_out_ready <= Data_out_ready_sig;

   -- architecture body
end architecture_Averaging_Filter;
