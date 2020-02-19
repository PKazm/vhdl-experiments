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

    -- ports related to writing samples into the FFT
    in_data : in std_logic_vector(g_data_width - 1 downto 0);
    in_data_wren : in std_logic;        -- risinge edge: write data into current mem_loc, falling_edge: increment mem_adr
    in_data_ready : out std_logic;      -- FFT memory is ready for sample data
    in_data_full : out std_logic;       -- FFT memory is full and is now overwriting older samples
    -- ports related to writing samples into the FFT

    -- ports related to reading results of FFT
    out_data_adr : in std_logic_vector(g_samples_exp - 1 downto 0);     -- asynchronous memory address
    out_read_complete : in std_logic;
    out_data : out std_logic_vector(g_data_width - 1 downto 0);
    out_data_ready : out std_logic      -- indicates when output data is valid
    -- ports related to reading results of FFT
);
end FFT;
architecture architecture_FFT of FFT is
    constant SAMPLE_CNT : natural := (2**g_samples_exp);
    constant PORT_CNT : natural := 2;
    -- sample memory uses an alternating 3 block design.
    -- A block will have the FFT process performed on it.
    -- B block will hold the most recent set of transformed data to be read
    -- C block will act as a circular memory block such that it will always have the most recent set of data.
    -- when an FFT transform is complete:
    -- A block will be set as the output and held static (i.e. read only mode)
    -- B block will be set as the circular memory block
    -- C block will have the FFT transform performed on its data
    -- etc.
    type time_sample_mem is array (g_samples_exp - 1 downto 0) of std_logic_vector(g_data_width - 1 downto 0);
    type ram_block_mem is array (2 downto 0) of time_sample_mem;
    signal SAMPLE_RAMS : ram_block_mem;

    -- memory access signals
    type wren_array_type is array(PORT_CNT - 1 downto 0) of std_logic;
    type adr_array_type is array(PORT_CNT - 1 downto 0) of std_logic_vector(g_samples_exp - 1 downto 0);
    type ram_dat_array_type is array(PORT_CNT - 1 downto 0) of std_logic_vector(g_data_width * 2 - 1 downto 0);

    type sample_wren_type is array(2 downto 0) of wren_array_type;
    type sample_adr_type is array(2 downto 0) of adr_array_type;
    type sample_dat_type is array(2 downto 0) of ram_dat_array_type;

    signal ram_wren : sample_wren_type;
    signal ram_adr : sample_adr_type;
    signal ram_dat_i : sample_dat_type;
    signal ram_dat_o : sample_dat_type;
    -- memory access signals

    -- input memory signals
    -- these get assigned to memory access signals depending on the mem block state of the FFT
    signal in_wren : wren_array_type;
    signal in_adr : adr_array_type;
    signal in_dat_i : ram_dat_array_type;
    signal in_dat_o : ram_dat_array_type;

    signal in_r_en : std_logic;
    signal in_data_real : std_logic_vector(g_data_width - 1 downto 0);
    signal in_data_imag : std_logic_vector(g_data_width - 1 downto 0);
    signal in_data_wren_last : std_logic;
    signal in_data_ready_sig : std_logic;
    signal in_data_full_sig : std_logic;
    signal in_mem_adr : unsigned(g_samples_exp - 1 downto 0);
    signal in_mem_adr_bitrev : unsigned(g_samples_exp - 1 downto 0);
    -- input memory signals

    -- output memory signals
    -- these get assigned to memory access signals depending on the mem block state of the FFT
    signal out_wren : wren_array_type;
    signal out_adr : adr_array_type;
    signal out_dat_i : ram_dat_array_type;
    signal out_dat_o : ram_dat_array_type;

    signal out_r_en : std_logic;
    signal out_data_real : std_logic_vector(g_data_width - 1 downto 0);
    signal out_data_imag : std_logic_vector(g_data_width - 1 downto 0);
    -- output memory signals

    -- fft memory signals
    -- these get assigned to memory access signals depending on the mem block state of the FFT
    signal fft_wren : wren_array_type;
    signal fft_adr : adr_array_type;
    signal fft_dat_i : ram_dat_array_type;
    signal fft_dat_o : ram_dat_array_type;

    signal fft_r_en : std_logic;
    signal fft_trans_complete : std_logic;
    signal fft_data_real : std_logic_vector(g_data_width - 1 downto 0);
    signal fft_data_imag : std_logic_vector(g_data_width - 1 downto 0);
    -- fft memory signals

    -- memory state control signals
    -- fft_a : memB = input, memA = process, memC = output
    -- fft_b : memC = input, memB = process, memA = output
    -- fft_c : memA = input, memC = process, memB = output
    type mem_block_states is(fft_a, fft_b, fft_c);
    signal mem_block_state : mem_block_states;
    -- memory state control signals

    signal sample_full : natural range 0 to SAMPLE_CNT - 1 := 0;
    signal data_in_full_sig : std_logic;
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
    signal sin_twid_1comp : signed(8 downto 0);
    -- Twiddle Table signals

    component Twiddle_Table
    generic (
        g_data_samples_exp : natural
    );
    port (
        -- twiddle count is half of sample count
        twiddle_index : in std_logic_vector(g_data_samples_exp - 2 downto 0);
    
        cos_twid : out std_logic_vector(8 downto 0);
        cos_twid_1comp : out std_logic_vector(8 downto 0);
        sin_twid : out std_logic_vector(8 downto 0);
        sin_twid_1comp : out std_logic_vector(8 downto 0)
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
            cos_twid_1comp => open,
            sin_twid => sin_twid,
            sin_twid => sin_twid_1comp
        );

    
    --=========================================================================
    p_mem_block_control : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            mem_block_state <= fft_a;
        elsif(rising_edge(PCLK)) then
            -- conditions for state progression
            -- all data is read out from transform: out_read_complete = 1
            -- transform is complete: fft_trans_complete = 1
            -- next data set if full and ready to be transformed: in_data_full_sig = 1
            if(out_read_complete = 1 and fft_trans_complete = 1 and in_data_full_sig = 1) then
                case mem_block_state is
                    when fft_a =>
                        mem_block_state <= fft_b;
                    when fft_b =>
                        mem_block_state <= fft_c;
                    when fft_c =>
                        mem_block_state <= fft_a;
                    when others =>
                        mem_block_state <= fft_a;
                end case;
            end if;
        end if;
    end process;

    process()
    begin
        case mem_block_state is
            when fft_a =>
                -- fft_a : memB = input, memA = process, memC = output
                ram_wren(0) <= fft_wren;
                ram_adr(0) <= fft_adr;
                ram_dat_i(0) <= fft_dat_i;
                fft_dat_o <= ram_dat_o(0);

                ram_wren(1) <= in_wren;
                ram_adr(1) <= in_adr;
                ram_dat_i(1) <= in_dat_i;
                in_dat_o <= ram_dat_o(1);

                ram_wren(2) <= out_wren;
                ram_adr(2) <= out_adr;
                ram_dat_i(2) <= out_dat_i;
                out_dat_o <= ram_dat_o(2);
            when fft_b =>
                -- fft_b : memC = input, memB = process, memA = output
                ram_wren(0) <= out_wren;
                ram_adr(0) <= out_adr;
                ram_dat_i(0) <= out_dat_i;
                out_dat_o <= ram_dat_o(0);

                ram_wren(1) <= fft_wren;
                ram_adr(1) <= fft_adr;
                ram_dat_i(1) <= fft_dat_i;
                fft_dat_o <= ram_dat_o(1);

                ram_wren(2) <= in_wren;
                ram_adr(2) <= in_adr;
                ram_dat_i(2) <= in_dat_i;
                in_dat_o <= ram_dat_o(2);
            when fft_c =>
                -- fft_c : memA = input, memC = process, memB = output
                ram_wren(0) <= in_wren;
                ram_adr(0) <= in_adr;
                ram_dat_i(0) <= in_dat_i;
                in_dat_o <= ram_dat_o(0);

                ram_wren(1) <= out_wren;
                ram_adr(1) <= out_adr;
                ram_dat_i(1) <= out_dat_i;
                out_dat_o <= ram_dat_o(1);

                ram_wren(2) <= fft_wren;
                ram_adr(2) <= fft_adr;
                ram_dat_i(2) <= fft_dat_i;
                fft_dat_o <= ram_dat_o(2);
            when others =>
                null;
        end case;
    end process;

    --=========================================================================

    -- load_sample process will be reset on RSTn = '0' and when mem_block_state changes
    -- in_mem_adr will increment and overflow to create a circular memory block
    -- when in_mem_adr = SAMPLE_CNT - 1 for the first time, data_in_full_sig will be set to 1
    -- when mem_block_state changes, the last in_mem_adr will be stored for reference by other processes
    --      and data_in_full_sig will be set to 0

    p_load_sample : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            data_in_wren_last <= '0';
            in_mem_adr <= 0;
            in_data_ready_sig <= '1';      -- default to empty RAM, we want to load data
            data_in_full_sig <= '0';
        elsif(rising_edge(PCLK)) then
            data_in_wren_last <= data_in_wren;
            if((data_in_wren_last = '0') and (data_in_wren = '1')) then
                -- write in_data to ram
                in_wren <= '1';
            elsif((data_in_wren_last = '1') and (data_in_wren = '0')) then
                -- increment in_mem_adr
                if(in_mem_adr /= SAMPLE_CNT - 1) then
                    in_mem_adr <= in_mem_adr + 1;
                else
                    data_in_full_sig <= '1';
                end if;
                in_wren <= '0';
            else
                -- in memory is idle
                in_wren <= '0';
            end if;
        end if;
    end process;

    gen_in_mem_adr_bitrev : for k in 1 to g_samples_exp generate
        in_mem_adr_bitrev(g_samples_exp - k) <= g_samples_exp(k - 1);
    end generate gen_in_mem_adr_bitrev;


    in_adr_0 <= in_mem_adr;--in_mem_adr_bitrev;
    in_dat_i_0 <= in_data;

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
    

    --=========================================================================

    p_freq_synthesis : process(PCLK, RSTn)
    begin

    end process;


    
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
