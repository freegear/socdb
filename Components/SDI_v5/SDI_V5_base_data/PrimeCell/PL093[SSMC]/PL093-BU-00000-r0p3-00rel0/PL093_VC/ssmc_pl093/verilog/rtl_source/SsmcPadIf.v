// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcPadIf.v.rca
// File Revision          : 1.25
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Clocking in the data from Memory and Routing out the Control and
//           Data signals from Core to Memory is the function of this block.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SsmcParams.v"

// -----------------------------------------------------------------------------

module SsmcPadIf 
  (                
                   // Inputs
                   SMFBCLK0,
                   SMFBCLK1,
                   SMFBCLK2,
                   SMFBCLK3,
                   SMMEMCLK,
                   nSMMEMCLK,
                   SMMEMCLKDELAY,
                   HRESETn,
                   nSMBURSTWAIT,
                   BIGENDIAN,
                   HsizeMemBufWr,
                   MWWr,
                   RBLEWr,
                   HwdataBuf,
                   MemoryWrSt,
                   nSMWENMC,
                   SmAddrTSM,
                   SMADDRMC,
                   nSMBLSMC,
                   SMDATAIN,
                   NextAsynAxs,
                   NextSmOEn,
                   NxtSMADDRVALIDMC,
                   NextSMBAAMC,
                   NextSMCSMC,
                   NextSMCSMCn,
                   NextSMDATAENMCn,
                   // Outputs
                   SMADDR,
                   SmBurstWtFbClk,
                   SyncWtSingle,
                   SmDataInFbClk,
                   SmDataEnCore,
                   SmDataOutCore,
                   SMCS,
                   nSMCS,
                   SMBAA,
                   SMADDRVALID,
                   nSMWEN,
                   nSMOEN,
                   nSMBLS
                   );

  // Inputs
  input         SMFBCLK0;       // Fedback clock from output pad for
                                // Byte Lane0
  input         SMFBCLK1;       // Fedback clock from output pad for
                                // Byte Lane1
  input         SMFBCLK2;       // Fedback clock from output pad for
                                // Byte Lane2
  input         SMFBCLK3;       // Fedback clock from output pad for
                                // Byte Lane3
  input         SMMEMCLK;       // Memory Clock
  input         nSMMEMCLK;      // Inverted Memory Clock
  input         SMMEMCLKDELAY;  // Delayed Memory Clock
  input         HRESETn;        // AHB system level Reset
  input [7:0]   nSMBURSTWAIT;   // Synchronous burst Wait signal from External
                                // Memory Controller to delay the transfer
  input         BIGENDIAN;      // Type of endianness of the system
  input [1:0]   HsizeMemBufWr;  // Buffered HsizeMemBuf while writing
  input [1:0]   MWWr;           // Buffered MW while writing
  input         RBLEWr;         // RBLE registered during write operation
  input [31:0]  HwdataBuf;      // Buffered and Endianized HWDATASMC
  input         MemoryWrSt;     // Indication that Memory SM is in Write
  input         nSMWENMC;       // Memory Write Enable, Active LOW
  input [1:0]   SmAddrTSM;      // Memory Address from TSM Module
  input [25:0]  SMADDRMC;       // Memory address output when Asynchronous memory
                                // access is progressing
  input [3:0]   nSMBLSMC;       // Byte Lane select when Asynchronous memory
                                // access is progressing
  input [31:0]  SMDATAIN;       // Data from Memory to SSMC

  input         NextAsynAxs;      // Indication of Asynchronous memory access
  input         NextSmOEn;        // Memory Output Enable, Active Low
  input         NxtSMADDRVALIDMC; // External address valid output, used to indicate
  input         NextSMBAAMC;      // External burst Address advance signal. Used to
  input [7:0]   NextSMCSMC;       // Active high chip select when Asynchronous
  input [7:0]   NextSMCSMCn;      // Active low chip select when Asynchronous
  input [3:0]   NextSMDATAENMCn;  // Data enable when Asynchronous memory access

  // Outputs
  output [25:0] SMADDR;         // External Memory Address Bus
  output        SmBurstWtFbClk; // nSMBURSTWAIT registered on SMFBCLK
  output        SyncWtSingle;   // Single bit Synchronous Wait
  output [31:0] SmDataInFbClk;  // Data from Memory Banks
  output [3:0]  SmDataEnCore;   // Data Enables when Write is in
                                // progress
  output [31:0] SmDataOutCore;  // Data Bus output from SsmcCore
  output [7:0]  SMCS;           // Chip Selects for external Memory,
                                // active HIGH
  output [7:0]  nSMCS;          // Chip Selects for external Memory,
                                // active LOW
  output        SMBAA;          // External burst Address advance signal. Used to 
                                // advance the address count in the external
                                // Memory device
  output        SMADDRVALID;    // External address valid output, used to indicate
                                // when the address output is stable during
                                // synchronous burst transfers
  output        nSMWEN;         // Memory Write Enable, Active LOW
  output        nSMOEN;         // Memory Output Enable, Active Low
  output [3:0]  nSMBLS;         // Memory device Byte lane enables


  // Inputs
  wire          SMFBCLK0;       // Fedback clock from output pad for
  // Byte Lane0
  wire          SMFBCLK1;       // Fedback clock from output pad for
  // Byte Lane1
  wire          SMFBCLK2;       // Fedback clock from output pad for
  // Byte Lane2
  wire          SMFBCLK3;       // Fedback clock from output pad for
  // Byte Lane3
  wire          nSMMEMCLK;      // Inverted Memory Clock
  wire          SMMEMCLKDELAY;  // Delayed Memory Clock
  wire          HRESETn;        // AHB system level Reset
  wire [7:0]    nSMBURSTWAIT;   // Synchronous burst Wait signal from External
  // Memory Controller to delay the transfer
  wire          BIGENDIAN;      // Type of endianness of the system
  wire [1:0]    HsizeMemBufWr;  // Buffered HsizeMemBuf while writing
  wire [1:0]    MWWr;           // Buffered MW while writing
  wire          RBLEWr;         // RBLE registered during write operation
  wire [31:0]   HwdataBuf;      // Buffered and Endianized HWDATASMC
  wire          MemoryWrSt;     // Indication that Memory SM is in Write
  // state
  reg           AsynAxs;        // Indication that Asynchronous memory access in
  // progress
  wire          nSMWENMC;       // Memory Write Enable, Active LOW
  wire [1:0]    SmAddrTSM;      // Memory Address from TSM Module
  wire [25:0]   SMADDRMC;       // Memory address output when Asynchronous memory
  wire [3:0]    nSMBLSMC;       // Byte Lane select when Asynchronous memory
  // access is progressing
  wire [31:0]   SMDATAIN;       // Data from Memory to SSMC

  // Outputs
  reg [25:0]    SMADDR;         // External Memory Address Bus
  reg           SmBurstWtFbClk; // nSMBURSTWAIT registered on SMFBCLK
  wire          SyncWtSingle;   // Single bit Synchronous Wait
  wire [31:0]   SmDataInFbClk;  // Data from Memory Banks
  reg [31:0]    SmDataOutCore;  // Data Bus output from SsmcCore

  wire [3:0]     SmDataEnCore;   // Data Enables when Write
  wire [7:0]     SMCS;           // Chip Selects for external Memory,
  wire [7:0]     nSMCS;          // Chip Selects for external Memory,
  wire           SMBAA;          // External burst Address advance signal. Used to 
  wire           SMADDRVALID;    // External address valid output, used to indicate
  reg           nSMWEN;         // Memory Write Enable, Active LOW
  wire           nSMOEN;         // Memory Output Enable, Active Low
  reg [3:0]     nSMBLS;         // Memory device Byte lane enables


  // -----------------------------------------------------------------------------
  //
  //                                  SsmcPadIf
  //                                  =========
  //
  // -----------------------------------------------------------------------------
  //
  // Overview
  // ========
  //           Clocking in the data from Memory and Routing out the Control and
  //           Data signals from Core to Memory is the function of this block.
  //           In this module SMDATAIN is clocked if it is from Synchronous
  //           Memories. Also based on the System Endianness Data is routed out.
  //           Logic to generate nSMBLS is also implemented in this module.
  //
  // -----------------------------------------------------------------------------

  // ---------------------------------------------------------------------
  // Constant declarations
  // -----------------------------------------------------------------------------

  // -----------------------------------------------------------------------------
  // Wire declarations
  // ---------------------------------------------------------------------
  wire [3:0]    Concat;
  // Vector to hold the Width's of AHB Width and Memory Width

  // -----------------------------------------------------------------------------
  // Register declarations
  // ---------------------------------------------------------------------
  reg [31:0]    SmDataInReg;
  // Registered SmDataIn for Synchronous Memory

  reg [25:0]    SMADDRMCDel;
  // Memory address output when Synchronous memory access is progressing

  reg [3:0]     nSMBLSMCDel;
  // Byte Lane select when Synchronous memory access is progressing

  reg [3:0]     nSMBLSClkdInvMC;
  // Byte Lane select for asynchronous memories registered on nSMMEMCLK

  wire [3:0]    nSMBLS4Async;
  // Byte Lane select multiplexed o/p between nSMBLSMC and nSMBLSClkdInvMC based
  // on RBLEWr setting

  reg [31:0]    SMDATAOUTMC;
  // Data output when Asynchronous memory access is progressing

  reg [31:0]    SMDATAOUTMCDel;
  // Data output when Synchronous memory access is progressing

  reg           nSMWENMCDel;
  // Write enable signal when Synchronous memory access is progressing

  reg           nSMWEN4Async;
  // Write enable signal for asynchronous memories registered on nSMMEMCLK

  wire          iSyncWtSingle;
  // Internal signal of SyncWtSingle

  // ---------------------------------------------------------------------
  // Function declarations
  // -----------------------------------------------------------------------------

  // synopsys translate_off
  // -----------------------------------------------------------------------------
  // Type declarations
  // -----------------------------------------------------------------------------



  // synopsys translate_on
  // -----------------------------------------------------------------------------
  //
  // Main body of code
  // =================
  //
  // -----------------------------------------------------------------------------


  // -----------------------------------------------------------------------------
  // Internal Signal Assignments
  // -----------------------------------------------------------------------------
  assign        SyncWtSingle = iSyncWtSingle;

  // -----------------------------------------------------------------------------
  //                              Assignments
  // -----------------------------------------------------------------------------

  assign        Concat      = {MWWr, HsizeMemBufWr[1:0]};
  // -----------------------------------------------------------------------------
  // Write Data Path Logic
  // In this block the Data is Endianized before driving on SMDATAOUTMC line.
  // SMDATAOUTMC is driven out based on SmAddrTSM, MWWr and BIGENDIAN signals.
  // Initially the Data is collected from AHB in HwdataBuf[31:0] register.
  // When Memory Write is initiated based on the Memory Address, Memory Width and
  // Endianness of the system.
  // -----------------------------------------------------------------------------
  always @(MemoryWrSt or BIGENDIAN or SmAddrTSM or HwdataBuf or Concat)
    begin : p_WriteDataComb
      SMDATAOUTMC    = 32'b00000000000000000000000000000000;
      if (MemoryWrSt == 1'b1)
        begin
          if (BIGENDIAN == 1'b0)
            begin
              case (Concat)
                
                // Memory size is Byte, AHB Width can be Byte, HWord, or Word.
                4'b0000, 4'b0001, 4'b0010 :
                  begin
                    // SMDATAOUTMC is driven out based on SmAddrTSM, and System
                    // Endianness.
                    case (SmAddrTSM[1:0])
                      2'b00 :
                        SMDATAOUTMC[7:0] = HwdataBuf[7:0];
                      
                      2'b01 :
                        SMDATAOUTMC[7:0] = HwdataBuf[15:8];
                      
                      2'b10 :
                        SMDATAOUTMC[7:0] = HwdataBuf[23:16];
                      
                      2'b11 :
                        SMDATAOUTMC[7:0] = HwdataBuf[31:24];
                      
                      default :
                        ; 
                    endcase
                  end

                // Memory size is HWord, AHB Width is Byte
                4'b0100 :
                  begin
                    // SMDATAOUTMC is driven out based on SmAddrTSM, and System
                    // Endianness.
                    case (SmAddrTSM[1])
                      1'b0 :
                        SMDATAOUTMC[15:0] = HwdataBuf[15:0];
                      
                      1'b1 :
                        SMDATAOUTMC[15:0] = HwdataBuf[31:16];
                      
                      default :
                        ;
                    endcase
                  end
                
                // Memory size is HWord, AHB Width can be HWord, or Word.
                4'b0101,  4'b0110 :
                  begin
                    // SMDATAOUTMC is driven out based on SmAddrTSM, and System
                    // Endianness
                    case (SmAddrTSM[1])
                      1'b0 :
                        SMDATAOUTMC[15:0] = HwdataBuf[15:0];
                      
                      1'b1 :
                        SMDATAOUTMC[15:0] = HwdataBuf[31:16];
                      
                      default :
                        ;
                    endcase
                  end

                // Memory size is Word, AHB Width is Byte.
                4'b1000 :
                  SMDATAOUTMC    = HwdataBuf;
                
                // Memory size is Word, AHB Width is HWord.
                4'b1001 :
                  SMDATAOUTMC    = HwdataBuf;
                
                // Memory size is Word, AHB Width is Word.
                4'b1010 :
                  SMDATAOUTMC    = HwdataBuf;
                
                default :
                  ;
              endcase
              
              // System is Big Endian.
            end
          else
            begin
              case (Concat)
                // Memory size is Byte, AHB Width can be Byte, HWord, or Word.
                4'b0000, 4'b0001, 4'b0010 :
                  begin
                    // SMDATAOUTMC is driven out based on SmAddrTSM, and System
                    // Endianness.
                    case (SmAddrTSM[1:0])
                      2'b11 :
                        SMDATAOUTMC[7:0] = HwdataBuf[7:0];
                      
                      2'b10 :
                        SMDATAOUTMC[7:0] = HwdataBuf[15:8];
                      
                      2'b01 :
                        SMDATAOUTMC[7:0] = HwdataBuf[23:16];
                      
                      2'b00 :
                        SMDATAOUTMC[7:0] = HwdataBuf[31:24];
                      
                      default :
                        ;
                    endcase
                  end
                
                // Memory size is HWord, AHB Width is Byte.
                4'b0100 :
                  begin
                    // SMDATAOUTMC is driven out based on SmAddrTSM, and System
                    // Endianness.
                    case (SmAddrTSM[1])
                      1'b1 :
                        SMDATAOUTMC[15:0] = HwdataBuf[15:0];
                      
                      1'b0 :
                        SMDATAOUTMC[15:0] = HwdataBuf[31:16];
                      
                      default :
                        ;
                    endcase
                  end
                
                // Memory size is HWord, AHB Width can be HWord, or Word.
                4'b0101, 4'b0110 :
                  begin
                    // SMDATAOUTMC is driven out based on SmAddrTSM, and System
                    // Endianness.
                    case (SmAddrTSM[1])
                      1'b1 :
                        SMDATAOUTMC[15:0] = HwdataBuf[15:0];
                      
                      1'b0 :
                        SMDATAOUTMC[15:0] = HwdataBuf[31:16];
                      
                      default :
                        ;
                    endcase
                  end
                
                // Memory size is Word, AHB Width is Byte.
                4'b1000 :
                  SMDATAOUTMC    = HwdataBuf;
                
                // Memory size is Word, AHB Width is HWord.
                4'b1001 :
                  SMDATAOUTMC    = HwdataBuf;
                
                // Memory size is Word, AHB Width is Word.
                4'b1010 :
                  SMDATAOUTMC    = HwdataBuf;
                
                default :
                  ;
              endcase
            end
        end
    end // p_WriteDataComb

  // -----------------------------------------------------------------------------
  // Mux to select between SMDATAIN or SmDataInReg(registered SMDATAIN), depending
  // on Asynchronous or Synchronous Memories.
  // -----------------------------------------------------------------------------
  assign SmDataInFbClk    = (AsynAxs == 1'b1) ? SMDATAIN : SmDataInReg;
  
  // ----------------------------------------------------------------------------
  // Macro containing AsynAxs plus the control signal registers
  //----------------------------------------------------------------------------

  // CS
  SsmcPadMux #(8) uSsmcPadMuxCS
    (
     // Outputs
     .SmCtrlOut                         (SMCS),
     // Inputs
     .SMMEMCLKDELAY                     (SMMEMCLKDELAY),
     .SMMEMCLK                          (SMMEMCLK),
     .HRESETn                           (HRESETn),
     .NextAsynAxs                       (NextAsynAxs),
     .SmCtrlIn                          (NextSMCSMC),
     .SmCtrlInit                        (1'b0));

  // CSn
  SsmcPadMux #(8) uSsmcPadMuxCSn
    (
     // Outputs
     .SmCtrlOut                         (nSMCS),
     // Inputs
     .SMMEMCLKDELAY                     (SMMEMCLKDELAY),
     .SMMEMCLK                          (SMMEMCLK),
     .HRESETn                           (HRESETn),
     .NextAsynAxs                       (NextAsynAxs),
     .SmCtrlIn                          (NextSMCSMCn),
     .SmCtrlInit                        (1'b1));

  // OEN
  SsmcPadMux #(1) uSsmcPadMuxOEn
    (
     // Outputs
     .SmCtrlOut                         (nSMOEN),
     // Inputs
     .SMMEMCLKDELAY                     (SMMEMCLKDELAY),
     .SMMEMCLK                          (SMMEMCLK),
     .HRESETn                           (HRESETn),
     .NextAsynAxs                       (NextAsynAxs),
     .SmCtrlIn                          (NextSmOEn),
     .SmCtrlInit                        (1'b1));

  // ADDRVALID
  SsmcPadMux #(1) uSsmcPadMuxAddrV
    (
     // Outputs
     .SmCtrlOut                         (SMADDRVALID),
     // Inputs
     .SMMEMCLKDELAY                     (SMMEMCLKDELAY),
     .SMMEMCLK                          (SMMEMCLK),
     .HRESETn                           (HRESETn),
     .NextAsynAxs                       (NextAsynAxs),
     .SmCtrlIn                          (NxtSMADDRVALIDMC),
     .SmCtrlInit                        (1'b1));

  // DATAEN
  SsmcPadMux #(4) uSsmcPadMuxDataEn
    (
     // Outputs
     .SmCtrlOut                         (SmDataEnCore),
     // Inputs
     .SMMEMCLKDELAY                     (SMMEMCLKDELAY),
     .SMMEMCLK                          (SMMEMCLK),
     .HRESETn                           (HRESETn),
     .NextAsynAxs                       (NextAsynAxs),
     .SmCtrlIn                          (NextSMDATAENMCn),
     .SmCtrlInit                        (1'b1));

  // BAA
  SsmcPadMux #(1) uSsmcPadMuxBAA
    (
     // Outputs
     .SmCtrlOut                         (SMBAA),
     // Inputs
     .SMMEMCLKDELAY                     (SMMEMCLKDELAY),
     .SMMEMCLK                          (SMMEMCLK),
     .HRESETn                           (HRESETn),
     .NextAsynAxs                       (NextAsynAxs),
     .SmCtrlIn                          (NextSMBAAMC),
     .SmCtrlInit                        (1'b1));

  // -----------------------------------------------------------------------------
  // The following block generates the SMMEMCLKDELAYed version of the output
  // signals. SMMEMCLKDELAYed version is used for Synchronous static memory
  // accesses.
  // -----------------------------------------------------------------------------
  always @(posedge SMMEMCLKDELAY or negedge HRESETn)
    begin : p_SmClkDelPadSeq
      if (!HRESETn)
        begin
          nSMBLSMCDel      <= 4'hF;
          nSMWENMCDel      <= 1'b1;
          SMADDRMCDel      <= {2'b00, 24'h000000};
          SMDATAOUTMCDel   <= 32'h00000000;
        end
      else
        begin
          nSMBLSMCDel      <= nSMBLSMC;
          nSMWENMCDel      <= nSMWENMC;
          SMADDRMCDel      <= SMADDRMC;
          SMDATAOUTMCDel   <= SMDATAOUTMC;
        end
    end // p_SmClkDelPadSeq

  always @(posedge SMMEMCLK or negedge HRESETn)
    begin : p_AsynAxs
      if (!HRESETn)
        AsynAxs <= 1'b1;
      else
        AsynAxs <= NextAsynAxs;
    end

  // -----------------------------------------------------------------------------
  // Sequential logic for Clocking in nSMWENMC and nSMBLSMC w.r.t nSMMEMCLK
  // -----------------------------------------------------------------------------
  always @(posedge nSMMEMCLK or negedge HRESETn)
    begin : p_InvClkSeq
      if (HRESETn == 1'b0)
        begin
          nSMWEN4Async    <= 1'b1;
          nSMBLSClkdInvMC <= 4'b1111;
        end
      else
        begin
          nSMWEN4Async    <= nSMWENMC;
          nSMBLSClkdInvMC <= nSMBLSMC;
        end
    end // p_InvClkSeq

  // -----------------------------------------------------------------------------
  // BLS for Asynchronous memories is selected based on RBLE setting.
  // -----------------------------------------------------------------------------
  assign nSMBLS4Async = ((RBLEWr |
                          (AsynAxs & (~MemoryWrSt))) == 1'b1) ? nSMBLSMC :
                        nSMBLSClkdInvMC;

  // -----------------------------------------------------------------------------
  // The following mux muxes out one among the SMMEMCLK version and SMMEMCLKDELAY
  // version as the final output. The Memory State information qualified with the
  // bit indicating Asynchronous or Synchronous memories is used for mux select.
  // -----------------------------------------------------------------------------
  always @(/*AUTOSENSE*/AsynAxs or SMADDRMC or SMADDRMCDel
           or SMDATAOUTMC or SMDATAOUTMCDel or nSMBLS4Async
           or nSMBLSMCDel or nSMWEN4Async or nSMWENMCDel)
    begin : p_OutputMuxComb
      if (AsynAxs == 1'b1)
        begin
          nSMBLS        = nSMBLS4Async;
          nSMWEN        = nSMWEN4Async;
          SMADDR        = SMADDRMC;
          SmDataOutCore = SMDATAOUTMC;
        end
      else
        begin
          nSMBLS        = nSMBLSMCDel;
          nSMWEN        = nSMWENMCDel;
          SMADDR        = SMADDRMCDel;
          SmDataOutCore = SMDATAOUTMCDel;
        end
    end // p_OutputMuxComb

  // -----------------------------------------------------------------------------
  // Logic to make nSMBURSTWAIT as single bit
  // -----------------------------------------------------------------------------

  assign iSyncWtSingle = (nSMBURSTWAIT[0] | nSMCS[0]) &
                         (nSMBURSTWAIT[1] | nSMCS[1]) &
                         (nSMBURSTWAIT[2] | nSMCS[2]) &
                         (nSMBURSTWAIT[3] | nSMCS[3]) &
                         (nSMBURSTWAIT[4] | nSMCS[4]) &
                         (nSMBURSTWAIT[5] | nSMCS[5]) &
                         (nSMBURSTWAIT[6] | nSMCS[6]) &
                         (nSMBURSTWAIT[7] | nSMCS[7]);

  // -----------------------------------------------------------------------------
  // Sequential logic for Clocking in iSyncWtSingle
  // -----------------------------------------------------------------------------
  always @(posedge SMFBCLK0 or negedge HRESETn)
    begin : p_BrstWtSeq
      if (HRESETn == 1'b0)
        begin
          SmBurstWtFbClk   <= 1'b1;
        end
      else
        begin
          SmBurstWtFbClk   <= iSyncWtSingle;
        end
    end // p_BrstWtSeq

  // -----------------------------------------------------------------------------
  // Sequential logic for Clocking in SMDATAIN[7:0]
  // -----------------------------------------------------------------------------
  always @(posedge SMFBCLK0 or negedge HRESETn)
    begin : p_SmDatByte0Seq
      if (HRESETn == 1'b0)
        begin
          SmDataInReg[7:0]     <= 8'h00;
        end
      else
        begin
          if (AsynAxs == 1'b0)
            begin
              SmDataInReg[7:0] <= SMDATAIN[7:0];
            end
        end
    end // p_SmDatByte0Seq

  // -----------------------------------------------------------------------------
  // Sequential logic for Clocking in SMDATAIN[15:8]
  // -----------------------------------------------------------------------------
  always @(posedge SMFBCLK1 or negedge HRESETn)
    begin : p_SmDatByte1Seq
      if (HRESETn == 1'b0)
        begin
          SmDataInReg[15:8]     <= 8'h00;
        end
      else
        begin
          if (AsynAxs == 1'b0)
            begin
              SmDataInReg[15:8] <= SMDATAIN[15:8];
            end
        end
    end // p_SmDatByte1Seq

  // -----------------------------------------------------------------------------
  // Sequential logic for Clocking in SMDATAIN[23:16]
  // -----------------------------------------------------------------------------
  always @(posedge SMFBCLK2 or negedge HRESETn)
    begin : p_SmDatByte2Seq
      if (HRESETn == 1'b0)
        begin
          SmDataInReg[23:16]     <= 8'h00;
        end
      else
        begin
          if (AsynAxs == 1'b0)
            begin
              SmDataInReg[23:16] <= SMDATAIN[23:16];
            end
        end
    end // p_SmDatByte2Seq

  // -----------------------------------------------------------------------------
  // Sequential logic for Clocking in SMDATAIN[31:24]
  // -----------------------------------------------------------------------------
  always @(posedge SMFBCLK3 or negedge HRESETn)
    begin : p_SmDatByte3Seq
      if (HRESETn == 1'b0)
        begin
          SmDataInReg[31:24]     <= 8'h00;
        end
      else
        begin
          if (AsynAxs == 1'b0)
            begin
              SmDataInReg[31:24] <= SMDATAIN[31:24];
            end
        end
    end // p_SmDatByte3Seq

  // synopsys translate_off
  // -----------------------------------------------------------------------------
  // START OF PROTOCOL CHECKERS
  // -----------------------------------------------------------------------------


  // Protocol checkers can be used for debugging purposes.


  // -----------------------------------------------------------------------------
  // END OF PROTOCOL CHECKERS
  // -----------------------------------------------------------------------------
  // synopsys translate_on

endmodule
// --================================== End ==================================--
