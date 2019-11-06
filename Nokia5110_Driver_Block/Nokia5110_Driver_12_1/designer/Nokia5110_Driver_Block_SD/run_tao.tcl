set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\hdl\timer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\hdl\Nokia5110_Driver.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\component\work\URAM_C0\URAM_C0_0\URAM_C0_URAM_C0_0_URAM.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\component\work\URAM_C0\URAM_C0.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\component\work\Nokia5110_Driver_Block_SD\Nokia5110_Driver_Block_SD.vhd}
set_top_level {Nokia5110_Driver_Block_SD}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_Driver_12_1\designer\Nokia5110_Driver_Block_SD\synthesis.fdc}
