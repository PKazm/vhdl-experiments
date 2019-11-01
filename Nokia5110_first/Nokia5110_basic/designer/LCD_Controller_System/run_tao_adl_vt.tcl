set_family {SmartFusion2}
read_adl {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_basic\designer\LCD_Controller_System\LCD_Controller_System.adl}
read_afl {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_basic\designer\LCD_Controller_System\LCD_Controller_System.afl}
map_netlist
check_constraints {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_basic\constraint\timing_sdc_errors.log}
write_sdc -strict -afl {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_basic\designer\LCD_Controller_System\timing_analysis.sdc}
