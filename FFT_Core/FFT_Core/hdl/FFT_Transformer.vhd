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

    stage_cnt
    bfly_cnt

    sampleA_adr
    sampleA_real
    sampleA_imag
    sampleB_adr
    sampleB_real
    sampleB_imag

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

    --=========================================================================

   -- architecture body
end architecture_FFT_Transformer;
