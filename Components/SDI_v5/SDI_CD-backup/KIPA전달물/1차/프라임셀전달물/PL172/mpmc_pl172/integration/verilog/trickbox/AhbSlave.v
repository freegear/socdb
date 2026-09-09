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
// File Name              : AhbSlave.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Generic AHB Slave to test AHB Slave Testbench 
//
// --=========================================================================--
 
`timescale 1ns/1ps
 
// -----------------------------------------------------------------------------

module AhbSlave (
                 HCLK,
                 HRESETn,
                 HADDR,
                 HTRANS,
                 HWRITE,
                 HSIZE,
                 HBURST,
                 HWDATA,
                 HRDATAIn,
                 HREADYIn,
                 HSPLITIn,
                 HSEL,
                 HMASTER,
                 HMASTLOCK,
                 HRESPIn,
                 HRDATAdly,
                 HREADYdly,
                 HRESPdly,
                 HSPLITdly
                );

input             HCLK;            // AHB Clock Signal
input             HRESETn;         // AHB Reset Signal
input   [31:0]    HADDR;           // AHB  Address Bus
input    [1:0]    HTRANS;          // AHB Transfer Mode
input             HWRITE;          // AHB Read/Write Signal
input    [2:0]    HSIZE;           // AHB Data Transfer Size
input    [2:0]    HBURST;          // AHB Burst type
input   [63:0]    HWDATA;          // AHB Write Data Bus
input   [63:0]    HRDATAIn;        // AHB Read Data Bus 
input             HREADYIn;        // AHB HREADY signal
input   [15:0]    HSPLITIn;        // AHB Split Reply 
input             HSEL;            // Slave select signal
input    [3:0]    HMASTER;         // MASTER driving the Bus 
input             HMASTLOCK;       // Slave locked by Master
input    [1:0]    HRESPIn;         // Combined Response 
output  [63:0]    HRDATAdly;       // AHB Read Data Bus
output            HREADYdly;       // AHB HREADY signal
output   [1:0]    HRESPdly;        // AHB response signal
output  [15:0]    HSPLITdly;       // AHB Splitx signal 
// -----------------------------------------------------------------------------
//
//                             AHBSlave 
//                             ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module is the top level of AHB generic  Split-capable slave  device 
// that aids validation of the Slave testbench. Instantiates all the 
// sub-modules. 
 
// ================================ ARCHITECTURE =============================--
 

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
wire    [2:0] HSIZEdlyInt;
// Internal Data Transfer Size

wire   [31:0] WSCReg1;
// Wait State Register 1

wire   [31:0] WSCReg2;
// Wait State Register 2

wire   [31:0] CR;
// Control Register

wire   [31:0] HADDRdlyInt;
// Internal Clocked Address Bus

wire          HWRITEdlyInt;
// Internal Clocked HWRITE signal

wire          HSELdlyInt;
// Internal Slave Select signal

wire          WrEn;
// Write Enable signal
 
wire          RdEn;
// Read Enable signal
 
wire          WSCReg1Sel;
// Wait State Register 1 Select signal
 
wire          WSCReg2Sel;
// Wait State Register 2 Select signal
 
wire          CRSel;
// Control Register Select signal
 
wire          ARRAY1Sel;
// ARRAY 1 Select signal
 
wire          ARRAY2Sel;
// ARRAY 2 Select signal

wire          TMRegSel;
// TimeOut Register Select signal

wire          XRDlyRegSel;
// Transfer Delay Register Select signal
 
wire   [31:0] HADDRdly;
// Delayed Address Bus

wire    [1:0] HTRANSdly;
// Delayed HTRANS Bus

wire   [31:0] TMReg;
// TimeOut Register

wire   [31:0] XRDlyReg;
// Transfer Delay Reg. 

wire          HWRITEdly;
// Delayed HWRITE signal 

wire          HSELdly;
// Delayed HSEL signal

wire          HMASTLOCKdly;
// Delayed HMASTLOCK signal

wire    [2:0] HSIZEdly;
// Delayed HSIZE signal 

wire    [2:0] HBURSTdly;
// Delayed Burst mode signal 

wire   [63:0] HWDATAdly;
// Delayed  Write Data Bus

wire   [63:0] HRDATAOut;
// Data Output bus

wire          HREADYOut;
// HREADY signal

wire   [15:0] HSPLITOut;
// SPLIT Reply to the Master

wire    [3:0] HMASTERdly;
// Master owning the AHB

wire    [1:0] HRESPOut;
// HRESP signal

wire          BYTE0En;
// Enable signal for 0th Byte in a Double Word

wire          BYTE1En;
// Enable signal for 1st Byte in a Double Word

wire          BYTE2En;
// Enable signal for 2nd Byte in a Double Word

wire          BYTE3En;
// Enable signal for 3rd Byte in a Double Word

wire          BYTE4En;
// Enable signal for 4th Byte in a Double Word

wire          BYTE5En;
// Enable signal for 5th Byte in a Double Word

wire          BYTE6En;
// Enable signal for 6th Byte in a Double Word

wire          BYTE7En;
// Enable signal for 7th Byte in a Double Word
 
// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Signal Mapping 
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Ahbif Module
// -----------------------------------------------------------------------------
Ahbif uAhbif
  (
   .HCLK         (HCLK),
   .HRESETn      (HRESETn),
   .HADDRdly     (HADDRdly),
   .HADDRdlyInt  (HADDRdlyInt),
   .HSELdlyInt   (HSELdlyInt),
   .HSIZEdlyInt  (HSIZEdlyInt),
   .HWRITEdlyInt (HWRITEdlyInt),
   .HTRANSdly    (HTRANSdly),
   .HWRITEdly    (HWRITEdly),
   .HSIZEdly     (HSIZEdly),
   .HBURSTdly    (HBURSTdly),
   .HWDATAdly    (HWDATAdly),
   .HSELdly      (HSELdly),
   .WSCReg1      (WSCReg1),
   .WSCReg2      (WSCReg2),
   .CR           (CR),
   .TMReg        (TMReg),
   .XRDlyReg     (XRDlyReg),
   .HMASTERdly   (HMASTERdly),
   .HMASTLOCKdly (HMASTLOCKdly),
   .HSPLITIn     (HSPLITIn),
   .HREADYIn     (HREADYIn),
   .HRESPIn      (HRESPIn),
   .ARRAY1Sel    (ARRAY1Sel),
   .ARRAY2Sel    (ARRAY2Sel),
   .WrEn         (WrEn),
   .RdEn         (RdEn),
   .WSCReg1Sel   (WSCReg1Sel),
   .WSCReg2Sel   (WSCReg2Sel),
   .CRSel        (CRSel),
   .TMRegSel     (TMRegSel),
   .XRDlyRegSel  (XRDlyRegSel),
   .BYTE0En      (BYTE0En),
   .BYTE1En      (BYTE1En),
   .BYTE2En      (BYTE2En),
   .BYTE3En      (BYTE3En),
   .BYTE4En      (BYTE4En),
   .BYTE5En      (BYTE5En),
   .BYTE6En      (BYTE6En),
   .BYTE7En      (BYTE7En),
   .HREADYOut    (HREADYOut),
   .HSPLITOut    (HSPLITOut),
   .HRESPOut     (HRESPOut)
  );

// -----------------------------------------------------------------------------
// AhbRegBlock Module
// -----------------------------------------------------------------------------
AhbRegBlock uAhbRegBlock
 (
  .HCLK         (HCLK),
  .HRESETn      (HRESETn),
  .HADDRdlyInt  (HADDRdlyInt),
  .HWRITEdlyInt (HWRITEdlyInt),
  .HSIZEdlyInt  (HSIZEdlyInt),
  .HSELdlyInt   (HSELdlyInt), 
  .HWDATAdly    (HWDATAdly),
  .ARRAY1Sel    (ARRAY1Sel),
  .ARRAY2Sel    (ARRAY2Sel),
  .WrEn         (WrEn),
  .RdEn         (RdEn),
  .WSCReg1Sel   (WSCReg1Sel),
  .WSCReg2Sel   (WSCReg2Sel),
  .CRSel        (CRSel),
  .TMRegSel     (TMRegSel),
  .XRDlyRegSel  (XRDlyRegSel),
  .BYTE0En      (BYTE0En),
  .BYTE1En      (BYTE1En),
  .BYTE2En      (BYTE2En),
  .BYTE3En      (BYTE3En),
  .BYTE4En      (BYTE4En),
  .BYTE5En      (BYTE5En),
  .BYTE6En      (BYTE6En),
  .BYTE7En      (BYTE7En),
  .WSCReg1      (WSCReg1),
  .WSCReg2      (WSCReg2),
  .CR           (CR),
  .TMReg        (TMReg),
  .XRDlyReg     (XRDlyReg),
  .HREADYIn     (HREADYIn),
  .HRDATAOut    (HRDATAOut)
);

// -----------------------------------------------------------------------------
// Ahbparam Module
// -----------------------------------------------------------------------------
Ahbparam uAhbparam
  ( 
   .HCLK         (HCLK),
   .HADDR        (HADDR),
   .HTRANS       (HTRANS),
   .HSIZE        (HSIZE),
   .HBURST       (HBURST),
   .DelayEn      (CR[5]),
   .HWRITE       (HWRITE),
   .HMASTER      (HMASTER),
   .HMASTERdly   (HMASTERdly),
   .HMASTLOCK    (HMASTLOCK),
   .HMASTLOCKdly (HMASTLOCKdly),
   .HSEL         (HSEL),
   .HSELdly      (HSELdly),
   .HADDRdly     (HADDRdly),
   .HTRANSdly    (HTRANSdly),
   .HSIZEdly     (HSIZEdly),
   .HBURSTdly    (HBURSTdly),
   .HWRITEdly    (HWRITEdly),
   .HREADYOut    (HREADYOut),
   .HREADYdly    (HREADYdly),
   .HWDATA       (HWDATA),
   .HRDATAOut    (HRDATAOut),
   .HWDATAdly    (HWDATAdly),
   .HRDATAdly    (HRDATAdly),
   .HSPLITOut    (HSPLITOut),
   .HSPLITdly    (HSPLITdly),
   .HRESPOut     (HRESPOut),
   .HRESPdly     (HRESPdly)
  ); 

endmodule
 
// --================================ END ====================================--
