----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Wed Jan 15 20:37:39 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Core2_APB3_tb.vhd
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

entity I2C_Core2_APB3_tb is
end I2C_Core2_APB3_tb;

architecture behavioral of I2C_Core2_APB3_tb is

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

    -- i2c APB inputs
    signal PADDR : std_logic_vector(7 downto 0) := (others => '0');
    signal PSEL : std_logic := '0';
    signal PENABLE : std_logic := '0';
    signal PWRITE : std_logic := '0';
    signal PWDATA : std_logic_vector(7 downto 0) := (others => '0');
    -- i2c APB inputs

    -- i2c APB outputs
    signal PREADY : std_logic := '0';
    signal PRDATA : std_logic_vector(7 downto 0) := (others => '0');
    signal PSLVERR : std_logic := '0';
    signal INT : std_logic := '0';
    -- i2c APB outputs

    -- i2c_core spies
    type i2c_states is(idle,
                        start0, start1, start2, start3,
                        stop0, stop1, stop2, stop3,
                        rstart0, rstart1, rstart2, rstart3,
                        data0, data1, data2, data3,
                        ack0, ack1, ack2, ack3);
    signal i_i2c_state_cur_spy : i2c_states;
    signal i_i2c_clk_pulse_spy : std_logic := '0';
    signal i_state_handshake_spy : std_logic := '0';
    signal i_bit_to_SDA_spy : std_logic := '0';
    signal i_i2c_read_reg_spy : std_logic_vector(8 downto 0) := (others => '0');
    constant FILT_LENGTH_CONST : natural := 3;
    signal i_SDA_filt_spy : std_logic_vector(FILT_LENGTH_CONST - 1 downto 0) := (others => '0');
    signal i_SCL_filt_spy : std_logic_vector(FILT_LENGTH_CONST - 1 downto 0) := (others => '0');
    signal i_SDAI_sig_history_spy : std_logic_vector(1 downto 0) := (others => '0');
    signal i_SCLI_sig_history_spy : std_logic_vector(1 downto 0) := (others => '0');
    signal i_bit_counter_spy : unsigned(2 downto 0) := (others => '1');
    signal i_did_ack_spy : std_logic := '0';
    -- i2c_core spies

    constant SEQ_CNT : natural := 32;

    -- i2c_apb spies
    signal sequence_cnt_spy : natural range 0 to SEQ_CNT - 1 := 0;
    signal seq_enable_spy : std_logic;
    signal seq_run_spy : std_logic;
    signal seq_data_spy : std_logic_vector(7 downto 0);
    signal seq_cmd_spy : std_logic_vector(1 downto 0);
    signal seq_finished_spy : std_logic;
    signal i2c_ready_spy : std_logic_vector(1 downto 0);
    signal i2c_reg_ctrl_spy : std_logic_vector(7 downto 0);
    signal i2c_reg_stat_spy : std_logic_vector(7 downto 0);
    signal i2c_reg_clk_spy : std_logic_vector(15 downto 0);
    signal i2c_reg_datI_spy : std_logic_vector(7 downto 0);
    signal i2c_reg_datO_spy : std_logic_vector(7 downto 0);
    signal i2c_initiate_spy : std_logic;
    signal i2c_instruct_spy : std_logic_vector(2 downto 0);
    signal i2c_clk_div_in_spy : std_logic_vector(15 downto 0);
    signal i2c_bus_busy_spy : std_logic;
    signal i2c_int_spy : std_logic;
    signal i2c_status_out_spy : std_logic_vector(1 downto 0);
    signal i2c_data_in_spy : std_logic_vector(7 downto 0);
    signal i2c_data_out_spy : std_logic_vector(7 downto 0);
    signal i2c_SDAI_spy : std_logic;
    signal i2c_SDAO_spy : std_logic;
    signal i2c_SDAE_spy : std_logic;
    signal i2c_SCLI_spy : std_logic;
    signal i2c_SCLO_spy : std_logic;
    signal i2c_SCLE_spy : std_logic;
    -- i2c_apb spies

    component I2C_Core2_APB3
        generic (
            g_auto_reg_max : natural;
            g_filter_length : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            PADDR : in std_logic_vector(7 downto 0);
            PSEL : in std_logic;
            PENABLE : in std_logic;
            PWRITE : in std_logic;
            PWDATA : in std_logic_vector(7 downto 0);
            SDAI : in std_logic;
            SCLI : in std_logic;
            trigger_seq : in std_logic;

            -- Outputs
            PREADY : out std_logic;
            PRDATA : out std_logic_vector(7 downto 0);
            PSLVERR : out std_logic;
            INT : out std_logic;
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

    -- Instantiate Unit Under Test:  I2C_Core2_APB3
    I2C_Core_APB3_0 : I2C_Core2_APB3
        generic map(
            g_auto_reg_max => 32,
            g_filter_length => FILT_LENGTH_CONST
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            PADDR => PADDR,
            PSEL => PSEL,
            PENABLE => PENABLE,
            PWRITE => PWRITE,
            PWDATA => PWDATA,
            SDAI => SDAI,
            SCLI => SCLI,
            trigger_seq => '0',
            
            -- Outputs
            PREADY =>  PREADY,
            PRDATA => PRDATA,
            PSLVERR =>  PSLVERR,
            INT =>  INT,
            SDAO =>  SDAO,
            SDAE =>  SDAE,
            SCLO =>  SCLO,
            SCLE =>  SCLE

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/i2c_state_cur", "i_i2c_state_cur_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/i2c_clk_pulse", "i_i2c_clk_pulse_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/state_handshake", "i_state_handshake_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/bit_to_SDA", "i_bit_to_SDA_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/i2c_read_reg", "i_i2c_read_reg_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/SDA_filt", "i_SDA_filt_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/SCL_filt", "i_SCL_filt_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/SDAI_sig_history", "i_SDAI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/SCLI_sig_history", "i_SCLI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/bit_counter", "i_bit_counter_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core2_0/did_ack", "i_did_ack_spy", 1, -1);

        init_signal_spy("I2C_Core_APB3_0/sequence_cnt", "sequence_cnt_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/seq_enable", "seq_enable_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/seq_run", "seq_run_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/seq_data", "seq_data_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/seq_cmd", "seq_cmd_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/seq_finished", "seq_finished_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_ready", "i2c_ready_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_reg_ctrl", "i2c_reg_ctrl_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_reg_stat", "i2c_reg_stat_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_reg_clk", "i2c_reg_clk_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_reg_datI", "i2c_reg_datI_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_reg_datO", "i2c_reg_datO_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_initiate", "i2c_initiate_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_instruct", "i2c_instruct_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_clk_div_in", "i2c_clk_div_in_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_bus_busy", "i2c_bus_busy_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_int", "i2c_int_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_status_out", "i2c_status_out_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_data_in", "i2c_data_in_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_data_out", "i2c_data_out_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_SDAI", "i2c_SDAI_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_SDAO", "i2c_SDAO_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_SDAE", "i2c_SDAE_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_SCLI", "i2c_SCLI_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_SCLO", "i2c_SCLO_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/i2c_SCLE", "i2c_SCLE_spy", 1, -1);
        wait;
    end process;

    SDAI <= SDAO when SDAE = '1' else SDA_slave;
    SCLI <= SCLO when SCLE = '1' else SCL_slave;

    SDA_slave <= '0' when i_did_ack_spy = '1' and i2c_instruct_spy = "100" else '1';

    THE_STUFF : process
        variable seq_reg : std_logic_vector(9 downto 0) := (others => '0');
    begin

        -- initialize

        --SDA_slave <= '1';
        SCL_slave <= '1';

        PADDR <= (others => '0');
        PSEL <= '0';
        PENABLE <= '0';
        PWRITE <= '0';
        PWDATA <= (others => '0');

        wait until(NSYSRESET = '1');

        -- APB reads to check sequence register defaults

        for i in 0 to SEQ_CNT - 1 loop

            -- APB idle state
            -- APB setup state
            PADDR <= "10" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '0';
            seq_reg := (others => '0');

            wait for ( SYSCLK_PERIOD * 1);
            -- APB enter access state

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            -- APB leave Access state
            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;

            assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);

            seq_reg(7 downto 0) := PRDATA;

            -- APB idle state
            -- APB setup state
            PADDR <= "11" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '0';

            wait for ( SYSCLK_PERIOD * 1);
            -- APB enter access state

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            -- APB leave Access state
            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;

            seq_reg(9 downto 8) := PRDATA(1 downto 0);

            report "Sequence Register: " & integer'image(i) & " = " & to_string(seq_reg(9 downto 8)) & "_" & to_hstring(seq_reg(7 downto 0));
            
        end loop;

        -- APB writes to setup I2C Core

        -- APB idle state
        -- APB setup state
        -- ** set clock prescaler
        PADDR <= X"02";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= X"80";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "I2C CLK0 written";

        -- APB idle state
        -- APB setup state
        -- ** set I2C start instruction
        PADDR <= X"00";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= B"0000_0011";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "start instruction written";

        wait until (INT = '1');

        -- APB idle state
        -- APB setup state
        -- ** set I2C data in to address
        PADDR <= X"04";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= B"0011_0110";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "data written";

        -- APB idle state
        -- APB setup state
        -- ** set I2C send data address
        PADDR <= X"00";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= B"0000_1001";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "data send written";

        wait until (INT = '1');

        -- APB idle state
        -- APB setup state
        -- ** set I2C read data
        PADDR <= X"05";
        PSEL <= '1';
        PWRITE <= '0';
        PWDATA <= B"0000_0000";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "data read happened";

        report "data_out Register: " & to_string(PRDATA);

        -- APB idle state
        -- APB setup state
        -- ** set I2C stop instruction
        PADDR <= X"00";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= B"0000_0101";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "stop instruction written";

        wait until (i2c_status_out_spy(1 downto 0) = "00");

        -- Enable sequence via APB
        -- APB idle state
        -- APB setup state
        -- ** set I2C instruction sequence start
        PADDR <= X"00";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= B"0001_0000";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "instruction sequence start written";

        wait until (INT = '1');

        -- Clear sequence finished interrupt
        -- APB idle state
        -- APB setup state
        -- ** set I2C instruction sequence start
        PADDR <= X"00";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= B"0000_0000";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "instruction sequence interrupt clear written";

        -- Enable sequence via trigger_auto



        -- APB reads to check sequence register defaults

        for i in 0 to SEQ_CNT - 1 loop

            -- APB idle state
            -- APB setup state
            PADDR <= "10" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '0';
            seq_reg := (others => '0');

            wait for ( SYSCLK_PERIOD * 1);
            -- APB enter access state

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            -- APB leave Access state
            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;

            assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);

            seq_reg(7 downto 0) := PRDATA;

            -- APB idle state
            -- APB setup state
            PADDR <= "11" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '0';

            wait for ( SYSCLK_PERIOD * 1);
            -- APB enter access state

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            -- APB leave Access state
            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;

            seq_reg(9 downto 8) := PRDATA(1 downto 0);

            report "Sequence Register: " & integer'image(i) & " = " & to_string(seq_reg(9 downto 8)) & "_" & to_hstring(seq_reg(7 downto 0));
            
        end loop;

        wait;
    end process;

end behavioral;

