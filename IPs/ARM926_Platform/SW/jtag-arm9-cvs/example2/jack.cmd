echo starting boot sequence
jtag
halt
idcode
#
echo configuring the processor and memory interface (Off)
poke 30470010 00100000
poke 30470010 08000000
# cpu
poke 30440030 4
poke 30440018 a52383
poke 30440008 2d41d400
# sdram
poke 3044000c 37bbbc00
poke 30070004 82781037
poke 30000014 1
# nand flash
poke 30010008 8b0b0202
poke 30010088 0
#
echo loading image (Red)
poke 30470008 08000000
load jack.bin 380
#
echo Running Image (Green)
poke 30470008 00100000
poke 30470010 08000000
pause 2
run 380
halt
run 380
