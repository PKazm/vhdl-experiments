history clear
run_tcl -fg I2C_Core_Block_sd_syn.tcl
set_option -frequency 200
project -run  
set_option -frequency 100
project -run  
project -close C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/I2C_Core/synthesis/I2C_Core_Block_sd_syn.prj
