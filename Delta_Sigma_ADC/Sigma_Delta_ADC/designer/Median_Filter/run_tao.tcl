set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Median_Filter.vhd}
set_top_level {Median_Filter}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\designer\Median_Filter\synthesis.fdc}
