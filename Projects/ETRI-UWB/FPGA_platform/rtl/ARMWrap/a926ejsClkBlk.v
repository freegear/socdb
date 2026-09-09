// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : a926ejsClkBlk.v,v
// File Revision       : 1.8
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

`timescale 1 ns / 10 ps


`include "ARM926EJS.vh" 

module a926ejsClkBlk (

CLK,
HRESETn,
DisableBlkClkGate,
WFIWakeUp,
STANDBYWFI,
ICClkEn,       
DCClkEn,       
ITCMClkEn,     
DTCMClkEn,     
IEXTClkEn,     
DEXTClkEn,     
CP15PipeClkEn, 
CP15DbgClkEn,  
ARM9ClkEn,     
MMUClkEn ,
ETMEN, 
TESTMODE,
GCLK,
ARM9Clk,
IEXTClk,
DEXTClk,
ICClk,
DCClk, 
DTCMClk,
ITCMClk,
CP15PipeClk, 
CP15DebugClk,
MMUClk,
ETMIFClk,
pETMEN
);

input  CLK;
input  HRESETn;
input  DisableBlkClkGate;
input  WFIWakeUp;
input  STANDBYWFI;
input  ICClkEn;       
input  DCClkEn;       
input  ITCMClkEn;     
input  DTCMClkEn;     
input  IEXTClkEn;     
input  DEXTClkEn;     
input  CP15PipeClkEn; 
input  CP15DbgClkEn;  
input  ARM9ClkEn;     
input  MMUClkEn;
input  ETMEN; 
input  TESTMODE;

output GCLK; 
output ARM9Clk;
output IEXTClk;
output DEXTClk;
output ICClk;
output DCClk;
output DTCMClk;
output ITCMClk;
output CP15PipeClk; 
output CP15DebugClk;
output MMUClk;
output ETMIFClk; 
output pETMEN;

reg pETMEN;

always @(posedge GCLK) begin
  pETMEN <= ETMEN;
end

  
`ifdef BLOCK_LEVEL_CLOCK_GATING

wire disableg;

wire GCLKEn;


// stall GCLK only in WFI mode

assign GCLKEn = ~STANDBYWFI | WFIWakeUp;

// prevent clock gating during SCAN test or
// if disabled via CP15

assign disableg = TESTMODE | DisableBlkClkGate;


a926ejsClkGate uGCLK(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (GCLKEn),
                     .disableg  (disableg),
                     .GatedClk  (GCLK)
);

a926ejsClkGate uARM9 (
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (ARM9ClkEn),
                     .disableg  (disableg),
                     .GatedClk  (ARM9Clk)
);


a926ejsClkGate uCP15Dbg(
                        .CLK       (CLK),
                        .RESETn    (HRESETn),
                        .ClkEnable (CP15DbgClkEn),
                        .disableg  (disableg),
                        .GatedClk  (CP15DebugClk)
);


a926ejsClkGate uCP15Pipe(
                        .CLK       (CLK),
                        .RESETn    (HRESETn),
                        .ClkEnable (CP15PipeClkEn),
                        .disableg  (disableg),
                        .GatedClk  (CP15PipeClk)
);


a926ejsClkGate uIC(
                   .CLK       (CLK),
                   .RESETn    (HRESETn),
                   .ClkEnable (ICClkEn),
                   .disableg  (disableg),
                   .GatedClk  (ICClk)
);


a926ejsClkGate uDC(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (DCClkEn),
                     .disableg  (disableg),
                     .GatedClk  (DCClk)
);


a926ejsClkGate uITCM(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (ITCMClkEn),
                     .disableg  (disableg),
                     .GatedClk  (ITCMClk)
);


a926ejsClkGate uDTCM(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (DTCMClkEn),
                     .disableg  (disableg),
                     .GatedClk  (DTCMClk)
);


a926ejsClkGate uIEXT(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (IEXTClkEn),
                     .disableg  (disableg),
                     .GatedClk  (IEXTClk)
);


a926ejsClkGate uDEXT(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (DEXTClkEn),
                     .disableg  (disableg),
                     .GatedClk  (DEXTClk)
);


a926ejsClkGate uMMU(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (MMUClkEn),
                     .disableg  (disableg),
                     .GatedClk  (MMUClk)
);


a926ejsClkGate uETM(
                     .CLK       (CLK),
                     .RESETn    (HRESETn),
                     .ClkEnable (pETMEN),
                     .disableg  (disableg),
                     .GatedClk  (ETMIFClk)
);



`else

// no block level clock gating option

assign GCLK = CLK;
assign ARM9Clk = CLK;
assign IEXTClk = CLK;
assign DEXTClk = CLK;
assign ICClk   = CLK;
assign DCClk = CLK;
assign DTCMClk = CLK;
assign ITCMClk = CLK;
assign ETMIFClk = CLK;
assign CP15PipeClk = CLK;
assign CP15DebugClk = CLK;
assign MMUClk = CLK;

`endif

endmodule 
