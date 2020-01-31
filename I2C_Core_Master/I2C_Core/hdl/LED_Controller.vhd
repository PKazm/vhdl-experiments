----------------------------------------------------------------------------------
---- Company: <Name>
----
---- File: LED_Controller.vhd
---- File history:
----	  <Revision number>: <Date>: <Comments>
----	  <Revision number>: <Date>: <Comments>
----	  <Revision number>: <Date>: <Comments>
----
---- Description: 
----
---- <Description here>
----
---- Targeted device: <Family::SmartFusion2> <Die::M2S010> <Package::144 TQ>
---- Author: <Name>
----
----------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity LED_Controller is
port (
	--<port_name> : <direction> <type>;
	--port_name1 : IN  std_logic; -- example
	--port_name2 : OUT std_logic_vector(1 downto 0)  -- example
	--<other_ports>;

	PCLK100 : in std_logic;		-- Assumed to be 100Mhz
	--CLK15 : in std_logic;		-- Assumed to be 15Mhz
	CLK0_5 : in std_logic;		-- Assumed to be .5Mhz
	PRESETN : in std_logic;		-- active low

	RST_out : out std_logic;

	I2C_Sniff_SCL : in std_logic;
	I2C_Sniff_SDA : in std_logic;

	--CoreABC Stuff
	PADDR : in std_logic_vector(7 downto 0);
	PSEL : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(7 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(7 downto 0);
	PSLVERR : out std_logic;

	INT : out std_logic;
	--CoreABC Stuff END

	--Interrupt Stuff
	Fabric_Int : in std_logic_vector(7 downto 0);
	--Interrupt Stuff END


	--Externals, board stuff
	Board_Buttons : in std_logic_vector (1 downto 0);
	Board_LEDs : out std_logic_vector (7 downto 0);
	Board_MOD1 : out std_logic_vector (5 downto 0);
	Board_J7 : out std_logic_vector (4 downto 0);
	Board_J8 : out std_logic;
	Board_J9 : out std_logic;
	Board_J10 : out std_logic;
	Board_J11 : out std_logic
	--Externals, board stuff

);
end LED_Controller;
architecture architecture_LED_Controller of LED_Controller is
   ---- signal, component etc. declarations
	----signal signal_name1 : std_logic; -- example
	----signal signal_name2 : std_logic_vector(1 downto 0) ; -- example
	
	signal Blink_Count : unsigned (19 downto 0) := (others => '0');
	signal Bright_Count : unsigned (15 downto 0) := (others => '0');
	signal Blink_Clock : std_logic := '0';
	signal PWMs : unsigned (5 downto 0) := (others => '0');
	signal LCD_Backlight_PWM : std_logic := '0';

	signal toggle : std_logic := '0';
	
	signal CH0_Value : std_logic_vector (15 downto 0);
	signal CH1_Value : std_logic_vector (15 downto 0);

	signal test_signal : std_logic_vector (1 downto 0) := (others => '0');


	-- BEGIN Register signals
	--constant register_count : natural := 6;
	--constant register_size : natural := 8;
	--constant reg_address_offset : natural := 1;

	constant CTRL_ADDR : std_logic_vector (7 downto 0) := X"00";
	constant CH0_0_ADDR : std_logic_vector (7 downto 0) := X"01";
	constant CH0_1_ADDR : std_logic_vector (7 downto 0) := X"02";
	constant CH1_0_ADDR : std_logic_vector (7 downto 0) := X"03";
	constant CH1_1_ADDR : std_logic_vector (7 downto 0) := X"04";
	constant INT_ADDR : std_logic_vector (7 downto 0) := X"05";
	
	signal CTRL_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal CH0_0_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal CH0_1_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal CH1_0_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal CH1_1_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal INT_reg : std_logic_vector (7 downto 0) := (others => '0');
	-- END Register Signals

	-- BEGIN APB signals
	type state_machine_apb is(APBidle, APBsetup, APBaccess, APBaccess2);
	signal apb_fsm : state_machine_apb;

	signal prdata_sig : std_logic_vector (7 downto 0) := (others => '0');
	signal pready_sig : std_logic := '0';
	-- END APB signals

	-- BEGIN Interrupt signals
	signal internal_int_sig : std_logic := '0';
	signal Fabric_int_sig : std_logic := '0';
	-- ENG Interrupt signals

	-- BEGIN timer signals
	signal timer_signal : std_logic := '0';
	signal timer_signal_last : std_logic := '0';
	signal timer_interrupt : std_logic := '0';
	-- END timer signals

	component timer
		generic(
			g_timer_count : natural := 500;
			g_repeat : std_logic := '1'
		);
		port(
			CLK : in std_logic;
			PRESETN : in std_logic;
			timer_clock_out : out std_logic;
    		timer_interrupt_pulse : out std_logic
		);
	end component;

begin

	--=========================================================================
	-- BEGIN APB Read thing

	APB_Reg_Read_process: process(PCLK100, PRESETn)
		--variable paddr_var : std_logic_vector(7 downto 0);
		--variable pwdata_var : std_logic_vector(7 downto 0);
	begin
		if(PWRITE = '0' and PSEL = '1') then
			--pready_sig <= '1';
			case PADDR is
				when CTRL_ADDR =>
					prdata_sig <= CTRL_reg;
				when CH0_0_ADDR =>
					prdata_sig <= CH0_0_reg;
				when CH0_1_ADDR =>
					prdata_sig <= CH0_1_reg;
				when CH1_0_ADDR =>
					prdata_sig <= CH1_0_reg;
				when CH1_1_ADDR =>
					prdata_sig <= CH1_1_ADDR;
				when INT_ADDR =>
					prdata_sig <= INT_reg;
				when others =>
					 prdata_sig <= (others => '0');
			end case;
		else
			prdata_sig <= (others => '0');
		end if;
	end process;

	-- BEGIN APB Return wires
	PRDATA <= prdata_sig;
	PREADY <= '1'; --pready_sig;
	PSLVERR <= '0';
	-- END APB Return wires


	-- END APB Read thing
	--=========================================================================
	-- BEGIN TIMER MODULE Stuff

	timer_Comp : timer
		generic map(
			g_timer_count => 250000,
			--g_timer_count => 25,
			g_repeat => '1'
			--g_repeat => '0'
		)
		port map(
			CLK => CLK0_5,
			PRESETN => PRESETN,
			timer_clock_out => timer_signal,
			timer_interrupt_pulse => timer_interrupt
		);

	-- END TIMER MODULE Stuff
	--=========================================================================
	-- BEGIN Control Register Writes
	Control_process: process(PCLK100, PRESETN)
	begin
		if(PRESETN = '0') then
			CTRL_reg <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = CTRL_ADDR) then	-- APB write
				--pready_sig <= '1';
				CTRL_reg <= PWDATA;
			else
				--CTRL_reg(0) <= '0';
				--CTRL_reg(1) <= '0';
				--CTRL_reg(2) <= '0';
				--CTRL_reg(3) <= '0';
				--CTRL_reg(4) <= '0';
				--CTRL_reg(5) <= '0';
				--CTRL_reg(6) <= '0';
				--CTRL_reg(7) <= '0';
			end if;
		end if;
	end process;
	-- END Control Register Writes
	--=========================================================================
	-- BEGIN CH0_0_reg Register Writes
	CH0_0_process: process(PCLK100, PRESETN)
	begin
		if(PRESETN = '0') then
			CH0_0_reg <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = CH0_0_ADDR) then	-- APB write
				--pready_sig <= '1';
				CH0_0_reg <= PWDATA;
			else
				null;
			end if;
		end if;
	end process;
	-- END CH0_0_reg Register Writes
	--=========================================================================
	-- BEGIN CH0_1_reg Register Writes
	CH0_1_process: process(PCLK100, PRESETN)
	begin
		if(PRESETN = '0') then
			CH0_1_reg <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = CH0_1_ADDR) then	-- APB write
				--pready_sig <= '1';
				CH0_1_reg <= PWDATA;
			else
				null;
			end if;
		end if;
	end process;
	-- END CH0_1_reg Register Writes
	--=========================================================================
	-- BEGIN CH1_0_reg Register Writes
	CH1_0_process: process(PCLK100, PRESETN)
	begin
		if(PRESETN = '0') then
			CH1_0_reg <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = CH1_0_ADDR) then	-- APB write
				--pready_sig <= '1';
				CH1_0_reg <= PWDATA;
			else
				null;
			end if;
		end if;
	end process;
	-- END CH1_0_reg Register Writes
	--=========================================================================
	-- BEGIN CH1_1_reg Register Writes
	CH1_1_process: process(PCLK100, PRESETN)
	begin
		if(PRESETN = '0') then
			CH1_1_reg <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = CH1_1_ADDR) then	-- APB write
				--pready_sig <= '1';
				CH1_1_reg <= PWDATA;
			else
				null;
			end if;
		end if;
	end process;
	-- END CH1_1_reg Register Writes
	--=========================================================================
	-- BEGIN Interrupt Register Writes
	Interrupt_process: process(PCLK100, PRESETN)
			variable timer_interrupt_last : std_logic;
	begin
		if(PRESETN = '0') then
			INT_reg <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = INT_ADDR) then	-- APB write
				--pready_sig <= '1';
				INT_reg <= PWDATA;
			else
				
				if(timer_interrupt_last = '0' and timer_interrupt = '1') then
					INT_reg(0) <= '1';
				end if;
				INT_reg(1) <= '0' when Fabric_Int(0) = '0' else '1';
				INT_reg(2) <= '0';
				INT_reg(3) <= '0';
				INT_reg(4) <= '0';
				INT_reg(5) <= '0';
				INT_reg(6) <= '0';
				INT_reg(7) <= '0';
			end if;
			timer_interrupt_last := timer_interrupt;
		end if;
	end process;
	-- END Interrupt Register Writes
	--=========================================================================

	Button_Handler: process(Board_Buttons)
	begin
		if(rising_edge(Board_Buttons(0))) then
			toggle <= not toggle;
		end if;
		if(rising_edge(Board_Buttons(1))) then
			null;
		end if;
	end process;
	
	LED_Control: process(CLK0_5, PRESETN)	-- LED blinking control
	begin
		if(PRESETN = '0') then
			Blink_Count <= (others => '0');
			Blink_Clock <= '0';
		elsif(rising_edge(CLK0_5)) then
			if(Blink_Count >= 500000) then	-- 250000 divides .5Mhz into 2Hz
				Blink_Count <= (others => '0');
			else
				Blink_Count <= Blink_Count + 1;
			end if;

			case to_integer(unsigned(Blink_Count)) is	 -- Blink_Count is reset at 500,000
				when 0 =>
					Blink_Clock <= '1';
				when 250000 =>
					Blink_Clock <= '0';
				when others => null;
			end case;
				
		end if;
	end process;

	LED_Bright: process(PCLK100, PRESETN)
	begin
		if(PRESETN = '0') then
			Bright_Count <= (others => '0');
			PWMs <= (others => '1');
			CH0_Value <= (others => '0');
			CH1_Value <= (others => '0');
		elsif(rising_edge(PCLK100)) then
			-- Bright_Count simply overflows to accomodate Raw Light Sensor Data
			Bright_Count <= Bright_Count + 1;
			--if(Bright_Count >= 5000) then   -- 2500 divides .5Mhz into 200hz
			--	Bright_Count <= (others => '0');
			--else
			--	Bright_Count <= Bright_Count + 1;
			--end if;

			case to_integer(unsigned(Bright_Count)) is	 -- Bright_Count is reset at 5,000
				when 0 =>
					if(CTRL_reg(0) = '1') then
						CH0_Value <= CH0_1_reg & CH0_0_reg;
						CH1_Value <= CH1_1_reg & CH1_0_reg;
					end if;
					PWMs <= (others => '1');
				when 16384 =>   -- 25%
					PWMs(0) <= '0';
				when 32768 =>   -- 50%
					PWMs(1) <= '0';
				when 49151 =>   -- 75%
					PWMs(2) <= '0';
				when 1400 =>	-- itty bitty 2% (roughly)
					PWMs(3) <= '0';
				when others => null;
			end case;

			if(Bright_Count = unsigned(CH0_Value)) then		-- Light Sensor%
				PWMs(4) <= '0';
			end if;

			if(Bright_Count = unsigned(CH1_Value)) then
				PWMs(5) <= '0';
			end if;
		end if;
	end process;

	LCD_Backlight_PWM <= PWMs(4);

	-- BEGIN outputs directly to board pins
	Board_LEDs(0) <= Blink_Clock nand PWMs(0);
	Board_LEDs(1) <= not((Board_Buttons(0) or Board_Buttons(1)) and PWMs(0));
	Board_LEDs(2) <= not PWMs(3);
	Board_LEDs(3) <= not PWMs(0);
	Board_LEDs(4) <= not PWMs(1);
	Board_LEDs(5) <= not PWMs(2);
	Board_LEDs(6) <= not PWMs(4);
	Board_LEDs(7) <= not PWMs(5);

	Board_MOD1(0) <= '1';
	Board_MOD1(1) <= '1';
	Board_MOD1(2) <= '1';
	Board_MOD1(3) <= test_signal(1);
	Board_MOD1(4) <= test_signal(0);
	Board_MOD1(5) <= Blink_Clock nand PWMs(1);

	Board_J7(0) <= I2C_Sniff_SCL;
	Board_J7(1) <= '0';
	Board_J7(2) <= '0';
	Board_J7(3) <= PWMs(4);
	Board_J7(4) <= '0';

	Board_J8 <= '1';
	Board_J9 <= '1';
	Board_J10 <= '1';
	Board_J11 <= '1';
	-- END outputs directly to board pins

	INT <= '0' when to_integer(unsigned(INT_reg)) = 0 else '1';
	RST_out <= PRESETN;

   ---- architecture body
end architecture_LED_Controller;