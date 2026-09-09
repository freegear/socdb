`define behavior_ram
//`define virtex_ram
`ifdef print_all
// If behavior_ram is defined, behavioral RAM model is used for the simulation.
// If virtex_ram is defined, Xilinx Virtex/VirtexE RAM model is used for the simulation.
// If apex_ram is defined, Altera Apex RAM model is used for the simulation.
`endif
// ##########################################################################
//
// Copyright (C) 2002 Eureka Technology Inc.
//
// Confidential & Proprietary Information
//
// All Rights Reserved
//
// The use, modification, or duplication of this product is protected
// according to FAR 12.212 and by Eureka's licensing agreement.
// This design contains confidential and proprietary information which
// are the properties of Eureka Technology Inc.
// Unauthorized use, disclosure, duplication, or reproduction are prohibited.
//
// eu_dpramx1: Dual Port RAM Module
// Rev 1.1
//
// ##########################################################################
//
// Revision 1.1 modification from previous version
//
// Remove reset signal from both ports
//
// ##########################################################################
//
// Brief Description
//
// eu_dpramx1 offers users 3 different options in the implementation of the
// dual port ram. It can be based on behaviorial model, Xilinx dual port
// block memory or Altera dual port block memory.
//
// In all cases, it supports a maximum of 8 bit address bus and the data bus
// width is between 1 to 16. Other values are prohibited.
//
// ##########################################################################
//
// Signal Description
//
//	raddr		read address
//	rclk		read clock
//	rdata		read data
//	waddr		write address
//	wclk		write clock
//	wdata		write data
//	we		write enable
//
// ##########################################################################
//
`timescale 1ns / 100ps

module eu_dpramx1(
	raddr,
	rclk,
	rdata,
	waddr,
	wclk,
	wdata,
	we
);

parameter addr_width = 8;
parameter data_width = 16;

input[addr_width-1:0]	raddr;
input			rclk;
output[data_width-1:0]	rdata;
input[addr_width-1:0]	waddr;
input			wclk;
input[data_width-1:0]	wdata;
input			we;



`ifdef behavior_ram
reg[data_width-1:0]	data[0:((1 << addr_width)-1)];
reg[data_width-1:0]	rdata;
integer			i;
`endif

`ifdef virtex_ram
wire[9:0]	addra;
wire[9:0]	addrb;
wire[17:0]	dina;
wire[15:0]	doutb;
`endif

`ifdef behavior_ram
//
// ###########################################################################
//
// Section 1.0
//
// Dual Port RAM using Behavioral Model
//
// ###########################################################################
//
always @(posedge wclk) begin
	if (we==1'b1) begin
	   data[waddr] <= #1 wdata;
	end
end

always @(posedge rclk) begin
	rdata <= #1 data[raddr];
end
`endif

`ifdef virtex_ram
//
// ###########################################################################
//
// Section 1.0
//
// Dual Port RAM using Xilinx Dual Port Block Memory
//
// ###########################################################################
//
dpram_256x16 dpram (
.addra		(addra[7:0]),
.addrb		(addrb[7:0]),
.clka		(wclk),
.clkb		(rclk),
.dina		(dina[15:0]),
.doutb		(doutb),
.wea		(we)
);
assign addra[addr_width-1:0] = waddr;
assign addra[9:addr_width] = 0;
assign addrb[addr_width-1:0] = raddr;
assign addrb[9:addr_width] = 0;
assign dina[data_width-1:0] = wdata;
assign dina[17:data_width] = 0;
assign rdata = doutb[data_width-1:0];
`endif

`ifdef apex_ram
//
// ###########################################################################
//
// Section 1.0
//
// Dual Port RAM using Altera Dual Port Block Memory
//
// ###########################################################################
//
/*
// Altera Apex ram compilation model
lpm_ram_dp dpram (
.data		(wdata),
.rdaddress	(raddr),
.wraddress	(waddr),
.rden		(1'b1),
.wren		(we),
.q		(rdata),
.rdclock	(rclk),
.rdclken	(1'b1),
.wrclock	(wclk),
.wrclken	(1'b1)
);
defparam dpram.lpm_width = data_width;
defparam dpram.lpm_widthad = addr_width;
defparam dpram.lpm_outdata = "REGISTERED";
defparam dpram.lpm_rdaddress_control = "UNREGISTERED";
*/
// Altera Apex ram simulation model
syn_dpram_256x16_rowr dpram (
.Data		(wdata),
.RdAddress	(raddr),
.WrAddress	(waddr),
.RdEn		(1'b1),
.WrEn		(we),
.Q		(rdata),
.RdClock	(rclk),
.RdClken	(1'b1),
.WrClock	(wclk),
.WrClken	(1'b1)
);
defparam dpram.Width = data_width;
defparam dpram.WidthAd = addr_width;
defparam dpram.NumWords = (1 << addr_width);
`endif

endmodule
