//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only
//  as authorised by a licensing agreement from ARM Limited
//  (C) COPYRIGHT 1998 ARM Limited
//  ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised copies
//  and copies may only be made to the extent permitted by a
//  licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information :
//
//
//  Filename            : KmiTrick.v,v
//
//  File Revision       : 1.1
//
//  Release Information : PL050-REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose: This file is top level for KMI TrickBox.
//
// ----------------------------------------------------------------------------


module KmiTrick (
                 BnRES,
                 PCLK,
                 PADDR,
                 PWDATA, 
                 PSELT,
                 PENABLE, 
                 PWRITE,
                 PRDATA,
                 KDATAIN,
                 KDATAOUT,
                 KMIRXINTR,
                 KMITXINTR, 
                 KMIINTR,
                 KCLKIN,
                 KCLKOUT,
                 KMIREFCLK,
                 SCANMODE,
                 nKMIRST
                );
     
input         BnRES;       // APB Reset Signal
input         PCLK;        // APB Clock
input [7:2]   PADDR;       // APB Address Bus
input [15:0]  PWDATA;      // APB Write Data Bus
input         PSELT;       // APB Slave Select Signal
input         PENABLE;     // APB Slave Enable
input         PWRITE;      // Read/Write Signal
output [15:0] PRDATA;      // Read data Bus
input         KDATAIN;     // Data input from PAD
output        KDATAOUT;    // Data output to PAD
input         KMIRXINTR;   // KMI Receive ierrupt
input         KMITXINTR;   // KMI transmit ierrupt
input         KMIINTR;     // KMI Combined ierrupt 
input         KCLKIN;      // Clock Input from PAD
output        SCANMODE;    // Scan Mode Enable Output
output        KCLKOUT;     // Clock Output to the PAD
output        KMIREFCLK;   // KMI Refrence Clock Output
output        nKMIRST;      // KMI Reset

// ---------------------------------------------------------------------------
//
//                               KmiTrick
//                               ========
//
// ---------------------------------------------------------------------------
//
// Overview
// ========
// This module is top level of KMI TrickBox. It instantiates different sub-
// modules. It drives the non-AMBA inputs of KMI Controller and reads the 
// non-AMBA outputs of the same. It also contains the synchronization 
// mechanism for signals passing through one clock domain to another clock 
// domain.
//
// ---------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------
wire WrenTXREG;
// Tx Fifo Write Enable from APB Interface to KmiTrRegfile
 
wire WrenCnREG;
// Control Register Write Enable from APB Interface to KmiTrRegfile
 
wire WrenSTAT;
// Status Register Write Enable 
 
wire WrenCLKL;
// CLKL Write Enable from APB Interface to KmiTrRegfile
 
wire WrenCLKH;
// CLKH Write Enable from APB Interface to KmiTrRegfile
 
wire WrenDSI;
// DSI Write Enable from APB Interface to KmiTrRegfile
 
wire WrenDHI;
// DHI Write Enable from APB Interface to KmiTrRegfile
 
wire WrenDSO;
// DSO Write Enable from APB Interface to KmiTrRegfile
 
wire WrenDHO;
// DHO Write Enable from APB Interface to KmiTrRegfile
 
wire WrenREFCLK;
// REFCLK Write Enable from APB Interface to KmiTrRegfile
 
wire WrenRG;
// RG Write Enable from APB Interface to KmiTrRegfile
 
wire WrenCLKDIV;
// CLKDIV Write Enable from APB Interface to KmiTrRegfile
 
wire WrenTIMOUT;
// TIMOUT Write Enable from APB Interface to KmiTrRegfile
 
wire WrenMODEREG;
// MODEREG Write Enable from APB Interface to KmiTrRegfile
 
wire WrenTIMESTAT;
// TIMESTAT Write Enable 
 
wire DataAvl;
// Rx Fifo Write Enable from Receiver Block
 
wire RdUpdateRx;
// Rx Fifo Read from APB Interface 
 
wire RdUpdateTx;
// Tx Fifo Read from Transmitter Block
 
wire [15:0] PWDataIn;
// Gated Write Data Bus
 
wire [7:0] RXDATAIN;
// Received Data
 
wire KmiTrRXFF;
// Receive Fifo Full flag
 
wire KmiTrRXFE;
// Receive Fifo empty flag

wire KmiTrRXFH;
// Receive Fifo more then Half Full flag
 
wire KmiTrTXFF;
// Transmit Fifo Full flag
 
wire KmiTrTXFE;
// Transmit Fifo empty flag
 
wire KmiTrTXFH;
// Transmit Fifo Less then Half Full flag
 
wire [7:0]  KmiTrRXREG;
// Receive Data Register 
 
wire [7:0]  KmiTrTXREG;
// Transmit Data Register
 
wire [4:0]  KmiTrCnREG;
// Control Register
 
wire [8:0]  KmiTrCLKL;
// Clock Low Value Register
 
wire [8:0]  KmiTrCLKH;
// Clock High Value Register
 
wire [15:0] KmiTrDSI;
// DSI Timing Register
 
wire [15:0] KmiTrDHI;
// DHI Timing Register
 
wire [15:0] KmiTrDSO;
// DSO Timing Register
 
wire [15:0] KmiTrDHO;
// DHO Timing Register
 
wire [7:0]  KmiTrREFCLK;
// REFCLK Period
 
wire [15:0] KmiTrRG;
// RG Timing Register
 
wire [7:0]  KmiTrCLKDIV;
// Clock Divisor for Pulse8MHz
 
wire [4:0]  KmiTrTIMOUT;
// Time Out Value Register
 
wire [3:0]  KmiTrMODEREG;
// Mode Register
 
wire KmiTrDWIDTHERR;
// Data Width Error Signal
 
wire KmiTrFRAMEERR;
// Framing Error Signal
 
wire KmiTrPARITYERR;
// Parity Error Signal
 
wire KmiTrDSOErr;
// DSO Timing Error Signal
 
wire KmiTrDHOErr;
// DHO Timing Error Signal
 
wire KCLK;
// Internal KCLK
 
wire CounterEn;
// Counter Enable for Clock

wire [3:0]  BitCount;
// Number of Bits being transmitted/received.
 
wire iKMIRST;
// Internal Copy of KMI Reset
 
wire RTS;
// Request to send signal
 
wire [1:0]  CurrentState;
// Current State of TrickBox Controller
 
wire Pulse8MHz;
// 8 MHz signal 
 
wire iREFCLK;
// Internal copy of REFCLK
 
wire KmiTrREFCLKOn;
// Internal Copy of KCLKOut
  
wire KmiTrPCLKOn;
// Internal Copy of KDATAOut

wire iKMICLKOUT;
// Internal Copy of KCLKOut
  
wire iKDATAOUT;
// Internal Copy of KDATAOut

wire WriteRxFF;
// Synchronized Rx Fifo Write
 
wire ReadTxFF;
// Synchronized Tx Fifo Read
 
wire KmiTrTXBUSY;
// Transmit Busy Signal
 
wire KmiTrRXBUSY;
// Receive Busy Signal

// ----------------------------------------------------------------------------
// Register declarations
// ----------------------------------------------------------------------------
reg FeedBackTx;
// Feedback signal to Transmitter Block for sunchronization
 
reg FeedBackRx;
// Feedback signal to Receiver block for sunchronization

reg iFeedBackRx;
// Internal Copy of FeedBackRx

reg iFeedBackTx;
// Internal Copy of FeedBackTx

// ---------------------------------------------------------------------------
//
//   Main body of code
//   =================
//
// ---------------------------------------------------------------------------

assign KMIREFCLK   = iREFCLK;
assign KCLKOUT     = iKMICLKOUT;
assign KDATAOUT    = iKDATAOUT;
assign nKMIRST     = iKMIRST;
assign SCANMODE    = KmiTrCnREG[4];

assign KmiTrTXBUSY = (CurrentState == 2'b10) ? 1'b1 : 1'b0; 
             
assign KmiTrRXBUSY = (CurrentState == 2'b01) ? 1'b1 : 1'b0;

assign WriteRxFF   =  ~(iFeedBackRx) & DataAvl;
assign ReadTxFF    =  ~(iFeedBackTx) & RdUpdateTx;

// ----------------------------------------------------------------------------
// iFeedBack signal generation for Receiver Fifo Write synchronization
// ----------------------------------------------------------------------------
always @(posedge PCLK or BnRES)
begin : p_iFeedBackRxSeq
  if (BnRES == 1'b0) 
    iFeedBackRx <= 1'b0;
  else 
    iFeedBackRx <= DataAvl;
end  // p_iFeedBackRxSeq

// ----------------------------------------------------------------------------
// FeedBack signal generation for Receiver Fifo Write synchronization
// ----------------------------------------------------------------------------
always @(posedge iREFCLK or BnRES)
begin : p_FeedBackRxSeq 
  if (BnRES == 1'b0)
    FeedBackRx <= 1'b0;
  else 
    FeedBackRx <= iFeedBackRx;
end  // p_FeedBackRxSeq

// ----------------------------------------------------------------------------
// iFeedBack signal generation for Transmit Fifo Read synchronization
// ----------------------------------------------------------------------------
always @(posedge PCLK or BnRES)
begin : p_iFeedBackTxSeq 
  if (BnRES == 1'b0) 
    iFeedBackTx <= 1'b0;
  else
    iFeedBackTx <= RdUpdateTx;
end  // p_iFeedBackTxSeq
 
// ----------------------------------------------------------------------------
// FeedBack signal generation for Transmit Fifo Read synchronization
// ----------------------------------------------------------------------------
always @(posedge iREFCLK or BnRES)
begin : p_FeedBackTxSeq  
  if (BnRES == 1'b0) 
    FeedBackTx <= 1'b0;
  else
    FeedBackTx <= iFeedBackTx;
end  // p_FeedBackTxSeq
  
// ----------------------------------------------------------------------------
// Component Instantiations
// ----------------------------------------------------------------------------
KmiTrApbif uKmiTrApbif 
         (
          .PCLK           (PCLK),       
          .BnRES          (BnRES),       
          .PADDR          (PADDR),         
          .PWDATA         (PWDATA),      
          .PRDATA         (PRDATA),     
          .PENABLE        (PENABLE),    
          .PWRITE         (PWRITE),     
          .PSEL           (PSELT),        
          .KmiTrRXREG     (KmiTrRXREG),    
          .KmiTrCnREG     (KmiTrCnREG), 
          .KmiTrREFCLKOn  (KmiTrREFCLKOn),
          .KmiTrPCLKOn    (KmiTrPCLKOn),  
          .KmiTrDWIDTHERR (KmiTrDWIDTHERR),  
          .KmiTrTXBUSY    (KmiTrTXBUSY),  
          .KmiTrRXBUSY    (KmiTrRXBUSY),  
          .KmiTrFRAMEERR  (KmiTrFRAMEERR),  
          .KmiTrPARITYERR (KmiTrPARITYERR), 
          .KmiTrCLKL      (KmiTrCLKL),    
          .KmiTrCLKH      (KmiTrCLKL),    
          .KmiTrDSI       (KmiTrDSI), 
          .KmiTrDHI       (KmiTrDHI),     
          .KmiTrDSO       (KmiTrDSO),    
          .KmiTrDHO       (KmiTrDHO),   
          .KmiTrREFCLK    (KmiTrREFCLK),   
          .KmiTrRG        (KmiTrRG),      
          .KmiTrRXFF      (KmiTrRXFF),    
          .KmiTrRXFE      (KmiTrRXFE),    
          .KmiTrRXFH      (KmiTrRXFH),    
          .KmiTrTXFF      (KmiTrTXFF),    
          .KmiTrTXFE      (KmiTrTXFE),    
          .KmiTrTXFH      (KmiTrTXFH),     
          .KmiINTR        (KMIINTR),    
          .KmiRXINTR      (KMIRXINTR),  
          .KmiTXINTR      (KMITXINTR), 
          .KDATAIN        (KDATAIN),    
          .KCLKIN         (KCLKIN),     
          .KmiTrTIMOUT    (KmiTrTIMOUT),   
          .KmiTrCLKDIV    (KmiTrCLKDIV),   
          .KmiTrMODEREG   (KmiTrMODEREG), 
          .KmiTrDSOErr    (KmiTrDSOErr), 
          .KmiTrDHOErr    (KmiTrDHOErr),  
          .WrenTXREG      (WrenTXREG),   
          .WrenCnREG      (WrenCnREG),  
          .WrenSTAT       (WrenSTAT),    
          .WrenCLKL       (WrenCLKL),    
          .WrenCLKH       (WrenCLKH),    
          .WrenDSI        (WrenDSI),     
          .WrenDHI        (WrenDHI),     
          .WrenDSO        (WrenDSO),     
          .WrenDHO        (WrenDHO),     
          .WrenREFCLK     (WrenREFCLK),  
          .WrenRG         (WrenRG),      
          .WrenCLKDIV     (WrenCLKDIV),  
          .WrenTIMOUT     (WrenTIMOUT),  
          .WrenMODEREG    (WrenMODEREG), 
          .WrenTIMESTAT   (WrenTIMESTAT),
          .RdUpdateRx     (RdUpdateRx),  
          .PWDataIn       (PWDataIn)   
         );

KmiTrBitCounter uKmiTrBitCounter 
         (
          .BnRES    (BnRES),       
          .KCLK     (KCLK),        
          .CounterEn(CounterEn),   
          .BitCount (BitCount)   
         );

KmiTrController uKmiTrController 
         (
          .REFCLK      (iREFCLK),       
          .BnRES       (BnRES),       
          .nKMIRST     (iKMIRST),       
          .BitCount    (BitCount),     
          .KmiTrTXFE   (KmiTrTXFE),      
          .KmiTrTIMOUT (KmiTrTIMOUT),     
          .KmiTrCnREG  (KmiTrCnREG),     
          .KDATAIn     (KDATAIN),      
          .KCLKIn      (KCLKIN),       
          .KDATAOut    (iKDATAOUT),    
          .KCLKOut     (iKMICLKOUT),     
          .KCLK        (KCLK),     
          .EnableOut   (CounterEn),
          .RTS         (RTS),        
          .CurrentState(CurrentState) 
         );

KmiTrDataWidth uKmiTrDataWidth
         (
          .BnRES          (BnRES),        
          .KmiTrCLKL      (KmiTrCLKL),       
          .KmiTrCLKH      (KmiTrCLKH),      
          .REFCLK         (iREFCLK),      
          .Pulse8MHz      (Pulse8MHz),    
          .WrenSTAT       (WrenSTAT),     
          .KDATAIn        (KDATAIN),     
          .KDATAOut       (iKDATAOUT),     
          .WidthMsrEn     (KmiTrCnREG[2]),   
          .KCLKOut        (iKMICLKOUT),      
          .WrenTIMESTAT   (WrenTIMESTAT), 
          .PWDataIn       (PWDataIn),
          .KmiTrDSO       (KmiTrDSO),       
          .KmiTrDHO       (KmiTrDHO), 
          .BitCount       (BitCount),     
          .CurrentState   (CurrentState), 
          .TdsoErr        (KmiTrDSOErr),     
          .TdhoErr        (KmiTrDHOErr),     
          .KmiTrDWIDTHERR (KmiTrDWIDTHERR)   
         );

KmiTrKCLKGen uKmiTrKCLKGen
         (
          .BnRES       (BnRES),     
          .KmiTrCLKL   (KmiTrCLKL),    
          .KmiTrCLKH   (KmiTrCLKH),   
          .REFCLK      (iREFCLK),  
          .Pulse8MHz   (Pulse8MHz), 
          .CLKEn       (CounterEn), 
          .CurrentState(CurrentState),   
          .KCLK        (KCLK)     
         );
 
KmiTrOutDrive uKmiTrOutDrive
         (
          .REFCLK        (iREFCLK),       
          .BnRES         (BnRES),        
          .BitCount      (BitCount),     
          .FParErr       (KmiTrCnREG[1]),      
          .KCLK          (KCLK),         
          .KmiTrTXREG    (KmiTrTXREG),     
          .CurrentState  (CurrentState),
          .KmiTrDSI      (KmiTrDSI),        
          .KmiTrRG       (KmiTrRG),         
          .KDATAIn       (KDATAIN),     
          .RTS           (RTS),        
          .WrenSTAT      (WrenSTAT),
          .PWDataIn      (PWDataIn), 
          .LegacyBit     (KmiTrCnREG[3]),    
          .FeedBackRx    (FeedBackRx),
          .FeedBackTx    (FeedBackTx), 
          .KmiTrRXREG    (RXDATAIN),      
          .KmiTrPARITYERR(KmiTrPARITYERR),    
          .KmiTrFRAMEERR (KmiTrFRAMEERR),    
          .DataAvl       (DataAvl),     
          .RdUpdateTx    (RdUpdateTx),    
          .KCLKOut       (iKMICLKOUT),     
          .KDATAOut      (iKDATAOUT),     
          .EnableOut     (CounterEn)    
         );
  
KmiTrPulseGen uKmiTrPulseGen
         (
          .BnRES       (BnRES),      
          .PCLK        (PCLK),      
          .KmiTrREFCLK (KmiTrREFCLK),   
          .KmiTrCLKDIV (KmiTrCLKDIV),   
          .KmiTrMODEREG(KmiTrMODEREG),  
          .WrenMREG    (WrenMODEREG),   
          .Pulse8MHz   (Pulse8MHz),  
          .REFCLK      (iREFCLK),    
          .nKMIRST     (iKMIRST),
          .REFCLKOn    (KmiTrREFCLKOn),
          .PCLKOn      (KmiTrPCLKOn)
         );

KmiTrRegFile uKmiTrRegFile
         (
          .WrenTXREG    (WrenTXREG),
          .WrenCnREG    (WrenCnREG),
          .WrenCLKL     (WrenCLKL), 
          .WrenCLKH     (WrenCLKH),   
          .WrenDSI      (WrenDSI),    
          .WrenDHI      (WrenDHI),    
          .WrenDSO      (WrenDSO),    
          .WrenDHO      (WrenDHO),    
          .WrenREFCLK   (WrenREFCLK), 
          .WrenRG       (WrenRG),     
          .WrenCLKDIV   (WrenCLKDIV), 
          .WrenTIMOUT   (WrenTIMOUT), 
          .WrenMODEREG  (WrenMODEREG),
          .DataAvl      (WriteRxFF),    
          .RdUpdateRx   (RdUpdateRx), 
          .RdUpdateTx   (ReadTxFF), 
          .PWDataIn     (PWDataIn),   
          .RXDATAIN     (RXDATAIN),   
          .PCLK         (PCLK),       
          .BnRES        (BnRES),      
          .KmiTrRXFF    (KmiTrRXFF),     
          .KmiTrRXFE    (KmiTrRXFE),     
          .KmiTrRXFH    (KmiTrRXFH),     
          .KmiTrTXFF    (KmiTrTXFF),     
          .KmiTrTXFE    (KmiTrTXFE),     
          .KmiTrTXFH    (KmiTrTXFH),     
          .KmiTrRXREG   (KmiTrRXREG),    
          .KmiTrTXREG   (KmiTrTXREG),    
          .KmiTrCnREG   (KmiTrCnREG),    
          .KmiTrCLKL    (KmiTrCLKL),     
          .KmiTrCLKH    (KmiTrCLKH),     
          .KmiTrDSI     (KmiTrDSI),      
          .KmiTrDHI     (KmiTrDHI),      
          .KmiTrDSO     (KmiTrDSO),      
          .KmiTrDHO     (KmiTrDHO),      
          .KmiTrREFCLK  (KmiTrREFCLK),   
          .KmiTrRG      (KmiTrRG),       
          .KmiTrCLKDIV  (KmiTrCLKDIV),   
          .KmiTrTIMOUT  (KmiTrTIMOUT),   
          .KmiTrMODEREG (KmiTrMODEREG)  
         );
   
KmiTrTimer uKmiTrTimer
         (
          .REFCLK   (iREFCLK),     
          .BnRES    (BnRES),      
          .Pulse8MHz(Pulse8MHz),  
          .nKMIRST  (iKMIRST),      
          .KDATAIn  (KDATAIN),    
          .KCLKIn   (KCLKIN),     
          .KDATAOut (iKDATAOUT),   
          .KCLKOut  (iKMICLKOUT),    
          .RTS      (RTS)       
         );
   
endmodule

// ======================== End of KmiTrick =================================--
