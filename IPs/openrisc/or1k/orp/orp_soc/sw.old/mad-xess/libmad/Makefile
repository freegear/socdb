CC = or32-rtems-gcc
AS = or32-rtems-as
AR = or32-rtems-ar
RUNLIB = or32-rtems-ranlib

LIBMAD_OBJ =	fixed.o		\
		bit.o 		\
		timer.o 	\
		stream.o 	\
		frame.o 	\
		synth.o 	\
		decoder.o 	\
		layer3.o 	\
		huffman.o

CC_OPTS = -DHAVE_CONFIG_H -DFPM_DEFAULT -fno-delayed-branch -Wall -nostdlib \
	-g -O -fforce-mem -fforce-addr -fthread-jumps -fcse-follow-jumps \
	-fcse-skip-blocks -fexpensive-optimizations -fregmove -fschedule-insns2 \
        -I. -I./../

all: libmad.a

libmad.a: $(LIBMAD_OBJ)
	$(AR) cru libmad.a $(LIBMAD_OBJ)
	$(RUNLIB) libmad.a

fixed.o: fixed.c config.h global.h fixed.h
	$(CC) $(CC_OPTS) -c -o fixed.o fixed.c

bit.o: bit.c config.h global.h bit.h
	$(CC) $(CC_OPTS) -c -o bit.o bit.c

timer.o: timer.c config.h global.h timer.h 
	$(CC) $(CC_OPTS) -c -o timer.o timer.c

stream.o: stream.c config.h global.h bit.h stream.h 
	$(CC) $(CC_OPTS) -c -o stream.o stream.c

frame.o: frame.c config.h global.h bit.h stream.h frame.h fixed.h timer.h layer3.h
	$(CC) $(CC_OPTS) -c -o frame.o frame.c

synth.o: synth.c config.h global.h fixed.h frame.h timer.h stream.h bit.h synth.h \
	../audio.h mad.h D.dat
	$(CC) $(CC_OPTS) -c -o synth.o synth.c

decoder.o: decoder.c config.h global.h stream.h bit.h frame.h fixed.h timer.h \
	synth.h decoder.h
	$(CC) $(CC_OPTS) -c -o decoder.o decoder.c

layer3.o: layer3.c config.h global.h fixed.h bit.h stream.h frame.h timer.h \
	huffman.h layer3.h rq_short.dat imdct_s.dat
	$(CC) $(CC_OPTS) -c -o layer3.o layer3.c

huffman.o: huffman.c config.h global.h huffman.h
	$(CC) $(CC_OPTS) -c -o huffman.o huffman.c

clean:
	rm -rf $(LIBMAD_OBJ) libmad.a *~ *.bak

