set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\hdl\I2C_Core.vhd}
set_top_level {I2C_Core}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\LITE-ON_Optical_Sensor_Core\designer\I2C_Core\synthesis.fdc}
