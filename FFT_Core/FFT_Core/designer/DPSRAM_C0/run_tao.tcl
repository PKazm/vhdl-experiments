set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\DPSRAM_C0\DPSRAM_C0_0\DPSRAM_C0_DPSRAM_C0_0_DPSRAM.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\DPSRAM_C0\DPSRAM_C0.vhd}
set_top_level {DPSRAM_C0}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\designer\DPSRAM_C0\synthesis.fdc}
