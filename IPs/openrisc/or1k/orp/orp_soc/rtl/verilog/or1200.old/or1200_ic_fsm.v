//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's IC FSM                                             ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Data cache state machine                                    ////
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
// $Log: or1200_ic_fsm.v,v $
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
// Revision 1.9  2001/10/21 17:57:16  lampret
// Removed params from generic_XX.v. Added translate_off/on in sprs.v and id.v. Removed spr_addr from ic.v and ic.v. Fixed CR+LF.
//
// Revision 1.8  2001/10/19 23:28:46  lampret
// Fixed some synthesis warnings. Configured with caches and MMUs.
//
// Revision 1.7  2001/10/14 13:12:09  lampret
// MP3 version.
//
// Revision 1.1.1.1  2001/10/06 10:18:35  igorm
// no message
//
// Revision 1.2  2001/08/09 13:39:33  lampret
// Major clean-up.
//
// Revision 1.1  2001/07/20 00:46:03  lampret
// Development version of RTL. Libraries are missing.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

`define OR1200_ICFSM_IDLE	3'd0
`define OR1200_ICFSM_CFETCH	3'd1
`define OR1200_ICFSM_LREFILL3	3'd2
`define OR1200_ICFSM_IFETCH	3'd3

//
// Data cache FSM for cache line of 16 bytes (4x singleword)
//

module or1200_ic_fsm(
	// Clock and reset
	clk, rst,

	// Internal i/f to top level IC
	ic_en, icimmu_cycstb_i, icimmu_ci_i, icpu_sel_i,
	tagcomp_miss, biudata_valid, biudata_error, start_addr, saved_addr,
	icram_we, biu_read, first_hit_ack, first_miss_ack, first_miss_err,
	burst, tag_we
);

//
// I/O
//
input				clk;
input				rst;
input				ic_en;
input				icimmu_cycstb_i;
input				icimmu_ci_i;
input	[3:0]			icpu_sel_i;
input				tagcomp_miss;
input				biudata_valid;
input				biudata_error;
input	[31:0]			start_addr;
output	[31:0]			saved_addr;
output	[3:0]			icram_we;
output				biu_read;
output				first_hit_ack;
output				first_miss_ack;
output				first_miss_err;
output				burst;
output				tag_we;

//
// Internal wires and regs
//
reg	[31:0]			saved_addr_r;
reg	[2:0]			state;
reg	[2:0]			cnt;
reg				hitmiss_eval;
reg				load;
reg				cache_inhibit;

//
// Generate of ICRAM write enables
//
assign icram_we = {4{load & biudata_valid & !cache_inhibit}};
assign tag_we = biu_read & biudata_valid & !cache_inhibit;

//
// BIU read and write
//
assign biu_read = (hitmiss_eval & tagcomp_miss) | (!hitmiss_eval & load);

//assign saved_addr = hitmiss_eval ? start_addr : saved_addr_r;
assign saved_addr = saved_addr_r;

//
// Assert for cache hit first word ready
// Assert for cache miss first word stored/loaded OK
// Assert for cache miss first word stored/loaded with an error
//
assign first_hit_ack = (state == `OR1200_ICFSM_CFETCH) & hitmiss_eval & !tagcomp_miss & !cache_inhibit & !icimmu_ci_i;
assign first_miss_ack = (state == `OR1200_ICFSM_CFETCH) & biudata_valid;
assign first_miss_err = (state == `OR1200_ICFSM_CFETCH) & biudata_error;

//
// Assert burst when doing reload of complete cache line
//
assign burst = (state == `OR1200_ICFSM_CFETCH) & tagcomp_miss & !cache_inhibit
		| (state == `OR1200_ICFSM_LREFILL3);

//
// Main IC FSM
//
always @(posedge clk or posedge rst) begin
	if (rst) begin
		state <= #1 `OR1200_ICFSM_IDLE;
		saved_addr_r <= #1 32'b0;
		hitmiss_eval <= #1 1'b0;
		load <= #1 1'b0;
		cnt <= #1 3'b000;
		cache_inhibit <= #1 1'b0;
	end
	else
	case (state)	// synopsys parallel_case
		`OR1200_ICFSM_IDLE :
			if (ic_en & icimmu_cycstb_i) begin		// fetch
				state <= #1 `OR1200_ICFSM_CFETCH;
				saved_addr_r <= #1 start_addr;
				hitmiss_eval <= #1 1'b1;
				load <= #1 1'b1;
				cache_inhibit <= #1 1'b0;
			end
			else begin							// idle
				state <= #1 `OR1200_ICFSM_IDLE;
				hitmiss_eval <= #1 1'b0;
				load <= #1 1'b0;
				cache_inhibit <= #1 1'b0;
			end
		`OR1200_ICFSM_CFETCH: begin	// fetch
			if (icimmu_cycstb_i & icimmu_ci_i)
				cache_inhibit <= #1 1'b1;
			if (hitmiss_eval)
				saved_addr_r[31:13] <= #1 start_addr[31:13];
			if (!ic_en)
				state <= #1 `OR1200_ICFSM_IDLE;
			else if (hitmiss_eval & !icimmu_cycstb_i) begin	// fetch aborted (usually caused by IMMU)
				state <= #1 `OR1200_ICFSM_IDLE;
				hitmiss_eval <= #1 1'b0;
				load <= #1 1'b0;
				cache_inhibit <= #1 1'b0;
			end
			else if (biudata_error) begin			// fetch terminated with an error
				state <= #1 `OR1200_ICFSM_IDLE;
				hitmiss_eval <= #1 1'b0;
				load <= #1 1'b0;
				cache_inhibit <= #1 1'b0;
			end
			else if (cache_inhibit & biudata_valid) begin	// fetch from cache-inhibited page
				state <= #1 `OR1200_ICFSM_IDLE;
				hitmiss_eval <= #1 1'b0;
				load <= #1 1'b0;
				cache_inhibit <= #1 1'b0;
			end
			else if (tagcomp_miss & biudata_valid) begin	// fetch missed, finish current external fetch and refill
				state <= #1 `OR1200_ICFSM_LREFILL3;
				saved_addr_r[3:2] <= #1 saved_addr_r[3:2] + 'd1;
				hitmiss_eval <= #1 1'b0;
				cnt <= #1 `OR1200_ICLS-2;
				cache_inhibit <= #1 1'b0;
			end
			else if (!tagcomp_miss & !icimmu_ci_i) begin	// fetch hit, finish immediately
				state <= #1 `OR1200_ICFSM_CFETCH;
				saved_addr_r <= #1 start_addr;
				hitmiss_eval <= #1 1'b1;
				load <= #1 1'b1;
				cache_inhibit <= #1 1'b0;
			end
			else if (!icimmu_cycstb_i) begin	// fetch aborted (usually caused by exception)
				state <= #1 `OR1200_ICFSM_IDLE;
				hitmiss_eval <= #1 1'b0;
				load <= #1 1'b0;
				cache_inhibit <= #1 1'b0;
			end
			else						// fetch in-progress
				hitmiss_eval <= #1 1'b0;
		end
		`OR1200_ICFSM_LREFILL3 : begin
			if (!ic_en)
				state <= #1 `OR1200_ICFSM_IDLE;
			else if (biudata_valid && (|cnt)) begin		// refill ack, more fetchs to come
				cnt <= #1 cnt - 'd1;
				saved_addr_r[3:2] <= #1 saved_addr_r[3:2] + 'd1;
			end
			else if (biudata_valid) begin			// last fetch of line refill
				state <= #1 `OR1200_ICFSM_IDLE;
				saved_addr_r <= #1 start_addr;
				hitmiss_eval <= #1 1'b0;
				load <= #1 1'b0;
			end
		end
		default:
			state <= #1 `OR1200_ICFSM_IDLE;
	endcase
end

endmodule
