--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: CORECORDIC_C0_tb.vhd
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

entity CORECORDIC_C0_tb is
end CORECORDIC_C0_tb;

architecture behavioral of CORECORDIC_C0_tb is

    constant SYSCLK_PERIOD : time := 10 ns; -- 100MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    constant data_i_width : natural := 10;
    constant data_o_width : natural := 10;

    component CORECORDIC_C0
        -- ports
        port (
            CLK : in std_logic;
            NGRST : in std_logic;
            RST : in std_logic;
            DIN_VALID : in std_logic;
            DIN_X : in std_logic_vector(data_i_width - 1 downto 0);
            DIN_Y : in std_logic_vector(data_i_width - 1 downto 0);
            RFD : out std_logic;
            DOUT_VALID : out std_logic;
            DOUT_X : out std_logic_vector(data_o_width - 1 downto 0);
            DOUT_A : out std_logic_vector(data_o_width - 1 downto 0)
        );
    end component;

    signal DIN_VALID : std_logic;
    signal DIN_X : std_logic_vector(data_i_width - 1 downto 0);
    signal DIN_Y : std_logic_vector(data_i_width - 1 downto 0);
    signal RFD : std_logic;
    signal DOUT_VALID : std_logic;
    signal DOUT_X : std_logic_vector(data_o_width - 1 downto 0);
    signal DOUT_A : std_logic_vector(data_o_width - 1 downto 0);

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

    -- Instantiate Unit Under Test:  CORECORDIC_C0
    CORECORDIC_C0_0 : CORECORDIC_C0
        -- port map
        port map( 
            CLK => SYSCLK,
            NGRST => NSYSRESET,
            RST => not NSYSRESET,
            DIN_VALID => DIN_VALID,
            DIN_X => DIN_X,
            DIN_Y => DIN_Y,
            RFD => RFD,
            DOUT_VALID => DOUT_VALID,
            DOUT_X => DOUT_X,
            DOUT_A => DOUT_A
        );

    process
    begin
        DIN_VALID <= '0';
        DIN_X <= (others => '0');
        DIN_Y <= (others => '0');

        wait until (NSYSRESET = '1');

        for i in 0 to 31 loop

            if(RFD /= '1') then
                wait until (RFD = '1');
            end if;

            case i is
                when 0 =>
                    DIN_X <= "0100000000";
                    DIN_Y <= "0000000000";
                when 1 =>
                    DIN_X <= "0100000000";
                    DIN_Y <= "0100000000";
                when 2 =>
                    DIN_X <= "1100000000";
                    DIN_Y <= "1100000000";
                when 3 =>
                    DIN_X <= "00" & std_logic_vector(to_unsigned(240, DIN_X'length - 2));
                    DIN_Y <= "00" & std_logic_vector(to_unsigned(240, DIN_X'length - 2));
                when others =>
                    DIN_X <= "00" & std_logic_vector(to_unsigned(i, DIN_X'length - 2));
                    DIN_Y <= "00" & std_logic_vector(to_unsigned(i, DIN_X'length - 2));
            end case;

            DIN_VALID <= '1';

            wait for (SYSCLK_PERIOD * 1);

            if(RFD /= '0') then
                wait until (RFD = '0');
            end if;

            DIN_VALID <= '0';

            if(DOUT_VALID /= '1') then
                wait until (DOUT_VALID = '1');
            end if;
            wait for (SYSCLK_PERIOD * 1);

            report "in: " & to_string(DIN_X) & ", " & to_string(DIN_Y) & " = " & to_string(DOUT_X) & "; " &
                    integer'image(to_integer(signed(DIN_X))) & ", " &
                    integer'image(to_integer(signed(DIN_Y))) & " = " &
                    integer'image(to_integer(signed(DOUT_X))) severity ERROR;



        end loop;

        wait;
    end process;


end behavioral;

