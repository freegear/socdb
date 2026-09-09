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
//  Filename             : $RCSfile :  $
//
//  File Revision        : $Revision : $
//
//  Release Information  : $State : $
//
//  ----------------------------------------------------------------------------
//  Purpose : 
//          This state machine implements the KMI controller.
//
// -------------------------------------------------------------------------

`timescale 1ns/1ps

// ---------------------------------------------------------------------------

module KmiTrController (
                        REFCLK,
                        BnRES,
                        nKMIRST,
                        BitCount,
                        KmiTrTXFE,
                        KmiTrTIMOUT,
                        KmiTrCnREG,
                        KDATAIn,
                        KCLKIn,
                        KDATAOut,
                        KCLKOut,
                        KCLK,
                        EnableOut,
                        RTS,
                        CurrentState 
                      );

input        REFCLK;        // Reference Clock
input        BnRES;         // APB Reset
input        nKMIRST;       // KMI Reset
input [3:0]  BitCount;      // Bit Counter Value
input        KmiTrTXFE;     // Transmit Fifo Status
input [4:0]  KmiTrTIMOUT;   // TimeOut Value
input [4:0]  KmiTrCnREG;    // Control Register
input        KDATAIn;       // Data Input from PAD
input        KCLKIn;        // Clock Input from PAD
input        KDATAOut;      // Data Output to PAD
input        KCLKOut;       // Clock Output to PAD
input        KCLK;          // Clock input from KCLKGen Module
input        EnableOut;     // Enable Signal from KmiTrOutDrive module
input        RTS;           // Request To Send Indication
output [1:0] CurrentState;  // Current State Output

// -------------------------------------------------------------------------
//
//                                KmiTrController
//                                ===============
//
// -------------------------------------------------------------------------
//
// Overview
// =======
//
// This state machine controls the overall transmit & request operation
// of the KMI. If simultaneous request for transmission & reception occur,
// the reception is given priority. If during transmission, there is a request 
// for reception before the 10th bit, it will abort transmission & will start
// the recieve cycle. If there is a timeout request  the controller aborts
// the transmit or receive in progress. If at any time the TrickBox is disabled
//  the controller goes to the Reset state.
// The controller in the PS2/AT mode interface sends an acknowledge pulse
// at the end of every transmit process. In the LEGACY mode there is no 
// acknowledge pulse.
//
// -------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
wire [3:0] TOutBit;
// TimeOut Bit

// -----------------------------------------------------------------------------
// register declarations
// -----------------------------------------------------------------------------
reg [1:0]  iCurrentState;
// Internal Copy of Current State

reg [1:0] NextState;
// D-Input for iCurrentState

reg Inhibit;
// Inhibit condition Indicator

reg DelayEn;
// Delayed version of EnableOut signal

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

assign TOutBit = KmiTrTIMOUT[3:0]; // Bit Number for timeout

// ---------------------------------------------------------------------------
// Delayed Version of EnableOut
// ---------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_DelayEnSeq
  if (BnRES == 1'b0) 
    DelayEn <= 1'b0;
  else 
    DelayEn <= EnableOut;
end  // p_DelayEnSeq

// ---------------------------------------------------------------------------
// Delayed Version of EnableOut
// ---------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_InhibitSeq  
  if (BnRES == 1'b0) 
    Inhibit <= 1'b0;
  else 
    Inhibit <= KCLKOut & ~(KCLKIn);
end  // p_InhibitSeq

// ---------------------------------------------------------------------------
// Next State Generation
// ---------------------------------------------------------------------------
always @ (iCurrentState or BitCount or KmiTrTXFE or KmiTrTIMOUT or 
          KmiTrCnREG or TOutBit or KDATAIn or KCLKIn or KDATAOut or 
          KCLKOut or RTS) 
begin : p_NextStateComb 
  if (Inhibit & ~(RTS)) 
    NextState = 2'b00;
  else if ((BitCount != 4'b1010) & (RTS == 1'b1)) 
    NextState = 2'b01;
  else
  begin
    case (iCurrentState)
      // If TrickBox is enabled & Request to Send is there, state will go 
      // to receive state. In case of KCLK & KDATA line HIGH & if some data
      // is available in the Transmit FIFO, NextState will be Transmit State.
      // Otherwise it will remain in the Idle State.  
     2'b00 :
     begin
        if (KmiTrCnREG[0] & RTS) 
          NextState = 2'b01;
        else if (KCLKIn & KDATAIn & KmiTrCnREG[0] & ~(KmiTrTXFE)) 
          NextState = 2'b10;
        else
          NextState = 2'b00;
     end
        
      // If Timeout is enabled, State will go to TIMEOUT state. If EnableOut 
      // goes LOW, State will go to Idle State. Otherwise it will remain in 
      // the Receive State.  
     2'b01 :
     begin
        if ((BitCount == TOutBit) & (KmiTrTIMOUT[4] == 1'b1) & ~(KCLK) & 
             ~(KCLKOut))
          NextState = 2'b11;
        else if (~(EnableOut) & DelayEn) 
          NextState = 2'b00;
        else
          NextState = 2'b01;
     end
        
      // If Timeout is enabled, State will go to TIMEOUT state. It will remain 
      // in the current state i.e. Transmit state till all bytes has been 
      // transmitted.
     2'b10 :
     begin
        if ((BitCount == TOutBit) & (KmiTrTIMOUT[4] == 1'b1)) 
          NextState = 2'b11;
        else if ((BitCount == 4'b1011) & (KCLKIn == 1'b1)) 
          NextState = 2'b00;
        else
          NextState = 2'b10;
     end
        
      // If Timeout is enabled, State will remain in the TIMEOUT state. 
      // Otherwise it will go to Idle State.
     2'b11 :
     begin
        if (KmiTrTIMOUT[4] == 1'b0) 
          NextState = 2'b00;
        else
          NextState = 2'b11;
     end
     default :
        NextState = iCurrentState;
     endcase
   end
end  // p_NextStateComb

// ---------------------------------------------------------------------------
// iCurrentState update with every positive edge of REFCLK.
// ---------------------------------------------------------------------------
always @ (posedge REFCLK or nKMIRST)
begin : p_CurrentStateSeq
  if (nKMIRST == 1'b0) 
    iCurrentState <= 2'b00;
  else 
    iCurrentState <= NextState;
end  // p_CurrentStateSeq

assign CurrentState = iCurrentState;

endmodule

// ========================End of KmiTrController ==========================--
