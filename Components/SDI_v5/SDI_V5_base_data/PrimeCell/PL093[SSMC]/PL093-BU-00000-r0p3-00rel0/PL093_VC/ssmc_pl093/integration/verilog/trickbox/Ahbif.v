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
// File Name              : Ahbif.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module implements the AHB bus inteface logic. 
// 
// --=========================================================================--
 
`timescale 1ns/1ps
 
// -----------------------------------------------------------------------------
 
module Ahbif (
              HCLK,
              HRESETn,
              HWRITEdly,
              HREADYIn,
              HSELdly,
              HMASTLOCKdly,
              HADDRdly,
              HTRANSdly,
              HSIZEdly,
              HBURSTdly,
              HWDATAdly,
              HMASTERdly,
              HSPLITIn,
              WSCReg1,
              WSCReg2,
              TMReg,
              XRDlyReg,
              CR,
              HRESPIn,
              HWRITEdlyInt,
              HSELdlyInt,
              WrEn,
              RdEn,
              BYTE0En,
              BYTE1En,
              BYTE2En,
              BYTE3En,
              BYTE4En,
              BYTE5En,
              BYTE6En,
              BYTE7En,
              ARRAY1Sel,
              ARRAY2Sel,
              WSCReg1Sel,
              WSCReg2Sel,
              CRSel,
              TMRegSel,
              XRDlyRegSel,
              HREADYOut,
              HADDRdlyInt,
              HSIZEdlyInt,
              HSPLITOut,
              HRESPOut
              );

input           HCLK;           // AHB Clock Signal
input           HRESETn;        // AHB Reset Signal
input           HWRITEdly;      // AHB Read/Write Signal
input           HREADYIn;       // Combined AHB HREADY from all Slaves
input           HSELdly;        // Slave Selected
input           HMASTLOCKdly;   // Delayed Master Locked signal
input  [31:0]   HADDRdly;       // AHB Address Bus
input   [1:0]   HTRANSdly;      // AHB Transfer type
input   [2:0]   HSIZEdly;       // AHB Data Transfer Size
input   [2:0]   HBURSTdly;      // AHB Burst Mode
input  [63:0]   HWDATAdly;      // AHB Write Data Bus
input   [3:0]   HMASTERdly;     // AHB Master Number
input  [15:0]   HSPLITIn;       // Delayed HSPLIT bus
input  [31:0]   WSCReg1;        // Wait State Register 1
input  [31:0]   WSCReg2;        // Wait State Register 2
input  [31:0]   TMReg;          // Timeout Register
input  [31:0]   XRDlyReg;       // Data delay Required
input  [31:0]   CR;             // Control Register
input   [1:0]   HRESPIn;        // Combined HRESP
output          HWRITEdlyInt;   // Clocked HWRITE signal
output          HSELdlyInt;     // Latched Slave Selected Signal
output          WrEn;           // Write Enabled
output          RdEn;           // Read Enabled
output          BYTE0En;        // Enable signal for 0th Byte in a Double Word 
output          BYTE1En;        // Enable signal for 1th Byte in a Double Word 
output          BYTE2En;        // Enable signal for 2th Byte in a Double Word 
output          BYTE3En;        // Enable signal for 3th Byte in a Double Word 
output          BYTE4En;        // Enable signal for 4th Byte in a Double Word 
output          BYTE5En;        // Enable signal for 5th Byte in a Double Word 
output          BYTE6En;        // Enable signal for 6th Byte in a Double Word 
output          BYTE7En;        // Enable signal for 7th Byte in a Double Word 
output          ARRAY1Sel;      // ARRAY 1 select signal
output          ARRAY2Sel;      // ARRAY 2 select signal
output          WSCReg1Sel;     // Wait State Register 1 select signal
output          WSCReg2Sel;     // Wait State Register 2 select signal
output          CRSel;          // Control Register select signal
output          TMRegSel;       // Timeout Register select signal
output          XRDlyRegSel;    // Transfer Delay time Register select signal
output          HREADYOut;      // HREADY signal
output [31:0]   HADDRdlyInt;    // Clocked HADDR signal
output  [2:0]   HSIZEdlyInt;    // Clocked HSIZE signal
output [15:0]   HSPLITOut;      // Split reply
output  [1:0]   HRESPOut;       // Slave HRESP signal
 
// -----------------------------------------------------------------------------
//
//                             Ahbif
//                             =====
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module samples the AHB signals, latches addresses  and  control signals 
//  and  drives out the appropriate transfer response. It also decodes AHB 
// accesses  and  generates the read/write strobes to the appropriate registers.
// It also inserts required number of wait states  expected for each transfer 
//  and  implements the split  and  retry logic.
// The generic slave has two wait state registers  and  two memory arrays. Each
// array can give all the responses depending upon the memory range being 
// accessed.   

// -----------------------------------------------------------------------------
// Register Base Address `defines 
// -----------------------------------------------------------------------------
`define WSCReg1ADDR     10'b0000000000 
// Wait State Register1 BaseAddress
 
`define WSCReg2ADDR     10'b0000000001
// Wait State Register2 BaseAddress
 
`define CRADDR          10'b0000000010
// Control Register BaseAddress
 
`define TMOUTREGADDR    10'b0000000011
//  TimeOut Register Base Address
 
`define XRDLYREGADDR    10'b0000000100
//  Transfer data delay Register BaseAddress
 
`define ARRAY1LOWADDR   4'b0001
// BaseAddress of Array 1 OK Response Address Range
 
`define ARRAY1ERRADDR   4'b0010 
// BaseAddress of Array 1 Error Response Address Range 
 
`define ARRAY1RTRYADDR  4'b0011 
// BaseAddress of Array 1 Retry Response Address Range
 
`define ARRAY1SPLITADDR 4'b0100 
// BaseAddress of Array 1 Split Response Address Range

`define ARRAY2LOWADDR   4'b0101 
// BaseAddress of Array 1 OK Response Address Range
 
`define ARRAY2ERRADDR   4'b0110 
// BaseAddress of Array 1 Error Response Address Range

`define ARRAY2RTRYADDR  4'b0111 
// BaseAddress of Array 1 Retry Response Address Range
 
`define ARRAY2SPLITADDR 4'b1000
// BaseAddress of Array 1 Split Response Address Range

// ----------------------------------------------------------------------------
// Signal declarations
// ----------------------------------------------------------------------------
wire        iARRAY1Sel;
// Internal ARRAY 1 Select signal 
 
wire        iARRAY2Sel;
// Internal ARRAY 2 Select signal 
 
wire        NextARRAY1Sel;
// ARRAY 1 Select signal  in the Address phase
 
wire        NextARRAY2Sel;
// ARRAY 2 Select signal  in the Address phase

wire        iWSCReg1Sel;
// Internal Wait State Register1 select signal

wire        iWSCReg2Sel;
// Internal Wait State Register2 select signal

wire        iCRSel;
// Internal Control Register1 select signal

wire        iTMRegSel;
// Internal Timeout Register select signal

wire        iXRDlyRegSel;
// Internal Transfer delay Register select signal

wire  [7:0] WSC1Init;
// Wait State Counter value to be loaded in next beat while accessing Array 1

wire  [7:0] WSC2Init;
// Wait State Counter value to be loaded in next beat while accessing Array 2

reg   [7:0] WSC;
// Wait State Counter
 
reg   [7:0] NextWSC;
// D-input of Wait State Counter

reg   [3:0] BeatCount;
// Beat Counter value 

reg   [3:0] NextBeatCount;
// D-input of BeatCounter
 
reg         iHREADYOut;
// Internal HREADY signal

wire  [1:0] RespSel;
// RESP Select signal according to the memory range access

wire  [1:0] iHRESPOut;
// Internal HRESP signal

reg  [31:0] iHADDRdlyInt;
// Internal HADDR signal

reg  [31:0] NxtHADDRdlyInt; 
// D-input  of Address bus

reg         iHWRITEdlyInt;
// Internal HWRITE signal
 
reg         NxtHWRITEdlyInt;
// D-input of HWRITE signal

reg         iHSELdlyInt;
// Internal HSEL signal
 
reg         NxtHSELdlyInt;
// D-input of HSEL signal

reg   [2:0] iHBURSTdlyInt;
// Internal HBURST signal
 
reg   [2:0] NxtHBURSTdlyInt;
// D-input of HBURST signal

reg   [1:0] iHTRANSdlyInt;
// Internal HTRANS signal
 
reg   [1:0] NxtHTRANSdlyInt;
// D-input of HTRANS signal

reg   [3:0] HMASTERdlyInt;
// Internal HMASTER signal
 
reg   [3:0] NxtHMASTERdlyInt;
// D-input of HMASTER signal

reg   [2:0] iHSIZEdlyInt;
// Internal HSIZE signal
 
reg   [2:0] NxtHSIZEdlyInt;
// D-input of HSIZE signal

wire        RespEn;
// Memory access Response enable signal 

wire        ForceErrResp;
// Complement of HRESP signal to generate errors

wire        PopEn;
// Enable signal to pop the Master addresses into HSPLIT bus

wire        FlushEn;
// Indicates Split/retry  Data Transfer over 

wire        LoadQen;
// Enables to load HMASTER into Queue

wire        LoadMasterEn;
// Loads HMASTER into the Active Master address bus

reg   [4:0] ActiveMaster;
// Active Master for which Slave is fetching data  and  a valid bit

reg   [4:0] NxtActiveMaster;
// D-input of Active Master for which Slave is fetching data     

reg  [31:0] ActiveHADDR;
// Active Address for which Slave is fetching data 
 
reg  [31:0] NxtActiveHADDR;
// D-input of Active Address for which Slave is fetching data

reg  [15:0] XRDlyCnt;
// Data Transfer Delay Counter

reg  [15:0] NextXRDlyCnt;
// D-input of Data Transfer Delay Counter 

reg  [31:0] TMOutCnt;
// TimeOut Counter for a particular Master access 
 
reg  [31:0] NextTMOutCnt;
// D-input of TimeOut Counter for a particular Master access

reg         AccType;
// Indicates; Split/Retry Access

reg         NxtAccType;
// D-input of AccType signal 

reg  [15:0] SplitStatus;
// Split Status of 16 Masters

reg  [15:0] NxtSplitStatus;
// D-input of Split Status 

wire [15:0] iHSPLITOut;
// Internal HSPLIT signal

wire  [3:0] Master;
// Internal MASTER signal

// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Assigning the local copy to output
// -----------------------------------------------------------------------------
assign   HREADYOut     = iHREADYOut;
assign   HRESPOut      = (ForceErrResp == 1'b1) ? ~(iHRESPOut) :iHRESPOut;
assign   HSPLITOut     = iHSPLITOut;
assign   HADDRdlyInt   = iHADDRdlyInt;
assign   HSIZEdlyInt   = iHSIZEdlyInt;
assign   HWRITEdlyInt  = iHWRITEdlyInt;
assign   HSELdlyInt    = iHSELdlyInt;
assign   ARRAY1Sel     = iARRAY1Sel;
assign   ARRAY2Sel     = iARRAY2Sel;
assign   WSCReg1Sel    = iWSCReg1Sel;
assign   WSCReg2Sel    = iWSCReg2Sel;
assign   CRSel         = iCRSel;
assign   TMRegSel      = iTMRegSel;
assign   XRDlyRegSel   = iXRDlyRegSel;
assign   ForceErrResp  = CR[2];
assign   RespEn        = CR[4];
// ----------------------------------------------------------------------------
// Latching Address Bus 
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_HADDRSeq 
  if (HRESETn == 1'b0)
    iHADDRdlyInt <= 32'h00000000;
  else 
    iHADDRdlyInt = NxtHADDRdlyInt;
end  // p_HADDRSeq;
 
// -----------------------------------------------------------------------------
// Loading address only when HREADY is set    
// -----------------------------------------------------------------------------
always @ (HADDRdly or HREADYIn or iHADDRdlyInt)
begin : p_HADDRComb 
// Loading address only when HREADY is set at the posedge of HCLK 
  if (HREADYIn == 1'b1) 
    NxtHADDRdlyInt   <= HADDRdly;
  else
    NxtHADDRdlyInt   <= iHADDRdlyInt;
end  // p_HADDRComb;
// ----------------------------------------------------------------------------
// Latching HSEL
// ----------------------------------------------------------------------------
always @ (posedge HCLK or  negedge HRESETn)
begin : p_HSELSeq 
  if (HRESETn == 1'b0) 
    iHSELdlyInt <= 1'b0;
  else 
    iHSELdlyInt <= NxtHSELdlyInt;
end  // p_HSELSeq;
 
// -----------------------------------------------------------------------------
// Loading address only when HREADY is set
// -----------------------------------------------------------------------------
always @ (HSELdly or  HREADYIn or iHSELdlyInt)
begin : p_HSELComb 
// Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn == 1'b1) 
    NxtHSELdlyInt = HSELdly;
  else
    NxtHSELdlyInt = iHSELdlyInt;
end  // p_HSELComb;
// ----------------------------------------------------------------------------
// Latching Write Signal 
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_HWRITEdlySeq 
  if (HRESETn == 1'b0) 
    iHWRITEdlyInt <=  1'b0;
  else 
    iHWRITEdlyInt <= NxtHWRITEdlyInt;
end  // p_HWRITEdlySeq;
 
// -----------------------------------------------------------------------------
//  Loading Write signal only when HREADY is set
// -----------------------------------------------------------------------------
always @ (HWRITEdly or  HREADYIn or  iHWRITEdlyInt)
begin : p_HWRITEdlyComb 
// Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn == 1'b1) 
    NxtHWRITEdlyInt = HWRITEdly;
  else
    NxtHWRITEdlyInt = iHWRITEdlyInt;
end  // p_HWRITEdlyComb;
// ----------------------------------------------------------------------------
// Latching Control signal HSIZE 
// ----------------------------------------------------------------------------
always @ ( posedge HCLK or negedge HRESETn)
begin : p_HSIZEdlySeq 
  if (HRESETn == 1'b0) 
    iHSIZEdlyInt <=  3'b000;
  else 
    iHSIZEdlyInt <= NxtHSIZEdlyInt;
end  // p_HSIZEdlySeq;
 
// -----------------------------------------------------------------------------
// Loading HSIZE signal only when HREADY is set
// -----------------------------------------------------------------------------
always @ (HSIZEdly or  HREADYIn or iHSIZEdlyInt)
begin : p_HSIZEdlyComb 
// Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn == 1'b1) 
    NxtHSIZEdlyInt = HSIZEdly;
  else
    NxtHSIZEdlyInt = iHSIZEdlyInt;
end  // p_HSIZEdlyComb;
// ----------------------------------------------------------------------------
// Latching Control signal HTRANS
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_HTRANSdlySeq 
  if (HRESETn == 1'b0) 
    iHTRANSdlyInt <= 2'b00;  
  else 
    iHTRANSdlyInt <= NxtHTRANSdlyInt;
end  // p_HTRANSdlySeq;
 
// -----------------------------------------------------------------------------
// Loading HTRANS signal only when HREADY is set
// -----------------------------------------------------------------------------
always @ (HTRANSdly or  HREADYIn or  iHTRANSdlyInt)
begin: p_HTRANSdlyComb 
// Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn == 1'b1) 
    NxtHTRANSdlyInt = HTRANSdly;
  else
    NxtHTRANSdlyInt = iHTRANSdlyInt;
end  // p_HTRANSdlyComb;
 
// ----------------------------------------------------------------------------
// Latching Control signal HBURST
// ----------------------------------------------------------------------------
always @ (posedge HCLK or  negedge HRESETn)
begin : p_HBURSTdlySeq 
  if (HRESETn == 1'b0) 
    iHBURSTdlyInt <= 1'b0;
  else 
    iHBURSTdlyInt <= NxtHBURSTdlyInt;
end  // p_HBURSTdlySeq;
 
// -----------------------------------------------------------------------------
// Loading HBURST signal only when HREADY is set
// -----------------------------------------------------------------------------
always @ (HBURSTdly or HREADYIn or iHBURSTdlyInt)
begin : p_HBURSTdlyComb 
// Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn == 1'b1) 
    NxtHBURSTdlyInt = HBURSTdly;
  else
    NxtHBURSTdlyInt = iHBURSTdlyInt;
end  // p_HBURSTdlyComb;
// ----------------------------------------------------------------------------
// Latching HMASTER Signal
// ----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HMASTERdlySeq
  if (HRESETn == 1'b0) 
    HMASTERdlyInt <=  4'b0000;
  else
    HMASTERdlyInt <= NxtHMASTERdlyInt;
end // p_HMASTERdlySeq;
 
// -----------------------------------------------------------------------------
// Loading HMASTER signal only when HREADY is set
// -----------------------------------------------------------------------------
always @(HMASTERdly or HREADYIn or HMASTERdlyInt)
begin : p_HMASTERdlyComb 
  if (HREADYIn == 1'b1) 
    NxtHMASTERdlyInt <= HMASTERdly;
  else
    NxtHMASTERdlyInt <= HMASTERdlyInt;
end // p_HMASTERdlyComb;
 
// ----------------------------------------------------------------------------
// Combinational Decode logic for Control  and  Wait state registers  
// ----------------------------------------------------------------------------
assign iWSCReg1Sel   = ((iHADDRdlyInt[11:2] == `WSCReg1ADDR) &  
                        (iHSELdlyInt == 1'b1)) ?  1'b1 : 1'b0;
assign iWSCReg2Sel   = ((iHADDRdlyInt[11:2] == `WSCReg2ADDR)  &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;
assign iCRSel        = ((iHADDRdlyInt[11:2] == `CRADDR)  &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;
assign iTMRegSel     = ((iHADDRdlyInt[11:2] == `TMOUTREGADDR) &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;
assign iXRDlyRegSel  = ((iHADDRdlyInt[11:2] == `XRDLYREGADDR) &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;

assign iARRAY1Sel    = ((iHADDRdlyInt[11:8] >= `ARRAY1LOWADDR)   &
                        (iHADDRdlyInt[11:8] <= `ARRAY1SPLITADDR) &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;

assign iARRAY2Sel    = ((iHADDRdlyInt[11:8] >= `ARRAY2LOWADDR)   &  
                        (iHADDRdlyInt[11:8] <= `ARRAY2SPLITADDR) &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;

assign NextARRAY1Sel = ((HADDRdly[11:8] >= `ARRAY1LOWADDR)    &  
                        (HADDRdly[11:8] <= `ARRAY1SPLITADDR)  &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;
assign NextARRAY2Sel = ((HADDRdly[11:8] >= `ARRAY2LOWADDR)    &  
                        (HADDRdly[11:8] <= `ARRAY2SPLITADDR)  &  
                        (iHSELdlyInt == 1'b1)) ? 1'b1 : 1'b0;

assign WrEn = iHWRITEdlyInt  &  iHTRANSdlyInt[1];

assign RdEn = ( !(iHWRITEdlyInt))  &  iHTRANSdlyInt[1];

// ----------------------------------------------------------------------------
// Combinational Decode logic to select the byte location being accessed 
// ----------------------------------------------------------------------------

assign BYTE0En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b000))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b00))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b0))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
 
assign BYTE1En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b001))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b00))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b0))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
 
assign BYTE2En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b010))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b01))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b0))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
 
assign BYTE3En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b011))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b01))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b0))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;

assign BYTE4En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b100))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b10))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b1))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
 
assign BYTE5En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b101))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b10))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b1))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
 
assign BYTE6En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b110))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b11))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b1))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
 
assign BYTE7En    = (((iHSIZEdlyInt[1:0] == 2'b00)
                     &  (iHADDRdlyInt[2:0] == 3'b111))
                     | ((iHSIZEdlyInt[1:0] == 2'b01)
                        &  (iHADDRdlyInt[2:1] == 2'b11))
                     | ((iHSIZEdlyInt[1:0] == 2'b10)
                        &  (iHADDRdlyInt[2] == 1'b1))
                     | (iHSIZEdlyInt[1:0] == 2'b11)) ? 1'b1 : 1'b0;
// ----------------------------------------------------------------------------
// Generating Response Signal 
// ----------------------------------------------------------------------------
assign RespSel =  (((iHADDRdlyInt[11:8] == `ARRAY1ERRADDR)   
                     | (iHADDRdlyInt[11:8] == `ARRAY2ERRADDR))  &       
                     (iHSELdlyInt == 1'b1)  &  (RespEn == 1'b1)) ? 2'b01 :
                  (((iHADDRdlyInt[11:8] == `ARRAY1RTRYADDR)   
                     | (iHADDRdlyInt[11:8] == `ARRAY2RTRYADDR))  &  
                     (iHSELdlyInt == 1'b1)  &  (RespEn == 1'b1)) ? 2'b10 :
                   (((iHADDRdlyInt[11:8] == `ARRAY1SPLITADDR)   
                     |  (iHADDRdlyInt[11:8] == `ARRAY2SPLITADDR))  &  
                     (iHSELdlyInt == 1'b1)  &  (RespEn == 1'b1)) ? 
                  2'b11 : 2'b00;

assign iHRESPOut     = ((iHTRANSdlyInt[1] == 1'b0) | (PopEn == 1'b1)| 
                        ((LoadMasterEn == 1'b0) &
                         (XRDlyCnt == 16'b0000000000000000) &
                         (ActiveMaster == { 1'b1, HMASTERdlyInt})) | 
                         ((RespSel != 2'b00)  &  (WSC > 8'b00000001))) ?
                         2'b00 : RespSel;
// ----------------------------------------------------------------------------
// Wait Cycles to be introduced in next beat : 
// While accessing  ARRAY #1 :
// WSCReg1(7:0) if it is INCR
// different wait states in other burst modes depending upon beatcount 
// ----------------------------------------------------------------------------
assign WSC1Init   =  ((HBURSTdly[2:1] == 2'b00) | 
                      ((HBURSTdly[2:1] == 2'b01)
                      &   (HTRANSdly == 2'b10))) ? WSCReg1[7:0] : 
                     ((HBURSTdly[2:1] == 2'b01)  &  
                      (BeatCount == 4'b0000)) ? WSCReg1[15:8] :  
                     ((HBURSTdly[2:1] == 2'b01) &
                      (BeatCount == 4'b0001)) ? WSCReg1[23:16] : 
                     ((HBURSTdly[2:1] == 2'b01) &
                      (BeatCount == 4'b0010)) ? WSCReg1[31:24] : 
                     ((HBURSTdly[2:1]  == 2'b10) &  
                      (HTRANSdly == 2'b10)) ? {4'b0000,  WSCReg1[3:0]} : 
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0000)) ? {4'b0000, WSCReg1[7:4]}:
                     ((HBURSTdly[2:1]  == 2'b10)  &
                      (BeatCount == 4'b0001)) ? {4'b0000, WSCReg1[11:8]}:
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0010)) ? {4'b0000, WSCReg1[15:12]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0011)) ? {4'b0000, WSCReg1[19:16]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0100)) ? {4'b0000, WSCReg1[23:20]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0101)) ? {4'b0000, WSCReg1[27:24]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0110)) ? {4'b0000,  WSCReg1[31:28]} :
                     ((HBURSTdly[2:1]  == 2'b11)  & 
                     (HTRANSdly == 2'b10)) ? {6'b000000, WSCReg1[1:0]} :
                     ((HBURSTdly[2:1]    == 2'b11)  &  
                      (BeatCount == 4'b0000))? {6'b000000, WSCReg1[3:2]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0001)) ? {6'b000000, WSCReg1[5:4]} : 
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0010)) ? {6'b000000, WSCReg1[7:6]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0011)) ? {6'b000000, WSCReg1[9:8]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0100)) ? {6'b000000, WSCReg1[11:10]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0101)) ? {6'b000000, WSCReg1[13:12]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0110)) ? {6'b000000, WSCReg1[15:14]} :
                     ((HBURSTdly[2:1]  == 2'b11  &  
                      (BeatCount == 4'b0111)) ? {6'b000000, WSCReg1[17:16]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1000)) ? {6'b000000, WSCReg1[19:18]}  :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1001)) ? {6'b000000, WSCReg1[21:20] } :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1010)) ? {6'b000000, WSCReg1[23:22] } :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1011)) ? {6'b000000, WSCReg1[25:24]}  :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1100)) ? {6'b000000, WSCReg1[27:26]} :
                     (HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1101)) ? {6'b000000, WSCReg1[29:28]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1110)) ?  {6'b000000, WSCReg1[31:30]} : 
                      1'b0;
 

assign WSC2Init   =  ((HBURSTdly[2:1] == 2'b00) | 
                      ((HBURSTdly[2:1] == 2'b01)
                      &   (HTRANSdly == 2'b10))) ? WSCReg2[7:0] : 
                     ((HBURSTdly[2:1] == 2'b01)  &  
                      (BeatCount == 4'b0000)) ? WSCReg2[15:8] :  
                     ((HBURSTdly[2:1] == 2'b01) &
                      (BeatCount == 4'b0001)) ? WSCReg2[23:16] : 
                     ((HBURSTdly[2:1] == 2'b01) &
                      (BeatCount == 4'b0010)) ? WSCReg2[31:24] : 
                     ((HBURSTdly[2:1]  == 2'b10) &  
                      (HTRANSdly == 2'b10)) ? {4'b0000,  WSCReg2[3:0]} : 
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0000)) ? {4'b0000, WSCReg2[7:4]} :
                      ((HBURSTdly[2:1]  == 2'b10)  &
                      (BeatCount == 4'b0001)) ? {4'b0000, WSCReg2[11:8]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0010)) ? {4'b0000, WSCReg2[15:12]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0011)) ? {4'b0000, WSCReg2[19:16]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0100)) ? {4'b0000, WSCReg2[23:20]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0101)) ? {4'b0000, WSCReg2[27:24]} :
                     ((HBURSTdly[2:1]  == 2'b10)  &  
                      (BeatCount == 4'b0110)) ? {4'b0000,  WSCReg2[31:28]} :
                     ((HBURSTdly[2:1]  == 2'b11)  & 
                     (HTRANSdly == 2'b10)) ? {6'b000000, WSCReg2[1:0]} :
                     ((HBURSTdly[2:1]    == 2'b11)  &  
                      (BeatCount == 4'b0000))? {6'b000000, WSCReg2[3:2]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0001)) ? {6'b000000, WSCReg2[5:4]} : 
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0010)) ? {6'b000000, WSCReg2[7:6]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0011)) ? {6'b000000, WSCReg2[9:8]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0100)) ? {6'b000000, WSCReg2[11:10]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0101)) ? {6'b000000, WSCReg2[13:12]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b0110)) ? {6'b000000, WSCReg2[15:14]} :
                     ((HBURSTdly[2:1]  == 2'b11  &  
                      (BeatCount == 4'b0111)) ? {6'b000000, WSCReg2[17:16]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1000)) ? {6'b000000, WSCReg2[19:18]}  :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1001)) ? {6'b000000, WSCReg2[21:20] } :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1010)) ? {6'b000000, WSCReg2[23:22] } :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1011)) ? {6'b000000, WSCReg2[25:24]}  :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1100)) ? {6'b000000, WSCReg2[27:26]} :
                     (HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1101)) ? {6'b000000, WSCReg2[29:28]} :
                     ((HBURSTdly[2:1] == 2'b11)  &  
                      (BeatCount == 4'b1110)) ?  {6'b000000, WSCReg2[31:30]} : 
                      1'b0;
                                         
// ----------------------------------------------------------------------------
// LoadMasterEn signal loads the ActiveMaster for which  the slave has given a
// split or  retry
// ----------------------------------------------------------------------------
assign   LoadMasterEn = ((HREADYIn == 1'b0) & (((((HRESPIn == 2'b11)  &  
                         (ActiveMaster[3:0] == HMASTERdlyInt)) |
                         (ActiveMaster[3:0] != HMASTERdlyInt)) &
                         (HRESPIn == 2'b10)) | ((HRESPIn == 2'b11)  &
                         (ActiveMaster[4] == 1'b0)))) ? 1'b1 : 
                         ((HREADYIn == 1'b0) & (HRESPIn[1] == 1'b1) &  
                         (ActiveMaster[4] == 1'b0) & (HMASTLOCKdly == 1'b1)) ?
                         1'b1 : 1'b0;

// ----------------------------------------------------------------------------
// LoadQEn denotes the bus master has to be loaded in split queue.
// ----------------------------------------------------------------------------
assign   LoadQen  = ((HREADYIn == 1'b0)  & (HRESPIn == 2'b11) &
                     (ActiveMaster[4] == 1'b1)  & (HMASTLOCKdly == 1'b0) & 
                     (ActiveMaster[3:0] != HMASTERdlyInt)) ? 1'b1 : 1'b0;

// ----------------------------------------------------------------------------
// PopEn denotes that current access is successful  &  the split queue has to
// be popped.
// ----------------------------------------------------------------------------
assign   PopEn   =  ((LoadMasterEn == 1'b0)  &  
                     (XRDlyCnt == 16'b0000000000000000)  &  
                     (ActiveMaster == {1'b1, HMASTERdlyInt})) ? 1'b1 : 1'b0;

// ----------------------------------------------------------------------------
// FlushEn denotes split/retry access is over  &  asserts HREADY.
// ----------------------------------------------------------------------------
assign   FlushEn = ((PopEn == 1'b1)  &  (iHSPLITOut == 16'b0000000000000000)) ?
                   1'b1 : 1'b0;

// ----------------------------------------------------------------------------
// SPLITx lines from AHB Slave
// ----------------------------------------------------------------------------
assign   iHSPLITOut = ((XRDlyCnt == 16'b0000000000000001)  &  
                      (HREADYIn == 1'b1)  &  (RespSel[1] == 1'b1)
                      &  (AccType == 1'b1)  &  
                      (ActiveMaster[3:0] == HMASTERdlyInt)) ? 
                      SplitStatus : 16'd0;                    

// ----------------------------------------------------------------------------
// Master address to be loaded in queue
 // ----------------------------------------------------------------------------
assign   Master = (LoadQen == 1'b1 | LoadMasterEn == 1'b1) ? HMASTERdlyInt 
                                                             : 4'b0000; 

// ----------------------------------------------------------------------------
// SPLIT status of all the masters 
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_LdQSeq 
  if (HRESETn == 1'b0) 
    SplitStatus <=  16'h0000;
  else 
    SplitStatus <= NxtSplitStatus;
end  // p_LdQSeq;
 
// -----------------------------------------------------------------------------
// Asserting  &  deasserting SPLIT status of masters
// -----------------------------------------------------------------------------
always @ (LoadMasterEn or PopEn or LoadQen or SplitStatus or Master or  HRESPIn)
begin : p_LdQComb 
  if ((LoadQen == 1'b1) | ((LoadMasterEn == 1'b1)  &  (HRESPIn == 2'b11))) 
    begin
      NxtSplitStatus = SplitStatus;
      case (Master) 
      4'b0000: 
        NxtSplitStatus[0] = LoadQen | LoadMasterEn;
      4'b0001:
        NxtSplitStatus[1] = LoadQen | LoadMasterEn;
      4'b0010:
        NxtSplitStatus[2] = LoadQen | LoadMasterEn;
      4'b0011:
        NxtSplitStatus[3] = LoadQen | LoadMasterEn;
      4'b0100:
        NxtSplitStatus[4] = LoadQen | LoadMasterEn;
      4'b0101:
        NxtSplitStatus[5] = LoadQen | LoadMasterEn;
      4'b0110:
        NxtSplitStatus[6] = LoadQen | LoadMasterEn;
      4'b0111:
        NxtSplitStatus[7] = LoadQen | LoadMasterEn;
      4'b1000:
        NxtSplitStatus[8] = LoadQen | LoadMasterEn;
      4'b1001:
        NxtSplitStatus[9] = LoadQen | LoadMasterEn;
      4'b1010:
        NxtSplitStatus[10] = LoadQen | LoadMasterEn;
      4'b1011:
        NxtSplitStatus[11] = LoadQen | LoadMasterEn;
      4'b1100:
        NxtSplitStatus[12] = LoadQen | LoadMasterEn;
      4'b1101:
        NxtSplitStatus[13] = LoadQen | LoadMasterEn;
      4'b1110:
        NxtSplitStatus[14] = LoadQen | LoadMasterEn;
      4'b1111:
        NxtSplitStatus[15] = LoadQen | LoadMasterEn;
      default:
        NxtSplitStatus     =  16'd0;
     endcase
   end 
  else
    begin
      if (PopEn == 1'b1)
        NxtSplitStatus = 16'b0000000000000000;
      else
        NxtSplitStatus = SplitStatus;
    end
end  // p_LdQComb;
 
// ----------------------------------------------------------------------------
// Loading the Master address f| which the slave is fetching data
// Loading the access type, if SPLIT then AccType => 1.
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_LdMasterSeq 
  if (HRESETn == 1'b0) 
    begin
      ActiveMaster <= 1'b0;
      AccType      <= 1'b0;
      ActiveHADDR  <= 1'b0;
    end
  else 
    begin
      ActiveMaster <= NxtActiveMaster;
      AccType      <= NxtAccType;
      ActiveHADDR  <= NxtActiveHADDR;
    end
end  // p_LdMasterSeq;
 
// -----------------------------------------------------------------------------
// Loads ActiveMaster when a new master comes in  &  is given a retry,or when a
// Master comes up with a SPLIT access when Slave is not fetching data for any 
// other master which is SPLIT/RETRY. 
// -----------------------------------------------------------------------------
always @ (ActiveMaster or HMASTERdlyInt or LoadMasterEn or FlushEn or TMOutCnt)
begin : p_LdMasterComb 
  if ((LoadMasterEn == 1'b1)  &  (ActiveMaster[3:0] != HMASTERdlyInt)) 
    NxtActiveMaster =  {1'b1 , HMASTERdlyInt};
  else if ((FlushEn == 1'b1) | (TMOutCnt == 32'h00000000)) 
    NxtActiveMaster =  4'b0000;
  else
    NxtActiveMaster = ActiveMaster;
end  // p_LdMasterComb;
// ----------------------------------------------------------------------------
// Loading Access type with which slave responded to Master
// ----------------------------------------------------------------------------
always @ (LoadMasterEn or FlushEn or TMOutCnt or AccType or HRESPIn or
          iHADDRdlyInt or ActiveHADDR)
begin : p_LdAccComb 
  if (LoadMasterEn == 1'b1) 
    begin
      NxtAccType      = HRESPIn[0];
      NxtActiveHADDR  = iHADDRdlyInt;
    end
  else if ((FlushEn == 1'b1) | (TMOutCnt == 32'h00000000))
    begin
      NxtAccType      = 1'b0;
      NxtActiveHADDR  = 1'b0;
    end
  else
    begin
      NxtAccType      = AccType;
      NxtActiveHADDR  = ActiveHADDR;
    end
end  // p_LdAccComb;

// ----------------------------------------------------------------------------
// TimeOut Counter
// ----------------------------------------------------------------------------
always @ (posedge HCLK or  negedge HRESETn)
begin : p_TMOutCntSeq 
  if (HRESETn == 1'b0) 
    TMOutCnt <= 1'b0;
  else 
    TMOutCnt <= NextTMOutCnt;
end  // p_TMOutCntSeq;
 
// -----------------------------------------------------------------------------
// Timeout Counter loaded when a Master takes over the slave
// -----------------------------------------------------------------------------
always @ (TMOutCnt or LoadMasterEn or TMReg)
begin : p_TMOutCntComb 
  if ((LoadMasterEn == 1'b1) & (ActiveMaster[3:0] != HMASTERdlyInt))  
    NextTMOutCnt = TMReg;
  else if (ActiveMaster[4] == 1'b1) 
    NextTMOutCnt = TMOutCnt - 1;
  else
    NextTMOutCnt = TMOutCnt;
end  // p_TMOutCntComb;
 
// ----------------------------------------------------------------------------
// Transfer delay reqd. by slave
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_XRDlyCntSeq 
  if (HRESETn == 1'b0) 
    XRDlyCnt <=  1'b0;
  else 
    XRDlyCnt <= NextXRDlyCnt;
end  // p_XRDlyCntSeq;
 
// -----------------------------------------------------------------------------
// Counter loaded when slave starts fetching data f| a SPLIT/RETRY access
// Decrement counter whenever the same slave comes f| an access again
// -----------------------------------------------------------------------------
always @ (XRDlyCnt or LoadMasterEn or ActiveMaster or HMASTERdlyInt or
          HREADYIn or HRESPIn or NxtActiveMaster or XRDlyReg or
          RespSel or XRDlyCnt)
begin : p_XRDlyCntComb 
  if ((LoadMasterEn == 1'b1) & (ActiveMaster[3: 0] != HMASTERdlyInt)) 
    begin 
      if (HRESPIn[0] == 1'b0) 
         NextXRDlyCnt = XRDlyReg[31:16];
      else
        NextXRDlyCnt = XRDlyReg[15:0];
    end
  else if ((HREADYIn == 1'b0)  &  ((HRESPIn[1] == 1'b1) |
           ((RespSel[1] == 1'b1) & (XRDlyCnt == 16'b0000000000000001)))
           &  (ActiveMaster == {1'b1,HMASTERdlyInt})) 
    NextXRDlyCnt = XRDlyCnt - 1;
  else
    NextXRDlyCnt = XRDlyCnt;
end  // p_XRDlyCntComb;
 
// ----------------------------------------------------------------------------
// F| introducing different wait states depending upon type of burst 
// BeatCounter is instantiated. 
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_BeatCountSeq 
  if (HRESETn == 1'b0) 
    BeatCount <=  1'b0;
  else 
    BeatCount <= NextBeatCount;
end  // p_BeatCountSeq;
 
// -----------------------------------------------------------------------------
// If NSEQ is detected or then BeatCounter is cleared.
// Else if it is a SEQ  &  not an INCR or then if HREADY is set or BeatCount has to // be incremented 
// -----------------------------------------------------------------------------
always @ (iHTRANSdlyInt or iHBURSTdlyInt or HREADYIn or BeatCount)
begin : p_BeatCountComb 
  if (iHTRANSdlyInt == 2'b10) 
    NextBeatCount = 1'b0;
  else if ((iHBURSTdlyInt != 3'b000)  &  (iHTRANSdlyInt[1] == 1'b1) 
           &  (HREADYIn == 1'b1)) 
    NextBeatCount = BeatCount + 1;
  else
    NextBeatCount = BeatCount;
end  // p_BeatCountComb;
 
// -----------------------------------------------------------------------------
// HREADY set high immediately if Registers are being accessed  &  in BUSY and
// IDLE transfers.
// Once a SPLIT/RETRY transfer is complete.
// Else set high only when Wait State Counter is cleared in n|mal transfers 
// -----------------------------------------------------------------------------
always @ (iHTRANSdlyInt or iWSCReg1Sel or iWSCReg2Sel or iCRSel or 
          iXRDlyRegSel or iTMRegSel or iARRAY1Sel or iARRAY2Sel or 
          HRESPIn or WSC or FlushEn)
begin : p_HREADYComb 
  if ((iWSCReg1Sel == 1'b1) | (iWSCReg2Sel == 1'b1) | (iCRSel == 1'b1) | 
      (iTMRegSel == 1'b1) | (iXRDlyRegSel == 1'b1) | 
      (iHTRANSdlyInt[1] == 1'b0)) 
    iHREADYOut = 1'b1;
  else if ((FlushEn == 1'b1)  &  (ActiveMaster[4] == 1'b1)) 
    iHREADYOut = 1'b1;
  else if ((iHTRANSdlyInt[1] == 1'b1)  &  ((iARRAY1Sel == 1'b1) | 
           (iARRAY2Sel == 1'b1)
          | (HRESPIn == 2'b01))  &  (WSC == 8'b00000000)) 
    iHREADYOut = 1'b1;
  else
    iHREADYOut = 1'b0;
end  // p_HREADYComb;
 
// ----------------------------------------------------------------------------
// Wait State Counter Generation 
// ----------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn)
begin : p_WSCSeq 
  if (HRESETn == 1'b0) 
    WSC <=  1'b0;
  else 
    WSC <= NextWSC;
end  // p_WSCSeq;
 
// -----------------------------------------------------------------------------
// When HREADY is set, load new value in Wait State Counter
// An access to the arrays immediately after the waitstate value has changed,
// should load the WSC with new value.
// Else WSCInit value will be loaded
// If HREADY is not set, WSC is decremented.  
// -----------------------------------------------------------------------------
always @ (HREADYIn or HWDATAdly or WSC or iHWRITEdlyInt or iWSCReg1Sel or 
          iWSCReg2Sel or NextARRAY1Sel or NextARRAY2Sel or WSC1Init or 
          WSC2Init or HADDRdly)
begin : p_WSCComb 
  if (HREADYIn == 1'b1) 
    begin 
      if (NextARRAY1Sel == 1'b1) 
        begin 
          if ((iHWRITEdlyInt == 1'b1)  &  (iWSCReg1Sel == 1'b1)) 
            begin
              if (iHBURSTdlyInt[0] == 1'b0) 
                NextWSC = HWDATAdly[7:0];
              else
                NextWSC ={4'b0000, HWDATAdly[3:0]};
            end
          else 
            begin
              if (HADDRdly[31:8] != 24'b000000000000000000000001)
                NextWSC = WSC1Init + 4'b0010;
              else  
                NextWSC = WSC1Init;
            end
        end
      else if (NextARRAY2Sel == 1'b1) 
        begin
          if ((iHWRITEdlyInt == 1'b1)  &  (iWSCReg2Sel == 1'b1)) 
            begin
              if (iHBURSTdlyInt[0] == 1'b0) 
                NextWSC = HWDATAdly[7:0];
              else
                NextWSC = {4'b0000, HWDATAdly[3:0]};
            end
          else
            begin
              if (HADDRdly[31:8] != 24'b000000000000000000000101)
                NextWSC = WSC2Init + 4'b0010;
              else
                NextWSC = WSC2Init;
            end
        end
    end
  else
    NextWSC = WSC - 1;
end  // p_WSCComb;

initial
begin
 iHREADYOut  = 1'b0;
// iHRESPOut   = 2'b00;
end

endmodule 

// --================================ END ====================================--
