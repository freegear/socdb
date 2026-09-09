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
// File Name              : VicTrAhbif.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This module implements the AHB Interface and Register
//           block.
//
// --=================================================================--

`timescale 1ns/1ps

// Include Parameter File
`include "VicTrParams.v"

// ---------------------------------------------------------------------

module VicTrAhbif (
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
                   VICTrVectAddr,
                   nVICFIQ,
                   nVICIRQ,
                   VICVECTADDROUT,
// Outputs
                   HRDATA,
                   HREADYOUT,
                   HRESP,
                   VICTrTCR,
                   VICINTSOURCE,
                   VICVECTADDRIN,
                   nVICFIQIN,
                   nVICIRQIN,
                   SetCSRBit,
                   ClearCSRBit,
                   VICTrSoftInt,
                   VICTrIntEnable,
                   VICTrIntSelect,
                   VICTrDefVectAddr,
                   VICTrVectAddr0,
                   VICTrVectAddr1,
                   VICTrVectAddr2,
                   VICTrVectAddr3,
                   VICTrVectAddr4,
                   VICTrVectAddr5,
                   VICTrVectAddr6,
                   VICTrVectAddr7,
                   VICTrVectAddr8,
                   VICTrVectAddr9,
                   VICTrVectAddr10,
                   VICTrVectAddr11,
                   VICTrVectAddr12,
                   VICTrVectAddr13,
                   VICTrVectAddr14,
                   VICTrVectAddr15,
                   VICTrVectCntl0,
                   VICTrVectCntl1,
                   VICTrVectCntl2,
                   VICTrVectCntl3,
                   VICTrVectCntl4,
                   VICTrVectCntl5,
                   VICTrVectCntl6,
                   VICTrVectCntl7,
                   VICTrVectCntl8,
                   VICTrVectCntl9,
                   VICTrVectCntl10,
                   VICTrVectCntl11,
                   VICTrVectCntl12,
                   VICTrVectCntl13,
                   VICTrVectCntl14,
                   VICTrVectCntl15
                   );

parameter tovminintsrc     = 0;
parameter tovmaxintsrc     = 2;
parameter tovminnvicfiqin  = 0;
parameter tovmaxnvicfiqin  = 5;
parameter tovminnvicirqin  = 0;
parameter tovmaxnvicirqin  = 5;
parameter tovminvectadin   = 0;
parameter tovmaxvectadin   = 5;

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input         HREADYIN;         // Transfer Ready Signal
input  [11:2] HADDR;            // Address Bus for AHB Slave
input         HTRANS;           // Transfer signal for AHB Slave
input   [2:0] HSIZE;            // AHB Transfer size
input         HWRITE;           // Write Signal for AHB Slave
input         HPROT;            // Protection Control signal
input  [31:0] HWDATA;           // Write Data input for AHB Slave
input         HSELVICTR;        // Slave Select Signal for the VIC
                                // Trickbox
input         HSELVIC;          // Slave Select Signal for the VIC
input  [31:0] VICTrVectAddr;    // Vector address from the Mirrored VIC
                                // Model
input         nVICFIQ;          // nVICFIQ output from the VIC
input         nVICIRQ;          // nVICIRQ output from the VIC
input  [31:0] VICVECTADDROUT;   // Input lines for reading
                                // VICVECTADDROUT

// Outputs
output [31:0] HRDATA;           // Read Data output from AHB Slave
output        HREADYOUT;        // Ready Signal from AHB Slave
output  [1:0] HRESP;            // Transfer Response from AHB Slave
output  [2:0] VICTrTCR;         // Compare Enable signals for
                                // VicTrProtChkr
output [31:0] VICINTSOURCE;     // Output lines for raising Interrupt
                                // requests to the VIC
output [31:0] VICVECTADDRIN;    // VICVECTADDRIN Daisy chain Vector
                                // address signal to the VIC
output        nVICFIQIN;        // nVICFIQIN Daisy chain signal to the
                                // VIC
output        nVICIRQIN;        // nVICIRQIN Daisy chain signal to the
                                // VIC
output        SetCSRBit;        // Control signal to set the Current
                                // Service register in the priority
                                // resolver
output        ClearCSRBit;      // Control signal to clear the Current
                                // Service register in the priority
                                // resolver
output [31:0] VICTrSoftInt;     // SoftInt output signal to the
                                // VicTrIntReq sub-block
output [31:0] VICTrIntEnable;   // IntEnable output signal to the
                                // VicTrIntReq sub-block
output [31:0] VICTrIntSelect;   // IntSelect output signal to the
                                // VicTrIntReq sub-block
output [31:0] VICTrDefVectAddr; // DefVectAddr output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr0;   // VectorAddr0 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr1;   // VectorAddr1 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr2;   // VectorAddr2 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr3;   // VectorAddr3 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr4;   // VectorAddr4 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr5;   // VectorAddr5 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr6;   // VectorAddr6 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr7;   // VectorAddr7 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr8;   // VectorAddr8 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr9;   // VectorAddr9 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr10;  // VectorAddr10 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr11;  // VectorAddr11 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr12;  // VectorAddr12 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr13;  // VectorAddr13 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr14;  // VectorAddr14 output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrVectAddr15;  // VectorAddr15 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl0;   // VectorCntl0 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl1;   // VectorCntl1 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl2;   // VectorCntl2 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl3;   // VectorCntl3 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl4;   // VectorCntl4 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl5;   // VectorCntl5 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl6;   // VectorCntl6 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl7;   // VectorCntl7 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl8;   // VectorCntl8 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl9;   // VectorCntl9 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl10;  // VectorCntl10 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl11;  // VectorCntl11 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl12;  // VectorCntl12 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl13;  // VectorCntl13 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl14;  // VectorCntl14 output signal to the
                                // VicTrVectBank sub-block
output  [5:0] VICTrVectCntl15;  // VectorCntl15 output signal to the
                                // VicTrVectBank sub-block

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire          HREADYIN;         // Transfer Ready Signal
wire   [11:2] HADDR;            // Address Bus for AHB Slave
wire          HTRANS;           // Transfer signal for AHB Slave
wire    [2:0] HSIZE;            // AHB Transfer size
wire          HWRITE;           // Write Signal for AHB Slave
wire          HPROT;            // Protection Control signal
wire   [31:0] HWDATA;           // Write Data input for AHB Slave
wire          HSELVICTR;        // Slave Select Signal for the VIC
                                // Trickbox
wire          HSELVIC;          // Slave Select Signal for the VIC
wire   [31:0] VICTrVectAddr;    // Vector address from the Mirrored VIC
                                // Model
wire          nVICFIQ;          // nVICFIQ output from the VIC
wire          nVICIRQ;          // nVICIRQ output from the VIC
wire   [31:0] VICVECTADDROUT;   // Input lines for reading
                                // VICVECTADDROUT

// Outputs
wire   [31:0] HRDATA;           // Read Data output from AHB Slave
reg           HREADYOUT;        // Ready Signal from AHB Slave
wire    [1:0] HRESP;            // Transfer Response from AHB Slave
reg     [2:0] VICTrTCR;         // Compare Enable signals for
                                // VicTrProtChkr
reg    [31:0] VICINTSOURCE;     // Output lines for raising Interrupt
                                // requests to the VIC
reg    [31:0] VICVECTADDRIN;    // VICVECTADDRIN Daisy chain Vector
                                // address signal to the VIC
reg           nVICFIQIN;        // nVICFIQIN Daisy chain signal to the
                                // VIC
reg           nVICIRQIN;        // nVICIRQIN Daisy chain signal to the
                                // VIC
wire          SetCSRBit;        // Control signal to set the Current
                                // Service register in the priority
                                // resolver
reg           ClearCSRBit;      // Control signal to clear the Current
                                // Service register in the priority
                                // resolver
reg    [31:0] VICTrSoftInt;     // Mirrored VICSoftInt register
reg    [31:0] VICTrIntEnable;   // Mirrored VICIntEnable register
reg    [31:0] VICTrIntSelect;   // Mirrored VICIntSelect register
reg    [31:0] VICTrDefVectAddr; // Mirrored VICDefVectAddr register
reg    [31:0] VICTrVectAddr0;   // Mirrored VICVectorAddr0 register
reg    [31:0] VICTrVectAddr1;   // Mirrored VICVectorAddr1 register
reg    [31:0] VICTrVectAddr2;   // Mirrored VICVectorAddr2 register
reg    [31:0] VICTrVectAddr3;   // Mirrored VICVectorAddr3 register
reg    [31:0] VICTrVectAddr4;   // Mirrored VICVectorAddr4 register
reg    [31:0] VICTrVectAddr5;   // Mirrored VICVectorAddr5 register
reg    [31:0] VICTrVectAddr6;   // Mirrored VICVectorAddr6 register
reg    [31:0] VICTrVectAddr7;   // Mirrored VICVectorAddr7 register
reg    [31:0] VICTrVectAddr8;   // Mirrored VICVectorAddr8 register
reg    [31:0] VICTrVectAddr9;   // Mirrored VICVectorAddr9 register
reg    [31:0] VICTrVectAddr10;  // Mirrored VICVectorAddr10 register
reg    [31:0] VICTrVectAddr11;  // Mirrored VICVectorAddr11 register
reg    [31:0] VICTrVectAddr12;  // Mirrored VICVectorAddr12 register
reg    [31:0] VICTrVectAddr13;  // Mirrored VICVectorAddr13 register
reg    [31:0] VICTrVectAddr14;  // Mirrored VICVectorAddr14 register
reg    [31:0] VICTrVectAddr15;  // Mirrored VICVectorAddr15 register
reg     [5:0] VICTrVectCntl0;   // Mirrored VICVectorCntl0 register
reg     [5:0] VICTrVectCntl1;   // Mirrored VICVectorCntl1 register
reg     [5:0] VICTrVectCntl2;   // Mirrored VICVectorCntl2 register
reg     [5:0] VICTrVectCntl3;   // Mirrored VICVectorCntl3 register
reg     [5:0] VICTrVectCntl4;   // Mirrored VICVectorCntl4 register
reg     [5:0] VICTrVectCntl5;   // Mirrored VICVectorCntl5 register
reg     [5:0] VICTrVectCntl6;   // Mirrored VICVectorCntl6 register
reg     [5:0] VICTrVectCntl7;   // Mirrored VICVectorCntl7 register
reg     [5:0] VICTrVectCntl8;   // Mirrored VICVectorCntl8 register
reg     [5:0] VICTrVectCntl9;   // Mirrored VICVectorCntl9 register
reg     [5:0] VICTrVectCntl10;  // Mirrored VICVectorCntl10 register
reg     [5:0] VICTrVectCntl11;  // Mirrored VICVectorCntl11 register
reg     [5:0] VICTrVectCntl12;  // Mirrored VICVectorCntl12 register
reg     [5:0] VICTrVectCntl13;  // Mirrored VICVectorCntl13 register
reg     [5:0] VICTrVectCntl14;  // Mirrored VICVectorCntl14 register
reg     [5:0] VICTrVectCntl15;  // Mirrored VICVectorCntl15 register

// ---------------------------------------------------------------------
//
//                             VicTrAhbif
//                             ==========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block interfaces the Trickbox with the AHB. It decodes AHB
// accesses and generates the write strobes to appropriate registers.
// This module also contains the output data multiplexer that forms the
// read interface. Slave response signals are generated from this
// module. This block implements both the VIC Mirrored and the
// Trickbox specific registers.
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//                      VIC Trickbox Register Map
// ---------------------------------------------------------------------
// Offset          Read (Width)           Write (Width)   Description
// ---------------------------------------------------------------------
// Mirrored Registers :

// 0x00C  VICTrIntSelect          VICTrIntSelect          Mirrored VIC
//                    (32 bits)               (32 bits)   IntSelect
// 0x010  VICTrIntEnable          VICTrIntEnable          Mirrored VIC
//                    (32 bits)               (32 bits)   IntEnable
// 0x014  -                       VICTrIntEnClear         Mirrored VIC
//                                            (32 bits)   IntEnableClear
// 0x018  VICTrSoftInt            VICTrSoftInt            Mirrored VIC
//                    (32 bits)               (32 bits)   SoftInt
// 0x01C  -                       VICTrSoftIntClear       Mirrored VIC
//                                            (32 bits)   SoftIntClear
// 0x020  VICTrProtection         VICTrProtection         Mirrored VIC
//                       (1 bit)                (1 bit)   Protection
// 0x030  VICTrVectAddr           VICTrVectAddr           Mirrored VIC
//                    (32 bits)               (32 bits)   VectAddr
// 0x034  VICTrDefVectAddr        VICTrDefVectAddr        Mirrored VIC
//                    (32 bits)               (32 bits)   DefVectAddr
// 0x100- VICTrVectAddr0-15       VICTrVectAddr0-15       Mirrored VIC
// 0x13C              (32 bits)               (32 bits)   VectAddr0-15
// 0x200- VICTrVectCntl0-15       VICTrVectCntl0-15       Mirrored VIC
// 0x23C               (6 bits)                (6 bits)   VectCntl0-15
// ---------------------------------------------------------------------
// Note :
//   A write to a VIC register will automatically update its mirrored
// register as well. If these mirrored VIC registers are accessed using
// the VIC Base address, the Trickbox returns zeroes on the HRDATA bus.
// However, if these registers are accessed using the Trickbox Base
// address (instead of the VIC Base address), their current contents are
// reflected onto the HRDATA bus.
// ---------------------------------------------------------------------
// VIC Trickbox-specific Registers :

// 0x000  VICTrTCR     (3 bits)   VICTrTCR     (3 bits)   Error Message
//                                                        Enable
// 0x004  VICTrIntSource          VICTrIntSource          Interrupt
//                    (32 bits)               (32 bits)   Source
// 0x008  VICTrStatus  (2 bits)   -                       FIQ and IRQ
//                                                        Status
// 0x024  VICTrVectAddrOut        -                       VICVECTADDROUT
//                    (32 bits)                           Status
// 0x028  VICTrIntIn   (2 bits)   VICTrIntIn   (2 bits)   nVICFIQIN and
//                                                        nVICIRQIN
//                                                        Source
// 0x02C  VICTrVectAddrIn         VICTrVectAddrIn         VICVECTADDRIN
//                    (32 bits)               (32 bits)   Source
// 0x038  VICTrWaitStReg          VICTrWaitStReg          An address
//                                                        location 
//                                                        accessible 
//                                                        with Non-Zero
//                                                        wait states
//                                                        and returns
//                                                        0x55555555
//                                                        when it is
//                                                        read
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
integer     WaitCount;
// Wait State Counter

wire        NewAccess;
// New Access to Trickbox or the VIC

wire        NxtBusEn;
// D-input of BusEn

wire        NxtRdAccess;
// D-input of RdAccess

wire        NxtWrAccess;
// D-input of WrAccess

wire        MrAccessEn;
// Mirrored registers access enable signal

wire        NxtMrWrAccess;
// D-input of MrWrAccess

wire        NxtMrRdAccess;
// D-input of MrRdAccess

wire        NxtDeviceSel;
// D-input of DeviceSel

wire [11:2] NxtAddr;
// D-input of Addr

wire        NxtClearCSRBit;
// Signal to delay the CSR bit Clearing by one clock

wire [31:0] RdData1;
// Internal Read Data bus1

wire [31:0] RdData2;
// Internal Read Data bus2

wire [31:0] RdData3;
// Internal Read Data bus3

wire [31:0] RdData;
// Internal Read Data bus

wire        IntSelectEn;
// VICTrIntSelect Access Enable signal

wire        IntEnableEn;
// VICTrIntEnable Access Enable signal

wire        IntEnClearEn;
// VICTrIntEnableClear Access Enable signal

wire        SoftIntEn;
// VICTrSoftInt Access Enable signal

wire        SoftIntClearEn;
// VICTrSoftIntClear Access Enable signal

wire        ProtectionEn;
// VICTrProtection Access Enable signal

wire        VectAddrEn;
// VICTrVectAddr Access Enable signal

wire        DefVectAddrEn;
// VICTrDefVectAddr Access Enable signal

wire        VectAddr0En;
// VICTrVectAddr0 Access Enable signal

wire        VectAddr1En;
// VICTrVectAddr1 Access Enable signal

wire        VectAddr2En;
// VICTrVectAddr2 Access Enable signal

wire        VectAddr3En;
// VICTrVectAddr3 Access Enable signal

wire        VectAddr4En;
// VICTrVectAddr4 Access Enable signal

wire        VectAddr5En;
// VICTrVectAddr5 Access Enable signal

wire        VectAddr6En;
// VICTrVectAddr6 Access Enable signal

wire        VectAddr7En;
// VICTrVectAddr7 Access Enable signal

wire        VectAddr8En;
// VICTrVectAddr8 Access Enable signal

wire        VectAddr9En;
// VICTrVectAddr9 Access Enable signal

wire        VectAddr10En;
// VICTrVectAddr10 Access Enable signal

wire        VectAddr11En;
// VICTrVectAddr11 Access Enable signal

wire        VectAddr12En;
// VICTrVectAddr12 Access Enable signal

wire        VectAddr13En;
// VICTrVectAddr13 Access Enable signal

wire        VectAddr14En;
// VICTrVectAddr14 Access Enable signal

wire        VectAddr15En;
// VICTrVectAddr15 Access Enable signal

wire        VectCntl0En;
// VICTrVectCntl0 Access Enable signal

wire        VectCntl1En;
// VICTrVectCntl1 Access Enable signal

wire        VectCntl2En;
// VICTrVectCntl2 Access Enable signal

wire        VectCntl3En;
// VICTrVectCntl3 Access Enable signal

wire        VectCntl4En;
// VICTrVectCntl4 Access Enable signal

wire        VectCntl5En;
// VICTrVectCntl5 Access Enable signal

wire        VectCntl6En;
// VICTrVectCntl6 Access Enable signal

wire        VectCntl7En;
// VICTrVectCntl7 Access Enable signal

wire        VectCntl8En;
// VICTrVectCntl8 Access Enable signal

wire        VectCntl9En;
// VICTrVectCntl9 Access Enable signal

wire        VectCntl10En;
// VICTrVectCntl10 Access Enable signal

wire        VectCntl11En;
// VICTrVectCntl11 Access Enable signal

wire        VectCntl12En;
// VICTrVectCntl12 Access Enable signal

wire        VectCntl13En;
// VICTrVectCntl13 Access Enable signal

wire        VectCntl14En;
// VICTrVectCntl14 Access Enable signal

wire        VectCntl15En;
// VICTrVectCntl15 Access Enable signal

wire        VICTrTCREn;
// VICTrTCR Access Enable signal

wire        TrIntSourceEn;
// VICTrIntSource Access Enable signal

wire        TrStatusEn;
// VICTrStatus Access Enable signal

wire        TrIntInEn;
// VICTrIntIn Access Enable signal

wire        TrVectAdInEn;
// VICTrVectAddrIn Access Enable signal

wire        TrVectAdOutEn;
// VICVECTADDROUT Access Enable signal

wire        WaitStRegEn;
// VICTrWaitStReg Access Enable signal

wire        IntSelectRdEn;
// VICTrIntSelect Read Access Enable signal

wire        IntEnableRdEn;
// VICTrIntEnable Read Access Enable signal

wire        SoftIntRdEn;
// VICTrSoftInt Read Access Enable signal

wire        ProtectionRdEn;
// VICTrProtection Read Access Enable signal

wire        VectAddrRdEn;
// VICTrVectAddr Read Access Enable signal

wire        DefVectAddrRdEn;
// VICTrDefVectAddr Read Access Enable signal

wire        VectAddr0RdEn;
// VICTrVectAddr0 Read Access Enable signal

wire        VectAddr1RdEn;
// VICTrVectAddr1 Read Access Enable signal

wire        VectAddr2RdEn;
// VICTrVectAddr2 Read Access Enable signal

wire        VectAddr3RdEn;
// VICTrVectAddr3 Read Access Enable signal

wire        VectAddr4RdEn;
// VICTrVectAddr4 Read Access Enable signal

wire        VectAddr5RdEn;
// VICTrVectAddr5 Read Access Enable signal

wire        VectAddr6RdEn;
// VICTrVectAddr6 Read Access Enable signal

wire        VectAddr7RdEn;
// VICTrVectAddr7 Read Access Enable signal

wire        VectAddr8RdEn;
// VICTrVectAddr8 Read Access Enable signal

wire        VectAddr9RdEn;
// VICTrVectAddr9 Read Access Enable signal

wire        VectAddr10RdEn;
// VICTrVectAddr10 Read Access Enable signal

wire        VectAddr11RdEn;
// VICTrVectAddr11 Read Access Enable signal

wire        VectAddr12RdEn;
// VICTrVectAddr12 Read Access Enable signal

wire        VectAddr13RdEn;
// VICTrVectAddr13 Read Access Enable signal

wire        VectAddr14RdEn;
// VICTrVectAddr14 Read Access Enable signal

wire        VectAddr15RdEn;
// VICTrVectAddr15 Read Access Enable signal

wire        VectCntl0RdEn;
// VICTrVectCntl0 Read Access Enable signal

wire        VectCntl1RdEn;
// VICTrVectCntl1 Read Access Enable signal

wire        VectCntl2RdEn;
// VICTrVectCntl2 Read Access Enable signal

wire        VectCntl3RdEn;
// VICTrVectCntl3 Read Access Enable signal

wire        VectCntl4RdEn;
// VICTrVectCntl4 Read Access Enable signal

wire        VectCntl5RdEn;
// VICTrVectCntl5 Read Access Enable signal

wire        VectCntl6RdEn;
// VICTrVectCntl6 Read Access Enable signal

wire        VectCntl7RdEn;
// VICTrVectCntl7 Read Access Enable signal

wire        VectCntl8RdEn;
// VICTrVectCntl8 Read Access Enable signal

wire        VectCntl9RdEn;
// VICTrVectCntl9 Read Access Enable signal

wire        VectCntl10RdEn;
// VICTrVectCntl10 Read Access Enable signal

wire        VectCntl11RdEn;
// VICTrVectCntl11 Read Access Enable signal

wire        VectCntl12RdEn;
// VICTrVectCntl12 Read Access Enable signal

wire        VectCntl13RdEn;
// VICTrVectCntl13 Read Access Enable signal

wire        VectCntl14RdEn;
// VICTrVectCntl14 Read Access Enable signal

wire        VectCntl15RdEn;
// VICTrVectCntl15 Read Access Enable signal

wire        VICTrTCRRdEn;
// VICTrTCR Read Access Enable signal

wire        TrIntSrcRdEn;
// VICTrIntSource Read Access Enable signal

wire        IntStatRdEn;
// VICTrStatus Read Access Enable signal

wire        TrIntInRdEn;
// VICTrIntIn Read Access Enable signal

wire        TrVectAdInRdEn;
// VICTrVectAddrIn Read Access Enable signal

wire        TrVectAdOutRdEn;
// VICVECTADDROUT Read Access Enable signal

wire        IntSelectWrEn;
// VICTrIntSelect Write Access Enable signal

wire        IntEnableWrEn;
// VICTrIntEnable Write Access Enable signal

wire        IntEnClearWrEn;
// VICTrIntEnableClear Write Access Enable signal

wire        SoftIntWrEn;
// VICTrSoftInt Write Access Enable signal

wire        SoftIntClearWrEn;
// VICTrSoftIntClear Write Access Enable signal

wire        ProtectionWrEn;
// VICTrProtection Write Access Enable signal

wire        VectAddrWrEn;
// VICTrVectAddr Write Access Enable signal

wire        DefVectAddrWrEn;
// VICTrDefVectAddr Write Access Enable signal

wire        VectAddr0WrEn;
// VICTrVectAddr0 Write Access Enable signal

wire        VectAddr1WrEn;
// VICTrVectAddr1 Write Access Enable signal

wire        VectAddr2WrEn;
// VICTrVectAddr2 Write Access Enable signal

wire        VectAddr3WrEn;
// VICTrVectAddr3 Write Access Enable signal

wire        VectAddr4WrEn;
// VICTrVectAddr4 Write Access Enable signal

wire        VectAddr5WrEn;
// VICTrVectAddr5 Write Access Enable signal

wire        VectAddr6WrEn;
// VICTrVectAddr6 Write Access Enable signal

wire        VectAddr7WrEn;
// VICTrVectAddr7 Write Access Enable signal

wire        VectAddr8WrEn;
// VICTrVectAddr8 Write Access Enable signal

wire        VectAddr9WrEn;
// VICTrVectAddr9 Write Access Enable signal

wire        VectAddr10WrEn;
// VICTrVectAddr10 Write Access Enable signal

wire        VectAddr11WrEn;
// VICTrVectAddr11 Write Access Enable signal

wire        VectAddr12WrEn;
// VICTrVectAddr12 Write Access Enable signal

wire        VectAddr13WrEn;
// VICTrVectAddr13 Write Access Enable signal

wire        VectAddr14WrEn;
// VICTrVectAddr14 Write Access Enable signal

wire        VectAddr15WrEn;
// VICTrVectAddr15 Write Access Enable signal

wire        VectCntl0WrEn;
// VICTrVectCntl0 Write Access Enable signal

wire        VectCntl1WrEn;
// VICTrVectCntl1 Write Access Enable signal

wire        VectCntl2WrEn;
// VICTrVectCntl2 Write Access Enable signal

wire        VectCntl3WrEn;
// VICTrVectCntl3 Write Access Enable signal

wire        VectCntl4WrEn;
// VICTrVectCntl4 Write Access Enable signal

wire        VectCntl5WrEn;
// VICTrVectCntl5 Write Access Enable signal

wire        VectCntl6WrEn;
// VICTrVectCntl6 Write Access Enable signal

wire        VectCntl7WrEn;
// VICTrVectCntl7 Write Access Enable signal

wire        VectCntl8WrEn;
// VICTrVectCntl8 Write Access Enable signal

wire        VectCntl9WrEn;
// VICTrVectCntl9 Write Access Enable signal

wire        VectCntl10WrEn;
// VICTrVectCntl10 Write Access Enable signal

wire        VectCntl11WrEn;
// VICTrVectCntl11 Write Access Enable signal

wire        VectCntl12WrEn;
// VICTrVectCntl12 Write Access Enable signal

wire        VectCntl13WrEn;
// VICTrVectCntl13 Write Access Enable signal

wire        VectCntl14WrEn;
// VICTrVectCntl14 Write Access Enable signal

wire        VectCntl15WrEn;
// VICTrVectCntl15 Write Access Enable signal

wire        VICTrTCRWrEn;
// VICTrTCR Write Access Enable signal

wire        TrIntSrcWrEn;
// VICTrIntSource Write Access Enable signal

wire        TrIntInWrEn;
// VICTrIntIn Write Access Enable signal

wire        TrVectAdInWrEn;
// VICTrVectAddrIn Write Access Enable signal

wire [31:0] NxtTrIntSelect;
// D-input of Mirrored VICTrIntSelect Register

wire [31:0] NxtTrIntEnable;
// D-input of Mirrored VICTrIntEnable Register

wire [31:0] NxtTrSoftInt;
// D-input of Mirrored VICTrSoftInt Register

wire        NxtTrProtection;
// D-input of Mirrored VICTrProtection Register

wire [31:0] NxtTrDefVectAddr;
// D-input of Mirrored VICTrDefVectAddr Register

wire [31:0] NxtTrVectAddr0;
// D-input of Mirrored VICTrVectorAddr0 Register

wire [31:0] NxtTrVectAddr1;
// D-input of Mirrored VICTrVectorAddr1 Register

wire [31:0] NxtTrVectAddr2;
// D-input of Mirrored VICTrVectorAddr2 Register

wire [31:0] NxtTrVectAddr3;
// D-input of Mirrored VICTrVectorAddr3 Register

wire [31:0] NxtTrVectAddr4;
// D-input of Mirrored VICTrVectorAddr1 Register

wire [31:0] NxtTrVectAddr5;
// D-input of Mirrored VICTrVectorAddr5 Register

wire [31:0] NxtTrVectAddr6;
// D-input of Mirrored VICTrVectorAddr6 Register

wire [31:0] NxtTrVectAddr7;
// D-input of Mirrored VICTrVectorAddr7 Register

wire [31:0] NxtTrVectAddr8;
// D-input of Mirrored VICTrVectorAddr8 Register

wire [31:0] NxtTrVectAddr9;
// D-input of Mirrored VICTrVectorAddr9 Register

wire [31:0] NxtTrVectAddr10;
// D-input of Mirrored VICTrVectorAddr10 Register

wire [31:0] NxtTrVectAddr11;
// D-input of Mirrored VICTrVectorAddr11 Register

wire [31:0] NxtTrVectAddr12;
// D-input of Mirrored VICTrVectorAddr12 Register

wire [31:0] NxtTrVectAddr13;
// D-input of Mirrored VICTrVectorAddr13 Register

wire [31:0] NxtTrVectAddr14;
// D-input of Mirrored VICTrVectorAddr14 Register

wire [31:0] NxtTrVectAddr15;
// D-input of Mirrored VICTrVectorAddr15 Register

wire  [5:0] NxtTrVectCntl0;
// D-input of Mirrored VICTrVectorCntl0 Register

wire  [5:0] NxtTrVectCntl1;
// D-input of Mirrored VICTrVectorCntl1 Register

wire  [5:0] NxtTrVectCntl2;
// D-input of Mirrored VICTrVectorCntl2 Register

wire  [5:0] NxtTrVectCntl3;
// D-input of Mirrored VICTrVectorCntl3 Register

wire  [5:0] NxtTrVectCntl4;
// D-input of Mirrored VICTrVectorCntl4 Register

wire  [5:0] NxtTrVectCntl5;
// D-input of Mirrored VICTrVectorCntl5 Register

wire  [5:0] NxtTrVectCntl6;
// D-input of Mirrored VICTrVectorCntl6 Register

wire  [5:0] NxtTrVectCntl7;
// D-input of Mirrored VICTrVectorCntl7 Register

wire  [5:0] NxtTrVectCntl8;
// D-input of Mirrored VICTrVectorCntl8 Register

wire  [5:0] NxtTrVectCntl9;
// D-input of Mirrored VICTrVectorCntl9 Register

wire  [5:0] NxtTrVectCntl10;
// D-input of Mirrored VICTrVectorCntl10 Register

wire  [5:0] NxtTrVectCntl11;
// D-input of Mirrored VICTrVectorCntl11 Register

wire  [5:0] NxtTrVectCntl12;
// D-input of Mirrored VICTrVectorCntl12 Register

wire  [5:0] NxtTrVectCntl13;
// D-input of Mirrored VICTrVectorCntl13 Register

wire  [5:0] NxtTrVectCntl14;
// D-input of Mirrored VICTrVectCntl14 Register

wire  [5:0] NxtTrVectCntl15;
// D-input of Mirrored VICTrVectCntl15 Register

wire  [2:0] NxtVICTrTCR;
// D-input of VICTrTCR Register

wire [31:0] NxtTrIntSource;
// D-input of VICTrIntSource Register

wire  [1:0] NxtTrIntIn;
// D-input of VICTrIntIn Register

wire [31:0] NxtTrVectAddrIn;
// D-input of VICTrVectAddrIn Register

// ---------------------------------------------------------------------
// Zero fill for register reads to return zeros in unused bit positions
// ---------------------------------------------------------------------
wire [31:0] ZEROFILL;

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg         BusEn;
// Bus latch Enable signal

reg         RdAccess;
// Read Access to Trickbox

reg         WrAccess;
// Write Access to Trickbox

reg         MrWrAccess;
// Write Access to Mirrored registers

reg         MrRdAccess;
// Read Access to Mirrored registers

reg         DeviceSel;
// Latched Device Select signal

reg  [11:2] Addr;
// Latched Address bus within Trickbox

reg         VICTrProtection;
// Mirrored Protection Register

reg  [31:0] VICTrIntSource;
// VICTrIntSource Register

reg   [1:0] VICTrIntIn;
// VICTrIntIn Register

reg  [31:0] VICTrVectAddrIn;
// VICTrVectAddrIn Register

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
// Assign ZEROFILL
// ---------------------------------------------------------------------
assign ZEROFILL         = 32'h00000000;

// ---------------------------------------------------------------------
// Assign 'min' and 'max' delays to the VICINTSOURCE signal
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICINTSRCComb
  # tovminintsrc VICINTSOURCE <= 32'hXXXXXXXX;
  # tovmaxintsrc VICINTSOURCE <= VICTrIntSource;
end // p_TrVICINTSRCComb

// ---------------------------------------------------------------------
// Assign 'min' and 'max' delays to the nVICFIQIN signal
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICFIQINComb
  # tovminnvicfiqin nVICFIQIN <= 1'bX;
  # tovmaxnvicfiqin nVICFIQIN <= VICTrIntIn[0];
end // p_TrVICFIQINComb

// ---------------------------------------------------------------------
// Assign 'min' and 'max' delays to the nVICIRQIN signal
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICIRQINComb
  # tovminnvicirqin nVICIRQIN <= 1'bX;
  # tovmaxnvicirqin nVICIRQIN <= VICTrIntIn[1];
end // p_TrVICIRQINComb

// ---------------------------------------------------------------------
// Assign 'min' and 'max' delays to the VICVECTADDRIN signal
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICVECTADComb
  # tovminvectadin VICVECTADDRIN <= 32'hXXXXXXXX;
  # tovmaxvectadin VICVECTADDRIN <= VICTrVectAddrIn;
end // p_TrVICVECTADComb

// ---------------------------------------------------------------------
// Detecting new accesses to either the VIC or the Trickbox
// ---------------------------------------------------------------------
assign NewAccess        = (HSELVICTR | HSELVIC) & HREADYIN & HTRANS;

assign NxtWrAccess      = (HREADYIN == 1'b1) ? 
                          (HSELVICTR & HWRITE & HTRANS) : WrAccess;

assign MrAccessEn       = (VICTrProtection == 1'b0) ? 1'b1 : HPROT;

assign NxtMrWrAccess    = (HREADYIN == 1'b1) ?
                          (HSELVIC & HWRITE & HTRANS & MrAccessEn &
                           ~(HSIZE[2]) & HSIZE[1] & ~(HSIZE[0])) :
                          MrWrAccess;

assign NxtMrRdAccess    = (HREADYIN == 1'b1) ?
                          (HSELVIC & ~(HWRITE) & HTRANS &
                           MrAccessEn & ~(HSIZE[2]) & HSIZE[1] &
                           ~(HSIZE[0])) : MrRdAccess;

assign NxtRdAccess      = (HREADYIN == 1'b1) ? 
                          (HSELVICTR & ~(HWRITE) & HTRANS) : RdAccess;

assign NxtDeviceSel     = (HREADYIN == 1'b1) ? HSELVICTR : DeviceSel;

// ---------------------------------------------------------------------
// Sequential logic for the Access Enable signals
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AccesstypeSeq
  if (HRESETn ==  1'b0)
    begin
      WrAccess   <= 1'b0;
      MrWrAccess <= 1'b0;
      MrRdAccess <= 1'b0;
      RdAccess   <= 1'b0;
      DeviceSel  <= 1'b0;
    end
  else
    begin
      WrAccess   <= NxtWrAccess;
      MrWrAccess <= NxtMrWrAccess;
      MrRdAccess <= NxtMrRdAccess;
      RdAccess   <= NxtRdAccess;
      DeviceSel  <= NxtDeviceSel;
    end
end // p_AccesstypeSeq

// ---------------------------------------------------------------------
// Samples the address if the slave is selected
// ---------------------------------------------------------------------
assign NxtAddr          = (NewAccess == 1'b1) ? HADDR[11:2] : Addr;

// ---------------------------------------------------------------------
// Sequential logic for the internal Address bus
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AddrSeq
  if (HRESETn ==  1'b0)
    Addr <= 10'b0000000000;
  else
    Addr <= NxtAddr;
end // p_AddrSeq

// ---------------------------------------------------------------------
// Bus Latch Enable signal generation
// ---------------------------------------------------------------------
assign NxtBusEn         = (NewAccess == 1'b1) ? 1'b1 : 1'b0;

// ---------------------------------------------------------------------
// Sequential logic for the Bus Latch Enable
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusEnSeq
  if (HRESETn ==  1'b0)
    BusEn <= 1'b0;
  else
    BusEn <= NxtBusEn;
end // p_BusEnSeq

// ---------------------------------------------------------------------
// Decode the latched Address
// ---------------------------------------------------------------------
assign IntSelectEn      = (Addr == `VICTRINTSELECTADDR) ? 1'b1 : 1'b0;

assign IntEnableEn      = (Addr == `VICTRINTENABLEADDR) ? 1'b1 : 1'b0;

assign IntEnClearEn     = (Addr == `VICTRINTENCLEARADDR) ? 1'b1 : 1'b0;

assign SoftIntEn        = (Addr == `VICTRSOFTINTADDR) ? 1'b1 : 1'b0;

assign SoftIntClearEn   = (Addr == `VICTRSOFTINTCLEARADDR) ?
                          1'b1 : 1'b0;

assign ProtectionEn     = (Addr == `VICTRPROTECTIONADDR) ? 1'b1 : 1'b0;

assign VectAddrEn       = (Addr == `VICTRVECTADADDR) ? 1'b1 : 1'b0;

assign DefVectAddrEn    = (Addr == `VICTRDEFVECTADADDR) ? 1'b1 : 1'b0;

assign VectAddr0En      = (Addr == `VICTRVECTAD0ADDR) ? 1'b1 : 1'b0;

assign VectAddr1En      = (Addr == `VICTRVECTAD1ADDR) ? 1'b1 : 1'b0;

assign VectAddr2En      = (Addr == `VICTRVECTAD2ADDR) ? 1'b1 : 1'b0;

assign VectAddr3En      = (Addr == `VICTRVECTAD3ADDR) ? 1'b1 : 1'b0;

assign VectAddr4En      = (Addr == `VICTRVECTAD4ADDR) ? 1'b1 : 1'b0;

assign VectAddr5En      = (Addr == `VICTRVECTAD5ADDR) ? 1'b1 : 1'b0;

assign VectAddr6En      = (Addr == `VICTRVECTAD6ADDR) ? 1'b1 : 1'b0;

assign VectAddr7En      = (Addr == `VICTRVECTAD7ADDR) ? 1'b1 : 1'b0;

assign VectAddr8En      = (Addr == `VICTRVECTAD8ADDR) ? 1'b1 : 1'b0;

assign VectAddr9En      = (Addr == `VICTRVECTAD9ADDR) ? 1'b1 : 1'b0;

assign VectAddr10En     = (Addr == `VICTRVECTAD10ADDR) ? 1'b1 : 1'b0;

assign VectAddr11En     = (Addr == `VICTRVECTAD11ADDR) ? 1'b1 : 1'b0;

assign VectAddr12En     = (Addr == `VICTRVECTAD12ADDR) ? 1'b1 : 1'b0;

assign VectAddr13En     = (Addr == `VICTRVECTAD13ADDR) ? 1'b1 : 1'b0;

assign VectAddr14En     = (Addr == `VICTRVECTAD14ADDR) ? 1'b1 : 1'b0;

assign VectAddr15En     = (Addr == `VICTRVECTAD15ADDR) ? 1'b1 : 1'b0;

assign VectCntl0En      = (Addr == `VICTRVECTCNTL0ADDR) ? 1'b1 : 1'b0;

assign VectCntl1En      = (Addr == `VICTRVECTCNTL1ADDR) ? 1'b1 : 1'b0;

assign VectCntl2En      = (Addr == `VICTRVECTCNTL2ADDR) ? 1'b1 : 1'b0;

assign VectCntl3En      = (Addr == `VICTRVECTCNTL3ADDR) ? 1'b1 : 1'b0;

assign VectCntl4En      = (Addr == `VICTRVECTCNTL4ADDR) ? 1'b1 : 1'b0;

assign VectCntl5En      = (Addr == `VICTRVECTCNTL5ADDR) ? 1'b1 : 1'b0;

assign VectCntl6En      = (Addr == `VICTRVECTCNTL6ADDR) ? 1'b1 : 1'b0;

assign VectCntl7En      = (Addr == `VICTRVECTCNTL7ADDR) ? 1'b1 : 1'b0;

assign VectCntl8En      = (Addr == `VICTRVECTCNTL8ADDR) ? 1'b1 : 1'b0;

assign VectCntl9En      = (Addr == `VICTRVECTCNTL9ADDR) ? 1'b1 : 1'b0;

assign VectCntl10En     = (Addr == `VICTRVECTCNTL10ADDR) ? 1'b1 : 1'b0;

assign VectCntl11En     = (Addr == `VICTRVECTCNTL11ADDR) ? 1'b1 : 1'b0;

assign VectCntl12En     = (Addr == `VICTRVECTCNTL12ADDR) ? 1'b1 : 1'b0;

assign VectCntl13En     = (Addr == `VICTRVECTCNTL13ADDR) ? 1'b1 : 1'b0;

assign VectCntl14En     = (Addr == `VICTRVECTCNTL14ADDR) ? 1'b1 : 1'b0;

assign VectCntl15En     = (Addr == `VICTRVECTCNTL15ADDR) ? 1'b1 : 1'b0;

assign VICTrTCREn       = (Addr == `VICTRTCRADDR) ? 1'b1 : 1'b0;

assign TrIntSourceEn    = (Addr == `VICTRINTSOURCEADDR) ? 1'b1 : 1'b0;

assign TrStatusEn       = (Addr == `VICTRINTSTATUSADDR) ? 1'b1 : 1'b0;

assign TrIntInEn        = (Addr == `VICTRINTINADDR) ? 1'b1 : 1'b0;

assign TrVectAdInEn     = (Addr == `VICTRVECTADINADDR) ? 1'b1 : 1'b0;

assign TrVectAdOutEn    = (Addr == `VICTRVECTADOUTADDR) ? 1'b1 : 1'b0;

assign WaitStRegEn      = (Addr == `VICTRWAITACCESSADDR) ? 1'b1 : 1'b0;

// ---------------------------------------------------------------------
// Generates Read Access Enable Signals
// ---------------------------------------------------------------------
assign IntSelectRdEn    = IntSelectEn & RdAccess;

assign IntEnableRdEn    = IntEnableEn & RdAccess;

assign SoftIntRdEn      = SoftIntEn & RdAccess;

assign ProtectionRdEn   = ProtectionEn & RdAccess;

assign VectAddrRdEn     = VectAddrEn & RdAccess;

assign DefVectAddrRdEn  = DefVectAddrEn & RdAccess;

assign VectAddr0RdEn    = VectAddr0En & RdAccess;

assign VectAddr1RdEn    = VectAddr1En & RdAccess;

assign VectAddr2RdEn    = VectAddr2En & RdAccess;

assign VectAddr3RdEn    = VectAddr3En & RdAccess;

assign VectAddr4RdEn    = VectAddr4En & RdAccess;

assign VectAddr5RdEn    = VectAddr5En & RdAccess;

assign VectAddr6RdEn    = VectAddr6En & RdAccess;

assign VectAddr7RdEn    = VectAddr7En & RdAccess;

assign VectAddr8RdEn    = VectAddr8En & RdAccess;

assign VectAddr9RdEn    = VectAddr9En & RdAccess;

assign VectAddr10RdEn   = VectAddr10En & RdAccess;

assign VectAddr11RdEn   = VectAddr11En & RdAccess;

assign VectAddr12RdEn   = VectAddr12En & RdAccess;

assign VectAddr13RdEn   = VectAddr13En & RdAccess;

assign VectAddr14RdEn   = VectAddr14En & RdAccess;

assign VectAddr15RdEn   = VectAddr15En & RdAccess;

assign VectCntl0RdEn    = VectCntl0En & RdAccess;

assign VectCntl1RdEn    = VectCntl1En & RdAccess;

assign VectCntl2RdEn    = VectCntl2En & RdAccess;

assign VectCntl3RdEn    = VectCntl3En & RdAccess;

assign VectCntl4RdEn    = VectCntl4En & RdAccess;

assign VectCntl5RdEn    = VectCntl5En & RdAccess;

assign VectCntl6RdEn    = VectCntl6En & RdAccess;

assign VectCntl7RdEn    = VectCntl7En & RdAccess;

assign VectCntl8RdEn    = VectCntl8En & RdAccess;

assign VectCntl9RdEn    = VectCntl9En & RdAccess;

assign VectCntl10RdEn   = VectCntl10En & RdAccess;

assign VectCntl11RdEn   = VectCntl11En & RdAccess;

assign VectCntl12RdEn   = VectCntl12En & RdAccess;

assign VectCntl13RdEn   = VectCntl13En & RdAccess;

assign VectCntl14RdEn   = VectCntl14En & RdAccess;

assign VectCntl15RdEn   = VectCntl15En & RdAccess;

assign VICTrTCRRdEn     = VICTrTCREn & RdAccess;

assign TrIntSrcRdEn     = TrIntSourceEn & RdAccess;

assign IntStatRdEn      = TrStatusEn & RdAccess;

assign TrIntInRdEn      = TrIntInEn & RdAccess;

assign TrVectAdInRdEn   = TrVectAdInEn & RdAccess;

assign TrVectAdOutRdEn  = TrVectAdOutEn & RdAccess;

// ---------------------------------------------------------------------
// Genarates Write Access Enable Signals
// ---------------------------------------------------------------------
assign IntSelectWrEn    = IntSelectEn & MrWrAccess;

assign IntEnableWrEn    = IntEnableEn & MrWrAccess;

assign IntEnClearWrEn   = IntEnClearEn & MrWrAccess;

assign SoftIntWrEn      = SoftIntEn & MrWrAccess;

assign SoftIntClearWrEn = SoftIntClearEn & MrWrAccess;

assign ProtectionWrEn   = ProtectionEn & MrWrAccess;

assign VectAddrWrEn     = VectAddrEn & MrWrAccess;

assign DefVectAddrWrEn  = DefVectAddrEn & MrWrAccess;

assign VectAddr0WrEn    = VectAddr0En & MrWrAccess;

assign VectAddr1WrEn    = VectAddr1En & MrWrAccess;

assign VectAddr2WrEn    = VectAddr2En & MrWrAccess;

assign VectAddr3WrEn    = VectAddr3En & MrWrAccess;

assign VectAddr4WrEn    = VectAddr4En & MrWrAccess;

assign VectAddr5WrEn    = VectAddr5En & MrWrAccess;

assign VectAddr6WrEn    = VectAddr6En & MrWrAccess;

assign VectAddr7WrEn    = VectAddr7En & MrWrAccess;

assign VectAddr8WrEn    = VectAddr8En & MrWrAccess;

assign VectAddr9WrEn    = VectAddr9En & MrWrAccess;

assign VectAddr10WrEn   = VectAddr10En & MrWrAccess;

assign VectAddr11WrEn   = VectAddr11En & MrWrAccess;

assign VectAddr12WrEn   = VectAddr12En & MrWrAccess;

assign VectAddr13WrEn   = VectAddr13En & MrWrAccess;

assign VectAddr14WrEn   = VectAddr14En & MrWrAccess;

assign VectAddr15WrEn   = VectAddr15En & MrWrAccess;

assign VectCntl0WrEn    = VectCntl0En & MrWrAccess;

assign VectCntl1WrEn    = VectCntl1En & MrWrAccess;

assign VectCntl2WrEn    = VectCntl2En & MrWrAccess;

assign VectCntl3WrEn    = VectCntl3En & MrWrAccess;

assign VectCntl4WrEn    = VectCntl4En & MrWrAccess;

assign VectCntl5WrEn    = VectCntl5En & MrWrAccess;

assign VectCntl6WrEn    = VectCntl6En & MrWrAccess;

assign VectCntl7WrEn    = VectCntl7En & MrWrAccess;

assign VectCntl8WrEn    = VectCntl8En & MrWrAccess;

assign VectCntl9WrEn    = VectCntl9En & MrWrAccess;

assign VectCntl10WrEn   = VectCntl10En & MrWrAccess;

assign VectCntl11WrEn   = VectCntl11En & MrWrAccess;

assign VectCntl12WrEn   = VectCntl12En & MrWrAccess;

assign VectCntl13WrEn   = VectCntl13En & MrWrAccess;

assign VectCntl14WrEn   = VectCntl14En & MrWrAccess;

assign VectCntl15WrEn   = VectCntl15En & MrWrAccess;

assign VICTrTCRWrEn     = VICTrTCREn & WrAccess;

assign TrIntSrcWrEn     = TrIntSourceEn & WrAccess;

assign TrIntInWrEn      = TrIntInEn & WrAccess;

assign TrVectAdInWrEn   = TrVectAdInEn & WrAccess;

// ---------------------------------------------------------------------
// Generates control signals to set/clear the Current Service Register
// ---------------------------------------------------------------------
assign SetCSRBit        = VectAddrEn & MrRdAccess;

assign NxtClearCSRBit   = VectAddrWrEn;

// ---------------------------------------------------------------------
// Combinational logic for all writeable registers.
//
// When the respective write enable input is asserted, copy the contents
// of the HWDATA bus into the corresponding registers.
// ---------------------------------------------------------------------
assign NxtTrIntSelect   = (IntSelectWrEn == 1'b1) ?
                           HWDATA : VICTrIntSelect;

assign NxtTrIntEnable   = (IntEnableWrEn == 1'b1)    ?
                          (HWDATA | VICTrIntEnable)    :
                          ((IntEnClearWrEn == 1'b1)  ?
                          (~(HWDATA) & VICTrIntEnable) :
                           VICTrIntEnable);

assign NxtTrSoftInt     = (SoftIntWrEn == 1'b1)        ?
                          (HWDATA | VICTrSoftInt)    :
                          ((SoftIntClearWrEn == 1'b1)  ?
                          (~(HWDATA) & VICTrSoftInt) :
                           VICTrSoftInt);

assign NxtTrProtection  = (ProtectionWrEn == 1'b1) ?
                           HWDATA[0] : VICTrProtection;

assign NxtTrDefVectAddr = (DefVectAddrWrEn == 1'b1) ?
                           HWDATA : VICTrDefVectAddr;

assign NxtTrVectAddr0   = (VectAddr0WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr0;

assign NxtTrVectAddr1   = (VectAddr1WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr1;

assign NxtTrVectAddr2   = (VectAddr2WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr2;

assign NxtTrVectAddr3   = (VectAddr3WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr3;

assign NxtTrVectAddr4   = (VectAddr4WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr4;

assign NxtTrVectAddr5   = (VectAddr5WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr5;

assign NxtTrVectAddr6   = (VectAddr6WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr6;

assign NxtTrVectAddr7   = (VectAddr7WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr7;

assign NxtTrVectAddr8   = (VectAddr8WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr8;

assign NxtTrVectAddr9   = (VectAddr9WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr9;

assign NxtTrVectAddr10  = (VectAddr10WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr10;

assign NxtTrVectAddr11  = (VectAddr11WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr11;

assign NxtTrVectAddr12  = (VectAddr12WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr12;

assign NxtTrVectAddr13  = (VectAddr13WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr13;

assign NxtTrVectAddr14  = (VectAddr14WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr14;

assign NxtTrVectAddr15  = (VectAddr15WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr15;

assign NxtTrVectCntl0   = (VectCntl0WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl0;

assign NxtTrVectCntl1   = (VectCntl1WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl1;

assign NxtTrVectCntl2   = (VectCntl2WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl2;

assign NxtTrVectCntl3   = (VectCntl3WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl3;

assign NxtTrVectCntl4   = (VectCntl4WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl4;

assign NxtTrVectCntl5   = (VectCntl5WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl5;

assign NxtTrVectCntl6   = (VectCntl6WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl6;

assign NxtTrVectCntl7   = (VectCntl7WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl7;

assign NxtTrVectCntl8   = (VectCntl8WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl8;

assign NxtTrVectCntl9   = (VectCntl9WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl9;

assign NxtTrVectCntl10  = (VectCntl10WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl10;

assign NxtTrVectCntl11  = (VectCntl11WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl11;

assign NxtTrVectCntl12  = (VectCntl12WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl12;

assign NxtTrVectCntl13  = (VectCntl13WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl13;

assign NxtTrVectCntl14  = (VectCntl14WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl14;

assign NxtTrVectCntl15  = (VectCntl15WrEn == 1'b1) ?
                           HWDATA[5:0] : VICTrVectCntl15;

assign NxtVICTrTCR      = (VICTrTCRWrEn == 1'b1) ?
                           HWDATA[2:0] : VICTrTCR;

assign NxtTrIntSource   = (TrIntSrcWrEn == 1'b1) ?
                           HWDATA : VICTrIntSource;

assign NxtTrIntIn       = (TrIntInWrEn == 1'b1) ?
                           HWDATA[1:0] : VICTrIntIn;

assign NxtTrVectAddrIn  = (TrVectAdInWrEn == 1'b1) ?
                           HWDATA : VICTrVectAddrIn;

// ---------------------------------------------------------------------
// Sequential logic for VICTrIntSelect, VICTrIntEnable, VICTrSoftInt,
// VICTrProtection and VICTrDefVectAddr
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrIntRegSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrIntSelect   <= 32'h00000000;
      VICTrIntEnable   <= 32'h00000000;
      VICTrSoftInt     <= 32'h00000000;
      VICTrProtection  <= 1'b0;
      VICTrDefVectAddr <= 32'h00000000;
    end
  else
    begin
      VICTrIntSelect   <= NxtTrIntSelect;
      VICTrIntEnable   <= NxtTrIntEnable;
      VICTrSoftInt     <= NxtTrSoftInt;
      VICTrProtection  <= NxtTrProtection;
      VICTrDefVectAddr <= NxtTrDefVectAddr;
    end
end // p_TrIntRegSeq

// ---------------------------------------------------------------------
// Sequential logic for the VICTrVectAddr registers
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrVectAddrSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrVectAddr0  <= 32'h00000000;
      VICTrVectAddr1  <= 32'h00000000;
      VICTrVectAddr2  <= 32'h00000000;
      VICTrVectAddr3  <= 32'h00000000;
      VICTrVectAddr4  <= 32'h00000000;
      VICTrVectAddr5  <= 32'h00000000;
      VICTrVectAddr6  <= 32'h00000000;
      VICTrVectAddr7  <= 32'h00000000;
      VICTrVectAddr8  <= 32'h00000000;
      VICTrVectAddr9  <= 32'h00000000;
      VICTrVectAddr10 <= 32'h00000000;
      VICTrVectAddr11 <= 32'h00000000;
      VICTrVectAddr12 <= 32'h00000000;
      VICTrVectAddr13 <= 32'h00000000;
      VICTrVectAddr14 <= 32'h00000000;
      VICTrVectAddr15 <= 32'h00000000;
    end
  else
    begin
      VICTrVectAddr0  <= NxtTrVectAddr0;
      VICTrVectAddr1  <= NxtTrVectAddr1;
      VICTrVectAddr2  <= NxtTrVectAddr2;
      VICTrVectAddr3  <= NxtTrVectAddr3;
      VICTrVectAddr4  <= NxtTrVectAddr4;
      VICTrVectAddr5  <= NxtTrVectAddr5;
      VICTrVectAddr6  <= NxtTrVectAddr6;
      VICTrVectAddr7  <= NxtTrVectAddr7;
      VICTrVectAddr8  <= NxtTrVectAddr8;
      VICTrVectAddr9  <= NxtTrVectAddr9;
      VICTrVectAddr10 <= NxtTrVectAddr10;
      VICTrVectAddr11 <= NxtTrVectAddr11;
      VICTrVectAddr12 <= NxtTrVectAddr12;
      VICTrVectAddr13 <= NxtTrVectAddr13;
      VICTrVectAddr14 <= NxtTrVectAddr14;
      VICTrVectAddr15 <= NxtTrVectAddr15;
    end
end // p_TrVectAddrSeq

// ---------------------------------------------------------------------
// Sequential logic for the VICTrVectCntl registers
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrVectCntlSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrVectCntl0  <= 6'b000000;
      VICTrVectCntl1  <= 6'b000000;
      VICTrVectCntl2  <= 6'b000000;
      VICTrVectCntl3  <= 6'b000000;
      VICTrVectCntl4  <= 6'b000000;
      VICTrVectCntl5  <= 6'b000000;
      VICTrVectCntl6  <= 6'b000000;
      VICTrVectCntl7  <= 6'b000000;
      VICTrVectCntl8  <= 6'b000000;
      VICTrVectCntl9  <= 6'b000000;
      VICTrVectCntl10 <= 6'b000000;
      VICTrVectCntl11 <= 6'b000000;
      VICTrVectCntl12 <= 6'b000000;
      VICTrVectCntl13 <= 6'b000000;
      VICTrVectCntl14 <= 6'b000000;
      VICTrVectCntl15 <= 6'b000000;
    end
  else
    begin
      VICTrVectCntl0  <= NxtTrVectCntl0;
      VICTrVectCntl1  <= NxtTrVectCntl1;
      VICTrVectCntl2  <= NxtTrVectCntl2;
      VICTrVectCntl3  <= NxtTrVectCntl3;
      VICTrVectCntl4  <= NxtTrVectCntl4;
      VICTrVectCntl5  <= NxtTrVectCntl5;
      VICTrVectCntl6  <= NxtTrVectCntl6;
      VICTrVectCntl7  <= NxtTrVectCntl7;
      VICTrVectCntl8  <= NxtTrVectCntl8;
      VICTrVectCntl9  <= NxtTrVectCntl9;
      VICTrVectCntl10 <= NxtTrVectCntl10;
      VICTrVectCntl11 <= NxtTrVectCntl11;
      VICTrVectCntl12 <= NxtTrVectCntl12;
      VICTrVectCntl13 <= NxtTrVectCntl13;
      VICTrVectCntl14 <= NxtTrVectCntl14;
      VICTrVectCntl15 <= NxtTrVectCntl15;
    end
end // p_TrVectCntlSeq

// ---------------------------------------------------------------------
// Sequential logic for VICTrTCR, VICTrIntSource, VICTrIntIn and
// VICTrVectAddrIn
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrRegSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrTCR        <= 3'b000;
      VICTrIntSource  <= 32'h00000000;
      VICTrIntIn      <= 2'b11;
      VICTrVectAddrIn <= 32'h00000000;
      ClearCSRBit     <= 1'b0;
    end
  else
    begin
      VICTrTCR        <= NxtVICTrTCR;
      VICTrIntSource  <= NxtTrIntSource;
      VICTrIntIn      <= NxtTrIntIn;
      VICTrVectAddrIn <= NxtTrVectAddrIn;
      ClearCSRBit     <= NxtClearCSRBit;
    end
end // p_TrRegSeq

// ---------------------------------------------------------------------
// Multiplexing RdData1 bus
// ---------------------------------------------------------------------
assign RdData1          = (IntSelectRdEn == 1'b1)    ?
                           VICTrIntSelect                :
                          ((IntEnableRdEn == 1'b1)   ?
                           VICTrIntEnable                :
                          ((SoftIntRdEn == 1'b1)     ?
                           VICTrSoftInt                  :
                          ((VectAddrRdEn == 1'b1)    ?
                           VICTrVectAddr                 :
                          ((DefVectAddrRdEn == 1'b1) ?
                           VICTrDefVectAddr              :
                          ((VICTrTCRRdEn == 1'b1)    ?
                           {ZEROFILL[31:3], VICTrTCR}    :
                          ((TrIntSrcRdEn == 1'b1)    ?
                           VICTrIntSource                :
                          ((IntStatRdEn == 1'b1)     ?
                           {ZEROFILL[31:2], nVICFIQ, nVICIRQ} :
                          ((TrIntInRdEn == 1'b1)     ?
                           {ZEROFILL[31:2], VICTrIntIn}  :
                          ((TrVectAdInRdEn == 1'b1)  ?
                           VICTrVectAddrIn               :
                          ((TrVectAdOutRdEn == 1'b1) ?
                           VICVECTADDROUT                :
                          ((WaitCount == `WAITSTATES) ?
                           (32'h55555555)                :
                           (ZEROFILL))))))))))));

// ---------------------------------------------------------------------
// Multiplexing RdData2 bus
// ---------------------------------------------------------------------
assign RdData2          = (VectAddr0RdEn == 1'b1)   ?
                           VICTrVectAddr0  :
                          ((VectAddr1RdEn == 1'b1)  ?
                           VICTrVectAddr1  :
                          ((VectAddr2RdEn == 1'b1)  ?
                           VICTrVectAddr2  :
                          ((VectAddr3RdEn == 1'b1)  ?
                           VICTrVectAddr3  :
                          ((VectAddr4RdEn == 1'b1)  ?
                           VICTrVectAddr4  :
                          ((VectAddr5RdEn == 1'b1)  ?
                           VICTrVectAddr5  :
                          ((VectAddr6RdEn == 1'b1)  ?
                           VICTrVectAddr6  :
                          ((VectAddr7RdEn == 1'b1)  ?
                           VICTrVectAddr7  :
                          ((VectAddr8RdEn == 1'b1)  ?
                           VICTrVectAddr8  :
                          ((VectAddr9RdEn == 1'b1)  ?
                           VICTrVectAddr9  :
                          ((VectAddr10RdEn == 1'b1) ?
                           VICTrVectAddr10 :
                          ((VectAddr11RdEn == 1'b1) ?
                           VICTrVectAddr11 :
                          ((VectAddr12RdEn == 1'b1) ?
                           VICTrVectAddr12 :
                          ((VectAddr13RdEn == 1'b1) ?
                           VICTrVectAddr13 :
                          ((VectAddr14RdEn == 1'b1) ?
                           VICTrVectAddr14 :
                          ((VectAddr15RdEn == 1'b1) ?
                           VICTrVectAddr15 :
                           (ZEROFILL))))))))))))))));

// ---------------------------------------------------------------------
// Multiplexing RdData3 bus
// ---------------------------------------------------------------------
assign RdData3          = (VectCntl0RdEn == 1'b1)    ?
                           {ZEROFILL[31:6], VICTrVectCntl0}  :
                           ((VectCntl1RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl1}  :
                           ((VectCntl2RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl2}  :
                           ((VectCntl3RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl3}  :
                           ((VectCntl4RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl4}  :
                           ((VectCntl5RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl5}  :
                           ((VectCntl6RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl6}  :
                           ((VectCntl7RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl7}  :
                           ((VectCntl8RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl8}  :
                           ((VectCntl9RdEn == 1'b1)  ?
                           {ZEROFILL[31:6], VICTrVectCntl9}  :
                           ((VectCntl10RdEn == 1'b1) ?
                           {ZEROFILL[31:6], VICTrVectCntl10} :
                           ((VectCntl11RdEn == 1'b1) ?
                           {ZEROFILL[31:6], VICTrVectCntl11} :
                           ((VectCntl12RdEn == 1'b1) ?
                           {ZEROFILL[31:6], VICTrVectCntl12} :
                           ((VectCntl13RdEn == 1'b1) ?
                           {ZEROFILL[31:6], VICTrVectCntl13} :
                           ((VectCntl14RdEn == 1'b1) ?
                           {ZEROFILL[31:6], VICTrVectCntl14} :
                           ((VectCntl15RdEn == 1'b1) ?
                           {ZEROFILL[31:6], VICTrVectCntl15} :
                           (ZEROFILL))))))))))))))));

// ---------------------------------------------------------------------
// Assigning Internal Read Data bus
// ---------------------------------------------------------------------
assign RdData           = (RdData1 | RdData2 | RdData3);

// ---------------------------------------------------------------------
// Inserting Wait States
// ---------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WaitStatesSeq 
  if (HRESETn == 1'b0)
    WaitCount <= 0;
  else
    if (DeviceSel == 1'b1)
      if (WaitStRegEn == 1'b1 || WaitCount != 0)
        if (WaitCount < `WAITSTATES)
          WaitCount <= WaitCount + 1;
        else
          WaitCount <= 0;
      else
        WaitCount <= 0;
    else
      WaitCount <= 0;
end // p_WaitStatesSeq

// ---------------------------------------------------------------------
// HREADYOUT Generation
// ---------------------------------------------------------------------
always @(HRESETn or DeviceSel or WaitStRegEn or WaitCount)
begin : p_HREADYComb
  if (HRESETn ==  1'b0)
    HREADYOUT <= `TR_H_READY;
  else if (DeviceSel ==  1'b1)
    if (WaitStRegEn == 1'b1)
      if (WaitCount == `WAITSTATES)
        HREADYOUT <= `TR_H_READY;
      else
        HREADYOUT <= `TR_H_WAIT;
    else
      HREADYOUT <= `TR_H_READY;
  else
    HREADYOUT <= `TR_H_READY;
end // p_HREADYComb

// ---------------------------------------------------------------------
// AHB Output Assignments
// ---------------------------------------------------------------------
assign HRDATA           = (RdAccess == 1'b1) ? RdData : (ZEROFILL);

assign HRESP            = `TR_H_OKAY;

endmodule

// --============================== End ==============================--
