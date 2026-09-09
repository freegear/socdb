# PREFIX = /usr/local/bin/arm-elf-
PREFIX = /data/lart/cross/bin/arm-linux-

# COPY = copy
COPY = cp

#DEBUG = -gdwarf-2
#THUMB = -mthumb 

all:
	$(PREFIX)as $(THUMB) -o setup.obj setup.S
	$(PREFIX)gcc $(DEBUG) -S -o flasher.S flasher.c
	$(PREFIX)as $(THUMB) -o flasher.obj flasher.S
	$(PREFIX)ld -Ttext 0x380 -o flasher.elf -Map flasher.map setup.obj \
		flasher.obj
	$(PREFIX)objcopy -S -O binary flasher.elf flasher.bin
	$(COPY) flasher.bin ..
	$(COPY) flasher.cmd ..

dis:
	$(PREFIX)objdump -d flasher.elf > flasher.dis

clean:
	rm -f setup.obj
	rm -f flasher.S
	rm -f flasher.obj
	rm -f flasher.elf
	rm -f flasher.bin
	rm -f flasher.map
	rm -f flasher.dis
	rm -f ../flasher.bin
	rm -f ../flasher.cmd
