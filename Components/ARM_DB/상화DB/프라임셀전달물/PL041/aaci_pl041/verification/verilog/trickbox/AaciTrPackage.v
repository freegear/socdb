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
// File Name              : AaciTrPackage.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           Trickbox Parameter definitions
//
// --=================================================================--

// ---------------------------------------------------------------------
// Constant declarations used in AaciTrRxFIFO and AaciTrTxFIFO
// ---------------------------------------------------------------------
`define FIFODEPTH        128
// To define the FIFO depth for receive and transmit FIFO

`define POINTERWIDTH     7
// To define the FIFO depth this should be defined according to
// FIFO depth

// ---------------------------------------------------------------------
// Constant declarations used in AaciTrProtChk
// ---------------------------------------------------------------------
`define OFFSET           1
// Data width tolerence from the full clock period

`define MAXSYNCDELAY     2
// Maximum SYNC port delay allowed after posedge of BITCLK

`define MAXSDATADELAY    2
// Maximum AACISDATAOUT port delay allowed after posedge of BITCLK

// ---------------------------------------------------------------------
// Constant declarations for the states in the state machine in
// AaciTrMainCntl
// ---------------------------------------------------------------------
// The state declarations for the main transmit/receive state machine.
// ---------------------------------------------------------------------
`define ST_INITIAL       4'b0000
`define ST_SYNC          4'b0001
`define ST_SLOT1         4'b0010
`define ST_SLOT2         4'b0011
`define ST_SLOT3         4'b0100
`define ST_SLOT4         4'b0101
`define ST_SLOT5         4'b0110
`define ST_SLOT6         4'b0111
`define ST_SLOT7         4'b1000
`define ST_SLOT8         4'b1001
`define ST_SLOT9         4'b1010
`define ST_SLOT10        4'b1011
`define ST_SLOT11        4'b1100
`define ST_SLOT12        4'b1101

// ---------------------------------------------------------------------
// Constant declarations used in AaciTrClkGen
// ---------------------------------------------------------------------
`define BtClkSkew        3
// Skew for the BITCLK generated with respect to PCLK when PCLK is
// routed to BITCLK

// ---------------------------------------------------------------------
// Constant declarations used in AaciTrRegBlk
// ---------------------------------------------------------------------
`define PCLK_PERIOD      10
// The PCLK period for the simulation.. it should be same as in
// timing.v in the testbench
 
`define Tdclrrx         (`PCLK_PERIOD * 0.6)
// The delay from rising edge of the the PCLK for DMACLRRX signal from
// the trickbox
 
`define Tdclrtx         (`PCLK_PERIOD * 0.6)
// The delay from rising edge of the the PCLK for DMACLRTX signal from
// the trickbox

// ---------------------------------------------------------------------
// AACI Trickbox registers' addresses constant defs used in AaciTrApbIf
// ---------------------------------------------------------------------
// Registers at trickbox base
// --------------------------
`define PA_AACITRCNTRL   10'b0000000000
// AACITrCntrlReg at offset 0x00

`define PA_AACITRINTR1   10'b0000000000
// AACITrIntr1Reg at offset 0x00

`define PA_AACITRBTCLK   10'b0000000001
// AACITrBtClkPrd at offset 0x04

`define PA_AACITRDMAREG  10'b0000000010
// AACITrBtClkPrd at offset 0x08

`define PA_AACITRFST     10'b0000000011
// AACITrFIFOStat at offset 0x0C

`define PA_AACITRRF      10'b0000000100
// AACITrRxFIFO at offset 0x10

`define PA_AACITRTF      10'b0000000101
// AACITrTxFIFO at offset 0x14

`define PA_AACITRINTR2   10'b0000000110
// AACITrIntr2Reg at offset 0x18

`define PA_AACITRCLKREG  10'b0000000111
// AACITrClkreg at offset 0x1C

// Common registers at the AACI base
// ---------------------------------

`define PA_AACITRRESET   10'b0000011111
// AACITrRESET at offset 0x7C

`define PA_AACITSYNC     10'b0000100000
// AACITrSYNC at offset 0x80

// --============================== End ==============================--
