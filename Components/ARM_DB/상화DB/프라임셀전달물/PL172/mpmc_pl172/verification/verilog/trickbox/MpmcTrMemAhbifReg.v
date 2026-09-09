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
// File Name              : MpmcTrMemAhbifReg.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the MPMC Memory model with the AHB bus.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MpmcTrParams.v"

// -----------------------------------------------------------------------------

module MpmcTrMemAhbifReg (
// Inputs
                          HCLK,
                          HRESETn,
                          HADDR,
                          HTRANS,
                          HWRITE,
                          HSIZE,
                          HBURST,
                          HREADYIN,
                          HWDATA,
                          HSELMPMCTRMEM,
                          AhbRdDataDW,

// Outputs
                          HRDATA,
                          HREADYOUT,
                          HRESP,
                          MPMCTrMEMRWr,
                          LatchHADDR,
                          MPMCTrIDCY,
                          MPMCTrWaitRd,
                          MPMCTrWaitWr,
                          MPMCTrWaitPg,
                          MPMCTrMEMT,
                          MPMCTrMEMB,
                          MPMCTrCS2OEN,
                          MPMCTrCS2WEN,
                          MPMCTrCSPOL
                         );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // Bus Reset
input  [15:0] HADDR;            // AHB Address Bus
input   [1:0] HTRANS;           // Transfer type
input         HWRITE;           // AHB Peripheral Write
input   [2:0] HSIZE;            // Transfer size
input   [2:0] HBURST;           // Burst Type
input         HREADYIN;         // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;           // AHB Write Data bus
input         HSELMPMCTRMEM;    // AHB Peripheral (TrickMem) Select
input  [31:0] AhbRdDataDW;      // Mem Rd data

// Outputs
output [31:0] HRDATA;           // AHB Read Data bus
output        HREADYOUT;        // Slave HREADY output
output  [1:0] HRESP;            // Slave response

output        MPMCTrMEMRWr;     // MPMCTrMEMR Write enable
output [15:0] LatchHADDR;       // Latched AHB Address
output  [4:0] MPMCTrIDCY;       // MPMCTrIDCY Register
output  [5:0] MPMCTrWaitRd;     // MPMCTrWaitRd Register
output  [5:0] MPMCTrWaitWr;     // MPMCTrWaitWr Register
output  [5:0] MPMCTrWaitPg;     // MPMCTrWaitPg Register
output [10:0] MPMCTrMEMT;       // MPMCTrMEMT Register
output [16:0] MPMCTrMEMB;       // MPMCTrMEMB Register
output  [4:0] MPMCTrCS2OEN;     // MPMCTrCS2OEN Register
output  [4:0] MPMCTrCS2WEN;     // MPMCTrCS2WEN Register
output  [7:0] MPMCTrCSPOL;      // MPMCTrCSPOL Register

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // Bus Reset
wire   [15:0] HADDR;            // AHB Address Bus
wire    [1:0] HTRANS;           // Transfer type
wire          HWRITE;           // AHB Peripheral Write
wire    [2:0] HSIZE;            // Transfer size
wire    [2:0] HBURST;           // Burst Type
wire          HREADYIN;         // Multiplexed version of HREADY outputs
wire   [31:0] HWDATA;           // AHB Write Data bus
wire          HSELMPMCTRMEM;    // AHB Peripheral (TrickMem) Select
wire   [31:0] AhbRdDataDW;      // Mem Rd data

// Outputs
wire   [31:0] HRDATA;           // AHB Read Data bus
reg           HREADYOUT;        // Slave HREADY output
wire    [1:0] HRESP;            // Slave response

wire          MPMCTrMEMRWr;     // MPMCTrMEMR Write enable
wire   [15:0] LatchHADDR;       // Latched AHB Address
wire    [4:0] MPMCTrIDCY;       // MPMCTrIDCY Register
wire    [5:0] MPMCTrWaitRd;     // MPMCTrWaitRd Register
wire    [5:0] MPMCTrWaitWr;     // MPMCTrWaitWr Register
wire    [5:0] MPMCTrWaitPg;     // MPMCTrWaitPg Register
wire   [10:0] MPMCTrMEMT;       // MPMCTrMEMT Register
wire   [16:0] MPMCTrMEMB;       // MPMCTrMEMB Register
wire    [4:0] MPMCTrCS2OEN;     // MPMCTrCS2OEN Register
wire    [4:0] MPMCTrCS2WEN;     // MPMCTrCS2WEN Register
wire    [7:0] MPMCTrCSPOL;      // MPMCTrCSPOL Register

// -----------------------------------------------------------------------------
//
//                              MpmcTrMemAhbifReg
//                              =================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   MPMC Tricbox is an AHB slave. This block interfaces the trickbox with the
// AHB bus. All slave response signals are generated from this module.
// This module decodes AHB accesses and generates the read/write
// strobe to the appropriate registers. HCLK period calculation logic also
// contained in this module.
//
// -----------------------------------------------------------------------------
//                         MPMC Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register    Type   Width    Describtion
// -----------------------------------------------------------------------------
// 0x0000 -  MPMCTrMEMR   R/W    32-bit   32-bit wide and 2K deep Memory. By
// 0x1FFF                                changing the MemDeep value in
//                                       SmcTrConst file it is possible to
//                                       change the size of the memory array.
//
// 0x2000    MPMCTrIDCY   R/W    5-bit    Memory data bus turn around time.
//
// 0x4000    MPMCTrMEMT   R/W   11-bit    Memory type and width configuration
//                                       register.
//
// 0x5000    MPMCTrMEMB   R/W    17-bit   Memory base address register.
//
// 0x6000    MPMCTrCS2OEN R/W     5-bit   In the case of SRAMs and ROMs, this
//                                       register determines the time duration
//                                       between Chip Select assertion and the
//                                       nMPMCOEN assertion.
//                                       In the case of Page mode ROMs initial
//                                       access to this register determines the
//                                       time duration between Chip Select
//                                       assertion and the nMPMCOEN assertion
//                                       and is insignificant in successive
//                                       page mode ROM accesses.
//
// 0x7000    MPMCTrWaitRd R/W    6-bit    This is read access time in case of
//                                       SRAM and ROM. This is initial access
//                                       time in case of page mode ROM.
//
// 0x8000    MPMCTrCS2WEN R/W     5-bit   In the case of SRAMs, this register
//                                       determines the time duration between
//                                       Chip Select assertion and the nMPMCWEN
//                                       assertion.
//                                       In the case of page mode ROMs and
//                                       ROMs, this field is insignificant.
//
// 0x9000    MPMCTrWaitWr R/W    6-bit    This is write access time in case of
//                                       SRAM. This is burst access time in
//                                       case of Page mode ROM.
//
// 0xA000    MPMCTrWaitPg R/W    6-bit    This is the delay for asynchronous
//                                       page mode sequential access.
//
// 0xF000    MPMCTrCSPOL  R/W     8-bit   Chip Select Polarity setting register.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define ZEROFILL         32'h00000000

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 12 to 15 (4 bits)
// -----------------------------------------------------------------------------
`define HADDR_MPMCTrMEMR   4'b0000
// MPMCTrMEMR at offset 0x0000 to 1FFF

`define HADDR_MPMCTrIDCY   4'b0010
// MPMCTrIDCY at offset 0x2000

`define HADDR_MPMCTrMEMT   4'b0100
// MPMCTrMEMT at offset 0x4000

`define HADDR_MPMCTrMEMB   4'b0101
// MPMCTrMEMB at offset 0x5000

`define HADDR_MPMCTrCS2OEN 4'b0110
// MPMCTrCS2OEN at offset 0x6000

`define HADDR_MPMCTrWaitRd 4'b0111
// MPMCTrWaitRd at offset 0x7000

`define HADDR_MPMCTrCS2WEN 4'b1000
// MPMCTrCS2WEN at offset 0x8000

`define HADDR_MPMCTrWaitWr 4'b1001
// MPMCTrWaitWr at offset 0x9000

`define HADDR_MPMCTrWaitPg 4'b1010
// MPMCTrWaitPg at offset 0xA000

`define HADDR_MPMCTrCSPOL  4'b1111
// MPMCTrCSPOL at offset 0xC000

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire    [3:0] SelLatchHADDR;
// Used for Adress decoding

wire    [4:0] NxtMPMCTrIDCY;
// D-Input of MPMCTrIDCY Register

wire    [5:0] NxtMPMCTrWaitRd;
// D-Input of MPMCTrWaitRd Register

wire    [5:0] NxtMPMCTrWaitWr;
// D-Input of MPMCTrWaitWr Register

wire    [5:0] NxtMPMCTrWaitPg;
// D-Input of MPMCTrWaitPg Register

wire   [10:0] NxtMPMCTrMEMT;
// D-Input of MPMCTrMEMT Register

wire   [16:0] NxtMPMCTrMEMB;
// D-Input of MPMCTrMEMB Register

wire    [4:0] NxtMPMCTrCS2OEN;
// D-Input of MPMCTrCS2OEN Register

wire    [4:0] NxtMPMCTrCS2WEN;
// D-Input of MPMCTrCS2WEN Register

wire    [7:0] NxtMPMCTrCSPOL;
// D-Input of MPMCTrCSPOL Register

wire          MPMCTrMEMRRd;
// MPMCTrMEMR Read

wire          MPMCTrIDCYRd;
// MPMCTrIDCY Read

wire          MPMCTrWaitRdRd;
// MPMCTrWaitRd Read

wire          MPMCTrWaitWrRd;
// MPMCTrWaitWr Read

wire          MPMCTrWaitPgRd;
// MPMCTrWaitPg Read

wire          MPMCTrMEMTRd;
// MPMCTrMEMT Read

wire          MPMCTrMEMBRd;
// MPMCTrMEMB Read

wire          MPMCTrCS2OENRd;
// MPMCTrCS2OEN Read

wire          MPMCTrCS2WENRd;
// MPMCTrCS2WEN Read

wire          MPMCTrCSPOLRd;
// MPMCTrCSPOL Read

wire          MPMCTrIDCYWr;
// MPMCTrIDCY Write

wire          MPMCTrWaitRdWr;
// MPMCTrWaitRd Write

wire          MPMCTrWaitWrWr;
// MPMCTrWaitWr Write

wire          MPMCTrWaitPgWr;
// MPMCTrWaitPg Write

wire          MPMCTrMEMTWr;
// MPMCTrMEMT Write

wire          MPMCTrMEMBWr;
// MPMCTrMEMB Write

wire          MPMCTrCS2OENWr;
// MPMCTrCS2OEN Write

wire          MPMCTrCS2WENWr;
// MPMCTrCS2WEN Write

wire          MPMCTrCSPOLWr;
// MPMCTrCSPOL Write

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg    [15:0] iLatchHADDR;
// Latched version of HADDR

reg     [1:0] iHRESP;
// Indicates the type of response for a transfer

// signal MPMCTrMEMR    : std_logic_vector(31 downto 0);
// MPMCTrMEMR Register

reg     [4:0] iMPMCTrIDCY;
// Internal version of MPMCTrIDCY Register

reg     [5:0] iMPMCTrWaitRd;
// Internal version of MPMCTrWaitRd Register

reg     [5:0] iMPMCTrWaitWr;
// Internal version of MPMCTrWaitWr Register

reg     [5:0] iMPMCTrWaitPg;
// Internal version of MPMCTrWaitPg Register

reg    [10:0] iMPMCTrMEMT;
// Internal version of MPMCTrMEMT Register

reg    [16:0] iMPMCTrMEMB;
// Internal version of MPMCTrMEMB Register

reg     [4:0] iMPMCTrCS2OEN;
// Internal version of MPMCTrCS2OEN Register

reg     [4:0] iMPMCTrCS2WEN;
// Internal version of MPMCTrCS2WEN Register

reg     [7:0] iMPMCTrCSPOL;
// Internal version of MPMCTrCSPOL Register

reg           RdEn;
// Read enable signal

reg           WrEn;
// Write enable signal

reg           ErrorLat;
// Latch error condition

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
  iMPMCTrMEMT = 11'b00000000000;
end

// -----------------------------------------------------------------------------
// It is used for address decoding
// -----------------------------------------------------------------------------
assign SelLatchHADDR    = iLatchHADDR[15:12];

// -----------------------------------------------------------------------------
// Write enable for registers
// -----------------------------------------------------------------------------
assign MPMCTrMEMRWr     = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrMEMR)) ? 1'b1 : 1'b0;

assign MPMCTrIDCYWr     = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrIDCY)) ? 1'b1 : 1'b0;

assign MPMCTrWaitRdWr   = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrWaitRd)) ?
                          1'b1 : 1'b0;

assign MPMCTrWaitWrWr   = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrWaitWr)) ?
                          1'b1 : 1'b0;

assign MPMCTrMEMTWr     = ((WrEn === 1'b1) &
                           (SelLatchHADDR === `HADDR_MPMCTrMEMT)) ? 1'b1 : 1'b0;

assign MPMCTrMEMBWr     = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrMEMB)) ? 1'b1 : 1'b0;

assign MPMCTrCS2OENWr   = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrCS2OEN)) ?
                          1'b1 : 1'b0;

assign MPMCTrCS2WENWr   = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrCS2WEN)) ?
                          1'b1 : 1'b0;

assign MPMCTrCSPOLWr    = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrCSPOL)) ?
                          1'b1 : 1'b0;

assign MPMCTrWaitPgWr   = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrWaitPg)) ?
                          1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Read enable for registers
// -----------------------------------------------------------------------------
assign MPMCTrMEMRRd     = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrMEMR)) ? 1'b1 : 1'b0;

assign MPMCTrIDCYRd     = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrIDCY)) ? 1'b1 : 1'b0;

assign MPMCTrWaitRdRd   = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrWaitRd)) ?
                          1'b1 : 1'b0;

assign MPMCTrWaitWrRd   = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrWaitWr)) ?
                          1'b1 : 1'b0;

assign MPMCTrWaitPgRd   = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrWaitPg)) ?
                          1'b1 : 1'b0;

assign MPMCTrMEMTRd     = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrMEMT)) ? 1'b1 : 1'b0;

assign MPMCTrMEMBRd     = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrMEMB)) ? 1'b1 : 1'b0;

assign MPMCTrCS2OENRd   = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrCS2OEN)) ?
                          1'b1 : 1'b0;

assign MPMCTrCS2WENRd   = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrCS2WEN)) ?
                          1'b1 : 1'b0;

assign MPMCTrCSPOLRd    = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_MPMCTrCSPOL)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATA           = (MPMCTrMEMRRd == 1'b1) ?
                           AhbRdDataDW : ((MPMCTrIDCYRd == 1'b1) ?
                           {27'b000000000000000000000000000, iMPMCTrIDCY} :
                           ((MPMCTrWaitRdRd == 1'b1) ?
                           {26'b00000000000000000000000000, iMPMCTrWaitRd} :
                           ((MPMCTrWaitWrRd == 1'b1) ?
                           {26'b00000000000000000000000000, iMPMCTrWaitWr} :
                           ((MPMCTrWaitPgRd == 1'b1) ?
                           {26'b00000000000000000000000000, iMPMCTrWaitPg} :
                           ((MPMCTrMEMTRd == 1'b1) ?
                           {21'b000000000000000000000, iMPMCTrMEMT} :
                           ((MPMCTrMEMBRd == 1'b1) ?
                           {15'b000000000000000, iMPMCTrMEMB} :
                           ((MPMCTrCS2OENRd == 1'b1) ?
                           {27'b000000000000000000000000000, iMPMCTrCS2OEN} :
                           ((MPMCTrCS2WENRd == 1'b1) ?
                           {27'b000000000000000000000000000, iMPMCTrCS2WEN} :
                           ((MPMCTrCSPOLRd == 1'b1) ?
                           {24'b000000000000000000000000, iMPMCTrCSPOL} :
                           32'h00000000)))))))));

// -----------------------------------------------------------------------------
// This process generate the bus response required for an AHB slave.
// MPMC trickbox is designed for an HBURST of INCR type and an HSIZE of 32-bit.
// So this process will generate an ERROR response when the master try to access
// it in some other mode. Also it display an error message to the output.
// Trickbox always provides a ZERO wait state OKAY response for IDLE and BUSY
// HTRANS of the master.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusRespSeq
  if (HRESETn == 1'b0)
    begin
      iHRESP              <= 2'b00;
      HREADYOUT           <= 1'b1;
      WrEn                <= 1'b0;
      RdEn                <= 1'b0;
      ErrorLat            <= 1'b0;
      iLatchHADDR         <= 16'h0000;
    end
  else
    begin
      if ((iHRESP == `HRESP_ERROR) & (HREADYIN == 1'b0) & (ErrorLat == 1'b1))
        begin
          iHRESP          <= `HRESP_ERROR;
          HREADYOUT       <= 1'b1;
          WrEn            <= 1'b0;
          RdEn            <= 1'b0;
          ErrorLat        <= 1'b0;
        end
      else if (((HTRANS == `HTRANS_IDLE) | (HTRANS == `HTRANS_BUSY)) &
               (HSELMPMCTRMEM == 1'b1) & (HREADYIN == 1'b1))
        begin
          iHRESP          <= `HRESP_OKAY;
          HREADYOUT       <= 1'b1;
        end
      else if ((HREADYIN == 1'b1) & (HSELMPMCTRMEM == 1'b1))
        begin
          if (HSIZE == `HSIZE_WORD)
            begin
              HREADYOUT   <= 1'b1;
              iLatchHADDR <= HADDR;
              iHRESP      <= `HRESP_OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn    <= 1'b1;
                  RdEn    <= 1'b0;
                end
              else
                begin
                  WrEn    <= 1'b0;
                  RdEn    <= 1'b1;
                end
            end
          else
            begin
              iHRESP      <= `HRESP_ERROR;
              HREADYOUT   <= 1'b0;
              WrEn        <= 1'b0;
              RdEn        <= 1'b0;
              ErrorLat    <= 1'b1;
              $display("Error Response from MPMC TrickMem slave");
            end
        end
      else
        begin
          WrEn            <= 1'b0;
          RdEn            <= 1'b0;
          iHRESP          <= 2'b00;
          HREADYOUT       <= 1'b1;
          ErrorLat        <= 1'b0;
        end
    end
end // p_BusRespSeq

// -----------------------------------------------------------------------------
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
assign NxtMPMCTrIDCY    = (MPMCTrIDCYWr == 1'b1) ? HWDATA[4:0] : iMPMCTrIDCY;

assign NxtMPMCTrWaitRd  = (MPMCTrWaitRdWr == 1'b1) ?
                           HWDATA[5:0] : iMPMCTrWaitRd;

assign NxtMPMCTrWaitWr  = (MPMCTrWaitWrWr == 1'b1) ?
                           HWDATA[5:0] : iMPMCTrWaitWr;

assign NxtMPMCTrWaitPg  = (MPMCTrWaitPgWr == 1'b1) ?
                           HWDATA[5:0] : iMPMCTrWaitPg;

assign NxtMPMCTrMEMT    = (MPMCTrMEMTWr == 1'b1) ? HWDATA[10:0] : iMPMCTrMEMT;

assign NxtMPMCTrMEMB    = (MPMCTrMEMBWr == 1'b1) ? HWDATA[16:0] : iMPMCTrMEMB;

assign NxtMPMCTrCS2OEN  = (MPMCTrCS2OENWr == 1'b1) ?
                           HWDATA[4:0] : iMPMCTrCS2OEN;

assign NxtMPMCTrCS2WEN  = (MPMCTrCS2WENWr == 1'b1) ?
                           HWDATA[4:0] : iMPMCTrCS2WEN;

assign NxtMPMCTrCSPOL   = (MPMCTrCSPOLWr == 1'b1) ?
                           HWDATA[7:0] : iMPMCTrCSPOL;

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegUpdateSeq
  if (HRESETn == 1'b0)
    begin
      iMPMCTrIDCY       <= 5'b00000;
      iMPMCTrWaitRd     <= 6'b011111;
      iMPMCTrWaitWr     <= 6'b011111;
      iMPMCTrWaitPg     <= 6'b011111;
      iMPMCTrMEMT[5:4]  <= 2'b00;
      iMPMCTrMEMT[10:8] <= 3'b000;
      iMPMCTrMEMB       <= 15'b000000000000000;
      iMPMCTrCS2OEN     <= 5'b00000;
      iMPMCTrCS2WEN     <= 5'b00000;
      iMPMCTrCSPOL      <= 8'h00;
    end
  else
    begin
      iMPMCTrIDCY       <= NxtMPMCTrIDCY;
      iMPMCTrWaitRd     <= NxtMPMCTrWaitRd;
      iMPMCTrWaitWr     <= NxtMPMCTrWaitWr;
      iMPMCTrWaitPg     <= NxtMPMCTrWaitPg;
      iMPMCTrMEMT       <= NxtMPMCTrMEMT;
      iMPMCTrMEMB       <= NxtMPMCTrMEMB;
      iMPMCTrCS2OEN     <= NxtMPMCTrCS2OEN;
      iMPMCTrCS2WEN     <= NxtMPMCTrCS2WEN;
      iMPMCTrCSPOL      <= NxtMPMCTrCSPOL;
    end
end // p_RegUpdateSeq

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;
assign LatchHADDR       = iLatchHADDR;
assign MPMCTrIDCY       = iMPMCTrIDCY;
assign MPMCTrWaitRd     = iMPMCTrWaitRd;
assign MPMCTrWaitWr     = iMPMCTrWaitWr;
assign MPMCTrWaitPg     = iMPMCTrWaitPg;
assign MPMCTrMEMT       = iMPMCTrMEMT;
assign MPMCTrMEMB       = iMPMCTrMEMB;
assign MPMCTrCS2OEN     = iMPMCTrCS2OEN;
assign MPMCTrCS2WEN     = iMPMCTrCS2WEN;
assign MPMCTrCSPOL      = iMPMCTrCSPOL;

endmodule

// --================================== End ==================================--
