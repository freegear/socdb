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
                
                VIDControlPCLK,
                LCDTiming0PCLK,
                LCDTiming1PCLK,
                LCDTiming2PCLK,
                LCDTiming3PCLK,
                LCDControlPCLK,
// Outputs
`ifdef BYPASS
				VideoBP,
				VideoBPWait,
`endif
				
                LcdEn,
                LcdBPP,
                BGR,
                LcdPwrEn ,
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
                CPL
);

// Inputs
input           LCDCLK;        	// Lcd Clock input
input           nRST;    		// Reset signal - LCDCLK domain

input	[12:0]	VIDControlPCLK;
input   [15:0] 	LCDTiming0PCLK;       // TimingReg0 write enable - SYSCLK domain
input   [19:0] 	LCDTiming1PCLK;       // TimingReg1 write enable - SYSCLK domain
input   [15:0] 	LCDTiming2PCLK;       // TimingReg2 write enable - SYSCLK domain
input   [16:0] 	LCDTiming3PCLK;
input   [12:4] 	LCDControlPCLK;        // LcdControlReg write enable - SYSCLK domain

// Outputs
`ifdef BYPASS
output			VideoBP;
output  [11:0]	VideoBPWait;
`endif

output          LcdEn;          // Lcd enable bit from control reg
output  [02:00] LcdBPP;         // Lcd Bits Per Pixel
output          BGR;            // Select between normal or swapped output
output          LcdPwrEn;       // LCD Power enable
output  [08:00] HSW;            // Horz Sync Pulse width value
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

reg  [12:0]  VIDControlLCDCLK;
reg  [15:0]  LCDTiming0LCDCLK;
reg  [19:0]  LCDTiming1LCDCLK;
reg  [15:0]  LCDTiming2LCDCLK;
reg  [16:0]  LCDTiming3LCDCLK;
reg  [12:4]  LCDControlLCDCLK;

reg  [12:0]  VIDControl;
reg  [15:0]  LCDTiming0;
reg  [19:0]  LCDTiming1;
reg  [15:0]  LCDTiming2;
reg  [16:0]  LCDTiming3;
reg  [12:4]  LCDControl;

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
           			
assign HSW 			= LCDTiming1[19:11];
assign CPL 			= LCDTiming1[10: 0];
           			
assign VBP 			= LCDTiming2[15: 8];
assign VFP 			= LCDTiming2[ 7: 0];
           			
assign VSW 			= LCDTiming3[16:11];
assign LPS 			= LCDTiming3[10: 0];

assign LcdEn        = LCDControl[12];
assign LcdPwrEn     = LCDControl[11];
assign LcdBPP       = LCDControl[10:8];
assign BGR          = LCDControl[7];
assign IEO 			= LCDControl[6];
assign IVS 			= LCDControl[5];
assign IHS 			= LCDControl[4];

`ifdef BYPASS
assign VideoBP		= VIDControl[12];
assign VideoBPWait	= VIDControl[11:0];
`endif
// -----------------------------------------------------------------------------
// Generation of one clock delayed version of register.
// -----------------------------------------------------------------------------
always @ (posedge LCDCLK or negedge nRST)
	if (!nRST) begin
		VIDControlLCDCLK  <= 0;
		LCDTiming0LCDCLK  <= {16{1'b1}};
		LCDTiming1LCDCLK  <= {9'd511, 11'd2047};
		LCDTiming2LCDCLK  <= {16{1'b1}};
		LCDTiming3LCDCLK  <= {6'd15, 11'd2047};
		LCDControlLCDCLK  <= 0;
	end
	else begin
	    VIDControlLCDCLK  <= VIDControlPCLK;
	    LCDTiming0LCDCLK  <= LCDTiming0PCLK;
	    LCDTiming1LCDCLK  <= LCDTiming1PCLK;
	    LCDTiming2LCDCLK  <= LCDTiming2PCLK;
	    LCDTiming3LCDCLK  <= LCDTiming3PCLK;
	    LCDControlLCDCLK  <= LCDControlPCLK;
	  end

// ---------------------------------------------------------------------------
// registering the next state inputs
// ---------------------------------------------------------------------------
always @(posedge LCDCLK or negedge nRST) 
	if (!nRST) begin
	    VIDControl <= 0;
	    LCDTiming0 <= {16{1'b1}};
	    LCDTiming1 <= {9'd511, 11'd2047};
	    LCDTiming2 <= {16{1'b1}};
	    LCDTiming3 <= {6'd15, 11'd2047};
	    LCDControl <= 0;
	end
	else begin
	    VIDControl <= VIDControlLCDCLK;
	    LCDTiming0 <= LCDTiming0LCDCLK;
	    LCDTiming1 <= LCDTiming1LCDCLK;
	    LCDTiming2 <= LCDTiming2LCDCLK;
	    LCDTiming3 <= LCDTiming3LCDCLK;
	    LCDControl <= LCDControlLCDCLK;
	end

endmodule

// --================================== End ==================================--
