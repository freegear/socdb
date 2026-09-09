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
//  File Name              : SciTrTXCntl.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
//  Purpose                : This module contain transmit state machine.
//------------------------------------------------------------------------------

`timescale 1ns/1ps 
 
//------------------------------------------------------------------------------

module SciTrTXCntl 
       (
        SCICLK, 
        PRESETn, 
        TrTxEnSync, 
        TrTxPEnSync, 
        TrTXPStSync, 
        TrTXNAKSync, 
        TrSENSE, 
        TrRSyTXPC,  
        TrRSyCHG,  
        TrRSyBLKG,  
        TrRSyBAUD, 
        TrRSyVALUE,  
        TrRSyJit, 
        TrRSyJitPat,  
        TXDataAvlblSync, 
        TXShiftData, 
        TXFRdPtrInc, 
        SCIDATAOUT, 
        SCIDATAIN, 
        TXPtimError, 
        TXPtimWdError, 
        TXPError  
       );

input        SCICLK; // RFCLK input	
input        PRESETn; // Reset input
input        TrTxEnSync; // Transmitter enabled
input        TrTxPEnSync; // Transmiter parity Error enabled
input        TrTXPStSync; // Parity state 
input        TrTXNAKSync; // T0 mode 
input        TrSENSE; // Data line sense
input        [3:0]TrRSyTXPC;  // TX retray cnt 
input        [7:0]TrRSyCHG;  // TX CHG
input        [7:0]TrRSyBLKG;  // TX BLKG 
input        [15:0]TrRSyBAUD; // Baud value 
input        [7:0]TrRSyVALUE;  // SCIVALUE 
input        [15:0]TrRSyJit; // Jit value
input        [9:0]TrRSyJitPat;  // Jit Patern
input        TXDataAvlblSync; // Data level of FIFO
input        [7:0]TXShiftData; // Transmit DATA
output        TXFRdPtrInc ; // TX FIFO read pointer Increment
output        SCIDATAOUT ; // Serial dada out put
input         SCIDATAIN; // Serial data in put
output        TXPtimError ; // Parity tim Error
output        TXPtimWdError ; // Parity width Error 
output        TXPError;  // Parity Error
//------------------------------------------------------------------------------
//
//                   SciTrTXCntl
//                   =============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
//  The transmit state machine shifts out transmit data according to the
//  programmed frequency. After one FRAM transmission pull the out put line   
//  HIGH and check the input line. If the receiver pull the line low with  
//  in a valid time period it will retransmit the same data again else   
//  increment the FIFO pointer and transmit the next data in the FIFO  
//-----------------------------------------------------------------------------

 
 
 
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define ZEROVAL  28'b0000000000000000000000000000 
 
`define ONE      28'b0000000000000000000000000001
 
//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------

reg [2:0]SciTXCntlSt;
reg [2:0]NextSciTXCntlSt;
// Transmit State Register

reg iTXFRdPtrInc;
reg NextTXFRdPtrInc;
// Transmit FIFO read pointer Increment

reg iSCIDATAOUT;
reg NextSCIDATAOUT;
// Serial out put data line

reg [2:0]BitCount;
reg [2:0]NextBitCount;
// Bit count. Determine the FRAM width

reg [6:0]TXShiftReg;
reg [6:0]NextTXShiftReg;
// Transmit shift register

reg [3:0]TXPCnt;
reg [3:0]NextTXPCnt;
// Transmit retray counter

reg [7:0]TXCHGCnt;
reg [7:0]NextTXCHGCnt;
// Charactor Guard register 

reg [7:0] TXBLKGCnt;
reg [7:0] NextTXBLKGCnt;
// Block Guard register 

reg [27:0] BitJitCnt;
reg [27:0] NextBitJitCnt;
// Bit period register
 
reg [9:0]JitPat;
reg [9:0]NextJitPat;
// Jitter value register

reg [3:0]JitCorrCnt;
reg [3:0]NextJitCorrCnt;
// Jitter correction register

reg iTXPtimError; 
reg NextTXPtimError; 
// TX parity time error ( retransission hand shaking asserter at wrong time)

reg iTXPtimWdError; 
reg NextTXPtimWdError ; 
// TX parity time width error

reg iTXPError; 
reg NextTXPError; 
// TX parity error

reg ParityBit; 
reg NextParityBit;
//  parity bit
    
// Comparators
wire BitCountComp;
wire BitCountHalf;
wire BitJitCmp;
wire TXCHGCountCmp;
wire TXBLKGCountCmp;
wire TrTXFError;

wire JitEn;
// Jitter enable   

wire JitDir;
// Jitter direction
   
wire [27:0]BitJitRvalue;
// Bit width in RFCLK value
 
wire [27:0]JitCorrVALUE;
// Jitter correction value 

wire[27:0]TrRSyBAUDMul;
//  Baud value

wire [27:0]TrRSyJitMul;
// Jitter value 
   
//------------------------------------------------------------------------------
//
// Main body of  code
// ==================
//
//-----------------------------------------------------------------------------
    

//------------------------------------------------------------------------------
// Assign local copy to the output signal
//-----------------------------------------------------------------------------
assign SCIDATAOUT       =  iSCIDATAOUT;
assign TXFRdPtrInc      =  iTXFRdPtrInc;
assign TXPtimError      =  iTXPtimError; 
assign TXPtimWdError    =  iTXPtimWdError; 
assign TXPError         =  iTXPError; 

//-----------------------------------------------------------------------------
// Expansion of comparators...
//-----------------------------------------------------------------------------
assign BitCountComp   = (BitCount[2:0] == 3'b000) ? 1'b1 :  1'b0;
assign BitCountHalf   = (BitCount[2:0] == 3'b100) ? 1'b1 : 1'b0;
assign TXCHGCountCmp  = (TXCHGCnt[7:0] == 'b00000001) ? 1'b1 : 1'b0;
assign TXBLKGCountCmp = (TXBLKGCnt[7:0] == 'b00000001) ?  1'b1: 1'b0;
assign TrTXFError     = ((TXPCnt >= 4'b0001) && (TrTxPEnSync == 1'b1)) ? 1'b1 :
                         1'b0;
assign BitJitCmp      = (BitJitCnt[27:0] == `ONE)  ? 1'b1 : 1'b0;
assign JitEn          = JitPat[0];
assign JitDir         = JitPat[9];

//-----------------------------------------------------------------------------
// State transition process
//-----------------------------------------------------------------------------
always @(posedge SCICLK or  negedge PRESETn) 
begin : p_TranSeq 
  if (PRESETn == 1'b0)
    begin 
      SciTXCntlSt      <= 3'b000;
      iSCIDATAOUT      <= 1'b1;
      iTXFRdPtrInc     <= 1'b0;
      iTXPtimError     <= 1'b0; 
      iTXPtimWdError   <= 1'b0;
      iTXPError        <= 1'b0;
      BitCount         <= 3'b000;
      BitJitCnt        <= `ZEROVAL;
      JitPat           <= 10'b0000000000;
      JitCorrCnt       <= 4'b0000;
      TXPCnt           <= 4'b0000;
      TXCHGCnt         <= 8'b00000000;
      TXBLKGCnt        <= 8'b00000000;
      TXShiftReg       <= 7'b0000000;
      ParityBit        <= 1'b0;
    end 
  else
    begin 
      SciTXCntlSt      <= NextSciTXCntlSt;
      iTXFRdPtrInc     <= NextTXFRdPtrInc;
      iSCIDATAOUT      <= NextSCIDATAOUT;
      iTXPtimError     <= NextTXPtimError; 
      iTXPtimWdError   <= NextTXPtimWdError; 
      iTXPError        <= NextTXPError;
      BitCount         <= NextBitCount;
      BitJitCnt        <= NextBitJitCnt;
      JitPat           <= NextJitPat;
      JitCorrCnt       <= NextJitCorrCnt;
      TXPCnt           <= NextTXPCnt;
      TXCHGCnt         <= NextTXCHGCnt;
      TXBLKGCnt        <= NextTXBLKGCnt;
      TXShiftReg       <= NextTXShiftReg;
      ParityBit        <= NextParityBit;
    end
end // p_TranSeq;

//-----------------------------------------------------------------------------
// Output and next state logic generation
//-----------------------------------------------------------------------------
always @(SciTXCntlSt or iSCIDATAOUT or SCIDATAIN or BitCount or 
         BitJitCnt or TXPCnt or TXCHGCnt or TXBLKGCnt or 
         TXShiftReg or TXDataAvlblSync or TrTxEnSync or 
         TrRSyBLKG or TXBLKGCountCmp or BitJitCmp or 
         BitCountComp or BitCountHalf or TrRSyCHG or 
         TXCHGCountCmp or ParityBit or iTXFRdPtrInc or
         iTXPtimError or iTXPtimWdError or JitPat or JitCorrCnt)
begin : p_TranCombo
// Default assignments
  NextSciTXCntlSt   = SciTXCntlSt;
  NextTXFRdPtrInc   = iTXFRdPtrInc;
  NextTXPtimError   = 1'b0; 
  NextTXPtimWdError = 1'b0; 
  NextSCIDATAOUT    = iSCIDATAOUT;
  NextBitCount      = BitCount;
  NextBitJitCnt     = BitJitCnt;
  NextJitPat        = JitPat;
  NextJitCorrCnt    = JitCorrCnt;
  NextTXPCnt        = TXPCnt;
  NextTXCHGCnt      = TXCHGCnt;
  NextTXBLKGCnt     = TXBLKGCnt;
  NextTXShiftReg    = TXShiftReg;
  NextParityBit     = ParityBit;

  case (SciTXCntlSt) 

    // RESET state 
    3'b000 :
    
      // Transmiter enabled && data available in the FIFO. 
      // Go to START bit state  
      if (((TXDataAvlblSync) && (TrTxEnSync) == 1'b1))
        begin  
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = BitJitRvalue;
          NextJitPat        = TrRSyJitPat;
          NextSciTXCntlSt   = 3'b001;
          NextJitCorrCnt    = 4'b0000;
          NextTXBLKGCnt     = TrRSyBLKG;
          NextTXPCnt        = TrRSyTXPC;
       end  
     else
       begin 
         NextSCIDATAOUT    = 1'b1;
         NextBitJitCnt     = `ZEROVAL;
         NextSciTXCntlSt   = 4'b000;
       end

    // BLKGUARD state 
    3'b001 :

      // Transmitter is disabled. Go to RESET state 
      if (TrTxEnSync == 1'b0) 
        begin  
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = `ZEROVAL;
          NextSciTXCntlSt   = 3'b000;
          NextTXBLKGCnt     = 8'b00000000;
        end 
      // Transmit Guard time completed. Go to START BIT state
      else if (((BitJitCmp) && (TXBLKGCountCmp)) || 
               ((TrRSyBLKG == 8'b00000000) == 1'b1))
        begin  
          NextSCIDATAOUT    = 1'b0;
          NextBitJitCnt     = BitJitRvalue;
          NextBitCount      = 3'b111;
          NextSciTXCntlSt   = 3'b011;
          NextTXBLKGCnt     = 8'b00000000;
          NextJitPat = {JitPat[9], 1'b0, JitPat[8:1]};
        // Jitter enabled. Increment the Jitter correction counter. If JitDir
        // signal is high add the jitter value else subtract the jitter 
        // value     
          if (JitEn == 1'b1)
            begin  
              NextJitCorrCnt  = JitCorrCnt + 1;
              if (JitDir == 1'b1) 
                NextBitJitCnt = BitJitRvalue + TrRSyJit;
              else
                NextBitJitCnt = BitJitRvalue - TrRSyJit;
            end 
          // jitter is not enabled
          else
          NextBitJitCnt   = BitJitRvalue;
        end
      // Bit preiod over. Reload the BitPeriod counter
      else if (BitJitCmp == 1'b1)
        begin  
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = BitJitRvalue;
          NextTXBLKGCnt     = (TXBLKGCnt -1);
          NextSciTXCntlSt   = 3'b001;
        end
      else
        begin  
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = BitJitCnt -1;
          NextSciTXCntlSt   = 3'b001;
        end

 
    // START bit state 
    3'b011 :

      // Transmitter is disabled. Go to RESET state 
      if (TrTxEnSync == 1'b0)
        begin 
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = `ZEROVAL;
          NextSciTXCntlSt   = 3'b000;
        end  
      // Transmit FIFO becomes empty. Go to RESET state 
      else if (TXDataAvlblSync == 1'b0)
        begin  
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = `ZEROVAL;
          NextSciTXCntlSt   = 3'b000;
          NextTXCHGCnt      = 8'b00000000;
        end    
      // Start bit transmission completed. Go to DATA TRANSMIT state
      else if (BitJitCmp == 1'b1)
        begin  
          NextParityBit     = ((TXShiftData[0])^ (TXShiftData[1]) ^ 
                               (TXShiftData[2]) ^ (TXShiftData[3]) ^ 
                               (TXShiftData[4]) ^ (TXShiftData[5]) ^
                               (TXShiftData[6]) ^ (TXShiftData[7]) ^ 
                               (TrTXPStSync)    ^ (TrTXFError)     ^ 
                               (TrSENSE));  
          NextSCIDATAOUT      = TXShiftData[0];
          NextBitCount        = 3'b111;
          NextTXShiftReg[6:0] = TXShiftData[7:1];
          NextSciTXCntlSt     = 3'b010;
          NextJitPat          = {JitPat[9], 1'b0, JitPat[8:1]};
        // Jitter enabled. Increment the Jitter correction counter. If JitDir
        // signal is high add the jitter value else subtract the jitter 
        // value     
          if (JitEn == 1'b1)
            begin 
              NextJitCorrCnt  = JitCorrCnt + 1;
              if (JitDir == 1'b1) 
                NextBitJitCnt = BitJitRvalue + TrRSyJit;
              else
                NextBitJitCnt = BitJitRvalue - TrRSyJit;
            end
        // jitter is not enabled
          else
            NextBitJitCnt  = BitJitRvalue;
        end
      else 
        begin 
          NextBitJitCnt     = BitJitCnt -1;
          NextSciTXCntlSt   = 3'b011;
        end
   

    // DATA TRANSMIT state
    3'b010 :

      // Transmitter is disabled. Go to RESET state 
      if (TrTxEnSync == 1'b0)
        begin 
          NextSCIDATAOUT    = 1'b1;
          NextBitJitCnt     = `ZEROVAL;
          NextBitCount      = 3'b000;
          NextSciTXCntlSt   = 3'b000;
        end 
     // All data bits transmitted. Go to PARITY BIT state.
      else if (((BitJitCmp) && (BitCountComp)) == 1'b1) 
        begin 
          NextSCIDATAOUT    = ParityBit;
          NextSciTXCntlSt   = 3'b110;
          NextJitPat        ={JitPat[9], 1'b0, JitPat[8:1]};
        // Jitter enabled. Increment the Jitter correction counter. If JitDir
        // signal is high add the jitter value else subtract the jitter
        // value    
          if (JitEn == 1'b1)
            begin
              NextJitCorrCnt  = JitCorrCnt + 1;
              if (JitDir == 1'b1)
                NextBitJitCnt = BitJitRvalue + TrRSyJit;
              else
                NextBitJitCnt = BitJitRvalue - TrRSyJit;
            end
        // jitter is not enabled
          else
            NextBitJitCnt   = BitJitRvalue;
        end
      //  At the end of a bit period, shift in the next bit && reload the
      //  BitJitCnt counter
      else if (BitJitCmp == 1'b1)
        begin 
          NextSCIDATAOUT             = TXShiftReg[0];
          NextBitCount               = BitCount -1;
          NextTXShiftReg[5:0] = TXShiftReg[6:1]; 
          NextTXShiftReg[6]          = 1'b0; 
          NextSciTXCntlSt            = 3'b010;
          NextJitPat                 = {JitPat[9], 1'b0, JitPat[8:1]};
        // Jitter enabled. Increment the Jitter correction counter. If JitDir
        // signal is high add the jitter value else subtract the jitter
        // value    
          if (JitEn == 1'b1)
            begin 
              NextJitCorrCnt  = JitCorrCnt + 1;
              if (JitDir == 1'b1) 
                NextBitJitCnt = BitJitRvalue + TrRSyJit;
              else
                NextBitJitCnt = BitJitRvalue - TrRSyJit;
            end
          else
          // jitter is not enabled
            NextBitJitCnt   = BitJitRvalue;
        end
      else
        begin 
          NextBitJitCnt     = BitJitCnt -1;
          NextSciTXCntlSt   = 3'b010;
        end
       

    // PARITY BIT state.
    3'b110 :
      // Transmitter is disabled. Go to RESET state 
      if (TrTxEnSync == 1'b0) 
        begin 
          NextSCIDATAOUT        = 1'b1;
          NextBitJitCnt         = `ZEROVAL;
          NextSciTXCntlSt       = 3'b000;
        end 
      // Parity bit transmission completed. Go to TRANSMIT GUARD state
      else if (BitJitCmp == 1'b1)
        begin 
          NextSCIDATAOUT        = 1'b1;
          NextSciTXCntlSt       = 3'b111;
          NextJitPat            = TrRSyJitPat;
          NextJitCorrCnt        = 4'b0000;
        // Make the FRAM width `define by giving the inverse jitter
        // in transmit charactor guard time  
          if (JitDir == 1'b1) 
            NextBitJitCnt       = BitJitRvalue  - JitCorrVALUE;
          else 
            NextBitJitCnt       = BitJitRvalue  + JitCorrVALUE;
        // T0 mode
          if (TrTXNAKSync == 1'b1)
            begin  
              NextTXCHGCnt        = TrRSyCHG + 2; 
              NextTXBLKGCnt       = 8'b00000010;
            end
        // T1 mode
          else
            begin  
              NextTXCHGCnt        = TrRSyCHG + 1; 
              NextTXFRdPtrInc     =  !(iTXFRdPtrInc); 
              NextTXBLKGCnt       = 8'b00000010;
            end
        end
      else 
        begin
          NextBitJitCnt         = BitJitCnt - 1;
          NextSciTXCntlSt       = 3'b110;
        end


    // TRANSMIT GUARD state
    3'b111 :
      // Transmitter is disabled. Go to RESET state 
      if (TrTxEnSync == 1'b0)
        begin  
          NextSCIDATAOUT        = 1'b1;
          NextBitJitCnt         = `ZEROVAL;
          NextSciTXCntlSt       = 3'b000;
          NextTXCHGCnt = 8'b00000000;
        end
      // Charactor Guard time over. 
      else if (((BitJitCmp) && (TXCHGCountCmp)) == 1'b1) 
        begin  
        // Transmiter FIFO empty. Go to RESET state
          if (TXDataAvlblSync == 1'b0) 
            begin  
              NextSCIDATAOUT      = 1'b1;
              NextBitJitCnt       = `ZEROVAL;
              NextSciTXCntlSt     = 3'b000;
              NextTXCHGCnt        = 8'b00000000;
            end
        // Transmiter FIFO not empty. Go to START BIT state
          else
            begin  
              NextSCIDATAOUT      = 1'b0;
              NextBitJitCnt       = BitJitRvalue;
              NextSciTXCntlSt     = 3'b011;
              NextTXPCnt          = TrRSyTXPC;
              NextJitPat          = {JitPat[9], 1'b0, JitPat[8:1]};
            end
          // Jitter enabled. Increment the Jitter correction counter. If JitDir
          // signal is high add the jitter value else subtract the jitter
          // value
          if (JitEn == 1'b1) 
            begin  
              NextJitCorrCnt    = JitCorrCnt + 1;
              if (JitDir == 1'b1) 
                NextBitJitCnt   = BitJitRvalue + TrRSyJit;
              else
                NextBitJitCnt   = BitJitRvalue - TrRSyJit;
            end
          else
            NextBitJitCnt     = BitJitRvalue;
        end
      // Parity Error detected. Go to PARITY_WIDTH state. SCIDATIN should
      // remain low for 2 etu time 
      else if (SCIDATAIN == 1'b0) 
        begin  
        // Parity error asserted with in the valid time period  
          if ((BitJitCnt == ((BitJitRvalue/2) + (TrRSyBAUD +3))) &&
               (BitJitCnt >= ((BitJitRvalue/2) - (TrRSyBAUD +1)))) 
             begin  
               NextBitJitCnt       = BitJitRvalue + TrRSyBAUD;
               NextSciTXCntlSt     = 3'b101;
               NextTXBLKGCnt       = 8'b00000010;
             end
           else
             begin  
               NextBitJitCnt       = BitJitRvalue + TrRSyBAUD;
               NextSciTXCntlSt     = 3'b101;
               NextTXPtimError     = 1'b1; 
               NextTXBLKGCnt       = 8'b00000010;
             end
        end
      // Bit Period over. Reload the Bitperiod counter  
      else if (BitJitCmp == 1'b1 ) 
        begin  
        // Increment the transmit FIFO.  
          if ((TrTXNAKSync == 1'b1) && (TXCHGCnt == 8'b00000010 )) 
            begin  
              NextBitJitCnt       = BitJitRvalue;
              NextSciTXCntlSt     = 3'b111;
              NextTXCHGCnt        = TXCHGCnt -1;
              NextTXBLKGCnt       = TXBLKGCnt -1;
              NextTXFRdPtrInc     =  !(iTXFRdPtrInc); 
            end
          else
            begin  
              NextBitJitCnt       = BitJitRvalue;
              NextSciTXCntlSt     = 3'b111;
              NextTXCHGCnt        = TXCHGCnt - 1;
              NextTXBLKGCnt       = TXBLKGCnt - 1;
            end
        end
      else
        begin  
          NextBitJitCnt         = BitJitCnt - 1;
          NextSciTXCntlSt       = 3'b111;
        end


    // PARITY_WIDTH state    
    3'b101 :

      // Transmitter is disabled. Go to RESET state 
      if (TrTxEnSync == 1'b0) 
        begin  
          NextSCIDATAOUT     = 1'b1;
          NextBitJitCnt      = `ZEROVAL;
          NextSciTXCntlSt    = 3'b000;
          NextTXCHGCnt       = 8'b00000000;
        end
      // Width 2 etu over. If SCIDATAIN still remain low Go to RESET state.
      // Otherwise dataclash may happen.      
      else if (((BitJitCmp) && (TXBLKGCountCmp)) == 1'b1) 
        begin  
          NextBitJitCnt      = BitJitRvalue - TrRSyBAUD;
          NextSciTXCntlSt    = 3'b100;
          NextTXCHGCnt       = TrRSyCHG; 
          NextTXBLKGCnt      = 8'b00000000;
          NextTXPtimWdError   = 1'b1;
        end
      // SCIDATAIN become high with in the valid time period.  
      else if (SCIDATAIN == 1'b1) 
        begin  
          if ((TXBLKGCnt == 8'b00000001) &&
              (BitJitCnt == (2 * (TrRSyBAUD+1) + 2))) 
            begin  
              NextBitJitCnt    = BitJitRvalue;
              NextSciTXCntlSt  = 3'b100;
              NextTXCHGCnt     = TrRSyCHG +2; 
              NextTXBLKGCnt    = 8'b00000000;
            end
          else 
            begin  
              NextBitJitCnt     = BitJitRvalue;
              NextSciTXCntlSt   = 3'b100;
              NextTXCHGCnt      = TrRSyCHG +2; 
              NextTXBLKGCnt     = 8'b00000000;
              NextTXPtimWdError  = 1'b1;
            end
         end
      else if (BitJitCmp == 1'b1) 
        begin  
          NextBitJitCnt   = BitJitRvalue;
          NextTXBLKGCnt   = TXBLKGCnt -1;
          NextSciTXCntlSt = 3'b101;
        end
      else
        begin  
          NextBitJitCnt   = BitJitCnt -1;
          NextSciTXCntlSt = 3'b101;
        end


    // RE_TRANSMIT state 
    3'b100 :

      // Transmitter is disabled. Go to RESET state 
      if(TrTxEnSync == 1'b0)
        begin  
        NextSCIDATAOUT     = 1'b1;
        NextBitJitCnt      = `ZEROVAL;
        NextSciTXCntlSt    = 3'b000;
        NextTXCHGCnt       = 8'b00000000;
      end
      // In 2 etu time over.    
      else if (((BitJitCmp) && (TXCHGCountCmp)) == 1'b1) 
        begin  
        // Transmit FIFO become empty. Go to RESET state 
          if (TXDataAvlblSync == 1'b0) 
            begin  
              NextSCIDATAOUT   = 1'b1;
              NextBitJitCnt    = `ZEROVAL;
              NextSciTXCntlSt  = 3'b000;
              NextTXCHGCnt     = 8'b00000000;
            end
        // Transmit FIFO not empty. Go to START BIT state 
          else 
            begin  
              NextSCIDATAOUT   = 1'b0;
              NextBitJitCnt    = BitJitRvalue;
              NextSciTXCntlSt  = 3'b011;
              NextTXCHGCnt     = 8'b00000000;
              NextTXBLKGCnt    = 8'b00000000;
              NextTXPCnt       = TXPCnt -1;
              NextJitPat       = {JitPat[9], 1'b0, JitPat[8:1]};
            // Jitter enabled. Increment the Jitter correction counter. If JitDir
            // signal is high add the jitter value else subtract the jitter
            // value
              if (JitEn == 1'b1) 
                begin  
                  NextJitCorrCnt  = JitCorrCnt + 1;
                  if (JitDir == 1'b1) 
                    NextBitJitCnt = BitJitRvalue + TrRSyJit;
                  else
                    NextBitJitCnt = BitJitRvalue - TrRSyJit;
                end
              else
                NextBitJitCnt  = BitJitRvalue;
            end
        end
      else if (BitJitCmp  == 1'b1) 
        begin  
          NextBitJitCnt   = BitJitRvalue;
          NextTXCHGCnt    = TXCHGCnt -1;
          NextSciTXCntlSt = 3'b100;
        end
      else 
        begin  
          NextBitJitCnt   = BitJitCnt -1;
          NextSciTXCntlSt = 3'b100;
        end
         
    default :
      NextSciTXCntlSt = 3'b000;
  endcase
end // 

//-----------------------------------------------------------------------------
// Transmit Error enable. It is used for sending wrong parity && check  
// whether the receiver ask for retransmission 
//-----------------------------------------------------------------------------
always @(SciTXCntlSt)
begin : p_TXPRErrorComb 
  if ((SciTXCntlSt == 3'b101) && (TrTXFError == 1'b0)) 
    NextTXPError = 1'b1;
  else 
    NextTXPError = 1'b0;
end // p_TXPRErrorComb;  

//-----------------------------------------------------------------------------
// Calculating the Bit period time from Baud && SCIVALUE
//-----------------------------------------------------------------------------
assign TrRSyBAUDMul    = {12'b000000000000, TrRSyBAUD}; 
assign TrRSyJitMul     = {12'b000000000000, TrRSyJit}; 

assign BitJitRvalue    =  ((TrRSyBAUDMul + 1) * TrRSyVALUE);
assign JitCorrVALUE    = (SciTXCntlSt == 3'b110) ?  (JitCorrCnt * TrRSyJitMul) :
                         0;

 

//  Signals: SciTXCntlSt<3:0> SciTXCntlNextSt<3:0> 
//    ST_IDLE	000
//    ST_BLKGUARD 001
//    ST_STARTBIT 011
//    ST_TRDATA 010
//    ST_PARITY 110
//    ST_CHGUARD 111
//    ST_WIDTH 101
//    ST_RETRANSMIT 100
endmodule
//=============================== End =======================================--
