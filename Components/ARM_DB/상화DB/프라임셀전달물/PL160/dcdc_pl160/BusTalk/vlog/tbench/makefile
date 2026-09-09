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
	verilog -f vxl.rtl tb_Dcdc.v

vxl_net_min:
	verilog +define+NET_MIN -f vxl.net tb_Dcdc.v

vxl_net_max:
	verilog +define+NET_MAX -f vxl.net tb_Dcdc.v

vxl_net_min_cb25:
	verilog +licq_vxl +define+NET_MIN +neg_tchk -f vxl.net.cb25 tb_Dcdc.v

vxl_net_max_cb25:
	verilog +licq_vxl +define+NET_MAX +neg_tchk -f vxl.net.cb25 tb_Dcdc.v

vxl_rtl_free:
	verilog -f vxl.rtl tb_Dcdc_free.v

vxl_net_free_min:
	verilog +define+NET_MIN -f vxl.net tb_Dcdc_free.v

vxl_net_free_max:
	verilog +define+NET_MAX -f vxl.net tb_Dcdc_free.v

vxl_net_free_min_cb25:
	verilog +licq_vxl +define+NET_MIN +neg_tchk -f vxl.net.cb25 tb_Dcdc_free.v

vxl_net_free_max_cb25:
	verilog +licq_vxl +define+NET_MAX +neg_tchk -f vxl.net.cb25 tb_Dcdc_free.v


#-------------------------------------------------------------------------------
# Use the vsim_* 'make' options given below to simulate using ModelSim.
#-------------------------------------------------------------------------------

vsim_rtl:
	vsim tb_Dcdc

vsim_net_min:
	vsim -sdfmin u_Dcdc=../../../verilog/uutNetlist/Dcdc_Verilog.sdf21 \
	-L UDP -L libverilog tb_Dcdc

vsim_net_max:
	vsim -sdfmax u_Dcdc=../../../verilog/uutNetlist/Dcdc_Verilog.sdf21 \
	-L UDP -L libverilog tb_Dcdc

vsim_rtl_free:
	vsim tb_Dcdc_free

vsim_net_free_min:
	vsim -sdfmin u_Dcdc=../../../verilog/uutNetlist/Dcdc_Verilog.sdf21 \
	-L UDP -L libverilog tb_Dcdc_free

vsim_net_free_max:
	vsim -sdfmax u_Dcdc=../../../verilog/uutNetlist/Dcdc_Verilog.sdf21 \
	-L UDP -L libverilog tb_Dcdc_free

#-------------------------------------------------------------------------------
# Use the standard 'make clean' option for compilation using ModelSim. 
#-------------------------------------------------------------------------------

MODULES = timing.v apbslave_tb.v tb_Dcdc.v tb_Dcdc_free.v
 
include ../modeltech/StdMakefile.mk

#------------------------------------- End -------------------------------------
