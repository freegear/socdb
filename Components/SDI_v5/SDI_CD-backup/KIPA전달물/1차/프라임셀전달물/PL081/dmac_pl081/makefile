#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.6
#-
#- Release Information    : PrimeCell(TM)-PL081-REL1v0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           A makefile to control peripheral development 
#-
#-           Note that the 'make clean' command would delete the 
#-           subdirectories, synopsys/log, synopsys/report, synopsys/db
#-           and synopsys/work. If this is not desired, then 'cd' to the
#-           individual directories and do 'make clean' within the
#-           directory.
#- --=========================================================================--
 
all:
	@(cd $(HDL_SOURCE) ; make all; )

rtl_check : 
	@(cd  chrysalis ; make rtl; ) 

rtl: 
	@(cd  verification ; make rtl; ) 

net_max :  
	@(cd  verification ; make net_max; ) 

net_typ : 
	@(cd  verification ; make net_typ; ) 

net_min : 
	@(cd  verification ; make net_min; ) 

cover :  
	@(cd  verification; make cover; )

default :  
	@(cd  verification; make default; )

netlist :  
	@(cd  synopsys; make netlist; )
#	@(cd  chrysalis; make netlist; )

clean :  
	@(cd  vhdl ; make clean; ) 
	@(cd  verilog ; make clean; ) 
	@(cd  verification ; make clean; ) 
	@(cd  integration ; make clean; ) 
	@(cd  synopsys; make clean; )
#	@(cd  chrysalis; make clean; )

#################################### End #######################################
