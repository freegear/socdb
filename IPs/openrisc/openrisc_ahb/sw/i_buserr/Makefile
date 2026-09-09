
all: i_buserr-nocache i_buserr-ic i_buserr-dc i_buserr-icdc 

i_buserr-nocache: buserr.o i_buserr.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-nocache.o buserr.o i_buserr.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

i_buserr-ic: buserr.o i_buserr.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-ic.o buserr.o i_buserr.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

i_buserr-dc: buserr.o i_buserr.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-dc.o buserr.o i_buserr.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

i_buserr-icdc: buserr.o i_buserr.o
	or32-uclinux-gcc -Wall -g -nostdlib -mhard-div -T../support/orp.ld -o $@.or32 ../support/reset-icdc.o buserr.o i_buserr.o ../support/libsupport.a
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/

i_buserr.o: i_buserr.c Makefile
	or32-uclinux-gcc -I../support -g -O2 -c -o i_buserr.o i_buserr.c -Wall -g -nostdlib -mhard-div

buserr.o: buserr.S Makefile
	or32-uclinux-gcc -I../support -g -c -o buserr.o buserr.S -Wall -g -nostdlib -mhard-div

clean:
	rm -rf *.o *.bin *.hex *.srec *.or32 *.log stdout.txt

