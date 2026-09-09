module DmRDmaArb (
		nRST, Clk, FrameRst,

		Req0, BLen0, Addr0, Ack0, Valid0, RdData0, RLast0,
		Req1, BLen1, Addr1, Ack1, Valid1, RdData1, RLast1,
		Req2, BLen2, Addr2, Ack2, Valid2, RdData2, RLast2,

		RdReq, RdAck, ReqID, ValidID, Valid, RdData, RLast,
		Addr, BLen
);

`include "DmPara.v"

input			nRST, Clk, FrameRst;
input			Req0   ,    Req1,    Req2;
input	[ 4:0]	BLen0  ,   BLen1,   BLen2;
input	[AW:0]	Addr0  ,   Addr1,   Addr2;
output			Ack0   ,    Ack1,    Ack2;
output			Valid0 ,  Valid1,  Valid2;
output			RLast0 ,  RLast1,  RLast2;
output	[DW:0]	RdData0, RdData1, RdData2;

input	[IW:0]	ValidID;
input			Valid;
input			RLast;
input	[DW:0]	RdData;

input			RdAck;
output			RdReq;
output	[IW:0]	ReqID;
output	[31:0]	Addr;
output	[ 4:0]	BLen;
//-------------------------------------------------------------------------------
wire	[IW:0]	ReqID;
wire	[IW:0]	iReqID;
wire			AllReq;
wire			RdReq;

reg 	[ 4:0]	iBLen;
reg 	[AW:0]	iAddr;
wire	[ 4:0]	BLen;
wire	[DW:0]	Addr;
//-------------------------------------------------------------------------------
// RdReq Mux
assign iReqID = (Req0) ? 0 :	
				(Req1) ? 1 :	
				(Req2) ? 2 :	
					 	 0;

assign AllReq = Req0 | Req1 | Req2;

always@(iReqID or BLen0 or BLen1 or BLen2)
	case(iReqID)		// synopsys full_case parallel_case
		0 :	iBLen= BLen0;
		1 :	iBLen= BLen1;
		2 :	iBLen= BLen2;
	endcase

always@(iReqID or Addr0 or Addr1 or Addr2)
	case(iReqID)		// synopsys full_case parallel_case
		0 :	iAddr= Addr0;
		1 :	iAddr= Addr1;
		2 :	iAddr= Addr2;
	endcase

assign ReqID = iReqID;
assign BLen  = iBLen;
assign Addr  = {iAddr, 2'b0};	// 32bit Aligned Address
assign RdReq = AllReq;

assign Ack0	= (iReqID == 0) & RdAck;
assign Ack1	= (iReqID == 1) & RdAck;
assign Ack2	= (iReqID == 2) & RdAck;
//-------------------------------------------------------------------------------
// Data DeMux
assign Valid0	= (ValidID == 0) & Valid;
assign Valid1	= (ValidID == 1) & Valid;
assign Valid2	= (ValidID == 2) & Valid;

assign RLast0	= (ValidID == 0) & RLast;
assign RLast1	= (ValidID == 1) & RLast;
assign RLast2	= (ValidID == 2) & RLast;

assign RdData0	=  RdData;
assign RdData1	=  RdData;
assign RdData2	=  RdData;
//-------------------------------------------------------------------------------

endmodule