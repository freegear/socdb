//
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
// ahb_arb Rev 1.0
// 
// Simulation model of AHB bus arbiter
//
//
// ##########################################################################
//
`timescale 1ns / 100ps

module ahb_arb(
hclk,
hreset_b,
hbusreq,
hgrant,
hready_from_slave,
hready,

haddr,
hburst,
hprot,
hsize,
htrans,
hwrite,
hwdata,

h0addr,
h0burst,
h0prot,
h0size,
h0trans,
h0write,
h0wdata,
h1addr,
h1burst,
h1prot,
h1size,
h1trans,
h1write,
h1wdata,
h2addr,
h2burst,
h2prot,
h2size,
h2trans,
h2write,
h2wdata,
h3addr,
h3burst,
h3prot,
h3size,
h3trans,
h3write,
h3wdata,
test_state);

input		hclk;
input		hreset_b;
input[3:0]	hbusreq;
output[3:0]	hgrant;
input[3:0]	hready_from_slave;
output		hready;


output[31:0]	haddr;
output[2:0]	hburst;
output[3:0]	hprot;
output[2:0]	hsize;
output[1:0]	htrans;
output		hwrite;
output[31:0]	hwdata;

input[31:0]	h0addr;
input[2:0]	h0burst;
input[3:0]	h0prot;
input[2:0]	h0size;
input[1:0]	h0trans;
input		h0write;
input[31:0]	h0wdata;
input[31:0]	h1addr;
input[2:0]	h1burst;
input[3:0]	h1prot;
input[2:0]	h1size;
input[1:0]	h1trans;
input		h1write;
input[31:0]	h1wdata;
input[31:0]	h2addr;
input[2:0]	h2burst;
input[3:0]	h2prot;
input[2:0]	h2size;
input[1:0]	h2trans;
input		h2write;
input[31:0]	h2wdata;
input[31:0]	h3addr;
input[2:0]	h3burst;
input[3:0]	h3prot;
input[2:0]	h3size;
input[1:0]	h3trans;
input		h3write;
input[31:0]	h3wdata;
input[31:0]	test_state;

reg[31:0]	haddr;
reg[2:0]	hburst;
reg[3:0]	hprot;
reg[2:0]	hsize;
reg[1:0]	htrans;
reg		hwrite;
reg[31:0]	hwdata;
wire		grant0;
wire		grant1;
wire		grant2;
wire		grant3;
integer		grant_now;
integer		mux_now;
integer		mux_sel;
integer		mux_sel_dt;
reg[31:0]	switch_val;
reg		switch_grant;

//
// #########################################################################
//
// Section 1.0
//
// randomly decide to change bus grant signal
//
// #########################################################################
//
always @(posedge hclk) begin
   #1;
   switch_val = $random;
   if ((test_state != 32'h00000100) || (switch_val[4:0] == 5'b00000))
	switch_grant = 1;
   else
	switch_grant = 0;
end

//
// #########################################################################
//
// Section 2.0
//
// decide the new port to receive grant, based on
// rotating priority
//
// #########################################################################
//
always @(posedge hclk) begin
   if (~hreset_b) grant_now = 0;
   if (switch_grant) begin
	if (grant0) begin
	   if (hbusreq[1]) grant_now = 1;
	   else if (hbusreq[2]) grant_now = 2;
	   else if (hbusreq[3]) grant_now = 3;
	   else grant_now = 0;
	end
	else if (grant1) begin
	   if (hbusreq[2]) grant_now = 2;
	   else if (hbusreq[3]) grant_now = 3;
	   else if (hbusreq[0]) grant_now = 0;
	   else grant_now = 1;
	end
	else if (grant2) begin
	   if (hbusreq[3]) grant_now = 3;
	   else if (hbusreq[0]) grant_now = 0;
	   else if (hbusreq[1]) grant_now = 1;
	   else grant_now = 2;
	end
	else if (grant3) begin
	   if (hbusreq[0]) grant_now = 0;
	   else if (hbusreq[1]) grant_now = 1;
	   else if (hbusreq[2]) grant_now = 2;
	   else grant_now = 3;
	end
   end
end
//
assign #1 grant0 = (grant_now==0) ? 1'b1 : 1'b0;
assign #1 grant1 = (grant_now==1) ? 1'b1 : 1'b0;
assign #1 grant2 = (grant_now==2) ? 1'b1 : 1'b0;
assign #1 grant3 = (grant_now==3) ? 1'b1 : 1'b0;
assign hgrant[0] = grant0;
assign hgrant[1] = grant1;
assign hgrant[2] = grant2;
assign hgrant[3] = grant3;
//
//
// switch the master mux based on valid grant
//
always @(posedge hclk) begin
   if (grant0 & hready) mux_now = 0;
   if (grant1 & hready) mux_now = 1;
   if (grant2 & hready) mux_now = 2;
   if (grant3 & hready) mux_now = 3;
   #1;
   mux_sel = mux_now;
end

always @(posedge hclk) begin
   if (hready==1'b1) mux_sel_dt = #1 mux_sel;
end
//
// #########################################################################
//
// Section 3.0
//
// muxing master outputs
//
// #########################################################################
//
always @(mux_sel or h0addr or h1addr or h2addr or h3addr) begin
   case (mux_sel)
   0 : haddr = h0addr;
   1 : haddr = h1addr;
   2 : haddr = h2addr;
   3 : haddr = h3addr;
   default : haddr = 32'bx;
   endcase
end
//
always @(mux_sel or h0burst or h1burst or h2burst or h3burst) begin
   case (mux_sel)
   0 : hburst = h0burst;
   1 : hburst = h1burst;
   2 : hburst = h2burst;
   3 : hburst = h3burst;
   default : hburst = 3'bx;
   endcase
end
//
always @(mux_sel or h0prot or h1prot or h2prot or h3prot) begin
   case (mux_sel)
   0 : hprot = h0prot;
   1 : hprot = h1prot;
   2 : hprot = h2prot;
   3 : hprot = h3prot;
   default : hprot = 4'bx;
   endcase
end
//
always @(mux_sel or h0size or h1size or h2size or h3size) begin
   case (mux_sel)
   0 : hsize = h0size;
   1 : hsize = h1size;
   2 : hsize = h2size;
   3 : hsize = h3size;
   default : hsize = 3'bx;
   endcase
end
//
always @(mux_sel or h0trans or h1trans or h2trans or h3trans) begin
   case (mux_sel)
   0 : htrans = h0trans;
   1 : htrans = h1trans;
   2 : htrans = h2trans;
   3 : htrans = h3trans;
   default : htrans = 2'bx;
   endcase
end
//
always @(mux_sel_dt or h0wdata or h1wdata or h2wdata or h3wdata) begin
   case (mux_sel_dt)
   0 : hwdata = h0wdata;
   1 : hwdata = h1wdata;
   2 : hwdata = h2wdata;
   3 : hwdata = h3wdata;
   default : hwdata = 32'bx;
   endcase
end
//
always @(mux_sel or h0write or h1write or h2write or h3write) begin
   case (mux_sel)
   0 : hwrite = h0write;
   1 : hwrite = h1write;
   2 : hwrite = h2write;
   3 : hwrite = h3write;
   default : hwrite = 1'bx;
   endcase
end
//
// #########################################################################
//
// Section 4.0
//
// slave side muxing
//
// #########################################################################
//
assign hready = hready_from_slave[0] & hready_from_slave[1] &
		hready_from_slave[2] & hready_from_slave[3];
//
endmodule
