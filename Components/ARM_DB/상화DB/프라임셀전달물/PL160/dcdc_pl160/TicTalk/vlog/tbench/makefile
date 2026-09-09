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
# File Revision          : 1.2
# 
# Release Information    : PL160-REL1v1
# 
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Purpose : Verilog Library Makefile for Verilog-XL and ModelSim.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Use the vxl_* 'make' options given below to simulate using Verilog-XL.
#-------------------------------------------------------------------------------

vxl_rtl:
	verilog +licq_vxl -f vxl.rtl tb_tic.v

vxl_net_min:
	verilog +licq_vxl +define+NET_MIN -f vxl.net tb_tic.v

vxl_net_max:
	verilog +licq_vxl +define+NET_MAX -f vxl.net tb_tic.v

vxl_net_min_cb25:
	verilog +licq_vxl +define+NET_MIN +neg_tchk -f vxl.net.cb25 tb_tic.v

vxl_net_max_cb25:
	verilog +licq_vxl +define+NET_MAX +neg_tchk -f vxl.net.cb25 tb_tic.v


#-------------------------------------------------------------------------------
# Use the vsim_* 'make' options given below to simulate using ModelSim.
#-------------------------------------------------------------------------------

vsim_rtl:
	vsim -lic_vlog tb_tic

vsim_net_min:
	vsim -lic_vlog -sdfmin u_easy/u_rps/uDcdc=../../../verilog/uutNetlist/Dcdc_Verilog.sdf21 -L UDP -L libverilog tb_tic

vsim_net_max:
	vsim -lic_vlog -sdfmax u_easy/u_rps/uDcdc=../../../verilog/uutNetlist/Dcdc_Verilog.sdf21 -L UDP -L libverilog tb_tic

#-------------------------------------------------------------------------------
# Use the standard 'make clean' option for compilation using ModelSim. 
#-------------------------------------------------------------------------------

MODULES = ticbox.v tb_tic.v
 
include ../modeltech/StdMakefile.mk

#------------------------------------ End --------------------------------------
