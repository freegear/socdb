####################################
# SAMPLE CODE

TARGET=arm-elf
GCC   =${TARGET}-gcc
GAS   =${TARGET}-gas
LD    =${TARGET}-ld
OBJDUMP = ${TARGET}-objdump
OBJCOPY = ${TARGET}-objcopy


CFLAGS = -march=armv4

STARTUP_DIR = ./StartUpCode
LD_SCRIPT   = ./sdiv5.vct


DEFAULT_INCLUDES = -I. -I../Inc -I../Peri -I../Sys -I../Lib -I./API
INCLUDES = ${DEFAULT_INCLUDES}


####################################
SRC = main.c

OBJ_FILES = start.o stack.o start_c.o sample.o 
####################################
# Build

all : sample.bin


sample.bin : Makefile ${OBJ_FILES}
	${GCC} ${CFLAGS} ${OBJ_FILES} -o sample.elf -T ${LD_SCRIPT}  -nostartfiles -Wl,-Map sample.map
	${OBJCOPY} -I elf32-littlearm sample.elf -O binary sample.bin
	${OBJCOPY} -I elf32-littlearm sample.elf -O ihex sample.hex
	${OBJDUMP} -D sample.elf > sample.elf.dis
	cp sample.bin ./code.bin
	mtirgen -16 ./code.bin ./SDI_V5.rom
	romout ./SDI_V5.rom

sample.o : main.c
	${GCC} ${CFLAGS} ${INCLUDES} main.c -O2 -c -o sample.o

start_c.o  : ${STARTUP_DIR}/start_c.c
	${GCC} ${CFLAGS} -O2 -c ${STARTUP_DIR}/start_c.c -c -o start_c.o

start.o : ${STARTUP_DIR}/start.S
	${GCC} ${CFLAGS} ${STARTUP_DIR}/start.S -c -o start.o

stack.o : ${STARTUP_DIR}/stack.S
	${GCC}  ${CFLAGS} ${STARTUP_DIR}/stack.S -c -o stack.o


clean :
	rm -fr *.bin
	rm -fr *.o
	rm -fr *~
	rm -fr *.dis
	rm -fr *.rom
