----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Tue Feb 18 00:23:50 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Butterfly_HW_DSP_tb.vhd
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

library modelsim_lib;
use modelsim_lib.util.all;

entity Butterfly_HW_DSP_tb is
end Butterfly_HW_DSP_tb;

architecture behavioral of Butterfly_HW_DSP_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant SAMPLE_EXP : natural := 8;
    constant INTER_DAT_WIDTH : natural := 9;


    -- butterfly spies
    signal cos_twid_spy : std_logic_vector(8 downto 0);
    signal sin_twid_spy : std_logic_vector(8 downto 0);
    signal temp_real_spy : signed(17 downto 0);
    signal temp_real_trunc_spy : signed(INTER_DAT_WIDTH - 1 downto 0);
    signal temp_imag_spy : signed(34 downto 0);
    signal temp_imag_trunc_spy : signed(INTER_DAT_WIDTH - 1 downto 0);
    -- butterfly spies

    -- butterfly signals
    signal twiddle_index : std_logic_vector(6 downto 0);
    signal real_a_in : std_logic_vector(8 downto 0);
    signal imag_a_in : std_logic_vector(8 downto 0);
    signal real_b_in : std_logic_vector(8 downto 0);
    signal imag_b_in : std_logic_vector(8 downto 0);
    signal real_a_out : std_logic_vector(8 downto 0);
    signal imag_a_out : std_logic_vector(8 downto 0);
    signal real_b_out : std_logic_vector(8 downto 0);
    signal imag_b_out : std_logic_vector(8 downto 0);
    -- butterfly signals

    component Butterfly_HW_DSP
        generic (
            g_samples_exp : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            twiddle_index : in std_logic_vector(g_samples_exp - 2 downto 0);
            real_a_in : in std_logic_vector(8 downto 0);
            imag_a_in : in std_logic_vector(8 downto 0);
            real_b_in : in std_logic_vector(8 downto 0);
            imag_b_in : in std_logic_vector(8 downto 0);

            -- Outputs
            real_a_out : out std_logic_vector(8 downto 0);
            imag_a_out : out std_logic_vector(8 downto 0);
            real_b_out : out std_logic_vector(8 downto 0);
            imag_b_out : out std_logic_vector(8 downto 0)

            -- Inouts

        );
    end component;

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

    -- Instantiate Unit Under Test:  Butterfly_HW_DSP
    Butterfly_HW_DSP_0 : Butterfly_HW_DSP
        generic map(
            g_samples_exp => SAMPLE_EXP
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            twiddle_index => twiddle_index,
            real_a_in => real_a_in,
            imag_a_in => imag_a_in,
            real_b_in => real_b_in,
            imag_b_in => imag_b_in,

            -- Outputs
            real_a_out => real_a_out,
            imag_a_out => imag_a_out,
            real_b_out => real_b_out,
            imag_b_out => imag_b_out

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("Butterfly_HW_DSP_0/cos_twid", "cos_twid_spy", 1, -1);
        init_signal_spy("Butterfly_HW_DSP_0/sin_twid", "sin_twid_spy", 1, -1);
        init_signal_spy("Butterfly_HW_DSP_0/temp_real", "temp_real_spy", 1, -1);
        init_signal_spy("Butterfly_HW_DSP_0/temp_real_trunc", "temp_real_trunc_spy", 1, -1);
        init_signal_spy("Butterfly_HW_DSP_0/temp_imag", "temp_imag_spy", 1, -1);
        init_signal_spy("Butterfly_HW_DSP_0/temp_imag_trunc", "temp_imag_trunc_spy", 1, -1);
        wait;
    end process;

    process
    begin

        twiddle_index <= (others => '0');
        real_a_in <= (others => '0');
        imag_a_in <= (others => '0');
        real_b_in <= (others => '0');
        imag_b_in <= (others => '0');
        wait until (NSYSRESET = '1');

        twiddle_index <= std_logic_vector(to_unsigned(0, twiddle_index'length));
        real_a_in <= std_logic_vector(to_signed(255, real_a_in'length));
        imag_a_in <= std_logic_vector(to_signed(0, imag_a_in'length));
        real_b_in <= std_logic_vector(to_signed(255, real_b_in'length));
        imag_b_in <= std_logic_vector(to_signed(0, imag_b_in'length));
        
        wait for ( SYSCLK_PERIOD * 4 );

        report "rA: " & integer'image(to_integer(signed(real_a_out))) &
                ", iA: " & integer'image(to_integer(signed(imag_a_out))) &
                ", rB: " & integer'image(to_integer(signed(real_b_out))) &
                ", iB: " & integer'image(to_integer(signed(imag_b_out)));

        twiddle_index <= std_logic_vector(to_unsigned(0, twiddle_index'length));
        real_a_in <= std_logic_vector(to_signed(-2, real_a_in'length));
        imag_a_in <= std_logic_vector(to_signed(0, imag_a_in'length));
        real_b_in <= std_logic_vector(to_signed(-5, real_b_in'length));
        imag_b_in <= std_logic_vector(to_signed(0, imag_b_in'length));
        
        wait for ( SYSCLK_PERIOD * 4 );

        report "rA: " & integer'image(to_integer(signed(real_a_out))) &
                ", iA: " & integer'image(to_integer(signed(imag_a_out))) &
                ", rB: " & integer'image(to_integer(signed(real_b_out))) &
                ", iB: " & integer'image(to_integer(signed(imag_b_out)));

        twiddle_index <= std_logic_vector(to_unsigned(125, twiddle_index'length));
        real_a_in <= std_logic_vector(to_signed(9, real_a_in'length));
        imag_a_in <= std_logic_vector(to_signed(127, imag_a_in'length));
        real_b_in <= std_logic_vector(to_signed(0, real_b_in'length));
        imag_b_in <= std_logic_vector(to_signed(128, imag_b_in'length));

        wait for ( SYSCLK_PERIOD * 4 );
        
        report "rA: " & integer'image(to_integer(signed(real_a_out))) &
                ", iA: " & integer'image(to_integer(signed(imag_a_out))) &
                ", rB: " & integer'image(to_integer(signed(real_b_out))) &
                ", iB: " & integer'image(to_integer(signed(imag_b_out)));

        wait;
    end process;

end behavioral;

