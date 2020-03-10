-- ***************************************************************************/
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation. All rights reserved.
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description:  User Test Bench
--              Generic behavioral modules
--
--Revision Information:
--Date         Description
--28Feb2014    Initial Release
--
--SVN Revision Information:
--SVN $Revision: $
--SVN $Data: $
--
--Resolved SARs
--SAR     Date    Who         Description
--
--Notes:
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY bhvDelay IS
  GENERIC ( DELAY : natural := 2  );
  PORT    ( nGrst, rst, clk : in std_logic;
            inp : in natural;
            outp: out natural );
END ENTITY bhvDelay;

ARCHITECTURE bhv of bhvDelay IS
  TYPE dlyArray IS ARRAY (0 to DELAY) of integer;
  -- initialize delay line
  SIGNAL delayLine : dlyArray := (OTHERS => 0);
BEGIN
  outp <= inp WHEN DELAY=0 ELSE
          delayLine(DELAY-1);

  PROCESS (clk, nGrst)
  BEGIN
    IF (NOT nGrst = '1') THEN
      FOR i IN DELAY DOWNTO 0 LOOP
        delayLine(i) <= 0;
      END LOOP;
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst='1') THEN
        FOR i IN DELAY DOWNTO 0 LOOP
          delayLine(i) <= 0;
        END LOOP;
      ELSE
        FOR i IN DELAY DOWNTO 1 LOOP
          delayline(i) <= delayline(i-1);
        END LOOP;
        delayline(0) <= inp;
      END IF;  -- rst/clkEn
    END IF;
  END PROCESS;
END ARCHITECTURE bhv;



------------ Register-based Multi-bit Delay has only input and output ----------
LIBRARY IEEE;
  USE IEEE.std_logic_1164.all;
  USE IEEE.numeric_std.all;
USE work.bhv_pack.all;

ENTITY bhv_kitDelay_reg IS
  GENERIC(
    WIDTH : integer := 16;
    DELAY:     integer := 2  );
  PORT (nGrst, rst, clk, clkEn : in std_logic;
        inp : in std_logic_vector(WIDTH-1 DOWNTO 0);
        outp: out std_logic_vector(WIDTH-1 DOWNTO 0) );
END ENTITY bhv_kitDelay_reg;

ARCHITECTURE bhv of bhv_kitDelay_reg IS
  CONSTANT DLY_INT : integer := intMux_bhv (0, DELAY-1, (DELAY>0));
  TYPE dlyArray IS ARRAY (0 to DLY_INT) of std_logic_vector(WIDTH-1 DOWNTO 0);
  -- initialize delay line
  SIGNAL delayLine : dlyArray := (OTHERS => std_logic_vector(to_unsigned(0, WIDTH)));
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
        delayLine(i) <= std_logic_vector( to_unsigned(0, WIDTH));
      END LOOP;
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst='1') THEN
        FOR i IN DLY_INT DOWNTO 0 LOOP
          delayLine(i) <= std_logic_vector( to_unsigned(0, WIDTH));
        END LOOP;
      ELSIF (clkEn = '1') THEN
        FOR i IN DLY_INT DOWNTO 1 LOOP
          delayline(i) <= delayline(i-1);
        END LOOP;
        delayline(0) <= inp;
      END IF;  -- rst/clkEn
    END IF;
  END PROCESS;
END ARCHITECTURE bhv;



LIBRARY ieee;
  USE ieee.std_logic_1164.all;
  USE ieee.std_logic_unsigned.all;
USE work.bhv_pack.all;

ENTITY bhv_kitDelay_bit_reg IS
  GENERIC (
    DELAY         : INTEGER := 2  );
  PORT (
    nGrst         : IN STD_LOGIC;
    rst           : IN STD_LOGIC;
    clk           : IN STD_LOGIC;
    clkEn         : IN STD_LOGIC;
    inp           : IN STD_LOGIC;
    outp          : OUT STD_LOGIC  );
END ENTITY bhv_kitDelay_bit_reg;

ARCHITECTURE bhv OF bhv_kitDelay_bit_reg IS
  CONSTANT DLY_INT : integer := intMux_bhv (0, DELAY-1, (DELAY>0));
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
END ARCHITECTURE bhv;


------------------------------- CLOCK GENERATOR --------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY bhvClockGen IS
  GENERIC (
    CLKPERIOD   : delay_length := 20 ns;
    NGRSTLASTS  : delay_length := 24 ns  );
  PORT (halt    :  IN std_logic;
    clk, nGrst  : OUT std_logic;
    rst         : OUT std_logic;
    rstn        : OUT std_logic     );
END bhvClockGen;

ARCHITECTURE behav OF bhvClockGen IS
  SIGNAL clk_w : std_logic := '0';
  SIGNAL nGrst_w : std_logic := '0';
  SIGNAL nGrst_tick, nGrst_tick2 : std_logic := '0';

BEGIN
  clk   <= clk_w;
  nGrst <= nGrst_w;
  nGrst_w <= '1' AFTER NGRSTLASTS;
  rst   <= nGrst_tick AND NOT(nGrst_tick2);
  rstn  <= NOT(nGrst_tick) OR nGrst_tick2;

  PROCESS
    BEGIN
      clk_w <= '0', '1' AFTER CLKPERIOD/2;
      LOOP
        IF (halt='1') THEN WAIT;
        ELSE
          clk_w <= '0', '1' AFTER CLKPERIOD/2;
          WAIT FOR CLKPERIOD;
        END IF;
      END LOOP;
  END PROCESS;

  PROCESS (clk_w)
  BEGIN
    IF (clk_w'EVENT AND clk_w = '1') THEN
      nGrst_tick  <= nGrst_w;
      nGrst_tick2 <= nGrst_tick;
    END IF;
  END PROCESS;
END ARCHITECTURE behav;



--4/23/2015 start
-- generate clock, rst and nGrst.  nGrst is longer than a clock period.
-- clk only starts after nGrst ends
LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.all;
USE work.bhv_pack.all;

ENTITY bhvClkGen IS
  GENERIC (
    CLKPERIOD   : delay_length := 20 ns;
    NGRSTLASTS  : delay_length := 24 ns;
    RST_DLY     : integer := 10  );
  PORT (halt    :  IN std_logic;
    clk, nGrst  : OUT std_logic;
    rst         : OUT std_logic     );
END bhvClkGen;

ARCHITECTURE behav OF bhvClkGen IS
  SIGNAL clki : std_logic := '0';
  SIGNAL nGrst_w : std_logic := '0';
  SIGNAL nGrst_tick, nGrst_tick2 : std_logic := '0';
  SIGNAL rsti  : std_logic; 

BEGIN
  clk   <= clki AND nGrst_w;
  nGrst <= nGrst_w;
  nGrst_w <= '1' AFTER NGRSTLASTS;
  rsti   <= nGrst_tick AND NOT(nGrst_tick2);

  PROCESS
    BEGIN
      clki <= '0', '1' AFTER CLKPERIOD/2;
      LOOP
        IF (halt='1') THEN WAIT;
        ELSE
          clki <= '0', '1' AFTER CLKPERIOD/2;
          WAIT FOR CLKPERIOD;
        END IF;
      END LOOP;
  END PROCESS;

  PROCESS (clki)
  BEGIN
    IF (clki'EVENT AND clki = '1') THEN
      nGrst_tick  <= nGrst_w;
      nGrst_tick2 <= nGrst_tick;
    END IF;
  END PROCESS;

  dly_0 : bhv_kitDelay_bit_reg
    GENERIC MAP( DELAY => RST_DLY )
    PORT MAP( nGrst => nGrst_w, clkEn => '1',
      rst => '0', clk => clki, 
      inp => rsti,  outp => rst );

END ARCHITECTURE behav;
--4/23/2015 end



------------------------------------ Pulse edge detector
LIBRARY ieee;
  USE ieee.std_logic_1164.all;

ENTITY bhvEdge IS
  GENERIC ( REDGE : INTEGER := 1	);	  -- 1 - rising edge, or 0 - falling edge
  PORT (  nGrst, rst, clk, inp  : IN STD_LOGIC;
          outp                  : OUT STD_LOGIC );
END ENTITY bhvEdge;

ARCHITECTURE bhv OF bhvEdge IS
  SIGNAL inp_tick        : STD_LOGIC;
  SIGNAL rise_edge       : STD_LOGIC;
  SIGNAL fall_edge       : STD_LOGIC;

BEGIN
  rise_edge <= inp AND NOT(inp_tick);
  fall_edge <= NOT(inp) AND inp_tick;
  outp <= fall_edge WHEN REDGE=0 ELSE rise_edge;

  PROCESS (clk, nGrst)
  BEGIN
    IF ((NOT(nGrst)) = '1') THEN
      inp_tick <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') THEN inp_tick <= '0';
      ELSE                inp_tick <= inp;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE bhv;



-- simple incremental counter
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.bhv_pack.all;

ENTITY bhvCountS IS
  GENERIC ( WIDTH         : INTEGER := 16;
            DCVALUE       : INTEGER := 1;		-- state to decode
            BUILD_DC      : INTEGER := 1  );
  PORT (nGrst, rst, clk, clkEn, cntEn : IN STD_LOGIC;
    Q             : OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    dc            : OUT STD_LOGIC   );		-- decoder output
END ENTITY bhvCountS;

ARCHITECTURE bhv OF bhvCountS IS
  SIGNAL count  : unsigned(WIDTH-1 DOWNTO 0);
BEGIN
  Q <= std_logic_vector(count);
  dc <= to_logic_bhv(count = DCVALUE) WHEN (BUILD_DC = 1) ELSE 'X';

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
END ARCHITECTURE bhv;




