quietly set ACTELLIBNAME SmartFusion2
quietly set PROJECT_DIR "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/Absolute_Value_Complex"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap SmartFusion2 "C:/Microsemi/Libero_SoC_v12.1/Designer/lib/modelsimpro/precompiled/vlog/SmartFusion2"
if {[file exists CORECORDIC_LIB/_info]} {
   echo "INFO: Simulation library CORECORDIC_LIB already exists"
} else {
   file delete -force CORECORDIC_LIB 
   vlib CORECORDIC_LIB
}
vmap CORECORDIC_LIB "CORECORDIC_LIB"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/HARD_MULT_ADDSUB_C1/HARD_MULT_ADDSUB_C1_0/HARD_MULT_ADDSUB_C1_HARD_MULT_ADDSUB_C1_0_HARD_MULT_ADDSUB.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/HARD_MULT_ADDSUB_C1/HARD_MULT_ADDSUB_C1.vhd"
vcom -2008 -explicit  -work presynth "C:/Users/Phoenix136/Dropbox/FPGA/Microsemi/FFT_Core/hdl/FFT_Package.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Alpha_Max_plus_Beta_Min.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CORECORDIC/4.0.102/rtl/vhdl/core/cordic_rtl_pack.vhd"
vcom -2008 -explicit  -work CORECORDIC_LIB "${PROJECT_DIR}/component/work/CORECORDIC_C0/CORECORDIC_C0_0/coreparameters.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/Alpha_Max_plus_Beta_Min_tb.vhd"

vsim -L SmartFusion2 -L presynth -L CORECORDIC_LIB  -t 1ps presynth.testbench
add wave /testbench/*
run 10000ns
