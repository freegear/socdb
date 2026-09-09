// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacAhbSlaveIf.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMA controller AHB Slave Interface module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacAhbSlaveIf (
// Inputs
                       // AHB signals
                       HCLK,
                       HRESETn,
                       HSELDMAC,
                       HWRITE,
                       HTRANS,
                       HWDATA,
                       HADDR,
                       HSIZE,
                       HREADYIN,
                       Revision,
                       Ch0HRDATA,
                       Ch1HRDATA,
                       Ch2HRDATA,
                       Ch3HRDATA,
                       Ch4HRDATA,
                       Ch5HRDATA,
                       Ch6HRDATA,
                       Ch7HRDATA,
                       // DMA requests from the peripherals
                       DMACBREQ,
                       DMACLBREQ,
                       DMACSREQ,
                       DMACLSREQ,
                       // The double synchronised versions of the DMA Requests
                       DMACSREQSync,
                       DMACBREQSync,
                       DMACLSREQSync,
                       DMACLBREQSync,
                       // Signals taken in for integration test read purpose
                       // DMAC response signals
                       DMACCLR,
                       DMACTC,
                       // DMAC interrupt request signals
                       DMACINTERR,
                       DMACINTTC,
                       // Channel enabled status
                       ChannelEn0,
                       ChannelEn1,
                       ChannelEn2,
                       ChannelEn3,
                       ChannelEn4,
                       ChannelEn5,
                       ChannelEn6,
                       ChannelEn7,
                       // Channels interrupt status
                       // Error Interrupt status
                       IntErrCh0,
                       IntErrCh1,
                       IntErrCh2,
                       IntErrCh3,
                       IntErrCh4,
                       IntErrCh5,
                       IntErrCh6,
                       IntErrCh7,
                       // TC Interrupt status
                       IntTCCh0,
                       IntTCCh1,
                       IntTCCh2,
                       IntTCCh3,
                       IntTCCh4,
                       IntTCCh5,
                       IntTCCh6,
                       IntTCCh7,
                       // Raw Error Interrupt status
                       RawIntErrCh0,
                       RawIntErrCh1,
                       RawIntErrCh2,
                       RawIntErrCh3,
                       RawIntErrCh4,
                       RawIntErrCh5,
                       RawIntErrCh6,
                       RawIntErrCh7,
                       // Raw TC Interrupt status
                       RawIntTCCh0,
                       RawIntTCCh1,
                       RawIntTCCh2,
                       RawIntTCCh3,
                       RawIntTCCh4,
                       RawIntTCCh5,
                       RawIntTCCh6,
                       RawIntTCCh7,
                       // Clear DMA REQ signals from all the channels
                       // from DmacRspRoute module
                       ClearReq,
                       // Clear in case of error response
                       ErrClrReq0,
                       ErrClrReq1,
                       ErrClrReq2,
                       ErrClrReq3,
                       ErrClrReq4,
                       ErrClrReq5,
                       ErrClrReq6,
                       ErrClrReq7,
// Outputs
                       // AHB signals
                       HREADYOUT,
                       HRESP,
                       HRDATA,
                       // Register Read-write selects
                       // Write enable signal for the registers
                       RegHWrite,
                       RegAddress,
                       // Select signals for channels for read/write channel
                       // registers
                       DmacChannelSel0,
                       DmacChannelSel1,
                       DmacChannelSel2,
                       DmacChannelSel3,
                       DmacChannelSel4,
                       DmacChannelSel5,
                       DmacChannelSel6,
                       DmacChannelSel7,
                       // Gated versions of the DMA requests
                       MskdDMACSREQ,
                       MskdDMACBREQ,
                       MskdDMACLSREQ,
                       MskdDMACLBREQ,
                       // Interrupt clear signals for the channels
                       ClrIntTC0,
                       ClrIntTC1,
                       ClrIntTC2,
                       ClrIntTC3,
                       ClrIntTC4,
                       ClrIntTC5,
                       ClrIntTC6,
                       ClrIntTC7,
                       ClrIntErr0,
                       ClrIntErr1,
                       ClrIntErr2,
                       ClrIntErr3,
                       ClrIntErr4,
                       ClrIntErr5,
                       ClrIntErr6,
                       ClrIntErr7,
                       // Request signals to the channels
                       DMACBREQCh,
                       DMACLBREQCh,
                       DMACSREQCh,
                       DMACLSREQCh,
                       // Integration test registers
                       ITEN,
                       DMACITOP1,
                       DMACITOP2,
                       DMACITOP3,
                       // Other non-channel specific signals
                       DMACEn,
                       BigEndianM1,
                       BigEndianM2
                       );

// Inputs
// AHB signals
input         HCLK;             // AHB clock
input         HRESETn;          // AHB Reset
input         HSELDMAC;         // Slave Select for DMAC
input         HWRITE;           // Data transfer direction
input         HTRANS;           // Type of transfer on AHB. Bit 1 of
                                // HTRANS on AHB
input  [15:0] HWDATA;           // AHB Write Data bus
input  [11:2] HADDR;            // AHB slave address
input   [2:0] HSIZE;            // Width of the transfer on AHB
input         HREADYIN;         // Ready response on AHB from previous
                                // Slave
input   [3:0] Revision;         // Revision number from DmacRevAnd
input  [31:0] Ch0HRDATA;        // Read data bus from channel 0
input  [31:0] Ch1HRDATA;        // Read data bus from channel 1
input  [31:0] Ch2HRDATA;        // Read data bus from channel 2
input  [31:0] Ch3HRDATA;        // Read data bus from channel 3
input  [31:0] Ch4HRDATA;        // Read data bus from channel 4
input  [31:0] Ch5HRDATA;        // Read data bus from channel 5
input  [31:0] Ch6HRDATA;        // Read data bus from channel 6
input  [31:0] Ch7HRDATA;        // Read data bus from channel 7
// DMA requests from the peripherals
input  [15:0] DMACBREQ;         // DMA burst transfer request
input  [15:0] DMACLBREQ;        // DMA last burst transfer request
input  [15:0] DMACSREQ;         // DMA single transfer request
input  [15:0] DMACLSREQ;        // DMA last single transfer request
// The double synchronised versions of the DMA Requests
input  [15:0] DMACSREQSync;     // Synchronised signal for DMACSREQ
input  [15:0] DMACBREQSync;     // Synchronised signal for DMACBREQ
input  [15:0] DMACLSREQSync;    // Synchronised signal for DMACLSREQ
input  [15:0] DMACLBREQSync;    // Synchronised signal for DMACLBREQ
// Signals taken in for integration test read purpose
// DMAC response signals
input  [15:0] DMACCLR;          // DMAC request clear
input  [15:0] DMACTC;           // DMAC terminal count
// DMAC interrupt request signals
input         DMACINTERR;       // DMAC error interrupt request
input         DMACINTTC;        // DMAC terminal count interrupt
                                // request
// Channel enabled status
input         ChannelEn0;       // Channel 0 enable status
input         ChannelEn1;       // Channel 1 enable status
input         ChannelEn2;       // Channel 2 enable status
input         ChannelEn3;       // Channel 3 enable status
input         ChannelEn4;       // Channel 4 enable status
input         ChannelEn5;       // Channel 5 enable status
input         ChannelEn6;       // Channel 6 enable status
input         ChannelEn7;       // Channel 7 enable status
// Channels interrupt status
// Error Interrupt status
input         IntErrCh0;        // Error Interrupt for channel 0
input         IntErrCh1;        // Error Interrupt for channel 1
input         IntErrCh2;        // Error Interrupt for channel 2
input         IntErrCh3;        // Error Interrupt for channel 3
input         IntErrCh4;        // Error Interrupt for channel 4
input         IntErrCh5;        // Error Interrupt for channel 5
input         IntErrCh6;        // Error Interrupt for channel 6
input         IntErrCh7;        // Error Interrupt for channel 7
// TC Interrupt status
input         IntTCCh0;         // TC Interrupt for channel 0
input         IntTCCh1;         // TC Interrupt for channel 1
input         IntTCCh2;         // TC Interrupt for channel 2
input         IntTCCh3;         // TC Interrupt for channel 3
input         IntTCCh4;         // TC Interrupt for channel 4
input         IntTCCh5;         // TC Interrupt for channel 5
input         IntTCCh6;         // TC Interrupt for channel 6
input         IntTCCh7;         // TC Interrupt for channel 7
// Raw Error Interrupt status
input         RawIntErrCh0;     // Raw Error Interrupt for Channel 0
input         RawIntErrCh1;     // Raw Error Interrupt for Channel 1
input         RawIntErrCh2;     // Raw Error Interrupt for Channel 2
input         RawIntErrCh3;     // Raw Error Interrupt for Channel 3
input         RawIntErrCh4;     // Raw Error Interrupt for Channel 4
input         RawIntErrCh5;     // Raw Error Interrupt for Channel 5
input         RawIntErrCh6;     // Raw Error Interrupt for Channel 6
input         RawIntErrCh7;     // Raw Error Interrupt for Channel 7
// Raw TC Interrupt status
input         RawIntTCCh0;      // Raw TC Interrupt for Channel 0
input         RawIntTCCh1;      // Raw TC Interrupt for Channel 1
input         RawIntTCCh2;      // Raw TC Interrupt for Channel 2
input         RawIntTCCh3;      // Raw TC Interrupt for Channel 3
input         RawIntTCCh4;      // Raw TC Interrupt for Channel 4
input         RawIntTCCh5;      // Raw TC Interrupt for Channel 5
input         RawIntTCCh6;      // Raw TC Interrupt for Channel 6
input         RawIntTCCh7;      // Raw TC Interrupt for Channel 7
// Clear DMA REQ signals from all the channels from DmacRspRoute module
input  [15:0] ClearReq;         // Clear DMAREQ from Channels
// Clear in case of error response
input  [15:0] ErrClrReq0;       // Clear from Channel0 for Error
input  [15:0] ErrClrReq1;       // Clear from Channel1 for Error
input  [15:0] ErrClrReq2;       // Clear from Channel2 for Error
input  [15:0] ErrClrReq3;       // Clear from Channel3 for Error
input  [15:0] ErrClrReq4;       // Clear from Channel4 for Error
input  [15:0] ErrClrReq5;       // Clear from Channel5 for Error
input  [15:0] ErrClrReq6;       // Clear from Channel6 for Error
input  [15:0] ErrClrReq7;       // Clear from Channel7 for Error

// Outputs
// AHB signals
output        HREADYOUT;        // Ready response from DMAC AHB slave interface
output  [1:0] HRESP;            // Response to AHB from DMAC AHB slave interface
output [31:0] HRDATA;           // Read data bus to AHB from AHB slave interface
// Register Read-write selects
// Write enable signal for the registers
output        RegHWrite;        // Write enable signal to DMAC channel registers
output  [4:2] RegAddress;       // Registered lower order address bits
                                // for register addressing
// Select signals for channels for read/write channel registers
output        DmacChannelSel0;  // Read-Write Select for channel 0
output        DmacChannelSel1;  // Read-Write Select for channel 1
output        DmacChannelSel2;  // Read-Write Select for channel 2
output        DmacChannelSel3;  // Read-Write Select for channel 3
output        DmacChannelSel4;  // Read-Write Select for channel 4
output        DmacChannelSel5;  // Read-Write Select for channel 5
output        DmacChannelSel6;  // Read-Write Select for channel 6
output        DmacChannelSel7;  // Read-Write Select for channel 7
// Gated versions of the DMA requests
output [15:0] MskdDMACSREQ;     // Gated DMACSREQ with DMACEn
output [15:0] MskdDMACBREQ;     // Gated DMACBREQ with DMACEn
output [15:0] MskdDMACLSREQ;    // Gated DMACLSREQ with DMACEn
output [15:0] MskdDMACLBREQ;    // Gated DMACLBREQ with DMACEn
// Interrupt clear signals for the channels
output        ClrIntTC0;        // TC Interrupt clear for channel 0
output        ClrIntTC1;        // TC Interrupt clear for channel 1
output        ClrIntTC2;        // TC Interrupt clear for channel 2
output        ClrIntTC3;        // TC Interrupt clear for channel 3
output        ClrIntTC4;        // TC Interrupt clear for channel 4
output        ClrIntTC5;        // TC Interrupt clear for channel 5
output        ClrIntTC6;        // TC Interrupt clear for channel 6
output        ClrIntTC7;        // TC Interrupt clear for channel 7
output        ClrIntErr0;       // Error Interrupt clear for channel 0
output        ClrIntErr1;       // Error Interrupt clear for channel 1
output        ClrIntErr2;       // Error Interrupt clear for channel 2
output        ClrIntErr3;       // Error Interrupt clear for channel 3
output        ClrIntErr4;       // Error Interrupt clear for channel 4
output        ClrIntErr5;       // Error Interrupt clear for channel 5
output        ClrIntErr6;       // Error Interrupt clear for channel 6
output        ClrIntErr7;       // Error Interrupt clear for channel 7
// Request signals to the channels
output [15:0] DMACBREQCh;       // DMA burst transfer request
output [15:0] DMACLBREQCh;      // DMAC last burst transfer request
output [15:0] DMACSREQCh;       // DMAC single transfer request
output [15:0] DMACLSREQCh;      // DMAC last single transfer request
// Integration test and counter test related register bit values
output        ITEN;             // integration Test enable
output [15:0] DMACITOP1;        // register DMACITOP1
output [15:0] DMACITOP2;        // register DMACITOP2
output  [1:0] DMACITOP3;        // register DMACITOP3
// Other non-channel specific signals
output        DMACEn;           // DMAC Controller Enable
output        BigEndianM1;      // Endian-ness bit for master 1
output        BigEndianM2;      // Endian-ness bit for master 2

// Inputs
// AHB signals
wire          HCLK;             // AHB clock
wire          HRESETn;          // AHB Reset
wire          HSELDMAC;         // Slave Select for DMAC
wire          HWRITE;           // Data transfer direction
wire          HTRANS;           // Type of transfer on AHB. Bit 1 of
                                // HTRANS on AHB
wire   [15:0] HWDATA;           // AHB Write Data bus
wire   [11:2] HADDR;            // AHB slave address
wire    [2:0] HSIZE;            // Width of the transfer on AHB
wire          HREADYIN;         // Ready response on AHB from previous
                                // Slave
wire    [3:0] Revision;         // Revision number from DmacRevAnd
wire   [31:0] Ch0HRDATA;        // Read data bus from channel 0
wire   [31:0] Ch1HRDATA;        // Read data bus from channel 1
wire   [31:0] Ch2HRDATA;        // Read data bus from channel 2
wire   [31:0] Ch3HRDATA;        // Read data bus from channel 3
wire   [31:0] Ch4HRDATA;        // Read data bus from channel 4
wire   [31:0] Ch5HRDATA;        // Read data bus from channel 5
wire   [31:0] Ch6HRDATA;        // Read data bus from channel 6
wire   [31:0] Ch7HRDATA;        // Read data bus from channel 7
// DMA requests from the peripherals
wire   [15:0] DMACBREQ;         // DMA burst transfer request
wire   [15:0] DMACLBREQ;        // DMA last burst transfer request
wire   [15:0] DMACSREQ;         // DMA single transfer request
wire   [15:0] DMACLSREQ;        // DMA last single transfer request
// The double synchronised versions of the DMA Requests
wire   [15:0] DMACSREQSync;     // Synchronised signal for DMACSREQ
wire   [15:0] DMACBREQSync;     // Synchronised signal for DMACBREQ
wire   [15:0] DMACLSREQSync;    // Synchronised signal for DMACLSREQ
wire   [15:0] DMACLBREQSync;    // Synchronised signal for DMACLBREQ
// Signals taken in for integration test read purpose
// DMAC response signals
wire   [15:0] DMACCLR;          // DMAC request clear
wire   [15:0] DMACTC;           // DMAC terminal count
// DMAC interrupt request signals
wire          DMACINTERR;       // DMAC error interrupt request
wire          DMACINTTC;        // DMAC terminal count interrupt
                                // request
// Channel enabled status
wire          ChannelEn0;       // Channel 0 enable status
wire          ChannelEn1;       // Channel 1 enable status
wire          ChannelEn2;       // Channel 2 enable status
wire          ChannelEn3;       // Channel 3 enable status
wire          ChannelEn4;       // Channel 4 enable status
wire          ChannelEn5;       // Channel 5 enable status
wire          ChannelEn6;       // Channel 6 enable status
wire          ChannelEn7;       // Channel 7 enable status
// Channels interrupt status
// Error Interrupt status
wire          IntErrCh0;        // Error Interrupt for channel 0
wire          IntErrCh1;        // Error Interrupt for channel 1
wire          IntErrCh2;        // Error Interrupt for channel 2
wire          IntErrCh3;        // Error Interrupt for channel 3
wire          IntErrCh4;        // Error Interrupt for channel 4
wire          IntErrCh5;        // Error Interrupt for channel 5
wire          IntErrCh6;        // Error Interrupt for channel 6
wire          IntErrCh7;        // Error Interrupt for channel 7
// TC Interrupt status
wire          IntTCCh0;         // TC Interrupt for channel 0
wire          IntTCCh1;         // TC Interrupt for channel 1
wire          IntTCCh2;         // TC Interrupt for channel 2
wire          IntTCCh3;         // TC Interrupt for channel 3
wire          IntTCCh4;         // TC Interrupt for channel 4
wire          IntTCCh5;         // TC Interrupt for channel 5
wire          IntTCCh6;         // TC Interrupt for channel 6
wire          IntTCCh7;         // TC Interrupt for channel 7
// Raw Error Interrupt status
wire          RawIntErrCh0;     // Raw Error Interrupt for Channel 0
wire          RawIntErrCh1;     // Raw Error Interrupt for Channel 1
wire          RawIntErrCh2;     // Raw Error Interrupt for Channel 2
wire          RawIntErrCh3;     // Raw Error Interrupt for Channel 3
wire          RawIntErrCh4;     // Raw Error Interrupt for Channel 4
wire          RawIntErrCh5;     // Raw Error Interrupt for Channel 5
wire          RawIntErrCh6;     // Raw Error Interrupt for Channel 6
wire          RawIntErrCh7;     // Raw Error Interrupt for Channel 7
// Raw TC Interrupt status
wire          RawIntTCCh0;      // Raw TC Interrupt for Channel 0
wire          RawIntTCCh1;      // Raw TC Interrupt for Channel 1
wire          RawIntTCCh2;      // Raw TC Interrupt for Channel 2
wire          RawIntTCCh3;      // Raw TC Interrupt for Channel 3
wire          RawIntTCCh4;      // Raw TC Interrupt for Channel 4
wire          RawIntTCCh5;      // Raw TC Interrupt for Channel 5
wire          RawIntTCCh6;      // Raw TC Interrupt for Channel 6
wire          RawIntTCCh7;      // Raw TC Interrupt for Channel 7
// Clear DMA REQ signals from all the channels from DmacRspRoute module
wire   [15:0] ClearReq;         // Clear DMAREQ from Channels
// Clear in case of error response
wire   [15:0] ErrClrReq0;       // Clear from Channel0 for Error
wire   [15:0] ErrClrReq1;       // Clear from Channel1 for Error
wire   [15:0] ErrClrReq2;       // Clear from Channel2 for Error
wire   [15:0] ErrClrReq3;       // Clear from Channel3 for Error
wire   [15:0] ErrClrReq4;       // Clear from Channel4 for Error
wire   [15:0] ErrClrReq5;       // Clear from Channel5 for Error
wire   [15:0] ErrClrReq6;       // Clear from Channel6 for Error
wire   [15:0] ErrClrReq7;       // Clear from Channel7 for Error

// Outputs
// AHB signals
wire          HREADYOUT;        // Ready response from DMAC AHB slave
                                // interface
wire    [1:0] HRESP;            // Response to AHB from DMAC AHB slave
                                // interface
wire   [31:0] HRDATA;           // Read data bus to AHB from AHB slave
                                // interface
// Register Read-write selects
// Write enable signal for the registers
wire          RegHWrite;        // Write enable signal to DMAC channel
                                // registers
wire    [4:2] RegAddress;       // Registered lower order address bits
                                // for register addressing
// Select signals for channels for read/write channel registers
reg           DmacChannelSel0;  // Read-Write Select for channel 0
reg           DmacChannelSel1;  // Read-Write Select for channel 1
reg           DmacChannelSel2;  // Read-Write Select for channel 2
reg           DmacChannelSel3;  // Read-Write Select for channel 3
reg           DmacChannelSel4;  // Read-Write Select for channel 4
reg           DmacChannelSel5;  // Read-Write Select for channel 5
reg           DmacChannelSel6;  // Read-Write Select for channel 6
reg           DmacChannelSel7;  // Read-Write Select for channel 7
// Gated versions of the DMA requests
wire   [15:0] MskdDMACSREQ;     // Gated DMACSREQ with DMACEn
wire   [15:0] MskdDMACBREQ;     // Gated DMACBREQ with DMACEn
wire   [15:0] MskdDMACLSREQ;    // Gated DMACLSREQ with DMACEn
wire   [15:0] MskdDMACLBREQ;    // Gated DMACLBREQ with DMACEn
// Interrupt clear signals for the channels
wire          ClrIntTC0;        // TC Interrupt clear for channel 0
wire          ClrIntTC1;        // TC Interrupt clear for channel 1
wire          ClrIntTC2;        // TC Interrupt clear for channel 2
wire          ClrIntTC3;        // TC Interrupt clear for channel 3
wire          ClrIntTC4;        // TC Interrupt clear for channel 4
wire          ClrIntTC5;        // TC Interrupt clear for channel 5
wire          ClrIntTC6;        // TC Interrupt clear for channel 6
wire          ClrIntTC7;        // TC Interrupt clear for channel 7
wire          ClrIntErr0;       // Error Interrupt clear for channel 0
wire          ClrIntErr1;       // Error Interrupt clear for channel 1
wire          ClrIntErr2;       // Error Interrupt clear for channel 2
wire          ClrIntErr3;       // Error Interrupt clear for channel 3
wire          ClrIntErr4;       // Error Interrupt clear for channel 4
wire          ClrIntErr5;       // Error Interrupt clear for channel 5
wire          ClrIntErr6;       // Error Interrupt clear for channel 6
wire          ClrIntErr7;       // Error Interrupt clear for channel 7
// Request signals to the channels
wire   [15:0] DMACBREQCh;       // DMA burst transfer request
wire   [15:0] DMACLBREQCh;      // DMAC last burst transfer request
wire   [15:0] DMACSREQCh;       // DMAC single transfer request
wire   [15:0] DMACLSREQCh;      // DMAC last single transfer request
// Integration test related registers
wire          ITEN;             // integration Test enable
wire   [15:0] DMACITOP1;        // register DMACITOP1
wire   [15:0] DMACITOP2;        // register DMACITOP2
wire    [1:0] DMACITOP3;        // register DMACITOP3
// Other non-channel specific signals
wire          DMACEn;           // DMAC Controller Enable
wire          BigEndianM1;      // Endian-ness bit for master 1
wire          BigEndianM2;      // Endian-ness bit for master 2

// -----------------------------------------------------------------------------
//
//                               DmacAhbSlaveIf
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module decodes AHB accesses and generates the select signals to the
// registers residing in the module and also for the registers residing in the
// channels. Also implements the common registers of DMA controller. This
// generated the HRDATA from the DMA controller for the AHB when read is done
// from registers in DMA controller through AHB.
// In case of writes to DMA controller registers it generates write enable along
// with the individual select for the registers.
//
//   The slave interface registers the information whether it has been selected
// or not in the register called DMACSlaveState.
// SELECTED indicates that the DMAC Slave is selected and NOTSELECTED indicates
// that the DMAC Slave is not selected. The Interface drives required response
// signals to AHB when DMA controller slave is selected.
//   In case if the read/or write is done for DMA registers is not of WORD size
// then the Interface drives the EROOR response to the AHB.
//
// The registers map for the DMA controller registers is as follows :
// -----------------------------------------------------------------------------
//               DMA Controller Functional Mode Register Map
// -----------------------------------------------------------------------------
// Offset| RegisterName | R/W  |  Read- | Write- |    Description
//       |              |      |  Width | Width  |
// -----------------------------------------------------------------------------
//
// 0x000 DMACIntStat       R     8-bits     -     Interrupt status
// 0x004 DMACIntTCStat     R     8-bits     -     TC Interrupt status
// 0x008 DMACIntTCClr        W     -      8-bits  TC Interrupt clear
// 0x00C DMACIntErrStat    R     8-bits     -     Error Interrupt status
// 0x010 DMACIntErrClr       W     -      8-bits  Error Interrupt clear
// 0x014 DMACRawIntTC      R     8-bits     -     Raw TC Interrupt status
// 0x018 DMACRawIntErr     R     8-bits     -     Raw Error Interrupt status
// 0x01C DMACEnbldChns     R/W   8-bits   8-bits  Channel Enables
// 0x020 DMACSoftBReq      R/W  16-bits  16-bits  Soft DMA burst Request
// 0x024 DMACSoftSReq      R/W  16-bits  16-bits  Soft DMA single Request
// 0x028 DMACSoftLBReq     R/W  16-bits  16-bits  Soft DMA L-burst Request
// 0x02C DMACSoftLSReq     R/W  16-bits  16-bits  Soft DMA L-single Request
// 0x030 DMACConfig        R/W   3-bits   3-bits  DMAC configuration
// 0x034 DMACSync          R/W  16-bits  16-bits  DMAC requests select control
// -----------------------------------------------------------------------------
//               DMAC Controller Channel Register Map
// -----------------------------------------------------------------------------
// 0x100 DMACC0SrcAddr     R/W  32-bits  32-bits  Source Address register0
// 0x104 DMACC0DestAddr    R/W  32-bits  32-bits  Destination Address reg0
// 0x108 DMACC0LLIReg      R/W  31-bits  31-bits  Next Linked list Address0
// 0x10C DMACC0Control     R/W  32-bits  32-bits  Channel Control register0
// 0x110 DMACC0Config      R/W  19-bits  19-bits  Channel Config register0
//
// 0x120 DMACC1SrcAddr     R/W  32-bits  32-bits  Source Address register1
// 0x124 DMACC1DestAddr    R/W  32-bits  32-bits  Destination Address reg1
// 0x128 DMACC1LLIReg      R/W  31-bits  31-bits  Next Linked list Address1
// 0x12C DMACC1Control     R/W  32-bits  32-bits  Channel Control register1
// 0x130 DMACC1Config      R/W  19-bits  19-bits  Channel Config register1
//
// 0x140 DMACC2SrcAddr     R/W  32-bits  32-bits  Source Address register2
// 0x144 DMACC2DestAddr    R/W  32-bits  32-bits  Destination Address reg2
// 0x148 DMACC2LLIReg      R/W  31-bits  31-bits  Next Linked list Address2
// 0x14C DMACC2Control     R/W  32-bits  32-bits  Channel Control register2
// 0x150 DMACC2Config      R/W  19-bits  19-bits  Channel Config register2
//
// 0x160 DMACC3SrcAddr     R/W  32-bits  32-bits  Source Address register3
// 0x164 DMACC3DestAddr    R/W  32-bits  32-bits  Destination Address reg3
// 0x168 DMACC3LLIReg      R/W  31-bits  31-bits  Next Linked list Address3
// 0x16C DMACC3Control     R/W  32-bits  32-bits  Channel Control register3
// 0x170 DMACC3Config      R/W  19-bits  19-bits  Channel Config register3
//
// 0x180 DMACC4SrcAddr     R/W  32-bits  32-bits  Source Address register4
// 0x184 DMACC4DestAddr    R/W  32-bits  32-bits  Destination Address reg4
// 0x188 DMACC4LLIReg      R/W  31-bits  31-bits  Next Linked list Address4
// 0x18C DMACC4Control     R/W  32-bits  32-bits  Channel Control register4
// 0x190 DMACC4Config      R/W  19-bits  19-bits  Channel Config register4
//
// 0x1A0 DMACC5SrcAddr     R/W  32-bits  32-bits  Source Address register5
// 0x1A4 DMACC5DestAddr    R/W  32-bits  32-bits  Destination Address reg5
// 0x1A8 DMACC5LLIReg      R/W  31-bits  31-bits  Next Linked list Address5
// 0x1AC DMACC5Control     R/W  32-bits  32-bits  Channel Control register5
// 0x1B0 DMACC5Config      R/W  19-bits  19-bits  Channel Config register5
//
// 0x1C0 DMACC6SrcAddr     R/W  32-bits  32-bits  Source Address register6
// 0x1C4 DMACC6DestAddr    R/W  32-bits  32-bits  Destination Address reg6
// 0x1C8 DMACC6LLIReg      R/W  31-bits  31-bits  Next Linked list Address6
// 0x1CC DMACC6Control     R/W  32-bits  32-bits  Channel Control register6
// 0x1D0 DMACC6Config      R/W  19-bits  19-bits  Channel Config register6
//
// 0x1E0 DMACC7SrcAddr     R/W  32-bits  32-bits  Source Address register7
// 0x1E4 DMACC7DestAddr    R/W  32-bits  32-bits  Destination Address reg7
// 0x1E8 DMACC7LLIReg      R/W  31-bits  31-bits  Next Linked list Address7
// 0x1EC DMACC7Control     R/W  32-bits  32-bits  Channel Control register7
// 0x1F0 DMACC7Config      R/W  19-bits  19-bits  Channel Config register7
// -----------------------------------------------------------------------------
//               DMA Controller Test Mode Register Map
// -----------------------------------------------------------------------------
// 0x500  DMACTCR          R/W   1-bit   1-bit    Test Control
// 0x504  DMACITOP1        R/W   16-bits 16-bits  Output Set/Read
// 0x508  DMACITOP2        R/W   16-bits 16-bits  Output Set/Read
// 0x50C  DMACITOP3        R/W   2-bits  2-bits   Output Set/Read
// -----------------------------------------------------------------------------
//               DMA Controller Identification Register Map
// -----------------------------------------------------------------------------
// 0xFE0  DMACPeriphId0    R     8-bits     -    Peripheral Identification
//                                               register bits 7:0
// 0xFE4  DMACPeriphId1    R     8-bits     -    Peripheral Identification
//                                               register bits 15:8
// 0xFE8  DMACPeriphId2    R     8-bits     -    Peripheral Identification
//                                               register bits 23:16
// 0xFEC  DMACPeriphId3    R     8-bits     -    Peripheral Identification
//                                               register bits 31:24
// 0xFF0  DMACPCellId0     R     8-bits     -    PrimeCell Identification
//                                               register bits 7:0
// 0xFF4  DMACPCellId1     R     8-bits     -    PrimeCell Identification
//                                               register bits 15:8
// 0xFF8  DMACPCellId2     R     8-bits     -    PrimeCell Identification
//                                               register bits 23:16
// 0xFFC  DMACPCellId3     R     8-bits     -    PrimeCell Identification
//                                               register bits 31:24
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [15:0] iMskdDMACSREQ;
// Internal version of Gated DMACSREQ with DMACEn

wire [15:0] iMskdDMACBREQ;
// Internal version of Gated DMACBREQ with DMACEn

wire [15:0] iMskdDMACLSREQ;
// Internal version of Gated DMACLSREQ with DMACEn

wire [15:0] iMskdDMACLBREQ;
// Internal version of Gated DMACLBREQ with DMACEn

wire [15:0] iDMACSREQCh;
// DMACSREQ request for channel - internal signal

wire [15:0] iDMACBREQCh;
// DMACBREQ request for channel - internal signal

wire [15:0] iDMACLSREQCh;
// DMACLSREQ request for channel - internal signal

wire [15:0] iDMACLBREQCh;
// DMACLBREQ request for channel - internal signal

wire [15:0] ErrClrReq;
// ORed version of the clear from all the channels in case of error

wire        iDMACEn;
// DMA Controller Enable signal - internal

wire        iITEN;
// Integration test enable signal - internal

wire  [1:0] IntraOP3;
// Intra chip output signals for read of DMACITOP3 register for integration
// tests

wire  [7:0] DMACEnbldChns;
// The signal to return the status of the channel enabled or not

wire  [7:0] DMACIntTCStat;
// DMAC INTTC status interrupt register

wire  [7:0] DMACIntErrStat;
// DMAC INTERR status interrupt register

wire  [7:0] DMACIntStat;
// DMAC Combined interrupt status register

wire  [7:0] DMACRawIntTC;
// DMAC Raw INTTC interrupt status register

wire  [7:0] DMACRawIntErr;
// DMAC Raw INTERR interrupt status register

wire  [2:0] NxtDMACConfig;
// D Input of DMACConfig register

wire [15:0] NxtDMACSync;
// D Input of DMACSync register

wire        NxtDMACTCR;
// D Input of DMACTCR register

wire [15:0] NxtDMACITOP1;
// D Input of DMACITOP1 register

wire [15:0] NxtDMACITOP2;
// D Input of DMACITOP2 register

wire  [1:0] NxtDMACITOP3;
// D Input of DMACITOP3 register

wire [15:0] MuxDMACSREQ;
// The Multiplexed DMA request signal from synchronised and unsynchronised
// version of the DMACSREQ

wire [15:0] MuxDMACBREQ;
// The Multiplexed DMA request signal from synchronised and unsynchronised
// version of the DMACBREQ

wire [15:0] MuxDMACLSREQ;
// The Multiplexed DMA request signal from synchronised and unsynchronised
// version of the DMACLSREQ

wire [15:0] MuxDMACLBREQ;
// The Multiplexed DMA request signal from synchronised and unsynchronised
// version of the DMACLBREQ

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         iRegHWrite;
// Register write signal

reg   [1:0] iHRESP;
// DMAC Slave response

reg         iHREADYOUT;
// DMAC Slave wait signal

reg  [15:0] BuffDMACSREQ;
// Buffered version of Gated DMACSREQ with DMACEn

reg  [15:0] BuffDMACBREQ;
// Buffered version of Gated DMACBREQ with DMACEn

reg  [15:0] BuffDMACLSREQ;
// Buffered version of Gated DMACLSREQ with DMACEn

reg  [15:0] BuffDMACLBREQ;
// Buffered version of Gated DMACLBREQ with DMACEn

// Channel requests
reg  [15:0] iDMACITOP1;
// Integration test output register - internal

reg  [15:0] iDMACITOP2;
// Integration test output register - internal

reg   [1:0] iDMACITOP3;
// Integration test output register - internal

reg         DmacIntTCClrWr;
// Write Select for DMACIntTCClr

reg         DmacIntErrClrWr;
// Write Select for DMACIntErrClr

reg         DmacITCRWr;
// Read-Write Select for DMACTCR

reg         DmacITOP1Wr;
// Read-Write Select for DMACITOP1

reg         DmacITOP2Wr;
// Read-Write Select for DMACITOP2

reg         DmacITOP3Wr;
// Read-Write Select for DMACITOP3

reg         DmacSoftBRqWr;
// Read-Write Select for DMACSoftBReq

reg         DmacSoftSRqWr;
// Read-Write Select for DMACSoftSReq

reg         DmacSoftLBRqWr;
// Read-Write Select for DMACSoftBReq

reg         DmacSoftLSRqWr;
// Read-Write Select for DMACSoftSReq

reg         DmacConfigWr;
// Read-Write Select for DMACConfig

reg         DmacSyncWr;
// Read-Write Select for DMACSync

reg  [31:0] RegHRDATA;
// Read data bus from common registers

reg         DMACSlaveState;
// DMAC Slave State condition indication

reg  [11:2] HAddrBuff;
// Registered version of the HADDR

reg         NxtSlaveState;
// D input of DMACSlaveState flip-flop

reg   [1:0] NxtHResp;
// D input of iHRESP flip-flop to drive the responses

reg         NxtHReadyOut;
// D input of iHREADYOUT flip-flop to drive the wait responses

reg  [11:2] NxtHAddrBuff;
// D Input of HAddrBuff

reg         NxtHWrite;
// D Input of iRegHWrite

// DMAC Registers are defined here
reg  [15:0] DMACSoftSReq;
// Software DMASREQ Request register

reg  [15:0] DMACSoftBReq;
// Software DMABREQ Request register

reg  [15:0] DMACSoftLSReq;
// Software DMALSREQ Request register

reg  [15:0] DMACSoftLBReq;
// Software DMALBREQ Request register

reg   [2:0] DMACConfig;
// DMA configuration register

reg  [15:0] DMACSync;
// DMA request synchronisation control register

reg         DMACTCR;
// DMA test control register

reg  [15:0] NxtDMACSftSRq;
// D Input of DMACSoftSReq register

reg  [15:0] NxtDMACSftBRq;
// D Input of DMACSoftBReq register

reg  [15:0] NxtDMACSftLSRq;
// D Input of DMACSoftLSReq register

reg  [15:0] NxtDMACSftLBRq;
// D Input of DMACSoftLBReq register

//Include Parameters File
`include "DmacParams.v"

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
// Combinatorial assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Assigning the HRDATA from the ORing of the buffered data from the channels
// and the data from registers with in the module
// -----------------------------------------------------------------------------
assign HRDATA           = Ch0HRDATA | Ch1HRDATA | Ch2HRDATA | Ch3HRDATA |
                           Ch4HRDATA | Ch5HRDATA | Ch6HRDATA | Ch7HRDATA |
                            RegHRDATA;

// -----------------------------------------------------------------------------
// Slave Interface of the DMA controller driving out the slave responses on to
// the AHB, and registering the Address and write information from the AHB when
// the slave is selected.
// o The Slave gives ERROR response in case of NON-WORD access.
// o The Slave inserts one WAIT state in case of all channel registers read
// o It drives out OKAY response when it is NOT selected
// o It drives the OKAY response when it is accessed for WORD transfers.
// -----------------------------------------------------------------------------
always @(HSELDMAC or HWRITE or HTRANS or HADDR or HSIZE or HREADYIN or
         DMACSlaveState or HAddrBuff or iHRESP or iRegHWrite or iHREADYOUT)
begin : p_SlaveStateComb
  NxtSlaveState    = DMACSlaveState;
  NxtHResp         = iHRESP;
  NxtHAddrBuff     = HAddrBuff;
  NxtHWrite        = iRegHWrite;
  NxtHReadyOut     = iHREADYOUT;
  // The DMA controller slave responses and select signals driving
  // Here the HREADYOUT is checked to check whether previous transfer was waited
  if (iHREADYOUT == 1'b1)
    begin
      if ((HSELDMAC == 1'b1) & (HREADYIN == 1'b1))
        begin
          if (HTRANS == 1'b1)
            begin
              if (HSIZE == `WORD_ACCESS)
                begin
                  NxtSlaveState    = `ST_SLAVE_SELECTED;
                  NxtHResp         = `HRESP_OKAY;
                  NxtHAddrBuff     = HADDR;
                  NxtHWrite        = HWRITE;
                  // For the channel registers we have to insert WAIT states in
                  // case of read operation in case of write operation there
                  // should be no WAIT state added
                  if (HWRITE == 1'b1)
                    begin
                      NxtHReadyOut     = 1'b1;
                      // WAIT states are added for full channel register's space
                    end
                  else if ((HADDR[11:10] == 2'b00 &
                             (HADDR[9] == 1'b1 | HADDR[8] == 1'b1)) |
                           (HADDR[11:8] == 4'b0100))
                    begin
                      NxtHReadyOut     = 1'b0;
                    end
                end
              else
                begin
                  NxtHResp         = `HRESP_ERROR;
                  NxtSlaveState    = `ST_SLAVE_NOTSELECTED;
                  NxtHWrite        = 1'b0;
                  NxtHReadyOut     = 1'b0;
                end
            end
          else
            begin
              NxtHResp         = `HRESP_OKAY;
              NxtSlaveState    = `ST_SLAVE_NOTSELECTED;
              NxtHWrite        = 1'b0;
              NxtHReadyOut     = 1'b1;
            end
        end
      else
        begin
          NxtSlaveState    = `ST_SLAVE_NOTSELECTED;
          NxtHResp         = `HRESP_OKAY;
          NxtHWrite        = 1'b0;
          NxtHReadyOut     = 1'b1;
        end
    end
  else
    begin
      NxtSlaveState    = `ST_SLAVE_NOTSELECTED;
      NxtHReadyOut     = 1'b1;
    end

end // p_SlaveStateComb

// -----------------------------------------------------------------------------
// DMAC AHB Slave Interface state machine : Clocked process
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_MainStateMCSeq
  if (HRESETn == 1'b0)
    begin
      DMACSlaveState   <= `ST_SLAVE_NOTSELECTED;
      iHRESP           <= `HRESP_OKAY;
      HAddrBuff        <= 10'b0;
      iRegHWrite       <= 1'b0;
      iHREADYOUT       <= 1'b1;
    end
  else
    begin
      DMACSlaveState   <= NxtSlaveState;
      iHRESP           <= NxtHResp;
      HAddrBuff        <= NxtHAddrBuff;
      iRegHWrite       <= NxtHWrite;
      iHREADYOUT       <= NxtHReadyOut;
    end
end // p_MainStateMCSeq

// -----------------------------------------------------------------------------
// Driving out the lower bits of the address bus to the channel for channel
// register selection
// -----------------------------------------------------------------------------
assign RegAddress       = HAddrBuff[4:2];

// -----------------------------------------------------------------------------
// Generating the Individual Select signal for the registers residing inside the
// channels and with in the slave module of the DMA controller.
// -----------------------------------------------------------------------------
always @(DMACSlaveState or HAddrBuff or iRegHWrite)
begin : p_Add1DecodeComb
  DmacIntTCClrWr   = 1'b0;
  DmacIntErrClrWr  = 1'b0;
  DmacSoftBRqWr    = 1'b0;
  DmacSoftLBRqWr   = 1'b0;
  DmacSoftLSRqWr   = 1'b0;
  DmacSoftSRqWr    = 1'b0;
  DmacConfigWr     = 1'b0;
  DmacSyncWr       = 1'b0;
  DmacITCRWr       = 1'b0;
  DmacITOP1Wr      = 1'b0;
  DmacITOP2Wr      = 1'b0;
  DmacITOP3Wr      = 1'b0;

  if ((DMACSlaveState == `ST_SLAVE_SELECTED) & (iRegHWrite == 1'b1))
    begin
      case (HAddrBuff)
        `HADDR_DMACTCCLR :
           DmacIntTCClrWr   = 1'b1;
        `HADDR_DMACERRCLR :
           DmacIntErrClrWr  = 1'b1;
        `HADDR_DMACSOFTBREQ :
           DmacSoftBRqWr    = 1'b1;
        `HADDR_DMACSOFTSREQ :
           DmacSoftSRqWr    = 1'b1;
        `HADDR_DMACSOFTLBREQ :
           DmacSoftLBRqWr   = 1'b1;
        `HADDR_DMACSOFTLSREQ :
           DmacSoftLSRqWr   = 1'b1;
        `HADDR_DMACCONFIG :
           DmacConfigWr     = 1'b1;
        `HADDR_DMACSYNC :
           DmacSyncWr       = 1'b1;
        `HADDR_DMACTCR :
           DmacITCRWr       = 1'b1;
        `HADDR_DMACITOP1 :
           DmacITOP1Wr      = 1'b1;
        `HADDR_DMACITOP2 :
           DmacITOP2Wr      = 1'b1;
        `HADDR_DMACITOP3 :
           DmacITOP3Wr      = 1'b1;
        default :
          begin
            DmacIntTCClrWr   = 1'b0;
            DmacIntErrClrWr  = 1'b0;
            DmacSoftBRqWr    = 1'b0;
            DmacSoftLBRqWr   = 1'b0;
            DmacSoftLSRqWr   = 1'b0;
            DmacSoftSRqWr    = 1'b0;
            DmacConfigWr     = 1'b0;
            DmacSyncWr       = 1'b0;
            DmacITCRWr       = 1'b0;
            DmacITOP1Wr      = 1'b0;
            DmacITOP2Wr      = 1'b0;
            DmacITOP3Wr      = 1'b0;
          end
      endcase
    end
end // p_Add1DecodeComb

// -----------------------------------------------------------------------------
// Generating the Individual Select signal for the registers residing inside the
// channels and with in the slave module of the DMA controller.
// -----------------------------------------------------------------------------
always @(DMACSlaveState or HAddrBuff)
begin : p_Add2DecodeComb
  DmacChannelSel0  = 1'b0;
  DmacChannelSel1  = 1'b0;
  DmacChannelSel2  = 1'b0;
  DmacChannelSel3  = 1'b0;
  DmacChannelSel4  = 1'b0;
  DmacChannelSel5  = 1'b0;
  DmacChannelSel6  = 1'b0;
  DmacChannelSel7  = 1'b0;

  if (DMACSlaveState == `ST_SLAVE_SELECTED)
    begin
      case (HAddrBuff[11:5])
        `HADDR_DMACCHANNEL0 :
           DmacChannelSel0  = 1'b1;
        `HADDR_DMACCHANNEL1 :
           DmacChannelSel1  = 1'b1;
        `HADDR_DMACCHANNEL2 :
           DmacChannelSel2  = 1'b1;
        `HADDR_DMACCHANNEL3 :
           DmacChannelSel3  = 1'b1;
        `HADDR_DMACCHANNEL4 :
           DmacChannelSel4  = 1'b1;
        `HADDR_DMACCHANNEL5 :
           DmacChannelSel5  = 1'b1;
        `HADDR_DMACCHANNEL6 :
           DmacChannelSel6  = 1'b1;
        `HADDR_DMACCHANNEL7 :
           DmacChannelSel7  = 1'b1;
        default :
          begin
            DmacChannelSel0  = 1'b0;
            DmacChannelSel1  = 1'b0;
            DmacChannelSel2  = 1'b0;
            DmacChannelSel3  = 1'b0;
            DmacChannelSel4  = 1'b0;
            DmacChannelSel5  = 1'b0;
            DmacChannelSel6  = 1'b0;
            DmacChannelSel7  = 1'b0;
          end
      endcase
    end
end // p_Add2DecodeComb

// -----------------------------------------------------------------------------
// Driving intrachip output signals for read purpose
// -----------------------------------------------------------------------------
assign IntraOP3         = ({DMACINTERR, DMACINTTC});

// -----------------------------------------------------------------------------
// Assign the DMACEnbldChns register bits to the corresponding enable signals
// from the channels
// -----------------------------------------------------------------------------
assign DMACEnbldChns    = ({ChannelEn7, ChannelEn6, ChannelEn5,
                           ChannelEn4, ChannelEn3, ChannelEn2,
                           ChannelEn1, ChannelEn0});

// -----------------------------------------------------------------------------
// Assigning the Interrupt status to its respective registers
// -----------------------------------------------------------------------------
assign DMACIntTCStat    = ({IntTCCh7, IntTCCh6, IntTCCh5, IntTCCh4,
                           IntTCCh3, IntTCCh2, IntTCCh1, IntTCCh0});

assign DMACIntErrStat   = ({IntErrCh7, IntErrCh6, IntErrCh5, IntErrCh4,
                           IntErrCh3, IntErrCh2, IntErrCh1, IntErrCh0});

assign DMACIntStat      = (DMACIntTCStat | DMACIntErrStat);

assign DMACRawIntTC     = ({RawIntTCCh7, RawIntTCCh6, RawIntTCCh5,
                           RawIntTCCh4, RawIntTCCh3, RawIntTCCh2,
                           RawIntTCCh1, RawIntTCCh0});

assign DMACRawIntErr    = ({RawIntErrCh7, RawIntErrCh6, RawIntErrCh5,
                           RawIntErrCh4, RawIntErrCh3, RawIntErrCh2,
                           RawIntErrCh1, RawIntErrCh0});

// -----------------------------------------------------------------------------
// Driving out the HRDATA depending on the particular register selected
// -----------------------------------------------------------------------------
always @(DMACSlaveState or HAddrBuff or DMACIntStat or DMACIntTCStat or
         DMACIntErrStat or DMACRawIntTC or DMACRawIntErr or DMACEnbldChns or
         iDMACBREQCh or iDMACSREQCh or iDMACLBREQCh or iDMACLSREQCh or
         DMACConfig or DMACSync or DMACTCR or DMACCLR or DMACTC or IntraOP3 or
         Revision)
begin : p_DataDriveComb
  RegHRDATA        = 32'b0;
  if (DMACSlaveState == `ST_SLAVE_SELECTED)
    begin
      case (HAddrBuff)
        `HADDR_DMACINT :
          RegHRDATA        = {24'b0, DMACIntStat};
        `HADDR_DMACINTTC :
          RegHRDATA        = {24'b0, DMACIntTCStat};
        `HADDR_DMACINTERR :
          RegHRDATA        = {24'b0, DMACIntErrStat};
        `HADDR_DMACRAWINTTC :
          RegHRDATA        = {24'b0, DMACRawIntTC};
        `HADDR_DMACRAWINTERR :
          RegHRDATA        = {24'b0, DMACRawIntErr};
        `HADDR_DMACENABLEDCHNS :
          RegHRDATA        = {24'b0, DMACEnbldChns};
        `HADDR_DMACSOFTBREQ :
          RegHRDATA        = {16'b0, iDMACBREQCh};
        `HADDR_DMACSOFTSREQ :
          RegHRDATA        = {16'b0, iDMACSREQCh};
        `HADDR_DMACSOFTLBREQ :
          RegHRDATA        = {16'b0, iDMACLBREQCh};
        `HADDR_DMACSOFTLSREQ :
          RegHRDATA        = {16'b0, iDMACLSREQCh};
        `HADDR_DMACCONFIG :
          RegHRDATA        = {29'b0, DMACConfig};
        `HADDR_DMACSYNC :
          RegHRDATA        = {16'b0, DMACSync};
        `HADDR_DMACTCR :
          RegHRDATA        = {31'b0, DMACTCR};
        `HADDR_DMACITOP1 :
          RegHRDATA        = {16'b0, DMACCLR};
        `HADDR_DMACITOP2 :
          RegHRDATA        = {16'b0, DMACTC};
        `HADDR_DMACITOP3 :
          RegHRDATA        = {30'b0, IntraOP3};
        `HADDR_DMACPERIPHID0 :
          RegHRDATA        = {24'b0, `PERIPHID0};
        `HADDR_DMACPERIPHID1 :
          RegHRDATA        = {24'b0, `PERIPHID1};
        `HADDR_DMACPERIPHID2 :
          RegHRDATA        = {24'b0, Revision, `PERIPHID2};
        `HADDR_DMACPERIPHID3 :
          RegHRDATA        = {24'b0, `PERIPHID3};
        `HADDR_DMACPCELLID0 :
          RegHRDATA        = {24'b0, `PCELLID0};
        `HADDR_DMACPCELLID1 :
          RegHRDATA        = {24'b0, `PCELLID1};
        `HADDR_DMACPCELLID2 :
          RegHRDATA        = {24'b0, `PCELLID2};
        `HADDR_DMACPCELLID3 :
          RegHRDATA        = {24'b0, `PCELLID3};
        default :
          RegHRDATA        = 32'b0;
      endcase
    end
end // p_DataDriveComb

// -----------------------------------------------------------------------------
// Combinatorial logic for write-able registers.
// -----------------------------------------------------------------------------
assign NxtDMACConfig    = (DmacConfigWr == 1'b1) ? HWDATA[2:0]       :
                           DMACConfig;

assign NxtDMACSync      = (DmacSyncWr == 1'b1) ? HWDATA[15:0]        :
                           DMACSync;

assign NxtDMACTCR       = (DmacITCRWr == 1'b1) ? HWDATA[0] : DMACTCR;

assign NxtDMACITOP1     = (DmacITOP1Wr == 1'b1) ? HWDATA[15:0]       :
                           iDMACITOP1;

assign NxtDMACITOP2     = (DmacITOP2Wr == 1'b1) ? HWDATA[15:0]       :
                           iDMACITOP2;

assign NxtDMACITOP3     = (DmacITOP3Wr == 1'b1) ? HWDATA[1:0]        :
                           iDMACITOP3;

// -----------------------------------------------------------------------------
// Combinatorial logic for all Soft Request registers.
// The Soft request registers are cleared only on clear signal from the
// channels. But these request bits in the registers are set from the
// AHB Slave Interface
// Channel also gives the clear request in case of error on AHB slave side
// -----------------------------------------------------------------------------
assign ErrClrReq        = ErrClrReq7 | ErrClrReq6 | ErrClrReq5 |
                           ErrClrReq4 | ErrClrReq3 | ErrClrReq2 |
                           ErrClrReq1 | ErrClrReq0;

// -----------------------------------------------------------------------------
// Write logic of DMACSoftReq registers
// A. The SoftReq registers are getting cleared when
//    1. the ClearReq signals come from the channel
//    2. DMACEn bit is made low by the software
//    3. If software writes in the register with value 0 in the Test Mode
// B. The SoftReq registers are getting set when
//    1. Software writes with value 1 in the corresponding bit
// C. The write of value 0 by the software in the register bits in the
//    normal mode would not have any effect.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Write logic of DMACSoftBReq register
// -----------------------------------------------------------------------------
always @(ClearReq or DMACSoftBReq or HWDATA or DmacSoftBRqWr or iDMACEn or
         ErrClrReq or iITEN)
begin : p_SftBrqWrComb
  NxtDMACSftBRq    = DMACSoftBReq;
  if (ClearReq[0] == 1'b1 | ErrClrReq[0] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[0] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[0] == 1'b1)
        begin
          NxtDMACSftBRq[0] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[0] == 1'b0))
        begin
          NxtDMACSftBRq[0] = 1'b0;
        end
    end

  if (ClearReq[1] == 1'b1 | ErrClrReq[1] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[1] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[1] == 1'b1)
        begin
          NxtDMACSftBRq[1] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[1] == 1'b0))
        begin
          NxtDMACSftBRq[1] = 1'b0;
        end
    end

  if (ClearReq[2] == 1'b1 | ErrClrReq[2] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[2] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[2] == 1'b1)
        begin
          NxtDMACSftBRq[2] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[2] == 1'b0))
        begin
          NxtDMACSftBRq[2] = 1'b0;
        end
    end

  if (ClearReq[3] == 1'b1 | ErrClrReq[3] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[3] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[3] == 1'b1)
        begin
          NxtDMACSftBRq[3] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[3] == 1'b0))
        begin
          NxtDMACSftBRq[3] = 1'b0;
        end
    end

  if (ClearReq[4] == 1'b1 | ErrClrReq[4] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[4] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[4] == 1'b1)
        begin
          NxtDMACSftBRq[4] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[4] == 1'b0))
        begin
          NxtDMACSftBRq[4] = 1'b0;
        end
    end

  if (ClearReq[5] == 1'b1 | ErrClrReq[5] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[5] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[5] == 1'b1)
        begin
          NxtDMACSftBRq[5] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[5] == 1'b0))
        begin
          NxtDMACSftBRq[5] = 1'b0;
        end
    end

  if (ClearReq[6] == 1'b1 | ErrClrReq[6] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[6] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[6] == 1'b1)
        begin
          NxtDMACSftBRq[6] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[6] == 1'b0))
        begin
          NxtDMACSftBRq[6] = 1'b0;
        end
    end

  if (ClearReq[7] == 1'b1 | ErrClrReq[7] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[7] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[7] == 1'b1)
        begin
          NxtDMACSftBRq[7] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[7] == 1'b0))
        begin
          NxtDMACSftBRq[7] = 1'b0;
        end
    end

  if (ClearReq[8] == 1'b1 | ErrClrReq[8] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[8] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[8] == 1'b1)
        begin
          NxtDMACSftBRq[8] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[8] == 1'b0))
        begin
          NxtDMACSftBRq[8] = 1'b0;
        end
    end

  if (ClearReq[9] == 1'b1 | ErrClrReq[9] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[9] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[9] == 1'b1)
        begin
          NxtDMACSftBRq[9] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[9] == 1'b0))
        begin
          NxtDMACSftBRq[9] = 1'b0;
        end
    end

  if (ClearReq[10] == 1'b1 | ErrClrReq[10] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[10] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[10] == 1'b1)
        begin
          NxtDMACSftBRq[10] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[10] == 1'b0))
        begin
          NxtDMACSftBRq[10] = 1'b0;
        end
    end

  if (ClearReq[11] == 1'b1 | ErrClrReq[11] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[11] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[11] == 1'b1)
        begin
          NxtDMACSftBRq[11] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[11] == 1'b0))
        begin
          NxtDMACSftBRq[11] = 1'b0;
        end
    end

  if (ClearReq[12] == 1'b1 | ErrClrReq[12] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[12] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[12] == 1'b1)
        begin
          NxtDMACSftBRq[12] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[12] == 1'b0))
        begin
          NxtDMACSftBRq[12] = 1'b0;
        end
    end

  if (ClearReq[13] == 1'b1 | ErrClrReq[13] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[13] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[13] == 1'b1)
        begin
          NxtDMACSftBRq[13] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[13] == 1'b0))
        begin
          NxtDMACSftBRq[13] = 1'b0;
        end
    end

  if (ClearReq[14] == 1'b1 | ErrClrReq[14] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[14] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[14] == 1'b1)
        begin
          NxtDMACSftBRq[14] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[14] == 1'b0))
        begin
          NxtDMACSftBRq[14] = 1'b0;
        end
    end

  if (ClearReq[15] == 1'b1 | ErrClrReq[15] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftBRq[15] = 1'b0;
    end
  else if (DmacSoftBRqWr == 1'b1)
    begin
      if (HWDATA[15] == 1'b1)
        begin
          NxtDMACSftBRq[15] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[15] == 1'b0))
        begin
          NxtDMACSftBRq[15] = 1'b0;
        end
    end

end // p_SftBrqWrComb

// -----------------------------------------------------------------------------
// Write logic of DMACSoftSReq register
// -----------------------------------------------------------------------------
always @(ClearReq or DMACSoftSReq or HWDATA or DmacSoftSRqWr or iDMACEn or
         ErrClrReq or iITEN)
begin : p_SftSrqWrComb
  NxtDMACSftSRq    = DMACSoftSReq;

  if (ClearReq[0] == 1'b1 | ErrClrReq[0] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[0] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[0] == 1'b1)
        begin
          NxtDMACSftSRq[0] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[0] == 1'b0))
        begin
          NxtDMACSftSRq[0] = 1'b0;
        end
    end

  if (ClearReq[1] == 1'b1 | ErrClrReq[1] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[1] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[1] == 1'b1)
        begin
          NxtDMACSftSRq[1] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[1] == 1'b0))
        begin
          NxtDMACSftSRq[1] = 1'b0;
        end
    end

  if (ClearReq[2] == 1'b1 | ErrClrReq[2] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[2] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[2] == 1'b1)
        begin
          NxtDMACSftSRq[2] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[2] == 1'b0))
        begin
          NxtDMACSftSRq[2] = 1'b0;
        end
    end

  if (ClearReq[3] == 1'b1 | ErrClrReq[3] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[3] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[3] == 1'b1)
        begin
          NxtDMACSftSRq[3] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[3] == 1'b0))
        begin
          NxtDMACSftSRq[3] = 1'b0;
        end
      end

  if (ClearReq[4] == 1'b1 | ErrClrReq[4] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[4] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[4] == 1'b1)
        begin
          NxtDMACSftSRq[4] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[4] == 1'b0))
        begin
          NxtDMACSftSRq[4] = 1'b0;
        end
    end

  if (ClearReq[5] == 1'b1 | ErrClrReq[5] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[5] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[5] == 1'b1)
        begin
          NxtDMACSftSRq[5] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[5] == 1'b0))
        begin
          NxtDMACSftSRq[5] = 1'b0;
        end
    end

  if (ClearReq[6] == 1'b1 | ErrClrReq[6] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[6] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[6] == 1'b1)
        begin
          NxtDMACSftSRq[6] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[6] == 1'b0))
        begin
          NxtDMACSftSRq[6] = 1'b0;
        end
    end

  if (ClearReq[7] == 1'b1 | ErrClrReq[7] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[7] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[7] == 1'b1)
        begin
          NxtDMACSftSRq[7] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[7] == 1'b0))
        begin
          NxtDMACSftSRq[7] = 1'b0;
        end
    end

  if (ClearReq[8] == 1'b1 | ErrClrReq[8] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[8] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[8] == 1'b1)
        begin
          NxtDMACSftSRq[8] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[8] == 1'b0))
        begin
          NxtDMACSftSRq[8] = 1'b0;
        end
    end

  if (ClearReq[9] == 1'b1 | ErrClrReq[9] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[9] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[9] == 1'b1)
        begin
          NxtDMACSftSRq[9] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[9] == 1'b0))
        begin
          NxtDMACSftSRq[9] = 1'b0;
        end
    end

  if (ClearReq[10] == 1'b1 | ErrClrReq[10] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[10] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[10] == 1'b1)
        begin
          NxtDMACSftSRq[10] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[10] == 1'b0))
        begin
          NxtDMACSftSRq[10] = 1'b0;
        end
    end

  if (ClearReq[11] == 1'b1 | ErrClrReq[11] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[11] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[11] == 1'b1)
        begin
          NxtDMACSftSRq[11] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[11] == 1'b0))
        begin
          NxtDMACSftSRq[11] = 1'b0;
        end
    end

  if (ClearReq[12] == 1'b1 | ErrClrReq[12] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[12] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[12] == 1'b1)
        begin
          NxtDMACSftSRq[12] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[12] == 1'b0))
        begin
          NxtDMACSftSRq[12] = 1'b0;
        end
    end

  if (ClearReq[13] == 1'b1 | ErrClrReq[13] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[13] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[13] == 1'b1)
        begin
          NxtDMACSftSRq[13] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[13] == 1'b0))
        begin
          NxtDMACSftSRq[13] = 1'b0;
        end
    end

  if (ClearReq[14] == 1'b1 | ErrClrReq[14] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[14] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[14] == 1'b1)
        begin
          NxtDMACSftSRq[14] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[14] == 1'b0))
        begin
          NxtDMACSftSRq[14] = 1'b0;
        end
    end

  if (ClearReq[15] == 1'b1 | ErrClrReq[15] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftSRq[15] = 1'b0;
    end
  else if (DmacSoftSRqWr == 1'b1)
    begin
      if (HWDATA[15] == 1'b1)
        begin
          NxtDMACSftSRq[15] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[15] == 1'b0))
        begin
          NxtDMACSftSRq[15] = 1'b0;
        end
    end

end // p_SftSrqWrComb

// -----------------------------------------------------------------------------
// Write logic of DMACSoftLBReq register
// -----------------------------------------------------------------------------
always @(ClearReq or DMACSoftLBReq or HWDATA or DmacSoftLBRqWr or iDMACEn or
         ErrClrReq or iITEN)
begin : p_SftLBrqWrComb
  NxtDMACSftLBRq   = DMACSoftLBReq;

  if (ClearReq[0] == 1'b1 | ErrClrReq[0] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[0] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[0] == 1'b1)
        begin
          NxtDMACSftLBRq[0] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[0] == 1'b0))
        begin
          NxtDMACSftLBRq[0] = 1'b0;
        end
    end

  if (ClearReq[1] == 1'b1 | ErrClrReq[1] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[1] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[1] == 1'b1)
        begin
          NxtDMACSftLBRq[1] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[1] == 1'b0))
        begin
          NxtDMACSftLBRq[1] = 1'b0;
        end
    end

  if (ClearReq[2] == 1'b1 | ErrClrReq[2] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[2] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[2] == 1'b1)
        begin
          NxtDMACSftLBRq[2] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[2] == 1'b0))
        begin
          NxtDMACSftLBRq[2] = 1'b0;
        end
    end

  if (ClearReq[3] == 1'b1 | ErrClrReq[3] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[3] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[3] == 1'b1)
        begin
          NxtDMACSftLBRq[3] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[3] == 1'b0))
        begin
          NxtDMACSftLBRq[3] = 1'b0;
        end
    end

  if (ClearReq[4] == 1'b1 | ErrClrReq[4] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[4] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[4] == 1'b1)
        begin
          NxtDMACSftLBRq[4] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[4] == 1'b0))
        begin
          NxtDMACSftLBRq[4] = 1'b0;
        end
    end

  if (ClearReq[5] == 1'b1 | ErrClrReq[5] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[5] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[5] == 1'b1)
        begin
          NxtDMACSftLBRq[5] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[5] == 1'b0))
        begin
          NxtDMACSftLBRq[5] = 1'b0;
        end
    end

  if (ClearReq[6] == 1'b1 | ErrClrReq[6] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[6] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[6] == 1'b1)
        begin
          NxtDMACSftLBRq[6] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[6] == 1'b0))
        begin
          NxtDMACSftLBRq[6] = 1'b0;
        end
    end

  if (ClearReq[7] == 1'b1 | ErrClrReq[7] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[7] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[7] == 1'b1)
        begin
          NxtDMACSftLBRq[7] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[7] == 1'b0))
        begin
          NxtDMACSftLBRq[7] = 1'b0;
        end
    end

  if (ClearReq[8] == 1'b1 | ErrClrReq[8] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[8] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[8] == 1'b1)
        begin
          NxtDMACSftLBRq[8] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[8] == 1'b0))
        begin
          NxtDMACSftLBRq[8] = 1'b0;
        end
    end

  if (ClearReq[9] == 1'b1 | ErrClrReq[9] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[9] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[9] == 1'b1)
        begin
          NxtDMACSftLBRq[9] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[9] == 1'b0))
        begin
          NxtDMACSftLBRq[9] = 1'b0;
        end
    end

  if (ClearReq[10] == 1'b1 | ErrClrReq[10] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[10] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[10] == 1'b1)
        begin
          NxtDMACSftLBRq[10] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[10] == 1'b0))
        begin
          NxtDMACSftLBRq[10] = 1'b0;
        end
    end

  if (ClearReq[11] == 1'b1 | ErrClrReq[11] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[11] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[11] == 1'b1)
        begin
          NxtDMACSftLBRq[11] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[11] == 1'b0))
        begin
          NxtDMACSftLBRq[11] = 1'b0;
        end
    end

  if (ClearReq[12] == 1'b1 | ErrClrReq[12] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[12] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[12] == 1'b1)
        begin
          NxtDMACSftLBRq[12] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[12] == 1'b0))
        begin
          NxtDMACSftLBRq[12] = 1'b0;
        end
    end

 if (ClearReq[13] == 1'b1 | ErrClrReq[13] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
 begin
      NxtDMACSftLBRq[13] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[13] == 1'b1)
        begin
          NxtDMACSftLBRq[13] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[13] == 1'b0))
        begin
          NxtDMACSftLBRq[13] = 1'b0;
        end
    end

  if (ClearReq[14] == 1'b1 | ErrClrReq[14] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[14] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[14] == 1'b1)
        begin
          NxtDMACSftLBRq[14] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[14] == 1'b0))
        begin
          NxtDMACSftLBRq[14] = 1'b0;
        end
    end

  if (ClearReq[15] == 1'b1 | ErrClrReq[15] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLBRq[15] = 1'b0;
    end
  else if (DmacSoftLBRqWr == 1'b1)
    begin
      if (HWDATA[15] == 1'b1)
        begin
          NxtDMACSftLBRq[15] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[15] == 1'b0))
        begin
          NxtDMACSftLBRq[15] = 1'b0;
        end
    end

end // p_SftLBrqWrComb

// -----------------------------------------------------------------------------
// Write logic of DMACSoftLSReq register
// -----------------------------------------------------------------------------
always @(ClearReq or DMACSoftLSReq or HWDATA or DmacSoftLSRqWr or iDMACEn or
         ErrClrReq or iITEN)
begin : p_SftLSrqWrComb
  NxtDMACSftLSRq   = DMACSoftLSReq;

  if (ClearReq[0] == 1'b1 | ErrClrReq[0] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[0] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[0] == 1'b1)
        begin
          NxtDMACSftLSRq[0] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[0] == 1'b0))
        begin
          NxtDMACSftLSRq[0] = 1'b0;
        end
    end

  if (ClearReq[1] == 1'b1 | ErrClrReq[1] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[1] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[1] == 1'b1)
        begin
          NxtDMACSftLSRq[1] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[1] == 1'b0))
        begin
          NxtDMACSftLSRq[1] = 1'b0;
        end
    end

  if (ClearReq[2] == 1'b1 | ErrClrReq[2] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[2] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[2] == 1'b1)
        begin
          NxtDMACSftLSRq[2] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[2] == 1'b0))
        begin
          NxtDMACSftLSRq[2] = 1'b0;
        end
    end

  if (ClearReq[3] == 1'b1 | ErrClrReq[3] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[3] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[3] == 1'b1)
        begin
          NxtDMACSftLSRq[3] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[3] == 1'b0))
        begin
          NxtDMACSftLSRq[3] = 1'b0;
        end
    end

  if (ClearReq[4] == 1'b1 | ErrClrReq[4] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[4] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[4] == 1'b1)
        begin
          NxtDMACSftLSRq[4] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[4] == 1'b0))
        begin
          NxtDMACSftLSRq[4] = 1'b0;
        end
    end

  if (ClearReq[5] == 1'b1 | ErrClrReq[5] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[5] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[5] == 1'b1)
        begin
          NxtDMACSftLSRq[5] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[5] == 1'b0))
        begin
          NxtDMACSftLSRq[5] = 1'b0;
        end
    end

  if (ClearReq[6] == 1'b1 | ErrClrReq[6] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[6] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[6] == 1'b1)
        begin
          NxtDMACSftLSRq[6] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[6] == 1'b0))
        begin
          NxtDMACSftLSRq[6] = 1'b0;
        end
    end

  if (ClearReq[7] == 1'b1 | ErrClrReq[7] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[7] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[7] == 1'b1)
        begin
          NxtDMACSftLSRq[7] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[7] == 1'b0))
        begin
          NxtDMACSftLSRq[7] = 1'b0;
        end
    end

  if (ClearReq[8] == 1'b1 | ErrClrReq[8] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[8] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[8] == 1'b1)
        begin
          NxtDMACSftLSRq[8] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[8] == 1'b0))
        begin
          NxtDMACSftLSRq[8] = 1'b0;
        end
    end

  if (ClearReq[9] == 1'b1 | ErrClrReq[9] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[9] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[9] == 1'b1)
        begin
          NxtDMACSftLSRq[9] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[9] == 1'b0))
        begin
          NxtDMACSftLSRq[9] = 1'b0;
        end
    end

  if (ClearReq[10] == 1'b1 | ErrClrReq[10] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[10] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[10] == 1'b1)
        begin
          NxtDMACSftLSRq[10] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[10] == 1'b0))
        begin
          NxtDMACSftLSRq[10] = 1'b0;
        end
    end

  if (ClearReq[11] == 1'b1 | ErrClrReq[11] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[11] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[11] == 1'b1)
        begin
          NxtDMACSftLSRq[11] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[11] == 1'b0))
        begin
          NxtDMACSftLSRq[11] = 1'b0;
        end
    end

  if (ClearReq[12] == 1'b1 | ErrClrReq[12] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[12] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[12] == 1'b1)
        begin
          NxtDMACSftLSRq[12] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[12] == 1'b0))
        begin
          NxtDMACSftLSRq[12] = 1'b0;
        end
    end

  if (ClearReq[13] == 1'b1 | ErrClrReq[13] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[13] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[13] == 1'b1)
        begin
          NxtDMACSftLSRq[13] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[13] == 1'b0))
        begin
          NxtDMACSftLSRq[13] = 1'b0;
        end
    end

  if (ClearReq[14] == 1'b1 | ErrClrReq[14] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[14] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[14] == 1'b1)
        begin
          NxtDMACSftLSRq[14] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[14] == 1'b0))
        begin
          NxtDMACSftLSRq[14] = 1'b0;
        end
    end

  if (ClearReq[15] == 1'b1 | ErrClrReq[15] == 1'b1 |
      (iDMACEn == 1'b0 & iITEN == 1'b0))
    begin
      NxtDMACSftLSRq[15] = 1'b0;
    end
  else if (DmacSoftLSRqWr == 1'b1)
    begin
      if (HWDATA[15] == 1'b1)
        begin
          NxtDMACSftLSRq[15] = 1'b1;
        end
      else if (iITEN == 1'b1 & (HWDATA[15] == 1'b0))
        begin
          NxtDMACSftLSRq[15] = 1'b0;
        end
  end

end // p_SftLSrqWrComb

// -----------------------------------------------------------------------------
// Sequential process for write-able registers.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ComRegWriteSeq
  if (HRESETn == 1'b0)
    begin
      DMACSoftBReq     <= 16'b0;
      DMACSoftLBReq    <= 16'b0;
      DMACSoftSReq     <= 16'b0;
      DMACSoftLSReq    <= 16'b0;
      DMACConfig       <= 16'b0;
      DMACSync         <= 16'b0;
      DMACTCR          <= 1'b0;
      iDMACITOP1       <= 16'b0;
      iDMACITOP2       <= 16'b0;
      iDMACITOP3       <= 16'b0;
    end
  else
    begin
      DMACSoftBReq     <= NxtDMACSftBRq;
      DMACSoftLBReq    <= NxtDMACSftLBRq;
      DMACSoftSReq     <= NxtDMACSftSRq;
      DMACSoftLSReq    <= NxtDMACSftLSRq;
      DMACConfig       <= NxtDMACConfig;
      DMACSync         <= NxtDMACSync;
      DMACTCR          <= NxtDMACTCR;
      iDMACITOP1       <= NxtDMACITOP1;
      iDMACITOP2       <= NxtDMACITOP2;
      iDMACITOP3       <= NxtDMACITOP3;
    end
end // p_ComRegWriteSeq

// -----------------------------------------------------------------------------
// Generating the interrupt clear signals for clearing different
// interrupts generated by the channels
// -----------------------------------------------------------------------------
assign ClrIntTC0        = DmacIntTCClrWr & HWDATA[0];
assign ClrIntTC1        = DmacIntTCClrWr & HWDATA[1];
assign ClrIntTC2        = DmacIntTCClrWr & HWDATA[2];
assign ClrIntTC3        = DmacIntTCClrWr & HWDATA[3];
assign ClrIntTC4        = DmacIntTCClrWr & HWDATA[4];
assign ClrIntTC5        = DmacIntTCClrWr & HWDATA[5];
assign ClrIntTC6        = DmacIntTCClrWr & HWDATA[6];
assign ClrIntTC7        = DmacIntTCClrWr & HWDATA[7];

assign ClrIntErr0       = DmacIntErrClrWr & HWDATA[0];
assign ClrIntErr1       = DmacIntErrClrWr & HWDATA[1];
assign ClrIntErr2       = DmacIntErrClrWr & HWDATA[2];
assign ClrIntErr3       = DmacIntErrClrWr & HWDATA[3];
assign ClrIntErr4       = DmacIntErrClrWr & HWDATA[4];
assign ClrIntErr5       = DmacIntErrClrWr & HWDATA[5];
assign ClrIntErr6       = DmacIntErrClrWr & HWDATA[6];
assign ClrIntErr7       = DmacIntErrClrWr & HWDATA[7];

// -----------------------------------------------------------------------------
// Assign the DMACTCR register bits to the corresponding signals
// -----------------------------------------------------------------------------
assign iITEN            = DMACTCR;

// -----------------------------------------------------------------------------
// Assign the DMACConfig register bits to the corresponding signals
// -----------------------------------------------------------------------------
assign iDMACEn          = DMACConfig[0];
assign BigEndianM1      = DMACConfig[1];
assign BigEndianM2      = DMACConfig[2];

// -----------------------------------------------------------------------------
// Masking the DMA requests from the peripherals when the DMAC is not enbled
// This is for implementing low power mode
// -----------------------------------------------------------------------------
assign iMskdDMACSREQ    = (iDMACEn == 1'b1) ? DMACSREQ : ('d0);

assign iMskdDMACBREQ    = (iDMACEn == 1'b1) ? DMACBREQ : ('d0);

assign iMskdDMACLSREQ   = (iDMACEn == 1'b1) ? DMACLSREQ : ('d0);

assign iMskdDMACLBREQ   = (iDMACEn == 1'b1) ? DMACLBREQ : ('d0);

// -----------------------------------------------------------------------------
// Buffering the DMAC requests
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BuffReqSeq
  if (HRESETn == 1'b0)
    begin
      BuffDMACSREQ     <= 16'b0;
      BuffDMACBREQ     <= 16'b0;
      BuffDMACLSREQ    <= 16'b0;
      BuffDMACLBREQ    <= 16'b0;
    end
  else
    begin
      BuffDMACSREQ     <= iMskdDMACSREQ;
      BuffDMACBREQ     <= iMskdDMACBREQ;
      BuffDMACLSREQ    <= iMskdDMACLSREQ;
      BuffDMACLBREQ    <= iMskdDMACLBREQ;
    end
end // p_BuffReqSeq

// -----------------------------------------------------------------------------
// Muxing out the synchronised and un-synchronised version of the DMA Requests
// -----------------------------------------------------------------------------
assign MuxDMACSREQ[0]   = (DMACSync[0] == 1'b1) ? BuffDMACSREQ[0]    :
                           DMACSREQSync[0];
assign MuxDMACBREQ[0]   = (DMACSync[0] == 1'b1) ? BuffDMACBREQ[0]    :
                           DMACBREQSync[0];
assign MuxDMACLSREQ[0]  = (DMACSync[0] == 1'b1) ? BuffDMACLSREQ[0]   :
                           DMACLSREQSync[0];
assign MuxDMACLBREQ[0]  = (DMACSync[0] == 1'b1) ? BuffDMACLBREQ[0]   :
                           DMACLBREQSync[0];
assign MuxDMACSREQ[1]   = (DMACSync[1] == 1'b1) ? BuffDMACSREQ[1]    :
                           DMACSREQSync[1];
assign MuxDMACBREQ[1]   = (DMACSync[1] == 1'b1) ? BuffDMACBREQ[1]    :
                           DMACBREQSync[1];
assign MuxDMACLSREQ[1]  = (DMACSync[1] == 1'b1) ? BuffDMACLSREQ[1]   :
                           DMACLSREQSync[1];
assign MuxDMACLBREQ[1]  = (DMACSync[1] == 1'b1) ? BuffDMACLBREQ[1]   :
                           DMACLBREQSync[1];
assign MuxDMACSREQ[2]   = (DMACSync[2] == 1'b1) ? BuffDMACSREQ[2]    :
                           DMACSREQSync[2];
assign MuxDMACBREQ[2]   = (DMACSync[2] == 1'b1) ? BuffDMACBREQ[2]    :
                           DMACBREQSync[2];
assign MuxDMACLSREQ[2]  = (DMACSync[2] == 1'b1) ? BuffDMACLSREQ[2]   :
                           DMACLSREQSync[2];
assign MuxDMACLBREQ[2]  = (DMACSync[2] == 1'b1) ? BuffDMACLBREQ[2]   :
                           DMACLBREQSync[2];
assign MuxDMACSREQ[3]   = (DMACSync[3] == 1'b1) ? BuffDMACSREQ[3]    :
                           DMACSREQSync[3];
assign MuxDMACBREQ[3]   = (DMACSync[3] == 1'b1) ? BuffDMACBREQ[3]    :
                           DMACBREQSync[3];
assign MuxDMACLSREQ[3]  = (DMACSync[3] == 1'b1) ? BuffDMACLSREQ[3]   :
                           DMACLSREQSync[3];
assign MuxDMACLBREQ[3]  = (DMACSync[3] == 1'b1) ? BuffDMACLBREQ[3]   :
                           DMACLBREQSync[3];
assign MuxDMACSREQ[4]   = (DMACSync[4] == 1'b1) ? BuffDMACSREQ[4]    :
                           DMACSREQSync[4];
assign MuxDMACBREQ[4]   = (DMACSync[4] == 1'b1) ? BuffDMACBREQ[4]    :
                           DMACBREQSync[4];
assign MuxDMACLSREQ[4]  = (DMACSync[4] == 1'b1) ? BuffDMACLSREQ[4]   :
                           DMACLSREQSync[4];
assign MuxDMACLBREQ[4]  = (DMACSync[4] == 1'b1) ? BuffDMACLBREQ[4]   :
                           DMACLBREQSync[4];
assign MuxDMACSREQ[5]   = (DMACSync[5] == 1'b1) ? BuffDMACSREQ[5]    :
                           DMACSREQSync[5];
assign MuxDMACBREQ[5]   = (DMACSync[5] == 1'b1) ? BuffDMACBREQ[5]    :
                           DMACBREQSync[5];
assign MuxDMACLSREQ[5]  = (DMACSync[5] == 1'b1) ? BuffDMACLSREQ[5]   :
                           DMACLSREQSync[5];
assign MuxDMACLBREQ[5]  = (DMACSync[5] == 1'b1) ? BuffDMACLBREQ[5]   :
                           DMACLBREQSync[5];
assign MuxDMACSREQ[6]   = (DMACSync[6] == 1'b1) ? BuffDMACSREQ[6]    :
                           DMACSREQSync[6];
assign MuxDMACBREQ[6]   = (DMACSync[6] == 1'b1) ? BuffDMACBREQ[6]    :
                           DMACBREQSync[6];
assign MuxDMACLSREQ[6]  = (DMACSync[6] == 1'b1) ? BuffDMACLSREQ[6]   :
                           DMACLSREQSync[6];
assign MuxDMACLBREQ[6]  = (DMACSync[6] == 1'b1) ? BuffDMACLBREQ[6]   :
                           DMACLBREQSync[6];
assign MuxDMACSREQ[7]   = (DMACSync[7] == 1'b1) ? BuffDMACSREQ[7]    :
                           DMACSREQSync[7];
assign MuxDMACBREQ[7]   = (DMACSync[7] == 1'b1) ? BuffDMACBREQ[7]    :
                           DMACBREQSync[7];
assign MuxDMACLSREQ[7]  = (DMACSync[7] == 1'b1) ? BuffDMACLSREQ[7]   :
                           DMACLSREQSync[7];
assign MuxDMACLBREQ[7]  = (DMACSync[7] == 1'b1) ? BuffDMACLBREQ[7]   :
                           DMACLBREQSync[7];
assign MuxDMACSREQ[8]   = (DMACSync[8] == 1'b1) ? BuffDMACSREQ[8]    :
                           DMACSREQSync[8];
assign MuxDMACBREQ[8]   = (DMACSync[8] == 1'b1) ? BuffDMACBREQ[8]    :
                           DMACBREQSync[8];
assign MuxDMACLSREQ[8]  = (DMACSync[8] == 1'b1) ? BuffDMACLSREQ[8]   :
                           DMACLSREQSync[8];
assign MuxDMACLBREQ[8]  = (DMACSync[8] == 1'b1) ? BuffDMACLBREQ[8]   :
                           DMACLBREQSync[8];
assign MuxDMACSREQ[9]   = (DMACSync[9] == 1'b1) ? BuffDMACSREQ[9]    :
                           DMACSREQSync[9];
assign MuxDMACBREQ[9]   = (DMACSync[9] == 1'b1) ? BuffDMACBREQ[9]    :
                           DMACBREQSync[9];
assign MuxDMACLSREQ[9]  = (DMACSync[9] == 1'b1) ? BuffDMACLSREQ[9]   :
                           DMACLSREQSync[9];
assign MuxDMACLBREQ[9]  = (DMACSync[9] == 1'b1) ? BuffDMACLBREQ[9]   :
                           DMACLBREQSync[9];
assign MuxDMACSREQ[10]  = (DMACSync[10] == 1'b1) ? BuffDMACSREQ[10]  :
                           DMACSREQSync[10];
assign MuxDMACBREQ[10]  = (DMACSync[10] == 1'b1) ? BuffDMACBREQ[10]  :
                           DMACBREQSync[10];
assign MuxDMACLSREQ[10] = (DMACSync[10] == 1'b1) ? BuffDMACLSREQ[10] :
                           DMACLSREQSync[10];
assign MuxDMACLBREQ[10] = (DMACSync[10] == 1'b1) ? BuffDMACLBREQ[10] :
                           DMACLBREQSync[10];
assign MuxDMACSREQ[11]  = (DMACSync[11] == 1'b1) ? BuffDMACSREQ[11]  :
                           DMACSREQSync[11];
assign MuxDMACBREQ[11]  = (DMACSync[11] == 1'b1) ? BuffDMACBREQ[11]  :
                           DMACBREQSync[11];
assign MuxDMACLSREQ[11] = (DMACSync[11] == 1'b1) ? BuffDMACLSREQ[11] :
                           DMACLSREQSync[11];
assign MuxDMACLBREQ[11] = (DMACSync[11] == 1'b1) ? BuffDMACLBREQ[11] :
                           DMACLBREQSync[11];
assign MuxDMACSREQ[12]  = (DMACSync[12] == 1'b1) ? BuffDMACSREQ[12]  :
                           DMACSREQSync[12];
assign MuxDMACBREQ[12]  = (DMACSync[12] == 1'b1) ? BuffDMACBREQ[12]  :
                           DMACBREQSync[12];
assign MuxDMACLSREQ[12] = (DMACSync[12] == 1'b1) ? BuffDMACLSREQ[12] :
                           DMACLSREQSync[12];
assign MuxDMACLBREQ[12] = (DMACSync[12] == 1'b1) ? BuffDMACLBREQ[12] :
                           DMACLBREQSync[12];
assign MuxDMACSREQ[13]  = (DMACSync[13] == 1'b1) ? BuffDMACSREQ[13]  :
                           DMACSREQSync[13];
assign MuxDMACBREQ[13]  = (DMACSync[13] == 1'b1) ? BuffDMACBREQ[13]  :
                           DMACBREQSync[13];
assign MuxDMACLSREQ[13] = (DMACSync[13] == 1'b1) ? BuffDMACLSREQ[13] :
                           DMACLSREQSync[13];
assign MuxDMACLBREQ[13] = (DMACSync[13] == 1'b1) ? BuffDMACLBREQ[13] :
                           DMACLBREQSync[13];
assign MuxDMACSREQ[14]  = (DMACSync[14] == 1'b1) ? BuffDMACSREQ[14]  :
                           DMACSREQSync[14];
assign MuxDMACBREQ[14]  = (DMACSync[14] == 1'b1) ? BuffDMACBREQ[14]  :
                           DMACBREQSync[14];
assign MuxDMACLSREQ[14] = (DMACSync[14] == 1'b1) ? BuffDMACLSREQ[14] :
                           DMACLSREQSync[14];
assign MuxDMACLBREQ[14] = (DMACSync[14] == 1'b1) ? BuffDMACLBREQ[14] :
                           DMACLBREQSync[14];
assign MuxDMACSREQ[15]  = (DMACSync[15] == 1'b1) ? BuffDMACSREQ[15]  :
                           DMACSREQSync[15];
assign MuxDMACBREQ[15]  = (DMACSync[15] == 1'b1) ? BuffDMACBREQ[15]  :
                           DMACBREQSync[15];
assign MuxDMACLSREQ[15] = (DMACSync[15] == 1'b1) ? BuffDMACLSREQ[15] :
                           DMACLSREQSync[15];
assign MuxDMACLBREQ[15] = (DMACSync[15] == 1'b1) ? BuffDMACLBREQ[15] :
                           DMACLBREQSync[15];

// -----------------------------------------------------------------------------
// Routing the Request signals to the channels by ORing the HARD and SOFT
// requests.
// -----------------------------------------------------------------------------
assign iDMACSREQCh      = MuxDMACSREQ | DMACSoftSReq;
assign iDMACBREQCh      = MuxDMACBREQ | DMACSoftBReq;
assign iDMACLSREQCh     = MuxDMACLSREQ | DMACSoftLSReq;
assign iDMACLBREQCh     = MuxDMACLBREQ | DMACSoftLBReq;

// -----------------------------------------------------------------------------
// Assigning internal signals to the outputs
// -----------------------------------------------------------------------------
assign RegHWrite        = iRegHWrite;
assign HRESP            = iHRESP;
assign HREADYOUT        = iHREADYOUT;
assign DMACSREQCh       = iDMACSREQCh;
assign DMACBREQCh       = iDMACBREQCh;
assign DMACLSREQCh      = iDMACLSREQCh;
assign DMACLBREQCh      = iDMACLBREQCh;
assign DMACEn           = iDMACEn;
assign ITEN             = iITEN;
assign MskdDMACSREQ     = iMskdDMACSREQ;
assign MskdDMACBREQ     = iMskdDMACBREQ;
assign MskdDMACLSREQ    = iMskdDMACLSREQ;
assign MskdDMACLBREQ    = iMskdDMACLBREQ;
assign DMACITOP1        = iDMACITOP1;
assign DMACITOP2        = iDMACITOP2;
assign DMACITOP3        = iDMACITOP3;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

integer                   BitNum;
// Variable for counting the number of bit

// -----------------------------------------------------------------------------
// Protocol check if the DMAC is disabled before the previous service request
// from the SoftReq registers are not yet serviced.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_DsblBefClrProt
  for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
    begin
      if (iITEN == 1'b0)
        if (iDMACEn == 1'b0 && DMACSoftBReq[BitNum] == 1'b1 &&
            ClearReq[BitNum] != 1'b1)
          $display($time, "Warning : DmacAhbSlaveIf2 : DMAC disabled before ",
            " the previous DMA request from DmacSoftBReq register is serviced");
    end

  for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
    begin
      if (iITEN == 1'b0)
        if (iDMACEn == 1'b0 && DMACSoftSReq[BitNum] == 1'b1 &&
            ClearReq[BitNum] != 1'b1)
          $display($time, "Warning : DmacAhbSlaveIf3 : DMAC disabled before ",
             " the previous DMA request from DmacSoftSReq register is",
             " serviced");
    end

  for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
    begin
      if (iITEN == 1'b0)
        if (iDMACEn == 1'b0 && DMACSoftLSReq[BitNum] == 1'b1 &&
            ClearReq[BitNum] != 1'b1)
          $display($time, "Warning : DmacAhbSlaveIf4 : DMAC disabled before ",
          "the previous DMA request from DmacSoftLSReq register is serviced");
     end

  for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
    begin
      if (iITEN == 1'b0)
        if (iDMACEn == 1'b0 && DMACSoftLBReq[BitNum] == 1'b1 &&
            ClearReq[BitNum] != 1'b1)
          $display($time, "Warning : DmacAhbSlaveIf5 : DMAC disabled before ",
           "the previous DMA request from DmacSoftLBReq register is serviced");
    end
end // process p_DsblBefClrProt;

// -----------------------------------------------------------------------------
// Protocol check if the SoftReq registers requests are set again before the
// previous request is over && clears it
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_ClrSftRqProt
  if (iDMACEn == 1'b1)
    begin
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DmacSoftBRqWr == 1'b1 && iITEN == 1'b0 &&
                DMACSoftBReq[BitNum] == 1'b1 && HWDATA[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf7 : DMACSoftBReq register",
             " bit/s is/are set again before the previous request is serviced");
        end

      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DmacSoftSRqWr == 1'b1 && iITEN == 1'b0 &&
                DMACSoftSReq[BitNum] == 1'b1 && HWDATA[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf8 : DMACSoftSReq ",
               " register bit/s is/are set again before the previous",
               " request is serviced");
        end

      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DmacSoftLBRqWr == 1'b1 && iITEN == 1'b0 &&
                DMACSoftLBReq[BitNum] == 1'b1 && HWDATA[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf9 : DMACSoftLBReq ",
               " register bit/s is/are set again before the previous ",
               "request is serviced");
        end

      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DmacSoftLSRqWr == 1'b1 && iITEN == 1'b0 &&
                DMACSoftLSReq[BitNum] == 1'b1 && HWDATA[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf10 : DMACSoftLSReq ",
               "register bit/s is/are set again before the previous request",
               " is serviced");
        end
    end
end // process p_ClrSftRqProt;

// -----------------------------------------------------------------------------
// For giving error message if the slave is accessed for non-word width access
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_NonWordAcProt
  if ((HSELDMAC == 1'b1) && (HREADYIN == 1'b1))
    if (HTRANS == 1'b1)
      if (HSIZE != `WORD_ACCESS)
        $display($time, "Warning : DmacAhbSlaveIf11 : DMAC Slave is accessed",
          "with Non-Word transactions");
end // process p_NonWordAcProt;

// -----------------------------------------------------------------------------
// Issue an error message when SREQ / BREQ are asserted along with LSREQ/LBREQ
// of a peripheral.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_SimultReqProt
  if (iDMACEn == 1'b1)
    begin
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DMACLBREQ[BitNum] == 1'b1)
            if (DMACBREQ[BitNum] == 1'b1 || DMACSREQ[BitNum] == 1'b1)
              $display($time, "Warning : DmacAhbSlaveIf12 : SREQ / BREQ ",
                              "asserted along with LBREQ ");
        end
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DMACLSREQ[BitNum] == 1'b1)
            if (DMACBREQ[BitNum] == 1'b1 || DMACSREQ[BitNum] == 1'b1)
              $display($time, "Warning : DmacAhbSlaveIf13 : SREQ / BREQ ",
                              "asserted along with LSREQ ");
        end
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DMACLSREQ[BitNum] == 1'b1 && DMACLBREQ[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf14 : LSREQ && LBREQ ",
                              "raised simultaneously ");
        end
    end
end // process p_SimultReqProt;

// -----------------------------------------------------------------------------
// For giving DMAC status
// -----------------------------------------------------------------------------
always @(iDMACEn)
begin : p_DmacStatProt
  if (iDMACEn == 1'b0)
    $display($time, "Note : DmacAhbSlaveIf15 : DMA Controller is disabled now");
  else if (iDMACEn == 1'b1)
    $display($time, "Note : DmacAhbSlaveIf16 : DMA Controller is enabled now");
end // process p_DmacStatProt;

// -----------------------------------------------------------------------------
// For detecting if the 'soft' && 'hard' DMA requests are high at a time
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_HrdSftRqProt
  if (iDMACEn == 1'b1)
    begin
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (MuxDMACSREQ[BitNum] == 1'b1 && DMACSoftSReq[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf17 : Soft && Hard SREQ ",
                            "Request are active simultaneously");
        end
  
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (MuxDMACBREQ[BitNum] == 1'b1 && DMACSoftBReq[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf18 : Soft && Hard BREQ ",
                            "Request are active simultaneously");
        end
  
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (MuxDMACLSREQ[BitNum] == 1'b1 && DMACSoftLSReq[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf19 : Soft && Hard LSREQ ",
                            "Request are active simultaneously");
        end
  
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (MuxDMACLBREQ[BitNum] == 1'b1 && DMACSoftLBReq[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf20 : Soft && Hard LBREQ ",
                            "Request are active simultaneously");
        end
    end

end // process p_HrdSftRqProt;

// -----------------------------------------------------------------------------
// Issue an warning message when soft SREQ / BREQ are asserted along with
// soft LSREQ/LBREQ
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_SmltSftReqProt
  if (iDMACEn == 1'b1)
    begin
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DMACSoftLBReq[BitNum] == 1'b1)
            if (DMACSoftBReq[BitNum] == 1'b1 || DMACSoftSReq[BitNum] == 1'b1)
              $display($time, "Warning : DmacAhbSlaveIf21 : Soft SREQ / BREQ ",
                              "asserted along with soft LBREQ ");
        end
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DMACSoftLSReq[BitNum] == 1'b1)
            if (DMACSoftBReq[BitNum] == 1'b1 || DMACSoftSReq[BitNum] == 1'b1)
              $display($time, "Warning : DmacAhbSlaveIf22 : Soft SREQ / BREQ ",
                              "asserted along with soft LSREQ ");
        end
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (DMACSoftLSReq[BitNum] == 1'b1 && DMACSoftLBReq[BitNum] == 1'b1)
            $display($time, "Warning : DmacAhbSlaveIf23 : Soft LSREQ && soft",
                            " LBREQ raised simultaneously ");
        end
      for (BitNum = 0; BitNum <16; BitNum = BitNum +1)
        begin
          if (ClearReq[BitNum] == 1'b1)
            if ((DmacSoftSRqWr || DmacSoftBRqWr || DmacSoftLSRqWr ||
                 DmacSoftLBRqWr) == 1'b1)
              if (HWDATA[BitNum] == 1'b1)
                $display($time, "Warning : DmacAhbSlaveIf24 : Soft REQ ",
                                " register bit is tried to be written 1 when ",
                                "CLEAR corresponding to it is still HIGH");
        end
    end
end // process p_SmltSftReqProt;

// -----------------------------------------------------------------------------
// Invalid address access detection
// -----------------------------------------------------------------------------
always @(DMACSlaveState or HAddrBuff)
begin : p_AddrDecodeProt
  if (DMACSlaveState == `ST_SLAVE_SELECTED)
    case (HAddrBuff)
        `HADDR_DMACTCCLR, `HADDR_DMACERRCLR, `HADDR_DMACENABLEDCHNS,
        `HADDR_DMACSOFTBREQ, `HADDR_DMACSOFTSREQ, `HADDR_DMACSOFTLBREQ,
        `HADDR_DMACSOFTLSREQ, `HADDR_DMACCONFIG, `HADDR_DMACSYNC,
        `HADDR_DMACTCR, `HADDR_DMACITOP1, `HADDR_DMACITOP2,
        `HADDR_DMACITOP3,
        `HADDR_DMACPERIPHID0, `HADDR_DMACPERIPHID1, `HADDR_DMACPERIPHID2,
        `HADDR_DMACPERIPHID3, `HADDR_DMACPCELLID0, `HADDR_DMACPCELLID1,
        `HADDR_DMACPCELLID2, `HADDR_DMACPCELLID3, `HADDR_DMACINT,
        `HADDR_DMACINTTC, `HADDR_DMACINTERR, `HADDR_DMACRAWINTTC,
        `HADDR_DMACRAWINTERR :;
      default :
        case (HAddrBuff[11:5])
            `HADDR_DMACCHANNEL0, `HADDR_DMACCHANNEL1, `HADDR_DMACCHANNEL2,
            `HADDR_DMACCHANNEL3, `HADDR_DMACCHANNEL4, `HADDR_DMACCHANNEL5,
            `HADDR_DMACCHANNEL6, `HADDR_DMACCHANNEL7 :;
          default :
           $display($time, "Note: DmacAhbSlaveIf1 : Reserved address space",
                           " is accessed");
        endcase
    endcase
end // process p_AddrDecodeProt;

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// synopsys translate_on

endmodule

// --================================== End ==================================--
