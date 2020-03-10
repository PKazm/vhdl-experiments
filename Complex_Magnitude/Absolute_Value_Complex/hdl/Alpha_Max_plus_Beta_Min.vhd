--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Alpha_Max_plus_Beta_Min.vhd
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

entity Alpha_Max_plus_Beta_Min is
generic (
    g_data_width : natural := 8;
    g_adr_width : natural := 8;
    g_adr_pipe : natural := 1
    --g_buffer_input : natural := 1
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    assoc_adr_in : in std_logic_vector(g_adr_width - 1 downto 0);
    val_A : in std_logic_vector(g_data_width - 1 downto 0);
    val_B : in std_logic_vector(g_data_width - 1 downto 0);
    in_valid : in std_logic;

    assoc_adr_out : out std_logic_vector(g_adr_width - 1 downto 0);
    o_flow : out std_logic;
    out_valid : out std_logic;
    result : out std_logic_vector(g_data_width - 1 downto 0)
);
end Alpha_Max_plus_Beta_Min;
architecture architecture_Alpha_Max_plus_Beta_Min of Alpha_Max_plus_Beta_Min is

    constant PIPE_LENGTH : natural := 5;

    constant alpha : std_logic_vector(8 downto 0) := "0" & X"F5";    -- 245 ~= 0.96043 * (2^8 - 1)
    constant beta : std_logic_vector(8 downto 0) := "0" & X"65";     -- 101 ~= 0.39782 * (2^8 - 1)

    type adr_type is array(PIPE_LENGTH - 1 downto 0) of std_logic_vector(g_adr_width - 1 downto 0);
    signal adr_pipe : adr_type;

    signal val_A_sig : std_logic_vector(g_data_width - 1 downto 0);
    signal val_B_sig : std_logic_vector(g_data_width - 1 downto 0);
    
    signal in_valid_sig : std_logic;
    signal valid_pipe : std_logic_vector(PIPE_LENGTH - 1 downto 0);
    signal out_valid_sig : std_logic;

    signal o_flow_sig : std_logic;

    signal val_A_pos : std_logic_vector(g_data_width - 1 downto 0);
    signal val_B_pos : std_logic_vector(g_data_width - 1 downto 0);

    signal val_max : std_logic_vector(g_data_width - 1 downto 0);
    signal val_min : std_logic_vector(g_data_width - 1 downto 0);

    -- sets division of Math block output
    constant TRUNC_BIT_HIGH : natural := 17;

    signal mult_result : std_logic_vector(34 downto 0);
    signal mult_result_slice : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal mult_result_rnd_bias : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);
    signal mult_result_rnd_slice_bias : std_logic_vector(TRUNC_BIT_HIGH + 1 downto 0);

    --component HARD_MULT_ADDSUB_C0
    --    -- Port list
    --    port(
    --        -- Inputs
    --        A0    : in  std_logic_vector(8 downto 0);
    --        A1    : in  std_logic_vector(8 downto 0);
    --        B0    : in  std_logic_vector(8 downto 0);
    --        B1    : in  std_logic_vector(8 downto 0);
    --        C     : in  std_logic_vector(34 downto 0);
    --        -- Outputs
    --        CDOUT : out std_logic_vector(43 downto 0);
    --        P     : out std_logic_vector(34 downto 0)
    --        );
    --end component;

    component HARD_MULT_ADDSUB_C1
        -- Port list
        port(
            -- Inputs
            CLK : in std_logic;
            P_ACLR_N : in std_logic;
            P_SCLR_N : in std_logic;
            P_EN : in std_logic;
            A0    : in  std_logic_vector(8 downto 0);
            A1    : in  std_logic_vector(8 downto 0);
            B0    : in  std_logic_vector(8 downto 0);
            B1    : in  std_logic_vector(8 downto 0);
            C     : in  std_logic_vector(34 downto 0);
            -- Outputs
            CDOUT : out std_logic_vector(43 downto 0);
            P     : out std_logic_vector(34 downto 0)
            );
    end component;

begin

    --val_A_sig <= val_A;
    --val_B_sig <= val_B;

    in_valid_sig <= in_valid;
    out_valid <= out_valid_sig;

    out_valid_sig <= valid_pipe(valid_pipe'high);
    
    gen_adr_pipe : if(g_adr_pipe /= 0) generate
        process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                adr_pipe <= (others => (others => '0'));
            elsif(rising_edge(PCLK)) then
                adr_pipe(0) <= assoc_adr_in;
                for i in 1 to adr_pipe'high loop
                    adr_pipe(i) <= adr_pipe(i - 1);
                end loop;
            end if;
        end process;

        assoc_adr_out <= adr_pipe(adr_pipe'high);
    end generate;


    process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            valid_pipe <= (others => '0');
            val_A_sig <= (others => '0');
            val_B_sig <= (others => '0');
            val_A_pos <= (others => '0');
            val_B_pos <= (others => '0');
            val_max <= (others => '0');
            val_min <= (others => '0');
            result <= (others => '0');
            o_flow_sig <= '0';
        elsif(rising_edge(PCLK)) then
            valid_pipe(0) <= in_valid_sig;
            for i in 1 to valid_pipe'high loop
                valid_pipe(i) <= valid_pipe(i - 1);
            end loop;
            val_A_sig <= val_A;
            val_B_sig <= val_B;

            val_A_pos <= val_A_sig when signed(val_A_sig) > 0 else std_logic_vector(signed(not val_A_sig) + 1);
            val_B_pos <= val_B_sig when signed(val_B_sig) > 0 else std_logic_vector(signed(not val_B_sig) + 1);

            val_max <= val_A_pos when val_A_pos > val_B_pos else val_B_pos;
            val_min <= val_A_pos when val_A_pos < val_B_pos else val_B_pos;
            
            result <= mult_result_rnd_slice_bias(mult_result_rnd_slice_bias'high) &
                        mult_result_rnd_slice_bias(mult_result_rnd_slice_bias'high - 3 downto mult_result_rnd_slice_bias'high - result'length - 1);
            o_flow_sig <= (mult_result_rnd_slice_bias(mult_result_rnd_slice_bias'high) xor mult_result_rnd_slice_bias(mult_result_rnd_slice_bias'high - 1)) or
                        (mult_result_rnd_slice_bias(mult_result_rnd_slice_bias'high) xor mult_result_rnd_slice_bias(mult_result_rnd_slice_bias'high - 2));
        end if;
    end process;

    --HARD_MULT_ADDSUB_C0_0 : HARD_MULT_ADDSUB_C0
    --port map( 
    --    -- Inputs
    --    A0    => (val_max'high downto 0 => val_max, others => val_max(val_max'high)),
    --    B0    => alpha,
    --    A1    => (val_min'high downto 0 => val_min, others => val_min(val_min'high)),
    --    B1    => beta,
    --    C     => (others => '0'),
    --    -- Outputs
    --    CDOUT => OPEN,
    --    P     => mult_result
    --    );

    HARD_MULT_ADDSUB_C1_0 : HARD_MULT_ADDSUB_C1
    port map( 
        -- Inputs
        CLK     => PCLK,
        P_ACLR_N  => RSTn,
        P_SCLR_N  => '1',
        P_EN      => '1',
        A0    => (val_max'high downto 0 => val_max, others => val_max(val_max'high)),
        B0    => alpha,
        A1    => (val_min'high downto 0 => val_min, others => val_min(val_min'high)),
        B1    => beta,
        C     => (others => '0'),
        -- Outputs
        CDOUT => OPEN,
        P     => mult_result
        );

    mult_result_slice <= mult_result(mult_result'high) & mult_result(mult_result_slice'length - 2 downto 0);
    mult_result_rnd_bias <= RND_HALF_TO_EVEN_BIAS_GEN(mult_result_slice, 11);
    mult_result_rnd_slice_bias <= std_logic_vector(signed(mult_result_slice) + signed(mult_result_rnd_bias));

    

    o_flow <= o_flow_sig;

   -- architecture body
end architecture_Alpha_Max_plus_Beta_Min;
