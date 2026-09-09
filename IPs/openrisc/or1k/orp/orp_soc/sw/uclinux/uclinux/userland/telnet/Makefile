
CC = or32-uclibc-gcc
LD = or32-uclibc-gcc
STRIP = or32-uclibc-strip


EXEC = telnet
OBJS = authenc.o commands.o main.o network.o ring.o sys_bsd.o telnet.o \
	terminal.o tn3270.o utilities.o genget.o getent.o misc.o 

CFLAGS += -O2 -DPARANOID_TTYS -DTERMCAP -DUSE_TERMIO -DKLUDGELINEMODE -D_GNU_SOURCE -DEMBED
CFLAGS += -I../termcap -Wall -Werror-implicit-function-declaration
LDFLAGS += -r -d -L ../termcap 
LDLIBS = -ltermcap

all: $(EXEC)

#uses non LGPL librarys
$(EXEC): $(OBJS)
#	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(ROOTDIR)/lib/libg/libg.a $(LDLIBS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)
	$(STRIP) -g $@

clean:
	-rm -f $(EXEC) *.elf *.coff *.gdb *.o

$(OBJS): defines.h externs.h fdset.h general.h types.h ring.h misc.h \
		misc-proto.h

