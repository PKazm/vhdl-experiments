open_project -project {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Blink_The_Good_One\designer\Blinking_System\Blinking_System_fp\Blinking_System.pro}
enable_device -name {M2S010} -enable 1
set_programming_file -name {M2S010} -file {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Blink_The_Good_One\designer\Blinking_System\Blinking_System.ppd}
set_programming_action -action {PROGRAM} -name {M2S010} 
run_selected_actions
set_programming_file -name {M2S010} -no_file
save_project
close_project
