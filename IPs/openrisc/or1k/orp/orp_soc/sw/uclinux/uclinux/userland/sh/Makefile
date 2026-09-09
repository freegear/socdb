# Makefile for sh

PROG      := sh
BUILDTIME := $(shell TZ=UTC date --utc "+%Y.%m.%d-%H:%M%z")


# With a modern GNU make(1) (highly recommended, that's what all the
# developers use), all of the following configuration values can be
# overridden at the command line.  For example:
#   make CROSS=powerpc-linux- DOSTATIC=true 

# If you want a static binary, turn this on.
DOSTATIC = true

# Set the following to `true' to make a debuggable build.
# Leave this set to `false' for production use.
# eg: `make DODEBUG=true tests'
# Do not enable this for production builds...
DODEBUG = false

# If you are running a cross compiler, you may want to set this
# to something more interesting, like "powerpc-linux-".
CROSS =or32-elf-
CC = $(CROSS)gcc
LD = $(CROSS)ld
STRIPTOOL = $(CROSS)strip

# To compile vs an alternative libc, you may need to use/adjust
# the following lines to meet your needs.
#LIBCDIR=/home/andersen/CVS/uC-libc
#GCCINCDIR = $(shell gcc -print-search-dirs | sed -ne "s/install: \(.*\)/\1include/gp")
#CFLAGS+=-nostdinc -I$(LIBCDIR)/include -I$(GCCINCDIR)
#LDFLAGS+=-nostdlib
#LIBRARIES = $(LIBCDIR)/libc.a -lgcc

#--------------------------------------------------------

# use '-Os' optimization if available, else use -O2
OPTIMIZATION = $(shell if $(CC) -Os -S -o /dev/null -xc /dev/null >/dev/null 2>&1; \
    then echo "-Os"; else echo "-O2" ; fi)

WARNINGS =

ifeq ($(DODEBUG),true)
    CFLAGS  += $(WARNINGS) -g -D_GNU_SOURCE -I../../uC-libc/include
    LDFLAGS +=
    STRIP    =
else
    CFLAGS  += $(WARNINGS) $(OPTIMIZATION) -fomit-frame-pointer -D_GNU_SOURCE
    CFLAGS  += -I../../uC-libc/include

    LDFLAGS += -s -L/home/simons/uClinux/uC-libc/
    LDFLAGS += -L/home/simons/uClinux/uC-libc/
    LDFLAGS += -L/home/simons/or1k/lib/gcc-lib/or32-elf/2.95.2/

    STRIP    = $(STRIPTOOL) --remove-section=.note --remove-section=.comment $(PROG)
endif
ifeq ($(DOSTATIC),true)
    LDFLAGS += --static
    #
    #use '-ffunction-sections -fdata-sections' and '--gc-sections' (if they 
    # work) to try and strip out any unused junk.  Doesn't do much for me, 
    # but you may want to give it a shot...
    #
    #ifeq ($(shell $(CC) -ffunction-sections -fdata-sections -S \
    #	-o /dev/null -xc /dev/null 2>/dev/null && $(LD) \
    #			--gc-sections -v >/dev/null && echo 1),1)
    #	CFLAGS += -ffunction-sections -fdata-sections
    #	LDFLAGS += --gc-sections
    #endif
endif


OBJ	= sh1.o sh2.o sh3.o sh4.o sh5.o

all:	$(PROG)

$(PROG):	$(OBJ)
	$(LD) $(LDFLAGS) -r -o $@ $(OBJ) /home/simons/or1k/or32-elf/lib/crt0.o -lc -lgcc

.S.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

clean:
	rm -f sh *.coff *.o *.bak core

.PHONY: tags
tags:
	ctags -R .

