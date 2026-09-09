// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SciTrRegBlkUpd.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Purpose     : This block contains second stage buffer of registers
//               whose contents need to be updated in SCICLK-domain
//              
//------------------------------------------------------------------------------

`timescale 1ns/1ps  

//------------------------------------------------------------------------------

module SciTrRegBlkUpd (
                       SCICLK,        
                       PRESETn,            
                       TrCRUpdSync,      
                       TrTXPCUpdSync,    
                       TrRXPCUpdSync,    
                       TrCTRLUpdSync,    
                       TrATUpdSync,      
                       TrDTUpdSync,      
                       TrTXBLKGUpdSync,  
                       TrTXCHGUpdSync,   
                       TrCKICCUpdSync,   
                       TrBAUDUpdSync,    
                       TrVALUEUpdSync,   
                       TrRXCHGUpdSync,   
                       TrRXBLKGUpdSync,  
                       TrJitUpdSync,     
                       TrJitPatUpdSync,  
                       SCITrCR,          
                       SCITrTXPC,        
                       SCITrRXPC,        
                       SCITrCTRL,       
                       SCITrAT,          
                       SCITrDT,          
                       SCITrTXBLKG,      
                       SCITrTXCHG,       
                       SCITrCKICC,       
                       SCITrBAUD,        
                       SCITrVALUE,      
                       SCITrRXCHG,       
                       SCITrRXBLKG,      
                       SCITrJit,        
                       SCITrJitPat,      
                       SCICLKErEn,       
                       TXPtimErEn,      
                       TXPErEn,          
                       TXPtimWdErEn,    
                       RXPErEn,         
                       RXCtimErEn,     
                       RXBtimErEn,    
                       StartBitErEn,    
                       TrBoxEn,        
                       TrTXEn,        
                       TrRXEn,       
                       TrDebugEn,   
                       TrCDETEn,       
                       TrTXPEn,       
                       TrRXPEn,      
                       TrTXPStEn,   
                       TrRXPStEn,  
                       TrTXNAKEn,      
                       TrRXNAKEn,     
                       SCIDEACREQ,   
                       TrDackREn,   
                       SCANMODE,   
                       nSCIRST,   
                       TrSENSE,  
                       TrSCICLKEn, 
                       TrRSyTXPC,       
                       TrRSyRXPC,      
                       TrRSyAT,       
                       TrRSyDT,      
                       TrTXRSyBLKG, 
                       TrTXRSyCHG, 
                       TrRSyCKICC,      
                       TrRSyBAUD,      
                       TrRSyVALUE,    
                       TrRXRSyCHG,   
                       TrRXRSyBLKG, 
                 //      TrRSyRFCK,  
                       TrRSyJit,       
                       TrRSyJitPat   
                      );

input          SCICLK;           // SCI Reference Clock
input          PRESETn;          // Reset input
input          TrCRUpdSync;      // Sync for TrCRUpdate
input          TrTXPCUpdSync;    // Sync for TrTXPCUpdate
input          TrRXPCUpdSync;    // Sync for TrRXPCUpdate
input          TrCTRLUpdSync;    // Sync for TrCTRLUpdate
input          TrATUpdSync;      // Sync for ATUpdate
input          TrDTUpdSync;      // Sync for DTUpdate
input          TrTXBLKGUpdSync;  // Sync for TXBLKGUpdat
input          TrTXCHGUpdSync;   // Sync for TXCHTGUpdate
input          TrCKICCUpdSync;   // Sync for CLKICCUpdat
input          TrBAUDUpdSync;    // Sync for BAUDUpdate
input          TrVALUEUpdSync;   // Sync for VALUEUpdate
input          TrRXCHGUpdSync;   // Sync for RXCHGUpdate
input          TrRXBLKGUpdSync;  // Sync for RXBLKGUpdate
input          TrJitUpdSync;     // Sync for JitUpdate
input          TrJitPatUpdSync;  // Sync for JitPatUpdate
input  [15:0]  SCITrCR;          // I stg CR
input  [3:0]   SCITrTXPC;        // I stg TXRET
input  [3:0]   SCITrRXPC;        // I stg RXRET
input  [7:0]   SCITrCTRL;        // I stg ErEn
input  [15:0]  SCITrAT;          // I stg ATIME
input  [15:0]  SCITrDT;          // I stg DTIME
input  [7:0]   SCITrTXBLKG;      // I stg TXBLKG
input  [7:0]   SCITrTXCHG;       // I stg TXCHG
input  [15:0]  SCITrCKICC;       // I stg CLKIC
input  [15:0]  SCITrBAUD;        // I stg BAUD
input  [7:0]  SCITrVALUE;       // I stg VALUE
input  [7:0]   SCITrRXCHG;       // I stg RXCHG
input  [7:0]   SCITrRXBLKG;      // I stg RXBLKG
     //   SCITrRFCK              // I stg REFCLK
     //   SCITrWV                // I stg WV
input  [15:0]  SCITrJit;         // I stg Jit
input  [9:0]   SCITrJitPat;      // I stg JitCnt
output         SCICLKErEn;       // SCICLK Er massege En
output         TXPtimErEn;       // TXPtim Er massege En
output         TXPErEn;          // TXPEr  Er massege En
output         TXPtimWdErEn;     // TXPtimWd Er massege En
output         RXPErEn;          // RXPEr massege En
output         RXCtimErEn;       // RXCtimEr massege En
output         RXBtimErEn;       // RXBtimEr massege En
output         StartBitErEn;     // StartBitEr massege En
output         TrBoxEn;          // Trickbox enable
output         TrTXEn;           // Transmit enable
output         TrRXEn;           // Receive enable
output         TrDebugEn;        // Debug message on
output         TrCDETEn;         // Card DETECT En
output         TrTXPEn;          // TXP force Error enable
output         TrRXPEn;          // RXP force Error enable
output         TrTXPStEn;        // TX parity state
output         TrRXPStEn;        // RX parity state
output         TrTXNAKEn;        // TX hand shaking on
output         TrRXNAKEn;        // RX hand shaking on
output         SCIDEACREQ;       // SCI deactivation Req
output         TrDackREn;        // SCI deactivation read
output         SCANMODE;         // scanmode enable
output         nSCIRST;          // reset
output         TrSENSE;          // Data line SENSE
output         TrSCICLKEn;       // SCICLKOUT from trickbox enable
output  [3:0]  TrRSyTXPC;        // II stg TXTRY
output  [3:0]  TrRSyRXPC;        // II stg RXTRY
output  [15:0] TrRSyAT;          // II stg ATIME
output  [15:0] TrRSyDT;          // II stg DTIME
output  [7:0]  TrTXRSyBLKG;      // II stg TXBG
output  [7:0]  TrTXRSyCHG;       // II stg TXCHG
output  [15:0] TrRSyCKICC;       // II stg CLKICC
output  [15:0] TrRSyBAUD;        // II stg BAUD
output  [7:0]  TrRSyVALUE;       // II stg VALUE
output  [7:0]  TrRXRSyCHG;       // II stg RXCHG
output  [7:0]  TrRXRSyBLKG;      // II stg RXBG
//output  [15:0]  TrRSyRFCK;        // II stg REFCK
output  [15:0] TrRSyJit;         // II stg JitP
output  [9:0]  TrRSyJitPat;      // II stg JitCt
//------------------------------------------------------------------------------
//
//                   SciTrRegBlkUpd
//                   ===============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
// This module contains the second stage buffers for the 
// registers. 
// Data on the corresponding first stage inputs are clocked into the 
// second stage buffers when their corresponding WrEn signals are 
// asserted. The WrEn signals are generated by XORing the UpdateSync 
// input with the internal delayed version of that signal. 
//
//
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

reg [15:0] TrRSyCR;
// 2nd stage buffer for SCITrCR

wire [15:0] NextTrRSyCR;
// D-input for SCITrCR

reg [3:0] TrRSyTXPC;
// 2nd stage buffer for SCITrTXPC

wire [3:0] NextTrRSyTXPC;
// D-input for SCITrTXPC

reg [3:0] TrRSyRXPC;
// 2nd stage buffer for SCITrRXPC

wire [3:0] NextTrRSyRXPC;
// D-input for SCITrRXPC

reg [7:0] TrRSyCTRL;
// 2nd stage buffer for TrCTRL

wire [7:0] NextTrRSyCTRL;
// D-input for TrCTRL

reg [15:0] TrRSyAT;
// 2nd stage buffer for SCIATIME

wire [15:0] NextTrRSyAT;
// D-input for SCITrAT

reg [15:0] TrRSyDT;
// 2nd stage buffer for SCITrDT

wire [15:0]  NextTrRSyDT;
// D-input for SCITrDT

reg [7:0] TrTXRSyBLKG;
// 2nd stage buffer for SCITrTXBLKG

wire [7:0] NextTrTXRSyBLKG;
// D-input for SCITrTXBLKG

reg [7:0] TrTXRSyCHG;
// 2nd stage buffer for SCITrTXCHG

wire [7:0] NextTrTXRSyCHG;
// D-input for SCITrTXCHG

reg [15:0] TrRSyCKICC;
// 2nd stage buffer for SCITrCKICC

wire [15:0] NextTrRSyCKICC;
// D-input for SCITrCKICC

reg [15:0] TrRSyBAUD;
// 2nd stage buffer for SCITrBAUD

wire [15:0] NextTrRSyBAUD;
// D-input for SCITrBAUD

reg [7:0] TrRSyVALUE;
// 2nd stage buffer for SCITrRSyVALUE

wire [7:0] NextTrRSyVALUE;
// D-input for VALUE

reg [7:0] TrRXRSyCHG;
// 2nd stage buffer for SCITrRXCHG

wire [7:0] NextTrRXRSyCHG;
// D-input for SCITrRXCHG

reg [7:0] TrRXRSyBLKG;
// 2nd stage buffer for SCITrRXBLKG

wire [7:0] NextTrRXRSyBLKG;
// D-input for SCITrRXBLKG

reg [15:0] TrRSyJit;
// 2nd stage buffer for SCITrJit

wire [15:0] NextTrRSyJit;
// D-input for SCITrJit

reg [9:0] TrRSyJitPat;
// 2nd stage buffer for SCITrJitPat

wire [9:0] NextTrRSyJitPat;
// D-input for SCITrJitPat

//------------------------------------------------------------------------------
// Delayed version of UpdateSyncs 
//------------------------------------------------------------------------------

reg DTrCRUpdtSyn;
// Delayed version of TrCRUpdSync

reg DTrTXPCUpdtSyn;	
// Delayed version of TrTXPCUpdSync	

reg DTrRXPCUpdtSyn;	
// Delayed version of TrRXPCUpdSync	

reg DTrCTRLUpdtSyn;	
// Delayed version of TrCTRLUpdSync	

reg DTrATUpdtSyn;	
// Delayed version of TrATUpdSync	

reg DTrDTUpdtSyn;	
// Delayed version of TrDTUpdSync	

reg DTrTXBLKGUpdtSyn;	
// Delayed version of TrTXBLKGUpdSync	

reg DTrTXCHGUpdtSyn;	
// Delayed version of TrTXCHGUpdSync	

reg DTrCKICCUpdtSyn;	
// Delayed version of TrCKICCUpdSync	

reg DTrBAUDUpdtSyn;	
// Delayed version of TrBAUDUpdSync	

reg DTrVALUEUpdtSyn;	
// Delayed version of TrVALUEUpdSync	

reg DTrRXCHGUpdtSyn;	
// Delayed version of TrRXCHGUpdSync	

reg DTrRXBLKGUpdtSyn;	
// Delayed version of TrRXBLKGUpdSync

reg DTrJitUpdtSyn;	
// Delayed version of TrJitUpdSync

reg DTrJitPatUpdtSyn;	
// Delayed version of TrJitPatUpdSync

//------------------------------------------------------------------------------
// Load signals for second stage buffers 
//------------------------------------------------------------------------------
wire TrRSyCRWrEn;
// Load signal for 2nd stage SCITrCR buffer 

wire TrRSyTXPCWrEn;	
// Load signal for 2nd stage SCITrTXPC buffer

wire TrRSyRXPCWrEn;	
// Load signal for 2nd stage SCITrRXPC buffer

wire TrRSyCTRLWrEn;	
// Load signal for 2nd stage SCITrCTRL buffer

wire TrRSyATWrEn;
// Load signal for 2nd stage SCITrAT buffer

wire TrRSyDTWrEn;
// Load signal for 2nd stage SCITrDT buffer

wire TrTXRSyBLKGWrEn;
// Load signal for 2nd stage buffer SCITrTXBLKG buffer

wire TrTXRSyCHGWrEn;
// Load signal for 2nd stage SCITrTXCHG buffer

wire TrRSyCKICCWrEn;	
// Load signal for 2nd stage SCITrCKICC buffer

wire TrRSyBAUDWrEn;
// Load signal for 2nd stage SCITrBAUD buffer

wire TrRSyVALUEWrEn;	
// Load signal for 2nd stage SCITrVALUE buffer

wire TrRXRSyCHGWrEn;
// Load signal for 2nd stage SCITrRXCHG buffer

wire TrRXRSyBLKGWrEn;	
// Load signal for 2nd stage SCITrRXBLKG buffer

wire TrRSyJitWrEn;	
// Load signal for 2nd stage SCITrJit buffer

wire TrRSyJitPatWrEn;	
// Load signal for 2nd stage SCITrJitPat buffer

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
// Generation of delayed versions of the Update trigger inputs.
//------------------------------------------------------------------------------
always @(posedge SCICLK or negedge PRESETn)
begin : p_DelUpdateSeq
  if (PRESETn == 1'b0)
  begin
    DTrCRUpdtSyn     <= 1'b0;
    DTrTXPCUpdtSyn   <= 1'b0;
    DTrRXPCUpdtSyn   <= 1'b0;
    DTrCTRLUpdtSyn   <= 1'b0;
    DTrATUpdtSyn     <= 1'b0;	
    DTrDTUpdtSyn     <= 1'b0;	
    DTrTXBLKGUpdtSyn <= 1'b0;	
    DTrTXCHGUpdtSyn  <= 1'b0;	
    DTrCKICCUpdtSyn  <= 1'b0;	
    DTrBAUDUpdtSyn   <= 1'b0;	
    DTrVALUEUpdtSyn  <= 1'b0;	
    DTrRXCHGUpdtSyn  <= 1'b0;	
    DTrRXBLKGUpdtSyn <= 1'b0;	
  end
  else
  begin
    DTrCRUpdtSyn     <= TrCRUpdSync;
    DTrTXPCUpdtSyn   <= TrTXPCUpdSync;	
    DTrRXPCUpdtSyn   <= TrRXPCUpdSync;	
    DTrCTRLUpdtSyn   <= TrCTRLUpdSync;	
    DTrATUpdtSyn     <= TrATUpdSync;
    DTrDTUpdtSyn     <= TrDTUpdSync;	
    DTrTXBLKGUpdtSyn <= TrTXBLKGUpdSync;	
    DTrTXCHGUpdtSyn  <= TrTXCHGUpdSync;	
    DTrCKICCUpdtSyn  <= TrCKICCUpdSync;	
    DTrBAUDUpdtSyn   <= TrBAUDUpdSync;	
    DTrVALUEUpdtSyn  <= TrVALUEUpdSync;	
    DTrRXCHGUpdtSyn  <= TrRXCHGUpdSync;	
    DTrRXBLKGUpdtSyn <= TrRXBLKGUpdSync;	
    DTrJitUpdtSyn    <= TrJitUpdSync;	
    DTrJitPatUpdtSyn <= TrJitPatUpdSync;	
  end
end // p_DelUpdateSeq;

//------------------------------------------------------------------------------
// Generation of load signals for the second stage buffers.
//------------------------------------------------------------------------------
assign TrRSyCRWrEn       = DTrCRUpdtSyn     ^ TrCRUpdSync;

assign TrRSyTXPCWrEn     = DTrTXPCUpdtSyn   ^ TrTXPCUpdSync;	

assign TrRSyRXPCWrEn     = DTrRXPCUpdtSyn   ^ TrRXPCUpdSync;	

assign TrRSyCTRLWrEn     = DTrCTRLUpdtSyn   ^ TrCTRLUpdSync;	

assign TrRSyATWrEn       = DTrATUpdtSyn     ^ TrATUpdSync;

assign TrRSyDTWrEn       = DTrDTUpdtSyn     ^ TrDTUpdSync;	

assign TrTXRSyBLKGWrEn   = DTrTXBLKGUpdtSyn ^ TrTXBLKGUpdSync;	

assign TrTXRSyCHGWrEn    = DTrTXCHGUpdtSyn  ^ TrTXCHGUpdSync;	

assign TrRSyCKICCWrEn    = DTrCKICCUpdtSyn  ^ TrCKICCUpdSync;	

assign TrRSyBAUDWrEn     = DTrBAUDUpdtSyn   ^ TrBAUDUpdSync;	

assign TrRSyVALUEWrEn    = DTrVALUEUpdtSyn  ^ TrVALUEUpdSync;	

assign TrRXRSyCHGWrEn    = DTrRXCHGUpdtSyn  ^ TrRXCHGUpdSync;	

assign TrRXRSyBLKGWrEn   = DTrRXBLKGUpdtSyn ^ TrRXBLKGUpdSync;	

assign TrRSyJitWrEn      = DTrJitUpdtSyn    ^ TrJitUpdSync;

assign TrRSyJitPatWrEn   = DTrJitPatUpdtSyn ^ TrJitPatUpdSync;

//------------------------------------------------------------------------------
// Write into the second stage buffers.
//------------------------------------------------------------------------------
  
assign NextTrRSyCR       = (TrRSyCRWrEn == 1'b1) ? SCITrCR : TrRSyCR; 

assign NextTrRSyTXPC     =  (TrRSyTXPCWrEn == 1'b1) ? SCITrTXPC  : TrRSyTXPC; 

assign NextTrRSyRXPC     = (TrRSyRXPCWrEn == 1'b1) ? SCITrRXPC : TrRSyRXPC; 

assign NextTrRSyCTRL     = (TrRSyCTRLWrEn == 1'b1) ? SCITrCTRL : TrRSyCTRL; 

assign NextTrRSyAT       = (TrRSyATWrEn == 1'b1) ? SCITrAT     : TrRSyAT; 

assign NextTrRSyDT       = (TrRSyDTWrEn == 1'b1) ? SCITrDT    : TrRSyDT; 

assign NextTrTXRSyBLKG   = (TrTXRSyBLKGWrEn ==1'b1)? SCITrTXBLKG : TrTXRSyBLKG; 

assign NextTrTXRSyCHG    = (TrTXRSyCHGWrEn == 1'b1) ? SCITrTXCHG : TrTXRSyCHG; 

assign NextTrRSyCKICC    = (TrRSyCKICCWrEn == 1'b1) ? SCITrCKICC : TrRSyCKICC; 

assign NextTrRSyBAUD     = (TrRSyBAUDWrEn == 1'b1) ? SCITrBAUD : TrRSyBAUD; 

assign NextTrRSyVALUE    =  (TrRSyVALUEWrEn == 1'b1) ? SCITrVALUE : TrRSyVALUE; 

assign NextTrRXRSyCHG    = (TrRXRSyCHGWrEn == 1'b1) ? SCITrRXCHG : TrRXRSyCHG; 

assign NextTrRXRSyBLKG   = (TrRXRSyBLKGWrEn == 1'b1)? SCITrRXBLKG : TrRXRSyBLKG; 

assign NextTrRSyJit      = (TrRSyJitWrEn == 1'b1) ? SCITrJit : TrRSyJit; 

assign NextTrRSyJitPat   = (TrRSyJitPatWrEn == 1'b1)? SCITrJitPat : TrRSyJitPat; 

//------------------------------------------------------------------------------
// Sequential process for write
//------------------------------------------------------------------------------
always @(posedge SCICLK or negedge PRESETn)
begin : p_RegWrSeq
  if (PRESETn == 1'b0)
  begin
    TrRSyCR     <= 16'b0000000000000000; 
    TrRSyTXPC   <= 4'b0000; 
    TrRSyRXPC   <= 4'b0000; 
    TrRSyCTRL   <= 8'b00000000; 
    TrRSyAT     <= 16'b0000000000000000; 
    TrRSyDT     <= 16'b0000000000000000; 
    TrTXRSyBLKG <= 8'b00000000; 
    TrTXRSyCHG  <= 8'b00000000; 
    TrRSyCKICC  <= 16'b0000000000000000; 
    TrRSyBAUD   <= 16'b0000000000000000; 
    TrRSyVALUE  <= 8'b00000000; 
    TrRXRSyCHG  <= 8'b00000000; 
    TrRXRSyBLKG <= 8'b00000000; 
    TrRSyJit    <= 16'b0000000000000000; 
    TrRSyJitPat <= 10'b0000000000; 
  end
  else
  begin 
    TrRSyCR     <=  NextTrRSyCR;
    TrRSyTXPC   <=  NextTrRSyTXPC;
    TrRSyRXPC   <=  NextTrRSyRXPC;
    TrRSyCTRL   <=  NextTrRSyCTRL;
    TrRSyAT     <=  NextTrRSyAT;
    TrRSyDT     <=  NextTrRSyDT;
    TrTXRSyBLKG <=  NextTrTXRSyBLKG;
    TrTXRSyCHG  <=  NextTrTXRSyCHG;
    TrRSyCKICC  <=  NextTrRSyCKICC;
    TrRSyBAUD   <=  NextTrRSyBAUD;
    TrRSyVALUE  <=  NextTrRSyVALUE;
    TrRXRSyCHG  <=  NextTrRXRSyCHG;
    TrRXRSyBLKG <=  NextTrRXRSyBLKG;
    TrRSyJit    <=  NextTrRSyJit;
    TrRSyJitPat <=  NextTrRSyJitPat;
  end  
end // p_RegWrSeq; 

//------------------------------------------------------------------------------
// Generation of Control signals for Trick Box and Error message Enable 
//------------------------------------------------------------------------------
assign TrBoxEn      = TrRSyCR[0];
assign TrTXEn       = TrRSyCR[1];
assign TrRXEn       = TrRSyCR[2];
assign TrDebugEn    = TrRSyCR[3];
assign TrCDETEn     = TrRSyCR[4];
assign TrTXPEn      = TrRSyCR[5];
assign TrRXPEn      = TrRSyCR[6];
assign TrTXPStEn    = TrRSyCR[7];
assign TrRXPStEn    = TrRSyCR[8];
assign TrTXNAKEn    = TrRSyCR[9];
assign TrRXNAKEn    = TrRSyCR[10];
assign SCIDEACREQ   = TrRSyCR[11];
assign SCANMODE     = TrRSyCR[12];
assign nSCIRST      = TrRSyCR[13];
assign TrSENSE      = TrRSyCR[14];
assign TrSCICLKEn   = TrRSyCR[15];
assign SCICLKErEn   = TrRSyCTRL[0];
assign TXPtimErEn   = TrRSyCTRL[1];
assign TXPErEn      = TrRSyCTRL[2];
assign TXPtimWdErEn = TrRSyCTRL[3];
assign RXPErEn      = TrRSyCTRL[4];
assign RXCtimErEn   = TrRSyCTRL[5];
assign RXBtimErEn   = TrRSyCTRL[6];
assign StartBitErEn = TrRSyCTRL[7];

endmodule
// --======================= End of SciTrRegBlkUpd ===========================--




















