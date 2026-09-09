// ##########################################################################
//
// Copyright (C) 2001-2003 Eureka Technology Inc.
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
// monitor_bus : verify ecConnect1 bus
// Rev 1.0
//
// ##########################################################################
//
`timescale 1ns / 100ps

module monitor_bus(
clk,
ads_b,
blast_b,
cs_b,
rdy_b,
abort_b,
master_id,
retry_b,
size,
wr,
reset_b
);

parameter disable_monitor = 1'b1;

input clk;
input ads_b;
input blast_b;
input cs_b;
input rdy_b;
input abort_b;
input[1:0] master_id;
input retry_b;
input[7:0] size;
input wr;
input reset_b;

integer wait_cnt[0:8];
integer rd_retry_cnt[0:31];
integer wr_retry_cnt[0:31];
integer idle_retry_cnt[0:31];
integer abort_cnt;
integer size_cnt[0:31];

integer loopIdx;
integer t_init;
integer t_retry;

reg op;
reg retry_flag;
reg blast_flag;
reg cs_flag;
reg[7:0] tmp_size;


always @(posedge clk)
if (disable_monitor==1'b0) begin
	if(reset_b == 1'b0)
	begin
		abort_cnt = 0;
		for(loopIdx = 0; loopIdx < 9; loopIdx = loopIdx + 1)
			wait_cnt[loopIdx] = 0;
		for(loopIdx = 0; loopIdx < 32; loopIdx = loopIdx + 1)
		begin
			rd_retry_cnt[loopIdx] = 0;
			wr_retry_cnt[loopIdx] = 0;
			idle_retry_cnt[loopIdx] = 0;
			size_cnt[loopIdx] = 0;
		end
		retry_flag = 1'b0;
	end
	if(~cs_b) begin
		if(ads_b == 1'b0) begin
			t_init = 0;
			t_retry = 0;
		 	size_cnt[size] = size_cnt[size] + 1;
		 	tmp_size[7:0] = size[7:0];
		 	blast_flag = 1'b0;
		end
 		else if(rdy_b == 1'b0)
	 	begin
 			wait_cnt[t_init-t_retry] = wait_cnt[t_init-t_retry] + 1;
/*
 			if(tmp_size[7:0] == 8'h01) begin
 			     if((~blast_b && ~blast_flag) || (blast_b && blast_flag)) begin
 			     	blast_flag = ~blast_flag;
 			     end
 			     else begin
 			     	$write("Error: Incorrect blast_b assertion for master %d\n", master_id);
 			     	$stop;
 			     end
 			end
*/
 			if(tmp_size[7:0] > 8'h01) tmp_size[7:0] = tmp_size[7:0] - 8'h01;
	 	end
 		else	
 			t_init = t_init+1;
	end
 	if((retry_b == 1'b0) && (retry_flag == 1'b0)) begin
 		t_retry = 0;
 		retry_flag = 1'b1;
 		op = wr;
 		cs_flag = ~cs_b;
 	end
 	else if((retry_b == 1'b1) && (retry_flag == 1'b1))
 	begin
 		t_retry = t_retry+1;
 		retry_flag = 1'b0;
		if(cs_flag) begin
 			if(op == 1'b0)
 				rd_retry_cnt[t_retry] = rd_retry_cnt[t_retry]+1;
	 		else
 				wr_retry_cnt[t_retry] = wr_retry_cnt[t_retry]+1;
		end
		else
			idle_retry_cnt[t_retry] = idle_retry_cnt[t_retry]+1;

 	end
 	else if((retry_b == 1'b0) && (retry_flag == 1'b1))
 		t_retry = t_retry+1;
 	if(abort_b == 1'b0) abort_cnt = abort_cnt+1;
end

endmodule
