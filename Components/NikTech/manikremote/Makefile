MANIK_BASE=..
MANIK_SYSINCL=$(MANIK_BASE)/include
DEFINES=
CFLAGS=-ffunction-sections
LDFLAGS=--gc-sections

all: manikremote.hex manikremote.vhd manikremote.bin manikremote.mem

clean: 
	rm -f *~ *.elf *.i *.o *.s *.diss

manikremote.hex: manikremote.elf
	manik-elf-objcopy -O ihex $< $@

manikremote.bin: manikremote.elf
	manik-elf-objcopy -O binary $< $@

manikremote.mem : manikremote.bin
	$(MANIK_BASE)/utils/conv2bin manikremote.bin manikremote.mem

manikremote.vhd: manikremote.bin
	$(MANIK_BASE)/utils/gen_vhdl_ram $< $@ manikremote

# Order of files in the linker is important
manikremote.elf : manikremote.o m_div.o ser.o
	manik-elf-ld $(LDFLAGS) -o $@ manikremote.o m_div.o ser.o 

m_div.o : $(MANIK_BASE)/c_system_lib/m_div.c
	manik-elf-gcc -O2 -c $(CFLAGS) -o $@ -I $(MANIK_SYSINCL) $(MANIK_BASE)/c_system_lib/m_div.c

ser.o : $(MANIK_BASE)/c_system_lib/ser.c $(MANIK_SYSINCL)/ser.h $(MANIK_SYSINCL)/manik_system.h
	manik-elf-gcc -O3 -Os -c -o $@ $(CFLAGS) -I $(MANIK_SYSINCL) $(MANIK_BASE)/c_system_lib/ser.c

manikremote.o : $(MANIK_SYSINCL)/ser.h $(MANIK_SYSINCL)/manik_system.h manikremote.c
	manik-elf-gcc -O3 -Os $(CFLAGS) -c -o $@ -I $(MANIK_SYSINCL) manikremote.c


