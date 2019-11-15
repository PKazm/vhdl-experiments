----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Nov 14 19:59:13 2019
-- Parameters for COREABC
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant ABCCODE : string( 1 to 1852 ) := "JUMP $MAIN

    // Check if Nokia5110 Driver is currently busy outputting LCD data
    IOREAD
    CMP DAt8 1    
    RETISR IF ZERO

    $Shift_Pixels
    RAMREAD RAM_Y_pos
    APBWRT ACC 0 LCD_pixels_X_ADDR
    INC
    CMP DAT 84
    JUMP IFNOT ZERO $save_y_pos
        LOAD DAT8 0
    $save_y_pos
    RAMWRT RAM_Y_pos ACC
    
    APBWRT DAT8 0 LCD_pixels_Y_ADDR 1
    APBREAD 1 DSC_pixels0_ADDR
    APBWRT ACC 0 LCD_pixels_data_ADDR

    APBWRT DAT8 0 LCD_pixels_Y_ADDR 2
    APBREAD 1 DSC_pixels1_ADDR
    APBWRT ACC 0 LCD_pixels_data_ADDR

    APBWRT DAT8 0 LCD_pixels_Y_ADDR 3
    APBREAD 1 DSC_pixels2_ADDR
    APBWRT ACC 0 LCD_pixels_data_ADDR

    APBWRT DAT8 0 LCD_pixels_Y_ADDR 4
    APBREAD 1 DSC_pixels3_ADDR
    APBWRT ACC 0 LCD_pixels_data_ADDR

    RETISR

$MAIN

    DEF DSC_ctrl_ADDR 0x00
    DEF DSC_pixels0_ADDR 0x10
    DEF DSC_pixels1_ADDR 0x11
    DEF DSC_pixels2_ADDR 0x12
    DEF DSC_pixels3_ADDR 0x13

    DEF LCD_pixels_data_ADDR 0x10
    DEF LCD_pixels_X_ADDR 0x11
    DEF LCD_pixels_Y_ADDR 0x12

    DEF RAM_pixels      0x00
    DEF RAM_pixels_last 0x01
    DEF RAM_Y_pos       0x02

    //CALL Shift_Pixels
    APBWRT DAT8 0 LCD_pixels_X_ADDR 0
    APBWRT DAT8 0 LCD_pixels_Y_ADDR 0
    APBWRT DAT8 0 LCD_pixels_data_ADDR 0x0F
    $clear_lcd
    APBREAD 0 LCD_pixels_X_ADDR
    INC
    CMP DAT8 84
    JUMP IFNOT ZERO $WRT_X_ADDR
        APBREAD 0 LCD_pixels_Y_ADDR
        INC
        CMP DAT8 6
        JUMP IFNOT ZERO $WRT_Y_ADDDR
            LOAD DAT8 0
            JUMP $Halt_Stuff
        $WRT_Y_ADDDR
        APBWRT ACC 0 LCD_pixels_Y_ADDR
        LOAD DAT8 0
    $WRT_X_ADDR
    // writes 0 if = 84, or writes source + 1
    APBWRT ACC 0 LCD_pixels_X_ADDR
    
    APBWRT DAT8 0 LCD_pixels_data_ADDR 0
    JUMP $clear_lcd

    $Halt_Stuff

    RAMWRT RAM_Y_pos 0
    APBWRT DAT8 1 DSC_ctrl_ADDR 0b00000001
    HALT";
    constant ACT_CALIBRATIONDATA : integer := 1;
    constant APB_AWIDTH : integer := 8;
    constant APB_DWIDTH : integer := 8;
    constant APB_SDEPTH : integer := 2;
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
    constant ICWIDTH : integer := 6;
    constant IFWIDTH : integer := 1;
    constant IIWIDTH : integer := 1;
    constant IMEM_APB_ACCESS : integer := 0;
    constant INITWIDTH : integer := 11;
    constant INSMODE : integer := 0;
    constant IOWIDTH : integer := 1;
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
