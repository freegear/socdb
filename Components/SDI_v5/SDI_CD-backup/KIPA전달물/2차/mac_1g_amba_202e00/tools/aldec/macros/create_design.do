# ******************************************************************* #
# Copyright (c) 2001-2004  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix S.A. immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #
#
# ------------------------------------------------------------------- #
# Project name         : MAC-1G_AMBA
# Project description  : Gigabit Media Access Controller for Ethernet
# File name            : create_design.do
# File contents        : Sample macro for ALDEC ActiveVHDL 
# Purpose              : Creating design for MAC test bench
# Design Engineer      : L.C.
# Quality Engineer     : M.B.
# Version              : 2.02
# Last modification    : 2004-08-16
# ------------------------------------------------------------------- #

@transcript off
set DIR d:\designs\mac_1g_amba\ver_202
set directory mac_1g_amba_202e00

transcript on
# ------------------------------------------------------------------- #
# Creating design MAC-1G_AMBA
# ------------------------------------------------------------------- #
@transcript off

createdesign $directory $DIR

transcript on
# ------------------------------------------------------------------- #
# Opening design MAC-1G_AMBA
# ------------------------------------------------------------------- #
@transcript off

cd $DIR\$directory
opendesign $directory

transcript on
# ------------------------------------------------------------------- #
# Creating destination library for core of model
# ------------------------------------------------------------------- #
@transcript off

vlib MAC_1G_LIB $DSN
vmap MAC_1G_LIB $DSN
vlib MAC2AMBA_LIB $DSN
vmap MAC2AMBA_LIB $DSN
vlib MAC_1G_AMBA_LIB $DSN
vmap MAC_1G_AMBA_LIB $DSN


transcript on
# ------------------------------------------------------------------- #
# Adding Macros
# ------------------------------------------------------------------- #
@transcript off

addfile -do $DSN\tools\aldec\macros\create_design.do
addfile -tcl $DSN\tools\aldec\macros\08bit_tests.tcl
addfile -tcl $DSN\tools\aldec\macros\16bit_tests.tcl
addfile -tcl $DSN\tools\aldec\macros\32bit_tests.tcl
addfile -tcl $DSN\tools\aldec\macros\all_tests.tcl


@transcript on
# ------------------------------------------------------------------- #
# Adding components of mac_1g core
# ------------------------------------------------------------------- #
@transcript off

addfile -vhdl $DSN\src\core\mac_1g\utility_mac_1g.vhd
addfile -vhdl $DSN\src\core\mac_1g\rc.vhd
addfile -vhdl $DSN\src\core\mac_1g\tc.vhd
addfile -vhdl $DSN\src\core\mac_1g\bd.vhd
addfile -vhdl $DSN\src\core\mac_1g\tfifo.vhd
addfile -vhdl $DSN\src\core\mac_1g\rfifo.vhd
addfile -vhdl $DSN\src\core\mac_1g\tlsm.vhd
addfile -vhdl $DSN\src\core\mac_1g\rlsm.vhd
addfile -vhdl $DSN\src\core\mac_1g\dma.vhd
addfile -vhdl $DSN\src\core\mac_1g\csr.vhd
addfile -vhdl $DSN\src\core\mac_1g\rstc.vhd
addfile -vhdl $DSN\src\core\mac_1g\miism.vhd
addfile -vhdl $DSN\src\core\mac_1g\bp.vhd
addfile -vhdl $DSN\src\core\mac_1g\dom.vhd
addfile -vhdl $DSN\src\core\mac_1g\domack.vhd
addfile -vhdl $DSN\src\core\mac_1g\domreq.vhd
addfile -vhdl $DSN\src\core\mac_1g\fcr.vhd
addfile -vhdl $DSN\src\core\mac_1g\fct.vhd
addfile -vhdl $DSN\src\core\mac_1g\fcstat.vhd
addfile -vhdl $DSN\src\core\mac_1g\sc.vhd
addfile -vhdl $DSN\src\core\MAC_1g\mac_1g.vhd

@transcript on
# ------------------------------------------------------------------- #
# Adding components of mac2amba wrapper core
# ------------------------------------------------------------------- #
@transcript off

addfile -vhdl $DSN\src\core\mac2amba\mac2amba_package.vhd
addfile -vhdl $DSN\src\core\mac2amba\macdata2ahb.vhd
addfile -vhdl $DSN\src\core\mac2amba\maccsr2apb.vhd
addfile -vhdl $DSN\src\core\mac2amba\mac2amba.vhd
 
 
addfile -vhdl $DSN\src\core\mac_1g_amba.vhd 

transcript on
# ------------------------------------------------------------------- #
# Adding chip
# ------------------------------------------------------------------- #
@transcript off

addfile -vhdl $DSN\src\tb\chip\tris.vhd
addfile -vhdl $DSN\src\tb\chip\dualram.vhd
addfile -vhdl $DSN\src\tb\chip\scdram.vhd
addfile -vhdl $DSN\src\tb\chip\chip_mac_1g_amba.vhd
transcript on
# ------------------------------------------------------------------- #
# Adding components of Test Bench
# ------------------------------------------------------------------- #
@transcript off

addfile -vhdl $DSN\src\tb\env\linkmon.vhd
addfile -vhdl $DSN\src\tb\env\intmon.vhd
addfile -vhdl $DSN\src\tb\env\apbcmd.vhd
addfile -vhdl $DSN\src\tb\env\ambaarbcmd.vhd
addfile -vhdl $DSN\src\tb\env\smemstimahb.vhd
addfile -vhdl $DSN\src\tb\env\clkgen.vhd
addfile -vhdl $DSN\src\tb\env\rstgen.vhd
addfile -vhdl $DSN\src\tb\env\cam.vhd

transcript on
# ------------------------------------------------------------------- #
# Adding Test Bench
# ------------------------------------------------------------------- #
@transcript off

addfile -vhdl $DSN\src\tb\mac_1g_amba_tb.vhd

# =================================================================== #
# Compiler section
# =================================================================== #
# ------------------------------------------------------------------- #
# Compiling core mac_1g
# ------------------------------------------------------------------- #
@transcript off

cd $DSN\src\core\mac_1g
vcom -87 -work MAC_1G_LIB utility_mac_1g.vhd
vcom -87 -work MAC_1G_LIB tc.vhd
vcom -87 -work MAC_1G_LIB rc.vhd
vcom -87 -work MAC_1G_LIB bd.vhd
vcom -87 -work MAC_1G_LIB tfifo.vhd
vcom -87 -work MAC_1G_LIB rfifo.vhd
vcom -87 -work MAC_1G_LIB tlsm.vhd
vcom -87 -work MAC_1G_LIB rlsm.vhd
vcom -87 -work MAC_1G_LIB dma.vhd
vcom -87 -work MAC_1G_LIB csr.vhd
vcom -87 -work MAC_1G_LIB rstc.vhd
vcom -87 -work MAC_1G_LIB miism.vhd
vcom -87 -work MAC_1G_LIB dom.vhd
vcom -87 -work MAC_1G_LIB domack.vhd
vcom -87 -work MAC_1G_LIB domreq.vhd
vcom -87 -work MAC_1G_LIB bp.vhd
vcom -87 -work MAC_1G_LIB fcr.vhd
vcom -87 -work MAC_1G_LIB fct.vhd
vcom -87 -work MAC_1G_LIB fcstat.vhd
vcom -87 -work MAC_1G_LIB sc.vhd
vcom -87 -work MAC_1G_LIB mac_1g.vhd

@transcript on
# ------------------------------------------------------------------- #
# compiling mac2amba wrapper core
# ------------------------------------------------------------------- #
@transcript off

vcom -87 -work MAC2AMBA_LIB $DSN\src\core\mac2amba\mac2amba_package.vhd
vcom -87 -work MAC2AMBA_LIB $DSN\src\core\mac2amba\macdata2ahb.vhd
vcom -87 -work MAC2AMBA_LIB $DSN\src\core\mac2amba\maccsr2apb.vhd
vcom -87 -work MAC2AMBA_LIB $DSN\src\core\mac2amba\mac2amba.vhd

transcript on
# ------------------------------------------------------------------- #
# compiling mac_amba
# ------------------------------------------------------------------- #
@transcript off

vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\core\mac_1g_amba.vhd

transcript on
# ------------------------------------------------------------------- #
# Adding chip
# ------------------------------------------------------------------- #
@transcript off

vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\chip\tris.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\chip\dualram.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\chip\scdram.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\chip\chip_mac_1g_amba.vhd

transcript on
# ------------------------------------------------------------------- #
# Adding components of Test Bench
# ------------------------------------------------------------------- #
@transcript off

vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\linkmon.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\intmon.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\apbcmd.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\ambaarbcmd.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\smemstimahb.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\clkgen.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\rstgen.vhd
vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\env\cam.vhd

transcript on
# ------------------------------------------------------------------- #
# Adding Test Bench
# ------------------------------------------------------------------- #
@transcript off

vcom -87 -work MAC_1G_AMBA_LIB $DSN\src\tb\mac_1g_amba_tb.vhd


