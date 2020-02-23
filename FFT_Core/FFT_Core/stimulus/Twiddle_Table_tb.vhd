----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Fri Feb 21 15:56:03 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Twiddle_Table_tb.vhd
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

entity Twiddle_Table_tb is
end Twiddle_Table_tb;

architecture behavioral of Twiddle_Table_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant USE_BRAM : natural := 1;
    constant TWIDDLE_CNT_EXP : natural := 8;
    constant TWIDDLE_CNT : natural := 2**TWIDDLE_CNT_EXP;


    signal twiddle_index : std_logic_vector(TWIDDLE_CNT_EXP - 1 downto 0);
    signal twiddle_ready : std_logic;
    signal cos_twid : std_logic_vector(8 downto 0);
    signal cos_twid_1comp : std_logic_vector(8 downto 0);
    signal sin_twid : std_logic_vector(8 downto 0);
    signal sin_twid_1comp : std_logic_vector(8 downto 0);

    component Twiddle_table
        generic (
            g_data_samples_exp : natural;
            g_use_BRAM : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            twiddle_index : in std_logic_vector(g_data_samples_exp - 2 downto 0);

            -- Outputs
            twiddle_ready : out std_logic;
            cos_twid : out std_logic_vector(8 downto 0);
            cos_twid_1comp : out std_logic_vector(8 downto 0);
            sin_twid : out std_logic_vector(8 downto 0);
            sin_twid_1comp : out std_logic_vector(8 downto 0)

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

    -- Instantiate Unit Under Test:  Twiddle_table
    Twiddle_table_0 : Twiddle_table
        generic map(
            g_data_samples_exp => TWIDDLE_CNT_EXP + 1,
            g_use_BRAM => USE_BRAM
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            twiddle_index => twiddle_index,

            -- Outputs
            twiddle_ready => twiddle_ready,
            cos_twid => cos_twid,
            cos_twid_1comp => cos_twid_1comp,
            sin_twid => sin_twid,
            sin_twid_1comp => sin_twid_1comp

            -- Inouts

        );

    spy_process : process
    begin
        --init_signal_spy("Butterfly_HW_DSP_0/cos_twid", "cos_twid_spy", 1, -1);
        --init_signal_spy("Butterfly_HW_DSP_0/sin_twid", "sin_twid_spy", 1, -1);
        --init_signal_spy("Butterfly_HW_DSP_0/temp_real", "temp_real_spy", 1, -1);
        --init_signal_spy("Butterfly_HW_DSP_0/temp_real_trunc", "temp_real_trunc_spy", 1, -1);
        --init_signal_spy("Butterfly_HW_DSP_0/temp_imag", "temp_imag_spy", 1, -1);
        --init_signal_spy("Butterfly_HW_DSP_0/temp_imag_trunc", "temp_imag_trunc_spy", 1, -1);
        wait;
    end process;
    
    process
    begin

        twiddle_index <= (others => '0');
        wait until (twiddle_ready = '1' and NSYSRESET = '1');
        identifier : for i in 0 to TWIDDLE_CNT loop
            twiddle_index <= std_logic_vector(to_unsigned(i, twiddle_index'length));
            wait for ( SYSCLK_PERIOD * 1 );
            report integer'image(to_integer(signed(cos_twid))) & ", " & integer'image(to_integer(signed(sin_twid)));
        end loop ; -- identifier

        wait;
    end process;

end behavioral;

