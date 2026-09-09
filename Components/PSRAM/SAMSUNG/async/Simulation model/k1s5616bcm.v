/*===================================================================
Verilog behavioral model of Asynchronous UtRAM (K1S5616BCM, K1S56161CM)

Revision	: V1.0
date		: Apr. 28. 2006
===================================================================*/

`timescale	1ns / 10ps

`define	tRCmin		70
`define	tAAmax		70
`define	tCOmax		70
`define	tOEmax		35
`define	tBAmax		35
`define	tLZmin		5
`define	tBLZmin		5
`define	tOLZmin		5
`define	tHZmin		0
`define	tHZmax		12
`define	tBHZmin		0
`define	tBHZmax		12
`define	tOHZmin		0
`define	tOHZmax		10
`define	tOHmin		5
`define	tWCmin		70
`define	tCWmin		60
`define	tASmin		0
`define	tAWmin		60
`define	tBWmin		60
`define	tWPmin		55
`define	tWRmin		0
`define	tWHZmin		0
`define	tWHZmax		25
`define	tDWmin		30
`define	tDHmin		0
`define	tOWmin		5
`define	tPCmin		25
`define	tPAmax		20

`define	MEGA		1048576
`define	B		16
`define	INITIAL		-100
`define	MARGIN		0.01
`define	tPWRUP		200000
`define	tDPD		500
`define	DENSITY		256*`MEGA
`define	ADDR_TOP	23

module K1S5616BCM(cs1b, cs2, oeb, web, addr, io, ubb, lbb);
input	cs1b, cs2, oeb, web, ubb, lbb;
wire	csb = cs1b;
wire	zzb = cs2;

input	[`ADDR_TOP:0]	addr;
inout	[`B-1:0]	io;

reg	[`B-1:0]	mem	[`DENSITY/`B-1:0];

//`protect
reg	WRITE_MODE, PAGE_MODE, DPD_MODE, DPD_EXT, READ_CSB, READ_WEB, READ_ADDR, READ_BC;
reg	[1:0]	READ_MODE_CSB, READ_MODE_WEB, READ_MODE_ADDR, READ_MODE_OEB, READ_MODE_BC;
reg	[1:0]	byte;
reg	[`ADDR_TOP:0]	addr_prev, addr_int;
reg	[`B-1:0]	data_in, data_tmp, data_out_csb, data_out_web, data_out_addr, data_out_ubblbb, data_out_oeb;
real	now;
real	tCSB_L, tLBB_L, tUBB_L, tWEB_H, tWEB_L, tADDR, tIO;
real	tWRITE_ENT, tWRITE_EXT, tREAD_ENT;

initial begin
	$timeformat(-9, 1, " ns", 10);
	now = `INITIAL;
	tCSB_L = `INITIAL;	tLBB_L = `INITIAL;	tUBB_L = `INITIAL;	tWEB_H = `INITIAL;
	tWEB_L = `INITIAL;	tADDR = `INITIAL;	tIO = `INITIAL;
	tWRITE_ENT = `INITIAL;	tWRITE_EXT = `INITIAL;	tREAD_ENT = `INITIAL;
	WRITE_MODE = 0;	PAGE_MODE = 0;	DPD_MODE = 0;	DPD_EXT = 0;	
	READ_CSB = 0;		READ_WEB = 0;		READ_ADDR = 0;		READ_BC = 0;
	READ_MODE_CSB = 0;	READ_MODE_WEB = 0;	READ_MODE_ADDR = 0;	READ_MODE_OEB = 0;	READ_MODE_BC = 0;
end

/////////////////////////////////
//Power-up sequence
/////////////////////////////////
always @(csb or zzb) begin
	now = $realtime;
	`ifdef PWRUP_SKIP
	`else
		if (now < `tPWRUP-`MARGIN) begin
			if (csb === 1'b0 && zzb === 1'b0) begin
				$display("Error, after power-up, wait 200us with CS1B=high or CS2=low at %t", now);
			end
		end
	`endif
	#`MARGIN;
	if (DPD_EXT == 1) begin
		$display("Error, after deep power down exit, wait 200us with CSB=high and ZZB=high at %t", now);
	end
end

/////////////////////////////////
//Write
/////////////////////////////////
always @(negedge csb or negedge web or negedge lbb or negedge ubb or posedge zzb) begin
	now = $realtime;
	#(`MARGIN*2);
	if ({csb, web, zzb} === 3'b001 && (lbb === 1'b0 || ubb === 1'b0)) begin
		if (now - tWRITE_ENT < `tWCmin-`MARGIN) begin
			$display("Error, tWCmin violation at %t", now);
		end
		if (now - tADDR < `tASmin-`MARGIN) begin
			$display("Error, tASmin violation at %t", now);
		end
//		if (now - tREAD_ENT < `tRCmin-`MARGIN) begin			//ignored because of read-skew-free
//			$display("Error, tRCmin violation at %t", now);
//		end
		$display("Write at %t", now);
		byte = {ubb, lbb};
		addr_int = addr;
		WRITE_MODE = 1;
		tWRITE_ENT = now;
	end
end
always @(posedge csb or posedge web or posedge lbb or posedge ubb or negedge zzb) begin
	if (WRITE_MODE == 1) begin
		now = $realtime;
		if (now - tCSB_L < `tCWmin-`MARGIN) begin
			$display("Error, tCWmin violation at %t", now);
		end
		if (now - tADDR < `tAWmin-`MARGIN) begin
			$display("Error, tAWmin violation at %t", now);
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
		$display("\taddress is %b", addr_int);
		$display("\tdata-in is %b", data_in);
		data_tmp = mem[addr_int];
		if (byte[1] === 1'b0) data_tmp[15:8] = data_in[15:8];
		if (byte[0] === 1'b0) data_tmp[7:0] = data_in[7:0];
		mem[addr_int] = data_tmp;
		WRITE_MODE = 0;
		tWRITE_EXT = now;
	end
end
always @(addr) begin
	now = $realtime;
	#`MARGIN;
	if (WRITE_MODE == 1) begin
		$display("Error, not allowed address toggle during write op. at %t", now);
	end
	if (now - tWRITE_EXT < `tWRmin-`MARGIN) begin
		$display("Error, tWRmin violation at %t", now);
	end
end
always @(io) begin
	now = $realtime;
	#`MARGIN;
	if (now - tWRITE_EXT < `tDHmin-`MARGIN) begin
		$display("Error, tDHmin violation at %t", now);
	end
end
/*
always @(negedge web) begin
	now = $realtime;
	if (now - tWEB_H < `tWHPmin-`MARGIN) begin
		$display("Error, tWHPmin violation at %t", now);
	end
end
*/

/////////////////////////////////
//Read
/////////////////////////////////
assign	io[15:8] = (READ_MODE_CSB[1])? data_out_csb[15:8]:8'bz;
assign	io[15:8] = (READ_MODE_WEB[1])? data_out_web[15:8]:8'bz;
assign	io[15:8] = (READ_MODE_ADDR[1])? data_out_addr[15:8]:8'bz;
assign	io[15:8] = (READ_MODE_BC[1])? data_out_ubblbb[15:8]:8'bz;
assign	io[15:8] = (READ_MODE_OEB[1])? data_out_oeb[15:8]:8'bz;
assign	io[7:0] = (READ_MODE_CSB[0])? data_out_csb[7:0]:8'bz;
assign	io[7:0] = (READ_MODE_WEB[0])? data_out_web[7:0]:8'bz;
assign	io[7:0] = (READ_MODE_ADDR[0])? data_out_addr[7:0]:8'bz;
assign	io[7:0] = (READ_MODE_BC[0])? data_out_ubblbb[7:0]:8'bz;
assign	io[7:0] = (READ_MODE_OEB[0])? data_out_oeb[7:0]:8'bz;
always @(negedge csb or addr or posedge web or posedge zzb or negedge lbb or negedge ubb) begin
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		now = $realtime;
		if (PAGE_MODE == 1) begin
			if (now - tREAD_ENT < `tPCmin-`MARGIN) begin
				$display("Error, tPCmin violation at %t", now);
			end
		end
//		else begin
//			if (now - tREAD_ENT < `tRCmin-`MARGIN) begin			//ignored because of read-skew-free
//				$display("Error, tRCmin violation at %t", now);
//			end
//		end
		if (now - tWRITE_ENT < `tWPmin-`MARGIN) begin
			$display("Error, tWPmin violation at %t", now);
		end
		$display("Read at %t", now);
		$display("\taddress is %b", addr);
		tREAD_ENT = now;
		disable upper_hiz_blk;
		disable lower_hiz_blk;
	end
end
always @(negedge csb or posedge zzb) begin
	#`MARGIN;
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		READ_CSB = 1;
		if (oeb === 1'b0) begin
			if (ubb === 1'b0) begin
				READ_MODE_CSB[1] <= #(`tLZmin-`MARGIN) 1;
			end
			if (lbb === 1'b0) begin
				READ_MODE_CSB[0] <= #(`tLZmin-`MARGIN) 1;
			end
		end
		data_tmp = mem[addr];
		data_out_csb <= 16'bx;
		data_out_csb <= #(`tCOmax-`MARGIN) data_tmp;
	end
end
always @(posedge web) begin
	#`MARGIN;
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		READ_WEB = 1;
		if (oeb === 1'b0) begin
			if (ubb === 1'b0) begin
				READ_MODE_WEB[1] <= #(`tOWmin-`MARGIN) 1;
			end
			if (lbb === 1'b0) begin
				READ_MODE_WEB[0] <= #(`tOWmin-`MARGIN) 1;
			end
		end
		data_tmp = mem[addr];
		data_out_web <= 16'bx;
		data_out_web <= #(`tAAmax-`MARGIN) data_tmp;
	end
end
always @(addr) begin
	#`MARGIN;
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		READ_ADDR = 1;
		READ_MODE_CSB <= #(`tOHmin-`MARGIN) 2'b0;
		READ_MODE_WEB <= #(`tOHmin-`MARGIN) 2'b0;
		READ_MODE_OEB <= #(`tOHmin-`MARGIN) 2'b0;
		READ_MODE_BC <= #(`tOHmin-`MARGIN) 2'b0;
		if (oeb === 1'b0) begin
			if (ubb === 1'b0) begin
				READ_MODE_ADDR[1] <= #(`tOHmin-`MARGIN) 1;
			end
			if (lbb === 1'b0) begin
				READ_MODE_ADDR[0] <= #(`tOHmin-`MARGIN) 1;
			end
		end
		//#`MARGIN;
		data_tmp = mem[addr];
		data_out_addr <= #(`tOHmin-`MARGIN) 16'bx;
		if (addr_prev[`ADDR_TOP:2] === addr[`ADDR_TOP:2]) begin
			PAGE_MODE = 1;
			data_out_addr <= #(`tPAmax-`MARGIN) data_tmp;
		end
		else begin
			PAGE_MODE = 0;
			data_out_addr <= #(`tAAmax-`MARGIN) data_tmp;
		end
	end
end
always @(negedge ubb) begin
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		READ_BC = 1;
		if (oeb === 1'b0) begin
			READ_MODE_BC[1] <= #`tBLZmin 1;
		end
		data_tmp = mem[addr];
		data_out_ubblbb[15:8] <= 8'bx;
		data_out_ubblbb[15:8] <= #`tBAmax data_tmp[15:8];
	end
end
always @(negedge lbb) begin
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		READ_BC = 1;
		if (oeb === 1'b0) begin
			READ_MODE_BC[0] <= #`tBLZmin 1;
		end
		data_tmp = mem[addr];
		data_out_ubblbb[7:0] <= 8'bx;
		data_out_ubblbb[7:0] <= #`tBAmax data_tmp[7:0];
	end
end
always @(negedge oeb) begin
	if ({zzb, csb, web} === 3'b101 && (lbb === 1'b0 || ubb === 1'b0)) begin
		data_tmp = mem[addr];
		data_out_oeb <= 16'bx;
		if (ubb === 1'b0) begin
			if (READ_CSB) READ_MODE_CSB[1] <= #`tOLZmin 1;
			if (READ_WEB) READ_MODE_WEB[1] <= #`tOLZmin 1;
			if (READ_ADDR) READ_MODE_ADDR[1] <= #`tOLZmin 1;
			if (READ_BC) READ_MODE_BC[1] <= #`tOLZmin 1;
			READ_MODE_OEB[1] <= #`tOLZmin 1;
			data_out_oeb[15:8] <= #`tOEmax data_tmp[15:8];
		end
		if (lbb === 1'b0) begin
			if (READ_CSB) READ_MODE_CSB[0] <= #`tOLZmin 1;
			if (READ_WEB) READ_MODE_WEB[0] <= #`tOLZmin 1;
			if (READ_ADDR) READ_MODE_ADDR[0] <= #`tOLZmin 1;
			if (READ_BC) READ_MODE_BC[0] <= #`tOLZmin 1;
			READ_MODE_OEB[0] <= #`tOLZmin 1;
			data_out_oeb[7:0] <= #`tOEmax data_tmp[7:0];
		end
		disable upper_hiz_blk;
		disable lower_hiz_blk;
	end
end
always @(posedge csb or negedge web) begin
	now = $realtime;
	//if (now - tREAD_ENT < `tRCmin-`MARGIN) begin
		//$display("Error, tRCmin violation at %t", now);
	//end
	PAGE_MODE = 0;
end
always @(posedge ubb or posedge csb or negedge web or posedge oeb or negedge zzb) begin : upper_hiz_blk
	READ_CSB = 0;
	READ_WEB = 0;
	READ_ADDR = 0;
	data_out_csb <= #`tOHmin 16'bx;
	data_out_web <= #`tOHmin 16'bx;
	data_out_addr <= #`tOHmin 16'bx;
	data_out_ubblbb <= #`tOHmin 16'bx;
	data_out_oeb <= #`tOHmin 16'bx;
	READ_MODE_CSB[1] <= #`tHZmax 0;
	READ_MODE_WEB[1] <= #`tWHZmax 0;
	READ_MODE_ADDR[1] <= #`tHZmax 0;
	READ_MODE_OEB[1] <= #`tOHZmax 0;
	READ_MODE_BC[1] <= #`tBHZmax 0;
end
always @(posedge lbb or posedge csb or negedge web or posedge oeb or negedge zzb) begin : lower_hiz_blk
	READ_CSB = 0;
	READ_WEB = 0;
	READ_ADDR = 0;
	data_out_csb <= #`tOHmin 16'bx;
	data_out_web <= #`tOHmin 16'bx;
	data_out_addr <= #`tOHmin 16'bx;
	data_out_ubblbb <= #`tOHmin 16'bx;
	data_out_oeb <= #`tOHmin 16'bx;
	READ_MODE_CSB[0] <= #`tHZmax 0;
	READ_MODE_WEB[0] <= #`tWHZmax 0;
	READ_MODE_ADDR[0] <= #`tHZmax 0;
	READ_MODE_OEB[0] <= #`tOHZmax 0;
	READ_MODE_BC[0] <= #`tBHZmax 0;
end


/////////////////////////////////
//Store signal toggle time
/////////////////////////////////
always @(csb) begin
	now = $realtime;
	if (csb === 1'b0) tCSB_L = now;
end
always @(lbb) begin
	now = $realtime;
	if (lbb === 1'b0) tLBB_L = now;
end
always @(ubb) begin
	now = $realtime;
	if (ubb === 1'b0) tUBB_L = now;
end
always @(web) begin
	now = $realtime;
	if (web === 1'b0) tWEB_L = now;
	else if (web === 1'b1) tWEB_H = now;
end
always @(addr) begin
	#`MARGIN;
	if (WRITE_MODE == 0) begin
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
`endprotect
endmodule
