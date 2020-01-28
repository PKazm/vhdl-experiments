--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Core_APB3.vhd
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

entity I2C_Core_APB3 is
generic (
    g_auto_reg_max : natural := 64;
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

    --status_to_top : out std_logic_vector(1 downto 0);
    --i2c_int_to_top : out std_logic;

    trigger_seq : in std_logic
);
end I2C_Core_APB3;
architecture architecture_I2C_Core_APB3 of I2C_Core_APB3 is

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


    signal trigger_seq_last : std_logic;
    signal i2c_status_out_last : std_logic_vector(1 downto 0);
    signal seq_toggle : std_logic;

    -- I2C_instruction_RAM connection signals
    signal i2c_adr_to_mem : std_logic_vector(5 downto 0);
    signal i2c_data_to_mem : std_logic_vector(7 downto 0);
    signal i2c_bus_active : std_logic;
    signal i2c_bus_rw_instr : std_logic;
    signal i2c_bus_w_en : std_logic;
    signal i2c_mem_to_bus : std_logic_vector(7 downto 0);
    signal i2c_mem_done : std_logic;
    signal i2c_seq_enable : std_logic;
    signal i2c_seq_finished : std_logic;
    signal i2c_seq_count : std_logic_vector(5 downto 0);
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
    -- I2C_instruction_RAM connection signals

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

    component I2C_Instruction_RAM
        generic(
            g_auto_reg_max : natural;
            g_filter_length : natural
        );
        -- ports
        port( 
            PCLK : in std_logic;
            RSTn : in std_logic;

            adr_to_mem : in std_logic_vector(5 downto 0);
            data_to_mem : in std_logic_vector(7 downto 0);
            bus_active : in std_logic;
            bus_rw_instr : in std_logic;
            bus_w_en : in std_logic;

            mem_to_bus : out std_logic_vector(7 downto 0);
            mem_done : out std_logic;

            seq_enable : in std_logic;
            seq_finished : out std_logic;
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
    end component;

begin

    I2C_Instruction_RAM_0 : I2C_Instruction_RAM
        generic map(
            g_auto_reg_max => g_auto_reg_max,
            g_filter_length => g_filter_length
        )
        -- port map
        port map( 
            PCLK => PCLK,
            RSTn => RSTn,

            adr_to_mem => i2c_adr_to_mem,
            data_to_mem => i2c_data_to_mem,
            bus_active => i2c_bus_active,
            bus_rw_instr => i2c_bus_rw_instr,
            bus_w_en => i2c_bus_w_en,

            mem_to_bus => i2c_mem_to_bus,
            mem_done => i2c_mem_done,

            seq_enable => i2c_seq_enable,
            seq_finished => i2c_seq_finished,
            seq_count => i2c_seq_count,


            -- i2c signals passthrough
            i2c_initiate => i2c_initiate,
            i2c_instruct => i2c_instruct,
            i2c_clk_div_in => i2c_clk_div_in,
            i2c_bus_busy => i2c_bus_busy,
            i2c_int => i2c_int,
            i2c_status_out => i2c_status_out,
            i2c_data_in => i2c_data_in,
            i2c_data_out => i2c_data_out,
            -- i2c signals passthrough

            -- i2c bus passthrough
            SDAI => i2c_SDAI,
            SDAO => i2c_SDAO,
            SDAE => i2c_SDAE,

            SCLI => i2c_SCLI,
            SCLO => i2c_SCLO,
            SCLE => i2c_SCLE
            -- i2c bus passthrough
        );

    i2c_SDAI <= SDAI;
    SDAO <= i2c_SDAO;
    SDAE <= i2c_SDAE;
    i2c_SCLI <= SCLI;
    SCLO <= i2c_SCLO;
    SCLE <= i2c_SCLE;

    --=========================================================================
    -- BEGIN APB Register Read logic

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
                elsif(PADDR(7) = '1') then
                    -- RAM has a delay due to loading the output flipflops
                    -- APB order is PADDR > PSEL > PENABLE.
                    -- This 3 clock sequence should be long enought to load the FF
                    -- if not, add delay to PREADY from here (or handshake in I2C_Instruction_RAM)
                    if(PADDR(6) = '0') then
                        PRDATA_sig <= i2c_mem_to_bus(7 downto 0);
                    else
                        PRDATA_sig <= "000000" & i2c_mem_to_bus(1 downto 0);
                    end if;
                end if;
            else
                PRDATA_sig <= (others => '0');
            end if;
        end if;
    end process;

    -- BEGIN APB Return wires
    PRDATA <= PRDATA_sig;
    PREADY <= i2c_mem_done when PADDR(7) = '1' and PWRITE = '1' else '1'; --PREADY_sig;
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

    i2c_seq_enable <= i2c_reg_ctrl(4);
    i2c_initiate <= i2c_reg_ctrl(0);
    i2c_instruct <= i2c_reg_ctrl(3 downto 1);
    
    --=========================================================================

    p_reg_stat : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            --i2c_reg_stat <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = I2C_REG_STAT_ADDR) then
                -- status register is read only
                null;
            end if;
        end if;
    end process;

    i2c_reg_stat(7 downto 2) <= i2c_seq_count;
    i2c_reg_stat(1 downto 0) <= i2c_status_out;

    INT <= (i2c_int and not i2c_reg_ctrl(4)) or i2c_seq_finished;

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

    p_RAM_write : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            null;
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR(7) = '1' and PREADY = '0') then
                -- PWDATA and PADDR are always being read by the instruction_RAM
                -- this sets when they get acted upon
                i2c_bus_active <= '1';
            else
                i2c_bus_active <= '0';
            end if;
        end if;
    end process;

    i2c_adr_to_mem <= PADDR(5 downto 0) when PADDR(7) = '1' and PSEL = '1' else i2c_adr_to_mem;
    i2c_data_to_mem <= PWDATA;
    i2c_bus_rw_instr <= PADDR(6);
    i2c_bus_w_en <= not PREADY and i2c_bus_active;

    -- END Register Write logic
    --=========================================================================

    --status_to_top <= i2c_status_out;
    --i2c_int_to_top <= i2c_int;

   -- architecture body
end architecture_I2C_Core_APB3;
