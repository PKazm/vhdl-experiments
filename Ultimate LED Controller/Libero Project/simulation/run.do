quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/Blink_The_Good_One"
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
if {[file exists COREI2C_LIB/_info]} {
   echo "INFO: Simulation library COREI2C_LIB already exists"
} else {
   file delete -force COREI2C_LIB 
   vlib COREI2C_LIB
}
vmap COREI2C_LIB "COREI2C_LIB"

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
vcom -2008 -explicit  -work COREI2C_LIB "${PROJECT_DIR}/component/Actel/DirectCore/COREI2C/7.2.101/rtl/vhdl/core/corei2creal.vhd"
vcom -2008 -explicit  -work COREI2C_LIB "${PROJECT_DIR}/component/work/COREI2C_C0/COREI2C_C0_0/rtl/vhdl/core/corei2c.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/COREI2C_C0/COREI2C_C0.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3_muxptob3.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3_iaddr_reg.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/coreapb3.vhd"
vcom -2008 -explicit  -work COREAPB3_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAPB3/4.1.100/rtl/vhdl/core/components.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/CoreAPB3_C0/CoreAPB3_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Fake_Light_Sensor.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/I2C_Pull_Up.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/timer.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/LED_Controller.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0_0/OSC_C0_OSC_C0_0_OSC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/Blinking_System/Blinking_System.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/coreparameters_tgi.vhd"

vsim -L SmartFusion2 -L presynth -L COREABC_LIB -L COREAPB3_LIB -L COREI2C_LIB  -t 1fs presynth.Blinking_System
# The following lines are commented because no testbench is associated with the project
# add wave /testbench/*
# run 1000ns
