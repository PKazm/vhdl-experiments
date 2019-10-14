JUMP $MAIN
$INTERRUPT
    //poll APB_Slave for int source
    APBREAD 0 0x00
    //00 = APB_Slave, 01 = I2C, 10 = timer

    CMP DAT8 0b01
    JUMP IF ZERO $INTI2C
    CMP DAT8 0b10
    JUMP IF ZERO $INTTIMER
    JUMP $INTAPBSLAVE


    $INTTIMER
    //Any value written to Timer ADDR 0x10 clears the interrupt
    APBWRT DAT8 2 0x10 1

    //Read current LED register, increment by 1, write back.
    APBREAD 0 0xF0
    INC
    APBWRT ACC 0 0xF0
    
    RETISR
    

    //Handle I2C interrupt, probably send next byte
    $INTI2C
    IOREAD
    CMP DAT8 27
    JUMP IF ZERO $I2C_27
    CMP DAT8 26
    JUMP IF ZERO $I2C_26
    CMP DAT8 25
    JUMP IF ZERO $I2C_25
    CMP DAT8 24
    JUMP IF ZERO $I2C_24
    CMP DAT8 23
    JUMP IF ZERO $I2C_23
    CMP DAT8 22
    JUMP IF ZERO $I2C_22
    CMP DAT8 21
    JUMP IF ZERO $I2C_21
    CMP DAT8 20
    JUMP IF ZERO $I2C_20
    CMP DAT8 19
    JUMP IF ZERO $I2C_19
    CMP DAT8 18
    JUMP IF ZERO $I2C_18
    CMP DAT8 17
    JUMP IF ZERO $I2C_17
    CMP DAT8 16
    JUMP IF ZERO $I2C_16
    CMP DAT8 15
    JUMP IF ZERO $I2C_15
    CMP DAT8 14
    JUMP IF ZERO $I2C_14
    CMP DAT8 13
    JUMP IF ZERO $I2C_13
    CMP DAT8 12
    JUMP IF ZERO $I2C_12
    CMP DAT8 11
    JUMP IF ZERO $I2C_11
    CMP DAT8 10
    JUMP IF ZERO $I2C_10
    CMP DAT8 9
    JUMP IF ZERO $I2C_9
    CMP DAT8 8
    JUMP IF ZERO $I2C_8
    CMP DAT8 7
    JUMP IF ZERO $I2C_7
    CMP DAT8 6
    JUMP IF ZERO $I2C_6
    CMP DAT8 5
    JUMP IF ZERO $I2C_5
    CMP DAT8 4
    JUMP IF ZERO $I2C_4
    CMP DAT8 3
    JUMP IF ZERO $I2C_3
    CMP DAT8 2
    JUMP IF ZERO $I2C_2
    CMP DAT8 1
    JUMP IF ZERO $I2C_1
    CMP DAT8 0
    JUMP IF ZERO $I2C_0
    CMP DAT8 0xFF
    JUMP IF ZERO $AbandonShip

    //BEGIN Light Sens INIT states

        //Step 0, write address light sens for initial setup
        $I2C_0
        APBREAD 1 0x04
        CMP DAT8 0x08
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b0
        IOWRT DAT8 1
        JUMP $ContinueI2C

        //step 1, write control register address
        $I2C_1
        APBREAD 1 0x04
        CMP DAT8 0x18
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 0x80
        IOWRT DAT8 2
        JUMP $ContinueI2C

        //step 2, write control register data
        $I2C_2
        APBREAD 1 0x04
        CMP DAT8 0x28
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 0b00000001
        IOWRT DAT8 3
        JUMP $ContinueI2C

        //step 3, register write finished, stop I2C
        $I2C_3
        APBREAD 1 0x04
        CMP DAT8 0x28
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 4
        JUMP $StopI2C

    //END Light Sens INIT states

    //BEGIN Light Sens Read states

    //BEGIN Light Sens Read CH1_0
        //Step 4, write address light sens for CH1_0 read process
        $I2C_4
        APBREAD 1 0x04
        CMP DAT8 0x08
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b0
        IOWRT DAT8 5
        JUMP $ContinueI2C

        //Step 5, write CH1_0 register address
        $I2C_5
        APBREAD 1 0x04
        CMP DAT8 0x18
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 0x88
        IOWRT DAT8 6
        JUMP $ContinueI2C

        //Step 6, repeat start to begin change from write to read
        $I2C_6
        APBREAD 1 0x04
        CMP DAT8 0x28
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 7
        JUMP $RepeatStartI2C

        //Step 7, write address light sens, set to Read
        //I2C will swap to Master/Receiver mode
        $I2C_7
        APBREAD 1 0x04
        CMP DAT8 0x10
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b1
        IOWRT DAT8 8
        JUMP $ContinueI2C

        //Step 8, prep to read CH1_0 register data
        $I2C_8
        APBREAD 1 0x04
        CMP DAT8 0x40
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 9
        JUMP $ContinuteI2CRead

        //Step 9, actually finally read CH1_0 register data
        $I2C_9
        APBREAD 1 0x04
        CMP DAT8 0x58
        JUMP IFNOT ZERO $AbandonShip
        APBREAD 1 0x08
        APBWRT ACC 0 0x02
        IOWRT DAT8 10
        JUMP $StopStartI2C

    //END Light Sens Read CH1_0

    //BEGIN Light Sens Read CH1_1
        //Step 10, write address light sens for CH1_1 read process
        $I2C_10
        APBREAD 1 0x04
        CMP DAT8 0x08
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b0
        IOWRT DAT8 11
        JUMP $ContinueI2C

        //Step 11, write CH1_1 register address
        $I2C_11
        APBREAD 1 0x04
        CMP DAT8 0x18
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 0x89
        IOWRT DAT8 12
        JUMP $ContinueI2C

        //Step 12, repeat start to begin change from write to read
        $I2C_12
        APBREAD 1 0x04
        CMP DAT8 0x28
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 13
        JUMP $RepeatStartI2C

        //Step 13, write address light sens, set to Read
        //I2C will swap to Master/Receiver mode
        $I2C_13
        APBREAD 1 0x04
        CMP DAT8 0x10
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b1
        IOWRT DAT8 14
        JUMP $ContinueI2C

        //Step 14, prep to read CH1_1 register data
        $I2C_14
        APBREAD 1 0x04
        CMP DAT8 0x40
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 15
        JUMP $ContinuteI2CRead

        //Step 15, actually finally read CH11 register data
        $I2C_15
        APBREAD 1 0x04
        CMP DAT8 0x58
        JUMP IFNOT ZERO $AbandonShip
        APBREAD 1 0x08
        APBWRT ACC 0 0x02
        IOWRT DAT8 16
        JUMP $StopStartI2C
    
    //END Light Sens Read CH1_1

    //BEGIN Light Sens Read CH0_0
        //Step 16, write address light sens for CH0_0 read process
        $I2C_16
        APBREAD 1 0x04
        CMP DAT8 0x08
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b0
        IOWRT DAT8 5
        JUMP $ContinueI2C

        //Step 17, write CH0_0 register address
        $I2C_17
        APBREAD 1 0x04
        CMP DAT8 0x18
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 0x8A
        IOWRT DAT8 18
        JUMP $ContinueI2C

        //Step 18, repeat start to begin change from write to read
        $I2C_18
        APBREAD 1 0x04
        CMP DAT8 0x28
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 19
        JUMP $RepeatStartI2C

        //Step 19, write address light sens, set to Read
        //I2C will swap to Master/Receiver mode
        $I2C_19
        APBREAD 1 0x04
        CMP DAT8 0x10
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b1
        IOWRT DAT8 20
        JUMP $ContinueI2C

        //Step 20, prep to read CH0_0 register data
        $I2C_20
        APBREAD 1 0x04
        CMP DAT8 0x40
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 21
        JUMP $ContinuteI2CRead

        //Step 21, actually finally read CH0_0 register data
        $I2C_21
        APBREAD 1 0x04
        CMP DAT8 0x58
        JUMP IFNOT ZERO $AbandonShip
        APBREAD 1 0x08
        APBWRT ACC 0 0x02
        IOWRT DAT8 22
        JUMP $StopStartI2C

    //END Light Sens Read CH0_0

    //BEGIN Light Sens Read CH0_1
        //Step 22, write address light sens for CH0_1 read process
        $I2C_22
        APBREAD 1 0x04
        CMP DAT8 0x08
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b0
        IOWRT DAT8 23
        JUMP $ContinueI2C

        //Step 23, write CH0_1 register address
        $I2C_23
        APBREAD 1 0x04
        CMP DAT8 0x18
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 0x8B
        IOWRT DAT8 24
        JUMP $ContinueI2C

        //Step 24, repeat start to begin change from write to read
        $I2C_24
        APBREAD 1 0x04
        CMP DAT8 0x28
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 25
        JUMP $RepeatStartI2C

        //Step 25, write address light sens, set to Read
        //I2C will swap to Master/Receiver mode
        $I2C_25
        APBREAD 1 0x04
        CMP DAT8 0x10
        JUMP IFNOT ZERO $AbandonShip
        APBWRT DAT8 1 0x08 (0x29 << 1) | 0b1
        IOWRT DAT8 26
        JUMP $ContinueI2C

        //Step 26, prep to read CH0_1 register data
        $I2C_26
        APBREAD 1 0x04
        CMP DAT8 0x40
        JUMP IFNOT ZERO $AbandonShip
        IOWRT DAT8 27
        JUMP $ContinuteI2CRead

        //Step 27, actually finally read CH0_1 register data
        $I2C_27
        APBREAD 1 0x04
        CMP DAT8 0x58
        JUMP IFNOT ZERO $AbandonShip
        APBREAD 1 0x08
        APBWRT ACC 0 0x02
        //GO BACK TO STEP 4
        IOWRT DAT8 4
        JUMP $StopI2C
    
    //END Light Sens Read CH0_1

    //END LIGHT SENS READ STATES


    //BEGIN I2C shared Functions?

        $ContinuteI2CRead
        APBREAD 1 0x00
        AND DAT8 0b11000011
        APBWRT ACC 1 0x00
        RETISR

        $ContinueI2C
        APBREAD 1 0x00
        AND DAT8 0b11000111
        APBWRT ACC 1 0x00
        RETISR

        $RepeatStartI2C
        APBREAD 1 0x00
        AND DAT8 0b11110111
        OR DAT8 0b00100000
        APBWRT ACC 1 0x00
        RETISR

        $StopStartI2C
        APBREAD 1 0x00
        AND DAT8 0b11110111
        OR DAT8 0b00110000
        APBWRT ACC 1 0x00
        RETISR

        $StopI2C
        APBREAD 1 0x00
        AND DAT8 0b11110111
        OR DAT8 0b00010000
        APBWRT ACC 1 0x00
        RETISR

        $AbandonShip
        //Abandon i2c message, reset, whatever
        IOWRT DAT8 0xFF
        JUMP $StopI2C

    //END I2C shared function things


    //Handle APB_Slave interrupt, custom logic, its magic
    $INTAPBSLAVE
    
    RETISR
    
$MAIN
    //Set Timer Prescale to PCLK/64 (0b0100)
    APBWRT DAT8 2 0x0C 0b0100
    //Load Timer with round(39062.5)
    APBWRT DAT 2 0x00 39063
    //Start Timer
    APBWRT DAT8 2 0x08 0b011


    //Initialize I2C
    //Set I2C CLK to  PCLK/60 (0b110)
        //Set in GUI
    //Send I2C Start
    APBREAD 1 0x00
    OR DAT8 0b01100000
    APBWRT ACC 1 0x00
    
    //Write I2C init step to feedbackIO
    IOWRT DAT8 0
    

    APBWRT DAT8 0 0xFF 0x00
    APBWRT DAT8 0 0xF0 0x00

HALT