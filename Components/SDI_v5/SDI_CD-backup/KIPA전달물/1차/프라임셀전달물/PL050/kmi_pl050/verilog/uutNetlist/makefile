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
#-  Purpose  : Standard Verilog Library Makefile
#-------------------------------------------------------------------------------

MODULES = Kmi_net.v

# the default library name (should not need to alter this)
LIBRARY = work

all: $(MODULES) modelsim.ini
	vmake | $(MAKE) -f -

clean:  $(MODULES) makefile modelsim.ini
	if [ -d $(LIBRARY) ] ; then \
		(cd $(LIBRARY) ; rm -rf *; rm -rf .*) ; \
		rmdir $(LIBRARY) ; fi ;
	vlib $(LIBRARY)
	vlog $(MODULES)
        
nowork:  $(MODULES) makefile modelsim.ini
	if [ -d $(LIBRARY) ] ; then \
                (cd $(LIBRARY) ; rm -rf *; rm -rf .*) ; \
                rmdir $(LIBRARY) ; fi ;

changed: $(MODULES) makefile modelsim.ini


modelsim.ini :
	cp ../modeltech/modelsim.ini .

############################# End of file ######################################

