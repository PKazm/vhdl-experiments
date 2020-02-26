# vhdl-experiments
All the mumbo jumbo code that is me learning VHDL. Targeted for Microsemi Smartfusion2.
https://www.digikey.com/product-detail/en/microsemi-corporation/M2S010-MKR-KIT/1100-1288-ND/6709124

## Why Smartfusion2?
I would like to do FPGA design for satellites. In my research it seems the most common part selection for these types of missions are FPGAs that use flash based configuration memory. Flash based configuration has inherent upset tolerence (immunity?) characteristics that make configuration validation on "normal" FPGAs unecessary, this reduces the amount of work to implement a design.

The 2 major providers of flash based FPGAs are Xilinx with a few select products, and Microsemi (formerly Actel) across their entire line of products.

Non specialized versions of Xilinx FPGA development boards start in the $70 range with limited accessible I/O and little to no onboard peripherals or interfaces (VGA, ethernet, etc.). Additionally there was a change to new design tools that threw into question whether the older design tool that supported the FPGAs on the cheaper dev boards would run on a modern Windows 10 OS. It probably would but figuring all compatibilites out sort of becomes its own project.

Microsemi on the other hand has the previously linked dev board for ~$40 shipped. The Smartfusion2 device is a SoC FPGA and is supported by the most recent versions of the designer software. The FPGA portion shares features with Igloo2 devices (the standalone FPGA version) and RTG4 devices (Microsemi's second to current space grade/radiation hardened FPGA). Notably the block RAM, and DSP math blocks seem to be copy/pasted between the $40 smartfusion2 kit I purchased and the RTG4 devices supposedly being used by NASA.

Conclusion: Price, ability to accumulate device applicable knowledge to my area of interest, and the promise of modern tools with ongoing support all pointed to Smartfusion2.

## Project Chronology:

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
1. [Delta_Sigma_first](https://github.com/PKazm/vhdl-experiments/tree/master/Delta_Sigma_first)
    * Incorporates Nokia5110_Driver_Block
    * LVDS Analog to pulse bitstream
    * Pulse bitstream to quantized integer numbers
    * Convert integer values to pixel bars for graph display
    * Writing pixel data to Nokia5110 LCD with frame buffer
1. [I2C Master (WIP)](https://github.com/PKazm/vhdl-experiments/tree/master/I2C_Core_Master)
    * Intended to be a generic I2C master I will use in future projects
    * Incorporates a simple instruction queue to perform complete I2C transactions without calling out to a bus master
1. [Delta-Sigma ADC](https://github.com/PKazm/vhdl-experiments/tree/master/Delta_Sigma_ADC)
    * Rewritten as I found more resources and continued to understand the parts of the design
    * Includes a simple averaging filter
1. [FFT Core (WIP)](https://github.com/PKazm/vhdl-experiments/tree/master/FFT_Core)
    * I need an FFT core, I want to understand FFTs, so I am writing my own FFT
    * Uses uSRAM to store complex numbers
    * Uses DSP/Math blocks in DOTP mode for complex multiplication
    * Operates on 9 bit signed numbers
    * 9 bit signed twiddle factors with a post multiplication bit shift to correct the scaled twiddle values and stay within 9 bits.
1. **On The Menu**
    * Auto trigger and time scaling oscilliscope.
        * Delta Sigma for data samples
        * FFT for time scaling
        * Edge detector for triggering
        * Nokia5110 LCD for display
        * CoreABC to tie everything together
