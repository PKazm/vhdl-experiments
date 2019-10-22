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

entity APB_Interface is
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

	Reg_Addr : out std_logic_vector(7 downto 0);
	Reg_Value_in : in std_logic_vector(7 downto 0);
	Reg_Value_out : out std_logic_vector(7 downto 0);
	Write_High : out std_logic;
	Enable : out std_logic;		-- indicator for parent VHDL entity
	Handled : in std_logic		-- response from parent "I'm done"
);
end APB_Interface;
architecture architecture_APB_Interface of APB_Interface is
	-- APB slave will only see activity from master setup and access
	type state_machine_apb is(APBidle, APBsetup, APBaccess, APBaccess2);
	signal apb_fsm : state_machine_apb;

	signal prdata_sig : std_logic_vector (7 downto 0) := (others => '0');
	signal pready_sig : std_logic := '0';

	signal reg_value_sig : std_logic_vector (7 downto 0) := (others => '0');

begin

	process(PCLK)
		variable paddr_var : std_logic_vector(7 downto 0);
		variable pwdata_var : std_logic_vector(7 downto 0);
	begin
		-- slave states lag the master state
		if(rising_edge(PCLK)) then
			case apb_fsm is
				when APBidle =>		-- Idle State
					if(PSELx = '1') then		-- master is in SETUP and will be in ACCESS next clock
						apb_fsm <= APBaccess;
						Enable <= '1';
						if(PWRITE = '1') then
							-- I am ready to read immediately
							pready_sig <= '1';
						else
							-- I am not ready to write immediately. (probably)
							pready_sig <= '0';
						end if;
					else
						prdata_sig <= X"00";
						Enable <= '0';
					end if;
				when APBaccess =>		-- Master has done SETUP and is currently in ACCESS
					-- I only want the important bits from APB address
					--paddr_var := PADDR(7 downto 0);
					--pwdata_var := PWDATA(7 downto 0);

					if(PENABLE = '1') then
						if(PWRITE = '1')then
							pready_sig <= '1';
							reg_value_sig <= pwdata_var;
						else
							pready_sig <= '1';
							-- if parent doesn't set Reg_Value_in super quick.... try again tomorrow I guess
							prdata_sig <= Reg_Value_in;
						end if;

						if(Handled = '1') then
							apb_fsm <= APBidle;
						end if;
					end if;
				when APBaccess2 =>
					-- only used if replying to master takes longer
					-- (Why don't you just hold in APBaccess the first one?)
					-- (shut up)
					apb_fsm <= APBidle;
				when others =>
					apb_fsm <= APBidle;
			end case;

		end if;

	end process;
	
	-- BEGIN APB Return wires
	PRDATA <= (31 downto 8 => '0') & prdata_sig;
	PREADY <= pready_sig;
	PSLVERR <= '0';
	-- END APB Return wires

	-- BEGIN Parent connections
	Reg_Addr <= PADDR(7 downto 0);
	Write_High <= PWRITE;
	Reg_Value_out <= PWDATA(7 downto 0);
	-- END Parent connections

   -- architecture body
end architecture_APB_Interface;
