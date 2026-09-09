// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdSyncCLCDCLK.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : This module double synchronises the signals 
//                           entering the CLCDCLK clock domain from HCLK clock 
//                           domain. It also has control and timing registers in
//                           CLCDCLK clock domain.
//
// --=========================================================================--
 
`timescale 1ns/1ps
// ----------------------------------------------------------------------------
 
module ClcdSyncCLCDCLK (
// Inputs
                        CLCDCLK,
                        nCLCLKRESET,
                        AhbMError,
                        FrameRstAck,
                        VCStatSyncHclk,
                        LCDT0Wen,
                        LCDT1Wen,
                        LCDT2Wen,
                        LCDT3Wen,
                        LCDCWen,
                        HWDATAS, 
// Outputs
                        LcdEn,
                        LcdBPP,
                        LcdBW,
                        LcdTFT,
                        LcdMono8,
                        LcdDualLclk,
                        BGR,
                        BEBO,
                        BEPO,
                        LcdPwrEn ,
                        LcdVComp,
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
                        AhbMBESyncLclk,
                        FrRstAckSyncLclk,
                        VCStaAckSyncLclk,
                        Tim0WenLclkDel,
                        Tim1WenLclkDel,
                        Tim2WenLclkDel,
                        Tim3WenLclkDel,
                        ConlWenLclkDel
                       );

// Inputs
input           CLCDCLK;        // Lcd Clock input
input           nCLCLKRESET;    // Reset signal - CLCDCLK domain
input           AhbMError;      // Ahb master bus error
input           FrameRstAck;    // End of frame signal
input           VCStatSyncHclk; // Acknowledge for the VCOMP status signal
input           LCDT0Wen;       // TimingReg0 write enable - HCLK domain
input           LCDT1Wen;       // TimingReg1 write enable - HCLK domain
input           LCDT2Wen;       // TimingReg2 write enable - HCLK domain
input           LCDT3Wen;       // TimingReg3 write enable - HCLK domain
input           LCDCWen;        // LcdControlReg write enable - HCLK domain
input   [31:0]  HWDATAS;        // AHB write data bus

// Outputs
output          LcdEn;          // Lcd enable bit from control reg
output  [02:00] LcdBPP;         // Lcd Bits Per Pixel
output          LcdBW;          // Lcd black and white mode
output          LcdTFT;         // Lcd is TFT or STN type
output          LcdMono8;       // No of bits in mono mode
output          LcdDualLclk;    // Indicates whether it is dual or single panel
output          BGR;            // Select between normal or swapped output
output          BEBO;           // Select B/W big or small Endian byte order
output          BEPO;           // Select B/W big or small Endian pixel order
output          LcdPwrEn;       // LCD Power enable
output  [01:00] LcdVComp;       // Used to generate interrupt at diff positions
output  [05:00] PPL;            // No of Pixels per line info from control reg
output  [07:00] HSW;            // Horz Sync Pulse width value
output  [07:00] HFP;            // Horz Front Porch value
output  [07:00] HBP;            // Vert Back  Porch value
output  [09:00] LPP;            // Lines per panel value
output  [05:00] VSW;            // Vert Sync Pulse width value
output  [07:00] VFP;            // Vert Front Porch value
output  [07:00] VBP;            // Vert Back  Porch value
output  [09:00] PCD;            // programmable clock divider from timer reg2
output  [04:00] ACB;            // AC Bias pin frequency
output          IVS;            // Invert Vsync
output          IHS;            // Invert Hsync
output          IPC;            // Invert Panel Clock
output          IEO;            // Invert Output Enable
output  [09:00] CPL;            // Clocks Per Line
output          BCD;            // Bypass Pixel Clock Divider
output  [06:00] LED;            // Line-End signal delay
output          LEE;            // Line End Enable
output        AhbMBESyncLclk;   // Ahb master bus error synchronised to CLCDCLK
output        FrRstAckSyncLclk; // FrameRstack signal synchronised to CLCDCLK
output        VCStaAckSyncLclk; // VCompStatAck signal synchronised to CLCDCLK
output        Tim0WenLclkDel;   // Registered signal for re-synchronization
output        Tim1WenLclkDel;   // Registered signal for re-synchronization
output        Tim2WenLclkDel;   // Registered signal for re-synchronization
output        Tim3WenLclkDel;   // Registered signal for re-synchronization
output        ConlWenLclkDel;   // Registered signal for re-synchronization

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
// wire declaration
// -----------------------------------------------------------------------------
wire          CLCDCLK;        
// Lcd Clock input                                          (Module Input)

wire          nCLCLKRESET;    
// Reset signal - CLCDCLK domain                            (Module Input)

wire          FrameRstAck;    
// End of frame signal synchronised to HCLK domain          (Module Input)

wire           VCStatSyncHclk;       
// Acknowledge for the VCOMP status signal                  (Module Input)

wire            LCDT0Wen;      
// TimingReg0 write enable - HCLK domain                    (Module Input)

wire            LCDT1Wen;      
// TimingReg1 write enable - HCLK domain                    (Module Input)

wire            LCDT2Wen;      
// TimingReg2 write enable - HCLK domain                    (Module Input)

wire            LCDT3Wen;      
// TimingReg3 write enable - HCLK domain                    (Module Input)

wire            LCDCWen;        
// LcdControlReg write enable - HCLK domain                 (Module Input)

wire  [31:0]    HWDATAS;        
// AHB write data bus                                       (Module Input)

wire          LcdEn;
// Lcd enable bit from control reg                          (Module output)
 
wire [02:00]  LcdBPP;
// Lcd Bits Per Pixel                                       (Module output)
 
wire          LcdBW;
// Lcd black and white mode                                 (Module output)
 
wire          LcdTFT;
// Lcd is TFT or STN type                                   (Module output)
 
wire          LcdMono8;
// No of bits in mono mode                                  (Module output)
 
wire          LcdDualLclk;
// Indicates whether it is dual or single panel             (Module output)
 
wire          BGR;
// Select between normal or swapped output                  (Module output)
 
wire          BEBO;
// Select B/W big or small Endian byte order                (Module output)
 
wire          BEPO;
// Select B/W big or small Endian pixel order               (Module output)
 
wire          LcdPwrEn ;
// LCD Power enable                                         (Module output)
 
wire [1:0]  LcdVComp;
// Used to generate interrupt at diff positions             (Module output)
 
wire [5:0]  PPL;
// No of Pixels per line info from control reg              (Module output)
 
wire [7:0]  HSW;
// Horz Sync Pulse width value                              (Module output)
 
wire [7:0]  HFP;
// Horz Front Porch width value                             (Module output)
 
wire [7:0]  HBP;
// Vert Back  Porch width value                             (Module output)
 
wire [9:0]  LPP;
// Lines per panel value                                    (Module output)
 
wire [5:0]  VSW;
// Vert Sync Pulse width value                              (Module output)
 
wire [7:0]  VFP;
// Vert Front Porch width                                   (Module output)
 
wire [7:0]  VBP;
// Vert Back  Porch width value                             (Module output)
 
wire [9:0]  PCD;
// Clock divider value                                      (Module output)
 
wire [4:0]  ACB;
// AC Bias pin frequency                                    (Module output)
 
wire          IVS;
// Invert Vsync                                             (Module output)
 
wire          IHS;
// Invert Hsync                                             (Module output)
 
wire          IPC;
// Invert Panel Clock                                       (Module output)
 
wire          IEO;
// Invert Output Enable                                     (Module output)
 
wire [9:0]  CPL;
// Clocks Per Line                                          (Module output)
 
wire          BCD;
// Bypass Pixel Clock Divider                               (Module output)
 
wire [6:0]  LED;
// Line-End signal delay                                    (Module output)
 
wire          LEE;
// Line End Enable                                          (Module output)

wire          Tim0WenSel;
// Select signal for mux which writes on CLCDCLK
 
wire          Tim1WenSel;
// Select signal for mux which writes on CLCDCLK
 
wire          Tim2WenSel;
// Select signal for mux which writes on CLCDCLK
 
wire          Tim3WenSel;
// Select signal for mux which writes on CLCDCLK
 
wire          ConlWenSel;
// Select signal for mux which writes on CLCDCLK

// -----------------------------------------------------------------------------
// Register declaration
// -----------------------------------------------------------------------------
reg            FrRstAckSyncLclk; 
// FrameRstack signal synchronised to CLCDCLK               (Module Output)

reg            VCStaAckSyncLclk; 
// VCompStatAck signal synchronised to CLCDCLK              (Module Output)

reg            AhbMBESyncLclk;
// AhbMError signal synchronised to CLCDCLK                 (Module Output)

reg           Tim0WenLclkDel ;
// Registered signal for re-synchronization                 (Module Output)
 
reg           Tim1WenLclkDel ;
// Registered signal for re-synchronization                 (Module Output)
 
reg           Tim2WenLclkDel ;
// Registered signal for re-synchronization                 (Module Output)
 
reg           Tim3WenLclkDel ;
// Registered signal for re-synchronization                 (Module Output)
 
reg           ConlWenLclkDel ;
// Registered signal for re-synchronization                 (Module Output)

reg            FrRStAckSyncInt;
// First level register for  FrameRstAck signal

reg            VCStAckSyncInt;
// First level register for VCompStAck signal

reg            AhbMBESyncInt;
// First level register for AhbMError signal

reg  [29:0]  LCDTiming0;
// Horizontal Control Register
 
reg  [29:0]  NextLCDTiming0;
// D-input of Horizontal Control Register
 
reg  [31:0]  LCDTiming1;
// Vertical Control Register
 
reg  [31:0]  NextLCDTiming1;
// D-input of Vertical Control Register
 
reg  [30:0]  LCDTiming2;
// Timing information for lcd
 
reg  [30:0]  NextLCDTiming2;
// D-input of LCDTiming2
 
reg  [7:0]  LCDTiming3;
// This register contains line end parameters
 
reg  [7:0]  NextLCDTiming3;
// D-input of LCDTiming3 register
 
reg  [13:0]  LCDControl;
// LCD Control Register which controls the mode
 
reg  [13:0]  NextLCDControl;
// D-input of LCDControl register
 
reg           Timing0WenLclk;
// Write enable for Timing0 register-HCLK domain
 
reg           Timing1WenLclk;
// Write enable for Timing1 register-CLCDCLK domain
 
reg           Timing2WenLclk;
// Write enable for Timing2 register-CLCDCLK domain
 
reg           Timing3WenLclk;
// Write enable for Timing3 register-CLCDCLK domain
 
reg           ControlWenLclk;
// Write enable for control register-CLCDCLK domain
 
reg           Tmg0WenSync1;
// First level synchroniser output for Timing0WenLclk signal
 
reg           Tmg1WenSync1;
// First level synchroniser output for Timing1WenLclk signal
 
reg           Tmg2WenSync1;
// First level synchroniser output for Timing2WenLclk signal
 
reg           Tmg3WenSync1;
// First level synchroniser output for Timing3WenLclk signal
 
reg           CtrlWenSync1;
// First level synchroniser output for LCDControlWen signal

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
 
// ----------------------------------------------------------------------------
// Register bit assignments
// ----------------------------------------------------------------------------

assign PPL = LCDTiming0[5:0];
assign HSW = LCDTiming0[13:6];
assign HFP = LCDTiming0[21:14];
assign HBP = LCDTiming0[29:22];

assign LPP = LCDTiming1[9:0];
assign VSW = LCDTiming1[15:10];
assign VFP = LCDTiming1[23:16];
assign VBP = LCDTiming1[31:24];

assign PCD = {LCDTiming2[30:26],LCDTiming2[4:0]};
assign ACB = LCDTiming2[10:6];
assign IVS = LCDTiming2[11];
assign IHS = LCDTiming2[12];
assign IPC = LCDTiming2[13];
assign IEO = LCDTiming2[14];
assign CPL = LCDTiming2[24:15];
assign BCD = LCDTiming2[25];

assign LED = LCDTiming3[6:0];
assign LEE = LCDTiming3[7];

assign LcdEn        =  LCDControl[0];
assign LcdBPP       =  LCDControl[3:1];
assign LcdBW        =  LCDControl[4];
assign LcdTFT       =  LCDControl[5];
assign LcdMono8     =  LCDControl[6];
assign LcdDualLclk  =  LCDControl[7];
assign BGR          =  LCDControl[8];
assign BEBO         =  LCDControl[9];
assign BEPO         =  LCDControl[10];
assign LcdPwrEn     =  LCDControl[11];
assign LcdVComp     =  LCDControl[13:12];


// ---------------------------------------------------------------------------
// Synchronisation of control and timing register write enable signals to
// the CLCDCLK clock domain.
// ---------------------------------------------------------------------------
always @ (posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_SyncRegSeq
  if (nCLCLKRESET == 1'b0) 
    begin
      Timing0WenLclk  <= 1'b0;
      Timing1WenLclk  <= 1'b0;
      Timing2WenLclk  <= 1'b0;
      Timing3WenLclk  <= 1'b0;
      ControlWenLclk  <= 1'b0;
      Tmg0WenSync1    <= 1'b0;
      Tmg1WenSync1    <= 1'b0;
      Tmg2WenSync1    <= 1'b0;
      Tmg3WenSync1    <= 1'b0;
      CtrlWenSync1    <= 1'b0;
    end
  else
     begin
       Timing0WenLclk  <= Tmg0WenSync1;
       Timing1WenLclk  <= Tmg1WenSync1;
       Timing2WenLclk  <= Tmg2WenSync1;
       Timing3WenLclk  <= Tmg3WenSync1;
       ControlWenLclk  <= CtrlWenSync1;
       Tmg0WenSync1    <= LCDT0Wen;
       Tmg1WenSync1    <= LCDT1Wen;
       Tmg2WenSync1    <= LCDT2Wen;
       Tmg3WenSync1    <= LCDT3Wen;
       CtrlWenSync1    <= LCDCWen;
     end
end // p_SyncRegSeq

// -----------------------------------------------------------------------------
// Generation of one clock delayed version of register write enables.
// -----------------------------------------------------------------------------
always @ (posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_DelWrEnSeq
  if (nCLCLKRESET == 1'b0) 
   begin
     Tim0WenLclkDel  <= 1'b0;
     Tim1WenLclkDel  <= 1'b0;
     Tim2WenLclkDel  <= 1'b0;
     Tim3WenLclkDel  <= 1'b0;
     ConlWenLclkDel  <= 1'b0;
   end
  else 
    begin
      Tim0WenLclkDel  <= Timing0WenLclk;
      Tim1WenLclkDel  <= Timing1WenLclk;
      Tim2WenLclkDel  <= Timing2WenLclk;
      Tim3WenLclkDel  <= Timing3WenLclk;
      ConlWenLclkDel  <= ControlWenLclk;
    end
end // p_DelWrEnSeq

// -----------------------------------------------------------------------------
// Actual write enable pulses for latching of the data in to the registers
// -----------------------------------------------------------------------------
assign Tim0WenSel = (!Tim0WenLclkDel) & (Timing0WenLclk);
assign Tim1WenSel = (!Tim1WenLclkDel) & (Timing1WenLclk);
assign Tim2WenSel = (!Tim2WenLclkDel) & (Timing2WenLclk);
assign Tim3WenSel = (!Tim3WenLclkDel) & (Timing3WenLclk);
assign ConlWenSel = (!ConlWenLclkDel) & (ControlWenLclk);

// ---------------------------------------------------------------------------
// This  block controls the actual write in CLCDCLK domain. Here depending
// on the register enable signals the data from the data bus is registered
// on to the corresponding registers.
// ---------------------------------------------------------------------------
always @(Tim0WenSel or Tim1WenSel or Tim2WenSel or Tim3WenSel or ConlWenSel or
         HWDATAS    or LCDTiming0 or LCDTiming1 or LCDTiming2 or LCDTiming3 or
         LCDControl)
begin : p_MuxSelComb
  NextLCDTiming0 = LCDTiming0;
  NextLCDTiming1 = LCDTiming1;
  NextLCDTiming2 = LCDTiming2;
  NextLCDTiming3 = LCDTiming3;
  NextLCDControl = LCDControl;
  if (Tim0WenSel)
    NextLCDTiming0[29:0] =  HWDATAS[31:2];
  if (Tim1WenSel)
    NextLCDTiming1[31:0] =  HWDATAS[31:0];
  if (Tim2WenSel)
    NextLCDTiming2[30:0] = {HWDATAS[31:16], HWDATAS[14:0]};
  if (Tim3WenSel)
    NextLCDTiming3[7:0] = {HWDATAS[16], HWDATAS[6:0]};
  if (ConlWenSel)
    NextLCDControl[13:0] = HWDATAS[13:0];
end // p_MuxSelComb

// ---------------------------------------------------------------------------
// registering the next state inputs
// ---------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET) 
begin : p_HCLKSyncSeq
  if (nCLCLKRESET == 1'b0)
    begin
      LCDTiming0 <= {30{1'b0}};
      LCDTiming1 <= {32{1'b0}};
      LCDTiming2 <= {31{1'b0}};
      LCDTiming3 <= {8{1'b0}};
      LCDControl <= {14{1'b0}};
    end
  else 
    begin
      LCDTiming0 <= NextLCDTiming0;
      LCDTiming1 <= NextLCDTiming1;
      LCDTiming2 <= NextLCDTiming2;
      LCDTiming3 <= NextLCDTiming3;
      LCDControl <= NextLCDControl;
    end
end // p_HCLKSyncSeq

// -----------------------------------------------------------------------------
// Synchronisation of other control signals coming to the CLCDCLK domain
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_SyncCntSeq
  if (nCLCLKRESET == 1'b0)
    begin
      FrRStAckSyncInt  <=  1'b0;
      VCStAckSyncInt   <=  1'b0;
      AhbMBESyncInt    <=  1'b0;
      FrRstAckSyncLclk <=  1'b0;
      VCStaAckSyncLclk <=  1'b0;
      AhbMBESyncLclk   <=  1'b0;
    end
  else
    begin
      FrRStAckSyncInt  <=  FrameRstAck;
      VCStAckSyncInt   <=  VCStatSyncHclk;
      AhbMBESyncInt    <=  AhbMError;
      FrRstAckSyncLclk <=  FrRStAckSyncInt;
      VCStaAckSyncLclk <=  VCStAckSyncInt;
      AhbMBESyncLclk   <=  AhbMBESyncInt;
    end
end // p_SyncCntSeq

endmodule

// --================================== End ==================================--
