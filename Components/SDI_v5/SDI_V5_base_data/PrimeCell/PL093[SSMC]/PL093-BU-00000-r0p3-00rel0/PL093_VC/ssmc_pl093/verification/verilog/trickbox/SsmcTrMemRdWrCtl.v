// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTrMemRdWrCtl.v.rca
// File Revision          : 1.8
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block Interfaces the SSMC with the memory modules
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SsmcTrParams.v"

// -----------------------------------------------------------------------------

module SsmcTrMemRdWrCtl  (
// Inputs
                         HCLK,
                         HRESETn,
                         SMADDR,
                         nSMDATAEN,
                         SSMTrBankCS,
                         nSSMTrBankCS,
                         SSMTrCS,
                         nSSMTrCS,
                         nSMWEN,
                         nSMBLS,
                         nSMOEN,
                         MemRdDataDW,
                         SMCLK,
                         SMADDRVALID,
                         SSMCTrBurstWt,
                         SSMCTrMEMBASE,
                         SMTrBIDCYR,
                         SMTrBWSTRDR,
                         SMTrBWSTWRR,
                         SMTrBWSTOENR,
                         SMTrBWSTWENR,
                         SMTrBWSTBRDR,
                         SMTrBCR,
                         SMMemClkRatio,   
// Inout
                         SMDATA,
// Outputs
                         LatchSMADDR,
                         nSMBURSTWAIT,
                         SMFBCLK,
                         SMTrIND,  
                         TrnSMBLS
                        );

parameter Tclk = 7.52;         // HCLK Period

// Inputs
input         HCLK;             // AHB Bus Clock
input         HRESETn;          // Bus Reset
input  [25:0] SMADDR;           // Address Bus to Memory
input   [3:0] nSMDATAEN;        // Memory Bus Enable
input         SSMTrBankCS;      // Bank select active high
input         nSSMTrBankCS;     // Bank select active low
input   [7:0] SSMTrCS;          // The status of all the 8 banks CS active high
input   [7:0] nSSMTrCS;         // The status of all the 8 banks CS active low
input         nSMWEN;           // Write enable
input   [3:0] nSMBLS;           // Byte lane select
input         nSMOEN;           // Output enable
input  [31:0] MemRdDataDW;      // SMC read data
input         SMCLK;            // SSMC clock for synchronous memory operation
input         SMADDRVALID;      // Address valid signal
input   [8:0] SSMCTrBurstWt;    // Burst access external delay
input  [14:0] SSMCTrMEMBASE;    // Memory base address
input   [3:0] SMTrBIDCYR;       // Memory Data Bus turn around time
input   [4:0] SMTrBWSTRDR;      // Initial Read acess time
input   [4:0] SMTrBWSTWRR;      // Write access time
input   [3:0] SMTrBWSTOENR;     // CS to output enable time
input   [3:0] SMTrBWSTWENR;     // CS to write enable time
input   [4:0] SMTrBWSTBRDR;     // Burst read time after initial access
input  [21:0] SMTrBCR;          // Bank control parameters
input   [1:0] SMMemClkRatio;    // Memory clock ratio 

// Inout
inout  [31:0] SMDATA;           // Memory Data Bus

// Outputs
output [10:0] LatchSMADDR;      // Latched SSMC Address
output        nSMBURSTWAIT;     // External Burst wait signal to SSMC
output        SMFBCLK;          // Feed back clock
output        SMTrIND;          // Indicate the address[4:0] ="11111"
output  [3:0] TrnSMBLS;         // Byte Lane Select signal
                                // whose value depend on RBLE

// Inputs
wire          HCLK;             // AHB Bus Clock 
wire          HRESETn;          // Bus Reset
wire   [25:0] SMADDR;           // Address Bus to Memory
wire    [3:0] nSMDATAEN;        // Memory Bus Enable
wire          SSMTrBankCS;      // Bank select active high
wire          nSSMTrBankCS;     // Bank select active low
wire    [7:0] SSMTrCS;          // The status of all the 8 banks CS active high
wire    [7:0] nSSMTrCS;         // The status of all the 8 banks CS active low
wire          nSMWEN;           // Write enable 
wire    [3:0] nSMBLS;           // Byte lane select
wire          nSMOEN;           // Output enable
wire   [31:0] MemRdDataDW;      // SMC read data
wire          SMCLK;            // SSMC clock for synchronous memory operation
wire          SMADDRVALID;      // Address valid signal
wire    [8:0] SSMCTrBurstWt;    // Burst access external delay
wire   [14:0] SSMCTrMEMBASE;    // Memory base address
wire    [3:0] SMTrBIDCYR;       // Memory Data Bus turn around time
wire    [4:0] SMTrBWSTRDR;      // Initial Read acess time
wire    [4:0] SMTrBWSTWRR;      // Write access time
wire    [3:0] SMTrBWSTOENR;     // CS to output enable time
wire    [3:0] SMTrBWSTWENR;     // CS to write enable time   
wire    [4:0] SMTrBWSTBRDR;     // Burst read time after initial access
wire   [21:0] SMTrBCR;          // Bank control parameters
wire    [1:0] SMMemClkRatio;    // Memory clock ratio
// Inouts
wire   [31:0] SMDATA;           // Memory Data Bus

// Outputs
reg    [10:0] LatchSMADDR;      // Latched SSMC Address
reg          nSMBURSTWAIT;      // External Burst wait signal to SSMC
wire          SMFBCLK;          // Feed back clock
reg           SMTrIND;          // Indicate the address[4:0] ="11111"          
reg     [3:0] TrnSMBLS;         // Byte Lane Select signal
                                // whose value depend on RBLE

// -----------------------------------------------------------------------------
//
//                              SsmcTrMemRdWrCtl
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block constitutes the main control block in the SSMC trickbox.
// Depending on the content of the SMTrBCR register this block model the
// memory module as SRAM, FLASH, ROM or Page mode ROM. It is possible to program
// the trickmem as a memory of data size 8-bit, 16-bit and 32-bit. This module
// contains all  memory related signals given by the SSMC. All memory related
// timing parameters are checked in this module. Facility to display error
// messages, if any violation happened are also provided.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define EIGHT                   2'b00
`define SIXTEEN                 2'b01
`define THIRTYTWO               2'b10

`define ST_CNTRL_IDLE           3'b000
// IDLE state.

`define ST_CNTRL_READ           3'b001
// READ state.

`define ST_CNTRL_INTBRSTREAD    3'b010
// Burst read(initial) state.

`define ST_CNTRL_WRITE          3'b011
// Write state.

`define ST_CNTRL_BURSTREAD      3'b100
// Burst read(short) state.

`define ST_CNTRL_BURSTWRITE     3'b101
// Burst write state.

`define ST_CNTRL_SYWRITE        3'b110
// Synchronouse Write state.

`define XonSMDATAOUT            1'b0
// Controls whether 'X' or '0' is driven on SMDATA during read accesses.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        nSMBLSWR;
// Memory write enable when byte lane is using as write enable

wire        ExtBankActive;
// Assigned '0' when all chip selectes become idle.

wire        DelnSMWEN;
// Delayed version of nSMWEN to check for protocol.

wire        DelExtBankActive;
// Delayed version of ExtBankActive.

wire [10:0] DelLatchSMADDR;
// 2 ns Delayed version of LatchSMADDR

wire        DelnWR;
// 1 ns Delayed version of nWR

wire        DelnCS;
// 1 ns Delayed version of nCS

wire        Del3nCS;
// 3 ns Delayed version of nCS

wire        Del1nSMOEN;
// 1 ns Delayed version of nSMOEN.

wire        Del3nSMOEN;
// 3 ns Delayed version of nSMOEN.

wire  [3:0] DelnSMBLS;
// 1 ns Delayed version of nMPMCBLS.

wire        MaxAccErMask;
// If set to '1' it will mask the read access maximum time violation message

wire        AccErMask;
// If set to '1' it will mask the read access time violation message.

wire        WaitEn;
// SMCTrnWAIT toggle enable bit

wire        BWtMask;
// To mask the nSMBURSTWAIT

wire        BoundaryCase;
// Read-data return time select

time DisplayTime;
// for debugging

time  WenAsrn;
// WEn assertion start time.

time  WenDeAsrn;
// WEn de-assertion time.

time  IntWSTBurst;
// External burst wait time

time  IntIDCY;
// Memory idle time.

time  IntWSTRead;
// Access time for read.

time  IntWSTBInitRead;
// Initial access time for page mode ROM read.

time IntWSTBRead;
// Access time for page read.

time IntWSTWrite;
// Access time for write.

time IntWSTReadMax;
// Maximum allowable access time for read.

time IntWSTBInitRdMax;
// Maximum allowable access time for initial page mode ROM read.

time IntWSTBReadMax;
// Maximum allowable access time for page read.

time IntWSTWriteMax;
// Maximum allowable access time for write.

time IntCS2OEN;
// Memory Chip Select to Output enable time

time IntCS2WEN;
// Memory Chip Select to Write enable time

time AccessSTime;
// Latch the time when access starts

time WrEndTime;
// Latch the time when write gets finish.

time RdEndTime;
// Latch the time when read gets finish.

time AddChangeTime;
// Latch the time when address changes.

time WrSTime;
// Latch the time when write gets start.

time NBRdSTime;
// Latch the time when non page read gets start.

time BRdSTime;
// Latch the time when page read gets start.

time IdleStartTime;
// Latch the time when memory idle time start.

time DataChangeTime;
// Latch the time when data changes.

// -----------------------------------------------------------------------------
// signals for SSMC 
// -----------------------------------------------------------------------------
wire        DelSMCLK;
// Delayed SMCLK 

wire  [3:0] BeatNo;
// Number of beats after which burst wait asserted

wire  [3:0] BeatCnt;
// internal beat counter
 
wire        AddrValidWriteEn;
// Address valid for write

wire        AddrValidReadEn;
// Address valid for read

wire        BurstLenWrite;
// Burst transfer lenth for write

wire        BurstLenRead;
// Synchronous burst mode write

wire        SyncEnRead;
// Synchronous burst mode read

wire        SyncEnWrite;
// Synchronous burst mode write

wire        BMRead;
// Burst mode read

wire  [1:0] MW;
// Memory width

wire        WP;
// Write protection

wire        WaitPol;
// External wait signal polarity

wire        RBLE;
// Read byte lane enable

wire        DelOutofRange;
// Delayed OutofRange

wire        DataWrRd;
// DataWrRd indicates for Read or Write access

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg   [1:0] ClkFactor;
// Multiplying factor for Clock duration

reg  [31:0] WstRead;
// External Wait States counter for read

reg  [31:0] WstWrite;
// External Wait States counter for write

reg         WEnLatched;
// To indicate nWEN has asserted for one clock

reg         ALatched;
// To indicate the latching of SMADDR to iSyLatchSMADDR

reg         ALatchedReg;
// Registered version of ALatched signal

reg         NextALatchedReg;
// D-Input of ALatchedReg

reg         DelSMADDRVALID;
// Delayed version of SMADDRVALID

reg         StartIncrAddr;
// To indicate the latching of SMADDR to iSyLatchSMADDR

reg  [10:0] NxtSyLatchSMADDR;
// D flip flop input,Latched address for syncronous operation

reg  [10:0] iLatchSMADDR;
// Latched address for Asynchronous access

reg  [10:0] SyLatchSMADDR;
// Latched address for internal synchronous increments

reg  [10:0] iSyLatchSMADDR;
// Internal synchronous increments
        
reg         nWR;
// Memory write enable.

reg         nCS;
// Memory device enable.

reg  [31:0] SMDATAOUT;
// Memory Data bus

reg         RdCountDown;
// Count Down enable for Read process

reg         WrCountDown;
// Count Down enable for Write process

reg   [4:0] RdCount;
// Read count

reg         BwtAssert;
// To indicate assert burst wait
 
reg   [5:0] BWtAssnCount;
// Burst Wait assertion count

reg   [5:0] BWtCount;
// Burst Wait assertion counter

reg   [4:0] WrCount;
// Write count

reg   [9:0] ExtWaitCount;
// Read count

reg  [23:0] WaitCount;
// External Wait States counter

reg   [2:0] SsmcCntSt;
// State register.

reg   [2:0] NxtSsmcCntSt;
// D-input for State register.

reg  [10:0] OldLatchSMADDR;
// Store the old address.

reg         BWt;
// External Burst wait

reg         DataWrRdy;
// Data input enable signal

reg         DataRdy;
// Data out enable signal

reg  [14:0] ShiftMemBase;
// Shifted Memory Base address for comparision

reg         OutofRange;
// Memory access out of range indicator

reg         ToggSt;
// State Toggler to trigger the state machine

reg         BWtFlag;
// Flag for burst wait assertion

reg   [3:0] AddrEvent;
// Address event

reg         BWtLatched2;
// Latched version of BWt at next edge of clock

reg         BWtLatched;
// Latched verision of BWt

reg         BurstWr;
// Indicates Burst Write to the memory

reg         BurstSyWr;
// Indicates Synchronous Burst Write to the memory

reg         BurstR;
// Indicates Burst Reads to the Memory

reg         BurstSyR;
// Indicates Burst Synchronous Reads to the Memory

reg         NBurstR;
// Indicates Non-Burst Reads to the Memory

reg         OldOEN;
// For state transition 

integer i;
// FOR LOOP variable

reg  [31:0] DefData;
// Default data to be driven to the MPMCDATA

reg         Msg_Voilate;
// signal used for issuing warning message for the timing voilation of nSMWEN.

reg         WEnFlag;
// signal flags for WEn assertion.

wire         WrapRead;
// Wrap read enable

reg         WrapAct;
// Wrap read Active
// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  SMDATAOUT      = 32'hzzzzzzzz;
  SsmcCntSt      = 3'b000;
  NxtSsmcCntSt   = 3'b000;
  WrEndTime      = 0;
  RdEndTime      = 0;
  WrSTime        = 0;
  AddChangeTime  = 0;
  DataChangeTime = 0;
  iLatchSMADDR   = 10'b0000000000;
  iSyLatchSMADDR = 10'b0000000000;
  SyLatchSMADDR  = 10'b0000000000;
  BurstR         = 1'b0;
  NBurstR        = 1'b0;
  NBRdSTime      = 0;
  BRdSTime       = 0;
  IdleStartTime  = 0;
  DefData        = 32'hDEADBEEF;
  BwtAssert      = 1'b0;
  BWtAssnCount   = 6'b000000;
  BWtCount       = 6'b000000;
  WrCount        = 5'b00000;
  WstRead        = 5'b00000;
  WstWrite       = 5'b00000;
  ExtWaitCount   = 10'b0000000000;
  WaitCount      = 24'b000000000000000000000000;
  ClkFactor      = 2'b01;
  WrapAct        = 1'b0;
end

// -----------------------------------------------------------------------------
// Register field rename
// -----------------------------------------------------------------------------
assign AddrValidWriteEn = SMTrBCR[20];
assign BurstLenWrite    = SMTrBCR[19:18];
assign SyncEnWrite      = SMTrBCR[17];
assign WrapRead         = SMTrBCR[14];
assign AddrValidReadEn  = SMTrBCR[12];
assign BurstLenRead     = SMTrBCR[11:10];
assign SyncEnRead       = SMTrBCR[9];
assign BMRead           = SMTrBCR[8]; 
assign MW               = SMTrBCR[5:4];
assign WP               = SMTrBCR[3];
assign WaitEn           = SMTrBCR[2];
assign WaitPol          = SMTrBCR[1]; 
assign RBLE             = SMTrBCR[0];

// -----------------------------------------------------------------------------
// Signal assignment 
// -----------------------------------------------------------------------------
assign BeatNo           = SSMCTrBurstWt[7:4]; 
assign BWtMask          = SSMCTrBurstWt[8];   

assign nSMBLSWR         = nSMBLS[0] & nSMBLS[1] & nSMBLS[2] & nSMBLS[3];

assign DataWrRd         = nSMDATAEN[0] & nSMDATAEN[1] & nSMDATAEN[2] &
                          nSMDATAEN[3];

assign SMDATA           = SMDATAOUT;

// -----------------------------------------------------------------------------
// ClkFactor determination
// -----------------------------------------------------------------------------
always @(SMMemClkRatio)
begin : p_ClkFactorComb
  case (SMMemClkRatio)
    2'b00   : ClkFactor = 2'b01;
    2'b01   : ClkFactor = 2'b10;
    2'b10   : ClkFactor = 2'b11;
    default : ClkFactor = 2'b01;
  endcase
end // p_ClkFactorComb

// -----------------------------------------------------------------------------
// Write Enable selection according to the RBLE value
// -----------------------------------------------------------------------------
always @(RBLE or nSMBLS or nSMWEN or WEnLatched)
begin : p_SMBLSComb
  if (SyncEnWrite == 1'b1)
    begin
      if (RBLE == 1'b0)
        TrnSMBLS <= nSMBLS;
      else
        TrnSMBLS <= nSMBLS | 
                     (~{WEnLatched,  WEnLatched, WEnLatched, WEnLatched});
    end
  else
    begin
      if (RBLE == 1'b0)
        TrnSMBLS <= nSMBLS;
      else
        TrnSMBLS <= nSMBLS | {nSMWEN, nSMWEN, nSMWEN, nSMWEN};
    end
end //p_SMBLSComb    

// -----------------------------------------------------------------------------
// Chip Select/Polarity Mux
// -----------------------------------------------------------------------------
always @(SSMTrBankCS or nSSMTrBankCS)
begin : p_ChipSelComb
assign nCS = ~(SSMTrBankCS && (~(nSSMTrBankCS)));
end // p_ChipSelComb

// -----------------------------------------------------------------------------
// Write enable select Mux
// -----------------------------------------------------------------------------
always @(RBLE or nSMBLSWR or nSMWEN)
begin : p_nWRComb
  if (RBLE == 1'b0)
    nWR = nSMBLSWR;
  else
    nWR = nSMWEN;
end // p_nWRComb

// -----------------------------------------------------------------------------
// Converting std_logic_vector to time.
// -----------------------------------------------------------------------------
always @(SSMCTrBurstWt or SMTrBIDCYR or SMTrBWSTRDR or SMTrBWSTWRR or
         SMTrBWSTRDR or SMTrBWSTBRDR or SMTrBWSTOENR or SMTrBWSTWENR or
         ClkFactor)
begin
     
 IntWSTBurst      <= (SSMCTrBurstWt[3:0]) * ClkFactor * Tclk;

 IntIDCY          <= (((SMTrBIDCYR) + 1) * ClkFactor * Tclk);
 IntWSTRead       <= (((SMTrBWSTRDR) + 1) * ClkFactor * Tclk - 2);
 IntWSTWrite      <= (((SMTrBWSTWRR) + 1) * (ClkFactor * Tclk) - 
                                                (ClkFactor * Tclk));
 IntWSTBInitRead  <= (((SMTrBWSTRDR) + 1) * ClkFactor * Tclk - 2) ;
 IntWSTBRead      <= (((SMTrBWSTBRDR) + 1) * ClkFactor * Tclk - 2) ;
 IntCS2OEN        <= SMTrBWSTOENR * ClkFactor * Tclk;
 IntCS2WEN        <= SMTrBWSTWENR * ClkFactor * Tclk;
end

// -----------------------------------------------------------------------------
// Calculate the maximum allowable time for read and write access.
// -----------------------------------------------------------------------------
always @(IntWSTWrite or IntWSTRead or IntWSTBRead or
         IntWSTBInitRead or ClkFactor) 
begin
  IntWSTWriteMax   <= IntWSTWrite + 2 *(ClkFactor * Tclk) + `DelayTime;
  IntWSTReadMax    <= IntWSTRead + 1 *(ClkFactor * Tclk) + `DelayTime;
  IntWSTBReadMax   <= IntWSTBRead + 2 *(ClkFactor * Tclk) + `DelayTime;
  IntWSTBInitRdMax <= IntWSTBInitRead + 1 *(ClkFactor * Tclk) + `DelayTime;
end

// -----------------------------------------------------------------------------
// Generate the delayed version of signals
// -----------------------------------------------------------------------------
assign  # 1  DelnWR          = nWR;
assign  # 1 DelnCS           = nCS;
assign  # 3 Del3nCS          = nCS;
assign  # 7 DelnSMWEN        = nSMWEN;
assign  # 1 Del1nSMOEN       = nSMOEN;
assign  # 3 Del3nSMOEN       = nSMOEN;
assign  # 1 DelnSMBLS        = nSMBLS;
assign  # 2 DelExtBankActive = ExtBankActive;
assign  # 1 DelOutofRange    = OutofRange;  

// -----------------------------------------------------------------------------
// ExtBankActive becomes high when any other chip selects becomes enabled.
// -----------------------------------------------------------------------------
assign ExtBankActive    = (     (SSMTrCS[7] & (~(nSSMTrCS[7])))
                             | (SSMTrCS[6] & (~(nSSMTrCS[6])))
                            | (SSMTrCS[5] & (~(nSSMTrCS[5])))
                           | (SSMTrCS[4] & (~(nSSMTrCS[4])))
                          | (SSMTrCS[3] & (~(nSSMTrCS[3])))
                         | (SSMTrCS[2] & (~(nSSMTrCS[2])))
                        | (SSMTrCS[1] & (~(nSSMTrCS[1])))
                       | (SSMTrCS[0] & (~(nSSMTrCS[0]))) ) && nCS;

// -----------------------------------------------------------------------------
// SSMC clock operations
// -----------------------------------------------------------------------------
assign   #2 DelSMCLK = SMCLK;
assign      SMFBCLK  = DelSMCLK;

// -----------------------------------------------------------------------------
// Latch the time when WEN is asserted
// -----------------------------------------------------------------------------
always @(negedge nSMWEN or negedge nCS or WEnFlag)
begin : p_WenATimeComb
  if (nCS == 1'b0 && nSMWEN == 1'b0 && WEnFlag == 1'b0)
    begin
      WenAsrn <= $time;
      WEnFlag <= 1'b1;
    end
end // p_WenATimeComb
 
// -----------------------------------------------------------------------------
// Latch the time when WEN is de-asserted
// -----------------------------------------------------------------------------
always @(posedge nSMWEN or WEnFlag)
begin : p_WenDeATimeComb
  if (nSMWEN == 1'b1 && WEnFlag == 1'b1)
    begin
      WenDeAsrn <= $time;
      WEnFlag <= 1'b0;
    end
end // p_WenDeATimeComb  

// -----------------------------------------------------------------------------
// Latch the time when access starts
// -----------------------------------------------------------------------------
always @(negedge nCS)
begin : p_AccSTimeComb
  AccessSTime <= $time -  1;
end // p_AccSTimeComb

// -----------------------------------------------------------------------------
// Latch the time when write gets finish
// -----------------------------------------------------------------------------
always @(posedge nWR)
begin : p_WrEndTimeComb
    WrEndTime <= $time;
end // p_WrEndTimeComb

// -----------------------------------------------------------------------------
// Latch the time when Read gets finish
// -----------------------------------------------------------------------------
always @(posedge nSMOEN)
begin : p_RdEndTimeComb
  if (DelnCS == 1'b0)
    RdEndTime <= $time;
end // p_RdEndTimeComb

// -----------------------------------------------------------------------------
// Latch the time when chip inactive
// -----------------------------------------------------------------------------
always @(posedge nCS)
begin : p_IdlStrtTimeComb
  IdleStartTime <= $time;
end // p_IdlStrtTimeComb

// -----------------------------------------------------------------------------
// During the write cycle address should not change. Also in this design
// nSMOEN is never enabled when write is enabled.
// -----------------------------------------------------------------------------
always @(nSMOEN or nWR or nCS)
begin : p_RWAssrtComb
  if ((nSMOEN == 1'b0) && (nWR == 1'b0) && (nCS == 1'b0))
    $display($time, "Warning : SSMCTM1: Read enable and write enable are",
                    " asserted at the same time Instance \n %m", $time);
end // p_RWAssrtComb

//always @(SMADDR)
//begin : p_ADDRComb
//  if ((DelnWR == 1'b0) && (nCS == 1'b0) && (SyncEnWrite == 1'b0))
//    $display($time, "Warning : SSMCTM2: Address changed when write enable",
//                    " was active Instance \n %m", $time);
//end // p_ADDRComb

// -----------------------------------------------------------------------------
// During the read cycle chip select should not change.
// -----------------------------------------------------------------------------
always @(nCS)
begin : p_CsStatusCheck
  if (nCS == 1'b1)
    begin
      # `DelayTime;
      if (nWR == 1'b0)
        if (($time - 2*(ClkFactor * Tclk)) > WrEndTime)
          $display($time, "Warning : SSMCTM3: Chip select controlled write", 
                          "Instance \n %m", $time);

      if (nSMOEN == 1'b0)
        if (($time - 2*(ClkFactor * Tclk)) > RdEndTime)
          $display($time, "Warning : SSMCTM4: Chip select changed during read", 
                          "was active \n %m", $time);
    end
end // p_CsStatusCheck

// -----------------------------------------------------------------------------
// Checks for OEN and WEN asserted simultaneously
// -----------------------------------------------------------------------------
always @(nSMOEN or nWR or nCS)
begin : p_RdWrAssertComb
  if ((nCS == 1'b0) && (nSMOEN == 1'b0) && (nWR == 1'b0))
    $display($time, "Warning : SSMCTM5: Output Enable and Write Enable are",
                              " asserted together \n %m", $time);
end // p_RdWrAssertComb

// -----------------------------------------------------------------------------
// Idle time check between the memory banks
// -----------------------------------------------------------------------------
always @(DelExtBankActive)
begin : p_IdleBetBank
  if ((DelExtBankActive == 1'b1) && (ExtBankActive == 1'b1) && 
      ($time > IntIDCY))
    begin
      # `DelayTime;
      if (nCS == 1'b1 && (nSMBLSWR == 1'b0 || nSMWEN == 1'b0) &&
          nSMOEN == 1'b1)
        if ($time - (4 + RdEndTime) < IntIDCY)
          $display($time, "Warning : SSMCTM6: Bank to Bank idle time violation",
                           "\n %m ", $time);
    end
end // p_IdleBetBank

// -----------------------------------------------------------------------------
// Checking the address and data hold time with resepect to the rising edge
// of write signal.
// -----------------------------------------------------------------------------
always @(SMADDR)
begin : p_ADDRHldComb
  if ((nCS == 1'b0) && (($time - WrEndTime) < `AddWrHoldTime))
    $display($time, "Warning :SSMCTM7: Address hold time violation\n %m",$time);
end // p_ADDRHldComb

always @(SMDATA)
begin : p_DATAHldComb
  if (($time > 0) && (nCS == 1'b0) && (($time - WrEndTime) < `DataWrHoldTime))
    $display($time, "Warning : SSMCTM8: Data hold time violation\n %m", $time);
end // p_DATAHldComb

always @(WrEndTime)
begin : p_DATAStpComb
  if (($time > 100) && (nCS == 1'b0) &&
      ((WrEndTime - DataChangeTime) < `DataWrSetupTime))
    $display("$time, Warning : SSMCTM9: Data setup time violation\n %m",$time);
end // p_DATAStpComb

// -----------------------------------------------------------------------------
// nSMWEN assertion time check
// -----------------------------------------------------------------------------
always @(WenAsrn or WenDeAsrn or ClkFactor or Tclk)
  begin : p_nSMWENCheck
    if (((WenDeAsrn - WenAsrn) < (ClkFactor * Tclk)) && (nCS == 1'b0))
      begin
        $display("$time, Warning : SSMCTM10: nSMWEN is asserted for less than",
                       "a clock cycle.\n %m", $time);
      end
  end // p_nSMWENCheck

// -----------------------------------------------------------------------------
// BurstR signal is used by the state machine to change from READ state to the
// Burst Read state
// -----------------------------------------------------------------------------
always @(iLatchSMADDR)
begin : p_BurstRComb
  if ((WaitEn == 1'b0) && (SyncEnRead == 1'b0) &&
      (iLatchSMADDR[10:3] == OldLatchSMADDR[10:3]) && (BMRead == 1'b1))
    BurstR = 1'b1;
    # ((ClkFactor * Tclk)/2 - 1) BurstR = 1'b0;
end // p_BurstRComb

always @(nSMOEN)
begin : p_OldOENComb
  OldOEN <= nSMOEN;
end // p_OldOENComb

// -----------------------------------------------------------------------------
// BurstSyR signal is used by the state machine to change from READ state to the
// Burst(for synchronouse memory) Read state
// -----------------------------------------------------------------------------
always @(iSyLatchSMADDR)
begin : p_SyBurstRComb
  if ((SyncEnRead == 1'b1) && (BMRead == 1'b1))
    BurstSyR = 1'b1;
    # ((ClkFactor * Tclk)/2 - 1) BurstSyR = 1'b0;
end // p_SyBurstRComb
// -----------------------------------------------------------------------------
// NBurstR indicates the start of a valid read
// -----------------------------------------------------------------------------
always @(iLatchSMADDR)
begin : p_NBurstRComb
  if (SyncEnRead == 1'b0)
    NBurstR = 1'b1;
    # ((ClkFactor * Tclk)/2 - 1) NBurstR = 1'b0;
end // p_NBurstRComb

// -----------------------------------------------------------------------------
// BurstWr signal is used by the state machine to change from Write state to
// burst write state
// -----------------------------------------------------------------------------
always @(iSyLatchSMADDR)
begin : p_BurstWrComb
  if ((SyncEnWrite == 1'b1) && (nCS == 1'b0) &&
      (iSyLatchSMADDR[10:3] == OldLatchSMADDR[10:3]))
    BurstWr = 1'b1;
    # ((ClkFactor * Tclk)/2 - 1) BurstWr = 1'b0;
end // p_BurstWrComb 

// -----------------------------------------------------------------------------
// State transition process
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge DelSMCLK)
begin : p_RdWrSeq
  if (HRESETn == 1'b0)
    begin
      SsmcCntSt <= `ST_CNTRL_IDLE;
      ToggSt    <= 1'b0;
    end
  else
    begin
      SsmcCntSt <= NxtSsmcCntSt;
      ToggSt    <= ~ToggSt;
    end
end // p_RdWrSeq

// -----------------------------------------------------------------------------
// Next State generation process
// -----------------------------------------------------------------------------
always @(LatchSMADDR or iSyLatchSMADDR or nWR or nSMOEN or nCS or OutofRange
         or SsmcCntSt or SyncEnWrite or SyncEnRead or BMRead or WP or
         RdCount or ToggSt or ALatched or posedge BurstR or posedge NBurstR
         or posedge BurstWr or WrCount)
begin : p_RdWrComb
  case (SsmcCntSt)
    // IDLE STATE
    `ST_CNTRL_IDLE :
      begin
        WrCountDown <= 1'b0;
        RdCountDown <= 1'b0;
        DataRdy     <= 1'b0;
        DataWrRdy   <= 1'b0;
        if (nCS == 1'b0)
          begin
            // Write cycle started.
            if (OutofRange == 1'b1)
              NxtSsmcCntSt <= `ST_CNTRL_IDLE;
            else
              begin
                if ((nWR == 1'b0) && (SyncEnWrite == 1'b0))
                  begin
                    if (($time - (RdEndTime - 1)) < IntIDCY)
                      $display($time, " Warning : SSMCTM11: Read to write idle",
                                      " time violation \n %m", $time);

                    if (($time - AddChangeTime) < `AddWrSetupTime)
                      $display($time, " Warning : SSMCTM12: Address set up",
                                      " time violation\n %m", $time);

                    if (WaitEn == 1'b0)
                      if (($time - AccessSTime) < IntCS2WEN)
                        $display($time, " Warning : SSMCTM13: Chip Select to",
                         "Write Enable assertion time violation \n %m", $time);

                    // Write is allowed only when memory is configured as SRAM.
                    if (WP == 1'b0)
                      begin
                        NxtSsmcCntSt <= `ST_CNTRL_WRITE;
                        WrSTime      <= $time - IntCS2WEN - 2;

                        // If the programmed memory size is
                        // 8-bit then only one write enable is active at a time.
                        // 16-bit then either nSMBLS(0) and nSMBLS(1) or
                        // nSMBLS(2) and nSMBLS(3) are high at all time

                        if ((MW == `EIGHT) && (nCS == 1'b0))
                          begin
                            if ((nSMBLS[3] & nSMBLS[2] & nSMBLS[1]) == 1'b0)
                             $display("$time, Warning : SSMCTM14: Write",
                            "enable violation for an 8-bit memory\n %m", $time);
                          end
                        else if ((MW == `SIXTEEN) && (nCS == 1'b0))
                          begin
                            if ((nSMBLS[3] & nSMBLS[2]) == 1'b0)
                              $display("$time, Warning : SSMCTM15: Write",
                             "enable violation for a 16-bit memory\n %m",$time);
                          end
                      end
                    else
                      begin
                        NxtSsmcCntSt <= `ST_CNTRL_IDLE;
                        $display("SSMCTM16: Write is not supported");
                      end
                  end

               // Synchronouse write started.
                else if ((nWR == 1'b0) && (SyncEnWrite == 1'b1))
                    if (WP == 1'b0)
                      NxtSsmcCntSt <= `ST_CNTRL_SYWRITE;
                    else
                      NxtSsmcCntSt <= `ST_CNTRL_IDLE;
    
               // Read cycle started.
                else if (nSMOEN == 1'b0)
                  begin
                    if (($time - WrEndTime) < (Tclk - 2))
                      $display("$time, Warning : SSMCTM17: Write to read idle",
                               "time violation\n %m ", $time);

                    if (WaitEn == 1'b0)
                      if (($time - (AccessSTime + 0)) < IntCS2OEN)
                        $display($time, " Warning : SSMCTM18: Chip Select to",
                         "Output Enable assertion time violation \n %m", $time);

                    NBRdSTime <= $time - IntCS2OEN - 2;

                    if (BMRead == 1'b1)
                      begin
                        NxtSsmcCntSt <= `ST_CNTRL_INTBRSTREAD;
                        BRdSTime     <= $time - IntCS2OEN - 2;
                      end
                    else
                      NxtSsmcCntSt <= `ST_CNTRL_READ;
                  end
                else
                  NxtSsmcCntSt <= `ST_CNTRL_IDLE;
              end
          end
      end

    // READ State
    `ST_CNTRL_READ :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 0)
          DataRdy <= 1'b1;

        // Read cycle finished.
        if (nSMOEN == 1'b1)
          begin
            NxtSsmcCntSt <= `ST_CNTRL_IDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - NBRdSTime) > IntWSTReadMax)
                    $display("$time, Warning : SSMCTM19: Maximum time limit",
                            "for the read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("$time, Warning : SSMCTM20: Access time violation",
                              "for Read \n %m", $time);
              end
          end

        // Synchronous read access.In case of synchronous read addrvalid signal
        // will get asserted for 0ne clock cycle.
        // Address will be latched for incrementing internally.
 
        // BURST access. In case of page access higher order address will
        // not change.
        else if (BurstR == 1'b1 && nCS == 1'b0)
          begin
            DataRdy      <= 1'b0;
            NBRdSTime    <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_READ;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - NBRdSTime) > IntWSTReadMax)
                    $display("$time, Warning : SSMCTM23: Maximum time limit",
                              "for the read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("$time, Warning : SSMCTM24: Access time violation",
                                     "for the read \n %m", $time);
              end

          end
        // Continuous read.
        else if (NBurstR == 1'b1 && nSMOEN == 1'b0)
          begin
            DataRdy      <= 1'b0;
            NBRdSTime    <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_READ;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - NBRdSTime) > IntWSTReadMax)
                    $display("$time, Warning : SSMCTM25: Maximum time limit",
                       "for the non page read access has exceeded\n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("$time, Warning : SSMCTM26: Access time violation",
                             "for Read \n %m", $time);
              end
          end
        else
          NxtSsmcCntSt <= `ST_CNTRL_READ;
      end

    `ST_CNTRL_INTBRSTREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 0)
          DataRdy <= 1'b1;

        // BURST read finished.
        if (nCS == 1'b1)
          begin
            NxtSsmcCntSt <= `ST_CNTRL_IDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BRdSTime) > IntWSTBInitRdMax)
                    $display("$time, Warning : SSMCTM27: Maximum time limit",
                     "for the page read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBInitRead)
                    $display("$time, Warning : SSMCTM28: Access time violation",
                            "for page mode Read \n %m", $time);
              end
          end

        // Burst access. For Burst access lower two address bits remains
        // unchanged.
        else if (BurstR == 1'b1 && nSMOEN == 1'b0)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_BURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - BRdSTime) > IntWSTBInitRdMax) &
                      (RdEndTime < BRdSTime))
                    $display("$time, Warning : SSMCTM29: Maximum time limit",
                    "for the Busrt mode read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBInitRead)
                    $display("$time, Warning : SSMCTM30: Access time violation",
                             "for Burst mode Read \n %m", $time);
              end
          end
        // Synchronouse burst read
        else if (BurstSyR == 1'b1 && nSMOEN == 1'b0)
          begin
           DataRdy       <= 1'b1;
           NxtSsmcCntSt  <= `ST_CNTRL_BURSTREAD;
          end
 
        // Page read access with nSMOEN deasserted between transfers
        else if (BurstR == 1'b1 & nSMOEN == 1'b1)
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_BURSTREAD;
          end

        // Continuous Burst ROM read, but not the Burst access.
        else if (NBurstR == 1'b1 & nSMOEN == 1'b1)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_INTBRSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BRdSTime) > IntWSTBInitRdMax)
                    $display("$time, Warning : SSMCTM31: Maximum time limit",
                     "for the Burst mode read access has exceeded\n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBInitRead)
                    $display("$time, Warning : SSMCTM32: Access time violation",
                             "for Read \n %m ", $time);
              end
          end
        else
            NxtSsmcCntSt <= `ST_CNTRL_INTBRSTREAD;
      end

    // ST_BURSTREAD
    `ST_CNTRL_BURSTREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 0)
          DataRdy <= 1'b1;

        // Burst read finished.
        if (nCS == 1'b1)
          begin
            NxtSsmcCntSt <= `ST_CNTRL_IDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BRdSTime) > IntWSTBReadMax)
                    $display("$time, Warning : SSMCTM33: Maximum time limit",
                       "for the Burst read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBRead)
                    $display("$time, Warning : SSMCTM34: Access time violation",
                             "for Read \n %m", $time);
              end

          end

      // Burst access. For Burst access lower two address bits remains
      // unchanged.
        else if (BurstR == 1'b1)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_BURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BRdSTime) > IntWSTBReadMax)
                    $display("$time, Warning : SSMCTM35: Maximum time limit",
                         "for the Burst read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBRead)
                    $display("$time, Warning : SSMCTM36: Access time violation",
                              "for Read \n %m", $time);
              end

          end

        // Continuous Burst ROM read, but not the burst access.
        else if (NBurstR == 1'b1)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtSsmcCntSt <= `ST_CNTRL_INTBRSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BRdSTime) > IntWSTBInitRdMax)
                    $display("$time, Warning : SSMCTM37: Maximum time limit",
                     "for the page mode read access has exceeded \n %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBRead)
                    $display("$time, Warning : SSMCTM38: Access time violation",
                             "for Read \n %m", $time);
              end

          end

         // Synchronouse burst read  *** order changed
        else if (BurstSyR == 1'b1)
          begin
           DataRdy       <= 1'b1;
           NxtSsmcCntSt  <= `ST_CNTRL_BURSTREAD;
          end

        else
          NxtSsmcCntSt <= `ST_CNTRL_BURSTREAD;
      end

    // ST_WRITE
    `ST_CNTRL_WRITE :
      begin
        RdCountDown <= 1'b0;
        DataRdy     <= 1'b0;
        // Write cycle finished. Data in the SMDATA bus, is written into
        // the memory element pointed by the SMADDR value by using the rising
        // edge of the write signal.
        if (nWR == 1'b1)
          begin
            NxtSsmcCntSt <= `ST_CNTRL_IDLE;

            if (WaitEn == 1'b0)
              begin
                if (($time - WrSTime) < IntWSTWrite)
                  begin
                   DisplayTime  <= ($time - WrSTime);
                  $display($time, " Warning : SSMCTM41: Access time violation",
                                  " for write \n %m", $time);
                  end

                if (($time - WrSTime) > IntWSTWriteMax)
                   $display($time, " Warning : SSMCTM42: Maximum time limit",
                           " for write access has exceeded \n %m", $time);
              end
          end
        else
          NxtSsmcCntSt <= `ST_CNTRL_WRITE;
      end

    // Synchronous write
    `ST_CNTRL_SYWRITE :
      begin
        WrCountDown <= 1'b1;
        if (WrCount == 5'b00000)
          DataWrRdy <= 1'b1;

        if (nCS == 1'b1)
          NxtSsmcCntSt         <= `ST_CNTRL_IDLE;
        // Synchronouse Burst write started.
        // SMADDR line latched at SMADDRVALID and the address bieng increamented
        // internally at SMCLK.
        else if ((WEnLatched == 1'b1) && (BurstWr == 1'b1) && 
                 (SyncEnWrite == 1'b1))
          NxtSsmcCntSt        <= `ST_CNTRL_BURSTWRITE;
        else
        // Synchronous write being done after the SMADDRVALID signal
        // asserted and and SMADDR will be latched.
          NxtSsmcCntSt        <= `ST_CNTRL_SYWRITE;
      end
    // Synchronous burst write
    `ST_CNTRL_BURSTWRITE :
       begin
         DataWrRdy <= 1'b1;
         if (nCS == 1'b1)
           NxtSsmcCntSt         <= `ST_CNTRL_IDLE;
         else if ((WEnLatched == 1'b1) && (BurstWr == 1'b1) &&
                 (SyncEnWrite == 1'b1))
           NxtSsmcCntSt        <= `ST_CNTRL_BURSTWRITE;
       end

    // default state.
    default :
      begin
        RdCountDown  <= 1'b0;
        DataRdy      <= 1'b0;
        WrCountDown  <= 1'b0;
        DataWrRdy    <= 1'b0;
        NxtSsmcCntSt <= `ST_CNTRL_IDLE;
      end
  endcase
end // p_RdWrComb

// -----------------------------------------------------------------------------
// Capture read data
// -----------------------------------------------------------------------------
always @(WaitEn or DataRdy or RdCountDown or MemRdDataDW)
begin : p_SSMCDATAComb
  if ((WaitEn == 1'b1) && (RdCountDown == 1'b1))
    begin
      if (MW == `EIGHT)
        begin
          SMDATAOUT[7:0] = MemRdDataDW[7:0];
          SMDATAOUT[31:8] = 24'hzzzzzz;
        end
      else if (MW == `SIXTEEN)
        begin
          SMDATAOUT[15:0] = MemRdDataDW[15:0];
          SMDATAOUT[31:16] = 16'hzzzz;
        end
      else
        SMDATAOUT = MemRdDataDW;
    end
  else if (DataRdy == 1'b1)
    begin
      if (MW == `EIGHT)
        begin
          SMDATAOUT[7:0] = MemRdDataDW[7:0];
          SMDATAOUT[31:8] = 24'hzzzzzz;
        end
      else if (MW == `SIXTEEN)
        begin
          SMDATAOUT[15:0] = MemRdDataDW[15:0];
          SMDATAOUT[31:16] = 16'hzzzz;
        end
      else
        SMDATAOUT = MemRdDataDW;
    end
  else if (RdCountDown == 1'b1)
    begin
      if (`XonSMDATAOUT == 1'b0)
        begin
          if (MW == `EIGHT)
            begin
              SMDATAOUT[7:0] = DefData[7:0];
              SMDATAOUT[31:8] = 24'hzzzzzz;
            end
          else if (MW == `SIXTEEN)
            begin
              SMDATAOUT[15:0] = DefData[15:0];
              SMDATAOUT[31:16] = 16'hzzzz;
            end
          else
            SMDATAOUT = DefData;
        end
      else
        SMDATAOUT = 32'hxxxxxxxx;
    end
  else
    SMDATAOUT = 32'hzzzzzzzz;
end // p_SSMCDATAComb

// -----------------------------------------------------------------------------
// Read Wait selector
// -----------------------------------------------------------------------------
always @(NxtSsmcCntSt or ALatched)
begin : p_WstReadComb
  if (NxtSsmcCntSt == `ST_CNTRL_BURSTREAD)
    if (ALatched == 1'b0)
       WstRead = SMTrBWSTBRDR;
    else
       WstRead = 5'b00000;
  else
    if (ALatched == 1'b0)
      WstRead = SMTrBWSTRDR - SMTrBWSTOENR;
    else
      WstRead = SMTrBWSTRDR - SMTrBWSTOENR + 1;
end // p_WstReadComb

// -----------------------------------------------------------------------------
// Read Counter
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge DelSMCLK)
begin : p_RdCntrSeq
  if (HRESETn == 1'b0)
    RdCount <= 6'b111111;
  else
    begin
      if (RdCountDown == 1'b1)
        begin
          if (RdCount == 6'b000000)
            RdCount <= WstRead;
          else
            RdCount <= RdCount - 1;
        end
      else
        RdCount <= WstRead;
    end
end // p_RdCntrSeq

// -----------------------------------------------------------------------------
// Write Wait selector
// -----------------------------------------------------------------------------
always @(NxtSsmcCntSt)
begin : p_WstWriteComb
  if ((NxtSsmcCntSt == `ST_CNTRL_SYWRITE) && (RBLE == 1'b0))
    WstWrite = SMTrBWSTWRR + 1;
  else if ((NxtSsmcCntSt == `ST_CNTRL_SYWRITE) && (RBLE == 1'b1))
    WstWrite = SMTrBWSTWRR - SMTrBWSTWENR + 1;
end // p_WstWriteComb

// -----------------------------------------------------------------------------
// Write Counter
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge DelSMCLK)
//always @(negedge HRESETn or negedge DelSMCLK or WrCount)
begin : p_WrCntrSeq
  if (HRESETn == 1'b0)
    WrCount <= 5'b11111;
  else
    begin
      if (WrCountDown == 1'b1)
        begin
          if (WrCount == 5'b00000)
            WrCount <= WstWrite ;
          else
            WrCount <= WrCount - 1;
        end
      else
        WrCount <= WstWrite;
    end
end // p_WrCntrSeq

// -----------------------------------------------------------------------------
// Synchronous memory address incrementing.
// -----------------------------------------------------------------------------
//always @(posedge DelSMCLK or negedge HRESETn)
always @(posedge DelSMCLK or negedge HRESETn or nCS)
begin : p_SyncAddrIncrSeq
  if (HRESETn == 1'b0)
    iSyLatchSMADDR <= 10'b0000000000;
  else
  if (nCS == 1'b0)
  begin
    if ((ALatched == 1'b1) && (StartIncrAddr == 1'b0))
      iSyLatchSMADDR <= SyLatchSMADDR;
    else if ((ALatched == 1'b1) && (StartIncrAddr == 1'b1))
      if ((NxtSsmcCntSt == `ST_CNTRL_SYWRITE) && (WEnLatched == 1'b1))
        if ((BWtLatched2 == 1'b0) && (DataWrRdy == 1'b1))
          iSyLatchSMADDR <= iSyLatchSMADDR + 1;
        else
          iSyLatchSMADDR   <= iSyLatchSMADDR;
      else if ((NxtSsmcCntSt == `ST_CNTRL_BURSTWRITE) && (WEnLatched == 1'b1))
       //   if (BWt == 1'b0)
          if (BWtLatched == 1'b0)
            iSyLatchSMADDR <= iSyLatchSMADDR + 1;
          else
            iSyLatchSMADDR   <= iSyLatchSMADDR;
      else if (NxtSsmcCntSt == `ST_CNTRL_INTBRSTREAD)
        if (BWtFlag == 1'b0)
       //   if ((RdCount == 0) && (BWt == 1'b0))
          if ((RdCount == 6'b000000) && (BWt == 1'b0))
            if (!WrapAct)
            iSyLatchSMADDR <= iSyLatchSMADDR + 1;
            else
            if (MW == `SIXTEEN)
              begin 
              iSyLatchSMADDR[3:0] <= 4'b0000;
              iSyLatchSMADDR[9:4] <= iSyLatchSMADDR[9:4];
              end
            else
            if (MW == `THIRTYTWO)
              begin 
              iSyLatchSMADDR[2:0] <= 3'b000;
              iSyLatchSMADDR[9:3] <= iSyLatchSMADDR[9:3];
              end
            else
            iSyLatchSMADDR <= iSyLatchSMADDR + 1;
          else
            iSyLatchSMADDR   <= iSyLatchSMADDR;
        else if ((AddrEvent == 4'b0001) && (BWt == 1'b1))
            iSyLatchSMADDR   <= iSyLatchSMADDR;
        else
          if (BWtLatched2 == 1'b0)
            iSyLatchSMADDR   <= iSyLatchSMADDR + 1;
          else
            iSyLatchSMADDR   <= iSyLatchSMADDR;
      else if (NxtSsmcCntSt == `ST_CNTRL_BURSTREAD)
        if (BWtFlag == 1'b0)
          if ((RdCount == 6'b000000) && (BWt == 1'b0))
            if (!WrapAct)
            iSyLatchSMADDR <= iSyLatchSMADDR + 1;
            else
            if (MW == `SIXTEEN)
              begin
              iSyLatchSMADDR[3:0] <= 4'b0000;
              iSyLatchSMADDR[9:4] <= iSyLatchSMADDR[9:4];
              end
            else
            if (MW == `THIRTYTWO)
              begin
              iSyLatchSMADDR[2:0] <= 3'b000;
              iSyLatchSMADDR[9:3] <= iSyLatchSMADDR[9:3];
              end
            else
            iSyLatchSMADDR <= iSyLatchSMADDR + 1;
          else 
            iSyLatchSMADDR   <= iSyLatchSMADDR;
        else
          if (BWtLatched2 == 1'b0)
            iSyLatchSMADDR   <= iSyLatchSMADDR + 1;
          else
            iSyLatchSMADDR   <= iSyLatchSMADDR;
      else if (NxtSsmcCntSt == `ST_CNTRL_IDLE)
        iSyLatchSMADDR <= SyLatchSMADDR;
  end
  else
    iSyLatchSMADDR <= 10'bzzzzzzzzzz; 

end // p_SyncAddrIncrSeq

// -----------------------------------------------------------------------------
// SMTrIND signal logic
// -----------------------------------------------------------------------------
always @(iSyLatchSMADDR)
begin : p_INDComb
  if (iSyLatchSMADDR[4:0] == 5'b11111)
    SMTrIND <= 1'b0;
  else
    SMTrIND <= 1'b1;
end // p_INDComb

// -----------------------------------------------------------------------------
// WrapRead access process
// -----------------------------------------------------------------------------
always @(WrapRead or MW or iSyLatchSMADDR)
begin : p_WrapReadComb
  case (MW)
    2'b01 :
      if ((WrapRead == 1'b1) && (iSyLatchSMADDR[3:0] == 4'b1111))
        WrapAct <= 1'b1;
      else
        WrapAct <= 1'b0;
    2'b10 :
      if ((WrapRead == 1'b1) && (iSyLatchSMADDR[2:0] == 3'b111))
        WrapAct <= 1'b1;
      else
        WrapAct <= 1'b0;
    default :
      WrapAct <= 1'b0;
  endcase
end //p_WrapReadComb

// -----------------------------------------------------------------------------
// Beat counter process
// -----------------------------------------------------------------------------
always @(BeatNo or posedge nCS or negedge nCS or SsmcCntSt or AddrEvent
         or posedge ALatched or negedge ALatched or BWt or WrCount 
         or iSyLatchSMADDR or posedge WEnLatched or negedge WEnLatched
         or  RdCount)
begin : p_BeatcountComb
  case (BeatNo)
    4'b0000 :
      if (nCS == 1'b0)
        BwtAssert <= 1'b1;
      else if (nCS == 1'b1)
        BwtAssert <= 1'b0;
    4'b0001 :
      if (SsmcCntSt == `ST_CNTRL_SYWRITE)
        if ((WrCount == 5'b00001) && (WEnLatched == 1'b1))
          BwtAssert <= 1'b1;
        else if (ALatched == 1'b0)
          BwtAssert <= 1'b0;
      else if (SsmcCntSt == `ST_CNTRL_INTBRSTREAD)
        if (RdCount == 5'b00001)
          BwtAssert <= 1'b1;
        else if (ALatched == 1'b0)
          BwtAssert <= 1'b0;
    default :
      if (SsmcCntSt == `ST_CNTRL_BURSTREAD)
        if (AddrEvent == BeatNo)
          BwtAssert <= 1'b1;
        else if (ALatched == 1'b0)
          BwtAssert <= 1'b0;
      else
        if (WEnLatched == 1'b1)
          if (AddrEvent == BeatNo)
            BwtAssert <= 1'b1;
          else if (ALatched == 1'b0)
            BwtAssert <= 1'b0;
        else
          if ((nCS == 1'b0) && (AddrEvent == (BeatNo + 1)))
            BwtAssert <= 1'b1;
          else if (ALatched == 1'b0)
            BwtAssert <= 1'b0;
  endcase
end // p_BeatcountComb

// -----------------------------------------------------------------------------
// Event counter on address line
// -----------------------------------------------------------------------------
always @(iSyLatchSMADDR or negedge ALatched)
begin : p_AddrEventComb
  if (ALatched == 1'b1)
    AddrEvent <= AddrEvent + 1;
  else 
    AddrEvent <= 4'b0000;
end // p_AddrEventComb

// -----------------------------------------------------------------------------
// Assertion of nSMBURSTWAIT
// -----------------------------------------------------------------------------
always @(NxtSsmcCntSt)
begin : p_BWtAssnComb
  if (NxtSsmcCntSt == `ST_CNTRL_INTBRSTREAD)
    BWtAssnCount <= {2'b00, SSMCTrBurstWt[3:0]} + WstRead;
  else if (NxtSsmcCntSt == `ST_CNTRL_SYWRITE)
    BWtAssnCount <= {2'b00, SSMCTrBurstWt[3:0]} + WstWrite;
end // p_BWtAssnComb

// -----------------------------------------------------------------------------
// Flag signal to be used to indicate nSMBurstWait assertion
// -----------------------------------------------------------------------------
always @(posedge BWt or posedge nCS)
begin : p_BWtFlagComb
  if ((BWt == 1'b1) && (nCS == 1'b0))
    BWtFlag <= 1'b1;
  else
    BWtFlag <= 1'b0;
end // p_BWtFlagComb

// -----------------------------------------------------------------------------
// Assertion of nSMBURSTWAIT
// -----------------------------------------------------------------------------
always @(negedge DelSMCLK or negedge HRESETn )
begin : p_BURSTWtAssnSeq
  if (HRESETn == 1'b0)
    begin
      nSMBURSTWAIT <= 1'b1;
      BWt          <= 1'b0;
    end
  else if (DelSMCLK == 1'b0)
    if (((SyncEnWrite == 1'b1) || (SyncEnRead == 1'b1)) && (BWtMask == 1'b0))
      if ((BwtAssert == 1'b1) && (nCS == 1'b0))
        if (BWtCount == 0)
          begin
            nSMBURSTWAIT <= 1'b1;
            BWt          <= 1'b0;
          end
        else
          begin
            BWtCount     <= BWtCount - 1;
            nSMBURSTWAIT <= 1'b0;
            BWt          <= 1'b1;
          end
end //p_BURSTWtAssnSeq

// -----------------------------------------------------------------------------
// Assignment
// -----------------------------------------------------------------------------
always @(BWtAssnCount)
BWtCount <= BWtAssnCount;

// -----------------------------------------------------------------------------
// Latched version of nSMBURSTWAIT
// -----------------------------------------------------------------------------
always @(posedge DelSMCLK or negedge HRESETn)
begin : p_BWtLatchedSeq
  if (HRESETn == 1'b0)
    BWtLatched        <= 1'b0;
  else
    if (BWt == 1'b1)
      BWtLatched        <= 1'b1;
    else
      BWtLatched        <= 1'b0;
end // p_BWtLatchedSeq

// -----------------------------------------------------------------------------
// Latched version of nSMBURSTWAIT on the next negetive edge of clock
// -----------------------------------------------------------------------------
always @(negedge DelSMCLK or negedge HRESETn)
begin : p_BWtLatched2Seq
  if (HRESETn == 1'b0)
    BWtLatched2 <= 1'b0;
   else
     if (BWtLatched == 1'b1)
       BWtLatched2 <= 1'b1;
     else
       BWtLatched2 <= 1'b0;
end // p_BWtLatched2Seq

// -----------------------------------------------------------------------------
// Latch the time when data gets changes
// -----------------------------------------------------------------------------
always @(SMDATA)
begin : p_DatLatchTimeComb
  if (!((SMDATA[31:0] == 32'h00000000) === 1'bx))
    DataChangeTime = $time;
end // p_DatLatchTimeComb

// -----------------------------------------------------------------------------
// Base address shifting for comparision.
// -----------------------------------------------------------------------------
always @(SSMCTrMEMBASE or MW)
begin : p_SMBaseShiftComb
  if (MW == `EIGHT)
    ShiftMemBase = SSMCTrMEMBASE;
  else if (MW == `SIXTEEN)
    ShiftMemBase = {1'b0, SSMCTrMEMBASE[14:1]};
  else if (MW == `THIRTYTWO)
    ShiftMemBase = {2'b00, SSMCTrMEMBASE[14:2]};
end // p_SMBaseShiftComb

// -----------------------------------------------------------------------------
// Address Mux. This process generate the latched address depend on the
// programed size of the memory width.
// -----------------------------------------------------------------------------
always @(SMADDR or ShiftMemBase or SMADDRVALID or DataWrRd or AddrValidReadEn
         or SyncEnRead or AddrValidWriteEn or SyncEnWrite)
begin : p_SMAddrLatchComb
  AddChangeTime = $time;
  if (SMADDR[25:11] == ShiftMemBase)
    begin
      OutofRange <= 1'b0;
      if ((SMADDRVALID == 1'b0) && (AddrValidReadEn == 1'b1) &&
          (SyncEnRead == 1'b1) && (DataWrRd == 1'b1))
        SyLatchSMADDR = SMADDR[10:0];
      else if ((SMADDRVALID == 1'b0) && (AddrValidWriteEn == 1'b1) &&
               (SyncEnWrite == 1'b1) && (DataWrRd == 1'b0))
        SyLatchSMADDR = SMADDR[10:0];
      else
        iLatchSMADDR = SMADDR[10:0];
    end
  else
    OutofRange = 1'b1;
end // p_SMAddrLatchComb

// -----------------------------------------------------------------------------
// Address laching for Synchronouse memory operations
// -----------------------------------------------------------------------------
always @(ALatchedReg or SMADDRVALID or DelSMADDRVALID or AddrValidReadEn or
         SyncEnRead or DataWrRd or AddrValidWriteEn or SyncEnWrite or nCS)
begin : p_SyncAddrComb
  NextALatchedReg <= ALatchedReg;
  if ((SMADDRVALID == 1'b0) && (DelSMADDRVALID == 1'b1))
    if ((AddrValidReadEn == 1'b1) && (SyncEnRead == 1'b1) && (DataWrRd == 1'b1))
      NextALatchedReg <= 1'b1;
    else if ((AddrValidWriteEn == 1'b1) && (SyncEnWrite == 1'b1) &&
             (DataWrRd == 1'b0))
      NextALatchedReg <= 1'b1;
    else
      NextALatchedReg <= 1'b0;
  else if (nCS == 1'b1)
    NextALatchedReg <= 1'b0;
end // p_SyncAddrComb

// -----------------------------------------------------------------------------
// ALatched signal assignment for indication of address latching
// -----------------------------------------------------------------------------
always @(NextALatchedReg or ALatchedReg or nCS)
begin : p_ALatchedComb
  ALatched <= ((NextALatchedReg || ALatchedReg) && (~(nCS)));
end // p_ALatchedComb
       
// -----------------------------------------------------------------------------
// Start address incrementing internally after 1 clock of ALatched.
// -----------------------------------------------------------------------------
always @(posedge DelSMCLK or negedge HRESETn)
begin : p_StartIncrAddrSeq
  if (HRESETn == 1'b0)
    begin
      StartIncrAddr  <= 1'b0;
      DelSMADDRVALID <= 1'b1;
      ALatchedReg    <= 1'b0;
    end  
  else
    begin
      DelSMADDRVALID <= SMADDRVALID;
      ALatchedReg    <= NextALatchedReg; 
      if (ALatched == 1'b1)
        StartIncrAddr <= 1'b1;
      else
        StartIncrAddr <= 1'b0;
    end
end // p_StartIncrAddrSeq

// -----------------------------------------------------------------------------
// nWEN Latching process for sunchronous operation
// -----------------------------------------------------------------------------
always @(negedge nSMWEN or  nCS or negedge HRESETn)
//always @(nSMWEN or  nCS or negedge HRESETn)
begin : p_SyncWEnLatchComb
  if (HRESETn == 1'b0)
    WEnLatched <= 1'b0;
else if ((nSMWEN == 1'b0) && (nCS == 1'b0))
    WEnLatched <= 1'b1;
  else if (nCS == 1'b1)
    WEnLatched <= 1'b0;
end // p_SyncWEnLatchComb

// -----------------------------------------------------------------------------
// Out of range access warning
// -----------------------------------------------------------------------------
always @(DelOutofRange or DelnCS)
begin : p_OutofRngComb
  if ((DelOutofRange == 1'b1) && (DelnCS == 1'b0) && (DelnCS == nCS))
    $display($time, " Warning : SSMCTM43: Accessed location is out",
                    "of range \n %m", $time);
end // p_OutofRngComb

// -----------------------------------------------------------------------------
// Old SSMCADDR
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge DelSMCLK)
begin : p_OldAddrLtchComb
  if (HRESETn == 1'b0)
    OldLatchSMADDR <= 11'b00000000000;
  else
    if (ALatched == 1'b1)
      OldLatchSMADDR <= iSyLatchSMADDR;
    else
      OldLatchSMADDR <= iLatchSMADDR;
end // p_OldAddrLtchComb

// -----------------------------------------------------------------------------
// nSMBLS check during read. During read cycle nSMBLS should be "1111" when
// RBLE = '0' and nSMBLS should be "0000" when RBLE = '1'
// -----------------------------------------------------------------------------
always @(nSMBLS or DelnSMBLS or Del1nSMOEN or nSMOEN or RBLE or nCS)
begin : p_SMBLSChkComb
  if (((Del1nSMOEN | nSMOEN) == 1'b0) && (nCS == 1'b0))
    begin
      if ((RBLE == 1'b0) && ((nSMBLS < 4'hF) && (DelnSMBLS < 4'hF)))
        $display("$time, Warning : SSMCTM44: nSMBLS violation when RBLE = '0' ",
                              "during read \n %m", $time);

      if ((RBLE == 1'b1) && ((nSMBLS > 4'h0) && (DelnSMBLS > 4'h0)))
        $display("$time, Warning : SSMCTM45: nSMBLS violation when RBLE = '1'",
                                 "during read \n %m", $time);
    end
end // p_SMBLSChkComb

// -----------------------------------------------------------------------------
// Assign local copy to the output
// -----------------------------------------------------------------------------
always @(iLatchSMADDR or iSyLatchSMADDR or ALatched or nCS)
begin : p_SMADDRMuxComb
  if (nCS == 1'b0)
    if (ALatched == 1'b1)
      LatchSMADDR <= iSyLatchSMADDR;
    else
      LatchSMADDR <= iLatchSMADDR;
  else
    LatchSMADDR <= 10'bzzzzzzzzzz;
end // p_SMADDRMuxComb
 
endmodule

// --================================== End ==================================--
