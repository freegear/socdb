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
//  File Name           : A7TWrapTest.v,v
//  File Revision       : 1.13
//  
//  Release Information : CPU_AHB_Wrappers-RELv1r1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Wrapper test module
//  --========================================================================--

`timescale 1ns/1ps
 
module A7TWrapTest (
                    HCLK, nHCLK, HRESETn, HTRANS1S, HWRITES,
                    HWDATAS, HSELS, HREADYS, A, BUSDIS, COMMRX, COMMTX,
                    DBGACK, DBGRQI, DOUT, HIGHZ, LOCK, MAS, nCPI,
                    nENOUT, nENOUTI, nEXEC, nM, nMREQ, nOPC, nRW,
                    nTDOEN, nTRANS, RANGEOUT0, RANGEOUT1, SCREG, SEQ,
                    TBIT, TDO, HRDATAS, HREADYOUTS, HRESPS,
                    TestModeR, TestModeF, TestClk, TestCtrl
                    );

  input         HCLK;
  input         nHCLK;
  input         HRESETn;
  input         HTRANS1S;
  input         HWRITES;
  input [31:0]  HWDATAS;
  input         HSELS;
  input         HREADYS;
  input [31:0]  A;
  input         BUSDIS;
  input         COMMRX;
  input         COMMTX;
  input         DBGACK;
  input         DBGRQI;
  input [31:0]  DOUT;
  input         HIGHZ;
  input         LOCK;
  input [1:0]   MAS;
  input         nCPI;
  input         nENOUT;
  input         nENOUTI;
  input         nEXEC;
  input [4:0]   nM;
  input         nMREQ;
  input         nOPC;
  input         nRW;
  input         nTDOEN;
  input         nTRANS;
  input         RANGEOUT0;
  input         RANGEOUT1;
  input [3:0]   SCREG;
  input         SEQ;
  input         TBIT;
  input         TDO;
  output [31:0] HRDATAS;
  output        HREADYOUTS;
  output [1:0]  HRESPS;
  // Indicates core TIC testing mode
  output        TestModeR;
  output        TestModeF;
  // Test clock enable
  output        TestClk;
  // Test input control data
  output [27:0] TestCtrl;

  //------------------------------------------------------------------------------
  // Constant declarations
  //------------------------------------------------------------------------------
  // HTRANS transfer type signal encoding
  `define TRN_IDLE 2'b00
  `define TRN_BUSY 2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ 2'b11

  // HRESP transfer response signal encoding
  `define RSP_OKAY 2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

  // State encoding for the Test State Machine
  `define ST_INACTIVE 3'b000
  `define ST_CTRL_IN 3'b001
  `define ST_DATA_IN 3'b010
  `define ST_DATA_OUT 3'b011
  `define ST_STAT_OUT 3'b100
  `define ST_ADDR_OUT 3'b101
  `define ST_TURNAROUND 3'b110

  //------------------------------------------------------------------------------
  // Signal declarations
  //------------------------------------------------------------------------------
  reg           TestModeR;    //  Indicates core TIC testing mode 
  reg           TestModeF;    //  Indicates core TIC testing mode 
  reg [27:0]    TestCtrl;    //  Test input control data 

  wire          TestEn;    //  Enable for test state machine 
  reg [2:0]     NextTest;    //  Test state machine 
  reg [2:0]     CurrentTest;
  reg           TestModeNext;    //  TestMode register input 
  reg           TestClkNext;    //  TestClk  register input 
  reg           iTestClk;    //  Internal TestClk 
  reg           TestReadNext;    //  TestRead register input 
  reg           TestRead;    //  Drive read data out 
  reg           TestStatNext;    //  TestStat register input 
  reg           TestStat;    //  Drive test status out 
  reg           NewCtrlNext;    //  NewCtrl register input 
  reg           NewCtrl;    //  Indicates new control value to be stored 
  reg           nENOUTReg;    //  Registered core output 
  reg           nENOUTIReg;    //  Registered core output 
  wire [31:0]   TestData;    //  Test output read data 
  wire [31:0]   HrdataMux;    //  Test data mux 

  //------------------------------------------------------------------------------
  // Beginning of main code
  //------------------------------------------------------------------------------

  //------------------------------------------------------------------------------
  // TestEn generation
  //------------------------------------------------------------------------------
  // This signal is used to enable the test state machine. It is set HIGH when
  //  HSELS is HIGH and the current cycle is a TRN_NONSEQ or TRN_SEQ, and
  //  is set LOW at all other times.
  // (HTRANS1S == 1'b1) is equivalent to:
  //   (HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)) 
  assign TestEn  = (HSELS & HTRANS1S) ? 1'b1 : 1'b0;

  //------------------------------------------------------------------------------
  // Granted state machine next state logic
  //------------------------------------------------------------------------------
  always @ (CurrentTest or TestEn or HWRITES or HREADYS)
    begin:p_NextTestComb
      case (CurrentTest )
        `ST_INACTIVE:begin
          // Test mode inactive
          // HREADYS only needs to be checked when entering test mode, as
          // after this time the core will always respond with HREADYOUTS
          // high
          if  ( TestEn && HREADYS )
            begin 
              NextTest  = `ST_CTRL_IN ;
            end
          else
            begin
              NextTest  = `ST_INACTIVE ;
            end 
        end
        `ST_CTRL_IN:begin
          // Control write vector
          if  ( TestEn )
            begin 
              if  ( HWRITES )
                begin 
                  NextTest  = `ST_DATA_IN ;
                end
              else
                begin
                  NextTest  = `ST_DATA_OUT ;
                end 
            end
          else
            begin
              NextTest  = `ST_CTRL_IN ;
            end 
        end
        `ST_DATA_IN:begin
          // Data write vector
          if  ( TestEn )
            begin 
              NextTest  = `ST_STAT_OUT ;
            end
          else
            begin
              NextTest  = `ST_DATA_IN ;
            end 
        end
        `ST_DATA_OUT:begin
          // Data read vector
          if  ( TestEn )
            begin 
              NextTest  = `ST_STAT_OUT ;
            end
          else
            begin
              NextTest  = `ST_DATA_OUT ;
            end 
        end
        `ST_STAT_OUT:begin
          // Status read vector
          if  ( TestEn )
            begin 
              NextTest  = `ST_ADDR_OUT ;
            end
          else
            begin
              NextTest  = `ST_STAT_OUT ;
            end 
        end
        `ST_ADDR_OUT:begin
          // Address read vector
          if  ( TestEn )
            begin 
              NextTest  = `ST_INACTIVE ;
            end
          else
            begin
              NextTest  = `ST_TURNAROUND ;
            end 
        end
        `ST_TURNAROUND:begin
          // Bus turnaround
          if  ( TestEn )
            begin 
              NextTest  = `ST_CTRL_IN ;
            end
          else
            begin
              NextTest  = `ST_TURNAROUND ;
            end 
        end
        default: begin
          NextTest  = `ST_INACTIVE ;
        end
      endcase
    end 

  //------------------------------------------------------------------------------
  // Test state machine current state
  //------------------------------------------------------------------------------
  // Loads the value of NextTest in on each HCLK
  always @ (negedge HRESETn or posedge HCLK)
    begin:p_CurrentTestSeq
      if  ( HRESETn ==1'b0 )
        begin 
          CurrentTest  <= `ST_INACTIVE ;
        end
      else
        begin
          CurrentTest  <= NextTest ;
        end 
    end 

  //------------------------------------------------------------------------------
  // TestMode generation
  //------------------------------------------------------------------------------
  // TestMode is asserted throughout the test. It is only set inactive when the
  //  core remains selected after an ST_ADDR_OUT state. (The usual mode of
  //  operation is to deselect the core after ST_ADDR_OUT to move into the
  //  ST_TURNAROUND state.)
  always @ (TestEn or CurrentTest)
    begin:p_TestModeComb
      if  (((CurrentTest ==`ST_INACTIVE ) & (TestEn == 1'b0 )) ||
           ((CurrentTest ==`ST_ADDR_OUT ) & (TestEn == 1'b1 )))
        begin 
          TestModeNext  = 1'b0 ;
        end
      else
        begin
          TestModeNext  = 1'b1 ;
        end 
    end 

  always @ (posedge HCLK or negedge HRESETn)
    begin:p_TestModeRSeq
      if  ( HRESETn ==1'b0 )
        begin 
          TestModeR  <= 1'b0 ;
        end
      else
        begin
          TestModeR  <= TestModeNext ;
        end 
    end 

  always @ (posedge nHCLK or negedge HRESETn)
    begin:p_TestModeFSeq
      if  ( HRESETn ==1'b0 )
        begin 
          TestModeF  <= 1'b0 ;
        end
      else
        begin
          TestModeF  <= TestModeNext ;
        end 
    end 

  //------------------------------------------------------------------------------
  // TestClk generation
  //------------------------------------------------------------------------------
  // TestClk is asserted during the test process when the core should be clocked.
  //  This signal is actually a clock enable and is eventually routed to the
  //  nWAIT pin on the core. TestClk is asserted when in either the ST_DATA_IN or
  //  ST_DATA_OUT states.
  always @ (TestEn or CurrentTest)
    begin:p_TestClkComb
      if  ( ((CurrentTest ==`ST_CTRL_IN ) && TestEn ))
        begin 
          TestClkNext  = 1'b1 ;
        end
      else
        begin
          TestClkNext  = 1'b0 ;
        end 
    end 
  always @ (posedge HCLK or negedge HRESETn)
    begin:p_TestClkSeq
      if  ( HRESETn ==1'b0 )
        begin 
          iTestClk  <= 1'b0 ;
        end
      else
        begin
          iTestClk  <= TestClkNext ;
        end 
    end 
  //------------------------------------------------------------------------------
  // TestRead generation
  //------------------------------------------------------------------------------
  // TestRead is asserted during the test process when the core should be driving
  //  data out on to the data bus, i.e. during a read cycle. This signal is used
  //  to ensure that the core data out bus is driven out onto the HRDATAS bus.
  //  TestRead is asserted during the first cycle in the ST_DATA_OUT state.
  always @ (TestEn or CurrentTest or HWRITES)
    begin:p_TestReadComb
      if  ( (((CurrentTest ==`ST_CTRL_IN ) && TestEn ) && HWRITES ==1'b0 ))
        begin 
          TestReadNext  = 1'b1 ;
        end
      else
        begin
          TestReadNext  = 1'b0 ;
        end 
    end 
  always @ (posedge HCLK or negedge HRESETn)
    begin:p_TestReadSeq
      if  ( HRESETn ==1'b0 )
        begin 
          TestRead  <= 1'b0 ;
        end
      else
        begin
          TestRead  <= TestReadNext ;
        end 
    end 
  //------------------------------------------------------------------------------
  // TestStat generation
  //------------------------------------------------------------------------------
  // TestStat is asserted during the test process when the status output signals
  //  from the core are driven on to the main system data bus. TestStat is
  //  asserted during the first cycle in the ST_STAT_OUT and ST_ADDR_OUT states.
  always @ (TestEn or CurrentTest)
    begin:p_TestStatComb
      if  ((((CurrentTest ==`ST_DATA_IN ) & (TestEn )) ||
            ((CurrentTest ==`ST_DATA_OUT ) & (TestEn ))
            ) ||
           ((CurrentTest ==`ST_STAT_OUT ) & (TestEn )))
        begin 
          TestStatNext  = 1'b1 ;
        end
      else
        begin
          TestStatNext  = 1'b0 ;
        end 
    end 
  always @ (posedge HCLK or negedge HRESETn)
    begin:p_TestStatSeq
      if  ( HRESETn ==1'b0 )
        begin 
          TestStat  <= 1'b0 ;
        end
      else
        begin
          TestStat  <= TestStatNext ;
        end 
    end 

  //------------------------------------------------------------------------------
  // NewCtrl generation
  //------------------------------------------------------------------------------
  // NewCtrl is used to determine when the TestCtrl register is updated. This
  //  should occur in the ST_CTRL_IN state.
  always @ (TestEn or CurrentTest)
    begin:p_NewCtrlComb
      if  (((CurrentTest ==`ST_INACTIVE ) & (TestEn )) ||
           ((CurrentTest ==`ST_TURNAROUND ) & (TestEn )))
        begin 
          NewCtrlNext  = 1'b1 ;
        end
      else
        begin
          NewCtrlNext  = 1'b0 ;
        end 
    end 

  always @ (posedge HCLK or negedge HRESETn)
    begin:p_NewCtrl
      if  ( HRESETn ==1'b0 )
        begin 
          NewCtrl  <= 1'b0 ;
        end
      else
        begin
          NewCtrl  <= NewCtrlNext ;
        end 
    end 

  //------------------------------------------------------------------------------
  // TestCtrl register
  //------------------------------------------------------------------------------
  // TestCtrl stores the state of the HWDATAS bus during TIC testing. TestCtrl
  //  sets the state of many core control signals during slave state testing.
  // The TestCtrl register is only updated when the ST_CTRL_IN state is first
  //  entered, as indicated by NewCtrl.
  always @ (posedge HCLK or negedge HRESETn)
    begin:p_TestCtrlSeq
      if  ( HRESETn ==1'b0 )
        begin 
          TestCtrl [27:0] <= {28{1'b0}};
        end
      else
        begin
          if  ( NewCtrl )
            begin 
              TestCtrl  <= HWDATAS [27:0];
            end 
        end 
    end 

  //------------------------------------------------------------------------------
  // nENOUT registers
  //------------------------------------------------------------------------------
  // The core's nENOUT/nENOUTI outputs are registered so that they remain valid
  //  during status output (generation of TestData).
  always @ (posedge HCLK or negedge HRESETn)
    begin:p_nENOUTSeq
      if  ( HRESETn ==1'b0 )
        begin 
          nENOUTReg  <= 1'b1 ;
        end
      else
        begin
          if  ( iTestClk )
            begin 
              nENOUTReg  <= (nENOUT  | (~TestRead ));
            end 
        end 
    end 
  always @ (posedge HCLK or negedge HRESETn)
    begin:p_nENOUTISeq
      if  ( HRESETn ==1'b0 )
        begin 
          nENOUTIReg  <= 1'b1 ;
        end
      else
        begin
          if  ( iTestClk )
            begin 
              nENOUTIReg  <= (nENOUTI  | (~TestRead ));
            end 
        end 
    end 

  //------------------------------------------------------------------------------
  // TestData generation
  //------------------------------------------------------------------------------
  // This multiplexer selects between control outputs (status) and address. This
  //  value will then be driven onto the HRDATAS bus.
  // [31:28]
  // [27:24]
  // [23:20]
  // [19:16]
  // [15:12]
  // [11:8]
  // [7:4]
  // [3:0]
  assign TestData  = ((CurrentTest !=`ST_ADDR_OUT ) ?
                      {BUSDIS, SCREG[3], SCREG[2], SCREG[1], SCREG[0], HIGHZ,
                       nTDOEN, DBGRQI, RANGEOUT0, RANGEOUT1, COMMRX, COMMTX,
                       DBGACK, TDO, nENOUTReg, nENOUTIReg, TBIT, nCPI, nM[4],
                       nM[3], nM[2], nM[1], nM[0], nTRANS, nEXEC, LOCK, MAS[1], 
                       MAS[0], nOPC, nRW, nMREQ, SEQ} 
                      :(A[31:0]));

  //------------------------------------------------------------------------------
  // HRDATAS generation
  //------------------------------------------------------------------------------
  // Generates output read data during core TIC testing, with correct AHB timing.
  assign HrdataMux  = ((TestStat ) ?
                       TestData :(DOUT));

  assign HRDATAS  = (((TestStat ) | (TestRead )) ?
                     HrdataMux :(1'b0));

  //------------------------------------------------------------------------------
  // Output drivers
  //------------------------------------------------------------------------------
  // Assign internal signals to outputs

  assign  TestClk  = iTestClk ;

  assign  HREADYOUTS  = 1'b1 ;
  // Always HIGH during core TIC testing 

  assign  HRESPS  = `RSP_OKAY ;
  // Only generates OKAY response

endmodule
