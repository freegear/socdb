#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- -----------------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : makefile.rca
#- File Revision          : 1.7
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
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
           latency_monitor/BWMonitor/BWMonitor.vhd \
           latency_monitor/LatencyMonitor/LatencyMonitor.vhd \
           am29pl320db_90.vhd               \
           am29pl320dt_60r.vhd              \
           at27lv040a_12.vhd                \
           at27lv040a_15.vhd                \
           at27lv040a_90.vhd                \
           hm5212165f_75a.vhd               \
           hm5212805f_75.vhd                \
           hm5225325f_b60.vhd               \
           hm5225805b_75.vhd                \
           hm5257805b_a6.vhd                \
           hm5264165f_75.vhd                \
           hm5264805f_75.vhd                \
           hyb25l128800ac.vhd               \
           I28f320w18b_70.vhd               \
           Int28f800f3b95.vhd               \
           Int28f800f3b115.vhd              \
           k3n9vu1000m.vhd                  \
           k3p9vu1000m_3_0v.vhd             \
           k4s281632c_75.vhd                \
           k4s561632a_75.vhd                \
           k6r1016v1c_12.vhd                \
           k6r1016v1c_15.vhd                \
           k6r4016c1c_10.vhd                \
           k6r4016c1c_12.vhd                \
           k6t8016c3m_55.vhd                \
           k6t8016c3m_70.vhd                \
           m27w201-80.vhd                   \
           mt28f002b3vg.vhd                 \
           mt28f002b3vg_9b.vhd              \
           mt28f004b5_6t1.vhd               \
           mt28f004b5_6t2.vhd               \
           mt28f004b5_8b_et.vhd             \
           mt28f400b5sg_8t.vhd              \
           mt28s4m16lc_10.vhd               \
           mt28s4m16lc_12.vhd               \
           mt48lc16m16a2_75.vhd             \
           mt48lc16m8a2_75.vhd              \
           mt48lc1m16a1_6s.vhd              \
           mt48lc2m32b2_6.vhd               \
           mt48lc2m32lffc_8.vhd             \
           mt48lc32m16a2_75.vhd             \
           mt48lc4m16a2_75.vhd              \
           mt48lc4m32b2_6.vhd               \
           mt48lc8m16a2_7e.vhd              \
           mt48lc8m8a2_7e.vhd               \
           mt5c2568_12.vhd                  \
           mt5c2568_20.vhd                  \
           sst37vf020_90.vhd                \
           upd4516821g5.vhd                 \
           k4s641632d_60.vhd                \
           k4s643232c_60.vhd                \
           timing.vhd                       \
           timingmaster.vhd                 \
           buswmaster_pck.vhd               \
           buswatchmaster.vhd               \
           ahbslave_tb.vhd                  \
           decoder.vhd                      \
           defslave.vhd                     \
           tbench.vhd                       \
           tbench1.vhd                      \
           tbench2.vhd                      \
           tbench3.vhd                      \
           tbench4.vhd                      \
           tbench5.vhd                      \
           tbench6.vhd                      \
           tbench7.vhd                      \
           tbench8.vhd                      \
           tbench9.vhd                      \
           tbench10.vhd                     \
           tbench11.vhd                     \
           tbench12.vhd                     \
           tbench13.vhd

TEST_ENV = BUSTALK

include $(GLOBAL)/$(SIMULATOR)/RtlMakefile.mk

##################################### End ######################################
