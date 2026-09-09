// --=========================================================================--
//  This confidential  and  proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies  and  copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
//  Version  and  Release Control Information:
//  
//  File Name              : SspTrRegCore.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : This block contains, the Registers in the SSPTrickBox
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrRegCore( 
                    PCLK, 
                    PRESETn, 
                    SSPTBCR0Wr, 
                    SSPTBCR1Wr, 
                    SSPTBCR2Wr,
                    SSPTBSRWr, 
                    SSPTBPREWr,
                    SSPTBTDRWr,
                    SSPTBRDRWr, 
                    SSPTBSETPINSWr, 
                    SSPTBCLKREGWr, 
                    SSPTBCLKREG1Wr,
                    SSPTBDMACRWrEn,
                    PWDATAIn, 

                    SSPTXDMACLRStag2,
                    SSPRXDMACLRStag2,
                    CR0Update,  
                    CR1Update,  
                    SSPTBCR0,  
                    SSPTBCR1, 
                    SSPTBCR2,
                    SSPTBSR,
                    SSPTBCLKREG, 
                    SSPTBCLKREG1, 
                    SSPTBSETPINS, 
                    SSPTBPRE,
                    SSPTDMACR
                   );

input         PCLK;                // APB bus clock
input         PRESETn;             // APB bus Reset 
input         SSPTBCR0Wr;          // Write enable for SSPTBCR0
input         SSPTBCR1Wr;          // Write enable for SSPTBCR1
input         SSPTBCR2Wr;          // Write enable for SSPTBCR2
input         SSPTBSRWr;           // Write enable for SSPTBSR
input         SSPTBPREWr;          // Write enable for SSPTBPRE
input         SSPTBTDRWr;          // Write enable for SSPTBTDR
input         SSPTBRDRWr;          // Write enable for SSTBRDR
input         SSPTBSETPINSWr;      // Write enable for SSTBSETPINS
input         SSPTBCLKREGWr;       // Write enable for SSSPTBCLKREG
input         SSPTBCLKREG1Wr;      // Write enable for SSSPTBCLKREG1
input         SSPTBDMACRWrEn;      // Write Enable for UTDMACR
input  [15:0] PWDATAIn;            // Int PWDATA
input         SSPTXDMACLRStag2;    // For UARTTXDMACLR
input         SSPRXDMACLRStag2;    // For UARTRXDMACLR
output        CR0Update;           // Update trigger of Cntl Reg0 
output        CR1Update;           // Update trigger of Cntl Reg1 
output [15:0] SSPTBCR0;            // Cntl Reg0 
output  [5:0] SSPTBCR1;            // Cntl Reg1 
output [10:0] SSPTBCR2;            // SSPTBCR2  Reg
output [10:0] SSPTBSR;             // SSP Trickbox Status Register
output [15:0] SSPTBCLKREG;         // Clk Register 
output [15:0] SSPTBCLKREG1;        // Clk Register 
output  [6:0] SSPTBSETPINS;        // CLK and RST Cntl Reg     
output  [3:0] SSPTBPRE;            // Prescale Reg 
output  [1:0] SSPTDMACR;           // DMACR bits

// -----------------------------------------------------------------------------
//
//                               SspTrRegCore
//                               ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block contains the registers in the SSPTrickBox. The writable 
// registers are SSPTBCR0, SSPTBCR1,SSPTBCR2, SSPTBTDR, SSPTBRDR, SSPTBPRE,
// SSPTBBCLREG, SSPTBSETPINS and SSICR. 
// Out of these, writes to SSPTBTDR go to the Transmit FIFO register. 
// The entire contents of SSPTBCR0 and  two bit of SSPTBCR1 need to be 
// synchronised to the SSPCLK domain. These registers contain bit fields that 
// need to remain coherent during the synchronisation process. Use of double 
// synchronisation does not guarantee this. Hence, a two-buffer synchronisation
// technique is used for synchronisation. The first stage required for this
// technique is implemented in this module. In the case of SSPTBCR1, 2 bits need
// to be synchronised to the SSPCLK domain. These bits are single-bit fields
// and hence double sunchronisation is used to synchronise these bits to the
// SSPCLK domain. 
// The first buffer is written to, when the write enable input for the 
// corresponding register is asserted. 
//
// -----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire Declarations
// ----------------------------------------------------------------------------
wire        PCLK;
// APB bus clock

wire        PRESETn;
// APB bus Reset

wire        SSPTBCR0Wr;
// Write enable for SSPTBCR0

wire        SSPTBCR1Wr;
// Write enable for SSPTBCR1

wire        SSPTBCR2Wr;
// Write enable for SSPTBCR2

wire        SSPTBSRWr;
// Write enable for SSPTBSR

wire        SSPTBPREWr;
// Write enable for SSPTBPRE

wire        SSPTBTDRWr;
// Write enable for SSPTBTDR

wire        SSPTBRDRWr;
// Write enable for SSTBRDR

wire        SSPTBSETPINSWr;
// Write enable for SSTBSETPINS

wire        SSPTBCLKREGWr;
// Write enable for SSSPTBCLKREG

wire        SSPTBCLKREG1Wr;
// Write enable for SSSPTBCLKREG1

wire        SSPTBDMACRWrEn;
// Write enable for UTDMACR

wire [15:0] PWDATAIn;
// Int PWDATA

wire        SSPTXDMACLRStag2;
// For UARTTXDMACLR;

wire        SSPRXDMACLRStag2;
// For SSPRXDMACLRStag2;

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [3:0] iSSPTBPRE;
// SSPTBPRE 

reg  [3:0] NextSSPTBPRE;
// D-input of iSSPTBPRE

reg [15:0] iSSPTBCR0;
// SSPTBCR0 First stage buffer

reg [15:0] NextSSPTBCR0;
// D-input of iSSPTBCR0

reg  [5:0] iSSPTBCR1;
// SSPTBCR1 Register

reg [10:0] iSSPTBCR2;
// SSPTBCR2 First stage buffer

reg  [5:0] NextSSPTBCR1;
// D-input of iSSPTBCR1

reg [10:0] NextSSPTBCR2;
// D - input of iSSPTBCR2

reg [11:0] iSSPTBSR;
// SSPTBSR First stage buffer

reg [11:0] NextSSPTBSR;
// D-input of iSSPTBSR

reg  [6:0] iSSPTBSETPINS;
// SSPTBSETPINS First stage buffer

reg  [6:0] NextSSPTBSETPINS;
// D-input of iSSPTBSETPINS

reg [15:0] iSSPTBCLKREG;
// SSPTBCLKREG First stage buffer

reg [15:0] iSSPTBCLKREG1;
// SSPTBCLKREG1 First stage buffer

reg [15:0] NextSSPTBCLKREG;
// D-input of iSSPTBCLKREG         

reg [15:0] NextSSPTBCLKREG1;
// D-input of iSSPTBCLKREG1        

reg        iCR0Update;
// Internal copy of CR0Update output

reg        iCR1Update;
// Internal copy of CR1Update output

reg        NextCR0Update;
// D-input of iCR0Update

reg        NextCR1Update;
// D-input of iCR1Update

reg SSPTXDMACLR;
// SSPTXDMACLR

reg SSPRXDMACLR;
// SSPRXDMACLR

reg NextSSPTXDMACLR;
// D-input of TXDMACLR
  
reg NextSSPRXDMACLR;
// D-input of RXDMACLR

// -----------------------------------------------------------------------------
// 
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Connect local copies to output signals
// -----------------------------------------------------------------------------
// SSPTBCR0
assign SSPTBCR0          = iSSPTBCR0;

// SSPTBCR1
assign SSPTBCR1          = iSSPTBCR1;

// SSPTBCR2
assign SSPTBCR2          = iSSPTBCR2;

// SSPTBSR
assign SSPTBSR           = iSSPTBSR;

// SSPTBSETPINS
assign SSPTBSETPINS      = iSSPTBSETPINS;

// SSPTBCLKREG
assign SSPTBCLKREG       = iSSPTBCLKREG;

// SSPTBCLKREG1
assign SSPTBCLKREG1      = iSSPTBCLKREG1;

// SSPTBPRE
assign SSPTBPRE          = iSSPTBPRE;

// SSPTXDMACLR
assign SSPTDMACR[0]      = SSPTXDMACLR;

// SSPRXDMACLR 
assign SSPTDMACR[1]      = SSPRXDMACLR;

// -----------------------------------------------------------------------------
// Clocked process for the registers in this block. 
// -----------------------------------------------------------------------------
always @( posedge PCLK or  negedge PRESETn)
begin : p_SSESeq
  if (PRESETn == 1'b0) 
    begin
      iSSPTBCR0        <=  16'b0000000000000000;
      iSSPTBCR1        <=  6'b000000;
      iSSPTBCR2        <=  11'b00000000000;
      iSSPTBSR         <=  11'b00000000000;
      iSSPTBSETPINS    <=  7'b0000000;
      iSSPTBPRE        <=  4'b0000;
      iSSPTBCLKREG     <=  16'b000000000000000;
      iSSPTBCLKREG1    <=  16'b000000000000000;
    end
  else 
    begin
      iSSPTBCR1        <= NextSSPTBCR1;
      iSSPTBCR0        <= NextSSPTBCR0;
      iSSPTBCR2        <= NextSSPTBCR2;
      iSSPTBSR         <= NextSSPTBSR;
      iSSPTBSETPINS    <= NextSSPTBSETPINS;
      iSSPTBCLKREG     <= NextSSPTBCLKREG;
      iSSPTBCLKREG1    <= NextSSPTBCLKREG1;
      iSSPTBPRE        <= NextSSPTBPRE;
    end
end   // p_SSESeq;

// -----------------------------------------------------------------------------
// Write interface for First stage buffer.
// Write into the First stage buffers from the Data bus when the corresponding 
// write enable signal is asserted. 
// -----------------------------------------------------------------------------
always @(iSSPTBCR0 or iSSPTBCR2 or iSSPTBCR1 or iSSPTBSR or iSSPTBSETPINS or
         iSSPTBPRE or SSPTBSETPINSWr or SSPTBPREWr or SSPTBCR0Wr or 
         SSPTBCR2Wr or SSPTBCR1Wr or SSPTBSRWr or SSPTBCLKREGWr or 
         SSPTBCLKREG1Wr or iSSPTBCLKREG or iSSPTBCLKREG1 or  PWDATAIn)
begin : p_RegComb
  if (SSPTBCR0Wr == 1'b1) 
    NextSSPTBCR0 = PWDATAIn;
  else 
    NextSSPTBCR0 = iSSPTBCR0;

  if (SSPTBCR1Wr == 1'b1) 
    NextSSPTBCR1 = PWDATAIn[5:0];
  else 
    NextSSPTBCR1 = iSSPTBCR1;

  if (SSPTBCR2Wr == 1'b1)
    NextSSPTBCR2 = PWDATAIn;
  else 
    NextSSPTBCR2 = iSSPTBCR2;

  if (SSPTBSRWr == 1'b1) 
    NextSSPTBSR = PWDATAIn[10:0];
  else 
    NextSSPTBSR = iSSPTBSR;

  if (SSPTBSETPINSWr == 1'b1) 
    NextSSPTBSETPINS = PWDATAIn[6:0];
  else 
    NextSSPTBSETPINS = iSSPTBSETPINS;
  
  if (SSPTBCLKREGWr == 1'b1) 
    NextSSPTBCLKREG = PWDATAIn[15:0];
  else 
    NextSSPTBCLKREG = iSSPTBCLKREG;
  
  if (SSPTBCLKREG1Wr == 1'b1) 
    NextSSPTBCLKREG1 = PWDATAIn[15:0];
  else 
    NextSSPTBCLKREG1 = iSSPTBCLKREG1;
  
  if (SSPTBPREWr == 1'b1) 
    NextSSPTBPRE = PWDATAIn[3:0];
  else 
    NextSSPTBPRE = iSSPTBPRE;
end   // p_RegComb;

// -----------------------------------------------------------------------------
// The iCR0Update signal toggles with every write to the SSPCR0 register
// -----------------------------------------------------------------------------
always @(iCR0Update or SSPTBCR0Wr)
begin : p_UpdtCR0Comb 
  NextCR0Update = iCR0Update;
  if (SSPTBCR0Wr == 1'b1) 
    NextCR0Update =  !(iCR0Update);
end   // p_UpdtCR0Comb;

// -----------------------------------------------------------------------------
// The iCR1Update signal toggles with every write to the SSPCR0 register
// -----------------------------------------------------------------------------
always @(iCR1Update or SSPTBCR1Wr)
begin : p_UpdtCR1Comb 
  NextCR1Update = iCR1Update;
  if (SSPTBCR1Wr == 1'b1) 
    NextCR1Update =  ~(iCR1Update);
end   // p_UpdtCR1Comb;

// -----------------------------------------------------------------------------
// Sequential process for iCR0Update
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_UpdtCR0Seq 
  if (PRESETn == 1'b0) 
    begin
      iCR0Update <= 1'b0;
      iCR1Update <= 1'b0;
    end
  else  
    begin
      iCR0Update <= NextCR0Update;
      iCR1Update <= NextCR1Update;
    end
end   // p_UpdtCR0Seq;

// ----------------------------------------------------------------------------
// Clock PWDATAIn into SSPTDMACR when SSPTBDMACRWrEn is asserted, TX
// ----------------------------------------------------------------------------
always @(SSPTBDMACRWrEn or SSPTXDMACLR or PWDATAIn or SSPTXDMACLRStag2) 
begin : p_TXDMAComb 
  NextSSPTXDMACLR = SSPTXDMACLR;
 
  if (SSPTBDMACRWrEn)
    NextSSPTXDMACLR = PWDATAIn[0];
  else if (SSPTXDMACLRStag2)
    NextSSPTXDMACLR = 1'b0;
end // p_TXDMAComb;

// ----------------------------------------------------------------------------
// Sequential process for SSPTDMACR
// ----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_TXDMASeq
  if (PRESETn == 1'b0)
    SSPTXDMACLR <=  1'b0;
  else 
    SSPTXDMACLR <= NextSSPTXDMACLR;
end // p_TXDMASeq;

// ----------------------------------------------------------------------------
// Clock PWDATAIn into SSPTDMACR when SSPTBDMACRWrEn is asserted, RX
// ----------------------------------------------------------------------------
always @(SSPTBDMACRWrEn or SSPRXDMACLR or PWDATAIn or SSPRXDMACLRStag2) 
begin : p_RXDMAComb 
  NextSSPRXDMACLR = SSPRXDMACLR;
 
  if (SSPTBDMACRWrEn)
    NextSSPRXDMACLR = PWDATAIn[1];
  else if(SSPRXDMACLRStag2)
    NextSSPRXDMACLR = 1'b0;
end // p_RXDMAComb;

// ----------------------------------------------------------------------------
// Sequential process for SSPTDMACR
// ----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn) 
begin : p_RXDMASeq

  if (PRESETn == 1'b0)
    SSPRXDMACLR <= 1'b0;
  else
    SSPRXDMACLR <= NextSSPRXDMACLR;
end // p_RXDMASeq;


// -----------------------------------------------------------------------------
// Connect local copies to output ports
// -----------------------------------------------------------------------------
assign CR0Update  = iCR0Update;
assign CR1Update  = iCR1Update;

endmodule

// --================================  End  ==================================--


