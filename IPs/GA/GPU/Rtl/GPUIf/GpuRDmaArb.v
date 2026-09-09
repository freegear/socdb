module GpuRDmaArb (
		nRST, Clk,

		Req0, Ack0, Valid0, BLen0, Addr0, ByteEn0,
		Req1, Ack1, Valid1, BLen1, Addr1, ByteEn1,
		Req2, Ack2, Valid2, BLen2, Addr2, ByteEn2,
		Req3, Ack3, Valid3, BLen3, Addr3, ByteEn3,
		Req4, Ack4, Valid4, BLen4, Addr4, ByteEn4,
		RdData0, RdData1, RdData2, RdData3, RdData4,

		RdReq, RdAck, ReqID, ValidID, Valid, RdData,
		Addr, BLen, ByteEn
);

`include "GpuPara.v"

input			nRST, Clk;
input			Req0, Req1, Req2, Req3, Req4;
output			Ack0, Ack1, Ack2, Ack3, Ack4;
input	[ 4:0]	BLen0, BLen1, BLen2, BLen3, BLen4;
input	[31:0]	Addr0, Addr1, Addr2, Addr3, Addr4;
input	[ 3:0]	ValidID;
input			Valid;
input	[DW:0]	RdData;

output			Valid0, Valid1, Valid2, Valid3, Valid4;
output	[DW:0]	RdData0, RdData1, RdData2, RdData3, RdData4;
output	[BW:0]	ByteEn0, ByteEn1, ByteEn2, ByteEn3, ByteEn4;

input			RdAck;
output			RdReq;
output	[ 3:0]	ReqID;
output	[31:0]	Addr;
output	[ 4:0]	BLen;
output	[BW:0]	ByteEn;
//-------------------------------------------------------------------------------
wire	[ 3:0]	ReqID;
wire	[ 3:0]	iReqID;
wire			AllReq;
wire			RdReq;

reg 	[ 4:0]	iBLen;
reg 	[31:0]	iAddr;
wire	[ 4:0]	BLen;
wire	[31:0]	Addr;
//-------------------------------------------------------------------------------
// RdReq Mux
assign iReqID = (Req0) ? 0 :	
				(Req1) ? 1 :	
				(Req2) ? 2 :	
				(Req3) ? 3 :	
				(Req4) ? 4 :	
					 	 0;

assign AllReq = Req0 | Req1 | Req2 | Req3 | Req4;

always@(iReqID or BLen0 or BLen1 or BLen2 or BLen3 or BLen4)
	case(iReqID)		// synopsys full_case parallel_case
		0 :	iBLen= BLen0;
		1 :	iBLen= BLen1;
		2 :	iBLen= BLen2;
		3 :	iBLen= BLen3;
		4 :	iBLen= BLen4;
	endcase

always@(iReqID or Addr0 or Addr1 or Addr2 or Addr3 or Addr4)
	case(iReqID)		// synopsys full_case parallel_case
		0 :	iAddr= Addr0;
		1 :	iAddr= Addr1;
		2 :	iAddr= Addr2;
		3 :	iAddr= Addr3;
		4 :	iAddr= Addr4;
	endcase

assign ReqID = iReqID;
assign BLen  = iBLen;
assign Addr  = iAddr;
assign RdReq = AllReq;

assign Ack0	= (iReqID == 0) & RdAck;
assign Ack1	= (iReqID == 1) & RdAck;
assign Ack2	= (iReqID == 2) & RdAck;
assign Ack3	= (iReqID == 3) & RdAck;
assign Ack4	= (iReqID == 4) & RdAck;
//-------------------------------------------------------------------------------
// Data DeMux
assign Valid0	= (ValidID == 0) & Valid;
assign Valid1	= (ValidID == 1) & Valid;
assign Valid2	= (ValidID == 2) & Valid;
assign Valid3	= (ValidID == 3) & Valid;
assign Valid4	= (ValidID == 4) & Valid;

//assign ByteEn0	= (ValidID == 0) ? ByteEn : 0;
//assign ByteEn1	= (ValidID == 1) ? ByteEn : 0;
//assign ByteEn2	= (ValidID == 2) ? ByteEn : 0;
//assign ByteEn3	= (ValidID == 3) ? ByteEn : 0;
//assign ByteEn4	= (ValidID == 4) ? ByteEn : 0;

assign ByteEn0	=  ByteEn;
assign ByteEn1	=  ByteEn;
assign ByteEn2	=  ByteEn;
assign ByteEn3	=  ByteEn;
assign ByteEn4	=  ByteEn;

assign RdData0	=  RdData;
assign RdData1	=  RdData;
assign RdData2	=  RdData;
assign RdData3	=  RdData;
assign RdData4	=  RdData;
//-------------------------------------------------------------------------------

endmodule
