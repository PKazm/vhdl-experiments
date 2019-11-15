-- ********************************************************************/
-- Copyright 2012 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  ram128x8_smartfusion2.vhd
--
-- Description: Simple APB Bus Controller
--              Low Level RAM Model (SmartFusion2 Family)
--
--
-- Notes:
--
-- *********************************************************************/

library ieee;
use ieee.std_logic_1164.all;
library smartfusion2;

entity COREABC_C0_COREABC_C0_0_RAM128X8 is
    port(
        WD      : in  std_logic_vector(7 downto 0);
        WADDR   : in  std_logic_vector(6 downto 0);
        RADDR   : in  std_logic_vector(6 downto 0);
        WEN     : in  std_logic;
        WCLK    : in  std_logic;
        RCLK    : in  std_logic;
        RESETN  : in  std_logic;
        RD      : out std_logic_vector(7 downto 0)
    );
end COREABC_C0_COREABC_C0_0_RAM128X8;

architecture RTL of COREABC_C0_COREABC_C0_0_RAM128X8 is

    component RAM64x18
    generic (
        MEMORYFILE      : String  := ""
    );
    port (
        A_DOUT          : out   std_logic_vector(17 downto 0);
        B_DOUT          : out   std_logic_vector(17 downto 0);
        BUSY            : out   std_logic;
        A_ADDR_CLK      : in    std_logic;
        A_DOUT_CLK      : in    std_logic;
        A_ADDR_SRST_N   : in    std_logic;
        A_DOUT_SRST_N   : in    std_logic;
        A_ADDR_ARST_N   : in    std_logic;
        A_DOUT_ARST_N   : in    std_logic;
        A_ADDR_EN       : in    std_logic;
        A_DOUT_EN       : in    std_logic;
        A_BLK           : in    std_logic_vector(1 downto 0);
        A_ADDR          : in    std_logic_vector(9 downto 0);
        B_ADDR_CLK      : in    std_logic;
        B_DOUT_CLK      : in    std_logic;
        B_ADDR_SRST_N   : in    std_logic;
        B_DOUT_SRST_N   : in    std_logic;
        B_ADDR_ARST_N   : in    std_logic;
        B_DOUT_ARST_N   : in    std_logic;
        B_ADDR_EN       : in    std_logic;
        B_DOUT_EN       : in    std_logic;
        B_BLK           : in    std_logic_vector(1 downto 0);
        B_ADDR          : in    std_logic_vector(9 downto 0);
        C_CLK           : in    std_logic;
        C_ADDR          : in    std_logic_vector(9 downto 0);
        C_DIN           : in    std_logic_vector(17 downto 0);
        C_WEN           : in    std_logic;
        C_BLK           : in    std_logic_vector(1 downto 0);
        A_EN            : in    std_logic;
        A_ADDR_LAT      : in    std_logic;
        A_DOUT_LAT      : in    std_logic;
        A_WIDTH         : in    std_logic_vector(2 downto 0);
        B_EN            : in    std_logic;
        B_ADDR_LAT      : in    std_logic;
        B_DOUT_LAT      : in    std_logic;
        B_WIDTH         : in    std_logic_vector(2 downto 0);
        C_EN            : in    std_logic;
        C_WIDTH         : in    std_logic_vector(2 downto 0);
        SII_LOCK        : in    std_logic
    );
    end component;

    signal DOUT_RAM_0   : std_logic_vector(17 downto 0);
    signal VCC_1_net    : std_logic;
    signal GND_1_net    : std_logic;
    signal A_ADDR       : std_logic_vector( 9 downto 0);
    signal C_ADDR       : std_logic_vector( 9 downto 0);
    signal C_DIN        : std_logic_vector(17 downto 0);

begin

    RD <= DOUT_RAM_0(7 downto 0);

    VCC_1_net <= '1';
    GND_1_net <= '0';

    A_ADDR <= RADDR(6 downto 0) & "000";
    C_ADDR <= WADDR(6 downto 0) & "000";
    C_DIN  <= "0000000000" & WD(7 downto 0);

    U_RAM64x18 : RAM64x18
    port map (
        A_DOUT         => DOUT_RAM_0,
        B_DOUT         => open,
        BUSY           => open,
        A_ADDR_CLK     => RCLK,
        A_DOUT_CLK     => VCC_1_net,
        A_ADDR_SRST_N  => VCC_1_net,
        A_DOUT_SRST_N  => VCC_1_net,
        A_ADDR_ARST_N  => RESETN,
        A_DOUT_ARST_N  => VCC_1_net,
        A_ADDR_EN      => VCC_1_net,
        A_DOUT_EN      => VCC_1_net,
        A_BLK          => "11",
        A_ADDR         => A_ADDR,
        B_ADDR_CLK     => VCC_1_net,
        B_DOUT_CLK     => VCC_1_net,
        B_ADDR_SRST_N  => VCC_1_net,
        B_DOUT_SRST_N  => VCC_1_net,
        B_ADDR_ARST_N  => VCC_1_net,
        B_DOUT_ARST_N  => VCC_1_net,
        B_ADDR_EN      => VCC_1_net,
        B_DOUT_EN      => VCC_1_net,
        B_BLK          => "00",
        B_ADDR         => "0000000000",
        C_CLK          => WCLK,
        C_ADDR         => C_ADDR,
        C_DIN          => C_DIN,
        C_WEN          => WEN,
        C_BLK          => "11",
        A_EN           => VCC_1_net,
        A_ADDR_LAT     => GND_1_net,
        A_DOUT_LAT     => VCC_1_net,
        B_EN           => VCC_1_net,
        B_ADDR_LAT     => GND_1_net,
        B_DOUT_LAT     => VCC_1_net,
        C_EN           => VCC_1_net,
        A_WIDTH        => "011",
        B_WIDTH        => "011",
        C_WIDTH        => "011",
        SII_LOCK       => GND_1_net
     );

end RTL;
