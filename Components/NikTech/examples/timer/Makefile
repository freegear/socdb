BOARD=s3Estarterkit
CC=manik-elf-gcc
CC_OPTS=-g -O2

all: ttest.elf

clean:
	rm -f *~ *.i *.o *.diss

ttest.o : ttest.c
	$(CC) $(CC_OPTS) -I ../../include -c $< -o $@

timer.o : ../../c_system_lib/timer.c
	$(CC) $(CC_OPTS) -I ../../include -c $< -o $@

ttest.elf : ttest.o timer.o
	$(CC) -custom-crt $< timer.o -T ../../c_system_lib/$(BOARD)/board_linker_script -o $@
