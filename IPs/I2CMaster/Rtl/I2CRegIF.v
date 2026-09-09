// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : I2CRegIF.v
// File Revision       : Ver 3.0
// Revision History    : 
// 
//  ----------------------------------------------------------------
//  Purpose            : I2C Register Interface Block
//  ----------------------------------------------------------------

`timescale 1ns/1ps
module I2CRegIF
(
	//APB
	PCLK         , 
	PRESETn      , 
	PENABLE      , 
	PSEL         , 
	PWRITE       , 
	PADDR        , 
	PWDATA       ,
	PRDATA       ,

	//input	
	BusyDet		,  // Bus Busy Detected
	//StartDet	,
	StopDet		,
	ArbitLostDet,
	
	TxCompInt	,	

	AckValue	,
	//Control Signal
	AckEn		, 
	//TxClkSel	, 
	IntPendFlag	, 
	IntPendClr	,
	TxClkVal	,
	//HsPreVal	,


	OpMode		,
	Start		,
	Stop		,
	StartClr	,
	StopClr		,

//	IAR			,
//	IAR_1		,
	IDSRo		,
	ReadData	,
	SW_RST		, // Soft Reset

	// Interrupt Signal
	int		//	,

//	int_aas		
);

//`define HSMODE_SUPPORT

//APB
	input          PCLK        ;     
	input          PRESETn     ;    
	input          PENABLE     ;   
	input          PSEL        ;  
	input          PWRITE      ; 
	input  [1:0]   PADDR       ; 
	input  [31:0]  PWDATA      ; 
	output [31:0]  PRDATA      ;


	input	BusyDet		; // I2C Bus Busy Signal 
//	input	StartDet	;
	input	StopDet		;
	input	ArbitLostDet; // Arbitration Lost Detect

	input	TxCompInt	;

	input	AckValue	;

	output		AckEn		;
//	output		TxClkSel	;
	output		IntPendFlag	;
	output		IntPendClr	;
	output	[11:0]	TxClkVal	;

	//output [5:0]	HsPreVal	; // HS-Mode Prescaler Value Setting
	output 			OpMode		; // Operation Mode Select
	
	output			Start		; // Transmit Start
	output			Stop		; // Transmit Start
	input			StartClr	;
	input			StopClr		;

	//output [6:0]	IAR			; // Slave Address for 7bit/10bit Addressing
	//output [1:0]	IAR_1		; // Extend Slave Address for 10bit Addressing
	output [7:0]	IDSRo		; // IDSR	
	input  [7:0]	ReadData	;

	output			SW_RST		;
	output			int			;
	//output			int_aas		;


	//wire			int_aas	=0;

`define ICCR0Addr	2'b00
`define ICSRAddr	2'b01
`define IDSRAddr	2'b10

wire	NextICCR0_r	= PSEL & ~PENABLE & ~PWRITE & (PADDR[1:0]== `ICCR0Addr);
wire	NextICSR_r 	= PSEL & ~PENABLE & ~PWRITE & (PADDR[1:0]== `ICSRAddr);
wire	NextIDSR_r 	= PSEL & ~PENABLE & ~PWRITE & (PADDR[1:0]== `IDSRAddr);
wire	ICCR0_w		= PSEL & PENABLE  & PWRITE  & (PADDR[1:0]== `ICCR0Addr);
wire	ICSR_w 		= PSEL & PENABLE  & PWRITE  & (PADDR[1:0]== `ICSRAddr);
wire	IDSR_w 		= PSEL & PENABLE  & PWRITE  & (PADDR[1:0]== `IDSRAddr);
                         

//////////////////////////////////////////////////////
//	ICCR0 Register
//	I2C Bus Control Register Setting
//////////////////////////////////////////////////////
//for another module control
	reg			AckEn;
	reg			TxRxIntEn;
	reg	[11:0]	TxClkVal;
	reg			OpMode;
	reg			SW_RST;

	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		begin
		OpMode		<= 1;
		AckEn 		<= 0; // Acknowledge  1: Acknowledge==0, 0:Acknowledge ==1
		TxRxIntEn	<= 0; // Interrupt Enable
		TxClkVal	<= 0; // Prescaler Value Setting
		end
		else if (ICCR0_w)
		begin
		OpMode		<= PWDATA[2];
		AckEn 		<= PWDATA[1];
		TxRxIntEn	<= PWDATA[0];
		TxClkVal	<= PWDATA[15:4];
		end
	end

	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		SW_RST <= 1'b0;
		else if ((ICCR0_w)&PWDATA[16])
		SW_RST <= 1'b1;
		else
		SW_RST <= 1'b0;
	end

	wire	IntPendClr;	
	wire	IntPendSet;
	assign	IntPendSet = TxCompInt | StopDet| ArbitLostDet;
	
	assign IntPendClr = (ICCR0_w)& PWDATA[3];// Interrupt Clear for Next Step
	reg	IntPendFlag;
	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		IntPendFlag <= 0;
		else if (SW_RST)
		IntPendFlag <= 0;
		else if (IntPendClr) 
		IntPendFlag <= 0;
		else if (IntPendSet)// 1byte trans , General call or match, arbitration fail
		IntPendFlag <= 1;
	end

	reg	ArbSta;
	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		ArbSta <= 1'b0;
		else if (SW_RST)
		ArbSta <= 1'b0;
		else if (IntPendClr)
		ArbSta <= 1'b0;	
		else if (ArbitLostDet)
		ArbSta <= 1'b1;
	end
//////////////////////////////////////////////////////
//	ICSR Register
//	I2C control/Status Register Setting
//////////////////////////////////////////////////////

	reg	Start;
	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		Start	<= 1'b0; // 0: Stop Gen 1: Start Gen
		else if (SW_RST)
		Start	<= 1'b0;
		else if (ICSR_w & PWDATA[4])
		Start	<=  1'b1;
		else if (StartClr)
		Start	<= 1'b0;
	end

	reg	Stop;
	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		Stop	<= 1'b0; // 0: Stop Gen 1: Start Gen
		else if (SW_RST)
		Stop	<= 1'b0;
		else if (ICSR_w & ~PWDATA[4])
		Stop	<= 1'b1;
		else if (StopClr)
		Stop	<= 1'b0;
	end


	reg	BusError;
	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
			BusError <= 1'b0;
		else if (SW_RST|IntPendClr)
			BusError <= 1'b0;
		else if (OpMode&AckValue&TxCompInt)
			BusError <= 1'b1;
	end



//////////////////////////////////////////////////////
//	IDSR Register
//	I2C Data Shift Register Setting
//////////////////////////////////////////////////////

	reg	[7:0]	IDSRo;
	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		IDSRo 		<= 2'b00;
		else if (IDSR_w)// & 
		IDSRo		<= PWDATA[7:0];
	end


//////////////////////////////////////////////////////
//	I2C Register Read
//////////////////////////////////////////////////////
wire	AckValue;
wire	[7:0]	IDSR_i;
wire	BusBusy;
assign  BusBusy = BusyDet;
assign 	IDSR_i = ReadData;

reg		[31:0]	NextPRDATA;
reg		[31:0]	PRDATA;
	
	always @(PRDATA or NextICCR0_r or NextICSR_r or NextIDSR_r or
			 AckEn or/* TxClkSel or*/ TxRxIntEn or IntPendFlag or TxClkVal or
			OpMode or BusBusy or AckValue or BusError or ArbSta or IDSR_i)
	begin
		NextPRDATA = PRDATA;
		case(1'b1) // synopsys parallel_case full_case
		NextICCR0_r	:NextPRDATA = {16'd0, TxClkVal, IntPendFlag, OpMode,  AckEn, TxRxIntEn};
		NextICSR_r	:NextPRDATA = {24'd0,2'b00,1'b0, 1'b0, BusBusy,
									 ArbSta, AckValue, BusError} ;
		NextIDSR_r	:NextPRDATA = {IDSR_i} ;
		default		:NextPRDATA = PRDATA; // for AXI bus Implementation 2007 5 3
		endcase
	end

	always @(posedge PCLK or negedge PRESETn)
	begin
		if (!PRESETn)
		PRDATA <= 0;
		else
		PRDATA <= NextPRDATA;
	end


//////////////////////////////////////////////////////
//	I2C  Interrupt Output
//////////////////////////////////////////////////////

assign int 	=	TxRxIntEn & (IntPendFlag);

endmodule
