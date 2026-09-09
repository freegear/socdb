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
//  File Name              : ClcdAhbSlaveIf.v.rca
//  File Revision          : 1.4
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//------------------------------------------------------------------------------
//  Purpose                : ClcdAhbSlave module of Colour LCD Controller.
//============================================================================--
 
`timescale 1ns/1ps

`include "ClcdDefine.v"
`include "ClcdConfig.v"

// -----------------------------------------------------------------------------

`define ST_NOT_SELECTED    4'b0001 // State NOT SELECTED
`define ST_IDLERESP        4'b0010 // State IDLE RESPONSE
`define ST_WRITE           4'b0100 // State WRITE
`define ST_READ            4'b1000 // State READ

 
`define NOSELCYC           4'b0001 // NOT SELECTED CYCLE
`define WRITECYC           4'b0100 // WRITE CYCLE
`define READCYC            4'b1000 // READ CYCLE

`define ADDR_TIMING0       7'b000_0000 // LCD TIMING0 - offset 0x00000000
`define ADDR_TIMING1       7'b000_0001 // LCD TIMING1 - offset 0x00000004
`define ADDR_TIMING2       7'b000_0010 // LCD TIMING2 - offset 0x00000008
`define ADDR_TIMING3       7'b000_0011 // LCD TIMING3 - offset 0x0000000C
`define ADDR_UBASEREG      7'b000_0100 // LCD Upper Panel Frame Addr-0x00000010
`define ADDR_LBASEREG      7'b000_0101 // LCD Lower Panel Frame Addr-0x00000014
`define ADDR_IMSC          7'b000_0110 // LCD IMSC    - offset 0x00000018
`define ADDR_CTRLREG       7'b000_0111 // LCD Control reg - offset 0x0000001C
`define ADDR_RIS           7'b000_1000 // LCD RIS     - offset 0x00000020
`define ADDR_MIS           7'b000_1001 // LCD MIS     - offset 0x00000024
`define ADDR_ICR           7'b000_1010 // LCD ICR     - offset 0x00000028
`define ADDR_UPCURREG      7'b000_1011 // LCD Lower Panel DMA Channel-0x0000002C
`define ADDR_LPCURREG      7'b000_1100 // LCD Lower Panel DMA Channel-0x00000030

// -----------------------------------------------------------------------------
// Peripheral Identification register's address constants
// -----------------------------------------------------------------------------
`define ADDR_PERIPHID0     7'b1111000
// Address of  CLCDPERIPHID0 at offset 0xFE0
`define ADDR_PERIPHID1     7'b1111001
// Address of  CLCDPERIPHID1 at offset 0xFE4
`define ADDR_PERIPHID2     7'b1111010
// Address of  CLCDPERIPHID2 at offset 0xFE8
`define ADDR_PERIPHID3     7'b1111011
// Address of  CLCDPERIPHID3 at offset 0xFEC

// -----------------------------------------------------------------------------
// PrimeCell Identification register's address constants
// -----------------------------------------------------------------------------
`define ADDR_PCELLID0      7'b1111100
// Address of  CLCDPERIPHID0 at offset 0xFF0
`define ADDR_PCELLID1      7'b1111101
// Address of  CLCDPERIPHID1 at offset 0xFF4
`define ADDR_PCELLID2      7'b1111110
// Address of  CLCDPERIPHID2 at offset 0xFF8
`define ADDR_PCELLID3      7'b1111111
// Address of  CLCDPERIPHID3 at offset 0xFFC

// -----------------------------------------------------------------------------
// Test register's address constants
// -----------------------------------------------------------------------------
`define ADDR_TCR           7'b1000000
// CLCDTCR at offset 0xF00 
`define ADDR_ITOP1         7'b1000001
// CLCDITOP1 at offset 0xF04
`define ADDR_ITOP2         7'b1000010
// CLCDITOP2 at offset 0xF08 
 
// -----------------------------------------------------------------------------
// Peripheral Identification register's values
// -----------------------------------------------------------------------------
`define PERIPHID0          8'b00010000
// CLCDPERIIPHID0 value programmed as 0x10
`define PERIPHID1          8'b00010001
// CLCDPERIIPHID1 value programmed as 0x11
`define Designer1          4'b0100
// CLCDPERIIPHID2 Designer1 value programmed as 0x04
`define PERIPHID3          8'b00000000
// CLCDPERIIPHID3 value programmed as 0x00

// -----------------------------------------------------------------------------
// PrimeCell Identification register's values
// -----------------------------------------------------------------------------
`define PCELLID0           8'b00001101
// CLCDPCELLID0 value programmed as 0x0D
`define PCELLID1           8'b11110000
// CLCDPCELLID1 value programmed as 0xF0
`define PCELLID2           8'b00000101
// CLCDPCELLID2 value programmed as 0x05
`define PCELLID3           8'b10110001
// CLCDPCELLID3 value programmed as 0xB1


module ClcdAhbSlaveIf (
// Input Ports
                       HCLK,
                       HRESETn,
                       HTRANSS,
                       HWRITES,
                       HSELCLCD,
                       HREADYINS,
                       HWDATAS,
                       HADDRS,
                       LCDUPCURR,
                       LCDLPCURR,
                       AhbMError,
                       PalAHBRData,
                       FifoUF,
                       Vcomp, 
                       LNBU,    
                       LcdEn,
                       LcdBPP,
                       LcdBW,
                       LcdTFT,
                       LcdMono8,
                       LcdDualLclk,
                       BGR,
                       BEBO,
                       BEPO,
                       LcdPwrEn,
                       LcdVComp,
                       PPL,
                       HSW,
                       HFP,
                       HBP,
                       LPP,
                       VSW,
                       VFP,
                       VBP,
                       PCD,
                       ACB,
                       IVS,
                       IHS,
                       IPC,
                       IEO,
                       CPL,
                       BCD,
                       LED,
                       LEE,
                       Tim0WenLclkDel,
                       Tim1WenLclkDel,
                       Tim2WenLclkDel,
                       Tim3WenLclkDel,
                       ConlWenLclkDel,
                       ITEN,
                       IntraOP,
                       PrimaryOP,
                       Revision, 

// Output Ports
                       HRESPS,
                       HREADYOUTS,
                       HRDATAS,
                       ClrAhbMasterErr,
                       ClrLNBU,
                       LCDUPBASE,
                       LCDLPBASE,
                       PalAHBWriteBn,
                       PalAHBAddr,
                       CLCDMBERRINTRint,
                       CLCDFUFINTRint,
                       CLCDVCOMPINTRint,
                       CLCDLNBUINTRint,
                       CLCDINTRint,
                       CLCDCLKSELint,
                       LcdDualHclk,
                       WATERMARK,
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
input   [1:00]  HTRANSS;          // Transfer response signal for AHB Slave
input           HWRITES;          // Write signal for AHB Slave
input           HREADYINS;        // Ready signal for AHB Slave
input   [11:02] HADDRS;           // Address bus for AHB slave
input   [31:00] HWDATAS;          // Write data input for AHB Slave
input           HSELCLCD;         // Select signal for this Slave

input   [29:00] LCDUPCURR;        // upper panel current address(read only)
input   [29:00] LCDLPCURR;        // lower panel current dma address(read only)
input           AhbMError;        // Master Error input
input           LcdEn;            // Lcd enable bit 
input   [02:00] LcdBPP;           // Lcd Bits Per Pixel
input           LcdBW;            // Lcd black and white mode
input           LcdTFT;           // Lcd is TFT or STN type
input           LcdMono8;         // No of bits in mono mode
input           LcdDualLclk;      // Indicates whether it is dual or single 
                                  // panel
input           BGR;              // Select between normal or swapped input 
input           BEBO;             // Select B/W big or small Endian byte order
input           BEPO;             // Select B/W big or small Endian pixel order
input           LcdPwrEn;         // LCD Power enable
input   [01:00] LcdVComp;         // Used to generate interrupt at different 
                                  // positions
input   [05:00] PPL;              // No of Pixels per line 
input   [07:00] HSW;              // Horz Sync Pulse width value
input   [07:00] HFP;              // Horz Front Porch value
input   [07:00] HBP;              // Vert Back  Porch value
input   [09:00] LPP;              // Lines per panel value
input   [05:00] VSW;              // Vert Sync Pulse width value
input   [07:00] VFP;              // Vert Front Porch value
input   [07:00] VBP;              // Vert Back  Porch value
input   [09:00] PCD;              // programmable clock divider 
input   [04:00] ACB;              // AC Bias pin frequency
input           IVS;              // Invert Vsync
input           IHS;              // Invert Hsync
input           IPC;              // Invert Panel Clock
input           IEO;              // Invert Output Enable
input   [09:00] CPL;              // Clocks Per Line
input           BCD;              // Bypass Pixel Clock Divider
input   [06:00] LED;              // Line-End signal delay
input           LEE;              // Line End Enable
input   [31:00] PalAHBRData;      // PalleteRam read data bus
input           FifoUF;           // FIFO Empty signal(Upper FIFO)
input           Vcomp;            // Vertical Compare status from timing 
                                  // generator
input           LNBU;             // Next Addr update signal
input           Tim0WenLclkDel;   // Registered signal for re-synchronization
input           Tim1WenLclkDel;   // Registered signal for re-synchronization
input           Tim2WenLclkDel;   // Registered signal for re-synchronization
input           Tim3WenLclkDel;   // Registered signal for re-synchronization
input           ConlWenLclkDel;   // Registered signal for re-synchronization
input           ITEN;             // Integration test enable CLCDTCR bit 0
input   [5:0]   IntraOP;          // Intra chip output signals for integration 
                                  // test reads
input   [29:0]  PrimaryOP;        // Primary output signals for integration 
                                  // test reads
input   [3:0]   Revision;         // Device revision designator

output  [01:00] HRESPS;           // Slave response from AHB Slave
output          HREADYOUTS;       // Ready signal from AHB Slave
output  [31:00] HRDATAS;          // Read out data from AHB Slave
output          ClrAhbMasterErr;  // Error clearence for Master
output          ClrLNBU;          // Error clearence for Master
output  [29:00] LCDUPBASE;        // LCD Upper panel DMA Base Address
output  [29:00] LCDLPBASE;        // LCD Lower panel DMA Base Address
output          PalAHBWriteBn;    // Enable for Pallete entity
output  [09:00] PalAHBAddr;       // Ahb read/write address for Palette and 
                                  // TPRAM

output          CLCDMBERRINTRint; // AHB MasterError interrupt
output          CLCDFUFINTRint;   // LCD upper FIFO underflow interrupt
output          CLCDLNBUINTRint;  // LCD next base update interrupt
output          CLCDVCOMPINTRint; // LCD Vertical compare status interrupt
output          CLCDINTRint;      // combined interrupt of all interrupts

output          LcdDualHclk;      // Indicates whether it is dual or single 
                                  // panel 
output          WATERMARK;        // LCD DMAFIFO watermark level select bit
output          CLCDCLKSELint;    // Clock select output 
output          LCDT0Wen;         // TimingReg0 write enable - HCLK domain
output          LCDT1Wen;         // TimingReg1 write enable - HCLK domain
output          LCDT2Wen;         // TimingReg2 write enable - HCLK domain
output          LCDT3Wen;         // TimingReg3 write enable - HCLK domain
output          LCDCWen;          // LcdControlReg write enable - HCLK domain
output          LCDTCRWen;        // Test control register write enable
output          LCDITOP1Wen;      // Integration Test Output register 1 write 
                                  // enable
output          LCDITOP2Wen;      // Integration Test Output register 2 write
                                  // enable


// -----------------------------------------------------------------------------
//
// Overview
// ========
//          Provides CPU access to the colour LCD controller control and timing
//          registers, Palette RAM and TPRAM.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire            HCLK;           
// AHB Clock                                                   (Module input)

wire            HRESETn;        
// AHB Bus Reset signal - HCLK domain                          (Module input)

wire    [1:0]  HTRANSS;        
// Transfer response signal for AHB Slave                      (Module input)

wire            HWRITES;        
// Write signal for AHB Slave                                  (Module input)

wire            HREADYINS;      
// Ready signal for AHB Slave                                  (Module input)

wire    [11:2] HADDRS;         
// Address bus for AHB slave                                   (Module input)

wire    [31:0] HWDATAS;        
// Write data input for AHB Slave                              (Module input)

wire            HSELCLCD;       
// Select signal for this Slave                                (Module input)

wire    [29:0] LCDUPCURR;     
// upper panel current address(read only)                      (Module input)

wire    [29:0] LCDLPCURR;     
// lower panel current dma address(read only)                  (Module input)

wire            AhbMError;      
// Master Error input                                          (Module input)
 
wire    [31:0] PalAHBRData;    
// PaletteRam read data bus                                    (Module input)
 
wire            FifoUF;         
// FIFO Empty signal(Upper FIFO)                               (Module input)
 
wire            Vcomp;          
// Vertical Compare status from timing generator               (Module input)

wire            LNBU;           
// Next Addr update signal                                     (Module input)


wire          LcdEn;
// Lcd enable bit from control reg                             (Module input)

wire [02:00]  LcdBPP;
// Lcd Bits Per Pixel                                          (Module input)

wire          LcdBW;
// Lcd black and white mode                                    (Module input)

wire          LcdTFT;
// Lcd is TFT or STN type                                      (Module input)

wire          LcdMono8;
// No of bits in mono mode                                     (Module input)

wire          LcdDualLclk;
// Indicates whether it is dual or single panel                (Module input)

wire          BGR;
// Select between normal or swapped output                     (Module input)

wire          BEBO;
// Select B/W big or small Endian byte order                   (Module input)

wire          BEPO;
// Select B/W big or small Endian pixel order                  (Module input)

wire          LcdPwrEn ;
// LCD Power enable                                            (Module input)

wire [1:0]  LcdVComp;
// Used to generate interrupt at diff positions                (Module input)

wire [5:0]  PPL;
// No of Pixels per line info                                  (Module input)

wire [7:0]  HSW;
// Horz Sync Pulse width value                                 (Module input)

wire [7:0]  HFP;
// Horz Front Porch width value                                (Module input)

wire [7:0]  HBP;
// Vert Back  Porch width value                                (Module input)

wire [9:0]  LPP;
// Lines per panel value                                       (Module input)

wire [5:0]  VSW;
// Vert Sync Pulse width value                                 (Module input)

wire [7:0]  VFP;
// Vert Front Porch width                                      (Module input)

wire [7:0]  VBP;
// Vert Back  Porch width value                                (Module input)

wire [9:0]  PCD;
// Clock divider value                                         (Module input)

wire        Tim0WenLclkDel;   
// Registered signal for re-synchronization                    (Module input)

wire        Tim1WenLclkDel;   
// Registered signal for re-synchronization                    (Module input)

wire        Tim2WenLclkDel;   
// Registered signal for re-synchronization                    (Module input)

wire        Tim3WenLclkDel;   
// Registered signal for re-synchronization                    (Module input)

wire        ConlWenLclkDel;   
// Registered signal for re-synchronization                    (Module input)

wire [4:0]  ACB;
// AC Bias pin frequency                                       (Module input)

wire          IVS;
// Invert Vsync                                                (Module input)

wire          IHS;
// Invert Hsync                                                (Module input)

wire          IPC;
// Invert Panel Clock                                          (Module input)

wire          IEO;
// Invert Output Enable                                        (Module input)

wire [9:0]  CPL;
// Clocks Per Line                                             (Module input)

wire          BCD;
// Bypass Pixel Clock Divider                                  (Module input)

wire [6:0]  LED;
// Line-End signal delay                                       (Module input)

wire          LEE;
// Line End Enable                                             (Module input)

wire          ClrAhbMasterErr;
// AHB Error clearence bit for Master                          (Module output)

wire          ClrLNBU;
// Next base update interrupt clear bit                        (Module output)

wire          PalAHBWriteBn;
// Write enable for Palette RAM                                (Module output)

wire [9:0]    PalAHBAddr;
// Ahb read/write address for Palette and TPRAM                (Module output)

wire          CLCDMBERRINTRint;
// AHB MasterError interrupt                                   (Module output)

wire          CLCDFUFINTRint;
// LCD DMA FIFO underflow interrupt                            (Module output)

wire          CLCDLNBUINTRint;
// LCD next base update interrupt                              (Module output)

wire          CLCDVCOMPINTRint;
// LCD Vertical compare status interrupt                       (Module output)

wire          CLCDINTRint;
// combined interrupt of all interrupts                        (Module output)

wire [31:0] HRDATAS;
// AHB Read data bus                                           (Module output)

wire [4:1]  LCDRIS;         
// LCD Raw Interrupt Status Register

wire [4:1]  LCDMIS;      
// LCD Masked Interrupt Status Register

wire          PalWrComplete;
// Palette RAM write has completed 

wire          WaitRdCyc;
// Read cycle flag.When asserted HReadySout is delayed.

wire          NoSelCycSt;
// asserted when LcdSlaveState is in NOSELCYC state

wire          WriteCycSt;
// asserted when LcdSlaveState is in WRITECYC state

wire          ReadCycSt; 
// asserted when LcdSlaveState is in READCYC state

// ----------------------------------------------------------------------------
// Register declarations
// ----------------------------------------------------------------------------

reg  [1:0]  HRESPS;   
// Slave response from AHB Slave                               (Module output)

reg           HREADYOUTS;
// Ready signal from AHB Slave                                 (Module output)

reg  [29:0]  LCDUPBASE;
// LCD Upper panel DMA Base Address                            (Module output)

reg  [29:0]  LCDLPBASE;
//LCD Lower panel DMA Base Address                             (Module output)

reg           LcdDualHclk;  
// Indicates whether it is dual or single panel                (Module output)

reg           WATERMARK;
// Lcd DMAFIFO watermark select                                (Module output)

reg           CLCDCLKSELint;
// Clcd clock source select                                    (Module output)

reg           PaletteRAMWen;
// Write enable for Palette RAM register-HCLK domain           (Module output)

reg           LCDT0Wen ;
// Register logic before giving for synchronizer               (Module Output)
 
reg           LCDT1Wen ;
// Register logic before giving for synchronizer               (Module Output)
 
reg           LCDT2Wen ;
// Register logic before giving for synchronizer               (Module Output)
 
reg           LCDT3Wen ;
// Register logic before giving for synchronizer               (Module Output)
 
reg           LCDCWen  ;
// Register logic before giving for synchronizer               (Module Output)

reg  [1:0]  NextHRESPS;   
// D-input of HRESPS register

reg           NextHREADYOUTS;
// D-input of HREADYOUTS register

reg  [29:0]  NextLCDUPBASE;
// D-input of LCDUPBASE register

reg  [29:0]  NextLCDLPBASE;
// D-input of LCDLPBASE register

reg           NextLcdDualHclk;  
// D-input of LcdDualHclk register

reg           NextCLCDCLKSELint;
// D-input of CLCDCLKSELint register

reg  [31:0]  HRDATAInt;         
// AHB Read data internal multiplexer output

reg  [31:0]  NextHRDATAInt;     
// AHB Read data internal multiplexer output

reg  [4:1]  LCDIMSC;        
// LCD Interrupt Mask Set Clear register

reg  [3:0]  NextIMSC;    
// D-input of LCD Interrupt Mask Set Clear register

reg  [11:2]  AddressBuff;       
// Reg to hold the offset address(for Latching)

reg  [11:2]  NextAddressBuff;   
// input of the offset address(for Latching)

reg  [3:0]  LcdSlaveState;     
// input vector to control the state machine

reg  [3:0]  NxtLcdSlaveState; 
// D-input of LcdSlaveState register 

reg  [2:0]  PalWriteSt;
// Register for Palette RAM write state machine

reg  [2:0]  NextPalWriteSt;
// D-input of PalWriteSt register

reg           PalReadSt;
// Internal version of Palette Read flag

reg           NextPalReadSt;
// D-input of PalReadSt register

reg           PalRdComplete;
// Flag for Palettte RAM read over indication

reg           WaitComb;
// Flag to delay the assertion of HReadySout

reg           WaitWrCyc ;
// register for Write cycle status

reg           FifoStatus;
// Register for DMA fifo underflow interrupt status

reg           NextFifoStatus;
// D-input of FifoStatus

reg           VcompStatus;
// Register for Vertical compare interrupt status

reg           NextVcompStatus;
// D-input of VcompStatus

reg           LCDTiming0Wen;
// Write enable for Timing0 register-HCLK domain

reg           LCDTiming1Wen;
// Write enable for Timing1 register-HCLK domain

reg           LCDTiming2Wen;
// Write enable for Timing2 register-HCLK domain

reg           LCDTiming3Wen;
// Write enable for Timing3 register-HCLK domain

reg           LCDUPBASEWen;
// Write enable for UPBASE register-HCLK domain

reg           LCDLPBASEWen;
// Write enable for LOWBASE register-HCLK domain

reg           LCDIMSCWen;
// Internal version of write enable for Timing register-HCLK domain

reg           LCDControlWen;
// Write enable for Control register-HCLK domain

reg           LCDICRWen;
// Write enable for Interrupt Clear register-HCLK domain

reg           LCDTCRWen;
// Write enable for Test Control Register-HCLK domain

reg           LCDITOP1Wen;
// Write enable for Integration Test Output 1 register-HCLK domain

reg           LCDITOP2Wen;
// Write enable for Integration Test Output 2 register-HCLK domain

reg           LckWenOnHclk;
// Register for CLCDCLK register write enables synchronised back to HCLK

reg           DelLckWenOnHclk;
// Delayed version of LckWenOnHclk

reg           LckRegWenMask;
// clear signal for LckWenOnHclk signal

reg           NextLckWenMask;
// D-input of LckRegWenMask

reg           LckRegWenOnSync;
// First level synchroniser output for LckWenOnHclk

reg           NextLckWenOnSync;
// D-input of LckRegWenOnSync



reg           NextWATERMARK;
// D-input of WATERMARK register

reg           NextLCDT0Wen ;
// D-input of LCDT0Wen register

reg           NextLCDT1Wen ;
// D-input of LCDT1Wen register

reg           NextLCDT2Wen ;
// D-input of LCDT2Wen register

reg           NextLCDT3Wen ;
// D-input of LCDT3Wen register

reg           NextLCDCWen  ;
// D-input of LCDCWen register
 
reg           NextLCDTCRWen  ;
// D-input of LCDTCRWen register
 
reg           NextLCDITOP1Wen  ;
// D-input of LCDITOP1Wen register
 
reg           NextLCDITOP2Wen  ;
// D-input of LCDITOP2Wen register
 
//-----------------------------------------------------------------------------
//
// Main body of code
// =================
//
//-----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// LcdSlaveState decode assignments
// ----------------------------------------------------------------------------
assign NoSelCycSt =|(LcdSlaveState & `NOSELCYC);
assign WriteCycSt =|(LcdSlaveState & `WRITECYC);
assign ReadCycSt  =|(LcdSlaveState & `READCYC); 

// -----------------------------------------------------------------------------
// Register bit assignments
// -----------------------------------------------------------------------------
 assign LCDRIS[1]        = FifoStatus;
 assign LCDRIS[2]        = LNBU;
 assign LCDRIS[3]        = VcompStatus;
 assign LCDRIS[4]        = AhbMError;
 assign LCDMIS           = LCDRIS[4:1] & LCDIMSC[4:1];
 assign CLCDFUFINTRint   = LCDMIS[1]; 
 assign CLCDLNBUINTRint  = LCDMIS[2];  
 assign CLCDVCOMPINTRint = LCDMIS[3];
 assign CLCDMBERRINTRint = LCDMIS[4];
 assign CLCDINTRint      = |LCDMIS[4:1];

//------------------------------------------------------------------------------
//    S L A V E    S E L E C T    S T A T E    M A C H I N E
//------------------------------------------------------------------------------
// This SM  has `ST_NOT_SELECTED,`ST_IDLERESP,`ST_WRITE,`ST_READ states. The 
// state machine enters the `ST_NOT_SELECTED state  by default.The state 
// machine enters the `ST_IDLERESP state when response from master is idle,
// busy .state machine will enter the `ERRESP state when data transfer size is
// not a word.It will enter `ST_READ or `WRITECYC depending on the HWRITES
// signal. Transition to each state is qualified with HREADYINS and HSELCLD.
//------------------------------------------------------------------------------
always @(LcdSlaveState or AddressBuff or HREADYINS or HSELCLCD or HTRANSS or
         HADDRS or WaitWrCyc or WaitRdCyc or HWRITES or HREADYOUTS or HRESPS
         or NoSelCycSt or WriteCycSt or ReadCycSt ) 
begin : p_SlaveSMComb
  NxtLcdSlaveState  = LcdSlaveState;
  NextHREADYOUTS    = HREADYOUTS;
  NextHRESPS        = HRESPS;
  NextAddressBuff   = AddressBuff;
  case (LcdSlaveState)
    `ST_NOT_SELECTED, `ST_IDLERESP, `ST_WRITE, `ST_READ :
      if (HREADYINS) 
        begin
          if (HSELCLCD) 
            begin
              case (HTRANSS)
                `IDLE : 
                  begin
                    NxtLcdSlaveState      = `ST_IDLERESP;
                    NextHREADYOUTS        = 1'b1;
                    NextHRESPS            = `OKAY;
                    NextAddressBuff       = HADDRS[11:2];
                  end

                `BUSY : 
                  begin
                    NxtLcdSlaveState  = `ST_IDLERESP;
                    NextHREADYOUTS    = 1'b1;
                    NextHRESPS        = `OKAY;
                    NextAddressBuff   = HADDRS[11:2];
                  end

                `NSEQ, `SEQ : 
                  begin
                    NextHRESPS = `OKAY;
                    NextAddressBuff = HADDRS[11:2];
                    if (HWRITES) 
                      begin
                        NxtLcdSlaveState  = `ST_WRITE;
                        NextHREADYOUTS    = ~WaitWrCyc;
                      end
                    else 
                      begin
                        NxtLcdSlaveState = `ST_READ;
                        if ((AddressBuff[11:9] == 3'b000) || 
                            (AddressBuff[11:9] == 3'b111) || (HTRANSS == `NSEQ))
                          NextHREADYOUTS  = 1'b0;
                        else if (WaitRdCyc == 1'b1)
                          NextHREADYOUTS  = 1'b0;
                        else 
                          NextHREADYOUTS  = 1'b1;
                      end
                  end

                default : ;
              endcase
            end
          else 
            begin
              NxtLcdSlaveState  = `ST_NOT_SELECTED;
              NextHREADYOUTS    = 1'b1;
              NextHRESPS        = `OKAY;
            end
        end
      else 
        begin
          case (1'b1)
            NoSelCycSt   : NextHREADYOUTS = 1'b1;

            WriteCycSt   : NextHREADYOUTS = ~WaitWrCyc;

            ReadCycSt    : 
              begin
                if ((AddressBuff[11:9] == 3'b000) ||
                    (AddressBuff[11:9] == 3'b111))
                  NextHREADYOUTS = 1'b1;
                else if (!WaitRdCyc)
                  NextHREADYOUTS  = 1'b1;
                else 
                  NextHREADYOUTS = HREADYOUTS;
              end

            default      : NextHREADYOUTS = HREADYOUTS;
          endcase
        end

    default : 
      begin
        NxtLcdSlaveState = `ST_NOT_SELECTED;
        NextHREADYOUTS   = 1'b1;
        NextHRESPS       = `OKAY;
      end
  endcase
end // p_SlaveSMComb

// ---------------------------------------------------------------------------
// registering all Next state signal
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_SlaveSMSeq
  if (!HRESETn) 
    begin
      LcdSlaveState <= `ST_NOT_SELECTED;
      HREADYOUTS    <= 1'b1;
      HRESPS        <= `OKAY;
      AddressBuff   <= 10'b0;
    end
  else 
    begin
      LcdSlaveState <= NxtLcdSlaveState;        
      HREADYOUTS    <= NextHREADYOUTS;
      HRESPS        <= NextHRESPS;
      AddressBuff   <= NextAddressBuff;
    end
end // p_SlaveSMSeq

// ---------------------------------------------------------------------------
// Generating the  Status Register status
// ---------------------------------------------------------------------------
assign ClrAhbMasterErr = HWDATAS[4] & LCDICRWen;
assign ClrLNBU         = HWDATAS[2] & LCDICRWen;

// ---------------------------------------------------------------------------
// This block generates the status reg bits. Here depending on , whether the
// CPU is clearing the status bit or if the error gets generated, status bits
// are assigned accordingly.
// ---------------------------------------------------------------------------
always @(FifoStatus or VcompStatus or LCDICRWen or FifoUF or Vcomp or HWDATAS) 
begin : p_StatusRegComb
  NextFifoStatus   = FifoStatus;
  NextVcompStatus  = VcompStatus;
  if (LCDICRWen) 
    begin
      if (HWDATAS[1]) 
        NextFifoStatus   = 1'b0;
      if (HWDATAS[3]) 
        NextVcompStatus  = 1'b0;
    end
  else 
    begin
      if (FifoUF) 
        NextFifoStatus   = 1'b1;
      if (Vcomp)         
        NextVcompStatus  = 1'b1;
    end
end // p_StatusRegComb

// ---------------------------------------------------------------------------
// registering the next state inputs
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_StatusRegSeq
  if (!HRESETn) 
    begin
      FifoStatus   <= 1'b0;
      VcompStatus  <= 1'b0;
    end
  else 
    begin
      FifoStatus   <= NextFifoStatus;
      VcompStatus  <= NextVcompStatus;
    end
end // p_StatusRegSeq

// ---------------------------------------------------------------------------
// This always block is responsible for generating the combinational wait
// signal so that wait state can be put immediately after write occurs to 
// the registers which is in sync with CLCDCLK domain. This is in critical
// path as it directly decodes the HADDRS. The case statement in this block
// is required if we dont want wait states to be introduced in the "One
// Clock Access" locations. e.g. LCDIMSC register. However doing so 
// results in a timing critical path. If this not desired and register
// access performance is not an issue then the whole case-endcase statement
// in the next block to be replaced by just WaitComb = 1; This'll insert
// at least one wait state in the bus cycle for access to the CLCD registers.
// ---------------------------------------------------------------------------
always @( HREADYINS or HSELCLCD or HADDRS or HWRITES) 
begin : p_WaitComb
  WaitComb = 1'b0;
  if (HREADYINS && HSELCLCD) 
    begin
      // This case statement is in timing critical path. To avoid timing
      //  issue COMMENT out the whole case-endcase and UNCOMMENT the
      //  subsequent assignment. 
      case (HADDRS[11:9])
        3'b000 : 
          begin
            case (HADDRS[8:2])
              `ADDR_TIMING0,`ADDR_TIMING1, `ADDR_TIMING2,`ADDR_TIMING3,
              `ADDR_CTRLREG : 
                if (HWRITES) 
                  WaitComb = 1'b1;

              default : 
                WaitComb = 1'b0;
            endcase // case(HADDRS[8:2])
          end // case: 3'b000

        3'b001 : 
          if (HWRITES) 
            WaitComb = 1'b1;

        default : 
          WaitComb = 1'b0;
      endcase
      
    end // if (HREADYINS && HSELCLCD)
end // p_WaitComb

// -----------------------------------------------------------------------------
// Register Write Logic
// This always block controls the enable signal for the registers depending on 
// which address the cpu is trying to acces.These signals are in HCLK domain.
// -----------------------------------------------------------------------------
always @(WriteCycSt or AddressBuff) 
begin : p_RegWriteComb
  LCDTiming0Wen    = 1'b0;
  LCDTiming1Wen    = 1'b0;
  LCDTiming2Wen    = 1'b0;
  LCDTiming3Wen    = 1'b0;
  LCDUPBASEWen     = 1'b0;
  LCDLPBASEWen     = 1'b0;
  LCDIMSCWen       = 1'b0;
  LCDControlWen    = 1'b0;
  LCDICRWen        = 1'b0;
  PaletteRAMWen    = 1'b0;
  LCDTCRWen        = 1'b0;
  LCDITOP1Wen      = 1'b0;
  LCDITOP2Wen      = 1'b0;

  if (WriteCycSt==1'b1) 
    begin
      case (AddressBuff[11:9])
        3'b000 : 
          case (AddressBuff[8:2])
            `ADDR_TIMING0  : LCDTiming0Wen    = 1'b1;
            `ADDR_TIMING1  : LCDTiming1Wen    = 1'b1;
            `ADDR_TIMING2  : LCDTiming2Wen    = 1'b1;
            `ADDR_TIMING3  : LCDTiming3Wen    = 1'b1;
            `ADDR_UBASEREG : LCDUPBASEWen     = 1'b1;
            `ADDR_LBASEREG : LCDLPBASEWen     = 1'b1;
            `ADDR_IMSC     : LCDIMSCWen       = 1'b1;
            `ADDR_CTRLREG  : LCDControlWen    = 1'b1;
            `ADDR_ICR      : LCDICRWen        = 1'b1;
            default        :; 
          endcase

        3'b001 : 
          PaletteRAMWen = 1'b1;

        3'b111 : 
          case (AddressBuff[8:2])
            `ADDR_TCR     : LCDTCRWen   = 1'b1;
            `ADDR_ITOP1   : LCDITOP1Wen = 1'b1;
            `ADDR_ITOP2   : LCDITOP2Wen = 1'b1;
            default       :;
          endcase

        default :;
      endcase
    end
end // p_RegWriteComb

// -----------------------------------------------------------------------------
// Write cycle wait state generation
// -----------------------------------------------------------------------------
always @(WaitComb           or PaletteRAMWen      or 
         LCDTiming0Wen      or LCDTiming1Wen      or
         LCDTiming2Wen      or LCDTiming3Wen      or
         LCDControlWen      or PalWrComplete      or
         LckWenOnHclk       or DelLckWenOnHclk    or
         HREADYOUTS         or WriteCycSt         or
         LcdSlaveState) 
begin : p_WaitWrCycComb
  WaitWrCyc = WaitComb;
  case (1'b1)
    LCDTiming0Wen , LCDTiming1Wen , LCDTiming2Wen , LCDTiming3Wen ,
    LCDControlWen : 
      if (!LckWenOnHclk && DelLckWenOnHclk) 
        WaitWrCyc = 1'b0;
      else if ((!HREADYOUTS) && (WriteCycSt==1'b1))
        WaitWrCyc = 1'b1;

    PaletteRAMWen : 
      if (PalWrComplete)    
        WaitWrCyc = 1'b0;
      else if ((!HREADYOUTS) && (WriteCycSt==1'b1))
        WaitWrCyc = 1'b1;

    default :; 
  endcase
end // p_WaitWrCycComb

// ---------------------------------------------------------------------------
// Block to register the signal before feeding into synczer to avoid glitch
// ---------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn) 
begin : p_HCLKWenClk
  if (!HRESETn) 
    begin
      LCDT0Wen <= 1'b0;
      LCDT1Wen <= 1'b0;
      LCDT2Wen <= 1'b0;
      LCDT3Wen <= 1'b0;
      LCDCWen  <= 1'b0;
    end
  else 
    begin
      LCDT0Wen <= NextLCDT0Wen;
      LCDT1Wen <= NextLCDT1Wen;
      LCDT2Wen <= NextLCDT2Wen;
      LCDT3Wen <= NextLCDT3Wen;
      LCDCWen  <= NextLCDCWen;
    end
end // p_HCLKWenClk;

// ---------------------------------------------------------------------------
// Block to synchronize the signal in CLCDCLK domain.
// ---------------------------------------------------------------------------
always @ (LCDTiming0Wen or LckRegWenMask or LCDTiming1Wen or LCDTiming2Wen or
          LCDTiming3Wen or LCDControlWen ) 
begin : p_CLCDCLKSynComb
  NextLCDT0Wen = LCDTiming0Wen & ~LckRegWenMask;
  NextLCDT1Wen = LCDTiming1Wen & ~LckRegWenMask;
  NextLCDT2Wen = LCDTiming2Wen & ~LckRegWenMask;
  NextLCDT3Wen = LCDTiming3Wen & ~LckRegWenMask;
  NextLCDCWen  = LCDControlWen & ~LckRegWenMask;
end // p_CLCDCLKSynComb

// ---------------------------------------------------------------------------
// Block to resynchronize back to HCLK Domain
// ---------------------------------------------------------------------------
always @ ( Tim0WenLclkDel or Tim1WenLclkDel or
           Tim2WenLclkDel or Tim3WenLclkDel or
           ConlWenLclkDel or LckWenOnHclk   or
           LckRegWenMask     or HREADYOUTS  ) 
begin : p_ReSyncHCLKComb
  NextLckWenOnSync    = (Tim0WenLclkDel | Tim1WenLclkDel |
                         Tim2WenLclkDel | Tim3WenLclkDel | ConlWenLclkDel);
  if (HREADYOUTS) 
    NextLckWenMask = 1'b0;
  else if (LckWenOnHclk)
    NextLckWenMask = 1'b1;
  else NextLckWenMask = LckRegWenMask;
end // p_ReSyncHCLKComb

// ---------------------------------------------------------------------------
// registering the next state inputs
// ---------------------------------------------------------------------------
always @ (posedge HCLK or negedge HRESETn) 
begin : p_ReSyncHCLKSeq
  if (!HRESETn) 
    begin
      LckWenOnHclk       <= 1'b0;
      LckRegWenOnSync    <= 1'b0; 
      DelLckWenOnHclk    <= 1'b0;
      LckRegWenMask      <= 1'b0;
    end
  else 
    begin
      LckRegWenOnSync    <= NextLckWenOnSync;
      LckWenOnHclk       <= LckRegWenOnSync;
      DelLckWenOnHclk    <= LckWenOnHclk;
      LckRegWenMask      <= NextLckWenMask;
    end
end // p_ReSyncHCLKSeq

// ---------------------------------------------------------------------------
// This  block controls the actual write in HCLK domain. Here depending
// on the register enable signals the data from the data bus is registered 
// on to the corresponding registers.
// ---------------------------------------------------------------------------
always @(LCDUPBASEWen or LCDLPBASEWen or LCDControlWen or HWDATAS or
         LCDIMSCWen or LCDUPBASE   or LCDLPBASE   or LCDIMSC or
         LcdDualHclk or LCDTiming2Wen or 
         CLCDCLKSELint or WATERMARK) 
begin : p_HCLKWriteComb
  NextLCDUPBASE     = LCDUPBASE;
  NextLCDLPBASE     = LCDLPBASE;
  NextIMSC          = LCDIMSC;
  NextLcdDualHclk   = LcdDualHclk;
  NextCLCDCLKSELint = CLCDCLKSELint;
  NextWATERMARK     = WATERMARK;
  if (LCDUPBASEWen) 
    NextLCDUPBASE[29:0] = HWDATAS[31:2];
  if (LCDLPBASEWen) 
    NextLCDLPBASE[29:0] = HWDATAS[31:2];
  if (LCDTiming2Wen) 
    NextCLCDCLKSELint   = HWDATAS[5];
  if (LCDControlWen) 
    begin
      NextLcdDualHclk     = HWDATAS[7];
      NextWATERMARK       = HWDATAS[16];
    end  
  if (LCDIMSCWen) 
    NextIMSC[3:0] = HWDATAS[4:1];
end // p_HCLKWriteComb

// ---------------------------------------------------------------------------
// registering the next state inputs
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_HCLKWriteSeq
  if (!HRESETn) 
    begin
      LCDUPBASE          <= {30{1'b0}};
      LCDLPBASE          <= {30{1'b0}};
      LCDIMSC[4:1]       <= { 4{1'b0}};
      LcdDualHclk        <= 1'b0;
      CLCDCLKSELint      <= 1'b0;
      WATERMARK          <= 1'b0;
    end
  else 
    begin
      LCDUPBASE          <= NextLCDUPBASE;
      LCDLPBASE          <= NextLCDLPBASE;
      LCDIMSC            <= NextIMSC;
      LcdDualHclk        <= NextLcdDualHclk;
      CLCDCLKSELint      <= NextCLCDCLKSELint;
      WATERMARK          <= NextWATERMARK;
    end
end // p_HCLKWriteSeq

// ---------------------------------------------------------------------------
// This block takes care of inserting wait states while writing  to 
// PalleteRam.The signals PalAHBWriteBn and PalWrComplete can be used to have 
// variable wait states, by properly assigning it in the state machine.
// ---------------------------------------------------------------------------

assign PalAHBAddr       = AddressBuff[11:2];
assign PalAHBWriteBn    = ~PalWriteSt[1] | ~PaletteRAMWen;
assign PalWrComplete    = PalWriteSt[1];

// -----------------------------------------------------------------------------
// Pallete Write Wait State Generation combinational logic
// -----------------------------------------------------------------------------
always @(PaletteRAMWen or PalWriteSt) 
begin : p_PalWriteComb
  NextPalWriteSt = PalWriteSt;
  case (PalWriteSt)
    3'b001 : 
      if (PaletteRAMWen)
        NextPalWriteSt = 3'b010;

    3'b010 : 
      NextPalWriteSt = 3'b100;

    3'b100 : 
      NextPalWriteSt = 3'b001;

    default : 
      NextPalWriteSt = 3'b001;
  endcase
end // p_PalWriteComb

// -----------------------------------------------------------------------------
// Pallete Write Wait State Generation sequential logic
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_PalWriteSeq
  if (!HRESETn) 
    PalWriteSt <= 3'b001; 
  else
    PalWriteSt <= NextPalWriteSt;
end // p_PalWriteSeq

// ---------------------------------------------------------------------------
// read data path logic
// This  block controls the actual read operation.
// Depending on the address location for which the master wants to read ,
// The corresponding data from that register is put on the data bus.
// ---------------------------------------------------------------------------
always @(AddressBuff or HBP or HFP or HSW or PPL or LPP or VSW or VFP or VBP or
         BCD or CPL or IEO or IPC or IHS or IVS or ACB or CLCDCLKSELint or PCD
         or LEE or LED or LCDUPBASE or LCDLPBASE or LCDIMSC or 
         LcdVComp or LcdPwrEn or BEPO or BEBO or WATERMARK or
         BGR or LcdDualLclk or LcdMono8 or LcdTFT or LcdBW or LcdBPP or 
         LcdEn or LCDRIS or LCDMIS or LCDUPCURR or LCDLPCURR or ITEN or
         IntraOP or PrimaryOP or Revision) 
begin : p_ReadComb
  NextHRDATAInt = 32'b0;
  if (AddressBuff[11:9] == 3'b000)
    case (AddressBuff[8:2])
      `ADDR_TIMING0   : NextHRDATAInt = {HBP, HFP, HSW, PPL, 2'b0};
      `ADDR_TIMING1   : NextHRDATAInt = {VBP, VFP, VSW, LPP};
      `ADDR_TIMING2   : NextHRDATAInt = {PCD[9:5],BCD,CPL,1'b0,IEO,
                                         IPC,IHS,IVS,ACB, CLCDCLKSELint,
                                         PCD[4:0]};
      `ADDR_TIMING3   : NextHRDATAInt = {15'b0,LEE,9'b0,LED};
      `ADDR_UBASEREG  : NextHRDATAInt = {LCDUPBASE,2'b0} ;
      `ADDR_LBASEREG  : NextHRDATAInt = {LCDLPBASE,2'b0} ;
      `ADDR_IMSC      : NextHRDATAInt = {27'b0,LCDIMSC, 1'b0};
      `ADDR_CTRLREG   : NextHRDATAInt = {15'b0,WATERMARK,2'b0,
                                         LcdVComp,LcdPwrEn, BEPO,
                                         BEBO,BGR,LcdDualLclk, 
                                         LcdMono8, LcdTFT,LcdBW, LcdBPP,LcdEn};

      `ADDR_RIS       : NextHRDATAInt = {27'b0,LCDRIS, 1'b0};
      `ADDR_MIS       : NextHRDATAInt = {27'b0,LCDMIS, 1'b0};
      `ADDR_UPCURREG  : NextHRDATAInt = {LCDUPCURR,2'b0};
      `ADDR_LPCURREG  : NextHRDATAInt = {LCDLPCURR,2'b0};
      default         : NextHRDATAInt = 32'h00000000;
    endcase
  else if (AddressBuff[11:9] == 3'b111)
    case (AddressBuff[8:2])
      `ADDR_TCR       : NextHRDATAInt = {31'h00000000,  ITEN};
      `ADDR_ITOP1     : NextHRDATAInt = {26'h0000000,   IntraOP};
      `ADDR_ITOP2     : NextHRDATAInt = {2'b00,         PrimaryOP};
      `ADDR_PCELLID0  : NextHRDATAInt = {24'h000000,   `PCELLID0};
      `ADDR_PCELLID1  : NextHRDATAInt = {24'h000000,   `PCELLID1};
      `ADDR_PCELLID2  : NextHRDATAInt = {24'h000000,   `PCELLID2};
      `ADDR_PCELLID3  : NextHRDATAInt = {24'h000000,   `PCELLID3};
      `ADDR_PERIPHID0 : NextHRDATAInt = {24'h000000,   `PERIPHID0};
      `ADDR_PERIPHID1 : NextHRDATAInt = {24'h000000,   `PERIPHID1}; 
      `ADDR_PERIPHID2 : NextHRDATAInt = {24'h000000,    Revision, `Designer1};
      `ADDR_PERIPHID3 : NextHRDATAInt = {24'h000000,   `PERIPHID3};
      default         : NextHRDATAInt = {32'h00000000};
    endcase
end // p_ReadComb

// ---------------------------------------------------------------------------
// Registering the HRDATAInt
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_ReadSeq
  if (!HRESETn)
    HRDATAInt <= 32'h00000000;
  else
    HRDATAInt <= NextHRDATAInt;
end // p_ReadSeq

// HRDATAS output
assign HRDATAS[31:0] = ((AddressBuff[11:9] == 3'b000) || 
                        (AddressBuff[11:9] == 3'b111)) ? HRDATAInt   :
                        (AddressBuff[11:9] == 3'b001)  ? PalAHBRData : 32'b0;
                      
// WaitRdCyc output
assign WaitRdCyc = (AddressBuff[11:9] == 3'b001) ? ~PalRdComplete : 1'b0;

// ---------------------------------------------------------------------------
// PALLETE READ :This block take care of inserting wait states in read opern
// The signals PalAHBWriteBn and PalRdComplete can be used to have variable
// wait states , by properly assigning it in the state machine.
// ---------------------------------------------------------------------------
always @(PalReadSt or AddressBuff or ReadCycSt) 
begin : p_PalReadComb
  NextPalReadSt    = 1'b0;
  PalRdComplete    = 1'b0;
  if (ReadCycSt==1'b1) 
    begin
      case (AddressBuff [11:9])
        3'b001 :  
          begin 
            NextPalReadSt = ~PalReadSt & `PAL_RAM_READ_STRTCH; 
            PalRdComplete = ((PalReadSt & `PAL_RAM_READ_STRTCH) || 
                             (!`PAL_RAM_READ_STRTCH)); 
          end
        default : 
          begin
            NextPalReadSt    = 1'b0;
            PalRdComplete    = 1'b0;
          end
      endcase
    end
end // p_PalReadComb

// ---------------------------------------------------------------------------
// Registering the next state values
// ---------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_PalReadSeq
  if (!HRESETn) 
    PalReadSt <= 1'b0; 
  else 
    PalReadSt <= NextPalReadSt;
end // p_PalReadSeq

endmodule

// --================================ End ==================================--

