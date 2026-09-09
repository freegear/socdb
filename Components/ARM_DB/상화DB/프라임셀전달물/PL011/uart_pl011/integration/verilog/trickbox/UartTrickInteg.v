// ========================================================================== 
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//---------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrickInteg.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
//  Purpose  : This module is the top level entity of the VHDL  trickbox 
//
// ========================================================================== --

`timescale 1ns/1ps

//- ----------------------------------------------------------------------------
module UartTrickInteg (
                      );

// -----------------------------------------------------------------------------
//
//                                UartTrickInteg
//                                ==============
//
// -----------------------------------------------------------------------------
//
//  Overview
//  ========
//    This block is the top level of the Integration test trickbox. This block
//  instantiates the functional sub-blocks in the trickbox.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

UartTrClk uUartTrClk                  (
                    .PCLK             (PCLK),        
                    .BnRES            (BnRES),
                    .ClkPeriod        (ClkPeriod),  
                    .UartClk          (UartClk),        
                    .PCLKOn           (PCLKOn),
                    .REFCLKOn         (REFCLKOn),
                    .RESETBIT         (RESETBIT),       
                    .RSTMODEREG       (RSTMODEREG),
                    .nUARTRST         (nUARTRST)
                    );

UartTrIntLB uUartTrIntLB              (
                    .UARTTXD  	      (UARTTXD), 
                    .nSIROUT	      (nSIROUT),
                    .nUARTOut2	      (nUARTOut2),
                    .nUARTOut1	      (nUARTOut1),
                    .nUARTRTS	      (nUARTRTS),
                    .nUARTDTR	      (nUARTDTR),
                    .UARTRXD 	      (UARTRXD),
                    .SIRIN   	      (SIRIN),
                    .nUARTCTS	      (nUARTCTS),
                    .nUARTDCD	      (nUARTDCD),
                    .nUARTDSR	      (nUARTDSR),
                    .nUARTRI 	      (nUARTRI)
                    );
    
endmodule

//========================== End of UartTrickInteg  ==========================--
