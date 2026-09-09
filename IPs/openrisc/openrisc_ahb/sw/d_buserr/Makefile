
all: d_buserr-nocache d_buserr-icdc

d_buserr-nocache: buserr.o d_buserr.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-nocache.o buserr.o d_buserr.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

d_buserr-icdc: buserr.o d_buserr.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-icdc.o buserr.o d_buserr.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

d_buserr.o: d_buserr.c Makefile
	or32-uclinux-gcc -I../support -g -O2 -c -o d_buserr.o d_buserr.c -Wall -g -nostdlib -mhard-div

buserr.o: buserr.S Makefile
	or32-uclinux-gcc -I../support -g -c -o buserr.o buserr.S -Wall -g -nostdlib -mhard-div

clean:
	rm -rf *.o *.bin *.hex *.srec *.or32 *.log stdout.txt

