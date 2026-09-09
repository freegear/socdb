//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : Outport2.v,v
//  File Revision      : 1.8
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural sub-block architecture of Example Amba
//                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
//                        Outport 2.
//
//                        The module contains the following AHB device:
//
//                          - APBif
//
//                        The module contains the following APB devices:
//
//                          - Peripheral to bridge mux (MuxP2B)
//                          - Watchdog
//                          - Timers
//                          - GPIO PrimeCell (PL061)
//                          - Remap and Pause controller
//                          - Example APB Slave
//
//                        HREADYOUT is looped back to HREADY as the APBif
//                        is the only AHB slave in this module.
//  --========================================================================--

`timescale 1ns/1ps

module Outport2 (
	HCLK, 
	HRESETn, 
	HADDR, 
	HBURST, 
	HPROT, 
	HREADYmtrx, 
	HSELmtrx, 
        HSIZE, 
	HTRANS, 
	HWDATA, 
	HWRITE, 
	HRDATA, 
	HREADYOUT, 
	HRESP, 
        TIMINT1, 
	TIMINT2, 
	TIMINTC, 
	WDOGRESn, 
	WDOGRES, 
	WDOGINT, 
	nFIQ,
        nIRQ, 
	Pause, 
	Remap, 
	GPIN, 
	nGPAFEN, 
	GPAFOUT, 
	GPOUT,  
	nGPEN, 
        GPAFIN, 
	GPIOINTR, 
	GPIOMIS, 
// UART 
      //PAD
        nUARTCTS,
        nUARTDCD,
        nUARTDSR,
        nUARTRI,
        UARTRXD,
        SIRIN,
        UARTTXD,
        nSIROUT,
        nUARTDTR,
      //Intrrupt
        UARTINTR,       // 9     Combined interrupt
      //UARTDMA
 	UARTRXDMACLR,     
	UARTTXDMACLR,     
	UARTTXDMASREQ,    
	UARTTXDMABREQ,    
	UARTRXDMASREQ,    
	UARTRXDMABREQ,    
// MMC
      //PAD
        MCLK,            
        nMCLK,           
        MMCIFBCLK,       
        nMMCIRST,        
        MMCICMDIN,       
        MMCIDATIN,
         	
        MMCICLKOUT,   
        MMCICMDOUT,   
        nMMCICMDEN,   
        MMCIDATOUT,   
        nMMCIDATEN,    
        MMCIPWR,      
        MMCIROD,      
        MMCIVDD, 
      
      //Interrupt
	MMCIINTR0,  
	MMCIINTR1,  

      //DMA	
        MMCIDMACLR, 
        MMCIDMASREQ,     
        MMCIDMABREQ,     
        MMCIDMALSREQ,    
        MMCIDMALBREQ,    
// SCI
      //PAD
        SCIDATAIN,
        SCICLKIN,
        SCIDETECT,
        SCIDEACREQ,

        nSCIDATAOUTEN,
        nSCIDATAEN,
        SCICLKOUT,
        nSCICLKOUTEN,
        nSCICLKEN,
        nSCICARDRST,
        SCIFCB,
        SCIVCCEN,
        SCIDEACACK,
  
      //Interrupt
        SCIINTR,

      //DMA	
        SCITXDMACLR,
        SCIRXDMACLR,
        SCITXDMASREQ,
        SCITXDMABREQ,
        SCIRXDMASREQ,
        SCIRXDMABREQ,
// SSP
      //PAD
 	SSPRXD,
        SSPFSSIN,
        SSPCLKIN,

  	SSPFSSOUT,
        SSPCLKOUT,
        SSPTXD,
        nSSPOE,
        nSSPCTLOE,

      //Interrupt
	SSPINTR,

      //DMA	
        SSPTXDMACLR,
        SSPRXDMACLR,
        SSPTXDMASREQ,
        SSPTXDMABREQ,
        SSPRXDMASREQ,
        SSPRXDMABREQ,

// RTC
   //PAD
        CLK1HZ,         
        nRTCRST,        
   //Interrupt
        RTCINTR,        

// AACI
      //PAD
        AACIBITCLK,      
        nAACIBITCLK,     
        nAACIBITCLKRST,  
        nFAACIBITCLKRST, 
        AACISDATAIN,     
        
        AACIRESET,       
        AACISYNC,        
        AACISDATAOUT,    

      //Interrupt
        AACIINTR,   
     
      //DMA	
        AACIDMACLRRX,    
        AACIDMACLRTX,    
        AACIDMASREQRX,   
        AACIDMALSREQRX,  
        AACIDMABREQRX,   
        AACIDMALBREQRX,  
        AACIDMABREQTX,   
// SCAN
	SCANENABLE, 
	SCANINHCLK, 
        SCANOUTHCLK, 
	SCANINPCLK, 
	SCANOUTPCLK
	);

  // Common AHB signals
  input         HCLK;
  input         HRESETn;

  // Matrix AHB connections
  input  [31:0] HADDR;
  input  [2:0]  HBURST;
  input  [3:0]  HPROT;
  input         HREADYmtrx;
  input         HSELmtrx;
  input  [2:0]  HSIZE;
  input  [1:0]  HTRANS;
  input  [31:0] HWDATA;
  input         HWRITE;

  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;

  // Timer signals 
  output        TIMINT1;
  output        TIMINT2;
  output        TIMINTC;

  // Watchdog signals
  input         WDOGRESn;
  output        WDOGRES;
  output        WDOGINT;

  // Processor interrupts
  input         nFIQ;
  input         nIRQ;

  // Remap/Pause control signals
  output        Pause;
  output        Remap;

  // GPIO signals
  input  [7:0]  GPIN;
  input  [7:0]  nGPAFEN;
  input  [7:0]  GPAFOUT;
  output [7:0]  GPOUT;
  output [7:0]  nGPEN;
  output [7:0]  GPAFIN;
  output        GPIOINTR;
  output [7:0]  GPIOMIS;

  //UART
  input         nUARTCTS;
  input         nUARTDCD;
  input         nUARTDSR;
  input         nUARTRI;
  input         UARTRXD;
  input         SIRIN;
  output        UARTTXD;
  output        nSIROUT;
  output        nUARTDTR;
  
 //Intrrupt
  output       UARTINTR;          

 //UART DMA
  input         UARTRXDMACLR;  
  input         UARTTXDMACLR;  
  output        UARTTXDMASREQ; 
  output        UARTTXDMABREQ; 
  output        UARTRXDMASREQ; 
  output        UARTRXDMABREQ; 

 // MMC
  input         MMCIDMACLR;    
  input         MCLK;          
  input         nMCLK;         
  input         MMCIFBCLK;     
  input         nMMCIRST;      
  input         MMCICMDIN;     
  input         MMCIDATIN;     
  
  output        MMCIINTR0;     
  output        MMCIINTR1;     
  output        MMCIDMASREQ;   
  output        MMCIDMABREQ;   
  output        MMCIDMALSREQ;  
  output        MMCIDMALBREQ;  
  output        MMCICLKOUT;    
  output        MMCICMDOUT;    
  output        nMMCICMDEN;    
  output        MMCIDATOUT;    
  output        nMMCIDATEN;    
  output        MMCIPWR;       
  output        MMCIROD;       
  output  [3:0] MMCIVDD;       

// SCI
  //PAD
  input         SCIDATAIN;     
  input         SCICLKIN;      
  input         SCIDETECT;     
  input         SCIDEACREQ;    

  output        nSCIDATAOUTEN; 
  output        nSCIDATAEN;    
  output        SCICLKOUT;     
  output        nSCICLKOUTEN;  
  output        nSCICLKEN;     
  output        nSCICARDRST;   
  output        SCIFCB;        
  output        SCIVCCEN;      
  output        SCIDEACACK;    

  //Interrupt
  output         SCIINTR;      

  //DMA	
  input          SCITXDMACLR;  
  input          SCIRXDMACLR;  
                 
  output         SCITXDMASREQ; 
  output         SCITXDMABREQ; 
  output         SCIRXDMASREQ; 
  output         SCIRXDMABREQ; 

// SSP
   //PAD
  input          SSPRXD;       
  input          SSPCLKIN;     
  input          SSPFSSIN;     

  output         SSPFSSOUT;    
  output         SSPCLKOUT;    
  output         SSPTXD;       
  output         nSSPOE;       
  output         nSSPCTLOE;    

  //Interrupt
  input          SSPINTR;      

  //DMA	
  input          SSPTXDMACLR;  
  input          SSPRXDMACLR;  
                 
  output         SSPTXDMASREQ; 
  output         SSPTXDMABREQ; 
  output         SSPRXDMASREQ; 
  output         SSPRXDMABREQ; 

// RTC
   //PAD
  input          CLK1HZ;          
  input          nRTCRST;         
   //Interrupt
  output         RTCINTR;         

// AACI
      //PAD
  input          AACIBITCLK;      
  input          nAACIBITCLK;     
  input          nAACIBITCLKRST;  
  input          nFAACIBITCLKRST; 
  input          AACISDATAIN;     
                 
  output         AACIRESET;       
  output         AACISYNC;        
  output         AACISDATAOUT;    
      //Interrupt
  output         AACIINTR;        
      //DMA	
  input          AACIDMACLRRX;    
  input          AACIDMACLRTX;    
  output         AACIDMASREQRX;   
  output         AACIDMALSREQRX;  
                                  
  output         AACIDMABREQRX;   
  output         AACIDMALBREQRX;  
                                  
  output         AACIDMABREQTX;   
 
 // Scan test dummy signals; not cn 
  input          SCANENABLE;      
  input          SCANINHCLK;      
  output         SCANOUTHCLK;     
  input          SCANINPCLK;      
  output         SCANOUTPCLK;     

  // Port wires
  wire          HCLK;
  wire          HRESETn;

  wire  [31:0]  HADDR;
  wire  [2:0]   HBURST;
  wire  [3:0]   HPROT;
  wire          HREADYmtrx;
  wire          HSELmtrx;
  wire  [2:0]   HSIZE;
  wire  [1:0]   HTRANS;
  wire  [31:0]  HWDATA;
  wire          HWRITE;

  wire  [31:0]  HRDATA;
  wire          HREADYOUT;
  wire  [1:0]   HRESP;

  wire          TIMINT1;
  wire          TIMINT2;
  wire          TIMINTC;

  wire          WDOGRESn;
  wire          WDOGRES;
  wire          WDOGINT;

  wire          nFIQ;
  wire          nIRQ;

  wire          Pause;
  wire          Remap;

  wire  [7:0]   GPIN;
  wire  [7:0]   nGPAFEN;
  wire  [7:0]   GPAFOUT;
  wire  [7:0]   GPOUT;
  wire  [7:0]   nGPEN;
  wire  [7:0]   GPAFIN;
  wire          GPIOINTR;
  wire  [7:0]   GPIOMIS;

  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;
  wire          SCANINPCLK;
  wire          SCANOUTPCLK;

//------------------------------------------------------------------------------
// Signal declarations: AHB
//------------------------------------------------------------------------------

// AHB signal
  wire          iHREADYOUT;

//------------------------------------------------------------------------------
// Signal declarations: APB
//------------------------------------------------------------------------------

// APB backbone
  wire          PENABLE;
  wire  [23:0]  PADDR;
  wire          PWRITE;
  wire  [31:0]  PWDATA;
  wire  [31:0]  PRDATA;

// Slave-specific APB signals
  wire          PSELS0;
  wire          PSELS1;
  wire          PSELS2;
  wire          PSELS3;
  wire          PSELS4;
  wire          PSELS5;
  wire          PSELS6;
  wire          PSELS7;
  wire          PSELS8;
  wire          PSELS9;
  wire          PSELS10;
  wire          PSELS11;
  wire          PSELS12;
  wire          PSELS13;
  wire          PSELS14;
  wire          PSELS15;

  wire  [31:0]  PRDATAS0;
  wire  [31:0]  PRDATAS1;
  wire  [31:0]  PRDATAS2;
  wire  [31:0]  PRDATAS3;
  wire  [31:0]  PRDATAS4;
  wire  [31:0]  PRDATAS5;
  wire  [31:0]  PRDATAS6;
  wire  [31:0]  PRDATAS7;
  wire  [31:0]  PRDATAS8;
  wire  [31:0]  PRDATAS9;
  wire  [31:0]  PRDATAS10;
  wire  [31:0]  PRDATAS11;
  wire  [31:0]  PRDATAS12;
  wire  [31:0]  PRDATAS13;
  wire  [31:0]  PRDATAS14;
  wire  [31:0]  PRDATAS15;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINtimers;
  wire          SCANOUTtimers;
  wire          SCANINwdog;
  wire          SCANOUTwdog;
  wire          SCANINgpio;
  wire          SCANOUTgpio;
  wire          SCANINegapb;
  wire          SCANOUTegapb;
  wire          SCANINrpc;
  wire          SCANOUTrpc;
  wire          SCANINapbif;
  wire          SCANOUTapbif;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire          TieOffHi1;
  wire  [31:0]  TieOffLo32;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The TieOff signals must be assigned explicitly within the body of the VHDL.
// Using initial values (in the signal declaration, above) will not work in
//  Synopsys. Signals are used rather than constants as constants can not be 
//  connected directly to sub-component instantiations
  assign TieOffHi1 = 1'b1;
  assign TieOffLo32 = {32{1'b0}};

// AHB to APB Bridge instantiated as AHB slave 12
  APBif uAPBif 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR[27:0]),
     .HTRANS      (HTRANS),
     .HWRITE      (HWRITE),
     .HWDATA      (HWDATA),
     .HSEL        (HSELmtrx),     
     .HREADY      (iHREADYOUT),   

     .HRDATA      (HRDATA),       
     .HREADYOUT   (iHREADYOUT),
     .HRESP       (HRESP),

     .PRDATA      (PRDATA),       

     .PWDATA      (PWDATA),
     .PADDR       (PADDR),
     .PWRITE      (PWRITE),
     .PENABLE     (PENABLE),
     .PSELS0      (PSELS0),
     .PSELS1      (PSELS1),
     .PSELS2      (PSELS2),
     .PSELS3      (PSELS3),
     .PSELS4      (PSELS4),
     .PSELS5      (PSELS5),
     .PSELS6      (PSELS6),
     .PSELS7      (PSELS7),
     .PSELS8      (PSELS8),
     .PSELS9      (PSELS9),
     .PSELS10     (PSELS10),
     .PSELS11     (PSELS11),
     .PSELS12     (PSELS12),
     .PSELS13     (PSELS13),
     .PSELS14     (PSELS14),
     .PSELS15     (PSELS15),

     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINapbif), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTapbif) // Scan Chain Output  
    );

  // Connect internal signal to port
  assign HREADYOUT = iHREADYOUT;

// Central multiplexer - peripherals to bridge
  MuxP2B uMuxP2B 
    (
      .PSELS0    (PSELS0),
      .PSELS1    (PSELS1),
      .PSELS2    (PSELS2),
      .PSELS3    (PSELS3),
      .PSELS4    (PSELS4),
      .PSELS5    (PSELS5),
      .PSELS6    (PSELS6),
      .PSELS7    (PSELS7),
      .PSELS8    (PSELS8),
      .PSELS9    (PSELS9),
      .PSELS10   (PSELS10),
      .PSELS11   (PSELS11),
      .PSELS12   (PSELS12),
      .PSELS13   (PSELS13),
      .PSELS14   (PSELS14),
      .PSELS15   (PSELS15),

      .PRDATAS0  (PRDATAS0),
      .PRDATAS1  (PRDATAS1),
      .PRDATAS2  (PRDATAS2),
      .PRDATAS3  (PRDATAS3),
      .PRDATAS4  (PRDATAS4),
      .PRDATAS5  (PRDATAS5),
      .PRDATAS6  (PRDATAS6),
      .PRDATAS7  (PRDATAS7),
      .PRDATAS8  (PRDATAS8),
      .PRDATAS9  (PRDATAS9),
      .PRDATAS10 (PRDATAS10),
      .PRDATAS11 (PRDATAS11),
      .PRDATAS12 (PRDATAS12),
      .PRDATAS13 (PRDATAS13),
      .PRDATAS14 (PRDATAS14),
      .PRDATAS15 (PRDATAS15),

      .PRDATA    (PRDATA)
    );

  // Tie off unused APB slave data paths
  assign PRDATAS0  = TieOffLo32;
  assign PRDATAS11 = TieOffLo32;
  assign PRDATAS12 = TieOffLo32;
  assign PRDATAS13 = TieOffLo32;
  assign PRDATAS14 = TieOffLo32;

// Watchdog timer module instantiated as APB slave 1
  Watchdog uWatchdog 
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS1),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS1),

     .WDOGCLK     (HCLK),
     .WDOGCLKEN   (TieOffHi1),
     .WDOGRESn    (WDOGRESn),
     .WDOGINT     (WDOGINT),
     .WDOGRES     (WDOGRES),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINwdog), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTwdog) // Scan Chain Output
    );

// Timers module instantiated as APB slave 2
  Timers uTimers 
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS2),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS2),

     .TIMCLK      (HCLK),
     .TIMCLKEN1   (TieOffHi1),
     .TIMCLKEN2   (TieOffHi1),
     .TIMINT1     (TIMINT1),
     .TIMINT2     (TIMINT2),
     .TIMINTC     (TIMINTC),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),   // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINtimers), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTtimers) // Scan Chain Output
    );

// General Purpose Input/Output module instantiated as APB slave 4
  Gpio uGpio 
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PSEL        (PSELS4),
     .PENABLE     (PENABLE),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA[7:0]),
     .PADDR       (PADDR[11:2]),

     .GPIN        (GPIN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .PRDATA      (PRDATAS4[7:0]),
     .nGPEN       (nGPEN),
     .GPOUT       (GPOUT),
     .GPAFIN      (GPAFIN),
     .GPIOINTR    (GPIOINTR),
     .GPIOMIS     (GPIOMIS),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINgpio), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTgpio) // Scan Chain Output
    );

  // Drive unused output read-data bits LOW.
  assign PRDATAS4[31:8] = {24{1'b0}};

// Remap and Pause controller instantiated as APB slave 8
  RemapPause uRemapPause 
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSELRPC     (PSELS8),
     .PADDR       (PADDR[5:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA[7:0]),
     .PRDATA      (PRDATAS8[7:0]),

     .nFIQ        (nFIQ),
     .nIRQ        (nIRQ),

     .Pause       (Pause),
     .Remap       (Remap),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINrpc),  // Scan Chain Input
     .SCANOUTPCLK (SCANOUTrpc)  // Scan Chain Output
    );

  // Drive unused output read data bits LOW.
  assign PRDATAS8[31:8] = {24{1'b0}};

// UART
wire    UARTTXDMASREQ; // Output
wire    UARTTXDMABREQ; // Output
wire	UARTRXDMASREQ; // Output
wire    UARTRXDMABREQ; // Output

//assign  UARTRXDMACLR = 0;  // Input
//assign	UARTTXDMACLR = 0;  // Input


 Uart uUART(
     .UARTCLK           (HCLK),
     .nUARTRST          (HRESETn),

    // APB interface and register block
     .PCLK              (HCLK),
     .PRESETn           (HRESETn),
     .PSEL              (PSELS9),
     .PENABLE           (PENABLE),
     .PWRITE            (PWRITE),
     .PADDR             (PADDR[11:2]),
     .PWDATA            (PWDATA),
     .PRDATA            (PRDATAS9),

    // DMA interface
     .UARTRXDMACLR      (UARTRXDMACLR ),
     .UARTTXDMACLR      (UARTTXDMACLR ),
     .UARTTXDMASREQ     (UARTTXDMASREQ),
     .UARTTXDMABREQ     (UARTTXDMABREQ),
     .UARTRXDMASREQ     (UARTRXDMASREQ),
     .UARTRXDMABREQ     (UARTRXDMABREQ),

    // FIFO status and interruput generation
     .UARTTXINTR        (UARTTXINTR),
     .UARTRXINTR        (UARTRXINTR),
     .UARTMSINTR        (UARTMSINTR),
     .UARTRTINTR        (UARTRTINTR),
     .UARTEINTR         (UARTEINTR),
     .UARTINTR          (UARTINTR),

     .nUARTRI           (nUARTRI),  
     .nUARTCTS          (nUARTCTS), 
     .nUARTDSR          (nUARTDSR), 
     .nUARTDCD          (nUARTDCD), 

     .nUARTDTR          (nUARTDTR), 
     .nUARTRTS          (nUARTRTS), 
     .nUARTOut1         (nUARTOut1),
     .nUARTOut2         (nUARTOut2),

    // Receiver
     .UARTRXD           (UARTRXD),  
     .SIRIN             (SIRIN),    

    // Transmitter
     .UARTTXD           (UARTTXD),  
     .nSIROUT           (nSIROUT),  

    // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINegapb), // Scan Chain Input
     .SCANINUCLK  (SCANINtimers),
     .SCANOUTPCLK (SCANOUTegapb), // Scan Chain Output
     .SCANOUTUCLK (SCANOUTtimersUART)
     );

wire nHCLK;

assign nHCLK = ~HCLK;

Mmci uMmci (
// Inputs
     .PCLK		(HCLK),
     .PRESETn		(HRESETn),
     .PSEL		(PSELS3),
     .PENABLE		(PENABLE),
     .PWRITE		(PWRITE),
     .PADDR		(PADDR[11:2]),
     .PWDATA		(PWDATA),

     .SCANENABLE	(),
     .SCANINPCLK	(),
     .SCANINMCLK	(),
     .SCANINnMCLK	(),
     .SCANINMMCIFBCLK	(),

     .MMCIDMACLR	(MMCIDMACLR),
     .MCLK		(HCLK),
     .nMCLK		(nHCLK),
     .MMCIFBCLK		(MMCIFBCLK),
     .nMMCIRST		(nMMCIRST),
     .MMCICMDIN		(MMCICMDIN),
     .MMCIDATIN		(MMCIDATIN),
// Outputs
     .PRDATA		(PRDATAS3),
           
     .SCANOUTPCLK	(),
     .SCANOUTMCLK	(),
     .SCANOUTnMCLK	(),
     .SCANOUTMMCIFBCLK	(),

     .MMCIINTR0		(MMCIINTR0),
     .MMCIINTR1		(MMCIINTR1),

     .MMCIDMASREQ	(MMCIDMASREQ),
     .MMCIDMABREQ	(MMCIDMABREQ),
     .MMCIDMALSREQ	(MMCIDMALSREQ),
     .MMCIDMALBREQ	(MMCIDMALBREQ),

     .MMCICLKOUT	(MMCICLKOUT),
     .MMCICMDOUT	(MMCICMDOUT),
     .nMMCICMDEN	(nMMCICMDEN),
     .MMCIDATOUT	(MMCIDATOUT),

     .nMMCIDATEN	(nMMCIDATEN),
     .MMCIPWR		(MMCIPWR),
     .MMCIROD		(MMCIROD),
     .MMCIVDD		(MMCIVDD)
      );

 Sci uSci(

// Inputs
     .PCLK		(HCLK      ),
     .SCICLK            (HCLK      ),
     .PRESETn           (HRESETn   ),
     .nSCIRST           (HRESETn   ),
     .PSEL              (PSELS5    ),
     .PENABLE           (PENABLE   ),
     .PWRITE            (PWRITE    ),
     .PADDR             (PADDR[11:2]),
     .PWDATA            (PWDATA    ),

     .SCIDATAIN         (SCIDATAIN ),
     .SCICLKIN          (SCICLKIN  ),
     .SCIDETECT         (SCIDETECT ),
     .SCIDEACREQ        (SCIDEACREQ), 

     .SCITXDMACLR	(SCITXDMACLR),
     .SCIRXDMACLR 	(SCIRXDMACLR),

     .SCANENABLE        (), 
     .SCANINPCLK        (),
     .SCANINSCICLK      (),

// Outputs
     .nSCIDATAOUTEN     (nSCIDATAOUTEN),
     .nSCIDATAEN        (nSCIDATAEN   ),
     .SCICLKOUT         (SCICLKOUT    ),
     .nSCICLKOUTEN      (nSCICLKOUTEN ),
     .nSCICLKEN         (nSCICLKEN    ),
     .nSCICARDRST       (nSCICARDRST  ),
     .SCIFCB		(SCIFCB	      ), 
     .SCIVCCEN		(SCIVCCEN     ), 

     .SCIDEACACK        (SCIDEACACK   ),
     .PRDATA            (PRDATAS5     ),

     .SCICARDININTR     (SCICARDININTR  ), 
     .SCICARDOUTINTR    (SCICARDOUTINTR ),
     .SCICARDUPINTR     (SCICARDUPINTR  ),
     .SCICARDDNINTR     (SCICARDDNINTR  ),
     .SCITXERRINTR      (SCITXERRINTR   ),
     .SCIATRSTOUTINTR   (SCIATRSTOUTINTR), 
     .SCIATRDTOUTINTR   (SCIATRDTOUTINTR),
     .SCIBLKTOUTINTR    (SCIBLKTOUTINTR ),
     .SCICHTOUTINTR     (SCICHTOUTINTR  ),
     .SCIRTOUTINTR      (SCIRTOUTINTR   ),
     .SCIRORINTR        (SCIRORINTR     ), 
     .SCICLKSTPINTR     (SCICLKSTPINTR  ),
     .SCICLKACTINTR     (SCICLKACTINTR  ),
     .SCITXTIDEINTR     (SCITXTIDEINTR  ),
     .SCIRXTIDEINTR     (SCIRXTIDEINTR  ),

     .SCIINTR           (SCIINTR),

     .SCITXDMASREQ      (SCITXDMASREQ),
     .SCITXDMABREQ      (SCITXDMABREQ),
     .SCIRXDMASREQ      (SCIRXDMASREQ),
     .SCIRXDMABREQ      (SCIRXDMABREQ),

     .SCANOUTPCLK       (),
     .SCANOUTSCICLK     () 
       );

Ssp uSsp (
// Inputs
           .PCLK	(HCLK),
           .SSPCLK	(HCLK),

           .PRESETn	(HRESETn),
           .nSSPRST	(HRESETn),

           .PSEL	(PSELS6),
           .PENABLE	(PENABLE),
           .PWRITE	(PWRITE),

           .SSPRXD	(SSPRXD  ),
           .SSPFSSIN	(SSPFSSIN),
           .SSPCLKIN	(SSPCLKIN),

           .SCANENABLE	(),
           .SCANINPCLK	(),
           .SCANINSSPCLK(),

           .PADDR	(PADDR[11:2]),

           .PWDATA	(PWDATA),

           .SSPTXDMACLR	(SSPTXDMACLR),
           .SSPRXDMACLR	(SSPRXDMACLR),
// Outputs
           .SSPINTR	(SSPINTR),
           .SSPRXINTR	(SSPRXINTR),
           .SSPTXINTR	(SSPTXINTR) ,
           .SSPRORINTR	(SSPRORINTR),
           .SSPRTINTR	(SSPRTINTR),

           .SSPFSSOUT	(SSPFSSOUT),
           .SSPCLKOUT	(SSPCLKOUT),

           .SCANOUTPCLK	(),
           .SCANOUTSSPCLK(),

           .SSPTXD	(SSPTXD   ),
           .nSSPOE	(nSSPOE   ),
           .nSSPCTLOE	(nSSPCTLOE),

           .PRDATA	(PRDATAS6),

           .SSPTXDMASREQ(SSPTXDMASREQ),
           .SSPTXDMABREQ(SSPTXDMABREQ),
           .SSPRXDMASREQ(SSPRXDMASREQ),
           .SSPRXDMABREQ(SSPRXDMABREQ)
           );

Aaci uAaci (
// Inputs
            .PCLK		(HCLK		),
            .AACIBITCLK		(AACIBITCLK	),
            .nAACIBITCLK	(nAACIBITCLK	),
            .PRESETn		(HRESETn	),
            .nAACIBITCLKRST	(nAACIBITCLKRST	),
            .nFAACIBITCLKRST	(nFAACIBITCLKRST),
            .PSEL		(PSELS10	),
            .PENABLE		(PENABLE	),
            .PWRITE		(PWRITE		),
            .AACIDMACLRRX	(AACIDMACLRRX	),
            .AACIDMACLRTX	(AACIDMACLRTX	),
            .SCANENABLE		(SCANENABLE	),
            .SCANINPCLK		(SCANINPCLK	),
            .SCANINBITCLK	(SCANINBITCLK	),
            .SCANINnBITCLK	(SCANINnBITCLK	),
            .AACISDATAIN	(AACISDATAIN	),
            .PADDR		(PADDR[11:2]	),
            .PWDATA		(PWDATA		),
// Outputs
            .AACIRESET		(AACIRESET	),
            .AACISYNC   	(AACISYNC   	),
            .AACITXINTR1	(AACITXINTR1	),
            .AACITXINTR2	(AACITXINTR2	),
            .AACITXINTR3	(AACITXINTR3	),
            .AACITXINTR4	(AACITXINTR4	),
            .AACIRXINTR1	(AACIRXINTR1	),
            .AACIRXINTR2	(AACIRXINTR2	),
            .AACIRXINTR3	(AACIRXINTR3	),
            .AACIRXINTR4	(AACIRXINTR4	),
            .AACIORINTR1	(AACIORINTR1	),
            .AACIORINTR2	(AACIORINTR2	),
            .AACIORINTR3	(AACIORINTR3	),
            .AACIORINTR4	(AACIORINTR4	),
            .AACIURINTR1	(AACIURINTR1	),
            .AACIURINTR2	(AACIURINTR2	),
            .AACIURINTR3	(AACIURINTR3	),
            .AACIURINTR4	(AACIURINTR4	),
            .AACITXCINTR1	(AACITXCINTR1	),
            .AACITXCINTR2	(AACITXCINTR2	),
            .AACITXCINTR3	(AACITXCINTR3	),
            .AACITXCINTR4	(AACITXCINTR4	),
            .AACIRXTOINTR1	(AACIRXTOINTR1	),
            .AACIRXTOINTR2	(AACIRXTOINTR2	),
            .AACIRXTOINTR3	(AACIRXTOINTR3	),
            .AACIRXTOINTR4	(AACIRXTOINTR4	),
            .AACIWINTR		(AACIWINTR	),
            .AACIGPIOINTR	(AACIGPIOINTR	),
            .AACIS12RXINTR	(AACIS12RXINTR	),
            .AACIS12TXINTR	(AACIS12TXINTR	),
            .AACIS2RXINTR	(AACIS2RXINTR	),
            .AACIS2TXINTR	(AACIS2TXINTR	),
            .AACIS1RXINTR	(AACIS1RXINTR	),
            .AACIS1TXINTR	(AACIS1TXINTR	),
            .AACIRXTOFEINTR1	(AACIRXTOFEINTR1),
            .AACIRXTOFEINTR2	(AACIRXTOFEINTR2),
            .AACIRXTOFEINTR3	(AACIRXTOFEINTR3),
            .AACIRXTOFEINTR4	(AACIRXTOFEINTR4),
            .AACIINTR		(AACIINTR	),
            .AACIDMASREQRX	(AACIDMASREQRX	),
            .AACIDMALSREQRX	(AACIDMALSREQRX	),
            .AACIDMABREQRX	(AACIDMABREQRX	),
            .AACIDMALBREQRX	(AACIDMALBREQRX	),
            .AACIDMABREQTX	(AACIDMABREQTX	),
            .SCANOUTPCLK	(SCANOUTPCLK	),
            .SCANOUTBITCLK	(SCANOUTBITCLK	),
            .SCANOUTnBITCLK	(SCANOUTnBITCLK	),
            .AACISDATAOUT	(AACISDATAOUT	),
            .PRDATA		(PRDATAS10	)
            );

Rtc uRtc (
          // Inputs
            .PCLK		(HCLK),
            .PRESETn		(HRESETn),
            .PSEL		(PSELS7),
            .PENABLE		(PENABLE),
            .PWRITE		(PWRITE),
            .PADDR		(PADDR[11:2]),
            .PWDATA		(PWDATA),
            .CLK1HZ		(CLK1HZ),
            .nRTCRST		(HRESETn),
            .nPOR		(HRESETn),
            .SCANENABLE		(),
            .SCANINPCLK		(),
            .SCANINCLK1HZ	(),
          // Outputs
            .PRDATA		(PRDATAS7),
            .RTCINTR		(RTCINTR),
            .SCANOUTPCLK	(),
            .SCANOUTCLK1HZ	()
            );
endmodule

// --================================= End ===================================--

