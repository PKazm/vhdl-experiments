----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Fri Jan 10 03:24:04 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_Core_APB3_tb.vhd
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity I2C_Core_APB3_tb is
end I2C_Core_APB3_tb;

architecture behavioral of I2C_Core_APB3_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant SEQ_REG_CNT : natural := 32;

    -- APB
    signal PADDR : std_logic_vector(7 downto 0) := (others => '0');
    signal PSEL : std_logic := '0';
    signal PENABLE : std_logic := '0';
    signal PWRITE : std_logic := '0';
    signal PWDATA : std_logic_vector(7 downto 0) := (others => '0');
    signal PREADY : std_logic := '0';
    signal PRDATA : std_logic_vector(7 downto 0) := (others => '0');
    signal PSLVERR : std_logic := '0';
    -- APB

    --I2C
    signal SDAI : std_logic := '0';
    signal SDAO : std_logic := '0';
    signal SDAE : std_logic := '0';
    signal SCLI : std_logic := '0';
    signal SCLO : std_logic := '0';
    signal SCLE : std_logic := '0';
    --I2C

    -- I2C Spies
    signal i2c_ctrl_spy : std_logic_vector(7 downto 0);
    signal i2c_data_spy : std_logic_vector(7 downto 0);
    signal i2c_clk_spy : std_logic_vector(15 downto 0);
    signal auto_ctrl_spy : std_logic_vector(7 downto 0);
    signal reg_update_spy : std_logic;
    -- I2C Spies

    signal trigger_auto : std_logic := '0';

    component I2C_Core_APB3
        generic (
            g_auto_reg_max : natural
        );
        -- ports
        port( 
            -- Inputs
            PCLK : in std_logic;
            RSTn : in std_logic;
            PADDR : in std_logic_vector(7 downto 0);
            PSEL : in std_logic;
            PENABLE : in std_logic;
            PWRITE : in std_logic;
            PWDATA : in std_logic_vector(7 downto 0);
            SDAI : in std_logic;
            SCLI : in std_logic;
            trigger_auto : in std_logic;

            -- Outputs
            PREADY : out std_logic;
            PRDATA : out std_logic_vector(7 downto 0);
            PSLVERR : out std_logic;
            SDAO : out std_logic;
            SDAE : out std_logic;
            SCLO : out std_logic;
            SCLE : out std_logic

            -- Inouts

        );
    end component;

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  I2C_Core_APB3
    I2C_Core_APB3_0 : I2C_Core_APB3
        generic map(
            g_auto_reg_max => SEQ_REG_CNT
        )
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            RSTn => NSYSRESET,
            PADDR => PADDR,
            PSEL => PSEL,
            PENABLE => PENABLE,
            PWRITE => PWRITE,
            PWDATA => PWDATA,
            SDAI => SDAI,
            SCLI => SCLI,
            trigger_auto => trigger_auto,

            -- Outputs
            PREADY =>  PREADY,
            PRDATA => PRDATA,
            PSLVERR =>  PSLVERR,
            SDAO =>  SDAO,
            SDAE =>  SDAE,
            SCLO =>  SCLO,
            SCLE => SCLE

            -- Inouts

        );

    spy_process : process
    begin
        init_signal_spy("I2C_Core_APB3_0/I2C_Core_0/i2c_reg_ctrl", "i2c_ctrl_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core_0/i2c_data", "i2c_data_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/I2C_Core_0/i2c_clk_div", "i2c_clk_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/auto_ctrl", "auto_ctrl_spy", 1, -1);
        init_signal_spy("I2C_Core_APB3_0/reg_update", "reg_update_spy", 1, -1);
        wait;
    end process;

    The_Stuff : process
        variable seq_reg : std_logic_vector(9 downto 0) := (others => '0');
    begin

        -- initialize

        SDAI <= '1';
        SCLI <= '1';

        PADDR <= (others => '0');
        PSEL <= '0';
        PENABLE <= '0';
        PWRITE <= '0';
        PWDATA <= (others => '0');

        wait until(NSYSRESET = '1');


        -- APB reads to check sequence register defaults

        for i in 0 to SEQ_REG_CNT - 1 loop

            -- APB idle state
            -- APB setup state
            PADDR <= "10" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '0';
            seq_reg := (others => '0');

            wait for ( SYSCLK_PERIOD * 1);
            -- APB enter access state

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            -- APB leave Access state
            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;

            assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);

            seq_reg(7 downto 0) := PRDATA;

            -- APB idle state
            -- APB setup state
            PADDR <= "11" & std_logic_vector(to_unsigned(i, 6));
            PSEL <= '1';
            PWRITE <= '0';

            wait for ( SYSCLK_PERIOD * 1);
            -- APB enter access state

            PENABLE <= '1';

            wait for ( SYSCLK_PERIOD * 1);

            -- APB leave Access state
            if(PREADY /= '1') then
                wait until (PREADY = '1');
            end if;

            seq_reg(9 downto 8) := PRDATA(1 downto 0);

            report "Sequense Register: " & integer'image(i) & " = " & to_string(seq_reg(9 downto 8)) & "_" & to_hstring(seq_reg(7 downto 0));
            
        end loop;

        -- APB writes to setup I2C Core

        -- APB idle state
        -- APB setup state
        PADDR <= X"02";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= X"80";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "I2C CLK0 written";

        -- APB idle state
        -- APB setup state
        PADDR <= X"00";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= "00000001";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "I2C Control written";

        -- APB idle state
        -- APB setup state
        PADDR <= X"10";
        PSEL <= '1';
        PWRITE <= '1';
        PWDATA <= "00000011";

        wait for ( SYSCLK_PERIOD * 1);
        -- APB enter access state

        PENABLE <= '1';

        wait for ( SYSCLK_PERIOD * 1);

        -- APB leave Access state
        if(PREADY /= '1') then
            wait until (PREADY = '1');
        end if;

        assert(PSLVERR = '0') report "APB error : " & std_logic'image(PSLVERR);
        report "Auto Control written";
        
        -- Enable sequence via APB

        -- Enable sequence via trigger_auto
    end process;

end behavioral;

