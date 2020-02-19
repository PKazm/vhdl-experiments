# Written by Synplify Pro version mapact, Build 2461R. Synopsys Run ID: sid1580786908 
# Top Level Design Parameters 

# Clocks 
create_clock -period 10.000 -waveform {0.000 5.000} -name {FCCC_C1_FCCC_C1_0_FCCC|GL0_net_inferred_clock} [get_pins {FCCC_C1_0/FCCC_C1_0/CCC_INST/GL0}] 
create_clock -period 10.000 -waveform {0.000 5.000} -name {timer|timer_clock_out_sig_inferred_clock} [get_pins {Sigma_Delta_system_0/Sigma_Delta_LVDS_ADC_0/Sample_CLK_timer/timer_clock_out_sig/Q}] 

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
set Inferred_clkgroup_0 [list FCCC_C1_FCCC_C1_0_FCCC|GL0_net_inferred_clock]
set Inferred_clkgroup_1 [list timer|timer_clock_out_sig_inferred_clock]
set_clock_groups -asynchronous -group $Inferred_clkgroup_0
set_clock_groups -asynchronous -group $Inferred_clkgroup_1


# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 

# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 

