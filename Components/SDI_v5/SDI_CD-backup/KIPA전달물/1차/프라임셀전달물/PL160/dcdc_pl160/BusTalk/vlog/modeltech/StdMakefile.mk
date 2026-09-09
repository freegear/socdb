#-------------------------------------------------------------------------------
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 1999 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
# 
# Version and Release Control Information:
# 
# File Name              : StdMakefile.mk,v
# File Revision          : 1.2
# 
# Release Information    : PL160-REL1v1
# 
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Purpose : A standardised makefile to be included in other makefiles
#-------------------------------------------------------------------------------

# use make CHECK_OUT="" to prevent files being checked out (DEFAULT)
CHECK_OUT = @echo Newer version of $@ in CVS
#CHECK_OUT = ""
# use make CHECK_OUT="co $@" to ensure latest version checked out
#CHECK_OUT = co $@
# use make CHECK_OUT="co -rX $@" to check out version X
#CHECK_OUT = co -rX $@


# a generic rule to check out out of date files from under CVS
% : CVS/%,v
	$(CHECK_OUT)

# the default library name (should not need to alter this)
LIBRARY = work

all: $(MODULES) modelsim.ini
	vmake | $(MAKE) -f -

clean:  $(MODULES) makefile modelsim.ini
	if [ -d $(LIBRARY) ] ; then \
	(cd $(LIBRARY) ; rm -rf *; rm -rf .*) ; \
	rmdir $(LIBRARY) ; fi ;
	vlib $(LIBRARY)
	vlog -compat $(MODULES)

nowork:  $(MODULES) makefile modelsim.ini
	if [ -d $(LIBRARY) ] ; then \
	(cd $(LIBRARY) ; rm -rf *; rm -rf .*) ; \
	rmdir $(LIBRARY) ; fi ;

changed: $(MODULES) makefile modelsim.ini


modelsim.ini :
	cp ${PERIPH}/BusTalk/vlog/modeltech/modelsim.ini .

#################################### End of file ###############################
