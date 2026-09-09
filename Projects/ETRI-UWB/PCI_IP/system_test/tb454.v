`ifdef print_all
//
// translate: Address translation option. If defined a2p and p2a input are
//		created to provide address translation.
//
`endif
//
// ##########################################################################
//
// Copyright (c) by Eureka Technology Inc.
//
// Confidential and Proprietary
//
// All Rights Reserved.
//
// The use, modification, or duplication of this product is protected
// according to FAR 12.212 and by Eureka's licensing agreement.
// This design contains confidential and proprietary information which
// are the properties of Eureka Technology Inc.
// Unauthorized use, disclosure, duplication, or reproduction are prohibited.
//
// tb454: System test for top454
// Rev 2.2
//
// Filename: tb454.v
//
// ###########################################################################
//
// Brief Description
//
// This test bench instantiates two AHB master models, two AHB slave models,
// two PCI master models, one PCI target model.
//
// The PCI devices are initialized by AHB master ahbmdevice1.
// Big endian mode can be tested by assigning 1 to big_endian.
// The parameter cache_size should be the same for the whole system and should
// be equal to the cacheline size register in the PCI configuration register.
//
// ##########################################################################
//
`timescale 1ns / 100ps

`define clkin @(posedge clk) #1

module tb454;

reg		clk;
reg		reset_b;
integer		inttime;
reg		pciclk;
wire[31:0]	s_haddr;
wire[2:0]	s_hburst;
wire[31:0] 	s_hrdata;
wire		s_hready;
wire[1:0]	s_hresp;
wire[2:0]	s_hsize;
wire[1:0]	s_htrans;
wire[31:0]	s_hwdata;
wire		s_hwrite;
wire[3:0]	s_hprot;

wire[31:0] 	s0_hrdata;
wire		s0_hreadyout;
wire[1:0]	s0_hresp;
wire[3:0]	s0_hsel;
wire[31:0] 	s1_hrdata;
wire		s1_hreadyout;
wire[1:0]	s1_hresp;
wire		s1_hsel;
wire[31:0] 	s2_hrdata;
wire		s2_hreadyout;
wire[1:0]	s2_hresp;
wire		s2_hsel;
wire[31:0] 	s3_hrdata;
wire		s3_hreadyout;
wire[1:0]	s3_hresp;

wire[31:0]	m0_haddr;
wire[2:0]	m0_hburst;
wire		m0_hbusreq;
wire[31:0] 	m0_hrdata;
wire[2:0]	m0_hsize;
wire[1:0]	m0_htrans;
wire[31:0]	m0_hwdata;
wire		m0_hwrite;
wire		m0_hlock;
wire[3:0]	m0_hprot;
wire[31:0]	m1_haddr;
wire[2:0]	m1_hburst;
wire		m1_hbusreq;
wire[2:0]	m1_hsize;
wire[1:0]	m1_htrans;
wire[31:0]	m1_hwdata;
wire		m1_hwrite;
wire		m1_hlock;
wire[3:0]	m1_hprot;
wire[31:0]	m2_haddr;
wire[2:0]	m2_hburst;
wire		m2_hbusreq;
wire[2:0]	m2_hsize;
wire[1:0]	m2_htrans;
wire[31:0]	m2_hwdata;
wire		m2_hwrite;
wire		m2_hlock;
wire[3:0]	m2_hprot;
wire[31:0]	m3_haddr;
wire[2:0]	m3_hburst;
wire		m3_hbusreq;
wire[2:0]	m3_hsize;
wire[1:0]	m3_htrans;
wire[31:0]	m3_hwdata;
wire		m3_hwrite;
wire		m3_hlock;
wire[3:0]	m3_hprot;

wire[3:0]	hbusreq;
wire[3:0]	hgrant;
wire[3:0]	hready_from_slave;

wire		sel_slave0;
wire		sel_slave1;
wire		sel_slave2;
wire		sel_slave3;
wire		sel_slave0_nxt;
wire		sel_slave1_nxt;
wire		sel_slave2_nxt;
wire		sel_slave3_nxt;
wire[31:8]	a2p_ia;
wire[31:8]	a2p_im;
wire[31:8]	a2p_ma;
wire[31:8]	a2p_mm;
wire[31:8]	p2a_0a;
wire[31:8]	p2a_0m;
wire[31:8]	p2a_1a;
wire[31:8]	p2a_1m;

// PCI interface
tri1[31:0]		ad;
tri1[3:0]		cbe_b;
tri1			devsel_b;
tri1			frame_b;
wire			inta_b;
tri1			irdy_b;
tri0			par;
tri1			perr_b;
wire[3:0]		req_b;
wire			serr_b;
tri1			stop_b;
tri1			trdy_b;
reg			hs_fast;
reg			big_endian;
reg[1:0]		prefetch_limit;
reg			printvec;
integer			test_state;
wire[7:0]		mtrdone;
integer			logfile;
integer			statfile;
integer			display_time;
integer			i;

// PCI arbiter
wire[8:0]		arb_gnt_b;
wire[8:0]		arb_req_b;

assign arb_req_b[0] = req_b[0];
assign arb_req_b[1] = 1'b1;
assign arb_req_b[2] = req_b[2];
assign arb_req_b[3] = req_b[3];
assign arb_req_b[8:4] = 5'b11111;

// system clock is 8ns cycle time
initial begin
    clk=1;
    inttime=0;
    forever begin
	# 4  clk = ~clk;
	if (clk==1) inttime = inttime+1;
    end
end

// pciclk is 15ns cycle time
initial begin
    pciclk=1;
    forever begin
	#8 pciclk = 0;
	#7 pciclk = 1;
    end
end


// here
initial begin
// Reset the system
	reset_b = 1'b0;
	hs_fast = 1'b1;
	prefetch_limit = 2'b10;
	big_endian = 1'b1;
	test_state = 0;
	repeat(30) @(posedge clk);
	reset_b = 1'b1;
//
// wait for master 0 finish configuration then start fixed test, followed by random test
	while (mtrdone[1] != 1'b1) @(posedge clk);

	repeat (200) @(posedge clk);
	test_state = 32'h00000001;
	fork
	   while (mtrdone[0] != 1'b1) @(posedge clk);
	   while (mtrdone[3] != 1'b1) @(posedge clk);
	join

	repeat (200) @(posedge clk);
	test_state = 32'h00000002;
	fork
	   while (mtrdone[0] != 1'b1) @(posedge clk);
	   while (mtrdone[3] != 1'b1) @(posedge clk);
	join

	repeat (200) @(posedge clk);
	test_state = 32'h00000003;
	fork
	   while (mtrdone[0] != 1'b1) @(posedge clk);
	   while (mtrdone[3] != 1'b1) @(posedge clk);
	join

	repeat (200) @(posedge clk);
	test_state = 32'h00000004;
	fork
	   while (mtrdone[0] != 1'b1) @(posedge clk);
	   while (mtrdone[3] != 1'b1) @(posedge clk);
	join

	repeat (200) @(posedge clk);
	test_state = 32'h0000000a;
	fork
	   while (mtrdone[1] != 1'b1) @(posedge clk);
	join

	repeat (100) @(posedge clk);
	test_state = 32'h0000000b;
	fork
	   while (mtrdone[0] != 1'b1) @(posedge clk);
	join

	repeat (100) @(posedge clk);
	test_state = 32'h00000100;

end

//
// ##########################################################################
//
// Decoder
//
// Decode s_haddr and generate sX_hsel[4:0] for each slave.
//
// ##########################################################################
//
// s0_hsel signal is for top454
//
assign s0_hsel[0] = ((s_haddr[31:29]==3'b000) && (s_haddr[19:18]==2'b00)) ? 1'b1 : 1'b0;
assign s0_hsel[1] = ((s_haddr[31:29]==3'b000) && (s_haddr[19:18]==2'b01)) ? 1'b1 : 1'b0;
assign s0_hsel[2] = ((s_haddr[31:29]==3'b000) && (s_haddr[19:18]==2'b10)) ? 1'b1 : 1'b0;
assign s0_hsel[3] = ((s_haddr[31:29]==3'b000) && (s_haddr[19:18]==2'b11)) ? 1'b1 : 1'b0;

assign s1_hsel = (s_haddr[31:29]==3'b101) && (s_haddr[15]==1'b0) ? 1'b1 : 1'b0;
assign s2_hsel = (s_haddr[31:29]==3'b101) && (s_haddr[15]==1'b1) ? 1'b1 : 1'b0;

//
// Generate select signals for the hresp and hrdata
//
assign sel_slave0_nxt = (s_haddr[31:29]==3'b000) ? 1'b1 : 1'b0;
assign sel_slave1_nxt = (s_haddr[31:29]==3'b101) && (s_haddr[15]==1'b0) ? 1'b1 : 1'b0;
assign sel_slave2_nxt = (s_haddr[31:29]==3'b101) && (s_haddr[15]==1'b1) ? 1'b1 : 1'b0;
assign sel_slave3_nxt = (s_haddr[31:29]==3'b011) ? 1'b1 : 1'b0;

//
// ##########################################################################
//
// Multiplexors
//
// Mux the hresp signals and read data.
//
// ##########################################################################
//
dffe Usel_slave0 (sel_slave0, sel_slave0_nxt, clk, reset_b, 1'b1, s_hready);
dffe Usel_slave1 (sel_slave1, sel_slave1_nxt, clk, reset_b, 1'b1, s_hready);
dffe Usel_slave2 (sel_slave2, sel_slave2_nxt, clk, reset_b, 1'b1, s_hready);
dffe Usel_slave3 (sel_slave3, sel_slave3_nxt, clk, reset_b, 1'b1, s_hready);

// Mux slave signals based on the signals from decoder
assign s_hrdata = (sel_slave0) ? s0_hrdata :
		(sel_slave1) ? s1_hrdata :
		(sel_slave2) ? s2_hrdata :
		s3_hrdata;
assign s_hresp = (sel_slave0) ? s0_hresp :
		(sel_slave1) ? s1_hresp :
		(sel_slave2) ? s2_hresp :
		s3_hresp;

//
// ##########################################################################
//
// Model instantiation
//
// ##########################################################################
//
// Arbiter
ahb_arb ahb_arb(
.hclk			(clk),
.hreset_b		(reset_b),
.hbusreq		(hbusreq),
.hgrant			(hgrant),
.hready_from_slave	(hready_from_slave),
.hready			(s_hready),

.haddr			(s_haddr),
.hburst			(s_hburst),
.hprot			(s_hprot),
.hsize			(s_hsize),
.htrans			(s_htrans),
.hwrite			(s_hwrite),
.hwdata			(s_hwdata),

.h0addr			(m0_haddr),
.h0burst		(m0_hburst),
.h0prot			(m0_hprot),
.h0size			(m0_hsize),
.h0trans		(m0_htrans),
.h0write		(m0_hwrite),
.h0wdata		(m0_hwdata),
.h1addr			(m1_haddr),
.h1burst		(m1_hburst),
.h1prot			(m1_hprot),
.h1size			(m1_hsize),
.h1trans		(m1_htrans),
.h1write		(m1_hwrite),
.h1wdata		(m1_hwdata),
.h2addr			(m2_haddr),
.h2burst		(m2_hburst),
.h2prot			(m2_hprot),
.h2size			(m2_hsize),
.h2trans		(m2_htrans),
.h2write		(m2_hwrite),
.h2wdata		(m2_hwdata),
.h3addr			(m3_haddr),
.h3burst		(m3_hburst),
.h3prot			(m3_hprot),
.h3size			(m3_hsize),
.h3trans		(m3_htrans),
.h3write		(m3_hwrite),
.h3wdata		(m3_hwdata),
.test_state		(test_state)
);
assign hbusreq[0] = m0_hbusreq;
assign hbusreq[1] = m1_hbusreq;
assign hbusreq[2] = m2_hbusreq;
assign hbusreq[3] = 1'b0;

assign hready_from_slave[0] = s0_hreadyout;
assign hready_from_slave[1] = s1_hreadyout;
assign hready_from_slave[2] = s2_hreadyout;
assign hready_from_slave[3] = s3_hreadyout;
assign s3_hreadyout = 1'b1;


// AHB master model 1
ahbmdevice ahbmdevice1(
.big_endian	(big_endian),
.clk		(clk),
.haddr		(m1_haddr),
.hburst		(m1_hburst),
.hrdata		(s_hrdata),
.hready		(s_hready),
.hresp		(s_hresp),
.hsize		(m1_hsize),
.htrans		(m1_htrans),
.hwdata		(m1_hwdata),
.hwrite		(m1_hwrite),
.hgrant		(hgrant[1]),
.hbusreq	(m1_hbusreq),
.hlock		(m1_hlock),
.hprot		(m1_hprot),
.test_state	(test_state),
.mtrdone	(mtrdone[1]),
.reset_b	(reset_b)
);
defparam ahbmdevice1.std_mback.abort_start_addr = 32'h00000034;
defparam ahbmdevice1.std_mback.abort_end_addr = 32'h0000007f;
defparam ahbmdevice1.std_mback.abort_mask = 32'h000003ff;
defparam ahbmdevice1.std_mback.cache_disable = 1'b0;
defparam ahbmdevice1.std_mback.cache_size = 16;
defparam ahbmdevice1.std_mback.load_cache_flag = 1'b0;
defparam ahbmdevice1.std_mback.config_enable = 1'b1;
defparam ahbmdevice1.std_mback.master_id = 3'b001;
defparam ahbmdevice1.std_mback.store_length = 7;
defparam ahbmdevice1.std_mback.store_size = 128;
defparam ahbmdevice1.num_cs = 7;


// AHB master model 2
ahbmdevice ahbmdevice2(
.big_endian	(big_endian),
.clk		(clk),
.haddr		(m2_haddr),
.hburst		(m2_hburst),
.hrdata		(s_hrdata),
.hready		(s_hready),
.hresp		(s_hresp),
.hsize		(m2_hsize),
.htrans		(m2_htrans),
.hwdata		(m2_hwdata),
.hwrite		(m2_hwrite),
.hgrant		(hgrant[2]),
.hbusreq	(m2_hbusreq),
.hlock		(m2_hlock),
.hprot		(m2_hprot),
.test_state	(test_state),
.mtrdone	(mtrdone[2]),
.reset_b	(reset_b)
);
defparam ahbmdevice2.std_mback.abort_start_addr = 32'h00000034;
defparam ahbmdevice2.std_mback.abort_end_addr = 32'h0000007f;
defparam ahbmdevice2.std_mback.abort_mask = 32'h000003ff;
defparam ahbmdevice2.std_mback.cache_disable = 1'b0;
defparam ahbmdevice2.std_mback.cache_size = 16;
defparam ahbmdevice2.std_mback.load_cache_flag = 1'b0;
defparam ahbmdevice2.std_mback.config_enable = 1'b0;
defparam ahbmdevice2.std_mback.master_id = 3'b010;
defparam ahbmdevice2.std_mback.store_length = 7;
defparam ahbmdevice2.std_mback.store_size = 128;
defparam ahbmdevice2.num_cs = 7;


// AHB slave device 1
ahbslave ahbslave1(
.clk			(clk),
.big_endian		(big_endian),
.haddr			(s_haddr),
.hburst			(s_hburst),
.hrdata			(s1_hrdata),
.hreadyin		(s_hready),
.hreadyout		(s1_hreadyout),
.hresp			(s1_hresp),
.hsel			(s1_hsel),
.hsize			(s_hsize),
.htrans			(s_htrans),
.hwdata			(s_hwdata),
.hwrite			(s_hwrite),
.test_state		(test_state),
.reset_b		(reset_b)
);
defparam ahbslave1.rd_retry_disable = 1'b0;
defparam ahbslave1.wr_retry_disable = 1'b0;
defparam ahbslave1.max_wait = 16;
defparam ahbslave1.abort_start_addr = 32'h00000034;
defparam ahbslave1.abort_end_addr = 32'h0000007f;
defparam ahbslave1.abort_mask = 32'h000003ff;
defparam ahbslave1.bus_width = 32;
defparam ahbslave1.store_size = 2048;
defparam ahbslave1.store_length = 11;


// AHB slave device 2
ahbslave ahbslave2(
.clk			(clk),
.big_endian		(big_endian),
.haddr			(s_haddr),
.hburst			(s_hburst),
.hrdata			(s2_hrdata),
.hreadyin		(s_hready),
.hreadyout		(s2_hreadyout),
.hresp			(s2_hresp),
.hsel			(s2_hsel),
.hsize			(s_hsize),
.htrans			(s_htrans),
.hwdata			(s_hwdata),
.hwrite			(s_hwrite),
.test_state		(test_state),
.reset_b		(reset_b)
);
defparam ahbslave2.rd_retry_disable = 1'b0;
defparam ahbslave2.wr_retry_disable = 1'b0;
defparam ahbslave2.max_wait = 4;
defparam ahbslave2.abort_start_addr = 32'h00000034;
defparam ahbslave2.abort_end_addr = 32'h0000007f;
defparam ahbslave2.abort_mask = 32'h000003ff;
defparam ahbslave2.bus_width = 32;
defparam ahbslave2.store_size = 2048;
defparam ahbslave2.store_length = 11;

assign a2p_ia = 24'h000000;
assign a2p_im = 24'h000000;
assign a2p_ma = 24'h000000;
assign a2p_mm = 24'h000000;
assign p2a_0a = 24'h000000;
assign p2a_0m = 24'h000000;
assign p2a_1a = 24'h000000;
assign p2a_1m = 24'h000000;

top454 top454(
.ad		(ad),
.arb_gnt_b	(arb_gnt_b),
.arb_req_b	(arb_req_b),
.cbe_b		(cbe_b),
.devsel_b	(devsel_b),
.frame_b	(frame_b),
.gnt_b		(arb_gnt_b[0]),
.idsel		(ad[11]),
.inta_b		(inta_b),
.irdy_b		(irdy_b),
.par		(par),
.perr_b		(perr_b),
.req_b		(req_b[0]),
.serr_b		(serr_b),
.stop_b		(stop_b),
.trdy_b		(trdy_b),

.m_haddr	(m0_haddr),
.m_hburst	(m0_hburst),
.m_hrdata	(s_hrdata),
.m_hready	(s_hready),
.m_hresp	(s_hresp),
.m_hsize	(m0_hsize),
.m_htrans	(m0_htrans),
.m_hwdata	(m0_hwdata),
.m_hwrite	(m0_hwrite),
.m_hgrant	(hgrant[0]),
.m_hbusreq	(m0_hbusreq),
.m_hlock	(m0_hlock),

.haddr		(s_haddr),
.hburst		(s_hburst),
.hrdata		(s0_hrdata),
.hready_i	(s_hready),
.hready		(s0_hreadyout),
.hresp		(s0_hresp),
.hsel		(s0_hsel),
.hsize		(s_hsize),
.htrans		(s_htrans),
.hwdata		(s_hwdata),
.hwrite		(s_hwrite),

`ifdef translate
.a2p_ia		(a2p_ia),
.a2p_im		(a2p_im),
.a2p_ma		(a2p_ma),
.a2p_mm		(a2p_mm),
`endif
.big_endian	(big_endian),
.clk		(clk),
.hs_fast	(hs_fast),
`ifdef translate
.p2a_0a		(p2a_0a),
.p2a_0m		(p2a_0m),
.p2a_1a		(p2a_1a),
.p2a_1m		(p2a_1m),
`endif
.pciclk		(pciclk),
.prefetch_limit	(prefetch_limit),
.reset_b	(reset_b)
);


// PCI target device 1
pcitdevice pcitdevice1(
.ad		(ad),
.cbe_b		(cbe_b),
.clk		(pciclk),
.devsel_b	(devsel_b),
.frame_b	(frame_b),
.idsel		(ad[12]),
.inta_b		(inta_b),
.irdy_b		(irdy_b),
.par		(par),
.perr_b		(perr_b),
.reset_b	(reset_b),
.serr_b		(serr_b),
.stop_b		(stop_b),
.trdy_b		(trdy_b),
.test_state	(test_state)
);
defparam pcitdevice1.std_tback0.cache_size = 16;
defparam pcitdevice1.std_tback0.max_wait = 0;
defparam pcitdevice1.std_tback0.abort_start_addr = 32'h00000034;
defparam pcitdevice1.std_tback0.abort_end_addr = 32'h0000007f;
defparam pcitdevice1.std_tback0.abort_mask = 32'h000003ff;
defparam pcitdevice1.std_tback0.store_size = 2048;
defparam pcitdevice1.std_tback0.store_length = 11;

defparam pcitdevice1.std_tback1.cache_size = 16;
defparam pcitdevice1.std_tback1.max_wait = 4;
defparam pcitdevice1.std_tback1.abort_start_addr = 32'h00000034;
defparam pcitdevice1.std_tback1.abort_end_addr = 32'h0000007f;
defparam pcitdevice1.std_tback1.abort_mask = 32'h000003ff;
defparam pcitdevice1.std_tback1.store_size = 2048;
defparam pcitdevice1.std_tback1.store_length = 11;


// PCI master device 0
pcimdevice pcimdevice0(
.ad		(ad),
.cbe_b		(cbe_b),
.clk		(pciclk),
.devsel_b	(devsel_b),
.frame_b	(frame_b),
.gnt_b		(arb_gnt_b[2]),
.idsel		(ad[13]),
.inta_b		(inta_b),
.irdy_b		(irdy_b),
.par		(par),
.perr_b		(perr_b),
.req_b		(req_b[2]),
.reset_b	(reset_b),
.stop_b		(stop_b),
.trdy_b		(trdy_b),
.test_state	(test_state),
.mtrdone	(mtrdone[0])
);
defparam pcimdevice0.std_mback.abort_start_addr = 32'h00000034;
defparam pcimdevice0.std_mback.abort_end_addr = 32'h0000007f;
defparam pcimdevice0.std_mback.abort_mask = 32'h000003ff;
defparam pcimdevice0.std_mback.done_flag = 1'b0;
defparam pcimdevice0.std_mback.cache_disable = 1'b0;
defparam pcimdevice0.std_mback.cache_size = 16;
defparam pcimdevice0.std_mback.load_cache_flag = 1'b1;
defparam pcimdevice0.std_mback.config_enable = 1'b0;
defparam pcimdevice0.std_mback.master_id = 3'b000;
defparam pcimdevice0.std_mback.store_length = 7;
defparam pcimdevice0.std_mback.store_size = 128;
defparam pcimdevice0.num_cs = 7;


// PCI master device 1
pcimdevice pcimdevice1(
.ad		(ad),
.cbe_b		(cbe_b),
.clk		(pciclk),
.devsel_b	(devsel_b),
.frame_b	(frame_b),
.gnt_b		(arb_gnt_b[3]),
.idsel		(ad[14]),
.inta_b		(inta_b),
.irdy_b		(irdy_b),
.par		(par),
.perr_b		(perr_b),
.req_b		(req_b[3]),
.reset_b	(reset_b),
.stop_b		(stop_b),
.trdy_b		(trdy_b),
.test_state	(test_state),
.mtrdone	(mtrdone[3])
);
defparam pcimdevice1.std_mback.abort_start_addr = 32'h00000034;
defparam pcimdevice1.std_mback.abort_end_addr = 32'h0000007f;
defparam pcimdevice1.std_mback.abort_mask = 32'h000003ff;
defparam pcimdevice1.std_mback.done_flag = 1'b0;
defparam pcimdevice1.std_mback.cache_disable = 1'b0;
defparam pcimdevice1.std_mback.cache_size = 16;
defparam pcimdevice1.std_mback.load_cache_flag = 1'b1;
defparam pcimdevice1.std_mback.config_enable = 1'b0;
defparam pcimdevice1.std_mback.master_id = 3'b011;
defparam pcimdevice1.std_mback.store_length = 7;
defparam pcimdevice1.std_mback.store_size = 128;
defparam pcimdevice1.num_cs = 7;


// module to check PCI IO address and byte enables
monitor_pci monitor_pci(
.ad		(ad[1:0]),
.cbe_b		(cbe_b),
.frame_b	(frame_b),
.irdy_b		(irdy_b),
.devsel_b	(devsel_b),
.stop_b		(stop_b),
.trdy_b		(trdy_b),
.clk		(pciclk),
.reset_b	(reset_b),
.inttime	(inttime)
);



boundchk boundchk (
.addr		(m0_haddr),
.hburst		(m0_hburst),
.hgrant		(hgrant[0]),
.hready		(s_hready),
.hresp		(s_hresp),
.trans		(m0_htrans),
.clk		(clk),
.incr   	(m0_hburst[0])
);



initial begin
        $write("System level testbench for ep454\n");
        $write("\tby Eureka Technology Inc.\n\n");
        $write("Description of counters in AHB masters:\n");
        $write("   write_cnt: total number of write accesses this master has issued\n");
        $write("   read_cnt: total number of read hit accesses this master has issued\n");
        $write("   PCI target io access: number of accesses to IO space of the PCI target model through EP454\n");
        $write("   PCI target mem access: number of accesses to memory space of the PCI target model through EP454\n");
        $write("   Config ADDR access: number of accesses to configuration address register of EP454\n");
        $write("   Config DATA access: number of accesses to configuration data register of EP454\n");
        $write("   AHB slave model 1 access: number of accesses to AHB slave model 1 on the local AHB bus\n");
        $write("   AHB slave model 2 access: number of accesses to AHB slave model 2 on the local AHB bus\n");

        $write("Description of counters in PCI master:\n");
        $write("   pci_write_cnt: total number of write accesses\n");
        $write("   pci_read_cnt: total number of read hit accesses\n");
        $write("   PCI target model cfg cnt: number of accesses to the configuration registers of the PCI target model\n");
        $write("   PCI target model io cnt: number of accesses to the IO space of the PCI target model\n");
        $write("   PCI target model mem cnt: number of accesses to the memory space of the PCI target model\n");
        $write("   AHB slave model 1 access: number of accesses to AHB slave model 1 through EP454\n");
        $write("   AHB slave model 2 access: number of accesses to AHB slave model 2 through EP454\n");

        $write("\nSimulation begins...\n\n");

    @ (posedge clk);
    @ (posedge clk);

    if (big_endian==1'b0) begin
	$write("The AHB bus is in little endian mode in this simulation\n\n");
    end
    else begin
	$write("The AHB bus is in big endian mode in this simulation\n\n");
    end

    while (1) begin

      @(posedge clk) begin
// Print counters

        display_time = inttime;
        if ((display_time % 20000) == 0) begin

	   #1;

	   $write("\n###############################################################\n");
	   $write("AHB Master 1 counter values after %d clock cycles:\n", display_time);
	   $write("   write_cnt=%d,           read_cnt=%d\n",ahbmdevice1.std_mback.wr_cnt, ahbmdevice1.std_mback.rd_cnt);
	   $write(" PCI target io access (thru ep454) cnt = %d   ", ahbmdevice1.std_mback.access_cnt1);
	   $write(" PCI target mem access (thru ep454) cnt = %d   ", ahbmdevice1.std_mback.access_cnt2);
	   $write("\n Config ADDR access (thru ep454) cnt = %d", ahbmdevice1.std_mback.access_cnt4);
	   $write("\n Config DATA access (thru ep454) cnt = %d", ahbmdevice1.std_mback.access_cnt5);
	   $write("\n AHB slave model 1 access cnt = %d", ahbmdevice1.std_mback.access_cnt3);
	   $write("\n AHB slave model 2 access cnt = %d", ahbmdevice1.std_mback.access_cnt6);

	   $write("\n");
	   $write("\nAHB Master 2 counter values after %d clock cycles:\n", display_time);
	   $write("   write_cnt=%d,           read_cnt=%d\n",ahbmdevice2.std_mback.wr_cnt, ahbmdevice2.std_mback.rd_cnt);
	   $write(" PCI target io access (thru ep454) cnt = %d   ", ahbmdevice2.std_mback.access_cnt1);
	   $write(" PCI target mem access (thru ep454) cnt = %d   ", ahbmdevice2.std_mback.access_cnt2);
	   $write("\n AHB slave model 1 access cnt = %d", ahbmdevice2.std_mback.access_cnt3);
	   $write("\n AHB slave model 2 access cnt = %d", ahbmdevice2.std_mback.access_cnt6);

	   $write("\n");
	   $write("\nPCI master 0 counter values after %d clock cycles:\n", display_time);
	   $write("   pci_write_cnt=%d,           pci_read_cnt=%d\n",pcimdevice0.std_mback.wr_cnt, pcimdevice0.std_mback.rd_cnt);
	   $write(" PCI target model cfg cnt = %d   ", pcimdevice0.std_mback.access_cnt0);
	   $write(" PCI target model io cnt = %d   ", pcimdevice0.std_mback.access_cnt1);
	   $write(" PCI target model mem cnt = %d   ", pcimdevice0.std_mback.access_cnt2);
	   $write("\n AHB slave model 1 access (thru ep454) = %d", pcimdevice0.std_mback.access_cnt3);
	   $write("\n AHB slave model 2 access (thru ep454) = %d", pcimdevice0.std_mback.access_cnt6);

	   $write("\n");
	   $write("\nPCI master 1 counter values after %d clock cycles:\n", display_time);
	   $write("   pci_write_cnt=%d,           pci_read_cnt=%d\n",pcimdevice1.std_mback.wr_cnt, pcimdevice1.std_mback.rd_cnt);
	   $write(" PCI target model cfg cnt = %d   ", pcimdevice1.std_mback.access_cnt0);
	   $write(" PCI target model io cnt = %d   ", pcimdevice1.std_mback.access_cnt1);
	   $write(" PCI target model mem cnt = %d   ", pcimdevice1.std_mback.access_cnt2);
	   $write("\n AHB slave model 1 access (thru ep454) = %d", pcimdevice1.std_mback.access_cnt3);
	   $write("\n AHB slave model 2 access (thru ep454) = %d", pcimdevice1.std_mback.access_cnt6);

	   $write("\n");

	end
     end

   end

end


initial begin
   printvec=0;
//   statfile = $fopen("statsfile.txt");
   if (printvec==1) begin
	logfile = $fopen("top454.in");
	forever begin
	   `clkin;
	   #2;
	   $fwrite(logfile,"%b\n",
	   {
	top454.ad,
	top454.cbe_b,
	top454.devsel_b,
	top454.frame_b,
	top454.gnt_b,
	top454.idsel,
	top454.irdy_b,
	top454.par,
	top454.perr_b,
	top454.req_b,
	top454.serr_b,
	top454.stop_b,
	top454.trdy_b,
	top454.oe_ad,
	top454.oe_cbe,
	top454.oe_devsel,
	top454.oe_frame,
	top454.oe_irdy,
	top454.oe_par,
	top454.oe_perr,
	top454.oe_req,
	top454.oe_stop,
	top454.oe_trdy,

// AHB Bus Master Interface
	top454.m_haddr,
	top454.m_hburst,
	top454.m_hbusreq,
	top454.m_hgrant,
	top454.m_hlock,
	top454.m_hrdata,
	top454.m_hready,
	top454.m_hresp,
	top454.m_hsize,
	top454.m_htrans,
	top454.m_hwdata,
	top454.m_hwrite,

// AHB Bus Slave Interface
	top454.haddr,
	top454.hburst,
	top454.hrdata,
	top454.hready_i,
	top454.hready,
	top454.hresp,
	top454.hsel,
	top454.hsize,
	top454.htrans,
	top454.hwdata,
	top454.hwrite,

// System signals
	top454.pciclk,
	top454.reset_b,
	top454.clk
	   });
	end
   end	
end

endmodule
