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
// ep560k1 SD Slave controller
//
// Rev 1.1
//
// ##########################################################################
//
// Rev 1.1 modification from previous revision
//
// 070622	No SDIO signals
// 070622	41 bit user address
//
// ##########################################################################
//
// Signal Description:
//
// SD interface:
//		clk			clock input from SD interface
//		cmdin			CMD input pin
//		cmdout			CMD output pin
//		dtin			DAT in pin
//		dtout			DAT out pin
//		oe_cmd			output enable for CMD pin
//		oe_dt			output enable for DAT pin
//
// Memory Card User interface:
//		abort_b			abort current user transaction
//		addr			memory address to user logic
//		ads_b			address strobe, signals to start an access
//		be_b			byte enable, indicating which bytes are transferred
//		blast_b			burst last, signals last word of burst
//		cs_b			chip select for the type of operation requested by user
//		drd			data read line
//		dwr			data write line
//		error			user request caused error
//		rdy_b			data ready or command acknowledgement
//		size			transfer size
//		wr			indicates write or read access
//
// System and Status Signals:
//		card_ecc_disabled	Card ECC is disabled
//		card_ecc_failed		ECC applied to data, but failed
//		dsr			DSR contents
//		hreset_b		hardware reset
//		pwdin			Password Input
//		pwd_len			Password Length Input
//		rd_thd			read threshold for stream data read
//		sresetm_b		soft reset signal to user for memory
//
// ##########################################################################
//
`timescale 1ns / 100ps

module ep560k1(
cmdin,
cmdout,
dtin,
dtout,
oe_cmd,
oe_dt,
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

input		cmdin;
output		cmdout;
output		oe_cmd;
input[7:0]	dtin;
output[7:0]	dtout;
output[7:0]	oe_dt;
input		sdclk;

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

wire[9:0]	dtbuf_raddr;
wire[31:0]	dtbuf_rdata;
wire[9:0]	dtbuf_waddr;
wire[31:0]	dtbuf_wdata;
wire		dtbuf_wren;


//
// ##########################################################################
//
// Instantiate low level modules
//
// ##########################################################################
//
sd_slave sd_slave(
.clk			(sdclk),
.cmdin			(cmdin),
.cmdout			(cmdout),
.dtin			(dtin),
.dtout			(dtout),
.oe_cmd			(oe_cmd),
.oe_dt			(oe_dt),

.abort_b		(abort_b),
.addr			(addr),
.ads_b			(ads_b),
.be_b			(be_b),
.blast_b		(blast_b),
.cs_b			(cs_b),
.drd			(drd),
.dwr			(dwr),
.error			(error),
.rdy_b			(rdy_b),
.size			(size),
.wr			(wr),


.card_ecc_disabled	(card_ecc_disabled),
.card_ecc_failed	(card_ecc_failed),
.cid			(cid),
.csd			(csd),
.dsr			(dsr),
.ecsd_a			(ecsd_a),
.ecsd_b			(ecsd_b),
.ecsd_c			(ecsd_c),
.ecsd_d			(ecsd_d),
.ecsd_e			(ecsd_e),
.ecsd_f			(ecsd_f),
.ecsd_g			(ecsd_g),
.ecsd_h			(ecsd_h),
.ecsd_i			(ecsd_i),
.ecsd_j			(ecsd_j),
.ecsd_k			(ecsd_k),
.ecsd_l			(ecsd_l),
.ecsd_m			(ecsd_m),
.ecsd_n			(ecsd_n),
.ecsd_o			(ecsd_o),
.ecsd_p			(ecsd_p),
.ecsd_q			(ecsd_q),
.ecsd_r			(ecsd_r),
.ecsd_s			(ecsd_s),
.hreset_b		(hreset_b),
.ocr_mem		(ocr_mem),
.oe_card_detect		(oe_card_detect),
.pwdin			(pwdin),
.pwd_len		(pwd_len),
.rd_thd			(rd_thd),
.scr			(scr),
.sel_mmc		(sel_mmc),
.sresetm_b		(sresetm_b),

.dtbuf_raddr		(dtbuf_raddr),
.dtbuf_rdata		(dtbuf_rdata),
.dtbuf_waddr		(dtbuf_waddr),
.dtbuf_wdata		(dtbuf_wdata),
.dtbuf_wren		(dtbuf_wren)

);

eu_dpramx2 #(10, 32) dtbuf(
.raddr			(dtbuf_raddr),
.rclk			(sdclk),
.rdata			(dtbuf_rdata),
.waddr			(dtbuf_waddr),
.wclk			(sdclk),
.wdata			(dtbuf_wdata),
.we			(dtbuf_wren)
);

endmodule
//
// This code is filtered with these parameters defined
// sdm
// mmc
// mmc_2k
