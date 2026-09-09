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
# File Name              : makefile,v
# File Revision          : 1.1
# 
# Release Information    : PL050-REL1v1
# 
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Purpose : Verilog Library Makefile for Verilog-XL and ModelSim.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Use the vxl_* 'make' options given below to simulate using Verilog-XL.
#-------------------------------------------------------------------------------

vxl_rtl:
	verilog +licq_vxl -f vxl.rtl tb_Kmi.v

vxl_net_min:
	verilog +licq_vxl +define+NET_MIN -f vxl.net tb_Kmi.v

vxl_net_max:
	verilog +licq_vxl +define+NET_MAX -f vxl.net tb_Kmi.v

vxl_net_min_cb25:
	verilog +licq_vxl +define+NET_MIN +neg_tchk -f vxl.net.cb25 tb_Kmi.v

vxl_net_max_cb25:
	verilog +licq_vxl +define+NET_MAX +neg_tchk -f vxl.net.cb25 tb_Kmi.v

vxl_rtl_free:
	verilog +licq_vxl -f vxl.rtl -y ../trickbox tb_Kmi_free.v

vxl_net_free_min:
	verilog +licq_vxl +define+NET_MIN -y ../trickbox -f vxl.net tb_Kmi_free.v

vxl_net_free_max:
	verilog +licq_vxl +define+NET_MAX -y ../trickbox -f vxl.net tb_Kmi_free.v

vxl_net_free_min_cb25:
	verilog +licq_vxl +define+NET_MIN +neg_tchk -y ../trickbox -f vxl.net.cb25 tb_Kmi_free.v

vxl_net_free_max_cb25:
	verilog +licq_vxl +define+NET_MAX +neg_tchk -y ../trickbox -f vxl.net.cb25 tb_Kmi_free.v


#-------------------------------------------------------------------------------
# Use the vsim_* 'make' options given below to simulate using ModelSim.
#-------------------------------------------------------------------------------

vsim_rtl:
	vsim -lic_vlog tb_Kmi

vsim_net_min:
	vsim -lic_vlog -sdfmin u_Kmi=../../../verilog/uutNetlist/Kmi_Verilog.sdf21 -L UDP -L libverilog tb_Kmi

vsim_net_max:
	vsim -lic_vlog -sdfmax u_Kmi=../../../verilog/uutNetlist/Kmi_Verilog.sdf21 -L UDP -L libverilog tb_Kmi

vsim_rtl_free:
	vsim -lic_vlog tb_Kmi_free

vsim_net_free_min:
	vsim -lic_vlog -sdfmin u_Kmi=../../../verilog/uutNetlist/Kmi_Verilog.sdf21 -L UDP -L libverilog tb_Kmi_free

vsim_net_free_max:
	vsim -lic_vlog -sdfmax u_Kmi=../../../verilog/uutNetlist/Kmi_Verilog.sdf21 -L UDP -L libverilog tb_Kmi_free

#-------------------------------------------------------------------------------
# Use the standard 'make clean' option for compilation using ModelSim. 
#-------------------------------------------------------------------------------

MODULES = timing.v apbslave_tb.v apbmux.v tb_Kmi.v tb_Kmi_free.v
 
include ../modeltech/StdMakefile.mk

############################## End of file #####################################
