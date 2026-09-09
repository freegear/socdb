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
#- File Revision          : 1.5
#-
#- Release Information    : PrimeCell(TM)-PL081-REL1v0
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
           ../trickbox/DmacTrPackage.vhd    \
           ../trickbox/DmacTrIntArb.vhd     \
           ../trickbox/DmacTrAhbSlaveIf.vhd \
           ../trickbox/DmacTrMasWrap.vhd    \
           ../trickbox/DmacTrAhbLite.vhd    \
           ../trickbox/DmacTrAhbMaster.vhd  \
           ../trickbox/DmacTrRouter.vhd     \
           ../trickbox/DmacTrChLogic.vhd    \
           ../trickbox/DmacTrBehaviour.vhd  \
           ../trickbox/DmacTrProChkr.vhd    \
           ../trickbox/DmacTrMem.vhd        \
           ../trickbox/DmacTrCounter.vhd    \
           ../trickbox/DmacTrPeriph.vhd     \
           ../trickbox/DmacTrGntGen.vhd     \
           ../trickbox/DmacTrick.vhd        \
           timing.vhd                       \
           timingmaster.vhd                 \
           buswmaster_pck.vhd               \
           buswatchmaster.vhd               \
           ahbslave_tb.vhd                  \
           decoder.vhd                      \
           defslave.vhd                     \
           tbench.vhd

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

##################################### End ######################################
