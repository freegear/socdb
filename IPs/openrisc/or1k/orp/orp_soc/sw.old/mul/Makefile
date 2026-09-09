
cases = mul-nocache-O0 mul-nocache-O2 mul-ic-O0 mul-ic-O2 mul-dc-O0 mul-dc-O2 mul-icdc-O2 mul-icdc-O0
common = ../support/except.o ../support/support.o 

all: $(cases)

mul-nocache-O0: $(common) mul-O0.o ../support/reset-nocache.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-nocache-O2: $(common) mul-O2.o ../support/reset-nocache.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-ic-O0: $(common) mul-O0.o ../support/reset-ic.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-ic-O2: $(common) mul-O2.o ../support/reset-ic.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-dc-O0: $(common) mul-O0.o ../support/reset-dc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-dc-O2: $(common) mul-O2.o ../support/reset-dc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-icdc-O0: $(common) mul-O0.o ../support/reset-icdc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-icdc-O2: $(common) mul-O2.o ../support/reset-icdc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

mul-O0.o: mul.c
	or32-rtems-gcc -O0 $? -c -o $@

mul-O2.o: mul.c
	or32-rtems-gcc -O2 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex
