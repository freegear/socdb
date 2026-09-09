ifndef CROSS_COMPILE
#CROSS_COMPILE = or32-uclinux-
#CROSS_COMPILE = or32-elf-
CROSS_COMPILE =

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
NM = $(CROSS_COMPILE)nm
endif

export	CROSS_COMPILE

all: test.exe

test.exe: test.c Makefile
#	$(CC) -g -c -o $@ $< $(CFLAGS) crt0.o
	$(CC) -g -o $@ $< $(CFLAGS)

#########################################################################
clean:
	rm *.elf;rm *.exe
