
CC = or32-uclibc-gcc
LD = or32-uclibc-gcc
STRIP = or32-uclibc-strip

CFLAGS += -DL_intflag -DL_modestring -DL_timestring -DL_isadir -DL_copyfile \
        -DL_buildname -DL_expandwildcards -DL_namesort -DL_match -DL_makeargs \
        -DL_makestring -DL_chunks -DL_expandenvvar

SH = sh
SHOBJS = sash.o cmds.o cmd_uclinux.o ls.o ps.o hexdump.o df.o free.o \
 	hostname.o date.o utils.o

SHUTDOWN = shutdown
SHUTDOWNOBJS = shutdown.o

REBOOT = reboot
REBOOTOBJS = reboot.o

LIBSASH = libsash/libsash.a

all: $(SH)

$(SH): $(SHOBJS)
	$(LD) $(LDFLAGS) -r -d -o $@ $(SHOBJS) $(LDLIBS)


#	$(STRIP) -g $@

$(SHUTDOWN): $(SHUTDOWNOBJS) $(LIBSASH)
	$(LD) $(LDFLAGS) -o $@ $(SHUTDOWNOBJS) $(LIBSASH) $(LDLIBS)

$(REBOOT): $(REBOOTOBJS) $(LIBSASH)
	$(LD) $(LDFLAGS) -o $@ $(REBOOTOBJS) $(LIBSASH) $(LDLIBS)

dummy_target:

$(LIBSASH): dummy_target
	$(MAKE) -C libsash

clean:
	rm -f $(SH) $(SHUTDOWN) $(REBOOT) *.elf *.coff *.gdb *.o
	$(MAKE) -C libsash clean

