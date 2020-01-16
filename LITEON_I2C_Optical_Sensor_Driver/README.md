# LITEON I2C Driver

WIP

This project is an excuse to build my own I2C master that has the capability of performing I2C transactions on its own. There is also the capability of building interfaces for different busses such as Wishbone or AXI without having to rewrite the logic that handles the SDA and SCL lines. As it is I use APB3 the most and have therefore written the initial version to use that.

This I2C Core still needs some robustness work as well as some fixing with regards to the Instruction Sequence functionality.

Currently when using the Instruction Sequence such that a uSRAM is inferred it will synthesize to 2 uSRAM blocks when the data would conceivably fit into 1 block. This is a result of how I wrote the read/write logic and the fact that different parts of the 10 bit vector are used for different things.