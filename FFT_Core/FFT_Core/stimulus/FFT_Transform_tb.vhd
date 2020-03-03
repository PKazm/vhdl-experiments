----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Feb 27 22:57:16 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: FFT_Transform_tb.vhd
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
--use ieee.math_real.uniform;
--use ieee.math_real.floor;

use work.FFT_package.all;

library smartfusion2;
use smartfusion2.all;

--library modelsim_lib;
--use modelsim_lib.util.all;

entity FFT_Transform_tb is
end FFT_Transform_tb;

architecture behavioral of FFT_Transform_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';



    signal ram_stable : std_logic;
    signal ram_ready : std_logic;
    signal ram_valid : std_logic;
    signal ram_w_en : w_en_array_type;
    signal ram_adr : adr_array_type;
    signal ram_dat_w : ram_dat_array_type;
    signal ram_dat_r : ram_dat_array_type;

    component FFT_Transformer
        -- ports
        port( 
            PCLK : in std_logic;
            RSTn : in std_logic;

            ram_stable : in std_logic;
            ram_ready : in std_logic;

            ram_valid : out std_logic;

            ram_w_en : out w_en_array_type;
            ram_adr : out adr_array_type;
            ram_dat_w : out ram_dat_array_type;
            ram_dat_r : in ram_dat_array_type
        );
    end component;

    signal A_WEN : std_logic;
    signal B_WEN : std_logic;
    signal A_ADDR : std_logic_vector(9 downto 0);
    signal A_DIN : std_logic_vector(17 downto 0);
    signal B_ADDR : std_logic_vector(9 downto 0);
    signal B_DIN : std_logic_vector(17 downto 0);
    signal A_DOUT : std_logic_vector(17 downto 0);
    signal B_DOUT : std_logic_vector(17 downto 0);

    signal A_wen_init : std_logic;
    signal A_adr_init : std_logic_vector(9 downto 0);
    signal A_din_init : std_logic_vector(17 downto 0);
        
    component DPSRAM_C0
        port( 
            CLK : in std_logic;
            A_WEN : in std_logic;
            B_WEN : in std_logic;
            A_ADDR : in std_logic_vector(9 downto 0);
            A_DIN : in std_logic_vector(17 downto 0);
            B_ADDR : in std_logic_vector(9 downto 0);
            B_DIN : in std_logic_vector(17 downto 0);
            A_DOUT : out std_logic_vector(17 downto 0);
            B_DOUT : out std_logic_vector(17 downto 0)
        );
    end component;

    signal init_done : std_logic := '0';
    type 
    constant TEST_SAMPLES : time_sample_mem := (
            "0" & X"00" & std_logic_vector(to_signed(-10, 9)),
            "0" & X"00" & std_logic_vector(to_signed(108, 9)),
            "0" & X"00" & std_logic_vector(to_signed(7, 9)),
            "0" & X"00" & std_logic_vector(to_signed(64, 9)),
            "0" & X"00" & std_logic_vector(to_signed(-16, 9)),
            "0" & X"00" & std_logic_vector(to_signed(37, 9)),
            "0" & X"00" & std_logic_vector(to_signed(130, 9)),
            "0" & X"00" & std_logic_vector(to_signed(64, 9)),
            "0" & X"00" & std_logic_vector(to_signed(104, 9)),
            "0" & X"00" & std_logic_vector(to_signed(66, 9)),
            "0" & X"00" & std_logic_vector(to_signed(47, 9)),
            "0" & X"00" & std_logic_vector(to_signed(185, 9)),
            "0" & X"00" & std_logic_vector(to_signed(102, 9)),
            "0" & X"00" & std_logic_vector(to_signed(145, 9)),
            "0" & X"00" & std_logic_vector(to_signed(101, 9)),
            "0" & X"00" & std_logic_vector(to_signed(83, 9)),
            "0" & X"00" & std_logic_vector(to_signed(246, 9)),
            "0" & X"00" & std_logic_vector(to_signed(151, 9)),
            "0" & X"00" & std_logic_vector(to_signed(145, 9)),
            "0" & X"00" & std_logic_vector(to_signed(151, 9)),
            "0" & X"00" & std_logic_vector(to_signed(96, 9)),
            "0" & X"00" & std_logic_vector(to_signed(210, 9)),
            "0" & X"00" & std_logic_vector(to_signed(202, 9)),
            "0" & X"00" & std_logic_vector(to_signed(151, 9)),
            "0" & X"00" & std_logic_vector(to_signed(133, 9)),
            "0" & X"00" & std_logic_vector(to_signed(74, 9)),
            "0" & X"00" & std_logic_vector(to_signed(189, 9)),
            "0" & X"00" & std_logic_vector(to_signed(145, 9)),
            "0" & X"00" & std_logic_vector(to_signed(123, 9)),
            "0" & X"00" & std_logic_vector(to_signed(141, 9)),
            "0" & X"00" & std_logic_vector(to_signed(57, 9)),
            "0" & X"00" & std_logic_vector(to_signed(173, 9)),
            "0" & X"00" & std_logic_vector(to_signed(158, 9)),
            "0" & X"00" & std_logic_vector(to_signed(74, 9)),
            "0" & X"00" & std_logic_vector(to_signed(116, 9)),
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

    -- Instantiate Unit Under Test:  FFT_Transformer
    FFT_Transformer_0 : FFT_Transformer
        -- port map
        port map( 
            PCLK => SYSCLK,
            RSTn => NSYSRESET,

            -- connections to FFT RAM block
            ram_stable => ram_stable,
            ram_ready => ram_ready,
            ram_valid => ram_valid,
            ram_w_en => ram_w_en,
            ram_adr => ram_adr,
            ram_dat_w => ram_dat_w,
            ram_dat_r => ram_dat_r
            -- connections to FFT RAM block
        );
    
    DPSRAM_C0_0 : DPSRAM_C0
        port map(
            CLK => SYSCLK,
            A_WEN => A_WEN,
            B_WEN => B_WEN,
            A_ADDR => A_ADDR,
            A_DIN => A_DIN,
            B_ADDR => B_ADDR,
            B_DIN => B_DIN,
            A_DOUT => A_DOUT,
            B_DOUT => B_DOUT
        );



    spy_process : process
    begin
        --init_signal_spy("FFT_Butterfly_HW_MATHDSP_0/temp_real", "temp_real_spy", 1, -1);
        --init_signal_spy("FFT_Butterfly_HW_MATHDSP_0/temp_imag", "temp_imag_spy", 1, -1);
        --init_signal_spy("FFT_Butterfly_HW_MATHDSP_0/temp_real_trunc", "temp_real_trunc_spy", 1, -1);
        --init_signal_spy("FFT_Butterfly_HW_MATHDSP_0/temp_imag_trunc", "temp_imag_trunc_spy", 1, -1);
        wait;
    end process;


    p_write_data : process
        variable samples_var : time_sample_mem;
    begin
        -- WHY IS THE DPSRAM MEM INIT BROKEN
        init_done <= '0';
        A_wen_init <= '0';
        wait until (NSYSRESET = '1');
        for i in 0 to TEST_SAMPLES'high loop
            A_wen_init <= '1';
            A_adr_init <= (SAMPLE_CNT_EXP - 1 downto 0 => BIT_REV_FUNC(std_logic_vector(to_unsigned(i, SAMPLE_CNT_EXP))), others => '0');
            A_din_init <= TEST_SAMPLES(i);--(8 downto 0 => TEST_SAMPLES(i), others => '0');
            wait for (SYSCLK_PERIOD * 1);
        end loop;
        A_wen_init <= '0';
        init_done <= '1';
        report "RAM init done";
        wait;
    end process;

    A_WEN <= ram_w_en(0) when init_done = '1' else A_wen_init;
    B_WEN <= ram_w_en(1);
    A_ADDR <= (ram_adr(0)'high downto 0 => ram_adr(0), others => '0') when init_done = '1' else A_adr_init;
    B_ADDR <= (ram_adr(1)'high downto 0 => ram_adr(1), others => '0');
    A_DIN <= ram_dat_w(0) when init_done = '1' else A_din_init;
    B_DIN <= ram_dat_w(1);
    ram_dat_r(0) <= A_DOUT;
    ram_dat_r(1) <= B_DOUT;

    p_test_transform : process
    begin
        ram_stable <= '0';
        ram_ready <= '0';
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

