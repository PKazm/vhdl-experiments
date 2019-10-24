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

library work;
use work.all;
use work.register_pkg.all;

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


	constant register_count : natural := 6;
	constant register_size : natural := 8;
	constant reg_address_offset : natural := 1;

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

	-- BEGIN Register signals
	--signal Reg_Val_in : std_logic_vector (7 downto 0) := (others => '0');
	--signal Reg_Val_out : std_logic_vector (7 downto 0) := (others => '0');
	--signal Reg_Write_High : std_logic := '0';
	--signal Reg_Enabled : std_logic := '0';
	signal Reg_Access_read : register_array(register_count - 1 downto 0)(register_size - 1 downto 0);
	signal Reg_Accross_write : register_array(register_count - 1 downto 0)(register_size - 1 downto 0);

	signal Reg_Busy_sig : std_logic := '0';
	signal Reg_Update_sig : std_logic := '0';
	-- END Register signals

	component Register_Core
		generic (
			register_count : natural := 6;
			register_size : natural := 8;
			address_offsets : natural := 1
		);
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

			Reg_Access_In : in register_array(register_count - 1 downto 0)(register_size - 1 downto 0);
			Reg_Access_Out : out register_array(register_count - 1 downto 0)(register_size - 1 downto 0);
			Reg_Busy : out std_logic;		-- indicates APB (or other) is updating registers
			Reg_Update : in std_logic		-- indicates parent has updated registers
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

	--=========================================================================
	-- BEGIN REGISTER MODULE THING

	Register_Comp : Register_Core
		generic map(
			register_count => register_count,
			register_size => register_size,
			address_offsets => reg_address_offset
		)
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

			Reg_Access_In => Reg_Accross_write,
			Reg_Access_Out => Reg_Access_read,
			Reg_Busy => Reg_Busy_sig,
			Reg_Update => Reg_Update_sig
		);

	-- this block should maybe occur in the Register_Control process
	--Reg_Accross_write(0) <= CTRL_reg;
	--Reg_Accross_write(1) <= CH0_0_reg;
	--Reg_Accross_write(2) <= CH0_1_reg;
	--Reg_Accross_write(3) <= CH1_0_reg;
	--Reg_Accross_write(4) <= CH1_1_reg;
	--Reg_Accross_write(5) <= INT_reg;

	CTRL_reg <= Reg_Access_read(0);
	CH0_0_reg <= Reg_Access_read(1);
	CH0_1_reg <= Reg_Access_read(2);
	CH1_0_reg <= Reg_Access_read(3);
	CH1_1_reg <= Reg_Access_read(4);
	INT_reg <= Reg_Access_read(5);

	Register_Control: process(PCLK, PRESETN)
	begin
		if(rising_edge(PCLK)) then
			-- I don't think anything happens here anymore
		end if;
	end process Register_Control;

	-- END REGISTER MODULE THING
	--=========================================================================
	-- BEGIN TIMER MODULE THING

	timer_Comp : timer
		generic map(
			g_timer_count => 500
		)
		port map(
			CLK => PCLK,
			timer_out => timer_signal
		);

	-- END TIMER MODULE THING
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