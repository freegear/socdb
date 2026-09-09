#!/bin/sh

# function for exit when fail
action() {
	$* || exit 1
	rc=$?
	return $rc
}

if [ -e ./work ]
then
	rm -rf work
fi

vlib work

VLOG_OPT0=$1
VLOG_OPT='-work work +libext+.v +incdir+../../rtl/or1200'

RTL_PATH='../../rtl'
#
# RTL files (or1200)
#
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_ctrl.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_cpu.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_rf.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_rfram_generic.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_alu.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_lsu.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_reg2mem.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_mem2reg.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_operandmuxes.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_wbmux.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_genpc.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_if.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_freeze.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_sprs.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_top_qmem_only.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_pic.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_tt.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_except.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_amultp2_32x32.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_gmultp2_32x32.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_cfgr.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_mult_mac.v
action vlog $VLOG_OPT0 $VLOG_OPT $RTL_PATH/or1200/or1200_qmem_top_qmem_only.v

action vlog $VLOG_OPT0 $VLOG_OPT ../../model/spram_2048x32.v
action vlog $VLOG_OPT0 $VLOG_OPT ../../testbench/or1200_monitor.v
action vlog $VLOG_OPT0 $VLOG_OPT ../../testbench/tb.v
