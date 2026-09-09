// ##########################################################################
//
// Copyright (C) 2003 Eureka Technology Inc.
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
// monitor_pci : model checking ad[1:0] and cbe_b[3:0] mismatch in io access
//		 Also check illegal assertion of DEVSEL#, STOP# and TRDY#
//
// ##########################################################################
//
`timescale 1ns / 100ps

module monitor_pci(
ad,
cbe_b,
frame_b,
irdy_b,
devsel_b,
stop_b,
trdy_b,
clk,
reset_b,
inttime
);

input[1:0]	ad;
input[3:0]	cbe_b;
input		frame_b;
input		irdy_b;
input		devsel_b;
input		stop_b;
input		trdy_b;
input		clk;
input		reset_b;
input[31:0]	inttime;



reg[15:0]	byte_nil_cnt;
reg[15:0]	byte0_cnt;
reg[15:0]	byte1_cnt;
reg[15:0]	byte2_cnt;
reg[15:0]	byte3_cnt;
reg[1:0]	ad_reg;
reg[3:0]	cbe_b_reg;
reg		check_cycle;
reg		frame_b_reg;



always @(negedge reset_b or posedge clk) begin
   if (reset_b==1'b0) begin
	frame_b_reg = 1'b1;
   end
   else begin
	frame_b_reg <= #1 frame_b;
   end
end

always @(negedge reset_b or posedge clk) begin
   if (reset_b==1'b0) begin
	ad_reg[1:0] = 2'b00;
	cbe_b_reg[3:0] = 4'b1111;
	check_cycle = 1'b0;
   end
   else begin
	if ((frame_b==1'b0) && (frame_b_reg==1'b1)) begin
	   ad_reg[1:0] <= #1 ad[1:0];
	   cbe_b_reg[3:0] <= #1 cbe_b[3:0];
	   check_cycle <= #1 1'b1;
	end

	if (irdy_b==1'b0) begin
	   check_cycle <= #1 1'b0;
	end
   end
end

always @(negedge reset_b or posedge clk) begin
   if (reset_b==1'b0) begin
	byte_nil_cnt[15:0] = 16'h0000;
	byte0_cnt[15:0] = 16'h0000;
	byte1_cnt[15:0] = 16'h0000;
	byte2_cnt[15:0] = 16'h0000;
	byte3_cnt[15:0] = 16'h0000;
   end
   else begin
	if ((check_cycle==1'b1) && ((cbe_b_reg[3:0]==4'b0010) || (cbe_b_reg[3:0]==4'b0011))) begin
	   if (cbe_b[3:0]==4'b1111) begin
		byte_nil_cnt[15:0] = byte_nil_cnt[15:0] + 16'h0001;
	   end
	   else if (cbe_b[0]==1'b0) begin
		if (ad_reg[1:0]==2'b00) begin
		   byte0_cnt[15:0] = byte0_cnt[15:0] + 16'h0001;
		end
		else begin
		   $write("Error ***** IO access ad[1:0] mismatch at%d\n", inttime);
		   $write("            For byte enable %b, expect ad[1:0] to be 00, get %b\n", cbe_b, ad_reg);
		   $stop;
		end
	   end
	   else if (cbe_b[1]==1'b0) begin
		if (ad_reg[1:0]==2'b01) begin
		   byte1_cnt[15:0] = byte1_cnt[15:0] + 16'h0001;
		end
		else begin
		   $write("Error ***** IO access ad[1:0] mismatch at%d\n", inttime);
		   $write("            For byte enable %b, expect ad[1:0] to be 01, get %b\n", cbe_b, ad_reg);
		   $stop;
		end
	   end
	   else if (cbe_b[2]==1'b0) begin
		if (ad_reg[1:0]==2'b10) begin
		   byte2_cnt[15:0] = byte2_cnt[15:0] + 16'h0001;
		end
		else begin
		   $write("Error ***** IO access ad[1:0] mismatch at%d\n", inttime);
		   $write("            For byte enable %b, expect ad[1:0] to be 10, get %b\n", cbe_b, ad_reg);
		   $stop;
		end
	   end
	   else if (cbe_b[3]==1'b0) begin
		if (ad_reg[1:0]==2'b11) begin
		   byte3_cnt[15:0] = byte3_cnt[15:0] + 16'h0001;
		end
		else begin
		   $write("Error ***** IO access ad[1:0] mismatch at%d\n", inttime);
		   $write("            For byte enable %b, expect ad[1:0] to be 11, get %b\n", cbe_b, ad_reg);
		   $stop;
		end
	   end
	end
   end
end

always @(negedge reset_b or posedge clk) begin
   if (reset_b==1'b0) ;
   else begin
	if ((frame_b==1'b1) && (irdy_b==1'b1)) begin
	   if (devsel_b==1'b1) ;
	   else begin
		$write("Error ***** Illegal assertion of DEVSEL# at%d\n", inttime);
		$stop;
	   end

	   if (stop_b==1'b1) ;
	   else begin
		$write("Error ***** Illegal assertion of STOP# at%d\n", inttime);
		$stop;
	   end

	   if (trdy_b==1'b1) ;
	   else begin
		$write("Error ***** Illegal assertion of TRDY# at%d\n", inttime);
		$stop;
	   end
	end
   end
end

endmodule
