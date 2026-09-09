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
define waveform window listpane 8.92
define waveform window namepane 28.56
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
    iwb \
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
      xess_top.i_xess_fpga.or1200_top.iwb_biu.clk \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.clmode[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.long_ack_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.long_err_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.rst \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.valid_div[1:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_ack_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_cab_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_clk_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_cyc_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_err_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_rst_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_rty_i \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_stb_o \
      xess_top.i_xess_fpga.or1200_top.iwb_biu.wb_we_o \

add group \
    ctrl \

add group \
    except \

add group \
    wb_master \

add group \
    sprs \

add group \
    du \

add group \
    alu \

add group \
    mul \

add group \
    wbmux \

add group \
    tcop \
      xess_top.i_xess_fpga.tc_top.i0_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i0_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i0_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i0_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i0_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i0_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i0_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i0_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i1_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i1_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i1_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i1_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i1_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i1_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i1_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i1_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i1_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i2_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i2_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i2_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i2_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i2_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i2_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i2_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i2_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i2_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i3_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i3_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i3_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i3_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i3_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i3_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i3_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i3_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i3_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i4_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i4_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i4_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i4_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i4_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i4_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i4_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i4_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i4_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i5_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i5_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i5_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i5_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i5_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i5_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i5_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i5_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i5_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i6_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i6_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i6_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i6_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i6_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i6_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i6_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i6_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i6_wb_we_i \
      xess_top.i_xess_fpga.tc_top.i7_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.i7_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i7_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.i7_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.i7_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.i7_wb_err_o \
      xess_top.i_xess_fpga.tc_top.i7_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.i7_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.i7_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t0_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t0_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t0_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t0_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t1_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t1_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t1_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t1_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t1_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t1_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t1_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t1_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t1_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t2_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t2_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t2_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t2_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t2_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t2_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t2_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t2_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t2_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t3_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t3_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t3_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t3_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t3_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t3_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t3_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t3_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t3_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t4_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t4_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t4_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t4_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t4_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t4_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t4_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t4_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t4_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t5_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t5_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t5_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t5_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t5_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t5_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t5_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t5_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t5_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t6_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t6_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t6_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t6_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t6_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t6_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t6_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t6_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t6_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t7_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t7_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t7_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t7_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t7_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t7_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t7_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t7_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t7_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t8_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t8_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t8_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t8_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t8_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t8_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t8_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t8_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t8_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t8_wb_we_o \
      xess_top.i_xess_fpga.tc_top.wb_clk_i \
      xess_top.i_xess_fpga.tc_top.wb_rst_i \
      xess_top.i_xess_fpga.tc_top.xi0_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi0_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi1_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi1_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi2_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi2_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi3_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi3_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi4_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi4_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi5_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi5_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi6_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi6_wb_err_o \
      xess_top.i_xess_fpga.tc_top.xi7_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.xi7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.xi7_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi0_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi0_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi1_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi1_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi2_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi2_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi3_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi3_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi4_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi4_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi5_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi5_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi6_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi6_wb_err_o \
      xess_top.i_xess_fpga.tc_top.yi7_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.yi7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.yi7_wb_err_o \
      xess_top.i_xess_fpga.tc_top.z_wb_ack_t \
      xess_top.i_xess_fpga.tc_top.z_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.z_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.z_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.z_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.z_wb_dat_t[31:0]'h \
      xess_top.i_xess_fpga.tc_top.z_wb_err_t \
      xess_top.i_xess_fpga.tc_top.z_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.z_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.z_wb_we_i \

add group \
    "tc_top.t0_ch" \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i0_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i1_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i2_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i3_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i4_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i5_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i6_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.i7_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.req_cont \
      xess_top.i_xess_fpga.tc_top.t0_ch.req_i[7:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.req_r[2:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.req_won[2:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.t0_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t0_ch.wb_clk_i \
      xess_top.i_xess_fpga.tc_top.t0_ch.wb_rst_i \

add group \
    "tc_top.t18_ch_upper" \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i0_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i1_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i2_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i3_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i4_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i5_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i6_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.i7_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.req_cont \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.req_i[7:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.req_r[2:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.req_won[2:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.t0_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.wb_clk_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_upper.wb_rst_i \

add group \
    "tc_top.t18_ch_lower" \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_in[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_out[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_ack_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_cab_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_cyc_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_err_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_stb_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.i0_wb_we_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.req_t[7:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t0_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t1_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t2_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t3_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t4_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t5_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t6_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_in[33:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_out[71:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_ack_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_adr_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_cab_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_cyc_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_err_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_sel_o[3:0]'h \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_stb_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.t7_wb_we_o \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.wb_clk_i \
      xess_top.i_xess_fpga.tc_top.t18_ch_lower.wb_rst_i \

add group \
    rf \

add group \
    if \

add group \
    freeze \

add group \
    tt \

add group \
    dwb \
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
    fl \
      xess_top.i_xess_fpga.flash_top.a[20:0]'h \
      xess_top.i_xess_fpga.flash_top.a_oe \
      xess_top.i_xess_fpga.flash_top.ack \
      xess_top.i_xess_fpga.flash_top.cen \
      xess_top.i_xess_fpga.flash_top.counter[4:0]'h \
      xess_top.i_xess_fpga.flash_top.d[7:0]'h \
      xess_top.i_xess_fpga.flash_top.fflash'h \
      xess_top.i_xess_fpga.flash_top.flash_rstn \
      xess_top.i_xess_fpga.flash_top.middle_tphqv[3:0]'h \
      xess_top.i_xess_fpga.flash_top.oen \
      xess_top.i_xess_fpga.flash_top.rdy \
      xess_top.i_xess_fpga.flash_top.wb_ack_o \
      xess_top.i_xess_fpga.flash_top.wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_clk_i \
      xess_top.i_xess_fpga.flash_top.wb_cyc_i \
      xess_top.i_xess_fpga.flash_top.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_err_o \
      xess_top.i_xess_fpga.flash_top.wb_rst_i \
      xess_top.i_xess_fpga.flash_top.wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.flash_top.wb_stb_i \
      xess_top.i_xess_fpga.flash_top.wb_we_i \
      xess_top.i_xess_fpga.flash_top.wen \

add group \
    sr \
      xess_top.i_xess_fpga.sram_top.LatchedAddr[18:0]'h \
      xess_top.i_xess_fpga.sram_top.Mux \
      xess_top.i_xess_fpga.sram_top.ack_we \
      xess_top.i_xess_fpga.sram_top.d_oe \
      xess_top.i_xess_fpga.sram_top.fsram'h \
      xess_top.i_xess_fpga.sram_top.l0_wen \
      xess_top.i_xess_fpga.sram_top.l1_wen \
      xess_top.i_xess_fpga.sram_top.l_a[18:0]'h \
      xess_top.i_xess_fpga.sram_top.l_cen \
      xess_top.i_xess_fpga.sram_top.l_d_i[15:0]'h \
      xess_top.i_xess_fpga.sram_top.l_d_o[15:0]'h \
      xess_top.i_xess_fpga.sram_top.l_data[15:0]'h \
      xess_top.i_xess_fpga.sram_top.l_mux[15:0]'h \
      xess_top.i_xess_fpga.sram_top.l_oe \
      xess_top.i_xess_fpga.sram_top.l_oen \
      xess_top.i_xess_fpga.sram_top.l_read[15:0]'h \
      xess_top.i_xess_fpga.sram_top.latch_data[31:0]'h \
      xess_top.i_xess_fpga.sram_top.r0_wen \
      xess_top.i_xess_fpga.sram_top.r1_wen \
      xess_top.i_xess_fpga.sram_top.r_a[18:0]'h \
      xess_top.i_xess_fpga.sram_top.r_ack \
      xess_top.i_xess_fpga.sram_top.r_cen \
      xess_top.i_xess_fpga.sram_top.r_d_i[15:0]'h \
      xess_top.i_xess_fpga.sram_top.r_d_o[15:0]'h \
      xess_top.i_xess_fpga.sram_top.r_data[15:0]'h \
      xess_top.i_xess_fpga.sram_top.r_mux[15:0]'h \
      xess_top.i_xess_fpga.sram_top.r_oe \
      xess_top.i_xess_fpga.sram_top.r_oen \
      xess_top.i_xess_fpga.sram_top.r_read[15:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_ack_o \
      xess_top.i_xess_fpga.sram_top.wb_adr_i[31:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_clk_i \
      xess_top.i_xess_fpga.sram_top.wb_cyc_i \
      xess_top.i_xess_fpga.sram_top.wb_dat_i[31:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_dat_o[31:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_err_o \
      xess_top.i_xess_fpga.sram_top.wb_rst_i \
      xess_top.i_xess_fpga.sram_top.wb_sel_i[3:0]'h \
      xess_top.i_xess_fpga.sram_top.wb_stb_i \
      xess_top.i_xess_fpga.sram_top.wb_we_i \

add group \
    dmmu_tlb \

add group \
    dmmu_top \

add group \
    dc_top \

add group \
    dc_fsm \

add group \
    ic_top \

add group \
    ic_fsm \

add group \
    immu_tlb \

add group \
    immu_top \

add group \
    dbg_if_model \

add group \
    genpc \

add group \
    lsu \

add group \
    mem2reg \


deselect all
open window designbrowser 1 geometry 56 117 855 550
open window waveform 1 geometry 10 62 1016 709
zoom at 5563903.368(0)ns 0.00018673 0.00000000
