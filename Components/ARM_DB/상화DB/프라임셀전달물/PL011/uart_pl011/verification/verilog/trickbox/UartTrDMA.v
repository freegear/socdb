// ========================================================================== --
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrDMA.v.rca
//  File Revision          : 1.4
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
// Purpose     : This block generates the UARTDMACLR signals
//  
// ========================================================================== --

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------

module UartTrDMA (
// Inputs
                  PCLK,
                  PRESETn,
                  TXDMACLRStag1,
                  RXDMACLRStag1,
// Outputs
                  UARTTXDMACLR,
                  UARTRXDMACLR,
                  TXDMACLRStag4,
                  RXDMACLRStag4
                 );

// Inputs
input         PCLK;             // APB Clock
input         PRESETn;          // AMBA Reset
input         TXDMACLRStag1;    // 1st stage for UARTTXDMACLR
input         RXDMACLRStag1;    // 1st stage for UARTRXDMACLR

// Outputs
output        UARTTXDMACLR;     // Transmit DMA request clear
output        UARTRXDMACLR;     // Receive DMA request clear
output        TXDMACLRStag4;    // For UARTTXDMACLR
output        RXDMACLRStag4;    // For UARTRXDMACLR

// Inputs
wire          PCLK;             // APB Clock
wire          PRESETn;          // AMBA Reset 
wire          TXDMACLRStag1;    // 1st stage for UARTTXDMACLR
wire          RXDMACLRStag1;    // 1st stage for UARTRXDMACLR

// Outputs
wire          UARTTXDMACLR;     // Transmit DMA request clear
wire          UARTRXDMACLR;     // Receive DMA request clear
reg           TXDMACLRStag4;    // For UARTTXDMACLR
reg           RXDMACLRStag4;    // For UARTRXDMACLR

//------------------------------------------------------------------------------
//
//                               UartTrDMA
//                               =========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
// This module generates the UARTTXDMACLR and UARTRXDMACLR signals.
// These are used to test the Uart DMA interface.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Component declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
reg           TXDMACLRStag2;
// 2nd delayed version of TXDMACLRStag1
  
reg           TXDMACLRStag3;
// 3rddelayed version of TXDMACLRStag1
  
reg           TXDMACLRStag5;
// 4th delayed version of TXDMACLRStag1

reg           RXDMACLRStag2;
// 2nd delayed version of RXDMACLRStag1

reg           RXDMACLRStag3;
// 3rd delayed version of RXDMACLRStag1
  
reg           RXDMACLRStag5;
// 4th delayed version of RXDMACLRStag1


//-------------------------------------------------------------------------------
// 
// Main VHDL code
// ==============
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Sequential process for registers/flip-flops in this block
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
    if (PRESETn == 1'b0)
      begin
        TXDMACLRStag2 <= 1'b0;
        TXDMACLRStag3 <= 1'b0;
        TXDMACLRStag4 <= 1'b0;
        TXDMACLRStag5 <= 1'b0;
        RXDMACLRStag2 <= 1'b0;
        RXDMACLRStag3 <= 1'b0;
        RXDMACLRStag4 <= 1'b0;
        RXDMACLRStag5 <= 1'b0;
      end
    else
      begin
        TXDMACLRStag2 <= TXDMACLRStag1;
        TXDMACLRStag3 <= TXDMACLRStag2;
        TXDMACLRStag4 <= TXDMACLRStag3;
        TXDMACLRStag5 <= TXDMACLRStag4;
        RXDMACLRStag2 <= RXDMACLRStag1;
        RXDMACLRStag3 <= RXDMACLRStag2;
        RXDMACLRStag4 <= RXDMACLRStag3;
        RXDMACLRStag5 <= RXDMACLRStag4;
      end
end // p_Seq

//------------------------------------------------------------------------------
// UARTTXDMACLR is a four PCLK-wide pulse used to clear the
// UARTTXDMA requests.
//------------------------------------------------------------------------------
 
assign UARTTXDMACLR  = ((TXDMACLRStag1 & !(TXDMACLRStag2) &
                   !(TXDMACLRStag3) & !(TXDMACLRStag4) &
                   !(TXDMACLRStag5)) | (TXDMACLRStag1 & (TXDMACLRStag2) &
                   !(TXDMACLRStag3) & !(TXDMACLRStag4) &
                   !(TXDMACLRStag5)) | (TXDMACLRStag1 & (TXDMACLRStag2) &
                   (TXDMACLRStag3) & !(TXDMACLRStag4) &
                   !(TXDMACLRStag5)) | (TXDMACLRStag1 & (TXDMACLRStag2) &
                   (TXDMACLRStag3) & (TXDMACLRStag4) & !(TXDMACLRStag5))); 
//------------------------------------------------------------------------------
// UARTRXDMACLR is a four PCLK-wide pulse used to clear the
// UARTRXDMA requests.
//------------------------------------------------------------------------------

assign UARTRXDMACLR  =  ((RXDMACLRStag1 & !(RXDMACLRStag2) &
                   !(RXDMACLRStag3) & !(RXDMACLRStag4) &
                   !(RXDMACLRStag5)) | (RXDMACLRStag1 & (RXDMACLRStag2) &
                   !(RXDMACLRStag3) & !(RXDMACLRStag4) &
                   !(RXDMACLRStag5)) | (RXDMACLRStag1 & (RXDMACLRStag2) &
                   (RXDMACLRStag3) & !(RXDMACLRStag4) &
                   !(RXDMACLRStag5)) | (RXDMACLRStag1 & (RXDMACLRStag2) &
                   (RXDMACLRStag3) & (RXDMACLRStag4) & !(RXDMACLRStag5))); 
endmodule

//========================== End of UartTrDMA ==============================--
