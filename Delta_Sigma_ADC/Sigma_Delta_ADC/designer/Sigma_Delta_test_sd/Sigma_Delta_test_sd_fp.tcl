new_project \
         -name {Sigma_Delta_test_sd} \
         -location {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Sigma_Delta_ADC\designer\Sigma_Delta_test_sd\Sigma_Delta_test_sd_fp} \
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
