// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MpmcTrMemRdWrCtl.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block controls the read-write operations of the TrickMem
//           memory model. This also performs the memory protocol checks.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MpmcTrParams.v"

// -----------------------------------------------------------------------------

module MpmcTrMemRdWrCtl (
// Inputs
                         HCLK,
                         HRESETn,
                         MPMCADDR,
                         nMPMCDATAEN,
                         MPMCTrCS,
                         MPMCTrAllCS,
                         nMPMCWEN,
                         nMPMCBLS,
                         nMPMCOEN,
                         MemRdDataDW,
                         MPMCTrIDCY,
                         MPMCTrWaitRd,
                         MPMCTrWaitWr,
                         MPMCTrWaitPg,
                         MPMCTrMEMT,
                         MPMCTrMEMB,
                         MPMCTrCS2OEN,
                         MPMCTrCS2WEN,
                         MPMCTrExtWait,
                         MPMCTrCSPOL,

// Inouts
                         MPMCDATA,

// Outputs
                         LatchMCADDR,
                         MPMCActLowCS
                        );

parameter Tclk = 60.00;         // HCLK Period

// Inputs
input         HCLK;             // AHB Bus Clock
input         HRESETn;          // Bus Reset
input  [27:0] MPMCADDR;         // Address Bus to Memory
input   [3:0] nMPMCDATAEN;      // Memory Bus Enable
input         MPMCTrCS;         // Bank select
input   [7:0] MPMCTrAllCS;      // The status of all the 8 banks
                                // connected with the MPMC
input         nMPMCWEN;         // Write enable
input   [3:0] nMPMCBLS;         // Byte lane select
input         nMPMCOEN;         // Output enable
input  [31:0] MemRdDataDW;      // MPMC read data
input   [4:0] MPMCTrIDCY;       // Memory Data Bus turn around time
input   [5:0] MPMCTrWaitRd;     // Read access/Initial access time
input   [5:0] MPMCTrWaitWr;     // Write access/Page mode read access time
input   [5:0] MPMCTrWaitPg;     // Page mode access time
input  [10:0] MPMCTrMEMT;       // Memory type
input  [16:0] MPMCTrMEMB;       // Memory Base Address
input   [4:0] MPMCTrCS2OEN;     // CS-nMPMCOEN assertion delay
input   [4:0] MPMCTrCS2WEN;     // CS-nMPMCWEN assertion delay
input   [9:0] MPMCTrExtWait;    // Extented Wait count Register
input   [7:0] MPMCTrCSPOL;      // Chip Select polarity

// Inouts
inout  [31:0] MPMCDATA;         // Memory Data Bus

// Outputs
output [10:0] LatchMCADDR;      // Latched MPMC Address
output        MPMCActLowCS;     // Used for suitably routing the MPMCWAIT
                                // signal

// Inputs
wire          HCLK;             // AHB Bus Clock
wire          HRESETn;          // Bus Reset
wire   [27:0] MPMCADDR;         // Address Bus to Memory
wire    [3:0] nMPMCDATAEN;      // Memory Bus Enable
wire          MPMCTrCS;         // Bank select
wire    [7:0] MPMCTrAllCS;      // The status of all the 8 banks
                                // connected with the MPMC
wire          nMPMCWEN;         // Write enable
wire    [3:0] nMPMCBLS;         // Byte lane select
wire          nMPMCOEN;         // Output enable
wire   [31:0] MemRdDataDW;      // MPMC read data
wire    [4:0] MPMCTrIDCY;       // Memory Data Bus turn around time
wire    [5:0] MPMCTrWaitRd;     // Read access/Initial access time
wire    [5:0] MPMCTrWaitWr;     // Write access/Page mode ROM initial read
                                // access time
wire    [5:0] MPMCTrWaitPg;     // Page access time
wire   [10:0] MPMCTrMEMT;       // Memory type
wire   [16:0] MPMCTrMEMB;       // Memory Base Address
wire    [4:0] MPMCTrCS2OEN;     // CS-nMPMCOEN assertion delay
wire    [4:0] MPMCTrCS2WEN;     // CS-nMPMCWEN assertion delay
wire    [9:0] MPMCTrExtWait;    // Extented Wait count Register
wire    [7:0] MPMCTrCSPOL;      // Chip Select polarity

// Inouts
wire   [31:0] MPMCDATA;         // Memory Data Bus

// Outputs
reg    [10:0] LatchMCADDR;      // Latched MPMC Address
wire          MPMCActLowCS;     // Used for suitably routing the MPMCWAIT
                                // signal

// -----------------------------------------------------------------------------
//
//                              MpmcTrMemRdWrCtl
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block constitutes the main control block in the MPMC trickbox.
// Depending on the content of the MPMCTrMEMT register this block model the
// memory module as SRAM, ROM or Page mode ROM. It is possible to program the
// trickmem as a memory of data size 8-bit, 16-bit and 32-bit. This module
// contains all static memory related signals given by the MPMC. All memory
// related timing parameters are checked in this module. Facility to display
// error messages, if any violation happened are also provided.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define EIGHT            2'b00
`define SIXTEEN          2'b01
`define THIRTYTWO        2'b10

`define STIDLE           3'b000
// IDLE state.

`define STREAD           3'b001
// READ state.

`define STINITBURSTREAD  3'b010
// Page mode (initial/slow) read state.

`define STBURSTREAD      3'b011
// Page mode (fast/page) read state.

`define STWRITE          3'b100
// Write state.

`define XonMCDATA        1'b0
// Controls whether 'X' or '0' is driven on MPMCDATA during read accesses.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        nMCBLSWR;
// Memory write enable when byte lane is using as write enable

wire        Wait4WtdAssn;
// Control signal to time the MPMCWAIT de-assertion

wire        Wait4WtAssn;
// Control signal to time the MPMCWAIT assertion

wire        ExtBankActive;
// Assigned '0' when all chip selectes become idle.

wire        DelExtBankActive;
// Delayed version of ExtBankActive.

time AccessSTime;
// Latch the time when access starts

time WrEndTime;
// Latch the time when write gets finish.

time RdEndTime;
// Latch the time when read gets finish.

time AddChangeTime;
// Latch the time when address changes.

time LastAddChgTime;
// Store the time when address changed last time

wire        DelnCS;
// 1 ns Delayed version of nCS

wire        nCSQ;
// Clked version of nCS

wire        Del1nMCOEN;
// 1 ns Delayed version of nMPMCOEN.

wire  [3:0] DelnMCBLS;
// 1 ns Delayed version of nMPMCBLS.

wire  [1:0] MEMSIZE;
// Width of the Memory model

wire  [1:0] MEMTYPE;
// Type of the Memory model (SRAM, ROM, BROM)

wire        MaxAccErMask;
// If set to '1' it will mask the read access maximum time violation message

wire        AccErMask;
// If set to '1' it will mask the read access time violation message.

wire        RBLE;
// Read byte lane enable

wire        CSPolarity;
// Chip Select polarity

wire        WaitEn;
// MPMCTrnWAIT toggle enable bit

wire [31:0] IntIDCY;
// Memory idle time.

wire [31:0] IntWSTRead;
// Access time for read.

wire [31:0] IntWSTBInitRead;
// Initial access time for page mode ROM read.

wire [31:0] IntWSTBRead;
// Access time for page read.

wire [31:0] IntWSTWrite;
// Access time for write.

wire [31:0] IntWSTReadMax;
// Maximum allowable access time for read.

wire [31:0] IntWSTBInitRdMax;
// Maximum allowable access time for initial page mode ROM read.

wire [31:0] IntWSTBReadMax;
// Maximum allowable access time for page read.

wire [31:0] IntWSTWriteMax;
// Maximum allowable access time for write.

wire [31:0] IntCS2OEN;
// Memory Chip Select to Output enable time

wire [31:0] IntCS2WEN;
// Memory Chip Select to Write enable time

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         OldOEN;
// Signal to catch the rising edge of nMPMCOEN

reg   [7:0] XCS;
// External Bank Select signal after multiplexion with the CSPolarity

reg  [31:0] MPMCDATAOUT;
// Memory Data bus

reg         nWR;
// Memory write enable.

reg         nCS;
// Memory device enable.

reg         RdCountDown;
// Count Down enable for Read process

reg   [5:0] RdCount;
// Read count

reg   [5:0] WrCount;
// Write count

reg   [5:0] WstRead;
// External Wait States counter

reg  [15:0] ExtWaitCount;
// Read count

reg  [23:0] WaitCount;
// External Wait States counter

reg   [2:0] MpmcCntSt;
// State register.

reg   [2:0] NxtMpmcCntSt;
// D-input for State register.

reg  [10:0] OldLatchMCADDR;
// Store the old address.

reg [5:0] valsixteen;
// Store 0x10

reg [15:0] MpmcExtWt;
// Store extended wait value

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

reg         DataRdy;
// Data out enable signal

reg         OutofRange;
// Memory access out of range indicator

reg         ToggSt;
// State Toggler to trigger the state machine

reg         BurstR;
// Indicates Burst Reads to the Memory

wire        iBurstR;
// Indicates Burst Reads to the Memory

reg         BurstRQ;
// Indicates latched BurstR

reg         NBurstR;
// Indicates Non-Burst Reads to the Memory

integer i;
// FOR LOOP variable

reg  [31:0] DefData;
// Default data to be driven to the MPMCDATA

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
  MPMCDATAOUT    = 32'hzzzzzzzz;
  WrEndTime      = 0;
  RdEndTime      = 0;
  WrSTime        = 0;
  AddChangeTime  = 0;
  DataChangeTime = 0;
  LatchMCADDR    = 10'b0000000000;
  BurstR         = 1'b0;
  NBurstR        = 1'b0;
  NBRdSTime      = 0;
  BRdSTime       = 0;
  IdleStartTime  = 0;
  DefData        = 32'hDEADBEEF;
  valsixteen     = 6'b010000;
end

// -----------------------------------------------------------------------------
// MPMCTrMEMT Register field rename
// -----------------------------------------------------------------------------
assign MEMSIZE          = MPMCTrMEMT[1:0];
assign MEMTYPE          = MPMCTrMEMT[3:2];
assign MaxAccErMask     = MPMCTrMEMT[4];
assign AccErMask        = MPMCTrMEMT[5];
assign RBLE             = MPMCTrMEMT[6];
assign CSPolarity       = MPMCTrMEMT[7];
assign WaitEn           = MPMCTrMEMT[8];
assign nMCBLSWR         = nMPMCBLS[0] & nMPMCBLS[1] & nMPMCBLS[2] & nMPMCBLS[3];
assign MPMCDATA         = ((nMPMCOEN == 1'b1) || (nCS == 1'b1)) ?
                          32'hzzzzzzzz : MPMCDATAOUT;
assign iBurstR          = BurstR;
// -----------------------------------------------------------------------------
// External Bank Select/Polarity Mux
// -----------------------------------------------------------------------------
always @(MPMCTrCSPOL or MPMCTrAllCS)
begin : p_XCSComb
  for (i = 7; i >= 0; i = i-1)
    if (MPMCTrCSPOL[i] == 1'b0)
      XCS[i] = ~(MPMCTrAllCS[i]);
    else
      XCS[i] = MPMCTrAllCS[i];
end // p_XCSComb

// -----------------------------------------------------------------------------
// Chip Select/Polarity Mux
// -----------------------------------------------------------------------------
always @(CSPolarity or MPMCTrCS)
begin : p_nCSComb
  if (CSPolarity == 1'b0)
    nCS = MPMCTrCS;
  else
    nCS = ~(MPMCTrCS);
end // p_nCSComb

// -----------------------------------------------------------------------------
// Write enable select Mux
// -----------------------------------------------------------------------------
always @(RBLE or nMCBLSWR or nMPMCWEN)
begin : p_nWRComb
  if (RBLE == 1'b0)
    nWR = nMCBLSWR;
  else
    nWR = nMPMCWEN;
end // p_nWRComb

// -----------------------------------------------------------------------------
// Converting std_logic_vector to time.
// -----------------------------------------------------------------------------
assign IntIDCY          = (MPMCTrIDCY + 1) * Tclk;

assign IntWSTRead       = ((MPMCTrWaitRd + 1) * Tclk - 2);

assign IntWSTWrite      = (MPMCTrWaitWr * Tclk);

assign IntWSTBInitRead  = ((MPMCTrWaitRd + 1) * Tclk -2);

assign IntWSTBRead      = ((MPMCTrWaitPg + 1) * Tclk - 2);

assign IntCS2OEN        = MPMCTrCS2OEN * Tclk;
assign IntCS2WEN        = MPMCTrCS2WEN * Tclk;

// -----------------------------------------------------------------------------
// Calculate the maximum allowable time for read and write access.
// -----------------------------------------------------------------------------
assign IntWSTReadMax    = IntWSTRead + 3*Tclk + `DelayTime;
assign IntWSTWriteMax   = IntWSTWrite + 2*Tclk + `DelayTime;
assign IntWSTBReadMax   = IntWSTBRead + 1*Tclk + `DelayTime;
assign IntWSTBInitRdMax = IntWSTBInitRead + 1*Tclk + `DelayTime;

// -----------------------------------------------------------------------------
// Generate the delayed version of signals
// -----------------------------------------------------------------------------
assign  # 1 DelnCS           = nCS;
assign  # 1 Del1nMCOEN       = nMPMCOEN;
assign  # 1 DelnMCBLS        = nMPMCBLS;
assign  # 2 DelExtBankActive = ExtBankActive;
assign  # 60 nCSQ        = nCS;
// -----------------------------------------------------------------------------
// ExtBankActive becomes high when any other chip selects becomes enabled.
// -----------------------------------------------------------------------------
assign ExtBankActive    = (XCS[7] | XCS[6] | XCS[5] | XCS[4] | XCS[3] |
                           XCS[2] | XCS[1] | XCS[0]) & nCS;

// -----------------------------------------------------------------------------
// Latch the time when access starts
// -----------------------------------------------------------------------------
always @(negedge nCS)
begin : p_AccSTimeComb
  AccessSTime <= $time;
end // p_AccSTimeComb

// -----------------------------------------------------------------------------
// Latch the time when write gets finish
// -----------------------------------------------------------------------------
always @(posedge nWR)
begin : p_WrEndTimeComb
  if (DelnCS == 1'b0)
    WrEndTime <= $time;
end // p_WrEndTimeComb

// -----------------------------------------------------------------------------
// Latch the time when Read gets finish
// -----------------------------------------------------------------------------
always @(posedge nMPMCOEN)
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

always @(IdleStartTime)
begin : p_CSDeAssrtnComb
  if (($time > 0) & ((IdleStartTime - WrEndTime) < Tclk))
    $display("Error : Time %t : MPMCTM1: Write enable to CS de-assertion delay violation Instance %m", $time);
end // p_CSDeAssrtnComb

// -----------------------------------------------------------------------------
// During the write cycle address should not change. Also in this design
// nMPMCOEN is never enabled when write is enabled.
// -----------------------------------------------------------------------------
always @(nMPMCOEN or nWR or nCS)
begin : p_RWAssrtComb
  if ((nMPMCOEN == 1'b0) && (nWR == 1'b0) && (nCS == 1'b0))
    $display("Error : Time %t : MPMCTM2: Read enable and write enable are asserted at the same time Instance %m", $time);
end // p_RWAssrtComb

always @(MPMCADDR)
begin : p_ADDRComb
  if ((nWR == 1'b0) && (nCS == 1'b0))
    $display("Error : Time %t : MPMCTM3: Address changed when write enable was active Instance %m", $time);
end // p_ADDRComb

// -----------------------------------------------------------------------------
// During the read cycle chip select should not change. This particular design
// is not supporting the chip select controlled write.
// -----------------------------------------------------------------------------
always @(nCS)
begin : p_CsStatusCheck
  if (nCS == 1'b1)
    begin
      # `DelayTime;
      if (nWR == 1'b0)
        if (($time - 2*Tclk) > WrEndTime)
          $display("Error : Time %t : MPMCTM4: Chip select controlled write Instance %m", $time);

      if (nMPMCOEN == 1'b0)
        if (($time - 2*Tclk) > RdEndTime)
          $display("Error : Time %t : MPMCTM5: Chip select changed during read was active Instance %m", $time);
    end
end // p_CsStatusCheck

// -----------------------------------------------------------------------------
// Checks for OEN and WEN asserted simultaneously
// -----------------------------------------------------------------------------
always @(nMPMCOEN or nWR or nCS)
begin : p_RdWrAssertComb
  if ((nCS == 1'b0) && (nMPMCOEN == 1'b0) && (nWR == 1'b0))
    $display("Error : Time %t : MPMCTM6: Output Enable and Write Enable are asserted together Instance %m", $time);
end // p_RdWrAssertComb

// -----------------------------------------------------------------------------
// Idle time check between the memory banks
// -----------------------------------------------------------------------------
always @(DelExtBankActive)
begin : p_IdleBetBank
  if ((DelExtBankActive == 1'b1) && (ExtBankActive == 1'b1))
    begin
      # `DelayTime;
      if (nCS == 1'b1 && (nMCBLSWR == 1'b0 || nMPMCWEN == 1'b0) &&
          nMPMCOEN == 1'b1)
        if ($time - (4 + RdEndTime) < IntIDCY)
          $display("Error : Time %t : MPMCTM7: Bank to Bank idle time violation Instance %m", $time);
    end
end // p_IdleBetBank

// -----------------------------------------------------------------------------
// Checking the address and data hold time with respect to the rising edge
// of write signal.
// -----------------------------------------------------------------------------
always @(MPMCADDR)
begin : p_ADDRHldComb
  if ((nCS == 1'b0) && (($time - WrEndTime) < `AddWrHoldTime))
    $display("Error : Time %t : MPMCTM8: Address hold time violation Instance %m", $time);
end // p_ADDRHldComb

always @(MPMCDATA)
begin : p_DATAHldComb
  if (($time > 0) && (nCS == 1'b0) && (($time - WrEndTime) < `DataWrHoldTime))
    $display("Error : Time %t : MPMCTM9: Data hold time violation Instance %m", $time);
end // p_DATAHldComb

always @(WrEndTime)
begin : p_DATAStpComb
  if (($time > 100) && (nCS == 1'b0) &&
      ((WrEndTime - DataChangeTime) < `DataWrSetupTime))
    $display("Error : Time %t : MPMCTM10: Data setup time violation Instance %m", $time);
end // p_DATAStpComb

always @(LatchMCADDR)
begin : p_BurstRComb
  if ((WaitEn == 1'b0) &&
      (LatchMCADDR[10:2] == OldLatchMCADDR[10:2]) && (MEMTYPE[1] == 1'b1))
    BurstR = 1'b1;
    # (Tclk/2 -1) BurstR = 1'b0;
end // p_BurstRComb

always @(nMPMCOEN)
begin : p_OldOENComb
  OldOEN <= nMPMCOEN;
end // p_OldOENComb

// -----------------------------------------------------------------------------
// NBurstR indicates the start of a valid read
// -----------------------------------------------------------------------------
always @(LatchMCADDR)
begin : p_NBurstRComb
  if ((WaitEn == 1'b0))
    NBurstR = 1'b1;
    # (Tclk/2 -1) NBurstR = 1'b0;
end // p_NBurstRComb

// -----------------------------------------------------------------------------
// State transition process
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge HCLK)
begin : p_RdWrSeq
  if (HRESETn == 1'b0)
    begin
      MpmcCntSt <= `STIDLE;
      ToggSt    <= 1'b0;
    end
  else
    begin
      MpmcCntSt <= NxtMpmcCntSt;
      ToggSt    <= ~ToggSt;
    end
end // p_RdWrSeq

// -----------------------------------------------------------------------------
// Next State generation process
// -----------------------------------------------------------------------------
always @(LatchMCADDR or nWR or nMPMCOEN or nCS or OutofRange or MpmcCntSt or
         posedge BurstR or posedge NBurstR)
begin : p_RdWrComb
  case (MpmcCntSt)
    // IDLE STATE
    `STIDLE :
      begin
        if (nCS == 1'b0)
          begin
            // Write cycle started.
            if (OutofRange == 1'b1)
              NxtMpmcCntSt <= `STIDLE;
            else
              begin
                if (nWR == 1'b0)
                  begin
                    if (($time - (RdEndTime - 1)) < IntIDCY)
                      $display("Error : Time %t : MPMCTM11: Read to write idle time violation Instance %m", $time);

                    if (($time - AddChangeTime) < `AddWrSetupTime)
                      $display("Error : Time %t : MPMCTM12: Address set up time violation Instance %m", $time);

                    if (WaitEn == 1'b0)
                      if (($time - AccessSTime) < IntCS2WEN)
                        $display("Error : Time %t : MPMCTM13: Chip Select to Write Enable assertion time violation Instance %m", $time);

                    // Write is allowed only when memory is configured as SRAM.
                    if (MEMTYPE[0] == 1'b0)
                      begin
                        NxtMpmcCntSt <= `STWRITE;
                        WrSTime      <= $time - IntCS2WEN - 2;

                        // If the programmed memory size is
                        // 8-bit then only one write enable is active at a time.
                        // 16-bit then either nMPMCBLS(0) and nMPMCBLS(1) or
                        // nMPMCBLS(2) and nMPMCBLS(3) are high at all time

                        if ((MEMSIZE == `EIGHT) && (nCS == 1'b0))
                          begin
                            if ((nMPMCBLS[3] & nMPMCBLS[2] & nMPMCBLS[1]) == 1'b0)
                              $display("Error : Time %t : MPMCTM14: Write enable violation for an 8-bit memory Instance %m", $time);

                          end
                        else if ((MEMSIZE == `SIXTEEN) && (nCS == 1'b0))
                          begin
                            if ((nMPMCBLS[3] & nMPMCBLS[2]) == 1'b0)
                              $display("Error : Time %t : MPMCTM15: Write enable violation for a 16-bit memory Instance %m", $time);
                          end
                      end
                    else
                      begin
                        NxtMpmcCntSt <= `STIDLE;
                        $display("Error : Time %t : MPMCTM16: Write is not supported Instance %m", $time);
                      end

                  // Read cycle started.
                  end
                else if (nMPMCOEN == 1'b0)
                  begin
                    if (($time - WrEndTime) < (Tclk - 2))
                      $display("Error : Time %t : MPMCTM17: Write to read idle time violation Instance %m", $time);

                    if (WaitEn == 1'b0)
                      if (($time - (AccessSTime + 0)) < IntCS2OEN)
                        $display("Error : Time %t : MPMCTM18: Chip Select to Output Enable assertion time violation Instance %m", $time);

                    NBRdSTime <= $time - IntCS2OEN - 2;

                    if (MEMTYPE[1] == 1'b1)
                      begin
                        NxtMpmcCntSt <= `STINITBURSTREAD;
                        BRdSTime     <= $time - IntCS2OEN - 2;
                      end
                    else
                      NxtMpmcCntSt <= `STREAD;
                  end
                else
                  NxtMpmcCntSt <= `STIDLE;
              end
          end
      end
    // ST_READ
    `STREAD :
      begin
        // Read cycle finished.
        if (nMPMCOEN == 1'b1)
          begin
            NxtMpmcCntSt <= `STIDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - NBRdSTime) > IntWSTReadMax)
                    $display("Error : Time %t : MPMCTM19: Maximum time limit for the read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("Error : Time %t : MPMCTM20: Access time violation for Read Instance %m", $time);
              end
          end
        // Page access. In case of page access higher order address will
        // not change.
        else if (BurstR == 1'b1 && nCS == 1'b0)
          begin
            DataRdy      <= 1'b0;
            NBRdSTime    <= $time - 1;
            NxtMpmcCntSt <= `STREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - AddChangeTime) > IntWSTReadMax)
                    $display("Error : Time %t : MPMCTM21: Maximum time limit for the read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - AddChangeTime) < IntWSTRead)
                    $display("Error : Time %t : MPMCTM22: Access time violation for the read Instance %m", $time);
              end

          end
        // Continuous read.
        else if (NBurstR == 1'b1 && nCS == 1'b0)
          begin
            DataRdy      <= 1'b0;
            NBRdSTime    <= $time - 1;
            NxtMpmcCntSt <= `STREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - AddChangeTime) > IntWSTReadMax)
                    $display("Error : Time %t : MPMCTM23: Maximum time limit for the non page read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("Error : Time %t : MPMCTM24: Access time violation for Read Instance %m", $time);
              end

          end
        else
          NxtMpmcCntSt <= `STREAD;
      end

    `STINITBURSTREAD :
      begin
        // Page read finished.
        if (nCS == 1'b1)
          begin
            NxtMpmcCntSt <= `STIDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - LastAddChgTime) > IntWSTBInitRdMax)
                    $display("Error : Time %t : MPMCTM25: Maximum time limit for the page read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBInitRead)
                    $display("Error : Time %t : MPMCTM26: Access time violation for page mode Read Instance %m", $time);
              end

          end

        // Page access. For page access lower two address bits remains
        // unchanged.
        else if (BurstR == 1'b1)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtMpmcCntSt <= `STBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - AddChangeTime) > IntWSTBInitRdMax) &
                      (RdEndTime < AddChangeTime))
                    $display("Error : Time %t : MPMCTM29: Maximum time limit for the page mode read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - AccessSTime) < IntWSTBInitRead)
                    $display("Error : Time %t : MPMCTM30: Access time violation for page mode Read Instance %m", $time);
              end

          end

        // Page read access with nMPMCOEN deasserted between transfers
        else if (BurstR == 1'b1 & nMPMCOEN == 1'b1)
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtMpmcCntSt <= `STBURSTREAD;
          end

        // Continuous Page mode ROM read, but not the page access.
        else if (NBurstR == 1'b1 & nMPMCOEN == 1'b0)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtMpmcCntSt <= `STINITBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - AddChangeTime) > IntWSTBInitRdMax)
                    $display("Error : Time %t : MPMCTM31: Maximum time limit for the page mode read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - AddChangeTime) < IntWSTBInitRead)
                    $display("Error : Time %t : MPMCTM32: Access time violation for Read Instance %m", $time);
              end

          end

        // Continuous Page mode ROM read, but not the page access
        else if (NBurstR == 1'b1 & nMPMCOEN == 1'b1)
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time;
            NxtMpmcCntSt <= `STINITBURSTREAD;
          end
        else if (nMPMCOEN == 1'b1)
          begin
            DataRdy <= 1'b0;
            NxtMpmcCntSt <= `STINITBURSTREAD;
  
            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - AddChangeTime) > IntWSTBInitRdMax) &
                      (RdEndTime < AddChangeTime))
                    $display("Error : Time %t : MPMCTM27: Maximum time limit for the page mode read access has exceeded Instance %m", $time);
  
                if (AccErMask == 1'b0)
                  if (($time - AddChangeTime) < IntWSTBInitRead)
                    $display("Error : Time %t : MPMCTM28: Access time violation for page mode Read Instance %m", $time);
              end
          end
        else
            NxtMpmcCntSt <= `STINITBURSTREAD;
      end

    // ST_BURSTREAD
    `STBURSTREAD :
      begin
        // Page read finished.
        if (nCS == 1'b1)
          begin
            NxtMpmcCntSt <= `STIDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - AddChangeTime) > IntWSTBReadMax)
                    $display("Error : Time %t : MPMCTM33: Maximum time limit for the page mode read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBRead)
                    $display("Error : Time %t : MPMCTM34: Access time violation for Read Instance %m", $time);
              end

          end

      // Page access. For page access lower two address bits remains
      // unchanged.
        else if (BurstR == 1'b1)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtMpmcCntSt <= `STBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - AddChangeTime) > IntWSTBReadMax) &
                      (RdEndTime < AddChangeTime))
                    $display("Error : Time %t : MPMCTM37: Maximum time limit for the page mode read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - AccessSTime) < IntWSTBRead)
                    $display("Error : Time %t : MPMCTM38: Access time violation for Read Instance %m", $time);
              end

          end

        // Page mode read access with nMPMCOEN deasserted between transfers
        else if (BurstR == 1'b1 & nMPMCOEN == 1'b1)
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtMpmcCntSt <= `STBURSTREAD;
          end

        // Continuous Page mode ROM read, but not the page access.
        else if (NBurstR == 1'b1)
          begin
            DataRdy      <= 1'b0;
            BRdSTime     <= $time - 1;
            NxtMpmcCntSt <= `STINITBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - AddChangeTime) > IntWSTBInitRdMax)
                    $display("Error : Time %t : MPMCTM39: Maximum time limit for the page mode read access has exceeded Instance %m", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBRead)
                    $display("Error : Time %t : MPMCTM40: Access time violation for Read Instance %m", $time);
              end

          end

        // Continuous Page mode ROM read, but not the page access
        else if (NBurstR == 1'b1 & nMPMCOEN == 1'b1)
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtMpmcCntSt <= `STINITBURSTREAD;
          end

      else if (nMPMCOEN == 1'b1 && OldOEN == 1'b0)
        begin
          DataRdy <= 1'b0;
          NxtMpmcCntSt <= `STBURSTREAD;

          if (WaitEn == 1'b0)
            begin
              if (MaxAccErMask == 1'b0)
                if (($time - AddChangeTime) > IntWSTBReadMax)
                  $display("Error : Time %t : MPMCTM35: Maximum time limit for the page mode read access has exceeded Instance %m", $time);

              if (AccErMask == 1'b0)
                if (($time - AddChangeTime) < IntWSTBRead)
                  $display("Error : Time %t : MPMCTM36: Access time violation for page mode Read Instance %m", $time);
            end
        end

        else
          NxtMpmcCntSt <= `STBURSTREAD;
      end

    // ST_WRITE
    `STWRITE :
      begin
        // Write cycle finished. Data in the MPMCDATA bus, is written into
        // the memory element pointed by the MPMCADDR value by using the rising
        // edge of the write signal.
        if (nWR == 1'b1)
          begin
            NxtMpmcCntSt <= `STIDLE;

            if (WaitEn == 1'b0)
              begin
                if (($time - WrSTime) < IntWSTWrite)
                  $display("Error : Time %t : MPMCTM41: Access time violation for write Instance %m", $time);

                if (($time - WrSTime) > IntWSTWriteMax)
                  $display("Error : Time %t : MPMCTM42: Maximum time limit for write access has exceeded Instance %m", $time);
              end

          end
        else
          NxtMpmcCntSt <= `STWRITE;
      end

    // default state.
    default :
      begin
        NxtMpmcCntSt <= `STIDLE;
      end
  endcase
end // p_RdWrComb

// -----------------------------------------------------------------------------
// Data drive control
// -----------------------------------------------------------------------------
always @(MpmcCntSt or RdCount or ToggSt)
// always @(MpmcCntSt or RdCount)
begin : p_DatDrCntlComb
  case (MpmcCntSt)
    `STIDLE :
      begin
        RdCountDown <= 1'b0;
        DataRdy     <= 1'b0;
      end
    `STREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 0)
          DataRdy <= 1'b1;
      end
    `STINITBURSTREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 0)
          DataRdy <= 1'b1;
      end
    `STBURSTREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 0)
          DataRdy <= 1'b1;
      end
    `STWRITE :
      begin
        RdCountDown <= 1'b0;
        DataRdy     <= 1'b0;
      end
    default :
      begin
        RdCountDown  <= 1'b0;
        DataRdy      <= 1'b0;
      end
  endcase
end // p_DatDrCntlComb

// -----------------------------------------------------------------------------
// Capture read data
// -----------------------------------------------------------------------------
always @(WaitEn or DataRdy or RdCountDown or MemRdDataDW)
begin : p_MPMCDATAComb
  if ((WaitEn == 1'b1) && (RdCountDown == 1'b1))
    begin
      if (MEMSIZE == `EIGHT)
        begin
          MPMCDATAOUT[7:0] = MemRdDataDW[7:0];
          MPMCDATAOUT[31:8] = 24'hzzzzzz;
        end
      else if (MEMSIZE == `SIXTEEN)
        begin
          MPMCDATAOUT[15:0] = MemRdDataDW[15:0];
          MPMCDATAOUT[31:16] = 16'hzzzz;
        end
      else
        MPMCDATAOUT = MemRdDataDW;
    end
  else if (DataRdy == 1'b1)
    begin
      if (MEMSIZE == `EIGHT)
        begin
          MPMCDATAOUT[7:0] = MemRdDataDW[7:0];
          MPMCDATAOUT[31:8] = 24'hzzzzzz;
        end
      else if (MEMSIZE == `SIXTEEN)
        begin
          MPMCDATAOUT[15:0] = MemRdDataDW[15:0];
          MPMCDATAOUT[31:16] = 16'hzzzz;
        end
      else
        MPMCDATAOUT = MemRdDataDW;
    end
  else if (RdCountDown == 1'b1)
    begin
      if (`XonMCDATA == 1'b0)
        begin
          if (MEMSIZE == `EIGHT)
            begin
              MPMCDATAOUT[7:0] = DefData[7:0];
              MPMCDATAOUT[31:8] = 24'hzzzzzz;
            end
          else if (MEMSIZE == `SIXTEEN)
            begin
              MPMCDATAOUT[15:0] = DefData[15:0];
              MPMCDATAOUT[31:16] = 16'hzzzz;
            end
          else
            MPMCDATAOUT = DefData;
        end
      else
        MPMCDATAOUT = 32'hxxxxxxxx;
    end
  else
    MPMCDATAOUT = 32'hzzzzzzzz;
end // p_MPMCDATAComb

// -----------------------------------------------------------------------------
// Read Wait selector
// -----------------------------------------------------------------------------
always @(NxtMpmcCntSt)
begin : p_WstReadComb
  if (NxtMpmcCntSt == `STBURSTREAD)
    WstRead = MPMCTrWaitPg;
  else
    WstRead = MPMCTrWaitRd - MPMCTrCS2OEN;
end // p_WstReadComb

// -----------------------------------------------------------------------------
// Read Counter
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge HCLK)
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
// Extended wait counter
// -----------------------------------------------------------------------------
always @(posedge HCLK or LatchMCADDR or OldLatchMCADDR or WaitEn or nCSQ)
begin : p_ExtWaitCalcComb
  if (WaitEn == 1'b1 & HCLK == 1'b1)
    begin
      if ((LatchMCADDR[10:0] != OldLatchMCADDR[10:0]) | nCSQ == 1'b1)
        MpmcExtWt <= 16'h0000;
      else
        MpmcExtWt <= MpmcExtWt + 1;
    end
end // p_ExtWaitCalcComb

// -----------------------------------------------------------------------------
// Maximum value of extended counter
// -----------------------------------------------------------------------------
always @(MPMCTrExtWait)
begin : p_MaxExtWt
  if (MPMCTrExtWait == 16'h0000) 
    ExtWaitCount <= 16'h000F;
  else
    ExtWaitCount <= (MPMCTrExtWait * valsixteen) + 2;
end // p_MaxExtWt
// -----------------------------------------------------------------------------
// Extended Wait time check
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_ExtWaitSeq
  if (HRESETn == 1'b0)
    ExtWaitCount <= 16'hFFFF;
  else
    begin
      if (WaitEn == 1'b1)
        begin
          if ((RdCountDown == 1'b1) | (MpmcCntSt == `STWRITE))
            begin
              if (ExtWaitCount == MpmcExtWt)
                $display("Error : Time %t : MPMCTM43 : Extended Wait Count has counted down to 0 Instance %m", $time);
            end
        end
    end
end // p_ExtWaitSeq

// -----------------------------------------------------------------------------
// Latch the time when data gets changes
// -----------------------------------------------------------------------------
always @(MPMCDATA)
begin : p_DatLatchTimeComb
  if (!((MPMCDATA[31:0] == 32'h00000000) === 1'bx))
    DataChangeTime = $time;
end // p_DatLatchTimeComb

// -----------------------------------------------------------------------------
// Address Mux. This process generate the latched address depend on the
// programed size of the memory width.
// -----------------------------------------------------------------------------
always @(MPMCADDR or MEMSIZE or MPMCTrMEMB)
begin : p_MPMCAddrLthComb
  AddChangeTime = $time;
  if (MPMCADDR[27:11] == MPMCTrMEMB)
    begin
      OutofRange <= 1'b0;
      if (MEMSIZE == `EIGHT)
        LatchMCADDR = MPMCADDR[10:0];
      else if (MEMSIZE == `SIXTEEN)
        LatchMCADDR = MPMCADDR[10:0];
      else if (MEMSIZE == `THIRTYTWO)
        begin
          LatchMCADDR = MPMCADDR[10:0];
        end
    end
  else
    OutofRange = 1'b1;
end // p_MPMCAddrLthComb

// -----------------------------------------------------------------------------
// Out of range access warning
// -----------------------------------------------------------------------------
always @(OutofRange or DelnCS)
begin : p_OutofRngComb
  if ((OutofRange == 1'b1) && (DelnCS == 1'b0) && (DelnCS == nCS))
    $display("Error : Time %t : MPMCTM44: Accessed location is out of range Instance %m", $time);
end // p_OutofRngComb

// -----------------------------------------------------------------------------
// Old MPMCADDR
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge HCLK)
begin : p_OldAddrLtchComb
  if (HRESETn == 1'b0)
    OldLatchMCADDR <= 11'b00000000000;
  else
    OldLatchMCADDR <= LatchMCADDR;
end // p_OldAddrLtchComb

// -----------------------------------------------------------------------------
// Store the time when the address changed 
// -----------------------------------------------------------------------------
always @(BurstRQ)
begin : p_OldAddrTimeComb
    if (BurstRQ == 1'b1)
       LastAddChgTime = $time;
end // p_OldAddrTimeComb

// -----------------------------------------------------------------------------
// Clock the BurstR 
// -----------------------------------------------------------------------------
always @(posedge HCLK or HRESETn or BurstR)
begin : p_ClkBurstRSeq
  if (HRESETn == 1'b0)
    BurstRQ = 1'b0;
  else
    BurstRQ = iBurstR; 
end // p_ClkBurstRSeq

// -----------------------------------------------------------------------------
// nMPMCBLS check during read. During read cycle nMPMCBLS should be "1111" when
// RBLE = '0' and nMPMCBLS should be "0000" when RBLE = '1'
// -----------------------------------------------------------------------------
always @(nMPMCBLS or DelnMCBLS or Del1nMCOEN or nMPMCOEN or RBLE or nCS)
begin : p_MPMCBLSChkComb
  if (((Del1nMCOEN | nMPMCOEN) == 1'b0) && (nCS == 1'b0))
    begin
      if ((RBLE == 1'b0) && ((nMPMCBLS < 4'hF) && (DelnMCBLS < 4'hF)))
        $display("Error : Time %t : MPMCTM45: nMPMCBLS violation when RBLE = '0' during read Instance %m", $time);

      if ((RBLE == 1'b1) && ((nMPMCBLS > 4'h0) && (DelnMCBLS > 4'h0)))
        $display("Error : Time %t : MPMCTM46: nMPMCBLS violation when RBLE = '1' during read Instance %m", $time);
    end
end // p_MPMCBLSChkComb

// -----------------------------------------------------------------------------
// Assign local copy to the output
// -----------------------------------------------------------------------------
assign MPMCActLowCS     = nCS;

endmodule

// --================================== End ==================================--
