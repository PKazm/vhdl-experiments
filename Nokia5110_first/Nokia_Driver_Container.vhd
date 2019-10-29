--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Nokia_Driver_Container.vhd
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

entity Nokia_Driver_Container is
port (
    CLK : in std_logic;     -- assumed to be 100Mhz
    CLK_SPI : in std_logic; -- Must be less than 4Mhz for Nokia5110
    RSTn : in std_logic;

    Board_Buttons : in std_logic_vector(1 downto 0);
    Board_LEDs : out std_logic_vector(7 downto 0);
    Board_MOD1 : out std_logic_vector(5 downto 0);
    Board_J7 : out std_logic_vector(4 downto 0);
    Board_J8 : out std_logic;
    Board_J9 : out std_logic;
    Board_J10 : out std_logic;
    Board_J11 : out std_logic
);
end Nokia_Driver_Container;
architecture architecture_Nokia_Driver_Container of Nokia_Driver_Container is

    signal buttons_last : std_logic_vector(1 downto 0) := (others => '0');
    signal LCD_Backlight_sig : std_logic := '0';

    -- BEGIN Nokia_Driver_Comp: Nokia5110_Driver signals
    signal SPIDO : std_logic := '0';
    signal SPICLK : std_logic := '0';
    signal data_command : std_logic := '0';
    signal chip_enable : std_logic := '0';
    signal RSTout : std_logic := '0';
    -- END Nokia_Driver_Comp: Nokia5110_Driver signals

    component Nokia5110_Driver
        generic (
            frame_size : natural := 8
        );
        port (
            CLK : in std_logic;     -- assumed to be 100Mhz
            CLK_SPI : in std_logic; -- Must be less than 4Mhz for Nokia5110
            RSTn : in std_logic;
            enable : in std_logic;

            SPIDO : out std_logic;
            SPICLK : out std_logic;
            data_command : out std_logic;
            chip_enable : out std_logic;
            RSTout : out std_logic
        );
    end component;

    -- BEGIN start_up_timer : timer signals
    signal timer_out_sig : std_logic := '0';
    signal timer_int_sig : std_logic := '0';
    -- END start_up_timer : timer signals

    component timer
        generic(
            g_timer_count : natural := 200;
            g_repeat : std_logic := '1'
        );
        port(
            CLK : in std_logic;
            PRESETN : in std_logic;

            timer_out : out std_logic;
            interrupt_pulse : out std_logic
        );
    end component;

begin

    start_up_timer : timer
    generic map (
        g_timer_count => 500,
        g_repeat => '0'
    )
    port map (
        CLK => CLK_SPI,
        PRESETN => RSTn,

        timer_out => timer_out_sig,
        interrupt_pulse => timer_int_sig
    );

    Nokia_Driver_Comp : Nokia5110_Driver
    port map (
        CLK => CLK,
        CLK_SPI => CLK_SPI,
        RSTn => RSTn,
        enable => timer_out_sig,

        SPIDO => SPIDO,
        SPICLK => SPICLK,
        data_command => data_command,
        chip_enable => chip_enable,
        RSTout => RSTout
    );

    process(CLK, RSTn)
    begin
        buttons_last <= Board_Buttons;
        if(RSTn = '0') then
            LCD_Backlight_sig <= '1';
        elsif(rising_edge(Board_Buttons(0))) then
            LCD_Backlight_sig <= not LCD_Backlight_sig;
        end if;
    end process;

    -- BEGIN outputs directly to board pins
	Board_LEDs(0) <= not Board_Buttons(0);
	Board_LEDs(1) <= '0';
	Board_LEDs(2) <= not Board_Buttons(1);
	Board_LEDs(3) <= '0';
	Board_LEDs(4) <= not (Board_Buttons(0) and Board_Buttons(1));
	Board_LEDs(5) <= not (Board_Buttons(0) and Board_Buttons(1));
	Board_LEDs(6) <= not (Board_Buttons(0) and Board_Buttons(1));
	Board_LEDs(7) <= '0';

	Board_MOD1(0) <= '0';
	Board_MOD1(1) <= '0';
	Board_MOD1(2) <= '0';
	Board_MOD1(3) <= '0';
	Board_MOD1(4) <= '0';
	Board_MOD1(5) <= '0';

	Board_J7(0) <= '0';
	Board_J7(1) <= RSTout;     -- Nokia5110 LCD ~RESET
	Board_J7(2) <= '0';
	Board_J7(3) <= LCD_Backlight_sig;     -- Nokia5110 LCD Brightness
	Board_J7(4) <= '0';

	Board_J8 <= SPIDO;        -- SPI Data Out
	Board_J9 <= SPICLK;        -- SPI CLK
	Board_J10 <= data_command;       -- Nokia5110 D/~C, Command/address and Data in select
	Board_J11 <= chip_enable;       -- Nokia5110 Chip Enable
	-- END outputs directly to board pins

   -- architecture body
end architecture_Nokia_Driver_Container;
