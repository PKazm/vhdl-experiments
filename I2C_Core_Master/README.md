# I2C Core Master

WIP, User Guide in the works but the cool bits are explained below.

This I2C Master is intended to be compatible with the NXP (Philips) I2C specification Rev. 6.

The current features are consistent with Single Master capability and can be seen in detail in the table below.

| Feature | This Core | Single Master | Multi-Master |
| --- | :---: | :---: | :---: |
| START condition | **Yes** | M | M |
| STOP condition | **Yes** | M | M |
| Acknowledge | **Yes** | M | M |
| Synchronization | No | n/a | M |
| Arbitration | No | n/a | M |
| Clock Stretching | **Yes** | O | O |
| 7-bit slave address | **Yes** | M | M |
| 10-bit slave address | **Yes** | O | O |
| General Call Address | **Yes** | O | O |
| Software Reset | **Yes** | O | O |
| START byte | **Yes** | n/a | O |

M = mandatory, O = optional, n/a = not applicable

## Instruction RAM

There is a configurable Instruction RAM which can store up to 64 I2C instructions (START, STOP, DATA, etc.). This limit is due the available address bits being 6 for the RAM location. This RAM is inferred to a uSRAM block by Synplify Pro and initialized to unknown values (classic BRAM). Each address as accessed via APB consists of 2 BRAM locations each 8 bits wide. RAM locations ending in '0' hold the data portion of the address while RAM locations ending in '1' hold the instruction portion. When an instruction sequence is started the I2C Master will iterate through each RAM location and perform the instruction found there in accordance with the table below.

| Bits | Function |
| :---: | --- |
| 000 | No Operation |
| 001 | START Operation |
| 010 | STOP Operation |
| 011 | Repeated START Operation |
| 100 | Write Operation |
| 101 | Read Operation |

If a read operation is performed the data read from the SDA line will be stored in the Data location associated with the read instruction at the end of the I2C operation. These values (and all RAM locations) can be read by the Bus when the sequence has completed.

## Interrupt Based Manual Control

The I2C Master can be controlled on a per operation level by writing to the control register [3:1] bits with the desired operation and setting the I2C run bit in the control register [0]. The I2C will perform the operation and send an interrupt signal upon completion. An exception is a STOP command will not send an interrupt signal.


## Resources Used
Results of I2C with 64 instruction locations synthesis from within my test project for a Smartfusion2 M2S010:

4LUT: 302, DFF: 123, uSRAM: 1

Standalone synthesis timing estimate:

159Mhz
