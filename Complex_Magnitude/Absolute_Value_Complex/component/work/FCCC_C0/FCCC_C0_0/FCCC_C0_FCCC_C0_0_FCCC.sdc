set_component FCCC_C0_FCCC_C0_0_FCCC
# Microsemi Corp.
# Date: 2020-Mar-05 18:03:20
#

create_clock -period 20 [ get_pins { CCC_INST/RCOSC_25_50MHZ } ]
create_generated_clock -multiply_by 4 -divide_by 2 -source [ get_pins { CCC_INST/RCOSC_25_50MHZ } ] -phase 0 [ get_pins { CCC_INST/GL0 } ]
