//  ----------------------------------------------------------------------------
//  This confidential &proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  &copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version &Release Control Information :
//
//
//  Filename            : KmiTrApbif.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
// Purpose : This block implements the APB inteface for the Keyboard Mouse 
//           Inteface TrickBox. This block generates decodes for register 
//           accesses.
//
// ---------------------------------------------------------------------------

`timescale  1ns/1ps

// ---------------------------------------------------------------------------

module KmiTrApbif (
                   PCLK,
                   BnRES,
                   PADDR,
                   PWDATA,
                   PENABLE,
                   PWRITE,
                   PSEL,
                   KmiTrRXREG,
                   KmiTrCnREG,
                   KmiTrREFCLKOn,
                   KmiTrPCLKOn,
                   KmiTrDWIDTHERR,
                   KmiTrTXBUSY,
                   KmiTrRXBUSY,
                   KmiTrFRAMEERR,
                   KmiTrPARITYERR,
                   KmiTrCLKL,
                   KmiTrCLKH,
                   KmiTrDSI,
                   KmiTrDHI,
                   KmiTrDSO,
                   KmiTrDHO,
                   KmiTrREFCLK,
                   KmiTrRG,
                   KmiTrRXFF,
                   KmiTrRXFE,
                   KmiTrRXFH,
                   KmiTrTXFF,
                   KmiTrTXFE,
                   KmiTrTXFH,
                   KmiINTR,
                   KmiRXINTR,
                   KmiTXINTR,
                   KDATAIN,
                   KCLKIN,
                   KmiTrTIMOUT,
                   KmiTrCLKDIV,
                   KmiTrMODEREG,
                   KmiTrDSOErr,
                   KmiTrDHOErr,
                   WrenTXREG,
                   WrenCnREG,
                   WrenSTAT,
                   WrenCLKL,
                   WrenCLKH,
                   WrenDSI,
                   WrenDHI,
                   WrenDSO,
                   WrenDHO,
                   WrenREFCLK,
                   WrenRG,
                   WrenCLKDIV,
                   WrenTIMOUT,
                   WrenMODEREG,
                   WrenTIMESTAT,
                   PRDATA,
                   RdUpdateRx,
                   PWDataIn,
                  );
           
input         PCLK;          // APB Clock
input         BnRES;         // APB Reset(Active LOW)
input [7:2]   PADDR;         // Address Bus
input [15:0]  PWDATA;        // Data Input Bus
input         PENABLE;       // Access enable
input         PWRITE;        // Write/Read Signal
input         PSEL;          // Peripheral Select
input [7:0]   KmiTrRXREG;    // Received Data
input [4:0]   KmiTrCnREG;    // Control Register
input         KmiTrREFCLKOn; // Data Width Error    (Status Bit 6)
input         KmiTrPCLKOn;   // TxBusy Signal       (Status Bit 5)
input         KmiTrDWIDTHERR;// Data Width Error    (Status Bit 4)
input         KmiTrTXBUSY;   // TxBusy Signal       (Status Bit 3)
input         KmiTrRXBUSY;   // RxBusy Signal       (Status Bit 2)
input         KmiTrFRAMEERR; // Framing Error Signal(Status Bit 1)
input         KmiTrPARITYERR;// Parity Error Signal (Status Bit 0)
input [8:0]   KmiTrCLKL;     // Clock Low Timing
input [8:0]   KmiTrCLKH;     // Clock High Timing
input [15:0]  KmiTrDSI;      // DSI Tim. Param. 
input [15:0]  KmiTrDHI;      // DHI Tim. Param. 
input [15:0]  KmiTrDSO;      // DSO Tim. Param. 
input [15:0]  KmiTrDHO;      // DHO Tim. Param. 
input [7:0]   KmiTrREFCLK;   // Reference Clock
input [15:0]  KmiTrRG;       // RG Tim. Param. 
input         KmiTrRXFF;     // Receiver Fifo Full
input         KmiTrRXFE;     // Receiver Fifo Empty
input         KmiTrRXFH;     // Receiver Fifo More Than Half Full
input         KmiTrTXFF;     // Transmitter Fifo Full
input         KmiTrTXFE;     // Transmitter Fifo Empty
input         KmiTrTXFH;     // Transmitter Fifo Less Than Half Full 
input         KmiINTR;       // Kmi Interrupt Input 
input         KmiRXINTR;     // Kmi Receive Interrupt Input 
input         KmiTXINTR;     // Kmi Transmit Interrupt Input 
input         KDATAIN;       // Data Line Status 
input         KCLKIN;        // Clock Line Status
input [4:0]   KmiTrTIMOUT;   // Time Out Value
input [7:0]   KmiTrCLKDIV;   // Clock Divisor 
input [3:0]   KmiTrMODEREG;  // Kmi Clock/Reset 
input         KmiTrDSOErr;   // DSO Error Signal
input         KmiTrDHOErr;   // DHO Error Signal
output        WrenTXREG;     // Transmitter Register Write Enable
output        WrenCnREG;     // Control Register Write Enable
output        WrenSTAT;      // Status Register Write Enable
output        WrenCLKL;      // Clock Low Time Value Write Enable
output        WrenCLKH;      // Clock High Time Value Write Enable
output        WrenDSI;       // DSI Register Write Enable
output        WrenDHI;       // DHI Register Write Enable
output        WrenDSO;       // DSO Register Write Enable
output        WrenDHO;       // DHO Register Write Enable
output        WrenREFCLK;    // Reference Clock Value Write Enable
output        WrenRG;        // RG Register Write Enable 
output        WrenCLKDIV;    // Reference Clock Divisor Write Enable
output        WrenTIMOUT;    // Time Out Value Write Enable
output        WrenMODEREG;   // Reset/Clock Mode Write Enable
output        WrenTIMESTAT;  // Timing Parameter Status Write Enable
output [15:0] PRDATA;        // Data o/p Bus
output        RdUpdateRx;    // Shift next data in Rx FF
output [15:0] PWDataIn;      // Muxed Data
           
// ---------------------------------------------------------------------------
//
//                           KmiTrApbif
//                           ==========
//
// ---------------------------------------------------------------------------
//
// Overview
// ========
// This module decodes the APB accesses &generates the Read/Write strobes
// for the different registers This module also contains the output data
// multiplexer &the output register that form the read interface. The
// internal databus, for the TrickBox, PWDataIn[15:0], is also generated in this
// module by gating the input data bus, PWDATA[15:0] with PSEL &PWRITE.
//
// ---------------------------------------------------------------------------
//
// ---------------------------------------------------------------------------
//                       TrickBox Register Map
// ---------------------------------------------------------------------------
// Offset     Read(Width)        Write(Width)      Description
// ---------------------------------------------------------------------------
// 0x00  KmiTrRXREG(8 bits)    KmiTrTXREG(8 bits)   TrickBox Data Register 
// 0x04  KmiTrCnREG(5 bits)    KmiCnREG(5 bits)     TrickBox Control Register
// 0x08  KmiTrSTAT(7 bits)     KmiTrSTAT(7 bits)    TrickBox Status  Register
// 0x0C  KmiTrCLKL(9 bits)     KmiTrCLKL(9 bits)    TrickBox Low Clock Timing
// 0x10  KmiTrCLKH(9 bits)     KmiTrCLKH(9 bits)    TrickBox High Clock Timing 
// 0x14  KmiTrDSI(16 bits)     KmiTrDSI(16 bits)    TrickBox DSI Tim. Param.
// 0x18  KmiTrDHI(16 bits)     KmiTrDHI(16 bits)    TrickBox DHI Tim. Param.
// 0x1c  KmiTrDSO(16 bits)     KmiTrDSO(16 bits)    TrickBox DSO Tim. Param.
// 0x20  KmiTrDHO(16 bits)     KmiTrDHO(16 bits)    TrickBox DHO Tim. Param.
// 0x24  KmiTrREFCLK(8 bits)   KmiTrREFCLK(8 bits)  TrickBox REFCLK Timing 
// 0x28  KmiTrRG(16 bits)      KmiTrRG(16 bits)     TrickBox RG Tim. Param.
// 0x2c  KmiTrFFLAG(6 bits)    KmiTrFFLAG(6 bits)   TrickBox Fifo Flag Register
// 0x30  KmiTrCHECKPIN(5 bits) KmiTrCHECKPIN(5 bits)TrickBox Pin Status
// 0x34  KmiTrTIMOUT(5 bits)   KmiTrTIMOUT(5 bits)  TrickBox Timeout Value
// 0x38  KmiTrCLKDIV(8 bits)   KmiTrCLKDIV(8 bits)  TrickBox Clock Divisor
// 0x3c  KmiTrMODEREG(4 bits)  KmiTrMODEREG(4 bits) TrickBox Clock/Reset Value 
// 0x40  KmiTrTIMESTAT(2 bits) KmiTrTIMESTAT(2 bits)TrickBox Timing Error Status
// 
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Constant definitions
// ----------------------------------------------------------------------------
`define DREGADDR     6'b000000 
// Data Register Offset 0x00 from the Base Address

`define CNREGADDR    6'b000001 
// Control Register Offset 0x04 from the Base Address

`define STATREGADDR  6'b000010 
// Status Register Offset 0x08 from the Base Address

`define CLKLADDR     6'b000011 
// CLKL Register Offset 0x0c from the Base Address

`define CLKHADDR     6'b000100 
// CLKH Register Offset 0x10 from the Base Address

`define DSIADDR      6'b000101 
// DSI Register Offset 0x14 from the Base Address

`define DHIADDR      6'b000110 
// DHI Register Offset 0x18 from the Base Address

`define DSOADDR      6'b000111 
// DSO Register Offset 0x1c from the Base Address

`define DHOADDR      6'b001000 
// DHO Register Offset 0x20 from the Base Address

`define REFCLKADDR   6'b001001 
// REFCLK Register Offset 0x24 from the Base Address

`define RGADDR       6'b001010 
// RG Register Offset 0x28 from the Base Address

`define FFLAGADDR    6'b001011 
// FFLAG Register Offset 0x2c from the Base Address

`define CHECKPINADDR 6'b001100 
// CHECKPIN Register Offset 0x30 from the Base Address

`define TIMOUTADDR   6'b001101 
// TIMOUT Register Offset 0x34 from the Base Address

`define CLKDIVADDR   6'b001110 
// CLKDIV Register Offset 0x38 from the Base Address

`define MODEADDR     6'b001111 
// MODE Register Offset 0x3c from the Base Address

`define TIMESTATADDR 6'b010000 
// TIMESTATUS Register Offset 0x40 from the Base Address

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
wire [7:2] GatedPADDR;
// Gate PADDR with PSEL to save power

wire Wren; 
// Write enable

wire Rden; 
// Read enable

wire [6:0] KmiTrSTAT;
// Status Register

wire [5:0] KmiTrFFLAG;
// Flag Status Register

wire [1:0] KmiTrTIMESTAT;
// Time Status Register

wire [4:0] KmiTrCHECKPIN;
// Kmi TrickBox CHECKPIN Register

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Create read vectors by concatenation
// -----------------------------------------------------------------------------

assign KmiTrSTAT  = {KmiTrREFCLKOn, KmiTrPCLKOn, KmiTrDWIDTHERR, KmiTrTXBUSY, 
                     KmiTrRXBUSY, KmiTrFRAMEERR, KmiTrPARITYERR}; 
                    
assign KmiTrFFLAG = {KmiTrRXFF, KmiTrRXFE, KmiTrRXFH, KmiTrTXFF, KmiTrTXFE, 
                     KmiTrTXFH}; 
 
assign KmiTrTIMESTAT = {KmiTrDSOErr, KmiTrDHOErr};
 
assign KmiTrCHECKPIN = {KmiINTR, KmiRXINTR, KmiTXINTR, KDATAIN, KCLKIN}; 
 
// -----------------------------------------------------------------------------
// Write Interface
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Save power by preventing change in internal data bus &address bus 
// the device is not selected.
// -----------------------------------------------------------------------------
assign GatedPADDR   = (PSEL == 1'b1) ? PADDR : 6'b000000;
    
assign PWDataIn     = ((PSEL == 1'b1) & (PWRITE == 1'b1)) ? PWDATA :
                      16'b0000000000000000;

assign Wren         = PSEL & PENABLE & PWRITE;
   
assign WrenTXREG    = ((Wren == 1'b1) & (GatedPADDR == `DREGADDR)) ? 1'b1 : 
                      1'b0;
 
assign WrenCnREG    = ((Wren == 1'b1) &(GatedPADDR == `CNREGADDR)) ? 1'b1 : 
                      1'b0;
   
assign WrenSTAT     = ((Wren == 1'b1) &(GatedPADDR == `STATREGADDR)) ? 1'b1 :
                      1'b0;
  
assign WrenCLKL     = ((Wren == 1'b1) &(GatedPADDR == `CLKLADDR)) ? 1'b1 : 
                      1'b0;
          
assign WrenCLKH     = ((Wren == 1'b1) &(GatedPADDR == `CLKHADDR)) ? 1'b1 : 
                      1'b0;
          
assign WrenDSI      = ((Wren == 1'b1) &(GatedPADDR == `DSIADDR)) ? 1'b1 : 
                      1'b0;
          
assign WrenDHI      = ((Wren == 1'b1) &(GatedPADDR == `DHIADDR)) ? 1'b1 : 
                      1'b0;
         
assign WrenDSO      = ((Wren == 1'b1) &(GatedPADDR == `DSOADDR)) ? 1'b1 : 
                      1'b0;
          
assign WrenDHO      = ((Wren == 1'b1) &(GatedPADDR == `DHOADDR)) ? 1'b1 : 
                      1'b0;
   
assign WrenREFCLK   = ((Wren == 1'b1) &(GatedPADDR == `REFCLKADDR)) ? 1'b1 : 
                      1'b0;
            
assign WrenRG       = ((Wren == 1'b1) &(GatedPADDR == `RGADDR)) ? 1'b1 : 
                      1'b0;
          
assign WrenCLKDIV   = ((Wren == 1'b1) &(GatedPADDR == `CLKDIVADDR)) ? 1'b1 : 
                      1'b0;

assign WrenTIMOUT   = ((Wren == 1'b1) &(GatedPADDR == `TIMOUTADDR)) ? 1'b1 : 
                      1'b0;

assign WrenMODEREG  = ((Wren == 1'b1) &(GatedPADDR == `MODEADDR)) ? 1'b1 : 
                      1'b0;
   
assign WrenTIMESTAT = ((Wren == 1'b1) &(GatedPADDR == `TIMESTATADDR)) ? 1'b1 :
                      1'b0;

// -----------------------------------------------------------------------------
// Read Interface
// -----------------------------------------------------------------------------
assign Rden         = PSEL & ~(PWRITE) & PENABLE;
 
assign RdUpdateRx   = ((Rden == 1'b1) &(GatedPADDR == `DREGADDR)) ? 1'b1 : 
                      1'b0;

// -----------------------------------------------------------------------------
// Output Mux for selecting Data from different registers
// -----------------------------------------------------------------------------
assign PRDATA = (Rden == 1'b1) & (GatedPADDR == `DREGADDR) ? 
                {8'h00, KmiTrRXREG} :
                (Rden == 1'b1) & (GatedPADDR == `CNREGADDR) ?
                {11'h000, KmiTrCnREG} :       
                (Rden == 1'b1) & (GatedPADDR == `STATREGADDR) ?
                {9'h000, KmiTrSTAT} :
                (Rden == 1'b1) & (GatedPADDR == `CLKLADDR) ?
                {7'b00, KmiTrCLKL} :          
                (Rden == 1'b1) & (GatedPADDR == `CLKHADDR) ?
                {7'b00, KmiTrCLKH} :
                (Rden == 1'b1) & (GatedPADDR == `DSIADDR) ? 
                KmiTrDSI :
                (Rden == 1'b1) & (GatedPADDR == `DHIADDR) ? 
                KmiTrDHI :
                (Rden == 1'b1) & (GatedPADDR == `DSOADDR) ? 
                KmiTrDSO :              
                (Rden == 1'b1) & (GatedPADDR == `DHOADDR) ? 
                KmiTrDHO :         
                (Rden == 1'b1) & (GatedPADDR == `FFLAGADDR) ? 
                {10'h000, KmiTrFFLAG} :
                (Rden == 1'b1) & (GatedPADDR == `RGADDR) ? 
                KmiTrRG :
                (Rden == 1'b1) & (GatedPADDR == `REFCLKADDR) ? 
                {8'b00, KmiTrREFCLK} :
                (Rden == 1'b1) & (GatedPADDR == `TIMOUTADDR) ?
                {11'h000, KmiTrTIMOUT} :
                (Rden == 1'b1) & (GatedPADDR == `CLKDIVADDR) ?
                {8'b00, KmiTrCLKDIV} :
                (Rden == 1'b1) & (GatedPADDR == `MODEADDR) ?
                {12'h000, KmiTrMODEREG} :
                (Rden == 1'b1) & (GatedPADDR == `TIMESTATADDR) ?
                {14'b0000, KmiTrTIMESTAT} :
                (Rden == 1'b1) & (GatedPADDR == `CHECKPINADDR) ?
                {11'b000, KmiTrCHECKPIN} :
                16'h0000; 
      
endmodule

// ========================= End of KmiTrApbIf ==============================--
