--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Sample_Outputer.vhd
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

use work.FFT_package.all;

entity FFT_Sample_Outputer is
generic (
    --g_data_width : natural := 8;
    --g_samples_exp : natural := 5
    g_sync_input : natural := 0;
    g_buffer_output : natural := 0
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    -- connections to sample generator
    output_en : in std_logic;
    output_adr : in std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    output_real : out std_logic_vector(SAMPLE_WIDTH_INT - 1 downto 0);
    output_imag : out std_logic_vector(SAMPLE_WIDTH_INT - 1 downto 0);
    output_ready : out std_logic;
    output_valid : out std_logic;
    -- connections to sample generator


    -- connections to FFT RAM block
    ram_stable : in std_logic;
    ram_ready : in std_logic;

    ram_valid : out std_logic;

    ram_w_en : out w_en_array_type;
    ram_adr : out adr_array_type;
    ram_dat_w : out ram_dat_array_type;
    ram_dat_r : in ram_dat_array_type
    -- connections to FFT RAM block
);
end FFT_Sample_Outputer;
architecture architecture_FFT_Sample_Outputer of FFT_Sample_Outputer is

    type adr_sync_type is array(1 downto 0) of std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);

    signal output_en_sync : std_logic_vector(1 downto 0);
    signal output_adr_sync : adr_sync_type;

    signal output_en_sig : std_logic;
    signal output_en_last : std_logic;
    signal output_adr_sig : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);

    signal output_valid_sig : std_logic;
    signal output_ready_sig : std_logic;

    signal ram_stable_sig : std_logic;
    signal ram_ready_sig : std_logic;
    signal ram_valid_sig : std_logic;
    signal ram_w_en_sig : w_en_array_type;
    signal ram_r_en : r_en_array_type;
    signal ram_adr_sig : adr_array_type;
    signal ram_dat_w_sig : ram_dat_array_type;
    signal ram_dat_r_sig : ram_dat_array_type;
begin

    ram_stable_sig <= ram_stable;
    ram_ready_sig <= ram_ready;

    ram_valid <= ram_valid_sig;

    ram_w_en <= ram_w_en_sig;
    ram_adr <= ram_adr_sig;
    ram_dat_w <= ram_dat_w_sig;

    ram_dat_r_sig <= ram_dat_r;

    
    ram_valid_sig <= '1';
    ram_w_en_sig <= (others => '0');
    ram_adr_sig(1) <= (others => '0');
    ram_dat_w_sig <= (others => (others => '0'));

    --=========================================================================
    
    gen_input_no_sync : if(g_sync_input = 0) generate
        p_input_sync : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                output_en_last <= '0';
            elsif(rising_edge(PCLK)) then
                output_en_last <= output_en_sig;
            end if;
        end process;

        output_en_sig <= output_en;
        output_adr_sig <= output_adr;
    end generate gen_input_no_sync;

    gen_input_yes_sync : if(g_sync_input /= 0) generate
        p_input_sync : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                output_en_sync <= (others => '0');
                output_adr_sync <= (others => (others => '0'));
                output_en_last <= '0';
            elsif(rising_edge(PCLK)) then
                output_en_sync(0) <= output_en;
                output_adr_sync(0) <= output_adr;
                output_en_sync(1) <= output_en_sync(0);
                output_adr_sync(1) <= output_adr_sync(0);

                output_en_last <= output_en_sig;
            end if;
        end process;

        output_en_sig <= output_en_sync(1);
        output_adr_sig <= output_adr_sync(1);
    end generate gen_input_yes_sync;

    --=========================================================================

    gen_out_no_buffer : if(g_buffer_output = 0) generate
        output_real <= ram_dat_r_sig(0)(8 downto 0) when output_en_sig = '1' else (others => '0');
        output_imag <= ram_dat_r_sig(0)(17 downto 9) when output_en_sig = '1' else (others => '0');

        -- possible race condition if external perif is fast enough. sub nanosecond?
        output_valid_sig <= output_en_sig;
    end generate gen_out_no_buffer;

    gen_out_yes_buffer : if(g_buffer_output /= 0) generate
		p_output_buffer : process(PCLK, RSTn)
		begin
			if(RSTn = '0') then
				output_real <= (others => '0');
                output_imag <= (others => '0');
                output_valid_sig <= '0';
            elsif(rising_edge(PCLK)) then
                if(output_ready_sig = '1') then
                    if(output_en_last = '0' and output_en_sig = '1') then
                        output_real <= ram_dat_r_sig(0)(8 downto 0);
                        output_imag <= ram_dat_r_sig(0)(17 downto 9);
                        output_valid_sig <= '1';
                    elsif(output_en_last = '1' and output_en_sig = '0') then
                        output_valid_sig <= '0';
                    end if;
                else
                    output_real <= (others => '0');
                    output_imag <= (others => '0');
                    output_valid_sig <= '0';
                end if;
			end if;
		end process;
    end generate gen_out_yes_buffer;

    ram_adr_sig(0) <= output_adr_sig;
    output_ready_sig <= ram_stable_sig and ram_ready_sig;

    
    output_ready <= output_ready_sig;
    output_valid <= output_valid_sig;

   -- architecture body
end architecture_FFT_Sample_Outputer;
