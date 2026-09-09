OBJS = simpleinit.o

CC = or32-uclibc-gcc
STRIP = or32-uclibc-strip

PRGS = init

all: $(PRGS)

init: $(OBJS)
	$(CC) $(CFLAGS) -r -d $(OBJS) -o $@
	$(STRIP) -g $@

clean:
	rm -f *.[oa] *.coff *~ core init
