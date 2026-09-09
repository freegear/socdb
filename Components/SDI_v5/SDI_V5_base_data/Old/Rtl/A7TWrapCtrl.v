//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : A7TWrapCtrl.v,v
//  File Revision       : 1.9
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Multiplexer used to drive the core control inputs with
//                        test data from the A7TWrapTest block.
//                        When the test logic is removed, the TestCtrl bus is
//                        tied off at the next level of hierarchy, allowing this
//                        multiplexer to be optimised out during synthesis or
//                        removed by hand.
//  --========================================================================--

`timescale 1ns/1ps
 
module A7TWrapCtrl (
		    HCLK, HRESETn, ARMNFIQ, ARMNIRQ, xnTRST, xTCK,
		    xTDI, xTMS, AbortInt, TestMode, TestClk, TestCtrl,
		    ABORT, nFIQ, nIRQ, nRESET, TCK, TDI, TMS, nTRST,
		    ABE, ALE, APE, BIGEND, BL, BREAKPT, CPA, CPB,
		    DBGEN, DBGRQ, EXTERN0, EXTERN1, ISYNC, nWAIT,
		    SDOUTBS, TBE, BUSEN, DBE, nENIN
		    );

  // AMBA input signals
  input          HCLK;
  input          HRESETn;

  // Interrupt inputs to core
  input          ARMNFIQ;
  input          ARMNIRQ;

  // JTAG connections
  input          xnTRST;
  input          xTCK;
  input          xTDI;
  input          xTMS;

  // Internal wrapper signals
  // Core ABORT default value
  input          AbortInt;
  // Indicates core TIC testing mode
  input          TestMode;
  // Test clock enable
  input          TestClk;
  // Test input control data
  input [27:0]   TestCtrl;

  // These signals are routed directly from this block to the core.
  output 	 ABORT;
  output 	 nFIQ;
  output 	 nIRQ;
  output 	 nRESET;
  output 	 TCK;
  output 	 TDI;
  output 	 TMS;
  output 	 nTRST;

  // During normal operation these test signals are tied off to
  //  static values, and only change during TIC testing of the core.
  output 	 ABE;
  output 	 ALE;
  output 	 APE;
  output 	 BIGEND;
  output [3:0]   BL;
  output 	 BREAKPT;
  output 	 CPA;
  output 	 CPB;
  output 	 DBGEN;
  output 	 DBGRQ;
  output 	 EXTERN0;
  output 	 EXTERN1;
  output 	 ISYNC;
  output 	 nWAIT;
  output 	 SDOUTBS;
  output 	 TBE;

  // These signals are driven to constant values during test and normal
  //  operation.
  output 	 BUSEN;
  output 	 DBE;
  output 	 nENIN;


     reg ABORT;
     reg nFIQ;
     reg nIRQ;
     reg nRESET;
     reg TCK;
     reg TDI;
     reg TMS;
     reg nTRST;
     reg ABE;
     reg ALE;
     reg APE;
     reg BIGEND;
     reg[3 : 0] BL;
     reg BREAKPT;
     reg CPA;
     reg CPB;
     reg DBGEN;
     reg DBGRQ;
     reg EXTERN0;
     reg EXTERN1;
     reg ISYNC;
     reg nWAIT;
     reg SDOUTBS;
     reg TBE;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Tested signals to the core
//------------------------------------------------------------------------------
// This multiplexer allows various ARM control signal inputs to be exercised
//  via the wrapper test structures when TestMode is asserted. When TestMode is
//  inactive, the control signals revert to their normal default operation.
// If the test wrapper has been removed, then this multiplexer will be
//  optimised out during synthesis, or can be removed by hand.

// The BIGEND and ISYNC default settings may be changed according to the system
//  used:
// BIGEND: Default LOW  - Little Endian
//                 HIGH - Big Endian
// ISYNC:  Default HIGH - Synchronisation of interrupts disabled
//                 LOW  - Synchronisation of interrupts enabled

  always @ (TestMode or AbortInt or ARMNFIQ or ARMNIRQ or HRESETn
	    or xnTRST or xTCK or xTDI or xTMS or TestCtrl or
	    TestClk or HCLK)
    begin : p_CtrlMuxComb
      if  ( TestMode ==1'b0 )
	begin 
	  ABE  = 1'b1 ;
	  ABORT  = AbortInt ;
	  ALE  = 1'b1 ;
	  APE  = 1'b1 ;
	  BIGEND  = 1'b0 ;
	  // Default: Little Endian operation
	  BL[3] = 1'b1 ;
	  BL[2] = 1'b1 ;
	  BL[1] = 1'b1 ;
	  BL[0] = 1'b1 ;
	  BREAKPT  = 1'b0 ;
	  CPA  = 1'b1 ;
	  CPB  = 1'b1 ;
	  DBGEN  = 1'b1 ;
	  DBGRQ  = 1'b0 ;
	  EXTERN0  = 1'b0 ;
	  EXTERN1  = 1'b0 ;
	  ISYNC  = 1'b1 ;
	  // Default: Synchronisation of interrupts disabled
	  nFIQ  = ARMNFIQ ;
	  nIRQ  = ARMNIRQ ;
	  nRESET  = HRESETn ;
	  nWAIT  = 1'b1 ;
	  SDOUTBS  = 1'b0 ;
	  nTRST  = xnTRST ;
	  TCK  = xTCK ;
	  TDI  = xTDI ;
	  TMS  = xTMS ;
	  TBE  = 1'b1 ;
	end
      else
	begin
	  ABE  = TestCtrl[7] ;
	  ABORT  = TestCtrl[2] ;
	  ALE  = TestCtrl[6] ;
	  APE  = TestCtrl[25] ;
	  BIGEND  = TestCtrl[10] ;
	  BL[3] = (TestCtrl[24] & TestClk );
	  BL[2] = (TestCtrl[23] & TestClk );
	  BL[1] = (TestCtrl[22] & TestClk );
	  BL[0] = (TestCtrl[21] & TestClk );
	  BREAKPT  = TestCtrl[13] ;
	  CPA  = TestCtrl[9] ;
	  CPB  = TestCtrl[8] ;
	  DBGEN  = TestCtrl[12] ;
	  DBGRQ  = TestCtrl[14] ;
	  EXTERN0  = TestCtrl[15] ;
	  EXTERN1  = TestCtrl[16] ;
	  ISYNC  = TestCtrl[11] ;
	  nFIQ  = TestCtrl[4] ;
	  nIRQ  = TestCtrl[3] ;
	  nRESET  = TestCtrl[0] ;
	  nWAIT  = (TestCtrl[1] & TestClk );
	  SDOUTBS  = TestCtrl[27] ;
	  nTRST  = TestCtrl[17] ;
	  TCK  = ((TestCtrl[18] & TestClk ) & (~HCLK ));
	  TDI  = TestCtrl[19] ;
	  TMS  = TestCtrl[20] ;
	  TBE  = TestCtrl[26] ;
	end 
    end 

//------------------------------------------------------------------------------
// Untested signals to the core
//------------------------------------------------------------------------------
// These output signals are not tested as part of the core TIC testing, so do
//  not need to be passed through the test multiplexer.
     assign  BUSEN  = 1'b1 ;
     assign  DBE  = 1'b1 ;
     assign  nENIN  = 1'b0 ;
endmodule
