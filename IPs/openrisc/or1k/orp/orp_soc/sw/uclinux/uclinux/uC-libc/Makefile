DIRS = headers error gtermcap misc stdio2 time getent regexp string termios sysdeps \
malloc-simple net or1k

all: libc.a

libc.a: $(DIRS)
	or32-elf-ranlib $@

headers: dummy
	if [ ! -L "include/asm" ]; then ln -s ../../uClinux-2.0.x/include/asm include/asm ; fi
	if [ ! -L "include/net" ]; then ln -s ../../uClinux-2.0.x/include/net include/net ; fi
	if [ ! -L "include/linux" ]; then ln -s ../../uClinux-2.0.x/include/linux include/linux ; fi

error: dummy
	make -C error

gtermcap: dummy
	make -C gtermcap

misc: dummy
	make -C misc

stdio2: dummy
	make -C stdio2

time: dummy
	make -C time

getent: dummy
	make -C getent

regexp: dummy
	make -C regexp

string: dummy
	make -C string

termios: dummy
	make -C termios

sysdeps: dummy
	make -C sysdeps

malloc-simple: dummy
	make -C malloc-simple

net: dummy
	make -C net

or1k: dummy
	make -C or1k

dummy:

clean:
	-rm `find -name \*.[oa]` `find -name \*~` core
	-rm include/asm include/net include/linux

