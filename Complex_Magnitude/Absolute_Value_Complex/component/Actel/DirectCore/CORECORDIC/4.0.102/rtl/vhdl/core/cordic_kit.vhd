--****************************************************************
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation.  All rights reserved
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description: CoreCORDIC
--             Common static modules
--
--Rev:
--v4.0 10/23/2014
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

--                         ____  ____  __      __   _  _
--                        (  _ \( ___)(  )    /__\ ( \/ )
--                         )(_) ))__)  )(__  /(__)\ \  /
--                        (____/(____)(____)(__)(__)(__)

------------- Register-based 1-bit Delay has only input and output -----------
LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.std_logic_unsigned.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_kitDelay_bit_reg IS
  GENERIC (
    DELAY         : INTEGER := 2  );
  PORT (
    nGrst         : IN STD_LOGIC;
    rst           : IN STD_LOGIC;
    clk           : IN STD_LOGIC;
    clkEn         : IN STD_LOGIC;
    inp           : IN STD_LOGIC;
    outp          : OUT STD_LOGIC  );
END ENTITY cordic_kitDelay_bit_reg;

ARCHITECTURE rtl OF cordic_kitDelay_bit_reg IS
  CONSTANT DLY_INT : integer := intMux (0, DELAY-1, (DELAY>0));
  TYPE dlyArray IS ARRAY (0 to DLY_INT) of std_logic;
  -- initialize delay line
  SIGNAL delayLine : dlyArray := (OTHERS => '0');
BEGIN
  genNoDel: IF (DELAY=0) GENERATE
    outp <= inp;
  END GENERATE;

  genDel: IF (DELAY/=0) GENERATE
      outp <= delayLine(DELAY-1);
  END GENERATE;

  PROCESS (clk, nGrst)
  BEGIN
    IF (NOT nGrst = '1') THEN
      FOR i IN DLY_INT DOWNTO 0 LOOP
        delayLine(i) <= '0';
      END LOOP;
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst='1') THEN
        FOR i IN DLY_INT DOWNTO 0 LOOP
          delayLine(i) <= '0';
        END LOOP;
      ELSIF (clkEn = '1') THEN
        FOR i IN DLY_INT DOWNTO 1 LOOP
          delayline(i) <= delayline(i-1);
        END LOOP;
        delayline(0) <= inp;
      END IF;  -- rst/clkEn
    END IF;
  END PROCESS;
END ARCHITECTURE rtl;


------------ Register-based Multi-bit Delay has only input and output ----------
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_kitDelay_reg IS
  GENERIC(
    BITWIDTH : integer := 16;
    DELAY:     integer := 2  );
  PORT (nGrst, rst, clk, clkEn : in std_logic;
        inp : in std_logic_vector(BITWIDTH-1 DOWNTO 0);
        outp: out std_logic_vector(BITWIDTH-1 DOWNTO 0) );
END ENTITY cordic_kitDelay_reg;

ARCHITECTURE rtl of cordic_kitDelay_reg IS
  CONSTANT DLY_INT : integer := intMux (0, DELAY-1, (DELAY>0));
  TYPE dlyArray IS ARRAY (0 to DLY_INT) of std_logic_vector(BITWIDTH-1 DOWNTO 0);
  -- initialize delay line
  SIGNAL delayLine : dlyArray := (OTHERS => std_logic_vector(to_unsigned(0, BITWIDTH)));
BEGIN
  genNoDel: IF (DELAY=0) GENERATE
    outp <= inp;
  END GENERATE;

  genDel: IF (DELAY/=0) GENERATE
      outp <= delayLine(DELAY-1);
  END GENERATE;

  PROCESS (clk, nGrst)
  BEGIN
    IF (NOT nGrst = '1') THEN
      FOR i IN DLY_INT DOWNTO 0 LOOP
        delayLine(i) <= std_logic_vector( to_unsigned(0, BITWIDTH));
      END LOOP;
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst='1') THEN
        FOR i IN DLY_INT DOWNTO 0 LOOP
          delayLine(i) <= std_logic_vector( to_unsigned(0, BITWIDTH));
        END LOOP;
      ELSIF (clkEn = '1') THEN
        FOR i IN DLY_INT DOWNTO 1 LOOP
          delayline(i) <= delayline(i-1);
        END LOOP;
        delayline(0) <= inp;
      END IF;  -- rst/clkEn
    END IF;
  END PROCESS;
END ARCHITECTURE rtl;


--                       _____                  _
--                      / ____|                | |
--                     | |     ___  _   _ _ __ | |_ ___ _ __
--                     | |    / _ \| | | | '_ \| __/ _ \ '__|
--                     | |___| (_) | |_| | | | | ||  __/ |
--                      \_____\___/ \__,_|_| |_|\__\___|_|

-- simple incremental counter
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_kitCountS IS
  GENERIC ( WIDTH         : INTEGER := 16;
            DCVALUE       : INTEGER := 1;		-- state to decode
            BUILD_DC      : INTEGER := 1  );
  PORT (nGrst, rst, clk, clkEn, cntEn : IN STD_LOGIC;
    Q             : OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    dc            : OUT STD_LOGIC   );		-- decoder output
END ENTITY cordic_kitCountS;

ARCHITECTURE rtl OF cordic_kitCountS IS
  SIGNAL count  : unsigned(WIDTH-1 DOWNTO 0);
BEGIN
  Q <= std_logic_vector(count);
  dc <= to_logic(count = DCVALUE) WHEN (BUILD_DC = 1) ELSE 'X';

  PROCESS (nGrst, clk)
  BEGIN
    IF (nGrst = '0') THEN
      count <= to_unsigned(0, WIDTH);
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (clkEn = '1') THEN
        IF (rst = '1') THEN
          count <= to_unsigned(0, WIDTH);
        ELSIF (cntEn = '1') THEN
          count <= count+1;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE rtl;


--                         _____                       _
--                        |  __ \                     | |
--                        | |__) |___  _   _ _ __   __| |
--                        |  _  // _ \| | | | '_ \ / _` |
--                        | | \ \ (_) | |_| | | | | (_| |
--                        |_|  \_\___/ \__,_|_| |_|\__,_|

-- ---------------------  Round Up or Symmetric Round  ----------------------
-- 2-clk delay to match convergent rounding
-- -------------------------------
-- INWIDTH must be >= OUTWIDTH
-- -------------------------------
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

-- m = INWIDTH-OUTWIDTH is supposed to be >=1
ENTITY cordic_kitRndUp IS
  GENERIC ( INWIDTH       : INTEGER := 16;
            OUTWIDTH      : INTEGER := 12;
            SYMM          : INTEGER := 0  );
  PORT  (
    nGrst       : IN STD_LOGIC;
    rst         : IN STD_LOGIC;
    clk         : IN STD_LOGIC;
    datai_valid : IN STD_LOGIC;
    inp         : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
    outp        : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0) );
END ENTITY cordic_kitRndUp;

ARCHITECTURE rtl OF cordic_kitRndUp IS
  SIGNAL inp_w, inp_ww  : STD_LOGIC_VECTOR(OUTWIDTH DOWNTO 0);
  SIGNAL outp_w         : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
BEGIN
  inp_w  <= inp(INWIDTH-1 DOWNTO INWIDTH-OUTWIDTH-1);
  inp_ww <= std_logic_vector(signed(inp_w) + 1);
  outp_w <= inp_ww(OUTWIDTH DOWNTO 1);

  pipe_0 : cordic_kitDelay_reg
    GENERIC MAP ( BITWIDTH  => OUTWIDTH,
                  DELAY     => 2  )
    PORT MAP (
      nGrst  => nGrst,
      rst    => rst,
      clk    => clk,
      clkEn  => datai_valid,
      inp    => outp_w,
      outp   => outp     );
END ARCHITECTURE rtl;


LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

-- m = INWIDTH-OUTWIDTH is supposed to be >=2
ENTITY cordic_kitRndSymm IS
  GENERIC ( INWIDTH       : INTEGER := 16;
            OUTWIDTH      : INTEGER := 12;
            SYMM          : INTEGER := 0  );
  PORT  (
    nGrst       : IN STD_LOGIC;
    rst         : IN STD_LOGIC;
    clk         : IN STD_LOGIC;
    datai_valid : IN STD_LOGIC;
    inp         : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
    outp        : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0) );
END ENTITY cordic_kitRndSymm;

ARCHITECTURE rtl OF cordic_kitRndSymm IS
  constant M  : INTEGER := INWIDTH - OUTWIDTH;
  constant NEGADD_NIB1 : STD_LOGIC_VECTOR (M-2 DOWNTO 0) := (others=>'1');
  constant NEGADD_NIB0 : STD_LOGIC_VECTOR (INWIDTH-1 DOWNTO M-1) := (others=>'0');
  constant NEGADD : STD_LOGIC_VECTOR (INWIDTH-1 DOWNTO 0) := NEGADD_NIB0 & NEGADD_NIB1;
  constant POSADD : STD_LOGIC_VECTOR (INWIDTH-1 DOWNTO 0) := ((M-1)=>'1', OTHERS=>'0');

  SIGNAL halfRnd  : STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
  SIGNAL outp_w   : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
BEGIN
  halfRnd <= std_logic_vector(signed(inp) + signed(POSADD)) WHEN inp(INWIDTH-1) = '0'
              ELSE
             std_logic_vector(signed(inp) + signed(NEGADD));
  outp_w <= halfRnd(INWIDTH-1 DOWNTO INWIDTH-OUTWIDTH);

  pipe_0 : cordic_kitDelay_reg
    GENERIC MAP ( BITWIDTH  => OUTWIDTH,
                  DELAY     => 2  )
    PORT MAP (
      nGrst  => nGrst,
      rst    => rst,
      clk    => clk,
      clkEn  => datai_valid,
      inp    => outp_w,
      outp   => outp     );
END ARCHITECTURE rtl;

-- ---------------------------  Convergent Rounding  --------------------------
-- Round-to-nearest-even  = Convergent = Round half to even = Unbiased =
-- statistician's rounding = Dutch rounding = Gaussian rounding =
-- Odd-even rounding = Bankers' rounding = broken rounding = DDR rounding
-- and is widely used in bookkeeping.
-- 2-clk delay
-- -------------------------------
-- INWIDTH must be >= OUTWIDTH+2.
-- -------------------------------
-- Overflow may occur when inp>0 only since we always add 1 or 0, never add -1

LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_kitRndEven IS
  GENERIC ( INWIDTH      : INTEGER := 16;
            OUTWIDTH     : INTEGER := 12  );
  PORT (
    nGrst   : IN STD_LOGIC;
    clk     : IN STD_LOGIC;
    datai_valid  : IN STD_LOGIC;
    rst     : IN STD_LOGIC;
    inp     : IN STD_LOGIC_VECTOR(INWIDTH - 1 DOWNTO 0);
    outp    : OUT STD_LOGIC_VECTOR(OUTWIDTH - 1 DOWNTO 0) );
END ENTITY cordic_kitRndEven;

ARCHITECTURE rtl OF cordic_kitRndEven IS
  SIGNAL roundBit      : STD_LOGIC;
  SIGNAL roundBit_tick : STD_LOGIC;
  SIGNAL stickyBit     : STD_LOGIC;
  SIGNAL rBit          : STD_LOGIC;
  SIGNAL lsBit         : STD_LOGIC;
  SIGNAL riskOV        : STD_LOGIC;
  SIGNAL inp_w         : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
  SIGNAL inp_tick      : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
  SIGNAL outp_w        : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
  SIGNAL signBit       : STD_LOGIC;
  SIGNAL rndBit_vect   : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);

BEGIN
  signBit <= inp(INWIDTH-1);
  -- the least significant remaining bit
  lsBit <= inp(INWIDTH-OUTWIDTH);
  -- the most significant truncated bit
  rBit <= inp(INWIDTH-OUTWIDTH-1);
  stickyBit <= reductionOr(inp(INWIDTH-OUTWIDTH-2 DOWNTO 0));
  -- Detect the max positive number of size OUTWIDTH: sign==0, others==1
  riskOV <= (NOT(signBit)) AND (reductionAnd(inp(INWIDTH-2 DOWNTO INWIDTH-OUTWIDTH)));
  -- Calculate the bit to be added to the remaining bits
  roundBit <= rBit AND (stickyBit OR lsBit) AND NOT(riskOV);

  -- Pipe the roundBit
  roundBit_pipe_0 : cordic_kitDelay_bit_reg
    GENERIC MAP ( DELAY => 1 )
    PORT MAP (
      nGrst => nGrst, rst => rst, clk => clk,
      clkEn  => datai_valid,
      inp    => roundBit,
      outp   => roundBit_tick  );

  -- Simply delay the bits to keep matching the roundBit delay
  inp_w <= inp(INWIDTH-1 DOWNTO INWIDTH-OUTWIDTH);
  inp_pipe_0 : cordic_kitDelay_reg
    GENERIC MAP ( BITWIDTH  => OUTWIDTH, DELAY => 1)
    PORT MAP (
      nGrst  => nGrst, rst => rst, clk => clk,
      clkEn  => datai_valid,
      inp    => inp_w,
      outp   => inp_tick  );

  -- Calculate the result and pipe it
  rndBit_vect <= (0=>roundBit_tick, others=>'0');
  outp_w <= std_logic_vector(signed(inp_tick) + signed(rndBit_vect));

  result_pipe_0 : cordic_kitDelay_reg
    GENERIC MAP (BITWIDTH  => OUTWIDTH, DELAY => 1)
    PORT MAP (
      nGrst  => nGrst, rst => rst, clk => clk,
      clkEn  => datai_valid,
      inp    => outp_w,
      outp   => outp  );

END ARCHITECTURE rtl;



-- Combine all round types depending on ROUND parameter and
-- INWIDTH/OUTWIDTH values:
-- ROUND                          Function
-- ---------------------------------------
--  0     INWIDTH >  OUTWIDTH     Truncate
--  1     INWIDTH > OUTWIDTH+1    Convergent round
--  2     INWIDTH >  OUTWIDTH     Symmetry round
--  3     INWIDTH >  OUTWIDTH     Round Up
--  1     INWIDTH ==OUTWIDTH+1    Round Up
--  x     INWIDTH <= OUTWIDTH     Sign extend

LIBRARY ieee;
  USE ieee.std_logic_1164.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_kitRoundTop IS
  GENERIC ( INWIDTH   : INTEGER := 16;
            OUTWIDTH  : INTEGER := 12;
            ROUND     : INTEGER := 1;
            VALID_BIT : INTEGER := 0  );
  PORT (
    nGrst         : IN STD_LOGIC;
    rst           : IN STD_LOGIC;
    clk           : IN STD_LOGIC;
    inp           : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
    outp          : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
    --A bit that travels side by side with data.  No interaction with rounding
    validi        : IN STD_LOGIC;
    valido        : OUT STD_LOGIC  );
END ENTITY cordic_kitRoundTop;

ARCHITECTURE rtl OF cordic_kitRoundTop IS
  SIGNAL outp_w        : STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
BEGIN
  -- Just sign extend
  sign_extend : IF (INWIDTH <= OUTWIDTH) GENERATE
    signExt_0 : cordic_signExt
      GENERIC MAP (INWIDTH => INWIDTH,
        OUTWIDTH  => OUTWIDTH,
        UNSIGN    => 0      )
      PORT MAP (  inp   => inp,
        outp  => outp_w );

    pipe_0 : cordic_kitDelay_reg
      GENERIC MAP (BITWIDTH => OUTWIDTH, DELAY => 2)
      PORT MAP (
        nGrst  => nGrst, rst => rst, clk => clk,
        clkEn  => '1',
        inp    => outp_w,
        outp   => outp      );
  END GENERATE;

  -- Truncate
  truncate : IF ( (INWIDTH>OUTWIDTH) AND (ROUND=0) ) GENERATE
    outp_w <= inp(INWIDTH-1 DOWNTO INWIDTH-OUTWIDTH);

    pipe_0 : cordic_kitDelay_reg
      GENERIC MAP (BITWIDTH => OUTWIDTH, DELAY => 2)
      PORT MAP (
        nGrst  => nGrst, rst => rst, clk => clk,
        clkEn  => '1',
        inp    => outp_w,
        outp   => outp      );
  END GENERATE;

  -- Round up
  round_up : IF (((INWIDTH>OUTWIDTH) AND (ROUND=3)) OR
                 ((INWIDTH=OUTWIDTH+1) AND (ROUND/=0))) GENERATE
    kitRndUp_0 : cordic_kitRndUp
      GENERIC MAP (
        INWIDTH       => INWIDTH,
        OUTWIDTH      => OUTWIDTH,
        SYMM          => 0 )
      PORT MAP (
        nGrst => nGrst, rst => rst, clk => clk,
        datai_valid  => '1',
        inp          => inp,
        outp         => outp      );
  END GENERATE;

  -- Round symm
  symm : IF ((INWIDTH>OUTWIDTH+1) AND (ROUND=2)) GENERATE
    kitSymm_0 : cordic_kitRndSymm
      GENERIC MAP (
        INWIDTH       => INWIDTH,
        OUTWIDTH      => OUTWIDTH,
        SYMM          => 1 )
      PORT MAP (
        nGrst => nGrst, rst => rst, clk => clk,
        datai_valid  => '1',
        inp          => inp,
        outp         => outp      );
  END GENERATE;

  -- Convergent rounding
  converg_rnd : IF ((INWIDTH>OUTWIDTH+1) AND (ROUND=1)) GENERATE
    kitRndEven_0 : cordic_kitRndEven
      GENERIC MAP (INWIDTH => INWIDTH, OUTWIDTH => OUTWIDTH)
      PORT MAP (
        nGrst => nGrst, rst => rst, clk => clk,
        datai_valid  => '1',
        inp          => inp,
        outp         => outp    );
  END GENERATE;

  create_valid_bit: IF (VALID_BIT=1) GENERATE
    valid_pipe_0 : cordic_kitDelay_bit_reg
     GENERIC MAP (  DELAY  => 2 )
     PORT MAP (
        nGrst  => nGrst,  rst => rst, clk => clk, clkEn  => '1',
        inp    => validi,
        outp   => valido  );
  END GENERATE;

END ARCHITECTURE rtl;



--        ___  ____  ___  _  _    ____  _  _  ____  ____  _  _  ____
--       / __)(_  _)/ __)( \( )  ( ___)( \/ )(_  _)( ___)( \( )(  _ \
--       \__ \ _)(_( (_-. )  (    )__)  )  (   )(   )__)  )  (  )(_) )
--       (___/(____)\___/(_)\_)  (____)(_/\_) (__) (____)(_)\_)(____/
-- Resize a vector inp to the specified size.
-- When resizing to a larger vector, sign extend the inp: the new [leftmost]
-- bit positions are filled with a sign bit (UNSIGNED==0) or 0's (UNSIGNED==1).
-- When resizing to a smaller vector, account for the DROP_MSB flavor:
-- - DROP_MSB==0.  Normal. Simply drop extra LSB's
-- - DROP_MSB==1.  Unusual. If signed, retain the sign bit along with the LSB's
--                 If unsigned, simply drop extra MSB"s
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;
-- If signed, keep the input sign bit; otherwise just drop extra MSB's
ENTITY cordic_signExt IS
  GENERIC (
    INWIDTH   : INTEGER := 16;
    OUTWIDTH  : INTEGER := 20;
    UNSIGN    : INTEGER := 0;     -- 0-signed conversion; 1-unsigned
    -- When INWIDTH>OUTWIDTH, drop extra MSB's. Normally extra LSB's are dropped
    DROP_MSB  : INTEGER := 0  );
  PORT (
    inp             : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
    outp            : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0)  );
END ENTITY cordic_signExt;

ARCHITECTURE rtl OF cordic_signExt IS
  SIGNAL sB            : STD_LOGIC;
  signal outp_s : signed  (OUTWIDTH-1 downto 0);
  signal outp_u : unsigned(OUTWIDTH-1 downto 0);
BEGIN
  -- Input sign bit
  sB <= inp(INWIDTH-1);
  pass_thru : IF (INWIDTH = OUTWIDTH) GENERATE
    outp <= inp;
  END GENERATE;

  extend_sign : IF (OUTWIDTH > INWIDTH) GENERATE
    outp_s <= RESIZE (signed(inp), OUTWIDTH);
    outp_u <= RESIZE (unsigned(inp), OUTWIDTH);
    outp <= std_logic_vector(outp_s) WHEN UNSIGN=0 ELSE std_logic_vector(outp_u);
  END GENERATE;

  cut_lsbs : IF ((OUTWIDTH < INWIDTH) AND (DROP_MSB = 0)) GENERATE
    outp <= inp(INWIDTH-1 DOWNTO INWIDTH-OUTWIDTH);
  END GENERATE;

  cut_msbs : IF ((OUTWIDTH < INWIDTH) AND (DROP_MSB = 1)) GENERATE
    outp(OUTWIDTH-2 DOWNTO 0) <= inp(OUTWIDTH-2 DOWNTO 0);
    outp(OUTWIDTH-1) <= sB WHEN (UNSIGN = 0) ELSE inp(OUTWIDTH-1);
  END GENERATE;

END ARCHITECTURE rtl;



--  ___  ____   __   ____  ____    __  __    __    ___  _   _  ____  _  _  ____
-- / __)(_  _) /__\ (_  _)( ___)  (  \/  )  /__\  / __)( )_( )(_  _)( \( )( ___)
-- \__ \  )(  /(__)\  )(   )__)    )    (  /(__)\( (__  ) _ (  _)(_  )  (  )__)
-- (___/ (__)(__)(__)(__) (____)  (_/\/\_)(__)(__)\___)(_) (_)(____)(_)\_)(____)
--  --------  CORDIC Word-serial State Machine  ----------
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordicSm IS
  GENERIC (
    ITERATIONS     : INTEGER := 24;
    LOGITER        : INTEGER := 5;		-- log2(ITERATIONS)
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
    freeze_regs    : OUT STD_LOGIC  );
END ENTITY cordicSm;

ARCHITECTURE rtl OF cordicSm IS
  constant LOGITER_M   : INTEGER := ceil_log2(ITERATIONS+1);
  constant FRONT_PIPES : INTEGER := COARSE + IN_REG;

  SIGNAL rfdn, rfdi, rfdi_n : STD_LOGIC;
  SIGNAL rst_iterCount      : STD_LOGIC;
  SIGNAL iterCount          : STD_LOGIC_VECTOR(LOGITER_M-1 DOWNTO 0);
  SIGNAL ld_data_validi, ld_data_valid_w    : STD_LOGIC;
  SIGNAL iter_counti        : STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
  SIGNAL rfd_piloti         : STD_LOGIC;
BEGIN
  rfd <= rfdi;
  rfd_pilot <= rfd_piloti;
  ld_data_valid <= ld_data_valid_w;

  -- rst or ld_data_valid resets and kicks off the iterCounter. After
  -- ITERATIONS-1 cycles, the counter generates a short rfd_pilot signal and
  -- gets stuck in ITERATIONS state, as rfd goes High thus preventing counting
  rst_iterCount <= rst OR ld_data_valid_w;
  rfdi    <= (NOT rfdn) AND (NOT rst); 
  rfdi_n  <= NOT rfdi;

  iterCounter_0 : cordic_kitCountS
     GENERIC MAP (
        WIDTH     => LOGITER_M,
        DCVALUE   => ITERATIONS-1,
        BUILD_DC  => 1  )
     PORT MAP (
        nGrst  => nGrst,
        rst    => rst_iterCount,
        clk    => clk,
        clkEn  => '1',
        cntEn  => rfdi_n,
        Q      => iterCount,
        dc     => rfd_piloti   );

  -- Negative rfdn RS flop
  PROCESS (nGrst, clk)
  BEGIN
    IF (nGrst = '0') THEN
      rfdn <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') OR (rfd_piloti = '1') THEN
        rfdn <= '0';
      ELSIF (ld_data_validi = '1') THEN
        rfdn <= '1';
      END IF;
    END IF;
  END PROCESS;

  iter_counti <= iterCount(LOGITER-1 DOWNTO 0);
  
--sar68170  ld_data_validi <= din_valid AND NOT(rfdn);
  ld_data_validi <= din_valid AND rfdi;
  
  dly_iter_count_0 : cordic_kitDelay_reg
     GENERIC MAP (  BITWIDTH  => LOGITER,
                    DELAY     => FRONT_PIPES  )
     PORT MAP (
        nGrst  => nGrst,  rst    => '0',  clk    => clk,  clkEn  => '1',
        inp    => iter_counti,
        outp   => iter_count );

  dly_ld_valid_0 : cordic_kitDelay_bit_reg
     GENERIC MAP (  DELAY  => FRONT_PIPES )
     PORT MAP (
        nGrst  => nGrst,  rst    => '0',  clk    => clk,  clkEn  => '1',
        inp    => ld_data_validi,
        outp   => ld_data_valid_w  );

  dly_freeze_reg_0 : cordic_kitDelay_bit_reg
     GENERIC MAP (  DELAY  => FRONT_PIPES+COARSE )
     PORT MAP (
        nGrst  => nGrst,  rst    => '0',  clk    => clk,  clkEn  => '1',
        inp    => rfdn,
        outp   => freeze_regs );

  dly_micro_done_0 : cordic_kitDelay_bit_reg
     GENERIC MAP (  DELAY  => FRONT_PIPES+1 )
     PORT MAP (
        nGrst  => nGrst,  rst    => '0',  clk    => clk,  clkEn  => '1',
        inp    => rfd_piloti,
        outp   => micro_done );
END ARCHITECTURE rtl;




LIBRARY ieee;
  USE ieee.std_logic_1164.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_init_kickstart IS
   PORT ( nGrst          : IN STD_LOGIC;
          clk            : IN STD_LOGIC;
          rst            : IN STD_LOGIC;
          rsto           : OUT STD_LOGIC   );
END ENTITY cordic_init_kickstart;

ARCHITECTURE rtl OF cordic_init_kickstart IS
   SIGNAL pulse, terminate_rsto   : STD_LOGIC;
   SIGNAL rstoi                   : STD_LOGIC := '0';
BEGIN
  -- After deasserting nGrst, wait several clk cycles, then generate a 1-clk
  -- pulse.  The counter below works once after nGrst, then rstoi holds it.
  counter_0 : cordic_kitCountS
    GENERIC MAP ( WIDTH     => 4,
                  DCVALUE   => 15,
                  BUILD_DC  => 1  )
    PORT MAP (
      nGrst  => nGrst,
      rst    => rst,
      clk    => clk,
      clkEn  => '1',
      cntEn  => rstoi,
      Q      => open,
      dc     => pulse  );

  -- Terminate rstoi on rst or pulse, whichever comes first
  terminate_rsto <= rst OR pulse;
  PROCESS (nGrst, clk)
  BEGIN
    IF (nGrst = '0') THEN
      rstoi <= '1';
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (terminate_rsto = '1') THEN
        rstoi <= '0';
      END IF;
    END IF;
  END PROCESS;

  -- If no nGrst, rstoi can be in any state. Say rstoi=1. Then rsto will stay
  -- in state 1 (until rst comes) and SM will reset. If rstoi=0, rsto=rst
  -- and SM will be reset as well
  rsto <= rstoi OR rst;
END ARCHITECTURE rtl;

--LIBRARY ieee;
--  USE ieee.std_logic_1164.all;
--USE work.cordic_rtl_pack.all;
--
--ENTITY cordic_init_kickstart IS
--   PORT ( nGrst          : IN STD_LOGIC;
--          clk            : IN STD_LOGIC;
--          rst            : IN STD_LOGIC;
--          rsto           : OUT STD_LOGIC   );
--END ENTITY cordic_init_kickstart;
--
--ARCHITECTURE rtl OF cordic_init_kickstart IS
--   SIGNAL pulse               : STD_LOGIC;
--   SIGNAL block_pulse         : STD_LOGIC;
--   SIGNAL nblock_pulse        : STD_LOGIC;
--   SIGNAL rstoi               : STD_LOGIC;
--BEGIN
--  rsto <= rstoi;
--  nblock_pulse <= NOT(block_pulse);
--
--  -- After deasserting nGrst, wait several clk cycles, then generate a 1-clk
--  -- pulse.  The counter below works once after nGrst, then stays in state 0.
--  counter_0 : cordic_kitCountS
--    GENERIC MAP ( WIDTH     => 4,
--                  DCVALUE   => 15,
--                  BUILD_DC  => 1  )
--    PORT MAP (
--      nGrst  => nGrst,
--      rst    => rst,
--      clk    => clk,
--      clkEn  => '1',
--      cntEn  => nblock_pulse,
--      Q      => open,
--      dc     => pulse  );
--
--  -- If rst comes first, block the pulse
--  PROCESS (nGrst, clk)
--  BEGIN
--    IF (nGrst = '0') THEN
--      block_pulse <= '0';
--    ELSIF (clk'EVENT AND clk = '1') THEN
--      IF (rstoi = '1') THEN
--        block_pulse <= '1';
--      END IF;
--    END IF;
--  END PROCESS;
--
--  rstoi <= rst OR pulse;
--END ARCHITECTURE rtl;


-- sss start
--        +-+-+ +-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+
--        |D|P| |B|i|t|s| |T|r|a|n|s|i|t|i|o|n|
--        +-+-+ +-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+
-- Datapath transition from input to uRotator
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_dp_bits_trans IS
  GENERIC (  IN_BITS  : INTEGER := 16;
             DP_BITS  : INTEGER := 16  );
  PORT ( xin, yin, ain    : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
         xout, yout, aout : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0) );
END ENTITY cordic_dp_bits_trans;

ARCHITECTURE rtl OF cordic_dp_bits_trans IS
  -- CORDIC arithmetic has datapath width of dpBits.
  -- Input fx-pt data are to be scaled up or down to the datapath width.
  -- IMPORTANT: X,Y datapath must have an extra bit to accomodate large output
  -- vectors (e.g. 1.67*sqrt(1^2+1^2)=1.647*1.41) due to CORDIC gain!!!
  SIGNAL xouti, youti, aouti  : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
BEGIN
  -- First sign-extend inputs to output size
  sign_ext_x_0 : cordic_signExt
    GENERIC MAP ( INWIDTH   => IN_BITS,
                  OUTWIDTH  => DP_BITS,
                  UNSIGN  => 0,
                  DROP_MSB  => 0  )
    PORT MAP (  inp   => xin,
                outp  => xouti );

  sign_ext_y_0 : cordic_signExt
    GENERIC MAP ( INWIDTH   => IN_BITS,
                  OUTWIDTH  => DP_BITS,
                  UNSIGN  => 0,
                  DROP_MSB  => 0  )
    PORT MAP (  inp   => yin,
                outp  => youti );

  sign_ext_a_0 : cordic_signExt
    GENERIC MAP ( INWIDTH   => IN_BITS,
                  OUTWIDTH  => DP_BITS,
                  UNSIGN  => 0,
                  DROP_MSB  => 0  )
    PORT MAP (  inp   => ain,
                outp  => aouti );

  inBits_less1 : IF (DP_BITS >= IN_BITS+1) GENERATE
    xout <= leftShiftL (xouti, (DP_BITS-1-IN_BITS));
    yout <= leftShiftL (youti, (DP_BITS-1-IN_BITS));
  END GENERATE;

  inBits_more1 : IF (DP_BITS < IN_BITS+1) GENERATE
    xout <= rightShiftA (xouti, 1);
    yout <= rightShiftA (youti, 1);
  END GENERATE;

  inBits_less : IF (DP_BITS >= IN_BITS) GENERATE
    aout <= leftShiftL (aouti, (DP_BITS-IN_BITS));
  END GENERATE;

  inBits_more : IF (DP_BITS < IN_BITS) GENERATE
    aout <= aouti;
  END GENERATE;
END ARCHITECTURE rtl;


--                       ____
--                      / ___| ___    __ _  _ __  ___   ___
--                     | |    / _ \  / _` || '__|/ __| / _ \
--                     | |___| (_) || (_| || |   \__ \|  __/
--                      \____|\___/  \__,_||_|   |___/ \___|

-- Coarse pre-rotator rotates inp vestor based on mode if necessary.
-- If coarse rotation was performed, it raises flag to let post-rotator know it
-- needs to correct a micro-rotator output

-- Coarse Algo
-------------------------------------
-- halfMaxVal = antilog(IN_BITS-2);

--  Rotation Modes
--    if( inp.a > halfMaxVal)  {
--      coarse.a    = inp.a - halfMaxVal;  // subtract PI/2
--      coarseFlag  = 1;
--    }
--    if( inp.a < -halfMaxVal) {
--      coarse.a    = inp.a + halfMaxVal;  // add PI/2
--      coarseFlag  = -1;
--    }

--  Vectoring Modes
--    if(inp.x < 0)   { // initial vector is in quadrant 2 or 3
--      if(inp.y >= 0)  { // initial vector is in quadrant 2
--        // rotate by -PI/2
--        coarse.x = inp.y;
--        coarse.y = -inp.x;
--        coarseFlag  = 1;
--      }
--      else            { // initial vector is in quadrant 3
--        // rotate by +PI/2
--        coarse.x = -inp.y;
--        coarse.y = inp.x;
--        coarseFlag  = -1;
--      }
--    }
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_coarse_pre_rotator IS
  GENERIC (  IN_BITS       : INTEGER := 16;
             MODE_VECTOR   : INTEGER := 0;
             COARSE        : INTEGER := 0  );
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
END ENTITY cordic_coarse_pre_rotator;

ARCHITECTURE rtl OF cordic_coarse_pre_rotator IS
  -- !!! IMPORTANT: SET THE SOFT cordic_angle_scale FUNCTION = 2*fx_half_PI !!!
  constant fx_half_PI_slv : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0) := ((IN_BITS-3)=>'1', others=>'0');    --sss
  constant fx_half_PI : signed(IN_BITS-1 DOWNTO 0) := signed(fx_half_PI_slv);

  SIGNAL x2u_w          : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL y2u_w          : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL a2u_w          : STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
  SIGNAL coarse_flag_w  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL lock_flag      : STD_LOGIC;

BEGIN
  pre_coarse_rotationMode : IF ((COARSE/=0) AND (MODE_VECTOR/=1)) GENERATE

    a2u_w <=  std_logic_vector( signed(din_a) - fx_half_PI )
                WHEN signed(din_a) > fx_half_PI ELSE
              std_logic_vector( signed(din_a) + fx_half_PI )
                WHEN signed(din_a) < -fx_half_PI ELSE
              din_a;

    x2u_w <= din_x;
    y2u_w <= din_y;
    coarse_flag_w <= "01" WHEN signed(din_a) > fx_half_PI ELSE
                     "10" WHEN signed(din_a) < -fx_half_PI ELSE
                     "00";
  END GENERATE;

  pre_coarse_vectorMode : IF ((COARSE/=0) AND (MODE_VECTOR=1)) GENERATE
    x2u_w <=  din_x   WHEN signed(din_x) >= 0 ELSE
              din_y   WHEN signed(din_y) >= 0 ELSE
              std_logic_vector(-signed(din_y));
    y2u_w <=  din_y   WHEN signed(din_x) >= 0 ELSE
              std_logic_vector(-signed(din_x)) WHEN signed(din_y) >= 0 ELSE
              din_x;
    a2u_w <=  din_a;
    coarse_flag_w <= "00" WHEN signed(din_x) >= 0 ELSE
                     "01" WHEN signed(din_y) >= 0 ELSE
                     "10";
  END GENERATE;

  coarse_regs : IF (COARSE /= 0) GENERATE
    preCoarseReg_x : cordic_kitDelay_reg
      GENERIC MAP ( BITWIDTH => IN_BITS,
                    DELAY    => 1  )
      PORT MAP (  nGrst => nGrst, rst => '0', clk => clk, clkEn => '1',
           inp    => x2u_w,
           outp   => x2u  );

    preCoarseReg_y : cordic_kitDelay_reg
      GENERIC MAP ( BITWIDTH => IN_BITS,
                    DELAY    => 1  )
      PORT MAP (  nGrst => nGrst, rst => '0', clk => clk, clkEn => '1',
           inp    => y2u_w,
           outp   => y2u  );

    preCoarseReg_a : cordic_kitDelay_reg
      GENERIC MAP ( BITWIDTH => IN_BITS,
                    DELAY    => 1  )
      PORT MAP (  nGrst => nGrst, rst => '0', clk => clk, clkEn => '1',
           inp    => a2u_w,
           outp   => a2u  );

    -- Delay validity bit to match the above regs
    dly_0 : cordic_kitDelay_bit_reg
      GENERIC MAP ( DELAY  => 1 )
      PORT MAP (  nGrst => nGrst, rst => '0', clk => clk, clkEn => '1',
         inp    => datai_valid,
         outp   => datai_valido );

    -- Save coarse flag for a period of datai_valid.
    lock_flag <= datai_valid OR rst;
    preCoarseReg_flag : cordic_kitDelay_reg
      GENERIC MAP ( BITWIDTH  => 2,
                    DELAY     => 1 )
      PORT MAP (
        nGrst  => '1', clk => clk,
        rst    => rst,
        clkEn  => lock_flag,
        inp    => coarse_flag_w,
        outp   => coarse_flag  );
  END GENERATE;

  no_coarse : IF (COARSE = 0) GENERATE
     x2u          <= din_x;
     y2u          <= din_y;
     a2u          <= din_a;
     datai_valido <= datai_valid;
     coarse_flag  <= "11";
  END GENERATE;

END ARCHITECTURE rtl;



-- Coarse post-rotator rotates outp vestor based on mode and outputs the final
-- vector.  If does so if pre-rotator had raised a flag.  Otherwise it just let
-- the micro-rotator output thru.

-- Coarse Algo
-------------------------------------
-- halfMax = antiLog(OUT_BITS-2)

-- Rotation Modes
--    if(coarseFlag==1)  {
--      coarse.x = -inp.y;
--      coarse.y = inp.x;
--    }
--    if(coarseFlag==-1)  {
--      coarse.x = inp.y;
--      coarse.y = -inp.x;
--    }

-- Vectoring Modes
--    if(coarseFlag==1)
--      coarse.a = inp.a + halfMax;
--    if(coarseFlag==-1)
--      coarse.a = inp.a - halfMax;
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_coarse_post_rotator IS
  GENERIC (BITS         : INTEGER := 16;
           MODE_VECTOR  : INTEGER := 0;
           COARSE       : INTEGER := 0 );
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
END ENTITY cordic_coarse_post_rotator;

ARCHITECTURE rtl OF cordic_coarse_post_rotator IS
  -- !!! IMPORTANT: SET THE SOFT cordic_angle_scale FUNCTION = 2*fx_half_PI !!!
  constant fx_half_PI_slv : STD_LOGIC_VECTOR(BITS-1 DOWNTO 0) := ((BITS-3)=>'1', others=>'0');    --sss
  constant fx_half_PI : signed(BITS-1 DOWNTO 0) := signed(fx_half_PI_slv);

  SIGNAL x_w           : STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
  SIGNAL y_w           : STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
  SIGNAL a_w           : STD_LOGIC_VECTOR(BITS-1 DOWNTO 0);
  SIGNAL coarse_flag_w : STD_LOGIC;
BEGIN
  post_coarse_rotationMode : IF ((COARSE /= 0) AND (MODE_VECTOR /= 1)) GENERATE
    x_w <= std_logic_vector(-signed(yu)) WHEN (coarse_flag = "01") ELSE
           yu                            WHEN (coarse_flag = "10") ELSE
           xu;
    y_w <= xu                            WHEN (coarse_flag = "01") ELSE
           std_logic_vector(-signed(xu)) WHEN (coarse_flag = "10") ELSE
           yu;
    a_w <= (others=>'0');
  END GENERATE;

  post_coarse_vectorMode : IF ((COARSE /= 0) AND (MODE_VECTOR = 1)) GENERATE
    x_w <= xu;
    y_w <= yu;
    a_w <= std_logic_vector(signed(au) + fx_half_PI) WHEN (coarse_flag = "01") ELSE
           std_logic_vector(signed(au) - fx_half_PI) WHEN (coarse_flag = "10") ELSE
           au;
  END GENERATE;

  coarse_regs : IF (COARSE /= 0) GENERATE
    preCoarseReg_x : cordic_kitDelay_reg
      GENERIC MAP (  BITWIDTH  => BITS,
                     DELAY     => 1 )
      PORT MAP ( nGrst  => nGrst, clk    => clk, clkEn  => '1',
        rst    => rst,
        inp    => x_w,
        outp   => out_x  );

    preCoarseReg_y : cordic_kitDelay_reg
      GENERIC MAP (  BITWIDTH  => BITS,
                     DELAY     => 1 )
      PORT MAP ( nGrst  => nGrst, clk    => clk, clkEn  => '1',
        rst    => rst,
        inp    => y_w,
        outp   => out_y  );

    preCoarseReg_a : cordic_kitDelay_reg
      GENERIC MAP (  BITWIDTH  => BITS,
                     DELAY     => 1 )
      PORT MAP ( nGrst  => nGrst, clk    => clk, clkEn  => '1',
        rst    => rst,
        inp    => a_w,
        outp   => out_a  );

    -- Delay validity bit to match the above regs
    dly_0 : cordic_kitDelay_bit_reg
      GENERIC MAP ( DELAY  => 1 )
      PORT MAP (  nGrst  => nGrst, rst => '0', clk => clk, clkEn => '1',
            inp    => datai_valid,
            outp   => datao_valid );
   END GENERATE;

   no_coarse : IF (COARSE = 0) GENERATE
      out_x <= xu;
      out_y <= yu;
      out_a <= au;
      datao_valid <= datai_valid;
   END GENERATE;
END ARCHITECTURE rtl;



LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_word_calc IS
  GENERIC (  MODE_VECTOR    : INTEGER := 0;
             DP_BITS        : INTEGER := 48;
             LOGITER        : INTEGER := 6   );
  PORT (
    clk            : IN STD_LOGIC;
    nGrst          : IN STD_LOGIC;
    rst            : IN STD_LOGIC;
    clkEn          : IN STD_LOGIC;
    x0             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    y0             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    a0             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    xn             : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    yn             : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    an             : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    ld_data_valid  : IN STD_LOGIC;
    iter_count     : IN STD_LOGIC_VECTOR(LOGITER-1 DOWNTO 0);
    freeze_regs    : IN STD_LOGIC;
    aRom           : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0)   );
END ENTITY cordic_word_calc;

ARCHITECTURE rtl OF cordic_word_calc IS
  SIGNAL XshiftOut : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL YshiftOut : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL d         : STD_LOGIC;
  SIGNAL xni       : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL yni       : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL ani       : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
BEGIN
  xn <= xni;
  yn <= yni;
  an <= ani;

  XshiftOut <= rightShiftA ( yni, to_integer(unsigned(iter_count)) );
  YshiftOut <= rightShiftA ( xni, to_integer(unsigned(iter_count)) );
  d <= NOT(yni(DP_BITS-1)) WHEN (MODE_VECTOR /= 0) ELSE ani(DP_BITS-1);

  PROCESS (clk, nGrst)
  BEGIN
    IF (nGrst = '0') THEN
      ani <= (others=>'0');
      xni <= (others=>'0');
      yni <= (others=>'0');
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (clkEn = '1') THEN
        IF (rst = '1') THEN
          ani <= (others=>'0');
          xni <= (others=>'0');
          yni <= (others=>'0');
        ELSIF (ld_data_valid = '1') THEN
          ani <= a0;
          xni <= x0;
          yni <= y0;
        ELSIF (freeze_regs = '1') THEN
          IF (d = '1') THEN
            ani <= std_logic_vector(signed(ani) + signed(aRom));
            xni <= std_logic_vector(signed(xni) + signed(XshiftOut));
            yni <= std_logic_vector(signed(yni) - signed(YshiftOut));
          ELSE
            ani <= std_logic_vector(signed(ani) - signed(aRom));
            xni <= std_logic_vector(signed(xni) - signed(XshiftOut));
            yni <= std_logic_vector(signed(yni) + signed(YshiftOut));
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE rtl;



LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.cordic_rtl_pack.all;

ENTITY cordic_par_calc IS
  GENERIC (  MODE_VECTOR    : INTEGER := 0;
             DP_BITS        : INTEGER := 48;
             LOGITER        : INTEGER := 6;
             ITER_NUM       : INTEGER := 1   );
  PORT (
    clk            : IN STD_LOGIC;
    nGrst          : IN STD_LOGIC;
    rst            : IN STD_LOGIC;
    clkEn          : IN STD_LOGIC;
    x0             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    y0             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    a0             : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    xn             : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    yn             : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    an             : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
    aRom           : IN STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0)   );
END ENTITY cordic_par_calc;

ARCHITECTURE rtl OF cordic_par_calc IS
  SIGNAL XshiftOut : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL YshiftOut : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL d         : STD_LOGIC;
  SIGNAL xni       : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL yni       : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
  SIGNAL ani       : STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0);
BEGIN
  xn <= xni;
  yn <= yni;
  an <= ani;

  XshiftOut <= rightShiftA ( y0, ITER_NUM);
  YshiftOut <= rightShiftA ( x0, ITER_NUM);
  d <= NOT(y0(DP_BITS-1)) WHEN (MODE_VECTOR /= 0) ELSE a0(DP_BITS-1);

  PROCESS (clk, nGrst)
  BEGIN
    IF (nGrst = '0') THEN
      ani <= (others=>'0');
      xni <= (others=>'0');
      yni <= (others=>'0');
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (clkEn = '1') THEN
        IF (rst = '1') THEN
          ani <= (others=>'0');
          xni <= (others=>'0');
          yni <= (others=>'0');
        ELSE
          IF (d = '1') THEN
            ani <= std_logic_vector(signed(a0) + signed(aRom));
            xni <= std_logic_vector(signed(x0) + signed(XshiftOut));
            yni <= std_logic_vector(signed(y0) - signed(YshiftOut));
          ELSE
            ani <= std_logic_vector(signed(a0) - signed(aRom));
            xni <= std_logic_vector(signed(x0) - signed(XshiftOut));
            yni <= std_logic_vector(signed(y0) + signed(YshiftOut));
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE rtl;


