// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : CLTrProtCheck.v.rca
//  File Revision          : 1.4
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Purpose : CLCD Trickbox Panel Protocol Checking module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
module CLTrProtCheck (
                     CLCLK,
                     HRESETN,
                     CLTrEn,
                     CLTrIntrTest,
                     CLTrFUFIntrTst,
                     CLPOWER,
                     LcdEn,
                     CLFP,
                     CLLP,
                     CLCP,
                     CLAC,
                     CLLE,
                     TFT,
                     PCD,
                     HSW,
                     HFP,
                     HBP,
                     LPP,
                     VSW,
                     VFP,
                     VBP,
                     ACB,
                     IVS,
                     IHS,
                     IPC,
                     IEO,
                     CPL,
                     BCD,
                     LED,
                     LEE,
                     Check,
                     CLTrBaseUpdate,
                     VCOMPINTRout,
                     LNBUINTRout,
                     VComp,
                     VSYNCState
                     );

input         CLCLK;
// LCD Clock


input         HRESETN;
// AHB System reset (active low)

input         CLTrEn;
// CLCD Trickbox Enable
 
input         CLTrIntrTest;
// CLCD Trickbox interupt test bit 
 
input         CLTrFUFIntrTst;
// CLCD Trickbox interupt test bit
 
input         CLPOWER;
// From CLCD Contr. Power enable
 
input         LcdEn;
// CLCD enable signal

input         CLFP;
// From CLCD Contr. : Frame Sync Pulse

input         CLLP;
// From CLCD Contr. : Line Sync Pulse

input         CLCP;
// From CLCD Contr. : Pixel Clock

input         CLAC;
// From CLCD Contr. : STN AC bias drive or TFT data Enable output

input         CLLE;
// From CLCD Contr. : Line End Signal

input         TFT;
// If 1 denotes TFT mode, else STN mode

input [9:0]   PCD;
// Panel Clock Divisor


input [7:0]   HSW;
// Horizontal Sync Pulse Width

input [7:0]   HFP;
// Horizontal Front Porch

input [7:0]   HBP;
// Horizontal Back Porch

input [9:0]   LPP;
// Line Per Panel

input [5:0]   VSW;
// Vertical Sync Pulse Width

input [7:0]   VFP;
// Vertical Front Porch

input [7:0]   VBP;
// Vertical Back Porch

input [4:0]   ACB;
// AC Bias Pin Frequency

input         IVS;
// Invert VSync

input         IHS;
// Invert HSync

input         IPC;
// Invert Panel Clock

input         IEO;
// Invert Output Enable

input [9:0]   CPL;
// Clocks Per Line

input         BCD;
// ByPass Pixel Clock Divisor

input [6:0]   LED;
// Line End Delay

input         LEE;
// Line End Enable

input         VCOMPINTRout;
// From Reg block

input         LNBUINTRout;
// From Reg block

input [1:0]   VComp;
// From Reg block

output [2:0]   VSYNCState;

output        Check;
// CLCP at Active Region : To provide Data Checking module a clock trigger 
// to check the CLCD Data

output         CLTrBaseUpdate;
// CLCD Trickbox Base Update Request Signal
// Loads the Address Counters in CLCDIf module by their respective base 
// addresses for Address Check up.


// -----------------------------------------------------------------------------
//
//                             CLTrProtCheck
//                             =============
//
// -----------------------------------------------------------------------------
//
// Overview:
// ========
// This module is responsible for Protocol Checking of the CLCD Panel Signals.
// This module includes:
// - Input signal formating block
// - VSync, HSync and CLCP check Block
// - CLLE Check Block
// - CLAC Check Block
// - Free-running PCLK Check Block in TFT mode
// - Check (for CLD Check) and Signal generation
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// States in the State Machine
`define ST_IDL         3'b000
`define ST_VSW          3'b001
`define ST_VBP          3'b010
`define ST_VACTIVE      3'b011
`define ST_VFP          3'b100
`define ST_HSW          3'b001
`define ST_HBP          3'b010
`define ST_HACTIVE      3'b011
`define ST_HFP          3'b100
`define ST_PCLKON       3'b001
`define ST_PCLKOFF      3'b010
`define ST_LED          3'b001
`define ST_CLLE         3'b010
`define ST_CLACON       3'b001
`define ST_CLACOFF      3'b010

// Width of counters
`define HCOUNTSIZ       11 
`define CCOUNTSIZ1      23
`define CCOUNTSIZ       11
`define CPLSIZ          11
`define LECOUNTSIZ      8
`define ACCOUNTSIZ      24

// What to do on ERROR : Exit or Continue
// --------------------------------------
`ifdef EXIT
  `define ERR_EXIT   $finish
`else
  `define ERR_EXIT   $display("Error Exit\n")
`endif
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          CLCLK;          // (module input)
wire          HRESETN;        // (module input)
wire          CLTrEn;         // (module input)
wire          CLTrIntrTest;   // (module input)
wire          CLTrFUFIntrTst; // (module input)
wire          CLPOWER;        // (module input)
wire          LcdEn;          // (module input)
wire          CLFP;           // (module input)
wire          CLLP;           // (module input)
wire          CLCP;           // (module input)
wire          CLAC;           // (module input)
wire          CLLE;           // (module input)
wire          TFT;            // (module input)
wire  [9:0]   PCD;            // (module input)
wire  [7:0]   HSW;            // (module input)
wire  [7:0]   HFP;            // (module input)
wire  [7:0]   HBP;            // (module input)
wire  [9:0]   LPP;            // (module input)
wire  [5:0]   VSW;            // (module input)
wire  [7:0]   VFP;            // (module input)
wire  [7:0]   VBP;            // (module input)
wire  [4:0]   ACB;            // (module input)
wire          IVS;            // (module input)
wire          IHS;            // (module input)
wire          IPC;            // (module input)
wire          IEO;            // (module input)
wire  [9:0]   CPL;            // (module input)
wire          BCD;            // (module input)
wire  [6:0]   LED;            // (module input)
wire          LEE;            // (module input)
wire          LNBUINTRout;    // (module input)
wire          VCOMPINTRout;   //(module input)
wire  [1:0]   VComp;          //(module input)
wire          Check;          // (module output)
wire          CLTrBaseUpdate; // (module output)
// Internal Wires:
// --------------
wire VSYNC;
// Vertical Sync : Active HIGH version CLFP

wire HSYNC;
// Horizontal Sync : Active HIGH version CLLP

wire PCLK;
// Panel Clock : Active HIGH version CLCP

wire AC;
// CLCD AC Signal : Active HIGH version CLAC

wire [31:0] LineWidth;
// Line Pulse Width in terms of CLCLK

// Values to compare
// -----------------

wire [`CCOUNTSIZ1 - 1:0]     HSWValue;
// HSW Value

wire [`CCOUNTSIZ1 - 1:0]     HBPValue;
// HBP Value

wire [`CCOUNTSIZ1 - 1:0]     HACTIVEValue;
// HACTIVE Value

wire [`CCOUNTSIZ1 - 1:0]     HFPValue;
// HFP Value

wire [`CCOUNTSIZ - 1:0]      PCLKValue;
// Panel Clock Period

wire [`CPLSIZ - 1:0]         CPLValue;
// Clocks per line counter

wire [`ACCOUNTSIZ - 1:0]     CLACValue;
// CLAC half period Value

// Internal Signal
// ---------------
wire                         Active;
// Denotes the Active region of display = VACTIVE AND HACTIVE

wire                         CLLECheck;
// Denotes the time when CLLE checking can be started.

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// State Variables
// ---------------
reg [2:0]                VSYNCState;
// VSYNC State Variable

reg [2:0]                HSYNCState;
// HSYNC State Variable

reg [2:0]                PCLKState;
// PCLK State Variable in TFT mode 

reg [2:0]                PCLKState1;
// PCLK State Variable 1 in Active region

reg [2:0]                CLLEState;
// CLLE State Variable 

reg [2:0]                CLACState;
// CLAC State Variable

reg                      CLLEFlag;
// CLLE Check flag

// Counters
// --------

reg [`HCOUNTSIZ - 1:0]                HSYNCCount;
// HSYNC Counter to count in VSYNC States

reg [`CCOUNTSIZ1 - 1:0]               CLCLKCount1;
// CLCLK Counter 1 to count in HSYNC States

reg [`CCOUNTSIZ - 1:0]                CLCLKCount2;
// CLCLK Counter 2 to count in PCLK States in TFT mode

reg [`CCOUNTSIZ - 1:0]                CLCLKCount3;
// CLCLK Counter 3 to count in PCLK States in Active region

reg [`CPLSIZ - 1:0]                   CPLCount;
// Panel Clock per line counter

reg [`LECOUNTSIZ - 1:0]               CLLECount;
// Counter to check CLLE

reg [`ACCOUNTSIZ - 1:0]               CLACCount;
// CLAC Counter

// -----------------------------------------------------------------------------
// Main body of code
// =================
// Logic resolver of CLFP, CLLP, CLCP and CLAC
// This Block will resolve the inverted logic, i.e. if CLFP is active LOW,
// this will generate active high version of CLFP as VSYNC. So, VSYNC will be
// connected directly to CLFP for IVS = 0, and to the inverted version of
// CLFP for IVS = 1. Same for CLLP, CLCP and CLAC. But, if LcdEn is low, all
// the logics should be low.
// -----------------------------------------------------------------------------
assign VSYNC = (IVS ? ~CLFP : CLFP) & (CLPOWER | CLTrFUFIntrTst);
assign HSYNC = (IHS ? ~CLLP : CLLP) & (CLPOWER | CLTrFUFIntrTst);
assign PCLK  = (IPC ? ~CLCP : CLCP) & (CLPOWER | CLTrFUFIntrTst);
assign AC    = ((IEO & TFT) ? ~CLAC : CLAC) & (CLPOWER | CLTrFUFIntrTst);

// -----------------------------------------------------------------------------
// Duration Values Generation
// -----------------------------------------------------------------------------
assign HSWValue     = (HSW + 1) * PCLKValue - 1;
assign HBPValue     = (HBP + 1) * PCLKValue - 1;
assign HACTIVEValue = (CPL+ 1) * PCLKValue - 1;
assign HFPValue     = (HFP + 1) * PCLKValue - 1;
assign PCLKValue    = BCD ? 1 : PCD + 2;
assign CLACValue    = (ACB + 1) * LineWidth - 1;
assign LineWidth    = (HSWValue + HBPValue + HFPValue + HACTIVEValue + 4);

// -----------------------------------------------------------------------------
// VSYNC TEST
// -----------------------------------------------------------------------------
always @(negedge HSYNC or negedge HRESETN or negedge CLTrEn)
begin : p_VSYNCCheck
  if (!HRESETN || !CLTrEn)
    begin
      VSYNCState = `ST_IDL;
      HSYNCCount = `HCOUNTSIZ'b0;
    end
  else
    begin
      if (VSYNCState == `ST_IDL)
        begin
           VSYNCState = `ST_VSW;
           HSYNCCount = `HCOUNTSIZ'b0;
        end
      else if (VSYNCState == `ST_VSW && HSYNCCount == VSW)
        begin
          VSYNCState = `ST_VBP;
          HSYNCCount = `HCOUNTSIZ'b0;
        end
      else if (VSYNCState == `ST_VBP && HSYNCCount == (VBP-1))
        begin
          VSYNCState = `ST_VACTIVE;
          HSYNCCount = `HCOUNTSIZ'b0;
        end
      else if (VSYNCState == `ST_VACTIVE && HSYNCCount == LPP)
        begin
          VSYNCState = `ST_VFP;
          HSYNCCount = `HCOUNTSIZ'b0;
        end
      else if (VSYNCState == `ST_VFP && HSYNCCount == (VFP-1))
        begin
          VSYNCState = `ST_VSW;
          HSYNCCount = `HCOUNTSIZ'b0;
        end
      else
        HSYNCCount = HSYNCCount + 1'b1;
      if (TFT)
        begin
          if (VSYNCState == `ST_VSW)
            begin
              if (!VSYNC && !CLTrIntrTest)
                begin
                  $display($time," ERROR:IN TFT MODE VSYNC LOW IN VSW ");
                  `ERR_EXIT;
                end
            end
          else
            begin
              if (VSYNC &&!CLTrIntrTest && LcdEn)
                begin
                  $display($time,"ERROR:TFT MODE VSYNC HIGH IN NON VSW_REGION");
                  `ERR_EXIT;
                end
            end
        end
    end
end
// -----------------------------------------------------------------------------
// To check VSYNC signal in 1st active period after HSYNC in STN mode
// -----------------------------------------------------------------------------
always@(negedge Active)
begin : p_VsyncSTNCheck
  if (!CLTrIntrTest)
    begin
      if (!TFT)
        if (VSYNCState == `ST_VACTIVE && !HSYNCCount)
          begin
            if ((!VSYNC) && (LcdEn))
              begin
                $display($time," ERROR:STN MODE VSYNC LOW IN ACTIVE REGN");
                `ERR_EXIT;
              end
          end
        else
          begin
            if ((VSYNC) && (LcdEn))
              begin
                $display($time," ERROR:STN MODE VSYNC HIGH NONACTIVE REGN");
                `ERR_EXIT;
              end
          end
    end
end
// -----------------------------------------------------------------------------
// OCCURENCE of VCOMP interupt checking 
// -----------------------------------------------------------------------------
always@(posedge VCOMPINTRout)
begin : p_VComp_Test
  if (VCOMPINTRout)
    if (!( (VComp == 2'b0 && ((VSYNCState == `ST_VFP && HSYNCCount == VFP -1)
                                                || (VSYNCState == `ST_IDL))) 
       || (VComp == 2'b01 && (VSYNCState == `ST_VSW) && HSYNCCount == VSW)  
       || (VComp == 2'b10 && (VSYNCState == `ST_VBP) && HSYNCCount == VBP-1)
       || (VComp == 2'b11 && (VSYNCState == `ST_VACTIVE) && HSYNCCount == LPP)))
       $display($time,"ERROR:IN OCCURENCE OF VCOMP INTERUPT");
end
// -----------------------------------------------------------------------------
// OCCURENCE of   LNBU interupt checking
// -----------------------------------------------------------------------------
always@(posedge LNBUINTRout)
begin : p_LNBU_Test
  if (LNBUINTRout)
    if (!(VSYNCState == `ST_VSW && HSYNCCount == VSW &&
       (HSYNCState == `ST_HACTIVE || HSYNCState == `ST_HBP)))
      $display($time,"ERROR:IN OCCURENCE OF LNBU INTERUPT");
end

// -----------------------------------------------------------------------------
// HSYNC TEST
// -----------------------------------------------------------------------------
always @(negedge CLCLK or negedge HRESETN or negedge CLTrEn)
begin : p_HSYNCCheck
  if (!HRESETN || !CLTrEn)
    begin
      HSYNCState = `ST_IDL;
      CLCLKCount1 = `CCOUNTSIZ1'b0;
    end
  else
    begin
      if (HSYNCState == `ST_HSW)
        begin
          if (!HSYNC && !CLTrIntrTest && LcdEn)
            begin
              $display($time,"ERROR: HSYNC LOW IN HSW REGION");
              `ERR_EXIT;
            end
        end
      else
        begin
          if (HSYNC && !CLTrIntrTest && LcdEn)
            begin
              $display($time,"ERROR: HSYNC HIGH IN NON_HSW REGION");
              `ERR_EXIT;
            end
        end
      if (HSYNCState == `ST_IDL && HSYNC)
        begin
           HSYNCState = `ST_HSW;
           CLCLKCount1 = `CCOUNTSIZ1'b0;
        end
      else if (HSYNCState == `ST_HSW && CLCLKCount1 == HSWValue)
        begin
          HSYNCState = `ST_HBP;
          CLCLKCount1 = `CCOUNTSIZ1'b0;
        end
      else if (HSYNCState == `ST_HBP && CLCLKCount1 == HBPValue)
        begin
          HSYNCState = `ST_HACTIVE;
          CLCLKCount1 = `CCOUNTSIZ1'b0;
        end
      else if (HSYNCState == `ST_HACTIVE && CLCLKCount1 == HACTIVEValue)
        begin
          HSYNCState = `ST_HFP;
          CLCLKCount1 = `CCOUNTSIZ1'b0;
        end
      else if (HSYNCState == `ST_HFP && CLCLKCount1 == HFPValue)
        begin
          HSYNCState = `ST_HSW;
          CLCLKCount1 = `CCOUNTSIZ1'b0;
        end
      else
        CLCLKCount1 = CLCLKCount1 + 1'b1;
    end
end

// -----------------------------------------------------------------------------
// Changing to  HSW state at each posedge of the HSYNC
// -----------------------------------------------------------------------------
always @(HSYNC)
begin : p_HSW_state
 if (HSYNC)
   begin
     HSYNCState = `ST_HSW;
     CLCLKCount1 = `CCOUNTSIZ1'b0;
   end
end

// -----------------------------------------------------------------------------
// Active Signal Generation:
// -----------------------------------------------------------------------------
assign CPLValue = CPL + 1;
assign Active = ((VSYNCState == `ST_VACTIVE) && ((HSYNCState == `ST_HACTIVE) 
                || ((HSYNCState == `ST_HFP) && (CLCLKCount1 == 'b0) && !CLCLK)))
                && !((VSYNCState == `ST_VACTIVE) && (HSYNCState == `ST_HACTIVE)
                && (CLCLKCount1 == 'b0) && !CLCLK);

// -----------------------------------------------------------------------------
// PCLK TEST in TFT mode
// -----------------------------------------------------------------------------
always @(CLCLK or negedge HRESETN or negedge CLTrEn)
begin : p_TFTPCLKCheck
  if (!CLTrIntrTest)
    begin
      if (!HRESETN || !TFT || !CLTrEn)
        begin
          PCLKState = `ST_IDL;
          CLCLKCount2 = `CCOUNTSIZ'b0;
        end
      else
        begin
          if (PCLKState == `ST_IDL && PCLK)
            begin
              PCLKState = `ST_PCLKON;
              CLCLKCount2 = `CCOUNTSIZ'b0;
            end
          else if (PCLKState == `ST_PCLKON && !PCLK)
            begin
              if ((CLCLKCount2 != PCLKValue - 1) && (LcdEn))
                begin
                  $display($time,"ERROR: IN TFT MODE CLCP period is not ",
                                         "equal to PCD * CLCLK");
                  `ERR_EXIT;
                end
              PCLKState   = `ST_PCLKOFF;
              CLCLKCount2 = `CCOUNTSIZ'b0;
            end
          else if (PCLKState == `ST_PCLKOFF && PCLK)
            begin
              if ((CLCLKCount2 != PCLKValue - 1) && (LcdEn))
                begin
                  $display($time,"ERROR : IN TFT MODE CLCP period is not ",
                                          "equalto PCD * CLCLK");
                  `ERR_EXIT;
                end
              PCLKState = `ST_PCLKON;
              CLCLKCount2 = `CCOUNTSIZ'b0;
            end
          else 
            CLCLKCount2 = CLCLKCount2 + 1'b1;
        end
    end
end

// -----------------------------------------------------------------------------
// PCLK TEST in Active region
// -----------------------------------------------------------------------------
always @(CLCLK or negedge HRESETN or negedge CLTrEn)
begin : p_ActivePCLKCheck
  if (!CLTrIntrTest)
    begin
      if (!HRESETN || !Active || !CLTrEn)
        begin
          PCLKState1 = `ST_IDL;
          CLCLKCount3 = `CCOUNTSIZ'b0;
          CPLCount    = `CPLSIZ'b0;
        end
      else
        begin
          if (PCLKState1 == `ST_IDL && PCLK)
            begin
              PCLKState1 = `ST_PCLKON;
              CLCLKCount3 = `CCOUNTSIZ'b0;
            end
          else if (PCLKState1 == `ST_PCLKON && !PCLK)
            begin
              if ((CLCLKCount3 != PCLKValue - 1) && (LcdEn))
                begin
                  $display($time," ERROR:In STN Mode in Active region CLCP ON", 
                                 " period is not equal to PCD * CLCLK "); 
                  `ERR_EXIT;
                end
              PCLKState1 = `ST_PCLKOFF;
              CLCLKCount3 = `CCOUNTSIZ'b0;
              CPLCount    = CPLCount + 1'b1;
            end
          else if (PCLKState1 == `ST_PCLKOFF)
            begin
              if (CPLCount == CPL + 1)
                begin
                  PCLKState1 = `ST_IDL;
                  CLCLKCount3 = `CCOUNTSIZ'b0;
                  CPLCount  = `CPLSIZ'b0;
                end
              else if (PCLK)
                begin
                  if ((CLCLKCount3 != PCLKValue - 1) && (LcdEn))
                    begin
                      $display($time," ERROR :In STN Mode  Active region CLCP ",
                                      "OFF period is not equal to PCD * CLCLK");
                      `ERR_EXIT;
                    end
                  PCLKState1 = `ST_PCLKON;
                  CLCLKCount3 = `CCOUNTSIZ'b0;
                end
              else
                CLCLKCount3 = CLCLKCount3 + 1'b1;
            end
          else
            CLCLKCount3 = CLCLKCount3 + 1'b1;
        end
    end
end

// -----------------------------------------------------------------------------
// CLLE Check Start Signal generation:
// -----------------------------------------------------------------------------
assign CLLECheck = (CPLCount == CPL) && PCLK && CLLEFlag;

// -----------------------------------------------------------------------------
// CLLE TEST
// -----------------------------------------------------------------------------
always @(negedge CLCLK or negedge HRESETN or negedge CLTrEn)
begin : p_CLLECheck
  if (!CLTrIntrTest)
    begin
      if (!HRESETN || !LEE || !CLTrEn)
        begin
          CLLEState = `ST_IDL;
          CLLECount = `LECOUNTSIZ'b0;
        end
      else if (CLLEState == `ST_IDL && CLLECheck)
        begin
          CLLEState = `ST_LED;
          CLLECount = `LECOUNTSIZ'b0;
        end
      else if (CLLEState == `ST_LED && CLLE)
        begin
          if((CLLECount != LED) && (LcdEn))
            begin
              $display($time," ERROR: IN LINE END DELAY : LED Value");
              `ERR_EXIT;
            end
          CLLEState = `ST_CLLE;
          CLLECount = `LECOUNTSIZ'b0;
        end
      else if (CLLEState == `ST_CLLE && !CLLE)
        begin
          if ((CLLECount != 3) && (LcdEn))
            begin
              $display($time," ERROR:CLLE NOT HIGH FOR 4 CYCLES");
              `ERR_EXIT;
            end
          CLLEState = `ST_IDL;
          CLLECount = `LECOUNTSIZ'b0;
        end
      else
        CLLECount = CLLECount + 1'b1;
    end
end
// -----------------------------------------------------------------------------
// Setting the CLLE check flag
// -----------------------------------------------------------------------------
always@(posedge CLCLK)
begin : p_ResetFlag
  if (!BCD)
    CLLEFlag = 0;
end
// -----------------------------------------------------------------------------
// Reseting the CLLE check flag
// ----------------------------------------------------------------------------
always@(posedge PCLK)
begin : p_SetFlag
  CLLEFlag = 1;
end
// -----------------------------------------------------------------------------
// CLAC TEST
// -----------------------------------------------------------------------------
always @(posedge CLCLK or negedge HRESETN or negedge CLTrEn)
begin : p_CLACCheck
  if (!CLTrIntrTest)
    begin
      if (!HRESETN || !LEE || !CLTrEn)
        begin
          CLACState = `ST_IDL;
          CLACCount = `ACCOUNTSIZ'b0;
        end
      else if (TFT)
        begin
          if (Active)
            begin
              if ((!AC) && (LcdEn))
                begin
                  $display($time," ERROR: TFT MODE CLAC LOW IN ACTIVE REGION");
                  `ERR_EXIT;
                end
            end
          else
            begin
              if ((AC) && (LcdEn))
                begin
                  $display($time," ERROR:TFT MODE CLAC HIGH IN NONACT REGION");
                  `ERR_EXIT;
                end
            end
        end
      else
        begin
          if (CLACState == `ST_IDL && AC)
            begin
              CLACState = `ST_CLACON;
              CLACCount = `ACCOUNTSIZ'b0;
            end
          else if (CLACState == `ST_CLACON && !AC)
            begin
              if ((CLACCount != CLACValue) && (LcdEn))
                begin
                  $display($time," ERROR: In STN MODE CLAC ON period", 
                                   " not equal to ACB VALUE ");
                  `ERR_EXIT;
                end
              CLACState = `ST_CLACOFF;
              CLACCount = `ACCOUNTSIZ'b0;
            end
          else if (CLACState == `ST_CLACOFF && AC)
            begin
              if ((CLACCount != CLACValue) && (LcdEn))
                begin
                  $display($time," ERROR: In STN MODE CLAC OFF period", 
                                          " not equal to ACB VALUE"); 
                  `ERR_EXIT;
                end
              CLACState = `ST_CLACON;
              CLACCount = `ACCOUNTSIZ'b0;
            end
          else
            CLACCount = CLACCount + 1'b1;
        end
    end
end

// -----------------------------------------------------------------------------
// CLTrBaseUpdate and Check Signal Generation
// -----------------------------------------------------------------------------
assign CLTrBaseUpdate = (VSYNCState == `ST_VSW);
assign Check = PCLK & Active & CLTrEn;

endmodule

// --================================== End ==================================--
