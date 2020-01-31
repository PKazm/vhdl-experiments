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


    -- RAM control signals
    adr_to_mem : in std_logic_vector(5 downto 0);
    mem_instr_sel : in std_logic;
    bus_w_en : in std_logic;
    bus_op_req : in std_logic;
    
    mem_done : out std_logic;
    -- RAM control signals
    -- RAM write signals
    bus_to_mem : in std_logic_vector(7 downto 0);
    -- RAM write signals
    -- RAM read signals
    mem_to_bus : out std_logic_vector(7 downto 0);
    -- RAM read signals

    -- sequence control signals
    seq_enable : in std_logic;      -- held high until seq_finished = '1'.
    seq_finished : out std_logic;   -- this is basically the sequence interrupt
    -- seq_cnt_out can either align with the extra bits from I2C status (8 - 2 = 6)
    -- essentially a limit so all status bits are in 1 "register" length
    -- or 
    -- match the address range or match the reg_max generic
    seq_cnt_out : out std_logic_vector(5 downto 0);
    -- sequence control signals

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
    type reg_seq_type is array((g_auto_reg_max * 2) - 1 downto 0) of std_logic_vector(7 downto 0);
    signal i2c_seq_regs : reg_seq_type;


    -- A accesses instruction locations
    signal uSRAM_A_ADDR_sig : std_logic_vector(6 downto 0);
    signal uSRAM_A_DOUT_sig : std_logic_vector(7 downto 0);
    signal ram_instr_out : std_logic_vector(7 downto 0);
    -- B accesses data locations
    signal uSRAM_B_ADDR_sig : std_logic_vector(6 downto 0);
    signal uSRAM_B_DOUT_sig : std_logic_vector(7 downto 0);
    signal ram_data_out : std_logic_vector(7 downto 0);
    -- C writes from the APB bus and the sequence logic
    signal uSRAM_C_WEN_sig : std_logic;
    signal uSRAM_C_ADDR_sig : std_logic_vector(6 downto 0);
    signal uSRAM_C_DIN_sig : std_logic_vector(7 downto 0);

    signal ram_addr_selected : std_logic_vector(5 downto 0);
    signal C_w_instr : std_logic;
    signal write_en : std_logic;
    signal mem_op_req : std_logic;
    signal mem_delay_cnt : unsigned(1 downto 0);
    signal mem_done_sig : std_logic;
    -- seq RAM

    -- seq control signals
    type seq_states is(idle, next_instr, do_instr, read_i2c);
    signal seq_state_cur : seq_states;
    signal seq_instr_timeout : natural range 0 to 3 := 3;   -- limits the number of times an instruction can repeat: "watchdog"
    signal sequence_cnt : natural range 0 to g_auto_reg_max - 1 := 0;

    signal seq_instr : std_logic_vector(2 downto 0);
    signal seq_data : std_logic_vector(7 downto 0);
    signal i2c_ready : std_logic;
    signal i2c_run : std_logic;
    signal i2c_write_d : std_logic;
    signal seq_write : std_logic;
    signal seq_last_instr : std_logic;
    signal seq_selected : std_logic;
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

    -- passthrough I2C bus connections
    i2c_SDAI_sig <= SDAI;
    SDAO <= i2c_SDAO_sig;
    SDAE <= i2c_SDAE_sig;
    i2c_SCLI_sig <= SCLI;
    SCLO <= i2c_SCLO_sig;
    SCLE <= i2c_SCLE_sig;
    -- passthrough I2C bus connections

    g_no_instr_ram : if(g_auto_reg_max = 0) generate
        -- passthrough I2C control signals
            -- signals from the bus to I2C
            i2c_initiate_sig <= i2c_initiate;
            i2c_instruct_sig <= i2c_instruct;
            i2c_clk_div_in_sig <= i2c_clk_div_in;
            i2c_data_in_sig <= i2c_data_in;
            
            -- signals from I2C to the bus
            i2c_bus_busy <= i2c_bus_busy_sig;
            i2c_int <= i2c_int_sig;
            i2c_status_out <= i2c_status_out_sig;
            i2c_data_out <= i2c_data_out_sig;
        -- passthrough I2C control signals

        mem_to_bus <= (others => '0');
        mem_done <= '1';

        seq_finished <= '0';
        seq_cnt_out <= (others => '0');
    end generate g_no_instr_ram;

    g_yes_instr_ram : if(g_auto_reg_max > 0) generate
        -- passthrough I2C control signals
            -- signals from the bus to I2C
            i2c_initiate_sig <= i2c_run when seq_selected = '1' else i2c_initiate;
            i2c_instruct_sig <= ram_instr_out(2 downto 0) when seq_selected = '1'  else i2c_instruct;
            i2c_clk_div_in_sig <= i2c_clk_div_in;
            i2c_data_in_sig <= ram_data_out when seq_selected = '1' else i2c_data_in;
            
            -- signals from I2C to the bus
            i2c_bus_busy <= i2c_bus_busy_sig;
            i2c_int <= i2c_int_sig;
            i2c_status_out <= i2c_status_out_sig;
            i2c_data_out <= i2c_data_out_sig;
        -- passthrough I2C control signals

        --=========================================================================
        -- A port is used to read the instruction portion of a RAM location
        -- B port is used to read the data portion of a RAM location
        p_ram_stuff : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                ram_data_out <= (others => '0');
                ram_instr_out <= (others => '0');

                mem_delay_cnt <= (others => '0');
            elsif(rising_edge(PCLK)) then
                ram_data_out <= uSRAM_B_DOUT_sig;
                ram_instr_out <= uSRAM_A_DOUT_sig;

                if(uSRAM_C_WEN_sig = '1') then
                    case C_w_instr is
                        when '0' =>
                            -- write data
                            i2c_seq_regs(to_integer(unsigned(uSRAM_C_ADDR_sig))) <= uSRAM_C_DIN_sig;
                        when '1' =>
                            -- write instruction
                            i2c_seq_regs(to_integer(unsigned(uSRAM_C_ADDR_sig))) <= "00000" & uSRAM_C_DIN_sig(2 downto 0);
                        when others =>
                            -- C_w_instr is boolean, how did you get here?
                            null;
                    end case;
                end if;

                if(mem_op_req = '1' and mem_done_sig = '0') then
                    if(mem_delay_cnt = "10") then
                        null;
                        -- write enable would be here but its set by combinational logic below.
                    else
                        mem_delay_cnt <= mem_delay_cnt + 1;
                    end if;
                elsif(mem_op_req = '0') then
                    mem_delay_cnt <= (others => '0');
                end if;
            end if;
        end process;

        -- intermediate signal assignements
        seq_selected <= seq_enable and not seq_finished_sig;
        ram_addr_selected <= std_logic_vector(to_unsigned(sequence_cnt, ram_addr_selected'length))
                                    when seq_selected = '1' else adr_to_mem;
        mem_op_req <= seq_write when seq_selected = '1' else bus_op_req;
        C_w_instr <= '0' when seq_selected = '1' else mem_instr_sel;
        -- intermediate signal assignements

        uSRAM_A_ADDR_sig <= ram_addr_selected & '1';
        uSRAM_A_DOUT_sig <= i2c_seq_regs(to_integer(unsigned(uSRAM_A_ADDR_sig)));
        uSRAM_B_ADDR_sig <= ram_addr_selected & '0';
        uSRAM_B_DOUT_sig <= i2c_seq_regs(to_integer(unsigned(uSRAM_B_ADDR_sig)));

        uSRAM_C_ADDR_sig <= ram_addr_selected & C_w_instr;

        uSRAM_C_DIN_sig <= i2c_data_out_sig when seq_selected = '1' else bus_to_mem;

        -- assuming ADDR and DATA are stable upon mem_op_req rising to 1
        -- this should give an immediate pulse which gets set low on the first clock rise
        -- gotta save that time so I can be idle longer.
        write_en <= seq_write when seq_selected = '1' else bus_w_en;
        uSRAM_C_WEN_sig <= write_en and mem_op_req and not mem_delay_cnt(0) and not mem_delay_cnt(1);

        mem_done_sig <= mem_delay_cnt(1);
        mem_done <= mem_done_sig;
        mem_to_bus <= ram_instr_out when mem_instr_sel = '1' else ram_data_out;

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
                            when "000" =>    -- instruction "00" indicates No Operation
                                if(seq_last_instr = '1') then
                                    seq_state_cur <= idle;
                                else
                                    seq_state_cur <= next_instr;
                                end if;
                            when "001" =>  -- "01" indicates I2C Op
                                if(i2c_ready = '0') then
                                    if(seq_last_instr = '1') then
                                        seq_state_cur <= idle;
                                    else
                                        seq_state_cur <= next_instr;
                                    end if;
                                end if;
                                i2c_run <= '1';
                            when "010" =>  -- "01" indicates I2C Op
                                if(i2c_ready = '0') then
                                    if(seq_last_instr = '1') then
                                        seq_state_cur <= idle;
                                    else
                                        seq_state_cur <= next_instr;
                                    end if;
                                end if;
                                i2c_run <= '1';
                            when "011" =>  -- "01" indicates I2C Op
                                if(i2c_ready = '0') then
                                    if(seq_last_instr = '1') then
                                        seq_state_cur <= idle;
                                    else
                                        seq_state_cur <= next_instr;
                                    end if;
                                end if;
                                i2c_run <= '1';
                            when "100" =>  -- "10" indicate write
                                if(i2c_ready = '0') then
                                    if(seq_last_instr = '1') then
                                        seq_state_cur <= idle;
                                    else
                                        seq_state_cur <= next_instr;
                                    end if;
                                end if;
                                i2c_run <= '1';
                            when "101" =>    -- instruction "11" indicates Read, read from I2C on Op completion
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
        seq_instr <= ram_instr_out(2 downto 0);
        seq_data <= ram_data_out;

        seq_finished <= seq_finished_sig;
        seq_cnt_out <= std_logic_vector(to_unsigned(sequence_cnt, seq_cnt_out'length));
    end generate g_yes_instr_ram;

    --=========================================================================

    -- architecture body
end architecture_I2C_Instruction_RAM;
