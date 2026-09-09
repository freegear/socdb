#! /bin/sh
action()
{
  $* || exit 1
}

if [ -e work ]; then
	rm -fr work
fi
vlib work

RTL_PATH=../rtl
# CPU
action vcom $RTL_PATH/Tarm/core/alu.vhd
action vcom $RTL_PATH/Tarm/core/clz_unit.vhd
action vcom $RTL_PATH/Tarm/core/cond_check.vhd
action vcom $RTL_PATH/Tarm/core/cpsr_update.vhd
action vcom $RTL_PATH/Tarm/core/data_filter.vhd
action vcom $RTL_PATH/Tarm/core/dmem_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/dmiu.vhd
action vcom $RTL_PATH/Tarm/core/dmou.vhd
action vcom $RTL_PATH/Tarm/core/ff1_32.vhd
action vcom $RTL_PATH/Tarm/core/ff1_4.vhd
action vcom $RTL_PATH/Tarm/core/ff4_32.vhd
action vcom $RTL_PATH/Tarm/core/ff_wb_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/ff_x1_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/ff_x2_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/ff_x2b_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/forward_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/greg.vhd
action vcom $RTL_PATH/Tarm/core/if_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/inst_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/inv1.vhd
action vcom $RTL_PATH/Tarm/core/fadd.vhd
action vcom $RTL_PATH/Tarm/core/csa.vhd
action vcom $RTL_PATH/Tarm/core/mbe.vhd
action vcom $RTL_PATH/Tarm/core/mul.vhd
action vcom $RTL_PATH/Tarm/core/mux2_32.vhd
action vcom $RTL_PATH/Tarm/core/mux2_4.vhd
action vcom $RTL_PATH/Tarm/core/mux3_32.vhd
action vcom $RTL_PATH/Tarm/core/mux3_4.vhd
action vcom $RTL_PATH/Tarm/core/mux4_32.vhd
action vcom $RTL_PATH/Tarm/core/op_filter.vhd
action vcom $RTL_PATH/Tarm/core/pass_wb_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/pass_wb_data.vhd
action vcom $RTL_PATH/Tarm/core/psr.vhd
action vcom $RTL_PATH/Tarm/core/reg_conv.vhd
action vcom $RTL_PATH/Tarm/core/shift.vhd
action vcom $RTL_PATH/Tarm/core/stall_flush_ctrl.vhd
action vcom $RTL_PATH/Tarm/core/wr_backup.vhd
action vcom $RTL_PATH/Tarm/core/toyarm.vhd

action vcom $RTL_PATH/Tarm/cache/cachepkg.vhd
action vcom $RTL_PATH/Tarm/cache/cachereg.vhd
action vcom $RTL_PATH/Tarm/cache/cacheipu.vhd
action vcom $RTL_PATH/Tarm/cache/cachedpu.vhd
action vcom $RTL_PATH/Tarm/cache/cacheic.vhd
action vcom $RTL_PATH/Tarm/cache/cachedc.vhd
action vcom $RTL_PATH/Tarm/cache/cachewb.vhd
action vcom $RTL_PATH/Tarm/cache/cacheahb.vhd
action vcom $RTL_PATH/Tarm/cache/cachectl.vhd
action vcom $RTL_PATH/Tarm/cache/sp128x22m4.vhd
action vcom $RTL_PATH/Tarm/cache/sp128x23m4.vhd
action vcom $RTL_PATH/Tarm/cache/sp512x32m4.vhd
action vcom $RTL_PATH/Tarm/cache/cachemem.vhd

action vcom $RTL_PATH/Tarm/cpu.vhd
action vlog $RTL_PATH/Tarm/tarm_axi.v
action vlog $RTL_PATH/Tarm/tarm_axi_fastclk.v

