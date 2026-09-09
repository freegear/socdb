#
# Makefile for the linux kernel.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#
.S.o:
	$(CC) -D__ASSEMBLY__ $(AFLAGS) -c $< -o $*.o

all: board.o

O_TARGET := board.o
O_OBJS := config.o initrd.o 

initrd.o: initrd ../tools/bintoc ../tools/piggyback ../tools/comp reset.o uncomp.o
	../tools/bintoc < initrd |$(AS) -o initrd.o

../tools/bintoc: ../tools/bintoc.c
	$(HOSTCC) $(HOSTCFLAGS) -o ../tools/bintoc ../tools/bintoc.c

../tools/piggyback: ../tools/piggyback.c
	$(HOSTCC) $(HOSTCFLAGS) -o ../tools/piggyback ../tools/piggyback.c

../tools/comp: ../tools/comp.c
	$(HOSTCC) $(HOSTCFLAGS) -o ../tools/comp ../tools/comp.c

include $(TOPDIR)/Rules.make
