// ###########################################################################
//
// Copyright (c) by Eureka Technology Inc.
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
//
// ahb master device
// Rev 1.0
//
// ###########################################################################
//
// Using this file
//
// (1) Specify values to the following parameters
//     - ahbmtrback.master_id : specify an unique 2 bit value as the ID of
//       this device.
//     - ahbmtrback.cfg_init : specify 1 if this device will be the one to
//       do the configuration.  *ONLY* one device should have this parameter
//       set to 1.
//       (Note: incr and wrap cannot be 1'b1 at the same time)
// (2) Modify file ahbmtrback
//
// ###########################################################################
//
// Recommendation
//
// To completely simulate the traffic on the AHB bus, it is recommended to
// instantiate 4 "ahbmdevice".  Two of them have incr=0 and wrap=0.  One has
// incr=1 and wrap=0 and the last one has incr=0 and wrap=1.
//
// ###########################################################################
//
`timescale 1ns / 100ps

module ahbmdevice(
big_endian,
clk,
haddr,
hburst,
hrdata,
hready,
hresp,
hsize,
htrans,
hwdata,
hwrite,
hgrant,
hbusreq,
hlock,
hprot,
test_state,
mtrdone,
reset_b
);

parameter num_cs 	   = 6;

input		big_endian;
input		clk;
output[31:0]	haddr;
output[2:0]	hburst;
input[31:0]	hrdata;
input		hready;
input[1:0]	hresp;
output[2:0]	hsize;
output[1:0]	htrans;
output[31:0]	hwdata;
output		hwrite;
input		hgrant;
output		hbusreq;
output		hlock;
output[3:0]	hprot;
input[31:0]	test_state;
output		mtrdone;
input		reset_b;

wire[31:0]	t_adr;
wire		t_ads_b;
wire[3:0]	t_be_b;
wire[31:0]	t_dwr;
wire		t_err_b;
wire		t_rdy_b;
wire[4:0]	t_trans;
wire[1:0]	t_hsize;
wire		t_wr;
wire		t_wrap;
wire[31:0]	t_drd;
wire		t_busy;

wire		rdnxt_b;
wire		wren_b;
wire		wait_b;
wire		done_b;
wire[num_cs-1:0]cs_b;
wire[15:0] 	size;
wire		blast_b;
wire		retry_b;
wire[1:0]	dummy_cmd;
wire		dummy_mio;

ab_mas_m ab_mas_m(
.big_endian		(big_endian),
.clk			(clk),
.m_haddr		(haddr),
.m_hburst		(hburst),
.m_hrdata		(hrdata),
.m_hready		(hready),
.m_hresp		(hresp),
.m_hsize		(hsize),
.m_htrans		(htrans),
.m_hwdata		(hwdata),
.m_hwrite		(hwrite),
.m_hgrant		(hgrant),
.m_hbusreq		(hbusreq),
.m_hlock		(hlock),
.m_hprot		(hprot),
//
.t_adr			(t_adr),
.t_ads_b		(t_ads_b),
.t_be_b			(t_be_b),
.t_busy			(t_busy),
.t_dwr			(t_dwr),
.t_err_b		(t_err_b),
.t_rdy_b		(t_rdy_b),
.t_hsize		(t_hsize),
.t_trans		(t_trans),
.t_wr			(t_wr),
.t_drd			(t_drd),
.t_wrap			(t_wrap),
//
.reset_b		(reset_b)
);

std_mback std_mback(
.clk		(clk),
.big_endian	(big_endian),
.ads_b		(t_ads_b),
.addr		(t_adr),
.be_b		(t_be_b),
.blast_b	(blast_b),
.cacheline	(t_wrap),
.cs_b		(cs_b),
.dwr		(t_dwr),
.done_b		(done_b),
.drd		(t_drd),
.err_b		(t_err_b),
.h_cmd		(dummy_cmd),
.h_mio		(dummy_mio),
.hsize		(t_hsize),
.rdnxt_b	(rdnxt_b),
.rdy_b		(t_rdy_b),
.size		(size),
.wait_b		(wait_b),
.wr		(t_wr),
.wren_b		(wren_b),
.mtrdone	(mtrdone),
.test_state	(test_state),
.reset_b	(reset_b)
);
defparam std_mback.num_cs = num_cs;

assign t_busy = ~wait_b;
assign t_trans = size[5:0];

monitor_bus monitor_bus(
.clk		(clk),
.ads_b		(t_ads_b),
.abort_b	(t_err_b),
.blast_b	(blast_b),
.cs_b		(&(cs_b)),
.master_id	(std_mback.master_id[1:0]),
.rdy_b		(t_rdy_b),
.retry_b	(retry_b),
.wr		(t_wr),
.size		(size[7:0]),
.reset_b	(reset_b)
);

endmodule


