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
// pcimdevice : PCI master device
//
// ##########################################################################
//
// Using this module
//
// Please modify module std_mback according to the user specification
//
// ##########################################################################
//
// Parameters
//
// There are a number of parameters in std_mback.  Some of them are needed
// to be modified.  Please refer to module std_mback for more details.
//
// The following is an example to specify these parameters in the level
// that instantiates the devices,
//
// pcimdevice.std_mback.master_id = 1;
//
// ##########################################################################
//
`timescale 1ns / 100ps

module pcimdevice (
ad,
cbe_b,
clk,
devsel_b,
frame_b,
gnt_b,
idsel,
inta_b,
irdy_b,
par,
perr_b,
req_b,
reset_b,
stop_b,
trdy_b,
test_state,
mtrdone
);

parameter num_cs 	   = 6;

inout[31:0]	ad;
inout[3:0]	cbe_b;
input		clk;
inout		devsel_b;
inout		frame_b;
input		gnt_b;
input		idsel;
output		inta_b;
inout		irdy_b;
inout		par;
inout		perr_b;
output		req_b;
input		reset_b;
inout		stop_b;
inout		trdy_b;
input[31:0]	test_state;
output		mtrdone;

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
wire		h_adsh_b;
wire		h_adsm_b;
wire[31:0]	h_ain;
wire[31:0]	h_aout;
wire[3:0]	h_bein_b;
wire[3:0]	h_beout_b;
wire		h_boff_b;
wire		h_cacheline;
wire[7:0]	h_cache_size;
wire[1:0]	h_cmd;
wire[1:0]	h_cs_b;
wire[31:0]	h_din;
wire		h_done_b;
wire[31:0]	h_dout;
wire		h_mio;
wire		h_rdym_b;
wire[15:0]	h_size;
wire		h_wait_b;
wire		h_wrin;
wire		h_wrout;

wire            blast_b;
wire[num_cs-1:0]cs_b;
wire            err_b;
wire[1:0]       hsize;
wire            rdnxt_b;
wire            wren_b;

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
bufif1 (req_b, reqout_b, oe_req);
bufif1 (stop_b, stopout_b, oe_stop);
bufif1 (trdy_b, trdyout_b, oe_trdy);

assign err_b = (h_boff_b | h_done_b);

std_mback std_mback(
.clk		(clk),
.big_endian	(1'b0),
.addr		(h_ain),
.ads_b	        (h_adsh_b),
.be_b	        (h_bein_b),
.blast_b        (blast_b),
.cacheline	(h_cacheline),
.cs_b           (cs_b),
.err_b          (err_b),
.h_cmd		(h_cmd),
.h_mio          (h_mio),
.dwr		(h_din),
.done_b	        (h_done_b),
.drd		(h_dout),
.hsize          (hsize),
.rdnxt_b        (rdnxt_b),
.rdy_b	        (h_rdym_b),
.size		(h_size),
.wait_b	        (h_wait_b),
.wr		(h_wrin),
.wren_b         (wren_b),
.mtrdone	(mtrdone),
.test_state	(test_state),
.reset_b	(reset_b)
);
defparam std_mback.num_cs = num_cs;

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
.gnt_b		(gnt_b),
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
.h_abort_b	(1'b1),
.h_adsh_b	(h_adsh_b),
.h_adsm_b	(h_adsm_b),
.h_ain		(h_ain),
.h_aout		(h_aout),
.h_bein_b	(h_bein_b),
.h_beout_b	(h_beout_b),
.h_bii_b	(1'b1),
.h_blast_b	(1'b1),
.h_boff_b	(h_boff_b),
.h_cacheline	(h_cacheline),
.h_cache_size	(h_cache_size),
.h_cmd		(h_cmd),
.h_cs_b		(h_cs_b),
.h_din		(h_din),
.h_done_b	(h_done_b),
.h_dout		(h_dout),
.h_inta_b	(1'b1),
.h_mio		(h_mio),
.h_rdyh_b	(1'b1),
.h_rdym_b	(h_rdym_b),
.h_retry_b	(1'b1),
.h_size		(h_size),
.h_wait_b	(h_wait_b),
.h_wrin		(h_wrin),
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
