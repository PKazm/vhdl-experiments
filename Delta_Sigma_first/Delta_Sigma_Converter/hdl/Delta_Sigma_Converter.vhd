--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Delta_Sigma_Converter.vhd
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

entity Delta_Sigma_Converter is
generic (
    g_sample_div : natural := 256;
    --g_sample_div_pow2 : natural := 10;
    g_data_bits : natural := 8
);
port (
    PCLK : in std_logic;      -- 100Mhz
    CLK_OSample : in std_logic;       -- 20Mhz (limited for testing by labnation smartscope)
	--CLK_output : in std_logic;      -- 1Mhhz
	RSTn : in std_logic;

    Analog_in : in std_logic;
    
    ADC_feedback : out std_logic;
    --ADC_out_not : out std_logic;

    --data_out : out std_logic_vector (g_data_bits - 1 downto 0);

	--Board_Buttons : in std_logic_vector(1 downto 0);

    -- APB connections
    PADDR : in std_logic_vector(7 downto 0);
	PSEL : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(7 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(7 downto 0);
	PSLVERR : out std_logic;

	INT : out std_logic
    -- APB connections

);
end Delta_Sigma_Converter;
architecture architecture_Delta_Sigma_Converter of Delta_Sigma_Converter is
    -- signal, component etc. declarations

    signal CLK_OSample_last : std_logic := '0';

    signal internal_data : std_logic_vector(g_data_bits - 1 downto 0) := (others => '0');
    signal avg_out_sig : std_logic_vector(g_data_bits - 1 downto 0) := (others => '0');
    signal data_out_sig : std_logic_vector(g_data_bits - 1 downto 0) := (others => '0');

    signal analog_FF : std_logic := '0';

    signal pixel_sig : std_logic_vector(31 downto 0) := (others => '0');

    -- BEGIN PWM quantizer signals
    signal pwm_quantized_value : unsigned(g_data_bits - 1 downto 0) := (others => '0');
    signal pwm_quantized_counter : unsigned(g_data_bits - 1 downto 0) := (others => '0');
    signal pwm_counter : natural range 0 to g_sample_div - 1 := 0;
    signal pwm_interrupt : std_logic := '0';
    signal pwm_interrupt_last : std_logic := '0';
    -- END PWM quantizer signals

    signal pixels_ready : std_logic := '0';

    -- BEGIN APB signals
    signal prdata_sig : std_logic_vector(7 downto 0) := (others => '0');
    -- END APB signals

    -- BEGIN DSC Resgister signals
    constant DSC_ctrl_reg_ADDR : std_logic_vector(7 downto 0) := X"00";
    constant DSC_data0_pixels_ADDR : std_logic_vector(7 downto 0) := X"10";
    constant DSC_data1_pixels_ADDR : std_logic_vector(7 downto 0) := X"11";
    constant DSC_data2_pixels_ADDR : std_logic_vector(7 downto 0) := X"12";
    constant DSC_data3_pixels_ADDR : std_logic_vector(7 downto 0) := X"13";

    signal DSC_ctrl_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data0_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data1_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data2_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal DSC_data3_pixels_reg : std_logic_vector(7 downto 0) := (others => '0');
    -- END DSC Resgister signals

begin
    --=========================================================================
    -- BEGIN APB Register Read logic
    APB_Reg_Read_process: process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            prdata_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PWRITE = '0' and PSEL = '1') then
                case PADDR is
                    when DSC_ctrl_reg_ADDR =>
                        prdata_sig <= DSC_ctrl_reg;
                    when DSC_data0_pixels_ADDR =>
                        prdata_sig <= DSC_data0_pixels_reg;
                    when DSC_data1_pixels_ADDR =>
                        prdata_sig <= DSC_data1_pixels_reg;
                    when DSC_data2_pixels_ADDR =>
                        prdata_sig <= DSC_data2_pixels_reg;
                    when DSC_data3_pixels_ADDR =>
                        prdata_sig <= DSC_data3_pixels_reg;
                    when others =>
                        prdata_sig <= (others => '0');
                end case;
            else
                prdata_sig <= (others => '0');
            end if;
        end if;
    end process;

    -- BEGIN APB Return wires
    PRDATA <= prdata_sig;
    PREADY <= '1'; --pready_sig;
    PSLVERR <= '0';
    -- END APB Return wires

    -- END APB Register Read logic
    --=========================================================================
    -- BEGIN Register Write logic

    p_DSC_reg_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            DSC_ctrl_reg <= "00000000";
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = DSC_ctrl_reg_ADDR) then
                -- 0bXXXXXXX & enable
                DSC_ctrl_reg <= PWDATA;
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    process(PCLK)
    begin
        if(rising_edge(PCLK)) then
            CLK_OSample_last <= CLK_OSample;
        end if;
    end process;


    p_lets_make_a_FF : process(CLK_OSample, RSTn)
    begin
		if(RSTn = '0') then
			analog_FF <= '0';
        elsif(rising_edge(CLK_OSample)) then
            analog_FF <= Analog_in;
        end if;
    end process;

    p_pwm_quantizer : process(CLK_OSample, RSTn)
        variable comparison_var : unsigned(g_data_bits - 1 downto 0) := (others => '1');
    begin
		if(RSTn = '0') then
			pwm_counter <= 0;
			pwm_interrupt <= '0';
			pwm_interrupt_last <= '0';
			pwm_quantized_counter <= (pwm_quantized_counter'high => '0', others => '1');
			pwm_quantized_value <= (others => '0');
        elsif(rising_edge(CLK_OSample)) then
            pwm_interrupt_last <= pwm_interrupt;
            if(analog_FF = '1') then
                if(pwm_quantized_counter /= comparison_var) then
                    pwm_quantized_counter <= pwm_quantized_counter + 1;
                end if;
            else
                if(pwm_quantized_counter /= 0) then
                    pwm_quantized_counter <= pwm_quantized_counter - 1;
                end if;
            end if;

            if(pwm_counter = g_sample_div - 1) then
                pwm_counter <= 0;
                pwm_interrupt <= '1';
                pwm_quantized_value <= pwm_quantized_counter;
            elsif(pwm_counter = 1) then
                pwm_counter <= pwm_counter + 1;
                pwm_interrupt <= '0';
            else
                pwm_counter <= pwm_counter + 1;
                pwm_interrupt <= '0';
            end if;

            --pwm_interrupt_last <= pwm_interrupt;
            --if(pwm_counter = g_sample_div - 1) then
            --    pwm_counter <= 0;
            --    pwm_interrupt <= '1';
            --    pwm_quantized_value <= pwm_quantized_counter;
            --    pwm_quantized_counter <= (pwm_quantized_counter'high => '0', others => '1');
            --else
            --    pwm_counter <= pwm_counter + 1;
            --    pwm_interrupt <= '0';
            --    if(analog_FF = '1') then
            --        pwm_quantized_counter <= pwm_quantized_counter + 1;
            --    else
            --        pwm_quantized_counter <= pwm_quantized_counter - 1;
            --    end if;
            --end if;
        end if;
    end process;

    p_pwm_to_pixel_bar : process(CLK_OSample, RSTn)
    begin
		if(RSTn = '0') then
			pixel_sig <= (others => '0');
        elsif(rising_edge(CLK_OSample)) then
            if(pwm_interrupt_last = '0' and pwm_interrupt = '1') then
                for I in 0 to 31 loop
                    if(to_integer(unsigned(pwm_quantized_value)) > (I * ((2 ** g_data_bits) / 32)) + 1) then
                        pixel_sig(i) <= '1';
                    else
                        pixel_sig(I) <= '0';
                    end if;
                end loop;
            end if;
        end if;
    end process;
    
    p_pixel_bar_to_registers : process(CLK_OSample, RSTn)
    begin
		if(RSTn = '0') then
			DSC_data0_pixels_reg <= (others => '0');
			DSC_data1_pixels_reg <= (others => '0');
			DSC_data2_pixels_reg <= (others => '0');
			DSC_data3_pixels_reg <= (others => '0');
        elsif(rising_edge(CLK_OSample)) then
            if(pwm_interrupt_last = '0' and pwm_interrupt = '1') then
                if(DSC_ctrl_reg(0) = '1') then
                    pixels_ready <= '1';
                end if;
                for i in 0 to 7 loop
                    DSC_data0_pixels_reg(i) <= pixel_sig(31 - i);       -- Y = 1
                end loop;
                for i in 0 to 7 loop
                    DSC_data1_pixels_reg(i) <= pixel_sig(23 - i);       -- Y = 2
                end loop;
                for i in 0 to 7 loop
                    DSC_data2_pixels_reg(i) <= pixel_sig(15 - i);       -- Y = 3
                end loop;
                for i in 0 to 7 loop
                    DSC_data3_pixels_reg(i) <= pixel_sig(7 - i);       -- Y = 4
                end loop;
            elsif(pwm_interrupt_last = '1' and pwm_interrupt = '0') then
                pixels_ready <= '0';
            end if;
		end if;
    end process;


    ADC_feedback <= analog_FF;
    INT <= pixels_ready;     -- DSC_ctrl_reg(0) check should be sprinkled elsewhere

   -- architecture body
end architecture_Delta_Sigma_Converter;
