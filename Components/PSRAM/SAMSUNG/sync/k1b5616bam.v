/*===================================================================
Verilog behavioral model of Synchronous Burst UtRAM
(K1B5616BAM, K1B5616BBM)

Revision	: V1.0
date		: Nov. 22. 2003
===================================================================*/

`timescale	1ns / 10ps

//MRS AC characteristics
`define	tCLPLmin	0.0
`define	tPLWLmin	0.0
`define	tWHPHmin	0.0
`define	tPHCHmin	0.0
`define	tDPDmin		500.0

//Asynchronous AC characteristics
`define	tCSHPAmin	10.0
`define	tRCmin		70.0
`define	tPCmin		25.0
`define	tAAmax		70.0
`define	tPAmax		20.0
`define	tCOmax		70.0
`define	tOEmax		35.0
`define	tBAmax		35.0
`define	tLZmin		5.0
`define	tBLZmin		5.0
`define	tOLZmin		5.0
`define	tCHZmin		0.0
`define	tCHZmax		12.0
`define	tBHZmin		0.0
`define	tBHZmax		12.0
`define	tOHZmin		0.0
`define	tOHZmax		10.0
`define	tOHmin		5.0
`define	tWCmin		70.0
`define	tCWmin		60.0
`define	tADVmin		7.0
`define	tASmin		0.0
`define	tASAmin		0.0
`define	tAHAmin		7.0
`define	tCSSAmin	10.0
`define	tAWmin		60.0
`define	tBWmin		60.0
`define	tWPmin		55.0
`define	tWHPmin		5.0
`define	tWRmin		0.0
`define	tDWmin		30.0
`define	tDHmin		0.0

//Synchronous AC characteristics
`define	Tmin_F4		15.0
`define	Tmin_F5		12.5
`define	Tmin_F6		11.0
`define	Tmin_F7		9.6
`define	Tmin_V2		15.0
`define	Tmin_V3		12.5
`define	Tmin_V4		9.6
`define	Tmax		200.0
`define	tBCmax		1200.0
`define	tASBmin		3.0
`define	tAHBmin		2.0
`define	tADVSmin	3.0
`define	tADVHmin	2.0
`define	tCSSBmin	3.0
`define	tBEADVmin	0.0
`define	tBSADVmin	0.0
`define	tCSLHmin	3.0
`define	tCSHPmin	5.0
`define	tWLmax_F4	10.0
`define	tWLmax_F5	10.0
`define	tWLmax_F6	10.0
`define	tWLmax_F7	10.0
`define	tWLmax_V2	10.0
`define	tWLmax_V3	10.0
`define	tWLmax_V4	10.0
`define	tWHmax_F4	10.0
`define	tWHmax_F5	8.0
`define	tWHmax_F6	8.0
`define	tWHmax_F7	7.0
`define	tWHmax_V2	10.0
`define	tWHmax_V3	8.0
`define	tWHmax_V4	7.0
`define	tWZmax		7.0
`define	tBELmin		1	//clock
`define	tOELmin		1	//clock
`define	tBLZmin		5.0
`define	tOLZmin		5.0
`define	tCDmax_F4	10.0
`define	tCDmax_F5	8.0
`define	tCDmax_F6	8.0
`define	tCDmax_F7	7.0
`define	tCDmax_V2	10.0
`define	tCDmax_V3	8.0
`define	tCDmax_V4	7.5
`define	tOHBmin		2.0
`define	tHZmax		8.0
`define	tWESmin		3.0
`define	tWEHmin		2.0
`define	tBSmin		3.0
`define	tBHmin		2.0
`define	tBMSmin		3.0
`define	tBMHmin		2.0
`define	tDSmin		3.0
`define	tDHCmin		2.0

`define	MEGA		1048576
`define	ADDR_TOP	23
`define	INITIAL		-100
`define	FIX	1'b0
`define	VAR	1'b1
`define	FULL_DS	2'b00
`define	HALF_DS	2'b01
`define	QUAR_DS	2'b10
`define	MODE1	2'b00
`define	MODE2	2'b01
`define	MODE3	2'b10
`define	LOW_EN	1'b0
`define	HIGH_EN	1'b1
`define	WRAP	1'b0
`define	NOWRAP	1'b1
`define	ONE_CLK 1'b0
`define	AT_DATA 1'b1
`define	DPD_EN	1'b0
`define	DPD_DI	1'b1
`define	PAR_EN	1'b0
`define	PAR_DI	1'b1
`define	BOT_A	1'b0
`define	TOP_A	1'b1
`define	FULL_A	2'b00
`define	HALF_A	2'b10
`define	QUAR_A	2'b11
`define	MARGIN	0.01
`define	tPWRUP	200000

module K1B5616B2M(clk, advb, psb, csb, oeb, web, addr, io, ubb, lbb, waitb, wrst_latb);
input	clk, advb, psb, csb, oeb, web, ubb, lbb, wrst_latb;
output	waitb;
input	[`ADDR_TOP:0]	addr;
inout	[15:0]	io;

reg	waitb;
reg	[15:0]	mem	[16*`MEGA-1:0];
reg	IL, WP, WM, WC, DPD, PAR, PARA, nowrap_disable;
reg	[1:0]	DS, MS, PARS;
reg	MRS_MODE, AWRITE_MODE, SWRITE_MODE, SWRITE_MODE_D, SREAD_MODE, SREAD_MODE_D, PAGE_MODE, 
	DPD_MODE, PAR_MODE, DPD_EXT, ADVB_LOW, BURSTOP_MODE;
reg	[1:0]	AREAD_MODE_CSB, AREAD_MODE_ADDR, AREAD_MODE_OEB, AREAD_MODE_BC,
			SREAD_MODE_CSB, SREAD_MODE_OEB, SREAD_MODE_BC;
reg	[1:0]	byte;
reg	[`ADDR_TOP:0]	addr_ext, addr_prev, addr_int;
reg	[15:0]	data_in, data_tmp, adata_out_csb, adata_out_addr, adata_out_ubblbb, adata_out_oeb, sdata_out;
integer	LAT, BL, burst, latency, smrs_count, CL, burst_freeze_count, init_freeze_count, burst_freeze_count_prev, VLAT;
real	now;
real	tCLK_H, tCLK_H_PREV, tADVB_H, tADVB_L, tPSB_L, tCSB_H, tCSB_L, tLBB_L, tUBB_L,
	tLBB_H, tUBB_H, tWEB_H, tWEB_L, tOEB_L, tADDR, tADDR_INT, tIO;
real	tMRS_ENT, tMRS_EXT, tWRITE_ENT, tWRITE_EXT, tREAD_ENT, tREAD_EXT, tBURST_EXT, tCDmax, tWLmax, tWHmax, tAWLmax;
event	sdata_out_event, waitb_hiz, waitb_low, waitb_low_advb;

initial begin
	$timeformat(-9, 1, " ns", 10);
	waitb = 1'bz;
	now = `INITIAL;
	tCLK_H = `INITIAL;	tCLK_H_PREV = `INITIAL;
	tADVB_H = `INITIAL;	tADVB_L = `INITIAL;	tPSB_L = `INITIAL;	tCSB_H = `INITIAL;
	tCSB_L = `INITIAL;	tLBB_L = `INITIAL;	tUBB_L = `INITIAL;	tLBB_H = `INITIAL;
	tUBB_H = `INITIAL;	tWEB_H = `INITIAL;	tWEB_L = `INITIAL;	tOEB_L = `INITIAL;
	tADDR = `INITIAL;	tIO = `INITIAL;
	tMRS_ENT = `INITIAL;	tMRS_EXT = `INITIAL;	tWRITE_ENT = `INITIAL;	tWRITE_EXT = `INITIAL;
	tREAD_ENT = `INITIAL;	tREAD_EXT = `INITIAL;	tBURST_EXT = `INITIAL;
	DS = `FULL_DS;	MS = `MODE1;	IL = `FIX;	WP = `LOW_EN;	WM = `WRAP;	
	LAT = 5; WC = `ONE_CLK;	BL = 16;	DPD = `DPD_EN;	PAR = `PAR_EN;
	PARA = `BOT_A;	PARS = `FULL_A;
	MRS_MODE = 0;	AWRITE_MODE = 0;	SWRITE_MODE = 0;	SWRITE_MODE_D = 0;
	SREAD_MODE = 0;	SREAD_MODE_D = 0;	PAGE_MODE = 0;	DPD_MODE = 0;	PAR_MODE = 0;	DPD_EXT = 0;	
	ADVB_LOW = 0;	BURSTOP_MODE = 0;
	AREAD_MODE_CSB = 0;	AREAD_MODE_ADDR = 0;	AREAD_MODE_OEB = 0;	AREAD_MODE_BC = 0;
	SREAD_MODE_CSB = 0;	SREAD_MODE_OEB = 0;	SREAD_MODE_BC = 0;
	smrs_count = 0;	nowrap_disable = 0;
end

/////////////////////////////////
//Power-up sequence
/////////////////////////////////
always @(csb or psb) begin
	now = $realtime;
	`ifdef PWRUP_SKIP
	`else
		if (now < `tPWRUP-`MARGIN) begin
			if (csb === 1'b0 || psb === 1'b0) begin
				$display("Error, after power-up, wait 200us with CSB and MRSB high at %t", now);
			end
		end
	`endif
	#`MARGIN;
	if (DPD_EXT == 1) begin
		$display("Error, after deep power down exit, wait 200us with CSB and MRSB high at %t", now);
	end
end

/////////////////////////////////
//Mode register set
/////////////////////////////////
always @(negedge csb or negedge web or negedge lbb or negedge ubb or negedge psb) begin
	if (DPD_MODE != 1 && PAR_MODE != 1) begin
		now = $realtime;
		#(`MARGIN*2);
		if ({csb, ubb, lbb, web, psb} === 5'b00000) begin
			if (now - tWRITE_ENT < `tWPmin-`MARGIN || now - tMRS_ENT < `tWPmin-`MARGIN) begin
				$display("Error, tWPmin violation at %t", now);
			end
			//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
				//$display("Error, tRCmin violation at %t", now);
			//end
			if (now - tADDR < `tASmin-`MARGIN || now - tADVB_L < `tASmin-`MARGIN) begin
				$display("Error, tASmin violation at %t", now);
			end
			if (now - tPSB_L < `tPLWLmin-`MARGIN) begin
				$display("Error, tPLWL violation at %t", now);
			end
			if (now - tCSB_L < `tCLPLmin-`MARGIN) begin
				$display("Error, tCLPL violation at %t", now);
			end
			$display("Mode Register Set at %t", now);
			tMRS_ENT = now;
			MRS_MODE = 1;
			mrs(addr);
			smrs_count = 0;
		end
	end
end
always @(posedge csb or posedge web or posedge lbb or posedge ubb or posedge psb) begin
	if (MRS_MODE == 1) begin
		now = $realtime;
		if (now - tCSB_L < `tCWmin-`MARGIN) begin
			$display("Error, tCWmin violation at %t", now);
		end
		if (now - tADDR < `tAWmin-2*`MARGIN) begin
			$display("Error, tAWmin violation at %t", now);
		end
		if (now - tLBB_L < `tBWmin-`MARGIN || now - tUBB_L < `tBWmin-`MARGIN) begin
			$display("Error, tBWmin violation at %t", now);
		end
		if (now - tWEB_L < `tWPmin-`MARGIN) begin
			$display("Error, tWPmin violation at %t", now);
		end
		MRS_MODE = 0;
		tMRS_EXT = now;
	end
end
always @(addr) begin
	now = $realtime;
	#`MARGIN;
	if (MRS_MODE == 1) begin
		$display("Error, not allowed address toggle during mrs op. at %t", now);
	end
	if (AWRITE_MODE == 1) begin
		if (MS == `MODE1) begin
			$display("Error, not allowed address toggle during write op. at %t", now);
		end
		else if (MS == `MODE2) begin
			if (now - tADVB_H < `tAHAmin-`MARGIN) begin
				$display("Error, tAH(A)min violation at %t", now);
			end
		end
	end
	if (SWRITE_MODE == 1 && MS == `MODE3) begin
		if (now - tCLK_H < `tAHBmin-`MARGIN) begin
			$display("Error, tAH(B)min violation at %t", now);
		end
	end
	if (SREAD_MODE == 1 && (MS == `MODE2 || MS == `MODE3)) begin
		if (now - tCLK_H < `tAHBmin-`MARGIN) begin
			$display("Error, tAH(B)min violation at %t", now);
		end
	end
	if (ADVB_LOW == 1) begin
		if (MS == `MODE2 || MS == `MODE3) begin
			$display("Error, not allowed address toggle during ADVB=low period at %t", now);
		end
	end
	if (now - tWRITE_EXT < `tWRmin-`MARGIN) begin
		$display("Error, tWRmin violation at %t", now);
	end
	if (now - tMRS_EXT < `tWRmin-`MARGIN) begin
		$display("Error, tWRmin violation at %t", now);
	end
end
always @(posedge psb) begin
	now = $realtime;
	if (now - tMRS_EXT < `tWHPHmin-`MARGIN) begin
		$display("Error, tWHPHmin violation at %t", now);
	end
end
always @(posedge csb) begin
	now = $realtime;
	if (now - tMRS_EXT < `tPHCHmin-`MARGIN) begin
		$display("Error, tPHCHmin violation at %t", now);
	end
end
always @(posedge advb) begin
	now = $realtime;
	#`MARGIN;
	if (MS == `MODE2 || MS == `MODE3) begin
		if (AWRITE_MODE == 1) begin
			if (now - tCSB_L < `tCSSAmin-`MARGIN) begin
				$display("Error, tCSS(A)min violation at %t", now);
			end
		end
		else if (SREAD_MODE == 1 || SWRITE_MODE == 1) begin
			if (now - tCLK_H < `tADVHmin-`MARGIN) begin
				$display("Error, tADVHmin violation at %t", now);
			end
		end
		else begin
			if (now - tWRITE_EXT < `tWRmin-`MARGIN) begin
				$display("Error, tWRmin violation at %t", now);
			end
		end
	end
	else begin
		if (now - tADVB_L < `tADVmin-`MARGIN) begin
			$display("Error, tADVmin violation at %t", now);
		end
	end
end
always @(negedge advb) begin
	if (MS == `MODE2 || MS == `MODE3) begin
		now = $realtime;
		#`MARGIN;
		if (now - tADDR < `tASAmin-`MARGIN) begin
			$display("Error, tAS(A)min violation at %t", now);
		end
		if (now - tBURST_EXT < `tBEADVmin-`MARGIN) begin
			$display("Error, tBEADVmin violation at %t", now);
		end
	end
end
always @(negedge web) begin
	now = $realtime;
	if (now - tWEB_H < `tWHPmin-`MARGIN) begin
		$display("Error, tWHPmin violation at %t", now);
	end
end
	
/////////////////////////////////
//Assign address when advb=low in sync-mode
/////////////////////////////////
always @(negedge advb or negedge csb or posedge psb) begin
	now = $realtime;
	if (MS == `MODE2 || MS == `MODE3) begin
		if ({advb, csb, psb} === 3'b001) begin
			tADDR_INT = now;
			#(`MARGIN*1);
			addr_ext = addr;
			#(`MARGIN*1);
			ADVB_LOW = 1;
		end
	end
end
always @(posedge advb or posedge csb) begin
	if (MS == `MODE2 || MS == `MODE3) begin
		ADVB_LOW = 0;
	end
end

/////////////////////////////////
//Async write in AREAD_AWRITE or SREAD_AWRITE
/////////////////////////////////
always @(negedge csb or negedge web or negedge lbb or negedge ubb) begin
	now = $realtime;
	#(`MARGIN*2);
	if (MS == `MODE1 || MS == `MODE2) begin
		if ({csb, web, psb} === 3'b001) begin
			if (now - tWRITE_ENT < `tWPmin-`MARGIN || now - tMRS_ENT < `tWPmin-`MARGIN) begin
				$display("Error, tWPmin violation at %t", now);
			end
			//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
				//$display("Error, tRCmin violation at %t", now);
			//end
			if (now - tADDR < `tASmin-`MARGIN) begin
				$display("Error, tASmin violation at %t", now);
			end
			$display("Async write at %t", now);
			byte = {ubb, lbb};
			if (MS == `MODE1) addr_ext = addr;
			AWRITE_MODE = 1;
			tWRITE_ENT = now;
			smrs_count = 0;
			disable waitb_hiz_blk;
			disable waitb_low_blk;
			disable waitb_low_advb_blk;
			waitb <= #`MARGIN 1'bx;
			waitb <= #`tWZmax 1'bz;
			disable read_csb;
			disable read_addr;
			disable read_lbb;
			disable read_ubb;
			disable read_oeb;
		end
	end
end
always @(posedge csb or posedge web or posedge lbb or posedge ubb) begin
	if (AWRITE_MODE == 1) begin
		now = $realtime;
		if (now - tCSB_L < `tCWmin-`MARGIN) begin
			$display("Error, tCWmin violation at %t", now);
		end
		if (MS == `MODE1) begin
			if (now - tADDR < `tAWmin-2*`MARGIN) begin
				$display("Error, tAWmin violation at %t", now);
			end
		end
		else begin
			if (now - tADDR_INT < `tAWmin-2*`MARGIN) begin
				$display("Error, tAWmin violation at %t", now);
			end
		end
		if (now - tLBB_L < `tBWmin-`MARGIN || now - tUBB_L < `tBWmin-`MARGIN) begin
			$display("Error, tBWmin violation at %t", now);
		end
		if (now - tWEB_L < `tWPmin-`MARGIN) begin
			$display("Error, tWPmin violation at %t", now);
		end
		if (now - tIO < `tDWmin-`MARGIN) begin
			$display("Error, tDWmin violation at %t", now);
		end
		$display("\taddress is %b", addr_ext);
		$display("\tdata-in is %b", data_in);
		data_tmp = mem[addr_ext];
		if (byte[1] === 1'b0) data_tmp[15:8] = data_in[15:8];
		if (byte[0] === 1'b0) data_tmp[7:0] = data_in[7:0];
		mem[addr_ext] = data_tmp;
		AWRITE_MODE = 0;
		tWRITE_EXT = now;
	end
end
always @(io) begin
	now = $realtime;
	if (MS == `MODE3 && SWRITE_MODE == 1) begin
		if ((IL == `FIX && latency >= LAT-CL) || (IL == `VAR && latency >= LAT)) begin
			if (now - tCLK_H < `tDHCmin-`MARGIN) begin
				$display("Error, tDH(B)min violation at %t", now);
			end
		end
	end
	else begin
		if (now - tWRITE_EXT < `tDHmin-`MARGIN) begin
			$display("Error, tDH(A)min violation at %t", now);
		end
	end
end

/////////////////////////////////
//Async read in Async_Read_Async_Write
/////////////////////////////////
assign	io[15:8] = (AREAD_MODE_CSB[1])? adata_out_csb[15:8]:8'bz;
assign	io[15:8] = (AREAD_MODE_ADDR[1])? adata_out_addr[15:8]:8'bz;
assign	io[15:8] = (AREAD_MODE_BC[1])? adata_out_ubblbb[15:8]:8'bz;
assign	io[15:8] = (AREAD_MODE_OEB[1])? adata_out_oeb[15:8]:8'bz;
assign	io[7:0] = (AREAD_MODE_CSB[0])? adata_out_csb[7:0]:8'bz;
assign	io[7:0] = (AREAD_MODE_ADDR[0])? adata_out_addr[7:0]:8'bz;
assign	io[7:0] = (AREAD_MODE_BC[0])? adata_out_ubblbb[7:0]:8'bz;
assign	io[7:0] = (AREAD_MODE_OEB[0])? adata_out_oeb[7:0]:8'bz;
always @(negedge csb or addr or posedge web or posedge psb) begin
	if (MS == `MODE1 && {psb, csb, web} === 3'b101) begin
		now = $realtime;
		if (PAGE_MODE == 1) begin
			if (now - tREAD_ENT < `tPCmin-`MARGIN) begin
				$display("Error, tPCmin violation at %t", now);
			end
		end
		else begin
			//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
				//$display("Error, tRCmin violation at %t", now);
			//end
		end
		if (now - tWRITE_ENT < `tWPmin-`MARGIN || now - tMRS_ENT < `tWPmin-`MARGIN) begin
			$display("Error, tWPmin violation at %t", now);
		end
		$display("Async read at %t", now);
		$display("\taddress is %b", addr);
		if (addr === 24'b1111_1111111111_1111111111) smrs_count = (smrs_count == 3)? 3 : smrs_count+1;
		else if (addr === 24'b1111_1111111111_1011111111) smrs_count = (smrs_count == 3)? 4 : 0;
		else if (smrs_count == 4) begin
			mrs(addr);
			smrs_count = 0;
		end
		else smrs_count = 0;
		tREAD_ENT = now;
		disable upper_hiz_blk;
		disable lower_hiz_blk;
	end
end
always @(negedge csb or posedge web or posedge psb) begin : read_csb
	#`MARGIN;
	if (MS == `MODE1 && {psb, csb, web} === 3'b101) begin
		if (oeb === 1'b0) begin
			if (ubb === 1'b0) begin
				AREAD_MODE_CSB[1] <= #(`tLZmin-`MARGIN) 1;
			end
			if (lbb === 1'b0) begin
				AREAD_MODE_CSB[0] <= #(`tLZmin-`MARGIN) 1;
			end
		end
		data_tmp = mem[addr];
		//disable read_addr;
		//disable read_ubb;
		//disable read_lbb;
		//disable read_oeb;
		adata_out_csb <= 16'bx;
		adata_out_csb <= #(`tCOmax-`MARGIN) data_tmp;
	end
end
always @(addr) begin : read_addr
	#`MARGIN;
	if (MS == `MODE1 && {psb, csb, web} === 3'b101) begin
		AREAD_MODE_CSB <= #(`tOHmin-`MARGIN) 2'b0;
		AREAD_MODE_OEB <= #(`tOHmin-`MARGIN) 2'b0;
		AREAD_MODE_BC <= #(`tOHmin-`MARGIN) 2'b0;
		if (oeb === 1'b0) begin
			if (ubb === 1'b0) begin
				AREAD_MODE_ADDR[1] <= #(`tOHmin-`MARGIN) 1;
			end
			if (lbb === 1'b0) begin
				AREAD_MODE_ADDR[0] <= #(`tOHmin-`MARGIN) 1;
			end
		end
		//#`MARGIN;
		data_tmp = mem[addr];
		//disable read_csb;
		//disable read_ubb;
		//disable read_lbb;
		//disable read_oeb;
		adata_out_addr <= #(`tOHmin-`MARGIN) 16'bx;
		if (addr_prev[`ADDR_TOP:2] === addr[`ADDR_TOP:2]) begin
			PAGE_MODE = 1;
			adata_out_addr <= #(`tPAmax-`MARGIN) data_tmp;
		end
		else begin
			PAGE_MODE = 0;
			adata_out_addr <= #(`tAAmax-`MARGIN) data_tmp;
		end
	end
end
always @(negedge ubb) begin : read_ubb
	if (MS == `MODE1 && {psb, csb, web, oeb} === 4'b1010) begin
		AREAD_MODE_BC[1] <= #`tBLZmin 1;
		data_tmp = mem[addr];
		//disable read_csb;
		//disable read_addr;
		//disable read_lbb;
		//disable read_oeb;
		adata_out_ubblbb[15:8] <= 8'bx;
		adata_out_ubblbb[15:8] <= #`tBAmax data_tmp[15:8];
	end
	else if ((MS == `MODE2 || MS == `MODE3) && SREAD_MODE == 1) begin
		if (oeb === 1'b0) begin
			disable sdout_ub_blk;
			sdata_out[15:8] <= 8'bx;
			SREAD_MODE_BC[1] <= #`tBLZmin 1;
		end
	end
end
always @(negedge lbb) begin : read_lbb
	if (MS == `MODE1 && {psb, csb, web, oeb} === 4'b1010) begin
		AREAD_MODE_BC[0] <= #`tBLZmin 1;
		data_tmp = mem[addr];
		//disable read_csb;
		//disable read_addr;
		//disable read_ubb;
		//disable read_oeb;
		adata_out_ubblbb[7:0] <= 8'bx;
		adata_out_ubblbb[7:0] <= #`tBAmax data_tmp[7:0];
	end
	else if ((MS == `MODE2 || MS == `MODE3) && SREAD_MODE == 1) begin
		if (oeb === 1'b0) begin
			disable sdout_lb_blk;
			sdata_out[7:0] <= 8'bx;
			SREAD_MODE_BC[0] <= #`tBLZmin 1;
		end
	end
end
always @(negedge oeb) begin : read_oeb
	if (MS == `MODE1 && {psb, csb, web} === 3'b101) begin
		data_tmp = mem[addr];
		//disable read_csb;
		//disable read_addr;
		//disable read_lbb;
		//disable read_ubb;
		adata_out_oeb <= 16'bx;
		if (ubb === 1'b0) begin
			AREAD_MODE_OEB[1] <= #`tOLZmin 1;
			adata_out_oeb[15:8] <= #`tOEmax data_tmp[15:8];
		end
		if (lbb === 1'b0) begin
			AREAD_MODE_OEB[0] <= #`tOLZmin 1;
			adata_out_oeb[7:0] <= #`tOEmax data_tmp[7:0];
		end
	end
	else if ((MS == `MODE2 || MS == `MODE3) && SREAD_MODE == 1) begin
		if (ubb === 1'b0) begin
			disable sdout_ub_blk;
			sdata_out[15:8] <= 8'bx;
			SREAD_MODE_OEB[1] <= #`tOLZmin 1;
		end
		if (lbb === 1'b0) begin
			disable sdout_lb_blk;
			sdata_out[7:0] <= 8'bx;
			SREAD_MODE_OEB[0] <= #`tOLZmin 1;
		end
	end
end
always @(posedge ubb) begin
	if ((MS == `MODE2 || MS == `MODE3) && SREAD_MODE == 1) begin
		disable sdout_ub_blk;
		sdata_out[15:8] <= 8'bx;
		SREAD_MODE_CSB[1] <= #`tBHZmax 1'b0;
		SREAD_MODE_OEB[1] <= #`tBHZmax 1'b0;
		SREAD_MODE_BC[1] <= #`tBHZmax 1'b0;
	end
end
always @(posedge lbb) begin
	if ((MS == `MODE2 || MS == `MODE3) && SREAD_MODE == 1) begin
		disable sdout_lb_blk;
		sdata_out[7:0] <= 8'bx;
		SREAD_MODE_CSB[0] <= #`tBHZmax 1'b0;
		SREAD_MODE_OEB[0] <= #`tBHZmax 1'b0;
		SREAD_MODE_BC[0] <= #`tBHZmax 1'b0;
	end
end
always @(posedge oeb) begin
	if ((MS == `MODE2 || MS == `MODE3) && SREAD_MODE == 1) begin
		disable sdout_ub_blk;
		disable sdout_lb_blk;
		sdata_out <= 16'bx;
		SREAD_MODE_CSB <= #`tOHZmax 2'b0;
		SREAD_MODE_OEB <= #`tOHZmax 2'b0;
		SREAD_MODE_BC <= #`tOHZmax 2'b0;
	end
end
always @(posedge csb or negedge web) begin
	if (MS == `MODE1) begin
		now = $realtime;
		//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
			//$display("Error, tRCmin violation at %t", now);
		//end
		PAGE_MODE = 0;
	end
end
always @(posedge ubb or posedge csb or negedge web or posedge oeb or negedge psb) begin : upper_hiz_blk
	//disable read_csb;
	//disable read_addr;
	//disable read_lbb;
	//disable read_ubb;
	//disable read_oeb;
	adata_out_csb <= #`tOHmin 16'bx;
	adata_out_addr <= #`tOHmin 16'bx;
	adata_out_ubblbb <= #`tOHmin 16'bx;
	adata_out_oeb <= #`tOHmin 16'bx;
	AREAD_MODE_CSB[1] <= #`tCHZmax 0;
	AREAD_MODE_ADDR[1] <= #`tCHZmax 0;
	AREAD_MODE_OEB[1] <= #`tOHZmax 0;
	AREAD_MODE_BC[1] <= #`tBHZmax 0;
end
always @(posedge lbb or posedge csb or negedge web or posedge oeb or negedge psb) begin : lower_hiz_blk
	//disable read_csb;
	//disable read_addr;
	//disable read_lbb;
	//disable read_ubb;
	//disable read_oeb;
	adata_out_csb <= #`tOHmin 16'bx;
	adata_out_addr <= #`tOHmin 16'bx;
	adata_out_ubblbb <= #`tOHmin 16'bx;
	adata_out_oeb <= #`tOHmin 16'bx;
	AREAD_MODE_CSB[0] <= #`tCHZmax 0;
	AREAD_MODE_ADDR[0] <= #`tCHZmax 0;
	AREAD_MODE_OEB[0] <= #`tOHZmax 0;
	AREAD_MODE_BC[0] <= #`tBHZmax 0;
end

/////////////////////////////////
//Clock cycle time
/////////////////////////////////
always @(posedge clk) begin
	now = $realtime;
	if (SREAD_MODE_D == 1 || SWRITE_MODE_D == 1) begin
		if (IL == `FIX) begin
			case(LAT)
			'd4: begin
				if (now - tCLK_H_PREV < `Tmin_F4-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			'd5: begin
				if (now - tCLK_H_PREV < `Tmin_F5-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			'd6: begin
				if (now - tCLK_H_PREV < `Tmin_F6-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			'd7: begin
				if (now - tCLK_H_PREV < `Tmin_F7-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			endcase
		end
		else begin
			case(LAT)
			'd2: begin
				if (now - tCLK_H_PREV < `Tmin_V2-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			'd3: begin
				if (now - tCLK_H_PREV < `Tmin_V3-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			'd4: begin
				if (now - tCLK_H_PREV < `Tmin_V4-`MARGIN) begin
					$display("Error, Tmin violation at %t", now);
				end
			end
			endcase
		end
		if (now - tCLK_H_PREV > `Tmax+`MARGIN) begin
			if (tCLK_H_PREV != `INITIAL) begin
				$display("Error, Tmax violation at %t", now);
			end
		end
	end
end

/////////////////////////////////
//Sync write
/////////////////////////////////
always @(posedge clk) begin : sync_write
	if (MS == `MODE3) begin
		now = $realtime;
		if ({psb, advb, csb, web} === 4'b1000) begin
			//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
				//$display("Error, tRCmin violation at %t", now);
			//end
			//if (now - tWRITE_ENT < `tWPmin-`MARGIN || now - tMRS_ENT < `tWPmin-`MARGIN) begin
				//$display("Error, tWPmin violation at %t", now);
			//end
			if (now - tADVB_L < `tADVSmin-`MARGIN) begin
				$display("Error, tADVSmin violation at %t", now);
			end
			if (now - tCSB_L < `tCSSBmin-`MARGIN) begin
				$display("Error, tCSSBmin violation at %t", now);
			end
			if (now - tWEB_L < `tWESmin-`MARGIN) begin
				$display("Error, tWESmin violation at %t", now);
			end
			if (now - tADDR < `tASBmin-2*`MARGIN) begin
				$display("Error, tAS(B)min violation at %t", now);
			end
			$display("Sync write at %t", now);
			$display("\taddress is %b", addr);
			smrs_count = 0;
			tWRITE_ENT = now;
			SWRITE_MODE = 1;
			SWRITE_MODE_D <= #`MARGIN 1;
			SREAD_MODE = 0;
			SREAD_MODE_D <= #`MARGIN 0;
			SREAD_MODE_CSB <= #`tCHZmax 2'b0;
			SREAD_MODE_OEB <= #`tOHZmax 2'b0;
			SREAD_MODE_BC <= #`tBHZmax 2'b0;
			sdata_out <= #`tOHBmin 16'bx;
			burst = 0;
			burst_freeze_count = 0;
			burst_freeze_count_prev <= #`MARGIN 0;
			latency = 0;
			addr_int = addr_ext;
			disable waitb_low_blk;
			disable waitb_low_advb_blk;
			if (IL == `FIX && LAT == 3) begin
				waitb <= 1'bx;
				waitb <= #tWHmax 1'b1 ^ WP;
			end
			else begin
				waitb <= 1'bx;
				waitb <= #tWLmax 1'b0 ^ WP;
			end
			if (WM == `WRAP || 
				(BL == 4 && (addr_ext[7:0] == 8'hfc || addr_ext[7:0] == 8'hfb)) ||
				(BL == 8 && (addr_ext[7:0] == 8'hf8 || addr_ext[7:0] == 8'hf7)) ||
				(BL == 16 && (addr_ext[7:0] == 8'hf0 || addr_ext[7:0] == 8'hef)) ||
				(BL == 32 && (addr_ext[7:0] == 8'he0 || addr_ext[7:0] == 8'hdf)))
				nowrap_disable = 1;
			else nowrap_disable = 0;
		end
		else if (SWRITE_MODE_D == 1 && {psb, advb, csb} === 4'b110) begin
			if ((IL == `FIX && latency >= LAT-CL) || (IL == `VAR && latency >= LAT)) begin
				if (burst != BL) begin
					if (now - tUBB_L < `tBSmin-`MARGIN || now - tLBB_L < `tBSmin-`MARGIN) begin
						$display("Error, tBSmin violation at %t", now);
					end
					if (now - tUBB_H < `tBMSmin-`MARGIN || now - tLBB_H < `tBMSmin-`MARGIN) begin
						$display("Error, tBMSmin violation at %t", now);
					end
					if (now - tUBB_H < `tBMSmin-`MARGIN || now - tLBB_H < `tBMSmin-`MARGIN) begin
						$display("Error, tBMSmin violation at %t", now);
					end
					if (now - tIO < `tDSmin-`MARGIN) begin
						$display("Error, tDSmin violation at %t", now);
					end
					addr_int = linear(addr_ext, burst);
					data_tmp = mem[addr_int];
					if (ubb === 1'b0) data_tmp[15:8] = data_in[15:8];
					if (lbb === 1'b0) data_tmp[7:0] = data_in[7:0];
					if (burst_freeze_count == 0) begin //PBTX16
						mem[addr_int] = data_tmp;
					end
					$display("\tdata-in is %b", data_in);

					if (WM == `NOWRAP) begin
						if (addr_int[7:0] == 8'hff && burst_freeze_count == 0 && nowrap_disable == 0) begin
							if (IL == `FIX) init_freeze_count = (CL==2)? LAT : LAT-1;
							else init_freeze_count = (LAT < 4)? LAT-CL+2+2 : LAT-CL+2+3;
							burst_freeze_count = init_freeze_count;
						end
						if (burst_freeze_count > 0) burst_freeze_count = burst_freeze_count - 1;
						//burst_freeze_count_prev <= #`MARGIN burst_freeze_count;
						burst_freeze_count_prev <= @(posedge clk) burst_freeze_count;
					end
					if (burst_freeze_count == 0) burst = burst + 1;
				end
				else if (burst == BL) begin
					//if (now - tWRITE_ENT < `tWCmin-`MARGIN) begin
						//$display("Error, tWCmin violation at %t", now);//ADVB burst stop
					//end
					tWRITE_EXT = now;
					tBURST_EXT = now;
					SWRITE_MODE = 0;
					SWRITE_MODE_D = 0;
				end
			end
	if (IL == `FIX) begin
			if ((WC == `ONE_CLK && latency == LAT-CL-2) ||
				(WC == `AT_DATA && latency == LAT-CL-1)) begin
				waitb <= 1'bx;
				waitb <= #tWHmax 1'b1 ^ WP;
			end
			else if (nowrap_disable == 0) begin
				if (addr_ext[7:0] == 8'hff) begin
					if ((WC == `ONE_CLK && latency == LAT-CL-1) ||
						(WC == `AT_DATA && latency == LAT-CL)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				else if (addr_ext[7:0] == 8'hfe) begin
					if ((WC == `ONE_CLK && latency == LAT-CL) ||
						(WC == `AT_DATA && latency == LAT-CL+1)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				else if (WC == `ONE_CLK && addr_ext[7:0] == 8'hfd) begin
					if (latency == LAT-CL+1) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				if ((WC == `ONE_CLK && addr_int[7:0] == 8'hfe && ~(addr_ext[7:0] == 8'hfe && latency < LAT)) ||
					(WC == `AT_DATA && addr_int[7:0] == 8'hff && burst_freeze_count == init_freeze_count-1)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
				end
				if ((WC == `ONE_CLK && burst_freeze_count == 1) ||
					(WC == `AT_DATA && burst_freeze_count == 0 && burst_freeze_count_prev == 2)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b1 ^ WP;
				end
			end
	end
	if (IL == `VAR) begin
			if ((WC == `ONE_CLK && latency == LAT-2) ||
				(WC == `AT_DATA && latency == LAT-1)) begin
				waitb <= 1'bx;
				waitb <= #tWHmax 1'b1 ^ WP;
			end
			else if (nowrap_disable == 0) begin
				if (addr_ext[7:0] == 8'hff) begin
					if ((WC == `ONE_CLK && latency == LAT-1) ||
						(WC == `AT_DATA && latency == LAT))begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				else if (addr_ext[7:0] == 8'hfe) begin
					if ((WC == `ONE_CLK && latency == LAT) ||
						(WC == `AT_DATA && latency == LAT+1)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				else if (WC == `ONE_CLK && addr_ext[7:0] == 8'hfd) begin
					if (latency == LAT+1) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				if ((WC == `ONE_CLK && addr_int[7:0] == 8'hfe && ~(addr_ext[7:0] == 8'hfe && latency < LAT)) ||
					(WC == `AT_DATA && addr_int[7:0] == 8'hff && burst_freeze_count == init_freeze_count-1)) begin
					waitb <= 1'bx;
					waitb <= #tWHmax 1'b0 ^ WP;
				end
				if ((WC == `ONE_CLK && burst_freeze_count == 1) ||
					(WC == `AT_DATA && burst_freeze_count == 0 && burst_freeze_count_prev == 2)) begin
					waitb <= 1'bx;
					waitb <= #tWHmax 1'b1 ^ WP;
				end
			end
	end
			latency = latency + 1;
		end
	end
end
always @(posedge web) begin
	if (MS == `MODE3 && SWRITE_MODE == 1) begin
		if (now - tCLK_H < `tWEHmin-`MARGIN) begin
			$display("Error, tWEHmin violation at %t", now);
		end
	end
end
always @(posedge lbb or posedge ubb) begin
	if (MS == `MODE3 && SWRITE_MODE == 1) begin
		if ((IL == `FIX && latency >= LAT-CL) || (IL == `VAR && latency >= LAT)) begin
			if (now - tCLK_H < `tBHmin-`MARGIN) begin
				$display("Error, tBHmin violation at %t", now);
			end
		end
	end
end
always @(negedge lbb or negedge ubb) begin
	if (MS == `MODE3 && SWRITE_MODE == 1) begin
		if ((IL == `FIX && latency >= LAT-CL) || (IL == `VAR && latency >= LAT)) begin
			if (now - tCLK_H < `tBMHmin-`MARGIN) begin
				$display("Error, tBMHmin violation at %t", now);
			end
		end
	end
end
	
/////////////////////////////////
//Sync read
/////////////////////////////////
assign	io[15:8] = (SREAD_MODE_CSB[1])? sdata_out[15:8]:8'bz;
assign	io[15:8] = (SREAD_MODE_BC[1])? sdata_out[15:8]:8'bz;
assign	io[15:8] = (SREAD_MODE_OEB[1])? sdata_out[15:8]:8'bz;
assign	io[7:0] = (SREAD_MODE_CSB[0])? sdata_out[7:0]:8'bz;
assign	io[7:0] = (SREAD_MODE_BC[0])? sdata_out[7:0]:8'bz;
assign	io[7:0] = (SREAD_MODE_OEB[0])? sdata_out[7:0]:8'bz;
always @(posedge clk) begin : sync_read
	if (MS == `MODE3 || MS == `MODE2) begin
		now = $realtime;
		if ({psb, advb, csb, web} === 4'b1001) begin
			//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
				//$display("Error, tRCmin violation at %t", now);
			//end
			//if (now - tWRITE_ENT < `tWPmin-`MARGIN || now - tMRS_ENT < `tWPmin-`MARGIN) begin
				//$display("Error, tWPmin violation at %t", now);
			//end
			if (now - tADVB_L < `tADVSmin-`MARGIN && now != tADVB_L) begin
				$display("Error, tADVSmin violation at %t", now);
			end
			if (now - tCSB_L < `tCSSBmin-`MARGIN && now != tCSB_L) begin
				$display("Error, tCSSBmin violation at %t", now);
			end
			if (now - tWEB_H < `tWESmin-`MARGIN && now != tWEB_H) begin
				$display("Error, tWESmin violation at %t", now);
			end
			if (now - tADDR < `tASBmin-2*`MARGIN) begin
				$display("Error, tAS(B)min violation at %t", now);
			end
			$display("Sync burst read at %t", now);
			$display("\taddress is %b", addr);
			if (addr === 24'b1111_1111111111_1111111111) smrs_count = (smrs_count == 3)? 3 : smrs_count+1;
			else if (addr === 24'b1111_1111111111_1011111111) smrs_count = (smrs_count == 3)? 4 : 0;
			else if (smrs_count == 4) begin
				mrs(addr);
				smrs_count = 0;
			end
			else smrs_count = 0;
			tREAD_ENT = now;
			SREAD_MODE = 1;
			SREAD_MODE_D <= #`MARGIN 1;
			SWRITE_MODE = 0;
			SWRITE_MODE_D <= #`MARGIN 0;
			sdata_out = 16'bx;
			burst = 0;
			burst_freeze_count = 0;
			burst_freeze_count_prev <= #`MARGIN 0;
			latency = 0;
			addr_int = addr_ext;
			disable waitb_low_blk;
			disable waitb_low_advb_blk;
			waitb <= 1'bx;
			waitb <= #tWLmax 1'b0 ^ WP;
			if (WM == `WRAP || 
				(BL== 4 && addr_ext[7:0] == 8'hfc) ||
				(BL == 8 && addr_ext[7:0] == 8'hf8) ||
				(BL == 16 && addr_ext[7:0] == 8'hf0) || 
				(BL == 32 && addr_ext[7:0] == 8'he0))
				nowrap_disable = 1;
			else nowrap_disable = 0;
			if (oeb === 1'b0) begin
				if (ubb === 1'b0) begin
					SREAD_MODE_CSB[1] <= #`tBLZmin 1;
				end
				if (lbb === 1'b0) begin
					SREAD_MODE_CSB[0] <= #`tBLZmin 1;
				end
			end
			#3.0;
			if (IL == `FIX) VLAT = LAT;
			else begin
				VLAT = (~wrst_latb)? (LAT < 4)? LAT+2 : LAT+3 : LAT;
				if (wrst_latb) $display("AC_param : best latency at %t", now);
				else $display("AC_param : worst latency at %t", now);
			end
		end
		else if ((SREAD_MODE_D == 1 && {psb, advb, csb, web} === 4'b1101 && MS == `MODE2)
				|| (SREAD_MODE_D == 1 && {psb, advb, csb} === 3'b110 && MS == `MODE3)) begin
			if ((IL == `FIX && latency >= LAT-1) || (IL == `VAR && latency >= VLAT-1)) begin
				if (burst != BL) begin
					sdata_out <= #`tOHBmin 16'bx;
					addr_int = linear(addr_ext, burst);
					if (burst_freeze_count == 0) begin
						data_tmp = mem[addr_int];
					end
					if (now - tUBB_L < (now-tCLK_H_PREV)*`tBELmin-`MARGIN) begin
						data_tmp[15:8] = 8'bx;
					end
					if (now - tLBB_L < (now-tCLK_H_PREV)*`tBELmin-`MARGIN) begin
						data_tmp[7:0] = 8'bx;
					end
					if (now - tOEB_L < (now-tCLK_H_PREV)*`tOELmin-`MARGIN) begin
						data_tmp = 16'bx;
					end
					->sdata_out_event;

					if (WM == `NOWRAP) begin
						if (addr_int[7:0] == 8'hff && burst_freeze_count == 0 && nowrap_disable == 0) begin
							if (IL == `FIX) init_freeze_count = (CL==2)? LAT : LAT-1;
							else init_freeze_count = (LAT < 4)? LAT-CL+2+2 : LAT-CL+2+3;
							burst_freeze_count = init_freeze_count;
						end
						if (burst_freeze_count > 0) burst_freeze_count = burst_freeze_count - 1;
						//burst_freeze_count_prev <= #`MARGIN burst_freeze_count;
						burst_freeze_count_prev <= @(posedge clk) burst_freeze_count;
					end
					if (burst_freeze_count == 0) burst = burst + 1;
				end
				else if (burst == BL) begin
					//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
						//$display("Error, tRCmin violation at %t", now);
					//end
					tREAD_EXT = now;
					tBURST_EXT = now;
					sdata_out <= #`tOHBmin 16'bx;
					SREAD_MODE = 0;
					SREAD_MODE_D = 0;
					SREAD_MODE_CSB <= #`tHZmax 2'b0;
					SREAD_MODE_BC <= #`tHZmax 2'b0;
					SREAD_MODE_OEB <= #`tHZmax 2'b0;
				end
			end
			if ((WC == `ONE_CLK && latency == VLAT-2) ||
				(WC == `AT_DATA && latency == VLAT-1))begin
				waitb <= 1'bx;
				waitb <= #tWHmax 1'b1 ^ WP;
			end
			else if (nowrap_disable == 0) begin
				if (addr_ext[7:0] == 8'hff) begin
					if ((WC == `ONE_CLK && latency == VLAT-1) ||
						(WC == `AT_DATA && latency == VLAT)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				else if (addr_ext[7:0] == 8'hfe) begin
					if (WC == `ONE_CLK && latency == VLAT) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				if (addr_int[7:0] == 8'hff) begin
 					if ((WC == `ONE_CLK && burst_freeze_count == init_freeze_count-1) ||
						(WC == `AT_DATA && burst_freeze_count == init_freeze_count-2)) begin
						waitb <= 1'bx;
						waitb <= #tWHmax 1'b0 ^ WP;
					end
				end
				if ((WC == `ONE_CLK && burst_freeze_count == 0 && burst_freeze_count_prev == 2) ||
					(WC == `AT_DATA && burst_freeze_count == 0 && burst_freeze_count_prev == 1)) begin
					waitb <= 1'bx;
					waitb <= #tWHmax 1'b1 ^ WP;
				end
			end
			latency = latency + 1;
		end
	end
end
always @(sdata_out_event) begin : sdout_ub_blk
	if (SREAD_MODE_CSB[1] == 1) begin
		sdata_out[15:8] <= #tCDmax data_tmp[15:8];
	end
	else if (SREAD_MODE_BC[1] == 1) begin
		sdata_out[15:8] <= #tCDmax data_tmp[15:8];
	end
	else if (SREAD_MODE_OEB[1] == 1) begin
		sdata_out[15:8] <= #tCDmax data_tmp[15:8];
	end
end
always @(sdata_out_event) begin : sdout_lb_blk
	if (SREAD_MODE_CSB[0] == 1) begin
		sdata_out[7:0] <= #tCDmax data_tmp[7:0];
	end
	else if (SREAD_MODE_BC[0] == 1) begin
		sdata_out[7:0] <= #tCDmax data_tmp[7:0];
	end
	else if (SREAD_MODE_OEB[0] == 1) begin
		sdata_out[7:0] <= #tCDmax data_tmp[7:0];
	end
end

/////////////////////////////////
//Burst stop(csb)
/////////////////////////////////
always @(posedge csb or negedge psb) begin
	->waitb_hiz;
	//waitb <= 1'bx;
	//waitb <= #`tWZmax 1'bz;
	if (SREAD_MODE == 1) begin
		now = $realtime;
		//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
			//$display("Error, tRCmin violation at %t", now);
		//end
		$display("Read burst stop by CSB=high at %t", now);
		tREAD_EXT = now;
		tBURST_EXT = now;
		sdata_out <= #`tOHBmin 16'bx;
		disable sync_read;
		disable sdout_ub_blk;
		disable sdout_lb_blk;
		SREAD_MODE = 0;
		SREAD_MODE_D = 0;
		SREAD_MODE_CSB <= #`tCHZmax 2'b0;
		SREAD_MODE_OEB <= #`tOHZmax 2'b0;
		SREAD_MODE_BC <= #`tBHZmax 2'b0;
		BURSTOP_MODE = 1;
		if (now - tCLK_H < `tCSLHmin-`MARGIN) begin
			$display("Error, tCSLHmin violation at %t", now);
		end
	end
	else if (SWRITE_MODE == 1) begin
		now = $realtime;
		//if (now - tWRITE_ENT < `tWCmin-`MARGIN) begin
			//$display("Error, tWCmin violation at %t", now);
		//end
		$display("Write burst stop by CSB=high at %t", now);
		tWRITE_EXT = now;
		tBURST_EXT = now;
		disable sync_write;
		SWRITE_MODE = 0;
		SWRITE_MODE_D = 0;
		BURSTOP_MODE = 1;
		if (now - tCLK_H < `tCSLHmin-`MARGIN) begin
			$display("Error, tCSLHmin violation at %t", now);
		end
	end
end
always @(negedge csb) begin
	if (MS == `MODE3) ->waitb_low;
	else if (MS == `MODE2) begin
		if (web == 1'b1) ->waitb_low;
		//else ->waitb_hiz;
	end
	if (BURSTOP_MODE == 1) begin
		now = $realtime;
		BURSTOP_MODE = 0;
		if (now - tCSB_H < `tCSHPmin-`MARGIN) begin
			$display("Error, tCSHPmin violation at %t", now);
		end
	end
	else if (MS == `MODE1) begin
		if (now - tCSB_H < `tCSHPAmin-`MARGIN) begin
			$display("Error, tCSHPAmin violation at %t", now);
		end
	end
end
always @(negedge advb) begin
	if (MS == `MODE3) ->waitb_low_advb;
	else if (MS == `MODE2) begin
		if (web == 1'b1) ->waitb_low_advb;
		//else ->waitb_hiz;
	end
end
always @(waitb_hiz) begin : waitb_hiz_blk
	disable waitb_low_blk;
	disable waitb_low_advb_blk;
	waitb <= 1'bx;
	waitb <= #`tWZmax 1'bz;
end
always @(waitb_low) begin : waitb_low_blk
	disable waitb_hiz_blk;
	disable waitb_low_advb_blk;
	waitb <= 1'bx;
	waitb <= #tWLmax 1'b0 ^ WP;
end
always @(waitb_low_advb) begin : waitb_low_advb_blk
	disable waitb_low_blk;
	disable waitb_hiz_blk;
	waitb <= 1'bx;
	waitb <= #tAWLmax 1'b0 ^ WP;
end

/////////////////////////////////
//Burst stop(web)
/////////////////////////////////
always @(negedge web) begin
	if (SREAD_MODE == 1 && MS == `MODE2) begin
		now = $realtime;
		//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
			//$display("Error, tRCmin violation at %t", now);
		//end
		$display("Read burst stop by WEB=low at %t", now);
		tREAD_EXT = now;
		tBURST_EXT = now;
		sdata_out <= #`tOHBmin 16'bx;
		disable sync_read;
		disable sdout_ub_blk;
		disable sdout_lb_blk;
		SREAD_MODE = 0;
		SREAD_MODE_D = 0;
		//SREAD_MODE_CSB <= #`tCHZmax 2'b0;
		//SREAD_MODE_OEB <= #`tOHZmax 2'b0;
		//SREAD_MODE_BC <= #`tBHZmax 2'b0;
		SREAD_MODE_CSB <= #`tWZmax 2'b0;
		SREAD_MODE_OEB <= #`tWZmax 2'b0;
		SREAD_MODE_BC <= #`tWZmax 2'b0;
	end
end
always @(posedge web) begin
	if (MS == `MODE2) begin
		if ({csb, psb} === 3'b01) ->waitb_low;
	end
end

/////////////////////////////////
//Deep power down & Partial array refresh
/////////////////////////////////
always @(negedge psb) begin : DPD_PAR_blk
	if (csb === 1'b1) begin
		if (DPD == `DPD_EN) begin
			DPD_MODE <= #(`tDPDmin-`MARGIN) 1;
			//#(`tDPDmin-`MARGIN);
			//DPD_MODE = 1;
		end
		else if (DPD == `DPD_DI && PAR == `PAR_EN) begin
			PAR_MODE <= #(`tDPDmin-`MARGIN) 1;
			//#(`tDPDmin-`MARGIN);
			//PAR_MODE = 1;
		end
	end
end
always @(posedge DPD_MODE) begin
	now = $realtime;
	#`MARGIN;
	$display("Deep power down mode is enabled at %t", now);
end
always @(posedge PAR_MODE) begin
	now = $realtime;
	#`MARGIN;
	$display("Partial array refresh is enabled at %t", now);
end
always @(posedge psb) begin
	now = $realtime;
	disable DPD_PAR_blk;
	if (DPD_MODE == 1) begin
		$display("Deep power down mode exit at %t", now);
		DPD_MODE <= #(`MARGIN*2) 0;
		DPD_EXT <= #`tPWRUP 0;
	end
	else if (PAR_MODE == 1) begin
		$display("Partial array refresh exit at %t", now);
		PAR_MODE <= #(`MARGIN*2) 0;
	end
end

/////////////////////////////////
//Store signal toggle time
/////////////////////////////////
always @(clk) begin
	now = $realtime;
	if (clk === 1'b1) begin
		tCLK_H = now;
		tCLK_H_PREV <= #`MARGIN now;
	end
end
always @(advb) begin
	now = $realtime;
	if (csb === 1'b0) begin
		if (advb === 1'b1) tADVB_H = now;
		else if (advb === 1'b0) tADVB_L = now;
	end
end
always @(psb) begin
	now = $realtime;
	if (psb === 1'b0) tPSB_L = now;
end
always @(csb) begin
	now = $realtime;
	if (csb === 1'b1) tCSB_H = now;
	else if (csb === 1'b0) tCSB_L = now;
end
always @(lbb) begin
	now = $realtime;
	if (lbb === 1'b0) tLBB_L = now;
	else if (lbb === 1'b1) tLBB_H = now;
end
always @(ubb) begin
	now = $realtime;
	if (ubb === 1'b0) tUBB_L = now;
	else if (ubb === 1'b1) tUBB_H = now;
end
always @(web) begin
	now = $realtime;
	if (web === 1'b0) tWEB_L = now;
	else if (web === 1'b1) tWEB_H = now;
end
always @(oeb) begin
	now = $realtime;
	if (oeb === 1'b0) tOEB_L = now;
end
always @(addr) begin
	#`MARGIN;
	if (AWRITE_MODE == 0) begin
		now = $realtime;
		tADDR = now;
		addr_prev <= #(`MARGIN*2) addr;
	end
end
always @(io) begin
	if (io !== 16'bz) begin
		now = $realtime;
		tIO = now;
		data_in = io;
	end
end
/////////////////////////////////
//Tasks & Functions
/////////////////////////////////
task mrs;
input	[`ADDR_TOP:0]	addr;
begin
	waitb <= 1'bx;
	//waitb <= #`tRCmin 1'bz;
	case(addr[18])
	1'b0:	begin
		$display("\tInitial Latency : Fixed Read");
		IL = `FIX;
	end
	1'b1:	begin
		$display("\tInitial Latency : Variable Read");
		IL = `VAR;
	end
	default: IL = 'bx;
	endcase
	case(addr[17:16])
	2'b00:	begin
		$display("\tDriver Strength : Full Drive");
		DS = `FULL_DS;
	end
	2'b01:	begin
		$display("\tDriver Strength : 1/2 Drive");
		DS = `HALF_DS;
	end
	2'b10:	begin
		$display("\tDriver Strength : 1/4 Drive");
		DS = `QUAR_DS;
	end
	default: DS = 'bx;
	endcase
	case(addr[15:14])
	2'b00:	begin
		$display("\tMode Select : Mode1\(Async 4 Page Read/Async Write\)");
		MS <= #`tRCmin `MODE1;
	end
	2'b01:	begin
		$display("\tMode Select : Mode2\(Sync Burst Read/Async Write\)");
		MS <= #`tRCmin `MODE2;
	end
	2'b10:	begin
		$display("\tMode Select : Mode3\(Sync Burst Read/Sync Burst Write\)");
		MS <= #`tRCmin `MODE3;
	end
	default: MS = 'bx;
	endcase
	case(addr[13])
	1'b0:	begin
		$display("\tWAITB Polarity : Low Enable");
		WP = `LOW_EN;
	end
	1'b1:	begin
		$display("\tWAITB Polarity : High Enable");
		WP = `HIGH_EN;
	end
	default: WP = 'bx;
	endcase
	case(addr[12])
	1'b0:	begin
		$display("\tWrap : Wrap");
		WM = `WRAP;
	end
	1'b1:	begin
		$display("\tWrap : No wrap");
		WM = `NOWRAP;
	end
	default: WM = 'bx;
	endcase
	case(addr[11:9])
	3'b100:	LAT = 2;
	3'b000:	LAT = 3;
	3'b001:	LAT = 4;
	3'b010:	LAT = 5;
	3'b011:	LAT = 6;
	3'b101:	LAT = 7;
	3'b110:	LAT = 8;
	3'b111:	LAT = 9;
	default: LAT = 'bx;
	endcase
	$display("\tLatency Count : %d", LAT);
	if (IL == `FIX) begin
		CL = (LAT < 7)? (LAT == 2)? 1 : 2 : 3;
		case(LAT)
		'd4: begin
			tCDmax = `tCDmax_F4;
			tWHmax = `tWHmax_F4;
			tWLmax = `tWLmax_F4;
			tAWLmax = `tWLmax_F4;
		end
		'd5: begin
			tCDmax = `tCDmax_F5;
			tWHmax = `tWHmax_F5;
			tWLmax = `tWLmax_F5;
			tAWLmax = `tWLmax_F5;
		end
		'd6: begin
			tCDmax = `tCDmax_F6;
			tWHmax = `tWHmax_F6;
			tWLmax = `tWLmax_F6;
			tAWLmax = `tWLmax_F6;
		end
		'd7: begin
			tCDmax = `tCDmax_F7;
			tWHmax = `tWHmax_F7;
			tWLmax = `tWLmax_F7;
			tAWLmax = `tWLmax_F7;
		end
		endcase
	end
	else begin
		CL = (LAT < 4)? 2 : 3;
		case(LAT)
		'd2: begin
			tCDmax = `tCDmax_V2;
			tWHmax = `tWHmax_V2;
			tWLmax = `tWLmax_V2;
			tAWLmax = `tWLmax_V2;
		end
		'd3: begin
			tCDmax = `tCDmax_V3;
			tWHmax = `tWHmax_V3;
			tWLmax = `tWLmax_V3;
			tAWLmax = `tWLmax_V3;
		end
		'd4: begin
			tCDmax = `tCDmax_V4;
			tWHmax = `tWHmax_V4;
			tWLmax = `tWLmax_V4;
			tAWLmax = `tWLmax_V4;
		end
		endcase
	end
	case(addr[8])
	1'b0:	begin
		$display("\tWait Configuration : One clock prior");
		WC = `ONE_CLK;
	end
	1'b1:	begin
		$display("\tWait Configuration : At data");
		WC = `AT_DATA;
	end
	default: WC = 'bx;
	endcase
	case(addr[7:5])
	3'b010:	BL = 4;
	3'b011:	BL = 8;
	3'b100:	BL = 16;
	3'b101:	BL = 32;
	3'b111:	BL = (WM == `WRAP)? 256 : -1;	//Full or Continuous
	default: BL = 'bx;
	endcase
	$display("\tBurst Length : %d", BL);
	case(addr[4])
	1'b0:	begin
		$display("\tDeep Power Down : DPD Enable");
		DPD = `DPD_EN;
	end
	1'b1:	begin
		$display("\tDeep Power Down : DPD Disable");
		DPD = `DPD_DI;
	end
	default: DPD = 'bx;
	endcase
	case(addr[3])
	1'b0:	begin
		$display("\tPartial Array Refresh : PAR Enable");
		PAR = `PAR_EN;
	end
	1'b1:	begin
		$display("\tPartial Array Refresh : PAR Disable");
		PAR = `PAR_DI;
	end
	default: PAR = 'bx;
	endcase
	case(addr[2])
	1'b0:	begin
		$display("\tPAR Array : Bottom Array");
		PARA = `BOT_A;
	end
	1'b1:	begin
		$display("\tPAR Array : Top Array");
		PARA = `TOP_A;
	end
	default: PARA = 'bx;
	endcase
	case(addr[1:0])
	2'b00:	begin
		$display("\tPAR Size : Full Array");
		PARS = `FULL_A;
	end
	2'b10:	begin
		$display("\tPAR Size : 1/2 Array");
		PARS = `HALF_A;
	end
	2'b11:	begin
		$display("\tPAR Size : 1/4 Array");
		PARS = `QUAR_A;
	end
	default: PARS = 'bx;
	endcase
end
endtask
function [`ADDR_TOP:0] linear;
input	[`ADDR_TOP:0] addr;
input	burst;
integer	burst;
reg	[`ADDR_TOP:0] addr_tmp;
integer	m;
begin
	addr_tmp = addr;
	if (WM == `WRAP) begin
		case(BL)
			'd4:	addr_tmp[1:0] = addr_tmp[1:0] + burst;
			'd8:	addr_tmp[2:0] = addr_tmp[2:0] + burst;
			'd16:	addr_tmp[3:0] = addr_tmp[3:0] + burst;
			'd32:	addr_tmp[4:0] = addr_tmp[4:0] + burst;
			'd256:	addr_tmp[7:0] = addr_tmp[7:0] + burst;
			default:	addr_tmp = 'bx;
		endcase
	end
	else addr_tmp = addr_tmp + burst;
	linear = addr_tmp;
end
endfunction
endmodule
