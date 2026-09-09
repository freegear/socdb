#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2003 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.6
#-
#- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose : 
#-           Verilog Library Makefile
#-
#- --=========================================================================--

MODULES = \
        ../common/defs.v \
        ../common/funcs.v \
        ../common/configmaster.v \
	../sys/RemPause.v \
	../sys/MuxP2B.v \
	../sys/APBif.v \
	../sys/ResCntl.v \
	../sys/Arbiter.v \
	../sys/Decoder.v \
	../sys/DefaultSlave.v \
	../sys/MuxM2S.v \
	../sys/MuxS2M.v \
	../sys/SMI.v \
        timing.v \
        timingmaster.v \
        buswatchmaster.v \
        TicWatcher.v \
	RPS.v \
	EASY.v


TEST_ENV = TICTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#- --================================= End ===================================--
