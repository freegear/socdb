
OBJS = termcap.o tparam.o version.o

CC = or32-uclibc-gcc
AR = or32-uclibc-ar
RANLIB = or32-uclibc-ranlib

CFLAGS += -Wall -Werror-implicit-function-declaration -O2
CFLAGS += -DHAVE_STRING_H=1 -DHAVE_UNISTD_H=1 -DSTDC_HEADERS=1  -DTERMCAP_FILE=\"/etc/termcap\" -I. -I.

all: libtermcap.a

libtermcap.a: $(OBJS)
	$(AR) rc $@ $(OBJS)
	$(RANLIB) $@

clean:
	rm -f *.[oa] *~ core libtermcap.a
