
GCC   =gcc
GAS   =gas
LD    =ld
OBJDUMP = objdump
OBJCOPY = objcopy

DEFAULT_INCLUDES = -I. -I./include -I/usr/include/libxml2 
INCLUDES = ${DEFAULT_INCLUDES}
LINK = -lxml2

####################################
SRC = main.c ReadXML.c MkFile.c genDef.c genReqCnt.c genReqInter.c genPermitCtl.c genWriteCh.c genReadCh.c genBusTop.c

OBJ_FILES = genBusTop.o genReadCh.o genWriteCh.o genPermitCtl.o genReqInter.o genReqCnt.o genDef.o MkFile.o ReadXML.o main.o 
####################################
# Build

all : sample.bin

sample.bin : Makefile ${OBJ_FILES}
	${GCC}  -o axibusGen.run ${OBJ_FILES} ${LINK}

main.o : main.c
	${GCC} ${INCLUDES} -g main.c  -c -o  main.o

ReadXML.o : ReadXML.c
	${GCC} ${INCLUDES} -g ReadXML.c -c -o  ReadXML.o

MkFile.o : MkFile.c
	${GCC} ${INCLUDES} -g MkFile.c -c -o  MkFile.o

genDef.o : genDef.c
	${GCC} ${INCLUDES} -g genDef.c -c -o  genDef.o

genReqCnt.o : genReqCnt.c
	${GCC} ${INCLUDES} -g genReqCnt.c -c -o  genReqCnt.o

genReqInter.o : genReqInter.c
	${GCC} ${INCLUDES} -g genReqInter.c -c -o  genReqInter.o

genPermitCtl.o : genPermitCtl.c
	${GCC} ${INCLUDES} -g genPermitCtl.c -c -o  genPermitCtl.o

genWriteCh.o : genWriteCh.c
	${GCC} ${INCLUDES} -g genWriteCh.c -c -o  genWriteCh.o

genReadCh.o : genReadCh.c
	${GCC} ${INCLUDES} -g genReadCh.c -c -o  genReadCh.o

genBusTop.o : genBusTop.c
	${GCC} ${INCLUDES} -g genBusTop.c -c -o  genBusTop.o

clean :
	rm -fr *.run
	rm -fr *.o
	rm -fr *~
	rm test
