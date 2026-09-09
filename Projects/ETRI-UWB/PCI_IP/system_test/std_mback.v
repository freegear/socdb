`ifdef print_all
// debug_info displays simulation progress information wrt access type
// store_info displays storage information
`endif
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
// std_mback : Standard master backend model
//
//
// ###########################################################################
//
// Rev 2.0
//
// Root std_mback Rev 1.1
//
// ##########################################################################
//
// Rev 2.0
// Modification from previous revision
//
// 050521 Added big_endian exclusively used for 8-bit and 16-bit mode
//	  access in AHB bus.
// 030922 Enabled specifying target abort range through abort_start_addr and
//	abort_end_addr parameters
//	Enabled running fixed test through gen_fixed_test
// 030707 Fixed the avail_size generation in randInit for hsize = 2'b00 and
//	hsize = 2'b01
// 030609 Fixed gen_size function in std_mback.v to support equal probability of
//	single and burst of 4 when "004wb" or "004wc" are specified for size_str
// 030606 Added 64-bit support for mtrwrite and compare_rd_data
// 030606 Fixed compare_rd_data bug when size = 8'h01 for 32-bit data comparison
// 030603 Fixed simultaneous target abort and master abort handling
// 030529 Fixed index increment for hsize = 00 and hsize = 01 in compare_rd_data
//	and mtrwrite functions
// 030527 Re-organized code into user modifiable and non-user modifiable areas
//	Fixed issues with ecconnect2 timing
// ##########################################################################
//
// Rev 1.1
// Modification from previous revision
//
// 030130 Added gen_size64 function to decide if the current transfer is a
//	  single 64 bit transfer and hence needing special handling
//	  Also modified function compare_rd_data to handle this case
// ##########################################################################
//
// Brief Description
//
// This is the Standard master backend model.
// It issues different types of requests to different target devices on the same
// bus and any other buses. Also can initiate configuration of devices
//
// ##############################################################################
//
// Using this module
//
// 1) The user is allowed to customize certain functions to suit their requirements.
//    **IMPORTANT** please change the following functions before proceeding further.
//    configure		 : to configure devices connected to the core.
//    gen_fixed_test	 : to perform fixed tests before kicking off random tests
//    gen_signal_str     : to program the strings, used to generate of various signals
//    gen_store_retrieve : to program storage areas to particular chipselect lines
//    gen_sideband	: to generate necessary sideband signals
//    runTest	    : to run the test
//
//    **IMPORTANT** code appearing in each of the above functions is supposed to only
//    serve as a template to assist you to understand the working of the function
//
// 2) Update (if necessary) the parameters cache_size and cache_disable.
//    **IMPORTANT** the parameter cache_size has to be the same as the
//    parameter of the same name in std_tback. The cache size register in
//    the host bridge has to be initialized correctly.
//    Please see procedure "configure".
// 3) This version supports instantiating 2 std_mback in the system level
//    testing. Each master should have different value in master_id. Only one
//    instance should have config_enable = 1 and other should have config_enable = 0.
//    See procedure "gen_addr" & "configure" for more info.
// 4) Procedure "configure" does the configuration of all devices.  It
//    needs to be updated according to the user specification.
// 5) Error handling is done via the isAbort flag. This is generated in the gen_addr
//    function and is set for abort conditions. Aborts are forced by the master based
//    on the address. Whenever an abort condition is created by the user, care must be
//    taken to set the isAbort flag.
// 6) The num_cs parameter controls storage and address generation. Assuming num_cs = 6
//    The access_cnt0,..,access_cnt5 is a counter of number of accesses to each area
//    specified by the corresponding cs_b line.
//    base0,..,base5 is the base address for accessing the areas specified by the
//    corresponding cs_b line.
//    store0,..,store5 is the storage area for accessing data for the area specified
//    by the corresponding cs_b line.
//
// #############################################################################
//
// Signal Description
//
//	clk			System clock
//	addr			Address output to master model
//	ads_b			Address strobe, request for master access
//	be_b			Byte enable output to master model
//	blast_b			Burst Last signal output
//	cacheline		Cacheline wrap/linear increment mode
//	done_b			Master request done
//	drd			Data input from master model
//	dwr			Data output to master model
//	err_b			Error input from master model
//	hsize			Data transfer width output
//	rdy_b			Master access ready
//	rdnxt_b			Request for next read data
//	size			Master transfer size output to master model
//	wait_b			Master insert wait state
//	wr			Master read/write output to master model
//	wren_b			Request for next write data
//	reset_b			System reset
//
// #############################################################################
//
// Parameter Definition
// base0, base1, base2, base3, base4, base5
//	Base address parameters, defined one per cs_b line
//	Allowable values: Any legal 32-bit value
// bus_width
//	Size of data bus
//	Allowable values: 32 and 64
//	Default value: 32
// be_width
//	Size of byte enable signal
//	Allowable values: 4 and 8
//	Default value: 4
//
// boundary_cross
//	Parameter to decide whether address boundary crossing must be allowed for
//	current master. Enable this feature only if an "address boundary cross"
//	access does NOT spillover into another master's area.
//	Allowable values : 0 (disable) and 1 (enabled)
//	Default value : 0 (disable)
//
// cache_disable
//	Flag to control access mode
//	Allowable values: 1'b0(cache enabled) and 1'b1 (cache disabled)
//	Default value: 1'b1 (cache disabled)
// cache_size
//	Size of cache access
//	Allowable values: 1,4,8,16
//	Default value = 8
// config_enable
//	Flag to decide if current master should be used to do configuration.
//	Allowable values: 1'b1 (enable) and 1'b0 (disable)
//	Default value = 1'b0 (disable)
// done_flag
//	Flag to indicate if done_b signal is connected to the master backend.
//	This is used to decrement the local transfer counter if there is no
//	done_b signal.
//	Allowable values: 1'b0(done_b connected) and 1'b1 (done_b not connected)
//	Default value = 1'b1 (done_b is not connected)
//	Please refer gen_new_datacnt function for details
// ecconnect
//	Flag to decide between EC connect1 and EC connect2
//	Allowable values: 1 (EC connect1) and 2 (EC connect2)
//	Default value = 1 (EC connect1)
//
// ecconnect2_early_terminate
//	Flag to enable/disable early burst termination in ecconnect2
//	This flag is used with h_fast signal
//	Allowable values : 1'b0 (disable) and 1'b1 (enable)
//	Default value = 1'b1 (enable)
//
// load_cache_flag
//	Flag to decide what will be the cache size value -- transfer size or cache
//	size parameter
//	Allowable values: 1'b0 (transfer size) and 1'b1 (cache size)
//	Default value = 1'b1 (cache size)
//	Please refer gen_cache_size function for details
// master_id
//	Current master's id
//	Allowable values: Any legal 2-bit number.
//	length can be expanded to include more masters
//	Default value = 3'b000
// num_cs
//	Number of chip select lines
//	Allowable values: Any number >=1 and <= 16
//	Default value: 6
// store_length
//	store_size = 2**store_length
//	Bit length of the store size parameter
//	Allowable values: Any legal value >= 0
//	This value should change in conjunction with the store_size parameter
//	Default value = 10
// store_size
//	Size of the data stores
//	Allowable values: Any legal value >= 1
//	Default value = 1024
// abort_start_addr
//	Starting 32-bit word address of abort range
//	Allowable values: Any legal value of length equal to address width
//	Default value = 32'hffffffff
// abort_end_addr
//	Ending 32-bit word address of abort range
//	Allowable values: Any legal value of length equal to address width
//	Default value = 32'h00000000
// abort_mask
//	32-bit word mask on abort address
//	Allowable values: Any legal value of length equal to address width
//	Default value = 32'hffffffff
// big_endian
//	endian setting, 1=big endian, 0=little endian
//	This parameter is used exclusively for AHB bus in 8-bit and 16-bit mode
//	access. Default value should be used for other bus (32-bit) since it is
//	supposed to be don't care.
//	Default value = 1'b0;
//
// #############################################################################
//
// Description of random numbers used in standard master backend model
//
// ran1[31:30]  --  Used to generate hsize in function gen_hsize
// ran1[29:22]  --  Used to generate size in function gen_size
// ran1[21:14]  --  Used to generate rbe_b in function gen_rbe_b
// ran1[13:12]  --  Used to generate addr[1:0] in function gen_addr1_0
// ran1[11]     --  Used to generate cacheline wrap mode in function gen_cache
// ran1[6:3]    --  Used to generate cs_b in function gen_cs_b
// ran1[0]	--  Used to select read or write operation
// ran2[3:0]    --  Used to setup transfers
// ran2[11:4]   --  Used to generate wait states in task insert_wait
// ran2[31:16]  --  Used by task randInit
//
// Following tasks/functions generate their own random numbers due to
// large amount of randomness or unpredictable length of random values
// or to keep the interface simple
//
// gen_signal_string -- unpredictable length of random values
// gen_wdata	 -- many random values needed
// gen_wbe_b	 -- many random values needed
// mtrread	   -- for interface simplicity
// mtrwrite	  -- for interface simplicity
//
// #############################################################################
//
`timescale 1ns / 100ps

module std_mback(
clk,
big_endian,
addr,
ads_b,
be_b,
blast_b,
cacheline,
cs_b,
done_b,
drd,
dwr,
err_b,
h_cmd,
h_mio,
hsize,
rdnxt_b,
rdy_b,
size,
wait_b,
wr,
wren_b,
mtrdone,
test_state,
reset_b
);

parameter abort_start_addr = 32'hffffffff;
parameter abort_end_addr   = 32'h00000000;
parameter abort_mask	   = 32'hffffffff;
parameter base0	   = 32'h00001000;
parameter base1	   = 32'h12040000;
parameter base2	   = 32'h10000000;
parameter base3	   = 32'haf000000;
parameter base4	   = 32'h00080000;
parameter base5	   = 32'h000c0000;
parameter base6	   = 32'haf100000;
parameter base7	   = 32'h000c0000;
parameter base8	   = 32'h000c0000;
parameter base9	   = 32'h000c0000;
parameter base10	   = 32'h000c0000;
parameter base11	   = 32'h000c0000;
parameter base12	   = 32'h000c0000;
parameter base13	   = 32'h000c0000;
parameter base14	   = 32'h000c0000;
parameter base15	   = 32'h000c0000;
parameter be_width	   = 4;
parameter boundary_cross   = 1'b0;
parameter bus_width	   = 32;
parameter done_flag	= 1'b1;
parameter cache_disable    = 1'b1;
parameter cache_size	   = 8;
parameter load_cache_flag  = 1'b1;
parameter config_enable    = 1'b0;
parameter ecconnect	   = 1;
parameter master_id	   = 3'b000;
parameter num_cs	   = 6;
parameter store_length	   = 10;
parameter store_size	   = 1024;
parameter ecconnect2_early_terminate = 1'b1;

input			clk;
input			big_endian;
output[31:0]		addr;
output			ads_b;
output[be_width-1:0]  be_b;
output			blast_b;
output			cacheline;
output[num_cs-1:0]    cs_b;
input			done_b;
input[bus_width-1:0]  drd;
output[bus_width-1:0] dwr;
input			err_b;
output[1:0]	   h_cmd;
output		h_mio;
output[1:0]		hsize;
output			rdnxt_b;
input			rdy_b;
output[15:0]		size;
output			wait_b;
output			wr;
output			wren_b;
output			mtrdone;
input[31:0]		test_state;
input			reset_b;

reg[31:0]		addr;
reg			ads_b;
reg[be_width-1:0]     be_b;
reg			blast_b;
reg			cacheline;
reg[num_cs-1:0]		cs_b;
reg[bus_width-1:0]    dwr;
reg[1:0]		h_cmd;
reg		   h_mio;
reg[1:0]		hsize;
reg			rdnxt_b;
reg[15:0]		size;
reg			wait_b;
reg			wr;
reg			wren_b;

//
// one store area for each cs. The number of local storage
// space has to match with num_cs parameter.
//
reg[bus_width-1:0]    store0[0:store_size-1];
reg[bus_width-1:0]    store1[0:store_size-1];
reg[bus_width-1:0]    store2[0:store_size-1];
reg[bus_width-1:0]    store3[0:store_size-1];
reg[bus_width-1:0]    store4[0:store_size-1];
reg[bus_width-1:0]    store5[0:store_size-1];
reg[bus_width-1:0]    store6[0:store_size-1];
//

reg[31:0]		tmp_addr;
reg			tmp_cacheline;
reg[7:0]		tmp_size;
reg[num_cs-1:0]		tmp_cs_b;
reg[1:0]		tmp_hsize;
reg[be_width-1:0]     tmp_rbe_b;
reg[be_width-1:0]     wbe_b[0:255];
reg[bus_width-1:0]    rdata[0:255];
reg[bus_width-1:0]    wdata[0:255];
reg[31:0]		ran1;
reg[31:0]		ran2;
reg[31:0]		ran5;
reg[31:0]	     rand_addr_bits;
reg		   rw_sel;
reg			noStore;
reg[7:0]		trfr_count;
reg[31:0]	     avail_size;
reg			zerodata;
reg			mtrdone;
integer		expect_rdy_cnt;
integer		ecconnect2_wait_states;

// Counters
reg[19:0]		linear_cnt;
reg[19:0]		cacheline_cnt;
reg[19:0]		mabort_cnt;
reg[19:0]	     tabort_cnt;
reg[19:0]	     boundary_cross_cnt;
reg[19:0]	     boundary_acc_cnt;
reg[19:0]	     burst_mid_err_cnt;
reg[19:0]	     early_terminate_cnt;
reg[19:0]	     master_trfr_terminate_cnt;

//counters to count number of access to particular target area
//indicated by cs_b -- maximum number of counters possible is 16
reg[19:0]		access_cnt0;
reg[19:0]		access_cnt1;
reg[19:0]		access_cnt2;
reg[19:0]		access_cnt3;
reg[19:0]		access_cnt4;
reg[19:0]		access_cnt5;
reg[19:0]		access_cnt6;
reg[19:0]		access_cnt7;
reg[19:0]		access_cnt8;
reg[19:0]		access_cnt9;
reg[19:0]		access_cnt10;
reg[19:0]		access_cnt11;
reg[19:0]		access_cnt12;
reg[19:0]		access_cnt13;
reg[19:0]		access_cnt14;
reg[19:0]		access_cnt15;

//counters to indicate accesses of a particular type
reg[19:0]		wr_cnt;
reg[19:0]		rd_cnt;

// Temporary variables
integer			k;
integer			rseed1;
integer			rseed2;

//
// #############################################################################
//
// Function to generate tmp_cs_b
//
// After generating cs_b, a counter corresponding to the area being accessed
// is incremented to reflect number of accesses to the area
//
// #############################################################################
//
function[num_cs-1:0] gen_cs_b;
input[3:0]	     ran1;
reg[15:0]	     tmp_cs_b;
begin

   tmp_cs_b = 16'b1111111111111111;

// If master_id=3'b100, it is the DMA port, so only allow access to the cs_b1 or 2.
   if (master_id == 3'b100) begin
   // I/O space in PCI target
	if (ran1[3] == 1'b0)
	   tmp_cs_b[1] = 1'b0;
   // memory space in PCI target
	else
	   tmp_cs_b[2] = 1'b0;
   end
// config space in PCI
   else if ((ran1[2:0] == 3'b000) && ((master_id == 3'b000) || (master_id == 3'b011)))
	tmp_cs_b[0] = 1'b0;
// CONFIG_ADDR access
   else if ((ran1[2:0] == 3'b100) && (config_enable == 1'b1))
	tmp_cs_b[4] = 1'b0;
// CONFIG_DATA access
   else if ((ran1[2:0] == 3'b101) && (config_enable == 1'b1))
	tmp_cs_b[5] = 1'b0;
// I/O space in PCI target
   else if (ran1[2:0] == 3'b001)
	tmp_cs_b[1] = 1'b0;
// memory space in PCI target
   else if ((ran1[2:0] == 3'b010) || (ran1[2:0] == 3'b110))
	tmp_cs_b[2] = 1'b0;
// AHB slave 1
   else if ((ran1[2:0] == 3'b011) || (ran1[2:0] == 3'b111))
	tmp_cs_b[3] = 1'b0;
// AHB slave 2
   else
	tmp_cs_b[6] = 1'b0;

   gen_cs_b[num_cs-1:0] = tmp_cs_b[num_cs-1:0];
end
endfunction

//
//##############################################################################
//
// Task to specify the strings for various signals
//
//##############################################################################
//
task gen_signal_string;
inout[num_cs-1:0] tmp_cs_b;
//rw_sel specifies whether the current operation is a read or a write
//1 is a write and 0 is a read
input	     rw_sel;
//random number used to specify the random bits in the address in address generation
//task. use this variable to trigger specific conditions related to address
inout[31:0]	rand;
//address string
output[255:0]     addr_str;
//address[1:0] string
output[7:0]	addr1_0_str;
//cache line wrap mode flag
output[7:0]	cache_str;
//config access flag
output	    config_acc_flag;
//access width string
output[15:0]	hsize_str;
//read byte enable string
output[15:0]	  rbe_b_str;
//transfer size string
output[31:0]	size_str;
//write byte enable string
output[15:0]	  wbe_b_str;
output[7:0]	access_str;
output[7:0]	store_str;
output[bus_width-1:0]	config_addr_value;
inout[31:0]	rseed1;
inout[31:0]	rseed2;
integer	   local_rand;
begin

//   ****************************************************************************
//   PLEASE READ THE FOLLOWING BEFORE USING THIS FUNCTION
//
//   ADDR_STR -- ADDRESS STRING
//   This string contains a sequence of 32 characters specifying the address bits.
//   The allowable characters are
//   0 : bit with value 0
//   1 : bit with value 1
//   b : base address bit
//   m : master id bit
//   r : bit with a random value
//
//   the 'r' bits in the address string will translate into random values in
//   gen_addr function. These random values will be picked up from the addr_rand
//   variable generated in this function.
//
//
//   SIZE_STR -- TRANSFER SIZE STRING
//   The string is of the format "ddd[rw]", where
//   'd' is a decimal digit (0-9)
//   The value of 'ddd' is the maximum possible transfer size
//   Current maximum allowable value of ddd is 255
//   'r' is used to generate a random transfer size between 1 and ddd
//   'w' is used to generate a transfer size that is either 1 or a power of 2
//	(excluding 2) between 1 and ddd
//   NOTE: Only one of 'r' or 'w' must be used.
//
//
//   HSIZE_STR -- ACCESS WIDTH STRING
//   The string can be one of the following -- "00" "01" "10" "rr" "0r" "r0" "1r" "r1"
//   An 'r' is used for random access width
//   The illegal hsize value of 2'b11 is not generated
//
//
//   WBE_B_STR -- WRITE BYTE ENABLE STRING
//   The string can be one of the following "r0" "c0" "00" "rv" "cv" "0v" "rb" "cb" "0b"
//   'r' is used for random byte enables in a single transfer
//   'c' is used for contiguous byte enables in a single transfer
//   '0' is used for a byte enable of all 0's
//   'v' is used for random byte enables in a burst transfer
//   'b' is used for contiguous byte enables in a burst transfer
//   Note : For testing AHB bus, the pattern should be "00" with different hsize to exercise
//	  partial byte enable.
//
//
//   RBE_B_STR -- READ BYTE ENABLE STRING
//   The string can be one of the following "r0" "c0" "00"
//   'r' is used for random byte enables in a single transfer
//   'c' is used for contiguous byte enables in a single transfer
//   '0' is used for a byte enable of all 0's
//   Note : For testing AHB bus, the pattern should be "00" with different hsize to exercise
//	  partial byte enable.
//
//
//   ADDR1_0_STR -- ADDR[1:0] BITS GENERATION STRING
//   The string can be one of the following "0" "b" "r"
//   '0' is used for addr[1:0] = 2'b00
//   'b' is used for addr[1:0] that follow the byte enable
//   'r' is used for addr[1:0] that is generated randomly
//   'c' is used for addr[1:0] to be left unchanged/constant
//   Note : When 'b' is used, hsize_str must be "10".
//
//
//   CACHE_STR -- CACHELINE ACCESS STRING
//   The string can be one of the following "c", "d", "l"
//   'c' is used for cacheline wrap mode only
//   'd' is used for cacheline wrap mode and linear increment mode
//   'l' is used for linear increment mode only
//
//
//   ACCESS_STR -- ACCESS TYPE STRING
//   The string can be one of the following "0", "1", "2", "3", "4", "5"
//   "0" : number of rdy is not deterministic
//   "1" : number of rdy matches with transfer size
//   "2" : receives rdy till hitting abort range
//	 starting address AND transfer size are always preserved
//   "3" : no rdy for the entire transfer when stepping into the abort range
//	 starting address AND transfer size are always preserved
//   "4" : receives rdy till hitting abort range
//	 starting address is preserved AND
//	 transfer size is promoted to 4, 8 or 16 during cache wrap mode
//   "5" : no rdy for the entire transfer when stepping into the abort range
//	 starting address is rearranged to the beginning of cacheline AND
//	 transfer size is promoted to 4, 8 or 16 during cache wrap mode
//
//
//   STORE_STR -- STORE TYPE STRING
//   The string can be one of the following "0", "1", "2"
//   "0" : entire transfer are not stored because the starting address is beyond
//	 the address boundary
//   "1" : data are stored according to the number of rdy received
//   "2" : entire transfer are not stored when bursting from abort range back to
//	 normal range due to the rearrangement of the starting address to the
//	 beginning of the cacheline during cache wrap mode
//	 otherwise, data are stored according to the number of rdy received
//
//
//   CONFIG_ACC_FLAG -- CONFIG ACCESS FLAG
//   This flag has to be set if the master wants to access the config_addr area
//
//   rand -- address generation random value input
//   this is the random number used to specify the random bits in the address
//   in address generation task. use this variable to trigger specific conditions
//   related to address
//
//   ****************************************************************************


     config_acc_flag = 1'b0;
     get_random(rseed1, rseed2, local_rand);

//   config space in PCI target from PCI bus
     if(tmp_cs_b[0] == 1'b0) begin
	addr_str = "bbbbbbbbbbbbbbbbbbbbbbbb11mrrr00";
	size_str = "001r";
	hsize_str = "10";
	addr1_0_str = "0";
	wbe_b_str = "r0";
	rbe_b_str = "r0";
	cache_str = "l";
	access_str = "1";
	store_str = "1";
     end
//   I/O space in PCI target from CPU/PCI bus
     else if(tmp_cs_b[1] == 1'b0) begin
//	 master abort programming
	   if((local_rand[27:24] == 4'b0100) &&
		((master_id == 3'b000) || (master_id == 3'b011))) begin
		addr_str = "1111rrrrrrrr0100000000mmrrr1rr00";
		store_str = "0";
	   end
//	 target abort programming
	   else if(local_rand[27:24] == 4'b0101) begin
		addr_str = "bbbbbbbbbbbb0100000mmm0rrrrrrr00";
//	     force the starting address to lie within abort range
		rand[6:4] = 3'b001;
		store_str = "1";
	   end
//	 normal access
	   else begin
		addr_str = "bbbbbbbbbbbb0100000mmm0rrrrrrr00";
		store_str = "1";
	   end

	   if ((master_id == 3'b000) || (master_id == 3'b011)) begin
		size_str = "008r";
		hsize_str = "10";
		addr1_0_str = "b";
		wbe_b_str = "rv";
		rbe_b_str = "r0";
		cache_str = "l";
		if (rw_sel == 1'b0)
		  access_str = "2";
		else
		  access_str = "0";
	   end
	   else if ((master_id == 3'b001) || (master_id == 3'b010)) begin
		size_str = "016r";
		hsize_str = "rr";
		addr1_0_str = "r";
		wbe_b_str = "00";
		rbe_b_str = "00";
		cache_str = "l";
		if (rw_sel == 1'b0)
		  access_str = "5";
		else
		  access_str = "1";
	   end
	   else if (master_id == 3'b100) begin
		size_str = "016r";
		hsize_str = "10";
		addr1_0_str = "b";
		wbe_b_str = "cb";
		rbe_b_str = "c0";
		cache_str = "l";
		if (rw_sel == 1'b0)
		  access_str = "3";
		else
		  access_str = "1";
	   end
     end
//   memory space in PCI target
     else if(tmp_cs_b[2] == 1'b0) begin
//	 master abort programming
	   if((local_rand[19:16] == 4'b0100) &&
		((master_id == 3'b000) || (master_id == 3'b011))) begin
		addr_str = "1111rrrrrrrr0000000000mmrrr1rr00";
		store_str = "0";
	   end
//	 target abort programming
	   else if(local_rand[19:16] == 4'b0101) begin
		addr_str = "bbbbbbbbbbbb0000000mmm0rrrrrrr00";
//	     force the starting address to lie within abort range
		rand[6:4] = 3'b001;
		store_str = "1";
	   end
//	 normal access
	   else begin
		addr_str = "bbbbbbbbbbbb0000000mmm0rrrrrrr00";
		store_str = "1";
	   end

	   if ((master_id == 3'b000) || (master_id == 3'b011)) begin
//	     25% of write conditions are promoted to meet mwi command requirements
		if ((rw_sel == 1'b1) && (local_rand[15:14] == 2'b11)) begin
		   size_str = "032w";
		   wbe_b_str = "00";
		   rbe_b_str = "00";
		   cache_str = "l";
		end
		else begin
		   size_str = "008r";
		   wbe_b_str = "rv";
		   rbe_b_str = "r0";
		   cache_str = "d";
		end
		hsize_str = "10";
		addr1_0_str = "c";
		if (rw_sel == 1'b0)
		  access_str = "2";
		else
		  access_str = "0";
	   end
	   else if ((master_id == 3'b001) || (master_id == 3'b010)) begin
		size_str = "016r";
		hsize_str = "rr";
		addr1_0_str = "r";
		wbe_b_str = "00";
		rbe_b_str = "00";
		cache_str = "d";
		if (rw_sel == 1'b0)
		  access_str = "5";
		else
		  access_str = "1";
	   end
	   else if (master_id == 3'b100) begin
		size_str = "016r";
		hsize_str = "10";
		addr1_0_str = "b";
		wbe_b_str = "cb";
		rbe_b_str = "c0";
		cache_str = "l";
		if (rw_sel == 1'b0)
		  access_str = "3";
		else
		  access_str = "1";
	   end
     end
//   AHB bus slave model 1
     else if(tmp_cs_b[3] == 1'b0) begin
	   addr_str = "bbbbbbbbbbbbbbbb0bbmmm0rrrrrrr00";
	   if ((master_id == 3'b001) || (master_id == 3'b010)) begin
		size_str = "016r";
		hsize_str = "rr";
		addr1_0_str = "0";
		wbe_b_str = "00";
		rbe_b_str = "00";
		cache_str = "d";
		store_str = "2";
		if (rw_sel == 1'b0)
		  access_str = "4";
		else
		  access_str = "1";
	   end
	   else if ((master_id == 3'b000) || (master_id == 3'b011)) begin
//	     25% of write conditions are promoted to meet mwi command requirements
		if ((rw_sel == 1'b1) && (local_rand[13:12] == 2'b11)) begin
		   size_str = "032w";
		   wbe_b_str = "00";
		   rbe_b_str = "00";
		   cache_str = "l";
		end
		else begin
		   size_str = "016r";
		   wbe_b_str = "rv";
		   rbe_b_str = "r0";
		   cache_str = "d";
		end
		hsize_str = "10";
		addr1_0_str = "c";
		store_str = "1";
		if (rw_sel == 1'b0)
		  access_str = "2";
		else
		  access_str = "1";
	   end
     end
//   CONFIG_ADDR register from CPU bus
     else if(tmp_cs_b[4] == 1'b0) begin
	addr_str = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
//	must be 4 byte access
	size_str = "001w";
	hsize_str = "10";
	addr1_0_str = "0";
	wbe_b_str = "00";
	rbe_b_str = "00";
	cache_str = "l";
	config_acc_flag = 1'b1;
//	only bits [5:2] are modifiable
//	Device Number 1 => IDSEL = AD[12] for PCI target device
	config_addr_value[31:8] = 24'h800008;
	config_addr_value[7:6] = 2'b10;
	config_addr_value[5:4] = master_id[1:0];
	config_addr_value[3:2] = local_rand[1:0];
	config_addr_value[1:0] = 2'b00;
	store_str = "1";
	access_str = "1";
     end
//   CONFIG_DATA register from CPU bus
     else if(tmp_cs_b[5] == 1'b0) begin
	addr_str = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
	size_str = "001w";
	hsize_str = "rr";
	addr1_0_str = "r";
	wbe_b_str = "00";
	rbe_b_str = "00";
	cache_str = "l";
	store_str = "1";
	access_str = "1";
     end
//   AHB bus slave model 2
     else if(tmp_cs_b[6] == 1'b0) begin
	   addr_str = "bbbbbbbbbbbbbbbb1bbmmm0rrrrrrr00";
	   if ((master_id == 3'b001) || (master_id == 3'b010)) begin
		size_str = "016r";
		hsize_str = "rr";
		addr1_0_str = "0";
		wbe_b_str = "00";
		rbe_b_str = "00";
		cache_str = "d";
		store_str = "2";
		if (rw_sel == 1'b0)
		  access_str = "4";
		else
		  access_str = "1";
	   end
	   else if ((master_id == 3'b000) || (master_id == 3'b011)) begin
//	     25% of write conditions are promoted to meet mwi command requirements
		if ((rw_sel == 1'b1) && (local_rand[11:10] == 2'b11)) begin
		   size_str = "032w";
		   wbe_b_str = "00";
		   rbe_b_str = "00";
		   cache_str = "l";
		end
		else begin
		   size_str = "016r";
		   wbe_b_str = "rv";
		   rbe_b_str = "r0";
		   cache_str = "d";
		end
		hsize_str = "10";
		addr1_0_str = "c";
		store_str = "1";
		if (rw_sel == 1'b0)
		  access_str = "2";
		else
		  access_str = "1";
	   end
     end
end
endtask

//
// ###########################################################################
//
// Task to generate storage area index for fixed testing
//
// Takes access address and chipselect as input an generates the storage
// index as output
//
// ###########################################################################
//
function[31:0] gen_storage_idx;
input[31:0]	tmp_addr;
input[num_cs-1:0]  tmp_cs_b;
reg[255:0]	 addr_str;
reg[7:0]	   local_str;
integer	    i;
integer	    j;
integer	    rand_idx;
begin
//  config space in PCI target from PCI bus
     if(~tmp_cs_b[0]) begin
	addr_str = "bbbbbbbbbbbbbbbbbbbbbbbb11mrrr00";
     end
//  I/O space in PCI target from CPU/PCI bus
     else if(~tmp_cs_b[1]) begin
	addr_str = "bbbbbbbbbbbb0100000mmm0rrrrrrr00";
     end
//  memory space in PCI target
     else if(~tmp_cs_b[2]) begin
	addr_str = "bbbbbbbbbbbb0000000mmm0rrrrrrr00";
     end
//  AHB bus slave model 1
     else if(~tmp_cs_b[3]) begin
	addr_str = "bbbbbbbbbbbbbbbb0bbmmm0rrrrrrr00";
     end
//  CONFIG_ADDR register from CPU bus
     else if(~tmp_cs_b[4]) begin
	addr_str = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
     end
//  CONFIG_DATA register from CPU bus
     else if(~tmp_cs_b[5]) begin
	addr_str = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
     end
//  AHB bus slave model 2
     else if(~tmp_cs_b[6]) begin
	addr_str = "bbbbbbbbbbbbbbbb1bbmmm0rrrrrrr00";
     end

    rand_idx = 0;
    gen_storage_idx[31:0] = 32'h00000000;

//  loop to grab the characters in the address string
    for(i=0;i<32;i=i+1) begin
	for(j=0;j<8;j=j+1) begin
		local_str[j] = addr_str[i*8+j];
	end
	case(local_str)
//		character is 'm' or a master id bit
		"m" : begin
			    end
//		character is 'r' or a bit with a random value
		"r" : begin
			gen_storage_idx[rand_idx] = tmp_addr[i];
			rand_idx = rand_idx+1;
		    end
//		character is 'b' or a base address bit
		"b" : begin
			    end
//		character is '0' or a bit with a value 0
		"0" : begin
			    end
//		character is '1' or a bit with a value 1
		"1" : begin
			    end
	endcase
    end
end
endfunction

//
// ##########################################################################
//
// Task to initialize data store
//
// ##########################################################################
//
task init_store;
integer i;
begin
	for(i=0;i<store_size;i=i+1)
	begin
		store0[i] = 0;
		store1[i] = 0;
		store2[i] = 0;
		store3[i] = 0;
		store4[i] = 0;
		store5[i] = 0;
		store6[i] = 0;
	end
end
endtask

//
// ###########################################################################
//
// Task to do store/retrieve data from appropriate store depending on cs_b
//
// Note: This task needs to be modified if there is a CONFIG_ADDR and
//	CONFIG_DATA access.
//
// ###########################################################################
//
task gen_store_retrieve;
input[num_cs-1:0]	tmp_cs_b;
input		   flag;
input[store_length-1:0] idx;
inout[bus_width-1:0]    dt_tmp;
reg[store_length-1:0]	tmp_idx;
reg[bus_width-1:0]	local_data;
begin
//	when flag is 0, data is being retrieved from the storage
	if(flag == 1'b0) begin
	   if (tmp_cs_b[0]==1'b0)
		dt_tmp[bus_width-1:0] = store0[idx];
	   else if (tmp_cs_b[1] == 1'b0)
		dt_tmp[bus_width-1:0] = store1[idx];
	   else if (tmp_cs_b[2] == 1'b0)
		dt_tmp[bus_width-1:0] = store2[idx];
	   else if (tmp_cs_b[3] == 1'b0)
		dt_tmp[bus_width-1:0] = store3[idx];
	   else if (tmp_cs_b[4] == 1'b0)
		dt_tmp[bus_width-1:0] = store4[0];
	   else if (tmp_cs_b[5] == 1'b0) begin
		local_data = store4[0];
		tmp_idx[store_length-1:4] = 0;
		tmp_idx[3:0] = local_data[5:2];
		dt_tmp[bus_width-1:0] = store5[tmp_idx];
	   end
	   else if (tmp_cs_b[6] == 1'b0)
		dt_tmp[bus_width-1:0] = store6[idx];
	end
	else
//	when flag is 1, data is being stored in the storage area
	if(flag == 1'b1) begin
	   if (tmp_cs_b[0]==1'b0) begin
		store0[idx] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location %d ", master_id, dt_tmp, idx);
		$write("in store 0 at time %d\n", tb454.inttime);
`endif
	   end
	   else if (tmp_cs_b[1]==1'b0) begin
		store1[idx] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location %d ", master_id, dt_tmp, idx);
		$write("in store 1 at time %d\n", tb454.inttime);
`endif
	   end
	   else if (tmp_cs_b[2]==1'b0) begin
		store2[idx] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location %d ", master_id, dt_tmp, idx);
		$write("in store 2 at time %d\n", tb454.inttime);
`endif
	   end
	   else if (tmp_cs_b[3]==1'b0) begin
		store3[idx] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location %d ", master_id, dt_tmp, idx);
		$write("in store 3 at time %d\n", tb454.inttime);
`endif
	   end
	   else if (tmp_cs_b[4]==1'b0) begin
		store4[0] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location 0 ", master_id, dt_tmp);
		$write("in store 4 at time %d\n", tb454.inttime);
`endif
	   end
	   else if (tmp_cs_b[5]==1'b0) begin
		local_data = store4[0];
		tmp_idx[store_length-1:4] = 0;
		tmp_idx[3:0] = local_data[5:2];
		store5[tmp_idx] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location %d ", master_id, dt_tmp, tmp_idx);
		$write("in store 5 at time %d\n", tb454.inttime);
`endif
	   end
	   else if (tmp_cs_b[6]==1'b0) begin
		store6[idx] = dt_tmp[bus_width-1:0];
`ifdef store_info
		$write("master %b storing data %h to location %d ", master_id, dt_tmp, idx);
		$write("in store 6 at time %d\n", tb454.inttime);
`endif
	   end
	end
end
endtask

//
// ###########################################################################
//
// Task to generate sideband signals
// This task generates the necessary sideband signals for a particular core
// Ex: h_cmd, h_mio, t_unspec etc.
//
// This function is called at the same time as the ads_b signal is generated
// The necessary signal has to be directly generated here as the actual length
// of the sideband signal may vary from implementation to implementation.
//
// ###########################################################################
//
task gen_sideband;
input[31:0]	 tmp_addr;
input[num_cs-1:0]   tmp_cs_b;
input		tmp_cacheline;
input[7:0]	  tmp_size;
input		tmp_wr;
inout[31:0]	 rseed1;
inout[31:0]	 rseed2;
reg[31:0]	   rand;
begin

    get_random(rseed1, rseed2, rand);
    if(tmp_wr == 1'b1) begin
//     system configuration before the system test starts
	if (tmp_cs_b[6:0]==7'b1111111)
	   h_cmd[1:0] = 2'b10;
//	configuration access after the system test starts
	else if ((tmp_cs_b[0]==1'b0) || (tmp_cs_b[4] == 1'b0) || (tmp_cs_b[5] == 1'b0))
	   h_cmd[1:0] = 2'b10;
//	IO access
	else if (tmp_cs_b[1]==1'b0)
	   h_cmd[1:0] = 2'b00;
//	memory access
	else begin
//	mwi
	  if((((cache_size == 4) && (tmp_addr[3:2] == 2'b00)) ||
		((cache_size == 8) && (tmp_addr[4:2] == 3'b000)) ||
		((cache_size == 16) && (tmp_addr[5:2] == 4'b0000))) &&
	     (tmp_cacheline == 1'b0) && (tmp_size[7:0] >= cache_size))
		h_cmd[1:0] = 2'b10;
//	mw
	  else
		h_cmd[1:0] = 2'b00;
	end
    end
    else begin
//     configuration access after the system test starts
	if ((tmp_cs_b[0]==1'b0) || (tmp_cs_b[4] == 1'b0) || (tmp_cs_b[5] == 1'b0))
	   h_cmd[1:0] = 2'b10;
//     IO access
	else if (tmp_cs_b[1]==1'b0)
	  h_cmd[1:0] = 2'b00;
//     memory access
	else begin
//     mrm
	  if ((rand[15:14]==2'b11) && (tmp_size[7:0]!=8'h01)) h_cmd[1:0] = 2'b01;
//     mrl
	  else if ((rand[15:14]==2'b10) && (tmp_size[7:0]!=8'h01)) h_cmd[1:0] = 2'b10;
//     mr
	  else h_cmd[1:0] = 2'b00;
	end
    end

    if (tmp_cs_b[6:0]==7'b1111111)
	h_mio = 1'b0;
    else if ((tmp_cs_b[0] == 1'b0) || (tmp_cs_b[1] == 1'b0) || (tmp_cs_b[4] == 1'b0) || (tmp_cs_b[5] == 1'b0))
	h_mio = 1'b0;
    else
	h_mio = 1'b1;

end
endtask

//
// ##############################################################################
//
// Task to do configuration
//
// ##############################################################################
//
task configure;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
begin
	tmp_cs_b = 16'hffef;
	avail_size = 32'hffffffff;
	rand_addr_bits = 32'h00000000;
//	configuration task for AHB
	if(tmp_cs_b[4] == 1'b0)
	begin
// *** configure the host bridge
	    $write("Initialize the host bridge\n");

//	    write to config addr
//  Device Number = 0 => IDSEL = AD(11)
	    $write(" write to config_addr -- command/status\n");
	    wdata[0] = 32'h80000004;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  enable target memory/IO access
//  enable master bit
	    $write("write to config_data -- command/status\n");
	    wdata[0] = 32'h04000007;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
//  PCI latency timer and cacheline size register in EP454
	    $write(" write to config_addr -- latency timer/cache line size\n");
	    wdata[0] = 32'h8000000c;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  cache size of 16
	    $write("write to config_data -- latency timer/cache line size\n");
	    wdata[0] = 32'h00002010;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
	    $write(" write to config_addr -- BAR0\n");
	    wdata[0] = 32'h80000010;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
	    $write("write to config_data -- BAR0\n");
	    wdata[0] = 32'haf000000;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
	    $write(" write to config_addr -- BAR1\n");
	    wdata[0] = 32'h80000014;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
	    $write("write to config_data -- BAR1\n");
	    wdata[0] = 32'haf080000;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
	    $write(" write to config_addr -- BAR2\n");
	    wdata[0] = 32'h80000018;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
	    $write("write to config_data -- BAR2\n");
	    wdata[0] = 32'haf0c0000;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
	    $write(" write to config_addr -- BAR3\n");
	    wdata[0] = 32'h8000001c;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
	    $write("write to config_data -- BAR3\n");
	    wdata[0] = base6;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

// *** configure the PCI model - target
	    $write("Initialize the pci model (target)\n");

//	    write to config addr
//  Device Number = 1 => IDSEL = AD(12)
	    $write(" write to config_addr -- command/status\n");
	    wdata[0] = 32'h80000804;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  enable target memory/IO access
	    $write("write to config_data -- command/status\n");
	    wdata[0] = 32'h04000003;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
//  PCI Target Model latency timer and cacheline size register
	    $write(" write to config_addr -- latency timer/cache line size\n");
	    wdata[0] = 32'h8000080c;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  cache size of 16
	    $write("write to config_data -- latency timer/cache line size\n");
	    wdata[0] = 32'h00003010;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
	    $write(" write to config_addr -- BAR0\n");
	    wdata[0] = 32'h80000810;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
	    $write("write to config_data -- BAR0\n");
	    wdata[0] = base2;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
	    $write(" write to config_addr -- BAR1\n");
	    wdata[0] = 32'h80000814;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
	    $write("write to config_data -- BAR1\n");
	    wdata[0] = base1;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

// *** configure the PCI model - master 0
	    $write("Initialize the pci model 0 (master 0)\n");

//	    write to config addr
//  Device Number = 2 => IDSEL = AD(13)
	    $write(" write to config_addr -- command/status\n");
	    wdata[0] = 32'h80001004;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  enable master bit
	    $write("write to config_data -- command/status\n");
	    wdata[0] = 32'h04000004;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
//  PCI Master Model 0 latency timer and cacheline size register
	    $write(" write to config_addr -- latency timer/cache line size\n");
	    wdata[0] = 32'h8000100c;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  cache size of 16
	    $write("write to config_data -- latency timer/cache line size\n");
	    wdata[0] = 32'h00003010;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

// *** configure the PCI model - master 1
	    $write("Initialize the pci model 1 (master 1)\n");

//	    write to config addr
//  Device Number = 3 => IDSEL = AD(14)
	    $write(" write to config_addr -- command/status\n");
	    wdata[0] = 32'h80001804;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  enable master bit
	    $write("write to config_data -- command/status\n");
	    wdata[0] = 32'h04000004;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
//  PCI Master Model 1 latency timer and cacheline size register
	    $write(" write to config_addr -- latency timer/cache line size\n");
	    wdata[0] = 32'h8000180c;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config data
//  cache size of 16
	    $write("write to config_data -- latency timer/cache line size\n");
	    wdata[0] = 32'h00003010;
	    mtrwrite(32'h000c0000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b1, 2'b10, avail_size, 1);

//	    write to config addr
//  user-defined area
	    $write(" write to config_addr -- fake location in external pci\n");
	    wdata[0] = 32'h80000890;
	    mtrwrite(32'h00080000, 1'b0, rand_addr_bits, 8'h01, tmp_cs_b, rseed1, rseed2, 1'b0, 2'b10, avail_size, 1);
	end
end
endtask

//
// #############################################################################
//
// Task to do fixed testing before random testing is kicked off
//
// This task is used to run fixed tests from a particular master before the
// master kicks off the random testing. From the testbench perspective,
// each master which needs to start its fixed testing waits for the
// fixed_test variable, which is an integer, to be a particular value before it
// can kick off its fixed testing. The fixed_test variable is again checked before
// kicking off the random test.
//
// #############################################################################
//
task gen_fixed_test10;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
reg[31:0]    storage_idx;
reg[31:0]    rand;
integer	i;
begin

     get_random(rseed1, rseed2, rand);
     avail_size = 32'hffffffff;
     tmp_hsize = 2'b10;
     noStore = 1'b0;

// AHB master device 1
//	CONFIG_ADDR register write followed by read
//	(content point to PCI target device user defined configuration register)
	tmp_cs_b = 16'hffef;
	tmp_addr = base4;
	tmp_cacheline = 1'b0;
	tmp_size = 8'h01;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
//	generate the write data
	wdata[0] = 32'h80000880;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	CONFIG_DATA register write followed by read to PCI target device
	tmp_cs_b = 16'hffdf;
	tmp_addr = base5;
	tmp_cacheline = 1'b0;
	tmp_size = 8'h01;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b1100;
	if (big_endian) tmp_addr[1:0] = 2'b10; else tmp_addr[1:0] = 2'b00;
//	generate the write data
	wdata[0] = 32'h11223344;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	PCI IO write followed by read access to PCI target device
	tmp_cs_b = 16'hfffd;
//	only address bit (8:2) are allowed to vary
	tmp_addr = {base1[31:13], master_id[2:0], 10'b0000000000};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h01;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
//	generate the write data
	wdata[0] = 32'h88776655;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	PCI single memory write followed by read access to PCI target device
	tmp_cs_b = 16'hfffb;
//	only address bit (8:2) are allowed to vary
	tmp_addr = {base2[31:13], master_id[2:0], 10'b0000000000};
	tmp_cacheline = 1'b1;
	tmp_size = 8'h01;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
//	generate the write data
	wdata[0] = 32'h11223344;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	PCI burst memory write followed by read access to PCI target device
	tmp_cs_b = 16'hfffb;
//	only address bit (8:2) are allowed to vary
	tmp_addr = {base2[31:13], master_id[2:0], 10'b0000001000};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h02;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
	wbe_b[1] = 4'b0000;
//	generate the write data
	wdata[0] = 32'hffeeddcc;
	wdata[1] = 32'hbbaa9988;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);
end
endtask

task gen_fixed_test11;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
reg[31:0]    storage_idx;
reg[31:0]    rand;
integer	i;
begin

     get_random(rseed1, rseed2, rand);
     avail_size = 32'hffffffff;
     tmp_hsize = 2'b10;
     noStore = 1'b0;

// PCI master device 0
//	AHB bus slave model 1 single write followed by read access
	tmp_cs_b = 16'hfff7;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base3[31:16], 1'b0, base3[14:13], master_id[2:0], 10'b0100000000};
	tmp_cacheline = 1'b1;
	tmp_size = 8'h01;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0110;
//	generate the write data
	wdata[0] = 32'hffeeddcc;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	AHB bus slave model 1 burst write followed by read access
	tmp_cs_b = 16'hfff7;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base3[31:16], 1'b0, base3[14:13], master_id[2:0], 10'b0101111100};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h0a;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
	wbe_b[1] = 4'b0000;
	wbe_b[2] = 4'b0000;
	wbe_b[3] = 4'b0000;
	wbe_b[4] = 4'b0000;
	wbe_b[5] = 4'b0000;
	wbe_b[6] = 4'b0000;
	wbe_b[7] = 4'b0000;
	wbe_b[8] = 4'b1010;
	wbe_b[9] = 4'b0101;
//	generate the write data
	wdata[0] = 32'h11111111;
	wdata[1] = 32'h22222222;
	wdata[2] = 32'h33333333;
	wdata[3] = 32'h44444444;
	wdata[4] = 32'h55555555;
	wdata[5] = 32'h66666666;
	wdata[6] = 32'h77777777;
	wdata[7] = 32'h88888888;
	wdata[8] = 32'h99999999;
	wdata[9] = 32'haaaaaaaa;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	AHB bus slave model 2 single write followed by read access
	tmp_cs_b = 16'hffbf;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base6[31:16], 1'b1, base3[14:13], master_id[2:0], 10'b0101111100};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h01;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
//	generate the write data
	wdata[0] = 32'h77665544;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

//	AHB bus slave model 2 burst write followed by read access
	tmp_cs_b = 16'hffbf;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base6[31:16], 1'b1, base3[14:13], master_id[2:0], 10'b0110000000};
	tmp_cacheline = 1'b1;
	tmp_size = 8'h08;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
	wbe_b[1] = 4'b0010;
	wbe_b[2] = 4'b0100;
	wbe_b[3] = 4'b1000;
	wbe_b[4] = 4'b0000;
	wbe_b[5] = 4'b0000;
	wbe_b[6] = 4'b0000;
	wbe_b[7] = 4'b0000;
//	generate the write data
	wdata[0] = 32'h11111111;
	wdata[1] = 32'h22222222;
	wdata[2] = 32'h33333333;
	wdata[3] = 32'h44444444;
	wdata[4] = 32'h55555555;
	wdata[5] = 32'h66666666;
	wdata[6] = 32'h77777777;
	wdata[7] = 32'h88888888;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	insert_wait(10);
	mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
		rseed1, rseed2, expect_rdy_cnt, trfr_count);
	compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, storage_idx,
			tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
	insert_wait(10);

end
endtask

//
// test write bandwidth from PCI side
//
task gen_fixed_test2;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
reg[31:0]    storage_idx;
reg[31:0]    rand;
integer		i;
integer		j;
begin

     get_random(rseed1, rseed2, rand);
     avail_size = 32'hffffffff;
     tmp_hsize = 2'b10;
     noStore = 1'b0;

// access AHB bus slave model 1 burst write followed by read access
// burst write of 8 words, repeat 8 times
     for (i=0;i<=3;i=i+1) begin
	tmp_cs_b = 16'hfff7;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base3[31:16], 1'b0, base3[14:13], master_id[2:0], 10'b0100000000};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h10;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
// byte enable and data for write access
	for (j=0;j<=15;j=j+1) begin
	   wbe_b[j] = 4'b0000;
	   wdata[j] = (j+1) * 32'h01010101;
	end
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
     end
end
endtask

//
// test write bandwidth from PCI side
//
task gen_fixed_test3;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
reg[31:0]    storage_idx;
reg[31:0]    rand;
integer		i;
integer		j;
begin

     get_random(rseed1, rseed2, rand);
     avail_size = 32'hffffffff;
     tmp_hsize = 2'b10;
     noStore = 1'b0;

// access AHB bus slave model 1 burst write followed by read access
// burst write of 8 words, repeat 8 times
     for (i=0;i<=7;i=i+1) begin
	tmp_cs_b = 16'hfff7;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base3[31:16], 1'b0, base3[14:13], master_id[2:0], 10'b0100000000};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h18;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
// byte enable and data for write access
	for (j=0;j<=23;j=j+1) begin
	   wbe_b[j] = 4'b0000;
	   wdata[j] = (j+1) * 32'h01010101;
	end
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
	repeat(2) @(posedge clk);
	#1;
     end
end
endtask

//
// test write bandwidth from PCI side
//
task gen_fixed_test4;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
reg[31:0]    storage_idx;
reg[31:0]    rand;
integer		i;
integer		j;
begin

     get_random(rseed1, rseed2, rand);
     avail_size = 32'hffffffff;
     tmp_hsize = 2'b10;
     noStore = 1'b0;

// access AHB bus slave model 1 burst write followed by read access
// burst write of 8 words, repeat 8 times
     for (i=0;i<=3;i=i+1) begin
	tmp_cs_b = 16'hfff7;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base3[31:16], 1'b0, base3[14:13], master_id[2:0], 10'b0100000000};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h20;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
// byte enable and data for write access
	for (j=0;j<=31;j=j+1) begin
	   wbe_b[j] = 4'b0000;
	   wdata[j] = (j+1) * 32'h01010101;
	end
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
     end
end
endtask

//
// test write bandwidth from PCI side
//
task gen_fixed_test1;
inout[31:0]  rseed1;
inout[31:0]  rseed2;
reg[31:0]    storage_idx;
reg[31:0]    rand;
integer	i;
begin

     get_random(rseed1, rseed2, rand);
     avail_size = 32'hffffffff;
     tmp_hsize = 2'b10;
     noStore = 1'b0;

// access AHB bus slave model 1 burst write followed by read access
// burst write of 8 words, repeat 8 times
     for (i=0;i<=3;i=i+1) begin
	tmp_cs_b = 16'hfff7;
//	only address bit (8:2) is allowed to vary
	tmp_addr = {base3[31:16], 1'b0, base3[14:13], master_id[2:0], 10'b0100000000};
	tmp_cacheline = 1'b0;
	tmp_size = 8'h08;
	expect_rdy_cnt = {24'h000000, tmp_size[7:0]};
//	byte enable for write access
	wbe_b[0] = 4'b0000;
	wbe_b[1] = 4'b0000;
	wbe_b[2] = 4'b0000;
	wbe_b[3] = 4'b0000;
	wbe_b[4] = 4'b0000;
	wbe_b[5] = 4'b0000;
	wbe_b[6] = 4'b0000;
	wbe_b[7] = 4'b0000;
	wbe_b[8] = 4'b1010;
	wbe_b[9] = 4'b0101;
//	generate the write data
	wdata[0] = 32'h11111111;
	wdata[1] = 32'h22222222;
	wdata[2] = 32'h33333333;
	wdata[3] = 32'h44444444;
	wdata[4] = 32'h55555555;
	wdata[5] = 32'h66666666;
	wdata[6] = 32'h77777777;
	wdata[7] = 32'h88888888;
	wdata[8] = 32'h99999999;
	wdata[9] = 32'haaaaaaaa;
//	byte enable for read access
	tmp_rbe_b = 4'b0000;
//	generate the storage index for the current access
	storage_idx = gen_storage_idx(tmp_addr, tmp_cs_b);

	mtrwrite(tmp_addr, tmp_cacheline, storage_idx, tmp_size, tmp_cs_b,
		 rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
     end
end
endtask


//
// ##############################################################################
//
// Task to do transfer setup
//
// ##############################################################################
//
task trfr_setup;
inout[31:0]     rseed1;
inout[31:0]     rseed2;
input[3:0]	rand;
input	   rw_sel;
reg[bus_width-1:0]   tmp_rdata;
reg[bus_width-1:0]   tmp_wdata;
reg[7:0]	     trfr_count;
begin

end
endtask

//
// ##########################################################################
//
// Task to run actual test
//
// ##########################################################################
//
task runTest;
begin

//     it is suggested that different seeds for random number generation
//     happen here
	forever begin
	   get_random(rseed1, rseed2, ran1);
	   get_random(rseed1, rseed2, ran2);
//	 transfer setup
	   trfr_setup(rseed1, rseed2, ran2[3:0], ran1[0]);
//	   initialize all random inputs
	   randInit(ran1, ran2[31:16], rseed1, rseed2, rw_sel, tmp_addr, tmp_cacheline,
		    tmp_cs_b, tmp_hsize, tmp_rbe_b, tmp_size, rand_addr_bits, avail_size,
		    expect_rdy_cnt, noStore);
	   hsize = tmp_hsize;

	   if (rw_sel==1'b1) begin
`ifdef debug_info
		$write("master %d beginning new write access\n", master_id);
`endif
		mtrwrite(tmp_addr, tmp_cacheline, rand_addr_bits, tmp_size, tmp_cs_b,
			rseed1, rseed2, noStore, tmp_hsize, avail_size, expect_rdy_cnt);
		wr_cnt[19:0] = wr_cnt[19:0] + 20'h00001;
	   end
	   else begin
`ifdef debug_info
		$write("master %d beginning new read access\n", master_id);
`endif
		mtrread(tmp_addr, tmp_cacheline, tmp_size, tmp_cs_b, tmp_rbe_b,
			rseed1, rseed2, expect_rdy_cnt, trfr_count);
		if(trfr_count[7:0] > 8'h00) begin
		 compare_rd_data(tmp_addr, tmp_cs_b, tmp_cacheline, rand_addr_bits,
				 tmp_size, trfr_count, tmp_hsize, tmp_rbe_b, zerodata);
		 if(zerodata == 1'b0)
		   rd_cnt[19:0] = rd_cnt[19:0] + 20'h00001;
		end
	   end

	   k = k+1;
	   insert_wait(ran2);
	end
end
endtask

//
// ##########################################################################
//
// Initial Test Setup
//
// ##########################################################################
//
initial begin

	k=0;
	mtrdone = 0;

	@ (posedge clk) ;
	@ (posedge clk) ;
	@ (posedge clk) ;
//	when reset_b is asserted, initialize internal signals
	while (reset_b==1'b0) begin
	    #1;
	    ads_b = 1'b1;
	    blast_b = 1'b1;
	    cs_b = 16'hffff;
	    wren_b = 1'b1;
	    rdnxt_b = 1'b1;
	    size = 16'h0000;
	    wr = 1'b1;
	    hsize = 2'b11;
//	    flag to keep track of data of all 0's
	    zerodata = 1'b1;
	    rseed1 = 12345;
	    rseed2 = 98765;
	    ecconnect2_wait_states = 0;
	    @ (posedge clk);
	end
	@ (posedge clk) ;
	@ (posedge clk) ;
	@ (posedge clk) ;
//	initialize data in all stores to 0
	init_store;
//	initialize write data array
	init_data;
//	initialize various counters
	init_counters;

// initialize configuration through this master if config_enable parameter is set
	if(config_enable == 1'b1) begin
	    wbe_b[0] = 0;
	    wbe_b[1] = 0;
	    configure(rseed1, rseed2);
	    $write("System initialization complete.\n");

	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;
	end

// wait for a particular value of fixed_test before starting the fixed test
	if(master_id == 3'b000) begin
	    if (test_state!=1) wait (test_state == 1);
	    $write("master %d fixed test1 start.\n", master_id);
	    gen_fixed_test1(rseed1, rseed2);
	    $write("master %d fixed test1 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=2) wait (test_state == 2);
	    $write("master %d fixed test2 start.\n", master_id);
	    gen_fixed_test2(rseed1, rseed2);
	    $write("master %d fixed test2 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=3) wait (test_state == 3);
	    $write("master %d fixed test3 start.\n", master_id);
	    gen_fixed_test3(rseed1, rseed2);
	    $write("master %d fixed test3 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=4) wait (test_state == 4);
	    $write("master %d fixed test4 start.\n", master_id);
	    gen_fixed_test4(rseed1, rseed2);
	    $write("master %d fixed test4 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=11) wait (test_state == 11);
	    $write("master %d fixed test11 start.\n", master_id);
	    gen_fixed_test11(rseed1, rseed2);
	    $write("master %d fixed test11 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;
	end
	else if(master_id == 3'b001) begin
	    if (test_state !=10) wait(test_state == 10);
	    $write("master %d fixed test10 start.\n", master_id);
	    gen_fixed_test10(rseed1, rseed2);
	    $write("master %d fixed test10 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;
	end
	else if(master_id == 3'b011) begin
	    if (test_state!=1) wait (test_state == 1);
	    $write("master %d fixed test1 start.\n", master_id);
	    gen_fixed_test1(rseed1, rseed2);
	    $write("master %d fixed test1 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=2) wait (test_state == 2);
	    $write("master %d fixed test2 start.\n", master_id);
	    gen_fixed_test2(rseed1, rseed2);
	    $write("master %d fixed test2 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=3) wait (test_state == 3);
	    $write("master %d fixed test3 start.\n", master_id);

// doesn't do anything master 3
//	    gen_fixed_test3(rseed1, rseed2);
	    $write("master %d fixed test3 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	    if (test_state!=4) wait (test_state == 4);
	    $write("master %d fixed test4 start.\n", master_id);
	    gen_fixed_test4(rseed1, rseed2);
	    $write("master %d fixed test4 complete.\n", master_id);
	    mtrdone = 1;
	    repeat(4) @(posedge clk);
	    mtrdone = 0;

	end


// wait for random test
	if (test_state!=32'h00000100) wait (test_state == 32'h00000100);

//
// ##########################################################################
//
// Main test loop
//
// ##########################################################################
//
	$write("master %d random access start.\n", master_id);
	runTest;

end

//
// ###########################################################################
//
// Function to generate random numbers
//
// ###########################################################################
//
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

//
// ##########################################################################
//
// Task to initialize various counters
//
// ##########################################################################
//
task init_counters;
begin

// counter to count number of linear increment mode accesses
   linear_cnt[19:0] = 20'h00000;

// counter to count number of cacheline wrap mode accesses
   cacheline_cnt[19:0] = 20'h00000;

// counter to count number of master abort accesses
   mabort_cnt[19:0] = 20'h0000;

// counter to count number of target abort accesses
   tabort_cnt[19:0] = 20'h0000;

// counters to count access to each destination area indicated by cs_b
   access_cnt0[19:0]  = 20'h00000;
   access_cnt1[19:0]  = 20'h00000;
   access_cnt2[19:0]  = 20'h00000;
   access_cnt3[19:0]  = 20'h00000;
   access_cnt4[19:0]  = 20'h00000;
   access_cnt5[19:0]  = 20'h00000;
   access_cnt6[19:0]  = 20'h00000;
   access_cnt7[19:0]  = 20'h00000;
   access_cnt8[19:0]  = 20'h00000;
   access_cnt9[19:0]  = 20'h00000;
   access_cnt10[19:0] = 20'h00000;
   access_cnt11[19:0] = 20'h00000;
   access_cnt12[19:0] = 20'h00000;
   access_cnt13[19:0] = 20'h00000;
   access_cnt14[19:0] = 20'h00000;
   access_cnt15[19:0] = 20'h00000;

// counter to count number of write accesses
   wr_cnt[19:0] = 20'h00000;

// counter to count number of read accesses
   rd_cnt[19:0]	= 20'h00000;

// counter to count number of boundary cross accesses
   boundary_cross_cnt[19:0] = 20'h00000;

// counter to count number of boundary address accesses
   boundary_acc_cnt[19:0] = 20'h00000;

// counter to count number of error accesses in the middle of a burst
   burst_mid_err_cnt[19:0] = 20'h00000;

// early transfer termination for ecconnect2
   early_terminate_cnt[19:0] = 20'h00000;

// master access termination with no data transfer for ecconnect2
   master_trfr_terminate_cnt[19:0] = 20'h00000;

`ifdef ec220
//latency timer acces
   lat_cnt = 20'h00000;
`endif

end
endtask

//
// #############################################################################
//
// Task to initialize write data
//
// #############################################################################
//
task init_data;
integer i;
begin
	for(i=0;i<256;i=i+1) begin
	   if(bus_width == 32)
		wdata[i] = 32'h00000000;
	   else
		wdata[i] = 64'h0000000000000000;
	end
end
endtask

//
// #############################################################################
//
// Task to insert random wait states at the end of each access
//
// #############################################################################
//
task insert_wait;
input[31:0]	ran2;
begin

   repeat (ran2[11:6]) begin
	@(posedge clk);
   end

end
endtask

//
//##############################################################################
//
// Task to generate the access address
//
//##############################################################################
//
task gen_addr;
input[255:0]	addr_str;
input[num_cs-1:0]  tmp_cs_b;
input[31:0]	base;
input[31:0]	addr_rand;
output[31:0]	addr;
output[31:0]	rand_addr_bits;
output[31:0]	num_rand;
reg[7:0]	   local_str;
reg		freeze_num_rand;
integer	    i;
integer	    j;
integer	    master_idx;
integer	    rand_idx;
begin
    master_idx = 0;
    rand_idx = 0;
    num_rand = 0;
    freeze_num_rand = 1'b0;
    rand_addr_bits[31:0] = 32'h00000000;
//  loop to grab the characters in the address string
    for(i=0;i<32;i=i+1) begin
	for(j=0;j<8;j=j+1) begin
	    local_str[j] = addr_str[i*8+j];
	end
	case(local_str)
//		character is 'm' or a master id bit
		"m" : begin
				 addr[i] = master_id[master_idx];
				 master_idx = master_idx+1;
				 if(freeze_num_rand == 1'b0) begin
			    num_rand = rand_idx;
			    freeze_num_rand = 1'b1;
				 end
			    end
//		character is 'r' or a bit with a random value
		"r" : begin
			addr[i] = addr_rand[rand_idx];
			rand_addr_bits[rand_idx] = addr_rand[rand_idx];
			rand_idx = rand_idx+1;
		    end
//		character is 'b' or a base address bit
		"b" : addr[i] = base[i];
//		character is '0' or a bit with a value 0
		"0" : addr[i] = 1'b0;
//		character is '1' or a bit with a value 1
		"1" : addr[i] = 1'b1;
	endcase
    end
end
endtask

//
//##############################################################################
//
// Task to generate access width
//
//##############################################################################
//
function[1:0] gen_hsize;
input[15:0]   hsize_str;
input[1:0]    rand;
reg[7:0]	local_str;
integer	i;
integer	j;
begin
//   grab the characters in the access width string
     for(i=0;i<2;i=i+1) begin
	for(j=0;j<8;j=j+1) begin
	    local_str[j] = hsize_str[i*8+j];
	end
	case(local_str)
//		character is 'r' or a randomly generated bit
		"r" : gen_hsize[i] = rand[i];
//		character is '0' or a bit with value 0
		"0" : gen_hsize[i] = 1'b0;
//		character is '1' or a bit with value 1
		"1" : gen_hsize[i] = 1'b1;
	endcase
     end
//   2'b11 is an illegal value
     if(gen_hsize == 2'b11)
	gen_hsize = 2'b10;
end
endfunction

//
// ##########################################################################
//
// Function to generate cacheline access
//
// ##########################################################################
//
function gen_cache;
input[7:0]   cache_str;
input	rand;
reg[7:0]     local_str;
integer	     j;
begin
//  grab the characters in the access width string
    for(j=0;j<8;j=j+1) begin
	local_str[j] = cache_str[j];
    end
    case(local_str)
//	if address bits 1 and 0 must be 2'b00
	"c" : gen_cache = 1'b1;
	"d" : gen_cache = rand;
	"l" : gen_cache = 1'b0;
    endcase
    if((gen_cache == 1'b1) && (cache_disable == 1'b1)) begin
	$write("Error: Cacheline access attempted when cachewrap mode is disabled\n");
	$stop;
    end
    if(gen_cache == 1'b1)
	cacheline_cnt = cacheline_cnt + 20'h00001;
    else
	linear_cnt = linear_cnt + 20'h00001;
end
endfunction

//
// ##########################################################################
//
// Function to generate cache size to be used to store data
// This function is needed because some cores do not use the cache size
// parameter as the actual size of the cache but instead use the transfer
// size as the actual cache size
// Ex: AHB master in ep454
//
// ##########################################################################
//
function[7:0] gen_cache_size;
input[7:0] tmp_size;
begin
	if(load_cache_flag == 1'b0)
	    gen_cache_size[7:0] = tmp_size[7:0];
	else
	    gen_cache_size[7:0] = cache_size;
end
endfunction

//
//###########################################################################
//
// Task to generate transfer size
//
//###########################################################################
//
task gen_size;
input[31:0]   size_str;
input[7:0]    store_str;
input[31:0]   access_addr;
input[31:0]   num_rand;
input[31:0]   rand_addr_bits;
input[7:0]    rand;
input	 tmp_cacheline;
input[1:0]    tmp_hsize;
output[7:0]   tmp_size;
output[31:0]  avail_size;
reg[31:0]     addr_boundary;
reg[31:0]     addr_incr;
reg	   isWord;
reg[7:0]	local_str;
reg[31:0]     local_addr;
reg[7:0]	local_cache_size;
reg	   freeze_last_error_locn;
integer	i;
integer	j;
integer	limit;
integer	max_size;
integer	cur_good_locn;
integer	last_error_locn;
begin
//  flag to decide whether size is a power of 2 or not
    isWord = 1'b0;
//  loop to grab the characters in the access width string
    max_size = 0;
    for(i=4;i>=0;i=i-1) begin
	for(j=0;j<8;j=j+1) begin
	   local_str[j] = size_str[i*8+j];
	end
//	parse the size string
	case(local_str)
//		character specifying that size is any value
		"r" : isWord = 1'b0;
//		character specifying that size is either 1 or a power of 2 (excluding 2)
		"w" : isWord = 1'b1;
//		character is 0 or 1
		"0" : max_size = max_size * 10 + 0;
		"1" : max_size = max_size * 10 + 1;
		"2" : max_size = max_size * 10 + 2;
		"3" : max_size = max_size * 10 + 3;
		"4" : max_size = max_size * 10 + 4;
		"5" : max_size = max_size * 10 + 5;
		"6" : max_size = max_size * 10 + 6;
		"7" : max_size = max_size * 10 + 7;
		"8" : max_size = max_size * 10 + 8;
		"9" : max_size = max_size * 10 + 9;
	endcase
    end

//  single transfer has size 1
    if(max_size == 1)
	tmp_size = 8'h01;
//  cacheline wrap mode
    else if(tmp_cacheline == 1'b1) begin
//	size is limited by minimum of user specified maximum burst size and cache size
	if(max_size <= cache_size)
	   limit = max_size;
	else
	   limit = cache_size;

	tmp_size = (rand[7:0] % limit) + 1;
    end
//  linear increment mode
    else if(tmp_cacheline == 1'b0) begin
//	linear increment mode, the transfer size cannot exceed the user specified limit
	limit = max_size;
	tmp_size = (rand[7:0] % limit) + 1;
    end

    if(tmp_size[7:0] == 8'h00)
	tmp_size[7:0] = 8'h01;

//  if the transfer size is specified to be at a word boundary, then set the size
//  to be a power of 2
    if(isWord == 1'b1) begin
	if(tmp_size[7:0] < 8'h04) tmp_size[7:0] = 8'h01;
	else if(tmp_size[7:0] < 8'h08) tmp_size[7:0] = 8'h04;
	else if(tmp_size[7:0] < 8'h10) tmp_size[7:0] = 8'h08;
	else if(tmp_size[7:0] < 8'h20) tmp_size[7:0] = 8'h10;
	else if(tmp_size[7:0] < 8'h40) tmp_size[7:0] = 8'h20;
	else if(tmp_size[7:0] < 8'h80) tmp_size[7:0] = 8'h40;
	else if(tmp_size[7:0] > 8'h80) tmp_size[7:0] = 8'h80;
    end

//  starting address is beyond the address boundary
    if(store_str == "0") begin
	avail_size[31:0] = 32'h00000000;
    end
//  calculate the available size based on the starting address
//  adjust the transfer size if no boundary crossing is allowed
    else begin
	local_addr[31:0] = 32'h00000000;
	addr_boundary = 32'h00000000;
	for(i=0;i<num_rand;i=i+1) begin
	   local_addr[i] = rand_addr_bits[i];
	   addr_boundary[i] = 1'b1;
	end

//	available size calculates the available area for the current access,
//	before the access hits an address boundary for the current target area
	avail_size[31:0] = (addr_boundary[31:0] - local_addr[31:0]) + 32'h00000001;

//	16-bit mode transfer, double avail_size, then minus the starting address
	if(tmp_hsize == 2'b01) begin
	   avail_size[31:0] = avail_size[31:0] * 32'h00000002;
	   if (access_addr[1:0] == 2'b10)
		avail_size[31:0] = avail_size[31:0] - 32'h00000001;
	end
//	8-bit mode transfer, four times avail_size, then minus the starting address
	else if(tmp_hsize == 2'b00) begin
	   avail_size[31:0] = avail_size[31:0] * 32'h00000004;
	   if (access_addr[1:0] == 2'b11)
		avail_size[31:0] = avail_size[31:0] - 32'h00000003;
	   else if (access_addr[1:0] == 2'b10)
		avail_size[31:0] = avail_size[31:0] - 32'h00000002;
	   else if (access_addr[1:0] == 2'b01)
		avail_size[31:0] = avail_size[31:0] - 32'h00000001;
	end

//	transfer size is bigger than the available size
//	if users specify no boundary crossing, transfer size will be adjusted so that
//	it will not burst beyond the address boundary.
//	otherwise it will burst beyond the address boundary
	if(avail_size[31:0] < {24'h000000,tmp_size[7:0]}) begin
	   if ((boundary_cross == 1'b0) || (tmp_cacheline == 1'b1)) begin
		tmp_size[7:0] = avail_size[7:0];
		if(isWord == 1'b1) begin
		 if(tmp_size[7:0] < 8'h04) tmp_size[7:0] = 8'h01;
		 else if(tmp_size[7:0] < 8'h08) tmp_size[7:0] = 8'h04;
		 else if(tmp_size[7:0] < 8'h10) tmp_size[7:0] = 8'h08;
		 else if(tmp_size[7:0] < 8'h20) tmp_size[7:0] = 8'h10;
		 else if(tmp_size[7:0] < 8'h40) tmp_size[7:0] = 8'h20;
		 else if(tmp_size[7:0] < 8'h80) tmp_size[7:0] = 8'h40;
		 else if(tmp_size[7:0] > 8'h80) tmp_size[7:0] = 8'h80;
		end
		boundary_acc_cnt[19:0] = boundary_acc_cnt[19:0] + 20'h00001;
	   end
	   else begin
		boundary_cross_cnt[19:0] = boundary_cross_cnt[19:0] + 20'h00001;
	   end
	end
    end

//  if access does not start beyond the address boundary, adjust the transfer
//  size if the access will burst from an abort range back to the normal range
    if(avail_size[31:0] != 32'h00000000) begin
	if(bus_width == 32) begin
	   if(tmp_hsize == 2'b00)
		addr_incr = 32'h00000001;
	   else if(tmp_hsize == 2'b01)
		addr_incr = 32'h00000002;
	   else if(tmp_hsize == 2'b10)
		addr_incr = 32'h00000004;
	end
	else
	   addr_incr = 32'h00000008;

//	go through all locations that will be accessed from the starting address
	local_cache_size = gen_cache_size(tmp_size);
	freeze_last_error_locn = 1'b0;
	cur_good_locn = 0;
	last_error_locn = -2;
	for(i=0;i<tmp_size;i=i+1) begin
	   if(tmp_cacheline == 1'b0)
		local_addr = (access_addr+(i*addr_incr));
	   else begin
		if (bus_width == 32) begin
		 if (tmp_hsize==2'b10) begin
		    if(local_cache_size <= 4) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
		    end
		    else if(local_cache_size <= 8) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		    else if(local_cache_size <= 16) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		    end
		 end
		 else if (tmp_hsize==2'b01) begin
		    if(local_cache_size <= 4) begin
			local_addr[31:3] = access_addr[31:3];
			local_addr[2:0] = (access_addr[2:0] + (i*addr_incr));
		    end
		    else if(local_cache_size <= 8) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
		    end
		    else if(local_cache_size <= 16) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		 end
		 else if (tmp_hsize==2'b00) begin
		    if(local_cache_size <= 4) begin
			local_addr[31:2] = access_addr[31:2];
			local_addr[1:0] = (access_addr[1:0] + (i*addr_incr));
		    end
		    else if(local_cache_size <= 8) begin
			local_addr[31:3] = access_addr[31:3];
			local_addr[2:0] = (access_addr[2:0] + (i*addr_incr));
		    end
		    else if(local_cache_size <= 16) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
		    end
		 end
		end
		else begin
		 if(local_cache_size <= 4) begin
		    local_addr[31:5] = access_addr[31:5];
		    local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		 end
		 else if(local_cache_size <= 8) begin
		    local_addr[31:6] = access_addr[31:6];
		    local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		 end
		 else if(local_cache_size <= 16) begin
		    local_addr[31:7] = access_addr[31:7];
		    local_addr[6:0] = (access_addr[6:0] + (i*addr_incr));
		 end
		end
	   end

//	 check if the addressed location is an abort address
	   if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		if (freeze_last_error_locn == 1'b0)
		 last_error_locn = i;
	   end
	   else begin
		cur_good_locn = i;
		if (cur_good_locn == last_error_locn+1)
		 freeze_last_error_locn = 1'b1;
	   end
	end

//	if the access will burst from an abort range back to the normal range,
//	reduce the burst size to the min. of last abort location and avail_size
	if (freeze_last_error_locn == 1'b1) begin
	   if ((last_error_locn+1) < avail_size)
		tmp_size[7:0] = last_error_locn + 1;
	   else
		tmp_size[7:0] = avail_size[7:0];

	   if(isWord == 1'b1) begin
		if(tmp_size[7:0] < 8'h04) tmp_size[7:0] = 8'h01;
		else if(tmp_size[7:0] < 8'h08) tmp_size[7:0] = 8'h04;
		else if(tmp_size[7:0] < 8'h10) tmp_size[7:0] = 8'h08;
		else if(tmp_size[7:0] < 8'h20) tmp_size[7:0] = 8'h10;
		else if(tmp_size[7:0] < 8'h40) tmp_size[7:0] = 8'h20;
		else if(tmp_size[7:0] < 8'h80) tmp_size[7:0] = 8'h40;
		else if(tmp_size[7:0] > 8'h80) tmp_size[7:0] = 8'h80;
	   end
	end
    end
end
endtask

//
//##############################################################################
//
// Task to calculate the number of ready response
//
// Type0: number of rdy is not deterministic
// Type1: number of rdy matches with transfer size
// Type2: receives rdy till hitting abort range
//	starting address AND transfer size are always preserved
// Type3: no rdy for the entire transfer when stepping into the abort range
//	starting address AND transfer size are always preserved
// Type4: receives rdy till hitting abort range
//	starting address is preserved AND
//	transfer size is promoted to 4, 8 or 16 during cache wrap mode
// Type5: no rdy for the entire transfer when stepping into the abort range
//	starting address is rearranged to the beginning of cacheline AND
//	transfer size is promoted to 4, 8 or 16 during cache wrap mode
//
//##############################################################################
//
function[31:0] gen_expect_rdy_cnt;
input[7:0]    access_str;
input[31:0]   access_addr;
input	 tmp_cacheline;
input[1:0]    tmp_hsize;
input[7:0]    tmp_size;
input[31:0]   avail_size;
reg[31:0]     addr_incr;
reg[31:0]     local_addr;
reg[7:0]	rdy_cnt;
reg[7:0]	rdy2_cnt;
reg[7:0]	wrap_size;
reg	   encounter_error;
reg	   use_rdy2_cnt;
integer	i;

begin
    if(bus_width == 32) begin
	if(tmp_hsize == 2'b00)
	   addr_incr = 32'h00000001;
	else if(tmp_hsize == 2'b01)
	   addr_incr = 32'h00000002;
	else if(tmp_hsize == 2'b10)
	   addr_incr = 32'h00000004;
    end
    else
	addr_incr = 32'h00000008;

    encounter_error = 1'b0;
    rdy_cnt[7:0] = 8'h00;
    use_rdy2_cnt = 1'b0;
    rdy2_cnt[7:0] = 8'h00;
    wrap_size[7:0] = 8'h00;

//  Type1: number of rdy matches with transfer size
    if (access_str == "1")
	rdy_cnt[7:0] = tmp_size[7:0];
//  Type2: receives rdy till hitting abort range
//	 starting address AND transfer size are always preserved
    else if (access_str == "2") begin
//  access start beyond address boundary
	if (avail_size[31:0] == 32'h00000000) begin
	   rdy_cnt[7:0] = 8'h00;
	   mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
	end
//  access start within address boundary
	else begin
//  go through all locations that will be accessed from the starting address
	   for(i=0;i<tmp_size;i=i+1) begin
		if(tmp_cacheline == 1'b0)
		 local_addr = (access_addr+(i*addr_incr));
		else begin
		 if (bus_width == 32) begin
		    if(cache_size == 4) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
		    end
		    else if(cache_size == 8) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		    else if(cache_size == 16) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		    end
		 end
		 else begin
		    if(cache_size == 4) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		    else if(cache_size == 8) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		    end
		    else if(cache_size == 16) begin
			local_addr[31:7] = access_addr[31:7];
			local_addr[6:0] = (access_addr[6:0] + (i*addr_incr));
		    end
		 end
		end
//  check if the addressed location is an abort address
		if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		 ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		 if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
		    if(i==0)
			tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
		    else
			burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		 end
		 encounter_error = 1'b1;
		end
//  check if the addressed location is beyond the address boundary
		else if ((i+1) > avail_size[31:0]) begin
		 if (encounter_error == 1'b0) begin
		    mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
		 end
		 encounter_error = 1'b1;
		end
		else begin
		 if (encounter_error == 1'b0)
		    rdy_cnt[7:0] = rdy_cnt[7:0] + 8'h01;
		end
	   end
	end
    end
//  Type3: no rdy for the entire transfer when stepping into the abort range
//	 starting address AND transfer size are always preserved
    else if (access_str == "3") begin
//  access start beyond address boundary
	if (avail_size[31:0] == 32'h00000000) begin
	   rdy_cnt[7:0] = 8'h00;
	   mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
	end
//  access start within address boundary
	else begin
//  go through all locations that will be accessed from the starting address
	   for(i=0;i<tmp_size;i=i+1) begin
		if(tmp_cacheline == 1'b0)
		 local_addr = (access_addr+(i*addr_incr));
		else begin
		 if (bus_width == 32) begin
		    if(cache_size == 4) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
		    end
		    else if(cache_size == 8) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		    else if(cache_size == 16) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		    end
		 end
		 else begin
		    if(cache_size == 4) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		    else if(cache_size == 8) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		    end
		    else if(cache_size == 16) begin
			local_addr[31:7] = access_addr[31:7];
			local_addr[6:0] = (access_addr[6:0] + (i*addr_incr));
		    end
		 end
		end
//  check if the addressed location is an abort address
		if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		 ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		 if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
		    if(i==0)
			tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
		    else
			burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		 end
		 encounter_error = 1'b1;
		end
//  check if the addressed location is beyond the address boundary
		else if ((i+1) > avail_size[31:0]) begin
		 if (encounter_error == 1'b0) begin
		    mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
		 end
		 encounter_error = 1'b1;
		end
		else begin
		 rdy_cnt[7:0] = rdy_cnt[7:0] + 8'h01;
		end
	   end

	   if (encounter_error == 1'b1) rdy_cnt[7:0] = 8'h00;
	end
    end
//  Type4: receives rdy till hitting abort range
//	 starting address is preserved AND
//	 transfer size is promoted to 4, 8 or 16 during cache wrap mode
    else if (access_str == "4") begin
//  access start beyond address boundary
	if (avail_size[31:0] == 32'h00000000) begin
	   rdy_cnt[7:0] = 8'h00;
	   mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
	end
//  access start within address boundary
	else begin
//  linear increment mode
	   if (tmp_cacheline == 1'b0) begin
//  go through all locations that will be accessed from the starting address
		for (i=0;i<tmp_size;i=i+1) begin
		 local_addr = (access_addr+(i*addr_incr));
//  check if the addressed location is an abort address
		 if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		    ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		    if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
			if(i==0)
			  tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
			else
			  burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		    end
		    encounter_error = 1'b1;
		 end
//  check if the addressed location is beyond the address boundary
		 else if ((i+1) > avail_size[31:0]) begin
		    if (encounter_error == 1'b0) begin
			mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
		    end
		    encounter_error = 1'b1;
		 end
		 else begin
		    rdy_cnt[7:0] = rdy_cnt[7:0] + 8'h01;
		 end
		end
	   end
//  cache wrap mode
	   else begin
		if ((tmp_size > 8'h01) && (tmp_size < 8'h04))
		 wrap_size[7:0] = 8'h04;
		else if ((tmp_size > 8'h04) && (tmp_size < 8'h08))
		 wrap_size[7:0] = 8'h08;
		else if ((tmp_size > 8'h08) && (tmp_size < 8'h10))
		 wrap_size[7:0] = 8'h10;
		else
		 wrap_size[7:0] = tmp_size[7:0];
//  go through all locations that will be accessed from the starting address
		for(i=0;i<wrap_size;i=i+1) begin
		 if (bus_width == 32) begin
		    if (wrap_size[7:0] == 8'h04) begin
			if (tmp_hsize==2'b10) begin
			  local_addr[31:4] = access_addr[31:4];
			  local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
			end
			else if (tmp_hsize==2'b01) begin
			  local_addr[31:3] = access_addr[31:3];
			  local_addr[2:0] = (access_addr[2:0] + (i*addr_incr));
			end
			else if (tmp_hsize==2'b00) begin
			  local_addr[31:2] = access_addr[31:2];
			  local_addr[1:0] = (access_addr[1:0] + (i*addr_incr));
			end
		    end
		    else if (wrap_size[7:0] == 8'h08) begin
			if (tmp_hsize==2'b10) begin
			  local_addr[31:5] = access_addr[31:5];
			  local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
			end
			else if (tmp_hsize==2'b01) begin
			  local_addr[31:4] = access_addr[31:4];
			  local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
			end
			else if (tmp_hsize==2'b00) begin
			  local_addr[31:3] = access_addr[31:3];
			  local_addr[2:0] = (access_addr[2:0] + (i*addr_incr));
			end
		    end
		    else if (wrap_size[7:0] == 8'h10) begin
			if (tmp_hsize==2'b10) begin
			  local_addr[31:6] = access_addr[31:6];
			  local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
			end
			else if (tmp_hsize==2'b01) begin
			  local_addr[31:5] = access_addr[31:5];
			  local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
			end
			else if (tmp_hsize==2'b00) begin
			  local_addr[31:4] = access_addr[31:4];
			  local_addr[3:0] = (access_addr[3:0] + (i*addr_incr));
			end
		    end
		    else begin
			local_addr[31:0] = access_addr[31:0];
		    end
		 end
		 else begin
		    if(wrap_size[7:0] == 8'h04) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = (access_addr[4:0] + (i*addr_incr));
		    end
		    else if(wrap_size[7:0] == 8'h08) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = (access_addr[5:0] + (i*addr_incr));
		    end
		    else if(wrap_size[7:0] == 8'h10) begin
			local_addr[31:7] = access_addr[31:7];
			local_addr[6:0] = (access_addr[6:0] + (i*addr_incr));
		    end
		    else begin
			local_addr[31:0] = access_addr[31:0];
		    end
		 end
//  check if the addressed location is an abort address
		 if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		    ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		    if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
			if(i==0)
			  tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
			else
			  burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		    end
		    encounter_error = 1'b1;
		 end
		 else begin
		    if (encounter_error == 1'b0)
			rdy_cnt[7:0] = rdy_cnt[7:0] + 8'h01;
		 end
		end

		if (rdy_cnt[7:0] > tmp_size[7:0])
		 rdy_cnt[7:0] = tmp_size[7:0];
	   end
	end
    end
//  Type5: no rdy for the entire transfer when stepping into the abort range
//	 starting address is rearranged to the beginning of cacheline AND
//	 transfer size is promoted to 4, 8 or 16 during cache wrap mode
    else if (access_str == "5") begin
//  access start beyond address boundary
	if (avail_size[31:0] == 32'h00000000) begin
	   rdy_cnt[7:0] = 8'h00;
	   mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
	end
//  access start within address boundary
	else begin
//  linear increment mode
	   if (tmp_cacheline == 1'b0) begin
//  go through all locations that will be accessed from the starting address
		for (i=0;i<tmp_size;i=i+1) begin
		 local_addr = (access_addr+(i*addr_incr));
//  check if the addressed location is an abort address
		 if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		    ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		    if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
			if(i==0)
			  tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
			else
			  burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		    end
		    encounter_error = 1'b1;
		 end
//  check if the addressed location is beyond the address boundary
		 else if ((i+1) > avail_size[31:0]) begin
		    if (encounter_error == 1'b0) begin
			mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
		    end
		    encounter_error = 1'b1;
		 end
		 else begin
		    if (((tmp_size-i) == 4) || ((tmp_size-i) == 8) ||
			((tmp_size-i) == 16) || (use_rdy2_cnt == 1'b1)) begin
			rdy2_cnt[7:0] = rdy2_cnt[7:0] + 8'h01;
			use_rdy2_cnt = 1'b1;
		    end
		    else begin
			rdy_cnt[7:0] = rdy_cnt[7:0] + 8'h01;
		    end
		 end
		end

		if (encounter_error == 1'b0)
		 rdy_cnt[7:0] = rdy_cnt[7:0] + rdy2_cnt[7:0];
	   end
//  cache wrap mode
	   else begin
		if ((tmp_size > 8'h01) && (tmp_size < 8'h04))
		 wrap_size[7:0] = 8'h04;
		else if ((tmp_size > 8'h04) && (tmp_size < 8'h08))
		 wrap_size[7:0] = 8'h08;
		else if ((tmp_size > 8'h08) && (tmp_size < 8'h10))
		 wrap_size[7:0] = 8'h10;
		else
		 wrap_size[7:0] = tmp_size[7:0];
//  go through all locations that will be accessed from the starting address
		for(i=0;i<wrap_size;i=i+1) begin
		 if (bus_width == 32) begin
		    if (wrap_size[7:0] == 8'h04) begin
			if (tmp_hsize==2'b10) begin
			  local_addr[31:4] = access_addr[31:4];
			  local_addr[3:0] = i*addr_incr;
			end
			else if (tmp_hsize==2'b01) begin
			  local_addr[31:3] = access_addr[31:3];
			  local_addr[2:0] = i*addr_incr;
			end
			else if (tmp_hsize==2'b00) begin
			  local_addr[31:2] = access_addr[31:2];
			  local_addr[1:0] = i*addr_incr;
			end
		    end
		    else if (wrap_size[7:0] == 8'h08) begin
			if (tmp_hsize==2'b10) begin
			  local_addr[31:5] = access_addr[31:5];
			  local_addr[4:0] = i*addr_incr;
			end
			else if (tmp_hsize==2'b01) begin
			  local_addr[31:4] = access_addr[31:4];
			  local_addr[3:0] = i*addr_incr;
			end
			else if (tmp_hsize==2'b00) begin
			  local_addr[31:3] = access_addr[31:3];
			  local_addr[2:0] = i*addr_incr;
			end
		    end
		    else if (wrap_size[7:0] == 8'h10) begin
			if (tmp_hsize==2'b10) begin
			  local_addr[31:6] = access_addr[31:6];
			  local_addr[5:0] = i*addr_incr;
			end
			else if (tmp_hsize==2'b01) begin
			  local_addr[31:5] = access_addr[31:5];
			  local_addr[4:0] = i*addr_incr;
			end
			else if (tmp_hsize==2'b00) begin
			  local_addr[31:4] = access_addr[31:4];
			  local_addr[3:0] = i*addr_incr;
			end
		    end
		    else begin
			local_addr[31:0] = access_addr[31:0];
		    end
		 end
		 else begin
		    if(wrap_size[7:0] == 8'h04) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = i*addr_incr;
		    end
		    else if(wrap_size[7:0] == 8'h08) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = i*addr_incr;
		    end
		    else if(wrap_size[7:0] == 8'h10) begin
			local_addr[31:7] = access_addr[31:7];
			local_addr[6:0] = i*addr_incr;
		    end
		    else begin
			local_addr[31:0] = access_addr[31:0];
		    end
		 end
//  check if the addressed location is an abort address
		 if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		    ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		    if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
			if(i==0)
			  tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
			else
			  burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		    end
		    encounter_error = 1'b1;
		 end
		 else begin
		    rdy_cnt[7:0] = rdy_cnt[7:0] + 8'h01;
		 end
		end

		if (encounter_error == 1'b1)
		 rdy_cnt[7:0] = 8'h00;
		else if (rdy_cnt[7:0] > tmp_size[7:0])
		 rdy_cnt[7:0] = tmp_size[7:0];
	   end
	end
    end

//  Type0: number of rdy is not deterministic
    if (access_str == "0")
	gen_expect_rdy_cnt[31:0] = -1;
    else
	gen_expect_rdy_cnt[31:0] = {24'h000000, rdy_cnt[7:0]};

end
endfunction

//
//##############################################################################
//
// Task to generate noStore flag
//
// Type0: entire transfer are not stored because the starting address is beyond
//	the address boundary
// Type1: data are stored according to the number of rdy received
// Type2: entire transfer are not stored when bursting from abort range back to
//	normal range due to the rearrangement of the starting address to the
//	beginning of the cacheline during cache wrap mode
//	otherwise, data are stored according to the number of rdy received
//
//##############################################################################
//
function gen_noStore;
input[7:0]    store_str;
input[31:0]   access_addr;
input	 tmp_cacheline;
input[1:0]    tmp_hsize;
input[7:0]    tmp_size;
reg[31:0]     addr_incr;
reg[31:0]     local_addr;
reg[7:0]	wrap_size;
reg	   encounter_error;
integer	i;
integer	last_good_locn;
integer	last_error_locn;

begin
    if(bus_width == 32) begin
	if(tmp_hsize == 2'b00)
	   addr_incr = 32'h00000001;
	else if(tmp_hsize == 2'b01)
	   addr_incr = 32'h00000002;
	else if(tmp_hsize == 2'b10)
	   addr_incr = 32'h00000004;
    end
    else
	addr_incr = 32'h00000008;

    wrap_size[7:0] = 8'h00;
    encounter_error = 1'b0;
    last_good_locn = 0;
    last_error_locn = 0;

//  Type0: entire transfer are not stored because the starting address is beyond
//	 the address boundary
    if (store_str == "0") begin
	mabort_cnt[19:0] = mabort_cnt[19:0] + 20'h00001;
	gen_noStore = 1'b1;
    end
//  Type1: data are stored according to the number of rdy received
    else if (store_str == "1") begin
	gen_noStore = 1'b0;
    end
//  Type2: entire transfer are not stored when bursting from abort range back to
//	 normal range due to the rearrangement of the starting address to the
//	 beginning of the cacheline during cache wrap mode
//	 otherwise, data are stored according to the number of rdy received
    else if (store_str == "2") begin
//  linear increment mode
	if (tmp_cacheline == 1'b0) begin
	   gen_noStore = 1'b0;
	end
//  cache wrap mode
	else begin
	   if ((tmp_size > 8'h01) && (tmp_size < 8'h04))
		wrap_size[7:0] = 8'h04;
	   else if ((tmp_size > 8'h04) && (tmp_size < 8'h08))
		wrap_size[7:0] = 8'h08;
	   else if ((tmp_size > 8'h08) && (tmp_size < 8'h10))
		wrap_size[7:0] = 8'h10;
	   else
		wrap_size[7:0] = tmp_size[7:0];
//  go through all locations that will be accessed from the starting address
	   for(i=0;i<wrap_size;i=i+1) begin
		if (bus_width == 32) begin
		 if (wrap_size[7:0] == 8'h04) begin
		    if (tmp_hsize==2'b10) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = i*addr_incr;
		    end
		    else if (tmp_hsize==2'b01) begin
			local_addr[31:3] = access_addr[31:3];
			local_addr[2:0] = i*addr_incr;
		    end
		    else if (tmp_hsize==2'b00) begin
			local_addr[31:2] = access_addr[31:2];
			local_addr[1:0] = i*addr_incr;
		    end
		 end
		 else if (wrap_size[7:0] == 8'h08) begin
		    if (tmp_hsize==2'b10) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = i*addr_incr;
		    end
		    else if (tmp_hsize==2'b01) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = i*addr_incr;
		    end
		    else if (tmp_hsize==2'b00) begin
			local_addr[31:3] = access_addr[31:3];
			local_addr[2:0] = i*addr_incr;
		    end
		 end
		 else if (wrap_size[7:0] == 8'h10) begin
		    if (tmp_hsize==2'b10) begin
			local_addr[31:6] = access_addr[31:6];
			local_addr[5:0] = i*addr_incr;
		    end
		    else if (tmp_hsize==2'b01) begin
			local_addr[31:5] = access_addr[31:5];
			local_addr[4:0] = i*addr_incr;
		    end
		    else if (tmp_hsize==2'b00) begin
			local_addr[31:4] = access_addr[31:4];
			local_addr[3:0] = i*addr_incr;
		    end
		 end
		 else begin
		    local_addr[31:0] = access_addr[31:0];
		 end
		end
		else begin
		 if(wrap_size[7:0] == 8'h04) begin
		    local_addr[31:5] = access_addr[31:5];
		    local_addr[4:0] = i*addr_incr;
		 end
		 else if(wrap_size[7:0] == 8'h08) begin
		    local_addr[31:6] = access_addr[31:6];
		    local_addr[5:0] = i*addr_incr;
		 end
		 else if(wrap_size[7:0] == 8'h10) begin
		    local_addr[31:7] = access_addr[31:7];
		    local_addr[6:0] = i*addr_incr;
		 end
		 else begin
		    local_addr[31:0] = access_addr[31:0];
		 end
		end
//  check if the addressed location is an abort address
		if(((local_addr & abort_mask) >= (abort_start_addr & abort_mask)) &&
		 ((local_addr & abort_mask) <= (abort_end_addr & abort_mask))) begin
		 if(encounter_error == 1'b0) begin
//  increment appropriate target abort counters depending
//  on location of abort address in the burst
		    if(i==0)
			tabort_cnt[19:0] = tabort_cnt[19:0] + 20'h00001;
		    else
			burst_mid_err_cnt[19:0] = burst_mid_err_cnt[19:0] + 20'h00001;
		 end
		 encounter_error = 1'b1;
		 last_error_locn = i;
		end
		else begin
		 last_good_locn = i;
		end
	   end

	   if ((encounter_error == 1'b1) && (last_error_locn < last_good_locn))
		gen_noStore = 1'b1;
	   else
		gen_noStore = 1'b0;
	end
    end
end
endfunction

//
//##############################################################################
//
// Task to generate byte enables for a read access
//
//##############################################################################
//
function[be_width-1:0] gen_rbe_b;
input[15:0] rbe_b_str;
input[7:0]  int_size;
input[7:0]  rand;
reg[7:0]    local_str;
integer     i;
integer     j;
integer     k;
begin
    for(i=0;i<2;i=i+1) begin
	for(j=0;j<8;j=j+1) begin
	    local_str[j] = rbe_b_str[i*8+j];
	end
	case(local_str)
//		contiguous byte enable generation for single access
		"c" : begin
			if(int_size == 8'h01) begin
			   if (bus_width == 32) begin
				if (rand[1:0] == 2'b01) begin
				   gen_rbe_b[be_width-1:0] = 4'b1110;
				   k = rand[3:2];
				end
				else if (rand[1:0] == 2'b10) begin
				   gen_rbe_b[be_width-1:0] = 4'b1100;
				   k = rand[3:2] % 3;
				end
				else if (rand[1:0] == 2'b11) begin
				   gen_rbe_b[be_width-1:0] = 4'b1000;
				   k = rand[3];
				end
				else begin
				   gen_rbe_b[be_width-1:0] = 4'b0000;
				   k = 0;
				end
			   end

			   if (bus_width == 64) begin
				if (rand[2:0] == 3'b001) begin
				   gen_rbe_b[be_width-1:0] = 8'b11111110;
				   k = rand[5:3];
				end
				else if (rand[2:0] == 3'b010) begin
				   gen_rbe_b[be_width-1:0] = 8'b11111100;
				   k = rand[5:3] % 7;
				end
				else if (rand[2:0] == 3'b011) begin
				   gen_rbe_b[be_width-1:0] = 8'b11111000;
				   k = rand[5:3] % 6;
				end
				else if (rand[2:0] == 3'b100) begin
				   gen_rbe_b[be_width-1:0] = 8'b11110000;
				   k = rand[5:3] % 5;
				end
				else if (rand[2:0] == 3'b101) begin
				   gen_rbe_b[be_width-1:0] = 8'b11100000;
				   k = rand[5:4];
				end
				else if (rand[2:0] == 3'b110) begin
				   gen_rbe_b[be_width-1:0] = 8'b11000000;
				   k = rand[5:3] % 3;
				end
				else if (rand[2:0] == 3'b111) begin
				   gen_rbe_b[be_width-1:0] = 8'b10000000;
				   k = rand[5];
				end
				else begin
				   gen_rbe_b[be_width-1:0] = 8'b00000000;
				   k = 0;
				end
			   end

			// left shift to create different contiguous byte enable pattern
			   for(j=1;j<k+1;j=j+1) begin
				gen_rbe_b[be_width-1:0] = {gen_rbe_b[be_width-2:0], 1'b1};
			   end
			end
		    end
//		random byte enable generation for single access
		"r" : begin
			if(int_size == 8'h01) begin
			   gen_rbe_b[be_width-1:0] = rand[be_width-1:0];
			   if((gen_rbe_b[3:0] == 4'hf) && (bus_width == 32))
				gen_rbe_b[3] = 1'b0;
			   else if((gen_rbe_b[be_width-1:0] == 8'hff) && (bus_width == 64))
				gen_rbe_b[be_width-1] = 1'b0;

			end
		     end
//	     0 byte enable generation
		"0" : begin
			if (bus_width == 32)
			   gen_rbe_b[be_width-1:0] = 4'h0;
			else if (bus_width == 64)
			   gen_rbe_b[be_width-1:0] = 8'h00;
		     end
	endcase
    end
end
endfunction

//
//##############################################################################
//
// Task to generate byte enables for a write access
//
//##############################################################################
//
task gen_wbe_b;
input[15:0]	wbe_b_str;
inout[31:0]	rseed1;
inout[31:0]	rseed2;
input[7:0]	int_size;
reg[7:0]	  local_str;
reg[be_width-1:0] tmp_be_b;
reg[31:0]	 rand;
integer	   i;
integer	   j;
integer	   k;
begin
    get_random(rseed1, rseed2, rand);
//  grab the characters in the access width string
    for(i=0;i<2;i=i+1) begin
	for(j=0;j<8;j=j+1) begin
	    local_str[j] = wbe_b_str[i*8+j];
	end
	case(local_str)
//	contiguous byte enable generation for single access
	    "c" : begin
		    if(int_size == 8'h01) begin
			   if (bus_width == 32) begin
				if (rand[31:30] == 2'b01) begin
				   tmp_be_b[be_width-1:0] = 4'b1110;
				   k = rand[29:28];
				end
				else if (rand[31:30] == 2'b10) begin
				   tmp_be_b[be_width-1:0] = 4'b1100;
				   k = rand[29:28] % 3;
				end
				else if (rand[31:30] == 2'b11) begin
				   tmp_be_b[be_width-1:0] = 4'b1000;
				   k = rand[29];
				end
				else begin
				   tmp_be_b[be_width-1:0] = 4'b0000;
				   k = 0;
				end
			   end

			   if (bus_width == 64) begin
				if (rand[31:29] == 3'b001) begin
				   tmp_be_b[be_width-1:0] = 8'b11111110;
				   k = rand[28:26];
				end
				else if (rand[31:29] == 3'b010) begin
				   tmp_be_b[be_width-1:0] = 8'b11111100;
				   k = rand[28:26] % 7;
				end
				else if (rand[31:29] == 3'b011) begin
				   tmp_be_b[be_width-1:0] = 8'b11111000;
				   k = rand[28:26] % 6;
				end
				else if (rand[31:29] == 3'b100) begin
				   tmp_be_b[be_width-1:0] = 8'b11110000;
				   k = rand[28:26] % 5;
				end
				else if (rand[31:29] == 3'b101) begin
				   tmp_be_b[be_width-1:0] = 8'b11100000;
				   k = rand[28:27];
				end
				else if (rand[31:29] == 3'b110) begin
				   tmp_be_b[be_width-1:0] = 8'b11000000;
				   k = rand[28:26] % 3;
				end
				else if (rand[31:29] == 3'b111) begin
				   tmp_be_b[be_width-1:0] = 8'b10000000;
				   k = rand[28];
				end
				else begin
				   tmp_be_b[be_width-1:0] = 8'b00000000;
				   k = 0;
				end
			   end

			// left shift to create different contiguous byte enable pattern
			   for(j=1;j<k+1;j=j+1) begin
				tmp_be_b[be_width-1:0] = {tmp_be_b[be_width-2:0], 1'b1};
			   end

			   wbe_b[0] = tmp_be_b;
		    end
		  end
//		byte enable is random for single access
	    "r" : begin
			if(int_size == 8'h01) begin
			    tmp_be_b = rand[be_width-1:0];
			    if((tmp_be_b[3:0] == 4'hf) && (bus_width == 32))
				tmp_be_b[3] = 1'b0;
			    else if ((tmp_be_b[be_width-1:0] == 8'hff) && (bus_width == 64))
				tmp_be_b[be_width-1] = 1'b0;

			    wbe_b[0] = tmp_be_b;
			end
		  end
//		variable random byte enable for each transfer in a burst access
	    "v" : begin
			get_random(rseed1, rseed2, rand);
//			1/8 of the chance wbe_b are purely random
			if(rand[2:0] == 3'b111) begin
			   for(k=0;k<int_size;k=k+1) begin
				get_random(rseed1, rseed2, rand);
				if(be_width == 4)
				  wbe_b[k] = rand[31:28];
				else if(be_width == 8)
				  wbe_b[k] = rand[31:24];
			   end
			end
//			1/8 of the chance wbe_b are all '0'
			else if(rand[2:0] == 3'b000) begin
			   for(k=0;k<int_size;k=k+1) begin
				if(be_width == 4)
				  wbe_b[k] = 4'b0000;
				else if(be_width == 8)
				  wbe_b[k] = 8'h00;
			   end
			end
//			6/8 of the chance wbe_b are mixed
			else begin
//			In mixed mode,
//			1/2 of the chance full byte enable
//			3/8 of the chance random byte enable
//			1/8 of the chance inactive byte enable
			   k = 0;
			   while(k<int_size) begin
				get_random(rseed1, rseed2, rand);
				if (rand[18] == 1'b0) begin
				   if(be_width == 4)
					wbe_b[k] = 4'b0000;
				   else if(be_width == 8)
					wbe_b[k] = 8'h00;
				end
				else if(rand[18:16] == 3'b100) begin
				   if(be_width == 4)
					wbe_b[k] = 4'b1111;
				   else if(be_width == 8)
					wbe_b[k] = 8'hff;
				end
				else begin
				   if(be_width == 4)
					wbe_b[k] = rand[15:12];
				   else if(be_width == 8)
					wbe_b[k] = rand[15:8];
				end
				k = k+1;
			   end
			end
		  end
//		byte enables must be all 0's for burst access
	    "0" : begin
			for(k=0;k<int_size;k=k+1) begin
			   if(be_width == 4)
				wbe_b[k] = 4'b0000;
			   else if(be_width == 8)
				wbe_b[k] = 8'h00;
			end
		  end
//		byte enables must be contiguous for burst access
	    "b" : begin
			for(k=0;k<int_size;k=k+1) begin
			   if (k == 0) begin
				get_random(rseed1, rseed2, rand);
				if(be_width == 4) begin
				   if(rand[7:6] == 2'b01)
					wbe_b[k] = 4'b0111;
				   else if(rand[7:6] == 2'b10)
					wbe_b[k] = 4'b0011;
				   else if(rand[7:6] == 2'b11)
					wbe_b[k] = 4'b0001;
				   else
					wbe_b[k] = 4'b0000;
				end
				else if(be_width == 8) begin
				   if(rand[7:5] == 3'b001)
					wbe_b[k] = 8'b01111111;
				   else if(rand[7:5] == 3'b010)
					wbe_b[k] = 8'b00111111;
				   else if(rand[7:5] == 3'b011)
					wbe_b[k] = 8'b00011111;
				   else if(rand[7:5] == 3'b100)
					wbe_b[k] = 8'b00001111;
				   else if(rand[7:5] == 3'b101)
					wbe_b[k] = 8'b00000111;
				   else if(rand[7:5] == 3'b110)
					wbe_b[k] = 8'b00000011;
				   else if(rand[7:5] == 3'b111)
					wbe_b[k] = 8'b00000001;
				   else
					wbe_b[k] = 8'b00000000;
				end
			   end
			   else if (k == int_size-1) begin
				get_random(rseed1, rseed2, rand);
				if(be_width == 4) begin
				   if(rand[23:22] == 2'b01)
					wbe_b[k] = 4'b1110;
				   else if(rand[23:22] == 2'b10)
					wbe_b[k] = 4'b1100;
				   else if(rand[23:22] == 2'b11)
					wbe_b[k] = 4'b1000;
				   else
					wbe_b[k] = 4'b0000;
				end
				else if(be_width == 8) begin
				   if(rand[23:21] == 3'b001)
					wbe_b[k] = 8'b11111110;
				   else if(rand[23:21] == 3'b010)
					wbe_b[k] = 8'b11111100;
				   else if(rand[23:21] == 3'b011)
					wbe_b[k] = 8'b11111000;
				   else if(rand[23:21] == 3'b100)
					wbe_b[k] = 8'b11110000;
				   else if(rand[23:21] == 3'b101)
					wbe_b[k] = 8'b11100000;
				   else if(rand[23:21] == 3'b110)
					wbe_b[k] = 8'b11000000;
				   else if(rand[23:21] == 3'b111)
					wbe_b[k] = 8'b10000000;
				   else
					wbe_b[k] = 8'b00000000;
				end
			   end
			   else begin
				if(be_width == 4)
				   wbe_b[k] = 4'b0000;
				else if(be_width == 8)
				   wbe_b[k] = 8'h00;
			   end
			end
		  end
	endcase
    end
end
endtask

//
//##############################################################################
//
// Task to generate address bits 1 and 0
//
//##############################################################################
//
task gen_addr1_0;
input[7:0]	  addr1_0_str;
input[be_width-1:0] be_b;
input[1:0]	  tmp_hsize;
input		rw_sel;
input[1:0]	  rand;
inout[31:0]	 addr;
input		    big_endian;
reg[7:0]	    local_str;
reg[be_width-1:0]   tmp_be_b;
integer		    j;
begin
//  grab the characters in the access width string
    for(j=0;j<8;j=j+1) begin
	local_str[j] = addr1_0_str[j];
    end
    case(local_str)
//	if address bits 1 and 0 must be 2'b00
	"0" : addr[1:0] = 2'b00;
//	if address bits 1 and 0 must follow the byte enable
	"b" : begin
		    if (big_endian==1'b0) begin
			if(rw_sel == 1'b1)
			    tmp_be_b = wbe_b[0];
			else
			    tmp_be_b = be_b;
			if(tmp_be_b[0] == 1'b0)
			    addr[1:0] = 2'b00;
			else if(tmp_be_b[1] == 1'b0)
			    addr[1:0] = 2'b01;
			else if(tmp_be_b[2] == 1'b0)
			    addr[1:0] = 2'b10;
			else if(tmp_be_b[3] == 1'b0)
			    addr[1:0] = 2'b11;
		    end
		    else begin
			if(rw_sel == 1'b1)
			    tmp_be_b = wbe_b[0];
			else
			    tmp_be_b = be_b;
			if(tmp_be_b[3] == 1'b0)
			    addr[1:0] = 2'b00;
			else if(tmp_be_b[2] == 1'b0)
			    addr[1:0] = 2'b01;
			else if(tmp_be_b[1] == 1'b0)
			    addr[1:0] = 2'b10;
			else if(tmp_be_b[0] == 1'b0)
			    addr[1:0] = 2'b11;
		    end
		end
//	if address bits 1 and 0 are random
	"r" : begin
//		for 32-bit access, addr[1:0] must be 00 because
//		all byte enable are active
		if(tmp_hsize == 2'b10) begin
		   addr[1:0] = 2'b00;
		end
//		for 16-bit access, addr[1] is random but addr[0] is 0
		else if(tmp_hsize == 2'b01) begin
		   addr[1] = rand[1];
		   addr[0] = 1'b0;
		end
//		for 8-bit access, addr[1:0] are random
		else if(tmp_hsize == 2'b00) begin
		   addr[1:0] = rand;
		end
		end
//	leave addr[1:0] unchanged
	"c" : begin
		end
    endcase
end
endtask

//
//##############################################################################
//
// Task to generate write data
//
//##############################################################################
//
task gen_wdata;
input		config_acc_flag;
input[bus_width-1:0] config_addr_value;
inout[31:0]	  rseed1;
inout[31:0]	  rseed2;
input[7:0]	   size;
integer		i;
reg[bus_width-1:0]   tmp_wdata;
begin
//  randomly generate the write data for the current burst size
    if(config_acc_flag == 1'b0) begin
	for(i=0;i<size;i=i+1) begin
	   get_random(rseed1, rseed2, tmp_wdata[31:0]);
	   if (bus_width == 64) begin
		get_random(rseed1, rseed2, tmp_wdata[bus_width-1:bus_width-32]);
	   end
	   wdata[i] = tmp_wdata[bus_width-1:0];
	end
    end
//  generation of random write data to user defined CONFIG_ADDR area
    else if(config_acc_flag == 1'b1) begin
	wdata[0] = config_addr_value[bus_width-1:0];
    end
end
endtask

//
//##############################################################################
//
// Task to generate index into the storage area
//
//##############################################################################
//
function[store_length-1:0] gen_idx;
input[31:0] rand_addr_bits;
begin
     gen_idx[store_length-1:0] = rand_addr_bits[store_length-1:0];
end
endfunction

//
// ##########################################################################
//
// Function to generate new datacnt
//
// ##########################################################################
//
function[7:0] gen_new_datacnt;
input[7:0]    datacnt;
begin
   gen_new_datacnt = (done_flag == 1'b1) ? (datacnt[7:0] - 8'h01) : datacnt[7:0];
end
endfunction

//
// ##########################################################################
//
// Write task
//
// This task is called when the master backend model decides to perform a
// write transaction. It allows the master backend model to initiate a write
// request according to the ECconnect bus protocol. At the same time, it
// also backups the write data so that it can be retrieved later for data
// comparison during the read transaction.
//
// Explanation of all inputs/outputs
// tmp_addr	 : Starting address of the access
// tmp_cacheline : Burst ordering of the access
//		   (0=Linear Increment, 1=Cacheline Wrap)
// rand_addr_bits: rand_addr_bits indicate the storage index of the data. It
//		   composes of the address bit designated for data storage.
//		   rand_addr_bits can also be computed by gen_storage_idx task.
// tmp_size	 : No. of words requested for the transfer
// tmp_cs_b	 : User defined chip select for the access
// rseed1, rseed2: Random number seeds
//		   (Inout of get_random task)
// noStore	 : noStore indicates whether user wants the data to be back up
//		   for later comparison during read.
//		   (0=Data backup, 1=No Data backup)
// tmp_hsize	 : No. of bits being accessed in 32-bits AHB bus
//		   (00=8 bit, 01=16 bits, 10=32 bits, 11=undefined)
//		   tmp_hsize is ignored when bus_width=64
// avail_size	 : avail_size calculates the available storage left for the
//		   current target access before hitting the storage limit based
//		   on the starting address so that tmp_size will be adjusted
//		   according to boundary_cross parameter.
//		   (User may tie avail_size to 32'hffffffff if they guarantees
//		 that the access will not be beyond the storage limit.)
// expect_rdy_cnt: Expect the number of rdy to return during the access
//		 In normal access without any error, expect_rdy_cnt equals
//		 to tmp_size. However, for any early termination due to an
//		   error or other reasons, expect_rdy_cnt is less than
//		   tmp_size and may not be deterministic.
//
// P.S. User needs to provide the two dimensional array of wbe_b[*] and
//	wdata[*] for the byte enable and the data of the write transaction.
//
// ##########################################################################
//
task mtrwrite;
input[31:0]		tmp_addr;
input			tmp_cacheline;
input[31:0]		rand_addr_bits;
input[7:0]		tmp_size;
input[num_cs-1:0]     tmp_cs_b;
inout[31:0]	   rseed1;
inout[31:0]	   rseed2;
input		 noStore;
input[1:0]		tmp_hsize;
input[31:0]	   avail_size;
input[31:0]	   expect_rdy_cnt;

reg[7:0]		datacnt;
reg			done;
reg		   ecc2_terminate;
reg[be_width-1:0]     first_wbe_b;
reg[store_length-1:0] idx;
reg[7:0]		local_cache_size;
reg[31:0]		ran3;
reg			rdy_flag;
reg[store_length-1:0] start_idx;
reg[be_width-1:0]     tmp_wbe_b;
reg[bus_width-1:0]    wdt_new;
reg[bus_width-1:0]    wdt_tmp;
reg[7:0]		wr_ptr;
reg			write_abort;
reg[31:0]	     sideband_addr;
reg		   sideband_cacheline;
reg[num_cs-1:0]	sideband_cs_b;
reg[7:0]		sideband_size;
integer		j;
integer			k;
integer			width_count;
integer		trfr_count;
integer		num_wait_states;

begin

   wr_ptr[7:0] = 8'h00;
   datacnt = 8'h00;
   done = 1'b0;
   write_abort = 1'b0;
   first_wbe_b[be_width-1:0] = wbe_b[wr_ptr];
   rdy_flag = 1'b0;
   ecc2_terminate = 1'b0;

   @(posedge clk);
// generate output signals for this access
   ads_b <= #1 1'b0;
   cs_b <= #1 tmp_cs_b;
   addr[31:0] <= #1 tmp_addr[31:0];

   cacheline <= #1 tmp_cacheline;
   size[15:0] <= #1 {8'h00, tmp_size[7:0]};
   wait_b <= #1 1'b1;
   wr <= #1 1'b1;
   be_b[be_width-1:0] <= #1 wbe_b[wr_ptr];
   if(ecconnect == 1)
	dwr[bus_width-1:0] <= #1 wdata[wr_ptr];
// transfer size local counter. stop transfer when this reaches 0 on masters
// not supporting done_b
   datacnt = tmp_size;

   sideband_addr[31:0] = tmp_addr[31:0];
   sideband_cs_b[num_cs-1:0] = tmp_cs_b[num_cs-1:0];
   sideband_size[7:0] = tmp_size[7:0];
   sideband_cacheline = tmp_cacheline;

   gen_sideband(sideband_addr, sideband_cs_b, sideband_cacheline,
		sideband_size, 1'b1, rseed1, rseed2);

   while (done==1'b0) begin
	get_random(rseed1, rseed2, ran3);
	@(posedge clk) begin

//	   de-assert ads_b after first cycle
	   ads_b <= #1 1'b1;
//	   transfer data whenever rdy_b is asserted
	   if ((rdy_b==1'b0) || ((ecconnect == 2) && (rdy_flag == 1'b1))) begin
		if((ecconnect == 2) && (rdy_b == 1'b0) && (ecconnect2_early_terminate == 1'b1) &&
		   (ran3[13:8] == 6'b000000)) begin
		   rdy_flag = 1'b0;
		   blast_b <= #1 1'b0;
		   @(posedge clk);
		   blast_b <= #1 1'b1;
		   datacnt = 8'h00;
		   ecc2_terminate = 1'b1;
		   master_trfr_terminate_cnt = master_trfr_terminate_cnt + 20'h00001;
		end
		else
		   rdy_flag = 1'b1;
		if (ecconnect == 1) begin
		    wr_ptr[7:0] = wr_ptr[7:0]+8'h01;
		    be_b[be_width-1:0] <= #1 wbe_b[wr_ptr];
		    dwr[bus_width-1:0] <= #1 wdata[wr_ptr];
		    datacnt[7:0] = gen_new_datacnt(datacnt);
		    if((size[15:0] == 16'h0001) || (datacnt == 8'h01))
			blast_b <= #1 1'b0;
		end
		else if((ecconnect == 2) && (rdy_flag == 1'b1)) begin
		    dwr[bus_width-1:0] <= #1 wdata[wr_ptr];
		    be_b[be_width-1:0] <= #1 wbe_b[wr_ptr];
		    if(datacnt == 8'h00)
			wren_b <= #1 1'b1;
		    else begin
			if((ecconnect2_wait_states > 0) && ((tmp_size != 8'h01)
			&& (wren_b != 1'b0))) begin
			  num_wait_states = (ran3[31:0]) % ecconnect2_wait_states;
			  repeat (num_wait_states) begin
				  wren_b <= #1 1'b1;
				  @(posedge clk);
			  end
			end
			wren_b <= #1 1'b0;
			if (tmp_size == 8'h01)
			   wr_ptr[7:0] = 8'h01;
			else if (datacnt > 8'h01)
			   wr_ptr[7:0] = wr_ptr[7:0]+8'h01;
			if(wren_b == 1'b0) begin
			  datacnt[7:0] = gen_new_datacnt(datacnt);
			end
		    end
		    if((size[15:0] == 16'h0001) || (datacnt == 8'h01))
			blast_b <= #1 1'b0;
		    else if((ran3[26:20] == 7'b0000000) && (ecconnect2_early_terminate == 1'b1)) begin
			blast_b <= #1 1'b0;
			@(posedge clk);
			wren_b <= #1 1'b1;
			blast_b <= #1 1'b1;
			datacnt = 8'h00;
			early_terminate_cnt = early_terminate_cnt + 20'h00001;
		    end
		end
	   end
//	   end of transfer is reached whenever done_b is asserted OR
//	   all data is transferred, indicated by datacnt
	   if ((done_b==1'b0) || (datacnt == 8'h00))
	   begin
		done = 1'b1;
//		make output signals don't care once the transfer completes
		if (bus_width == 32) begin
		   dwr[bus_width-1:0] <= #1 32'hxxxxxxxx;
		   be_b[be_width-1:0] <= #1 4'hx;
		end
		else if (bus_width == 64) begin
		   dwr[bus_width-1:0] <= #1 64'hxxxxxxxxxxxxxxxx;
		   be_b[be_width-1:0] <= #1 8'hxx;
		end
		wr <= #1 1'bx;
		size <= #1 16'bxxxxxxxxxxxxxxxx;
		wren_b <= #1 1'b1;
		rdnxt_b <= #1 1'b1;
		blast_b <= #1 1'b1;
		cacheline <= #1 1'bx;
		cs_b <= #1 16'bxxxxxxxxxxxxxxxx;
	   end
//	   flag to remember errors during transfer
	   if (err_b == 1'b0) write_abort = 1'b1;
	   if ((err_b == 1'b0) && (done_b !== 1'b0)) done = 1'b1;
	   if ((test_state==32'h00000100) && (ran3[1:0]== 2'b11)) wait_b <= #1 1'b0;
	   else wait_b <= #1 1'b1;
	end
   end
   @(posedge clk);
   blast_b <= #1 1'b1;
   trfr_count = wr_ptr;

// compare the number of expected rdy with the actual outcome
   if((expect_rdy_cnt == trfr_count) || (expect_rdy_cnt == -1))
	;
   else begin
	$write("Error: Master %b Write rdy number mismatch, expect %d, get %d.\n",
		master_id, expect_rdy_cnt, trfr_count);
	$stop;
   end

   if(avail_size[31:0] < {24'h000000,trfr_count}) trfr_count[7:0] = avail_size[7:0];

// if noStore is set then do not store any data
   if ((noStore == 1'b1) || (ecc2_terminate == 1'b1));
// store data in data store
   else begin
	start_idx[store_length-1:0] = gen_idx(rand_addr_bits);
	idx = start_idx;
	local_cache_size = gen_cache_size(tmp_size);
	width_count = 0;
	if(tmp_hsize == 2'b00) width_count[1:0] = tmp_addr[1:0];
	else if(tmp_hsize == 2'b01) width_count[0] = tmp_addr[1];
	j=0;
	for (k=0; k<trfr_count; k=k+1) begin
	    if ((tmp_cacheline==1'b0) || (local_cache_size>16))
		idx[store_length-1:0] = start_idx[store_length-1:0] + j;
	    else begin
		if (local_cache_size<=4) begin
		    if(tmp_hsize == 2'b00);
		    else if(tmp_hsize == 2'b01) begin
			idx[store_length-1:1] = start_idx[store_length-1:1];
			idx[0] = start_idx[0] + j;
		    end
		    else begin
			idx[store_length-1:2] = start_idx[store_length-1:2];
			idx[1:0] = start_idx[1:0] + j;
		    end
		end
		else if (local_cache_size<=8) begin
		    if(tmp_hsize == 2'b00) begin
			idx[store_length-1:1] = start_idx[store_length-1:1];
			idx[0] = start_idx[0] + j;
		    end
		    else if(tmp_hsize == 2'b01) begin
			idx[store_length-1:2] = start_idx[store_length-1:2];
			idx[1:0] = start_idx[1:0] + j;
		    end
		    else begin
			idx[store_length-1:3] = start_idx[store_length-1:3];
			idx[2:0] = start_idx[2:0] + j;
		    end
		end
		else if (local_cache_size<=16) begin
		    if(tmp_hsize == 2'b00) begin
			idx[store_length-1:2] = start_idx[store_length-1:2];
			idx[1:0] = start_idx[1:0] + j;
		    end
		    else if(tmp_hsize == 2'b01) begin
			idx[store_length-1:3] = start_idx[store_length-1:3];
			idx[2:0] = start_idx[2:0] + j;
		    end
		    else begin
			idx[store_length-1:4] = start_idx[store_length-1:4];
			idx[3:0] = start_idx[3:0] + j;
		    end
		end
	    end

	    tmp_wbe_b[be_width-1:0] = wbe_b[k];
	    wdt_new[bus_width-1:0] = wdata[k];
//	    fetch current data at location idx in data store
	    gen_store_retrieve(tmp_cs_b,1'b0,idx,wdt_tmp);
//	    8-bit access data selection
	    if(tmp_hsize == 2'b00)
	    begin
		if (big_endian==1'b0) begin
		   if (width_count == 3) wdt_tmp[31:24] = wdt_new[31:24];
		   if (width_count == 2) wdt_tmp[23:16] = wdt_new[23:16];
		   if (width_count == 1) wdt_tmp[15:8]  = wdt_new[15:8];
		   if (width_count == 0) wdt_tmp[7:0]   = wdt_new[7:0];
		end
		else begin
		   if (width_count == 0) wdt_tmp[31:24] = wdt_new[31:24];
		   if (width_count == 1) wdt_tmp[23:16] = wdt_new[23:16];
		   if (width_count == 2) wdt_tmp[15:8]  = wdt_new[15:8];
		   if (width_count == 3) wdt_tmp[7:0]   = wdt_new[7:0];
		end
	    end
	    else if(tmp_hsize == 2'b01)
//	    16-bit access data selection
	    begin
		if (big_endian==1'b0) begin
		   if (width_count == 1) wdt_tmp[31:16] = wdt_new[31:16];
		   if (width_count == 0) wdt_tmp[15:0]  = wdt_new[15:0];
		end
		else begin
		   if (width_count == 0) wdt_tmp[31:16] = wdt_new[31:16];
		   if (width_count == 1) wdt_tmp[15:0]  = wdt_new[15:0];
		end
	    end
//	    32-bit access data selection
	    else begin
		   if (tmp_wbe_b[0]==1'b0) wdt_tmp[7:0]   = wdt_new[7:0];
		   if (tmp_wbe_b[1]==1'b0) wdt_tmp[15:8]  = wdt_new[15:8];
		   if (tmp_wbe_b[2]==1'b0) wdt_tmp[23:16] = wdt_new[23:16];
		   if (tmp_wbe_b[3]==1'b0) wdt_tmp[31:24] = wdt_new[31:24];
		   if (be_width == 8) begin
			if (tmp_wbe_b[be_width-4]==1'b0) wdt_tmp[bus_width-25:bus_width-32]   = wdt_new[bus_width-25:bus_width-32];
			if (tmp_wbe_b[be_width-3]==1'b0) wdt_tmp[bus_width-17:bus_width-24]  = wdt_new[bus_width-17:bus_width-24];
			if (tmp_wbe_b[be_width-2]==1'b0) wdt_tmp[bus_width-9:bus_width-16] = wdt_new[bus_width-9:bus_width-16];
			if (tmp_wbe_b[be_width-1]==1'b0) wdt_tmp[bus_width-1:bus_width-8] = wdt_new[bus_width-1:bus_width-8];
		   end
	    end
//	    store new data in location idx in data store
	    gen_store_retrieve(tmp_cs_b,1'b1,idx,wdt_tmp);
	    if(tmp_hsize == 2'b01) width_count = (width_count + 1) % 2;
	    else if(tmp_hsize == 2'b00) width_count = (width_count + 1) % 4;
	    if(width_count == 0) j=j+1;
	end
   end
end
endtask

//
// ##########################################################################
//
// Read task
//
// This task is called when the master backend model decides to perform a
// read transaction. It allows the master backend model to initiate a read
// request according to the ECconnect bus protocol. However, the data
// comparison is actually done when compare_rd_data is called after mtrread.
//
// Explanation of all inputs/outputs
// tmp_addr	 : Starting address of the access
// tmp_cacheline : Burst ordering of the access
//		   (0=Linear Increment, 1=Cacheline Wrap)
// tmp_size	 : No. of words requested for the transfer
// tmp_cs_b	 : User defined chip select for the access
// tmp_rbe_b	 : Read byte enable. For burst transfer,
//		 tmp_rbe_b needs to be all asserted.
// rseed1, rseed2: Random number seeds
//		   (Inout of get_random task)
// expect_rdy_cnt: Expect the number of rdy to return during the access
//		 In normal access without any error, expect_rdy_cnt equals
//		 to tmp_size. However, for any early termination due to an
//		   error or other reasons, expect_rdy_cnt is less than
//		   tmp_size and may not be deterministic.
// trfr_count	 : Actual number of data being transferred which is used in
//		 compare_rd_data task.
//		 Output from mtrread.
//
// P.S. User needs to provide the one dimensional array of tmp_rbe_b for the
//	byte enable of the read transaction. For burst transfer, tmp_rbe_b
//	should be declared as 4'b0000.
//
// ##########################################################################
//
task mtrread;
input[31:0]		tmp_addr;
input			tmp_cacheline;
input[7:0]		tmp_size;
input[num_cs-1:0]     tmp_cs_b;
input[be_width-1:0]   tmp_rbe_b;
inout[31:0]	   rseed1;
inout[31:0]	   rseed2;
input[31:0]	   expect_rdy_cnt;
output[7:0]	   trfr_count;

reg[bus_width-1:0]    data;
reg[7:0]		datacnt;
reg			done;
reg[store_length-1:0] idx;
reg[31:0]		ran4;
reg			rdy_flag;
reg[7:0]		rd_ptr;
reg[bus_width-1:0]    rdt_tmp;
reg			read_abort;
reg[store_length-1:0] start_idx;
reg[31:0]	     sideband_addr;
reg		   sideband_cacheline;
reg[num_cs-1:0]	sideband_cs_b;
reg[7:0]		sideband_size;
integer			k;

begin

   rd_ptr[7:0] = 8'b00000000;
   done = 1'b0;
   read_abort = 1'b0;
   datacnt = 8'h00;
   rdy_flag = 1'b0;

   @(posedge clk);
// generate output signals for current access
   ads_b <= #1 1'b0;
   cs_b <= #1 tmp_cs_b;
   addr[31:0] <= #1 tmp_addr[31:0];
   cacheline <= #1 tmp_cacheline;
   size[15:0] <= #1 {8'h00, tmp_size[7:0]};
// transfer size counter
   datacnt = tmp_size;
   wait_b <= #1 1'b1;
   wr <= #1 1'b0;
   rdnxt_b <= #1 1'b1;
   be_b[be_width-1:0] = tmp_rbe_b[be_width-1:0];

   sideband_addr[31:0] = tmp_addr[31:0];
   sideband_cs_b[num_cs-1:0] = tmp_cs_b[num_cs-1:0];
   sideband_size[7:0] = tmp_size[7:0];
   sideband_cacheline = tmp_cacheline;

   gen_sideband(sideband_addr, sideband_cs_b, sideband_cacheline,
		sideband_size, 1'b1, rseed1, rseed2);

   while (done==1'b0) begin
	get_random(rseed1, rseed2, ran4);
	@(posedge clk) begin
	   if ((rdy_b==1'b0) || ((ecconnect == 2) && (rdy_flag == 1'b1))) begin
		if((ecconnect == 2) && (rdy_b == 1'b0) && (ecconnect2_early_terminate == 1'b1) &&
		   (ran4[13:8] == 6'b000000) && err_b) begin
		   $write("master %b early terminate\n", master_id);
		   rdy_flag = 1'b0;
		   blast_b <= #1 1'b0;
		   @(posedge clk);
		   blast_b <= #1 1'b1;
		   datacnt = 8'h00;
		   master_trfr_terminate_cnt = master_trfr_terminate_cnt + 20'h00001;
		end
		else if(err_b)
		   rdy_flag = 1'b1;
		if (ecconnect == 1) begin
		    rdata[rd_ptr] = drd[bus_width-1:0];
//		    decrement datacnt for masters not supporting done_b
		    datacnt[7:0] = gen_new_datacnt(datacnt);
		    rd_ptr[7:0] = rd_ptr[7:0]+8'h01;
		end
		else if((ecconnect == 2) && (rdy_flag == 1'b1)) begin
		    rdnxt_b <= #1 1'b0;
		    rdata[rd_ptr] = drd[bus_width-1:0];
		    if(datacnt == 8'h00)
			rdnxt_b <= #1 1'b1;
		    else begin
			if(rdnxt_b == 1'b0) begin
			  datacnt[7:0] = gen_new_datacnt(datacnt);
			  rd_ptr[7:0] = rd_ptr[7:0]+8'h01;
			end
		    end
		end
	   end
	end
//	current access is complete whenever done_b is asserted OR
//	datacnt is 0 on masters not supporting done_b
	if ((done_b==1'b0) || (datacnt == 0))
	begin
		done = 1'b1;
//		make output signals don't care once the transfer completes
		wr <= #1 1'b1;
		if (bus_width == 32)
		   be_b[be_width-1:0] <= #1 4'hx;
		else if (bus_width == 64)
		   be_b[be_width-1:0] <= #1 8'hxx;
		size <= #1 16'bxxxxxxxxxxxxxxxx;
		rdnxt_b <= #1 1'b1;
		wren_b <= #1 1'b1;
		cacheline <= #1 1'bx;
		cs_b <= #1 16'bxxxxxxxxxxxxxxxx;
		blast_b <= #1 1'b1;
	end
//	remember any error assertion
	if (err_b == 1'b0) read_abort = 1'b1;
//	support error handling on masters which do not have a done signal
//	asserted to indicate an error
	if ((err_b == 1'b0) && (done_b !== 1'b0)) done = 1'b1;
	   if ((test_state==32'h00000100) && (ran4[1:0]== 2'b11)) wait_b <= #1 1'b0;
	   else wait_b <= #1 1'b1;
	ads_b <= #1 1'b1;
	if(ecconnect == 1) begin
	   if((size[15:0] == 16'h0001) || (datacnt == 8'h01))
		blast_b <= #1 1'b0;
	end
	else
	if((ecconnect == 2) && (rdy_flag == 1'b1)) begin
	   if((size[15:0] == 16'h0001) || (datacnt == 8'h01))
		blast_b <= #1 1'b0;
	   else if((ran4[26:20] == 7'b0000000) && (ecconnect2_early_terminate == 1'b1)) begin
		rdy_flag = 1'b0;
		blast_b <= #1 1'b0;
		@(posedge clk);
		rdnxt_b <= #1 1'b1;
		blast_b <= #1 1'b1;
		datacnt = 8'h00;
		early_terminate_cnt = early_terminate_cnt + 20'h00001;
	   end
	end
   end
   @(posedge clk);
   blast_b <= #1 1'b1;
   trfr_count = rd_ptr;
   #1;

// compare the number of expected rdy with the actual outcome
   if((expect_rdy_cnt == trfr_count) || (expect_rdy_cnt == -1))
	;
   else begin
	$write("Error: Master %b Read rdy number mismatch, expect %d, get %d.\n",
		master_id, expect_rdy_cnt, trfr_count);
	$stop;
   end
end
endtask

//
// ###########################################################################
//
// Task to compare read data
//
// This task is called after mtrread for the data comparison.
//
// Explanation of all inputs/outputs
// tmp_addr	 : Starting address of the access
// tmp_cs_b	 : User defined chip select for the access
// tmp_cacheline : Burst ordering of the access
//		   (0=Linear Increment, 1=Cacheline Wrap)
// rand_addr_bits: rand_addr_bits indicate the storage index of the data. It
//		   composes of the address bit designated for data storage.
//		   rand_addr_bits can also be computed by gen_storage_idx task.
// tmp_hsize	 : No. of bits being accessed in 32-bits AHB bus
//		   (00=8 bit, 01=16 bits, 10=32 bits, 11=undefined)
//		   tmp_hsize is ignored when bus_width=64
// trfr_count	 : Actual number of data being transferred
//		 Output from mtrread.
// tmp_hsize	 : No. of bits being accessed in 32-bits AHB bus
//		   (00=8 bit, 01=16 bits, 10=32 bits, 11=undefined)
//		   tmp_hsize is ignored when bus_width=64
// tmp_rbe_b	 : Read byte enable. For burst transfer,
//		 tmp_rbe_b needs to be all asserted.
// zerodata	 : It indicates whether the current storage location has been
//		 written with non-zero data before. It is used in runTest
//		 task to increment the read counter.
//		 Output from compare_rd_data.
//
// ###########################################################################
//
task compare_rd_data;
input[31:0]		tmp_addr;
input[num_cs-1:0]	tmp_cs_b;
input			tmp_cacheline;
input[31:0]		rand_addr_bits;
input[7:0]		tmp_size;
input[7:0]		trfr_count;
input[1:0]		tmp_hsize;
input[be_width-1:0]     tmp_rbe_b;
output			zerodata;
reg[bus_width-1:0]	data;
reg[store_length-1:0]	idx;
reg[7:0]		local_cache_size;
reg[bus_width-1:0]	rdt_tmp;
reg[store_length-1:0]	start_idx;
integer			j;
integer			k;
integer			width_count;
begin

	zerodata = 1'b1;
	width_count = 0;
	if(tmp_hsize == 2'b00) width_count[1:0] = tmp_addr[1:0];
	else if(tmp_hsize == 2'b01) width_count[0] = tmp_addr[1];
//	generate the starting index to retrieve data from
	start_idx[store_length-1:0] = gen_idx(rand_addr_bits);
	idx = start_idx;
	local_cache_size = gen_cache_size(tmp_size);
	j=0;
	for (k=0; k<trfr_count; k=k+1) begin
//	if index is already generated, increment it according to whether it is
//	cache wrap mode or linear increment mode
	   if ((tmp_cacheline==1'b0) || (local_cache_size>16))
		idx[store_length-1:0] = start_idx[store_length-1:0] + j;
	   else begin
		if (local_cache_size<=4) begin
		    if(tmp_hsize == 2'b00);
		    else if(tmp_hsize == 2'b01) begin
			idx[store_length-1:1] = start_idx[store_length-1:1];
			idx[0] = start_idx[0] + j;
		    end
		    else begin
			idx[store_length-1:2] = start_idx[store_length-1:2];
			idx[1:0] = start_idx[1:0] + j;
		    end
		end
		else if (local_cache_size<=8) begin
		    if(tmp_hsize == 2'b00) begin
			idx[store_length-1:1] = start_idx[store_length-1:1];
			idx[0] = start_idx[0] + j;
		    end
		    else if(tmp_hsize == 2'b01) begin
			idx[store_length-1:2] = start_idx[store_length-1:2];
			idx[1:0] = start_idx[1:0] + j;
		    end
		    else begin
			idx[store_length-1:3] = start_idx[store_length-1:3];
			idx[2:0] = start_idx[2:0] + j;
		    end
		end
		else if (local_cache_size<=16) begin
		    if(tmp_hsize == 2'b00) begin
			idx[store_length-1:2] = start_idx[store_length-1:2];
			idx[1:0] = start_idx[1:0] + j;
		    end
		    else if(tmp_hsize == 2'b01) begin
			idx[store_length-1:3] = start_idx[store_length-1:3];
			idx[2:0] = start_idx[2:0] + j;
		    end
		    else begin
			idx[store_length-1:4] = start_idx[store_length-1:4];
			idx[3:0] = start_idx[3:0] + j;
		    end
		end
	   end

	   data[bus_width-1:0] = rdata[k];
	   gen_store_retrieve(tmp_cs_b,1'b0,idx,rdt_tmp);
	   if((bus_width == 64) && (data[bus_width-1:0] != 64'h0000000000000000))
		zerodata = 1'b0;
	   else if((bus_width == 32) && (data[bus_width-1:0] != 32'h00000000))
		zerodata = 1'b0;
//	   8-bit access data selection
	   if(tmp_hsize == 2'b00)
	   begin
		if (big_endian==1'b0) begin
		if (width_count == 3) begin
		   if (data[31:24]==rdt_tmp[31:24]);
		   else begin
			$write("master %d read data byte 3 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 2) begin
		   if (data[23:16]==rdt_tmp[23:16]);
		   else begin
			$write("master %d read data byte 2 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 1) begin
		   if (data[15:8]==rdt_tmp[15:8]);
		   else begin
			$write("master %d read data byte 1 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 0) begin
		   if (data[7:0]==rdt_tmp[7:0]);
		   else begin
			$write("master %d read data byte 0 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		end
		else begin
		if (width_count == 0) begin
		   if (data[31:24]==rdt_tmp[31:24]);
		   else begin
			$write("master %d read data byte 0 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 1) begin
		   if (data[23:16]==rdt_tmp[23:16]);
		   else begin
			$write("master %d read data byte 1 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 2) begin
		   if (data[15:8]==rdt_tmp[15:8]);
		   else begin
			$write("master %d read data byte 2 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 3) begin
		   if (data[7:0]==rdt_tmp[7:0]);
		   else begin
			$write("master %d read data byte 3 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		end
	   end
//		   16-bit access data selection
	   else if(tmp_hsize == 2'b01) begin
		if (big_endian==1'b0) begin
		if (width_count == 1) begin
		   if (data[31:16]==rdt_tmp[31:16]);
		   else begin
			$write("master %d read data bytes 3&2 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 0) begin
		   if (data[15:0]==rdt_tmp[15:0]);
		   else begin
			$write("master %d read data bytes 1&0 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		end
		else begin
		if (width_count == 0) begin
		   if (data[31:16]==rdt_tmp[31:16]);
		   else begin
			$write("master %d read data bytes 0&1 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		else if (width_count == 1) begin
		   if (data[15:0]==rdt_tmp[15:0]);
		   else begin
			$write("master %d read data bytes 2&3 error --", master_id);
			$write("expecting %h, get %h, k=%d\n", rdt_tmp, data, k);
			$stop;
		   end
		end
		end
	   end
//	   32-bit access data selection
	   else begin
		if (trfr_count[7:0]==8'b00000001) begin
			if (tmp_rbe_b[0]==1'b0) begin
			   if (data[7:0]==rdt_tmp[7:0]) ;
			   else begin
				$write("master model %d single read byte 0 mismatch,", master_id);
				$write("expect %h, get %h\n", rdt_tmp, data);
				$stop;
			   end
			end
			if (tmp_rbe_b[1]==1'b0) begin
			   if (data[15:8]==rdt_tmp[15:8]) ;
			   else begin
				$write("master model %d single read byte 1 mismatch,", master_id);
				$write("expect %h, get %h\n", rdt_tmp, data);
				$stop;
			   end
			end
			if (tmp_rbe_b[2]==1'b0) begin
			   if (data[23:16]==rdt_tmp[23:16]) ;
			   else begin
				$write("master model %d single read byte 2 mismatch,", master_id);
				$write("expect %h, get %h\n", rdt_tmp, data);
				$stop;
			   end
			end
			if (tmp_rbe_b[3]==1'b0) begin
			   if (data[31:24]==rdt_tmp[31:24]) ;
			   else begin
				$write("master model %d single read byte 3 mismatch,", master_id);
				$write("expect %h, get %h\n", rdt_tmp, data);
				$stop;
			   end
			end
			if (bus_width == 64) begin
				if (tmp_rbe_b[be_width-4]==1'b0) begin
				   if (data[bus_width-25:bus_width-32]==rdt_tmp[bus_width-25:bus_width-32]) ;
				   else begin
					$write("master model %d single read byte 4 mismatch,", master_id);
					$write("expect %h, get %h\n", rdt_tmp, data);
					$stop;
				   end
				end
				if (tmp_rbe_b[be_width-3]==1'b0) begin
				   if (data[bus_width-17:bus_width-24]==rdt_tmp[bus_width-17:bus_width-24]) ;
				   else begin
					$write("master model %d single read byte 5 mismatch,", master_id);
					$write("expect %h, get %h\n", rdt_tmp, data);
					$stop;
				   end
				end
				if (tmp_rbe_b[be_width-2]==1'b0) begin
				   if (data[bus_width-9:bus_width-16]==rdt_tmp[bus_width-9:bus_width-16]) ;
				   else begin
					$write("master model %d single read byte 6 mismatch,", master_id);
					$write("expect %h, get %h\n", rdt_tmp, data);
					$stop;
				   end
				end
				if (tmp_rbe_b[be_width-1]==1'b0) begin
				   if (data[bus_width-1:bus_width-8]==rdt_tmp[bus_width-1:bus_width-8]) ;
				   else begin
					$write("master model %d single read byte 7 mismatch,", master_id);
					$write("expect %h, get %h\n", rdt_tmp, data);
					$stop;
				   end
				end
			end
		   end
		else begin
			if (data[bus_width-1:0]==rdt_tmp[bus_width-1:0]) ;
			else begin
			   $write("master model %d burst read data %d mismatch,", master_id, k);
			   $write("expect %h, get %h\n", rdt_tmp, data);
			   $stop;
			end
		end
	   end
	    if(tmp_hsize == 2'b01) width_count = (width_count + 1) % 2;
	    else if(tmp_hsize == 2'b00) width_count = (width_count + 1) % 4;
	    if(width_count == 0) j=j+1;
	end
end
endtask

//
// ##########################################################################
//
// Task to do random initialization before read/write tasks
//
// ##########################################################################
//
task randInit;
input[31:0]	ran1;
input[15:0]	ran2;
inout[31:0]	rseed1;
inout[31:0]	rseed2;
output	     rw_sel;
output[31:0]	tmp_addr;
output	     tmp_cacheline;
output[num_cs-1:0] tmp_cs_b;
output[1:0]	tmp_hsize;
output[be_width-1:0] tmp_rbe_b;
output[7:0]	   tmp_size;
output[31:0]	rand_addr_bits;
output[31:0]	avail_size;
output[31:0]	expect_rdy_cnt;
output	     noStore;
reg[7:0]	   access_str;
reg[255:0]	 addr_str;
reg[7:0]	   addr1_0_str;
reg[31:0]	  base;
reg[7:0]	   cache_str;
reg		config_acc_flag;
reg[bus_width-1:0] config_addr_value;
reg[15:0]	  hsize_str;
reg[15:0]	  rbe_b_str;
reg[31:0]	  size_str;
reg[7:0]	   store_str;
reg[15:0]	  tmp_reg;
reg[15:0]	  wbe_b_str;
integer	    num_rand;
integer	    addr_rand;
begin
     rw_sel = ran1[0];
     get_random(rseed1, rseed2, addr_rand);

//   generate cs_b
     tmp_cs_b = gen_cs_b(ran1[6:3]);

//   generate strings and flags for various signals
     gen_signal_string(tmp_cs_b, rw_sel, addr_rand, addr_str, addr1_0_str,
			cache_str, config_acc_flag, hsize_str, rbe_b_str,
			size_str, wbe_b_str, access_str, store_str,
			config_addr_value, rseed1, rseed2);
     tmp_reg = 16'hffff;
     tmp_reg[num_cs-1:0] = tmp_cs_b[num_cs-1:0];
     case(tmp_reg)
	  16'hfffe : base = base0;
	  16'hfffd : base = base1;
	  16'hfffb : base = base2;
	  16'hfff7 : base = base3;
	  16'hffef : base = base4;
	  16'hffdf : base = base5;
	  16'hffbf : base = base6;
	  16'hff7f : base = base7;
	  16'hfeff : base = base8;
	  16'hfdff : base = base9;
	  16'hfbff : base = base10;
	  16'hf7ff : base = base11;
	  16'hefff : base = base12;
	  16'hdfff : base = base13;
	  16'hbfff : base = base14;
	  16'h7fff : base = base15;
     endcase

//   generate address
     gen_addr(addr_str, tmp_cs_b, base, addr_rand, tmp_addr, rand_addr_bits, num_rand);

//   generate hsize -- access width
     tmp_hsize = gen_hsize(hsize_str, ran1[31:30]);

//   generate cacheline wrap mode/linear increment mode
     tmp_cacheline = gen_cache(cache_str, ran1[11]);

     if (addr1_0_str=="b") begin
//   generate transfer size
	gen_size(size_str, store_str, tmp_addr, num_rand, rand_addr_bits, ran1[29:22],
		 tmp_cacheline, tmp_hsize, tmp_size, avail_size);

//   generate byte enable for read operation
	tmp_rbe_b = gen_rbe_b(rbe_b_str, tmp_size, ran1[21:14]);

//   generate byte enables for write operation
	gen_wbe_b(wbe_b_str, rseed1, rseed2, tmp_size);

//   generate address bits 1 and 0
	gen_addr1_0(addr1_0_str, tmp_rbe_b, tmp_hsize, rw_sel, ran1[13:12], tmp_addr, big_endian);
     end
     else begin
//   generate address bits 1 and 0
	gen_addr1_0(addr1_0_str, tmp_rbe_b, tmp_hsize, rw_sel, ran1[13:12], tmp_addr, big_endian);

//   generate transfer size
	gen_size(size_str, store_str, tmp_addr, num_rand, rand_addr_bits, ran1[29:22],
		 tmp_cacheline, tmp_hsize, tmp_size, avail_size);

//   generate byte enable for read operation
	tmp_rbe_b = gen_rbe_b(rbe_b_str, tmp_size, ran1[21:14]);

//   generate byte enables for write operation
	gen_wbe_b(wbe_b_str, rseed1, rseed2, tmp_size);
     end

//   generate write data
     gen_wdata(config_acc_flag, config_addr_value, rseed1, rseed2, tmp_size);

//   compute the number of expected rdy
     expect_rdy_cnt = gen_expect_rdy_cnt(access_str, tmp_addr, tmp_cacheline,
					 tmp_hsize, tmp_size, avail_size);

//   generate noStore flag
     noStore = gen_noStore(store_str, tmp_addr, tmp_cacheline, tmp_hsize, tmp_size);

//   Update access counters
     if (tmp_cs_b[0]==1'b0) access_cnt0[19:0] = access_cnt0[19:0] + 20'h00001;
     else if (tmp_cs_b[1]==1'b0) access_cnt1[19:0] = access_cnt1[19:0] + 20'h00001;
     else if (tmp_cs_b[2]==1'b0) access_cnt2[19:0] = access_cnt2[19:0] + 20'h00001;
     else if (tmp_cs_b[3]==1'b0) access_cnt3[19:0] = access_cnt3[19:0] + 20'h00001;
     else if (tmp_cs_b[4]==1'b0) access_cnt4[19:0] = access_cnt4[19:0] + 20'h00001;
     else if (tmp_cs_b[5]==1'b0) access_cnt5[19:0] = access_cnt5[19:0] + 20'h00001;
     else if (tmp_cs_b[6]==1'b0) access_cnt6[19:0] = access_cnt6[19:0] + 20'h00001;
     else if (tmp_cs_b[7]==1'b0) access_cnt7[19:0] = access_cnt7[19:0] + 20'h00001;
     else if (tmp_cs_b[8]==1'b0) access_cnt8[19:0] = access_cnt8[19:0] + 20'h00001;
     else if (tmp_cs_b[9]==1'b0) access_cnt9[19:0] = access_cnt9[19:0] + 20'h00001;
     else if (tmp_cs_b[10]==1'b0) access_cnt10[19:0] = access_cnt10[19:0] + 20'h00001;
     else if (tmp_cs_b[11]==1'b0) access_cnt11[19:0] = access_cnt11[19:0] + 20'h00001;
     else if (tmp_cs_b[12]==1'b0) access_cnt12[19:0] = access_cnt12[19:0] + 20'h00001;
     else if (tmp_cs_b[13]==1'b0) access_cnt13[19:0] = access_cnt13[19:0] + 20'h00001;
     else if (tmp_cs_b[14]==1'b0) access_cnt14[19:0] = access_cnt14[19:0] + 20'h00001;
     else if (tmp_cs_b[15]==1'b0) access_cnt15[19:0] = access_cnt15[19:0] + 20'h00001;

end
endtask
endmodule
