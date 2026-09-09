#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 1999 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-
#-  Version and Release Control Information:
#-
#-  File Name              : makefile,v
#-  File Revision          : 1.5
#-
#-  Release Information    : PrimeCell(TM)-PL170-REL2v2
#-
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to build BusTalk vectors.
#-------------------------------------------------------------------------------

VECS_DIR = invec

% : %.c busmacros.h busheader.h config.h  busmacros.c  addargs_script
	@nawk -f addargs_script $@.c
	@gcc -ansi -g temp.$@.c  busmacros.c -o $@
#Uncomment the following line if you don't want to see the pre-processed .c file
#	@rm temp.$@.c
	@$@ > $(VECS_DIR)/$@.tmp
	@cpy_vect $(VECS_DIR) $(@)
	@rm  $(VECS_DIR)/$@.tmp
	if [ "$(VECT_TYPE)" = "" ]; then \
	awk -f bif2sim.awk < $(VECS_DIR)/$@.bif > $(VECS_DIR)/$@.sim \
	; fi ;

############################# End of file #####################################
