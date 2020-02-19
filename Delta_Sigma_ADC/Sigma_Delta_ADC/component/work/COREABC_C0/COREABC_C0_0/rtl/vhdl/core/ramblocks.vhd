-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  ramblocks.vhd
--
-- Description: Simple APB Bus Controller
--              Selects how to build the RAM block based on the family
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 27672 $
-- SVN $Date: 2016-10-18 14:35:37 +0100 (Tue, 18 Oct 2016) $
--
-- Notes:
--
-- *********************************************************************/


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library COREABC_LIB;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_support.all;

entity COREABC_C0_COREABC_C0_0_RAMBLOCKS is
     generic ( DWIDTH : integer range 8 to 32;
     	       FAMILY : integer range 0 to 99
			 );
     port(CLK    : in  std_logic;
          RESETN : in  std_logic;
          WEN    : in  std_logic;
          ADDR   : in  std_logic_vector(7 downto 0);
          WD     : in  std_logic_vector(DWIDTH-1 downto 0);
          RD     : out std_logic_vector(DWIDTH-1 downto 0)
        ) ;
end COREABC_C0_COREABC_C0_0_RAMBLOCKS;


architecture RTL of  COREABC_C0_COREABC_C0_0_RAMBLOCKS is

subtype RWORD     is std_logic_vector (DWIDTH-1 downto 0);
type RAM_ARRAY    is array ( INTEGER range <>) of RWORD;

signal WDX : std_logic_vector(15 downto 0);
signal RDX : std_logic_vector(15 downto 0);
signal WDY : std_logic_vector(15 downto 0);
signal RDY : std_logic_vector(15 downto 0);

signal RENX : std_logic;

signal Logic0 : std_logic;
signal Logic1 : std_logic;

signal WEN_r0c0 : std_logic;
signal WEN_r0c1 : std_logic;
signal WEN_r0c2 : std_logic;
signal WEN_r0c3 : std_logic;
signal WEN_r1c0 : std_logic;
signal WEN_r1c1 : std_logic;
signal WEN_r1c2 : std_logic;
signal WEN_r1c3 : std_logic;
signal ADDR7_q  : std_logic;
signal RD_r0c0  : std_logic_vector(7 downto 0);
signal RD_r0c1  : std_logic_vector(7 downto 0);
signal RD_r0c2  : std_logic_vector(7 downto 0);
signal RD_r0c3  : std_logic_vector(7 downto 0);
signal RD_r1c0  : std_logic_vector(7 downto 0);
signal RD_r1c1  : std_logic_vector(7 downto 0);
signal RD_r1c2  : std_logic_vector(7 downto 0);
signal RD_r1c3  : std_logic_vector(7 downto 0);
signal RADDR    : std_logic_vector(7 downto 0);


begin

Logic0 <= '0';
Logic1 <= '1';

RENX <= not WEN;

-----------------------------------------------------------------------------
-- Use Behavioural RAM
--

UG0: if family=0  generate

  process(CLK)
  variable RAM   : RAM_ARRAY(0 to 255);
  variable maddr : std_logic_vector(7 downto 0);
  variable iaddr : INTEGER range 0 to 255 := 0;
  begin
    if CLK'event and CLK='1' then
	  maddr := (others => '0');
	  for i in 0 to 7 loop 	  -- remove x's in sim
	    if ADDR(i)='1' then
		  maddr(i) := '1';
	    end if;
	  end loop;
      iaddr := conv_integer(maddr);
      if WEN='1' then
        RAM(iaddr) := WD;
      end if;
      RD <= RAM(iaddr);
    end if;
  end process;


end generate;



UG00: if family=25  generate

  process(CLK)
  variable RAM   : RAM_ARRAY(0 to 255);
  variable maddr : std_logic_vector(7 downto 0);
  variable iaddr : INTEGER range 0 to 255 := 0;
  begin
    if CLK'event and CLK='1' then
	  maddr := (others => '0');
	  for i in 0 to 7 loop 	  -- remove x's in sim
	    if ADDR(i)='1' then
		  maddr(i) := '1';
	    end if;
	  end loop;
      iaddr := conv_integer(maddr);
      if WEN='1' then
        RAM(iaddr) := WD;
      end if;
      RD <= RAM(iaddr);
    end if;
  end process;


end generate;


-----------------------------------------------------------------------------
-- AX
-- For 8/16 bit use a  256x16 memory  = 1 memory element
-- For 32 bit use a 128x32 memory  = 1 memory element

UG1: if family=11 or family=12 generate

 UR816:
  if DWIDTH=8 or DWIDTH=16 generate
     UR: COREABC_C0_COREABC_C0_0_RAM256X16
             port map (RWCLK => CLK,
                       RESET => RESETN,
                       WEN   => WEN,
                       REN   => RENX,
                       WADDR => ADDR,
                       RADDR => ADDR,
                       WD    => WDX,
                       RD    => RDX
                     ) ;
  end generate;

  UR8:
  if DWIDTH=8 generate
     WDX <= "00000000" & WD;
     RD  <= RDX(7 downto 0);
  end generate;

  UR16:
  if DWIDTH=16 generate
     WDX <= WD;
     RD  <= RDX;
  end generate;





  UR32B:
   if DWIDTH=32  generate
     URA: COREABC_C0_COREABC_C0_0_RAM256X16
             port map (RWCLK => CLK,
                       RESET => RESETN,
                       WEN   => WEN,
                       REN   => RENX,
                       WADDR => ADDR,
                       RADDR => ADDR,
                       WD    => WD(15 downto 0),
                       RD    => RD(15 downto 0)
                     ) ;
     URB: COREABC_C0_COREABC_C0_0_RAM256X16
             port map (RWCLK => CLK,
                       RESET => RESETN,
                       WEN   => WEN,
                       REN   => RENX,
                       WADDR => ADDR,
                       RADDR => ADDR,
                       WD    => WD(31 downto 16),
                       RD    => RD(31 downto 16)
                     ) ;
   end generate;

end generate;


-----------------------------------------------------------------------------
-- APA
-- Use multiple 8-bit RAM
--

UG2: if family=14 generate

 UR: for i in 0 to DWIDTH/8-1 generate
   UR: COREABC_C0_COREABC_C0_0_RAM256X8
       port map (RWCLK  => CLK,
                 RESET  => CLK,
                 WEN    => WEN,
                 REN    => Logic1,
                 WADDR  => ADDR,
                 RADDR  => ADDR,
                 WD     => WD(i*8+7 downto i*8),
                 RD     => RD(i*8+7 downto i*8)
               ) ;

  end generate;

end generate;

-----------------------------------------------------------------------------
-- PA3/PA3E/PA3L/Fusion/SmartFusion/IGLOO/IGLOOe/IGLOO+
--
UG3: if family=15 or family=16 or family=17 or family=18
          or family=20 or family=21 or family=22 or family=23
          or family=24
 generate

 UR: COREABC_C0_COREABC_C0_0_RAM256X16
     port map (RWCLK => CLK,
               RESET => RESETN,
               WEN   => WEN,
               REN   => RENX,
               WADDR => ADDR,
               RADDR => ADDR,
               WD    => WDX,
               RD    => RDX
             ) ;

  UR8:
  if DWIDTH=8 generate
     WDX <= "00000000" & WD;
	 RD  <= RDX(7 downto 0);
  end generate;

  UR16:
  if DWIDTH=16 generate
     WDX <= WD;
	 RD  <= RDX;
  end generate;

  -- REN could simply be tied high in this circuit, but the Actel RAM models will generate a
  -- warning message every time the memory is written.
  -- So when WEN is high we force REN low !

  UR32:
  if DWIDTH=32 generate
      UR0: COREABC_C0_COREABC_C0_0_RAM256X16
           port map (RWCLK => CLK,
                     RESET => RESETN,
                     WEN   => WEN,
                     REN   => RENX,
                     WADDR => ADDR,
                     RADDR => ADDR,
                     WD    => WDY,
                     RD    => RDY
                   ) ;


     WDX <= WD(15 downto 0);
     WDY <= WD(31 downto 16);
	 RD  <= RDY & RDX;
  end generate;
end generate;

-----------------------------------------------------------------------------
-- SmartFusion2
--
UG4: if family=19 or  family=26 generate
    UR8:
    if DWIDTH = 8 generate
        RADDR <= (ADDR(7 downto 1) & not(ADDR(0))) when WEN = '1'
                 else ADDR;

        process (ADDR, WEN)
        begin
            if (ADDR(7) = '1') then
                WEN_r0c0 <= '0';
                WEN_r1c0 <= WEN;
            else
                WEN_r0c0 <= WEN;
                WEN_r1c0 <= '0';
            end if;
        end process;

        process (CLK)
        begin
            if (CLK'event and CLK = '1') then
                ADDR7_q <= ADDR(7);
            end if;
        end process;

        process (ADDR7_q, RD_r1c0,
                 RD_r0c0)
        begin
            if (ADDR7_q = '1') then
                RD <= RD_r1c0;
            else
                RD <= RD_r0c0;
            end if;
        end process;

        ram_r0c0 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(7 downto 0),
            RD     => RD_r0c0,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c0,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c0 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(7 downto 0),
            RD     => RD_r1c0,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c0,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
    end generate;
    UR16:
    if DWIDTH = 16 generate
        RADDR <= (ADDR(7 downto 1) & not(ADDR(0))) when WEN = '1'
                 else ADDR;

        process (ADDR, WEN)
        begin
            if (ADDR(7) = '1') then
                WEN_r0c0 <= '0';
                WEN_r0c1 <= '0';
                WEN_r1c0 <= WEN;
                WEN_r1c1 <= WEN;
            else
                WEN_r0c0 <= WEN;
                WEN_r0c1 <= WEN;
                WEN_r1c0 <= '0';
                WEN_r1c1 <= '0';
            end if;
        end process;

        process (CLK)
        begin
            if (CLK'event and CLK = '1') then
                ADDR7_q <= ADDR(7);
            end if;
        end process;

        process (ADDR7_q, RD_r1c1, RD_r1c0,
                 RD_r0c1, RD_r0c0)
        begin
            if (ADDR7_q = '1') then
                RD <= RD_r1c1 & RD_r1c0;
            else
                RD <= RD_r0c1 & RD_r0c0;
            end if;
        end process;

        ram_r0c0 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(7 downto 0),
            RD     => RD_r0c0,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c0,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r0c1 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(15 downto 8),
            RD     => RD_r0c1,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c1,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c0 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(7 downto 0),
            RD     => RD_r1c0,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c0,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c1 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(15 downto 8),
            RD     => RD_r1c1,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c1,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
    end generate;
    UR32:
    if DWIDTH = 32 generate
        RADDR <= (ADDR(7 downto 1) & not(ADDR(0))) when WEN = '1'
                 else ADDR;

        process (ADDR, WEN)
        begin
            if (ADDR(7) = '1') then
                WEN_r0c0 <= '0';
                WEN_r0c1 <= '0';
                WEN_r0c2 <= '0';
                WEN_r0c3 <= '0';
                WEN_r1c0 <= WEN;
                WEN_r1c1 <= WEN;
                WEN_r1c2 <= WEN;
                WEN_r1c3 <= WEN;
            else
                WEN_r0c0 <= WEN;
                WEN_r0c1 <= WEN;
                WEN_r0c2 <= WEN;
                WEN_r0c3 <= WEN;
                WEN_r1c0 <= '0';
                WEN_r1c1 <= '0';
                WEN_r1c2 <= '0';
                WEN_r1c3 <= '0';
            end if;
        end process;

        process (CLK)
        begin
            if (CLK'event and CLK = '1') then
                ADDR7_q <= ADDR(7);
            end if;
        end process;

        process (ADDR7_q, RD_r1c3, RD_r1c2, RD_r1c1, RD_r1c0,
                 RD_r0c3, RD_r0c2, RD_r0c1, RD_r0c0)
        begin
            if (ADDR7_q = '1') then
                RD <= RD_r1c3 & RD_r1c2 & RD_r1c1 & RD_r1c0;
            else
                RD <= RD_r0c3 & RD_r0c2 & RD_r0c1 & RD_r0c0;
            end if;
        end process;

        ram_r0c0 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(7 downto 0),
            RD     => RD_r0c0,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c0,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r0c1 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(15 downto 8),
            RD     => RD_r0c1,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c1,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r0c2 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(23 downto 16),
            RD     => RD_r0c2,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c2,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r0c3 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(31 downto 24),
            RD     => RD_r0c3,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r0c3,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c0 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(7 downto 0),
            RD     => RD_r1c0,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c0,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c1 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(15 downto 8),
            RD     => RD_r1c1,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c1,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c2 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(23 downto 16),
            RD     => RD_r1c2,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c2,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
        ram_r1c3 : COREABC_C0_COREABC_C0_0_RAM128X8
        port map (
            WD     => WD(31 downto 24),
            RD     => RD_r1c3,
            WADDR  => ADDR(6 downto 0),
            RADDR  => RADDR(6 downto 0),
            WEN    => WEN_r1c3,
            WCLK   => CLK,
            RCLK   => CLK,
            RESETN => RESETN
        );
    end generate;
end generate;

end RTL;
