// ==============================================================================
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DSM_Left.v (Delta Signa Modulator Left)
// File Revision       : 
// ------------------------------------------------------------------------------
//  Purpose            : DAC
// ==============================================================================
// DSM design by MC_Hong 		: 09.12.30
// Multiplier test 				: 10.01.05
// Adder & Subtracter test 		: 10.01.06
// Random test 					: 10.01.09
// first disign complet			: 10.01.12


`timescale 1ns/1ps
module DSM_Left
(
	nReset,			

	DATAINPUTL, 	//I2S FIFO output
	Left_start,
	DSM_SYSCLK,
	MCLK,			//48Kh * 256 Freq

	DSM_OUTDATA_L		//DSM output
);

input 			nReset;
input [23:0]	DATAINPUTL;
input 			Left_start;
input 			DSM_SYSCLK;
input 			MCLK;

output 			DSM_OUTDATA_L;
reg				DSM_OUTDATA_L;


reg [31:0] DelayX1 [1:0];
reg [31:0] DelayX2 [2:0];
reg [31:0] DelayY1 [1:0];
reg [31:0] DelayY2 [2:0];
reg [31:0] DelayY3 [3:0];

reg [31:0] QInput;			// InData + NTF_Error (y)
reg [31:0] QError;					// QInput - 2^19



//NTF Filter Coefficient
parameter [18:0] B1 = 32'd139740;
parameter [18:0] B2 = 32'd229157;
parameter [18:0] B3 = 32'd97096;
parameter [18:0] A1 = 32'd384548;
parameter [18:0] A2 = 32'd295131;
parameter [18:0] A3 = 32'd77667;
parameter [18:0] NORMALIZE = 32'd3;
parameter [18:0] ROUND = 1 << 18;





wire idle; 	
wire ready; 	
wire quantizer;
wire adding;
wire ntf; 		
wire multiply1;
wire multiply2;
wire multiply3;
wire multiply4;

reg nBeforedata;
always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset)
		nBeforedata <= 1;
	else if(Left_start)
		nBeforedata <= 0;
end

//MCLK start 
reg MCLK_delay;
always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset)
		MCLK_delay <= 0;
	else if(MCLK) 
		MCLK_delay <= 1;
	else 
		MCLK_delay <= 0;
end
// state machine
parameter   DSM_IDLE	  		=	0;  
parameter   DSM_READY	  		=	1;  
parameter   DSM_QUANTIZER 		=	2;
parameter   DSM_ADDING1			=	3;

parameter   DSM_NTF		  		=	4;  
parameter   DSM_MULTIPLIY1		= 	5;  
parameter   DSM_MULTIPLIY2		= 	6;  
parameter   DSM_MULTIPLIY3		= 	7;  
parameter   DSM_MULTIPLIY4		= 	8;  

reg	  [8:0] state;
reg	  [9:0] next;

always @(posedge DSM_SYSCLK or negedge nReset)
begin
	if(!nReset) 
		state <= 1;
	else
		state <= next;
end

wire MCLK_adding_start;
assign MCLK_adding_start = (!MCLK & MCLK_delay & !nBeforedata & !Left_start & ready)|multiply3; //100Mhz system frequency 
//assign MCLK_adding_start = (!MCLK & MCLK_delay & !nBeforedata & !Left_start & ready); 		//200Mhz system frequency

reg adding_start_enable;
always @(posedge DSM_SYSCLK or negedge nReset) 
	if(!nReset)
		adding_start_enable <= 1'b0;
	else if(MCLK_adding_start) 
		adding_start_enable <= 1'b1;


wire MCLK_multiply_start;
assign MCLK_multiply_start = MCLK & !MCLK_delay & !nBeforedata &  adding_start_enable;







// 연산 중 reset이 되어도 한 cycle 연산은 진행된다.
always @(state or MCLK_multiply_start or nReset)
begin
next = 0;
	case(1'b1)		// synopsys parallel_case full_case
	
	state[DSM_IDLE]:
	begin
		if(nReset)
			next[DSM_READY] = 1'b1;
		else 
			next[DSM_IDLE] = 1'b1;
	end

	state[DSM_READY]:
	begin
		if(!nReset)
			next[DSM_IDLE] = 1'b1;	
		else if(MCLK_multiply_start)
			next[DSM_QUANTIZER] = 1'b1;
		else 
			next[DSM_READY] = 1'b1;
	end

	state[DSM_QUANTIZER]:
	begin
		if(!nReset)
			next[DSM_IDLE] = 1'b1;
		else
			next[DSM_ADDING1] = 1'b1;
	end

	state[DSM_ADDING1]:
		next[DSM_NTF] = 1'b1;

	state[DSM_NTF]:
		next[DSM_MULTIPLIY1] = 1'b1;

	state[DSM_MULTIPLIY1]:
		next[DSM_MULTIPLIY2] = 1'b1;
		
	state[DSM_MULTIPLIY2]:
		next[DSM_MULTIPLIY3] = 1'b1;
		
	state[DSM_MULTIPLIY3]:
		next[DSM_MULTIPLIY4] = 1'b1;
	
	state[DSM_MULTIPLIY4]:
		next[DSM_READY] = 1'b1;

	endcase
end



assign idle 		= next[DSM_IDLE];
assign ready		= next[DSM_READY];
assign quantizer 	= next[DSM_QUANTIZER];
assign adding 		= next[DSM_ADDING1];
assign ntf 			= next[DSM_NTF];
assign multiply1 	= next[DSM_MULTIPLIY1];
assign multiply2 	= next[DSM_MULTIPLIY2];
assign multiply3 	= next[DSM_MULTIPLIY3];
assign multiply4 	= next[DSM_MULTIPLIY4];



// For Debugging
reg   [8:0] oversample_times;
reg   [8:0] oversample_cnt;
reg   [24:0] full_cnt;
always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset)
		oversample_times <= 0;
	else if(oversample_cnt == 257)
		oversample_times <= oversample_times + 1;
end	

always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset)begin
		oversample_cnt <= 0;
		full_cnt <= 0;
	end
	else if(oversample_cnt == 257)begin
		oversample_cnt <= 1;
		full_cnt <= full_cnt;
	end
//	else if(quantizer) begin
	else if(MCLK_adding_start && !ready) begin  //3-22
//	else if(MCLK_adding_start) begin
		oversample_cnt <= oversample_cnt + 1; 
		full_cnt <= full_cnt + 1;	
	end
end
wire over = (oversample_cnt <= 128)? 1 : 0;

reg   [24:0] full_cnt_1;
always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset)begin
		full_cnt_1 <= 0;
	end
	else if(MCLK_multiply_start && !ready) begin
		full_cnt_1 <= full_cnt_1 + 1;	
	end
end


// Input data
wire signed [23:0] 		DATAINPUTL;			// Data Register




// DSM Quantization
parameter [24:0] CONSTANT = (1<<24);




//wire signed [55:0] tempB1;
//wire signed [55:0] tempB2;
//wire signed [55:0] tempB3;
//wire signed [55:0] tempA1;
//wire signed [55:0] tempA2;
//wire signed [55:0] tempA3;
wire signed [31:0] totalA;
wire signed [31:0] totalB;
wire signed [31:0] SUM;

wire signed [31:0] SHAPING_OUT;


wire signed [19:0] in1_B1 = B1;
wire signed [31:0] in2 = QError;
wire signed [55:0] M = in1_B1 * in2;
wire signed [55:0] MnR = M + ROUND;
wire signed [36:0] tempB1 = (multiply1)? MnR>>19 : 0;

wire signed [19:0] in1_B2 = B2;
wire signed [31:0] in2_X1 = DelayX1[1];
wire signed [55:0] M1 = in1_B2 * in2_X1;
wire signed [55:0] MnR1 = M1 + ROUND;
wire signed [36:0] tempB2 = (multiply1)? MnR1>>19 : 0;

wire signed [19:0] in1_B3 = B3;
wire signed [31:0] in2_X2 = DelayX2[2];
wire signed [55:0] M2 = in1_B3 * in2_X2;
wire signed [55:0] MnR2 = M2 + ROUND;
wire signed [36:0] tempB3 = (multiply1)? MnR2>>19 : 0;

assign totalB = (tempB1 - tempB2 + tempB3);




wire signed [19:0] in1_A1 = A1;
wire signed [31:0] in2_Y1 = DelayY1[1];
wire signed [55:0] M3 = in1_A1 * in2_Y1;
wire signed [55:0] MnR3 = M3 + ROUND;
wire signed [36:0] tempA1 = (multiply1)? MnR3>>19 : 0;

wire signed [19:0] in1_A2 = A2;
wire signed [31:0] in2_Y2 = DelayY2[2];
wire signed [55:0] M4 = in1_A2 * in2_Y2;
wire signed [55:0] MnR4 = M4 + ROUND;
wire signed [36:0] tempA2 = (multiply1)? MnR4>>19 : 0;

wire signed [19:0] in1_A3 = A3;
wire signed [31:0] in2_Y3 = DelayY3[3];
wire signed [55:0] M5 = in1_A3 * in2_Y3;
wire signed [55:0] MnR5 = M5 + ROUND;
wire signed [36:0] tempA3 = (multiply1)? MnR5>>19 : 0;

assign totalA = (tempA1 - tempA2 + tempA3);


//assign tempB1 = (ntf)? ((B1 * QError) + ROUND)>>19 : 0;
//assign tempB2 = (ntf)? ((B2 * DelayX1[1]) + ROUND)>>19 : 0;
//assign tempB3 = (ntf)? ((B3 * DelayX2[2]) + ROUND)>>19 : 0;

//assign tempA1 = (ntf)? ((A1 * DelayY1[1]) + ROUND)>>19: 0;
//assign tempA2 = (ntf)? ((A2 * DelayY2[2]) + ROUND)>>19: 0;
//assign tempA3 = (ntf)? ((A3 * DelayY3[3]) + ROUND)>>19: 0;


assign SUM =  (totalA + totalB);
assign SHAPING_OUT = SUM * NORMALIZE;



reg signed [31:0] NTF_Error;				// NTF Error output
always @(posedge DSM_SYSCLK or negedge nReset)
	if(!nReset)
		NTF_Error <= 0;
	else if(multiply1)
		NTF_Error <= SHAPING_OUT;



reg [31:0] ADDReg1;
reg [31:0] ADDReg2;
reg [31:0] SReg1;

wire signed [23:0] add = ADDReg1[23:0]; 

always @(posedge DSM_SYSCLK or negedge nReset)
	if(!nReset)
		ADDReg1 <= 0;
	else if(MCLK_adding_start)
		ADDReg1 <= DATAINPUTL + NTF_Error;


always @(posedge DSM_SYSCLK or negedge nReset) 
	if(!nReset) 
		QInput <= 0;
	else if(MCLK_multiply_start) //quantizer 
		QInput <= ADDReg1;


always @(posedge DSM_SYSCLK or negedge nReset)begin
	if(!nReset)begin
		ADDReg2 <= 0;
		SReg1 <= 0;
	end
	else if(adding) begin
		ADDReg2 <= QInput + CONSTANT;
		SReg1 <= QInput - CONSTANT;
	end
end


	

always @(posedge DSM_SYSCLK or negedge nReset) 
	if(!nReset) 
		QError <= 0;
	else if(ntf) begin
		if(QInput[31] != 1)  
			QError <= SReg1;
		else 
			QError <= ADDReg2;
	end


always @(posedge DSM_SYSCLK or negedge nReset) 
	if(!nReset) 
		DSM_OUTDATA_L <= 0;
	else if(nBeforedata)
		DSM_OUTDATA_L <= 0;
	else if(QInput[31] != 1)
		DSM_OUTDATA_L <= 1;
	else 
		DSM_OUTDATA_L <= 0;

reg [8:0] DATA_COUNTER;
always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset) 
		DATA_COUNTER <=0;
	else if(oversample_cnt == 256)
		DATA_COUNTER <=0;
	else if(!ready & MCLK_adding_start)begin
		if(DSM_OUTDATA_L)
			DATA_COUNTER <= DATA_COUNTER + 1;
		else
			DATA_COUNTER <= DATA_COUNTER - 1;
	end
end


reg [8:0] DATA_ADD;
always @(posedge DSM_SYSCLK or negedge nReset) 
	if(!nReset) 
		DATA_ADD <=0;
	else if(multiply4 && (oversample_cnt == 256))
		DATA_ADD <= DATA_COUNTER;	




always @(posedge DSM_SYSCLK or negedge nReset) begin
	if(!nReset) begin
		DelayX1[0] <= 0;
		DelayX1[1] <= 0;
	
		DelayX2[0] <= 0;
		DelayX2[2] <= 0;
		DelayX2[1] <= 0;

		DelayY1[0] <= 0;
		DelayY1[1] <= 0;
		
		DelayY2[0] <= 0;
		DelayY2[2] <= 0;
		DelayY2[1] <= 0;

		DelayY3[0] <= 0;
		DelayY3[3] <= 0;
		DelayY3[2] <= 0;
		DelayY3[1] <= 0;
	end
//	else if(ntf) begin
	else if(multiply4) begin
		DelayX1[1] <= QError;
	
		DelayX2[1] <= QError;
		DelayX2[2] <= DelayX2[1];
		
		DelayY1[1] <= NTF_Error;
		
		DelayY2[1] <= NTF_Error;
		DelayY2[2] <= DelayY2[1];

		DelayY3[1] <= NTF_Error;
		DelayY3[3] <= DelayY3[2];
		DelayY3[2] <= DelayY3[1];

	end
end


endmodule

