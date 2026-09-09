
cases = cbasic-nocache-O0 cbasic-nocache-O2 cbasic-ic-O0 cbasic-ic-O2 cbasic-dc-O0 cbasic-dc-O2 cbasic-icdc-O0 cbasic-icdc-O2
common = ../support/except.o ../support/support.o 

all: $(cases)

cbasic-nocache-O0: $(common) cbasic-O0.o ../support/reset-nocache.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-nocache-O2: $(common) cbasic-O2.o ../support/reset-nocache.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-ic-O0: $(common) cbasic-O0.o ../support/reset-ic.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-ic-O2: $(common) cbasic-O2.o ../support/reset-ic.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-dc-O0: $(common) cbasic-O0.o ../support/reset-dc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-dc-O2: $(common) cbasic-O2.o ../support/reset-dc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-icdc-O0: $(common) cbasic-O0.o ../support/reset-icdc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-icdc-O2: $(common) cbasic-O2.o ../support/reset-icdc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

cbasic-O0.o: cbasic.c
	or32-rtems-gcc -O0 $? -c -o $@

cbasic-O2.o: cbasic.c
	or32-rtems-gcc -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex
