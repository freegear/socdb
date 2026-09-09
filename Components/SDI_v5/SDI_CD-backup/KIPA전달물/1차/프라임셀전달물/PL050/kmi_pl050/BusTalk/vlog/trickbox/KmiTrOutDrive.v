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
//  Filename            : KmiTrOutDrive.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose : This modules drives the Data & Clock on the KCLK & KDATA 
//            lines.
//  ---------------------------------------------------------------------------


module KmiTrOutDrive (
                      REFCLK,
                      BnRES,
                      BitCount,
                      FParErr,
                      KCLK,
                      KmiTrTXREG,
                      CurrentState,
                      KmiTrDSI,
                      KmiTrRG,
                      KDATAIn,
                      RTS,
                      LegacyBit,
                      PWDataIn,
                      WrenSTAT,
                      FeedBackTx,
                      FeedBackRx,
                      KmiTrRXREG,
                      KmiTrPARITYERR,
                      KmiTrFRAMEERR,
                      DataAvl,
                      RdUpdateTx,
                      KCLKOut,
                      KDATAOut,
                      EnableOut
                     );  

input        REFCLK;        // Reference Clock
input        BnRES;         // APB Reset
input [3:0]  BitCount;      // Bit Counter Value
input        FParErr;       // Forced Parity Error
input        KCLK;          // KCLK input
input [7:0]  KmiTrTXREG;    // Tx Data Input
input [1:0]  CurrentState;  // Current State
input [15:0] KmiTrDSI;      // DSI Tim. Param.
input [15:0] KmiTrRG;       // RG Tim. Param.
input        KDATAIn;       // Data line Input from PAD
input        RTS;           // Request to Send Indication
input        LegacyBit;     // Legacy Mode Bit
input [15:0] PWDataIn;      // APB Data Input 
input        WrenSTAT;      // Status Register Write Enable
input        FeedBackTx;    // Used as feedback for synchronization
input        FeedBackRx;    // Used as feedback for synchronization
output [7:0] KmiTrRXREG;    // Received Data
output       KmiTrPARITYERR;// Parity Error Bit
output       KmiTrFRAMEERR; // framing Error Bit
output       DataAvl;       // Data Available Indication to RX fifo
output       RdUpdateTx;    // Data Read signal to TX Fifo
output       KCLKOut;       // Clock Output to The PAD
output       KDATAOut;      // Data Output to The PAD
output       EnableOut;     // Enable signal to different modules

// ----------------------------------------------------------------------------
//
//                         KmiTrOutDrive
//                         =============
//
// ----------------------------------------------------------------------------
//
// Overview
// ========
// This module depending on the CurrentState, drives or recieves the data.
// During Transmission it enables the KCLK generation & outputs the data
// on the KDATAOut. During reception it samples the Data line at every 
// Clock & assembles the input bits in a register. It also checks for
// Parity Error & framing Error. After reception it stores the data into
// the Rx fifo.
//
// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// wire declarations
// -----------------------------------------------------------------------------
wire TimeOutTr;
// Indicates the transition to Timeout State
 
wire TimeOutStrt;
// Indicates the Start of TimeOut
 
wire [7:0] KmiTrRXREG;
// Recieved Data

wire DataAvl;
// Recieve Data Available signal

wire RdUpdateTx;
// Tx Fifo Read signal

wire EnableOut;
// Enable signal to other modules

wire TxParity;
// Transmit Data Parity Bit

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [8:0] TxFrame;
// Transmit frame Register 
 
reg RxParity;
// Receive Data Parity Bit
 
reg [7:0] RxData;
// Received Data 
 
reg [7:0] NextRxData;
// D-input for RxData
 
reg iDataAvl;
// Internal copy of DataAvl
 
reg iRdUpdateTx;
// Internal Copy of RdUpdateTx
 
reg iKCLKOut;
// Internal copy of KCLKOut
 
reg iKDATAOut;
// Internal copy of KDATAOut
 
reg DelayRTS;
// Delayed version of RTS
 
time Tdsi;
// DSI Timing Parameter
 
time Tkrg;
// Tkrg Timing Parameter
 
reg iEnableOut;
// Internal EnableOut
 
reg DelayTimeOutTr; 
// Delayed version of DelayTimeOutTr
 
reg KmiTrPARITYERR;
// Parity Error Signal

reg KmiTrFRAMEERR; 
// Framing Error Signal

reg KCLKOut;
// Clock Output to the PAD

reg KDATAOut;
// Data Output to the PAD

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial  //Default Assignment
begin
  iDataAvl   = 1'b0;
  iRdUpdateTx = 1'b0;
end

always @ ( KmiTrDSI or KmiTrRG)
begin : p_TimeParComb
  Tdsi  = KmiTrDSI;
  Tkrg  = KmiTrRG; 
end // p_TimeParComb

assign TxParity = KmiTrTXREG[0] ^ KmiTrTXREG[1] ^ KmiTrTXREG[2] ^ KmiTrTXREG[3]                   ^ KmiTrTXREG[4] ^ KmiTrTXREG[5] ^ KmiTrTXREG[6] ^ 
                  KmiTrTXREG[7] ^ ~(FParErr); 

assign KmiTrRXREG  = RxData;
assign DataAvl     = iDataAvl;
assign RdUpdateTx  = iRdUpdateTx;
assign EnableOut   = iEnableOut;
assign TimeOutTr   = CurrentState[0] & CurrentState[1];
assign TimeOutStrt =  ~(DelayTimeOutTr) & TimeOutTr;

// ---------------------------------------------------------------------------
// Synchronized KDATAOut 
// ---------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_KDATAOutSeq
  if (BnRES == 1'b0) 
    KDATAOut <= 1'b0;
  else
    KDATAOut <= iKDATAOut;
end  // p_KDATAOutSeq
    
// ---------------------------------------------------------------------------
// Synchronized KCLKOut 
// ---------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_KCLKOutSeq
  if (BnRES == 1'b0) 
    KCLKOut <= 1'b0;
  else
    KCLKOut <= iKCLKOut;
end  // p_KCLKOutSeq
    
// ---------------------------------------------------------------------------
// Delayed version of TimeOutTr to generate pulse at TimeOut start.
// ---------------------------------------------------------------------------
always @ (posedge REFCLK or BnRES)
begin : p_DelayTimeOutTrSeq
  if (BnRES == 1'b0) 
    DelayTimeOutTr <= 1'b0;
  else 
    DelayTimeOutTr <= TimeOutTr;
end  // p_DelayTimeOutTrSeq
    
// ---------------------------------------------------------------------------
// NextRxData is being updated at negetive edge of KCLK. At negative edge 
// of KCLK, NextRxData will be used for shifting data into RxData.
// ---------------------------------------------------------------------------
always @ (negedge KCLK) 
begin : p_RxDataSeq
  NextRxData <= RxData;
end  // p_RxDataSeq    

// ---------------------------------------------------------------------------
// Delayed version of RTS for starting the reception. 
// ---------------------------------------------------------------------------
always @ (posedge BnRES or REFCLK)
begin : p_DelayRTSSeq
  if (BnRES == 1'b0) 
     DelayRTS <= 1'b0;
  else
     DelayRTS <= RTS;
end  // p_DelayRTSSeq

// ---------------------------------------------------------------------------
// Data Available Signal to Receive FIFO. Synchronization procedure has been
// used since this is going to PCLK domain.
// ---------------------------------------------------------------------------
always @ (negedge KCLK or posedge FeedBackRx)
begin : p_DataAvlSeq 
  if (FeedBackRx == 1'b1)
    iDataAvl = 1'b0;
  else if ((BitCount == 4'b1001) & (CurrentState == 2'b01))
      iDataAvl = 1'b1;
end  // p_DataAvlComb 

// ---------------------------------------------------------------------------
// iRdUpdateTx signal is being generated for Reading the TX Fifo.
// ---------------------------------------------------------------------------
always @ (negedge KCLK or posedge TimeOutStrt or posedge FeedBackTx)
begin : p_RdUpdateTxSeq 
  if (FeedBackTx == 1'b1) 
    iRdUpdateTx = 1'b0;
  else if (TimeOutStrt == 1'b1) 
    iRdUpdateTx = 1'b1;
  else if ((BitCount == 4'b1010) & (CurrentState == 2'b10)) 
    iRdUpdateTx = 1'b1;
end  // p_RdUpdateTxSeq 
 
// ---------------------------------------------------------------------------
// Parity Error Check is being done here. This bit can be cleared by 
// writing to the corresponding bit in the Status Register.
// ---------------------------------------------------------------------------
always @ (KCLK or BnRES or WrenSTAT)
begin : p_ParityErrComb  
  if (BnRES == 1'b0) 
    KmiTrPARITYERR = 1'b0;
  else if (WrenSTAT & PWDataIn[0]) 
    KmiTrPARITYERR = 1'b0;
  else if (CurrentState == 2'b01) @(posedge KCLK)
    if ((BitCount == 4'b1000) & (RxParity != KDATAIn)) 
      KmiTrPARITYERR = 1'b1;
end  // p_ParityErrComb 

// ---------------------------------------------------------------------------
// Stop Bit Test
// ---------------------------------------------------------------------------
always @ (KCLK or BnRES or WrenSTAT)
begin : p_FrameErrComb
  if (BnRES == 1'b0) 
    KmiTrFRAMEERR = 1'b0;
  else if (WrenSTAT & PWDataIn[1]) 
    KmiTrFRAMEERR = 1'b0;
  else if (CurrentState == 2'b01) @(posedge KCLK)
    if ((BitCount == 4'b1001) &  ~(KDATAIn) & iKDATAOut)
      KmiTrFRAMEERR = 1'b1;
end  // p_FrameErrComb
 
// ---------------------------------------------------------------------------
// This process generates different signals & outputs for other modules. 
// In this process, depending on the CurrentState various operations are 
// performed. In case of Transmit State & Receive state, KCLKOut is being
// generated. Data is being output in case of Transmit State. When module
// is in receive state, KDATAIn Line is being sampled for receive data.  
// Enable signal for different modules is also being generated here.
// ---------------------------------------------------------------------------
always @ (KCLK or CurrentState or EnableOut)
begin : p_KCLKOutComb
  case (CurrentState)
    2'b00 : 
      iKCLKOut  = 1'b1;
       
    2'b01 : 
      if (EnableOut == 1'b1) 
      begin 
        if (BitCount <= 4'b1001) 
          iKCLKOut = KCLK;
        else if (BitCount == 4'b1010) 
          if (LegacyBit == 1'b0) 
            iKCLKOut = KCLK;
          else
            iKCLKOut = 1'b1;
        else if (BitCount == 4'b1011) 
          iKCLKOut = 1'b1;
      end
         
    2'b10 : begin
      iKCLKOut  = #Tdsi KCLK; 
      if (BitCount == 4'b1011) 
        @(negedge KCLK)  iKCLKOut = #Tdsi 1'b1;
      end

    2'b11 : ; 

    default:
      iKCLKOut = 1'b1;
  endcase
end  // p_KCLKOutComb

always @ (BitCount or CurrentState)
begin : p_KDATAOutComb
  case (CurrentState)
    2'b00 :
      iKDATAOut = 1'b1;
       
    2'b01 :
      if ((BitCount == 4'b1010) &  ~(LegacyBit))  
        iKDATAOut = 1'b0;
      else if(KCLK == 1'b0) 
        iKDATAOut = 1'b1;
         
    2'b10 :
       if (BitCount == 4'b0000)
       begin 
         iKDATAOut = 1'b0;
         TxFrame = {TxParity, KmiTrTXREG};
       end
       else if (BitCount < 4'b1010) 
         @(negedge KCLK) begin
           iKDATAOut = TxFrame[0];
           TxFrame = {1'b0, TxFrame[8:1]};
         end
       else if (BitCount == 4'b1010) 
         @(negedge KCLK) iKDATAOut = 1'b1;

    2'b11 : ;

    default :
      iKDATAOut = 1'b1;
  endcase
end  // p_KDATAOutComb

always @ (BitCount or KCLK or CurrentState or DelayRTS)
begin : p_EnableOutComb
  case (CurrentState)
    2'b00 :
      iEnableOut = 1'b0;
       
    2'b01 :
      if (DelayRTS == 1'b1) 
        iEnableOut = #Tkrg 1'b1;
      else if(KCLK == 1'b0) begin
        if ((BitCount == 4'b1010) & LegacyBit)   
          iEnableOut = 1'b0;
        else if ((BitCount == 4'b1011) &  ~(LegacyBit)) 
          iEnableOut = 1'b0;
        end
         
    2'b10 :
      if (BitCount == 4'b0000) 
        iEnableOut = 1'b1;
      else if (BitCount == 4'b1011) 
        if (KCLK == 1'b0)
          iEnableOut = 1'b0;

    2'b11 :
      iEnableOut = 1'b0; 
      
    default :
      iEnableOut = 1'b0;
  endcase
end  // p_EnableOutComb

always @ (KCLK or CurrentState)
begin : p_UpdateRxComb
  case (CurrentState)
    2'b00 : begin
      RxParity = 1'b1;
      RxData = 8'b00000000;
    end
   
    2'b01 : begin
      @(posedge KCLK)
        if (BitCount < 4'b1000) 
        begin
          RxData = {KDATAIn, NextRxData[7:1]};
          RxParity = RxParity ^ KDATAIn;
        end 
    end
 
    default : begin
      RxParity = 1'b1;
      RxData = 8'b00000000;
    end
  endcase
end  // p_UpdateRxComb

endmodule

// =========================== End of KmiTrOutDrive =========================--
