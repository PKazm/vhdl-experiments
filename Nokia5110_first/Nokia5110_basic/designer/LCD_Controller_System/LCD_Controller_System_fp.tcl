new_project \
         -name {LCD_Controller_System} \
         -location {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Nokia5110_basic\designer\LCD_Controller_System\LCD_Controller_System_fp} \
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
