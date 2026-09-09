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
//  File Name           : Arbiter3.v,v
//  File Revision       : 1.11
// 
//  Release Information : ADK_REL1v1
// 
//  ----------------------------------------------------------------------------
//  Purpose             : AHB System Arbiter.
//                        The arbiter processes requests for ownership of the
//                        bus and grants one bus master according to the
//                        arbitration scheme.
//                        The arbitration scheme is encoded within a
//                        separate sub-block (ArbSchm3) to allow it
//                        to be easily modified without compromising
//                        correct AHB operation
//  --========================================================================--

`timescale 1ns/1ps

module Arbiter3 
  ( // Common AHB signals
    HCLK, 
    HRESETn,

    // AHB Control bus signals of the active master and slave
    HTRANS, 
    HBURST, 
    HREADY, 
    HRESP,

    // Bus-request signals from individual masters
    HBUSREQM3, 
    HBUSREQM2, 
    HBUSREQM1, 
    HBUSREQM0,

    // Locked-transfer request signals from individual masters               
    HLOCKM3, 
    HLOCKM2, 
    HLOCKM1, 
    HLOCKM0,

    // Bus from SPLIT-capable slaves, indicating to the Arbiter
    //  which bus masters should be allowed to re-attempt a split
    //  transaction. Each bit of this bus corresponds to a single
    //  bus master.
    HSPLIT,

    // Bus-grant signals to individual masters (mutually exclusive)
    HGRANTM3, 
    HGRANTM2, 
    HGRANTM1, 
    HGRANTM0,
                  
    // Granted master number for multiplexor control and slaves
    HMASTER, 
    HMASTERD,

    // Indicates the locked status of the current transfer
    HMASTLOCK,
                  
    // Scan test dummy signals; not connected until scan insertion
    SCANENABLE,   // Scan Test Mode Enbl
    SCANINHCLK,   // Scan Chain Input   
    SCANOUTHCLK); // Scan Chain Output  

  input        HCLK;
  input        HRESETn;
  input [1:0]  HTRANS;
  input [2:0]  HBURST;
  input        HREADY;
  input [1:0]  HRESP;
  input        HBUSREQM3;
  input        HBUSREQM2;
  input        HBUSREQM1;
  input        HBUSREQM0;
  input        HLOCKM3;
  input        HLOCKM2;
  input        HLOCKM1;
  input        HLOCKM0;
  input [3:0]  HSPLIT;
  input        SCANENABLE;
  input        SCANINHCLK;
  output       HGRANTM3;
  output       HGRANTM2;
  output       HGRANTM1;
  output       HGRANTM0;
  output [3:0] HMASTER;
  output [3:0] HMASTERD;
  output       HMASTLOCK;
  output       SCANOUTHCLK;


//----------------------------------------------------------------------------
// Constant declarations
//----------------------------------------------------------------------------
// HTRANS transfer type signal encoding
`define TRN_IDLE 2'b00
`define TRN_BUSY 2'b01
`define TRN_NONSEQ 2'b10
`define TRN_SEQ 2'b11

  // HBURST transfer type signal encoding
`define BUR_SINGLE 3'b000
`define BUR_INCR 3'b001
`define BUR_WRAP4 3'b010
`define BUR_INCR4 3'b011
`define BUR_WRAP8 3'b100
`define BUR_INCR8 3'b101
`define BUR_WRAP16 3'b110
`define BUR_INCR16 3'b111

  // HRESP transfer response signal encoding
`define RSP_OKAY 2'b00
`define RSP_ERROR 2'b01
`define RSP_RETRY 2'b10
`define RSP_SPLIT 2'b11

//----------------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------------

// Input/Output Signals
  wire       HCLK;
  wire       HRESETn;
  wire [1:0] HTRANS;
  wire [2:0] HBURST;
  wire       HREADY;
  wire [1:0] HRESP;
  wire       HBUSREQM3;
  wire       HBUSREQM2;
  wire       HBUSREQM1;
  wire       HBUSREQM0;
  wire       HLOCKM3;
  wire       HLOCKM2;
  wire       HLOCKM1;
  wire       HLOCKM0;
  wire [3:0] HSPLIT;
  wire       SCANENABLE;
  wire       SCANINHCLK;
  wire [3:0] HMASTERD;
  wire       HMASTLOCK;
  wire       SCANOUTHCLK;

  reg        HGRANTM3;
  reg        HGRANTM2;
  reg        HGRANTM1;
  reg        HGRANTM0;
  reg  [3:0] HMASTER;


// Internal Signals

  // Request generation
  reg  [3:0]   BusReqReg;
  wire [3:0]   Request;
  wire [3:0]   TopRequest;
  reg  [3:0]   GrantMaster;
  reg  [3:0]   AddrMaster;
  reg  [3:0]   DataMaster;

  // Burst counter logic
  reg  [3:0]   NextBurst;
  reg  [3:0]   CurrentBurst;
  wire         BurstInProgress;

  // Locked transfer logic
  reg          Lock;
  wire         NextHmastLock;
  reg          iHMASTLOCK;
  reg          LockedData;
  wire         HoldLock;
  wire         SplitRetry1;
  reg          SplitRetry2;

  // Split transfer logic
  wire         Split1;
  reg          Split2;
  reg  [3:0]   SplitReg;
  wire [3:0]   SplitMask;
  reg  [3:0]   SplitMaskReg;
  reg  [3:0]   SplitMaskSet;

  // Signals used when a locked master receives a Split response
  wire         ForceNoGrant;
  reg          ForceNoMaster;
  wire         LockedSplitSet;
  reg          LockedSplitClr;



//----------------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------------
// Overview of the Arbiter operation

  // The following key signals are used in the arbiter :-
  //  GrantMaster is the master number that currently has its grant signal
  //  AddrMaster is the master number that owns the address/control signals
  //  DataMaster is the master number that owns the read/write data buses

//----------------------------------------------------------------------------
// Register request inputs
//----------------------------------------------------------------------------
// The arbiter requests inputs are registered before use.
//
// Bus master 0 is reserved for the dummy bus master (which only performs 
//  IDLE transfers). A "Pause" input signal can be connected to this input
//  signal to requst that no other masters are to be granted.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_BusReqRegSeq
      if ((!HRESETn))
        begin 
          BusReqReg <= {4{1'b0}};
        end
      else
        begin
          BusReqReg <= {HBUSREQM3,HBUSREQM2,HBUSREQM1,HBUSREQM0};
        end 
    end 

  // Mask the Request inputs - If any master has received a Split transfer
  //  reponse then its request input is masked until it is un-split.
  assign Request = (BusReqReg & (~SplitMask));

  // The arbitration scheme is instantiated to allow easier modification
  //  without affecting proper AHB operation
  ArbSchm3 uArbSchm3 
    (
     // Bused collection of all incoming requests
     .Request          (Request),
     // Indicates whether the default master has been split
     .SplitMaskDefault (SplitMask[1]),
     // Indicates that an un-split defined length burst is in progress
     .BurstInProgress  (BurstInProgress),
     // Currently granted master
     .AddrMaster       (AddrMaster),
     // Master to be granted next
     .TopRequest       (TopRequest)
     );

  // The selection of the new HGRANT signal is based on the following
  //   1. If the current transfer is locked then keep the current
  //      master granted.
  //   2. Otherwise grant the highest requesting master.
  always @ (iHMASTLOCK or HoldLock or AddrMaster or TopRequest)
    begin : p_GrantComb
      if ((iHMASTLOCK || HoldLock))
        begin 
          GrantMaster = AddrMaster;
        end
      else
        begin
          GrantMaster = TopRequest;
        end 
    end 

  // The "GrantMaster" encoding is decoded to generate individual HGRANT 
  //  signals to each bus master.
  // In the special case of a master receiving a Split response on a locked
  //  transfer, as indicated by ForceNoGrant, the HGRANT outputs are overriden
  //  to grant the bus to the dummy master.
  always @ (ForceNoGrant or GrantMaster)
    begin : p_HGrantComb
      if (ForceNoGrant)
        begin 
          HGRANTM3 = 1'b0;
          HGRANTM2 = 1'b0;
          HGRANTM1 = 1'b0;
          HGRANTM0 = 1'b1;  // Grants the dummy bus master
        end
      else
        begin
          if (GrantMaster == 4'b0011)
            begin 
              HGRANTM3 = 1'b1;
            end
          else
            begin
              HGRANTM3 = 1'b0;
            end 

          if (GrantMaster == 4'b0010)
            begin 
              HGRANTM2 = 1'b1;
            end
          else
            begin
              HGRANTM2 = 1'b0;
            end 

          if (GrantMaster == 4'b0001)
            begin 
              HGRANTM1 = 1'b1;
            end
          else
            begin
              HGRANTM1 = 1'b0;
            end 

          if (GrantMaster == 4'b0000)
            begin 
              HGRANTM0 = 1'b1;
            end
          else
            begin
              HGRANTM0 = 1'b0;
            end 
        end 
    end 

//----------------------------------------------------------------------------
// HMASTER output generation and registers
//----------------------------------------------------------------------------
// When HREADY is HIGH the master which currently has its grant signal
//  asserted becomes the owner of the address bus and the number of this 
//  master is reflected on to the HMASTER output.
// The register that generates HMASTER does not have a reset term to ensure
//  that it reflects the correct master number during reset.
  always @ (posedge HCLK)
    begin : p_AddrMasterSeq
      if (HREADY)
        begin 
          AddrMaster <= GrantMaster;
        end  
    end 

  // In the special case of a master receiving a Split response on a locked
  //  transfer the HMASTER outputs are overriden to grant the bus to dummy
  //  master.
  always @ (ForceNoMaster or AddrMaster)
    begin : p_HMASTERSeq
      if (ForceNoMaster)
        begin 
          HMASTER = 4'b0000;
        end
      else
        begin
          HMASTER = AddrMaster;
        end 
    end 

//----------------------------------------------------------------------------
// BURST TRANSFER COUNTER
//----------------------------------------------------------------------------
// During a fixed length burst transfer a master may de-assert its request
//  but the arbiter will not change the currently selected master until
//  the last transfer of the burst.
//
// The Burst counter is used to count down from the number of transfers the
//  master should perform and when the counter reaches zero the bus may be
//  passed to another master.
// The value initially loaded into the counter is dependent on whether or
//  not the address phase of the first transfer is waited.
  always @ (HREADY or HTRANS or HBURST or CurrentBurst)
    begin : p_NextBurstComb
      if ((!HREADY))
        begin 
          if (HTRANS == `TRN_NONSEQ)
            begin 
              case (HBURST)
                `BUR_INCR16,`BUR_WRAP16 : begin
                  NextBurst = 4'b1111;
                end
                `BUR_INCR8,`BUR_WRAP8 : begin
                  NextBurst = 4'b0111;
                end
                `BUR_INCR4,`BUR_WRAP4 : begin
                  NextBurst = 4'b0011;
                end
                `BUR_SINGLE,`BUR_INCR : begin
                  NextBurst = 4'b0000;
                end
                default: begin
                  NextBurst = 4'b0000;
                end
              endcase
            end
          else
            begin
              NextBurst = CurrentBurst;
            end 
        end
      else  // HREADY = '1'
        begin
          case (HTRANS)
            `TRN_NONSEQ : begin
              case (HBURST)
                `BUR_INCR16,`BUR_WRAP16 : begin
                  NextBurst = 4'b1110;
                end
                `BUR_INCR8,`BUR_WRAP8 : begin
                  NextBurst = 4'b0110;
                end
                `BUR_INCR4,`BUR_WRAP4 : begin
                  NextBurst = 4'b0010;
                end
                `BUR_SINGLE,`BUR_INCR : begin
                  NextBurst = 4'b0000;
                end
                default: begin
                  NextBurst = 4'b0000;
                end
              endcase
            end
            `TRN_SEQ : begin
              if (CurrentBurst == 4'b0000)
                begin 
                  NextBurst = 4'b0000;
                end
              else
                begin
                  NextBurst = (CurrentBurst  - 1'b1);
                end 
            end
            `TRN_BUSY : begin
              NextBurst = CurrentBurst;
            end
            `TRN_IDLE : begin
              NextBurst = 4'b0000;
            end
            default: begin
              NextBurst = 4'b0000;
            end
          endcase
        end 
    end 

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_BurstSeq
      if ((!HRESETn))
        begin 
          CurrentBurst <= {4{1'b0}};
        end
      else
        begin
          CurrentBurst <= NextBurst;
        end 
    end 

  assign BurstInProgress = (((CurrentBurst == 4'b0000) | (SplitRetry2)) ?
                           1'b0 : 1'b1);

//----------------------------------------------------------------------------
// LOCKED TRANSFERS
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Lock generation
//----------------------------------------------------------------------------
// When a master is granted the bus its HLOCK input is sampled to determine
//  whether or not it requires locked access. 
// The HoldLock signal is used to ensure that no other master is granted
//  during if data phase of the last locked transfer receives a Split or
//  Retry response.
  always @ (HoldLock or GrantMaster or HLOCKM3 or HLOCKM2 or HLOCKM1 or HLOCKM0)
    begin : p_HlockComb
      if (HoldLock)
        begin 
          Lock = 1'b1;
        end
      else
        begin
          case (GrantMaster)
            4'b0000: begin
              Lock = HLOCKM0;
            end
            4'b0001: begin
              Lock = HLOCKM1;
            end
            4'b0010: begin
              Lock = HLOCKM2;
            end
            4'b0011: begin
              Lock = HLOCKM3;
            end
            default: begin
              Lock = 1'b0;
            end
          endcase
        end 
    end 

  // The HMASTLOCK output indicates if the current address is a locked transfer.

  // A corner case exists when a master performs an access which
  // receives a SPLIT response, and then during the split data phase
  // commences the address phase of a locked transfer.  NextHmastLock
  // must be forced low in this particular case, otherwise the Arbiter
  // will incorrectly grant the split master for an extra cycle in
  // advance of receiving the HSPLIT response from the slave.
  assign NextHmastLock = HREADY ? Lock :
                         ((AddrMaster == DataMaster) &&
                          ((HRESP == `RSP_SPLIT) || (HRESP == `RSP_RETRY)) &&
                          LockedData == 1'b0) ? 1'b0 :
                         iHMASTLOCK;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HmastlockSeq
      if ((!HRESETn))
        begin 
          iHMASTLOCK <= 1'b0;
        end
      else
        begin
          iHMASTLOCK <= NextHmastLock;
        end 
    end 

  assign HMASTLOCK = iHMASTLOCK;

//----------------------------------------------------------------------------
// Last Locked Data
//----------------------------------------------------------------------------
// The signal LockedData is HIGH when the data phase a locked transfer is
//  underway. The arbiter needs to know when this is occuring in case the data
//  receives either a Split or Retry response, in which case it must ensure 
//  that the current master remains granted until the data phase has been 
//  completed.
//
// LockedData is simply a delayed version of HMASTLOCK.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_LockedDataSeq
      if ((!HRESETn))
        begin 
          LockedData <= 1'b0;
        end
      else
        begin
          if (HREADY)
            begin 
              LockedData <= iHMASTLOCK;
            end 
        end 
    end 

//------------------------------------------------------------------------------
// Split/Retry detection
//------------------------------------------------------------------------------
// SplitRetry1 is set HIGH during the first cycle of a split/retry response
//  (when HREADY is LOW). The registered SplitRetry2 is HIGH during the second
//  cycle of the response (when HREADY is HIGH).
  assign SplitRetry1 = ((HREADY == 1'b0) & ((HRESP == `RSP_RETRY) |
                       (HRESP == `RSP_SPLIT))) ?
                       1'b1 : 1'b0;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_SplitRetry2Seq
      if ((!HRESETn))
        begin 
          SplitRetry2 <= 1'b0;
        end
      else
        begin
          SplitRetry2 <= SplitRetry1;
        end 
    end 

  // The HoldLock signal is asserted when the data phase of the last locked
  //  transfer receives either a Split or Retry response. This is used to
  //  force the iHMASTLOCK signal 
  assign HoldLock = (((LockedData) & (SplitRetry2)) ? 1'b1 : 1'b0);

//----------------------------------------------------------------------------
// SPLIT TRANSFERS
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Split Response Detection
//----------------------------------------------------------------------------
// The following section is used to detect and monitor Split responses. A 
//  register with one bit per master is used to record which masters have 
//  received a Split response.
// 
// DataMaster contains the number of the master that is currently
//  driving/reading the data buses and is used to determine which bit of the
//  SplitMask should be set when a split response is detected.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_DataMasterSeq
      if ((!HRESETn))
        begin 
          DataMaster <= {4{1'b0}};
        end
      else
        begin
          if (HREADY)
            begin 
              DataMaster <= AddrMaster;
            end 
        end 
    end 

  // DataMaster is passed out to HMASTERD (HMASTER for the data phase) which 
  //  is used by the master to slave multiplexor, MuxM2S
  assign HMASTERD = DataMaster;

  assign Split1 = (((HRESP == `RSP_SPLIT) & (HREADY == 1'b0)) ? 1'b1 : 1'b0);

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_Split2
      if ((!HRESETn))
        begin 
          Split2 <= 1'b0;
        end
      else
        begin
          Split2 <= Split1;
        end 
    end 

  always @ (Split2 or DataMaster)
    begin : p_MaskSetComb
      if (Split2)
        begin 
          case (DataMaster)
            4'b0000: begin
              SplitMaskSet = 4'b0001;
            end
            4'b0001: begin
              SplitMaskSet = 4'b0010;
            end
            4'b0010: begin
              SplitMaskSet = 4'b0100;
            end
            4'b0011: begin
              SplitMaskSet = 4'b1000;
            end
            default: begin
              SplitMaskSet = 4'b0000;
            end
          endcase
        end
      else
        begin
          SplitMaskSet = 4'b0000;
        end 
    end 

  // HSPLIT is used to clear the appropriate bits in the SplitMask when a
  //  split-capable slave indicates that it can complete the transfer. Clearing 
  //  must have priority over setting to ensure that the SplitMask is cleared 
  //  if HSPLITx is asserted in the second cycle of a Split Response.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_SplitRegSeq
      if ((!HRESETn))
        begin 
          SplitReg <= {4{1'b0}};
        end
      else
        begin
          SplitReg <= HSPLIT;
        end 
    end 

  assign SplitMask = ((SplitMaskReg | SplitMaskSet) & (~SplitReg));

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_SplitMaskRegSeq
      if ((!HRESETn))
        begin 
          SplitMaskReg <= {4{1'b0}};
        end
      else
        begin
          SplitMaskReg <= SplitMask;
        end 
    end 

//----------------------------------------------------------------------------
// LOCKED TRANSFER WITH SPLIT RESPONSE
//----------------------------------------------------------------------------
// A special case that needs to be considered within the Arbiter is when a
//  Split response is given to a Locked transfer.
// It should be noted, that performing locked transfers to memory regions that
//  give split response is not recommended as this will cause the bus to be 
//  locked for a large number of cycles.
// A split response to a locked transfer is detected using the
// LockedSplitSet signal.
  assign LockedSplitSet = (((LockedData) & (Split2)) ? 1'b1 : 1'b0);

  always @ (DataMaster or SplitReg)
    begin : p_LockedSplitClr
      case (DataMaster)
        4'b0000: begin
          LockedSplitClr = SplitReg[0];
        end
        4'b0001: begin
          LockedSplitClr = SplitReg[1];
        end
        4'b0010: begin
          LockedSplitClr = SplitReg[2];
        end
        4'b0011: begin
          LockedSplitClr = SplitReg[3];
        end
        default: begin
          LockedSplitClr = 1'b0;
        end
      endcase
    end 

  // The signal ForceNoGrant is used to force all the HGRANT signals LOW
  //  and a delayed version, ForceNoMaster, is used to force the HMASTER
  //  output to zero, indicating that the dummy master has been granted.
  // This must happen when a master performing a locked transfer, but the
  //  slave gives a Split response.
  assign ForceNoGrant = ((LockedSplitSet) ? 
                        1'b1 : ((LockedSplitClr) ? 
                        1'b0 : (ForceNoMaster)));

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_ForceNoMasterSeq
      if ((!HRESETn))
        begin 
          ForceNoMaster <= 1'b0;
        end
      else
        begin
          if (HREADY)
            begin 
              ForceNoMaster <= ForceNoGrant;
            end 
        end 
    end 

endmodule

// --================================= End ===================================--

