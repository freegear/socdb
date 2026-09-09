// --=========================================================================--

//  ----------------------------------------------------------------------------
//  Purpose                : This module double synchronises the signals 
//                           entering the LcdClk clock domain from SYSCLK clock 
//                           domain. It also has control and timing registers in
//                           LCDCLK clock domain.
//
// --=========================================================================--
 
`timescale 1ns/1ps
// ----------------------------------------------------------------------------
 
module LcdReg (
// Inputs		
                LCDCLK,
                nRST,
                
                LCDTiming0PCLK,
                LCDTiming1PCLK,
                LCDTiming2PCLK,
                LCDTiming3PCLK,
                LCDControlPCLK,
                LcdLineEndPCLK,
// Outputs
                LcdEn,
                LcdBPP,
                BGR,
                LcdPwrEn ,
                LcdVComp,
                HSW,
                HFP,
                HBP,
                LPS,
                VSW,
                VFP,
                VBP,
                IVS,
                IHS,
                IEO,
                CPL,
                LED,
                LEE
);

// Inputs
input           LCDCLK;        	// Lcd Clock input
input           nRST;    		// Reset signal - LCDCLK domain
input   [31:0] 	LCDTiming0PCLK;       // TimingReg0 write enable - SYSCLK domain
input   [31:0] 	LCDTiming1PCLK;       // TimingReg1 write enable - SYSCLK domain
input   [31:0] 	LCDTiming2PCLK;       // TimingReg2 write enable - SYSCLK domain
input   [31:0] 	LCDTiming3PCLK;
input   [31:0] 	LCDControlPCLK;        // LcdControlReg write enable - SYSCLK domain
input   [31:0] 	LcdLineEndPCLK;

// Outputs
output          LcdEn;          // Lcd enable bit from control reg
output  [01:00] LcdBPP;         // Lcd Bits Per Pixel
output          BGR;            // Select between normal or swapped output
output          LcdPwrEn;       // LCD Power enable
output  [01:00] LcdVComp;       // Used to generate interrupt at diff positions
output  [07:00] HSW;            // Horz Sync Pulse width value
output  [07:00] HFP;            // Horz Front Porch value
output  [07:00] HBP;            // Vert Back  Porch value
output  [10:00] LPS;            // Lines per panel value
output  [05:00] VSW;            // Vert Sync Pulse width value
output  [07:00] VFP;            // Vert Front Porch value
output  [07:00] VBP;            // Vert Back  Porch value
output          IVS;            // Invert Vsync
output          IHS;            // Invert Hsync
output          IEO;            // Invert Output Enable
output  [10:00] CPL;            // Clocks Per Line
output  [06:00] LED;            // Line-End signal delay
output          LEE;            // Line End Enable

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module includes the following
// - D-type flip-flops for double synchronisation of control signals.
// - LcdControl, LcdTiming0, LcdTiming1, LcdTiming2 and LcdTiming3 registers
//   with write control logic.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declaration
// -----------------------------------------------------------------------------

reg  [31:0]  LCDTiming0LCDCLK;
reg  [31:0]  LCDTiming1LCDCLK;
reg  [31:0]  LCDTiming2LCDCLK;
reg  [31:0]  LCDTiming3LCDCLK;
reg  [31:0]  LCDControlLCDCLK;
reg  [31:0]  LcdLineEndLCDCLK;

reg  [31:0]  LCDTiming0;
reg  [31:0]  LCDTiming1;
reg  [31:0]  LCDTiming2;
reg  [31:0]  LCDTiming3;
reg  [31:0]  LCDControl;
reg  [31:0]  LcdLineEnd;

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
 
// ----------------------------------------------------------------------------
// Register bit assignments
// ----------------------------------------------------------------------------
assign HBP 			= LCDTiming0[15: 8];
assign HFP 			= LCDTiming0[ 7: 0];
           			
assign HSW 			= LCDTiming1[18:11];
assign CPL 			= LCDTiming1[10: 0];
           			
assign VBP 			= LCDTiming2[15: 8];
assign VFP 			= LCDTiming2[ 7: 0];
           			
assign VSW 			= LCDTiming3[16:11];
assign LPS 			= LCDTiming3[10: 0];

assign LcdVComp  	= LcdLineEnd[9:8];
assign LED 			= LcdLineEnd[6:0];
assign LEE 			= LcdLineEnd[7];

assign LcdEn        = LCDControl[31];
assign LcdPwrEn     = LCDControl[30];
assign LcdBPP       = LCDControl[9:8];
assign BGR          = LCDControl[7];
assign IEO 			= LCDControl[6];
assign IVS 			= LCDControl[5];
assign IHS 			= LCDControl[4];

// -----------------------------------------------------------------------------
// Generation of one clock delayed version of register.
// -----------------------------------------------------------------------------
always @ (posedge LCDCLK or negedge nRST)
	if (!nRST) begin
		LCDTiming0LCDCLK  <= 1'b0;
		LCDTiming1LCDCLK  <= 1'b0;
		LCDTiming2LCDCLK  <= 1'b0;
		LCDTiming3LCDCLK  <= 1'b0;
		LCDControlLCDCLK  <= 1'b0;
		LcdLineEndLCDCLK  <= 1'b0;
	end
	else begin
	    LCDTiming0LCDCLK  <= LCDTiming0PCLK;
	    LCDTiming1LCDCLK  <= LCDTiming1PCLK;
	    LCDTiming2LCDCLK  <= LCDTiming2PCLK;
	    LCDTiming3LCDCLK  <= LCDTiming3PCLK;
	    LCDControlLCDCLK  <= LCDControlPCLK;
	    LcdLineEndLCDCLK  <= LcdLineEndPCLK;
	  end

// ---------------------------------------------------------------------------
// registering the next state inputs
// ---------------------------------------------------------------------------
always @(posedge LCDCLK or negedge nRST) 
	if (!nRST) begin
	    LCDTiming0 <= {32{1'b0}};
	    LCDTiming1 <= {21'b0, 11'd2047};
	    LCDTiming2 <= {32{1'b0}};
	    LCDTiming3 <= {21'b0, 11'd2047};
	    LcdLineEnd <= {32{1'b0}};
	    LCDControl <= {32{1'b0}};
	end
	else begin
	    LCDTiming0 <= LCDTiming0LCDCLK;
	    LCDTiming1 <= LCDTiming1LCDCLK;
	    LCDTiming2 <= LCDTiming2LCDCLK;
	    LCDTiming3 <= LCDTiming3LCDCLK;
	    LcdLineEnd <= LcdLineEndLCDCLK;
	    LCDControl <= LCDControlLCDCLK;
	end

endmodule

// --================================== End ==================================--
