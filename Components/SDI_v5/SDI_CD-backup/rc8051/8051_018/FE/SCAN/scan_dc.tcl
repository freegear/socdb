#
# Written by : DC-Transcript, Version V-2004.06-1 -- May 28, 2004
# Date       : Fri Feb  4 20:52:24 2005
#

#
# Translation of script: scan_dc.dc
#

read_file -f verilog /user/cklee/PRJ/8051_018/FE/SYN/SYN_DB/rc8051RtlTop_compile.v 

current_design rc8051RtlTop
link

set test_default_scan_style  multiplexed_flip_flop
set_test_methodology full_scan
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_period 100
set test_default_strobe 80

set hdlin_enable_rtldrc_info true
set test_enable_dft_drc TRUE
set_dft_configuration -autofix
set_autofix_configuration

set test_stil_netlist_format verilog

create_test_clock clk -p 100 -w [list 45 55]
#create_test_clock mtx_clk -p 100 -w [list 45 55]
#create_test_clock prx_clk -p 100 -w [list 45 55]
#create_test_clock grx_clk -p 100 -w [list 45 55]
#create_test_clock m_clk -p 100 -w [list 45 55]

set_signal_type test_asynch_inverted rst_p

set_scan_configuration -chain_count 16

set_scan_signal test_scan_in -port {rom_data_i[0]}
set_scan_signal test_scan_in -port {rom_data_i[1]}
set_scan_signal test_scan_in -port {rom_data_i[2]}
set_scan_signal test_scan_in -port {rom_data_i[3]}
set_scan_signal test_scan_in -port {rom_data_i[4]}
set_scan_signal test_scan_in -port {rom_data_i[5]}
set_scan_signal test_scan_in -port {rom_data_i[6]}
set_scan_signal test_scan_in -port {rom_data_i[7]}
set_scan_signal test_scan_in -port {in_xdat_a[0]}
set_scan_signal test_scan_in -port {in_xdat_a[1]}
set_scan_signal test_scan_in -port {in_xdat_a[2]}
set_scan_signal test_scan_in -port {in_xdat_a[3]}
set_scan_signal test_scan_in -port {in_xdat_a[4]}
set_scan_signal test_scan_in -port {in_xdat_a[5]}
set_scan_signal test_scan_in -port {in_xdat_a[6]}
set_scan_signal test_scan_in -port {in_xdat_a[7]}

set_scan_signal test_scan_out -port {rom_adr_o[0]}
set_scan_signal test_scan_out -port {rom_adr_o[1]}
set_scan_signal test_scan_out -port {rom_adr_o[2]}
set_scan_signal test_scan_out -port {rom_adr_o[3]}
set_scan_signal test_scan_out -port {rom_adr_o[4]}
set_scan_signal test_scan_out -port {rom_adr_o[5]}
set_scan_signal test_scan_out -port {rom_adr_o[6]}
set_scan_signal test_scan_out -port {rom_adr_o[7]}
set_scan_signal test_scan_out -port {rom_adr_o[8]}
set_scan_signal test_scan_out -port {rom_adr_o[9]}
set_scan_signal test_scan_out -port {rom_adr_o[10]}
set_scan_signal test_scan_out -port {rom_adr_o[11]}
set_scan_signal test_scan_out -port {rom_adr_o[12]}
set_scan_signal test_scan_out -port {rom_adr_o[13]}
set_scan_signal test_scan_out -port {rom_adr_o[14]}
set_scan_signal test_scan_out -port {rom_adr_o[15]}

set_scan_signal test_scan_enable -port scan_en
set_dft_signal test_mode -port test_mode


current_design rc8051RtlTop
set_dft_configuration  -autofix

set_scan_bidi output -port *p1_io*
#set_scan_bidi output -port *dn_ram_data*
#set_scan_bidi output -port m_data*
#set_scan_bidi output -port *mdio*

set_test_hold 0 BistMode 
set_test_hold 1 test_mode
#set_test_hold 0 TCK
#set_test_hold 0 TMS
#set_test_hold 0 TRST

###############set_dont_touch#########################
current_design rc8051RtlTop
set_dont_touch_network clk
set_dont_touch_network rst_p
#set_dont_touch_network PI_mtx_clk/C
#set_dont_touch_network PI_prx_clk/C
#set_dont_touch_network PI_grx_clk/C
#set_dont_touch_network PI_m_clk/C

set_dont_touch_network PI_scan_en/C
set_dont_touch_network PI_test_mode/C
set_dont_touch_network PI_BistMode/C


current_design rc8051RtlTop
####################################################

#set_dft_signal test_point_clock -port m_clk
#set_dft_signal test_point_clock -port grx_clk

#set_dft_signal test_point_clock -port prx_clk
#set_dft_signal test_point_clock -port mtx_clk
#set_dft_signal test_point_clock -port ref_clk

set_scan_element false [find -hier cell "*SRAM_i0*"]
#set_scan_element false [find -hier cell "*dpram*"]
#set_scan_element false { epsc_blk/macsec_blk/tx_blk/bypass_blk/delay_fifo/delay_fifo }
#set_scan_element false { epsc_blk/macsec_blk/rx_blk/bypass_blk/delay_fifo/delay_fifo }

set_autofix_configuration -async true
set_autofix_async rst_p [all_registers]
set_autofix_clock clk [all_registers]

##############set_dont_use######################################################
set_dont_use "slow/DFFN*"
set_dont_use "slow/CLK*"
set_dont_use "slow/JK*"
set_dont_use "slow/*XL" ;# don't use low power cells.
set_dont_use "slow/DLY*" ;# dont'use DLY cell, -> 2004.03.15.23:00 change

set_dont_use "fast/DFFN*"
set_dont_use "fast/CLK*"
set_dont_use "fast/JK*"
set_dont_use "fast/*XL" ;# don't use low power cells.
set_dont_use "fast/DLY*" ;# dont'use DLY cell, -> 2004.03.15.23:00 change
#because of its poor driving ability.
#set_dont_use "slow/CMPR*"
#set_dont_use "slow/ADD*"
#set_dont_use "slow/SD*"
set_dont_use "slow/*TL*"


create_test_protocol
preview_dft -test_points all
dft_drc > pre_dft_drc.rpt

insert_dft

#create_test_protocol
dft_drc -coverage_estimate > post_dft_drc.rpt

set_fix_multiple_port_nets -all
set_fix_multiple_port_nets -feedthroughs -constants -outputs -buffer_constants

report_test -port > report_ports
report_test -scan_path > scan_path.rpt

current_design rc8051RtlTop
write -format verilog -hierarchy -output ./SCAN_DB/rc8051RtlTop_scan.v
write -format db -hierarchy -output ./SCAN_DB/rc8051RtlTop_scan.db
write_test_protocol -format stil -out   ./SCAN_DB/rc8051RtlTop_scan.spf
quit

