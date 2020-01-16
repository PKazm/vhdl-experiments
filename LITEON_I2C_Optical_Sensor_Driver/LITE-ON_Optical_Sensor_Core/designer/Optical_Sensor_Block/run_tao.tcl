set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\hdl\I2C_Core2.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\hdl\I2C_Core2_APB3.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\component\work\Optical_Sensor_Block\Optical_Sensor_Block.vhd}
set_top_level {Optical_Sensor_Block}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\designer\Optical_Sensor_Block\synthesis.fdc}
