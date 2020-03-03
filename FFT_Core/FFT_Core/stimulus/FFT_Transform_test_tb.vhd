--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Transform_test_sd_tb.vhd
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.FFT_package.all;

library modelsim_lib;
use modelsim_lib.util.all;


entity FFT_Transform_test_tb is
end FFT_Transform_test_tb;

architecture behavioral of FFT_Transform_test_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    -- FFT Transform signals
    signal ram_stable : std_logic;
    signal ram_ready : std_logic;
    signal ram_valid : std_logic;
    signal ram_assigned : std_logic;
    signal ram_returned : std_logic;
    signal ram_w_en_0 : w_en_array_type;
    signal ram_adr_0 : adr_array_type;
    signal ram_dat_w_0 : ram_dat_array_type;
    signal ram_dat_r_0 : ram_dat_array_type;
    signal ram_w_en_1 : w_en_array_type;
    signal ram_adr_1 : adr_array_type;
    signal ram_dat_w_1 : ram_dat_array_type;
    signal ram_dat_r_1 : ram_dat_array_type;
    -- FFT Transform signals

    -- DPSRAM signals
    signal A_WEN_0 : std_logic;
    signal B_WEN_0 : std_logic;
    signal A_ADDR_0 : std_logic_vector(9 downto 0);
    signal A_DIN_0 : std_logic_vector(17 downto 0);
    signal B_ADDR_0 : std_logic_vector(9 downto 0);
    signal B_DIN_0 : std_logic_vector(17 downto 0);
    signal A_DOUT_0 : std_logic_vector(17 downto 0);
    signal B_DOUT_0 : std_logic_vector(17 downto 0);
    signal A_DOUT_0_REAL : std_logic_vector(8 downto 0);
    signal A_DOUT_0_IMAG : std_logic_vector(8 downto 0);
    signal B_DOUT_0_REAL : std_logic_vector(8 downto 0);
    signal B_DOUT_0_IMAG : std_logic_vector(8 downto 0);
    signal A_WEN_1 : std_logic;
    signal B_WEN_1 : std_logic;
    signal A_ADDR_1 : std_logic_vector(9 downto 0);
    signal A_DIN_1 : std_logic_vector(17 downto 0);
    signal B_ADDR_1 : std_logic_vector(9 downto 0);
    signal B_DIN_1 : std_logic_vector(17 downto 0);
    signal A_DOUT_1 : std_logic_vector(17 downto 0);
    signal B_DOUT_1 : std_logic_vector(17 downto 0);
    signal A_DOUT_1_REAL : std_logic_vector(8 downto 0);
    signal A_DOUT_1_IMAG : std_logic_vector(8 downto 0);
    signal B_DOUT_1_REAL : std_logic_vector(8 downto 0);
    signal B_DOUT_1_IMAG : std_logic_vector(8 downto 0);

    signal A_wen_init : std_logic;
    signal A_adr_init : std_logic_vector(9 downto 0);
    signal A_din_init : std_logic_vector(17 downto 0);
    -- DPSRAM signals

    -- transform spies
    signal stage_cnt_spy : natural range 0 to SAMPLE_CNT_EXP - 1 := 0;
    signal dft_cnt_spy : natural range 0 to 2**(SAMPLE_CNT_EXP - 1) - 1 := 0;
    signal bfly_cnt_spy : natural range 0 to 2**(SAMPLE_CNT_EXP - 1) - 1 := 0;
    signal dft_fin_spy : std_logic;
    signal dft_done_spy : std_logic;
    signal dft_max_spy : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    signal bfly_max_spy : unsigned(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_index_next_spy : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_index_next2_spy : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal twiddle_index_spy : std_logic_vector(SAMPLE_CNT_EXP - 2 downto 0);
    signal bf0_do_calc_spy : std_logic;
    signal bf0_adr_a_in_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_adr_b_in_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_real_a_in_spy : std_logic_vector(8 downto 0);
    signal bf0_imag_a_in_spy : std_logic_vector(8 downto 0);
    signal bf0_real_b_in_spy : std_logic_vector(8 downto 0);
    signal bf0_imag_b_in_spy : std_logic_vector(8 downto 0);
    type adr_pipe_type is array(4 - 1 downto 0) of std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    --signal adr_a_pipe_spy : adr_pipe_type;
    --signal adr_b_pipe_spy : adr_pipe_type;
    signal adr_a_pipe1_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal adr_b_pipe1_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal twiddle_cos_real_spy : std_logic_vector(8 downto 0);
    signal twiddle_sin_imag_spy : std_logic_vector(8 downto 0);
    signal temp_real_trunc_rnd_spy : signed(9 downto 0);
    signal temp_imag_trunc_rnd_spy : signed(9 downto 0);
    signal real_a_to_arith_spy : std_logic_vector(9 downto 0);
    signal imag_a_to_arith_spy : std_logic_vector(9 downto 0);
    --signal real_a_out_sum_spy : std_logic_vector(9 downto 0);
    --signal imag_a_out_sum_spy : std_logic_vector(9 downto 0);
    --signal real_b_out_sum_spy : std_logic_vector(9 downto 0);
    --signal imag_b_out_sum_spy : std_logic_vector(9 downto 0);
    signal bf0_calc_done_spy : std_logic;
    signal bf0_adr_a_out_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_adr_b_out_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal bf0_real_a_out_spy : std_logic_vector(8 downto 0);
    signal bf0_imag_a_out_spy : std_logic_vector(8 downto 0);
    signal bf0_real_b_out_spy : std_logic_vector(8 downto 0);
    signal bf0_imag_b_out_spy : std_logic_vector(8 downto 0);
    -- transform spies

    component FFT_Transform_test
        -- ports
        port( 
            -- Inputs
            ram_ready : in std_logic;
            PCLK : in std_logic;
            RSTn : in std_logic;
            ram_stable : in std_logic;
            A_WEN_0 : in std_logic;
            B_WEN_0 : in std_logic;
            A_WEN_1 : in std_logic;
            B_WEN_1 : in std_logic;
            ram_assigned : in std_logic;
            B_DIN_0 : in std_logic_vector(17 downto 0);
            A_ADDR_0 : in std_logic_vector(9 downto 0);
            A_DIN_0 : in std_logic_vector(17 downto 0);
            B_ADDR_0 : in std_logic_vector(9 downto 0);
            A_DIN_1 : in std_logic_vector(17 downto 0);
            A_ADDR_1 : in std_logic_vector(9 downto 0);
            B_DIN_1 : in std_logic_vector(17 downto 0);
            B_ADDR_1 : in std_logic_vector(9 downto 0);
            ram_dat_r_0 : ram_dat_array_type;
            ram_dat_r_1 : ram_dat_array_type;

            -- Outputs
            ram_valid : out std_logic;
            ram_returned : out std_logic;
            B_DOUT_0 : out std_logic_vector(17 downto 0);
            A_DOUT_0 : out std_logic_vector(17 downto 0);
            B_DOUT_1 : out std_logic_vector(17 downto 0);
            A_DOUT_1 : out std_logic_vector(17 downto 0);
            ram_w_en_0 : out w_en_array_type;
            ram_w_en_1 : out w_en_array_type;
            ram_adr_0 : out adr_array_type;
            ram_dat_w_1 : out ram_dat_array_type;
            ram_adr_1 : out adr_array_type;
            ram_dat_w_0 : out ram_dat_array_type

            -- Inouts

        );
    end component;

    signal init_done : std_logic := '0';
    type test_sample_mem is array (0 to (2**8) - 1) of std_logic_vector(SAMPLE_WIDTH_INT * 2 - 1 downto 0);
    constant TEST_SAMPLES : test_sample_mem := (
            "0" & X"00" & std_logic_vector(to_signed(1, 9)),
            "0" & X"00" & std_logic_vector(to_signed(133, 9)),
            "0" & X"00" & std_logic_vector(to_signed(210, 9)),
            "0" & X"00" & std_logic_vector(to_signed(65, 9)),
            "0" & X"00" & std_logic_vector(to_signed(128, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-46, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-67, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-168, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-170, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-96, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-69, 9)),
            "0" & X"00" & std_logic_vector(to_signed(86, 9)),
            "0" & X"00" & std_logic_vector(to_signed(82, 9)),
            "0" & X"00" & std_logic_vector(to_signed(165, 9)),
            "0" & X"00" & std_logic_vector(to_signed(75, 9)),
            "0" & X"00" & std_logic_vector(to_signed(64, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-9, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-65, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-15, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-126, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-49, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-95, 9)),
            "0" & X"00" & std_logic_vector(to_signed(28, 9)),
            "0" & X"00" & std_logic_vector(to_signed(92, 9)),
            "0" & X"00" & std_logic_vector(to_signed(115, 9)),
            "0" & X"00" & std_logic_vector(to_signed(166, 9)),
            "0" & X"00" & std_logic_vector(to_signed(40, 9)),
            "0" & X"00" & std_logic_vector(to_signed(61, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-153, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-97, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-198, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-101, 9)),
            "0" & X"00" & std_logic_vector(to_signed(0, 9)),
            "0" & X"00" & std_logic_vector(to_signed(0, 9)),
            "0" & X"00" & std_logic_vector(to_signed(0, 9)),
            "0" & X"00" & std_logic_vector(to_signed(17, 9)),
            "0" & X"00" & std_logic_vector(to_signed(102, 9)),
            "0" & X"00" & std_logic_vector(to_signed(73, 9)),
            "0" & X"00" & std_logic_vector(to_signed(44, 9)),
            "0" & X"00" & std_logic_vector(to_signed(52, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-41, 9)),
            "0" & X"00" & std_logic_vector(to_signed(19, 9)),
            "0" & X"00" & std_logic_vector(to_signed(57, 9)),
            "0" & X"00" & std_logic_vector(to_signed(11, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-4, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-107, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-45, 9)),
            "0" & X"00" & std_logic_vector(to_signed(12, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-95, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-36, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-147, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-117, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-19, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-126, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-79, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-166, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-157, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-74, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-139, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-133, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-164, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-209, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-66, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-123, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-182, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-173, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-192, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-113, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-137, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-153, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-152, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-207, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-96, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-62, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-100, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-62, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-157, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-48, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-18, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-99, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-35, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-101, 9)),
            "0" & X"00" & std_logic_vector(to_signed(5, 9)),
            "0" & X"00" & std_logic_vector(to_signed(30, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-19, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-14, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-45, 9)),
            "0" & X"00" & std_logic_vector(to_signed(20, 9)),
            "0" & X"00" & std_logic_vector(to_signed(99, 9)),
            "0" & X"00" & std_logic_vector(to_signed(47, 9)),
            "0" & X"00" & std_logic_vector(to_signed(69, 9)),
            "0" & X"00" & std_logic_vector(to_signed(27, 9)),
            "0" & X"00" & std_logic_vector(to_signed(49, 9)),
            "0" & X"00" & std_logic_vector(to_signed(130, 9)),
            "0" & X"00" & std_logic_vector(to_signed(88, 9)),
            "0" & X"00" & std_logic_vector(to_signed(109, 9)),
            "0" & X"00" & std_logic_vector(to_signed(98, 9)),
            "0" & X"00" & std_logic_vector(to_signed(47, 9)),
            "0" & X"00" & std_logic_vector(to_signed(216, 9)),
            "0" & X"00" & std_logic_vector(to_signed(135, 9)),
            "0" & X"00" & std_logic_vector(to_signed(122, 9)),
            "0" & X"00" & std_logic_vector(to_signed(93, 9)),
            "0" & X"00" & std_logic_vector(to_signed(107, 9)),
            "0" & X"00" & std_logic_vector(to_signed(227, 9)),
            "0" & X"00" & std_logic_vector(to_signed(151, 9)),
            "0" & X"00" & std_logic_vector(to_signed(161, 9)),
            "0" & X"00" & std_logic_vector(to_signed(148, 9)),
            "0" & X"00" & std_logic_vector(to_signed(71, 9)),
            "0" & X"00" & std_logic_vector(to_signed(218, 9)),
            "0" & X"00" & std_logic_vector(to_signed(227, 9)),
            "0" & X"00" & std_logic_vector(to_signed(127, 9)),
            "0" & X"00" & std_logic_vector(to_signed(125, 9)),
            "0" & X"00" & std_logic_vector(to_signed(61, 9)),
            "0" & X"00" & std_logic_vector(to_signed(194, 9)),
            "0" & X"00" & std_logic_vector(to_signed(174, 9)),
            "0" & X"00" & std_logic_vector(to_signed(101, 9)),
            "0" & X"00" & std_logic_vector(to_signed(131, 9)),
            "0" & X"00" & std_logic_vector(to_signed(31, 9)),
            "0" & X"00" & std_logic_vector(to_signed(125, 9)),
            "0" & X"00" & std_logic_vector(to_signed(158, 9)),
            "0" & X"00" & std_logic_vector(to_signed(70, 9)),
            "0" & X"00" & std_logic_vector(to_signed(88, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-2, 9)),
            "0" & X"00" & std_logic_vector(to_signed(65, 9)),
            "0" & X"00" & std_logic_vector(to_signed(92, 9)),
            "0" & X"00" & std_logic_vector(to_signed(45, 9)),
            "0" & X"00" & std_logic_vector(to_signed(28, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-45, 9)),
            "0" & X"00" & std_logic_vector(to_signed(31, 9)),
            "0" & X"00" & std_logic_vector(to_signed(81, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-44, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-8, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-75, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-81, 9)),
            "0" & X"00" & std_logic_vector(to_signed(3, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-86, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-94, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-134, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-130, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-44, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-136, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-137, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-157, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-200, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-65, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-153, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-163, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-191, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-236, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-68, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-150, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-180, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-158, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-240, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-90, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-130, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-118, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-151, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-172, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-84, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-61, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-129, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-94, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-205, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-69, 9)),
            "0" & X"00" & std_logic_vector(to_signed(5, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-78, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-40, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-108, 9)),
            "0" & X"00" & std_logic_vector(to_signed(5, 9)),
            "0" & X"00" & std_logic_vector(to_signed(73, 9)),
            "0" & X"00" & std_logic_vector(to_signed(0, 9)),
            "0" & X"00" & std_logic_vector(to_signed(20, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-46, 9)),
            "0" & X"00" & std_logic_vector(to_signed(34, 9)),
            "0" & X"00" & std_logic_vector(to_signed(106, 9)),
            "0" & X"00" & std_logic_vector(to_signed(26, 9)),
            "0" & X"00" & std_logic_vector(to_signed(91, 9)),
            "0" & X"00" & std_logic_vector(to_signed(38, 9)),
            "0" & X"00" & std_logic_vector(to_signed(77, 9)),
            "0" & X"00" & std_logic_vector(to_signed(185, 9)),
            "0" & X"00" & std_logic_vector(to_signed(92, 9)),
            "0" & X"00" & std_logic_vector(to_signed(124, 9)),
            "0" & X"00" & std_logic_vector(to_signed(95, 9)),
            "0" & X"00" & std_logic_vector(to_signed(93, 9)),
            "0" & X"00" & std_logic_vector(to_signed(201, 9)),
            "0" & X"00" & std_logic_vector(to_signed(141, 9)),
            "0" & X"00" & std_logic_vector(to_signed(155, 9)),
            "0" & X"00" & std_logic_vector(to_signed(136, 9)),
            "0" & X"00" & std_logic_vector(to_signed(94, 9)),
            "0" & X"00" & std_logic_vector(to_signed(214, 9)),
            "0" & X"00" & std_logic_vector(to_signed(154, 9)),
            "0" & X"00" & std_logic_vector(to_signed(166, 9)),
            "0" & X"00" & std_logic_vector(to_signed(161, 9)),
            "0" & X"00" & std_logic_vector(to_signed(79, 9)),
            "0" & X"00" & std_logic_vector(to_signed(203, 9)),
            "0" & X"00" & std_logic_vector(to_signed(172, 9)),
            "0" & X"00" & std_logic_vector(to_signed(141, 9)),
            "0" & X"00" & std_logic_vector(to_signed(128, 9)),
            "0" & X"00" & std_logic_vector(to_signed(46, 9)),
            "0" & X"00" & std_logic_vector(to_signed(178, 9)),
            "0" & X"00" & std_logic_vector(to_signed(171, 9)),
            "0" & X"00" & std_logic_vector(to_signed(89, 9)),
            "0" & X"00" & std_logic_vector(to_signed(123, 9)),
            "0" & X"00" & std_logic_vector(to_signed(21, 9)),
            "0" & X"00" & std_logic_vector(to_signed(137, 9)),
            "0" & X"00" & std_logic_vector(to_signed(149, 9)),
            "0" & X"00" & std_logic_vector(to_signed(59, 9)),
            "0" & X"00" & std_logic_vector(to_signed(79, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-46, 9)),
            "0" & X"00" & std_logic_vector(to_signed(46, 9)),
            "0" & X"00" & std_logic_vector(to_signed(70, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-1, 9)),
            "0" & X"00" & std_logic_vector(to_signed(15, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-50, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-26, 9)),
            "0" & X"00" & std_logic_vector(to_signed(22, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-53, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-39, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-106, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-102, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-22, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-92, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-81, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-164, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-174, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-60, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-132, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-96, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-160, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-201, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-57, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-113, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-164, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-188, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-239, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-103, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-103, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-151, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-143, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-181, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-105, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-103, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-106, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-111, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-182, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-60, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-90, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-92, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-71, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-154, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-61, 9)),
            "0" & X"00" & std_logic_vector(to_signed(10, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-28, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-2, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-85, 9))
    );

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  FFT_Transform_test
    FFT_Transform_test_0 : FFT_Transform_test
        -- port map
        port map( 
            -- Inputs
            ram_ready => ram_ready,
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            ram_stable => ram_stable,
            ram_assigned => ram_assigned,
            B_ADDR_0 => B_ADDR_0,
            B_DIN_0 => B_DIN_0,
            A_ADDR_0 => A_ADDR_0,
            A_DIN_0 => A_DIN_0,
            B_WEN_0 => B_WEN_0,
            A_WEN_0 => A_WEN_0,
            B_ADDR_1 => B_ADDR_1,
            B_DIN_1 => B_DIN_1,
            A_ADDR_1 => A_ADDR_1,
            A_DIN_1 => A_DIN_1,
            B_WEN_1 => B_WEN_1,
            A_WEN_1 => A_WEN_1,
            ram_dat_r_0 => ram_dat_r_0,
            ram_dat_r_1 => ram_dat_r_1,

            -- Outputs
            B_DOUT_0 => B_DOUT_0,
            A_DOUT_0 => A_DOUT_0,
            B_DOUT_1 => B_DOUT_1,
            A_DOUT_1 => A_DOUT_1,
            ram_valid => ram_valid,
            ram_returned => ram_returned,
            ram_w_en_0 => ram_w_en_0,
            ram_w_en_1 => ram_w_en_1,
            ram_adr_0 => ram_adr_0,
            ram_dat_w_1 => ram_dat_w_1,
            ram_adr_1 => ram_adr_1,
            ram_dat_w_0 => ram_dat_w_0

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/stage_cnt", "stage_cnt_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/dft_cnt", "dft_cnt_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bfly_cnt", "bfly_cnt_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/dft_fin", "dft_fin_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/dft_done", "dft_done_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/dft_max", "dft_max_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bfly_max", "bfly_max_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/twiddle_index", "twiddle_index_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/twiddle_index_next", "twiddle_index_next_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/twiddle_index_next2", "twiddle_index_next2_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_do_calc", "bf0_do_calc_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_adr_a_in", "bf0_adr_a_in_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_adr_b_in", "bf0_adr_b_in_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_real_a_in", "bf0_real_a_in_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_imag_a_in", "bf0_imag_a_in_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_real_b_in", "bf0_real_b_in_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_imag_b_in", "bf0_imag_b_in_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/twiddle_cos_real", "twiddle_cos_real_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/twiddle_sin_imag", "twiddle_sin_imag_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/adr_a_pipe(1)", "adr_a_pipe1_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/adr_b_pipe(1)", "adr_b_pipe1_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/temp_real_trunc_rnd", "temp_real_trunc_rnd_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/temp_imag_trunc_rnd", "temp_imag_trunc_rnd_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/real_a_to_arith", "real_a_to_arith_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/imag_a_to_arith", "imag_a_to_arith_spy", 1, -1);
        --init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/real_a_out_sum", "real_a_out_sum_spy", 1, -1);
        --init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/imag_a_out_sum", "imag_a_out_sum_spy", 1, -1);
        --init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/real_b_out_sum", "real_b_out_sum_spy", 1, -1);
        --init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/FFT_Butterfly_HW_MATHDSP_0/imag_b_out_sum", "imag_b_out_sum_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_calc_done", "bf0_calc_done_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_adr_a_out", "bf0_adr_a_out_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_adr_b_out", "bf0_adr_b_out_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_real_a_out", "bf0_real_a_out_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_imag_a_out", "bf0_imag_a_out_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_real_b_out", "bf0_real_b_out_spy", 1, -1);
        init_signal_spy("FFT_Transform_test_0/FFT_Transformer_0/bf0_imag_b_out", "bf0_imag_b_out_spy", 1, -1);
        wait;
    end process;

    p_write_data : process
        variable samples_var : time_sample_mem;
    begin
        -- WHY IS THE DPSRAM MEM INIT BROKEN
        init_done <= '0';
        A_wen_init <= '0';
        A_adr_init <= (others => '0');
        A_din_init <= (others => '0');
        wait until (NSYSRESET = '1');
        wait for (SYSCLK_PERIOD * 2);
        for i in 0 to TEST_SAMPLES'high loop
            A_wen_init <= '1';
            --A_adr_init <= (SAMPLE_CNT_EXP - 1 downto 0 => BIT_REV_FUNC(std_logic_vector(to_unsigned(i, SAMPLE_CNT_EXP))), others => '0');
            A_adr_init <= (8 - 1 downto 0 => std_logic_vector(to_unsigned(i, 8)), others => '0');
            A_din_init <= (TEST_SAMPLES(i)'high downto 0 => TEST_SAMPLES(i), others => '0');
            --case i is
            --    when 0 =>
            --        A_din_init <= (SAMPLE_WIDTH_INT - 1 downto 0 => std_logic_vector(to_signed(-1, SAMPLE_WIDTH_INT)), others => '0');
            --    when 1 =>
            --        A_din_init <= (SAMPLE_WIDTH_INT - 1 downto 0 => std_logic_vector(to_signed(-2, SAMPLE_WIDTH_INT)), others => '0');
            --    when others =>
            --        A_din_init <= (SAMPLE_WIDTH_INT - 1 downto 0 => std_logic_vector(to_signed(i, SAMPLE_WIDTH_INT)), others => '0');
            --end case;
            wait for (SYSCLK_PERIOD * 1);
        end loop;
        A_wen_init <= '0';
        init_done <= '1';
        report "RAM init done";
        wait;
    end process;

    A_WEN_0 <= ram_w_en_0(0) when init_done = '1' else A_wen_init;
    B_WEN_0 <= ram_w_en_0(1);
    A_ADDR_0 <= (ram_adr_0(0)'high downto 0 => ram_adr_0(0), others => '0') when init_done = '1' else A_adr_init;
    B_ADDR_0 <= (ram_adr_0(1)'high downto 0 => ram_adr_0(1), others => '0');
    A_DIN_0 <= ram_dat_w_0(0) when init_done = '1' else A_din_init;
    B_DIN_0 <= ram_dat_w_0(1) when init_done = '1' else (others => '0');
    ram_dat_r_0(0) <= A_DOUT_0 when init_done = '1' else (others => '0');
    ram_dat_r_0(1) <= B_DOUT_0 when init_done = '1' else (others => '0');

    A_DOUT_0_REAL <= A_DOUT_0(8 downto 0);
    A_DOUT_0_IMAG <= A_DOUT_0(17 downto 9);
    B_DOUT_0_REAL <= B_DOUT_0(8 downto 0);
    B_DOUT_0_IMAG <= B_DOUT_0(17 downto 9);


    A_WEN_1 <= ram_w_en_1(0);
    B_WEN_1 <= ram_w_en_1(1);
    A_ADDR_1 <= (ram_adr_1(0)'high downto 0 => ram_adr_1(0), others => '0');
    B_ADDR_1 <= (ram_adr_1(1)'high downto 0 => ram_adr_1(1), others => '0');
    A_DIN_1 <= ram_dat_w_1(0) when init_done = '1' else (others => '0');
    B_DIN_1 <= ram_dat_w_1(1) when init_done = '1' else (others => '0');
    ram_dat_r_1(0) <= A_DOUT_1 when init_done = '1' else (others => '0');
    ram_dat_r_1(1) <= B_DOUT_1 when init_done = '1' else (others => '0');
    --ram_dat_r_1(0) <= (others => '1');
    --ram_dat_r_1(1) <= (others => '1');

    A_DOUT_1_REAL <= A_DOUT_1(8 downto 0);
    A_DOUT_1_IMAG <= A_DOUT_1(17 downto 9);
    B_DOUT_1_REAL <= B_DOUT_1(8 downto 0);
    B_DOUT_1_IMAG <= B_DOUT_1(17 downto 9);

    p_test_transform : process
    begin
        ram_stable <= '0';
        ram_ready <= '0';
        ram_assigned <= '0';
        --ram_valid;
        wait until (init_done = '1');

        ram_stable <= '1';
        ram_ready <= '1';
        report "Transform has begun";

        wait until (ram_valid = '1');

        report "did it work?";
        
        wait;
    end process;

end behavioral;

