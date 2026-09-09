# Copyright (C) 1995,1996 Robert de Bath <rdebath@cix.compulink.co.uk>
# This file is part of the Linux-8086 C library and is distributed
# under the GNU Library General Public License.

LIBC=../libc.a

CC=or32-elf-gcc
AR=or32-elf-ar
RANLIB=or32-elf-ranlib

CCFLAGS= -O2  -msoft-float -I../include

CFLAGS=$(ARCH) $(CCFLAGS) $(DEFS)

OBJ=termcap.o tparam.o

all: $(LIBC)($(OBJ))
	@$(RM) $(OBJ)

clean:
	rm -f *.o libc.a

