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


setenv source_dir src/core
setenv env_dir    src/tb/env
setenv chip_dir   src/tb/chip
setenv tb_dir     src/tb
setenv work_dir   tools/mti/ee_lib

vlib $work_dir
vmap MAC_1G_LIB $work_dir
vmap MAC2AMBA_LIB $work_dir
vmap MAC_1G_AMBA_LIB $work_dir
