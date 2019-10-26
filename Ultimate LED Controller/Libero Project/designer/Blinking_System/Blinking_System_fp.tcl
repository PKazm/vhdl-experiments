new_project \
         -name {Blinking_System} \
         -location {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Blink_The_Good_One\designer\Blinking_System\Blinking_System_fp} \
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
