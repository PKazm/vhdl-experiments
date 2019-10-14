--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Fake_Light_Sensor.vhd
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

entity Fake_Light_Sensor is
port (
    CLK_in : in std_logic;

    SCL_in : in std_logic;
    SCL_out : out std_logic;
    SDA_in : in std_logic;
    SDA_out : out std_logic
);
end Fake_Light_Sensor;
architecture architecture_Fake_Light_Sensor of Fake_Light_Sensor is
    -- signal, component etc. declarations
    type state_machine is(idle, ack, address, receiving, transmitting);
    signal state : state_machine;
    signal last_state : state_machine;
    signal last_SCL : std_logic := '0';
    signal last_SDA : std_logic := '0';

    signal data_in : std_logic_vector (7 downto 0) := (others => '0');
    signal data_out : std_logic_vector (7 downto 0) := (others => '0');
    signal ack_return : std_logic := '0';
    signal count_data : unsigned (3 downto 0) := (others => '0');

    signal ack_toggle : std_logic := '0';
    signal read_true : std_logic := '0';
    signal reg_addr_rec : std_logic := '0';
    signal reg_addr : std_logic_vector (7 downto 0) := (others => '0');

    signal SCL_in_sig : std_logic := '0';
    signal SCL_out_sig : std_logic := '0';
    signal SDA_in_sig : std_logic := '0';
    signal SDA_out_sig : std_logic := '0';


    signal CTRL_REG : std_logic_vector (7 downto 0) := x"00";
    signal MEAS_REG : std_logic_vector (7 downto 0) := x"03";
    signal ID_REG : std_logic_vector (7 downto 0) := x"A0";
    signal MANU_REG : std_logic_vector (7 downto 0) := x"05";
    signal CH1_0_REG : std_logic_vector (7 downto 0) := x"55";
    signal CH1_1_REG : std_logic_vector (7 downto 0) := x"99";
    signal CH0_0_REG : std_logic_vector (7 downto 0) := x"FA";
    signal CH0_1_REG : std_logic_vector (7 downto 0) := x"33";
    signal STAT_REG : std_logic_vector (7 downto 0) := x"00";

    constant I2C_ADDR : std_logic_vector (6 downto 0) := "0101001"; --0x29
    
    constant CTRL_ADDR : std_logic_vector (7 downto 0) := x"80";
    constant MEAS_ADDR : std_logic_vector (7 downto 0) := x"85";
    constant ID_ADD : std_logic_vector (7 downto 0) := x"86";
    constant MANU_ADDR : std_logic_vector (7 downto 0) := x"87";
    constant CH1_0_ADDR : std_logic_vector (7 downto 0) := x"88";
    constant CH1_1_ADDR : std_logic_vector (7 downto 0) := x"89";
    constant CH0_0_ADDR : std_logic_vector (7 downto 0) := x"8A";
    constant CH0_1_ADDR : std_logic_vector (7 downto 0) := x"8B";
    constant STAT_ADDR : std_logic_vector (7 downto 0) := x"8C";

begin

    process(CLK_in)
        --variable ack_var : std_logic;
        variable datum_var : std_logic;
        variable data_var : std_logic_vector (7 downto 0);
    begin
        if(rising_edge(CLK_in)) then
            last_SCL <= SCL_in_sig;        -- only updates on next process cycle
            last_SDA <= SDA_in_sig;        -- only updates on next process cycle

            if(last_SCL = '1' and SCL_in_sig = '1' and last_SDA = '1' and SDA_in_sig = '0') then
                -- SDA falling edge while SCL remaings high indicates Start OR Repeated Start
                SDA_out_sig <= '1';
                SCL_out_sig <= '1';
                if(state = idle) then
                    reg_addr_rec <= '0';
                    reg_addr <= (others => '0');
                end if;
                count_data <= to_unsigned(0, 4);
                ack_toggle <= '0';
                last_state <= state;
                state <= address;
            elsif(last_SCL = '1' and SCL_in_sig = '1' and last_SDA = '0' and SDA_in_sig = '1') then
                -- SDA rising edge while SCL remaings high indicates Stop
                SDA_out_sig <= '1';
                SCL_out_sig <= '1';
                last_state <= state;
                state <= idle;
            else

                case state is
                    when idle =>
                        SDA_out_sig <= '1';
                        SCL_out_sig <= '1';
                    when address =>
                        if(last_SCL = '0' and SCL_in_sig = '1') then
                            count_data <= count_data + 1;
                            data_in <= data_in(6 downto 0) & SDA_in_sig;
                        end if;
                        
                        if(last_SCL = '1' and SCL_in_sig = '0' and count_data = 8) then
                            last_state <= state;
                            state <= ack;
                            SCL_out_sig <= '1';
                            SDA_out_sig <= '1';

                            if(data_in(7 downto 1) = I2C_ADDR) then
                                ack_return <= '0';     -- this is my address
                                read_true <= data_in(0);
                                if(data_in(0) = '0') then   -- write, SDA will write to data_in
                                    null;
                                else
                                    if(reg_addr_rec) then   -- read, data_out will write to SDA
                                        case reg_addr is
                                            when CTRL_ADDR =>
                                                data_out <= CTRL_REG;
                                            when MEAS_ADDR =>
                                                data_out <= MEAS_REG;
                                            when ID_ADD =>
                                                data_out <= ID_REG;
                                            when MANU_ADDR =>
                                                data_out <= MANU_REG;
                                            when CH1_0_ADDR =>
                                                data_out <= CH1_0_REG;
                                            when CH1_1_ADDR =>
                                                data_out <= CH1_1_REG;
                                            when CH0_0_ADDR =>
                                                data_out <= CH0_0_REG;
                                            when CH0_1_ADDR =>
                                                data_out <= CH0_1_REG;
                                            when STAT_ADDR =>
                                                data_out <= STAT_REG;
                                            when others =>
                                                null; -- if you got here... tough
                                        end case;
                                    end if;
                                end if;
                            else
                                ack_return <= '1';     -- this is not my address
                            end if;
                        end if;
                    when receiving =>
                        if(last_SCL = '0' and SCL_in_sig = '1') then
                            SDA_out_sig <= '1';
                            SCL_out_sig <= '1';

                            count_data <= count_data + 1;
                            data_in <= data_in(6 downto 0) & SDA_in_sig;
                        end if;

                        if(last_SCL = '1' and SCL_in_sig = '0' and count_data = 8) then
                            last_state <= state;
                            state <= ack;
                            SCL_out_sig <= '1';
                            SDA_out_sig <= '1';

                            if(reg_addr_rec = '0') then
                                case data_in is
                                    when CTRL_ADDR =>
                                        ack_return <= '0';
                                    when MEAS_ADDR =>
                                        ack_return <= '0';
                                    when ID_ADD =>
                                        ack_return <= '0';
                                    when MANU_ADDR =>
                                        ack_return <= '0';
                                    when CH1_0_ADDR =>
                                        ack_return <= '0';
                                    when CH1_1_ADDR =>
                                        ack_return <= '0';
                                    when CH0_0_ADDR =>
                                        ack_return <= '0';
                                    when CH0_1_ADDR =>
                                        ack_return <= '0';
                                    when STAT_ADDR =>
                                        ack_return <= '0';
                                    when others =>
                                        ack_return <= '1';     -- reg_addr unknown
                                end case;
                            else    -- reg_addr_rec = 1
                                case reg_addr is
                                    when CTRL_ADDR =>
                                        ack_return <= '0';
                                        CTRL_REG <= data_in;
                                    when MEAS_ADDR =>
                                        ack_return <= '0';
                                        MEAS_REG <= data_in;
                                    when ID_ADD =>
                                        ack_return <= '0';
                                        ID_REG <= data_in;
                                    when MANU_ADDR =>
                                        ack_return <= '0';
                                        MANU_REG <= data_in;
                                    when CH1_0_ADDR =>
                                        ack_return <= '0';
                                        CH1_0_REG <= data_in;
                                    when CH1_1_ADDR =>
                                        ack_return <= '0';
                                        CH1_1_REG <= data_in;
                                    when CH0_0_ADDR =>
                                        ack_return <= '0';
                                        CH0_0_REG <= data_in;
                                    when CH0_1_ADDR =>
                                        ack_return <= '0';
                                        CH0_1_REG <= data_in;
                                    when STAT_ADDR =>
                                        ack_return <= '0';
                                        STAT_REG <= data_in;
                                    when others =>
                                        ack_return <= '1';     -- reg_addr unknown
                                end case;
                            end if;
                        end if;
                    when transmitting =>
                        if(last_SCL = '1' and SCL_in_sig = '0') then
                            if(count_data = 8) then
                                last_state <= state;
                                state <= ack;
                                SCL_out_sig <= '1';
                                SDA_out_sig <= '1';
                            else
                                SDA_out_sig <= data_out(7);
                                data_out <= data_out(6 downto 0) & '1';
                            end if;
                        elsif(last_SCL = '0' and SCL_in_sig = '1') then
                            count_data <= count_data + 1;
                        end if;
                    when ack =>
                        count_data <= to_unsigned(0, 4);

                        
                        if(read_true = '0' or last_state = address) then    -- write
                            SDA_out_sig <= ack_return;
                        else                        -- read
                            SDA_out_sig <= '1';
                        end if;
                        if(last_SCL = '1' and SCL_in_sig = '0') then
                            SCL_out_sig <= '1';
                            SDA_out_sig <= '1';
                            
                            if(read_true = '0') then    -- write
                                last_state <= state;
                                state <= receiving;
                            else                        -- read
                                last_state <= state;
                                state <= transmitting;
                                SDA_out_sig <= data_out(7);
                                data_out <= data_out(6 downto 0) & '1';
                            end if;
                            
                        elsif(last_SCL = '0' and SCL_in_sig = '1') then
                            if(reg_addr_rec = '0' and ack_return = '0' and last_state = receiving) then
                                reg_addr <= data_in;
                                reg_addr_rec <= '1';
                            end if;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    SCL_in_sig <= SCL_in;
    SCL_out <= SCL_out_sig;
    SDA_in_sig <= SDA_in;
    SDA_out <= SDA_out_sig;

   -- architecture body
end architecture_Fake_Light_Sensor;
