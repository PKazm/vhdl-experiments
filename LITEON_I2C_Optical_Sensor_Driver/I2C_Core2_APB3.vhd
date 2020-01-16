--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Core2_APB3.vhd
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

entity I2C_Core2_APB3 is
generic (
    g_auto_reg_max : natural := 32;
    g_filter_length : natural := 3
);
port (
    PCLK : in std_logic;
    RSTn : in std_logic;

    -- APB connections
    PADDR : in std_logic_vector(7 downto 0);
    PSEL : in std_logic;
    PENABLE : in std_logic;
    PWRITE : in std_logic;
    PWDATA : in std_logic_vector(7 downto 0);
    PREADY : out std_logic;
    PRDATA : out std_logic_vector(7 downto 0);
    PSLVERR : out std_logic;

    INT : out std_logic;
    -- APB connections

    -- i2c passthrough connections
    SDAI : in std_logic;
    SDAO : out std_logic;
    SDAE : out std_logic;
    
    SCLI : in std_logic;
	SCLO : out std_logic;
    SCLE : out std_logic;
    -- i2c passthrough connections

    trigger_seq : std_logic
);
end I2C_Core2_APB3;
architecture architecture_I2C_Core2_APB3 of I2C_Core2_APB3 is

    -- BEGIN register signals
    constant I2C_REG_CTRL_ADDR : std_logic_vector(7 downto 0) := X"00";
    constant I2C_REG_STAT_ADDR : std_logic_vector(7 downto 0) := X"01";
    constant I2C_REG_CLK0_ADDR : std_logic_vector(7 downto 0) := X"02";
    constant I2C_REG_CLK1_ADDR : std_logic_vector(7 downto 0) := X"03";
    constant I2C_REG_DATI_ADDR : std_logic_vector(7 downto 0) := X"04";
    constant I2C_REG_DATO_ADDR : std_logic_vector(7 downto 0) := X"05";


    signal i2c_reg_ctrl : std_logic_vector(7 downto 0);
    signal i2c_reg_stat : std_logic_vector(7 downto 0);
    signal i2c_reg_clk : std_logic_vector(15 downto 0);
    signal i2c_reg_datI : std_logic_vector(7 downto 0);
    signal i2c_reg_datO : std_logic_vector(7 downto 0);

    --
    -- instruction sequence registers
    constant I2C_REGS_ADDR_START : std_logic_vector(7 downto 0) := "10000000";  -- X"80"
    type reg_seq_type is array(g_auto_reg_max - 1 downto 0) of std_logic_vector(9 downto 0);
    signal i2c_seq_regs : reg_seq_type;
    signal i2c_seq_written : std_logic_vector(9 downto 0);
    signal i2c_seq_selected : std_logic_vector(9 downto 0);
    -- END register signals

    signal trigger_seq_last : std_logic;
    signal i2c_status_out_last : std_logic_vector(1 downto 0);
    signal seq_toggle : std_logic;

    -- Sequence Instruction signals
    signal sequence_cnt : natural range 0 to g_auto_reg_max - 1 := 0;
    signal seq_enable : std_logic;
    signal seq_run : std_logic;
    signal seq_data : std_logic_vector(7 downto 0);
    signal seq_cmd : std_logic_vector(1 downto 0);
    signal seq_finished : std_logic;
    signal i2c_ready : std_logic_vector(1 downto 0);
    -- Sequence Instruction signals

    -- I2C_Core connection signals
    signal i2c_initiate : std_logic;
    signal i2c_instruct : std_logic_vector(2 downto 0);
    signal i2c_clk_div_in : std_logic_vector(15 downto 0);
    signal i2c_bus_busy : std_logic;
    signal i2c_int : std_logic;
    signal i2c_status_out : std_logic_vector(1 downto 0);
    signal i2c_data_in : std_logic_vector(7 downto 0);
    signal i2c_data_out : std_logic_vector(7 downto 0);
    signal i2c_SDAI : std_logic;
    signal i2c_SDAO : std_logic;
    signal i2c_SDAE : std_logic;
    signal i2c_SCLI : std_logic;
    signal i2c_SCLO : std_logic;
    signal i2c_SCLE : std_logic;
    -- I2C_Core connection signals

    -- BEGIN APB signals
    signal PADDR_sig : std_logic_vector(7 downto 0);
    signal PSEL_sig : std_logic;
    signal PENABLE_sig : std_logic;
    signal PWRITE_sig : std_logic;
    signal PWDATA_sig : std_logic_vector(7 downto 0);
    signal PREADY_sig : std_logic;
    signal PRDATA_sig : std_logic_vector(7 downto 0);
    signal PSLVERR_sig : std_logic;
    -- END APB signals

    component I2C_Core2
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

    I2C_Core2_0 : I2C_Core2
        generic map(
            g_filter_length => g_filter_length
        )
        -- port map
        port map( 
            PCLK => PCLK,
            RSTn => RSTn,

            -- control inputs
            initiate => i2c_initiate,
            instruct => i2c_instruct,
            clk_div_in => i2c_clk_div_in,
            -- control inputs

            -- status outputs
            i2c_bus_busy => i2c_bus_busy,
            i2c_int => i2c_int,
            status_out => i2c_status_out,
            -- status outputs

            -- data connections
            data_in => i2c_data_in,
            data_out => i2c_data_out,
            -- data connections

            -- I2C connections
            SDAI => i2c_SDAI,
            SDAO => i2c_SDAO,
            SDAE => i2c_SDAE,
            
            SCLI => i2c_SCLI,
            SCLO => i2c_SCLO,
            SCLE => i2c_SCLE
            -- I2C connections
        );

    i2c_SDAI <= SDAI;
    SDAO <= i2c_SDAO;
    SDAE <= i2c_SDAE;
    i2c_SCLI <= SCLI;
    SCLO <= i2c_SCLO;
    SCLE <= i2c_SCLE;

    --=========================================================================
    -- BEGIN APB Register Read logic
    gen_no_seq_APB_read_logic : if(g_auto_reg_max = 0) generate
        APB_Reg_Read_process : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                PRDATA_sig <= (others => '0');
            elsif(rising_edge(PCLK)) then
                if(PWRITE = '0' and PSEL = '1') then
                    case PADDR is
                        when I2C_REG_CTRL_ADDR =>
                            PRDATA_sig <= i2c_reg_ctrl;
                        when I2C_REG_STAT_ADDR =>
                            PRDATA_sig <= i2c_reg_stat;
                        when I2C_REG_CLK0_ADDR =>
                            PRDATA_sig <= i2c_reg_clk(7 downto 0);
                        when I2C_REG_CLK1_ADDR =>
                            PRDATA_sig <= i2c_reg_clk(15 downto 8);
                        when I2C_REG_DATI_ADDR =>
                            PRDATA_sig <= i2c_reg_datI;
                        when I2C_REG_DATO_ADDR =>
                            PRDATA_sig <= i2c_reg_datO;
                        when others =>
                            PRDATA_sig <= (others => '0');
                    end case;
                else
                    PRDATA_sig <= (others => '0');
                end if;
            end if;
        end process;
    end generate gen_no_seq_APB_read_logic;

    gen_seq_APB_read_logic : if(g_auto_reg_max > 0) generate
        process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
                PRDATA_sig <= (others => '0');
            elsif(rising_edge(PCLK)) then
                if(PWRITE = '0' and PSEL = '1') then
                    if(PADDR(7) = '0') then
                        case PADDR is
                            when I2C_REG_CTRL_ADDR =>
                                PRDATA_sig <= i2c_reg_ctrl;
                            when I2C_REG_STAT_ADDR =>
                                PRDATA_sig <= i2c_reg_stat;
                            when I2C_REG_CLK0_ADDR =>
                                PRDATA_sig <= i2c_reg_clk(7 downto 0);
                            when I2C_REG_CLK1_ADDR =>
                                PRDATA_sig <= i2c_reg_clk(15 downto 8);
                            when I2C_REG_DATI_ADDR =>
                                PRDATA_sig <= i2c_reg_datI;
                            when I2C_REG_DATO_ADDR =>
                                PRDATA_sig <= i2c_reg_datO;
                            when others =>
                                PRDATA_sig <= (others => '0');
                        end case;
                    else    -- PADDR(7) = 1, indicating sequence register
                        if(PADDR(6) = '0') then
                            PRDATA_sig <= i2c_seq_regs(to_integer(unsigned(PADDR(5 downto 0))))(7 downto 0);
                        else
                            PRDATA_sig <= "000000" & i2c_seq_regs(to_integer(unsigned(PADDR(5 downto 0))))(9 downto 8);
                        end if;
                    end if;
                else
                    PRDATA_sig <= (others => '0');
                end if;
            end if;
        end process;
    end generate gen_seq_APB_read_logic;

    -- BEGIN APB Return wires
    PRDATA <= PRDATA_sig;
    PREADY <= '1'; --PREADY_sig;
    PSLVERR <= '0';
    -- END APB Return wires

    -- END APB Register Read logic
    --=========================================================================
    -- BEGIN Register Write logic


    p_reg_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            i2c_reg_ctrl <= (others => '0');
            trigger_seq_last <= '0';
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = I2C_REG_CTRL_ADDR) then
                -- 7-5  : unused
                -- 4    : Initiate instruction sequence by setting to 1, cleared automatically
                -- 3-1  : I2C instruction, ignored if running from sequence
                -- 0    : rising edge (0 to 1) initiates I2C instruction (bits 3-1), ignored if running from sequence
                i2c_reg_ctrl <= "000" & PWDATA(4 downto 0);
            end if;
                trigger_seq_last <= trigger_seq;
                i2c_status_out_last <= i2c_status_out;
                if(trigger_seq_last = '0' and trigger_seq = '1') then
                    -- trigger pulse started instruction sequence
                    i2c_reg_ctrl(4) <= '1';-- if sequence complete, set 0, else no change,
                end if;

                if(i2c_status_out_last(1) = '0' and i2c_status_out(1) = '1') then
                    i2c_reg_ctrl(0) <= '0';
                end if;
        end if;
    end process;

    seq_enable <= i2c_reg_ctrl(4);
    i2c_initiate <= seq_run when seq_enable = '1' else i2c_reg_ctrl(0);
    i2c_instruct <= i2c_reg_ctrl(3 downto 1) when seq_enable = '0' else
                        seq_data(2 downto 0) when seq_cmd = "01" else
                                        "100" when seq_cmd = "10" else
                                        "101" when seq_cmd = "11" else
                                        "000";
    
    --=========================================================================

    p_reg_stat : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            --i2c_reg_stat <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = I2C_REG_STAT_ADDR) then
                null;
            end if;
        end if;
    end process;

    i2c_reg_stat(7 downto 2) <= std_logic_vector(to_unsigned(sequence_cnt, 6));
    i2c_reg_stat(1 downto 0) <= i2c_status_out;

    INT <= (i2c_int and not i2c_reg_ctrl(4)) or seq_finished;

    --=========================================================================

    p_reg_clk : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            i2c_reg_clk <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1') then
                case PADDR is
                    when I2C_REG_CLK0_ADDR =>
                        i2c_reg_clk(7 downto 0) <= PWDATA;
                    when I2C_REG_CLK1_ADDR =>
                        i2c_reg_clk(15 downto 8) <= PWDATA;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    i2c_clk_div_in <= i2c_reg_clk;

    --=========================================================================

    p_reg_data_in : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            i2c_reg_datI <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = I2C_REG_DATI_ADDR) then
                i2c_reg_datI <= PWDATA;
            end if;
        end if;
    end process;

    i2c_data_in <= i2c_reg_datI;

    --=========================================================================

    p_reg_data_out : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            --i2c_reg_datO <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = I2C_REG_DATO_ADDR) then
                null;
            end if;
        end if;
    end process;

    i2c_reg_datO <= i2c_data_out;

    --=========================================================================
    gen_seq_logic : if(g_auto_reg_max > 0) generate
        p_reg_instr_seq : process(PCLK, RSTn)
            --variable i2c_seq_selected :
            --i2c_seq_written
        begin
            if(RSTn = '0') then
                --for I in 0 to g_auto_reg_max - 1 loop
                --    i2c_seq_regs(I) <= "00" & X"00";
                --end loop;
                -- default to light sensor I'm using
                --i2c_seq_regs(0) <= "01" & "00000001";  -- start
                --i2c_seq_regs(1) <= "10" & "01010010";  -- optical sensor address + write
                --i2c_seq_regs(2) <= "10" & X"88";  -- optical sensor register address
                --i2c_seq_regs(3) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(4) <= "10" & "01010011";  -- optical sensor address + read
                --i2c_seq_regs(5) <= "11" & X"00";  -- sensor data
                --i2c_seq_regs(6) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(7) <= "10" & "01010010";  -- optical sensor address + write
                --i2c_seq_regs(8) <= "10" & X"89";  -- optical sensor register address
                --i2c_seq_regs(9) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(10) <= "10" & "01010011";  -- optical sensor address + read
                --i2c_seq_regs(11) <= "11" & X"00";  -- sensor data
                --i2c_seq_regs(12) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(13) <= "10" & "01010010";  -- optical sensor address + write
                --i2c_seq_regs(14) <= "10" & X"8A";  -- optical sensor register address
                --i2c_seq_regs(15) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(16) <= "10" & "01010011";  -- optical sensor address + read
                --i2c_seq_regs(17) <= "11" & X"00";  -- sensor data
                --i2c_seq_regs(18) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(19) <= "10" & "01010010";  -- optical sensor address + write
                --i2c_seq_regs(20) <= "10" & X"8B";  -- optical sensor register address
                --i2c_seq_regs(21) <= "01" & "00000011";  -- repeated start
                --i2c_seq_regs(22) <= "10" & "01010011";  -- optical sensor address + read
                --i2c_seq_regs(23) <= "11" & X"00";  -- sensor data
                --i2c_seq_regs(24) <= "01" & "00000010";  -- stop
                -- default to light sensor I'm using
                
            elsif(rising_edge(PCLK)) then
                if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR(7) = '1') then
                    if(PADDR(6) = '0') then
                        i2c_seq_regs(to_integer(unsigned(PADDR(5 downto 0))))(7 downto 0) <= PWDATA;
                    else
                        i2c_seq_regs(to_integer(unsigned(PADDR(5 downto 0))))(9 downto 8) <= PWDATA(1 downto 0);
                    end if;
                elsif(seq_enable = '1' and i2c_seq_regs(sequence_cnt)(9 downto 8) = "11" and i2c_status_out = "10") then
                    -- this register reads from I2C data_out when it is in a stable state after the I2C operation is complete
                    i2c_seq_regs(sequence_cnt)(7 downto 0) <= i2c_data_out;
                end if;
            end if;
        end process;
        i2c_seq_selected <= i2c_seq_regs(sequence_cnt);
        seq_data <= i2c_seq_selected(7 downto 0);
        seq_cmd <= i2c_seq_selected(9 downto 8);


        -- END Register Write logic
        --=========================================================================

        p_edge_triggers : process(PCLK, RSTn)
        begin
            if(RSTn = '0') then
            elsif(rising_edge(PCLK)) then
            end if;
        end process;

        p_sequence_run : process(PCLK, RSTn)
            -- WHAT IS THE CONDITION FOR THE SEQUENCE TO START?
            -- sequence running and i2c interrupt is high
            -- WHAT IS THE CONDITION FOR THE SEQUENCE TO do the next step?
            -- sequence running and i2c is idle (avoid sending multiple instructions)

            -- sequence must remain stable for the duration of the I2C operation (interrupt clear to interrupt set)
        begin
            if(RSTn = '0') then
                sequence_cnt <= 0;
                seq_finished <= '0';
                seq_run <= '0';
                i2c_ready(1) <= '0';
            elsif(rising_edge(PCLK)) then
                i2c_ready(1) <= i2c_ready(0);
                if(seq_enable = '1' and i2c_ready(1) = '0' and i2c_ready(0) = '1' and seq_run = '1') then
                    seq_run <= '0';
                    if(i2c_status_out = "11") then
                        -- ACK failed, repeat last instruction (don't increment sequence_cnt)
                        null;
                    elsif(sequence_cnt = g_auto_reg_max - 1) then
                        -- this check should occur AFTER the instruction selected by the incremented counter has run.
                        seq_finished <= '1';
                    else
                        sequence_cnt <= sequence_cnt + 1;
                    end if;
                elsif(seq_cmd = "00") then
                    if(sequence_cnt = g_auto_reg_max - 1) then
                        -- this check should occur AFTER the instruction selected by the incremented counter has run.
                        seq_finished <= '1';
                    else
                        sequence_cnt <= sequence_cnt + 1;
                    end if;
                elsif(seq_enable = '1' and i2c_ready(0) = '1' and seq_run <= '0') then
                    seq_run <= '1';
                end if;

                if(seq_enable = '0') then
                    seq_run <= '0';
                    seq_finished <= '0';
                    sequence_cnt <= 0;
                end if;
            end if;

        end process;

        i2c_ready(0) <= '1' when i2c_status_out = "00" or i2c_int = '1' else '0';
    end generate gen_seq_logic;


   -- architecture body
end architecture_I2C_Core2_APB3;
