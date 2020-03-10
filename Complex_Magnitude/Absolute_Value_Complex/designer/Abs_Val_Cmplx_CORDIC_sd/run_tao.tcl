set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 -lib CORECORDIC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\Actel\DirectCore\CORECORDIC\4.0.102\rtl\vhdl\core\cordic_rtl_pack.vhd}
read_vhdl -mode vhdl_2008 -lib CORECORDIC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\Actel\DirectCore\CORECORDIC\4.0.102\rtl\vhdl\core\cordic_kit.vhd}
read_vhdl -mode vhdl_2008 -lib CORECORDIC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\CORECORDIC_C0\CORECORDIC_C0_0\rtl\vhdl\core\cordic_par.vhd}
read_vhdl -mode vhdl_2008 -lib CORECORDIC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\CORECORDIC_C0\CORECORDIC_C0_0\CORECORDIC_C0_CORECORDIC_C0_0_CordicLUT_word.vhd}
read_vhdl -mode vhdl_2008 -lib CORECORDIC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\CORECORDIC_C0\CORECORDIC_C0_0\rtl\vhdl\core\cordic_word.vhd}
read_vhdl -mode vhdl_2008 -lib CORECORDIC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\CORECORDIC_C0\CORECORDIC_C0_0\rtl\vhdl\core\CORECORDIC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\CORECORDIC_C0\CORECORDIC_C0.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\component\work\Abs_Val_Cmplx_CORDIC_sd\Abs_Val_Cmplx_CORDIC_sd.vhd}
set_top_level {Abs_Val_Cmplx_CORDIC_sd}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Absolute_Value_Complex\designer\Abs_Val_Cmplx_CORDIC_sd\synthesis.fdc}
