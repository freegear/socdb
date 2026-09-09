#
# Makefile for /h.
#

include ../rules.in

all:	
	echo 'nothing to do'

#------------------------------------------------------------
#  Convert sources from DOS to UNIX and vice versa
#------------------------------------------------------------
dos:	
	$(UNIX2DOS) *.h *.s README*
	for i in $(BOARDS); \
	do (cd $$i; ../../tools/unix2dos *.h *.s ) ; \
	done
	
unix:	
	$(DOS2UNIX) *.h *.s README*
	for i in $(BOARDS); \
	do (cd $$i; ../../tools/dos2unix *.h *.s ) ; \
	done
	
#------------------------------------------------------------
#  clean up the development tree.
#------------------------------------------------------------
clean:	
	rm -f *~ *.bak ./*/*~ ./*/*.bak
	done
	
