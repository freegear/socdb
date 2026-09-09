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
#- Purpose  : Standard VHDL Library Makefile  
#-------------------------------------------------------------------------------

vsim_rtl:
	vsim -c tb_Sdram -lic_vhdl
 
vsim_net_max:
	vsim -c +no_glitch_msg -L -libvhdl -sdfmax uSdram=../../../vhdl/uutNetlist/Sdram_Vhdl.sdf21 tb_Sdram -lic_vhdl
 
vsim_net_min:
	vsim -c +no_glitch_msg -L -libvhdl -sdfmin uSdram=../../../vhdl/uutNetlist/Sdram_Vhdl.sdf21 tb_Sdram -lic_vhdl
 
vsim_rtl_cas1:
	vsim -c tb_Sdram_CAS1 -lic_vhdl
 
vsim_net_cas1_max:
	vsim -c +no_glitch_msg -L -libvhdl -sdfmax uSdram=../../../vhdl/uutNetlist/Sdram_Vhdl.sdf21 tb_Sdram_CAS1 -lic_vhdl
 
vsim_net_cas1_min:
	vsim -c +no_glitch_msg -L -libvhdl -sdfmin uSdram=../../../vhdl/uutNetlist/Sdram_Vhdl.sdf21 tb_Sdram_CAS1 -lic_vhdl
 
vsim_rtl_256M:
	vsim -c tb_Sdram_256M -lic_vhdl
 
vsim_net_256M_max:
	vsim -c +no_glitch_msg -L -libvhdl -sdfmax uSdram=../../../vhdl/uutNetlist/Sdram_Vhdl.sdf21 tb_Sdram_256M -lic_vhdl
 
vsim_net_256M_min:
	vsim -c +no_glitch_msg -L -libvhdl -sdfmin uSdram=../../../vhdl/uutNetlist/Sdram_Vhdl.sdf21 tb_Sdram_256M -lic_vhdl
 
MODULES = timing.vhd timingmaster.vhd ahbslave_tb.vhd decoder0.vhd decoder1.vhd defslave.vhd BuswPack.vhd BusWatch.vhd tb_Sdram.vhd tb_Sdram_CAS1.vhd tb_Sdram_256M.vhd
 
include ../modeltech/StdMakefile.mk

############################## End of file #####################################
