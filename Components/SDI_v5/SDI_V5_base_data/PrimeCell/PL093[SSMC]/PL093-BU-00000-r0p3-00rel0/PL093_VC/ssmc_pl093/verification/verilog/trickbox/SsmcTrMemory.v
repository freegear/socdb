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
// File Name              : SsmcTrMemory.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//          This module is the SSMC Trick Memory Wrapper box.this
//          instantiat the memory Read Write control and Memory array module.
//          This module is been instantiated in the top level test bench.

// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrMemory (
// Inputs
                    HCLK,
                    HRESETn,
                    HWDATA,
                    LatchHADDR,
                    SMADDR,
                    nSMDATAEN,
                    SSMTrBankCS,
                    nSSMTrBankCS,
                    SSMTrCS,
                    nSSMTrCS,
                    nSMWEN,
                    nSMBLS,
                    nSMOEN,
                    SMCLK,
                    SMADDRVALID,
                    SSMCTrMEMARRAYWr,
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
                    AhbRdDataDW,
                    nSMBURSTWAIT,
                    SMTrIND,
                    SMFBCLK
                   );
parameter Tclk = 10.56;        // HCLK Period

// Inputs
input        HCLK;            // AHB Clock 
input        HRESETn;         // Bus Reset 
input [31:0] HWDATA;          // Write data from AHB 
input [17:0] LatchHADDR;      // Latched AHB Address 
input [25:0] SMADDR;          // Address Bus to Memory 
input  [3:0] nSMDATAEN;       // Memory Bus Enable 
input        SSMTrBankCS;     // Bank select active high 
input        nSSMTrBankCS;    // Bank select active low 
input  [7:0] SSMTrCS;         // The status of all the 8 banks connected
                              // with the SMC active high chip select
input  [7:0] nSSMTrCS;        // The status of all the 8 banks connected
                              // with the SMC active low chip select
input        nSMWEN;          // Write enable 
input  [3:0] nSMBLS;          // Byte lane select 
input        nSMOEN;          // Output enable 
input        SMCLK;           // SSMC clock for synchronous memory operation
input        SMADDRVALID;     // Address valid signal 
input        SSMCTrMEMARRAYWr;// Write enable to memory from AHB Interface
input  [8:0] SSMCTrBurstWt;   // Burst access external delay
input [14:0] SSMCTrMEMBASE;   // Memory base address 
input  [3:0] SMTrBIDCYR;      // Memory Data Bus turn around time
input  [4:0] SMTrBWSTRDR;     // Initial Read acess time 
input  [4:0] SMTrBWSTWRR;     // Write access time 
input  [3:0] SMTrBWSTOENR;    // CS to output enable time 
input  [3:0] SMTrBWSTWENR;    // CS to write enable time 
input  [4:0] SMTrBWSTBRDR;    // Burst read time after initial access
input [21:0] SMTrBCR;         // Bank control parameters
input  [1:0] SMMemClkRatio;   // Clock Ratio 

// Inout
inout [31:0] SMDATA;           // Output data

// Outputs
output [31:0] AhbRdDataDW;     // Read data from AHB Interface
output        nSMBURSTWAIT;    // External Burst wait signal to UUT
output        SMTrIND;         //  Indicates Address limit
output        SMFBCLK;         // Feed back clock



//Inputs
 wire        HCLK;             // AHB Clock  
 wire        HRESETn;          // Bus Reset
 wire [31:0] HWDATA;           // Write data from AHB
 wire [17:0] LatchHADDR;       // Latched AHB Address
 wire [25:0] SMADDR;           // Address Bus to Memory
 wire  [3:0] nSMDATAEN;        // Memory Bus Enable
 wire        SSMTrBankCS;      // Bank select active high
 wire        nSSMTrBankCS;     // Bank select active low
 wire  [7:0] SSMTrCS;          // The status of all the 8 banks connected
                               // with the SMC active high chip select
 wire  [7:0] nSSMTrCS;         // The status of all the 8 banks connected
                               // with the SMC active low chip select
 wire        nSMWEN;           // Write enable
 wire  [3:0] nSMBLS;           // Byte lane select
 wire        nSMOEN;           // Output enable
 wire        SMCLK;            // SSMC clock for synchronous memory operation
 wire        SMADDRVALID;      // Address valid signal
 wire        SSMCTrMEMARRAYWr; // Write enable to memory from AHB Interface
 wire  [8:0] SSMCTrBurstWt;    // Burst access external delay
 wire [14:0] SSMCTrMEMBASE;    // Memory base address
 wire  [3:0] SMTrBIDCYR;       // Memory Data Bus turn around time
 wire  [4:0] SMTrBWSTRDR;      // Initial Read acess time
 wire  [4:0] SMTrBWSTWRR;      // Write access time
 wire  [3:0] SMTrBWSTOENR;     // CS to output enable time
 wire  [3:0] SMTrBWSTWENR;     // CS to write enable time
 wire  [4:0] SMTrBWSTBRDR;     // Burst read time after initial access
 wire [21:0] SMTrBCR;          // Bank control parameters
 wire  [1:0] SMMemClkRatio;    // Clock Ratio 

// Inout
 wire [31:0] SMDATA;

// Outputs
 wire [31:0] AhbRdDataDW;      // Read data from AHB Interface
 wire        nSMBURSTWAIT;     // External Burst wait signal to UUT
 wire        SMTrIND;          //  Indicates Address limit
 wire        SMFBCLK;          // Feed back clock


// -----------------------------------------------------------------------------//
//                             SsmcTrMemory
//                             ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This Block is top Wrapper module.This Block instantiates memory read write
// control sub block and memarray for each bank :
//
// 1. SsmcTrMemRdWrCtl - SSMC Trick memory read write control.
// 2. SsmcTrMemArray   - Memory array.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [3:0] TrnSMBLS;
// Byte Lane Select signal whose value depend on RBLE

wire        RBLE;
// Read Byte Lane Enable signal

wire  [7:0] AhbRdDatab0;
// BYTE0 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab1;
// BYTE1 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab2;
// BYTE2 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab3;
// BYTE3 of 32 bits AHB Read Data

wire  [7:0] MemRdDatab0;
// BYTE0 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab1;
// BYTE1 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab2;
// BYTE2 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab3;
// BYTE3 of 32 bits Memory Read Data

wire  [7:0] MemWrDatab0;
// BYTE0 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab1;
// BYTE1 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab2;
// BYTE2 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab3;
// BYTE3 of 32 bits Memory Write Data

wire [31:0] MemRdDataDW;
// 32 Bits Memory Read Data (Concatenation of MemRdDatab0-3)

wire [10:0] LatchSMADDR;
// Latched Memory Address Bus

wire        iSMFBCLK;
// internal feedback clock

wire  [3:0] inSMBLS;
// Internal version of nSMBLS signal after concidering polarity

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign MemWrDatab0      = SMDATA[7:0];
assign MemWrDatab1      = SMDATA[15:8];
assign MemWrDatab2      = SMDATA[23:16];
assign MemWrDatab3      = SMDATA[31:24];
assign MemRdDataDW      = {MemRdDatab3, MemRdDatab2, MemRdDatab1,
                           MemRdDatab0};
assign AhbRdDataDW      = {AhbRdDatab3, AhbRdDatab2, AhbRdDatab1,
                           AhbRdDatab0};

assign inSMBLS          = (SMTrBCR[6] == 1'b1) ? (~(nSMBLS)) : (nSMBLS);
// -----------------------------------------------------------------------------
// Instantiation of Memroy control logic
// -----------------------------------------------------------------------------
defparam uSsmcTrMemRdWrCtl.Tclk = Tclk;
SsmcTrMemRdWrCtl uSsmcTrMemRdWrCtl  (
                   .HCLK            (HCLK),
                   .HRESETn         (HRESETn),
                   .SMADDR          (SMADDR),
                   .nSMDATAEN       (nSMDATAEN),
                   .SSMTrBankCS     (SSMTrBankCS),
                   .nSSMTrBankCS    (nSSMTrBankCS),
                   .SSMTrCS         (SSMTrCS),
                   .nSSMTrCS        (nSSMTrCS),
                   .nSMWEN          (nSMWEN),
//                   .nSMBLS          (nSMBLS),
                   .nSMBLS          (inSMBLS),
                   .nSMOEN          (nSMOEN),
                   .MemRdDataDW     (MemRdDataDW),
                   .SMCLK           (SMCLK),
                   .SMADDRVALID     (SMADDRVALID),
                   .SSMCTrBurstWt   (SSMCTrBurstWt),
                   .SSMCTrMEMBASE   (SSMCTrMEMBASE),
                   .SMTrBIDCYR      (SMTrBIDCYR),
                   .SMTrBWSTRDR     (SMTrBWSTRDR),
                   .SMTrBWSTWRR     (SMTrBWSTWRR),
                   .SMTrBWSTOENR    (SMTrBWSTOENR),
                   .SMTrBWSTWENR    (SMTrBWSTWENR),
                   .SMTrBWSTBRDR    (SMTrBWSTBRDR),
                   .SMTrBCR         (SMTrBCR),
                   .SMMemClkRatio   (SMMemClkRatio), 

                   .SMDATA          (SMDATA),

                   .LatchSMADDR     (LatchSMADDR),
                   .nSMBURSTWAIT    (nSMBURSTWAIT),
                   .SMFBCLK         (SMFBCLK),
                   .SMTrIND         (SMTrIND),
                   .TrnSMBLS        (TrnSMBLS)       

                   );

// -----------------------------------------------------------------------------
// 4 Memory array instantiation
// -----------------------------------------------------------------------------
defparam u0SsmcTrMemArray.Tclk = Tclk; 
SsmcTrMemArray u0SsmcTrMemArray    (
                  .HCLK            (HCLK),
                  .HRESETn         (HRESETn),
                  .nCS             (nSSMTrBankCS),
                  .nSMBLS          (TrnSMBLS[0]),
                  .SMFBCLK         (SMFBCLK),
                  .SMCLK           (SMCLK),
                  .SSMCTrMEMARRAYWr(SSMCTrMEMARRAYWr),
                  .LatchHADDR      (LatchHADDR[12:2]),
                  .LatchSMADDR     (LatchSMADDR),
                  .HWDATA          (HWDATA[7:0]),
                  .MemWrDatab      (MemWrDatab0),
                  .SMMemClkRatio   (SMMemClkRatio),

                  .AhbRdDatab      (AhbRdDatab0),
                  .MemRdDatab      (MemRdDatab0)
                  );

defparam u1SsmcTrMemArray.Tclk = Tclk; 
SsmcTrMemArray u1SsmcTrMemArray    (
                  .HCLK            (HCLK),
                  .HRESETn         (HRESETn),
                  .nCS             (nSSMTrBankCS),
                  .nSMBLS          (TrnSMBLS[1]),
                  .SMFBCLK         (SMFBCLK),
                  .SMCLK           (SMCLK),
                  .SSMCTrMEMARRAYWr(SSMCTrMEMARRAYWr),
                  .LatchHADDR      (LatchHADDR[12:2]),
                  .LatchSMADDR     (LatchSMADDR),
                  .HWDATA          (HWDATA[15:8]),
                  .MemWrDatab      (MemWrDatab1),
                  .SMMemClkRatio   (SMMemClkRatio),

                  .AhbRdDatab      (AhbRdDatab1),
                  .MemRdDatab      (MemRdDatab1)
                  );

defparam u2SsmcTrMemArray.Tclk = Tclk; 
SsmcTrMemArray u2SsmcTrMemArray    (
                  .HCLK            (HCLK),
                  .HRESETn         (HRESETn),
                  .nCS             (nSSMTrBankCS),
                  .nSMBLS          (TrnSMBLS[2]),
                  .SMFBCLK         (SMFBCLK),
                  .SMCLK           (SMCLK),
                  .SSMCTrMEMARRAYWr(SSMCTrMEMARRAYWr),
                  .LatchHADDR      (LatchHADDR[12:2]),
                  .LatchSMADDR     (LatchSMADDR),
                  .HWDATA          (HWDATA[23:16]),
                  .MemWrDatab      (MemWrDatab2),
                  .SMMemClkRatio   (SMMemClkRatio), 

                  .AhbRdDatab      (AhbRdDatab2),
                  .MemRdDatab      (MemRdDatab2)
                  );

defparam u3SsmcTrMemArray.Tclk = Tclk; 
SsmcTrMemArray u3SsmcTrMemArray    (
                  .HCLK            (HCLK),
                  .HRESETn         (HRESETn),
                  .nCS             (nSSMTrBankCS),
                  .nSMBLS          (TrnSMBLS[3]),
                  .SMFBCLK         (SMFBCLK),
                  .SMCLK           (SMCLK),
                  .SSMCTrMEMARRAYWr(SSMCTrMEMARRAYWr),
                  .LatchHADDR      (LatchHADDR[12:2]),
                  .LatchSMADDR     (LatchSMADDR),
                  .HWDATA          (HWDATA[31:24]),
                  .MemWrDatab      (MemWrDatab3),
                  .SMMemClkRatio   (SMMemClkRatio),

                  .AhbRdDatab      (AhbRdDatab3),
                  .MemRdDatab      (MemRdDatab3)
                  );

endmodule
// --================================== End ==================================--
