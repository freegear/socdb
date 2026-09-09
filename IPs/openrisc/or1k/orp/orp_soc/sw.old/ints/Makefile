common = ../support/except.o ../support/support.o
cases = ints1-nocache ints1-ic ints2-nocache ints2-ic ints1-dc ints2-dc ints1-icdc ints2-icdc ints3-nocache

all: $(cases)

ints1-nocache: $(common) ../support/reset-nocache.o handlers.o ints1.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints1-ic: $(common) ../support/reset-ic.o handlers.o ints1.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints2-nocache: $(common) ../support/reset-nocache.o handlers.o ints2.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints2-ic: $(common) ../support/reset-ic.o handlers.o ints2.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints1-dc: $(common) ../support/reset-dc.o handlers.o ints1.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints2-dc: $(common) ../support/reset-dc.o handlers.o ints2.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints1-icdc: $(common) ../support/reset-icdc.o handlers.o ints1.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints2-icdc: $(common) ../support/reset-icdc.o handlers.o ints2.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints3-nocache: $(common) ../support/reset-nocache.o handlers.o ints3.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

ints1.o: ints1.S
	or32-rtems-gcc $? -c -o $@

ints2.o: ints2.S
	or32-rtems-gcc $? -c -o $@

ints3.o: ints3.S
	or32-rtems-gcc $? -c -o $@

handlers.o: handlers.S
	or32-rtems-gcc $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex
