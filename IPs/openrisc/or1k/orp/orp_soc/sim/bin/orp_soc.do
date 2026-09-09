// Signalscan Version 6.7p1


define bookmarks \
    xess_top.i_xess_fpga.risc.or1200_cpu \
    xess_top.i_xess_fpga.risc \

define noactivityindicator
define analog waveform lines
define add variable default overlay off
define waveform window analogheight 1
define terminal automatic
define buttons control \
  1 opensimmulationfile \
  2 executedofile \
  3 designbrowser \
  4 waveform \
  5 source \
  6 breakpoints \
  7 definesourcessearchpath \
  8 exit \
  9 createbreakpoint \
  10 creategroup \
  11 createmarker \
  12 closesimmulationfile \
  13 renamesimmulationfile \
  14 replacesimulationfiledata \
  15 listopensimmulationfiles \
  16 savedofile
define buttons waveform \
  1 undo \
  2 cut \
  3 copy \
  4 paste \
  5 delete \
  6 zoomin \
  7 zoomout \
  8 zoomoutfull \
  9 expand \
  10 createmarker \
  11 designbrowser:1 \
  12 variableradixbinary \
  13 variableradixoctal \
  14 variableradixdecimal \
  15 variableradixhexadecimal \
  16 variableradixascii
define buttons designbrowser \
  1 undo \
  2 cut \
  3 copy \
  4 paste \
  5 delete \
  6 cdupscope \
  7 getallvariables \
  8 getdeepallvariables \
  9 addvariables \
  10 addvarsandclosewindow \
  11 closewindow \
  12 scopefiltermodule \
  13 scopefiltertask \
  14 scopefilterfunction \
  15 scopefilterblock \
  16 scopefilterprimitive
define buttons event \
  1 undo \
  2 cut \
  3 copy \
  4 paste \
  5 delete \
  6 move \
  7 closewindow \
  8 duplicate \
  9 defineasrisingedge \
  10 defineasfallingedge \
  11 defineasanyedge \
  12 variableradixbinary \
  13 variableradixoctal \
  14 variableradixdecimal \
  15 variableradixhexadecimal \
  16 variableradixascii
define buttons source \
  1 undo \
  2 cut \
  3 copy \
  4 paste \
  5 delete \
  6 createbreakpoint \
  7 creategroup \
  8 createmarker \
  9 createevent \
  10 createregisterpage \
  11 closewindow \
  12 opensimmulationfile \
  13 closesimmulationfile \
  14 renamesimmulationfile \
  15 replacesimulationfiledata \
  16 listopensimmulationfiles
define buttons register \
  1 undo \
  2 cut \
  3 copy \
  4 paste \
  5 delete \
  6 createregisterpage \
  7 closewindow \
  8 continuefor \
  9 continueuntil \
  10 continueforever \
  11 stop \
  12 previous \
  13 next \
  14 variableradixbinary \
  15 variableradixhexadecimal \
  16 variableradixascii
define show related transactions  
define exit prompt
define event search direction forward
define variable nofullhierarchy
define variable nofilenames
define variable nofullpathfilenames
include bookmark with filenames
include scope history without filenames
define waveform window listpane 10.92
define waveform window namepane 24.95
define multivalueindication
define pattern curpos dot
define pattern cursor1 dot
define pattern cursor2 dot
define pattern marker dot
define print designer root
define print border
define print color blackonwhite
define print command "/usr/ucb/lpr -P%P"
define print printer  lp
define print range visible
define print variable visible
define rise fall time low threshold percentage 10
define rise fall time high threshold percentage 90
define rise fall time low value 0
define rise fall time high value 3.3
define sendmail command "/usr/lib/sendmail"
define sequence time width 30.00
define snap

define source noprompt
define time units default
define userdefinedbussymbol
define user guide directory "/usr/local/designacc/signalscan-6.5s2/doc/html"
define waveform window grid off
define waveform window waveheight 14
define waveform window wavespace 6
define web browser command netscape
define zoom outfull on initial add off
add group \
    "risc.dwb" \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.aborted \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.aborted_r \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_ack_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_cab_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_cyc_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_err_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_sel_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_stb_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.biu_we_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.clk \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.clmode[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.long_ack_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.long_err_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.rst \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.valid_div[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.burst_len[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_cti_o[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_ack_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_cab_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_clk_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_cyc_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_err_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_rst_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_rty_i \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_stb_o \
      xess_top.i_xess_fpga.or1200_top.dwb_biu.wb_we_o \

add group \
    "risc.except" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.abort_ex \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.branch_taken \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.datain[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.dcpu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.dcpu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.delayed1_ex_dslot \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.delayed2_ex_dslot \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.delayed_iee[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.delayed_tee[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.du_dsr[13:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.eear[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.eear_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.epcr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.epcr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.esr[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.esr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.ex_dslot \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.ex_exceptflags[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.ex_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.ex_pc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.ex_void \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.except_flushpipe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.except_start \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.except_started \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.except_stop[12:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.except_trig[12:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.except_type[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.extend_flush \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.extend_flush_last \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.flushpipe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.genpc_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.icpu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.icpu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.id_exceptflags[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.id_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.id_pc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.if_pc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.if_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.int_pending \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.lr_sav[31:2]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.lsu_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.pc_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_align \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_dbuserr \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_dmmufault \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_dtlbmiss \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_ibuserr \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_illegal \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_immufault \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_int \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_itlbmiss \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_range \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_syscall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_tick \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sig_trap \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.spr_dat_npc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.spr_dat_ppc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.sr[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.state[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.tick_pending \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.wb_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_except.wb_pc[31:0]'h \

add group \
    "risc.ctrl" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.alu_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.branch_addrofs[31:2]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.branch_op[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.branch_taken \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.comp_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.ex_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.ex_insn[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.ex_macrc_op \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.ex_void \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.except_illegal \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.flushpipe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.force_dslot_fetch \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.id_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.id_insn[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.id_macrc_op \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.id_void \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.if_insn[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.imm_signextend \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.lsu_addrofs[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.lsu_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.mac_op[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.multicycle[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.no_more_dslot \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.pre_branch_op[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rf_addra[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rf_addrb[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rf_addrw[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rf_rda \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rf_rdb \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rfe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rfwb_op[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.sel_a[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.sel_b[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.sel_imm \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.shrot_op[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.sig_syscall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.sig_trap \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.simm[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.spr_addrimm[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.wb_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.wb_insn[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.wb_rfaddrw[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_ctrl.wbforw_valid \

add group \
    "risc.monitor" \
      or1200_monitor.iwb_progress_addr[31:0]'h \
      or1200_monitor.dwb_progress'h \
      or1200_monitor.fexe'h \
      or1200_monitor.fspr'h \
      or1200_monitor.insns'h \
      or1200_monitor.iwb_progress'h \
      or1200_monitor.r3'h \
      or1200_monitor.ref[23:0]'h \

add group \
    "risc.iwb" \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.aborted \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.aborted_r \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_ack_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_cab_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_cyc_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_err_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_sel_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_stb_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.biu_we_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.burst_len[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.clk \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.clmode[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.long_ack_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.long_err_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.rst \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.valid_div[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_bte_o[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_cab_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_clk_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_cti_o[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_err_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_rst_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_rty_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_ack_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_stb_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_cyc_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_we_o \

add group \
    "risc.genpc" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.binsn_addr[31:2]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.branch_addrofs[31:2]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.branch_op[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.epcr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.except_prefix \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.except_start \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.except_type[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.flag \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.genpc_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.genpc_refetch \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.icpu_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.icpu_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.icpu_cycstb_o \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.icpu_rty_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.icpu_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.icpu_tag_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.lr_restor[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.no_more_dslot \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.pc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.pcreg[31:2]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.spr_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.spr_pc_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_genpc.taken \

add group \
    "risc.ic_top" \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.from_icram[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ic_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ic_en \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ic_inv \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_cab_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_cyc_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_stb_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icbiu_we_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icfsm_biu_read \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icfsm_burst \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icfsm_first_hit_ack \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icfsm_first_miss_ack \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icfsm_first_miss_err \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icfsm_tag_we \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icimmu_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icimmu_ci_i \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icimmu_cycstb_i \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icimmu_err_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icimmu_rty_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icimmu_tag_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icpu_ack_o \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icpu_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icpu_sel_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icpu_tag_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.icram_we[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ictag_addr[11:4]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ictag_en \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ictag_v \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.ictag_we \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.saved_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.spr_cs \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.spr_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.spr_write \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.tag[19:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.tag_v \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.tagcomp_miss \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.to_icram[31:0]'h \

add group \
    "risc.ic_fsm" \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.biu_read \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.biudata_error \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.biudata_valid \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.burst \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.cache_inhibit \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.cnt[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.first_hit_ack \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.first_miss_ack \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.first_miss_err \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.hitmiss_eval \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.ic_en \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.icimmu_ci_i \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.icimmu_cycstb_i \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.icram_we[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.load \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.saved_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.saved_addr_r[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.start_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.state[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.tag_we \
      xess_top.i_xess_fpga.or1200_top.or1200_ic_top.or1200_ic_fsm.tagcomp_miss \

add group \
    "risc.sprs" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.addrbase[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.addrofs[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.alu_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.branch_op[2:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.cfgr_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.du_access \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.du_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.du_dat_cpu[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.du_dat_du[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.du_read \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.du_write \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.eear[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.eear_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.eear_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.epcr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.epcr_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.epcr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.esr[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.esr_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.esr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.except_started \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.flag \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.flag_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.flagforw \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.npc_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.pc_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.ppc_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.read_spr \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.rf_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_cs[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_cfgr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_dmmu[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_du[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_immu[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_mac[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_npc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_pic[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_pm[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_ppc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_rf[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_dat_tt[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.spr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.sprs_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.sr[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.sr_sel \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.sr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.sys_data[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.to_sr[15:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.to_wbmux[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.unqualified_cs[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_sprs.write_spr \

add group \
    "risc.immu_top" \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.fault \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.ic_en \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icimmu_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icimmu_ci_o \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icimmu_cycstb_o \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icimmu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icimmu_rty_i \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icimmu_tag_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_cycstb_i \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_err_o \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_rty_o \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_tag_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.icpu_vpn_r[31:13]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.immu_en \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_ci \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_done \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_en \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_en_r \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_hit \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_ppn[31:13]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.dis_spr_access \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.page_cross \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_spr_access \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_sxe \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.itlb_uxe \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.miss \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.spr_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.spr_cs \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.spr_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.spr_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.spr_write \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.supv \

add group \
    "risc.immu_tlb" \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.ci \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.hit \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.ppn[31:13]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.spr_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.spr_cs \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.spr_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.spr_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.spr_write \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.sxe \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_en \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_index[5:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_mr_en \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_mr_ram_in[13:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_mr_ram_out[13:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_mr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_tr_en \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_tr_ram_in[21:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_tr_ram_out[21:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.tlb_tr_we \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.uxe \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.v \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.vaddr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_immu_top.or1200_immu_tlb.vpn[31:19]'h \

add group \
    "risc.mult" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.a[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.alu_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.b[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.ex_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.id_macrc_op \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mac_op[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mac_op_r1[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mac_op_r2[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mac_op_r3[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mac_r[63:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mac_stall_r \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.macrc_op \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mul_prod[63:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.mul_prod_r[63:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.result[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_cs \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_machi_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_maclo_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.spr_write \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.x[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_mult_mac.y[31:0]'h \

add group \
    "risc.rf" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.addra[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.addrb[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.addrw[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.dataa[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.dataa_saved[32:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.datab[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.datab_saved[32:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.dataw[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.flushpipe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.from_rfa[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.from_rfb[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.id_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rda \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rdb \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_addra[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_addrw[4:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_dataw[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_ena \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_enb \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_we \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rf_we_allow \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.spr_addr[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.spr_cs \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.spr_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.spr_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.spr_valid \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.spr_write \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.supv \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.wb_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_rf.we \

add group \
    "risc.gmult" \

add group \
    "risc.amult" \

add group \
    "risc.if" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.addr_saved[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.except_ibuserr \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.except_immufault \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.except_itlbmiss \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.flushpipe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.genpc_refetch \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.icpu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.icpu_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.icpu_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.icpu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.icpu_tag_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.if_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.if_insn[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.if_pc[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.if_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.insn_saved[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.no_more_dslot \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.rfe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_if.saved \

add group \
    "risc.freeze" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.abort_ex \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.du_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.ex_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.extend_flush \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.flushpipe \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.flushpipe_r \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.force_dslot_fetch \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.genpc_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.icpu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.icpu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.id_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.if_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.if_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.lsu_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.lsu_unstall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.mac_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.multicycle[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.multicycle_cnt[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.multicycle_freeze \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_freeze.wb_freeze \

add group \
    flash_if \
      xess_top.i_xess_fpga.flash_top.a[20:0]'h \
      xess_top.i_xess_fpga.flash_top.a_oe \
      xess_top.i_xess_fpga.flash_top.adr[31:0]'h \
      xess_top.i_xess_fpga.flash_top.cen \
      xess_top.i_xess_fpga.flash_top.d[7:0]'h \
      xess_top.i_xess_fpga.flash_top.delay[1:0]'h \
      xess_top.i_xess_fpga.flash_top.fflash'h \
      xess_top.i_xess_fpga.flash_top.flash_rstn \
      xess_top.i_xess_fpga.flash_top.oen \
      xess_top.i_xess_fpga.flash_top.rdy \
      xess_top.i_xess_fpga.flash_top.wb_ack_o \
      xess_top.i_xess_fpga.flash_top.wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_clk_i \
      xess_top.i_xess_fpga.flash_top.wb_cyc_i \
      xess_top.i_xess_fpga.flash_top.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_err \
      xess_top.i_xess_fpga.flash_top.wb_err_o \
      xess_top.i_xess_fpga.flash_top.wb_rst_i \
      xess_top.i_xess_fpga.flash_top.wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_stb_i \
      xess_top.i_xess_fpga.flash_top.wb_we_i \
      xess_top.i_xess_fpga.flash_top.wen \

add group \
    "risc.sb" \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.clk \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_ack_o \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_cab_i \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_cyc_i \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_err_o \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_stb_i \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.dcsb_we_i \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.rst \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_cab_o \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_cyc_o \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_stb_o \
      xess_top.i_xess_fpga.or1200_top.or1200_sb.sbbiu_we_o \

add group \
    "risc.sb_fifo" \

add group \
    "risc.lsu" \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.addrbase[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.addrofs[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_ack_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_cycstb_o \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_err_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_rty_i \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_tag_i[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_tag_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.dcpu_we_o \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.du_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.except_align \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.except_dbuserr \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.except_dmmufault \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.except_dtlbmiss \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.lsu_datain[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.lsu_dataout[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.lsu_op[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.lsu_stall \
      xess_top.i_xess_fpga.or1200_top.or1200_cpu.or1200_lsu.lsu_unstall \

add group \
    sram_if \
      xess_top.i_xess_fpga.sram_top.adr[31:0]'h \
      xess_top.i_xess_fpga.sram_top.d_oe \
      xess_top.i_xess_fpga.sram_top.delay[1:0]'h \
      xess_top.i_xess_fpga.sram_top.fsram'h \
      xess_top.i_xess_fpga.sram_top.l0_wen \
      xess_top.i_xess_fpga.sram_top.l1_wen \
      xess_top.i_xess_fpga.sram_top.l_a[18:0]'h \
      xess_top.i_xess_fpga.sram_top.l_cen \
      xess_top.i_xess_fpga.sram_top.l_d_i[15:0]'h \
      xess_top.i_xess_fpga.sram_top.l_d_o[15:0]'h \
      xess_top.i_xess_fpga.sram_top.l_oen \
      xess_top.i_xess_fpga.sram_top.r0_wen \
      xess_top.i_xess_fpga.sram_top.r1_wen \
      xess_top.i_xess_fpga.sram_top.r_a[18:0]'h \
      xess_top.i_xess_fpga.sram_top.r_cen \
      xess_top.i_xess_fpga.sram_top.r_d_i[15:0]'h \
      xess_top.i_xess_fpga.sram_top.r_d_o[15:0]'h \
      xess_top.i_xess_fpga.sram_top.r_oen \
      xess_top.i_xess_fpga.sram_top.wb_ack_o \
      xess_top.i_xess_fpga.sram_top.wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_clk_i \
      xess_top.i_xess_fpga.sram_top.wb_cyc_i \
      xess_top.i_xess_fpga.sram_top.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_err \
      xess_top.i_xess_fpga.sram_top.wb_err_o \
      xess_top.i_xess_fpga.sram_top.wb_rst_i \
      xess_top.i_xess_fpga.sram_top.wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_stb_i \
      xess_top.i_xess_fpga.sram_top.wb_we_i \


deselect all
open window designbrowser 1 geometry 56 121 855 550
open window waveform 1 geometry 10 62 1016 709
zoom at 1021653.388(0)ns 0.00016725 0.00000000
