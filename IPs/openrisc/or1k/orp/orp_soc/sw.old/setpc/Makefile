CCFLAGS = -O2 -g -nostdlib

all: setpc.or32

setpc.or32: setpc.o
	or32-rtems-gcc -nostdlib setpc.o -o setpc.or32
	or32-rtems-objcopy -O binary setpc.or32 setpc.bin	
	../utils/bin2srec setpc.bin > setpc.srec
	../utils/bin2hex setpc.bin > setpc.hex
	cp setpc.hex ../../sim/src/setpc.mem

setpc.o: setpc.S
	or32-rtems-gcc $(CCFLAGS) setpc.S -c -DOR1K	

clean:
	rm -f *.o setpc.or32 *.bin *.srec *.hex
