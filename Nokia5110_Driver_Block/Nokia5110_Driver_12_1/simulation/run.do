quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/Nokia5110_Driver_12_1"
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
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/timer.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Nokia5110_Driver.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0_0/OSC_C0_OSC_C0_0_OSC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/URAM_C0/URAM_C0_0/URAM_C0_URAM_C0_0_URAM.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/URAM_C0/URAM_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/Nokia5110_Driver_Block_SD/Nokia5110_Driver_Block_SD.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/Driver_Container/Driver_Container.vhd"
vcom -2008 -explicit  -work COREABC_LIB "${PROJECT_DIR}/component/work/COREABC_C0/COREABC_C0_0/coreparameters_tgi.vhd"

vsim -L SmartFusion2 -L presynth -L COREABC_LIB -L COREAPB3_LIB  -t 100ps presynth.Driver_Container
# The following lines are commented because no testbench is associated with the project
# add wave /testbench/*
# run 2.1ms
