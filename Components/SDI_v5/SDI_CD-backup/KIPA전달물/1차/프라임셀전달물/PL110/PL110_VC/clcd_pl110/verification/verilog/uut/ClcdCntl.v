//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//-----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdCntl.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//------------------------------------------------------------------------------
//  Purpose                : Top level module of Colour LCD Controller.
//============================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
//  ----------------------------------------------------------------------------

module ClcdCntl (
                         // inputs
                          HCLK,
                          CLCDCLK,
                          nCLCDCLK,
                          HRESETn,
                          nCLCLKRESET,
                          HSELCLCD,
                          HADDRS,
                          HTRANSS,
                          HWRITES,
                          HREADYINS,
                          HWDATAS,
                          HREADYINM,
                          HRESPM,
                          HGRANTM,
                          HRDATAM,
                          PalAHBRData,
                          PalLcdRData,
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
                          PalLcdAddr,
                          PalLcdCSB2,
                          CLPOWERint,
                          CLLPint,
                          CLCPint,
                          CLFPint,
                          CLACint,
                          CLDint,
                          CLLEint,
                          CLCDMBEINTRint,
                          CLCDFUFINTRint,
                          CLCDLNBUINTRint,
                          CLCDVCOMPINTRint,
                          CLCDINTRint,
                          LCDTCRWen,
                          LCDITOP1Wen,
                          LCDITOP2Wen
                 );


input           HCLK;             // AHB Clock
input           CLCDCLK;          // LCD Controller Clock input 
input           nCLCDCLK;         // LCD Controller Clock input (inverted)
input           HRESETn;          // AHB Bus Reset signal - HCLK domain
input           nCLCLKRESET;      // Reset signal - CLCDCLK domain
input           HSELCLCD;         // Slave select signal
input   [11:2]  HADDRS;           // Address bus for AHB slave
input   [1:0]   HTRANSS;          // Transfer response signal for AHB Slave
input           HWRITES;          // Write signal for AHB Slave
input           HREADYINS;        // Ready signal for AHB Slave
input   [31:0]  HWDATAS;          // Write data input for AHB Slave
input   [1:0]   HRESPM;           // Slave response for AHB master
input           HREADYINM;        // Ready signal for AHB Master
input           HGRANTM;          // Bus grant signal from arbiter for
                                  // AHB master
input   [31:0]  HRDATAM;          // Read data input for AHB Master
input   [31:0]  PalAHBRData;      // Palette RAM read data from port1
input   [31:0]  PalLcdRData;      // Palette RAM read data from port2
input           ITEN;             // Integration test enable CLCDTCR bit 0
input   [5:0]   IntraOP;          // Intra chip output signals for integration 
                                  // test reads
input   [29:0]  PrimaryOP;        // Primary output signals for integration 
                                  // test reads
input   [3:0]   Revision;         // Device revision designator

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
output  [6:0]   PalAHBAddr;       // Palette RAM address - Port1(AHB side)
output  [6:0]   PalLcdAddr;       // Palette RAM address - Port2(Lcd side)
output          PalLcdCSB2;       // Palette RAM chip select - Port2(Lcd side)
output          CLPOWERint;       // LCD panel power enable
output          CLLPint;          // LCD Line pulse(STN)/Hsync pulse(TFT)
output          CLCPint;          // LCD Panel clock
output          CLFPint;          // LCD Frame pulse(STN)/Vsync pulse(TFT)
output          CLACint;          // LCD panel AC bias(STN)/ Data enable(TFT)
output  [23:0]  CLDint;           // LCD panel data out
output          CLLEint;          // Line end signal
output          CLCDMBEINTRint;   // AHB Error interrupt
output          CLCDFUFINTRint;   // LCD FIFO underflow interrupt
output          CLCDLNBUINTRint;  // LCD next base update interrupt
output          CLCDVCOMPINTRint; // LCD Vertical compare status interrupt
output          CLCDINTRint;      // combined interrupt of all interrupts
output          LCDTCRWen;        // Test control register write enable
output          LCDITOP1Wen;      // Integration Test Output register 1 write 
                                  // enable
output          LCDITOP2Wen;      // Integration Test Output register 2 write
                                  // enable

// -----------------------------------------------------------------------------
// Wire declaration
// -----------------------------------------------------------------------------

wire FRPInc ;
// Upper-lower fifo read pointer increment

wire LcdEn;
// Lcd controller enable bit

wire LcdBW;
// enable black & white panel mode

wire LcdTFT;
// enable TFT panel mode

wire LcdMono8;
// enable 8-bit interface for black & white panel

wire LcdDualLclk;
// enable dual panel mode

wire LcdPwrEn;
// enable Lcd panel power

wire [1:0] LcdVComp;
// vertical state compare value

wire [2:0] LcdBPP;
// Number of bits per pixel

wire[9:4]  PPL;
// Pixels per line

wire [7:0] HSW;
// Horizontal sync width(number of CLCP)

wire [7:0] HFP;
// Horizontal frontporch width(number of CLCP)

wire [7:0] HBP;
// Horizontal backporch width(number of CLCP)

wire [5:0] VSW;
// Vertical sync width(number Hsync pulse)

wire [7:0] VFP;
// Vertical frontporch width(number Hsync pulse)

wire [7:0] VBP;
// Vertical backporch width(number Hsync pulse)

wire [9:0] LPP;
// number of active lines per panel

wire [9:0] CPL;
// number of panel clocks per line

wire [9:0] PCD;
// Panel clock divder value

wire [4:0] ACB;
// number of lines to toggle AC bias

wire IVS;
// Invert vertical sync pulse

wire IHS;
// Invert vertical sync pulse

wire IPC;
// Invert horizontal sync pulse

wire IEO;
// Invert output enable for TFT

wire BCD;
// bypass panel clock divider

wire [6:0] LED;
// Line end delay value

wire LEE;
// enable line end wire generation

wire FrRstAckSyncLclk;
// Acknowledge Frame reset

wire VCStaAckSyncLclk;
// Acknowledge VCompStat

wire AhbMBESyncLclk;
// AHB master error interrupt

wire UFifoWrEn;
// Upper Fifo write enable

wire LFifoWrEn;
// Lower Fifo write enable

wire [`PTR_SIZE-1:0] UFWrPtr;
// Upper Fifo write address

wire [`PTR_SIZE-1:0] LFWrPtr;
// Lower Fifo write address

wire [`PTR_SIZE-1:0] FRdPtr;
// Upper Fifo read address

wire [31:0] FifoWData;
// Fifo REG/RAM write data

wire [7:0] PixelRed;
// Red pixel data out

wire [7:0] PixelGreen;
// Green pixel data out

wire [7:0] PixelBlue;
// Blue pixel data out

wire Brightbit;
// Intensity bit

wire [7:0] UpSTNData;
// upper panel STN data

wire [7:0] LpSTNData;
// Lower panel STN data

wire [63:0] FifoRData;
// output data from the Fifo REG/RAM corresponding to the read pointer

wire [9:0] IntPalAHBAddr;
// Palette RAM/TPRAM address - Port1(AHB side)

wire FrameStart;
// Frame Start

wire FrameRst;
// Frame Reset

wire VCompStat;
// Vertical Compare Status

wire PixelEn;
// Pixel Enable

wire Toggle;
//  Toggle

wire UnpackEn;
//  Unpacker Enable

wire LcdCP;
// LCD Clock Pulse

wire PixelAvail;
// Pixel Available

wire TFTPDEn;
// TFT Panel Data Enable

wire iCLPOWERint;
// Internal Copy of CLPOWERint

wire iPalLcdCSB2;
// Internal copy of PalLcdCSB2

wire BGR;
// Enable Blue and Red pixel swapping

wire BEBO;
// Select B/W big or small Endian byte order

wire BEPO;
// Select B/W big or small Endian pixel order

wire Tim0WenLclkDel;
// Registered Timing0 reg write enable wire for re-synchronization

wire Tim1WenLclkDel;
// Registered Timing1 reg write enable wire for re-synchronization

wire Tim2WenLclkDel;
// Registered Timing2 reg write enable wire for re-synchronization

wire Tim3WenLclkDel;
// Registered Timing3 reg write enable wire for re-synchronization

wire ConlWenLclkDel;
// Registered control reg write enable wire for re-synchronization

wire FrStSyncHclk;
// Frame start wire synchronised to HCLK domain

wire FrRstSyncHclk;
// Frame reset wire synchronised to HCLK domain

wire VCStatSyncHclk;
// Vertical compare status wire, HCLK synchronised

wire FRPIncSyncHclk;
// Upper-lower fifo read pointer increment enable HCLK synchronised

wire AhbMError;
// AHB master bus error interrupt

wire FrameRstAck;
// Acknowledge for FrameRst wire

wire LCDT0Wen;
// TimingReg0 write enable - HCLK domain

wire LCDT1Wen;
// TimingReg1 write enable - HCLK domain

wire LCDT2Wen;
// TimingReg2 write enable - HCLK domain

wire LCDT3Wen;
// TimingReg3 write enable - HCLK domain

wire LCDCWen;
// ControlReg write enable - HCLK domain

// -----------------------------------------------------------------------------
//
// Overview
// ========
//          It instantiates:
//          1. ClcdAhbIf (contains AHB interface,input FIFO,Unpacker
//             and Palettiser).
//          2. ClcdDmaFRegWrap (DMA fifo wrapper contains Fifo REG/TPRAMs) 
//          3. ClcdSyncHCLK (Synchronisers for signals passing into the HCLK
//             domain).
//          4. ClcdSerialiser (contains the Unpacker and the Palette
//             Control blocks).
//          5. ClcdMain (contains Greyscaler,Timing generator,Panel clock
//             generator, output Formatter and output FIFO).
//          6. ClcdSyncCLCDCLK (Synchronisers for signals passing into the 
//             CLCDCLK domain).
//          7. ClcdOutMux (Output panel data and clock MUX)
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Palette RAM ahb address. Only bit 6:0 is needed.
// -----------------------------------------------------------------------------
assign PalAHBAddr = IntPalAHBAddr[6:0];

// -----------------------------------------------------------------------------
// AHB Interface instantiation
// -----------------------------------------------------------------------------
ClcdAhbIf uClcdAhbIf (
          .HCLK               (HCLK),
          .HRESETn            (HRESETn),
          .HTRANSS            (HTRANSS),
          .HWRITES            (HWRITES),
          .HSELCLCD           (HSELCLCD),
          .HREADYINS          (HREADYINS),
          .HWDATAS            (HWDATAS),
          .HADDRS             (HADDRS),
          .HRESPM             (HRESPM),
          .HREADYINM          (HREADYINM),
          .HGRANTM            (HGRANTM),
          .HRDATAM            (HRDATAM),
          .PalAHBRData        (PalAHBRData),
          .LcdEn              (LcdEn),
          .LcdBW              (LcdBW),
          .LcdTFT             (LcdTFT),
          .LcdMono8           (LcdMono8),
          .LcdDualLclk        (LcdDualLclk),
          .BGR                (BGR),
          .BEBO               (BEBO),
          .BEPO               (BEPO),
          .LcdPwrEn           (LcdPwrEn),
          .LcdBPP             (LcdBPP),
          .LcdVComp           (LcdVComp),
          .PPL                (PPL),
          .HSW                (HSW),
          .HFP                (HFP),
          .HBP                (HBP),
          .VSW                (VSW),
          .VBP                (VBP),
          .VFP                (VFP),
          .LPP                (LPP),
          .CPL                (CPL),
          .PCD                (PCD),
          .ACB                (ACB),
          .IVS                (IVS),
          .IHS                (IHS),
          .IPC                (IPC),
          .IEO                (IEO),
          .BCD                (BCD),
          .LED                (LED),
          .LEE                (LEE),
          .Tim0WenLclkDel     (Tim0WenLclkDel),
          .Tim1WenLclkDel     (Tim1WenLclkDel),
          .Tim2WenLclkDel     (Tim2WenLclkDel),
          .Tim3WenLclkDel     (Tim3WenLclkDel),
          .ConlWenLclkDel     (ConlWenLclkDel),
          .FrStSyncHclk       (FrStSyncHclk),
          .FrRstSyncHclk      (FrRstSyncHclk),
          .VCStatSyncHclk     (VCStatSyncHclk),
          .FRPIncSyncHclk     (FRPIncSyncHclk),
          .ITEN               (ITEN),
          .IntraOP            (IntraOP),
          .PrimaryOP          (PrimaryOP),
          .Revision           (Revision), 

          .HTRANSM            (HTRANSM),
          .HWRITEM            (HWRITEM),
          .HSIZEM             (HSIZEM),
          .HBURSTM            (HBURSTM),
          .HADDRM             (HADDRM),
          .HPROT              (HPROT),
          .HLOCK              (HLOCK),
          .HRESPS             (HRESPS),
          .HBUSREQM           (HBUSREQM),
          .HREADYOUTS         (HREADYOUTS),
          .CLCDCLKSELint      (CLCDCLKSELint),
          .HRDATAS            (HRDATAS),
          .PalAHBWriteBn      (PalAHBWriteBn),
          .PalAHBAddr         (IntPalAHBAddr),
          .FifoWData          (FifoWData),
          .UFWrPtr            (UFWrPtr),
          .LFWrPtr            (LFWrPtr),
          .UFifoWrEn          (UFifoWrEn),
          .LFifoWrEn          (LFifoWrEn),
          .CLCDMBEINTRint     (CLCDMBEINTRint),
          .CLCDFUFINTRint     (CLCDFUFINTRint),
          .CLCDLNBUINTRint    (CLCDLNBUINTRint),
          .CLCDVCOMPINTRint   (CLCDVCOMPINTRint),
          .CLCDINTRint        (CLCDINTRint),
          .AhbMError          (AhbMError),
          .FrameRstAck        (FrameRstAck),
          .LCDT0Wen           (LCDT0Wen),
          .LCDT1Wen           (LCDT1Wen),
          .LCDT2Wen           (LCDT2Wen),
          .LCDT3Wen           (LCDT3Wen),
          .LCDCWen            (LCDCWen),
          .LCDTCRWen          (LCDTCRWen),
          .LCDITOP1Wen        (LCDITOP1Wen),
          .LCDITOP2Wen        (LCDITOP2Wen)
                  );

// -----------------------------------------------------------------------------
// Instantiation of DMA FIFO RAM wrapper - contains register based FIFO
// Use the following code for synthesisable register based FIFO (default)
// or comment out if complied ram cell is to be used.
// -----------------------------------------------------------------------------
ClcdDmaFRegWrap uClcdDmaFWrap (
                 .HCLK             (HCLK),
                 .UFifoWrEn        (UFifoWrEn),
                 .LFifoWrEn        (LFifoWrEn),
                 .UFWrPtr          (UFWrPtr),
                 .LFWrPtr          (LFWrPtr),
                 .FRdPtr           (FRdPtr),
                 .FifoWData        (FifoWData),
                         
                 .FifoRData        (FifoRData)
                  );

// -----------------------------------------------------------------------------
// Instantiation of DMA FIFO RAM wrapper - contains generated ram based FIFO
// Use the following code for a compiled ram cell or comment out if a 
// synthesisable register based FIFO (default) is to be used.
// -----------------------------------------------------------------------------
//ClcdDmaFRamWrap
//       uClcdDmaFWrap ( 
//          .HCLK             (HCLK),
//          .UFifoWrEn        (UFifoWrEn),
//          .LFifoWrEn        (LFifoWrEn),
//          .UFWrPtr          (UFWrPtr),
//          .LFWrPtr          (LFWrPtr),
//          .LcdFifoRamREB    (PalLcdCSB2),
//          .FRdPtr           (FRdPtr),
//          .FifoWData        (FifoWData),
//
//          .FifoRData        (FifoRData)
//                      );

// -----------------------------------------------------------------------------
// Synchroniser-HCLK module instantiation
// -----------------------------------------------------------------------------
 ClcdSyncHCLK 
       uClcdSyncHCLK (
          .HCLK               (HCLK),
          .HRESETn            (HRESETn),
          .FrameStart         (FrameStart),
          .FrameRst           (FrameRst),
          .VCompStat          (VCompStat),
          .FRPInc             (FRPInc),
          
          .FrStSyncHclk       (FrStSyncHclk),
          .FrRstSyncHclk      (FrRstSyncHclk),
          .VCStatSyncHclk     (VCStatSyncHclk),
          .FRPIncSyncHclk     (FRPIncSyncHclk)
          );

// -----------------------------------------------------------------------------
// Serialiser instantiation
// -----------------------------------------------------------------------------
 ClcdSerialiser
       uClcdSerialiser (
          .CLCDCLK             (CLCDCLK), 
          .nCLCLKRESET         (nCLCLKRESET), 
          .FrameRst            (FrameRst), 
          .FifoRData           (FifoRData), 
          .LcdBPP              (LcdBPP),
          .LcdDualLclk         (LcdDualLclk),
          .BGR                 (BGR),
          .BEBO                (BEBO),
          .BEPO                (BEPO),
          .PixelEn             (PixelEn), 
          .Toggle              (Toggle), 
          .UnpackEn            (UnpackEn), 
          .PalLcdRData         (PalLcdRData),
       
          .PalLcdAddr          (PalLcdAddr),
          .FRdPtr              (FRdPtr),
          .FRPInc              (FRPInc),
          .PixelValid          (PixelAvail),
          .PixelRed            (PixelRed),
          .PixelGreen          (PixelGreen),
          .PixelBlue           (PixelBlue),
          .Brightbit           (Brightbit)
          );


// -----------------------------------------------------------------------------
// Lcd Interface instantiation
// -----------------------------------------------------------------------------
ClcdMain uClcdMain (
                    .CLCDCLK          (CLCDCLK),
                    .nCLCDCLK         (nCLCDCLK),
                    .nCLCLKRESET      (nCLCLKRESET),
                    .PixelRed         (PixelRed[4:1]),
                    .PixelGreen       (PixelGreen[4:1]),
                    .PixelBlue        (PixelBlue[4:1]),
                    .LcdEn            (LcdEn),
                    .LcdDual          (LcdDualLclk),
                    .LcdPwrEn         (LcdPwrEn),
                    .PixelAvail       (PixelAvail),
                    .HFP              (HFP),
                    .HBP              (HBP),
                    .HSW              (HSW),
                    .CPL              (CPL),
                    .PPL              (PPL),
                    .ACB              (ACB),
                    .VSW              (VSW),
                    .VFP              (VFP),
                    .VBP              (VBP),
                    .LPS              (LPP),
                    .IVS              (IVS),
                    .IHS              (IHS),
                    .IEO              (IEO),
                    .LcdTFT           (LcdTFT),
                    .BCD              (BCD),
                    .PCD              (PCD),
                    .LcdBW            (LcdBW),
                    .Mono8Bit         (LcdMono8),
                    .LED              (LED),
                    .LEE              (LEE),
                    .LcdVComp         (LcdVComp),
                    .FrRstAckSyncLclk (FrRstAckSyncLclk),
                    .VCompAckSyncLclk (VCStaAckSyncLclk),
                    .AhbMBESyncLclk   (AhbMBESyncLclk),
                    
                    .Toggle           (Toggle),
                    .PixelEn          (PixelEn),
                    .LcdCP            (LcdCP),
                    .CLLPint          (CLLPint),
                    .CLFPint          (CLFPint),
                    .CLACint          (CLACint),
                    .CLLEint          (CLLEint),
                    .CLPOWERint       (CLPOWERint),
                    .PalLcdCSB2       (PalLcdCSB2),
                    .UnpackEn         (UnpackEn),
                    .UpSTNData        (UpSTNData),
                    .LpSTNData        (LpSTNData),
                    .FrameStart       (FrameStart),
                    .FrameRst         (FrameRst),
                    .VCompStat        (VCompStat),
                    .TFTPDEn          (TFTPDEn)
                 );

// -----------------------------------------------------------------------------
// Synchronisation to CLCDCLK instantiation
// -----------------------------------------------------------------------------
 ClcdSyncCLCDCLK
          uClcdSyncCLCDCLK (
          .CLCDCLK            (CLCDCLK),
          .nCLCLKRESET        (nCLCLKRESET),
          .AhbMError          (AhbMError),
          .FrameRstAck        (FrameRstAck),
          .VCStatSyncHclk     (VCStatSyncHclk),
          .LCDT0Wen           (LCDT0Wen),
          .LCDT1Wen           (LCDT1Wen),
          .LCDT2Wen           (LCDT2Wen),
          .LCDT3Wen           (LCDT3Wen),
          .LCDCWen            (LCDCWen),
          .HWDATAS            (HWDATAS),
      
          .LcdEn              (LcdEn),
          .LcdBPP             (LcdBPP),
          .LcdBW              (LcdBW),
          .LcdTFT             (LcdTFT),
          .LcdMono8           (LcdMono8),
          .LcdDualLclk        (LcdDualLclk),
          .BGR                (BGR),
          .BEBO               (BEBO),
          .BEPO               (BEPO),
          .LcdPwrEn           (LcdPwrEn),
          .LcdVComp           (LcdVComp),
          .PPL                (PPL),
          .HSW                (HSW),
          .HFP                (HFP),
          .HBP                (HBP),
          .LPP                (LPP),
          .VSW                (VSW),
          .VFP                (VFP),
          .VBP                (VBP),
          .PCD                (PCD),
          .ACB                (ACB),
          .IVS                (IVS),
          .IHS                (IHS),
          .IPC                (IPC),
          .IEO                (IEO),
          .CPL                (CPL),
          .BCD                (BCD),
          .LED                (LED),
          .LEE                (LEE),
          .AhbMBESyncLclk     (AhbMBESyncLclk),
          .FrRstAckSyncLclk   (FrRstAckSyncLclk),
          .VCStaAckSyncLclk   (VCStaAckSyncLclk),
          .Tim0WenLclkDel     (Tim0WenLclkDel),
          .Tim1WenLclkDel     (Tim1WenLclkDel),
          .Tim2WenLclkDel     (Tim2WenLclkDel),
          .Tim3WenLclkDel     (Tim3WenLclkDel),
          .ConlWenLclkDel     (ConlWenLclkDel)
          );

// -----------------------------------------------------------------------------
// Lcd output MUX instantiation
// -----------------------------------------------------------------------------
ClcdOutMux uClcdOutMux (
                         .CLCDCLK    (CLCDCLK),
                         .IPC        (IPC),
                         .BCD        (BCD),
                         .LcdTFT     (LcdTFT),
                         .LcdBPP     (LcdBPP),
                         .LcdDual    (LcdDualLclk),
                         .TFTPDEn    (TFTPDEn),
                         .CLPOWERint (CLPOWERint),
                         .LcdEn      (LcdEn),
                         .LcdCP      (LcdCP),
                         .PixelRed   (PixelRed),
                         .PixelGreen (PixelGreen),
                         .PixelBlue  (PixelBlue),
                         .Brightbit  (Brightbit),
                         .UpSTNData  (UpSTNData),
                         .LpSTNData  (LpSTNData),
                        
                         .CLCPint    (CLCPint),
                         .CLDint     (CLDint)
                       );

endmodule

// --================================== End ==================================--

