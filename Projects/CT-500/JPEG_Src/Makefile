SRC 	= jpegdec.c main.c
HEADER 	= jpegdec.h



all : jpegdec.exe PANORAMA_1.BMP

clean :
	rm -fr *.exe
	rm -fr *~
	rm -fr *.stackdump

jpegdec.exe : Makefile ${SRC} ${HEADER}
	gcc -O2 -o jpegdec.exe ${SRC} -g


PANORAMA_1.BMP : Makefile PANORAMA_1.RAW jpegdec.exe
	./jpegdec.exe
	../RAW2BMP/raw2bmp.exe PANORAMA_1.RAW 1440 480

