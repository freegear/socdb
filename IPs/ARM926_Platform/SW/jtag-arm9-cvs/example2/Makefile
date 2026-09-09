# PREFIX = /usr/local/bin/arm-elf-
PREFIX = /data/lart/cross/bin/arm-linux-

# COPY = copy
COPY = cp

#DEBUG = -gdwarf-2
#THUMB = -mthumb 

all:
	$(PREFIX)as $(THUMB) -o setup.obj setup.S
	$(PREFIX)gcc $(DEBUG) -S -o jack.S jack.c
	$(PREFIX)as $(THUMB) -o jack.obj jack.S
	$(PREFIX)ld -Ttext 0x380 -o jack.elf -Map jack.map setup.obj \
		jack.obj
	$(PREFIX)objcopy -S -O binary jack.elf jack.bin
	$(COPY) jack.bin ..
	$(COPY) jack.cmd ..

dis:
	$(PREFIX)objdump -d jack.elf > jack.dis

clean:
	rm -f setup.obj
	rm -f jack.S
	rm -f jack.obj
	rm -f jack.elf
	rm -f jack.bin
	rm -f jack.map
	rm -f jack.dis
	rm -f ../jack.bin
	rm -f ../jack.cmd
