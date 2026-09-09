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
#-           VHDL Library Makefile
#-
#- --=========================================================================--


MODULES =  \
           ../common/Conv.vhd \
           ../common/defs.vhd \
           ../common/funcs.vhd \
           ../common/configmaster.vhd \
           ../common/defsmaster.vhd \
           ../common/funcsmaster.vhd \
           ../sys/RemPause.vhd \
           ../sys/MuxP2B.vhd \
           ../sys/APBif.vhd \
           ../sys/ResCntl.vhd \
           ../sys/Arbiter.vhd \
           ../sys/Decoder.vhd \
           ../sys/DefaultSlave.vhd \
           ../sys/MuxM2S.vhd \
           ../sys/MuxS2M.vhd \
           ../sys/SMI.vhd \
           ../sys/TIC.vhd \
           timing.vhd \
           timingmaster.vhd \
           buswmaster_pck.vhd \
           buswatchmaster.vhd \
           TicWatcher.vhd \
           RPS.vhd \
           EASY.vhd

TEST_ENV = TICTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#- --================================= End ===================================--
