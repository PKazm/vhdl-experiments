-- Version: v12.1 12.600.0.14

library ieee;
use ieee.std_logic_1164.all;
library smartfusion2;
use smartfusion2.all;

entity DPSRAM_C0_DPSRAM_C0_0_DPSRAM is

    port( A_DIN  : in    std_logic_vector(17 downto 0);
          A_DOUT : out   std_logic_vector(17 downto 0);
          B_DIN  : in    std_logic_vector(17 downto 0);
          B_DOUT : out   std_logic_vector(17 downto 0);
          A_ADDR : in    std_logic_vector(9 downto 0);
          B_ADDR : in    std_logic_vector(9 downto 0);
          CLK    : in    std_logic;
          A_WEN  : in    std_logic;
          B_WEN  : in    std_logic
        );

end DPSRAM_C0_DPSRAM_C0_0_DPSRAM;

architecture DEF_ARCH of DPSRAM_C0_DPSRAM_C0_0_DPSRAM is 

  component RAM1K18
    generic (MEMORYFILE:string := ""; RAMINDEX:string := "");

    port( A_DOUT        : out   std_logic_vector(17 downto 0);
          B_DOUT        : out   std_logic_vector(17 downto 0);
          BUSY          : out   std_logic;
          A_CLK         : in    std_logic := 'U';
          A_DOUT_CLK    : in    std_logic := 'U';
          A_ARST_N      : in    std_logic := 'U';
          A_DOUT_EN     : in    std_logic := 'U';
          A_BLK         : in    std_logic_vector(2 downto 0) := (others => 'U');
          A_DOUT_ARST_N : in    std_logic := 'U';
          A_DOUT_SRST_N : in    std_logic := 'U';
          A_DIN         : in    std_logic_vector(17 downto 0) := (others => 'U');
          A_ADDR        : in    std_logic_vector(13 downto 0) := (others => 'U');
          A_WEN         : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_CLK         : in    std_logic := 'U';
          B_DOUT_CLK    : in    std_logic := 'U';
          B_ARST_N      : in    std_logic := 'U';
          B_DOUT_EN     : in    std_logic := 'U';
          B_BLK         : in    std_logic_vector(2 downto 0) := (others => 'U');
          B_DOUT_ARST_N : in    std_logic := 'U';
          B_DOUT_SRST_N : in    std_logic := 'U';
          B_DIN         : in    std_logic_vector(17 downto 0) := (others => 'U');
          B_ADDR        : in    std_logic_vector(13 downto 0) := (others => 'U');
          B_WEN         : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_EN          : in    std_logic := 'U';
          A_DOUT_LAT    : in    std_logic := 'U';
          A_WIDTH       : in    std_logic_vector(2 downto 0) := (others => 'U');
          A_WMODE       : in    std_logic := 'U';
          B_EN          : in    std_logic := 'U';
          B_DOUT_LAT    : in    std_logic := 'U';
          B_WIDTH       : in    std_logic_vector(2 downto 0) := (others => 'U');
          B_WMODE       : in    std_logic := 'U';
          SII_LOCK      : in    std_logic := 'U'
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

    signal \VCC\, \GND\, ADLIB_VCC : std_logic;
    signal GND_power_net1 : std_logic;
    signal VCC_power_net1 : std_logic;

begin 

    \GND\ <= GND_power_net1;
    \VCC\ <= VCC_power_net1;
    ADLIB_VCC <= VCC_power_net1;

    DPSRAM_C0_DPSRAM_C0_0_DPSRAM_R0C0 : RAM1K18

              generic map(MEMORYFILE => "DPSRAM_C0_DPSRAM_C0_0_DPSRAM_R0C0.mem"
        )

      port map(A_DOUT(17) => A_DOUT(17), A_DOUT(16) => A_DOUT(16), 
        A_DOUT(15) => A_DOUT(15), A_DOUT(14) => A_DOUT(14), 
        A_DOUT(13) => A_DOUT(13), A_DOUT(12) => A_DOUT(12), 
        A_DOUT(11) => A_DOUT(11), A_DOUT(10) => A_DOUT(10), 
        A_DOUT(9) => A_DOUT(9), A_DOUT(8) => A_DOUT(8), A_DOUT(7)
         => A_DOUT(7), A_DOUT(6) => A_DOUT(6), A_DOUT(5) => 
        A_DOUT(5), A_DOUT(4) => A_DOUT(4), A_DOUT(3) => A_DOUT(3), 
        A_DOUT(2) => A_DOUT(2), A_DOUT(1) => A_DOUT(1), A_DOUT(0)
         => A_DOUT(0), B_DOUT(17) => B_DOUT(17), B_DOUT(16) => 
        B_DOUT(16), B_DOUT(15) => B_DOUT(15), B_DOUT(14) => 
        B_DOUT(14), B_DOUT(13) => B_DOUT(13), B_DOUT(12) => 
        B_DOUT(12), B_DOUT(11) => B_DOUT(11), B_DOUT(10) => 
        B_DOUT(10), B_DOUT(9) => B_DOUT(9), B_DOUT(8) => 
        B_DOUT(8), B_DOUT(7) => B_DOUT(7), B_DOUT(6) => B_DOUT(6), 
        B_DOUT(5) => B_DOUT(5), B_DOUT(4) => B_DOUT(4), B_DOUT(3)
         => B_DOUT(3), B_DOUT(2) => B_DOUT(2), B_DOUT(1) => 
        B_DOUT(1), B_DOUT(0) => B_DOUT(0), BUSY => OPEN, A_CLK
         => CLK, A_DOUT_CLK => \VCC\, A_ARST_N => \VCC\, 
        A_DOUT_EN => \VCC\, A_BLK(2) => \VCC\, A_BLK(1) => \VCC\, 
        A_BLK(0) => \VCC\, A_DOUT_ARST_N => \VCC\, A_DOUT_SRST_N
         => \VCC\, A_DIN(17) => A_DIN(17), A_DIN(16) => A_DIN(16), 
        A_DIN(15) => A_DIN(15), A_DIN(14) => A_DIN(14), A_DIN(13)
         => A_DIN(13), A_DIN(12) => A_DIN(12), A_DIN(11) => 
        A_DIN(11), A_DIN(10) => A_DIN(10), A_DIN(9) => A_DIN(9), 
        A_DIN(8) => A_DIN(8), A_DIN(7) => A_DIN(7), A_DIN(6) => 
        A_DIN(6), A_DIN(5) => A_DIN(5), A_DIN(4) => A_DIN(4), 
        A_DIN(3) => A_DIN(3), A_DIN(2) => A_DIN(2), A_DIN(1) => 
        A_DIN(1), A_DIN(0) => A_DIN(0), A_ADDR(13) => A_ADDR(9), 
        A_ADDR(12) => A_ADDR(8), A_ADDR(11) => A_ADDR(7), 
        A_ADDR(10) => A_ADDR(6), A_ADDR(9) => A_ADDR(5), 
        A_ADDR(8) => A_ADDR(4), A_ADDR(7) => A_ADDR(3), A_ADDR(6)
         => A_ADDR(2), A_ADDR(5) => A_ADDR(1), A_ADDR(4) => 
        A_ADDR(0), A_ADDR(3) => \GND\, A_ADDR(2) => \GND\, 
        A_ADDR(1) => \GND\, A_ADDR(0) => \GND\, A_WEN(1) => A_WEN, 
        A_WEN(0) => A_WEN, B_CLK => CLK, B_DOUT_CLK => \VCC\, 
        B_ARST_N => \VCC\, B_DOUT_EN => \VCC\, B_BLK(2) => \VCC\, 
        B_BLK(1) => \VCC\, B_BLK(0) => \VCC\, B_DOUT_ARST_N => 
        \VCC\, B_DOUT_SRST_N => \VCC\, B_DIN(17) => B_DIN(17), 
        B_DIN(16) => B_DIN(16), B_DIN(15) => B_DIN(15), B_DIN(14)
         => B_DIN(14), B_DIN(13) => B_DIN(13), B_DIN(12) => 
        B_DIN(12), B_DIN(11) => B_DIN(11), B_DIN(10) => B_DIN(10), 
        B_DIN(9) => B_DIN(9), B_DIN(8) => B_DIN(8), B_DIN(7) => 
        B_DIN(7), B_DIN(6) => B_DIN(6), B_DIN(5) => B_DIN(5), 
        B_DIN(4) => B_DIN(4), B_DIN(3) => B_DIN(3), B_DIN(2) => 
        B_DIN(2), B_DIN(1) => B_DIN(1), B_DIN(0) => B_DIN(0), 
        B_ADDR(13) => B_ADDR(9), B_ADDR(12) => B_ADDR(8), 
        B_ADDR(11) => B_ADDR(7), B_ADDR(10) => B_ADDR(6), 
        B_ADDR(9) => B_ADDR(5), B_ADDR(8) => B_ADDR(4), B_ADDR(7)
         => B_ADDR(3), B_ADDR(6) => B_ADDR(2), B_ADDR(5) => 
        B_ADDR(1), B_ADDR(4) => B_ADDR(0), B_ADDR(3) => \GND\, 
        B_ADDR(2) => \GND\, B_ADDR(1) => \GND\, B_ADDR(0) => 
        \GND\, B_WEN(1) => B_WEN, B_WEN(0) => B_WEN, A_EN => 
        \VCC\, A_DOUT_LAT => \VCC\, A_WIDTH(2) => \VCC\, 
        A_WIDTH(1) => \GND\, A_WIDTH(0) => \GND\, A_WMODE => 
        \GND\, B_EN => \VCC\, B_DOUT_LAT => \VCC\, B_WIDTH(2) => 
        \VCC\, B_WIDTH(1) => \GND\, B_WIDTH(0) => \GND\, B_WMODE
         => \GND\, SII_LOCK => \GND\);
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);

    VCC_power_inst1 : VCC
      port map( Y => VCC_power_net1);


end DEF_ARCH; 
