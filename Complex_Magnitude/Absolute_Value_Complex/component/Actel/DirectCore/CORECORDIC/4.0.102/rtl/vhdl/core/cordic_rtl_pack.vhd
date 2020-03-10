-- ***************************************************************************/
--Microsemi Corporation Proprietary and Confidential
--Copyright 2014 Microsemi Corporation. All rights reserved.
--
--ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
--ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
--IN ADVANCE IN WRITING.
--
--Description:  CoreCordic RTL
--              RTL Package
--
--Revision Information:
--Date         Description
--18Jun2014    Initial Release
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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE std.textio.all;
USE IEEE.NUMERIC_STD.all;

PACKAGE cordic_rtl_pack IS

  FUNCTION to_logic   ( x : integer) return std_logic;
  FUNCTION to_logic   ( x : boolean) return std_logic;
  FUNCTION to_integer ( sig : std_logic_vector) return integer;
  function to_integer ( x : boolean) return integer;
  FUNCTION to_signInteger ( din : std_logic_vector ) return integer;
  FUNCTION reductionAnd (x: std_logic_vector) RETURN std_logic;
  FUNCTION reductionOr (x: std_logic_vector) RETURN std_logic;
  FUNCTION reductionXor (x: std_logic_vector) RETURN std_logic;

  FUNCTION kit_resize (a:IN signed; len: IN integer) RETURN signed;
  FUNCTION kit_resize (a:IN unsigned; len: IN integer) RETURN unsigned;

  -- convert std_logic to std_logic_vector and back
  FUNCTION vectorize (s: std_logic)        return std_logic_vector;
  FUNCTION vectorize (v: std_logic_vector) return std_logic_vector;
  FUNCTION scalarize (v: in std_logic_vector) return std_logic;

  -- Shift Left Logical: leftShiftL(bbbbb, 2) = bbb00;
  FUNCTION leftShiftL (arg: STD_LOGIC_VECTOR; count: NATURAL)
                                                        RETURN STD_LOGIC_VECTOR;
  -- Shift Right Logical: rightShiftL(bbbbb, 2) = 00bbb;
  FUNCTION rightShiftL (ARG: STD_LOGIC_VECTOR; COUNT: NATURAL)
                                                        RETURN STD_LOGIC_VECTOR;
  -- Shift Right Arithmetic: rightShiftA(sbbbb, 2) = sssbb;
  FUNCTION rightShiftA (ARG: STD_LOGIC_VECTOR; COUNT: NATURAL)
                                                        RETURN STD_LOGIC_VECTOR;
  FUNCTION bit_reverse( sig : std_logic_vector; WIDTH : INTEGER)
                                                        RETURN STD_LOGIC_VECTOR;
  function ceil_log2 (N : positive) return natural;
  function ceil_log3 (N : positive) return natural;
  function antilog2 (k : natural) return positive;
  function intMux (a, b : integer; sel : boolean ) return integer;
  function intMux3 (a, b, c : integer; sel : integer ) return integer;

  function sign_ext (inp: std_logic_vector; OUTWIDTH, UNSIGN: natural)
            return std_logic_vector;
  FUNCTION binary_to_one_hot (binary : STD_LOGIC_VECTOR; binary_size : NATURAL;
                              enable : STD_LOGIC) RETURN STD_LOGIC_VECTOR;

--------------------------------------------------------------------------------

  COMPONENT cordic_kitDelay_bit_reg
    GENERIC (DELAY  : INTEGER);
    PORT (nGrst, rst, clk, clkEn, inp : IN STD_LOGIC;
      outp                            : OUT STD_LOGIC  );
  END COMPONENT;

  COMPONENT cordic_kitDelay_reg
    GENERIC ( BITWIDTH      : INTEGER;
              DELAY         : INTEGER  );
    PORT (nGrst, rst, clk, clkEn : in std_logic;
          inp : in std_logic_vector(BITWIDTH-1 DOWNTO 0);
          outp: out std_logic_vector(BITWIDTH-1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT cordic_kitCountS
    GENERIC ( WIDTH         : INTEGER := 16;
              DCVALUE       : INTEGER := 1;		-- state to decode
              BUILD_DC      : INTEGER := 1  );
    PORT (nGrst, rst, clk, clkEn, cntEn : IN STD_LOGIC;
      Q             : OUT STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
      dc            : OUT STD_LOGIC   );		-- decoder output
  END COMPONENT;

  COMPONENT cordic_kitRndUp
    GENERIC ( INWIDTH       : INTEGER := 16;
              OUTWIDTH      : INTEGER := 12;
              SYMM          : INTEGER := 1  );
    PORT (
      nGrst       : IN STD_LOGIC;
      rst         : IN STD_LOGIC;
      clk         : IN STD_LOGIC;
      datai_valid : IN STD_LOGIC;
      inp         : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
      outp        : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT cordic_kitRndSymm
    GENERIC ( INWIDTH       : INTEGER := 16;
              OUTWIDTH      : INTEGER := 12;
              SYMM          : INTEGER := 1  );
    PORT (
      nGrst       : IN STD_LOGIC;
      rst         : IN STD_LOGIC;
      clk         : IN STD_LOGIC;
      datai_valid : IN STD_LOGIC;
      inp         : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
      outp        : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT cordic_kitRndEven
    GENERIC ( INWIDTH      : INTEGER := 16;
              OUTWIDTH     : INTEGER := 12  );
    PORT (
      nGrst   : IN STD_LOGIC;
      clk     : IN STD_LOGIC;
      datai_valid  : IN STD_LOGIC;
      rst     : IN STD_LOGIC;
      inp     : IN STD_LOGIC_VECTOR(INWIDTH - 1 DOWNTO 0);
      outp    : OUT STD_LOGIC_VECTOR(OUTWIDTH - 1 DOWNTO 0) );
  END COMPONENT;

  COMPONENT cordic_kitRoundTop
    GENERIC (INWIDTH : INTEGER := 16;
      OUTWIDTH  : INTEGER := 12;
      ROUND     : INTEGER := 1;
      VALID_BIT : INTEGER := 0  );
    PORT (
      nGrst         : IN STD_LOGIC;
      rst           : IN STD_LOGIC;
      clk           : IN STD_LOGIC;
      inp           : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
      outp          : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0);
      --A bit travels side by side with data.  No interaction with rounding
      validi        : IN STD_LOGIC;
      valido        : OUT STD_LOGIC  );
  END COMPONENT;

  COMPONENT cordic_signExt
    GENERIC (
      INWIDTH   : INTEGER := 16;
      OUTWIDTH  : INTEGER := 20;
      UNSIGN    : INTEGER := 0;     -- 0-signed conversion; 1-unsigned
      DROP_MSB  : INTEGER := 0  );
    PORT (
      inp             : IN STD_LOGIC_VECTOR(INWIDTH-1 DOWNTO 0);
      outp            : OUT STD_LOGIC_VECTOR(OUTWIDTH-1 DOWNTO 0)  );
  END COMPONENT;

  COMPONENT cordic_dp_bits_trans
    GENERIC (  IN_BITS  : INTEGER := 16;
               DP_BITS : INTEGER := 0  );
    PORT ( xin, yin, ain    : IN STD_LOGIC_VECTOR(IN_BITS-1 DOWNTO 0);
           xout, yout, aout : OUT STD_LOGIC_VECTOR(DP_BITS-1 DOWNTO 0) );
  END COMPONENT;

END cordic_rtl_pack;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

PACKAGE BODY cordic_rtl_pack IS

  FUNCTION to_logic ( x : integer) return std_logic is
  variable y  : std_logic;
  begin
    if x = 0 then
      y := '0';
    else
      y := '1';
    end if;
    return y;
  end to_logic;


  FUNCTION to_logic( x : boolean) return std_logic is
    variable y : std_logic;
  begin
    if x then
      y := '1';
    else
      y := '0';
    end if;
    return(y);
  end to_logic;


  FUNCTION to_integer(sig : std_logic_vector) return integer is
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
  end function to_integer;


  FUNCTION to_signInteger ( din : std_logic_vector ) return integer is
  begin
    return to_integer(signed(din));
  end to_signInteger;


  FUNCTION to_integer( x : boolean) return integer is
    variable y : integer;
  BEGIN
    if x then
      y := 1;
    else
      y := 0;
    end if;
    return(y);
  END to_integer;


  FUNCTION reductionAnd (x: std_logic_vector) RETURN std_logic IS
    VARIABLE r: std_logic := '1';
    BEGIN
      FOR i IN x'range LOOP
        r := r AND x(i);
      END LOOP;
      RETURN r;
  END FUNCTION reductionAnd;


  FUNCTION reductionOr (x: std_logic_vector) RETURN std_logic IS
    VARIABLE r: std_logic := '0';
    BEGIN
      FOR i IN x'range LOOP
        r := r OR x(i);
      END LOOP;
      RETURN r;
  END FUNCTION reductionOr;


  FUNCTION reductionXor (x: std_logic_vector) RETURN std_logic IS
    VARIABLE r: std_logic := '0';
    BEGIN
      FOR i IN x'range LOOP
        r := r XOR x(i);
      END LOOP;
      RETURN r;
  END FUNCTION reductionXor;


  -- Result: Resizes the SIGNED vector IN to the specified size.
  --         To create a larger vector, the new [leftmost] bit positions
  --         are filled with the sign bit.
  --         When truncating, the sign bit is retained along with the MSB's
  FUNCTION kit_resize(a:IN signed; len: IN integer) RETURN signed IS
  BEGIN
    IF a'length > len then
       RETURN a(len-1+a'right DOWNTO a'right);
    ELSE
      RETURN Resize(a,len);
    END IF;
  END kit_resize;


  -- Result: Resizes the UNSIGNED vector IN to the specified size.
  --         To create a larger vector, the new [leftmost] bit positions
  --         are filled with '0'. When truncating, the leftmost bits
  --         are dropped (!)
  FUNCTION kit_resize(a:IN unsigned; len: IN integer) RETURN unsigned IS
  BEGIN
    RETURN Resize(a,len);
  END kit_resize;


  -- Convert std_logic to std_logic_vector(0 downto 0) and back
  FUNCTION vectorize(s: std_logic) return std_logic_vector is
    variable v: std_logic_vector(0 downto 0);
  BEGIN
    v(0) := s;
    return v;
  END;


  FUNCTION vectorize(v: std_logic_vector) return std_logic_vector is
  BEGIN
    return v;
  END;


  -- scalarize returns an LSB
  FUNCTION scalarize(v: in std_logic_vector) return std_logic is
  BEGIN
    --assert v'length = 1
    --report "scalarize: output port must be single bit!"
    --severity FAILURE;
    return v(v'LEFT);
  END;


  -- Shift Left Logical: leftShiftL(bbbbb, 2) = bbb00;
  FUNCTION leftShiftL (arg: STD_LOGIC_VECTOR; count: NATURAL)
                                                      return STD_LOGIC_VECTOR is
    constant ARG_L: INTEGER := ARG'LENGTH-1;
    alias XARG: STD_LOGIC_VECTOR(ARG_L downto 0) is ARG;
    variable RESULT: STD_LOGIC_VECTOR(ARG_L downto 0) := (others => '0');
  BEGIN
    if COUNT <= ARG_L then
      RESULT(ARG_L downto COUNT) := XARG(ARG_L-COUNT downto 0);
    end if;
    return RESULT;
  END leftShiftL;


-- Shift Right Logical: rightShiftL(bbbbb, 2) = 00bbb;
  FUNCTION rightShiftL (ARG: STD_LOGIC_VECTOR; COUNT: NATURAL)
                                                      return STD_LOGIC_VECTOR is
    constant ARG_L: INTEGER := ARG'LENGTH-1;
    alias XARG: STD_LOGIC_VECTOR(ARG_L downto 0) is ARG;
    variable RESULT: STD_LOGIC_VECTOR(ARG_L downto 0) := (others => '0');
  begin
    if COUNT <= ARG_L then
      RESULT(ARG_L-COUNT downto 0) := XARG(ARG_L downto COUNT);
    end if;
    return RESULT;
  end rightShiftL;


-- Shift Right Arithmetic: rightShiftA(sbbbb, 2) = sssbb;
  function rightShiftA (ARG: STD_LOGIC_VECTOR; COUNT: NATURAL)
                                                      return STD_LOGIC_VECTOR is
    constant ARG_L: INTEGER := ARG'LENGTH-1;
    alias XARG: STD_LOGIC_VECTOR(ARG_L downto 0) is ARG;
    variable RESULT: STD_LOGIC_VECTOR(ARG_L downto 0);
    variable XCOUNT: NATURAL := COUNT;
  begin
    if ((ARG'LENGTH <= 1) or (XCOUNT = 0)) then return ARG;
    else
      if (XCOUNT > ARG_L) then XCOUNT := ARG_L;
      end if;
      RESULT(ARG_L-XCOUNT downto 0) := XARG(ARG_L downto XCOUNT);
      RESULT(ARG_L downto (ARG_L - XCOUNT + 1)) := (others => XARG(ARG_L));
    end if;
    return RESULT;
  end rightShiftA;


--  FUNCTION shftRA (x    :IN std_logic_vector(WORDSIZE-1 DOWNTO 0);
--                   shft :IN integer)
--                   RETURN std_logic_vector IS
--  VARIABLE x1 : bit_vector(WORDSIZE-1 DOWNTO 0);
--  BEGIN
--    x1 := To_bitvector(x) SRA shft;
--    RETURN(To_StdLogicVector(x1) );
--  END FUNCTION shftRA;


-- Reverse bits
  FUNCTION bit_reverse( sig : std_logic_vector; WIDTH : INTEGER) return STD_LOGIC_VECTOR is
    variable reverse : std_logic_vector(WIDTH-1 DOWNTO 0);
  BEGIN
    FOR i IN 0 TO WIDTH-1 LOOP
      reverse(i) := sig(WIDTH-1-i);
    END LOOP;
    return reverse;
  end function bit_reverse;


-- Log2
  function ceil_log2 (N : positive) return natural is
    variable tmp, res : integer;
  begin
    tmp:=1 ;
    res:=0;
    WHILE tmp < N LOOP
      tmp := tmp*2;
      res := res+1;
    END LOOP;
    return res;
  end ceil_log2;

  function antilog2 (k : natural) return positive is
    variable tmp, res : integer;
  begin
    tmp:=0 ;
    res:=1;
    WHILE tmp < k LOOP
      res := res*2;
      tmp := tmp+1;
    END LOOP;
    return res;
  end antilog2;

-- Log3
  function ceil_log3 (N : positive) return natural is
    variable tmp, res : integer;
  begin
    tmp:=1 ;
    res:=0;
    WHILE tmp < N LOOP
      tmp := tmp*3;
      res := res+1;
    END LOOP;
    return res;
  end ceil_log3;

-- Integer Mux: mimics a Verilog constant function sel ? b : a;
  function intMux (a, b : integer; sel : boolean ) return integer is
    variable tmp: integer;
  begin
    IF (sel=False) THEN tmp := a;
    ELSE tmp := b;
    END IF;
    return tmp;
  end intMux;

  function intMux3 (a, b, c : integer; sel : integer ) return integer is
    variable tmp: integer;
  begin
    IF    (sel=2) THEN tmp := c;
    ELSIF (sel=1) THEN tmp := b;
    ELSE               tmp := a;
    END IF;
    return tmp;
  end intMux3;

  -- Result: Resizes the vector inp to the specified size.
  -- To create a larger vector, the new [leftmost] bit positions are filled
  -- with the sign bit (if UNSIGNED==0) or 0's (if UNSIGNED==1).
  -- When truncating, the sign bit is retained along with the rightmost part
  -- (if UNSIGNED==0), or the leftmost bits are all dropped (if UNSIGNED==1)
  FUNCTION sign_ext (inp: std_logic_vector; OUTWIDTH, UNSIGN: natural)
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
  END FUNCTION;

----------------------------------------------

  FUNCTION binary_to_one_hot (
      binary      : STD_LOGIC_VECTOR ;
      binary_size : NATURAL;
      enable      : STD_LOGIC  )
    RETURN STD_LOGIC_VECTOR is
      VARIABLE indx : INTEGER := to_integer(unsigned(binary));
      VARIABLE One_Hot_Var : STD_LOGIC_VECTOR(2**binary_size-1 downto 0);
    BEGIN
      One_Hot_Var := (others => '0');
      One_Hot_Var(indx) := enable;
      RETURN One_Hot_Var;
  END FUNCTION;

END cordic_rtl_pack;
