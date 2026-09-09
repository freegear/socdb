// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name             : Interrupt.v,v
// File Revision         : 1.4
//
// Release Information   : ADK_REL1v1
//
// ---------------------------------------------------------------------
// Purpose : This block is the top level of the AHB Interrupt Controller
//
// --=================================================================--
//
//                                Interrupt
//                                =========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
// This block is the top level of the IC. This block instantiates
// the following functional sub-blocks.
// - ICAhbifReg
// - ICVectBank
// - ICPriority
// - ICSynctoHCLK
// - RevAnd
//

`timescale 1ns/1ps

module Interrupt (
// Inputs
    HCLK,          // AHB Clock
    HRESETn,       // AHB Reset
    HSELIC,        // Interrupt Controller select
    HWRITE,        // AHB Write
    HREADY,        // Shared HREADY line
    HPROT,         // Protection mode
    HTRANS,        // Bit 1 of HTRANS
    HSIZE,         // AHB transfer size
    ICINTSOURCE,   // Interrupt source
    nICFIQIN,      // Fast interrupt input
    nICIRQIN,      // Normal interrupt input
    ICVECTADDRIN,  // Vector Address input
    SCANENABLE,    // Scan Enable
    SCANINHCLK,    // HCLK domain Scan input
    HWDATA,        // AHB write data bus
    HADDR,         // AHB address bus
// Outputs
    HREADYOUT,     // IC ready signal
    HRESP,         // AHB transfer response
    nICFIQ,        // Fast Interrupt request
    nICIRQ,        // Normal Interrupt request
    ICVECTADDROUT, // Vector Address output
    SCANOUTHCLK,   // HLCK domain Scan output
    HRDATA);       // AHB Read data bus

  input         HCLK;
  input         HRESETn;
  input         HSELIC;
  input         HWRITE;
  input         HREADY;
  input         HPROT;
  input         HTRANS;
  input [2:0]   HSIZE;
  input [31:0]  ICINTSOURCE;
  input         nICFIQIN;
  input         nICIRQIN;
  input [31:0]  ICVECTADDRIN;
  input         SCANENABLE;
  input         SCANINHCLK;
  input [31:0]  HWDATA;
  input [11:2]  HADDR;

  output        HREADYOUT;
  output [1:0]  HRESP;
  output        nICFIQ;
  output        nICIRQ;
  output [31:0] ICVECTADDROUT;
  output        SCANOUTHCLK;
  output [31:0] HRDATA;

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------

// Input/Output Signals
  wire         HCLK;
  wire         HRESETn;
  wire         HSELIC;
  wire         HWRITE;
  wire         HREADY;
  wire         HPROT;
  wire         HTRANS;
  wire [2:0]   HSIZE;
  wire [31:0]  ICINTSOURCE;
  wire         nICFIQIN;
  wire         nICIRQIN;
  wire [31:0]  ICVECTADDRIN;
  wire         SCANENABLE;
  wire         SCANINHCLK;
  wire [31:0]  HWDATA;
  wire [11:2]  HADDR;
  wire         HREADYOUT;
  wire [1:0]   HRESP;
  wire         nICFIQ;
  wire         nICIRQ;
  wire [31:0]  ICVECTADDROUT;
  wire         SCANOUTHCLK;
  wire [31:0]  HRDATA;

// Internal Signals
  wire         PriorWrEnCo;      // Write enable for VectAddr register
  wire         PriorRdEn;        // Read enable for VectAddr register
  wire         NonVectIrqCo;     // Non-Vectored Interrupt
  wire [31:0]  ICVECTADDROUTCo;  // Vector Address output from ICPriority
  wire [31:0]  ICDefVectAddr;    // Default Vector Address
  wire [31:0]  ICIRQStatusCo;    // IRQ status
  wire [31:0]  ICFIQStatusCo;    // FIQ status
  wire [31:0]  ICRawIntrCo;      // IC Raw Interrupt
  wire [31:0]  ICRawIntrSync;    // Synced ICRawIntr
  wire [31:0]  ICIRQStatusSync;  // Synced ICIRQStatus
  wire [31:0]  ICFIQStatusSync;  // Synced ICFIQStatus
  wire         ICIRQCo;          // Vectored IRQ Interrupt
  wire [3:0]   TieOff1;          // Input 1 for RevAnd
  wire [3:0]   TieOff2;          // Input 2 for RevAnd
  wire [3:0]   Revision;         // Output of RevAnd

// ---------------------------------------------------------------------
// Instantiation of ICAhbifReg
// ---------------------------------------------------------------------
     ICAhbifReg uICAhbifReg
       (.HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HSELIC          (HSELIC),
        .HWRITE          (HWRITE),
        .HREADY          (HREADY),
        .HPROT           (HPROT),
        .HTRANS          (HTRANS),
        .HSIZE           (HSIZE),
        .HWDATA          (HWDATA),
        .HADDR           (HADDR),
        .Revision        (Revision),
        .ICINTSOURCE     (ICINTSOURCE),
        .nICFIQIN        (nICFIQIN),
        .nICIRQIN        (nICIRQIN),
        .ICIRQCo         (ICIRQCo),
        .ICVECTADDRIN    (ICVECTADDRIN),
        .ICVECTADDROUTCo (ICVECTADDROUTCo),
        .ICRawIntrSync   (ICRawIntrSync),
        .ICIRQStatusSync (ICIRQStatusSync),
        .ICFIQStatusSync (ICFIQStatusSync),
        .PriorWrEnCo     (PriorWrEnCo),
        .PriorRdEn       (PriorRdEn),
        .HREADYOUT       (HREADYOUT),
        .HRESP           (HRESP),
        .NonVectIrqCo    (NonVectIrqCo),
        .ICDefVectAddr   (ICDefVectAddr),
        .nICFIQ          (nICFIQ),
        .ICIRQStatusCo   (ICIRQStatusCo),
        .ICFIQStatusCo   (ICFIQStatusCo),
        .ICRawIntrCo     (ICRawIntrCo),
        .HRDATA          (HRDATA)
        );

// ---------------------------------------------------------------------
// Instantiation of IntSynctoHCLK
// ---------------------------------------------------------------------
  ICSynctoHCLK  uICSynctoHCLK
    (.HCLK            (HCLK),
     .HRESETn         (HRESETn),
     .ICRawIntrCo     (ICRawIntrCo),
     .ICIRQStatusCo   (ICIRQStatusCo),
     .ICFIQStatusCo   (ICFIQStatusCo),
     .ICRawIntrSync   (ICRawIntrSync),
     .ICIRQStatusSync (ICIRQStatusSync),
     .ICFIQStatusSync (ICFIQStatusSync)
     );

// ---------------------------------------------------------------------
// Instantiation of IntPriority
// ---------------------------------------------------------------------
  ICPriority  uICPriority
    (.HCLK            (HCLK),
     .HRESETn         (HRESETn),
     .PriorWrEnCo     (PriorWrEnCo),
     .PriorRdEn       (PriorRdEn),
     .NonVectIrqCo    (NonVectIrqCo),
     .ICDefVectAddr   (ICDefVectAddr),
     .nICIRQIN        (nICIRQIN),
     .ICVECTADDRIN    (ICVECTADDRIN),
     .ICIRQCo         (ICIRQCo),
     .nICIRQ          (nICIRQ),
     .ICVECTADDROUTCo (ICVECTADDROUTCo)
     );

// ---------------------------------------------------------------------
// Instantiation of RevAnd for bit 0 of Revision
// ---------------------------------------------------------------------
  RevAnd  u0RevAnd
    (.TieOff1  (TieOff1[0]),
     .TieOff2  (TieOff2[0]),
     .Revision (Revision[0])
     );

// ---------------------------------------------------------------------
// Instantiation of RevAnd for bit 1 of Revision
// ---------------------------------------------------------------------
  RevAnd  u1RevAnd
    (.TieOff1  (TieOff1[1]),
     .TieOff2  (TieOff2[1]),
     .Revision (Revision[1])
     );

// ---------------------------------------------------------------------
// Instantiation of RevAnd for bit 2 of Revision
// ---------------------------------------------------------------------
  RevAnd  u2RevAnd
    (.TieOff1  (TieOff1[2]),
     .TieOff2  (TieOff2[2]),
     .Revision (Revision[2])
     );

// ---------------------------------------------------------------------
// Instantiation of RevAnd for bit 3 of Revision
// ---------------------------------------------------------------------
  RevAnd  u3RevAnd
    (.TieOff1  (TieOff1[3]),
     .TieOff2  (TieOff2[3]),
     .Revision (Revision[3])
     );

// ---------------------------------------------------------------------
// Assign the Revision Number
//
// The Revision Number of the Interrupt Controller is determined by the
// values assigned to the TieOff1 and TieOff2 signals.
// A TieOff1 = TieOff2 = 0000 value will set the Revision field of the
// Peripheral ID to 0000. This is the default.
//
// If a different Revision number is to be used, change the values
// assigned to the TieOff1 and TieOff2 signals. For example, to
// use a Revision Number of 0001, change TieOff1 and TieOff2 to 0001.
// ---------------------------------------------------------------------

  assign TieOff1 = 4'b0000;
  assign TieOff2 = 4'b0000;

// ---------------------------------------------------------------------
// Assign internal copies of signals to output ports
// ---------------------------------------------------------------------
  assign ICVECTADDROUT = ICVECTADDROUTCo;

endmodule
