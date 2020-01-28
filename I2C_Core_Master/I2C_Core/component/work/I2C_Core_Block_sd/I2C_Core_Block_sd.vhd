----------------------------------------------------------------------
-- Created by SmartDesign Mon Jan 27 17:10:45 2020
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
-- I2C_Core_Block_sd entity declaration
----------------------------------------------------------------------
entity I2C_Core_Block_sd is
    -- Port list
    port(
        -- Inputs
        PADDR       : in  std_logic_vector(7 downto 0);
        PCLK        : in  std_logic;
        PENABLE     : in  std_logic;
        PSEL        : in  std_logic;
        PWDATA      : in  std_logic_vector(7 downto 0);
        PWRITE      : in  std_logic;
        RSTn        : in  std_logic;
        SCLI        : in  std_logic;
        SDAI        : in  std_logic;
        trigger_seq : in  std_logic;
        -- Outputs
        INT         : out std_logic;
        PRDATA      : out std_logic_vector(7 downto 0);
        PREADY      : out std_logic;
        PSLVERR     : out std_logic;
        SCLE        : out std_logic;
        SCLO        : out std_logic;
        SDAE        : out std_logic;
        SDAO        : out std_logic
        );
end I2C_Core_Block_sd;
----------------------------------------------------------------------
-- I2C_Core_Block_sd architecture body
----------------------------------------------------------------------
architecture RTL of I2C_Core_Block_sd is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- I2C_Core_APB3
-- using entity instantiation for component I2C_Core_APB3
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal APB_Slave_PRDATA        : std_logic_vector(7 downto 0);
signal APB_Slave_PREADY        : std_logic;
signal APB_Slave_PSLVERR       : std_logic;
signal INT_net_0               : std_logic;
signal SCLE_net_0              : std_logic;
signal SCLO_net_0              : std_logic;
signal SDAE_net_0              : std_logic;
signal SDAO_net_0              : std_logic;
signal SCLE_net_1              : std_logic;
signal SDAE_net_1              : std_logic;
signal SDAO_net_1              : std_logic;
signal INT_net_1               : std_logic;
signal APB_Slave_PRDATA_net_0  : std_logic_vector(7 downto 0);
signal APB_Slave_PREADY_net_0  : std_logic;
signal APB_Slave_PSLVERR_net_0 : std_logic;
signal SCLO_net_1              : std_logic;

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 SCLE_net_1              <= SCLE_net_0;
 SCLE                    <= SCLE_net_1;
 SDAE_net_1              <= SDAE_net_0;
 SDAE                    <= SDAE_net_1;
 SDAO_net_1              <= SDAO_net_0;
 SDAO                    <= SDAO_net_1;
 INT_net_1               <= INT_net_0;
 INT                     <= INT_net_1;
 APB_Slave_PRDATA_net_0  <= APB_Slave_PRDATA;
 PRDATA(7 downto 0)      <= APB_Slave_PRDATA_net_0;
 APB_Slave_PREADY_net_0  <= APB_Slave_PREADY;
 PREADY                  <= APB_Slave_PREADY_net_0;
 APB_Slave_PSLVERR_net_0 <= APB_Slave_PSLVERR;
 PSLVERR                 <= APB_Slave_PSLVERR_net_0;
 SCLO_net_1              <= SCLO_net_0;
 SCLO                    <= SCLO_net_1;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- I2C_Core_APB3_0
I2C_Core_APB3_0 : entity work.I2C_Core_APB3
    generic map( 
        g_auto_reg_max  => ( 64 ),
        g_filter_length => ( 3 )
        )
    port map( 
        -- Inputs
        PCLK        => PCLK,
        RSTn        => RSTn,
        PADDR       => PADDR,
        PSEL        => PSEL,
        PENABLE     => PENABLE,
        PWRITE      => PWRITE,
        PWDATA      => PWDATA,
        SDAI        => SDAI,
        SCLI        => SCLI,
        trigger_seq => trigger_seq,
        -- Outputs
        PREADY      => APB_Slave_PREADY,
        PRDATA      => APB_Slave_PRDATA,
        PSLVERR     => APB_Slave_PSLVERR,
        INT         => INT_net_0,
        SDAO        => SDAO_net_0,
        SDAE        => SDAE_net_0,
        SCLO        => SCLO_net_0,
        SCLE        => SCLE_net_0 
        );

end RTL;
