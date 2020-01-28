--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Instruction_RAM.vhd
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

entity I2C_Instruction_RAM is
generic (
    g_auto_reg_max : natural := 64;
    g_filter_length : natural := 3
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    adr_to_mem : in std_logic_vector(5 downto 0);
    data_to_mem : in std_logic_vector(7 downto 0);
    bus_active : in std_logic;
    bus_rw_instr : in std_logic;
    bus_w_en : in std_logic;

    mem_to_bus : out std_logic_vector(7 downto 0);
    mem_done : out std_logic;

    seq_enable : in std_logic;      -- held high until seq_finished = '1'.
    seq_finished : out std_logic;   -- this is basically the sequence interrupt
    -- seq_count can either align with the extra bits from I2C status (8 - 2 = 6)
    -- essentially a limit so all status bits are in 1 "register" length
    -- or 
    -- match the address range or match the reg_max generic
    seq_count : out std_logic_vector(5 downto 0);


    -- i2c signals passthrough
    i2c_initiate : in std_logic;
    i2c_instruct : in std_logic_vector(2 downto 0);
    i2c_clk_div_in : in std_logic_vector(15 downto 0);
    i2c_bus_busy : out std_logic;
    i2c_int : out std_logic;
    i2c_status_out : out std_logic_vector(1 downto 0);
    i2c_data_in : in std_logic_vector(7 downto 0);
    i2c_data_out : out std_logic_vector(7 downto 0);
    -- i2c signals passthrough

    -- i2c bus passthrough
    SDAI : in std_logic;
    SDAO : out std_logic;
    SDAE : out std_logic;

    SCLI : in std_logic;
    SCLO : out std_logic;
    SCLE : out std_logic
    -- i2c bus passthrough
);
end I2C_Instruction_RAM;
architecture architecture_I2C_Instruction_RAM of I2C_Instruction_RAM is

    -- seq RAM
    type reg_seq_type is array(g_auto_reg_max - 1 downto 0) of std_logic_vector(9 downto 0);
    signal i2c_seq_regs : reg_seq_type;


    -- A reads to the APB bus
    signal uSRAM_A_ADDR_sig : std_logic_vector(5 downto 0);
    signal uSRAM_A_DOUT_sig : std_logic_vector(9 downto 0);
    -- B reads to the sequence logic
    signal uSRAM_B_ADDR_sig : std_logic_vector(5 downto 0);
    signal uSRAM_B_DOUT_sig : std_logic_vector(9 downto 0);
    -- C writes from the APB bus and the sequence logic
    signal uSRAM_C_BLK_sig : std_logic;
    signal uSRAM_C_ADDR_sig : std_logic_vector(5 downto 0);
    signal uSRAM_C_DIN_sig : std_logic_vector(9 downto 0);

    signal from_bus : std_logic;
    signal write_data : std_logic;
    signal instr_bits_to_mem : std_logic_vector(1 downto 0);
    signal data_bits_to_mem : std_logic_vector(7 downto 0);
    signal mem_delay_cnt : unsigned(1 downto 0);
    signal mem_done_sig : std_logic;
    -- seq RAM

    -- seq control signals
    type seq_states is(idle, next_instr, do_instr, read_i2c);
    signal seq_state_cur : seq_states;
    signal seq_instr_timeout : natural range 0 to 3 := 3;   -- limits the number of times an instruction can repeat: "watchdog"
    signal sequence_cnt : natural range 0 to g_auto_reg_max - 1 := 0;

    signal seq_instr : std_logic_vector(1 downto 0);
    signal seq_data : std_logic_vector(7 downto 0);
    signal i2c_ready : std_logic;
    signal i2c_run : std_logic;
    signal i2c_write_d : std_logic;
    signal seq_write : std_logic;
    signal seq_last_instr : std_logic;
    signal seq_finished_sig : std_logic;
    signal uSRAM_delay_sig : unsigned(0 downto 0);
    -- seq control signals


    -- I2C_Core connection signals
    signal i2c_initiate_sig : std_logic;
    signal i2c_instruct_sig : std_logic_vector(2 downto 0);
    signal i2c_clk_div_in_sig : std_logic_vector(15 downto 0);
    signal i2c_bus_busy_sig : std_logic;
    signal i2c_int_sig : std_logic;
    signal i2c_status_out_sig : std_logic_vector(1 downto 0);
    signal i2c_data_in_sig : std_logic_vector(7 downto 0);
    signal i2c_data_out_sig : std_logic_vector(7 downto 0);
    signal i2c_SDAI_sig : std_logic;
    signal i2c_SDAO_sig : std_logic;
    signal i2c_SDAE_sig : std_logic;
    signal i2c_SCLI_sig : std_logic;
    signal i2c_SCLO_sig : std_logic;
    signal i2c_SCLE_sig : std_logic;
    -- I2C_Core connection signals

    component I2C_Core
        generic(
            g_filter_length : natural
        );
        -- ports
        port( 
            PCLK : in std_logic;
            RSTn : in std_logic;

            -- control inputs
            initiate : in std_logic;
            instruct : in std_logic_vector(2 downto 0);
            clk_div_in : in std_logic_vector(15 downto 0);
            -- control inputs

            -- status outputs
            i2c_bus_busy : out std_logic;
            i2c_int : out std_logic;
            status_out : out std_logic_vector(1 downto 0);
            -- status outputs

            -- data connections
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0);
            -- data connections

            -- I2C connections
            SDAI : in std_logic;
            SDAO : out std_logic;
            SDAE : out std_logic;
            
            SCLI : in std_logic;
            SCLO : out std_logic;
            SCLE : out std_logic
            -- I2C connections
        );
    end component;
begin

    I2C_Core_0 : I2C_Core
        generic map(
            g_filter_length => g_filter_length
        )
        -- port map
        port map( 
            PCLK => PCLK,
            RSTn => RSTn,

            -- control inputs
            initiate => i2c_initiate_sig,
            instruct => i2c_instruct_sig,
            clk_div_in => i2c_clk_div_in_sig,
            -- control inputs

            -- status outputs
            i2c_bus_busy => i2c_bus_busy_sig,
            i2c_int => i2c_int_sig,
            status_out => i2c_status_out_sig,
            -- status outputs

            -- data connections
            data_in => i2c_data_in_sig,
            data_out => i2c_data_out_sig,
            -- data connections

            -- I2C connections
            SDAI => i2c_SDAI_sig,
            SDAO => i2c_SDAO_sig,
            SDAE => i2c_SDAE_sig,
            
            SCLI => i2c_SCLI_sig,
            SCLO => i2c_SCLO_sig,
            SCLE => i2c_SCLE_sig
            -- I2C connections
        );

    -- passthrough I2C control signals
        -- signals from the bus to I2C
        i2c_initiate_sig <= i2c_run when seq_enable = '1' else i2c_initiate;
        i2c_instruct_sig <= seq_data(2 downto 0) when seq_enable = '1' and seq_instr = "01" else
                                            "100" when seq_enable = '1' and seq_instr = "10" else
                                            "101" when seq_enable = '1' and seq_instr = "11" else
                                    i2c_instruct;
        i2c_clk_div_in_sig <= i2c_clk_div_in;
        i2c_data_in_sig <= seq_data when seq_enable = '1' else i2c_data_in;
        
        -- signals from I2C to the bus
        i2c_bus_busy <= i2c_bus_busy_sig;
        i2c_int <= i2c_int_sig;
        i2c_status_out <= i2c_status_out_sig;
        i2c_data_out <= i2c_data_out_sig;
    -- passthrough I2C control signals

    -- passthrough I2C bus connections
    i2c_SDAI_sig <= SDAI;
    SDAO <= i2c_SDAO_sig;
    SDAE <= i2c_SDAE_sig;
    i2c_SCLI_sig <= SCLI;
    SCLO <= i2c_SCLO_sig;
    SCLE <= i2c_SCLE_sig;
    -- passthrough I2C bus connections

    --=========================================================================

    -- A port is used by the APB interface to return values from memory
    p_read_A_port : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            uSRAM_A_DOUT_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then
            uSRAM_A_DOUT_sig <= i2c_seq_regs(to_integer(unsigned(uSRAM_A_ADDR_sig)));
        end if;
    end process;

    uSRAM_A_ADDR_sig <= adr_to_mem;
    mem_to_bus <= "000000" & uSRAM_A_DOUT_sig(9 downto 8) when bus_rw_instr = '1' else uSRAM_A_DOUT_sig(7 downto 0);

    --=========================================================================
    
    -- B port is used by the instruction sequence
    p_read_B_port : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            uSRAM_B_DOUT_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then
            uSRAM_B_DOUT_sig <= i2c_seq_regs(to_integer(unsigned(uSRAM_B_ADDR_sig)));
        end if;
    end process;

    uSRAM_B_ADDR_sig <= std_logic_vector(to_unsigned(sequence_cnt, uSRAM_B_ADDR_sig'length));

    --=========================================================================

    -- C port writes from APB + A or I2C + B
    -- APB writes can be to either instruction or data
    -- sequence readback can only be data
    p_write_C_port : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            mem_done_sig <= '0';
            mem_delay_cnt <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(uSRAM_C_BLK_sig = '1') then
                if(mem_done_sig = '0') then
                    if(mem_delay_cnt = "10") then
                        i2c_seq_regs(to_integer(unsigned(uSRAM_C_ADDR_sig))) <= uSRAM_C_DIN_sig;
                        mem_done_sig <= '1';
                    else
                        mem_delay_cnt <= mem_delay_cnt + 1;
                    end if;
                else
                    mem_done <= '1';
                end if;
            else
                mem_done_sig <= '0';
                mem_done <= '0';
                mem_delay_cnt <= (others => '0');
            end if;
        end if;

    end process;

    from_bus <= bus_active and not seq_enable;
    -- I had the register be 1 = instr, 0 = data, but wrote the flags the other way, here is the changeover
    write_data <= not bus_rw_instr when from_bus = '1' else i2c_write_d;

    -- instr from port A when write_data = 1 and from_bus = 1
    -- instr from APB when write_data = 0 and from_bus = 1
    --
    -- instr from port B when write_data = 1 and from_bus = 0
    -- 0 when write_data = 0 and from_bus = 0 (reset reg value)
    instr_bits_to_mem <= uSRAM_A_DOUT_sig(9 downto 8) when write_data = '1' and from_bus = '1' else
                            data_to_mem(1 downto 0) when write_data = '0' and from_bus = '1' else
                        uSRAM_B_DOUT_sig(9 downto 8) when write_data = '1' and from_bus = '0' else
                                                "00" when write_data = '0' and from_bus = '0';

    -- data from APB when write_data = 1 and from_bus = 1
    -- data from port A when write_data = 0 and from_bus = 1
    --
    -- data from I2C when write_data = 1 and from_bus = 0
    -- 0 when write_data = 0 and from_bus = 0 (reset reg value)
    data_bits_to_mem <=         data_to_mem when write_data = '1' and from_bus = '1' else
                uSRAM_A_DOUT_sig(7 downto 0) when write_data = '0' and from_bus = '1' else
                            i2c_data_out_sig when write_data = '1' and from_bus = '0' else
                                        X"00" when write_data = '0' and from_bus = '0';

    uSRAM_C_DIN_sig <= instr_bits_to_mem & data_bits_to_mem;

    uSRAM_C_ADDR_sig <= std_logic_vector(to_unsigned(sequence_cnt, uSRAM_B_ADDR_sig'length)) when seq_enable = '1' else adr_to_mem;

    uSRAM_C_BLK_sig <= seq_write or bus_w_en;

    --=========================================================================
    
    p_sequence_run : process(PCLK, RSTn)
    begin

        if(RSTn = '0') then
            seq_state_cur <= idle;
            sequence_cnt <= 0;
            i2c_run <= '0';
            seq_write <= '0';
            seq_last_instr <= '0';
        elsif(rising_edge(PCLK)) then
            
            seq_write <= '0';
            case seq_state_cur is
                when idle =>
                    i2c_run <= '0';
                    i2c_write_d <= '0';
                    if(seq_enable = '1') then
                        if(i2c_ready = '1') then
                            if(seq_last_instr = '0') then
                                seq_state_cur <= do_instr;
                                if(sequence_cnt = g_auto_reg_max - 1) then
                                    -- this instruction will run but the next will not
                                    seq_last_instr <= '1';
                                end if;
                            else
                                seq_finished_sig <= '1';
                            end if;
                        end if;
                    else
                        -- seq_enable = 0, either finished or canceled by APB write
                        sequence_cnt <= 0;
                        seq_finished_sig <= '0';
                        seq_last_instr <= '0';
                    end if;
                when next_instr =>
                    -- increment sequence_cnt
                    -- (update address -> retrieve mem data) -> store in output FF
                    if(i2c_ready = '1') then
                        if(i2c_status_out_sig /= "11" and seq_last_instr = '0') then
                            -- status "11" indicates Ack error, redo data transaction
                            sequence_cnt <= sequence_cnt + 1;
                        end if;
                        seq_state_cur <= idle;
                    end if;
                when do_instr =>
                    case seq_instr is
                        when "00" =>    -- instruction "00" indicates No Operation
                            if(seq_last_instr = '1') then
                                seq_state_cur <= idle;
                            else
                                seq_state_cur <= next_instr;
                            end if;
                        when "01" =>  -- "01" indicates I2C Op
                            if(i2c_ready = '0') then
                                if(seq_last_instr = '1') then
                                    seq_state_cur <= idle;
                                else
                                    seq_state_cur <= next_instr;
                                end if;
                            end if;
                            i2c_run <= '1';
                        when "10" =>  -- "10" indicate write
                            if(i2c_ready = '0') then
                                if(seq_last_instr = '1') then
                                    seq_state_cur <= idle;
                                else
                                    seq_state_cur <= next_instr;
                                end if;
                            end if;
                            i2c_run <= '1';
                        when "11" =>    -- instruction "11" indicates Read, read from I2C on Op completion
                            if(i2c_ready = '0') then
                                seq_state_cur <= read_i2c;
                            end if;
                            i2c_write_d <= '1';
                            i2c_run <= '1';
                        when others =>
                            seq_state_cur <= idle;
                    end case;
                when read_i2c =>
                    if(i2c_ready = '1') then
                        seq_write <= '1';
                        if(mem_done_sig = '1') then
                            if(seq_last_instr = '1') then
                                seq_state_cur <= idle;
                            else
                                seq_state_cur <= next_instr;
                            end if;
                        end if;
                    end if;
                when others =>
                    -- how did you get here?
                    seq_state_cur <= idle;
            end case;
        end if;
    end process;

    i2c_ready <= '1' when i2c_status_out_sig = "00" or i2c_int = '1' else '0';
    seq_instr <= uSRAM_B_DOUT_sig(9 downto 8);  -- reg from p_read_B_port
    seq_data <= uSRAM_B_DOUT_sig(7 downto 0);   -- reg from p_read_B_port

    seq_finished <= seq_finished_sig;
    seq_count <= std_logic_vector(to_unsigned(sequence_cnt, seq_count'length));

    --=========================================================================

    -- architecture body
end architecture_I2C_Instruction_RAM;
