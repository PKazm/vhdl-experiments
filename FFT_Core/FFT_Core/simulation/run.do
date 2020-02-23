quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/FFT_Core"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/FFT_Butterfly_HW_MATHDSP.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/FFT_Package.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/FFT_Butterfly_HW_MATHDSP_tb.vhd"

vsim -L SmartFusion2 -L presynth  -t 1fs presynth.FFT_Butterfly_HW_MATHDSP_tb
add wave /FFT_Butterfly_HW_MATHDSP_tb/*
run 1000ns
