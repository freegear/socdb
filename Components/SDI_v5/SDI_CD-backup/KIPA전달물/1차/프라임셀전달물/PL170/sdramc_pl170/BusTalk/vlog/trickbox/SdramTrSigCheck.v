//  ----------------------------------------------------------------------------
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
//  File Name              : $RCS: $
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
//  ----------------------------------------------------------------------------
//  Purpose                : This block checks for different conditions and 
//                           commands issued by the Controller.
//  ----------------------------------------------------------------------------

`timescale 1ns/1ps

module SdramTrSigCheck ( 
                         HCLK,
                         HRESETn,
                         nPOR,
                         ReadSel,
                         WriteSel,
                         DIn,
                         CKE,
                         nRAS,
                         nCAS,
                         nCS,
                         nWE,
                         A10,
                         A5,
                         A6,
 
                         DOut,
                         ModeBit 
                        ); 

input         HCLK;      // AHB clock input
input         HRESETn;   // Reset from AHB
input         nPOR;      // Power On Reset
input         ReadSel;   // Read Select from the top module
input         WriteSel;  // Write Select from the top module
input [31:0]  DIn;       // Data Input from the top module
input [3:0]   CKE;       // Clock Enable Pin to memory device
input [3:0]   nCS;       // Chip Select
input         nRAS;      // nRAS output from the memory module
input         nCAS;      // nCAS output from the memory module
input         nWE;       // nWE output from the memory module
input         A10;       // Addr[10] output from the memory module
input         A6;        // Addr[6] output from the memory module
input         A5;        // Addr[5] output from the memory module

output [31:0] DOut;      // Data Output to the top module
output        ModeBit;   // SDRAM Select

// ----------------------------------------------------------------------------
//
//                      SdramTrSigCheck
//                      ===============
//      
// ----------------------------------------------------------------------------
//
// Overview
// ========
// This module checks for different commands issued by the UUT. It checks
// the Refresh command width and also the cycles taken between two consecutive 
// Refresh commands. It also checks for the correctness of the Refresh cycle 
// frequency.
//
// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Port declarations
// -----------------------------------------------------------------------------
wire        HCLK;
wire        HRESETn;
wire        ReadSel;
wire        WriteSel;
wire [31:0] DIn;
wire [3:0]  CKE;
wire [3:0]  nCS;
wire        nRAS;
wire        nCAS;
wire        nWE;
wire        A10;
wire        A6;
wire        A5;

wire [31:0] DOut;
reg         ModeBit;

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
wire        NextPALL;
// D-Input to PALL

wire        NextNOP;
// D-Input to NOP

wire        NextModeBit;
// D-Input to ModeBit

wire        NextModeRegCommand;
// D-Input to ModeRegCommand

wire [6:0]  NextRegCount;
// D-Input to RegCount

wire        nReset;

wire [3:0]  NextRefCount;

wire [15:0] NextExpRefCycles;

wire        NextInitCheckEn;

wire        ValidRefCommand;

wire        NextRefCommand;

wire [2:0]  NextRefWidth;

wire [31:0] NextDataReg;

wire        NextSREF;
// D-Input to SREF

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         SREF;
// SREF command Detect Ouptut

reg [2:0]   PresentState;

reg [2:0]   NextState;

reg         InitSeqSt;

reg         NextInitSeqSt;

reg         RefCommand;

reg         DelayRefCommand;

reg [2:0]   RefWidth;

reg         NextRefStatus;

reg         RefStatus;

reg [3:0]   RefCount;

reg [15:0]  RefCycles;

reg [15:0]  NextRefCycles;

reg         ModeRegCheck;

reg         NextModeRegCheck;

reg         InitCheckEn;

reg         ModeRegCommand;

reg [6:0]   ModeRegCount;

reg         PhaseRefEn;

reg         NextPhaseRefEn;

reg         RefCheckEn;

reg         NextRefCheckEn;

reg         RefErrStat;

reg         NextRefErrStat;

reg         NOP;
// NOP command Detect Ouptut

reg [15:0]  ExpRefCycles;

reg [31:0]  DataReg;

reg         PALL;
// PALL command Detect Ouptut

reg [2:0]   RefIgnore; 

reg [2:0]   NextRefIgnore;

// -----------------------------------------------------------------------------
//
// Main Verilog code
// =================
//
// ----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Refresh Check Error Status 
// ---------------------------------------------------------------------------
always @(ExpRefCycles or ValidRefCommand or RefIgnore or RefCheckEn or 
         RefCycles or RefErrStat or WriteSel or DIn)
begin
  if (WriteSel && DIn[10])
    NextRefErrStat = 1'b0;
  else if (ValidRefCommand && (RefIgnore == 3'b000) && RefCheckEn)
    begin
      if ((RefCycles < (ExpRefCycles - 2'b10)) || 
          (RefCycles > (ExpRefCycles + 2'b10)))
        NextRefErrStat = 1'b1;
    end
  else
    NextRefErrStat = RefErrStat;
end 

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    RefErrStat <= 1'b0;
  else
    RefErrStat <= NextRefErrStat;
end 

// ---------------------------------------------------------------------------
// Expected Refresh Cycles
// ---------------------------------------------------------------------------
assign NextExpRefCycles = WriteSel ? DIn[26:11] :
                          ExpRefCycles;

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    ExpRefCycles <= 16'h0000;
  else
    ExpRefCycles <= NextExpRefCycles;
end 

// ---------------------------------------------------------------------------
// Refresh Check Enable 
// ---------------------------------------------------------------------------
always @(PhaseRefEn or ValidRefCommand or RefIgnore or RefCheckEn)
begin
  if (PhaseRefEn)
    NextRefCheckEn = 1'b1;
  else if (ValidRefCommand && (RefIgnore == 3'b000))
    NextRefCheckEn = 1'b0;
  else
    NextRefCheckEn = RefCheckEn;
end 

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    RefCheckEn <= 1'b0;
  else
    RefCheckEn <= NextRefCheckEn;
end 

// ---------------------------------------------------------------------------
// Phase Delayed Refresh Check Enable
// ---------------------------------------------------------------------------
always @(WriteSel or DIn)
begin
  if (WriteSel)
    NextPhaseRefEn = DIn[9];
  else 
    NextPhaseRefEn = 1'b0;
end 

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    PhaseRefEn <= 1'b0;
  else
    PhaseRefEn <= NextPhaseRefEn;
end 

// ---------------------------------------------------------------------------
// Refresh Ignore 
// ---------------------------------------------------------------------------
always @(PhaseRefEn or ValidRefCommand or RefIgnore)
begin
  if (PhaseRefEn)
    NextRefIgnore = 3'b100;
  else if (ValidRefCommand && (RefIgnore != 3'b000))
    NextRefIgnore = RefIgnore - 1'b1;
  else
    NextRefIgnore = RefIgnore;
end 

// ---------------------------------------------------------------------------
// NextRefIgnore value is assigned to RefIgnore at the negative edge of HCLK
// to provide half a clock preiod for RefErrStat to be set if the difference
// between RefCycles and ExpRefCycles is more than 2'b10
// ---------------------------------------------------------------------------
always @(negedge HCLK or negedge nReset)
begin
  if (~nReset)
    RefIgnore <= 3'b000;
  else
    RefIgnore <= NextRefIgnore;
end 

// ---------------------------------------------------------------------------
// Mode Register Command 
// ---------------------------------------------------------------------------
assign NextModeRegCommand = ModeBit ? (~nRAS & ~nCAS & ~nWE & A5 & ~&nCS) :
                            (~nRAS & ~nCAS & ~nWE & ~&nCS);

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    ModeRegCommand <= 1'b0;
  else
    ModeRegCommand <= NextModeRegCommand;
end

// ---------------------------------------------------------------------------
// Mode Register Command Counter
// ---------------------------------------------------------------------------
assign NextRegCount = ~InitCheckEn ? 7'b0000000 :
                      ModeRegCommand ? (ModeRegCount + 1'b1) :
                      ModeRegCount;

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    ModeRegCount <= 7'b0000000;
  else
    ModeRegCount <= NextRegCount;
end

// ---------------------------------------------------------------------------
// Mode Register Command Check
// ---------------------------------------------------------------------------
always @(ModeRegCount or ModeRegCommand or ModeRegCheck or A6 or ModeBit or 
         InitCheckEn)
begin
  if (~InitCheckEn)
    NextModeRegCheck = 1'b0;
  else if ((ModeRegCount == 7'b0000100) & ~ModeBit)
    NextModeRegCheck = 1'b1;
  else if (ModeBit & ModeRegCommand)
  begin
    if (ModeRegCount == 7'b1000111)
      NextModeRegCheck = 1'b1;  
    case(ModeRegCount)
    7'b0000000,
    7'b0010010,
    7'b0100100,
    7'b0110110:
    if (A6)
      $display($time,"Error! SCLR expected instead of SCCR");
    default :
      if (~A6)  
        $display($time,"Error! SCCR expected instead of SCLR");
    endcase
  end
  else
    NextModeRegCheck = ModeRegCheck;
end
 
always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    ModeRegCheck <= 1'b0;
  else
    ModeRegCheck <= NextModeRegCheck;
end

// ---------------------------------------------------------------------------
// NOP Condition Check
// ---------------------------------------------------------------------------
assign NextNOP = CKE[0] & CKE[1] & CKE[2] & CKE[3] & ~nCS[0] & ~nCS[1] & 
                 ~nCS[2] & ~nCS[3] & nRAS & nCAS & nWE;

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    NOP <= 1'b0;
  else
    NOP <= NextNOP;
end

// ---------------------------------------------------------------------------
// Initialization Sequence Check StateMachine
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    PresentState <= 3'b000;
  else
    PresentState <= NextState;
end

// ---------------------------------------------------------------------------
// Initialization Sequence Check Status
// ---------------------------------------------------------------------------
 always @(PresentState or WriteSel or DIn or InitSeqSt or ModeRegCheck)
 begin
   if (WriteSel & DIn[1])
     NextInitSeqSt = 1'b0; 
   else if ((PresentState == 3'b100) && ModeRegCheck)
     NextInitSeqSt = 1'b1;
   else
     NextInitSeqSt = InitSeqSt;
 end 

 always @(posedge HCLK or negedge nReset)
 begin
   if (~nReset)
     InitSeqSt <= 1'b0;
   else
     InitSeqSt <= NextInitSeqSt;
 end

//  ----------------------------------------------------------------------------
//   Next State logic generation
//  ----------------------------------------------------------------------------
 always @(PresentState or NOP or PALL or RefStatus or ModeRegCheck or
          InitCheckEn or InitSeqSt )
 begin
    NextState = PresentState;
    case (PresentState) // synopsys parallel_case full_case
    3'b000:
    begin
      if (InitCheckEn)
        NextState = 3'b001;
    end

    3'b001:
    begin
      if (NOP)
        NextState = 3'b010;
    end
 
    3'b010:
    begin
      if (PALL)
        NextState = 3'b011;
      else if (NOP)
        $display($time,"Error! NOP Has Been Issued More Than Once");
    end

    3'b011:
    begin
      if (PALL)
        $display($time,"Error! PALL Has Been Issued More Than Once");
      else if (NOP)
        $display($time,"Error! NOP Has Been Issued More Than Once");
      else if (RefStatus)
        NextState = 3'b100;
    end

    3'b100:
    begin
      if (PALL)
        $display($time,"Error! PALL Has Been Issued More Than Once");
      else if (NOP)
        $display($time,"Error! NOP Has Been Issued More Than Once");
      else if (ModeRegCheck)
        NextState = 3'b000;
    end
 
    default:
      NextState = 3'b000;

    endcase
 end
 
// ---------------------------------------------------------------------------
// nReset Generation
// ---------------------------------------------------------------------------
assign nReset = HRESETn & nPOR;

// ---------------------------------------------------------------------------
// VCSDRAM/SDRAM Mode Bit
// ---------------------------------------------------------------------------
assign NextModeBit = WriteSel ? DIn[2] : ModeBit;
 
always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    ModeBit <= 1'b0;
  else
    ModeBit <= NextModeBit;
end

// ---------------------------------------------------------------------------
// InitCheckEn bit
// ---------------------------------------------------------------------------
assign NextInitCheckEn = WriteSel  ? DIn[0] : 
                         InitSeqSt ? 1'b0   :
                         InitCheckEn;

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    InitCheckEn <= 1'b0;
  else
    InitCheckEn <= NextInitCheckEn;
end

// ---------------------------------------------------------------------------
// Sensing The Refresh Command and check for the validity of the command
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Refresh Command Generation
// ---------------------------------------------------------------------------
assign NextRefCommand = ~nRAS & ~nCAS & nWE & CKE[0] & CKE[1] & CKE[2] & 
                        CKE[3] & ((nCS[0] & nCS[1] & (nCS[2]^nCS[3])) | 
                        (nCS[2] & nCS[3] & (nCS[1]^nCS[0])));

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    RefCommand <= 1'b0;
  else
    RefCommand <= NextRefCommand;
end

// ---------------------------------------------------------------------------
// Refresh Command Validity Check
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    DelayRefCommand <= 1'b0;
  else
    DelayRefCommand <= RefCommand;
end

assign NextRefWidth = NextRefCommand & ~nCS[3] & (RefWidth == 3'b000) ? 3'b100:
                      NextRefCommand & ~nCS[2] & (RefWidth == 3'b100) ? 3'b011:
                      NextRefCommand & ~nCS[1] & (RefWidth == 3'b011) ? 3'b010:
                      NextRefCommand & ~nCS[0] & (RefWidth == 3'b010) ? 3'b001:
                      RefWidth == 3'b001 ? 3'b000 : RefWidth;
                       
always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    RefWidth <= 3'b000;
  else
    RefWidth <= NextRefWidth;
end

assign ValidRefCommand = (ModeBit == 1'b0) ? (
                         ~RefCommand & DelayRefCommand & (RefWidth == 3'b000)?
                         1'b1 : 1'b0 ) : (RefWidth == 3'b000 ? 1'b1 : 1'b0); 

always @(posedge HCLK)
begin
  if (~RefCommand & DelayRefCommand & ~ValidRefCommand & ~ModeBit)
    $display($time,"Warning : Not Valid Refresh Request");
end

// ---------------------------------------------------------------------------
// Refresh Command Counter : Enabled only when InitCheckEn bit is On.
// ---------------------------------------------------------------------------
assign NextRefCount = (PresentState != 3'b011) ? 4'b0000  : 
                      ValidRefCommand ? (RefCount + 1'b1) : 
                      RefCount; 

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    RefCount <= 4'b0000;
  else
    RefCount <= NextRefCount;
end

// ---------------------------------------------------------------------------
// No of Refresh Command Check
// ---------------------------------------------------------------------------
always @(RefCount or RefStatus & PresentState) 
begin
  if (PresentState == 3'b011)
    if (RefCount[3])
      NextRefStatus = 1'b1;
    else
      NextRefStatus = 1'b0;
  else if (PresentState != 3'b011)
    NextRefStatus = 1'b0;
  else
    NextRefStatus = RefStatus;
end

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    RefStatus <= 1'b0;
  else
    RefStatus <= NextRefStatus;
end

// ---------------------------------------------------------------------------
// No of Cycles between two Refresh Command
// ---------------------------------------------------------------------------
always @(ValidRefCommand or RefCycles)
begin
  if (ValidRefCommand)
    NextRefCycles = 16'h0000;
  else
    NextRefCycles = RefCycles + 1'b1;
end

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    RefCycles <= 16'h0000;
  else
    RefCycles <= NextRefCycles;
end

// ---------------------------------------------------------------------------
// PALL Check
// ---------------------------------------------------------------------------
assign NextPALL = ModeBit ? (~nRAS & ~nCAS & ~nWE & A10 & ~A5) :
                  (~nRAS & nCAS & ~nWE & A10);

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    PALL <= 1'b0;
  else
    PALL <= NextPALL;
end

// ---------------------------------------------------------------------------
// SREF Check
// ---------------------------------------------------------------------------
assign NextSREF = ~nRAS & ~nCAS & nWE & ~CKE[0] & ~CKE[1] & ~CKE[2] & 
                  ~CKE[3] & ~nCS[0] & ~nCS[1] & ~nCS[2] & ~nCS[3];

always @(posedge HCLK or negedge nReset)
begin
  if (nReset == 1'b0)
    SREF <= 1'b0;
  else
    SREF <= NextSREF;
end

// ---------------------------------------------------------------------------
// Data Output on ReadSel. Removed the qualification of HCLK with ReadSel
// for transfering the DataReg to DOut in AHB case.
// ---------------------------------------------------------------------------
assign DOut = (ReadSel) ? DataReg : 
              'h00000000;

// ---------------------------------------------------------------------------
// Data Register
// ---------------------------------------------------------------------------
assign NextDataReg = {5'b00000, ExpRefCycles, RefErrStat, RefCheckEn, CKE, 
                      A10, SREF, ModeBit, InitSeqSt, InitCheckEn};

always @(posedge HCLK or negedge nReset)
begin
  if (~nReset)
    DataReg <= 32'h00000000;
  else
    DataReg <= NextDataReg;
end 

endmodule

// --================================== End ==================================--
