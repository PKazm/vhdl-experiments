--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Parallel architecture
--
--Rev:
--v4.0 3/6/2015
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

--                        +-+-+-+-+-+-+-+-+-+-+-+-+-+
--                        |M|i|c|r|o|-|R|o|t|a|t|o|r|
--                        +-+-+-+-+-+-+-+-+-+-+-+-+-+
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
USE work.cordic_rtl_pack.all;

ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_par_uRotator IS
  GENERIC ( IN_BITS     : INTEGER := 16;                                --5/15/2015
            DP_BITS     : INTEGER := 16;
            ITERATIONS  : INTEGER := 24;
            LOGITER     : INTEGER := 6;
            MODE        : INTEGER := 0;
            MODE_VECTOR : INTEGER := 0 );
  PORT (  rst         : IN STD_LOGIC;
          nGrst       : IN STD_LOGIC;
          clk         : IN STD_LOGIC;
          din_valid   : IN STD_LOGIC;
          x0          : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          y0          : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          a0          : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          datao_valid : OUT STD_LOGIC;
          xn          : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          yn          : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          an          : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          rcpr_gain_fx: OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );     --5/15/2015
END ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_par_uRotator;

ARCHITECTURE rtl OF CORECORDIC_C0_CORECORDIC_C0_0_cordic_par_uRotator IS
  COMPONENT cordic_par_calc IS
    GENERIC ( MODE_VECTOR : INTEGER;
              DP_BITS     : INTEGER;
              LOGITER     : INTEGER;
              ITER_NUM    : INTEGER  );
    PORT (  clk   : IN STD_LOGIC;
            nGrst : IN STD_LOGIC;
            rst   : IN STD_LOGIC;
            clkEn : IN STD_LOGIC;
            x0    : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            y0    : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            a0    : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            xn    : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            yn    : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            an    : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            aRom  : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_cROM_par IS
    GENERIC ( DP_BITS   : INTEGER;
              IN_BITS   : INTEGER;
              ITERATION : INTEGER  );
    PORT( arctan:       OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          rcprGain_fx : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );
  END COMPONENT;

  TYPE type_arom IS ARRAY (0 TO ITERATIONS-1) OF STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  TYPE type_rcpr IS ARRAY (0 TO ITERATIONS-1) OF STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);    --5/15/2015
  TYPE type_data IS ARRAY (0 TO ITERATIONS) OF STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);

  SIGNAL aRom                   : type_arom;
  SIGNAL xi                     : type_data;
  SIGNAL yi                     : type_data;
  SIGNAL ai                     : type_data;
  SIGNAL clkEn                  : STD_LOGIC := '1';
  SIGNAL rcprGain_fx            : type_rcpr;
BEGIN
--5/15/2015  xi(0) <= x0 WHEN MODE/=3 ELSE rcprGain_fx(0);
  xi(0) <= x0;
  yi(0) <= y0;
  ai(0) <= a0;
  xn <= xi(ITERATIONS);
  yn <= yi(ITERATIONS);
  an <= ai(ITERATIONS);
  
  rcpr_gain_fx <= rcprGain_fx(0);                               --5/15/2015

  cLayer : FOR stage IN 0 TO ITERATIONS-1 GENERATE
    par_calc_0 : cordic_par_calc
      GENERIC MAP ( MODE_VECTOR  => MODE_VECTOR,
                    DP_BITS      => DP_BITS,
                    LOGITER      => LOGITER,
                    ITER_NUM     => stage  )
      PORT MAP (  clk    => clk,
                  nGrst  => nGrst,
                  rst    => rst,
                  clkEn  => clkEn,
                  x0     => xi(stage),
                  y0     => yi(stage),
                  a0     => ai(stage),
                  xn     => xi(stage+1),
                  yn     => yi(stage+1),
                  an     => ai(stage+1),
                  aRom   => aRom(stage)  );

    cordicRam_0 : CORECORDIC_C0_CORECORDIC_C0_0_cROM_par
      GENERIC MAP ( ITERATION => stage,
                    IN_BITS   => IN_BITS,                       --5/15/2015
                    DP_BITS   => DP_BITS  )
      PORT MAP (  arctan      => aRom(stage),
                  rcprGain_fx => rcprGain_fx(stage) );
  END GENERATE;

  dly_0 : cordic_kitDelay_bit_reg
    GENERIC MAP ( DELAY  => ITERATIONS )
    PORT MAP (  nGrst  => nGrst,
                rst    => rst,
                clk    => clk,
                clkEn  => '1',
                inp    => din_valid,
                outp   => datao_valid );

END ARCHITECTURE rtl;



LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
USE work.cordic_rtl_pack.all;

ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_par IS
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
    FPGA_FAMILY      : INTEGER := 19;
    DIE_SIZE         : INTEGER := 20  );
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
          rcpr_gain_fx: OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );     --5/15/2015
END ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_par;

ARCHITECTURE rtl OF CORECORDIC_C0_CORECORDIC_C0_0_cordic_par IS
  COMPONENT cordic_coarse_pre_rotator
    GENERIC ( IN_BITS     : INTEGER := 16;
              MODE_VECTOR : INTEGER := 0;
              COARSE      : INTEGER := 0  );
    PORT (  rst, nGrst       : IN STD_LOGIC;
            clk              : IN STD_LOGIC;
            datai_valid      : IN STD_LOGIC;
            din_x            : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            din_y            : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            din_a            : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            x2u              : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            y2u              : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            a2u              : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
            coarse_flag      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            datai_valido     : OUT STD_LOGIC  );
  END COMPONENT;

  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_cordic_par_uRotator
    GENERIC ( DP_BITS     : INTEGER := 16;
              IN_BITS     : INTEGER;
              ITERATIONS  : INTEGER := 24;
              LOGITER     : INTEGER := 6;
              MODE_VECTOR : INTEGER := 0;
              MODE        : INTEGER := 0 );
    PORT (  rst         : IN STD_LOGIC;
            nGrst       : IN STD_LOGIC;
            clk         : IN STD_LOGIC;
            din_valid   : IN STD_LOGIC;
            x0          : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            y0          : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            a0          : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            datao_valid : OUT STD_LOGIC;
            xn          : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            yn          : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            an          : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            rcpr_gain_fx: OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );     --5/15/2015
  END COMPONENT;

  COMPONENT cordic_coarse_post_rotator IS
    GENERIC ( BITS        : INTEGER := 16;
              MODE_VECTOR : INTEGER := 0;
              COARSE      : INTEGER := 0 );
    PORT (  rst, nGrst  : IN STD_LOGIC;
            clk         : IN STD_LOGIC;
            datai_valid : IN STD_LOGIC;
            coarse_flag : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            xu          : IN STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
            yu          : IN STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
            au          : IN STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
            out_x       : OUT STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
            out_y       : OUT STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
            out_a       : OUT STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
            datao_valid : OUT STD_LOGIC  );
  END COMPONENT;

  constant LOGITER    : INTEGER := ceil_log2(ITERATIONS);

  SIGNAL x2u                    : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);		-- inputs to uRotator
  SIGNAL y2u                    : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL a2u                    : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL coarse_flag            : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL coarse_flag2post       : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL rnd_done               : STD_LOGIC;
  SIGNAL coarse_pre_datao_valid : STD_LOGIC;
  SIGNAL iter_count             : STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
  SIGNAL romAngle               : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL x0                     : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL y0                     : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL a0                     : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL xn_u                   : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL yn_u                   : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL an_u                   : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL post_coarse_x          : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL post_coarse_y          : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL post_coarse_a          : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL ld_data2calc           : STD_LOGIC;
  SIGNAL xn_rnd                 : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL yn_rnd                 : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL an_rnd                 : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL micro_done             : STD_LOGIC;

BEGIN
  pre_rotat_0 : cordic_coarse_pre_rotator
    GENERIC MAP ( IN_BITS      => IN_BITS,
                  MODE_VECTOR  => MODE_VECTOR,
                  COARSE       => COARSE  )
    PORT MAP (  nGrst         => nGrst,
                rst           => rst,
                clk           => clk,
                datai_valid   => din_valid,
                din_x         => din_x,
                din_y         => din_y,
                din_a         => din_a,
                x2u           => x2u,
                y2u           => y2u,
                a2u           => a2u,
                coarse_flag   => coarse_flag,
                datai_valido  => coarse_pre_datao_valid  );

  -- Store coarse_flag until it is used by coarse postRotator
  hold_coarse_flag_0 : cordic_kitDelay_reg
    GENERIC MAP ( BITWIDTH  => 2,
                  DELAY     => ITERATIONS+2 )
    PORT MAP (  nGrst  => nGrst,
                rst    => rst,
                clk    => clk,
                clkEn  => '1',
                inp    => coarse_flag,
                outp   => coarse_flag2post );

  -- CORDIC arithmetic has datapath width of dpBits.
  -- Input fx-pt data are to be scaled up or down to the datapath width.  
  -- IMPORTANT: the datapath must have an extra bit to accomodate large output
  -- vectors (e.g. 1.67*sqrt(1^2+1^2)=1.647*1.41) due to CORDIC gain!!!
  trans_inp2dp_0 : cordic_dp_bits_trans
    GENERIC MAP (IN_BITS  => IN_BITS,
                 DP_BITS  => DP_BITS)
    PORT MAP (  xin   => x2u, 
                yin   => y2u, 
                ain   => a2u,
                xout  => x0, 
                yout  => y0, 
                aout  => a0 );

  uRotator_par_0 : CORECORDIC_C0_CORECORDIC_C0_0_cordic_par_uRotator
    GENERIC MAP ( DP_BITS      => DP_BITS,
                  IN_BITS      => IN_BITS,                      --5/15/2015
                  ITERATIONS   => ITERATIONS,
                  LOGITER      => LOGITER,
                  MODE_VECTOR  => MODE_VECTOR,
                  MODE         => MODE  )
    PORT MAP (  nGrst        => nGrst,
                rst          => rst,
                clk          => clk,
                din_valid    => coarse_pre_datao_valid,
                x0           => x0,
                y0           => y0,
                a0           => a0,
                datao_valid  => micro_done,
                xn           => xn_u,
                yn           => yn_u,
                an           => an_u,
                rcpr_gain_fx => rcpr_gain_fx  );                --5/15/2015

  -- Round micro-rotator outputs
  -- Two cases are possible:
  -- 1. OUT_BITS <= DP_BITS perhaps is more likely.  Then it makes sense to
  --    cut extra bits before going to coarse_post_rotator, which has an adder
  -- 2. OUT_BITS > DP_BITS.  Then it makes sense to use coarse_post_rotator and
  --    then just sign extend the output. This case's blocked by GUI

  -- Round to EFFECT_OUT_BITS that is round to OUT_BITS if it is smaller than
  -- uRotator DP_BITS; otherwise just pass it through
  roundx_0 : cordic_kitRoundTop
    GENERIC MAP ( INWIDTH    => DP_BITS,
                  OUTWIDTH   => EFFECT_OUT_BITS,
                  ROUND      => ROUND,
                  VALID_BIT  => 1  )
    PORT MAP (  nGrst   => nGrst,
                rst     => '0',
                clk     => clk,
                inp     => xn_u,
                outp    => xn_rnd,
                validi  => micro_done,
                valido  => rnd_done  );

  roundy_0 : cordic_kitRoundTop
    GENERIC MAP ( INWIDTH    => DP_BITS,
                  OUTWIDTH   => EFFECT_OUT_BITS,
                  ROUND      => ROUND,
                  VALID_BIT  => 0  )
    PORT MAP (  nGrst   => nGrst,
                rst     => '0',
                clk     => clk,
                inp     => yn_u,
                outp    => yn_rnd,
                validi  => '1',
                valido  => open  );

  rounda_0 : cordic_kitRoundTop
    GENERIC MAP ( INWIDTH    => DP_BITS,
                  OUTWIDTH   => EFFECT_OUT_BITS,
                  ROUND      => ROUND,
                  VALID_BIT  => 0  )
    PORT MAP (  nGrst   => nGrst,
                rst     => '0',
                clk     => clk,
                inp     => an_u,
                outp    => an_rnd,
                validi  => '1',
                valido  => open  );

  post_rotat_0 : cordic_coarse_post_rotator
    GENERIC MAP ( BITS         => EFFECT_OUT_BITS,
                  MODE_VECTOR  => MODE_VECTOR,
                  COARSE       => COARSE )
     PORT MAP ( rst          => rst,
                nGrst        => nGrst,
                clk          => clk,
                datai_valid  => rnd_done,
                coarse_flag  => coarse_flag2post,
                xu           => xn_rnd,
                yu           => yn_rnd,
                au           => an_rnd,
                out_x        => post_coarse_x,
                out_y        => post_coarse_y,
                out_a        => post_coarse_a,
                datao_valid  => dout_valid );

  let_coarse_out : IF (OUT_BITS <= DP_BITS) GENERATE
     out_x <= post_coarse_x;
     out_y <= post_coarse_y;
     out_a <= post_coarse_a;
  END GENERATE;

  coarse_then_signExt : IF (OUT_BITS > DP_BITS) GENERATE
    signExt_0 : cordic_signExt
      GENERIC MAP ( INWIDTH   => DP_BITS,
                    OUTWIDTH  => OUT_BITS,
                    UNSIGN    => 0,
                    DROP_MSB  => 0  )
      PORT MAP (  inp   => post_coarse_x,
                  outp  => out_x );

    signExt_1 : cordic_signExt
      GENERIC MAP ( INWIDTH   => DP_BITS,
                    OUTWIDTH  => OUT_BITS,
                    UNSIGN    => 0,
                    DROP_MSB  => 0  )
      PORT MAP (  inp   => post_coarse_y,
                  outp  => out_y );


    signExt_2 : cordic_signExt
      GENERIC MAP ( INWIDTH   => DP_BITS,
                    OUTWIDTH  => OUT_BITS,
                    UNSIGN    => 0,
                    DROP_MSB  => 0  )
      PORT MAP (  inp   => post_coarse_a,
                  outp  => out_a );
  END GENERATE;
END ARCHITECTURE rtl;

