BOARD=s3Estarterkit
CC=manik-elf-gcc
CC_OPTS=-g -O2

all: banner.elf

clean:
	rm -f *~ *.i *.o *.diss

banner.o : banner.c
	$(CC) $(CC_OPTS) -I ../../include -c $< -o $@

banner.elf : banner.o
	$(CC) -custom-crt $<  -T ../../c_system_lib/$(BOARD)/board_linker_script -o $@
