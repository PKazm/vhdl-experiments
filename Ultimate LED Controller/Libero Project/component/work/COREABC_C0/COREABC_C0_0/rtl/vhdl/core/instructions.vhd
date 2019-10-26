-- ********************************************************************/
-- Copyright 2008 Actel Corporation.  All rights reserved.
-- IP Engineering
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- File:  instructions.vhd
--
-- Description: Simple APB Bus Controller
--              Top Level
--
-- Rev: 2.4   24Jan08 IPB  : Production Release
--
-- SVN Revision Information:
-- SVN $Revision: 11063 $
-- SVN $Date: 2009-11-17 09:10:46 -0800 (Tue, 17 Nov 2009) $
--
-- Notes:
--   TESTMODE is used to set what tests are used for verification tests
--   based on the core configuration.
--
-- *********************************************************************/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library COREABC_LIB;
use COREABC_LIB.COREABC_C0_COREABC_C0_0_support.all;
entity COREABC_C0_COREABC_C0_0_INSTRUCTIONS is
  generic ( AWIDTH   : integer range 1 to 16;
            DWIDTH   : integer range 8 to 32;
            SWIDTH   : integer range 0 to 4 ;
            ICWIDTH  : integer range 1 to 16;
            IIWIDTH  : integer range 1 to 32;
            IFWIDTH  : integer range 0 to 28;
            IWWIDTH  : integer range 1 to 64;
            EN_MULT  : integer range 0 to 3;
            EN_INC   : integer range 0 to 1;
            TESTMODE : integer range 0 to 99
           );
  port     ( ADDRESS     : in  std_logic_vector(ICWIDTH-1 downto 0);
             INSTRUCTION : out std_logic_vector(IWWIDTH-1 downto 0)
           );
end COREABC_C0_COREABC_C0_0_INSTRUCTIONS;
architecture RTL of COREABC_C0_COREABC_C0_0_INSTRUCTIONS is
constant AW : integer := AWIDTH;
constant DW : integer := DWIDTH;
constant SW : integer := max1(SWIDTH,1);
constant IW : integer := ICWIDTH;
signal INS : std_logic_vector(IWWIDTH-1 downto 0);
-- These allow the passing of IFWIDTH to the support package
constant  iJUMP    : integer := iJUMPB   + IFWIDTH;
constant  iCALL    : integer := iCALLB   + IFWIDTH;
constant  iRETURN  : integer := iRETURNB + IFWIDTH;
constant  iRETISR  : integer := iRETISRB + IFWIDTH;
constant  iWAIT    : integer := iWAITB   + IFWIDTH;
constant  iHALT    : integer := iHALTB   + IFWIDTH;
constant  iINC     : integer := iINCB    + 2*EN_MULT + 1 - EN_INC;
-- These constants used internally for CoreAI
constant  iACM_CTRLSTAT          : integer := 16#00#;
constant  iACM_ADDR_ADDR         : integer := 16#04#;
constant  iACM_DATA_ADDR         : integer := 16#08#;
constant  iADC_CTRL2_HI_ADDR     : integer := 16#10#;
constant  iADC_STAT_HI_ADDR      : integer := 16#20#;
-- CCDirective Insert constants
constant Sym_I2C_Step : integer := 0;
constant Sym_I2C_State : integer := 1;
constant Sym_I2C_Reg_Addr : integer := 2;
constant Sym_I2C_Reg_Val : integer := 3;
constant Sym_Data_Store_Addr : integer := 4;
constant Sym_Light_Store_CTRL : integer := 0;
constant Sym_Light_Store_CH0_0 : integer := 1;
constant Sym_Light_Store_CH0_1 : integer := 2;
constant Sym_Light_Store_CH1_0 : integer := 3;
constant Sym_Light_Store_CH1_1 : integer := 4;
constant Sym_Light_Store_Int : integer := 5;
constant Label_Light_Control_Interrupt : integer := 9;
constant Label_I2C_Process : integer := 13;
constant Label_I2C_0x08_Start_Sent : integer := 34;
constant Label_I2C_0x10_Restart_Sent : integer := 36;
constant Label_I2C_0x18_SLA_W_Sent : integer := 38;
constant Label_I2C_0x28_Data_Sent : integer := 41;
constant Label_I2C_0x40_SLA_R_Sent : integer := 51;
constant Label_I2C_0x50_Data_Received : integer := 52;
constant Label_I2C_CH1_0 : integer := 63;
constant Label_I2C_CH1_1 : integer := 67;
constant Label_I2C_CH0_0 : integer := 71;
constant Label_I2C_Continue : integer := 76;
constant Label_I2C_Continue_Read : integer := 80;
constant Label_I2C_RepeatStart : integer := 84;
constant Label_I2C_StopStart : integer := 90;
constant Label_I2C_Stop : integer := 99;
constant Label_I2C_0xE0_Stop_transmitted : integer := 106;
constant Label_AbandonShip : integer := 110;
constant Label_MAIN : integer := 111;
constant Label_LOOP : integer := 117;
begin
-- These are the procedure calls to create the instruction sequence
PROM:
process(ADDRESS)
variable ADDRINT : integer range 0 to 2**ICWIDTH-1;
begin
   ADDRINT := conv_integer(ADDRESS);
   ---------------------------------------------------------------------------------------------
   case TESTMODE is
     when 0 =>
        case ADDRINT is
          -- A MANUALLY CREATED USER INSTRUCTION SEQUENCE SHOULD BE INSERTED HERE
          when 0   =>    INS <= doins( iJUMP,0);
          when others => INS <= ( others => '-');    -- default is dont cares, reduces tile counts
        end case;
-- Automatically created code will be inserted by CC here
-- CCDirective Insert code
   case ADDRINT is
      when  0 => INS <= doins( iJUMP, Label_MAIN);
      --   Interrupt Service Routine Here
      when  1 => INS <= doins( iAPBREAD, 2, Sym_Light_Store_Int);
      when  2 => INS <= doins( iBITTST, 1);
      when  3 => INS <= doins( iJUMP, iIFNOT, iZERO, Label_I2C_Process);
      when  4 => INS <= doins( iBITTST, 0);
      when  5 => INS <= doins( iJUMP, iIFNOT, iZERO, Label_Light_Control_Interrupt);
      --   interrupt fallthrough
      when  6 => INS <= doins( iAND, iDAT, 2#00000011#);
      when  7 => INS <= doins( iAPBWRT, iACC, 2, Sym_Light_Store_Int);
      when  8 => INS <= doins( iRETISR);
      -- $Light_Control_Interrupt
      --   ACC should still be Light_Store_Int
      when  9 => INS <= doins( iAND, iDAT, 2#11111110#);
      when 10 => INS <= doins( iAPBWRT, iACC, 2, Sym_Light_Store_Int);
      --   do nothing yet
      --   eventually trigger light sensor read
      when 11 => INS <= doins( iAPBWRT, iDAT8, 1, 16#00#, 2#11100000#);
      --  APBREAD 1 0x6000
      --  APBREAD 1 0x00
      --  APBWRT DAT 0 0x0000 0x40030000
      --  APBREAD 1 0x8048
      --  APBWRT DAT 0 0x0000 0x40000000
      when 12 => INS <= doins( iRETISR);
      -- $I2C_Process
      when 13 => INS <= doins( iAPBREAD, 1, 16#04#);
      when 14 => INS <= doins( iCMP, iDAT8, 16#08#);
      when 15 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0x08_Start_Sent);
      when 16 => INS <= doins( iCMP, iDAT8, 16#10#);
      when 17 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0x10_Restart_Sent);
      when 18 => INS <= doins( iCMP, iDAT8, 16#18#);
      when 19 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0x18_SLA_W_Sent);
      when 20 => INS <= doins( iCMP, iDAT8, 16#20#);
      --   error transmitting SLA+W, send again
      when 21 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_Continue);
      when 22 => INS <= doins( iCMP, iDAT8, 16#28#);
      when 23 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0x28_Data_Sent);
      when 24 => INS <= doins( iCMP, iDAT8, 16#30#);
      --   error transmitting Data, send again
      when 25 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_Continue);
      --  CMP DAT8 0x38
      --   arbitration lost
      --  JUMP IF ZERO $AbandonShip
      when 26 => INS <= doins( iCMP, iDAT8, 16#40#);
      when 27 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0x40_SLA_R_Sent);
      when 28 => INS <= doins( iCMP, iDAT8, 16#48#);
      --   error transmitting SLA+R, send again
      when 29 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_Continue);
      --  CMP DAT8 0x50
      --   ack returned (bad) repeat read will occur
      when 30 => INS <= doins( iCMP, iDAT8, 16#58#);
      when 31 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0x50_Data_Received);
      when 32 => INS <= doins( iCMP, iDAT8, 16#E0#);
      when 33 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_0xE0_Stop_transmitted);
      -- $I2C_0x08_Start_Sent
      --   0x08 will always precede an address+W
      when 34 => INS <= doins( iAPBWRT, iDAT8, 1, 16#008#, 82);
      when 35 => INS <= doins( iJUMP, Label_I2C_Continue);
      -- $I2C_0x10_Restart_Sent
      --   0x10 will always precede an address+R (in this design)
      when 36 => INS <= doins( iAPBWRT, iDAT8, 1, 16#008#, 83);
      when 37 => INS <= doins( iJUMP, Label_I2C_Continue);
      -- $I2C_0x18_SLA_W_Sent
      --   0x18 precedes a register address write
      --  I2C_Reg_Addr is set beforehand when state is set
      when 38 => INS <= doins( iRAMREAD, Sym_I2C_Reg_Addr);
      when 39 => INS <= doins( iAPBWRT, iACC, 1, 16#008#);
      when 40 => INS <= doins( iJUMP, Label_I2C_Continue);
      -- $I2C_0x28_Data_Sent
      --   0x28 preceeds another data write (reg_value), repeat start (reg_read), or stop
      --    I2C_State = 0, I2C_Step = 0
      --        write Reg_Value (only occurs during init in this design)
      --    I2C_State = 0, I2C_Step = 1
      --        both Reg_Addr and Reg_Value have been sent, STOP
      --    I2C_State = [1-3]
      --        reading each Light Sensor channel, RepeatStart (fallthrough)
      when 41 => INS <= doins( iRAMREAD, Sym_I2C_State);
      when 42 => INS <= doins( iCMP, iDAT8, 0);
      when 43 => INS <= doins( iJUMP, iIFNOT, iZERO, Label_I2C_RepeatStart);
      when 44 => INS <= doins( iRAMREAD, Sym_I2C_Step);
      when 45 => INS <= doins( iCMP, iDAT8, 1);
      when 46 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_Stop);
      when 47 => INS <= doins( iRAMWRT, Sym_I2C_Step, iDAT8, 1);
      when 48 => INS <= doins( iRAMREAD, Sym_I2C_Reg_Val);
      when 49 => INS <= doins( iAPBWRT, iACC, 1, 16#008#);
      when 50 => INS <= doins( iJUMP, Label_I2C_Continue);
      -- $I2C_0x40_SLA_R_Sent
      --   0x40 precedes receiving the data byte
      --   set ACK response Here
      --   literally just set NACk return, which is done in $I2C_Continue_Read
      when 51 => INS <= doins( iJUMP, Label_I2C_Continue_Read);
      -- $I2C_0x50_Data_Received
      --   0x50 is the last step, stop or stop/start after this
      --    read I2C data and send to storage register (custom VHDL)
      --    increment I2C_State
      when 52 => INS <= doins( iRAMREAD, Sym_I2C_State);
      when 53 => INS <= doins( iCMP, iDAT8, 1);
      when 54 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_CH1_0);
      when 55 => INS <= doins( iCMP, iDAT8, 2);
      when 56 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_CH1_1);
      when 57 => INS <= doins( iCMP, iDAT8, 3);
      when 58 => INS <= doins( iJUMP, iIF, iZERO, Label_I2C_CH0_0);
      --   fallthrough: received CH0_1, prep for CH1_0
      when 59 => INS <= doins( iAPBREAD, 1, 16#008#);
      when 60 => INS <= doins( iAPBWRT, iACC, 2, Sym_Light_Store_CH0_1);
      when 61 => INS <= doins( iRAMWRT, Sym_I2C_Reg_Addr, iDAT, 16#88#);
      when 62 => INS <= doins( iJUMP, Label_I2C_Stop);
      -- $I2C_CH1_0
      --   received CH1_0 prep for CH1_1
      when 63 => INS <= doins( iAPBREAD, 1, 16#008#);
      when 64 => INS <= doins( iAPBWRT, iACC, 2, Sym_Light_Store_CH1_0);
      when 65 => INS <= doins( iRAMWRT, Sym_I2C_Reg_Addr, iDAT, 16#89#);
      when 66 => INS <= doins( iJUMP, Label_I2C_StopStart);
      -- $I2C_CH1_1
      --   received CH1_1 prep for CH0_0
      when 67 => INS <= doins( iAPBREAD, 1, 16#008#);
      when 68 => INS <= doins( iAPBWRT, iACC, 2, Sym_Light_Store_CH1_1);
      when 69 => INS <= doins( iRAMWRT, Sym_I2C_Reg_Addr, iDAT, 16#8A#);
      when 70 => INS <= doins( iJUMP, Label_I2C_StopStart);
      -- $I2C_CH0_0
      --   received CH0_0 prep for CH0_1
      when 71 => INS <= doins( iAPBREAD, 1, 16#008#);
      when 72 => INS <= doins( iAPBWRT, iACC, 2, Sym_Light_Store_CH0_0);
      when 73 => INS <= doins( iRAMWRT, Sym_I2C_Reg_Addr, iDAT, 16#8B#);
      when 74 => INS <= doins( iJUMP, Label_I2C_StopStart);
      when 75 => INS <= doins( iRETISR);
      --  clear interrupt
      --  BEGIN I2C Shared Routines
      -- $I2C_Continue
      --   Clear Int (and also Start and Stop)
      when 76 => INS <= doins( iAPBREAD, 1, 16#00#);
      when 77 => INS <= doins( iAND, iDAT8, 2#11000111#);
      when 78 => INS <= doins( iAPBWRT, iACC, 1, 16#00#);
      when 79 => INS <= doins( iRETISR);
      -- $I2C_Continue_Read
      --   Clear Int (and Start/Stop) Set return NACK
      when 80 => INS <= doins( iAPBREAD, 1, 16#00#);
      when 81 => INS <= doins( iAND, iDAT8, 2#11000011#);
      when 82 => INS <= doins( iAPBWRT, iACC, 1, 16#00#);
      when 83 => INS <= doins( iRETISR);
      -- $I2C_RepeatStart
      --   Set state registers
      when 84 => INS <= doins( iRAMWRT, Sym_I2C_Step, iDAT8, 0);
      --   Clear Int, set Start
      --  RAMWRT I2C_Step DAT8 0
      when 85 => INS <= doins( iAPBREAD, 1, 16#00#);
      when 86 => INS <= doins( iAND, iDAT8, 2#11000111#);
      when 87 => INS <= doins( iOR, iDAT8, 2#00100000#);
      when 88 => INS <= doins( iAPBWRT, iACC, 1, 16#00#);
      when 89 => INS <= doins( iRETISR);
      -- $I2C_StopStart
      --   Set state registers
      --   $I2C_StopStart is only called during the read process, so INC state
      when 90 => INS <= doins( iRAMWRT, Sym_I2C_Step, iDAT8, 0);
      when 91 => INS <= doins( iRAMREAD, Sym_I2C_State);
      when 92 => INS <= doins( iINC);
      when 93 => INS <= doins( iRAMWRT, Sym_I2C_State, iACC);
      --   Clear Int, set Start and Stop
      when 94 => INS <= doins( iAPBREAD, 1, 16#00#);
      when 95 => INS <= doins( iAND, iDAT8, 2#11000111#);
      when 96 => INS <= doins( iOR, iDAT8, 2#00110000#);
      when 97 => INS <= doins( iAPBWRT, iACC, 1, 16#00#);
      when 98 => INS <= doins( iRETISR);
      -- $I2C_Stop
      --   Set state registers
      when 99 => INS <= doins( iRAMWRT, Sym_I2C_Step, iDAT8, 0);
      when 100 => INS <= doins( iRAMWRT, Sym_I2C_State, iDAT8, 1);
      --   Clear Int and set Stop
      when 101 => INS <= doins( iAPBREAD, 1, 16#00#);
      when 102 => INS <= doins( iAND, iDAT8, 2#11000111#);
      when 103 => INS <= doins( iOR, iDAT8, 2#00010000#);
      when 104 => INS <= doins( iAPBWRT, iACC, 1, 16#00#);
      when 105 => INS <= doins( iRETISR);
      -- $I2C_0xE0_Stop_transmitted
      when 106 => INS <= doins( iAPBREAD, 1, 16#00#);
      when 107 => INS <= doins( iAND, iDAT8, 2#11110111#);
      when 108 => INS <= doins( iAPBWRT, iACC, 1, 16#00#);
      when 109 => INS <= doins( iRETISR);
      -- $AbandonShip
      --   Something wrong with transmission
      when 110 => INS <= doins( iRETISR);
      --  END I2C Shared Routines
      --   End Interrupt Service Routine
      --   MAIN HERE
      -- $MAIN
      --   PCLK is 100Mhz
      --   Slot 1 (I2C_C0)
      --   I2C_C0: CTRL      0x00
      --   I2C_C0: STATUS    0x04
      --   I2C_C0: DATA      0x08
      --   I2C_C0: ADDR0     0x0C
      --   I2C_C0: SMBUS     0x10
      --   I2C_C0: ADDR1     0x1C
      --   I2C RAM locations
      --   RAM 0x00
      --    Stores states for overall operation [0 = reg addr, 1 = reg val]
      --   RAM 0x01 Z
      --    Stores states [Init, CH1_0, CH1_1, CH0_0, CH0_1]
      --   RAM 0x02
      --    Stores Reg_Addr
      --   RAM 0x03
      --    Stores Reg_Value
      --   Custom VHDL light sensor registers
      --   Initialize I2C_0 for Light Sensor
      --   PCLK/960 = 0b100; included in enable transfer to save 1 instruction
      --    This is done when Start is set
      --  APBWRT DAT8 1 0x00 0b10000000
      --   Load RAM slots for Light Sensor Init over I2C
      when 111 => INS <= doins( iRAMWRT, Sym_I2C_Step, iDAT8, 0);
      when 112 => INS <= doins( iRAMWRT, Sym_I2C_State, iDAT8, 0);
      when 113 => INS <= doins( iRAMWRT, Sym_I2C_Reg_Addr, iDAT8, 16#80#);
      when 114 => INS <= doins( iRAMWRT, Sym_I2C_Reg_Val, iDAT8, 2#00011001#);
      --   Begin Light Sensor init transfer
      when 115 => INS <= doins( iAPBWRT, iDAT8, 1, 16#00#, 2#11100000#);
      --   SPI_0: CONTROL       0X40001000
      --   SPI_0: TXRXDF_SIZE   0X40001004
      --   SPI_0: STATUS        0X40001008
      --   SPI_0: INT_CLEAR     0X4000100C
      --   SPI_0: RX_DATA       0X40001010
      --   SPI_0: TX_DATA       0X40001014
      --   SPI_0: CLK_GEN       0X40001018
      --   SPI_0: SLAVE_SELECT  0X4000101C
      --   SPI_0: MIS           0X40001020
      --   SPI_0: RIS           0X40001024
      --  APBWRT DAT 4 0x1000 0x30
      when 116 => INS <= doins( iHALT);
      -- $LOOP
      --  Loop forever waiting for interrupts
      when 117 => INS <= doins( iNOP);
      when 118 => INS <= doins( iJUMP, Label_LOOP);
      --   END MAIN
      when others => INS <= ( others => '-');
   end case;
   ---------------------------------------------------------------------------------------------
   -- 8-Bit operation simple core
   when 1 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55#);               -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F#);                -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#05#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- APB Bus Cycles, immediate data
        when 5  => INS <= doins( iLOAD,16#12#);
        when 6  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#12#);
        when 7  => INS <= doins( iAPBREAD, 0,16#10#);
        when 8  => INS <= doins( iCMP,16#12#);
        when 9  => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Accumalator writes
        when 10 => INS <= doins( iLOAD,16#23#);
        when 11 => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 12 => INS <= doins( iAPBREAD, 0,16#20#);
        when 13 => INS <= doins( iCMP,16#23#);
        when 14 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Flag Conditions
        when 15 => INS <= doins( iLOAD,255);                       -- set zero flag
        when 16 => INS <= doins( iINC, 1);
        when 17 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        when 18 => INS <= doins( iINC, 1);                         -- not set
        when 19 => INS <= doins( iCALL,iIF,ZERO,30);
        when 20 => INS <= doins( iCALL,iIF,NEGATIVE,30);           -- number is positive
        -- Big negative value
		when 23 => INS <= doins( iLOAD,0);                              -- Try loading big negative values
        when 24 => INS <= doins( iXOR, -1);
        when 25 => INS <= doins( iINC );                              -- not set
        when 26 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Done tests, jump to signal all done
        when 27 => INS <= doins( iJUMP, 28);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 28 => INS <= doins( iIOWRT, iDAT, 253);
        when 29 => INS <= doins( iJUMP, 29);
        -- Error Condition
        when 30 => INS <= doins( iIOWRT, iDAT, 254);                  -- Error Condition
        when 31 => INS <= doins( iJUMP, 31);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- 16-Bit operation simple core
   when 2 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#1255#);               -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F0F#);                -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#0205#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- APB Bus Cycles, immediate data
        when 5  => INS <= doins( iLOAD,16#1111#);
        when 6  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#1234#);
        when 7  => INS <= doins( iAPBREAD, 0,16#10#);
        when 8  => INS <= doins( iCMP,16#1234#);
        when 9  => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Accumalator writes
        when 10 => INS <= doins( iLOAD,16#2312#);
        when 11 => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 12 => INS <= doins( iAPBREAD, 0,16#20#);
        when 13 => INS <= doins( iCMP,16#2312#);
        when 14 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Flag Conditions
        when 15 => INS <= doins( iLOAD,16#FFFF#);                       -- set zero flag
        when 16 => INS <= doins( iADD, 1);
        when 17 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        when 18 => INS <= doins( iADD, 1);                              -- not set
        when 19 => INS <= doins( iCALL,iIF,ZERO,30);
        when 20 => INS <= doins( iCALL,iIF,NEGATIVE,30);                -- number is positive
        when 21 => INS <= doins( iADD, 16#FFF6#);                       -- will go negative
        when 22 => INS <= doins( iCALL,iNOTIF,NEGATIVE,30);             -- number is positive
        -- Big negative value
		when 23 => INS <= doins( iLOAD,0);                              -- Try loading big negative values
        when 24 => INS <= doins( iXOR, 16#FFFF#);
        when 25 => INS <= doins( iADD, 1);                              -- not set
        when 26 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Done tests, jump to signal all done
        when 27 => INS <= doins( iJUMP, 28);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 28 => INS <= doins( iIOWRT, iDAT, 253);
        when 29 => INS <= doins( iJUMP, 29);
        -- Error Condition
        when 30 => INS <= doins( iIOWRT, iDAT, 254);                          -- Error Condition
        when 31 => INS <= doins( iJUMP, 31);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   ---------------------------------------------------------------------------------------------
   -- 32-Bit operation simple core
   when 3 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#12552345#);                  -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F0F0F0F#);                   -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#02050305#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- APB Bus Cycles, immediate data
        when 5  => INS <= doins( iLOAD,16#1111#);
        when 6  => INS <= doins( iAPBWRT, iDAT,0,16#10#,16#12345678#);
        when 7  => INS <= doins( iAPBREAD, 0,16#10#);
        when 8  => INS <= doins( iCMP,16#12345678#);
        when 9  => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Accumalator writes
        when 10 => INS <= doins( iLOAD,16#23121234#);
        when 11 => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 12 => INS <= doins( iAPBREAD, 0,16#20#);
        when 13 => INS <= doins( iCMP,16#23121234#);
        when 14 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Flag Conditions
        when 15 => INS <= doins( iLOAD,-1);                             -- set zero flag
        when 16 => INS <= doins( iADD, 1);
        when 17 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        when 18 => INS <= doins( iADD, 1);                              -- not set
        when 19 => INS <= doins( iCALL,iIF,ZERO,30);
        when 20 => INS <= doins( iCALL,iIF,NEGATIVE,30);                -- number is positive
        when 21 => INS <= doins( iADD, -8);                             -- will go negative
        when 22 => INS <= doins( iCALL,iNOTIF,NEGATIVE,30);             -- number is positive
        -- Big negative value
		when 23 => INS <= doins( iLOAD,0);                              -- Try loading big negative values
        when 24 => INS <= doins( iXOR, -1);
        when 25 => INS <= doins( iADD, 1);                              -- not set
        when 26 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Done tests, jump to signal all done
        when 27 => INS <= doins( iJUMP, 28);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 28 => INS <= doins( iIOWRT, iDAT, 253);
        when 29 => INS <= doins( iJUMP, 29);
        -- Error Condition
        when 30 => INS <= doins( iIOWRT, iDAT, 254);                          -- Error Condition
        when 31 => INS <= doins( iJUMP, 31);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- 8-Bit operation simple core with RAM
   when 4 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55#);                        -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F#);                         -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#05#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- APB Bus Cycles, immediate data
        when 5  => INS <= doins( iLOAD,16#12#);
        when 6  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#12#);
        when 7  => INS <= doins( iAPBREAD, 0,16#10#);
        when 8  => INS <= doins( iCMP,16#12#);
        when 9  => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Loop Instruction
        when 10 => INS <= doins( iLOAD,0);                              -- Clear accum
        when 11 => INS <= doins( iLOADZ,iDAT, 5);
        when 12 => INS <= doins( iINC);
        when 13 => INS <= doins( iDECZ);
        when 14 => INS <= doins( iJUMP,iNOTIF,ZZERO,12);
        when 15 => INS <= doins( iCMP,16#05#);                          -- Should loop 5 times
        when 16 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Memory Block read and write
        when 17 => INS <= doins( iLOAD,16#12#);
        when 18 => INS <= doins( iRAMWRT,0,iACC);                            -- write and then readback to verify
        when 19 => INS <= doins( iINC);
        when 20 => INS <= doins( iRAMWRT,10,iACC);
        when 21 => INS <= doins( iRAMREAD,0);
        when 22 => INS <= doins( iCMP,16#12#);
        when 23 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        when 24 => INS <= doins( iRAMREAD,10);
        when 25 => INS <= doins( iCMP,16#13#);
        when 26 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Done tests, jump to signal all done
        when 27 => INS <= doins( iJUMP, 28);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 28 => INS <= doins( iIOWRT, iDAT, 253);
        when 29 => INS <= doins( iJUMP, 29);
        -- Error Condition
        when 30 => INS <= doins( iIOWRT, iDAT, 254);                          -- Error Condition
        when 31 => INS <= doins( iJUMP, 31);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- 16-Bit operation simple core with RAM
   when 5 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#5544#);                      -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F0F#);                       -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#0504#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- APB Bus Cycles, immediate data
        when 5  => INS <= doins( iLOAD,16#1111#);
        when 6  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#1234#);
        when 7  => INS <= doins( iAPBREAD, 0,16#10#);
        when 8  => INS <= doins( iCMP,16#1234#);
        when 9  => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Loop Instruction
        when 10 => INS <= doins( iLOAD,0);                              -- Clear accum
        when 11 => INS <= doins( iLOADZ,iDAT, 5);
        when 12 => INS <= doins( iINC);
        when 13 => INS <= doins( iDECZ);
        when 14 => INS <= doins( iJUMP,iNOTIF,ZZERO,12);
        when 15 => INS <= doins( iCMP,16#05#);                          -- Should loop 5 times
        when 16 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Memory Block read and write
        when 17 => INS <= doins( iLOAD,16#1234#);
        when 18 => INS <= doins( iRAMWRT,0,iACC);                             -- write and then readback to verify
        when 19 => INS <= doins( iINC);
        when 20 => INS <= doins( iRAMWRT,10,iACC);
        when 21 => INS <= doins( iRAMREAD,0);
        when 22 => INS <= doins( iCMP,16#1234#);
        when 23 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        when 24 => INS <= doins( iRAMREAD,10);
        when 25 => INS <= doins( iCMP,16#1235#);
        when 26 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Done tests, jump to signal all done
        when 27 => INS <= doins( iJUMP, 28);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 28 => INS <= doins( iIOWRT, iDAT, 253);
        when 29 => INS <= doins( iJUMP, 29);
        -- Error Condition
        when 30 => INS <= doins( iIOWRT, iDAT, 254);                          -- Error Condition
        when 31 => INS <= doins( iJUMP, 31);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- 32-Bit operation simple core with RAM
   when 6 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55443322#);                  -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F0F0F0F#);                   -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#05040302#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- APB Bus Cycles, immediate data
        when 5  => INS <= doins( iLOAD,16#1111#);
        when 6  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#12345678#);
        when 7  => INS <= doins( iAPBREAD, 0,16#10#);
        when 8  => INS <= doins( iCMP,16#12345678#);
        when 9  => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Loop Instruction
        when 10 => INS <= doins( iLOAD,0);                              -- Clear accum
        when 11 => INS <= doins( iLOADZ,iDAT, 5);
        when 12 => INS <= doins( iINC);
        when 13 => INS <= doins( iDECZ);
        when 14 => INS <= doins( iJUMP,iNOTIF,ZZERO,12);
        when 15 => INS <= doins( iCMP,16#05#);                          -- Should loop 5 times
        when 16 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Memory Block read and write
        when 17 => INS <= doins( iLOAD,16#12345678#);
        when 18 => INS <= doins( iRAMWRT,0,iACC);                            -- write and then readback to verify
        when 19 => INS <= doins( iINC);
        when 20 => INS <= doins( iRAMWRT,10,iACC);
        when 21 => INS <= doins( iRAMREAD,0);
        when 22 => INS <= doins( iCMP,16#12345678#);
        when 23 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        when 24 => INS <= doins( iRAMREAD,10);
        when 25 => INS <= doins( iCMP,16#12345679#);
        when 26 => INS <= doins( iJUMP,iNOTIF,ZERO,30);
        -- Done tests, jump to signal all done
        when 27 => INS <= doins( iJUMP, 28);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 28 => INS <= doins( iIOWRT, iDAT, 253);
        when 29 => INS <= doins( iJUMP, 29);
        -- Error Condition
        when 30 => INS <= doins( iIOWRT, iDAT, 254);                          -- Error Condition
        when 31 => INS <= doins( iJUMP, 31);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   ---------------------------------------------------------------------------------------------
   -- Fully Configured 8 bit Operation with 256 instructions
   when 11 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55#);                        -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND, 16#0F#);                        -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP, 16#05#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 5   => INS <= doins( iOR, 16#A2#);
        when 6   => INS <= doins( iCMP,16#A7#);
        when 7   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 8   => INS <= doins( iINC );
        when 9   => INS <= doins( iCMP,16#A8#);
        when 10  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 11  => INS <= doins( iXOR, 16#0F#);
        when 12  => INS <= doins( iCMP,16#A7#);
        when 13  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 14  => INS <= doins( iADD, 16#12#);
        when 15  => INS <= doins( iCMP,16#B9#);
        when 16  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 17  => INS <= doins( iSHL0 );
        when 18  => INS <= doins( iCMP,16#72#);
        when 19  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 20  => INS <= doins( iSHL1 );
        when 21  => INS <= doins( iCMP,16#E5#);
        when 22  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 23  => INS <= doins( iSHR0 );
        when 24  => INS <= doins( iCMP,16#72#);
        when 25  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 26  => INS <= doins( iSHR1 );
        when 27  => INS <= doins( iCMP,16#B9#);
        when 28  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- APB Bus Cycles, immediate data
        when 30  => INS <= doins( iLOAD,16#66#);
        when 31  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#12#);
        when 32  => INS <= doins( iAPBWRT, iDAT, 0,16#11#,16#13#);
        when 33  => INS <= doins( iAPBWRT, iDAT, 1,16#10#,16#14#);
        when 34  => INS <= doins( iAPBWRT, iDAT, 1,16#11#,16#15#);
        when 35  => INS <= doins( iAPBWRT, iDAT, 2,16#10#,16#16#);
        when 36  => INS <= doins( iAPBWRT, iDAT, 2,16#11#,16#17#);
        when 37  => INS <= doins( iAPBWRT, iDAT, 3,16#10#,16#18#);
        when 38  => INS <= doins( iAPBWRT, iDAT, 3,16#11#,chartoint('Z'));
        when 39  => INS <= doins( iAPBREAD, 0,16#10#);
        when 40  => INS <= doins( iCMP,16#12#);
        when 41  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 42  => INS <= doins( iAPBREAD, 0,16#11#);
        when 43  => INS <= doins( iCMP,16#13#);
        when 44  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 45  => INS <= doins( iAPBREAD, 1,16#10#);
        when 46  => INS <= doins( iCMP,16#14#);
        when 47  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 48  => INS <= doins( iAPBREAD, 1,16#11#);
        when 49  => INS <= doins( iCMP,16#15#);
        when 50  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 51  => INS <= doins( iAPBREAD, 2,16#10#);
        when 52  => INS <= doins( iCMP,16#16#);
        when 53  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 54  => INS <= doins( iAPBREAD, 2,16#11#);
        when 55  => INS <= doins( iCMP,16#17#);
        when 56  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 57  => INS <= doins( iAPBREAD, 3,16#10#);
        when 58  => INS <= doins( iCMP,16#18#);
        when 59  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 60  => INS <= doins( iAPBREAD, 3,16#11#);
        when 61  => INS <= doins( iCMP,chartoint('Z'));
        when 62  => INS <= doins( iJUMP,iIFNOT,ZERO,254);     -- other condition
        when 63  => INS <= doins( iCMP,chartoint('Y'));
        when 64  => INS <= doins( iJUMP,iIF,ZERO,254);
        -- Accumalator writes
        when 65 =>  INS <= doins( iLOAD,16#23#);
        when 66  => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 67  => INS <= doins( iINC);
        when 68  => INS <= doins( iAPBWRT, iACC,  0,16#21#);
        when 69  => INS <= doins( iINC);
        when 70  => INS <= doins( iAPBWRT, iACC,  1,16#22#);
        when 71  => INS <= doins( iAPBREAD, 0,16#20#);
        when 72  => INS <= doins( iCMP,16#23#);
        when 73  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 74  => INS <= doins( iAPBREAD, 0,16#21#);
        when 75  => INS <= doins( iCMP,16#24#);
        when 76  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 77  => INS <= doins( iAPBREAD, 1,16#22#);
        when 78  => INS <= doins( iCMP,16#25#);
        when 79  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- ACM writes
        when 81  => INS <= doins( iAPBWRT,iDAT, 0,0,16#54#);                -- initialise APB RAM
        when 82  => INS <= doins( iAPBWRT,iDAT, 0,1,16#55#);                -- initialise APB RAM
        when 83  => INS <= doins( iAPBWRT,iDAT, 0,2,16#56#);                -- initialise APB RAM
        when 84  => INS <= doins( iLOAD,99);                                -- Now the ACM writes
        when 85  => INS <= doins( iAPBWRT, iACM, 0,0);                      -- location 99 lookup
        when 86  => INS <= doins( iINC);
        when 87  => INS <= doins( iAPBWRT, iACM, 0,1);                      -- location 100 lookup
        when 88  => INS <= doins( iINC);
        when 89  => INS <= doins( iAPBWRT, iACM, 0,2);                      -- location 101 lookup
        when 90  => INS <= doins( iAPBREAD, 0,0);
        when 91  => INS <= doins( iCMP,156);                                -- 99=63/=9c=156
        when 92  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 93  => INS <= doins( iAPBREAD, 0,1);
        when 94  => INS <= doins( iCMP,16#55#);                             -- 100 is not written
        when 95  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 96  => INS <= doins( iAPBREAD, 0,2);
        when 97  => INS <= doins( iCMP,154);                                -- 101=65/=9a=154
        when 98  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Flag Conditions
        when 99  => INS <= doins( iLOAD,255);                               -- set zero flag
        when 100 => INS <= doins( iINC);
        when 101 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 102 => INS <= doins( iINC);                                    -- not set
        when 103 => INS <= doins( iJUMP,iIF,ZERO, 254);
        when 104 => INS <= doins( iJUMP,iIF,NEGATIVE,254);                  -- number is positive
        when 105 => INS <= doins( iADD, 16#F6#);                            -- will go negative
        when 106 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);               -- number is positive
        -- Call and Return
        when 107 => INS <= doins( iLOAD,255);                               -- set zero flag
        when 108 => INS <= doins( iINC);
        when 109 => INS <= doins( iCALL,iIF,ZERO, 243);                     -- should call
        when 110 => INS <= doins( iCALL, iNOTIF,ZERO, 242);                 -- should not call
        when 111 => INS <= doins( iCALL,  244);                             -- check return, will return
        when 112 => INS <= doins( iINC);                                    -- Clear zero
        when 113 => INS <= doins( iCALL,iNOTIF,ZERO,243);                   -- should call
        when 114 => INS <= doins( iCALL,iIF,ZERO,242);                      -- should not call
        when 115 => INS <= doins( iCALL,246);                               -- check return, will return
        -- Repeat with Negative flag
        when 116 => INS <= doins( iLOAD,254);                                -- set negative flag
        when 117 => INS <= doins( iINC);
        when 118 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);
        when 119 => INS <= doins( iCALL,iIF,NEGATIVE,243);                  -- should call
        when 120 => INS <= doins( iCALL,iNOTIF,NEGATIVE,242);               -- should not call
        when 121 => INS <= doins( iCALL,248);                               -- check return, will return
        when 122 => INS <= doins( iINC);                                    -- not set
        when 123 => INS <= doins( iJUMP,iIF,NEGATIVE,254);
        when 124 => INS <= doins( iCALL,iNOTIF,NEGATIVE,243);               -- should call
        when 125 => INS <= doins( iCALL,iIF,NEGATIVE,242);                  -- should not call
        when 126 => INS <= doins( iCALL,iNOTIF,ALWAYS,251);                 -- check return, will return
        -- Check Stack calling
        when 130 => INS <= doins( iLOAD,0);                                 -- Clear accum
        when 131 => INS <= doins( iCALL,232);
        when 132 => INS <= doins( iCMP,1);                                  -- Should have incremented by 1
        when 133 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 134 => INS <= doins( iCALL,229);
        when 135 => INS <= doins( iCMP,3);                                  -- Should have incremented by 2
        when 136 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 137 => INS <= doins( iCALL, 226);
        when 138 => INS <= doins( iCMP,6);                                  -- Should have incremented by 3
        when 139 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 140 => INS <= doins( iCALL, 223);
        when 141 => INS <= doins( iCMP,10);                                 -- Should have incremented by 4
        when 142 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Loop Instruction
        when 145 => INS <= doins( iLOAD,0);                                 -- Clear accum
        when 146 => INS <= doins( iLOADZ,iDAT, 5);
        when 147 => INS <= doins( iINC);
        when 148 => INS <= doins( iDECZ);
        when 149 => INS <= doins( iJUMP,iNOTIF,ZZERO,147);
        when 150 => INS <= doins( iCMP,05);                                 -- Should have incremented by 5
        when 151 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Memory Block read and write
        when 155 => INS <= doins( iLOAD,16#45#);                            -- Test Data
        when 156 => INS <= doins( iRAMWRT,0,iACC);                               -- write and then readback to verify
        when 157 => INS <= doins( iINC);
        when 158 => INS <= doins( iRAMWRT,10,iACC);
        when 159 => INS <= doins( iINC);
        when 160 => INS <= doins( iRAMWRT,100,iACC);
        when 161 => INS <= doins( iINC);
        when 162 => INS <= doins( iRAMWRT,250,iACC);
        when 163 => INS <= doins( iRAMREAD,0);
        when 164 => INS <= doins( iCMP,16#45#);
        when 165 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 166 => INS <= doins( iRAMREAD,10);
        when 167 => INS <= doins( iCMP,16#46#);
        when 168 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 169 => INS <= doins( iRAMREAD,100);
        when 170 => INS <= doins( iCMP,16#47#);
        when 171 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 172 => INS <= doins( iRAMREAD,250);
        when 173 => INS <= doins( iCMP,16#48#);
        when 174 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- test additional shift and rotate instructions
        -- Simple Test of Boolean Operations
        when 180   => INS <= doins( iLOAD,16#15#);                          -- Set Accumalator to 15hex
        when 181   => INS <= doins( iSHL0 );                                -- SHIFT <= 0
        when 182   => INS <= doins( iCMP, 16#2A#);
        when 183   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 184   => INS <= doins( iSHL1 );                                -- SHIFT <= 1
        when 185   => INS <= doins( iCMP, 16#55#);
        when 186   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 187   => INS <= doins( iSHLE);                                 -- SHIFT <= EXTEND
        when 188   => INS <= doins( iCMP, 16#AB#);
        when 189   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 191   => INS <= doins( iROL );                                 -- SHIFT <= ROTATE
        when 192   => INS <= doins( iCMP, 16#57#);
        when 193   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 194   => INS <= doins( iLOAD,16#15#);                          -- Set Accumalator to 15hex
        when 195   => INS <= doins( iSHR0 );                                -- SHIFT => 0
        when 196   => INS <= doins( iCMP, 16#0A#);
        when 197   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 198   => INS <= doins( iSHR1 );                                -- SHIFT => 1
        when 199   => INS <= doins( iCMP, 16#85#);
        when 200   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 201   => INS <= doins( iSHRE);                                 -- SHIFT => EXTEND
        when 202   => INS <= doins( iCMP, 16#C2#);
        when 203   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 204   => INS <= doins( iROR);                                  -- SHIFT => ROTATE
        when 205   => INS <= doins( iCMP, 16#61#);
        when 206   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        ----------------------------------------------------------------------------------
        -- WAIT instruction
        when 207 => INS <= doins( iIOWRT, iDAT, 16#00#);                     -- IO_IN is connected to IO_OUT
        when 208 => INS <= doins( iWAIT,iIF,INPUT0 );                        -- wait if flag 0 set its not !
        when 209 => INS <= doins( iIOWRT, iDAT, 16#01#);                     -- IO_IN is connected to IO_OUT
        when 210 => INS <= doins( iWAIT,iNOTIF,INPUT0 );                     -- wait if flag 0 set its set !
        -- Test SUB
        when 211 => INS <= doins( iLOAD, 100);
        when 212 => INS <= doins( iSUB, 1);
        when 213 => INS <= doins( iCMP, 99);
        when 214 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 215 => INS <= doins( iSUB, 95);
        when 216 => INS <= doins( iCMP, 4);
        when 217 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Jump to ISR tests
        when 218 => INS <= doins( iJUMP, 300);
        ----------------------------------------------------------------------------------
        -- ISR testing
        when 300 => INS <= doins( iLOAD,16#12#);                        -- Put 12 in memory location 1
        when 301 => INS <= doins( iRAMWRT,1,iACC);
        when 302 => INS <= doins( iCMP, 16#12#);                        -- set zero flag
        when 303 => INS <= doins( iJUMP,iNOTIF,ZERO,254);               -- ZERO flag should still be set before ISR
        when 304 => INS <= doins( iIOWRT, iDAT, 249);                   -- route INTACT to flag input
        when 305 => INS <= doins( iIOWRT, iDAT, 251);                   -- Cause interrupt to occur
        when 306 => INS <= doins( iNOP);
        when 307 => INS <= doins( iNOP);
        when 308 => INS <= doins( iJUMP,iNOTIF,ZERO,254);               -- ZERO flag should still be set after ISR
        when 309 => INS <= doins( iRAMREAD,1);                          -- Verify that ISR called once only
        when 310 => INS <= doins( iCMP, 16#13#);
        when 311 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 312 => INS <= doins( iIOWRT, iDAT, 250);                   -- route IO_OUT to flag input
        when 313 => INS <= doins( iJUMP,410);
        -- The ISR Service Routine
        when 400 => INS <= doins( iPUSH);                               -- store the accumalator
        when 401 => INS <= doins( iIOWRT, iDAT, 252);                   -- Clear the external interrupt
        when 402 => INS <= doins( iRAMREAD,1);                          -- increment the value at location 1
        when 403 => INS <= doins( iINC);                                --
        when 404 => INS <= doins( iRAMWRT,1,iACC);                      -- write it back, zero flag is not set
        when 405 => INS <= doins( iJUMP,iNOTIF,INPUT0,254);             -- INTACT should be set
        when 406 => INS <= doins( iCALL,223);                           -- Do a normal call
        when 407 => INS <= doins( iJUMP,iNOTIF,INPUT0,254);             -- INTACT should still be set
        when 408 => INS <= doins( iPOP);                                -- Restore the accumlator
        when 409 => INS <= doins( iRETISR);
        ----------------------------------------------------------------------------------
        -- 2.3 Added Instructions Testing
        when 410 => INS <= doins( iLOAD,iDAT,16#55#);           -- use new immediate instruction
        when 411 => INS <= doins( iAND, iDAT,16#0F#);
        when 412 => INS <= doins( iCMP, iDAT,16#05#);
        when 413 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 414 => INS <= doins( iOR, iDAT,16#A2#);
        when 415 => INS <= doins( iCMP,iDAT,16#A7#);
        when 416 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 417 => INS <= doins( iINC );
        when 418 => INS <= doins( iCMP,iDAT,16#A8#);
        when 419 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 420 => INS <= doins( iXOR,iDAT,16#0F#);
        when 421 => INS <= doins( iCMP,iDAT,16#A7#);
        when 422 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 423 => INS <= doins( iADD,iDAT,16#12#);
        when 424 => INS <= doins( iCMP,iDAT,16#B9#);
        when 425 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 426 => INS <= doins( iCMP,16#B9#);
        when 427 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 430 => INS <= doins( iRAMWRT,0,iDAT,16#55#);         -- put data in RAM
        when 431 => INS <= doins( iRAMWRT,1,iDAT,16#0F#);
        when 432 => INS <= doins( iRAMWRT,2,iDAT,16#05#);
        when 433 => INS <= doins( iRAMWRT,3,iDAT,16#A2#);
        when 434 => INS <= doins( iRAMWRT,4,iDAT,16#A7#);
        when 435 => INS <= doins( iRAMWRT,5,iDAT,16#A8#);
        when 436 => INS <= doins( iRAMWRT,6,iDAT,16#0F#);
        when 437 => INS <= doins( iRAMWRT,7,iDAT,16#12#);
        when 438 => INS <= doins( iRAMWRT,8,iDAT,16#b9#);
                                                              --RAM based instructions
        when 439 => INS <= doins( iLOAD,iRAM,0);              --iLOAD,iDAT,16#55#);
        when 440 => INS <= doins( iAND, iRAM,1);              --iAND, iDAT,16#0F#);
        when 441 => INS <= doins( iCMP, iRAM,2);              --iCMP, iDAT,16#05#);
        when 442 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 443 => INS <= doins( iOR, iRAM,3);               --iOR, iDAT,16#A2#);
        when 444 => INS <= doins( iCMP,iRAM,4);               --iCMP,iDAT,16#A7#);
        when 445 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 446 => INS <= doins( iINC );
        when 447 => INS <= doins( iCMP,iRAM,5);               --iCMP,iDAT,16#A8#);
        when 448 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 449 => INS <= doins( iXOR,iRAM,6);               --iXOR,iDAT,16#0F#);
        when 450 => INS <= doins( iCMP,iRAM,4);               --iCMP,iDAT,16#A7#);
        when 451 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 452 => INS <= doins( iADD,iRAM,7);               --iADD,iDAT,16#12#);
        when 453 => INS <= doins( iCMP,iRAM,8);               --iCMP,iDAT,16#B9#);
        when 454 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 455 => INS <= doins( iCMP,16#B9#);
        when 456 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 470 => INS <= doins( iIOWRT, iDAT,16#32#);        -- Test New IO Instructions
        when 471 => INS <= doins( iIOREAD);                    -- Check old write and read
        when 472 => INS <= doins( iCMP,16#32#);
        when 473 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 474 => INS <= doins( iLOAD,iDAT,16#47#);
        when 475 => INS <= doins( iIOWRT,iACC);                -- New instruction and read
        when 476 => INS <= doins( iLOAD,iDAT,0);
        when 477 => INS <= doins( iIOREAD);
        when 478 => INS <= doins( iCMP,16#47#);
        when 479 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 480 => INS <= doins( iLOAD,iDAT,16#77#);          -- PUSH Immediate data
        when 481 => INS <= doins( iPUSH,iACC);
        when 482 => INS <= doins( iPUSH,iDAT,16#89#);
        when 483 => INS <= doins( iPOP);
        when 484 => INS <= doins( iCMP,16#89#);
        when 485 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 486 => INS <= doins( iPOP);
        when 487 => INS <= doins( iCMP,16#77#);
        when 488 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Loop Instruction
        when 490 => INS <= doins( iLOAD,5);                      -- accum=5
        when 491 => INS <= doins( iLOADZ,iACC);
        when 492 => INS <= doins( iINC);
        when 493 => INS <= doins( iDECZ);
        when 494 => INS <= doins( iJUMP,iNOTIF,ZZERO,492);
        when 495 => INS <= doins( iCMP,10);                      -- Should have incremented by 5
        when 496 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- WAIT instruction with switching input
        when 498 => INS <= doins( iIOWRT, iDAT, 249);                  -- This will assert input for 20 clocks
        when 499 => INS <= doins( iJUMP,iNOTIF,INPUT1,254);            -- Make sure is set
        when 500 => INS <= doins( iWAIT,iIF,INPUT1 );                  -- Should sit here for 20 clocks
        when 501 => INS <= doins( iJUMP,iIF,INPUT1,254);               -- Make sure is cleared
        when 502 => INS <= doins( iIOWRT, iDAT, 250);                  -- route IO_OUT to flag input
        -- Multiply and DEC
        when 503 => INS <= doins( iLOAD,3);
        when 504 => INS <= doins( iMULT,iDAT,3);
        when 505 => INS <= doins( iRAMWRT,15,iDAT,4);
        when 506 => INS <= doins( iMULT,iRAM,15);
        when 507 => INS <= doins( iDEC);
        when 508 => INS <= doins( iCMP,35);
        when 509 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Multiply Example
        when 510 => INS <= doins( iRAMWRT,0,iDAT,12);       -- A
        when 511 => INS <= doins( iRAMWRT,1,iDAT,13);       -- B
        when 512 => INS <= doins( iRAMWRT,2,iDAT,0);        -- P=Answer
        when 513 => INS <= doins( iLOADZ,iDAT,8);
        when 514 => INS <= doins( iRAMREAD,0);              -- Get A
        when 515 => INS <= doins( iBITTST,0);               -- See if bit 0 set
        when 516 => INS <= doins( iJUMP,iIF,iZERO,520);
        when 517 => INS <= doins( iRAMREAD,2);              -- Get P
        when 518 => INS <= doins( iADD,iRAM,1);             -- ADD B
        when 519 => INS <= doins( iRAMWRT,2,iACC);          -- Save
        when 520 => INS <= doins( iRAMREAD,1);              -- Shift B
        when 521 => INS <= doins( iSHL0);                   --  *2
        when 522 => INS <= doins( iRAMWRT,1,iACC);          --
        when 523 => INS <= doins( iRAMREAD,0);              -- Shift A
        when 524 => INS <= doins( iSHR0);                   --
        when 525 => INS <= doins( iRAMWRT,0,iACC);          -- Save
        when 526 => INS <= doins( iDECZ);                -- Do for all bits
        when 527 => INS <= doins( iJUMP,iIFNOT,iZZERO,514);
        when 528 => INS <= doins( iRAMREAD,2);              -- Get P
        when 529 => INS <= doins( iCMP,156);                -- 12*13 should be 156
        when 530 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
         -- Loop Increment Instruction
        when 531 => INS <= doins( iLOAD,0);                  -- Clear accum
        when 532 => INS <= doins( iLOADZ,iDAT,251);
        when 533 => INS <= doins( iINC);
        when 534 => INS <= doins( iINCZ);
        when 535 => INS <= doins( iJUMP,iNOTIF,ZZERO,533);
        when 536 => INS <= doins( iCMP,16#05#);              -- Should loop 5 times
        when 537 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
	  	-- Indirect Addressing
        when 540 => INS <= doins( iLOADZ,iDAT,10);
        when 541 => INS <= doins( iAPBWRTZ, iDAT, 0,16#12#);  -- Write 12 to slot 0  @LOOP=10
        when 542 => INS <= doins( iINCZ);
        when 543 => INS <= doins( iAPBWRTZ, iDAT, 0,16#15#);  -- Write 15 to slot 0  @LOOP=11
	    when 544 => INS <= doins( iAPBREAD, 0,10);            -- Read the location
        when 545 => INS <= doins( iCMP,16#12#);
        when 546 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
	    when 547 => INS <= doins( iAPBREAD, 0,11);            -- Read the location
        when 548 => INS <= doins( iCMP,16#15#);
        when 549 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 550 => INS <= doins( iINCZ);
        when 551 => INS <= doins( iLOAD,33);                  --
        when 552 => INS <= doins( iAPBWRTZ, iACC, 0);         -- Write ACC to slot 0  @LOOP=12
	    when 553 => INS <= doins( iAPBREAD, 0,12);            -- Read the location
        when 554 => INS <= doins( iCMP,33);
        when 555 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 556 => INS <= doins( iINCZ);
        when 557 => INS <= doins( iLOAD,1);                   -- ACM location 1 will be 254
        when 558 => INS <= doins( iAPBWRTZ, iACM, 0);         -- Write ACM to slot 0  @LOOP=13
	    when 559 => INS <= doins( iAPBREAD, 0,13);            -- Read the location
        when 560 => INS <= doins( iCMP,254);
        when 561 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 562 => INS <= doins( iLOADZ,iDAT,10);		      -- check indirect reads
	    when 563 => INS <= doins( iAPBREADZ, 0);              -- Read the location
        when 564 => INS <= doins( iCMP,16#12#);
        when 565 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 566 => INS <= doins( iINCZ);
	    when 567 => INS <= doins( iAPBREADZ, 0);              -- Read the location
        when 568 => INS <= doins( iCMP,16#15#);
	    when 569 => INS <= doins( iAPBREAD, 0,11);             -- Read the location
        when 570 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- test the ADDZ and DECZ instructions
		when 571 => INS <= doins( iLOADZ,iDAT,10);
        when 572 => INS <= doins( iSUBZ ,iDAT,10);
        when 573 => INS <= doins( iJUMP,iNOTIF,ZZERO,254);
        when 574 => INS <= doins( iLOADZ,iDAT,16#FE#);
        when 575 => INS <= doins( iADDZ ,iDAT,2);
        when 576 => INS <= doins( iJUMP,iNOTIF,ZZERO,254);
        when 577 => INS <= doins( iLOAD,iDAT,3);
        when 578 => INS <= doins( iLOADZ,iDAT,16#FD#);
        when 579 => INS <= doins( iADDZ ,iACC);
        when 580 => INS <= doins( iJUMP,iNOTIF,ZZERO,254);
        -- Done tests, jump to signal all done
        when 582 => INS <= doins( iJUMP,240);
        ----------------------------------------------------------------------------------
        -- Call testing
        when 223 => INS <= doins( iINC);
        when 224 => INS <= doins( iCALL, 226);
        when 225 => INS <= doins( iRETURN);
        when 226 => INS <= doins( iINC);
        when 227 => INS <= doins( iCALL,229);
        when 228 => INS <= doins( iRETURN);
        when 229 => INS <= doins( iINC);
        when 230 => INS <= doins( iCALL,232);
        when 231 => INS <= doins( iRETURN);
        when 232 => INS <= doins( iINC);
        when 233 => INS <= doins( iAPBWRT,iACC,1,0); -- cause internal ADDR to switch
        when 234 => INS <= doins( iRETURN);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 240 => INS <= doins( iIOWRT, iDAT, 253);
        when 241 => INS <= doins( iJUMP,241);
        -- If called here error
        when 242 => INS <= doins( iJUMP,254);
        ------------------------------------------------------------------------------------
        -- If called here return
        when 243 => INS <= doins( iRETURN);
        -- If called here return on zero
        when 244 => INS <= doins( iRETURN,iIF,ZERO);
        when 245 => INS <= doins( iJUMP,254);
        -- If called here return on NOT zero
        when 246 => INS <= doins( iRETURN,iNOTIF,ZERO);
        when 247 => INS <= doins( iJUMP,254);
        -- If called here return on negative
        when 248 => INS <= doins( iRETURN,iIF,NEGATIVE);
        when 249 => INS <= doins( iJUMP,254);
        -- If called here return on NOT negative
        when 250 => INS <= doins( iRETURN,iNOTIF,NEGATIVE);
        when 251 => INS <= doins( iJUMP,254);
        -- Error Condition
        when 254 => INS <= doins( iIOWRT, iDAT, 254);                          -- Error Condition
        when 255 => INS <= doins( iJUMP,251);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- Fully Configured 16 bit Operation with 256 instructions
   when 12 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#4455#);                      -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F0F#);                       -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#0405#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 5   => INS <= doins( iOR, 16#C0A2#);
        when 6   => INS <= doins( iCMP,16#C4A7#);
        when 7   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 8   => INS <= doins( iINC );
        when 9   => INS <= doins( iCMP,16#C4A8#);
        when 10  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 11  => INS <= doins( iXOR, 16#0F0F#);
        when 12  => INS <= doins( iCMP,16#CBA7#);
        when 13  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 14  => INS <= doins( iADD, 16#1012#);
        when 15  => INS <= doins( iCMP,16#DBB9#);
        when 16  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 17  => INS <= doins( iSHL0 );
        when 18  => INS <= doins( iCMP,16#b772#);
        when 19  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 20  => INS <= doins( iSHL1 );
        when 21  => INS <= doins( iCMP,16#6eE5#);
        when 22  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 23  => INS <= doins( iSHR0 );
        when 24  => INS <= doins( iCMP,16#3772#);
        when 25  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 26  => INS <= doins( iSHR1 );
        when 27  => INS <= doins( iCMP,16#9bB9#);
        when 28  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- APB Bus Cycles, immediate data
        when 30  => INS <= doins( iLOAD,16#12#);
        when 31  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#2112#);
        when 32  => INS <= doins( iAPBWRT, iDAT, 0,16#11#,16#3113#);
        when 33  => INS <= doins( iAPBWRT, iDAT, 1,16#12#,16#4114#);
        when 34  => INS <= doins( iAPBWRT, iDAT, 1,16#13#,16#5115#);
        when 35  => INS <= doins( iAPBWRT, iDAT, 2,16#14#,16#6116#);
        when 36  => INS <= doins( iAPBWRT, iDAT, 2,16#15#,16#7117#);
        when 37  => INS <= doins( iAPBWRT, iDAT, 3,16#10#,16#8118#);
        when 38  => INS <= doins( iAPBWRT, iDAT, 3,16#11#,16#9119#);
        when 39  => INS <= doins( iAPBREAD, 0,16#10#);
        when 40  => INS <= doins( iCMP,16#2112#);
        when 41  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 42  => INS <= doins( iAPBREAD, 0,16#11#);
        when 43  => INS <= doins( iCMP,16#3113#);
        when 44  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 45  => INS <= doins( iAPBREAD, 1,16#12#);
        when 46  => INS <= doins( iCMP,16#4114#);
        when 47  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 48  => INS <= doins( iAPBREAD, 1,16#13#);
        when 49  => INS <= doins( iCMP,16#5115#);
        when 50  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 51  => INS <= doins( iAPBREAD, 2,16#14#);
        when 52  => INS <= doins( iCMP,16#6116#);
        when 53  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 54  => INS <= doins( iAPBREAD, 2,16#15#);
        when 55  => INS <= doins( iCMP,16#7117#);
        when 56  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 57  => INS <= doins( iAPBREAD, 3,16#10#);
        when 58  => INS <= doins( iCMP,16#8118#);
        when 59  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 60  => INS <= doins( iAPBREAD, 3,16#11#);
        when 61  => INS <= doins( iCMP,16#9119#);
        when 62  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Accumalator writes
        when 65 =>  INS <= doins( iLOAD,16#5023#);
        when 66  => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 67  => INS <= doins( iINC);
        when 68  => INS <= doins( iAPBWRT, iACC,  0,16#21#);
        when 69  => INS <= doins( iINC);
        when 70  => INS <= doins( iAPBWRT, iACC,  1,16#22#);
        when 71  => INS <= doins( iAPBREAD, 0,16#20#);
        when 72  => INS <= doins( iCMP,16#5023#);
        when 73  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 74  => INS <= doins( iAPBREAD, 0,16#21#);
        when 75  => INS <= doins( iCMP,16#5024#);
        when 76  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 77  => INS <= doins( iAPBREAD, 1,16#22#);
        when 78  => INS <= doins( iCMP,16#5025#);
        when 79  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- ACM writes
        when 81  => INS <= doins( iAPBWRT, iDAT, 0,0,16#54#);               -- initialise APB RAM
        when 82  => INS <= doins( iAPBWRT, iDAT, 0,1,16#55#);               -- initialise APB RAM
        when 83  => INS <= doins( iAPBWRT, iDAT, 0,2,16#56#);               -- initialise APB RAM
        when 84  => INS <= doins( iLOAD,99);                                -- Now the ACM writes
        when 85  => INS <= doins( iAPBWRT, iACM, 0,0);                      -- location 99 lookup
        when 86  => INS <= doins( iINC);
        when 87  => INS <= doins( iAPBWRT, iACM, 0,1);                      -- location 100 lookup
        when 88  => INS <= doins( iINC);
        when 89  => INS <= doins( iAPBWRT, iACM, 0,2);                      -- location 101 lookup
        when 90  => INS <= doins( iAPBREAD, 0,0);
        when 91  => INS <= doins( iAND,16#00FF#);
        when 92  => INS <= doins( iCMP,156);                                -- 99=63/=9c=156
        when 93  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 94  => INS <= doins( iAPBREAD, 0,1);
        when 95  => INS <= doins( iAND,16#00FF#);
        when 96  => INS <= doins( iCMP,16#55#);                             -- 100 is not written
        when 97  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Flag Conditions
        when 99  => INS <= doins( iLOAD,16#FFFF#);                          -- set zero flag
        when 100 => INS <= doins( iINC);
        when 101 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 102 => INS <= doins( iINC);                                    -- not set
        when 103 => INS <= doins( iJUMP,iIF,ZERO, 254);
        when 104 => INS <= doins( iJUMP,iIF,NEGATIVE,254);                  -- number is positive
        when 105 => INS <= doins( iADD, 16#FFF6#);                          -- will go negative
        when 106 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);               -- number is positive
        -- Call and Return
        when 107 => INS <= doins( iLOAD,16#FFFF#);                          -- set zero flag
        when 108 => INS <= doins( iINC);
        when 109 => INS <= doins( iCALL,iIF,ZERO, 243);                     -- should call
        when 110 => INS <= doins( iCALL, iNOTIF,ZERO, 242);                 -- should not call
        when 111 => INS <= doins( iCALL,  244);                             -- check return, will return
        when 112 => INS <= doins( iINC);                                    -- Clear zero
        when 113 => INS <= doins( iCALL,iNOTIF,ZERO,243);                   -- should call
        when 114 => INS <= doins( iCALL,iIF,ZERO,242);                      -- should not call
        when 115 => INS <= doins( iCALL,246);                               -- check return, will return
        -- Repeat with Negative flag
        when 116 => INS <= doins( iLOAD,16#FFFE#);                          -- set negative flag
        when 117 => INS <= doins( iINC);
        when 118 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);
        when 119 => INS <= doins( iCALL,iIF,NEGATIVE,243);                  -- should call
        when 120 => INS <= doins( iCALL,iNOTIF,NEGATIVE,242);               -- should not call
        when 121 => INS <= doins( iCALL,248);                               -- check return, will return
        when 122 => INS <= doins( iINC);                                    -- not set
        when 123 => INS <= doins( iJUMP,iIF,NEGATIVE,254);
        when 124 => INS <= doins( iCALL,iNOTIF,NEGATIVE,243);               -- should call
        when 125 => INS <= doins( iCALL,iIF,NEGATIVE,242);                  -- should not call
        when 126 => INS <= doins( iCALL,iNOTIF,ALWAYS,251);                 -- check return, will return
        -- Check Stack calling
        when 130 => INS <= doins( iLOAD,0);                                 -- Clear accum
        when 131 => INS <= doins( iCALL,232);
        when 132 => INS <= doins( iCMP,1);                                  -- Should have incremented by 1
        when 133 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 134 => INS <= doins( iCALL,229);
        when 135 => INS <= doins( iCMP,3);                                  -- Should have incremented by 2
        when 136 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 137 => INS <= doins( iCALL, 226);
        when 138 => INS <= doins( iCMP,6);                                  -- Should have incremented by 3
        when 139 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 140 => INS <= doins( iCALL, 223);
        when 141 => INS <= doins( iCMP,10);                                 -- Should have incremented by 4
        when 142 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Loop Instruction
        when 145 => INS <= doins( iLOAD,0);                                 -- Clear accum
        when 146 => INS <= doins( iLOADZ,iDAT, 5);
        when 147 => INS <= doins( iINC);
        when 148 => INS <= doins( iDECZ);
        when 149 => INS <= doins( iJUMP,iNOTIF,ZZERO,147);
        when 150 => INS <= doins( iCMP,05);                                 -- Should have incremented by 5
        when 151 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Memory Block read and write
        when 155 => INS <= doins( iLOAD,16#1245#);                          -- Test Data
        when 156 => INS <= doins( iRAMWRT,0,iACC);                               -- write and then readback to verify
        when 157 => INS <= doins( iINC);
        when 158 => INS <= doins( iRAMWRT,10,iACC);
        when 159 => INS <= doins( iINC);
        when 160 => INS <= doins( iRAMWRT,100,iACC);
        when 161 => INS <= doins( iINC);
        when 162 => INS <= doins( iRAMWRT,250,iACC);
        when 163 => INS <= doins( iRAMREAD,0);
        when 164 => INS <= doins( iCMP,16#1245#);
        when 165 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 166 => INS <= doins( iRAMREAD,10);
        when 167 => INS <= doins( iCMP,16#1246#);
        when 168 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 169 => INS <= doins( iRAMREAD,100);
        when 170 => INS <= doins( iCMP,16#1247#);
        when 171 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 172 => INS <= doins( iRAMREAD,250);
        when 173 => INS <= doins( iCMP,16#1248#);
        when 174 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Done tests, jump to signal all done
        when 180 => INS <= doins( iCALL,240);
        ----------------------------------------------------------------------------------
        -- Call testing
        when 223 => INS <= doins( iINC);
        when 224 => INS <= doins( iCALL, 226);
        when 225 => INS <= doins( iRETURN);
        when 226 => INS <= doins( iINC);
        when 227 => INS <= doins( iCALL,229);
        when 228 => INS <= doins( iRETURN);
        when 229 => INS <= doins( iINC);
        when 230 => INS <= doins( iCALL,232);
        when 231 => INS <= doins( iRETURN);
        when 232 => INS <= doins( iINC);
        when 233 => INS <= doins( iNOP);
        when 234 => INS <= doins( iRETURN);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 240 => INS <= doins( iIOWRT, iDAT, 253);
        when 241 => INS <= doins( iJUMP,241);
        -- If called here error
        when 242 => INS <= doins( iJUMP,254);
        ------------------------------------------------------------------------------------
        -- If called here return
        when 243 => INS <= doins( iRETURN);
        -- If called here return on zero
        when 244 => INS <= doins( iRETURN,iIF,ZERO);
        when 245 => INS <= doins( iJUMP,254);
        -- If called here return on NOT zero
        when 246 => INS <= doins( iRETURN,iNOTIF,ZERO);
        when 247 => INS <= doins( iJUMP,254);
        -- If called here return on negative
        when 248 => INS <= doins( iRETURN,iIF,NEGATIVE);
        when 249 => INS <= doins( iJUMP,254);
        -- If called here return on NOT negative
        when 250 => INS <= doins( iRETURN,iNOTIF,NEGATIVE);
        when 251 => INS <= doins( iJUMP,254);
        -- Error Condition
        when 254 => INS <= doins( iIOWRT, iDAT, 254);                             -- Error Condition
        when 255 => INS <= doins( iJUMP,251);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- Fully Configured 32 bit Operation with 256 instructions
   when 13 =>   -- 32 bit
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#12344455#);                      -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F0F0F0F#);                       -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#02040405#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 5   => INS <= doins( iOR, 16#4000C0A2#);
        when 6   => INS <= doins( iCMP,16#4204C4A7#);
        when 7   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 8   => INS <= doins( iINC );
        when 9   => INS <= doins( iCMP,16#4204C4A8#);
        when 10  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 11  => INS <= doins( iXOR, 16#10F00F0F#);
        when 12  => INS <= doins( iCMP,16#52f4CBA7#);
        when 13  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 14  => INS <= doins( iADD, 16#03001012#);
        when 15  => INS <= doins( iCMP,16#55F4DBB9#);
        when 16  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 17  => INS <= doins( iAND,16#0FFFFFFF#);                       -- make sure MSB's are zero
        when 18  => INS <= doins( iSHL0 );
        when 19  => INS <= doins( iCMP,16#0BE9b772#);
        when 20  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 21  => INS <= doins( iSHL1 );
        when 22  => INS <= doins( iCMP,16#17D36EE5#);
        when 23  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 24  => INS <= doins( iSHR0 );
        when 25  => INS <= doins( iCMP,16#0BE9B772#);
        when 26  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 27  => INS <= doins( iSHR1 );
        when 28  => INS <= doins( iSHR0 );
        when 29  => INS <= doins( iCMP,16#42fa6ddc#);
        when 30  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- APB Bus Cycles, immediate data
        when 31  => INS <= doins( iLOAD,16#12#);
        when 32  => INS <= doins( iAPBWRT,iDAT,0,16#10#,16#20002112#);
        when 33  => INS <= doins( iAPBWRT,iDAT,0,16#11#,16#30003113#);
        when 34  => INS <= doins( iAPBWRT,iDAT,1,16#12#,16#40004114#);
        when 35  => INS <= doins( iAPBWRT,iDAT,1,16#13#,16#50005115#);
        when 36  => INS <= doins( iAPBWRT,iDAT,2,16#14#,16#60006116#);
        when 37  => INS <= doins( iAPBWRT,iDAT,2,16#15#,16#70007117#);
        when 38  => INS <= doins( iAPBWRT,iDAT,3,16#10#,16#08008118#);
        when 39  => INS <= doins( iAPBWRT,iDAT,3,16#11#,16#09009119#);
        when 40  => INS <= doins( iAPBREAD, 0,16#10#);
        when 41  => INS <= doins( iCMP,16#20002112#);
        when 42  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 43  => INS <= doins( iAPBREAD, 0,16#11#);
        when 44  => INS <= doins( iCMP,16#30003113#);
        when 45  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 46  => INS <= doins( iAPBREAD, 1,16#12#);
        when 47  => INS <= doins( iCMP,16#40004114#);
        when 48  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 49  => INS <= doins( iAPBREAD, 1,16#13#);
        when 50  => INS <= doins( iCMP,16#50005115#);
        when 51  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 52  => INS <= doins( iAPBREAD, 2,16#14#);
        when 53  => INS <= doins( iCMP,16#60006116#);
        when 54  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 55  => INS <= doins( iAPBREAD, 2,16#15#);
        when 56  => INS <= doins( iCMP,16#70007117#);
        when 57  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 58  => INS <= doins( iAPBREAD, 3,16#10#);
        when 59  => INS <= doins( iCMP,16#08008118#);
        when 60  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 61  => INS <= doins( iAPBREAD, 3,16#11#);
        when 62  => INS <= doins( iCMP,16#09009119#);
        when 63  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Accumalator writes
        when 65 =>  INS <= doins( iLOAD,16#12345023#);
        when 66  => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 67  => INS <= doins( iINC);
        when 68  => INS <= doins( iAPBWRT, iACC,  0,16#21#);
        when 69  => INS <= doins( iINC);
        when 70  => INS <= doins( iAPBWRT, iACC,  1,16#22#);
        when 71  => INS <= doins( iAPBREAD, 0,16#20#);
        when 72  => INS <= doins( iCMP,16#12345023#);
        when 73  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 74  => INS <= doins( iAPBREAD, 0,16#21#);
        when 75  => INS <= doins( iCMP,16#12345024#);
        when 76  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 77  => INS <= doins( iAPBREAD, 1,16#22#);
        when 78  => INS <= doins( iCMP,16#12345025#);
        when 79  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- ACM writes
        when 81  => INS <= doins( iAPBWRT, iDAT,0,0,16#54#);                -- initialise APB RAM
        when 82  => INS <= doins( iAPBWRT, iDAT,0,1,16#55#);                -- initialise APB RAM
        when 83  => INS <= doins( iAPBWRT, iDAT,0,2,16#56#);                -- initialise APB RAM
        when 84  => INS <= doins( iLOAD,99);                                -- Now the ACM writes
        when 85  => INS <= doins( iAPBWRT, iACM, 0,0);                      -- location 99 lookup
        when 86  => INS <= doins( iINC);
        when 87  => INS <= doins( iAPBWRT, iACM, 0,1);                      -- location 100 lookup
        when 88  => INS <= doins( iINC);
        when 89  => INS <= doins( iAPBWRT, iACM, 0,2);                      -- location 101 lookup
        when 90  => INS <= doins( iAPBREAD, 0,0);
        when 91  => INS <= doins( iAND,16#000000FF#);
        when 92  => INS <= doins( iCMP,156);                                -- 99=63/=9c=156
        when 93  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 94  => INS <= doins( iAPBREAD, 0,1);
        when 95  => INS <= doins( iAND,16#000000FF#);
        when 96  => INS <= doins( iCMP,16#55#);                             -- 100 is not written
        when 97  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Flag Conditions
        when 99  => INS <= doins( iLOAD,-1);                                -- set zero flag
        when 100 => INS <= doins( iINC);
        when 101 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 102 => INS <= doins( iINC);                                    -- not set
        when 103 => INS <= doins( iJUMP,iIF,ZERO, 254);
        when 104 => INS <= doins( iJUMP,iIF,NEGATIVE,254);                  -- number is positive
        when 105 => INS <= doins( iADD, -8);                                -- will go negative
        when 106 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);               -- number is positive
        -- Call and Return
        when 107 => INS <= doins( iLOAD,-1);                                -- set zero flag
        when 108 => INS <= doins( iINC);
        when 109 => INS <= doins( iCALL,iIF,ZERO, 243);                     -- should call
        when 110 => INS <= doins( iCALL, iNOTIF,ZERO, 242);                 -- should not call
        when 111 => INS <= doins( iCALL,  244);                             -- check return, will return
        when 112 => INS <= doins( iINC);                                    -- Clear zero
        when 113 => INS <= doins( iCALL,iNOTIF,ZERO,243);                   -- should call
        when 114 => INS <= doins( iCALL,iIF,ZERO,242);                      -- should not call
        when 115 => INS <= doins( iCALL,246);                               -- check return, will return
        -- Repeat with Negative flag
        when 116 => INS <= doins( iLOAD,-2);                                -- set negative flag
        when 117 => INS <= doins( iINC);
        when 118 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);
        when 119 => INS <= doins( iCALL,iIF,NEGATIVE,243);                  -- should call
        when 120 => INS <= doins( iCALL,iNOTIF,NEGATIVE,242);               -- should not call
        when 121 => INS <= doins( iCALL,248);                               -- check return, will return
        when 122 => INS <= doins( iINC);                                    -- not set
        when 123 => INS <= doins( iJUMP,iIF,NEGATIVE,254);
        when 124 => INS <= doins( iCALL,iNOTIF,NEGATIVE,243);               -- should call
        when 125 => INS <= doins( iCALL,iIF,NEGATIVE,242);                  -- should not call
        when 126 => INS <= doins( iCALL,iNOTIF,ALWAYS,251);                 -- check return, will return
        -- Check Stack calling
        when 130 => INS <= doins( iLOAD,0);                                 -- Clear accum
        when 131 => INS <= doins( iCALL,232);
        when 132 => INS <= doins( iCMP,1);                                  -- Should have incremented by 1
        when 133 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 134 => INS <= doins( iCALL,229);
        when 135 => INS <= doins( iCMP,3);                                  -- Should have incremented by 2
        when 136 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 137 => INS <= doins( iCALL, 226);
        when 138 => INS <= doins( iCMP,6);                                  -- Should have incremented by 3
        when 139 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 140 => INS <= doins( iCALL, 223);
        when 141 => INS <= doins( iCMP,10);                                 -- Should have incremented by 4
        when 142 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Loop Instruction
        when 145 => INS <= doins( iLOAD,0);                                 -- Clear accum
        when 146 => INS <= doins( iLOADZ,iDAT, 5);
        when 147 => INS <= doins( iINC);
        when 148 => INS <= doins( iDECZ);
        when 149 => INS <= doins( iJUMP,iNOTIF,ZZERO,147);
        when 150 => INS <= doins( iCMP,05);                                  -- Should have incremented by 5
        when 151 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Memory Block read and write
        when 155 => INS <= doins( iLOAD,16#23456745#);                      -- Test Data
        when 156 => INS <= doins( iRAMWRT,0,iACC);                               -- write and then readback to verify
        when 157 => INS <= doins( iINC);
        when 158 => INS <= doins( iRAMWRT,10,iACC);
        when 159 => INS <= doins( iINC);
        when 160 => INS <= doins( iRAMWRT,100,iACC);
        when 161 => INS <= doins( iINC);
        when 162 => INS <= doins( iRAMWRT,250,iACC);
        when 163 => INS <= doins( iRAMREAD,0);
        when 164 => INS <= doins( iCMP,16#23456745#);
        when 165 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 166 => INS <= doins( iRAMREAD,10);
        when 167 => INS <= doins( iCMP,16#23456746#);
        when 168 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 169 => INS <= doins( iRAMREAD,100);
        when 170 => INS <= doins( iCMP,16#23456747#);
        when 171 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 172 => INS <= doins( iRAMREAD,250);
        when 173 => INS <= doins( iCMP,16#23456748#);
        when 174 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Done tests, jump to signal all done
        when 180 => INS <= doins( iCALL,240);
        ----------------------------------------------------------------------------------
        -- Call testing
        when 223 => INS <= doins( iINC);
        when 224 => INS <= doins( iCALL, 226);
        when 225 => INS <= doins( iRETURN);
        when 226 => INS <= doins( iINC);
        when 227 => INS <= doins( iCALL,229);
        when 228 => INS <= doins( iRETURN);
        when 229 => INS <= doins( iINC);
        when 230 => INS <= doins( iCALL,232);
        when 231 => INS <= doins( iRETURN);
        when 232 => INS <= doins( iINC);
        when 233 => INS <= doins( iNOP);
        when 234 => INS <= doins( iRETURN);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 240 => INS <= doins( iIOWRT, iDAT, 253);
        when 241 => INS <= doins( iJUMP,241);
        -- If called here error
        when 242 => INS <= doins( iJUMP,254);
        ------------------------------------------------------------------------------------
        -- If called here return
        when 243 => INS <= doins( iRETURN);
        -- If called here return on zero
        when 244 => INS <= doins( iRETURN,iIF,ZERO);
        when 245 => INS <= doins( iJUMP,254);
        -- If called here return on NOT zero
        when 246 => INS <= doins( iRETURN,iNOTIF,ZERO);
        when 247 => INS <= doins( iJUMP,254);
        -- If called here return on negative
        when 248 => INS <= doins( iRETURN,iIF,NEGATIVE);
        when 249 => INS <= doins( iJUMP,254);
        -- If called here return on NOT negative
        when 250 => INS <= doins( iRETURN,iNOTIF,NEGATIVE);
        when 251 => INS <= doins( iJUMP,254);
        -- Error Condition
        when 254 => INS <= doins( iIOWRT, iDAT, 254);                         -- Error Condition
        when 255 => INS <= doins( iJUMP,251);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   ---------------------------------------------------------------------------------------------
   -- 8-Bit operation with all insructions enabled
   when 14 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55#);                        -- Set Accumalator to 55hex
        when 2   => INS <= doins( iAND,16#0F#);                         -- Do some maths and jump to error if one occurs
        when 3   => INS <= doins( iCMP,16#05#);
        when 4   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 5   => INS <= doins( iOR, 16#A2#);
        when 6   => INS <= doins( iCMP,16#A7#);
        when 7   => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 8   => INS <= doins( iADD, 16#01#);
        when 9   => INS <= doins( iCMP,16#A8#);
        when 10  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 11  => INS <= doins( iXOR, 16#0F#);
        when 12  => INS <= doins( iCMP,16#A7#);
        when 13  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 14  => INS <= doins( iADD, 16#12#);
        when 15  => INS <= doins( iCMP,16#B9#);
        when 16  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- APB Bus Cycles, immediate data
        when 30  => INS <= doins( iLOAD,16#12#);
        when 31  => INS <= doins( iAPBWRT, iDAT, 0,16#10#,16#12#);
        when 32  => INS <= doins( iAPBWRT, iDAT, 0,16#11#,16#13#);
        when 33  => INS <= doins( iAPBWRT, iDAT, 1,16#12#,16#14#);
        when 34  => INS <= doins( iAPBWRT, iDAT, 1,16#13#,16#15#);
        when 35  => INS <= doins( iAPBWRT, iDAT, 2,16#14#,16#16#);
        when 36  => INS <= doins( iAPBWRT, iDAT, 2,16#15#,16#17#);
        when 37  => INS <= doins( iAPBWRT, iDAT, 3,16#10#,16#18#);
        when 38  => INS <= doins( iAPBWRT, iDAT, 3,16#11#,16#19#);
        when 39  => INS <= doins( iAPBREAD, 0,16#10#);
        when 40  => INS <= doins( iCMP,16#12#);
        when 41  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 42  => INS <= doins( iAPBREAD, 0,16#11#);
        when 43  => INS <= doins( iCMP,16#13#);
        when 44  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 45  => INS <= doins( iAPBREAD, 1,16#12#);
        when 46  => INS <= doins( iCMP,16#14#);
        when 47  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 48  => INS <= doins( iAPBREAD, 1,16#13#);
        when 49  => INS <= doins( iCMP,16#15#);
        when 50  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 51  => INS <= doins( iAPBREAD, 2,16#14#);
        when 52  => INS <= doins( iCMP,16#16#);
        when 53  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 54  => INS <= doins( iAPBREAD, 2,16#15#);
        when 55  => INS <= doins( iCMP,16#17#);
        when 56  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 57  => INS <= doins( iAPBREAD, 3,16#10#);
        when 58  => INS <= doins( iCMP,16#18#);
        when 59  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 60  => INS <= doins( iAPBREAD, 3,16#11#);
        when 61  => INS <= doins( iCMP,16#19#);
        when 62  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Flag Conditions
        when 99  => INS <= doins( iLOAD,255);                           -- set zero flag
        when 100 => INS <= doins( iADD, 1);
        when 101 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 102 => INS <= doins( iADD, 1);                             -- not set
        when 103 => INS <= doins( iJUMP,iIF,ZERO, 254);
        when 104 => INS <= doins( iJUMP,iIF,NEGATIVE,254);              -- number is positive
        when 105 => INS <= doins( iADD, 16#F6#);                        -- will go negative
        when 106 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);           -- number is positive
        -- Call and Return
        when 107 => INS <= doins( iLOAD,255);                           -- set zero flag
        when 108 => INS <= doins( iADD, 1);
        when 109 => INS <= doins( iCALL,iIF,ZERO, 243);                 -- should call
        when 110 => INS <= doins( iCALL, iNOTIF,ZERO, 242);             -- should not call
        when 111 => INS <= doins( iCALL,  244);                         -- check return, will return
        when 112 => INS <= doins( iADD, 1);                             -- Clear zero
        when 113 => INS <= doins( iCALL,iNOTIF,ZERO,243);               -- should call
        when 114 => INS <= doins( iCALL,iIF,ZERO,242);                  -- should not call
        when 115 => INS <= doins( iCALL,246);                           -- check return, will return
        -- Repeat with Negative flag
        when 116 => INS <= doins( iLOAD,254);                           -- set negative flag
        when 117 => INS <= doins( iADD, 1);
        when 118 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,254);
        when 119 => INS <= doins( iCALL,iIF,NEGATIVE,243);              -- should call
        when 120 => INS <= doins( iCALL,iNOTIF,NEGATIVE,242);           -- should not call
        when 121 => INS <= doins( iCALL,248);                           -- check return, will return
        when 122 => INS <= doins( iADD, 1);                             -- not set
        when 123 => INS <= doins( iJUMP,iIF,NEGATIVE,254);
        when 124 => INS <= doins( iCALL,iNOTIF,NEGATIVE,243);           -- should call
        when 125 => INS <= doins( iCALL,iIF,NEGATIVE,242);              -- should not call
        when 126 => INS <= doins( iCALL,iNOTIF,ALWAYS,251);             -- check return, will return
        -- Check Stack calling
        when 130 => INS <= doins( iLOAD,0);                             -- Clear accum
        when 131 => INS <= doins( iCALL,232);
        when 132 => INS <= doins( iCMP,1);                              -- Should have incremented by 1
        -- Done tests, jump to signal all done
        when 180 => INS <= doins( iCALL,240);
        ----------------------------------------------------------------------------------
        -- Call testing
        when 223 => INS <= doins( iADD, 1);
        when 224 => INS <= doins( iCALL, 226);
        when 225 => INS <= doins( iRETURN);
        when 226 => INS <= doins( iADD, 1);
        when 227 => INS <= doins( iCALL,229);
        when 228 => INS <= doins( iRETURN);
        when 229 => INS <= doins( iADD, 1);
        when 230 => INS <= doins( iCALL,232);
        when 231 => INS <= doins( iRETURN);
        when 232 => INS <= doins( iADD, 1);
        when 233 => INS <= doins( iNOP);
        when 234 => INS <= doins( iRETURN);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 240 => INS <= doins( iIOWRT, iDAT, 253);
        when 241 => INS <= doins( iJUMP,241);
        -- If called here error
        when 242 => INS <= doins( iJUMP,254);
        ------------------------------------------------------------------------------------
        -- If called here return
        when 243 => INS <= doins( iRETURN);
        -- If called here return on zero
        when 244 => INS <= doins( iRETURN,iIF,ZERO);
        when 245 => INS <= doins( iJUMP,254);
        -- If called here return on NOT zero
        when 246 => INS <= doins( iRETURN,iNOTIF,ZERO);
        when 247 => INS <= doins( iJUMP,254);
        -- If called here return on negative
        when 248 => INS <= doins( iRETURN,iIF,NEGATIVE);
        when 249 => INS <= doins( iJUMP,254);
        -- If called here return on NOT negative
        when 250 => INS <= doins( iRETURN,iNOTIF,NEGATIVE);
        when 251 => INS <= doins( iJUMP,254);
        -- Error Condition
        when 254 => INS <= doins( iIOWRT, iDAT, 254);                  -- Error Condition
        when 255 => INS <= doins( iJUMP,251);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   ---------------------------------------------------------------------------------------------
   -- 8-Bit operation with all some instructions enabled  - no stack
   when 15 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55#);                -- Set Accumalator to 55hex
        when 8   => INS <= doins( iINC);
        when 9   => INS <= doins( iCMP,16#56#);
        when 10  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- IO IN and OUT Jump Conditions
        when 20 => INS <= doins( iIOWRT, iDAT, 16#00#);               -- IO_IN is connected to IO_OUT
        when 21 => INS <= doins( iJUMP,iIF,INPUT0, 254);
        when 22 => INS <= doins( iJUMP,iIF,INPUT1, 254);
        when 23 => INS <= doins( iJUMP,iIF,INPUT2, 254);
        when 24 => INS <= doins( iJUMP,iIF,INPUT3, 254);
        when 25 => INS <= doins( iIOWRT, iDAT, 16#01#);               -- IO_IN is connected to IO_OUT
        when 26 => INS <= doins( iJUMP,iNOTIF,INPUT0, 254);
        when 27 => INS <= doins( iJUMP,iIF,INPUT1   , 254);
        when 28 => INS <= doins( iJUMP,iIF,INPUT2   , 254);
        when 29 => INS <= doins( iJUMP,iIF,INPUT3   , 254);
        when 30 => INS <= doins( iIOWRT, iDAT, 16#02#);               -- IO_IN is connected to IO_OUT
        when 31 => INS <= doins( iJUMP,iIF,INPUT0   , 254);
        when 32 => INS <= doins( iJUMP,iNOTIF,INPUT1, 254);
        when 33 => INS <= doins( iJUMP,iIF,INPUT2   , 254);
        when 34 => INS <= doins( iJUMP,iIF,INPUT3   , 254);
        when 35 => INS <= doins( iIOWRT, iDAT, 16#04#);               -- IO_IN is connected to IO_OUT
        when 36 => INS <= doins( iJUMP,iIF,INPUT0   , 254);
        when 37 => INS <= doins( iJUMP,iIF,INPUT1   , 254);
        when 38 => INS <= doins( iJUMP,iNOTIF,INPUT2, 254);
        when 39 => INS <= doins( iJUMP,iIF,INPUT3   , 254);
        when 40 => INS <= doins( iIOWRT, iDAT, 16#08#);               -- IO_IN is connected to IO_OUT
        when 41 => INS <= doins( iJUMP,iIF,INPUT0   , 254 );
        when 42 => INS <= doins( iJUMP,iIF,INPUT1   , 254 );
        when 43 => INS <= doins( iJUMP,iIF,INPUT2   , 254 );
        when 44 => INS <= doins( iJUMP,iNOTIF,INPUT3, 254 );
        -- APB Bus Cycles, immediate data
        -- Accumalator writes
        when 65 =>  INS <= doins( iLOAD,16#23#);
        when 66  => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 67  => INS <= doins( iINC);
        when 68  => INS <= doins( iAPBWRT, iACC,  0,16#21#);
        when 69  => INS <= doins( iINC);
        when 70  => INS <= doins( iAPBWRT, iACC,  0,16#22#);
        when 71  => INS <= doins( iAPBREAD, 0,16#20#);
        when 72  => INS <= doins( iCMP,16#23#);
        when 73  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 74  => INS <= doins( iAPBREAD, 0,16#21#);
        when 75  => INS <= doins( iCMP,16#24#);
        when 76  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 77  => INS <= doins( iAPBREAD, 0,16#22#);
        when 78  => INS <= doins( iCMP,16#25#);
        when 79  => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        -- Flag Conditions
        when 99  => INS <= doins( iLOAD,255);                       -- set zero flag
        when 100 => INS <= doins( iINC);
        when 101 => INS <= doins( iJUMP,iNOTIF,ZERO,254);
        when 102 => INS <= doins( iINC);                            -- not set
        when 103 => INS <= doins( iJUMP,iIF,ZERO, 254);
        when 104 => INS <= doins( iJUMP,iIF,NEGATIVE,254);          -- number is positive
        -- Done tests, jump to signal all done
        when 180 => INS <= doins( iCALL,240);
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 240 => INS <= doins( iIOWRT, iDAT, 253);
        when 241 => INS <= doins( iJUMP,241);
        -- If called here error
        when 242 => INS <= doins( iJUMP,254);
        ------------------------------------------------------------------------------------
        -- Error Condition
        when 254 => INS <= doins( iIOWRT, iDAT, 254);                  -- Error Condition
        when 255 => INS <= doins( iJUMP,251);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
   -- Instruction set to demonstrate CoreAI Operation
   when 16 =>
      case ADDRINT is
        when 0  => INS <= doins( iWAIT,iUNTIL,INPUT0);                      -- wait until AB non busy
        when 1  => INS <= doins( iAPBWRT, iDAT8, 0,iACM_CTRLSTAT,16#0001#); -- set ACM reset
        when 2  => INS <= doins( iWAIT,iUNTIL,INPUT0);                      -- wait until AB non busy
        -- ADC should be calibrating - poll status register
        when 3  => INS <= doins( iAPBREAD, 0,iADC_STAT_HI_ADDR);         -- read status
        when 4  => INS <= doins( iAND,16#8000#);                        -- mask to Calibrate
        when 5  => INS <= doins( iJUMP,iNOTIF,ZERO,3);                  -- if not calibrated  wait
        -- Now Program the AV AC AT AG Registers
        when 6  => INS <= doins( iLOAD,16#0000#);                       -- ACC=0
        when 7  => INS <= doins( iWAIT,iUNTIL,INPUT0);                   -- wait until AB non busy
        when 8  => INS <= doins( iAPBWRT, iACC, 0,iACM_ADDR_ADDR);       -- Write the Accumulator to ACM Address
        when 9  => INS <= doins( iAPBWRT, iACM, 0,iACM_DATA_ADDR);       -- Write ACM Data indexed by Accumulator
        when 10 => INS <= doins( iADD, 16#0001#);                       -- Increment the address
        when 11 => INS <= doins( iBITTST,4);                            -- See if at the last address
        when 12 => INS <= doins( iJUMP,iIF,ZERO,7);                     -- Repeat if not done
        -- Check ADC is Calibrated
        when 13 => INS <= doins( iWAIT,iUNTIL,INPUT0);                   -- wait until AB non busy
        when 14 => INS <= doins( iIOWRT, iDAT, 16#01#);                       -- Indicate initialized
        -- Now do a sample off channel 1
        when 15 => INS <= doins( iAPBWRT, 0,iADC_CTRL2_HI_ADDR,16#2100#);-- Start Conversion Channel 1
        when 16 => INS <= doins( iJUMP,iIF,INPUT0,16);                   -- wait until AB non busy
        --Now Compare the value, see if between 4.75 and 5.25v
        when 17 => INS <= doins( iAPBREAD, 0,iADC_STAT_HI_ADDR);         -- Read ADC Value
        when 18 => INS <= doins( iAND,16#0FFF#);                        -- leave ADC data
        when 19 => INS <= doins( iCMPLEQ,1187);                         -- See if < 4.75v Subtract 1187
        when 20 => INS <= doins( iJUMP,iIF,NEGATIVE,23);                -- jump if negative, less than 4.75
        when 21 => INS <= doins( iCMPLEQ,1312);                         -- See if > 5.25v Subtract 1312
        when 22 => INS <= doins( iJUMP,iNOTIF,NEGATIVE,25);             -- jump if negative, less then 5.25
                                                                         -- simply fall through since >5.25
        -- Decided voltage <4.75 or >5.25 so clear flag
        when 23 => INS <= doins( iIOWRT, iDAT, 16#01#);                       -- Turn DETECTED off
        when 24 => INS <= doins( iJUMP, 15);                            -- Sample again
        -- Decided voltage between 4.75 and 5.25 so set flag
        when 25 => INS <= doins( iIOWRT, iDAT, 16#03#);                       -- Turn DETECTED on
        when 26 => INS <= doins( iJUMP, 15);                            -- Sample again
        when others => INS <= ( others => '-');
      end case;
      ---------------------------------------------------------------------------------------------
   ---------------------------------------------------------------------------------------------
   -- Simple set of instructions - used to test various build types
   when 20 to 31 =>
      case ADDRINT is
        -- Jump to test start point
        when 0   => INS <= doins( iJUMP,1);
        -- Simple Test of Boolean Operations
        when 1   => INS <= doins( iLOAD,16#55#);                -- Set Accumalator to 55hex
        when 8   => INS <= doins( iINC);
        when 9   => INS <= doins( iCMP,16#56#);
        when 10  => INS <= doins( iJUMP,iNOTIF,ZERO,120);
        -- IO IN and OUT Jump Conditions
        when 20 => INS <= doins( iIOWRT, iDAT, 16#00#);               -- IO_IN is connected to IO_OUT
        when 21 => INS <= doins( iJUMP,iIF,INPUT0, 120);
        when 22 => INS <= doins( iJUMP,iIF,INPUT1, 120);
        when 23 => INS <= doins( iJUMP,iIF,INPUT2, 120);
        when 24 => INS <= doins( iJUMP,iIF,INPUT3, 120);
        when 25 => INS <= doins( iIOWRT, iDAT, 16#01#);               -- IO_IN is connected to IO_OUT
        when 26 => INS <= doins( iJUMP,iNOTIF,INPUT0, 120);
        when 27 => INS <= doins( iJUMP,iIF,INPUT1   , 120);
        when 28 => INS <= doins( iJUMP,iIF,INPUT2   , 120);
        when 29 => INS <= doins( iJUMP,iIF,INPUT3   , 120);
        when 30 => INS <= doins( iIOWRT, iDAT, 16#02#);               -- IO_IN is connected to IO_OUT
        when 31 => INS <= doins( iJUMP,iIF,INPUT0   , 120);
        when 32 => INS <= doins( iJUMP,iNOTIF,INPUT1, 120);
        when 33 => INS <= doins( iJUMP,iIF,INPUT2   , 120);
        when 34 => INS <= doins( iJUMP,iIF,INPUT3   , 120);
        when 35 => INS <= doins( iIOWRT, iDAT, 16#04#);               -- IO_IN is connected to IO_OUT
        when 36 => INS <= doins( iJUMP,iIF,INPUT0   , 120);
        when 37 => INS <= doins( iJUMP,iIF,INPUT1   , 120);
        when 38 => INS <= doins( iJUMP,iNOTIF,INPUT2, 120);
        when 39 => INS <= doins( iJUMP,iIF,INPUT3   , 120);
        when 40 => INS <= doins( iIOWRT, iDAT, 16#08#);               -- IO_IN is connected to IO_OUT
        when 41 => INS <= doins( iJUMP,iIF,INPUT0   , 120 );
        when 42 => INS <= doins( iJUMP,iIF,INPUT1   , 120 );
        when 43 => INS <= doins( iJUMP,iIF,INPUT2   , 120 );
        when 44 => INS <= doins( iJUMP,iNOTIF,INPUT3, 120 );
        when 45 => INS <= doins( iJUMP,65);
        -- APB Bus Cycles, immediate data
        when 65 =>  INS <= doins( iLOAD,16#23#);
        when 66  => INS <= doins( iAPBWRT, iACC,  0,16#20#);
        when 67  => INS <= doins( iINC);
        when 68  => INS <= doins( iAPBWRT, iACC,  0,16#21#);
        when 69  => INS <= doins( iINC);
        when 70  => INS <= doins( iAPBWRT, iACC,  0,16#22#);
        when 71  => INS <= doins( iAPBREAD, 0,16#20#);
        when 72  => INS <= doins( iCMP,16#23#);
        when 73  => INS <= doins( iJUMP,iNOTIF,ZERO,120);
        when 74  => INS <= doins( iAPBREAD, 0,16#21#);
        when 75  => INS <= doins( iCMP,16#24#);
        when 76  => INS <= doins( iJUMP,iNOTIF,ZERO,120);
        when 77  => INS <= doins( iAPBREAD, 0,16#22#);
        when 78  => INS <= doins( iCMP,16#25#);
        when 79  => INS <= doins( iJUMP,iNOTIF,ZERO,120);
        when 80  => INS <= doins( iJUMP,99);
        -- Flag Conditions
        when 99  => INS <= doins( iLOAD,0);                         -- set zero flag
        when 100 => INS <= doins( iAND, 0);
        when 101 => INS <= doins( iJUMP,iNOTIF,ZERO,120);
        when 102 => INS <= doins( iINC);                            -- not set
        when 103 => INS <= doins( iJUMP,iIF,ZERO, 120);
        when 104 => INS <= doins( iJUMP,iIF,NEGATIVE,120);          -- number is positive
        ------------------------------------------------------------------------------------
        -- All tests complete
        when 105 => INS <= doins( iIOWRT, iDAT, 253);
        when 106 => INS <= doins( iHALT);
        -- Error Condition
        when 120 => INS <= doins( iIOWRT, iDAT, 254);                  -- Error Condition
        when 121 => INS <= doins( iHALT);
        when others => INS <= doins( iNOP);
     end case;
   ---------------------------------------------------------------------------------------------
     -- Illegal testmode specified
     when others =>    case ADDRINT is
                         when 0 => INS <= doins( iIOWRT, iDAT, 254);                 -- Error Condition
                         when 1 => INS <= doins( iJUMP, 11);
                         when others => INS <= doins( iNOP);
                       end case;
end case;
end process;
--------------------------------------------------------------------------------------------------------
-- Force in the dont cares
process(INS)
begin
  INSTRUCTION <= ( others => '-');
  INSTRUCTION(5 downto 0) <= INS(5 downto 0);
  if SW>0 then
    INSTRUCTION(SW-1+6 downto 6) <=  INS(SW-1+6 downto 6);
  end if;
  INSTRUCTION(AW-1+4+6 downto 4+6)        <=  INS(AW-1+4+6 downto 4+6);
  INSTRUCTION(DW-1+16+4+6 downto 16+4+6 ) <=  INS(DW-1+16+4+6 downto 16+4+6 );
end process;
end RTL;
