//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's Instruction TLB                                    ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Instantiation of ITLB.                                      ////
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
// $Log: or1200_immu_tlb.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.3  2002/02/11 04:33:17  lampret
// Speed optimizations (removed duplicate _cyc_ and _stb_). Fixed D/IMMU cache-inhibit attr.
//
// Revision 1.2  2002/01/28 01:16:00  lampret
// Changed 'void' nop-ops instead of insn[0] to use insn[16]. Debug unit stalls the tick timer. Prepared new flag generation for add and and insns. Blocked DC/IC while they are turned off. Fixed I/D MMU SPRs layout except WAYs. TODO: smart IC invalidate, l.j 2 and TLB ways.
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.8  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.7  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:36  igorm
// no message
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

//
// Insn TLB
//

module or1200_immu_tlb(
	// Rst and clk
	clk, rst,

	// I/F for translation
	tlb_en, vaddr, hit, ppn, uxe, sxe, ci, 

	// SPR access
	spr_cs, spr_write, spr_addr, spr_dat_i, spr_dat_o
);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_OPERAND_WIDTH;

//
// I/O
//

//
// Clock and reset
//
input				clk;
input				rst;

//
// I/F for translation
//
input				tlb_en;
input	[aw-1:0]		vaddr;
output				hit;
output	[31:`OR1200_IMMU_PS]	ppn;
output				uxe;
output				sxe;
output				ci;

//
// SPR access
//
input				spr_cs;
input				spr_write;
input	[31:0]			spr_addr;
input	[31:0]			spr_dat_i;
output	[31:0]			spr_dat_o;

//
// Internal wires and regs
//
wire	[`OR1200_ITLB_TAG]	vpn;
wire				v;
wire	[`OR1200_ITLB_INDXW-1:0]	tlb_index;
wire				tlb_mr_en;
wire				tlb_mr_we;
wire	[`OR1200_ITLBMRW-1:0]	tlb_mr_ram_in;
wire	[`OR1200_ITLBMRW-1:0]	tlb_mr_ram_out;
wire				tlb_tr_en;
wire				tlb_tr_we;
wire	[`OR1200_ITLBTRW-1:0]	tlb_tr_ram_in;
wire	[`OR1200_ITLBTRW-1:0]	tlb_tr_ram_out;

//
// Implemented bits inside match and translate registers
//
// itlbwYmrX: vpn 31-19  v 0
// itlbwYtrX: ppn 31-13  uxe 7  sxe 6
//
// itlb memory width:
// 19 bits for ppn
// 13 bits for vpn
// 1 bit for valid
// 2 bits for protection
// 1 bit for cache inhibit

//
// Enable for Match registers
//
assign tlb_mr_en = tlb_en | (spr_cs & !spr_addr[`OR1200_ITLB_TM_ADDR]);

//
// Write enable for Match registers
//
assign tlb_mr_we = spr_cs & spr_write & !spr_addr[`OR1200_ITLB_TM_ADDR];

//
// Enable for Translate registers
//
assign tlb_tr_en = tlb_en | (spr_cs & spr_addr[`OR1200_ITLB_TM_ADDR]);

//
// Write enable for Translate registers
//
assign tlb_tr_we = spr_cs & spr_write & spr_addr[`OR1200_ITLB_TM_ADDR];

//
// Output to SPRS unit
//
assign spr_dat_o = (spr_cs & !spr_write & !spr_addr[`OR1200_ITLB_TM_ADDR]) ?
			{vpn, tlb_index & {`OR1200_ITLB_INDXW{v}}, {`OR1200_ITLB_TAGW-7{1'b0}}, 1'b0, 5'b00000, v} :
		(spr_cs & !spr_write & spr_addr[`OR1200_ITLB_TM_ADDR]) ?
			{ppn, {`OR1200_IMMU_PS-8{1'b0}}, uxe, sxe, {4{1'b0}}, ci, 1'b0} :
			32'h00000000;

//
// Assign outputs from Match registers
//
assign {vpn, v} = tlb_mr_ram_out;

//
// Assign to Match registers inputs
//
assign tlb_mr_ram_in = {spr_dat_i[`OR1200_ITLB_TAG], spr_dat_i[`OR1200_ITLBMR_V_BITS]};

//
// Assign outputs from Translate registers
//
assign {ppn, uxe, sxe, ci} = tlb_tr_ram_out;

//
// Assign to Translate registers inputs
//
assign tlb_tr_ram_in = {spr_dat_i[31:`OR1200_IMMU_PS],
			spr_dat_i[`OR1200_ITLBTR_UXE_BITS],
			spr_dat_i[`OR1200_ITLBTR_SXE_BITS],
			spr_dat_i[`OR1200_ITLBTR_CI_BITS]};

//
// Generate hit
//
assign hit = (vpn == vaddr[`OR1200_ITLB_TAG]) & v;

//
// TLB index is normally vaddr[18:13]. If it is SPR access then index is
// spr_addr[5:0].
//
assign tlb_index = spr_cs ? spr_addr[`OR1200_ITLB_INDXW-1:0] : vaddr[`OR1200_ITLB_INDX];

//
// Instantiation of ITLB Match Registers
//
or1200_spram_64x14 itlb_mr_ram(
	.clk(clk),
	.rst(rst),
	.ce(tlb_mr_en),
	.we(tlb_mr_we),
	.oe(1'b1),
	.addr(tlb_index),
	.di(tlb_mr_ram_in),
	.do(tlb_mr_ram_out)
);

//
// Instantiation of ITLB Translate Registers
//
or1200_spram_64x22 itlb_tr_ram(
	.clk(clk),
	.rst(rst),
	.ce(tlb_tr_en),
	.we(tlb_tr_we),
	.oe(1'b1),
	.addr(tlb_index),
	.di(tlb_tr_ram_in),
	.do(tlb_tr_ram_out)
);

endmodule
