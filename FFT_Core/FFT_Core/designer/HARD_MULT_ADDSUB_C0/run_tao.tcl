set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\HARD_MULT_ADDSUB_C0\HARD_MULT_ADDSUB_C0_0\HARD_MULT_ADDSUB_C0_HARD_MULT_ADDSUB_C0_0_HARD_MULT_ADDSUB.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\HARD_MULT_ADDSUB_C0\HARD_MULT_ADDSUB_C0.vhd}
set_top_level {HARD_MULT_ADDSUB_C0}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\designer\HARD_MULT_ADDSUB_C0\synthesis.fdc}
