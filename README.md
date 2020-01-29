# vhdl-experiments
All the mumbo jumbo code that is me learning VHDL. Targeted for Microsemi Smartfusion2.
https://www.digikey.com/product-detail/en/microsemi-corporation/M2S010-MKR-KIT/1100-1288-ND/6709124


Project Chronology:

1. [Basic_VHDL_Thing](https://github.com/PKazm/vhdl-experiments/tree/master/Basic_VHDL_Thing)
    * Hardware I/O validation
1. [APB3_Practice](https://github.com/PKazm/vhdl-experiments/tree/master/APB3_practice)
    * APB3 AMBA Bus
    * IP Core: I2C
    * IP Core: timer
    * VHDL I2C slave
    * most projects after this also incorporate APB busses with better slave implementations.
1. [Ultimate LED Controller](https://github.com/PKazm/vhdl-experiments/tree/master/Ultimate%20LED%20Controller)
    * Builds off APB3_Practice
    * PWM
    * I2C connection to onboard light sensor
1. [Nokia5110_first](https://github.com/PKazm/vhdl-experiments/tree/master/Nokia5110_first)
    * write to Nokia5110 from RTL memory
    * SPI
1. [Nokia5110_Driver_Block](https://github.com/PKazm/vhdl-experiments/tree/master/Nokia5110_Driver_Block) (updated as bugs/features found in future projects)
    * Builds off Nokia5110_first
    * Synplify Pro Infer uSRAM blocks
    * Generic controlled generated logic
    * LCD frame buffer
1. [Delta_Sigma_first (WIP)](https://github.com/PKazm/vhdl-experiments/tree/master/Delta_Sigma_first)
    * Incorporates Nokia5110_Driver_Block
    * LVDS Analog to pulse bitstream
    * Pulse bitstream to quantized integer numbers
    * Convert integer values to pixel bars for graph display
    * Writing pixel data to Nokia5110 LCD with frame buffer
1. [I2C Master (WIP)](https://github.com/PKazm/vhdl-experiments/tree/master/I2C_Core_Master)
    * Intended to be a generic I2C master I will use in future projects
    * Incorporates a simple instruction queue to perform complete I2C transactions without calling out to a bus master
