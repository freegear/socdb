//  --================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  --------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : A920TWrap.v,v
//  File Revision       : 1.14
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//  
//  --------------------------------------------------------------------
//  Purpose             : This entity ties together all the sub blocks 
//                        that form the amba wrapper, and provides
//                        interfaces to the AMBA AHB bus and the
//                        processor core.
//  --================================================================--

`timescale 1ns/1ps
 
module A920TWrap (HCLK, HRESETn, HRDATAM, HREADYM, HRESPM, HGRANTM,
		  HADDRM, HTRANSM, HWRITEM, HSIZEM, HBURSTM, HPROTM,
		  HWDATAM, HBUSREQM, HLOCKM, HADDRS, HTRANS1S, HWRITES,
		  HWDATAS, HSELS, HREADYS, HRDATAS, HREADYOUTS,
		  HRESPS, BnRES, DOUT, DIN, AOUT, AREQ, ASTB, BURST,
		  LOK, NCMAHB, PROT, SIZE, TRAN, WRITEOUT, AGNT,
		  WAITIN, ERRORIN, WAITOUT, AIN, DSEL, WRITEIN,
    	       	  SCANENABLE,    // Scan Enable
    	       	  SCANINHCLK,    // HCLK domain Scan input
               	  SCANOUTHCLK   // HLCK domain Scan output
	       	  );
  
  //------------------------------------------------------
  // AMBA bus signals
  //------------------------------------------------------
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
  input         HTRANS1S;
  input 	HWRITES;
  input [31:0] 	HWDATAS;
  input 	HSELS;
  input 	HREADYS;

  // Signals to AMBA bus used during test mode
  output [31:0] HRDATAS;
  output 	HREADYOUTS;
  output [1:0] 	HRESPS;

  //------------------------------------------------------
  // ARM core signals
  //------------------------------------------------------
  // Signals used during normal operation and test mode
  output 	BnRES;
  output [31:0] DIN;
  input [31:0] 	DOUT;

  // Signals from ARM core used during normal operation
  input [31:0] 	AOUT;
  input 	AREQ;
  input 	ASTB;
  input [1:0] 	BURST;
  input 	LOK;
  input 	NCMAHB;
  input [1:0] 	PROT;
  input [1:0] 	SIZE;
  input [1:0] 	TRAN;
  input 	WRITEOUT;

  // Signals to ARM core used during normal operation
  output 	AGNT;
  output 	WAITIN;
  output 	ERRORIN;

  // Signals from ARM core used during test mode
  input 	WAITOUT;

  // Signals to ARM core used during test mode
  output [11:2] AIN;
  output 	DSEL;
  output 	WRITEIN;

  // ATPG scan connections
  input		SCANENABLE;
  input		SCANINHCLK;
  output	SCANOUTHCLK;

  //----------------------------------------------------------------------
  // The wrapper is made up of the following blocks:
  //   A920TWrapSM     - Converts A920T bus accesses into AHB-Lite
  //   A920TWrapMaster - Bus Master interface that controls the wrapper's
  //                     access to the AHB. Converts AHB-Lite accesses
  //                     from A920TWrapSM into full AHB
  //   A920TWrapSlave  - Slave interface that controls the core during TIC
  //                     testing mode.
  //   ClockInv        - Clock inverter
  //----------------------------------------------------------------------

  //----------------------------------------------------------------------
  //  Signal declarations
  //----------------------------------------------------------------------

  wire [1:0] 	MTRANS;
  wire [31:0] 	MADDR;
  wire 		MWRITE;
  wire [2:0] 	MSIZE;
  wire [2:0] 	MBURST;
  wire [3:0] 	MPROT;
  wire 		MLOCK;
  wire 		MBUSREQ;
  wire 		MREADY;
  wire 		MERROR;
  wire [31:0] 	DinMaster;
  wire [31:0] 	DinSlave;
  wire [31:0] 	DINi;
  wire 		TestMode;
  wire 		nHCLK;

  //------------------------------------------------------------------------------
  // Beginning of main code
  //------------------------------------------------------------------------------

  // An inverted HCLK is required by some functions
  ClockInv  nHCLKgen 
    (.InClock (HCLK),
     .OutClock (nHCLK)
     );

  // For normal operation the DIN port is connected to DinMaster and for test
  //  mode the DIN port is connected DinSlave, to receive write data from the TIC.
  assign DINi  = (TestMode ==1'b0 ? DinMaster :DinSlave);

  // A delay is used to give the core input data a hold time after the
  //  falling edge of HCLK when running an RTL simulation.
  assign #1  DIN  = DINi ;

  A920TWrapSM  uA920TWrapSM 
    (.HCLK (HCLK),
     .nHCLK (nHCLK),
     .HRESETn (HRESETn),
     .MREADY (MREADY),
     .MERROR (MERROR),
     .MRDATA (HRDATAM),
     .MADDR (MADDR),
     .MTRANS (MTRANS),
     .MWRITE (MWRITE),
     .MSIZE (MSIZE),
     .MBURST (MBURST),
     .MPROT (MPROT),
     .MLOCK (MLOCK),
     .MBUSREQ (MBUSREQ),
     .MWDATA (HWDATAM),
     .AOUT (AOUT),
     .AREQ (AREQ),
     .ASTB (ASTB),
     .BURST (BURST),
     .DOUT (DOUT),
     .LOK (LOK),
     .NCMAHB (NCMAHB),
     .PROT (PROT),
     .SIZE (SIZE),
     .TRAN (TRAN),
     .WRITEOUT (WRITEOUT),
     .BnRES (BnRES),
     .DinMaster (DinMaster),
     .WAITIN (WAITIN),
     .ERRORIN (ERRORIN)
     );

  A920TWrapMaster  uA920TWrapMaster 
    (.HCLK (HCLK),
     .HRESETn (HRESETn),
     .HREADYM (HREADYM),
     .HRESPM (HRESPM),
     .HGRANTM (HGRANTM),
     .HSELS (HSELS),
     .MADDR (MADDR),
     .MTRANS (MTRANS),
     .MWRITE (MWRITE),
     .MSIZE (MSIZE),
     .MBURST (MBURST),
     .MPROT (MPROT),
     .MLOCK (MLOCK),
     .MBUSREQ (MBUSREQ),
     .HADDRM (HADDRM),
     .HTRANSM (HTRANSM),
     .HWRITEM (HWRITEM),
     .HSIZEM (HSIZEM),
     .HBURSTM (HBURSTM),
     .HPROTM (HPROTM),
     .HBUSREQM (HBUSREQM),
     .HLOCKM (HLOCKM),
     .MREADY (MREADY),
     .MERROR (MERROR)
     );

  A920TWrapSlave  uA920TWrapSlave 
    (.HCLK (HCLK),
     .nHCLK (nHCLK),
     .HRESETn (HRESETn),
     .HADDRS (HADDRS),
     .HTRANS1S (HTRANS1S),
     .HWRITES (HWRITES),
     .HSELS (HSELS),
     .HREADYS (HREADYS),
     .HWDATAS (HWDATAS),
     .HRDATAS (HRDATAS),
     .HREADYOUTS (HREADYOUTS),
     .HRESPS (HRESPS),
     .DOUT (DOUT),
     .WAITOUT (WAITOUT),
     .AIN (AIN),
     .AGNT (AGNT),
     .DSEL (DSEL),
     .WRITEIN (WRITEIN),
     .DinSlave (DinSlave),
     .TestMode (TestMode)
     );
endmodule
