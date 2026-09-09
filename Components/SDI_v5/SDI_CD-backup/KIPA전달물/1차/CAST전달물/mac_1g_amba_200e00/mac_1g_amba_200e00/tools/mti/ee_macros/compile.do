# ******************************************************************* #
# Copyright (c) 1999-2003  Evatronix SA
# ******************************************************************* #
# Please review the terms of the license agreement before using
# this file. If you are not an authorized user, please destroy this
# source code file and notify Evatronix S.A. immediately that you
# inadvertently received an unauthorized copy.
# ******************************************************************* #
#
# ------------------------------------------------------------------- #
# Project name         : MAC-1G
# Project description  : Gigabit Media Access Controller for Ethernet
# File name            : COMPILE.DO
# File contents        : Sample macro for MTI ModelSim EE
# Purpose              : MAC test bench
# Design Engineer      : T.K.
# Quality Engineer     : M.B.
# Test version         : 2.00
# Last modification    : 2003-06-24
# ------------------------------------------------------------------- #

transcript off
# ------------------------------------------------------------------- #
# Directories location
# ------------------------------------------------------------------- #

setenv source_dir src/core
setenv env_dir    src/tb/env
setenv chip_dir   src/tb/chip
setenv tb_dir     src/tb
setenv work_dir   tools/mti/ee_lib

# ------------------------------------------------------------------- #
# Maping destination directory for core of model
# ------------------------------------------------------------------- #

vlib $work_dir
vmap MAC_1G_LIB $work_dir
vmap MAC2AMBA_LIB $work_dir
vmap MAC_1G_AMBA_LIB $work_dir
transcript on


# ------------------------------------------------------------------- #
# Compiling utility packages
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/utility_mac_1g.vhd
vcom  -87 -nodebug -work MAC2AMBA_LIB $source_dir/mac2amba/mac2amba_package.vhd
transcript on


# ------------------------------------------------------------------- #
# Compiling components of core	MAC_1G
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/rc.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/tc.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/bd.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/tfifo.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/rfifo.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/tlsm.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/rlsm.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/dma.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/csr.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/rstc.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/miism.vhd
vcom  -87 -nodebug -work MAC_1G_LIB $source_dir/mac_1g/mac_1g.vhd
transcript on
   
# ------------------------------------------------------------------- #
# Compiling components of core	MAC2AMBA
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -nodebug -work MAC2AMBA_LIB $source_dir/mac2amba/macdata2ahb.vhd
vcom  -87 -nodebug -work MAC2AMBA_LIB $source_dir/mac2amba/maccsr2apb.vhd
vcom  -87 -nodebug -work MAC2AMBA_LIB $source_dir/mac2amba/mac2amba.vhd
transcript on   
   
# ------------------------------------------------------------------- #
# Compiling core MAC_1G_AMBA
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $source_dir/mac_1g_amba.vhd
transcript on

# ------------------------------------------------------------------- #
# Compiling components of chip
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $chip_dir/tris.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $chip_dir/dualram.vhd
transcript on

# ------------------------------------------------------------------- #
# Compiling chip
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -work MAC_1G_AMBA_LIB $chip_dir/chip_mac_1g_amba.vhd
transcript on

# ------------------------------------------------------------------- #
# Compiling environment components of Test Bench
# ------------------------------------------------------------------- #

transcript off
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/linkmon.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/intmon.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/apbcmd.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/ambaarbcmd.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/smemstimahb.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/clkgen.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/rstgen.vhd
vcom  -87 -nodebug -work MAC_1G_AMBA_LIB $env_dir/cam.vhd
transcript on


# ------------------------------------------------------------------- #
# Compiling Test Bench
# ------------------------------------------------------------------- #

transcript off
vcom -87 -work MAC_1G_AMBA_LIB $tb_dir/mac_1g_amba_tb.vhd
transcript on

# ******************************************************************* #
