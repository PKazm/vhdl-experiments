# Written by Synplify Pro version mapact, Build 2461R. Synopsys Run ID: sid1573032190 
# Top Level Design Parameters 

# Clocks 
create_clock -period 10.000 -waveform {0.000 5.000} -name {Nokia5110_Driver_Block_SD|CLK} [get_ports {CLK}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {timerZ1|timer_clock_out_sig_inferred_clock} [get_pins {Nokia5110_Driver_0/SPI_timer/timer_clock_out_sig/Q}] 

# Virtual Clocks 

# Generated Clocks 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 

# Output Load Constraints 

# Driving Cell Constraints 

# Input Delay Constraints 

# Output Delay Constraints 

# Wire Loads 

# Other Constraints 

# syn_hier Attributes 

# set_case Attributes 

# Clock Delay Constraints 
set Inferred_clkgroup_0 [list Nokia5110_Driver_Block_SD|CLK]
set Inferred_clkgroup_1 [list timerZ1|timer_clock_out_sig_inferred_clock]
set_clock_groups -asynchronous -group $Inferred_clkgroup_0
set_clock_groups -asynchronous -group $Inferred_clkgroup_1


# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 

# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 

