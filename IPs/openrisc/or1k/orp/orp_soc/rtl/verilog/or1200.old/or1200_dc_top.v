//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's Data Cache top level                               ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Instantiation of all DC blocks.                             ////
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
// $Log: or1200_dc_top.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.4  2002/02/11 04:33:17  lampret
// Speed optimizations (removed duplicate _cyc_ and _stb_). Fixed D/IMMU cache-inhibit attr.
//
// Revision 1.3  2002/01/28 01:16:00  lampret
// Changed 'void' nop-ops instead of insn[0] to use insn[16]. Debug unit stalls the tick timer. Prepared new flag generation for add and and insns. Blocked DC/IC while they are turned off. Fixed I/D MMU SPRs layout except WAYs. TODO: smart IC invalidate, l.j 2 and TLB ways.
//
// Revision 1.2  2002/01/14 06:18:22  lampret
// Fixed mem2reg bug in FAST implementation. Updated debug unit to work with new genpc/if.
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.10  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.9  2001/10/14 13:12:09  lampret
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
// Revision 1.2  2001/07/22 03:31:53  lampret
// Fixed RAM's oen bug. Cache bypass under development.
//
// Revision 1.1  2001/07/20 00:46:03  lampret
// Development version of RTL. Libraries are missing.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

//
// Data cache
//
module or1200_dc_top(
	// Rst, clk and clock control
	clk, rst,

	// External i/f
	dcbiu_dat_o, dcbiu_adr_o, dcbiu_cyc_o, dcbiu_stb_o, dcbiu_we_o, dcbiu_sel_o, dcbiu_cab_o,
	dcbiu_dat_i, dcbiu_ack_i, dcbiu_err_i,

	// Internal i/f
	dc_en,
	dcdmmu_adr_i, dcdmmu_cycstb_i, dcdmmu_ci_i,
	dcpu_we_i, dcpu_sel_i, dcpu_tag_i, dcpu_dat_i,
	dcpu_dat_o, dcpu_ack_o, dcpu_rty_o, dcdmmu_err_o, dcdmmu_tag_o,

	// SPRs
	spr_cs, spr_write, spr_dat_i
);

parameter dw = `OR1200_OPERAND_WIDTH;

//
// I/O
//

//
// Clock and reset
//
input				clk;
input				rst;

//
// External I/F
//
output	[dw-1:0]		dcbiu_dat_o;
output	[31:0]			dcbiu_adr_o;
output				dcbiu_cyc_o;
output				dcbiu_stb_o;
output				dcbiu_we_o;
output	[3:0]			dcbiu_sel_o;
output				dcbiu_cab_o;
input	[dw-1:0]		dcbiu_dat_i;
input				dcbiu_ack_i;
input				dcbiu_err_i;

//
// Internal I/F
//
input				dc_en;
input	[31:0]			dcdmmu_adr_i;
input				dcdmmu_cycstb_i;
input				dcdmmu_ci_i;
input				dcpu_we_i;
input	[3:0]			dcpu_sel_i;
input	[3:0]			dcpu_tag_i;
input	[dw-1:0]		dcpu_dat_i;
output	[dw-1:0]		dcpu_dat_o;
output				dcpu_ack_o;
output				dcpu_rty_o;
output				dcdmmu_err_o;
output	[3:0]			dcdmmu_tag_o;

//
// SPR access
//
input				spr_cs;
input				spr_write;
input	[31:0]			spr_dat_i;

//
// Internal wires and regs
//
wire				tag_v;
wire	[`OR1200_DCTAG_W-2:0]	tag;
wire	[dw-1:0]		to_dcram;
wire	[dw-1:0]		from_dcram;
wire	[31:0]			saved_addr;
wire	[3:0]			dcram_we;
wire				dctag_we;
wire	[31:0]			dc_addr;
wire				dcfsm_biu_read;
wire				dcfsm_biu_write;
reg				tagcomp_miss;
wire	[`OR1200_DCINDXH:`OR1200_DCLS]	dctag_addr;
wire				dctag_en;
wire				dctag_v; 
wire				dc_inv;
wire				dcfsm_first_hit_ack;
wire				dcfsm_first_miss_ack;
wire				dcfsm_first_miss_err;
wire				dcfsm_burst;
wire				dcfsm_tag_we;

//
// Simple assignments
//
assign dcbiu_adr_o = dc_addr;
assign dc_inv = spr_cs & spr_write;
assign dctag_we = dcfsm_tag_we | dc_inv;
assign dctag_addr = dc_inv ? spr_dat_i[`OR1200_DCINDXH:`OR1200_DCLS] : dc_addr[`OR1200_DCINDXH:`OR1200_DCLS];
assign dctag_en = dc_inv | dc_en;
assign dctag_v = ~dc_inv;

//
// Data to BIU is from DCRAM when DC is enabled or from LSU when
// DC is disabled
//
assign dcbiu_dat_o = dcpu_dat_i;

//
// Bypases of the DC when DC is disabled
//
assign dcbiu_cyc_o = (dc_en) ? dcfsm_biu_read | dcfsm_biu_write : dcdmmu_cycstb_i;
assign dcbiu_stb_o = (dc_en) ? dcfsm_biu_read | dcfsm_biu_write : dcdmmu_cycstb_i;
assign dcbiu_we_o = (dc_en) ? dcfsm_biu_write : dcpu_we_i;
assign dcbiu_sel_o = (dc_en & dcfsm_biu_read & !dcfsm_biu_write & !dcdmmu_ci_i) ? 4'b1111 : dcpu_sel_i;
assign dcbiu_cab_o = (dc_en) ? dcfsm_burst : 1'b0;
assign dcpu_rty_o = ~dcpu_ack_o;
assign dcdmmu_tag_o = dcdmmu_err_o ? `OR1200_DTAG_BE : dcpu_tag_i;

//
// DC/LSU normal and error termination
//
assign dcpu_ack_o = dc_en ? dcfsm_first_hit_ack | dcfsm_first_miss_ack : dcbiu_ack_i;
assign dcdmmu_err_o = dc_en ? dcfsm_first_miss_err : dcbiu_err_i;

//
// Select between claddr generated by DC FSM and addr[3:2] generated by LSU
//
//assign dc_addr = (dcfsm_biu_read | dcfsm_biu_write) ? saved_addr : dcdmmu_adr_i;

//
// Select between input data generated by LSU or by BIU
//
assign to_dcram = (dcfsm_biu_read) ? dcbiu_dat_i : dcpu_dat_i;

//
// Select between data generated by DCRAM or passed by BIU
//
assign dcpu_dat_o = dcfsm_first_miss_ack | !dc_en ? dcbiu_dat_i : from_dcram;

//
// Tag comparison
//
always @(tag or saved_addr or tag_v) begin
	if ((tag != saved_addr[31:`OR1200_DCTAGL]) || !tag_v)
		tagcomp_miss = 1'b1;
	else
		tagcomp_miss = 1'b0;
end

//
// Instantiation of DC Finite State Machine
//
or1200_dc_fsm or1200_dc_fsm(
	.clk(clk),
	.rst(rst),
	.dc_en(dc_en),
	.dcdmmu_cycstb_i(dcdmmu_cycstb_i),
	.dcdmmu_ci_i(dcdmmu_ci_i),
	.dcpu_we_i(dcpu_we_i),
	.dcpu_sel_i(dcpu_sel_i),
	.tagcomp_miss(tagcomp_miss),
	.biudata_valid(dcbiu_ack_i),
	.biudata_error(dcbiu_err_i),
	.start_addr(dcdmmu_adr_i),
	.saved_addr(saved_addr),
	.dcram_we(dcram_we),
	.biu_read(dcfsm_biu_read),
	.biu_write(dcfsm_biu_write),
	.first_hit_ack(dcfsm_first_hit_ack),
	.first_miss_ack(dcfsm_first_miss_ack),
	.first_miss_err(dcfsm_first_miss_err),
	.burst(dcfsm_burst),
	.tag_we(dcfsm_tag_we),
	.dc_addr(dc_addr)
);

//
// Instantiation of DC main memory
//
or1200_dc_ram or1200_dc_ram(
	.clk(clk),
	.rst(rst),
	.addr(dc_addr[`OR1200_DCINDXH:2]),
	.en(dc_en),
	.we(dcram_we),
	.datain(to_dcram),
	.dataout(from_dcram)
);

//
// Instantiation of DC TAG memory
//
or1200_dc_tag or1200_dc_tag(
	.clk(clk),
	.rst(rst),
	.addr(dctag_addr),
	.en(dctag_en),
	.we(dctag_we),
	.datain({dc_addr[31:`OR1200_DCTAGL], dctag_v}),
	.tag_v(tag_v),
	.tag(tag)
);

endmodule
