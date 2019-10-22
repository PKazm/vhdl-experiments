# WIP
# Blinking_MSS
This project builds off of the APB3_Practice project to utilize peripherals located within the Smartfusion2 Microcontroller Subsystem instead of Fabric cores.

This project is a work in progress and will change over time.

Major improvements include rewriting the I2C state machine assembly code for CoreABC that acts as the I2C Master controller. Notably the instruction count was reduced from 279 to 112. The maximum jumps (and therfore clock cycles) to navigate the new I2C code from any interrupt trigger should have been reduced substantially with the rewrite though I haven't analyzed any of that yet. The instruction count comparison also includes additional functionality related to other peripherals on the APB but the I2C code took most of it.
