//  --============================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : MuxM2S.v,v
//  File Revision      : 1.7
// 
//  Release Information : ADK_REL1v1
// 
//  ----------------------------------------------------------------
//  Purpose   : Central multiplexer - signals from masters to slaves.
//              Also generates the default master outputs when no
//              other masters are selected.
//              Stand-alone module to allow ease of removal if an
//              alternative interconnection scheme is to be used.
//  --============================================================--

`timescale 1ns/1ps

module MuxM2S 
  (
   // Granted master number, used by this multiplexor to select Control
   //  bus signals during the address phase
   HMASTER,

   // Granted master number, used by this multiplexor to select the 
   //  write-data during the data phase
   HMASTERD,

   // Control signals and write-data from Master 1
   HADDRM1, 
   HTRANSM1, 
   HWRITEM1, 
   HSIZEM1, 
   HBURSTM1, 
   HPROTM1, 
   HWDATAM1,

   // Control signals and write-data from Master 2
   HADDRM2, 
   HTRANSM2, 
   HWRITEM2, 
   HSIZEM2,
   HBURSTM2, 
   HPROTM2, 
   HWDATAM2,

   // Control signals and write-data from Master 3
   HADDRM3, 
   HTRANSM3, 
   HWRITEM3, 
   HSIZEM3,
   HBURSTM3, 
   HPROTM3, 
   HWDATAM3,

   // Outputs from this multiplexor to the AHB
   HADDR, 
   HTRANS, 
   HWRITE, 
   HSIZE, 
   HBURST,
   HPROT, 
   HWDATA);

  input [3:0]   HMASTER;
  input [3:0]   HMASTERD;
  input [31:0]  HADDRM1;
  input [1:0]   HTRANSM1;
  input         HWRITEM1;
  input [2:0]   HSIZEM1;
  input [2:0]   HBURSTM1;
  input [3:0]   HPROTM1;
  input [31:0]  HWDATAM1;
  input [31:0]  HADDRM2;
  input [1:0]   HTRANSM2;
  input         HWRITEM2;
  input [2:0]   HSIZEM2;
  input [2:0]   HBURSTM2;
  input [3:0]   HPROTM2;
  input [31:0]  HWDATAM2;
  input [31:0]  HADDRM3;
  input [1:0]   HTRANSM3;
  input         HWRITEM3;
  input [2:0]   HSIZEM3;
  input [2:0]   HBURSTM3;
  input [3:0]   HPROTM3;
  input [31:0]  HWDATAM3;
  output [31:0] HADDR;
  output [1:0]  HTRANS;
  output        HWRITE;
  output [2:0]  HSIZE;
  output [2:0]  HBURST;
  output [3:0]  HPROT;
  output [31:0] HWDATA;



//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [3:0]   HMASTER;
  wire [3:0]   HMASTERD;
  wire [31:0]  HADDRM1;
  wire [1:0]   HTRANSM1;
  wire         HWRITEM1;
  wire [2:0]   HSIZEM1;
  wire [2:0]   HBURSTM1;
  wire [3:0]   HPROTM1;
  wire [31:0]  HWDATAM1;
  wire [31:0]  HADDRM2;
  wire [1:0]   HTRANSM2;
  wire         HWRITEM2;
  wire [2:0]   HSIZEM2;
  wire [2:0]   HBURSTM2;
  wire [3:0]   HPROTM2;
  wire [31:0]  HWDATAM2;
  wire [31:0]  HADDRM3;
  wire [1:0]   HTRANSM3;
  wire         HWRITEM3;
  wire [2:0]   HSIZEM3;
  wire [2:0]   HBURSTM3;
  wire [3:0]   HPROTM3;
  wire [31:0]  HWDATAM3;

  reg [31:0]   HADDR;
  reg [1:0]    HTRANS;
  reg          HWRITE;
  reg [2:0]    HSIZE;
  reg [2:0]    HBURST;
  reg [3:0]    HPROT;
  reg [31:0]   HWDATA;

//------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------
// HMASTER output encoding
`define MST_DEF 4'b0000
`define MST_M1 4'b0001
`define MST_M2 4'b0010
`define MST_M3 4'b0011

//------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------

//------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------
// Multiplexers controlling address, control and write data to the slaves.
// When no masters are granted the Dummy Master settings are selected by the
//  muxes. This sets all outputs to zero, performing IDLE transfers.
// The HTRANS output is the only one required to be driven LOW when no 
//  masters are selected - it is possible to drive all other outputs with
//  values from one of the masters that is not selected, removing the need
//  for driving wide buses LOW.

  always @ (HMASTER or HADDRM1 or HADDRM2 or HADDRM3)
    begin : p_HADDRComb
      case (HMASTER)
        `MST_M1 : begin
          HADDR = HADDRM1;
        end
        `MST_M2 : begin
          HADDR = HADDRM2;
        end
        `MST_M3 : begin
          HADDR = HADDRM3;
        end
        default: begin
          HADDR = {32{1'b0}};
        end
      endcase
    end 

  always @ (HMASTER or HTRANSM1 or HTRANSM2 or HTRANSM3)
    begin : p_HTRANSComb
      case (HMASTER)
        `MST_M1 : begin
          HTRANS = HTRANSM1;
        end
        `MST_M2 : begin
          HTRANS = HTRANSM2;
        end
        `MST_M3 : begin
          HTRANS = HTRANSM3;
        end
        default: begin
          HTRANS = 2'b00;
        end
      endcase
    end 

  always @ (HMASTER or HWRITEM1 or HWRITEM2 or HWRITEM3)
    begin : p_HWRITEComb
      case (HMASTER)
        `MST_M1 : begin
          HWRITE = HWRITEM1;
        end
        `MST_M2 : begin
          HWRITE = HWRITEM2;
        end
        `MST_M3 : begin
          HWRITE = HWRITEM3;
        end
        default: begin
          HWRITE = 1'b0;
        end
      endcase
    end 

  always @ (HMASTER or HSIZEM1 or HSIZEM2 or HSIZEM3)
    begin : p_HSIZEComb
      case (HMASTER)
        `MST_M1 : begin
          HSIZE = HSIZEM1;
        end
        `MST_M2 : begin
          HSIZE = HSIZEM2;
        end
        `MST_M3 : begin
          HSIZE = HSIZEM3;
        end
        default: begin
          HSIZE = 3'b000;
        end
      endcase
    end 

  always @ (HMASTER or HBURSTM1 or HBURSTM2 or HBURSTM3)
    begin : p_HBURSTComb
      case (HMASTER)
        `MST_M1 : begin
          HBURST = HBURSTM1;
        end
        `MST_M2 : begin
          HBURST = HBURSTM2;
        end
        `MST_M3 : begin
          HBURST = HBURSTM3;
        end
        default: begin
          HBURST = 3'b000;
        end
      endcase
    end 

  always @ (HMASTER or HPROTM1 or HPROTM2 or HPROTM3)
    begin : p_HPROTComb
      case (HMASTER)
        `MST_M1 : begin
          HPROT = HPROTM1;
        end
        `MST_M2 : begin
          HPROT = HPROTM2;
        end
        `MST_M3 : begin
          HPROT = HPROTM3;
        end
        default: begin
          HPROT = 4'b0000;
        end
      endcase
    end 

  always @ (HMASTERD or HWDATAM1 or HWDATAM2 or HWDATAM3)
    begin : p_HWDATAComb
      case (HMASTERD)
        `MST_M1 : begin
          HWDATA = HWDATAM1;
        end
        `MST_M2 : begin
          HWDATA = HWDATAM2;
        end
        `MST_M3 : begin
          HWDATA = HWDATAM3;
        end
        default: begin
          HWDATA = {32{1'b0}};
        end
      endcase
    end 

  
endmodule
