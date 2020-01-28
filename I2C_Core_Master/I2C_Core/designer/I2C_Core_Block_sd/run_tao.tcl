set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\hdl\I2C_Core.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\hdl\I2C_Instruction_RAM.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\hdl\I2C_Core_APB3.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\component\work\I2C_Core_Block_sd\I2C_Core_Block_sd.vhd}
set_top_level {I2C_Core_Block_sd}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\designer\I2C_Core_Block_sd\synthesis.fdc}
