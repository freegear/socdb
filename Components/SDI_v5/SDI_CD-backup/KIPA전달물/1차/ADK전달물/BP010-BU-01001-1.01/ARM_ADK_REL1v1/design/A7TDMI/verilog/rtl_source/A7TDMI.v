//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : A7TDMI.v,v
//  File Revision       : 1.14
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//
//  ----------------------------------------------------------------------------
//  Purpose             : To integrate the arm core with the AMBA wrapper and
//                        provide an AMBA compatible bus master to higher
//                        hierarchical levels.
//  --========================================================================--
`timescale 1ns/1ps
 
module A7TDMI (HCLK, HRESETn, HRDATAM, HREADYM, HRESPM, HGRANTM, HADDRM,
               HTRANSM, HWRITEM, HSIZEM, HBURSTM, HPROTM, HWDATAM,
               HBUSREQM, HLOCKM, HTRANS1S, HWRITES, HWDATAS, HSELS, HREADYS,
               HRDATAS, HREADYOUTS, HRESPS, ARMNFIQ, ARMNIRQ, COMMRX, COMMTX,
               nTRST, TCK, TDI, TMS, nTDOEN, TDO,
    	       SCANENABLE,    // Scan Enable
    	       SCANINHCLK,    // HCLK domain Scan input
               SCANOUTHCLK   // HLCK domain Scan output
	       );

  // Signals used during normal operation and test mode
  input         HCLK;
  input         HRESETn;

  // Signals from AMBA bus used during normal operation
  input  [31:0] HRDATAM;
  input         HREADYM;
  input   [1:0] HRESPM;
  input         HGRANTM;

  // Signals to AMBA bus used during normal operation
  output [31:0] HADDRM;
  output  [1:0] HTRANSM;
  output        HWRITEM;
  output  [2:0] HSIZEM;
  output  [2:0] HBURSTM;
  output  [3:0] HPROTM;
  output [31:0] HWDATAM;
  output        HBUSREQM;
  output        HLOCKM;

  // Signals from AMBA bus used during test mode
  input         HTRANS1S;
  input         HWRITES;
  input  [31:0] HWDATAS;
  input         HSELS;
  input         HREADYS;

  // Signals to AMBA bus used during test mode
  output [31:0] HRDATAS;
  output        HREADYOUTS;
  output  [1:0] HRESPS;

  // ARM interrupts
  input         ARMNFIQ;
  input         ARMNIRQ;

  // Comms channel signals
  output        COMMRX;
  output        COMMTX;

  // JTAG connections
  input         nTRST;
  input         TCK;
  input         TDI;
  input         TMS;
  output        nTDOEN;
  output        TDO;

  // ATPG scan connections
  input		SCANENABLE;
  input		SCANINHCLK;
  output	SCANOUTHCLK;


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
  wire [31:0] A;
  wire        ABE;
  wire        ABORT;
  wire        ALE;
  wire        APE;
  wire        BIGEND;
  wire  [3:0] BL;
  wire        BREAKPT;
  wire        BUSDIS;
  wire        BUSEN;
  wire        COMMRXi;
  wire        COMMTXi;
  wire        CPA;
  wire        CPB;
  wire [31:0] D;
  wire        DBE;
  wire        DBGACK;
  wire        DBGEN;
  wire        DBGRQ;
  wire        DBGRQI;
  wire [31:0] DIN;
  wire [31:0] DOUT;
  wire        DRIVEBS;
  wire        ECLK;
  wire        ECAPCLK;
  wire        ECAPCLKBS;
  wire        EXTERN0;
  wire        EXTERN1;
  wire        HIGHZ;
  wire        ICAPCLKBS;
  wire  [3:0] IR;
  wire        ISYNC;
  wire        LOCK;
  wire  [1:0] MAS;
  wire        MCLK;
  wire        nCPI;
  wire        nENIN;
  wire        nENOUT;
  wire        nENOUTI;
  wire        nEXEC;
  wire        nFIQ;
  wire        nHIGHZ;
  wire        nIRQ;
  wire  [4:0] nM;
  wire        nMREQ;
  wire        nOPC;
  wire        nRESET;
  wire        nRW;
  wire        nTDOENi;
  wire        nTRANS;
  wire        nTRSTi;
  wire        nWAIT;
  wire        PCLKBS;
  wire        RANGEOUT0;
  wire        RANGEOUT1;
  wire        RSTCLKBS;
  wire  [3:0] SCREG;
  wire        SDINBS;
  wire        SDOUTBS;
  wire        SEQ;
  wire        SHCLKBS;
  wire        SHCLK2BS;
  wire  [3:0] TAPSM;
  wire        TBE;
  wire        TBIT;
  wire        TCKi;
  wire        TCK1;
  wire        TCK2;
  wire        TDIi;
  wire        TDOi;
  wire        TMSi;
 
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// Intermediate signals are needed as these outputs from the core are inputs to
//  the wrapper test block, but outputs from the wrapper.
  assign COMMRX = COMMRXi;
  assign COMMTX = COMMTXi;
  assign nTDOEN = nTDOENi;
  assign TDO    = TDOi;

  assign HWDATAM = DOUT;
 
  A7TWrap uA7TWrap (
    //------------------------------------------------------
    // AMBA bus signals
    //------------------------------------------------------
    // Signals from AMBA bus used during normal operation
    .HCLK        (HCLK),
    .HRESETn     (HRESETn),
    .HRDATAM     (HRDATAM),
    .HREADYM     (HREADYM),
    .HRESPM      (HRESPM),
    .HGRANTM     (HGRANTM),

    // Signals to AMBA bus used during normal operation
    .HADDRM      (HADDRM),
    .HTRANSM     (HTRANSM),
    .HWRITEM     (HWRITEM),
    .HSIZEM      (HSIZEM),
    .HBURSTM     (HBURSTM),
    .HPROTM      (HPROTM),
    .HBUSREQM    (HBUSREQM),
    .HLOCKM      (HLOCKM),

    // Signals from AMBA bus used during test mode
    .HTRANS1S    (HTRANS1S),
    .HWRITES     (HWRITES),
    .HWDATAS     (HWDATAS),
    .HSELS       (HSELS),
    .HREADYS     (HREADYS),

    // Signals to AMBA bus used during test mode
    .HRDATAS     (HRDATAS),
    .HREADYOUTS  (HREADYOUTS),
    .HRESPS      (HRESPS),

    // ARM interrupts
    .ARMNFIQ     (ARMNFIQ),
    .ARMNIRQ     (ARMNIRQ),

    //------------------------------------------------------
    // ARM core signals
    //------------------------------------------------------
    // Signals from ARM core used during normal operation
    .A           (A),
    .DOUT        (DOUT),
    .LOCK        (LOCK),
    .MAS         (MAS),
    .nMREQ       (nMREQ),
    .nOPC        (nOPC),
    .nRW         (nRW),
    .nTRANS      (nTRANS),
    .SEQ         (SEQ),

    // Signals to ARM core used during normal operation
    .ABORT       (ABORT),
    .DIN         (DIN),
    .MCLK        (MCLK),
    .nFIQ        (nFIQ),
    .nIRQ        (nIRQ),
    .nRESET      (nRESET),
    .nWAIT       (nWAIT),

    // Signals to ARM core used during test mode.
    // During normal operation these signals are tied off to static values.
    .ABE         (ABE),
    .ALE         (ALE),
    .APE         (APE),
    .BIGEND      (BIGEND),
    .BL          (BL),
    .BREAKPT     (BREAKPT),
    .BUSEN       (BUSEN),
    .CPA         (CPA),
    .CPB         (CPB),
    .DBE         (DBE),
    .DBGEN       (DBGEN),
    .DBGRQ       (DBGRQ),
    .EXTERN0     (EXTERN0),
    .EXTERN1     (EXTERN1),
    .ISYNC       (ISYNC),
    .nENIN       (nENIN),
    .SDOUTBS     (SDOUTBS),
    .TBE         (TBE),

    // Signals from ARM core used during test mode.
    .BUSDIS      (BUSDIS),
    .COMMRX      (COMMRXi),
    .COMMTX      (COMMTXi),
    .DBGACK      (DBGACK),
    .DBGRQI      (DBGRQI),
    .HIGHZ       (HIGHZ),
    .RANGEOUT0   (RANGEOUT0),
    .RANGEOUT1   (RANGEOUT1),
    .nCPI        (nCPI),
    .nENOUT      (nENOUT),
    .nENOUTI     (nENOUTI),
    .nEXEC       (nEXEC),
    .nM          (nM),
    .nTDOEN      (nTDOENi),
    .SCREG       (SCREG),
    .TBIT        (TBIT),

    //------------------------------------------------------
    // JTAG signals
    //------------------------------------------------------
    // JTAG inputs from external tester and ARM core
    .xnTRST      (nTRST),
    .xTCK        (TCK),
    .xTDI        (TDI),
    .xTMS        (TMS),
    .xTDO        (TDOi),

    // JTAG outputs to core, after passing through test logic
    .nTRST       (nTRSTi),
    .TCK         (TCKi),
    .TDI         (TDIi),
    .TMS         (TMSi),
    .SCANENABLE  (SCANENABLE),    // Scan Enable
    .SCANINHCLK  (SCANINHCLK),    // HCLK domain Scan input
    .SCANOUTHCLK (SCANOUTHCLK)   // HLCK domain Scan output
    );
 

  ARM7TDMI uARM7TDMI (
    .A         (A),         //  Output becomes HADDR
    .ABE       (ABE),       //  Usually tied HIGH
    .ABORT     (ABORT),     //  Input comes from HRESP
    .ALE       (ALE),       //  Usually tied HIGH
    .APE       (APE),       //  Usually tied HIGH
    .BIGEND    (BIGEND),    //  Usually tied LOW
    .BL        (BL),        //  Usually tied HIGH
    .BREAKPT   (BREAKPT),   //  Usually tied LOW
    .BUSDIS    (BUSDIS),    //  Output used for test only
    .BUSEN     (BUSEN),     //  Tied HIGH
    .COMMRX    (COMMRXi),   //  Output to system COMMRX
    .COMMTX    (COMMTXi),   //  Output to system COMMTX
    .CPA       (CPA),       //  Usually tied HIGH
    .CPB       (CPB),       //  Usually tied HIGH
    .D         (D),         //  Unconnected, DIN and DOUT used
    .DBE       (DBE),       //  Tied HIGH
    .DBGACK    (DBGACK),    //  Output used for test only
    .DBGEN     (DBGEN),     //  Usually tied HIGH
    .DBGRQ     (DBGRQ),     //  Usually tied LOW
    .DBGRQI    (DBGRQI),    //  Output used for test only
    .DIN       (DIN),       //  Input data comes from HRDATA
    .DOUT      (DOUT),      //  Output used to drive HWDATA
    .DRIVEBS   (DRIVEBS),   //  Unconnected output
    .ECLK      (ECLK),      //  Unconnected output
    .ECAPCLK   (ECAPCLK),   //  Unconnected output
    .ECAPCLKBS (ECAPCLKBS), //  Unconnected output
    .EXTERN0   (EXTERN0),   //  Usually tied LOW
    .EXTERN1   (EXTERN1),   //  Usually tied LOW
    .HIGHZ     (HIGHZ),     //  Output used for test only
    .ICAPCLKBS (ICAPCLKBS), //  Unconnected output
    .IR        (IR),        //  Unconnected output
    .ISYNC     (ISYNC),     //  Usually tied HIGH
    .LOCK      (LOCK),      //  Output used for test only
    .MAS       (MAS),       //  Output used to form HSIZE
    .MCLK      (MCLK),      //  Main clock input
    .nCPI      (nCPI),      //  Output used for test only
    .nENIN     (nENIN),     //  Usually tied LOW
    .nENOUT    (nENOUT),    //  Output used for test only
    .nENOUTI   (nENOUTI),   //  Output used for test only
    .nEXEC     (nEXEC),     //  Output used for test only
    .nFIQ      (nFIQ),      //  Input comes from system FIQ
    .nHIGHZ    (nHIGHZ),    //  Unconnected output
    .nIRQ      (nIRQ),      //  Input comes from system IRQ
    .nM        (nM),        //  Output used for test only
    .nMREQ     (nMREQ),     //  Output used to form HTRANS
    .nOPC      (nOPC),      //  Output used to form HPROT
    .nRESET    (nRESET),    //  Input from system HRESETn
    .nRW       (nRW),       //  Output used to form HWRITE
    .nTDOEN    (nTDOENi),   //  Output used for test only
    .nTRANS    (nTRANS),    //  Output used to from HPROT
    .nTRST     (nTRSTi),    //  Input from system nTRST
    .nWAIT     (nWAIT),     //  Usually tied HIGH
    .PCLKBS    (PCLKBS),    //  Unconnected output
    .RANGEOUT0 (RANGEOUT0), //  Output used for test only
    .RANGEOUT1 (RANGEOUT1), //  Output used for test only
    .RSTCLKBS  (RSTCLKBS),  //  Unconnected output
    .SCREG     (SCREG),     //  Output used for test only
    .SDINBS    (SDINBS),    //  Unconnected output
    .SDOUTBS   (SDOUTBS),   //  Usually tied LOW
    .SEQ       (SEQ),       //  Ouput used to form HTRANS
    .SHCLKBS   (SHCLKBS),   //  Unconnected output
    .SHCLK2BS  (SHCLK2BS),  //  Unconnected output
    .TAPSM     (TAPSM),     //  Unconnected output
    .TBE       (TBE),       //  Usually tied HIGH
    .TBIT      (TBIT),      //  Output used for test only
    .TCK       (TCKi),      //  Input from system TCK
    .TCK1      (TCK1),      //  Unconnected output
    .TCK2      (TCK2),      //  Unconnected output
    .TDI       (TDIi),      //  Input from system TDI
    .TDO       (TDOi),      //  Output to system TDO
    .TMS       (TMSi)       //  Input from system TMS
    );


endmodule

// --================================= End ===================================--
