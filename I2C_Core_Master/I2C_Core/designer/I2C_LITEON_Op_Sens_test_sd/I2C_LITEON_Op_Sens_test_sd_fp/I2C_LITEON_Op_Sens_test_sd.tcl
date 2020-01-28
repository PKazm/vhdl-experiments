open_project -project {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\designer\I2C_LITEON_Op_Sens_test_sd\I2C_LITEON_Op_Sens_test_sd_fp\I2C_LITEON_Op_Sens_test_sd.pro}
enable_device -name {M2S010} -enable 1
set_programming_file -name {M2S010} -file {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\designer\I2C_LITEON_Op_Sens_test_sd\I2C_LITEON_Op_Sens_test_sd.ppd}
set_programming_action -action {PROGRAM} -name {M2S010} 
run_selected_actions
set_programming_file -name {M2S010} -no_file
save_project
close_project
