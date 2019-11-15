new_project \
         -name {Delta_Sigma_Design} \
         -location {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Delta_Sigma_Converter\designer\Delta_Sigma_Design\Delta_Sigma_Design_fp} \
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
