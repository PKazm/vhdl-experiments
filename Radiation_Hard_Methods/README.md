# Radiation Hard Methods


Subfolders:

1. Basic Design
    * Description of the simple design that Rad_Hard methods will be applied to
2. Combinational FlipFlop
    * As combinational logic is more resilient to upsets, hard flipflops are replaced with combinational flipflops
    * This appears to be unsupported for Smartfusion2 devices as a Synplify attribute
3. Triple Modular Redundancy
    * Instead of single path resiliency, TMR uses redundant components followed by voting to 
4. TMR with Combination Flipflop
    * While TMR is logically immune to single event upsets, 2 upsets would defeat the design. Therefore, reducing the probability of a SEU will in turn reduce the probability of a double event upset. Implementing Combinational flipflops in addition to TMR further increases the FPGA design's radiation hardness.
    * This appears to be unsupported for Smartfusion2 devices as a Synplify attribute
