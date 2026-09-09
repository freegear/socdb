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
// top560: Top level design template for ep560k1. This module shows how
//		ep560k1 is used as a module inside a chip level design.
//
// Rev 1.1
//
// ##########################################################################
//
// Signal Description
//
// SD signals
//	cmd		SD command signal
//	dt		SD data signal
//	sdclk		SD clock signal
//
// System inputs
//	hreset_b	system reset input (upon hardware powerup)
//
// ##########################################################################
//
`timescale 1ns / 100ps

module top560(
cmd,
dt,
sdclk,

abort_b,
addr,
ads_b,
be_b,
blast_b,
cs_b,
drd,
dwr,
error,
rdy_b,
size,
wr,


card_ecc_disabled,
card_ecc_failed,
cid,
csd,
dsr,
ecsd_a,
ecsd_b,
ecsd_c,
ecsd_d,
ecsd_e,
ecsd_f,
ecsd_g,
ecsd_h,
ecsd_i,
ecsd_j,
ecsd_k,
ecsd_l,
ecsd_m,
ecsd_n,
ecsd_o,
ecsd_p,
ecsd_q,
ecsd_r,
ecsd_s,
hreset_b,
ocr_mem,
oe_card_detect,
pwdin,
pwd_len,
rd_thd,
scr,
sel_mmc,
sresetm_b
);

input		sdclk;
inout		cmd;
inout[7:0]	dt;

output		abort_b;
output[40:0] 	addr;
output		ads_b;
output[3:0]	be_b;
output		blast_b;
output[1:0]	cs_b;
input[31:0]	drd;
output[31:0]	dwr;
input		error;
input		rdy_b;
output[9:0]	size;
output		wr;


input		card_ecc_disabled;
input		card_ecc_failed;
input[127:0]	cid;
input[127:0]	csd;
output[15:0]	dsr;
input[7:0]	ecsd_a;
input[31:0]	ecsd_b;
input[7:0]	ecsd_c;
input[7:0]	ecsd_d;
input[7:0]	ecsd_e;
input[7:0]	ecsd_f;
input[7:0]	ecsd_g;
input[7:0]	ecsd_h;
input[7:0]	ecsd_i;
input[7:0]	ecsd_j;
input[7:0]	ecsd_k;
input[7:0]	ecsd_l;
input[7:0]	ecsd_m;
input[7:0]	ecsd_n;
input[7:0]	ecsd_o;
input[7:0]	ecsd_p;
input[7:0]	ecsd_q;
output[7:0]	ecsd_r;
output[7:0]	ecsd_s;
input		hreset_b;
input[31:0]	ocr_mem;
output		oe_card_detect;
input[127:0]	pwdin;
input[7:0]	pwd_len;
input[2:0]	rd_thd;
input[63:0]	scr;
input		sel_mmc;
output		sresetm_b;

wire		oe_cmd;
wire		cmdout;
wire[7:0]	oe_dt;
wire[7:0]	dtout;

//
// ##########################################################################
//
// model tri-state buffers
//
// Pin Key (left column SD, right column SPI:
// CD/DAT[3]	CS
// CMD		DI
// DAT[0]	DO
// DAT[1]	Reserved (Interrupt in SDIO)
// DAT[2]	Reserved (Read-wait in SDIO)
// DAT[4]	Reserved
// DAT[5]	Reserved
// DAT[6]	Reserved
// DAT[7]	Reserved
//
// ##########################################################################
//
assign cmd = (oe_cmd) ? cmdout : 1'bz;
assign dt[0] = (oe_dt[0]) ? dtout[0] : 1'bz;
assign dt[1] = (oe_dt[1]) ? dtout[1] : 1'bz;
assign dt[2] = (oe_dt[2]) ? dtout[2] : 1'bz;
assign dt[3] = (oe_dt[3]) ? dtout[3] : 1'bz;
assign dt[4] = (oe_dt[4]) ? dtout[4] : 1'bz;
assign dt[5] = (oe_dt[5]) ? dtout[5] : 1'bz;
assign dt[6] = (oe_dt[6]) ? dtout[6] : 1'bz;
assign dt[7] = (oe_dt[7]) ? dtout[7] : 1'bz;
//
// ##########################################################################
//
// Instantiate low level modules
//
// ##########################################################################
//
ep560k1 ep560k1(
.cmdin		(cmd),
.cmdout		(cmdout),
.dtin		(dt),
.dtout		(dtout),
.oe_cmd		(oe_cmd),
.oe_dt		(oe_dt),
.sdclk		(sdclk),

.abort_b	(abort_b),
.addr		(addr),
.ads_b		(ads_b),
.be_b		(be_b),
.blast_b	(blast_b),
.cs_b		(cs_b),
.drd		(drd),
.dwr		(dwr),
.error		(error),
.rdy_b		(rdy_b),
.size		(size),
.wr		(wr),


.card_ecc_disabled	(card_ecc_disabled),
.card_ecc_failed	(card_ecc_failed),
.cid		(cid),
.csd		(csd),
.dsr		(dsr),
.ecsd_a		(ecsd_a),
.ecsd_b		(ecsd_b),
.ecsd_c		(ecsd_c),
.ecsd_d		(ecsd_d),
.ecsd_e		(ecsd_e),
.ecsd_f		(ecsd_f),
.ecsd_g		(ecsd_g),
.ecsd_h		(ecsd_h),
.ecsd_i		(ecsd_i),
.ecsd_j		(ecsd_j),
.ecsd_k		(ecsd_k),
.ecsd_l		(ecsd_l),
.ecsd_m		(ecsd_m),
.ecsd_n		(ecsd_n),
.ecsd_o		(ecsd_o),
.ecsd_p		(ecsd_p),
.ecsd_q		(ecsd_q),
.ecsd_r		(ecsd_r),
.ecsd_s		(ecsd_s),
.hreset_b	(hreset_b),
.ocr_mem	(ocr_mem),
.oe_card_detect	(oe_card_detect),
.pwdin		(pwdin),
.pwd_len	(pwd_len),
.rd_thd		(rd_thd),
.scr		(scr),
.sel_mmc	(sel_mmc),
.sresetm_b	(sresetm_b)
);

endmodule
//
// This code is filtered with these parameters defined
// sdm
// mmc
// mmc_2k
