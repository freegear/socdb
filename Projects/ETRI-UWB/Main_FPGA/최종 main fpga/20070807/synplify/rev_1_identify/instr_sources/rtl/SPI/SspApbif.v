// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SspApbif.v.rca
//  File Revision          : 1.5
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------

// Purpose      : APB Interface to generate decodes for write and read
//                accesses to SSP internal registers.

// --=========================================================================--
  
`timescale 1ns/1ps

//------------------------------------------------------------------------------


module SspApbif (
// Inputs
                 PCLK, 

                 PRESETn, 

                 PSEL, 
                 PWRITE, 
                 PENABLE, 
                 PADDR, 

                 PWDATA,

                 TNF, 
                 RNE, 
                 BSY, 
                 RFF, 
                 TFE, 

                 TXRIS,
                 RXRIS,
                 RTRISSync,
                 RORRIS,

                 TXMIS,
                 RXMIS,
                 RTMISSync,
                 RORMIS,


				 TxFFillLevel,
				 RxFFillLevel,
                 RxFRdData, 
                 TxFRdData,

// Outputs
                 PRDATA, 
				 RORIC,
				 RTIC,
				 SPICON,
				 SPIPRE,
				 SPIINTDMA,
				 SPITXDAT,
				 SPIHIDDEN,

				 SPITXDATWr,
                 RxFRdPtrInc 
                );

// Include Defs file
`include "SspDefs.v"

// Inputs
input         PCLK;             // APB Bus Clock
input         PRESETn;          // AMBA Bus Reset
input         PSEL;             // APB Peripheral select
input         PWRITE;           // APB Peripheral Write
input         PENABLE;          // APB Peripheral enable
input  [4:2]  PADDR;            // APB Peripheral address
input  [15:0] PWDATA;           // Write databus

input         TNF;              // Tx FIFO Not Full
input         RNE;              // Rx FIFO Not Empty
input         BSY;              // SSP Busy
input         RFF;              // Rx FIFO Full
input         TFE;              // Tx FIFO Empty

input         TXRIS;            // Tx Raw Interrupt Status
input         RXRIS;            // Rx Raw Interrupt Status
input         RTRISSync;        // Rx Timeout Raw Interrup Status
input         RORRIS;           // Rx Over Run Raw Interrupt Status
input         TXMIS;            // Tx Masked Interrupt Status
input         RXMIS;            // Rx Masked Interrupt Status
input         RTMISSync;        // Rx Timeout Masked Interrup Status
input         RORMIS;           // Rx Over Run Raw Interrupt Status

input  [3:0]  TxFFillLevel;
input  [3:0]  RxFFillLevel;
input  [15:0] RxFRdData;        // Rx Data
input  [15:0] TxFRdData;        // Rx Data

// Output
output [31:0] PRDATA;           // Read Databus
output		  RORIC;
output		  RTIC;

output [3:0]	SPICON;
output [15:0]	SPIPRE;
output [13:0]	SPIINTDMA;
output [15:0]	SPITXDAT;
output [7:0]	SPIHIDDEN;

output	  SPITXDATWr;
output    RxFRdPtrInc;      // Rx FIFO Read

reg  [31:0] PRDATA; 

wire  [4:2] GatedPA;         

wire [15:0] NextPRDATA;         

wire SPICONWr     ;
wire SPIPREWr     ;
wire SPIINTDMAWr  ;
wire SPIINTSTAWr  ; 
wire SPITXDATWr   ; 
wire SPIHIDDENWr  ;     

wire SPICONRd     ;
wire SPIPRERd     ;
wire SPISTARd     ;
wire SPIINTDMARd  ; 
wire SPIINTSTARd  ;
wire SPITXDATRd   ;
wire SPIRXDATRd   ;
wire SPIHIDDENRd  ;     

wire RxFRdPtrInc  ;

wire        WrEn;
wire        RdEn;

`define	SPICONREG		3'b000	
`define	SPIPREREG		3'b001	
`define SPISTAREG		3'b010	
`define	SPIINTDMAREG	3'b011	
`define	SPIINTSTAREG	3'b100	
`define SPITXDATREG		3'b101	
`define SPIRXDATREG		3'b110	
`define SPIHIDDENREG	3'b111	


reg	[3:0]	SPICON;
reg	[15:0]	SPIPRE;
wire[5:0]	SPISTA;
reg	[13:0]	SPIINTDMA;
wire[3:0]	SPIINTSTA;
reg	[15:0]	SPITXDAT;
reg	[7:0]	SPIHIDDEN;

assign	SPISTA 		 = {TxFFillLevel,RxFFillLevel,~TNF,TFE,RFF,~RNE,BSY,1'b0};
assign  SPIINTSTA 	 = {TXRIS,RXRIS,RTRISSync,RORRIS}; // RAW Int Status

assign GatedPA[4:2] = (PSEL == 1'b1) ? PADDR : 3'b000;

assign WrEn          = PENABLE & PSEL & PWRITE; 

assign SPICONWr      = PENABLE & PSEL & PWRITE & (GatedPA == `SPICONREG);
assign SPIPREWr      = PENABLE & PSEL & PWRITE & (GatedPA == `SPIPREREG);
assign SPIINTDMAWr   = PENABLE & PSEL & PWRITE & (GatedPA == `SPIINTDMAREG);
assign SPIINTSTAWr   = PENABLE & PSEL & PWRITE & (GatedPA == `SPIINTSTAREG);
assign SPITXDATWr    = PENABLE & PSEL & PWRITE & (GatedPA == `SPITXDATREG);
assign SPIHIDDENWr	 = PENABLE & PSEL & PWRITE & (GatedPA == `SPIHIDDENREG);
	
assign RdEn          = PSEL & ~PWRITE; 
assign SPICONRd      = RdEn & (GatedPA == `SPICONREG);
assign SPIPRERd      = RdEn & (GatedPA == `SPIPREREG);
assign SPISTARd      = RdEn & (GatedPA == `SPISTAREG);
assign SPIINTDMARd   = RdEn & (GatedPA == `SPIINTDMAREG);
assign SPIINTSTARd   = RdEn & (GatedPA == `SPIINTSTAREG);
assign SPITXDATRd    = RdEn & (GatedPA == `SPITXDATREG);
assign SPIRXDATRd    = RdEn & (GatedPA == `SPIRXDATREG);
assign SPIHIDDENRd	 = RdEn & (GatedPA == `SPIHIDDENREG);

assign RxFRdPtrInc  = PENABLE & PSEL & ~PWRITE & (GatedPA == `SPIRXDATREG); 

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	SPICON <= 4'b0000;
	else if (SPICONWr)
	SPICON <= PWDATA[3:0];
end
// SPICON = SSE,MS,SPH,SPO

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	SPIPRE <= 0;
	else if (SPIPREWr)
	SPIPRE <= PWDATA;
end
// SPIPRE = SSPCPSR(CPSDVSR)  , SCR

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	SPIINTDMA <= 14'b0000000100001;
	else if (SPIINTDMAWr)
	SPIINTDMA <= PWDATA[13:0];
end
// 
//
// Interrupt Clear Bit
reg NextRORIC;
reg	RORIC;
always@(SPIINTSTAWr or RORIC or PWDATA) 
begin 
  NextRORIC   = RORIC;

  if(SPIINTSTAWr == 1'b1)
    NextRORIC = PWDATA[4];
  else
    NextRORIC = 1'b0;
end 

always@(posedge PCLK or negedge PRESETn)
  begin 
    if (PRESETn == 1'b0)
      RORIC <= 1'b0;
    else
      RORIC <= NextRORIC;
  end 


reg NextRTIC;
reg	RTIC;
always@(SPIINTSTAWr or RTIC or RTRISSync or PWDATA) 
begin 
NextRTIC   = RTIC;
    if(SPIINTSTAWr == 1'b1)
      NextRTIC = PWDATA[5];
    else
    if(RTRISSync == 1'b0)
      NextRTIC = 1'b0;
end 

always@(posedge PCLK or negedge PRESETn)
begin : p_RTICSeq 
	if(PRESETn == 1'b0)
      RTIC <= 1'b0;
    else
      RTIC <= NextRTIC;
end 


always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	SPITXDAT <= 0;
	else if (SPITXDATWr)
	SPITXDAT <= PWDATA;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	SPIHIDDEN <= 8'b01110000; // Default 8bit mode
	else if (SPIHIDDENWr)
	SPIHIDDEN <= PWDATA[7:0];
end

assign  NextPRDATA = 
        (SPICONRd        == 1'b1)  ? {12'd0,SPICON}		: (
        (SPIPRERd        == 1'b1)  ? {SPIPRE}   		: (
        (SPISTARd        == 1'b1)  ? {2'b00,SPISTA}	    : (
        (SPIINTDMARd     == 1'b1)  ? {2'b00,SPIINTDMA}	: (
        (SPIINTSTARd     == 1'b1)  ? {12'd0,SPIINTSTA}	: (
		(SPITXDATRd      == 1'b1)  ? {SPITXDAT}			: (
        (SPIRXDATRd      == 1'b1)  ? {RxFRdData}        : (
        (SPIHIDDENRd      == 1'b1) ? {8'd0,SPIHIDDEN}   : (
        16'h0000))))))));

always @ (posedge PCLK or negedge PRESETn) 
begin
  if (PRESETn == 1'b0) 
    PRDATA  <= 32'b0;
  else
    PRDATA  <= {15'd0,NextPRDATA};
end 
endmodule

// --============================ End ========================================--
