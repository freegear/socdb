#-------------------------------------------------------------------------------
# This confidential and proprietary software may be used only as
# authorised by a licensing agreement from ARM Limited
#   (C) COPYRIGHT 2000 ARM Limited
#       ALL RIGHTS RESERVED
# The entire notice above must be reproduced on all authorised
# copies and copies may only be made to the extent permitted
# by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
# 
# Version and Release Control Information:
# 
# File Name              : makefile.rca
# File Revision          : 1.7
# 
# Release Information    : PrimeCell(TM)-PL011-REL1v3
# 
#-------------------------------------------------------------------------------

MODULES =  \
           ../common/defs.vhd         \
           ../common/funcs.vhd        \
           ../common/countdown.vhd    \
           ../common/clockgen.vhd     \
           ../buswatcher/busw_pck.vhd \
           ../buswatcher/buswatch.vhd \
           ../reader/readline.vhd     \
           ../reader/reader.vhd       \
           ../bid/buscyc_drivers.vhd  \
           ../bid/addrctl_driver.vhd  \
           ../bid/penable_driver.vhd  \
           ../bid/data_driver.vhd     \
           ../bid/busline_drivers.vhd \
           ../bid/reset_driver.vhd    \
           ../vr/reg.vhd              \
           ../vr/vregbank.vhd              \
           ../vr/linedrv.vhd          \
           ../vr/vio_driver.vhd       \
           ../vr/viregcyc_drivers.vhd \
           timing.vhd                 \
           apbslave_tb.vhd            \
           apbmux.vhd                 \
           tbench.vhd                 

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

############################## End of file #####################################
