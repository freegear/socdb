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
//  File Name              : CLTrick.v.rca
//  File Revision          : 1.3
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Purpose : CLCD Trickbox Top Module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module CLTrick (
                HCLK,
                HRESETN,

                // Main Bus Slave AHB Signals connected to Slave Testbench
                HADDRB,
                HTRANSB,      
                HWRITEB,
                HSELB,
                HSELCom,
                HSIZEB,      
                HBURSTB,    
                HWDATAB,
                HRDATAB,
                HREADYBIn,
                HREADYBOut,
                HRESPB,

                // CLCD AHB Signals
                HADDRC,
                HTRANSC,
                HWRITEC,
                HSIZEC,
                HBURSTC,
                HRDATAC,
                HREADYC,
                HPROTC,
                HLOCKC,
                HRESPC,
                HBUSREQC,
                HGRANTC,

                // CLCD Panel Signals
                LCDCLK,
                nCLCLKRESET, 
                CLPOWER,
                CLFP,
                CLLP,
                CLCP,
                CLAC,
                CLD,
                CLLE,

                CLCLKSEL,

                // Interrupt Signals
                BEINTTR,
                FUFINTR,
                LNBUINTR,
                VCOMPINTR,
                INTR
               ); 

input             HCLK;           // AHB Bus Clock
input             HRESETN;        // AHB Reset

input  [9:2]      HADDRB;         // AHB (Bus) Address Bus
input  [1:0]      HTRANSB;        // AHB (Bus) Transfer Type
input             HWRITEB;        // AHB (Bus) Transfer Direction
input             HSELB;          // AHB (Bus) Slave Select
input             HSELCom;        // AHB Common Registers Select
input  [2:0]      HSIZEB;         // AHB (Bus) Transfer Size
input  [2:0]      HBURSTB;        // AHB (Bus) Burst Type
input  [31:0]     HWDATAB;        // AHB (Bus) Write Data Bus
input             HREADYBIn;      // AHB (Bus) Global Transfer Done
output [31:0]     HRDATAB;        // AHB (Bus) Read  Data Bus
output            HREADYBOut;     // AHB (Bus) TrickBox Transfer Done
output [1:0]      HRESPB;         // AHB (Bus) transfer Response

input  [31:0]     HADDRC;         // AHB (CLCD) Address Bus
input  [1:0]      HTRANSC;        // AHB (CLCD) Transfer Type
input             HWRITEC;        // AHB (CLCD) Transfer Direction
input  [2:0]      HSIZEC;         // AHB (CLCD) Transfer Size
input  [2:0]      HBURSTC;        // AHB (CLCD) Burst Type
output            HREADYC;        // AHB (CLCD) Transfer Done
input  [3:0]      HPROTC;         // AHB (CLCD) Protection Signal
input             HLOCKC;         // AHB (CLCD) Lock mode
output [31:0]     HRDATAC;        // AHB (CLCD) Read  Data Bus
input             HBUSREQC;       // AHB (CLCD) Bus Request from CLCD Master
output [1:0]      HRESPC;         // AHB (CLCD) Transfer Response
output            HGRANTC;        // AHB (CLCD) Bus Grant for CLCD Master

output            LCDCLK;         //  LCD Clock
output            nCLCLKRESET;    // Reset for LCD Clock domain
input             CLPOWER;        // LCD Power Panel Enable
input             CLFP;           // Frame Sync Pulse
input             CLLP;           // Line Sync Pulse
input             CLCP;           // Pixel Clock
input             CLAC;           // STN AC bias drive or TFT data Enable output
input [23:0]      CLD;            // CLCD Panel Data
input             CLLE;           // Line End Signal

input             CLCLKSEL;       // CLCD Clock Souurce Select Signal
input             BEINTTR;        // CLCD Bus Error Interrupt
input             FUFINTR;       // CLCD DMA Lower FIFO Underflow Interrupt
input             LNBUINTR;       // CLCD Next Base Address Update Interrupt
input             VCOMPINTR;      // CLCD Vertical Compare Interrupt
input             INTR;           // CLCD Combined Interrupt

// -----------------------------------------------------------------------------
//                             CLTrick
//                             =======
// -----------------------------------------------------------------------------
// Overview
// ========
// This module is the top level of the CLCD Trickbox.
// It includes the following:
//  1. Bus AHB Interface
//  2. Register Block
//  3. CLCD AHB Interface
//  4. CLCD Data Checker Module
//  5. CLCD Panel Protocol Checker
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
// Module I/Os
// -----------
wire              HCLK;           // (module input)
wire              HRESETN;        // (module input)

wire   [9:2]      HADDRB;         // (module input)
wire   [1:0]      HTRANSB;        // (module input)
wire              HWRITEB;        // (module input)
wire              HSELB;          // (module input)
wire              HSELCom;        // (module input)
wire   [2:0]      HSIZEB;         // (module input)
wire   [2:0]      HBURSTB;        // (module input)
wire   [31:0]     HWDATAB;        // (module input)
wire              HREADYBIn;      // (module input)
wire   [31:0]     HRDATAB;        // (module output)
wire              HREADYBOut;     // (module output)
wire   [1:0]      HRESPB;         // (module output)

wire   [31:0]     HADDRC;         // (module input)
wire   [1:0]      HTRANSC;        // (module input)
wire              HWRITEC;        // (module input)
wire   [2:0]      HSIZEC;         // (module input)
wire   [2:0]      HBURSTC;        // (module input)
wire              HREADYC;        // (module output)
wire   [3:0]      HPROTC;         // (module input)
wire              HLOCKC;         // (module input)
wire   [31:0]     HRDATAC;        // (module output)
wire              HBUSREQC;       // (module input)
wire   [1:0]      HRESPC;         // (module output)
wire              HGRANTC;        // (module output)

wire              CLPOWER;        // (module input)
wire              CLFP;           // (module input)
wire              CLLP;           // (module input)
wire              CLCP;           // (module input)
wire              CLAC;           // (module input)
wire  [23:0]      CLD;            // (module input)
wire              CLLE;           // (module input)

wire              CLCLKSEL;       // (module input)
wire              BEINTTR;        // (module input)
wire              FUFINTR;       // (module input)
wire              LNBUINTR;       // (module input)
wire              VCOMPINTR;      // (module input)
wire              INTR;           // (module input)

// Internal Signals
// ----------------
wire              CLTrWRITE;       // CLCD Trickbox Write
wire   [31:0]     CLTrWDATA;       // CLCD Trickbox Write Data
wire   [31:0]     CLTrRDATA;       // CLCD Trickbox Read  Data
wire              CLTrRegSel;      // CLCD Trickbox Register Select
wire              CLTrControlSel;  // CLCD Trickbox Control Reg Select
wire              CLTrTiming0Sel;  // CLCD Trickbox Timing 0 Reg Select
wire              CLTrTiming1Sel;  // CLCD Trickbox Timing 1 Reg Select
wire              CLTrTiming2Sel;  // CLCD Trickbox Timing 2 Reg Select
wire              CLTrTiming3Sel;  // CLCD Trickbox Timing 3 Reg Select
wire              CLTrUPBASESel;   // CLCD Trickbox Upper Panel Base Select
wire              CLTrLPBASESel;   // CLCD Trickbox Lower Panel Base Select
wire              CLTrPalSel;      // CLCD Trickbox Palette Select
wire    [6:0]     CLTrPalAddr;     // CLCD Trickbox Palette Offset Address
wire   [31:0]     CLTrUPBASE;      // CLCD Data Base Address for Upper Panel
wire   [31:0]     CLTrLPBASE;      // CLCD Data Base Address for Lower Panel
wire   [31:0]     Delay;           // Trickbox delay counter value 
wire              CLTrIntrTest;    // CLCD Trickbox interupt test bit
wire              CLTrFUFIntrTst;  // CLCD Trickbox FIFO underflow interupt 
                                   // test bit
wire              CLTrRand;        // CLCD Trickbox random responce test bit
wire              CLTrError;       // CLCD Trickbox Error bit
wire              CLTrPanel;       // Indicates active panel
wire              CLTrGrant;       // CLCD grant for fifo underflow interupt 
wire              CLTrReset;       // CLCD clock domain reset Bit
wire              DataAvail;       // Indicate that Master is sampling data
wire   [2:0]      SlaveState;      // Slave condition to Reg Block for CLTrError
wire              CLTrEn;          // CLCD Trickbox Enable
wire   [2:0]      BPP;             // Bits per pixel
wire              BW;              // Black-White mode in STN
wire              TFT;             // Indicates TFT or STN Mode
wire              Mono8;           // Indicates MONO 8 bit or 4 bit mode
wire              Dual;            // Indicates Single or Dual Panel STN mode
wire              BGR;             // Indicates BGR or RGB format
wire              BEBO;            // Indicates Byte order
wire              BEPO;            // Indicates Pixel order within Byte
wire              VCOMPINTRout;    // To protcolcheck module
wire              LNBUINTRout;     // To protcolcheck module

wire   [1:0]      VComp;           // VComp Interrupt Control bit
wire   [5:0]      PPL;             // Pixel Per Line
wire   [7:0]      HSW;             // Horizontal Sync Pulse Width
wire   [7:0]      HFP;             // Horizontal Front Porch
wire   [7:0]      HBP;             // Horizontal Back Porch
wire   [9:0]      LPP;             // Line Per Panel
wire   [5:0]      VSW;             // Vertical Sync Pulse Width
wire   [7:0]      VFP;             // Vertical Front Porch
wire   [7:0]      VBP;             // Vertical Back Porch
wire   [9:0]      PCD;             // Panel Clock Divisor
wire   [4:0]      ACB;             // AC Bias Pin Frequency
wire              IVS;             // Invert VSync
wire              IHS;             // Invert HSync
wire              IPC;             // Invert Panel Clock
wire              IEO;             // Invert Output Enable
wire   [9:0]      CPL;             // Clocks Per Line
wire              BCD;             // ByPass Pixel Clock Divisor
wire   [6:0]      LED;             // Line End Delay
wire              LEE;             // Line End Select
wire              Check;           // Check CLD
wire              CLTrBaseUpdate;  // CLCD Trickbox Base Update Request Signal
wire              ResetWritePtrs;  // CLCD Trickbox initialise write pointers
wire  [2:0]       VSYNCState;      // Vertical sync pulse
wire              LCDCLK;          // wire declaration for LCD clock generator
wire              LcdEn;           // Enable signal for LCD controller
wire              LcdPwr;          // Enable signal for LCD controller

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg               nCLCLKRESET;     // CLCD clock domain resetgenerator
reg               CLCLK;           // CLCD clock
reg               IntCLTrReset;    // Synchronised CLCD clock domain reset bit

// -----------------------------------------------------------------------------
// Parameter declarations
// -----------------------------------------------------------------------------
parameter         LCDPeriod = 10;  // CLCD clock period

// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------

// Instantiation of CLTrAHBIf
CLTrAHBIf uCLTrAHBIf (
                     // Inputs
                     .HCLK                 (HCLK),
                     .HRESETN              (HRESETN),
                     .HADDR                (HADDRB),
                     .HTRANS               (HTRANSB),
                     .HWRITE               (HWRITEB),
                     .HSEL                 (HSELB),
                     .HSELCom              (HSELCom),
                     .HSIZE                (HSIZEB),
                     .HBURST               (HBURSTB),
                     .HWDATA               (HWDATAB),
                     .HREADYIn             (HREADYBIn),

                     .CLTrRDATA            (CLTrRDATA),

                     // Outputs
                     .HRDATA               (HRDATAB),
                     .HREADYOut            (HREADYBOut),
                     .HRESP                (HRESPB),

                     .CLTrWRITE            (CLTrWRITE),
                     .CLTrWDATA            (CLTrWDATA),
                     .CLTrRegSel           (CLTrRegSel),
                     .CLTrControlSel       (CLTrControlSel),
                     .CLTrTiming0Sel       (CLTrTiming0Sel),
                     .CLTrTiming1Sel       (CLTrTiming1Sel),
                     .CLTrTiming2Sel       (CLTrTiming2Sel),
                     .CLTrTiming3Sel       (CLTrTiming3Sel),
                     .CLTrUPBASESel        (CLTrUPBASESel),
                     .CLTrLPBASESel        (CLTrLPBASESel),
                     .CLTrPalSel           (CLTrPalSel),
                     .DelayRegSel          (DelayRegSel),
                     .Delay                (Delay),
                     .CLTrPalAddr          (CLTrPalAddr)
                    );

// Instantiation of CLTrCLCDIf
CLTrCLCDIf uCLTrCLCDIf(
                     .HCLK                  (HCLK),
                     .HRESETN               (HRESETN),
                     .HADDR                 (HADDRC),
                     .HTRANS                (HTRANSC),
                     .HWRITE                (HWRITEC),
                     .HSIZE                 (HSIZEC),
                     .HBURST                (HBURSTC),
                     .HRDATA                (HRDATAC),
                     .HREADY                (HREADYC),
                     .HPROT                 (HPROTC),
                     .HLOCK                 (HLOCKC),
                     .HRESP                 (HRESPC),
                     .HBUSREQ               (HBUSREQC),
                     .HGRANT                (HGRANTC),
                     .CLTrEn                (CLTrEn),
                     .CLTrUPBASE            (CLTrUPBASE),
                     .CLTrLPBASE            (CLTrLPBASE),
                     .CLTrError             (CLTrError),
                     .CLTrPanel             (CLTrPanel),
                     .Dual                  (Dual),
                     .PPL                   (PPL),
                     .LPP                   (LPP),
                     .BPP                   (BPP),
                     .CLTrRand              (CLTrRand),
                     .CLTrGrant             (CLTrGrant),
                     .DataAvail             (DataAvail),
                     .SlaveState            (SlaveState),
                     .CLTrBaseUpdate        (CLTrBaseUpdate),
                     .ResetWritePtrs        (ResetWritePtrs)
                    );

// Instantiation of CLTrRegBlock
CLTrRegBlock uCLTrRegBlock(
                     .HCLK                  (HCLK),
                     .HRESETN               (HRESETN),
                     .CLTrWRITE             (CLTrWRITE),
                     .CLTrWDATA             (CLTrWDATA),
                     .CLTrRDATA             (CLTrRDATA),
                     .CLTrRegSel            (CLTrRegSel),
                     .CLTrControlSel        (CLTrControlSel),
                     .CLTrTiming0Sel        (CLTrTiming0Sel),
                     .CLTrTiming1Sel        (CLTrTiming1Sel),
                     .CLTrTiming2Sel        (CLTrTiming2Sel),
                     .CLTrTiming3Sel        (CLTrTiming3Sel),
                     .CLTrUPBASESel         (CLTrUPBASESel),
                     .CLTrLPBASESel         (CLTrLPBASESel),
                     .DelayRegSel           (DelayRegSel), 
                     .CLTrUPBASE            (CLTrUPBASE),
                     .CLTrLPBASE            (CLTrLPBASE),
                     .SlaveState            (SlaveState),
 
                     // Interrupt Lines
                     .BEINTTR               (BEINTTR),
                     .FUFINTR               (FUFINTR),
                     .LNBUINTR              (LNBUINTR),
                     .VCOMPINTR             (VCOMPINTR),
                     .VCOMPINTRout          (VCOMPINTRout),
                     .LNBUINTRout           (LNBUINTRout),
                     .INTR                  (INTR),
 
                     // Control bit fields
                     .CLTrEn                (CLTrEn),
                     .LcdEn                 (LcdEn),
                     .LcdPwr                (LcdPwr),
                     .BPP                   (BPP),
                     .BW                    (BW),
                     .TFT                   (TFT),
                     .Mono8                 (Mono8),
                     .Dual                  (Dual),
                     .BGR                   (BGR),
                     .BEBO                  (BEBO),
                     .BEPO                  (BEPO),
                     .VComp                 (VComp),
                     .CLTrGrant             (CLTrGrant),
                     .CLTrReset             (CLTrReset),
                     .CLTrError             (CLTrError),
                     .CLTrIntrTest          (CLTrIntrTest),
                     .CLTrFUFIntrTst        (CLTrFUFIntrTst),
                     .CLTrRand              (CLTrRand),
                     .PPL                   (PPL),
                     .HSW                   (HSW),
                     .HFP                   (HFP),
                     .HBP                   (HBP),
                     .LPP                   (LPP),
                     .VSW                   (VSW),
                     .VFP                   (VFP),
                     .VBP                   (VBP),
                     .PCD                   (PCD),
                     .ACB                   (ACB),
                     .IVS                   (IVS),
                     .IHS                   (IHS),
                     .IPC                   (IPC),
                     .IEO                   (IEO),
                     .CPL                   (CPL),
                     .BCD                   (BCD),
                     .LED                   (LED),
                     .LEE                   (LEE),
                     .Delay                 (Delay)  
                     );

// Instantiation of CLTrDataCheck
CLTrDataCheck uCLTrDataCheck(
                     .HCLK                  (HCLK),
                     .VSYNCState            (VSYNCState),
                     .CLCLK                 (LCDCLK),
                     .HRESETN               (HRESETN),
                     .CLTrEn                (CLTrEn),
                     .CLTrIntrTest          (CLTrIntrTest),
                     .CLTrFUFIntrTst        (CLTrFUFIntrTst),
                     .CLPOWER               (CLPOWER),
                     .DataAvail             (DataAvail),
                     .Check                 (Check),
                     .DataIn                (HRDATAC),
                     .PPL                   (PPL),
                     .LPP                   (LPP),
                     .CLD                   (CLD),
                     .BPP                   (BPP),
                     .BW                    (BW),
                     .TFT                   (TFT),
                     .Mono8                 (Mono8),
                     .Dual                  (Dual),
                     .BGR                   (BGR),
                     .BEBO                  (BEBO),
                     .BEPO                  (BEPO),
                     .CLTrPanel             (CLTrPanel),
                     .ResetWritePtrs        (ResetWritePtrs),
 
                     // Palette RAM Signals
                     .PalSelect             (CLTrPalSel),
                     .PalWrite              (CLTrWRITE),
                     .PalData               (CLTrWDATA),
                     .PalAddr               (CLTrPalAddr)
                     );

// Instantiation of CLTrProtCheck
CLTrProtCheck uCLTrProtCheck (
                     .CLCLK                 (LCDCLK),
                     .HRESETN               (HRESETN),
                     .CLTrEn                (CLTrEn),
                     .CLTrIntrTest          (CLTrIntrTest),
                     .CLTrFUFIntrTst        (CLTrFUFIntrTst),
                     .CLPOWER               (CLPOWER),
                     .LcdEn                 (LcdEn),
                     .CLFP                  (CLFP),
                     .CLLP                  (CLLP),
                     .CLCP                  (CLCP),
                     .CLAC                  (CLAC),
                     .CLLE                  (CLLE),
                     .TFT                   (TFT),
                     .PCD                   (PCD),
                     .HSW                   (HSW),
                     .HFP                   (HFP),
                     .HBP                   (HBP),
                     .LPP                   (LPP),
                     .VSW                   (VSW),
                     .VFP                   (VFP),
                     .VBP                   (VBP),
                     .ACB                   (ACB),
                     .IVS                   (IVS),
                     .IHS                   (IHS),
                     .IPC                   (IPC),
                     .IEO                   (IEO),
                     .CPL                   (CPL),
                     .BCD                   (BCD),
                     .LED                   (LED),
                     .LEE                   (LEE),
                     .Check                 (Check),
                     .CLTrBaseUpdate        (CLTrBaseUpdate),
                     .VCOMPINTRout          (VCOMPINTRout),
                     .LNBUINTRout           (LNBUINTRout),
                     .VComp                 (VComp),
                     .VSYNCState           (VSYNCState)
                     );
// -----------------------------------------------------------------------------
// Generation of CLCD clock 
// -----------------------------------------------------------------------------
initial
  begin : p_ClockGen 
    CLCLK = 1'b0;
    forever
      begin
        # (LCDPeriod/2) CLCLK = ~ CLCLK;  
      end
  end
// -----------------------------------------------------------------------------
// Assigning the CLCD clock according to clksel signal
// -----------------------------------------------------------------------------
assign LCDCLK = (CLCLKSEL) ? CLCLK : HCLK; 

// -----------------------------------------------------------------------------
// Assigning Reset value of nCLCLKRESET
// -----------------------------------------------------------------------------
initial
begin : Reset_Ini
  nCLCLKRESET = 1;
end

// -----------------------------------------------------------------------------
// Transfering the CLTrReset in to CLCD clock domain reset 
// -----------------------------------------------------------------------------
always @(IntCLTrReset or HRESETN or CLCLKSEL)
begin : p_ClcdReset
   nCLCLKRESET = 1;
   if (CLCLKSEL == 1)
      nCLCLKRESET = IntCLTrReset;
   else
      nCLCLKRESET = HRESETN;
end

// -----------------------------------------------------------------------------
// Synchronising the Clcd clock domain reset to the CLCD clock
// -----------------------------------------------------------------------------
always @(posedge CLCLK)
begin : p_SyncReset
  IntCLTrReset <= ~CLTrReset;
end

// -----------------------------------------------------------------------------

endmodule
 
// --================================== End ==================================--

