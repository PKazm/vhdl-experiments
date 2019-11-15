-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  instructram.vhd
--
-- Description: Simple APB Bus Controller
--              Contains the Instruction storage RAM blocks
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 16742 $
-- SVN $Date: 2012-04-13 00:26:17 +0100 (Fri, 13 Apr 2012) $
--
-- Notes:
-- SAR60966: Write not gated with INITDATAVAL
--
-- *********************************************************************/

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library COREABC_LIB;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_support.all;


entity COREABC_C0_COREABC_C0_0_INSTRUCTRAM is
  generic ( AWIDTH    : integer range 1 to 16;
            DWIDTH    : integer range 8 to 32;
            SWIDTH    : integer range 0 to 4;
            ICWIDTH   : integer range 1 to 16;
            ICDEPTH   : integer range 1 to 65536;
            IWWIDTH   : integer range 1 to 64;
            INITWIDTH : integer range 1 to 16;
            TESTMODE  : integer range 0 to 99;
            IMEM_APB_ACCESS : integer range 0 to 2;
            UNIQ_STRING_LENGTH : integer range 1 to 256 := 10
           );
  port(    CLK           : in  std_logic;
           RSTN          : in  std_logic;
           INITDATVAL    : in  std_logic;
           INITDONE      : in  std_logic;
           INITADDR      : in  std_logic_vector(INITWIDTH-1 downto 0);
           INITDATA      : in  std_logic_vector(8 downto 0);
           ADDRESS       : in  std_logic_vector(ICWIDTH-1 downto 0);
           INSTRUCTION   : out std_logic_vector(IWWIDTH-1 downto 0);
           PSEL          : in  std_logic;
           PENABLE       : in  std_logic;
           PWRITE        : in  std_logic;
           PADDR         : in  std_logic_vector(AWIDTH-1 downto 0);
           PWDATA        : in  std_logic_vector(DWIDTH-1 downto 0);
           PRDATA        : out std_logic_vector(DWIDTH-1 downto 0);
           PSLVERR       : out std_logic;
           PREADY        : out std_logic
          );
end COREABC_C0_COREABC_C0_0_INSTRUCTRAM;


architecture RTL of COREABC_C0_COREABC_C0_0_INSTRUCTRAM is

constant AW : integer := AWIDTH;
constant DW : integer := DWIDTH;
constant SW : integer := max1(SWIDTH,1);
constant IW : integer := ICWIDTH;

constant RAMDEPTH : integer := 2**ICWIDTH;
constant RAMWIDTH : integer := AW+DW+SW+6;

constant NROWS : integer := 1+ (RAMDEPTH-1)/512 ;
constant NCOLS : integer := 1+ (RAMWIDTH-1)/9 ;

signal TADDRESS   : std_logic_vector(15 downto 0);
signal RDATA      : std_logic_vector(9*NCOLS-1 downto 0);

subtype RWORD     is std_logic_vector (9*NCOLS-1 downto 0);
type TDATAMUX     is array ( INTEGER range 0 to NROWS-1) of RWORD;
signal RDATAX     : TDATAMUX;

signal RENABLE    : std_logic;
signal WENABLE    : std_logic_vector(NROWS*NCOLS-1 downto 0);

signal INITSEL    : std_logic_vector(63 downto 0);

signal apbsel       : std_logic_vector(63 downto 0);
signal rdata_q      : std_logic_vector(62 downto 0);
signal upper_addr   : std_logic_vector(7 downto 0);
signal ninth_bit_wr : std_logic;
signal wdata_apb    : std_logic_vector(8 downto 0);

signal WADDR        : std_logic_vector(8 downto 0);
signal WDATA        : std_logic_vector(8 downto 0);

signal Logic0 : std_logic;
signal Logic1 : std_logic;

begin

Logic0 <= '0';
Logic1 <= '1';

PSLVERR <= '0';
PREADY <= '1';

----------------------------------------------------------------------------------------------------
-- Chip Selects
--

process(INITADDR)
begin
  INITSEL <= ( others=> '0');
  for c in 0 to NCOLS-1 loop
    for r in 0 to NROWS-1 loop
	  INITSEL(r*NCOLS+c) <= to_logic(INITADDR(INITWIDTH-1 downto 9) = r*NCOLS+c );
	end loop;
  end loop;
end process;

process(PADDR, upper_addr)
begin
  apbsel <= ( others=> '0');
  for c in 0 to NCOLS-1 loop
    for r in 0 to NROWS-1 loop
	  apbsel(r*NCOLS+c) <= to_logic(upper_addr(7 downto 2) = r*NCOLS+c );
	end loop;
  end loop;
end process;


----------------------------------------------------------------------------------------------------
-- Create the Memory Blocks, no of blocks varies based on generics
-- this builds the memory from 512x9 memory blocks

   RENABLE <= not(PWRITE) when (PSEL = '1' and PADDR(7) = '0') else INITDONE;

   process(ADDRESS, PADDR, PSEL, upper_addr)
   begin
     TADDRESS <= ( others => '0');
     if (PSEL = '1') then
        TADDRESS(14 downto 0) <= upper_addr(7 downto 0) & PADDR(6 downto 0);
     else
        TADDRESS(ICWIDTH-1 downto 0) <= ADDRESS;
     end if;
   end process;

   UC: for c in 0 to NCOLS-1 generate

	  UR: for r in 0 to NROWS-1 generate

          WENABLE(r*NCOLS+c) <= apbsel(r*NCOLS+c)
                                when (PSEL = '1' and PADDR(7) = '0' and PWRITE = '1' and IMEM_APB_ACCESS = 2) else
                                not INITDONE and INITSEL (r*NCOLS+c) and INITDATVAL;
          WADDR(8 downto 0)  <= (upper_addr(1 downto 0) & PADDR(6 downto 0))
                                when (PSEL = '1' and PADDR(7) = '0' and IMEM_APB_ACCESS = 2) else
                                INITADDR(8 downto 0);
          WDATA(8 downto 0)  <= wdata_apb(8 downto 0)
                                when (PSEL = '1' and PADDR(7) = '0' and IMEM_APB_ACCESS = 2) else
                                INITDATA(8 downto 0);

          URAM: COREABC_C0_COREABC_C0_0_IRAM512x9
          generic map (
                    RID => r,
                    CID => c,
                    UNIQ_STRING_LENGTH => UNIQ_STRING_LENGTH
          )
          port map
                  (  RD            => RDATAX(r)(c*9+8 downto c*9),
                     RADDR         => TADDRESS(8 downto 0),
                     RWCLK         => CLK,
                     RESET         => RSTN,
                     WENABLE       => WENABLE(r*NCOLS+c),
                     RENABLE       => RENABLE,
                     INITADDR      => WADDR(8 downto 0),
                     INITDATA      => WDATA
                 );
        end generate;

   end generate;


   UMUX0 : if NROWS=1 generate
     RDATA <= RDATAX(0);
   end generate;

   UMUX1 : if NROWS>1 generate

    process(RDATAX,TADDRESS)
     variable INDEX : integer range 0 to NROWS-1;
     begin
        INDEX := conv_integer(TADDRESS(11 downto 9));
        RDATA <= RDATAX(INDEX);
     end process;

   end generate;


--------------------------------------------------------------------------------------------------------
-- Expand RAM output into the INSTRUCTION

process(RDATA, PSEL)
begin
  if (PSEL = '0') then
  -- Don't want INSTRUCTION to change during an APB access to RAM
    INSTRUCTION <= ( others => '-');
    INSTRUCTION(5 downto 0) <= RDATA(5 downto 0);
    if SW>0 then
      INSTRUCTION(SW-1+6 downto 6) <=  RDATA(SW-1+6 downto 6);
    end if;
    INSTRUCTION(AW-1+4+6 downto 4+6)        <=  RDATA(AW-1+SW+6 downto SW+6);
    INSTRUCTION(DW-1+16+4+6 downto 16+4+6 ) <=  RDATA(DW-1+AW+SW+6 downto AW+SW+6 );
  end if;
end process;


    --======================================================================================================
    --======================================================================================================
    --
    --  APB INTERFACE RELATED CODE (other APB related code also appears above)
    --
    --======================================================================================================
    --======================================================================================================
    process (RSTN, CLK)
    begin
        if (RSTN = '0') then
            rdata_q <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if ((PSEL = '1') and (PADDR(7) = '0') and (PWRITE = '0')) then
		      	rdata_q(9*NCOLS-1 downto 0) <= RDATA;
            end if;
        end if;
    end process;

    process (RSTN, CLK)
    begin
        if (RSTN = '0') then
            upper_addr   <= "00000000";
            ninth_bit_wr <= '0';
        elsif (CLK'event and CLK = '1') then
            if ((PSEL = '1') and (PADDR(7) = '1') and (PWRITE = '1')) then
                case PADDR(5 downto 2) is
                    when "0000" => upper_addr <= PWDATA(7 downto 0);
                    when "0001" => ninth_bit_wr <= PWDATA(0);
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- When the APB data width is 8 bits, the nine bit write data to the
    -- 512x9 RAM blocks is obtained by concatenating ninth_bit_wr with
    -- PWDATA[7:0]. Otherwise, the lower nine bits of PWDATA are simply
    -- used directly.
    process (ninth_bit_wr, PWDATA)
    begin
        if (DWIDTH = 8) then
            wdata_apb <= ninth_bit_wr & PWDATA(7 downto 0);
        else
            wdata_apb <= PWDATA(8 downto 0);
        end if;
    end process;

    -- APB read data.
    process (PADDR, RDATA, rdata_q)
    variable prdata_32 : std_logic_vector(31 downto 0);
    begin
        if (IMEM_APB_ACCESS /= 2) then
            -- APB access is read only
            PRDATA(DWIDTH-1 downto 0) <= RDATA(DWIDTH-1 downto 0);
        else
            if (PADDR(7) = '0') then
                PRDATA(DWIDTH-1 downto 0) <= RDATA(DWIDTH-1 downto 0);
            else
                prdata_32 := (others => '0');
                if (DWIDTH = 8) then
                    case (PADDR(5 downto 2)) is
                        when "0010" => prdata_32(7 downto 0) := rdata_q(15 downto 8);
                        when "0011" => prdata_32(7 downto 0) := rdata_q(23 downto 16);
                        when "0100" => prdata_32(7 downto 0) := rdata_q(31 downto 24);
                        when "0101" => prdata_32(7 downto 0) := rdata_q(39 downto 32);
                        when others => prdata_32(DWIDTH-1 downto 0) := (others => '0');
                    end case;
                elsif (DWIDTH = 16) then
                    case (PADDR(5 downto 2)) is
                        when "0010" => prdata_32(15 downto 0) := rdata_q(31 downto 16);
                        when "0011" => prdata_32(15 downto 0) := rdata_q(47 downto 32);
                        when others => prdata_32(DWIDTH-1 downto 0) := (others => '0');
                    end case;
                else
                -- DWIDTH = 32
                    case (PADDR(5 downto 2)) is
                        when "0010" => prdata_32(30 downto 0) := rdata_q(62 downto 32);
                        when others => prdata_32(DWIDTH-1 downto 0) := (others => '0');
                    end case;
                end if;
                PRDATA(DWIDTH-1 downto 0) <= prdata_32(DWIDTH-1 downto 0);
            end if;
        end if;
    end process;

end RTL;
