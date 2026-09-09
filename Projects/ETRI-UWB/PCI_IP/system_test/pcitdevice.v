//
// ##########################################################################
//
// Copyright (c) 2002 by Eureka Technology Inc.
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
// pcitdevice : PCI target device
//
// ##########################################################################
//
// Using this module
//
// Please modify module std_tback according to the user specification.
//
// May need to change the size of the base registers in pcimodel.  Some
// variable assignments that may need modification are "base0_adr", "base1_adr",
// "base0_reg", "base1_reg", "adr0_match" & "adr1_match".
//
// ##########################################################################
//
// Parameters
//
// There are a number of parameters in std_tback.  Please refer to module
// std_tback for more details.
//
// The following is an example to specify these parameters in the level
// that instantiates the devices,
//
// pcitdevice.std_tback.cache_size = 4;
//
// ##########################################################################
//
`timescale 1ns / 100ps

module pcitdevice (
ad,
cbe_b,
clk,
devsel_b,
frame_b,
idsel,
inta_b,
irdy_b,
par,
perr_b,
reset_b,
serr_b,
stop_b,
trdy_b,
test_state
);

inout[31:0]	ad;
inout[3:0]	cbe_b;
input		clk;
inout		devsel_b;
inout		frame_b;
input		idsel;
output		inta_b;
inout		irdy_b;
inout		par;
inout		perr_b;
input		reset_b;
output		serr_b;
inout		stop_b;
inout		trdy_b;
input[31:0]	test_state;

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
wire		h_abort_b;
wire		h_adsm_b;
wire[31:0]	h_aout;
wire[3:0]	h_beout_b;
wire		h_boff_b;
wire[7:0]	h_cache_size;
wire[1:0]	h_cs_b;
wire[31:0]	h_din;
wire		h_done_b;
wire[31:0]	h_dout;
wire		h_rdyh_b;
wire		h_rdym_b;
wire		h_retry_b;
wire		h_wrout;

wire            done0_b;
wire            done1_b;
wire            h_abort0_b;
wire            h_abort1_b;
wire[31:0]      h_din0;
wire[31:0]      h_din1;
wire            h_rdyh0_b;
wire            h_rdyh1_b;
wire            h_retry0_b;
wire            h_retry1_b;

bufif1 (ad[0], adout[0], oe_ad);
bufif1 (ad[1], adout[1], oe_ad);
bufif1 (ad[2], adout[2], oe_ad);
bufif1 (ad[3], adout[3], oe_ad);
bufif1 (ad[4], adout[4], oe_ad);
bufif1 (ad[5], adout[5], oe_ad);
bufif1 (ad[6], adout[6], oe_ad);
bufif1 (ad[7], adout[7], oe_ad);
bufif1 (ad[8], adout[8], oe_ad);
bufif1 (ad[9], adout[9], oe_ad);
bufif1 (ad[10], adout[10], oe_ad);
bufif1 (ad[11], adout[11], oe_ad);
bufif1 (ad[12], adout[12], oe_ad);
bufif1 (ad[13], adout[13], oe_ad);
bufif1 (ad[14], adout[14], oe_ad);
bufif1 (ad[15], adout[15], oe_ad);
bufif1 (ad[16], adout[16], oe_ad);
bufif1 (ad[17], adout[17], oe_ad);
bufif1 (ad[18], adout[18], oe_ad);
bufif1 (ad[19], adout[19], oe_ad);
bufif1 (ad[20], adout[20], oe_ad);
bufif1 (ad[21], adout[21], oe_ad);
bufif1 (ad[22], adout[22], oe_ad);
bufif1 (ad[23], adout[23], oe_ad);
bufif1 (ad[24], adout[24], oe_ad);
bufif1 (ad[25], adout[25], oe_ad);
bufif1 (ad[26], adout[26], oe_ad);
bufif1 (ad[27], adout[27], oe_ad);
bufif1 (ad[28], adout[28], oe_ad);
bufif1 (ad[29], adout[29], oe_ad);
bufif1 (ad[30], adout[30], oe_ad);
bufif1 (ad[31], adout[31], oe_ad);

bufif1 (cbe_b[0], cbeout_b[0], oe_cbe);
bufif1 (cbe_b[1], cbeout_b[1], oe_cbe);
bufif1 (cbe_b[2], cbeout_b[2], oe_cbe);
bufif1 (cbe_b[3], cbeout_b[3], oe_cbe);

bufif1 (devsel_b, devselout_b, oe_devsel);
bufif1 (frame_b, frameout_b, oe_frame);
bufif1 (inta_b, intaout_b, ~intaout_b);
bufif1 (irdy_b, irdyout_b, oe_irdy);
bufif1 (par, parout, oe_par);
bufif1 (perr_b, perrout_b, oe_perr);
bufif1 (serr_b, serrout_b, ~serrout_b);
bufif1 (stop_b, stopout_b, oe_stop);
bufif1 (trdy_b, trdyout_b, oe_trdy);

std_tback std_tback0(
.clk		(clk),
.abort_b	(h_abort0_b),
.addr		(h_aout),
.ads_b	        (h_adsm_b),
.be_b		(h_beout_b),
.blast_b        (1'b1),
.cs_b		(h_cs_b[0]),
.done_b         (done0_b),
.drd	        (h_din0),
.dwr	        (h_dout),
.rdy_b	        (h_rdyh0_b),
.rdnxt_b        (1'b1),
.retry_b	(h_retry0_b),
.size           (8'hff),
.tar64_b        (1'b1),
.wr		(h_wrout),
.wren_b         (1'b1),
.test_state	(test_state),
.reset_b	(reset_b)
);

std_tback std_tback1(
.clk		(clk),
.abort_b	(h_abort1_b),
.addr		(h_aout),
.ads_b	        (h_adsm_b),
.be_b		(h_beout_b),
.blast_b        (1'b1),
.cs_b		(h_cs_b[1]),
.done_b         (done1_b),
.drd	        (h_din1),
.dwr	        (h_dout),
.rdy_b	        (h_rdyh1_b),
.rdnxt_b        (1'b1),
.retry_b	(h_retry1_b),
.size           (8'hff),
.tar64_b        (1'b1),
.wr		(h_wrout),
.wren_b         (1'b1),
.test_state	(test_state),
.reset_b	(reset_b)
);

assign h_rdyh_b = (~h_cs_b[0]) ? h_rdyh0_b : 
                  ((~h_cs_b[1]) ? h_rdyh1_b : 1'b1);

assign h_abort_b = (~h_cs_b[0]) ? h_abort0_b : 
                  ((~h_cs_b[1]) ? h_abort1_b : 1'b1);

assign h_retry_b = (~h_cs_b[0]) ? h_retry0_b : 
                  ((~h_cs_b[1]) ? h_retry1_b : (h_retry0_b & h_retry1_b));

assign h_din = (~h_cs_b[0]) ? h_din0 : 
               ((~h_cs_b[1]) ? h_din1 : 32'hxxxxxxxx);


pcimodel pcimodel(
.adin		(ad),
.adout		(adout),
.cbein_b	(cbe_b),
.cbeout_b	(cbeout_b),
.clk		(clk),
.devselin_b	(devsel_b),
.devselout_b	(devselout_b),
.framein_b	(frame_b),
.frameout_b	(frameout_b),
.gnt_b		(1'b1),
.idsel		(idsel),
.intaout_b	(intaout_b),
.irdyin_b	(irdy_b),
.irdyout_b	(irdyout_b),
.parin		(par),
.parout		(parout),
.perrin_b	(perr_b),
.perrout_b	(perrout_b),
.reqout_b	(reqout_b),
.reset_b	(reset_b),
.serrout_b	(serrout_b),
.stopin_b	(stop_b),
.stopout_b	(stopout_b),
.trdyin_b	(trdy_b),
.trdyout_b	(trdyout_b),
.h_abort_b	(h_abort_b),
.h_adsh_b	(1'b1),
.h_adsm_b	(h_adsm_b),
.h_ain		(32'h00000000),
.h_aout		(h_aout),
.h_bein_b	(4'b0000),
.h_beout_b	(h_beout_b),
.h_bii_b	(1'b1),
.h_blast_b	(1'b1),
.h_boff_b	(h_boff_b),
.h_cacheline	(1'b0),
.h_cache_size	(h_cache_size),
.h_cmd		(2'b00),
.h_cs_b		(h_cs_b),
.h_din		(h_din),
.h_done_b	(h_done_b),
.h_dout		(h_dout),
.h_inta_b	(1'b1),
.h_mio		(1'b1),
.h_rdyh_b	(h_rdyh_b),
.h_rdym_b	(h_rdym_b),
.h_retry_b	(h_retry_b),
.h_size		(16'hffff),
.h_wait_b	(1'b1),
.h_wrin		(1'b0),
.h_wrout	(h_wrout),
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
.device_id	(16'h0000),
.vendor_id	(16'heeee),
.class_code	(24'hff0000),
.revision_id	(8'h00),
.interrupt_pin	(8'h01),
.subsystem_id	(16'h0000),
.subvendor_id	(16'heeee),
.run_66mhz	(1'b0)
);

endmodule
