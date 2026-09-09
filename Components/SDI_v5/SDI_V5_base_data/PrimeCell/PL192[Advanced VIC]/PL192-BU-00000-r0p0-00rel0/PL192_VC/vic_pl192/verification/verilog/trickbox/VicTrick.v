// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicTrick.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Top level of the VIC Trickbox.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrick (
// Inputs
                 HCLK,
                 HRESETn,
                 HREADYIN,
                 HADDR,
                 HTRANS,
                 HSIZE,
                 HWRITE,
                 HPROT,
                 HWDATA,
                 HSELVICTR,
                 HSELVIC,
                 nVICFIQ,
                 nVICIRQ,
                 VICVECTADDROUT,
                 VICVECTADDRV,
                 VICIRQACKOUT,

// Outputs
                 HCLKTRICK,
                 HRDATA,
                 HREADYOUT,
                 HRESP,
                 VICINTSOURCE,
                 VICSYNCEN,
                 VICIRQACK,
                 VICVECTADDRIN,
                 nVICFIQIN,
                 nVICIRQIN,
                 VICFIQINREG,
                 VICIRQINREG
                );

parameter Tclk = 10;

// Inputs
input         HCLK;           // AHB Clock
input         HRESETn;        // AHB Reset
input         HREADYIN;       // Transfer Ready Signal
input  [11:2] HADDR;          // Address Bus for AHB Slave
input         HTRANS;         // Transfer signal for AHB Slave
input   [2:0] HSIZE;          // AHB Transfer size
input         HWRITE;         // Write Signal for AHB Slave
input         HPROT;          // Protection Control signal
input  [31:0] HWDATA;         // Write Data input for AHB Slave
input         HSELVICTR;      // Slave Select Signal for
                              // the VIC Trickbox
input         HSELVIC;        // Slave Select Signal for the VIC
input         nVICFIQ;        // nVICFIQ output from the VIC
input         nVICIRQ;        // nVICIRQ output from the VIC
input  [31:0] VICVECTADDROUT; // VICVECTADDROUT output from the VIC
input         VICVECTADDRV;   // VIC Address valid Signal which indicates
                              // Address valid
input         VICIRQACKOUT;   // VIC Acknowledge signal 

// Outputs
output        HCLKTRICK;      // Clock to UUT and mirrored trickbox.
                              // If bit 5 in VICTrTCR is set the is
                              // turned off
output [31:0] HRDATA;         // Read Data output from AHB Slave
output        HREADYOUT;      // Ready Signal from AHB Slave
output  [1:0] HRESP;          // Transfer Response from AHB Slave
output [31:0] VICINTSOURCE;   // Output lines for raising
                              // Interrupt requests to the VIC
output        VICSYNCEN;      // VIC Synchronization enable 
output        VICIRQACK;      // Acknowledge signal to the VIC 
output [31:0] VICVECTADDRIN;  // VICVECTADDRIN Daisy chain Vector
                              // address signal to the VIC
output        nVICFIQIN;      // nVICFIQIN Daisy chain
                              // signal to the VIC
output        nVICIRQIN;      // nVICIRQIN Daisy chain
                              // signal to the VIC
output        VICFIQINREG;    // Daisy Chain Fiq Interrupt signal to VIC 
output        VICIRQINREG;    // Daisy Chain Fiq Interrupt signal to VIC 

// Inputs
wire         HCLK;            // AHB Clock
wire         HRESETn;         // AHB Reset
wire         HREADYIN;        // Transfer Ready Signal
wire  [11:2] HADDR;           // Address Bus for AHB Slave
wire         HTRANS;          // Transfer signal for AHB Slave
wire   [2:0] HSIZE;           // AHB Transfer size
wire         HWRITE;          // Write Signal for AHB Slave
wire         HPROT;           // Protection Control signal
wire  [31:0] HWDATA;          // Write Data input for AHB Slave
wire         HSELVICTR;       // Slave Select Signal for
                              // the VIC Trickbox
wire         HSELVIC;         // Slave Select Signal for the VIC
wire         nVICFIQ;         // nVICFIQ output from the VIC
wire         nVICIRQ;         // nVICIRQ output from the VIC
wire  [31:0] VICVECTADDROUT;  // VICVECTADDROUT output from the VIC
wire         VICVECTADDRV;    // VIC Address valid Signal which indicates
                              // Address valid
wire         VICIRQACKOUT;    // VIC Acknowledge signal 
 
// Outputs
wire        HCLKTRICK;        // Clock to UUT and mirrored trickbox.
                              // If bit 5 in VICTrTCR is set the is
                              // turned off
wire [31:0] HRDATA;           // Read Data output from AHB Slave
wire        HREADYOUT;        // Ready Signal from AHB Slave
wire  [1:0] HRESP;            // Transfer Response from AHB Slave
wire [31:0] VICINTSOURCE;     // Output lines for raising
                              // Interrupt requests to the VIC
wire        VICSYNCEN;        // VIC Synchronization enable 
wire        VICIRQACK;        // Acknowledge signal to the VIC 
wire [31:0] VICVECTADDRIN;    // VICVECTADDRIN Daisy chain Vector
                              // address signal to the VIC
wire        nVICFIQIN;        // nVICFIQIN Daisy chain
                              // signal to the VIC
wire        nVICIRQIN;        // nVICIRQIN Daisy chain
                              // signal to the VIC
wire        VICFIQINREG;      // Daisy Chain Fiq Interrupt signal to VIC 
wire        VICIRQINREG;      // Daisy Chain Fiq Interrupt signal to VIC 

// -----------------------------------------------------------------------------
//
//                              VicTrick
//                              ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the VIC Trickbox. This block
// instantiates the following sub-blocks:
//
// 1. VicTrAhbif
// 2. VicMirTrickbox
//    1. VicTrIntReqLog
//    2. VicTrFiqIntrLog
//    3. VicTrIrqIntrLog
//    4. VicTrIrqPriLog        
// 3. VicTrProtChkr
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
 
//------------------------------------------------------------------------------
// Timing Parameters of Trickbox
//------------------------------------------------------------------------------
`define tovmaxintsrc     (0.05 * Tclk)
// VICINTSOURCE valid time (max) after HCLK rising edge
 
`define tovmaxnvicfiqin  (0.2 * Tclk)
// nVICFIQIN valid time (max) after HCLK rising edge
 
`define tovmaxnvicirqin  (0.2 * Tclk)
// nVICIRQIN valid time (max) after HCLK rising edge
 
`define tovmaxvectadin   (0.2 * Tclk)
// VICVECTADDRIN valid time (max) after HCLK rising edge
 
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [31:0] VICTrSoftInt;
// SoftInt register
 
wire [31:0] VICTrIntEnable;
// IntEnable register
 
wire [31:0] VICTrIntSelect;
// IntSelect register
 
wire [15:0] VICTrSwPriMask;
// Software Priority Mask register
 
wire  [3:0] VICTrVectPriDsy;
// Priority Programmable register for Daisy chain Irq Interrupt

wire  [3:0] VICTrVectPrity0;  
// Priority Programmable register0

wire  [3:0] VICTrVectPrity1;  
// Priority Programmable register1

wire  [3:0] VICTrVectPrity2;  
// Priority Programmable register2

wire  [3:0] VICTrVectPrity3;  
// Priority Programmable register3

wire  [3:0] VICTrVectPrity4;  
// Priority Programmable register4

wire  [3:0] VICTrVectPrity5;  
// Priority Programmable register5

wire  [3:0] VICTrVectPrity6;  
// Priority Programmable register6

wire  [3:0] VICTrVectPrity7;  
// Priority Programmable register7

wire  [3:0] VICTrVectPrity8;  
// Priority Programmable register8

wire  [3:0] VICTrVectPrity9;  
// Priority Programmable register9

wire  [3:0] VICTrVectPrity10; 
// Priority Programmable register10

wire  [3:0] VICTrVectPrity11;
// Priority Programmable register11

wire  [3:0] VICTrVectPrity12;
// Priority Programmable register12

wire  [3:0] VICTrVectPrity13;
// Priority Programmable register13

wire  [3:0] VICTrVectPrity14;
// Priority Programmable register14

wire  [3:0] VICTrVectPrity15; 
// Priority Programmable register15

wire  [3:0] VICTrVectPrity16;
// Priority Programmable register16

wire  [3:0] VICTrVectPrity17; 
// Priority Programmable register17

wire  [3:0] VICTrVectPrity18; 
// Priority Programmable register18

wire  [3:0] VICTrVectPrity19; 
// Priority Programmable register19

wire  [3:0] VICTrVectPrity20; 
// Priority Programmable register20

wire  [3:0] VICTrVectPrity21; 
// Priority Programmable register21

wire  [3:0] VICTrVectPrity22; 
// Priority Programmable register22

wire  [3:0] VICTrVectPrity23; 
// Priority Programmable register23

wire  [3:0] VICTrVectPrity24; 
// Priority Programmable register24

wire  [3:0] VICTrVectPrity25; 
// Priority Programmable register25

wire  [3:0] VICTrVectPrity26; 
// Priority Programmable register26

wire  [3:0] VICTrVectPrity27; 
// Priority Programmable register27

wire  [3:0] VICTrVectPrity28; 
// Priority Programmable register28

wire  [3:0] VICTrVectPrity29; 
// Priority Programmable register29

wire  [3:0] VICTrVectPrity30; 
// Priority Programmable register30

wire  [3:0] VICTrVectPrity31;
// Priority Programmable register31
 
wire [31:0] VICTrVectAddr0;
// VectorAddress 0 register
 
wire [31:0] VICTrVectAddr1;
// VectorAddress 1 register
 
wire [31:0] VICTrVectAddr2;
// VectorAddress 2 register
 
wire [31:0] VICTrVectAddr3;
// VectorAddress 3 register
 
wire [31:0] VICTrVectAddr4;
// VectorAddress 4 register
 
wire [31:0] VICTrVectAddr5;
// VectorAddress 5 register
 
wire [31:0] VICTrVectAddr6;
// VectorAddress 6 register
 
wire [31:0] VICTrVectAddr7;
// VectorAddress 7 register
 
wire [31:0] VICTrVectAddr8;
// VectorAddress 8 register
 
wire [31:0] VICTrVectAddr9;
// VectorAddress 9 register
 
wire [31:0] VICTrVectAddr10;
// VectorAddress 10 register
 
wire [31:0] VICTrVectAddr11;
// VectorAddress 11 register
 
wire [31:0] VICTrVectAddr12;
// VectorAddress 12 register
 
wire [31:0] VICTrVectAddr13;
// VectorAddress 13 register
 
wire [31:0] VICTrVectAddr14;
// VectorAddress 14 register
 
wire [31:0] VICTrVectAddr15;
// VectorAddress 15 register
 
wire [31:0] VICTrVectAddr16;
// VectorAddress 16 register
 
wire [31:0] VICTrVectAddr17;
// VectorAddress 17 register
 
wire [31:0] VICTrVectAddr18;
// VectorAddress 18 register
 
wire [31:0] VICTrVectAddr19;
// VectorAddress 19 register
 
wire [31:0] VICTrVectAddr20;
// VectorAddress 20 register
 
wire [31:0] VICTrVectAddr21;
// VectorAddress 21 register
 
wire [31:0] VICTrVectAddr22;
// VectorAddress 22 register
 
wire [31:0] VICTrVectAddr23;
// VectorAddress 23 register
 
wire [31:0] VICTrVectAddr24;
// VectorAddress 24 register
 
wire [31:0] VICTrVectAddr25;
// VectorAddress 25 register
 
wire [31:0] VICTrVectAddr26;
// VectorAddress 26 register
 
wire [31:0] VICTrVectAddr27;
// VectorAddress 27 register
 
wire [31:0] VICTrVectAddr28;
// VectorAddress 28 register
 
wire [31:0] VICTrVectAddr29;
// VectorAddress 29 register
 
wire [31:0] VICTrVectAddr30;
// VectorAddress 30 register
 
wire [31:0] VICTrVectAddr31;
// VectorAddress 31 register

wire [31:0] VICTrIntSource;
// Interrupt source register
 
wire [31:0] VICTrVectAddrIn;
// Vector AddressIn register

wire        nVICTrFiqIn;
// nVICFIQIN Daisy chain signal
 
wire        nVICTrIrqIn;
// nVICIRQIN Daisy chain signal
 
wire        VICTrFiqInReg;
//  VICFiqInReg Daisy chain signal
 
wire        VICTrIrqInReg;
// VICIrqInReg Daisy chain signal
 
wire [31:0] VICTrRawIntr;
// Raw Interrupt register
 
wire [31:0] VICTrIrqStatus;
// IRQ Status register
 
wire [31:0] VICTrFiqStatus;
// FIQ Status register
 
wire        nVICTrFiq;
// nFIQ from Mirrored VIC model
 
wire        nVICTrIrq;
// nIRQ from Mirrored VIC model
 
wire [31:0] VICTrVectAddr;
// Updated Vector address for selected Interrupt source
 
wire [31:0] VICTrVectAddrOut;
// VectAddrOut from the internal mirrored model
 
wire  [8:0] VICTrTcr;
// Error Message Enabling signal

wire        VectAddrWrTrig;
// Write Enable signal on VICADDRESS register implemented in AHB Block
 
wire        VectAddrRdTrig;
// Read Enable signal on VICADDRESS register implemented in AHB Block

wire        AsyncRdEn;
//Asynchronous Read Enable

wire        VICTrIrqAck; 
// Acknowledge signal internally generated to Mirror Trickbox and uut 

wire        VICTrIrqAckOut; 
// Acknowledged signal to Daisy output

wire        nVICTrSyncEn; 
// Synchronous Enable signal

wire        VICTrVectAddrv; 
// Synchronous Enable signal


// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

defparam uVicTrAhbif.tovmaxintsrc     = `tovmaxintsrc;
defparam uVicTrAhbif.tovmaxnvicfiqin  = `tovmaxnvicfiqin;
defparam uVicTrAhbif.tovmaxnvicirqin  = `tovmaxnvicirqin;
defparam uVicTrAhbif.tovmaxvectadin   = `tovmaxvectadin;
 
// -----------------------------------------------------------------------------
// Instantiation of Trickbox-AHB Interface Block
// -----------------------------------------------------------------------------
VicTrAhbif uVicTrAhbif                (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADYIN         (HREADYIN),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HSIZE            (HSIZE),
                    .HWRITE           (HWRITE),
                    .HPROT            (HPROT),
                    .HWDATA           (HWDATA),
                    .HSELVICTR        (HSELVICTR),
                    .HSELVIC          (HSELVIC),
                    .VICTrVectAddr    (VICTrVectAddrOut),
                    .nVICFIQ          (nVICFIQ),
                    .nVICIRQ          (nVICIRQ),
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .VICVECTADDRV     (VICVECTADDRV),
                    .HRDATA           (HRDATA),
                    .HREADYOUT        (HREADYOUT),
                    .HRESP            (HRESP),
                    .VICTrTCR         (VICTrTcr),
                    .VICINTSOURCE     (VICTrIntSource),
                    .VICVECTADDRIN    (VICTrVectAddrIn),
                    .nVICFIQIN        (nVICTrFiqIn),
                    .nVICIRQIN        (nVICTrIrqIn),
                    .VICIRQINREG      (VICTrIrqInReg),
                    .VICFIQINREG      (VICTrFiqInReg),
                    .nVICSYNCEN       (nVICTrSyncEn),
                    .VICTrSoftInt     (VICTrSoftInt),
                    .VICTrIntEnable   (VICTrIntEnable),
                    .VICTrIntSelect   (VICTrIntSelect),
                    .VICTrSwPriMask   (VICTrSwPriMask),
                    .VICTrVectPriDsy  (VICTrVectPriDsy), 
                    .VICTrVectPrity0  (VICTrVectPrity0),
                    .VICTrVectPrity1  (VICTrVectPrity1),
                    .VICTrVectPrity2  (VICTrVectPrity2),
                    .VICTrVectPrity3  (VICTrVectPrity3),
                    .VICTrVectPrity4  (VICTrVectPrity4),
                    .VICTrVectPrity5  (VICTrVectPrity5),
                    .VICTrVectPrity6  (VICTrVectPrity6),
                    .VICTrVectPrity7  (VICTrVectPrity7),
                    .VICTrVectPrity8  (VICTrVectPrity8),
                    .VICTrVectPrity9  (VICTrVectPrity9),
                    .VICTrVectPrity10 (VICTrVectPrity10),
                    .VICTrVectPrity11 (VICTrVectPrity11),
                    .VICTrVectPrity12 (VICTrVectPrity12),
                    .VICTrVectPrity13 (VICTrVectPrity13),
                    .VICTrVectPrity14 (VICTrVectPrity14),
                    .VICTrVectPrity15 (VICTrVectPrity15),
                    .VICTrVectPrity16 (VICTrVectPrity16),
                    .VICTrVectPrity17 (VICTrVectPrity17),
                    .VICTrVectPrity18 (VICTrVectPrity18),
                    .VICTrVectPrity19 (VICTrVectPrity19),
                    .VICTrVectPrity20 (VICTrVectPrity20),
                    .VICTrVectPrity21 (VICTrVectPrity21),
                    .VICTrVectPrity22 (VICTrVectPrity22),
                    .VICTrVectPrity23 (VICTrVectPrity23),
                    .VICTrVectPrity24 (VICTrVectPrity24),
                    .VICTrVectPrity25 (VICTrVectPrity25),
                    .VICTrVectPrity26 (VICTrVectPrity26),
                    .VICTrVectPrity27 (VICTrVectPrity27),
                    .VICTrVectPrity28 (VICTrVectPrity28),
                    .VICTrVectPrity29 (VICTrVectPrity29),
                    .VICTrVectPrity30 (VICTrVectPrity30),
                    .VICTrVectPrity31 (VICTrVectPrity31),
                    .VICTrVectAddr0   (VICTrVectAddr0),
                    .VICTrVectAddr1   (VICTrVectAddr1),
                    .VICTrVectAddr2   (VICTrVectAddr2),
                    .VICTrVectAddr3   (VICTrVectAddr3),
                    .VICTrVectAddr4   (VICTrVectAddr4),
                    .VICTrVectAddr5   (VICTrVectAddr5),
                    .VICTrVectAddr6   (VICTrVectAddr6),
                    .VICTrVectAddr7   (VICTrVectAddr7),
                    .VICTrVectAddr8   (VICTrVectAddr8),
                    .VICTrVectAddr9   (VICTrVectAddr9),
                    .VICTrVectAddr10  (VICTrVectAddr10),
                    .VICTrVectAddr11  (VICTrVectAddr11),
                    .VICTrVectAddr12  (VICTrVectAddr12),
                    .VICTrVectAddr13  (VICTrVectAddr13),
                    .VICTrVectAddr14  (VICTrVectAddr14),
                    .VICTrVectAddr15  (VICTrVectAddr15),
                    .VICTrVectAddr16  (VICTrVectAddr16),
                    .VICTrVectAddr17  (VICTrVectAddr17),
                    .VICTrVectAddr18  (VICTrVectAddr18),
                    .VICTrVectAddr19  (VICTrVectAddr19),
                    .VICTrVectAddr20  (VICTrVectAddr20),
                    .VICTrVectAddr21  (VICTrVectAddr21),
                    .VICTrVectAddr22  (VICTrVectAddr22),
                    .VICTrVectAddr23  (VICTrVectAddr23),
                    .VICTrVectAddr24  (VICTrVectAddr24),
                    .VICTrVectAddr25  (VICTrVectAddr25),
                    .VICTrVectAddr26  (VICTrVectAddr26),
                    .VICTrVectAddr27  (VICTrVectAddr27),
                    .VICTrVectAddr28  (VICTrVectAddr28),
                    .VICTrVectAddr29  (VICTrVectAddr29),
                    .VICTrVectAddr30  (VICTrVectAddr30),
                    .VICTrVectAddr31  (VICTrVectAddr31),
                    .VICACKOUT        (VICTrIrqAck),
                    .HCLKTRICK        (HCLKTRICK),
                    .VectAddrWrTrig   (VectAddrWrTrig),
                    .VectAddrRdTrig   (VectAddrRdTrig),
                    .AsyncRdEn        (AsyncRdEn)
                    );
// -----------------------------------------------------------------------------
// Instantiation of VIC Mirror Trickbox
// -----------------------------------------------------------------------------
VicMirTrickbox uVicMirTrickbox        (
                    .HCLK             (HCLKTRICK),
                    .HRESETn          (HRESETn),
                    .VicTrIntSource   (VICTrIntSource),
                    .nVicTrFiqIn      (nVICTrFiqIn),
                    .nVicTrIrqIn      (nVICTrIrqIn),
                    .VicTrVectAddrIn  (VICTrVectAddrIn),
                    .VicTrIrqInReg    (VICTrIrqInReg),
                    .VicTrFiqInReg    (VICTrFiqInReg),
                    .VicTrIrqAck      (VICTrIrqAck),
                    .nVicTrSyncEn     (nVICTrSyncEn),
                    .VicTrSoftInt     (VICTrSoftInt),
                    .VicTrIntEn       (VICTrIntEnable),
                    .VicTrIntSelect   (VICTrIntSelect),
                    .VicTrSwPriMask   (VICTrSwPriMask),
                    .VicTrVectPriDsy  (VICTrVectPriDsy),
                    .VicTrVectPrity0  (VICTrVectPrity0),
                    .VicTrVectPrity1  (VICTrVectPrity1),
                    .VicTrVectPrity2  (VICTrVectPrity2),
                    .VicTrVectPrity3  (VICTrVectPrity3),
                    .VicTrVectPrity4  (VICTrVectPrity4),
                    .VicTrVectPrity5  (VICTrVectPrity5),
                    .VicTrVectPrity6  (VICTrVectPrity6),
                    .VicTrVectPrity7  (VICTrVectPrity7),
                    .VicTrVectPrity8  (VICTrVectPrity8),
                    .VicTrVectPrity9  (VICTrVectPrity9),
                    .VicTrVectPrity10 (VICTrVectPrity10),
                    .VicTrVectPrity11 (VICTrVectPrity11),
                    .VicTrVectPrity12 (VICTrVectPrity12),
                    .VicTrVectPrity13 (VICTrVectPrity13),
                    .VicTrVectPrity14 (VICTrVectPrity14),
                    .VicTrVectPrity15 (VICTrVectPrity15),
                    .VicTrVectPrity16 (VICTrVectPrity16),
                    .VicTrVectPrity17 (VICTrVectPrity17),
                    .VicTrVectPrity18 (VICTrVectPrity18),
                    .VicTrVectPrity19 (VICTrVectPrity19),
                    .VicTrVectPrity20 (VICTrVectPrity20),
                    .VicTrVectPrity21 (VICTrVectPrity21),
                    .VicTrVectPrity22 (VICTrVectPrity22),
                    .VicTrVectPrity23 (VICTrVectPrity23),
                    .VicTrVectPrity24 (VICTrVectPrity24),
                    .VicTrVectPrity25 (VICTrVectPrity25),
                    .VicTrVectPrity26 (VICTrVectPrity26),
                    .VicTrVectPrity27 (VICTrVectPrity27),
                    .VicTrVectPrity28 (VICTrVectPrity28),
                    .VicTrVectPrity29 (VICTrVectPrity29),
                    .VicTrVectPrity30 (VICTrVectPrity30),
                    .VicTrVectPrity31 (VICTrVectPrity31),
                    .VicTrVectAddr0   (VICTrVectAddr0),
                    .VicTrVectAddr1   (VICTrVectAddr1),
                    .VicTrVectAddr2   (VICTrVectAddr2),
                    .VicTrVectAddr3   (VICTrVectAddr3),
                    .VicTrVectAddr4   (VICTrVectAddr4),
                    .VicTrVectAddr5   (VICTrVectAddr5),
                    .VicTrVectAddr6   (VICTrVectAddr6),
                    .VicTrVectAddr7   (VICTrVectAddr7),
                    .VicTrVectAddr8   (VICTrVectAddr8),
                    .VicTrVectAddr9   (VICTrVectAddr9),
                    .VicTrVectAddr10  (VICTrVectAddr10),
                    .VicTrVectAddr11  (VICTrVectAddr11),
                    .VicTrVectAddr12  (VICTrVectAddr12),
                    .VicTrVectAddr13  (VICTrVectAddr13),
                    .VicTrVectAddr14  (VICTrVectAddr14),
                    .VicTrVectAddr15  (VICTrVectAddr15),
                    .VicTrVectAddr16  (VICTrVectAddr16),
                    .VicTrVectAddr17  (VICTrVectAddr17),
                    .VicTrVectAddr18  (VICTrVectAddr18),
                    .VicTrVectAddr19  (VICTrVectAddr19),
                    .VicTrVectAddr20  (VICTrVectAddr20),
                    .VicTrVectAddr21  (VICTrVectAddr21),
                    .VicTrVectAddr22  (VICTrVectAddr22),
                    .VicTrVectAddr23  (VICTrVectAddr23),
                    .VicTrVectAddr24  (VICTrVectAddr24),
                    .VicTrVectAddr25  (VICTrVectAddr25),
                    .VicTrVectAddr26  (VICTrVectAddr26),
                    .VicTrVectAddr27  (VICTrVectAddr27),
                    .VicTrVectAddr28  (VICTrVectAddr28),
                    .VicTrVectAddr29  (VICTrVectAddr29),
                    .VicTrVectAddr30  (VICTrVectAddr30),
                    .VicTrVectAddr31  (VICTrVectAddr31),
                    .VectAddrWrTrig   (VectAddrWrTrig),
                    .VectAddrRdTrig   (VectAddrRdTrig),
                    .AsyncRdEn        (AsyncRdEn),
                    .VicTrRawIntr     (VICTrRawIntr),
                    .VicTrIrqStatus   (VICTrIrqStatus),
                    .VicTrFiqStatus   (VICTrFiqStatus),
                    .nVicTrFiq        (nVICTrFiq),
                    .nVicTrIrq        (nVICTrIrq),
                    .VicTrIrqAckOut   (VICTrIrqAckOut),
                    .VicTrVectAddrv   (VICTrVectAddrv),
                    .VicTrVectAddr    (VICTrVectAddrOut)
                    );

// -----------------------------------------------------------------------------
// Instantiation of output comparator
// -----------------------------------------------------------------------------
VicTrProtChkr uVicTrProtChkr          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .VICTrTCR         (VICTrTcr),
                    .nVICFIQ          (nVICFIQ),
                    .nFIQ             (nVICTrFiq),
                    .nVICIRQ          (nVICIRQ),
                    .nIRQ             (nVICTrIrq),
                    .VICVECTADDRV     (VICVECTADDRV),
                    .VICTrVectAddrv   (VICTrVectAddrv),
                    .VICIRQACKOUT     (VICIRQACKOUT),
                    .VicTrIrqAckOut   (VICTrIrqAckOut),
                    .VICVECTADDROUT   (VICVECTADDROUT),
                    .VICTrVectAddrOut (VICTrVectAddrOut)
                    );
 
// -----------------------------------------------------------------------------
// Assigns output signals of the VIC Trickbox
// -----------------------------------------------------------------------------
assign VICINTSOURCE     = VICTrIntSource;
assign VICVECTADDRIN    = VICTrVectAddrIn;
assign nVICFIQIN        = nVICTrFiqIn;
assign nVICIRQIN        = nVICTrIrqIn;
assign VICFIQINREG      = VICTrFiqInReg;
assign VICIRQINREG      = VICTrIrqInReg;
assign VICIRQACK        = VICTrIrqAck;
assign VICSYNCEN        = nVICTrSyncEn;

endmodule

// --=============================== End =====================================--
