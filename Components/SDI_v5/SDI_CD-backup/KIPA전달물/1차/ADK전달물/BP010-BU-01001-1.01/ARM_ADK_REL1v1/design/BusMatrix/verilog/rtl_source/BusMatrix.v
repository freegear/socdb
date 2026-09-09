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
//  File Name           : BusMatrix.v,v
//  File Revision       : 1.2
//  
//  Release Information : BusMatrix-REL1v0
//  
//-----------------------------------------------------------------------------
//  Purpose             : BusMatrix is the top-level which connects together
//                        the required Input Stages, MatrixDecodes, Output 
//                        Stages and Output Arbitration blocks.
//                        
//===========================================================================--
`timescale 1ns/1ps

module BusMatrix (
    
    // Common AHB signals
    HCLK,
    HRESETn,

    // Input Port 0
    HSELS0 ,
    HADDRS0,
    HTRANSS0,
    HWRITES0,
    HSIZES0,
    HBURSTS0,
    HPROTS0,
    HWDATAS0,
    HMASTLOCKS0,
    HREADYS0,
    HRDATAS0,
    HREADYOUTS0,
    HRESPS0,
                  
    // Input Port 1
    HSELS1,
    HADDRS1,
    HTRANSS1,
    HWRITES1,
    HSIZES1,
    HBURSTS1,
    HPROTS1,
    HWDATAS1,
    HMASTLOCKS1,
    HREADYS1,
    HRDATAS1,
    HREADYOUTS1,
    HRESPS1,
                  
    // Output Port 0
    HSELM0,
    HADDRM0,
    HTRANSM0,
    HWRITEM0,
    HSIZEM0,
    HBURSTM0,
    HPROTM0,
    HWDATAM0,
    HMASTLOCKM0,
    HREADYM0,
    HRDATAM0,
    HREADYOUTM0,
    HRESPM0,
                  
    // Output Port 1
    HSELM1,
    HADDRM1,
    HTRANSM1,
    HWRITEM1,
    HSIZEM1,
    HBURSTM1,
    HPROTM1,
    HWDATAM1,
    HMASTLOCKM1,
    HREADYM1,
    HRDATAM1,
    HREADYOUTM1,
    HRESPM1,
                  
    // Output Port 2
    HSELM2,
    HADDRM2,
    HTRANSM2,
    HWRITEM2,
    HSIZEM2,
    HBURSTM2,
    HPROTM2,
    HWDATAM2,
    HMASTLOCKM2,
    HREADYM2,
    HRDATAM2,
    HREADYOUTM2,
    HRESPM2,
                  
    // Scan test dummy signals; not connected until scan insertion 
    SCANENABLE,   // Scan Test Mode Enbl
    SCANINHCLK,   // Scan Chain Input   
    SCANOUTHCLK   // Scan Chain Output     
    );
  

    input         HCLK;
    input         HRESETn;

    input         HSELS0;
    input  [31:0] HADDRS0;
    input   [1:0] HTRANSS0;
    input         HWRITES0;
    input   [2:0] HSIZES0;
    input   [2:0] HBURSTS0;
    input   [3:0] HPROTS0;
    input  [31:0] HWDATAS0;
    input         HMASTLOCKS0;
    input         HREADYS0;

    input         HSELS1;
    input  [31:0] HADDRS1;
    input   [1:0] HTRANSS1;
    input         HWRITES1;
    input   [2:0] HSIZES1;
    input   [2:0] HBURSTS1;
    input   [3:0] HPROTS1;
    input  [31:0] HWDATAS1;
    input         HMASTLOCKS1;
    input         HREADYS1;
  
    input  [31:0] HRDATAM0;
    input         HREADYOUTM0;
    input   [1:0] HRESPM0;
    input  [31:0] HRDATAM1;
    input         HREADYOUTM1;
    input   [1:0] HRESPM1;
    input  [31:0] HRDATAM2;
    input         HREADYOUTM2;
    input   [1:0] HRESPM2;

    input         SCANENABLE;
    input         SCANINHCLK;

  
    output [31:0] HRDATAS0;
    output        HREADYOUTS0;
    output  [1:0] HRESPS0;
    output [31:0] HRDATAS1;
    output        HREADYOUTS1;
    output  [1:0] HRESPS1;
  
    output        HSELM0;
    output [31:0] HADDRM0;
    output  [1:0] HTRANSM0;
    output        HWRITEM0;
    output  [2:0] HSIZEM0;
    output  [2:0] HBURSTM0;
    output  [3:0] HPROTM0;
    output [31:0] HWDATAM0;
    output        HMASTLOCKM0;
    output        HREADYM0;

    output        HSELM1;
    output [31:0] HADDRM1;
    output  [1:0] HTRANSM1;
    output        HWRITEM1;
    output  [2:0] HSIZEM1;
    output  [2:0] HBURSTM1;
    output  [3:0] HPROTM1;
    output [31:0] HWDATAM1;
    output        HMASTLOCKM1;
    output        HREADYM1;

    output        HSELM2;
    output [31:0] HADDRM2;
    output  [1:0] HTRANSM2;
    output        HWRITEM2;
    output  [2:0] HSIZEM2;
    output  [2:0] HBURSTM2;
    output  [3:0] HPROTM2;
    output [31:0] HWDATAM2;
    output        HMASTLOCKM2;
    output        HREADYM2;
 
    output        SCANOUTHCLK;
 
 
    wire        HCLK;
    wire        HRESETn;

    wire        HSELS0;
    wire [31:0] HADDRS0;
    wire  [1:0] HTRANSS0;
    wire        HWRITES0;
    wire  [2:0] HSIZES0;
    wire  [2:0] HBURSTS0;
    wire  [3:0] HPROTS0;
    wire [31:0] HWDATAS0;
    wire        HMASTLOCKS0;
    wire        HREADYS0;
    wire [31:0] HRDATAS0;
    wire        HREADYOUTS0;
    wire  [1:0] HRESPS0;

    wire        HSELS1;
    wire [31:0] HADDRS1;
    wire  [1:0] HTRANSS1;
    wire        HWRITES1;
    wire  [2:0] HSIZES1;
    wire  [2:0] HBURSTS1;
    wire  [3:0] HPROTS1;
    wire [31:0] HWDATAS1;
    wire        HMASTLOCKS1;
    wire        HREADYS1;
    wire [31:0] HRDATAS1;
    wire        HREADYOUTS1;
    wire  [1:0] HRESPS1;

    wire        HSELM0;
    wire [31:0] HADDRM0;
    wire  [1:0] HTRANSM0;
    wire        HWRITEM0;
    wire  [2:0] HSIZEM0;
    wire  [2:0] HBURSTM0;
    wire  [3:0] HPROTM0;
    wire [31:0] HWDATAM0;
    wire        HMASTLOCKM0;
    wire        HREADYM0;
    wire [31:0] HRDATAM0;
    wire        HREADYOUTM0;
    wire  [1:0] HRESPM0;

    wire        HSELM1;
    wire [31:0] HADDRM1;
    wire  [1:0] HTRANSM1;
    wire        HWRITEM1;
    wire  [2:0] HSIZEM1;
    wire  [2:0] HBURSTM1;
    wire  [3:0] HPROTM1;
    wire [31:0] HWDATAM1;
    wire        HMASTLOCKM1;
    wire        HREADYM1;
    wire [31:0] HRDATAM1;
    wire        HREADYOUTM1;
    wire  [1:0] HRESPM1;

    wire        HSELM2;
    wire [31:0] HADDRM2;
    wire  [1:0] HTRANSM2;
    wire        HWRITEM2;
    wire  [2:0] HSIZEM2;
    wire  [2:0] HBURSTM2;
    wire  [3:0] HPROTM2;
    wire [31:0] HWDATAM2;
    wire        HMASTLOCKM2;
    wire        HREADYM2;
    wire [31:0] HRDATAM2;
    wire        HREADYOUTM2;
    wire  [1:0] HRESPM2;

  
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    wire        Sel0;
    wire [31:0] Addr0;
    wire  [1:0] Trans0;
    wire        Write0;
    wire  [2:0] Size0;
    wire  [2:0] Burst0;
    wire  [3:0] Prot0;
    wire        Mastlock0;
    wire        Active0;
    wire        HeldTran0;
    wire        Readyout0;
    wire  [1:0] Resp0;

    wire        Sel1;
    wire [31:0] Addr1;
    wire  [1:0] Trans1;
    wire        Write1;
    wire  [2:0] Size1;
    wire  [2:0] Burst1;
    wire  [3:0] Prot1;
    wire        Mastlock1;
    wire        Active1;
    wire        HeldTran1;
    wire        Readyout1;
    wire  [1:0] Resp1;
  
    wire        Sel0to0;
    wire        Active0to0;
    wire        Sel1to0;
    wire        Active1to0;
  
    wire        Sel0to1;
    wire        Active0to1;
    wire        Sel1to1;
    wire        Active1to1;
  
    wire        Sel0to2;
    wire        Active0to2;
    wire        Sel1to2;
    wire        Active1to2;
  
  
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define RSP_OKAY 2'b00

  
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
  
  InputStage uInputStage0 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS0),
    .HADDRS     (HADDRS0),
    .HTRANSS    (HTRANSS0),
    .HWRITES    (HWRITES0),
    .HSIZES     (HSIZES0),
    .HBURSTS    (HBURSTS0),
    .HPROTS     (HPROTS0),
    .HMASTLOCKS (HMASTLOCKS0),
    .HREADYS    (HREADYS0),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS0),
    .HRESPS     (HRESPS0),

    // Internal Address/Control Signals
    .Sel        (Sel0),
    .Addr       (Addr0),
    .Trans      (Trans0),
    .Write      (Write0),
    .Size       (Size0),
    .Burst      (Burst0),
    .Prot       (Prot0),
    .Mastlock   (Mastlock0),
    .HeldTran   (HeldTran0),

    // Internal Response
    .Active     (Active0),
    .Readyout   (Readyout0),
    .Resp       (Resp0)
    );
  
  InputStage uInputStage1 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS1),
    .HADDRS     (HADDRS1),
    .HTRANSS    (HTRANSS1),
    .HWRITES    (HWRITES1),
    .HSIZES     (HSIZES1),
    .HBURSTS    (HBURSTS1),
    .HPROTS     (HPROTS1),
    .HMASTLOCKS (HMASTLOCKS1),
    .HREADYS    (HREADYS1),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS1),
    .HRESPS     (HRESPS1),

    // Internal Address/Control Signals
    .Sel        (Sel1),
    .Addr       (Addr1),
    .Trans      (Trans1),
    .Write      (Write1),
    .Size       (Size1),
    .Burst      (Burst1),
    .Prot       (Prot1),
    .Mastlock   (Mastlock1),
    .HeldTran   (HeldTran1),

    // Internal Response
    .Active     (Active1),
    .Readyout   (Readyout1),
    .Resp       (Resp1)
    );


  MatrixDecode uMatrixDecode0 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS0),
    .Sel        (Sel0),
    .Addr       (Addr0),
    .Sel0       (Sel0to0),
    .Active0    (Active0to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
    .Sel1       (Sel0to1),
    .Active1    (Active0to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
    .Sel2       (Sel0to2),
    .Active2    (Active0to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
    .Active     (Active0),
    .HREADYOUTS (Readyout0),
    .HRESPS     (Resp0),
    .HRDATAS    (HRDATAS0)
    );
  
  MatrixDecode uMatrixDecode1 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS1),
    .Sel        (Sel1),
    .Addr       (Addr1),
    .Sel0       (Sel1to0),
    .Active0    (Active1to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
    .Sel1       (Sel1to1),
    .Active1    (Active1to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
    .Sel2       (Sel1to2),
    .Active2    (Active1to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
    .Active     (Active1),
    .HREADYOUTS (Readyout1),
    .HRESPS     (Resp1),
    .HRDATAS    (HRDATAS1)
    );

  
  OutputStage uOutputstage0 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to0),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to0),
         
    // Port 1 Signals
    .Sel1       (Sel1to0),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to0),
         
    // Slave Address/Control Signals
    .HSELM      (HSELM0),
    .HADDRM     (HADDRM0),
    .HTRANSM    (HTRANSM0),
    .HWRITEM    (HWRITEM0),
    .HSIZEM     (HSIZEM0),
    .HBURSTM    (HBURSTM0),
    .HPROTM     (HPROTM0),
    .HMASTLOCKM (HMASTLOCKM0),
    .HREADYM    (HREADYM0),
    .HWDATAM    (HWDATAM0),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM0)
    );
  
  OutputStage uOutputstage1 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to1),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to1),
         
    // Port 1 Signals
    .Sel1       (Sel1to1),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to1),
         
    // Slave Address/Control Signals
    .HSELM      (HSELM1),
    .HADDRM     (HADDRM1),
    .HTRANSM    (HTRANSM1),
    .HWRITEM    (HWRITEM1),
    .HSIZEM     (HSIZEM1),
    .HBURSTM    (HBURSTM1),
    .HPROTM     (HPROTM1),
    .HMASTLOCKM (HMASTLOCKM1),
    .HREADYM    (HREADYM1),
    .HWDATAM    (HWDATAM1),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM1)
    );
  
  OutputStage uOutputstage2 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to2),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to2),
         
    // Port 1 Signals
    .Sel1       (Sel1to2),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to2),
         
    // Slave Address/Control Signals
    .HSELM      (HSELM2),
    .HADDRM     (HADDRM2),
    .HTRANSM    (HTRANSM2),
    .HWRITEM    (HWRITEM2),
    .HSIZEM     (HSIZEM2),
    .HBURSTM    (HBURSTM2),
    .HPROTM     (HPROTM2),
    .HMASTLOCKM (HMASTLOCKM2),
    .HREADYM    (HREADYM2),
    .HWDATAM    (HWDATAM2),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM2)
    );
  
endmodule


