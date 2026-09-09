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
//  File Name              : SciTrSynctoRFCLK.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Purpose     : This block synchronises signals crossing over from
//               the PCLK domain into the SCIREFCLK domain.
//------------------------------------------------------------------------------
  
`timescale 1ns/1ps
//------------------------------------------------------------------------------

module SciTrSynctoRFCLK (
                         SCICLK,     
                         PRESETn,           
                         TxDataAvlbl,    
                         TrCRUpdate,     
                         TrTXPCUpdate,  
                         TrRXPCUpdate, 
                         TrCTRLUpdate,
                         TrATUpdate,    
                         TrDTUpdate,   
                         TrTXBGUpdate,
                         TrTXCGUpdate, 
                         TrCKICUpdate,  
                         TrBAUDUpdate, 
                         TrVALUpdate, 
                         TrRXCGUpdate, 
                         TrRXBGUpdate,
                         TrJitUpdate,    
                         TrJitPUpdate,  
                         TxDataAvlblSync, 
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
                         TrJitPatUpdSync 
                        );


input  SCICLK;           // SCI Reference clock
input  PRESETn;          // Reset input
input  TxDataAvlbl;      // TX FIFO dada evell
input  TrCRUpdate;       // Control Reg update trigger
input  TrTXPCUpdate;     // TX retray update trigger
input  TrRXPCUpdate;     // RX retray update trigger
input  TrCTRLUpdate;     // Error En  update trigger
input  TrATUpdate;       // ATIME update trigger
input  TrDTUpdate;       // DTIME update trigger
input  TrTXBGUpdate;     // TX BLKG update trigger
input  TrTXCGUpdate;     // TX CHTG update trigger
input  TrCKICUpdate;     // CLKICC update trigger
input  TrBAUDUpdate;     // BAUD update trigger
input  TrVALUpdate;      // VALUE update trigger
input  TrRXCGUpdate;     // RX CHGUR update trigger
input  TrRXBGUpdate;     // RX BLKGU update trigger
input  TrJitUpdate;      // Jit value update trigger
input  TrJitPUpdate;     // Jit Cnt update trigger
output TxDataAvlblSync;  // Sync for Tx data Avilable
output TrCRUpdSync;      // Sync for control Reg Update
output TrTXPCUpdSync ;   // Sync for TX Retray Update
output TrRXPCUpdSync;    // Sync for RX Retray Update
output TrCTRLUpdSync;    // Sync for Error En Update
output TrATUpdSync;      // Sync for ATIMEUpdate
output TrDTUpdSync;      // Sync for DTIMEUpdate
output TrTXBLKGUpdSync;  // Sync for TX BLKG Updat
output TrTXCHGUpdSync;   // Sync for TX CHG Update
output TrCKICCUpdSync;   // Sync for CLKICCUpdat
output TrBAUDUpdSync;    // Sync for BAUDUpdate
output TrVALUEUpdSync;   // Sync for VALUEUpdate
output TrRXCHGUpdSync;   // Sync for RX CHG Update
output TrRXBLKGUpdSync;  // Sync for RX BLKG Update
output TrJitUpdSync;     // Sync for Jit value Update
output TrJitPatUpdSync;  // Sync for Jit Cnt Update

//------------------------------------------------------------------------------
//
//                   SciTrSynctoRFCLK
//                   =================
//
//------------------------------------------------------------------------------
// Overview
// ========
//
// This module synchronises signals crossing over from the PCLK
// domain into the SCICLK domain.
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
reg TxDataAvlblSync;  
// Sync for Tx data Avilable

reg TrCRUpdSync;      
// Sync for control Reg Update

reg TrTXPCUpdSync ;   
// Sync for TX Retray Update

reg TrRXPCUpdSync;    
// Sync for RX Retray Update

reg TrCTRLUpdSync;    
// Sync for Error En Update

reg TrATUpdSync;      
// Sync for ATIMEUpdate

reg TrDTUpdSync;      
// Sync for DTIMEUpdate

reg TrTXBLKGUpdSync;  
// Sync for TX BLKG Updat

reg TrTXCHGUpdSync;   
// Sync for TX CHG Update

reg TrCKICCUpdSync;   
// Sync for CLKICCUpdat

reg TrBAUDUpdSync;    
// Sync for BAUDUpdate

reg TrVALUEUpdSync;   
// Sync for VALUEUpdate

reg TrRXCHGUpdSync;   
// Sync for RX CHG Update

reg TrRXBLKGUpdSync;  
// Sync for RX BLKG Update

reg TrJitUpdSync;     
// Sync for Jit value Update

reg TrJitPatUpdSync;  
// Sync for Jit Cnt Update

reg TxDataAvlblSync1;
// 1st stage synchronised version of TxDataAvilabl

reg TrCRUpdSync1;
// 1st stage synchronised version of Control Update

reg TrTXPCUpdSync1;	
// 1st stage synchronised version of TrTXPCUpdate

reg TrRXPCUpdSync1;	
// 1st stage synchronised version of TrRXPCUpdate

reg TrCTRLUpdSync1;	
// 1st stage synchronised version of TrCTRLUpdate

reg TrATUpdSync1;	
// 1st stage synchronised version of TrATUpdate

reg TrDTUpdSync1;	
// 1st stage synchronised version of TrDTUpdate

reg TrTXBLKGUpdSync1;	
// 1st stage synchronised version of TrTXBGUpdate

reg TrTXCHGUpdSync1;	
// 1st stage synchronised version of TrTXCGUpdate

reg TrCKICCUpdSync1;	
// 1st stage synchronised version of TrCKICUpdate

reg TrBAUDUpdSync1;	
// 1st stage synchronised version of TrBAUDUpdate

reg TrVALUEUpdSync1;	
// 1st stage synchronised version of TrVALUpdate

reg TrRXCHGUpdSync1;	
// 1st stage synchronised version of TrRXCGUpdate

reg TrRXBLKGUpdSync1;	
// 1st stage synchronised version of TrRXBGUpdate

reg TrJitUpdSync1;	
// 1st stage synchronised version of TrJitUpdate

reg TrJitPatUpdSync1;	
// 1st stage synchronised version of TrJitPUpdate

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
// Synchronisers for FIFO-related signals
//------------------------------------------------------------------------------
always @(posedge SCICLK or  PRESETn)
begin : p_FIFOSeq
  if (PRESETn == 1'b0)
  begin  
    TxDataAvlblSync1 <= 1'b0;
    TxDataAvlblSync <= 1'b0;
  end
  else
  begin
    TxDataAvlblSync1 <= TxDataAvlbl;
    TxDataAvlblSync  <= TxDataAvlblSync1;
  end
end // p_FIFOSeq;

//------------------------------------------------------------------------------
// Synchronisers for the all Update signals.
//------------------------------------------------------------------------------
always @(posedge SCICLK or  PRESETn)
begin : p_UpdateSeq
  if (PRESETn <= 1'b0)
  begin  
    TrCRUpdSync1      <= 1'b0;	
    TrCRUpdSync       <= 1'b0;	
    TrTXPCUpdSync1    <= 1'b0;	
    TrTXPCUpdSync     <= 1'b0;	
    TrRXPCUpdSync1    <= 1'b0;	
    TrRXPCUpdSync     <= 1'b0;	
    TrCTRLUpdSync1    <= 1'b0;	
    TrCTRLUpdSync     <= 1'b0;	
    TrATUpdSync1      <= 1'b0;	
    TrATUpdSync       <= 1'b0;	
    TrDTUpdSync1      <= 1'b0;	
    TrDTUpdSync       <= 1'b0;	
    TrTXBLKGUpdSync1  <= 1'b0;	
    TrTXBLKGUpdSync   <= 1'b0;	
    TrTXCHGUpdSync1   <= 1'b0;	
    TrTXCHGUpdSync    <= 1'b0;	
    TrCKICCUpdSync1   <= 1'b0;	
    TrCKICCUpdSync    <= 1'b0;	
    TrBAUDUpdSync1    <= 1'b0;	
    TrBAUDUpdSync     <= 1'b0;	
    TrVALUEUpdSync1   <= 1'b0;	
    TrVALUEUpdSync    <= 1'b0;	
    TrRXCHGUpdSync1   <= 1'b0;	
    TrRXCHGUpdSync    <= 1'b0;	
    TrRXBLKGUpdSync1  <= 1'b0;	
    TrRXBLKGUpdSync   <= 1'b0;	
    TrJitUpdSync      <= 1'b0;
    TrJitUpdSync1     <= 1'b0;
    TrJitPatUpdSync   <= 1'b0;
    TrJitPatUpdSync1  <= 1'b0;
  end
  else
  begin
    TrCRUpdSync1      <= TrCRUpdate; 
    TrCRUpdSync       <= TrCRUpdSync1; 
    TrTXPCUpdSync1    <= TrTXPCUpdate;
    TrTXPCUpdSync     <= TrTXPCUpdSync1;
    TrRXPCUpdSync1    <= TrRXPCUpdate;
    TrRXPCUpdSync     <= TrRXPCUpdSync1;
    TrCTRLUpdSync1    <= TrCTRLUpdate;
    TrCTRLUpdSync     <= TrCTRLUpdSync1;
    TrATUpdSync1      <= TrATUpdate;
    TrATUpdSync       <= TrATUpdSync1;
    TrDTUpdSync1      <= TrDTUpdate;
    TrDTUpdSync       <= TrDTUpdSync1;
    TrTXBLKGUpdSync1  <= TrTXBGUpdate;
    TrTXBLKGUpdSync   <= TrTXBLKGUpdSync1;
    TrTXCHGUpdSync1   <= TrTXCGUpdate;
    TrTXCHGUpdSync    <= TrTXCHGUpdSync1;
    TrCKICCUpdSync1   <= TrCKICUpdate;
    TrCKICCUpdSync    <= TrCKICCUpdSync1; 
    TrBAUDUpdSync1    <= TrBAUDUpdate; 
    TrBAUDUpdSync     <= TrBAUDUpdSync1; 
    TrVALUEUpdSync1   <= TrVALUpdate;
    TrVALUEUpdSync    <= TrVALUEUpdSync1;
    TrRXCHGUpdSync1   <= TrRXCGUpdate;
    TrRXCHGUpdSync    <= TrRXCHGUpdSync1;
    TrRXBLKGUpdSync1  <= TrRXBGUpdate;
    TrRXBLKGUpdSync   <= TrRXBLKGUpdSync1;
    TrJitUpdSync1     <= TrJitUpdate;
    TrJitUpdSync      <= TrJitUpdSync1;
    TrJitPatUpdSync1  <= TrJitPUpdate;
    TrJitPatUpdSync   <= TrJitPatUpdSync1;
  end
end // p_UpdateSeq;

endmodule 

//=============================== End =======================================--













