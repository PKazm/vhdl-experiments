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
-- File: I2C_Core_APB3_tb.vhd
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

entity I2C_Core_APB3_tb is
end I2C_Core_APB3_tb;

architecture behavioral of I2C_Core_APB3_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    
    constant INSTR_SEQ_SIZE_CONST : natural := 64;
    constant FILT_LENGTH_CONST : natural := 3;


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
    signal ir_i2c_seq_regs_spy : reg_seq_type;

    signal ir_i2c_initiate_sig_spy : std_logic;
    signal ir_uSRAM_A_ADDR_sig_spy : std_logic_vector(5 downto 0);
    signal ir_uSRAM_A_DOUT_sig_spy : std_logic_vector(9 downto 0);
    signal ir_uSRAM_B_ADDR_sig_spy : std_logic_vector(5 downto 0);
    signal ir_uSRAM_B_DOUT_sig_spy : std_logic_vector(9 downto 0);
    signal ir_uSRAM_C_BLK_sig_spy : std_logic;
    signal ir_uSRAM_C_ADDR_sig_spy : std_logic_vector(5 downto 0);
    signal ir_uSRAM_C_DIN_sig_spy : std_logic_vector(9 downto 0);
    signal ir_from_bus_spy : std_logic;
    signal ir_write_data_spy : std_logic;
    signal ir_instr_bits_to_mem_spy : std_logic_vector(1 downto 0);
    signal ir_data_bits_to_mem_spy : std_logic_vector(7 downto 0);
    signal ir_mem_to_bus_spy : std_logic_vector(7 downto 0);
    signal ir_mem_delay_cnt_spy : unsigned (1 downto 0);
    type seq_states is(idle, next_instr, do_instr, read_i2c);
    signal ir_seq_state_cur_spy : seq_states;
    -- i2c RAM spies

    component I2C_Core_APB3
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

    -- Instantiate Unit Under Test:  I2C_Core_APB3
    I2C_Core_APB3_0 : I2C_Core_APB3
        generic map(
            g_auto_reg_max => INSTR_SEQ_SIZE_CONST,
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

        -- i2c RAM spies
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/i2c_seq_regs", "ir_i2c_seq_regs_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/i2c_initiate_sig", "ir_i2c_initiate_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_A_ADDR_sig", "ir_uSRAM_A_ADDR_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_A_DOUT_sig", "ir_uSRAM_A_DOUT_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_B_ADDR_sig", "ir_uSRAM_B_ADDR_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_B_DOUT_sig", "ir_uSRAM_B_DOUT_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_C_BLK_sig", "ir_uSRAM_C_BLK_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_C_ADDR_sig", "ir_uSRAM_C_ADDR_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/uSRAM_C_DIN_sig", "ir_uSRAM_C_DIN_sig_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/from_bus", "ir_from_bus_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/write_data", "ir_write_data_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/instr_bits_to_mem", "ir_instr_bits_to_mem_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/data_bits_to_mem", "ir_data_bits_to_mem_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/mem_to_bus", "ir_mem_to_bus_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/mem_delay_cnt", "ir_mem_delay_cnt_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/seq_state_cur", "ir_seq_state_cur_spy", 1, -1);
        -- i2c RAM spies

        -- i2c core spies
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/i2c_state_cur", "i_i2c_state_cur_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/i2c_bus_ready", "i_i2c_bus_ready_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/i2c_clk_pulse", "i_i2c_clk_pulse_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/state_handshake", "i_state_handshake_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/bit_to_SDA", "i_bit_to_SDA_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/i2c_read_reg", "i_i2c_read_reg_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/SDA_filt", "i_SDA_filt_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/SCL_filt", "i_SCL_filt_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/SDAI_sig_history", "i_SDAI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/SCLI_sig_history", "i_SCLI_sig_history_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/bit_counter", "i_bit_counter_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/did_ack", "i_did_ack_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Instruction_RAM_0/I2C_Core_0/i2c_instr_reg", "i_i2c_instr_reg_spy", 1, -1);
        -- i2c core spies
        wait;
    end process;

    SDAI <= SDAO when SDAE = '1' else SDA_slave;
    SCLI <= SCLO when SCLE = '1' else SCL_slave;

    SDA_slave <= '0' when i_did_ack_spy = '1' and i_i2c_instr_reg_spy = "100" else '1';

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
            PADDR <= "10" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '1';
            PWDATA <= seq_reg(7 downto 0);

            wait for ( SYSCLK_PERIOD * 1);
            
            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;
            
            PADDR <= (others => '0');
            PSEL <= '0';
            PENABLE <= '0';
            PWRITE <= '0';
            PWDATA <= (others => '0');

            wait for ( SYSCLK_PERIOD * 1);

            --==================================================================
            -- write instruction of seq_reg to RAM

            PADDR <= "11" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '1';
            PWDATA <= "000000" & seq_reg(9 downto 8);

            wait for ( SYSCLK_PERIOD * 1);

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;
            
            PADDR <= (others => '0');
            PSEL <= '0';
            PENABLE <= '0';
            PWRITE <= '0';
            PWDATA <= (others => '0');

            assert (seq_reg = ir_i2c_seq_regs_spy(i)) report "RAM write mismatch loc : " &
                                                            integer'image(i) & " - " &
                                                            to_string(seq_reg) & " /= " &
                                                            to_string(ir_i2c_seq_regs_spy(i));

        end loop;

        PADDR <= (others => '0');
        PSEL <= '0';
        PENABLE <= '0';
        PWRITE <= '0';
        PWDATA <= (others => '0');

        report "APB RAM write complete";

        wait for ( SYSCLK_PERIOD * 1);
        --=========================================================================

        --=========================================================================
        -- read I2C RAM registers

        for i in 0 to INSTR_SEQ_SIZE_CONST - 1 loop


            --==================================================================
            -- read data of RAM to seq_reg
            PADDR <= "10" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PENABLE <= '0';

            wait for ( SYSCLK_PERIOD * 2);

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);
            --if(mem_done /= '1') then
            --    wait until (mem_done = '1');
            --end if;
            seq_reg(7 downto 0) := PRDATA;

            wait for ( SYSCLK_PERIOD * 1);

            --==================================================================
            -- write instruction of seq_reg to RAM
            

            PADDR <= "11" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PENABLE <= '0';

            wait for ( SYSCLK_PERIOD * 2);

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);
            --if(mem_done /= '1') then
            --    wait until (mem_done = '1');
            --end if;
            seq_reg(9 downto 8) := PRDATA(1 downto 0);
            
            wait for ( SYSCLK_PERIOD * 1);

            assert (seq_reg = ir_i2c_seq_regs_spy(i)) report "RAM read mismatch loc : " &
                                                            integer'image(i) & " - " &
                                                            to_string(seq_reg) & " /= " &
                                                            to_string(ir_i2c_seq_regs_spy(i));

        end loop;

        PADDR <= (others => '0');
        PSEL <= '0';
        PENABLE <= '0';
        PWRITE <= '0';
        PWDATA <= (others => '0');

        report "APB RAM read complete";
            
    end process;

end behavioral;

