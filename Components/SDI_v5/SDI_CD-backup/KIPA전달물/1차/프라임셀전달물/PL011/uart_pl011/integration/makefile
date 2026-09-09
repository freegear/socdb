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
#-  File Name              : makefile.rca
#-  File Revision          : 1.8
#-
#-  Release Information    : PrimeCell(TM)-PL011-REL1v3
#-
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
#-  Purpose  : A makefile to initiate BusTalk Simulations
#-------------------------------------------------------------------------------

# list of directories to make. Order is important
DIRS = bustest vhdl verilog 

rtl: 
	@(cd  $(HDL_SOURCE) ; make rtl; ) 

cover: 
	@(cd  $(HDL_SOURCE) ; make cover; ) 

net_max :  
	@(cd  $(HDL_NETL) ; make net_max; ) 

net_typ : 
	@(cd  $(HDL_NETL) ; make net_typ; ) 

net_min : 
	@(cd  $(HDL_NETL) ; make net_min; ) 

default :  
	@(cd  bustest; make all; )


include $(GLOBAL)/$(SIMULATOR)/DirMakefile.mk


#################################### End of file ###############################
