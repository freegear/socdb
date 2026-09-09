#common = ../support/except.o ../support/support.o
common = 
cases = int_test-nocache

all: $(cases)

int_test-nocache: $(common) int_test.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

basic-ic: $(common) basic.o ../support/reset-ic.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

basic-dc: $(common) basic.o ../support/reset-dc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

basic-icdc: $(common) basic.o ../support/reset-icdc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

int_test.o: int_test.S
	or32-rtems-gcc -O0 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex
