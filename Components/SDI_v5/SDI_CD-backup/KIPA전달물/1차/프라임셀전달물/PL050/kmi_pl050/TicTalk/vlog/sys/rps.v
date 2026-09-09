//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : rps.v,v
//  File Revision       : 1.1
//  
//  Release Information : PL050-REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Reference Peripheral Instantiations
//  --========================================================================--

`timescale 1ns/1ps

module rps (
        BCLK,
        BnRES,
        Pause,
        Remap,

        PENABLE, 
        PSELRPC,
        PSELUUT,
        PSELIC,
        PADDR,
        PWRITE,
        PWDATA,
        PRDATA,
        REFCLK
        );

`uselib lib=sys lib=uut

// ASB Inputs
input           BCLK;
input           BnRES;
input           REFCLK;

// ASB Outputs
output          Pause;   // Pause mode entered
output          Remap;   // Reset memory map in use

// APB Inputs
input  [15:0]   PADDR;
input           PWRITE;
input           PENABLE;
input           PSELRPC; // Remap and Pause
input           PSELUUT; // UUT
input           PSELIC;  // Interrupt Controller
input  [31:0]   PWDATA;

// APB Output
output [31:0]   PRDATA;

//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------
wire            NFIQ_Local;
wire            NIRQ_Local;

wire   [7:0]    PRDATARemPause;

wire   [7:0]    PRDATAKMI;
wire            SCANMODE;
wire            KMICLKIN;
wire            KMIDATAIN;
wire            nKMICLKEN;
wire            nKMIDATAEN;
wire            KMITXINTR;
wire            KMIRXINTR;
wire            KMIINTR;
wire            PENABLE;
 
reg             nKMIRST;
reg             nKMIRSTInt;

//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------

assign PRDATA = ({24'h000000, PRDATARemPause} | {24'h000000, PRDATAKMI});

assign NFIQ_Local = 1'b1;
assign NIRQ_Local = 1'b1;

assign SCANMODE = 1'b0;
 
assign KMICLKIN   = 1'b1;
assign KMIDATAIN  = 1'b1;

// create nKMIRST by synchronizing BnRES
  always @(posedge BCLK or negedge BnRES)
  begin
    if (BnRES == 1'b0)
      begin
        nKMIRSTInt <= 1'b0;
        nKMIRST    <= 1'b0;
      end
    else
      begin
        nKMIRSTInt <= BnRES;
        nKMIRST    <= nKMIRSTInt;
      end
  end

Kmi uKmi (
        .BnRES       (BnRES),
        .PCLK        (BCLK),
        .SCANMODE    (SCANMODE),
        .nKMIRST     (nKMIRST),
        .PADDRH      (PADDR[7:6]),
        .PADDRL      (PADDR[4:2]),
        .PRDATA      (PRDATAKMI),
        .PWDATA      (PWDATA[7:0]),
        .PSEL        (PSELUUT),
        .PENABLE     (PENABLE),
        .PWRITE      (PWRITE),
        .KMIREFCLK   (BCLK),  
        .KMICLKIN    (KMICLKIN),
        .KMIDATAIN   (KMIDATAIN),
        .nKMICLKEN   (nKMICLKEN),
        .nKMIDATAEN  (nKMIDATAEN),
        .KMITXINTR   (KMITXINTR),
        .KMIRXINTR   (KMIRXINTR),
        .KMIINTR     (KMIINTR)
             );

rem_pause u_rem_pause (
        .BCLK              (BCLK), 
        .BnRES             (BnRES),
        .PENABLE           (PENABLE),
        .PSELRPC           (PSELRPC),
        .PADDR             (PADDR[5:2]), 
        .PWRITE            (PWRITE),
        .nFIQ              (NFIQ_Local),
        .nIRQ              (NIRQ_Local),
        .PWDATA            (PWDATA[0:0]), 
        .PRDATA            (PRDATARemPause[7:0]),
        .Pause             (Pause),
        .Remap             (Remap) 
        ) ;

endmodule

// --================================ End ====================================--
