// ###########################################################################
//
// Copyright (c) 2002 Eureka Technology Inc.
//
// Confidential Information
//
// All Rights Reserved
//
// The use, modification, or duplication of this product is protected
// according to FAR 12.212 and by Eureka's licensing agreement.
// This design contains confidential and proprietary information which
// are the properties of Eureka Technology Inc.
// Unauthorized use, disclosure, duplication, or reproduction are prohibited.
//
// 1K Access Violation Check Module
// Rev 1.0
//
// ###########################################################################
//
// Brief Description
//
// This module checks if during an access to the AHB slave whether an 1K boundary
// has been crossed. If so, an error must be flagged.
// The module asserts error if the current access type to slave is an SEQ and
// the current address' bits [9:2] are all 0's and the last access address' bits [9:2]
// are all 1's and this is an incrementing access
// ##########################################################################
//
// Signal Description
//
//	clk			Clock Input
//	addr			Address input
//	trans			Current Transaction Type
//	incr			Flag to indicate incrementing access
//
// ###########################################################################
//
`timescale 1ns / 100ps

module boundchk(
addr,
hburst,
hgrant,
hready,
hresp,
trans,
clk,
incr
);
input [31:0] addr;
input [2:0] hburst;
input hgrant;
input hready;
input [1:0] hresp;
input [1:0] trans;
input clk;
input       incr;

reg [31:0] last_addr;
integer	ahbburst_cnt;
integer	burst_size;
reg	hgrant_ff;

initial 
begin
	last_addr = 32'h00000000;
end

always @(posedge clk)
begin
	//if SEQ and current address' [9:2] is all 0's and last address's [9:2] was all 1's and if this is an incrementing transfer
	if ((trans == 2'b11) && (addr[9:2] == 8'b00000000) && (last_addr[9:2] == 8'b11111111) && (incr == 1'b1)) begin
		$display("Error: Master tried to cross 1k boundary of AHB Slave");
		$stop;
	end
	last_addr <= #1 addr;
end

always @(posedge clk)
begin

	if (hready==1'b1) hgrant_ff <= #1 hgrant;

end

//
// Check the value of HBURST and the actual number of words a master transfers.
// 
always @(posedge clk)
begin

// Update the counter that counts the number of words being transferred.

	if ((trans==2'b10) && (hready==1'b1) && (hgrant_ff==1'b1)) begin

	   if (hburst==3'b000) burst_size = 0;
	   else if (hburst==3'b001) burst_size = -1;
	   else if (hburst[2:1]==2'b01) burst_size = 3;
	   else if (hburst[2:1]==2'b10) burst_size = 7;
	   else if (hburst[2:1]==2'b11) burst_size = 15;

	   if (hgrant==1'b0) ahbburst_cnt <= #1 0;
	   else ahbburst_cnt <= #1 burst_size;
	end
	else if ((trans==2'b11) && (hready==1'b1) && (hgrant_ff==1'b1)) begin

	   if (hgrant==1'b0) ahbburst_cnt <= #1 0;
	   else if (ahbburst_cnt>0) ahbburst_cnt <= #1 ahbburst_cnt - 1;

	end
	else if ((trans==2'b11) && ((hresp[0]==1'b1) || (hresp[1]==1'b1)) && (hgrant_ff==1'b1)) begin
	   ahbburst_cnt <= #1 0;
	end

// Check the value of the counter to be consistent with the transfer size specified in hburst.
	if ((trans==2'b10) && (hready==1'b1) && (hgrant_ff==1'b1)) begin
	   if (ahbburst_cnt>0) begin
		$write("ERROR -- Early burst termination caused by the master\n");
		$stop;
	   end
	end

	else if ((trans==2'b11) && (hready==1'b1) && (hgrant_ff==1'b1)) begin
	   if (ahbburst_cnt==0) begin
		$write("ERROR -- Too many SEQs \n");
		$stop;
	   end
	end

	else if (trans==2'b00) begin
	   if (ahbburst_cnt>0) begin
		$write("ERROR -- Early burst termination caused by the master\n");
		$stop;
	   end
	end

end



endmodule
