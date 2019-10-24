--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Register_Core.vhd
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

package register_pkg is
	type register_array is array (natural range <>) of std_logic_vector;
end package;


library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.register_pkg.all;


entity Register_Core is
generic (
	register_count : natural := 2;
	register_size : natural := 8;
	address_offsets : natural := 1
);
port (
    --<port_name> : <direction> <type>;
	
	-- BEGIN APB Stuff
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
	-- END APB Stuff

	-- BEGIN Parent Stuff
	Reg_Access_In : in register_array(register_count - 1 downto 0)(register_size - 1 downto 0);
	Reg_Access_Out : out register_array(register_count - 1 downto 0)(register_size - 1 downto 0);
	--Reg_Access_Out : out std_logic_vector((register_size * register_count) - 1 downto 0);
	--Reg_Access_In : in std_logic_vector((register_size * register_count) - 1 downto 0);
	Reg_Busy : out std_logic;		-- indicates APB (or other) is updating registers
	Reg_Update : in std_logic		-- indicates parent has updated registers
	-- END Parent Stuff
);
end Register_Core;
architecture architecture_Register_Core of Register_Core is
	-- APB slave will only see activity from master setup and access
	type state_machine_apb is(APBidle, APBsetup, APBaccess, APBaccess2);
	signal apb_fsm : state_machine_apb;

	signal prdata_sig : std_logic_vector (register_size - 1 downto 0) := (others => '0');
	signal pready_sig : std_logic := '0';

	signal register_update : std_logic := '0';

	--signal reg_sequence_sig : std_logic_vector ((register_size * register_count) - 1 downto 0) := (others => '0');
	signal registers_sig : register_array(register_count - 1 downto 0)(register_size - 1 downto 0);-- := (others => '0');

begin

	process(PCLK, PRESETn)
		variable paddr_var : std_logic_vector(7 downto 0);
		variable pwdata_var : std_logic_vector(register_size-1 downto 0);
	begin
		-- slave states lag the master state
		if(PRESETn = '0') then
			apb_fsm <= APBidle;
			for i in registers_sig'low to registers_sig'high loop
				registers_sig(i) <= (others => '0');
			end loop;
		elsif(rising_edge(PCLK)) then
			case apb_fsm is
				when APBidle =>		-- Idle State
					if(PSELx = '1') then		-- master is in SETUP and will be in ACCESS next clock
						apb_fsm <= APBaccess;
						register_update <= '1';
						if(PWRITE = '1') then
							-- I am ready to read immediately
							pready_sig <= '1';
						else
							-- I am not ready to write immediately. (probably)
							pready_sig <= '0';
						end if;
					else
						prdata_sig <= (others => '0');
						register_update <= '0';
					end if;
				when APBaccess =>		-- Master has done SETUP and is currently in ACCESS
					-- I only want the important bits from APB address
					paddr_var := PADDR(7 downto 0);
					pwdata_var := PWDATA(register_size-1 downto 0);

					if(PENABLE = '1') then
						if(PWRITE = '1')then
							apb_fsm <= APBidle;
							pready_sig <= '1';
							registers_sig(to_integer(unsigned(paddr_var)) / address_offsets) <= pwdata_var;
						else
							apb_fsm <= APBaccess2;
							pready_sig <= '1';
							-- if parent doesn't set Reg_Value_in super quick.... try again tomorrow I guess
							prdata_sig <= registers_sig(to_integer(unsigned(paddr_var)) / address_offsets);
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
	PRDATA <= (31 downto register_size => '0') & prdata_sig;
	PREADY <= pready_sig;
	PSLVERR <= '0';
	-- END APB Return wires

	-- BEGIN Parent connections
	Reg_Access_Out <= registers_sig;
	Reg_Busy <= register_update;
	-- END Parent connections

   -- architecture body
end architecture_Register_Core;
