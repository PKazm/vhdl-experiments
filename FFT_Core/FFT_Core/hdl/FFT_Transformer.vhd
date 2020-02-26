--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Transformer.vhd
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

entity FFT_Transformer isgeneric (
    --g_data_width : natural := 8;
    --g_samples_exp : natural := 5
    --g_sync_input : natural := 0
);
port (

    PCLK : in std_logic;
    RSTn : in std_logic;

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
end FFT_Transformer;
architecture architecture_FFT_Transformer of FFT_Transformer is

    type stage_states is(srst, runDFT, incr);

    signal stage_cnt : natural 0 to SAMPLE_CNT_EXP - 1 := 0;
    -- 2**(SAMPLE_CNT_EXP - 1) - 1 = N / 2
    signal dft_cnt : natural 0 to 2**(SAMPLE_CNT_EXP - 1) - 1 := 0;
    signal bfly_cnt : natural 0 to 2**(SAMPLE_CNT_EXP - 1) - 1 := 0;

    signal dft_max : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    signal dft_run : std_logic;
    signal dft_fin : std_logic;

    signal bfly_max : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    signal bfly_run : std_logic;

    signal sampleA_adr : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal sampleA_real : std_logic_vector(8 downto 0);
    signal sampleA_imag : std_logic_vector(8 downto 0);
    signal sampleB_adr : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal sampleB_real : std_logic_vector(8 downto 0);
    signal sampleB_imag : std_logic_vector(8 downto 0);


    -- external sample ram connections
    signal ram_stable_sig : std_logic;
    signal ram_ready_sig : std_logic;
    signal ram_valid_sig : std_logic;
    signal ram_w_en_sig : w_en_array_type;
    signal ram_r_en : r_en_array_type;
    signal ram_adr_sig : adr_array_type;
    signal ram_dat_w_sig : ram_dat_array_type;
    signal ram_dat_r_sig : ram_dat_array_type;
    -- external sample ram connections


    -- component twiddle table connections
    signal twiddle_index : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_ready : std_logic;
    signal cos_twid : std_logic_vector(8 downto 0);
    signal cos_twid_1comp : std_logic_vector(8 downto 0);
    signal sin_twid : std_logic_vector(8 downto 0);
    signal sin_twid_1comp : std_logic_vector(8 downto 0);
    -- component twiddle table connections

    -- component butterfly connections
    signal bf0_do_calc : std_logic;
    signal bf0_twiddle_cos_real : std_logic_vector(8 downto 0);
    signal bf0_twiddle_sin_imag : std_logic_vector(8 downto 0);
    signal bf0_twiddle_sin_imag_1comp : std_logic_vector(8 downto 0);
    signal bf0_real_a_in : std_logic_vector(8 downto 0);
    signal bf0_imag_a_in : std_logic_vector(8 downto 0);
    signal bf0_real_b_in : std_logic_vector(8 downto 0);
    signal bf0_imag_b_in : std_logic_vector(8 downto 0);
    signal bf0_calc_done : std_logic;
    signal bf0_A_done : std_logic;
    signal bf0_B_done : std_logic;
    signal bf0_real_a_out : std_logic_vector(8 downto 0);
    signal bf0_imag_a_out : std_logic_vector(8 downto 0);
    signal bf0_real_b_out : std_logic_vector(8 downto 0);
    signal bf0_imag_b_out : std_logic_vector(8 downto 0);
    -- component butterfly connections

    component Twiddle_table
        generic(
            g_data_samples_exp : natural;
            g_use_BRAM : natural
        );
        port(
            PCLK : in std_logic;
            RSTn : in std_logic;
            -- twiddle count is half of sample count
            twiddle_index : in std_logic_vector(g_data_samples_exp - 2 downto 0);
            twiddle_ready : out std_logic;
        
            cos_twid : out std_logic_vector(8 downto 0);
            cos_twid_1comp : out std_logic_vector(8 downto 0);
            sin_twid : out std_logic_vector(8 downto 0);
            sin_twid_1comp : out std_logic_vector(8 downto 0)
        );
    end component;

    component FFT_Butterfly_HW_MATHDSP
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            do_calc : in std_logic;
            twiddle_cos_real : in std_logic_vector(8 downto 0);
            twiddle_sin_imag : in std_logic_vector(8 downto 0);
            twiddle_sin_imag_1comp : in std_logic_vector(8 downto 0);
            real_a_in : in std_logic_vector(8 downto 0);
            imag_a_in : in std_logic_vector(8 downto 0);
            real_b_in : in std_logic_vector(8 downto 0);
            imag_b_in : in std_logic_vector(8 downto 0);

            -- Outputs
            calc_done : out std_logic;
            A_done : out std_logic;
            B_done : out std_logic;
            real_a_out : out std_logic_vector(8 downto 0);
            imag_a_out : out std_logic_vector(8 downto 0);
            real_b_out : out std_logic_vector(8 downto 0);
            imag_b_out : out std_logic_vector(8 downto 0)

            -- Inouts

        );
    end component;

begin

    Twiddle_table_0 : Twiddle_table
        generic map(
            g_data_samples_exp => SAMPLE_CNT_EXP,
            g_use_BRAM => 1
        )
        port map(
            PCLK => PCLK,
            RSTn => RSTn,
            -- twiddle count is half of sample count
            twiddle_index => twiddle_index,
            twiddle_ready => twiddle_ready,
        
            cos_twid => cos_twid,
            cos_twid_1comp => cos_twid_1comp,
            sin_twid => sin_twid,
            sin_twid_1comp => sin_twid_1comp
        );

    FFT_Butterfly_HW_MATHDSP_0 : FFT_Butterfly_HW_MATHDSP
        -- port map
        port map( 
            -- Inputs
            PCLK => PCLK,
            RSTn => RSTn,
            do_calc => bf0_do_calc,
            twiddle_cos_real => bf0_twiddle_cos_real,
            twiddle_sin_imag => bf0_twiddle_sin_imag,
            twiddle_sin_imag_1comp => bf0_twiddle_sin_imag_1comp,
            real_a_in => bf0_real_a_in,
            imag_a_in => bf0_imag_a_in,
            real_b_in => bf0_real_b_in,
            imag_b_in => bf0_imag_b_in,

            -- Outputs
            calc_done => bf0_calc_done,
            A_done => bf0_A_done,
            B_done => bf0_B_done,
            real_a_out => bf0_real_a_out,
            imag_a_out => bf0_imag_a_out,
            real_b_out => bf0_real_b_out,
            imag_b_out => bf0_imag_b_out

            -- Inouts

        );

    ram_stable_sig <= ram_stable;
    ram_ready_sig <= ram_ready;

    ram_valid <= ram_valid_sig;

    ram_w_en <= ram_w_en_sig;
    ram_adr <= ram_adr_sig;
    ram_dat_w <= ram_dat_w_sig;

    ram_dat_r_sig <= ram_dat_r;

    --=========================================================================

    p_stage_manager : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            stage_cnt <= 0;
            dft_max <= (others => '0');
            dft_run <= '0';
            --bfly_max <= 0;
        elsif(rising_edge(PCLK)) then
            if(ram_stable_sig = '0') then
                -- sync reset
                stage_cnt <= 0;
                dft_max <= (others => '0');
                dft_run <= '0';
                --bfly_max <= 0;
            else
                if(dft_run = '0') then
                    if(stage_cnt /= SAMPLE_CNT_EXP - 1) then
                        stage_cnt <= stage_cnt + 1;
                        -- maybe have reset be (others => '1')
                        -- dft_max is is equivalent to twiddle_step value, so just reuse it
                        dft_max <= shift_right(to_unsigned(2**(SAMPLE_CNT_EXP - 1) - 1, dft_max'length), stage_cnt + 1);
                        --bfly_max <= shift_right(to_unsigned(2**(SAMPLE_CNT_EXP - 1) - 1, dft_max'length), stage_cnt + 1);
                        dft_run <= '1';
                    else
                        -- stages finished
                        -- congratulations, you've earned 1 set of transformed data
                    end if;
                elsif(dft_fin = '1') then
                    dft_run <= '0';
                else
                    
                end if;
            end if;
        end if;
    end process;

    bfly_max <= BIT_REV_FUNC(dft_max);

    

    --=========================================================================

    p_sub_DFT_manager : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            dft_cnt <= 0;
            dft_fin <= '0';
        elsif(rising_edge(PCLK)) then
            if(ram_stable_sig = '0' or dft_run = '0') then
                -- sync reset
                dft_cnt <= 0;
                dft_fin <= '0';
            elsif(dft_run = '1') then
                if(dft_fin = '0') then
                    if(dft_cnt /= dft_max) then
                        dft_cnt <= dft_cnt + 1;
                        twiddle_index <= 
                    else
                        dft_fin <= '1';
                    end if;
                else
                    -- congratulations, you've finished the sub DFT
                end if;
            end if;
        end if;
    end process;

    --=========================================================================

    p_butterfly_manager : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            bfly_cnt <= 0;
            bfly_fin <= '0';
        elsif(rising_edge(PCLK)) then
            if(ram_stable_sig = '0' or dft_run = '0') then
                -- sync reset
                bfly_cnt <= 0;
                bfly_fin <= '0';
            elsif(dft_run = '1') then
                if(bfly_fin = '0') then
                    if(bfly_cnt /= bfly_max) then
                        bfly_cnt <= bfly_cnt + 1;
                        twiddle_index <= 
                    else
                        bfly_fin <= '1';
                    end if;
                else
                    -- congratulations, you've finished the sub DFT
                end if;
            end if;
        end if;
    end process;

    ram_adr_sig(0) <= sampleA_adr;
    ram_adr_sig(1) <= sampleB_adr;
    

   -- architecture body
end architecture_FFT_Transformer;
