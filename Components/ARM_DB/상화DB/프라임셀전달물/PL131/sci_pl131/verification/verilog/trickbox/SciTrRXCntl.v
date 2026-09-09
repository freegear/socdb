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
//  File Name              : SciTrRXCntl.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Purpose     : This block performs reception of serial data
//               and performs parity check 
//------------------------------------------------------------------------------
  
`timescale 1ns/1ps

module SciTrRXCntl (
                    SCICLK,
                    PRESETn,
                    TrRXEnSync,
                    TrRXPEnSync,
                    TrRXPStSync,
                    TrRSyRXPC,
                    TrRSyCHG,
                    TrRSyBLKG,
                    SCIDATAIN,
                    SCIDATAOUT,
                    TrRXNAKSync,
                    TrSENSE,
                    TrRSyBaud,
                    TrRSyValue,
                    RXPError,
                    RXCtimError,
                    RXBtimError,
                    StartBitError,
                    RXShiftData,
                    RXFWr
                   );

input        SCICLK;        // Main SCI Clock
input        PRESETn;       // Reset input
input        TrRXEnSync;    // SCI Trickbox Receiver Enable
input        TrRXPEnSync;   // SCI Trickbox Receiver Parity Error Enable
input        TrRXPStSync;   // Receiver Parity State 
input  [3:0] TrRSyRXPC;     // Parity Counter
input  [7:0] TrRSyCHG;      // Character Time counter  
input  [7:0] TrRSyBLKG;     // Block Time Counter
input        SCIDATAIN;     // Receive Serial input
output       SCIDATAOUT;    // Receive serial output
input        TrRXNAKSync;   // Enables character transmit handshaking 
input        TrSENSE;       // Data line SENSE
input [15:0] TrRSyBaud;     // Baud value
input  [7:0] TrRSyValue;    // SCIVALUE    
output       RXPError;      // Receive parity error
output       RXCtimError;   // Receive character time erroe 
output       RXBtimError;   // Receive block time error 
output       StartBitError; // Start bit time error 
output [8:0] RXShiftData;   // Received Data 
output       RXFWr;         // Receive FIFO Write 

//------------------------------------------------------------------------------
//
//                                SciTrRXCntl
//                               =============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
//  This block performs shifting-in of the serial bit stream and stores the
//  received data in a register and perform parity error check on the received 
//  data. If the parity error bit is enabled this block will simulate the 
//  receive parity Error condition and request for retransmission.
// 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define ZERO 28'b0000000000000000000000000000
 
`define ONE  28'b0000000000000000000000000001
 
//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
wire        SCICLK;  
// Main SCI Clock

wire        PRESETn;
// Reset input

wire        TrRXEnSync;
// SCI Trickbox Receiver Enable

wire        TrRXPEnSync;
// SCI Trickbox Receiver Parity Error Enable

wire        TrRXPStSync;
// Receiver Parity State 

wire  [3:0] TrRSyRXPC;
// Parity Counter

wire  [7:0] TrRSyCHG;
// Character Time counter  

wire  [7:0] TrRSyBLKG;
// Block Time Counter

wire        SCIDATAIN;
// Receive Serial input

wire        TrRXNAKSync;
// Enables character transmit handshaking 

wire        TrSENSE;
// Data line SENSE

wire [15:0] TrRSyBaud;
// Baud value

wire  [7:0] TrRSyValue;
// SCIVALUE    

wire        BitPeriodCmp;
wire        BitCmp;
wire        TrRXFError;
wire [27:0] BitPeriodRvalue;
wire [27:0] TrRSyBAUDMul;

//------------------------------------------------------------------------------
// Register declarations
//------------------------------------------------------------------------------
 
// Receive State Register 
reg  [2:0] SciRXCntlSt;
reg  [2:0] NextSciRXCntlSt;

// Receive FIFO Write
reg        RXFWr;
reg        NextRXFWr;

// Receive Parity Error Generation counter  
reg  [3:0] RXPCnt;
reg  [3:0] NextRXPCnt;

reg  [8:0] RXCHGCnt;
reg  [8:0] NextRXCHGCnt;
// Character Guard time counter 
 
reg  [8:0] RXBLKGCnt;
reg  [8:0] NextRXBLKGCnt;
// Block Guard time counter 
 
reg  [8:0] RXShiftReg;
reg  [8:0] NextRXShiftReg;
// Receive Shift Register 
 
reg        RXPError;
reg        NextRXPError;
// Receive parity Error  

reg        RXCtimError;
reg        NextRXCtimError;
// Receive Character time Error  
 
reg        RXBtimError;
reg        NextRXBtimError;
// Receive Block time Error  
 
reg        StartBitError;
reg        NextStartBitError;
// Receive Block time Error  
 
reg        SCIDATAOUT;
reg        NextSCIDATAOUT;
// Serial output signal   

reg [27:0] BitPeriodCnt;
reg [27:0] NextBitPeriodCnt;
// Counter that is used to generate the Baud10 signal

reg  [3:0] BitCnt;
reg  [3:0] NextBitCnt;
// Counter that is used to generate data frame over condition 

reg        Delay;
reg        NextDelay;
// Used to produce one etu delay
  

//------------------------------------------------------------------------------
//
// Main body of code
// ==================
//
//------------------------------------------------------------------------------
    
//-----------------------------------------------------------------------------
// Expansion of comparators...
//-----------------------------------------------------------------------------

assign BitPeriodCmp = (BitPeriodCnt[27:0] == `ONE);
assign BitCmp = (BitCnt[3:0] == 4'b0000);
assign TrRXFError = ((RXPCnt >= 4'b0001) & (TrRXPEnSync));

assign RXShiftData  = RXShiftReg;

//-----------------------------------------------------------------------------
// State transition process
//-----------------------------------------------------------------------------
always @(posedge SCICLK or negedge PRESETn) 
begin : p_ReceSeq
  if (PRESETn == 1'b0)
    begin
      SciRXCntlSt      <= 3'b000;
      RXFWr            <= 1'b0;
      BitPeriodCnt     <= `ZERO;
      BitCnt           <= 4'b0000;
      RXCHGCnt         <= 9'b000000000;
      RXBLKGCnt        <= 9'b000000000;
      RXShiftReg       <= 9'b000000000;
      RXPCnt           <= 4'b0000;
      RXPError         <= 1'b0;
      RXCtimError      <= 1'b0;
      RXBtimError      <= 1'b0;
      StartBitError    <= 1'b0;
      SCIDATAOUT       <= 1'b1;
      Delay            <= 1'b0;
    end
  else
    begin
      SciRXCntlSt      <= NextSciRXCntlSt;
      RXFWr            <= NextRXFWr;
      BitPeriodCnt     <= NextBitPeriodCnt;
      BitCnt           <= NextBitCnt;
      RXCHGCnt         <= NextRXCHGCnt;
      RXBLKGCnt        <= NextRXBLKGCnt;
      RXShiftReg       <= NextRXShiftReg;
      RXPError         <= NextRXPError;
      RXPCnt           <= NextRXPCnt;
      RXCtimError      <= NextRXCtimError;
      RXBtimError      <= NextRXBtimError;
      StartBitError    <= NextStartBitError;
      SCIDATAOUT       <= NextSCIDATAOUT;
      Delay            <= NextDelay;
    end
end // p_ReceSeq

// Output and next state logic generation
always @(SciRXCntlSt or BitPeriodCnt or BitCnt or BitPeriodCmp or BitCmp or
         RXCtimError or RXBtimError or SCIDATAIN or SCIDATAOUT or RXFWr or 
         RXCHGCnt or RXBLKGCnt or RXPCnt or TrRXEnSync or TrRXNAKSync or
         RXShiftReg or TrRSyCHG or TrRSyBLKG or TrRSyRXPC or StartBitError or
         TrRXFError or Delay or RXPError)

begin : p_ReceComb
// Default assignments
NextSciRXCntlSt   = SciRXCntlSt;
NextBitPeriodCnt  = BitPeriodCnt;
NextBitCnt        = BitCnt;
NextRXCHGCnt      = RXCHGCnt;
NextRXBLKGCnt     = RXBLKGCnt;
NextRXPCnt        = RXPCnt;
NextRXPError      = 1'b0;
NextRXCtimError   = 1'b0;
NextRXBtimError   = 1'b0;
NextStartBitError = 1'b0;
NextRXFWr         = RXFWr;
NextSCIDATAOUT    = SCIDATAOUT;
NextRXShiftReg    = RXShiftReg;
NextDelay         = Delay;

  case (SciRXCntlSt)

    // RESET state
    3'b000 :
      begin
        //  Receiver not enabled 
        if (TrRXEnSync == 1'b0)
          begin
            NextSciRXCntlSt   = 3'b000;
            NextBitPeriodCnt  = `ZERO;
          end
        // Receiver is enabled and SCIDATAIN is high
        else 
          begin 
            if (SCIDATAIN == 1'b1)
              begin
                NextBitPeriodCnt  = BitPeriodRvalue + TrRSyBaud;
                NextRXBLKGCnt     = {1'b0, TrRSyBLKG};
                NextSciRXCntlSt   = 3'b001;
              end
            else
              begin
                // SCIDATAIN low detected 
                if (SCIDATAIN == 1'b0)
                  begin
                    if (TrRSyBLKG == 8'b00000000)
                      begin
                        NextBitPeriodCnt = BitPeriodRvalue/2 + TrRSyBaud + 1;
                        NextSciRXCntlSt  = 3'b011;
                      end
                    else
                      begin
                        NextRXBtimError  = 1'b1;
                        NextBitPeriodCnt = BitPeriodRvalue/2 + TrRSyBaud + 1;
                        NextSciRXCntlSt  = 3'b011;
                      end
                  end
              end
          end 
      end


    // BLKG time State
    3'b001 :
      begin
      if (TrRXEnSync == 1'b0)
        begin
          NextSciRXCntlSt     = 3'b000;
          NextBitPeriodCnt    = `ZERO;
          NextRXBLKGCnt       = 9'b000000000;
        end
      // Start bit detected
      else if (SCIDATAIN == 1'b0)
        begin
          if ((BitPeriodCnt <= (2 * TrRSyBaud)) && 
            (RXBLKGCnt == 9'b000000001))
             begin
               NextSciRXCntlSt   = 3'b011;
               NextBitPeriodCnt  = BitPeriodRvalue/2 + TrRSyBaud + 1;
               NextRXBLKGCnt     = 9'b000000000;
             end
           // Start bit detected before the block time completion
           else
             begin
               NextSciRXCntlSt   = 3'b011;
               NextBitPeriodCnt  = BitPeriodRvalue/2 + TrRSyBaud + 1;
               NextRXBtimError   = 1'b1;
               NextRXBLKGCnt     = 9'b000000000;
             end
        end
      // RX block Guard time over. Back to idle state 
      else if ((BitPeriodCmp == 1'b1) && (RXBLKGCnt == 9'b000000001))
        begin
          NextSciRXCntlSt     = 3'b000;
          NextBitPeriodCnt    = `ZERO;
          NextRXBLKGCnt       = 9'b000000000;
        end
      // Bit period over. Reload the counter  
      else if (BitPeriodCmp == 1'b1)
        begin
          NextRXBLKGCnt       = RXBLKGCnt - 1;
          NextBitPeriodCnt    = BitPeriodRvalue;
          NextSciRXCntlSt     = 3'b001;
        end
      else
        begin
          NextSciRXCntlSt     = 3'b001;
          NextBitPeriodCnt    = BitPeriodCnt - 1;   
        end
      end

    // If at any time the SCIDATAIN line goes HIGH, invalidate  the
    // start bit .
    3'b011 : 
      begin
      // Trick box disabled. Back to reset state 
      if (TrRXEnSync == 1'b0)
        begin
          NextSciRXCntlSt   = 3'b000;
          NextBitPeriodCnt  = `ZERO;
        end
      // Invalid start bit detected. Back to reset state
      else if (BitPeriodCmp == 1'b1)
        begin
          NextSciRXCntlSt     = 3'b000;
          NextBitPeriodCnt    = `ZERO;
          NextBitCnt          = 4'b0000;
          NextRXShiftReg      = 9'b000000000;
          NextStartBitError   = 1'b1;
        end
      // Invalid start bit detected. Back to reset state
      else if (SCIDATAIN == 1'b1)
        begin
          NextSciRXCntlSt     = 3'b000;
          NextBitPeriodCnt    = `ZERO;
          NextBitCnt          = 4'b0000;
          NextRXShiftReg      = 9'b000000000;
          NextStartBitError   = 1'b1;
        end
      else if (SCIDATAIN == 1'b0)
        begin
          // Valid start bit detected. Go to Receive state
          if ((BitPeriodCnt <= (2 * TrRSyBaud)) == 1'b1) 
            begin
              NextSciRXCntlSt   = 3'b010;
              NextRXShiftReg    = 9'b000000000;
              NextBitPeriodCnt  = BitPeriodRvalue;
              NextBitCnt        = 4'b1000;
              NextRXPCnt        = TrRSyRXPC;
            end
          else 
            begin
              NextSciRXCntlSt   = 3'b011;
              NextBitPeriodCnt  = BitPeriodCnt - 1;
            end
        end  
      end

    // Receive State  
    3'b010 : 
      begin
      // Trick box disabled. Back to reset state 
      if (TrRXEnSync == 1'b0)
        begin
          NextSciRXCntlSt    = 3'b000;
          NextBitPeriodCnt   = `ZERO;
          NextBitCnt         = 4'b0000;
        end
      // Reception completed. Go to receive GUARD state
      else if ((BitCmp & BitPeriodCmp) == 1'b1)
        begin
          // T0 mode. Parity error enabled
          if ((TrRXNAKSync & TrRXFError) == 1'b1)
            begin
              NextSciRXCntlSt    = 3'b110;
              NextSCIDATAOUT     = 1'b1;
              NextDelay          = 1'b1;
              NextBitPeriodCnt   = BitPeriodRvalue;
              NextRXCHGCnt       = {1'b0, (TrRSyCHG + 7)};
              NextRXFWr          = ~(RXFWr);
              NextRXShiftReg     = {SCIDATAIN, RXShiftReg[8:1]};
              NextRXPError       = {SCIDATAIN     ^ RXShiftReg[1] ^  
                                    RXShiftReg[2] ^ RXShiftReg[3] ^ 
                                    RXShiftReg[4] ^ RXShiftReg[5] ^ 
                                    RXShiftReg[6] ^ RXShiftReg[7] ^ 
                                    RXShiftReg[8] ^ TrRXPStSync   ^ 
                                    TrSENSE };

            end
          // T0 mode. Parity error disabled  
          else if (TrRXNAKSync == 1'b1)
            begin
              NextBitPeriodCnt   = BitPeriodRvalue;
              NextSciRXCntlSt    = 3'b110;
              NextRXCHGCnt       = {1'b0, (TrRSyCHG + 2)};
              NextRXFWr          = ~(RXFWr);
              NextSCIDATAOUT     = 1'b1;
              NextRXShiftReg     = {SCIDATAIN, RXShiftReg[8:1]};
              NextRXPError       = {SCIDATAIN     ^ RXShiftReg[1] ^  
                                    RXShiftReg[2] ^ RXShiftReg[3] ^ 
                                    RXShiftReg[4] ^ RXShiftReg[5] ^ 
                                    RXShiftReg[6] ^ RXShiftReg[7] ^ 
                                    RXShiftReg[8] ^ TrRXPStSync   ^ 
                                    TrSENSE };
            end
          // T1 mode. 
          else
            begin
              NextBitPeriodCnt   = BitPeriodRvalue;
              NextSciRXCntlSt    = 3'b110;
              NextRXCHGCnt       = {1'b0, (TrRSyCHG + 2)};
              NextRXFWr          = ~(RXFWr);
              NextSCIDATAOUT     = 1'b1;
              NextRXShiftReg     = {SCIDATAIN, RXShiftReg[8:1]};
              NextRXPError       = {SCIDATAIN     ^ RXShiftReg[1] ^  
                                    RXShiftReg[2] ^ RXShiftReg[3] ^ 
                                    RXShiftReg[4] ^ RXShiftReg[5] ^ 
                                    RXShiftReg[6] ^ RXShiftReg[7] ^ 
                                    RXShiftReg[8] ^ TrRXPStSync   ^ 
                                    TrSENSE };
            end
        end
      // one bit time (etu) completed 
      else if (BitPeriodCmp == 1'b1)
        begin
          NextRXShiftReg    = {SCIDATAIN, RXShiftReg[8:1]};
          NextBitCnt        = BitCnt - 1;
          NextBitPeriodCnt  = BitPeriodRvalue;
          NextSCIDATAOUT    = 1'b1;
          NextSciRXCntlSt   = 3'b010;
        end
      else
        begin
          NextBitPeriodCnt  = BitPeriodCnt - 1;
          NextSciRXCntlSt   = 3'b010;
        end
      end
   
    // Receive GUARD state 
    3'b110 : 
      begin
      // Trick box disabled. Back to reset  state 
      if (TrRXEnSync == 1'b0)
        begin
          NextSciRXCntlSt      = 3'b000;
          NextBitPeriodCnt     = `ZERO;
          NextRXCHGCnt         = 9'b000000000;
          NextRXPCnt           = 4'b0000; 
          NextSCIDATAOUT       = 1'b1;
        end
      // RX block Guard time over. Back to idle state 
      else if ((RXCHGCnt == 9'b000000001) && (BitPeriodCmp == 1'b1))
         begin
           NextSciRXCntlSt      = 3'b000;
           NextBitPeriodCnt     = `ZERO;
           NextRXCHGCnt         = 9'b000000000;
           NextRXPCnt           = 4'b0000;
           NextSCIDATAOUT       = 1'b1;
         end
      // Start bit detected
      else if ((SCIDATAIN == 1'b0) && (RXCHGCnt == 9'b000000001))  
        begin
          // Charactor Guard time satisfied. 
          if (((BitPeriodCnt == (BitPeriodRvalue/2 + TrRSyBaud + 2)) &&
               (BitPeriodCnt >= (BitPeriodRvalue/2 - TrRSyBaud - 2))) == 1'b1)
            begin 
              // Parity error enabled. Go to re_receive state
              if ((TrRXNAKSync & TrRXFError) == 1'b1)
                begin
                  NextRXPCnt       = RXPCnt - 1; 
                  NextBitPeriodCnt = BitPeriodRvalue/2 + TrRSyBaud;
                  NextSciRXCntlSt  = 3'b111;
                  NextSCIDATAOUT   = 1'b1;
                end
               // Parity error disabled. Go to receive state 
              else 
                begin
                  NextBitPeriodCnt = BitPeriodRvalue/2 + TrRSyBaud;
                  NextSciRXCntlSt  = 3'b011;
                  NextSCIDATAOUT   = 1'b1;
                end
            end
          // Charactor Guard time error. 
          else 
            begin
              // Parity error enabled. Go to re_receive state
              if ((TrRXNAKSync & TrRXFError) == 1'b1)
                begin
                  NextRXPCnt = RXPCnt - 1; 
                  NextBitPeriodCnt = BitPeriodRvalue/2 + TrRSyBaud;
                  NextSciRXCntlSt  = 3'b111;
                  NextRXCtimError  = 1'b1;
                  NextSCIDATAOUT   = 1'b1;
                end
              // Parity error disabled. Go to receive state 
              else
                begin
                  NextBitPeriodCnt = BitPeriodRvalue/2 + TrRSyBaud;
                  NextSciRXCntlSt  = 3'b011;
                  NextRXCtimError  = 1'b1;
                  NextSCIDATAOUT   = 1'b1;
                end
            end
        end
      // One bit period over(etu). Decrement the NextBitPeriod counter 
      else if (BitPeriodCmp == 1'b1)
        begin
          // Asking for the retransmission by making the SCIDATAOUT signal
          // low for one etu after the parity bit detection   
          if (Delay == 1'b1)
            begin
              NextDelay          = 1'b0;
              NextSCIDATAOUT     = 1'b0;
              NextRXCHGCnt       = RXCHGCnt - 1;
              NextBitPeriodCnt   = BitPeriodRvalue;
              NextSciRXCntlSt    = 3'b110;
            end
          // make the SCIDATAOUT signal high after one etu
          else
            begin
              NextSCIDATAOUT     = 1'b1;
              NextRXCHGCnt       = RXCHGCnt - 1;
              NextBitPeriodCnt   = BitPeriodRvalue;
              NextSciRXCntlSt    = 3'b110;
            end
        end
      else 
        begin
          NextSciRXCntlSt      = 3'b110;
          NextBitPeriodCnt     = BitPeriodCnt - 1;
        end
      end

    // Re_Receive state 
    3'b111 : 
      begin
        // Trick box disabled. Back to reset state 
        if (TrRXEnSync == 1'b0)
          begin
            NextSciRXCntlSt      = 3'b000;
            NextBitPeriodCnt     = `ZERO;
          end
        // Invalid start bit detected
        else if (BitPeriodCmp == 1'b1)
          begin
            NextSciRXCntlSt      = 3'b000;
            NextBitPeriodCnt     = `ZERO;
            NextBitCnt           = 4'b0000;
            NextRXShiftReg       = 9'b000000000;
            NextStartBitError    = 1'b1;
          end
      // Invalid start bit detected
      else if (SCIDATAIN == 1'b1)
        begin
          NextSciRXCntlSt      = 3'b000;
          NextBitPeriodCnt     = `ZERO;
          NextBitCnt           = 4'b0000;
          NextRXShiftReg       = 9'b000000000;
          NextStartBitError    = 1'b1;
        end
      // Valid start bit detected.
      else if (SCIDATAIN == 1'b0)
        begin
          if ((BitPeriodCnt <=  2 * (TrRSyBaud + 1)) == 1'b1) 
            begin
              NextSciRXCntlSt     = 3'b010;
              NextRXShiftReg      = 9'b000000000;
              NextBitPeriodCnt    = BitPeriodRvalue;
              NextBitCnt          = 4'b1000;
            end
          else
            begin
              NextBitPeriodCnt    = BitPeriodCnt - 1;
              NextSciRXCntlSt     = 3'b111;
            end
        end
      end

   default :  
      NextSciRXCntlSt         = 3'b000;

  endcase
end // p_ReceComb

//-----------------------------------------------------------------------------
// Calculating the Bit period time from Baud and SCIVALUE 
//-----------------------------------------------------------------------------
assign TrRSyBAUDMul    = {12'b000000000000, TrRSyBaud};
assign BitPeriodRvalue = (TrRSyBAUDMul + 1) * TrRSyValue;

endmodule

//=============================== End =======================================--
