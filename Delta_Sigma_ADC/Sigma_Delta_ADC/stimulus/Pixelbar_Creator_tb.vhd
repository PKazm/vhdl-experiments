----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Feb  3 19:05:00 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Pixelbar_Creator_tb.vhd
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

entity Pixelbar_Creator_tb is
end Pixelbar_Creator_tb;

architecture behavioral of Pixelbar_Creator_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    
    constant CON_DATA_BITS : natural := 8;
    constant CON_PIX_PER_REG : natural := 8;
    constant CON_PIX_NUM_REG : natural := 2;

    constant CON_PIXELS_TOTAL : natural := (CON_PIX_PER_REG * CON_PIX_NUM_REG);


    signal Data_in_ready : std_logic := '0';
    signal Data_in : std_logic_vector(CON_DATA_BITS - 1 downto 0) := (others => '0');
    signal Pixel_bar_out : std_logic_vector(CON_PIXELS_TOTAL - 1 downto 0) := (others => '0');
    signal Data_out_ready : std_logic := '0';


    component Pixelbar_Creator
        generic (
            g_pixel_registers : natural;
            g_pixel_register_size : natural;
            g_data_in_bits : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            Data_in_ready : in std_logic;
            Data_in : in std_logic_vector(CON_DATA_BITS - 1 downto 0);
            PADDR : in std_logic_vector(7 downto 0);
            PSEL : in std_logic;
            PENABLE : in std_logic;
            PWRITE : in std_logic;
            PWDATA : in std_logic_vector(7 downto 0);

            -- Outputs
            Pixel_bar_out : out std_logic_vector(CON_PIXELS_TOTAL - 1 downto 0);
            Data_out_ready : out std_logic;
            PREADY : out std_logic;
            PRDATA : out std_logic_vector(7 downto 0);
            PSLVERR : out std_logic;
            INT : out std_logic

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

    -- Instantiate Unit Under Test:  Pixelbar_Creator
    Pixelbar_Creator_0 : Pixelbar_Creator
        generic map(
            g_pixel_registers => CON_PIX_NUM_REG,
            g_pixel_register_size => CON_PIX_PER_REG,
            g_data_in_bits => CON_DATA_BITS
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            Data_in_ready => Data_in_ready,
            Data_in => Data_in,
            PADDR => (others=> '0'),
            PSEL => '0',
            PENABLE => '0',
            PWRITE => '0',
            PWDATA => (others=> '0'),

            -- Outputs
            Pixel_bar_out => Pixel_bar_out,
            Data_out_ready =>  Data_out_ready,
            PREADY =>  open,
            PRDATA => open,
            PSLVERR =>  open,
            INT =>  open

            -- Inouts

        );

    THE_STUFF : process
    begin
        Data_in <= std_logic_vector(unsigned(Data_in) + 1);
        Data_in_ready <= '1';
        wait for ( SYSCLK_PERIOD * 20);
        Data_in_ready <= '0';
        wait for ( SYSCLK_PERIOD * 1);
    end process;

end behavioral;

