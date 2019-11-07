-- Version: v12.1 12.600.0.14

library ieee;
use ieee.std_logic_1164.all;
library smartfusion2;
use smartfusion2.all;

entity URAM_C0_URAM_C0_0_URAM is

    port( A_DOUT : out   std_logic_vector(7 downto 0);
          B_DOUT : out   std_logic_vector(7 downto 0);
          C_DIN  : in    std_logic_vector(7 downto 0);
          A_ADDR : in    std_logic_vector(8 downto 0);
          B_ADDR : in    std_logic_vector(8 downto 0);
          C_ADDR : in    std_logic_vector(8 downto 0);
          C_BLK  : in    std_logic;
          CLK    : in    std_logic
        );

end URAM_C0_URAM_C0_0_URAM;

architecture DEF_ARCH of URAM_C0_URAM_C0_0_URAM is 

  component OR4
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          D : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component CFG2
    generic (INIT:std_logic_vector(3 downto 0) := x"0");

    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component RAM64x18
    generic (MEMORYFILE:string := ""; RAMINDEX:string := "");

    port( A_DOUT        : out   std_logic_vector(17 downto 0);
          B_DOUT        : out   std_logic_vector(17 downto 0);
          BUSY          : out   std_logic;
          A_ADDR_CLK    : in    std_logic := 'U';
          A_DOUT_CLK    : in    std_logic := 'U';
          A_ADDR_SRST_N : in    std_logic := 'U';
          A_DOUT_SRST_N : in    std_logic := 'U';
          A_ADDR_ARST_N : in    std_logic := 'U';
          A_DOUT_ARST_N : in    std_logic := 'U';
          A_ADDR_EN     : in    std_logic := 'U';
          A_DOUT_EN     : in    std_logic := 'U';
          A_BLK         : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_ADDR        : in    std_logic_vector(9 downto 0) := (others => 'U');
          B_ADDR_CLK    : in    std_logic := 'U';
          B_DOUT_CLK    : in    std_logic := 'U';
          B_ADDR_SRST_N : in    std_logic := 'U';
          B_DOUT_SRST_N : in    std_logic := 'U';
          B_ADDR_ARST_N : in    std_logic := 'U';
          B_DOUT_ARST_N : in    std_logic := 'U';
          B_ADDR_EN     : in    std_logic := 'U';
          B_DOUT_EN     : in    std_logic := 'U';
          B_BLK         : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_ADDR        : in    std_logic_vector(9 downto 0) := (others => 'U');
          C_CLK         : in    std_logic := 'U';
          C_ADDR        : in    std_logic_vector(9 downto 0) := (others => 'U');
          C_DIN         : in    std_logic_vector(17 downto 0) := (others => 'U');
          C_WEN         : in    std_logic := 'U';
          C_BLK         : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_EN          : in    std_logic := 'U';
          A_ADDR_LAT    : in    std_logic := 'U';
          A_DOUT_LAT    : in    std_logic := 'U';
          A_WIDTH       : in    std_logic_vector(2 downto 0) := (others => 'U');
          B_EN          : in    std_logic := 'U';
          B_ADDR_LAT    : in    std_logic := 'U';
          B_DOUT_LAT    : in    std_logic := 'U';
          B_WIDTH       : in    std_logic_vector(2 downto 0) := (others => 'U');
          C_EN          : in    std_logic := 'U';
          C_WIDTH       : in    std_logic_vector(2 downto 0) := (others => 'U');
          SII_LOCK      : in    std_logic := 'U'
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

    signal \QAX_TEMPR0[0]\, \QAX_TEMPR1[0]\, \QAX_TEMPR2[0]\, 
        \QAX_TEMPR3[0]\, \QAX_TEMPR0[1]\, \QAX_TEMPR1[1]\, 
        \QAX_TEMPR2[1]\, \QAX_TEMPR3[1]\, \QAX_TEMPR0[2]\, 
        \QAX_TEMPR1[2]\, \QAX_TEMPR2[2]\, \QAX_TEMPR3[2]\, 
        \QAX_TEMPR0[3]\, \QAX_TEMPR1[3]\, \QAX_TEMPR2[3]\, 
        \QAX_TEMPR3[3]\, \QAX_TEMPR0[4]\, \QAX_TEMPR1[4]\, 
        \QAX_TEMPR2[4]\, \QAX_TEMPR3[4]\, \QAX_TEMPR0[5]\, 
        \QAX_TEMPR1[5]\, \QAX_TEMPR2[5]\, \QAX_TEMPR3[5]\, 
        \QAX_TEMPR0[6]\, \QAX_TEMPR1[6]\, \QAX_TEMPR2[6]\, 
        \QAX_TEMPR3[6]\, \QAX_TEMPR0[7]\, \QAX_TEMPR1[7]\, 
        \QAX_TEMPR2[7]\, \QAX_TEMPR3[7]\, \QBX_TEMPR0[0]\, 
        \QBX_TEMPR1[0]\, \QBX_TEMPR2[0]\, \QBX_TEMPR3[0]\, 
        \QBX_TEMPR0[1]\, \QBX_TEMPR1[1]\, \QBX_TEMPR2[1]\, 
        \QBX_TEMPR3[1]\, \QBX_TEMPR0[2]\, \QBX_TEMPR1[2]\, 
        \QBX_TEMPR2[2]\, \QBX_TEMPR3[2]\, \QBX_TEMPR0[3]\, 
        \QBX_TEMPR1[3]\, \QBX_TEMPR2[3]\, \QBX_TEMPR3[3]\, 
        \QBX_TEMPR0[4]\, \QBX_TEMPR1[4]\, \QBX_TEMPR2[4]\, 
        \QBX_TEMPR3[4]\, \QBX_TEMPR0[5]\, \QBX_TEMPR1[5]\, 
        \QBX_TEMPR2[5]\, \QBX_TEMPR3[5]\, \QBX_TEMPR0[6]\, 
        \QBX_TEMPR1[6]\, \QBX_TEMPR2[6]\, \QBX_TEMPR3[6]\, 
        \QBX_TEMPR0[7]\, \QBX_TEMPR1[7]\, \QBX_TEMPR2[7]\, 
        \QBX_TEMPR3[7]\, \BLKX0[0]\, \BLKY0[0]\, \BLKZ0[0]\, 
        \BLKX1[0]\, \BLKX1[1]\, \BLKY1[0]\, \BLKY1[1]\, 
        \BLKZ1[0]\, \BLKZ1[1]\, \VCC\, \GND\, ADLIB_VCC
         : std_logic;
    signal GND_power_net1 : std_logic;
    signal VCC_power_net1 : std_logic;
    signal nc47, nc34, nc70, nc60, nc74, nc64, nc9, nc13, nc23, 
        nc55, nc80, nc33, nc16, nc26, nc45, nc73, nc58, nc63, 
        nc27, nc17, nc36, nc48, nc37, nc5, nc52, nc76, nc51, nc66, 
        nc77, nc67, nc4, nc42, nc41, nc59, nc25, nc15, nc35, nc49, 
        nc28, nc18, nc75, nc65, nc38, nc1, nc2, nc50, nc22, nc12, 
        nc21, nc11, nc78, nc54, nc68, nc3, nc32, nc40, nc31, nc44, 
        nc7, nc72, nc6, nc71, nc62, nc61, nc19, nc29, nc53, nc39, 
        nc8, nc79, nc43, nc69, nc56, nc20, nc10, nc57, nc24, nc14, 
        nc46, nc30 : std_logic;

begin 

    \GND\ <= GND_power_net1;
    \VCC\ <= VCC_power_net1;
    ADLIB_VCC <= VCC_power_net1;

    \OR4_A_DOUT[3]\ : OR4
      port map(A => \QAX_TEMPR0[3]\, B => \QAX_TEMPR1[3]\, C => 
        \QAX_TEMPR2[3]\, D => \QAX_TEMPR3[3]\, Y => A_DOUT(3));
    
    \INVBLKX0[0]\ : INV
      port map(A => A_ADDR(7), Y => \BLKX0[0]\);
    
    \CFG2_BLKX1[1]\ : CFG2
      generic map(INIT => x"8")

      port map(A => A_ADDR(8), B => \VCC\, Y => \BLKX1[1]\);
    
    \OR4_B_DOUT[1]\ : OR4
      port map(A => \QBX_TEMPR0[1]\, B => \QBX_TEMPR1[1]\, C => 
        \QBX_TEMPR2[1]\, D => \QBX_TEMPR3[1]\, Y => B_DOUT(1));
    
    URAM_C0_URAM_C0_0_URAM_R0C0 : RAM64x18
      generic map(MEMORYFILE => "URAM_C0_URAM_C0_0_URAM_R0C0.mem"
        )

      port map(A_DOUT(17) => nc47, A_DOUT(16) => nc34, A_DOUT(15)
         => nc70, A_DOUT(14) => nc60, A_DOUT(13) => nc74, 
        A_DOUT(12) => nc64, A_DOUT(11) => nc9, A_DOUT(10) => nc13, 
        A_DOUT(9) => nc23, A_DOUT(8) => nc55, A_DOUT(7) => 
        \QAX_TEMPR0[7]\, A_DOUT(6) => \QAX_TEMPR0[6]\, A_DOUT(5)
         => \QAX_TEMPR0[5]\, A_DOUT(4) => \QAX_TEMPR0[4]\, 
        A_DOUT(3) => \QAX_TEMPR0[3]\, A_DOUT(2) => 
        \QAX_TEMPR0[2]\, A_DOUT(1) => \QAX_TEMPR0[1]\, A_DOUT(0)
         => \QAX_TEMPR0[0]\, B_DOUT(17) => nc80, B_DOUT(16) => 
        nc33, B_DOUT(15) => nc16, B_DOUT(14) => nc26, B_DOUT(13)
         => nc45, B_DOUT(12) => nc73, B_DOUT(11) => nc58, 
        B_DOUT(10) => nc63, B_DOUT(9) => nc27, B_DOUT(8) => nc17, 
        B_DOUT(7) => \QBX_TEMPR0[7]\, B_DOUT(6) => 
        \QBX_TEMPR0[6]\, B_DOUT(5) => \QBX_TEMPR0[5]\, B_DOUT(4)
         => \QBX_TEMPR0[4]\, B_DOUT(3) => \QBX_TEMPR0[3]\, 
        B_DOUT(2) => \QBX_TEMPR0[2]\, B_DOUT(1) => 
        \QBX_TEMPR0[1]\, B_DOUT(0) => \QBX_TEMPR0[0]\, BUSY => 
        OPEN, A_ADDR_CLK => \VCC\, A_DOUT_CLK => CLK, 
        A_ADDR_SRST_N => \VCC\, A_DOUT_SRST_N => \VCC\, 
        A_ADDR_ARST_N => \VCC\, A_DOUT_ARST_N => \VCC\, A_ADDR_EN
         => \VCC\, A_DOUT_EN => \VCC\, A_BLK(1) => \BLKX1[0]\, 
        A_BLK(0) => \BLKX0[0]\, A_ADDR(9) => A_ADDR(6), A_ADDR(8)
         => A_ADDR(5), A_ADDR(7) => A_ADDR(4), A_ADDR(6) => 
        A_ADDR(3), A_ADDR(5) => A_ADDR(2), A_ADDR(4) => A_ADDR(1), 
        A_ADDR(3) => A_ADDR(0), A_ADDR(2) => \GND\, A_ADDR(1) => 
        \GND\, A_ADDR(0) => \GND\, B_ADDR_CLK => \VCC\, 
        B_DOUT_CLK => CLK, B_ADDR_SRST_N => \VCC\, B_DOUT_SRST_N
         => \VCC\, B_ADDR_ARST_N => \VCC\, B_DOUT_ARST_N => \VCC\, 
        B_ADDR_EN => \VCC\, B_DOUT_EN => \VCC\, B_BLK(1) => 
        \BLKY1[0]\, B_BLK(0) => \BLKY0[0]\, B_ADDR(9) => 
        B_ADDR(6), B_ADDR(8) => B_ADDR(5), B_ADDR(7) => B_ADDR(4), 
        B_ADDR(6) => B_ADDR(3), B_ADDR(5) => B_ADDR(2), B_ADDR(4)
         => B_ADDR(1), B_ADDR(3) => B_ADDR(0), B_ADDR(2) => \GND\, 
        B_ADDR(1) => \GND\, B_ADDR(0) => \GND\, C_CLK => CLK, 
        C_ADDR(9) => C_ADDR(6), C_ADDR(8) => C_ADDR(5), C_ADDR(7)
         => C_ADDR(4), C_ADDR(6) => C_ADDR(3), C_ADDR(5) => 
        C_ADDR(2), C_ADDR(4) => C_ADDR(1), C_ADDR(3) => C_ADDR(0), 
        C_ADDR(2) => \GND\, C_ADDR(1) => \GND\, C_ADDR(0) => 
        \GND\, C_DIN(17) => \GND\, C_DIN(16) => \GND\, C_DIN(15)
         => \GND\, C_DIN(14) => \GND\, C_DIN(13) => \GND\, 
        C_DIN(12) => \GND\, C_DIN(11) => \GND\, C_DIN(10) => 
        \GND\, C_DIN(9) => \GND\, C_DIN(8) => \GND\, C_DIN(7) => 
        C_DIN(7), C_DIN(6) => C_DIN(6), C_DIN(5) => C_DIN(5), 
        C_DIN(4) => C_DIN(4), C_DIN(3) => C_DIN(3), C_DIN(2) => 
        C_DIN(2), C_DIN(1) => C_DIN(1), C_DIN(0) => C_DIN(0), 
        C_WEN => \VCC\, C_BLK(1) => \BLKZ1[0]\, C_BLK(0) => 
        \BLKZ0[0]\, A_EN => \VCC\, A_ADDR_LAT => \VCC\, 
        A_DOUT_LAT => \GND\, A_WIDTH(2) => \GND\, A_WIDTH(1) => 
        \VCC\, A_WIDTH(0) => \VCC\, B_EN => \VCC\, B_ADDR_LAT => 
        \VCC\, B_DOUT_LAT => \GND\, B_WIDTH(2) => \GND\, 
        B_WIDTH(1) => \VCC\, B_WIDTH(0) => \VCC\, C_EN => \VCC\, 
        C_WIDTH(2) => \GND\, C_WIDTH(1) => \VCC\, C_WIDTH(0) => 
        \VCC\, SII_LOCK => \GND\);
    
    \OR4_A_DOUT[1]\ : OR4
      port map(A => \QAX_TEMPR0[1]\, B => \QAX_TEMPR1[1]\, C => 
        \QAX_TEMPR2[1]\, D => \QAX_TEMPR3[1]\, Y => A_DOUT(1));
    
    \OR4_B_DOUT[4]\ : OR4
      port map(A => \QBX_TEMPR0[4]\, B => \QBX_TEMPR1[4]\, C => 
        \QBX_TEMPR2[4]\, D => \QBX_TEMPR3[4]\, Y => B_DOUT(4));
    
    \OR4_A_DOUT[4]\ : OR4
      port map(A => \QAX_TEMPR0[4]\, B => \QAX_TEMPR1[4]\, C => 
        \QAX_TEMPR2[4]\, D => \QAX_TEMPR3[4]\, Y => A_DOUT(4));
    
    \CFG2_BLKY1[1]\ : CFG2
      generic map(INIT => x"8")

      port map(A => B_ADDR(8), B => \VCC\, Y => \BLKY1[1]\);
    
    \OR4_B_DOUT[6]\ : OR4
      port map(A => \QBX_TEMPR0[6]\, B => \QBX_TEMPR1[6]\, C => 
        \QBX_TEMPR2[6]\, D => \QBX_TEMPR3[6]\, Y => B_DOUT(6));
    
    \OR4_A_DOUT[6]\ : OR4
      port map(A => \QAX_TEMPR0[6]\, B => \QAX_TEMPR1[6]\, C => 
        \QAX_TEMPR2[6]\, D => \QAX_TEMPR3[6]\, Y => A_DOUT(6));
    
    \CFG2_BLKX1[0]\ : CFG2
      generic map(INIT => x"4")

      port map(A => A_ADDR(8), B => \VCC\, Y => \BLKX1[0]\);
    
    \OR4_B_DOUT[0]\ : OR4
      port map(A => \QBX_TEMPR0[0]\, B => \QBX_TEMPR1[0]\, C => 
        \QBX_TEMPR2[0]\, D => \QBX_TEMPR3[0]\, Y => B_DOUT(0));
    
    \OR4_A_DOUT[0]\ : OR4
      port map(A => \QAX_TEMPR0[0]\, B => \QAX_TEMPR1[0]\, C => 
        \QAX_TEMPR2[0]\, D => \QAX_TEMPR3[0]\, Y => A_DOUT(0));
    
    \CFG2_BLKY1[0]\ : CFG2
      generic map(INIT => x"4")

      port map(A => B_ADDR(8), B => \VCC\, Y => \BLKY1[0]\);
    
    \OR4_B_DOUT[5]\ : OR4
      port map(A => \QBX_TEMPR0[5]\, B => \QBX_TEMPR1[5]\, C => 
        \QBX_TEMPR2[5]\, D => \QBX_TEMPR3[5]\, Y => B_DOUT(5));
    
    \OR4_B_DOUT[2]\ : OR4
      port map(A => \QBX_TEMPR0[2]\, B => \QBX_TEMPR1[2]\, C => 
        \QBX_TEMPR2[2]\, D => \QBX_TEMPR3[2]\, Y => B_DOUT(2));
    
    \OR4_A_DOUT[5]\ : OR4
      port map(A => \QAX_TEMPR0[5]\, B => \QAX_TEMPR1[5]\, C => 
        \QAX_TEMPR2[5]\, D => \QAX_TEMPR3[5]\, Y => A_DOUT(5));
    
    \OR4_A_DOUT[2]\ : OR4
      port map(A => \QAX_TEMPR0[2]\, B => \QAX_TEMPR1[2]\, C => 
        \QAX_TEMPR2[2]\, D => \QAX_TEMPR3[2]\, Y => A_DOUT(2));
    
    URAM_C0_URAM_C0_0_URAM_R2C0 : RAM64x18
      generic map(MEMORYFILE => "URAM_C0_URAM_C0_0_URAM_R2C0.mem"
        )

      port map(A_DOUT(17) => nc36, A_DOUT(16) => nc48, A_DOUT(15)
         => nc37, A_DOUT(14) => nc5, A_DOUT(13) => nc52, 
        A_DOUT(12) => nc76, A_DOUT(11) => nc51, A_DOUT(10) => 
        nc66, A_DOUT(9) => nc77, A_DOUT(8) => nc67, A_DOUT(7) => 
        \QAX_TEMPR2[7]\, A_DOUT(6) => \QAX_TEMPR2[6]\, A_DOUT(5)
         => \QAX_TEMPR2[5]\, A_DOUT(4) => \QAX_TEMPR2[4]\, 
        A_DOUT(3) => \QAX_TEMPR2[3]\, A_DOUT(2) => 
        \QAX_TEMPR2[2]\, A_DOUT(1) => \QAX_TEMPR2[1]\, A_DOUT(0)
         => \QAX_TEMPR2[0]\, B_DOUT(17) => nc4, B_DOUT(16) => 
        nc42, B_DOUT(15) => nc41, B_DOUT(14) => nc59, B_DOUT(13)
         => nc25, B_DOUT(12) => nc15, B_DOUT(11) => nc35, 
        B_DOUT(10) => nc49, B_DOUT(9) => nc28, B_DOUT(8) => nc18, 
        B_DOUT(7) => \QBX_TEMPR2[7]\, B_DOUT(6) => 
        \QBX_TEMPR2[6]\, B_DOUT(5) => \QBX_TEMPR2[5]\, B_DOUT(4)
         => \QBX_TEMPR2[4]\, B_DOUT(3) => \QBX_TEMPR2[3]\, 
        B_DOUT(2) => \QBX_TEMPR2[2]\, B_DOUT(1) => 
        \QBX_TEMPR2[1]\, B_DOUT(0) => \QBX_TEMPR2[0]\, BUSY => 
        OPEN, A_ADDR_CLK => \VCC\, A_DOUT_CLK => CLK, 
        A_ADDR_SRST_N => \VCC\, A_DOUT_SRST_N => \VCC\, 
        A_ADDR_ARST_N => \VCC\, A_DOUT_ARST_N => \VCC\, A_ADDR_EN
         => \VCC\, A_DOUT_EN => \VCC\, A_BLK(1) => \BLKX1[1]\, 
        A_BLK(0) => \BLKX0[0]\, A_ADDR(9) => A_ADDR(6), A_ADDR(8)
         => A_ADDR(5), A_ADDR(7) => A_ADDR(4), A_ADDR(6) => 
        A_ADDR(3), A_ADDR(5) => A_ADDR(2), A_ADDR(4) => A_ADDR(1), 
        A_ADDR(3) => A_ADDR(0), A_ADDR(2) => \GND\, A_ADDR(1) => 
        \GND\, A_ADDR(0) => \GND\, B_ADDR_CLK => \VCC\, 
        B_DOUT_CLK => CLK, B_ADDR_SRST_N => \VCC\, B_DOUT_SRST_N
         => \VCC\, B_ADDR_ARST_N => \VCC\, B_DOUT_ARST_N => \VCC\, 
        B_ADDR_EN => \VCC\, B_DOUT_EN => \VCC\, B_BLK(1) => 
        \BLKY1[1]\, B_BLK(0) => \BLKY0[0]\, B_ADDR(9) => 
        B_ADDR(6), B_ADDR(8) => B_ADDR(5), B_ADDR(7) => B_ADDR(4), 
        B_ADDR(6) => B_ADDR(3), B_ADDR(5) => B_ADDR(2), B_ADDR(4)
         => B_ADDR(1), B_ADDR(3) => B_ADDR(0), B_ADDR(2) => \GND\, 
        B_ADDR(1) => \GND\, B_ADDR(0) => \GND\, C_CLK => CLK, 
        C_ADDR(9) => C_ADDR(6), C_ADDR(8) => C_ADDR(5), C_ADDR(7)
         => C_ADDR(4), C_ADDR(6) => C_ADDR(3), C_ADDR(5) => 
        C_ADDR(2), C_ADDR(4) => C_ADDR(1), C_ADDR(3) => C_ADDR(0), 
        C_ADDR(2) => \GND\, C_ADDR(1) => \GND\, C_ADDR(0) => 
        \GND\, C_DIN(17) => \GND\, C_DIN(16) => \GND\, C_DIN(15)
         => \GND\, C_DIN(14) => \GND\, C_DIN(13) => \GND\, 
        C_DIN(12) => \GND\, C_DIN(11) => \GND\, C_DIN(10) => 
        \GND\, C_DIN(9) => \GND\, C_DIN(8) => \GND\, C_DIN(7) => 
        C_DIN(7), C_DIN(6) => C_DIN(6), C_DIN(5) => C_DIN(5), 
        C_DIN(4) => C_DIN(4), C_DIN(3) => C_DIN(3), C_DIN(2) => 
        C_DIN(2), C_DIN(1) => C_DIN(1), C_DIN(0) => C_DIN(0), 
        C_WEN => \VCC\, C_BLK(1) => \BLKZ1[1]\, C_BLK(0) => 
        \BLKZ0[0]\, A_EN => \VCC\, A_ADDR_LAT => \VCC\, 
        A_DOUT_LAT => \GND\, A_WIDTH(2) => \GND\, A_WIDTH(1) => 
        \VCC\, A_WIDTH(0) => \VCC\, B_EN => \VCC\, B_ADDR_LAT => 
        \VCC\, B_DOUT_LAT => \GND\, B_WIDTH(2) => \GND\, 
        B_WIDTH(1) => \VCC\, B_WIDTH(0) => \VCC\, C_EN => \VCC\, 
        C_WIDTH(2) => \GND\, C_WIDTH(1) => \VCC\, C_WIDTH(0) => 
        \VCC\, SII_LOCK => \GND\);
    
    URAM_C0_URAM_C0_0_URAM_R1C0 : RAM64x18
      generic map(MEMORYFILE => "URAM_C0_URAM_C0_0_URAM_R1C0.mem"
        )

      port map(A_DOUT(17) => nc75, A_DOUT(16) => nc65, A_DOUT(15)
         => nc38, A_DOUT(14) => nc1, A_DOUT(13) => nc2, 
        A_DOUT(12) => nc50, A_DOUT(11) => nc22, A_DOUT(10) => 
        nc12, A_DOUT(9) => nc21, A_DOUT(8) => nc11, A_DOUT(7) => 
        \QAX_TEMPR1[7]\, A_DOUT(6) => \QAX_TEMPR1[6]\, A_DOUT(5)
         => \QAX_TEMPR1[5]\, A_DOUT(4) => \QAX_TEMPR1[4]\, 
        A_DOUT(3) => \QAX_TEMPR1[3]\, A_DOUT(2) => 
        \QAX_TEMPR1[2]\, A_DOUT(1) => \QAX_TEMPR1[1]\, A_DOUT(0)
         => \QAX_TEMPR1[0]\, B_DOUT(17) => nc78, B_DOUT(16) => 
        nc54, B_DOUT(15) => nc68, B_DOUT(14) => nc3, B_DOUT(13)
         => nc32, B_DOUT(12) => nc40, B_DOUT(11) => nc31, 
        B_DOUT(10) => nc44, B_DOUT(9) => nc7, B_DOUT(8) => nc72, 
        B_DOUT(7) => \QBX_TEMPR1[7]\, B_DOUT(6) => 
        \QBX_TEMPR1[6]\, B_DOUT(5) => \QBX_TEMPR1[5]\, B_DOUT(4)
         => \QBX_TEMPR1[4]\, B_DOUT(3) => \QBX_TEMPR1[3]\, 
        B_DOUT(2) => \QBX_TEMPR1[2]\, B_DOUT(1) => 
        \QBX_TEMPR1[1]\, B_DOUT(0) => \QBX_TEMPR1[0]\, BUSY => 
        OPEN, A_ADDR_CLK => \VCC\, A_DOUT_CLK => CLK, 
        A_ADDR_SRST_N => \VCC\, A_DOUT_SRST_N => \VCC\, 
        A_ADDR_ARST_N => \VCC\, A_DOUT_ARST_N => \VCC\, A_ADDR_EN
         => \VCC\, A_DOUT_EN => \VCC\, A_BLK(1) => \BLKX1[0]\, 
        A_BLK(0) => A_ADDR(7), A_ADDR(9) => A_ADDR(6), A_ADDR(8)
         => A_ADDR(5), A_ADDR(7) => A_ADDR(4), A_ADDR(6) => 
        A_ADDR(3), A_ADDR(5) => A_ADDR(2), A_ADDR(4) => A_ADDR(1), 
        A_ADDR(3) => A_ADDR(0), A_ADDR(2) => \GND\, A_ADDR(1) => 
        \GND\, A_ADDR(0) => \GND\, B_ADDR_CLK => \VCC\, 
        B_DOUT_CLK => CLK, B_ADDR_SRST_N => \VCC\, B_DOUT_SRST_N
         => \VCC\, B_ADDR_ARST_N => \VCC\, B_DOUT_ARST_N => \VCC\, 
        B_ADDR_EN => \VCC\, B_DOUT_EN => \VCC\, B_BLK(1) => 
        \BLKY1[0]\, B_BLK(0) => B_ADDR(7), B_ADDR(9) => B_ADDR(6), 
        B_ADDR(8) => B_ADDR(5), B_ADDR(7) => B_ADDR(4), B_ADDR(6)
         => B_ADDR(3), B_ADDR(5) => B_ADDR(2), B_ADDR(4) => 
        B_ADDR(1), B_ADDR(3) => B_ADDR(0), B_ADDR(2) => \GND\, 
        B_ADDR(1) => \GND\, B_ADDR(0) => \GND\, C_CLK => CLK, 
        C_ADDR(9) => C_ADDR(6), C_ADDR(8) => C_ADDR(5), C_ADDR(7)
         => C_ADDR(4), C_ADDR(6) => C_ADDR(3), C_ADDR(5) => 
        C_ADDR(2), C_ADDR(4) => C_ADDR(1), C_ADDR(3) => C_ADDR(0), 
        C_ADDR(2) => \GND\, C_ADDR(1) => \GND\, C_ADDR(0) => 
        \GND\, C_DIN(17) => \GND\, C_DIN(16) => \GND\, C_DIN(15)
         => \GND\, C_DIN(14) => \GND\, C_DIN(13) => \GND\, 
        C_DIN(12) => \GND\, C_DIN(11) => \GND\, C_DIN(10) => 
        \GND\, C_DIN(9) => \GND\, C_DIN(8) => \GND\, C_DIN(7) => 
        C_DIN(7), C_DIN(6) => C_DIN(6), C_DIN(5) => C_DIN(5), 
        C_DIN(4) => C_DIN(4), C_DIN(3) => C_DIN(3), C_DIN(2) => 
        C_DIN(2), C_DIN(1) => C_DIN(1), C_DIN(0) => C_DIN(0), 
        C_WEN => \VCC\, C_BLK(1) => \BLKZ1[0]\, C_BLK(0) => 
        C_ADDR(7), A_EN => \VCC\, A_ADDR_LAT => \VCC\, A_DOUT_LAT
         => \GND\, A_WIDTH(2) => \GND\, A_WIDTH(1) => \VCC\, 
        A_WIDTH(0) => \VCC\, B_EN => \VCC\, B_ADDR_LAT => \VCC\, 
        B_DOUT_LAT => \GND\, B_WIDTH(2) => \GND\, B_WIDTH(1) => 
        \VCC\, B_WIDTH(0) => \VCC\, C_EN => \VCC\, C_WIDTH(2) => 
        \GND\, C_WIDTH(1) => \VCC\, C_WIDTH(0) => \VCC\, SII_LOCK
         => \GND\);
    
    \CFG2_BLKZ1[1]\ : CFG2
      generic map(INIT => x"8")

      port map(A => C_ADDR(8), B => C_BLK, Y => \BLKZ1[1]\);
    
    \INVBLKY0[0]\ : INV
      port map(A => B_ADDR(7), Y => \BLKY0[0]\);
    
    URAM_C0_URAM_C0_0_URAM_R3C0 : RAM64x18
      generic map(MEMORYFILE => "URAM_C0_URAM_C0_0_URAM_R3C0.mem"
        )

      port map(A_DOUT(17) => nc6, A_DOUT(16) => nc71, A_DOUT(15)
         => nc62, A_DOUT(14) => nc61, A_DOUT(13) => nc19, 
        A_DOUT(12) => nc29, A_DOUT(11) => nc53, A_DOUT(10) => 
        nc39, A_DOUT(9) => nc8, A_DOUT(8) => nc79, A_DOUT(7) => 
        \QAX_TEMPR3[7]\, A_DOUT(6) => \QAX_TEMPR3[6]\, A_DOUT(5)
         => \QAX_TEMPR3[5]\, A_DOUT(4) => \QAX_TEMPR3[4]\, 
        A_DOUT(3) => \QAX_TEMPR3[3]\, A_DOUT(2) => 
        \QAX_TEMPR3[2]\, A_DOUT(1) => \QAX_TEMPR3[1]\, A_DOUT(0)
         => \QAX_TEMPR3[0]\, B_DOUT(17) => nc43, B_DOUT(16) => 
        nc69, B_DOUT(15) => nc56, B_DOUT(14) => nc20, B_DOUT(13)
         => nc10, B_DOUT(12) => nc57, B_DOUT(11) => nc24, 
        B_DOUT(10) => nc14, B_DOUT(9) => nc46, B_DOUT(8) => nc30, 
        B_DOUT(7) => \QBX_TEMPR3[7]\, B_DOUT(6) => 
        \QBX_TEMPR3[6]\, B_DOUT(5) => \QBX_TEMPR3[5]\, B_DOUT(4)
         => \QBX_TEMPR3[4]\, B_DOUT(3) => \QBX_TEMPR3[3]\, 
        B_DOUT(2) => \QBX_TEMPR3[2]\, B_DOUT(1) => 
        \QBX_TEMPR3[1]\, B_DOUT(0) => \QBX_TEMPR3[0]\, BUSY => 
        OPEN, A_ADDR_CLK => \VCC\, A_DOUT_CLK => CLK, 
        A_ADDR_SRST_N => \VCC\, A_DOUT_SRST_N => \VCC\, 
        A_ADDR_ARST_N => \VCC\, A_DOUT_ARST_N => \VCC\, A_ADDR_EN
         => \VCC\, A_DOUT_EN => \VCC\, A_BLK(1) => \BLKX1[1]\, 
        A_BLK(0) => A_ADDR(7), A_ADDR(9) => A_ADDR(6), A_ADDR(8)
         => A_ADDR(5), A_ADDR(7) => A_ADDR(4), A_ADDR(6) => 
        A_ADDR(3), A_ADDR(5) => A_ADDR(2), A_ADDR(4) => A_ADDR(1), 
        A_ADDR(3) => A_ADDR(0), A_ADDR(2) => \GND\, A_ADDR(1) => 
        \GND\, A_ADDR(0) => \GND\, B_ADDR_CLK => \VCC\, 
        B_DOUT_CLK => CLK, B_ADDR_SRST_N => \VCC\, B_DOUT_SRST_N
         => \VCC\, B_ADDR_ARST_N => \VCC\, B_DOUT_ARST_N => \VCC\, 
        B_ADDR_EN => \VCC\, B_DOUT_EN => \VCC\, B_BLK(1) => 
        \BLKY1[1]\, B_BLK(0) => B_ADDR(7), B_ADDR(9) => B_ADDR(6), 
        B_ADDR(8) => B_ADDR(5), B_ADDR(7) => B_ADDR(4), B_ADDR(6)
         => B_ADDR(3), B_ADDR(5) => B_ADDR(2), B_ADDR(4) => 
        B_ADDR(1), B_ADDR(3) => B_ADDR(0), B_ADDR(2) => \GND\, 
        B_ADDR(1) => \GND\, B_ADDR(0) => \GND\, C_CLK => CLK, 
        C_ADDR(9) => C_ADDR(6), C_ADDR(8) => C_ADDR(5), C_ADDR(7)
         => C_ADDR(4), C_ADDR(6) => C_ADDR(3), C_ADDR(5) => 
        C_ADDR(2), C_ADDR(4) => C_ADDR(1), C_ADDR(3) => C_ADDR(0), 
        C_ADDR(2) => \GND\, C_ADDR(1) => \GND\, C_ADDR(0) => 
        \GND\, C_DIN(17) => \GND\, C_DIN(16) => \GND\, C_DIN(15)
         => \GND\, C_DIN(14) => \GND\, C_DIN(13) => \GND\, 
        C_DIN(12) => \GND\, C_DIN(11) => \GND\, C_DIN(10) => 
        \GND\, C_DIN(9) => \GND\, C_DIN(8) => \GND\, C_DIN(7) => 
        C_DIN(7), C_DIN(6) => C_DIN(6), C_DIN(5) => C_DIN(5), 
        C_DIN(4) => C_DIN(4), C_DIN(3) => C_DIN(3), C_DIN(2) => 
        C_DIN(2), C_DIN(1) => C_DIN(1), C_DIN(0) => C_DIN(0), 
        C_WEN => \VCC\, C_BLK(1) => \BLKZ1[1]\, C_BLK(0) => 
        C_ADDR(7), A_EN => \VCC\, A_ADDR_LAT => \VCC\, A_DOUT_LAT
         => \GND\, A_WIDTH(2) => \GND\, A_WIDTH(1) => \VCC\, 
        A_WIDTH(0) => \VCC\, B_EN => \VCC\, B_ADDR_LAT => \VCC\, 
        B_DOUT_LAT => \GND\, B_WIDTH(2) => \GND\, B_WIDTH(1) => 
        \VCC\, B_WIDTH(0) => \VCC\, C_EN => \VCC\, C_WIDTH(2) => 
        \GND\, C_WIDTH(1) => \VCC\, C_WIDTH(0) => \VCC\, SII_LOCK
         => \GND\);
    
    \OR4_B_DOUT[7]\ : OR4
      port map(A => \QBX_TEMPR0[7]\, B => \QBX_TEMPR1[7]\, C => 
        \QBX_TEMPR2[7]\, D => \QBX_TEMPR3[7]\, Y => B_DOUT(7));
    
    \OR4_A_DOUT[7]\ : OR4
      port map(A => \QAX_TEMPR0[7]\, B => \QAX_TEMPR1[7]\, C => 
        \QAX_TEMPR2[7]\, D => \QAX_TEMPR3[7]\, Y => A_DOUT(7));
    
    \CFG2_BLKZ1[0]\ : CFG2
      generic map(INIT => x"4")

      port map(A => C_ADDR(8), B => C_BLK, Y => \BLKZ1[0]\);
    
    \INVBLKZ0[0]\ : INV
      port map(A => C_ADDR(7), Y => \BLKZ0[0]\);
    
    \OR4_B_DOUT[3]\ : OR4
      port map(A => \QBX_TEMPR0[3]\, B => \QBX_TEMPR1[3]\, C => 
        \QBX_TEMPR2[3]\, D => \QBX_TEMPR3[3]\, Y => B_DOUT(3));
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);

    VCC_power_inst1 : VCC
      port map( Y => VCC_power_net1);


end DEF_ARCH; 
