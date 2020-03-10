# Complex Magnitude

This project will go over several methods for calculating the magnitude, or absolute value, of complex numbers implemented on an FPGA.

## Brute Force

Implement the Pythagorean Theorem into hardware: a^2 + b^2 = c^2. The multiplications are alright, the problem comes with find the square root to determine 'c'. This is possible but expensive.

## Alpha Max plus Beta Min

This method is an approximation algorithm: Mag ~= Alpha * max(|I|, |Q|) + Beta * min(|I|, |Q|)

This is a very simple method requiring 3 steps only. logic to determine which value is the greatest, then the multiplication and addition, then a rounding step if necessary (it is).

## CORDIC

This is a versatile algorithm that uses a concept of rotating the input point around a circle. The radius of the circle is the distance from the origin to the input point and the process of rotating it can be simplified to a series of bit shifts (multiplying and dividing by 2).

Unfortunately the IP Core provided by Microsemi doesn't seem to produce accurate results in Rectangular to Polar mode.

E.g. inputting 6 and 6 gives 18, while inputting 7 and 7 gives 9. There is a gain as a result of the algorithm but a basic understanding of what should be happening suggests the result for 7 and 7 should be larger than 6 and 6.