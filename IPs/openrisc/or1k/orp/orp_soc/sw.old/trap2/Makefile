CCFLAGS = -O2 -g -nostdlib

all: trap.or32

trap.or32: trap.o
	or32-rtems-gcc -nostdlib trap.o -o trap.or32
	or32-rtems-objcopy -O binary trap.or32 trap.bin	
	../utils/bin2srec trap.bin > trap.srec
	../utils/bin2hex trap.bin > trap.hex
	cp trap.hex ../../sim/src/flash.in

trap.o: trap.S
	or32-rtems-gcc $(CCFLAGS) trap.S -c -DOR1K	

clean:
	rm -f *.o trap.or32 *.bin *.srec *.hex
