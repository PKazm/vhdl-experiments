set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\Twiddle_table.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\Butterfly_HW_DSP.vhd}
set_top_level {Butterfly_HW_DSP}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\designer\Butterfly_HW_DSP\synthesis.fdc}
