// ==============================================================================
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DSM_DelayDataBlock.v
// File Revision       : 
// ------------------------------------------------------------------------------
//  Purpose            : For  DSM(Right Left) Input Data 
// ==============================================================================
// DSM Delay Data Block Design	: 10.0.1.11

`timescale 1ns/1ps
module DSM_DelayDataBlock
(
		CLK,
		DATAINPUT_R,
		DATAINPUT_L,
		RightLoadSignal,
		nReset,
		MCLK,		
		START_data_true,
//		DSM_sysclk,

		DSM_INDATA_R,
		DSM_INDATA_L
);

input         CLK;

input	[31:0]	DATAINPUT_R;
input	[31:0]	DATAINPUT_L;
input			RightLoadSignal;
input			nReset;

input        	MCLK;

output  [23:0]  DSM_INDATA_R;
output  [23:0]  DSM_INDATA_L;
output  START_data_true;
//output  DSM_sysclk;



wire [31:0] DATAINPUT_R; 
wire [31:0] DATAINPUT_L; 
wire CLK;
wire nReset;
wire MCLK;
wire RightLoadSignal;

wire TwoDataOutput_Timing;
wire Lbuffer_datainput;

//wire DSM_sysclk;
//assign DSM_sysclk = CLK;

reg  [23:0] DSM_INDATA_R;
reg  [23:0] DSM_INDATA_L;

reg datastorage;
reg datastorage_delay;
reg Rbuffer_datainput;
reg TwoDataOutput_en;
reg [23:0] DelayBufferR;
reg [23:0] DelayBufferL;

reg RightLoadSignal_delay1;
reg RightLoadSignal_delay2;
reg RightLoadSignal_delay3;

reg MCLK_delay;


assign TwoDataOutput_Timing = datastorage & !datastorage_delay;
assign Lbuffer_datainput = !datastorage & datastorage_delay;
wire ITs_Timing = TwoDataOutput_Timing | Lbuffer_datainput;

//wire START_data = TwoDataOutput_Timing & TwoDataOutput_en;
wire START_data = ITs_Timing & TwoDataOutput_en;

wire START_data_true = START_data;


wire MCLK_en;
assign MCLK_en = MCLK & !MCLK_delay;




///////////////////////////////////////////////////////////////////////////////
reg RLSignal_1;
always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RLSignal_1 <= 0;
	else if(RightLoadSignal)
		RLSignal_1 <= 1;
	else 
		RLSignal_1 <= 0;

reg RLSignal_2;
always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RLSignal_2 <= 0;
	else if(RLSignal_1)
		RLSignal_2 <= 1;
	else 
		RLSignal_2 <= 0;

reg RLSignal_3;
always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RLSignal_3 <= 0;
	else if(RLSignal_2)
		RLSignal_3 <= 1;
	else 
		RLSignal_3 <= 0;


wire RLSignal = !RightLoadSignal & !RLSignal_1 & !RLSignal_2 & RLSignal_3;

reg RLSignal_en;
always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RLSignal_en <= 0;
	else if(RLSignal)
		RLSignal_en <= 1;
	else if(MCLK_en)
		RLSignal_en <= 0;


reg RLSignal_en_delay;
always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RLSignal_en_delay <= 0;
	else if(RLSignal_en)
		RLSignal_en_delay <= 1;
	else 
		RLSignal_en_delay <= 0;

wire RightLoadSignal_true = !RLSignal_en & RLSignal_en_delay;
///////////////////////////////////////////////////////////////////////////////


always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RightLoadSignal_delay1 <= 0;
//	else if(RightLoadSignal)
	else if(RightLoadSignal_true)
		RightLoadSignal_delay1 <= 1;
	else 
		RightLoadSignal_delay1 <= 0;

always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RightLoadSignal_delay2 <= 0;
	else if(RightLoadSignal_delay1)
		RightLoadSignal_delay2 <= 1;
	else 
		RightLoadSignal_delay2 <= 0;

always @(posedge CLK or negedge nReset) 
	if(!nReset)
		RightLoadSignal_delay3 <= 0;
	else if(RightLoadSignal_delay2)
		RightLoadSignal_delay3 <= 1;
	else 
		RightLoadSignal_delay3 <= 0;

always @(posedge CLK or negedge nReset) 
	if(!nReset)
		datastorage <= 0;	
	else if(!RightLoadSignal_delay1 & !RightLoadSignal_delay2 & RightLoadSignal_delay3)
		datastorage <= datastorage + 1;
	else 
		datastorage <= datastorage;	

always @(posedge CLK or negedge nReset) 
	if(!nReset)
		datastorage_delay <= 0;	
	else if(datastorage)
		datastorage_delay <= 1;
	else 
		datastorage_delay <= 0;	

always @(posedge CLK or negedge nReset) 
	if(!nReset)
		Rbuffer_datainput <= 0;	
	else if(TwoDataOutput_Timing)
		Rbuffer_datainput <= 1;
	else 
		Rbuffer_datainput <= 0;	



always @(posedge CLK or negedge nReset) 
	if(!nReset) 
		DelayBufferR <= 1'b0;
	else if(ITs_Timing == 1) 
//	else if(Rbuffer_datainput == 1) 
		DelayBufferR <= DATAINPUT_R[23:0];
	//	DelayBufferR <= DATAINPUT_R[31:8];
	else 
		DelayBufferR <= DelayBufferR;

always @(posedge CLK or negedge nReset) 
	if(!nReset) 
		DelayBufferL <= 1'b0;
	else if(ITs_Timing == 1) 
//	else if(Lbuffer_datainput == 1) 
		DelayBufferL <= DATAINPUT_L[23:0];
	//	DelayBufferL <= DATAINPUT_L[31:8];
	else 
		DelayBufferL <= DelayBufferL;

always @(posedge CLK or negedge nReset) 
	if(!nReset) 
		TwoDataOutput_en <= 0;
	else if(Rbuffer_datainput)
		TwoDataOutput_en <= 1;

always @(posedge CLK or negedge nReset)begin 
	if(!nReset)begin
		DSM_INDATA_R <= 0;	
		DSM_INDATA_L <= 0; 	
	end
	else if(START_data)begin	
//	else if(START_data_true)begin	
		DSM_INDATA_R <= DelayBufferR;	
		DSM_INDATA_L <= DelayBufferL; 	
	end
end


always @(posedge CLK or negedge nReset) 
	if(!nReset)
		MCLK_delay <= 0;
	else if(MCLK) 
		MCLK_delay <= 1;
	else 
		MCLK_delay <= 0;


//debugging
reg [15:0] data_cnt;
always @(posedge CLK or negedge nReset) 
	if(!nReset) 
		data_cnt <= 0;
	else if(!RightLoadSignal_delay2 && RightLoadSignal_delay3)
		data_cnt <= data_cnt + 1;


endmodule

