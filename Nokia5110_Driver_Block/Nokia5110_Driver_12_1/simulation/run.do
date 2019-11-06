quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/Nokia5110_Driver_12_1"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/timer.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Nokia5110_Driver.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/URAM_C0/URAM_C0_0/URAM_C0_URAM_C0_0_URAM.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/URAM_C0/URAM_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/Nokia5110_Driver_Block_SD/Nokia5110_Driver_Block_SD.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/Nokia5110_Driver_tb.vhd"

vsim -L SmartFusion2 -L presynth  -t 100ps presynth.Nokia5110_Driver_tb
add wave /Nokia5110_Driver_tb/*
run 2.1ms
