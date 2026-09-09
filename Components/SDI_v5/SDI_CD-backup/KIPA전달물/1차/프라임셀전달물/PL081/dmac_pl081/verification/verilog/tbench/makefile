#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.5
#-
#- Release Information    : PrimeCell(TM)-PL081-REL1v0
#-
#- ---------------------------------------------------------------------
#- Purpose  :
#-            makefile for Verilog Testbench files
#-
#- --=================================================================--

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
tbench.v

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

################################# End ##################################
