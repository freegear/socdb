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
//  File Name              : SciTrRegBlk.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Purpose     : This block contains fuctional registers of SCI. It also 
//               generates update trigger signal for those registers
//               whose contents need to be updated in SCIREFCLK domain.  
//------------------------------------------------------------------------------
  
`timescale 1ns/1ps

//------------------------------------------------------------------------------

module  SciTrRegBlk 
       (
        PCLK, 
        PRESETn,
        SCITrCRWrEn,
        SCITrFiLCRWrEn, 
        SCITrTXPCWrEn,
        SCITrRXPCWrEn,
        SCITrCTRLWrEn,
        SCITrATWrEn,
        SCITrDTWrEn, 
        SCITrTXBLKGWrEn,
        SCITrTXCHGWrEn,
        SCITrCKICCWrEn, 
        SCITrBAUDWrEn, 
        SCITrVALUEWrEn, 
        SCITrRXCHGWrEn,
        SCITrRXBLKGWrEn, 
        SCITrRFCKWrEn,
        SCITrWVWrEn, 
        SCITrJitWrEn,
        SCITrJitPatWrEn,
        SCITrRFCNTLWrEn, 
        SCITrDMAWr,
        SCITXDMACLRStag2,
        SCIRXDMACLRStag2,
        PWDATAIn, 

        SCITrCR , 
        SCITrFiLCR, 
        SCITrTXPC,
        SCITrRXPC,  
        SCITrCTRL,  
        SCITrAT, 
        SCITrDT,
        SCITrTXBLKG,
        SCITrTXCHG,
        SCITrCKICC, 
        SCITrBAUD, 
        SCITrVALUE,
        SCITrRXCHG, 
        SCITrRFCK,
        SCITrRXBLKG,
        SCITrWV,   
        SCITrJit,  
        SCITrJitPat,
        SCITrRFCNTL,  
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
        TrRFCKUpdate, 
        TrWVUpdate,
        TrJitUpdate, 
        TrJitPUpdate,
        SCITDMACR
       );

input        PCLK; // APB Bus Clock
input        PRESETn; // Reset input
input        SCITrCRWrEn ; // Control Reg Wr En
input        SCITrFiLCRWrEn; // FIFO level Wr En
input        SCITrTXPCWrEn; // TX retray Wr En
input        SCITrRXPCWrEn; // RX retray Wr En
input        SCITrCTRLWrEn; // Error En Wr En
input        SCITrATWrEn; // ATIME Wr En
input        SCITrDTWrEn; // DTIME Wr En
input        SCITrTXBLKGWrEn; // TX BLKG Wr En
input        SCITrTXCHGWrEn; // TX CHTG Wr En
input        SCITrCKICCWrEn; // CLKICC Wr En
input        SCITrBAUDWrEn; // BAUD Wr En
input        SCITrVALUEWrEn; // VALUE Wr En
input        SCITrRXCHGWrEn; // RX CHG Wr En
input        SCITrRXBLKGWrEn; // RX BLKG Wr En
input        SCITrRFCKWrEn; // REFCLK Reg Wr En
input        SCITrWVWrEn; // Error Margin Wr En
input        SCITrJitWrEn; // Jit value Wr En
input        SCITrJitPatWrEn; // Jit Cnt Wr En
input        SCITrRFCNTLWrEn; // REFCLK Cnt Wr En
input        SCITrDMAWr;  // Write Enable for UTDMACR
input        SCITXDMACLRStag2; // For SCITXDMACLR
input        SCIRXDMACLRStag2; // For SCIRXDMACLR
input        [15:0] PWDATAIn; // Int PWDATA

output        [15:0] SCITrCR; // Control reg
output        [7:0] SCITrFiLCR;  // FIFO level
output        [3:0] SCITrTXPC;  // TX Retray
output        [3:0] SCITrRXPC;  // RX Retray
output        [7:0] SCITrCTRL;  // Error En 
output        [15:0] SCITrAT; // ACTtim reg
output        [15:0] SCITrDT; // DEACTtim reg
output        [7:0] SCITrTXBLKG;  // TX BLKG reg
output        [7:0] SCITrTXCHG;  // TX CHG reg
output        [15:0] SCITrCKICC; // CLKICC reg
output        [15:0] SCITrBAUD ; // BAUD reg
output        [7:0] SCITrVALUE;  // VALUE reg
output        [7:0] SCITrRXCHG;  // RX CHG reg
output        [7:0] SCITrRXBLKG;  // RX BLKG reg
output        [15:0] SCITrRFCK; // REFCLK reg
output        [7:0] SCITrWV;  // Err Margin 
output        [15:0] SCITrJit; // Jit value 
output        [9:0] SCITrJitPat;  // Jit Pat reg
output        [2:0] SCITrRFCNTL;  // REFCLK Cnt
output        TrCRUpdate; // Control reg update trigger
output        TrTXPCUpdate; // TX Retray Reg update trigger
output        TrRXPCUpdate; // RX Retray Reg update trigger
output        TrCTRLUpdate; // Error Enable Reg trigger
output        TrATUpdate; // ATIME update trigger
output        TrDTUpdate; // DTIME update trigger
output        TrTXBGUpdate; // TX BLKG  update trigger
output        TrTXCGUpdate; // TX CHG update trigger
output        TrCKICUpdate; // CLKICC update trigger
output        TrBAUDUpdate; // BAUD update trigger
output        TrVALUpdate; // VALUE update trigger
output        TrRXCGUpdate; // RX CHG  update trigger
output        TrRXBGUpdate; // RX BLKG update trigger
output        TrRFCKUpdate; // REFCLK Reg update trigger
output        TrWVUpdate; // Error Margin Reg update trigger
output        TrJitUpdate; // Jit value Reg update trigger
output        TrJitPUpdate;// Jit Cnt update trigger
output [1:0]  SCITDMACR;    // TX DMA Clear

//------------------------------------------------------------------------------
//
//                   SciTrRegBlk
//                   ===========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
//  This block contains the  registers for the SCI trickbox. Write data from
// the PWDATAIn bus is clocked in when the appropriate write enable signal is
// asserted.
//------------------------------------------------------------------------------
//


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
//reg        [12:0]iSCITrSR1;      
reg  [15:0] iSCITrCR          ;
// Internal copy of SCITrCR 

wire [15:0] NextSCITrCR       ;
// D-input of SCITrCR 

reg  [7:0] iSCITrFiLCR       ;
//Internal copy of SCITrFiLCR

wire [7:0] NextSCITrFiLCR    ;
// D-input of SCITrFiLCR 

reg  [3:0] iSCITrTXPC        ;
//internal copy of SCITrTXPC

wire [3:0] NextSCITrTXPC     ;
// D-input of SCITrTXPC 

reg  [3:0] iSCITrRXPC        ;
//internal copy of SCITrRXPC

wire [3:0] NextSCITrRXPC     ;
// D-input of SCITrRXPC 

reg  [7:0] iSCITrCTRL        ;
//internal copy of SCITrCTRL

wire [7:0] NextSCITrCTRL     ;
// D-input of SCITrCTRL

reg  [15:0] iSCITrAT          ;
//internal copy of SCITrAT 

wire [15:0] NextSCITrAT       ;
// D-input of SCITrAT 

reg  [15:0] iSCITrDT          ;	
//internal copy of SCITrDT

wire [15:0] NextSCITrDT       ;	
// D-input of SCITrDT

reg  [7:0] iSCITrTXBLKG      ;
//internal copy of SCITrTXBLKG

wire [7:0] NextSCITrTXBLKG   ;
// D-input of SCITrTXBLKG 

reg  [7:0] iSCITrTXCHG       ;
//internal copy of SCITrTXCHG

wire [7:0] NextSCITrTXCHG    ;
// D-input of SCITrTXCHG 

reg  [15:0] iSCITrCKICC       ;
//internal copy of SCITrCKICC

wire [15:0] NextSCITrCKICC    ;
// D-input of SCITrCKICC 

reg  [15:0] iSCITrBAUD        ;
//internal copy of SCITrBAUD

wire [15:0] NextSCITrBAUD     ;
// D-input of SCITrBAUD 

reg  [7:0] iSCITrVALUE       ;
//internal copy of SCIVALUE

wire [7:0] NextSCITrVALUE    ;
// D-input of SCITrVALUE 

reg  [7:0] iSCITrRXCHG       ;
//internal copy of SCITrRXCHG

wire [7:0] NextSCITrRXCHG    ;
// D-input of SCITrRXCHG 

reg  [7:0] iSCITrRXBLKG      ;
//internal copy of SCIBLKGUARD

wire [7:0] NextSCITrRXBLKG   ;
// D-input of SCITrRXBLKG 

reg  [15:0] iSCITrRFCK ;
//internal copy of SCITrRFCK

wire [15:0] NextSCITrRFCK;
// D-input of SCITrRFCK 

reg  [7:0] iSCITrWV          ;
//internal copy of SCITrWV

wire [7:0] NextSCITrWV       ;
// D-input of SCITrWV 

reg  [15:0] iSCITrJit         ;
//internal copy of SCITrJit

wire [15:0] NextSCITrJit      ;
// D-input of SCITrJit 

reg  [9:0] iSCITrJitPat      ;
//internal copy of SCITrJitPat

wire [9:0] NextSCITrJitPat   ;
// D-input of SCITrJitPat 

reg  [2:0] iSCITrRFCNTL   ;
//internal copy of SCITrRFCNTL

wire [2:0] NextSCITrRFCNTL ;
// D-input of SCITrRFCNTL 

reg  iTrCRUpdate      ;
// Internal copy of Update trigger for SCITrCR register

wire NextTrCRUpdate   ;
// D-input of iTrCRUpdate

reg  iTrTXPCUpdate    ;
// Internal copy of Update trigger for SCITrTXPC register

wire NextTrTXPCUpdate ;
// D-input of iTrTXPCUpdate

reg  iTrRXPCUpdate    ;
// Internal copy of Update trigger for SCITrRXPC register

wire NextTrRXPCUpdate ;
// D-input of iTrRXPCUpdate

reg  iTrCTRLUpdate    ;
// Internal copy of Update trigger for TrCTRLUpdate register

wire NextTrCTRLUpdate ;
// D-input of iTrCTRLUpdate 

reg  iTrATUpdate      ;
// Internal copy of Update trigger for SCRTrATIME register

wire NextTrATUpdate   ;
// D-input of iTrATUpdate

reg  iTrDTUpdate      ;	
// Internal copy of Update trigger for SCRTrDT register

wire NextTrDTUpdate;	
// D-input of iTrDTUpdate 

reg  iTrTXBGUpdate ;	
// Internal copy of Update trigger for TrSCIBLKG register

wire NextTrTXBGUpdate ;	
// D-input of iTrTXBGUpdate

reg  iTrTXCGUpdate    ;	
// Internal copy of Update trigger for TrSCICHG register

wire NextTrTXCGUpdate ;	
// D-input of iTrTXCGUpdate

reg  iTrCKICUpdate    ;	
// Internal copy of Update trigger for TrSCICKICC register

wire NextTrCKICUpdate ;	
// D-input of iTrCKICUpdate

reg  iTrBAUDUpdate    ;	
// Internal copy of Update trigger for TrSCIBAUD register

wire NextTrBAUDUpdate ;	
// D-input of iTrBAUDUpdate

reg  iTrVALUpdate     ;	
// Internal copy of Update trigger for TrSCIVALUE register

wire NextTrVALUpdate  ;	
// D-input of iTrVALUpdate

reg  iTrRXCGUpdate    ;	
// Internal copy of Update trigger for SCITrRXCHG register

wire NextTrRXCGUpdate ;	
// D-input of iTrRXCGUpdate

reg  iTrRXBGUpdate    ;	
// Internal copy of Update trigger for SCITrRXBLKG register

wire NextTrRXBGUpdate ;	
// D-input of SCITrRXBGUpdate

reg  iTrRFCKUpdate    ;	
// Internal copy of Update trigger for TrRFCKUpdate register

wire NextTrRFCKUpdate ;	
// D-input of SCITrRFCKUpdate

reg  iTrWVUpdate      ;	
// Internal copy of Update trigger for TrWVUpdate register

wire NextTrWVUpdate   ;	
// D-input of SCITrWVUpdate

reg  iTrJitUpdate     ;	
// Internal copy of Update trigger for TrJitUpdate register

wire NextTrJitUpdate  ;	
// D-input of SCITrJitUpdate

reg  iTrJitPUpdate    ;	
// Internal copy of Update trigger for TrJitPUpdate register

wire NextTrJitPUpdate ;	
// D-input of SCITrJitPUpdate

wire   SCITXDMACLRStag2;
// For SCITXDMACLR;

wire   SCIRXDMACLRStag2;
// For SCIRXDMACLRStag2;

reg SCITXDMACLR;
// SCITXDMACLR

reg SCIRXDMACLR;
// SCIRXDMACLR

reg NextSCITXDMACLR;
// D-input of TXDMACLR
  
reg NextSCIRXDMACLR;
// D-input of RXDMACLR

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
initial
begin 
iSCITrRFCK   = 16'b0000000000010100;
iSCITrRFCNTL = 3'b000;
iSCITrCKICC  = 16'b0000000000000100;
end
//-----------------------------------------------------------------------------
// Combinational logic for all functional registers.When the respective
// write enable input is asserted, copy the contents of the PWDATAIn bus into
// the corresponding registers. 
//-----------------------------------------------------------------------------

assign NextSCITrCR        = (SCITrCRWrEn == 1'b1) ?    PWDATAIn[15:0] :
                            iSCITrCR;    
assign NextSCITrFiLCR     = (SCITrFiLCRWrEn == 1'b1) ?    PWDATAIn[7:0] :
                            iSCITrFiLCR;    
 
assign NextSCITrTXPC      = (SCITrTXPCWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrTXPC;       
 
assign NextSCITrRXPC      = (SCITrRXPCWrEn == 1'b1) ? PWDATAIn[3:0] :
                            iSCITrRXPC;       
 
assign NextSCITrCTRL      = (SCITrCTRLWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrCTRL; 
 
assign NextSCITrAT        = (SCITrATWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrAT; 
 
assign NextSCITrDT        = (SCITrDTWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrDT; 
 
assign NextSCITrTXBLKG    = (SCITrTXBLKGWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrTXBLKG; 
 
assign NextSCITrTXCHG     = (SCITrTXCHGWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrTXCHG; 
 
assign NextSCITrCKICC     = (SCITrCKICCWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrCKICC;  
 
assign NextSCITrBAUD      = (SCITrBAUDWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrBAUD;  
 
assign NextSCITrVALUE     = (SCITrVALUEWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrVALUE;  
 
assign NextSCITrRXCHG     = (SCITrRXCHGWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrRXCHG; 
 
assign NextSCITrRXBLKG    = (SCITrRXBLKGWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrRXBLKG;  
 
assign NextSCITrRFCK      = (SCITrRFCKWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrRFCK;  
 
assign NextSCITrWV        = (SCITrWVWrEn == 1'b1) ?  PWDATAIn[7:0] :
                            iSCITrWV;  
 
assign NextSCITrJit       = (SCITrJitWrEn == 1'b1) ?  PWDATAIn[15:0] :
                            iSCITrJit;  
 
assign NextSCITrJitPat    = (SCITrJitPatWrEn == 1'b1) ?  PWDATAIn[9:0] :
                            iSCITrJitPat;  
 
assign NextSCITrRFCNTL    = (SCITrRFCNTLWrEn == 1'b1) ?  PWDATAIn[2:0] :
                            iSCITrRFCNTL; 

//-----------------------------------------------------------------------------
// Sequential process for all functional registers.
//-----------------------------------------------------------------------------
always  @(posedge PCLK or  negedge PRESETn)
begin : p_Seq 
  if (PRESETn == 1'b0)
  begin  
    iSCITrCR       <= 16'b0000000000000000;	
    iSCITrFiLCR    <= 8'b00000000;
    iSCITrTXPC     <= 4'b0000;
    iSCITrRXPC     <= 4'b0000;
    iSCITrCTRL     <= 8'b00000000;
    iSCITrAT       <= 16'b0000000000000000;	
    iSCITrDT       <= 16'b0000000000000000;	
    iSCITrTXBLKG   <= 8'b00000000;	
    iSCITrTXCHG    <= 8'b00000000;	
    iSCITrCKICC    <= 16'b0000000000000000;	
    iSCITrBAUD     <= 16'b0000000000000000;	
    iSCITrVALUE    <= 8'b00000000;	
    iSCITrRXCHG    <= 8'b00000000;	
    iSCITrRXBLKG   <= 8'b00000000;	
    iSCITrRFCK     <= 16'b0000000000010100; 
    iSCITrWV       <= 8'b00000000;	
    iSCITrJit      <= 16'b0000000000000000;	
    iSCITrJitPat   <= 10'b0000000000;	
    iSCITrRFCNTL   <= 3'b000;	
  end 
  else
  begin  
    iSCITrCR       <= NextSCITrCR;
    iSCITrFiLCR    <= NextSCITrFiLCR;
    iSCITrTXPC     <= NextSCITrTXPC;
    iSCITrRXPC     <= NextSCITrRXPC;
    iSCITrCTRL     <= NextSCITrCTRL;
    iSCITrAT       <= NextSCITrAT;
    iSCITrDT       <= NextSCITrDT;
    iSCITrTXBLKG   <= NextSCITrTXBLKG;
    iSCITrTXCHG    <= NextSCITrTXCHG;
    iSCITrCKICC    <= NextSCITrCKICC;
    iSCITrBAUD     <= NextSCITrBAUD;
    iSCITrVALUE    <= NextSCITrVALUE;
    iSCITrRXCHG    <= NextSCITrRXCHG;
    iSCITrRXBLKG   <= NextSCITrRXBLKG;
    iSCITrRFCK     <= NextSCITrRFCK;	
    iSCITrWV       <= NextSCITrWV;	
    iSCITrJit      <= NextSCITrJit;	
    iSCITrJitPat   <= NextSCITrJitPat;	
    iSCITrRFCNTL   <= NextSCITrRFCNTL;	
  end
end // p_Seq;

//-----------------------------------------------------------------------------
// Update signal of registers toggles with their corresponding 
// write to the registers.
//-----------------------------------------------------------------------------

assign NextTrCRUpdate       =  (SCITrCRWrEn == 1'b1) ? !(iTrCRUpdate) :       
                     
                        iTrCRUpdate;   

assign NextTrTXPCUpdate     =  (SCITrTXPCWrEn == 1'b1)  ? !(iTrTXPCUpdate) :    
                     
                        iTrTXPCUpdate;   

assign NextTrRXPCUpdate     =  (SCITrRXPCWrEn == 1'b1)   ? !(iTrRXPCUpdate) :   
                     
                        iTrRXPCUpdate;   

assign NextTrCTRLUpdate     =  (SCITrCTRLWrEn == 1'b1)   ? !(iTrCTRLUpdate) :   
                     
                        iTrCTRLUpdate;   

assign NextTrATUpdate       =  (SCITrATWrEn == 1'b1) ? !(iTrATUpdate) :     
                     
                        iTrATUpdate;

assign NextTrDTUpdate       =  (SCITrDTWrEn == 1'b1) ? !(iTrDTUpdate) :     
                     
                        iTrDTUpdate;

assign NextTrTXBGUpdate     =  (SCITrTXBLKGWrEn == 1'b1) ? !(iTrTXBGUpdate) :   
                     
                        iTrTXBGUpdate;

assign NextTrTXCGUpdate     =  (SCITrTXCHGWrEn == 1'b1) ? !(iTrTXCGUpdate) :   
                     
                        iTrTXCGUpdate;

assign NextTrCKICUpdate     =  (SCITrCKICCWrEn == 1'b1) ? !(iTrCKICUpdate) :   
                     
                        iTrCKICUpdate; 

assign NextTrBAUDUpdate     =  (SCITrBAUDWrEn == 1'b1) ? !(iTrBAUDUpdate) :   
                     
                        iTrBAUDUpdate; 

assign NextTrVALUpdate      =  (SCITrVALUEWrEn == 1'b1) ? !(iTrVALUpdate) :    
                     
                        iTrVALUpdate; 

assign NextTrRXCGUpdate     =  (SCITrRXCHGWrEn == 1'b1) ? !(iTrRXCGUpdate) :   
                     
                        iTrRXCGUpdate;

assign NextTrRXBGUpdate     =  (SCITrRXBLKGWrEn == 1'b1) ? !(iTrRXBGUpdate) :   
                     
                        iTrRXBGUpdate; 

assign NextTrRFCKUpdate     =  (SCITrRFCKWrEn == 1'b1) ? !(iTrRFCKUpdate) :   
                     
                        iTrRFCKUpdate; 

assign NextTrWVUpdate       =  (SCITrWVWrEn == 1'b1) ? !(iTrWVUpdate) :     
                     
                        iTrWVUpdate; 

assign NextTrJitUpdate      =  (SCITrJitWrEn == 1'b1) ? !(iTrJitUpdate) :    
                     
                        iTrJitUpdate; 

assign NextTrJitPUpdate     =  (SCITrJitPatWrEn == 1'b1) ? !(iTrJitPUpdate) :   
                     
                        iTrJitPUpdate; 

//-----------------------------------------------------------------------------
// Sequential process for all Updates.
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin 
  if (PRESETn == 1'b0)
  begin 
    iTrCRUpdate      <= 1'b0;
    iTrTXPCUpdate    <= 1'b0;
    iTrRXPCUpdate    <= 1'b0;
    iTrCTRLUpdate    <= 1'b0;
    iTrATUpdate      <= 1'b0;
    iTrDTUpdate      <= 1'b0;	
    iTrTXBGUpdate    <= 1'b0;	
    iTrTXCGUpdate    <= 1'b0;	
    iTrCKICUpdate    <= 1'b0;	
    iTrBAUDUpdate    <= 1'b0;	
    iTrVALUpdate     <= 1'b0;	
    iTrRXCGUpdate    <= 1'b0;	
    iTrRXBGUpdate    <= 1'b0;	
    iTrRFCKUpdate    <= 1'b0;	
    iTrWVUpdate      <= 1'b0;	
    iTrJitUpdate     <= 1'b0;	
    iTrJitPUpdate    <= 1'b0;	
  end 
  else
  begin  
    iTrCRUpdate      <= NextTrCRUpdate;
    iTrTXPCUpdate    <= NextTrTXPCUpdate;
    iTrRXPCUpdate    <= NextTrRXPCUpdate;
    iTrCTRLUpdate    <= NextTrCTRLUpdate;
    iTrATUpdate      <= NextTrATUpdate;
    iTrDTUpdate      <= NextTrDTUpdate;
    iTrTXBGUpdate    <= NextTrTXBGUpdate;
    iTrTXCGUpdate    <= NextTrTXCGUpdate;
    iTrCKICUpdate    <= NextTrCKICUpdate;
    iTrBAUDUpdate    <= NextTrBAUDUpdate;
    iTrVALUpdate     <= NextTrVALUpdate;
    iTrRXCGUpdate    <= NextTrRXCGUpdate;
    iTrRXBGUpdate    <= NextTrRXBGUpdate;
    iTrRFCKUpdate    <= NextTrRFCKUpdate;
    iTrWVUpdate      <= NextTrWVUpdate;
    iTrJitUpdate     <= NextTrJitUpdate;
    iTrJitPUpdate    <= NextTrJitPUpdate;
  end
end // p_UpdateSeq;

//-----------------------------------------------------------------------------
 //-----------------------------------------------------------------------------
assign SCITrCR        = iSCITrCR;
assign SCITrFiLCR     = iSCITrFiLCR;
assign SCITrTXPC      = iSCITrTXPC;
assign SCITrRXPC      = iSCITrRXPC;
assign SCITrCTRL      = iSCITrCTRL;
assign SCITrAT        = iSCITrAT;
assign SCITrDT        = iSCITrDT;
assign SCITrTXBLKG    = iSCITrTXBLKG;
assign SCITrTXCHG     = iSCITrTXCHG;
assign SCITrCKICC     = iSCITrCKICC;
assign SCITrBAUD      = iSCITrBAUD;
assign SCITrVALUE     = iSCITrVALUE;
assign SCITrRXCHG     = iSCITrRXCHG;
assign SCITrRXBLKG    = iSCITrRXBLKG;
assign SCITrRFCK      = iSCITrRFCK;
assign SCITrWV        = iSCITrWV;
assign SCITrJit       = iSCITrJit;
assign SCITrJitPat    = iSCITrJitPat;
assign SCITrRFCNTL    = iSCITrRFCNTL;
assign TrCRUpdate     = iTrCRUpdate;
assign TrTXPCUpdate   = iTrTXPCUpdate;
assign TrRXPCUpdate   = iTrRXPCUpdate;
assign TrCTRLUpdate   = iTrCTRLUpdate;
assign TrATUpdate     = iTrATUpdate;
assign TrDTUpdate     = iTrDTUpdate;
assign TrTXBGUpdate   = iTrTXBGUpdate;
assign TrTXCGUpdate   = iTrTXCGUpdate;
assign TrCKICUpdate   = iTrCKICUpdate;
assign TrBAUDUpdate   = iTrBAUDUpdate;
assign TrVALUpdate    = iTrVALUpdate;
assign TrRXCGUpdate   = iTrRXCGUpdate;
assign TrRXBGUpdate   = iTrRXBGUpdate;
assign TrRFCKUpdate   = iTrRFCKUpdate;
assign TrWVUpdate     = iTrWVUpdate;
assign TrJitUpdate    = iTrJitUpdate;
assign TrJitPUpdate   = iTrJitPUpdate;
assign SCITDMACR[1]   = SCITXDMACLR;
assign SCITDMACR[0]   = SCIRXDMACLR;

// ----------------------------------------------------------------------------
// Clock PWDATAIn into SCITXDMACLR when SCITrDMAWr is asserted, TX
// ----------------------------------------------------------------------------
always @(SCITrDMAWr or SCITXDMACLR or PWDATAIn or SCITXDMACLRStag2) 
begin : p_TXDMAComb 
  NextSCITXDMACLR = SCITXDMACLR;
 
  if (SCITrDMAWr)
    NextSCITXDMACLR = PWDATAIn[1];
  else if (SCITXDMACLRStag2)
    NextSCITXDMACLR = 1'b0;
end // p_TXDMAComb;

// ----------------------------------------------------------------------------
// Sequential process for SCITDMACR
// ----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_TXDMASeq
  if (PRESETn == 1'b0)
    SCITXDMACLR <=  1'b0;
  else 
    SCITXDMACLR <= NextSCITXDMACLR;
end // p_TXDMASeq;

// ----------------------------------------------------------------------------
// Clock PWDATAIn into SCITDMACR when SCITrDMAWr is asserted, RX
// ----------------------------------------------------------------------------
always @(SCITrDMAWr or SCIRXDMACLR or PWDATAIn or SCIRXDMACLRStag2) 
begin : p_RXDMAComb 
  NextSCIRXDMACLR = SCIRXDMACLR;
 
  if (SCITrDMAWr)
    NextSCIRXDMACLR = PWDATAIn[0];
  else if(SCIRXDMACLRStag2)
    NextSCIRXDMACLR = 1'b0;
end // p_RXDMAComb;

// ----------------------------------------------------------------------------
// Sequential process for SCITDMACR
// ----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_RXDMASeq

  if (PRESETn == 1'b0)
    SCIRXDMACLR <= 1'b0;
  else
    SCIRXDMACLR <= NextSCIRXDMACLR;
end // p_RXDMASeq;

endmodule
//=================================== End === ==============================--

















