####################################
# PROGRAM to BUILD
PROGRAM_NAME=fpgatest
# Source description
SRC_C = main.c ../Lib/dma_mux.c ../Peri/gpio.c ../Peri/uart.c ../Peri/dmac.c intr_test.c ../Peri/uarttest.c ../Peri/pci.c
SRC_ASM = start.S cachefunc.S ddr.S 
OBJ_C = $(SRC_C:.c=.o)
OBJ_ASM = $(SRC_ASM:.S=.o)
OBJ_FILES = $(OBJ_ASM) $(OBJ_C)
####################################

####################################
# Build Environment

TARGET=arm-elf
GCC   =${TARGET}-gcc
OBJDUMP = ${TARGET}-objdump
OBJCOPY = ${TARGET}-objcopy

INCLUDES= -I. -I../Inc -I../Peri -I../Sys -I../Lib
CFLAGS = -march=armv4 -O2 -Wall ${INCLUDES}

LD_SCRIPT   = ./ldscript.scr
LDFLAGS = -nostartfiles -nodefaultlibs -static
#VPATH = .:./StartUpCode

####################################
# Build

all : ${PROGRAM_NAME}.bin

${PROGRAM_NAME}.bin : Makefile ${OBJ_FILES}
	${GCC} ${CFLAGS} -o ${PROGRAM_NAME}.elf -T ${LD_SCRIPT} ${OBJ_FILES} -nostartfiles ${LDFLAGS} -Wl,-Map,${PROGRAM_NAME}.map
	${OBJCOPY}  --only-section=.text --only-section=.data -I elf32-littlearm ${PROGRAM_NAME}.elf -O binary ${PROGRAM_NAME}.bin
	${OBJDUMP} -D ${PROGRAM_NAME}.elf > ${PROGRAM_NAME}.elf.dis
	./mtirgen.exe -16 ./${PROGRAM_NAME}.bin ./program.rom

%.o : %.c
	$(GCC) $(CFLAGS) -c -o $@ $<

%.o : %.S
	$(GCC) $(CFLAGS) -c -o $@ $<

clean :
	rm -fr *.bin
	rm -fr ${OBJ_FILES}
	rm -fr *~
	rm -fr *.dis
	rm -fr *.rom
	rm -fr *.elf
	rm -fr *.map
