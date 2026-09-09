#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000-2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.9
#-
#- Release Information    : PrimeCell(TM)-PL092-REL1v1
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           makefile for VHDL Testbench files
#-
#- --=========================================================================--

MODULES =  \
           ../common/defs.vhd         \
           ../common/funcs.vhd        \
           ../common/configmaster.vhd \
           ../common/defsmaster.vhd   \
           ../common/funcsmaster.vhd  \
           ../common/countdown.vhd    \
           ../common/clockgen.vhd     \
           ../buswatcher/busw_pck.vhd \
           ../buswatcher/buswatch.vhd \
           ../reader/readline.vhd     \
           ../reader/reader.vhd       \
           ../bid/reset_driver.vhd    \
           ../bid/cyc_drivers.vhd     \
           ../bid/split.vhd           \
           ../vr/reg.vhd              \
           ../vr/vregbank.vhd         \
           ../vr/linedrv.vhd          \
           ../vr/VIODriver.vhd        \
           ../vr/VRCycDrivers.vhd     \
           timing.vhd                 \
           timingmaster.vhd           \
           buswmaster_pck.vhd         \
           buswatchmaster.vhd         \
           ahbslave_tb.vhd            \
           decoder.vhd                \
           defslave.vhd               \
           sram1.vhd                  \
           sram2.vhd                  \
           sram3.vhd                  \
           sram4.vhd                  \
           flash1.vhd                 \
           flash2.vhd                 \
           mrom1.vhd                  \
           mrom2.vhd                  \
           tbench.vhd                 \
           tb_Denali.vhd

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

#- --================================= End ===================================--
