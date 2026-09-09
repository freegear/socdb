#-------------------------------------------------------------------------------
#-  This confidential and proprietary software may be used only as
#-  authorised by a licensing agreement from ARM Limited
#-    (C) COPYRIGHT 2000 ARM Limited
#-        ALL RIGHTS RESERVED
#-  The entire notice above must be reproduced on all authorised
#-  copies and copies may only be made to the extent permitted
#-  by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#-
#-  Version and Release Control Information:
#-
#-  File Name              : makefile.rca
#-  File Revision          : 1.1
#-
#-  Release Information    : PrimeCell(TM)-PL061-REL1v0
#-
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to initiate BusTalk Simulations
#-------------------------------------------------------------------------------

# list of directories to make. Order is important
#DIRS = bustest vhdl verilog 
#DIRS = bustest vhdl 
DIRS = vhdl verilog
rtl: 
	@(cd  $(HDL_SOURCE) ; $(MAKE) rtl; ) 

cover: 
	@(cd  $(HDL_SOURCE) ; $(MAKE) cover; ) 

net_max :  
	@(cd  $(HDL_NETL) ; $(MAKE) net_max; ) 

net_typ : 
	@(cd  $(HDL_NETL) ; $(MAKE) net_typ; ) 

net_min : 
	@(cd  $(HDL_NETL) ; $(MAKE) net_min; ) 

default :  
	@(cd  bustest; $(MAKE) all; )


include $(GLOBAL)/$(SIMULATOR)/DirMakefile.mk


#################################### End of file ###############################
