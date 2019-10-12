This project was intended to validate FPGA pin assignments with physical pins located on the developenent board.

The VHDL is essentially a FSM driven demux in which pressing Button1 will progress to the next state, and thereby output the clock signal on the next output. Button2 as well as "overflowing" the FSM will reset the FSM to 0.
