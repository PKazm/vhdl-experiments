--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Pixelbar_Creator.vhd
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

entity Pixelbar_Creator is
generic (
    g_pixel_registers : natural := 1;
    g_pixel_register_size : natural := 8;
    g_data_in_bits : natural := 8
);
port (
    PCLK : in std_logic;      -- 100Mhz
    RSTn : in std_logic;

    Data_in_ready : in std_logic;
    Data_in : in std_logic_vector(g_data_in_bits - 1 downto 0);
    Pixel_bar_out : out std_logic_vector((g_pixel_registers * g_pixel_register_size) - 1 downto 0);
    --Data_out : out std_logic_vector(g_data_bits - 1 downto 0);
    Data_out_ready : out std_logic;

    -- APB connections
    PADDR : in std_logic_vector(7 downto 0);
	PSEL : in std_logic;
	PENABLE : in std_logic;
	PWRITE : in std_logic;
	PWDATA : in std_logic_vector(7 downto 0);
	PREADY : out std_logic;
	PRDATA : out std_logic_vector(7 downto 0);
	PSLVERR : out std_logic;

	INT : out std_logic
    -- APB connections
);
end Pixelbar_Creator;
architecture architecture_Pixelbar_Creator of Pixelbar_Creator is
    constant pixels_total : natural := g_pixel_registers * g_pixel_register_size;
    signal pixel_array_sig : std_logic_vector(pixels_total - 1 downto 0) := (others => '0');

    signal data_in_ready_last : std_logic;

    constant CTRL_ADDR : std_logic_vector(7 downto 0) := X"00";
    constant PIXEL_START_ADDR : std_logic_vector(7 downto 0) := "10000000";

    signal ctrl_reg : std_logic_vector(7 downto 0);

    -- BEGIN APB signals
    signal PADDR_sig : std_logic_vector(7 downto 0);
    signal PSEL_sig : std_logic;
    signal PENABLE_sig : std_logic;
    signal PWRITE_sig : std_logic;
    signal PWDATA_sig : std_logic_vector(7 downto 0);
    signal PREADY_sig : std_logic;
    signal PRDATA_sig : std_logic_vector(7 downto 0);
    signal PSLVERR_sig : std_logic;
    -- END APB signals

begin

    --=========================================================================
    -- BEGIN APB Register Read logic
    p_APB_Reg_Read : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            PRDATA_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PWRITE = '0' and PSEL = '1') then
                if(PADDR(7) = '0') then
                    case PADDR is
                        when CTRL_ADDR =>
                            PRDATA_sig <= ctrl_reg;
                        when others =>
                            PRDATA_sig <= (others => '0');
                    end case;
                else
                    --PRDATA_sig <= pixel_array_sig();
                end if;
            else
                PRDATA_sig <= (others => '0');
            end if;
        end if;
    end process;

    -- BEGIN APB Return wires
    PRDATA <= PRDATA_sig;
    PREADY <= '1'; --pready_sig;
    PSLVERR <= '0';
    -- END APB Return wires

    -- END APB Register Read logic
    --=========================================================================
    -- BEGIN Register Write logic


    p_DSC_reg_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            ctrl_reg <= "00000000";
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = CTRL_ADDR) then
                -- 0bXXXX_XXXX
                ctrl_reg <= PWDATA;
            else
                null;
            end if;
        end if;
    end process;


    -- END Register Write logic
    --=========================================================================


    p_pixel_bar_from_value : process(PCLK, RSTn)
    begin
		if(RSTn = '0') then
            pixel_array_sig <= (others => '0');
            data_in_ready_last <= '0';
            Data_out_ready <= '0';
        elsif(rising_edge(PCLK)) then
            data_in_ready_last <= Data_in_ready;
            if(data_in_ready_last = '0' and Data_in_ready = '1') then
                Data_out_ready <= '0';
                for I in 0 to pixels_total - 1 loop
                    -- i * (2 ^ bits) / pixels_total
                    if(to_integer(unsigned(Data_in)) > (I * ((2 ** g_data_in_bits) / pixels_total))) then
                        pixel_array_sig(I) <= '1';
                    else
                        pixel_array_sig(I) <= '0';
                    end if;
                end loop;
            else
                Data_out_ready <= '1';
            end if;
        end if;
    end process;

    Pixel_bar_out <= pixel_array_sig;
   -- architecture body
end architecture_Pixelbar_Creator;
