# Copyright (C) 1995,1996 Robert de Bath <rdebath@cix.compulink.co.uk>
# This file is part of the Linux-8086 C library and is distributed
# under the GNU Library General Public License.

LIBC=../libc.a

CC=or32-elf-gcc
AR=or32-elf-ar
RANLIB=or32-elf-ranlib

CFLAGS= -O2  -msoft-float -D__linux__ -I../include -I.

.S.s:
	$(CC) $(CFLAGS) -D__ASSEMBLY__ -traditional -E -o $*.s $<
.S.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

include makefile.objs

all: $(LIBC)

$(LIBC): $(OBJ)
	$(AR) $(ARFLAGS) $@ $(OBJ)
	@$(RM) $(OBJ)

transfer:
	-@rm -f ../include/stdio.h
	cp -p stdio.h ../include/.

clean:
	rm -f *.o libc.a
