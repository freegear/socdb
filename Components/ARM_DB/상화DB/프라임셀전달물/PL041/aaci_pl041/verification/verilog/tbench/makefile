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
#- File Revision          : 1.3
#-
#- Release Information    : PrimeCell(TM)-PL041-REL1v0
#-
#- ---------------------------------------------------------------------
#- Purpose  : 
#-            makefile for Verilog Testbench files
#-
#- --=================================================================--

MODULES =  \
../common/defs.v \
../common/countdown.v \
../common/clockgen.v\
../reader/reader.v\
../buswatcher/buswatch.v\
../bid/buscyc_drivers.v \
../bid/addrctl_driver.v \
../bid/penable_driver.v \
../bid/data_driver.v \
../bid/busline_drivers.v \
../bid/reset_driver.v\
../vr/reg.v \
../vr/linedrv.v \
../vr/vio_driver.v \
../vr/viregcyc_drivers.v\
timing.v \
apbslave_tb.v \
apbmux.v \
tbench.v

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

################################# End ##################################
