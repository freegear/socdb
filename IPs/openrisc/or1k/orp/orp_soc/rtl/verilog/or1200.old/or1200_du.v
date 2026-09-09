//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's Debug Unit                                         ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Basic OR1200 debug unit.                                    ////
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
// $Log: or1200_du.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:45  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.6  2002/03/14 00:30:24  lampret
// Added alternative for critical path in DU.
//
// Revision 1.5  2002/02/11 04:33:17  lampret
// Speed optimizations (removed duplicate _cyc_ and _stb_). Fixed D/IMMU cache-inhibit attr.
//
// Revision 1.4  2002/01/28 01:16:00  lampret
// Changed 'void' nop-ops instead of insn[0] to use insn[16]. Debug unit stalls the tick timer. Prepared new flag generation for add and and insns. Blocked DC/IC while they are turned off. Fixed I/D MMU SPRs layout except WAYs. TODO: smart IC invalidate, l.j 2 and TLB ways.
//
// Revision 1.3  2002/01/18 07:56:00  lampret
// No more low/high priority interrupts (PICPR removed). Added tick timer exception. Added exception prefix (SR[EPH]). Fixed single-step bug whenreading NPC.
//
// Revision 1.2  2002/01/14 06:18:22  lampret
// Fixed mem2reg bug in FAST implementation. Updated debug unit to work with new genpc/if.
//
// Revision 1.1  2002/01/03 08:16:15  lampret
// New prefixes for RTL files, prefixed module names. Updated cache controllers and MMUs.
//
// Revision 1.12  2001/11/30 18:58:00  simons
// Trap insn couses break after exits ex_insn.
//
// Revision 1.11  2001/11/23 08:38:51  lampret
// Changed DSR/DRR behavior and exception detection.
//
// Revision 1.10  2001/11/20 21:25:44  lampret
// Fixed dbg_is_o assignment width.
//
// Revision 1.9  2001/11/20 18:46:14  simons
// Break point bug fixed
//
// Revision 1.8  2001/11/18 08:36:28  lampret
// For GDB changed single stepping and disabled trap exception.
//
// Revision 1.7  2001/10/21 18:09:53  lampret
// Fixed sensitivity list.
//
// Revision 1.6  2001/10/14 13:12:09  lampret
// MP3 version.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

//
// Debug unit
//

module or1200_du(
	// RISC Internal Interface
	clk, rst,
	dcpu_cycstb_i, dcpu_we_i,
	icpu_cycstb_i, ex_freeze, branch_op, ex_insn, du_dsr,
	du_stall, du_addr, du_dat_i, du_dat_o, du_read, du_write, du_except,
	spr_cs, spr_write, spr_addr, spr_dat_i, spr_dat_o,

	// External Debug Interface
	dbg_stall_i, dbg_dat_i, dbg_adr_i, dbg_op_i, dbg_ewt_i,
	dbg_lss_o, dbg_is_o, dbg_wp_o, dbg_bp_o, dbg_dat_o
);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_OPERAND_WIDTH;

//
// I/O
//

//
// RISC Internal Interface
//
input				clk;		// Clock
input				rst;		// Reset
input				dcpu_cycstb_i;	// LSU status
input				dcpu_we_i;	// LSU status
input	[`OR1200_FETCHOP_WIDTH-1:0]	icpu_cycstb_i;	// IFETCH unit status
input				ex_freeze;	// EX stage freeze
input	[`OR1200_BRANCHOP_WIDTH-1:0]	branch_op;	// Branch op
input	[dw-1:0]		ex_insn;	// EX insn
output	[`OR1200_DU_DSR_WIDTH-1:0]     du_dsr;		// DSR
output				du_stall;	// Debug Unit Stall
output	[aw-1:0]		du_addr;	// Debug Unit Address
input	[dw-1:0]		du_dat_i;	// Debug Unit Data In
output	[dw-1:0]		du_dat_o;	// Debug Unit Data Out
output				du_read;	// Debug Unit Read Enable
output				du_write;	// Debug Unit Write Enable
input	[12:0]			du_except;	// Exception masked by DSR
input				spr_cs;		// SPR Chip Select
input				spr_write;	// SPR Read/Write
input	[aw-1:0]		spr_addr;	// SPR Address
input	[dw-1:0]		spr_dat_i;	// SPR Data Input
output	[dw-1:0]		spr_dat_o;	// SPR Data Output

//
// External Debug Interface
//
input				dbg_stall_i;	// External Stall Input
input	[dw-1:0]		dbg_dat_i;	// External Data Input
input	[aw-1:0]		dbg_adr_i;	// External Address Input
input	[2:0]			dbg_op_i;	// External Operation Select Input
input				dbg_ewt_i;	// External Watchpoint Trigger Input
output	[3:0]			dbg_lss_o;	// External Load/Store Unit Status
output	[1:0]			dbg_is_o;	// External Insn Fetch Status
output	[10:0]			dbg_wp_o;	// Watchpoints Outputs
output				dbg_bp_o;	// Breakpoint Output
output	[dw-1:0]		dbg_dat_o;	// External Data Output


//
// Some connections go directly from the CPU through DU to Debug I/F
//
`ifdef OR1200_DU_STATUS_UNIMPLEMENTED
assign dbg_lss_o = 4'b0000;
assign dbg_is_o = 2'b00;
`else
assign dbg_lss_o = dcpu_cycstb_i ? {dcpu_we_i, 3'b000} : 4'b0000;
assign dbg_is_o = {1'b0, icpu_cycstb_i};
`endif
assign dbg_wp_o = 11'b000_0000_0000;
assign dbg_dat_o = du_dat_i;

//
// Some connections go directly from Debug I/F through DU to the CPU
//
assign du_stall = dbg_stall_i;
assign du_addr = dbg_adr_i;
assign du_dat_o = dbg_dat_i;
assign du_read = (dbg_op_i == `OR1200_DU_OP_READSPR);
assign du_write = (dbg_op_i == `OR1200_DU_OP_WRITESPR);

`ifdef OR1200_DU_IMPLEMENTED

//
// Debug Mode Register 1 (only ST and BT implemented)
//
`ifdef OR1200_DU_DMR1
reg	[23:22]			dmr1;		// DMR1 implemented (ST & BT)
`else
wire	[23:22]			dmr1;		// DMR1 not implemented
`endif

//
// Debug Mode Register 2 (not implemented)
//
`ifdef OR1200_DU_DMR2
wire	[31:0]			dmr2;		// DMR not implemented
`endif

//
// Debug Stop Register
//
`ifdef OR1200_DU_DSR
reg	[`OR1200_DU_DSR_WIDTH-1:0]	dsr;		// DSR implemented
`else
wire	[`OR1200_DU_DSR_WIDTH-1:0]	dsr;		// DSR not implemented
`endif

//
// Debug Reason Register
//
`ifdef OR1200_DU_DRR
reg	[13:0]			drr;		// DRR implemented
`else
wire	[13:0]			drr;		// DRR not implemented
`endif

//
// Internal wires
//
wire				dmr1_sel; 	// DMR1 select
wire				dsr_sel; 	// DSR select
wire				drr_sel; 	// DRR select
reg				dbg_bp_r;
`ifdef OR1200_DU_READREGS
reg	[31:0]			spr_dat_o;
`endif
reg	[13:0]			except_stop;	// Exceptions that stop because of DSR

//
// DU registers address decoder
//
`ifdef OR1200_DU_DMR1
assign dmr1_sel = (spr_cs && (spr_addr[`OR1200_SPR_OFS_BITS] == `OR1200_DU_OFS_DMR1));
`endif
`ifdef OR1200_DU_DSR
assign dsr_sel = (spr_cs && (spr_addr[`OR1200_SPR_OFS_BITS] == `OR1200_DU_OFS_DSR));
`endif
`ifdef OR1200_DU_DRR
assign drr_sel = (spr_cs && (spr_addr[`OR1200_SPR_OFS_BITS] == `OR1200_DU_OFS_DRR));
`endif

//
// Decode started exception
//
always @(du_except) begin
	except_stop = 14'b0000_0000_0000;
	casex (du_except)
		13'b1_xxxx_xxxx_xxxx:
			except_stop[`OR1200_DU_DRR_TTE] = 1'b1;
		13'b0_1xxx_xxxx_xxxx: begin
			except_stop[`OR1200_DU_DRR_IE] = 1'b1;
		end
		13'b0_01xx_xxxx_xxxx: begin
			except_stop[`OR1200_DU_DRR_IME] = 1'b1;
		end
		13'b0_001x_xxxx_xxxx:
			except_stop[`OR1200_DU_DRR_IPFE] = 1'b1;
		13'b0_0001_xxxx_xxxx: begin
			except_stop[`OR1200_DU_DRR_BUSEE] = 1'b1;
		end
		13'b0_0000_1xxx_xxxx:
			except_stop[`OR1200_DU_DRR_IIE] = 1'b1;
		13'b0_0000_01xx_xxxx: begin
			except_stop[`OR1200_DU_DRR_AE] = 1'b1;
		end
		13'b0_0000_001x_xxxx: begin
			except_stop[`OR1200_DU_DRR_DME] = 1'b1;
		end
		13'b0_0000_0001_xxxx:
			except_stop[`OR1200_DU_DRR_DPFE] = 1'b1;
		13'b0_0000_0000_1xxx:
			except_stop[`OR1200_DU_DRR_BUSEE] = 1'b1;
		13'b0_0000_0000_01xx: begin
			except_stop[`OR1200_DU_DRR_RE] = 1'b1;
		end
		13'b0_0000_0000_001x: begin
			except_stop[`OR1200_DU_DRR_TE] = 1'b1;
		end
		13'b0_0000_0000_0001:
			except_stop[`OR1200_DU_DRR_SCE] = 1'b1;
		default:
			except_stop = 14'b0000_0000_0000;
	endcase
end

//
// dbg_bp_o is registered
//
assign dbg_bp_o = dbg_bp_r;

//
// Breakpoint activation register
//
always @(posedge clk or posedge rst)
	if (rst)
		dbg_bp_r <= #1 1'b0;
	else if (!ex_freeze)
		dbg_bp_r <= #1 |except_stop
`ifdef OR1200_DU_DMR1_ST
                        | ~((ex_insn[31:26] == `OR1200_OR32_NOP) & ex_insn[16]) & dmr1[`OR1200_DU_DMR1_ST]
`endif
`ifdef OR1200_DU_DMR1_BT
                        | (branch_op != `OR1200_BRANCHOP_NOP) & dmr1[`OR1200_DU_DMR1_BT]
`endif
			;
        else
                dbg_bp_r <= #1 |except_stop;

//
// Write to DMR1
//
`ifdef OR1200_DU_DMR1
always @(posedge clk or posedge rst)
	if (rst)
		dmr1 <= 2'b00;
	else if (dmr1_sel && spr_write)
		dmr1 <= #1 spr_dat_i[23:22];
`else
assign dmr1 = 2'b00;
`endif

//
// DMR2 bits tied to zero
//
`ifdef OR1200_DU_DMR2
assign dmr2 = 32'h0000_0000;
`endif

//
// Write to DSR
//
`ifdef OR1200_DU_DSR
always @(posedge clk or posedge rst)
	if (rst)
		dsr <= {`OR1200_DU_DSR_WIDTH{1'b0}};
	else if (dsr_sel && spr_write)
		dsr <= #1 spr_dat_i[`OR1200_DU_DSR_WIDTH-1:0];
`else
assign dsr = {`OR1200_DU_DSR_WIDTH{1'b0}};
`endif

//
// Write to DRR
//
`ifdef OR1200_DU_DRR
always @(posedge clk or posedge rst)
	if (rst)
		drr <= 14'b0;
	else if (drr_sel && spr_write)
		drr <= #1 spr_dat_i[13:0];
	else
		drr <= #1 drr | except_stop;
`else
assign drr = 14'b0;
`endif

//
// Read DU registers
//
`ifdef OR1200_DU_READREGS
always @(spr_addr or dsr or drr or dmr1 or dmr2)
	case (spr_addr[`OR1200_SPR_OFS_BITS])
`ifdef OR1200_DU_DMR1
		`OR1200_DU_OFS_DMR1:
			spr_dat_o = {8'b0, dmr1, 22'b0};
`endif
`ifdef OR1200_DU_DMR2
		`OR1200_DU_OFS_DMR2:
			spr_dat_o = dmr2;
`endif
`ifdef OR1200_DU_DSR
		`OR1200_DU_OFS_DSR:
			spr_dat_o = {18'b0, dsr};
`endif
`ifdef OR1200_DU_DRR
		`OR1200_DU_OFS_DRR:
			spr_dat_o = {18'b0, drr};
`endif
		default:
			spr_dat_o = 32'h0000_0000;
	endcase
`endif

//
// DSR alias
//
assign du_dsr = dsr;

`else

//
// When DU is not implemented, drive all outputs as would when DU is disabled
//
assign dbg_bp_o = 1'b0;
assign du_dsr = {`OR1200_DU_DSR_WIDTH{1'b0}};

//
// Read DU registers
//
`ifdef OR1200_DU_READREGS
assign spr_dat_o = 32'h0000_0000;
`ifdef OR1200_DU_UNUSED_ZERO
`endif
`endif

`endif

endmodule
