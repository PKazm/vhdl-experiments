quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/LITE-ON_Optical_Sensor_Core"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Core.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Core_APB3.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/I2C_Core_APB3_tb.vhd"

vsim -L SmartFusion2 -L presynth  -t 1fs presynth.I2C_Core_APB3_tb
add wave /I2C_Core_APB3_tb/*
run .1ms
