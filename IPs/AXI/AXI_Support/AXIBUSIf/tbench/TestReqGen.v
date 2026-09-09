//
// TestReqGen.v
// Description : Test Request Generator(part of testbench) for AXIBUSIf
//
// Copyright(C) 2008 RichenTech
// See Licese.txt for License Information
//
// 20-Feb-2008 holelee Created
//

//
// this module is not intended to be synthesized
// test purpose only behavioral model.
//

`timescale 1ns/1ps

module TestReqGen
(
	CLK,
	RESETn,

	Req,
	ReqAddr,
	ReqLen,
	ReqRnW,
	ReqAck,

	WriteData,	// Write Data
	WriteEn,	// Write Data Byte Enable(Active High)
	WriteDataReady,	// Write Data Ready(Active High) : Toggle WriteData/WriteEn when WriteDataReady is high on rising of ACLK
	ReadData,	// Read Data
	ReadDataValid	// Read Data Valid(Active High) : Latch Read Data when ReadDataValid is high on rising of ACLK
);

//
// Configuration Parameter
//
parameter READ_SUPPORT = 1;
parameter WRITE_SUPPORT = 1;
parameter DATA_WIDTH = 32;
parameter REQ_Q_DEPTH = 4;
parameter RANDOMIZE = 1;	// Request Timing is random ?
parameter INFINITE_RANDOM_TEST = 1;
parameter RANDOM_TEST_MAX = 500000;
parameter MAX_IDLE_CYCLE = 50000;
parameter RANDOM_TEST_WIDTH = 13;	// 2^(RANDOM_TEST_WIDTH) : 8KB

parameter DW = DATA_WIDTH;
parameter DENW = DATA_WIDTH/8;
parameter REQ_Q_LEN = {REQ_Q_DEPTH{1'b1}};
parameter RDATA_Q_DEPTH = REQ_Q_DEPTH + 4;
parameter RDATA_Q_LEN = {RDATA_Q_DEPTH{1'b1}};
parameter WDATA_Q_DEPTH = REQ_Q_DEPTH + 4;
parameter WDATA_Q_LEN = {WDATA_Q_DEPTH{1'b1}};
parameter RANDOM_TEST_ADDRMAX = {RANDOM_TEST_WIDTH{1'b1}};

input  CLK;
input  RESETn;

output        Req;
output [31:0] ReqAddr;
output [ 3:0] ReqLen;
output        ReqRnW;
input         ReqAck;

output [DATA_WIDTH-1:0] WriteData;
output [DENW-1:0] WriteEn;
input         WriteDataReady;

input  [DATA_WIDTH-1:0] ReadData;
input         ReadDataValid;

//
// Request Que
//
reg  [REQ_Q_DEPTH-1:0] REQ_Q_WAddr;
reg  [REQ_Q_DEPTH-1:0] REQ_Q_RAddr;
reg                   REQ_Q_Full;

wire REQ_Q_Empty;
assign REQ_Q_Empty = (!REQ_Q_Full) && (REQ_Q_WAddr == REQ_Q_RAddr);

reg [31:0] ReqAddr_Q[REQ_Q_LEN:0];
reg [3:0]  ReqLen_Q[REQ_Q_LEN:0];
reg        ReqRnW_Q[REQ_Q_LEN:0];

//
// RDATA Que
//
reg  [RDATA_Q_DEPTH-1:0] RDATA_Q_WAddr;
reg  [RDATA_Q_DEPTH-1:0] RDATA_Q_RAddr;
reg                   RDATA_Q_Full;

wire RDATA_Q_Empty;
//assign RDATA_Q_Empty = (!RDATA_Q_Full) && (RDATA_Q_WAddr == RDATA_Q_RAddr);
//function [RDATA_Q_DEPTH:0] RDATA_Q_Space;
//	input i;
//	RDATA_Q_Space = (RDATA_Q_WAddr != RDATA_Q_RAddr) ? {1'b0, (RDATA_Q_RAddr-RDATA_Q_WAddr)} : ((RDATA_Q_Full) ? 0 : {1'b1, {(RDATA_Q_DEPTH-1){1'b0}}});
//endfunction
assign RDATA_Q_Empty = (RDATA_Q_WAddr == RDATA_Q_RAddr);
function [RDATA_Q_DEPTH:0] RDATA_Q_Space;
	input i;
	RDATA_Q_Space = (RDATA_Q_WAddr == RDATA_Q_RAddr) ? {1'b1, {(RDATA_Q_DEPTH-1){1'b0}}} : {1'b0, (RDATA_Q_RAddr-RDATA_Q_WAddr-1)};
endfunction


reg [DATA_WIDTH-1:0] ReadData_Q[RDATA_Q_LEN:0];


//
// WDATA Que
//
reg  [WDATA_Q_DEPTH-1:0] WDATA_Q_WAddr;
reg  [WDATA_Q_DEPTH-1:0] WDATA_Q_RAddr;
reg                   WDATA_Q_Full;

wire WDATA_Q_Empty;
//assign WDATA_Q_Empty = (!WDATA_Q_Full) && (WDATA_Q_WAddr == WDATA_Q_RAddr);
//function [WDATA_Q_DEPTH:0] WDATA_Q_Space;
//	input i;
//	WDATA_Q_Space = (WDATA_Q_WAddr != WDATA_Q_RAddr) ? {1'b0, (WDATA_Q_RAddr-WDATA_Q_WAddr)} : ((WDATA_Q_Full) ? 0 : {1'b1, {(WDATA_Q_DEPTH-1){1'b0}}});
//endfunction
assign WDATA_Q_Empty = (WDATA_Q_WAddr == WDATA_Q_RAddr);
function [WDATA_Q_DEPTH:0] WDATA_Q_Space;
	input i;
	WDATA_Q_Space = (WDATA_Q_WAddr == WDATA_Q_RAddr) ? {1'b1, {(WDATA_Q_DEPTH-1){1'b0}}} : {1'b0, (WDATA_Q_RAddr-WDATA_Q_WAddr-1)};
endfunction

reg [DATA_WIDTH-1:0] WriteData_Q[WDATA_Q_LEN:0];
reg [DENW-1:0] WriteEn_Q[WDATA_Q_LEN:0];

task request;
	input [31:0] Addr;
	input [3:0] Len;
	input RnW;

	begin
//		@(posedge CLK) ;
		while (REQ_Q_Full) @(posedge CLK);	// wait until Request Que is not full
//		if(RnW == 1)
//		begin
//			while(RDATA_Q_Space(0) <= {{(RDATA_Q_DEPTH-4){1'b0}}, Len}) @(posedge CLK);	// wait until Read Data Que is available
//		end
//		else
//		begin
//			while(WDATA_Q_Space(0) <= {{(WDATA_Q_DEPTH-4){1'b0}}, Len}) @(posedge CLK);	// wait until Write Data Que is available
//		end

		ReqAddr_Q[REQ_Q_WAddr] = Addr;
		ReqLen_Q[REQ_Q_WAddr] = Len;
		ReqRnW_Q[REQ_Q_WAddr] = RnW;
		REQ_Q_WAddr = REQ_Q_WAddr + 1;
		if(REQ_Q_RAddr == REQ_Q_WAddr)
			REQ_Q_Full = 1;
	end
endtask

task read_data;
	input [DATA_WIDTH-1:0] data;
	reg [RDATA_Q_DEPTH-1:0] RDATA_Q_WAddrPlusOne;
	begin
		// no need to check RDATA Que has space(already checked in task request)
		#1;
		RDATA_Q_WAddrPlusOne = RDATA_Q_WAddr + 1;
		while(RDATA_Q_WAddrPlusOne == RDATA_Q_RAddr)	// wait until Write Data Que is available
		begin
			@(posedge CLK);	// wait until Write Data Que is available
			#1 ;
		end
		ReadData_Q[RDATA_Q_WAddr] = data;
		if((RDATA_Q_WAddr+1) == RDATA_Q_RAddr)
			RDATA_Q_Full = 1;
		RDATA_Q_WAddr = RDATA_Q_WAddr + 1;
	end
endtask

task write_data;
	input [DATA_WIDTH-1:0] data;
	input [DENW-1:0] write_en;
	reg [RDATA_Q_DEPTH-1:0] WDATA_Q_WAddrPlusOne;
	begin
		#1;
		WDATA_Q_WAddrPlusOne = WDATA_Q_WAddr + 1;
		while(WDATA_Q_WAddrPlusOne == WDATA_Q_RAddr)
		begin
			@(posedge CLK);	// wait until Write Data Que is available
			#1 ;
		end
		WriteData_Q[WDATA_Q_WAddr] = data;
		WriteEn_Q[WDATA_Q_WAddr] = write_en;
		WDATA_Q_WAddr = WDATA_Q_WAddr + 1;
		if(WDATA_Q_WAddr == WDATA_Q_RAddr)
			WDATA_Q_Full = 1;
	end
endtask

task sim_init;
	begin
		REQ_Q_WAddr = 0;
		REQ_Q_RAddr = 0;
		REQ_Q_Full  = 0;
		RDATA_Q_WAddr = 0;
		RDATA_Q_RAddr = 0;
		RDATA_Q_Full  = 0;
		WDATA_Q_WAddr = 0;
		WDATA_Q_RAddr = 0;
		WDATA_Q_Full  = 0;

		while(RESETn !== 1) @(posedge CLK);	// wait until RESETn is released;

		@(posedge CLK);
	end
endtask

task wait_until_done;
	begin
		@(posedge CLK) ;
		while((!RDATA_Q_Empty) || (!WDATA_Q_Empty)) @(posedge CLK);
	end
endtask


//
// Request Processing
//
reg random_value;
reg        Req;
reg [31:0] ReqAddr;
reg [3:0]  ReqLen;
reg        ReqRnW;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		Req <= 0;
		ReqAddr <= 0;
		ReqLen <= 0;
		ReqRnW <= 0;
		REQ_Q_Full <= 0;
	end
	else
	begin
		random_value = $random & RANDOMIZE;

		if(random_value == 0 && (!REQ_Q_Empty) && ((Req == 1 && ReqAck == 1) || Req == 0))
		begin
			Req     <= 1;
			ReqAddr <= ReqAddr_Q[REQ_Q_RAddr];
			ReqLen  <= ReqLen_Q[REQ_Q_RAddr];
			ReqRnW  <= ReqRnW_Q[REQ_Q_RAddr];

			REQ_Q_RAddr <= REQ_Q_RAddr + 1;
			REQ_Q_Full <= 0;
		end
		else if(Req == 1 && ReqAck == 1)
			Req <= 0;
	end
end

//
// Checking idle time
//
reg [31:0] idle_cycle;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		idle_cycle <= 0;
	else
	begin
		if(idle_cycle >= MAX_IDLE_CYCLE)
		begin
			$display("No additional request generated for loop time\n");
			$stop;
		end

		if(Req && ReqAck)
			idle_cycle <= 0;
		else
			idle_cycle <= idle_cycle + 1;
	end
end


//
// Read Data Check
//
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		RDATA_Q_Full = 0;
		RDATA_Q_RAddr = 0;
	end
	else
	begin
		if(ReadDataValid == 1)
		begin
			if(RDATA_Q_Empty)
			begin
				$display("Received Read Data when No Request Generated");
				$stop;
			end
			if(ReadData_Q[RDATA_Q_RAddr] !== ReadData)
			begin
				$display("Read Data(%h) mismatch with expected value(%h)", ReadData, ReadData_Q[RDATA_Q_RAddr]);
				$stop;
			end
			RDATA_Q_RAddr = RDATA_Q_RAddr + 1;
			RDATA_Q_Full = 0;
		end
	end
end

//
// Write Data Supply
//
reg [DATA_WIDTH-1:0] WriteData;
reg [DENW-1:0] WriteEn;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		WDATA_Q_Full = 0;
		WDATA_Q_RAddr = 0;
		WriteData <= 0;
		WriteEn <= 0;
	end
	else
	begin
		if(!WDATA_Q_Empty)
		begin
			if(WriteDataReady)
			begin
				WDATA_Q_RAddr = WDATA_Q_RAddr + 1;
				WDATA_Q_Full = 0;
			end

			WriteData <= WriteData_Q[WDATA_Q_RAddr];
			WriteEn   <= WriteEn_Q[WDATA_Q_RAddr];
		end
		else
			WriteData <= 32'hxxxxxxxx;
			WriteEn   <= {DENW{1'b1}};
	end
end

initial
begin
	sim_init;

	write_initial_data;

	wait_until_done;

	if(INFINITE_RANDOM_TEST)
	begin
		while(1)
			random_read_write;
	end
	else
	begin
		repeat(RANDOM_TEST_MAX)
			random_read_write;
	end

	wait_until_done;
	$finish;
end

// RANDOM Read/Write Test
function [(DATA_WIDTH-1):0] TestData;
	input [31:0] Addr;
	begin
//		if(DATA_WIDTH==64)
//			TestData[63:32] = Addr+1;
		TestData = Addr;
		
	end
endfunction

wire [31:0] addr_inc;
wire [31:0] addr_mask;
assign addr_inc = (DATA_WIDTH == 64) ? 8: 4;
assign addr_mask = ((DATA_WIDTH == 64) ? 32'hfffffff8: 32'hfffffffc) & {{(32-RANDOM_TEST_WIDTH){1'b0}}, {RANDOM_TEST_WIDTH{1'b1}}};
task write_initial_data;
integer i, j;
	begin
		for(i = 0; i < RANDOM_TEST_ADDRMAX; i = i + j*addr_inc)
		begin
			request(i, 4'd15, 0);	// Write Request
			for(j = 0; j <= 15; j = j + 1)
			begin
				write_data(TestData(i+j*addr_inc), {DENW{1'b1}});
			end
		end
	end	
endtask

task random_read_write;
	reg rnw;
	reg [31:0] addr;
	reg [3:0] len;
	begin
		rnw = $random;
		addr = $random & addr_mask;
		len = $random;

		while((addr + len*addr_inc) > RANDOM_TEST_ADDRMAX)
		begin
			addr = $random & addr_mask;
			len = $random;
		end

		request(addr, len, rnw);

		if(rnw)
		begin
			read_data(TestData(addr));
			while(len != 0)
			begin
				addr = addr + addr_inc;
				len = len - 1;
				read_data(TestData(addr));
			end
		end
		else
		begin
			write_data(TestData(addr), {DENW{1'b1}});
			while(len != 0)
			begin
				addr = addr + addr_inc;
				len = len - 1;
				write_data(TestData(addr), {DENW{1'b1}});
			end
		end
	end
endtask

endmodule
