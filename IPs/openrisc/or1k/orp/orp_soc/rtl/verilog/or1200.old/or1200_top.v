//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200 Top Level                                            ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  OR1200 Top Level                                            ////
////                                                              ////
////  To Do:                                                      ////
////   - make it smaller and faster                               ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: or1200_top.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.5  2002/02/11 04:33:17  lampret
// Speed optimizations (removed duplicate _cyc_ and _stb_). Fixed D/IMMU cache-inhibit attr.
//
// Revision 1.4  2002/02/01 19:56:55  lampret
// Fixed combinational loops.
//
// Revision 1.3  2002/01/28 01:16:00  lampret
// Changed 'void' nop-ops instead of insn[0] to use insn[16]. Debug unit stalls the tick timer. Prepared new flag generation for add and and insns. Blocked DC/IC while they are turned off. Fixed I/D MMU SPRs layout except WAYs. TODO: smart IC invalidate, l.j 2 and TLB ways.
//
// Revision 1.2  2002/01/18 07:56:00  lampret
// No more low/high priority interrupts (PICPR removed). Added tick timer exception. Added exception prefix (SR[EPH]). Fixed single-step bug whenreading NPC.
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.13  2001/11/23 08:38:51  lampret
// Changed DSR/DRR behavior and exception detection.
//
// Revision 1.12  2001/11/20 00:57:22  lampret
// Fixed width of du_except.
//
// Revision 1.11  2001/11/18 08:36:28  lampret
// For GDB changed single stepping and disabled trap exception.
//
// Revision 1.10  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.9  2001/10/14 13:12:10  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:35  igorm
// no message
//
// Revision 1.4  2001/08/13 03:36:20  lampret
// Added cfg regs. Moved all defines into one defines.v file. More cleanup.
//
// Revision 1.3  2001/08/09 13:39:33  lampret
// Major clean-up.
//
// Revision 1.2  2001/07/22 03:31:54  lampret
// Fixed RAM's oen bug. Cache bypass under development.
//
// Revision 1.1  2001/07/20 00:46:21  lampret
// Development version of RTL. Libraries are missing.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_top(
	// System
	clk_i, rst_i, pic_ints_i, clmode_i,

	// Instruction WISHBONE INTERFACE
	iwb_clk_i, iwb_rst_i, iwb_ack_i, iwb_err_i, iwb_rty_i, iwb_dat_i,
	iwb_cyc_o, iwb_adr_o, iwb_stb_o, iwb_we_o, iwb_sel_o, iwb_cab_o, iwb_dat_o,

	// Data WISHBONE INTERFACE
	dwb_clk_i, dwb_rst_i, dwb_ack_i, dwb_err_i, dwb_rty_i, dwb_dat_i,
	dwb_cyc_o, dwb_adr_o, dwb_stb_o, dwb_we_o, dwb_sel_o, dwb_cab_o, dwb_dat_o,

	// External Debug Interface
	dbg_stall_i, dbg_dat_i, dbg_adr_i, dbg_op_i, dbg_ewt_i,
	dbg_lss_o, dbg_is_o, dbg_wp_o, dbg_bp_o, dbg_dat_o,
	
	// Power Management
	pm_cpustall_i,
	pm_clksd_o, pm_dc_gate_o, pm_ic_gate_o, pm_dmmu_gate_o, 
	pm_immu_gate_o, pm_tt_gate_o, pm_cpu_gate_o, pm_wakeup_o, pm_lvolt_o

);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_OPERAND_WIDTH;
parameter ppic_ints = `OR1200_PIC_INTS;

//
// I/O
//

//
// System
//
input			clk_i;
input			rst_i;
input	[1:0]		clmode_i;	// 00 WB=RISC, 01 WB=RISC/2, 10 N/A, 11 WB=RISC/4
input	[ppic_ints-1:0]	pic_ints_i;

//
// Instruction WISHBONE interface
//
input			iwb_clk_i;	// clock input
input			iwb_rst_i;	// reset input
input			iwb_ack_i;	// normal termination
input			iwb_err_i;	// termination w/ error
input			iwb_rty_i;	// termination w/ retry
input	[dw-1:0]	iwb_dat_i;	// input data bus
output			iwb_cyc_o;	// cycle valid output
output	[aw-1:0]	iwb_adr_o;	// address bus outputs
output			iwb_stb_o;	// strobe output
output			iwb_we_o;	// indicates write transfer
output	[3:0]		iwb_sel_o;	// byte select outputs
output			iwb_cab_o;	// indicates consecutive address burst
output	[dw-1:0]	iwb_dat_o;	// output data bus

//
// Data WISHBONE interface
//
input			dwb_clk_i;	// clock input
input			dwb_rst_i;	// reset input
input			dwb_ack_i;	// normal termination
input			dwb_err_i;	// termination w/ error
input			dwb_rty_i;	// termination w/ retry
input	[dw-1:0]	dwb_dat_i;	// input data bus
output			dwb_cyc_o;	// cycle valid output
output	[aw-1:0]	dwb_adr_o;	// address bus outputs
output			dwb_stb_o;	// strobe output
output			dwb_we_o;	// indicates write transfer
output	[3:0]		dwb_sel_o;	// byte select outputs
output			dwb_cab_o;	// indicates consecutive address burst
output	[dw-1:0]	dwb_dat_o;	// output data bus

//
// External Debug Interface
//
input			dbg_stall_i;	// External Stall Input
input	[dw-1:0]	dbg_dat_i;	// External Data Input
input	[aw-1:0]	dbg_adr_i;	// External Address Input
input	[2:0]		dbg_op_i;	// External Operation Select Input
input			dbg_ewt_i;	// External Watchpoint Trigger Input
output	[3:0]		dbg_lss_o;	// External Load/Store Unit Status
output	[1:0]		dbg_is_o;	// External Insn Fetch Status
output	[10:0]		dbg_wp_o;	// Watchpoints Outputs
output			dbg_bp_o;	// Breakpoint Output
output	[dw-1:0]	dbg_dat_o;	// External Data Output

//
// Power Management
//
input			pm_cpustall_i;
output	[3:0]		pm_clksd_o;
output			pm_dc_gate_o;
output			pm_ic_gate_o;
output			pm_dmmu_gate_o;
output			pm_immu_gate_o;
output			pm_tt_gate_o;
output			pm_cpu_gate_o;
output			pm_wakeup_o;
output			pm_lvolt_o;


//
// Internal wires and regs
//

//
// DC to BIU
//
wire	[dw-1:0]	dcbiu_dat_dc;
wire	[aw-1:0]	dcbiu_adr_dc;
wire			dcbiu_cyc_dc;
wire			dcbiu_stb_dc;
wire			dcbiu_we_dc;
wire	[3:0]		dcbiu_sel_dc;
wire	[3:0]		dcbiu_tag_dc;
wire	[dw-1:0]	dcbiu_dat_biu;
wire			dcbiu_ack_biu;
wire			dcbiu_err_biu;
wire	[3:0]		dcbiu_tag_biu;

//
// IC to BIU
//
wire	[dw-1:0]	icbiu_dat_ic;
wire	[aw-1:0]	icbiu_adr_ic;
wire			icbiu_cyc_ic;
wire			icbiu_stb_ic;
wire			icbiu_we_ic;
wire	[3:0]		icbiu_sel_ic;
wire	[3:0]		icbiu_tag_ic;
wire	[dw-1:0]	icbiu_dat_biu;
wire			icbiu_ack_biu;
wire			icbiu_err_biu;
wire	[3:0]		icbiu_tag_biu;

//
// CPU's SPR access to various RISC units (shared wires)
//
wire			supv;
wire	[aw-1:0]	spr_addr;
wire	[dw-1:0]	spr_dat_cpu;
wire	[31:0]		spr_cs;
wire			spr_we;

//
// DMMU and CPU
//
wire			dmmu_en;
wire	[31:0]		spr_dat_dmmu;

//
// DMMU and DC
//
wire			dcdmmu_err_dc;
wire	[3:0]		dcdmmu_tag_dc;
wire	[aw-1:0]	dcdmmu_adr_dmmu;
wire			dcdmmu_cycstb_dmmu;
wire			dcdmmu_ci_dmmu;

//
// CPU and data memory subsystem
//
wire			dc_en;
wire	[31:0]		dcpu_adr_cpu;
wire			dcpu_we_cpu;
wire	[3:0]		dcpu_sel_cpu;
wire	[3:0]		dcpu_tag_cpu;
wire	[31:0]		dcpu_dat_cpu;
wire	[31:0]		dcpu_dat_dc;
wire			dcpu_ack_dc;
wire			dcpu_rty_dc;
wire			dcpu_err_dmmu;
wire	[3:0]		dcpu_tag_dmmu;

//
// IMMU and CPU
//
wire			immu_en;
wire	[31:0]		spr_dat_immu;

//
// CPU and insn memory subsystem
//
wire			ic_en;
wire	[31:0]		icpu_adr_cpu;
wire			icpu_cycstb_cpu;
wire			icpu_we_cpu;
wire	[3:0]		icpu_sel_cpu;
wire	[3:0]		icpu_tag_cpu;
wire	[31:0]		icpu_dat_ic;
wire			icpu_ack_ic;
wire	[31:0]		icpu_adr_immu;
wire			icpu_err_immu;
wire	[3:0]		icpu_tag_immu;

//
// IMMU and IC
//
wire	[aw-1:0]	icimmu_adr_immu;
wire			icimmu_rty_ic;
wire			icimmu_err_ic;
wire	[3:0]		icimmu_tag_ic;
wire			icimmu_cycstb_immu;
wire			icimmu_ci_immu;

//
// Connection between CPU and PIC
//
wire	[dw-1:0]	spr_dat_pic;
wire			pic_wakeup;
wire			sig_int;

//
// Connection between CPU and PM
//
wire	[dw-1:0]	spr_dat_pm;

//
// CPU and TT
//
wire	[dw-1:0]	spr_dat_tt;
wire			sig_tick;

//
// Debug port and caches/MMUs
//
wire	[dw-1:0]	spr_dat_du;
wire			du_stall;
wire	[dw-1:0]	du_addr;
wire	[dw-1:0]	du_dat_du;
wire			du_read;
wire			du_write;
wire	[12:0]		du_except;
wire	[`OR1200_DU_DSR_WIDTH-1:0]     du_dsr;
wire	[dw-1:0]	du_dat_cpu;

wire			ex_freeze;
wire	[31:0]		ex_insn;
wire	[`OR1200_BRANCHOP_WIDTH-1:0]	branch_op;

//
// Instantiation of Instruction WISHBONE BIU
//
or1200_wb_biu iwb_biu(
	// RISC clk, rst and clock control
	.clk(clk_i),
	.rst(rst_i),
	.clmode(clmode_i),

	// WISHBONE interface
	.wb_clk_i(iwb_clk_i),
	.wb_rst_i(iwb_rst_i),
	.wb_ack_i(iwb_ack_i),
	.wb_err_i(iwb_err_i),
	.wb_rty_i(iwb_rty_i),
	.wb_dat_i(iwb_dat_i),
	.wb_cyc_o(iwb_cyc_o),
	.wb_adr_o(iwb_adr_o),
	.wb_stb_o(iwb_stb_o),
	.wb_we_o(iwb_we_o),
	.wb_sel_o(iwb_sel_o),
	.wb_cab_o(iwb_cab_o),
	.wb_dat_o(iwb_dat_o),

	// Internal RISC bus
	.biu_dat_i(icbiu_dat_ic),
	.biu_adr_i(icbiu_adr_ic),
	.biu_cyc_i(icbiu_cyc_ic),
	.biu_stb_i(icbiu_stb_ic),
	.biu_we_i(icbiu_we_ic),
	.biu_sel_i(icbiu_sel_ic),
	.biu_cab_i(icbiu_cab_ic),
	.biu_dat_o(icbiu_dat_biu),
	.biu_ack_o(icbiu_ack_biu),
	.biu_err_o(icbiu_err_biu)
);

//
// Instantiation of Data WISHBONE BIU
//
or1200_wb_biu dwb_biu(
	// RISC clk, rst and clock control
	.clk(clk_i),
	.rst(rst_i),
	.clmode(clmode_i),

	// WISHBONE interface
	.wb_clk_i(dwb_clk_i),
	.wb_rst_i(dwb_rst_i),
	.wb_ack_i(dwb_ack_i),
	.wb_err_i(dwb_err_i),
	.wb_rty_i(dwb_rty_i),
	.wb_dat_i(dwb_dat_i),
	.wb_cyc_o(dwb_cyc_o),
	.wb_adr_o(dwb_adr_o),
	.wb_stb_o(dwb_stb_o),
	.wb_we_o(dwb_we_o),
	.wb_sel_o(dwb_sel_o),
	.wb_cab_o(dwb_cab_o),
	.wb_dat_o(dwb_dat_o),

	// Internal RISC bus
	.biu_dat_i(dcbiu_dat_dc),
	.biu_adr_i(dcbiu_adr_dc),
	.biu_cyc_i(dcbiu_cyc_dc),
	.biu_stb_i(dcbiu_stb_dc),
	.biu_we_i(dcbiu_we_dc),
	.biu_sel_i(dcbiu_sel_dc),
	.biu_cab_i(dcbiu_cab_dc),
	.biu_dat_o(dcbiu_dat_biu),
	.biu_ack_o(dcbiu_ack_biu),
	.biu_err_o(dcbiu_err_biu)
);

//
// Instantiation of IMMU
//
or1200_immu_top or1200_immu_top(
	// Rst and clk
	.clk(clk_i),
	.rst(rst_i),

	// CPU i/f
	.ic_en(ic_en),
	.immu_en(immu_en),
	.supv(supv),
	.icpu_adr_i(icpu_adr_cpu),
	.icpu_cycstb_i(icpu_cycstb_cpu),
	.icpu_adr_o(icpu_adr_immu),
	.icpu_tag_o(icpu_tag_immu),
	.icpu_rty_o(icpu_rty_immu),
	.icpu_err_o(icpu_err_immu),

	// SPR access
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_IMMU]),
	.spr_write(spr_we),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_cpu),
	.spr_dat_o(spr_dat_immu),

	// IC i/f
	.icimmu_rty_i(icimmu_rty_ic),
	.icimmu_err_i(icimmu_err_ic),
	.icimmu_tag_i(icimmu_tag_ic),
	.icimmu_adr_o(icimmu_adr_immu),
	.icimmu_cycstb_o(icimmu_cycstb_immu),
	.icimmu_ci_o(icimmu_ci_immu)
);

//
// Instantiation of Instruction Cache
//
or1200_ic_top or1200_ic_top(
	.clk(clk_i),
	.rst(rst_i),

	// IC and CPU/IMMU
	.ic_en(ic_en),
	.icimmu_adr_i(icimmu_adr_immu),
	.icimmu_cycstb_i(icimmu_cycstb_immu),
	.icimmu_ci_i(icimmu_ci_immu),
	.icpu_we_i(icpu_we_cpu),
	.icpu_sel_i(icpu_sel_cpu),
	.icpu_tag_i(icpu_tag_cpu),
	.icpu_dat_o(icpu_dat_ic),
	.icpu_ack_o(icpu_ack_ic),
	.icimmu_rty_o(icimmu_rty_ic),
	.icimmu_err_o(icimmu_err_ic),
	.icimmu_tag_o(icimmu_tag_ic),

	// SPR access
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_IC]),
	.spr_write(spr_we),
	.spr_dat_i(spr_dat_cpu),

	// IC and BIU
	.icbiu_dat_o(icbiu_dat_ic),
	.icbiu_adr_o(icbiu_adr_ic),
	.icbiu_cyc_o(icbiu_cyc_ic),
	.icbiu_stb_o(icbiu_stb_ic),
	.icbiu_we_o(icbiu_we_ic),
	.icbiu_sel_o(icbiu_sel_ic),
	.icbiu_cab_o(icbiu_cab_ic),
	.icbiu_dat_i(icbiu_dat_biu),
	.icbiu_ack_i(icbiu_ack_biu),
	.icbiu_err_i(icbiu_err_biu)
);

//
// Instantiation of Instruction Cache
//
or1200_cpu or1200_cpu(
	.clk(clk_i),
	.rst(rst_i),

	// Connection IC and IFETCHER inside CPU
	.ic_en(ic_en),
	.icpu_adr_o(icpu_adr_cpu),
	.icpu_cycstb_o(icpu_cycstb_cpu),
	.icpu_we_o(icpu_we_cpu),
	.icpu_sel_o(icpu_sel_cpu),
	.icpu_tag_o(icpu_tag_cpu),
	.icpu_dat_i(icpu_dat_ic),
	.icpu_ack_i(icpu_ack_ic),
	.icpu_rty_i(icpu_rty_immu),
	.icpu_adr_i(icpu_adr_immu),
	.icpu_err_i(icpu_err_immu),
	.icpu_tag_i(icpu_tag_immu),

	// Connection CPU to external Debug port
	.ex_freeze(ex_freeze),
	.ex_insn(ex_insn),
	.branch_op(branch_op),
	.du_stall(du_stall),
	.du_addr(du_addr),
	.du_dat_du(du_dat_du),
	.du_read(du_read),
	.du_write(du_write),
	.du_dsr(du_dsr),
	.du_except(du_except),
	.du_dat_cpu(du_dat_cpu),

	// Connection IMMU and CPU internally
	.immu_en(immu_en),

	// Connection DC and CPU
	.dc_en(dc_en),
	.dcpu_adr_o(dcpu_adr_cpu),
	.dcpu_cycstb_o(dcpu_cycstb_cpu),
	.dcpu_we_o(dcpu_we_cpu),
	.dcpu_sel_o(dcpu_sel_cpu),
	.dcpu_tag_o(dcpu_tag_cpu),
	.dcpu_dat_o(dcpu_dat_cpu),
        .dcpu_dat_i(dcpu_dat_dc),
	.dcpu_ack_i(dcpu_ack_dc),
	.dcpu_rty_i(dcpu_rty_dc),
	.dcpu_err_i(dcpu_err_dmmu),
	.dcpu_tag_i(dcpu_tag_dmmu),

	// Connection DMMU and CPU internally
	.dmmu_en(dmmu_en),

	// Connection PIC and CPU's EXCEPT
	.sig_int(sig_int),
	.sig_tick(sig_tick),

	// SPRs
	.supv(supv),
	.spr_addr(spr_addr),
	.spr_dat_cpu(spr_dat_cpu),
	.spr_dat_pic(spr_dat_pic),
	.spr_dat_tt(spr_dat_tt),
	.spr_dat_pm(spr_dat_pm),
	.spr_dat_dmmu(spr_dat_dmmu),
	.spr_dat_immu(spr_dat_immu),
	.spr_dat_du(spr_dat_du),
	.spr_cs(spr_cs),
	.spr_we(spr_we)
);

//
// Instantiation of DMMU
//
or1200_dmmu_top or1200_dmmu_top(
	// Rst and clk
	.clk(clk_i),
	.rst(rst_i),

	// CPU i/f
	.dc_en(dc_en),
	.dmmu_en(dmmu_en),
	.supv(supv),
	.dcpu_adr_i(dcpu_adr_cpu),
	.dcpu_cycstb_i(dcpu_cycstb_cpu),
	.dcpu_we_i(dcpu_we_cpu),
	.dcpu_tag_o(dcpu_tag_dmmu),
	.dcpu_err_o(dcpu_err_dmmu),

	// SPR access
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_DMMU]),
	.spr_write(spr_we),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_cpu),
	.spr_dat_o(spr_dat_dmmu),

	// DC i/f
	.dcdmmu_err_i(dcdmmu_err_dc),
	.dcdmmu_tag_i(dcdmmu_tag_dc),
	.dcdmmu_adr_o(dcdmmu_adr_dmmu),
	.dcdmmu_cycstb_o(dcdmmu_cycstb_dmmu),
	.dcdmmu_ci_o(dcdmmu_ci_dmmu)
);

//
// Instantiation of Data Cache
//
or1200_dc_top or1200_dc_top(
	.clk(clk_i),
	.rst(rst_i),

	// DC and CPU/DMMU
	.dc_en(dc_en),
	.dcdmmu_adr_i(dcdmmu_adr_dmmu),
	.dcdmmu_cycstb_i(dcdmmu_cycstb_dmmu),
	.dcdmmu_ci_i(dcdmmu_ci_dmmu),
	.dcpu_we_i(dcpu_we_cpu),
	.dcpu_sel_i(dcpu_sel_cpu),
	.dcpu_tag_i(dcpu_tag_cpu),
	.dcpu_dat_i(dcpu_dat_cpu),
	.dcpu_dat_o(dcpu_dat_dc),
	.dcpu_ack_o(dcpu_ack_dc),
	.dcpu_rty_o(dcpu_rty_dc),
	.dcdmmu_err_o(dcdmmu_err_dc),
	.dcdmmu_tag_o(dcdmmu_tag_dc),

	// SPR access
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_DC]),
	.spr_write(spr_we),
	.spr_dat_i(spr_dat_cpu),

	// DC and BIU
	.dcbiu_dat_o(dcbiu_dat_dc),
	.dcbiu_adr_o(dcbiu_adr_dc),
	.dcbiu_cyc_o(dcbiu_cyc_dc),
	.dcbiu_stb_o(dcbiu_stb_dc),
	.dcbiu_we_o(dcbiu_we_dc),
	.dcbiu_sel_o(dcbiu_sel_dc),
	.dcbiu_cab_o(dcbiu_cab_dc),
	.dcbiu_dat_i(dcbiu_dat_biu),
	.dcbiu_ack_i(dcbiu_ack_biu),
	.dcbiu_err_i(dcbiu_err_biu)
);

//
// Instantiation of Debug Unit
//
or1200_du or1200_du(
	// RISC Internal Interface
	.clk(clk_i),
	.rst(rst_i),
	.dcpu_cycstb_i(dcpu_cycstb_cpu),
	.dcpu_we_i(dcpu_we_cpu),
	.icpu_cycstb_i(icpu_cycstb_cpu),
	.ex_freeze(ex_freeze),
	.branch_op(branch_op),
	.ex_insn(ex_insn),
	.du_dsr(du_dsr),

	// DU's access to SPR unit
	.du_stall(du_stall),
	.du_addr(du_addr),
	.du_dat_i(du_dat_cpu),
	.du_dat_o(du_dat_du),
	.du_read(du_read),
	.du_write(du_write),
	.du_except(du_except),

	// Access to DU's SPRs
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_DU]),
	.spr_write(spr_we),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_cpu),
	.spr_dat_o(spr_dat_du),

	// External Debug Interface
	.dbg_stall_i(dbg_stall_i),
	.dbg_dat_i(dbg_dat_i),
	.dbg_adr_i(dbg_adr_i),
	.dbg_op_i(dbg_op_i),
	.dbg_ewt_i(dbg_ewt_i),
	.dbg_lss_o(dbg_lss_o),
	.dbg_is_o(dbg_is_o),
	.dbg_wp_o(dbg_wp_o),
	.dbg_bp_o(dbg_bp_o),
	.dbg_dat_o(dbg_dat_o)
);

//
// Programmable interrupt controller
//
or1200_pic or1200_pic(
	// RISC Internal Interface
	.clk(clk_i),
	.rst(rst_i),
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_PIC]),
	.spr_write(spr_we),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_cpu),
	.spr_dat_o(spr_dat_pic),
	.pic_wakeup(pic_wakeup),
	.int(sig_int), 

	// PIC Interface
	.pic_int(pic_ints_i)
);

//
// Instantiation of Tick timer
//
or1200_tt or1200_tt(
	// RISC Internal Interface
	.clk(clk_i),
	.rst(rst_i),
	.du_stall(du_stall),
	.spr_cs(spr_cs[`OR1200_SPR_GROUP_TT]),
	.spr_write(spr_we),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_cpu),
	.spr_dat_o(spr_dat_tt),
	.int(sig_tick)
);

//
// Instantiation of Power Management
//
or1200_pm or1200_pm(
	// RISC Internal Interface
	.clk(clk_i),
	.rst(rst_i),
	.pic_wakeup(pic_wakeup),
	.spr_write(spr_we),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_cpu),
	.spr_dat_o(spr_dat_pm),

	// Power Management Interface
	.pm_cpustall(pm_cpustall_i),
	.pm_clksd(pm_clksd_o),
	.pm_dc_gate(pm_dc_gate_o),
	.pm_ic_gate(pm_ic_gate_o),
	.pm_dmmu_gate(pm_dmmu_gate_o),
	.pm_immu_gate(pm_immu_gate_o),
	.pm_tt_gate(pm_tt_gate_o),
	.pm_cpu_gate(pm_cpu_gate_o),
	.pm_wakeup(pm_wakeup_o),
	.pm_lvolt(pm_lvolt_o)
);


endmodule
