----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Fri Jan 24 20:35:34 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Instruction_RAM_tb.vhd
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

entity I2C_Instruction_RAM_tb is
end I2C_Instruction_RAM_tb;

architecture behavioral of I2C_Instruction_RAM_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant INSTR_SEQ_SIZE_CONST : natural := 64;
    constant FILT_LENGTH_CONST : natural := 3;

    signal adr_to_mem : std_logic_vector(5 downto 0);
    signal data_to_mem : std_logic_vector(7 downto 0);
    signal bus_active : std_logic;
    signal bus_rw_instr : std_logic;
    signal bus_w_en : std_logic;
    signal seq_enable : std_logic;
    signal i2c_initiate : std_logic;
    signal i2c_instruct : std_logic_vector(2 downto 0);
    signal i2c_clk_div_in : std_logic_vector(15 downto 0);
    signal i2c_data_in : std_logic_vector(7 downto 0);
    signal mem_to_bus : std_logic_vector(7 downto 0);
    signal mem_done : std_logic;
    signal seq_finished : std_logic;
    signal i2c_bus_busy : std_logic;
    signal i2c_int : std_logic;
    signal i2c_status_out : std_logic_vector(1 downto 0);
    signal i2c_data_out : std_logic_vector(7 downto 0);

    -- i2c signals
    signal SDAI : std_logic := '0';
    signal SDAO : std_logic := '0';
    signal SDAE : std_logic := '0';
    signal SCLI : std_logic := '0';
    signal SCLO : std_logic := '0';
    signal SCLE : std_logic := '0';
    signal SDA_slave : std_logic := '0';
    signal SCL_slave : std_logic := '0';
    -- i2c signals

    -- i2c core spies
    type i2c_states is(idle,
                        start0, start1, start2, start3,
                        stop0, stop1, stop2, stop3,
                        rstart0, rstart1, rstart2, rstart3,
                        data0, data1, data2, data3,
                        ack0, ack1, ack2, ack3);
    signal i_i2c_state_cur_spy : i2c_states;
    signal i_i2c_bus_ready_spy : std_logic;
    signal i_i2c_clk_pulse_spy : std_logic := '0';
    signal i_state_handshake_spy : std_logic := '0';
    signal i_bit_to_SDA_spy : std_logic := '0';
    signal i_i2c_read_reg_spy : std_logic_vector(8 downto 0) := (others => '0');
    signal i_SDA_filt_spy : std_logic_vector(FILT_LENGTH_CONST - 1 downto 0) := (others => '0');
    signal i_SCL_filt_spy : std_logic_vector(FILT_LENGTH_CONST - 1 downto 0) := (others => '0');
    signal i_SDAI_sig_history_spy : std_logic_vector(1 downto 0) := (others => '0');
    signal i_SCLI_sig_history_spy : std_logic_vector(1 downto 0) := (others => '0');
    signal i_bit_counter_spy : unsigned(2 downto 0) := (others => '1');
    signal i_did_ack_spy : std_logic := '0';
    signal i_i2c_instr_reg_spy : std_logic_vector(2 downto 0);
    -- i2c core spies

    -- i2c RAM spies
    type reg_seq_type is array(INSTR_SEQ_SIZE_CONST - 1 downto 0) of std_logic_vector(9 downto 0);
    signal i2c_seq_regs_spy : reg_seq_type;

    signal i2c_initiate_sig_spy : std_logic;
    signal uSRAM_A_ADDR_sig_spy : std_logic_vector(5 downto 0);
    signal uSRAM_A_DOUT_sig_spy : std_logic_vector(9 downto 0);
    signal uSRAM_B_ADDR_sig_spy : std_logic_vector(5 downto 0);
    signal uSRAM_B_DOUT_sig_spy : std_logic_vector(9 downto 0);
    signal uSRAM_C_BLK_sig_spy : std_logic;
    signal uSRAM_C_ADDR_sig_spy : std_logic_vector(5 downto 0);
    signal uSRAM_C_DIN_sig_spy : std_logic_vector(9 downto 0);
    signal from_bus_spy : std_logic;
    signal write_data_spy : std_logic;
    signal instr_bits_to_mem_spy : std_logic_vector(1 downto 0);
    signal data_bits_to_mem_spy : std_logic_vector(7 downto 0);
    signal mem_delay_cnt_spy : unsigned (1 downto 0);
    type seq_states is(idle, next_instr, do_instr, read_i2c);
    signal seq_state_cur_spy : seq_states;
    -- i2c RAM spies

    component I2C_Instruction_RAM
        generic (
            g_auto_reg_max : natural;
            g_filter_length : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            adr_to_mem : in std_logic_vector(5 downto 0);
            data_to_mem : in std_logic_vector(7 downto 0);
            bus_active : in std_logic;
            bus_rw_instr : in std_logic;
            bus_w_en : in std_logic;
            seq_enable : in std_logic;
            i2c_initiate : in std_logic;
            i2c_instruct : in std_logic_vector(2 downto 0);
            i2c_clk_div_in : in std_logic_vector(15 downto 0);
            i2c_data_in : in std_logic_vector(7 downto 0);
            SDAI : in std_logic;
            SCLI : in std_logic;

            -- Outputs
            mem_to_bus : out std_logic_vector(7 downto 0);
            mem_done : out std_logic;
            seq_finished : out std_logic;
            i2c_bus_busy : out std_logic;
            i2c_int : out std_logic;
            i2c_status_out : out std_logic_vector(1 downto 0);
            i2c_data_out : out std_logic_vector(7 downto 0);
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

    -- Instantiate Unit Under Test:  I2C_Instruction_RAM
    I2C_Instruction_RAM_0 : I2C_Instruction_RAM
        generic map(
                g_auto_reg_max => INSTR_SEQ_SIZE_CONST,
                g_filter_length => FILT_LENGTH_CONST
            )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            adr_to_mem => adr_to_mem,
            data_to_mem => data_to_mem,
            bus_active => bus_active,
            bus_rw_instr => bus_rw_instr,
            bus_w_en => bus_w_en,
            seq_enable => seq_enable,
            i2c_initiate => i2c_initiate,
            i2c_instruct => i2c_instruct,
            i2c_clk_div_in => i2c_clk_div_in,
            i2c_data_in => i2c_data_in,
            SDAI => SDAI,
            SCLI => SCLI,

            -- Outputs
            mem_to_bus => mem_to_bus,
            mem_done => mem_done,
            seq_finished => seq_finished,
            i2c_bus_busy => i2c_bus_busy,
            i2c_int => i2c_int,
            i2c_status_out => i2c_status_out,
            i2c_data_out => i2c_data_out,
            SDAO => SDAO,
            SDAE => SDAE,
            SCLO => SCLO,
            SCLE => SCLE

            -- Inouts

        );


    spy_process : process
    begin
        init_signal_spy("I2C_Instruction_RAM_0/i2c_seq_regs", "i2c_seq_regs_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/i2c_initiate_sig", "i2c_initiate_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_A_ADDR_sig", "uSRAM_A_ADDR_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_A_DOUT_sig", "uSRAM_A_DOUT_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_B_ADDR_sig", "uSRAM_B_ADDR_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_B_DOUT_sig", "uSRAM_B_DOUT_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_C_BLK_sig", "uSRAM_C_BLK_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_C_ADDR_sig", "uSRAM_C_ADDR_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/uSRAM_C_DIN_sig", "uSRAM_C_DIN_sig_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/from_bus", "from_bus_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/write_data", "write_data_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/instr_bits_to_mem", "instr_bits_to_mem_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/data_bits_to_mem", "data_bits_to_mem_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/mem_delay_cnt", "mem_delay_cnt_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/seq_state_cur", "seq_state_cur_spy", 1, -1);
        
        -- i2c core spies
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/i2c_state_cur", "i_i2c_state_cur_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/i2c_bus_ready", "i_i2c_bus_ready_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/i2c_clk_pulse", "i_i2c_clk_pulse_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/state_handshake", "i_state_handshake_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/bit_to_SDA", "i_bit_to_SDA_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/i2c_read_reg", "i_i2c_read_reg_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/SDA_filt", "i_SDA_filt_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/SCL_filt", "i_SCL_filt_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/SDAI_sig_history", "i_SDAI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/SCLI_sig_history", "i_SCLI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/bit_counter", "i_bit_counter_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/did_ack", "i_did_ack_spy", 1, -1);
        init_signal_spy("I2C_Instruction_RAM_0/I2C_Core_0/i2c_instr_reg", "i_i2c_instr_reg_spy", 1, -1);
        -- i2c core spies
        wait;
    end process;

    SDAI <= SDAO when SDAE = '1' else SDA_slave;
    SCLI <= SCLO when SCLE = '1' else SCL_slave;

    SDA_slave <= '0' when i_did_ack_spy = '1' and i_i2c_instr_reg_spy = "100" else '1';

    THE_STUFF : process
		variable seq_reg : std_logic_vector(9 downto 0);
    begin

        SCL_slave <= '1';

        adr_to_mem <= (others => '0');
        data_to_mem <= (others => '0');
        bus_active <= '0';
        bus_rw_instr <= '0';
        bus_w_en <= '0';

        seq_enable <= '0';
        i2c_initiate <= '0';
        i2c_instruct <= (others => '0');
        i2c_clk_div_in <= (others => '0');
        i2c_data_in <= (others => '0');

        wait until(NSYSRESET = '1');

        --=========================================================================


        bus_active <= '1';
        -- write to all RAM locations via the input signals
        for i in 0 to INSTR_SEQ_SIZE_CONST - 1 loop
            case i is
                when 0 => seq_reg := "01" & "00000001";  -- start
                when 1 => seq_reg := "10" & "01010010";  -- optical sensor address + write
                when 2 => seq_reg := "10" & X"88";  -- optical sensor register address
                when 3 => seq_reg := "01" & "00000011";  -- repeated start
                when 4 => seq_reg := "10" & "01010011";  -- optical sensor address + read
                when 5 => seq_reg := "11" & X"00";  -- sensor data
                when 6 => seq_reg := "01" & "00000011";  -- repeated start
                when 7 => seq_reg := "10" & "01010010";  -- optical sensor address + write
                when 8 => seq_reg := "10" & X"89";  -- optical sensor register address
                when 9 => seq_reg := "01" & "00000011";  -- repeated start
                when 10 => seq_reg := "10" & "01010011";  -- optical sensor address + read
                when 11 => seq_reg := "11" & X"00";  -- sensor data
                when 12 => seq_reg := "01" & "00000011";  -- repeated start
                when 13 => seq_reg := "10" & "01010010";  -- optical sensor address + write
                when 14 => seq_reg := "10" & X"8A";  -- optical sensor register address
                when 15 => seq_reg := "01" & "00000011";  -- repeated start
                when 16 => seq_reg := "10" & "01010011";  -- optical sensor address + read
                when 17 => seq_reg := "11" & X"00";  -- sensor data
                when 18 => seq_reg := "01" & "00000011";  -- repeated start
                when 19 => seq_reg := "10" & "01010010";  -- optical sensor address + write
                when 20 => seq_reg := "10" & X"8B";  -- optical sensor register address
                when 21 => seq_reg := "01" & "00000011";  -- repeated start
                when 22 => seq_reg := "10" & "01010011";  -- optical sensor address + read
                when 23 => seq_reg := "11" & X"00";  -- sensor data
                when 24 => seq_reg := "01" & "00000010";  -- stop
                when 30 => seq_reg := "01" & "00000001";    -- start
                when 63 => seq_reg := "01" & "00000010";    -- stop
                when others => seq_reg := "00" & X"00";
            end case;


            --==================================================================
            -- write data of seq_reg to RAM
            adr_to_mem <= std_logic_vector(to_unsigned(i, adr_to_mem'length));
            data_to_mem <= seq_reg(7 downto 0);
            bus_rw_instr <= '0';
            --bus_w_en <= '0';

            bus_w_en <= '1';

            wait for ( SYSCLK_PERIOD * 1);
            if(mem_done /= '1') then
                wait until (mem_done = '1');
            end if;

            bus_w_en <= '0';
            wait for ( SYSCLK_PERIOD * 1);

            --==================================================================
            -- write instruction of seq_reg to RAM

            adr_to_mem <= std_logic_vector(to_unsigned(i, adr_to_mem'length));
            data_to_mem <= "000000" & seq_reg(9 downto 8);
            bus_rw_instr <= '1';
            --bus_w_en <= '0';

            bus_w_en <= '1';

            wait for ( SYSCLK_PERIOD * 1);
            if(mem_done /= '1') then
                wait until (mem_done = '1');
            end if;


            bus_w_en <= '0';
            wait for ( SYSCLK_PERIOD * 1);

            assert (seq_reg = i2c_seq_regs_spy(i)) report "RAM write mismatch loc : " &
                                                            integer'image(i) & " - " &
                                                            to_string(seq_reg) & " /= " &
                                                            to_string(i2c_seq_regs_spy(i));

        end loop;

        adr_to_mem <= (others => '0');
        data_to_mem <= (others => '0');
        bus_active <= '0';
        bus_rw_instr <= '0';
        bus_w_en <= '0';

        seq_enable <= '0';
        i2c_initiate <= '0';
        i2c_instruct <= (others => '0');
        i2c_clk_div_in <= X"0180";
        i2c_data_in <= (others => '0');

        report "RAM write complete";

        wait for ( SYSCLK_PERIOD * 1);
        --=========================================================================
        -- run sequence

        seq_enable <= '1';

        if(seq_finished /= '1') then
            wait until (seq_finished = '1');
        end if;

        seq_enable <= '0';

        adr_to_mem <= (others => '0');
        data_to_mem <= (others => '0');
        bus_active <= '0';
        bus_rw_instr <= '0';
        bus_w_en <= '0';

        seq_enable <= '0';
        i2c_initiate <= '0';
        i2c_instruct <= (others => '0');
        i2c_clk_div_in <= X"0180";
        i2c_data_in <= (others => '0');

        report "I2C sequence complete";

        wait for ( SYSCLK_PERIOD * 1);
        --=========================================================================
        -- run manual I2C commands

        -- i2c start command
        i2c_instruct <= "001";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until (i2c_int = '1');

        -- i2c data send command
        i2c_instruct <= "100";
        i2c_data_in <= X"52";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';
        
        wait until (i2c_int = '1');

        -- i2c repeated start command
        i2c_instruct <= "011";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';

        wait until (i2c_int = '1');

        -- i2c data send command
        i2c_instruct <= "100";
        i2c_data_in <= X"25";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';
        
        wait until (i2c_int = '1');

        -- i2c stop command
        i2c_instruct <= "010";
        i2c_initiate <= '0';
        wait for ( SYSCLK_PERIOD * 1);
        i2c_initiate <= '1';
        
        wait until (i2c_status_out = "00");

        i2c_initiate <= '0';

        report "I2C manual complete";

        wait for ( SYSCLK_PERIOD * 1);
        --=========================================================================
        -- read I2C RAM registers

        bus_active <= '1';

        for i in 0 to INSTR_SEQ_SIZE_CONST - 1 loop


            --==================================================================
            -- read data of RAM to seq_reg
            adr_to_mem <= std_logic_vector(to_unsigned(i, adr_to_mem'length));
            bus_rw_instr <= '0';

            wait for ( SYSCLK_PERIOD * 2);
            --if(mem_done /= '1') then
            --    wait until (mem_done = '1');
            --end if;
            seq_reg(7 downto 0) := mem_to_bus;

            wait for ( SYSCLK_PERIOD * 1);

            --==================================================================
            -- write instruction of seq_reg to RAM
            

            adr_to_mem <= std_logic_vector(to_unsigned(i, adr_to_mem'length));
            bus_rw_instr <= '1';

            wait for ( SYSCLK_PERIOD * 2);
            --if(mem_done /= '1') then
            --    wait until (mem_done = '1');
            --end if;
            seq_reg(9 downto 8) := mem_to_bus(1 downto 0);
            
            wait for ( SYSCLK_PERIOD * 1);

            assert (seq_reg = i2c_seq_regs_spy(i)) report "RAM read mismatch loc : " &
                                                            integer'image(i) & " - " &
                                                            to_string(seq_reg) & " /= " &
                                                            to_string(i2c_seq_regs_spy(i));

        end loop;

        adr_to_mem <= (others => '0');
        data_to_mem <= (others => '0');
        bus_active <= '0';
        bus_rw_instr <= '0';
        bus_w_en <= '0';

        seq_enable <= '0';
        i2c_initiate <= '0';
        i2c_instruct <= (others => '0');
        i2c_data_in <= (others => '0');

        report "RAM read complete";

        bus_active <= '0';

        wait;
    end process;

end behavioral;

