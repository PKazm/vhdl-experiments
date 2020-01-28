----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Tue Jan 14 15:47:59 2020
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

    -- i2c signals
    signal SDAI : std_logic := '0';
    signal SDAO : std_logic := '0';
    signal SDAE : std_logic := '0';
    signal SCLI : std_logic := '0';
    signal SCLO : std_logic := '0';
    signal SCLE : std_logic := '0';
    -- i2c signals

    signal SDA_slave : std_logic := '1';
    signal SCL_slave : std_logic := '1';

    -- i2c inputs
    signal i2c_initiate : std_logic := '0';
    signal i2c_instruction : std_logic_vector(2 downto 0) := (others => '0');
    signal i2c_clock_div : std_logic_vector(15 downto 0) := (others => '0');
    signal data_in : std_logic_vector(7 downto 0) := (others => '0');
    -- i2c inputs

    -- i2c outputs
    signal i2c_bus_busy : std_logic := '0';
    signal i2c_status : std_logic_vector(1 downto 0) := (others => '0');
    signal i2c_int : std_logic := '0';
    signal data_out : std_logic_vector(7 downto 0);
    -- i2c outputs


    type i2c_states is(idle,
                        start0, start1, start2, start3,
                        stop0, stop1, stop2, stop3,
                        rstart0, rstart1, rstart2, rstart3,
                        data0, data1, data2, data3,
                        ack0, ack1, ack2, ack3);
    signal i2c_state_cur_spy : i2c_states;

    signal i2c_clk_pulse_spy : std_logic := '0';
    signal state_handshake_spy : std_logic := '0';
    signal bit_to_SDA_spy : std_logic := '0';
    signal i2c_read_reg_spy : std_logic_vector(8 downto 0) := (others => '0');
    constant FILT_LENGTH_CONST : natural := 3;
    signal SDA_filt_spy : std_logic_vector(FILT_LENGTH_CONST - 1 downto 0) := (others => '0');
    signal SCL_filt_spy : std_logic_vector(FILT_LENGTH_CONST - 1 downto 0) := (others => '0');
    signal SDAI_sig_history_spy : std_logic_vector(1 downto 0) := (others => '0');
    signal SCLI_sig_history_spy : std_logic_vector(1 downto 0) := (others => '0');
    signal bit_counter_spy : unsigned(2 downto 0) := (others => '1');
    signal did_ack_spy : std_logic := '0';

    component I2C_Core
        generic (
            g_filter_length : natural := 3
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            initiate : in std_logic;
            instruct : in std_logic_vector(2 downto 0);
            clk_div_in : in std_logic_vector(15 downto 0);
            SDAI : in std_logic;
            SCLI : in std_logic;

            -- Outputs
            data_out : out std_logic_vector(7 downto 0);
            i2c_bus_busy : out std_logic;
            status_out : out std_logic_vector(1 downto 0);
            i2c_int : out std_logic;
            SDAO : out std_logic;
            SDAE : out std_logic;
            SCLO : out std_logic;
            SCLE : out std_logic

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
        generic map(
            g_filter_length => FILT_LENGTH_CONST
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            data_in => data_in,
            initiate => i2c_initiate,
            instruct => i2c_instruction,
            clk_div_in => i2c_clock_div,
            SDAI => SDAI,
            SCLI => SCLI,

            -- Outputs
            data_out => data_out,
            i2c_bus_busy =>  i2c_bus_busy,
            status_out => i2c_status,
            i2c_int =>  i2c_int,
            SDAO =>  SDAO,
            SDAE =>  SDAE,
            SCLO =>  SCLO,
            SCLE =>  SCLE

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("I2C_Core_0/i2c_state_cur", "i2c_state_cur_spy", 1, -1);
        init_signal_spy("I2C_Core_0/i2c_clk_pulse", "i2c_clk_pulse_spy", 1, -1);
        init_signal_spy("I2C_Core_0/state_handshake", "state_handshake_spy", 1, -1);
        init_signal_spy("I2C_Core_0/bit_to_SDA", "bit_to_SDA_spy", 1, -1);
        init_signal_spy("I2C_Core_0/i2c_read_reg", "i2c_read_reg_spy", 1, -1);
        init_signal_spy("I2C_Core_0/SDA_filt", "SDA_filt_spy", 1, -1);
        init_signal_spy("I2C_Core_0/SCL_filt", "SCL_filt_spy", 1, -1);
        init_signal_spy("I2C_Core_0/SDAI_sig_history", "SDAI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Core_0/SCLI_sig_history", "SCLI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Core_0/bit_counter", "bit_counter_spy", 1, -1);
        init_signal_spy("I2C_Core_0/did_ack", "did_ack_spy", 1, -1);
        wait;
    end process;

    SDAI <= SDAO when SDAE = '1' else SDA_slave;
    SCLI <= SCLO when SCLE = '1' else SCL_slave;

    THE_STUFF : process
    begin
        -- do reset stuff
        i2c_initiate <= '0';
        i2c_instruction <= (others => '0');
        i2c_clock_div <= X"0080";
        data_in <= X"DE";
        wait until(NSYSRESET = '1');

        -- start i2c packet
        i2c_instruction <= "001";
        i2c_initiate <= '1';

        wait until ( i2c_int = '1');

        -- send address
        i2c_instruction <= "100";
        data_in <= "10101010";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until ( did_ack_spy = '1');
        SDA_slave <= '0';   -- ack
        wait until ( i2c_int = '1');
        SDA_slave <= '1';

        -- send register
        i2c_instruction <= "100";
        data_in <= X"AD";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until ( did_ack_spy = '1');
        SDA_slave <= '1';   -- non ack
        wait until ( i2c_int = '1');
        SDA_slave <= '1';

        -- resend register
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until ( did_ack_spy = '1');
        SDA_slave <= '0';   -- ack
        wait until ( i2c_int = '1');
        SDA_slave <= '1';

        -- send repeated start
        i2c_instruction <= "011";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until ( i2c_int = '1');

        -- send address with read
        i2c_instruction <= "100";
        data_in <= "10101011";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until ( did_ack_spy = '1');
        SDA_slave <= '0';   -- ack
        wait until ( i2c_int = '1');
        SDA_slave <= '1';

        -- read sda data
        i2c_instruction <= "101";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        SDA_slave <= '1';
        wait until (rising_edge(SCLE));
        SDA_slave <= '1';
        wait until (rising_edge(SCLE));
        SDA_slave <= '1';
        wait until (rising_edge(SCLE));
        SDA_slave <= '0';
        wait until (rising_edge(SCLE));
        SDA_slave <= '1';
        wait until (rising_edge(SCLE));
        SDA_slave <= '1';
        wait until (rising_edge(SCLE));
        SDA_slave <= '1';
        wait until (rising_edge(SCLE));
        SDA_slave <= '1';


        wait until ( i2c_int = '1');

        report "Byte read: expect 1110_1111; got " & to_string(data_out);

        -- no op i2c packet (DO NOTHING GRACEFULLY)
        i2c_instruction <= "000";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        if(i2c_int /= '1') then
            wait until (i2c_int = '1');
        end if;

        -- stop i2c packet
        i2c_instruction <= "010";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait;
    end process;

end behavioral;

