OBJS = ping.o

CC = or32-uclibc-gcc
LD = or32-uclibc-gcc
STRIP = or32-uclibc-strip

CFLAGS := $(CFLAGS) -Wall -Werror-implicit-function-declaration -D__USE_BSD
LDFLAGS := -r -d

all: ping

ping: $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $@
	$(STRIP) -g $@

clean:
	rm -f *.[oa] *.coff *~ core ping
