#-----------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-----------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : SimMakefile_LDV.mk.rca
#- File Revision          : 1.2
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#-----------------------------------------------------------------------
#-  Purpose  :
#-             A makefile to run LDV simulations 
#-----------------------------------------------------------------------

LDV_OPTIONS = +licq_vxl +neg_tchk -f ../tbench/vxl$(TBENCH)_LDV.files +libext+.v -y ../trickbox  

NETL_OPTIONS = -y $(DIRS_VERILOG) -v $(FILES_VERILOG) ../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net.v 

rtl:    vxl.files
	verilog $(LDV_OPTIONS) -y ../uut  ../tbench/tbench$(TBENCH).v

net_min: vxl.files
	verilog +define+NET_MIN +sdf_file../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 $(LDV_OPTIONS) $(NETL_OPTIONS) ../tbench/tbench.v

net_typ: vxl.files
	verilog +define+NET_TYP +sdf_file../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 $(LDV_OPTIONS) $(NETL_OPTIONS) ../tbench/tbench.v

net_max: vxl.files
	verilog +define+NET_MAX +sdf_file../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 $(LDV_OPTIONS) $(NETL_OPTIONS) ../tbench/tbench.v

vxl.files:  
	\cp ../tbench/vxl$(TBENCH)_LDV.files vxl$(TBENCH)_LDV.files; \

################################ End ###################################
