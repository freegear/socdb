# Copyright (C) 1995,1996 Robert de Bath <rdebath@cix.compulink.co.uk>
# This file is part of the Linux-8086 C library and is distributed
# under the GNU Library General Public License.

LIBC=../libc.a

CC=or32-elf-gcc
AR=or32-elf-ar
RANLIB=or32-elf-ranlib

CCFLAGS= -O2  -msoft-float -fno-builtin -I../include

ASRC=addr.c
AOBJ=inet_aton.o inet_addr.o inet_ntoa.o
# raise.o bcmp.o index.o rindex.o 

#UOBJ= getenv.o putenv.o popen.o system.o getcwd.o execl.o execv.o execlp.o execvp.o
#setenv.o


OBJ=$(AOBJ)

CFLAGS=$(ARCH) $(CCFLAGS) $(DEFS)

all: $(LIBC)
	@$(RM) $(OBJ)

$(LIBC): $(LIBC)($(OBJ))

$(LIBC)($(AOBJ)): $(ASRC)
	$(CC) $(CFLAGS) -DL_$* $< -c -o $*.o
	$(AR) $(ARFLAGS) $@ $*.o

clean:
	rm -f *.o libc.a
