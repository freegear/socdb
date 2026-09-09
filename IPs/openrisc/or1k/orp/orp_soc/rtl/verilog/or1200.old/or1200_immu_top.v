//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's Instruction MMU top level                          ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Instantiation of all IMMU blocks.                           ////
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
// $Log: or1200_immu_top.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.5  2002/02/11 04:33:17  lampret
// Speed optimizations (removed duplicate _cyc_ and _stb_). Fixed D/IMMU cache-inhibit attr.
//
// Revision 1.4  2002/02/01 19:56:54  lampret
// Fixed combinational loops.
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
// Revision 1.6  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from dc.v and ic.v. Fixed CR+LF.
//
// Revision 1.5  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:36  igorm
// no message
//
// Revision 1.1  2001/08/17 08:03:35  lampret
// *** empty log message ***
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
// Insn MMU
//

module or1200_immu_top(
	// Rst and clk
	clk, rst,

	// CPU i/f
	ic_en, immu_en, supv, icpu_adr_i, icpu_cycstb_i,
	icpu_adr_o, icpu_tag_o, icpu_rty_o, icpu_err_o,

	// SPR access
	spr_cs, spr_write, spr_addr, spr_dat_i, spr_dat_o,

	// IC i/f
	icimmu_rty_i, icimmu_err_i, icimmu_tag_i, icimmu_adr_o, icimmu_cycstb_o, icimmu_ci_o
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
// CPU I/F
//
input				ic_en;
input				immu_en;
input				supv;
input	[aw-1:0]		icpu_adr_i;
input				icpu_cycstb_i;
output	[aw-1:0]		icpu_adr_o;
output	[3:0]			icpu_tag_o;
output				icpu_rty_o;
output				icpu_err_o;

//
// SPR access
//
input				spr_cs;
input				spr_write;
input	[aw-1:0]		spr_addr;
input	[31:0]			spr_dat_i;
output	[31:0]			spr_dat_o;

//
// IC I/F
//
input				icimmu_rty_i;
input				icimmu_err_i;
input	[3:0]			icimmu_tag_i;
output	[aw-1:0]		icimmu_adr_o;
output				icimmu_cycstb_o;
output				icimmu_ci_o;

//
// Internal wires and regs
//
wire				itlb_spr_access;
wire	[31:`OR1200_IMMU_PS]	itlb_ppn;
wire				itlb_hit;
wire				itlb_uxe;
wire				itlb_sxe;
wire	[31:0]			itlb_dat_o;
wire				itlb_en;
wire				itlb_ci;
wire				itlb_done;
wire				fault;
wire				miss;
reg	[31:0]			icpu_adr_o;
reg				itlb_en_r;
reg	[31:`OR1200_IMMU_PS]	icpu_vpn_r;

//
// Implemented bits inside match and translate registers
//
// itlbwYmrX: vpn 31-10  v 0
// itlbwYtrX: ppn 31-10  uxe 7  sxe 6
//
// itlb memory width:
// 19 bits for ppn
// 13 bits for vpn
// 1 bit for valid
// 2 bits for protection
// 1 bit for cache inhibit

//
// icpu_adr_o
//
`ifdef OR1200_REGISTERED_OUTPUTS
always @(posedge rst or posedge clk)
	if (rst)
		icpu_adr_o <= #1 32'h0000_0100;
	else
		icpu_adr_o <= #1 icpu_adr_i;
`else
Unsupported !!!
`endif

`ifdef OR1200_NO_IMMU

//
// Put all outputs in inactive state
//
assign spr_dat_o = 32'h00000000;
assign icimmu_adr_o = icpu_adr_i;
assign icpu_tag_o = icimmu_tag_i;
assign icimmu_cycstb_o = icpu_cycstb_i;
assign icpu_rty_o = icimmu_rty_i;
assign icpu_err_o = icimmu_err_i;
assign icimmu_ci_o = `OR1200_IMMU_CI;

`else

//
// ITLB SPR access
//
// 1200 - 12FF  itlbmr w0
// 1200 - 123F  itlbmr w0 [63:0]
//
// 1300 - 13FF  itlbtr w0
// 1300 - 133F  itlbtr w0 [63:0]
//
assign itlb_spr_access = spr_cs;

//
// Tags:
//
// OR1200_DTAG_TE - TLB miss Exception
// OR1200_DTAG_PE - Page fault Exception
//
assign icpu_tag_o = miss ? `OR1200_DTAG_TE : fault ? `OR1200_DTAG_PE : icimmu_tag_i;

//
// icpu_rty_o
//
// assign icpu_rty_o = !icpu_err_o & icimmu_rty_i;
assign icpu_rty_o = icimmu_rty_i;

//
// icpu_err_o
//
assign icpu_err_o = miss | fault | icimmu_err_i;

//
// Assert itlb_en_r after one clock cycle
//
always @(posedge clk or posedge rst)
	if (rst)
		itlb_en_r <= #1 1'b0;
	else
		itlb_en_r <= #1 itlb_en;

//
// Assert itlb_done one clock cycle after new address is first presented and tlb is enabled.
//
// assign itlb_done = (icpu_adr_i == icpu_adr_o) & itlb_en_r;
assign itlb_done = itlb_en_r;

//
// Cut transfer if something goes wrong with translation. If IC is disabled,
// use delayed signals.
//
assign icimmu_cycstb_o = (!ic_en & immu_en) ? ~(miss | fault) & icpu_cycstb_i : (miss | fault) ? 1'b0 : icpu_cycstb_i;

//
// Cache Inhibit
//
assign icimmu_ci_o = immu_en ? itlb_done & itlb_ci : `OR1200_IMMU_CI;

//
// Register icpu_adr_i's VPN for use when IMMU is not enabled but PPN is expected to come
// one clock cycle after offset part.
//
always @(posedge clk or posedge rst)
	if (rst)
		icpu_vpn_r <= #1 {31-`OR1200_IMMU_PS{1'b0}};
	else
		icpu_vpn_r <= #1 icpu_adr_i[31:`OR1200_IMMU_PS];

//
// Physical address is either translated virtual address or
// simply equal when IMMU is disabled
//
assign icimmu_adr_o = immu_en ? {itlb_ppn, icpu_adr_i[`OR1200_IMMU_PS-1:0]} : {icpu_vpn_r, icpu_adr_i[`OR1200_IMMU_PS-1:0]};

//
// Output to SPRS unit
//
assign spr_dat_o = itlb_spr_access ? itlb_dat_o : 32'h00000000;

//
// Page fault exception logic
//
assign fault = itlb_done &
			(  (!supv & !itlb_uxe)		// Execute in user mode not enabled
			|| (supv & !itlb_sxe));		// Execute in supv mode not enabled

//
// TLB Miss exception logic
//
assign miss = itlb_done & !itlb_hit;

//
// ITLB Enable
//
assign itlb_en = immu_en & icpu_cycstb_i;

//
// Instantiation of ITLB
//
or1200_immu_tlb or1200_immu_tlb(
	// Rst and clk
        .clk(clk),
	.rst(rst),

        // I/F for translation
        .tlb_en(itlb_en),
	.vaddr(icpu_adr_i),
	.hit(itlb_hit),
	.ppn(itlb_ppn),
	.uxe(itlb_uxe),
	.sxe(itlb_sxe),
	.ci(itlb_ci),

        // SPR access
        .spr_cs(itlb_spr_access),
	.spr_write(spr_write),
	.spr_addr(spr_addr),
	.spr_dat_i(spr_dat_i),
	.spr_dat_o(itlb_dat_o)
);

`endif

endmodule
