quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/I2C_Core"
source "${PROJECT_DIR}/simulation/bfmtovec_compile.tcl";

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"
if {[file exists COREABC_LIB/_info]} {
   echo "INFO: Simulation library COREABC_LIB already exists"
} else {
   file delete -force COREABC_LIB 
   vlib COREABC_LIB
}
vmap COREABC_LIB "COREABC_LIB"
if {[file exists COREAPB3_LIB/_info]} {
   echo "INFO: Simulation library COREAPB3_LIB already exists"
} else {
   file delete -force COREAPB3_LIB 
   vlib COREAPB3_LIB
}
vmap COREAPB3_LIB "COREAPB3_LIB"
if {[file exists CORETIMER_LIB/_info]} {
   echo "INFO: Simulation library CORETIMER_LIB already exists"
} else {
   file delete -force CORETIMER_LIB 
   vlib CORETIMER_LIB
}
vmap CORETIMER_LIB "CORETIMER_LIB"

vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/support.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/acmtable.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/instructnvm_bb.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/iram512x9_rtl.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/instructram.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/test/misc.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/test/textio.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/debugblk.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/instructions.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/ram128x8_smartfusion2.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/ram256x16_rtl.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/ram256x8_rtl.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/ramblocks.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/coreabc.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/rtl/vhdl/core/components.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3_muxptob3.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3_iaddr_reg.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/components.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CoreAPB3_C0/CoreAPB3_C0.vhd"
vcom -2008 -explicit  -work CORETIMER_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreTimer/2.0.103/rtl/vhdl/core/coretimer_pkg.vhd"
vcom -2008 -explicit  -work CORETIMER_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreTimer/2.0.103/rtl/vhdl/core/coretimer.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CoreTimer_C0/CoreTimer_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Fake_Light_Sensor.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Pull_Up.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/LED_controller.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0_0/OSC_C0_OSC_C0_0_OSC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Core.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Instruction_RAM.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Core_APB3.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/I2C_LITEON_Op_Sens_test_sd/I2C_LITEON_Op_Sens_test_sd.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/coreparameters_tgi.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/I2C_LITEON_Op_Sens_test_tb.vhd"

vsim -L SmartFusion2 -L presynth -L COREABC_LIB -L COREAPB3_LIB -L CORETIMER_LIB  -t 100ps presynth.I2C_LITEON_Op_Sens_test_tb
add wave /I2C_LITEON_Op_Sens_test_tb/*
run 1ms
