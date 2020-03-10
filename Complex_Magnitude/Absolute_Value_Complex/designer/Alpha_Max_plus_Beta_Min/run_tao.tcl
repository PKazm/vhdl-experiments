set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\HARD_MULT_ADDSUB_C1\HARD_MULT_ADDSUB_C1_0\HARD_MULT_ADDSUB_C1_HARD_MULT_ADDSUB_C1_0_HARD_MULT_ADDSUB.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\HARD_MULT_ADDSUB_C1\HARD_MULT_ADDSUB_C1.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\FFT_Package.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\hdl\Alpha_Max_plus_Beta_Min.vhd}
set_top_level {Alpha_Max_plus_Beta_Min}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\designer\Alpha_Max_plus_Beta_Min\synthesis.fdc}
