// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdMain.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : Lcd Panel Interface module
// --=========================================================================--

`timescale 1ns/1ps

// ----------------------------------------------------------------------------

module ClcdMain (
                // Inputs

                   CLCDCLK, 
                   nCLCDCLK,
                   nCLCLKRESET, 
                   PixelRed, 
                   PixelGreen, 
                   PixelBlue,
                   LcdEn, 
                   LcdDual,
                   LcdPwrEn,
                   PixelAvail,
                   HFP, 
                   HBP, 
                   HSW, 
                   CPL, 
                   PPL, 
                   ACB,
                   VSW, 
                   VFP, 
                   VBP, 
                   LPS, 
                   IVS, 
                   IHS, 
                   IEO, 
                   LcdTFT,
                   BCD, 
                   PCD, 
                   LcdBW, 
                   Mono8Bit,
                   LED,
                   LEE,
                   LcdVComp,
                   FrRstAckSyncLclk,
                   VCompAckSyncLclk,
                   AhbMBESyncLclk,

                // Outputs

                   Toggle,
                   PixelEn,
                   LcdCP, 
                   CLLPint, 
                   CLFPint, 
                   CLACint, 
                   CLLEint,
                   CLPOWERint,
                   PalLcdCSB2,
                   UnpackEn,
                   UpSTNData,
                   LpSTNData,
                   FrameStart,
                   FrameRst,
                   VCompStat, 
                   TFTPDEn
                 ); 

input       CLCDCLK;          // Clock input
input       nCLCDCLK;         // inverted Clock input
input       nCLCLKRESET;      // System Reset
input       LcdPwrEn;         // Lcd Panel power enable bit
input [9:4] PPL;              // number of pixels per line
input [9:0] PCD;              // Panel clock divider
input [7:0] HFP;              // Horizontal front porch value
input [7:0] HBP;              // Horizontal back porch value
input [7:0] HSW;              // Horizontal sync width value
input [9:0] CPL;              // LcdCP clocks per line
input [5:0] VSW;              // Vertical sync width value
input [7:0] VFP;              // Vertical front porch value
input [7:0] VBP;              // Vertical back porch value
input [9:0] LPS;              // Lines per screen value
input       IVS;              // Invert vertical sync
input       IHS;              // Invert horizontal sync
input       IEO;              // Invert output enable for TFT
input       LEE;              // Enable Line-End signal generation
input [6:0] LED;              // Line-End signal delay value
input       LcdEn;            // Lcd Controller enable bit
input       LcdDual;          // Dual mode enable
input       LcdBW;            // Lcd is black and white
input       Mono8Bit;         // 8-bit panel interface
input [1:0] LcdVComp;         // Vertical compare interrupt value
input [4:0] ACB;              // Number of lines between toggling ACBias pin
input       FrRstAckSyncLclk; // Frame reset acknowldge from AHB Master
input       VCompAckSyncLclk; // Vertical compare interrupt acknowledge
input       LcdTFT;           // TFT mode - some different behaviour
input       BCD;              // Bypass Panel clock divider - pixel every clock
input       AhbMBESyncLclk;   // Error interrupt from AHB master.
input       PixelAvail;       // Pixel valid from palettiser
input [3:0] PixelRed;         // Palettised pixel data - Red
input [3:0] PixelGreen;       // Palettised pixel data - Green
input [3:0] PixelBlue;        // Palettised pixel data - Blue
 
output       CLLPint;         // Line pulse signal to LCD Panel
output       CLFPint;         // Frame pulse signal to LCD Panel
output       CLACint;         // ACBias signal to LCD Panel
output       CLLEint;         // Line-End signal
output       LcdCP;           // Panel clock output
output       CLPOWERint;      // LCD Panel power
output       PixelEn;         // Pixel Enable to the Unpacker/FIFO
output       Toggle;          // Dual Mode Toggle bit to UnPacker
output       FrameStart;      // Start DMA request
output       FrameRst;        // Stop DMA & flush pipeline
output       VCompStat;       // Vertical compare interrupt
output       PalLcdCSB2;      // Palette Ram port2 Chip select
output       UnpackEn;        // Enable for unpacker state machine
output       TFTPDEn;         // Enable for TFT panel data
output [7:0] UpSTNData;       // Upper panel STN data
output [7:0] LpSTNData;       // Lower panel STN data



// -----------------------------------------------------------------------------
//
// Overview
// ========
//            This module instantiates: 
//                             1. ClcdGS      (Greyscaler)
//                             2. ClcdFormat  (output formatter)
//                             3. ClcdTiming  (Timing generator)
//                             4. ClcdCPGen   (Panel Clock generator)
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
 
wire                  CLCDCLK;
// Clock input                                        (Module input)

wire                  nCLCDCLK;
// Clock input                                        (Module input)

wire                  nCLCLKRESET;
// System Reset                                       (Module input)

wire                  LcdPwrEn;
// Lcd Panel power enable bit                         (Module input)

wire  [7:0]           HFP;
// Horizontal front porch value                       (Module input)

wire  [7:0]           HBP;
// Horizontal back porch value                        (Module input)

wire  [7:0]           HSW;
// Horizontal sync width value                        (Module input)

wire  [9:0]           CPL;
// LcdCP clocks per line                              (Module input)

wire  [5:0]           VSW;
// Vertical sync width value                          (Module input)

wire  [7:0]           VFP;
// Vertical front porch value                         (Module input)

wire  [7:0]           VBP;
// Vertical back porch value                          (Module input)

wire  [9:0]           LPS;
// Lines per screen value                             (Module input)

wire                  IVS;
// Invert vertical sync                               (Module input)

wire                  IHS;
// Invert horizontal sync                             (Module input)

wire                  IEO;
// Invert output enable for TFT                       (Module input)

wire                  LEE;
// Enable Line-End signal generation                  (Module input)

wire  [6:0]           LED;
// Line-End signal Delay value                        (Module input)

wire                  LcdEn;
// Lcd Controller enable bit                          (Module input)

wire                  LcdDual;
// Enable dual mode                                   (Module input)

wire  [1:0]           LcdVComp;
// Vertical compare interrupt value                   (Module input)

wire  [4:0]           ACB;
// Number of lines between toggling ACBias pin        (Module input)

wire                  FrRstAckSyncLclk;
// Frame reset DMA  acknowldge                        (Module input)

wire                  VCompAckSyncLclk;
// Vertical compare interrupt acknowledge             (Module input)

wire                  LcdTFT;
// TFT mode - some different behaviour                (Module input)

wire                  BCD;
// Bypass Clock Divider - pixel every clock           (Module input)

wire                  AhbMBESyncLclk;
// Error interrupt from AHB master                    (Module input)

wire                  PixelAvail;
// Pixel valid from palettiser                        (Module input)

wire  [3:0]           PixelRed;
// Palettised pixel data - Red                        (Module input)

wire  [3:0]           PixelGreen;
// Palettised pixel data - Green                      (Module input)

wire  [3:0]           PixelBlue;
// Palettised pixel data - Blue                       (Module input)

wire                  NullPC;
// count CLCDCLKs, produce NextRising but not LcdCP

wire                  FifoEn;
// Fifo read (passive) or enable (TFT)          

wire                  StartRow;
// Start of active line from timing module          

wire                  PCEn;
// clock divider stop & start

wire                  NextRising;
// rising edge on next clock to timing module

wire                  UpFormFifoFull;
// Upper panel Out Fifo Full                        

wire                   LpFormFifoFull;
//Lower panel Out Fifo Full                         

wire                  UpRGS;
//Upper panel greyscaled pixel out - Red

wire                  UpGGS;
//Upper panel greyscaled pixel out - Green

wire                  UpBGS;
//Upper panel greyscaled pixel out - Blue

wire                  LpRGS;
//Lower panel greyscaled pixel out - Red

wire                  LpGGS;
// Lower panel greyscaled pixel out - Green

wire                  LpBGS;
//Lower panel greyscaled pixel out - Blue

wire                  UpPixelEn;
// Pixel Enable to Upper Panel Formater

wire                  LpPixelEn;
// Pixel Enable to Lower Panel Formater

wire                  EndFrame;  
// End frame from timing module

wire                  LFifoEn;
// Read enable for Lower FIFO

// -----------------------------------------------------------------------------
// Greyscaler instantiation
// -----------------------------------------------------------------------------

ClcdGS uClcdGS (
                .CLCDCLK        (CLCDCLK),
                .nCLCLKRESET    (nCLCLKRESET),
                .PixelRed       (PixelRed),
                .PixelGreen     (PixelGreen),
                .PixelBlue      (PixelBlue),
                .LcdEn          (LcdEn),
                .LcdTFT         (LcdTFT),
                .FifoEn         (FifoEn),
                .PixelAvail     (PixelAvail),
                .StartRow       (StartRow),
                .LcdDual        (LcdDual),
                .EndFrame       (EndFrame),
                .PPL            (PPL),
                .UpFormFifoFull (UpFormFifoFull),
                .LpFormFifoFull (LpFormFifoFull),
                .AhbMBESyncLclk (AhbMBESyncLclk),
              
                .Toggle         (Toggle),
                .PixelEn        (PixelEn),
                .UpRGS          (UpRGS),
                .UpGGS          (UpGGS),
                .UpBGS          (UpBGS),
                .LpRGS          (LpRGS),
                .LpGGS          (LpGGS),
                .LpBGS          (LpBGS),
                .UpPixelEn      (UpPixelEn),
                .LpPixelEn      (LpPixelEn)
               );

// -----------------------------------------------------------------------------
// Output formatter instantiation
// Upper Panel Formatter
// -----------------------------------------------------------------------------
ClcdFormat uClcdFormat1 (
                         .CLCDCLK        (CLCDCLK),
                         .nCLCLKRESET    (nCLCLKRESET),
                         .LcdBW          (LcdBW),
                         .Mono8Bit       (Mono8Bit), 
                         .LcdTFT         (LcdTFT),
                         .PixelEn        (UpPixelEn),
                         .FifoRead       (FifoEn),
                         .AhbMBESyncLclk (AhbMBESyncLclk),
                         .RGS            (UpRGS),
                         .GGS            (UpGGS),
                         .BGS            (UpBGS),
                         
                         .STNDout        (UpSTNData),
                         .FormFifoFull   (UpFormFifoFull)
                        );

// -----------------------------------------------------------------------------
// Output formatter Instanciation
// Lower Panel Formatter
// -----------------------------------------------------------------------------
// Enable lower panel FIFO only when LcdDual= 1
assign LFifoEn  = FifoEn & LcdDual;

ClcdFormat uClcdFormat2 (
                         .CLCDCLK        (CLCDCLK),
                         .nCLCLKRESET    (nCLCLKRESET),
                         .LcdBW          (LcdBW),
                         .Mono8Bit       (Mono8Bit),
                         .LcdTFT         (LcdTFT),
                         .PixelEn        (LpPixelEn),
                         .FifoRead       (LFifoEn),
                         .AhbMBESyncLclk (AhbMBESyncLclk),
                         .RGS            (LpRGS),
                         .GGS            (LpGGS),
                         .BGS            (LpBGS),
                         
                         .STNDout        (LpSTNData),
                         .FormFifoFull   (LpFormFifoFull)
                        );

// -----------------------------------------------------------------------------
// Panel clock generator instantiation
// -----------------------------------------------------------------------------

ClcdCPGen uClcdCPGen (
                        .CLCDCLK      (CLCDCLK),
                        .nCLCDCLK     (nCLCDCLK),
                        .nCLCLKRESET  (nCLCLKRESET),
                        .PCD          (PCD),
                        .NullPC       (NullPC),
                        .PCEn         (PCEn),
                      
                        .LcdCP        (LcdCP),  
                        .NextRising   (NextRising)
                     );


// -----------------------------------------------------------------------------
// Timing generator instantiation
// -----------------------------------------------------------------------------

ClcdTiming uClcdTiming (
                        .CLCDCLK          (CLCDCLK), 
                        .nCLCLKRESET      (nCLCLKRESET),
                        .HFP              (HFP),
                        .HBP              (HBP),
                        .HSW              (HSW), 
                        .CPL              (CPL), 
                        .VSW              (VSW), 
                        .VFP              (VFP),
                        .VBP              (VBP), 
                        .LPS              (LPS), 
                        .IVS              (IVS), 
                        .IHS              (IHS),
                        .IEO              (IEO), 
                        .LcdTFT           (LcdTFT), 
                        .BCD              (BCD),
                        .LEEn             (LEE),
                        .LEDel            (LED),
                        .LcdPwrEn         (LcdPwrEn),
                        .LcdEn            (LcdEn),
                        .LcdVComp         (LcdVComp), 
                        .ACB              (ACB),
                        .AhbMBESyncLclk   (AhbMBESyncLclk),
                        .FrRstAckSyncLclk (FrRstAckSyncLclk),
                        .VCompAckSyncLclk (VCompAckSyncLclk),
                        .NextRising       (NextRising),

                        .EndFrame         (EndFrame),
                        .PCEn             (PCEn),
                        .FifoEn           (FifoEn),     
                        .CLLPint          (CLLPint),
                        .CLFPint          (CLFPint),
                        .CLACint          (CLACint),
                        .CLLEint          (CLLEint),
                        .CLPOWERint       (CLPOWERint),
                        .StartRow         (StartRow),   
                        .FrameStart       (FrameStart),
                        .FrameRst         (FrameRst),
                        .VCompStat        (VCompStat),
                        .PalLcdCSB2       (PalLcdCSB2),
                        .UnpackEn         (UnpackEn),
                        .NullPC           (NullPC),
                        .TFTPDEn           (TFTPDEn)
                           );
                        
endmodule 
// --=========================================================================--
  
