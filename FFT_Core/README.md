# FFT Core

This FFT is going to be used in conjunction with the ADC Core and Nokia5110 driver to create an FPGA based FFT plotter, and later on an auto triggering and time scaling oscilliscope.

## Overview of Implementation

This FFT will be made up of 3 major components

1. Input Manager
    * This component handles all sample inputs by storing them in SRAM, tracking when the sample memory is full, etc.
1. Output Manager
    * This component keeps track of when the output data is valid and whether it has been read.
1. The Transform
    * The real meat. This component performs the FFT transformation

There is also a top level manager that monitors the completion status of each of the input, output, and transform components. Each component is assigned an SRAM block and enabled. This is when inputs may be written, outputs may be read, and the transform may be processed. Each component will then issue a "complete" signal (mem full, output complete, transform complete) at which point the SRAM blocks will be linked to the next component.

This process ensures that each component will have valid data for its duration and can be operated on in parallel.

![FFT system](FFT_Core/EXTRA%20FILES/Diagrams/FFT_System_Diagram.png)

## The Butterfly

Currently the butterfly for this design uses 2 Hardware Math blocks in Dot Product mode to complete 1 complex number multiplication in a single clock cycle. Within the Smartfusion2 device this is limited to a 9x9 bit multiplication. e.g.

Result = A x B + C x D; where A, B, C, and D are 9 bit numbers.

Getting the DOTP mode to be instantiated correctly meant I couldn't rely on Synopsis inferring correctly as the specific configuration of the Math block is not supported. I therefore had to find the component and bring it into my HDL for usage.

After the multiplication, the result is added or subtracted to the second sample through distributed arithmetic blocks. I let the tool figure this part out.

All told, the basic butterfly data flow looks like the following:

![Butterfly Schematic](FFT_Core/EXTRA%20FILES/Diagrams/Butterfly_Block_Diagram.png)

In order to achieve 200Mhz timing the butterfly will be setup in pipeline mode consisting of 2 stages. Each stage will have a set of flipflops as the final step. The first stage is the Math blocks. These accept unbuffered data on the component input ports that feed directly into the Math block. My assumption is that the Butterfly manager logic I write will have a set of registers feeding these inputs directly. The result of the Math blocks will be stored in a set of registers.

The second stage will take the values from the Math block registers and perform the addition and subtraction to calculate the final values for the 2 complex number samples.

There will also be registers that carry along the sample memory addresses so that when the final results are output the SRAM writing logic won't have to go searching for what address the data belongs to.

At the moment, the worst case path within the butterfly is between the input flipflop feeding the Math block and the pipeline flipflop that stores the Math block's result. This gives an estimate of just over 200Mhz for the butterfly. I'm not sure I can get much faster than that I can get the design. I think I can find some more time in routing (30% of the delay) but it probably isn't worth the effort.

![Butterfly Pipeline Sim](FFT_Core/EXTRA%20FILES/Diagrams/Butterfly_Timing_Sim.png)

![RAM and Butterfly pipeline](FFT_Core/EXTRA%20FILES/Wavedrom/butterfly_2_DPLSRAM_timing.png)

## The Transformer, frequency in disguise

Currently working with as an 8 stage pipeline from SRAM read location to SRAM write location. Uses 2 LSRAM blocks that it ping pongs between to maximize memory accesses per time.

Output compared to custom GNU Octave integer FFT version which is itself compared to the built in Octave FFT function. Some discrepencies do occur which I believe are the result of the Octave integer rounding using a "Round half away from zero" method while my Butterfly calculations use a "Round half to even" implementation.

The transform does seem able to hit 200Mhz. Initial synthesis runs give 211Mhz estimate with about 70% delay due to routing. As the full core isn't done I'll wait to make more changes if necessary.

The transform while connected to 2 LSRAM blocks for testing uses the following resources:

* 344 DFF
* 317 LUT
* 2 DSP blocks
* 2 LSRAM
* 1 SRAM (twiddle table size depends on FFT size)



## Resources Used

Goal: 3 LSRAM, 2 DSP, minimum 100Mhz, 2 clock cycles per butterfly calculation.
