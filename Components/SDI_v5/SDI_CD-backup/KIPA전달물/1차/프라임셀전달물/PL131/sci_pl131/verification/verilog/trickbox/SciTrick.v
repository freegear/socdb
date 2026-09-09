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
//  File Name              : SciTrick.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Purpose  : This module is the top level SCI trickbox
//------------------------------------------------------------------------------

`timescale 1ns/1ps

//------------------------------------------------------------------------------

module SciTrick 
       (
        // APB bus signals
        PCLK,
        PRESETn,
        PENABLE,
        PSELT,
        PWRITE,
        PADDR,
        PWDATA,
        PRDATA,

        // Reference clock for the Sci
        SCICLK,

        // Reset and Funtion Code Bit signal to Sci  
        nSCIRST,
        SCIFCB,
      
        // Card Detect signal to SCI
        SCIDETECT,
      
        // Card control signals 
        SCIVCCEN,
        nSCICARDRST,

        // Sci Data Signals 
        SCICLKOUT,            
        SCICLKIN,
        SCIDATAOUT, 
        SCIDATAIN, 
 
        // SCI Interrupt signals 
        SCICARDININTR,
        SCICARDOUTINTR,
        SCICARDUPINTR,
        SCICARDDNINTR,
        SCITXERRINTR,
        SCIATRSTOUTINTR,
        SCIATRDTOUTINTR,
        SCIBLKTOUTINTR,
        SCICHTOUTINTR,
        SCITXTIDEINTR,
        SCIRXTIDEINTR,
        SCIRTOUTINTR,
        SCIRORINTR,
        SCICLKSTPINTR,
        SCICLKACTINTR,
        SCIINTR,
    
        // PMU signals
        SCIDEACACK, 
        SCIDEACREQ,

        // DMA Interface signals
        SCITXDMASREQ,
        SCITXDMABREQ,
        SCIRXDMASREQ,
        SCIRXDMABREQ,
        SCITXDMACLR,
        SCIRXDMACLR
       );

// APB bus signals
input        PCLK;
input        PRESETn;
input        PENABLE;
input        PSELT;
input        PWRITE;
input        [7:2]PADDR;
input        [15:0]PWDATA;
output       [15:0]PRDATA;
// Reference clock for the Sci
output       SCICLK;
// Reset signal to Sci  
output       nSCIRST;
// Card Detect signal to SCI
output       SCIDETECT;
// Card control signals 
input        SCIVCCEN;
input        nSCICARDRST;
input        SCIFCB;
// Sci Data Signals 
output       SCICLKOUT;            
input        SCICLKIN;
output       SCIDATAOUT; 
input        SCIDATAIN; 
// SCI Interrupt signals 
input        SCICARDININTR;
input        SCICARDOUTINTR;
input        SCICARDUPINTR;
input        SCICARDDNINTR;
input        SCITXERRINTR;
input        SCIATRSTOUTINTR;
input        SCIATRDTOUTINTR;
input        SCIBLKTOUTINTR;
input        SCICHTOUTINTR;
input        SCITXTIDEINTR;
input        SCIRXTIDEINTR;
input        SCIRTOUTINTR;
input        SCIRORINTR;
input        SCICLKSTPINTR;
input        SCICLKACTINTR;
input        SCIINTR;
// PMU signals
input        SCIDEACACK; 
output       SCIDEACREQ;

// DMA Interface signals
input        SCITXDMASREQ; // Transmit DMA single request
input        SCITXDMABREQ; // Transmit DMA burst  request
input        SCIRXDMASREQ; // Receive  DMA single request
input        SCIRXDMABREQ; // Receive  DMA burst  request
output       SCITXDMACLR;  // Transmit DMA request clear
output       SCIRXDMACLR;  // Receive DMA request clear


// -----------------------------------------------------------------------------
//
//                                  SspTrick
//                                  ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module instantiates the following sub-modules:
//
// 1.  SciTrApbif       - APB Interface
// 2.  SciTrRxFIFO      - Receive FIFO
// 3.  SciTrTxFIFO      - Transmit FIFO 
// 4.  SciTrREFCLKGen   - Clock generation module
// 5.  SciTrMux         - Output mux
// 6.  SciTrTimCheck    - Time checker
// 7.  SciTrSynctoRFCLK - Synchronisers for signals crossing into RFCLK domain
// 8.  SciTrSynctoPCLK  - Synchronisers for signals crossing into PCLK domain
// 9.  SciTrRegBlk      - Register block
// 10. SciTrRegBlkUpd   - Register update block
// 11. SciTrTXCntl      - Transmiter
// 12. SciTrRXCntl      - Receiver 
// 13. SciTrDMA         - DMA Tx and Rx clear signal generation

// -----------------------------------------------------------------------------
wire  StartBitError;
wire  iSCICLK;	
wire  TXSCIDATAIN;	
wire  RXSCIDATAIN;	
wire  TXSCIDATAOUT;	
wire  RXSCIDATAOUT;	
wire  SCITrDATAWrEn;	
wire  SCITrCRWrEn;	
wire  SCITrFiLCRWrEn;	
wire  SCITrTXPCWrEn;	
wire  SCITrRXPCWrEn;	
wire  SCITrCTRLWrEn;	
wire  SCITrATWrEn;	
wire  SCITrDTWrEn;	
wire  SCITrTXBLKGWrEn;	
wire  SCITrTXCHGWrEn;	
wire  SCITrCKICCWrEn;	
wire  SCITrBAUDWrEn;	
wire  SCITrVALUEWrEn;	
wire  SCITrRXCHGWrEn;	
wire  SCITrRXBLKGWrEn;	
wire  SCITrRFCKWrEn;	
wire  SCITrWVWrEn;	
wire  SCITrJitWrEn;	
wire  SCITrJitPatWrEn;	
wire  SCITrRFCNTLWrEn;
wire  [15:0] PWDATAIn;	
wire  [15:0] SCITrCR;	
wire  [7:0] SCITrFiLCR;	
wire  [3:0] SCITrTXPC;	
wire  [3:0] SCITrRXPC;	
wire  [7:0] SCITrCTRL;	
wire  [15:0] SCITrAT;	
wire  [15:0] SCITrDT;	
wire  [7:0] SCITrTXBLKG;	
wire  [7:0] SCITrTXCHG;	
wire  [15:0] SCITrCKICC;	
wire  [15:0] SCITrBAUD;	
wire  [7:0] SCITrVALUE;	
wire  [7:0] SCITrRXCHG;	
wire  [7:0] SCITrRXBLKG;	
wire  [15:0] SCITrRFCK;	
wire  [7:0] SCITrWV;	
wire  [15:0] SCITrJit;	
wire  [9:0] SCITrJitPat;	
wire  [2:0] SCITrRFCNTL;
wire  PCLKOn;
wire  REFCLKOn;
wire  TrCRUpdate;	
wire  TrTXPCUpdate;
wire  TrRXPCUpdate;
wire  TrCTRLUpdate;	
wire  TrATUpdate;	
wire  TrDTUpdate;	
wire  TrTXBGUpdate;	
wire  TrTXCGUpdate;	
wire  TrCKICUpdate;	
wire  TrBAUDUpdate;	
wire  TrVALUpdate;	
wire  TrRXCGUpdate;	
wire  TrRXBGUpdate;	
wire  TrRFCKUpdate;	
wire  TrWVUpdate;	
wire  TrJitUpdate;	
wire  TrJitPUpdate;	
wire  TrCRUpdSync;
wire  TrTXPCUpdSync;
wire  TrRXPCUpdSync;
wire  TrCTRLUpdSync;
wire  TrATUpdSync;
wire  TrDTUpdSync;
wire  TrTXBLKGUpdSync;
wire  TrTXCHGUpdSync;
wire  TrCKICCUpdSync;
wire  TrBAUDUpdSync;
wire  TrVALUEUpdSync;
wire  TrRXCHGUpdSync;
wire  TrRXBLKGUpdSync;
wire  TrJitUpdSync;
wire  TrJitPatUpdSync;
wire  TxFRdPtrIncSync; 
wire  TxFRdPtrInc; 
wire  SCITrTFR; 
wire  SCITrTFF; 
wire  SCITrTFE; 
wire  [7:0] TxFRdData; 
wire  RxFWrSync; 
wire  RxFWr; 
wire  RxFRdPtrInc; 
wire  [8:0] RxFWrData; 
wire  SCITrRFR ; 
wire  SCITrRFE; 
wire  SCITrRFF; 
wire  [8:0] RxFRdData; 
wire  SCICLKErEn;
wire  TXPtimErEn;
wire  TXPErEn;
wire  TXPtimWdErEn;
wire  RXPErEn;
wire  RXCtimErEn;
wire  RXBtimErEn;
wire  StartBitErEn;
wire  TrBoxEn;
wire  TrTXEn;
wire  TrRXEn;
wire  TrDebugEn;
wire  TrTXPEn;
wire  TrRXPEn;
wire  TrTXPStEn;
wire  TrRXPStEn;
wire  TrTXNAKEn;
wire  TrRXNAKEn;
wire  TrSCIREQ;
wire  TrDackREn;
wire  TrSENSE;
wire  TrSCICLKEn;
wire  TxDataAvlblSync; 	
wire  TxDataAvlbl; 	
wire  [3:0] TrRSyTXPC;
wire  [3:0] TrRSyRXPC;
wire  [15:0] TrRSyAT;
wire  [15:0] TrRSyDT;
wire  [7:0] TrTXRSyBLKG;
wire  [7:0] TrTXRSyCHG;
wire  [15:0] TrRSyCKICC;
wire  [15:0] TrRSyBaud;
wire  [7:0] TrRSyValue;
wire  [7:0] TrRXRSyCHG;
wire  [7:0] TrRXRSyBLKG;
wire  [15:0] TrRSyJit;
wire  [9:0] TrRSyJitPat;
wire  TXPtimError;
wire  TXPtimWdError;
wire  TXPError;
wire  RXPError;
wire  RXCtimError;
wire  RXBtimError;
wire  SCITrDMAWr;
wire  [1:0] SCITDMACR;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign SCICLK = iSCICLK;

SciTrApbif uSciTrApbif 
         ( 
          .PCLK              (PCLK), 
          .PRESETn           (PRESETn), 
          .PSELT             (PSELT), 
          .PENABLE           (PENABLE), 
          .PWRITE            (PWRITE), 
          .PADDR             (PADDR), 
          .PWDATA            (PWDATA), 
          .RxFRdData         (RxFRdData), 
          .SCITrCR           (SCITrCR), 
          .SCITrFiLCR        (SCITrFiLCR), 
          .SCITrCTRL         (SCITrCTRL), 
          .SCITrTXPC         (SCITrTXPC), 
          .SCITrRXPC         (SCITrRXPC), 
          .SCITrTFF          (SCITrTFF), 
          .SCITrTFE          (SCITrTFE), 
          .SCITrTFR          (SCITrTFR), 
          .SCITrRFF          (SCITrRFF), 
          .SCITrRFE          (SCITrRFE), 
          .SCITrRFR          (SCITrRFR), 
          .SCITrAT           (SCITrAT), 
          .SCITrDT           (SCITrDT), 
          .SCITrTXBLKG       (SCITrTXBLKG), 
          .SCITrTXCHG        (SCITrTXCHG), 
          .SCITrCKICC        (SCITrCKICC), 
          .SCITrBAUD         (SCITrBAUD), 
          .SCITrVALUE        (SCITrVALUE), 
          .SCITrRXCHG        (SCITrRXCHG), 
          .SCITrRXBLKG       (SCITrRXBLKG), 
          .SCITrRFCK         (SCITrRFCK), 
          .SCITrWV           (SCITrWV), 
          .SCITrJit          (SCITrJit), 
          .SCITrJitPat       (SCITrJitPat), 
          .PCLKOn            (PCLKOn), 
          .REFCLKOn          (REFCLKOn),
          .SCICARDININTR     (SCICARDININTR), 
          .SCICARDOUTINTR    (SCICARDOUTINTR), 
          .SCICARDUPINTR     (SCICARDUPINTR), 
          .SCICARDDNINTR     (SCICARDDNINTR), 
          .SCITXERRINTR      (SCITXERRINTR), 
          .SCIATRSTOUTINTR   (SCIATRSTOUTINTR), 
          .SCIATRDTOUTINTR   (SCIATRDTOUTINTR), 
          .SCIBLKTOUTINTR    (SCIBLKTOUTINTR), 
          .SCICHTOUTINTR     (SCICHTOUTINTR), 
          .SCITXTIDEINTR     (SCITXTIDEINTR), 
          .SCIRXTIDEINTR     (SCIRXTIDEINTR), 
          .SCIRTOUTINTR      (SCIRTOUTINTR), 
          .SCIRORINTR        (SCIRORINTR),
          .SCICLKSTPINTR     (SCICLKSTPINTR),
          .SCICLKACTINTR     (SCICLKACTINTR),
          .SCIINTR           (SCIINTR), 
          .SCIDEACACK        (SCIDEACACK),
          .SCITrDATAWrEn     (SCITrDATAWrEn), 
          .SCITrCRWrEn       (SCITrCRWrEn), 
          .SCITrFiLCRWrEn    (SCITrFiLCRWrEn), 
          .SCITrTXPCWrEn     (SCITrTXPCWrEn), 
          .SCITrRXPCWrEn     (SCITrRXPCWrEn), 
          .SCITrCTRLWrEn     (SCITrCTRLWrEn), 
          .SCITrATWrEn       (SCITrATWrEn), 
          .SCITrDTWrEn       (SCITrDTWrEn), 
          .SCITrTXBLKGWrEn   (SCITrTXBLKGWrEn), 
          .SCITrTXCHGWrEn    (SCITrTXCHGWrEn), 
          .SCITrCKICCWrEn    (SCITrCKICCWrEn), 
          .SCITrBAUDWrEn     (SCITrBAUDWrEn), 
          .SCITrVALUEWrEn    (SCITrVALUEWrEn), 
          .SCITrRXCHGWrEn    (SCITrRXCHGWrEn), 
          .SCITrRXBLKGWrEn   (SCITrRXBLKGWrEn), 
          .SCITrRFCKWrEn     (SCITrRFCKWrEn), 
          .SCITrWVWrEn       (SCITrWVWrEn), 
          .SCITrJitWrEn      (SCITrJitWrEn), 
          .SCITrJitPatWrEn   (SCITrJitPatWrEn), 
          .SCITrRFCNTLWrEn   (SCITrRFCNTLWrEn), 
          .RxFRdPtrInc       (RxFRdPtrInc), 
          .PWDATAIn          (PWDATAIn), 
          .PRDATA            (PRDATA),
          .SCITXDMASREQ      (SCITXDMASREQ),
          .SCITXDMABREQ      (SCITXDMABREQ),
          .SCIRXDMASREQ      (SCIRXDMASREQ),
          .SCIRXDMABREQ      (SCIRXDMABREQ),
          .SCITrDMAWr        (SCITrDMAWr)
        );

SciTrRegBlk uSciTrRegBlk 
         (
          .PCLK              (PCLK),           
          .PRESETn           (PRESETn),           
          .SCITrCRWrEn       (SCITrCRWrEn),    
          .SCITrFiLCRWrEn    (SCITrFiLCRWrEn), 
          .SCITrTXPCWrEn     (SCITrTXPCWrEn),  
          .SCITrRXPCWrEn     (SCITrRXPCWrEn),  
          .SCITrCTRLWrEn     (SCITrCTRLWrEn),  
          .SCITrATWrEn       (SCITrATWrEn),    
          .SCITrDTWrEn       (SCITrDTWrEn),    
          .SCITrTXBLKGWrEn   (SCITrTXBLKGWrEn),  
          .SCITrTXCHGWrEn    (SCITrTXCHGWrEn),   
          .SCITrCKICCWrEn    (SCITrCKICCWrEn), 
          .SCITrBAUDWrEn     (SCITrBAUDWrEn), 
          .SCITrVALUEWrEn    (SCITrVALUEWrEn), 
          .SCITrRXCHGWrEn    (SCITrRXCHGWrEn),   
          .SCITrRXBLKGWrEn   (SCITrRXBLKGWrEn),  
          .SCITrRFCKWrEn     (SCITrRFCKWrEn),  
          .SCITrWVWrEn       (SCITrWVWrEn),  
          .SCITrJitWrEn      (SCITrJitWrEn),  
          .SCITrJitPatWrEn   (SCITrJitPatWrEn),  
          .SCITrRFCNTLWrEn   (SCITrRFCNTLWrEn),  
          .SCITrDMAWr        (SCITrDMAWr),
          .SCITXDMACLRStag2  (SCITXDMACLRStag2),
          .SCIRXDMACLRStag2  (SCIRXDMACLRStag2),
          .PWDATAIn          (PWDATAIn),       

          .SCITrCR           (SCITrCR),        
          .SCITrFiLCR        (SCITrFiLCR),     
          .SCITrTXPC         (SCITrTXPC),      
          .SCITrRXPC         (SCITrRXPC),      
          .SCITrCTRL         (SCITrCTRL),      
          .SCITrAT           (SCITrAT),        
          .SCITrDT           (SCITrDT),        
          .SCITrTXBLKG       (SCITrTXBLKG),      
          .SCITrTXCHG        (SCITrTXCHG),       
          .SCITrCKICC        (SCITrCKICC),     
          .SCITrBAUD         (SCITrBAUD),      
          .SCITrVALUE        (SCITrVALUE),     
          .SCITrRXCHG        (SCITrRXCHG),       
          .SCITrRFCK         (SCITrRFCK),      
          .SCITrRXBLKG       (SCITrRXBLKG),      
          .SCITrWV           (SCITrWV),      
          .SCITrJit          (SCITrJit),      
          .SCITrJitPat       (SCITrJitPat),      
          .SCITrRFCNTL       (SCITrRFCNTL),      
          .TrCRUpdate        (TrCRUpdate),     
          .TrTXPCUpdate      (TrTXPCUpdate),   
          .TrRXPCUpdate      (TrRXPCUpdate),   
          .TrCTRLUpdate      (TrCTRLUpdate),   
          .TrATUpdate        (TrATUpdate),     
          .TrDTUpdate        (TrDTUpdate),     
          .TrTXBGUpdate      (TrTXBGUpdate),   
          .TrTXCGUpdate      (TrTXCGUpdate),    
          .TrCKICUpdate      (TrCKICUpdate),  
          .TrBAUDUpdate      (TrBAUDUpdate),   
          .TrVALUpdate       (TrVALUpdate), 
          .TrRXCGUpdate      (TrRXCGUpdate),    
          .TrRFCKUpdate      (TrRFCKUpdate),
          .TrWVUpdate        (TrWVUpdate), 
          .TrRXBGUpdate      (TrRXBGUpdate),   
          .TrJitUpdate       (TrJitUpdate),   
          .TrJitPUpdate      (TrJitPUpdate),  
          .SCITDMACR         (SCITDMACR)
         );

SciTrRegBlkUpd uSciTrRegBlkUpd 
 (
          .SCICLK           (iSCICLK), 
          .PRESETn           (PRESETn), 
          .TrCRUpdSync       (TrCRUpdSync), 
          .TrTXPCUpdSync     (TrTXPCUpdSync), 
          .TrRXPCUpdSync     (TrRXPCUpdSync), 
          .TrCTRLUpdSync     (TrCTRLUpdSync), 
          .TrATUpdSync       (TrATUpdSync), 
          .TrDTUpdSync       (TrDTUpdSync), 
          .TrTXBLKGUpdSync   (TrTXBLKGUpdSync), 
          .TrTXCHGUpdSync    (TrTXCHGUpdSync), 
          .TrCKICCUpdSync    (TrCKICCUpdSync), 
          .TrBAUDUpdSync     (TrBAUDUpdSync), 
          .TrVALUEUpdSync    (TrVALUEUpdSync), 
          .TrRXCHGUpdSync    (TrRXCHGUpdSync), 
          .TrRXBLKGUpdSync   (TrRXBLKGUpdSync), 
          .TrJitUpdSync      (TrJitUpdSync), 
          .TrJitPatUpdSync   (TrJitPatUpdSync), 
          .SCITrCR           (SCITrCR), 
          .SCITrTXPC         (SCITrTXPC), 
          .SCITrRXPC         (SCITrRXPC), 
          .SCITrCTRL         (SCITrCTRL), 
          .SCITrAT           (SCITrAT), 
          .SCITrDT           (SCITrDT), 
          .SCITrTXBLKG       (SCITrTXBLKG), 
          .SCITrTXCHG        (SCITrTXCHG), 
          .SCITrCKICC        (SCITrCKICC), 
          .SCITrBAUD         (SCITrBAUD), 
          .SCITrVALUE        (SCITrVALUE), 
          .SCITrRXCHG        (SCITrRXCHG), 
          .SCITrRXBLKG       (SCITrRXBLKG), 
          .SCITrJit          (SCITrJit), 
          .SCITrJitPat       (SCITrJitPat), 
          .SCICLKErEn        (SCICLKErEn),
          .TXPtimErEn        (TXPtimErEn),
          .TXPErEn           (TXPErEn),
          .TXPtimWdErEn      (TXPtimWdErEn),
          .RXPErEn           (RXPErEn),
          .RXCtimErEn        (RXCtimErEn),
          .RXBtimErEn        (RXBtimErEn),
          .StartBitErEn      (StartBitErEn),
          .TrBoxEn           (TrBoxEn),   
          .TrTXEn            (TrTXEn),    
          .TrRXEn            (TrRXEn),    
          .TrDebugEn         (TrDebugEn), 
          .TrCDETEn          (SCIDETECT),  
          .TrTXPEn           (TrTXPEn),   
          .TrRXPEn           (TrRXPEn),   
          .TrTXPStEn         (TrTXPStEn),
          .TrRXPStEn         (TrRXPStEn),
          .TrTXNAKEn         (TrTXNAKEn),
          .TrRXNAKEn         (TrRXNAKEn),
          .SCIDEACREQ        (SCIDEACREQ),
          .TrDackREn         (TrDackREn), 
          .SCANMODE          (SCANMODE), 
          .nSCIRST           (nSCIRST), 
          .TrSENSE           (TrSENSE), 
          .TrSCICLKEn        (TrSCICLKEn), 
          .TrRSyTXPC         (TrRSyTXPC), 
          .TrRSyRXPC         (TrRSyRXPC), 
          .TrRSyAT           (TrRSyAT), 
          .TrRSyDT           (TrRSyDT), 
          .TrTXRSyBLKG       (TrTXRSyBLKG), 
          .TrTXRSyCHG        (TrTXRSyCHG), 
          .TrRSyCKICC        (TrRSyCKICC), 
          .TrRSyBAUD         (TrRSyBaud), 
          .TrRSyVALUE        (TrRSyValue), 
          .TrRXRSyCHG        (TrRXRSyCHG), 
          .TrRXRSyBLKG       (TrRXRSyBLKG), 
//    .TrRSyRFCK         (TrRSyRFCK), 
          .TrRSyJit          (TrRSyJit), 
          .TrRSyJitPat       (TrRSyJitPat) 
         );

SciTrSynctoRFCLK uSciTrSynctoRFCLK 
 (
          .SCICLK       (iSCICLK), 
          .PRESETn         (PRESETn), 
          .TxDataAvlblSync (TxDataAvlblSync),	
          .TxDataAvlbl     (TxDataAvlbl),	
          .TrCRUpdate      (TrCRUpdate), 
          .TrTXPCUpdate    (TrTXPCUpdate), 
          .TrRXPCUpdate    (TrRXPCUpdate), 
          .TrCTRLUpdate    (TrCTRLUpdate), 
          .TrATUpdate      (TrATUpdate), 
          .TrDTUpdate      (TrDTUpdate), 
          .TrTXBGUpdate    (TrTXBGUpdate), 
          .TrTXCGUpdate    (TrTXCGUpdate), 
          .TrCKICUpdate    (TrCKICUpdate), 
          .TrBAUDUpdate    (TrBAUDUpdate), 
          .TrVALUpdate     (TrVALUpdate), 
          .TrRXCGUpdate    (TrRXCGUpdate), 
          .TrRXBGUpdate    (TrRXBGUpdate), 
          .TrJitUpdate     (TrJitUpdate), 
          .TrJitPUpdate    (TrJitPUpdate), 
          .TrCRUpdSync     (TrCRUpdSync), 
          .TrTXPCUpdSync   (TrTXPCUpdSync), 
          .TrRXPCUpdSync   (TrRXPCUpdSync), 
          .TrCTRLUpdSync   (TrCTRLUpdSync), 
          .TrATUpdSync     (TrATUpdSync), 
          .TrDTUpdSync     (TrDTUpdSync), 
          .TrTXBLKGUpdSync (TrTXBLKGUpdSync), 
          .TrTXCHGUpdSync  (TrTXCHGUpdSync), 
          .TrCKICCUpdSync  (TrCKICCUpdSync), 
          .TrBAUDUpdSync   (TrBAUDUpdSync), 
          .TrVALUEUpdSync  (TrVALUEUpdSync), 
          .TrRXCHGUpdSync  (TrRXCHGUpdSync), 
          .TrRXBLKGUpdSync (TrRXBLKGUpdSync), 
          .TrJitUpdSync    (TrJitUpdSync), 
          .TrJitPatUpdSync (TrJitPatUpdSync) 
         );

SciTrSynctoPCLK uSciTrSynctoPCLK 
 (
          .TxFRdPtrInc     (TxFRdPtrInc), 
          .RxFWr           (RxFWr),
          .PCLK            (PCLK),
          .PRESETn         (PRESETn),
          .TxFRdPtrIncSync (TxFRdPtrIncSync),
          .RxFWrSync       ( RxFWrSync)
         );

SciTrTxFIFO uSciTrTxFIFO 
 (
          .PCLK	           (PCLK),	
          .PRESETn         (PRESETn),	
          .SCIDRWr         (SCITrDATAWrEn),	
          .TxFRdPtrIncSync (TxFRdPtrIncSync),	
          .PWDATAIn        (PWDATAIn[7:0]),
          .TxSRLevel       (SCITrFiLCR[3:0]),
          .SCITrTFR        (SCITrTFR),
          .TxDataAvlbl     (TxDataAvlbl),
          .SCITrTFF	   (SCITrTFF),	
          .SCITrTFE        (SCITrTFE),
          .TxFRdData	   (TxFRdData)	
         );


SciTrRxFIFO uSciTrRxFIFO 
 (
          .PCLK            (PCLK),	
          .PRESETn         (PRESETn),	
          .RxFWrSync       (RxFWrSync),
          .RxFRdPtrInc     (RxFRdPtrInc),	
          .RxSRLevel       (SCITrFiLCR[7:4]),
          .RxFWrData       (RxFWrData),
          .SCITrRFR        (SCITrRFR), 	
          .SCITrRFE	   (SCITrRFE),	
          .SCITrRFF 	   (SCITrRFF),	
          .RxFRdData       (RxFRdData)	
         );

SciTrREFCLKGen uSciTrREFCLKGen
 (
          .PCLK            (PCLK), 
          .PRESETn         (PRESETn),
          .SCICLK       (iSCICLK),
          .PCLKOn          (PCLKOn),
          .REFCLKOn        (REFCLKOn),
          .SCITrRFCK       (SCITrRFCK),
          .SCICLKOUT       (SCICLKOUT),
          .SCITrCKICC      (SCITrCKICC),
          .SCITrRFCNTL     (SCITrRFCNTL),
          .TrSCICLKEn      (TrSCICLKEn)
         );
 


 
SciTrTXCntl uSciTrTXCntl
 (
          .SCICLK       (iSCICLK),  
          .PRESETn         (PRESETn),
          .TrTxEnSync      (TrTXEn),
          .TrTxPEnSync     (TrTXPEn),
          .TrTXPStSync     (TrTXPStEn),
          .TrTXNAKSync     (TrTXNAKEn),
          .TrSENSE         (TrSENSE),
          .TrRSyTXPC       (TrRSyTXPC),
          .TrRSyCHG        (TrTXRSyCHG),
          .TrRSyBLKG       (TrTXRSyBLKG),
          .TrRSyJit        ( TrRSyJit),
          .TrRSyJitPat     (TrRSyJitPat),
          .TrRSyBAUD       (TrRSyBaud),
          .TrRSyVALUE      (TrRSyValue),
          .TXDataAvlblSync (TxDataAvlblSync),
          .TXShiftData     (TxFRdData), 
          .TXFRdPtrInc     (TxFRdPtrInc),
          .SCIDATAOUT      (TXSCIDATAOUT),
          .SCIDATAIN       (TXSCIDATAIN),
          .TXPtimError     (TXPtimError),
          .TXPtimWdError   (TXPtimWdError),
          .TXPError        (TXPError)
         );
 
SciTrRXCntl uSciTrRXCntl
 (
          .SCICLK       (iSCICLK),
          .PRESETn         (PRESETn),
          .TrRXEnSync      (TrRXEn), 
          .TrRXPEnSync     (TrRXPEn),
          .TrRXPStSync     (TrRXPStEn),
          .TrRSyRXPC       (TrRSyRXPC),
          .TrRSyCHG        (TrRXRSyCHG),
          .TrRSyBLKG       (TrRXRSyBLKG),
          .SCIDATAIN       (RXSCIDATAIN),
          .SCIDATAOUT      (RXSCIDATAOUT),
          .TrRXNAKSync     (TrRXNAKEn),
          .TrSENSE         (TrSENSE),
          .TrRSyBaud       (TrRSyBaud), 
          .TrRSyValue      (TrRSyValue),
          .RXPError        (RXPError),
          .RXCtimError     (RXCtimError),
          .RXBtimError     (RXBtimError),
          .StartBitError   (StartBitError),
          .RXShiftData     (RxFWrData),
          .RXFWr           (RxFWr)
         );

SciTrMux uSciTrMux 
 (
          .SCICLK       (iSCICLK), 
          .PRESETn         (PRESETn),
          .TrTXEn          (TrTXEn),
          .TrRXEn          (TrRXEn),
          .SCIDATAIN       (SCIDATAIN),
          .TXSCIDATAIN     (TXSCIDATAIN), 
          .RXSCIDATAIN     (RXSCIDATAIN),
          .TXSCIDATAOUT    (TXSCIDATAOUT),
          .RXSCIDATAOUT    (RXSCIDATAOUT),
          .SCIDATAOUT      (SCIDATAOUT)
         );
 
SciTrTimCheck  uSciTrTimCheck
 (
          .SCICLK         (iSCICLK),
          .PRESETn         (PRESETn),
          .SCIDATAOUT      (SCIDATAIN),  
          .SCICLKIN        (SCICLKIN),
          .DeBugOn         (TrDebugEn),
          .SCITrRFCK       (SCITrRFCK),
          .SCITrWV         (SCITrWV),
          .SCITrCKICC      (SCITrCKICC),
          .SCICLKErEn      (SCICLKErEn),
          .TXPtimErEn      (TXPtimErEn),
          .TXPErEn         (TXPErEn),
          .TXPtimWdErEn    (TXPtimWdErEn),
          .RXPErEn         (RXPErEn),
          .RXCtimErEn      (RXCtimErEn),
          .RXBtimErEn      (RXBtimErEn),
          .StartBitErEn    (StartBitErEn),
          .TXPtimError     (TXPtimError),  
          .TXPtimWdError   (TXPtimWdError),
          .TXPError        (TXPError),
          .RXPError        (RXPError),
          .RXCtimError     (RXCtimError),
          .RXBtimError     (RXBtimError),
          .StartBitError   (StartBitError)
         );

SciTrDMA  uSciTrDMA
 (
          .PCLK             (PCLK),
          .PRESETn          (PRESETn),
          .SCITXDMACLRStag1 (SCITDMACR[1]),
          .SCIRXDMACLRStag1 (SCITDMACR[0]),
          .SCITXDMACLR      (SCITXDMACLR),
          .SCIRXDMACLR      (SCIRXDMACLR),
          .SCITXDMACLRStag2 (SCITXDMACLRStag2),
          .SCIRXDMACLRStag2 (SCIRXDMACLRStag2)
         );


endmodule

