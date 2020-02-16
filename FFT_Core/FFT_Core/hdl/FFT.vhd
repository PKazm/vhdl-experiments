--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT.vhd
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

entity FFT is
generic (
    g_data_width : natural := 8;
    g_samples_exp : natural := 5
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    data_in : in std_logic_vector(g_data_width - 1 downto 0);
    data_in_ready : in std_logic;
    send_data_in : out std_logic;
    data_decomp_out : out std_logic_vector(g_data_width - 1 downto 0);
    data_out_ready : out std_logic
    --imaginary
);
end FFT;
architecture architecture_FFT of FFT is
    constant SAMPLE_CNT : natural := (2**g_samples_exp);
    type time_sample_mem is array (SAMPLE_CNT - 1 downto 0) of std_logic_vector(g_data_width - 1 downto 0);
    signal time_samples : time_sample_mem;
    signal time_samples_decomp : time_sample_mem;

    signal sample_full : natural range 0 to SAMPLE_CNT - 1 := 0;
    signal data_valid : std_logic;

    type freq_domain_mem is array (SAMPLE_CNT / 2 downto 0) of std_logic_vector(g_data_width - 1 downto 0);
    signal rex_samples : freq_domain_mem;
    signal imx_samples : freq_domain_mem;

    signal data_in_ready_last : std_logic;
    signal data_out_ready_sig : std_logic;

    -- FFT control signals
    constant STAGE_CNT_MAX : natural := g_samples_exp - 1;
    signal stage_cnt : natural range 0 to STAGE_CNT_MAX := 0;
    
    -- how BF get used is determined by g_samples_exp, but its always 4 total
    constant BF_CNT_MAX : natural := 3;
    signal butterfly_cnt : natural range 0 to BF_CNT_MAX := 0;
    -- FFT control signals

    -- Twiddle Table signals
    signal twiddle_index : std_logic_vector(g_samples_exp - 2 downto 0);
    signal cos_twid : signed(8 downto 0);
    signal sin_twid : signed(8 downto 0);
    -- Twiddle Table signals

    component Twiddle_Table
    generic (
        g_data_samples_exp : natural
    );
    port (
        -- twiddle count is half of sample count
        twiddle_index : in std_logic_vector(g_data_samples_exp - 2 downto 0);
    
        cos_twid : out std_logic_vector(8 downto 0);
        sin_twid : out std_logic_vector(8 downto 0)
    );
    end component;

begin

    Twiddle_Table_0 : Twiddle_Table
        generic map(
            g_data_samples_exp => g_samples_exp
        )
        port map(
            -- twiddle count is half of sample count
            twiddle_index => twiddle_index,
        
            cos_twid => cos_twid,
            sin_twid => sin_twid
        );

    --=========================================================================

    p_load_sample : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            data_in_ready_last <= '0';
            data_valid <= '0';
            sample_full <= 0;
            data_valid <= '0';
            send_data_in <= '1';      -- default to empty RAM, we want to load data
        elsif(rising_edge(PCLK)) then
            data_in_ready_last <= data_in_ready;
            if((data_in_ready_last = '0') and (data_in_ready = '1')) then
                if(sample_full /= SAMPLE_CNT - 1) then
                    sample_full <= sample_full + 1;
                else
                    data_valid <= '1';
                end if;

                for i in 1 to (SAMPLE_CNT - 1) loop
                    time_samples(i) <= time_samples(i - 1);
                end loop;
                time_samples(0) <= data_in;
                data_out_ready_sig <= '0';
            else
                data_out_ready_sig <= '1';
            end if;
        end if;
    end process;

    --=========================================================================

    p_decomposed_samples : process(time_samples)
        variable tmp_index : std_logic_vector(g_samples_exp - 1 downto 0);
        variable rev_index : std_logic_vector(g_samples_exp - 1 downto 0);
    begin
        -- this loop performs a bit reversal data sort
        for i in 0 to (SAMPLE_CNT - 1) loop
            tmp_index := std_logic_vector(to_unsigned(i, g_samples_exp));
            -- This loop reverses the bit order of the index
            for k in 1 to g_samples_exp loop
                rev_index(g_samples_exp - k) := tmp_index(k - 1);
            end loop;
            time_samples_decomp(to_integer(unsigned(rev_index))) <= time_samples(i);
        end loop;
    end process;

    data_decomp_out <= time_samples_decomp(SAMPLE_CNT - 1);

    data_out_ready <= data_out_ready_sig and data_valid;

    --=========================================================================

    p_freq_synthesis : process(PCLK, RSTn)
    begin

    end process;

    --MACCout <= std_logic_vector((unsigned(dat1) * X"55") + (unsigned(dat2) * X"11"));
    --=========================================================================
    
    p_FFT_process : process(PCLK, RSTn)
    begin

        if(RSTn = '0') then
            stage_cnt = 0;
            butterfly_cnt = 0;
        elsif(rising_edge(PCLK)) then
            for I in 0 to 3 loop

            end loop;
        end if;
    end process;

   -- architecture body
end architecture_FFT;
