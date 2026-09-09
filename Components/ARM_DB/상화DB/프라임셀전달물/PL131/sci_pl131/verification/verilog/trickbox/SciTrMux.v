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
//  File Name              : SciTrMux.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Purpose     : This block work as MUX between the receiver and transmitter   
//------------------------------------------------------------------------------
 
`timescale 1ns/1ps
//------------------------------------------------------------------------------

module SciTrMux (
                 SCICLK,     
                 PRESETn,         
                 TrTXEn,        
                 TrRXEn,        
                 SCIDATAIN,     
                 TXSCIDATAIN,   
                 RXSCIDATAIN,   
                 TXSCIDATAOUT,  
                 RXSCIDATAOUT,  
                 SCIDATAOUT    
                );

input  SCICLK;        // SCICLK input
input  PRESETn;       // reset input
input  TrTXEn;        // Transmiter En
input  TrRXEn;        // Receiver En
input  SCIDATAIN;     // Input
output TXSCIDATAIN;   // Transmiter input
output RXSCIDATAIN;   // Receiver input
input  TXSCIDATAOUT;  // Transmiter output
input  RXSCIDATAOUT;  // Receiver output
output SCIDATAOUT;    // Output
//------------------------------------------------------------------------------
//
//                   SciTrMux
//                   ========
//
//------------------------------------------------------------------------------
// Overview
// ========
//
// Depend on the condition of the transmit or  receive enable this modlue
// connect transmit or recive state mechine to the output world 
//
//------------------------------------------------------------------------------
//  -----------------------------------------------------------------------------
//  Signal declarations
//  -----------------------------------------------------------------------------

reg TXSCIDATAIN;   
// Transmiter input

reg RXSCIDATAIN;   
// Receiver input

reg SCIDATAOUT;    
// Output


//------------------------------------------------------------------------------
//  Main body of code 
// ==================
//
//------------------------------------------------------------------------------

 
always @(TrTXEn or TrRXEn or TXSCIDATAOUT or  RXSCIDATAOUT or SCIDATAIN)
begin : p_OutMuxComb
  if (TrTXEn == 1'b1)
  begin 
    SCIDATAOUT   = TXSCIDATAOUT;
    TXSCIDATAIN  = SCIDATAIN;
    RXSCIDATAIN  = 1'b1;
  end
  else 
  begin
    if (TrRXEn == 1'b1)
    begin 
      SCIDATAOUT   = RXSCIDATAOUT;
      TXSCIDATAIN  = 1'b1;
      RXSCIDATAIN  = SCIDATAIN;
    end
    else
    begin
      SCIDATAOUT   = 1'b1;
      TXSCIDATAIN  = 1'b1;
      RXSCIDATAIN  = 1'b1;
    end
  end       
end // p_OutMuxComb;
      
endmodule 

//=============================== End =======================================--













