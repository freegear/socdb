//  ----------------------------------------------------------------------------
//  This confidential & proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  & copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version & Release Control Information :
//
//
//  Filename            : KmiTrRegFile.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
// ----------------------------------------------------------------------------
// Purpose : This block holds the different registers within the TrickBox.
//           It also generates the TrickBox Fifo Status signals.
//
// ----------------------------------------------------------------------------

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module KmiTrRegFile (
                     WrenTXREG,
                     WrenCnREG,
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
                     DataAvl,
                     RdUpdateRx,
                     RdUpdateTx,
                     PWDataIn,
                     RXDATAIN,
                     PCLK,
                     BnRES,
                     KmiTrRXFF,
                     KmiTrRXFE,
                     KmiTrRXFH,
                     KmiTrTXFF,
                     KmiTrTXFE,
                     KmiTrTXFH,
                     KmiTrRXREG,
                     KmiTrTXREG,
                     KmiTrCnREG,
                     KmiTrCLKL,
                     KmiTrCLKH,
                     KmiTrDSI,
                     KmiTrDHI,
                     KmiTrDSO,
                     KmiTrDHO,
                     KmiTrREFCLK,
                     KmiTrRG,
                     KmiTrCLKDIV,
                     KmiTrTIMOUT,
                     KmiTrMODEREG
                    );
 
input         WrenTXREG;    // Transmit Register Write from APB 
input         WrenCnREG;    // Control Register Write from APB 
input         WrenCLKL;     // Clock Low Time Value Write from APB
input         WrenCLKH;     // Clock High Time Value Write from APB
input         WrenDSI;      // DSI Write from APB
input         WrenDHI;      // DHI Write from APB
input         WrenDSO;      // DSO Write from APB
input         WrenDHO;      // DHO Write from APB
input         WrenREFCLK;   // REFCLK write from APB
input         WrenRG;       // RG  Write from APB
input         WrenCLKDIV;   // CLKDIV Write from APB
input         WrenTIMOUT;   // TIMOUT Write from APB 
input         WrenMODEREG;  // MODEREG write from APB
input         DataAvl;      // Receive Register Write from Rx Block
input         RdUpdateRx;   // To Read Next Data in RXFF
input         RdUpdateTx;   // To Read Next Data in TXFF
input [15:0]  PWDataIn;     // Muxed Data from APB
input [7:0]   RXDATAIN;     // Data from Rx 
input         PCLK;         // APB Clock
input         BnRES;        // APB Reset
output        KmiTrRXFF;    // Receiver Buffer Full
output        KmiTrRXFE;    // Receiver Buffer Empty
output        KmiTrRXFH;    // Receiver Buffer More Than Half Full
output        KmiTrTXFF;    // Transmitter Buffer Full
output        KmiTrTXFE;    // Transmitter Buffer Empty
output        KmiTrTXFH;    // Transmitter Buffer Less Than Half Full
output [7:0]  KmiTrRXREG;   // Receiver Buffer
output [7:0]  KmiTrTXREG;   // Transmitter Buffer
output [4:0]  KmiTrCnREG;   // Control Register
output [8:0]  KmiTrCLKL;    // Clock Low Time Reg
output [8:0]  KmiTrCLKH;    // Clock High Time Reg
output [15:0] KmiTrDSI;     // DSI Tim. Param.
output [15:0] KmiTrDHI;     // DSI Tim. Param.
output [15:0] KmiTrDSO;     // DSI Tim. Param.
output [15:0] KmiTrDHO;     // DSI Tim. Param.
output [7:0]  KmiTrREFCLK;  // REFCLK Register
output [15:0] KmiTrRG;      // DSI Tim. Param.
output [7:0]  KmiTrCLKDIV;  // Clock Divisor value
output [4:0]  KmiTrTIMOUT;  // Time Out Value
output [3:0]  KmiTrMODEREG;  // CLK/Reset Register

// ----------------------------------------------------------------------------
//
//                           KmiTrRegFile
//                           ============
//
// ----------------------------------------------------------------------------
//
// Overview
// ========
// The different registers within the TrickBox are implemented here. Write 
// to these registers will update the contents. 
// 
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declaration
// ---------------------------------------------------------------------------- 
wire  KmiTrRXFF;    
// Receiver Buffer Full

wire  KmiTrRXFE;    
// Receiver Buffer Empty

wire  KmiTrRXFH;    
// Receiver Buffer More Than Half Full

wire  KmiTrTXFF;    
// Transmitter Buffer Full

wire  KmiTrTXFE;    
// Transmitter Buffer Empty

wire  KmiTrTXFH;    
// Transmitter Buffer Less Than Half Full

wire [4:0] KmiTrCnREG;
// Internal Copy of Control Register
   
wire [4:0] NextKmiTrCnREG;
// D input to KmiTrCnREG
 
wire [8:0] KmiTrCLKL;
// Internal Copy of KmiTrCLKL
   
wire [8:0]  NextKmiTrCLKL;
// D input to KmiTrCLKL
   
wire [8:0]  KmiTrCLKH;
// Internal Copy of KmiTrCLKH
   
wire [8:0]  NextKmiTrCLKH;
// D input to KmiTrCLKH

wire [15:0] KmiTrDSI;
// Internal Copy of DSI Reg
   
wire [15:0]  NextKmiTrDSI;
// D input to DSI Reg

wire [15:0]  KmiTrDHI;
// Internal Copy of DHI Reg
   
wire [15:0]  NextKmiTrDHI;
//  D input to DHI Reg

wire [15:0] KmiTrDSO;
// Internal Copy of DSO Reg
   
wire [15:0] NextKmiTrDSO;
// D input to DSO Reg
   
wire [15:0] KmiTrDHO;
// Internal Copy of DHO Reg
   
wire [15:0] NextKmiTrDHO;
// D input to DHO Reg

wire [7:0] KmiTrREFCLK;
// Internal Copy of REFCLK Value
   
wire [7:0] NextKmiTrREFCLK;
// D input to KmiTrREFCLK
   
wire [15:0] KmiTrRG;
// Internal Copy of RG Reg
   
wire [15:0] NextKmiTrRG;
// D input to RG Reg

wire [7:0] KmiTrCLKDIV;
// Internal Copy of Clock Divisor value
   
wire [7:0] NextKmiTrCLKDIV;
// D input to KmiTrCLKDIV
   
wire [4:0] KmiTrTIMOUT;
// Internal Copy of Time Out Value
   
wire [4:0] NextKmiTrTIMOUT;
// D input to KmiTrTIMOUT
   
wire [3:0] KmiTrMODEREG;
// Internal Copy of MODEREG Value
   
wire [3:0] NextKmiTrMODEREG;
// D input to KmiTrMODEREG

// ----------------------------------------------------------------------------
// Register declaration
// ---------------------------------------------------------------------------- 
reg [4:0] iKmiTrCnREG;
// Internal Copy of Control Register
   
reg [8:0] iKmiTrCLKL;
// Internal Copy of KmiTrCLKL
   
reg [8:0]  iKmiTrCLKH;
// Internal Copy of KmiTrCLKH
   
reg [15:0] iKmiTrDSI;
// Internal Copy of DSI Reg
   
reg [15:0]  iKmiTrDHI;
// Internal Copy of DHI Reg
   
reg [15:0] iKmiTrDSO;
// Internal Copy of DSO Reg
   
reg [15:0] iKmiTrDHO;
// Internal Copy of DHO Reg
   
reg [7:0] iKmiTrREFCLK;
// Internal Copy of REFCLK Value
   
reg [15:0] iKmiTrRG;
// Internal Copy of RG Reg
   
reg [7:0] iKmiTrCLKDIV;
// Internal Copy of Clock Divisor value
   
reg [4:0] iKmiTrTIMOUT;
// Internal Copy of Time Out Value
   
reg [3:0] iKmiTrMODEREG;
// Internal Copy of MODEREG Value
   
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Component Instantiation
// -----------------------------------------------------------------------------
KmiTrTXFIFO  uKmiTrTXFIFO
         (
          .PCLK     (PCLK),
          .BnRES    (BnRES), 
          .Write    (WrenTXREG), 
          .Read     (RdUpdateTx),
          .DataIn   (PWDataIn[7:0]),
          .Ffull    (KmiTrTXFF),
          .Fempty   (KmiTrTXFE), 
          .Fhalfless(KmiTrTXFH),
          .DataOut  (KmiTrTXREG)
         );

KmiTrRXFIFO  uKmiTrRXFIFO  
         (
          .PCLK     (PCLK),
          .BnRES    (BnRES),
          .Write    (DataAvl),
          .Read     (RdUpdateRx),
          .DataIn   (RXDATAIN),
          .Ffull    (KmiTrRXFF),
          .Fempty   (KmiTrRXFE),
          .Fhalfmore(KmiTrRXFH),
          .DataOut  (KmiTrRXREG)
         );

 
assign NextKmiTrCnREG   = WrenCnREG == 1'b1 ? PWDataIn[4:0] : 
                          iKmiTrCnREG;
 
assign NextKmiTrCLKL    = WrenCLKL == 1'b1 ? PWDataIn[8:0] : 
                          iKmiTrCLKL;

assign NextKmiTrCLKH    = WrenCLKH == 1'b1 ? PWDataIn[8:0] : 
                          iKmiTrCLKH;

assign NextKmiTrDSI     = WrenDSI == 1'b1 ?  PWDataIn :
                          iKmiTrDSI;

assign NextKmiTrDHI     = WrenDHI == 1'b1 ? PWDataIn :
                          iKmiTrDHI;

assign NextKmiTrDSO     = WrenDSO == 1'b1 ? PWDataIn :
                          iKmiTrDSO;

assign NextKmiTrDHO     = WrenDHO == 1'b1 ? PWDataIn :
                          iKmiTrDHO;

assign NextKmiTrREFCLK  = WrenREFCLK == 1'b1 ? PWDataIn[7:0] : 
                          iKmiTrREFCLK;

assign NextKmiTrRG      = WrenRG == 1'b1 ? PWDataIn : 
                          iKmiTrRG;

assign NextKmiTrCLKDIV  = WrenCLKDIV == 1'b1 ? PWDataIn[7:0] : 
                          iKmiTrCLKDIV;

assign NextKmiTrTIMOUT  = WrenTIMOUT == 1'b1 ? PWDataIn[4:0] : 
                          iKmiTrTIMOUT;

assign NextKmiTrMODEREG = WrenMODEREG == 1'b1 ? PWDataIn[3:0] : 
                          iKmiTrMODEREG;

// ----------------------------------------------------------------------------
// This process updates various registers at the positive edge of PCLK.
// ----------------------------------------------------------------------------
always @ (posedge PCLK or BnRES)
begin : p_RegistersSeq 
  if (BnRES == 1'b0) 
  begin
    iKmiTrCnREG    <= 5'b00000;  
    iKmiTrCLKL     <= 9'b000000000; 
    iKmiTrCLKH     <= 9'b000000000; 
    iKmiTrDSI      <= 16'b0000000000000000; 
    iKmiTrDHI      <= 16'b0000000000000000; 
    iKmiTrDSO      <= 16'b0000000000000000;
    iKmiTrDHO      <= 16'b0000000000000000; 
    iKmiTrREFCLK   <= 8'b00000000; 
    iKmiTrRG       <= 16'b0000000000000000; 
    iKmiTrCLKDIV   <= 8'b00000000; 
    iKmiTrTIMOUT   <= 5'b00000;
    iKmiTrMODEREG  <= 4'b0001;
  end
  else
  begin
    iKmiTrCnREG    <= NextKmiTrCnREG;
    iKmiTrCLKL     <= NextKmiTrCLKL;
    iKmiTrCLKH     <= NextKmiTrCLKH;
    iKmiTrDSI      <= NextKmiTrDSI;
    iKmiTrDHI      <= NextKmiTrDHI;
    iKmiTrDSO      <= NextKmiTrDSO;
    iKmiTrDHO      <= NextKmiTrDHO;
    iKmiTrREFCLK   <= NextKmiTrREFCLK;
    iKmiTrRG       <= NextKmiTrRG;
    iKmiTrCLKDIV   <= NextKmiTrCLKDIV;
    iKmiTrTIMOUT   <= NextKmiTrTIMOUT;
    iKmiTrMODEREG  <= NextKmiTrMODEREG;
  end
end  // p_RegistersSeq;

assign KmiTrCnREG    = iKmiTrCnREG;
assign KmiTrCLKL     = iKmiTrCLKL;
assign KmiTrCLKH     = iKmiTrCLKH;
assign KmiTrDSI      = iKmiTrDSI;
assign KmiTrDHI      = iKmiTrDHI;
assign KmiTrDSO      = iKmiTrDSO;
assign KmiTrDHO      = iKmiTrDHO;
assign KmiTrREFCLK   = iKmiTrREFCLK;
assign KmiTrRG       = iKmiTrRG;
assign KmiTrCLKDIV   = iKmiTrCLKDIV;
assign KmiTrTIMOUT   = iKmiTrTIMOUT;
assign KmiTrMODEREG  = iKmiTrMODEREG;

endmodule

//========================== End of KmiTrRegFile ==============================
