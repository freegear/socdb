####################################
# PROGRAM to BUILD
PROGRAM_NAME=fpgatest
# Source description
SRC_C = main.c
SRC_ASM = start.s \
	mmufunc.s \
	cachefunc.s \
	rd_CP15C0C.c 
OBJ_C = $(SRC_C:.c=.o)
OBJ_ASM = $(SRC_ASM:.s=.o)
OBJ_FILES = $(OBJ_ASM) $(OBJ_C)
####################################

####################################
# Build Environment

TARGET=arm-elf
GCC   =${TARGET}-gcc
OBJDUMP = ${TARGET}-objdump
OBJCOPY = ${TARGET}-objcopy

INCLUDES= -I. -I../Inc -I../Peri -I../Sys -I../Lib -I./API
CFLAGS = -march=armv4 -O2 ${INCLUDES}

LD_SCRIPT   = ./ldscript.scr
LDFLAGS = -nostartfiles -nodefaultlibs -static
#VPATH = .:./StartUpCode

####################################
# Build

all : ${PROGRAM_NAME}.bin

${PROGRAM_NAME}.bin : Makefile ${OBJ_FILES}
	${GCC} ${CFLAGS} -o ${PROGRAM_NAME}.elf -T ${LD_SCRIPT} ${OBJ_FILES} -nostartfiles ${LDFLAGS} -Wl,-Map,${PROGRAM_NAME}.map
	${OBJCOPY} -I elf32-littlearm ${PROGRAM_NAME}.elf -O binary ${PROGRAM_NAME}.bin
	${OBJDUMP} -D ${PROGRAM_NAME}.elf > ${PROGRAM_NAME}.elf.dis
	mtirgen -16 ./${PROGRAM_NAME}.bin ./program.rom

%.o : %.c
	$(GCC) $(CFLAGS) -c -o $@ $<

%.o : %.s
	$(GCC) $(CFLAGS) -c -o $@ $<

clean :
	rm -fr *.bin
	rm -fr *.o
	rm -fr *~
	rm -fr *.dis
