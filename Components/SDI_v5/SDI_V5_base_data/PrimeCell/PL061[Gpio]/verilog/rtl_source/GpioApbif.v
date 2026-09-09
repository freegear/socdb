//  ====================================================================
//  This Confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  --------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : GpioApbif.v.rca
//  File Revision          : 1.1
//
//  Release Information    : PrimeCell(TM)-PL061-REL1v0
//
//  --------------------------------------------------------------------
//
// ---------------------------------------------------------------------
// Purpose                 : GpioApbif is the APB interface for the Gpio
//
// =====================================================================

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module GpioApbif (
// Inputs
                  PCLK,
                  PRESETn,
                  PSEL,
                  PENABLE,
                  PWRITE,
                  PWDATA,
                  PADDR,
                  GPINSync2,
                  GPIORIS,
                  nGPAFENtst,
                  GPAFOUTtst,
                  GPAFINtst,
                  Revision,

// Outputs
                  PRDATA,
                  nGPIODIR,
                  GPIODATA,
                  GPIOAFSEL,
                  GPIOIS,
                  GPIOIEV,
                  GPIOIC,
                  GPIOIBE,
                  GPIOINTR,
                  GPIOMIS,
                  GPIOITCR,
                  GPIOITIP1,
                  GPIOITIP2,
                  GPIOITOP3
                 );

// Inputs
input        PCLK;         // APB clock
input        PRESETn;      // AMBA reset
input        PSEL;         // APB periph. select
input        PENABLE;      // APB enable
input        PWRITE;       // APB write
input  [7:0] PWDATA;       // APB write data
input [11:2] PADDR;        // APB address bus
input  [7:0] GPINSync2;    // status
input  [7:0] GPIORIS;      // GPIO RAW int. status
input  [7:0] nGPAFENtst;   // p 1 Read
input  [7:0] GPAFOUTtst;   // p 2 Read
input  [7:0] GPAFINtst;    // p 3 Read
input  [3:0] Revision;     // Revision Number

// Outputs
output [7:0] PRDATA;      // APB read data
output [7:0] nGPIODIR;    // GPIO o/p enable
output [7:0] GPIODATA;    // GPIO o/p pin/status
output [7:0] GPIOAFSEL;   // Alt.Funct. select
output [7:0] GPIOIS;      // GPIO int. sense
output [7:0] GPIOIEV;     // GPIO int. event
output [7:0] GPIOIC;      // GPIO int. clear
output [7:0] GPIOIBE;     // GPIO int. both edge
output       GPIOINTR;    // GPIO INTERRUPT O/P
output [7:0] GPIOMIS;     // GPIO Masked Interr.
output       GPIOITCR;    // GPIO Test Ctrl. reg
output [7:0] GPIOITIP1;   // Integr. test i/p 1
output [7:0] GPIOITIP2;   // Integr. test i/p 2
output [7:0] GPIOITOP3;   // Integr. test o/p 3

// Inputs
wire        PCLK;         // APB clock
wire        PRESETn;      // AMBA reset
wire        PSEL;         // APB periph. select
wire        PENABLE;      // APB enable
wire        PWRITE;       // APB write
wire  [7:0] PWDATA;       // APB write data
wire [11:2] PADDR;        // APB address bus
wire  [7:0] GPINSync2;    // status
wire  [7:0] GPIORIS;      // GPIO RAW int. status
wire  [7:0] nGPAFENtst;   // p 1 Read
wire  [7:0] GPAFOUTtst;   // p 2 Read
wire  [7:0] GPAFINtst;    // p 3 Read
wire  [3:0] Revision;     // Revision Number

// Outputs
wire [7:0] PRDATA;      // APB read data
wire [7:0] nGPIODIR;    // GPIO o/p enable
wire [7:0] GPIODATA;    // GPIO o/p pin/status
wire [7:0] GPIOAFSEL;   // Alt.Funct. select
wire [7:0] GPIOIS;      // GPIO int. sense
wire [7:0] GPIOIEV;     // GPIO int. event
wire [7:0] GPIOIC;      // GPIO int. clear
wire [7:0] GPIOIBE;     // GPIO int. both edge
wire       GPIOINTR;    // GPIO INTERRUPT O/P
wire [7:0] GPIOMIS;     // GPIO Masked Interr.
wire       GPIOITCR;    // GPIO Test Ctrl. reg
wire [7:0] GPIOITIP1;   // Integr. test i/p 1
wire [7:0] GPIOITIP2;   // Integr. test i/p 2
wire [7:0] GPIOITOP3;   // Integr. test o/p 3

//----------------------------------------------------------------------
//
//                           GpioApbif
//                           =========
//
//----------------------------------------------------------------------
//
// Overview
// ========
// The APB interface generates  the internal decodes  and  the correspon
// ding read and write enables for the various registers.
//
// The different registers of the Gpio are within this block. Writes and
// reads to  these registers, qualified  with  their  respective  select
// signals,  will update  the corresponding registers  on  a  write, and
// present the latest data on a read.
// The individual bits  in the GPIODATA register  are  updated  with the
// data  on the input lines  GPIN  when  the corresponding bits  in  the
// GPIODIR register are set to 0.
// If the bits of the GPIODIR register are set to 1, the contents of the
// corresponding bits  in the GPIODATA register are output  on the GPOUT
// lines.
//
//----------------------------------------------------------------------
//                         Gpio Register Map
//----------------------------------------------------------------------
// Offset  Read [8bit)    Write [8bit)  Description
//----------------------------------------------------------------------
// 0x000   GPIODATA       GPIODATA      Data register
// 0x400   GPIODIR        GPIODIR       Data Direction register
// 0x404   GPIOIS         GPIOIS        Interrupt Sense register
// 0x408   GPIOIBE        GPIOIBE       Interrupt Both Edges register
// 0x40C   GPIOIEV        GPIOIEV       Interrupt EVent register
// 0x410   GPIOIE         GPIOIE        Interrupt Enable register
// 0x414   GPIORIS        ----          Raw Interrupt register
// 0x418   GPIOMIS        ----          Masked Interrupt register
// 0x41C   ----           GPIOIC        Interrupt Clear register
// 0x420   GPIOAFSEL      GPIOAFSEL     Alternate Functionality reg.
// 0x600   GPIOITCR[1b)   GPIOITCR[1b)  Integration Test Control reg.
// 0x604   ----           GPIOITOP1     Integration Test Output Set reg
// 0x608   ----           GPIOITOP2[1b) Integr. Interrupt Test O/P Read
// 0x60C   GPIOITOP3      GPIOITOP3
// 0x610   GPIOITIP1      GPIOITIP1
// 0x614   GPIOITIP2      GPIOITIP2
// 0xFE0   PERIPHERALID0  ----          Identification[0] register
// 0xFE4   PERIPHERALID1  ----          Identification[1) register
// 0xFE8   PERIPHERALID2  ----          Identification[2) register
// 0xFEC   PERIPHERALID3  ----          Identification[3) register
// 0xFF0   OCTOPUSID0     ----          Octopus Identification[0] reg.
// 0xFF4   OCTOPUSID1     ----          Octopus Identification[1) reg.
// 0xFF8   OCTOPUSID2     ----          Octopus Identification[2) reg.
// 0xFFC   OCTOPUSID3     ----          Octopus Identification[3) reg.

//----------------------------------------------------------------------

//----------------------------------------------------------------------
//
// Internal Constants
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Normal mode registers' address `defines
//----------------------------------------------------------------------

`define GPIODATA_ADDR      2'b00
`define GPIODIR_ADDR       10'b0100000000
`define GPIOIS_ADDR        10'b0100000001
`define GPIOIBE_ADDR       10'b0100000010
`define GPIOIEV_ADDR       10'b0100000011
`define GPIOIE_ADDR        10'b0100000100
`define GPIORIS_ADDR       10'b0100000101
`define GPIOMIS_ADDR       10'b0100000110
`define GPIOIC_ADDR        10'b0100000111
`define GPIOAFSEL_ADDR     10'b0100001000

`define GPIOITCR_ADDR      10'b0110000000
`define GPIOITIP1_ADDR     10'b0110000001
`define GPIOITIP2_ADDR     10'b0110000010
`define GPIOITOP1_ADDR     10'b0110000011
`define GPIOITOP2_ADDR     10'b0110000100
`define GPIOITOP3_ADDR     10'b0110000101

//----------------------------------------------------------------------
// Peripheral Identification registers' address `defines
//----------------------------------------------------------------------

`define PERIPHID0_ADDR     10'b1111111000
`define PERIPHID1_ADDR     10'b1111111001
`define PERIPHID2_ADDR     10'b1111111010
`define PERIPHID3_ADDR     10'b1111111011
`define OCTOPSID0_ADDR     10'b1111111100
`define OCTOPSID1_ADDR     10'b1111111101
`define OCTOPSID2_ADDR     10'b1111111110
`define OCTOPSID3_ADDR     10'b1111111111

//----------------------------------------------------------------------
// Peripheral Identification registers' contents
//----------------------------------------------------------------------
// PartNumber    = 0x061
// Designer      == 0x41
// Configuration == 0x00

`define PartNumber        12'b000001100001
`define Designer          8'b01000001
`define iConfiguration    8'b00000000

`define iOctopusID        32'b10110001000001011111000000001101

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------

//----------------------------------------------------------------------
// ID Internal Signals
//----------------------------------------------------------------------
wire [31:0] OCTOPUSID;
wire [31:0] PERIPHERALID;

// The 4-bit revision number must be implemented as read only D-types to
// allow for ECO metal fixes to update the revision number.

// ID, OCTOPUS code can be seen at the end of the file


// Read Fill Vector
wire [7:0] ZeroFill;

wire [7:0] GPIODIR;
// GPIO DATA DIRECTION REGISTER

reg [7:0] GPIOMISint;
// GPIO Masked Interrupt Status Register

wire [7:0] GPIOIE;
// GPIO Interrupt Enable Register

wire [7:0] GPIOITOP1;
// GPIO  Integration Masked Interrupt Output Set Register

wire [11:2] GatedPADDR;
// Gated version of PADDR

wire Rden;
// Internal read enable signal

wire Wren;
// Internal write enable signal

wire PRDATAEn;
// Internal PRDATA write enable signal

wire [7:0] PWDATAIn;
// Internal Write Data Bus, to reduce power consumption

//signal Prdatamux;
// Internal read data bus

wire GPIODATArd;
// GPIODATA read enable signal

wire GPIODIRrd;
// GPIODIR read enable signal

wire GPIOISrd;
// GPIOIS read enable signal

wire GPIOIBErd;
// GPIOIBE read enable signal

wire GPIOIEVrd;
// GPIOIEV read enable signal

wire GPIOIErd;
// GPIOIE read enable signal

wire GPIORISrd;
// GPIORIS read enable signal

wire GPIOMISrd;
// GPIOMIS read enable signal

wire GPIOAFSELrd;
// GPIOAFSEL read enable signal

wire GPIOITCRrd;
// GPIOTestControlRegister read enable signal(read strobe)

wire GPIOITOP2rd;
// GPIOTestOutputRegister GPIOINTR status read enable signal

wire GPIOITOP3rd;
// GPIOTestOutputRegister GPAFIN status read enable signal

wire GPIOITIP1rd;
// GPIOTestInputRegister GPAFOUT status read enable signal

wire GPIOITIP2rd;
// GPIOTestInputRegister nGPAFEN status read enable signal

wire PERIPHID0rd;
// PERIPHERALID0 read enable signal

wire PERIPHID1rd;
// PERIPHERALID1 read enable signal

wire PERIPHID2rd;
// PERIPHERALID2 read enable signal

wire PERIPHID3rd;
// PERIPHERALID3 read enable signal

wire OCTOPSID0rd;
// OCTOPUSID0 read enable signal

wire OCTOPSID1rd;
// OCTOPUSID1 read enable signal

wire OCTOPSID2rd;
// OCTOPUSID2 read enable signal

wire OCTOPSID3rd;
// OCTOPUSID3 read enable signal

wire GPIODATAwr;
// GPIODATA write enable signal

wire GPIODIRwr;
// GPIODIR write enable signal

wire GPIOISwr;
// GPIOIS write enable signal

wire GPIOIBEwr;
// GPIOIBE write enable signal

wire GPIOIEVwr;
// GPIOIEV write enable signal

wire GPIOIEwr;
// GPIOIE write enable signal

wire GPIOICwr;
// GPIOIC write enable signal

wire GPIOAFSELwr;
// GPIOAFSEL write enable signal

wire GPIOITCRwr;
// GPIOITCR write enable signal

wire GPIOITOP1wr;
// GPIOITOP1 write enable signal

wire GPIOITOP3wr;
// GPIOTestOutputRegister write enable signal

wire GPIOITIP1wr;
// GPIOTestInputRegister write enable signal

wire GPIOITIP2wr;
// GPIOTestInputRegister write enable signal

wire [7:0] NextPRDATA;
// D-input of PRDATA

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg [7:0] iPRDATA;
// local copy of output PRDATA

reg [7:0] iGPIODATA;
// local copy of GPIODATA

reg [7:0] iGPIODIR;
// local copy of GPIODIR

reg [7:0] iGPIOIS;
// local copy of GPIOIS

reg [7:0] iGPIOIBE;
// local copy of GPIOIBE

reg [7:0] iGPIOIEV;
// local copy of GPIOIEV

reg [7:0] iGPIOIE;
// local copy of GPIOIE

reg [7:0] iGPIOMIS;
// local copy of GPIOMIS

reg iGPIOINTR;
// local copy of GPIOINTR

reg [7:0] iGPIOIC;
// local copy of GPIOIC

reg [7:0] iGPIOAFSEL;
// local copy of GPIOAFSEL

reg iGPIOITCR;
// local copy of GPIOITCR

reg [7:0] iGPIOITOP1;
// local copy of GPIOITOP1

reg [7:0] iGPIOITOP3;
// local copy of

reg [7:0] iGPIOITIP1;
// local copy of

reg [7:0] iGPIOITIP2;
// local copy of

reg [7:0] NextGPIODATA;
// D-input of GPIODATA

reg [7:0] NextGPIODIR;
// D-input of GPIODIR

reg [7:0] NextGPIOIS;
// D-input of GPIOIS

reg [7:0] NextGPIOIBE;
// D-input of GPIOIBE

reg [7:0] NextGPIOIEV;
// D-input of GPIOIEV

reg [7:0] NextGPIOIE;
// D-input of GPIOIE

reg [7:0] NextGPIOIC;
// D-input of GPIOIC

reg [7:0] NextGPIOAFSEL;
// D-input of GPIOAFSEL

reg NextGPIOITCR;
// D-input of GPIOITCR

reg [7:0] NextGPIOITOP1;
// D-input of GPIOITOP1

reg [7:0] NextGPIOITOP3;
// D-input of

reg [7:0] NextGPIOITIP1;
// D-input of

reg [7:0] NextGPIOITIP2;
// D-input of

integer i;
// Internal Loop variable

reg [7:0] GPIODATAWrm;
// Internal Write Strobe bus masked with GatedPADDR

reg [7:0] GPIODATAm;
// Internal Masked version of GPIODATA

//----------------------------------------------------------------------
//
// Main body of code
// =================
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Write Interface
//----------------------------------------------------------------------
//
// Write databus is gated with PSEL  and  PWRITE to reduce power consump
// tion. This prevents toggling of the internal write databus when there
// are no writes or when the device is not selected.  The address bus is
// gated with PSEL  to prevent internal toggling when the device is  not
// selected.
//----------------------------------------------------------------------
assign PWDATAIn    = ((PSEL ==  1'b1) && (PWRITE == 1'b1)) ?  PWDATA
                      : 8'b00000000;

assign GatedPADDR  = (PSEL == 1'b1) ? (PADDR) : 10'b0000000000;

assign Wren        = PENABLE & PWRITE & PSEL;

// The GPIO must provide the data during the Enable cycle, as stated in
// the AMBA Specification. The data is sampled by the APB on the next
// rising edge of PCLK.

//----------------------------------------------------------------------
// Normal Mode Register Write Decodes
//----------------------------------------------------------------------

assign GPIODATAwr  = ((Wren == 1'b1) &&
                      (GatedPADDR[11:10] == `GPIODATA_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIODIRwr   = ((Wren == 1'b1) && (GatedPADDR == `GPIODIR_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOISwr    = ((Wren == 1'b1) && (GatedPADDR == `GPIOIS_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOIBEwr   = ((Wren == 1'b1) && (GatedPADDR == `GPIOIBE_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOIEVwr   = ((Wren == 1'b1) && (GatedPADDR == `GPIOIEV_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOIEwr    = ((Wren == 1'b1) && (GatedPADDR == `GPIOIE_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOICwr    = ((Wren == 1'b1) && (GatedPADDR == `GPIOIC_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOAFSELwr = ((Wren == 1'b1) && (GatedPADDR == `GPIOAFSEL_ADDR))
                     ? 1'b1 : 1'b0;

//----------------------------------------------------------------------
// Test  Mode Register Write Decodes
//----------------------------------------------------------------------
assign GPIOITCRwr  = ((Wren == 1'b1) && (GatedPADDR == `GPIOITCR_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITOP1wr = ((Wren == 1'b1) && (GatedPADDR == `GPIOITOP1_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITOP3wr = ((Wren == 1'b1) && (GatedPADDR == `GPIOITOP3_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITIP1wr = ((Wren == 1'b1) && (GatedPADDR == `GPIOITIP1_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITIP2wr = ((Wren == 1'b1) && (GatedPADDR == `GPIOITIP2_ADDR))
                     ? 1'b1 : 1'b0;

//----------------------------------------------------------------------
// Read Interface
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Normal Mode Register Read Decodes
//----------------------------------------------------------------------

// Assign Read Fill Vector
assign ZeroFill = 8'b00000000;

assign Rden        = PSEL & (~PWRITE) & (~PENABLE);

assign PRDATAEn    = PSEL & (~PWRITE) & (~PENABLE);

assign GPIODATArd  = ((Rden == 1'b1) && (GatedPADDR[11:10] ==
					   `GPIODATA_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIODIRrd   = ((Rden == 1'b1) && (GatedPADDR == `GPIODIR_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOISrd    = ((Rden == 1'b1) && (GatedPADDR == `GPIOIS_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOIBErd   = ((Rden == 1'b1) && (GatedPADDR == `GPIOIBE_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOIEVrd   = ((Rden == 1'b1) && (GatedPADDR == `GPIOIEV_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOIErd    = ((Rden == 1'b1) && (GatedPADDR == `GPIOIE_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIORISrd   = ((Rden == 1'b1) && (GatedPADDR == `GPIORIS_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOMISrd   = ((Rden == 1'b1) && (GatedPADDR == `GPIOMIS_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOAFSELrd = ((Rden == 1'b1) && (GatedPADDR == `GPIOAFSEL_ADDR))
                     ? 1'b1 : 1'b0;

//----------------------------------------------------------------------
// Test Mode Register Read Decodes
//----------------------------------------------------------------------

assign GPIOITCRrd  = ((Rden == 1'b1) && (GatedPADDR == `GPIOITCR_ADDR))
                     ? 1'b1 : 1'b0;
assign GPIOITOP2rd = ((Rden == 1'b1) && (GatedPADDR == `GPIOITOP2_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITOP3rd = ((Rden == 1'b1) && (GatedPADDR == `GPIOITOP3_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITIP1rd = ((Rden == 1'b1) && (GatedPADDR == `GPIOITIP1_ADDR))
                     ? 1'b1 : 1'b0;

assign GPIOITIP2rd = ((Rden == 1'b1) && (GatedPADDR == `GPIOITIP2_ADDR))
                     ? 1'b1 : 1'b0;
//----------------------------------------------------------------------
// Identification Mode Register Read Decodes
//----------------------------------------------------------------------

assign PERIPHID0rd = ((Rden == 1'b1) && (GatedPADDR == `PERIPHID0_ADDR))
                     ? 1'b1 : 1'b0;

assign PERIPHID1rd = ((Rden == 1'b1) && (GatedPADDR == `PERIPHID1_ADDR))
                     ? 1'b1 : 1'b0;

assign PERIPHID2rd = ((Rden == 1'b1) && (GatedPADDR == `PERIPHID2_ADDR))
                     ? 1'b1 : 1'b0;

assign PERIPHID3rd = ((Rden == 1'b1) && (GatedPADDR == `PERIPHID3_ADDR))
                     ? 1'b1 : 1'b0;

assign OCTOPSID0rd = ((Rden == 1'b1) && (GatedPADDR == `OCTOPSID0_ADDR))
                     ? 1'b1 : 1'b0;

assign OCTOPSID1rd = ((Rden == 1'b1) && (GatedPADDR == `OCTOPSID1_ADDR))
                     ? 1'b1 : 1'b0;

assign OCTOPSID2rd = ((Rden == 1'b1) && (GatedPADDR == `OCTOPSID2_ADDR))
                     ? 1'b1 : 1'b0;

assign OCTOPSID3rd = ((Rden == 1'b1) && (GatedPADDR == `OCTOPSID3_ADDR))
                     ? 1'b1 : 1'b0;

//----------------------------------------------------------------------
// Implementation of Mux to read data from selected registers.
//
// When the peripheral is not being accessed, 1'b0s are driven on the
// Read Databus (PRDATA) so as not to place any restrictions on the
// method of external bus connection. The external data buses of the
// peripherals on the APB may then be connected to the AHB-to-APB
// bridge using either a Muxed or ORed bus connection method.
//----------------------------------------------------------------------

assign NextPRDATA = (GPIODATArd == 1'b1)  ? GPIODATAm           :
                    (GPIODIRrd  == 1'b1)  ? GPIODIR             :
                    (GPIOISrd == 1'b1)    ? iGPIOIS             :
                    (GPIOIBErd == 1'b1)   ? iGPIOIBE            :
                    (GPIOIEVrd == 1'b1)   ? iGPIOIEV            :
                    (GPIOIErd == 1'b1)    ? iGPIOIE             :
                    (GPIORISrd == 1'b1)   ? GPIORIS             :
                    (GPIOMISrd == 1'b1)   ? iGPIOMIS            :
                    (GPIOAFSELrd == 1'b1) ? iGPIOAFSEL          :
                    (GPIOITCRrd == 1'b1 ) ? {ZeroFill[7:1], iGPIOITCR}:
                    (GPIOITOP2rd == 1'b1) ? {ZeroFill[7:1], iGPIOINTR}:
                    (GPIOITOP3rd == 1'b1) ? GPAFINtst           :
                    (GPIOITIP1rd == 1'b1) ? GPAFOUTtst          :
                    (GPIOITIP2rd == 1'b1) ? nGPAFENtst          :
                    (PERIPHID0rd == 1'b1) ? PERIPHERALID[7:0]   :
                    (PERIPHID1rd == 1'b1) ? PERIPHERALID[15:8]  :
                    (PERIPHID2rd == 1'b1) ? PERIPHERALID[23:16] :
                    (PERIPHID3rd == 1'b1) ? PERIPHERALID[31:24] :
                    (OCTOPSID0rd == 1'b1) ? OCTOPUSID[7:0]      :
                    (OCTOPSID1rd == 1'b1) ? OCTOPUSID[15:8]     :
                    (OCTOPSID2rd == 1'b1) ? OCTOPUSID[23:16]    :
                    (OCTOPSID3rd == 1'b1) ? OCTOPUSID[31:24]    :
                    ZeroFill;

always @(posedge PCLK or negedge PRESETn)
begin : p_Read_seq
  if (PRESETn == 1'b0)
    iPRDATA <= 8'b00000000;
  else
    iPRDATA <= NextPRDATA;
end // p_Read_seq;

assign PRDATA = iPRDATA;

//----------------------------------------------------------------------
// Implementation of Data register Write Mask
//----------------------------------------------------------------------
// purpose :  To gate  the write strobe  with  the corresponding bits in
// the Address lines GatedPADDR.

always @(GatedPADDR or GPIODATAwr)
begin : p_Dwm_comb
  for (i = 7; i >= 0; i = i - 1)
    GPIODATAWrm[i] = (GatedPADDR[i+2] & GPIODATAwr);
end // p_Dwm_comb;

//----------------------------------------------------------------------
// Implementation of Data register Read Mask
//----------------------------------------------------------------------
always @(iGPIODATA or GatedPADDR)	
begin : p_Drm_comb
  for (i = 7; i >= 0; i = i - 1)
    GPIODATAm[i] = (GatedPADDR[i+2] & iGPIODATA[i]);
end // p_Drm_comb;

//----------------------------------------------------------------------
// Implementation of data register
//----------------------------------------------------------------------
always @(GPINSync2 or iGPIODIR or iGPIODATA or GPIODATAWrm or
		       PWDATAIn)
begin : p_Data_comb
  for (i = 7; i >= 0; i = i - 1)
    begin
      if (iGPIODIR[i] == 1'b0)
        NextGPIODATA[i] = GPINSync2[i];
      else if (GPIODATAWrm[i] == 1'b1)
        NextGPIODATA[i] = PWDATAIn[i];
      else
         NextGPIODATA[i] = iGPIODATA[i];
    end
end // p_Data_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Data_seq
  if (PRESETn == 1'b0)
    iGPIODATA <= 8'b00000000;
  else
    iGPIODATA <= NextGPIODATA;
end // p_Data_seq;

assign GPIODATA = iGPIODATA;

//----------------------------------------------------------------------
// Implementation of data direction register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIODIRwr or iGPIODIR)
begin : p_Datdir_comb
  if (GPIODIRwr == 1'b1)
    NextGPIODIR = PWDATAIn;
  else
    NextGPIODIR = iGPIODIR;
end // p_Datdir_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Datdir_seq
  if (PRESETn == 1'b0)
    iGPIODIR <= 8'b00000000;
  else
    iGPIODIR <= NextGPIODIR;
end // p_Datdir_seq;

assign GPIODIR = iGPIODIR;
assign nGPIODIR =  ~(GPIODIR);

//----------------------------------------------------------------------
// Implementation of Interrupt Sense register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOISwr or iGPIOIS)
begin : p_Is_comb
  if (GPIOISwr == 1'b1)
    NextGPIOIS = PWDATAIn;
  else
    NextGPIOIS = iGPIOIS;
end // p_Is_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Is_seq
  if (PRESETn == 1'b0)
    iGPIOIS <= 8'b00000000;
  else
    iGPIOIS <= NextGPIOIS;
end // p_Is_seq;

assign GPIOIS = iGPIOIS;

//----------------------------------------------------------------------
// Implementation of Interrupt Both Edges register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOIBEwr or iGPIOIBE)
begin : p_Ibe_comb
  if (GPIOIBEwr == 1'b1)
    NextGPIOIBE = PWDATAIn;
  else
    NextGPIOIBE = iGPIOIBE;
end // p_Ibe_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Ibe_seq
  if (PRESETn == 1'b0)
    iGPIOIBE <= 8'b00000000;
  else
    iGPIOIBE <= NextGPIOIBE;
end // p_Ibe_seq;

assign GPIOIBE = iGPIOIBE;

//----------------------------------------------------------------------
// Implementation of Interrupt EVent register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOIEVwr or iGPIOIEV)
begin : p_Iev_comb
  if (GPIOIEVwr == 1'b1)
    NextGPIOIEV = PWDATAIn;
  else
    NextGPIOIEV = iGPIOIEV;
end // p_Iev_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Iev_seq
  if (PRESETn == 1'b0)
    iGPIOIEV <= 8'b00000000;
  else
    iGPIOIEV <= NextGPIOIEV;
end // p_Iev_seq;

assign GPIOIEV = iGPIOIEV;

//----------------------------------------------------------------------
// Implementation of Interrupt Enable register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOIEwr or iGPIOIE)
begin : p_Ie_comb
  if (GPIOIEwr == 1'b1)
    NextGPIOIE = PWDATAIn;
  else
    NextGPIOIE = iGPIOIE;
end // p_Ie_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Ie_seq
  if (PRESETn == 1'b0)
    iGPIOIE <= 8'b00000000;
  else
    iGPIOIE <= NextGPIOIE;
end // p_Ie_seq;

assign GPIOIE = iGPIOIE;

//----------------------------------------------------------------------
// Implementation of Integration Test Control Register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOITCRwr or iGPIOITCR)
begin : p_Tcr_comb
  if (GPIOITCRwr == 1'b1)
    NextGPIOITCR = PWDATAIn[0];
  else
    NextGPIOITCR = iGPIOITCR;
end // p_Tcr_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Tcr_seq
  if (PRESETn == 1'b0)
    iGPIOITCR <= 1'b0;
  else
    iGPIOITCR <= NextGPIOITCR;
end // p_Tcr_seq;

assign GPIOITCR = iGPIOITCR;

//----------------------------------------------------------------------
// Implementation of Integration Test Output Set Register
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOITOP1wr or iGPIOITOP1)
begin : p_Top_comb
  if (GPIOITOP1wr == 1'b1)
    NextGPIOITOP1 = PWDATAIn;
  else
    NextGPIOITOP1 = iGPIOITOP1;
end // p_Top_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Top_seq
  if (PRESETn == 1'b0)
    iGPIOITOP1 <= 8'b00000000;
  else
    iGPIOITOP1 <= NextGPIOITOP1;
end // p_Top_seq;

assign GPIOITOP1 = iGPIOITOP1;

//----------------------------------------------------------------------
// Implementation of Integration Test Control Register Mux
//----------------------------------------------------------------------
always @(iGPIOITCR or iGPIOITOP1 or GPIOMISint)
begin : p_TestMux_comb
  if (iGPIOITCR == 1'b1)
    iGPIOMIS = iGPIOITOP1;
  else
    iGPIOMIS = GPIOMISint;
end // p_TestMux_comb;

assign GPIOMIS = iGPIOMIS;

//----------------------------------------------------------------------
// Raw Interrupt register is intrinsically implemented in GpioInt.vhd, v
// GPIORIS is an input to this module, so accessible from here.
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Implementation of Masked Interrupt register
//----------------------------------------------------------------------
always @(GPIORIS or iGPIOIE)
begin : p_Mis_comb
  for (i = 7; i >= 0; i = i - 1)
    GPIOMISint[i] = (GPIORIS[i] & iGPIOIE[i]);
end // p_Mis_comb;

//----------------------------------------------------------------------
// Implementation of GPIOINTR
// Single line Interrupt request output
//----------------------------------------------------------------------
always @(iGPIOMIS)
begin : p_Gpiointr_comb
    iGPIOINTR = (iGPIOMIS[7] | iGPIOMIS[6] | iGPIOMIS[5] |
	          iGPIOMIS[4] | iGPIOMIS[3] | iGPIOMIS[2] |
	          iGPIOMIS[1] | iGPIOMIS[0]);

end // p_Gpiointr_comb;

assign GPIOINTR = iGPIOINTR;

//----------------------------------------------------------------------
// Implementation of Interrupt Clear register                          *
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOICwr)
begin : p_Ic_comb
  if (GPIOICwr == 1'b1)
    NextGPIOIC = PWDATAIn;
  else
    NextGPIOIC = 8'b00000000;
end // p_Ic_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Ic_seq
  if (PRESETn == 1'b0)
    iGPIOIC <= 8'b00000000;
  else
    iGPIOIC <= NextGPIOIC;
end // p_Ic_seq;

assign GPIOIC = iGPIOIC;

//----------------------------------------------------------------------
// Implementation of Alternate Functionality reg.
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOAFSELwr or iGPIOAFSEL)
begin : p_Afsel_comb
  if (GPIOAFSELwr == 1'b1)
    NextGPIOAFSEL = PWDATAIn;
  else
    NextGPIOAFSEL = iGPIOAFSEL;
end // p_Afsel_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_Afsel_seq
  if (PRESETn == 1'b0)
    iGPIOAFSEL <= 8'b00000000;
  else
    iGPIOAFSEL <= NextGPIOAFSEL;
end // p_Afsel_seq;

assign GPIOAFSEL = iGPIOAFSEL;

//----------------------------------------------------------------------
// GPIOITOP3
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOITOP3wr or iGPIOITOP3)
begin : p_III_comb
  if (GPIOITOP3wr == 1'b1)
    NextGPIOITOP3 = PWDATAIn;
  else
    NextGPIOITOP3 = iGPIOITOP3;
end // p_III_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_III_seq
  if (PRESETn == 1'b0)
    iGPIOITOP3 <= 8'b00000000;
  else
    iGPIOITOP3 <= NextGPIOITOP3;
end // p_III_seq;

assign GPIOITOP3 = iGPIOITOP3;

//----------------------------------------------------------------------
// GPIOITIP1
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOITIP1wr or iGPIOITIP1)
begin : p_I_comb
  if (GPIOITIP1wr == 1'b1)
    NextGPIOITIP1 = PWDATAIn;
  else
    NextGPIOITIP1 = iGPIOITIP1;
end // p_I_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_I_seq
  if (PRESETn == 1'b0)
    iGPIOITIP1 <=  8'b00000000;
  else
    iGPIOITIP1 <= NextGPIOITIP1;
end // p_I_seq;

assign GPIOITIP1 = iGPIOITIP1;

//----------------------------------------------------------------------
// GPIOITIP2
//----------------------------------------------------------------------
always @(PWDATAIn or GPIOITIP2wr or iGPIOITIP2)
begin : p_II_comb
  if (GPIOITIP2wr == 1'b1)
    NextGPIOITIP2 = PWDATAIn;
  else
    NextGPIOITIP2 = iGPIOITIP2;
end // p_II_comb;

always @(posedge PCLK or negedge PRESETn)
begin : p_II_seq
  if (PRESETn == 1'b0)
    iGPIOITIP2 <= 8'b00000000;
  else
    iGPIOITIP2 <= NextGPIOITIP2;
end // p_II_seq;

assign GPIOITIP2 = iGPIOITIP2;

//----------------------------------------------------------------------
// Implementation of data register
//----------------------------------------------------------------------

assign PERIPHERALID = {`iConfiguration, Revision, `Designer,
                       `PartNumber};
assign OCTOPUSID = `iOctopusID;

endmodule

//============================ End of GpioApbif ========================
