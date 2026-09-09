CCFLAGS = -O2 -g -nostdlib

all: console-xess

console-xess: screen.o font.o except.o support.o console-xess.o
	or32-rtems-ld -g -Txess.ld except.o support.o screen.o font.o console-xess.o -o console-xess.or32
	or32-rtems-objcopy -O binary console-xess.or32 console-xess.bin	
	./bin2srec console-xess.bin > console-xess.srec

console-xess.o: console-xess.c
	or32-rtems-gcc $(CCFLAGS) console-xess.c -c -DOR1K

font.o: font.c
	or32-rtems-gcc $(CCFLAGS) font.c -c -DOR1K

screen.o: screen.c screen.h
	or32-rtems-gcc $(CCFLAGS) screen.c -c -DOR1K

except.o: except.S
	or32-rtems-as except.S -o except.o
	

support.o: support.c spr_defs.h
	or32-rtems-gcc $(CCFLAGS) support.c -c -DOR1K	

cprintf.o: cprintf.c
	or32-rtems-gcc $(CCFLAGS) cprintf.c -c -DOR1K  

clean:
	rm -f *.o console-xess console-xess.or32 *.bin *.srec
