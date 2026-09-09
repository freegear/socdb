// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DBI.v.rca
// File Revision          : 1.21
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements a dynamic priority arbitration logic for the
//           External Data Bus and Address Bus Interface between SmcCore,
//           TIC block and the Additional Memory Controller. A bypass logic
//           is also implemented in the DBI which will enable the Smc to
//           interface with EbiSdram
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DBI (
// Inputs
            HCLK,
            HRESETn,

            TICBUSREQ,
            SMBUSREQ,
            MCBUSREQ,
            TICBUSGNTEBI,
            SMBUSGNTEBI,
            nSMCDATAEN,
            MCDATAEN,
            TICREAD,
            SMCDATAOUT,
            MCDATAOUT,
            TBUSOUT,
            SMCADDR,
            MCADDR,
            EXTBUSMUX,

// Outputs
            TICBUSREQEBI,
            SMBUSREQEBI,
            TICBUSGNT,
            SMBUSGNT,
            MCBUSGNT,
            nSMDATAEN,
            TICREADEBI,
            SMDATAOUT,
            TBUSOUTEBI,
            SMADDR
           );

// Inputs
input         HCLK;            // AHB Clock
input         HRESETn;         // AHB Reset
input         TICBUSREQ;       // Internal Bus Request from TIC to DBI
input         SMBUSREQ;        // Internal Bus Request from SmcCore to DBI
input         MCBUSREQ;        // Bus Request from the Additional Memory
                               // Controller
input         TICBUSGNTEBI;    // Bus Grant input to TIC from external EbiSdram
input         SMBUSGNTEBI;     // Bus Grant input to SmcCore from external
                               // EbiSdram
input   [3:0] nSMCDATAEN;      // Pad enables from SmcCore
input   [3:0] MCDATAEN;        // Pad enables from Additional Memory Controller
input         TICREAD;         // Pad enables from TIC
input  [31:0] SMCDATAOUT;      // SmcCore Output Data bus
input  [31:0] MCDATAOUT;       // Additional Memory controller Output Data Bus
input  [31:0] TBUSOUT;         // TIC output Data bus
input  [25:0] SMCADDR;         // SmcCore Address Bus;
input  [25:0] MCADDR;          // Additional Memory Controller Address Bus

input         EXTBUSMUX;       // This tied input will determine whether the
                               // internal DBI or external EbiSdram will be
                               // used for bus arbitration

// Outputs
output        TICBUSREQEBI;    // External Data bus request signal from TIC
                               // to the EbiSdram
output        SMBUSREQEBI;     // External Data bus request signal from SmcCore
                               // to the EbiSdram
output        TICBUSGNT;       // Bus Grant to TIC from either DBI or EbiSdram
output        SMBUSGNT;        // Bus Grant to SmcCore from either DBI or
                               // EbiSdram
output        MCBUSGNT;        // Bus Grant to Additional Memory Controller
                               // from DBI
output  [3:0] nSMDATAEN;       // Final Pad Enables of the SMC peripheral
output        TICREADEBI;      // Pad Enable signal from TIC when EbiSdram is
                               // used
output [31:0] SMDATAOUT;       // Data output bus of the SMC-peripheral
output [31:0] TBUSOUTEBI;      // Data bus output from the TIC when EbiSdram is
                               // used
output [25:0] SMADDR;          // Address bus of the SMC-peripheral

// Inputs
wire          HCLK;            // AHB Clock
wire          HRESETn;         // AHB Reset
wire          TICBUSREQ;       // Bus Request from TIC to DBI
wire          SMBUSREQ;        // Bus Request from SMC to DBI
wire          MCBUSREQ;        // Bus Request from Additional Memory Controller
wire          TICBUSGNTEBI;    // Bus Grant input to TIC from external EbiSdram
wire          SMBUSGNTEBI;     // Bus Grant input to SmcCore from external
                               // EbiSdram
wire    [3:0] nSMCDATAEN;      // Pad enables from SmcCore
wire    [3:0] MCDATAEN;        // Pad enables from Additional Memory Controller
wire          TICREAD;         // Pad enables from TIC
wire   [31:0] SMCDATAOUT;      // SmcCore Output Data bus
wire   [31:0] MCDATAOUT;       // Additional Memory Controller Output Data Bus
wire   [31:0] TBUSOUT;         // TIC output Data bus
wire   [25:0] SMCADDR;         // SmcCore Address Bus
wire   [25:0] MCADDR;          // Additional Memory Controller Address Bus
wire          EXTBUSMUX;       // This tied input will determine whether the
                               // internal DBI or external EbiSdram will be
                               // used for bus arbitration

// Outputs
wire          TICBUSREQEBI;    // External Data bus request signal from TIC
                               // to the EbiSdram
wire          SMBUSREQEBI;     // External Data bus request signal from SmcCore
                               // to the EbiSdram
wire          TICBUSGNT;       // Bus Grant to TIC from either DBI or EbiSdram
wire          SMBUSGNT;        // Bus Grant to SmcCore from either DBI or
                               // EbiSdram
wire          MCBUSGNT;        // Bus Grant to Additional Memory Controller
                               // from DBI
reg     [3:0] nSMDATAEN;       // Final Pad Enables of the SMC peripheral
wire          TICREADEBI;      // Pad Enable signal from TIC when EbiSdram is
                               // used
reg    [31:0] SMDATAOUT;       // Data output bus of the SMC-peripheral
wire   [31:0] TBUSOUTEBI;      // Data bus output from the TIC when EbiSdram is
                               // used
reg    [25:0] SMADDR;          // Address bus of the SMC-peripheral

// -----------------------------------------------------------------------------
//
//                                     DBI
//                                     ===
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   The feature of the DBI is that it supports dynamic priority arbitration.
// The TIC has the highest priority followed by the Additional Memory Controller
// and the SmcCore has the lowest priority. If a lower priority master is
// doing transfers on the bus and a higher priority master requests for the bus
// then the DBI de-asserts the bus grant line of the lower priority master
// indicating it should leave control of the bus. Once the bus request line is
// de-asserted by the lower priority master, the DBI then grants the control of
// the bus to the higher priority master.
// The Data Bus Interface implements the following functions:
// o  Multiplexes the Data lines and data bus byte lane enable lines from the
//    TIC, Additional Memory Controller and the SmcCore on to the common Data
//    pins of the chip.
// o  Arbitrates between the SmcCore and Additional Memory Controller for the
//    control of the address lines
// o  Implements the Arbiter state machine to regulate access requests from the
//    SmcCore block, TIC and Additional Memory Controller.
//
//   A bypass logic has been implemented which will cater to the requirement 
// when the SMC needs to interface with the EbiSdram. In this scenario the DBI
// becomes redundant as the External BusReq and BusGnt pins become active and
// these get connected to the SmcCore block. During synthesis the redundant DBI
// can get optimized out.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// State encoding for the DBI state machine

`define ST_DBI_IDLE      4'b0001
// Idle state

`define ST_DBI_GNT_TIC   4'b0010
// Grant state for the TIC

`define ST_DBI_GNT_MC    4'b0100
// Grant state for the Additional Memory Controller

`define ST_DBI_GNT_SMC   4'b1000
// Grant state for the SMC

// -----------------------------------------------------------------------------
// Bit encoding for the DBI State machine
// -----------------------------------------------------------------------------
`define DBI_IDLE         0
`define DBI_GNT_TIC      1
`define DBI_GNT_MC       2
`define DBI_GNT_SMC      3

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       TICBUSGNTdbi;
// Internal version of TIC bus grant signals

wire       MCBUSREQdbi;
// Gated MCBUSREQ which will be active only when the DBI is used

wire       iMCBUSGNT;
// Internal version of Additional Memory Controller Bus Grant signals

wire       SMBUSGNTdbi;
// Internal version of SMC Bus Grant signals

wire       SMBUSGNTEBIInt;
// SMBUSGNTEBI qualified with SMBUSREQ

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [3:0] ArbState;
// DBI Arbiter state register

reg  [3:0] NextArbState;
// D-input of DBI Arbiter state register

reg        McBusDrive;
// BusDrive signal for Additional Memory Controller Bus

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Multiplexer to choose between the DBI and the external EbiSdram for bus
// arbitration
// -----------------------------------------------------------------------------

assign SMBUSGNTEBIInt   = SMBUSGNTEBI && SMBUSREQ;

assign SMBUSREQEBI      = (EXTBUSMUX == 1'b1) ? SMBUSREQ : 1'b0;

assign TICBUSREQEBI     = (EXTBUSMUX == 1'b1) ? TICBUSREQ : 1'b0;

assign SMBUSGNT         = (EXTBUSMUX == 1'b1) ? SMBUSGNTEBIInt : SMBUSGNTdbi;

assign TICBUSGNT        = (EXTBUSMUX == 1'b1) ? TICBUSGNTEBI : TICBUSGNTdbi;

assign TICREADEBI       = (EXTBUSMUX == 1'b1) ? TICREAD : 1'b0;

assign TBUSOUTEBI       = (EXTBUSMUX == 1'b1) ? TBUSOUT : 32'h00000000;

assign MCBUSREQdbi      = (EXTBUSMUX == 1'b0) ? MCBUSREQ : 1'b0;

// -----------------------------------------------------------------------------
// DBI Arbiter State Machine - Next state Computation
// A Dynamic priority arbitration scheme is implemented with TIC
// having the highest priority followed by the Additional Memory Controller and
// SmcCore having least priority.
// The EXTBUSMUX is the tied input pad, input value on which determines if the
// DBI needs to do the arbitration
// -----------------------------------------------------------------------------
always @(ArbState or EXTBUSMUX or SMBUSREQ or TICBUSREQ or MCBUSREQdbi)
begin : p_ArbSmComb
  NextArbState   = ArbState;

// The Arbiter state machine is active only if the EXTBUSMUX tied to '0'
  if (EXTBUSMUX == 1'b0)
    begin
      case (ArbState)

// This is the state, the state machine moves into after reset. If TIC requests
// for the bus, the state machine grants the bus to it even if other bus
// requests are simlutaneously asserted. The next in priority is the Additional
// Memory Controller which gets control of the bus if its request is detected
// when the TIC is not requesting. The SmcCore is granted the bus when it
// asserts its request lines and the other masters are not contesting for the
// control of the bus
// This is the default state when none of the masters are active
        `ST_DBI_IDLE :
          begin
            if (TICBUSREQ == 1'b1)
              begin
                NextArbState   = `ST_DBI_GNT_TIC;
              end
            else if (MCBUSREQdbi == 1'b1)
              begin
                NextArbState   = `ST_DBI_GNT_MC;
              end
            else if (SMBUSREQ == 1'b1)
              begin
                NextArbState   = `ST_DBI_GNT_SMC;
              end
            else
              begin
                NextArbState   = `ST_DBI_IDLE;
              end
          end

// When the TIC is active, the DBI gives control of the Bus to TIC while its
// BusReq is asserted {the DBI resides in this state}. Once TIC completes its
// operation and de-asserts the BusReq, the DBI considers the requests from the
// other masters with the same priority logic.
        `ST_DBI_GNT_TIC :
          begin
            if (TICBUSREQ == 1'b0)
              begin
                if (MCBUSREQdbi == 1'b1)
                  begin
                    NextArbState   = `ST_DBI_GNT_MC;
                  end
                else if (SMBUSREQ == 1'b1)
                  begin
                    NextArbState   = `ST_DBI_GNT_SMC;
                  end
                else
                  begin
                    NextArbState   = `ST_DBI_IDLE;
                  end
              end
            else
              begin
                NextArbState   = `ST_DBI_GNT_TIC;
              end
          end

// This is the state when the Additional Memory Controller is active and has the
// control of the bus. In this situation if the TIC requests for the Bus then
// the DBI de-asserts the MCBUSGNT. The AMC is then expected to complete its
// current operation and de-assert its BusReq
// If the lower priority master {SmcCore} requests for the bus then the DBI
// gives grant only after the AMC completes all its operation indicated by
// de-assertion on the MCBUSREQ input
        `ST_DBI_GNT_MC :
          begin
            if (TICBUSREQ == 1'b1 && MCBUSREQdbi == 1'b0)
              begin
                NextArbState   = `ST_DBI_GNT_TIC;
              end
            else if (MCBUSREQdbi == 1'b0)
              begin
                if (SMBUSREQ == 1'b1)
                  begin
                    NextArbState   = `ST_DBI_GNT_SMC;
                  end
                else
                  begin
                    NextArbState   = `ST_DBI_IDLE;
                  end
              end
            else
              begin
                NextArbState   = `ST_DBI_GNT_MC;
              end
          end

// This state indicates that the SmcCore is active and has the control of the
// bus. Whenever any of the higher priority master request for the bus, the DBI
// de-asserts the SMBUSGNT and waits for the SmcCore to complete its current
// operation and de-assert SMBUSREQ. Depending on the priority the corresponding
// master is given the control of the bus
        `ST_DBI_GNT_SMC :
          begin
            if (TICBUSREQ == 1'b1 && SMBUSREQ == 1'b0)
              begin
                NextArbState   = `ST_DBI_GNT_TIC;
              end
            else if (MCBUSREQdbi == 1'b1 && SMBUSREQ == 1'b0)
              begin
                NextArbState   = `ST_DBI_GNT_MC;
              end
            else if (SMBUSREQ == 1'b0)
              begin
                NextArbState   = `ST_DBI_IDLE;
              end
            else
              begin
                NextArbState     = `ST_DBI_GNT_SMC;
              end
          end

        default :
           NextArbState   = `ST_DBI_IDLE;
      endcase
    end
end // p_ArbSmComb

// -----------------------------------------------------------------------------
// Sequential process for ArbState
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ArbSmSeq
  if (HRESETn == 1'b0)
    begin
      ArbState       <= `ST_DBI_IDLE;
    end
  else
    begin
      ArbState       <= NextArbState;
    end
end // p_ArbSmSeq

// -----------------------------------------------------------------------------
// Generation of grant signal to the TIC. It is generated if TICBUSREQ
// is asserted and if the states are DBI_IDLE or DBI_GNT_TIC. It is taken
// care in the state machine that if TICBUSREQ is asserted during a
// DBI_GNT_SMC or DBI_GNT_MC state, once the corresponding bus requests
// are deasserted, it switches to DBI_GNT_TIC state.
// -----------------------------------------------------------------------------
assign TICBUSGNTdbi     = (((ArbState[`DBI_IDLE] || ArbState[`DBI_GNT_TIC]) &&
                            TICBUSREQ) && (!(EXTBUSMUX)));

// -----------------------------------------------------------------------------
// Generation of grant signal to the Additional Memory Controller. It is
// generated only if MCBUSREQ is asserted and TICBUSREQ is deasserted and if the
// states are DBI_IDLE or DBI_GNT_MC. It is taken care in the state
// machine that if MCBUSREQ is asserted during a DBI_GNT_SMC state, once the
// corresponding bus request is deasserted, it switches to DBI_GNT_MC state.
// -----------------------------------------------------------------------------
assign iMCBUSGNT        = (((ArbState[`DBI_IDLE] || ArbState[`DBI_GNT_MC]) &&
                            MCBUSREQdbi && (!(TICBUSREQ))) && (!(EXTBUSMUX))); 

// -----------------------------------------------------------------------------
// Generation of grant signal to the SmcCore. It is generated only if
// SMCBUSREQ is asserted and all other bus requests are deasserted.
// -----------------------------------------------------------------------------
assign SMBUSGNTdbi      = (((ArbState[`DBI_IDLE] ||SMBUSREQ) &&
                            (!(TICBUSREQ)) && (!(MCBUSREQ))) && (!(EXTBUSMUX)));

// -----------------------------------------------------------------------------
// Generation of Bus drive signal for Additional Memory Controller. This signal
// will ensure that the bus is driven with MCDATAOUT and MCADDR till
// MCBUSREQ is deasserted.
// -----------------------------------------------------------------------------
always @(MCBUSREQdbi or iMCBUSGNT or ArbState)
begin : p_DriveMcComb
  if ((MCBUSREQdbi == 1'b1 && iMCBUSGNT == 1'b1) ||
      (MCBUSREQdbi == 1'b1 && iMCBUSGNT == 1'b0 && ArbState == `ST_DBI_GNT_MC))
    begin
      McBusDrive     = 1'b1;
    end
  else
    begin
      McBusDrive     = 1'b0;
    end
end // p_DriveMcComb

// -----------------------------------------------------------------------------
// Multiplex the data to the Data Bus Interface output. The data bus
// output is multiplexed between the SmcCore, Additional Memory Controller
// and TIC
// -----------------------------------------------------------------------------
always @(SMCDATAOUT or TBUSOUT or MCDATAOUT or TICBUSGNTdbi or McBusDrive)
begin : p_DataGenComb
  if (TICBUSGNTdbi == 1'b1)
    begin
      SMDATAOUT      = TBUSOUT;
    end
  else if (McBusDrive == 1'b1)
    begin
      SMDATAOUT      = MCDATAOUT;
    end
  else
    begin
      SMDATAOUT      = SMCDATAOUT;
    end
end // p_DataGenComb

// -----------------------------------------------------------------------------
// Multiplex the Address to the Address Bus Interface. This Address Bus
// output is multiplexed between SmcCore and Additional Memory Controller core.
// -----------------------------------------------------------------------------
always @(McBusDrive or SMCADDR or MCADDR)
begin : p_AddrGenComb
  if (McBusDrive == 1'b1)
    begin
      SMADDR         = MCADDR;
    end
  else
    begin
      SMADDR         = SMCADDR;
    end
end // p_AddrGenComb

// -----------------------------------------------------------------------------
// Pad Control Logic:
// o If the SmcCore data enables or Additional Memory
//   Controller data enables are asserted, then irrespective of whether the
//   SmcCore or Additional Memory Controller is granted bus or not, the final
//   pads should be enabled.  This is due to the recirculation logic support.
// o Whenever the TICREAD is asserted & TIC is granted, then the final pad will
//   be enabled.
// -----------------------------------------------------------------------------
always @(nSMCDATAEN or MCDATAEN or TICREAD or TICBUSGNTdbi or McBusDrive)
begin : p_PadEnComb
  nSMDATAEN   = nSMCDATAEN;
  if (TICBUSGNTdbi == 1'b1)
    nSMDATAEN = ~({TICREAD,TICREAD,TICREAD,TICREAD});
  else if (McBusDrive == 1'b1)
    nSMDATAEN = MCDATAEN;
end // p_PadEnComb

// -----------------------------------------------------------------------------
// Connect local copies to the outputs
// -----------------------------------------------------------------------------
assign MCBUSGNT       = iMCBUSGNT;

endmodule
// --================================== End ==================================--
