set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\DPSRAM_C0\DPSRAM_C0_0\DPSRAM_C0_DPSRAM_C0_0_DPSRAM.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\DPSRAM_C0\DPSRAM_C0.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\HARD_MULT_ADDSUB_C0\HARD_MULT_ADDSUB_C0_0\HARD_MULT_ADDSUB_C0_HARD_MULT_ADDSUB_C0_0_HARD_MULT_ADDSUB.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\HARD_MULT_ADDSUB_C0\HARD_MULT_ADDSUB_C0.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\FFT_Package.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\FFT_Butterfly_HW_MATHDSP.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\Twiddle_table.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\FFT_Transformer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\FFT_Transform_test.vhd}
set_top_level {FFT_Transform_test}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\designer\FFT_Transform_test\synthesis.fdc}
