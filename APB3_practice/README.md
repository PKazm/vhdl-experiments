# APB Practice Project

This project was to learn and implement an APB3 bus in fabric. To accomplish this I created an APB_Slave VHDL component which would accept APB3 commands and read/write to internal registers. A CoreABC from the Libero catalog was used as an APB master and programmed in assembly.

A timer core was added from the Libero Catalog in order to read/write to an existing IP component and generally interact with the included peripherals. This Timer was set to trigger an interrupt every 500msec. This interrupt was captured by the CoreABC which then read, incremented by 1, and wrote to a register in my custom ABP_Slave. This data register was also connected to pins on the chip which connected to 8 LEDs on the dev board.

An I2C core was added from the Libero Catalog with the intention of communicating with the Light Sensor on the board. During the process of writing an abomination of assembly code to act as a state machine for the I2C an I2C_slave was created to mimic the registers and response of the Light Sensor. This approach allowed simulation of the design to debug the I2C controller code as well as confirm my understanding of the I2C protocol.
