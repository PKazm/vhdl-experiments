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
--****************************************************************

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
USE work.cordic_rtl_pack.all;

ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_word IS
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
      nGrst            : IN STD_LOGIC;
      rst              : IN STD_LOGIC;
      clk              : IN STD_LOGIC;
      din_valid        : IN STD_LOGIC;
      din_x            : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      din_y            : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      din_a            : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      rfd              : OUT STD_LOGIC;
      dout_valid       : OUT STD_LOGIC;
      out_x            : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      out_y            : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      out_a            : OUT STD_LOGIC_VECTOR(OUT_BITS-1 DOWNTO 0);
      rcpr_gain_fx     : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)   );    --5/15/2015
END ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_word;

ARCHITECTURE rtl OF CORECORDIC_C0_CORECORDIC_C0_0_cordic_word IS
  COMPONENT cordic_coarse_pre_rotator
    GENERIC (  IN_BITS       : INTEGER;
               MODE_VECTOR   : INTEGER;
               COARSE        : INTEGER);
    PORT (
      rst, nGrst    : IN STD_LOGIC;
      clk           : IN STD_LOGIC;
      datai_valid   : IN STD_LOGIC;
      din_x         : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      din_y         : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      din_a         : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      x2u           : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      y2u           : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      a2u           : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
      coarse_flag   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      datai_valido  : OUT STD_LOGIC   );
  END COMPONENT;

  COMPONENT cordic_coarse_post_rotator IS
    GENERIC (BITS         : INTEGER;
             MODE_VECTOR  : INTEGER;
             COARSE       : INTEGER );
    PORT ( rst, nGrst   : IN STD_LOGIC;
           clk          : IN STD_LOGIC;
           datai_valid  : IN STD_LOGIC;
           coarse_flag  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
           xu           : IN STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
           yu           : IN STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
           au           : IN STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
           out_x        : OUT STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
           out_y        : OUT STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
           out_a        : OUT STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
           datao_valid  : OUT STD_LOGIC  );
  END COMPONENT;

  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator
    GENERIC ( IN_BITS          : INTEGER;
              DP_BITS          : INTEGER;
              ITERATIONS       : INTEGER;
              LOGITER          : INTEGER;
              MODE_VECTOR      : INTEGER;
              MODE             : INTEGER;
              FPGA_FAMILY      : INTEGER;
              DIE_SIZE         : INTEGER );
    PORT (  rst, nGrst       : IN STD_LOGIC;
            clk              : IN STD_LOGIC;
            ld_data_valid    : IN STD_LOGIC;
            freeze_regs      : IN STD_LOGIC;
            x0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            y0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            a0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            iter_count       : IN STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
            xn               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            yn               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            an               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            rcpr_gain_fx     : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)   );
  END COMPONENT;

  COMPONENT cordicSm IS
    GENERIC (
      ITERATIONS     : INTEGER := 24;
      LOGITER        : INTEGER := 5;
      COARSE         : INTEGER := 0;
      IN_REG         : INTEGER := 0   );
    PORT (
      clk            : IN STD_LOGIC;
      rst, nGrst     : IN STD_LOGIC;
      din_valid      : IN STD_LOGIC;
      rfd            : OUT STD_LOGIC;
      rfd_pilot      : OUT STD_LOGIC;
      micro_done     : OUT STD_LOGIC;
      ld_data_valid  : OUT STD_LOGIC;
      iter_count     : OUT STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
      freeze_regs    : OUT STD_LOGIC   );
  END COMPONENT;

  constant LOGITER    : INTEGER := ceil_log2(ITERATIONS);

  -- Prepare nibbles to be used IF (DP_BITS >= IN_BITS)
  SIGNAL x2u              : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);		-- inputs to uRotator
  SIGNAL y2u              : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL a2u              : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL coarse_flag      : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL coarse_flag2post : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL pre_coarse_valid : STD_LOGIC;
  SIGNAL rnd_done         : STD_LOGIC;
  SIGNAL iter_count       : STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
  SIGNAL romAngle         : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL x0               : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL y0               : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL a0               : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL xn_u             : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL yn_u             : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL an_u             : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL post_coarse_x    : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL post_coarse_y    : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL post_coarse_a    : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL rfd_pilot        : STD_LOGIC;
  SIGNAL ld_data_valid    : STD_LOGIC;
  SIGNAL ld_data2calc     : STD_LOGIC;
  SIGNAL xn_rnd           : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL yn_rnd           : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL an_rnd           : STD_LOGIC_VECTOR(EFFECT_OUT_BITS-1 DOWNTO 0);
  SIGNAL micro_done       : STD_LOGIC;
  SIGNAL freeze_regs      : STD_LOGIC;
  SIGNAL flag_regEn       : STD_LOGIC;
  SIGNAL rfdi             : STD_LOGIC;
BEGIN
  rfd <= rfdi;
  ld_data_valid <= din_valid AND rfdi;

  pre_rotat_0 : cordic_coarse_pre_rotator
     GENERIC MAP (  IN_BITS      => IN_BITS,
                    MODE_VECTOR  => MODE_VECTOR,
                    COARSE       => COARSE  )
     PORT MAP ( rst           => rst,
                nGrst         => nGrst,
                clk           => clk,
                datai_valid   => ld_data_valid,
                din_x         => din_x,
                din_y         => din_y,
                din_a         => din_a,
                x2u           => x2u,
                y2u           => y2u,
                a2u           => a2u,
                coarse_flag   => coarse_flag,
                datai_valido  => pre_coarse_valid );

  -- Store coarse_flag until it is used by coarse postRotator
  flag_regEn <= rfd_pilot OR rst;
  hold_coarse_flag_0 : cordic_kitDelay_reg
     GENERIC MAP (  BITWIDTH  => 2,
                    DELAY     => 1 )
     PORT MAP ( nGrst  => nGrst,
                rst    => rst,
                clk    => clk,
                clkEn  => flag_regEn,
                inp    => coarse_flag,
                outp   => coarse_flag2post );

  sm_0 : cordicSm
     GENERIC MAP (  ITERATIONS  => ITERATIONS,
                    LOGITER     => LOGITER,
                    COARSE      => COARSE,
                    IN_REG      => IN_REG  )
     PORT MAP ( clk            => clk,
                nGrst          => nGrst,
                rst            => rst,
                din_valid      => din_valid,
                ld_data_valid  => ld_data2calc,
                rfd            => rfdi,
                rfd_pilot      => rfd_pilot,
                micro_done     => micro_done,
                iter_count     => iter_count,
                freeze_regs    => freeze_regs );

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

  uRotator_0 : CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator
    GENERIC MAP ( IN_BITS      => IN_BITS,                      --5/15/2015
                  DP_BITS      => DP_BITS,
                  ITERATIONS   => ITERATIONS,
                  LOGITER      => LOGITER,
                  MODE_VECTOR  => MODE_VECTOR,
                  MODE         => MODE,
                  FPGA_FAMILY  => FPGA_FAMILY,
                  DIE_SIZE     => DIE_SIZE  )
    PORT MAP (  rst            => rst,
                nGrst          => nGrst,
                clk            => clk,
                ld_data_valid  => ld_data2calc,
                x0             => x0,
                y0             => y0,
                a0             => a0,
                iter_count     => iter_count,
                freeze_regs    => freeze_regs,
                xn             => xn_u,
                yn             => yn_u,
                an             => an_u,
                rcpr_gain_fx   => rcpr_gain_fx  );              --5/15/2015

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
                rst     => rst,
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


LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

--                        +-+-+-+-+-+-+-+-+-+-+-+-+-+
--                        |M|i|c|r|o|-|R|o|t|a|t|o|r|
--                        +-+-+-+-+-+-+-+-+-+-+-+-+-+
ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator IS
  GENERIC ( IN_BITS          : INTEGER := 16;                   --5/15/2015
            DP_BITS          : INTEGER := 16;
            ITERATIONS       : INTEGER := 24;
            LOGITER          : INTEGER := 6;
            MODE_VECTOR      : INTEGER := 0;
            MODE             : INTEGER := 0;
            FPGA_FAMILY      : INTEGER := 19;
            DIE_SIZE         : INTEGER := 20  );
  PORT (  rst, nGrst       : IN STD_LOGIC;
          clk              : IN STD_LOGIC;
          ld_data_valid    : IN STD_LOGIC;
          freeze_regs      : IN STD_LOGIC;
          x0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          y0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          a0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          iter_count       : IN STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
          xn               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          yn               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          an               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
          rcpr_gain_fx     : OUT STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0)  );     --5/15/2015
END ENTITY CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator;

ARCHITECTURE rtl OF CORECORDIC_C0_CORECORDIC_C0_0_cordic_word_uRotator IS
  COMPONENT cordic_word_calc
    GENERIC ( MODE_VECTOR      : INTEGER := 0;
              DP_BITS          : INTEGER := 48;
              LOGITER          : INTEGER := 6  );
    PORT (  clk              : IN STD_LOGIC;
            nGrst            : IN STD_LOGIC;
            rst              : IN STD_LOGIC;
            clkEn            : IN STD_LOGIC;
            x0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            y0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            a0               : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            xn               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            yn               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            an               : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
            ld_data_valid    : IN STD_LOGIC;
            iter_count       : IN STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
            freeze_regs      : IN STD_LOGIC;
            aRom             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0)  );
  END COMPONENT;

  COMPONENT CORECORDIC_C0_CORECORDIC_C0_0_word_cROM
    GENERIC ( LOGITER   : INTEGER;
              IN_BITS : INTEGER;                                          --5/15/2015
              DP_BITS : INTEGER  );
    PORT  ( iterCount   : IN std_logic_vector(LOGITER-1 DOWNTO 0);
            arctan      : OUT std_logic_vector(DP_BITS-1 DOWNTO 0);
            rcprGain_fx : OUT std_logic_vector(IN_BITS-1 DOWNTO 0)  );    --5/15/2015
  END COMPONENT;

  SIGNAL romAngle     : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL rcprGain_fx  : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);             --5/15/2015
BEGIN
--5/15/2015  x0i <= rcprGain_fx WHEN MODE=3 ELSE x0;
  
  calculator_0 : cordic_word_calc
    GENERIC MAP ( MODE_VECTOR  => MODE_VECTOR,
                  DP_BITS      => DP_BITS,
                  LOGITER      => LOGITER )
     PORT MAP (
        rst            => rst,
        nGrst          => nGrst,
        clk            => clk,
        clkEn          => '1',
        x0             => x0,                                             --5/15/2015
        y0             => y0,
        a0             => a0,
        xn             => xn,
        yn             => yn,
        an             => an,
        ld_data_valid  => ld_data_valid,
        freeze_regs    => freeze_regs,
        iter_count     => iter_count,
        aRom           => romAngle  );

  cordicRam : CORECORDIC_C0_CORECORDIC_C0_0_word_cROM
    GENERIC MAP ( LOGITER => LOGITER,
                  IN_BITS => IN_BITS,
                  DP_BITS => DP_BITS  )
    PORT MAP (  iterCount  => iter_count,
                arctan     => romAngle,
                rcprGain_fx => rcpr_gain_fx );                --5/15/2015

END ARCHITECTURE rtl;



