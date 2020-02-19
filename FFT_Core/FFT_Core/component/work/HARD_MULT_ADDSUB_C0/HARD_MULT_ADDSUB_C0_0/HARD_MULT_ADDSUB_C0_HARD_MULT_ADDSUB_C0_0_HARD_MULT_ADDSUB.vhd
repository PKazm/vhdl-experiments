-- Version: v12.1 12.600.0.14

library ieee;
use ieee.std_logic_1164.all;
library smartfusion2;
use smartfusion2.all;

entity HARD_MULT_ADDSUB_C0_HARD_MULT_ADDSUB_C0_0_HARD_MULT_ADDSUB is

    port( A0    : in    std_logic_vector(8 downto 0);
          B0    : in    std_logic_vector(8 downto 0);
          A1    : in    std_logic_vector(8 downto 0);
          B1    : in    std_logic_vector(8 downto 0);
          C     : in    std_logic_vector(34 downto 0);
          P     : out   std_logic_vector(34 downto 0);
          CDOUT : out   std_logic_vector(43 downto 0)
        );

end HARD_MULT_ADDSUB_C0_HARD_MULT_ADDSUB_C0_0_HARD_MULT_ADDSUB;

architecture DEF_ARCH of 
        HARD_MULT_ADDSUB_C0_HARD_MULT_ADDSUB_C0_0_HARD_MULT_ADDSUB is 

  component MACC
    port( CLK               : in    std_logic_vector(1 downto 0) := (others => 'U');
          A                 : in    std_logic_vector(17 downto 0) := (others => 'U');
          A_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          B                 : in    std_logic_vector(17 downto 0) := (others => 'U');
          B_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          C                 : in    std_logic_vector(43 downto 0) := (others => 'U');
          C_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          C_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          C_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          FDBKSEL           : in    std_logic := 'U';
          FDBKSEL_EN        : in    std_logic := 'U';
          FDBKSEL_AL_N      : in    std_logic := 'U';
          FDBKSEL_SL_N      : in    std_logic := 'U';
          CDSEL             : in    std_logic := 'U';
          CDSEL_EN          : in    std_logic := 'U';
          CDSEL_AL_N        : in    std_logic := 'U';
          CDSEL_SL_N        : in    std_logic := 'U';
          ARSHFT17          : in    std_logic := 'U';
          ARSHFT17_EN       : in    std_logic := 'U';
          ARSHFT17_AL_N     : in    std_logic := 'U';
          ARSHFT17_SL_N     : in    std_logic := 'U';
          SUB               : in    std_logic := 'U';
          SUB_EN            : in    std_logic := 'U';
          SUB_AL_N          : in    std_logic := 'U';
          SUB_SL_N          : in    std_logic := 'U';
          CARRYIN           : in    std_logic := 'U';
          SIMD              : in    std_logic := 'U';
          DOTP              : in    std_logic := 'U';
          OVFL_CARRYOUT_SEL : in    std_logic := 'U';
          A_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          C_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          FDBKSEL_BYPASS    : in    std_logic := 'U';
          FDBKSEL_AD        : in    std_logic := 'U';
          FDBKSEL_SD_N      : in    std_logic := 'U';
          CDSEL_BYPASS      : in    std_logic := 'U';
          CDSEL_AD          : in    std_logic := 'U';
          CDSEL_SD_N        : in    std_logic := 'U';
          ARSHFT17_BYPASS   : in    std_logic := 'U';
          ARSHFT17_AD       : in    std_logic := 'U';
          ARSHFT17_SD_N     : in    std_logic := 'U';
          SUB_BYPASS        : in    std_logic := 'U';
          SUB_AD            : in    std_logic := 'U';
          SUB_SD_N          : in    std_logic := 'U';
          CDIN              : in    std_logic_vector(43 downto 0) := (others => 'U');
          CDOUT             : out   std_logic_vector(43 downto 0);
          P                 : out   std_logic_vector(43 downto 0);
          OVFL_CARRYOUT     : out   std_logic
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

    signal N_GND, N_VCC : std_logic;
    signal GND_power_net1 : std_logic;
    signal VCC_power_net1 : std_logic;
    signal nc8, nc7, nc6, nc2, nc9, nc5, nc4, nc3, nc1
         : std_logic;

begin 

    N_GND <= GND_power_net1;
    N_VCC <= VCC_power_net1;

    U0 : MACC
      port map(CLK(1) => N_GND, CLK(0) => N_GND, A(17) => A1(8), 
        A(16) => A1(7), A(15) => A1(6), A(14) => A1(5), A(13) => 
        A1(4), A(12) => A1(3), A(11) => A1(2), A(10) => A1(1), 
        A(9) => A1(0), A(8) => A0(8), A(7) => A0(7), A(6) => 
        A0(6), A(5) => A0(5), A(4) => A0(4), A(3) => A0(3), A(2)
         => A0(2), A(1) => A0(1), A(0) => A0(0), A_EN(1) => N_VCC, 
        A_EN(0) => N_VCC, A_ARST_N(1) => N_VCC, A_ARST_N(0) => 
        N_VCC, A_SRST_N(1) => N_VCC, A_SRST_N(0) => N_VCC, B(17)
         => B0(8), B(16) => B0(7), B(15) => B0(6), B(14) => B0(5), 
        B(13) => B0(4), B(12) => B0(3), B(11) => B0(2), B(10) => 
        B0(1), B(9) => B0(0), B(8) => B1(8), B(7) => B1(7), B(6)
         => B1(6), B(5) => B1(5), B(4) => B1(4), B(3) => B1(3), 
        B(2) => B1(2), B(1) => B1(1), B(0) => B1(0), B_EN(1) => 
        N_VCC, B_EN(0) => N_VCC, B_ARST_N(1) => N_VCC, 
        B_ARST_N(0) => N_VCC, B_SRST_N(1) => N_VCC, B_SRST_N(0)
         => N_VCC, C(43) => C(34), C(42) => C(33), C(41) => C(32), 
        C(40) => C(31), C(39) => C(30), C(38) => C(29), C(37) => 
        C(28), C(36) => C(27), C(35) => C(26), C(34) => C(25), 
        C(33) => C(24), C(32) => C(23), C(31) => C(22), C(30) => 
        C(21), C(29) => C(20), C(28) => C(19), C(27) => C(18), 
        C(26) => C(17), C(25) => C(16), C(24) => C(15), C(23) => 
        C(14), C(22) => C(13), C(21) => C(12), C(20) => C(11), 
        C(19) => C(10), C(18) => C(9), C(17) => C(8), C(16) => 
        C(7), C(15) => C(6), C(14) => C(5), C(13) => C(4), C(12)
         => C(3), C(11) => C(2), C(10) => C(1), C(9) => C(0), 
        C(8) => N_GND, C(7) => N_GND, C(6) => N_GND, C(5) => 
        N_GND, C(4) => N_GND, C(3) => N_GND, C(2) => N_GND, C(1)
         => N_GND, C(0) => N_GND, C_EN(1) => N_VCC, C_EN(0) => 
        N_VCC, C_ARST_N(1) => N_VCC, C_ARST_N(0) => N_VCC, 
        C_SRST_N(1) => N_VCC, C_SRST_N(0) => N_VCC, P_EN(1) => 
        N_VCC, P_EN(0) => N_VCC, P_ARST_N(1) => N_VCC, 
        P_ARST_N(0) => N_VCC, P_SRST_N(1) => N_VCC, P_SRST_N(0)
         => N_VCC, FDBKSEL => N_GND, FDBKSEL_EN => N_VCC, 
        FDBKSEL_AL_N => N_VCC, FDBKSEL_SL_N => N_VCC, CDSEL => 
        N_GND, CDSEL_EN => N_VCC, CDSEL_AL_N => N_VCC, CDSEL_SL_N
         => N_VCC, ARSHFT17 => N_GND, ARSHFT17_EN => N_VCC, 
        ARSHFT17_AL_N => N_VCC, ARSHFT17_SL_N => N_VCC, SUB => 
        N_GND, SUB_EN => N_VCC, SUB_AL_N => N_VCC, SUB_SL_N => 
        N_VCC, CARRYIN => N_GND, SIMD => N_GND, DOTP => N_VCC, 
        OVFL_CARRYOUT_SEL => N_GND, A_BYPASS(1) => N_VCC, 
        A_BYPASS(0) => N_VCC, B_BYPASS(1) => N_VCC, B_BYPASS(0)
         => N_VCC, C_BYPASS(1) => N_VCC, C_BYPASS(0) => N_VCC, 
        P_BYPASS(1) => N_VCC, P_BYPASS(0) => N_VCC, 
        FDBKSEL_BYPASS => N_VCC, FDBKSEL_AD => N_GND, 
        FDBKSEL_SD_N => N_VCC, CDSEL_BYPASS => N_VCC, CDSEL_AD
         => N_GND, CDSEL_SD_N => N_VCC, ARSHFT17_BYPASS => N_VCC, 
        ARSHFT17_AD => N_GND, ARSHFT17_SD_N => N_VCC, SUB_BYPASS
         => N_VCC, SUB_AD => N_GND, SUB_SD_N => N_VCC, CDIN(43)
         => N_GND, CDIN(42) => N_GND, CDIN(41) => N_GND, CDIN(40)
         => N_GND, CDIN(39) => N_GND, CDIN(38) => N_GND, CDIN(37)
         => N_GND, CDIN(36) => N_GND, CDIN(35) => N_GND, CDIN(34)
         => N_GND, CDIN(33) => N_GND, CDIN(32) => N_GND, CDIN(31)
         => N_GND, CDIN(30) => N_GND, CDIN(29) => N_GND, CDIN(28)
         => N_GND, CDIN(27) => N_GND, CDIN(26) => N_GND, CDIN(25)
         => N_GND, CDIN(24) => N_GND, CDIN(23) => N_GND, CDIN(22)
         => N_GND, CDIN(21) => N_GND, CDIN(20) => N_GND, CDIN(19)
         => N_GND, CDIN(18) => N_GND, CDIN(17) => N_GND, CDIN(16)
         => N_GND, CDIN(15) => N_GND, CDIN(14) => N_GND, CDIN(13)
         => N_GND, CDIN(12) => N_GND, CDIN(11) => N_GND, CDIN(10)
         => N_GND, CDIN(9) => N_GND, CDIN(8) => N_GND, CDIN(7)
         => N_GND, CDIN(6) => N_GND, CDIN(5) => N_GND, CDIN(4)
         => N_GND, CDIN(3) => N_GND, CDIN(2) => N_GND, CDIN(1)
         => N_GND, CDIN(0) => N_GND, CDOUT(43) => CDOUT(43), 
        CDOUT(42) => CDOUT(42), CDOUT(41) => CDOUT(41), CDOUT(40)
         => CDOUT(40), CDOUT(39) => CDOUT(39), CDOUT(38) => 
        CDOUT(38), CDOUT(37) => CDOUT(37), CDOUT(36) => CDOUT(36), 
        CDOUT(35) => CDOUT(35), CDOUT(34) => CDOUT(34), CDOUT(33)
         => CDOUT(33), CDOUT(32) => CDOUT(32), CDOUT(31) => 
        CDOUT(31), CDOUT(30) => CDOUT(30), CDOUT(29) => CDOUT(29), 
        CDOUT(28) => CDOUT(28), CDOUT(27) => CDOUT(27), CDOUT(26)
         => CDOUT(26), CDOUT(25) => CDOUT(25), CDOUT(24) => 
        CDOUT(24), CDOUT(23) => CDOUT(23), CDOUT(22) => CDOUT(22), 
        CDOUT(21) => CDOUT(21), CDOUT(20) => CDOUT(20), CDOUT(19)
         => CDOUT(19), CDOUT(18) => CDOUT(18), CDOUT(17) => 
        CDOUT(17), CDOUT(16) => CDOUT(16), CDOUT(15) => CDOUT(15), 
        CDOUT(14) => CDOUT(14), CDOUT(13) => CDOUT(13), CDOUT(12)
         => CDOUT(12), CDOUT(11) => CDOUT(11), CDOUT(10) => 
        CDOUT(10), CDOUT(9) => CDOUT(9), CDOUT(8) => CDOUT(8), 
        CDOUT(7) => CDOUT(7), CDOUT(6) => CDOUT(6), CDOUT(5) => 
        CDOUT(5), CDOUT(4) => CDOUT(4), CDOUT(3) => CDOUT(3), 
        CDOUT(2) => CDOUT(2), CDOUT(1) => CDOUT(1), CDOUT(0) => 
        CDOUT(0), P(43) => P(34), P(42) => P(33), P(41) => P(32), 
        P(40) => P(31), P(39) => P(30), P(38) => P(29), P(37) => 
        P(28), P(36) => P(27), P(35) => P(26), P(34) => P(25), 
        P(33) => P(24), P(32) => P(23), P(31) => P(22), P(30) => 
        P(21), P(29) => P(20), P(28) => P(19), P(27) => P(18), 
        P(26) => P(17), P(25) => P(16), P(24) => P(15), P(23) => 
        P(14), P(22) => P(13), P(21) => P(12), P(20) => P(11), 
        P(19) => P(10), P(18) => P(9), P(17) => P(8), P(16) => 
        P(7), P(15) => P(6), P(14) => P(5), P(13) => P(4), P(12)
         => P(3), P(11) => P(2), P(10) => P(1), P(9) => P(0), 
        P(8) => nc8, P(7) => nc7, P(6) => nc6, P(5) => nc2, P(4)
         => nc9, P(3) => nc5, P(2) => nc4, P(1) => nc3, P(0) => 
        nc1, OVFL_CARRYOUT => OPEN);
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);

    VCC_power_inst1 : VCC
      port map( Y => VCC_power_net1);


end DEF_ARCH; 
