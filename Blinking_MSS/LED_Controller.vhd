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

	PCLK : in std_logic;		-- Assumed to be 100Mhz
	CLK : in std_logic;			-- Assumed to be .5Mhz
	PRESETN : in std_logic;		-- active low
	MSS_Ready : in std_logic;
	MSS_Init_Done : in std_logic;
	PLL_Lock : in std_logic;

	RST_out : out std_logic;

	--CoreABC Stuff
	PADDR : in std_logic_vector(31 downto 0);
	PSELx : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(31 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(31 downto 0);
	PSLVERR : out std_logic;

	INT : out std_logic;
	--CoreABC Stuff END


	--Externals
	Board_Buttons : in std_logic_vector (1 downto 0);
	Board_LEDs : out std_logic_vector (7 downto 0);
	Board_MOD1 : out std_logic_vector (5 downto 0)

);
end LED_Controller;
architecture architecture_LED_Controller of LED_Controller is
   ---- signal, component etc. declarations
	----signal signal_name1 : std_logic; -- example
	----signal signal_name2 : std_logic_vector(1 downto 0) ; -- example
	
	signal Blink_Count : unsigned (19 downto 0) := (others => '0');
	signal Bright_Count : unsigned (15 downto 0) := (others => '0');
	signal Blink_Clock : std_logic := '0';
	signal PWMs : unsigned (4 downto 0) := (others => '0');

	signal toggle : std_logic := '0';
	
	signal Light_Value : unsigned (15 downto 0);

	signal test_signal : std_logic_vector (1 downto 0) := (others => '0');

	signal timer_signal : std_logic := '0';

	constant CTRL_ADDR : std_logic_vector (7 downto 0) := X"00";
	constant CH0_ADDR : std_logic_vector (7 downto 0) := X"01";
	constant CH1_ADDR : std_logic_vector (7 downto 0) := X"02";
	constant INT_ADDR : std_logic_vector (7 downto 0) := X"03";
	
	signal CTRL_reg : std_logic_vector (7 downto 0) := (others => '0');
	signal CH0_reg : std_logic_vector (15 downto 0) := (others => '0');
	signal CH1_reg : std_logic_vector (15 downto 0) := (others => '0');
	signal INT_reg : std_logic_vector (7 downto 0) := (others => '0');

	-- BEGIN APB_Interface signals
	signal APB_addr_sig : std_logic_vector (7 downto 0) := (others => '0');
	signal APB_Reg_Val_in : std_logic_vector (7 downto 0) := (others => '0');
	signal APB_Reg_Val_out : std_logic_vector (7 downto 0) := (others => '0');
	signal APB_Write_High : std_logic := '0';
	signal APB_Enabled : std_logic := '0';

	signal APB_Handled : std_logic := '0';
	-- END APB_Interface signals

	component APB_Interface
		port(
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

			Reg_Addr : out std_logic_vector(7 downto 0);
			Reg_Value_out : out std_logic_vector(7 downto 0);
			Reg_Value_in : in std_logic_vector(7 downto 0);
			Write_High : out std_logic;
			Enable : out std_logic;
			Handled : in std_logic
		);
	end component;

	component timer
		generic(
			g_timer_count : natural := 500
		);
		port(
			CLK : in std_logic;
    		timer_out : out std_logic
		);
	end component;

begin

	APB_Comp : APB_Interface
		port map(
			PCLK => PCLK,

			PRESETn => PRESETN, -- active low
			PADDR => PADDR,
			PSELx => PSELx,
			PENABLE => PENABLE,
			PWRITE => PWRITE,
			PWDATA => PWDATA,
			PREADY => PREADY,
			PRDATA => PRDATA,
			PSLVERR => PSLVERR,

			Reg_Addr => APB_addr_sig,
			Reg_Value_in => APB_Reg_Val_in,
			Reg_Value_out => APB_Reg_Val_out,
			Write_High => APB_Write_High,
			Enable => APB_Enabled,
			Handled => APB_Handled
		);

	APB_Interaction: process(PCLK)
	begin
		if(rising_edge(PCLK)) then
			if(APB_Enabled = '1' and APB_Handled = '0') then
				APB_Handled <= '1';
				case APB_addr_sig is
					when CTRL_ADDR =>
						if(PWRITE = '1') then
							CTRL_reg <= APB_Reg_Val_out;
						else
							APB_Reg_Val_in <= CTRL_reg;
						end if;
					when CH0_ADDR =>
						if(PWRITE = '1') then
							CH0_reg <= APB_Reg_Val_out & CH0_reg(15 downto 8);
						else
							APB_Reg_Val_in <= X"00";
						end if;
					when CH1_ADDR =>
						if(PWRITE = '1') then
							CH1_reg <= APB_Reg_Val_out & CH1_reg(15 downto 8);
						else
							APB_Reg_Val_in <= X"00";
						end if;
					when INT_ADDR =>
						if(PWRITE = '1') then
							CH1_reg <= APB_Reg_Val_out & CH1_reg(15 downto 8);
						else
							APB_Reg_Val_in <= X"00";
						end if;
					when others =>
						null;
				end case;
			elsif(APB_Enabled = '0') then
				APB_Handled <= '0';
			end if;
		end if;
	end process APB_Interaction;

	timer_Comp : timer
		--generic map(
		--	g_timer_count => 500
		--);
		port map(
			CLK => PCLK,
			timer_out => timer_signal
		);

	Button_Handler: process(Board_Buttons)
	begin
		if(rising_edge(Board_Buttons(0))) then
			toggle <= not toggle;
		end if;
		if(rising_edge(Board_Buttons(1))) then
			null;
		end if;
	end process;
	
	LED_Control: process(CLK)	-- LED blinking control
	begin
		if(rising_edge(CLK)) then
			if(Blink_Count >= 500000) then	-- 250000 divides .5Mhz into 2Hz
				Blink_Count <= (others => '0');
			else
				Blink_Count <= Blink_Count + 1;
			end if;
			
			if(Bright_Count >= 5000) then   -- 2500 divides .5Mhz into 200hz
				Bright_Count <= (others => '0');
			else
				Bright_Count <= Bright_Count + 1;
			end if;

			case Blink_Count is	 -- Blink_Count is reset at 500,000
				when to_unsigned(0, Blink_Count'length) =>
					Blink_Clock <= '1';
				when to_unsigned(250000, Blink_Count'length) =>
					Blink_Clock <= '0';
				when others => null;
			end case;

			case Bright_Count is	 -- Bright_Count is reset at 5,000
				when to_unsigned(0, Bright_Count'length) =>
					PWMs <= "11111";
				when to_unsigned(1250, Bright_Count'length) =>   -- 25%
					PWMs(0) <= '0';
				when to_unsigned(2500, Bright_Count'length) =>   -- 50%
					PWMs(1) <= '0';
				when to_unsigned(3750, Bright_Count'length) =>   -- 75%
					PWMs(2) <= '0';
				when to_unsigned(100, Bright_Count'length) =>	-- itty bitty 2%
					PWMs(3) <= '0';
				when others => null;
			end case;
			--if(Bright_Count = Light_Value) then	-- Light Sensor%
			--	PWMs(4) <= '0';
			--end if;
		end if;
	end process;

	-- BEGIN outputs directly to board pins
	Board_LEDs(0) <= Blink_Clock nand PWMs(0);
	Board_LEDs(1) <= not((Board_Buttons(0) or Board_Buttons(1)) and PWMs(0));
	Board_LEDs(2) <= not PWMs(3);
	Board_LEDs(3) <= not PWMs(0);
	Board_LEDs(4) <= not PWMs(1);
	Board_LEDs(5) <= not PWMs(2);
	Board_LEDs(6) <= not PWMs(4);
	Board_LEDs(7) <= Blink_Clock or (not toggle);

	Board_MOD1(0) <= PRESETN;
	Board_MOD1(1) <= '0';
	Board_MOD1(2) <= '1';
	Board_MOD1(3) <= test_signal(1);
	Board_MOD1(4) <= test_signal(0);
	Board_MOD1(5) <= Blink_Clock nand PWMs(1);
	-- END outputs directly to board pins

   ---- architecture body
end architecture_LED_Controller;