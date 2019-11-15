JUMP $MAIN

    // Check if Nokia5110 Driver is currently busy outputting LCD data
    RETISR IF INPUT0

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
    HALT