onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/apb_addr
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_mctl/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/apb_rdata
add wave -noupdate -format Literal /Atb_mctl/ahb_htrans
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel0
add wave -noupdate -format Logic -radix binary /Atb_mctl/ahb_sel1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_sel3
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_addr
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/Atb_mctl/ahb_addr[1]}
add wave -noupdate -format Logic -height 15 -radix hexadecimal {/Atb_mctl/ahb_addr[0]}
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ahb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ahb_ready
add wave -noupdate -format Literal -radix unsigned /Atb_mctl/ext_adr
add wave -noupdate -format Literal -radix binary /Atb_mctl/ext_cs
add wave -noupdate -format Literal -expand /Atb_mctl/ext_be
add wave -noupdate -format Literal -radix hexadecimal -expand /Atb_mctl/ext_wbe
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/ext_we
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_wdata
add wave -noupdate -format Logic /Atb_mctl/ext_bidoe
add wave -noupdate -format Logic /Atb_mctl/ext_oe
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/ext_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram_data_h
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram_data_l
add wave -noupdate -divider {bank 0}
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/sram16_b0/csb
add wave -noupdate -format Logic -radix binary /Atb_mctl/sram16_b0/wrb_0
add wave -noupdate -format Logic -radix binary /Atb_mctl/sram16_b0/wrb_1
add wave -noupdate -format Literal -radix unsigned /Atb_mctl/sram16_b0/addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/sram16_b0/rdb
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram16_b0/data
add wave -noupdate -divider {bank 1}
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram8_b1/data
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/sram8_b1/addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/sram8_b1/we_n
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/sram8_b1/oe_n
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/sram8_b1/cs_n
add wave -noupdate -divider SMC
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/resetx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/apb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_sel0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_sel1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_sel2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_sel3
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_htrans
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_ready
add wave -noupdate -format Logic /Atb_mctl/mem_ctrl/tsel
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ahb_rdata
add wave -noupdate -format Logic /Atb_mctl/mem_ctrl/smc_start
add wave -noupdate -format Literal -radix hexadecimal -expand /Atb_mctl/mem_ctrl/ext_cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ext_adr
add wave -noupdate -format Literal -radix binary /Atb_mctl/mem_ctrl/ext_wbe
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/ext_we
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ext_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/ext_rdata
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/adr_setup
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/cs_setup
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/acc_cycle
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/cs_hold
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/adr_hold
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/dbus_width
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_mctl/mem_ctrl/adr_sft
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_rdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/str_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/smc_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/bsel
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/twr
add wave -noupdate -format Logic /Atb_mctl/mem_ctrl/trd
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/tsize
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/taddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/tbeb
add wave -noupdate -format Literal -radix unsigned /Atb_mctl/mem_ctrl/burst_src
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_wex
add wave -noupdate -format Literal -radix binary /Atb_mctl/mem_ctrl/sram_bex
add wave -noupdate -format Literal -radix binary /Atb_mctl/mem_ctrl/sram_ibex
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/mem_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/mem_rdyx
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/b2m_data
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_rdx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_latch
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_wenx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/burst_end
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/mem_wenx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_csx
add wave -noupdate -format Logic -radix binary /Atb_mctl/mem_ctrl/sram_rdyx
add wave -noupdate -divider Reg
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_enable
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_sel
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_write
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/apb_rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/ahb_write
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/dbus_width
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/adr_sft
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/adr_setup
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/cs_setup
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/acc_cycle
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/cs_hold
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/adr_hold
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/rdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/reg_wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/reg_rd
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/rd_bnkctrl
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl_0
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl_1
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl_2
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/bnkctrl_3
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/reg_smc/sel_bnkctrl
add wave -noupdate -divider {SRAM CTRL}
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/resetx
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/dbus_width
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/port_32bit
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/port_16bit
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/port_08bit
add wave -noupdate -color Violet -format Literal -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_setup
add wave -noupdate -color Violet -format Literal -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs_setup
add wave -noupdate -color Violet -format Literal -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/acc_cycle
add wave -noupdate -color Violet -format Literal -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs_hold
add wave -noupdate -color Violet -format Literal -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_hold
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/use_bex
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_sft
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mesb_adr26_0
add wave -noupdate -format Literal -radix binary /Atb_mctl/mem_ctrl/sram_ctrl/esb_bex
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/esb_rdx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/esb_wrx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_idle
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_wenx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_rdyx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_latch
add wave -noupdate -format Literal -radix binary /Atb_mctl/mem_ctrl/sram_ctrl/sram_ibex
add wave -noupdate -format Literal -radix binary /Atb_mctl/mem_ctrl/sram_ctrl/sram_bex
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_rdx
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_wex
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_adr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_csx
add wave -noupdate -color {Orange Red} -format Logic -itemcolor {Orange Red} -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/ns
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/wait_count
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/burst_cnt
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/fsm_adr
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_rbex
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs4
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs5
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs6
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/mcs8
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/reset
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_setup_0clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs_setup_0clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/acc_cycle_1clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_hold_0clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs_hold_0clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/rd_or_wr
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/wait_end
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/go_state
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state0_1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state0_2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state0_3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state0_4
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state0_7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state1_2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state1_3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state1_4
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state1_7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state2_3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state2_4
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state2_7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state3_4
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state3_7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state4_7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state5_6
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state5_8
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state6_8
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state7_5
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state7_6
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state8_0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state8_1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state8_2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state8_3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state8_4
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/state8_7
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/pre_cs
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/pre_access
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_setup_wait
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/adr_hold_wait
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs_setup_wait
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/cs_hold_wait
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/acc_cycle_wait
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/load_adr_setup
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/load_cs_setup
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/load_acc_cycle
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/load_cs_hold
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/load_adr_hold
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/down_wait_count
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/inc01
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/inc02
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/inc04
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/fsm_adr1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/fsm_adr0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m08bit
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m08bit0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m08bit1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m08bit2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m08bit3
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m16bit0
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m16bit1
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/m32bit0
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/temp_bex
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/temp_ibex
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/bst_p32_rdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/bst_p16_rdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/bst_p08_rdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/nor_rdy
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/when_sram8x2
add wave -noupdate -format Logic -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/when_sram8x4
add wave -noupdate -format Literal -radix hexadecimal /Atb_mctl/mem_ctrl/sram_ctrl/sram_wbex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6759 ns} 0}
configure wave -namecolwidth 174
configure wave -valuecolwidth 76
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {4212 ns} {7605 ns}
