# ******************************************************************* #
# Copyright (c) 1999-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix SA immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #

# ------------------------------------------------------------------- #
# Project name         : MAC-1G_AMBA
# Project description  : Ethernet Media Access Controller
#
# File name            : SIMULATE.DO
# File contents        : Sample macro for MTI ModelSim EE
# Purpose              : MAC-1G_AMBA core functional simulation
# Design Engineer      : M.B.
# Quality Engineer     : M.B.
# Version              : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #

#transcript off

# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #


setenv work_dir   tools/mti/ee_lib
setenv report_dir tools/mti/ee_reports

# ------------------------------------------------------------------- #
# Maping destination directory
# ------------------------------------------------------------------- #

vmap MAC_1G_LIB $work_dir
vmap MAC2AMBA_LIB $work_dir
vmap MAC_1G_AMBA_LIB $work_dir
#transcript on


# ------------------------------------------------------------------- #
# Loading the Test Bench
# ------------------------------------------------------------------- #

#transcript off
vsim -t ns -lib MAC_1G_AMBA_LIB TESTBENCH_MAC_1G_AMBA_CONFIGURATION
#transcript on


# ------------------------------------------------------------------- #
# Adding signals to the 'Wave' window
# ------------------------------------------------------------------- #

#transcript off
add wave -logic /uut/tps
add wave -logic /uut/rps
add wave -logic /uut/gbo
add wave -logic /uut/int

add wave -logic /uut/hclk
add wave -logic /uut/hresetn
add wave -logic /uut/hrdata
add wave -logic /uut/hready
add wave -logic /uut/hresp
add wave -logic /uut/haddr
add wave -logic /uut/htrans
add wave -logic /uut/hwrite
add wave -logic /uut/hsize
add wave -logic /uut/hburst
add wave -logic /uut/hprot
add wave -logic /uut/hwdata
add wave -logic /uut/hgrantmac
add wave -logic /uut/hbusreqmac	
add wave -logic /uut/hlockmac  

add wave -logic /uut/pclk
add wave -logic /uut/presetn
add wave -logic /uut/paddr
add wave -logic /uut/pselmaccsr
add wave -logic /uut/penable
add wave -logic /uut/pwrite
add wave -logic /uut/pwdata
add wave -logic /uut/prdata

add wave -logic /uut/clkt
add wave -logic /uut/txd
add wave -logic /uut/txen
add wave -logic /uut/txer
						 
add wave -logic /uut/clkr 
add wave -logic /uut/rxd
add wave -logic /uut/rxdv
add wave -logic /uut/rxer
add wave -logic /uut/col
add wave -logic /uut/crs

add wave -logic /uut/mdc
add wave -logic /uut/mdio


#transcript on


# ------------------------------------------------------------------- #
# Adding signals to the 'List' window
# ------------------------------------------------------------------- #

#transcript off
#add list -width 8 /uut/gbo
transcript on


# ------------------------------------------------------------------- #
# Writing report
# ------------------------------------------------------------------- #

#transcript off
write report $report_dir/simulate.log
#transcript on

# ******************************************************************* #
