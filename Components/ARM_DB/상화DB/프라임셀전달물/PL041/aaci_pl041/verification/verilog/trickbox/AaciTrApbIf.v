// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//  
// File Name              : AaciTrApbIf.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           APB Interface to generate decodes for write and read
//           accesses to AACI Trickbox internal registers.
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"

// ---------------------------------------------------------------------

module AaciTrApbIf (
// Inputs
                    // APB signals
                    PCLK, 
                    PRESETn, 
                    PSEL, 
                    PSELCOM, 
                    PWRITE, 
                    PENABLE, 
                    PADDR, 
                    PWDATA, 

                    // DMA Request signals
                    AACIDMASREQRX, 
                    AACIDMALSREQRX, 
                    AACIDMABREQRX, 
                    AACIDMALBREQRX, 
                    AACIDMABREQTX, 

                    // Interrupt signals
                    AACIINTR, 
                    AACITXINTR1, 
                    AACITXINTR2, 
                    AACITXINTR3, 
                    AACITXINTR4, 
                    AACIRXINTR1, 
                    AACIRXINTR2, 
                    AACIRXINTR3, 
                    AACIRXINTR4, 
                    AACIORINTR1, 
                    AACIORINTR2, 
                    AACIORINTR3, 
                    AACIORINTR4, 
                    AACITXCINTR1, 
                    AACITXCINTR2, 
                    AACITXCINTR3, 
                    AACITXCINTR4, 
                    AACIURINTR1, 
                    AACIURINTR2, 
                    AACIURINTR3, 
                    AACIURINTR4, 
                    AACIRXTOINTR1, 
                    AACIRXTOINTR2, 
                    AACIRXTOINTR3, 
                    AACIRXTOINTR4, 
                    AACIWINTR, 
                    AACIGPIOINTR, 
                    AACIS1RXINTR, 
                    AACIS2RXINTR, 
                    AACIS12RXINTR, 
                    AACIS1TXINTR, 
                    AACIS2TXINTR, 
                    AACIS12TXINTR, 
                    AACIRXTOFEINTR1, 
                    AACIRXTOFEINTR2, 
                    AACIRXTOFEINTR3, 
                    AACIRXTOFEINTR4, 
            
                    // Status signals
                    TxFFillLevel, 
                    RxFFillLevel, 
                    PCLKOn, 
                    BITCLKOn, 

                    // Register inputs
                    AACITrClkReg, 
                    AACITrDMAReg, 
                    AACITrBtClkPrd, 
                    RxFRData, 
// Outputs
                    // Write Enable signals
                    AACITRCNTRLWr, 
                    AACITRCLKWr, 
                    AACITRBTCLKWr, 
                    AACITRDMAWr, 
                    AACITrTxFIFOWr, 
                    AACITRRESETWr, 
                    AACITSYNCWr, 
                    RxFRdPtrInc, 

                    // APB signals
                    PRDATA, 
                    PWDataIn 
                   );

// Inputs
input         PCLK;              // APB Clock
input         PRESETn;           // AMBA Bus Reset
input         PSEL;              // AACI trickbox select
input         PSELCOM;           // AACI select
input         PWRITE;            // APB Peripheral Write
input         PENABLE;           // APB Peripheral enable
input  [11:2] PADDR;             // APB Addr
input  [31:0] PWDATA;            // Write databus

input         AACIDMASREQRX;     // AACI single transfer req
input         AACIDMALSREQRX;    // AACI single last transfer
input         AACIDMABREQRX;     // AACI burst transfer req
input         AACIDMALBREQRX;    // AACI burst last transfer
input         AACIDMABREQTX;     // AACI single transfer req

input         AACIINTR;          // AACI combined interrupt
input         AACITXINTR1;       // Channel 1 fifo Tx intr
input         AACITXINTR2;       // Channel 2 fifo Tx intr
input         AACITXINTR3;       // Channel 3 fifo Tx intr
input         AACITXINTR4;       // Channel 4 fifo Tx intr
input         AACIRXINTR1;       // Channel 1 fifo Rx intr
input         AACIRXINTR2;       // Channel 2 fifo Rx intr
input         AACIRXINTR3;       // Channel 3 fifo Rx intr
input         AACIRXINTR4;       // Channel 4 fifo Rx intr
input         AACIORINTR1;       // Ch1 fifo overrun Intr
input         AACIORINTR2;       // Ch2 fifo overrun Intr
input         AACIORINTR3;       // Ch3 fifo overrun Intr
input         AACIORINTR4;       // Ch4 fifo overrun Intr
input         AACITXCINTR1;      // Ch1 Tx complete Intr
input         AACITXCINTR2;      // Ch2 Tx complete Intr
input         AACITXCINTR3;      // Ch3 Tx complete Intr
input         AACITXCINTR4;      // Ch4 Tx complete Intr
input         AACIURINTR1;       // Ch1 Tx under run Intr
input         AACIURINTR2;       // Ch2 Tx under run Intr
input         AACIURINTR3;       // Ch3 Tx under run Intr
input         AACIURINTR4;       // Ch4 Tx under run Intr
input         AACIRXTOINTR1;     // Channel 1 Rx timeout Intr
input         AACIRXTOINTR2;     // Channel 2 Rx timeout Intr
input         AACIRXTOINTR3;     // Channel 3 Rx timeout Intr
input         AACIRXTOINTR4;     // Channel 4 Rx timeout Intr
input         AACIWINTR;         // Wakeup Interrupt
input         AACIGPIOINTR;      // GPIO Interrupt
input         AACIS1RXINTR;      // Slot1 recieve interrupt
input         AACIS2RXINTR;      // Slot2 recieve interrupt
input         AACIS12RXINTR;     // Slot12 recieve interrupt
input         AACIS1TXINTR;      // Slot1 transmit interrupt 
input         AACIS2TXINTR;      // Slot2 transmit interrupt 
input         AACIS12TXINTR;     // Slot12 transmit interrupt 
input         AACIRXTOFEINTR1;   // Rx Timeout FIFO 1 Empty intr
input         AACIRXTOFEINTR2;   // Rx Timeout FIFO 2 Empty intr
input         AACIRXTOFEINTR3;   // Rx Timeout FIFO 3 Empty intr
input         AACIRXTOFEINTR4;   // Rx Timeout FIFO 4 Empty intr
             
input [`POINTERWIDTH : 0] TxFFillLevel;
                                 // The Tx FIFO filllevel
input [`POINTERWIDTH : 0] RxFFillLevel;
                                 // The Rx FIFO filllevel
input         PCLKOn;            // PCLK is routed to BITCLK
input         BITCLKOn;          // Internal BITCLK is routed
                                 // to BITCLK
input   [2:0] AACITrClkReg;      // Clock muxing register
input   [6:5] AACITrDMAReg;      // Clock muxing register
input  [15:0] AACITrBtClkPrd;    // BITCLK period
input  [19:0] RxFRData;          // Receive FIFO Data
// Outputs
output        AACITRCNTRLWr;     // WrEn to AACITrCntrlReg
output        AACITRCLKWr;       // WrEn for AACITrClkReg
output        AACITRBTCLKWr;     // WrEn for AACITrBtClkPrd
output        AACITRDMAWr;       // WrEn for AACITrDMAReg
output        AACITrTxFIFOWr;    // WrEn for Tx FIFO
output        AACITRRESETWr;     // WrEn for AACITrRESET
output        AACITSYNCWr;       // WrEn for AACITRSYNC
output        RxFRdPtrInc;       // RxFIFO read ptr Increment
output [31:0] PRDATA;            // Read Databus
output [31:0] PWDataIn;          // Int PWDATA

// Inputs
wire          PCLK;              // (module input)
wire          PRESETn;           // (module input)
wire          PSEL;              // (module input)
wire          PSELCOM;           // (module input)
wire          PWRITE;            // (module input)
wire          PENABLE;           // (module input)
wire   [11:2] PADDR;             // (module input)
wire   [31:0] PWDATA;            // (module input)

wire          AACIDMASREQRX;     // (module input)
wire          AACIDMALSREQRX;    // (module input)
wire          AACIDMABREQRX;     // (module input)
wire          AACIDMALBREQRX;    // (module input)
wire          AACIDMABREQTX;     // (module input)

wire          AACIINTR;          // (module input)
wire          AACITXINTR1;       // (module input)
wire          AACITXINTR2;       // (module input)
wire          AACITXINTR3;       // (module input)
wire          AACITXINTR4;       // (module input)
wire          AACIRXINTR1;       // (module input)
wire          AACIRXINTR2;       // (module input)
wire          AACIRXINTR3;       // (module input)
wire          AACIRXINTR4;       // (module input)
wire          AACIORINTR1;       // (module input)
wire          AACIORINTR2;       // (module input)
wire          AACIORINTR3;       // (module input)
wire          AACIORINTR4;       // (module input)
wire          AACITXCINTR1;      // (module input)
wire          AACITXCINTR2;      // (module input)
wire          AACITXCINTR3;      // (module input)
wire          AACITXCINTR4;      // (module input)
wire          AACIURINTR1;       // (module input)
wire          AACIURINTR2;       // (module input)
wire          AACIURINTR3;       // (module input)
wire          AACIURINTR4;       // (module input)
wire          AACIRXTOINTR1;     // (module input)
wire          AACIRXTOINTR2;     // (module input)
wire          AACIRXTOINTR3;     // (module input)
wire          AACIRXTOINTR4;     // (module input)
wire          AACIWINTR;         // (module input)
wire          AACIGPIOINTR;      // (module input)
wire          AACIS1RXINTR;      // (module input)
wire          AACIS2RXINTR;      // (module input)
wire          AACIS12RXINTR;     // (module input)
wire          AACIS1TXINTR;      // (module input)
wire          AACIS2TXINTR;      // (module input)
wire          AACIS12TXINTR;     // (module input)
wire          AACIRXTOFEINTR1;   // (module input)
wire          AACIRXTOFEINTR2;   // (module input)
wire          AACIRXTOFEINTR3;   // (module input)
wire          AACIRXTOFEINTR4;   // (module input)
wire   [`POINTERWIDTH:0] TxFFillLevel;
                                 // (module input)
wire   [`POINTERWIDTH:0] RxFFillLevel;
                                 // (module input)
wire          PCLKOn;            // (module input)
wire          BITCLKOn;          // (module input)
wire    [2:0] AACITrClkReg;      // (module input)
wire    [6:5] AACITrDMAReg;      // (module input)
wire   [15:0] AACITrBtClkPrd;    // (module input)
wire   [19:0] RxFRData;          // (module input)

// Outputs
wire          AACITRCNTRLWr;     // (module output)
wire          AACITRCLKWr;       // (module output)
wire          AACITRBTCLKWr;     // (module output)
wire          AACITRDMAWr;       // (module output)
wire          AACITrTxFIFOWr;    // (module output)
wire          AACITRRESETWr;     // (module output)
wire          AACITSYNCWr;       // (module output)
wire          RxFRdPtrInc;       // (module output)
wire   [31:0] PWDataIn;          // (module output)
reg    [31:0] PRDATA;            // The read data bus from APB side

// ---------------------------------------------------------------------
//
//                           AaciTrApbIf
//                           ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
// This module decodes APB accesses and generates the write strobes to
// the appropriate registers. This module also contains the output data
// multiplexer and the output register that form the read interface. The
// internal databus, for the AACITrickbox, PWDataIn[31:0], is also
// generated in this module, by gating the input data bus, PWDATA[31:0]
// with PSEL (or PSELCOM) and PWRITE.
// Reading and writing of data from the internal registers and the Tx
// and Rx FIFO is done via the APB interface.
// This block has 2 PSELs; one is PSELCOM which is the same as the PSEL
// input to the AACI and the other is the trickbox-specific PSEL. The
// use of PSELCOM allows the trickbox to detect writes to certain
// AACI registers that are mirrored in the Trickbox. When these mirrored
// registers are writen to, the data is captured by the Trickbox and
// stored in the internal mirrored versions of the AACI registers.
// This eliminates extra register writes since the programming of
// the trickbox and the AACI happens in parallel. The PSEL is used for
// writing in to the trickbox specific registers and the trickbox
// transmit and receive FIFOs. The PSELCOM (PSEL of the AACI ) is used
// for writing in to the registers, which are mirror images of the AACI
// register (i.e. AACIRESET, AACISYNC). To avoid a conflict on the
// databus during reads to these mirrored register, the Trickbox will
// not respond reads to the morrored registers.
//
// ---------------------------------------------------------------------
//                    AACI TrickBox Register Map
// ---------------------------------------------------------------------
// Base          Offset  Register          Read/Write     Description 
// ---------------------------------------------------------------------
// Trickbox Base 0x000    AACITrCntrlReg    Write only  Control register
// Trickbox Base 0x000    AACITrIntr1Reg    Read only   Interrupt Status
//                                                     register
// Trickbox Base 0x004    AACITrBtClkPrd    Read-Write  BITCLK period in
//                                                     ns
// Trickbox Base 0x008    AACITrDMAReg      Read-Write  DMA interface 
//                                         register
// Trickbox Base 0x00C    AACITrFIFOStat    Read only
// Trickbox Base 0x010    AACITrRxFIFO      Read only
// Trickbox Base 0x014    AACITrTxFIFO      Write only
// Trickbox Base 0x018    AACITrIntr2Reg    Read only   Interrupt Status
//                                                     register
// Trickbox Base 0x01C    AACITrClkReg      Read-Write  Clcok muxing 
//                                                     control register
// AACI Base     0x07C    AACITrRESET       Write only
// AACI Base     0x080    AACITrSYNC        Write only
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Parameter declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Read Decodes for Register reads
wire        AACITRINTR1Rd;   // AACITRINTR read
wire        AACITRINTR2Rd;   // AACITRINTR2 read
wire        AACITRBTCLKRd;   // AACITRBTCLK read
wire        AACITRCLKRd;     // AACITRCLK read
wire        AACITRFSTRd;     // AACITRFST read
wire        AACITRDMARd;     // AACITRDMA read
wire        AACITRRFRd;      // AACITRRF read
wire [31:0] NextPRDATA;      // D input of PRDATA reg
wire        WrEn;            // Write enable for trickbox
wire        WrEnCom;         // Enable for AACI mirrored registers.
wire        RdEn;            // Read enable signal for the readable reg
wire [11:2] GatedPA;         // Gated bus address
wire  [4:0] IntDMAReg;       // The DMA register capturing the DMA
                             // signals.
wire [31:0] AACITrIntr1Reg;  // The interrupt register capturing the
                             // DMA signals.
wire  [4:0] AACITrIntr2Reg;  // The interrupt register 2 capturing the
                             // DMA signals.
wire [31:0] AACITrFIFOStat;  // The interrupt register 2 capturing the
                             // DMA signals.

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg  [31:0] ZEROFILL;
// Filling the zero's

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Initialise the ZEROFILL value
// ---------------------------------------------------------------------
initial
begin : ZeroFill
  ZEROFILL = 32'b0;
end // ZeroFill

// ---------------------------------------------------------------------
// Write Interface
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// Latch the  data bus and address bus when the device is  selected.
// ---------------------------------------------------------------------
assign GatedPA          = (PSEL == 1'b1 | PSELCOM == 1'b1) ? 
                           PADDR  : 12'b0;
assign PWDataIn         = ((PSEL == 1'b1 | PSELCOM == 1'b1) && 
                          (PWRITE == 1'b1)) ? PWDATA : 32'b0;
assign WrEn             = PENABLE && PSEL && PWRITE;
assign WrEnCom          = PENABLE && PSELCOM && PWRITE;

// ---------------------------------------------------------------------
// Register Write Decodes for common as well as trickbox specific
// registers
// ---------------------------------------------------------------------
// AACITrCntrlReg
assign AACITRCNTRLWr    = (WrEn  && (GatedPA == `PA_AACITRCNTRL));

// AACITrBtClkPrd
assign AACITRBTCLKWr    = (WrEn  && (GatedPA == `PA_AACITRBTCLK));

// AACITrClkReg
assign AACITRCLKWr      = (WrEn  && (GatedPA == `PA_AACITRCLKREG));

// AACITrDMAReg
assign AACITRDMAWr      = (WrEn  && (GatedPA == `PA_AACITRDMAREG));

// AACITrTxFIFO
assign AACITrTxFIFOWr   = (WrEn  && (GatedPA == `PA_AACITRTF));


// Common registers write enable generation

// AACITrRESET
assign AACITRRESETWr    = (WrEnCom  && (GatedPA == `PA_AACITRRESET));

// AACITrSYNC
assign AACITSYNCWr      = (WrEnCom  && (GatedPA == `PA_AACITSYNC));

// ---------------------------------------------------------------------
// Read Interface enable for  reading the trickbox specific registers
// ---------------------------------------------------------------------
assign  RdEn            = PSEL && (! PWRITE) && (! PENABLE);

// ---------------------------------------------------------------------
// Register Read Decodes for the trickbox specific registers
// ---------------------------------------------------------------------
// AACITrIntr1Reg
assign AACITRINTR1Rd    = (RdEn  && (GatedPA == `PA_AACITRINTR1));

// AACITrIntr2Reg
assign AACITRINTR2Rd    = (RdEn  && (GatedPA == `PA_AACITRINTR2));

// AACITrBtClkPrd
assign AACITRBTCLKRd    = (RdEn  && (GatedPA == `PA_AACITRBTCLK));

// AACITrClkReg
assign AACITRCLKRd      = (RdEn  && (GatedPA == `PA_AACITRCLKREG));

// AACITrDMAReg
assign AACITRDMARd      = (RdEn  && (GatedPA == `PA_AACITRDMAREG));

// AACITrFIFOStat
assign AACITRFSTRd      = (RdEn  && (GatedPA == `PA_AACITRFST));

// AACITrRxFIFO
assign AACITRRFRd       = (RdEn  && (GatedPA == `PA_AACITRRF));

// ---------------------------------------------------------------------
// Increment the Read pointer in the Receive FIFO after every read from
// the Receive FIFO i.e.  after every read from the AACITBRDR Register
// ---------------------------------------------------------------------
assign RxFRdPtrInc      = ((PENABLE == 1'b1) && (PSEL == 1'b1)
                        && (PWRITE == 1'b0)
                        && (GatedPA == `PA_AACITRRF)) ? 1'b1 : 1'b0;

// ---------------------------------------------------------------------
// Output Mux.
// When the peripheral trickbox is not being accessed, '0's are driven 
// on the Read Databus (PRDATA) so as not to place any restrictions on 
// the method of external bus connection. The external data buses of the
// peripherals on the APB may then be connected to the ASB-to-APB bridge
// using Muxed or ORed bus connection method.
// ---------------------------------------------------------------------
assign NextPRDATA       = (AACITRINTR1Rd == 1'b1) ? AACITrIntr1Reg :
                          ((AACITRINTR2Rd == 1'b1) ?
                            {27'b0, AACITrIntr2Reg} :
                          ((AACITRBTCLKRd == 1'b1) ?
                            {16'b0, AACITrBtClkPrd} :
                          ((AACITRCLKRd == 1'b1) ?
                            {27'b0, BITCLKOn, PCLKOn, AACITrClkReg} :
                          ((AACITRDMARd == 1'b1) ?
                            {25'b0, AACITrDMAReg, IntDMAReg} :
                          ((AACITRFSTRd == 1'b1) ?
                            AACITrFIFOStat :
                          ((AACITRRFRd == 1'b1) ?
                            {12'b0, RxFRData} : 27'b0))))));

// ---------------------------------------------------------------------
// Output Data register for sequential data driving on the rising edges
// of the PCLK
// ---------------------------------------------------------------------
always @ (posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (PRESETn == 1'b0)
    PRDATA  <= 32'h00000000;
  else
    PRDATA  <= NextPRDATA;
end   // p_Seq

// ---------------------------------------------------------------------
// The AACITrIntr1Reg assignment from the occurence of the interrupts.
// ---------------------------------------------------------------------
assign AACITrIntr1Reg   = {AACIURINTR4, AACIORINTR4, AACIRXINTR4,
                           AACITXINTR4, AACIRXTOINTR4, AACITXCINTR4,
                           AACIURINTR3, AACIORINTR3, AACIRXINTR3,
                           AACITXINTR3, AACIRXTOINTR3, AACITXCINTR3,
                           AACIURINTR2, AACIORINTR2, AACIRXINTR2,
                           AACITXINTR2, AACIRXTOINTR2, AACITXCINTR2,
                           AACIURINTR1, AACIORINTR1, AACIRXINTR1,
                           AACITXINTR1, AACIRXTOINTR1, AACITXCINTR1,
                           AACIWINTR, AACIGPIOINTR, AACIS12TXINTR,
                           AACIS12RXINTR, AACIS2TXINTR,
                           AACIS2RXINTR, AACIS1TXINTR,
                           AACIS1RXINTR};

// ---------------------------------------------------------------------
// The AACITrIntr2Reg assignment from the occurence of the interrupts.
// ---------------------------------------------------------------------
assign AACITrIntr2Reg   = {AACIRXTOFEINTR4, AACIRXTOFEINTR3,
                          AACIRXTOFEINTR2, AACIRXTOFEINTR1, AACIINTR};

// ---------------------------------------------------------------------
// The Internal DMA register assignment from the DMA requests from AACI
// ---------------------------------------------------------------------
assign IntDMAReg        = {AACIDMABREQTX, AACIDMALBREQRX, AACIDMABREQRX,
                          AACIDMALSREQRX, AACIDMASREQRX};

// ---------------------------------------------------------------------
// The AACITRFIFOStat assignment from the condition of the FIFO's.
// ---------------------------------------------------------------------
assign AACITrFIFOStat   = {ZEROFILL[15 : (`POINTERWIDTH +1)],
                          TxFFillLevel,
                          ZEROFILL[15 : (`POINTERWIDTH +1)],
                          RxFFillLevel};

endmodule

// =========================== End ===================================--
