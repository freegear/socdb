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
// File Name              : SmcTrMemAhbifReg.v.rca
// File Revision          : 1.14
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the SMC Memory model with the AHB bus.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrMemAhbifReg (
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
                         HSELSMCTRMEM,
                         AhbRdDataDW,

// Outputs
                         HRDATA,
                         HREADYOUT,
                         HRESP,

                         SMCTrMEMRWr,
                         LatchHADDR,
                         SMCTrIDCY,
                         SMCTrWST1,
                         SMCTrWST2,
                         SMCTrMEMT,
                         SMCTrMEMB,
                         SMCTrCS2OEN,
                         SMCTrCS2WEN,
                         SMCTrCSPOL
                        );

// Inputs
input         HCLK;         // AHB Clock
input         HRESETn;      // Bus Reset
input  [15:0] HADDR;        // AHB Address Bus
input   [1:0] HTRANS;       // Transfer type
input         HWRITE;       // AHB Peripheral Write
input   [2:0] HSIZE;        // Transfer size
input   [2:0] HBURST;       // Burst Type
input         HREADYIN;     // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;       // AHB Write Data bus
input         HSELSMCTRMEM; // AHB Peripheral (TrickMem) Select
input  [31:0] AhbRdDataDW;  // Mem Rd data



// Outputs
output [31:0] HRDATA;       // AHB Read Data bus
output        HREADYOUT;    // Slave HREADY output
output  [1:0] HRESP;        // Slave response


output        SMCTrMEMRWr;  // SMCTrMEMR Write enable
output [15:0] LatchHADDR;   // Latched AHB Address
output  [4:0] SMCTrIDCY;    // SMCTrIDCY Register
output  [5:0] SMCTrWST1;    // SMCTrWST1 Register
output  [5:0] SMCTrWST2;    // SMCTrWST2 Register
output [10:0] SMCTrMEMT;    // SMCTrMEMT Register
output [14:0] SMCTrMEMB;    // SMCTrMEMB Register
output  [4:0] SMCTrCS2OEN;  // SMCTrCS2OEN Register
output  [4:0] SMCTrCS2WEN;  // SMCTrCS2WEN Register
output  [7:0] SMCTrCSPOL;   // SMCTrCSPOL Register




// Inputs
  wire        HCLK;         // AHB Clock
  wire        HRESETn;      // Bus Reset
  wire [15:0] HADDR;        // AHB Address Bus
  wire  [1:0] HTRANS;       // Transfer type
  wire        HWRITE;       // AHB Peripheral Write
  wire  [2:0] HSIZE;        // Transfer size
  wire  [2:0] HBURST;       // Burst Type
  wire        HREADYIN;     // Multiplexed version of HREADY outputs
  wire [31:0] HWDATA;       // AHB Write Data bus
  wire        HSELSMCTRMEM; // AHB Peripheral (TrickMem) Select
  wire [31:0] AhbRdDataDW;  // Mem Rd data


// Outputs
  wire [31:0] HRDATA;       // AHB Read Data bus
  reg         HREADYOUT;    // Slave HREADY output
  wire  [1:0] HRESP;        // Slave response

  wire        SMCTrMEMRWr;  // SMCTrMEMR Write enable
  wire [15:0] LatchHADDR;   // Latched AHB Address
  wire  [4:0] SMCTrIDCY;    // SMCTrIDCY Register
  wire  [5:0] SMCTrWST1;    // SMCTrWST1 Register
  wire  [5:0] SMCTrWST2;    // SMCTrWST2 Register
  wire [10:0] SMCTrMEMT;    // SMCTrMEMT Register
  wire [14:0] SMCTrMEMB;    // SMCTrMEMB Register
  wire  [4:0] SMCTrCS2OEN;  // SMCTrCS2OEN Register
  wire  [4:0] SMCTrCS2WEN;  // SMCTrCS2WEN Register
  wire  [7:0] SMCTrCSPOL;   // SMCTrCSPOL Register


// -----------------------------------------------------------------------------
//
//                              SmcTrMemAhbifReg
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SMC Tricbox is an AHB slave. This block interfaces the trickbox with the AHB
// bus. All slave response signals are generated from this module.
// This module decodes AHB accesses and generates the read/write
// strobe to the appropriate registers. HCLK period calculation logic also
// contained in this module.
//
// -----------------------------------------------------------------------------
//                         SMC Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register    Type   Width    Describtion
// -----------------------------------------------------------------------------
// 0x0000 -  SMCTrMEMR   R/W    32-bit   32-bit wide and 2K deep Memory. By
// 0x1FFF                                changing the MemDeep value in
//                                       SmcTrConst file it is possible to
//                                       change the size of the memory array.
//
// 0x2000    SMCTrIDCY   R/W    5-bit    Memory data bus turn around time.
//
// 0x4000    SMCTrWST1   R/W    6-bit    This is read access time in case of
//                                       SRAM and ROM. This is initial access
//                                       time in case of Burst ROM.
//
// 0x6000    SMCTrWST2   R/W    6-bit    This is write access time in case of
//                                       SRAM. This is burst access time in
//                                       case of BURST ROM.
//
// 0x8000    SMCTrMEMT   R/W   11-bit    Memory type and width configuration
//                                       register.
//
// 0x9000    SMCTrMEMB   R/W    15-bit   Memory base address register.
//
// 0xA000    SMCTrCS2OEN R/W     5-bit   In the case of SRAMs and ROMs, this
//                                       register determines the time duration
//                                       between Chip Select assertion and the
//                                       nSMOEN assertion.
//                                       In the case of BROMs initial access
//                                       to this register determines the time
//                                       duration between Chip Select
//                                       assertion and the nSMOEN assertion
//                                       and is insignificant in successive
//                                       BROM accesses.
//
// 0xB000    SMCTrCS2WEN R/W     5-bit   In the case of SRAMs, this register
//                                       determines the time duration between
//                                       Chip Select assertion and the nSMWEN
//                                       assertion.
//                                       In the case of BROMs and ROMs, this
//                                       field is insignificant.
//
// 0xC000    SMCTrCSPOL  R/W     8-bit   Chip Select Polarity setting register.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define IDLE             2'b00
// Master IDLE respone

`define BUSY             2'b01
// Master BUSY respone

`define OKAY             2'b00
// Slave OKAY respone

`define ERROR            2'b01
// Slave ERROR respone

`define WORD             3'b010
// 32-bit operation

`define INCR             3'b001
// Undefined length burst

`define ZEROFILL         32'h00000000

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 12 to 15 (4 bits)
// -----------------------------------------------------------------------------
`define HADDR_SMCTrMEMR   4'h0
// SMCTrMEMR at offset 0x0000 to 1FFF

`define HADDR_SMCTrIDCY   4'h2
// SMCTrIDCY at offset 0x2000

`define HADDR_SMCTrWST1   4'h4
// SMCTrWST1 at offset 0x4000

`define HADDR_SMCTrWST2   4'h6
// SMCTrWST2 at offset 0x6000

`define HADDR_SMCTrMEMT   4'h8
// SMCTrMEMT at offset 0x8000

`define HADDR_SMCTrMEMB   4'h9
// SMCTrMEMB at offset 0x9000

`define HADDR_SMCTrCS2OEN 4'hA
// SMCTrCS2OEN at offset 0xA000

`define HADDR_SMCTrCS2WEN 4'hB
// SMCTrCS2WEN at offset 0xB000

`define HADDR_SMCTrCSPOL  4'hC
// SMCTrCSPOL at offset 0xC000

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [3:0] SelLatchHADDR;
// Used for Adress decoding

wire  [4:0] NxtSMCTrIDCY;
// D-Input of SMCTrIDCY Register

wire  [5:0] NxtSMCTrWST1;
// D-Input of SMCTrWST1 Register

wire  [5:0] NxtSMCTrWST2;
// D-Input of SMCTrWST2 Register

wire [10:0] NxtSMCTrMEMT;
// D-Input of SMCTrMEMT Register

wire [14:0] NxtSMCTrMEMB;
// D-Input of SMCTrMEMB Register

wire  [4:0] NxtSMCTrCS2OEN;
// D-Input of SMCTrCS2OEN Register

wire  [4:0] NxtSMCTrCS2WEN;
// D-Input of SMCTrCS2WEN Register

wire  [7:0] NxtSMCTrCSPOL;
// D-Input of SMCTrCSPOL Register

wire        SMCTrMEMRRd;
// SMCTrMEMR Read

wire        SMCTrIDCYRd;
// SMCTrIDCY Read

wire        SMCTrWST1Rd;
// SMCTrWST1 Read

wire        SMCTrWST2Rd;
// SMCTrWST2 Read

wire        SMCTrMEMTRd;
// SMCTrMEMT Read

wire        SMCTrMEMBRd;
// SMCTrMEMB Read

wire        SMCTrCS2OENRd;
// SMCTrCS2OEN Read

wire        SMCTrCS2WENRd;
// SMCTrCS2WEN Read

wire        SMCTrCSPOLRd;
// SMCTrCSPOL Read

wire        SMCTrIDCYWr;
// SMCTrIDCY Write

wire        SMCTrWST1Wr;
// SMCTrWST1 Write

wire        SMCTrWST2Wr;
// SMCTrWST2 Write

wire        SMCTrMEMTWr;
// SMCTrMEMT Write

wire        SMCTrMEMBWr;
// SMCTrMEMB Write

wire        SMCTrCS2OENWr;
// SMCTrCS2OEN Write

wire        SMCTrCS2WENWr;
// SMCTrCS2WEN Write

wire        SMCTrCSPOLWr;
// SMCTrCSPOL Write

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [15:0] iLatchHADDR;
// Latched version of HADDR

reg   [1:0] iHRESP;
// Indicates the type of response for a transfer

// signal SMCTrMEMR     : std_logic_vector(31 downto 0);
// SMCTrMEMR Register

reg   [4:0] iSMCTrIDCY;
// Internal version of SMCTrIDCY Register

reg   [5:0] iSMCTrWST1;
// Internal version of SMCTrWST1 Register

reg   [5:0] iSMCTrWST2;
// Internal version of SMCTrWST2 Register

reg  [10:0] iSMCTrMEMT;
// Internal version of SMCTrMEMT Register

reg  [14:0] iSMCTrMEMB;
// Internal version of SMCTrMEMB Register

reg   [4:0] iSMCTrCS2OEN;
// Internal version of SMCTrCS2OEN Register

reg   [4:0] iSMCTrCS2WEN;
// Internal version of SMCTrCS2WEN Register

reg   [7:0] iSMCTrCSPOL;
// Internal version of SMCTrCSPOL Register

reg         RdEn;
// Read enable signal

reg         WrEn;
// Write enable signal

reg         ErrorLat;
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


// -----------------------------------------------------------------------------
// It is used for address decoding
// -----------------------------------------------------------------------------
assign SelLatchHADDR    = iLatchHADDR[15:12];

// -----------------------------------------------------------------------------
// Write enable for registers
// -----------------------------------------------------------------------------
assign SMCTrMEMRWr      = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrMEMR)) ? 1'b1 : 1'b0;

assign SMCTrIDCYWr      = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrIDCY)) ? 1'b1 : 1'b0;

assign SMCTrWST1Wr      = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrWST1)) ? 1'b1 : 1'b0;

assign SMCTrWST2Wr      = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrWST2)) ? 1'b1 : 1'b0;

assign SMCTrMEMTWr      = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrMEMT)) ? 1'b1 : 1'b0;

assign SMCTrMEMBWr      = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrMEMB)) ? 1'b1 : 1'b0;

assign SMCTrCS2OENWr    = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrCS2OEN)) ? 1'b1 : 1'b0;

assign SMCTrCS2WENWr    = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrCS2WEN)) ? 1'b1 : 1'b0;

assign SMCTrCSPOLWr     = ((WrEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrCSPOL)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Read enable for registers
// -----------------------------------------------------------------------------
assign SMCTrMEMRRd      = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrMEMR)) ? 1'b1 : 1'b0;

assign SMCTrIDCYRd      = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrIDCY)) ? 1'b1 : 1'b0;

assign SMCTrWST1Rd      = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrWST1)) ? 1'b1 : 1'b0;

assign SMCTrWST2Rd      = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrWST2)) ? 1'b1 : 1'b0;

assign SMCTrMEMTRd      = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrMEMT)) ? 1'b1 : 1'b0;

assign SMCTrMEMBRd      = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrMEMB)) ? 1'b1 : 1'b0;

assign SMCTrCS2OENRd    = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrCS2OEN)) ? 1'b1 : 1'b0;

assign SMCTrCS2WENRd    = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrCS2WEN)) ? 1'b1 : 1'b0;

assign SMCTrCSPOLRd     = ((RdEn == 1'b1) &
                           (SelLatchHADDR == `HADDR_SMCTrCSPOL)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATA           = (SMCTrMEMRRd == 1'b1) ?
                           AhbRdDataDW :
                          ((SMCTrIDCYRd == 1'b1) ?
                           {27'b000000000000000000000000000, iSMCTrIDCY} :
                          ((SMCTrWST1Rd == 1'b1) ?
                           {26'b00000000000000000000000000, iSMCTrWST1} :
                          ((SMCTrWST2Rd == 1'b1) ?
                           {26'b00000000000000000000000000, iSMCTrWST2} :
                          ((SMCTrMEMTRd == 1'b1) ?
                           {21'b000000000000000000000, iSMCTrMEMT} :
                          ((SMCTrMEMBRd == 1'b1) ?
                           {17'b00000000000000000, iSMCTrMEMB} :
                          ((SMCTrCS2OENRd == 1'b1) ?
                           {27'b000000000000000000000000000, iSMCTrCS2OEN} :
                          ((SMCTrCS2WENRd == 1'b1) ?
                           {27'b000000000000000000000000000, iSMCTrCS2WEN} :
                          ((SMCTrCSPOLRd == 1'b1) ?
                           {24'h000000, iSMCTrCSPOL} :
                           32'h00000000))))))));

// -----------------------------------------------------------------------------
// This process generate the bus response required for an AHB slave.
// SMC trickbox is designed for an HBURST of INCR type and an HSIZE of 32-bit.
// So this process will generate an ERROR response when the master try to access
// it in some other mode. Also it display an error message to the output.
// Trickbox always provides a ZERO wait state OKAY response for IDLE and BUSY
// HTRANS of the master.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusRespSeq
  if (HRESETn == 1'b0)
    begin
      iHRESP           <= 2'b00;
      HREADYOUT        <= 1'b1;
      WrEn             <= 1'b0;
      RdEn             <= 1'b0;
      ErrorLat         <= 1'b0;
      iLatchHADDR      <= 16'h0000;
    end
  else
    begin
      if ((iHRESP == `ERROR) && (HREADYIN == 1'b0) && (ErrorLat == 1'b1))
        begin
          iHRESP           <= `ERROR;
          HREADYOUT        <= 1'b1;
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          ErrorLat         <= 1'b0;
        end
      else if (((HTRANS == `IDLE) || (HTRANS == `BUSY)) &&
               (HSELSMCTRMEM == 1'b1) && (HREADYIN == 1'b1))
        begin
          iHRESP           <= `OKAY;
          HREADYOUT        <= 1'b1;
        end
      else if ((HREADYIN == 1'b1) && (HSELSMCTRMEM == 1'b1))
        begin
          if ((HBURST == `INCR) && (HSIZE == `WORD))
            begin
              HREADYOUT        <= 1'b1;
              iLatchHADDR      <= HADDR;
              iHRESP           <= `OKAY;
              if (HWRITE == 1'b1)
                begin
                  WrEn             <= 1'b1;
                  RdEn             <= 1'b0;
                end
              else
                begin
                  WrEn             <= 1'b0;
                  RdEn             <= 1'b1;
                end
            end
          else
            begin
              iHRESP           <= `ERROR;
              HREADYOUT        <= 1'b0;
              WrEn             <= 1'b0;
              RdEn             <= 1'b0;
              ErrorLat         <= 1'b1;
              $display("Error Response from SMC TrickMem slave");
            end
        end
      else
        begin
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          iHRESP           <= 2'b00;
          HREADYOUT        <= 1'b1;
          ErrorLat         <= 1'b0;
        end
    end
end // p_BusRespSeq

// -----------------------------------------------------------------------------
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
assign NxtSMCTrIDCY     = (SMCTrIDCYWr == 1'b1) ?
                           HWDATA[4:0] : iSMCTrIDCY;

assign NxtSMCTrWST1     = (SMCTrWST1Wr == 1'b1) ?
                           HWDATA[5:0] : iSMCTrWST1;

assign NxtSMCTrWST2     = (SMCTrWST2Wr == 1'b1) ?
                           HWDATA[5:0] : iSMCTrWST2;

assign NxtSMCTrMEMT     = (SMCTrMEMTWr == 1'b1) ?
                           HWDATA[10:0] : iSMCTrMEMT;

assign NxtSMCTrMEMB     = (SMCTrMEMBWr == 1'b1) ?
                           HWDATA[14:0] : iSMCTrMEMB;

assign NxtSMCTrCS2OEN   = (SMCTrCS2OENWr == 1'b1) ?
                           HWDATA[4:0] : iSMCTrCS2OEN;

assign NxtSMCTrCS2WEN   = (SMCTrCS2WENWr == 1'b1) ?
                           HWDATA[4:0] : iSMCTrCS2WEN;

assign NxtSMCTrCSPOL    = (SMCTrCSPOLWr == 1'b1) ?
                           HWDATA[7:0] : iSMCTrCSPOL;

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegUpdateSeq
  if (HRESETn == 1'b0)
  begin
     iSMCTrIDCY       <= 5'b00000;
     iSMCTrWST1       <= 6'b011111;
     iSMCTrWST2       <= 6'b011111;
     iSMCTrMEMT       <= 11'b00000000000;
     iSMCTrMEMB       <= 15'b000000000000000;
     iSMCTrCS2OEN     <= 5'b00000;
     iSMCTrCS2WEN     <= 5'b00001;
     iSMCTrCSPOL      <= 8'h00;
    end
    else
    begin
     iSMCTrIDCY       <= NxtSMCTrIDCY;
     iSMCTrWST1       <= NxtSMCTrWST1;
     iSMCTrWST2       <= NxtSMCTrWST2;
     iSMCTrMEMT       <= NxtSMCTrMEMT;
     iSMCTrMEMB       <= NxtSMCTrMEMB;
     iSMCTrCS2OEN     <= NxtSMCTrCS2OEN;
     iSMCTrCS2WEN     <= NxtSMCTrCS2WEN;
     iSMCTrCSPOL      <= NxtSMCTrCSPOL;
  end
end // p_RegUpdateSeq

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign HRESP            = iHRESP;
assign LatchHADDR       = iLatchHADDR;
assign SMCTrIDCY        = iSMCTrIDCY;
assign SMCTrWST1        = iSMCTrWST1;
assign SMCTrWST2        = iSMCTrWST2;
assign SMCTrMEMT        = iSMCTrMEMT;
assign SMCTrMEMB        = iSMCTrMEMB;
assign SMCTrCS2OEN      = iSMCTrCS2OEN;
assign SMCTrCS2WEN      = iSMCTrCS2WEN;
assign SMCTrCSPOL       = iSMCTrCSPOL;

endmodule
// --================================== End ==================================--
