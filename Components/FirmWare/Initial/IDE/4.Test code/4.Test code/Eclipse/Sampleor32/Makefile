ifndef CROSS_COMPILE
#CROSS_COMPILE = or32-uclinux-
CROSS_COMPILE = or32-elf-
#CROSS_COMPILE =

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
NM = $(CROSS_COMPILE)nm
endif

export	CROSS_COMPILE

all: test.or32

reset.o: reset.S Makefile
	$(CC) -g -c -o $@ $< $(CFLAGS)

test.o: test.c Makefile
	$(CC) -g -c -o $@ $< $(CFLAGS)

test.or32: reset.o test.o Makefile
	$(LD) -Tram.ld -o $@ reset.o test.o $(LIBS)


System.map: test.or32
	@$(NM) $< | \
		grep -v '\(compiled\)\|\(\.o$$\)\|\( [aUw] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)' | \
		sort > System.map

#########################################################################
clean:
	find . -type f \
		\( -name 'core' -o -name '*.bak' -o -name '*~' \
		-o -name '*.o'  -o -name '*.a' -o -name '*.tmp' \
		-o -name '*.or32' -o -name '*.bin' -o -name '*.srec' \
		-o -name '*.mem' -o -name '*.img' -o -name '*.out' \
		-o -name '*.aux' -o -name '*.log' \) -print \
		| xargs rm -f
	rm -f System.map

distclean: clean
	find . -type f \
		\( -name .depend -o -name '*.srec' -o -name '*.bin' \
		-o -name '*.pdf' \) \
		-print | xargs rm -f
	rm -f $(OBJS) *.bak tags TAGS
	rm -fr *.*~