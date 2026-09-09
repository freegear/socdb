// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : I2CShift.v
// File Revision       : Ver 3.0 
// Revision History    : 
// 
//  ----------------------------------------------------------------
// Description         : I2C Shift Register Block  
//  ----------------------------------------------------------------


`timescale 1ns/1ps
module I2CShift(
	PCLK		,
	PRESETn		,

	SW_RST		,
	AckEn		, 	// Acknowledge Assertion
	OpMode		,	// 00: Slave Rx 01: Slave Tx 10: Master Rx 11: Master Tx
	Start		,	// Start Signal
	Stop		,	// Stop Signal

	IntPendFlag	,
	DataTrans	,	// Data Pending Clear and Next Data Trans 

	//Detect Signal from Detect module

	StartDet	,
	//StopDet		,
	ArbitLostDet	,

	ClkEn		, 	// Clock Working Sign (Started)

	IDSRo		,	// Send Data
	ReadData	,
	AckValue	,
	ReadUpd		,	// from clock module
	WriteUpd	,	// from clock module

//	SDAErrorDet	,	// I2C Bus Error Detect
	SCLWait		,	
	CntIsZero	,

	TxCompInt	,
	RepeatStart ,
	SendStop	,


	ArbitCheck	,
	// Control Signal
	SDA_IN		,
	nSDA_En
);

input			PCLK;
input			PRESETn;

input			SW_RST;

input			AckEn;
input			OpMode;
input			Start;
input			Stop;

input			IntPendFlag;
input			DataTrans;

input			StartDet;
//input			StopDet;
input			ArbitLostDet;

input			ClkEn;

input	[7:0]	IDSRo;
output	[7:0]	ReadData;
output			AckValue;
input			ReadUpd;
input			WriteUpd;

//output			SDAErrorDet;

output			SCLWait;
input			CntIsZero;

output			TxCompInt;

output			RepeatStart;
output			SendStop;

output			ArbitCheck;
input			SDA_IN;
output			nSDA_En;

wire	Start_sig;
wire	Stop_sig;
assign Start_sig = Start & CntIsZero ;
assign Stop_sig = Stop & CntIsZero ;

// SDA Data State

// START -> ADDRESS+R+ACK(R) -> DATAREAD+ACK(W) ... -> STOP
// START -> ADDRESS+W+ACK(R) -> DATAWRITE+ACK(R) ... -> STOP

`define SDA_IDLE 		10'b0000000001
`define SDA_IDLE1 		10'b0000000010
`define SDA_RSTART		10'b0000000100
`define SDA_START		10'b0000001000
`define SDA_DATASHFT	10'b0000010000
`define SDA_ACK			10'b0000100000
`define SDA_ACKIDLE		10'b0001000000
`define SDA_STOP		10'b0010000000
`define SDA_STOP1		10'b0100000000
`define SDA_STOP2		10'b1000000000

//========================================================
// SDA Line Control
//========================================================
wire	OneByteOver;
reg	[9:0]	C_state;
reg [9:0]	N_state;

//wire	BusError;
wire	DataUpd = (~OpMode) ? ReadUpd : WriteUpd; // Rising Falling Select
always @(C_state or Start or Stop or DataUpd or ReadUpd or WriteUpd or 
			/*BusError or*/ DataTrans or OneByteOver or CntIsZero or 
			IntPendFlag or ArbitLostDet or Start_sig or Stop_sig or SW_RST)
begin
	N_state = C_state;
	case (C_state)
	`SDA_IDLE:
		if (~IntPendFlag)
		begin
			if (Stop_sig)
			N_state = `SDA_STOP;
			else if (Start_sig)
			N_state = `SDA_START;	
			else		
			N_state = `SDA_IDLE;
		end

	`SDA_START:
		if (ArbitLostDet|SW_RST)
		N_state = `SDA_IDLE;
		else if (DataUpd) // SCL falling Edge
		N_state = `SDA_DATASHFT;
		else
		N_state = `SDA_START; 

	`SDA_DATASHFT:
		if (ArbitLostDet|SW_RST)		
		N_state = `SDA_IDLE;
		else if (OneByteOver&WriteUpd)
		N_state = `SDA_ACK;
		else 
		N_state = `SDA_DATASHFT;

	`SDA_ACK:
		if (SW_RST)
		N_state = `SDA_IDLE;
		else if (WriteUpd)
			N_state = `SDA_ACKIDLE;

	`SDA_ACKIDLE: // Interrupt Clear Wait State
		if (SW_RST)
		N_state = `SDA_IDLE;
		else if (DataTrans)// Interrupt Clear
		begin
			if (Start)
			N_state = `SDA_IDLE1;
			else if (Stop)
			N_state = `SDA_STOP1;
			else
			N_state = `SDA_DATASHFT;
		end

	`SDA_IDLE1: // Repeat Start
		if (SW_RST)
		N_state = `SDA_IDLE;
		else if (CntIsZero)
		N_state = `SDA_IDLE;

	`SDA_STOP1:
		if (SW_RST)
		N_state = `SDA_IDLE;
		else if (CntIsZero)
		N_state = `SDA_STOP2;

	`SDA_STOP2:
		if (SW_RST)
		N_state = `SDA_IDLE;
		else if (CntIsZero)
		N_state = `SDA_STOP;	
	
	`SDA_STOP:
		N_state = `SDA_IDLE;
	default : N_state = `SDA_IDLE;
	endcase
end
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	C_state <= `SDA_IDLE;
	else
		if (SW_RST)
		C_state <= `SDA_IDLE;
		else
		C_state <= N_state;
end

// 1byte Counter
reg [3:0] ByteCnt;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	ByteCnt <= 0;
	else
		begin
		if (StartDet|~ClkEn|DataTrans|ArbitLostDet|SW_RST)
		ByteCnt <= 0;
		else if (ClkEn&ReadUpd)
		ByteCnt <= ByteCnt+1;
		end
end

assign OneByteOver = (ByteCnt == 8) & ClkEn ;// 1Byte Sent
assign SCLWait	= (C_state == `SDA_ACKIDLE);// &(~DataTrans) ;
assign RepeatStart = (C_state == `SDA_IDLE1);
assign SendStop = (C_state == `SDA_STOP1);
assign ArbitCheck = ((C_state == `SDA_START)|(C_state == `SDA_DATASHFT))&OpMode;



// SDA OUTPUT
reg		[8:0]	DataShiftReg ;
reg		[8:0]	NextDataShiftReg ;
reg		NextnSDA_En;
reg		nSDA_En;
always @(DataShiftReg or ClkEn or 
		C_state or OpMode or AckEn or nSDA_En)
begin
		NextnSDA_En = nSDA_En;
	if (
	
		((OpMode==1'b0)&(C_state==`SDA_ACK)& AckEn)|//RX mode ACK
((ClkEn & ~DataShiftReg[8] & (C_state == `SDA_DATASHFT) & (OpMode==1'b1))//|  // TXMODE
)
		| (C_state==`SDA_START)|(C_state==`SDA_STOP1)|(C_state==`SDA_STOP2)) // Start State 
		NextnSDA_En	= 0;
	else if ( ( (OpMode==1'b0)&~(C_state==`SDA_ACK) )|// RX MODE
  (ClkEn & DataShiftReg[8]&((C_state==`SDA_DATASHFT)&&(OpMode==1'b1)) ) |
			((OpMode==1'b0)&(C_state==`SDA_ACK)& ~AckEn)|//RX mode ACK
			((OpMode==1'b1)&(C_state==`SDA_ACK))| // Tx Mode ACK
			(C_state==`SDA_STOP)|(C_state==`SDA_IDLE1))// Stop State		
		NextnSDA_En = 1;
	else
		NextnSDA_En = 1;
end
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	nSDA_En <= 1;
	else
		if (SW_RST)
		nSDA_En <= 1;
		else
		nSDA_En <= NextnSDA_En;
end



// ReadUpd 	=> rising Edge Update
// WriteUpd => Falling Edge Update
// DATA Shifting

always @(DataShiftReg or C_state or  StartDet or DataTrans or ClkEn or DataUpd or AckEn or IDSRo or SDA_IN)
begin
	NextDataShiftReg = DataShiftReg;
	if (((C_state==`SDA_START)&DataUpd) | DataTrans)
	NextDataShiftReg = {IDSRo,~AckEn};
	else if (ClkEn & DataUpd)
	NextDataShiftReg =  {DataShiftReg[7:0],SDA_IN};
end


always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	DataShiftReg <= 0;
	else
	DataShiftReg <= NextDataShiftReg;
end

reg [7:0]	ReadData;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	ReadData <= 0;
	else if ((N_state==`SDA_ACK)&~(C_state==`SDA_ACK))
	ReadData <= DataShiftReg[7:0];
end

reg AckValue; // Received Ack Value
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	AckValue <=0;
	else if ((C_state==`SDA_ACK)&&(SDA_IN)&&ReadUpd&&(OpMode==1'b1))
	AckValue <= 1'b1;
	else if ((C_state==`SDA_ACK)&&(~SDA_IN)&&ReadUpd&&(OpMode==1'b1))
	AckValue <= 1'b0;
	else 
	AckValue <= AckValue;
end

assign	TxCompInt = (C_state==`SDA_ACK)&(WriteUpd); 

//////////////////////////////////////////////////////////////////////////////

// synopsys translate_off
reg [8*10 : 1] CAState;

always @(C_state)
begin 
  if (C_state == 10'b0000000010)
    CAState = "IDLE1";
  else if (C_state == 10'b000000001)
    CAState = "IDLE";
  else if (C_state == 10'b0000000100)
    CAState = "RSTART";
  else if (C_state == 10'b0000001000)
    CAState = "START";
  else if (C_state == 10'b0000010000)
    CAState = "DATASHFT";
  else if (C_state == 10'b0000100000)
    CAState = "ACK";
  else if (C_state == 10'b0001000000)
    CAState = "ACKIDLE";
  else if (C_state == 10'b0010000000)
    CAState = "STOP";
  else if (C_state == 10'b0100000000)
    CAState = "STOP1";
  else if (C_state == 10'b1000000000)
    CAState = "STOP2";
end

reg [8*10 : 1] NAState;

always @(N_state)
begin 
  if (C_state == 10'b0000000010)
    CAState = "IDLE1";
  else if (N_state == 10'b0000000001)
    NAState = "IDLE";
  else if (N_state == 10'b0000000100)
    NAState = "RSTART";
  else if (N_state == 10'b0000001000)
    NAState = "START";
  else if (N_state == 10'b0000010000)
    NAState = "DATASHFT";
  else if (N_state == 10'b0000100000)
    NAState = "ACK";
  else if (N_state == 10'b0001000000)
    NAState = "ACKIDLE";
  else if (N_state == 10'b0010000000)
    NAState = "STOP";
  else if (N_state == 10'b0100000000)
    NAState = "STOP1";
  else if (N_state == 10'b1000000000)
    NAState = "STOP2";
end
// synopsys translate_on

endmodule
