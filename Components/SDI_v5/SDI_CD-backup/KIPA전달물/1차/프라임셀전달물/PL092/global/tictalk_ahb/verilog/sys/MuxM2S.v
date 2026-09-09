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
// File Name              : MuxM2S.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
// Purpose :
//           Central multiplexer - signals from masters to slaves
//           Also generates the default master outputs when no
//           other masters are selected.
//           Stand-alone module to allow ease of removal if an
//           alternative interconnection scheme is to be used.
//
// --=================================================================--

`timescale 1ns/1ps

module MuxM2S (HCLK, HRESETn, HMASTER, HREADY, HADDRarm, HTRANSarm,
               HWRITEarm, HSIZEarm, HBURSTarm, HPROTarm, HWDATAarm,
               HADDRtic, HTRANStic, HWRITEtic, HSIZEtic, HBURSTtic,
               HPROTtic, HWDATAtic, HADDR003, HTRANS003, HWRITE003,
               HSIZE003, HBURST003, HPROT003, HWDATA003, HADDR004,
               HTRANS004, HWRITE004, HSIZE004, HBURST004, HPROT004,
               HWDATA004, HADDR, HTRANS, HWRITE, HSIZE, HBURST,
               HPROT, HWDATA);

  input         HCLK;
  input         HRESETn;
  input   [3:0] HMASTER;
  input         HREADY;

  input  [31:0] HADDRarm;
  input   [1:0] HTRANSarm;
  input         HWRITEarm;
  input   [2:0] HSIZEarm;
  input   [2:0] HBURSTarm;
  input   [3:0] HPROTarm;
  input  [31:0] HWDATAarm;

  input  [31:0] HADDRtic;
  input   [1:0] HTRANStic;
  input         HWRITEtic;
  input   [2:0] HSIZEtic;
  input   [2:0] HBURSTtic;
  input   [3:0] HPROTtic;
  input  [31:0] HWDATAtic;

  input  [31:0] HADDR003;
  input   [1:0] HTRANS003;
  input         HWRITE003;
  input   [2:0] HSIZE003;
  input   [2:0] HBURST003;
  input   [3:0] HPROT003;
  input  [31:0] HWDATA003;

  input  [31:0] HADDR004;
  input   [1:0] HTRANS004;
  input         HWRITE004;
  input   [2:0] HSIZE004;
  input   [2:0] HBURST004;
  input   [3:0] HPROT004;
  input  [31:0] HWDATA004;

  output [31:0] HADDR;
  output  [1:0] HTRANS;
  output        HWRITE;
  output  [2:0] HSIZE;
  output  [2:0] HBURST;
  output  [3:0] HPROT;
  output [31:0] HWDATA;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// HMASTER output encoding
  `define MST_DEF 4'b0000
  `define MST_ARM 4'b0001
  `define MST_TIC 4'b0010
  `define MST_003 4'b0011
  `define MST_004 4'b0100

// ---------------------------------------------------------------------
// Signal declaration
// ---------------------------------------------------------------------
  reg  [3:0] HmasterPrev; // Previous HMASTER value

// Registered output signals
  reg [31:0] HADDR;
  reg  [1:0] HTRANS;
  reg        HWRITE;
  reg  [2:0] HSIZE;
  reg  [2:0] HBURST;
  reg  [3:0] HPROT;
  reg [31:0] HWDATA;

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// HMASTER register for write data multiplexer
// ---------------------------------------------------------------------
// HREADY is used as an enable so that if the previous transfer is
// waited, then the bus master number for that transfer is still stored.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      HmasterPrev <= 4'h0;
    else
    begin
      if (HREADY)
        HmasterPrev <= HMASTER;
    end
  end

// ---------------------------------------------------------------------
// Multiplexers
// ---------------------------------------------------------------------
// Multiplexers controlling address, control and write data to the
// slaves.

// When no masters are granted the Default Master settings are selected
// by the muxes. This sets all outputs to zero, performing IDLE
// transfers.
// The HTRANS output is the only one required to be driven LOW when no
// masters are selected - it is possible to drive all other outputs
// with values from one of the masters that is not selected, removing
// the need for driving wide buses LOW.

  always @(HMASTER or HADDRarm or HADDRtic or HADDR003 or HADDR004)
  begin
    case (HMASTER)
      `MST_ARM : HADDR = HADDRarm;
      `MST_TIC : HADDR = HADDRtic;
      `MST_003 : HADDR = HADDR003;
      `MST_004 : HADDR = HADDR004;
      default  : HADDR = 32'h0000_0000;
    endcase
  end

  always @(HMASTER or HTRANSarm or HTRANStic or HTRANS003 or HTRANS004)
  begin
    case (HMASTER)
      `MST_ARM : HTRANS = HTRANSarm;
      `MST_TIC : HTRANS = HTRANStic;
      `MST_003 : HTRANS = HTRANS003;
      `MST_004 : HTRANS = HTRANS004;
      default  : HTRANS = 2'b00;
    endcase
  end

  always @(HMASTER or HWRITEarm or HWRITEtic or HWRITE003 or HWRITE004)
  begin
    case (HMASTER)
      `MST_ARM : HWRITE = HWRITEarm;
      `MST_TIC : HWRITE = HWRITEtic;
      `MST_003 : HWRITE = HWRITE003;
      `MST_004 : HWRITE = HWRITE004;
      default  : HWRITE = 1'b0;
    endcase
  end

  always @(HMASTER or HSIZEarm or HSIZEtic or HSIZE003 or HSIZE004)
  begin
    case (HMASTER)
      `MST_ARM : HSIZE = HSIZEarm;
      `MST_TIC : HSIZE = HSIZEtic;
      `MST_003 : HSIZE = HSIZE003;
      `MST_004 : HSIZE = HSIZE004;
      default  : HSIZE = 3'b000;
    endcase
  end

  always @(HMASTER or HBURSTarm or HBURSTtic or HBURST003 or HBURST004)
  begin
    case (HMASTER)
      `MST_ARM : HBURST = HBURSTarm;
      `MST_TIC : HBURST = HBURSTtic;
      `MST_003 : HBURST = HBURST003;
      `MST_004 : HBURST = HBURST004;
      default  : HBURST = 3'b000;
    endcase
  end

  always @(HMASTER or HPROTarm or HPROTtic or HPROT003 or HPROT004)
  begin
    case (HMASTER)
      `MST_ARM : HPROT = HPROTarm;
      `MST_TIC : HPROT = HPROTtic;
      `MST_003 : HPROT = HPROT003;
      `MST_004 : HPROT = HPROT004;
      default  : HPROT = 4'b0000;
    endcase
  end

  always @(HmasterPrev or HWDATAarm or HWDATAtic or
           HWDATA003 or HWDATA004)
  begin
    case (HmasterPrev)
      `MST_ARM : HWDATA = HWDATAarm;
      `MST_TIC : HWDATA = HWDATAtic;
      `MST_003 : HWDATA = HWDATA003;
      `MST_004 : HWDATA = HWDATA004;
      default  : HWDATA = 32'h0000_0000;
    endcase
  end


endmodule

// --============================== End ==============================--
