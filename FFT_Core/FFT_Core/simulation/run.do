quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/FFT_Core"
onerror { quit -f }
onbreak { quit -f }

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Twiddle_table.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Butterfly_HW_DSP.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/Butterfly_HW_DSP_tb.vhd"

vsim -L SmartFusion2 -L presynth  -t 1fs presynth.Butterfly_HW_DSP_tb
add wave /Butterfly_HW_DSP_tb/*
run 1000ns
log /Butterfly_HW_DSP_tb/*
exit
