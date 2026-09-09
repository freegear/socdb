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
//  File Name              : ClcdTiming.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//   Purpose               : This module generates the following control signals
//                           for the LCD panel 
//                           1. LinePulse and Frame pulse
//                           2. ACBIAS/DataEnable
//                           3. LineEnd signal
//
// *****************************************************************************
//      UnpackEn has one clock cycle delay added to output path
//      to accomodate Synchronous Palette RAM 
// *****************************************************************************
// --=========================================================================--

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module ClcdTiming (
                     CLCDCLK,
                     nCLCLKRESET,
                     HFP,
                     HBP,
                     HSW,
                     CPL,
                     VSW,
                     VFP,
                     VBP,
                     LPS,
                     IVS,
                     IHS,
                     IEO,
                     LcdTFT,
                     BCD,
                     LEEn,
                     LEDel,
                     LcdPwrEn,
                     LcdEn,
                     LcdVComp,
                     ACB,
                     AhbMBESyncLclk,
                     FrRstAckSyncLclk,
                     VCompAckSyncLclk,
                     NextRising,

                     EndFrame,
                     PCEn,
                     FifoEn,
                     CLLPint,
                     CLFPint,
                     CLACint,
                     CLLEint,
                     CLPOWERint,
                     StartRow,
                     FrameStart,
                     FrameRst,
                     VCompStat,
                     PalLcdCSB2,
                     UnpackEn,
                     NullPC,
                     TFTPDEn
                   );

input       CLCDCLK;          // Clock input
input       nCLCLKRESET;      // System Reset
input       LcdPwrEn;         // Lcd Panel power enable bit 
input [7:0] HFP;              // Horizontal front porch value
input [7:0] HBP;              // Horizontal back porch value
input [7:0] HSW;              // Horizontal sync width value
input [9:0] CPL;              // LcdCP clocks per line
input [5:0] VSW;              // Vertical sync width value
input [7:0] VFP;              // Vertical front porch value
input [7:0] VBP;              // Vertical back porch value
input [9:0] LPS;              // Lines per screen value
input       IVS;              // Invert vertical sync
input       IHS;              // Invert horizontal sync
input       IEO;              // Invert output enable for TFT
input       LcdTFT;           // TFT mode - some different behaviour
input       BCD;              // Bypass Panel clock divider - pixel every clock
input       LEEn;             // Enable Line-End signal generation
input [6:0] LEDel;            // Line-End signal delay value
input       LcdEn;            // Lcd Controller enable bit 
input [1:0] LcdVComp;         // Vertical compare interrupt value
input [4:0] ACB;              // Number of lines between toggling ACBias pin
input       FrRstAckSyncLclk; // Frame reset acknowldge from AHB Master
input       VCompAckSyncLclk; // Vertical compare interrupt acknowledge
input       AhbMBESyncLclk;   // Error interrupt from AHB master.
input       NextRising;       // Indicates that LcdCP goes high next cycle

output      EndFrame;         // Tell greyscaler frame has ended
output      PCEn;             // Enable LcdCP clock to Lcd panel
output      FifoEn;           // Fifo read (passive) or enable (TFT)
output      CLLPint;          // Line pulse signal to LCD Panel
output      CLFPint;          // Frame pulse signal to LCD Panel
output      CLACint;          // ACBias signal to LCD Panel
output      CLLEint;          // Line-End signal
output      CLPOWERint;       // Lcd Panel Power
output      StartRow;         // Start of ACTIVE line (for grayscaler)
output      FrameStart;       // Start DMA request
output      FrameRst;         // Stop DMA & flush pipeline
output      VCompStat;        // Vertical compare interrupt
output      PalLcdCSB2;       // Palette Ram port2 Chip select 
output      UnpackEn;         // Enable signal for unpacker state machine 
output      NullPC;           // PC runs but is not sent to LCD
output      TFTPDEn;          // Enable for TFT panel data

// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// this module generates the Linepulse, Frame pulse, Line-End signal and other
// control signals required by the associated blocks of the LCD Controller.
// It includes the following logic:
// - State machine and Counter for horizontal timing control of the LCD panel. 
// - State machine and Counter for vertical timing control of the LCD panel.
// - AC-bias signal generation logic.
// - Line-End signal generation logic.
// -----------------------------------------------------------------------------

// state machine states
 
`define ST_V_SYNC         2'b00  // Vertical sync state
`define ST_V_BACKPORCH    2'b01  // Vertical back porch state
`define ST_V_ACTIVE       2'b10  // Vertical active state
`define ST_V_FRONTPORCH   2'b11  // Vertical front porch state
 
`define ST_H_SYNC         2'b00  // Horizontal sync state
`define ST_H_BACKPORCH    2'b01  // Horizontal back porch state
`define ST_H_ACTIVE       2'b10  // Horizontal active state
`define ST_H_FRONTPORCH   2'b11  // Horizontal front porch state
 
// Comparison interrupt positions
 
`define C_VSYNC           2'b00  //start of vertical sync state
`define C_BACKPORCH       2'b01  // start of vertical back porch state
`define C_ACTIVE          2'b10  // start of vertical active state
`define C_FRONTPORCH      2'b11  // start of vertical front porch state

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire                  CLCDCLK;          
// Clock input                                        (Module input)

wire                  nCLCLKRESET;   
// System Reset                                       (Module input)

wire                  LcdPwrEn;       
// Lcd Panel power enable bit                         (Module input)

wire  [7:0]           HFP;           
// Horizontal front porch value                       (Module input)

wire  [7:0]           HBP;           
// Horizontal back porch value                        (Module input)

wire  [7:0]           HSW;           
// Horizontal sync width value                        (Module input)

wire  [9:0]           CPL;           
// LcdCP clocks per line                              (Module input)

wire  [5:0]           VSW;           
// Vertical sync width value                          (Module input)

wire  [7:0]           VFP;           
// Vertical front porch value                         (Module input)

wire  [7:0]           VBP;           
// Vertical back porch value                          (Module input)

wire  [9:0]           LPS;           
// Lines per screen value                             (Module input)

wire                  IVS;           
// Invert vertical sync                               (Module input)

wire                  IHS;           
// Invert horizontal sync                             (Module input)

wire                  IEO;           
// Invert output enable for TFT                       (Module input)

wire                  LEEn;           
// Enable Line-End signal generation                  (Module input)

wire  [6:0]           LEDel;          
// Line-End signal Delay value                        (Module input)

wire                  LcdEn;        
// Lcd Controller enable bit                          (Module input)

wire  [1:0]           LcdVComp;     
// Vertical compare interrupt value                   (Module input)

wire  [4:0]           ACB;           
// Number of lines between toggling ACBias pin        (Module input)

wire                  FrRstAckSyncLclk;  
// Frame reset DMA  acknowldge                        (Module input)

wire                  VCompAckSyncLclk;  
// Vertical compare interrupt acknowledge             (Module input)

wire                  LcdTFT;           
// TFT mode - some different behaviour                (Module input)

wire                  NextRising;    
// Indicates that LcdCP goes high next cycle          (Module input)

wire                  BCD;           
// Bypass Clock Divider - pixel every clock           (Module input)

wire                  AhbMBESyncLclk;       
// Error interrupt from AHB master                    (Module input)

wire                  PCEn;
// Enable panel clock state machine                   (Module output)

wire                  StartRow;
// Start of new line : signal to greyscaler           (Module output)

wire                  IntCLLP1;
// Internal version of CLLP signal

wire                  IntLcdPwr;
// Internal version of CLPOWER signal

wire                  PalLcdCSB2;
// Palette RAM chip select(port2)                     (Module output)

wire                  CLFPint;
// Frame pulse output                                 (Module output)

wire                  CLLPint;
// Line  pulse output                                 (Module output)

wire                  IntCLFP1;
// Internal version of CLFP signal

wire                  HEq0;
// Horizontal count is equal to zero

wire                  VEq0;
// Vertical count is equal to zero

wire                  ACBEq0;
// ACB conut is equal to zero

wire                  NextFrameRst;
// D-input of Frame reset signal register

wire                  NextIntFrameSt;
// D-input of Frame start signal register

wire                  NextVComp;
// D-input of VCOMP status signal register

wire                  VEq1;
// Vertical count is equal to one

wire                  VFPEq0;
// Vertical Front porch value is equal zero

wire                  VBPEq0;
// Vertical back porch value is equal to zero

wire                  HEq1;
// Horizontal count is equal to zero

wire                  ACBEn;
// Enable for ACB counter

wire                  IntCLAC;
// Internal version of AC bias signal

wire                  IntCLAC1;
// Internal version of AC bias signal

wire                  NextUnpackEn;      
// Next state Enable signal for unpacker state machine 

wire                  ACBInt1;
// ACB signal MUX output


// -----------------------------------------------------------------------------
// register declarations
// -----------------------------------------------------------------------------
reg                   FrameRst;
// Reset signal to front end of the data path(DMA/unpacker) (Module output)

reg                   FrameStart;
// Frame start signal                                       (Module output)

reg                   CLLEint;
// Line end signal                                          (Module output)

reg                   CLPOWERint;
// LCD panel power                                         (Module output)

reg                   IntCLFP2;
// Internal version of CLFP

reg                   IntCLLP2;
// Internal version of CLLP

reg                   CLACint;
// AC bais(STN)/DataEnable (TFT)                           (Module output)

reg                   TFTPDEn;                      
// Enable for TFT panel data                               (Module output)

reg     [1:0]         VState;
// Vertical state machine state register

reg     [1:0]         HState;
// Horizontal state machine state register

reg                  ACBInt;
// Internal version of CLAC signal

reg                   FirstLine;
// Status bit for frame pulse generation in STN mode. 

reg                   SOL;
// Start of active line: signal to greyscaler 

reg                   NullPC;
// Enable panel clock output(gating of panel clock)        (Module output)

reg                   LoadHSW;
// Load Horizontal sync width value in to the horizontal counter

reg                   LoadHFP;
// Load Horizontal Front porch value in to the horizontal counter

reg                   LoadHBP;
// Load Horizontal back porch value in to the horizontal counter

reg                   LoadCPL;
// Load number of clocks per line value in to the horizontal counter

reg                   LoadVSW;
// Load vertical sync width value in to the vertical counter

reg                   LoadVFP;
// Load vertical Front porch value in to the vertical counter

reg                   LoadVBP;
// Load vertical back porch value in to the vertical counter

reg                   LoadLPS;
// Load lines/frame value in to the vertical counter

reg                   EndOfLine;
// end of active line. signal to greyscaler

reg     [1:0]         NextVState;
// D-input vertical state register

reg     [1:0]         NextHState;
// D-input horizontal state register

reg                   NextCLFP; 
// Frame pulse: output of vertical state machine

reg                   NextCLFP1;
// D-input of CLFP

reg                   NextCLLP;
// Line pulse: output of horizontal state machine

reg                   FrameStartSet; 
// Frame start signal: output of horizontal state machine 

reg                   IntFrameStart; 
// Internal version of Frame start signal

reg                   FrameRstSet; 
// Frame reset signal: output of vertical state machine

reg                   VCompSet;
// Vertical compare status: output of vertical state machine

reg                   DelNextRising;
// one clock delayed version of NextRising signal. this signal is used for 

// horizontal state transition
reg                   Dech; 
// Decrement horizontal counter

reg                   DecV;
// Decrement vertical counter

reg    [9:0]          HCount; 
// Horizontal counter register

reg    [9:0]          VCount;
// Vertical counter register

reg    [4:0]          ACBCount;
// AC bias counter register

reg                   NextOE;
// Data Enable signal for TFT panel

reg                   NextSOL;
// Start of new line: output of horizontal state machine 

reg                   EnFP;
// enable frame pulse

reg                   SetFirstLine;
// Flag for frame pulse generation during the first line of active 
// period in STN mode

reg                   ClrFirstLine;
// clear FirstLine flag

reg                   LoadFirstSW;
// load HSW and VSW values in to the cooresponding counters on reset.
// this signal is used to load the HSW and VSW values only when the Lcd 
// controller is enabled just after the Reset.

reg                   NextLoadFirstSW;
// D-input of LoadFirstSW

reg                   LEStartSet;
// Start Line end signal
reg                   VCompStat;
// Vertical state compare status 

reg [6:0]             NextLECount;
// D-input of Line-End signal counter

reg [6:0]             LECount;
// register for Line-End signal counter

reg                   LoadLEV;
// load Line-end signal value in to the counter

reg [6:0]             LEVal;
// Value to be loaded in to the Line-end signal counter

reg                   NextLEWait;
// D-input of LEWait signal register

reg                   LEWait;
// indicates the wait status of the Line-End signal

reg                   NextCLLEint;
// D-input of the Line-End signal register

reg  [9:0]            NextHCount;
// D-input of the HCount register

reg  [9:0]            NextVCount;
// D-input of the HCount register

reg    [4:0]          NextACBCount;
// D-input of ACB counter register

reg                   EnLowFlag;
// Flag to indicate that LcdEn has gone Low in VSYNC state

reg                   NextEnLowFlag;
// D-input of EnLowFlag register

reg                   LcdEnEdgedet;
// 1 CLCDCLK wide pulse of falling edge of LcdEn signal

reg                   NextLcdEnEdgedet;
// D-input of LcdEnEdgedet 

reg                   DelLcdEn;
// 1 CLCDCLK delayed version of LcdEn signal

reg                   DelFrameRstSet;
// 1 CLCDCLK delayed version of FrameRstSet signal

reg                   NextACBInt;
// D-input of ACB signal register

reg                   NextFrameStart;
// D-input of FrameStart

reg                   NextFirstLine;
// D-input of FirstLine

reg                   UnpackEn;      
// Enable signal for unpacker state machine 

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Combinational process for Horizontal counter
// When Load enables for different values are issued, the counter is loaded with
// the corresponding value.
// the counter is decremented when Dech signal is issued
// ----------------------------------------------------------------------------
always @(LoadHFP or LoadHBP or LoadHSW or LoadCPL or HFP or HBP 
         or HSW or CPL or Dech or HCount or LoadFirstSW)
begin : p_HCounterComb
    if ((LoadHSW == 1'b1) || (LoadFirstSW == 1'b1))
        NextHCount = {2'b00,HSW};
    else
      if (LoadHFP == 1'b1)
      NextHCount = {2'b00,HFP};
    else 
      if (LoadHBP == 1'b1)
        NextHCount = {2'b00,HBP};
    else
      if (LoadCPL == 1'b1)
        NextHCount = CPL;
    else
      if (Dech == 1'b1)
         NextHCount = HCount - 10'b0000000001;
    else
       NextHCount = HCount;
end // p_HCounterComb

// -----------------------------------------------------------------------------
// Sequential process for Horizontal counter
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin :p_HCounterSeq 
  if (nCLCLKRESET == 1'b0)
   HCount <= 10'b0000000000;
  else
   HCount <= NextHCount;
end // p_HCounterSeq

// -----------------------------------------------------------------------------
// Assert HEq0 if HCount = 0 and Heq1 if HCount = 1. These signals are used
// in the horizontal state machine
// -----------------------------------------------------------------------------
assign HEq1 = (HCount == 10'b0000000001);
assign HEq0 = (HCount == 10'b0000000000);

// -----------------------------------------------------------------------------
// Combinational process for Vertical counter
// When Load enables for differnt values are issued, the counter is loaded with
// corresponding value.
// the counter is decremented when DecV signal is issued
// ----------------------------------------------------------------------------
always @(LoadVFP or LoadVBP or LoadVSW or LoadLPS or VFP or VBP 
         or VSW or LPS or VCount or DecV or LoadFirstSW)
begin : p_VCounterComb
    if ((LoadVSW == 1'b1) || (LoadFirstSW == 1'b1))
        NextVCount = {4'b0000,VSW};
    else
      if (LoadVFP == 1'b1)
      NextVCount = {2'b00,VFP};
    else
      if (LoadVBP == 1'b1)
        NextVCount = {2'b00,VBP};
    else
      if (LoadLPS == 1'b1)
        NextVCount = LPS;
    else
      if (DecV == 1'b1)
         NextVCount = VCount - 10'b0000000001;
    else
       NextVCount = VCount;
end // p_VCounterComb
 
// -----------------------------------------------------------------------------
// Sequential process for Vertical counter
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_VCounterSeq 
  if (nCLCLKRESET == 1'b0)
   VCount <= 10'b0000000000;
  else
   VCount <= NextVCount;
end // p_VCounterSeq
 
// -----------------------------------------------------------------------------
// Assert VEq0 if VCount = 0 and Veq1 if VCount = 1. These signals are used
// in the vertical state machine
// -----------------------------------------------------------------------------
assign VEq1 = (VCount == 10'b0000000001);
assign VEq0 = (VCount == 10'b0000000000);

// -----------------------------------------------------------------------------
// Combinational process for ACB counter. the counter is loaded with the ACB 
// value whenever it expires. if EnLowFlag bit is set reset the counter.
// It is decremented by the line pulse.
// ----------------------------------------------------------------------------
always @( EndOfLine or ACB or ACBCount or ACBEq0 or EnLowFlag)
begin : p_AcbCountComb
  if ((EnLowFlag == 1'b1) && (EndOfLine == 1'b1))
    NextACBCount = 5'b0;
  else if ((ACBEq0 == 1'b1) && (EndOfLine == 1'b1))
     NextACBCount = ACB;
  else
    if (EndOfLine == 1'b1)
     NextACBCount = ACBCount - 5'b00001;
  else
     NextACBCount = ACBCount;
end // p_AcbCountComb

// ----------------------------------------------------------------------------
// Sequential process for ACB Counter
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_AcbCountSeq 
  if (nCLCLKRESET == 1'b0)
    ACBCount <= 5'b00000;
  else
    ACBCount <= NextACBCount;
end // p_AcbCountSeq

// -----------------------------------------------------------------------------
// Assert ACBEq0 signal when ACBCount = 00000
// -----------------------------------------------------------------------------
assign ACBEq0 = (ACBCount == 5'b00000);

// ----------------------------------------------------------------------------
// Enable pulse for ACB signal generation.
// Asserted only if the LcdEn bit is set and EnLow flag is zero or Vertical 
// state machine state is other than SYNC state or if TFT mode is enabled.
// -----------------------------------------------------------------------------
 assign ACBEn = (((LcdEn & ~EnLowFlag) | (VState != `ST_V_SYNC)) & ACBEq0 
                   & EnFP) | LcdTFT;

// ----------------------------------------------------------------------------
// Select between NextOE(for TFT panel) and ACBInt (for STN panel)
// ACB signal is inverted, each time the ACB Counter expires.
// -----------------------------------------------------------------------------
assign ACBInt1 = (LcdTFT == 1'b1) ? NextOE^IEO : ~ACBInt;

// ----------------------------------------------------------------------------
// Combinational process for ACBInt signal 
// -----------------------------------------------------------------------------
always @ (AhbMBESyncLclk or EnLowFlag or ACBInt or ACBInt1 or ACBEn)
begin : p_ACBIntComb
  NextACBInt = ACBInt;
  if ((AhbMBESyncLclk == 1'b1) || (EnLowFlag == 1'b1))
     NextACBInt = 1'b0;
  else if (ACBEn == 1'b1)
     NextACBInt = ACBInt1;
end // p_ACBIntComb

// ----------------------------------------------------------------------------
// Sequential process for ACBInt signal 
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_ACBIntSeq
  if (nCLCLKRESET == 1'b0)
     ACBInt <= 1'b0;
  else 
      ACBInt <= NextACBInt;
end // p_ACBIntSeq

// ----------------------------------------------------------------------------
// combinational process for Line-End signal counter. the counter is loaded
// with the LEValue when LoadLEV is sampled HIGH. The counter is decremented 
// if LEWait or CLLE is sampled HIGH on each CLCDCLK.
// ----------------------------------------------------------------------------
always @(LEWait or CLLEint or LoadLEV or LEVal or LECount)
begin : p_LECountComb
  if (LoadLEV == 1'b1)
     NextLECount = LEVal;
  else
    if ((LEWait == 1'b1) || (CLLEint == 1'b1))
       NextLECount = LECount - 7'b0000001;   
  else
       NextLECount = LECount;
end // p_LECountComb

// ----------------------------------------------------------------------------
// Sequential process for LEConuter
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_LECountSeq 
  if (nCLCLKRESET == 1'b0)
     LECount <= 7'b0;
  else
     LECount <= NextLECount; 
end // p_LECountSeq

// ----------------------------------------------------------------------------
// Control logic for Line-End signal. If the LEStart and LEEn signals are 
// sampled HIGH; load LEDelay in to the counter and assert LEWait signal to 
// decrement the counter.If the counter expires; load the counter with a value
// of "3" and assert CLLE signal.This value has to be loaded to keep CLLE signal
// HIGH for 4 CLCDCLK period. If the counter expires deassert the CLLE signal.
//
// ----------------------------------------------------------------------------
always @(LEStartSet or LEEn or LEWait or CLLEint or LEDel or LECount or LcdEn)
begin : p_LECntlComb
  LoadLEV     = 1'b0;
  LEVal[6:0]  = 7'b0;
  NextLEWait  = LEWait;
  NextCLLEint = CLLEint;
  if ((LEStartSet == 1'b1) && (LEEn == 1'b1))
    begin
      LoadLEV = 1'b1;
      LEVal[6:0] = LEDel[6:0];
      NextLEWait = 1'b1;
    end
  else
     begin
       if((LEWait == 1'b1) && (LECount == 7'b0))
         begin
           NextLEWait  = 1'b0;
           LoadLEV     = 1'b1;
           LEVal[6:0]  = 7'b000011;
           NextCLLEint = 1'b1;
         end
       if (((CLLEint == 1'b1) && (LECount == 7'b0)) || (LcdEn == 1'b0))
           NextCLLEint = 1'b0;
     end
end // p_LECntlComb

// ----------------------------------------------------------------------------
// Sequential process for CLLE and LEWait signal
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_LECntlSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      LEWait  <= 1'b0;
      CLLEint <= 1'b0;
    end
  else
    begin
      LEWait  <= NextLEWait;
      CLLEint <= NextCLLEint;
    end
end // p_LECntlSeq 

// ----------------------------------------------------------------------------
// Vertical state machine
//
// - Steps through the vertical transitions and decides where the sync pulses 
//   occur and when to read Lcd Data words from the FIFO.
//
// - All state transitions occur at the end of each line (as signalled by 
//   the horiz. s/m).
//
// - VFP VBP can both be zero, in which case the corresponding
//   states are skipped.
//
// - Video comparison interrupt is generated
// ----------------------------------------------------------------------------
assign VFPEq0 = (VFP == 8'b00000000);
assign VBPEq0 = (VBP == 8'b00000000);

// ----------------------------------------------------------------------------
// Vertical State Machine combinational logic
// ----------------------------------------------------------------------------
always @(VState or VEq0 or EndOfLine or LcdEn or LcdVComp or IVS or 
         VEq1 or VBPEq0 or VFPEq0 or LcdTFT or FirstLine or CLFPint or 
         AhbMBESyncLclk or EnLowFlag or LcdEnEdgedet)
begin : p_VStateComb
  NextVState    = `ST_V_SYNC;
  NextCLFP      = 1'b0;
  LoadVFP       = 1'b0;
  LoadVBP       = 1'b0;
  LoadVSW       = 1'b0;
  LoadLPS       = 1'b0;
  DecV          = 1'b0;
  FrameRstSet   = 1'b0;
  VCompSet      = 1'b0;
  SetFirstLine  = 1'b0;
  ClrFirstLine  = 1'b0;
  NextEnLowFlag = EnLowFlag;
// ----------------------------------------------------------------------------
// if AHB master Error interrupt is set; issue Frame reset to reset front end
// of the data path(DMA FIFO/Unpacker) and wait here
// ----------------------------------------------------------------------------
  if (AhbMBESyncLclk == 1'b1)
    begin
      FrameRstSet = 1'b1;
      LoadVSW     = 1'b1;
      NextVState  = `ST_V_SYNC;
      NextCLFP    = 1'b0;
    end
  else
    case(VState[1:0])
      `ST_V_SYNC :
        begin
// ----------------------------------------------------------------------------
// if LcdEn bit goes low( LcdEn falling edge detected) set EnLow Flag. this is
// necessary to avoid toggling of the timing signals when this bit toggles.
// ---------------------------------------------------------------------------- 
          if (LcdEnEdgedet == 1'b1)
            begin
              NextEnLowFlag = 1'b1;
              FrameRstSet = 1'b1;
            end // if (LcdEnEdgedet == 1'b1)
// ----------------------------------------------------------------------------
// if LcdEn bit is set and EnLow flag is not set and the panel type is TFT. 
// assert frame pulse signal.
// ---------------------------------------------------------------------------- 
          if ((LcdEn == 1'b1) && (EnLowFlag == 1'b0) && (LcdTFT == 1'b1)) 
            NextCLFP = 1'b1;
  
// ----------------------------------------------------------------------------
// if LcdEn bit is set and EndofLine is reached: 
// Decrement vertical counter. If Counter expires: 
// - Deassert frame pulse for TFT.
// - if VBP=0 and VCOMPStat is programmed for start of ACTIVE state: set VCOMP
// status, load LPS value in to the counter and go to ACTIVE state.  
// - Else if VCOMPStat is programmed for start of BACKPORCH state: set VCOMP
//   status, Load VBP value in to the counter and go to BACKPORCH state.
// ----------------------------------------------------------------------------
          if (EndOfLine == 1'b1)
            begin
              DecV = 1'b1;
              if (VEq0 == 1'b1)
                begin
                  NextCLFP = 1'b0;
                  if ((LcdEn == 1'b1) && (EnLowFlag == 1'b1))
                    begin
                      NextEnLowFlag = 1'b0;
                      FrameRstSet = 1'b0;
                    end 
                  if (EnLowFlag == 1'b1)
                    LoadVSW = 1'b1;
                  if (EnLowFlag == 1'b0)
                    begin
                      if (VBPEq0 == 1'b1)
                        begin
                          if (LcdVComp == `C_ACTIVE)
                            VCompSet = 1'b1;
                          if (LcdTFT == 1'b0)
                            SetFirstLine = 1'b1;
                          LoadLPS    = 1'b1;
                          NextVState = `ST_V_ACTIVE;
                        end // if (VBPEq0 == 1'b1)
                      else
                        begin
                          if (LcdVComp == `C_BACKPORCH)
                            VCompSet = 1'b1;
                          LoadVBP    = 1'b1;
                          NextVState = `ST_V_BACKPORCH;
                        end
                    end // if (EnLowFlag == 1'b0)
                end // if (VEq0 == 1'b1)
            end // if (EndOfLine == 1'b1)
        end // case: `ST_V_SYNC

      `ST_V_BACKPORCH :
        begin
          NextVState = `ST_V_BACKPORCH;
// ----------------------------------------------------------------------------
// if End of line is reached decrement vertical counter by one. When counter 
// expires: - if VCOMPStatus is programmed for start of ACTIVE state assert 
// VCOMP status. 
// - assert SetFirstLine flag to generate frame pulse during the first line of
//   active period for STN panel.
// - load LPS value in to the counter and go to ACTIVE state.
// ----------------------------------------------------------------------------
          if (EndOfLine == 1'b1)
            begin
              DecV = 1'b1;
              if (VEq1 == 1'b1) 
                begin
                  if (LcdVComp == `C_ACTIVE)
                    VCompSet = 1'b1;
                  if (LcdTFT == 1'b0)
                    SetFirstLine = 1'b1;
                  LoadLPS    = 1'b1;
                  NextVState = `ST_V_ACTIVE;
                end 
            end // if (EndOfLine == 1'b1)
        end // case: `ST_V_BACKPORCH

      `ST_V_ACTIVE :
        begin
          NextVState = `ST_V_ACTIVE;
// ---------------------------------------------------------------------------- 
// Produce frame pulse on first Line if the panel type is STN. when end of line
// is reached decrement the vertical counter by one. clear the FirstLine flag.
// when counter expires:
// - if VFP value is zero: assert Frame pulse if the panel type is TFT, deassert
//   Palette RAM chipselect,deassert PowerEn bit, if VCOMPStatus is programmed
//   for start of SYNC state assert VCOMP status, issue Frame reset,  load VSW 
//   value in to the counter and go to SYNC state.
// - Else load VFP value in to the counter and go to FRONTPORCH state.
// ----------------------------------------------------------------------------
          if (FirstLine == 1'b1)
            begin
              if ((CLFPint == 1'b1 && IVS== 1'b0) || 
                  (CLFPint == 1'b0 && IVS == 1'b1))
                begin
                  NextCLFP    = 1'b0;
                  ClrFirstLine = 1'b1;
                end
              else
                NextCLFP = 1'b1;
            end // if (FirstLine == 1'b1)

          if (EndOfLine == 1'b1)
            begin
              DecV = 1'b1;
              if (VEq0 == 1'b1)   
                begin
                  if (VFPEq0 == 1'b1) 
                    begin
                      if (LcdVComp == `C_VSYNC)
                        VCompSet = 1'b1;
                      if ((LcdTFT == 1'b1) && (LcdEn == 1'b1))
                        NextCLFP = 1'b1;
                      if (LcdEnEdgedet == 1'b1)
                        NextEnLowFlag = 1'b1;
                      FrameRstSet  = 1'b1; 
                      LoadVSW      = 1'b1;
                      NextVState   = `ST_V_SYNC;
                    end // if (VFPEq0 == 1'b1)
                  else
                    begin
                      if (LcdVComp == `C_FRONTPORCH)
                        VCompSet = 1'b1;
                      LoadVFP    = 1'b1;
                      NextVState = `ST_V_FRONTPORCH;
                    end
                end // if (VEq0 == 1'b1)
            end // if (EndOfLine == 1'b1)
        end // case: `ST_V_ACTIVE

      `ST_V_FRONTPORCH :
        begin
          NextVState = `ST_V_FRONTPORCH;
// ----------------------------------------------------------------------------
// When end of line is reached decrement the verticle counter by one. When the
// counter expires:
// - assert VCOMPStatus if it is programmed for the start of SYNC state.
// - assert Frame reset to reset the DMA FIFO/Unpacker.
// - load VSW value in to the verticle counter and go to sync state.
// ----------------------------------------------------------------------------
          if (EndOfLine == 1'b1)
            begin
              DecV = 1'b1;
              if (VEq1 == 1'b1)
                begin
                  if (LcdVComp == `C_VSYNC)
                    VCompSet = 1'b1;
                  if ((LcdTFT == 1'b1) && (LcdEn == 1'b1))
                    NextCLFP = 1'b1;
                  if (LcdEnEdgedet == 1'b1)
                    NextEnLowFlag = 1'b1;
                  FrameRstSet  = 1'b1; 
                  LoadVSW      = 1'b1;
                  NextVState   = `ST_V_SYNC;
                end // if (VEq1 == 1'b1)
            end // if (EndOfLine == 1'b1)
        end // case: `ST_V_FRONTPORCH

      default :
        begin
          NextVState = `ST_V_SYNC;
        end // case: default
      
    endcase // case(VState[1:0])
end // p_VStateComb

// -----------------------------------------------------------------------------
// Horizontal state machine
//
// - Steps through the horizontal transitions and decides the LP pulse occurs.
// - State transition happens on rising edge of panel clock (CLCP).
// - TFT mode:
//   LcdCP - always running but gated externally by BCD
//
// - Passive mode:
//   LcdCP - enabled in ACTIVE state (& used as counter clock)
//
// -----------------------------------------------------------------------------

always @(HState or VState or HEq0 or LcdEn or VEq0 or DelNextRising or BCD or
         LcdTFT or HEq1 or AhbMBESyncLclk or NextRising or HEq1 or EnLowFlag or
         DelLcdEn)
begin : p_HStateComb
  NextHState      = `ST_H_SYNC;
  NextCLLP        = 1'b0;
  LoadHFP         = 1'b0;
  LoadHBP         = 1'b0;
  LoadHSW         = 1'b0;
  LoadCPL         = 1'b0;
  Dech            = 1'b0;
  EndOfLine       = 1'b0;
  NextOE          = 1'b0;
  NextSOL         = 1'b0;
  NullPC          = ~LcdTFT;
  EnFP            = 1'b0;
  FrameStartSet   = 1'b0;
  LEStartSet      = 1'b0;
// ----------------------------------------------------------------------------
// if AHB master Error interrupt is set: Load HSW value in to the horizontal 
// counter, deactivate Line pulse and wait here.
// ----------------------------------------------------------------------------
  if (AhbMBESyncLclk == 1'b1)
    begin
      LoadHSW     = 1'b1;
      NextHState  = `ST_H_SYNC;
      NextCLLP    = 1'b0;
      NextOE      = 1'b0;
    end
  else
    case (HState[1:0])
      `ST_H_SYNC :
        begin
// -----------------------------------------------------------------------------
// if LcdEn bit is set or verticle state machine is not in SYNC state, decrement
// horizontal counter on each LcdCP. When counter expires: 
// - if VCOUNT = "1", assert FrameStart signal to start DMA.
// - load HBP value in to the horizontal counter and go to BACKPORCH state.
// -----------------------------------------------------------------------------
          if ((LcdEn == 1'b1) || (EnLowFlag == 1'b1) || ( VState != `ST_V_SYNC))
            begin
              Dech = DelNextRising | BCD;
              if ((DelLcdEn == 1'b1) || (BCD == 1'b1) || (VState != `ST_V_SYNC))
                NextCLLP = 1'b1;
              if ((HEq0 == 1'b1) && ((DelNextRising == 1'b1) || (BCD == 1'b1)))
                begin
                  NextCLLP  = 1'b0;
                  if ((VState == `ST_V_SYNC) && (VEq0 == 1'b1) 
                                             && (EnLowFlag == 1'b0))
                    FrameStartSet  = 1'b1;
                  LoadHBP    = 1'b1;
                  NextHState = `ST_H_BACKPORCH;
                end 
            end 
        end // case: `ST_H_SYNC

      `ST_H_BACKPORCH :
        begin
          NextHState = `ST_H_BACKPORCH;
// ----------------------------------------------------------------------------
// Decrement horizontal counter on each LcdCP.When the counter expires:
// - if VState = ACTIVE,Enable panel clock(LcdCP) for STN.
// - if VState = ACTIVE,Assert output enable(OE) for TFT.
// - Load CPL count in to the horizontal counter and go to ACTIVE state.
// ----------------------------------------------------------------------------
          Dech = DelNextRising | BCD;

// turn on panel clock for STN panel when entering ACTIVE state one clock early
          if ((LcdTFT == 1'b0) && (VState == `ST_V_ACTIVE) && (HEq0 == 1'b1))
            if ((NextRising == 1'b1) || (DelNextRising == 1'b1))
              NullPC = 1'b0;

          if ((HEq0 == 1'b1) && (DelNextRising == 1'b1 || BCD == 1'b1))
            begin
              LoadCPL    = 1'b1;
              NextHState = `ST_H_ACTIVE;
              EnFP       = 1'b1;
              if (VState == `ST_V_ACTIVE)
                NextOE = 1'b1;  // output enable for TFT
            end 
        end // case: `ST_H_BACKPORCH

      `ST_H_ACTIVE :
        begin
// ----------------------------------------------------------------------------
// - if VState = ACTIVE, Enable panel clock(LcdCP) for STN.
// - if Vstate = ACTIVE, assert output enable for TFT.
// Decrement horizontal counter on each LcdCP.When the counter expires:
// - if VState = ACTIVE, assert LEStart signal to start Line-End signal counter.
// - Load HFP value in to the horizontal counter and go to ACTIVE state.
// ----------------------------------------------------------------------------
          NextHState = `ST_H_ACTIVE;
          Dech       = DelNextRising | BCD;
          
          if (VState == `ST_V_ACTIVE)
            begin
              NextOE = 1'b1;         // output enable for TFT panel
              if ((LcdTFT == 1'b0) && (HEq0 == 1'b1) && 
                  ((NextRising == 1'b1) || (DelNextRising == 1'b1)))
                NullPC = 1'b1;
              else
                NullPC = 1'b0;
            end // if (VState == `ST_V_ACTIVE)

          // go to front porch
          if ((HEq0 == 1'b1) && (DelNextRising == 1'b1 || BCD == 1'b1))
            begin
              NextHState = `ST_H_FRONTPORCH;
              LoadHFP    = 1'b1;
              NextOE     = 1'b0;
            end 

          if ((DelNextRising == 1'b1 || BCD == 1'b1) && (HEq1 == 1'b1) &&
              (VState == `ST_V_ACTIVE))
            LEStartSet = 1'b1;
        end // case: `ST_H_ACTIVE

      `ST_H_FRONTPORCH :
        begin
          NextHState = `ST_H_FRONTPORCH;
// ----------------------------------------------------------------------------
// Decrement horizontal counter on each LcdCP.When the counter expires:
// - assert EndofLine,CLLP and  SOL (for greyscaler) signals.
// - Load HSW value in to the horizontal counter and go to SYNC state.
// ----------------------------------------------------------------------------
          Dech       = DelNextRising | BCD;
          if ((HEq0 == 1'b1) && (DelNextRising == 1'b1 || BCD == 1'b1))
            begin
              EndOfLine  = 1'b1;
              NextSOL    = 1'b1;
              LoadHSW    = 1'b1;
              if ((LcdEn == 1'b1) || (VState != `ST_V_SYNC))
                NextCLLP  = 1'b1;
              NextHState = `ST_H_SYNC;
            end 
          
        end // case: `ST_H_FRONTPORCH

      default :
        begin
          NextHState = `ST_H_SYNC;
        end // case: default

    endcase // case(HState[1:0])
end // p_HStateComb

// ----------------------------------------------------------------------------
// Enable for loading the  width count soon after the reset
// ----------------------------------------------------------------------------
always @(LcdEn or LoadFirstSW)
begin : p_SWComb
  NextLoadFirstSW = LoadFirstSW;
  if (LcdEn == 1'b1)
    NextLoadFirstSW =  1'b0;
end // p_SWComb

// ----------------------------------------------------------------------------
// Sequential process for LoadFirstSW signal
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
  begin : p_SWCSeq 
    if (nCLCLKRESET == 1'b0)
      LoadFirstSW <=  1'b1;
    else
      LoadFirstSW <=  NextLoadFirstSW;
  end // p_SWCSeq

// ----------------------------------------------------------------------------
// Delayed version of LcdEn and EnLowFlag signals
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_DEnSeq
  if (nCLCLKRESET == 1'b0)
    begin
      DelLcdEn  <= 1'b0;
      EnLowFlag <= 1'b0;
    end
  else
    begin
      DelLcdEn  <= LcdEn;
      EnLowFlag <= NextEnLowFlag;
    end
end // p_DEnSeq

// ----------------------------------------------------------------------------
// LcdEn falling edge detection. This is required to avoid the toggling of 
// timing signals when the state machine is in sync state and LcdEn bit changes
// ----------------------------------------------------------------------------
always @(LcdEnEdgedet or DelLcdEn or LcdEn)
begin : p_EnedgeComb
   NextLcdEnEdgedet = LcdEnEdgedet;
  if ((DelLcdEn & ~LcdEn) == 1'b1)
    NextLcdEnEdgedet = 1'b1;

  else if ((LcdEn & ~DelLcdEn) == 1'b1) 
    NextLcdEnEdgedet = 1'b0;
end // p_EnedgeComb

// ----------------------------------------------------------------------------
// Sequential process for LcdEnEdgedet signal
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_EnedgeSeq
  if (nCLCLKRESET == 1'b0)
    LcdEnEdgedet <=  1'b0;
  else
    LcdEnEdgedet <= NextLcdEnEdgedet;
end // p_EnedgeSeq

// ----------------------------------------------------------------------------
// Enable panel clock generation when LCDEn bit is enabled or the state machine
// is not in SYNC state 
// ----------------------------------------------------------------------------
assign PCEn = LcdEn | (VState != `ST_V_SYNC) | (HState != `ST_H_SYNC) | 
                                                                      EnLowFlag;

// ----------------------------------------------------------------------------
// set & clear FrameRst, VComp and FrameStart signals:
// ----------------------------------------------------------------------------
assign NextFrameRst = (FrameRstSet == 1'b1)  ? 1'b1 :
                      (FrRstAckSyncLclk == 1'b1) ? 1'b0 : FrameRst;

assign NextIntFrameSt = (FrameStartSet == 1'b1) ? 1'b1 :
                        (FrameStart == 1'b1) ? 1'b0 : IntFrameStart;

assign NextVComp =      (VCompSet == 1'b1)  ? 1'b1 :
                        (VCompAckSyncLclk == 1'b1) ? 1'b0 : VCompStat;

// ----------------------------------------------------------------------------
// EndFrame pulse is equivalent to FrameRst, but only when
// it's set, to generate one pulse
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_EndFrSeq
  if (nCLCLKRESET == 1'b0)
    DelFrameRstSet <= 1'b0;
  else
    DelFrameRstSet <= FrameRstSet;
end // p_EndFrSeq

assign EndFrame = FrameRstSet & ~DelFrameRstSet;

// ----------------------------------------------------------------------------
//  Sequential process for IntFrameStart signal
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_IntFrameStSeq
  if (nCLCLKRESET == 1'b0)
    IntFrameStart    <=  1'b0;
  else
    IntFrameStart    <=  NextIntFrameSt;
end // p_IntFrameStSeq

// ----------------------------------------------------------------------------
// Assert frame start only if FrameAck is HIGH. this is needed to ensure that
// that AHB master state machine has completed the current transfer and waiting
// for the Start of frame signal.
// ----------------------------------------------------------------------------
always @(IntFrameStart or FrRstAckSyncLclk)
begin : p_FrameStComb
  if (FrRstAckSyncLclk == 1'b1)
    NextFrameStart    =  IntFrameStart;
  else 
    NextFrameStart = 1'b0;
end // p_FrameStComb

// ----------------------------------------------------------------------------
//  Sequential process for FrameStart signal
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_FrameStSeq
  if (nCLCLKRESET == 1'b0)
    FrameStart <=  1'b0;
  else
    FrameStart <= NextFrameStart;   
end // p_FrameStSeq

// ----------------------------------------------------------------------------
// Enable Power to the Lcd Panel if LcdEn is HIGH and EnLowFlag is zero.
// ----------------------------------------------------------------------------
assign IntLcdPwr = LcdPwrEn & (LcdEn | (VState != `ST_V_SYNC)) & ~NextEnLowFlag;

// ----------------------------------------------------------------------------
// Fifo read / enable signal :
//      in passive mode, use NextRising in Active video region
//      in TFT BCD mode, use NextOE
//     in TFT PC  mode, use NextRising in Active video region
// ----------------------------------------------------------------------------
assign FifoEn = ((LcdTFT == 1'b1) && (BCD == 1'b1)) ? NextOE
           : (NextRising & (VState == `ST_V_ACTIVE) & (HState == `ST_H_ACTIVE));

// ----------------------------------------------------------------------------
// Sequential logic for internal signals
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_IntSigSeq
  if (nCLCLKRESET == 1'b0)
    begin
      FrameRst      <=  1'b0;
      DelNextRising <=  1'b0;
      SOL           <=  1'b0;
      VCompStat     <=  1'b0;
      HState        <=  `ST_H_SYNC;
      VState        <=  `ST_V_SYNC;
    end
  else
    begin
      FrameRst      <=  NextFrameRst;
      DelNextRising <=  NextRising;
      SOL           <=  NextSOL;
      VCompStat     <=  NextVComp;
      HState        <=  NextHState;
      VState        <=  NextVState;
    end
end // p_IntSigSeq

// ----------------------------------------------------------------------------
// Start greyscaling of new line. signal to the greyscaler.
// ----------------------------------------------------------------------------
assign StartRow = ((SOL == 1'b1) && (VState == `ST_V_ACTIVE));

// ----------------------------------------------------------------------------
// Enable for unpacker state machine. this is required for pipelining of the
// first pixel data from the unpacker/palette.
// ----------------------------------------------------------------------------
assign NextUnpackEn = (VState != `ST_V_SYNC);

// ----------------------------------------------------------------------------
// Seqential logic to delay UnPackEn signal by one CLCDCLK cycle.
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_UnpackEnSeq
  if (nCLCLKRESET == 1'b0)
    UnpackEn <= 1'b0;
  else
    UnpackEn <= NextUnpackEn;
end // p_UnpackEnSeq

// ----------------------------------------------------------------------------
// Enable palette RAM port2(read port) when the state machine is not in VSYNC
// state. this is necessary to prevent the data corruption when the palette
// RAM is written from AHB and both read and write address matches.
// ----------------------------------------------------------------------------
assign PalLcdCSB2 = ~NextUnpackEn;

// ----------------------------------------------------------------------------
// register to hold first line flag for CLFP generation
// this is used to generate Frame pulse of 1 Line duartion during the first 
// ACTIVE line period of the display for STN panel
// ----------------------------------------------------------------------------
always @(FirstLine or SetFirstLine or ClrFirstLine)
begin : p_FirstLComb
  NextFirstLine = FirstLine;
  if ((ClrFirstLine | SetFirstLine) == 1'b1)
    NextFirstLine = SetFirstLine;
end // p_FirstLComb

// ----------------------------------------------------------------------------
// Sequential process for First line signal
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_FirstLSeq
  if (nCLCLKRESET == 1'b0)
      FirstLine <= 1'b0;
  else
      FirstLine <= NextFirstLine;
end // p_FirstLSeq

// ----------------------------------------------------------------------------
// Enable CLFP and CLLP only if LCD is enabled
// ----------------------------------------------------------------------------
assign IntCLLP1 = NextCLLP & LcdEn;
assign IntCLFP1 = NextCLFP & LcdEn;

// ----------------------------------------------------------------------------
// Combinational process for Frame pulse. if AHB master error interrupt is set 
// Drive CLFP with the inactive state value.
// ----------------------------------------------------------------------------
always @(AhbMBESyncLclk or EnFP or LcdTFT or IntCLFP1 or IntCLFP2)
begin : p_LcdFPComb
   if (AhbMBESyncLclk == 1'b1)
     NextCLFP1 = 1'b0;
   else if ((EnFP | LcdTFT) == 1'b1)
     NextCLFP1  = IntCLFP1;
   else
     NextCLFP1 = IntCLFP2;
end // p_LcdFPComb

// ----------------------------------------------------------------------------
// Sequential  process for Frame pulse.
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_LcdFPSeq
  if (nCLCLKRESET == 1'b0)
    IntCLFP2 <= 1'b0;
  else
    IntCLFP2 <= NextCLFP1;
end // p_LcdFPSeq

// ----------------------------------------------------------------------------
// AC bias signal MUX. for TFT this signal has to be output enable.
// ----------------------------------------------------------------------------
assign IntCLAC = (LcdTFT == 1'b1) ? NextOE^IEO : ACBInt;
assign IntCLAC1 = IntCLAC & LcdEn;

// ----------------------------------------------------------------------------
// register output for CLLP, CLAC signals
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PCSigSeq
  if (nCLCLKRESET == 1'b0)
    begin
      IntCLLP2   <= 1'b0;
      CLACint    <= 1'b0;
      CLPOWERint <= 1'b0;
    end
  else
    begin
      IntCLLP2   <= IntCLLP1;
      CLACint    <= IntCLAC1;
      CLPOWERint <= IntLcdPwr;
    end
end // p_PCSigSeq

// ----------------------------------------------------------------------------
// Invert CLLP and CLFP signals if invert option is enabled
// ----------------------------------------------------------------------------
assign CLLPint = IntCLLP2 ^ IHS;
assign CLFPint = IntCLFP2 ^ IVS;

// ----------------------------------------------------------------------------
// TFT panel data enable signal generation. This signal is used to drive "0"
// on TFT panel data during inactive period of display
// ----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_TFTPDEnSeq
  if (nCLCLKRESET == 1'b0)
    TFTPDEn <= 1'b0;
  else
     TFTPDEn <= NextOE;
end // p_TFTPDEnSeq

endmodule

// --================================== End ==================================--
