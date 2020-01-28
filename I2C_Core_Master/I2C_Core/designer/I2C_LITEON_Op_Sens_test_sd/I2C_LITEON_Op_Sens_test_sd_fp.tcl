new_project \
         -name {I2C_LITEON_Op_Sens_test_sd} \
         -location {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\I2C_Core\designer\I2C_LITEON_Op_Sens_test_sd\I2C_LITEON_Op_Sens_test_sd_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S010} \
         -name {M2S010}
enable_device \
         -name {M2S010} \
         -enable {TRUE}
save_project
close_project
