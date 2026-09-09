//-------------------------------------------------------------------------
//  The confidential and proprietary information contained in this file may
//  only be used by a person authorised under and to the extent permitted
//  by a subsisting licensing agreement from ARM Limited.
//
//
//         (C) COPYRIGHT 2003 ARM Limited.
//             ALL RIGHTS RESERVED
//
//  This entire notice must be reproduced on all copies of this file
//  and copies of this file may only be made by a person if such person is
//  permitted to do so under the terms of a subsisting license agreement
//  from ARM Limited.
//
// Filename   : ARM926EJSCore_test.v,v
// Date       : 2002/10/28 13:48:24
// Revision   : 1.12
// Release Information : ARM926EJS_r0p5-00rel0 
//
//-------------------------------------------------------------------------

`timescale 1 ns / 10 ps

`include "smt_debug.vh"

module ARM926EJSCore (

   // ARM926EJ-S macrocell outputs
  STANDBYWFI, CFGBIGEND, DHADDR, DHTRANS, DHBURST, DHWRITE, DHSIZE, 
  DHBL, DHPROT, DHWDATA, DHBUSREQ, DHLOCK, IHADDR, IHTRANS, IHBURST, 
  IHWRITE, IHSIZE, IHPROT, IHBUSREQ, IHLOCK, CPCLKEN, CPINSTR, 
  CPDOUT, CPPASS, CPLATECANCEL, nCPINSTRVALID, nCPMREQ, nCPTRANS, 
  CPABORT, COMMRX, COMMTX, DBGACK, DBGRQI, DBGINSTREXEC, DBGRNG, 
  DBGTDO, DBGIR, DBGSCREG, DBGTAPSM, DBGnTDOEN, DBGSDIN, ETMBIGEND, 
  ETMHIVECS, ETMIA, ETMInMREQ, ETMISEQ, ETMITBIT, ETMIJBIT, 
  ETMZIFIRST, ETMZILAST, ETMIABORT, ETMDA, ETMDMAS, ETMDMORE, 
  ETMDnMREQ, ETMDnRW, ETMDSEQ, ETMRDATA, ETMDABORT, ETMWDATA, 
  ETMnWAIT, ETMDBGACK, ETMINSTREXEC, ETMRNGOUT, ETMID31To25, 
  ETMID15To11, ETMCHSD, ETMCHSE, ETMPASS, ETMLATECANCEL, ETMPROCID, 
  ETMPROCIDWR, ETMINSTRVALID, DRnRW, DRADDR, DRWD, DRIDLE, DRCS, 
  DRWBL, DRSEQ, IRnRW, IRADDR, IRWD, IRIDLE, IRCS, IRWBL, IRSEQ, 

   // ARM926EJ-S macrocell inputs
  CLK, nFIQ, nIRQ, VINITHI, BIGENDINIT, TAPID, HRESETn, DHCLKEN, DHGRANT, 
  DHREADY, DHRESP, DHRDATA, IHCLKEN, IHGRANT, IHREADY, IHRESP, 
  IHRDATA, CPDIN, CHSDE, CHSEX, CPBURST, CPEN, DBGEN, EDBGRQ, DBGEXT, 
  DBGIEBKPT, DBGDEWPT, DBGnTRST, DBGTCKEN, DBGTDI, DBGTMS, DBGSDOUT, 
  ETMEN, FIFOFULL, DRRD, DRWAIT, DRSIZE, IRRD, IRWAIT, IRSIZE, 
  INITRAM,DRDMAEN,DRDMACS,DRDMAADDR,IRDMAEN,IRDMACS,IRDMAADDR,


 

   // FPGA debug outputs

`ifdef FPGA
  DBG0,DBG1,DSWITCH,
`endif

   // MMU RAM interface

  MMUxADDR,MMUxWD,MMUxCS,MMUxWE,MMUxRD,
 

   // DCACHE RAM interface

 DCACHESIZE,
 DCTAGCS,
 DCTAGA,DCTAGWE,DCTAGRD0,DCTAGRD1,DCTAGRD2,DCTAGRD3,DCTAGWD,DCDATACS,DCDATAINDEX,
 DCDATAWORDB0,DCDATAWORDB1,DCDATAWORDB2,DCDATAWORDB3,DCDATABYTEWE,DCDATARD0,
 DCDATARD1,DCDATARD2,DCDATARD3,DCDATAWD0,DCDATAWD1,DCDATAWD2,DCDATAWD3,DCVALIDCS,
 DCVALIDA,DCVALIDWE,DCVALIDRD,DCVALIDWD,DCNoRRgen,DCDIRTYCS,DCDIRTYA,DCDIRTYWE,
 DCDIRTYRD,DCDIRTYWD,

 DCBISTEN,DCBISTA,DCBISTTAGCS,DCBISTDATACS,DCBISTVALIDCS,DCBISTDIRTYCS,

   // ICACHE RAM interface

 ICACHESIZE,
 ICTAGCS,
 ICTAGA,ICTAGWE,ICTAGRD0,ICTAGRD1,ICTAGRD2,ICTAGRD3,ICTAGWD,ICDATACS,ICDATAINDEX,
 ICDATAWORDB0,ICDATAWORDB1,ICDATAWORDB2,ICDATAWORDB3,ICDATABYTEWE,ICDATARD0,
 ICDATARD1,ICDATARD2,ICDATARD3,ICDATAWD0,ICDATAWD1,ICDATAWD2,ICDATAWD3,ICVALIDCS,
 ICVALIDA,ICVALIDWE,ICVALIDRD,ICVALIDWD,ICNoRRgen,

 ICBISTEN,ICBISTA,ICBISTTAGCS,ICBISTDATACS,ICBISTVALIDCS,

 SCANENABLE, INTEST, EXTEST, TESTMODE

  );
  
  
   // Clock, interrupts, etc.

   input             CLK;
   input             nFIQ;
   input             nIRQ;
   output            STANDBYWFI;
   input             VINITHI;
   input             BIGENDINIT;
   output            CFGBIGEND;
   input [31:0]      TAPID;
  
   // AHB signals - Common

   input             HRESETn;

   // AHB signals - D Side

   input             DHCLKEN;
   output [31:0]     DHADDR;
   output [1:0]      DHTRANS;
   output [2:0]      DHBURST;
   output            DHWRITE;
   output [2:0]      DHSIZE;
   output [3:0]      DHBL;
   output [3:0]      DHPROT;
   input             DHGRANT;
   input             DHREADY;
   input [1:0]       DHRESP;
   output [31:0]     DHWDATA;
   input [31:0]      DHRDATA;
   output            DHBUSREQ;
   output            DHLOCK;

   // AHB signals - I Side

   input             IHCLKEN;
   output [31:0]     IHADDR;
   output [1:0]      IHTRANS;
   output [2:0]      IHBURST;
   output            IHWRITE;
   output [2:0]      IHSIZE;
   output [3:0]      IHPROT;
   input             IHGRANT;
   input             IHREADY;
   input [1:0]       IHRESP;
   input [31:0]      IHRDATA;
   output            IHBUSREQ;
   output            IHLOCK;
  
  
   // Coprocessor interface signals

   output            CPCLKEN;
   output [31:0]     CPINSTR;
   output [31:0]     CPDOUT;
   input [31:0]      CPDIN;
   output            CPPASS;
   output            CPLATECANCEL;
   input [1:0]       CHSDE;
   input [1:0]       CHSEX;
   output            nCPINSTRVALID;
   output            nCPMREQ;
   output            nCPTRANS;
   input [3:0]       CPBURST;
   output            CPABORT;
   input             CPEN;
 	  
   // Debug signals

   output            COMMRX;
   output            COMMTX;
   output            DBGACK;
   input             DBGEN;
   output            DBGRQI;
   input             EDBGRQ;
   input [1:0]       DBGEXT;
   output            DBGINSTREXEC;
   output [1:0]      DBGRNG;
   input             DBGIEBKPT;
   input             DBGDEWPT;

   // Debug JTAG signals

   input             DBGnTRST;
   input             DBGTCKEN;
   input             DBGTDI;
   input             DBGTMS;
   output            DBGTDO;
   output [3:0]      DBGIR;
   output [4:0]      DBGSCREG;
   output [3:0]      DBGTAPSM;
   output            DBGnTDOEN;
   output            DBGSDIN;
   input             DBGSDOUT;
  
   // ETM Interface signals

   input             ETMEN;
   input             FIFOFULL;
   output            ETMBIGEND;
   output            ETMHIVECS;
   output [31:0]     ETMIA;
   output            ETMInMREQ;
   output            ETMISEQ;
   output            ETMITBIT;
   output            ETMIJBIT;
   output            ETMZIFIRST;
   output            ETMZILAST;
  
   output            ETMIABORT;
   output [31:0]     ETMDA;
   output [1:0]      ETMDMAS;
   output            ETMDMORE;
   output            ETMDnMREQ;
   output            ETMDnRW;
   output            ETMDSEQ;
   output [31:0]     ETMRDATA;
   output            ETMDABORT;
   output [31:0]     ETMWDATA;
   output            ETMnWAIT;
   output            ETMDBGACK;
   output            ETMINSTREXEC;
   output [1:0]      ETMRNGOUT;
   output [31:25]    ETMID31To25;
   output [15:11]    ETMID15To11;
   output [1:0]      ETMCHSD;
   output [1:0]      ETMCHSE;
   output            ETMPASS;
   output            ETMLATECANCEL;
   output [31:0]     ETMPROCID;
   output            ETMPROCIDWR;
   output            ETMINSTRVALID;

   // TCM Interface signals (non-DMA)

   output            DRnRW;
   output [17:0]     DRADDR;
   output [31:0]     DRWD;
   output            DRIDLE;
   output            DRCS;
   output [3:0]      DRWBL;
   output            DRSEQ;
   input [31:0]      DRRD;
   input             DRWAIT;
   input [3:0]       DRSIZE;

   output            IRnRW;
   output [17:0]     IRADDR;
   output [31:0]     IRWD;
   output            IRIDLE;
   output            IRCS;
   output [3:0]      IRWBL;
   output            IRSEQ;
   input [31:0]      IRRD;
   input             IRWAIT;
   input [3:0]       IRSIZE;
   input             INITRAM;

   // TCM DMA access 
  
   input             DRDMAEN;    // DTCM DMA enable
   input             DRDMACS;    // DTCM DMA CS.
   input [17:0]      DRDMAADDR;  // DTCM DMA address.

   input             IRDMAEN;    // ITCM DMA enable
   input             IRDMACS;    // ITCM DMA CS.
   input [17:0]      IRDMAADDR;  // ITCM DMA address.

`ifdef FPGA
   output [33:0]     DBG0;       // FPGA debug output
   output [33:0]     DBG1;       // FPGA debug output
   input [7:0]       DSWITCH;    // FPGA debug input (from DIP switches)
`endif

   // MMU RAM interface

   output [4:0]      MMUxADDR;  // address
   output [111:0]    MMUxWD;    // write data
   output            MMUxCS;    // chip select
   output [3:0]      MMUxWE;    // write enable
   input [111:0]     MMUxRD;    // read data
 

   // Data cache RAM interface

   input             [ 3: 0] DCACHESIZE;
 
   // BIST signals
   input             DCBISTEN;
   input             [12: 0] DCBISTA;           // address for access (WAY + index)
   input             [ 3: 0] DCBISTTAGCS;
   input             [ 3: 0] DCBISTDATACS;
   input             DCBISTVALIDCS;
   input             DCBISTDIRTYCS;

   // TAG ram
   output            [ 3: 0] DCTAGCS;
   output            [10: 0] DCTAGA;            // maximum #bits for NSETS
   output            [ 3: 0] DCTAGWE;
   input             [21: 0] DCTAGRD0;          // tag data from way 0
   input             [21: 0] DCTAGRD1;          // tag data from way 1
   input             [21: 0] DCTAGRD2;          // tag data from way 2
   input             [21: 0] DCTAGRD3;          // tag data from way 3
   output            [21: 0] DCTAGWD;           // maximum #bits for tag
 
   // DATA ram
   output            [ 3: 0] DCDATACS;
   output            [ 9: 0] DCDATAINDEX;       // index for data access (max #bits)
   output            [ 2: 0] DCDATAWORDB0;      // word selects for a line in bank 0
   output            [ 2: 0] DCDATAWORDB1;      // word selects for a line in bank 1
   output            [ 2: 0] DCDATAWORDB2;      // word selects for a line in bank 2
   output            [ 2: 0] DCDATAWORDB3;      // word selects for a line in bank 3
   output            [ 3: 0] DCDATABYTEWE;
   input             [31: 0] DCDATARD0;         // data from bank 0
   input             [31: 0] DCDATARD1;         // data from bank 1
   input             [31: 0] DCDATARD2;         // data from bank 2
   input             [31: 0] DCDATARD3;         // data from bank 3
   output            [31: 0] DCDATAWD0;         // data to bank 0
   output            [31: 0] DCDATAWD1;         // data to bank 1
   output            [31: 0] DCDATAWD2;         // data to bank 2
   output            [31: 0] DCDATAWD3;         // data to bank 3

   // VALID ram
   output                    DCVALIDCS;
   output            [ 7: 0] DCVALIDA;          // address to valid RAM
   output                    DCVALIDWE;         // 16 valid, 8 rrgen
   input             [23: 0] DCVALIDRD;         // 16 valid, 8 rrgen
   output            [23: 0] DCVALIDWD;         // 16 valid, 8 rrgen
   input                     DCNoRRgen;

   // DIRTY ram
   output                    DCDIRTYCS;
   output            [ 9: 0] DCDIRTYA;          // address to dirty RAM
   output            [ 7: 0] DCDIRTYWE;
   input             [ 7: 0] DCDIRTYRD;
   output            [ 7: 0] DCDIRTYWD;


   // Instruction cache RAM interface

   input             [ 3: 0] ICACHESIZE;
 
   // BIST signals

   input                     ICBISTEN;
   input             [12: 0] ICBISTA;           // address for access (WAY + index)
   input             [ 3: 0] ICBISTTAGCS;
   input             [ 3: 0] ICBISTDATACS;
   input                     ICBISTVALIDCS;

   // TAG ram
   output            [ 3: 0] ICTAGCS;
   output            [10: 0] ICTAGA;            // maximum #bits for NSETS
   output            [ 3: 0] ICTAGWE;
   input             [21: 0] ICTAGRD0;          // tag data from way 0
   input             [21: 0] ICTAGRD1;          // tag data from way 1
   input             [21: 0] ICTAGRD2;          // tag data from way 2
   input             [21: 0] ICTAGRD3;          // tag data from way 3
   output            [21: 0] ICTAGWD;           // maximum #bits for tag
 
   // DATA ram
   output            [ 3: 0] ICDATACS;
   output            [ 9: 0] ICDATAINDEX;       // index for data access (max #bits)
   output            [ 2: 0] ICDATAWORDB0;      // word selects for a line in bank 0
   output            [ 2: 0] ICDATAWORDB1;      // word selects for a line in bank 1
   output            [ 2: 0] ICDATAWORDB2;      // word selects for a line in bank 2
   output            [ 2: 0] ICDATAWORDB3;      // word selects for a line in bank 3
   output            [ 3: 0] ICDATABYTEWE;
   input             [31: 0] ICDATARD0;         // data from bank 0
   input             [31: 0] ICDATARD1;         // data from bank 1
   input             [31: 0] ICDATARD2;         // data from bank 2
   input             [31: 0] ICDATARD3;         // data from bank 3
   output            [31: 0] ICDATAWD0;         // data to bank 0
   output            [31: 0] ICDATAWD1;         // data to bank 1
   output            [31: 0] ICDATAWD2;         // data to bank 2
   output            [31: 0] ICDATAWD3;         // data to bank 3

   // VALID ram
   output            ICVALIDCS;
   output            [ 7: 0] ICVALIDA;          // address to valid RAM
   output                    ICVALIDWE;         // 16 valid, 8 rrgen
   input             [23: 0] ICVALIDRD;         // 16 valid, 8 rrgen
   output            [23: 0] ICVALIDWD;         // 16 valid, 8 rrgen
   input             ICNoRRgen;

   //ATPG
   input             SCANENABLE;
   input             INTEST;
   input             EXTEST;
   input             TESTMODE;

`define IDLE   3'b000 
`define WRITE  3'b001
`define READ   3'b010
`define WR_0   3'b011
`define WR_WK1 3'b100
`define RD_WK1 3'b101
`define DONE   3'b110

`define DT_IDLE        4'b0000 
`define DT_WRITE_TAG   4'b0001
`define DT_WRITE_PATAG 4'b0010
`define DT_READ_TAG    4'b0011
`define DT_READ_PATAG  4'b0100
`define DT_WR_0        4'b0101
`define DT_WR_WK1      4'b0110
`define DT_RD_WK1      4'b0111
`define DT_DONE        4'b1000

`define MMUBG1         ((1'b1 << 30) | (1'b1 << 56) | (1'b1 << 86))
`define MMUBG2         (1'b1 | (1'b1 << 56) | (1'b1 << 86))
`define MMUBG3         (1'b1 | (1'b1 << 30) | (1'b1 << 86))
`define MMUBG4         (1'b1 | (1'b1 << 30) | (1'b1 << 56))

reg [4:0] ICVCntRng;
always @(ICNoRRgen) begin
  case (ICNoRRgen)
    1'b0 : ICVCntRng = 5'b11000;
    1'b1 : ICVCntRng = 5'b10000;
  endcase
end

reg [4:0] DCVCntRng;
always @(DCNoRRgen) begin
  case (DCNoRRgen)
    1'b0 : DCVCntRng = 5'b11000;
    1'b1 : DCVCntRng = 5'b10000;
  endcase
end

reg [12:0] ICDADDR_RNG;
reg [10:0] ICTAG_RNG;
reg [7:0] ICVALIDA_RNG;
reg [12:0] ALIAS_ICDADDR_RNG;
reg [10:0] ALIAS_ICTAG_RNG;
reg [7:0] ALIAS_ICVALIDA_RNG;
//synopsys translate_off
reg [5 * 8 : 1]  sICSIZE;
//synopsys translate_on
always @(ICACHESIZE) begin
  case (ICACHESIZE)
    4'b0011 : begin
                ICDADDR_RNG  = 13'b0000011111110;
                ICTAG_RNG    = 11'b00000011110;
                ICVALIDA_RNG = 8'b00000110;
                ALIAS_ICDADDR_RNG  = 13'b0000100000000;
                ALIAS_ICTAG_RNG    = 11'b00000100000;
                ALIAS_ICVALIDA_RNG = 8'b00001000;
                //synopsys translate_off
                sICSIZE = "4kB";
                //synopsys translate_on
              end
    4'b0100 : begin
                ICDADDR_RNG = 13'b0000111111110;
                ICTAG_RNG   = 11'b00000111110;
                ICVALIDA_RNG = 8'b00001110;
                ALIAS_ICDADDR_RNG = 13'b0001000000000;
                ALIAS_ICTAG_RNG   = 11'b00001000000;
                ALIAS_ICVALIDA_RNG = 8'b00010000;
                //synopsys translate_off
                sICSIZE = "8kB";
                //synopsys translate_on
              end
    4'b0101 : begin
                ICDADDR_RNG  = 13'b0001111111110;
                ICTAG_RNG    = 11'b00001111110;
                ICVALIDA_RNG = 8'b00011110;
                ALIAS_ICDADDR_RNG = 13'b0010000000000;
                ALIAS_ICTAG_RNG   = 11'b00010000000;
                ALIAS_ICVALIDA_RNG = 8'b00100000;
                //synopsys translate_off
                sICSIZE = "16kB";
                //synopsys translate_on
              end
    4'b0110 : begin
                ICDADDR_RNG = 13'b0011111111110;
                ICTAG_RNG = 11'b00011111110;
                ICVALIDA_RNG = 8'b00111110;
                ALIAS_ICDADDR_RNG = 13'b0100000000000;
                ALIAS_ICTAG_RNG   = 11'b00100000000;
                ALIAS_ICVALIDA_RNG = 8'b01000000;
                //synopsys translate_off
                sICSIZE = "32kB";
                //synopsys translate_on
              end
    4'b0111 : begin
                ICDADDR_RNG = 13'b0111111111110;
                ICTAG_RNG = 11'b00111111110;
                ICVALIDA_RNG = 8'b01111110;
                ALIAS_ICDADDR_RNG = 13'b1000000000000;
                ALIAS_ICTAG_RNG   = 11'b01000000000;
                ALIAS_ICVALIDA_RNG = 8'b10000000;
                //synopsys translate_off
                sICSIZE = "64kB";
                //synopsys translate_on
              end
    4'b1000 : begin
                ICDADDR_RNG = 13'b1111111111110;
                ICTAG_RNG = 11'b01111111110;
                ICVALIDA_RNG = 8'b11111110;
                ALIAS_ICDADDR_RNG = 13'b0000000000000;
                ALIAS_ICTAG_RNG   = 11'b00000000000;
                ALIAS_ICVALIDA_RNG = 8'b00000000;
                //synopsys translate_off
                sICSIZE = "128kB";
                //synopsys translate_on
              end
    default : begin
                ICDADDR_RNG = 13'b0000000000000;
                ICTAG_RNG = 11'b00000000000;
                ICVALIDA_RNG = 8'b00000000;
                ALIAS_ICDADDR_RNG = 13'b0000000000000;
                ALIAS_ICTAG_RNG   = 11'b00000000000;
                ALIAS_ICVALIDA_RNG = 8'b00000000;
                //synopsys translate_off
                sICSIZE = "Invalid";
                //synopsys translate_on
              end
  endcase
end

reg [12:0] DCDADDR_RNG;
reg [10:0] DCTAG_RNG;
reg [10:0] DCPATAG_RNG;
reg  [7:0] DCVALIDA_RNG;
reg  [9:0] DCDIRTYA_RNG;
reg [12:0] ALIAS_DCDADDR_RNG;
reg [10:0] ALIAS_DCTAG_RNG;
reg  [7:0] ALIAS_DCVALIDA_RNG;
reg  [9:0] ALIAS_DCDIRTYA_RNG;
//synopsys translate_off
reg [5 * 8 : 1]  sDCSIZE;
//synopsys translate_on
always @(DCACHESIZE) begin
  case (DCACHESIZE)
    4'b0011 : begin
                DCDADDR_RNG = 13'b0000011111110;
                DCTAG_RNG   = 11'b00000011110;
                DCPATAG_RNG = 11'b10000011110;
                DCVALIDA_RNG = 8'b00000110;
                DCDIRTYA_RNG = 10'b0000011110;
                ALIAS_DCDADDR_RNG = 13'b0000100000000;
                ALIAS_DCTAG_RNG   = 11'b00000100000;
                ALIAS_DCVALIDA_RNG = 8'b00001000;
                ALIAS_DCDIRTYA_RNG = 10'b0000100000;
                //synopsys translate_off
                sDCSIZE = "4kB";
                //synopsys translate_on
              end
    4'b0100 : begin
                DCDADDR_RNG = 13'b0000111111110;
                DCTAG_RNG   = 11'b00000111110;
                DCPATAG_RNG = 11'b10000111110;
                DCVALIDA_RNG = 8'b00001110;
                DCDIRTYA_RNG = 10'b0000111110;
                ALIAS_DCDADDR_RNG = 13'b0001000000000;
                ALIAS_DCTAG_RNG   = 11'b00001000000;
                ALIAS_DCVALIDA_RNG = 8'b00010000;
                ALIAS_DCDIRTYA_RNG = 10'b0001000000;
                //synopsys translate_off
                sDCSIZE = "8kB";
                //synopsys translate_on
              end
    4'b0101 : begin
                DCDADDR_RNG = 13'b0001111111110;
                DCTAG_RNG   = 11'b00001111110;
                DCPATAG_RNG = 11'b10001111110;
                DCVALIDA_RNG = 8'b00011110;
                DCDIRTYA_RNG = 10'b0001111110;
                ALIAS_DCDADDR_RNG = 13'b0010000000000;
                ALIAS_DCTAG_RNG   = 11'b00010000000;
                ALIAS_DCVALIDA_RNG = 8'b00100000;
                ALIAS_DCDIRTYA_RNG = 10'b0010000000;
                //synopsys translate_off
                sDCSIZE = "16kB";
                //synopsys translate_on
              end
    4'b0110 : begin
                DCDADDR_RNG = 13'b0011111111110;
                DCTAG_RNG   = 11'b00011111110;
                DCPATAG_RNG = 11'b10011111110;
                DCVALIDA_RNG = 8'b00111110;
                DCDIRTYA_RNG = 10'b0011111110;
                ALIAS_DCDADDR_RNG = 13'b0100000000000;
                ALIAS_DCTAG_RNG   = 11'b00100000000;
                ALIAS_DCVALIDA_RNG = 8'b01000000;
                ALIAS_DCDIRTYA_RNG = 10'b0100000000;
                //synopsys translate_off
                sDCSIZE = "32kB";
                //synopsys translate_on
              end
    4'b0111 : begin
                DCDADDR_RNG = 13'b0111111111110;
                DCTAG_RNG   = 11'b00111111110;
                DCPATAG_RNG = 11'b10111111110;
                DCVALIDA_RNG = 8'b01111110;
                DCDIRTYA_RNG = 10'b0111111110;
                ALIAS_DCDADDR_RNG = 13'b1000000000000;
                ALIAS_DCTAG_RNG   = 11'b01000000000;
                ALIAS_DCVALIDA_RNG = 8'b10000000;
                ALIAS_DCDIRTYA_RNG = 10'b1000000000;
                //synopsys translate_off
                sDCSIZE = "64kB";
                //synopsys translate_on
              end
    4'b1000 : begin
                DCDADDR_RNG = 13'b1111111111110;
                DCTAG_RNG   = 11'b01111111110;
                DCPATAG_RNG = 11'b11111111110;
                DCVALIDA_RNG = 8'b11111110;
                DCDIRTYA_RNG = 10'b1111111110;
                ALIAS_DCDADDR_RNG = 13'b0000000000000;
                ALIAS_DCTAG_RNG   = 11'b00000000000;
                ALIAS_DCVALIDA_RNG = 8'b00000000;
                ALIAS_DCDIRTYA_RNG = 10'b0000000000;
                //synopsys translate_off
                sDCSIZE = "128kB";
                //synopsys translate_on
              end
    default : begin
                DCDADDR_RNG = 13'b0000000000000;
                DCTAG_RNG   = 11'b00000000000;
                DCPATAG_RNG = 11'b00000000000;
                DCVALIDA_RNG = 8'b00000000;
                DCDIRTYA_RNG = 10'b0000000000;
                ALIAS_DCDADDR_RNG = 13'b0000000000000;
                ALIAS_DCTAG_RNG   = 11'b00000000000;
                ALIAS_DCVALIDA_RNG = 8'b00000000;
                ALIAS_DCDIRTYA_RNG = 10'b0000000000;
                //synopsys translate_off
                sDCSIZE = "Invalid";
                //synopsys translate_on
              end
  endcase
end


//--------------------------------------------------
// MMU RAM Test
//--------------------------------------------------

reg [2:0] MMUState, MMUStateNext;
reg MMUBitCompare;
reg [111:0] MMUBitExpect;
reg [6:0] MMUCnt;

reg MMUCompare;
reg MMU_word_error, MMU_bit_error;
reg MMU_wordx_error, MMU_bitx_error;
reg [29:0] MMUExpect;
reg MMUxCS;
reg [3:0] MMUxWE;
reg [4:0] MMUxADDR;
reg [111:0] MMUxWD;

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    MMUState <= `IDLE;
  else 
    MMUState <= MMUStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    MMUCnt <= 7'b0000000;
  else if(MMUState == `WR_WK1)
    MMUCnt <= MMUCnt + 1;
end

always @(MMUState or MMUxADDR or MMUCnt) begin
  case(MMUState)
    `IDLE : MMUStateNext = `WRITE;
   `WRITE : MMUStateNext = (MMUxADDR == 5'b11110) ? `READ : `WRITE;
    `READ : MMUStateNext = (MMUxADDR == 5'b11110) ? `WR_0 : `READ;
    `WR_0 : MMUStateNext = `WR_WK1;
  `WR_WK1 : MMUStateNext = `RD_WK1;
  `RD_WK1 : MMUStateNext = (MMUCnt == 7'b1110000) ? `DONE : `WR_WK1;
    `DONE : MMUStateNext = `DONE;
  default : MMUStateNext = `IDLE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    MMUxCS <= 1'b0;
    MMUxWE <= 4'b0000;
    MMUxADDR <= 5'b11111;
    MMUxWD <= 112'b0;
  end else if(MMUState == `WRITE) begin
    MMUxCS <= 1'b1;
    MMUxWE <= 4'b1111;
    MMUxADDR <= MMUxADDR + 1;
    MMUxWD[29:0]   <= (MMUxWD[29:0] + 1);
    MMUxWD[55:30]  <= (MMUxWD[25:0] + 1);
    MMUxWD[85:56]  <= (MMUxWD[29:0] + 1);
    MMUxWD[111:86] <= (MMUxWD[25:0] + 1);
  end else if (MMUState == `READ) begin
    MMUxCS <= 1'b1;
    MMUxWE <= 4'b0000;
    MMUxADDR <= MMUxADDR + 1;
  end else if (MMUState == `WR_0) begin
    MMUxCS <= 1'b1;
    MMUxWE <= 4'b1111;
    MMUxADDR <= 5'b00000;
    MMUxWD <= 112'd0;
  end else if (MMUState == `WR_WK1) begin
    MMUxCS <= 1'b1;
    //MMUxWD background pattern checks for WE = | (MMUxWE[3:0])
    MMUxWD <= 1'b1 << MMUCnt | ( (MMUCnt == 7'b0000000) ? `MMUBG1 :
                                 (MMUCnt == 7'b0011111) ? `MMUBG2 :
                                 (MMUCnt == 7'b0111001) ? `MMUBG3 :
                                 (MMUCnt == 7'b1010111) ? `MMUBG4 : 112'b0); 
    MMUxWE[0] <= (MMUCnt == 7'b0000000) ? 1'b1 : | (MMUxWD[29:0]);
    MMUxWE[1] <= (MMUCnt == 7'b0011110) ? 1'b1 : | (MMUxWD[55:30]);
    MMUxWE[2] <= (MMUCnt == 7'b0111000) ? 1'b1 : | (MMUxWD[85:56]);
    MMUxWE[3] <= (MMUCnt == 7'b1010110) ? 1'b1 : | (MMUxWD[111:86]);
  end else if (MMUState == `RD_WK1) begin
    MMUxCS <= 1'b1;
    MMUxWE <= 4'b0000;
    MMUxADDR <= 5'b00000;
  end else begin
    MMUxCS <= 1'b0;
    MMUxWE <= 4'b0000;
    MMUxADDR <= 5'b11111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    MMUCompare <= 1'b0;
    MMUBitCompare <= 1'b0;
  end else begin
    MMUCompare <= MMUxCS & (MMUxWE == 4'b0000) & ((MMUState == `READ) | (MMUState == `WR_0));
    MMUBitCompare <= MMUxCS & (MMUxWE == 4'b0000) & ((MMUState == `WR_WK1) | (MMUState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    MMU_word_error <= 1'b0;
    MMU_wordx_error <= 1'b0;
    MMUExpect <= 30'd1;
    MMU_bit_error <= 1'b0;
    MMU_bitx_error <= 1'b0;
    MMUBitExpect <= 112'd1;
  end else if(MMUCompare) begin
    if(MMUxRD != ({MMUExpect[25:0],MMUExpect[29:0],MMUExpect[25:0],MMUExpect[29:0]})) begin
      MMU_word_error <= 1'b1;
    end
    //synopsys translate_off
    if(MMUxRD !== ({MMUExpect[25:0],MMUExpect[29:0],MMUExpect[25:0],MMUExpect[29:0]})) begin
      MMU_wordx_error <= 1'b1;
      $display ($time,,"MMU RAM Read Error. Expected = %x, Actual = %x",
                {MMUExpect[25:0],MMUExpect[29:0],MMUExpect[25:0],MMUExpect[29:0]},MMUxRD);
    end
    //synopsys translate_on
    MMUExpect <= MMUExpect + 1;
  end else if(MMUBitCompare) begin
    if(MMUxRD != MMUBitExpect) begin
      MMU_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(MMUxRD !== MMUBitExpect) begin
      MMU_bitx_error <= 1'b1;
      $display ($time,,"MMU RAM Read Error. Expected = %x, Actual = %x", MMUBitExpect,MMUxRD);
    end
    //synopsys translate_on
    MMUBitExpect <= 1'b1 << (MMUCnt-1);
  end
end

//--------------------------------------------------
// I-Cache Data RAM Test
//--------------------------------------------------

reg [2:0] ICDState, ICDStateNext;
reg ICDBitCompare;
reg [127:0] ICDBitExpect;
reg [7:0] ICDCnt;
reg [127:0] ICDMask;

reg ICDCompare;
reg ICD_word_error, ICD_bit_error;
reg ICD_wordx_error, ICD_bitx_error;
reg [31:0] ICDExpect;
reg [3:0] ICDATACS;
reg [31:0] ICDATAWD;
reg [3:0] ICDATABYTEWE;
reg [12:0] ICDADDR;
reg [3:0] ICDATABWE;
reg [3:0] ICDATABWENext;

wire [2:0] ICDATAWORDB0,ICDATAWORDB1,ICDATAWORDB2,ICDATAWORDB3;
wire [9:0] ICDATAINDEX;
wire [31:0] ICDExpectMask;
wire [127:0] ICDExpctMask128;
wire [31:0]  ICDExpectMasked;

assign ICDATAWORDB0 = ICDADDR[2:0];
assign ICDATAWORDB1 = ICDADDR[2:0];
assign ICDATAWORDB2 = ICDADDR[2:0];
assign ICDATAWORDB3 = ICDADDR[2:0];
assign ICDATAINDEX[9:0] = ICDADDR[12:3];

wire [31:0] ICDATAWD3,ICDATAWD2,ICDATAWD1,ICDATAWD0;
assign ICDATAWD0 = ICDATAWD;
assign ICDATAWD1 = ICDATAWD;
assign ICDATAWD2 = ICDATAWD;
assign ICDATAWD3 = ICDATAWD;

wire [127:0] ICDATARD;
assign ICDATARD = {ICDATARD3,ICDATARD2,ICDATARD1,ICDATARD0};

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICDState <= `IDLE;
  else if (MMUState == `DONE)
    ICDState <= ICDStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICDCnt <= 8'b00000000;
  else if(ICDState == `WR_WK1)
    ICDCnt <= ICDCnt + 1;
end

always @(ICDState or ICDADDR or ICDCnt or ICDADDR_RNG) begin
  case(ICDState)
    `IDLE : ICDStateNext = `WRITE;
   `WRITE : ICDStateNext = (ICDADDR == ICDADDR_RNG) ? `READ : `WRITE;
    `READ : ICDStateNext = (ICDADDR == ICDADDR_RNG) ? `WR_0 : `READ;
    `WR_0 : ICDStateNext = `WR_WK1;
  `WR_WK1 : ICDStateNext = `RD_WK1;
  `RD_WK1 : ICDStateNext = (ICDCnt == 8'b10000000) ? `DONE : `WR_WK1;
    `DONE : ICDStateNext = `DONE;
  default : ICDStateNext = `IDLE; 
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICDATACS <= 4'b0000;
    ICDATABYTEWE <= 4'b0001;
    ICDATABWENext <= 4'b0001;
    ICDADDR <= 13'b1111111111111;
    ICDATAWD <= 32'b0;
  end else if(ICDState == `WRITE) begin
    ICDATACS <= 4'b1111;
    ICDATABYTEWE <= ((ICDATABYTEWE + 1'b1) == 4'b0000) ? 4'b0001 : ICDATABYTEWE + 1'b1;
    ICDADDR <= ICDADDR + 1;
    ICDATAWD <= (ICDATAWD + 1);
  end else if (ICDState == `READ) begin
    ICDATACS <= 4'b1111;
    ICDATABYTEWE <= 4'b0000;
    ICDATABWENext <= ((ICDATABWENext + 1'b1) == 4'b0000) ? 4'b0001 : ICDATABWENext + 1'b1;
    ICDADDR <= (ICDADDR == (ICDADDR_RNG + 1)) ? 13'b0000000000000 : (ICDADDR + 1) ;
  end else if (ICDState == `WR_0) begin
    ICDATACS <= 4'b1111;
    ICDATABYTEWE <= 4'b1111;
    ICDADDR <= 13'b0000000000000;
    ICDATAWD <= 112'd0;
  end else if (ICDState == `WR_WK1) begin
    ICDADDR <= ALIAS_ICDADDR_RNG;
    ICDATACS[0] <= (ICDCnt < 8'b00100000);
    ICDATACS[1] <= (ICDCnt < 8'b01000000 && ICDCnt >= 8'b00100000);
    ICDATACS[2] <= (ICDCnt < 8'b01100000 && ICDCnt >= 8'b01000000);
    ICDATACS[3] <= (ICDCnt < 8'b10000000 && ICDCnt >= 8'b01100000);
    ICDATABYTEWE[0] <= ((ICDCnt % 32) <= 8);
    ICDATABYTEWE[1] <= (((ICDCnt % 32) >= 8) && ((ICDCnt % 32) <= 16));
    ICDATABYTEWE[2] <= (((ICDCnt % 32) >= 16) && ((ICDCnt % 32) <= 24));
    ICDATABYTEWE[3] <= ((ICDCnt % 32) >= 24);
    ICDATAWD <= 1'b1 << (ICDCnt % 32);
  end else if (ICDState == `RD_WK1) begin
    ICDATACS <= 4'b1111;
    ICDATABYTEWE <= 4'b0000;
    ICDADDR <= 13'b0000000000000;
  end else if (ICDState == `DONE) begin
    ICDATACS <= 4'b1111;
    ICDATABYTEWE <= 4'b0000;
    ICDADDR <= 13'b0000000000000;
  end else begin
    ICDATACS <= 4'b0000;
    ICDATABYTEWE <= 4'b0001;
    ICDADDR <= 13'b1111111111111;
    ICDATABWENext <= 4'b0001;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) 
    ICDATABWE <= 4'b1111;
  else
    ICDATABWE <= ICDATABWENext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICDCompare <= 1'b0;
    ICDBitCompare <= 1'b0;
  end else begin
    ICDCompare <= (ICDATACS == 4'b1111) & (ICDATABYTEWE == 4'b0000) & ((ICDState == `READ) | (ICDState == `WR_0));
    ICDBitCompare <= (ICDATACS == 4'b1111) & (ICDATABYTEWE == 4'b0000) & ((ICDState == `WR_WK1) | (ICDState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICDMask <= 128'b0;
  else if(ICDCnt == 8'd32)
    ICDMask[31:24] <= 8'b10000000;
  else if(ICDCnt == 8'd64)
    ICDMask[63:56] <= 8'b10000000;
  else if(ICDCnt == 8'd96)
    ICDMask[95:88] <= 8'b10000000;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICD_word_error <= 1'b0;
    ICD_bit_error <= 1'b0;
    ICD_wordx_error <= 1'b0;
    ICD_bitx_error <= 1'b0;
    ICDExpect <= 32'd1;
    ICDBitExpect <= 128'd1;
  end else if(ICDCompare) begin
    if((ICDATARD & ICDExpctMask128) != {4{ICDExpectMasked}}) begin
      ICD_word_error <= 1'b1;
    end
    //synopsys translate_off
    if((ICDATARD & ICDExpctMask128) !== {4{ICDExpectMasked}}) begin
      ICD_wordx_error <= 1'b1;
      $display ($time,,"I-Cache Data RAM Word Error. Expected = %x, Actual = %x",
                {ICDExpect,ICDExpect,ICDExpect,ICDExpect},ICDATARD);
    end
    //synopsys translate_on
    ICDExpect <= ICDExpect + 1;
  end else if(ICDBitCompare) begin
    if(ICDATARD != ICDBitExpect) begin
      ICD_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(ICDATARD !== ICDBitExpect) begin
      ICD_bitx_error <= 1'b1;
      $display ($time,,"I-Cache Data RAM Bit Error. Expected = %x, Actual = %x",
                ICDBitExpect,ICDATARD);
    end
    //synopsys translate_on
      ICDBitExpect <= (1'b1 << (ICDCnt-1)) ^ ICDMask;
  end
end

assign ICDExpectMasked  = ICDExpect & ICDExpectMask;

assign ICDExpectMask[31:24] = {7{ICDATABWE[3]}}; 
assign ICDExpectMask[23:16] = {7{ICDATABWE[2]}}; 
assign ICDExpectMask[15:8]  = {7{ICDATABWE[1]}};
assign ICDExpectMask[7:0]   = {7{ICDATABWE[0]}};
assign ICDExpctMask128 = {4{ICDExpectMask}};

//--------------------------------------------------
// D-Cache Data RAM Test
//--------------------------------------------------

reg [2:0] DCDState, DCDStateNext;
reg DCDBitCompare;
reg [127:0] DCDBitExpect;
reg [7:0] DCDCnt;
reg [127:0] DCDMask;

reg DCDCompare;
reg DCD_word_error, DCD_bit_error;
reg DCD_wordx_error, DCD_bitx_error;
reg [31:0] DCDExpect;
wire [31:0] DCDExpectMask;
wire [127:0] DCDExpctMask128;
reg [3:0] DCDATACS;
reg [31:0] DCDATAWD;
reg [3:0] DCDATABYTEWE;
reg [12:0] DCDADDR;
reg [3:0] DCDATABWE;
reg [3:0] DCDATABWENext;
wire [2:0] DCDATAWORDB0,DCDATAWORDB1,DCDATAWORDB2,DCDATAWORDB3;
wire [9:0] DCDATAINDEX;

assign DCDATAWORDB0 = DCDADDR[2:0];
assign DCDATAWORDB1 = DCDADDR[2:0];
assign DCDATAWORDB2 = DCDADDR[2:0];
assign DCDATAWORDB3 = DCDADDR[2:0];
assign DCDATAINDEX[9:0] = DCDADDR[12:3];

wire [31:0] DCDATAWD3,DCDATAWD2,DCDATAWD1,DCDATAWD0;
assign DCDATAWD0 = DCDATAWD;
assign DCDATAWD1 = DCDATAWD;
assign DCDATAWD2 = DCDATAWD;
assign DCDATAWD3 = DCDATAWD;

wire [31:0]  DCDExpectMasked;
wire [127:0] DCDATARD;
assign DCDATARD = {DCDATARD3,DCDATARD2,DCDATARD1,DCDATARD0};

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCDState <= `IDLE;
  else if (ICDState == `DONE)
    DCDState <= DCDStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCDCnt <= 8'b00000000;
  else if(DCDState == `WR_WK1)
    DCDCnt <= DCDCnt + 1;
end

always @(DCDState or DCDADDR or DCDCnt or DCDADDR_RNG) begin
  case(DCDState)
    `IDLE : DCDStateNext = `WRITE;
   `WRITE : DCDStateNext = (DCDADDR == DCDADDR_RNG) ? `READ : `WRITE;
    `READ : DCDStateNext = (DCDADDR == DCDADDR_RNG) ? `WR_0 : `READ;
    `WR_0 : DCDStateNext = `WR_WK1;
  `WR_WK1 : DCDStateNext = `RD_WK1;
  `RD_WK1 : DCDStateNext = (DCDCnt == 8'b10000000) ? `DONE : `WR_WK1;
    `DONE : DCDStateNext = `DONE;
  default : DCDStateNext = `IDLE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCDATACS <= 4'b0000;
    DCDATABYTEWE <= 4'b0000;
    DCDATABWENext <= 4'b1111;
    DCDADDR <= 13'b1111111111111;
    DCDATAWD <= 32'd55555555;
  end else if(DCDState == `WRITE) begin
    DCDATACS <= 4'b1111;
    DCDATABYTEWE <= ((DCDATABYTEWE + 1'b1) == 4'b0000) ? 4'b0001 : DCDATABYTEWE + 1'b1;
    DCDADDR <= DCDADDR + 1;
    DCDATAWD <= (DCDATAWD + 1);
  end else if (DCDState == `READ) begin
    DCDATACS <= 4'b1111;
    DCDATABYTEWE <= 4'b0000;
    DCDATABWENext <= ((DCDATABWENext + 1'b1) == 4'b0000) ? 4'b0001 : DCDATABWENext + 1'b1;
    DCDADDR <= (DCDADDR == (DCDADDR_RNG + 1)) ? 13'b0000000000000 : (DCDADDR + 1) ;
  end else if (DCDState == `WR_0) begin
    DCDATACS <= 4'b1111;
    DCDATABYTEWE <= 4'b1111;
    DCDADDR <= 13'b0000000000000;
    DCDATAWD <= 112'd0;
  end else if (DCDState == `WR_WK1) begin
    DCDADDR <= ALIAS_DCDADDR_RNG;
    DCDATACS[0] <= (DCDCnt < 8'b00100000);
    DCDATACS[1] <= (DCDCnt < 8'b01000000 && DCDCnt >= 8'b00100000);
    DCDATACS[2] <= (DCDCnt < 8'b01100000 && DCDCnt >= 8'b01000000);
    DCDATACS[3] <= (DCDCnt < 8'b10000000 && DCDCnt >= 8'b01100000);
    DCDATABYTEWE[0] <= (DCDCnt == 8'b00000000) ? 1'b1 : | ({DCDATAWD[31],DCDATAWD[6:0]});
    DCDATABYTEWE[1] <= | (DCDATAWD[14:7]);
    DCDATABYTEWE[2] <= | (DCDATAWD[22:15]);
    DCDATABYTEWE[3] <= | (DCDATAWD[30:23]);
    DCDATAWD <= 1'b1 << (DCDCnt[4:0]);
  end else if (DCDState == `RD_WK1) begin
    DCDATACS <= 4'b1111;
    DCDATABYTEWE <= 4'b0000;
    DCDADDR <= 13'b0000000000000;
  end else begin
    DCDATACS <= 4'b0000;
    DCDATABYTEWE <= 4'b0000;
    DCDADDR <= 13'b1111111111111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) 
    DCDATABWE <= 4'b1111;
  else
    DCDATABWE <= DCDATABWENext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCDCompare <= 1'b0;
    DCDBitCompare <= 1'b0;
  end else begin
    DCDCompare <= (DCDATACS == 4'b1111) & (DCDATABYTEWE == 4'b0000) & ((DCDState == `READ) | (DCDState == `WR_0));
    DCDBitCompare <= (DCDATACS == 4'b1111) & (DCDATABYTEWE == 4'b0000) & ((DCDState == `WR_WK1) | (DCDState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCDMask <= 128'b0;
  else if(DCDCnt == 8'd8)
    DCDMask[7:0] <= 8'b10000000;
  else if(DCDCnt == 8'd16)
    DCDMask[15:8] <= 8'b10000000;
  else if(DCDCnt == 8'd24)
    DCDMask[23:16] <= 8'b10000000;
  else if(DCDCnt == 8'd32)
    DCDMask[31:24] <= 8'b10000000;
  else if(DCDCnt == 8'd40)
    DCDMask[39:32] <= 8'b10000000;
  else if(DCDCnt == 8'd48)
    DCDMask[47:40] <= 8'b10000000;
  else if(DCDCnt == 8'd56)
    DCDMask[55:48] <= 8'b10000000;
  else if(DCDCnt == 8'd64)
    DCDMask[63:56] <= 8'b10000000;
  else if(DCDCnt == 8'd72)
    DCDMask[71:64] <= 8'b10000000;
  else if(DCDCnt == 8'd80)
    DCDMask[79:72] <= 8'b10000000;
  else if(DCDCnt == 8'd88)
    DCDMask[87:80] <= 8'b10000000;
  else if(DCDCnt == 8'd96)
    DCDMask[95:88] <= 8'b10000000;
  else if(DCDCnt == 8'd104)
    DCDMask[103:96] <= 8'b10000000;
  else if(DCDCnt == 8'd112)
    DCDMask[111:104] <= 8'b10000000;
  else if(DCDCnt == 8'd120)
    DCDMask[119:112] <= 8'b10000000;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCD_word_error <= 1'b0;
    DCD_bit_error <= 1'b0;
    DCD_wordx_error <= 1'b0;
    DCD_bitx_error <= 1'b0;
    DCDExpect <= 32'd55555556;
    DCDBitExpect <= 128'd1;
  end else if(DCDCompare) begin
    if((DCDATARD & DCDExpctMask128) != {4{DCDExpectMasked}}) begin
      DCD_word_error <= 1'b1;
    end
    //synopsys translate_off
    if((DCDATARD & DCDExpctMask128) !== {4{DCDExpectMasked}}) begin
      DCD_wordx_error <= 1'b1;
      $display ($time,,"D-Cache Data RAM Word Error. Expected = %x, Actual = %x",
                {DCDExpect,DCDExpect,DCDExpect,DCDExpect},DCDATARD);
    end
    //synopsys translate_on
    DCDExpect <= (DCDExpect + 1);

  end else if(DCDBitCompare) begin
    if(DCDATARD != DCDBitExpect) begin
      DCD_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCDATARD !== DCDBitExpect) begin
      DCD_bitx_error <= 1'b1;
      $display ($time,,"D-Cache Data RAM Bit Error. Expected = %x, Actual = %x",
                DCDBitExpect,DCDATARD);
    end
    //synopsys translate_on
    DCDBitExpect <= (1'b1 << (DCDCnt-1)) ^ DCDMask;
  end
end

assign DCDExpectMasked  = DCDExpect & DCDExpectMask;

assign DCDExpectMask[31:24] = {7{DCDATABWE[3]}};
assign DCDExpectMask[23:16] = {7{DCDATABWE[2]}};
assign DCDExpectMask[15:8]  = {7{DCDATABWE[1]}};
assign DCDExpectMask[7:0]   = {7{DCDATABWE[0]}};
assign DCDExpctMask128 = {4{DCDExpectMask}};

//--------------------------------------------------
// I-Cache TAG RAM Test
//--------------------------------------------------

reg [2:0] ICTState, ICTStateNext;
reg ICTBitCompare;
reg [87:0] ICTBitExpect;
reg [6:0] ICTCnt;
reg [87:0] ICTMask;

reg ICTCompare;
reg ICT_word_error, ICT_bit_error;
reg ICT_wordx_error, ICT_bitx_error;
reg [21:0] ICTExpect;
reg [3:0] ICTAGCS;
reg [21:0] ICTAGWD;
reg [3:0] ICTAGWE;
reg [10:0] ICTAGA;

wire [21:0] ICTAGWD3,ICTAGWD2,ICTAGWD1,ICTAGWD0;
assign ICTAGWD0 = ICTAGWD;
assign ICTAGWD1 = ICTAGWD;
assign ICTAGWD2 = ICTAGWD;
assign ICTAGWD3 = ICTAGWD;

wire [87:0] ICTAGRD;
assign ICTAGRD = {ICTAGRD3,ICTAGRD2,ICTAGRD1,ICTAGRD0};

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICTState <= `IDLE;
  else if (DCDState == `DONE)
    ICTState <= ICTStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICTCnt <= 7'b0000000;
  else if(ICTState == `WR_WK1)
    ICTCnt <= ICTCnt + 1;
end

always @(ICTState or ICTAGA or ICTCnt or ICTAG_RNG) begin
  case(ICTState)
    `IDLE : ICTStateNext = `WRITE;
   `WRITE : ICTStateNext = (ICTAGA == ICTAG_RNG) ? `READ : `WRITE;
    `READ : ICTStateNext = (ICTAGA == ICTAG_RNG) ? `WR_0 : `READ;
    `WR_0 : ICTStateNext = `WR_WK1;
  `WR_WK1 : ICTStateNext = `RD_WK1;
  `RD_WK1 : ICTStateNext = (ICTCnt == 7'b1011000) ? `DONE : `WR_WK1;
    `DONE : ICTStateNext = `DONE;
  default : ICTStateNext = `IDLE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICTAGCS <= 4'b0000;
    ICTAGWE <= 4'b0000;
    ICTAGA <= 11'b11111111111;
    ICTAGWD <= 22'b0;
  end else if(ICTState == `WRITE) begin
    ICTAGCS <= 4'b1111;
    ICTAGWE <= 4'b1111;
    ICTAGA <= ICTAGA + 1;
    ICTAGWD <= (ICTAGWD + 1);
  end else if (ICTState == `READ) begin
    ICTAGCS <= 4'b1111;
    ICTAGWE <= 4'b0000;
    ICTAGA <= (ICTAGA == (ICTAG_RNG + 1)) ? 11'b00000000000 : (ICTAGA + 1) ;
  end else if (ICTState == `WR_0) begin
    ICTAGCS <= 4'b1111;
    ICTAGWE <= 4'b1111;
    ICTAGA <= 11'b00000000000;
    ICTAGWD <= 22'd0;
  end else if (ICTState == `WR_WK1) begin
    ICTAGA <= ALIAS_ICTAG_RNG;
    ICTAGCS[0] <= (ICTCnt < 7'b0010110);
    ICTAGCS[1] <= (ICTCnt < 7'b0101100 && ICTCnt >= 7'b0010110);
    ICTAGCS[2] <= (ICTCnt < 7'b1000010 && ICTCnt >= 7'b0101100);
    ICTAGCS[3] <= (ICTCnt < 7'b1011000 && ICTCnt >= 7'b1000010);
    ICTAGWE[0] <= (ICTCnt < 7'b0010110);
    ICTAGWE[1] <= (ICTCnt < 7'b0101100 && ICTCnt >= 7'b0010110);
    ICTAGWE[2] <= (ICTCnt < 7'b1000010 && ICTCnt >= 7'b0101100);
    ICTAGWE[3] <= (ICTCnt < 7'b1011000 && ICTCnt >= 7'b1000010);
    //ICTAGWD <= 1'b1 << (ICTCnt % 22);
    ICTAGWD <=  (ICTCnt >= 66) ? (1'b1 << (ICTCnt - 66)) : 
                    (ICTCnt >= 44) ? (1'b1 << (ICTCnt - 44)) : 
                      (ICTCnt >= 22) ? (1'b1 << (ICTCnt - 22)) : (1'b1 << ICTCnt); 
  end else if (ICTState == `RD_WK1) begin
    ICTAGCS <= 4'b1111;
    ICTAGWE <= 4'b0000;
    ICTAGA <= 11'b00000000000;
  end else begin
    ICTAGCS <= 4'b0000;
    ICTAGWE <= 4'b0000;
    ICTAGA <= 11'b11111111111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICTCompare <= 1'b0;
    ICTBitCompare <= 1'b0;
  end else begin
    ICTCompare <= (ICTAGCS == 4'b1111) & (ICTAGWE == 4'b0000) & ((ICTState == `READ) | (ICTState == `WR_0));
    ICTBitCompare <= (ICTAGCS == 4'b1111) & (ICTAGWE == 4'b0000) & ((ICTState == `WR_WK1) | (ICTState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICTMask <= 88'b0;
  else if(ICTCnt == 7'd22)
    ICTMask[21:0] <= 22'b1000000000000000000000;
  else if(ICTCnt == 7'd44)
    ICTMask[43:22] <= 22'b1000000000000000000000;
  else if(ICTCnt == 7'd66)
    ICTMask[65:44] <= 22'b1000000000000000000000;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICT_word_error <= 1'b0;
    ICT_bit_error <= 1'b0;
    ICT_wordx_error <= 1'b0;
    ICT_bitx_error <= 1'b0;
    ICTExpect <= 22'd1;
    ICTBitExpect <= 88'd1;
  end else if(ICTCompare) begin
    if(ICTAGRD != {ICTExpect,ICTExpect,ICTExpect,ICTExpect}) begin
      ICT_word_error <= 1'b1;
    end
    //synopsys translate_off
    if(ICTAGRD !== {ICTExpect,ICTExpect,ICTExpect,ICTExpect}) begin
      ICT_wordx_error <= 1'b1;
      $display ($time,,"I-Cache TAG RAM Word Error. Expected = %x, Actual = %x",
                {ICTExpect,ICTExpect,ICTExpect,ICTExpect},ICTAGRD);
    end
    //synopsys translate_on
    ICTExpect <= ICTExpect + 1;
  end else if(ICTBitCompare) begin
    if(ICTAGRD != ICTBitExpect) begin
      ICT_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(ICTAGRD !== ICTBitExpect) begin
      ICT_bitx_error <= 1'b1;
      $display ($time,,"I-Cache TAG RAM bit Error. Expected = %x, Actual = %x",
                ICTBitExpect,ICTAGRD);
    end
    //synopsys translate_on
      ICTBitExpect <= (1'b1 << (ICTCnt-1)) ^ ICTMask;
  end
end

//--------------------------------------------------
// D-Cache TAG RAM Test
//--------------------------------------------------

reg [3:0] DCTState, DCTStateNext;
reg DCTBitCompare;
reg [87:0] DCTBitExpect;
reg [6:0] DCTCnt;
reg [87:0] DCTMask;

reg DCTCompare;
reg DCT_word_error, DCT_bit_error;
reg DCT_wordx_error, DCT_bitx_error;
reg [21:0] DCTExpect;
reg [3:0] DCTAGCS;
reg [21:0] DCTAGWD;
reg [3:0] DCTAGWE;
reg [10:0] DCTAGA;

wire [21:0] DCTAGWD3,DCTAGWD2,DCTAGWD1,DCTAGWD0;
assign DCTAGWD0 = DCTAGWD;
assign DCTAGWD1 = DCTAGWD;
assign DCTAGWD2 = DCTAGWD;
assign DCTAGWD3 = DCTAGWD;

wire [87:0] DCTAGRD;
assign DCTAGRD = {DCTAGRD3,DCTAGRD2,DCTAGRD1,DCTAGRD0};

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCTState <= `DT_IDLE;
  else if (ICTState == `DONE)
    DCTState <= DCTStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCTCnt <= 7'b0000000;
  else if(DCTState == `DT_WR_WK1)
    DCTCnt <= DCTCnt + 1;
end

always @(DCTState or DCTAGA or DCTCnt or DCTAG_RNG or DCPATAG_RNG) begin
  case(DCTState)
          `DT_IDLE : DCTStateNext = `DT_WRITE_TAG;
     `DT_WRITE_TAG : DCTStateNext = (DCTAGA == DCTAG_RNG)   ? `DT_WRITE_PATAG : `DT_WRITE_TAG;
   `DT_WRITE_PATAG : DCTStateNext = (DCTAGA == DCPATAG_RNG) ? `DT_READ_TAG : `DT_WRITE_PATAG;
      `DT_READ_TAG : DCTStateNext = (DCTAGA == DCTAG_RNG)   ? `DT_READ_PATAG : `DT_READ_TAG;
    `DT_READ_PATAG : DCTStateNext = (DCTAGA == DCPATAG_RNG) ? `DT_WR_0 : `DT_READ_PATAG;
          `DT_WR_0 : DCTStateNext = `DT_WR_WK1;
        `DT_WR_WK1 : DCTStateNext = `DT_RD_WK1;
        `DT_RD_WK1 : DCTStateNext = (DCTCnt == 7'b1011000) ? `DT_DONE : `DT_WR_WK1;
          `DT_DONE : DCTStateNext = `DT_DONE;
           default : DCTStateNext = `DT_DONE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCTAGCS <= 4'b0000;
    DCTAGWE <= 4'b0000;
    DCTAGA <= 11'b11111111111;
    DCTAGWD <= 22'b0;
  end else if(DCTState == `DT_WRITE_TAG) begin
    DCTAGCS <= 4'b1111;
    DCTAGWE <= 4'b1111;
    DCTAGA <= (DCTAGA + 1) ;
    DCTAGWD <= (DCTAGWD + 1);
  end else if(DCTState == `DT_WRITE_PATAG) begin
    DCTAGCS <= 4'b1111;
    DCTAGWE <= 4'b1111;
    DCTAGA <= (DCTAGA == (DCTAG_RNG + 1)) ? 11'b10000000000 : (DCTAGA + 1) ;
    DCTAGWD <= (DCTAGA == (DCTAG_RNG + 1)) ? 11'b10000000001 : (DCTAGWD + 1);
  end else if (DCTState == `DT_READ_TAG) begin
    DCTAGCS <= 4'b1111;
    DCTAGWE <= 4'b0000;
    DCTAGA <= (DCTAGA == (DCPATAG_RNG + 1)) ? 11'b00000000000 : (DCTAGA + 1) ;
  end else if (DCTState == `DT_READ_PATAG) begin
    DCTAGCS <= 4'b1111;
    DCTAGWE <= 4'b0000;
    DCTAGA <= (DCTAGA == (DCTAG_RNG + 1)) ? 11'b10000000000 : (DCTAGA + 1) ;
  end else if (DCTState == `DT_WR_0) begin
    DCTAGCS <= 4'b1111;
    DCTAGWE <= 4'b1111;
    DCTAGA <= 11'b00000000000;
    DCTAGWD <= 22'd0;
  end else if (DCTState == `DT_WR_WK1) begin
    DCTAGA <= ALIAS_DCTAG_RNG;
    DCTAGCS[0] <= (DCTCnt < 7'b0010110);
    DCTAGCS[1] <= (DCTCnt < 7'b0101100 && DCTCnt >= 7'b0010110);
    DCTAGCS[2] <= (DCTCnt < 7'b1000010 && DCTCnt >= 7'b0101100);
    DCTAGCS[3] <= (DCTCnt < 7'b1011000 && DCTCnt >= 7'b1000010);
    DCTAGWE[0] <= (DCTCnt < 7'b0010110);
    DCTAGWE[1] <= (DCTCnt < 7'b0101100 && DCTCnt >= 7'b0010110);
    DCTAGWE[2] <= (DCTCnt < 7'b1000010 && DCTCnt >= 7'b0101100);
    DCTAGWE[3] <= (DCTCnt < 7'b1011000 && DCTCnt >= 7'b1000010);
    DCTAGWD <=  (DCTCnt >= 66) ? (1'b1 << (DCTCnt - 66)) : 
                    (DCTCnt >= 44) ? (1'b1 << (DCTCnt - 44)) : 
                      (DCTCnt >= 22) ? (1'b1 << (DCTCnt - 22)) : (1'b1 << DCTCnt); 
    //DCTAGWD <= 1'b1 << (DCTCnt % 22);
  end else if (DCTState == `DT_RD_WK1) begin
    DCTAGCS <= 4'b1111;
    DCTAGWE <= 4'b0000;
    DCTAGA <= 11'b00000000000;
  end else begin
    DCTAGCS <= 4'b0000;
    DCTAGWE <= 4'b0000;
    DCTAGA <= 11'b11111111111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCTCompare <= 1'b0;
    DCTBitCompare <= 1'b0;
  end else begin
    DCTCompare <= (DCTAGCS == 4'b1111) & (DCTAGWE == 4'b0000) & 
                  ((DCTState == `DT_READ_TAG) | (DCTState == `DT_READ_PATAG) | (DCTState == `DT_WR_0));
    DCTBitCompare <= (DCTAGCS == 4'b1111) & (DCTAGWE == 4'b0000) & ((DCTState == `DT_WR_WK1) | (DCTState == `DT_DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCTMask <= 88'b0;
  else if(DCTCnt == 7'd22)
    DCTMask[21:0] <= 22'b1000000000000000000000;
  else if(DCTCnt == 7'd44)
    DCTMask[43:22] <= 22'b1000000000000000000000;
  else if(DCTCnt == 7'd66)
    DCTMask[65:44] <= 22'b1000000000000000000000;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCT_word_error <= 1'b0;
    DCT_bit_error <= 1'b0;
    DCT_wordx_error <= 1'b0;
    DCT_bitx_error <= 1'b0;
    DCTExpect <= 22'd1;
    DCTBitExpect <= 88'd1;
  end else if(DCTCompare) begin
    if(DCTAGRD != {DCTExpect,DCTExpect,DCTExpect,DCTExpect}) begin
      DCT_word_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCTAGRD !== {DCTExpect,DCTExpect,DCTExpect,DCTExpect}) begin
      DCT_wordx_error <= 1'b1;
      $display ($time,,"D-Cache TAG RAM Word Error. Expected = %x, Actual = %x",
                {DCTExpect,DCTExpect,DCTExpect,DCTExpect},DCTAGRD);
    end
    //synopsys translate_on
    DCTExpect <= (DCTAGA == 11'b10000000000) ? 11'b10000000001 : DCTExpect + 1;
  end else if(DCTBitCompare) begin
    if(DCTAGRD != DCTBitExpect) begin
      DCT_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCTAGRD !== DCTBitExpect) begin
      DCT_bitx_error <= 1'b1;
      $display ($time,,"D-Cache TAG RAM Bit Error. Expected = %x, Actual = %x",
                DCTBitExpect,DCTAGRD);
    end
    //synopsys translate_on
      DCTBitExpect <= (1'b1 << (DCTCnt-1)) ^ DCTMask;
  end
end

//--------------------------------------------------
// I-Cache Valid RAM Test
//--------------------------------------------------

reg [2:0] ICVState, ICVStateNext;
reg ICVBitCompare;
reg [23:0] ICVBitExpect;
reg [4:0] ICVCnt;

reg ICVCompare;
reg ICV_word_error, ICV_bit_error;
reg ICV_wordx_error, ICV_bitx_error;
reg [23:0] ICVExpect;
reg ICVALIDCS;
reg [23:0] ICVALIDWD;
reg ICVALIDWE;
reg [7:0] ICVALIDA;

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICVState <= `IDLE;
  else if (DCTState == `DT_DONE)
    ICVState <= ICVStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    ICVCnt <= 5'b00000;
  else if(ICVState == `WR_WK1)
    ICVCnt <= ICVCnt + 1;
end

always @(ICVState or ICVALIDA or ICVCnt or ICVALIDA_RNG or ICVCntRng) begin
  case(ICVState)
    `IDLE : ICVStateNext = `WRITE;
   `WRITE : ICVStateNext = (ICVALIDA == ICVALIDA_RNG) ? `READ : `WRITE;
    `READ : ICVStateNext = (ICVALIDA == ICVALIDA_RNG) ? `WR_0 : `READ;
    `WR_0 : ICVStateNext = `WR_WK1;
  `WR_WK1 : ICVStateNext = `RD_WK1;
  `RD_WK1 : ICVStateNext = (ICVCnt == ICVCntRng) ? `DONE : `WR_WK1;
    `DONE : ICVStateNext = `DONE;
  default : ICVStateNext = `IDLE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICVALIDCS <= 1'b0; 
    ICVALIDWE <= 1'b0;
    ICVALIDA <= 8'b11111111;
    ICVALIDWD <= 24'b0;
  end else if(ICVState == `WRITE) begin
    ICVALIDCS <= 1'b1;
    ICVALIDWE <= 1'b1;
    ICVALIDA <= ICVALIDA + 1;
    ICVALIDWD <= (ICVALIDWD + 1);
  end else if (ICVState == `READ) begin
    ICVALIDCS <= 1'b1;
    ICVALIDWE <= 1'b0;
    ICVALIDA <= (ICVALIDA == (ICVALIDA_RNG + 1)) ? 8'b00000000 : (ICVALIDA + 1) ;
  end else if (ICVState == `WR_0) begin
    ICVALIDCS <= 1'b1;
    ICVALIDWE <= 1'b1;
    ICVALIDA <= 8'b00000000;
    ICVALIDWD <= 23'd0;
  end else if (ICVState == `WR_WK1) begin
    ICVALIDA <= ALIAS_ICVALIDA_RNG;
    ICVALIDCS <= 1'b1;
    ICVALIDWE <= 1'b1;
    ICVALIDWD <= 1'b1 << (ICVCnt);
  end else if (ICVState == `RD_WK1) begin
    ICVALIDCS <= 1'b1;
    ICVALIDWE <= 1'b0;
    ICVALIDA <= 8'b00000000;
  end else begin
    ICVALIDCS <= 1'b0;
    ICVALIDWE <= 1'b0;
    ICVALIDA <= 8'b11111111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICVCompare <= 1'b0;
    ICVBitCompare <= 1'b0;
  end else begin
    ICVCompare <= (ICVALIDCS == 1'b1) & (ICVALIDWE == 1'b0) & ((ICVState == `READ) | (ICVState == `WR_0));
    ICVBitCompare <= (ICVALIDCS == 1'b1) & (ICVALIDWE == 1'b0) & ((ICVState == `WR_WK1) | (ICVState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    ICV_word_error <= 1'b0;
    ICV_bit_error <= 1'b0;
    ICV_wordx_error <= 1'b0;
    ICV_bitx_error <= 1'b0;
    ICVExpect <= 24'd1;
    ICVBitExpect <= 24'd1;
  end else if(ICVCompare) begin
    if(ICVALIDRD != ICVExpect) begin
      ICV_word_error <= 1'b1;
    end
    //synopsys translate_off
    if(ICVALIDRD !== ICVExpect) begin
      ICV_wordx_error <= 1'b1;
      $display ($time,,"I-Cache Valid RAM Word Error. Expected = %x, Actual = %x",
                ICVExpect,ICVALIDRD);
    end
    //synopsys translate_on
    ICVExpect <= ICVExpect + 1;
  end else if(ICVBitCompare) begin
    if(ICVALIDRD != ICVBitExpect) begin
      ICV_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(ICVALIDRD !== ICVBitExpect) begin
      ICV_bitx_error <= 1'b1;
      $display ($time,,"I-Cache Valid RAM bit Error. Expected = %x, Actual = %x",
                ICVBitExpect,ICVALIDRD);
    end
    //synopsys translate_on
      ICVBitExpect <= (1'b1 << (ICVCnt-1));
  end
end


//--------------------------------------------------
// D-Cache Valid RAM Test
//--------------------------------------------------

reg [2:0] DCVState, DCVStateNext;
reg DCVBitCompare;
reg [23:0] DCVBitExpect;
reg [4:0] DCVCnt;

reg DCVCompare;
reg DCV_word_error, DCV_bit_error;
reg DCV_wordx_error, DCV_bitx_error;
reg [23:0] DCVExpect;
reg DCVALIDCS;
reg [23:0] DCVALIDWD;
reg DCVALIDWE;
reg [7:0] DCVALIDA;

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCVState <= `IDLE;
  else if (ICVState == `DONE)
    DCVState <= DCVStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCVCnt <= 5'b00000;
  else if(DCVState == `WR_WK1)
    DCVCnt <= DCVCnt + 1;
end

always @(DCVState or DCVALIDA or DCVCnt or DCVALIDA_RNG or DCVCntRng) begin
  case(DCVState)
    `IDLE : DCVStateNext = `WRITE;
   `WRITE : DCVStateNext = (DCVALIDA == DCVALIDA_RNG) ? `READ : `WRITE;
    `READ : DCVStateNext = (DCVALIDA == DCVALIDA_RNG) ? `WR_0 : `READ;
    `WR_0 : DCVStateNext = `WR_WK1;
  `WR_WK1 : DCVStateNext = `RD_WK1;
  `RD_WK1 : DCVStateNext = (DCVCnt == DCVCntRng) ? `DONE : `WR_WK1;
    `DONE : DCVStateNext = `DONE;
  default : DCVStateNext = `IDLE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCVALIDCS <= 1'b0; 
    DCVALIDWE <= 1'b0;
    DCVALIDA <= 8'b11111111;
    DCVALIDWD <= 24'b0;
  end else if(DCVState == `WRITE) begin
    DCVALIDCS <= 1'b1;
    DCVALIDWE <= 1'b1;
    DCVALIDA <= DCVALIDA + 1;
    DCVALIDWD <= (DCVALIDWD + 1);
  end else if (DCVState == `READ) begin
    DCVALIDCS <= 1'b1;
    DCVALIDWE <= 1'b0;
    DCVALIDA <= (DCVALIDA == (DCVALIDA_RNG + 1)) ? 8'b00000000 : (DCVALIDA + 1) ;
  end else if (DCVState == `WR_0) begin
    DCVALIDCS <= 1'b1;
    DCVALIDWE <= 1'b1;
    DCVALIDA <= 8'b00000000;
    DCVALIDWD <= 23'd0;
  end else if (DCVState == `WR_WK1) begin
    DCVALIDA <= ALIAS_DCVALIDA_RNG;
    DCVALIDCS <= 1'b1;
    DCVALIDWE <= 1'b1;
    DCVALIDWD <= 1'b1 << (DCVCnt);
  end else if (DCVState == `RD_WK1) begin
    DCVALIDCS <= 1'b1;
    DCVALIDWE <= 1'b0;
    DCVALIDA <= 8'b00000000;
  end else begin
    DCVALIDCS <= 1'b0;
    DCVALIDWE <= 1'b0;
    DCVALIDA <= 8'b11111111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCVCompare <= 1'b0;
    DCVBitCompare <= 1'b0;
  end else begin
    DCVCompare <= (DCVALIDCS == 1'b1) & (DCVALIDWE == 1'b0) & ((DCVState == `READ) | (DCVState == `WR_0));
    DCVBitCompare <= (DCVALIDCS == 1'b1) & (DCVALIDWE == 1'b0) & ((DCVState == `WR_WK1) | (DCVState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCV_word_error <= 1'b0;
    DCV_bit_error <= 1'b0;
    DCV_wordx_error <= 1'b0;
    DCV_bitx_error <= 1'b0;
    DCVExpect <= 24'd1;
    DCVBitExpect <= 24'd1;
  end else if(DCVCompare) begin
    if(DCVALIDRD != DCVExpect) begin
      DCV_word_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCVALIDRD !== DCVExpect) begin
      DCV_wordx_error <= 1'b1;
      $display ($time,,"D-Cache Valid RAM Word Error. Expected = %x, Actual = %x",
                DCVExpect,DCVALIDRD);
    end
      //synopsys translate_on
    DCVExpect <= DCVExpect + 1;
  end else if(DCVBitCompare) begin
    if(DCVALIDRD != DCVBitExpect) begin
      DCV_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCVALIDRD !== DCVBitExpect) begin
      DCV_bitx_error <= 1'b1;
      $display ($time,,"D-Cache Valid RAM bit Error. Expected = %x, Actual = %x",
                DCVBitExpect,DCVALIDRD);
    end
    //synopsys translate_on
      DCVBitExpect <= (1'b1 << (DCVCnt-1));
  end
end

//--------------------------------------------------
// D-Cache Dirty RAM Test
//--------------------------------------------------

reg [2:0] DCDiState, DCDiStateNext;
reg DCDiBitCompare;
reg [7:0] DCDiBitExpect;
reg [3:0] DCDiCnt;

reg DCDiCompare;
reg DCDi_word_error, DCDi_bit_error;
reg DCDi_wordx_error, DCDi_bitx_error;
reg [7:0] DCDiExpect;
reg DCDIRTYCS;
reg [7:0] DCDIRTYWD;
reg [7:0] DCDIRTYWE;
reg [9:0] DCDIRTYA;

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCDiState <= `IDLE;
  else if (DCVState == `DONE)
    DCDiState <= DCDiStateNext;
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn)
    DCDiCnt <= 4'b0000;
  else if(DCDiState == `WR_WK1)
    DCDiCnt <= DCDiCnt + 1;
end

always @(DCDiState or DCDIRTYA or DCDiCnt or DCDIRTYA_RNG) begin
  case(DCDiState)
    `IDLE : DCDiStateNext = `WRITE;
   `WRITE : DCDiStateNext = (DCDIRTYA == DCDIRTYA_RNG) ? `READ : `WRITE;
    `READ : DCDiStateNext = (DCDIRTYA == DCDIRTYA_RNG) ? `WR_0 : `READ;
    `WR_0 : DCDiStateNext = `WR_WK1;
  `WR_WK1 : DCDiStateNext = `RD_WK1;
  `RD_WK1 : DCDiStateNext = (DCDiCnt == 4'b1000) ? `DONE : `WR_WK1;
    `DONE : DCDiStateNext = `DONE;
  default : DCDiStateNext = `IDLE;
  endcase
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCDIRTYCS <= 1'b0; 
    DCDIRTYWE <= 8'b00000000;
    DCDIRTYA <= 10'b1111111111;
    DCDIRTYWD <= 8'b0;
  end else if(DCDiState == `WRITE) begin
    DCDIRTYCS <= 1'b1;
    DCDIRTYWE <= 8'b11111111;
    DCDIRTYA <= DCDIRTYA + 1;
    DCDIRTYWD <= (DCDIRTYWD + 1);
  end else if (DCDiState == `READ) begin
    DCDIRTYCS <= 1'b1;
    DCDIRTYWE <= 8'b00000000;
    DCDIRTYA <= (DCDIRTYA == (DCDIRTYA_RNG + 1)) ? 10'b0000000000 : (DCDIRTYA + 1) ;
  end else if (DCDiState == `WR_0) begin
    DCDIRTYCS <= 1'b1;
    DCDIRTYWE <= 8'b11111111;
    DCDIRTYA <= 10'b0000000000;
    DCDIRTYWD <= 8'd0;
  end else if (DCDiState == `WR_WK1) begin
    DCDIRTYA <= ALIAS_DCDIRTYA_RNG;
    DCDIRTYCS <= 1'b1;
    DCDIRTYWE <= 1'b1 << (DCDiCnt);
    DCDIRTYWD <= 1'b1 << (DCDiCnt);
  end else if (DCDiState == `RD_WK1) begin
    DCDIRTYCS <= 1'b1;
    DCDIRTYWE <= 8'b00000000;
    DCDIRTYA <= 10'b0000000000;
  end else begin
    DCDIRTYCS <= 1'b0;
    DCDIRTYWE <= 8'b00000000;
    DCDIRTYA <= 10'b1111111111;
  end
end
   
always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCDiCompare <= 1'b0;
    DCDiBitCompare <= 1'b0;
  end else begin
    DCDiCompare <= (DCDIRTYCS == 1'b1) & (DCDIRTYWE == 8'b00000000) & ((DCDiState == `READ) | (DCDiState == `WR_0));
    DCDiBitCompare <= (DCDIRTYCS == 1'b1) & (DCDIRTYWE == 8'b00000000) & ((DCDiState == `WR_WK1) | (DCDiState == `DONE));
  end
end

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    DCDi_word_error <= 1'b0;
    DCDi_bit_error <= 1'b0;
    DCDi_wordx_error <= 1'b0;
    DCDi_bitx_error <= 1'b0;
    DCDiExpect <= 24'd1;
    DCDiBitExpect <= 24'd1;
  end else if(DCDiCompare) begin
    if(DCDIRTYRD != DCDiExpect) begin
      DCDi_word_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCDIRTYRD !== DCDiExpect) begin
      DCDi_wordx_error <= 1'b1;
      $display ($time,,"D-Cache Dirty RAM Word Error. Expected = %x, Actual = %x",
                DCDiExpect,DCDIRTYRD);
    end
    //synopsys translate_on
    DCDiExpect <= DCDiExpect + 1;
  end else if(DCDiBitCompare) begin
    if(DCDIRTYRD != DCDiBitExpect) begin
      DCDi_bit_error <= 1'b1;
    end
    //synopsys translate_off
    if(DCDIRTYRD !== DCDiBitExpect) begin
      DCDi_bitx_error <= 1'b1;
      $display ($time,,"D-Cache Dirty RAM bit Error. Expected = %x, Actual = %x",
                DCDiBitExpect,DCDIRTYRD);
    end
    //synopsys translate_on
      DCDiBitExpect <= DCDiBitExpect + (1'b1 << (DCDiCnt-1));
  end
end

reg Summary1;
reg Summary2;

always @(posedge CLK or negedge HRESETn) begin
  if(~HRESETn) begin
    Summary1 <= 1'b0;
    Summary2 <= 1'b0;
  end else begin
    Summary1 <= ((MMUState == `DONE) && (ICDState == `DONE) && (DCDState == `DONE) && 
                 (ICTState == `DONE) && (DCTState == `DT_DONE) && (ICVState == `DONE) && 
                 (DCVState == `DONE) && (DCDiState == `DONE));
    Summary2 <= Summary1;
  end
end

//synopsys translate_off
always @(Summary2) begin

  if(Summary2 == 1'b1) begin
     $display("Summary");
     $display("=======");
     $display("");
     $display("Cache Configuration");
     $display("-------------------");
     $display("I-Cache size = %s", sICSIZE);
     $display("D-Cache size = %s", sDCSIZE);
     if(ICNoRRgen == 1'b1) begin
       $display("I-Cache Valid RAM will only support random replacement algorithm");
     end else begin
       $display("I-Cache Valid RAM will support round-robin & random replacement algorithms");
     end
     if(DCNoRRgen == 1'b1) begin
       $display("D-Cache Valid RAM will only support random replacement algorithm");
     end else begin
       $display("D-Cache Valid RAM will support round-robin & random replacement algorithms");
     end
     $display("");
     $display("Cache Integration Tests");
     $display("-----------------------");

    if(MMU_word_error == 1'b1 || MMU_wordx_error == 1'b1 )
      $display("MMU RAM word test FAILED");
    else
      $display("MMU RAM word test passed");
    if(MMU_bit_error == 1'b1 || MMU_bitx_error == 1'b1)
      $display("MMU RAM bit/alias test FAILED");
    else
      $display("MMU RAM bit test passed");
    if(ICD_word_error == 1'b1 || ICD_wordx_error == 1'b1)
      $display("I-Cache Data RAM word test FAILED");
    else
      $display("I-Cache Data RAM word test passed");
    if(ICD_bit_error == 1'b1 || ICD_bitx_error == 1'b1)
      $display("I-Cache Data RAM bit/alias test FAILED");
    else
      $display("I-Cache Data RAM bit test passed");
    if(DCD_word_error == 1'b1 || DCD_wordx_error == 1'b1)
      $display("D-Cache Data RAM word test FAILED");
    else
      $display("D-Cache Data RAM word test passed");
    if(DCD_bit_error == 1'b1 || DCD_bitx_error == 1'b1)
      $display("D-Cache Data RAM bit/alias test FAILED");
    else
      $display("D-Cache Data RAM bit test passed");
    if(ICT_word_error == 1'b1 || ICT_wordx_error == 1'b1)
      $display("I-Cache TAG RAM word test FAILED");
    else
      $display("I-Cache TAG RAM word test passed");
    if(ICT_bit_error == 1'b1 || ICT_bitx_error == 1'b1)
      $display("I-Cache TAG RAM bit/alias test FAILED");
    else
      $display("I-Cache TAG RAM bit test passed");
    if(DCT_word_error == 1'b1 || DCT_wordx_error == 1'b1)
      $display("D-Cache TAG RAM word test FAILED");
    else
      $display("D-Cache TAG RAM word test passed");
    if(DCT_bit_error == 1'b1 || DCT_bitx_error == 1'b1)
      $display("D-Cache TAG RAM bit/alias test FAILED");
    else
      $display("D-Cache TAG RAM bit test passed");
    if(ICV_word_error == 1'b1 || ICV_wordx_error == 1'b1)
      $display("I-Cache Valid RAM word test FAILED");
    else
      $display("I-Cache Valid RAM word test passed");
    if(ICV_bit_error == 1'b1 || ICV_bitx_error == 1'b1)
      $display("I-Cache Valid RAM bit/alias test FAILED");
    else
      $display("I-Cache Valid RAM bit test passed");
    if(DCV_word_error == 1'b1 || DCV_wordx_error == 1'b1)
      $display("D-Cache Valid RAM word test FAILED");
    else
      $display("D-Cache Valid RAM word test passed");
    if(DCV_bit_error == 1'b1 || DCV_bitx_error == 1'b1)
      $display("D-Cache Valid RAM bit/alias test FAILED");
    else
      $display("D-Cache Valid RAM bit test passed");
    if(DCDi_word_error == 1'b1 || DCDi_wordx_error == 1'b1)
      $display("D-Cache Dirty RAM word test FAILED");
    else
      $display("D-Cache Dirty RAM word test passed");
    if(DCDi_bit_error == 1'b1 || DCDi_bitx_error == 1'b1)
      $display("D-Cache Dirty RAM bit/alias test FAILED");
    else
      $display("D-Cache Dirty RAM bit test passed");
    $display("");
    if((MMU_word_error == 1'b1) |
       (ICD_word_error == 1'b1) |
       (DCD_word_error == 1'b1) | 
       (ICT_word_error == 1'b1) |
       (DCT_word_error == 1'b1) | 
       (ICV_word_error == 1'b1) |
       (DCV_word_error == 1'b1) |
       (DCDi_word_error == 1'b1) |
       (MMU_bit_error == 1'b1) |
       (ICD_bit_error == 1'b1) |
       (DCD_bit_error == 1'b1) | 
       (ICT_bit_error == 1'b1) |
       (DCT_bit_error == 1'b1) | 
       (ICV_bit_error == 1'b1) |
       (DCV_bit_error == 1'b1) |
       (DCDi_bit_error == 1'b1) |
       (MMU_wordx_error == 1'b1) |
       (ICD_wordx_error == 1'b1) |
       (DCD_wordx_error == 1'b1) | 
       (ICT_wordx_error == 1'b1) |
       (DCT_wordx_error == 1'b1) | 
       (ICV_wordx_error == 1'b1) |
       (DCV_wordx_error == 1'b1) |
       (DCDi_wordx_error == 1'b1) |
       (MMU_bitx_error == 1'b1) |
       (ICD_bitx_error == 1'b1) |
       (DCD_bitx_error == 1'b1) | 
       (ICT_bitx_error == 1'b1) |
       (DCT_bitx_error == 1'b1) | 
       (ICV_bitx_error == 1'b1) |
       (DCV_bitx_error == 1'b1) |
       (DCDi_bitx_error == 1'b1)) begin

       $display ("!!! RAM integration FAILED. Test completed with errors !!!");
    end else begin
       $display ("RAM integration passed. Test completed with no errors");
    end
    $display("");
`ifndef __NO_STOP__
    $stop;
`endif //__NO_STOP__
  end
end
//synopsys translate_on
       
 
endmodule // ARM926EJSCore
