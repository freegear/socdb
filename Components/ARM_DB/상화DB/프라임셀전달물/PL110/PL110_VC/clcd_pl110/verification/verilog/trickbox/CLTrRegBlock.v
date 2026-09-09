// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : CLTrRegBlock.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Purpose : CLCD Trickbox Register Block
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module CLTrRegBlock  (
                     // Inputs
                       HCLK,
                       HRESETN,
                       CLTrWRITE,
                       CLTrWDATA,
                       CLTrRegSel,
                       DelayRegSel,
                       CLTrControlSel,
                       CLTrTiming0Sel,
                       CLTrTiming1Sel,
                       CLTrTiming2Sel,
                       CLTrTiming3Sel,
                       CLTrUPBASESel,
                       CLTrLPBASESel,
                       CLTrUPBASE,
                       CLTrLPBASE,
                       SlaveState,

                       // Interrupt Lines
                       BEINTTR,
                       FUFINTR,
                       LNBUINTR,
                       VCOMPINTR,
                       VCOMPINTRout,
                       LNBUINTRout,
                       INTR,

                       // Output
                       CLTrRDATA,
                       // Control bit fields
                       CLTrEn,
                       CLTrGrant,
                       CLTrReset,
                       CLTrIntrTest, 
                       CLTrError,
                       CLTrRand,
                       CLTrFUFIntrTst,
                       LcdEn,
                       LcdPwr,
                       BPP,
                       BW,
                       TFT,
                       Mono8,
                       Dual,
                       BGR,
                       BEBO,
                       BEPO,
                       VComp,
                       PPL,
                       HSW,
                       HFP,
                       HBP,
                       LPP,
                       VSW,
                       VFP,
                       VBP,
                       PCD,
                       ACB,
                       IVS,
                       IHS,
                       IPC,
                       IEO,
                       CPL,
                       BCD,
                       LED,
                       LEE,
                       Delay
                     );

input             HCLK;           // AHB Bus Clock
input             HRESETN;        // AHB Reset
input             CLTrWRITE;      // CLCD Trickbox Write
input  [31:0]     CLTrWDATA;      // CLCD Trickbox Block Write Data
input             CLTrRegSel;     // CLCD Trickbox Test Control Register
input             DelayRegSel;    // CLCD Trickbox Test Control Register
input             CLTrControlSel; // CLCD Trickbox Control  Select
input             CLTrTiming0Sel; // CLCD Trickbox Timing 0  Select
input             CLTrTiming1Sel; // CLCD Trickbox Timing 1  Select
input             CLTrTiming2Sel; // CLCD Trickbox Timing 2  Select
input             CLTrTiming3Sel; // CLCD Trickbox Timing 3  Select
input             CLTrUPBASESel;  // CLCD Trickbox Upper Panel Base Select
input             CLTrLPBASESel;  // CLCD Trickbox Lower Panel Base Select
input  [2:0]      SlaveState;     // Gives CLCD Panel Status to check Interrupt

input             BEINTTR;        // CLCD Bus Error Interrupt
input             FUFINTR;        // CLCD DMA Lower FIFO Underflow Interrupt
input             LNBUINTR;       // CLCD Next Base Address Update Interrupt
input             VCOMPINTR;      // CLCD Vertical Compare Interrupt
output            VCOMPINTRout;   // CLCD VComp Interrupt to protocol check
output            LNBUINTRout;    // CLCD LNBU Interrupt to protocol check
input             INTR;           // CLCD Combined Interrupt

output [31:0]     CLTrRDATA;      // CLCD Trickbox Block Read  Data
output            CLTrEn;         // CLCD Trickbox Enable
output            CLTrGrant;      // CLCD  grant Bit
output            CLTrReset;      // CLCD  clock domain reset Bit
output            CLTrIntrTest;   // CLCD interupt test Bit
output            CLTrError;      // CLCD Trickbox ERROR Response bit
output            CLTrRand;       // CLCD Trickbox bit gernerate random 
                                  // Responses from its CLCD interface
output            CLTrFUFIntrTst; // CLCD Trickbox for not checking data 
                                  // in FIFO underflow intrupt test 
output            LcdEn;          // Enable signal for LCD controller
output            LcdPwr;         // Panel Power
output [2:0]      BPP;            // Bits per pixel
output            BW;             // Black-White mode in STN
output            TFT;            // Indicates TFT or STN Mode
output            Mono8;          // Indicates MONO 8 bit or 4 bit mode 
output            Dual;           // Indicates Single or Dual Panel STN mode
output            BGR;            // Indicates BGR or RGB format
output            BEBO;           // Indicates Byte order
output            BEPO;           // Indicates Pixel order within Byte
output [1:0]      VComp;          // VComp Interrupt Control bit
output [5:0]      PPL;            // Pixel Per Line
output [7:0]      HSW;            // Horizontal Sync Pulse Width
output [7:0]      HFP;            // Horizontal Front Porch
output [7:0]      HBP;            // Horizontal Back Porch
output [9:0]      LPP;            // Line Per Panel
output [5:0]      VSW;            // Vertical Sync Pulse Width
output [7:0]      VFP;            // Vertical Front Porch
output [7:0]      VBP;            // Vertical Back Porch
output [9:0]      PCD;            // Panel Clock Divisor
output [4:0]      ACB;            // AC Bias Pin Frequency
output            IVS;            // Invert VSync
output            IHS;            // Invert HSync
output            IPC;            // Invert Panel Clock
output            IEO;            // Invert Output Enable
output [9:0]      CPL;            // Clocks Per Line
output            BCD;            // ByPass Pixel Clock Divisor
output [6:0]      LED;            // Line End Delay
output            LEE;            // Line End Select
output [31:0]     CLTrUPBASE;     // CLCD Trickbox Upper Panel Base Register
output [31:0]     CLTrLPBASE;     // CLCD Trickbox Lower Panel Base Register
output [31:0]     Delay;          // CLCD Trickbox delay for wait responces


// -----------------------------------------------------------------------------
//
//                             CLTrRegBlock
//                             ============
//
// -----------------------------------------------------------------------------
//
// Overview:
// ========
// This module is intended for Reading and Writing the registers in CLCD 
// Trickbox. This includes the following blocks:
// - All the Trickbox Registers 
// - Their Write mechanism
// - Their Read mechanism
// - Control signal generation for other internal modules
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// Slave State value to be checked for reseting CLTrError bit
`define  S_ERROR     3'b101         // Slave gives a ERROR response

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire              HCLK;           // (module input)
wire              HRESETN;        // (module input)
wire              CLTrWRITE;      // (module input)
wire   [31:0]     CLTrWDATA;      // (module input)
wire              CLTrRegSel;     // (module input)
wire              CLTrControlSel; // (module input)
wire              CLTrTiming0Sel; // (module input)
wire              CLTrTiming1Sel; // (module input)
wire              CLTrTiming2Sel; // (module input)
wire              CLTrTiming3Sel; // (module input)
wire              CLTrUPBASESel;  // (module input)
wire              CLTrLPBASESel;  // (module input)
 
wire              BEINTTR;        // (module input)
wire              FUFINTR;        // (module input)
wire              LNBUINTR;       // (module input)
wire              VCOMPINTR;      // (module input)
wire              INTR;           // (module input)
wire              VCOMPINTRout;   // (module output)
wire              LNBUINTRout;    // (module output) 
wire              CLTrEn;         // (module output)
wire              CLTrGrant;      // (module output)
wire              CLTrError;      // (module output)
wire              CLTrRand;       // (module output)
wire              CLTrFUFIntrTst; // (module output)
wire              LcdEn;          // (module output)
wire              LcdPwr;         // (module output)
wire              CLTrIntrTest;   // (module output)
wire   [2:0]      BPP;            // (module output)
wire              BW;             // (module output)
wire              TFT;            // (module output)
wire              Mono8;          // (module output)
wire              Dual;           // (module output)
wire              BGR;            // (module output)
wire              BEBO;           // (module output)
wire              BEPO;           // (module output)
wire   [1:0]      VComp;          // (module output)
wire   [5:0]      PPL;            // (module output)
wire   [7:0]      HSW;            // (module output)
wire   [7:0]      HFP;            // (module output)
wire   [7:0]      HBP;            // (module output)
wire   [9:0]      LPP;            // (module output)
wire   [5:0]      VSW;            // (module output)
wire   [7:0]      VFP;            // (module output)
wire   [7:0]      VBP;            // (module output)
wire   [9:0]      PCD;            // (module output)
wire   [4:0]      ACB;            // (module output)
wire              IVS;            // (module output)
wire              IHS;            // (module output)
wire              IPC;            // (module output)
wire              IEO;            // (module output)
wire   [9:0]      CPL;            // (module output)
wire              BCD;            // (module output)
wire   [6:0]      LED;            // (module output)
wire              LEE;            // (module output)
wire   [31:0]     Delay;          // (module output)

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [31:0]   CLTrRDATA;     // CLCD Trickbox Block Read  Data
reg [31:0]   CLTrTest;      // CLCD Trickbox Control Register
reg [31:0]   CLTrControl;   // CLCD Trickbox Control Register
reg [31:0]   CLTrTiming0;   // CLCD Trickbox Timing 0 Register
reg [31:0]   CLTrTiming1;   // CLCD Trickbox Timing 1 Register
reg [31:0]   CLTrTiming2;   // CLCD Trickbox Timing 2 Register
reg [31:0]   CLTrTiming3;   // CLCD Trickbox Timing 3 Register
reg [31:0]   CLTrUPBASE;    // CLCD Trickbox Upper Panel Base Register
reg [31:0]   CLTrLPBASE;    // CLCD Trickbox Lower Panel Base Register
reg [31:0]   CLTrIntr;      // CLCD Trickbox Interrupt Register
reg [31:0]   DelayReg;      // CLCD Trickbox Delay Register for waiting 
// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Assigning the interupt out to the protocol checker
// -----------------------------------------------------------------------------
assign  VCOMPINTRout = VCOMPINTR;
assign  LNBUINTRout  = LNBUINTR;

// -----------------------------------------------------------------------------
// Write Block for CLCD Test Control Register (Trickbox Specific)
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Test
  if (!HRESETN)
    CLTrTest      <= 32'b0;
  else 
    begin
      if (CLTrRegSel && CLTrWRITE)
        CLTrTest[6:0]  <= CLTrWDATA[6:0];
      // If Slave State is ERROR, reset CLTrError bit
      if (SlaveState == `S_ERROR)
        CLTrTest[2]    <= 1'b0;
    end
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Control Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Control
  if (!HRESETN)
    CLTrControl   <= 32'b0;
  else if (CLTrControlSel)
    if (CLTrWRITE)
      CLTrControl[13:0] <= CLTrWDATA[13:0];
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Delay Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Delay
  if (!HRESETN)
   DelayReg <= 32'b0;
  else if (DelayRegSel & CLTrWRITE)
      DelayReg[31:0] <= CLTrWDATA[31:0];
  else if(DelayReg != 32'b0)
      DelayReg = DelayReg - 1'b1;
end
// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Timing 0 Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Timing0
  if (!HRESETN)
    CLTrTiming0   <= 32'b0;
  else if (CLTrTiming0Sel)
    if (CLTrWRITE)
      CLTrTiming0[31:2] <= CLTrWDATA[31:2];
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Timing 1 Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Timing1
  if (!HRESETN)
    CLTrTiming1   <= 32'b0;
  else if (CLTrTiming1Sel)
    if (CLTrWRITE)
      CLTrTiming1 <= CLTrWDATA;
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Timing 2 Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Timing2
  if (!HRESETN)
    CLTrTiming2   <= 32'b0;
  else if (CLTrTiming2Sel)
    if (CLTrWRITE)
      CLTrTiming2[31:0] <= CLTrWDATA[31:0];
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Timing 3 Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Timing3
  if (!HRESETN)
    CLTrTiming3   <= 32'b0;
  else if (CLTrTiming3Sel)
    if (CLTrWRITE)
      begin
        CLTrTiming3[16]  <= CLTrWDATA[16];
        CLTrTiming3[6:0] <= CLTrWDATA[6:0];
      end
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Upper Panel Base Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_UPBASE
  if (!HRESETN)
    CLTrUPBASE    <= 32'b0;
  else if (CLTrUPBASESel)
    if (CLTrWRITE)
      CLTrUPBASE  <= CLTrWDATA;
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Lower Panel Base Register
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_LPBASE
  if (!HRESETN)
    CLTrLPBASE    <= 32'b0;
  else if (CLTrLPBASESel)
    if (CLTrWRITE)
      CLTrLPBASE    <= CLTrWDATA;
end

// -----------------------------------------------------------------------------
// Write Block for CLCD Trickbox Interrupt Status Register (Trickbox Specific)
// -----------------------------------------------------------------------------
always @(negedge HRESETN or posedge HCLK)
begin : p_Intr
  if (!HRESETN)
    CLTrIntr      <= 32'b0;
  else
    begin
      CLTrIntr[5:0] <= {BEINTTR,FUFINTR,1'b0,LNBUINTR,
                        VCOMPINTR,INTR};
      CLTrIntr[31:6] <= 26'b0;
    end
end
 
// -----------------------------------------------------------------------------
// Read Block : CLCD Trickbox Read gives the CLTrIntr Value
// Read block is Asynchronous.
// -----------------------------------------------------------------------------
always@(posedge CLTrRegSel)
begin : Read
  if (!CLTrWRITE && CLTrRegSel)
    CLTrRDATA = CLTrIntr;
end
// -----------------------------------------------------------------------------
// Read Block : CLCD Trickbox Read gives values for other registers 
// Read block is Asynchronous.
// -----------------------------------------------------------------------------
always @(CLTrWRITE)
begin : p_Read
  if (!CLTrWRITE && CLTrControlSel)
    CLTrRDATA = CLTrControl;
  else if (!CLTrWRITE && CLTrTiming0Sel)
    CLTrRDATA = CLTrTiming0;
  else if (!CLTrWRITE && CLTrTiming1Sel)
    CLTrRDATA = CLTrTiming1;
  else if (!CLTrWRITE && CLTrTiming2Sel)
    CLTrRDATA = CLTrTiming2;
  else if (!CLTrWRITE && CLTrTiming3Sel)
    CLTrRDATA = CLTrTiming3;
  else if (!CLTrWRITE && CLTrUPBASESel)
    CLTrRDATA = CLTrUPBASE;
  else if (!CLTrWRITE && CLTrLPBASESel)
    CLTrRDATA = CLTrLPBASE;
  else
    CLTrRDATA = 32'b0;
end

// -----------------------------------------------------------------------------
// Control Bit Fields and Data Outputs
// -----------------------------------------------------------------------------
// Control fields from  CLTrTest Register
// ----------------------------------------
assign   CLTrEn         = CLTrTest[0];
assign   CLTrGrant      = CLTrTest[1];
assign   CLTrError      = CLTrTest[2];
assign   CLTrIntrTest   = CLTrTest[3];
assign   CLTrFUFIntrTst = CLTrTest[4];
assign   CLTrRand       = CLTrTest[5];
assign   CLTrReset      = CLTrTest[6];

// Control fields from  CLTrControl Register
// ----------------------------------------
assign   LcdEn         = CLTrControl[0];
assign   BPP           = CLTrControl[3:1];
assign   BW            = CLTrControl[4];
assign   TFT           = CLTrControl[5];
assign   Mono8         = CLTrControl[6];
assign   Dual          = CLTrControl[7];
assign   BGR           = CLTrControl[8];
assign   BEBO          = CLTrControl[9];
assign   BEPO          = CLTrControl[10];
assign   LcdPwr        = CLTrControl[11];
assign   VComp         = CLTrControl[13:12];

// Control fields from  CLTrTiming0 Register
// ----------------------------------------
assign   PPL           = CLTrTiming0[7:2];
assign   HSW           = CLTrTiming0[15:8];
assign   HFP           = CLTrTiming0[23:16];
assign   HBP           = CLTrTiming0[31:24];

// Control fields from  CLTrTiming1 Register
// ----------------------------------------
assign   LPP           = CLTrTiming1[9:0];
assign   VSW           = CLTrTiming1[15:10];
assign   VFP           = CLTrTiming1[23:16];
assign   VBP           = CLTrTiming1[31:24];

// Control fields from  CLTrTiming2 Register
// ----------------------------------------
assign   PCD           = {CLTrTiming2[31:27],CLTrTiming2[4:0]};
assign   ACB           = CLTrTiming2[10:6];
assign   IVS           = CLTrTiming2[11];
assign   IHS           = CLTrTiming2[12];
assign   IPC           = CLTrTiming2[13];
assign   IEO           = CLTrTiming2[14];
assign   CPL           = CLTrTiming2[25:16];
assign   BCD           = CLTrTiming2[26];

// Control fields from CLTrTiming3 Register
// ----------------------------------------
assign   LED           = CLTrTiming3[6:0];
assign   LEE           = CLTrTiming3[16];

// Delay value to be passed to AHB interface
// ----------------------------------------
assign   Delay         = DelayReg;

endmodule
 
// --================================== End ==================================--

