//====================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//  
//----------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : A922T.v,v
// File Revision       : 1.19
// 
// Release Information : CPU_AHB_Wrappers-RELv1r1
// 
//----------------------------------------------------------------------
// Purpose             : To integrate the ARM core with the AMBA wrapper
//                       and provide an AMBA compatible bus master to 
//                       higher hierarchical levels.
//                       This file is a modified version of A920T.v
//                       to use the ARM922T processor
//====================================================================--

`timescale 1ns/1ps

module A922T (HCLK, HRESETn, HRDATAM, HREADYM, HRESPM, HGRANTM,
	      HADDRM, HTRANSM, HWRITEM, HSIZEM, HBURSTM, HPROTM,
	      HWDATAM, HBUSREQM, HLOCKM, HADDRS, HTRANS1S, HWRITES,
	      HWDATAS, HSELS, HREADYS, HRDATAS, HREADYOUTS, HRESPS,
	      FCLK, ARMNFIQ, ARMNIRQ, COMMRX, COMMTX, nTRST, TCK, TDI, 
	      TMS, nTDOEN, TDO,
    	      SCANENABLE,    // Scan Enable
    	      SCANINHCLK,    // HCLK domain Scan input
              SCANOUTHCLK   // HLCK domain Scan output
	      );
  // Signals used during normal operation and test mode
  input  HCLK;
  input  HRESETn;

  // Signals from AMBA bus used during normal operation
  input [31:0] HRDATAM;
  input        HREADYM;
  input [1:0]  HRESPM;
  input        HGRANTM;

  // Signals to AMBA bus used during normal operation
  output [31:0] HADDRM;
  output [1:0] 	HTRANSM;
  output 	HWRITEM;
  output [2:0] 	HSIZEM;
  output [2:0] 	HBURSTM;
  output [3:0] 	HPROTM;
  output [31:0] HWDATAM;
  output 	HBUSREQM;
  output 	HLOCKM;

  // Signals from AMBA bus used during test mode
  input [11:2] 	HADDRS;
  input  	HTRANS1S;
  input 	HWRITES;
  input [31:0] 	HWDATAS;
  input 	HSELS;
  input 	HREADYS;

  // Signals to AMBA bus used during test mode
  output [31:0] HRDATAS;
  output 	HREADYOUTS;
  output [1:0] 	HRESPS;

  // Fast Cache clock
  input 	FCLK;
  
  // ARM interrupts
  input 	ARMNFIQ;
  input 	ARMNIRQ;

  // Comms channel signals
  output 	COMMRX;
  output 	COMMTX;

  // JTAG connections
  input 	nTRST;
  input 	TCK;
  input 	TDI;
  input 	TMS;
  output 	nTDOEN;
  output 	TDO;

  // ATPG scan connections
  input		SCANENABLE;
  input		SCANINHCLK;
  output	SCANOUTHCLK;

  //---------------------------------------------------------------------- 
  // Signal declarations
  //----------------------------------------------------------------------

  wire 		AGNT;
  wire [11:2] 	AIN;
  wire [31:0] 	AOUT;
  wire 		AREQ;
  wire 		ASTB;
  wire 		BnRES;
  wire [1:0] 	BURST;
  wire [31:0] 	DIN;
  wire [31:0] 	DOUT;
  wire 		DSEL;
  wire 		ENBA;
  wire 		ENBD;
  wire 		ENBTRAN;
  wire 		ENSR;
  wire 		ERRORIN;
  wire 		ERROROUT;
  wire 		LASTIN;
  wire 		LASTOUT;
  wire 		LOK;
  wire 		NCMAHB;
  wire [1:0] 	PROT;
  wire [1:0] 	SIZE;
  wire [1:0] 	TRAN;
  wire 		WAITIN;
  wire 		WAITOUT;
  wire 		WRITEIN;
  wire 		WRITEOUT;
  wire [1:0] 	CHSDE;
  wire [1:0] 	CHSEX;
  wire 		CPCLK;
  wire [31:0] 	CPDOUT;
  wire [31:0] 	CPDIN;
  wire [31:0] 	CPID;
  wire 		CPLATECANCEL;
  wire 		nCPMREQ;
  wire 		CPPASS;
  wire 		CPTBIT;
  wire 		nCPTRANS;
  wire 		nCPWAIT;
  wire 		CPEN;
  wire 		DRIVEOUTBS;
  wire 		ECAPCLKBS;
  wire 		ICAPCLKBS;
  wire [3:0] 	IR;
  wire 		PCLKBS;
  wire 		RSTCLKBS;
  wire [4:0] 	SCREG;
  wire 		SDIN;
  wire 		SDOUTBS;
  wire 		SHCLK1BS;
  wire 		SHCLK2BS;
  wire [3:0] 	TAPSM;
  wire 		TCK1;
  wire 		TCK2;
  wire [31:0] 	TAPID;
  wire 		DBGACK;
  wire 		DBGEN;
  wire 		DBGRQI;
  wire 		DEWPT;
  wire 		ECLK;
  wire 		EDBGRQ;
  wire 		EXTERN0;
  wire 		EXTERN1;
  wire 		IEBKPT;
  wire 		INSTREXEC;
  wire 		RANGEOUT0;
  wire 		RANGEOUT1;
  wire 		TRACK;
  wire 		BIGENDOUT;
  wire 		FCLKOUT;
  wire 		VINITHI;
  wire 		ISYNC;
  wire 		ETMPWRDOWN;
  wire 		ETMBIGEND;
  wire 		ETMCLOCK;
  wire 		ETMHIVECS;
  wire 		ETMnWAIT;
  wire [31:1] 	ETMIA;
  wire 		ETMInMREQ;
  wire 		ETMISEQ;
  wire 		ETMITBIT;
  wire 		ETMIABORT;
  wire [31:24] 	ETMID31To24;
  wire [15:8] 	ETMID15To8;
  wire [31:0] 	ETMDA;
  wire [31:0] 	ETMDD;
  wire [1:0] 	ETMDMAS;
  wire 		ETMDMORE;
  wire 		ETMDnMREQ;
  wire 		ETMDnRW;
  wire 		ETMDSEQ;
  wire [1:0] 	ETMCHSD;
  wire [1:0] 	ETMCHSE;
  wire 		ETMLATECANCEL;
  wire 		ETMPASS;
  wire 		ETMDABORT;
  wire 		ETMDBGACK;
  wire 		ETMINSTREXEC;
  wire [1:0] 	ETMRNGOUT;

//----------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------

  // Default core connections that are not used in AHB wrapper
  // AMBA signals
  assign  LASTIN  = 1'b0 ;

  // Coprocessor interface signals
  assign  CHSDE  = 2'b10;
  assign  CHSEX  = 2'b10;
  assign  CPDIN  = {32{1'b0}};

  // JTAG and TAP controller signals
  assign  SDOUTBS  = 1'b0 ;

  // Debug signals
  assign  DBGEN    = 1'b1 ;
  assign  DEWPT    = 1'b0 ;
  assign  EDBGRQ   = 1'b0 ;
  assign  EXTERN0  = 1'b0 ;
  assign  EXTERN1  = 1'b0 ;
  assign  IEBKPT   = 1'b0 ;
  assign  TRACK    = 1'b0 ;

  // Miscellaneous signals
  assign  VINITHI    = 1'b0 ; // Exception vectors located at 0x00000000
  assign  ISYNC      = 1'b0 ; // Asynchronous interrupts allowed
  assign  CPEN       = 1'b0 ;
  // The TAPID value must match the ARM CPU used, else the TIC tests will show
  // violations.  The value 0x00922FOF is correct for a rev0 ARM922T
  assign  TAPID      = 32'h00922F0F;
  assign  ETMPWRDOWN = 1'b0 ;

  A920TWrap  uA920TWrap
    //------------------------------------------------------
    // AMBA bus signals
    //------------------------------------------------------
    // Signals used during normal operation and test mode
    (.HCLK (HCLK),
     .HRESETn (HRESETn),

     // Signals from AMBA bus used during normal operation
     .HRDATAM (HRDATAM),
     .HREADYM (HREADYM),
     .HRESPM (HRESPM),
     .HGRANTM (HGRANTM),

     // Signals to AMBA bus used during normal operation
     .HADDRM (HADDRM),
     .HTRANSM (HTRANSM),
     .HWRITEM (HWRITEM),
     .HSIZEM (HSIZEM),
     .HBURSTM (HBURSTM),
     .HPROTM (HPROTM),
     .HWDATAM (HWDATAM),
     .HBUSREQM (HBUSREQM),
     .HLOCKM (HLOCKM),

     // Signals from AMBA bus used during test mode
     .HADDRS (HADDRS),
     .HTRANS1S (HTRANS1S),
     .HWRITES (HWRITES),
     .HWDATAS (HWDATAS),
     .HSELS (HSELS),
     .HREADYS (HREADYS),

     // Signals to AMBA bus used during test mode
     .HRDATAS (HRDATAS),
     .HREADYOUTS (HREADYOUTS),
     .HRESPS (HRESPS),

     //------------------------------------------------------
     // ARM core signals
     //------------------------------------------------------
     // Signals used during normal operation and test mode
     .BnRES (BnRES),
     .DOUT (DOUT),
     .DIN (DIN),

     // Signals from ARM core used during normal operation
     .AOUT (AOUT),
     .AREQ (AREQ),
     .ASTB (ASTB),
     .BURST (BURST),
     .LOK (LOK),
     .NCMAHB (NCMAHB),
     .PROT (PROT),
     .SIZE (SIZE),
     .TRAN (TRAN),
     .WRITEOUT (WRITEOUT),

     // Signals to ARM core used during normal operation
     .AGNT (AGNT),
     .WAITIN (WAITIN),
     .ERRORIN (ERRORIN),

     // Signals from ARM core used during test mode
     .WAITOUT (WAITOUT),

     // Signals to ARM core used during test mode
     .AIN (AIN [11:2] ),
     .DSEL (DSEL),
     .WRITEIN (WRITEIN),
     .SCANENABLE  (SCANENABLE),    // Scan Enable
     .SCANINHCLK  (SCANINHCLK),    // HCLK domain Scan input
     .SCANOUTHCLK (SCANOUTHCLK)   // HLCK domain Scan output
     );

  ARM922T  uARM922T 
    // AMBA signals
    (.AGNT (AGNT),
     .AIN (AIN),
     .AOUT (AOUT),
     .AREQ (AREQ),
     .ASTB (ASTB),
     .BCLK (HCLK),
     .BnRES (BnRES),
     .BURST (BURST),
     .DIN (DIN),
     .DOUT (DOUT),
     .DSEL (DSEL),
     .ENBA (ENBA),
     .ENBD (ENBD),
     .ENBTRAN (ENBTRAN),
     .ENSR (ENSR),
     .ERRORIN (ERRORIN),
     .ERROROUT (ERROROUT),
     .LASTIN (LASTIN),
     .LASTOUT (LASTOUT),
     .LOK (LOK),
     .NCMAHB (NCMAHB),
     .PROT (PROT),
     .SIZE (SIZE),
     .TRAN (TRAN),
     .WAITIN (WAITIN),
     .WAITOUT (WAITOUT),
     .WRITEIN (WRITEIN),
     .WRITEOUT (WRITEOUT),

     // Coprocessor interface signals
     .CHSDE (CHSDE),
     .CHSEX (CHSEX),
     .CPCLK (CPCLK),
     .CPDOUT (CPDOUT),
     .CPDIN (CPDIN),
     .CPID (CPID),
     .CPLATECANCEL (CPLATECANCEL),
     .nCPMREQ (nCPMREQ),
     .CPPASS (CPPASS),
     .CPTBIT (CPTBIT),
     .nCPTRANS (nCPTRANS),
     .nCPWAIT (nCPWAIT),
     .CPEN (CPEN),

     // JTAG and TAP controller signals
     .DRIVEOUTBS (DRIVEOUTBS),
     .ECAPCLKBS (ECAPCLKBS),
     .ICAPCLKBS (ICAPCLKBS),
     .IR (IR),
     .PCLKBS (PCLKBS),
     .RSTCLKBS (RSTCLKBS),
     .SCREG (SCREG),
     .SDIN (SDIN),
     .SDOUTBS (SDOUTBS),
     .SHCLK1BS (SHCLK1BS),
     .SHCLK2BS (SHCLK2BS),
     .TAPSM (TAPSM),
     .TCK (TCK),
     .TCK1 (TCK1),
     .TCK2 (TCK2),
     .TDI (TDI),
     .TDO (TDO),
     .nTDOEN (nTDOEN),
     .TMS (TMS),
     .nTRST (nTRST),
     .TAPID (TAPID),

     // Debug signals
     .COMMRX (COMMRX),
     .COMMTX (COMMTX),
     .DBGACK (DBGACK),
     .DBGEN (DBGEN),
     .DBGRQI (DBGRQI),
     .DEWPT (DEWPT),
     .ECLK (ECLK),
     .EDBGRQ (EDBGRQ),
     .EXTERN0 (EXTERN0),
     .EXTERN1 (EXTERN1),
     .IEBKPT (IEBKPT),
     .INSTREXEC (INSTREXEC),
     .RANGEOUT0 (RANGEOUT0),
     .RANGEOUT1 (RANGEOUT1),
     .TRACK (TRACK),

     // Miscellaneous signals
     .BIGENDOUT (BIGENDOUT),
     .FCLKOUT (FCLKOUT),
     .FCLK (FCLK),
     .VINITHI (VINITHI),
     .ISYNC (ISYNC),
     .nFIQ (ARMNFIQ),
     .nIRQ (ARMNIRQ),

     // ETM Support
     .ETMPWRDOWN (ETMPWRDOWN),
     .ETMBIGEND (ETMBIGEND),
     .ETMCLOCK (ETMCLOCK),
     .ETMHIVECS (ETMHIVECS),
     .ETMnWAIT (ETMnWAIT),
     .ETMIA (ETMIA),
     .ETMInMREQ (ETMInMREQ),
     .ETMISEQ (ETMISEQ),
     .ETMITBIT (ETMITBIT),
     .ETMIABORT (ETMIABORT),
     .ETMID31To24 (ETMID31To24),
     .ETMID15To8 (ETMID15To8),
     .ETMDA (ETMDA),
     .ETMDD (ETMDD),
     .ETMDMAS (ETMDMAS),
     .ETMDMORE (ETMDMORE),
     .ETMDnMREQ (ETMDnMREQ),
     .ETMDnRW (ETMDnRW),
     .ETMDSEQ (ETMDSEQ),
     .ETMCHSD (ETMCHSD),
     .ETMCHSE (ETMCHSE),
     .ETMLATECANCEL (ETMLATECANCEL),
     .ETMPASS (ETMPASS),
     .ETMDABORT (ETMDABORT),
     .ETMDBGACK (ETMDBGACK),
     .ETMINSTREXEC (ETMINSTREXEC),
     .ETMRNGOUT (ETMRNGOUT)
     );
endmodule
