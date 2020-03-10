----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sat Mar  7 04:50:48 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Alpha_Max_plus_Beta_Min_tb.vhd
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

entity testbench is
end testbench;

architecture behavioral of testbench is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant dat_width : natural := 9;
    constant adr_width : natural := 8;

    component Alpha_Max_plus_Beta_Min
        generic (
            g_data_width : natural;
            g_adr_width : natural;
            g_adr_pipe : natural
        );
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            assoc_adr_in : in std_logic_vector(g_adr_width - 1 downto 0);
            val_A : in std_logic_vector(dat_width - 1 downto 0);
            val_B : in std_logic_vector(dat_width - 1 downto 0);
            in_valid : in std_logic;

            -- Outputs
            assoc_adr_out : out std_logic_vector(g_adr_width - 1 downto 0);
            o_flow : out std_logic;
            out_valid : out std_logic;
            result : out std_logic_vector(dat_width - 1 downto 0)

            -- Inouts

        );
    end component;

    signal assoc_adr_in : std_logic_vector(adr_width - 1 downto 0);
    signal val_A : std_logic_vector(dat_width - 1 downto 0);
    signal val_B : std_logic_vector(dat_width - 1 downto 0);
    signal in_valid : std_logic;
    signal out_valid : std_logic;
    signal assoc_adr_out : std_logic_vector(adr_width - 1 downto 0);
    signal o_flow : std_logic;
    signal result : std_logic_vector(dat_width - 1 downto 0);

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

    -- Instantiate Unit Under Test:  Alpha_Max_plus_Beta_Min
    Alpha_Max_plus_Beta_Min_0 : Alpha_Max_plus_Beta_Min
        generic map(
            g_data_width => dat_width,
            g_adr_width => adr_width,
            g_adr_pipe => 1
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            in_valid => in_valid,
            assoc_adr_in => assoc_adr_in,
            val_A => val_A,
            val_B => val_B,

            -- Outputs
            assoc_adr_out => assoc_adr_out,
            o_flow => o_flow,
            out_valid => out_valid,
            result => result

            -- Inouts

        );

    process
    begin
        assoc_adr_in <= (others => '0');
        val_A <= (others => '0');
        val_B <= (others => '0');
        in_valid <= '0';
        wait until (NSYSRESET = '1');


        for i in 0 to 31 loop

            wait for (SYSCLK_PERIOD * 1);

            assoc_adr_in <= std_logic_vector(to_signed(i, assoc_adr_in'length));

            case i is
                when 0 =>
                    val_A <= std_logic_vector(to_signed(0, val_A'length));
                    val_B <= std_logic_vector(to_signed(250, val_B'length));
                when 1 =>
                    val_A <= std_logic_vector(to_signed(250, val_A'length));
                    val_B <= std_logic_vector(to_signed(250, val_B'length));
                when 2 =>
                    val_A <= std_logic_vector(to_signed(1, val_A'length));
                    val_B <= std_logic_vector(to_signed(1, val_B'length));
                when 3 =>
                    val_A <= std_logic_vector(to_signed(-255, val_A'length));
                    val_B <= std_logic_vector(to_signed(-255, val_B'length));
                when others =>
                    val_A <= std_logic_vector(to_signed(i, val_A'length));
                    val_B <= std_logic_vector(to_signed(i, val_B'length));
            end case;

            in_valid <= '1';

            wait for (SYSCLK_PERIOD * 1);

            in_valid <= '0';
            
            if(out_valid /= '1') then
                wait until (out_valid = '1');
            end if;

            --wait for (SYSCLK_PERIOD * 4);

            report integer'image(to_integer(signed(result))) & " = abs(" &
                    integer'image(to_integer(signed(val_A))) & " + " &
                    integer'image(to_integer(signed(val_B))) & "i)" &
                    " Overflow: " & to_string(o_flow)
                    severity ERROR;
            
        end loop;

        wait;
    end process;

end behavioral;

