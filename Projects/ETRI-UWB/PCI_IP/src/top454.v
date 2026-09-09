//
// ########################################################################
//
// Copyright (C) by Eureka Technology Inc.
//
// Confidential and Proprietary
//
// All Rights Reserved
//
// The use, modification, or duplication of this product is protected
// according to FAR 12.212 and by Eureka's licenUART_RXg agreement.
// This design contains confidential and proprietary information which
// are the properties of Eureka Technology Inc.
// Unauthorized use, disclosure, duplication, or reproduction are prohibited.
//
// top454 top level design template for ep454g6.
//
// ########################################################################
//
// IMPORTANT NOTICE: This module is not the IP core. The IP core is ep454g6.
//		This file shows how the IP core can be instantiated within
//		a top level design as a sub-module.
//
// ########################################################################
//
// Signal Description
//
// PCI Interface
// 		ad			PCI address/data bus
//		arb_gnt_b		Bus grant from PCI bus arbiter
//		arb_req_b		Bus request to PCI bus arbiter
// 		cbe_b 			PCI command/byte enable bus 
// 		devsel_b 		DEVSEL PCI signal
// 		frame_b 		FRAME PCI signal
// 		gnt_b 			PCI bus grant
// 		idsel 			ID select for configuration 
//		inta_b			Interrupt A
// 		irdy_b 			IRDY PCI signal
// 		par 			parity PCI signal
// 		perr_b 			data parity PCI signal
// 		req_b 			PCI bus request
// 		serr_b 			system error
// 		stop_b 			STOP PCI signal
// 		trdy_b 			TRDY PCI signal
//
// AHB Bus Master Interface
//		m_haddr			AHB address
//		m_hburst		AHB burst size
//		m_hbusreq		AHB bus request
//		m_hgrant		AHB bus grant
//		m_hlock			AHB bus lock
//		m_hrdata		AHB read data
//		m_hready		AHB transfer ready
//		m_hresp			AHB bus response
//		m_hsize			AHB data size
//		m_htrans		AHB transfer type
//		m_hwdata		AHB write data
//		m_hwrite		AHB read/write indicator
//
// AHB Bus Slave Interface
//		haddr			AHB address
//		hburst			AHB burst size
//		hrdata			AHB read data
//		hready_i		AHB transfer ready (input)
//		hready			AHB transfer ready (output)
//		hresp			AHB bus response
//		hsel			AHB bus select
//		hsize			AHB data size
//		htrans			AHB transfer type
//		hwdata			AHB write data
//		hwrite			AHB read/write indicator
//
// System signals
//		big_endian		Big endian mode
//		clk			System bus clock
//		def_lat_cnt		default value of the latency counter
//		hs_fast			fast AHB-PCI posted write
//		pciclk			PCI bus clock
//		prefetch_limit		Target read prefetch limit
//					00=4 words
//					01=8 words
//					10=16 words
//		reset_b			System reset input
//
// ##########################################################################
//
`timescale 1ns / 100ps

module top454
(
// PCI interface
	ad,
	arb_gnt_b,
	arb_req_b,
	cbe_b,
	devsel_b,
	frame_b,
	gnt_b,
	idsel,
	inta_b,
	irdy_b,
	par,
	perr_b,
	req_b,
	serr_b,
	stop_b,
	trdy_b,

// AHB Bus Master Interface
	m_haddr,
	m_hburst,
	m_hbusreq,
	m_hgrant,
	m_hlock,
	m_hrdata,
	m_hready,
	m_hresp,
	m_hsize,
	m_htrans,
	m_hwdata,
	m_hwrite,

// AHB Bus Slave Interface
	haddr,
	hburst,
	hrdata,
	hready_i,
	hready,
	hresp,
	hsel,
	hsize,
	htrans,
	hwdata,
	hwrite,

// System signals
	big_endian,
	clk,
	hs_fast,
	pciclk,
	prefetch_limit,
	reset_b
);

//
// PCI interface
inout[31:0]	ad;
output[8:0]	arb_gnt_b;
input[8:0]	arb_req_b;
inout[3:0]	cbe_b;
inout		devsel_b;
inout		frame_b;
input		gnt_b;
input		idsel;
output		inta_b;
inout		irdy_b;
inout		par;
inout		perr_b;
output		req_b;
output		serr_b;
inout		stop_b;
inout		trdy_b;
//
// AHB Bus Master Interface
output[31:0]	m_haddr;
output[2:0]	m_hburst;
output		m_hbusreq;
input		m_hgrant;
output		m_hlock;
input[31:0]	m_hrdata;
input		m_hready;
input[1:0]	m_hresp;
output[2:0]	m_hsize;
output[1:0]	m_htrans;
output[31:0]	m_hwdata;
output		m_hwrite;
//
// AHB Bus Slave Interface
input[31:0]	haddr;
input[2:0]	hburst;
output[31:0]	hrdata;
input		hready_i;
output		hready;
output[1:0]	hresp;
input[3:0]	hsel;
input[2:0]	hsize;
input[1:0]	htrans;
input[31:0]	hwdata;
input		hwrite;
//
// System signals
input		big_endian;
input		clk;
input		hs_fast;
input		pciclk;
input[1:0]	prefetch_limit;
input		reset_b;

wire[31:0]	adout;
wire[3:0]	cbeout_b;
wire		devselout_b;
wire		frameout_b;
wire		intaout_b;
wire		irdyout_b;
wire		parout;
wire		perrout_b;
wire		reqout_b;
wire		serrout_b;
wire		stopout_b;
wire		trdyout_b;
wire		oe_ad;
wire		oe_cbe;
wire		oe_devsel;
wire		oe_frame;
wire		oe_irdy;
wire		oe_par;
wire		oe_perr;
wire		oe_req;
wire		oe_stop;
wire		oe_trdy;
wire[15:0]	device_id;
wire[15:0]	vendor_id;
wire[23:0]	class_code;
wire[7:0]	revision_id;
wire[7:0]	interrupt_pin;
wire[15:0]	subsystem_id;
wire[15:0]	subvendor_id;
wire		run_66mhz;
wire[34:16]	bar0_setup;
wire[34:16]	bar1_setup;
wire		sel_23;
wire[1:0]	m_hbar;
wire		status15;
wire		status14;
wire		status13;
wire		status12;
wire		status11;
wire		status8;
wire		status_rty;

//
// ##########################################################################
//
// Section 1.0
//
// Tri-state I/O buffers
//
// ##########################################################################
//
bufif1 (ad[31], adout[31], oe_ad);
bufif1 (ad[30], adout[30], oe_ad);
bufif1 (ad[29], adout[29], oe_ad);
bufif1 (ad[28], adout[28], oe_ad);
bufif1 (ad[27], adout[27], oe_ad);
bufif1 (ad[26], adout[26], oe_ad);
bufif1 (ad[25], adout[25], oe_ad);
bufif1 (ad[24], adout[24], oe_ad);
bufif1 (ad[23], adout[23], oe_ad);
bufif1 (ad[22], adout[22], oe_ad);
bufif1 (ad[21], adout[21], oe_ad);
bufif1 (ad[20], adout[20], oe_ad);
bufif1 (ad[19], adout[19], oe_ad);
bufif1 (ad[18], adout[18], oe_ad);
bufif1 (ad[17], adout[17], oe_ad);
bufif1 (ad[16], adout[16], oe_ad);
bufif1 (ad[15], adout[15], oe_ad);
bufif1 (ad[14], adout[14], oe_ad);
bufif1 (ad[13], adout[13], oe_ad);
bufif1 (ad[12], adout[12], oe_ad);
bufif1 (ad[11], adout[11], oe_ad);
bufif1 (ad[10], adout[10], oe_ad);
bufif1 (ad[9], adout[9], oe_ad);
bufif1 (ad[8], adout[8], oe_ad);
bufif1 (ad[7], adout[7], oe_ad);
bufif1 (ad[6], adout[6], oe_ad);
bufif1 (ad[5], adout[5], oe_ad);
bufif1 (ad[4], adout[4], oe_ad);
bufif1 (ad[3], adout[3], oe_ad);
bufif1 (ad[2], adout[2], oe_ad);
bufif1 (ad[1], adout[1], oe_ad);
bufif1 (ad[0], adout[0], oe_ad);
bufif1 (cbe_b[3], cbeout_b[3], oe_cbe);
bufif1 (cbe_b[2], cbeout_b[2], oe_cbe);
bufif1 (cbe_b[1], cbeout_b[1], oe_cbe);
bufif1 (cbe_b[0], cbeout_b[0], oe_cbe);
bufif1 (devsel_b, devselout_b, oe_devsel);
bufif1 (frame_b, frameout_b, oe_frame);
bufif1 (irdy_b, irdyout_b, oe_irdy);
bufif1 (par, parout, oe_par);
bufif1 (perr_b, perrout_b, oe_perr);
bufif1 (req_b, reqout_b, oe_req);
bufif1 (serr_b, serrout_b, ~serrout_b);
bufif1 (stop_b, stopout_b, oe_stop);
bufif1 (trdy_b, trdyout_b, oe_trdy);
bufif1 (inta_b, intaout_b, ~intaout_b);

//
// ##########################################################################
//
// Section 2.0
//
// Hardwired signals
//
// ##########################################################################
//
assign device_id = 16'h0000;
assign vendor_id = 16'h1901;
assign class_code = 24'hff0000;
assign revision_id = 8'h00;
assign interrupt_pin = 8'h01;
assign subsystem_id = 16'h0000;
assign subvendor_id = 16'h1901;
assign run_66mhz = 1'b0;
assign bar0_setup[34:16] = 19'h70fff;
assign bar1_setup[34:16] = 19'h00000;
assign sel_23 = 1'b1;

//
// ##########################################################################
//
// Section 3.0
//
// Instantiate EP454G6 IP core
//
// ##########################################################################
//
ep454g6 i_ep454g6
(
.adin			(ad),
.adout			(adout),
.arb_gnt_b		(arb_gnt_b),
.arb_req_b		(arb_req_b),
.cbein_b		(cbe_b),
.cbeout_b		(cbeout_b),
.devselin_b		(devsel_b),
.devselout_b		(devselout_b),
.framein_b		(frame_b),
.frameout_b		(frameout_b),
.gnt_b			(gnt_b),
.idsel			(idsel),
.intaout_b		(intaout_b),
.irdyin_b		(irdy_b),
.irdyout_b		(irdyout_b),
.parin			(par),
.parout			(parout),
.perrin_b		(perr_b),
.perrout_b		(perrout_b),
.reqout_b		(reqout_b),
.serrout_b		(serrout_b),
.stopin_b		(stop_b),
.stopout_b		(stopout_b),
.trdyin_b		(trdy_b),
.trdyout_b		(trdyout_b),
.oe_ad			(oe_ad),
.oe_cbe			(oe_cbe),
.oe_devsel		(oe_devsel),
.oe_frame		(oe_frame),
.oe_irdy		(oe_irdy),
.oe_par			(oe_par),
.oe_perr		(oe_perr),
.oe_req			(oe_req),
.oe_stop		(oe_stop),
.oe_trdy		(oe_trdy),
.bar0_setup		(bar0_setup),
.bar1_setup		(bar1_setup),
.device_id		(device_id),
.vendor_id		(vendor_id),
.class_code		(class_code),
.revision_id		(revision_id),
.interrupt_pin		(interrupt_pin),
.subsystem_id		(subsystem_id),
.subvendor_id		(subvendor_id),
.run_66mhz		(run_66mhz),

.m_haddr		(m_haddr),
.m_hbar			(m_hbar),
.m_hburst		(m_hburst),
.m_hbusreq		(m_hbusreq),
.m_hgrant		(m_hgrant),
.m_hlock		(m_hlock),
.m_hrdata		(m_hrdata),
.m_hready		(m_hready),
.m_hresp		(m_hresp),
.m_hsize		(m_hsize),
.m_htrans		(m_htrans),
.m_hwdata		(m_hwdata),
.m_hwrite		(m_hwrite),
//
// AHB Bus Slave Interface
.haddr			(haddr),
.hburst			(hburst),
.hrdata			(hrdata),
.hready_i		(hready_i),
.hready			(hready),
.hresp			(hresp),
.hsel			(hsel),
.hsize			(hsize),
.htrans			(htrans),
.hwdata			(hwdata),
.hwrite			(hwrite),
//
// System signals
.big_endian		(big_endian),
.clk			(clk),
.hs_fast		(hs_fast),
.h_inta_b		(1'b1),
.pciclk			(pciclk),
.prefetch_limit		(prefetch_limit),
.reset_b		(reset_b),
.sel_23			(sel_23),
.status15		(status15),
.status14		(status14),
.status13		(status13),
.status12		(status12),
.status11		(status11),
.status8		(status8),
.status_rty		(status_rty)
);


endmodule
//
