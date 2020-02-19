set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\FCCC_C0\FCCC_C0_0\FCCC_C0_FCCC_C0_0_FCCC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\FCCC_C0\FCCC_C0.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\OSC_C0\OSC_C0_0\OSC_C0_OSC_C0_0_OSC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\OSC_C0\OSC_C0.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\Twiddle_table.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\Butterfly_HW_DSP.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\hdl\LFSR_Fib_Gen.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\component\work\vhdl_complex_mult_test_sd\vhdl_complex_mult_test_sd.vhd}
set_top_level {vhdl_complex_mult_test_sd}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\FFT_Core\designer\vhdl_complex_mult_test_sd\synthesis.fdc}
