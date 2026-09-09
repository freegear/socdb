//  ----------------------------------------------------------------------------
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
//  File Name              : UartTrRegBlock.v.rca
//  File Revision          : 1.4
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//------------------------------------------------------------------------------
// Purpose     : This block generates decodes for Register accesses
//------------------------------------------------------------------------------
  
`timescale 1ns/1ps

//------------------------------------------------------------------------------

module UartTrRegBlock (
// Inputs
                       PCLK,
                       PRESETn,
                       UTILPRWrEn,
                       UTLCRHWrEn,
                       UTLCRMWrEn,
                       UTLCRLWrEn,
                       UTCRWrEn,
                       UTFORCEDERRSWrEn,
                       UTSETPINSWrEn,
                       UTBITSFTDATAWrEn,
                       UTSFTDATA2WrEn,
                       UTCLKREGWrEn,
                       RSTMODEREGWrEn,
                       UTDMACRWrEn,
                       UTSTPARITYWrEn,
                       UTFBRDWrEn,
                       PWDATAIn,
                       TXDMACLRStag4,
                       RXDMACLRStag4,

// Outputs
                       UTFORCEDERRS,
                       Mode,
                       UTLCRH,
                       UTLCRM,
                       UTLCRL,
                       UTILPR,
                       UTCR,
                       UTSTPARITY,
                       UTFBRD,
                       UTSETPINS,
                       UTBITSFTDATA,
                       UTBITSFTDATA2,
                       UTCLKREG,
                       RSTMODEREG,
                       UTDMACR
                      );

// Inputs
input         PCLK;             // APB Bus Clock
input         PRESETn;          // AMBA Reset
input         UTILPRWrEn;       // Write Enable for UTILPR
input         UTLCRHWrEn;       // Write Enable for LCRH
input         UTLCRMWrEn;       // Write Enable for LCRM
input         UTLCRLWrEn;       // Write Enable for LCRL
input         UTCRWrEn;         // Write Enable for UTCR
input         UTFORCEDERRSWrEn; // Write Enable for UTFORCEDERRS
input         UTSETPINSWrEn;    // Write Enable for UTSETPINS
input         UTBITSFTDATAWrEn; // Write Enable for UTBITSFTDATA
input         UTSFTDATA2WrEn;   // Write Enable for UTBITSFTDATA2
input         UTCLKREGWrEn;     // Write Enable for UTCLKREG
input         RSTMODEREGWrEn;   // Write Enable for UTRESETMODEREG 
input         UTDMACRWrEn;      // Write Enable for UTDMACR
input         UTSTPARITYWrEn;   // Write Enable for UTSTPARITY
input         UTFBRDWrEn;       // Write Enable for UTFBRD
input   [7:0] PWDATAIn;         // Data bus
input         TXDMACLRStag4;    // For UARTTXDMACLR
input         RXDMACLRStag4;    // For UARTRXDMACLR

// Outputs
output  [7:0] UTFORCEDERRS;     // Forcing Errs 
output  [1:0] Mode;             // Operation mode 
output  [7:0] UTLCRH;           // 1st buffer
output  [7:0] UTLCRM;           // 1st buffer
output  [7:0] UTLCRL;           // 1st buffer
output  [7:0] UTILPR;           // 1st buffer
output  [7:0] UTCR;             // CR bits
output  [7:0] UTSTPARITY;       // STPARITY bits
output  [5:0] UTFBRD;           // FBRD bits
output  [7:0] UTSETPINS;        // Set Pins Reg
output  [7:0] UTBITSFTDATA;     // Shift pulses
output  [5:0] UTBITSFTDATA2;    // Shift pulses 2
output  [7:0] UTCLKREG;         // Clock Period
output  [3:0] RSTMODEREG;       // Reset Reg
output  [1:0] UTDMACR;          // DMACR bits

// Inputs
wire          PCLK;             // APB Bus Clock
wire          PRESETn;            // Muxed Reset (from PRESETn)
wire          UTILPRWrEn;       // Write Enable for UTILPR
wire          UTLCRHWrEn;       // Write Enable for LCRH
wire          UTLCRMWrEn;       // Write Enable for LCRM
wire          UTLCRLWrEn;       // Write Enable for LCRL
wire          UTCRWrEn;         // Write Enable for UTCR
wire          UTFORCEDERRSWrEn; // Write Enable for UTFORCEDERRS
wire          UTSETPINSWrEn;    // Write Enable for UTSETPINS
wire          UTBITSFTDATAWrEn; // Write Enable for UTBITSFTDATA
wire          UTSFTDATA2WrEn;   // Write Enable for UTBITSFTDATA2
wire          UTCLKREGWrEn;     // Write Enable for UTCLKREG
wire          RSTMODEREGWrEn;   // Write Enable for UTRESETMODEREG 
wire          UTDMACRWrEn;      // Write Enable for UTDMACR
wire          UTSTPARITYWrEn;   // Write Enable for UTSTPARITY
wire          UTFBRDWrEn;       // Write Enable for UTFBRD
wire    [7:0] PWDATAIn;         // Data bus
wire          TXDMACLRStag4;    // For UARTTXDMACLR
wire          RXDMACLRStag4;    // For UARTRXDMACLR

// Outputs
reg     [7:0] UTFORCEDERRS;     // Forcing Errs 
reg     [1:0] Mode;             // Operation mode 
reg     [7:0] UTLCRH;           // 1st buffer
reg     [7:0] UTLCRM;           // 1st buffer
reg     [7:0] UTLCRL;           // 1st buffer
reg     [7:0] UTILPR;           // 1st buffer
reg     [7:0] UTCR;             // CR bits
reg     [7:0] UTSTPARITY;       // STPARITY bits
reg     [5:0] UTFBRD;           // FBRD bits
reg     [7:0] UTSETPINS;        // Set Pins Reg
reg     [7:0] UTBITSFTDATA;     // Shift pulses
reg     [5:0] UTBITSFTDATA2;    // Shift pulses 2
reg     [7:0] UTCLKREG;         // Clock Period
reg     [3:0] RSTMODEREG;       // Reset Reg
wire    [1:0] UTDMACR;          // DMACR bits

//------------------------------------------------------------------------------
//
//                             UartTrRegBlock
//                             ==============
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
//  This block contains the normal mode registers for the UT. Write data from
// the PWDATAIn bus is clocked in when the appropriate write enable signal is
// asserted. 
//  This block contains the first buffer in the 2-buffer synchronisation 
// mechanism for the LCR. It also contains the first buffer for the
// 2-buffer synchronisation mechanism for the ILPR.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg     [7:0] NextLCRH; 
// D-input of UTLCRH

reg     [7:0] NextLCRM;  
// D-input of UTLCRM

reg     [7:0] NextLCRL;  
// D-input of UTLCRL

reg     [7:0] NextILPR;
// D-input of UTILPR

reg     [7:0] NextUTCR;
// D-input of UTCR

reg     [7:0] NextUTSTPARITY;
// D-input of UTSTPARITY

reg     [5:0] NextUTFBRD;
// D-input of UTFBRD

reg     [7:0] NextUTFORCEDERRS;
// D-input of UTFORCEDERRS

reg     [7:0] NextUTSETPINS;
// D-input of UTSETPINS
 
reg     [7:0] NextBITSFTDATA;
// D-input for BITSFTDATA
 
reg     [5:0] NextBITSFTDATA2;
// D-input for BITSFTDATA2
 
reg     [7:0] NextCLKREG;
// D-input for CLK REG 

reg     [3:0] NextRSTMODEREG;
// D-input for Reset  REG
 
reg           iTXDMACLR;
// Internal copy of TXDMACLR

reg           iRXDMACLR;
// Internal copy of RXDMACLR

reg           NextTXDMACLR;
// D-input of TXDMACLR

reg           NextRXDMACLR;
// D-input of RXDMACLR
  
wire          nUTRST;
// Trickbox Reset

//------------------------------------------------------------------------------
//
// Main body of  code
// ==================
//
//------------------------------------------------------------------------------
   
//------------------------------------------------------------------------------
// Internal versions of output(s)...
//------------------------------------------------------------------------------
assign UTDMACR[0]       = iTXDMACLR;
assign UTDMACR[1]       = iRXDMACLR;

//------------------------------------------------------------------------------
// Generating Mode signal of Trickbox 
//------------------------------------------------------------------------------
always @(UTCR)
begin : p_ModeComb
  if (UTCR[1] == 1'b1)
    if (UTCR[2] == 1'b0)
      Mode <= 2'b01;
    else
      Mode <= 2'b10;
  else
    Mode <= 2'b00;
end // p_ModeComb
 
//-----------------------------------------------------------------------------
// Combinational process for 1st stage buffers for LCR. When the respective
// write enable input is asserted, copy the contents of the PWDATAIn bus into
// the corresponding 1st stage buffer.
//-----------------------------------------------------------------------------
always @(PWDATAIn or UTLCRHWrEn or UTLCRMWrEn or UTLCRLWrEn or 
         UTLCRH or UTLCRM or UTLCRL)
begin : p_LCRComb
  NextLCRH <= UTLCRH;
  NextLCRM <= UTLCRM;
  NextLCRL <= UTLCRL;

  if (UTLCRHWrEn == 1'b1)
    NextLCRH <= {PWDATAIn[7:1], 1'b0};

  if (UTLCRMWrEn == 1'b1)
    NextLCRM <= PWDATAIn;

  if (UTLCRLWrEn == 1'b1)
    NextLCRL <= PWDATAIn;
end // p_LCRComb

//-----------------------------------------------------------------------------
// Sequential process for first stage buffers for LCR 
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_LCRSeq
  if (PRESETn == 1'b0)
    begin
      UTLCRH <= 8'h00;
      UTLCRM <= 8'h00;
      UTLCRL <= 8'h00;
    end
  else
    begin
      UTLCRH <= NextLCRH;
      UTLCRM <= NextLCRM;
      UTLCRL <= NextLCRL;
    end
end // p_LCRSeq

//-----------------------------------------------------------------------------
// Clock in PWDATAIn into ILPR when UTILPRWrEn is asserted.
//-----------------------------------------------------------------------------
always @(UTILPRWrEn or UTILPR or PWDATAIn)
begin : p_ILPRComb
  NextILPR <= UTILPR;
  if (UTILPRWrEn == 1'b1)
    NextILPR <= PWDATAIn[7:0];
end // p_ILPRComb

//-----------------------------------------------------------------------------
// Sequential process for ILPR first stage buffer
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
    UTILPR <= 8'h00;
  else
    UTILPR <= NextILPR;
end // p_ILPSeq

//-----------------------------------------------------------------------------
// Clock PWDATAIn into UTCR when UTCRWrEn is asserted. 
//-----------------------------------------------------------------------------
always @(UTCRWrEn or UTCR or PWDATAIn) 
begin : p_CRComb
  NextUTCR <= UTCR;
 
  if (UTCRWrEn == 1'b1)
    NextUTCR <= PWDATAIn;
end // p_CRComb

//-----------------------------------------------------------------------------
// Sequential process for UTCR
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_CRSeq
  if (PRESETn == 1'b0)
    UTCR <= 8'h00;
  else
    UTCR <= NextUTCR;
end // p_CRSeq

//-----------------------------------------------------------------------------
// Clock PWDATAIn into UTUTFORCEDERRS when UTUTFORCEDERRSWrEn is asserted.
//-----------------------------------------------------------------------------
always @(UTFORCEDERRSWrEn or UTFORCEDERRS) 
begin : p_FORComb
  NextUTFORCEDERRS <= UTFORCEDERRS;

  if (UTFORCEDERRSWrEn == 1'b1)
    NextUTFORCEDERRS <= PWDATAIn;
end // p_FORComb

//-----------------------------------------------------------------------------
// Sequential process for UTFORCEDERRS 
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_FORSeq
  if (PRESETn == 1'b0)
    UTFORCEDERRS <= 8'h00;
  else
    UTFORCEDERRS <= NextUTFORCEDERRS;
end // p_FORSeq

//-----------------------------------------------------------------------------
// Clock in PWDATAIn into SET_PINS when UTSETPINSWrEn is asserted.
//-----------------------------------------------------------------------------
always @(UTSETPINSWrEn or UTSETPINS or PWDATAIn)
begin : p_UTSETPINSComb
  NextUTSETPINS <= UTSETPINS;
  if (UTSETPINSWrEn == 1'b1)
    NextUTSETPINS <= PWDATAIn[7:0];
end // p_UTSETPINSComb
 
//-----------------------------------------------------------------------------
// Sequential process for UTSETPINS first stage buffer
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_SETSeq
  if (PRESETn == 1'b0)
    UTSETPINS <= 8'h3F;
  else
    UTSETPINS <= NextUTSETPINS;
end // p_SETSeq
 
//-----------------------------------------------------------------------------
// Clock in PWDATAIn into BITSFTDATA when UTBITSFTDATAWrEn is asserted.
//-----------------------------------------------------------------------------
always @(UTBITSFTDATAWrEn or UTBITSFTDATA or PWDATAIn)
begin : p_BITSFTDATAComb
  NextBITSFTDATA <= UTBITSFTDATA;
  if (UTBITSFTDATAWrEn == 1'b1)
    NextBITSFTDATA <= PWDATAIn;
end // p_BITSFTDATAComb
 
//-----------------------------------------------------------------------------
// Sequential process for BITSFTDATA first stage buffer
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_BITSFTSeq
  if (PRESETn == 1'b0)
    UTBITSFTDATA <= 8'h00;
  else
    UTBITSFTDATA <= NextBITSFTDATA;
end // p_BITSFTSeq
 
//-----------------------------------------------------------------------------
// Clock in PWDATAIn into BITSFTDATA2 when UTSFTDATA2WrEn is asserted.
//-----------------------------------------------------------------------------
always @(UTSFTDATA2WrEn or UTBITSFTDATA2 or PWDATAIn)
begin
  NextBITSFTDATA2 <= UTBITSFTDATA2;
  if (UTSFTDATA2WrEn == 1'b1)
    NextBITSFTDATA2 <= PWDATAIn[5:0];
end // p_BITSFTDATA2Comb
 
//-----------------------------------------------------------------------------
// Sequential process for BITSFTDATA2 first stage buffer
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_BITSFTDATA2Seq
  if (PRESETn == 1'b0)
    UTBITSFTDATA2 <= 8'h00;
  else
    UTBITSFTDATA2 <= NextBITSFTDATA2;
end // p_BITSFTDATA2Seq
 
//-----------------------------------------------------------------------------
// Clock in PWDATAIn into CLKREG when UTCLKREGWrEn is asserted.
//-----------------------------------------------------------------------------
always @(UTCLKREGWrEn or UTCLKREG or PWDATAIn)
begin : p_CLKREGComb
  NextCLKREG <= UTCLKREG;
  if (UTCLKREGWrEn == 1'b1)
    NextCLKREG <= PWDATAIn;
end // p_CLKREGComb
 
//-----------------------------------------------------------------------------
// Sequential process for CLKREG first stage buffer
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_CLKREGSeq
  if (PRESETn == 1'b0)
    UTCLKREG <= 8'h00;
  else
    UTCLKREG <= NextCLKREG;
end // p_CLKREGSeq
 
//-----------------------------------------------------------------------------
// Clock in PWDATAIn into CLKREG when UTCLKREGWrEn is asserted.
//-----------------------------------------------------------------------------
always @(RSTMODEREGWrEn or RSTMODEREG or PWDATAIn)
begin : p_RSTMODEREGComb
  NextRSTMODEREG <= RSTMODEREG;
  if (RSTMODEREGWrEn == 1'b1)
    NextRSTMODEREG <= PWDATAIn[3:0];
end // p_RSTMODEREGComb
 
//-----------------------------------------------------------------------------
// Sequential process for RSTMODEREG first stage buffer
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_RSTMODESeq
  if (PRESETn == 1'b0)
    RSTMODEREG <= 8'h00;
  else
    RSTMODEREG <= NextRSTMODEREG;
end // p_RSTMODESeq;

//-----------------------------------------------------------------------------
// Clock PWDATAIn into UTDMACR when UTDMACRWrEn is asserted, TX
//-----------------------------------------------------------------------------
always @(UTDMACRWrEn or iTXDMACLR or PWDATAIn or TXDMACLRStag4) 
begin : p_TXDMAComb
  NextTXDMACLR <= iTXDMACLR;
 
  if (UTDMACRWrEn == 1'b1)
    NextTXDMACLR <= PWDATAIn[0];
  else if (TXDMACLRStag4 == 1'b1)
    NextTXDMACLR <= 1'b0;
end // p_TXDMAComb

//-----------------------------------------------------------------------------
// Sequential process for UTDMACR
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_TXDMASeq
  if (PRESETn == 1'b0)
    iTXDMACLR <=  1'b0;
  else
    iTXDMACLR <= NextTXDMACLR;
end // p_TXDMASeq


//-----------------------------------------------------------------------------
// Clock PWDATAIn into UTDMACR when UTDMACRWrEn is asserted, RX
//-----------------------------------------------------------------------------
always @(UTDMACRWrEn or iRXDMACLR or PWDATAIn or RXDMACLRStag4) 
begin : p_RXDMAComb
  NextRXDMACLR <= iRXDMACLR;
 
  if (UTDMACRWrEn == 1'b1)
    NextRXDMACLR <= PWDATAIn[1];
  else if (RXDMACLRStag4 == 1'b1)
    NextRXDMACLR <= 1'b0;
end // p_RXDMAComb

//-----------------------------------------------------------------------------
// Sequential process for UTDMACR
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_RXDMASeq
  if (PRESETn == 1'b0)
    iRXDMACLR <= 1'b0;
  else
    iRXDMACLR <= NextRXDMACLR;
end // p_RXDMASeq

//-----------------------------------------------------------------------------
// Clock PWDATAIn into UTSTPARITY when UTSTPARITYWrEn is asserted. 
//-----------------------------------------------------------------------------
always @(UTSTPARITYWrEn or UTSTPARITY or PWDATAIn) 
begin : p_STPARITYComb
  NextUTSTPARITY <= UTSTPARITY;
 
  if (UTSTPARITYWrEn == 1'b1)
    NextUTSTPARITY <= {PWDATAIn[7], 7'b0000000};
end // p_STPARITYComb

//-----------------------------------------------------------------------------
// Sequential process for UTSTPARITY
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_STPARITYSeq
  if (PRESETn == 1'b0)
    UTSTPARITY <= 8'h00;
  else
    UTSTPARITY <= NextUTSTPARITY;
end // p_STPARITYSeq

//-----------------------------------------------------------------------------
// Clock PWDATAIn into UTFBRD when UTFBRDWrEn is asserted. 
//-----------------------------------------------------------------------------
always @(UTFBRDWrEn or UTFBRD or PWDATAIn) 
begin : p_FBRDComb
  NextUTFBRD <= UTFBRD;
 
  if (UTFBRDWrEn == 1'b1)
    NextUTFBRD <= PWDATAIn[5:0];
end // p_FBRDComb

//-----------------------------------------------------------------------------
// Sequential process for UTFBRD
//-----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_FBRDSeq
  if (PRESETn == 1'b0)
    UTFBRD <= 6'b000000;
  else
    UTFBRD <= NextUTFBRD;
end // p_FBRDSeq

endmodule

//========================== End of UartTrRegBlock =============================
