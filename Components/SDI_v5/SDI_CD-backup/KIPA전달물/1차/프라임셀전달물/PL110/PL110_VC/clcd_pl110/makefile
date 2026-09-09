#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2003 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.2
#-
#- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
#-
#- ---------------------------------------------------------------------
#- Purpose :
#-           A makefile to control peripheral development 
#-           Note that the 'make clean' command would invoke
#-           the 'make clean' option in the synopsys sub-directory too,
#-           which would result in the deletion of the subdirectories
#-           synopsys/log, synopsys/report, synopsys/db and 
#-           synopsys/work. If this is not desired, then 'cd' to the
#-           individual directories and do 'make clean' within the
#-           directory.
#-
#- --=================================================================--

all:
	@export PERIPH
	@(cd $(HDL_SOURCE) ; make all; )

rtl: 
	@export PERIPH
	@(cd  verification ; make rtl; ) 

net_max :  
	@export PERIPH
	@(cd  verification ; make net_max; ) 

net_typ : 
	@export PERIPH
	@(cd  verification ; make net_typ; ) 

net_min : 
	@export PERIPH
	@(cd  verification ; make net_min; ) 

default :  
	@export PERIPH
	@(cd  verification; make default; )

netlist :  
	@export PERIPH
	@(cd  synopsys; make netlist; )

clean :  
	@export PERIPH
	@(cd  vhdl ; make clean; ) 
	@(cd  verilog ; make clean; ) 
	@(cd  verification ; make clean; ) 
	@(cd  integration ; make clean; ) 
	@(cd  synopsys; make clean; )

################################ End ###################################
