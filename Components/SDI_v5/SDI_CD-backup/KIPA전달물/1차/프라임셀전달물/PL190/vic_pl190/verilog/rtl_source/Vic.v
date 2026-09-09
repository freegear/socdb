// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : Vic.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This block is the top level of the VIC.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module Vic (
// Inputs
            HCLK,
            HRESETn,
            HSELVIC,
            HWRITE,
            HREADYIN,
            HPROT,
            HTRANS,
            HSIZE,
            VICINTSOURCE,
            nVICFIQIN,
            nVICIRQIN,
            VICVECTADDRIN,
            SCANENABLE,
            SCANINHCLK,
            HWDATA,
            HADDR,
// Outputs
            HREADYOUT,
            HRESP,
            nVICFIQ,
            nVICIRQ,
            VICVECTADDROUT,
            SCANOUTHCLK,
            HRDATA
           );

// Inputs
input         HCLK;           // AHB Clock
input         HRESETn;        // AHB Reset
input         HSELVIC;        // VIC select
input         HWRITE;         // AHB Write
input         HREADYIN;       // Shared HREADY line
input         HPROT;          // Protection mode
input         HTRANS;         // Bit 1 of HTRANS
input   [2:0] HSIZE;          // AHB transfer size
input  [31:0] VICINTSOURCE;   // Interrupt source
input         nVICFIQIN;      // Fast interrupt input
input         nVICIRQIN;      // Normal interrupt input
input  [31:0] VICVECTADDRIN;  // Vector Address input
input         SCANENABLE;     // Scan Enable
input         SCANINHCLK;     // HCLK domain Scan input
input  [31:0] HWDATA;         // AHB write data bus
input  [11:2] HADDR;          // AHB address bus

// Outputs
output        HREADYOUT;      // VIC ready signal
output  [1:0] HRESP;          // AHB transfer response
output        nVICFIQ;        // Fast Interrupt request
output        nVICIRQ;        // Normal Interrupt request
output [31:0] VICVECTADDROUT; // Vector Address output
output        SCANOUTHCLK;    // HLCK domain Scan output
output [31:0] HRDATA;         // AHB Read data bus

// Inputs
wire          HCLK;           // AHB Clock
wire          HRESETn;        // AHB Reset
wire          HSELVIC;        // VIC select
wire          HWRITE;         // AHB Write
wire          HREADYIN;       // Shared HREADY line
wire          HPROT;          // Protection mode
wire          HTRANS;         // Bit 1 of HTRANS
wire    [2:0] HSIZE;          // AHB transfer size
wire   [31:0] VICINTSOURCE;   // Interrupt source
wire          nVICFIQIN;      // Fast interrupt input
wire          nVICIRQIN;      // Normal interrupt input
wire   [31:0] VICVECTADDRIN;  // Vector Address input
wire          SCANENABLE;     // Scan Enable
wire          SCANINHCLK;     // HCLK domain Scan input
wire   [31:0] HWDATA;         // AHB write data bus
wire   [11:2] HADDR;          // AHB address bus

// Outputs
wire          HREADYOUT;      // VIC ready signal
wire    [1:0] HRESP;          // AHB transfer response
wire          nVICFIQ;        // Fast Interrupt request
wire          nVICIRQ;        // Normal Interrupt request
wire   [31:0] VICVECTADDROUT; // Vector Address output
wire          SCANOUTHCLK;    // HLCK domain Scan output
wire   [31:0] HRDATA;         // AHB Read data bus

// ---------------------------------------------------------------------
//
//                                 Vic
//                                 ===
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//   This block is the top level of the VIC. This block instantiates
// the following functional sub-blocks.
// - VicAhbifReg
// - VicVectBank
// - VicPriority
// - VicSynctoHCLK
// - VicRevAnd
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire  [5:0] VICVectCntl0;
// Vector Control0 register

wire [31:0] VICVectAddr0;
// Vector Address0 register

wire  [5:0] VICVectCntl1;
// Vector Control1 register

wire [31:0] VICVectAddr1;
// Vector Address1 register

wire  [5:0] VICVectCntl2;
// Vector Control2 register

wire [31:0] VICVectAddr2;
// Vector Address2 register

wire  [5:0] VICVectCntl3;
// Vector Control3 register

wire [31:0] VICVectAddr3;
// Vector Address3 register

wire  [5:0] VICVectCntl4;
// Vector Control4 register

wire [31:0] VICVectAddr4;
// Vector Address4 register

wire  [5:0] VICVectCntl5;
// Vector Control5 register

wire [31:0] VICVectAddr5;
// Vector Address5 register

wire  [5:0] VICVectCntl6;
// Vector Control6 register

wire [31:0] VICVectAddr6;
// Vector Address6 register

wire  [5:0] VICVectCntl7;
// Vector Control7 register

wire [31:0] VICVectAddr7;
// Vector Address7 register

wire  [5:0] VICVectCntl8;
// Vector Control8 register

wire [31:0] VICVectAddr8;
// Vector Address8 register

wire  [5:0] VICVectCntl9;
// Vector Control9 register

wire [31:0] VICVectAddr9;
// Vector Address9 register

wire  [5:0] VICVectCntl10;
// Vector Control10 register

wire [31:0] VICVectAddr10;
// Vector Address10 register

wire  [5:0] VICVectCntl11;
// Vector Control11 register

wire [31:0] VICVectAddr11;
// Vector Address11 register

wire  [5:0] VICVectCntl12;
// Vector Control12 register

wire [31:0] VICVectAddr12;
// Vector Address12 register

wire  [5:0] VICVectCntl13;
// Vector Control13 register

wire [31:0] VICVectAddr13;
// Vector Address13 register

wire  [5:0] VICVectCntl14;
// Vector Control14 register

wire [31:0] VICVectAddr14;
// Vector Address14 register

wire  [5:0] VICVectCntl15;
// Vector Control15 register

wire [31:0] VICVectAddr15;
// Vector Address15 register

wire        PriorWrEn;
// Write enable for VectAddr register

wire        PriorRdEn;
// Read enable for VectAddr register

wire        VectCntl0WrCo;
// Write enable for Vector Control0 register

wire        VectAddr0WrCo;
// Write enable for Vector Address0 register

wire        VectCntl1WrCo;
// Write enable for Vector Control1 register

wire        VectAddr1WrCo;
// Write enable for Vector Address1 register

wire        VectCntl2WrCo;
// Write enable for Vector Control2 register

wire        VectAddr2WrCo;
// Write enable for Vector Address2 register

wire        VectCntl3WrCo;
// Write enable for Vector Control3 register

wire        VectAddr3WrCo;
// Write enable for Vector Address3 register

wire        VectCntl4WrCo;
// Write enable for Vector Control4 register

wire        VectAddr4WrCo;
// Write enable for Vector Address4 register

wire        VectCntl5WrCo;
// Write enable for Vector Control5 register

wire        VectAddr5WrCo;
// Write enable for Vector Address5 register

wire        VectCntl6WrCo;
// Write enable for Vector Control6 register

wire        VectAddr6WrCo;
// Write enable for Vector Address6 register

wire        VectCntl7WrCo;
// Write enable for Vector Control7 register

wire        VectAddr7WrCo;
// Write enable for Vector Address7 register

wire        VectCntl8WrCo;
// Write enable for Vector Control8 register

wire        VectAddr8WrCo;
// Write enable for Vector Address8 register

wire        VectCntl9WrCo;
// Write enable for Vector Control9 register

wire        VectAddr9WrCo;
// Write enable for Vector Address9 register

wire        VectCntl10WrCo;
// Write enable for Vector Control10 register

wire        VectAddr10WrCo;
// Write enable for Vector Address10 register

wire        VectCntl11WrCo;
// Write enable for Vector Control11 register

wire        VectAddr11WrCo;
// Write enable for Vector Address11 register

wire        VectCntl12WrCo;
// Write enable for Vector Control12 register

wire        VectAddr12WrCo;
// Write enable for Vector Address12 register

wire        VectCntl13WrCo;
// Write enable for Vector Control13 register

wire        VectAddr13WrCo;
// Write enable for Vector Address13 register

wire        VectCntl14WrCo;
// Write enable for Vector Control14 register

wire        VectAddr14WrCo;
// Write enable for Vector Address14 register

wire        VectCntl15WrCo;
// Write enable for Vector Control15 register

wire        VectAddr15WrCo;
// Write enable for Vector Address15 register

wire        NonVectIrqCo;
// Non-Vectored Interrupt

wire [31:0] VICDefVectAddr;
// Default Vector Address

wire [31:0] VICIRQStatusCo;
// IRQ status

wire [31:0] VICFIQStatusCo;
// FIQ status

wire [31:0] VICRawIntrCo;
// VIC Raw Interrupt

wire [31:0] VICRawIntrSync;
// Synced VICRawIntr

wire [31:0] VICIRQStatusSync;
// Synced VICIRQStatus

wire [31:0] VICFIQStatusSync;
// Synced VICFIQStatus

wire [31:0] HWDataInCo;
// Internal write data bus

wire [15:0] PriorityMaskCo;
// Priority mask

wire        VectIrq0Co;
// Vectored IRQ0 Interrupt

wire        VectIrq1Co;
// Vectored IRQ1 Interrupt

wire        VectIrq2Co;
// Vectored IRQ2 Interrupt

wire        VectIrq3Co;
// Vectored IRQ3 Interrupt

wire        VectIrq4Co;
// Vectored IRQ4 Interrupt

wire        VectIrq5Co;
// Vectored IRQ5 Interrupt

wire        VectIrq6Co;
// Vectored IRQ6 Interrupt

wire        VectIrq7Co;
// Vectored IRQ7 Interrupt

wire        VectIrq8Co;
// Vectored IRQ8 Interrupt

wire        VectIrq9Co;
// Vectored IRQ9 Interrupt

wire        VectIrq10Co;
// Vectored IRQ10 Interrupt

wire        VectIrq11Co;
// Vectored IRQ11 Interrupt

wire        VectIrq12Co;
// Vectored IRQ12 Interrupt

wire        VectIrq13Co;
// Vectored IRQ13 Interrupt

wire        VectIrq14Co;
// Vectored IRQ14 Interrupt

wire        VectIrq15Co;
// Vectored IRQ15 Interrupt

wire        VICIRQCo;
// Vectored IRQ Interrupt

wire  [3:0] TieOff1;
// Input 1 for VicRevAnd

wire  [3:0] TieOff2;
// Input 2 for VicRevAnd

wire  [3:0] Revision;
// Output of VicRevAnd

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Instantiation of VicAhbifReg
// ---------------------------------------------------------------------
VicAhbifReg uVicAhbifReg              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSELVIC          (HSELVIC),
                    .HWRITE           (HWRITE),
                    .HREADYIN         (HREADYIN),
                    .HPROT            (HPROT),
                    .HTRANS           (HTRANS),
                    .HSIZE            (HSIZE),
                    .HWDATA           (HWDATA),
                    .HADDR            (HADDR),
                    .Revision         (Revision),
                    .VICINTSOURCE     (VICINTSOURCE),
                    .nVICFIQIN        (nVICFIQIN),
                    .nVICIRQIN        (nVICIRQIN),
                    .VICIRQCo         (VICIRQCo),
                    .VICVECTADDRIN    (VICVECTADDRIN),
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .VICVectCntl0     (VICVectCntl0),
                    .VICVectAddr0     (VICVectAddr0),
                    .VICVectCntl1     (VICVectCntl1),
                    .VICVectAddr1     (VICVectAddr1),
                    .VICVectCntl2     (VICVectCntl2),
                    .VICVectAddr2     (VICVectAddr2),
                    .VICVectCntl3     (VICVectCntl3),
                    .VICVectAddr3     (VICVectAddr3),
                    .VICVectCntl4     (VICVectCntl4),
                    .VICVectAddr4     (VICVectAddr4),
                    .VICVectCntl5     (VICVectCntl5),
                    .VICVectAddr5     (VICVectAddr5),
                    .VICVectCntl6     (VICVectCntl6),
                    .VICVectAddr6     (VICVectAddr6),
                    .VICVectCntl7     (VICVectCntl7),
                    .VICVectAddr7     (VICVectAddr7),
                    .VICVectCntl8     (VICVectCntl8),
                    .VICVectAddr8     (VICVectAddr8),
                    .VICVectCntl9     (VICVectCntl9),
                    .VICVectAddr9     (VICVectAddr9),
                    .VICVectCntl10    (VICVectCntl10),
                    .VICVectAddr10    (VICVectAddr10),
                    .VICVectCntl11    (VICVectCntl11),
                    .VICVectAddr11    (VICVectAddr11),
                    .VICVectCntl12    (VICVectCntl12),
                    .VICVectAddr12    (VICVectAddr12),
                    .VICVectCntl13    (VICVectCntl13),
                    .VICVectAddr13    (VICVectAddr13),
                    .VICVectCntl14    (VICVectCntl14),
                    .VICVectAddr14    (VICVectAddr14),
                    .VICVectCntl15    (VICVectCntl15),
                    .VICVectAddr15    (VICVectAddr15),
                    .VICRawIntrSync   (VICRawIntrSync),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .VICFIQStatusSync (VICFIQStatusSync),
                    .PriorWrEn        (PriorWrEn),
                    .PriorRdEn        (PriorRdEn),
                    .VectCntl0WrCo    (VectCntl0WrCo),
                    .VectAddr0WrCo    (VectAddr0WrCo),
                    .VectCntl1WrCo    (VectCntl1WrCo),
                    .VectAddr1WrCo    (VectAddr1WrCo),
                    .VectCntl2WrCo    (VectCntl2WrCo),
                    .VectAddr2WrCo    (VectAddr2WrCo),
                    .VectCntl3WrCo    (VectCntl3WrCo),
                    .VectAddr3WrCo    (VectAddr3WrCo),
                    .VectCntl4WrCo    (VectCntl4WrCo),
                    .VectAddr4WrCo    (VectAddr4WrCo),
                    .VectCntl5WrCo    (VectCntl5WrCo),
                    .VectAddr5WrCo    (VectAddr5WrCo),
                    .VectCntl6WrCo    (VectCntl6WrCo),
                    .VectAddr6WrCo    (VectAddr6WrCo),
                    .VectCntl7WrCo    (VectCntl7WrCo),
                    .VectAddr7WrCo    (VectAddr7WrCo),
                    .VectCntl8WrCo    (VectCntl8WrCo),
                    .VectAddr8WrCo    (VectAddr8WrCo),
                    .VectCntl9WrCo    (VectCntl9WrCo),
                    .VectAddr9WrCo    (VectAddr9WrCo),
                    .VectCntl10WrCo   (VectCntl10WrCo),
                    .VectAddr10WrCo   (VectAddr10WrCo),
                    .VectCntl11WrCo   (VectCntl11WrCo),
                    .VectAddr11WrCo   (VectAddr11WrCo),
                    .VectCntl12WrCo   (VectCntl12WrCo),
                    .VectAddr12WrCo   (VectAddr12WrCo),
                    .VectCntl13WrCo   (VectCntl13WrCo),
                    .VectAddr13WrCo   (VectAddr13WrCo),
                    .VectCntl14WrCo   (VectCntl14WrCo),
                    .VectAddr14WrCo   (VectAddr14WrCo),
                    .VectCntl15WrCo   (VectCntl15WrCo),
                    .VectAddr15WrCo   (VectAddr15WrCo),
                    .HREADYOUT        (HREADYOUT),
                    .HRESP            (HRESP),
                    .NonVectIrqCo     (NonVectIrqCo),
                    .VICDefVectAddr   (VICDefVectAddr),
                    .nVICFIQ          (nVICFIQ),
                    .VICIRQStatusCo   (VICIRQStatusCo),
                    .VICFIQStatusCo   (VICFIQStatusCo),
                    .VICRawIntrCo     (VICRawIntrCo),
                    .HRDATA           (HRDATA),
                    .HWDataInCo       (HWDataInCo)
                    );

// ---------------------------------------------------------------------
//  16 Instantiations of VicVectBank
// ---------------------------------------------------------------------
VicVectBank u0VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl0WrCo),
                    .VectAddrWrCo     (VectAddr0WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[0]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq0Co),
                    .VICVectCntl      (VICVectCntl0),
                    .VICVectAddr      (VICVectAddr0)
                    );
 
VicVectBank u1VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl1WrCo),
                    .VectAddrWrCo     (VectAddr1WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[1]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq1Co),
                    .VICVectCntl      (VICVectCntl1),
                    .VICVectAddr      (VICVectAddr1)
                    );

VicVectBank u2VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl2WrCo),
                    .VectAddrWrCo     (VectAddr2WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[2]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq2Co),
                    .VICVectCntl      (VICVectCntl2),
                    .VICVectAddr      (VICVectAddr2)
                    );

VicVectBank u3VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl3WrCo),
                    .VectAddrWrCo     (VectAddr3WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[3]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq3Co),
                    .VICVectCntl      (VICVectCntl3),
                    .VICVectAddr      (VICVectAddr3)
                    );

VicVectBank u4VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl4WrCo),
                    .VectAddrWrCo     (VectAddr4WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[4]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq4Co),
                    .VICVectCntl      (VICVectCntl4),
                    .VICVectAddr      (VICVectAddr4)
                    );

VicVectBank u5VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl5WrCo),
                    .VectAddrWrCo     (VectAddr5WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[5]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq5Co),
                    .VICVectCntl      (VICVectCntl5),
                    .VICVectAddr      (VICVectAddr5)
                    );

VicVectBank u6VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl6WrCo),
                    .VectAddrWrCo     (VectAddr6WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[6]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq6Co),
                    .VICVectCntl      (VICVectCntl6),
                    .VICVectAddr      (VICVectAddr6)
                    );

VicVectBank u7VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl7WrCo),
                    .VectAddrWrCo     (VectAddr7WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[7]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq7Co),
                    .VICVectCntl      (VICVectCntl7),
                    .VICVectAddr      (VICVectAddr7)
                    );

VicVectBank u8VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl8WrCo),
                    .VectAddrWrCo     (VectAddr8WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[8]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq8Co),
                    .VICVectCntl      (VICVectCntl8),
                    .VICVectAddr      (VICVectAddr8)
                    );

VicVectBank u9VicVectBank             (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl9WrCo),
                    .VectAddrWrCo     (VectAddr9WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[9]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq9Co),
                    .VICVectCntl      (VICVectCntl9),
                    .VICVectAddr      (VICVectAddr9)
                    );

VicVectBank u10VicVectBank            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl10WrCo),
                    .VectAddrWrCo     (VectAddr10WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[10]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq10Co),
                    .VICVectCntl      (VICVectCntl10),
                    .VICVectAddr      (VICVectAddr10)
                    );
 
VicVectBank u11VicVectBank            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl11WrCo),
                    .VectAddrWrCo     (VectAddr11WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[11]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq11Co),
                    .VICVectCntl      (VICVectCntl11),
                    .VICVectAddr      (VICVectAddr11)
                    );

VicVectBank u12VicVectBank            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl12WrCo),
                    .VectAddrWrCo     (VectAddr12WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[12]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq12Co),
                    .VICVectCntl      (VICVectCntl12),
                    .VICVectAddr      (VICVectAddr12)
                    );

VicVectBank u13VicVectBank            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl13WrCo),
                    .VectAddrWrCo     (VectAddr13WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[13]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq13Co),
                    .VICVectCntl      (VICVectCntl13),
                    .VICVectAddr      (VICVectAddr13)
                    );

VicVectBank u14VicVectBank            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl14WrCo),
                    .VectAddrWrCo     (VectAddr14WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[14]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq14Co),
                    .VICVectCntl      (VICVectCntl14),
                    .VICVectAddr      (VICVectAddr14)
                    );

VicVectBank u15VicVectBank            (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VectCntlWrCo     (VectCntl15WrCo),
                    .VectAddrWrCo     (VectAddr15WrCo),
                    .PriorityMaskCo   (PriorityMaskCo[15]),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .HWDataInCo       (HWDataInCo),
                    .VectIrqCo        (VectIrq15Co),
                    .VICVectCntl      (VICVectCntl15),
                    .VICVectAddr      (VICVectAddr15)
                    );

// ---------------------------------------------------------------------
// Instantiation of VicSynctoHCLK
// ---------------------------------------------------------------------
VicSynctoHCLK uVicSynctoHCLK          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VICRawIntrCo     (VICRawIntrCo),
                    .VICIRQStatusCo   (VICIRQStatusCo),
                    .VICFIQStatusCo   (VICFIQStatusCo),
                    .VICRawIntrSync   (VICRawIntrSync),
                    .VICIRQStatusSync (VICIRQStatusSync),
                    .VICFIQStatusSync (VICFIQStatusSync)
                    ); 

// ---------------------------------------------------------------------
// Instantiation of VicPriority
// ---------------------------------------------------------------------
VicPriority uVicPriority              (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .PriorWrEn        (PriorWrEn),
                    .PriorRdEn        (PriorRdEn),
                    .NonVectIrqCo     (NonVectIrqCo),
                    .VICDefVectAddr   (VICDefVectAddr),
                    .nVICIRQIN        (nVICIRQIN),
                    .VICVECTADDRIN    (VICVECTADDRIN),
                    .VectIrq0Co       (VectIrq0Co),
                    .VICVectAddr0     (VICVectAddr0),
                    .VectIrq1Co       (VectIrq1Co),
                    .VICVectAddr1     (VICVectAddr1),
                    .VectIrq2Co       (VectIrq2Co),
                    .VICVectAddr2     (VICVectAddr2),
                    .VectIrq3Co       (VectIrq3Co),
                    .VICVectAddr3     (VICVectAddr3),
                    .VectIrq4Co       (VectIrq4Co),
                    .VICVectAddr4     (VICVectAddr4),
                    .VectIrq5Co       (VectIrq5Co),
                    .VICVectAddr5     (VICVectAddr5),
                    .VectIrq6Co       (VectIrq6Co),
                    .VICVectAddr6     (VICVectAddr6),
                    .VectIrq7Co       (VectIrq7Co),
                    .VICVectAddr7     (VICVectAddr7),
                    .VectIrq8Co       (VectIrq8Co),
                    .VICVectAddr8     (VICVectAddr8),
                    .VectIrq9Co       (VectIrq9Co),
                    .VICVectAddr9     (VICVectAddr9),
                    .VectIrq10Co      (VectIrq10Co),
                    .VICVectAddr10    (VICVectAddr10),
                    .VectIrq11Co      (VectIrq11Co),
                    .VICVectAddr11    (VICVectAddr11),
                    .VectIrq12Co      (VectIrq12Co),
                    .VICVectAddr12    (VICVectAddr12),
                    .VectIrq13Co      (VectIrq13Co),
                    .VICVectAddr13    (VICVectAddr13),
                    .VectIrq14Co      (VectIrq14Co),
                    .VICVectAddr14    (VICVectAddr14),
                    .VectIrq15Co      (VectIrq15Co),
                    .VICVectAddr15    (VICVectAddr15),
                    .VICIRQCo         (VICIRQCo),
                    .nVICIRQ          (nVICIRQ),
                    .PriorityMaskCo   (PriorityMaskCo),
                    .VICVECTADDROUT   (VICVECTADDROUT)
                    );

// ---------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 0 of Revision
// ---------------------------------------------------------------------
VicRevAnd u0VicRevAnd                 (
                    .TieOff1          (TieOff1[0]),
                    .TieOff2          (TieOff2[0]),
                    .Revision         (Revision[0])
                    );

// ---------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 1 of Revision
// ---------------------------------------------------------------------
VicRevAnd u1VicRevAnd                 (
                    .TieOff1          (TieOff1[1]),
                    .TieOff2          (TieOff2[1]),
                    .Revision         (Revision[1])
                    );

// ---------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 2 of Revision
// ---------------------------------------------------------------------
VicRevAnd u2VicRevAnd                 (
                    .TieOff1          (TieOff1[2]),
                    .TieOff2          (TieOff2[2]),
                    .Revision         (Revision[2])
                    );

// ---------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 3 of Revision
// ---------------------------------------------------------------------
VicRevAnd u3VicRevAnd                 (
                    .TieOff1          (TieOff1[3]),
                    .TieOff2          (TieOff2[3]),
                    .Revision         (Revision[3])
                    );

// ---------------------------------------------------------------------
// Assign the Revision Number
//
// The Revision Number of the VIC is determined by the values assigned
// to the TieOff1 and TieOff2 signals. A TieOff1 = TieOff2 = 0000 value
// will set the Revision field of the VIC Peripheral ID to 0000. This
// is the default.
//
// If a different Revision number is to be used, change the values
// assigned to the TieOff1 and TieOff2 signals. For example, to
// use a Revision Number of 0001, change TieOff1 and TieOff2 to 0001.
// ---------------------------------------------------------------------
assign TieOff1          = 4'b0000;
assign TieOff2          = 4'b0000;

endmodule

// --============================== End ==============================--
