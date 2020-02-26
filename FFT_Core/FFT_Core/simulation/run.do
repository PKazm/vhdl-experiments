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

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0_0/FCCC_C0_FCCC_C0_0_FCCC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FCCC_C0/FCCC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0_0/OSC_C0_OSC_C0_0_OSC.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/OSC_C0/OSC_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/HARD_MULT_ADDSUB_C0/HARD_MULT_ADDSUB_C0_0/HARD_MULT_ADDSUB_C0_HARD_MULT_ADDSUB_C0_0_HARD_MULT_ADDSUB.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/HARD_MULT_ADDSUB_C0/HARD_MULT_ADDSUB_C0.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/FFT_Butterfly_HW_MATHDSP.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/LFSR_Fib_Gen.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/Twiddle_table.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/work/FFT_Butterfly_test_sd/FFT_Butterfly_test_sd.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/FFT_Package.vhd"

vsim -L SmartFusion2 -L presynth  -t 1fs presynth.FFT_Butterfly_test_sd
# The following lines are commented because no testbench is associated with the project
# add wave /tesbench/*
# run 1000ns
