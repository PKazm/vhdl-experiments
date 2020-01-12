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
    g_auto_reg_max : natural := 32
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

    --INT : out std_logic;
    -- APB connections

    -- i2c passthrough connections
    SDAI : in std_logic;
    SDAO : out std_logic;
    SDAE : out std_logic;
    
    SCLI : in std_logic;
	SCLO : out std_logic;
    SCLE : out std_logic;
    -- i2c passthrough connections

    trigger_auto : std_logic
);
end I2C_Core_APB3;
architecture architecture_I2C_Core_APB3 of I2C_Core_APB3 is

    -- BEGIN register signals
        -- pass through registers
        constant I2C_REG_CTRL_ADDR : std_logic_vector(7 downto 0) := X"00";
        constant I2C_REG_DATA_ADDR : std_logic_vector(7 downto 0) := X"01";
        constant I2C_REG_CLK0_ADDR : std_logic_vector(7 downto 0) := X"02";
        constant I2C_REG_CLK1_ADDR : std_logic_vector(7 downto 0) := X"03";

        signal ctrl_in : std_logic_vector(7 downto 0);
        signal ctrl_out : std_logic_vector(7 downto 0);
        signal data_in : std_logic_vector(7 downto 0);
        signal data_out : std_logic_vector(7 downto 0);
        signal clk_div_in : std_logic_vector(15 downto 0);
        signal clk_div_out : std_logic_vector(15 downto 0);

        signal reg_update : std_logic;
        -- pass through registers

    constant I2C_AUTO_CTRL_ADDR : std_logic_vector(7 downto 0) := X"10";

    signal auto_ctrl : std_logic_vector(7 downto 0);
    --
    -- data registers
    constant I2C_REGS_ADDR_START : std_logic_vector(7 downto 0) := "10000000";  -- X"80"
    type reg_auto_type is array(g_auto_reg_max - 1 downto 0) of std_logic_vector(9 downto 0);
    signal i2c_auto_regs : reg_auto_type;
    -- END register signals

    signal sequence_cnt : natural range 0 to g_auto_reg_max - 1 := 0;
    signal interrupt : std_logic;
    signal trigger_auto_last : std_logic;
    signal seq_toggle : std_logic;
    signal seq_finished : std_logic;

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

    I2C_Core_0 : I2C_Core
        -- port map
        port map( 
            -- Inputs
            PCLK => PCLK,
            RSTn => RSTn,
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

    --=========================================================================
    -- BEGIN APB Register Read logic
    APB_Reg_Read_process: process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            prdata_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PWRITE = '0' and PSEL = '1') then
                if(PADDR(7) = '0') then
                    case PADDR is
                        when I2C_REG_CTRL_ADDR =>
                            prdata_sig <= ctrl_out;
                        when I2C_REG_DATA_ADDR =>
                            prdata_sig <= data_out;
                        when I2C_REG_CLK0_ADDR =>
                            prdata_sig <= clk_div_out(7 downto 0);
                        when I2C_REG_CLK1_ADDR =>
                            prdata_sig <= clk_div_out(15 downto 8);
                        when I2C_AUTO_CTRL_ADDR =>
                            prdata_sig <= auto_ctrl;
                        when others =>
                            prdata_sig <= (others => '0');
                    end case;
                else    -- PADDR(7) = 1, indicating sequence register
                    if(PADDR(6) = '0') then
                        prdata_sig <= i2c_auto_regs(to_integer(unsigned(PADDR(5 downto 0))))(7 downto 0);
                    else
                        prdata_sig <= "000000" & i2c_auto_regs(to_integer(unsigned(PADDR(5 downto 0))))(9 downto 8);
                    end if;
                end if;
            else
                prdata_sig <= (others => '0');
            end if;
        end if;
    end process;

    -- BEGIN APB Return wires
    PRDATA <= prdata_sig;
    PREADY <= '1'; --pready_sig;
    PSLVERR <= '0';
    -- END APB Return wires

    -- END APB Register Read logic
    --=========================================================================
    -- BEGIN Register Write logic

    p_i2c_passthrough_reg : process(PCLK, RSTn)
        variable selected_seq_reg : std_logic_vector(9 downto 0) := (others => '0');
    begin
        if(RSTn = '0') then
            ctrl_in <= "00000000";
            data_in <= "00000000";
            clk_div_in <= (others => '0');
            seq_finished <= '0';
            sequence_cnt <= 0;
            reg_update <= '0';
            seq_toggle <= '0';
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1') then
                case PADDR is
                    when I2C_REG_CTRL_ADDR =>
                        reg_update <= '1';
                        ctrl_in <= PWDATA;      -- Read only bits are masked inside I2C_Core
                        data_in <= data_out;
                        clk_div_in <= clk_div_out;
                    when I2C_REG_DATA_ADDR =>
                        reg_update <= '1';
                        ctrl_in <= ctrl_out;
                        data_in <= PWDATA;
                        clk_div_in <= clk_div_out;
                    when I2C_REG_CLK0_ADDR =>
                        reg_update <= '1';
                        ctrl_in <= ctrl_out;
                        data_in <= data_out;
                        clk_div_in <= clk_div_out(15 downto 8) & PWDATA;
                    when I2C_REG_CLK1_ADDR =>
                        reg_update <= '1';
                        ctrl_in <= ctrl_out;
                        data_in <= data_out;
                        clk_div_in <= PWDATA & clk_div_out(7 downto 0);
                    when others =>
                        null;
                end case;
            elsif(auto_ctrl(1 downto 0) = "11" and ctrl_out(0) = '1') then
                -- Auto sequence is enabled and initiated
                -- I2C core is enabled


                if((ctrl_out(6 downto 5) = "00" and sequence_cnt = 0) or
                    (ctrl_out(6) = '1' and seq_toggle = '0' and sequence_cnt /= 0)) then
                    -- I2C_core is idle and sequence count is at the start
                    -- I2C_core is waiting and sequence count is not at the start
                    report "SEQUENCE DOING A THING: " & to_string(sequence_cnt);
                    selected_seq_reg := i2c_auto_regs(sequence_cnt);
                    seq_toggle <= '1';
                    if(selected_seq_reg(9) = '1') then
                        -- data write/read
                        data_in <= selected_seq_reg(7 downto 0);
                        ctrl_in <= "000" & selected_seq_reg(9) & '0' & selected_seq_reg(8) & "1" & ctrl_out(0);
                        clk_div_in <= clk_div_out;
                        reg_update <= '1';
                    elsif(selected_seq_reg(8) = '1') then
                        -- i2c START, STOP, etc.
                        data_in <= data_out;
                        ctrl_in <= "000" & '0' & selected_seq_reg(1 downto 0) & "1" & ctrl_out(0);
                        clk_div_in <= clk_div_out;
                        reg_update <= '1';
                    end if;

                    if(sequence_cnt = g_auto_reg_max - 1) then
                        seq_finished <= '1';
                    else
                        sequence_cnt <= sequence_cnt + 1;
                    end if;
                else
                    reg_update <= '0';
                    if(ctrl_out(6) = '0') then
                        seq_toggle <= '0';
                    end if;
                end if;
            else
                seq_finished <= '0';
                sequence_cnt <= 0;
                reg_update <= '0';
            end if;
        end if;
    end process;

    p_reg_auto_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            auto_ctrl(1 downto 0) <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = I2C_AUTO_CTRL_ADDR) then
                auto_ctrl(1 downto 0) <= PWDATA(1 downto 0);
            else
                if(trigger_auto_last = '0' and trigger_auto = '1' and auto_ctrl(0) = '1') then
                    auto_ctrl(1) <= '1';
                elsif(seq_finished = '1') then
                    auto_ctrl(1) <= '0';
                end if;
            end if;
        end if;
    end process;

    p_reg_auto_sequence : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            for I in 0 to g_auto_reg_max - 1 loop
                i2c_auto_regs(I) <= "00" & X"00";
            end loop;
            -- default to light sensor I'm using
            --i2c_auto_regs(0) <= "01" & "00000001";  -- start
            --i2c_auto_regs(1) <= "10" & "01010010";  -- optical sensor address + write
            --i2c_auto_regs(2) <= "10" & X"88";  -- optical sensor register address
            --i2c_auto_regs(3) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(4) <= "10" & "01010011";  -- optical sensor address + read
            --i2c_auto_regs(5) <= "11" & X"00";  -- sensor data
            --i2c_auto_regs(6) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(7) <= "10" & "01010010";  -- optical sensor address + write
            --i2c_auto_regs(8) <= "10" & X"89";  -- optical sensor register address
            --i2c_auto_regs(9) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(10) <= "10" & "01010011";  -- optical sensor address + read
            --i2c_auto_regs(11) <= "11" & X"00";  -- sensor data
            --i2c_auto_regs(12) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(13) <= "10" & "01010010";  -- optical sensor address + write
            --i2c_auto_regs(14) <= "10" & X"8A";  -- optical sensor register address
            --i2c_auto_regs(15) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(16) <= "10" & "01010011";  -- optical sensor address + read
            --i2c_auto_regs(17) <= "11" & X"00";  -- sensor data
            --i2c_auto_regs(18) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(19) <= "10" & "01010010";  -- optical sensor address + write
            --i2c_auto_regs(20) <= "10" & X"8B";  -- optical sensor register address
            --i2c_auto_regs(21) <= "01" & "00000011";  -- repeated start
            --i2c_auto_regs(22) <= "10" & "01010011";  -- optical sensor address + read
            --i2c_auto_regs(23) <= "11" & X"00";  -- sensor data
            --i2c_auto_regs(24) <= "01" & "00000010";  -- stop
            -- default to light sensor I'm using
            
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR(7) = '1') then
                if(PADDR(6) = '0') then
                    i2c_auto_regs(to_integer(unsigned(PADDR(5 downto 0))))(7 downto 0) <= PWDATA;
                else
                    i2c_auto_regs(to_integer(unsigned(PADDR(5 downto 0))))(9 downto 8) <= PWDATA(1 downto 0);
                end if;
            else
                null;
            end if;
        end if;
    end process;



    -- END Register Write logic
    --=========================================================================

    p_edge_FF_chains : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            trigger_auto_last <= '0';
        elsif(rising_edge(PCLK)) then
            trigger_auto_last <= trigger_auto;
        end if;
    end process;

    --p_run_sequence : process(PCLK, RSTn)
    --    variable selected_seq_reg : std_logic_vector(9 downto 0) := (others => '0');
    --begin
    --    if(RSTn = '0') then
    --        seq_finished <= '0';
    --        sequence_cnt <= 0;
    --    elsif(rising_edge(PCLK)) then
    --        if(auto_ctrl(1 downto 0) = "11" and ctrl_out(0) = '1') then
    --            -- Auto sequence is enabled and initiated
    --            -- I2C core is enabled
--
--
    --            if((ctrl_out(6 downto 5) = "00" and sequence_cnt = 0) or
    --                (ctrl_out(6) = '1' and sequence_cnt /= 0)) then
    --                -- I2C_core is idle and sequence count is at the start
    --                -- I2C_core is waiting and sequence count is not at the start
--
    --                selected_seq_reg := i2c_auto_regs(sequence_cnt);
    --                if(selected_seq_reg(9) = '1') then
    --                    -- data write/read
    --                    data_in <= selected_seq_reg(7 downto 0);
    --                    ctrl_in <= "000" & selected_seq_reg(9) & '0' & selected_seq_reg(8) & "1" & ctrl_out(0);
    --                    clk_div_in <= clk_div_out;
    --                    reg_update <= '1';
    --                elsif(selected_seq_reg(8) = '1') then
    --                    -- i2c START, STOP, etc.
    --                    data_in <= data_out;
    --                    ctrl_in <= "000" & '0' & selected_seq_reg(1 downto 0) & "1" & ctrl_out(0);
    --                    clk_div_in <= clk_div_out;
    --                    reg_update <= '1';
    --                end if;
--
    --                if(sequence_cnt = g_auto_reg_max - 1) then
    --                    seq_finished <= '1';
    --                else
    --                    sequence_cnt <= sequence_cnt + 1;
    --                end if;
    --            else
    --                reg_update <= '0';
    --            end if;
    --        else
    --            seq_finished <= '0';
    --            sequence_cnt <= 0;
    --        end if;
    --    end if;
    --end process;

    auto_ctrl(7 downto 2) <= std_logic_vector(to_unsigned(sequence_cnt, 6));


   -- architecture body
end architecture_I2C_Core_APB3;
