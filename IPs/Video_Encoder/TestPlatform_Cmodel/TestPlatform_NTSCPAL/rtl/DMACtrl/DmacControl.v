// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacControl.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI DMA Controller
//                     : Main state machine for channel control.
// ==============================================================================


`timescale 1ns/1ps

module DmacControl
(
		//	CLK & Reset
		ACLK     ,
		ARESETn  ,

		// Triggering signal
		Start   ,	// Input  : Start Operation
		Ready   ,	// Output : Operation Idle

		// FIFO signal
		FifoReset,
		NumByte  ,
		SrcWidth ,
		DataIn   ,
		WriteEn  ,
		SrcAddr  ,
		DstWidth ,
		DataOut  ,
		DataMask ,
		ReadEn   ,
		DstAddr  ,

		// From Register File
		ChControl   ,	// Input : Channel Control Register
		ChSrcAddr   ,	// Input ; Channel Source Address
		ChDestAddr  ,	// Input : Channel Destination Address
		ChDescriptor,	// Input : Channel Descriptor

		// To Register File
		ChControlWE,	// Output : Channel Control Register Write Enable(active high)
		ChSrcAddrWE,	// Output : Channel Source Address Write Enable(acthive high)
		ChDestAddrWE,	// Output : Channel Destination Address Write Enable(acthive high)
		ChDescriptorWE,	// Output : Channel Descriptor Write Enable(acthive high)
		ChControlWData,	// Output : Control Register Write Data
		ChSrcAddrWData,	// Output : Destination Register Write Data
		ChDestAddrWData,	// Output : Destination Address Register Write Data
		ChDescriptorWData,	// Output : Channel Register Write Data

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
		
		StartInterrupt,		// Output : Start(end of descriptor load) interrupt
		EndInterrupt,		// Output : End(Length is zero) interrupt
		ErrorInterrupt,		// Output : Error(bus & other) Interrupt
		StopInterrupt		// Output : Stop(length is zero, no further descriptor) Interrupt
);

`define OKAY 2'b00

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  Start;
output Ready;

output FifoReset;
output [4:0] NumByte;

output [1:0]  SrcWidth;
output [31:0] DataIn;
output        WriteEn;
output [1:0]  SrcAddr;

output [1:0]  DstWidth;
input  [31:0] DataOut;
input  [3:0]  DataMask;
output        ReadEn; 
output [1:0]  DstAddr;

input  [31:0] ChControl;
input  [31:0] ChSrcAddr;
input  [31:0] ChDestAddr;
input  [31:0] ChDescriptor;

output        ChControlWE;
output        ChSrcAddrWE;
output        ChDestAddrWE;
output        ChDescriptorWE;

output [31:0] ChControlWData;
output [31:0] ChSrcAddrWData;
output [31:0] ChDestAddrWData;
output [31:0] ChDescriptorWData;

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

output        StartInterrupt;
output        EndInterrupt;
output        ErrorInterrupt;
output        StopInterrupt;

// extract information form register value
wire [31:0] DestAddr;
wire [31:0] SourceAddr;
wire [31:0] DescriptorAddr;
wire        DescriptorEnd;

assign DestAddr = ChDestAddr;
assign SourceAddr = ChSrcAddr;
assign DescriptorAddr = {ChDescriptor[31:2], 2'b00};
assign DescriptorEnd = ChDescriptor[0];

wire [15:0] Length;
wire [2:0]  Size;
wire [1:0]  DestWidth;
wire        DestIncr;
wire [1:0]  SourceWidth;
wire        SrcIncr;

assign Length       = ChControl[15:0];
assign Size         = ChControl[18:16];
assign DestWidth    = ChControl[21:20];
assign DestIncr     = ChControl[22];
assign SourceWidth  = ChControl[25:24];
assign SrcIncr      = ChControl[26];

//
// State Machine
//
reg [10:0] State;		// Current State
reg [10:0] NextState;	// Next State
parameter S_IDLE0 = 0, S_IDLE1 = 1, S_DESC = 2, S_DREAD = 3, S_READ = 4, S_RDATA = 5, S_WRITE = 6, S_WDATA = 7, S_WERR_CHECK = 8, S_FINISH = 9, S_ERROR = 10;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		State <= 0;
		State[S_IDLE0] <= 1'b1;
	end
	else State <= NextState;
end

wire LengthIsZero = Length == 0;

wire AllDescriptorLoad;
wire LAST;
wire BusError;
reg  WriteError;
reg [1:0] NumOfRemainedWResp;

always @(State or Start or LengthIsZero or DescriptorEnd or AllDescriptorLoad or WriteError, BusError or LAST or RVALID or WVALID or WREADY or BVALID or BRESP)
begin
	NextState = 0;
	case(1'b1)	// synopsys parallel_case full_case
	State[S_IDLE0]:
		if(Start == 1'b1) NextState[S_IDLE1] = 1'b1;
		else NextState[S_IDLE0] = 1'b1;
	State[S_IDLE1]:	// Idle State
		if(LengthIsZero)
		begin
			if(!DescriptorEnd) NextState[S_DESC] = 1'b1;
			else NextState[S_ERROR] = 1'b1;	// Something wrong
		end
		else NextState[S_READ] = 1'b1;
	State[S_DESC]:	// Descriptor load request state
		NextState[S_DREAD] = 1'b1;
	State[S_DREAD]:		// Descriptor Read state
		if(AllDescriptorLoad)
		begin
			if(BusError) NextState[S_ERROR] = 1'b1;
			else if(LengthIsZero) NextState[S_ERROR] = 1'b1;	// Something wrong(holelee : Length should be updated before check)
			else NextState[S_READ] = 1'b1;
		end
		else NextState[S_DREAD] = 1'b1;
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
	State[S_FINISH]: NextState[S_IDLE0] = 1'b1;	// finished state
	State[S_ERROR]: NextState[S_IDLE0] = 1'b1;	// bus error state
	endcase
end

assign Ready = State[S_IDLE0];

wire [15:0] NewLength;
wire [5:0] ByteSize;
assign NewLength = Length - ByteSize;
assign StartInterrupt = State[S_DREAD] & NextState[S_READ];
assign EndInterrupt   = State[S_FINISH] & (NewLength == 0);
assign ErrorInterrupt = State[S_ERROR];
assign StopInterrupt  = EndInterrupt & DescriptorEnd;

// DESCRIPTOR READ 
reg [1:0] DescReadCount;
wire   ChRegWE;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		DescReadCount <= 0;
	else if(State[S_DESC])
		DescReadCount <= 0;
	else if(ChRegWE)
		DescReadCount <= DescReadCount + 1;
end
assign ChRegWE        = State[S_DREAD] && RVALID == 1'b1;
assign ChSrcAddrWE    = (ChRegWE && DescReadCount == 2'b00) | (State[S_FINISH] && SrcIncr);
assign ChDestAddrWE   = (ChRegWE && DescReadCount == 2'b01) | (State[S_FINISH] && DestIncr);
assign ChControlWE    = (ChRegWE && DescReadCount == 2'b10) | State[S_FINISH];
assign ChDescriptorWE = ChRegWE && DescReadCount == 2'b11;

/*
wire [31:0] NewSrcAddr;
wire [31:0] NewDestAddr;
wire [31:0] NewControl;

assign ChSrcAddrWData    = (State[S_FINISH]) ? NewSrcAddr  : RDATA;
assign ChDestAddrWData   = (State[S_FINISH]) ? NewDestAddr : RDATA;
assign ChControlWData    = (State[S_FINISH]) ? NewControl  : RDATA;
assign ChDescriptorWData = RDATA;

assign NewSrcAddr  = (SrcIncr) ? (SrcAddr + ByteSize) : SrcAddr;
assign NewDestAddr = (DestIncr) ? (DestAddr + ByteSize) : DestAddr;
assign NewControl  = {ChControl[31:16], NewLength};
*/
reg  [31:0] NewSrcAddr;
wire [31:0] NewDestAddr;
wire [31:0] NewControl;

assign ChSrcAddrWData    = (State[S_FINISH]) ? NewSrcAddr  : RDATA;
assign ChDestAddrWData   = (State[S_FINISH]) ? NewDestAddr : RDATA;
assign ChControlWData    = (State[S_FINISH]) ? NewControl  : RDATA;
assign ChDescriptorWData = RDATA;

wire [31:0] Add32bitOut;
wire [31:0] Add32bitOperand;
assign Add32bitOut = Add32bitOperand + ByteSize;
assign Add32bitOperand = (State[S_READ]) ? SourceAddr : DestAddr;
always @(posedge ACLK)
begin
	if(State[S_READ])
	begin
		if(SrcIncr)
			NewSrcAddr = Add32bitOut;
		else
			NewSrcAddr = SrcAddr;
	end
end

assign NewDestAddr = Add32bitOut;
assign NewControl  = {ChControl[31:16], NewLength};

assign AllDescriptorLoad = ChDescriptorWE;

// Fifo Control
assign FifoReset = State[S_READ];
assign NumByte   = ByteSize-1;
assign SrcWidth  = SourceWidth;
assign WriteEn   = RREADY & RVALID;
assign SrcAddr   = SourceAddr[1:0];
assign DstWidth  = DestWidth;
assign ReadEn    = WVALID & WREADY;
assign DstAddr   = DestAddr[1:0];

wire        Read;
wire        Write;
wire [31:0] Addr;
wire [1:0]  Width;
wire        Burst;

assign Read  = (State[S_DESC] || State[S_READ]);

// LowerAddr for WSTRB/WDATA/RDATA alignment
reg  [1:0] LowerAddr;
always @(posedge ACLK)
begin
	if(Write | Read)
	begin
		if(Width == 2'b01)	// HWORD
			LowerAddr <= {1'b0, Addr[1]};
		else
			LowerAddr <= Addr[1:0];
	end
	else if((State[S_WDATA] && WVALID && WREADY && DestIncr) | (State[S_RDATA] && RVALID && SrcIncr))
		LowerAddr <= LowerAddr + 1'b1;
end

reg [1:0]  AXISIZE;
reg  [31:0] DataIn;
always @(LowerAddr or AXISIZE or RDATA)
begin
	case(AXISIZE)
	2'b10: DataIn = RDATA;	// WORD
	2'b01: DataIn = (LowerAddr[0] == 0) ? {16'hxxxx, RDATA[15:0]} : {16'hxxxx, RDATA[31:16]};	// HWORD
	default:	// BYTE
		case(LowerAddr)
		2'b00: DataIn = {24'hxxxxxx, RDATA[7:0]};
		2'b01: DataIn = {24'hxxxxxx, RDATA[15:8]};
		2'b10: DataIn = {24'hxxxxxx, RDATA[23:16]};
		2'b11: DataIn = {24'hxxxxxx, RDATA[31:24]};
		endcase
	endcase
end

//
// AXI Request Processing
//
function [4:0] MaxIncrLenWithout4KBCross;
	input [11:0] Addr;
	input [1:0] Width;
	case(Width)
	2'b10:	// WORD
		if((&Addr[11:6]) == 1'b1) MaxIncrLenWithout4KBCross = 5'd16 - Addr[5:2];
		else MaxIncrLenWithout4KBCross = 5'd16;
	2'b01:	// HWORD
		if((&Addr[11:5]) == 1'b1) MaxIncrLenWithout4KBCross = 5'd16 - Addr[4:1];
		else MaxIncrLenWithout4KBCross = 5'd16;
	default:	// BYTE
		if((&Addr[11:4]) == 1'b1) MaxIncrLenWithout4KBCross = 5'd16 - Addr[3:0];
		else MaxIncrLenWithout4KBCross = 5'd16;
	endcase
endfunction

reg  [31:0] IncrAddr;
wire [31:0] NextIncrAddr;
wire [11:0] TestAddr;
assign TestAddr = (State[S_DESC] | State[S_READ] | State[S_WRITE]) ? Addr[11:0] : NextIncrAddr[11:0];

wire [4:0] MaxLenWithout4KBCross;
assign MaxLenWithout4KBCross = (Burst == 1'b1) ? MaxIncrLenWithout4KBCross(TestAddr[11:0], Width) : 5'd16;

reg  [5:0]  SizeInByte;
always @(posedge ACLK)
begin
	if(State[S_IDLE1])
	begin
	case(Size)
		3'b001: SizeInByte = 6'd2;
		3'b010: SizeInByte = 6'd4;
		3'b011: SizeInByte = 6'd8;
		3'b100: SizeInByte = 6'd16;
		3'b101: SizeInByte = 6'd32;
		default: SizeInByte = 6'd1;
		endcase
	end
end

// Read Request Sub FSM
// assign ByteSize = (State[S_DESC]) ? 5'd16 : ((Length >= SizeInByte) ? SizeInByte : Length[5:0]);
assign ByteSize = (State[S_DESC]) ? 5'd16 : ((((|Length[15:7]) == 1'b1) || Length[6:0] >= SizeInByte) ? SizeInByte : Length[5:0]);

reg  [5:0] TotalTransferLen;
always @(ByteSize or Width or Addr)
begin
	case(Width)
	2'b10: // WORD
	begin
		case(ByteSize[1:0])
		2'b00:
			if(Addr[1:0] == 2'b00) TotalTransferLen = {2'b00, ByteSize[5:2]};
			else TotalTransferLen = {2'b00, ByteSize[5:2]} + 1'b1;
		2'b01: TotalTransferLen = {2'b00, ByteSize[5:2]} + 1'b1;
		2'b10:
			if(Addr[1:0] != 2'b11)  TotalTransferLen = {2'b00, ByteSize[5:2]} + 1'b1;
			else TotalTransferLen = {2'b00, ByteSize[5:2]} + 2'b10;
		2'b11:
			if(Addr[1] == 1'b0) TotalTransferLen = {2'b00, ByteSize[5:2]} + 1'b1;
			else TotalTransferLen = {2'b00, ByteSize[5:2]} + 2'b10;
		endcase
	end
	2'b01: // HWORD
		if(ByteSize[0] == 0 && Addr[0] == 0) TotalTransferLen = {1'b0, ByteSize[5:1]};
		else TotalTransferLen = {1'b0, ByteSize[5:1]} + 1'b1;
	default: TotalTransferLen = ByteSize;	// BYTE
	endcase
end

wire [4:0] RealLen;
wire [5:0] NextRemainedTransferLen;
assign RealLen = (State[S_DESC] | State[S_READ] | State[S_WRITE]) ? ((TotalTransferLen > MaxLenWithout4KBCross) ? MaxLenWithout4KBCross : TotalTransferLen[4:0]) : ((NextRemainedTransferLen > MaxLenWithout4KBCross) ? MaxLenWithout4KBCross : NextRemainedTransferLen[4:0]);

assign Write = (State[S_WRITE]);
assign Addr  = (State[S_WRITE])? DestAddr : ((State[S_READ]) ? SourceAddr : DescriptorAddr);
assign Width  = (State[S_WRITE] | State[S_WDATA])? DstWidth : ((State[S_READ] | State[S_RDATA]) ? SrcWidth : 2'b10 /* WORD when descriptor */);
assign Burst = (State[S_WRITE] | State[S_WDATA]) ? DestIncr : ((State[S_DESC] | State[S_DREAD]) ? 1'b1 /* INCR */ : SrcIncr);

reg  [31:0] AlignedAddr;
always @(Addr or Width)
begin
	case(Width)
	2'b10: AlignedAddr = {Addr[31:2], 2'b00};	// WORD
	2'b01: AlignedAddr = {Addr[31:1], 1'b0};	// HWORD
	default: AlignedAddr = Addr[31:0];			// BYTE
	endcase
end

reg  [6:0]  AlignedRealLen;
reg  [3:0]  AXILEN;
reg  [4:0]  AXILENPlusOne;
always @(Width or AXILENPlusOne or Burst)
begin
	if(Burst == 0)
		AlignedRealLen = 0;
	else
	begin
		case(Width)
		2'b10: AlignedRealLen = {AXILENPlusOne, 2'b00};
		2'b01: AlignedRealLen = {1'b0, AXILENPlusOne, 1'b0};
		default: AlignedRealLen = {2'b00, AXILENPlusOne};
		endcase
	end
end
assign NextIncrAddr = IncrAddr + AlignedRealLen;

reg [5:0] RemainedTransferLen;
assign NextRemainedTransferLen = RemainedTransferLen - AXILENPlusOne;

reg        ARVALID;
reg        AWVALID;
reg [1:0]  AXIBURST;
wire [3:0] RealLenMinusOne;
assign RealLenMinusOne = RealLen - 1;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		ARVALID <= 0;
		AWVALID <= 0;
	end
	else
	begin
		AXIBURST <= {1'b0, Burst};
		AXISIZE <= Width;

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
		else if(State[S_DREAD] | State[S_RDATA])
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
assign ARSIZE  = AXISIZE;
assign ARBURST = AXIBURST;
assign AWADDR  = IncrAddr;
assign AWLEN   = AXILEN;
assign AWSIZE  = AXISIZE;
assign AWBURST = AXIBURST;

reg  [5:0] TransferCount;
always @(posedge ACLK)
begin
	if(Read|Write)
		TransferCount <= TotalTransferLen;
	else if(State[S_WDATA] && WREADY && WVALID)
		TransferCount <= TransferCount - 1;
	else if((State[S_RDATA] | State[S_DREAD]) && RVALID)
		TransferCount <= TransferCount - 1;
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
always @(posedge ACLK)
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
assign WLAST  = (CurrentAWLEN == 0);

// Write Request Counter for Wrire Response Channel Processing
always @(posedge ACLK)
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

// WSTRB 
reg  [3:0] WSTRB;
always @(LowerAddr or AXISIZE or DataMask)
begin
	case(AXISIZE)
	2'b10: WSTRB = DataMask;	// WORD
	2'b01: WSTRB = (LowerAddr[0] == 0) ? {2'b00, DataMask[1:0]} : {DataMask[1:0], 2'b00};	// HWORD
	default:	// BYTE
		case(LowerAddr)
		2'b00: WSTRB = {3'b000, DataMask[0]};
		2'b01: WSTRB = {2'b00,  DataMask[0], 1'b0};
		2'b10: WSTRB = {1'b0,   DataMask[0], 2'b00};
		2'b11: WSTRB = {        DataMask[0], 3'b000};
		endcase
	endcase
end

// WDATA
reg  [31:0] WDATA;
always @(AXISIZE or DataOut)
begin
	case(AXISIZE)
	2'b10: WDATA = DataOut;		// WORD
	2'b01: WDATA = {DataOut[15:0], DataOut[15:0]};		// HWORD
	default: WDATA = {DataOut[7:0], DataOut[7:0], DataOut[7:0], DataOut[7:0]};	// BYTE
	endcase
end

assign WVALID = State[S_WDATA] & (NumOfWriteReq != NumOfWriteProc);
assign RREADY = State[S_RDATA] | State[S_DREAD];
assign BREADY = State[S_WERR_CHECK] | State[S_WDATA];

// Read Error detection
reg  ReadError;
always @(posedge ACLK)
begin
	if(Read) ReadError <= 0;
	else if(RVALID == 1 && RRESP != `OKAY) ReadError <= 1'b1;
end
assign BusError = ReadError | (RRESP != `OKAY);

// Write Error detection
always @(posedge ACLK)
begin
	if(Write) WriteError <= 0;
	else if(BREADY == 1 && BVALID == 1 && BRESP != `OKAY) WriteError <= 1'b1;
end

endmodule
