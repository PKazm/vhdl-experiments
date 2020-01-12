----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Mon Jan  6 19:17:08 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Core_tb.vhd
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

entity I2C_Core_tb is
end I2C_Core_tb;

architecture behavioral of I2C_Core_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    signal SDAI : std_logic := '0';
    signal SDAO : std_logic := '0';
    signal SDAE : std_logic := '0';
    signal SCLI : std_logic := '0';
    signal SCLO : std_logic := '0';
    signal SCLE : std_logic := '0';

    signal reg_update : std_logic := '0';

    signal ctrl_in : std_logic_vector(7 downto 0) := (others => '0');
    signal ctrl_out : std_logic_vector(7 downto 0) := (others => '0');
    signal data_in : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out : std_logic_vector(7 downto 0) := (others => '0');
    signal clk_div_in : std_logic_vector(15 downto 0) := (others => '0');
    signal clk_div_out : std_logic_vector(15 downto 0) := (others => '0');

    signal interrupt : std_logic := '0';

    signal i2c_status : std_logic_vector(1 downto 0);
    signal i2c_opcode : std_logic_vector(2 downto 0);


    type i2c_states is(idle, start, stop, data, rstart, ack);
    signal i2c_state_cur_spy : i2c_states;
    signal i2c_counter_spy : unsigned(1 downto 0);
    signal i2c_counter_pulse_spy : std_logic;
    signal state_started_spy : std_logic;
    signal bit_counter_spy : unsigned(2 downto 0);
    signal op_finished_spy : std_logic;

    component I2C_Core
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            reg_update : std_logic;
            ctrl_in : in std_logic_vector(7 downto 0);
            data_in : in std_logic_vector(7 downto 0);
            clk_div_in : in std_logic_vector(15 downto 0);
            SDAI : in std_logic;
            SCLI : in std_logic;

            -- Outputs
            ctrl_out : out std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0);
            clk_div_out : out std_logic_vector(15 downto 0);
            SDAO : out std_logic;
            SDAE : out std_logic;
            SCLO : out std_logic;
            SCLE : out std_logic;
            interrupt : out std_logic

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

    -- Instantiate Unit Under Test:  I2C_Core
    I2C_Core_0 : I2C_Core
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            reg_update => reg_update,
            ctrl_in => ctrl_in,
            data_in => data_in,
            clk_div_in => clk_div_in,
            SDAI => SDAI,
            SCLI => SCLI,

            -- Outputs
            ctrl_out => ctrl_out,
            data_out => data_out,
            clk_div_out => clk_div_out,
            SDAO => SDAO,
            SDAE => SDAE,
            SCLO => SCLO,
            SCLE => SCLE,
            interrupt => interrupt

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("I2C_Core_0/i2c_state_cur", "i2c_state_cur_spy", 1, -1);
        init_signal_spy("I2C_Core_0/i2c_counter", "i2c_counter_spy", 1, -1);
        init_signal_spy("I2C_Core_0/bit_counter", "bit_counter_spy", 1, -1);
        init_signal_spy("I2C_Core_0/i2c_counter_pulse", "i2c_counter_pulse_spy", 1, -1);
        init_signal_spy("I2C_Core_0/op_finished", "op_finished_spy", 1, -1);
        init_signal_spy("I2C_Core_0/state_started", "state_started_spy", 1, -1);
        wait;
    end process;

    process(SYSCLK)
    begin
        
    end process;
    i2c_status <= ctrl_out(6 downto 5);
    i2c_opcode <= ctrl_out(4 downto 2);

    The_stuff: process
    begin

        SDAI <= '1';
        SCLI <= '1';
        reg_update <= '0';
        ctrl_in <= (others => '0');
        data_in <= (others => '0');
        clk_div_in <= (others => '0');

        wait until(NSYSRESET = '1');

        -- Start command
        reg_update <= '1';

        ctrl_in <= "00000111";
        clk_div_in <= X"0080";

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';

        wait until ( interrupt = '1');

        -- Address
        reg_update <= '1';

        ctrl_in <= "00010011";
        data_in <= X"DE";

        SDAI <= '0';

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        
        wait until ( interrupt = '1');

        -- first byte
        reg_update <= '1';

        ctrl_in <= "00010011";
        data_in <= X"AD";
        SDAI <= '0';

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        
        wait until ( interrupt = '1');

        -- repeated start
        reg_update <= '1';

        ctrl_in <= "00001111";

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        
        wait until ( interrupt = '1');

        -- address for read
        reg_update <= '1';

        ctrl_in <= "00010011";
        data_in <= X"BE";
        -- ack fail
        SDAI <= '1';

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        
        wait until ( interrupt = '1');

        -- address for read again
        reg_update <= '1';

        ctrl_in <= "00010011";
        -- ack fail
        SDAI <= '0';

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        
        wait until ( interrupt = '1');

        -- read byte
        reg_update <= '1';

        ctrl_in <= "00010111";

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        

        SDAI <= '1';
        wait until (falling_edge(SCLO));
        SDAI <= '1';
        wait until (falling_edge(SCLO));
        SDAI <= '1';
        wait until (falling_edge(SCLO));
        SDAI <= '0';
        wait until (falling_edge(SCLO));
        SDAI <= '1';
        wait until (falling_edge(SCLO));
        SDAI <= '1';
        wait until (falling_edge(SCLO));
        SDAI <= '1';
        wait until (falling_edge(SCLO));
        SDAI <= '1';

        
        
        wait until ( interrupt = '1');

        -- stop
        reg_update <= '1';

        ctrl_in <= "00001011";

        wait for ( SYSCLK_PERIOD * 1);
        reg_update <= '0';
        
        wait until ( interrupt = '1');

        wait;

    end process;

end behavioral;

