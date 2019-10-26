# Ultimate LED Controller
This project builds off an older PWM project as well as the APB3_practice project.

There are several updates as compared to APB3_practice:
- CoreABC assembly code has been rewritten to reduce program size (and therefore fabric usage) as well as interrupt processing time. This was accomplished by implementing a smarter State machine that reuses instructions and uses a broader but shorter effective logic tree to handle interrupts. This could be further optimized for speed during runtime by reordering the JUMP instructions based on the expected operation of the system but the gains in performance (that I don't need for this project) are not worth the loss of readability.
- LED_Controller implements a new APB interface for registers (as compared to APB_Slave in APB3_practice). This allows registers to be written to from multiple sources while still being synthesizable for hardware.


It is likely I will expand this project in the future to include the following in no particular order:
- Light Sensor data DSP. Probably something to smoothly transition to new Light Sensor values instead of the abrupt changes currently.
- SPI controlled LCD. Display information on a Nokia 5110.
- VGA output to a computer monitor. VGA output was a project I had done in college but haven't touched in 6(?) years. As the devboard I'm using does not include a VGA plug, I will have to frankenwire something, and also lose a monitor.
