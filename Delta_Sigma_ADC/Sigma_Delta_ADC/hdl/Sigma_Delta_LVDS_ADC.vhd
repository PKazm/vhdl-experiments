--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Sigma_Delta_LVDS_ADC.vhd
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

entity Sigma_Delta_LVDS_ADC is
generic (
    g_pclk_period : natural := 10;      -- default expects 10ns = 100Mhz
    --g_clks_per_transition : natural := 128;
    g_sample_div : natural := 100;      -- given 100Mhz, this gives 1Mhz as Oversample Freq. Recommend Over_Sample_freq < 50Mhz
    g_data_bits : natural := 8;
    g_invert_count : natural := 0       -- 0 = increment when analog_FF is 1, 1 = increment when analog_FF is 0
);
port (
    PCLK : in std_logic;      -- 100Mhz
    RSTn : in std_logic;

    LVDS_in : in std_logic;
    LVDS_PADN_feedback : out std_logic;

    Data_out : out std_logic_vector(g_data_bits - 1 downto 0);
    Data_Ready : out std_logic

);
end Sigma_Delta_LVDS_ADC;
architecture architecture_Sigma_Delta_LVDS_ADC of Sigma_Delta_LVDS_ADC is

    -- startup_delay_fin spends the first data sample holding analog_FF low to ensure RC low pass filter is at 0v
    signal startup_delay_fin : std_logic;

    signal sample_CLK : std_logic;
    signal sample_CLK_last : std_logic;
    constant SMPL_CNT_MAX : natural := (2 ** g_data_bits) - 1;
    signal sample_counter : natural range 0 to SMPL_CNT_MAX := 0;

    signal analog_FF : std_logic;

    signal pwm_quantized_value : unsigned(g_data_bits - 1 downto 0);
    signal pulse_accumulator : unsigned(g_data_bits - 1 downto 0);

    signal data_ready_sig : std_logic;

    component timer
        generic(
            g_timer_count : natural := 200;
            g_repeat : std_logic := '1'
        );
        port(
            CLK : in std_logic;
            PRESETN : in std_logic;

            timer_clock_out : out std_logic;
            timer_interrupt_pulse : out std_logic
        );
    end component;

begin

    Sample_CLK_timer : timer
    generic map (
        g_timer_count => g_sample_div,
        g_repeat => '1'
    )
    port map (
        CLK => PCLK,
        PRESETN => RSTn,

        timer_clock_out => sample_CLK,
        timer_interrupt_pulse => open
    );

    --=========================================================================

    p_lets_make_a_FF : process(sample_CLK, RSTn)
    begin
		if(RSTn = '0') then
			analog_FF <= '0';
        elsif(rising_edge(sample_CLK)) then
            if(startup_delay_fin = '0') then
                analog_FF <= '0';
            else
                analog_FF <= LVDS_in;
            end if;
        end if;
    end process;

    LVDS_PADN_feedback <= analog_FF;

    --=========================================================================

    p_the_quantization_stuff : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            sample_counter <= 0;
            pwm_quantized_value <= (others => '0');
            pulse_accumulator <= (others => '0');
            
            startup_delay_fin <= '0';
            data_ready_sig <= '0';
        elsif(rising_edge(PCLK)) then
            sample_CLK_last <= sample_CLK;

            if(sample_CLK_last = '0' and sample_CLK = '1') then
                if(sample_counter = SMPL_CNT_MAX) then
                    startup_delay_fin <= '1';
                    data_ready_sig <= '0';
                    sample_counter <= 0;
                    pwm_quantized_value <= pulse_accumulator;
                    pulse_accumulator <= (others => '0');
                else
                    if(startup_delay_fin = '1') then
                        data_ready_sig <= '1';
                    end if;
                    sample_counter <= sample_counter + 1;
                    if(analog_FF = '1' and g_invert_count = 0) then
                        -- increment accumulator
                        pulse_accumulator <= pulse_accumulator + 1;
                    elsif(analog_FF = '0' and g_invert_count /= 0) then
                        -- alternate comparator config results in inverted pulses
                        pulse_accumulator <= pulse_accumulator + 1;
                    else
                        -- no add
                    end if;
                end if;
            end if;
        end if;

    end process;

    Data_out <= std_logic_vector(pwm_quantized_value);
    Data_Ready <= data_ready_sig;

   -- architecture body
end architecture_Sigma_Delta_LVDS_ADC;
