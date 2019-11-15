--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: data_to_pixelbar.vhd
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

entity data_to_pixelbar is
generic (
	g_data_width : natural := 8;
	g_pixels_line_length : natural := 32
);
port (
    PCLK : in std_logic;

    data_in : in std_logic_vector(g_data_width - 1 downto 0);
    pixels_ready : out std_logic;       -- this is an interrupt

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
end data_to_pixelbar;
architecture architecture_data_to_pixelbar of data_to_pixelbar is

    signal pixels_ready_sig : std_logic := '0';

    -- BEGIN APB signals
    signal prdata_sig : std_logic_vector(7 downto 0) := (others => '0');
    -- END APB signals

begin
    --=========================================================================
    -- BEGIN APB Register Read logic
    APB_Reg_Read_process: process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            prdata_sig <= (others => '0');
        elsif(rising_edge(PCLK)) then
            if(PWRITE = '0' and PSEL = '1') then
                case PADDR is
                    when DSC_ctrl_reg_ADDR =>
                        prdata_sig <= DSC_ctrl_reg;
                    when DSC_data0_pixels_ADDR =>
                        prdata_sig <= DSC_data0_pixels_reg;
                    when DSC_data1_pixels_ADDR =>
                        prdata_sig <= DSC_data1_pixels_reg;
                    when DSC_data2_pixels_ADDR =>
                        prdata_sig <= DSC_data2_pixels_reg;
                    when DSC_data3_pixels_ADDR =>
                        prdata_sig <= DSC_data3_pixels_reg;
                    when others =>
                        prdata_sig <= (others => '0');
                end case;
            else
                prdata_sig <= (others => '0');
            end if;
        end if;
    end process;

    -- BEGIN APB Return wires
    PRDATA <= prdata_sig;
    PREADY <= '1'; --pready_sig;
    PSLVERR <= '0';
    -- END APB Return wires

    -- END APB Register Read logic
    --=========================================================================
    -- BEGIN Register Write logic

    p_DSC_reg_ctrl : process(PCLK, RSTn)
    begin
        if(RSTn = '0') then
            DSC_ctrl_reg <= "00000000";
        elsif(rising_edge(PCLK)) then
            if(PSEL = '1' and PENABLE = '1' and PWRITE = '1' and PADDR = DSC_ctrl_reg_ADDR) then
                -- 0bXXXXXXX & enable
                DSC_ctrl_reg <= PWDATA;
            else
                null;
            end if;
        end if;
    end process;

    --=========================================================================

    

   -- architecture body
end architecture_data_to_pixelbar;
