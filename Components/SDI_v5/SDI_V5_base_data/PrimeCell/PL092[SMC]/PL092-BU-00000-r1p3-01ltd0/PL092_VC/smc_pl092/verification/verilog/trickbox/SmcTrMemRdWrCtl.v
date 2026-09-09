// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcTrMemRdWrCtl.v.rca
// File Revision          : 1.15
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block Interfaces the SMC with the memory modules
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SmcTrParams.v"

// -----------------------------------------------------------------------------

module SmcTrMemRdWrCtl (
// Inputs
                        HCLK,
                        nHCLK,
                        HSIZE,
                        HRESETn,
                        SMADDR,
                        nSMDATAEN,
                        SMCTrCS,
                        SMCTrAllCS,
                        nSMWEN,
                        nSMBLS,
                        nSMOEN,
                        MemRdDataDW,
                        SMCTrIDCY,
                        SMCTrWST1,
                        SMCTrWST2,
                        SMCTrMEMT,
                        SMCTrMEMB,
                        SMCTrCS2OEN,
                        SMCTrCS2WEN,
                        SMCTrCSPOL,

// Inouts
                        SMDATA,

// Outputs
                        LatchSMADDR,
                        SMCActLowCS
                       );

parameter Tclk = 10.52;       // HCLK Period

// Inputs
input         HCLK;        // AHB Bus Clock
input         nHCLK;       // AHB Bus Clock (Inverted)
input  [2:0]  HSIZE;       // AHB Bus HSIZE 
input         HRESETn;     // Bus Reset
input  [25:0] SMADDR;      // Address Bus to Memory
input   [3:0] nSMDATAEN;   // Memory Bus Enable
input         SMCTrCS;     // Bank select
input   [7:0] SMCTrAllCS;  // The status of all the 8 banks connected
                           // with the SMC
input         nSMWEN;      // Write enable
input   [3:0] nSMBLS;      // Byte lane select
input         nSMOEN;      // Output enable
input  [31:0] MemRdDataDW; // SMC read data
input   [4:0] SMCTrIDCY;   // Memory Data Bus turn around time
input   [5:0] SMCTrWST1;   // Read access/Initial access time
input   [5:0] SMCTrWST2;   // Write access/Burst read access time
input  [10:0] SMCTrMEMT;   // Memory type
input  [14:0] SMCTrMEMB;   // Memory Base Address
input   [4:0] SMCTrCS2OEN; // CS-nSMOEN assertion delay
input   [4:0] SMCTrCS2WEN; // CS-nSMWEN assertion delay
input   [7:0] SMCTrCSPOL;  // Chip Select polarity


// Inouts
inout  [31:0] SMDATA;      // Memory Data Bus


// Outputs
output [12:0] LatchSMADDR; // Latched SMC Address
output        SMCActLowCS; // Used for suitably routing the SMWAIT
                           // signal

// Inputs
  wire        HCLK;        // AHB Bus Clock
  wire        nHCLK;       // AHB Bus Clock (Inverted)
  wire [2:0]  HSIZE;       // AHB Bus HSIZE 
  wire        HRESETn;     // Bus Reset
  wire [25:0] SMADDR;      // Address Bus to Memory
  wire  [3:0] nSMDATAEN;   // Memory Bus Enable
  wire        SMCTrCS;     // Bank select
  wire  [7:0] SMCTrAllCS;  // The status of all the 8 banks connected
                           // with the SMC
  wire        nSMWEN;      // Write enable
  wire  [3:0] nSMBLS;      // Byte lane select
  wire        nSMOEN;      // Output enable
  wire [31:0] MemRdDataDW; // SMC read data
  wire  [4:0] SMCTrIDCY;   // Memory Data Bus turn around time
  wire  [5:0] SMCTrWST1;   // Read access/Initial access time
  wire  [5:0] SMCTrWST2;   // Write access/Burst read access time
  wire [10:0] SMCTrMEMT;   // Memory type
  wire [14:0] SMCTrMEMB;   // Memory Base Address
  wire  [4:0] SMCTrCS2OEN; // CS-nSMOEN assertion delay
  wire  [4:0] SMCTrCS2WEN; // CS-nSMWEN assertion delay
  wire  [7:0] SMCTrCSPOL;  // Chip Select polarity

// Inouts
  wire [31:0] SMDATA;      // Memory Data Bus

// Outputs
  wire  [12:0] LatchSMADDR; // Latched SMC Address
  wire        SMCActLowCS; // Used for suitably routing the SMWAIT
                           // signal

// -----------------------------------------------------------------------------
//
//                               SmcTrMemRdWrCtl
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block constitutes the main control block in the SMC trickbox.
// Depending on the content of the SMCTrMEMT register this block model the
// memory module as SRAM, ROM or BURST ROM. It is possible to program the
// trickbox as a memory of data size 8-bit, 16-bit and 32-bit. This module
// contained all memory related signals given by the SMC. All memory related
// timing parameters are checked in this module. Facility to display error
// messages, if any violation happened are also provided.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define EIGHT            2'b00
`define SIXTEEN          2'b01
`define THIRTYTWO        2'b10
`define SRAM             2'b00
`define ROM              2'b01
`define BURSTROM         2'b10

`define STIDLE           3'b000
// IDLE state.

`define STREAD           3'b001
// READ state.

`define STINITBURSTREAD  3'b010
// Burst read state.

`define STBURSTREAD      3'b011
// Burst read state.

`define STWRITE          3'b100
// Write state.

`define XonSMDATA        1'b0
// Controls whether 'X' or '0' is driven on SMDATA during read accesses.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        nSMBLSWR;
// Memory write enable when byte lane is using as write enable

wire        Wait4WtdAssn;
// Control signal to time the SMWAIT de-assertion

wire        Wait4WtAssn;
// Control signal to time the SMWAIT assertion

wire        ExtBankActive;
// Assigned '0' when all chip selectes become idle.

wire        DelExtBankActive;
// Delayed version of ExtBankActive.

wire [12:0] DelLatchSMADDR;
// 2 ns Delayed version of LatchSMADDR

wire        DelnCS;
// 1 ns Delayed version of nCS

wire        DelnSMOEN;
// 3 ns Delayed version of nSMOEN.

wire        Del1nSMOEN;
// 1 ns Delayed version of nSMOEN.

wire  [3:0] DelnSMBLS;
// 1 ns Delayed version of nSMBLS.

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
// SMCTrnWAIT toggle enable bit

wire        BoundaryCase;
// Read-data return time select

time AccessSTime;
// Latch the time when access starts

time WrEndTime;
// Latch the time when write gets finish.

time OenChgTime;
// Latch the time when oen is deasseted.

time RdEndTime;
// Latch the time when read gets finish.

time CsAssernTime;
// Latch the time when csel gets asserted.

time CsDeAssernTime;
// Latch the time when csel gets deasserted.

time AddChangeTime;
// Latch the time when address changes.

time BAddChangeTime;
// Latch the time when address changes.

time LastAddChgTime;
// Latch the time when address changes.

wire [31:0] IntIDCY;
// Memory idle time.

wire [31:0] IntWSTRead;
// Access time for read.

wire [31:0] IntWSTBInitRead;
// Initial access time for burst read.

wire [31:0] IntWSTBRead;
// Access time for burst read.

wire [31:0] IntWSTWrite;
// Access time for write.

wire [31:0] IntWSTReadMax;
// Maximum allowable access time for read.

wire [31:0] IntWSTBInitRdMax;
// maximum allowable access time for burst read.

wire [31:0] IntWSTBReadMax;
// maximum allowable access time for burst read.

wire [31:0] IntWSTWriteMax;
// Maximum allowable access time for write.

wire [31:0] IntCS2OEN;
// Memory Chip Select to Output enable time

wire [31:0] IntCS2WEN;
// Memory Chip Select to Write enable time

time WrSTime;
// Latch the time when write gets start.

time NBRdSTime;
// Latch the time when non burst read gets start.

time BRdSTime;
// Latch the time when burst read gets start.

time IdleStartTime;
// Latch the time when memory idle time start.

reg         DataRdy;
// Data out enable signal

time DataChangeTime;
// Latch the time when data changes.

time ExtCsAssernTime;
// Latch the time when External CS is asserted.

wire [12:0] Del1LatchSMADDR;
// 1 ns Delayed version of LatchSMADDR

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [7:0] XCS;
// External Bank Select signal after multiplexion with the CSPolarity

reg         nWR;
// Memory write enable.

reg         nCS;
// Memory device enable.

reg         RdCountDown;
// Count Down enable for Read process

reg   [5:0] RdCount;
// Read count

reg  [31:0] SMDATAOUT;
// Memory Data bus

reg   [2:0] SmcCntSt;
// State register.

reg   [2:0] NxtSmcCntSt;
// State register.

reg  [12:0] OldLatchSMADDR;
// Store the old address.

reg  [12:0] iLatchSMADDR;
// Store the old address.

reg         OutofRange;
// Memory access out of range indicator

reg         ToggSt;
// State Toggler to trigger the state machine

reg         BurstR;
// Indicates Burst Reads to the Memory

reg         NBurstR;
// Indicates Non-Burst Reads to the Memory

integer i;
// FOR LOOP variable

reg  [31:0] DefData;
// Default data to be driven to the SMDATA

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
  SMDATAOUT         = 32'hzzzzzzzz;
  SmcCntSt          = 2'b00;
  WrEndTime         = 0;
  RdEndTime         = 0;
  RdCount           = 5'b0;
  WrSTime           = 0;
  AddChangeTime     = 0;
  DataChangeTime    = 0;
//  LatchSMADDR       = 10'b0000000000;
  BurstR            = 1'b0;
  NBurstR           = 1'b0;
  NBRdSTime         = 0;
  BRdSTime          = 0;
  IdleStartTime     = 0;
  DefData           = 32'hDEADBEEF;
end

// -----------------------------------------------------------------------------
// SMCTrMEMT Register field rename
// -----------------------------------------------------------------------------
assign MEMSIZE          = SMCTrMEMT[1:0];
assign MEMTYPE          = SMCTrMEMT[3:2];
assign MaxAccErMask     = SMCTrMEMT[4];
assign AccErMask        = SMCTrMEMT[5];
assign RBLE             = SMCTrMEMT[6];
assign CSPolarity       = SMCTrMEMT[7];
assign WaitEn           = SMCTrMEMT[8];
assign BoundaryCase     = SMCTrMEMT[10];
assign #1 nSMBLSWR         = nSMBLS[0] & nSMBLS[1] & nSMBLS[2] & nSMBLS[3];

assign SMDATA           = ((nSMOEN == 1'b1) || (nCS == 1'b1)) ?
                          32'hzzzzzzzz : SMDATAOUT;

// -----------------------------------------------------------------------------
// External Bank Select/Polarity Mux
// -----------------------------------------------------------------------------
always @(SMCTrCSPOL or SMCTrAllCS)
begin : p_XCSComb
  for (i = 7; i >= 0; i = i - 1)
    if (SMCTrCSPOL[i] == 1'b0)
      XCS[i] = ~(SMCTrAllCS[i]);
    else
      XCS[i] = SMCTrAllCS[i];
end // p_XCSComb

// -----------------------------------------------------------------------------
// Chip Select/Polarity Mux
// -----------------------------------------------------------------------------
always @(CSPolarity or SMCTrCS)
begin : p_nCSComb
  if (CSPolarity == 1'b0)
    begin
      nCS = SMCTrCS;
    end
  else
    begin
      nCS = ~(SMCTrCS);
    end
end // p_nCSComb

// -----------------------------------------------------------------------------
// Write enable select Mux
// -----------------------------------------------------------------------------
always @(RBLE or nSMBLSWR or nSMWEN)
begin : p_nWRComb
  if (RBLE == 1'b0)
    begin
      nWR = nSMBLSWR; 
    end
  else
    begin
      nWR = nSMWEN;
    end
end // p_nWRComb

// -----------------------------------------------------------------------------
// Converting std_logic_vector to time.
// -----------------------------------------------------------------------------
assign IntIDCY          = (SMCTrIDCY + 1) * Tclk;

assign IntWSTRead       = (SMCTrWST1 == 6'b000000) ? 
                          ((SMCTrWST1 + 1) * Tclk - 3) :
                          (SMCTrWST1 * Tclk + Tclk);

assign IntWSTWrite      = (SMCTrWST2 + 1) * Tclk - Tclk;

assign IntWSTBInitRead  = (SMCTrWST1 == 6'b000000) ?
                          ((SMCTrWST1 + 1) * Tclk - 2) :
                          (SMCTrWST1 * Tclk + Tclk -2 ) ;

assign IntWSTBRead      = (SMCTrWST2 == 6'b000000) ?
                          ((SMCTrWST2 + 1) * Tclk - 2) :
                          (SMCTrWST2 * Tclk + Tclk -2);

assign IntCS2OEN        = (SMCTrWST1 < SMCTrCS2OEN) ? (SMCTrWST1*Tclk ) : 
                          ((MEMTYPE[1] == 1'b1) && (SMCTrWST2 < SMCTrCS2OEN)) ? 
                            (SMCTrWST2 * Tclk) : (SMCTrCS2OEN * Tclk);
assign IntCS2WEN        = (SMCTrWST2 > SMCTrCS2WEN) ? (SMCTrCS2WEN * Tclk) : 
                          (SMCTrWST2*Tclk);

// -----------------------------------------------------------------------------
// Calculate the maximum allowable time for read and write access.
// -----------------------------------------------------------------------------
assign IntWSTReadMax    = IntWSTRead + 1*Tclk + `DelayTime;
assign IntWSTWriteMax   = IntWSTWrite + 2*Tclk + `DelayTime;
assign IntWSTBReadMax   = IntWSTBRead + 1*Tclk + `DelayTime;
assign IntWSTBInitRdMax = IntWSTBInitRead + 1*Tclk + `DelayTime;

// -----------------------------------------------------------------------------
// Generate the delayed version of signals
// -----------------------------------------------------------------------------
assign # 2   DelLatchSMADDR   = LatchSMADDR;
assign # 1   Del1LatchSMADDR  = LatchSMADDR;
assign # 1   DelnCS           = nCS;
assign # 3   DelnSMOEN        = nSMOEN;
assign # 1   Del1nSMOEN       = nSMOEN;
assign # 1   DelnSMBLS        = nSMBLS;
assign # 2   DelExtBankActive = ExtBankActive;

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
// Latch the time when Oen is deasserted.
// -----------------------------------------------------------------------------
always @(posedge nSMOEN)
begin : p_OenChgComb
  if (DelnCS == 1'b0)
  OenChgTime <= $time;
end // p_RdEndTimeComb


// -----------------------------------------------------------------------------
// Latch the time when Read gets finish, and corresponding CS is de-asserted.
// -----------------------------------------------------------------------------
always @(posedge nSMOEN or negedge HRESETn)
begin : p_CsDeAssernComb
  if (~HRESETn)
  begin
    CsDeAssernTime <= 0;
  end else begin
    if (DelnCS == 1'b0) begin
      wait (DelnCS);
      CsDeAssernTime <= $time;
    end    
  end  
end // p_CsDeAssernComb

// -----------------------------------------------------------------------------
// Latch the time when chip inactive
// -----------------------------------------------------------------------------
always @(posedge DelnCS)
begin : p_IdlStrtTimeComb
  IdleStartTime    <= $time - 2;
end // p_IdlStrtTimeComb

// -----------------------------------------------------------------------------
// During the write cycle address should not change. Also in this design
// nSMOEN is never enabled when write is enabled.
// -----------------------------------------------------------------------------
always @(nSMOEN or nWR or nCS)
begin : p_RWAssrtComb
  if ((nSMOEN == 1'b0) && (nWR == 1'b0) && (nCS == 1'b0))
    $display("Time %t SMCTM1: Read Enable and Write Enable are asserted together", $time);
end // p_RWAssrtComb

always @(SMADDR)
begin : p_ADDRComb
 if ((nWR == 1'b0) && (nCS == 1'b0))
   $display("Time %t SMCTM2: Address changed when Write Enable was active", $time);
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
          $display("Time %t SMCTM3: Chip select controlled write", $time);

      if (nSMOEN == 1'b0)
        if (($time - 2*Tclk) > RdEndTime)
          $display("Time %t SMCTM4: Chip select changed during read was active", $time);
    end
end // p_CsStatusCheck

// -----------------------------------------------------------------------------
// Checks for OEN and WEN asserted simultaneously
// -----------------------------------------------------------------------------
always @(negedge nSMOEN or negedge nWR)
begin : p_RdWrAssertComb 
  if (nCS == 1'b0) 
   if (nSMOEN == 1'b0) 
     if (nWR == 1'b0) 
       $display("SMCTM41: Output Enable and Write Enable are asserted together", $time);
end //p_RdWrAssertComb;

// -----------------------------------------------------------------------------
// Idle time check between the memory banks
// -----------------------------------------------------------------------------
always @(posedge ExtBankActive)
begin : p_IdleBetBank
  if (DelExtBankActive == 1'b0)
    begin
      ExtCsAssernTime = $time;
      wait (DelExtBankActive);
      if (($time - CsDeAssernTime ) < IntIDCY)
        $display("Time %t SMCTM5: Bank to Bank idle time violation", $time);
    end
end // p_IdleBetBank

// -----------------------------------------------------------------------------
// Checking the address and data hold time with resepect to the rising edge
// of write signal.
// -----------------------------------------------------------------------------
always @(SMADDR)
begin : p_ADDRHldComb
  if ((nCS == 1'b0) && (($time - WrEndTime) < `AddWrHoldTime))
    $display("Time %t SMCTM6: Address hold time violation", $time);
end // p_ADDRHldComb

always @(SMDATA)
begin : p_DATAHldComb
  if (($time > 0) && (nCS == 1'b0) && (($time - WrEndTime) < `DataWrHoldTime))
    $display("Time %t SMCTM7: Data hold time violation", $time);
end // p_DATAHldComb

always @(WrEndTime)
begin : p_DATAStpComb
  if (($time > 100) && (DelnCS == 1'b0) &&
      ((WrEndTime - DataChangeTime) < `DataWrSetupTime))
    $display("Time %t SMCTM8: Data setup time violation", $time);
end // p_DATAStpComb

// -----------------------------------------------------------------------------
// Next state State transition process
// -----------------------------------------------------------------------------
always @(iLatchSMADDR or nWR or nSMOEN or nCS or OutofRange or SmcCntSt 
         or RdCount or ToggSt)
begin : p_RdWrComb
  case (SmcCntSt)
    // IDLE STATE
    `STIDLE :
      begin
        RdCountDown <= 1'b0;
        DataRdy     <= 1'b0;
        if (nCS == 1'b0)
          begin
            // Write cycle started.
            if (OutofRange == 1'b1)
              NxtSmcCntSt <= `STIDLE;
            else
              begin
                if (nWR == 1'b0)
                  begin
                    if (($time - (RdEndTime - 1)) < IntIDCY)
                      $display("Time %t SMCTM9: Read to Write idle time violation", $time);

                    if (($time - AddChangeTime) < `AddWrSetupTime)
                      $display("Time %t SMCTM10: Address set up time violation", $time);

                    if (WaitEn == 1'b0)
                      if (($time - AccessSTime) < IntCS2WEN)
                        $display("Time %t SMCTM11: Chip Select to Write Enable assertion time violation", $time);

                    // Write is allowed only when memory is configured as SRAM.
                    if (MEMTYPE == `SRAM)
                      begin
                        NxtSmcCntSt <= `STWRITE;
                        WrSTime  = $time - IntCS2WEN - 2;

                        // If the programmed memory size is
                        // 8-bit then only one write enable is active at a
                        // time. 16-bit then either nSMBLS(0) and nSMBLS(1) or
                        // nSMBLS(2) and nSMBLS(3) are high at all time

                        if ((MEMSIZE == `EIGHT) && (nCS == 1'b0))
                          begin
                            if ((nSMBLS[3] & nSMBLS[2] & nSMBLS[1]) == 1'b0)
                              $display("Time %t SMCTM12: Write enable violation for an 8-bit memory", $time);
                          end
                        else if ((MEMSIZE == `SIXTEEN) && (nCS == 1'b0))
                          begin
                            if ((nSMBLS[3] & nSMBLS[2]) == 1'b0)
                              $display("Time %t SMCTM13: Write enable violation for a 16-bit memory", $time);
                          end
                      end
                    else
                      begin
                        NxtSmcCntSt <= `STIDLE;
                        $display("Time %t SMCTM14: Write is not supported", $time);
                      end

                  // Read cycle started.
                  end
                else if (nSMOEN == 1'b0)
                  begin
                    if (($time - WrEndTime) < (Tclk - 2))
                      $display("Time %t SMCTM15: Write to read idle time violation", $time);

                    if (WaitEn == 1'b0)
                      if (($time - (AccessSTime + 0)) < IntCS2OEN)
                        $display("Time %t SMCTM16: Chip Select to Output Enable assertion time violation", $time);

                    NBRdSTime = $time - IntCS2OEN - 2;

                    if (MEMTYPE[1] == 1'b1)
                      begin
                        NxtSmcCntSt <= `STINITBURSTREAD;
                        BRdSTime = $time - IntCS2OEN - 2;
                      end
                    else
                        NxtSmcCntSt <= `STREAD;
                  end
                else
                  NxtSmcCntSt <= `STIDLE;
              end
          end
      end

    // ST_READ
    `STREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 1'b0) 
          DataRdy <= 1'b1;

        // Read cycle finished.
        if (nSMOEN == 1'b1)
          begin
            NxtSmcCntSt <= `STIDLE;
            NBRdSTime <= $time - 1;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - NBRdSTime) > IntWSTReadMax)
                    $display("Time %t SMCTM17: Maximum time limit for the read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("Time %t SMCTM18: Access time violation for Read", $time);
              end
          end

        // BURST access. In case of burst access higher order address will
        // not change.
        // To prevent Unnecessary updation of NBRdSTime when chipselect
        // is deasserted the check for chip select assertion is included here
        // as well as in Non Burst read case

        else if ((nSMOEN == 1'b0) && (DelLatchSMADDR != iLatchSMADDR) && 
                 (iLatchSMADDR[12:2] == OldLatchSMADDR[12:2])) 
          begin
            DataRdy <= 1'b0;
            NBRdSTime <= $time - 1;
            NxtSmcCntSt  <= `STREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - LastAddChgTime) > IntWSTReadMax)
                    $display("Time %t SMCTM19: Maximum time limit for the read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - NBRdSTime) < IntWSTRead)
                    $display("Time %t SMCTM20: Access time violation for the read NBRdSTime %t", $time, NBRdSTime);
              end
          end

        // Continuous read.
        else if ((nSMOEN == 1'b0) && (DelLatchSMADDR != iLatchSMADDR))
          begin
            DataRdy <= 1'b0;
            NBRdSTime <= $time - 1;
            NxtSmcCntSt  <= `STREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - LastAddChgTime) > IntWSTReadMax)
                    $display("Time %t SMCTM21: Maximum time limit for the non burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - LastAddChgTime) < IntWSTRead)
                    $display("Time %t SMCTM22: Access time violation for Read", $time);
              end
          end
        else
          NxtSmcCntSt = `STREAD;
      end

    // Initial Burst read
    `STINITBURSTREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 1'b0) 
          DataRdy <= 1'b1;

        // Burst read finished.
        if (nCS == 1'b1)
          begin
            NxtSmcCntSt <= `STIDLE;
          end
        // Burst access. For burst access lower two address bits remains
        // unchanged.
        else if ((nSMOEN == 1'b1) && (DelnSMOEN != nSMOEN))
          begin
            DataRdy <= 1'b0;
            NxtSmcCntSt <= `STINITBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - LastAddChgTime) > IntWSTBInitRdMax) &&
                       (LastAddChgTime > RdEndTime))
                    $display("Time %t SMCTM25: Maximum time limit for the burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - AccessSTime) < IntWSTBInitRead)
                    $display("Time %t SMCTM26: Access time violation for Burst Read", $time);
              end
          end

        else if ((nSMOEN == 1'b0) && (iLatchSMADDR != OldLatchSMADDR) && 
                (iLatchSMADDR[12:2] == OldLatchSMADDR[12:2])) 
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtSmcCntSt <= `STBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - LastAddChgTime) > IntWSTBInitRdMax) && 
                       (LastAddChgTime > RdEndTime))
                    $display("Time %t SMCTM27: Maximum time limit for the burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - AccessSTime) < IntWSTBInitRead)
                    $display("Time %t SMCTM28: Access time violation for Read", $time);
              end
          end
        else if ((nSMOEN == 1'b1) && (iLatchSMADDR != OldLatchSMADDR) && 
                (iLatchSMADDR[12:2] == OldLatchSMADDR[12:2])) 
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtSmcCntSt <= `STBURSTREAD;
          end
        else if ((nSMOEN == 1'b0) && (iLatchSMADDR != OldLatchSMADDR))  
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtSmcCntSt <= `STINITBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - LastAddChgTime) > IntWSTBInitRdMax) &&
                      (($time - OenChgTime) > IntWSTBInitRdMax)) 
                    $display("Time %t SMCTM29: Maximum time limit for the burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - LastAddChgTime) < IntWSTBInitRead)
                    $display("Time %t SMCTM30: Access time violation for Read", $time);
              end
          end
        else
          NxtSmcCntSt <= `STINITBURSTREAD;
      end

    // ST_BURSTREAD
    `STBURSTREAD :
      begin
        RdCountDown <= 1'b1;
        if (RdCount == 1'b0) 
          DataRdy <= 1'b1;

        // Burst read finished.
        if ((nCS == 1'b1) || ((nSMOEN == 1'b1) && (HSIZE < MEMSIZE)))
          begin
            NxtSmcCntSt <= `STIDLE;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BAddChangeTime) > IntWSTBReadMax)
                    $display("Time %t SMCTM31: Maximum time limit for the burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - BAddChangeTime) < IntWSTBRead)
                    $display("Time %t SMCTM32: Access time violation for Read", $time);
              end
          end

        // Burst access. For burst access lower two address bits remains
        // unchanged.
          else if (((nSMOEN == 1'b0) && (iLatchSMADDR != OldLatchSMADDR)) && 
                 (iLatchSMADDR[12:2] == OldLatchSMADDR[12:2])) 
          begin

            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtSmcCntSt <= `STBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if ((($time - BAddChangeTime) > IntWSTBReadMax) &&
                       (RdEndTime < BAddChangeTime))
                    $display("Time %t SMCTM33: Maximum time limit for the burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - AccessSTime) < IntWSTBRead)
                    $display("Time %t SMCTM34: Access time violation for Read", $time);
              end
          end

        // Continuous Burst ROM read, but not the burst access.
        else if ((iLatchSMADDR != OldLatchSMADDR) && (nSMOEN == 1'b0)) 
          begin
            DataRdy <= 1'b0;
            BRdSTime <= $time - 1;
            NxtSmcCntSt <= `STINITBURSTREAD;

            if (WaitEn == 1'b0)
              begin
                if (MaxAccErMask == 1'b0)
                  if (($time - BAddChangeTime) > IntWSTBReadMax)
                    $display("Time %t SMCTM35: Maximum time limit for the burst read access has exceeded", $time);

                if (AccErMask == 1'b0)
                  if (($time - BRdSTime) < IntWSTBRead)
                    $display("Time %t SMCTM36: Access time violation for Read", $time);
              end
          end
        else
          NxtSmcCntSt <= `STBURSTREAD;
      end

    // ST_WRITE
    `STWRITE :
      begin
        RdCountDown <= 1'b0;
        DataRdy <= 1'b0;
        // Write cycle finished. Data in the SMDATA bus, is written into
        // the memory element pointed by the SMADDR value by using the rising
        // edge of the write signal.
        if ((nWR == 1'b1) || (nCS == 1'b1))
          begin
            NxtSmcCntSt <= `STIDLE;

            if (WaitEn == 1'b0)
              begin
                if (($time - WrSTime) < IntWSTWrite)
                  $display("Time %t SMCTM37: Access time violation for write", $time);

                if (($time - WrSTime) > IntWSTWriteMax)
                  $display("Time %t SMCTM42: Maximum time limit for write access has exceeded", $time);
              end

          end
        else
          NxtSmcCntSt <= `STWRITE;
      end

    // default state.
    default :
      begin
      RdCountDown <= 1'b0;
      DataRdy <= 1'b0;
      NxtSmcCntSt <= `STIDLE;
      end
  endcase
end // p_RdWrComb

// -----------------------------------------------------------------------------
// Capture read data
// -----------------------------------------------------------------------------
always @(WaitEn or DataRdy or RdCountDown or MemRdDataDW)
begin : p_SMDATAComb
  if ((WaitEn == 1'b1) && (RdCountDown == 1'b1))
    begin
      if (MEMSIZE == `EIGHT)
        begin
          SMDATAOUT[7:0] = MemRdDataDW[7:0];
          SMDATAOUT[31:8] = 24'hzzzzzz;
        end
      else if (MEMSIZE == `SIXTEEN)
        begin
          SMDATAOUT[15:0] = MemRdDataDW[15:0];
          SMDATAOUT[31:16] = 16'hzzzz;
        end
      else
        SMDATAOUT = MemRdDataDW;
    end
  else if (DataRdy == 1'b1)
    begin
      if (MEMSIZE == `EIGHT)
        begin
          SMDATAOUT[7:0] = MemRdDataDW[7:0];
          SMDATAOUT[31:8] = 24'hzzzzzz;
        end
      else if (MEMSIZE == `SIXTEEN)
        begin
          SMDATAOUT[15:0] = MemRdDataDW[15:0];
          SMDATAOUT[31:16] = 16'hzzzz;
        end
      else
        SMDATAOUT = MemRdDataDW;
    end
  else if (RdCountDown == 1'b1)
    begin
      if (`XonSMDATA == 1'b0)
        begin
          if (MEMSIZE == `EIGHT)
            begin
              SMDATAOUT[7:0] = DefData[7:0];
              SMDATAOUT[31:8] = 24'hzzzzzz;
            end
          else if (MEMSIZE == `SIXTEEN)
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
end // p_SMDATAComb
// -----------------------------------------------------------------------------
// BurstR signal is used by the state machine to change from READ state to the
// Burst Read state
// -----------------------------------------------------------------------------
always @(LatchSMADDR or DelLatchSMADDR)
begin : p_BurstRComb
  if ((LatchSMADDR == DelLatchSMADDR) && (nSMOEN == 1'b0) &&
      (WaitEn == 1'b0) && (DelnSMOEN == 1'b0) &&
      (LatchSMADDR[12:2] == OldLatchSMADDR[12:2]) && (MEMTYPE[1] == 1'b1))
    BurstR = 1'b1;
  else
    BurstR = 1'b0;
end // p_BurstRComb

// -----------------------------------------------------------------------------
// NBurstR indicates the start of a valid read
// -----------------------------------------------------------------------------
always @(LatchSMADDR or DelLatchSMADDR)
begin : p_NBurstRComb
  if ((LatchSMADDR == DelLatchSMADDR) && (nSMOEN == 1'b0) &&
      (WaitEn == 1'b0) && (DelnSMOEN == 1'b0))
    NBurstR = 1'b1;
  else
    NBurstR = 1'b0;
end // p_NBurstRComb
// -----------------------------------------------------------------------------
// State transition process
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge HCLK)
begin : p_RdWrSeq
  if (HRESETn == 1'b0)
    begin
      SmcCntSt <= `STIDLE;
      ToggSt    <= 1'b0;
    end
  else
    begin
      SmcCntSt <= NxtSmcCntSt;
      ToggSt    <= ~ToggSt;
    end
end // p_RdWrSeq
// -----------------------------------------------------------------------------
// Latch the time when data gets changes
// -----------------------------------------------------------------------------
always @(SMDATA)
begin : p_DatLatchTimeComb
  if ( !((SMDATA[31:0] == 32'h00000000) === 1'bx))
    DataChangeTime = $time;
end // p_DatLatchTimeComb


// -----------------------------------------------------------------------------
// Old SMADDR
// -----------------------------------------------------------------------------
always @(negedge HRESETn or negedge HCLK)
begin : p_OldAddrLtchComb
  if (HRESETn == 1'b0)
    OldLatchSMADDR <= 13'b00000000000;
  else
    OldLatchSMADDR <= LatchSMADDR;
end // p_OldAddrLtchComb

// -----------------------------------------------------------------------------
// Store the time when the address changed
// -----------------------------------------------------------------------------
always @(OldLatchSMADDR or negedge nCS)
begin : p_OldAddrTimeComb  
//  if (nCS == 1'b0)
    LastAddChgTime <= $time;
end //p_OldAddrTimeComb;

// -----------------------------------------------------------------------------
// Address Mux. This process generate the latched address depend on the
// programed size of the memory width.
// -----------------------------------------------------------------------------
always @(SMADDR or MEMSIZE or SMCTrMEMB)
begin : p_SMAddrLatchComb
  AddChangeTime  = $time;
  if (SMADDR[25:11] <= SMCTrMEMB)
  begin
    OutofRange = 1'b0;
    iLatchSMADDR = SMADDR[12:0];
  end
  else
    begin
      OutofRange = 1'b1;
      if ((DelnCS === 1'b0) && (DelnCS == nCS))
        $display("Time %t SMCTM38: Accessed location is out of range", $time);
    end
  BAddChangeTime    <= #2 $time; 
end // p_SMAddrLatchComb

// -----------------------------------------------------------------------------
// nSMBLS check during read. During read cycle nSMBLS should be "1111" when
// RBLE = '0' and nSMBLS should be "0000" when RBLE = '1'
// -----------------------------------------------------------------------------
always @(nSMBLS or DelnSMBLS or Del1nSMOEN or nSMOEN or RBLE or nCS)
begin : p_SMBLSChkComb
  if (((Del1nSMOEN | nSMOEN) == 1'b0) && (nCS == 1'b0))
    begin
      if ((RBLE == 1'b0) && (nSMBLS < 4'b1111) && (DelnSMBLS < 4'b1111))
        $display("Time %t SMCTM39: nSMBLS violation when RBLE = '0' during read", $time);

      if ((RBLE == 1'b1) && (nSMBLS > 4'b0000) && (DelnSMBLS > 4'b0000))
        $display("Time %t SMCTM40: nSMBLS violation when RBLE = '1' during read", $time);
    end
end // p_SMBLSChkComb

// -----------------------------------------------------------------------------
// Assign local copy to the output
// -----------------------------------------------------------------------------
assign SMCActLowCS      = nCS;
assign LatchSMADDR      = iLatchSMADDR;

endmodule
// --================================== End ==================================--
