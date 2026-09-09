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

module NFSsp ( 
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

            PRDATA 
            
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

wire        TxRxBSY; 
// Denotes SSP is transmitting or receiving

wire        BSY; 
// Denotes SSP is busy or TXFIFO is not empty

//wire [15:0] TxFRdData; 
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

wire        RXRIS;        
// Receive FIFO Raw Interrupt Source

//wire        RXMIS;        
// Receive FIFO Masked Interrupt Source

wire        TXRIS;        
// Transmit FIFO Raw Interrupt Source

//wire        TXMIS;        
// Transmit FIFO Masked Interrupt Source

wire        TXIM;        
// Tx  fifo Interrupt Mask

wire        RXIM;        
// Rx fifo Interrupt Mask 

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

//wire        DataStp;
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

wire        MRxRT;
// MasterRx Reload Timeout counter signal

wire        SRxRT;
// Slave Rx Reload Timeout counter signal
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
wire [2:0]	SPIINTDMA;
wire [15:0]	SPITXDAT;
wire [7:0]	SPIHIDDEN;

wire RORIM;
wire RORRIS;

assign SSE 			= SPICON[3];
assign MS			= SPICON[2];
assign SPO 			= SPICON[1];
assign SPH 			= SPICON[0];


assign SCR 			= SPIPRE[7:0];
assign SSPCPSR 		= SPIPRE[15:9];

assign DSS			= SPIHIDDEN[7:4];
assign SOD          = SPIHIDDEN[1];
assign LBM          = SPIHIDDEN[0];



assign RORIM			= SPIINTDMA[2];
assign RXIM         = SPIINTDMA[1];
assign TXIM			= SPIINTDMA[0];

//assign DSSPCLK      = SSPCR0[3:0];
assign DSSPCLK      = DSS;

assign SSPFSSOUT    = IntSSPFSSOUT; 
assign SSPCLKOUT    = IntSSPCLKOUT; 
assign SSPTXD       = IntSSPTXD; 
assign nSSPOE       = IntnSSPOE;
assign nSSPCTLOE    = IntnSSPCTLOE;
  
assign SSPINTR      = IntSSPINTR;

wire	RxWrite;
wire	SPITXDATRd;
wire	RXRISPulse;
wire	TXRISPulse;
assign RXRISPulse = RxWrite; // Receive Done Interrupt (or Transmit Done )
//assign RXRISPulse = RxFWr ; // Receive Done Interrupt (or Transmit Done )
//assign TXRISPulse = TxFRdPtrInc; // Tx Buffer Empty Interrupt
assign TXRISPulse = SPITXDATRd; // Tx Buffer Empty Interrupt
assign INTR = (TXIM & TXRIS)|(RXIM & RXRIS)|(RORIM&RORRIS); 

//assign TXMIS = TXIM & TXRIS;
//assign RXMIS = RXIM & RXRIS;
//assign RORMIS = RORIM & RORRIS;

// -----------------------------------------------------------------------------
// The APB Interface contains the Write interface and the Read interface
// for registers in the SSP.
// -----------------------------------------------------------------------------
NFSspApbif uNFSspApbif            (
             .PCLK            (PCLK),
             .PRESETn         (PRESETn),
             .PSEL            (PSEL),
             .PWRITE          (PWRITE),
             .PENABLE         (PENABLE),
             .PADDR           (PADDR),
             .PWDATA          (PWDATA),
             .BSY             (BSY),
             
			 .TXRISPulse      (TXRISPulse),
             .RXRISPulse      (RXRISPulse),
			 .RORRIS		  (RORRIS),
             
			 //.TXMIS           (TXMIS),
             //.RXMIS           (RXMIS),
		
			// .TXRISClr		  (SPITXDATWr), // TXBuffer Empty clr
			 .RXRISClr		  (RxFRdPtrInc), // RX Buffer Full Clr
			 .RORIC			  (RORIC),

			 .RxFRdData       (RxFRdData),
             //.TxFRdData       (TxFRdData),

             .PRDATA          (PRDATA),
			 .SPICON		  (SPICON),
			 .SPIPRE		  (SPIPRE),
			 .SPIINTDMA		  (SPIINTDMA),
			 .SPITXDAT		  (SPITXDAT),
			 .SPIHIDDEN		  (SPIHIDDEN),

			.TXRIS(TXRIS),
			.RXRIS(RXRIS),

			 .SPITXDATWr	  (SPITXDATWr),
             .RxFRdPtrInc     (RxFRdPtrInc)
           );




// -----------------------------------------------------------------------------
// The SspTxFIFO block contains the Transmit FIFO and the control logic
// required to regulate accesses to the FIFO.
// -----------------------------------------------------------------------------
 NFSspTxNoFIFO uNFSspTxNoFIFO (
			.PCLK            (PCLK),
			.PRESETn         (PRESETn), 
			.DSSPCLK	     (DSSPCLK),
			.SPITXDATWr      (SPITXDATWr),
			.TxFRdPtrInc	 (TxFRdPtrInc),
			.TxRxBSY	 	 (TxRxBSY),
			.PWDATAIn	     (PWDATA[15:0]),
			
			.TxDataAvlbl	 (TxDataAvlbl),
			.SPITXDATRd		 (SPITXDATRd),
			.BSY			 (BSY),
			.SPITXOUTDAT     (TxFRdDataIn)
);

// -----------------------------------------------------------------------------
// The SspRxFIFO block contains the Receive FIFO and the control logic
// required to regulate accesses to the FIFO.
// -----------------------------------------------------------------------------
 NFSspRxNoFIFO uNFSspRxNoFIFO (
			.PCLK			(PCLK),
			.PRESETn		(PRESETn),
			.RORIC			(RORIC),
			.MS				(MS),
			.RxFWr			(RxFWr), 
			.RxFRdPtrInc	(RxFRdPtrInc), 
			.SRxFWrData		(SRxFWrData),	 
			.MRxFWrData		(MRxFWrData),
			.RxWrite		(RxWrite),
			.RNE			(RNE),
			.RORRIS			(RORRIS),
			.RxFRdData		(RxFRdData)
);

// -----------------------------------------------------------------------------
// The SspIntGen block combines the three individual interrupts     .SPRFSINTR,
// SSPTFSINTR and SSPRORINTR by ORing them and the resultant signal is 
// clocked out as SSPINTR.
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// The SspTest block generates Test clock enable and Test reset for the SSP
// It also contains logic to perform Test muxing on non-AMBA inputs to the SSP
// -----------------------------------------------------------------------------
 NFSspTest uNFSspTest             (
             .LBM             (LBM),

             .SSPRXD          (SSPRXD),

             .INTR            (INTR),

             .FSSOUT          (FSSOUT),
             .CLKOUT          (CLKOUT),
             .TXD             (TXD),
             .nCTLOE          (nCTLOE),
             .nOE             (nOE),
          
          
             .IntSSPRXD       (IntSSPRXD),
			 
             .IntSSPINTR      (IntSSPINTR),

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
 NFSspScaleCntr uNFSspScaleCntr (
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
 NFSspMTxRxCntl uNFSspMTxRxCntl (
             .PCLK            (PCLK),
             .PRESETn         (PRESETn),

             .DSS             (DSS),

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

             .MRxRT           (MRxRT)
             );

// -----------------------------------------------------------------------------
// The SspSTxRxCntl block contains the main Transmit/Receive Slave mode control
// logic in the SSP.
// -----------------------------------------------------------------------------
   NFSspSTxRxCntl uNFSspSTxRxCntl  (
            .PCLK          	 (PCLK),
        
            .PRESETn         (PRESETn),

            .TXD             (TXD),
            .nOE             (nOE),
        
            .DSS             (DSS),       
                                       
                                       
            .SPO             (SPO),
            .SPH             (SPH),
       
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
endmodule

   
// --================================== End ==================================--
