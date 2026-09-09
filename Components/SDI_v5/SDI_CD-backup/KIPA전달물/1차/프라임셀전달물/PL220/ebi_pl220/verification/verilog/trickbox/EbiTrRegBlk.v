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
// File Name              : EbiTrRegBlk.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements the AHB read/write registers in the
//           EBI Trickbox
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module EbiTrRegBlk (
// Inputs
                    // AHB bus signals
                    HCLK,
                    MEMCLK1,
                    MEMCLK2,
                    MEMCLK3,
                    HRESETn,
                    HREADYIN,
                    WriteData,
                    EbiTrCntlWr,
                    EbiTrClkWr,
                    EbiTrAddr1Wr,
                    EbiTrAddr2Wr,
                    EbiTrAddr3Wr,
                    EbiTrData1Wr,
                    EbiTrData2Wr,
                    EbiTrData3Wr,
                    nEbiTrDataEn1Wr,
                    nEbiTrDataEn2Wr,
                    nEbiTrDataEn3Wr,
                    EbiTrExtDataInWr,
                    EbiTrTimeOut1Wr,
                    EbiTrTimeOut2Wr,
                    EbiTrTimeOut3Wr,
                    EBIGNT1,
                    EBIGNT2,
                    EBIGNT3,
                    EBIBACKOFF1,
                    EBIBACKOFF2,
                    EBIBACKOFF3,

// Outputs
                    EBIREQ1,
                    EBIREQ2,
                    EBIREQ3,
                    ClkFlag,
                    EventFlag,
                    EbiTrCntl,
                    EbiTrStatus,
                    EbiTrClk,
                    EbiTrAddr1,
                    EbiTrAddr2,
                    EbiTrAddr3,
                    EbiTrData1,
                    EbiTrData2,
                    EbiTrData3,
                    nEbiTrDataEn1,
                    nEbiTrDataEn2,
                    nEbiTrDataEn3,
                    EbiTrExtDataIn,
                    EbiTrTimeOut1,
                    EbiTrTimeOut2,
                    EbiTrTimeOut3,
                    EBIADDR1,
                    EBIADDR2,
                    EBIADDR3,
                    EBIDATA1,
                    EBIDATA2,
                    EBIDATA3,
                    nEBIDATAEN1,
                    nEBIDATAEN2,
                    nEBIDATAEN3,
                    EBIEXTDATAIN,
                    EBITIMEOUTVALUE1,
                    EBITIMEOUTVALUE2,
                    EBITIMEOUTVALUE3
                   );

// Inputs

// AHB bus signals
input         HCLK;             // AHB Bus Clock
input         MEMCLK1;          // Memory Clock1
input         MEMCLK2;          // Memory Clock2
input         MEMCLK3;          // Memory Clock3
input         HRESETn;          // Bus Reset
input         HREADYIN;         // HREADYIN for AHB
input  [31:0] WriteData;        // Write Data bus to the Register
                                // Block
input         EbiTrCntlWr;      // EbiTrCntl register write enable
input         EbiTrClkWr;       // EbiTrClk Register Write Enable
input         EbiTrAddr1Wr;     // EbiTrAddr1 Register Write Enable
input         EbiTrAddr2Wr;     // EbiTrAddr2 Register Write Enable
input         EbiTrAddr3Wr;     // EbiTrAddr3 Register Write Enable
input         EbiTrData1Wr;     // EbiTrData1 Register Write Enable
input         EbiTrData2Wr;     // EbiTrData2 Register Write Enable
input         EbiTrData3Wr;     // EbiTrData3 Register Write Enable
input         nEbiTrDataEn1Wr;  // nEbiTrDataEn1 Register Write Enable
input         nEbiTrDataEn2Wr;  // nEbiTrDataEn2 Register Write Enable
input         nEbiTrDataEn3Wr;  // nEbiTrDataEn3 Register Write Enable
input         EbiTrExtDataInWr; // EbiTrExtDataIn Register Write
                                // Enable
input         EbiTrTimeOut1Wr;  // EbiTrTimeOut1 Register Write Enable
input         EbiTrTimeOut2Wr;  // EbiTrTimeOut2 Register Write Enable
input         EbiTrTimeOut3Wr;  // EbiTrTimeOut3 Register Write Enable
input         EBIGNT1;          // grant signal from port1
input         EBIGNT2;          // grant signal from port2
input         EBIGNT3;          // grant signal from port3
input         EBIBACKOFF1;      // backoff signal from port1
input         EBIBACKOFF2;      // backoff signal from port2
input         EBIBACKOFF3;      // backoff signal from port3

// Outputs
output        EBIREQ1;          // EBI Request from port1
output        EBIREQ2;          // EBI Request from port2
output        EBIREQ3;          // EBI Request from port3
output        ClkFlag;          // Indicates whether Request
                                // comparison is clk by clk
output        EventFlag;        // Indicates whether Request
                                // comparison is on event basis
output  [7:0] EbiTrCntl;        // EbiTrCntl Register
output  [5:0] EbiTrStatus;      // EbiTrStatus Register
output  [2:0] EbiTrClk;         // MEMCLK frequency indicator
output [31:0] EbiTrAddr1;       // EbiTrAddr1 Register
output [31:0] EbiTrAddr2;       // EbiTrAddr2 Register
output [31:0] EbiTrAddr3;       // EbiTrAddr3 Register
output [31:0] EbiTrData1;       // EbiTrData1 Register
output [31:0] EbiTrData2;       // EbiTrData2 Register
output [31:0] EbiTrData3;       // EbiTrData3 Register
output  [3:0] nEbiTrDataEn1;    // nEbiTrDataEn1 Register
output  [3:0] nEbiTrDataEn2;    // nEbiTrDataEn2 Register
output  [3:0] nEbiTrDataEn3;    // nEbiTrData3 Register
output [31:0] EbiTrExtDataIn;   // EbiTrExtDataIn Register
output  [9:0] EbiTrTimeOut1;    // EbiTrTimeOut1 Register
output  [9:0] EbiTrTimeOut2;    // EbiTrTimeOut2 Register
output  [9:0] EbiTrTimeOut3;    // EbiTrTimeOut3 Register
output [31:0] EBIADDR1;         // Address bus from port 1
output [31:0] EBIADDR2;         // Address bus from port 2
output [31:0] EBIADDR3;         // Address bus from port 3
output [31:0] EBIDATA1;         // Data bus from port 1
output [31:0] EBIDATA2;         // Data bus from port 2
output [31:0] EBIDATA3;         // Data bus from port 3
output  [3:0] nEBIDATAEN1;      // Data enable bus from port 1
output  [3:0] nEBIDATAEN2;      // Data enable bus from port 2
output  [3:0] nEBIDATAEN3;      // Data enable bus from port 3
output [31:0] EBIEXTDATAIN;     // External DataIn from the memory
output  [9:0] EBITIMEOUTVALUE1; // Tie up value for port 1
output  [9:0] EBITIMEOUTVALUE2; // Tie up value for port 2
output  [9:0] EBITIMEOUTVALUE3; // Tie up value for port 3

// Inputs

// AHB bus signals
wire        HCLK;             // AHB Bus Clock
wire        MEMCLK1;          // Memory Clock1
wire        MEMCLK2;          // Memory Clock2
wire        MEMCLK3;          // Memory Clock3
wire        HRESETn;          // Bus Reset
wire        HREADYIN;         // HREADYIN for AHB
wire [31:0] WriteData;        // Write Data bus to the Register
                              // Block
wire        EbiTrCntlWr;      // EbiTrCntl register write enable
wire        EbiTrClkWr;       // EbiTrClk Register Write Enable
wire        EbiTrAddr1Wr;     // EbiTrAddr1 Register Write Enable
wire        EbiTrAddr2Wr;     // EbiTrAddr2 Register Write Enable
wire        EbiTrAddr3Wr;     // EbiTrAddr3 Register Write Enable
wire        EbiTrData1Wr;     // EbiTrData1 Register Write Enable
wire        EbiTrData2Wr;     // EbiTrData2 Register Write Enable
wire        EbiTrData3Wr;     // EbiTrData3 Register Write Enable
wire        nEbiTrDataEn1Wr;  // nEbiTrDataEn1 Register Write Enable
wire        nEbiTrDataEn2Wr;  // nEbiTrDataEn2 Register Write Enable
wire        nEbiTrDataEn3Wr;  // nEbiTrDataEn3 Register Write Enable
wire        EbiTrExtDataInWr; // EbiTrExtDataIn Register Write
                              // Enable
wire        EbiTrTimeOut1Wr;  // EbiTrTimeOut1 Register Write Enable
wire        EbiTrTimeOut2Wr;  // EbiTrTimeOut2 Register Write Enable
wire        EbiTrTimeOut3Wr;  // EbiTrTimeOut3 Register Write Enable
wire        EBIGNT1;          // grant signal from port1
wire        EBIGNT2;          // grant signal from port2
wire        EBIGNT3;          // grant signal from port3
wire        EBIBACKOFF1;      // backoff signal from port1
wire        EBIBACKOFF2;      // backoff signal from port2
wire        EBIBACKOFF3;      // backoff signal from port3

// Outputs
reg         EBIREQ1;          // EBI Request from port1
reg         EBIREQ2;          // EBI Request from port2
reg         EBIREQ3;          // EBI Request from port3
reg         ClkFlag;          // Indicates whether Request
                              // comparison is clk by clk
reg         EventFlag;        // Indicates whether Request
                              // comparison is on event basis
wire  [7:0] EbiTrCntl;        // EbiTrCntl Register
wire  [5:0] EbiTrStatus;      // EbiTrStatus Register
reg   [2:0] EbiTrClk;         // MEMCLK frequency indicator
reg  [31:0] EbiTrAddr1;       // EbiTrAddr1 Register
reg  [31:0] EbiTrAddr2;       // EbiTrAddr2 Register
reg  [31:0] EbiTrAddr3;       // EbiTrAddr3 Register
reg  [31:0] EbiTrData1;       // EbiTrData1 Register
reg  [31:0] EbiTrData2;       // EbiTrData2 Register
reg  [31:0] EbiTrData3;       // EbiTrData3 Register
reg   [3:0] nEbiTrDataEn1;    // nEbiTrDataEn1 Register
reg   [3:0] nEbiTrDataEn2;    // nEbiTrDataEn2 Register
reg   [3:0] nEbiTrDataEn3;    // nEbiTrData3 Register
reg  [31:0] EbiTrExtDataIn;   // EbiTrExtDataIn Register
reg   [9:0] EbiTrTimeOut1;    // EbiTrTimeOut1 Register
reg   [9:0] EbiTrTimeOut2;    // EbiTrTimeOut2 Register
reg   [9:0] EbiTrTimeOut3;    // EbiTrTimeOut3 Register
wire [31:0] EBIADDR1;         // Address bus from port 1
wire [31:0] EBIADDR2;         // Address bus from port 2
wire [31:0] EBIADDR3;         // Address bus from port 3
wire [31:0] EBIDATA1;         // Data bus from port 1
wire [31:0] EBIDATA2;         // Data bus from port 2
wire [31:0] EBIDATA3;         // Data bus from port 3
wire  [3:0] nEBIDATAEN1;      // Data enable bus from port 1
wire  [3:0] nEBIDATAEN2;      // Data enable bus from port 2
wire  [3:0] nEBIDATAEN3;      // Data enable bus from port 3
wire [31:0] EBIEXTDATAIN;     // External DataIn from the memory
wire  [9:0] EBITIMEOUTVALUE1; // Tie up value for port 1
wire  [9:0] EBITIMEOUTVALUE2; // Tie up value for port 2
wire  [9:0] EBITIMEOUTVALUE3; // Tie up value for port 3

// -----------------------------------------------------------------------------
//
//                                 EbiTrRegBlk
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// EBI Tricbox is an AHB slave. This block performs the following operations:
//   - Implements EBI Trickbox registers
//   - Drives non-AMBA, non-memory related signals into the EBI
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        NxtEBIREQ1;
// D-input for the EBIREQ1Q Register

wire        NxtEBIREQ2;
// D-input for the EBIREQ2Q Register

wire        NxtEBIREQ3;
// D-input for the EBIREQ3Q Register

wire        NxtClkFlag;
// D-input for the ClkFlag

wire        NxtEventFlag;
// D-input for the EventFlag

wire [31:0] NxtEbiTrAddr1;
// D-input for the EbiTrAddr1Q Register

wire [31:0] NxtEbiTrAddr2;
// D-input for the EbiTrAddr2Q Register

wire [31:0] NxtEbiTrAddr3;
// D-input for the EbiTrAddr3Q Register

wire [31:0] NxtEbiTrData1;
// D-input for the EbiTrData1Q Register

wire [31:0] NxtEbiTrData2;
// D-input for the EbiTrData2Q Register

wire [31:0] NxtEbiTrData3;
// D-input for the EbiTrData3Q Register

wire  [3:0] NxtnEbiTrDataEn1;
// D-input for the nEbiTrDataEn1Q Register

wire  [3:0] NxtnEbiTrDataEn2;
// D-input for the nEbiTrDataEn2Q Register

wire  [3:0] NxtnEbiTrDataEn3;
// D-input for the nEbiTrDataEn3Q Register

wire [31:0] NxtEbiTrExDataIn;
// D-input for the EbiTrExtDataIn Register

wire  [9:0] NxtEbiTrTimeOut1;
// D-input for the EbiTrTimeOut1Q Register

wire  [9:0] NxtEbiTrTimeOut2;
// D-input for the EbiTrTimeOut2Q Register

wire  [9:0] NxtEbiTrTimeOut3;
// D-input for the EbiTrTimeOut3Q Register

wire  [2:0] NxtEbiTrClk;
// D-input for the EbiTrClk

wire        NxtEbiTrCntlPos1;
// D-input for the EbiTrCntlPos1

wire        NxtEbiTrCntlPos2;
// D-input for the EbiTrCntlPos1

wire        NxtEbiTrCntlPos3;
// D-input for the EbiTrCntlPos1

wire        D1EBIREQ1Q;
// One delta delayed version of the signal EBIREQ1Q

wire [31:0] D1EbiTrAddr1Q;
// One delta delayed version of the signal EbiTrAddr1Q

wire [31:0] D1EbiTrData1Q;
// One delta delayed version of the signal EbiTrData1Q

wire  [3:0] D1nEbiTrDataEn1Q;
// One delta delayed version of the signal nEbiTrDataEn1Q

wire  [9:0] D1EbiTrTimeOut1Q;
// One delta delayed version of the signal EbiTrTimeOut1Q

wire        D1EBIREQ2Q;
// One delta delayed version of the signal EBIREQ2Q

wire [31:0] D1EbiTrAddr2Q;
// One delta delayed version of the signal EbiTrAddr2Q

wire [31:0] D1EbiTrData2Q;
// One delta delayed version of the signal EbiTrData2Q

wire  [3:0] D1nEbiTrDataEn2Q;
// One delta delayed version of the signal nEbiTrDataEn2Q

wire  [9:0] D1EbiTrTimeOut2Q;
// One delta delayed version of the signal EbiTrTimeOut2Q

wire        D1EBIREQ3Q;
// One delta delayed version of the signal EBIREQ3Q

wire [31:0] D1EbiTrAddr3Q;
// One delta delayed version of the signal EbiTrAddr3Q

wire [31:0] D1EbiTrData3Q;
// One delta delayed version of the signal EbiTrData3Q

wire  [3:0] D1nEbiTrDataEn3Q;
// One delta delayed version of the signal nEbiTrDataEn3Q

wire  [9:0] D1EbiTrTimeOut3Q;
// One delta delayed version of the signal EbiTrTimeOut3Q

wire        D2EBIREQ1Q;
// Two delta delayed version of the signal EBIREQ1Q

wire [31:0] D2EbiTrAddr1Q;
// Two delta delayed version of the signal EbiTrAddr1Q

wire [31:0] D2EbiTrData1Q;
// Two delta delayed version of the signal EbiTrData1Q

wire  [3:0] D2nEbiTrDataEn1Q;
// Two delta delayed version of the signal nEbiTrDataEn1Q

wire  [9:0] D2EbiTrTimeOut1Q;
// Two delta delayed version of the signal EbiTrTimeOut1Q

wire        D2EBIREQ2Q;
// Two delta delayed version of the signal EBIREQ2Q

wire [31:0] D2EbiTrAddr2Q;
// Two delta delayed version of the signal EbiTrAddr2Q

wire [31:0] D2EbiTrData2Q;
// Two delta delayed version of the signal EbiTrData2Q

wire  [3:0] D2nEbiTrDataEn2Q;
// Two delta delayed version of the signal nEbiTrDataEn2Q

wire  [9:0] D2EbiTrTimeOut2Q;
// Two delta delayed version of the signal EbiTrTimeOut2Q

wire        D2EBIREQ3Q;
// Two delta delayed version of the signal EBIREQ3Q

wire [31:0] D2EbiTrAddr3Q;
// Two delta delayed version of the signal EbiTrAddr3Q

wire [31:0] D2EbiTrData3Q;
// Two delta delayed version of the signal EbiTrData3Q

wire  [3:0] D2nEbiTrDataEn3Q;
// Two delta delayed version of the signal nEbiTrDataEn3Q

wire  [9:0] D2EbiTrTimeOut3Q;
// Two delta delayed version of the signal EbiTrTimeOut3Q

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         EbiTrCntlPos1;
// Position of EBI Request1 indicator

reg         EbiTrCntlPos2;
// Position of EBI Request2 indicator

reg         EbiTrCntlPos3;
// Position of EBI Request3 indicator

reg         iEBIREQ1;
// Internal version of EBIREQ1 Register

reg         iEBIREQ2;
// Internal version of EBIREQ2 Register

reg         iEBIREQ3;
// Internal version of EBIREQ3 Register

reg         EBIREQ1QQ;
// Clocked version of the EBIREQ1Q Register

reg         EBIREQ2QQ;
// Clocked version of the EBIREQ2Q Register

reg         EBIREQ3QQ;
// Clocked version of the EBIREQ3Q Register

reg  [31:0] EbiTrAddr1QQ;
// Clocked version of the EbiTrAddr1Q Register

reg  [31:0] EbiTrAddr2QQ;
// Clocked version of the EbiTrAddr2Q Register

reg  [31:0] EbiTrAddr3QQ;
// Clocked version of the EbiTrAddr3Q Register

reg  [31:0] EbiTrData1QQ;
// Clocked version of the EbiTrData1Q Register

reg  [31:0] EbiTrData2QQ;
// Clocked version of the EbiTrData2Q Register

reg  [31:0] EbiTrData3QQ;
// Clocked version of the EbiTrData3Q Register

reg   [3:0] nEbiTrDataEn1QQ;
// Clocked version of the nEbiTrDataEn1Q Register

reg   [3:0] nEbiTrDataEn2QQ;
// Clocked version of the nEbiTrDataEn2Q Register

reg   [3:0] nEbiTrDataEn3QQ;
// Clocked version of the nEbiTrDataEn3Q Register

reg   [9:0] EbiTrTimeOut1QQ;
// Clocked version of the EbiTrTimeOut1Q Register

reg   [9:0] EbiTrTimeOut2QQ;
// Clocked version of the EbiTrTimeOut2Q Register

reg   [9:0] EbiTrTimeOut3QQ;
// Clocked version of the EbiTrTimeOut3Q Register

reg         EBIREQ1Q;
// Clocked version of the NxtEBIREQ1 signal

reg         EBIREQ2Q;
// Clocked version of the NxtEBIREQ2 signal

reg         EBIREQ3Q;
// Clocked version of the NxtEBIREQ3 signal

reg  [31:0] EbiTrAddr1Q;
// Clocked version of the NxtEbiTrAddr1 signal

reg  [31:0] EbiTrAddr2Q;
// Clocked version of the NxtEbiTrAddr2 signal

reg  [31:0] EbiTrAddr3Q;
// Clocked version of the NxtEbiTrAddr3 signal

reg  [31:0] EbiTrData1Q;
// Clocked version of the NxtEbiTrData1 signal

reg  [31:0] EbiTrData2Q;
// Clocked version of the NxtEbiTrData2 signal

reg  [31:0] EbiTrData3Q;
// Clocked version of the NxtEbiTrData3 signal

reg   [3:0] nEbiTrDataEn1Q;
// Clocked version of the NxtnEbiTrDataEn1 signal

reg   [3:0] nEbiTrDataEn2Q;
// Clocked version of the NxtnEbiTrDataEn2 signal

reg   [3:0] nEbiTrDataEn3Q;
// Clocked version of the NxtnEbiTrDataEn3 signal

reg   [9:0] EbiTrTimeOut1Q;
// Clocked version of the NxtEbiTrTimeOut1 signal

reg   [9:0] EbiTrTimeOut2Q;
// Clocked version of the NxtEbiTrTimeOut2 signal

reg   [9:0] EbiTrTimeOut3Q;
// Clocked version of the NxtEbiTrTimeOut3 signal

// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
assign NxtEBIREQ1       = (EbiTrCntlWr == 1'b1) ? WriteData[0]       :
                           EBIREQ1Q;

assign NxtEBIREQ2       = (EbiTrCntlWr == 1'b1) ? WriteData[1]       :
                           EBIREQ2Q;

assign NxtEBIREQ3       = (EbiTrCntlWr == 1'b1) ? WriteData[2]       :
                           EBIREQ3Q;

assign NxtEbiTrCntlPos1 = (EbiTrCntlWr == 1'b1) ? WriteData[3]       :
                           EbiTrCntlPos1;

assign NxtEbiTrCntlPos2 = (EbiTrCntlWr == 1'b1) ? WriteData[4]       :
                           EbiTrCntlPos2;

assign NxtEbiTrCntlPos3 = (EbiTrCntlWr == 1'b1) ? WriteData[5]       :
                           EbiTrCntlPos3;

assign NxtClkFlag       = (EbiTrCntlWr == 1'b1) ? WriteData[6]       :
                           ClkFlag;

assign NxtEventFlag     = (EbiTrCntlWr == 1'b1) ? WriteData[7]       :
                           EventFlag;

assign NxtEbiTrClk      = (EbiTrClkWr == 1'b1) ? WriteData[2:0]      :
                           EbiTrClk;

assign NxtEbiTrAddr1    = (EbiTrAddr1Wr == 1'b1) ? WriteData[31:0]   :
                           EbiTrAddr1Q;

assign NxtEbiTrAddr2    = (EbiTrAddr2Wr == 1'b1) ? WriteData[31:0]   :
                           EbiTrAddr2Q;

assign NxtEbiTrAddr3    = (EbiTrAddr3Wr == 1'b1) ? WriteData[31:0]   :
                           EbiTrAddr3Q;

assign NxtEbiTrData1    = (EbiTrData1Wr == 1'b1) ? WriteData[31:0]   :
                           EbiTrData1Q;

assign NxtEbiTrData2    = (EbiTrData2Wr == 1'b1) ? WriteData[31:0]   :
                           EbiTrData2Q;

assign NxtEbiTrData3    = (EbiTrData3Wr == 1'b1) ? WriteData[31:0]   :
                           EbiTrData3Q;

assign NxtnEbiTrDataEn1 = (nEbiTrDataEn1Wr == 1'b1) ? WriteData[3:0] :
                           nEbiTrDataEn1Q;

assign NxtnEbiTrDataEn2 = (nEbiTrDataEn2Wr == 1'b1) ? WriteData[3:0] :
                           nEbiTrDataEn2Q;

assign NxtnEbiTrDataEn3 = (nEbiTrDataEn3Wr == 1'b1) ? WriteData[3:0] :
                           nEbiTrDataEn3Q;

assign NxtEbiTrExDataIn = (EbiTrExtDataInWr == 1'b1) ? WriteData[31:0] :
                           EbiTrExtDataIn;

assign NxtEbiTrTimeOut1 = (EbiTrTimeOut1Wr == 1'b1) ? WriteData[9:0] :
                           EbiTrTimeOut1Q;

assign NxtEbiTrTimeOut2 = (EbiTrTimeOut2Wr == 1'b1) ? WriteData[9:0] :
                           EbiTrTimeOut2Q;

assign NxtEbiTrTimeOut3 = (EbiTrTimeOut3Wr == 1'b1) ? WriteData[9:0] :
                           EbiTrTimeOut3Q;

// -----------------------------------------------------------------------------
// Sequential process for functional registers on HCLK
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_HclkSeq
  if (HRESETn == 1'b0)
    begin
      EBIREQ1Q         <= 1'b0;
      EbiTrAddr1Q      <= 32'h0000000;
      EbiTrData1Q      <= 32'h0000000;
      nEbiTrDataEn1Q   <= 4'b0000;
      EbiTrTimeOut1Q   <= 10'b0000000000;
      EBIREQ2Q         <= 1'b0;
      EbiTrAddr2Q      <= 32'h0000000;
      EbiTrData2Q      <= 32'h0000000;
      nEbiTrDataEn2Q   <= 4'b0000;
      EbiTrTimeOut2Q   <= 10'b0000000000;
      EBIREQ3Q         <= 1'b0;
      EbiTrAddr3Q      <= 32'h0000000;
      EbiTrData3Q      <= 32'h0000000;
      nEbiTrDataEn3Q   <= 4'b0000;
      EbiTrTimeOut3Q   <= 10'b0000000000;
      ClkFlag          <= 1'b0;
      EventFlag        <= 1'b0;
      EbiTrCntlPos1    <= 1'b0;
      EbiTrCntlPos2    <= 1'b0;
      EbiTrCntlPos3    <= 1'b0;
      EbiTrClk         <= 3'b000;
      EbiTrExtDataIn   <= 32'h0000000;
     end
   else
     begin
       EBIREQ1Q         <= NxtEBIREQ1;
       EbiTrAddr1Q      <= NxtEbiTrAddr1;
       EbiTrData1Q      <= NxtEbiTrData1;
       nEbiTrDataEn1Q   <= NxtnEbiTrDataEn1;
       EbiTrTimeOut1Q   <= NxtEbiTrTimeOut1;
       EBIREQ2Q         <= NxtEBIREQ2;
       EbiTrAddr2Q      <= NxtEbiTrAddr2;
       EbiTrData2Q      <= NxtEbiTrData2;
       nEbiTrDataEn2Q   <= NxtnEbiTrDataEn2;
       EbiTrTimeOut2Q   <= NxtEbiTrTimeOut2;
       EBIREQ3Q         <= NxtEBIREQ3;
       EbiTrAddr3Q      <= NxtEbiTrAddr3;
       EbiTrData3Q      <= NxtEbiTrData3;
       nEbiTrDataEn3Q   <= NxtnEbiTrDataEn3;
       EbiTrTimeOut3Q   <= NxtEbiTrTimeOut3;
       ClkFlag          <= NxtClkFlag;
       EventFlag        <= NxtEventFlag;
       EbiTrCntlPos1    <= NxtEbiTrCntlPos1;
       EbiTrCntlPos2    <= NxtEbiTrCntlPos2;
       EbiTrCntlPos3    <= NxtEbiTrCntlPos3;
       EbiTrClk         <= NxtEbiTrClk;
       EbiTrExtDataIn   <= NxtEbiTrExDataIn;
     end
end // p_HclkSeq

// -----------------------------------------------------------------------------
// -- Two delta delay is introduced to following registers on HCLK domain
// -----------------------------------------------------------------------------
assign D1EBIREQ1Q       = EBIREQ1Q;
assign D1EbiTrAddr1Q    = EbiTrAddr1Q;
assign D1EbiTrData1Q    = EbiTrData1Q;
assign D1nEbiTrDataEn1Q = EbiTrData1Q;
assign D1EbiTrTimeOut1Q = EbiTrTimeOut1Q;
assign D1EBIREQ2Q       = EBIREQ2Q;
assign D1EbiTrAddr2Q    = EbiTrAddr2Q;
assign D1EbiTrData2Q    = EbiTrData2Q;
assign D1nEbiTrDataEn2Q = EbiTrData2Q;
assign D1EbiTrTimeOut2Q = EbiTrTimeOut2Q;
assign D1EBIREQ3Q       = EBIREQ3Q;
assign D1EbiTrAddr3Q    = EbiTrAddr3Q;
assign D1EbiTrData3Q    = EbiTrData3Q;
assign D1nEbiTrDataEn3Q = EbiTrData3Q;
assign D1EbiTrTimeOut3Q = EbiTrTimeOut3Q;

assign D2EBIREQ1Q       = D1EBIREQ1Q;
assign D2EbiTrAddr1Q    = D1EbiTrAddr1Q;
assign D2EbiTrData1Q    = D1EbiTrData1Q;
assign D2nEbiTrDataEn1Q = D1EbiTrData1Q;
assign D2EbiTrTimeOut1Q = D1EbiTrTimeOut1Q;
assign D2EBIREQ2Q       = D1EBIREQ2Q;
assign D2EbiTrAddr2Q    = D1EbiTrAddr2Q;
assign D2EbiTrData2Q    = D1EbiTrData2Q;
assign D2nEbiTrDataEn2Q = D1EbiTrData2Q;
assign D2EbiTrTimeOut2Q = D1EbiTrTimeOut2Q;
assign D2EBIREQ3Q       = D1EBIREQ3Q;
assign D2EbiTrAddr3Q    = D1EbiTrAddr3Q;
assign D2EbiTrData3Q    = D1EbiTrData3Q;
assign D2nEbiTrDataEn3Q = D1EbiTrData3Q;
assign D2EbiTrTimeOut3Q = D1EbiTrTimeOut3Q;

// -----------------------------------------------------------------------------
// Sequential process for functional registers writes for Port1.
// -----------------------------------------------------------------------------
always @(posedge MEMCLK1 or negedge HRESETn)
begin : p_MemClk1Seq
  if (HRESETn == 1'b0)
    begin
      EBIREQ1QQ        <= 1'b0;
      EbiTrAddr1QQ     <= 32'h00000000;
      EbiTrData1QQ     <= 32'h00000000;
      nEbiTrDataEn1QQ  <= 4'b0000;
      EbiTrTimeOut1QQ  <= 10'b0000000000;
    end
  else
    begin
      EBIREQ1QQ        <= D2EBIREQ1Q;
      EbiTrAddr1QQ     <= D2EbiTrAddr1Q;
      EbiTrData1QQ     <= D2EbiTrData1Q;
      nEbiTrDataEn1QQ  <= D2nEbiTrDataEn1Q;
      EbiTrTimeOut1QQ  <= D2EbiTrTimeOut1Q;
    end
end // p_MemClk1Seq

// -----------------------------------------------------------------------------
// Mux to select between clocked or delayed request, address and data lines
// for Port1
// -----------------------------------------------------------------------------
always @(EbiTrCntlPos1 or EBIREQ1QQ or EbiTrAddr1QQ or EbiTrData1QQ or
         nEbiTrDataEn1QQ or EbiTrTimeOut1QQ or EBIREQ1Q or EbiTrAddr1Q or
         EbiTrData1Q or nEbiTrDataEn1Q or EbiTrTimeOut1Q)
begin : p_EbiRePos1Comb
  if (EbiTrCntlPos1 == 1'b0)
    begin
      EBIREQ1         = EBIREQ1Q;
      EbiTrAddr1      = EbiTrAddr1Q;
      EbiTrData1      = EbiTrData1Q;
      nEbiTrDataEn1   = nEbiTrDataEn1Q;
      EbiTrTimeOut1   = EbiTrTimeOut1Q;
    end
  else
    begin
      EBIREQ1         = EBIREQ1QQ;
      EbiTrAddr1      = EbiTrAddr1QQ;
      EbiTrData1      = EbiTrData1QQ;
      nEbiTrDataEn1   = nEbiTrDataEn1QQ;
      EbiTrTimeOut1   = EbiTrTimeOut1QQ;
    end
end // p_EbiRePos1Comb

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes for Port2.
// -----------------------------------------------------------------------------
always @(posedge MEMCLK2 or negedge HRESETn)
begin : p_MemClk2Seq
  if (HRESETn == 1'b0)
    begin
      EBIREQ2QQ        <= 1'b0;
      EbiTrAddr2QQ     <= 32'h00000000;
      EbiTrData2QQ     <= 32'h00000000;
      nEbiTrDataEn2QQ  <= 4'b0000;
      EbiTrTimeOut2QQ  <= 10'b0000000000;
    end
  else
    begin
      EBIREQ2QQ        <= D2EBIREQ2Q;
      EbiTrAddr2QQ     <= D2EbiTrAddr2Q;
      EbiTrData2QQ     <= D2EbiTrData2Q;
      nEbiTrDataEn2QQ  <= D2nEbiTrDataEn2Q;
      EbiTrTimeOut2QQ  <= D2EbiTrTimeOut2Q;
    end
end // p_MemClk2Seq

// -----------------------------------------------------------------------------
// Mux to select between clocked or Delayed request, address and data lines
// for Port2
// -----------------------------------------------------------------------------
always @(EbiTrCntlPos2 or EBIREQ2QQ or EbiTrAddr2QQ or EbiTrData2QQ or
         nEbiTrDataEn2QQ or EbiTrTimeOut2QQ or EBIREQ2Q or EbiTrAddr2Q or
         EbiTrData2Q or nEbiTrDataEn2Q or EbiTrTimeOut2Q)
begin : p_EbiRePos2Comb
  if (EbiTrCntlPos2 == 1'b0)
    begin
      EBIREQ2         = EBIREQ2Q;
      EbiTrAddr2      = EbiTrAddr2Q;
      EbiTrData2      = EbiTrData2Q;
      nEbiTrDataEn2   = nEbiTrDataEn2Q;
      EbiTrTimeOut2   = EbiTrTimeOut2Q;
    end
  else
    begin
      EBIREQ2         = EBIREQ2QQ;
      EbiTrAddr2      = EbiTrAddr2QQ;
      EbiTrData2      = EbiTrData2QQ;
      nEbiTrDataEn2   = nEbiTrDataEn2QQ;
      EbiTrTimeOut2   = EbiTrTimeOut2QQ;
    end
end // p_EbiRePos2Comb

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes for Port3.
// -----------------------------------------------------------------------------
always @(posedge MEMCLK3 or negedge HRESETn)
begin : p_MemClk3Seq
  if (HRESETn == 1'b0)
    begin
      EBIREQ3QQ        <= 1'b0;
      EbiTrAddr3QQ     <= 32'h00000000;
      EbiTrData3QQ     <= 32'h00000000;
      nEbiTrDataEn3QQ  <= 4'b0000;
      EbiTrTimeOut3QQ  <= 10'b0000000000;
    end
  else
    begin
      EBIREQ3QQ        <= D2EBIREQ3Q;
      EbiTrAddr3QQ     <= D2EbiTrAddr3Q;
      EbiTrData3QQ     <= D2EbiTrData3Q;
      nEbiTrDataEn3QQ  <= D2nEbiTrDataEn3Q;
      EbiTrTimeOut3QQ  <= D2EbiTrTimeOut3Q;
    end
end // p_MemClk3Seq

// -----------------------------------------------------------------------------
// Mux to select between clocked or delayed request, address and data lines
// for Port3
// -----------------------------------------------------------------------------
always @(EbiTrCntlPos3 or EBIREQ3QQ or EbiTrAddr3QQ or EbiTrData3QQ or
         nEbiTrDataEn3QQ or EbiTrTimeOut3QQ or EBIREQ3Q or EbiTrAddr3Q or
         EbiTrData3Q or nEbiTrDataEn3Q or EbiTrTimeOut3Q)
begin : p_EbiRePos3Comb
  if (EbiTrCntlPos3 == 1'b0)
     begin
       EBIREQ3         = EBIREQ3Q;
       EbiTrAddr3      = EbiTrAddr3Q;
       EbiTrData3      = EbiTrData3Q;
       nEbiTrDataEn3   = nEbiTrDataEn3Q;
       EbiTrTimeOut3   = EbiTrTimeOut3Q;
     end
 else
   begin
     EBIREQ3         = EBIREQ3QQ;
     EbiTrAddr3      = EbiTrAddr3QQ;
     EbiTrData3      = EbiTrData3QQ;
     nEbiTrDataEn3   = nEbiTrDataEn3QQ;
     EbiTrTimeOut3   = EbiTrTimeOut3QQ;
   end
end // p_EbiRePos3Comb

// -----------------------------------------------------------------------------
// Assign register value to its corresponding port
// -----------------------------------------------------------------------------
assign EBIADDR1         = EbiTrAddr1;
assign EBIADDR2         = EbiTrAddr2;
assign EBIADDR3         = EbiTrAddr3;
assign EBIDATA1         = EbiTrData1;
assign EBIDATA2         = EbiTrData2;
assign EBIDATA3         = EbiTrData3;
assign nEBIDATAEN1      = nEbiTrDataEn1;
assign nEBIDATAEN2      = nEbiTrDataEn2;
assign nEBIDATAEN3      = nEbiTrDataEn3;
assign EBIEXTDATAIN     = EbiTrExtDataIn;
assign EBITIMEOUTVALUE1 = EbiTrTimeOut1;
assign EBITIMEOUTVALUE2 = EbiTrTimeOut2;
assign EBITIMEOUTVALUE3 = EbiTrTimeOut3;

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign EbiTrCntl        = {EventFlag, ClkFlag, EbiTrCntlPos3,
                           EbiTrCntlPos2, EbiTrCntlPos1, EBIREQ3,
                           EBIREQ2, EBIREQ1};
assign EbiTrStatus      = {EBIBACKOFF3, EBIBACKOFF2, EBIBACKOFF1,
                           EBIGNT3, EBIGNT2, EBIGNT1};

endmodule
// --================================== End ==================================--
