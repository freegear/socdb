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
// ahbslave : Standard AHB bus slave device simulation model
//
// Rev 1.0
//
// Root std_tback rev 1.1
//
// ##########################################################################
//
// Parameter Description
// rd_retry_disable
//	Read retry assertion disable.
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b0 (retry not disabled).
// wr_retry_disable
//	Write retry assertion disable.
//	Allowable values 1'b0 and 1'b1. 
//	Default value 1'b0 (retry not disabled).
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
//	"1" in a bit indicates that the bit is don't care.
//	The don't care bit applies to the start, end, and current
//	address. In normal application, only the upper bits should
//	be "1".
//	Default value 32'hffffffff
// bus_width
//	Data bus width
//	Only allowable values is 32
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
//	big_endian		1=big endian, 0=little endian
//	haddr			Address input
//	hburst			burst type
//	hrdata			Read data output
//	hreadyin		ready input
//	hreadyout		ready output
//	hresp			slave response
//	hsel			Chip select
//	hsize			Size input
//	htrans			transfer type
//	hwrite			Write/read
//	hwdata			Write data input
//	reset_b			Reset
//
// ###########################################################################
//
`timescale 1ns / 100ps

module ahbslave(
clk,
big_endian,
haddr,
hburst,
hrdata,
hreadyin,
hreadyout,
hresp,
hsel,
hsize,
htrans,
hwdata,
hwrite,
test_state,
reset_b
);
//retry disable for reads
parameter	rd_retry_disable	= 1'b0; 
//retry disable for writes
parameter	wr_retry_disable	= 1'b0; 
//max. number of wait states
parameter	max_wait		= 8;
//abort start address
parameter	abort_start_addr	= 32'hffffffff; 
//abort end address
parameter	abort_end_addr		= 32'h00000000; 
//abort mask
parameter	abort_mask		= 32'hffffffff; 
//bus width
parameter	bus_width		= 32;
//store size
parameter	store_size		= 1024;
//store size 
parameter	store_length		= 10; 

input			clk;
input			big_endian;
input[31:0]		haddr;
input[2:0]		hburst;
output[bus_width-1:0]	hrdata;
input			hreadyin;
output			hreadyout;
output[1:0]		hresp;
input			hsel;
input[2:0]		hsize;
input[1:0]		htrans;
input[bus_width-1:0]	hwdata;
input			hwrite;
input[31:0]		test_state;
input			reset_b;

reg		        active_flag;
reg			write_flag;
reg[31:0]		write_addr;
reg[2:0]		write_hsize;
reg[bus_width-1:0]	hrdata;
reg[bus_width-1:0]	dtstore[0:store_size-1];
integer			rd_idx;
integer			wr_idx;
reg[31:0]	        ran1;
reg[31:0]	        ran2;
reg			hreadyout;
reg[1:0]		hresp;
integer			abort_cnt;
integer			retry_cnt;
reg[31:0]	        local_addr;
integer			wait_cnt;
integer		        acc_cntr;
integer		        i;
integer		        rseed1;
integer		        rseed2;
reg[2:0]		store_hsize;
reg			store_hwrite;
reg[31:0]		store_haddr;
reg[2:0]		store_hburst;
reg[31:0]		cur_addr;
reg[bus_width-1:0]	rmw_data;
//
// Define AHB encoding value to make design readable
wire[1:0]		value_okay;
wire[1:0]		value_error;
wire[1:0]		value_retry;
wire[1:0]		value_nonseq;
wire[1:0]		value_idle;
wire[1:0]		value_seq;
wire[1:0]		value_busy;
wire[2:0]		value_wrap4;
wire[2:0]		value_wrap8;
wire[2:0]		value_wrap16;
wire[2:0]		value_8bit;
wire[2:0]		value_16bit;
wire[2:0]		value_32bit;

//
// Function to compute the local data storage index from the address
//
// The user should pick the number of bits from the address according
// to address mapping of the system. This function should vary according
// to the test bench setup.
function[31:0] gen_idx;
input[31:0]	addr;

begin
	gen_idx[31:0] = addr[store_length+1:2];
//	$write("idx is %d\n",gen_idx);
end
endfunction

//
// Function to determine if the address is in the abort range
// The abort_mask defines don't care address bits
function in_abort_range;
input[31:0]	cur_addr;

reg[31:0]	local_addr;
reg[31:0]	local_start;
reg[31:0]	local_end;

begin
	local_addr = cur_addr & abort_mask;
	local_start = abort_start_addr & abort_mask;
	local_end = abort_end_addr & abort_mask;
	if ((local_addr >= local_start) && (local_addr <= local_end))
	     in_abort_range = 1'b1;
	else in_abort_range = 1'b0;
end
endfunction

//
//task to generate random number
task get_random;
inout[31:0] s1;
inout[31:0] s2;
output[31:0] ran_valout;
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
    
    ran_valout = z;

end 
endtask

//
// Function to generate number of wait states to generate
// use ran1 to determine the number of wait states
// inserts appropriate number of wait states between 0 and 256
function [31:0] gen_wait;
input[31:0]	r1;
input[31:0]	test_state;
begin
	if (test_state != 32'h00000100) gen_wait =0;
	else if (r1[7:4]==4'b0111) gen_wait = 128;
	else if (r1[7:4]==4'b0110) gen_wait = 64;
	else if (r1[7:4]==4'b0101) gen_wait = 32;
	else if (r1[7:4]==4'b0100) gen_wait = 16;
	else if (r1[7:4]==4'b0011) gen_wait = 8;
	else if (r1[7:4]==4'b0010) gen_wait = 4;
	else if (r1[7:4]==4'b0001) gen_wait = 2;
	else if (r1[7:4]==4'b0000) gen_wait = 1;
	else gen_wait = 0;

	if (gen_wait > max_wait) gen_wait = max_wait;
end
endfunction

//
// Function to generate the address sequence based on starting
// and hburst and hsize
function[31:0]	gen_next_addr;
input[31:0]	start_addr;
input[31:0]	acc_cntr;
input[2:0]	hburst;
input[2:0]	hsize;

reg[31:0]	local_addr;
integer		i;
integer		j;
begin
	gen_next_addr[31:0] = start_addr;
//
// compute base address
	if (hsize==value_8bit) local_addr = start_addr;
	else if (hsize==value_16bit) local_addr = {1'b0, start_addr[31:1]};
	else if (hsize==value_32bit) local_addr = {2'b00, start_addr[31:2]};
	else begin
		$write("Error ***** gen_next_addr, unsupported hsize in AHB slave, %b\n", hsize);
		$stop;
	end
//
// compute the rest of the address
	if (hburst==value_wrap4) local_addr[1:0] = local_addr[1:0] + acc_cntr;
	else if (hburst==value_wrap8) local_addr[2:0] = local_addr[2:0] + acc_cntr;
	else if (hburst==value_wrap16) local_addr[3:0] = local_addr[3:0] + acc_cntr;
	else local_addr = local_addr + acc_cntr;

	if (hsize==value_8bit)
		gen_next_addr = local_addr;
	else if (hsize==value_16bit)
		gen_next_addr = {local_addr[30:0], start_addr[0]};
	else if (hsize==value_32bit)
		gen_next_addr = {local_addr[29:0], start_addr[1:0]};
	else begin
		$write("Error ***** gen_next_addr, unsupported hsize in AHB slave, %b\n", hsize);
		$stop;
	end
end
endfunction

//
// Function to generate new rmw data into data storage
function[bus_width-1:0] gen_rmw_data;
input[bus_width-1:0]	existing_data;
input[bus_width-1:0]	hwdata;
input[31:0]		cur_addr;
input[2:0]		store_hsize;

//
// only the bytes affected according the hsize and 2LSB of address are affected
begin

//$write( "%h %h %h %h\n", existing_data, hwdata, cur_addr, store_hsize);
	gen_rmw_data = existing_data;
//
// 8-bit data
	if (store_hsize==value_8bit) begin
	   if (big_endian==1'b0) begin
		if (cur_addr[1:0]==2'b00) gen_rmw_data[7:0] = hwdata[7:0];
		else if (cur_addr[1:0]==2'b01) gen_rmw_data[15:8] = hwdata[15:8];
		else if (cur_addr[1:0]==2'b10) gen_rmw_data[23:16] = hwdata[23:16];
		else gen_rmw_data[31:24] = hwdata[31:24];
	   end
	   else begin
		if (cur_addr[1:0]==2'b00) gen_rmw_data[31:24] = hwdata[31:24];
		else if (cur_addr[1:0]==2'b01) gen_rmw_data[23:16] = hwdata[23:16];
		else if (cur_addr[1:0]==2'b10) gen_rmw_data[15:8] = hwdata[15:8];
		else gen_rmw_data[7:0] = hwdata[7:0];
	   end
	end
//
// 16-bit data
	else if (store_hsize==value_16bit) begin
	   if (big_endian==1'b0) begin
		if (cur_addr[1:0]==2'b00) gen_rmw_data[15:0] = hwdata[15:0];
		else if (cur_addr[1:0]==2'b10) gen_rmw_data[31:16] = hwdata[31:16];
		else begin
			$write("Error ***** gen_rmw_data, unsupported LSB for 16bit transfer, %b\n", cur_addr[1:0]);
			$stop;
		end
	   end
	   else begin
		if (cur_addr[1:0]==2'b00) gen_rmw_data[31:16] = hwdata[31:16];
		else if (cur_addr[1:0]==2'b10) gen_rmw_data[15:0] = hwdata[15:0];
		else begin
			$write("Error ***** gen_rmw_data, unsupported LSB for 16bit transfer, %b\n", cur_addr[1:0]);
			$stop;
		end
	   end
	end
//
// 32-bit data
	else if (store_hsize==value_32bit) begin
		if (cur_addr[1:0]==2'b00) gen_rmw_data[31:0] = hwdata[31:0];
		else begin
			$write("Error ***** gen_rmw_data, unsupported LSB for 32bit transfer, %b\n", cur_addr[1:0]);
			$stop;
		end
	end
//
	else begin
		$write("Error ***** gen_rmw_data, unsupported hsize, %b\n", store_hsize);
		$stop;
	end
end
endfunction

//
// Function to return read data only for the bytes read
function[bus_width-1:0] gen_read_data;
input[bus_width-1:0]	existing_data;
input[31:0]		cur_addr;
input[2:0]		store_hsize;

begin
	gen_read_data = existing_data;
//
// only the byte(s) specified by hsize and 2LSB of the address
// are read, other bits are "x"
//
// 8-bit data
	if (store_hsize==value_8bit) begin
	   if (big_endian==1'b0) begin
		if (cur_addr[1:0]==2'b00) gen_read_data[31:8] = 24'bx;
		else if (cur_addr[1:0]==2'b01) begin
			gen_read_data[7:0] = 8'bx;
			gen_read_data[31:16] = 16'bx;
		end
		else if (cur_addr[1:0]==2'b10) begin
			gen_read_data[15:0] = 16'bx;
			gen_read_data[31:24] = 8'bx;
		end
		else gen_read_data[23:0] = 24'bx;
	   end
	   else begin
		if (cur_addr[1:0]==2'b00) gen_read_data[23:0] = 24'bx;
		else if (cur_addr[1:0]==2'b01) begin
			gen_read_data[31:24] = 8'bx;
			gen_read_data[15:0] = 16'bx;
		end
		else if (cur_addr[1:0]==2'b10) begin
			gen_read_data[31:16] = 16'bx;
			gen_read_data[7:0] = 8'bx;
		end
		else gen_read_data[31:8] = 24'bx;
	   end
	end
//
// 16-bit data
	else if (store_hsize==value_16bit) begin
	   if (big_endian==1'b0) begin
		if (cur_addr[1:0]==2'b00) gen_read_data[31:16] = 16'bx;
		else if (cur_addr[1:0]==2'b10) gen_read_data[15:0] = 16'bx;
		else begin
			$write("Error ***** gen_read_data, unsupported LSB for 16bit transfer, %b\n", cur_addr[1:0]);
			$stop;
		end
	   end
	   else begin
		if (cur_addr[1:0]==2'b00) gen_read_data[15:0] = 16'bx;
		else if (cur_addr[1:0]==2'b10) gen_read_data[31:16] = 16'bx;
		else begin
			$write("Error ***** gen_read_data, unsupported LSB for 16bit transfer, %b\n", cur_addr[1:0]);
			$stop;
		end
	   end
	end
//
// 32-bit data
	else if (store_hsize==value_32bit) begin
		if (cur_addr[1:0]==2'b00) ;
		else begin
			$write("Error ***** gen_read_data, unsupported LSB for 32bit transfer, %b\n", cur_addr[1:0]);
			$stop;
		end
	end
//
	else begin
		$write("Error ***** gen_read_data, unsupported hsize, %b\n", store_hsize);
		$stop;
	end
end
endfunction

//
// main test program
//
// assign standard values
assign		value_okay = 2'b00;
assign		value_error = 2'b01;
assign		value_retry = 2'b10;
assign		value_nonseq = 2'b10;
assign		value_idle = 2'b00;
assign		value_seq = 2'b11;
assign		value_busy = 2'b01;
assign		value_wrap4 = 3'b010;
assign		value_wrap8 = 3'b100;
assign		value_wrap16 = 3'b110;
assign		value_8bit = 3'b000;
assign		value_16bit = 3'b001;
assign		value_32bit = 3'b010;

always @(posedge clk or negedge reset_b) begin
//
//   	if reset is received then initialize data store and counters to all 0's, 
//	reset flags and internal signals
	if (reset_b==1'b0) begin
		abort_cnt = 0;
		retry_cnt = 0;
		rseed1 = 100;
		rseed2 = 35007;
	   	active_flag = 1'b0;
	   	write_flag = 1'b0;
		hreadyout <= #1 1'b1;
		hresp <= #1 value_okay;
	end
	else begin
//
// process request
		if ((htrans==value_nonseq) && (hsel==1'b1) && (hreadyin==1'b1)) begin
// flag indicating ads has been asserted
// compute all the address of the transfer
		   active_flag = 1;
		   acc_cntr = 0;
		   store_hsize = hsize;
		   store_hwrite = hwrite;
		   store_haddr = haddr;
		   store_hburst = hburst;
		end
//
//		if htrans is seq, continue from previous transfer
		else if ((htrans==value_seq) & (hsel==1'b1) & (hreadyin==1'b1)) begin
		   active_flag = 1'b1;
		end
//
//		if htrans is idle, no more transfer
		else if (htrans==value_idle) begin
		   active_flag = 1'b0;
		end
//
//		if htrans is busy, suspend current operation
		else if (htrans==value_busy) begin
		   active_flag = 1'b0;
		   hreadyout <= #1 1'b1;
		end
// others such as missing hsel or missing hreadyin, treated as idle
		else
		   active_flag = 1'b0;

//
//		determine response to the current active cycle
//
		if (active_flag==1'b1) begin
		   get_random(rseed1, rseed2, ran1);
		   get_random(rseed1, rseed2, ran2);
		   wait_cnt = gen_wait(ran1, test_state);
//
// loop for wait state
		   while (wait_cnt != 0) begin
			hreadyout <= #1 1'b0;
			hresp <= #1 value_okay;
			write_flag <= #1 1'b0;
			wait_cnt = wait_cnt - 1;
			@(posedge clk);
		   end
//
// get address
		   cur_addr = gen_next_addr(store_haddr, acc_cntr, store_hburst, store_hsize);
//
// use random number to determine retry response if retry is allowed
		   if (((~rd_retry_disable & ~store_hwrite) || (~wr_retry_disable & store_hwrite)) &
			(test_state==32'h00000100) &&
			(ran2[31:28]==4'b0000)) begin
				hresp <= #1 value_retry;
				hreadyout <= #1 1'b0;
				write_flag <= #1 1'b0;
				@(posedge clk);
				hreadyout <= #1 1'b1;
		   end
//
// check if address is in the error range
		   else if (in_abort_range(cur_addr)) begin
			hresp <= #1 value_error;
			hreadyout <= #1 1'b0;
			write_flag <= #1 1'b0;
			@(posedge clk);
			hreadyout <= #1 1'b1;
		   end
//
// normal response
		   else begin
			acc_cntr = acc_cntr+1;
			hresp <= #1 value_okay;
//
// write access, store data using rmw in case transfer partial data
			if (store_hwrite) begin
				hreadyout <= #1 1'b1;
				write_flag <= #1 1'b1;
				write_addr <= #1 cur_addr;
				write_hsize <= #1 store_hsize;
			end
// read access
			else begin
				rd_idx = gen_idx(cur_addr);
				hrdata <= gen_read_data(dtstore[rd_idx], cur_addr, store_hsize);

				hreadyout <= #1 1'b1;
				write_flag <= #1 1'b0;
			end
		   end
		end
//
// not active, give normal response
		else begin
			hreadyout <= #1 1'b1;
			hresp <= #1 value_okay;
			hrdata <= #1 32'bx;
			write_flag <= #1 1'b0;
		end
	end
end

always @(posedge clk or negedge reset_b) begin
//
// if reset is received then initialize data store and counters to all 0's, 
// reset flags and internal signals
	if (reset_b==1'b0) begin
		for (i=0; i<store_size; i=i+1) begin
			dtstore[i] = 32'h00000000;
		end
	end
	else begin
		if (write_flag==1'b1) begin
			wr_idx = gen_idx(write_addr);
			rmw_data = gen_rmw_data(dtstore[wr_idx], hwdata, write_addr, write_hsize);
			dtstore[wr_idx] <= #1 rmw_data;
		end
	end
end

endmodule
