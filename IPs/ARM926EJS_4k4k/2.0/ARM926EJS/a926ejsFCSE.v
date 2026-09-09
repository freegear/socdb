//----------------------------------------------------------------------------- 
//  This confidential and proprietary software may be used only as              
//  authorised by a licensing agreement from ARM Limited                        
//    (C) COPYRIGHT 2003 ARM Limited                                           
//        ALL RIGHTS RESERVED                                                   
//  The entire notice above must be reproduced on all authorised                
//  copies and copies may only be made to the extent permitted                  
//  by a licensing agreement from ARM Limited.                                  
//                                                                              
//      Module       : a926ejsFCSE                                                  
//                                                                              
//      Project      :                                                  
//                                                                              
//      RCS Information                                                         
//                                                                              
//      Release Information : ARM926EJS_r0p5-00rel0 
//                                                                              
//----------------------------------------------------------------------------- 

`timescale 1ns / 1ps

`include "smt_debug.vh"

module a926ejsFCSE(GCLK,Reset,FCSESampleIA,FCSESampleDA,DVASelDAHeld,IVASelIAHeld,
                   IA,DA,CP15VA,FCSEPID,DisableFCSE,SelCP15VA,MMUEn,
                   DVA,IVA,DMVA,IMVA,DAME,IAFE,RawIMVA,RawDMVA);

input         GCLK;     
input         Reset;
input         FCSESampleIA;    // controls capturing of IA
input         FCSESampleDA;    // controls capturing of DA
input         DVASelDAHeld;    // select recirculated DA for DVA
input         IVASelIAHeld;    // select recirculated IA for IVA
input [31:0]  IA;              // ARM9EJ-S instruction address
input [31:0]  DA;              // ARM9EJ-S data address
input [31:0]  CP15VA;          // CP15 address source, used for debug access and test 
input [31:25] FCSEPID;         // FCSE PID value from CP15 register 13
input         DisableFCSE;     // disable FCSE translation 
input         SelCP15VA;       // select CP15VA as the source for IVA, DVA, IMVA and DMVA
input         MMUEn;           // MMU enabled?
output [31:0] DVA;             // data cache VA address bus (EX)
output [31:0] IVA;             // instruction cache VA address bus (CA)
output [31:0] DMVA;            // MVA for data cache and the MMU (ME)
output [31:0] IMVA;            // MVA for instruction cache and the MMU (FE)
output  [9:2] DAME;            // DA[9:2] pipelined into ME 
output  [9:2] IAFE;            // IA[9:2] pipelined into FE

output [31:25] RawIMVA;        // to I$ for use in FB & PWB (FE)
output [31:25] RawDMVA;        // to D$ for use in FB & PWB (ME)

reg [31:0] DVA;
reg [31:0] IVA;
reg [31:0] DMVA;
reg [31:0] IMVA;


wire        DATop7ZeroEX;      // top 7 bits of DA are zero
wire        IATop7ZeroCA;      // top 7 bits of IA are zero
reg         DATop7ZeroME;      // DATop7ZeroEX pipelined into ME
reg         IATop7ZeroFE;      // IATop7ZeroCA pipelined into FE
wire        SelIPID;           // select the FCSE PID for IMVA[31:25]
wire        SelDPID;           // select the FCSE PID for DMVA[31:25]
reg  [31:0] IAHeldFE;          // holding register for IA
reg  [31:0] DAHeldME;          // holding regsiter for DA
reg         pDisableFCSE;      // DisableFCSE pipelined by 1 GCLK cycle ME/FE
wire        iMmuEn;            // registered version of MMUEn
wire [31:25] RawIMVACA;        // mux output, prior to registering as RawIMVA
wire [31:25] RawDMVAEX;        // mux output, prior to registering as RawDMVA


// holding registers for IA and DA
//
// 
// IAHeldFE and DAHeldME are updated whenever the core is advanced,
// irrespective of whether a memory or instruction fetch has been
// issued by the ARM9EJ-S core. IAHeldFE and DAHeldME are held until
// the end of the current ME/FE cycle, as indicated by CLKEN.


always @(posedge GCLK) begin
  if (FCSESampleIA) begin
    IAHeldFE <= IA;
  end
end

assign IAFE = IAHeldFE[9:2];

always @(posedge GCLK) begin
  if (FCSESampleDA) begin
    DAHeldME <= DA;
  end
end

assign DAME = DAHeldME[9:2];


// FCSE translation and generation of IMVA and DMVA
//
// FCSE translation will be disabled by CP15 for
//
// - accesses made with MMU is disabled
// - a VA based cache or TLB maintenance operation 


// If FCSE translation is allowed then the switching in 
// of the FCSE PID value into the top bits of IMVA or DMVA
// is done if the address lies in the bottom 32Mb of the 
// VA address space, i.e. the top 7 bits of the address are
// all zero.
//
// A zero detect is performed on IA/DA in CA/EX respectively.
// This is then pipelined into FE/ME, and combined with the
// DisableFCSE signal from CP15 to make SelXPID.

assign IATop7ZeroCA = ~|IA[31:25];
assign DATop7ZeroEX = ~|DA[31:25];

always @(posedge GCLK) begin
  if (FCSESampleIA) begin
    IATop7ZeroFE <= IATop7ZeroCA;
  end
end

always @(posedge GCLK) begin
  if (FCSESampleDA) begin
    DATop7ZeroME <= DATop7ZeroEX;
  end
end

always @(posedge GCLK) begin
  pDisableFCSE <= DisableFCSE;
end

assign SelIPID = IATop7ZeroFE & ~pDisableFCSE;
assign SelDPID = DATop7ZeroME & ~pDisableFCSE;

// The top 7 bits of XMVA will be sourced from either:
//
//  IAHeldFE    - ARM9EJ-S address value used untranslated
//  FCSEPID   - FCSE translation
//  CP15VA    - address based debug or test operation
//
// Note that if SelCP15VA is 1, then DisableFCSE will also be 1
// so SelXPID and SelCP15VA will be mutex

// IMVA muxing for top 7 bits
//
// As SelCP15VA and ISelPID are mutex the "11" case is set
// to select IAHeldFE. This allows ISelPID nor SelCP15VA
// to be used to select IAHeldFE.

always @(SelIPID or 
         SelCP15VA or 
         IAHeldFE or
         FCSEPID or
         CP15VA)
  begin
    case ({SelIPID,SelCP15VA})
      2'b00   : IMVA[31:25] = IAHeldFE[31:25];
      2'b01   : IMVA[31:25] = CP15VA[31:25];
      2'b10   : IMVA[31:25] = FCSEPID;
      2'b11   : IMVA[31:25] = CP15VA[31:25];  // can't happen condition
      default : IMVA[31:25] = 7'bxxxxxxx;
    endcase
  end

// DMVA muxing for top 7 bits
// 
// This is exactly the same logic as for IMVA, except that DAHeldME,
// and DSelPID are used

always @(SelDPID or 
         SelCP15VA or 
         DAHeldME or
         FCSEPID or
         CP15VA)
  begin
    case ({SelDPID,SelCP15VA})
      2'b00   : DMVA[31:25] = DAHeldME[31:25];
      2'b01   : DMVA[31:25] = CP15VA[31:25];
      2'b10   : DMVA[31:25] = FCSEPID;
      2'b11   : DMVA[31:25] = CP15VA[31:25];  // can't happen condition
      default : DMVA[31:25] = 7'bxxxxxxx;
    endcase
  end

// IMVA and DMVA muxing for lower bits
//
// This is the same as for the upper bits, except that the selection
// criteria is solely SelCP15VA

always @(SelCP15VA or CP15VA or IAHeldFE or DAHeldME)
  begin
    if (SelCP15VA)
      begin
        IMVA[24:0] = CP15VA[24:0]; 
        DMVA[24:0] = CP15VA[24:0];
      end
    else
      begin
        IMVA[24:0] = IAHeldFE[24:0]; 
        DMVA[24:0] = DAHeldME[24:0];
      end
  end



// IVA and DVA
//
// IVA and DVA are the virtual addresses used by the caches. 
//
// I/DVA is 
//
// - IA/DA for non-regenerated ARM9EJ-S requests
// - I/DAHeldME for regenerated ARM9EJ-S requests
// - IA/DA for cache maintenace operations
// - IAHeld for regenerated instruction
// - CP15VA for debug and cache test operations
//
// Note: XVASelXAHeld and SelCP15VA are mutex

always @(SelCP15VA or
         IVASelIAHeld or
         IA or
         IAHeldFE or
         CP15VA)
  begin
    case ({IVASelIAHeld,SelCP15VA})
      2'b00   : IVA[31:0] = IA;
      2'b01   : IVA[31:0] = CP15VA;
      2'b10   : IVA[31:0] = IAHeldFE;
      2'b11   : IVA[31:0] = CP15VA;   // can't happen condition
      default : IVA[31:0] = {32{1'bx}};
    endcase
  end

always @(SelCP15VA or
         DVASelDAHeld or
         DA or
         DAHeldME or
         CP15VA)
  begin
    case ({DVASelDAHeld,SelCP15VA})
      2'b00   : DVA[31:0] = DA;
      2'b01   : DVA[31:0] = CP15VA;
      2'b10   : DVA[31:0] = DAHeldME;
      2'b11   : DVA[31:0] = CP15VA;   // can't happen condition
      default : DVA[31:0] = {32{1'bx}};
    endcase
  end


//---------------------------------------------------------------------------
// 'Raw' MVA to caches
// --------------------
//
// The logic below provides RawXMVA off d-types to the caches to facilitate 
// using the MVA in the address comparison in the FB and PWB in both caches.
// The approach taken below, is to exclude all CP15 related logic from the
// selection process, as these are not used in neither the uTag nor the FB.
// Instead the raw IA/DA is used when:
//
//   - the MMU is turned off
//   - the MMU is on _and_ the top 7 bits of IA/DA are not zero
//
// The RawIMVACA and RawDMVAEX (mux outputs), are then registered if 
// FCSESamplexA is asserted, to produce RawIMVA and RawDMVA. They are still
// called 'raw' as they do not contain CP15 addressing.
//
// The caches then use the RawXMVA for address comparisons off the d-types 
// in the FE and ME cycles.
//
//---------------------------------------------------------------------------

  a926dffrnx1 uMMUEn(iMmuEn, MMUEn, GCLK, Reset);

  assign RawIMVACA[31:25] = (iMmuEn & IATop7ZeroCA) ? FCSEPID : IA[31:25];
  assign RawDMVAEX[31:25] = (iMmuEn & DATop7ZeroEX) ? FCSEPID : DA[31:25];

  a926gdffx7 uSmpIA(RawIMVA[31:25], RawIMVACA[31:25], GCLK, FCSESampleIA);
  a926gdffx7 uSmpDA(RawDMVA[31:25], RawDMVAEX[31:25], GCLK, FCSESampleDA);

//---------------------------------------------------------------------------
// End of updates for MVA improvements
//---------------------------------------------------------------------------


// assertions 

//synopsys translate_off


always @(posedge GCLK)

  begin

// check that DisableFCSE is asserted if SelCP15VA is asserted

    if (SelCP15VA & ~DisableFCSE)
      begin
        $display("%d fatal error - DisableFCSE not asserted for CP15VA op",$time);
`ifndef __NO_STOP__
        $stop;
`endif //__NO_STOP__
      end

// check that SelCP15VA and SelHeldI/D are mutex

    if (SelCP15VA & IVASelIAHeld)
       begin
        $display("%d fatal error - SelCP15VA and IVASelIAHeld both 1",$time);
`ifndef __NO_STOP__
        $stop;
`endif //__NO_STOP__
      end
    if (SelCP15VA & DVASelDAHeld)
      begin
        $display("%d fatal error - SelCP15VA and DVASelDAHeld both 1",$time);
`ifndef __NO_STOP__
        $stop;
`endif //__NO_STOP__
      end

  end



//synopsys translate_on

endmodule



          













