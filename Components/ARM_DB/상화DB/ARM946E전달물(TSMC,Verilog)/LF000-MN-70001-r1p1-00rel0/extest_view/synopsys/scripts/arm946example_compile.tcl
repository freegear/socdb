#----------------------------------------------------------------------
#--  This confidential and proprietary software may be used only as
#--  authorised by a licensing agreement from ARM Limited
#--    (C) COPYRIGHT 2001-2002 ARM Limited
#--        ALL RIGHTS RESERVED
#--  The entire notice above must be reproduced on all authorised
#--  copies and copies may only be made to the extent permitted
#--  by a licensing agreement from ARM Limited.
#--
#-- Version and Release Control Information:
#--
#-- File Name     : $RCSfile: arm946example_compile.tcl,v $
#-- File Revision : $Revision: 1.2 $
#--
#-- Release Information : $State: Rel $
#--
#----------------------------------------------------------------------
#
# Purpose 	: DC build script for the ARM946Example wrapper using the .lib
#                 form of the ARM946E_88
#

set verilogout_no_tri true

# Set option values 
set verbose             0
set wrapper_mux_delay 0.0
set force_wireload      0  ;# 1 = Manual wireload selection, 0 = Auto selection.
                            # NOTE: UMC 0.18um VS library, NO wire load used if AUTO
set wireload_model "suggested_160K" ;# Name of wireload model to manually select
set presto              0  ;# 1 = Use PRESTO Verilog reader. Turned off since slower.
set signoff             0  ;# Only set for use in signoff STA scripts, leave = 0 here.

# Defining clock and clock period
set clk_period 		10.0
set io_clk_period 	10.0
set clk_uncertainty 	0.30
set max_transition_limit 1.0  ;# Define maximum transition constraint

set clk_name CLK

# Constrain the clock gating cell clock pins for clock latency less cell delay
set latency_fmax 0.000  ;# Define default zero latency
set latency_fmin 0.000  ;# Define default zero latency

# Read in the technology specific script 
if { $verbose } { 
	source -echo -verbose ./scripts/tsmc18.tcl 
} else {
	source -echo ./scripts/tsmc18.tcl
}

if { $presto } {
    set hdlin_enable_presto true 
} else {
    set hdlin_enable_presto false
}

# Read in the RTL for the top-level and for the test wrapper:
set hdlin_enable_vpp true
analyze -f verilog { A946ESParams.v CaptureCell.v CapUpdCell.v CapUpdCellClkEn.v \
                     CapUpdCellEn.v CapUpdCellReset.v A946ESDTCM.v A946ESITCM.v \
                     A946ESWrapper.v ARM946E_8888.v }

# Elaborate the design.
elaborate -update -architecture verilog ARM946E_8888

# Identify wire load model and operating conditions
if { $force_wireload } {
    set_wire_load_model -name $wireload_model -library $wireload_library
    set_wire_load_mode top
} else {
    set auto_wire_load_selection true
    set_wire_load_mode top
}

# Set the operating conditions
set_operating_conditions $max_name

# Compile Wrapper Scan Cells
current_design CapUpdCell
	compile 
	set_dont_touch CapUpdCell

current_design CapUpdCellClkEn
	compile
	set_dont_touch CapUpdCellClkEn

current_design CapUpdCellEn
	compile
	set_dont_touch CapUpdCellEn

current_design CapUpdCellReset
	compile
	set_dont_touch CapUpdCellReset

# Assert and link design 
current_design ARM946E_8888
link

set_fix_multiple_port_nets -feedthroughs -outputs -buffer_constants

# Create clock
create_clock -period $clk_period CLK
	set_clock_uncertainty -setup $clk_uncertainty CLK
	set_clock_uncertainty -hold $clk_uncertainty CLK
	set_clock_transition 0 CLK

set high_fanout [list CLK]
set_load  $load_value [list [all_outputs]]
set_driving_cell -cell $driving_cell_name -pin $driving_cell_pin [\
    list [remove_from_collection [all_inputs] $high_fanout]]

# Apply constraints
source -echo ./scripts/arm946example_constraints.tcl

# Check timing to warn of possible problems, this is an important step
redirect ./report/ARM946Example.checktiming {check_timing}

redirect ./report/ARM946Example.checkdesprecomp {check_design}

# Top Down Compile
compile -map_effort medium

redirect ./report/ARM946Example.checkdespostcomp {check_design}

# Check the scan chain in the wrapper to ensure that Design Compiler
# recognises it.
set_dont_touch A946ESWrapper true
current_design A946ESWrapper
set_scan_configuration -existing_scan true
set_signal_type test_scan_in   [get_port "SI"]
set_signal_type test_scan_out  [get_port "SO"]
set_signal_type test_scan_enable   [get_port "EXSCANENABLE"]
set_test_hold 0 [get_port "SerialEn"]
set_scan_element false {uscan115/HeldDataBit_reg \
                    uscan235/HeldDataBit_reg \
                    uscan261/HeldDataBit_reg \
                    uscan262/HeldDataBit_reg \
                    uscan263/HeldDataBit_reg \
                    uscan264/HeldDataBit_reg \
                    uscan265/HeldDataBit_reg \
                    uscan266/HeldDataBit_reg \
                    uscan267/HeldDataBit_reg \
                    uscan268/HeldDataBit_reg}
report_test -configuration
check_dft

current_design ARM946E_8888
set_scan_configuration -existing_scan true
# Setting Scan for DFT check
# Extest mode:
set_test_hold 0 TESTMODE
set_test_hold 0 SERIALEN
set_test_hold 0 SCANEN
set_test_hold 1 TESTEN
set_test_hold 0 INnotEXTEST
set_test_hold 0 INSCANENABLE

set_signal_type test_scan_enable EXSCANENABLE

set_signal_type test_scan_in SI
set_signal_type test_scan_out SO
foreach scan_num [list 1 2 3 4] {
    set scanin_name [format "SCANIN%s" $scan_num]
    set scanout_name [format "SCANOUT%s" $scan_num]
    set_signal_type test_scan_in $scanin_name
    set_signal_type test_scan_out $scanout_name
}

# Asserting non scan regions
set_scan_element false {uWrapper/uscan115/HeldDataBit_reg \
			uWrapper/uscan235/HeldDataBit_reg \
                       	uWrapper/uscan261/HeldDataBit_reg \
                       	uWrapper/uscan262/HeldDataBit_reg \
                       	uWrapper/uscan263/HeldDataBit_reg \
                        uWrapper/uscan264/HeldDataBit_reg \
                        uWrapper/uscan265/HeldDataBit_reg \
                        uWrapper/uscan266/HeldDataBit_reg \
                        uWrapper/uscan267/HeldDataBit_reg \
                        uWrapper/uscan268/HeldDataBit_reg \
                        iITCM iDTCM }

set test_default_delay       0
set test_default_bidir_delay 0
set test_default_strobe     35
set test_default_period    100
set test_stil_netlist_format verilog

# Create clock for scan tests
create_test_clock CLK  -period 100 -waveform {45 95}

check_dft

# More reports
redirect ./report/ARM946Example.qor    { report_qor }
redirect ./report/ARM946Example.timing { report_timing -max 32 -inp -nets -tran -cap -nos }
redirect ./report/ARM946Example.vio    { report_constraint -all_violators }

redirect          ./report/ARM946Example.des { report_design }
redirect -append  ./report/ARM946Example.des { report_clock  }
redirect -append  ./report/ARM946Example.des { report_clock -skew -nosplit }

# create DFT report:
#
# As the ARM946E_88 is a .lib we expect to see " Cell uARM946E_88
# (ARM946E_88) is unknown (black box) " warnings in the check_dft report.
# There may be similar warnings for the TCM RAMS if present.
redirect ./report/ARM946Example.dft      { check_dft  }
# This will only report the wrapper scan chain:
redirect ./report/ARM946Example.scanpath { report_test -scan_path }

# Write netlists
write -f verilog -hier -o ./db/ARM946Example.v
write -f db      -hier -o ./db/ARM946Example.db

quit
