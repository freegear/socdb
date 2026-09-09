CC = or32-rtems-gcc
AS = or32-rtems-as
AR = or32-rtems-ar
RUNLIB = or32-rtems-ranlib

SUBDIRS = libmad

MAD_OBJ =    	reset.o 	\
		minimad.o 	\
		fsyst.o 	\
		audio_oss.o 	\
		audio.o 	\
		memcpy.o 	\
		memmove.o 	\
		flash.o


CC_OPTS = -DHAVE_CONFIG_H -fno-delayed-branch -Wall -nostdlib \
        -I. -I./libmad/

#LD_OPTS = -T xess.ld -L/home/simons/or1k/lib/gcc-lib/or32-rtems/2.95.2/
LD_OPTS = -T xess.ld

all:
	@set fnord $(MAKEFLAGS); amf=$$2; \
	target=`echo $@ | sed s/-recursive//`; \
	list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "Making $$target in $$subdir"; \
	  (cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) $$target) \
	   || case "$$amf" in *=*) exit 1;; *k*) fail=yes;; *) exit 1;; esac; \
	done; \
	$(MAKE) $(AM_MAKEFLAGS) "minimad" || exit 1; \
	
minimad: $(MAD_OBJ) libmad/libmad.a
	$(CC) $(LD_OPTS) -o minimad $(MAD_OBJ) libmad/libmad.a
	
reset.o: reset.S
	$(CC) $(CC_OPTS) -c -o reset.o reset.S

minimad.o: minimad.c config.h audio.h libmad/mad.h fsyst.h
	$(CC) $(CC_OPTS) -c -o minimad.o minimad.c

fsyst.o: fsyst.c config.h fsyst.h
	$(CC) $(CC_OPTS) -c -o fsyst.o fsyst.c

audio_oss.o: audio_oss.c config.h
	$(CC) $(CC_OPTS) -c -o audio_oss.o audio_oss.c

audio.o: audio.c config.h audio.h libmad/mad.h
	$(CC) $(CC_OPTS) -c -o audio.o audio.c

memcpy.o: memcpy.c config.h _ansi.h
	$(CC) $(CC_OPTS) -c -o memcpy.o memcpy.c

memmove.o: memmove.c config.h
	$(CC) $(CC_OPTS) -c -o memmove.o memmove.c

flash.o: flash.c config.h
	$(CC) $(CC_OPTS) -c -o flash.o flash.c


clean:
	@set fnord $(MAKEFLAGS); amf=$$2; \
	target=`echo $@ | sed s/-recursive//`; \
	list='$(SUBDIRS)'; for subdir in $$list; do \
	  echo "Making $$target in $$subdir"; \
	  (cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) $$target) \
	   || case "$$amf" in *=*) exit 1;; *k*) fail=yes;; *) exit 1;; esac; \
	done; \
	rm -rf $(MAD_OBJ) minimad *~ *.bak

