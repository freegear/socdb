#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.13
#-
#- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           makefile for Verilog Testbench files
#-
#- --=========================================================================--

MODULES =  \
../common/defs.v \
../common/funcs.v \
../common/countdown.v \
../common/clockgen.v \
../common/configmaster.v \
../reader/reader.v \
../buswatcher/buswatch.v \
../bid/reset_driver.v \
../bid/cyc_drivers.v \
../bid/split.v \
../vr/Reg.v \
../vr/linedrv.v \
../vr/VIODriver.v \
../vr/VRCycDrivers.v \
timing.v \
timingmaster.v \
buswatchmaster.v \
ahbslave_tb.v \
decoder.v \
defslave.v \
km68v1002c_20.v \
k3p9vu1000m_3.3v_yc.v \
sst37vf020_90.v \
x28f640b3b_3v_100.v \
x28f800c3b_110.v \
k3p9vu1000m_3_0v.v \
k3p9vu1000m_3_3v.v \
km68v1002c_12.v \
tbench.v \
tb_Denali1.v \
tb_Denali.v

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#- --================================= End ===================================--
