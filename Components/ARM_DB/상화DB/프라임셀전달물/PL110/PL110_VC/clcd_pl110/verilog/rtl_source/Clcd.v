// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : Clcd.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose : Wrapper for Colour LCD Controller
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
//  ----------------------------------------------------------------------------

module Clcd (
        HCLK,
        CLCDCLK,
        nCLCDCLK,
        HRESETn,
        nCLCLKRESET,
        HSELCLCD,
        HTRANSS,
        HWRITES,
        HREADYINS,
        HRESPM,
        HREADYINM,
        HGRANTM,
        HADDRS,
        HWDATAS,
        HRDATAM,
        SCANENABLE,
        SCANINHCLK,
        SCANINCLCDCLK,
        SCANINnCLCDCLK,
        
        HRESPS,
        HREADYOUTS,
        HTRANSM,
        HWRITEM,
        HSIZEM,
        HBURSTM,
        HBUSREQM,
        HPROT,
        HLOCK,
        CLCDCLKSEL,
        HADDRM,
        HRDATAS,
        CLCDMBEINTR,
        CLCDFUFINTR,
        CLCDLNBUINTR,
        CLCDVCOMPINTR,
        CLCDINTR,
        CLPOWER,
        CLLP,
        CLCP,
        CLFP,
        CLAC,
        CLLE,
        CLD,
        SCANOUTHCLK,
        SCANOUTCLCDCLK,
        SCANOUTnCLCDCLK
            );

input           HCLK;            // AHB Clock
input           CLCDCLK;         // LCD Controller Clock input 
input           nCLCDCLK;        // Inverted Lcd clock input
input           HRESETn;         // AHB Bus Reset signal - HCLK domain
input           nCLCLKRESET;     // Reset signal - LCLK domain
input           HSELCLCD;        // device select signal
input   [1:0]   HTRANSS;         // Transfer response signal for AHB Slave
input           HWRITES;         // Write signal for AHB Slave
input           HREADYINS;       // Ready signal for AHB Slave
input   [1:0]   HRESPM;          // Slave response for AHB master
input           HREADYINM;       // Ready signal for AHB Master
input           HGRANTM;         // Bus grant signal from arbiter for AHB master
input   [11:2]  HADDRS;          // Address bus for AHB slave
input   [31:0]  HWDATAS;         // Write data input for AHB Slave
input   [31:0]  HRDATAM;         // Read data input for AHB Master
input           SCANENABLE;      // Scan Enable
input           SCANINHCLK;      // Scan Input signal in HCLK domain
input           SCANINCLCDCLK;   // Scan Input signal in CLCDCLK domain
input           SCANINnCLCDCLK;  // Scan Input signal in nCLCDCLK domain

output  [1:0]   HRESPS;          // Slave response from AHB Slave
output          HREADYOUTS;      // Ready signal from AHB Slave
output  [1:0]   HTRANSM;         // Transfer response signal from AHB Master
output          HWRITEM;         // Write signal from AHB master
output  [2:0]   HSIZEM;          // Size of the data transfer from AHB Master
output  [2:0]   HBURSTM;         // size of the burst from AHB Master
output          HBUSREQM;        // Bus request from AHB master
output  [3:0]   HPROT;           // Protection signal from AHB Master
output          HLOCK;           // Bus-lock signal from AHB Master
output          CLCDCLKSEL;      // LCLK Clock source select to Clock Mux
output  [31:0]  HADDRM;          // Address from AHB Master
output  [31:0]  HRDATAS;         // Read out data from AHB Slave
output          CLCDMBEINTR;     // AHB Error interrupt
output          CLCDFUFINTR;     // LCD lower FIFO underflow interrupt
output          CLCDLNBUINTR;    // LCD next base update interrupt
output          CLCDVCOMPINTR;   // LCD Vertical compare status interrupt
output          CLCDINTR;        // combined interrupt of all interrupts
output          CLPOWER;         // LCD panel power enable
output          CLLP;            // LCD Line pulse(STN)/Hsync pulse(TFT)
output          CLCP;            // LCD Panel clock
output          CLFP;            // LCD Frame pulse(STN)/Vsync pulse(TFT)
output          CLAC;            // LCD panel AC bias(STN)/ Data enable(TFT)
output          CLLE;            // Line end signal
output  [23:0]  CLD;             // LCD panel data out
output          SCANOUTHCLK;     // SCANOUT port in HCLK domain
output          SCANOUTCLCDCLK;  // SCANOUT port in CLCDCLK domain
output          SCANOUTnCLCDCLK; // SCANOUTnCLCDCLK : out std_logic

// -----------------------------------------------------------------------------
//
// Overview
// ========
//            It instantiates
//          1. Colour LCD Controller logic.
//          2. Palette RAM.
//          3. Integration Test logic
//          4. Device Revision 
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire            HCLK;           
// AHB Clock input                                         (Module Input)

wire            CLCDCLK;        
// LCD Controller Clock input                              (Module Input)

wire            nCLCDCLK;        
// LCD Controller Clock input                              (Module Input)

wire            HRESETn;        
// AHB Bus Reset signal - HCLK domain                      (Module Input)

wire            nCLCLKRESET;    
// Reset signal - LCLK domain                              (Module Input)

wire            HSELCLCD;       
// device select signal                                    (Module Input)

wire    [1:0]   HTRANSS;        
// Transfer response signal for AHB Slave                  (Module Input)

wire            HWRITES;        
// Write signal for AHB Slave                              (Module Input)

wire            HREADYINS;      
// Ready signal for AHB Slave                              (Module Input)

wire    [1:0]   HRESPM;         
// Slave response for AHB master                           (Module Input)

wire            HREADYINM;      
// Ready signal for AHB Master                             (Module Input)

wire            HGRANTM;        
// Bus grant signal from arbiter for AHB master            (Module Input)

wire    [11:2]  HADDRS;         
// Address bus for AHB slave                               (Module Input)

wire    [31:0]  HWDATAS;        
// Write data input for AHB Slave                          (Module Input)

wire    [31:0]  HRDATAM;        
// Read data input for AHB Master                          (Module Input)

wire    [6:0]   PalAHBAddr;
// Palette RAM address - Port1(AHB side)

wire    [6:0]   PalLcdAddr;
// Palette RAM address - Port2(Lcd side)

wire            PalAHBWriteBn;
// Palette RAM write enable - Port1(AHB side)

wire            PalLcdCSB2;
// Palette RAM chip select - Port2(Lcd side)

wire    [31:0]  PalAHBRData;
// Palette RAM Read data - Port1(AHB side)

wire    [31:0]  PalLcdRData;
// Palette RAM Read data - Port2(AHB side)

wire CLCDCLKSELint;
// Internal version of CLCDCLKSEL

wire CLCDMBEINTRint;
// Internal version of CLCDMBEINTR

wire CLCDFUFINTRint;
// Internal version of CLCDFUFINTR

wire CLCDLNBUINTRint;
// Internal version of CLCDLNBUINTR

wire CLCDVCOMPINTRint;
// Internal version of CLCDVCOMPINTR

wire CLCDINTRint;
// Internal version of CLCDINTR

wire CLPOWERint;
// Internal version of CLPOWER

wire CLLPint;
// Internal version of CLLP

wire CLCPint;
// Internal version of CLCP

wire CLFPint;
// Internal version of CLFP

wire CLACint;
// Internal version of CLAC

wire CLLEint;
// Internal version of CLLE

wire [23:0] CLDint;
// Internal version of CLD[23:0)

wire iCLCDCLKSEL;
// Local copy of CLCDCLKSEL

wire CLCDTCRWr;
// CLCD Test Control Register Write enable

wire CLCDITOP1Wr;
// CLCD Integration Test Output register 1 Write enable 

wire CLCDITOP2Wr;
// CLCD Integration Test Output register 2 Write enable

wire ITEN;
// Integration test enable

wire [5:0] IntraOP;
// Intra chip outputs read bus alias

wire [29:0] PrimaryOP;
// Primary outputs read bus alias

wire LCDTCRWen;
// Test control register write enable

wire LCDITOP1Wen;
// Integration Test Output register 1 write enable

wire LCDITOP2Wen;
// Integration Test Output register 2 write enable

wire  [3:0] TieOff1;
// Revision designator input

wire  [3:0] TieOff2;
// Revision designator input

wire  [3:0] Revision;
// Revision designator output


  // Define Intra-chip output signals bus for AHB reads
  assign IntraOP = {CLCDCLKSEL, CLCDMBEINTR, CLCDFUFINTR,
                    CLCDLNBUINTR, CLCDVCOMPINTR, CLCDINTR};

  // Define Primary output signals bus for AHB reads
  assign PrimaryOP = {CLPOWER, CLLP, CLCP, CLFP, CLAC, CLLE, CLD};

// -----------------------------------------------------------------------------
// Lcd Controller module instantiation
// -----------------------------------------------------------------------------
ClcdCntl uClcdCntl(
                     .HCLK             (HCLK),
                     .CLCDCLK          (CLCDCLK),
                     .nCLCDCLK         (nCLCDCLK),
                     .HRESETn          (HRESETn),
                     .nCLCLKRESET      (nCLCLKRESET),
                     .HSELCLCD         (HSELCLCD),
                     .HADDRS           (HADDRS),
                     .HTRANSS          (HTRANSS),
                     .HWRITES          (HWRITES),
                     .HREADYINS        (HREADYINS),
                     .HWDATAS          (HWDATAS),
                     .HREADYINM        (HREADYINM),
                     .HRESPM           (HRESPM),
                     .HGRANTM          (HGRANTM),
                     .HRDATAM          (HRDATAM),
                     .PalAHBRData      (PalAHBRData),
                     .PalLcdRData      (PalLcdRData),
                     .ITEN             (ITEN),
                     .IntraOP          (IntraOP),
                     .PrimaryOP        (PrimaryOP),
                     .Revision         (Revision),

                     .HTRANSM          (HTRANSM),
                     .HWRITEM          (HWRITEM),
                     .HSIZEM           (HSIZEM),
                     .HBURSTM          (HBURSTM),
                     .HADDRM           (HADDRM),
                     .HPROT            (HPROT),
                     .HLOCK            (HLOCK),
                     .HRESPS           (HRESPS),
                     .HBUSREQM         (HBUSREQM),
                     .HREADYOUTS       (HREADYOUTS),
                     .CLCDCLKSELint    (CLCDCLKSELint),
                     .HRDATAS          (HRDATAS),
                     .PalAHBWriteBn    (PalAHBWriteBn),
                     .PalAHBAddr       (PalAHBAddr),
                     .PalLcdAddr       (PalLcdAddr),
                     .PalLcdCSB2       (PalLcdCSB2),
                     .CLPOWERint       (CLPOWERint),
                     .CLLPint          (CLLPint),
                     .CLCPint          (CLCPint),
                     .CLFPint          (CLFPint),
                     .CLACint          (CLACint),
                     .CLDint           (CLDint),
                     .CLLEint          (CLLEint),
                     .CLCDMBEINTRint   (CLCDMBEINTRint),
                     .CLCDFUFINTRint   (CLCDFUFINTRint),
                     .CLCDLNBUINTRint  (CLCDLNBUINTRint),
                     .CLCDVCOMPINTRint (CLCDVCOMPINTRint),
                     .CLCDINTRint      (CLCDINTRint),
                     .LCDTCRWen        (LCDTCRWen),
                     .LCDITOP1Wen      (LCDITOP1Wen),
                     .LCDITOP2Wen      (LCDITOP2Wen)
                  );

  ClcdTest uClcdTest (
       .HCLK               (HCLK),
       .HRESETn            (HRESETn),
       .HWDATAS            (HWDATAS[29:0]),
       .CLCDCLKSELint      (CLCDCLKSELint),
       .CLCDMBEINTRint     (CLCDMBEINTRint),
       .CLCDFUFINTRint     (CLCDFUFINTRint),
       .CLCDLNBUINTRint    (CLCDLNBUINTRint),
       .CLCDVCOMPINTRint   (CLCDVCOMPINTRint),
       .CLCDINTRint        (CLCDINTRint),
       .CLPOWERint         (CLPOWERint),
       .CLLPint            (CLLPint),
       .CLCPint            (CLCPint),
       .CLFPint            (CLFPint),
       .CLACint            (CLACint),
       .CLLEint            (CLLEint),
       .CLDint             (CLDint),
       .LCDTCRWen          (LCDTCRWen),
       .LCDITOP1Wen        (LCDITOP1Wen),
       .LCDITOP2Wen        (LCDITOP2Wen),

       .ITEN               (ITEN),
       .CLCDCLKSEL         (CLCDCLKSEL),
       .CLCDMBEINTR        (CLCDMBEINTR),
       .CLCDFUFINTR        (CLCDFUFINTR),
       .CLCDLNBUINTR       (CLCDLNBUINTR),
       .CLCDVCOMPINTR      (CLCDVCOMPINTR),
       .CLCDINTR           (CLCDINTR),
       .CLPOWER            (CLPOWER),
       .CLLP               (CLLP),
       .CLCP               (CLCP),
       .CLFP               (CLFP),
       .CLAC               (CLAC),
       .CLLE               (CLLE),
       .CLD                (CLD)
    );

// -----------------------------------------------------------------------------
// Synchronous Dual Port RAM - Palette instantiation
// -----------------------------------------------------------------------------

 dpram128x32 uLCDPalette (
                    .A1   (PalAHBAddr),
                    .A2   (PalLcdAddr),
                    .CE1  (HCLK),
                    .CE2  (CLCDCLK),
                    .WEB1 (PalAHBWriteBn),
                    .WEB2 (1'b1),
                    .OEB1 (1'b0),
                    .OEB2 (1'b0),
                    .CSB1 (1'b0),
                    .CSB2 (PalLcdCSB2),
                    .I1   (HWDATAS),
                    .I2   (32'h0000_0000),

                    .O1   (PalAHBRData),
                    .O2   (PalLcdRData)
                 );


// Instantiate Device Revision
assign TieOff1      = 4'b0010;
assign TieOff2      = 4'b1111;

// ---------------------------------------------------------------------
// 1st instantiation of ClcdRevAnd
// ---------------------------------------------------------------------
  ClcdRevAnd  u0ClcdRevAnd (

            .TieOff1  (TieOff1[0]),
            .TieOff2  (TieOff2[0]),

            .Revision (Revision[0])
    );

// ---------------------------------------------------------------------
// 2nd instantiation of ClcdRevAnd
// ---------------------------------------------------------------------
  ClcdRevAnd  u1ClcdRevAnd (

            .TieOff1 (TieOff1[1]),
            .TieOff2 (TieOff2[1]),

            .Revision (Revision[1])
    );

// ---------------------------------------------------------------------
// 3rd instantiation of ClcdRevAnd
// ---------------------------------------------------------------------
  ClcdRevAnd  u2ClcdRevAnd (

            .TieOff1  (TieOff1[2]),
            .TieOff2  (TieOff2[2]),

            .Revision (Revision[2])
    );
    
// ---------------------------------------------------------------------
// 4th instantiation of ClcdRevAnd
// ---------------------------------------------------------------------
  ClcdRevAnd  u3ClcdRevAnd (

            .TieOff1  (TieOff1[3]),
            .TieOff2  (TieOff2[3]),

            .Revision (Revision[3])
    );endmodule
// --================================== End ==================================--


