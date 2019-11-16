# vhdl-experiments
All the mumbo jumbo code that is me learning VHDL. Targeted for Microsemi Smartfusion2.
https://www.digikey.com/product-detail/en/microsemi-corporation/M2S010-MKR-KIT/1100-1288-ND/6709124


Project Chronology:

1. Basic_VHDL_Thing
    * Hardware port validation
1. APB3_Practice
    * APB3 AMBA Bus
    * IP Core: I2C
    * IP Core: timer
    * VHDL I2C slave
1. Ultimate LED Controller (builds off APB3_Practice)
    * PWM
    * I2C connection to onboard light sensor
1. Nokia5110_first
    * write to Nokia5110 from RTL memory
    * SPI
1. Nokia5110_Driver_Block (builds off Nokia5110_first)
    * Synplify Pro Infer uSRAM blocks
    * Generic controlled generated logic
    * LCD frame buffer
1. Delta_Sigma_first (incorporates Nokia5110_Driver_Block)
    * LVDS Analog to pulse bitstream
    * Pulse bitstream to quantized integer numbers
    * Convert integer values to pixel bars for graph display
    * Writing pixel data to Nokia5110 LCD with frame buffer
