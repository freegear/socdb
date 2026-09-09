#
# Written by : DC-Transcript, Version V-2004.06-1 -- May 28, 2004
# Date       : Fri Feb  4 20:52:24 2005
#

#
# Translation of script: scan_dc.dc
#
#sh rm -r SCAN_LOGS
#sh mkdir SCAN_LOGS
#set logs SCAN_LOGS
set TOP_DESIGN  DTSDI002

read_file -f verilog  ./DATA/DTSDI002.noscan.v
read_file -f verilog  ./DB/adc_LTR9200.v


current_design $TOP_DESIGN
link

set test_default_scan_style  multiplexed_flip_flop
set test_methodology full_scan
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_period 100
set test_default_strobe 40
set hdlin_enable_rtldrc_info true
set test_enable_dft_drc TRUE
set_dft_configuration -autofix
set_autofix_configuration

set test_stil_netlist_format verilog

create_test_clock  -period 100  -waveform [list  45 55 ] [get_ports {ARM_OSCi}]


set_signal_type test_asynch_inverted ARM_RESETi
set_scan_configuration -chain_count 2

#set_scan_signal test_scan_in -port  PB_GPIO03 
#set_scan_signal test_scan_out -port PB_GPIO00 
#set_scan_signal test_scan_enable -port PI_RXD0 
set_dft_signal test_mode -port TEST_MODE 

set_test_hold 1 TEST_MODE
set_test_hold 0 ARM_TDI
set_test_hold 0 ARM_TCK
set_test_hold 0 ARM_TMS
set_test_hold 0 ARM_TRST



current_design $TOP_DESIGN

#set_scan_bidi output -port [remove_from_collection [find port "PB_MD* PB_GPIO*"] [find port "PB_GPIO03 PB_GPIO01"]]
#set_scan_bidi output -port *dn_ram_data*
#set_scan_bidi output -port m_data*
#set_scan_bidi output -port *mdio*

#set_test_hold 0 bistmode
#set_test_hold 1 asic_test

###############set_dont_touch#########################^F
#set_dont_touch PI_*
#set_dont_touch PO_*
#set_dont_touch PB_*
#set_dont_touch_network PI_ref_clk/C
#set_dont_touch_network PI_ref_clk/C
#set_dont_touch_network PI_mtx_clk/C

set_autofix_configuration -async true
set_autofix_async ARM_RESETi [all_registers]
set_autofix_clock ARM_OSCi [all_registers]

##############set_dont_use######################################################
set_dont_use "slow/CLK*"
set_dont_use "slow/JK*"
set_dont_use "slow/*XL" ;# don't use low power cells.
set_dont_use "slow/DLY*" ;# dont'use DLY cell

set_dont_use "slow/CMPR*"
set_dont_use "slow/ADD*"
set_dont_use "slow/*TL*"




create_test_protocol
redirect ./SCAN_LOGS/preview_dft.rpt { preview_dft -test_points all }
redirect ./SCAN_LOGS/pre_dft_drc.rpt { dft_drc }

insert_dft

redirect ./SCAN_LOGS/post_dft_drc.rpt { dft_drc -coverage_estimate }
redirect ./SCAN_LOGS/post_chech_scan.rpt { check_scan -verbose }

set_fix_multiple_port_nets -all
set_fix_multiple_port_nets -feedthroughs -constants -outputs -buffer_constants

report_test -port > ./SCAN_LOGS/report_ports
report_test -scan_path > ./SCAN_LOGS/scan_path.rpt

source ./ungroup.tcl
source ./eliminate_backslash.tcl
source ./screener.tcl
tsmc_naming_rule

current_design $TOP_DESIGN
write -format verilog -hierarchy -output ./SCAN_DB/$TOP_DESIGN.scan.v
write -format db -hierarchy -output ./SCAN_DB/$TOP_DESIGN.scan.db
write_test_protocol -format stil -out   ./SCAN_DB/$TOP_DESIGN.scan.spf
quit
