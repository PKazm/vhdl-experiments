-- ***********************************************************************/
-- Microsemi Corporation Proprietary and Confidential
-- Copyright 2012 Microsemi Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description:	CoreSF2Reset
--				Soft IP reset controller for SmartFusion2 device.
--              Sequences various reset signals to blocks to
--              SmartFusion2 device.
--
-- SVN Revision Information:
-- SVN $Revision: 20293 $
-- SVN $Date: 2013-04-26 11:36:28 -0700 (Fri, 26 Apr 2013) $
--
-- Notes:
--
-- ***********************************************************************/


-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package coresf2reset_support is
    function calc_count_width(x:integer) return integer;
    function greater(x:integer; y:integer) return integer;
end coresf2reset_support;

package body coresf2reset_support is
    function greater(x:integer; y:integer) return integer is
    begin
        if   x > y then return x;
        else            return y;
        end if;
    end greater;

    function calc_count_width( x : integer ) return integer is
    begin
        if    x > 2147483647 then return(32);
        elsif x > 1073741823 then return(31);
        elsif x >  536870911 then return(30);
        elsif x >  268435455 then return(29);
        elsif x >  134217727 then return(28);
        elsif x >   67108863 then return(27);
        elsif x >   33554431 then return(26);
        elsif x >   16777215 then return(25);
        elsif x >    8388607 then return(24);
        elsif x >    4194303 then return(23);
        elsif x >    2097151 then return(22);
        elsif x >    1048575 then return(21);
        elsif x >     524287 then return(20);
        elsif x >     262143 then return(19);
        elsif x >     131071 then return(18);
        elsif x >      65535 then return(17);
        elsif x >      32767 then return(16);
        elsif x >      16383 then return(15);
        elsif x >       8191 then return(14);
        elsif x >       4095 then return(13);
        elsif x >       2047 then return(12);
        elsif x >       1023 then return(11);
        elsif x >        511 then return(10);
        elsif x >        255 then return( 9);
        elsif x >        127 then return( 8);
        elsif x >         63 then return( 7);
        elsif x >         31 then return( 6);
        elsif x >         15 then return( 5);
        elsif x >          7 then return( 4);
        elsif x >          3 then return( 3);
        else                      return( 2);
        end if;
    end calc_count_width;
end coresf2reset_support;
-- ========================================================================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.coresf2reset_support.all;

entity CoreSF2Reset is
    generic(
    FAMILY          : integer := 19;
    -- EXT_RESET_CFG is used to determine what can cause the external reset
    -- to be driven (by asserting EXT_RESET_OUT).
    --    0 = EXT_RESET_OUT is never asserted
    --    1 = EXT_RESET_OUT is asserted if power up reset
    --        (POWER_ON_RESET_N) is asserted
    --    2 = EXT_RESET_OUT is asserted if MSS_RESET_N_M2F (from MSS) is
    --        asserted
    --    3 = EXT_RESET_OUT is asserted if power up reset
    --        (POWER_ON_RESET_N) or MSS_RESET_N_M2F (from MSS) is asserted.
    EXT_RESET_CFG   : integer := 3;
    -- DEVICE_VOLTAGE is set to according to the supply voltage to the
    -- device. The supply voltage determines the RC oscillator frequency.
    -- This can be 25 or 50 MHz.
    --    1 = 1.0 V (RC osc freq = 25 MHz)
    --    2 = 1.2 V (RC osc freq = 50 MHz)
    DEVICE_VOLTAGE  : integer := 2;
    -- Use the following parameters to indicate whether or not a particular
    -- peripheral block is being used (and connected to this core).
    MDDR_IN_USE     : integer := 1;
    FDDR_IN_USE     : integer := 1;
    SDIF0_IN_USE    : integer := 1;
    SDIF1_IN_USE    : integer := 1;
    SDIF2_IN_USE    : integer := 1;
    SDIF3_IN_USE    : integer := 1;
    -- DDR_WAIT specifies the time in microseconds that must have elapsed
    -- between release of the reset to the FDDR block (FDDR_CORE_RESET_N)
    -- and release of the reset to user logic (USER_FAB_RESET_N) (and
    -- assertion of INIT_DONE output).
    DDR_WAIT        : integer := 200
    );
    port (
    -- Clock from RC oscillator
    RCOSC_25_50MHZ              : in  std_logic;
    -- Clock from fabric CCC
    --input           CLK_BASE,
    -- Power on reset signal from g4m_control
    POWER_ON_RESET_N            : in  std_logic;
    -- Signals from/to reset pad (open drain, bidirectional pad,
    --  connects to external reset controller.)
    EXT_RESET_IN_N              : in  std_logic;
    EXT_RESET_OUT               : out std_logic;
    -- Signals to/from MSSDDR
    MSS_RESET_N_F2M             : out std_logic;
    M3_RESET_N                  : out std_logic;
    MSS_RESET_N_M2F             : in  std_logic;
    MDDR_DDR_AXI_S_CORE_RESET_N : out std_logic;
    INIT_DONE                   : out std_logic;
    -- CLR_INIT_DONE comes from CoreSF2Config
    CLR_INIT_DONE               : in  std_logic;
    -- Configuration done indication from CoreSF2Config
    CONFIG_DONE                 : in  std_logic;
    -- Reset input from fabric. This is ANDed with EXT_RESET_IN_N in this
    -- core.
    USER_FAB_RESET_IN_N         : in  std_logic;
    -- Reset to (AHB/AXI based) user logic in fabric
    USER_FAB_RESET_N            : out std_logic;
    -- FDDR signals
    FPLL_LOCK                   : in  std_logic;
    FDDR_CORE_RESET_N           : out std_logic;
    -- SERDESIF_0 signals
    SDIF0_SPLL_LOCK             : in  std_logic;
    SDIF0_PHY_RESET_N           : out std_logic;
    SDIF0_CORE_RESET_N          : out std_logic;
    -- SERDESIF_1 signals
    SDIF1_SPLL_LOCK             : in  std_logic;
    SDIF1_PHY_RESET_N           : out std_logic;
    SDIF1_CORE_RESET_N          : out std_logic;
    -- SERDESIF_0 signals
    SDIF2_SPLL_LOCK             : in  std_logic;
    SDIF2_PHY_RESET_N           : out std_logic;
    SDIF2_CORE_RESET_N          : out std_logic;
    -- SERDESIF_1 signals
    SDIF3_SPLL_LOCK             : in  std_logic;
    SDIF3_PHY_RESET_N           : out std_logic;
    SDIF3_CORE_RESET_N          : out std_logic
    );
end CoreSF2Reset;

architecture rtl of CoreSF2Reset is
    constant RCOSC_MEGAHERTZ : integer := 25 * DEVICE_VOLTAGE;
    constant COUNT_130us     : integer := 130 * RCOSC_MEGAHERTZ;
    constant COUNT_DDR       : integer := DDR_WAIT * RCOSC_MEGAHERTZ;
    constant COUNT_MAX       : integer := greater(COUNT_130us, COUNT_DDR);

    constant COUNT_WIDTH     : integer := calc_count_width(COUNT_MAX);

    -- Parameters for state machine states
    constant S0 : std_logic_vector(2 downto 0) := "000";
    constant S1 : std_logic_vector(2 downto 0) := "001";
    constant S2 : std_logic_vector(2 downto 0) := "010";
    constant S3 : std_logic_vector(2 downto 0) := "011";
    constant S4 : std_logic_vector(2 downto 0) := "100";
    constant S5 : std_logic_vector(2 downto 0) := "101";
    constant S6 : std_logic_vector(2 downto 0) := "110";

    -- Signals
    signal sm0_state                : std_logic_vector(2 downto 0);
    --signal sm1_state                : std_logic_vector(2 downto 0);
    signal sm2_state                : std_logic_vector(2 downto 0);
    signal next_sm0_state           : std_logic_vector(2 downto 0);
    --signal next_sm1_state           : std_logic_vector(2 downto 0);
    signal next_sm2_state           : std_logic_vector(2 downto 0);
    signal next_ext_reset_out       : std_logic;
    signal next_user_fab_reset_n    : std_logic;
    signal next_fddr_core_reset_n   : std_logic;
    signal next_sdif0_phy_reset_n   : std_logic;
    signal next_sdif0_core_reset_n  : std_logic;
    signal next_sdif1_phy_reset_n   : std_logic;
    signal next_sdif1_core_reset_n  : std_logic;
    signal next_sdif2_phy_reset_n   : std_logic;
    signal next_sdif2_core_reset_n  : std_logic;
    signal next_sdif3_phy_reset_n   : std_logic;
    signal next_sdif3_core_reset_n  : std_logic;
    signal next_mddr_core_reset_n   : std_logic;
    --signal next_user_mss_reset_n    : std_logic;
    --signal next_fab_m3_reset_n      : std_logic;
    signal next_count_enable        : std_logic;
    signal next_init_done_rcosc     : std_logic;
    signal release_ext_reset        : std_logic;
    signal next_release_ext_reset   : std_logic;

    signal sm0_areset_n             : std_logic;
    signal sm1_areset_n             : std_logic;
    signal sm2_areset_n             : std_logic;

    signal sm0_areset_n_q1          : std_logic;
    signal sm0_areset_n_rcosc       : std_logic;
    signal sm1_areset_n_q1          : std_logic;
    signal sm1_areset_n_rcosc       : std_logic;
    signal sm2_areset_n_q1          : std_logic;
    signal sm2_areset_n_rcosc       : std_logic;

    signal fpll_lock_q1             : std_logic;
    signal fpll_lock_q2             : std_logic;
    signal sdif0_spll_lock_q1       : std_logic;
    signal sdif0_spll_lock_q2       : std_logic;
    signal sdif1_spll_lock_q1       : std_logic;
    signal sdif1_spll_lock_q2       : std_logic;
    signal sdif2_spll_lock_q1       : std_logic;
    signal sdif2_spll_lock_q2       : std_logic;
    signal sdif3_spll_lock_q1       : std_logic;
    signal sdif3_spll_lock_q2       : std_logic;

    signal count_130us_0            : std_logic;
    signal count_ddr_0              : std_logic;
    signal count_enable             : std_logic;

    signal init_done_rcosc          : std_logic;

    signal count                    : std_logic_vector(COUNT_WIDTH-1 downto 0);

    signal FPLL_LOCK_int            : std_logic;
    signal SDIF0_SPLL_LOCK_int      : std_logic;
    signal SDIF1_SPLL_LOCK_int      : std_logic;
    signal SDIF2_SPLL_LOCK_int      : std_logic;
    signal SDIF3_SPLL_LOCK_int      : std_logic;

    signal CLR_INIT_DONE_q1         : std_logic;
    signal CLR_INIT_DONE_rcosc      : std_logic;
    signal CONFIG_DONE_q1           : std_logic;
    signal CONFIG_DONE_rcosc        : std_logic;

    signal EXT_RESET_OUT_0          : std_logic;
    signal MSS_RESET_N_F2M_0        : std_logic;
    signal M3_RESET_N_0             : std_logic;
    signal MDDR_DDR_AXI_S_CORE_RESET_N_0 : std_logic;
    signal INIT_DONE_0              : std_logic;
    signal USER_FAB_RESET_N_0       : std_logic;
    signal FDDR_CORE_RESET_N_0      : std_logic;
    signal SDIF0_PHY_RESET_N_0      : std_logic;
    signal SDIF0_CORE_RESET_N_0     : std_logic;
    signal SDIF1_PHY_RESET_N_0      : std_logic;
    signal SDIF1_CORE_RESET_N_0     : std_logic;
    signal SDIF2_PHY_RESET_N_0      : std_logic;
    signal SDIF2_CORE_RESET_N_0     : std_logic;
    signal SDIF3_PHY_RESET_N_0      : std_logic;
    signal SDIF3_CORE_RESET_N_0     : std_logic;

begin
    EXT_RESET_OUT   <= EXT_RESET_OUT_0;
    MSS_RESET_N_F2M <= MSS_RESET_N_F2M_0;
    M3_RESET_N      <= M3_RESET_N_0;
    MDDR_DDR_AXI_S_CORE_RESET_N <= MDDR_DDR_AXI_S_CORE_RESET_N_0;
    INIT_DONE           <= INIT_DONE_0;
    USER_FAB_RESET_N    <= USER_FAB_RESET_N_0;
    FDDR_CORE_RESET_N   <= FDDR_CORE_RESET_N_0;
    SDIF0_PHY_RESET_N   <= SDIF0_PHY_RESET_N_0;
    SDIF0_CORE_RESET_N  <= SDIF0_CORE_RESET_N_0;
    SDIF1_PHY_RESET_N   <= SDIF1_PHY_RESET_N_0;
    SDIF1_CORE_RESET_N  <= SDIF1_CORE_RESET_N_0;
    SDIF2_PHY_RESET_N   <= SDIF2_PHY_RESET_N_0;
    SDIF2_CORE_RESET_N  <= SDIF2_CORE_RESET_N_0;
    SDIF3_PHY_RESET_N   <= SDIF3_PHY_RESET_N_0;
    SDIF3_CORE_RESET_N  <= SDIF3_CORE_RESET_N_0;

    -- If a peripheral block is not in use, internally tie its PLL lock
    -- signal high.
    process (FPLL_LOCK)
    begin
        if (FDDR_IN_USE /= 0) then
            FPLL_LOCK_int <= FPLL_LOCK;
        else
            FPLL_LOCK_int <= '1';
        end if;
    end process;
    process (SDIF0_SPLL_LOCK)
    begin
        if (SDIF0_IN_USE /= 0) then
            SDIF0_SPLL_LOCK_int <= SDIF0_SPLL_LOCK;
        else
            SDIF0_SPLL_LOCK_int <= '1';
        end if;
    end process;
    process (SDIF1_SPLL_LOCK)
    begin
        if (SDIF1_IN_USE /= 0) then
            SDIF1_SPLL_LOCK_int <= SDIF1_SPLL_LOCK;
        else
            SDIF1_SPLL_LOCK_int <= '1';
        end if;
    end process;
    process (SDIF2_SPLL_LOCK)
    begin
        if (SDIF2_IN_USE /= 0) then
            SDIF2_SPLL_LOCK_int <= SDIF2_SPLL_LOCK;
        else
            SDIF2_SPLL_LOCK_int <= '1';
        end if;
    end process;
    process (SDIF3_SPLL_LOCK)
    begin
        if (SDIF3_IN_USE /= 0) then
            SDIF3_SPLL_LOCK_int <= SDIF3_SPLL_LOCK;
        else
            SDIF3_SPLL_LOCK_int <= '1';
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Create a number of asynchronous resets.
    -- Some source reset signals may be "combined" to create a single
    -- asynchronous reset.
    -----------------------------------------------------------------------
    process (EXT_RESET_IN_N, USER_FAB_RESET_IN_N, POWER_ON_RESET_N,
             MSS_RESET_N_M2F)
    begin
        sm0_areset_n <= ((EXT_RESET_IN_N and USER_FAB_RESET_IN_N)
                         and POWER_ON_RESET_N)
                        and MSS_RESET_N_M2F;
    end process;

    -- Assertion of resets to MSS (MSS_RESET_N_F2M and M3_RESET_N) caused
    -- by assertion of external reset input or assertion of reset signal
    -- from fabric.
    process (EXT_RESET_IN_N, USER_FAB_RESET_IN_N)
    begin
        sm1_areset_n <= EXT_RESET_IN_N and USER_FAB_RESET_IN_N;
    end process;

    -- There are a number of options for what can cause the external reset
    -- to be asserted.
    g_0: if (EXT_RESET_CFG = 0) generate
      process (POWER_ON_RESET_N)
      begin
          sm2_areset_n <= POWER_ON_RESET_N;
      end process;
    end generate;
    g_1: if (not(EXT_RESET_CFG = 0)) generate
      g_2: if (EXT_RESET_CFG = 1) generate
        process (POWER_ON_RESET_N)
        begin
            sm2_areset_n <= POWER_ON_RESET_N;
        end process;
      end generate;
      g_3: if (not(EXT_RESET_CFG = 1)) generate
        g_4: if (EXT_RESET_CFG = 2) generate
          process (MSS_RESET_N_M2F)
          begin
              sm2_areset_n <= MSS_RESET_N_M2F;
          end process;
        end generate;
        g_5: if (not(EXT_RESET_CFG = 2)) generate
          process (POWER_ON_RESET_N, MSS_RESET_N_M2F)
          begin
              sm2_areset_n <= POWER_ON_RESET_N and MSS_RESET_N_M2F;
          end process;
        end generate;
      end generate;
    end generate;

    -----------------------------------------------------------------------
    -- Create versions of asynchronous resets that are released
    -- synchronous to RCOSC_25_50MHZ.
    -----------------------------------------------------------------------
    process (RCOSC_25_50MHZ, sm0_areset_n)
    begin
        if (sm0_areset_n = '0') then
            sm0_areset_n_q1 <= '0';
            sm0_areset_n_rcosc <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            sm0_areset_n_q1 <= '1';
            sm0_areset_n_rcosc <= sm0_areset_n_q1;
        end if;
    end process;

    process (RCOSC_25_50MHZ, sm1_areset_n)
    begin
        if (sm1_areset_n = '0') then
            sm1_areset_n_q1 <= '0';
            sm1_areset_n_rcosc <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            sm1_areset_n_q1 <= '1';
            sm1_areset_n_rcosc <= sm1_areset_n_q1;
        end if;
    end process;

    process (RCOSC_25_50MHZ, sm2_areset_n)
    begin
        if (sm2_areset_n = '0') then
            sm2_areset_n_q1 <= '0';
            sm2_areset_n_rcosc <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            sm2_areset_n_q1 <= '1';
            sm2_areset_n_rcosc <= sm2_areset_n_q1;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Synchronize CLR_INIT_DONE input to RCOSC_25_50MHZ domain.
    -----------------------------------------------------------------------
    process (RCOSC_25_50MHZ, sm0_areset_n_rcosc)
    begin
        if (sm0_areset_n_rcosc = '0') then
            CLR_INIT_DONE_q1    <= '0';
            CLR_INIT_DONE_rcosc <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            CLR_INIT_DONE_q1    <= CLR_INIT_DONE;
            CLR_INIT_DONE_rcosc <= CLR_INIT_DONE_q1;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Synchronize CONFIG_DONE input to RCOSC_25_50MHZ domain.
    -----------------------------------------------------------------------
    process (RCOSC_25_50MHZ, sm0_areset_n_rcosc)
    begin
        if (sm0_areset_n_rcosc = '0') then
            CONFIG_DONE_q1    <= '0';
            CONFIG_DONE_rcosc <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            CONFIG_DONE_q1    <= CONFIG_DONE;
            CONFIG_DONE_rcosc <= CONFIG_DONE_q1;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Synchronize PLL lock signals to RCOSC_25_50MHZ domain.
    -----------------------------------------------------------------------
    process (RCOSC_25_50MHZ, sm0_areset_n_rcosc)
    begin
        if (sm0_areset_n_rcosc = '0') then
            fpll_lock_q1       <= '0';
            fpll_lock_q2       <= '0';
            sdif0_spll_lock_q1 <= '0';
            sdif0_spll_lock_q2 <= '0';
            sdif1_spll_lock_q1 <= '0';
            sdif1_spll_lock_q2 <= '0';
            sdif2_spll_lock_q1 <= '0';
            sdif2_spll_lock_q2 <= '0';
            sdif3_spll_lock_q1 <= '0';
            sdif3_spll_lock_q2 <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            fpll_lock_q1       <= FPLL_LOCK_int;
            fpll_lock_q2       <= fpll_lock_q1;
            sdif0_spll_lock_q1 <= SDIF0_SPLL_LOCK_int;
            sdif0_spll_lock_q2 <= sdif0_spll_lock_q1;
            sdif1_spll_lock_q1 <= SDIF1_SPLL_LOCK_int;
            sdif1_spll_lock_q2 <= sdif1_spll_lock_q1;
            sdif2_spll_lock_q1 <= SDIF2_SPLL_LOCK_int;
            sdif2_spll_lock_q2 <= sdif2_spll_lock_q1;
            sdif3_spll_lock_q1 <= SDIF3_SPLL_LOCK_int;
            sdif3_spll_lock_q2 <= sdif3_spll_lock_q1;
        end if;
    end process;

    -----------------------------------------------------------------------
    -- State machine 0
    -- Controls all output signals except MSS_RESET_N_F2M, M3_RESET_N and
    -- EXT_RESET_OUT.
    -----------------------------------------------------------------------
    -- State machine 0 - combinational part
    process (
        sm0_state,
        USER_FAB_RESET_N_0,
        FDDR_CORE_RESET_N_0,
        SDIF0_PHY_RESET_N_0,
        SDIF0_CORE_RESET_N_0,
        SDIF1_PHY_RESET_N_0,
        SDIF1_CORE_RESET_N_0,
        SDIF2_PHY_RESET_N_0,
        SDIF2_CORE_RESET_N_0,
        SDIF3_PHY_RESET_N_0,
        SDIF3_CORE_RESET_N_0,
        MDDR_DDR_AXI_S_CORE_RESET_N_0,
        count_enable,
        init_done_rcosc,
        release_ext_reset,
        fpll_lock_q2,
        sdif0_spll_lock_q2,
        sdif1_spll_lock_q2,
        sdif2_spll_lock_q2,
        sdif3_spll_lock_q2,
        count_130us_0,
        CONFIG_DONE_rcosc,
        count_ddr_0
    )
    begin
        next_sm0_state <= sm0_state;
        next_user_fab_reset_n <= USER_FAB_RESET_N_0;
        next_fddr_core_reset_n <= FDDR_CORE_RESET_N_0;
        next_sdif0_phy_reset_n <= SDIF0_PHY_RESET_N_0;
        next_sdif0_core_reset_n <= SDIF0_CORE_RESET_N_0;
        next_sdif1_phy_reset_n <= SDIF1_PHY_RESET_N_0;
        next_sdif1_core_reset_n <= SDIF1_CORE_RESET_N_0;
        next_sdif2_phy_reset_n <= SDIF2_PHY_RESET_N_0;
        next_sdif2_core_reset_n <= SDIF2_CORE_RESET_N_0;
        next_sdif3_phy_reset_n <= SDIF3_PHY_RESET_N_0;
        next_sdif3_core_reset_n <= SDIF3_CORE_RESET_N_0;
        next_mddr_core_reset_n <= MDDR_DDR_AXI_S_CORE_RESET_N_0;
        next_count_enable <= count_enable;
        next_init_done_rcosc <= init_done_rcosc;
        next_release_ext_reset <= release_ext_reset;
        case sm0_state is
            when "000" =>
                next_sm0_state <= "001";
            when "001" =>
                next_sm0_state <= "010";
                -- Release resets to FDDR and MDDR blocks
                next_fddr_core_reset_n <= '1';
                next_mddr_core_reset_n <= '1';
            when "010" =>
                -- Wait for CONFIG_DONE and PLL lock signals
                if (CONFIG_DONE_rcosc = '1' and fpll_lock_q2 = '1' and sdif0_spll_lock_q2 = '1' and sdif1_spll_lock_q2 = '1'
                    and sdif2_spll_lock_q2 = '1' and sdif3_spll_lock_q2 = '1') then
                    next_sm0_state <= "011";
                    -- Release serdes phy resets and start counter
                    next_sdif0_phy_reset_n <= '1';
                    next_sdif1_phy_reset_n <= '1';
                    next_sdif2_phy_reset_n <= '1';
                    next_sdif3_phy_reset_n <= '1';
                    next_count_enable <= '1';
                end if;
            when "011" =>
                -- Release serdes core resets 130us after phy resets.
                if (count_130us_0 = '1') then
                    next_sm0_state <= "100";
                    next_sdif0_core_reset_n <= '1';
                    next_sdif1_core_reset_n <= '1';
                    next_sdif2_core_reset_n <= '1';
                    next_sdif3_core_reset_n <= '1';
                end if;
            when "100" =>
                next_sm0_state <= "101";
            when "101" =>
                -- Wait until enough time has been allowed for DDR memory
                -- to be ready for use before releasing reset to user logic
                -- in fabric and asserting INIT_DONE output.
                -- (May not have to wait here at all, depending on how long
                -- it takes for CONFIG_DONE input to be asserted.)
                if (count_ddr_0 = '1') then
                    next_sm0_state <= "110";
                    next_user_fab_reset_n <= '1';
                    next_init_done_rcosc <= '1';
                    next_count_enable <= '0';
                end if;
            when "110" =>
                next_sm0_state <= "110";
                -- Allow release of external reset at this point.
                -- A separate state machine controls the external reset.
                -- The external reset may or may not be asserted depending
                -- on the reset source and the configuration chosen for
                -- external reset via the EXT_RESET_CFG parameter.
                next_release_ext_reset <= '1';
            when others =>
                next_sm0_state <= "000";
        end case;
    end process;

    -- State machine 0 - sequential part
    process (RCOSC_25_50MHZ, sm0_areset_n_rcosc)
    begin
        if (sm0_areset_n_rcosc = '0') then
            sm0_state                     <= "000";
            USER_FAB_RESET_N_0            <= '0';
            FDDR_CORE_RESET_N_0           <= '0';
            SDIF0_PHY_RESET_N_0           <= '0';
            SDIF0_CORE_RESET_N_0          <= '0';
            SDIF1_PHY_RESET_N_0           <= '0';
            SDIF1_CORE_RESET_N_0          <= '0';
            SDIF2_PHY_RESET_N_0           <= '0';
            SDIF2_CORE_RESET_N_0          <= '0';
            SDIF3_PHY_RESET_N_0           <= '0';
            SDIF3_CORE_RESET_N_0          <= '0';
            MDDR_DDR_AXI_S_CORE_RESET_N_0 <= '0';
            count_enable                  <= '0';
            release_ext_reset             <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            sm0_state                     <= next_sm0_state;
            USER_FAB_RESET_N_0            <= next_user_fab_reset_n;
            FDDR_CORE_RESET_N_0           <= next_fddr_core_reset_n;
            SDIF0_PHY_RESET_N_0           <= next_sdif0_phy_reset_n;
            SDIF0_CORE_RESET_N_0          <= next_sdif0_core_reset_n;
            SDIF1_PHY_RESET_N_0           <= next_sdif1_phy_reset_n;
            SDIF1_CORE_RESET_N_0          <= next_sdif1_core_reset_n;
            SDIF2_PHY_RESET_N_0           <= next_sdif2_phy_reset_n;
            SDIF2_CORE_RESET_N_0          <= next_sdif2_core_reset_n;
            SDIF3_PHY_RESET_N_0           <= next_sdif3_phy_reset_n;
            SDIF3_CORE_RESET_N_0          <= next_sdif3_core_reset_n;
            MDDR_DDR_AXI_S_CORE_RESET_N_0 <= next_mddr_core_reset_n;
            count_enable                  <= next_count_enable;
            release_ext_reset             <= next_release_ext_reset;
        end if;
    end process;

    process (RCOSC_25_50MHZ, sm0_areset_n_rcosc)
    begin
        if (sm0_areset_n_rcosc = '0') then
            init_done_rcosc <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            if (next_init_done_rcosc = '1') then
                init_done_rcosc <= '1';
            end if;
            if (CLR_INIT_DONE_rcosc = '1') then
                init_done_rcosc <= '0';
            end if;
        end if;
    end process;
    -- End of state machine 0.
    -----------------------------------------------------------------------

    -----------------------------------------------------------------------
    -- State machine 1
    -- Controls MSS_RESET_N_F2M and M3_RESET_N signals.
    -----------------------------------------------------------------------
--    -- State machine 1 - combinational part
--    process (
--        sm1_state,
--        MSS_RESET_N_F2M_0,
--        M3_RESET_N_0
--    )
--    begin
--        next_sm1_state <= sm1_state;
--        next_user_mss_reset_n <= MSS_RESET_N_F2M_0;
--        next_fab_m3_reset_n <= M3_RESET_N_0;
--        case sm1_state is
--            when "000" =>
--                next_sm1_state <= "001";
--            when "001" =>
--                -- Not waiting for PLL lock signals to be asserted before
--                -- releasing MSS_RESET_N_F2M and M3_RESET_N.
--                next_user_mss_reset_n <= '1';
--                next_fab_m3_reset_n <= '1';
--            when others =>
--                next_sm1_state <= "000";
--        end case;
--    end process;
--
--    -- State machine 1 - sequential part
--    process (RCOSC_25_50MHZ, sm1_areset_n_rcosc)
--    begin
--        if (sm1_areset_n_rcosc = '0') then
--            sm1_state         <= "000";
--            MSS_RESET_N_F2M_0 <= '0';
--            M3_RESET_N_0      <= '0';
--        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
--            sm1_state         <= next_sm1_state;
--            MSS_RESET_N_F2M_0 <= next_user_mss_reset_n;
--            M3_RESET_N_0      <= next_fab_m3_reset_n;
--        end if;
--    end process;
--    -- End of state machine 1.

    process (RCOSC_25_50MHZ, sm1_areset_n_rcosc)
    begin
        if (sm1_areset_n_rcosc = '0') then
            MSS_RESET_N_F2M_0 <= '0';
            M3_RESET_N_0      <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            MSS_RESET_N_F2M_0 <= '1';
            M3_RESET_N_0      <= '1';
        end if;
    end process;
    -----------------------------------------------------------------------

    -----------------------------------------------------------------------
    -- State machine 2
    -- Controls EXT_RESET_OUT signal.
    -----------------------------------------------------------------------
    -- State machine 2 - combinational part
    process (
        sm2_state,
        EXT_RESET_OUT_0,
        release_ext_reset
    )
    begin
        next_sm2_state <= sm2_state;
        next_ext_reset_out <= EXT_RESET_OUT_0;
        case sm2_state is
            when "000" =>
                next_sm2_state <= "001";
            when "001" =>
                -- release_ext_reset is controlled by state machine 0.
                if (release_ext_reset = '1') then
                    next_ext_reset_out <= '0';
                end if;
            when others =>
                next_sm2_state <= "000";
        end case;
    end process;

    -- State machine 2 - sequential part
    process (RCOSC_25_50MHZ, sm2_areset_n_rcosc)
    variable ext_res_out_rv : std_logic;
    begin
        if (EXT_RESET_CFG > 0) then
            ext_res_out_rv := '1';
        else
            ext_res_out_rv := '0';
        end if;
        if (sm2_areset_n_rcosc = '0') then
            sm2_state       <= "000";
            EXT_RESET_OUT_0 <= ext_res_out_rv;
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            sm2_state       <= next_sm2_state;
            EXT_RESET_OUT_0 <= next_ext_reset_out;
        end if;
    end process;
    -- End of state machine 2.
    -----------------------------------------------------------------------

    -- Counter clocked by RCOSC_25_50MHZ.
    -- Used to time intervals between reset releases.
    process (RCOSC_25_50MHZ, sm0_areset_n_rcosc)
    begin
        if (sm0_areset_n_rcosc = '0') then
            count <= (others => '0');
            --count <= 0;
            count_130us_0 <= '0';
            count_ddr_0 <= '0';
        elsif (RCOSC_25_50MHZ'event and RCOSC_25_50MHZ = '1') then
            if (count_enable = '1') then
                count <= std_logic_vector(unsigned(count) + 1);
            end if;
            -- Detect elapse of 130us.
            if (count = std_logic_vector(to_unsigned(COUNT_130us, COUNT_WIDTH))) then
                count_130us_0 <= '1';
            end if;
            -- Detect when enough time has been allowed for DDR memory to
            -- be ready for use
            if (count = std_logic_vector(to_unsigned(COUNT_DDR, COUNT_WIDTH))) then
                count_ddr_0 <= '1';
            end if;
        end if;
    end process;

    process (init_done_rcosc)
    begin
        INIT_DONE_0 <= init_done_rcosc;
    end process;

end rtl;
