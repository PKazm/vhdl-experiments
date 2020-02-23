----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Fri Feb 21 22:17:26 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Sample_Outputer_tb.vhd
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

entity FFT_Sample_Outputer_tb is
end FFT_Sample_Outputer_tb;

architecture behavioral of FFT_Sample_Outputer_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant SYNC_INPUT : natural := 1;
    constant BUFF_OUTPUT : natural := 1;

    signal output_en : std_logic;
    signal output_adr : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    signal output_real : std_logic_vector(SAMPLE_WIDTH_INT - 1 downto 0);
    signal output_imag : std_logic_vector(SAMPLE_WIDTH_INT - 1 downto 0);
    signal output_ready : std_logic;
    signal output_valid : std_logic;

    signal ram_stable : std_logic;
    signal ram_ready : std_logic;
    signal ram_valid : std_logic;
    signal ram_w_en : w_en_array_type;
    signal ram_adr : adr_array_type;
    signal ram_dat_w : ram_dat_array_type;
    signal ram_dat_r : ram_dat_array_type;


    -- signal spies
    signal output_en_sig_spy : std_logic;
    signal output_en_last_spy : std_logic;
    signal output_adr_sig_spy : std_logic_vector(SAMPLE_CNT_EXP - 1 downto 0);
    -- signal spies

    component FFT_Sample_Outputer
        generic (
            g_sync_input : natural;
            g_buffer_output : natural
        );
        -- ports
        port(
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

    -- Instantiate Unit Under Test:  FFT_Sample_Outputer
    FFT_Sample_Outputer_0 : FFT_Sample_Outputer
        generic map(
            g_sync_input => SYNC_INPUT,
            g_buffer_output => BUFF_OUTPUT
        )
        -- port map
        port map( 
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            -- connections to outside perif
            output_en => output_en,
            output_adr => output_adr,
            output_real => output_real,
            output_imag => output_imag,
            output_ready => output_ready,
            output_valid => output_valid,
            -- connections to outside perif


            -- connections to FFT RAM block
            ram_stable => ram_stable,
            ram_ready => ram_ready,
            ram_valid => ram_valid,
            ram_w_en => ram_w_en,
            ram_adr => ram_adr,
            ram_dat_w => ram_dat_w,
            ram_dat_r => ram_dat_r
        );

    spy_process : process
    begin
        init_signal_spy("FFT_Sample_Outputer_0/output_en_sig", "output_en_sig_spy", 1, -1);
        init_signal_spy("FFT_Sample_Outputer_0/output_en_last", "output_en_last_spy", 1, -1);
        init_signal_spy("FFT_Sample_Outputer_0/output_adr_sig", "output_adr_sig_spy", 1, -1);
        wait;
    end process;

    process
    begin
        output_en <= '0';
        output_adr <= (others => '0');
        ram_stable <= '0';
        ram_ready <= '0';
        ram_dat_r <= (others => (others =>'0'));
        
        wait until (NSYSRESET = '1');

        output_en <= '1';
        output_adr <= (others => '1');

        wait for (SYSCLK_PERIOD * 4);

        assert (output_real = "0" & X"00") report "RAM not stable error";

        ram_stable <= '1';

        wait for (SYSCLK_PERIOD * 1);

        assert (output_real = "0" & X"00") report "RAM not ready error";

        ram_ready <= '1';

        output_en <= '0';

        for i in 0 to SAMPLE_CNT loop
            
            wait for (SYSCLK_PERIOD * 1);
            output_en <= '1';
            output_adr <= std_logic_vector(to_unsigned(i, output_adr'length));
            ram_dat_r(0) <= std_logic_vector(to_unsigned(i, ram_dat_r(0)'length));
            wait until (output_en_sig_spy = '1');
            wait for (SYSCLK_PERIOD * 1);

            assert (ram_adr(0) = std_logic_vector(to_unsigned(i, ram_adr(0)'length))) report "RAM address error";
            assert (output_imag & output_real = ram_dat_r(0)) report "RAM data error";

            
            wait for (SYSCLK_PERIOD * 1);
            output_en <= '0';

        end loop;



        wait;
    end process;

end behavioral;

