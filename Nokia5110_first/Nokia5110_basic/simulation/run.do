quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/Nokia5110_basic"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Nokia5110_Memory.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Nokia5110_Driver.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/timer.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Nokia_Driver_Container.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0_0/OSC_C0_OSC_C0_0_OSC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/LCD_Controller_System/LCD_Controller_System.vhd"

vsim -L SmartFusion2 -L presynth  -t 1fs presynth.LCD_Controller_System
# The following lines are commented because no testbench is associated with the project
# add wave /testbench/*
# run 1000ns
