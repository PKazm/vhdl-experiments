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
generic (
    g_filter_length : natural := 3
);
port (
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
end I2C_Core;
architecture architecture_I2C_Core of I2C_Core is


    type i2c_states is(idle,
                        start0, start1, start2, start3,
                        stop0, stop1, stop2, stop3,
                        rstart0, rstart1, rstart2, rstart3,
                        data0, data1, data2, data3,
                        ack0, ack1, ack2, ack3);
    signal i2c_state_cur : i2c_states;

    signal i2c_bus_busy_sig : std_logic;
    signal i2c_bus_ready_cnt : std_logic;   -- counts after stop signal according to spec (ish)
    signal i2c_bus_ready : std_logic;

    signal i2c_clk_pulse : std_logic;
    signal state_handshake : std_logic;
    -- bit_counter is used to count bits during data read/write
    signal bit_counter : unsigned(2 downto 0);
    signal bit_to_SDA : std_logic;
    -- i2c_shift_reg [8-1] stores byte from SDA, bit 0 is ACK
    signal i2c_read_reg : std_logic_vector(8 downto 0);
    signal i2c_data_read : std_logic_vector(7 downto 0);
    signal i2c_ack_sig : std_logic;
    signal op_finished : std_logic;
    signal initiate_last : std_logic;
    signal did_ack : std_logic;
    
    -- BEGIN I2C signals
    signal SDAI_sig : std_logic;
    signal SDAO_sig : std_logic;
    signal SDAE_sig : std_logic;
    signal SCLI_sig : std_logic;
    signal SCLO_sig : std_logic;
    signal SCLE_sig : std_logic;

    -- vectors are updated at the frequency of PCLK
    signal SDAI_sig_history : std_logic_vector(1 downto 0);     -- index 0 is current value
    signal SCLI_sig_history : std_logic_vector(1 downto 0);     -- index 0 is current value

    constant FILT_ZEROES : std_logic_vector(g_filter_length - 2 downto 0) := (others => '0');
    constant FILT_ONES : std_logic_vector(g_filter_length - 2 downto 0) := (others => '1');
    signal SDA_filt : std_logic_vector(g_filter_length - 1 downto 0);
    signal SCL_filt : std_logic_vector(g_filter_length - 1 downto 0);

    signal SDA_mismatch : std_logic;
    signal SCL_mismatch : std_logic;
    -- END I2C signals

    -- BEGIN register signals
    signal i2c_instr_reg : std_logic_vector(2 downto 0);
    signal i2c_data : std_logic_vector(7 downto 0);
    signal status_sig : std_logic_vector(1 downto 0);
    -- END register signals

begin

    --=========================================================================

    p_update_reg_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then

        elsif(rising_edge(PCLK)) then
            
        end if;
    end process;

    data_out <= i2c_data_read;
    status_out <= status_sig;
    i2c_int <= status_sig(1);

    --=========================================================================

    p_i2c_line_filters : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            -- lines are considered idle when = 1
            -- starting at 0 will cause a rising edge condition on reset
            -- (of course if bus lines are not powered fast enough a falling then rising edge situation might occur)
            SDA_filt <= (others => '1');
            SCL_filt <= (others => '1');

            SDAI_sig_history <= (others => '1');
            SCLI_sig_history <= (others => '1');
        elsif(rising_edge(PCLK)) then
            SDA_filt <= SDA_filt(SDA_filt'high - 1 downto 0) & SDAI;
            SCL_filt <= SCL_filt(SCL_filt'high - 1 downto 0) & SCLI;

            -- while SDA is lagged by the filter length, it should be stable BEFORE SCL is set high
            -- This filter is very likely a much shorter duration than the stable time
            if(SDA_filt(SDA_filt'high downto 1) = FILT_ZEROES) then
                SDAI_sig_history <= SDAI_sig_history(SDAI_sig_history'high - 1 downto 0) & '0';
            elsif(SDA_filt(SDA_filt'high downto 1) = FILT_ONES) then
                SDAI_sig_history <= SDAI_sig_history(SDAI_sig_history'high - 1 downto 0) & '1';
            else
                -- avoid getting stuck on edge condition for multiple PCLK if bus becomes glitched
                SDAI_sig_history <= SDAI_sig_history(SDAI_sig_history'high - 1 downto 0) & SDAI_sig_history(0);
            end if;

            if(SCL_filt(SCL_filt'high downto 1) = FILT_ZEROES) then
                SCLI_sig_history <= SCLI_sig_history(SCLI_sig_history'high - 1 downto 0) & '0';
            elsif(SCL_filt(SCL_filt'high downto 1) = FILT_ONES) then
                SCLI_sig_history <= SCLI_sig_history(SCLI_sig_history'high - 1 downto 0) & '1';
            else
                -- avoid getting stuck on edge condition for multiple PCLK if bus becomes glitched
                SCLI_sig_history <= SCLI_sig_history(SCLI_sig_history'high - 1 downto 0) & SCLI_sig_history(0);
            end if;
        end if;
    end process;

    -- shorten notation and align with other I2C signal names
    SDAI_sig <= SDAI_sig_history(0);
    SCLI_sig <= SCLI_sig_history(0);

    --=========================================================================

    p_i2c_busy_monitor : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            -- if the bus is busy during this device's reset, well I'm not sure then. Maybe check for other activity.
            i2c_bus_busy_sig <= '0';
            i2c_bus_ready_cnt <= '0';
        elsif(rising_edge(PCLK)) then

            if(SDAI_sig_history(1) = '1' and SDAI_sig_history(0) = '0' and
                SCLI_sig_history(1) = '1' and SCLI_sig_history(0) = '1') then
                -- Start detected
                i2c_bus_busy_sig <= '1';

            elsif(SDAI_sig_history(1) = '0' and SDAI_sig_history(0) = '1' and
                SCLI_sig_history(1) = '1' and SCLI_sig_history(0) = '1') then
                -- Stop detected
                i2c_bus_busy_sig <= '0';
                i2c_bus_ready_cnt <= '1';

            end if;

            if(i2c_bus_ready = '1') then
                i2c_bus_ready_cnt <= '0';
            end if;
        end if;
    end process;
    
    -- this is delayed from SDAO and SCLO activity by the bus filter length.
    i2c_bus_busy <= i2c_bus_busy_sig;

    --=========================================================================

    p_i2c_arbitration_monitor : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            SDA_mismatch <= '0';
        elsif(rising_edge(PCLK)) then
            if(SDAI_sig /= SDAO_sig) then
                SDA_mismatch <= '1';
            else
                SDA_mismatch <= '0';
            end if;
        end if;
    end process;

    --=========================================================================

    p_i2c_clock_stretch : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            SCL_mismatch <= '0';
        elsif(rising_edge(PCLK)) then
            if(SCLI_sig /= SCLO_sig) then
                SCL_mismatch <= '1';
            else
                SCL_mismatch <= '0';
            end if;
        end if;
    end process;

    --=========================================================================

    p_i2c_clock_gen :process(PCLK, RSTn)
        variable i2c_clk_cnt : unsigned(15 downto 0);
    begin
        if(RSTn = '0') then
            i2c_clk_cnt := (others => '0');
            i2c_clk_pulse <= '1';
            i2c_bus_ready <= '1';
        elsif(rising_edge(PCLK)) then
            if(i2c_bus_busy_sig = '1') then
                i2c_bus_ready <= '0';
            end if;

            if(status_sig = "00") then
                -- sync reset
                -- start with pulse active as counter only operates when I2C Core is active
                i2c_clk_cnt := (others => '0');
                i2c_clk_pulse <= '1';
            elsif(i2c_bus_ready_cnt = '1' and i2c_bus_ready = '0') then
                -- count to half the desired SCL clock speed. This approximates the bus free time in the spec.
                if(i2c_clk_cnt = shift_right(unsigned(clk_div_in), 1) - 1) then
                    i2c_clk_cnt := (others => '0');
                    i2c_bus_ready <= '1';
                else
                    i2c_clk_cnt := i2c_clk_cnt + 1;
                end if;
            else
                -- I2C Core is active and the I2C clock is running (this is the clock)
                if(i2c_clk_cnt = shift_right(unsigned(clk_div_in), 2) - 1) then
                    i2c_clk_cnt := (others => '0');
                    i2c_clk_pulse <= '1';
                elsif(SCL_mismatch = '1') then
                    -- SCL mismatch, either glitch or clock stretching, pause clock and wait
                    null;
                else
                    i2c_clk_cnt := i2c_clk_cnt + 1;
                    if(state_handshake = '1') then
                        -- waits for handshake response
                        i2c_clk_pulse <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;

    --=========================================================================

    p_i2c_data_state_machine : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            i2c_state_cur <= idle;
            SDAO_sig <= '1';
            SCLO_sig <= '1';
            status_sig <= (others => '0');
            state_handshake <= '0';
            bit_counter <= (others => '1');
            initiate_last <= '0';
            did_ack <= '0';
            i2c_read_reg <= (others => '0');
        elsif(rising_edge(PCLK)) then
            initiate_last <= initiate;

            if(i2c_state_cur = idle) then
                if(status_sig = "01") then
                    -- data instructions take multiple iterations, check those
                    if(i2c_instr_reg(2 downto 1) = "10") then
                        -- read or write data operation
                        if(bit_counter = 0 and did_ack = '1') then
                            -- already determined to be in a read or write instruction
                            -- if write, set ack value, if not write, set 0
                            status_sig <= '1' & (i2c_ack_sig and not i2c_instr_reg(0));
                        elsif(bit_counter = 0 and did_ack = '0') then
                            i2c_state_cur <= data0;
                            did_ack <= '1';
                        else
                            i2c_state_cur <= data0;
                            -- bit_count lags the bit position, i.e. decremented after i2c action
                            bit_counter <= bit_counter - 1;
                        end if;
                    elsif(i2c_instr_reg = "010" and i2c_clk_pulse = '1' and state_handshake = '0') then
                        -- allow stop command to finish last quarter before setting I2C idle
                        status_sig <= "00";
                    end if;
                else
                    if(status_sig = "00") then
                        SDAO_sig <= '1';
                        SCLO_sig <= '1';
                        i2c_instr_reg <= (others => '0');
                    end if;

                    -- I2C bus is not in the middle of an instruction
                    if(initiate_last = '0' and initiate = '1') then
                        -- rising edge of initiation bit
                        i2c_instr_reg <= instruct;
                        bit_counter <= (others => '1');
                        did_ack <= '0';
                        case instruct is
                            when "000" =>   -- No Operation
                                -- not sure what to do here but there's extra bits and stuff
                                --status_sig <= "00";
                            when "001" =>   -- Start
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= start0;
                            when "010" =>   -- Stop
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= stop0;
                            when "011" =>   -- Repeated Start
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= rstart0;
                            when "100" =>   -- Transmit (write) Data
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= data0;
                            when "101" =>   -- Receive (read) Data
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= data0;
                            when "110" =>   -- write ACK value
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= data0;
                            when "111" =>   -- read ACK value
                                status_sig <= "01"; -- busy
                                i2c_state_cur <= data0;
                            when others =>
                                -- unintentional No Operation
                                --status_sig <= "00";
                        end case;
                    end if;
                end if;
            elsif(i2c_clk_pulse = '1' and state_handshake = '0') then
                state_handshake <= '1';

                case i2c_state_cur is
                    when start0 =>
                        if(i2c_bus_ready = '1') then
                            i2c_state_cur <= start1;
                            SDAO_sig <= '0';
                            SCLO_sig <= '1';
                        end if;
                    when start1 =>
                        i2c_state_cur <= start2;
                        SDAO_sig <= '0';
                        SCLO_sig <= '1';
                    when start2 =>
                        i2c_state_cur <= start3;
                        SDAO_sig <= '0';
                        SCLO_sig <= '1';
                    when start3 =>
                        i2c_state_cur <= idle;
                        SDAO_sig <= '0';
                        SCLO_sig <= '0';
                        status_sig <= "10";

                    when stop0 =>
                        i2c_state_cur <= stop1;
                        SDAO_sig <= '0';
                        SCLO_sig <= '0';
                    when stop1 =>
                        i2c_state_cur <= stop2;
                        SDAO_sig <= '0';
                        SCLO_sig <= '1';
                    when stop2 =>
                        i2c_state_cur <= stop3;
                        SDAO_sig <= '0';
                        SCLO_sig <= '1';
                    when stop3 =>
                        i2c_state_cur <= idle;
                        SDAO_sig <= '0';
                        SCLO_sig <= '1';
                        --status_sig <= "00";

                    when rstart0 =>
                        i2c_state_cur <= rstart1;
                        SDAO_sig <= '1';
                        SCLO_sig <= '0';
                    when rstart1 =>
                        i2c_state_cur <= rstart2;
                        SDAO_sig <= '1';
                        SCLO_sig <= '1';
                    when rstart2 =>
                        i2c_state_cur <= rstart3;
                        SDAO_sig <= '0';
                        SCLO_sig <= '1';
                    when rstart3 =>
                        i2c_state_cur <= idle;
                        SDAO_sig <= '0';
                        SCLO_sig <= '0';
                        status_sig <= "10";

                    when data0 =>
                        i2c_state_cur <= data1;
                        SDAO_sig <= bit_to_SDA;
                        SCLO_sig <= '0';
                        i2c_read_reg <= i2c_read_reg(7 downto 0) & '0';
                    when data1 =>
                        i2c_state_cur <= data2;
                        SDAO_sig <= bit_to_SDA;
                        SCLO_sig <= '1';
                        i2c_read_reg(0) <= SDAI_sig;
                    when data2 =>
                        i2c_state_cur <= data3;
                        SDAO_sig <= bit_to_SDA;
                        SCLO_sig <= '1';
                    when data3 =>
                        i2c_state_cur <= idle;
                        SDAO_sig <= bit_to_SDA;
                        SCLO_sig <= '0';

                    when others =>
                        null;
                end case;
            end if;

            if(i2c_clk_pulse = '0' and state_handshake = '1') then
                state_handshake <= '0';
            end if;
        end if;
    end process;

    bit_to_SDA <= data_in(to_integer(unsigned(bit_counter))) when i2c_instr_reg = "100" and did_ack = '0' else   -- data write
                                    '1' when i2c_instr_reg = "101" and did_ack = '1' else   -- send ack response after data read
                                    '1';    -- data read, ACK read, other commands do not use bit_to_SDA (1 means leave bus alone)
    i2c_data_read <= i2c_read_reg(8 downto 1);
    i2c_ack_sig <= i2c_read_reg(0);

    SDAO <= '0';--SDAO_sig;
    SDAE <= not SDAO_sig;--SDAE_sig;
    SCLO <= '0';--SCLO_sig;
    SCLE <= not SCLO_sig;--SCLE_sig;

    --=========================================================================


   -- architecture body
end architecture_I2C_Core;
