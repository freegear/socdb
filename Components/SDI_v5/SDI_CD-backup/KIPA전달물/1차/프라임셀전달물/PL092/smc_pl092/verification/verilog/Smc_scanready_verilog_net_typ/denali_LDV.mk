#-------------------------------------------------------------------------------
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#-------------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : denali_LDV.mk.rca
#- File Revision          : 1.5
#-
#- Release Information    : PrimeCell(TM)-PL092-REL1v1
#-
#-------------------------------------------------------------------------------
#-  Purpose  :
#-             This is a makefile to run LDV simulations. The exact path of the 
#-             custom created LDV Verilog-XL executable should be given for
#-             each of the simulation options.
#-             This custom Verilog-XL should be used in the place of the
#-             ../VerilogXL in this makefile 
#-------------------------------------------------------------------------------

LDV_OPTIONS = +licq_vxl +neg_tchk -f vxl_LDV.files +libext+.v -y ../trickbox  

NETL_OPTIONS = -y $(DIRS_VERILOG) -v $(FILES_VERILOG) ../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE)_net.v 

rtl:  vxl.files
	../verilog_xl $(LDV_OPTIONS) -y ../uut  ../tbench/tb_Denali.v

net_min: vxl.files
	../verilog_xl +define+NET_MIN +sdf_file../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 $(LDV_OPTIONS) $(NETL_OPTIONS) ../tbench/tb_Denali.v

net_typ: vxl.files
	../verilog_xl +define+NET_TYP +sdf_file../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 $(LDV_OPTIONS) $(NETL_OPTIONS) ../tbench/tb_Denali.v

net_max: vxl.files
	../verilog_xl +define+NET_MAX +sdf_file../uut/$(PERIPH)_$(TEST_METH)_$(HDL_SOURCE).sdf21 $(LDV_OPTIONS) $(NETL_OPTIONS) ../tbench/tb_Denali.v

vxl.files:  
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
	  if [ "$(AMBA)" = "AHB" ] || [ "$(AMBA)" = "APB" ]; then \
	    cp -f $(GLOBAL)/LDV/vxl_tictalk_ahb.files vxl.files; \
          else \
	    cp -f $(GLOBAL)/LDV/vxl_tictalk_asb.files vxl.files; \
          fi; \
	elif  [ "$(TEST_ENV)" = "BUSTALK" ]; then \
	  if [ "$(AMBA)" = "AHB" ]; then \
	    cp -f $(GLOBAL)/LDV/vxl_bustalk_ahb.files vxl.files; \
          else \
	    cp -f $(GLOBAL)/LDV/vxl_bustalk_apb.files vxl.files; \
          fi; \
	fi;

################################### End ########################################
