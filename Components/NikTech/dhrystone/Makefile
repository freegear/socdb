BOARD=s3Estarterkit
CC=manik-elf-gcc
CC_OPTS=-g -O2 -funroll-loops -frerun-loop-opt 

all: dhry.elf

clean:
	rm -f *~ *.i *.o *.diss *.elf 

dhry21a.o : dhry.h dhry21a.c
	$(CC) $(CC_OPTS) -c dhry21a.c -o $@

dhry21b.o : dhry.h dhry21b.c
	$(CC) $(CC_OPTS) -c dhry21b.c -o $@

timers.o : timers.c
	$(CC) $(CC_OPTS) -I ../include -c timers.c -o $@

m_div.o : m_div.c
	$(CC) $(CC_OPTS) -O3 -c m_div.c -o $@

dhry.elf : dhry21b.o dhry21a.o timers.o m_div.o
	$(CC) -custom-crt dhry*.o  m_div.o timers.o -Wl,-T -Wl,../c_system_lib/$(BOARD)/board_linker_script -o $@
