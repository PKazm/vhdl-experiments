----------------------------------------------------------------------
-- Created by SmartDesign Sat Mar  7 02:45:16 2020
-- Version: v12.1 12.600.0.14
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library CORECORDIC_LIB;
use CORECORDIC_LIB.all;
----------------------------------------------------------------------
-- CORECORDIC_C0 entity declaration
----------------------------------------------------------------------
entity CORECORDIC_C0 is
    -- Port list
    port(
        -- Inputs
        CLK        : in  std_logic;
        DIN_VALID  : in  std_logic;
        DIN_X      : in  std_logic_vector(9 downto 0);
        DIN_Y      : in  std_logic_vector(9 downto 0);
        NGRST      : in  std_logic;
        RST        : in  std_logic;
        -- Outputs
        DOUT_A     : out std_logic_vector(9 downto 0);
        DOUT_VALID : out std_logic;
        DOUT_X     : out std_logic_vector(9 downto 0);
        RFD        : out std_logic
        );
end CORECORDIC_C0;
----------------------------------------------------------------------
-- CORECORDIC_C0 architecture body
----------------------------------------------------------------------
architecture RTL of CORECORDIC_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC   -   Actel:DirectCore:CORECORDIC:4.0.102
component CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC
    generic( 
        ARCHITECT  : integer := 1 ;
        COARSE     : integer := 0 ;
        DP_OPTION  : integer := 0 ;
        DP_WIDTH   : integer := 16 ;
        IN_BITS    : integer := 10 ;
        ITERATIONS : integer := 48 ;
        MODE       : integer := 2 ;
        OUT_BITS   : integer := 10 ;
        ROUND      : integer := 1 
        );
    -- Port list
    port(
        -- Inputs
        CLK        : in  std_logic;
        DIN_A      : in  std_logic_vector(9 downto 0);
        DIN_VALID  : in  std_logic;
        DIN_X      : in  std_logic_vector(9 downto 0);
        DIN_Y      : in  std_logic_vector(9 downto 0);
        NGRST      : in  std_logic;
        RST        : in  std_logic;
        -- Outputs
        DOUT_A     : out std_logic_vector(9 downto 0);
        DOUT_VALID : out std_logic;
        DOUT_X     : out std_logic_vector(9 downto 0);
        DOUT_Y     : out std_logic_vector(9 downto 0);
        RFD        : out std_logic
        );
end component;
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal DOUT_A_1         : std_logic_vector(9 downto 0);
signal DOUT_VALID_net_0 : std_logic;
signal DOUT_X_2         : std_logic_vector(9 downto 0);
signal RFD_net_0        : std_logic;
signal DOUT_VALID_net_1 : std_logic;
signal RFD_net_1        : std_logic;
signal DOUT_X_2_net_0   : std_logic_vector(9 downto 0);
signal DOUT_A_1_net_0   : std_logic_vector(9 downto 0);
----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal DIN_A_const_net_0: std_logic_vector(9 downto 0);

begin
----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
 DIN_A_const_net_0 <= B"0000000000";
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 DOUT_VALID_net_1   <= DOUT_VALID_net_0;
 DOUT_VALID         <= DOUT_VALID_net_1;
 RFD_net_1          <= RFD_net_0;
 RFD                <= RFD_net_1;
 DOUT_X_2_net_0     <= DOUT_X_2;
 DOUT_X(9 downto 0) <= DOUT_X_2_net_0;
 DOUT_A_1_net_0     <= DOUT_A_1;
 DOUT_A(9 downto 0) <= DOUT_A_1_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CORECORDIC_C0_0   -   Actel:DirectCore:CORECORDIC:4.0.102
CORECORDIC_C0_0 : CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC
    generic map( 
        ARCHITECT  => ( 1 ),
        COARSE     => ( 0 ),
        DP_OPTION  => ( 0 ),
        DP_WIDTH   => ( 16 ),
        IN_BITS    => ( 10 ),
        ITERATIONS => ( 48 ),
        MODE       => ( 2 ),
        OUT_BITS   => ( 10 ),
        ROUND      => ( 1 )
        )
    port map( 
        -- Inputs
        RST        => RST,
        NGRST      => NGRST,
        CLK        => CLK,
        DIN_VALID  => DIN_VALID,
        DIN_X      => DIN_X,
        DIN_Y      => DIN_Y,
        DIN_A      => DIN_A_const_net_0, -- tied to X"0" from definition
        -- Outputs
        DOUT_VALID => DOUT_VALID_net_0,
        RFD        => RFD_net_0,
        DOUT_X     => DOUT_X_2,
        DOUT_Y     => OPEN,
        DOUT_A     => DOUT_A_1 
        );

end RTL;
