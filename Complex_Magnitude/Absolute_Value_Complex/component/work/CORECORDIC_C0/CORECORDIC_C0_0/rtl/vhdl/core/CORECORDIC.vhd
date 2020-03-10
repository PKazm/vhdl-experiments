--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Word-serial architecture
--
--Rev:
--v4.0 9/3/2014
--
--SVN Revision Information:
--SVN$Revision:$
--SVN$Date:$
--
--Resolved SARS
--
--Notes:
--

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
USE work.cordic_rtl_pack.all;

--****************************************************************
--  ----------------------  Conventions  -------------------------
--    Mode      |     Inputs         |           Outputs
--  ----------  |--------------------|-------------------------------
--  Rotation    | DIN_X: Magnitude R | DOUT_X = K*R*cosA
--    "0"       | DIN_Y:   -         | DOUT_Y = K*R*sinA
--              | DIN_A: Phase A     | DOUT_A   -
--              |                    |
--  Vectoring   | DIN_X: X           | DOUT_X = K*sqrt(X^2+Y^2) "magnitude R"
--(Translation) | DIN_Y: Y           | DOUT_Y     -
--    "1"       | DIN_A: -           | DOUT_A = arctan(Y/X) "Phase A"
--
--  K - CORDIC gain

ENTITY CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC IS
  GENERIC (
    ARCHITECT      : INTEGER := 0;		-- 0-word-serial; 1-parallel
    MODE           : INTEGER := 0;
    DP_OPTION      : INTEGER := 0;		-- DP width: 0-auto; 1-manual; 2-full
    DP_WIDTH       : INTEGER := 16;		-- DP width if DP_OPTION==manual
    IN_BITS        : INTEGER := 16;
    OUT_BITS       : INTEGER := 16;
    ROUND          : INTEGER := 0;		-- 0-truncate; 1-converg; 2-symm; 3-up
    ITERATIONS     : INTEGER := 24;
    COARSE         : INTEGER := 0  );		-- 0-don't; 1-povide coarse rotator
  PORT (
    NGRST          : IN STD_LOGIC;
    RST            : IN STD_LOGIC;
    CLK            : IN STD_LOGIC;
    DIN_X          : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
    DIN_Y          : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
    DIN_A          : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
    DIN_VALID      : IN STD_LOGIC;
    DOUT_X         : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
    DOUT_Y         : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
    DOUT_A         : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
    DOUT_VALID     : OUT STD_LOGIC;
    RFD            : OUT STD_LOGIC  );
END ENTITY CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC;

ARCHITECTURE rtl OF CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC IS
  COMPONENT cordic_init_kickstart
    PORT (  nGrst          : IN STD_LOGIC;
            clk            : IN STD_LOGIC;
            rst            : IN STD_LOGIC;
            rsto           : OUT STD_LOGIC  );
  END COMPONENT;

  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_cordic_word
    GENERIC (
      IN_BITS         : INTEGER := 16;
      OUT_BITS        : INTEGER := 16;
      ITERATIONS      : INTEGER := 24;
      MODE_VECTOR     : INTEGER := 0;
      MODE            : INTEGER := 0;
      DP_OPTION       : INTEGER := 0;
      DP_BITS         : INTEGER := 8;
      EFFECT_OUT_BITS : INTEGER := 8;
      ROUND           : INTEGER := 0;
      COARSE          : INTEGER := 0;
      -- Not used
      IN_REG          : INTEGER := 0;
      OUT_REG         : INTEGER := 0;
      FPGA_FAMILY     : INTEGER := 19;
      DIE_SIZE        : INTEGER := 20  );
    PORT (
      nGrst           : IN STD_LOGIC;
      rst             : IN STD_LOGIC;
      clk             : IN STD_LOGIC;
      din_valid       : IN STD_LOGIC;
      din_x           : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      din_y           : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      din_a           : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      rfd             : OUT STD_LOGIC;
      dout_valid      : OUT STD_LOGIC;
      out_x           : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      out_y           : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      out_a           : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      rcpr_gain_fx    : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );    --5/15/2015
  END COMPONENT;

  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_cordic_par
    GENERIC (
      IN_BITS       : INTEGER := 16;
      OUT_BITS      : INTEGER := 16;
      ITERATIONS    : INTEGER := 24;
      MODE_VECTOR   : INTEGER := 0;
      MODE          : INTEGER := 0;
      DP_OPTION     : INTEGER := 0;
      DP_BITS         : INTEGER := 8;
      EFFECT_OUT_BITS : INTEGER := 8;
      ROUND         : INTEGER := 0;
      COARSE        : INTEGER := 0;
      -- Not used
      IN_REG        : INTEGER := 0;
      OUT_REG       : INTEGER := 0;
      FPGA_FAMILY   : INTEGER := 19;
      DIE_SIZE      : INTEGER := 20  );
    PORT (  nGrst       : IN STD_LOGIC;
            rst         : IN STD_LOGIC;
            clk         : IN STD_LOGIC;
            din_valid   : IN STD_LOGIC;
            din_x       : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            din_y       : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            din_a       : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            dout_valid  : OUT STD_LOGIC;
            out_x       : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
            out_y       : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
            out_a       : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
            rcpr_gain_fx: OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );    --5/15/2015
  END COMPONENT;

  constant WORDSIZE_MAX   : INTEGER := 48;
  constant WORDSIZE_MIN   : INTEGER := 8;
  constant MODE_VECTOR    : INTEGER := to_integer((MODE=2) OR (MODE=4));

  constant LOGITER    : INTEGER := ceil_log2(ITERATIONS);
  constant LOGITER_M  : INTEGER := ceil_log2(ITERATIONS + 1);

  -- Set CORDIC datapath bitwidths
  constant BITS00 : INTEGER := IN_BITS + 2;
  constant BITS02 : INTEGER := IN_BITS + ITERATIONS + LOGITER;
  constant BITS0  : INTEGER := intMux3 (BITS00, DP_WIDTH, BITS02, DP_OPTION);

  constant BITS1      : INTEGER := intMux( BITS0, WORDSIZE_MIN, BITS0 < WORDSIZE_MIN);
  -- Cordic datapath bit width
  constant DP_BITS    : INTEGER := intMux( BITS1, WORDSIZE_MAX, BITS1 >= WORDSIZE_MAX);
  -- Round to the smaller of uRotator DP_BITS and OUT_BITS
  constant EFFECT_OUT_BITS  : INTEGER := intMux( DP_BITS, OUT_BITS, (OUT_BITS < DP_BITS) );
  -- End setting CORDIC datapath bitwidths

  -- Dummy params
  constant IN_REG         : INTEGER := 0;
  constant OUT_REG        : INTEGER := 0;
  constant USE_RAM        : INTEGER := 0;
  constant URAM_MAXDEPTH  : INTEGER := 0;
  constant FPGA_FAMILY    : INTEGER := 19;
  constant DIE_SIZE       : INTEGER := 20;

  SIGNAL din_xi, din_yi, din_ai : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL rcpr_gain_fx           : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);   --5/15/2015
  SIGNAL rsti             : STD_LOGIC;
BEGIN
  -- generate kickstart on nGrst or pass sync rst thru
  kickstart_0 : cordic_init_kickstart
    PORT MAP (  nGrst  => NGRST,
                clk    => CLK,
                rst    => RST,
                rsto   => rsti  );

  -- Enforce necessary constants at the input
  mode0_inputs: IF (MODE=0) GENERATE    --  General rotation
    din_xi <= DIN_X;
    din_yi <= DIN_Y;
    din_ai <= DIN_A;
  END GENERATE;

  mode1_inputs: IF (MODE=1) GENERATE    --  Polar to Rectangular
    din_xi <= DIN_X;
    din_yi <= (others=>'0');
    din_ai <= DIN_A;
  END GENERATE;

  mode2_inputs: IF (MODE=2) GENERATE    --  Rectangular to Polar
    din_xi <= DIN_X;
    din_yi <= DIN_Y;
    din_ai <= (others=>'0');
  END GENERATE;

  mode3_inputs: IF (MODE=3) GENERATE    --  Sin/Cos
--5/15/2015    -- Provide a dummy din_xi signal here.  Inside a uRotator it gets
--5/15/2015    -- replaced with rcprGain
--5/15/2015    din_xi <= DIN_X;          -- it's replaced with rcprGain at uRotator
    din_xi <= rcpr_gain_fx;
    din_yi <= (others=>'0');
    din_ai <= DIN_A;
  END GENERATE;

  mode4_inputs: IF (MODE=4) GENERATE    --  Arctan
    din_xi <= DIN_X;
    din_yi <= DIN_Y;
    din_ai <= (others=>'0');
  END GENERATE;

  word_serial : IF (ARCHITECT <= 1) GENERATE
    cordic_word_0 : CORECORDIC_C0_CORECORDIC_C0_0_cordic_word
      GENERIC MAP (
        IN_BITS       => IN_BITS,
        OUT_BITS      => OUT_BITS,
        ITERATIONS    => ITERATIONS,
        MODE_VECTOR   => MODE_VECTOR,
        MODE          => MODE,
        DP_OPTION     => DP_OPTION,
        DP_BITS         => DP_BITS,
        EFFECT_OUT_BITS => EFFECT_OUT_BITS,
        ROUND         => ROUND,
        IN_REG        => IN_REG,
        OUT_REG       => OUT_REG,
        COARSE        => COARSE,
        FPGA_FAMILY   => FPGA_FAMILY,
        DIE_SIZE      => DIE_SIZE  )
      PORT MAP (
        nGrst       => NGRST,
        rst         => rsti,
        clk         => CLK,
        din_valid   => DIN_VALID,
        rfd         => RFD,
        dout_valid  => DOUT_VALID,
        out_x       => DOUT_X,
        out_y       => DOUT_Y,
        out_a       => DOUT_A,
        din_x       => din_xi,
        din_y       => din_yi,
        din_a       => din_ai,
        rcpr_gain_fx=> rcpr_gain_fx );                          --5/15/2015
  END GENERATE;

  parallel : IF (ARCHITECT > 1) GENERATE
    cordic_paral_0 : CORECORDIC_C0_CORECORDIC_C0_0_cordic_par
      GENERIC MAP (
        IN_BITS         => IN_BITS,
        OUT_BITS        => OUT_BITS,
        ITERATIONS      => ITERATIONS,
        MODE_VECTOR     => MODE_VECTOR,
        MODE            => MODE,
        DP_OPTION       => DP_OPTION,
        DP_BITS         => DP_BITS,
        EFFECT_OUT_BITS => EFFECT_OUT_BITS,
        ROUND           => ROUND,
        COARSE          => COARSE,
        IN_REG          => IN_REG,
        OUT_REG         => OUT_REG,
        FPGA_FAMILY     => FPGA_FAMILY,
        DIE_SIZE        => DIE_SIZE  )
      PORT MAP (
        nGrst       => NGRST,
        rst         => rsti,
        clk         => CLK,
        din_valid   => DIN_VALID,
        dout_valid  => DOUT_VALID,
        out_x       => DOUT_X,
        out_y       => DOUT_Y,
        out_a       => DOUT_A,
        din_x       => din_xi,
        din_y       => din_yi,
        din_a       => din_ai,
        rcpr_gain_fx=> rcpr_gain_fx );                          --5/15/2015

    RFD <= '1';
  END GENERATE;
END ARCHITECTURE rtl;




