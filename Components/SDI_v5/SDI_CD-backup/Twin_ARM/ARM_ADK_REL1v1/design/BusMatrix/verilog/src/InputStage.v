//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//
//-----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : InputStage.v,v
//  File Revision       : 1.4
//  
//  Release Information : BusMatrix-REL1v0
//  
//-----------------------------------------------------------------------------
//  Purpose             : The Input Stage is used to hold a pending transfer
//                        when the required output stage is not available.
//                        
//===========================================================================--
`timescale 1ns/1ps

module InputStage (    
    HCLK ,
    HRESETn ,
// Input Port Address/Control Signals
    HSELS ,
    HADDRS ,
    HTRANSS ,
    HWRITES ,
    HSIZES ,
    HBURSTS ,
    HPROTS ,
    HMASTLOCKS ,
    HREADYS ,
// Input Port Response
    HREADYOUTS ,
    HRESPS ,
// Internal Address/Control Signals
    Sel ,
    Addr ,
    Trans ,
    Write ,
    Size ,
    Burst ,
    Prot ,
    Mastlock ,
    HeldTran ,
// Internal Response
    Active ,
    Readyout ,
    Resp );

    input         HCLK;
    input         HRESETn;
    input         HSELS;
    input  [31:0] HADDRS;
    input   [1:0] HTRANSS;
    input         HWRITES;
    input   [2:0] HSIZES;
    input   [2:0] HBURSTS;
    input   [3:0] HPROTS;
    input         HMASTLOCKS;
    input         HREADYS;
    input         Active;
    input         Readyout;
    input   [1:0] Resp;
    output        HREADYOUTS;
    output  [1:0] HRESPS;
    output        Sel;
    output [31:0] Addr;
    output  [1:0] Trans;
    output        Write;
    output  [2:0] Size;
    output  [2:0] Burst;
    output  [3:0] Prot;
    output        Mastlock;
    output        HeldTran;

    wire        HCLK;
    wire        HRESETn;
    wire        HSELS;
    wire [31:0] HADDRS;
    wire  [1:0] HTRANSS;
    wire        HWRITES;
    wire  [2:0] HSIZES;
    wire  [2:0] HBURSTS;
    wire  [3:0] HPROTS;
    wire        HMASTLOCKS;
    wire        HREADYS;
    reg         HREADYOUTS;
    reg   [1:0] HRESPS;
    reg         Sel;
    reg  [31:0] Addr;
    wire  [1:0] Trans;
    reg         Write;
    reg   [2:0] Size;
    wire  [2:0] Burst;
    reg   [3:0] Prot;
    reg         Mastlock;
    wire        HeldTran;
    wire        Active;
    wire        Readyout;
    wire  [1:0] Resp;


//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    wire        LoadReg;
    wire        iHeldTran;
    reg         HeldTranReg;
    reg         Valid;
    wire        ValidNext;
    reg  [31:0] RegAddr;
    reg         RegWrite;
    reg   [2:0] RegSize;
    reg   [2:0] RegBurst;
    reg   [3:0] RegProt;
    reg         RegMastlock;
    reg   [1:0] TransInt;
    reg   [2:0] BurstInt;
    reg   [3:0] OffsetAddr;
    reg   [3:0] CheckAddr;
    reg         BurstOverride;
    wire        BurstOverrideNext;
    reg         Bound;
    wire        BoundNext;
    wire        BoundEn;
  
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

`define true  1'b1
`define false 1'b0

// HTRANS transfer type signal encoding
`define TRN_IDLE 2'b00
`define TRN_BUSY 2'b01
`define TRN_NONSEQ 2'b10
`define TRN_SEQ 2'b11

// HSIZE transfer type signal encoding
`define SZ_BYTE 3'b000
`define SZ_HALF 3'b001
`define SZ_WORD 3'b010

// HBURST transfer type signal encoding
`define BUR_SINGLE 3'b000
`define BUR_INCR 3'b001
`define BUR_WRAP4 3'b010
`define BUR_INCR4 3'b011
`define BUR_WRAP8 3'b100
`define BUR_INCR8 3'b101
`define BUR_WRAP16 3'b110
`define BUR_INCR16 3'b111
`define RSP_OKAY 2'b00

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Holding Registers
//------------------------------------------------------------------------------
// Each input port has a holding register associated with it and a mux to
//  select between the register and the direct input path. The control of
//  the mux is done simply by selecting the holding register when it is loaded
//  with a pending transfer, otherwise the straight through path is used.

  always @ (negedge HRESETn or posedge HCLK)
  begin : p_HoldingRegSeq1
    if  ( HRESETn ==1'b0 )
    begin 
      RegAddr     <= {32{1'b0}};
      RegWrite    <= 1'b0 ;
      RegSize     <= 3'b000;
      RegBurst    <= 3'b000;
      RegProt     <= 4'b0000;
      RegMastlock <= 1'b0 ;
    end
    else
    begin
      if  ( LoadReg )
      begin 
        RegAddr     <= HADDRS ;
        RegWrite    <= HWRITES ;
        RegSize     <= HSIZES ;
        RegBurst    <= HBURSTS ;
        RegProt     <= HPROTS ;
        RegMastlock <= HMASTLOCKS ;
      end 
    end 
  end 

// The holding register is loaded whenever there is a transfer on the input
//  port, but it is not being driven on to the selected slave (as indicated
//  by Active being low).

  assign ValidNext  = (HSELS  & HTRANSS[1]) ? 1'b1  : 1'b0 ;
  
  assign LoadReg  = ((ValidNext & HREADYS) & (Active ==1'b0 )) ? 1'b1 : 1'b0;

  always @ (negedge HRESETn or posedge HCLK)
  begin : p_ValidSeq
    if  ( HRESETn ==1'b0 )
      Valid  <= 1'b0 ;
    else
    begin
     if  ( HREADYS )
      Valid  <= ValidNext ;
    end 
  end 

// The HeldTransfer signal is used to indicate when there is an active
//  transfer in the holding register. It is always set after the LoadReg
//  signal has been active. When set, it is cleared when the transfer is
//  being driven on to the selected slave (as indicated by Active being
//  high) and HREADY from the selected slave is high.

  assign iHeldTran  = ((LoadReg ) ? 1'b1  : 
                        (((Active ) & (Readyout )) ? 1'b0  : (HeldTranReg )));

  always @ (negedge HRESETn or posedge HCLK)
  begin : p_HeldTranSeq
    if  ( HRESETn ==1'b0 )
     HeldTranReg  <= 1'b0 ;
    else
     HeldTranReg  <= iHeldTran ;
  end 

     assign  HeldTran  = iHeldTran ;
// The output from this stage is selected from the holding register when
//  there is a held transfer. Otherwise the direct path is used.

  always @ (HeldTranReg or HSELS or HTRANSS or HADDRS or HWRITES 
            or HSIZES or HBURSTS or HPROTS or HMASTLOCKS or RegAddr 
            or RegWrite or RegSize or RegBurst or RegProt or RegMastlock)
  begin : p_MuxComb
    if  ( HeldTranReg ==1'b0 )
    begin 
      Sel      = HSELS ;
      TransInt = HTRANSS ;
      Addr     = HADDRS ;
      Write    = HWRITES ;
      Size     = HSIZES ;
      BurstInt = HBURSTS ;
      Prot     = HPROTS ;
      Mastlock = HMASTLOCKS ;
    end
    else
    begin
      Sel      = 1'b1 ;
      TransInt = `TRN_NONSEQ ;
      Addr     = RegAddr ;
      Write    = RegWrite ;
      Size     = RegSize ;
      BurstInt = RegBurst ;
      Prot     = RegProt ;
      Mastlock = RegMastlock ;
    end 
  end 

  assign Trans  = BurstOverride & Bound & (TransInt ==`TRN_SEQ ) ? `TRN_NONSEQ  
                : BurstOverride & Bound & (TransInt ==`TRN_BUSY ) ? `TRN_IDLE  
                : TransInt;

  assign Burst  = BurstOverride & (HTRANSS !=`TRN_NONSEQ ) ? `BUR_INCR  
                : BurstInt;

//------------------------------------------------------------------------------
// HREADYOUT Generation
//------------------------------------------------------------------------------
// There are three possible sources for the HREADYOUT signal.
//  - It is driven LOW when there is a held transfer.
//  - It is driven HIGH when not Selected or for Idle/Busy transfers.
//  - At all other times it is driven from the appropriate shared
//    slave.

  always @ (Valid or HeldTranReg or Readyout or Resp)
  begin : p_ReadyComb
    if  (Valid == 1'b0)
    begin 
      HREADYOUTS = 1'b1 ;
      HRESPS     = `RSP_OKAY ;
    end
    else if ( HeldTranReg )
    begin 
      HREADYOUTS = 1'b0 ;
      HRESPS     = `RSP_OKAY ;
    end
    else
    begin
      HREADYOUTS = Readyout ;
      HRESPS     = Resp ;
    end 
  end 

//------------------------------------------------------------------------------
// Early Burst Termination
//------------------------------------------------------------------------------
// There are times when the output stage will switch to another input port
//  without allowing the current burst to complete. In these cases the HTRANS
//  and HBURST signals need to be overriden to ensure that the transfers
//  reaching the output port meet the AHB specification.

  assign BurstOverrideNext  = (HTRANSS ==`TRN_NONSEQ ) 
                               | (HTRANSS ==`TRN_IDLE ) ? 1'b0  
                            : (Active ==1'b0) ? 1'b1  
                            : BurstOverride ;
 
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_BurstOverrideSeq
    if  ( HRESETn ==1'b0 )
      BurstOverride  <= 1'b0 ;
    else
      BurstOverride  <= BurstOverrideNext ;
  end 

// Boundary Checking Logic
  always @ (HADDRS or HSIZES)
  begin : p_OffsetAddrComb
    case (HSIZES )
      3'b000: OffsetAddr  = HADDRS[3:0];
      3'b001: OffsetAddr  = HADDRS[4:1];
      3'b010: OffsetAddr  = HADDRS[5:2];
      3'b011: OffsetAddr  = HADDRS[6:3];
      default: OffsetAddr  = HADDRS[3:0];
    endcase
  end 

  always @ (OffsetAddr or HBURSTS)
  begin : p_CheckAddrComb
    case (HBURSTS )
      `BUR_WRAP4 : begin
        CheckAddr[1:0] = OffsetAddr[1:0];
        CheckAddr[3:2] = 2'b11;
      end

      `BUR_WRAP8 : begin
        CheckAddr[2:0] = OffsetAddr[2:0];
        CheckAddr[3]   = 1'b1 ;
      end

      `BUR_WRAP16 : begin
        CheckAddr[3:0] = OffsetAddr[3:0];
      end

      default: begin
        CheckAddr[3:0] = 4'b0000;
      end
    endcase
  end 

  assign BoundNext  = (CheckAddr ==4'b1111) ? 1'b1  : (1'b0 );

  assign BoundEn  = ((HTRANSS [1]) & HREADYS) ? 1'b1 : 1'b0;
  
  always @ (negedge HRESETn or posedge HCLK)
  begin : p_BoundSeq
    if  ( HRESETn ==1'b0 )
      Bound  <= 1'b0 ;
    else
    begin
      if  (BoundEn)
        Bound  <= BoundNext ;
    end 
  end 

endmodule
