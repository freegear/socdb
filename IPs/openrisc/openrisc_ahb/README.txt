OpenRISC or1200 AHB platform

or1200 source code from orp @ www.opencores.org
(CVS checked out @ 22/Aug/2006)

AHB Bus from SDI V5 platform

Platform consists of following IPs
(a) or1200
(b) AHB bus
(c) Synchronous SRAM(512KBx32) model connected @ AHB(0x00000000) : Program/Data
(d) Synchronous SRAM(512KBx32) model connected @ AHB(0x04000000) : Not Used

Simulation is peformed with modelsim.

CAUTION:
Currently, or1200 only support BIG-ENDIAN.
So AHB is composed with BigEndian Configuration.
If you want use Litte-endian, or1200 must be modified.
And cross toolchain must be changed.
