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
#- File Revision          : 1.14
#-
#- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
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
           km68v1002c_20.vhd            \
           k3p9vu1000m_3.3v_yc.vhd \
           sst37vf020_90.vhd  \
           x28f640b3b_3v_100.vhd \
           x28f800c3b_110.vhd \
           k3p9vu1000m_3_0v.vhd \
           k3p9vu1000m_3_3v.vhd \
           km68v1002c_12.vhd  \
           tbench.vhd                 \
           tb_Denali1.vhd     \
           tb_Denali.vhd

TEST_ENV = BUSTALK

all: modelsim.ini work work.mk
	@make -f work.mk

clean:  
	@rm -rf work work.mk modelsim.ini

cover:  
	@rm -rf work
	@vnlib -simulator modelsim_vhdl5_4 -create work=./work
	@if [ "$(HDL_SOURCE)" = "vhdl" ]; then \
	  for CodeFile in $(MODULES) ; do \
	    vnvhdl -instrument -path -statement -branch \
              -condition -triggering -toggle -simulator \
               modelsim_vhdl5_4 $$CodeFile; \
	  done; \
	else \
	  for CodeFile in $(MODULES) ; do \
	    vnvlog -path -statement -branch -condition \
              -toggle -simulator modelsim_verilog5_4 -- $$CodeFile; \
	  done; \
	fi
	@rm -rf work.mk

work.mk: work modelsim.ini
	@for CodeFile in $(MODULES) ; do \
	  ftype=`echo $$CodeFile | awk -F. '{ i = NF }{print $$i}'`; \
	  if [ $$ftype = 'vhd' ]; then \
	    vcom -explicit -just p $$CodeFile; \
	    vcom -explicit -just e $$CodeFile; \
	    vcom -explicit $$CodeFile; \
	  else \
	    vlog -compat $$CodeFile; \
	  fi; \
	done
	@vmake > work.mk

work:
	@vlib work

modelsim.ini: 
	@if [ "$(TEST_ENV)" = "TICTALK" ]; then \
	  cp -f $(GLOBAL)/modelsim/modelsim_tictalk.ini modelsim.ini; \
	elif [ "$(TEST_ENV)" = "BUSTALK" ]; then \
	  cp -f $(GLOBAL)/modelsim/modelsim_bustalk.ini modelsim.ini; \
	else \
	  cp -f $(GLOBAL)/modelsim/modelsim.ini modelsim.ini; \
	fi

################################ End ###################################
#- --================================= End ===================================--
