common = ../support/except.o ../support/support.o
cases = syscall-nocache syscall-ic syscall-dc syscall-icdc

all: $(cases)

syscall-nocache: $(common) syscall.o ../support/reset-nocache.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

syscall-ic: $(common) syscall.o ../support/reset-ic.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

syscall-dc: $(common) syscall.o ../support/reset-dc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

syscall-icdc: $(common) syscall.o ../support/reset-icdc.o
	or32-rtems-ld -T ../support/xess-flash.ld $? -o $@.or32
	or32-rtems-objcopy -O binary $@.or32 $@.bin
	../utils/bin2srec $@.bin > $@.srec
	../utils/bin2hex $@.bin > $@.hex
	cp $@.hex ../../sim/src/$@.mem

syscall.o: syscall.S
	or32-rtems-gcc -O0 $? -c -o $@

clean:
	rm -f *.o *.or32 *.log *.bin *.srec *.hex
