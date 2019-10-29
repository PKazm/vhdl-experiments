onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {top testbench sigs}
add wave -noupdate -format Logic -radix hexadecimal /testbench/*
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 206
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {1880 ns}

# get rid of annoying VHDL Warning messages about arithmetic operands
# and numeric_std warnings ...
quietly set StdArithNoWarnings 1
quietly set NumericStdNoWarnings 1
