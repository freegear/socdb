// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicIntResolver.v.rca
// File Revision          : 1.11
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block resolves the interrupt according to the priority of the
//           interrupt source
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicIntResolver (
// Inputs
                 HCLK,
                 HRESETn,
                 IrqSync,
                 Port0,
                 Port1,
                 Port2,
                 Port3,
                 Port4,
                 Port5,
                 Port6,
                 Port7,
                 Port8,
                 Port9,
                 Port10,
                 Port11,
                 Port12,
                 Port13,
                 Port14,
                 Port15,
                 ITEN,
                 IrqAsync,
                 IRQForceVal,
                 CurrentPriority,
                 nIRQINForceVal,
                 nFIQINForceVal,
                 FIQForceVal,
                 nVICIRQIN,
                 VICIRQINREG,
                 nVICFIQIN,
                 VICFIQINREG,
                 VICINTSOURCE,
                 VICSoftInt,
                 VICIntEnable,
                 VICIntSelect,

// Outputs
                 FIQTestVal,
                 nFIQINTestVal,
                 nIRQINTestVal,
                 nVICIRQ,
                 nVICFIQ,
                 IRQPortRes,
                 IRQRequestRes,
                 IRQReqLevelRes,
                 IRQTestVal,
                 DaisyChainIn,
                 CurrentLevelMask,
                 Sync2DaisyIn,
                 Sync2IrqStatus,
                 VICRawIntr,
                 VICIRQStatus,
                 VICFIQStatus
                 );

// Inputs

input         HCLK;             // AHB Clock
input         HRESETn;          // AHB reset
input  [15:0] IrqSync;          // Synchronous IRQ
input   [5:0] Port0;            // Priority level of port0
input   [5:0] Port1;            // Priority level of port1
input   [5:0] Port2;            // Priority level of port2
input   [5:0] Port3;            // Priority level of port3
input   [5:0] Port4;            // Priority level of port4
input   [5:0] Port5;            // Priority level of port5
input   [5:0] Port6;            // Priority level of port6
input   [5:0] Port7;            // Priority level of port7
input   [5:0] Port8;            // Priority level of port8
input   [5:0] Port9;            // Priority level of port9
input   [5:0] Port10;           // Priority level of port10
input   [5:0] Port11;           // Priority level of port11
input   [5:0] Port12;           // Priority level of port12
input   [5:0] Port13;           // Priority level of port13
input   [5:0] Port14;           // Priority level of port14
input   [5:0] Port15;           // Priority level of port15
input         ITEN;             // Integration test enable
input  [15:0] IrqAsync;         // Asynchronous IRQ
input         IRQForceVal;      // VICIRQ o/p force value (non-invert)
input  [15:0] CurrentPriority;  // Current Interrupt priority
input         nIRQINForceVal;   // nVICIRQIN i/p force value
input         nFIQINForceVal;   // nVICFIQIN i/p force value
input         FIQForceVal;      // VICFIQ o/p force value (non-invert)
input         nVICIRQIN;        // Daisy IRQ chain input
input         VICIRQINREG;      // Register enable signal for VICIRQIN
input         nVICFIQIN;        // Daisy FIQ chain input
input         VICFIQINREG;      // Register enable signal for VICFIQIN
input  [31:0] VICSoftInt;       // Software interrupt source
input  [31:0] VICINTSOURCE;     // Interrupt source
input  [31:0] VICIntEnable;     // Interrupt Enable
input  [31:0] VICIntSelect;     // Interrupt Type

// Outputs
output        FIQTestVal;       // VICFIQ o/p force value (non-invert)
output        nIRQINTestVal;    // nVICIRQIN i/p force value
output        nFIQINTestVal;    // nVICFIQIN i/p force value
output        nVICIRQ;          // Asynchronous IRQ output
output        nVICFIQ;          // Asynchronous FIQ output
output  [5:0] IRQPortRes;       // Resolved IRQ source
output        IRQRequestRes;    // Synchronized IRQ request
output  [3:0] IRQReqLevelRes;   // Priority level of current IRQ request
output        IRQTestVal;       // VICIRQ o/p force value (non-invert)
output        DaisyChainIn;     // DaisyChain input after mux with test signal
output        Sync2DaisyIn;     // 2nd flip-flop for synchronization of
                                // DaisyChainIn
output [31:0] Sync2IrqStatus;   // Second flip-flop stage
output [15:0] CurrentLevelMask; // Mask due to current interrupt priority
                                // level
output [31:0] VICFIQStatus;     // Status of the FIQ after disabling
                                // the interrupt
output [31:0] VICIRQStatus;     // Status of the FIQ after disabling
                                // the interrupt
output [31:0] VICRawIntr;       // Status of the interrupts before masking

// Inputs

wire         HCLK;              // AHB Clock
wire         HRESETn;           // AHB reset
wire  [15:0] IrqSync;           // Synchronous IRQ
wire   [5:0] Port0;             // Priority level of port0
wire   [5:0] Port1;             // Priority level of port1
wire   [5:0] Port2;             // Priority level of port2
wire   [5:0] Port3;             // Priority level of port3
wire   [5:0] Port4;             // Priority level of port4
wire   [5:0] Port5;             // Priority level of port5
wire   [5:0] Port6;             // Priority level of port6
wire   [5:0] Port7;             // Priority level of port7
wire   [5:0] Port8;             // Priority level of port8
wire   [5:0] Port9;             // Priority level of port9
wire   [5:0] Port10;            // Priority level of port10
wire   [5:0] Port11;            // Priority level of port11
wire   [5:0] Port12;            // Priority level of port12
wire   [5:0] Port13;            // Priority level of port13
wire   [5:0] Port14;            // Priority level of port14
wire   [5:0] Port15;            // Priority level of port15
wire         ITEN;              // Integration test enable
wire  [15:0] IrqAsync;          // Asynchronous IRQ
wire         IRQForceVal;       // VICIRQ o/p force value (non-invert)
wire  [15:0] CurrentPriority;   // Current Interrupt priority
wire         nIRQINForceVal;    // nVICIRQIN i/p force value
wire         nFIQINForceVal;    // nVICFIQIN i/p force value
wire         FIQForceVal;       // VICFIQ o/p force value (non-invert)
wire         nVICIRQIN;         // Daisy chain IRQ input
wire         VICIRQINREG;       // Register enable signal for VICIRQIN
wire         nVICFIQIN;         // Daisy chain FIQ input
wire         VICFIQINREG;       // Register enable signal for VICFIQIN
wire  [31:0] VICSoftInt;        // Software interrupt source
wire  [31:0] VICINTSOURCE;      // Interrupt source
wire  [31:0] VICIntEnable;      // Interrupt Enable
wire  [31:0] VICIntSelect;      // Interrupt Type

// Outputs
wire         FIQTestVal;        // VICFIQ o/p read back (non-invert)
wire         nIRQINTestVal;     // nVICIRQIN i/p force value
wire         nFIQINTestVal;     // nVICFIQIN i/p force value
reg    [5:0] IRQPortRes;        // Resolved IRQ source
reg          IRQRequestRes;     // Synchronized IRQ request
reg    [3:0] IRQReqLevelRes;    // Priority level of current IRQ request
wire         IRQTestVal;        // VICIRQ o/p force value (non-invert)
wire         DaisyChainIn;      // DaisyChain input after mux with test signal
wire         nVICFIQ;           // Asynchronous FIQ output
wire         nVICIRQ;           // Asynchronous IRQ output
reg          Sync2DaisyIn;      // 2nd flip-flop for synchronization of
                                // DaisyChainIn
reg   [31:0] Sync2IrqStatus;    // Second flip-flop stage
reg   [15:0] CurrentLevelMask;  // Mask due to current interrupt priority
                                // level
wire  [31:0] VICRawIntr;        // Status of the interrupts before masking
wire  [31:0] VICFIQStatus;      // Status of the FIQ after disabling
                                // the interrupt
wire  [31:0] VICIRQStatus;      // Status of the FIQ after disabling
                                // the interrupt

// -----------------------------------------------------------------------------
//
//                             VicIntResolver
//                             ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block has the following functionality,
// - Resolves the interrupts according to the priority.
//     When there are more than one interrupts asserted, then the interrupts are
//     resolved according to the priority programmed.
// - It generates VICRAWINTR, VICIRQSTATUS, VICFIQSTATUS which are the
// contents of the registers.
// - It also generates nVICIRQ and nVICFIQ asynchronously.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire         nVICIRQINtmux;     // Test mux for nVICIRQIN
wire         nVICFIQINtmux;     // Test mux for nVICFIQIN
wire         nVICIRQINmux;      // Clocked or unclocked nVICIRQINtmux
                                // depending on VICIRQINREG
wire         VICIRQtmux;        // Test mux for VICIRQ
wire         nVICFIQINmux;      // Clocked or unclocked nVICFIQINtmux depending
                                // on VICFIQINREG
wire         iDaisyChainIn;     // Internal version of the DaisyChainIn
wire  [31:0] RawIntr;           // Raw interrupt status
wire  [31:0] MaskedRawIntr;     // Masked raw interrupt
wire  [31:0] iIrqStatus;        // Internal version of VICIRQStatus
wire  [31:0] iFiqStatus;        // Internal version of VICFIQStatus

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg           nVICIRQINQ;       // Registered nVICIRQIN test mux output
reg           nVICFIQINQ;       // Registered nVICFIQIN test mux output
reg           VICFIQtmux;       // Test mux for VICFIQ
reg           Sync1DaisyIn;     // 1st flip-flop for synchronization of
                                // DaisyChainIn
reg    [31:0] Sync1IrqStatus;   // First flip-flop stage

// Include Parameters File
`include "VicParams.v"

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// synopsys translate_off
// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------


// synopsys translate_on
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Determine which level of IRQ to be accepted
// -----------------------------------------------------------------------------
always @(IrqSync or Port0 or Port1 or Port2 or Port3 or Port4 or Port5 or
         Port6 or Port7 or Port8 or Port9 or Port10 or Port11 or Port12 or
         Port13 or Port14 or Port15)
begin : p_FinalDecodeComb
  if (IrqSync[0])
    begin
      IRQPortRes     = Port0;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0000;
    end
  else if (IrqSync[1])
    begin
      IRQPortRes     = Port1;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0001;
    end
  else if (IrqSync[2])
    begin
      IRQPortRes     = Port2;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0010;
    end
  else if (IrqSync[3])
    begin
      IRQPortRes     = Port3;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0011;
    end
  else if (IrqSync[4])
    begin
      IRQPortRes     = Port4;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0100;
    end
  else if (IrqSync[5])
    begin
      IRQPortRes     = Port5;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0101;
    end
  else if (IrqSync[6])
    begin
      IRQPortRes     = Port6;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0110;
    end
  else if (IrqSync[7])
    begin
      IRQPortRes     = Port7;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b0111;
    end
  else if (IrqSync[8])
    begin
      IRQPortRes     = Port8;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1000;
    end
  else if (IrqSync[9])
    begin
      IRQPortRes     = Port9;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1001;
    end
  else if (IrqSync[10])
    begin
      IRQPortRes     = Port10;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1010;
    end
  else if (IrqSync[11])
    begin
      IRQPortRes     = Port11;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1011;
    end
  else if (IrqSync[12])
    begin
      IRQPortRes     = Port12;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1100;
    end
  else if (IrqSync[13])
    begin
      IRQPortRes     = Port13;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1101;
    end
  else if (IrqSync[14])
    begin
      IRQPortRes     = Port14;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1110;
    end
  else if (IrqSync[15])
    begin
      IRQPortRes     = Port15;
      IRQRequestRes  = 1'b1;
      IRQReqLevelRes = 4'b1111;
    end
  else
    begin
      IRQPortRes     = {6{1'b0}};
      IRQRequestRes  = 1'b0 ;
      IRQReqLevelRes = 4'b1111;
    end
end // p_FinalDecodeComb

// -----------------------------------------------------------------------------
// Generate the VICIRQtmux, pre inverted version of nVICIRQ.
// When ITEN is high pass the force value. Else if there is any interrupt
// then, assert the VICIRQtmux. Once the interrupt gets the acknowledge from the
// CPU for the address read that the interrupt is deasserted.
// If there is any interrupt higher than the currently servicing interrupt is
// asserted then VICIRQtmux is asserted.
// -----------------------------------------------------------------------------
assign VICIRQtmux = ((ITEN == 1'b1) ? IRQForceVal :
                      (IrqAsync == 16'b0000000000000000) ? 1'b0 : 1'b1);

// -----------------------------------------------------------------------------
// Connect to top level
// -----------------------------------------------------------------------------
assign  nVICIRQ  = ~(VICIRQtmux);
assign  IRQTestVal  = VICIRQtmux;

// -----------------------------------------------------------------------------
// Generate current priority mask depending on the priority of the currently
// servicing interrupt.
// -----------------------------------------------------------------------------
always @(CurrentPriority)
begin : p_CurrLvlMaskComb
  if (CurrentPriority[0])
    begin
      CurrentLevelMask  = 16'b0000000000000000;
    end
  else if (CurrentPriority[1])
    begin
      CurrentLevelMask  = 16'b0000000000000001;
    end
  else if (CurrentPriority[2])
    begin
      CurrentLevelMask  = 16'b0000000000000011;
    end
  else if (CurrentPriority[3])
    begin
      CurrentLevelMask  = 16'b0000000000000111;
    end
  else if (CurrentPriority[4])
    begin
      CurrentLevelMask  = 16'b0000000000001111;
    end
  else if (CurrentPriority[5])
    begin
      CurrentLevelMask  = 16'b0000000000011111;
    end
  else if (CurrentPriority[6])
    begin
      CurrentLevelMask  = 16'b0000000000111111;
    end
  else if (CurrentPriority[7])
    begin
      CurrentLevelMask  = 16'b0000000001111111;
    end
  else if (CurrentPriority[8])
    begin
      CurrentLevelMask  = 16'b0000000011111111;
    end
  else if (CurrentPriority[9])
    begin
      CurrentLevelMask  = 16'b0000000111111111;
    end
  else if (CurrentPriority[10])
    begin
      CurrentLevelMask  = 16'b0000001111111111;
    end
  else if (CurrentPriority[11])
    begin
      CurrentLevelMask  = 16'b0000011111111111;
    end
  else if (CurrentPriority[12])
    begin
      CurrentLevelMask  = 16'b0000111111111111;
    end
  else if (CurrentPriority[13])
    begin
      CurrentLevelMask  = 16'b0001111111111111;
    end
  else if (CurrentPriority[14])
    begin
      CurrentLevelMask  = 16'b0011111111111111;
    end
  else if (CurrentPriority[15])
    begin
      CurrentLevelMask  = 16'b0111111111111111;
    end
  else
    begin
      CurrentLevelMask  = 16'b1111111111111111;
    end
end  // p_CurrLvlMaskComb

// -----------------------------------------------------------------------------
// IRQ daisy chain input Integration Test multiplexer
// -----------------------------------------------------------------------------
assign nVICIRQINtmux  = (ITEN  ? nIRQINForceVal : nVICIRQIN);

// -----------------------------------------------------------------------------
// Determine if input should be registered
// -----------------------------------------------------------------------------
assign nVICIRQINmux  = (VICIRQINREG ? nVICIRQINQ : nVICIRQINtmux);

// -----------------------------------------------------------------------------
// Connect to priority encoding logic
// -----------------------------------------------------------------------------
assign  iDaisyChainIn  = ~(nVICIRQINmux);

// -----------------------------------------------------------------------------
// Connect to top level for read back
// -----------------------------------------------------------------------------
assign  nIRQINTestVal  = nVICIRQINmux;

// -----------------------------------------------------------------------------
// Registered daisy chain IRQ and FIQ.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegDaisyChainSeq
  if (HRESETn ==1'b0)
    begin
      nVICIRQINQ  <= 1'b1;
      nVICFIQINQ  <= 1'b1;
    end
  else
    begin
      nVICFIQINQ  <= nVICFIQINtmux;
      nVICIRQINQ  <= nVICIRQINtmux;
    end
end // p_RegDaisyChainSeq

// -----------------------------------------------------------------------------
// FIQ daisy chain input Integration Test multiplexer
// -----------------------------------------------------------------------------
assign nVICFIQINtmux  = (ITEN ? nFIQINForceVal  : nVICFIQIN);

// -----------------------------------------------------------------------------
// Determine if input should be registered
// -----------------------------------------------------------------------------
assign nVICFIQINmux  = (VICFIQINREG ? nVICFIQINQ : nVICFIQINtmux);

// -----------------------------------------------------------------------------
// Connect to top level for read back
// -----------------------------------------------------------------------------
assign  nFIQINTestVal  = nVICFIQINmux;

// -----------------------------------------------------------------------------
// Combine with Software interrupt
// -----------------------------------------------------------------------------
assign  RawIntr  = (VICINTSOURCE  | VICSoftInt);

// -----------------------------------------------------------------------------
// Interrupt enable mask
// -----------------------------------------------------------------------------
assign  MaskedRawIntr  = (RawIntr & VICIntEnable);

// -----------------------------------------------------------------------------
// FIQ group
// -----------------------------------------------------------------------------
assign  iFiqStatus  = (MaskedRawIntr & VICIntSelect);

// -----------------------------------------------------------------------------
// IRQ group
// -----------------------------------------------------------------------------
assign  iIrqStatus  = (MaskedRawIntr  & ~(VICIntSelect));

// -----------------------------------------------------------------------------
// Connecting status to top level
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// FIQ status for read back
// -----------------------------------------------------------------------------
assign  VICFIQStatus  = iFiqStatus;

// -----------------------------------------------------------------------------
// IRQ status for read back
// -----------------------------------------------------------------------------
assign  VICIRQStatus  = iIrqStatus;

// -----------------------------------------------------------------------------
// RAW interrupt status for read back
// -----------------------------------------------------------------------------
assign  VICRawIntr  = RawIntr;

// -----------------------------------------------------------------------------
// FIQ output
// In test mode, select the integration test value. If any one of the interrupt
// is asserted, assert the FIQ. If the daisy chain interrupt is asserted select
// the daisy chain FIQ.
// -----------------------------------------------------------------------------
always @(iFiqStatus or nVICFIQINmux or ITEN or FIQForceVal)
begin : p_FIQoutputComb
  if (ITEN)
    begin
       VICFIQtmux = FIQForceVal;
    end
  else
    begin
      if (iFiqStatus != `ZERO32)
        begin
          VICFIQtmux  = 1'b1;
        end
      else
        begin
           VICFIQtmux  = ~(nVICFIQINmux);
        end
    end
end // p_FIQoutputComb

// -----------------------------------------------------------------------------
// Connect to top level
// -----------------------------------------------------------------------------
assign  FIQTestVal  = VICFIQtmux;
assign  nVICFIQ  = ~(VICFIQtmux);
assign  DaisyChainIn = iDaisyChainIn;

// -----------------------------------------------------------------------------
// Synchronize interrupt signals to HCLK
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_Sync2HCLKSeq
  if (HRESETn ==1'b0)
    begin
      Sync1DaisyIn   <= 1'b0;
      Sync2DaisyIn   <= 1'b0;
      Sync1IrqStatus <= {32{1'b0}};
      Sync2IrqStatus <= {32{1'b0}};
    end
  else
    begin
      Sync1DaisyIn   <= iDaisyChainIn;
      Sync2DaisyIn   <= Sync1DaisyIn;
      Sync1IrqStatus <= iIrqStatus;
      Sync2IrqStatus <= Sync1IrqStatus;
    end
end // p_Sync2HCLKSeq

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
