EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:GND #PWR?
U 1 1 5DBB10F8
P 5200 5050
F 0 "#PWR?" H 5200 4800 50  0001 C CNN
F 1 "GND" H 5205 4877 50  0000 C CNN
F 2 "" H 5200 5050 50  0001 C CNN
F 3 "" H 5200 5050 50  0001 C CNN
	1    5200 5050
	1    0    0    -1  
$EndComp
$Comp
L power:AC #PWR?
U 1 1 5DBB1750
P 3300 3800
F 0 "#PWR?" H 3300 3700 50  0001 C CNN
F 1 "AC" H 3300 4075 50  0000 C CNN
F 2 "" H 3300 3800 50  0001 C CNN
F 3 "" H 3300 3800 50  0001 C CNN
F 4 "R" H 3300 3800 50  0001 C CNN "Spice_Primitive"
F 5 "3.3" H 3300 3800 50  0001 C CNN "Spice_Model"
F 6 "Y" H 3300 3800 50  0001 C CNN "Spice_Netlist_Enabled"
	1    3300 3800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 5DBB2145
P 4150 4100
F 0 "R?" V 4357 4100 50  0000 C CNN
F 1 "1k" V 4266 4100 50  0000 C CNN
F 2 "" V 4080 4100 50  0001 C CNN
F 3 "~" H 4150 4100 50  0001 C CNN
	1    4150 4100
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C?
U 1 1 5DBB27AA
P 5200 4450
F 0 "C?" H 5315 4496 50  0000 L CNN
F 1 "1nF" H 5315 4405 50  0000 L CNN
F 2 "" H 5238 4300 50  0001 C CNN
F 3 "~" H 5200 4450 50  0001 C CNN
	1    5200 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 3800 3300 4100
Wire Wire Line
	3300 4100 4000 4100
Wire Wire Line
	5200 4300 5200 4100
Wire Wire Line
	5200 4100 4300 4100
Wire Wire Line
	5200 4600 5200 5050
Text GLabel 5950 4100 2    50   Output ~ 0
thingA
Wire Wire Line
	5200 4100 5950 4100
Connection ~ 5200 4100
$EndSCHEMATC
