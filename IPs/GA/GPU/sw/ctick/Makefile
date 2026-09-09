
cases = ctick-nocache-O2
common = ../support/libsupport.a

all: $(cases)

ctick-nocache-O2: ctick-O2.o ../support/reset-nocache.o $(common)
	or32-uclinux-ld -T ../support/orp.ld $? -o $@.or32
	or32-uclinux-objcopy -O binary $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex
#	cp $@.hex ../../sim/src/

ctick-O2.o: ctick.c
	or32-uclinux-gcc -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt
