// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : rps.v,v
// File Revision       : 1.2
// 
// Release Information : PL160-REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose : Reference Peripheral Instantiations
// --=========================================================================--

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
wire   [7:0]    PRDATADCDC;


wire   DCDCCLK;
wire   PCLK; 
wire   BnRES; 
wire   SCANMODE; 
wire   PSEL; 
wire   PENABLE; 
wire   PWRITE;
wire   [15:0] PADDR; 
// wire   [7:0] PWDATA; 
wire   DCDCDRIVE1IN; 
wire   DCDCDRIVE0IN; 
wire   DCDCFB1; 
wire   DCDCFB0;
wire   DCDCDR1SEL; 
wire   DCDCDR0SEL; 
// wire   [7:0] PRDATA; 
wire   DCDCDRIVEOE; 
wire   DCDCDRIVE1OUT;
wire   DCDCDRIVE0OUT;
reg    nDCDCRSTInt;
reg    nDCDCRST; 

//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------

assign PRDATA = ({24'h000000, PRDATARemPause} | {24'h00000, PRDATADCDC});

assign NFIQ_Local = 1'b1;
assign NIRQ_Local = 1'b1;

assign SCANMODE = 1'b0;
 
assign DCDCDRIVE0IN = 1'b1;
assign DCDCDRIVE1IN = 1'b1;
assign DCDCFB0      = 1'b0;
assign DCDCFB1      = 1'b0;
assign DCDCDR0SEL   = 1'b0;
assign DCDCDR1SEL   = 1'b0;

// create nDCDCRST by synchronizing BnRES
  always @(posedge BCLK or negedge BnRES)
  begin
    if (BnRES == 1'b0)
      begin
        nDCDCRSTInt <= 1'b0;
        nDCDCRST    <= 1'b0;
      end
    else
      begin
        nDCDCRSTInt <= BnRES;
        nDCDCRST    <= nDCDCRSTInt;
      end
  end

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

Dcdc uDcdc
      ( .DCDCCLK(BCLK),
        .PCLK(BCLK),
        .BnRES(BnRES),
        .nDCDCRST(nDCDCRST),
        .SCANMODE(SCANMODE),
        .PSEL(PSELUUT),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR[7:2]),
        .PWDATA(PWDATA[7:0]),
        .PRDATA(PRDATADCDC),
        .DCDCDRIVE0IN(DCDCDRIVE0IN), 
        .DCDCDRIVE1IN(DCDCDRIVE1IN), 
        .DCDCFB0(DCDCFB0), 
        .DCDCFB1(DCDCFB1), 
        .DCDCDR0SEL(DCDCDR0SEL),
        .DCDCDR1SEL(DCDCDR1SEL),
        .DCDCDRIVE0OUT(),
        .DCDCDRIVE1OUT(),
        .DCDCDRIVEOE()
           );


endmodule

// --================================ End ====================================--
