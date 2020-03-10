--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation. All rights reserved.
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description:  CoreCIC
--              CIC Interpolator RTL
--
--Revision Information:
--Date         Description
--20Jun2014    Initial Release
--
--SVN Revision Information:
--SVN $Revision:
--SVN $Data: $
--
--Resolved SARs
--SAR     Date    Who         Description
--
--Notes:
--
-- BEHAVIORAL PACKAGE of Non-synthesizable units.  Use in a testbench

library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE std.textio.all;
USE ieee.numeric_std.all;
------------------------------------------------------------
PACKAGE bhv_pack IS
  FUNCTION to_logic_bhv   ( x : integer) return std_logic;
  FUNCTION to_logic_bhv   ( x : boolean) return std_logic;
  FUNCTION to_integer_bhv ( sig : std_logic_vector) return integer;
  function to_integer_bhv ( x : boolean) return integer;
  FUNCTION reductionOr_bhv (x: std_logic_vector) RETURN std_logic;

  -- convert std_logic to std_logic_vector and back
  FUNCTION vectorize_bhv (s: std_logic)        return std_logic_vector;
  FUNCTION vectorize_bhv (v: std_logic_vector) return std_logic_vector;
  FUNCTION scalarize_bhv (v: in std_logic_vector) return std_logic;

  FUNCTION MAX (A, B: INTEGER) return INTEGER;
  PROCEDURE print(text: string);
  -- convert integer to string using specified base
  FUNCTION str(int: integer; base: integer) RETURN string;
  FUNCTION str(int: integer) RETURN string;
  FUNCTION to_char( x : INTEGER range 0 to 15) RETURN character;
  function intMux_bhv (a, b : integer; sel : boolean ) return integer;
  function intMux3_bhv (a, b, c : integer; sel : integer ) return integer;
  function ceil_log2_bhv (N : positive) return natural;
  function ceil_log3_bhv (N : positive) return natural;
  function sign_ext_bhv (inp: std_logic_vector; OUTWIDTH, UNSIGN: natural)
            return std_logic_vector;

--  -- check if the difference btw two std_logic_vectors <= threshold
--  FUNCTION unequal (x1, x2 : std_logic_vector; threshold : NATURAL)
--                    RETURN Boolean;

  COMPONENT bhvClockGen
    GENERIC (CLKPERIOD   : delay_length := 20 ns;
             NGRSTLASTS  : delay_length := 24 ns  );
    PORT (halt    :  IN std_logic;
      clk, nGrst  : OUT std_logic;
      rst, rstn   : OUT std_logic   );
  END COMPONENT;

  COMPONENT bhvClkGen
    GENERIC (
      CLKPERIOD   : delay_length := 20 ns;
      NGRSTLASTS  : delay_length := 24 ns;
      RST_DLY     : integer := 10  );
    PORT (halt    :  IN std_logic;
      clk, nGrst  : OUT std_logic;
      rst         : OUT std_logic     );
  END COMPONENT;

  COMPONENT bhvCounter
    GENERIC(
      WIDTH: positive := 16;
      UPDOWN: natural := 2    );
    PORT (nGrst, rst, clk, clkEn, up, ld : in std_logic;
          din: in natural;
          Q  : out natural   );
  END COMPONENT;

  COMPONENT bhvDelay
    GENERIC ( DELAY:     integer := 2  );
    PORT    ( nGrst, rst, clk : in std_logic;
              inp : in integer;
              outp: out integer );
  END COMPONENT;

  COMPONENT bhv_kitDelay_bit_reg
    GENERIC(DELAY:     integer := 2  );
    PORT (nGrst, rst, clk, clkEn : in std_logic;
          inp : in std_logic;
          outp: out std_logic );
  END COMPONENT;

  COMPONENT bhv_kitDelay_reg
    GENERIC(
      WIDTH : integer := 16;
      DELAY:     integer := 2  );
    PORT (nGrst, rst, clk, clkEn : in std_logic;
      inp : in std_logic_vector(WIDTH-1 DOWNTO 0);
      outp: out std_logic_vector(WIDTH-1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT bhvCountS IS
    GENERIC ( WIDTH         : INTEGER := 16;
              DCVALUE       : INTEGER := 1;		-- state to decode
              BUILD_DC      : INTEGER := 1  );
    PORT (nGrst, rst, clk, clkEn, cntEn : IN STD_LOGIC;
      Q             : OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
      dc            : OUT STD_LOGIC   );		-- decoder output
  END COMPONENT;

  COMPONENT bhvEdge
    GENERIC ( REDGE : INTEGER := 1	); -- 1-rising edge, or 0-falling edge
    PORT (  nGrst, rst, clk, inp  : IN STD_LOGIC;
            outp                  : OUT STD_LOGIC );
  END COMPONENT;

  -- ------------------------------------------------------------------------
  -- Synchronize two same-clk-domain pulses, whose clkEn are different
  -- inp              ____|______________________
  -- receiver_clkEn   _|______|______|_____|_____
  --                           ______
  -- outp             ________|      |___________
  --
  COMPONENT bhv_fEdge_ce
    PORT (nGrst, rst, clk, inp, receiver_clkEn  : IN STD_LOGIC;
          outp                                  : OUT STD_LOGIC );
  END COMPONENT;

  COMPONENT bhv_lfsr
    generic ( WIDTH: integer;
              LNGTH: integer );
    port(
      nGrst, rst, clk, clkEn, start :  in std_logic;
      term                          : out std_logic;
      outp  : out std_logic_vector (WIDTH-1 downto 0)   );
  end COMPONENT;

  COMPONENT bhv_dirac
    GENERIC ( WIDTH   : integer := 8;
              AMPL    : integer := 0;		-- 0-amplitude=1; 1-ampl=2^(WIDTH-1)
              LNGTH   : integer := 100    );
    PORT (nGrst, rst, clk, clkEn, start  : IN STD_LOGIC;
          outp  : OUT std_logic_vector(WIDTH-1 downto 0);
          term  : OUT std_logic );  -- terminate a particular test sequence
  END COMPONENT;

  COMPONENT bhv_step
    GENERIC ( WIDTH     : INTEGER := 8;
              AMPL      : INTEGER := 0;		-- 0-amplitude=1; 1-ampl=2^(WIDTH-1)
              NEG_AMPL  : INTEGER := 0;		-- negative amplitude
              LNGTH     : INTEGER := 100  );
    PORT (nGrst, rst, clk, clkEn, start  : IN STD_LOGIC;
          outp  : OUT std_logic_vector(WIDTH-1 downto 0);
          term  : OUT std_logic );  -- terminate a particular test sequence
  END COMPONENT;


  COMPONENT bhv_gen
    GENERIC ( KIND      : INTEGER := 0;		--0-Dirac, 1-step, 2-random
              WIDTH     : INTEGER := 8;
              AMPL      : INTEGER := 0;		-- 0-amplitude=1; 1-ampl=2^(WIDTH-1)
              LNGTH     : INTEGER := 100;
              NEG_AMPL  : INTEGER := 0  );		-- negative amplitude
    PORT (nGrst, rst, clk, clkEn, start  : IN STD_LOGIC;
          outp  : OUT std_logic_vector(WIDTH-1 downto 0);
          term  : OUT std_logic );  -- terminate a particular test sequence
  END COMPONENT;

  COMPONENT bhv_reload_coef_arr IS
    GENERIC ( COEF_WIDTH  : INTEGER := 8;
              TAPS        : INTEGER := 100      );
    PORT (
      set       :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      coef_flat : OUT STD_LOGIC_VECTOR(TAPS*COEF_WIDTH-1 DOWNTO 0)  );
  END COMPONENT;

  COMPONENT bhv_coef_gen IS
    GENERIC ( TAPS        : INTEGER := 100;
              COEF_WIDTH  : INTEGER := 12;
              COEF_SETS   : INTEGER := 1;
              COEF_TYPE   : INTEGER := 0 );   -- 1: reloadable
    PORT (nGrst, rst, clk, clkEn, start  : IN STD_LOGIC;
          coef  : OUT STD_LOGIC_VECTOR(COEF_WIDTH-1 DOWNTO 0);
          term, coef_valid  : OUT std_logic );  -- terminate test sequence
  END COMPONENT;


  COMPONENT bhvCrossClk IS
    PORT    ( nGrst      :  IN std_logic;
              destin_clk :  IN std_logic;
              inp        :  IN std_logic;
              outp       : OUT std_logic );
  END COMPONENT;


END bhv_pack; ----------------------------------------------- END bhv_pack

PACKAGE BODY bhv_pack IS  ----------------------------------- pack body

  FUNCTION to_logic_bhv ( x : boolean) return std_logic is
    variable y : std_logic;
  begin
    if x then
      y := '1';
    else
      y := '0';
    end if;
    return(y);
  end to_logic_bhv;

  FUNCTION to_logic_bhv ( x : integer) return std_logic is
  variable y  : std_logic;
  begin
    if x = 0 then
      y := '0';
    else
      y := '1';
    end if;
    return y;
  end to_logic_bhv;

  FUNCTION to_integer_bhv (sig : std_logic_vector) return integer is
    variable num : integer := 0;  -- descending sig as integer
  begin
    for i in sig'range loop
      if sig(i)='1' then
        num := num*2+1;
      else  -- take anything other than '1' as '0'
        num := num*2;
      end if;
    end loop;  -- i
    return num;
  end function to_integer_bhv;


  FUNCTION to_integer_bhv( x : boolean) return integer is
    variable y : integer;
  BEGIN
    if x then
      y := 1;
    else
      y := 0;
    end if;
    return(y);
  END to_integer_bhv;

  FUNCTION reductionOr_bhv (x: std_logic_vector) RETURN std_logic IS
    VARIABLE r: std_logic := '0';
    BEGIN
      FOR i IN x'range LOOP
        r := r OR x(i);
      END LOOP;
      RETURN r;
  END FUNCTION reductionOr_bhv;

  -- Convert std_logic to std_logic_vector(0 downto 0) and back
  FUNCTION vectorize_bhv(s: std_logic) return std_logic_vector is
    variable v: std_logic_vector(0 downto 0);
  BEGIN
    v(0) := s;
    return v;
  END;


  FUNCTION vectorize_bhv(v: std_logic_vector) return std_logic_vector is
  BEGIN
    return v;
  END;


  -- scalarize returns an LSB
  FUNCTION scalarize_bhv(v: in std_logic_vector) return std_logic is
  BEGIN
    --assert v'length = 1
    --report "scalarize: output port must be single bit!"
    --severity FAILURE;
    return v(v'LEFT);
  END;


  FUNCTION MAX (A, B: INTEGER) return INTEGER is
  begin
    if A > B then return A;
    else return B;
    end if;
  end MAX;

  FUNCTION to_int_bhv( x : boolean) return integer is
    variable y : integer;
  BEGIN
    if x then
      y := 1;
    else
      y := 0;
    end if;
    return(y);
  END to_int_bhv;

  FUNCTION to_char( x : INTEGER range 0 to 15) RETURN character IS
    BEGIN
      CASE x IS
        WHEN 0 => RETURN('0');
        WHEN 1 => RETURN('1');
        WHEN 2 => RETURN('2');
        WHEN 3 => RETURN('3');
        WHEN 4 => RETURN('4');
        WHEN 5 => RETURN('5');
        WHEN 6 => RETURN('6');
        WHEN 7 => RETURN('7');
        WHEN 8 => RETURN('8');
        WHEN 9 => RETURN('9');
        WHEN 10 => RETURN('A');
        WHEN 11 => RETURN('B');
        WHEN 12 => RETURN('C');
        WHEN 13 => RETURN('D');
        WHEN 14 => RETURN('E');
        WHEN 15 => RETURN('F');
      END CASE;
  END to_char;

  -- (adapted from Steve Vogwell's posting on comp.lang.vhdl)
  FUNCTION str(int: integer; base: integer) RETURN string is
    VARIABLE temp:      string(1 to 10);
    VARIABLE num:       integer;
    VARIABLE abs_int:   integer;
    VARIABLE len:       integer := 1;
    VARIABLE power:     integer := 1;

    BEGIN
    abs_int := ABS(int);
    num     := abs_int;
    WHILE num >= base LOOP                     -- Determine how many
      len := len + 1;                          -- characters required
      num := num / base;                       -- to represent the
    END LOOP;                                  -- number.

    FOR i IN len DOWNTO 1 LOOP                 -- Convert the number to
      temp(i) := to_char(abs_int/power mod base);  -- a string starting
      power := power * base;                   -- with the right hand
    END LOOP;                                  -- side.
    -- RETURN result and add sign if required
    IF int < 0 THEN
       RETURN '-'& temp(1 to len);
     ELSE
       RETURN temp(1 to len);
    END IF;
  END str;

  -- convert base 10 integer to string
  FUNCTION str(int: integer) RETURN string IS
    BEGIN
      RETURN str(int, 10) ;
   END str;


  PROCEDURE print(text: string) IS
    VARIABLE msg_line: line;
    BEGIN
      write(msg_line, text);
      writeline(output, msg_line);
  END print;

  -- integer mux
  function intMux_bhv (a, b : integer; sel : boolean ) return integer is
    variable tmp: integer;
  begin
    IF (sel=False) THEN tmp := a;
    ELSE tmp := b;
    END IF;
    return tmp;
  end intMux_bhv;

  function intMux3_bhv (a, b, c : integer; sel : integer ) return integer is
    variable tmp: integer;
  begin
    IF    (sel=2) THEN tmp := c;
    ELSIF (sel=1) THEN tmp := b;
    ELSE               tmp := a;
    END IF;
    return tmp;
  end intMux3_bhv;

  -- Log2
  function ceil_log2_bhv (N : positive) return natural is
    variable tmp, res : integer;
  begin
    tmp:=1 ;
    res:=0;
    WHILE tmp < N LOOP
      tmp := tmp*2;
      res := res+1;
    END LOOP;
    return res;
  end ceil_log2_bhv;

  -- Log3
  function ceil_log3_bhv (N : positive) return natural is
    variable tmp, res : integer;
  begin
    tmp:=1 ;
    res:=0;
    WHILE tmp < N LOOP
      tmp := tmp*3;
      res := res+1;
    END LOOP;
    return res;
  end ceil_log3_bhv;

--------------------
  -- Result: Resizes the vector inp to the specified size.
  -- To create a larger vector, the new [leftmost] bit positions are filled
  -- with the sign bit (if UNSIGNED==0) or 0's (if UNSIGNED==1).
  -- When truncating, the sign bit is retained along with the rightmost part
  -- (if UNSIGNED==0), or the leftmost bits are all dropped (if UNSIGNED==1)
  function sign_ext_bhv (inp: std_logic_vector; OUTWIDTH, UNSIGN: natural)
            return std_logic_vector IS
    constant INWIDTH: INTEGER := inp'LENGTH;
    variable outp_s : signed  (OUTWIDTH-1 downto 0);
    variable outp_u : unsigned(OUTWIDTH-1 downto 0);
    variable res: STD_LOGIC_VECTOR(OUTWIDTH-1 downto 0);
  begin
    outp_s := RESIZE (signed(inp), OUTWIDTH);
    outp_u := RESIZE (unsigned(inp), OUTWIDTH);
    if UNSIGN=0 then res := std_logic_vector(outp_s);
    else             res := std_logic_vector(outp_u);
    end if;
    return res;
  end sign_ext_bhv;


-------------------------
--  FUNCTION unequal (x1, x2 : std_logic_vector; threshold : NATURAL)
--                    RETURN Boolean IS
--    CONSTANT INP_LENGTH: integer := x1'LENGTH;
--    VARIABLE absDiff : natural;
--    VARIABLE result  : Boolean;
--
--    BEGIN
--      IF (INP_LENGTH /= x2'LENGTH) THEN RETURN True;
--      ELSE
--        absDiff := ABS( to_integer(signed(x1) - signed(x1)) );
--        result  := absDiff > threshold;
--      END IF;
--      RETURN result;
--  END FUNCTION unequal;
-----------------------------------------------------------------------------
END bhv_pack;
