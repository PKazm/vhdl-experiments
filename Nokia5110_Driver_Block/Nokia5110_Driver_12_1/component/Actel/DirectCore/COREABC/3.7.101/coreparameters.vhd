----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Wed Nov  6 15:55:43 2019
-- Parameters for COREABC
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant ABCCODE : string( 1 to 769 ) := "$MAIN
    DEF Driver_ctrl_ADDR 0x00
    DEF LCD_func_set_ADDR 0x01
    DEF LCD_disp_ctrl_ADDR 0x02
    DEF LCD_temp_ctrl_ADDR 0x03
    DEF LCD_bias_sys_ADDR 0x04
    DEF LCD_Vop_set_ADDR 0x05
    DEF LCD_mem_data_ADDR 0x10
    DEF LCD_mem_X_ADDR 0x11
    DEF LCD_mem_Y_ADDR 0x12

$crazy_loop
    APBREAD 0 LCD_mem_X_ADDR
    INC
    CMP DAT8 84
    JUMP IFNOT ZERO $WRT_X_ADDR
        APBREAD 0 LCD_mem_Y_ADDR
        INC
        CMP DAT8 6
        JUMP IFNOT ZERO $WRT_Y_ADDDR
            LOAD DAT8 0
        $WRT_Y_ADDDR
        APBWRT ACC 0 LCD_mem_Y_ADDR
        LOAD DAT8 0
    $WRT_X_ADDR
    // writes 0 if = 84, or writes source + 1
    APBWRT ACC 0 LCD_mem_X_ADDR

    APBREAD 0 LCD_mem_data_ADDR
    INC
    APBWRT ACC 0 LCD_mem_data_ADDR
    JUMP $crazy_loop";
    constant ACT_CALIBRATIONDATA : integer := 1;
    constant APB_AWIDTH : integer := 8;
    constant APB_DWIDTH : integer := 8;
    constant APB_SDEPTH : integer := 2;
    constant CODEHEXDUMP : string( 1 to 0 ) := "";
    constant CODEHEXDUMP2 : string( 1 to 0 ) := "";
    constant DEBUG : integer := 1;
    constant EN_ACM : integer := 0;
    constant EN_ADD : integer := 0;
    constant EN_ALURAM : integer := 0;
    constant EN_AND : integer := 0;
    constant EN_CALL : integer := 0;
    constant EN_DATAM : integer := 2;
    constant EN_INC : integer := 1;
    constant EN_INDIRECT : integer := 0;
    constant EN_INT : integer := 0;
    constant EN_IOREAD : integer := 0;
    constant EN_IOWRT : integer := 0;
    constant EN_MULT : integer := 0;
    constant EN_OR : integer := 0;
    constant EN_PUSH : integer := 0;
    constant EN_RAM : integer := 1;
    constant EN_SHL : integer := 0;
    constant EN_SHR : integer := 0;
    constant EN_XOR : integer := 1;
    constant FAMILY : integer := 19;
    constant HDL_license : string( 1 to 1 ) := "U";
    constant ICWIDTH : integer := 4;
    constant IFWIDTH : integer := 0;
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
