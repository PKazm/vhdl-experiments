-- *******************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  CoreABC.vhd
--
-- Description: Simple APB Bus Controller
--              Top Level
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 28141 $
-- SVN $Date: 2016-12-08 14:34:16 +0000 (Thu, 08 Dec 2016) $
--
-- Notes:
--
-- *********************************************************************/

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

Library COREABC_LIB;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_support.all;

-- Following SARS resolved in the release 2.1
-- SAR 60727: DEBUG Cant be turned off
-- SAR 60728: Stack Pointer setting can cause ModelSim Issues
-- SAR 60730: ModelSim Simulation can fail
-- SAR 60741: Synplicity 8.5 fails to synthesize the core
-- Following SARS resolved in the release 2.2
-- SAR 63778: APB access to slots >=2
-- SAR 64208: RETURN clears INTACT
-- Following SARS resolved in the release 2.3
-- SAR 63779: Instruction Enhancements
-- SAR 64209: Ability to operate from NVM
-- Following SARS resolved in the release 2.4
-- SAR 73685: ram configuration issue in igloo


--TODO
-- Need ISR testing added to verilog code



-- Rules  IIWIDTH <= APB_DWIDTH-4
--        ZRWIDTH <= APB_DWIDTH
--        ICWIDTH <= APB_AWIDTH
--        APB_SDEPTH  = APB_SWIDTH**2


entity COREABC_C0_COREABC_C0_0_COREABC is
  generic ( FAMILY      : integer range 0 to 99    :=  0;
            APB_AWIDTH  : integer range 8 to 16    := 10;
            APB_DWIDTH  : integer range 8 to 32    :=  8;
            APB_SDEPTH  : integer range 1 to 16    :=  4;
            ICWIDTH     : integer range 1 to 16    :=  8;
            ZRWIDTH     : integer range 0 to 16    :=  8;
            IFWIDTH     : integer range 0 to 28    :=  4;
            IIWIDTH     : integer range 1 to 32    :=  4;
            IOWIDTH     : integer range 1 to 32    :=  8;
            STWIDTH     : integer range 1 to 8     :=  4;
            EN_RAM      : integer range 0 to 1     :=  1;
            EN_AND      : integer range 0 to 1     :=  1;
            EN_XOR      : integer range 0 to 1     :=  1;
            EN_OR       : integer range 0 to 1     :=  1;
            EN_ADD      : integer range 0 to 1     :=  1;
            EN_INC      : integer range 0 to 1     :=  1;
            EN_SHL      : integer range 0 to 1     :=  1;
            EN_SHR      : integer range 0 to 1     :=  1;
            EN_CALL     : integer range 0 to 1     :=  1;
            EN_PUSH     : integer range 0 to 1     :=  1;
            EN_MULT     : integer range 0 to 3     :=  0;
            EN_ACM      : integer range 0 to 1     :=  1;
            EN_DATAM    : integer range 0 to 3     :=  1;
            EN_INT      : integer range 0 to 2     :=  1;
            EN_IOREAD   : integer range 0 to 1     :=  1;
            EN_IOWRT    : integer range 0 to 1     :=  1;
            EN_ALURAM   : integer range 0 to 1     :=  1;
            EN_INDIRECT : integer range 0 to 1     :=  1;
            ISRADDR     : integer range 0 to 65535 :=  1;
            DEBUG       : integer range 0 to 1     :=  1;
            INSMODE     : integer range 0 to 2     :=  0;
            INITWIDTH   : integer range 1 to 16    :=  8;
            TESTMODE    : integer range 0 to 99    :=  0;
            ACT_CALIBRATIONDATA : integer range 0 to 1   := 1;
            IMEM_APB_ACCESS     : integer range 0 to 2   := 2;
            UNIQ_STRING_LENGTH  : integer range 1 to 256 := 10;
            MAX_NVMDWIDTH       : integer range 16 to 32 := 32
           );
  port ( PCLK        : in  std_logic;
         NSYSRESET   : in  std_logic;

         -- APB Interface
         PRESETN     : out std_logic;
         PENABLE_M   : out std_logic;
         PWRITE_M    : out std_logic;
         PSEL_M      : out std_logic;
         PADDR_M     : out std_logic_vector( 19 downto 0);
         PWDATA_M    : out std_logic_vector( APB_DWIDTH-1 downto 0);
         PRDATA_M    : in  std_logic_vector( APB_DWIDTH-1 downto 0);
         PREADY_M    : in  std_logic;
         PSLVERR_M   : in  std_logic;

         -- Misc IO
         IO_IN       : in  std_logic_vector( IIWIDTH-1 downto 0);
         IO_OUT      : out std_logic_vector( IOWIDTH-1 downto 0);

         -- Interrupt
         INTREQ      : in  std_logic;
         INTACT      : out std_logic;

         -- RAM Initialization Port
         INITDATVAL  : in  std_logic;
         INITDONE    : in  std_logic;
         INITADDR    : in  std_logic_vector(INITWIDTH-1 downto 0);
         INITDATA    : in  std_logic_vector(8 downto 0);

         -- APB slave interface
         PSEL_S      : in  std_logic;
         PENABLE_S   : in  std_logic;
         PWRITE_S    : in  std_logic;
         PADDR_S     : in  std_logic_vector(APB_AWIDTH-1 downto 0);
         PWDATA_S    : in  std_logic_vector(APB_DWIDTH-1 downto 0);
         PRDATA_S    : out std_logic_vector(APB_DWIDTH-1 downto 0);
         PSLVERR_S   : out std_logic;
         PREADY_S    : out std_logic
       );

end COREABC_C0_COREABC_C0_0_COREABC;


architecture RTL of COREABC_C0_COREABC_C0_0_COREABC is

constant IWWIDTH    : integer := 32+16+4+6;   -- =58

constant IRWIDTH    : integer := calc_irwidth(en_ram,en_call,APB_DWIDTH,icwidth);
constant ICDEPTH    : integer range 1 to 65536 := 2 ** ICWIDTH;
constant APB_SWIDTH : integer range 0 to 4 := calc_swidth(APB_SDEPTH);
constant RAMWIDTH   : integer := APB_AWIDTH+APB_DWIDTH+APB_SWIDTH+6;

signal SMADDR          : std_logic_vector(ICWIDTH-1 downto 0);
signal INSTRUCTION     : std_logic_vector(IWWIDTH-1 downto 0);

signal STKPTR          : std_logic_vector(7 downto 0);
signal STKPTRM1        : std_logic_vector(7 downto 0);
signal STKPTRP1        : std_logic_vector(7 downto 0);
signal STKPTRRW        : std_logic_vector(7 downto 0);

signal INSTR_CMD       : std_logic_vector(2 downto 0);
signal INSTR_SCMD      : std_logic_vector(2 downto 0);
signal INSTR_SLOT      : std_logic_vector(APB_SWIDTH   downto 0);    -- handles 0 bit wide case
signal INSTR_ADDR      : std_logic_vector(APB_AWIDTH-1 downto 0);
signal INSTR_DATA      : std_logic_vector(APB_DWIDTH-1 downto 0);
signal INSTR_MUXC      : std_logic;

signal ACCUMULATOR     : std_logic_vector(APB_DWIDTH-1 downto 0);
signal ACCUM_NEXT      : std_logic_vector(APB_DWIDTH-1 downto 0);
signal ALUOUT          : std_logic_vector(APB_DWIDTH-1 downto 0);
signal MUX1            : std_logic_vector(APB_DWIDTH-1 downto 0);
signal MUX2            : std_logic_vector(APB_DWIDTH-1 downto 0);
signal DATAOUT_APB     : std_logic_vector(APB_DWIDTH-1 downto 0);
signal DATAOUT_RAM     : std_logic_vector(APB_DWIDTH-1 downto 0);
signal DATAOUT_IO      : std_logic_vector(APB_DWIDTH-1 downto 0);
signal DATAOUT_DB      : std_logic_vector(APB_DWIDTH-1 downto 0);
signal DATAOUT_ZREG    : std_logic_vector(APB_DWIDTH-1 downto 0);
signal DATAOUT_ZREG_ZR : std_logic_vector(ZRWIDTH-1 downto 0);
signal PRODUCT         : std_logic_vector(APB_DWIDTH-1 downto 0);
signal USE_ACM         : std_logic;
signal USE_ACC         : std_logic;

signal ZREGISTER       : std_logic_vector(ZRWIDTH  downto 0);         -- again 1 bit to big
signal ZREG_ZERO       : std_logic;

signal STBACCUM        : std_logic;
signal STBFLAG         : std_logic;
signal STBACCAPB       : std_logic;

signal ACCUM_ZERO      : std_logic;
signal ACCUM_NEG       : std_logic;
signal STD_ACCUM_ZERO  : std_logic;
signal STD_ACCUM_NEG   : std_logic;
signal ISR_ACCUM_ZERO  : std_logic;
signal ISR_ACCUM_NEG   : std_logic;
signal FLAGS           : std_logic;
signal DOJMP           : std_logic;
signal DOISR           : std_logic;
signal SHIFTMSB        : std_logic;
signal SHIFTLSB        : std_logic;

signal PENABLEI        : std_logic;
signal PSELI           : std_logic;
signal PREADYX         : std_logic;

signal STBRAM          : std_logic;
signal READRAM         : std_logic;
signal RAMADDR         : std_logic_vector(7 downto 0);
signal RAMADDR01       : std_logic_vector(7 downto 0);
signal RAMRDATA        : std_logic_vector(IRWIDTH-1 downto 0);
signal RAMWDATA        : std_logic_vector(IRWIDTH-1 downto 0);
signal RAMDOUT         : std_logic_vector(APB_DWIDTH-1 downto 0);

signal ISR             : std_logic;
signal INTREQX         : std_logic;

signal ACMDO           : std_logic;
signal ACMDATA         : std_logic_vector(7 downto 0);

signal DEBUG1          : std_logic;
signal DEBUG2          : std_logic;
signal DEBUGBLK_RESETN : std_logic;

signal GETINST         : std_logic;
signal STALL           : std_logic;
signal NVMREADY        : std_logic;

type TICYCLE is ( CYCLE0, CYCLE1, CYCLE2, CYCLE3 );
signal ICYCLE : TICYCLE;

signal RSTSYNC1        : std_logic;
signal RSTSYNC2        : std_logic;
signal ARESETN         : std_logic;
signal SRESETN         : std_logic;


-- added for 2.2
signal MUXIR           : std_logic;
signal ACCUM_IN        : std_logic_vector(APB_DWIDTH-1 downto 0);


signal ZERO00 : std_logic_vector(31 downto 0);
signal Logic0 : std_logic;
signal Logic1 : std_logic;

signal upper_addr      : std_logic_vector(7 downto 0);
signal ADDRESS         : std_logic_vector(ICWIDTH-1 downto 0);

-- "Internal" versions of APB slave signals
signal iPSEL_S         : std_logic;
signal iPENABLE_S      : std_logic;
signal iPWRITE_S       : std_logic;
signal iPADDR_S        : std_logic_vector(APB_AWIDTH-1 downto 0);
signal iPWDATA_S       : std_logic_vector(APB_DWIDTH-1 downto 0);
signal iPRDATA_S       : std_logic_vector(APB_DWIDTH-1 downto 0);
signal iPSLVERR_S      : std_logic;
signal iPREADY_S       : std_logic;


begin

ZERO00 <= ( others => '0');
Logic0 <= '0';
Logic1 <= '1';

---------------------------------------------------------------------------------
-- Adjust for supported level of APB access to IMEM
--
    imem_apb_access_0 : if (IMEM_APB_ACCESS = 0) generate
    -- No APB access to IMEM
        iPSEL_S    <= '0';
        iPENABLE_S <= '0';
        iPWRITE_S  <= '0';
        iPADDR_S   <= (others => '0');
        iPWDATA_S  <= (others => '0');
        PRDATA_S   <= (others => '0');
        PSLVERR_S  <= '0';
        PREADY_S   <= '1';
    end generate;

    imem_apb_access_not0 : if (IMEM_APB_ACCESS /= 0) generate
        iPSEL_S    <= PSEL_S;
        iPENABLE_S <= PENABLE_S;
        iPWRITE_S  <= PWRITE_S;
        iPADDR_S   <= PADDR_S;
        iPWDATA_S  <= PWDATA_S;
        PRDATA_S   <= iPRDATA_S;
        PSLVERR_S  <= iPSLVERR_S;
        PREADY_S   <= iPREADY_S;
    end generate;

ASYNC_RESET: if FAMILY /= 25 generate
    ---------------------------------------------------------------------------------
    -- Reset Sync Circuitry
    --
    process(PCLK,NSYSRESET)
    begin
        if NSYSRESET='0' then
            RSTSYNC1 <= '0';
            RSTSYNC2 <= '0';
        elsif PCLK'event and PCLK='1' then
            RSTSYNC1 <= '1';
            RSTSYNC2 <= RSTSYNC1;
        end if;
    end process;
    PRESETN <= RSTSYNC2;
    ARESETN <= RSTSYNC2;
    SRESETN <= '1';
end generate;

SYNC_RESET: if FAMILY = 25 generate
    PRESETN <= NSYSRESET;
    ARESETN <= '1';
    SRESETN <= NSYSRESET;
end generate;


---------------------------------------------------------------------------------
-- The Optional Storage RAM
--

URAM: if EN_RAM>0 or EN_CALL>0 or EN_INT>0 or EN_PUSH>0 generate

  process(INSTR_ADDR,INSTR_CMD,INSTR_SCMD,INSTR_MUXC,DATAOUT_RAM,STKPTRRW,SMADDR,DOISR)
  begin
    RAMADDR <= ( others => '-');
    RAMWDATA<= ( others => '-');
    if (INSTR_CMD="011" or INSTR_MUXC='1') and EN_RAM>0 and DOISR='0' then
      -- Store and Load Instructions
      RAMWDATA(APB_DWIDTH-1 downto 0) <= DATAOUT_RAM;
      RAMADDR <= INSTR_ADDR(7 downto 0);
      if INSTR_CMD="011" and INSTR_SCMD(2)='1' and EN_PUSH=1 then
        RAMADDR <= STKPTRRW;
      end if;
    elsif EN_CALL>0 or EN_INT>0 then
      -- Stack Operation
      RAMADDR <= STKPTRRW;
      if EN_INT>0 and DOISR='1' then
        RAMWDATA(ICWIDTH-1 downto 0)  <= SMADDR;    -- need to return to current address
      else
        RAMWDATA(ICWIDTH-1 downto 0)  <= SMADDR+1;
      end if;
    end if;
  end process;

  -- Removes the dont cares from the address bus for simulation reasons
  process(RAMADDR)
  begin
    RAMADDR01 <= ( others => '0' );
    for i in RAMADDR'range loop
      if RAMADDR(i)='1' then
        RAMADDR01(i) <='1';
      end if;
    end loop;
  end process;

  UR: COREABC_C0_COREABC_C0_0_RAMBLOCKS
       generic map ( DWIDTH => IRWIDTH,
                     FAMILY => FAMILY)
       port map (CLK    => PCLK,
                 RESETN => ARESETN,
                 WEN    => STBRAM,
                 ADDR   => RAMADDR01,
                 WD     => RAMWDATA,
                 RD     => RAMRDATA
               ) ;

  RAMDOUT<= RAMRDATA(APB_DWIDTH-1 downto 0);

end generate;


URAM0: if EN_RAM=0 and EN_CALL=0 and EN_INT=0 and EN_PUSH=0 generate
  RAMADDR   <= ( others => '0');
  RAMWDATA  <= ( others => '0');
  RAMDOUT   <= ( others => '0');
  RAMADDR01 <= ( others => '0');
  RAMRDATA  <= ( others => '0');
end generate;



---------------------------------------------------------------------------------
-- Optional ACM lookup
--

UACM: if EN_ACM=1 generate

  UA : COREABC_C0_COREABC_C0_0_ACMTABLE
    generic map (
                TESTMODE => TESTMODE
           )
    port map (  ACMADDR => ACCUMULATOR(7 downto 0),
                ACMDATA => ACMDATA,
                ACMDO   => ACMDO
           );

end generate;

UACM0: if EN_ACM=0 generate
  ACMDATA <= ( others => '0');
  ACMDO   <= '0';
end generate;

---------------------------------------------------------------------------------
-- This is the instruction sequence ROM
--

UROM: if INSMODE=0  or (INSMODE=2 and FAMILY/=17) generate

 UROM: COREABC_C0_COREABC_C0_0_INSTRUCTIONS
   generic map ( TESTMODE => TESTMODE,
				 EN_MULT  => EN_MULT,
				 EN_INC   => EN_INC,
                 AWIDTH   => APB_AWIDTH,
                 DWIDTH   => APB_DWIDTH,
                 SWIDTH   => APB_SWIDTH,
                 ICWIDTH  => ICWIDTH,
                 IIWIDTH  => IIWIDTH,
                 IFWIDTH  => IFWIDTH,
                 IWWIDTH  => IWWIDTH )
   port map ( ADDRESS     => ADDRESS,
              INSTRUCTION => INSTRUCTION
            );

  -- in this case register for timing reasons, it also helps area
  -- This register stage does not really add any logic, it reduces fanout and makes sure that
  -- the ROM function is clearly identified by Synthesis. Removing the registers tends to
  -- increase overall area
  -- instr_slot is N+1 bits wide, should there be 1 slot then the required bitwidth is zero
  -- we always force the top bit to zero

 process(PCLK)
 begin
  if PCLK'event and PCLK='1' then
    if iPSEL_S = '0' then
      INSTR_CMD  <= INSTRUCTION(2 downto 0);
      INSTR_SCMD <= INSTRUCTION(5 downto 3);
      INSTR_SLOT <= INSTRUCTION(APB_SWIDTH +6 downto 6);
      INSTR_SLOT(APB_SWIDTH) <= '0';  -- extra bit unused
      INSTR_ADDR <= INSTRUCTION(APB_AWIDTH-1+4+6 downto 4+6);
      INSTR_DATA <= INSTRUCTION(APB_DWIDTH-1+16+4+6 downto 16+4+6 );
      INSTR_MUXC <= INSTRUCTION(6);     -- this is slot bit 0
    end if;
  end if;
 end process;

 STALL <= '0';

 -- Provide APB read access to instruction ROM.
 -- Only the lower <APB_DWIDTH> bits can be read from each instruction location.
 process (ARESETN, PCLK)
 begin
     if (ARESETN = '0') then
         upper_addr <= "00000000";
     elsif PCLK'event and PCLK = '1' then
        if (SRESETN = '0') then
            upper_addr <= "00000000";
        else
            if ((iPSEL_S = '1') and (iPWRITE_S = '1')) then
	         	upper_addr <= iPWDATA_S(7 downto 0);
            end if;
        end if;
     end if;
 end process;

 process (iPSEL_S, upper_addr, iPADDR_S, SMADDR)
 variable ins_addr : std_logic_vector(15 downto 0);
 begin
     ins_addr := (others => '0');
     if (iPSEL_S = '1') then
         ins_addr := upper_addr(7 downto 0) & iPADDR_S(7 downto 0);
     else
         ins_addr(ICWIDTH-1 downto 0) := SMADDR;
     end if;
     ADDRESS(ICWIDTH-1 downto 0) <= ins_addr(ICWIDTH-1 downto 0);
 end process;

 iPRDATA_S(APB_DWIDTH-1 downto 0) <= INSTRUCTION(APB_DWIDTH-1 downto 0);
 iPREADY_S <= '1';
 iPSLVERR_S <= '0';

end generate;


UIRAM: if INSMODE=1  generate

  UIRAM: COREABC_C0_COREABC_C0_0_INSTRUCTRAM
    generic map (
                  TESTMODE      => TESTMODE,
                  AWIDTH        => APB_AWIDTH,
                  DWIDTH        => APB_DWIDTH,
                  SWIDTH        => APB_SWIDTH,
                  ICWIDTH       => ICWIDTH,
                  ICDEPTH       => ICDEPTH,
                  IWWIDTH       => IWWIDTH,
                  INITWIDTH     => INITWIDTH,
                  IMEM_APB_ACCESS    => IMEM_APB_ACCESS,
                  UNIQ_STRING_LENGTH => UNIQ_STRING_LENGTH
                )
    port map ( CLK           => PCLK,
               RSTN          => ARESETN,
               INITDATVAL    => INITDATVAL,
               INITDONE      => INITDONE,
               INITADDR      => INITADDR,
               INITDATA      => INITDATA,
               ADDRESS       => SMADDR,
               INSTRUCTION   => INSTRUCTION,
               PSEL          => iPSEL_S,
               PENABLE       => iPENABLE_S,
               PWRITE        => iPWRITE_S,
               PADDR         => iPADDR_S,
               PWDATA        => iPWDATA_S,
               PRDATA        => iPRDATA_S,
               PSLVERR       => iPSLVERR_S,
               PREADY        => iPREADY_S
             );

   -- dont register since RAM does
   process(INSTRUCTION)
   begin
     INSTR_CMD  <= INSTRUCTION(2 downto 0);
     INSTR_SCMD <= INSTRUCTION(5 downto 3);
     INSTR_SLOT <= INSTRUCTION(APB_SWIDTH +6 downto 6);
     INSTR_SLOT(APB_SWIDTH) <= '0';  -- extra bit unused
     INSTR_ADDR <= INSTRUCTION(APB_AWIDTH-1+4+6 downto 4+6);
     INSTR_DATA <= INSTRUCTION(APB_DWIDTH-1+16+4+6 downto 16+4+6 );
     INSTR_MUXC <= INSTRUCTION(6);    -- this is slot bit 0
   end process;

   STALL <= '0';

end generate;

UINVM: if INSMODE=2 and FAMILY=17 generate

 UROM : COREABC_C0_COREABC_C0_0_INSTRUCTNVM
    generic map (
                  MAX_NVMDWIDTH => MAX_NVMDWIDTH,
                  AWIDTH        => APB_AWIDTH,
                  DWIDTH        => APB_DWIDTH,
                  SWIDTH        => APB_SWIDTH,
                  ICWIDTH       => ICWIDTH,
                  ICDEPTH       => ICDEPTH,
                  IWWIDTH       => IWWIDTH,
                  ACT_CALIBRATIONDATA => ACT_CALIBRATIONDATA,
                  IMEM_APB_ACCESS     => IMEM_APB_ACCESS,
                  UNIQ_STRING_LENGTH  => UNIQ_STRING_LENGTH
                 )
    port map (    CLK         => PCLK,
                  RSTN        => ARESETN,
                  START       => GETINST,
                  STALL       => STALL,
                  ADDRESS     => SMADDR,
                  INSTRUCTION => INSTRUCTION,
                  PSEL        => iPSEL_S,
                  PENABLE     => iPENABLE_S,
                  PWRITE      => iPWRITE_S,
                  PADDR       => iPADDR_S,
                  PWDATA      => iPWDATA_S,
                  PRDATA      => iPRDATA_S,
                  PSLVERR     => iPSLVERR_S,
                  PREADY      => iPREADY_S
                 );

   -- dont register since NVM does
   process(INSTRUCTION)
   begin
     INSTR_CMD  <= INSTRUCTION(2 downto 0);
     INSTR_SCMD <= INSTRUCTION(5 downto 3);
     INSTR_SLOT <= INSTRUCTION(APB_SWIDTH +6 downto 6);
     INSTR_SLOT(APB_SWIDTH) <= '0';  -- extra bit unused
     INSTR_ADDR <= INSTRUCTION(APB_AWIDTH-1+4+6 downto 4+6);
     INSTR_DATA <= INSTRUCTION(APB_DWIDTH-1+16+4+6 downto 16+4+6 );
     INSTR_MUXC <= INSTRUCTION(6);    -- this is slot bit 0
   end process;


end generate;


---------------------------------------------------------------------------------
-- Accumulator
--

-- Shift and Rotate Instructions
process(INSTR_DATA,ACCUMULATOR)
begin
  SHIFTMSB <= '-';
  SHIFTLSB <= '-';
  if EN_SHL=1 or EN_SHR=1 then
    case INSTR_DATA(1 downto 0) is
      when "00" => SHIFTMSB <= '0';                       SHIFTLSB <= '0';
      when "01" => SHIFTMSB <= '1';                       SHIFTLSB <= '1';
      when "10" => SHIFTMSB <= ACCUMULATOR(APB_DWIDTH-1); SHIFTLSB <= ACCUMULATOR(0);
      when "11" => SHIFTMSB <= ACCUMULATOR(0);            SHIFTLSB <= ACCUMULATOR(APB_DWIDTH-1);
    when others =>
    end case;
  end if;
end process;

-- Switch Accumulator to use RAM output if RAM read or indirect command
MUXIR <= to_logic(EN_RAM=1) and (READRAM or (to_logic(EN_ALURAM=1) and INSTR_MUXC));


process(INSTR_DATA,MUXIR,RAMDOUT)
variable tmp     : std_logic_vector(APB_DWIDTH-1 downto 0);
begin
  if MUXIR='0' then
    ACCUM_IN <= clean(INSTR_DATA);
  else
    ACCUM_IN <= clean(RAMDOUT);
  end if;
end process;


-- Optional Mult
process(ACCUMULATOR,ACCUM_IN)
variable MULT : std_logic_vector(2*APB_DWIDTH-1 downto 0);
variable A,B  : std_logic_vector(APB_DWIDTH/2-1 downto 0);
begin
 case EN_MULT is
   when 1 =>  A :=  ACCUMULATOR(APB_DWIDTH/2-1 downto 0);
              B :=  ACCUM_IN(APB_DWIDTH/2-1 downto 0);
              PRODUCT  <=  A * B;
   when 2 =>  MULT :=  ACCUMULATOR * ACCUM_IN;
              PRODUCT  <=  MULT(APB_DWIDTH-1 downto 0);
   when 3 =>  MULT :=  ACCUMULATOR * ACCUM_IN;
              PRODUCT  <=  MULT(2*APB_DWIDTH-1 downto APB_DWIDTH);
   when others => PRODUCT <= ( others => '-');
 end case;
end process;


-- The functions
process(READRAM,INSTR_SCMD,ACCUMULATOR,SHIFTMSB,SHIFTLSB,ACCUM_IN,PRODUCT)
variable MSEL : std_logic_vector(2 downto 0);
begin
  ALUOUT <= ( others => '-');
  MSEL :=  INSTR_SCMD;
  if READRAM='1' then  -- if RAM read cycle force MSEL saves a wide mux
    MSEL := "111";
  end if;
  case MSEL is
    when "000"   => if EN_INC=1 and EN_MULT=0 and (INSMODE=0 or (INSMODE=2 and FAMILY/=17)) then
                      ALUOUT <= ACCUMULATOR +   1;
                    end if;
                    if EN_MULT>=1 then
                      ALUOUT <= PRODUCT;
                    end if;
    when "001"   => if EN_AND=1 then
                      ALUOUT <= ACCUMULATOR and ACCUM_IN;
                    end if;
    when "010"   => if EN_OR=1 then
                      ALUOUT <= ACCUMULATOR or  ACCUM_IN;
                    end if;
    when "011"   => if EN_XOR=1 then
                      ALUOUT <= ACCUMULATOR xor ACCUM_IN;
                    end if;
    when "100"   => if EN_ADD=1 or (EN_INC=1 and (EN_MULT>=1 or INSMODE>0 ))  then
                      ALUOUT <= ACCUMULATOR +   ACCUM_IN;
                    end if;
    when "101"   => if EN_SHL=1 then
                      ALUOUT <= ACCUMULATOR(APB_DWIDTH-2 downto 0) & SHIFTLSB;
                    end if;
    when "110"   => if EN_SHR=1 then
                      ALUOUT <= SHIFTMSB & ACCUMULATOR(APB_DWIDTH-1 downto 1);
                    end if;
    when "111"   => ALUOUT <= ACCUM_IN;
    when others  => ALUOUT <= ( others => '-');
  end case;
end process;


process(READRAM,INSTR_CMD,ALUOUT,PRDATA_M,IO_IN)
begin
   if (EN_RAM>0 and READRAM='1') or INSTR_CMD(1)='0'  then
     ACCUM_NEXT <= ALUOUT;
   elsif EN_IOREAD=1 and INSTR_CMD(0)='1' then
     ACCUM_NEXT <= ( others => '0');
     ACCUM_NEXT(IIWIDTH-1 downto 0) <= IO_IN;
   else
     ACCUM_NEXT <= PRDATA_M(APB_DWIDTH-1 downto 0);
   end if;
end process;


-- Accumulator
process(PCLK,ARESETN)
begin
  if ARESETN='0' then
    ACCUMULATOR <= ( others => '0');
    STD_ACCUM_ZERO  <= '0';
    STD_ACCUM_NEG   <= '0';
    ISR_ACCUM_ZERO  <= '0';
    ISR_ACCUM_NEG   <= '0';
  elsif PCLK'event and PCLK='1' then
    if SRESETN = '0' then
        ACCUMULATOR <= ( others => '0');
        STD_ACCUM_ZERO  <= '0';
        STD_ACCUM_NEG   <= '0';
        ISR_ACCUM_ZERO  <= '0';
        ISR_ACCUM_NEG   <= '0';
    else
        if STBACCUM='1' or STBACCAPB='1' then
          ACCUMULATOR <= ACCUM_NEXT;
        end if;
        if ISR='0' and STBFLAG='1' then
          STD_ACCUM_ZERO <= to_logic (ACCUM_NEXT = ZERO00(APB_DWIDTH-1 downto 0));
          STD_ACCUM_NEG  <= ACCUM_NEXT(APB_DWIDTH-1);
        end if;
        if ISR='1' and STBFLAG='1' and EN_INT>0 then
          ISR_ACCUM_ZERO <= to_logic (ACCUM_NEXT = ZERO00(APB_DWIDTH-1 downto 0));
          ISR_ACCUM_NEG  <= ACCUM_NEXT(APB_DWIDTH-1);
        end if;
        if EN_INT=0 then
          ISR_ACCUM_ZERO <= '0';
          ISR_ACCUM_NEG  <= '0';
        end if;
    end if;
  end if;
end process;


ACCUM_ZERO <= ISR_ACCUM_ZERO when ISR='1' else STD_ACCUM_ZERO;
ACCUM_NEG  <= ISR_ACCUM_NEG  when ISR='1' else STD_ACCUM_NEG;

ZREG_ZERO  <= '1' when (clean(ZREGISTER) = clean(ZERO00(ZRWIDTH downto 0)) and ZRWIDTH>0) else '0';


-- Flags Selection
process( INSTR_DATA, INSTR_SCMD, IO_IN, ACCUM_NEG, ACCUM_ZERO, ZREG_ZERO)
variable flagbits  : std_logic_vector(31 downto 0);
variable flagvalue : std_logic;
begin
  flagbits := ( others => '0');
  flagbits(3 downto 0)  := ( ZREG_ZERO & ACCUM_NEG & ACCUM_ZERO & '1' );
  for i in 0 to IFWIDTH-1 loop
    flagbits(i+4) := IO_IN(i);
  end loop;
  flagvalue := '0';
  for i in 0 to IFWIDTH+4-1 loop
    flagvalue := flagvalue or (INSTR_DATA(i) and flagbits(i));
  end loop;
  FLAGS <= flagvalue xnor INSTR_SCMD(0);    -- true or not true condition
end process;


---------------------------------------------------------------------------------
-- Data Output Mux, with generic to select core options
--

process(INSTR_CMD,INSTR_SCMD,INSTR_MUXC)
begin
  USE_ACC <= '-';
  USE_ACM <= '-';
  case INSTR_CMD is
   when "010" =>  if INSTR_SCMD(0)='1' then
                    USE_ACC <= '0'; --IMMED
                    USE_ACM <= '-';
                  elsif EN_ACM=1 and INSTR_SCMD(1)='1' then
                    USE_ACC <= '1'; --ACM
                    USE_ACM <= '1';
                  else
                    USE_ACC <= '1'; --ACCUM
                    USE_ACM <= '0';
                  end if;
   when "011" =>  if INSTR_MUXC='0' then
                    USE_ACC <= '0';
                    USE_ACM <= '-';
                  else
                    USE_ACC <= '1';
                    USE_ACM <= '0';
                  end if;
   when others => USE_ACC <= '-';
                  USE_ACM <= '-';
 end case;
end process;


process(USE_ACM,ACCUMULATOR,ACMDATA)
begin
 MUX1 <= ACCUMULATOR;
 if EN_ACM=1 and USE_ACM='1' then
    MUX1(7 downto 0) <= ACMDATA;
 end if;
end process;


process(USE_ACC,INSTR_DATA,MUX1)
begin
 if USE_ACC='0' then
    MUX2 <= INSTR_DATA;
 else
    MUX2 <= MUX1;
 end if;
end process;


process(MUX1,MUX2,ACCUMULATOR,INSTR_DATA)
begin
 case EN_DATAM is
   when 0 => DATAOUT_APB  <=  MUX1;
             DATAOUT_RAM  <=  ACCUMULATOR;
             DATAOUT_ZREG <=  ACCUMULATOR;
             DATAOUT_IO   <=  ACCUMULATOR;
   when 1 => DATAOUT_APB  <=  INSTR_DATA;
             DATAOUT_RAM  <=  INSTR_DATA;
             DATAOUT_ZREG <=  INSTR_DATA;
             DATAOUT_IO   <=  INSTR_DATA;
   when 2 => DATAOUT_APB  <=  MUX2;
             DATAOUT_RAM  <=  MUX2;
             DATAOUT_ZREG <=  MUX2;
             DATAOUT_IO   <=  MUX2;
   when 3 => DATAOUT_APB  <=  MUX1;
             DATAOUT_RAM  <=  ACCUMULATOR;
             DATAOUT_ZREG <=  INSTR_DATA;
             DATAOUT_IO   <=  INSTR_DATA;
  end case;
  DATAOUT_DB <= ( others => '0');
  -- synthesis translate_off
  DATAOUT_DB <= MUX2;
  -- synthesis translate_on
end process;

-- handle case when DWIDTH<ZRWIDTH
process(DATAOUT_ZREG)
constant N : integer := min1(APB_DWIDTH,ZRWIDTH);
constant M : integer := max1(1,ZRWIDTH-1);
begin
 DATAOUT_ZREG_ZR <=	( others => DATAOUT_ZREG(APB_DWIDTH-1));
 for i in 0 to N-1 loop
   DATAOUT_ZREG_ZR(i) <= DATAOUT_ZREG(i);
 end loop;
end process;

---------------------------------------------------------------------------------
-- Instruction Engine
--

-- Encodings for INSTR_CMD:
--     0:  LOGIC
--     1:  LOGIC no accumulator update
--     2:  APB Cycle
--     3:  LOAD
--     4:  JUMP
--     5:  CALL
--     6:  RET
--     7:  RESERVED

READRAM <= to_logic(clean(INSTR_CMD)="011" and EN_RAM>0 and clean(INSTR_SCMD(2 downto 1))/="11");

process(STKPTR)
variable TSTACK : std_logic_vector(STWIDTH-1 downto 0);
begin
  TSTACK := clean(STKPTR(STWIDTH-1 downto 0));
  STKPTRM1 <= ( others => '1');
  STKPTRP1 <= ( others => '1');
  STKPTRM1(STWIDTH-1 downto 0) <= TSTACK -1;      -- helps verilog translation
  STKPTRP1(STWIDTH-1 downto 0) <= TSTACK +1;
end process;

STKPTRRW <= STKPTRP1;

INTREQX <= to_logic((INTREQ='1' and (EN_INT=1)) or ( INTREQ='0' and (EN_INT=2)));

PREADYX <= PREADY_M;

NVMREADY <= to_logic(INSMODE<=1) or not STALL;


process(PCLK,ARESETN)
begin
  if ARESETN='0' then
    PSELI     <= '0';
    PENABLEI  <= '0';
    STBFLAG   <= '0';
    STBACCUM  <= '0';
    ICYCLE    <= CYCLE3;
    DOJMP     <= '0';
    DOISR     <= '0';
    STBRAM    <= '0';
    SMADDR    <= ( others => '1');
    ZREGISTER <= ( others => '0');
    IO_OUT    <= ( others => '0');
    STKPTR    <= ( others => '1');
    ISR       <= '0';
    GETINST   <= '0';
  elsif PCLK'event and PCLK='1' then
    if SRESETN = '0' then
        PSELI     <= '0';
        PENABLEI  <= '0';
        STBFLAG   <= '0';
        STBACCUM  <= '0';
        ICYCLE    <= CYCLE3;
        DOJMP     <= '0';
        DOISR     <= '0';
        STBRAM    <= '0';
        SMADDR    <= ( others => '1');
        ZREGISTER <= ( others => '0');
        IO_OUT    <= ( others => '0');
        STKPTR    <= ( others => '1');
        ISR       <= '0';
        GETINST   <= '0';
    else
        PSELI     <= '0';
        PENABLEI  <= '0';
        STBFLAG   <= '0';
        STBACCUM  <= '0';
        STBRAM    <= '0';
        GETINST   <= '0';
        case ICYCLE is
          when CYCLE0 =>   if INITDONE='1' or INSMODE=0  or INSMODE=2 then
                               if EN_INT>0 and INTREQX='1' and ISR='0' then
                                 ISR     <= '1';
                                 STKPTR  <= STKPTRM1;
                                 DOISR   <= '1';
                                 ICYCLE  <= CYCLE1;
                                 STBRAM  <= '1';
                               else
                                 ICYCLE <= CYCLE1;
                               end if;
                           end if;
          when CYCLE1 =>
                        if NVMREADY='1' then
                         if DOISR='1' then
                           ICYCLE <= CYCLE3;
                         else
                           case INSTR_CMD is
                           when "000" => -- LOGIC with update of flags
                                         ICYCLE   <= CYCLE3;
                                         STBFLAG  <= '1';
                                         STBACCUM <= '1';
                           when "001" => -- LOGIC no update of Accumulator, sets flags
                                         ICYCLE   <= CYCLE3;
                                         STBFLAG  <= '1';
                           when "010" => -- APB ACCESS
                                         if EN_ACM=1 and INSTR_SCMD(1 downto 0)="10" then
                                           PSELI <=  ACMDO;
                                         else
                                           PSELI <= '1';
                                         end if;
                                         ICYCLE    <= CYCLE2;
                           when "011" => -- LOAD
                                         case INSTR_SCMD is
                                           when "000" => if ZRWIDTH>0 then
                                                           ZREGISTER(ZRWIDTH-1 downto 0) <= DATAOUT_ZREG_ZR(ZRWIDTH-1 downto 0);
                                                         end if;
                                           when "001" => if ZRWIDTH>0 then -- ADD/SUB ZREGISTER
                                                           ZREGISTER(ZRWIDTH-1 downto 0) <= ZREGISTER(ZRWIDTH-1 downto 0)+DATAOUT_ZREG_ZR(ZRWIDTH-1 downto 0);
                                                         end if;
                                           when "010" => if EN_RAM>0 then    -- RAM write
                                                           STBRAM <= '1';
                                                         end if;
                                           when "011" => if EN_RAM>0 then    -- RAM read
                                                          STBFLAG  <= '1';
                                                          STBACCUM <= '1';
                                                         end if;
                                           when "100" => if EN_PUSH=1 then   -- RAM PUSH
                                                           STKPTR <= STKPTRM1;
                                                           STBRAM <= '1';
                                                         end if;
                                           when "101" => if EN_PUSH=1 then   -- RAM POP
                                                           STKPTR   <= STKPTRP1;
                                                           STBFLAG  <= '1';
                                                           STBACCUM <= '1';
                                                         end if;
                                           when "110" => -- IO READ instruction
                                                         if EN_IOREAD=1 then
                                                           STBFLAG  <= '1';
                                                           STBACCUM <= '1';
                                                         end if;
                                           when "111" => -- IO WRITE instruction
                                                         if EN_IOWRT=1 then
                                                           IO_OUT(IOWIDTH-1 downto 0) <= DATAOUT_IO(IOWIDTH-1 downto 0);
                                                         end if;
                                           when others =>
                                         end case;
                                         ICYCLE <= CYCLE3;
                           when "100" => -- JUMP
                                         if FLAGS='1' then
                                           DOJMP <= '1';
                                         end if;
                                         ICYCLE <= CYCLE3;
                           when "101" => -- CALL
                                         if EN_CALL=1 and FLAGS='1' then
                                            STKPTR <= STKPTRM1;
                                            STBRAM <= '1';
                                            DOJMP  <= '1';
                                         end if;
                                         ICYCLE <= CYCLE3;
                           when "110" => -- RET
                                         if (EN_CALL=1 or EN_INT>0) and FLAGS='1' then
                                            ICYCLE <= CYCLE3;
                                            STKPTR <= STKPTRP1;
                                            DOJMP  <= '1';
                                            if INSTR_SCMD(1)='1' and EN_INT>0 then
                                              ISR <= '0';
                                            end if;
                                         else
                                            ICYCLE <= CYCLE3;
                                         end if;
                           when "111" => -- Spare Instruction
                                         -- users should insert there instruction code here
                                         ICYCLE <= CYCLE3;
                           when others =>ICYCLE <= CYCLE3;
                         end case;
                         end if;
                         end if;
          when CYCLE2 => PENABLEI <= '1';
                         PSELI    <= '1';
                         if (PREADY_M='1' and PENABLEI='1') or PSELI='0' then
                           PSELI    <= '0';
                           PENABLEI <= '0';
                           ICYCLE   <= CYCLE3;
                         end if;
          when CYCLE3 => if NVMREADY='1' then
                           GETINST <= '1';
                           DOISR   <= '0';
                           DOJMP   <= '0';
                           if DOISR='1' and EN_INT>0 then
                              SMADDR <= conv_std_logic_vector(ISRADDR,ICWIDTH);
                           elsif DOJMP='1' then   -- jump, call, ret and wait instruction
                             SMADDR <= INSTR_ADDR(ICWIDTH-1 downto 0);	   -- JUMP/CALL Address
							 if (EN_CALL=1 or EN_INT>0) and INSTR_CMD(1)='1' then    -- Return - address from RAM
                                SMADDR <= RAMRDATA(ICWIDTH-1 downto 0);
                             end if;
                             if (INSTR_CMD(1)='0' and INSTR_SCMD(1)='1') then -- dont update if WAIT instruction
                                SMADDR <= SMADDR;
                             end if;
                             -- If in WAIT do not refetch instruction
                             if INSTR_CMD="100" and INSTR_SCMD(1)='1' then
                               GETINST <= '0';
                             end if;
                           else
                             SMADDR <= SMADDR+1;
                           end if;
                           ICYCLE <= CYCLE0;
                        end if;
        end case;
        if EN_CALL=0 and EN_INT=0 then
          STKPTR <= ( others => '1');
        end if;
        if STWIDTH<8 then
          STKPTR(7 downto STWIDTH) <= ( others => '1');
        end if;
        if ZRWIDTH=0 then
          ZREGISTER <= ( others => '0');
        end if;
        if EN_RAM=0 and EN_INT=0 and EN_CALL=0 and EN_PUSH=0 then
          STBRAM  <= '0';
        end if;
        if EN_INT=0 then
          ISR   <= '0';
          DOISR <= '0';
        end if;
        if EN_IOWRT=0 then
          IO_OUT <= ( others => '0');
        end if;
        ZREGISTER(ZRWIDTH) <= '0';
        if INSMODE/=2  then
          GETINST <= '0';
        end if;
    end if;
  end if;
end process;


INTACT <= ISR;


---------------------------------------------------------------------------------
-- APB Bus Signal
--

-- Drive the APB bus, note signals are extended to the 32 bit bus

process(INSTR_ADDR,INSTR_SCMD,ZREGISTER,INSTR_SLOT,ZERO00)
constant N : integer := min1(ZRWIDTH,APB_AWIDTH);
begin
 PADDR_M <= ( others => '0');
 PADDR_M(APB_SWIDTH+APB_AWIDTH-1 downto 0) <= INSTR_SLOT(APB_SWIDTH-1 downto 0) & ZERO00(APB_AWIDTH-1 downto 0);
 if EN_INDIRECT=1 and INSTR_SCMD(2)='1' and ZRWIDTH>0 then
   PADDR_M(N-1 downto 0) <= ZREGISTER(N-1 downto 0);
 else
   PADDR_M(APB_AWIDTH-1 downto 0) <= INSTR_ADDR;
 end if;
end process;


process(DATAOUT_APB)
begin
 PWDATA_M <= ( others => '0');
 PWDATA_M(APB_DWIDTH-1 downto 0) <= DATAOUT_APB;
end process;


PENABLE_M <= PENABLEI;
PWRITE_M  <= not(INSTR_SCMD(0) and INSTR_SCMD(1));

STBACCAPB <= PENABLEI and INSTR_SCMD(0) and INSTR_SCMD(1);


process(PSELI)
begin
  PSEL_M <= PSELI;
end process;

---------------------------------------------------------------------------------
-- Debug Code is non synthesizeable
-- This process basically creates an instruction trace in the log window

-- synthesis translate_off

DEBUG1 <= to_logic (NVMREADY='1' and ICYCLE=CYCLE1);
DEBUG2 <= to_logic (ICYCLE=CYCLE2 and PREADY_M='1' and PENABLEI='1' and INSTR_SCMD(1 downto 0)="11") ;
DEBUGBLK_RESETN <= ARESETN and SRESETN;

UDB : COREABC_C0_COREABC_C0_0_DEBUGBLK
 generic map ( DEBUG   => DEBUG,
               AWIDTH  => APB_AWIDTH,
               DWIDTH  => APB_DWIDTH,
               SWIDTH  => APB_SWIDTH,
               SDEPTH  => APB_SDEPTH,
               ICWIDTH => ICWIDTH,
               ICDEPTH => ICDEPTH,
               ZRWIDTH => ZRWIDTH,
               IIWIDTH => IIWIDTH,
               IOWIDTH => IOWIDTH,
               IRWIDTH => IRWIDTH,
			   EN_MULT => EN_MULT
              )
 port map ( PCLK         => PCLK,
            RESETN       => DEBUGBLK_RESETN,
            SMADDR       => SMADDR,
            ISR          => ISR,
            INSTR_CMD    => INSTR_CMD,
            INSTR_SCMD   => INSTR_SCMD,
            INSTR_DATA   => INSTR_DATA,
            INSTR_ADDR   => INSTR_ADDR,
            INSTR_SLOT   => INSTR_SLOT,
            PRDATA       => PRDATA_M(APB_DWIDTH-1 downto 0),
            PWDATA       => DATAOUT_DB,
            ACCUM_OLD    => ACCUMULATOR,
            ACCUM_NEW    => ACCUM_NEXT,
            ACCUM_ZERO   => ACCUM_ZERO,
            ACCUM_NEG    => ACCUM_NEG,
            FLAGS        => FLAGS,
            RAMDOUT      => RAMDOUT,
            STKPTR       => STKPTR,
            ZREGISTER    => ZREGISTER,
            ACMDO        => ACMDO,
            DEBUG1       => DEBUG1,
            DEBUG2       => DEBUG2
);

-- synthesis translate_on

end RTL;
