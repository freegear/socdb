// ##########################################################################
//
// Copyright (C) by Eureka Technology Inc.
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
// EP454G6 AHB-PCI Bridge
//
// Rev 1.0
//
// Root: ep454 Rev 2.2
//
// ##########################################################################
//
// Brief Description
//
// EP454 is an ARM-to-PCI host bridge. This host bridge provides the ARM
// CPU with access to the PCI bus. It also allows other PCI devices to
// access data on the ARM cpu bus.
//
// The ARM interface is AHB bus compatible. It contains ARM slave and ARM
// master functions. The PCI interface is compliant with PCI spec 2.2-3.0.
//  It contains PCI master, PCI slave, and capability to generate PCI
// configuration cycles to other PCI devices. This PCI interface also
// supports Cardbus interface with the additional CLKRUN signal. The
// PCI bus and the ARM bus each runs at its own clock.
//
// The ARM-to-PCI host bridge also contains an internal mailbox to pass
// message between the ARM and the PCI bus.
//
// ##########################################################################
//
// Signal Description
//
// PCI Interface
// 		adin			PCI address/data bus in 
// 		adout 			PCI address/data bus out
//		arb_gnt_b		Bus grant from PCI bus arbiter
//		arb_req_b		Bus request to PCI bus arbiter
// 		cbein_b 		PCI command/byte enable bus in 
// 		cbeout_b 		PCI command/byte enable bus out 
// 		devselin_b 		DEVSEL input
// 		devselout_b 		DEVSEL output
// 		framein_b 		FRAME input
// 		frameout_b		FRAME output
// 		gnt_b 			PCI bus grant
// 		idsel 			ID select for configuration 
//		intaout_b		interrupt A
// 		irdyin_b 		IRDY input
// 		irdyout_b 		IRDY output
// 		parin 			parity input
// 		parout 			parity output
// 		perrin_b 		data parity input
// 		perrout_b 		data parity output
// 		reqout_b 		PCI bus request
// 		serrout_b 		system error
// 		stopin_b 		STOP input
// 		stopout_b 		STOP output
// 		trdyin_b 		TRDY input
// 		trdyout_b 		TRDY output
// 		oe_ad 			Address/data output enable
// 		oe_cbe 			command/byte enable output enable
// 		oe_devsel 		DEVSEL output enable
// 		oe_frame 		FRAME output enable
// 		oe_irdy 		IRDY output enable
// 		oe_par 			parity output enable
// 		oe_perr 		data parity output enable
// 		oe_req 			PCI bus request output enable
// 		oe_stop 		STOP output enable
// 		oe_trdy 		TRDY output enable
//
// AHB Bus Master Interface
//		m_haddr			AHB address
//		m_hbar			Sideband signal, indicates the BAR hit
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
//		bar0_setup		BAR0 set up bit
//		bar1_setup		BAR1 set up bit
//		big_endian		big endian mode
//		clk			System bus clock
//		hs_fast			fast AHB-PCI posted write
//		h_inta_b		Backend interrupt
//		pciclk			PCI bus clock
//		prefetch_limit		Target read prefetch limit
//					00=4 words
//					01=8 words
//					10=16 words
//		reset_b			System reset input
//		sel_23			PCI revision 2.2/2.3
//					1=rev2.3   0=rev2.2
//
// ##########################################################################
//
`timescale 1ns / 100ps

module ep454g6(
	adin,
	adout,
	arb_gnt_b,
	arb_req_b,
	cbein_b,
	cbeout_b,
	devselin_b,
	devselout_b,
	framein_b,
	frameout_b,
	gnt_b,
	idsel,
	intaout_b,
	irdyin_b,
	irdyout_b,
	parin,
	parout,
	perrin_b,
	perrout_b,
	reqout_b,
	serrout_b,
	stopin_b,
	stopout_b,
	trdyin_b,
	trdyout_b,
	oe_ad,
	oe_cbe,
	oe_devsel,
	oe_frame,
	oe_irdy,
	oe_par,
	oe_perr,
	oe_req,
	oe_stop,
	oe_trdy,
	bar0_setup,
	bar1_setup,
	device_id,
	vendor_id,
	class_code,
	revision_id,
	interrupt_pin,
	subsystem_id,
	subvendor_id,
	run_66mhz,
//
	m_haddr,
	m_hbar,
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
//
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
//
	big_endian,
	clk,
	hs_fast,
	h_inta_b,
	pciclk,
	prefetch_limit,
	reset_b,
	sel_23,
	status15,
	status14,
	status13,
	status12,
	status11,
	status8,
	status_rty
);

input[31:0]	adin;
output[31:0]	adout;
output[8:0]	arb_gnt_b;
input[8:0]	arb_req_b;
input[3:0]	cbein_b;
output[3:0]	cbeout_b;
input		devselin_b;
output		devselout_b;
input		framein_b;
output		frameout_b;
input		gnt_b;
input		idsel;
output		intaout_b;
input		irdyin_b;
output		irdyout_b;
input		parin;
output		parout;
input		perrin_b;
output		perrout_b;
output		reqout_b;
output		serrout_b;
input		stopin_b;
output		stopout_b;
input		trdyin_b;
output		trdyout_b;
output		oe_ad;
output		oe_cbe;
output		oe_devsel;
output		oe_frame;
output		oe_irdy;
output		oe_par;
output		oe_perr;
output		oe_req;
output		oe_stop;
output		oe_trdy;
input[34:16]	bar0_setup;
input[34:16]	bar1_setup;
input[15:0]	device_id;
input[15:0]	vendor_id;
input[23:0]	class_code;
input[7:0]	revision_id;
input[7:0]	interrupt_pin;
input[15:0]	subsystem_id;
input[15:0]	subvendor_id;
input		run_66mhz;


// AHB Bus Master Interface
output[31:0]	m_haddr;
output[1:0]	m_hbar;
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

input		big_endian;
input		clk;
input		hs_fast;
input		h_inta_b;
input		pciclk;
input[1:0]	prefetch_limit;
input		reset_b;
input		sel_23;
output		status15;
output		status14;
output		status13;
output		status12;
output		status11;
output		status8;
output		status_rty;


wire		h_wb_busy;
wire[5:0]	s_hsel;
wire[4:0]	def_lat_cnt;
wire[3:0]	pci_rdbuf_raddr;
wire[31:0]	pci_rdbuf_rdata;
wire[3:0]	pci_rdbuf_waddr;
wire[31:0]	pci_rdbuf_wdata;
wire		pci_rdbuf_wren;

wire[4:0]	pci_wrbuf_raddr;
wire[31:0]	pci_wrbuf_rdata;
wire[4:0]	pci_wrbuf_waddr;
wire[31:0]	pci_wrbuf_wdata;
wire[3:0]	pci_wrbuf_wren;

wire[3:0]	m_hprot;
wire[31:0]	cpu_adr;
wire		db01_wea;
wire		db23_wea_word;
wire		db45_wea_word;
wire		db6_wea;
wire		h_abort_b;
wire		h_adsh_b;
wire		h_adsm_b;
wire[31:0]	h_ain;
wire[31:0]	h_aout;
wire[3:0]	h_bein_b;
wire[3:0]	h_beout_b;
wire		h_boff_b;
wire		h_burst_b;
wire		h_burst_cont;
wire		h_cacheline;
wire[7:0]	h_cache_size;
wire[1:0]	h_cmd;
wire[6:0]	h_cs_b;
wire[31:0]	h_din;
wire		h_discard;
wire		h_done_b;
wire[31:0]	h_dout;
wire		h_drcmt_b;
wire		h_mio;
wire[1:0]	h_mrd_cmd;
wire		h_par;
wire		h_rdyh_b;
wire		h_rdym_b;
wire		h_retry_b;
wire[15:0]	h_size;
wire		h_wrin;
wire		h_wrout;
wire		mack_b;
wire		mrdreq_b;
wire		mrd_abort;
wire[3:0]	mrd_addra;
wire[3:0]	mrd_addrb;
wire[31:0]	mrd_dina;
wire[31:0]	mrd_doutb;
wire		mwrreq_b;
wire[6:0]	mwr_addra;
wire[6:0]	mwr_addrb;
wire[3:0]	mwr_beina;
wire[3:0]	mwr_beoutb;
wire[31:0]	mwr_dina;
wire[31:0]	mwr_doutb;
wire[31:0]	pci_adr;
wire[6:0]	pci_bar;
wire[3:0]	pci_be_b;
wire		pci_cacheline;
wire[1:0]	pci_cmd;
wire		pci_mio;
wire[6:0]	pci_size;
wire		tack_b;
wire		trdreq_b;
wire		trd_abort;
wire[3:0]	trd_addra;
wire[7:0]	trd_addrb;
wire[3:0]	trd_be_b;
wire[31:0]	trd_dina;
wire[31:0]	trd_doutb;
wire		trd_retry;
wire[4:0]	trd_size;
wire		twrreq_b;
wire[7:0]	twr_addra;
wire[7:0]	twr_addrb;
wire[63:0]	twr_be_b;
wire[31:0]	twr_dina;
wire[31:0]	twr_doutb;
wire[15:0]	twr_dword_empty;
wire[15:0]	twr_dword_full;
wire[15:0]	valid_bit;
wire		m_swapen;
wire		t_swapen;
wire[4:0]	mwr_ramb0_raddr;
wire[4:0]	mwr_ramb0_waddr;
wire[4:0]	mwr_ramb1_raddr;
wire[4:0]	mwr_ramb1_waddr;
wire		hd_done_b;
wire		hd_err_b;
wire		hd_rdy_b;
wire[4:0]	trd_dlysize;
wire		more_wb;
wire[6:0]	int_m_hbar;

//
// ##########################################################################
//
// Section 1
//
// Hardwired signals
//
// ##########################################################################
//
assign m_swapen = ~big_endian;
assign t_swapen = ~big_endian;
assign mwr_ramb0_raddr[4] = mwr_addrb[6];
assign mwr_ramb0_raddr[3:0] = mwr_addrb[3:0];
assign mwr_ramb0_waddr[4] = mwr_addra[6];
assign mwr_ramb0_waddr[3:0] = mwr_addra[3:0];
assign mwr_ramb1_raddr[4] = mwr_addrb[6];
assign mwr_ramb1_raddr[3:0] = mwr_addrb[3:0];
assign mwr_ramb1_waddr[4] = mwr_addra[6];
assign mwr_ramb1_waddr[3:0] = mwr_addra[3:0];
assign s_hsel[5:4] = 2'b00;
assign s_hsel[3:0] = hsel[3:0];
assign h_cs_b [6:2] = 5'b11111;
assign m_hbar = int_m_hbar[1:0];
assign def_lat_cnt = 5'b10000;
//
// ##########################################################################
//
// Section 2
//
// RAM BLOCK Instantiations
//
// ##########################################################################
//
eu_dpramx2 #(5, 32) mwr_ramb0 (
.raddr		(mwr_ramb0_raddr),
.rclk		(pciclk),
.rdata		(mwr_doutb),
.waddr		(mwr_ramb0_waddr),
.wclk		(clk),
.wdata		(mwr_dina),
.we		(db01_wea)
);

eu_dpramx1 #(5, 4) mwr_ramb1 (
.raddr		(mwr_ramb1_raddr),
.rclk		(pciclk),
.rdata		(mwr_beoutb),
.waddr		(mwr_ramb1_waddr),
.wclk		(clk),
.wdata		(mwr_beina),
.we		(db01_wea)
);

eu_dpramx2 #(4, 32) mrd_ramb0 (
.raddr		(mrd_addrb[3:0]),
.rclk		(clk),
.rdata		(mrd_doutb),
.waddr		(mrd_addra[3:0]),
.wclk		(pciclk),
.wdata		(mrd_dina),
.we		(db23_wea_word)
);

eu_dpramx2 #(5, 32) twr_ramb0 (
.raddr		(twr_addrb[4:0]),
.rclk		(clk),
.rdata		(twr_doutb),
.waddr		(twr_addra[4:0]),
.wclk		(pciclk),
.wdata		(twr_dina),
.we		(db45_wea_word)
);

eu_dpramx2 #(4, 32) trd_ramb0 (
.raddr		(trd_addrb[3:0]),
.rclk		(pciclk),
.rdata		(trd_doutb),
.waddr		(trd_addra[3:0]),
.wclk		(clk),
.wdata		(trd_dina),
.we		(db6_wea)
);

// Read data buffer for PCI bus access from AHB
eu_dpramx2 #(4, 32) pci_rdbuf(
.raddr			(pci_rdbuf_raddr),
.rclk			(clk),
.rdata			(pci_rdbuf_rdata),
.waddr			(pci_rdbuf_waddr),
.wclk			(clk),
.wdata			(pci_rdbuf_wdata),
.we			(pci_rdbuf_wren)
);

// Write buffer for PCI bus access from AHB
eu_dpramx1 #(5, 8) pci_wrbuf_a(
.raddr			(pci_wrbuf_raddr),
.rclk			(clk),
.rdata			(pci_wrbuf_rdata[7:0]),
.waddr			(pci_wrbuf_waddr),
.wclk			(clk),
.wdata			(pci_wrbuf_wdata[7:0]),
.we			(pci_wrbuf_wren[0])
);

eu_dpramx1 #(5, 8) pci_wrbuf_b(
.raddr			(pci_wrbuf_raddr),
.rclk			(clk),
.rdata			(pci_wrbuf_rdata[15:8]),
.waddr			(pci_wrbuf_waddr),
.wclk			(clk),
.wdata			(pci_wrbuf_wdata[15:8]),
.we			(pci_wrbuf_wren[1])
);

eu_dpramx1 #(5, 8) pci_wrbuf_c(
.raddr			(pci_wrbuf_raddr),
.rclk			(clk),
.rdata			(pci_wrbuf_rdata[23:16]),
.waddr			(pci_wrbuf_waddr),
.wclk			(clk),
.wdata			(pci_wrbuf_wdata[23:16]),
.we			(pci_wrbuf_wren[2])
);

eu_dpramx1 #(5, 8) pci_wrbuf_d(
.raddr			(pci_wrbuf_raddr),
.rclk			(clk),
.rdata			(pci_wrbuf_rdata[31:24]),
.waddr			(pci_wrbuf_waddr),
.wclk			(clk),
.wdata			(pci_wrbuf_wdata[31:24]),
.we			(pci_wrbuf_wren[3])
);

//
// ##########################################################################
//
// Section 3
//
// Component Instantiations
//
// ##########################################################################
//
ab_slvb i_ab_slvb(
.big_endian		(big_endian),
.clk			(clk),
.s_haddr		(haddr),
.s_hburst		(hburst),
.s_hrdata		(hrdata),
.s_hreadyin		(hready_i),
.s_hreadyout		(hready),
.s_hresp		(hresp),
.s_hsel			(s_hsel),
.s_hsize		(hsize),
.s_htrans		(htrans),
.s_hwdata		(hwdata),
.s_hwrite		(hwrite),

.reset_b		(reset_b),
.pci_rdbuf_raddr	(pci_rdbuf_raddr),
.pci_rdbuf_rdata	(pci_rdbuf_rdata),
.pci_rdbuf_waddr	(pci_rdbuf_waddr),
.pci_rdbuf_wdata	(pci_rdbuf_wdata),
.pci_rdbuf_wren		(pci_rdbuf_wren),
.pci_wrbuf_raddr	(pci_wrbuf_raddr),
.pci_wrbuf_rdata	(pci_wrbuf_rdata),
.pci_wrbuf_waddr	(pci_wrbuf_waddr),
.pci_wrbuf_wdata	(pci_wrbuf_wdata),
.pci_wrbuf_wren		(pci_wrbuf_wren),

.db01_wea		(db01_wea),
.h_wb_busy		(h_wb_busy),
.hs_fast		(hs_fast),
.m_swapen		(m_swapen),
.mack_b			(mack_b),
.mrdreq_b		(mrdreq_b),
.mrd_abort		(mrd_abort),
.mrd_addrb		(mrd_addrb),
.mrd_doutb		(mrd_doutb),
.mwrreq_b		(mwrreq_b),
.mwr_addra		(mwr_addra),
.mwr_addrb		(mwr_addrb[6]),
.mwr_beina		(mwr_beina),
.mwr_dina		(mwr_dina),
.pci_adr		(pci_adr),
.pci_be_b		(pci_be_b),
.pci_cacheline		(pci_cacheline),
.pci_cmd		(pci_cmd),
.pci_mio		(pci_mio),
.pci_size		(pci_size)


);

ab_masb i_ab_masb(
.big_endian		(big_endian),
.clk			(clk),
.m_haddr		(m_haddr),
.m_hbar			(int_m_hbar),
.m_hburst		(m_hburst),
.m_hbusreq		(m_hbusreq),
.m_hgrant		(m_hgrant),
.m_hlock		(m_hlock),
.m_hprot		(m_hprot),
.m_hrdata		(m_hrdata),
.m_hready		(m_hready),
.m_hresp		(m_hresp),
.m_hsize		(m_hsize),
.m_htrans		(m_htrans),
.m_hwdata		(m_hwdata),
.m_hwrite		(m_hwrite),
.cpu_adr		(cpu_adr),
.db6_wea		(db6_wea),
.pci_bar		(pci_bar),
.tack_b			(tack_b),
.trdreq_b		(trdreq_b),
.trd_abort		(trd_abort),
.trd_addra		(trd_addra),
.trd_be_b		(trd_be_b),
.trd_dina		(trd_dina),
.trd_dlysize		(trd_dlysize),
.trd_retry		(trd_retry),
.twrreq_b		(twrreq_b),
.twr_addrb		(twr_addrb[3:0]),
.twr_be_b		(twr_be_b),
.twr_doutb		(twr_doutb),
.twr_dword_empty	(twr_dword_empty),
.twr_dword_full		(twr_dword_full),
.valid_bit		(valid_bit),
.reset_b		(reset_b),
.swap			(1'b0)
);

mbackpci i_mbackpci (
.db23_wea_word	(db23_wea_word),
.h_adsh_b	(h_adsh_b),
.h_ain		(h_ain),
.h_bein_b	(h_bein_b),
.h_boff_b	(h_boff_b),
.h_cacheline	(h_cacheline),
.h_cmd		(h_cmd),
.h_done_b	(h_done_b),
.h_dout		(h_dout),
.h_mio		(h_mio),
.h_rdym_b	(h_rdym_b),
.h_size		(h_size),
.h_wrin		(h_wrin),
.mack_b		(mack_b),
.mrdreq_b	(mrdreq_b),
.mrd_abort	(mrd_abort),
.mrd_addra	(mrd_addra),
.mrd_dina	(mrd_dina),
.mwrreq_b	(mwrreq_b),
.mwr_addrb	(mwr_addrb[5:0]),
.mwr_beoutb	(mwr_beoutb),
.pci_adr	(pci_adr),
.pci_be_b	(pci_be_b),
.pci_cacheline	(pci_cacheline),
.pci_cmd	(pci_cmd),
.pci_mio	(pci_mio),
.pci_size	(pci_size),
.pciclk		(pciclk),
.reset_b	(reset_b)
);

tbackpci i_tbackpci (
.cpu_adr	(cpu_adr),
.db45_wea_word	(db45_wea_word),
.def_lat_cnt	(def_lat_cnt),
.h_abort_b	(h_abort_b),
.h_adsm_b	(h_adsm_b),
.h_aout		(h_aout),
.h_beout_b	(h_beout_b),
.h_boff_b	(h_boff_b),
.h_burst_b	(h_burst_b),
.h_burst_cont	(h_burst_cont),
.h_cs_b		(h_cs_b),
.h_din		(h_din),
.h_discard	(h_discard),
.h_dout		(h_dout),
.h_drcmt_b	(h_drcmt_b),
.h_mrd_cmd	(h_mrd_cmd),
.h_rdyh_b	(h_rdyh_b),
.h_retry_b	(h_retry_b),
.h_wrout	(h_wrout),
.more_wb	(more_wb),
.mwr_doutb	(mwr_doutb),
.pci_bar	(pci_bar),
.pciclk		(pciclk),
.reset_b	(reset_b),
.tack_b		(tack_b),
.trdreq_b	(trdreq_b),
.trd_abort	(trd_abort),
.trd_addrb	(trd_addrb),
.trd_be_b	(trd_be_b),
.trd_dlysize	(trd_dlysize),
.trd_doutb	(trd_doutb),
.trd_retry	(trd_retry),
.trd_size	(trd_size),
.twrreq_b	(twrreq_b),
.twr_addra	(twr_addra),
.twr_addrb	(twr_addrb[7:4]),
.twr_be_b	(twr_be_b),
.twr_dina	(twr_dina),
.twr_dword_empty(twr_dword_empty),
.twr_dword_full	(twr_dword_full),
.valid_bit	(valid_bit)
);

pciif i_pciif (
.adin		(adin),
.adout		(adout),
.cbein_b	(cbein_b),
.cbeout_b	(cbeout_b),
.clk		(pciclk),
.devselin_b	(devselin_b),
.devselout_b	(devselout_b),
.framein_b	(framein_b),
.frameout_b	(frameout_b),
.gnt_b		(gnt_b),
.idsel		(idsel),
.intaout_b	(intaout_b),
.irdyin_b	(irdyin_b),
.irdyout_b	(irdyout_b),
.parin		(parin),
.parout		(parout),
.perrin_b	(perrin_b),
.perrout_b	(perrout_b),
.reqout_b	(reqout_b),
.reset_b	(reset_b),
.serrout_b	(serrout_b),
.stopin_b	(stopin_b),
.stopout_b	(stopout_b),
.trdyin_b	(trdyin_b),
.trdyout_b	(trdyout_b),
.h_abort_b	(h_abort_b),
.h_adsh_b	(h_adsh_b),
.h_adsm_b	(h_adsm_b),
.h_ain		(h_ain),
.h_aout		(h_aout),
.h_bein_b	(h_bein_b),
.h_beout_b	(h_beout_b),
.h_bii_b	(1'b1),
.h_blast_b	(1'b1),
.h_boff_b	(h_boff_b),
.h_burst_b	(h_burst_b),
.h_burst_cont	(h_burst_cont),
.h_cacheline	(h_cacheline),
.h_cache_size	(h_cache_size),
.h_cmd		(h_cmd),
.h_cs_b		(h_cs_b[1:0]),
.h_din		(h_din),
.h_discard	(h_discard),
.h_done_b	(h_done_b),
.h_dout		(h_dout),
.h_drcmt_b	(h_drcmt_b),
.h_inta_b	(h_inta_b),
.h_mio		(h_mio),
.h_mrd_cmd	(h_mrd_cmd),
.h_par		(h_par),
.h_rdyh_b	(h_rdyh_b),
.h_rdym_b	(h_rdym_b),
.h_retry_b	(h_retry_b),
.h_size		(h_size),
.h_wrin		(h_wrin),
.h_wrout	(h_wrout),
.status15	(status15),
.status14	(status14),
.status13	(status13),
.status12	(status12),
.status11	(status11),
.status8	(status8),
.status_rty	(status_rty),
.more_wb	(more_wb),
.prefetch_limit	(prefetch_limit),
.trd_size	(trd_size),
.oe_ad		(oe_ad),
.oe_cbe		(oe_cbe),
.oe_devsel	(oe_devsel),
.oe_frame	(oe_frame),
.oe_irdy	(oe_irdy),
.oe_par		(oe_par),
.oe_perr	(oe_perr),
.oe_req		(oe_req),
.oe_stop	(oe_stop),
.oe_trdy	(oe_trdy),
.bar0_setup	(bar0_setup),
.bar1_setup	(bar1_setup),
.device_id	(device_id),
.vendor_id	(vendor_id),
.class_code	(class_code),
.revision_id	(revision_id),
.interrupt_pin	(interrupt_pin),
.subsystem_id	(subsystem_id),
.subvendor_id	(subvendor_id),
.run_66mhz	(run_66mhz),
.sel_23		(sel_23)
);

pciarb i_pciarb(
.clk		(pciclk),
.framein_b	(framein_b),
.gnt_b		(arb_gnt_b),
.irdyin_b	(irdyin_b),
.req_b		(arb_req_b),
.reset_b	(reset_b)
);

endmodule

//
