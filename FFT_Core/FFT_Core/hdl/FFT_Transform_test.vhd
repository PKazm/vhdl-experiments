----------------------------------------------------------------------
-- Created by SmartDesign Sun Mar  1 04:45:07 2020
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library work;
use work.FFT_package.all;
----------------------------------------------------------------------
-- FFT_Transform_test_sd entity declaration
----------------------------------------------------------------------

--entity FFT_Transform_test is
--    -- testbench ports
--    port(
--        PCLK         : in  std_logic;
--        RSTn         : in  std_logic;
--
--        A_WEN_0 : in std_logic;
--        B_WEN_0 : in std_logic;
--        A_DIN_0 : in std_logic_vector(17 downto 0);
--        A_ADDR_0 : in std_logic_vector(9 downto 0);
--        B_DIN_0 : in std_logic_vector(17 downto 0);
--        B_ADDR_0 : in std_logic_vector(9 downto 0);
--        A_DOUT_0 : out std_logic_vector(17 downto 0);
--        B_DOUT_0 : out std_logic_vector(17 downto 0);
--
--        A_WEN_1 : in std_logic;
--        B_WEN_1 : in std_logic;
--        A_DIN_1 : in std_logic_vector(17 downto 0);
--        A_ADDR_1 : in std_logic_vector(9 downto 0);
--        B_DIN_1 : in std_logic_vector(17 downto 0);
--        B_ADDR_1 : in std_logic_vector(9 downto 0);
--        A_DOUT_1 : out std_logic_vector(17 downto 0);
--        B_DOUT_1 : out std_logic_vector(17 downto 0);
--
--        ram_ready    : in  std_logic;
--        ram_stable   : in  std_logic;
--        ram_valid    : out std_logic;
--        ram_assigned : in  std_logic;
--        ram_returned : out std_logic;
--        ram_w_en_0 : out w_en_array_type;
--        ram_adr_0 : out adr_array_type;
--        ram_dat_w_0 : out ram_dat_array_type;
--        ram_dat_r_0 : in ram_dat_array_type;
--        ram_w_en_1 : out w_en_array_type;
--        ram_adr_1 : out adr_array_type;
--        ram_dat_w_1 : out ram_dat_array_type;
--        ram_dat_r_1 : in ram_dat_array_type
--        );
--end FFT_Transform_test;

entity FFT_Transform_test is
    -- synthesis ports
    port(
        PCLK         : in  std_logic;
        RSTn         : in  std_logic;

        A_DOUT_0 : out std_logic_vector(17 downto 0);
        B_DOUT_0 : out std_logic_vector(17 downto 0);

        A_DOUT_1 : out std_logic_vector(17 downto 0);
        B_DOUT_1 : out std_logic_vector(17 downto 0);

        ram_ready    : in  std_logic;
        ram_stable   : in  std_logic;
        ram_valid    : out std_logic;
        ram_assigned : in  std_logic;
        ram_returned : out std_logic
        );
end FFT_Transform_test;
----------------------------------------------------------------------
-- FFT_Transform_test_sd architecture body
----------------------------------------------------------------------
architecture RTL of FFT_Transform_test is
----------------------------------------------------------------------
-- constant declarations
----------------------------------------------------------------------
constant TESTBENCH_MODE : boolean := false;
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- DPSRAM_C0
component DPSRAM_C0
    -- Port list
    port(
        -- Inputs
        A_ADDR : in  std_logic_vector(9 downto 0);
        A_DIN  : in  std_logic_vector(17 downto 0);
        A_WEN  : in  std_logic;
        B_ADDR : in  std_logic_vector(9 downto 0);
        B_DIN  : in  std_logic_vector(17 downto 0);
        B_WEN  : in  std_logic;
        CLK    : in  std_logic;
        -- Outputs
        A_DOUT : out std_logic_vector(17 downto 0);
        B_DOUT : out std_logic_vector(17 downto 0)
        );
end component;
-- FFT_Transformer
component FFT_Transformer
    -- Port list
    port(
        -- Inputs
        PCLK             : in  std_logic;
        RSTn             : in  std_logic;
        ram_assigned     : in  std_logic;
        ram_dat_r_0      : in  ram_dat_array_type;
        ram_dat_r_1      : in  ram_dat_array_type;
        ram_ready        : in  std_logic;
        ram_stable       : in  std_logic;
        -- Outputs
        ram_adr_0       : out adr_array_type;
        ram_adr_1       : out adr_array_type;
        ram_dat_w_0     : out ram_dat_array_type;
        ram_dat_w_1     : out ram_dat_array_type;
        ram_returned     : out std_logic;
        ram_valid        : out std_logic;
        ram_w_en_0       : out w_en_array_type;
        ram_w_en_1       : out w_en_array_type
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal A_WEN_0_sig : std_logic;
signal B_WEN_0_sig : std_logic;
signal A_DIN_0_sig : std_logic_vector(17 downto 0);
signal A_ADDR_0_sig : std_logic_vector(9 downto 0);
signal B_DIN_0_sig : std_logic_vector(17 downto 0);
signal B_ADDR_0_sig : std_logic_vector(9 downto 0);
signal A_DOUT_0_sig : std_logic_vector(17 downto 0);
signal B_DOUT_0_sig : std_logic_vector(17 downto 0);

signal A_WEN_1_sig : std_logic;
signal B_WEN_1_sig : std_logic;
signal A_DIN_1_sig : std_logic_vector(17 downto 0);
signal A_ADDR_1_sig : std_logic_vector(9 downto 0);
signal B_DIN_1_sig : std_logic_vector(17 downto 0);
signal B_ADDR_1_sig : std_logic_vector(9 downto 0);
signal A_DOUT_1_sig : std_logic_vector(17 downto 0);
signal B_DOUT_1_sig : std_logic_vector(17 downto 0);

signal ram_ready_sig    :  std_logic;
signal ram_stable_sig   :  std_logic;
signal ram_valid_sig    :  std_logic;
signal ram_assigned_sig :  std_logic;
signal ram_returned_sig :  std_logic;
signal ram_w_en_0_sig   :  w_en_array_type;
signal ram_adr_0_sig    :  adr_array_type;
signal ram_dat_w_0_sig  :  ram_dat_array_type;
signal ram_dat_r_0_sig  : ram_dat_array_type;
signal ram_w_en_1_sig   :  w_en_array_type;
signal ram_adr_1_sig    :  adr_array_type;
signal ram_dat_w_1_sig  :  ram_dat_array_type;
signal ram_dat_r_1_sig  : ram_dat_array_type;

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Top level to signal assignments
----------------------------------------------------------------------
--gen_testbench_mode_true : if(TESTBENCH_MODE = true) generate
--    A_WEN_0_sig     <=  A_WEN_0;
--    B_WEN_0_sig     <=  B_WEN_0;
--    A_DIN_0_sig     <=  A_DIN_0;
--    A_ADDR_0_sig    <=  A_ADDR_0;
--    B_DIN_0_sig     <=  B_DIN_0;
--    B_ADDR_0_sig    <=  B_ADDR_0;
--    A_DOUT_0        <=  A_DOUT_0_sig;
--    B_DOUT_0        <=  B_DOUT_0_sig;
--
--    A_WEN_1_sig     <=  A_WEN_1;
--    B_WEN_1_sig     <=  B_WEN_1;
--    A_DIN_1_sig     <=  A_DIN_1;
--    A_ADDR_1_sig    <=  A_ADDR_1;
--    B_DIN_1_sig     <=  B_DIN_1;
--    B_ADDR_1_sig    <=  B_ADDR_1;
--    A_DOUT_1        <=  A_DOUT_1_sig;
--    B_DOUT_1        <=  B_DOUT_1_sig;
--
--    ram_ready_sig       <=  ram_ready;
--    ram_stable_sig      <=  ram_stable;
--    ram_valid           <=  ram_valid_sig;
--    ram_assigned_sig    <=  ram_assigned;
--    ram_returned        <=  ram_returned_sig;
--
--    ram_w_en_0          <=  ram_w_en_0_sig;
--    ram_adr_0           <=  ram_adr_0_sig;
--    ram_dat_w_0         <=  ram_dat_w_0_sig;
--    ram_dat_r_0_sig     <=  ram_dat_r_0;
--
--    ram_w_en_1          <=  ram_w_en_1_sig;
--    ram_adr_1           <=  ram_adr_1_sig;
--    ram_dat_w_1         <=  ram_dat_w_1_sig;
--    ram_dat_r_1_sig     <=  ram_dat_r_1;
--end generate gen_testbench_mode_true;

gen_testbench_mode_false : if(TESTBENCH_MODE = false) generate
    A_WEN_0_sig     <=  ram_w_en_0_sig(0);
    B_WEN_0_sig     <=  ram_w_en_0_sig(1);
    A_DIN_0_sig     <=  ram_dat_w_0_sig(0);
    A_ADDR_0_sig    <=  (ram_adr_0_sig(0)'high downto 0 => ram_adr_0_sig(0), others => '0');
    B_DIN_0_sig     <=  ram_dat_w_0_sig(1);
    B_ADDR_0_sig    <=  (ram_adr_0_sig(1)'high downto 0 => ram_adr_0_sig(1), others => '0');
    ram_dat_r_0_sig(0)        <=  A_DOUT_0_sig;
    ram_dat_r_0_sig(1)        <=  B_DOUT_0_sig;

    A_WEN_1_sig     <=  ram_w_en_1_sig(0);
    B_WEN_1_sig     <=  ram_w_en_1_sig(1);
    A_DIN_1_sig     <=  ram_dat_w_1_sig(0);
    A_ADDR_1_sig    <=  (ram_adr_1_sig(0)'high downto 0 => ram_adr_1_sig(0), others => '0');
    B_DIN_1_sig     <=  ram_dat_w_1_sig(1);
    B_ADDR_1_sig    <=  (ram_adr_1_sig(1)'high downto 0 => ram_adr_1_sig(1), others => '0');
    ram_dat_r_1_sig(0)        <=  A_DOUT_1_sig;
    ram_dat_r_1_sig(1)        <=  B_DOUT_1_sig;

    ram_ready_sig       <=  ram_ready;
    ram_stable_sig      <=  ram_stable;
    ram_valid           <=  ram_valid_sig;
    ram_assigned_sig    <=  ram_assigned;
    ram_returned        <=  ram_returned_sig;

    --A_WEN_0     <= open;
    --B_WEN_0     <= open;
    --A_DIN_0     <= open;
    --A_ADDR_0    <= open;
    --B_DIN_0     <= open;
    --B_ADDR_0    <= open;
    A_DOUT_0    <= A_DOUT_0_sig;
    B_DOUT_0    <= B_DOUT_0_sig;

    --A_WEN_1     <= open;
    --B_WEN_1     <= open;
    --A_DIN_1     <= open;
    --A_ADDR_1    <= open;
    --B_DIN_1     <= open;
    --B_ADDR_1    <= open;
    A_DOUT_1    <= A_DOUT_1_sig;
    B_DOUT_1    <= B_DOUT_1_sig;

    --ram_w_en_0          <=  (others => '0');
    --ram_adr_0           <=  (others => (others => '0'));
    --ram_dat_w_0         <=  (others => (others => '0'));
    --ram_dat_r_0_sig     <=  open;

    --ram_w_en_1          <=  (others => '0');
    --ram_adr_1           <=  (others => (others => '0'));
    --ram_dat_w_1         <=  (others => (others => '0'));
    --ram_dat_r_1_sig     <=  open;
end generate gen_testbench_mode_false;

----------------------------------------------------------------------
-- Slices assignments
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Concatenation assignments
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- DPSRAM_C0_0
DPSRAM_C0_0 : DPSRAM_C0
    port map( 
        -- Inputs
        CLK    => PCLK,
        A_WEN  => A_WEN_0_sig,
        B_WEN  => B_WEN_0_sig,
        A_DIN  => A_DIN_0_sig,
        A_ADDR => A_ADDR_0_sig,
        B_DIN  => B_DIN_0_sig,
        B_ADDR => B_ADDR_0_sig,
        -- Outputs
        A_DOUT => A_DOUT_0_sig,
        B_DOUT => B_DOUT_0_sig 
        );
-- DPSRAM_C0_1
DPSRAM_C0_1 : DPSRAM_C0
    port map( 
        -- Inputs
        CLK    => PCLK,
        A_WEN  => A_WEN_1_sig,
        B_WEN  => B_WEN_1_sig,
        A_DIN  => A_DIN_1_sig,
        A_ADDR => A_ADDR_1_sig,
        B_DIN  => B_DIN_1_sig,
        B_ADDR => B_ADDR_1_sig,
        -- Outputs
        A_DOUT => A_DOUT_1_sig,
        B_DOUT => B_DOUT_1_sig 
        );
-- FFT_Transformer_0
FFT_Transformer_0 : FFT_Transformer
    port map( 
        -- Inputs
        PCLK             => PCLK,
        RSTn             => RSTn,
        ram_stable       => ram_stable_sig,
        ram_ready        => ram_ready_sig,
        ram_assigned     => ram_assigned_sig,
        ram_dat_r_0     => ram_dat_r_0_sig,
        ram_dat_r_1     => ram_dat_r_1_sig,
        -- Outputs
        ram_returned     => ram_returned_sig,
        ram_valid        => ram_valid_sig,
        ram_w_en_0       => ram_w_en_0_sig,
        ram_adr_0       => ram_adr_0_sig,
        ram_dat_w_0     => ram_dat_w_0_sig,
        ram_w_en_1       => ram_w_en_1_sig,
        ram_adr_1       => ram_adr_1_sig,
        ram_dat_w_1     => ram_dat_w_1_sig
        );

end RTL;
