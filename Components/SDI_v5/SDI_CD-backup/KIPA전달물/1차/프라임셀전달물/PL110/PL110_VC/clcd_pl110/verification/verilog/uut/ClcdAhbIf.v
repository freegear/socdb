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
//  File Name              : ClcdAhbIf.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : Lcd Controller AHB interface module (Front end of 
//                           the data path)
//
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
// -----------------------------------------------------------------------------
 
module ClcdAhbIf (
// Inputs
        HCLK, 
        HRESETn, 
        HTRANSS, 
        HWRITES, 
        HSELCLCD, 
        HREADYINS, 
        HWDATAS,
        HADDRS, 
        HRESPM,
        HREADYINM, 
        HGRANTM, 
        HRDATAM,
        PalAHBRData,
        LcdEn,
        LcdBW,
        LcdTFT,
        LcdMono8,
        LcdDualLclk,
        BGR,
        BEBO,
        BEPO,
        LcdPwrEn,
        LcdBPP,
        LcdVComp,
        PPL,
        HSW,
        HFP,
        HBP,
        VSW,
        VBP,
        VFP,
        LPP,
        CPL,
        PCD,
        ACB,
        IVS,
        IHS,
        IPC,
        IEO,
        BCD,
        LED,
        LEE,
        Tim0WenLclkDel,
        Tim1WenLclkDel,
        Tim2WenLclkDel,
        Tim3WenLclkDel,
        ConlWenLclkDel,
        FrStSyncHclk,
        FrRstSyncHclk,
        VCStatSyncHclk,
        FRPIncSyncHclk,
        ITEN,
        IntraOP,
        PrimaryOP,
        Revision, 

// Outputs 
        HTRANSM, 
        HWRITEM, 
        HSIZEM,
        HBURSTM,
        HADDRM, 
        HPROT,
        HLOCK, 
        HRESPS,
        HBUSREQM, 
        HREADYOUTS, 
        CLCDCLKSELint, 
        HRDATAS,
        PalAHBWriteBn, 
        PalAHBAddr,
        FifoWData,
        UFWrPtr,
        LFWrPtr,
        UFifoWrEn,
        LFifoWrEn,
        CLCDMBEINTRint,
        CLCDFUFINTRint,
        CLCDLNBUINTRint,
        CLCDVCOMPINTRint,
        CLCDINTRint,
        AhbMError,
        FrameRstAck,
        LCDT0Wen,
        LCDT1Wen,
        LCDT2Wen,
        LCDT3Wen,
        LCDCWen,
        LCDTCRWen,
        LCDITOP1Wen,
        LCDITOP2Wen
       );

input           HCLK;             // AHB Clock
input           HRESETn;          // AHB Bus Reset signal - HCLK domain
input   [1:0]   HTRANSS;          // Transfer response signal for AHB Slave
input           HWRITES;          // Write signal for AHB Slave
input           HSELCLCD;         // Slave select signal
input           HREADYINS;        // Ready signal for AHB Slave
input   [31:0]  HWDATAS;          // Write data input for AHB Slave
input   [11:2]  HADDRS;           // Address bus for AHB slave
input   [1:0]   HRESPM;           // Slave response for AHB master
input           HREADYINM;        // Ready signal for AHB Master
input           HGRANTM;          // Bus grant from arbiter for AHB master
input   [31:0]  HRDATAM;          // Read data input for AHB Master
input   [31:0]  PalAHBRData;      // Palette RAM read data from port1
input           LcdEn;            // Lcd controller enable bit
input           LcdBW;            // enable black & white panel mode
input           LcdTFT;           // enable TFT panel mode
input           LcdMono8;         // enable 8-bit interface for mono LCD
input           LcdDualLclk;      // enable dual panel mode
input           BGR;              // Enable Blue and Red pixel swapping
input           BEBO;             // Enable big-endian byte ordering
input           BEPO;             // Enable big-endian pixel ordering
                                  // with in a byte
input           LcdPwrEn;         // enable Lcd panel power
input   [2:0]   LcdBPP;           // Number of bits per pixel
input   [1:0]   LcdVComp;         // vertical state compare value
input   [9:4]   PPL;              // Pixels per line
input   [7:0]   HSW;              // Horizontal sync width(number of CLCP)
input   [7:0]   HFP;              // Horizontal frontporch width(number of CLCP)
input   [7:0]   HBP;              // Horizontal backporch width(number of CLCP)
input   [5:0]   VSW;              // Vertical sync width(number Hsync pulse)
input   [7:0]   VFP;              // Vertical frontporch width
input   [7:0]   VBP;              // Vertical backporch width
input   [9:0]   LPP;              // number of active lines per panel
input   [9:0]   CPL;              // number of panel clocks per line
input   [9:0]   PCD;              // Panel clock divder value
input   [4:0]   ACB;              // number of lines to toggle AC bias
input           IVS;              // Invert vertical sync pulse
input           IHS;              // Invert vertical sync pulse
input           IPC;              // Invert horizontal sync pulse
input           IEO;              // Invert output enable for TFT 
input           BCD;              // bypass panel clock divider
input   [6:0]   LED;              // Line end delay value
input           LEE;              // enable line end signal generation
input           Tim0WenLclkDel;   // Registered Timing0 reg write enable signal
                                  // for re-synchronization
input           Tim1WenLclkDel;   // Registered Timing1 reg write enable signal
                                  // for re-synchronization
input           Tim2WenLclkDel;   // Registered Timing2 reg write enable signal
                                  // for re-synchronization
input           Tim3WenLclkDel;   // Registered Timing3 reg write enable signal
                                  // for re-synchronization
input           ConlWenLclkDel;   // Registered control reg write enable signal
                                  // for re-synchronization
input           FrStSyncHclk;     // Frame start signal synchronised to HCLK
                                  // domain
input           FrRstSyncHclk;    // Frame reset signal synchronised to HCLK 
                                  // domain
input           VCStatSyncHclk;   // Vertical compare status signal, HCLK 
                                  // synchronised
input           FRPIncSyncHclk;   // Upper-lower fifo read pointer increment 
                                  // enable HCLK synchronised
input           ITEN;             // Integration test enable CLCDTCR bit 0
input  [5:0]    IntraOP;          // Intra chip output signals for integration 
                                  // test reads
input  [29:0]   PrimaryOP;        // Primary output signals for integration 
                                  // test reads
input  [3:0]    Revision;         // Device revision designator

output  [1:0]   HTRANSM;          // Transfer response signal from AHB Master
output          HWRITEM;          // Write signal from AHB master
output  [2:0]   HSIZEM;           // Size of the data transfer from AHB Master
output  [2:0]   HBURSTM;          // size of the burst from AHB Master
output  [31:0]  HADDRM;           // Address from AHB Master
output  [3:0]   HPROT;            // Protection signal from AHB Master
output          HLOCK;            // Bus-lock signal from AHB Master
output  [1:0]   HRESPS;           // Slave response from AHB Slave
output          HBUSREQM;         // Bus request from AHB master
output          HREADYOUTS;       // Ready signal from AHB Slave
output          CLCDCLKSELint;    // LCLK Clock source select to Clock Mux
output  [31:0]  HRDATAS;          // Read out data from AHB Slave
output          PalAHBWriteBn;    // Palette RAM write enable - Port1(AHB side)
output  [9:0]   PalAHBAddr;       // Palette RAM address - Port1(AHB side)
output  [31:0]  FifoWData;        // input data for FIFO
output [`PTR_SIZE-1:0] UFWrPtr;   // Upper Fifo write address
output [`PTR_SIZE-1:0] LFWrPtr;   // Lower Fifo write address
output          UFifoWrEn;        // Upper Fifo write enable
output          LFifoWrEn;        // Lower Fifo write enable
output          CLCDMBEINTRint;   // AHB Error interrupt
output          CLCDFUFINTRint;   // LCD lower FIFO underflow interrupt
output          CLCDLNBUINTRint;  // LCD next base update interrupt
output          CLCDVCOMPINTRint; // LCD Vertical compare status interrupt
output          CLCDINTRint;      // combined interrupt of all interrupts
output          AhbMError;        // AHB master bus error interrupt
output          FrameRstAck;      // Acknowledge for FrameRst signal
output          LCDT0Wen;         // TimingReg0 write enable - HCLK domain
output          LCDT1Wen;         // TimingReg1 write enable - HCLK domain
output          LCDT2Wen;         // TimingReg3 write enable - HCLK domain
output          LCDT3Wen;         // TimingReg3 write enable - HCLK domain
output          LCDCWen;          // ControlReg write enable - HCLK domain
output          LCDTCRWen;        // Test control register write enable
output          LCDITOP1Wen;      // Integration Test Output register 1 write 
                                  // enable
output          LCDITOP2Wen;      // Integration Test Output register 2 write
                                  // enable


// -----------------------------------------------------------------------------
//
// Overview
// ========
//          It instantiates the following modules:
//
//          1. ClcdAhbSlaveIf  (AHB Slave interface)
//          2. ClcdAhbMasterIf (AHB Master interface)
//          3. ClcdDMAFifo     (DMA Fifo controller )
//          4. ClcdSyncHCLK    (Synchroniser)
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

wire UFDataValid;
// Upper fifo data valid wire from AHB master

wire LFDataValid;
// lower fifo data valid wire from AHB master

wire [1:0] UFWatermark;
// Upper fifo water mark level to AHB master

wire [1:0] LFWatermark;
// Lower fifo water mark level to AHB master

wire UFifoAck;
// Acknowledge upper fifo data valid to AHB master

wire LFifoAck;
// Acknowledge lower fifo data valid to AHB master

wire FifoUF;
// Upper-Lower fifo underflow status 

wire [31:2] LCDLPBASE;
// Base address of the lower panel frame buffer

wire [31:2] LCDUPBASE;
// Base address of the upper panel frame buffer

wire LcdDualHclk;
// Dual mode enable synchronised to HCLK domain

wire [31:2] LCDLPCURR;
// Current address of the lower panel buffer Index

wire [31:2] LCDUPCURR;
// Current address of the upper panel buffer Index

wire [23:0]PixelIndex;
// Pixel data from the unpacker

wire LNBU;
// Next base update status

wire WATERMARK;
// DMAFIFO watermark level select

wire ClrLNBU;
// Clear next base address update 

wire ClrAhbMasterErr;
// Clear Ahbmaster error Interrupt status

wire LowerDmaFlag;
// Indicates which DMA fifo write is active

wire [4:0] WordCount;
// number of words to be transferred to the DMA FIFO

// -----------------------------------------------------------------------------
// AHB Slave instantiation
// -----------------------------------------------------------------------------
ClcdAhbSlaveIf
  uClcdAhbSlaveIf (
                   .HCLK                (HCLK),
                   .HRESETn             (HRESETn),
                   .HTRANSS             (HTRANSS),
                   .HWRITES             (HWRITES),
                   .HSELCLCD            (HSELCLCD),
                   .HREADYINS           (HREADYINS),
                   .HWDATAS             (HWDATAS),
                   .HADDRS              (HADDRS),
                   .LCDUPCURR           (LCDUPCURR),
                   .LCDLPCURR           (LCDLPCURR),
                   .AhbMError           (AhbMError),
                   .PalAHBRData         (PalAHBRData),
                   .FifoUF              (FifoUF),
                   .Vcomp               (VCStatSyncHclk),
                   .LNBU                (LNBU),
                   .LcdEn               (LcdEn),
                   .LcdBPP              (LcdBPP),
                   .LcdBW               (LcdBW),
                   .LcdTFT              (LcdTFT),
                   .LcdMono8            (LcdMono8),
                   .LcdDualLclk         (LcdDualLclk),
                   .BGR                 (BGR),
                   .BEBO                (BEBO),
                   .BEPO                (BEPO),
                   .LcdPwrEn            (LcdPwrEn),
                   .LcdVComp            (LcdVComp),
                   .PPL                 (PPL),
                   .HSW                 (HSW),
                   .HFP                 (HFP),
                   .HBP                 (HBP),
                   .LPP                 (LPP),
                   .VSW                 (VSW),
                   .VFP                 (VFP),
                   .VBP                 (VBP),
                   .PCD                 (PCD),
                   .ACB                 (ACB),
                   .IVS                 (IVS),
                   .IHS                 (IHS),
                   .IPC                 (IPC),
                   .IEO                 (IEO),
                   .CPL                 (CPL),
                   .BCD                 (BCD),
                   .LED                 (LED),
                   .LEE                 (LEE),                         
                   .Tim0WenLclkDel      (Tim0WenLclkDel),
                   .Tim1WenLclkDel      (Tim1WenLclkDel),
                   .Tim2WenLclkDel      (Tim2WenLclkDel),
                   .Tim3WenLclkDel      (Tim3WenLclkDel),
                   .ConlWenLclkDel      (ConlWenLclkDel),
                   .ITEN                (ITEN),
                   .IntraOP             (IntraOP),
                   .PrimaryOP           (PrimaryOP),
                   .Revision            (Revision), 

                   .HRESPS              (HRESPS),
                   .HREADYOUTS          (HREADYOUTS),
                   .HRDATAS             (HRDATAS),
                   .ClrAhbMasterErr     (ClrAhbMasterErr),
                   .ClrLNBU             (ClrLNBU),
                   .LCDUPBASE           (LCDUPBASE),
                   .LCDLPBASE           (LCDLPBASE),
                   .PalAHBWriteBn       (PalAHBWriteBn),
                   .PalAHBAddr          (PalAHBAddr),
                   .CLCDMBERRINTRint    (CLCDMBEINTRint),
                   .CLCDFUFINTRint      (CLCDFUFINTRint),
                   .CLCDVCOMPINTRint    (CLCDVCOMPINTRint),
                   .CLCDLNBUINTRint     (CLCDLNBUINTRint),
                   .CLCDINTRint         (CLCDINTRint),
                   .CLCDCLKSELint       (CLCDCLKSELint),
                   .LcdDualHclk         (LcdDualHclk),
                   .WATERMARK           (WATERMARK),
                   .LCDT0Wen            (LCDT0Wen),
                   .LCDT1Wen            (LCDT1Wen),
                   .LCDT2Wen            (LCDT2Wen),
                   .LCDT3Wen            (LCDT3Wen),
                   .LCDCWen             (LCDCWen),
                   .LCDTCRWen           (LCDTCRWen),
                   .LCDITOP1Wen         (LCDITOP1Wen), 
                   .LCDITOP2Wen         (LCDITOP2Wen)
                  );

// -----------------------------------------------------------------------------
// AHB Master instantiation
// -----------------------------------------------------------------------------
 ClcdAhbMasterIf
   uClcdAhbMasterIf (
                     .HCLK            (HCLK),
                     .HRESETn         (HRESETn),
                     .HGRANTM         (HGRANTM),
                     .HRESPM          (HRESPM),
                     .HREADYINM       (HREADYINM),
                     .HRDATAM         (HRDATAM),
                     .LCDLPBASE       (LCDLPBASE),
                     .LCDUPBASE       (LCDUPBASE),
                     .ClrAhbMasterErr (ClrAhbMasterErr),
                     .ClrLNBU         (ClrLNBU),
                     .LcdDual         (LcdDualHclk),
                     .UFWatermark     (UFWatermark),
                     .LFWatermark     (LFWatermark),
                     .FrameRst        (FrRstSyncHclk),
                     .FrameStart      (FrStSyncHclk),
                     .LFifoAck        (LFifoAck),
                     .UFifoAck        (UFifoAck),
                     
                     .HWRITEM         (HWRITEM),
                     .HSIZEM          (HSIZEM),
                     .HBURSTM         (HBURSTM),
                     .HADDRM          (HADDRM),
                     .HTRANSM         (HTRANSM),
                     .HPROTM          (HPROT),
                     .HLOCKM          (HLOCK),
                     .HBUSREQM        (HBUSREQM),
                     .LCDLPCURR       (LCDLPCURR),
                     .LCDUPCURR       (LCDUPCURR),
                     .AhbMError       (AhbMError),
                     .LNBU            (LNBU),
                     .UFDataValid     (UFDataValid),
                     .LFDataValid     (LFDataValid),
                     .FifoWData       (FifoWData),
                     .LowerDmaFlag    (LowerDmaFlag),
                     .WordCount       (WordCount),
                     .FrameRstAck     (FrameRstAck)
                     );


// -----------------------------------------------------------------------------
// DMA FIfo Controller module instantiation
// -----------------------------------------------------------------------------

ClcdDMAFifo uClcdDMAFifo (
                          .HCLK              (HCLK),
                          .HRESETn           (HRESETn),
                          .FrRstSyncHclk     (FrRstSyncHclk),
                          .FrStSyncHclk      (FrStSyncHclk),
                          .LcdDual           (LcdDualHclk),
                          .WATERMARK         (WATERMARK),
                          .UFDataValid       (UFDataValid),
                          .LFDataValid       (LFDataValid),
                          .LowerDmaFlag      (LowerDmaFlag),
                          .WordCount         (WordCount),
                          .FRPIncSyncHclk    (FRPIncSyncHclk),
                          
                          .UFWatermark       (UFWatermark),
                          .LFWatermark       (LFWatermark),
                          .UFifoAck          (UFifoAck),
                          .LFifoAck          (LFifoAck),
                          .UFWrPtr           (UFWrPtr),
                          .LFWrPtr           (LFWrPtr),
                          .UFifoWrEn         (UFifoWrEn),
                          .LFifoWrEn         (LFifoWrEn),
                          .DMAFifoUF         (FifoUF)
                         );

endmodule

// --================================== End ==================================--
