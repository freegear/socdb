#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 1998 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-  
#-  Version and Release Control Information:
#-  
#-  File Name              : makefile,v
#-  File Revision          : 1.2
#-  
#-  Release Information    : PL050-REL1v1
#-  
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to build BusTalk vectors.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# The Awk preprocessor is used to complete the argument list.
#
# The same makefile can be used to generate .tif, .bif or .sim vector files
# from the BusTalk source code.
#
# To generate .tif vectors two parameters need to be set.
#   1. #define TIF in config.h
#   2. setenv VECT_TYPE TIF at the unix command line
#
# To generate .bif and .sim vectors (default)
#   1. /* #define TIF */ in config.h
#   2. unsetenv VECT_TYPE at the unix command line
#                                        
#-------------------------------------------------------------------------------

VECS_DIR = invec

% : %.c busmacros.h config.h busheader.h busmacros.c addargs_script
	@nawk -f addargs_script $@.c
	@gcc -ansi -g temp.$@.c  busmacros.c -o $@
#Uncomment the following line if you don't want to see the pre-processed .c file
	@rm temp.$@.c
	@$@ > $(VECS_DIR)/$@.tmp
	@cpy_vect $(VECS_DIR) $(@)
	@rm  $(VECS_DIR)/$@.tmp*
	if [ "$(VECT_TYPE)" = "TIF" ]; then \
	awk -f tif2sim.awk < $(VECS_DIR)/$@.tif > $(VECS_DIR)/$@.sim \
	; fi ;
	if [ "$(VECT_TYPE)" = "" ]; then \
	awk -f bif2sim.awk < $(VECS_DIR)/$@.bif > $(VECS_DIR)/$@.sim \
	; fi ;


############################## End of file #####################################
