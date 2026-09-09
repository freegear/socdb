// -----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : RtcTrick.v.rca
//  File Revision          : 1.8
//  
//  Release Information    : PrimeCell(TM)-PL031-REL1v0
//  
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Purpose  : The Rtc trickbox module performs the following functions:
//             - Generates the CLK1HZ signal to the Rtc.
//             - Generates the SCANMODE signal to the Rtc.
//
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module RtcTrick (         
                 PCLK,
                 PRESETn,
                 PENABLE,
                 PSELT,
                 PWRITE, 
                 PADDR,
                 PWData, 
                 PRData,
                 RTCINTR,
                 CLK1HZ,
                 nRTCRST,  
                 nPOR,       
                 SCANMODE
                );

input         PCLK;      // APB CLock
input         PRESETn;   // AMBA reset
input         PENABLE;   // APB enable
input         PSELT;     // Trickbox select
input         PWRITE;    // APB write
input   [7:2] PADDR;     // APB address bus
input  [15:0] PWData;    // APB write databus
input         RTCINTR;   // RTC interrupt signal  
output [15:0] PRData;    // APB read databus
output        CLK1HZ;    // CLK1HZ signal
output        nRTCRST;   // RTC reset signal
output        nPOR;      // RTC power on reset signal
output        SCANMODE;  // SCANMODE control pin

// -----------------------------------------------------------------------------
//
//                             RtcTrick
//                             ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// CLK1HZ and SCANMODE, the external inputs to the RTC, are generated in this
// module. The width of the high phase of the CLK1HZ signal is programmable
// through the RTCLK1HZH register and the width of the low phase is programmable
// through the RTCLK1HZL register. The SCANMODE signal can be set by writing a 1
// into the bit 0 of RTCR register. The CLK1HZ signal is enabled by setting the
// bit 1 of the RTCR register. The Synchronized CLK1HZ signal can be read at the
// bit position 0 of the RTSR register. 
//
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//   RTC Trickbox Registers                                                
//   ======================                                                
//   RTCR       0x00    2  R/W  Control Register                            
//   RTSR       0x04    1  R    CLK1HZ Status Register                     
//   RTCLK1HZH  0x08   16  R/W  CLK1HZ High Phase Control Register         
//   RTCLK1HZL  0x0C   16  R/W  CLK1HZ Low Phase Control Register          
// -----------------------------------------------------------------------------
  
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        PCLK; 
// APB CLock            (Module input)

wire        PRESETn;     
// AMBA reset           (Module input)

wire        PENABLE;   
// APB enable           (Module input)

wire        PSELT;  
// Trickbox select      (Module input)

wire        PWRITE;    
// APB write            (Module input)

wire  [7:2] PADDR;     
// APB address bus      (Module input)

wire [15:0] PWData;    
// APB write databus    (Module input)

wire [15:0] PRData;    
// APB read databus     (Module output)

wire        CLK1HZ; 
// CLK1HZ signal        (Module output)
  
wire        SCANMODE; 
// SCANMODE control pin (Module output)

// Decodes for internal registers
wire        RTCRdec;
// Decode for Trickbox Control Register 

wire        RTSRdec;
// Decode for Trickbox Status Register 

wire        RTCLK1HZHdec;
// Decode for RTCLK1HZH register 

wire        RTCLK1HZLdec;
// Decode for RTCLK1HZL register

wire        RTCRrd;
// Read enable for RTCR

wire        RTCRwr;
// Write enable for RTCR  

wire        RTSRrd;
// Read enable for RTSR

wire        RTCLK1HZHrd;
// Read enable for RTCLK1HZH register

wire        RTCLK1HZHwr;
// Write enable for RTCLK1HZH register 

wire        RTCLK1HZLrd;
// Read enable for RTCLK1HZL register 

wire        RTCLK1HZLwr;
// Write enable for RTCLK1HZL register 

wire [15:0] NextRTINTR;
// D-input for Trickbox interrupt register

wire        RTINTRrd;
// Read enable for Interrupt id register

wire        RTINTRdec;
// Decode for RTINTR register
  
wire        RTCINTR;
// RTC interrupt signal
  
  
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [1:0] NextRTCR;
// D-input for RTCR   

reg   [1:0] RTCR;
// Trickbox Control Register 

reg  [15:0] NextRTCLK1HZH;
// D-input for RTCLK1HZH 

reg  [15:0] RTCLK1HZH;
// RTCLK1HZH register 

reg  [15:0] NextRTCLK1HZL; 
// D-input for RTCLK1HZL 

reg  [15:0] RTCLK1HZL;
// RTCLK1HZL register 

reg  [15:0] NextSyncCLK1HZ; 
// D-input for SyncCLK1HZ; 

reg         SyncCLK1HZ;
// SyncCLK1HZ register 

reg         iCLK1HZ;
// Internal CLK1HZ

reg  [15:0] RTINTR ;
// RTINR, interrupt id register

reg         Sync1PRESETn;
// SyncPRESETn register
 
reg         Sync2PRESETn ;
// Sync2PRESETn register
   
reg         nRTCRST ;
// RTC reset signal
  
reg         nPOR ;
// RTC power on reset signal  

// -----------------------------------------------------------------------------
// 
// Main body of code
// =================
// 
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// The clock period register values need to be initialised to prevent the  
// RTCLK1HZH/L lines from going to 'x' and consequently causing 0-cycle 
// oscillations during simulations. Note that the initialisation values are 
// non-zero. A value of zero in these registers would also cause 0-cycle
// oscillations.
// -----------------------------------------------------------------------------

initial
  begin
    RTCLK1HZH     = 16'h0001;
    NextRTCLK1HZH = 16'h0001;
    RTCLK1HZL     = 16'h0001; 
    NextRTCLK1HZL = 16'h0001; 
  end

// -----------------------------------------------------------------------------
// CLK1HZ signal generation based on status of bit 1 of RTCR register  
// -----------------------------------------------------------------------------
assign CLK1HZ = (RTCR[1] == 1'b1) ? iCLK1HZ : 1'b0;

// -----------------------------------------------------------------------------
// Address Decodes
// -----------------------------------------------------------------------------
assign RTCRdec = (PADDR[4:2] == 3'b000) ? 1'b1 : 1'b0;
assign RTCRrd  = PSELT & PENABLE & (~ PWRITE) & RTCRdec;
assign RTCRwr  = PSELT & PENABLE & PWRITE & RTCRdec;

assign RTSRdec = (PADDR[4:2] == 3'b001) ? 1'b1 : 1'b0;
assign RTSRrd  = PSELT & PENABLE & (~ PWRITE) & RTSRdec;

assign RTCLK1HZHdec = (PADDR[4:2] == 3'b010) ? 1'b1 : 1'b0;
assign RTCLK1HZHrd  = PSELT & PENABLE & (~ PWRITE) & RTCLK1HZHdec;
assign RTCLK1HZHwr  = PSELT & PENABLE & PWRITE & RTCLK1HZHdec;

assign RTCLK1HZLdec = (PADDR[4:2] == 3'b011) ? 1'b1 : 1'b0;
assign RTCLK1HZLrd  = PSELT & PENABLE & (~ PWRITE) & RTCLK1HZLdec;
assign RTCLK1HZLwr  = PSELT & PENABLE & PWRITE & RTCLK1HZLdec;

assign RTINTRdec    = (PADDR[4:2] == 3'b100) ? 1'b1 : 1'b0;
assign RTINTRrd     = PSELT & PENABLE & (~ PWRITE) & RTINTRdec;
assign NextRTINTR   = {15'b000000000000000,RTCINTR};

  
// -----------------------------------------------------------------------------
// Implementation of Trickbox Control Register (RTCR) 
// -----------------------------------------------------------------------------
always @(RTCR or PWData or RTCRwr)
begin : p_RTCRComb
  if (RTCRwr == 1'b1)
    NextRTCR = PWData[1:0];
  else
    NextRTCR = RTCR;
end // p_RTCRComb;
 
always @(posedge PCLK or negedge PRESETn)
begin : p_RTCRSeq
  if (PRESETn == 1'b0) 
    RTCR <= 2'b00;
  else
    RTCR <= NextRTCR;
end // p_RTCRSeq;

// -----------------------------------------------------------------------------
// Implementation of Trickbox CLK1HZ High-phase Register (RTCLK1HZH) 
// -----------------------------------------------------------------------------
always @(RTCLK1HZH or PWData or RTCLK1HZHwr)
begin : p_RTCLK1HZHComb  
  if (RTCLK1HZHwr == 1'b1)
    NextRTCLK1HZH = PWData;
  else
    NextRTCLK1HZH = RTCLK1HZH;
end // p_RTCLK1HZHComb
 
always @(posedge PCLK or negedge PRESETn)
begin : p_RTCLK1HZHSeq  
  if (PRESETn == 1'b0) 
    RTCLK1HZH <= 16'h0001; 
  else
    RTCLK1HZH <= NextRTCLK1HZH;
end // p_RTCLK1HZHSeq

// -----------------------------------------------------------------------------
// Implementation of Trickbox CLK1HZ Low-phase Register (RTCLK1HZL) 
// -----------------------------------------------------------------------------
always @(RTCLK1HZL or PWData or RTCLK1HZLwr)
begin : p_RTCLK1HZLComb  
  if (RTCLK1HZLwr == 1'b1)
    NextRTCLK1HZL = PWData;
  else
    NextRTCLK1HZL = RTCLK1HZL;
end // p_RTCLK1HZLComb
 
always @(posedge PCLK or negedge PRESETn)
begin : p_RTCLK1HZLSeq  
  if (PRESETn == 1'b0)
    RTCLK1HZL <= 16'h0001; 
  else
    RTCLK1HZL <= NextRTCLK1HZL;
end // p_RTCLK1HZLSeq

// -----------------------------------------------------------------------------
// Synchronize CLK1HZ to the posedge edge of the PCLK 
// to create SyncCLK1HZ. This signal will be readable at
// bit position 0 of the RTSR.
// -----------------------------------------------------------------------------

always @(RTCR or iCLK1HZ)
begin : p_SyncCLK1HZComb
  if (RTCR[1] == 1'b1)
    NextSyncCLK1HZ = iCLK1HZ;
  else
    NextSyncCLK1HZ = 1'b0;
end // p_SyncCLK1HZComb

always @(posedge PCLK or negedge PRESETn)
begin : p_SyncCLK1HZSeq    
  if (PRESETn == 1'b0)
    SyncCLK1HZ <= 1'b0;
  else
    SyncCLK1HZ <= NextSyncCLK1HZ;
end // p_SyncCLK1HZSeq

// -----------------------------------------------------------------------------
// Generate the CLK1HZ signal using the programmed phase values.
// -----------------------------------------------------------------------------
always
begin : p_CLockGenComb  
  iCLK1HZ = 1'b0;
  #(RTCLK1HZL);
  iCLK1HZ = 1'b1;
  #(RTCLK1HZH);
end // p_ClockGenComb 


// -----------------------------------------------------------------------------
// Output register. THis register stores the current status of the UUT interrupt
// pin.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_IntSeq
  if (PRESETn == 1'b0)
    RTINTR   <= 16'h0000;
  else
    RTINTR <= NextRTINTR;
end // p_IntSeq

  
// -----------------------------------------------------------------------------
// The SCANMODE pin is controlled via writes to bit 0 of the RTCR.
// -----------------------------------------------------------------------------
assign SCANMODE = RTCR[0];

  
// -----------------------------------------------------------------------------
// RTC Reset signal generation
// -----------------------------------------------------------------------------
always @(SCANMODE or PRESETn or Sync2PRESETn)
begin : p_ResetComb
  if (SCANMODE == 1'b1)
    nRTCRST = PRESETn;
  else
    nRTCRST = Sync2PRESETn;
end // p_ResetComb

always @(posedge CLK1HZ or negedge PRESETn)
  begin : p_ResetSeq    
    if (PRESETn == 1'b0)
      begin
        Sync1PRESETn <= 1'b0;
        Sync2PRESETn <= 1'b0;
      end    
    else
      begin
        Sync1PRESETn <= PRESETn;
        Sync2PRESETn <= Sync1PRESETn;
      end  
end // p_ResetSeq 

// -----------------------------------------------------------------------------
// RTC Power on Reset signal generation
// -----------------------------------------------------------------------------
always @(SCANMODE or PRESETn or Sync2PRESETn)
begin : p_nPORComb
  if (SCANMODE == 1'b1)
    nPOR = PRESETn;
  else
    nPOR = Sync2PRESETn;
end // p_nPORComb

// -----------------------------------------------------------------------------
// Mux out Read Data onto the APB
// Note that the "===" operator has been used instead of the "==" operator
// to prevent 'x' propagation onto the PRData lines when any of the select
// lines go to 'x'. The select lines may go to 'x' before clock edges since 
// the PSELT and the PWRITE lines are driven to 'x' in between accesses by the
// testbench.
// -----------------------------------------------------------------------------
assign PRData  = (RTCRrd      === 1'b1)  ? {{14{1'b0}},RTCR}          
                :(RTSRrd      === 1'b1)  ? {{15{1'b0}},SyncCLK1HZ}    
                :(RTCLK1HZHrd === 1'b1)  ? RTCLK1HZH                  
                :(RTCLK1HZLrd === 1'b1)  ? RTCLK1HZL                  
                :(RTINTRrd    === 1'b1)  ? RTINTR
                :16'h0000;

// -----------------------------------------------------------------------------
// The SCANMODE pin is controlled via writes to bit 0 of the RTCR.
// -----------------------------------------------------------------------------
assign SCANMODE = RTCR[0];


  
endmodule

// --======================= End of RtcTrick =================================--
