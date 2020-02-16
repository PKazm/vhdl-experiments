----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Fri Jan 31 00:18:16 2020
-- Parameters for COREABC
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant ABCCODE : string( 1 to 5123 ) := "JUMP $MAIN
    // Begin Interrupt Service Routine
    // clear i2c seq int
    APBWRT DAT8 0 0x00 0b00000000
    RAMREAD RAM_ADR_init_done
    CMP DAT8 1
    JUMP IF ZERO $I2C_reads
    // i2c start
    //APBWRT DAT8 0 0xC0 | 0 0x01
    //APBWRT DAT8 0 0x80 | 0 0x00
    // light sensor addr + W
    //APBWRT DAT8 0 0xC0 | 1 0x04
    //APBWRT DAT8 0 0x80 | 1 0x52
    //
    APBWRT DAT8 0 0xC0 | 2 0x04
    APBWRT DAT8 0 0x80 | 2 0x88
    //
    APBWRT DAT8 0 0xC0 | 3 0x03
    //
    APBWRT DAT8 0 0xC0 | 4 0x04
    APBWRT DAT8 0 0x80 | 4 0x53
    //
    APBWRT DAT8 0 0xC0 | 5 0x05
    APBWRT DAT8 0 0x80 | 5 0b00000000
    //
    APBWRT DAT8 0 0xC0 | 6 0x03
    //
    APBWRT DAT8 0 0xC0 | 7 0x04
    APBWRT DAT8 0 0x80 | 7 0x52
    //
    APBWRT DAT8 0 0xC0 | 8 0x04
    //
    APBWRT DAT8 0 0xC0 | 9 0x03
    //
    APBWRT DAT8 0 0xC0 | 10 0x04
    //
    APBWRT DAT8 0 0xC0 | 11 0x05
    //
    APBWRT DAT8 0 0xC0 | 12 0x03
    //
    APBWRT DAT8 0 0xC0 | 13 0x04
    //
    APBWRT DAT8 0 0xC0 | 14 0x04
    //
    APBWRT DAT8 0 0xC0 | 15 0x03
    //
    APBWRT DAT8 0 0xC0 | 16 0x04
    //
    APBWRT DAT8 0 0xC0 | 17 0x05
    //
    APBWRT DAT8 0 0xC0 | 18 0x03
    //
    APBWRT DAT8 0 0xC0 | 19 0x04
    //
    APBWRT DAT8 0 0xC0 | 20 0x04
    //
    APBWRT DAT8 0 0xC0 | 21 0x03
    //
    APBWRT DAT8 0 0xC0 | 22 0x04
    //
    APBWRT DAT8 0 0xC0 | 23 0x05
    
    RAMWRT RAM_ADR_init_done DAT8 1
    
    // start timer
    APBWRT DAT 1 0x08 0b011
    JUMP $I2C_SEQ_INT_CLR
    

    $I2C_reads
    
    // I2C 0x88 - CH1_0
    APBREAD 0 0x80 | 5
    APBWRT ACC 2 0x03
    RAMWRT RAM_ADR_I2C_CH1_0 ACC
    
    // I2C 0x89 - CH1_1
    APBREAD 0 0x80 | 11
    APBWRT ACC 2 0x04
    RAMWRT RAM_ADR_I2C_CH1_1 ACC
    
    // I2C 0x8A - CH0_0
    APBREAD 0 0x80 | 17
    APBWRT ACC 2 0x001
    RAMWRT RAM_ADR_I2C_CH0_0 ACC
    
    // I2C 0x8B - CH0_1
    APBREAD 0 0x80 | 23
    APBWRT ACC 2 0x02
    RAMWRT RAM_ADR_I2C_CH0_1 ACC
    
    APBWRT DAT8 2 0x00 1
    
    // generate LED pwm value (16 to 8 bit)
    RAMREAD RAM_ADR_I2C_CH0_1
    IOWRT ACC
    
    
    $I2C_SEQ_INT_CLR
    // clear timer int
    APBWRT DAT 1 0x10 1

    RETISR

$MAIN

    DEF RAM_ADR_I2C_SEQ_CNT  0x00
    DEF RAM_ADR_I2C_CH0_0    0x01
    DEF RAM_ADR_I2C_CH0_1    0x02
    DEF RAM_ADR_I2C_CH1_0    0x03
    DEF RAM_ADR_I2C_CH1_1    0x04
    DEF RAM_ADR_init_done    0x10
    RAMWRT RAM_ADR_init_done DAT8 0
    
    
    // clk_div of 0x00FF at PCLK:100Mhz gives 392.2kHz
    // clk_div of 0x03FF at PCLK:100Mhz gives 97.75kHz
    APBWRT DAT8 0 0x02 0xFF
    //APBWRT DAT8 0 0x03 0x03
    
    
    // i2c start
    APBWRT DAT8 0 0xC0 | 0 0x01
    APBWRT DAT8 0 0x80 | 0 0x00
    // light sensor addr + W
    APBWRT DAT8 0 0xC0 | 1 0x04
    APBWRT DAT8 0 0x80 | 1 0x52
    // light sensor reg addr - ctrl
    APBWRT DAT8 0 0xC0 | 2 0x04
    APBWRT DAT8 0 0x80 | 2 0x80
    // light sensor reg data - ALS_Gain[4:2]; SW_Reset[1]; ALS_Mode[0]
    APBWRT DAT8 0 0xC0 | 3 0x04
    APBWRT DAT8 0 0x80 | 3 0b00011101
    // i2c rstart
    APBWRT DAT8 0 0xC0 | 4 0x03
    APBWRT DAT8 0 0x80 | 4 0x00
    // light sensor addr + W
    APBWRT DAT8 0 0xC0 | 5 0x4
    APBWRT DAT8 0 0x80 | 5 0x52
    // light sensor reg addr - meas_rate
    APBWRT DAT8 0 0xC0 | 6 0x04
    APBWRT DAT8 0 0x80 | 6 0x85
    // light sensor reg data - ALS_intgr_time[5:3]; ALS_meas_time[2:0]
    APBWRT DAT8 0 0xC0 | 7 0x04
    APBWRT DAT8 0 0x80 | 7 0b00001001
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 8 0x00
    APBWRT DAT8 0 0x80 | 8 0x89
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 9 0x00
    APBWRT DAT8 0 0x80 | 9 0x00
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 10 0x00
    APBWRT DAT8 0 0x80 | 10 0x53
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 11 0x00
    APBWRT DAT8 0 0x80 | 11 0b00000000
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 12 0x00
    APBWRT DAT8 0 0x80 | 12 0x00
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 13 0x00
    APBWRT DAT8 0 0x80 | 13 0x52
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 14 0x00
    APBWRT DAT8 0 0x80 | 14 0x8A
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 15 0x00
    APBWRT DAT8 0 0x80 | 15 0x00
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 16 0x00
    APBWRT DAT8 0 0x80 | 16 0x53
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 17 0x00
    APBWRT DAT8 0 0x80 | 17 0b00000000
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 18 0x00
    APBWRT DAT8 0 0x80 | 18 0x00
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 19 0x00
    APBWRT DAT8 0 0x80 | 19 0x52
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 20 0x00
    APBWRT DAT8 0 0x80 | 20 0x8B
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 21 0x00
    APBWRT DAT8 0 0x80 | 21 0x00
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 22 0x00
    APBWRT DAT8 0 0x80 | 22 0x53
    // i2c NOP
    APBWRT DAT8 0 0xC0 | 23 0x00
    APBWRT DAT8 0 0x80 | 23 0b00000000
    // i2c stop
    APBWRT DAT8 0 0xC0 | 24 0x02
    APBWRT DAT8 0 0x80 | 24 0x00
    
    
    // INIT TIMER
    // TimerLoad
    // 977 for 20Mhz for 50ms
    // 4883 for 100Mhz for 50 ms
    // 19531 for 100Mhz for 200 ms
    APBWRT DAT 1 0x00 10000
    // TimerPrescale
    APBWRT DAT 1 0x0C 0x0009
    
    // start I2C sequence
    APBWRT DAT8 0 0x00 0b00010001
    

    HALT
    ";
    constant ACT_CALIBRATIONDATA : integer := 1;
    constant APB_AWIDTH : integer := 8;
    constant APB_DWIDTH : integer := 16;
    constant APB_SDEPTH : integer := 3;
    constant CODEHEXDUMP : string( 1 to 0 ) := "";
    constant CODEHEXDUMP2 : string( 1 to 0 ) := "";
    constant DEBUG : integer := 1;
    constant EN_ACM : integer := 0;
    constant EN_ADD : integer := 1;
    constant EN_ALURAM : integer := 0;
    constant EN_AND : integer := 1;
    constant EN_CALL : integer := 1;
    constant EN_DATAM : integer := 2;
    constant EN_INC : integer := 1;
    constant EN_INDIRECT : integer := 0;
    constant EN_INT : integer := 1;
    constant EN_IOREAD : integer := 1;
    constant EN_IOWRT : integer := 1;
    constant EN_MULT : integer := 0;
    constant EN_OR : integer := 1;
    constant EN_PUSH : integer := 1;
    constant EN_RAM : integer := 1;
    constant EN_SHL : integer := 1;
    constant EN_SHR : integer := 1;
    constant EN_XOR : integer := 1;
    constant FAMILY : integer := 19;
    constant HDL_license : string( 1 to 1 ) := "U";
    constant ICWIDTH : integer := 7;
    constant IFWIDTH : integer := 0;
    constant IIWIDTH : integer := 1;
    constant IMEM_APB_ACCESS : integer := 0;
    constant INITWIDTH : integer := 11;
    constant INSMODE : integer := 0;
    constant IOWIDTH : integer := 8;
    constant ISRADDR : integer := 1;
    constant MAX_NVMDWIDTH : integer := 32;
    constant STWIDTH : integer := 4;
    constant TESTBENCH : string( 1 to 4 ) := "User";
    constant TESTMODE : integer := 0;
    constant UNIQ_STRING : string( 1 to 23 ) := "COREABC_C0_COREABC_C0_0";
    constant UNIQ_STRING_LENGTH : integer := 23;
    constant VERILOGCODE : string( 1 to 0 ) := "";
    constant VERILOGVARS : string( 1 to 0 ) := "";
    constant VHDLCODE : string( 1 to 0 ) := "";
    constant VHDLVARS : string( 1 to 0 ) := "";
    constant ZRWIDTH : integer := 0;
end coreparameters;