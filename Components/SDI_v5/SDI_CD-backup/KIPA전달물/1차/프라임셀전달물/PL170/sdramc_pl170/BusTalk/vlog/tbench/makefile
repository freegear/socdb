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
#-  File Revision          : 1.6
#-  
#-  Release Information    : PrimeCell(TM)-PL170-REL2v2
#-  
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#- Purpose  : Standard Verilog Library Makefile  
#-------------------------------------------------------------------------------
 
#-------------------------------------------------------------------------------
# Use the vxl_* 'make' options given below to simulate using Verilog-XL.
#-------------------------------------------------------------------------------

vxl_rtl:
	verilog -f vxl.rtl tb_Sdram.v +licq_vxl

vxl_rtl_cas1:
	verilog -f vxl_cas1.rtl tb_Sdram_CAS1.v +licq_vxl

vxl_rtl_256M:
	verilog -f vxl_256M.rtl tb_Sdram_256M.v +licq_vxl

vxl_net_min:
	verilog tb_Sdram.v +define+NET_MIN -f vxl.net 

vxl_net_max:
	verilog tb_Sdram.v +define+NET_MAX -f vxl.net 

vxl_net_cas1_min:
	verilog tb_Sdram_CAS1.v +define+NET_MIN -f vxl_cas1.net 

vxl_net_cas1_max:
	verilog tb_Sdram_CAS1.v +define+NET_MAX -f vxl_cas1.net 

vxl_net_256M_min:
	verilog tb_Sdram_256M.v +define+NET_MIN -f vxl_256M.net 

vxl_net_256M_max:
	verilog tb_Sdram_256M.v +define+NET_MAX -f vxl_256M.net 

#-------------------------------------------------------------------------------
# Use the vsim_* 'make' options given below to simulate using ModelSim.
#-------------------------------------------------------------------------------

vsim_rtl:
	vsim -c tb_Sdram -lic_vlog

vsim_rtl_cas1:
	vsim -c tb_Sdram_CAS1 -lic_vlog

vsim_rtl_256M:
	vsim -c tb_Sdram_256M -lic_vlog

vsim_net_min:
	vsim -c -lic_vlog -sdfmin uSdram=../../../verilog/uutNetlist/Sdram_Verilog.sdf21 \
	-L libverilog tb_Sdram

vsim_net_max:
	vsim -c -lic_vlog -sdfmax uSdram=../../../verilog/uutNetlist/Sdram_Verilog.sdf21 \
	-L libverilog tb_Sdram

vsim_net_cas1_min:
	vsim -c -lic_vlog -sdfmin uSdram=../../../verilog/uutNetlist/Sdram_Verilog.sdf21 \
	-L libverilog tb_Sdram_CAS1

vsim_net_cas1_max:
	vsim -c -lic_vlog -sdfmax uSdram=../../../verilog/uutNetlist/Sdram_Verilog.sdf21 \
	-L libverilog tb_Sdram_CAS1

vsim_net_256M_min:
	vsim -c -lic_vlog -sdfmin uSdram=../../../verilog/uutNetlist/Sdram_Verilog.sdf21 \
	-L libverilog tb_Sdram_256M

vsim_net_256M_max:
	vsim -c -lic_vlog -sdfmax uSdram=../../../verilog/uutNetlist/Sdram_Verilog.sdf21 \
	-L libverilog tb_Sdram_256M

#-------------------------------------------------------------------------------
# Use the standard 'make clean' option for compilation using ModelSim. 
#-------------------------------------------------------------------------------

MODULES = timing.v decoder0.v decoder1.v defslave.v ahbslave0_tb.v ahbslave1_tb.v ahbslave2_tb.v ahbslave3_tb.v BusWatch.v tb_Sdram.v tb_Sdram_CAS1.v tb_Sdram_256M.v
 
include ../modeltech/StdMakefile.mk

############################## End of file #####################################
