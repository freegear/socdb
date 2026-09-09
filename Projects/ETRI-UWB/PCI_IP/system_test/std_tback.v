//
// ##########################################################################
//
// Copyright (C) by Eureka Technology Inc.
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
//
// std_tback : Standard target backend model
//
// Rev 1.1
//
// Root std_tback rev 1.0
// ##########################################################################
//
// Rev 1.1
// Modification from previous revision
//
// 030922 Enabled abort range specification through abort_start_addr and
//	abort_end_addr parameters
// 030910 Fixed blast_b signal handling and qualified ads_b for ecconnect2 with
//	cs_b
// 030130 Added tar64_b as input to distinguish between 64-bit single and 
//	  burst target transfers
// ##########################################################################
// Parameter Description
// idle_retry_disable 
//	retry assertion disable during idle cycles. 
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b0 (retry not disabled).
// rd_retry_disable
//	Read retry assertion disable.
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b0 (retry not disabled).
// wr_retry_disable
//	Write retry assertion disable.
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b0 (retry not disabled).
// abort_disable
//	Abort assertion disable
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b0 (abort not disabled).
// cache_size
//	Cache size to use in case of cache wrap mode
//	Allowable values 4,8,16. 
//	Default value 8.
// incr_mode
//	Increment mode type -- cache wrap mode or linear increment mode
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b1 (linear increment mode).
// max_wait
//	Maximum number of wait states
//	Allowable values -- powers of 2 between 0 and 256 
//	Default value 8.
// abort_start_addr
//	Abort range start address
//	Allowable values -- user programmable to any 32 bit value
//	Default value 32'hffffffff
// abort_end_addr
//	Abort range end address
//	Allowable values -- user programmable to any 32 bit value
//	Default value 32'h00000000
// abort_mask
//	Abort address mask
//	Allowable values -- user programmable to any 32 bit value
//	Default value 32'hffffffff
// ecconnect
//	ecconnect choice
//	Allowable values 1 (ecconnect1 only) and 2 (ecconnect2 also allowed). 
//	Default value 1 (ecconnect1 only).
// bus_width
//	Data bus width
//	Allowable values 32 and 64
//	Default value 32
// be_width
//	Byte enable width
//	Allowable values 4 and 8
//	Default value 4
// store_size
//	Store size
//	Allowable values -- user programmable to any non-zero value
//	Default value 1024
// store_length
//	Store length 
//	Allowable values -- Programmed to match store size
//	store_size = 2** store_length
//	Ex: If store size is 1024 -- store length is 10
//	Ex: If store size is 512 -- store length is 9
//	Ex: If store size is 64 -- store length is 6
//	Default value 10
//
// ##########################################################################
//
// Signal Description
//
//	clk			Clock
//	abort_b			Abort
//	addr			Address input
//	ads_b			Address strobe
//	be_b			Byte enables
//	blast_b			Burst last
//	cs_b			Chip select
//	done_b			Transfer completed output
//	drd			Read data output
//	dwr			Write data input
//	rdy_b			Data ready
//	rdnxt_b			Request for next read data
//	retry_b			Retry
//	size			Size input
//	wr			Write/read
//	wren_b			Request for next write data
//	reset_b			Reset
//
// ###########################################################################
//
`timescale 1ns / 100ps

module std_tback(
clk,
abort_b,
addr,
ads_b,
be_b,
blast_b,
cs_b,
done_b,
drd,
dwr,
rdy_b,
rdnxt_b,
retry_b,
size,
tar64_b,
wr,
wren_b,
test_state,
reset_b
);
//retry disable during idle cycles
parameter	idle_retry_disable 	= 1'b0; 
//retry disable for reads
parameter	rd_retry_disable	= 1'b0; 
//retry disable for writes
parameter	wr_retry_disable	= 1'b0; 
//abort disable
parameter	abort_disable 		= 1'b0;
//cache size 
parameter	cache_size		= 8; 
//increment mode
parameter 	incr_mode		= 1'b1;
//maximum number of wait states 
parameter	max_wait		= 8; 
//abort start address
parameter	abort_start_addr	= 32'hffffffff; 
//abort end address
parameter	abort_end_addr		= 32'h00000000; 
//abort mask
parameter	abort_mask		= 32'hffffffff; 
//ecconnect choice
parameter	ecconnect		= 1; 
//bus width
parameter	bus_width		= 32;
//byte enable width 
parameter	be_width		= 4; 
//store size
parameter	store_size		= 1024;
//store size 
parameter	store_length		= 10; 

input[31:0]		addr;
input			ads_b;
output			abort_b;
input[be_width-1:0]		be_b;
input			blast_b;
input			cs_b;
output			done_b;
output[bus_width-1:0]	drd;
input[bus_width-1:0]	dwr;
output			rdy_b;
input			rdnxt_b;
output			retry_b;
input			wr;
input			clk;
input			reset_b;
input[7:0]		size;
input			tar64_b;
input			wren_b;
input[31:0]		test_state;

reg			abort_b;
reg			addr_32_bound;
reg[31:0]   		addr_incr;
reg			ads_flag;
reg			done_b;
reg[bus_width-1:0]	drd;
reg[bus_width-1:0]	dtstore[0:store_size-1];
reg[store_length-1:0]	idx;
reg[bus_width-1:0]	last_wdt_tmp;
reg[31:0]		ran1;
reg[31:0]		ran2;
reg[31:0]		ran3;
reg[31:0]		ran4;
reg[store_length-1:0]	rd_init;
reg[bus_width-1:0]	rdt_tmp;
reg			rdy_b;
reg			rdy_flag;
reg			retry_b;
reg[15:0]		abort_cnt;
reg[15:0]		disconnect_cnt;
reg[15:0]		retry_cnt;
reg[7:0]		size_cnt;
reg[31:0] 		tmp1;
reg[31:0] 		tmp2;
reg[31:0]		tmp_addr;
reg[31:0]		tmp1_addr;
reg[31:0]		local_addr;
reg			tmp_rdy_b;
reg			tmp1_rdy_b;
reg			tmp_abort_b;
reg			tmp_retry_b;
reg			tmp_done_b;
reg[7:0]		wait_cnt;
reg[bus_width-1:0]	wdt_new;
reg[bus_width-1:0]	wdt_tmp;
integer			acc_cntr;
integer			err_length;
integer			i;
integer			j;
integer			rseed1;
integer			rseed2;
integer			wrap_addr;
reg[7:0]	wrap_mask;
reg[7:0]	mask_width;
integer	 cache_wrap_multiplier;


//task to generate random number
task get_random;
inout[31:0] s1;
inout[31:0] s2;
output[31:0] rand_out;
integer k;
integer z;
begin
    k = s1 / 53668;
    s1 = 40014 * (s1 - k * 53668) - k * 12211;
    if (s1 < 0) 
	s1 = s1 + 2147483563;

    k = s2 / 52774;
    s2 = 40692 * (s2 - k * 52774) - k * 3791;
    if (s2 < 0)
	s2 = s2 + 2147483399;

    z = s1 - s2;
    
    rand_out = z;

end 
endtask

//Function to generate number of wait states to generate
//takes random numbers r1 and r2 as input and depending on their value
//inserts appropriate number of wait states between 0 and 256

function [7:0] gen_wait;
input[31:0]	r1;
input[31:0]	r2;
input[31:0]	test_state;
begin

	if (test_state !=32'h00000100)
		gen_wait = 8'h00;
	else if(r1[7:4] == 4'b0111)
		gen_wait[7:0] = 8'h80;
	else if(r1[7:4] == 4'b0110)
		gen_wait[7:0] = 8'h40;
	else if(r1[7:4] == 4'b0101)
		gen_wait[7:0] = 8'h20;
	else if(r1[7:4] == 4'b0100)
		gen_wait[7:0] = 8'h10;
	else if(r1[7:4] == 4'b0011)
		gen_wait[7:0] = 8'h08;
	else if(r1[7:4] == 4'b0010)
		gen_wait[7:0] = 8'h04;
	else if(r1[7:4] == 4'b0001)
		gen_wait[7:0] = 8'h02;
	else if(r1[7:4] == 4'b0000)
		gen_wait[7:0] = 8'h01;
	else
		gen_wait[7:0] = 8'h00;

   	if(gen_wait[7:0] > max_wait[7:0])
   		gen_wait[7:0] = max_wait[7:0];
end
endfunction

always @(posedge clk or negedge reset_b) begin
//
//   if ecconnect1 port connection rule is used then following protocol must be applied
//
     if(ecconnect == 1) begin
//
//   	   if reset is received then initialize data store and counters to all 0's, 
//	   reset flags and internal signals
	   if (reset_b==1'b0) begin
		for (i=0; i<store_size; i=i+1) begin
		   if (bus_width == 32)
			dtstore[i] = 32'h00000000;
		   else if (bus_width == 64)
			dtstore[i] = 64'h0000000000000000;
		   else if (bus_width == 128)
			dtstore[i] = 128'h00000000000000000000000000000000;
		end

	   	ads_flag = 1'b0;
		tmp_rdy_b = 1'b1;
		tmp_retry_b = 1'b1;
		tmp_abort_b = 1'b1;
		if (bus_width == 32)
		   rdt_tmp[bus_width-1:0] = 32'h00000000;
		else if (bus_width == 64)
		   rdt_tmp[bus_width-1:0] = 64'h0000000000000000;
		else if (bus_width == 128)
		   rdt_tmp[bus_width-1:0] = 128'h00000000000000000000000000000000;
		wait_cnt[7:0] = 8'h00;
		size_cnt[7:0] = 8'h00;
		abort_cnt[15:0] = 16'h0000;
		disconnect_cnt[15:0] = 16'h0000;
		retry_cnt[15:0] = 16'h0000;
		j=0;
		cache_wrap_multiplier = (bus_width == 32) ? 4 :
					(bus_width == 64) ? 8 : 16;
		wrap_addr = cache_wrap_multiplier*cache_size;
		if(bus_width == 32)
		   mask_width = 8'h02;
		else if(bus_width == 64)
		   mask_width = 8'h03;
		else
		   mask_width = 8'h04;
		if(cache_size == 4)
		   mask_width = mask_width + 8'h02;
		else if(cache_size == 8)
		   mask_width = mask_width + 8'h03;
		else if(cache_size == 16)
		   mask_width = mask_width + 8'h04;
		rseed1 = 100;
		rseed2 = 3148;
		acc_cntr = 0;
		addr_incr = (bus_width == 32) ? 32'h00000004 :
			(bus_width == 64) ? 32'h00000008 : 32'h00000010;
	   end
	   else begin
//		if ads and cs are received at the same time then initialize size counter, 
//		ads flag, generate wait states and generate rdy_b, abort_b and retry_b 
//		depending on number of wait states and the parameters controlling them
		if ((ads_b==1'b0) && (cs_b==1'b0)) begin
//		   flag indicating ads has been asserted
		   ads_flag = 1'b1;
//		   internal size counter
		   size_cnt[7:0] = size[7:0];
		   get_random(rseed1, rseed2, ran1);
		   get_random(rseed1, rseed2, ran4);
		   acc_cntr = 0;
//		 see if the current access starts at a 32-bit boundary or 64-bit boundary
		   if(addr[2] == 1'b1) 
		   	addr_32_bound = 1'b1;
		   else 
		   	addr_32_bound = 1'b0;
		   wrap_mask[7:0] = 8'h00;
		   for(i=0;i<mask_width;i=i+1) 
			wrap_mask[i] = 1'b1;
		   tmp_addr[31:0] = addr[31:0];
		   tmp1_addr[31:0] = addr[31:0];
		   if ((ran1[1:0]==2'b00) || (ran4[26]==1'b0))
			wait_cnt[7:0] <= #1 8'h00;
		   else begin
		   	wait_cnt[7:0] <= #1 gen_wait(ran1,ran4, test_state);
		   end
		   if ((retry_b == 1'b0) || (abort_b == 1'b0)) begin
			tmp_rdy_b = 1'b1;
			tmp_retry_b = 1'b1;
		   	tmp_abort_b = 1'b1;
		   end
		   else if (wait_cnt[7:0]==8'h00) begin
//		   	if abort assertion is allowed and masked input address bits
//			are same as masked abort address bits assert tmp_abort_b
			if((abort_disable == 1'b0) && 
			  (((abort_start_addr & abort_mask) <= (addr & abort_mask)) &&
			   ((addr & abort_mask) <= (abort_end_addr & abort_mask))))
			begin
			   tmp_rdy_b = 1'b1;
			   tmp_retry_b = 1'b1;
		   	   tmp_abort_b = 1'b0;
		   	   if(~cs_b) abort_cnt[15:0] = abort_cnt[15:0] + 16'h0001;
		   	end
//			if read retry assertion is allowed and the operation is a read OR
//			if write retry assertion is allowed and the operation is a write
//			retry or disconnect transaction depending on random number
			else if ((((rd_retry_disable==1'b0) && (wr==1'b0)) || 
			     ((wr_retry_disable==1'b0) && (wr==1'b1))) && 
				(test_state==32'h00000100) &&
			     (ran1[9:6]==4'b0000)) begin
			   tmp_rdy_b = 1'b0;
			   tmp_retry_b = 1'b0;
			   retry_cnt[15:0] = retry_cnt[15:0] + 16'h0001;
		   	   tmp_abort_b = 1'b1;
			end
			else if ((((rd_retry_disable==1'b0) && (wr==1'b0)) ||
			     ((wr_retry_disable==1'b0) && (wr==1'b1))) && 
				(test_state==32'h00000100) &&
			     (ran1[9:6]==4'b1111)) begin
			   tmp_rdy_b = 1'b1;
			   tmp_retry_b = 1'b0;
			   disconnect_cnt[15:0] = disconnect_cnt[15:0] + 16'h0001;
		   	   tmp_abort_b = 1'b1;
			end
			else begin
			   tmp_rdy_b = 1'b0;
			   tmp_retry_b = 1'b1;
		   	   tmp_abort_b = 1'b1;
		   	   get_random(rseed1, rseed2, ran2);

			   if ((ran2[1:0]==2'b00) || (ran4[26]==1'b0))
				wait_cnt[7:0] <= #1 8'h00;
			   else begin
			   	wait_cnt[7:0] <= #1 gen_wait(ran2,ran4, test_state);
			   end
			end
		   end
//		   decrement non-zero wait count first
//		   no retry, rdy or abort assertion is allowed
		   else begin
			tmp_rdy_b = 1'b1;
			tmp_retry_b = 1'b1;
		   	tmp_abort_b = 1'b1;
			if(wait_cnt[7:0] > 8'h00) wait_cnt[7:0] <= #1 wait_cnt[7:0] - 8'h01;
		   end
//		   read data is valid if it is a read operation and rdy_b is asserted else return x
		   if (wr==1'b0) begin
			if(bus_width == 32)
				rd_init[store_length-1:0] = tmp_addr[store_length+1:2];
			else if(bus_width == 64)
				rd_init[store_length-1:0] = tmp_addr[store_length+2:3];
			else if(bus_width == 128)
				rd_init[store_length-1:0] = tmp_addr[store_length+3:4];

			if (tmp_rdy_b==1'b0) begin
			   rdt_tmp[bus_width-1:0] = dtstore[rd_init];
			   j=j+1;
			 if((((tmp_addr[7:0]+cache_wrap_multiplier*j) & wrap_mask[7:0])
			     == (wrap_mask[7:0] & wrap_addr[7:0])) && 
			   (incr_mode == 1'b0)) j=j-cache_size;
			end
			else begin
			   if(bus_width == 32)
				rdt_tmp[bus_width-1:0] = 32'hxxxxxxxx;
			   else if(bus_width == 64)
				rdt_tmp[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
			   else if(bus_width == 128)
				rdt_tmp[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end
		   end
		end
//		if ads has been asserted, keep track of it using the ads_flag
//		ads_flag is asserted till the terminating conditions
//		rdy_b, retry_b and abort_b are generated whenever there are no
//		wait states and their generation is permitted
		else if (ads_flag==1'b1) begin
			   if(bus_width == 32) begin
				idx[store_length-1:0] = tmp_addr[store_length+1:2] + j;
			   end
			   else if(bus_width == 64) begin
				if(acc_cntr == 0)
				idx[store_length-1:0] = tmp_addr[store_length+2:3] + j;
//				if((be_b[be_width-1:0] == 8'hf0) && (~tmp_rdy_b))
//				if the starting address of the current access starts 
//			    at a 32-bit boundary, then start at the upper 4 bytes
//			    instead of the lower 4 bytes
				if((addr_32_bound == 1'b1) && (acc_cntr == 0)) begin
					    addr_32_bound = 1'b0;
					    acc_cntr = acc_cntr+1;
				end
//				for each rdy_b received in a 32-bit access by a 64-bit target
//			    increment the access counter by 1
//			    the access counter decides which set of bytes will be stored
//			    for the current access
				if(tar64_b && ~tmp_rdy_b)
					acc_cntr = (acc_cntr+1)%3;
			   end
			   else if(bus_width == 128) begin
				idx[store_length-1:0] = tmp_addr[store_length+3:4] + j;
			   end

			   if((cs_b == 1'b1) || ((retry_b == 1'b0) && (bus_width == 32)) ||
				(abort_b == 1'b0) || ((blast_b == 1'b0) && ~rdy_b) ||
				((size_cnt == 8'h01) && ~rdy_b)) begin
				ads_flag = 1'b0;
				tmp_rdy_b = 1'b1;
				tmp_retry_b = 1'b1;
				tmp_abort_b = 1'b1;
				j=0;
			   end
			   else begin
				if (wait_cnt[7:0]==8'h00) begin
				   tmp1_addr = tmp_addr + (j * addr_incr);
				   if((abort_disable == 1'b0) && 
				   (((((abort_start_addr & abort_mask) <= (abort_mask & tmp_addr)) &&
				    ((tmp_addr & abort_mask) <= (abort_end_addr & abort_mask)))) || 
				   ((((abort_start_addr & abort_mask) <= (abort_mask & tmp1_addr)) &&
				    ((tmp1_addr & abort_mask) <= (abort_end_addr & abort_mask))))))
				   begin
					tmp_rdy_b = 1'b1;
					tmp_retry_b = 1'b1;
			   		tmp_abort_b = 1'b0;
			   		if(~cs_b) abort_cnt[15:0] = abort_cnt[15:0] + 16'h0001;
			   	   end
				   else if ((((rd_retry_disable==1'b0) && (wr==1'b0))
					|| ((wr_retry_disable==1'b0) && (wr==1'b1))) &&
					(test_state==32'h00000100) &&
					(ran2[8:5]==4'b0000)) begin
					tmp_rdy_b = 1'b0;
					tmp_retry_b = 1'b0;
					retry_cnt[15:0] = retry_cnt[15:0] + 16'h0001;
			   		tmp_abort_b = 1'b1;
					if(bus_width == 64) get_random(rseed1, rseed2, ran2);
				   end
				   else if ((((rd_retry_disable==1'b0) && (wr==1'b0))
					|| ((wr_retry_disable==1'b0) && (wr==1'b1))) &&
					(test_state==32'h00000100) &&
					(ran2[8:5]==4'b1111)) begin
					tmp_rdy_b = 1'b1;
					tmp_retry_b = 1'b0;
					disconnect_cnt[15:0] = disconnect_cnt[15:0] + 16'h0001;
			   		tmp_abort_b = 1'b1;
					if(bus_width == 64) get_random(rseed1, rseed2, ran2);
				   end
				   else begin
					tmp_rdy_b = 1'b0;
					tmp_retry_b = 1'b1;
			   		tmp_abort_b = 1'b1;
					get_random(rseed1, rseed2, ran2);

					if ((ran2[1:0]==2'b00) || (ran4[26]==1'b0))
					   wait_cnt[7:0] <= #1 8'h00;
					else begin
					  wait_cnt[7:0] <= #1 gen_wait(ran2,ran4, test_state);
					end
				   end
				end
				else begin
				   tmp_rdy_b = 1'b1;
				   tmp_retry_b = 1'b1;
			   	   tmp_abort_b = 1'b1;
				   if(wait_cnt[7:0] > 8'h00) wait_cnt[7:0] <= #1 wait_cnt[7:0] - 8'h01;
				end

				if ((rdy_b==1'b0) || ((~wren_b || rdnxt_b) && (ecconnect == 2)))
				    size_cnt[7:0] = size_cnt[7:0] - 8'h01;
			   end

			   if (wr==1'b0) begin
				if (tmp_rdy_b==1'b0) begin
				   rdt_tmp[bus_width-1:0] = dtstore[idx];
				   j=j+1;
				    if((((tmp_addr[7:0]+cache_wrap_multiplier*j) & wrap_mask[7:0]) == 
				   (wrap_mask[7:0] & wrap_addr[7:0])) && (incr_mode == 1'b0))
					j=j-cache_size;
				end
				else begin
			   	   if(bus_width == 32)
					rdt_tmp[bus_width-1:0] = 32'hxxxxxxxx;
				   else if(bus_width == 64)
					rdt_tmp[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
				   else if(bus_width == 128)
					rdt_tmp[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
				end
			   end
//		   storage of write data allowed IF
//		   write operation, rdy_b is asserted, ads has been asserted, cs_b
//		   is asserted and there are no retries OR
//		   write operation, retry_b and rdy_b asserted at same time and 
//		   cs_b is asserted
//		   write operation, blast_b and rdy_b asserted at same time and cs_b
//		   is asserted
		   else if(((wr==1'b1) && (rdy_b == 1'b0) && (ads_flag == 1'b1) &&
			(cs_b==1'b0) && (retry_b == 1'b1)) || 
		   	((wr==1'b1) && (retry_b == 1'b0) && (rdy_b == 1'b0) &&
		   		(cs_b == 1'b0)) || 
		   	((blast_b == 1'b0) && (rdy_b == 1'b0) && (wr == 1'b1) &&
		   		(cs_b == 1'b0))) begin
			wdt_tmp[bus_width-1:0] = dtstore[idx];

			if (be_b[0]==1'b0)
			   wdt_new[7:0] = dwr[7:0];
			else
			   wdt_new[7:0] = wdt_tmp[7:0];
			if (be_b[1]==1'b0)
			   wdt_new[15:8] = dwr[15:8];
			else
			   wdt_new[15:8] = wdt_tmp[15:8];
			if (be_b[2]==1'b0)
			   wdt_new[23:16] = dwr[23:16];
			else
			   wdt_new[23:16] = wdt_tmp[23:16];
			if (be_b[3]==1'b0)
			   wdt_new[31:24] = dwr[31:24];
			else
			   wdt_new[31:24] = wdt_tmp[31:24];

			if(be_width == 8 || be_width == 16) begin
			   if (be_b[be_width-4]==1'b0)
				wdt_new[bus_width-25:bus_width-32] = dwr[bus_width-25:bus_width-32];
			   else
				wdt_new[bus_width-25:bus_width-32] = wdt_tmp[bus_width-25:bus_width-32];
			   if (be_b[be_width-3]==1'b0)
				wdt_new[bus_width-17:bus_width-24] = dwr[bus_width-17:bus_width-24];
			   else
				wdt_new[bus_width-17:bus_width-24] = wdt_tmp[bus_width-17:bus_width-24];
			   if (be_b[be_width-2]==1'b0)
				wdt_new[bus_width-9:bus_width-16] = dwr[bus_width-9:bus_width-16];
			   else
				wdt_new[bus_width-9:bus_width-16] = wdt_tmp[bus_width-9:bus_width-16];
			   if (be_b[be_width-1]==1'b0)
				wdt_new[bus_width-1:bus_width-8] = dwr[bus_width-1:bus_width-8];
			   else
				wdt_new[bus_width-1:bus_width-8] = wdt_tmp[bus_width-1:bus_width-8];
			end

//			wdt_new is the new data to be stored
//			wdt_tmp is the data already in the store
//			if a 64-bit master is doing a single write to the target
//			and the data being stored is the upper word
//
//			then reload the backup of last_wdt_tmp[63:32] into the 
//			wdt_tmp[63:32]
//
//			load wdt_new[63:32] from wdt_new[31:0] because only the wdt_new[31:0]
//			byte enables are active
//
//			then use the same byte enables to decide which of the bytes
//			in wdt_new[63:32] have to be stored and the other bytes will
//			come from wdt_tmp[63:32]

			if((bus_width == 64) && (acc_cntr == 2)) begin
//				wdt_tmp[63:32] = last_wdt_tmp[31:0];
				wdt_new[63:32] = wdt_new[31:0];
				if(be_b[3] == 1'b1) wdt_new[63:56] = wdt_tmp[63:56];
				if(be_b[2] == 1'b1) wdt_new[55:48] = wdt_tmp[55:48];
				if(be_b[1] == 1'b1) wdt_new[47:40] = wdt_tmp[47:40];
				if(be_b[0] == 1'b1) wdt_new[39:32] = wdt_tmp[39:32];
				wdt_new[31:0] = wdt_tmp[31:0];
			end
//			if a 64-bit master is doing a single write to the target
//			and the data being stored is the lower word (31:0 or acc_cntr = 1)
//
//			then backup wdt_tmp[63:32] in last_wdt_tmp[31:0]
//
//			and also backup wdt_new[31:0] in wdt_new[63:32]
//
//			This process of storage is needed if the data being stored has 
//			a be_b of xf where x is not equal to f
/*
			else if((bus_width == 64) && (acc_cntr == 1)) begin
				last_wdt_tmp[31:0] = wdt_tmp[63:32];
				wdt_new[63:32] = wdt_new[31:0];
				if(be_b[3] == 1'b1) wdt_new[63:56] = wdt_tmp[63:56];
				if(be_b[2] == 1'b1) wdt_new[55:48] = wdt_tmp[55:48];
				if(be_b[1] == 1'b1) wdt_new[47:40] = wdt_tmp[47:40];
				if(be_b[0] == 1'b1) wdt_new[39:32] = wdt_tmp[39:32];
			end
*/			
			dtstore[idx] = wdt_new[bus_width-1:0];
			if((tmp_rdy_b == 1'b0) && (tmp_retry_b == 1'b0));

			if (ads_flag==1'b1)
			begin
				j=j+1;
				if((((tmp_addr[7:0]+cache_wrap_multiplier*j) & wrap_mask[7:0]) ==
				(wrap_mask[7:0] & wrap_addr[7:0])) && (incr_mode == 1'b0))
				 	j=j-cache_size;
			end
		   end
		end
		else begin
		   get_random(rseed1, rseed2, ran3);
		   tmp_abort_b = 1'b1;
		   if (bus_width == 32)
			drd[bus_width-1:0] = 32'hxxxxxxxx;
		   else if (bus_width == 64)
			drd[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
		   else if (bus_width == 128)
			drd[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		   if ((idle_retry_disable==1'b0) && (test_state==32'h00000100)) begin
			if (ran3[3:0]==4'h0)
			   tmp_retry_b = 1'b0;
			else
			   tmp_retry_b = 1'b1;
		   end
		   else begin
			tmp_retry_b = 1'b1;
		   end

		end
	   end
   end
//
// if ecconnect2 port connection rule is used then following protocol must be applied
//
   else if(ecconnect == 2)
   begin
//   	   if reset is received then initialize data store and counters to all 0's, i
//	   reset flags and internal signals
	   if (reset_b==1'b0) begin
		for (i=0; i<store_size; i=i+1) begin
		   if (bus_width == 32)
			dtstore[i] = 32'h00000000;
		   else if (bus_width == 64)
			dtstore[i] = 64'h0000000000000000;
		   else if (bus_width == 128)
			dtstore[i] = 128'h00000000000000000000000000000000;
		end
	   	ads_flag = 1'b0;
		rdy_flag = 1'b0;
		tmp_rdy_b = 1'b1;
		tmp_retry_b = 1'b1;
		tmp_abort_b = 1'b1;
		tmp_done_b = 1'b1;
		if (bus_width == 32)
		   rdt_tmp[bus_width-1:0] = 32'h00000000;
		else if (bus_width == 64)
		   rdt_tmp[bus_width-1:0] = 64'h0000000000000000;
		else if (bus_width == 128)
		   rdt_tmp[bus_width-1:0] = 128'h00000000000000000000000000000000;
		wait_cnt[7:0] = 8'h00;
		size_cnt[7:0] = 8'h00;
		abort_cnt[15:0] = 16'h0000;
		disconnect_cnt[15:0] = 16'h0000;
		retry_cnt[15:0] = 16'h0000;
		j=0;
		cache_wrap_multiplier = (bus_width == 32) ? 4 :
					(bus_width == 64) ? 8 : 16;
		wrap_addr = cache_wrap_multiplier*cache_size;
		if(bus_width == 32)
		   mask_width = 8'h02;
		else if(bus_width == 64)
		   mask_width = 8'h03;
		else
		   mask_width = 8'h04;
		if(cache_size == 4)
		   mask_width = mask_width + 8'h02;
		else if(cache_size == 8)
		   mask_width = mask_width + 8'h03;
		else if(cache_size == 16)
		   mask_width = mask_width + 8'h04;
		rseed1 = 200;
		rseed2 = 4288;
		addr_incr = (bus_width == 32) ? 32'h00000004 :
			(bus_width == 64) ? 32'h00000008 : 32'h00000010;
	   end
	   else begin
//		if ads is received then initialize size counter, ads flag,
//		generate wait states and generate rdy and abort depending on
//		number of wait states and the parameters controlling them
		if ((ads_b==1'b0) && (cs_b==1'b0)) begin
		   ads_flag = 1'b1;
		   tmp_addr[31:0] = addr[31:0];
		   size_cnt[7:0] = size[7:0];
		   get_random(rseed1, rseed2, ran1);
		   get_random(rseed1, rseed2, ran4);
		   wrap_mask[7:0] = 8'h00;
		   for(i=0;i<mask_width;i=i+1) 
			wrap_mask[i] = 1'b1;
		   if ((ran1[1:0]==2'b00) || (ran4[26]==1'b0))
			wait_cnt[7:0] = 8'h00;
		   else begin
		   	wait_cnt[7:0] = gen_wait(ran1,ran4, test_state);
		   end
		   if (wait_cnt[7:0]==8'h00) begin
			tmp_rdy_b = 1'b0;
			rdy_flag = 1'b1;
// 			master read abort or target read abort returns error
			if (wr==1'b0) begin
			   for(i=0;((i<size) && (tmp_abort_b==1'b1));i=i+1) begin
			   	if (bus_width == 32)
				   local_addr = (addr+(i*4));
			   	else if (bus_width == 64)
				   local_addr = (addr+(i*8));
			   	else if (bus_width == 128)
				   local_addr = (addr+(i*16));

				if((abort_disable == 1'b0) && 
				   (((abort_start_addr & abort_mask) <= (abort_mask & local_addr)) &&
				   ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))))
				begin
				   tmp_rdy_b = 1'b0;
				   tmp_retry_b = 1'b1;
				   tmp_abort_b = 1'b0;
				   abort_cnt[15:0] = abort_cnt[15:0] + 16'h0001;
				   rdy_flag = 1'b1;
				end
			   end
			end
			else begin
			   if((abort_disable == 1'b0) && 
				(((abort_start_addr & abort_mask) <= (abort_mask & tmp_addr)) &&
				((tmp_addr & abort_mask) <= (abort_end_addr & abort_mask))))
			   begin
				tmp_rdy_b = 1'b0;
				tmp_retry_b = 1'b1;
				tmp_abort_b = 1'b0;
				abort_cnt[15:0] = abort_cnt[15:0] + 16'h0001;
				rdy_flag = 1'b1;
			   end
			end
		   end
		   else begin
			wait_cnt[7:0] = wait_cnt[7:0] - 8'h01;
		   end

		   if (bus_width == 32)
			rd_init[store_length-1:0] = tmp_addr[store_length+1:2];
		   else if (bus_width == 64)
			rd_init[store_length-1:0] = tmp_addr[store_length+2:3];
		   else if (bus_width == 128)
			rd_init[store_length-1:0] = tmp_addr[store_length+3:4];

//		   load the read data, if tmp_rdy_b is asserted, in case of a read operation 
		   if (wr==1'b0) begin
			if ((tmp_rdy_b==1'b0) && (tmp_abort_b==1'b1)) begin
			   if(~cs_b)
				rdt_tmp[bus_width-1:0] = dtstore[rd_init];
			end
			else begin
			   if(bus_width == 32)
				rdt_tmp[bus_width-1:0] = 32'hxxxxxxxx;
			   else if(bus_width == 64) 
				rdt_tmp[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
			   else if(bus_width == 128)
				rdt_tmp[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end
		   end
		end
//		if ads has been asserted, keep track of it using the ads_flag
//		ads_flag is asserted till the terminating condition is reached
//		rdy_b is asserted for 1 cycle after ads_b assertion, when there
//		are no wait states
//		rdy_flag is used to remember rdy_b assertion
		else if (ads_flag==1'b1) begin
		   if ((wait_cnt[7:0]==8'h00) && (rdy_flag==1'b0)) begin
			tmp_rdy_b = 1'b0;
			rdy_flag = 1'b1;
			tmp1_addr = (tmp1_addr + addr_incr);
// 			master read abort or target read abort returns error
			if (wr==1'b0) begin
			   for(i=0;((i<size) && (tmp_abort_b==1'b1));i=i+1) begin
			   	if (bus_width == 32)
				   local_addr = (addr+(i*4));
			   	else if (bus_width == 64)
				   local_addr = (addr+(i*8));
			   	else if (bus_width == 128)
				   local_addr = (addr+(i*16));

				if((abort_disable == 1'b0) && 
				   (((abort_start_addr & abort_mask) <= (abort_mask & local_addr)) &&
				   ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))))
				begin
				   tmp_rdy_b = 1'b0;
				   tmp_retry_b = 1'b1;
				   tmp_abort_b = 1'b0;
				   abort_cnt[15:0] = abort_cnt[15:0] + 16'h0001;
				   rdy_flag = 1'b1;
				end
			   end
			end
			else begin
			   if((abort_disable == 1'b0) && 
			   ((((abort_start_addr & abort_mask) <= (abort_mask & tmp_addr)) &&
			    ((tmp_addr & abort_mask) <= (abort_end_addr & abort_mask)))) || 
			   ((((abort_start_addr & abort_mask) <= (abort_mask & tmp1_addr)) &&
			    ((tmp1_addr & abort_mask) <= (abort_end_addr & abort_mask)))))
			   begin
				tmp_rdy_b = 1'b0;
				tmp_retry_b = 1'b1;
				tmp_abort_b = 1'b0;
				abort_cnt[15:0] = abort_cnt[15:0] + 16'h0001;
				rdy_flag = 1'b1;
			   end
			end

//			next read data is loaded in advance for a read operation
			if (wr==1'b0) begin
			     if ((tmp_rdy_b==1'b0) && (tmp_abort_b==1'b1)) begin
				if(~cs_b)
				     rdt_tmp[bus_width-1:0] = dtstore[rd_init];
			     end
			     else begin
				if(bus_width == 32)
				   rdt_tmp[bus_width-1:0] = 32'hxxxxxxxx;
				else if(bus_width == 64) 
				   rdt_tmp[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
				else if(bus_width == 128)
				   rdt_tmp[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			     end
			end

		   end
		   else if ((wait_cnt[7:0]==8'h00) && (rdy_flag==1'b1)) begin
			tmp_rdy_b = 1'b1;
			tmp_abort_b = 1'b1;
			tmp1_addr = (tmp1_addr + addr_incr);
//			done_b is asserted immediately after rdy_b assertion for a read operation
			if ((rdy_b==1'b0) && (wr==1'b0)) begin
			   tmp_done_b = 1'b0;
			end
			if (done_b==1'b0) begin
			   tmp_done_b = 1'b1;
			end

			if (abort_b==1'b0) begin
			   ads_flag = 1'b0;
			   rdy_flag = 1'b0;
			   j=0;
			end
			else begin
//			   whenever a rdnxt_b is asserted, load the next read data 
			   if (rdnxt_b==1'b0) begin
				j=j+1;
				idx[store_length-1:0] = rd_init[store_length-1:0];
				idx[store_length-1:0] = idx[store_length-1:0] + j;
// 				last read data
				if ((cs_b==1'b0) && (size_cnt[7:0]==8'h01)) begin
				   if(bus_width ==32)
					rdt_tmp[bus_width-1:0] = 32'hxxxxxxxx;
				   else if(bus_width == 64)
					rdt_tmp[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
				   else if(bus_width == 128)
					rdt_tmp[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
				   ads_flag = 1'b0;
				   rdy_flag = 1'b0;
				   j=0;
				end
				else begin
				   rdt_tmp[bus_width-1:0] = dtstore[idx];
				end
				size_cnt[7:0] = size_cnt[7:0] - 8'h01;
			   end
//			   whenever a wren_b is received, store the write data
//			   then check if the current access is the last access 
			   else if ((wren_b==1'b0) && ~cs_b) begin
				idx[store_length-1:0] = rd_init[store_length-1:0];
				idx[store_length-1:0] = idx[store_length-1:0] + j;
				wdt_tmp[bus_width-1:0] = dtstore[idx];

				if (be_b[0]==1'b0)
				   wdt_new[7:0] = dwr[7:0];
				else
				   wdt_new[7:0] = wdt_tmp[7:0];
				if (be_b[1]==1'b0)
				   wdt_new[15:8] = dwr[15:8];
				else
				   wdt_new[15:8] = wdt_tmp[15:8];
				if (be_b[2]==1'b0)
				   wdt_new[23:16] = dwr[23:16];
				else
				   wdt_new[23:16] = wdt_tmp[23:16];
				if (be_b[3]==1'b0)
				   wdt_new[31:24] = dwr[31:24];
				else
				   wdt_new[31:24] = wdt_tmp[31:24];

				if(be_width == 8) begin
					if (be_b[be_width-4]==1'b0)
					   wdt_new[bus_width-25:bus_width-32] = dwr[bus_width-25:bus_width-32];
					else
					   wdt_new[bus_width-25:bus_width-32] = wdt_tmp[bus_width-25:bus_width-32];
					if (be_b[be_width-3]==1'b0)
					   wdt_new[bus_width-17:bus_width-24] = dwr[bus_width-17:bus_width-24];
					else
					   wdt_new[bus_width-17:bus_width-24] = wdt_tmp[bus_width-17:bus_width-24];
					if (be_b[be_width-2]==1'b0)
					   wdt_new[bus_width-9:bus_width-16] = dwr[bus_width-9:bus_width-16];
					else
					   wdt_new[bus_width-9:bus_width-16] = wdt_tmp[bus_width-9:bus_width-16];
					if (be_b[be_width-1]==1'b0)
					   wdt_new[bus_width-1:bus_width-8] = dwr[bus_width-1:bus_width-8];
					else
					   wdt_new[bus_width-1:bus_width-8] = wdt_tmp[bus_width-1:bus_width-8];
				end

				dtstore[idx] = wdt_new[bus_width-1:0];

// 				last write data
				if ((cs_b==1'b0) && (size_cnt[7:0]==8'h01)) begin
				   tmp_done_b = 1'b0;
				   ads_flag = 1'b0;
				   rdy_flag = 1'b0;
				   j=0;
				end
				else begin
				   j=j+1;
				end
				size_cnt[7:0] = size_cnt[7:0] - 8'h01;
			   end
			end
		   end
		   else begin
			wait_cnt[7:0] = wait_cnt[7:0] - 8'h01;
		   end
		end
		else begin
		   if (done_b==1'b0) tmp_done_b = 1'b1;
		   tmp_abort_b = 1'b1;
		   if(bus_width == 32)
			drd[bus_width-1:0] = 32'hxxxxxxxx;
		   else if(bus_width == 64)
			drd[bus_width-1:0] = 64'hxxxxxxxxxxxxxxxx;
		   else if(bus_width == 128)
			drd[bus_width-1:0] = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		end
	   end

   end
// drive external signals
   rdy_b <= #1 (tmp_rdy_b | cs_b);
   abort_b <= #1 (tmp_abort_b | cs_b);
   done_b <= #1 tmp_done_b;
   retry_b <= #1 tmp_retry_b;
   drd[bus_width-1:0] <= #1 rdt_tmp[bus_width-1:0];
end

endmodule
