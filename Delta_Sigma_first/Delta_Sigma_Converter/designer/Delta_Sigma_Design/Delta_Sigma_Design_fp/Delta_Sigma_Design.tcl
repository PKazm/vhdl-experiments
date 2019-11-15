open_project -project {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Delta_Sigma_Converter\designer\Delta_Sigma_Design\Delta_Sigma_Design_fp\Delta_Sigma_Design.pro}
enable_device -name {M2S010} -enable 1
set_programming_file -name {M2S010} -file {C:\Users\Phoenix136\Dropbox\FPGA\Microsemi\Delta_Sigma_Converter\designer\Delta_Sigma_Design\Delta_Sigma_Design.ppd}
set_programming_action -action {PROGRAM} -name {M2S010} 
run_selected_actions
set_programming_file -name {M2S010} -no_file
save_project
close_project
