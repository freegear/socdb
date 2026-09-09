// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : I2CLoClk.v
// File Revision    : 1.1 
// Reveision		: Tx Prescaler Bit 
//					: Add Soft Reset
//  -----------------------------------------------------------------------------
//  Purpose         : I2C SCL Clock State Machine
// ==============================================================================
module I2CLoClk 
	(
	PCLK,
	PRESETn,
	SW_RST,
	Start,
	Stop,

	IntPendFlag,
	DataTrans,

	StartDet,
	StopDet,
	BusErrorDet,
	ArbitLostDet,
	ClkEn,
	TxPre,
	WaitCnt,
	CntRst,
	SCLWait,
	CntIsZero,
	RepeatStart,
	SendStop,
	out_clk
	);

input			PCLK;
input			PRESETn;
input			SW_RST;
input			Start;
input			Stop;

input			IntPendFlag;
input			DataTrans;

input			StartDet;
input			StopDet;
input			ArbitLostDet;
input			BusErrorDet;
input			ClkEn;

input	[11:0] 	TxPre;

input			WaitCnt; // for Clock Sync
input			CntRst; // for Clock Sync
input			SCLWait;
output			CntIsZero;
input			RepeatStart;
input			SendStop;
output         	out_clk;

reg				out_clk;

`define 		StateIdle 	4'b0001
`define 		StateLow 	4'b0010
`define 		StateHigh1 	4'b0100
`define 		StateHigh2 	4'b1000
reg	[3:0]		State;
reg	[3:0]		NextState;

reg [11:0] CntVal;

wire CntIsZero	= (CntVal == 0);

wire	PendClr =0;
wire	StateIsIdle;
assign	StateIsIdle = (State==`StateIdle);
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	CntVal <= 0;
	end	
	else
		begin
		if (StopDet|StateIsIdle|CntIsZero|WaitCnt|PendClr|ArbitLostDet)
			CntVal <= TxPre; // Load Tx Prescaler Value
		else if (CntRst)
			CntVal <= 0;
		else if (!SCLWait) //if (SrcClkEn)
			CntVal <= CntVal-1;
		end
end


always @(State or Start or Stop or StartDet or CntIsZero or 
			PendClr or SCLWait or StopDet or BusErrorDet or
		 RepeatStart or SendStop or SW_RST or IntPendFlag)
begin
	NextState = State;
	case (State)
	`StateIdle	:
		if (Start&~IntPendFlag) // Clock Start
			NextState = `StateHigh1;
	`StateHigh1	:
		if (StopDet|SW_RST)
			NextState = `StateIdle;
		else if (CntIsZero) 
			NextState = `StateHigh2;
	`StateHigh2:
		if (StopDet|SW_RST)
			NextState = `StateIdle;
		else if (CntIsZero)
			NextState = `StateLow;
	`StateLow	:
		if (StopDet|BusErrorDet|SW_RST)
			NextState = `StateIdle;
		else if (CntIsZero & (RepeatStart|SendStop))
			NextState = `StateHigh1;
		else if (CntIsZero & SCLWait)
			NextState = `StateLow;
		else if (CntIsZero)
			NextState = `StateHigh2;
	endcase
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	State <= `StateIdle;
	else
	State <= NextState;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	out_clk <= 1'b1;
	else
	begin
		case (NextState)
		`StateIdle : 
			out_clk <= 1'b1;
		`StateHigh1:
			out_clk <= 1'b1;
		`StateHigh2:
			out_clk <= 1'b1;
		`StateLow:
			out_clk <= 1'b0;
		endcase
	end
end

// synopsys translate_off
reg [8*10 : 1] CAState;

always @(State)
begin 
  if (State == 3'b001)
    CAState = "IDLE";
  else if (State == 3'b010)
    CAState = "LOW";
  else if (State == 3'b100)
    CAState = "HIGH";
end

reg [8*10 : 1] NAState;

always @(NextState)
begin 
  if (NextState == 3'b001)
    NAState = "IDLE";
  else if (NextState == 3'b010)
    NAState = "LOW";
  else if (NextState == 3'b100)
    NAState = "HIGH";
end
// synopsys translate_on
endmodule

