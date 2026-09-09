#
# Copyright (C) ARM Limited 1998. All rights reserved.
# makefile for uHAL
#

include boards.in

#------------------------------------------------------------
#  Build everything by calling each makefile.
#------------------------------------------------------------
all:	
	for i in $(BOARDS); \
	do (echo '*** Making' $$i; cd Build/$$i.b ; $(MAKE) all) ; \
	done

#------------------------------------------------------------
#  clean up the development tree.
#------------------------------------------------------------
clean:	
	rm -f *~ ./*/*~ ./*/*.bak
	for i in $(BOARDS); \
	do (echo '*** Cleaning' $$i; cd Build/$$i.b ; $(MAKE) clean) ; \
	done
