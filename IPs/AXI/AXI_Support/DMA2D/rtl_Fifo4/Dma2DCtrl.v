// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Dma2DCtrl.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI 2D DMA Controller
//                     : Main state machine for control.
// ==============================================================================


`timescale 1ns/1ps

module Dma2DCtrl
(
		//	CLK & Reset
		ACLK     ,
		ARESETn  ,

		// Triggering signal
		Enabled  ,	// Input  : Enable Operation
		Active   ,	// Output : Operation active

		// FIFO signal
		FifoReset,
		FifoNumByte  ,
		FifoSrcWidth ,
		FifoDataIn   ,
		FifoWriteEn  ,
		FifoSrcAddr  ,
		FifoDstWidth ,
		FifoDataOut  ,
		FifoDataMask ,
		FifoReadEn   ,
		FifoDstAddr  ,

		// From Register File
		SrcAddr,	// Input ; Source Address
		DestAddr  ,	// Input : Destination Address
		ByteCnt   ,	// Input : Byte Count Register
		LineCnt   ,	// Input : Line Count Register
		AddrUpd,	// Input : Address update register

		// To Register File
		SrcAddrWE,	// Output : Source Address Write Enable(acthive high)
		DestAddrWE,	// Output : Destination Address Write Enable(acthive high)
		LineCntWE,	// Output : LineCnt Write Enable(acthive high)
		SrcAddrWData,	// Output : Destination Register Write Data
		DestAddrWData,	// Output : Destination Address Register Write Data
		LineCntWData,	// Output : LineCnt Write Data

		// AXI Interface
		ARVALID,
		ARREADY,
		ARADDR,
		ARLEN,
		ARSIZE,
		ARBURST,

		RDATA,
		RRESP,
		RLAST,
		RVALID,
		RREADY,

		AWVALID,
		AWREADY,
		AWADDR,
		AWLEN,
		AWSIZE,
		AWBURST,

		WDATA,
		WSTRB,
		WLAST,
		WVALID,
		WREADY,

		BRESP,
		BVALID,
		BREADY,
		
		ErrorInterrupt,		// Output : Error(bus & other) Interrupt
		StopInterrupt		// Output : Stop(length is zero, no further descriptor) Interrupt
);

`define OKAY 2'b00

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  Enabled;
output Active;

output FifoReset;
output [3:0] FifoNumByte;

output [1:0]  FifoSrcWidth;
output [31:0] FifoDataIn;
output        FifoWriteEn;
output [1:0]  FifoSrcAddr;

output [1:0]  FifoDstWidth;
input  [31:0] FifoDataOut;
input  [3:0]  FifoDataMask;
output        FifoReadEn; 
output [1:0]  FifoDstAddr;

input  [31:0] SrcAddr;
input  [31:0] DestAddr;
input  [15:0] ByteCnt;
input  [31:0] LineCnt;
input  [31:0] AddrUpd;

output        SrcAddrWE;
output        DestAddrWE;
output        LineCntWE;

output [31:0] SrcAddrWData;
output [31:0] DestAddrWData;
output [31:0] LineCntWData;

output        ARVALID;
input         ARREADY;
output [31:0] ARADDR;
output [3:0]  ARLEN;
output [2:0]  ARSIZE;
output [1:0]  ARBURST;

input  [31:0] RDATA;
input  [1:0]  RRESP;
input         RLAST;
input         RVALID;
output        RREADY;

output        AWVALID;
input         AWREADY;
output [31:0] AWADDR;
output [3:0]  AWLEN;
output [2:0]  AWSIZE;
output [1:0]  AWBURST;

output [31:0] WDATA;
output [3:0]  WSTRB;
output        WLAST;
output        WVALID;
input         WREADY;

input  [1:0]  BRESP;
input         BVALID;
output        BREADY;

output        ErrorInterrupt;
output        StopInterrupt;

// extract information form register value
wire [31:0] DestAddr;
wire [31:0] SrcAddr;

wire [15:0] Length;
wire [1:0]  DestWidth;
wire [1:0]  SourceWidth;

assign Length       = LineCnt[15:0];
assign DestWidth    = 2'b10;		// WORD only 
assign SourceWidth  = 2'b10;		// WORD only

//
// State Machine
//
reg [7:0] State;		// Current State
reg [7:0] NextState;	// Next State
parameter S_IDLE = 0, S_READ = 1, S_RDATA = 2, S_WRITE = 3, S_WDATA = 4, S_WERR_CHECK = 5, S_FINISH = 6, S_ERROR = 7;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		State <= 1;	// S_IDLE
	end
	else State <= NextState;
end

wire LengthIsZero = (Length == 0);

wire LAST;
wire BusError;
reg  WriteError;
reg [1:0] NumOfRemainedWResp;

always @(State or Enabled or LengthIsZero or WriteError or BusError or LAST or RVALID or WVALID or WREADY or BVALID or BRESP or NumOfRemainedWResp)
begin
	NextState = 0;
	case(1'b1)	// synopsys parallel_case full_case
	State[S_IDLE]:
		if(Enabled == 1'b1)
		begin
			if(LengthIsZero)
				NextState[S_ERROR] = 1'b1;
			else
				NextState[S_READ] = 1'b1;
		end
		else NextState[S_IDLE] = 1'b1;
	State[S_READ]:	// read request state
		NextState[S_RDATA] = 1'b1;
	State[S_RDATA]:	// data read state
		if(LAST == 1'b1 && RVALID == 1'b1)
		begin
			if(BusError) NextState[S_ERROR] = 1'b1;
			else NextState[S_WRITE] = 1'b1;
		end
		else NextState[S_RDATA] = 1'b1;
	State[S_WRITE]:	// write request state
		NextState[S_WDATA] = 1'b1;
	State[S_WDATA]:	// data write date
		if(LAST && WVALID && WREADY) NextState[S_WERR_CHECK] = 1'b1;
		else NextState[S_WDATA] = 1'b1;
	State[S_WERR_CHECK]:	// write error check state
		if(NumOfRemainedWResp == 1 && BVALID == 1'b1)
		begin
			if(BRESP != `OKAY || WriteError == 1) NextState[S_ERROR] = 1'b1;
			else NextState[S_FINISH] = 1'b1;
		end
		else NextState[S_WERR_CHECK] = 1'b1;
	State[S_FINISH]: NextState[S_IDLE] = 1'b1;	// finished state
	State[S_ERROR]: NextState[S_IDLE] = 1'b1;	// bus error state
	endcase
end

assign Active = ~State[S_IDLE];

wire [15:0] NewLength;
wire [4:0] ByteSize;
assign NewLength = Length - ByteSize;
assign ErrorInterrupt = State[S_ERROR];
assign StopInterrupt  = State[S_FINISH] && (NewLength == 0) && (LineCnt[31:16] == 0);

assign SrcAddrWE  = State[S_FINISH];
assign DestAddrWE = State[S_FINISH];
assign LineCntWE  = State[S_FINISH];

wire [15:0] LineCountMinusOne;
assign LineCountMinusOne = LineCnt[31:16] - 1;
wire [31:0] NewLineCnt;
assign NewLineCnt = (NewLength == 0) ? {LineCountMinusOne, ByteCnt} : {LineCnt[31:16], NewLength};

`define MANY_ADDER 1

`ifdef MANY_ADDER
// Many Adder implemenation
wire [31:0] NewSrcAddr;
wire [31:0] NewDestAddr;

assign NewSrcAddr = SrcAddr + ByteSize + ((NewLength == 0) ? {{16{AddrUpd[31]}}, AddrUpd[31:16]} : 32'h00000000);
assign NewDestAddr = DestAddr + ByteSize + ((NewLength == 0) ? {{16{AddrUpd[15]}}, AddrUpd[15:0]} : 32'h00000000);
`else
// Common Adder implemenation
reg  [31:0] NewSrcAddr;
wire [31:0] NewDestAddr;
reg  [31:0] Temp32bitResult;

wire [31:0] Adder32bitOut;
reg  [31:0] Adder32bitOp0;
reg  [31:0] Adder32bitOp1;

// Common adder
assign Adder32bitOut = Adder32bitOp0 + Adder32bitOp1;
always @(State or SrcAddr or DestAddr or ByteSize or AddrUpd or NewLength)
begin
	Adder32bitOp0 = Temp32bitResult;
	Adder32bitOp1 = (NewLength == 0)? {{16{AddrUpd[15]}}, AddrUpd[15:0]} : 32'h00000000;
	case(1'b1)	// synopsys parallel_case
	State[S_READ] :
		begin
			Adder32bitOp0 = SrcAddr;
			Adder32bitOp1 = ByteSize;
		end
	State[S_RDATA]:
		begin
			Adder32bitOp0 = Temp32bitResult;
			Adder32bitOp1 = (NewLength == 0)? {{16{AddrUpd[31]}}, AddrUpd[31:16]} : 32'h00000000;
		end
	State[S_WRITE]:
		begin
			Adder32bitOp0 = DestAddr;
			Adder32bitOp1 = ByteSize;
		end
	endcase
end

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		NewSrcAddr <= 0;
		Temp32bitResult <= 0;
	end
	else
	begin
		if(State[S_READ] | State[S_WRITE])
			Temp32bitResult <= Adder32bitOut;
		if(State[S_RDATA])
			NewSrcAddr <= Adder32bitOut;
	end
end
assign NewDestAddr = Adder32bitOut;
`endif
assign SrcAddrWData  = NewSrcAddr;
assign DestAddrWData = NewDestAddr;
assign LineCntWData  = NewLineCnt;

// Fifo Control
assign FifoReset = State[S_READ];
assign FifoNumByte   = ByteSize-1;
assign FifoSrcWidth  = SourceWidth;
assign FifoWriteEn   = RREADY & RVALID;
assign FifoSrcAddr   = SrcAddr[1:0];
assign FifoDstWidth  = DestWidth;
assign FifoReadEn    = WVALID & WREADY;
assign FifoDstAddr   = DestAddr[1:0];

wire        Read;
wire        Write;
wire [31:0] Addr;
wire [1:0]  Width;

assign Read  = State[S_READ];

wire [31:0] FifoDataIn;
assign FifoDataIn = RDATA;

//
// AXI Request Processing
//
function [4:0] MaxIncrLenWithout4KBCross;
	input [11:0] Addr;
	if((&Addr[11:6]) == 1'b1) MaxIncrLenWithout4KBCross = 5'd16 - Addr[5:2];
	else MaxIncrLenWithout4KBCross = 5'd16;
endfunction

reg  [31:0] IncrAddr;
wire [31:0] NextIncrAddr;
wire [11:0] TestAddr;
assign TestAddr = (State[S_READ] | State[S_WRITE]) ? Addr[11:0] : NextIncrAddr[11:0];

wire [4:0] MaxLenWithout4KBCross;
assign MaxLenWithout4KBCross = MaxIncrLenWithout4KBCross(TestAddr[11:0]);

wire [4:0] SizeInByte;
assign SizeInByte = 5'd16;

// Read Request Sub FSM
assign ByteSize = (((|Length[15:5]) == 1'b1) || Length[4:0] >= SizeInByte) ? SizeInByte : Length[4:0];

reg  [4:0] TotalTransferLen;
always @(ByteSize or Width or Addr)
begin
	case(ByteSize[1:0])
	2'b00:
		if(Addr[1:0] == 2'b00) TotalTransferLen = {3'b00, ByteSize[4:2]};
		else TotalTransferLen = {2'b00, ByteSize[4:2]} + 1'b1;
	2'b01: TotalTransferLen = {2'b00, ByteSize[4:2]} + 1'b1;
	2'b10:
		if(Addr[1:0] != 2'b11)  TotalTransferLen = {2'b00, ByteSize[4:2]} + 1'b1;
		else TotalTransferLen = {2'b00, ByteSize[4:2]} + 2'b10;
	2'b11:
		if(Addr[1] == 1'b0) TotalTransferLen = {2'b00, ByteSize[4:2]} + 1'b1;
		else TotalTransferLen = {2'b00, ByteSize[4:2]} + 2'b10;
	endcase
end

wire [4:0] RealLen;
wire [5:0] NextRemainedTransferLen;
assign RealLen = (State[S_READ] | State[S_WRITE]) ? ((TotalTransferLen > MaxLenWithout4KBCross) ? MaxLenWithout4KBCross : TotalTransferLen[4:0]) : ((NextRemainedTransferLen > MaxLenWithout4KBCross) ? MaxLenWithout4KBCross : NextRemainedTransferLen[4:0]);

assign Write = (State[S_WRITE]);
assign Addr  = (State[S_WRITE])? DestAddr : SrcAddr;
assign Width  = 2'b10; /* WORD only */

wire [31:0] AlignedAddr;
assign AlignedAddr = {Addr[31:2], 2'b00};

wire [6:0]  AlignedRealLen;
reg  [3:0]  AXILEN;
reg  [4:0]  AXILENPlusOne;
assign AlignedRealLen = {AXILENPlusOne, 2'b00};

assign NextIncrAddr = IncrAddr + AlignedRealLen;

reg [5:0] RemainedTransferLen;
assign NextRemainedTransferLen = RemainedTransferLen - AXILENPlusOne;

reg        ARVALID;
reg        AWVALID;
wire [3:0] RealLenMinusOne;
assign RealLenMinusOne = RealLen - 1;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		ARVALID <= 0;
		AWVALID <= 0;
		RemainedTransferLen <= 0;
		IncrAddr <= 0;
		AXILENPlusOne <= 0;
		AXILEN <= 0;
	end
	else
	begin
		if(Read | Write)
		begin
			IncrAddr <= AlignedAddr;
			RemainedTransferLen <= TotalTransferLen;
			AXILEN <= RealLenMinusOne;
			AXILENPlusOne <= RealLen;
			if(Read)
				ARVALID <= 1'b1;
			else
				AWVALID <= 1'b1;
		end
		else if(State[S_RDATA])
		begin
			if(NextRemainedTransferLen == 0 && ARREADY == 1)
				ARVALID <= 0;
			else if(ARREADY == 1'b1)
			begin
				IncrAddr <= NextIncrAddr;
				RemainedTransferLen <= NextRemainedTransferLen;
				AXILEN <= RealLenMinusOne;
				AXILENPlusOne <= RealLen;
			end
		end
		else if(State[S_WDATA])
		begin
			if(NextRemainedTransferLen == 0 && AWREADY == 1)
				AWVALID <= 0;
			else if(AWREADY == 1'b1)
			begin
				IncrAddr <= NextIncrAddr;
				RemainedTransferLen <= NextRemainedTransferLen;
				AXILEN <= RealLenMinusOne;
				AXILENPlusOne <= RealLen;
			end
		end
	end
end

assign ARADDR  = IncrAddr;
assign ARLEN   = AXILEN;
assign ARSIZE  = 2'b10;
assign ARBURST = 2'b01;
assign AWADDR  = IncrAddr;
assign AWLEN   = AXILEN;
assign AWSIZE  = 2'b10;
assign AWBURST = 2'b01;

reg  [5:0] TransferCount;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		TransferCount <= 0;
	else
	begin
		if(Read|Write)
			TransferCount <= TotalTransferLen;
		else if(State[S_WDATA] && WREADY && WVALID)
			TransferCount <= TransferCount - 1;
		else if((State[S_RDATA]) && RVALID)
			TransferCount <= TransferCount - 1;
	end
end
assign LAST = (TransferCount == 6'd1);

// Write Request Fifo for WLAST 0utput
// I Assumed that total 3 write request can be generated at once(this will be correct).
reg [3:0] CurrentAWLEN;
reg [3:0] AWLEN_FIFO_0;
reg [3:0] AWLEN_FIFO_1;
reg [1:0] NumOfWriteReq;
reg [1:0] NumOfWriteProc;
wire [1:0] NumOfWriteProcPlusOne;
assign NumOfWriteProcPlusOne = NumOfWriteProc+1;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		NumOfWriteReq <= 0;
		NumOfWriteProc <= 0;
		CurrentAWLEN <= 0;
		AWLEN_FIFO_0 <= 0;
		AWLEN_FIFO_1 <= 0;
	end
	else
	begin
		if(State[S_WRITE])
		begin
			NumOfWriteReq <= 0;
			NumOfWriteProc <= 0;
		end
		else if(State[S_WDATA])
		begin
			if(WVALID == 0)
			begin
				if(AWVALID == 1 && AWREADY == 1)
					CurrentAWLEN <= AXILEN;
			end
			else if(WLAST)
			begin
				if(WREADY & WVALID)
				begin
					if(NumOfWriteProcPlusOne != NumOfWriteReq)
					begin
						if(NumOfWriteProc == 2'b00)
							CurrentAWLEN <= AWLEN_FIFO_0;
						else
							CurrentAWLEN <= AWLEN_FIFO_1;
					end
					else if(AWVALID == 1 && AWREADY == 1)
						CurrentAWLEN <= AXILEN;
	
					NumOfWriteProc <= NumOfWriteProcPlusOne;
				end
			end
			else if(WREADY & WVALID)
				CurrentAWLEN <= CurrentAWLEN - 1;
	
			if(AWVALID == 1 && AWREADY == 1)
			begin
				if(NumOfWriteReq == 2'b01)
					AWLEN_FIFO_0 <= AXILEN;
				else
					AWLEN_FIFO_1 <= AXILEN;
	
				NumOfWriteReq <= NumOfWriteReq + 1;
			end
		end
	end
end
assign WLAST  = (CurrentAWLEN == 0);

// Write Request Counter for Wrire Response Channel Processing
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		NumOfRemainedWResp <= 0;
	else
	begin
		if(State[S_RDATA])
			NumOfRemainedWResp <= 0;
		else if(AWVALID & AWREADY)
		begin
			if(!(BVALID & BREADY))
				NumOfRemainedWResp <= NumOfRemainedWResp + 1;
		end
		else if(BVALID & BREADY)
			NumOfRemainedWResp <= NumOfRemainedWResp - 1;
	end
end

// WSTRB 
wire [3:0] WSTRB;
assign WSTRB = FifoDataMask;

// WDATA
wire [31:0] WDATA;
assign WDATA = FifoDataOut;		// WORD

assign WVALID = State[S_WDATA] & (NumOfWriteReq != NumOfWriteProc);
assign RREADY = State[S_RDATA];
assign BREADY = State[S_WERR_CHECK] | State[S_WDATA];

// Read Error detection
reg  ReadError;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		ReadError <= 0;
	else
	begin
		if(Read) ReadError <= 0;
		else if(RVALID == 1 && RRESP != `OKAY) ReadError <= 1'b1;
	end
end
assign BusError = ReadError | (RRESP != `OKAY);

// Write Error detection
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		WriteError <= 0;
	else
	begin
		if(Write) WriteError <= 0;
		else if(BREADY == 1 && BVALID == 1 && BRESP != `OKAY) WriteError <= 1'b1;
	end
end

endmodule
