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
#- File Revision          : 1.1
#-
#- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
#-
#- -----------------------------------------------------------------------------
#- Purpose  :
#-            makefile for VHDL Testbench files
#-
#- --=========================================================================--

MODULES =  \
           ../common/defs.vhd               \
           ../common/funcs.vhd              \
           ../common/configmaster.vhd       \
           ../common/defsmaster.vhd         \
           ../common/funcsmaster.vhd        \
           ../common/countdown.vhd          \
           ../common/clockgen.vhd           \
           ../buswatcher/busw_pck.vhd       \
           ../buswatcher/buswatch.vhd       \
           ../reader/readline.vhd           \
           ../reader/reader.vhd             \
           ../bid/reset_driver.vhd          \
           ../bid/cyc_drivers.vhd           \
           ../bid/split.vhd                 \
           ../vr/reg.vhd                    \
           ../vr/vregbank.vhd               \
           ../vr/linedrv.vhd                \
           ../vr/VIODriver.vhd              \
           ../vr/VRCycDrivers.vhd           \
           ../trickbox/CLTrAHBIf.vhd        \
           ../trickbox/CLTrCLCDIf.vhd       \
           ../trickbox/CLTrDataCheck.vhd    \
           ../trickbox/CLTrProtCheck.vhd    \
           ../trickbox/CLTrRegBlock.vhd     \
           ../trickbox/CLTrick.vhd          \
           timing.vhd                       \
           timingmaster.vhd                 \
           ahbslave_tb.vhd                  \
           decoder.vhd                      \
           defslave.vhd                     \
           buswmaster_pck.vhd               \
           buswatchmaster.vhd               \
           tbench.vhd

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

##################################### End ######################################
