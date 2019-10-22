JUMP $MAIN
// Interrupt Service Routine Here
    
    
    
    $I2C_Process
    APBREAD 1 0x2004
    CMP DAT8 0x08
    JUMP IF ZERO $I2C_0x08_Start_Sent
    CMP DAT8 0x10
    JUMP IF ZERO $I2C_0x10_Restart_Sent
    CMP DAT8 0x18
    JUMP IF ZERO $I2C_0x18_SLA_W_Sent
    CMP DAT8 0x20
    // error transmitting SLA+W, send again
    JUMP IF ZERO $I2C_Continue
    CMP DAT8 0x28
    JUMP IF ZERO $I2C_0x28_Data_Sent
    CMP DAT8 0x30
    // error transmitting Data, send again
    JUMP IF ZERO $I2C_Continue
    //CMP DAT8 0x38
    // arbitration lost
    //JUMP IF ZERO $AbandonShip
    CMP DAT8 0x40
    JUMP IF ZERO $I2C_0x40_SLA_R_Sent
    CMP DAT8 0x48
    // error transmitting SLA+R, send again
    JUMP IF ZERO $I2C_Continue
    //CMP DAT8 0x50
    // ack returned (bad) repeat read will occur
    CMP DAT8 0x58
    JUMP IF ZERO $I2C_0x50_Data_Received
    
    
    $I2C_0x08_Start_Sent
    // 0x08 will always precede an address+W
    APBWRT DAT8 1 0x2008 (0x29 << 1) | 0b0
    JUMP $I2C_Continue
    
    $I2C_0x10_Restart_Sent
    // 0x10 will always precede an address+R (in this design)
    APBWRT DAT8 1 0x2008 (0x29 << 1) | 0b1
    JUMP $I2C_Continue

    $I2C_0x18_SLA_W_Sent
    // 0x18 precedes a register address write
    //I2C_Reg_Addr is set beforehand when state is set
    RAMREAD I2C_Reg_Addr
    APBWRT ACC 1 0x2008
    JUMP $I2C_Continue

    $I2C_0x28_Data_Sent
    // 0x28 preceeds another data write (reg_value), repeat start (reg_read), or stop
    //  I2C_State = 0, I2C_Step = 0
    //      write Reg_Value (only occurs during init in this design)
    //  I2C_State = 0, I2C_Step = 1
    //      both Reg_Addr and Reg_Value have been sent, STOP
    //  I2C_State = [1-3]
    //      reading each Light Sensor channel, RepeatStart (fallthrough)
    RAMREAD I2C_State
    CMP DAT8 0
    JUMP IFNOT ZERO $I2C_RepeatStart
    RAMREAD I2C_Step
    CMP DAT8 1
    JUMP IF ZERO $I2C_Stop
    RAMWRT I2C_Step DAT8 0
    RAMREAD I2C_Reg_Val
    APBWRT ACC 1 0x2008
    JUMP $I2C_Continue

    $I2C_0x40_SLA_R_Sent
    // 0x40 precedes receiving the data byte
    // set ACK response Here
    // literally just set NACk return, which is done in $I2C_Continue_Read
    JUMP $I2C_Continue_Read

    $I2C_0x50_Data_Received
    // 0x50 is the last step, stop or stop/start after this
    //  read I2C data and send to storage register (custom VHDL)
    //  increment I2C_State
    RAMREAD I2C_State
    CMP DAT8 1
    JUMP IF ZERO $I2C_CH1_0
    CMP DAT8 2
    JUMP IF ZERO $I2C_CH1_1
    CMP DAT8 3
    JUMP IF ZERO $I2C_CH0_0
    // fallthrough is CH0_1, prep for CH1_0
        APBREAD 1 0x2008
        APBWRT ACC 2 Light_Store_CH0
        RAMWRT I2C_Reg_Addr 0x88
        JUMP $I2C_Stop
    $I2C_CH1_0
        // prep for CH1_1
        APBREAD 1 0x2008
        APBWRT ACC 2 Light_Store_CH1
        RAMWRT I2C_Reg_Addr 0x89
        JUMP $I2C_StopStart
    $I2C_CH1_1
        // prep for CH0_0
        APBREAD 1 0x2008
        APBWRT ACC 2 Light_Store_CH1
        RAMWRT I2C_Reg_Addr 0x8A
        JUMP $I2C_StopStart
    $I2C_CH0_0
        // prep for CH0_1
        APBREAD 1 0x2008
        APBWRT ACC 2 Light_Store_CH0
        RAMWRT I2C_Reg_Addr 0x8B
        JUMP $I2C_StopStart

    RETISR
    //clear interrupt
    
    //BEGIN I2C Shared Routines

        $I2C_Continue
        // Clear Int (and also Start and Stop)
        APBREAD 1 0x2000
        AND DAT8 0b11000111
        APBWRT ACC 1 0x2000
        RETISR

        $I2C_Continue_Read
        // Clear Int (and Start/Stop) Set return NACK
        APBREAD 1 0x2000
        AND DAT8 0b11000011
        APBWRT ACC 1 0x2000
        RETISR
        
        $I2C_RepeatStart
        // Set state registers
        RAMWRT I2C_Step DAT8 0
        // Clear Int, set Start
        RAMWRT I2C_Step DAT8 0
        APBREAD 1 0x2000
        AND DAT8 0b11000111
        OR DAT8 0b00100000
        APBWRT ACC 1 0x2000
        RETISR

        $I2C_StopStart
        // Set state registers
        // $I2C_StopStart is only called during the read process, so INC state
        RAMWRT I2C_Step DAT8 0
        RAMREAD I2C_State
        INC
        RAMWRT I2C_State ACC
        // Clear Int, set Start and Stop
        APBREAD 1 0x2000
        AND DAT8 0b11000111
        OR DAT8 0b00110000
        APBWRT ACC 1 0x2000
        RETISR
        
        $I2C_Stop
        // Set state registers
        RAMWRT I2C_Step DAT8 0
        RAMWRT I2C_State DAT8 1
        // Clear Int and set Stop
        APBREAD 1 0x2000
        AND DAT8 0b11000111
        OR DAT8 0b00010000
        APBWRT ACC 1 0x2000
        RETISR
        

        $AbandonShip
        // Something wrong with transmission
        RETISR

    //END I2C Shared Routines
    
// End Interrupt Service Routine
// MAIN HERE
$MAIN

    // MSS ADDR Header Most Sig Bits
    // slot: 0
    // Data16 bits: MSB = 0x04, LSB = 0x00
    APBWRT DAT 0 0x0004 0x4000
    
    // MSS Periph PCLK is 100Mhz
    
    // Slot 1 (SPI_0, I2C_0)
    // I2C_0: CTRL      0x40002000
    // I2C_0: STATUS    0x40002004
    // I2C_0: DATA      0x40002008
    // I2C_0: ADDR      0x4000200C
    // I2C_0: SMBUS     0x40002010
    // I2C_0: FREQ      0x40002014
    // I2C_0: GLITCHREG 0x40002018

    // I2C RAM locations
    // RAM 0x00
    //  Stores states for overall operation [0 = reg addr, 1 = reg val]
    // RAM 0x01 Z
    //  Stores states [Init, CH1_0, CH1_1, CH0_0, CH0_1]
    // RAM 0x02
    //  Stores Reg_Addr
    // RAM 0x03
    //  Stores Reg_Value
    DEF I2C_Step 0x00
    DEF I2C_State 0x01
    DEF I2C_Reg_Addr 0x02
    DEF I2C_Reg_Val 0x03
    DEF Data_Store_Addr 0x04

    // Custom VHDL light sensor registers
    DEF Light_Store_CH0 0x01
    DEF Light_Store_CH1 0x02


    // Initialize I2C_0 for Light Sensor
    // PCLK/960 = 0b100; included in enable transfer to save 1 instruction
    //APBWRT DAT8 1 0x2000 0b10000000; This is done when Start is set
    // Load RAM slots for Light Sensor Init over I2C
    RAMWRT I2C_Step DAT8 0
    RAMWRT I2C_State DAT8 0
    RAMWRT I2C_Reg_Addr DAT8 0x80
    RAMWRT I2C_Reg_Val DAT8 0x01
    // Begin Light Sensor init transfer
    APBWRT DAT8 1 0x2000 0b11100000
    
    //


    // SPI_0: CONTROL       0X40001000
    // SPI_0: TXRXDF_SIZE   0X40001004
    // SPI_0: STATUS        0X40001008
    // SPI_0: INT_CLEAR     0X4000100C
    // SPI_0: RX_DATA       0X40001010
    // SPI_0: TX_DATA       0X40001014
    // SPI_0: CLK_GEN       0X40001018
    // SPI_0: SLAVE_SELECT  0X4000101C
    // SPI_0: MIS           0X40001020
    // SPI_0: RIS           0X40001024

    //APBWRT DAT 4 0x1000 0x30

HALT
    $LOOP
        //Loop forever waiting for interrupts
        NOP
    JUMP $LOOP
// END MAIN