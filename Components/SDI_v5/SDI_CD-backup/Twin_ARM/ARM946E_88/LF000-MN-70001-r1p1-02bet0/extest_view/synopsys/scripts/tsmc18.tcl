#----------------------------------------------------------------------
#--  This confidential and proprietary software may be used only as
#--  authorised by a licensing agreement from ARM Limited
#--    (C) COPYRIGHT 2002 ARM Limited
#--        ALL RIGHTS RESERVED
#--  The entire notice above must be reproduced on all authorised
#--  copies and copies may only be made to the extent permitted
#--  by a licensing agreement from ARM Limited.
#--
#-- Version and Release Control Information:
#--
#-- File Name     : $RCSfile: tsmc18.tcl,v $
#-- File Revision : $Revision: 1.2 $
#--
#-- Release Information : $State: Rel $
#--
#----------------------------------------------------------------------
#
# Purpose: Technology file for Artisan TSMC 0.18um
#

# Setup libraries
set synthetic_library   dw_foundation.sldb
set target_library      [list slow_cg.db ]
set symbol_library	[list tsmc18_cg.sdb]

# Set to the TCM RAM library or libraries:
set ram_library         [list ByteRAM_256RA1SH_slow_syn.db ]

# Establish the complete link path
set link_path           [concat [list *]   $synthetic_library]
set link_path           [concat $link_path $target_library]
set link_path           [concat $link_path ARM946E_88_max]
set link_path           [concat $link_path $ram_library]

# Ensure that all RTL is in search path
set search_path         [list ../../verilog]

# Ensure that all libraries are in search path:
# Set to point to the required library.
set search_path         [concat  $search_path /path_to_cell_library/fb_tsmc18_sc-x-cg_2001q3v1/aci/sc/synopsys]
# Set to point to the Synopsys installation
set search_path         [concat  $search_path /path_to_synopsys_synthesis_lib/libraries/syn ]
# Point to the TCM ram models ($ram_library) here:
set search_path         [concat  $search_path path_to_ram_libs]
set search_path         [concat  $search_path path_to_ram_verilog]
# Add relative directories (there should be no need to change these):
set search_path         [concat  $search_path ../../timing_views/lib]
set search_path         [concat  $search_path ../verilog/RAMS]
set search_path         [concat  $search_path ../verilog/ARM946E_8888]

# Load up technology library, set context and define unwanted cells
read_db slow_cg.db

# Select load value for output ports
set load_value 0.3

# Select drive for input ports
set driving_cell_name NAND2X4
set driving_cell_pin Y

# Dont use these cells
set_dont_use slow_cg/RSLATNXL
set_dont_use slow_cg/SEDFFXL
set_dont_use slow_cg/CLK*
set_dont_use slow_cg/TBUF*
# Dont use low drive gates
set_dont_use [find cell slow_cg/*XL]

#Clock gating cells not to be used
set_dont_use slow_cg/TLATCO*
set_dont_use slow_cg/TLATNCA*
set_dont_use slow_cg/TLATTSCO*

# Define the design library
define_design_lib work -path ./lib

# Set verilog in/out variables
set hdlin_check_no_latch true
set hdlin_merge_nested_conditional_statements false
set verilogout_higher_designs_first true
set verilogout_no_tri true

# Define format of test signals
set test_scan_enable_port_naming_style SCANEN%s
set test_scan_in_port_naming_style SCANIN%s
set test_scan_out_port_naming_style SCANOUT%s

# Turn on ultra if wanted
#set_ultra_optimization true -force

# Generic name rules (for back-end tool compatibility)
define_name_rules ARM -allowed "A-Za-z0-9_" -first_restricted "0-9_" -last_restricted "_" -map { {{"\*cell\*", "U"}} }
#set bus_naming_style "%s_%d"

# At present, Apollo does not accept NAMEPREFIX in pdef
set pdefin_use_nameprefix false

set enable_page_mode false

read_db ARM946E_88_max.db

set_min_library -min_version fast_cg.db slow_cg.db
# Setup min library for TCM Ram(s)
set_min_library -min_version ByteRAM_256RA1SH_fast_syn.db ByteRAM_256RA1SH_slow_syn.db
set_min_library -min_version ARM946E_88_min.db ARM946E_88_max.db

set max_name slow
set min_name fast
