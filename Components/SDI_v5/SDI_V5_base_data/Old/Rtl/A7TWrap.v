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
//  File Name           : A7TWrap.v,v
//  File Revision       : 1.18
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : This entity ties together all the sub blocks that form
//                        the amba wrapper, and provides interfaces to the AMBA
//                        AHB bus and the processor core.
//                        The test structures have been separated from the rest
//                        of the wrapper to aid removal should alternative test
//                        strategies be employed.
//  --========================================================================--

`timescale 1ns/1ps

module A7TWrap (HCLK, HRESETn, HRDATAM, HREADYM, HRESPM, HGRANTM,
                HADDRM, HTRANSM, HWRITEM, HSIZEM, HBURSTM, HPROTM,
                HBUSREQM, HLOCKM, HTRANS1S, HWRITES, HWDATAS,
                HSELS, HREADYS, HRDATAS, HREADYOUTS, HRESPS, ARMNFIQ,
                ARMNIRQ, A, DOUT, LOCK, MAS, nMREQ, nOPC, nRW, nTRANS,
                SEQ, ABORT, DIN, MCLK, nFIQ, nIRQ, nRESET, nWAIT,
                BUSDIS, COMMRX, COMMTX, DBGACK, DBGRQI, HIGHZ,
                RANGEOUT0, RANGEOUT1, nCPI, nENOUT, nENOUTI, nEXEC,
                nM, nTDOEN, SCREG, TBIT, ABE, ALE, APE, BIGEND, BL,
                BREAKPT, BUSEN, CPA, CPB, DBE, DBGEN, DBGRQ, EXTERN0,
                EXTERN1, ISYNC, nENIN, SDOUTBS, TBE, xnTRST, xTCK,
                xTDI, xTMS, xTDO, nTRST, TCK, TDI, TMS,
    	       	SCANENABLE,    // Scan Enable
    	       	SCANINHCLK,    // HCLK domain Scan input
               	SCANOUTHCLK   // HLCK domain Scan output
	       	);

  //------------------------------------------------------
  // AMBA bus signals
  //------------------------------------------------------
  // Signals used during normal operation and test mode
  input         HCLK;
  input         HRESETn;

  // Signals from AMBA bus used during normal operation
  input [31:0]  HRDATAM;
  input         HREADYM;
  input [1:0]   HRESPM;
  input         HGRANTM;

  // Signals to AMBA bus used during normal operation
  output [31:0] HADDRM;
  output [1:0]  HTRANSM;
  output        HWRITEM;
  output [2:0]  HSIZEM;
  output [2:0]  HBURSTM;
  output [3:0]  HPROTM;
  output        HBUSREQM;
  output        HLOCKM;

  // Signals from AMBA bus used during test mode
  input         HTRANS1S;
  input         HWRITES;
  input [31:0]  HWDATAS;
  input         HSELS;
  input         HREADYS;

  // Signals to AMBA bus used during test mode
  output [31:0] HRDATAS;
  output        HREADYOUTS;
  output [1:0]  HRESPS;

  // ARM interrupts
  input         ARMNFIQ;
  input         ARMNIRQ;

  // ATPG scan connections
  input		SCANENABLE;
  input		SCANINHCLK;
  output	SCANOUTHCLK;

  //------------------------------------------------------
  // ARM core signals
  //------------------------------------------------------
  // Signals from ARM core used during normal operation
  input [31:0]  A;
  input [31:0]  DOUT;
  input         LOCK;
  input [1:0]   MAS;
  input         nMREQ;
  input         nOPC;
  input         nRW;
  input         nTRANS;
  input         SEQ;

  // Signals to ARM core used during normal operation
  output        ABORT;
  output [31:0] DIN;
  output        MCLK;
  output        nFIQ;
  output        nIRQ;
  output        nRESET;
  output        nWAIT;

  // Signals from ARM core used during test mode
  input         BUSDIS;
  input         COMMRX;
  input         COMMTX;
  input         DBGACK;
  input         DBGRQI;
  input         HIGHZ;
  input         RANGEOUT0;
  input         RANGEOUT1;
  input         nCPI;
  input         nENOUT;
  input         nENOUTI;
  input         nEXEC;
  input [4:0]   nM;
  input         nTDOEN;
  input [3:0]   SCREG;
  input         TBIT;

  // Signals to ARM core used during test mode
  // During normal operation these signals are tied off to static values
  output        ABE;
  output        ALE;
  output        APE;
  output        BIGEND;
  output [3:0]  BL;
  output        BREAKPT;
  output        BUSEN;
  output        CPA;
  output        CPB;
  output        DBE;
  output        DBGEN;
  output        DBGRQ;
  output        EXTERN0;
  output        EXTERN1;
  output        ISYNC;
  output        nENIN;
  output        SDOUTBS;
  output        TBE;

  //------------------------------------------------------
  // JTAG signals
  //------------------------------------------------------
  // JTAG inputs from external tester and ARM core
  input         xnTRST;
  input         xTCK;
  input         xTDI;
  input         xTMS;
  input         xTDO;

  // JTAG outputs to core, after passing through test logic
  output        nTRST;
  output        TCK;
  output        TDI;
  output        TMS;

  //----------------------------------------------------------------------
  // The wrapper is made up of the following blocks, in two sections:
  // Normal operation blocks:
  //   A7WrapSM      - Converts ARM7 bus transactions into AHB-Lite
  //                   bus transactions
  //   A7WrapMaster  - Gasket to connect AHB-Lite to full AHB bus (adds
  //                   split/retry and request/grant support)
  // Test mode blocks: (removable)
  //   A7TWrapCtrl   - Test multiplexer used to drive the core control
  //                   inputs with test data during TIC testing, or to
  //                   default values during normal operation
  //   A7TWrapTest   - Test Interface used during TIC testing.
  //----------------------------------------------------------------------

  //------------------------------------------------------------------------------
  // The following components are used where the design does not follow
  // fast-track design rules (use of clock-gating and transparent
  // latch).  These elements are treated specially during synthesis to
  // ensure that Synopsys: synthesises the latch correctly; and does
  // not place a buffer tree on the output of clock gates.
  //
  // Clock gate: NAND
  // Clock gate: inverter
  // Transparent latch with active-low asynchronous set
  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  // Constant declarations
  //------------------------------------------------------------------------------
  // HRESP transfer response signal encoding
  `define RSP_OKAY 2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

  // TRANS transfer type signal encoding
  `define TRAN_IDL 2'b00
  `define TRAN_COP 2'b01
  `define TRAN_NON 2'b10
  `define TRAN_SEQ 2'b11


  //------------------------------------------------------------------------------
  // Signal declarations
  //------------------------------------------------------------------------------
  // Internal signals used between wrapper blocks

  wire          TestModeR;
  wire          TestModeF;
  wire          TestClk;
  wire [27:0]   TestCtrl;
  wire          CLKEN;

  // AHB-Lite signals
  wire          MREADY;
  wire          MERROR;
  wire [31:0]   MADDR;
  wire [1:0]    MTRANS;
  wire          MWRITE;
  wire [2:0]    MSIZE;
  wire [2:0]    MBURST;
  wire [3:0]    MPROT;
  wire          MLOCK;
  wire          MBUSREQ;

  // Signals used when converting from ARM7TDMI to ARM7TDMI-S style
  wire          dCLKEN;
  wire          MCLKEN;
  wire          nHCLK;
  wire [1:0]    TRANS;
  wire [1:0]    PROT;

  //------------------------------------------------------------------------------
  // Beginning of main code
  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  // Extra glue logic required for ARM7TDMI and not required for ARM7TDMI-S
  //------------------------------------------------------------------------------

  // When in test mode the data coming into the core is the write
  // data from the TIC AHB master; otherwise it is the read data from
  // the AHB bus.
  assign DIN = ((TestModeR ) ? HWDATAS : (HRDATAM ));

  // TRANS can also be expressed as:
  //
  //     TRANS <= (not nMREQ) & (SEQ)
  //
  // but constants are used here to aid readability
  assign TRANS  = (((  nMREQ == 1'b0 ) & (SEQ == 1'b0 )) ? `TRAN_NON :
                   ((( nMREQ == 1'b0 ) & (SEQ == 1'b1 )) ? `TRAN_SEQ :
                    (((nMREQ == 1'b1 ) & (SEQ == 1'b0 )) ? `TRAN_IDL :
                     (`TRAN_COP ))));

  assign  PROT  = {nTRANS ,nOPC };

  // Delay CLKEN for use as a clock enable term.  A latch is used
  // rather than a register because the delay from rising HCLK to
  // CLKEN can be longer than a phase as it is created from HREADYin
  ClockInv  nHCLKgen 
    (.InClock(HCLK),
     .OutClock(nHCLK)
     );

  LATS  DelCLKEN 
    (.CLOCK(nHCLK),
     .DATAIN(CLKEN),
     .ASETn(HRESETn),
     .DATAOUT(dCLKEN)
     );

  // When in test mode, MCLK needs to be free-running
  assign  MCLKEN  = (dCLKEN  | TestModeF );

  ClockNand  MCLKgen 
    (.InClock(HCLK),
     .Enable(MCLKEN),
     .OutClock(MCLK)
     );

  //------------------------------------------------------------------------------
  // Main state machine to convert ARM7TDMI bus accesses into AHB-Lite
  // bus accesses
  //------------------------------------------------------------------------------
  A7WrapSM  iA7WrapSM (
                       // AMBA signals into wrapper
                       .HCLK(HCLK),
                       .HRESETn(HRESETn),
                       // AMBA-LITE signals into wrapper
                       .MREADY(MREADY),
                       .MERROR(MERROR),
                       // AMBA-LITE signals out of wrapper
                       .MADDR(MADDR),
                       .MTRANS(MTRANS),
                       .MWRITE(MWRITE),
                       .MSIZE(MSIZE),
                       .MBURST(MBURST),
                       .MPROT(MPROT),
                       .MLOCK(MLOCK),
                       // Core signals into wrapper
                       // Address bus
                       .ADDR(A),
                       // code, data or priv level
                       .PROT(PROT),
                       // memory access width
                       .SIZE(MAS),
                       // next transaction type
                       .TRANS(TRANS),
                       // indicates write access
                       .WRITE(nRW),
                       // indicates locked access (SWAP instruction)
                       .LOCK(LOCK),
                       // Core signals out of wrapper
                       .CLKEN(CLKEN)
                       );

  //------------------------------------------------------------------------------
  // AHB-Lite to full AHB master gasket
  //------------------------------------------------------------------------------
  A7WrapMaster iA7WrapMaster (
                              // AHB input signals into wrapper
                              .HCLK(HCLK),
                              .HRESETn(HRESETn),
                              .HREADY(HREADYM),
                              .HRESP(HRESPM),
                              .HGRANT(HGRANTM),
                              .HSELS(HSELS),
                              // Core signals into bus master block to
                              // become AHB outputs
                              .MADDR(MADDR),
                              .MTRANS(MTRANS),
                              .MWRITE(MWRITE),
                              .MSIZE(MSIZE),
                              .MBURST(MBURST),
                              .MPROT(MPROT),
                              .MLOCK(MLOCK),
                              .MBUSREQ(MBUSREQ),
                              // AHB output signals from bus master block
                              .HADDR(HADDRM),
                              .HTRANS(HTRANSM),
                              .HWRITE(HWRITEM),
                              .HSIZE(HSIZEM),
                              .HBURST(HBURSTM),
                              .HPROT(HPROTM),
                              .HBUSREQ(HBUSREQM),
                              .HLOCK(HLOCKM),
                              // Core signals from bus master block
                              // Core signals from bus master block
                              .MREADY(MREADY),
                              .MERROR(MERROR)
                              );

  // ARM7TDMI has no concept of "bus request" - initiation of active
  // transfers on the AHB is determined by looking for an active
  // transfer on TRANS (nMREQ, SEQ)
  assign  MBUSREQ  = 1'b1 ;

  //------------------------------------------------------------------------------
  // Slave test interface
  //------------------------------------------------------------------------------

  // REMOVAL OF WRAPPER TEST MULTIPLEXER
  // ===================================
  //
  // When the test wrapper is not used, this block may optionally be removed by
  //  hand, or optimised out during synthesis. The following default output
  //  connections should be used if the block is to be removed.
  // The BIGEND and ISYNC default settings may be changed according to the system
  //  used:
  // BIGEND: Default LOW  - Little Endian
  //                 HIGH - Big Endian
  // ISYNC:  Default HIGH - Synchronisation of interrupts disabled
  //                 LOW  - Synchronisation of interrupts enabled
  // ABORT   <= MERROR;
  // nFIQ    <= ARMNFIQ;
  // nIRQ    <= ARMNIRQ;
  // nRESET  <= HRESETn;
  //
  // TCK     <= xTCK;
  // TDI     <= xTDI;
  // TMS     <= xTMS;
  // nTRST   <= xnTRST;
  //
  // ABE     <= '1';
  // ALE     <= '1';
  // APE     <= '1';
  // BIGEND  <= '0'; -- Default setting: Little Endian operation
  // BL      <= "1111";
  // BREAKPT <= '0';
  // CPA     <= '1';
  // CPB     <= '1';
  // DBGEN   <= '1';
  // DBGRQ   <= '0';
  // EXTERN0 <= '0';
  // EXTERN1 <= '0';
  // ISYNC   <= '1'; -- Default setting: Synchronisation of interrupts disabled
  // nWAIT   <= '1';
  // SDOUTBS <= '0';
  // TBE     <= '1';
  //
  // BUSEN   <= '1';
  // DBE     <= '1';
  // nENIN   <= '0';

  A7TWrapCtrl uA7TWrapCtrl (
                            // AMBA input signals
                            .HCLK(HCLK),
                            .HRESETn(HRESETn),
                            // Interrupt inputs to core
                            .ARMNFIQ(ARMNFIQ),
                            .ARMNIRQ(ARMNIRQ),
                            // JTAG connections
                            .xnTRST(xnTRST),
                            .xTCK(xTCK),
                            .xTDI(xTDI),
                            .xTMS(xTMS),
                            // Internal wrapper signals
                            .AbortInt(MERROR),
                            .TestMode(TestModeR),
                            .TestClk(TestClk),
                            .TestCtrl(TestCtrl),
                            // These signals are routed directly from
                            // this block to the core.
                            .ABORT(ABORT),
                            .nFIQ(nFIQ),
                            .nIRQ(nIRQ),
                            .nRESET(nRESET),
                            .TCK(TCK),
                            .TDI(TDI),
                            .TMS(TMS),
                            .nTRST(nTRST),
                            // During normal operation these test
                            //  signals are tied off to static values,
                            //  and only change during TIC testing of
                            //  the core.
                            .ABE(ABE),
                            .ALE(ALE),
                            .APE(APE),
                            .BIGEND(BIGEND),
                            .BL(BL),
                            .BREAKPT(BREAKPT),
                            .CPA(CPA),
                            .CPB(CPB),
                            .DBGEN(DBGEN),
                            .DBGRQ(DBGRQ),
                            .EXTERN0(EXTERN0),
                            .EXTERN1(EXTERN1),
                            .ISYNC(ISYNC),
                            .nWAIT(nWAIT),
                            .SDOUTBS(SDOUTBS),
                            .TBE(TBE),
                            .BUSEN(BUSEN),
                            .DBE(DBE),
                            .nENIN(nENIN)
                            );

  // REMOVAL OF WRAPPER TEST INTERFACE
  // =================================
  //
  // If alternative test strategies are to be employed, the test interface can be
  //  removed by:
  //
  //    i) deleting the component declaration and instantiation for the
  //        A7TWrapTest block.
  //
  //   ii) removing the comments from the following signal assignments:
  //
  //
  // HRDATAS    <= (others => '0');
  // HREADYOUTS <= '1';
  // HRESPS     <= RSP_OKAY;
  //
  // TestMode   <= '0';
  // TestClk    <= '1';
  // TestCtrl   <= (others => '0');
  //
  // This will make the multiplexer in the A7TWrapCtrl block redundant, and this
  //  block may either be removed by hand, or optimized out during synthesis.
  A7TWrapTest uA7TWrapTest (
                            .HCLK(HCLK),
                            .nHCLK(nHCLK),
                            .HRESETn(HRESETn),
                            .HTRANS1S(HTRANS1S),
                            .HWRITES(HWRITES),
                            .HWDATAS(HWDATAS),
                            .HSELS(HSELS),
                            .HREADYS(HREADYS),
                            .A(A),
                            .BUSDIS(BUSDIS),
                            .COMMRX(COMMRX),
                            .COMMTX(COMMTX),
                            .DBGACK(DBGACK),
                            .DBGRQI(DBGRQI),
                            .DOUT(DOUT),
                            .HIGHZ(HIGHZ),
                            .LOCK(LOCK),
                            .MAS(MAS),
                            .nCPI(nCPI),
                            .nENOUT(nENOUT),
                            .nENOUTI(nENOUTI),
                            .nEXEC(nEXEC),
                            .nM(nM),
                            .nMREQ(nMREQ),
                            .nOPC(nOPC),
                            .nRW(nRW),
                            .nTDOEN(nTDOEN),
                            .nTRANS(nTRANS),
                            .RANGEOUT0(RANGEOUT0),
                            .RANGEOUT1(RANGEOUT1),
                            .SCREG(SCREG),
                            .SEQ(SEQ),
                            .TBIT(TBIT),
                            .TDO(xTDO),
                            .HRDATAS(HRDATAS),
                            .HREADYOUTS(HREADYOUTS),
                            .HRESPS(HRESPS),
                            .TestModeR(TestModeR),
                            .TestModeF(TestModeF),
                            .TestClk(TestClk),
                            .TestCtrl(TestCtrl)
                            );

endmodule
