set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\support.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\acmtable.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\instructnvm_bb.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\iram512x9_rtl.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\instructram.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\test\misc.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\test\textio.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\debugblk.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\instructions.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\ram128x8_smartfusion2.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\ram256x16_rtl.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\ram256x8_rtl.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\ramblocks.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\coreabc.vhd}
read_vhdl -mode vhdl_2008 -lib COREABC_LIB {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0_0\rtl\vhdl\core\components.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\COREABC_C0\COREABC_C0.vhd}
set_top_level {COREABC_C0}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\designer\COREABC_C0\synthesis.fdc}
