//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's AHB(instruction side) BIU                          ////
////                                                              ////
////  Description                                                 ////
////  Implements AHB interface for OpenRISC 1200                  ////
////                                                              ////
////  Limitation                                                  ////
////   - No support for SPLIT/RETRY                               ////
////   - AHB aribter should not take ownership of bus back        ////
///      in the middle of burst(WRAP4 only).                      ////
////                                                              ////
////  Important Note                                              ////
////   - OR1200 only support big-endian, so AHB interface is.     ////
////                                                              ////
////  Author(s):                                                  ////
////      - holelee                                               ////
////                                                              ////
////  Borrowed some code and comment from or1200_iwb_biu.v        ////
////  which is written by Damjan Lampret, lampret@opencores.org   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2006 holelee                                   ////
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

//////////////////////////////////////////////////////////////////////
//// Following is the orignal copyright notice of or1200_iwb_biu.v////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Damjan Lampret and OPENCORES.ORG          ////
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

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_iahb_biu(
	// RISC clock, reset and clock control
	clk, rst,

	// AHB-lite interface
	hbusreq, hgrant,
	haddr, htrans, hwrite, hsize, hburst, hprot, hwdata,
	hrdata, hready, hresp,

	// Internal RISC bus
	biu_dat_i, biu_adr_i, biu_siz_i, biu_cyc_i, biu_stb_i, biu_we_i, biu_cab_i,
	biu_dat_o, biu_ack_o, biu_err_o
);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_OPERAND_WIDTH;

//
// RISC clock, reset and clock control
//
input			clk;		// RISC clock
input			rst;		// RISC reset

//
// AHB interface
//
output          hbusreq;	// busreq
input           hgrant;		// grant
output [aw-1:0] haddr;		// address
output [1:0]    htrans;		// trans
output          hwrite;		// write/read ?
output [2:0]    hsize;		// transfer size
output [2:0]    hburst;		// burst type
output [3:0]    hprot;		// protection information
output [dw-1:0] hwdata;		// write data
input  [dw-1:0] hrdata;
input           hready;
input  [1:0]    hresp;

//
// Internal RISC interface
//
input	[dw-1:0]	biu_dat_i;	// input data bus
input	[aw-1:0]	biu_adr_i;	// address bus
input	[1:0]		biu_siz_i;	// WB cycle
input			biu_cyc_i;	// WB cycle
input			biu_stb_i;	// WB strobe
input			biu_we_i;	// WB write enable
input			biu_cab_i;	// CAB input
output	[31:0]		biu_dat_o;	// output data bus
output			biu_ack_o;	// ack output
output			biu_err_o;	// err output

`define IDLE 2'b00
`define NSEQ 2'b10
`define SEQ  2'b11

`define WRAP4 3'b010
`define SINGLE 3'b000

`define OKAY 2'b00

reg           hbusreq;
reg  [aw-1:0] haddr;		// address
reg  [1:0]    htrans;		// trans
reg  [2:0]    hsize;		// transfer size
reg  [2:0]    hburst;		// burst type
reg  [31:0]	  biu_dat_o;	// output data bus

wire biu_cycstb;
assign biu_cycstb = biu_cyc_i & biu_stb_i;

assign hprot = 0;	// I don't know how to encode hprot from openrisc
assign hwrite = 0;	// always read because this is instruction bus interface
assign hwdata = 0;	// write data is always zero. 

reg  [1:0] haddr_counter;
wire       data_phase;
reg        addr_bus_idle;

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		hbusreq <= 1'b0;
		haddr  <= 32'd0;
		htrans <= `IDLE;
		addr_bus_idle <= 1'b1;
		hsize  <= 0;
		hburst <= 0;
		haddr_counter <= 0;
	end
	else
	begin
		if(addr_bus_idle == 1'b1)
		begin
			if(biu_cycstb && (data_phase == 0))
			begin
				if(hgrant == 1 && hready == 1)
					htrans <= `NSEQ;
				haddr  <= biu_adr_i;
				hsize  <= {1'b0, biu_siz_i};
				hburst <= (biu_cab_i == 1) ? `WRAP4 : `SINGLE;
				haddr_counter <= (biu_cab_i == 1)? 2'b11: 2'b00;

				if(hgrant == 1 && hready == 1)
				begin
					addr_bus_idle <= 1'b0;
					hbusreq <= 0;
				end
				else
					hbusreq <= 1;
			end
		end
		else if(hready == 1'b1)
		begin
			haddr[3:2] <= haddr[3:2] + 1;	// WRAP4
			if(haddr_counter == 2'b00 || hgrant == 1'b0)
			begin
				htrans <= `IDLE;
				addr_bus_idle <= 1'b1;
			end
			else
				htrans <= `SEQ;

			haddr_counter <= haddr_counter - 1;
		end
	end
end

reg ahb_data_phase_1d;	// 1 clock delay for biu_ack
reg ahb_data_phase;
assign data_phase = ahb_data_phase | ahb_data_phase_1d;

always @(posedge rst or posedge clk)
begin
	if(rst)
	begin
		ahb_data_phase <= 0;
		ahb_data_phase_1d <= 0;
	end
	else
	begin
		ahb_data_phase_1d <= ahb_data_phase;
		if(hready == 1'b1)
		begin
			if(htrans != `IDLE)
				ahb_data_phase <= 1;
			else
				ahb_data_phase <= 0;
		end
	end
end

reg biu_ack_int;
always @(posedge rst or posedge clk)
begin
	if(rst)
		biu_ack_int <= 1'b0;
	else
	begin
		if(hready && ahb_data_phase)
			biu_ack_int <= 1'b1;
		else
			biu_ack_int <= 1'b0;
	end
end

reg biu_err_int;
always @(posedge rst or posedge clk)
begin
	if(rst)
		biu_err_int <= 1'b0;
	else
	begin
		if(hready && ahb_data_phase)
			biu_err_int <= (hresp != `OKAY);
		else
			biu_err_int <= 1'b0;
	end
end

always @(posedge clk) biu_dat_o <= hrdata;

//
// abort processing
//
wire aborted = ((htrans != `IDLE) | (data_phase == 1)) & (~biu_cycstb);
reg  aborted_r;
always @(posedge clk or posedge rst)
begin
	if(rst)
		aborted_r <= 0;
	else if(aborted)
		aborted_r <= 1;
	else if(data_phase == 0)
		aborted_r <= 0;
end

assign biu_err_o = biu_err_int & (aborted_r == 0);
// Both biu_err_o and biu_ack_o cannot be high at a time.
assign biu_ack_o = biu_ack_int & (aborted_r == 0) & (biu_err_int == 0); 

//
// Protocol chcker
//
// synopsys translate_off
always @(posedge clk)
begin
	if(!rst)
	begin
		if(aborted_r == 0 && (aborted == 1 && biu_ack_o == 0))
		begin
			$display("OR1200 instruction transfer aborted !! : haddr(%h)", haddr);
		end
	end
end
always @(posedge clk)
begin
	if(!rst)
	begin
		if(biu_cycstb && biu_we_i)
		begin
			$display("Detected write transfer on OR1200 instruction port !!");
			$stop;
		end
	end
end
// synopsys translate_on

endmodule
