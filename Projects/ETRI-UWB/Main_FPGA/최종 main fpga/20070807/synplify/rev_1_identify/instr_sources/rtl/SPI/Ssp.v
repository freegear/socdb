// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : Ssp.v.rca
//  File Revision          : 1.6
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//  Purpose          : This block is the top level of the SSP.

// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module Ssp ( 
// Inputs
            PCLK, 
            PRESETn, 
            PADDR, 
            PSEL, 
            PENABLE, 
            PWRITE, 
            PWDATA, 

// Outputs 
            SSPINTR, 

            SSPRXD, 
            SSPFSSIN, 
            SSPCLKIN,

            SSPFSSOUT, 
            SSPCLKOUT,

            SSPTXD, 
            nSSPOE, 
            nSSPCTLOE,

            PRDATA ,
			TxDMAReq,
			RxDMAReq
            
           );

// Inputs
input          PCLK;            // APB Bus Clock
input          PRESETn;         // AMBA Bus Reset
input          PSEL;            // APB Peripheral select
input          PENABLE;         // APB Peripheral enable
input          PWRITE;          // APB Peripheral write
input          SSPRXD;          // SSP Receive input
input          SSPCLKIN;        // SSP Serial Clock input
input          SSPFSSIN;        // SSP Serial Frame input
input   [4:2]  PADDR;           // APB Address Bus
input   [15:0] PWDATA;          // APB Write databus

//Outputs
output         SSPINTR;         // Combined Interrupt
output         SSPFSSOUT;       // Serial Frame Output pin
output         SSPCLKOUT;       // Serial Clock Output pin
output         SSPTXD;          // SSP Serial Transmit output
output         nSSPOE;          // Output Enable for SSPTXD
output         nSSPCTLOE;       // Output Enable for SSPCLKOUT and SSPFSSOUT
output  [31:0] PRDATA;          // Read databus

output		   TxDMAReq;
output		   RxDMAReq;

// -----------------------------------------------------------------------------
// 
//                                  Ssp
//                                  ===
// 
// -----------------------------------------------------------------------------
// 
// Overview
// ========
// 
//  This module instantiates the following sub-modules: 
// 
// 1.  SspApbif          - APB Interface
// 2.  SspRegCore        - Register Block
// 3.  SspRxFIFO         - Receive FIFO
// 4.  SspTxFIFO         - Transmit FIFO
// 5.  SspScaleCntr      - SSP Clock Pre-scaler
// 6.  SspMTxRxCntl      - Transmitter/Receiver Master mode
// 7.  SspSTxRxCntl      - Transmitter/Receiver Slave mode
// 8.  SspIntGen         - Interrupt Generator
// 11. SspTest           - Test Logic 
// 12. SspDMA            - DMA Interface
//  The module SspRevAnd used as a place-holder cell to mark the
// Revision of the Ssp. It contains a 2 input AND gate. The 2 input
// pins are tied-off at the top level of the hierarchy. These "TieOffs"
// can be identified during layout and re-wired to "VDD" or "VSS"
// if needed.  
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        RNE;
// Denotes RXFIFO not empty
 
wire [15:0] RxFRdData; 
// RXFIFO Read data bus

wire        RxFRdPtrInc; 
// RXFIFO Read Pointer Increment Signal

wire        TNF; 
// TXFIFO not full

wire        TxFRdPtrInc; 
// TXFIFO Read Pointer Increment Signal

wire        TxDataAvlbl;
// TXFIFO Data available  

wire        SPH; 
// Indicates phase of SCLK in SPI mode

wire        SPO; 
// Indicates polarity of SCLK in SPI mode

wire  [7:0] SCR;
// Serial clock rate
 
wire  [1:0] FRF; 
// Frame format

wire  [3:0] DSS; 
// Specifies Datasize to be transmited

wire        SSPCLKDIV; 
// SSPCLOCK Division signal

wire        RxFWr; 
//  Reciever Fifo write signal

wire [15:0] MRxFWrData; 
// RXFIFO Data to be written in Master mode

wire [15:0] SRxFWrData; 
// RXFIFO Data to be written in Slave mode

wire        TFE; 
// TXFIFO Empty signal

wire        RFF; 
// Denotes RXFIFO full

wire        TxRxBSY; 
// Denotes SSP is transmitting or receiving

wire        BSY; 
// Denotes SSP is busy or TXFIFO is not empty

wire [15:0] TxFRdData; 
//  TXFIFO Read data bus (direct from fifo)

wire [15:0] TxFRdDataIn; 
//  TXFIFO Read data bus (left justified fifo data)

wire [7:1]  SSPCPSR; 
//  SSP Clock Pre-scale Register

wire [6:0]  SSPCPSC; 
//  SSP Pre-scale Counter

wire        LBM;
//  Loop Back Mode
  
wire        SSE;
//  SSP Enable signal
 
wire        MS;
//  Master/Slave Select signal
 
wire        SOD;
//  Slave Output Disable Signal
 
wire [3:0]  DSSPCLK;
// Data Size Select Signal in PCLK domain

wire [1:0]  FRFPCLK;
// Frame Format Select Signal in PCLK domain

wire        RXRIS;        
// Receive FIFO Raw Interrupt Source

wire        RXMIS;        
// Receive FIFO Masked Interrupt Source

wire        TXRIS;        
// Transmit FIFO Raw Interrupt Source

wire        TXMIS;        
// Transmit FIFO Masked Interrupt Source

wire        RORRIS;        
// Rx FIFO Overrun Raw Interrupt Source

wire        RORMIS;        
// Rx FIFO Overrun Masked Interrupt Source

wire        RTMIS;        
// Rx Receive Time Out Masked Interrupt

wire        TXIM;        
// Tx  fifo Interrupt Mask

wire        RXIM;        
// Rx fifo Interrupt Mask 

wire        RTIM;        
// Rx Receive Timeout Interrupt Mask 

wire        RORIM;        
// Rx Over Run  Interrupt Mask

wire        NextSTXD;        
// D-input of Slave's Serial Transmit output

wire        NextnSOE;        
// Output Enable for Slave's SSPTXD signal

wire        NextSTxRxBSY;
// D-input of Slave's TxRxBSY signal

wire        NxtSTxFRdPtrInc;
// D-input of Slave's TXFIFO Read Pointer Increment signal

wire        NextSRxFWr;
// D-input of Slave's RXFIFO Write signal

wire        TXDMAE;
//  SSP Tx DMA Enable control bit in SSPDMACR

wire        RXDMAE;
//  SSP Rx DMA Enable control bit in SSPDMACR

wire        FIFOLTE7Full;
//  SSP TX FIFO has one or more spaces

wire        DataStp;
//  Rx Data Stopped Time Out signal

wire        FSSOUT;
//  FSSOUT integration test mux input 

wire        CLKOUT;
//  CLKOUT integration test mux input

wire        TXD;
//  SSPTXD integration test mux input

wire        nCTLOE;
//  nSSPCTLOE integration test mux inout

wire        nOE;
//  nSSPOEint prior to integration test mux

wire        RORINTR;
// RORINTR prior to integration test mux

wire        RTINTR;
// RTINTR prior to integration test mux

wire        INTR;
// INTR prior to integration test mux

wire        IntSSPRXD;
// SSPRXD integration test mux output


wire        IntSSPINTR;
// INTR integration test mux output

wire        IntSSPFSSOUT;
// FSSOUT integration test mux output

wire        IntSSPCLKOUT;
// CLKOUT integration test mux output

wire        IntSSPTXD;
// TXD integration test mux output

wire        IntnSSPCTLOE;
// nCTLOE integration test mux output

wire        IntnSSPOE;
// nSSPOE integration test mux output

wire        RORIC;
// Rx Over Run Interrupt Clear

wire        RTIC;
// Rx Time Out Interrupt Clear

wire        MRxRT;
// MasterRx Reload Timeout counter signal

wire        SRxRT;
// Slave Rx Reload Timeout counter signal

wire        IncRxTimeOut;
  // Rx Time Out Counter Enable 

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Assigning register bits to Local wires 
// -----------------------------------------------------------------------------
wire [3:0]	SPICON;
wire [15:0]	SPIPRE;
wire [13:0]	SPIINTDMA;
wire [15:0]	SPITXDAT;
wire [7:0]	SPIHIDDEN;


wire [3:0] TxFFillLevel;
wire [3:0] RxFFillLevel;

wire [3:0] TxDMALevel;
wire [3:0] RxDMALevel;
wire TxDMAReqEn	 ;
wire RxDMAReqEn	 ;


assign SSE 			= SPICON[3];
assign MS			= SPICON[2];
assign SPO 			= SPICON[1];
assign SPH 			= SPICON[0];


assign SCR 			= SPIPRE[7:0];
assign SSPCPSR 		= SPIPRE[15:9];

assign DSS			= SPIHIDDEN[7:4];
assign FRF			= SPIHIDDEN[3:2];
assign SOD          = SPIHIDDEN[1];
assign LBM          = SPIHIDDEN[0];



assign TXIM			= SPIINTDMA[13];
assign RXIM         = SPIINTDMA[12];
assign RTIM         = SPIINTDMA[11];
assign RORIM        = SPIINTDMA[10];

assign TxDMALevel	= SPIINTDMA[8:5];
assign RxDMALevel	= SPIINTDMA[3:0];

assign TxDMAReqEn	= SPIINTDMA[9];
assign RxDMAReqEn	= SPIINTDMA[4] ;

//assign FRFPCLK      = SSPCR0[5:4];
//assign DSSPCLK      = SSPCR0[3:0];
assign FRFPCLK      = FRF;
assign DSSPCLK      = DSS;


assign TXDMAE       = SPIINTDMA[9]; // Tx DMA Enable
assign RXDMAE       = SPIINTDMA[4]; // Rx DMA Enable

assign SSPFSSOUT    = IntSSPFSSOUT; 
assign SSPCLKOUT    = IntSSPCLKOUT; 
assign SSPTXD       = IntSSPTXD; 
assign nSSPOE       = IntnSSPOE;
assign nSSPCTLOE    = IntnSSPCTLOE;
  
assign SSPINTR      = IntSSPINTR;


// -----------------------------------------------------------------------------
// The APB Interface contains the Write interface and the Read interface
// for registers in the SSP.
// -----------------------------------------------------------------------------
SspApbif uSspApbif            (
             .PCLK            (PCLK),
             .PRESETn         (PRESETn),
             .PSEL            (PSEL),
             .PWRITE          (PWRITE),
             .PENABLE         (PENABLE),
             .PADDR           (PADDR),
             .PWDATA          (PWDATA),
             .TNF             (TNF),
             .RNE             (RNE),
             .BSY             (BSY),
             .RFF             (RFF),
             .TFE             (TFE),
             
			 .TXRIS           (TXRIS),
             .RXRIS           (RXRIS),
             .RTMISSync		  (RTINTR),
             .RTRISSync       (DataStp),
             .RORRIS          (RORRIS),
             
			 .TXMIS           (TXMIS),
             .RXMIS           (RXMIS),
             .RORMIS          (RORMIS),
             
			 .TxFFillLevel	  (TxFFillLevel),
			 .RxFFillLevel	  (RxFFillLevel),

			 .RxFRdData       (RxFRdData),
             .TxFRdData       (TxFRdData),

             .PRDATA          (PRDATA),
			 .RORIC			  (RORIC),
			 .RTIC			  (RTIC),
			 .SPICON		  (SPICON),
			 .SPIPRE		  (SPIPRE),
			 .SPIINTDMA		  (SPIINTDMA),
			 .SPITXDAT		  (SPITXDAT),
			 .SPIHIDDEN		  (SPIHIDDEN),


			 .SPITXDATWr	  (SPITXDATWr),
             .RxFRdPtrInc     (RxFRdPtrInc)
           );




// -----------------------------------------------------------------------------
// The SspTxFIFO block contains the Transmit FIFO and the control logic
// required to regulate accesses to the FIFO.
// -----------------------------------------------------------------------------
 SspTxFIFO uSspTxFIFO         (
             .PCLK            (PCLK),
             .PRESETn         (PRESETn), 
             .MS              (MS),
             .SSPDRWr         (SPITXDATWr),
             .TxFRdPtrIncSync (TxFRdPtrInc),
             .TxRxBSYSync     (TxRxBSY),
             .TXIM            (TXIM),
             .FRFPCLK         (FRFPCLK),
             .DSSPCLK         (DSSPCLK),
             .PWDATAIn        (PWDATA[15:0]),
			 .TxDMALevel	  (TxDMALevel),

             .TNF             (TNF), 
             .TFE             (TFE),
             .BSY             (BSY),
             .TXRIS           (TXRIS),
             .TXMIS           (TXMIS),
             .FIFOLTE7Full    (FIFOLTE7Full),
             .TxDataAvlbl     (TxDataAvlbl),
             .TxFRdData       (TxFRdData),
             .TxFRdDataIn     (TxFRdDataIn),
			 .TxFFillLevel	  (TxFFillLevel)
             );

// -----------------------------------------------------------------------------
// The SspRxFIFO block contains the Receive FIFO and the control logic
// required to regulate accesses to the FIFO.
// -----------------------------------------------------------------------------
 SspRxFIFO uSspRxFIFO     (
             .PCLK        (PCLK),
             .PRESETn     (PRESETn),
             .RXIM        (RXIM),
             .RORIM       (RORIM),
             .RORIC       (RORIC),
             .RxFWrSync   (RxFWr),
             .RxFRdPtrInc (RxFRdPtrInc),
             .MS          (MS),
             .SRxFWrData  (SRxFWrData),
             .MRxFWrData  (MRxFWrData),
			 .RxDMALevel  (RxDMALevel),

             .RNE         (RNE),
             .RFF         (RFF),
             .RXRIS       (RXRIS),
             .RORRIS      (RORRIS),
             .RXMIS       (RXMIS),
             .RORMIS      (RORMIS),
             .RxFRdData   (RxFRdData),
			 .RxFFillLevel(RxFFillLevel)
             );

// -----------------------------------------------------------------------------
// The SspIntGen block combines the three individual interrupts     .SPRFSINTR,
// SSPTFSINTR and SSPRORINTR by ORing them and the resultant signal is 
// clocked out as SSPINTR.
// -----------------------------------------------------------------------------
 SspIntGen uSspIntGen  (
             .TXMIS    (TXMIS),
             .RXMIS    (RXMIS),
             .RORMIS   (RORMIS),
             .DataStp  (DataStp),
             .RTIMSync (RTIM),
             .RORIC    (RORIC),
             .RTIC     (RTIC),
             .RORINTR  (RORINTR),
             .RTINTR   (RTINTR),
             .INTR     (INTR)
             );

// -----------------------------------------------------------------------------
// The SspTest block generates Test clock enable and Test reset for the SSP
// It also contains logic to perform Test muxing on non-AMBA inputs to the SSP
// -----------------------------------------------------------------------------
 SspTest uSspTest             (
             .PCLK            (PCLK),
             .PRESETn         (PRESETn),

             .LBM             (LBM),

             .SSPRXD          (SSPRXD),

             .TXMIS           (TXMIS),
             .RXMIS           (RXMIS),
             .RORINTR         (RORINTR),
             .RTINTR          (RTINTR),
             .INTR            (INTR),

             .FSSOUT          (FSSOUT),
             .CLKOUT          (CLKOUT),
             .TXD             (TXD),
             .nCTLOE          (nCTLOE),
             .nOE             (nOE),
          
          
             .IntSSPRXD       (IntSSPRXD),
			 
             .IntSSPINTR      (IntSSPINTR),
                  
			 .IntSSPTXINTR		(IntSSPTXINTR),
             .IntSSPRXINTR		(IntSSPRXINTR),
             .IntSSPRTINTR		(IntSSPRTINTR),
             .IntSSPRORINTR		(IntSSPRORINTR),

             .IntSSPFSSOUT    (IntSSPFSSOUT),
             .IntSSPCLKOUT    (IntSSPCLKOUT),
             .IntSSPTXD       (IntSSPTXD),
             .IntnSSPCTLOE    (IntnSSPCTLOE),
             .IntnSSPOE       (IntnSSPOE)
         );

// -----------------------------------------------------------------------------
// The SspScaleCntr block contains a pre-scaling counter that scales down
// the PCLK input in accordance with the value programmed in the SSPCPSR
// register. This block also contains the PCLK-domain part of the control
// logic required to synchronise the contents of SSPCR0 and SSPCPSR registers
// to the PCLK domain.
// -----------------------------------------------------------------------------
 SspScaleCntr uSspScaleCntr (
             .PCLK           (PCLK),
            
             .PRESETn        (PRESETn),
            
             .SSESync        (SSE),
             .SSPCPSR        (SSPCPSR),

             .SSPCLKDIV      (SSPCLKDIV),
             .SSPCPSC        (SSPCPSC)
            );

// -----------------------------------------------------------------------------
// The SspMTxRxCntl block contains the main Transmit/Receive Master mode control
// logic in the SSP.
// -----------------------------------------------------------------------------
 SspMTxRxCntl uSspMTxRxCntl (
             .PCLK            (PCLK),
             .PRESETn         (PRESETn),

             .DSS             (DSS),

             .FRF             (FRF),

             .SCR             (SCR),

             .SPO             (SPO),
             .SPH             (SPH),

             .SSESync         (SSE),
             .SSPCLKDIV       (SSPCLKDIV),
        
             .TxDataAvlblSync (TxDataAvlbl),
             .TxFRdDataIn     (TxFRdDataIn),

             .IntSSPRXD       (IntSSPRXD),
             .MSSync          (MS),
             .NextnSOE        (NextnSOE),
                                       
             .NextSTXD        (NextSTXD),
 
             .NextSRxFWr      (NextSRxFWr),
                                       
             .NxtSTxFRdPtrInc (NxtSTxFRdPtrInc),
                                       
             .NextSTxRxBSY    (NextSTxRxBSY),

             .RNESync         (RNE),
                                       
             .CLKOUT          (CLKOUT),
             .FSSOUT          (FSSOUT),
             .TXD             (TXD),
             .nCTLOE          (nCTLOE),
             .nOE             (nOE),

             .TxFRdPtrInc     (TxFRdPtrInc),
             .RxFWr           (RxFWr),
             .MRxFWrData      (MRxFWrData),     
                                        
             .TxRxBSY         (TxRxBSY),

             .MRxRT           (MRxRT),
             .IncRxTimeOut    (IncRxTimeOut)
             );

// -----------------------------------------------------------------------------
// The SspSTxRxCntl block contains the main Transmit/Receive Slave mode control
// logic in the SSP.
// -----------------------------------------------------------------------------
   SspSTxRxCntl uSspSTxRxCntl  (
            .PCLK          	 (PCLK),
        
            .PRESETn         (PRESETn),

            .TXD             (TXD),
            .nOE             (nOE),
        
            .DSS             (DSS),       
                                       
            .FRF             (FRF),     
                                       
            .SCR             (SCR),      
                                       
            .SPO             (SPO),
            .SPH             (SPH),
            .SSPCLKDIV       (SSPCLKDIV),
       
            .CLKINSync       (SSPCLKIN),
            .FSSINSync       (SSPFSSIN),
            .SSESync         (SSE),
            .MSSync          (MS),
            .SODSync         (SOD),
            .TxFRdDataIn     (TxFRdDataIn),    
                                       
            .TxFRdPtrInc     (TxFRdPtrInc),
            .RxFWr           (RxFWr),
            .TxRxBSY         (TxRxBSY),
            .IntSSPRXD       (IntSSPRXD),
 
            .NxtSTxFRdPtrInc (NxtSTxFRdPtrInc),
                                        
            .NextSTxRxBSY    (NextSTxRxBSY),
                                        
            .NextSRxFWr      (NextSRxFWr),
                                        
            .NextnSOE        (NextnSOE),
            .NextSTXD        (NextSTXD),
            .SRxFWrData      (SRxFWrData),   
                                        
            .SRxRT           (SRxRT)
             );

  SspDataStp uSspDataStp (

            .PCLK         (PCLK),
            .PRESETn      (PRESETn),
        
            .IncRxTimeOut (IncRxTimeOut),
        
            .MRxRT        (MRxRT),
            .SRxRT        (SRxRT),        
            .RNESync      (RNE),
            .RTICSync     (RTIC),
        
            .DataStp      (DataStp)
    );
  
	// Use New DMAC
  SspNewDMA	uSspNewDMA(
			.TxFFillLevel	(TxFFillLevel),
			.RxFFillLevel	(RxFFillLevel),
		
			.TxDMALevel		(TxDMALevel),
			.RxDMALevel		(RxDMALevel),
		
			.TxDMAReqEn		(TxDMAReqEn),
			.RxDMAReqEn		(RxDMAReqEn),
		
			.TxDMAReq		(TxDMAReq),
			.RxDMAReq		(RxDMAReq)
	);

endmodule

   
// --================================== End ==================================--
