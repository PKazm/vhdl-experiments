--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Core.vhd
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

entity I2C_Core is
port (
    PCLK : in std_logic;
    RSTn : in std_logic;
    
    -- register connections
    reg_update : in std_logic;
    ctrl_in : in std_logic_vector(7 downto 0);
    ctrl_out : out std_logic_vector(7 downto 0);
    data_in : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0);
    clk_div_in : in std_logic_vector(15 downto 0);
    clk_div_out : out std_logic_vector(15 downto 0);
    -- register connections

    interrupt : out std_logic;
    
    -- I2C connections
    SDAI : in std_logic;
    SDAO : out std_logic;
    SDAE : out std_logic;
    
    SCLI : in std_logic;
	SCLO : out std_logic;
    SCLE : out std_logic
    -- I2C connections
);
end I2C_Core;
architecture architecture_I2C_Core of I2C_Core is


    type i2c_states is(idle, start, stop, data, rstart, ack);
    signal i2c_state_cur : i2c_states;
    type i2c_status_states is(none, pause, start, rstart, stop, slawack, slawnack, dataack, datanack, arblost);
    signal i2c_status_cur : i2c_status_states;
    signal i2c_status_last : i2c_status_states;

    signal CLK_I2C_sig : std_logic;
    --signal CLK_I2C_sig_last : std_logic;
    signal CLK_I2C_write_readnot_sig : std_logic_vector(1 downto 0);
    signal CLK_I2C_write_sig : std_logic;
    signal CLK_I2C_read_sig : std_logic;

    -- i2c_counter is used within each i2c_state to determine points to manipulate SDA and SCL
    signal i2c_counter : unsigned(1 downto 0);
    signal i2c_counter_pulse : std_logic;
    signal state_started : std_logic;
    -- bit_counter is used to count bits during data read/write
    signal bit_counter : unsigned(2 downto 0);
    -- i2c_shift_reg stores data to read/write
    signal i2c_shift_reg : std_logic_vector(7 downto 0);
    signal i2c_ack_sig : std_logic;
    signal op_finished : std_logic;
    
    -- BEGIN I2C signals
    signal SDAI_sig : std_logic;
    signal SDAO_sig : std_logic;
    signal SDAE_sig : std_logic;
    signal SCLI_sig : std_logic;
    signal SCLO_sig : std_logic;
    signal SCLE_sig : std_logic;

    -- vectors are updated at the frequency of PCLK
    signal SDAI_sig_v : std_logic_vector(2 downto 0);
    signal SCLI_sig_v : std_logic_vector(2 downto 0);
    signal SCLO_sig_v : std_logic_vector(1 downto 0);
    -- END I2C signals

    -- BEGIN register signals
    signal i2c_reg_ctrl : std_logic_vector(7 downto 0);

    signal i2c_data : std_logic_vector(7 downto 0);
    signal i2c_clk_div : std_logic_vector(15 downto 0);
    -- END register signals

begin

    --=========================================================================

    p_update_reg_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            i2c_reg_ctrl(4 downto 0) <= (others => '0');
            i2c_clk_div <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(reg_update = '1') then
                --i2c_reg_ctrl(7) <= ctrl_in(7);        -- R : I2C bus busy status
                --i2c_reg_ctrl(6) <= ctrl_in(6);        -- R : status bit1
                --i2c_reg_ctrl(5) <= ctrl_in(5);        -- R : status bit0
                i2c_reg_ctrl(4) <= ctrl_in(4);      -- W : Operation bit2
                i2c_reg_ctrl(3) <= ctrl_in(3);      -- W : Operation bit1
                i2c_reg_ctrl(2) <= ctrl_in(2);      -- W : Operation bit0
                i2c_reg_ctrl(1) <= ctrl_in(1);      -- W : Core event Intialization
                i2c_reg_ctrl(0) <= ctrl_in(0);      -- W : Core Enable/Disable

                i2c_clk_div <= clk_div_in;      -- divide intended i2c clk div by 4 to generate intermediate points
            elsif(op_finished = '1') then
                i2c_reg_ctrl(1) <= '0';
            end if;
        end if;
    end process;

    ctrl_out <= i2c_reg_ctrl;
    data_out <= i2c_data;
    clk_div_out <= i2c_clk_div;


    p_i2c_busy_monitor : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            -- if the bus is busy during this device's reset, well I'm not sure then. Maybe check for other activity.
            i2c_reg_ctrl(7) <= '0';
        elsif(rising_edge(PCLK)) then
            SDAI_sig_v <= SDAI_sig_v(1 downto 0) & SDAI_sig;
            SCLI_sig_v <= SCLI_sig_v(1 downto 0) & SCLI_sig;

            if(SDAI_sig_v(1) = '1' and SDAI_sig_v(0) = '0' and SCLI_sig_v(1) = '1' and SCLI_sig_v(0) = '1') then
                i2c_reg_ctrl(7) <= '1';
            elsif(SDAI_sig_v(1) = '0' and SDAI_sig_v(0) = '1' and SCLI_sig_v(1) = '1' and SCLI_sig_v(0) = '1') then
                i2c_reg_ctrl(7) <= '0';
            end if;
        end if;
    end process;

    p_i2c_clock_gen :process(PCLK, RSTn)
        variable i2c_clk_cnt : unsigned(15 downto 0);
    begin
        if(RSTn = '0') then
            i2c_clk_cnt := (others => '0');
            --i2c_counter <= (others => '1');
            i2c_counter_pulse <= '1';
        elsif(rising_edge(PCLK)) then
            if(i2c_reg_ctrl(6 downto 5) /= "00") then
                if(i2c_clk_cnt = shift_right(unsigned(i2c_clk_div), 2)) then
                    i2c_clk_cnt := (others => '0');
                    --i2c_counter <= i2c_counter + 1;
                    i2c_counter_pulse <= '1';
                else
                    i2c_clk_cnt := i2c_clk_cnt + 1;
                    if(state_started = '1') then
                        i2c_counter_pulse <= '0';
                    end if;
                end if;
            else
                i2c_clk_cnt := (others => '0');
                --i2c_counter <= (others => '1');
                i2c_counter_pulse <= '1';
            end if;
        end if;
    end process;

    p_i2c_data_state_machine : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            i2c_state_cur <= idle;
            i2c_shift_reg <= (others => '0');
            i2c_ack_sig <= '0';
            i2c_reg_ctrl(6 downto 5) <= "00";
            i2c_data <= (others => '0');
            SDAO_sig <= '0';
            SDAE_sig <= '0';
            SCLO_sig <= '0';
            SCLE_sig <= '0';
            state_started <= '0';
            i2c_counter <= (others => '0');
            bit_counter <= (others => '0');
            op_finished <= '0';
        elsif(rising_edge(PCLK)) then
            case i2c_state_cur is
                when idle =>
                    if(i2c_reg_ctrl(6 downto 5) = "00") then
                        SDAE_sig <= '0';
                        SCLE_sig <= '0';
                    else
                        --SDAE_sig <= '1';
                        --SCLE_sig <= '1';
                    end if;
                    bit_counter <= (others => '0');
                    op_finished <= '0';
                    if(reg_update = '1') then
                        i2c_data <= data_in;
                    end if;

                    if(i2c_reg_ctrl(1) = '1' and i2c_reg_ctrl(0) = '1' and op_finished = '0')then
                        -- I2C bus is not busy and either controller has started I2C packet or Polling timer has triggered
                        i2c_reg_ctrl(6 downto 5) <= "01";
                        i2c_counter <= (others => '0');
                        case i2c_reg_ctrl(4 downto 2) is
                            when "000" =>   -- No Operation
                                -- not sure what to do here but there's extra bits and stuff
                            when "001" =>   -- Start
                                i2c_state_cur <= start;
                            when "010" =>   -- Stop
                                i2c_state_cur <= stop;
                            when "011" =>   -- Repeated Start
                                i2c_state_cur <= rstart;
                            when "100" =>   -- Transmit (write) Data
                                i2c_state_cur <= data;
                            when "101" =>   -- Receive (read) Data
                                i2c_state_cur <= data;
                            when others =>
                                -- unintentional No Operation
                        end case;
                    end if;
                when start =>
                    SDAE_sig <= '1';
                    SCLE_sig <= '1';
                    if(i2c_counter_pulse = '1' and state_started = '0') then
                        state_started <= '1';
                        i2c_counter <= i2c_counter + 1;
                        case i2c_counter is
                            when "00" =>
                                SDAO_sig <= '1';
                                SCLO_sig <= '1';
                            when "01" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '1';
                            when "10" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '1';
                            when "11" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '0';
                                i2c_state_cur <= idle;
                                i2c_reg_ctrl(6 downto 5) <= "10";
                                op_finished <= '1';
                            when others =>
                                -- its only 2 bits, how did you get here?
                                null;
                        end case;
                    else
                        state_started <= '0';
                    end if;
                when stop =>
                    SDAE_sig <= '1';
                    SCLE_sig <= '1';
                    if(i2c_counter_pulse = '1' and state_started = '0') then
                        state_started <= '1';
                        i2c_counter <= i2c_counter + 1;
                        case i2c_counter is
                            when "00" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '0';
                            when "01" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '1';
                            when "10" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '1';
                            when "11" =>
                                SDAO_sig <= '1';
                                SCLO_sig <= '1';
                                i2c_state_cur <= idle;
                                i2c_reg_ctrl(6 downto 5) <= "00";
                                op_finished <= '1';
                            when others =>
                                -- its only 2 bits, how did you get here?
                                null;
                        end case;
                    else
                        state_started <= '0';
                    end if;
                when rstart =>
                    SDAE_sig <= '1';
                    SCLE_sig <= '1';
                    if(i2c_counter_pulse = '1' and state_started = '0') then
                        state_started <= '1';
                        i2c_counter <= i2c_counter + 1;
                        case i2c_counter is
                            when "00" =>
                                SDAO_sig <= '1';
                                SCLO_sig <= '0';
                            when "01" =>
                                SDAO_sig <= '1';
                                SCLO_sig <= '1';
                            when "10" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '1';
                            when "11" =>
                                SDAO_sig <= '0';
                                SCLO_sig <= '0';
                                i2c_state_cur <= idle;
                                i2c_reg_ctrl(6 downto 5) <= "10";
                                op_finished <= '1';
                            when others =>
                                -- its only 2 bits, how did you get here?
                                null;
                        end case;
                    else
                        state_started <= '0';
                    end if;
                when data =>
                    -- SDAE is result of Ctrl OP bits. "100" indicating Write, "101" indicating Read
                    -- SDAO will be updated regardless so SDAE must be the gatekeeper to keep it off the bus during Reads
                    SDAE_sig <= i2c_reg_ctrl(4) and not i2c_reg_ctrl(3) and not i2c_reg_ctrl(2);
                    SCLE_sig <= '1';
                    if(i2c_counter_pulse = '1' and state_started = '0') then
                        state_started <= '1';
                        i2c_counter <= i2c_counter + 1;
                        case i2c_counter is
                            when "00" =>
                                SDAO_sig <= i2c_data(7);
                                SCLO_sig <= '0';
                                i2c_data <= i2c_data(6 downto 0) & '0';
                            when "01" =>
                                SDAO_sig <= SDAO_sig;
                                SCLO_sig <= '1';
                                i2c_data(0) <= SDAI_sig;
                            when "10" =>
                                SDAO_sig <= SDAO_sig;
                                SCLO_sig <= '1';
                            when "11" =>
                                SDAO_sig <= SDAO_sig;
                                SCLO_sig <= '0';
                                bit_counter <= bit_counter + 1;
                            when others =>
                                -- its only 2 bits, how did you get here?
                                null;
                        end case;
                    else
                        if(bit_counter = 7) then
                            i2c_state_cur <= ack;
                        end if;
                        state_started <= '0';
                    end if;
                when ack =>
                    if(i2c_counter_pulse = '1' and state_started = '0') then
                        state_started <= '1';
                        if(i2c_reg_ctrl(4) and not i2c_reg_ctrl(3) and not i2c_reg_ctrl(2)) then
                            -- "100" = write, check for ACK response
                            SDAE_sig <= '0';
                            SCLE_sig <= '1';
                            i2c_counter <= i2c_counter + 1;
                            case i2c_counter is
                                when "00" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '0';
                                when "01" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '1';
                                    i2c_ack_sig <= SDAI_sig;
                                when "10" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '1';
                                when "11" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '0';
                                    i2c_state_cur <= idle;
                                    i2c_reg_ctrl(6 downto 5) <= "1" & i2c_ack_sig;
                                    op_finished <= '1';
                                when others =>
                                    -- its only 2 bits, how did you get here?
                                    null;
                            end case;
                        elsif(i2c_reg_ctrl(4) and not i2c_reg_ctrl(3) and i2c_reg_ctrl(2)) then
                            -- "101" = read, send ACK response
                            SDAE_sig <= '1';
                            SCLE_sig <= '1';
                            i2c_counter <= i2c_counter + 1;
                            case i2c_counter is
                                when "00" =>
                                    SDAO_sig <= '1';
                                    SCLO_sig <= '0';
                                when "01" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '1';
                                when "10" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '1';
                                when "11" =>
                                    SDAO_sig <= SDAO_sig;
                                    SCLO_sig <= '0';
                                    i2c_state_cur <= idle;
                                    i2c_reg_ctrl(6 downto 5) <= "10";
                                    op_finished <= '1';
                                when others =>
                                    -- its only 2 bits, how did you get here?
                                    null;
                            end case;
                        else
                            -- You got here under the wrong opcode, please leave the premises.
                        end if;
                    else
                        state_started <= '0';
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;

        
    -- internal/external signal assignements
    SDAI_sig <= SDAI;
    SDAO <= SDAO_sig;
    SDAE <= SDAE_sig;
    SCLI_sig <= SCLI;
    SCLO <= SCLO_sig;
    SCLE <= SCLE_sig;
    -- internal/external signal assignements


    interrupt <= i2c_reg_ctrl(6); -- redundant much?


   -- architecture body
end architecture_I2C_Core;
