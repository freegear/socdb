//--==========================================================================--
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
//  File Name          : EASY_ML.v,v
//  File Revision      : 1.18
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem
//                        Multi-layer (EASY-ML) consisting of the ARM922T, 
//                        File Reader Bus Master and EgMaster. 
//--==========================================================================--

`timescale 1ns/1ps

//------------------------------------------------------------------------------
// EASY_ML Address Map
//------------------------------------------------------------------------------
// Full Decoding of the Address Map is performed continuously as a function of
//  HADDR. All unused slots are connected to a Default Slave.
//
// AHB address map is:
//

//------------------------------------------------------------------------------
module EASY_ML (
	XCLKIN, 
	nReset, 

        EBIEXTDATAIN,
        EBIEXTDATAOUT,
        nEBIEXTDATAEN,
        EBIEXTADDROUT,

	SMCS,
        nSMBLS, 
	nSMOEN, 
	TESTREQA, 
	TESTREQB, 
	TESTACK, 
	nTRST, 
	TCK, 
	TDI,
        TMS, 
	TDO, 
	nTDOEN, 
	COMMRX, 
	COMMTX, 
	XFCLK, 
	GPIN, 
	GPOUT, 
	nGPEN,
        nGPAFEN, 
	GPAFOUT, 
	GPAFIN, 

        nUARTCTS,
        nUARTDCD,
        nUARTDSR,
        nUARTRI,
        UARTRXD,
        SIRIN,
        UARTTXD,
        nSIROUT,
        nUARTDTR,

        // input
        MPMCBIGENDIAN,
        MPMCFBCLKIN0,
        MPMCFBCLKIN1,
        MPMCFBCLKIN2,
        MPMCFBCLKIN3,
        MPMCSTCS1MW,
        MPMCSTCS0POL,
        MPMCSTCS1POL,
        MPMCSTCS2POL,
        MPMCSTCS3POL,
        MPMCTESTIN,
        // output
        MPMCADDROUT,
        MPMCCKEOUT,
        MPMCCLKOUT,
        MPMCDQMOUT,
        MPMCRPVHHOUT,
        nMPMCBLSOUT,
        nMPMCCASOUT,
        nMPMCDYCSOUT,
        nMPMCOEOUT,
        nMPMCRASOUT,
        nMPMCRPOUT,
        nMPMCSTCSOUT,
        nMPMCWEOUT,
        // inout
        MPMCDATA,

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

        SSPRXD,     
        SSPCLKIN,   
        SSPFSSIN,   
                    
        SSPFSSOUT,  
        SSPCLKOUT,  
        SSPTXD,     
        nSSPOE,     
        nSSPCTLOE,  

        AACIBITCLK,        
        nAACIBITCLK,       
        nAACIBITCLKRST,
        nFAACIBITCLKRST,
        AACISDATAIN, 

        AACIRESET,
        AACISYNC,
        AACIDMABREQTX,
        AACISDATAOUT, 

        CLK1HZ,         
        nRTCRST, 

	SCANENABLE, 
	SCANINHCLK, 
	SCANOUTHCLK,
        SCANINPCLK, 
	SCANOUTPCLK
	);

  input         XCLKIN;      // External clock in
  input         nReset;      // Power on reset in
  input  [31:0] EBIEXTDATAIN; 
  output [31:0] EBIEXTDATAOUT;
  output [3:0]  nEBIEXTDATAEN; 
  output [25:0] EBIEXTADDROUT; 

  output [7:0]  SMCS;        // Memory bank Chip Select output pins
  output [3:0]  nSMBLS;      // Memory device Byte lane enables
  output        nSMOEN;      // Memory Output Enable 
                             //  (complement serves as Write-Enable)

  // TIC test command signals
  input         TESTREQA;    // Test bus request A
  input         TESTREQB;    // Test bus request B
  output        TESTACK;     // Test acknowledge

  // JTAG connections
  input         nTRST;
  input         TCK;
  input         TDI;
  input         TMS;
  output        TDO;
  output        nTDOEN;

  // ARM922T comms channel debug lines
  output        COMMRX;
  output        COMMTX;

  // ARM922T Fast Cache clock
  input         XFCLK;

  // GPIO lines
  input  [7:0]  GPIN;        // Inputs
  output [7:0]  GPOUT;       // Outputs
  output [7:0]  nGPEN;       // Output ctrl enables
  input  [7:0]  nGPAFEN;     // H/w ctrl enables
  input  [7:0]  GPAFOUT;     // H/w ctrl inputs
  output [7:0]  GPAFIN;      // H/w ctrl outputs

  // UART
  input         nUARTCTS;
  input         nUARTDCD;
  input         nUARTDSR;
  input         nUARTRI;
  input         UARTRXD;
  input         SIRIN;
  output        UARTTXD;
  output        nSIROUT;
  output        nUARTDTR;

 // MMC
  input         MCLK;            
  input         nMCLK;           
  input         MMCIFBCLK;       
  input         nMMCIRST;        
  input         MMCICMDIN;       
  input         MMCIDATIN;       

  output        MMCICLKOUT;      
  output        MMCICMDOUT;      
  output        nMMCICMDEN;      
  output        MMCIDATOUT;      
  output        nMMCIDATEN;     
  output        MMCIPWR;         
  output        MMCIROD;         
  output  [3:0] MMCIVDD;         

  // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE;  
  input         SCANINHCLK;  
  output        SCANOUTHCLK; 
  input         SCANINPCLK;  
  output        SCANOUTPCLK; 

  // MPMC PAD
  // input
  input         MPMCBIGENDIAN; 
  input         MPMCFBCLKIN0;  
  input         MPMCFBCLKIN1;  
  input         MPMCFBCLKIN2;  
  input         MPMCFBCLKIN3;  
  input   [1:0] MPMCSTCS1MW;   
  input         MPMCSTCS0POL; 
  input         MPMCSTCS1POL;
  input         MPMCSTCS2POL; 
  input         MPMCSTCS3POL; 
  input         MPMCTESTIN;    
  // output
  output [27:0] MPMCADDROUT;   
  output  [3:0] MPMCCKEOUT;    
  output  [3:0] MPMCCLKOUT;    
  output  [3:0] MPMCDQMOUT;    
  output        MPMCRPVHHOUT;  
  output  [3:0] nMPMCBLSOUT;   
  output        nMPMCCASOUT;   
  output  [3:0] nMPMCDYCSOUT;  
  output        nMPMCOEOUT;    
  output        nMPMCRASOUT;   
  output        nMPMCRPOUT;    
  output  [3:0] nMPMCSTCSOUT;  
  output        nMPMCWEOUT;    
  // inout
  inout [31:0]  MPMCDATA;

  	// PAD
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
                
  // SSP        
  input         SSPRXD;        
  input         SSPCLKIN;      
  input         SSPFSSIN;      
                
  output        SSPFSSOUT;     
  output        SSPCLKOUT;     
  output        SSPTXD;        
  output        nSSPOE;        
  output        nSSPCTLOE;     

  // AACI
  input         AACIBITCLK;      
  input         nAACIBITCLK;     
  input         nAACIBITCLKRST;  
  input         nFAACIBITCLKRST; 
  input         AACISDATAIN;     
                
  output        AACIRESET;       
  output        AACISYNC;        
  output        AACIDMABREQTX;  
  output        AACISDATAOUT;    

  // RTC
  input          CLK1HZ;          // 1 HZ clock
  input          nRTCRST;         // RTC reset signal

  // Port wires
  wire          XCLKIN;
  wire          nReset;

  wire   [7:0]  SMCS;
  wire   [3:0]  nSMBLS;
  wire          nSMOEN;
  
  wire          TESTREQA;
  wire          TESTREQB;
  wire          TESTACK;

  wire          nTRST;
  wire          TCK;
  wire          TDI;
  wire          TMS;
  wire          TDO;
  wire          nTDOEN;

  wire          COMMRX;
  wire          COMMTX;

  wire          XFCLK;

  wire [7:0]    GPIN;
  wire [7:0]    GPOUT;
  wire [7:0]    nGPEN;
  wire [7:0]    nGPAFEN;
  wire [7:0]    GPAFOUT;
  wire [7:0]    GPAFIN;

  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;
  wire          SCANINPCLK;
  wire          SCANOUTPCLK;

//------------------------------------------------------------------------------
// Signal declarations: AHB Common
//------------------------------------------------------------------------------

  wire          HCLK;
  wire          HRESETn;

//------------------------------------------------------------------------------
// Signal declarations: BusMatrix modules
//------------------------------------------------------------------------------

// Inport 0 AHB signals
  wire [31:0]   HADDRS0;
  wire [2:0]    HBURSTS0;
  wire          HMASTLOCKS0;
  wire [3:0]    HPROTS0;
  wire [31:0]   HRDATAS0;
  wire          HREADYS0;
  wire [1:0]    HRESPS0;
  wire [2:0]    HSIZES0;
  wire [1:0]    HTRANSS0;
  wire [31:0]   HWDATAS0;
  wire          HWRITES0;
  wire          HSELS0;
  wire          HREADYmtrxS0;
  wire [31:0]   HRDATAdmac; 
  wire [1:0]    HRESPdmac; 
  wire          HREADYOUTdmac; 

// Inport 1 AHB signals
  wire [31:0]   HADDRS1;
  wire [2:0]    HBURSTS1;
  wire          HMASTLOCKS1;
  wire [3:0]    HPROTS1;
  wire [31:0]   HRDATAS1;
  wire          HREADYS1;
  wire [1:0]    HRESPS1;
  wire [2:0]    HSIZES1;
  wire [1:0]    HTRANSS1;
  wire [31:0]   HWDATAS1;
  wire          HWRITES1;
  wire          HSELS1;
  wire          HREADYmtrxS1;

// Outport 0 AHB signals 
  wire [31:0]   HADDRM0;
  wire [2:0]    HBURSTM0;
  wire          HMASTLOCKM0;
  wire [3:0]    HPROTM0;
  wire [31:0]   HRDATAM0;
  wire          HREADYM0;
  wire [1:0]    HRESPM0;
  wire [2:0]    HSIZEM0;
  wire [1:0]    HTRANSM0;
  wire [31:0]   HWDATAM0;
  wire          HWRITEM0;
  wire          HSELM0;
  wire          HREADYOUTM0;

// Outport 1 AHB signals
  wire [31:0]   HADDRM1;
  wire [2:0]    HBURSTM1;
  wire          HMASTLOCKM1;
  wire [3:0]    HPROTM1;
  wire [31:0]   HRDATAM1;
  wire          HREADYM1;
  wire [1:0]    HRESPM1;
  wire [2:0]    HSIZEM1;
  wire [1:0]    HTRANSM1;
  wire [31:0]   HWDATAM1;
  wire          HWRITEM1;
  wire          HSELM1;
  wire          HREADYOUTM1;

// Outport 2 AHB signals
  wire [31:0]   HADDRM2;
  wire [2:0]    HBURSTM2;
  wire          HMASTLOCKM2;
  wire [3:0]    HPROTM2;
  wire [31:0]   HRDATAM2;
  wire          HREADYM2;
  wire [1:0]    HRESPM2;
  wire [2:0]    HSIZEM2;
  wire [1:0]    HTRANSM2;
  wire [31:0]   HWDATAM2;
  wire          HWRITEM2;
  wire          HSELM2;
  wire          HREADYOUTM2;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINHCLKbmtx;
  wire          SCANOUTHCLKbmtx;
  wire          SCANINHCLKinp0;
  wire          SCANOUTHCLKinp0;
  wire          SCANINHCLKinp1;
  wire          SCANOUTHCLKinp1;
  wire          SCANINHCLKoutp0;
  wire          SCANOUTHCLKoutp0;
  wire          SCANINHCLKoutp1;
  wire          SCANOUTHCLKoutp1;
  wire          SCANINHCLKoutp2;
  wire          SCANOUTHCLKoutp2;
  wire          SCANINPCLKoutp2;
  wire          SCANOUTPCLKoutp2;

//------------------------------------------------------------------------------
// Signal declarations: System specific
//------------------------------------------------------------------------------

// Watchdog
  wire          WDOGRES;
  wire          WDOGRESn;

// TIC signals
  wire          HREADYtst;
  wire [1:0]    HRESPtst;
  wire [31:0]   HRDATAtst;
  wire [31:0]   HADDRtst;
  wire          HSELtst;
  wire [1:0]    HTRANStst;
  wire          HWRITEtst;
  wire [31:0]   HWDATAtst;

// Interrupts
  wire          WDOGINT;
  wire          TIMINTC;
  wire          TIMINT2;
  wire          TIMINT1;
  wire          GPIOINTR;
  wire [7:0]    GPIOMIS;
  wire          nFIQ;
  wire          nIRQ;
  wire          RTMSINTR; 
  wire          UARTRXINTR; 
  wire		UARTTXINTR; 
  wire		UARTRTINTR; 
  wire		UARTEINTR;  
  wire 		UARTINTR;   
  wire          DMACINTERR;      
  wire          DMACINTTC;
  wire          DMACINTR;

// Miscellaneous signals
  wire          Remap;
  wire          Pause;

  wire [31:0]  MPMCDATAIN;
  wire [31:0]  MPMCDATAOUT;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire               TieOffL;	
  wire               TieOffHi1;	
  wire [15:0]        TieOffLo16;
  wire [23:0]        TieOffLo24;
  wire [31:0]        TieOffLo32;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

  assign TieOffHi1 = 1'b1;
  assign TieOffLo16 = {16{1'b0}};
  assign TieOffLo24 = {24{1'b0}};
  assign TieOffLo32 = {32{1'b0}};

//------------------------------------------------------------------------------
// DQI signal
//------------------------------------------------------------------------------

  wire[3:0]    nMPMCDATAEN;

   assign MPMCDATA = (~nMPMCDATAEN[0])? {TieOffLo24, MPMCDATAOUT[7:0]} : 31'hzzzzzzzz;      

//------------------------------------------------------------------------------
// Common system features
//------------------------------------------------------------------------------

// Drive the AHB clock with the external clock input.
  assign HCLK = XCLKIN;

// Common reset controller
  ResetCntl uResetCntl 
    (
     .HCLK     (HCLK),
     .nPOReset (nReset),
     .WDOGRES  (WDOGRES),
     .HRESETn  (HRESETn),
     .WDOGRESn (WDOGRESn)
    );

//------------------------------------------------------------------------------
// Signal declarations: DMA
//------------------------------------------------------------------------------
 
    // DMA response/request signals
     wire[15:0]         DMACBREQ;
     wire[15:0]         DMACSREQ;

     wire[15:0]         DMACLBREQ;
     wire[15:0]         DMACLSREQ;

     wire[15:0]         DMACCLR;

     wire[15:0]         DMACTC;

     wire               HSELdmac;
    
    
     wire               HRESP;    
     wire               HREADYOUT;

    // DMA SREQ 
     wire	  	AACIDMASREQRX;  
     wire               AACIDMALSREQRX; 
     wire               SSPRXDMASREQ;   
     wire               SSPTXDMASREQ;   
     wire               SCIRXDMASREQ;   
     wire               SCITXDMASREQ;   
     wire               MMCIDMASREQ;    
     wire               MMCIDMALSREQ;   
     wire               UARTRXDMASREQ;  
     wire               UARTTXDMASREQ;  

    // DMA BREQ 
     wire		AACIDMABREQRX; 			
     wire               AACIDMALBREQRX;
     wire               AACIDMABREQTX; 
     wire               SSPRXDMABREQ;  
     wire               SSPTXDMABREQ;  
     wire               SCIRXDMABREQ;  
     wire               SCITXDMABREQ;  
     wire               MMCIDMABREQ;   
     wire               MMCIDMALBREQ;  
     wire               UARTRXDMABREQ; 
     wire               UARTTXDMABREQ; 

     assign TieOffHi1 = 1'b1;	
 
     assign  DMACSREQ = 0;

     assign  DMACBREQ = 0;
    
     assign DMACLBREQ = TieOffLo16;

     assign DMACLSREQ = TieOffLo16;

     //AHB arbiter
    
     assign HGRANTDMACM = 1'b1;

     assign TieOffL = 0;	

     assign HSELS1   = 1'b1; 
     assign HMASTLOCKS1 = 1'b0;
     assign HPROTS1  = 4'b0000; 

//------------------------------------------------------------------------------
// AHB Multi-layer System
//------------------------------------------------------------------------------

// Multi-layer Bus Matrix module
  BusMatrix uBusMatrix 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),
     
     // Input Port 0
     .HSELS0      (HSELS0),
     .HADDRS0     (HADDRS0),
     .HTRANSS0    (HTRANSS0),
     .HWRITES0    (HWRITES0),
     .HSIZES0     (HSIZES0),
     .HBURSTS0    (HBURSTS0),
     .HPROTS0     (HPROTS0),
     .HWDATAS0    (HWDATAS0),
     .HMASTLOCKS0 (HMASTLOCKS0),
     .HREADYS0    (HREADYS0),

     .HRDATAS0    (HRDATAS0),
     .HREADYOUTS0 (HREADYmtrxS0),
     .HRESPS0     (HRESPS0),

     // Input Port 1
     .HSELS1      (HSELS1),
     .HADDRS1     (HADDRS1),
     .HTRANSS1    (HTRANSS1),
     .HWRITES1    (HWRITES1),
     .HSIZES1     (HSIZES1),
     .HBURSTS1    (HBURSTS1),
     .HPROTS1     (HPROTS1),
     .HWDATAS1    (HWDATAS1),
     .HMASTLOCKS1 (HMASTLOCKS1),
     .HREADYS1    (HREADYmtrxS1),
   //  .HREADYS1    (HREADYOUTdmac), //519 218

     .HRDATAS1    (HRDATAS1),
     .HREADYOUTS1 (HREADYmtrxS1),
     .HRESPS1     (HRESPS1),

     // Output Port 0
     .HSELM0      (HSELM0),
     .HADDRM0     (HADDRM0),
     .HTRANSM0    (HTRANSM0),
     .HWRITEM0    (HWRITEM0),
     .HSIZEM0     (HSIZEM0),
     .HBURSTM0    (HBURSTM0),
     .HPROTM0     (HPROTM0),
     .HWDATAM0    (HWDATAM0),
     .HMASTLOCKM0 (HMASTLOCKM0),
     .HREADYM0    (HREADYM0),

     .HRDATAM0    (HRDATAM0),
     .HREADYOUTM0 (HREADYOUTM0),
     .HRESPM0     (HRESPM0),

     // Output Port 1
     .HSELM1      (HSELM1),
     .HADDRM1     (HADDRM1), //
     .HTRANSM1    (HTRANSM1),
     .HWRITEM1    (HWRITEM1), //input
     .HSIZEM1     (HSIZEM1),
     .HBURSTM1    (HBURSTM1),
     .HPROTM1     (HPROTM1),
     .HWDATAM1    (HWDATAM1),
     .HMASTLOCKM1 (HMASTLOCKM1),
     .HREADYM1    (HREADYM1),

     .HRDATAM1    (HRDATAM1),
     .HREADYOUTM1 (HREADYOUTM1),
     .HRESPM1     (HRESPM1),

     // Output Port 2
     .HSELM2      (HSELM2),
     .HADDRM2     (HADDRM2),
     .HTRANSM2    (HTRANSM2),
     .HWRITEM2    (HWRITEM2),
     .HSIZEM2     (HSIZEM2),
     .HBURSTM2    (HBURSTM2),
     .HPROTM2     (HPROTM2),
     .HWDATAM2    (HWDATAM2),
     .HMASTLOCKM2 (HMASTLOCKM2),
     .HREADYM2    (HREADYM2),

     .HRDATAM2    (HRDATAM2),
     .HREADYOUTM2 (HREADYOUTM2),
     .HRESPM2     (HRESPM2),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKbmtx), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKbmtx) // Scan Chain Output
    );
  
// Inport 0 (ARM922T and Internal Memory)
  Inport0
    //   Memory initialisation file name: IntMemInitFile = "intram.dat"
    #(10, "intram.dat")
  // synopsys translate_on
  uInport0 
    (
     // Common AHB signals
     .HCLK         (HCLK),
     .HRESETn      (HRESETn),

     // Matrix AHB connections
     .HADDR        (HADDRS0),
     .HBURST       (HBURSTS0),
     .HMASTLOCK    (HMASTLOCKS0),
     .HPROT        (HPROTS0),
     .HSIZE        (HSIZES0),
     .HTRANS       (HTRANSS0),
     .HWDATA       (HWDATAS0),
     .HWRITE       (HWRITES0),
     .HSELmtrx     (HSELS0),
     .HREADYOUT    (HREADYS0),

     .HRDATAmtrx   (HRDATAS0),
     .HREADYmtrx   (HREADYmtrxS0),
     .HRESPmtrx    (HRESPS0),

     // ARM922T Test Slave connections
     .HADDRtst     (HADDRtst[11:2]),
     .HSELtst      (HSELtst),
     .HTRANStst    (HTRANStst),
     .HWRITEtst    (HWRITEtst),
     .HWDATAtst    (HWDATAtst),

     .HRDATAtst    (HRDATAtst),
     .HREADYOUTtst (HREADYtst),
     .HRESPtst     (HRESPtst),

     // ARM922T interrupts
     .nFIQ         (nFIQ),
     .nIRQ         (nIRQ),

     // ARM922T comms channel debug lines
     .COMMRX       (COMMRX),
     .COMMTX       (COMMTX),

     // ARM922T Fast Cache clock
     .FCLK         (XFCLK),

     // JTAG connections      
     .nTRST        (nTRST),
     .TCK          (TCK),
     .TDI          (TDI),
     .TMS          (TMS),
     .nTDOEN       (nTDOEN),
     .TDO          (TDO),

     // Remap/Pause control signals
     .Remap        (Remap),
     .Pause        (Pause),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE   (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK   (SCANINHCLKinp0), // Scan Chain Input
     .SCANOUTHCLK  (SCANOUTHCLKinp0) // Scan Chain Output
    );

wire[2:0] HSIZEword;
wire[31:0] HWDATAMdma;

assign HSIZEword = 3'b010;

// DMAC  inport1       
Dmac uDmac (
     // AHB slave signals
        //Input
     .HCLK              (HCLK),
     .HTRANS            (TieOffHi1),
     .HRESETn           (HRESETn),
     .HSELDMAC          (HSELdmac),
     .HWRITE            (HWRITES0),
     .HSIZE             (HSIZEword),
     .HREADYIN          (TieOffHi1),
     .HADDR             (HADDRS0[11:2]), 
     .HWDATA            (HWDATAM0),
        //Output
     .HRDATA            (HRDATAdmac),
     .HRESP             (HRESPdmac),
     .HREADYOUT         (HREADYOUTdmac),
     // DMA response/request signals
        //Input
     .DMACBREQ          (DMACBREQ),
     .DMACSREQ          (DMACSREQ),
     .DMACLBREQ         (DMACLBREQ),
     .DMACLSREQ         (DMACLSREQ),
        //Output
     .DMACCLR           (DMACCLR),
     .DMACTC            (DMACTC),

     // Interrupt request signals
        //Output
     .DMACINTERR        (DMACINTERR),
     .DMACINTTC         (DMACINTTC),
     .DMACINTR          (DMACINTR),

     // AHB master signals
        //Output
     .HADDRM            (HADDRS1),
     .HWRITEM           (HWRITES1),
     .HSIZEM            (HSIZES1),
     .HPROTM            (HPROPS1),
     .HLOCKDMACM        (HMASTLOCKS1),
     .HTRANSM           (HTRANSS1),
     .HBURSTM           (HBURSTS1),
     .HWDATAM           (HWDATAS1),
        //Input
     .HRDATAM           (HRDATAS1),
     .HREADYINM         (HREADYmtrxS1), 
     .HRESPM            (HRESPS1),

     // AHB arbiter
        //Input
     .HBUSREQDMACM      (HBUSREQDMACM),
     .HGRANTDMACM       (HGRANTDMACM),

     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKinp1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKinp1) // Scan Chain Output
     );

// Outport 0 (TIC, SMI, Retry slave, Default Slave and Lite2AHB wrapper)
  Outport0 uOutport0 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Matrix AHB connections
     .HADDR       (HADDRM0),
     .HBURST      (HBURSTM0),
     .HMASTLOCK   (HMASTLOCKM0),
     .HPROT       (HPROTM0),
     .HREADYmtrx  (HREADYM0),
     .HSELmtrx    (HSELM0),
     .HSIZE       (HSIZEM0),
     .HTRANS      (HTRANSM0),
     .HWDATA      (HWDATAM0),
     .HWRITE      (HWRITEM0),

     .HRDATA      (HRDATAM0),
     .HREADYOUT   (HREADYOUTM0),
     .HRESP       (HRESPM0),

     // Remap control signal
     .Remap       (Remap),

     // EBI external connections
     .EBIEXTDATAIN    (EBIEXTDATAIN),
     .EBIEXTDATAOUT   (EBIEXTDATAOUT),
     .EBIEXTADDROUT   (EBIEXTADDROUT),
     .nEBIEXTDATAEN   (nEBIEXTDATAEN),
     .SMCS        (SMCS),
     .nSMBLS      (nSMBLS),
     .nSMOEN      (nSMOEN),

     // MPMC Off-chip memory bus
     // input
     .MPMCBIGENDIAN    (MPMCBIGENDIAN),
     .MPMCDATAIN       (MPMCDATAIN),
     .MPMCFBCLKIN0     (MPMCFBCLKIN0),
     .MPMCFBCLKIN1     (MPMCFBCLKIN1),
     .MPMCFBCLKIN2     (MPMCFBCLKIN2),
     .MPMCFBCLKIN3     (MPMCFBCLKIN3),
     .MPMCSTCS1MW      (MPMCSTCS1MW),
     .MPMCSTCS0POL     (MPMCSTCS0POL),
     .MPMCSTCS1POL     (MPMCSTCS1POL),
     .MPMCSTCS2POL     (MPMCSTCS2POL),
     .MPMCSTCS3POL     (MPMCSTCS3POL),
     .MPMCTESTIN       (MPMCTESTIN),
     // output         
     .MPMCADDROUT      (MPMCADDROUT),
     .MPMCCKEOUT       (MPMCCKEOUT),
     .MPMCCLKOUT       (MPMCCLKOUT),
     .MPMCDATAOUT      (MPMCDATAOUT),
     .MPMCDQMOUT       (MPMCDQMOUT),
     .MPMCRPVHHOUT     (MPMCRPVHHOUT),
     .nMPMCBLSOUT      (nMPMCBLSOUT),
     .nMPMCCASOUT      (nMPMCCASOUT),
     .nMPMCDYCSOUT     (nMPMCDYCSOUT),
     .nMPMCOEOUT       (nMPMCOEOUT),
     .nMPMCRASOUT      (nMPMCRASOUT),
     .nMPMCRPOUT       (nMPMCRPOUT),
     .nMPMCSTCSOUT     (nMPMCSTCSOUT),
     .nMPMCWEOUT       (nMPMCWEOUT),
     .nMPMCDATAEN      (nMPMCDATAEN),

     .HRDATAdmac   (HRDATAdmac),
     .HREADYdmac   (HREADYOUTdmac),
     .HRESPdmac    (HRESPdmac),
     .HSELdmac    (HSELdmac),

     // TIC connections (AHB)
     .HADDRtst    (HADDRtst),
     .HSELtst     (HSELtst),
     .HTRANStst   (HTRANStst),
     .HWRITEtst   (HWRITEtst),
     .HWDATAtst   (HWDATAtst),

     .HREADYtst   (HREADYtst),
     .HRESPtst    (HRESPtst),
     .HRDATAtst   (HRDATAtst),

     // TIC test signals
     .TESTREQA    (TESTREQA),
     .TESTREQB    (TESTREQB),
     .TESTACK     (TESTACK),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),      // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKoutp0), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKoutp0) // Scan Chain Output
    );

// Outport 1 (AHB IRQ Controller)
  Outport1 uOutport1 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Matrix AHB connections
     .HADDR       (HADDRM1),
     .HBURST      (HBURSTM1),
     .HPROT       (HPROTM1),
     .HREADYmtrx  (HREADYM1),
     .HSELmtrx    (HSELM1),
     .HSIZE       (HSIZEM1),
     .HTRANS      (HTRANSM1),
     .HWDATA      (HWDATAM1),
     .HWRITE      (HWRITEM1),

     .HRDATA      (HRDATAM1),
     .HREADYOUT   (HREADYOUTM1),
     .HRESP       (HRESPM1),
 
     // Peripheral interrupt sources
     .WDOGINT     (WDOGINT),
     .TIMINTC     (TIMINTC),
     .TIMINT2     (TIMINT2),
     .TIMINT1     (TIMINT1),
     .GPIOMIS     (GPIOMIS),
     .GPIOINTR    (GPIOINTR),
     .UARTINTR    (UARTINTR),    // Combined interrupt
     .DMACINTR    (DMACINTR),     // Combined interrupt
     .MMCIINTR0   (MMCIINTR0),
     .MMCIINTR1   (MMCIINTR1),
     .SCIINTR	  (SCIINTR),
     .RTCINTR	  (RTCINTR),         
     .AACIINTR	  (AACIINTR),   
     // Processor interrupts
     .nICFIQ      (nFIQ),
     .nICIRQ      (nIRQ),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),      // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKoutp1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKoutp1) // Scan Chain Output
    );
// Outport 2 (AHB-APB bridge, Timers, Remap/Pause, Watchdog, Example APB Slave
//  ,GPIO, UART)

wire UARTloop;

  Outport2 uOutport2 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Matrix AHB connections
     .HADDR       (HADDRM2),
     .HBURST      (HBURSTM2),
     .HPROT       (HPROTM2),
     .HREADYmtrx  (HREADYM2),
     .HSELmtrx    (HSELM2),
     .HSIZE       (HSIZEM2),
     .HTRANS      (HTRANSM2),
     .HWDATA      (HWDATAM2),
     .HWRITE      (HWRITEM2),

     .HRDATA      (HRDATAM2),
     .HREADYOUT   (HREADYOUTM2),
     .HRESP       (HRESPM2),

     // Timer signals 
     .TIMINT1     (TIMINT1),
     .TIMINT2     (TIMINT2),
     .TIMINTC     (TIMINTC),

     // Watchdog signals
     .WDOGRESn    (WDOGRESn),
     .WDOGRES     (WDOGRES),
     .WDOGINT     (WDOGINT),

     // Processor interrupts
     .nFIQ        (nFIQ),
     .nIRQ        (nIRQ),

     // Remap/Pause control signals
     .Pause       (Pause),
     .Remap       (Remap),

     // GPIO signals
     .GPIN        (GPIN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .GPOUT       (GPOUT),
     .nGPEN       (nGPEN),
     .GPAFIN      (GPAFIN),
     .GPIOINTR    (GPIOINTR),
     .GPIOMIS     (GPIOMIS),

     // UART signals
     .nUARTCTS    (nUARTCTS),
     .nUARTDCD	  (nUARTDCD),
     .nUARTDSR    (nUARTDSR),
     .nUARTRI     (nUARTRI),
     //.UARTRXD     (UARTRXD),
     .UARTRXD     (UARTloop), // for DMA tst
     .SIRIN       (SIRIN),
     //.UARTTXD     (UARTTXD,)
     .UARTTXD     (UARTloop), // for DMA tst
     .nSIROUT     (nSIROUT),
     .nUARTDTR    (nUARTDTR),
     .UARTINTR    (UARTINTR),  // 9     Combined interrupt
  
     //UART DMA interface
     .UARTRXDMACLR      (DMACCLR[1]),
     .UARTTXDMACLR      (DMACCLR[0]),
     .UARTTXDMASREQ     (UARTTXDMASREQ),
     .UARTTXDMABREQ     (UARTTXDMABREQ),
     .UARTRXDMASREQ     (UARTRXDMASREQ),
     .UARTRXDMABREQ     (UARTRXDMABREQ),

     //MMC
     .MMCIDMACLR        (DMACCLR[2]),
     .MCLK              (HCLK),
     .nMCLK             (nHCLK),
     .MMCIFBCLK         (MMCIFBCLK),
     .nMMCIRST          (nMMCIRST),
     .MMCICMDIN         (MMCICMDIN),
     .MMCIDATIN         (MMCIDATIN),

     .MMCIINTR0         (MMCIINTR0),
     .MMCIINTR1         (MMCIINTR1),

     .MMCIDMASREQ       (MMCIDMASREQ),
     .MMCIDMABREQ       (MMCIDMABREQ),
     .MMCIDMALSREQ      (MMCIDMALSREQ),
     .MMCIDMALBREQ      (MMCIDMALBREQ),

     .MMCICLKOUT        (MMCICLKOUT),
     .MMCICMDOUT        (MMCICMDOUT),
     .nMMCICMDEN        (nMMCICMDEN),
     .MMCIDATOUT        (MMCIDATOUT),

     .nMMCIDATEN        (nMMCIDATEN),
     .MMCIPWR           (MMCIPWR),
     .MMCIROD           (MMCIROD),
     .MMCIVDD           (MMCIVDD),

     // SCI
        // PAD
     .SCIDATAIN		(SCIDATAIN),
     .SCICLKIN		(SCICLKIN),
     .SCIDETECT		(SCIDETECT),
     .SCIDEACREQ	(SCIDEACREQ),

     .nSCIDATAOUTEN	(nSCIDATAOUTEN),
     .nSCIDATAEN	(nSCIDATAEN),
     .SCICLKOUT		(SCICLKOUT),
     .nSCICLKOUTEN	(nSCICLKOUTEN),
     .nSCICLKEN		(nSCICLKEN),
     .nSCICARDRST	(nSCICARDRST),
     .SCIFCB		(SCIFCB),
     .SCIVCCEN		(SCIVCCEN),
     .SCIDEACACK	(SCIDEACACK),

      // Interrupt
     .SCIINTR		(SCIINTR),

      // DMA
     .SCITXDMACLR	(DMACCLR[3]),
     .SCIRXDMACLR	(DMACCLR[4]),
     .SCITXDMASREQ	(SCITXDMASREQ),
     .SCITXDMABREQ	(SCITXDMABREQ),
     .SCIRXDMASREQ	(SCIRXDMASREQ),
     .SCIRXDMABREQ	(SCIRXDMABREQ),

     // SSP
        // PAD
     .SSPRXD            (SSPRXD  ),
     .SSPFSSIN          (SSPFSSIN),
     .SSPCLKIN          (SSPCLKIN),
                        
     .SSPFSSOUT         (SSPFSSOUT),
     .SSPCLKOUT         (SSPCLKOUT),
     .SSPTXD            (SSPTXD   ),
     .nSSPOE            (nSSPOE   ),
     .nSSPCTLOE         (nSSPCTLOE),

      // Interrupt
     .SSPINTR           (SSPINTR),      

      // DMA
     .SSPTXDMACLR       (DMACCLR[5]),
     .SSPRXDMACLR       (DMACCLR[6]),
     .SSPTXDMASREQ      (SSPTXDMASREQ),
     .SSPTXDMABREQ      (SSPTXDMABREQ),
     .SSPRXDMASREQ      (SSPRXDMASREQ),
     .SSPRXDMABREQ      (SSPRXDMABREQ),

      // AACI
      	//PAD
     .AACIBITCLK	(AACIBITCLK),      
     .nAACIBITCLK	(nAACIBITCLK),     

     .nAACIBITCLKRST	(nAACIBITCLKRST),
     .nFAACIBITCLKRST	(nFAACIBITCLKRST),
     .AACISDATAIN	(AACISDATAIN), 

     .AACIRESET		(AACIRESET),
     .AACISYNC		(AACISYNC),
     .AACISDATAOUT	(AACISDATAOUT),    

      	//Interrupt
     .AACIINTR		(AACIINTR),   

      	//DMA
     .AACIDMACLRRX	(DMACCLR[7]), 
     .AACIDMACLRTX	(DMACCLR[8]),
     .AACIDMASREQRX	(AACIDMASREQRX),
     .AACIDMALSREQRX	(AACIDMALSREQRX),
     .AACIDMABREQRX	(AACIDMABREQRX),
     .AACIDMALBREQRX	(AACIDMALBREQRX),
     .AACIDMABREQTX	(AACIDMABREQTX),

     // RTC
     .CLK1HZ		(CLK1HZ ),         
     .nRTCRST		(nRTCRST),        
     .RTCINTR		(RTCINTR),         

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE        (SCANENABLE),       // Scan Test Mode Enable
     .SCANINHCLK        (SCANINHCLKoutp2),  // Scan Chain Input (HCLK)
     .SCANOUTHCLK       (SCANOUTHCLKoutp2), // Scan Chain Output (HCLK)
     .SCANINPCLK        (SCANINPCLKoutp2),  // Scan Chain Input (PCLK)
     .SCANOUTPCLK       (SCANOUTPCLKoutp2)  // Scan Chain Output (PCLK)
    );


endmodule

// --================================= End ===================================--

