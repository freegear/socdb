ifndef CROSS_COMPILE
#CROSS_COMPILE = arm-elf-
CROSS_COMPILE =

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
NM = $(CROSS_COMPILE)nm
endif

export	CROSS_COMPILE

all: test.exe

test.exe: test.c Makefile
	$(CC) -g -o $@ $< $(CFLAGS)

#########################################################################
clean:
	rm *.elf;rm *.exe
