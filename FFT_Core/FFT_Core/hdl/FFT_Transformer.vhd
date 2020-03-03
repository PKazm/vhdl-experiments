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
-- RAM1 
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S010> <Package::144 TQ>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.FFT_package.all;

entity FFT_Transformer is
--generic (
    --g_data_width : natural := 8;
    --g_samples_exp : natural := 5
    --g_sync_input : natural := 0
--);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    -- connections to FFT RAM block
    ram_stable : in std_logic;
    ram_ready : in std_logic;

    ram_assigned : in std_logic;
    ram_returned : out std_logic;

    ram_valid : out std_logic;

    ram_w_en_0 : out w_en_array_type;
    ram_adr_0 : out adr_array_type;
    ram_dat_w_0 : out ram_dat_array_type;
    ram_dat_r_0 : in ram_dat_array_type;
    ram_w_en_1 : out w_en_array_type;
    ram_adr_1 : out adr_array_type;
    ram_dat_w_1 : out ram_dat_array_type;
    ram_dat_r_1 : in ram_dat_array_type
    -- connections to FFT RAM block
);
end FFT_Transformer;
architecture architecture_FFT_Transformer of FFT_Transformer is

	constant PIPELINE_DELAY : natural := 4;

    type stage_states is(srst, runDFT, DFTrunning, FFTdone);
    signal stage_state : stage_states;

    signal transformation_finished : std_logic;     -- say it loud, say it proud

    signal stage_0_cur : std_logic;
    signal stage_cnt : natural range 0 to SAMPLE_CNT_EXP - 1 := 0;
    -- 2**(SAMPLE_CNT_EXP - 1) - 1 = N / 2
    signal dft_cnt : natural range 0 to 2**(SAMPLE_CNT_EXP - 1) - 1 := 0;
    signal bfly_cnt : natural range 0 to 2**(SAMPLE_CNT_EXP - 1) - 1 := 0;

    signal dft_max : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    signal dft_run : std_logic;
    signal dft_done : std_logic;
    signal dft_done_last : std_logic;
    signal dft_fin : std_logic;

    signal bfly_max : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    --signal bfly_run : std_logic;

    signal twiddle_step : unsigned(SAMPLE_CNT_EXP - 2 downto 0);

    type sample_adr_type is array(PIPELINE_DELAY - 3 downto 0) of std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);

    signal ram_r_adr_A : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal ram_r_adr_B : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal sampleA_adr : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal sampleB_adr : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal sampleA_adr_pipe : sample_adr_type;
    signal sampleB_adr_pipe : sample_adr_type;


    -- external sample ram connections
    signal ram_dest : std_logic;
    signal ram_stable_sig : std_logic;
    signal ram_ready_sig : std_logic;
    signal ram_valid_sig : std_logic;
    signal ram_w_en_0_sig : w_en_array_type;
    --signal ram_w_en_0_sig : std_logic_vector(PORT_CNT - 1 downto 0);
    signal ram_r_en_0 : r_en_array_type;
    signal ram_adr_0_sig : adr_array_type;
    signal ram_dat_w_0_sig : ram_dat_array_type;
    signal ram_dat_r_0_sig : ram_dat_array_type;
    signal ram_w_en_1_sig : w_en_array_type;
    --signal ram_w_en_1_sig : std_logic_vector(PORT_CNT - 1 downto 0);
    signal ram_r_en_1 : r_en_array_type;
    signal ram_adr_1_sig : adr_array_type;
    signal ram_dat_w_1_sig : ram_dat_array_type;
    signal ram_dat_r_1_sig : ram_dat_array_type;
    -- external sample ram connections


    -- component twiddle table connections
    signal twiddle_index : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_index_next : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_index_next2 : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_ready : std_logic;
    signal cos_twid : std_logic_vector(8 downto 0);
    signal cos_twid_1comp : std_logic_vector(8 downto 0);
    signal sin_twid : std_logic_vector(8 downto 0);
    signal sin_twid_1comp : std_logic_vector(8 downto 0);
    -- component twiddle table connections

    -- component butterfly connections
    signal do_calc_ctrl : std_logic;
    signal bf0_do_calc : std_logic;
    signal bf0_do_calc_next : std_logic;
    signal bf0_do_calc_next2 : std_logic;
    signal bf0_twiddle_cos_real : std_logic_vector(8 downto 0);
    signal bf0_twiddle_sin_imag : std_logic_vector(8 downto 0);
    signal bf0_twiddle_sin_imag_1comp : std_logic_vector(8 downto 0);
    signal bf0_adr_a_in : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_adr_b_in : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_real_a_in : std_logic_vector(8 downto 0);
    signal bf0_imag_a_in : std_logic_vector(8 downto 0);
    signal bf0_real_b_in : std_logic_vector(8 downto 0);
    signal bf0_imag_b_in : std_logic_vector(8 downto 0);
    signal bf0_calc_done : std_logic;
    signal bf0_adr_a_out : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_adr_b_out : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
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
        generic (
			g_adr_width : natural := 8;
			g_pipeline : natural := 1
		);
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            do_calc : in std_logic;
            twiddle_cos_real : in std_logic_vector(8 downto 0);
            twiddle_sin_imag : in std_logic_vector(8 downto 0);
            twiddle_sin_imag_1comp : in std_logic_vector(8 downto 0);
			adr_a_in : in std_logic_vector(g_adr_width - 1 downto 0);
			adr_b_in : in std_logic_vector(g_adr_width - 1 downto 0);
            real_a_in : in std_logic_vector(8 downto 0);
            imag_a_in : in std_logic_vector(8 downto 0);
            real_b_in : in std_logic_vector(8 downto 0);
            imag_b_in : in std_logic_vector(8 downto 0);

            -- Outputs
            calc_done : out std_logic;
			adr_a_out : out std_logic_vector(g_adr_width - 1 downto 0);
			adr_b_out : out std_logic_vector(g_adr_width - 1 downto 0);
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
            g_use_BRAM => 0
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
        generic map(
			g_adr_width => SAMPLE_CNT_EXP,
			g_pipeline => 1
		)
        -- port map
        port map( 
            -- Inputs
            PCLK => PCLK,
            RSTn => RSTn,
            do_calc => bf0_do_calc,
            twiddle_cos_real => bf0_twiddle_cos_real,
            twiddle_sin_imag => bf0_twiddle_sin_imag,
            twiddle_sin_imag_1comp => bf0_twiddle_sin_imag_1comp,
            adr_a_in => bf0_adr_a_in,
            adr_b_in => bf0_adr_b_in,
            real_a_in => bf0_real_a_in,
            imag_a_in => bf0_imag_a_in,
            real_b_in => bf0_real_b_in,
            imag_b_in => bf0_imag_b_in,

            -- Outputs
            calc_done => bf0_calc_done,
            adr_a_out => bf0_adr_a_out,
            adr_b_out => bf0_adr_b_out,
            real_a_out => bf0_real_a_out,
            imag_a_out => bf0_imag_a_out,
            real_b_out => bf0_real_b_out,
            imag_b_out => bf0_imag_b_out

            -- Inouts

        );

    ram_stable_sig <= ram_stable;
    ram_ready_sig <= ram_ready;

    ram_valid <= ram_valid_sig;

    ram_w_en_0 <= ram_w_en_0_sig;
    ram_adr_0 <= ram_adr_0_sig;
    ram_dat_w_0 <= ram_dat_w_0_sig;
    ram_w_en_1 <= ram_w_en_1_sig;
    ram_adr_1 <= ram_adr_1_sig;
    ram_dat_w_1 <= ram_dat_w_1_sig;

    ram_dat_r_0_sig <= ram_dat_r_0;
    ram_dat_r_1_sig <= ram_dat_r_1;

    --p_ram_buf : process(PCLK, RSTn)
    --begin
    --    if(rising_edge(PCLK)) then
    --        ram_dat_r_0_sig <= ram_dat_r_a;
    --        ram_dat_r_1_sig <= ram_dat_r_b;
    --    end if;
    --end process;

    --=========================================================================

    p_stage_manager : process(PCLK, RSTn)
        variable dft_max_next_var : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
        variable bfly_max_next_var : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    begin
        if(RSTn = '0') then
            stage_state <= runDFT;
            transformation_finished <= '0';
            ram_dest <= not ram_assigned;
            stage_0_cur <= '1';
            stage_cnt <= 0;
            dft_max <= (others => '1');
            dft_max_next_var := (others => '1');
            dft_run <= '0';
            bfly_max <= (others => '0');--to_unsigned(1, bfly_max'length);
            bfly_max_next_var := (others => '0');--to_unsigned(1, bfly_max'length);
            
        elsif(rising_edge(PCLK)) then
            if(ram_stable_sig = '0' and twiddle_ready = '0') then
                -- sync reset
                stage_state <= runDFT;
                transformation_finished <= '0';
                ram_dest <= not ram_assigned;
                stage_0_cur <= '1';
                stage_cnt <= 0;
                dft_max <= (others => '1');
                dft_max_next_var := (others => '1');
                dft_run <= '0';
                bfly_max <= (others => '0');--to_unsigned(1, bfly_max'length);
                bfly_max_next_var := (others => '0');--to_unsigned(1, bfly_max'length);
            else
                case stage_state is
                    when runDFT =>
                        dft_run <= '1';
                        if(bf0_do_calc = '1') then
                            -- randomly selected indicator of DFT running
                            stage_state <= DFTrunning;
                        end if;
                    when DFTrunning =>
                        if(dft_done = '1') then
                            if(stage_cnt /= SAMPLE_CNT_EXP - 1) then
                                stage_cnt <= stage_cnt + 1;
                                stage_0_cur <= '0';
                                ram_dest <= not ram_dest;
                                dft_run <= '0';
                                dft_max <= shift_right(dft_max, 1);
                                bfly_max <= bfly_max(bfly_max'high - 1 downto 0) & '1';
                                stage_state <= runDFT;
                            else
                                stage_state <= FFTdone;
                            end if;
                        end if;
                    when FFTdone =>
                        transformation_finished <= '1';
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    twiddle_step <= dft_max;
    ram_returned <= ram_dest;

    --=========================================================================

    p_sub_DFT_BFly_manager : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then

            dft_cnt <= 0;
            dft_fin <= '0';
            dft_done <= '0';

            bfly_cnt <= 0;
            do_calc_ctrl <= '0';
            bf0_do_calc <= '0';
            bf0_do_calc_next <= '0';
            bf0_do_calc_next2 <= '0';
            twiddle_index <= (others => '0');
            twiddle_index_next <= (others => '0');
            twiddle_index_next2 <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(ram_stable_sig = '0' or dft_run = '0') then
                -- sync reset

                dft_cnt <= 0;
                dft_fin <= '0';
                dft_done <= '0';

                bfly_cnt <= 0;
                do_calc_ctrl <= '0';
                bf0_do_calc <= '0';
                bf0_do_calc_next <= '0';
                bf0_do_calc_next2 <= '0';
                twiddle_index <= (others => '0');
                twiddle_index_next <= (others => '0');
                twiddle_index_next2 <= (others => '0');
            elsif(dft_run = '1') then

                twiddle_index_next2 <= twiddle_index_next;
                twiddle_index <= twiddle_index_next2;
                bf0_do_calc_next <= '1';
                if(bfly_cnt /= bfly_max) then
                    bfly_cnt <= bfly_cnt + 1;
                    twiddle_index_next <= std_logic_vector(unsigned(twiddle_index_next) + twiddle_step + 1);
                else
                    if(dft_cnt /= dft_max) then
                        dft_cnt <= dft_cnt + 1;
                        bfly_cnt <= 0;
                        twiddle_index_next <= (others => '0');
                    else
                        -- congratulations, you've finished the sub DFT
                        dft_fin <= '1';
                    end if;
                end if;

                if(dft_fin = '1') then
                    bf0_do_calc_next <= '0';
                end if;

                if(bf0_calc_done = '0' and dft_fin = '1') then
                    dft_done <= '1';
                end if;

                bf0_do_calc_next2 <= bf0_do_calc_next;
                bf0_do_calc <= bf0_do_calc_next2;
            end if;
            
        end if;
    end process;

    
    sampleB_adr <= std_logic_vector(unsigned(sampleA_adr) + unsigned(shift_left(to_unsigned(1, sampleB_adr'length), stage_cnt)));

    p_pipe_pusher : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            sampleA_adr <= (others => '0');
            for i in 0 to sampleA_adr_pipe'high loop
                sampleA_adr_pipe(i) <= (others => '0');
                sampleB_adr_pipe(i) <= (others => '0');
            end loop;
        elsif(rising_edge(PCLK)) then
            if(ram_stable_sig = '0' or dft_run = '0') then
                -- sync reset
                sampleA_adr <= (others => '0');
                for i in 0 to sampleA_adr_pipe'high loop
                    sampleA_adr_pipe(i) <= (others => '0');
                    sampleB_adr_pipe(i) <= (others => '0');
                end loop;
            else
                sampleA_adr <= std_logic_vector(to_unsigned(bfly_cnt, sampleA_adr'length) + shift_left(to_unsigned(dft_cnt, sampleA_adr'length), stage_cnt+1));
                sampleA_adr_pipe(0) <= sampleA_adr;
                sampleB_adr_pipe(0) <= sampleB_adr;
                for i in 1 to sampleA_adr_pipe'high loop
                    sampleA_adr_pipe(i) <= sampleA_adr_pipe(i - 1);
                    sampleB_adr_pipe(i) <= sampleB_adr_pipe(i - 1);
                end loop;
                
            end if;
        end if;
    end process;

    --=========================================================================

    
    ram_valid_sig <= transformation_finished;
    
    -- creating input buffer for twiddle factors changes routing on data address to reach 200Mhz.... let it be for now.
    --bf0_twiddle_cos_real <= cos_twid;
    --bf0_twiddle_sin_imag <= sin_twid;
    --bf0_twiddle_sin_imag_1comp <= sin_twid_1comp;
    bf0_adr_a_in <= sampleA_adr_pipe(sampleA_adr_pipe'high);
    bf0_adr_b_in <= sampleB_adr_pipe(sampleB_adr_pipe'high);

    p_MACC_buf : process(PCLK, RSTn)
    begin
        if(rstn = '0') then
            bf0_twiddle_cos_real <= (others => '0');
            bf0_twiddle_sin_imag <= (others => '0');
            bf0_twiddle_sin_imag_1comp <= (others => '0');
            bf0_real_a_in <= (others => '0');
            bf0_imag_a_in <= (others => '0');
            bf0_real_b_in <= (others => '0');
            bf0_imag_b_in <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(ram_stable = '0') then
                bf0_real_a_in <= (others => '0');
                bf0_imag_a_in <= (others => '0');
                bf0_real_b_in <= (others => '0');
                bf0_imag_b_in <= (others => '0');
            else
                bf0_twiddle_cos_real <= cos_twid;
                bf0_twiddle_sin_imag <= sin_twid;
                bf0_twiddle_sin_imag_1comp <= sin_twid_1comp;
                bf0_real_a_in <= ram_dat_r_0_sig(0)(8 downto 0) when ram_dest = '1' else ram_dat_r_1_sig(0)(8 downto 0);
                bf0_imag_a_in <= ram_dat_r_0_sig(0)(17 downto 9) when ram_dest = '1' else ram_dat_r_1_sig(0)(17 downto 9);
                bf0_real_b_in <= ram_dat_r_0_sig(1)(8 downto 0) when ram_dest = '1' else ram_dat_r_1_sig(1)(8 downto 0);
                bf0_imag_b_in <= ram_dat_r_0_sig(1)(17 downto 9) when ram_dest = '1' else ram_dat_r_1_sig(1)(17 downto 9);
            end if;
        end if;
    end process;

    -- bit rev sort incoming data on the fly
    ram_r_adr_A <= BIT_REV_FUNC(sampleA_adr) when stage_0_cur = '1' else sampleA_adr;
    ram_r_adr_B <= BIT_REV_FUNC(sampleB_adr) when stage_0_cur = '1' else sampleB_adr;

    ram_adr_0_sig(0) <= bf0_adr_a_out when ram_dest = '0' else ram_r_adr_A;
    ram_adr_0_sig(1) <= bf0_adr_b_out when ram_dest = '0' else ram_r_adr_B;
    ram_dat_w_0_sig(0)(8 downto 0) <= bf0_real_a_out;
    ram_dat_w_0_sig(0)(17 downto 9) <= bf0_imag_a_out;
    ram_dat_w_0_sig(1)(8 downto 0) <= bf0_real_b_out;
    ram_dat_w_0_sig(1)(17 downto 9) <= bf0_imag_b_out;
    ram_w_en_0_sig <= (others => bf0_calc_done) when ram_dest = '0' else (others => '0');

    ram_adr_1_sig(0) <= bf0_adr_a_out when ram_dest = '1' else ram_r_adr_A;
    ram_adr_1_sig(1) <= bf0_adr_b_out when ram_dest = '1' else ram_r_adr_B;
    ram_dat_w_1_sig(0)(8 downto 0) <= bf0_real_a_out;
    ram_dat_w_1_sig(0)(17 downto 9) <= bf0_imag_a_out;
    ram_dat_w_1_sig(1)(8 downto 0) <= bf0_real_b_out;
    ram_dat_w_1_sig(1)(17 downto 9) <= bf0_imag_b_out;
    ram_w_en_1_sig <= (others => bf0_calc_done) when ram_dest = '1' else (others => '0');
    

   -- architecture body
end architecture_FFT_Transformer;
