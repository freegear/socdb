#! /bin/sh
action()
{
  $* || exit 1
}

RTL_PATH=../../rtl
VLOG_OPT=+incdir+${RTL_PATH}/or1200

# AHB BUS
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_ahb_biu.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_iahb_biu.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_ctrl.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_cpu_ahb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_rf.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_rfram_generic.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_alu.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_lsu_ahb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_operandmuxes.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_wbmux.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_genpc.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_if.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_freeze.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_sprs.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_top_ahb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_pic.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_pm.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_tt.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_except.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dc_top_ahb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dc_fsm.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_reg2mem.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_mem2reg.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dc_tag.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dc_ram.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_ic_top.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_ic_fsm.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_ic_tag.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_ic_ram.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_immu_top.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_immu_tlb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dmmu_top.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dmmu_tlb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_amultp2_32x32.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_gmultp2_32x32.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_cfgr.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_du.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_sb_ahb.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_sb_fifo.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_mult_mac.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_qmem_top.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_dpram_32x32.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_2048x32.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_2048x32_bw.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_2048x8.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_512x20.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_256x21.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_1024x8.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_1024x32.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_1024x32_bw.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_64x14.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_64x22.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_spram_64x24.v
action vlog $VLOG_OPT $RTL_PATH/or1200/or1200_xcv_ram32x8d.v



