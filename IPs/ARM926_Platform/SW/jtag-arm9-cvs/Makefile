CFLAGS	= -g -Wall -pedantic -Wmissing-prototypes
#CFLAGS	= -O2 -Wall -pedantic -Wmissing-prototypes
OBJS = main.o jtag.o debug.o memory.o parse.o regs.o

jtag-arm9: $(OBJS)
	$(CC) -g -o jtag-arm9 $(OBJS)

clean:
	rm -f *.o *~ core jtag-arm9 jtag-arm9.exe
	make -C example clean
	make -C example2 clean

debug:
	gdb jtag-arm9
