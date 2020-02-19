set_family {SmartFusion2}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\FCCC_C1\FCCC_C1_0\FCCC_C1_FCCC_C1_0_FCCC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\FCCC_C1\FCCC_C1.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\LED_inverter_dimmer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\OSC_C1\OSC_C1_0\OSC_C1_OSC_C1_0_OSC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\OSC_C1\OSC_C1.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Pixelbar_Creator.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Power_On_Reset_Delay.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Averaging_Filter.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\timer.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\hdl\Sigma_Delta_LVDS_ADC.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\Sigma_Delta_system\Sigma_Delta_system.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\component\work\Sigma_Delta_test_sd\Sigma_Delta_test_sd.vhd}
set_top_level {Sigma_Delta_test_sd}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\designer\Sigma_Delta_test_sd\synthesis.fdc}
