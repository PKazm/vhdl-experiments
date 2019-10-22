--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: APB_Slave.vhd
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

entity APB_Slave is
port (
    --<port_name> : <direction> <type>;
	
	PCLK : in std_logic;

	PRESETn : in std_logic; -- active low
	PADDR : in std_logic_vector(31 downto 0);
	PSELx : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(31 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(31 downto 0);
	PSLVERR : out std_logic;

	INT_IN : in std_logic_vector (1 downto 0);		-- I2C and Timer
	INT_REQ : out std_logic;

	led_out : out std_logic_vector(7 downto 0);
	j7_out : out std_logic_vector(4 downto 0)
    --<other_ports>;
);
end APB_Slave;
architecture architecture_APB_Slave of APB_Slave is
   -- signal, component etc. declarations
	signal apb_fsm : unsigned (1 downto 0) := (others => '0');
	signal prdata_sig : std_logic_vector (7 downto 0) := (others => '0');
	signal led_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal ABC_MEM : std_logic_vector (7 downto 0) := (others => '0');
	signal light_CH0_reg : unsigned (15 downto 0) := (others => '0');
	signal light_CH1_reg : unsigned (15 downto 0) := (others => '0');
	signal pready_sig : std_logic := '1';
	signal int_sig : std_logic := '0';

	constant SELF_INT : std_logic_vector (1 downto 0) := "00";
	constant I2C_INT : std_logic_vector (1 downto 0) := "01";
	constant TIMER_INT : std_logic_vector (1 downto 0) := "10";

	constant INT_ADDR : std_logic_vector (7 downto 0) := X"00";
	constant LIGHT_CH0_ADDR : std_logic_vector (7 downto 0) := X"01";
	constant LIGHT_CH1_ADDR : std_logic_vector (7 downto 0) := X"02";
	constant LED_ADDR : std_logic_vector (7 downto 0) := "11110000";
	constant ABC_MEM_ADDR : std_logic_vector (7 downto 0) := X"FF";

begin
	process(PCLK)
		variable paddr_var : std_logic_vector(7 downto 0);
		variable pwdata_var : std_logic_vector(7 downto 0);
	begin
		-- slave states follow the master state
		if(rising_edge(PCLK)) then
			case to_integer(unsigned(apb_fsm)) is
				when 0 =>		-- Idle State
					if(PSELx = '1') then		-- master is in SETUP and will move to ACCESS next clock
						apb_fsm <= to_unsigned(1, 2);
						if(PWRITE = '1') then
							-- I am ready to read immediately
							pready_sig <= '1';
						else
							-- I am not ready to write immediately. (probably)
							pready_sig <= '0';
						end if;
					else
						prdata_sig <= X"00";
					end if;
				when 1 =>		-- Master has done SETUP and is currently in ACCESS
					-- I only want the important bits from APB address
					paddr_var(7) := PADDR(7);
					paddr_var(6) := PADDR(6);
					paddr_var(5) := PADDR(5);
					paddr_var(4) := PADDR(4);
					paddr_var(3) := PADDR(3);
					paddr_var(2) := PADDR(2);
					paddr_var(1) := PADDR(1);
					paddr_var(0) := PADDR(0);

					pwdata_var := PWDATA(7 downto 0);
					if(PENABLE = '1') then
						case paddr_var is
							when INT_ADDR =>
								if(PWRITE = '1') then
									null;
								else
									if(INT_IN(0) = '1') then
										prdata_sig <= (7 downto 2 => '0') & I2C_INT;
									elsif(INT_IN(1) = '1') then
										prdata_sig <= (7 downto 2 => '0') & TIMER_INT;
									elsif(INT_IN = "00") then
										prdata_sig <= (7 downto 2 => '0') & SELF_INT;
									end if;
								end if;
							when LIGHT_CH0_ADDR =>
								light_CH0_reg <= unsigned(pwdata_var) & light_CH0_reg(15 downto 8);
							when LIGHT_CH1_ADDR =>
								light_CH1_reg <= unsigned(pwdata_var) & light_CH1_reg(15 downto 8);
							when LED_ADDR =>
								if(PWRITE = '1') then
									led_reg(7) <= PWDATA(7);
									led_reg(6) <= PWDATA(6);
									led_reg(5) <= PWDATA(5);
									led_reg(4) <= PWDATA(4);
									led_reg(3) <= PWDATA(3);
									led_reg(2) <= PWDATA(2);
									led_reg(1) <= PWDATA(1);
									led_reg(0) <= PWDATA(0);
								else
									prdata_sig <= led_reg;
								end if;
							when ABC_MEM_ADDR =>
								if(PWRITE = '1') then
									ABC_MEM(7) <= PWDATA(7);
									ABC_MEM(6) <= PWDATA(6);
									ABC_MEM(5) <= PWDATA(5);
									ABC_MEM(4) <= PWDATA(4);
									ABC_MEM(3) <= PWDATA(3);
									ABC_MEM(2) <= PWDATA(2);
									ABC_MEM(1) <= PWDATA(1);
									ABC_MEM(0) <= PWDATA(0);
								else
									prdata_sig <= ABC_MEM;
								end if;
							when others =>
								null;
						end case;
					end if;

					if(PWRITE = '1')then
						apb_fsm <= to_unsigned(0, 2);
						pready_sig <= '1';
					else
						apb_fsm <= to_unsigned(2, 2);
						pready_sig <= '1';
					end if;
				when 2 =>
					-- no idea what might go here, maybe Write to master stuff?
					apb_fsm <= to_unsigned(0, 2);
				when others =>
					apb_fsm <= to_unsigned(0, 2);
			end case;

		end if;

	end process;

	led_out <= not led_reg;
	j7_out <= std_logic_vector(light_CH1_reg(4 downto 0));

	PRDATA <= (31 downto 8 => '0') & prdata_sig;
	PREADY <= pready_sig;
	PSLVERR <= '0';

	INT_REQ <= INT_IN(0) or INT_IN (1) or int_sig;

   -- architecture body
end architecture_APB_Slave;
