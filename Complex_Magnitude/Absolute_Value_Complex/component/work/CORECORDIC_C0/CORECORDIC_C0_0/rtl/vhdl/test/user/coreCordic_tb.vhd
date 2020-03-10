--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Word-serial architecture.  Test bench
--
--Rev:
--v4.0 10/31/2014  Maintenance Update
--
--SVN Revision Information:
--SVN$Revision:$
--SVN$Date:$
--
--Resolved SARS
--
--Notes:
--
--****************************************************************

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  USE IEEE.NUMERIC_STD.all;
  USE std.textio.all;
library CORECORDIC_LIB;
USE work.bhv_pack.all;
USE CORECORDIC_LIB.coreparameters.all;

ENTITY testbench IS
END ENTITY testbench;

ARCHITECTURE bhv OF testbench IS
  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC IS
    GENERIC (
      ARCHITECT   : INTEGER := 0;
      MODE        : INTEGER := 0;
      DP_OPTION   : INTEGER := 0;
      DP_WIDTH    : INTEGER := 16;
      IN_BITS     : INTEGER := 16;
      OUT_BITS    : INTEGER := 16;
      ROUND       : INTEGER := 0;
      ITERATIONS  : INTEGER := 24;
      COARSE      : INTEGER := 0    );
    PORT (
      NGRST       : IN STD_LOGIC;
      RST         : IN STD_LOGIC;
      CLK         : IN STD_LOGIC;
      DIN_X       : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      DIN_Y       : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      DIN_A       : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      DIN_VALID   : IN STD_LOGIC;
      DOUT_X      : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      DOUT_Y      : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      DOUT_A      : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      DOUT_VALID  : OUT STD_LOGIC;
      RFD         : OUT STD_LOGIC   );
  END COMPONENT;

  constant HALFPI : real := 3.1415926535897/2.0;
  constant WORDSIZE_MAX : INTEGER := 48;
  constant WORDSIZE_MIN : INTEGER := 8;
  constant MODE_VECTOR  : INTEGER := to_integer_bhv((MODE=2)OR(MODE=4));
  constant MODE_ROTATION: INTEGER := to_integer_bhv((MODE=0)OR(MODE=1)OR(MODE=3));

  -- PAR_DIN_VALID_OPTION: 0-always valid, 1-every other clk,
  -- 2-two clks valid then two clks not; 4-four clks valid, then four not
  constant PAR_DIN_VALID_OPTION : INTEGER := 0;
  constant CHECKPTS : INTEGER := 16;

  constant LOGITER  : integer := ceil_log2_bhv(ITERATIONS);
  constant IN_SCALEFL : real := 2.0**(IN_BITS-2);
  constant OUT_SCALEFL: real := 2.0**(OUT_BITS-3);

  -- If 0, use TB-generated extrn_increm to increm testVectCount
  -- Otherwise increm the counter automatically by looping back the dout_valid
  constant AUTOCYCLE : INTEGER := 0;

  COMPONENT cordic_bhvInpVect
    PORT (
      count   : IN INTEGER;
      xin, yin, ain: OUT STD_LOGIC_VECTOR (IN_BITS-1 DOWNTO 0)  );
  END COMPONENT;

  COMPONENT cordic_bhvOutpVect
    PORT (
      count   : IN INTEGER;
      goldSample1, goldSample2: OUT STD_LOGIC_VECTOR (OUT_BITS-1 DOWNTO 0)  );
  END COMPONENT;

  SIGNAL clk           : STD_LOGIC;
  SIGNAL rst           : STD_LOGIC;
  SIGNAL nGrst         : STD_LOGIC;
  SIGNAL i             : INTEGER;
  SIGNAL a0            : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL x0            : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL y0            : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL disp_a0r   : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL disp_x0r   : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL disp_y0r   : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL disp_a0r2  : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');  --5/18/2015
  SIGNAL disp_x0r2  : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');  --5/18/2015
  SIGNAL disp_y0r2  : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');  --5/18/2015
  SIGNAL disp_x0w   : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL disp_y0w   : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL disp_a0w   : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL disp_x0, disp_y0, disp_a0  : INTEGER;
  SIGNAL yn            : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
  SIGNAL xn            : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
  SIGNAL an            : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
  SIGNAL valid_count   : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL load_argument : STD_LOGIC;
  SIGNAL dout_valid    : STD_LOGIC;
  SIGNAL inVectCount_v : STD_LOGIC_VECTOR(ceil_log2_bhv(CHECKPTS)-1 DOWNTO 0);
  SIGNAL inVectCount   : INTEGER;
  SIGNAL goldVectCount_v : STD_LOGIC_VECTOR(ceil_log2_bhv(CHECKPTS)-1 DOWNTO 0);
  SIGNAL goldVectCount_vi : STD_LOGIC_VECTOR(ceil_log2_bhv(CHECKPTS) DOWNTO 0);
  SIGNAL goldVectCount : INTEGER;
  SIGNAL extrn_increm  : STD_LOGIC;
  SIGNAL rst_tick      : STD_LOGIC;
  SIGNAL Fail          : STD_LOGIC;
  SIGNAL step          : STD_LOGIC := '0';
  SIGNAL cos_gold      : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL sin_gold      : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL magni_gold    : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL phase_gold    : STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0):=(others=>'0');
  SIGNAL end_test, rst_tstSmpl_increm : STD_LOGIC;
  SIGNAL halt, rfd     : STD_LOGIC := '0';

BEGIN
--                       +-+-+-+-+-+-+-+-+-+-+-+ +-+-+
--                       |W|o|r|d|-|s|e|r|i|a|l| |T|B|
--                       +-+-+-+-+-+-+-+-+-+-+-+ +-+-+

  word_serial_tb : IF (ARCHITECT = 1) GENERATE
    rst_tstSmpl_increm <= rst OR extrn_increm;
    -- External increm signal for the input test vector
    testSample_increm_0 : bhvCountS
      GENERIC MAP ( WIDTH     => 6,
                    DCVALUE   => ITERATIONS+3,
                    BUILD_DC  => 1 )
      PORT MAP (
        nGrst => nGrst, clk => clk, clkEn => '1', cntEn => '1',
        rst   => rst_tstSmpl_increm,
        Q      => open,
        dc     => extrn_increm  );

    -- Kick off the argument load by rst, then use extrn_increm or dout_valid to load further args
    load_argument <= extrn_increm WHEN (AUTOCYCLE = 0) ELSE rfd;

    -- Latch the input vectors on load_argument to display them later
    PROCESS (clk)
    BEGIN
      IF (clk'EVENT AND clk = '1') THEN
        IF (load_argument = '1') THEN
          disp_x0r <= x0;
          disp_y0r <= y0;
          disp_a0r <= a0;
          disp_x0r2 <= disp_x0r;                                    --5/18/2015
          disp_y0r2 <= disp_y0r;                                    --5/18/2015
          disp_a0r2 <= disp_a0r;                                    --5/18/2015
        END IF;
      END IF;
    END PROCESS;

    -- start 5/27/2015
    disp_x0w <= disp_x0r2 WHEN COARSE=1 ELSE disp_x0r;
    disp_y0w <= disp_y0r2 WHEN COARSE=1 ELSE disp_y0r;
    disp_a0w <= disp_a0r2 WHEN COARSE=1 ELSE disp_a0r;
--    disp_x0 <= to_integer(signed(disp_x0r2)) WHEN COARSE=1 ELSE to_integer(signed(disp_x0r)); --5/18/2015
--    disp_y0 <= to_integer(signed(disp_y0r2)) WHEN COARSE=1 ELSE to_integer(signed(disp_y0r)); --5/18/2015
--    disp_a0 <= to_integer(signed(disp_a0r2)) WHEN COARSE=1 ELSE to_integer(signed(disp_a0r)); --5/18/2015
    -- end 5/27/2015
  END GENERATE;


--                          +-+-+-+-+-+-+-+-+ +-+-+
--                          |P|a|r|a|l|l|e|l| |T|B|
--                          +-+-+-+-+-+-+-+-+ +-+-+

  par_tb : IF (ARCHITECT /= 1) GENERATE     --Parallel testbench
    counter_0 : bhvCountS
      GENERIC MAP ( WIDTH     => 3,
                    DCVALUE   => 1,
                    BUILD_DC  => 0  )
      PORT MAP (
        nGrst => nGrst, clk => clk, clkEn => '1', cntEn => '1',
        rst    => rst,
        Q      => valid_count,
        dc     => open  );

    -- A step after nGrst or rst
    edge_detect_0 : bhvEdge
      GENERIC MAP (REDGE  => 0)   -- falling edge
      PORT MAP (nGrst => nGrst, rst => '0', clk => clk,
            inp    => rst,
            outp   => rst_tick   );

    PROCESS (clk, nGrst)
    BEGIN
      IF (nGrst = '0') THEN
        step <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
        IF (rst = '1') THEN
          step <= '0';
        ELSIF (rst_tick = '1') THEN
          step <= '1';
        END IF;
      END IF;
    END PROCESS;

    load_argument <= step           WHEN (PAR_DIN_VALID_OPTION=0) ELSE
                     step AND valid_count(0) WHEN (PAR_DIN_VALID_OPTION=1) ELSE
                     step AND valid_count(1) WHEN (PAR_DIN_VALID_OPTION=0) ELSE
                     step AND valid_count(2) WHEN (PAR_DIN_VALID_OPTION=1) ELSE step;

    -- Keep the input vectors to display them later
    pipe_par_dly_0 : bhv_kitDelay_reg
      GENERIC MAP ( DELAY  => ITERATIONS+2+2*COARSE,
                    WIDTH  => IN_BITS  )
      PORT MAP (
        nGrst => nGrst, clk => clk, clken => '1', rst => rst,
        inp    => x0,
        outp   => disp_x0w  );

    pipe_par_dly_1 : bhv_kitDelay_reg
      GENERIC MAP ( DELAY  => ITERATIONS+2+2*COARSE,
                    WIDTH  => IN_BITS  )
      PORT MAP (
        nGrst => nGrst, clk => clk, clken => '1', rst => rst,
        inp    => y0,
        outp   => disp_y0w  );

    pipe_par_dly_2 : bhv_kitDelay_reg
      GENERIC MAP ( DELAY  => ITERATIONS+2+2*COARSE,
                    WIDTH  => IN_BITS  )
      PORT MAP (
        nGrst => nGrst, clk => clk, clken => '1', rst => rst,
        inp    => a0,
        outp   => disp_a0w  );

    -- start 5/27/2015
--    disp_x0 <= to_integer(signed(disp_x0w));
--    disp_y0 <= to_integer(signed(disp_y0w));
--    disp_a0 <= to_integer(signed(disp_a0w));
    -- end 5/27/2015
  END GENERATE;

--                            +-+-+-+-+-+-+ +-+-+
--                            |C|o|m|m|o|n| |T|B|
--                            +-+-+-+-+-+-+ +-+-+

  fit_integer : IF (IN_BITS<33) GENERATE  -- convert inp data t decimal
    disp_x0 <= to_integer(signed(disp_x0w));
    disp_y0 <= to_integer(signed(disp_y0w));
    disp_a0 <= to_integer(signed(disp_a0w));
  END GENERATE;

  -- Count new samples loaded
  inVectCount_0 : bhvCountS
    GENERIC MAP ( WIDTH     => ceil_log2_bhv(CHECKPTS),
                  DCVALUE   => 1,
                  BUILD_DC  => 0  )
    PORT MAP (
      nGrst => nGrst, clk => clk, clkEn => '1', rst => rst,
      cntEn  => load_argument,
      Q      => inVectCount_v,
      dc     => open  );

  inVectCount <= to_integer_bhv(inVectCount_v);
  inpVect : cordic_bhvInpVect
    PORT MAP (
      count => inVectCount,
      xin   => x0,
      yin   => y0,
      ain   => a0   );

  -- Count golden output samples & generate end_test
  goldVectCount_0 : bhvCountS
    GENERIC MAP ( WIDTH     => ceil_log2_bhv(CHECKPTS)+1,
                  DCVALUE   => CHECKPTS,
                  BUILD_DC  => 1  )
    PORT MAP (
      nGrst => nGrst, clk => clk, clkEn => '1', rst => rst,
      cntEn  => dout_valid,
      Q      => goldVectCount_vi,
      dc     => end_test );
  goldVectCount_v <= goldVectCount_vi(ceil_log2_bhv(CHECKPTS)-1 DOWNTO 0);

  goldVectCount <= to_integer_bhv(goldVectCount_v);
  rotation_gold_vect : IF (MODE_ROTATION = 1) GENERATE
    goldVect_0 : cordic_bhvOutpVect
      PORT MAP (
        count        => goldVectCount,
        goldSample1  => sin_gold,
        goldSample2  => cos_gold  );
  END GENERATE;

  vectoring_gold_vect : IF (MODE_VECTOR = 1) GENERATE
    goldVect_0 : cordic_bhvOutpVect
      PORT MAP (
        count        => goldVectCount,
        goldSample1  => magni_gold,
        goldSample2  => phase_gold  );
  END GENERATE;

  CORECORDIC_0 : CORECORDIC_C0_CORECORDIC_C0_0_CORECORDIC
    GENERIC MAP ( ARCHITECT   => ARCHITECT,
                  MODE        => MODE,
                  DP_OPTION   => DP_OPTION,
                  DP_WIDTH    => DP_WIDTH,
                  IN_BITS     => IN_BITS,
                  OUT_BITS    => OUT_BITS,
                  ITERATIONS  => ITERATIONS,
                  ROUND       => ROUND,
                  COARSE      => COARSE  )
    PORT MAP (
      CLK         => clk,
      RST         => rst,
      NGRST       => nGrst,
      DIN_VALID   => load_argument,
      RFD         => rfd,
      DOUT_VALID  => dout_valid,
      DIN_X       => x0,
      DIN_Y       => y0,
      DIN_A       => a0,
      DOUT_X      => xn,
      DOUT_Y      => yn,
      DOUT_A      => an );


  --                  +-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+
  --                  |C|h|e|c|k| |t|h|e| |R|e|s|u|l|t|s|
  --                  +-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+

  PROCESS (clk, nGrst)
    VARIABLE temp_x, temp_y, temp_a : real;
  BEGIN
    IF (nGrst = '0') THEN
      Fail <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') THEN
        Fail <= '0';
      ELSE
        IF dout_valid='1' THEN
          IF MODE_ROTATION=1 THEN
            print("");
            IF (IN_BITS<33) THEN
              --$display("Input x, y and rotation angle(rad). Fx-pt: %d, %d and %d; Fl-pt %.3f, %.3f and %.3f", $signed(disp_x0), $signed(disp_y0), $signed(disp_a0),
              --   $signed(disp_x0)/IN_SCALEFL, $signed(disp_y0)/IN_SCALEFL, HALFPI*$signed(disp_a0)/IN_SCALEFL);
              temp_x := Real(disp_x0)/IN_SCALEFL;
              temp_y := Real(disp_y0)/IN_SCALEFL;
              temp_a := HALFPI*Real(disp_a0)/IN_SCALEFL;
              report "Input x, y and rotation angle(rad). Fx-pt: "
                  & integer'image(disp_x0) & ", " & integer'image(disp_y0)
                  & " and " & integer'image(disp_a0) & "; Fl-pt: "
                  & real'image(temp_x) & ", " & real'image(temp_y) & " and "
                  & real'image(temp_a);
            END IF;
            
            IF(OUT_BITS<33) THEN
              --$display("Expected x and y results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(sin_gold), $signed(cos_gold),
              --   $signed(sin_gold)/OUT_SCALEFL, $signed(cos_gold)/OUT_SCALEFL);
              temp_x := Real(to_integer(signed(sin_gold)))/OUT_SCALEFL;
              temp_y := Real(to_integer(signed(cos_gold)))/OUT_SCALEFL;
              report "Expected x and y results. Fx-pt: "
                  & integer'image(to_integer(signed(sin_gold))) & ", "
                  & integer'image(to_integer(signed(cos_gold))) & "; Fl-pt: "
                  & real'image(temp_x) & ", " & real'image(temp_y);
            END IF;
            
            IF ((xn = sin_gold) AND (yn = cos_gold)) THEN
              print("Passed");
            ELSE
              Fail <= '1';
              IF(OUT_BITS<33) THEN
                --$display("Error! Actual x and y results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(xn), $signed(yn),
                --  $signed(xn)/OUT_SCALEFL, $signed(yn)/OUT_SCALEFL);
                report "Error! Actual x and y results. Fx-pt: "
                    & integer'image(to_integer(signed(xn))) & " and "
                    & integer'image(to_integer(signed(yn))) & "; Fl-pt: "
                    & real'image(Real(to_integer(signed(xn)))) & " and "
                    & real'image(Real(to_integer(signed(yn))));
              END IF;      
              print("Failed");
            END IF;
            print("");

          ELSE      -- VECTORING
            print("");
            IF(IN_BITS<33) THEN
              --$display("Input x and y. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(disp_x0), $signed(disp_y0),
              --  $signed(disp_x0)/IN_SCALEFL, $signed(disp_y0)/IN_SCALEFL);
              temp_x := Real(disp_x0)/IN_SCALEFL;
              temp_y := Real(disp_y0)/IN_SCALEFL;
              report "Inputs x and y. Fx-pt: " & integer'image(disp_x0) & " and "
                  & integer'image(disp_y0) & "; Fl-pt: " & real'image(temp_x)
                  & " and " & real'image(temp_y);
            END IF;

            IF(OUT_BITS<33) THEN
              --$display("Expected x and y results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(magni_gold), $signed(phase_gold),
              --   $signed(magni_gold)/OUT_SCALEFL, HALFPI*$signed(phase_gold)/OUT_SCALEFL);
              temp_x := Real(to_integer(signed(magni_gold)))/OUT_SCALEFL;
              temp_a := HALFPI*Real(to_integer(signed(phase_gold)))/OUT_SCALEFL;
              report "Expected Magnitude and Phase. Fx-pt: "
                  & integer'image(to_integer(signed(magni_gold))) & ", "
                  & integer'image(to_integer(signed(phase_gold))) & "; Fl-pt: "
                  & real'image(temp_x) & ", " & real'image(temp_y);
            END IF;
            
            IF ((xn = magni_gold) AND (an = phase_gold)) THEN
              print("Passed");
            ELSE
              Fail <= '1';

              IF(OUT_BITS<33) THEN
                temp_x := Real(to_integer(signed(xn)))/OUT_SCALEFL;
                temp_a := HALFPI*Real(to_integer(signed(an)))/OUT_SCALEFL;
      		      --$display("Error! Actual Magnitude and Phase results. Fx-pt: %d and %d; Fl-pt %.3f and %.3f", $signed(xn), $signed(an),
                --  $signed(xn)/OUT_SCALEFL, (PI/2)*$signed(an)/OUT_SCALEFL);
                report "Error! Actual Magnitude and Phase results. Fx-pt: "
                    & integer'image(to_integer(signed(xn))) & " and "
                    & integer'image(to_integer(signed(an))) & "; Fl-pt: "
                    & real'image(temp_x) & " and " & real'image(temp_a);
              END IF;
              
              print("Failed");
            END IF;
            print("");
          END IF;     -- ROTATION/VECTOR MODES
        END IF;       -- dout_valid

        IF (end_test = '1') THEN
          IF(ARCHITECT=1) THEN
      	    IF (MODE_VECTOR=1) THEN
              IF (Fail='1') THEN
                print("**** Word-serial CORDIC Sqrt/Atan TEST FAILED *****");
              ELSE
                print("---- Word-serial CORDIC Sqrt/Atan test passed -----");
              END IF;
            ELSE
              IF (Fail = '1') THEN
                print("**** Word-serial CORDIC Rotation TEST FAILED *****");
              ELSE
                print("---- Word-serial CORDIC Rotation test passed -----");
              END IF;
            END IF;
          END IF;       --ARCH=1

          IF(ARCHITECT=2) THEN
      	    IF (MODE_VECTOR=1) THEN
              IF (Fail = '1') THEN
                print("**** Parallel CORDIC Sqrt/Atan TEST FAILED *****");
              ELSE
                print("---- Parallel CORDIC Sqrt/Atan test passed -----");
              END IF;
            ELSE
              IF (Fail = '1') THEN
                print("**** Parallel CORDIC Rotation TEST FAILED *****");
              ELSE
                print("---- Parallel CORDIC Rotation test passed -----");
              END IF;
            END IF;
          END IF;       --ARCH=2

          halt <= '1';
        END IF;         -- end_test
      END IF;           -- NOT rst
    END IF;             -- posedge clk
  END PROCESS;

--  clk_gen_0 : bhvClockGen
--    GENERIC MAP ( CLKPERIOD   => 10 ns,
--                  NGRSTLASTS  => 17 ns  )
--    PORT MAP (  halt   => halt,
--                clk    => clk,
--                rst    => rst,
--                nGrst  => nGrst  );

  clk_gen_0 : bhvClkGen
    GENERIC MAP ( CLKPERIOD   => 10 ns,
                  NGRSTLASTS  => 17 ns,
                  RST_DLY     => 10 )
    PORT MAP (  halt   => halt,
                clk    => clk,
                rst    => rst,
                nGrst  => nGrst  );

END ARCHITECTURE bhv;
