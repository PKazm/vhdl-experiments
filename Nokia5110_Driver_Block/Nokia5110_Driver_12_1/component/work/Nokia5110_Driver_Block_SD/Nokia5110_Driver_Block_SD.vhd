----------------------------------------------------------------------
-- Created by SmartDesign Sat Nov 16 02:18:20 2019
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
----------------------------------------------------------------------
-- Nokia5110_Driver_Block_SD entity declaration
----------------------------------------------------------------------
entity Nokia5110_Driver_Block_SD is
    -- Port list
    port(
        -- Inputs
        CLK          : in  std_logic;
        PADDR        : in  std_logic_vector(7 downto 0);
        PENABLE      : in  std_logic;
        PSEL         : in  std_logic;
        PWDATA       : in  std_logic_vector(7 downto 0);
        PWRITE       : in  std_logic;
        RSTn         : in  std_logic;
        -- Outputs
        PRDATA       : out std_logic_vector(7 downto 0);
        PREADY       : out std_logic;
        PSLVERR      : out std_logic;
        RSTout       : out std_logic;
        SPICLK       : out std_logic;
        SPIDO        : out std_logic;
        chip_enable  : out std_logic;
        data_command : out std_logic;
        driver_busy  : out std_logic
        );
end Nokia5110_Driver_Block_SD;
----------------------------------------------------------------------
-- Nokia5110_Driver_Block_SD architecture body
----------------------------------------------------------------------
architecture RTL of Nokia5110_Driver_Block_SD is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- Nokia5110_Driver
-- using entity instantiation for component Nokia5110_Driver
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal APB_Slave_PRDATA        : std_logic_vector(7 downto 0);
signal APB_Slave_PREADY        : std_logic;
signal APB_Slave_PSLVERR       : std_logic;
signal chip_enable_net_0       : std_logic;
signal data_command_net_0      : std_logic;
signal driver_busy_net_0       : std_logic;
signal RSTout_net_0            : std_logic;
signal SPICLK_net_0            : std_logic;
signal SPIDO_net_0             : std_logic;
signal RSTout_net_1            : std_logic;
signal driver_busy_net_1       : std_logic;
signal SPIDO_net_1             : std_logic;
signal SPICLK_net_1            : std_logic;
signal data_command_net_1      : std_logic;
signal chip_enable_net_1       : std_logic;
signal APB_Slave_PRDATA_net_0  : std_logic_vector(7 downto 0);
signal APB_Slave_PREADY_net_0  : std_logic;
signal APB_Slave_PSLVERR_net_0 : std_logic;

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 RSTout_net_1            <= RSTout_net_0;
 RSTout                  <= RSTout_net_1;
 driver_busy_net_1       <= driver_busy_net_0;
 driver_busy             <= driver_busy_net_1;
 SPIDO_net_1             <= SPIDO_net_0;
 SPIDO                   <= SPIDO_net_1;
 SPICLK_net_1            <= SPICLK_net_0;
 SPICLK                  <= SPICLK_net_1;
 data_command_net_1      <= data_command_net_0;
 data_command            <= data_command_net_1;
 chip_enable_net_1       <= chip_enable_net_0;
 chip_enable             <= chip_enable_net_1;
 APB_Slave_PRDATA_net_0  <= APB_Slave_PRDATA;
 PRDATA(7 downto 0)      <= APB_Slave_PRDATA_net_0;
 APB_Slave_PREADY_net_0  <= APB_Slave_PREADY;
 PREADY                  <= APB_Slave_PREADY_net_0;
 APB_Slave_PSLVERR_net_0 <= APB_Slave_PSLVERR;
 PSLVERR                 <= APB_Slave_PSLVERR_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- Nokia5110_Driver_0
Nokia5110_Driver_0 : entity work.Nokia5110_Driver
    generic map( 
        g_clk_period   => ( 10 ),
        g_clk_spi_div  => ( 50 ),
        g_frame_buffer => ( 1 ),
        g_frame_size   => ( 8 ),
        g_update_rate  => ( 1 )
        )
    port map( 
        -- Inputs
        CLK          => CLK,
        RSTn         => RSTn,
        PADDR        => PADDR,
        PSEL         => PSEL,
        PENABLE      => PENABLE,
        PWRITE       => PWRITE,
        PWDATA       => PWDATA,
        -- Outputs
        driver_busy  => driver_busy_net_0,
        SPIDO        => SPIDO_net_0,
        SPICLK       => SPICLK_net_0,
        data_command => data_command_net_0,
        chip_enable  => chip_enable_net_0,
        RSTout       => RSTout_net_0,
        PREADY       => APB_Slave_PREADY,
        PRDATA       => APB_Slave_PRDATA,
        PSLVERR      => APB_Slave_PSLVERR 
        );

end RTL;
