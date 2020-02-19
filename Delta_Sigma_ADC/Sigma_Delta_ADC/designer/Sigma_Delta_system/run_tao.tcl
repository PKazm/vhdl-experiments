set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Averaging_Filter.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\timer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Sigma_Delta_LVDS_ADC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\Sigma_Delta_system\Sigma_Delta_system.vhd}
set_top_level {Sigma_Delta_system}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\designer\Sigma_Delta_system\synthesis.fdc}
