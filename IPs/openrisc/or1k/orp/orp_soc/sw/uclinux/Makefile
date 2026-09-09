
all: linux.srec

linux.srec: linux
	or32-rtems-objcopy -O binary linux linux.bin
	../utils/bin2flimg 4 linux.bin > linux.mem
	../utils/bin2srec linux.bin > linux.srec

clean:
	rm -f *.bin *.srec *.mem
