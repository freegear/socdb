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
// File Name              : APBif.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           Converts AHB peripheral transfers to APB transfers
//
// --=================================================================--

`timescale 1ns/1ps

module APBif (HCLK, HRESETn, HADDR, HTRANS, HWRITE, HWDATA, HSELAPBif,
              HREADYin, HRDATA, HREADYout, HRESP, PRDATA, PWDATA,
              PENABLE, PSELIC, PSELUUT, PSELRPC, PADDR, PWRITE);

  input         HCLK;
  input         HRESETn;
  input  [31:0] HADDR;
  input   [1:0] HTRANS;
  input         HWRITE;
  input  [31:0] HWDATA;
  input         HSELAPBif;
  input         HREADYin;

  output [31:0] HRDATA;
  output        HREADYout;
  output  [1:0] HRESP;

  input  [31:0] PRDATA;

  output [31:0] PWDATA;
  output        PENABLE;
  output        PSELIC;  // APB Interrupt Controller
  output        PSELUUT; // APB Unit Under Test
  output        PSELRPC; // Remap and Pause
  output [31:0] PADDR;
  output        PWRITE;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// This constant defines the size of the peripheral address bus:
  parameter PADDRWIDTH = 32'd16;

// APBIF states:
//  ST_IDLE     is APB bus idle state entered on reset
//  ST_READ     is read setup
//  ST_RENABLE  is read enable
//  ST_WWAIT    is write wait state
//  ST_WRITE    is write setup
//  ST_WENABLE  is write enable
//  ST_WRITEP   is write setup with pending transfer
//  ST_WENABLEP is write enable with pending transfer
  `define ST_IDLE     4'b0000
  `define ST_READ     4'b0001
  `define ST_RENABLE  4'b0100
  `define ST_WWAIT    4'b1001
  `define ST_WRITE    4'b1010
  `define ST_WENABLE  4'b1110
  `define ST_WRITEP   4'b1011
  `define ST_WENABLEP 4'b1111

// EASY Peripherals address decoding values:
//  Interrupt Controller - 0x80000000 to 0x83FFFFFF
//  APB UUT              - 0x84000000 to 0x87FFFFFF
//  Remap & Pause        - 0x88000000 to 0x8BFFFFFF
  `define ICBASE  4'b0000
  `define UUTBASE 4'b0001
  `define RPCBASE 4'b0010

// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
  wire        Valid;          // Module is selected with valid transfer
  wire        ACRegEn;        // Enable for address and control
                              // registers
  reg  [31:0] HaddrReg;       // HADDR register
  reg         HwriteReg;      // HWRITE register
  wire [31:0] HaddrMux;       // HADDR multiplexer

  reg   [3:0] NextState;      // State machine
  reg   [3:0] CurrentState;

  wire        HreadyNext;     // HREADYout register input
  reg         iHREADYout;     // HREADYout register

  reg         PselICInt;      // Internal PSELIC
  reg         PselUUTInt;     // Internal PSELUUT
  reg         PselRPCInt;     // Internal PSELRPC

  wire        APBEn;          // Enable for APB output registers

  wire        PWDATAEn;       // PWDATA Register enable
  wire        PenableNext;    // PENABLE register input
  reg         PselICMux;      // PSEL multiplexer values
  reg         PselUUTMux;
  reg         PselRPCMux;
  reg         iPSELIC;        // Internal PSEL outputs
  reg         iPSELUUT;
  reg         iPSELRPC;
  reg  [PADDRWIDTH - 1:0] iPADDR;
                              // Registered internal PADDR
  wire        PwriteNext;     // PWRITE register input

  reg  [31:0] PWDATA;         // Registered output signal
  reg         PENABLE;        // Registered output signal
  reg         PWRITE;         // Registered output signal

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Valid transfer detection
// ---------------------------------------------------------------------
// Valid AHB transfers only take place when a non-sequential or
// sequential transfer is shown on HTRANS - an idle or busy transfer
// should be ignored.

  assign Valid = ((HSELAPBif == 1'b1 && HREADYin == 1'b1 &&
                   (HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)) ?
                 1'b1 : 1'b0);

// ---------------------------------------------------------------------
// Address and control registers
// ---------------------------------------------------------------------
// Registers are used to store the address and control signals from the
// address phase for use in the data phase of the transfer.
// Only enabled when the HREADYin input is HIGH and the module is
// addressed.

  assign ACRegEn = HSELAPBif & HREADYin;

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
    begin
      HaddrReg <= 32'h0000_0000;
      HwriteReg <= 1'b0;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg <= HADDR;
        HwriteReg <= HWRITE;
      end
    end
  end

// The address source used depends on the source of the current APB
// transfer. If the transfer is being generated from:
// - the pipeline registers, then the address source is HaddrReg
// - the AHB inputs, the the address source is HADDR.
//
// The HaddrMux multiplexer is used to select the appropriate address
// source. A new read, sequential read following another read, or a
// read following a write with no pending transfer are the only
// transfers that are generated directly from the AHB inputs. All other
// transfers are generated from the pipeline registers.

  assign HaddrMux = ((NextState == `ST_READ &&
                      (CurrentState == `ST_IDLE ||
                       CurrentState == `ST_RENABLE ||
                       CurrentState == `ST_WENABLE)) ? HADDR :
                    HaddrReg);

// ---------------------------------------------------------------------
// Next state logic for APB state machine
// ---------------------------------------------------------------------
// Generates next state from CurrentState and AHB inputs.
// Due to write transfers having an extra setup state, the pending
// states are used to indicate that there is a transfer in the pipeline
// that has not been started on the APB.
// Read transfers start immediately, so pending states are not needed.

  always @(CurrentState or Valid or HWRITE or HwriteReg)
  begin
    case (CurrentState)

      `ST_IDLE :                 // Idle state
        if (Valid)
          if (HWRITE)
            NextState = `ST_WWAIT;
          else
            NextState = `ST_READ;
        else
          NextState = `ST_IDLE;

      `ST_READ :                 // Read setup
        NextState = `ST_RENABLE;

      `ST_WWAIT :                // Hold for one cycle before write
        if (Valid)
          NextState = `ST_WRITEP;
        else
          NextState = `ST_WRITE;

      `ST_WRITE :                // Write setup
        if (Valid)
          NextState = `ST_WENABLEP;
        else
          NextState = `ST_WENABLE;

      `ST_WRITEP :               // Write setup with pending transfer
        NextState = `ST_WENABLEP;

      `ST_RENABLE :              // Read enable
        if (Valid)
          if (HWRITE)
            NextState = `ST_WWAIT;
          else
            NextState = `ST_READ;
        else
          NextState = `ST_IDLE;

      `ST_WENABLE :              // Write enable
        if (Valid)
          if (HWRITE)
            NextState = `ST_WWAIT;
          else
            NextState = `ST_READ;
        else
          NextState = `ST_IDLE;

      `ST_WENABLEP :             // Write enable with pending transfer
        if (HwriteReg)
          if (Valid)
            NextState = `ST_WRITEP;
          else
            NextState = `ST_WRITE;
        else
          NextState = `ST_READ;

      default  :
        NextState = `ST_IDLE;    // Return to idle on FSM error

    endcase
  end

// ---------------------------------------------------------------------
// State machine
// ---------------------------------------------------------------------
// Changes state on rising edge of HCLK.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      CurrentState <= `ST_IDLE;
    else
      CurrentState <= NextState;
  end

// ---------------------------------------------------------------------
// HREADYout generation
// ---------------------------------------------------------------------
// A registered version of HREADYout is used to improve output timing.
// Wait states are inserted during:
//  ST_READ
//  ST_WRITEP
//  ST_WENABLEP when the currently pending transfer is a read, or
//              when the currently driven AHB transfer is a read.

  assign HreadyNext = ((NextState == `ST_READ ||
                        NextState == `ST_WRITEP ||
                        (NextState == `ST_WENABLEP &&
                         (HWRITE == 1'b0 ||HwriteReg == 1'b0))) ?
                      1'b0 : 1'b1);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iHREADYout <= 1'b0;
    else
      iHREADYout <= HreadyNext;
  end

// ---------------------------------------------------------------------
// APB address decoding for slave devices
// ---------------------------------------------------------------------
// Decodes the address from HaddrMux, which only changes during a read
// or write cycle.
// When an address is used that is not in any of the ranges specified,
//  operation of the system continues, but no PSEL lines are set, so no
//  peripherals are selected during the read/write transfer.
// Operation of PWDATA, PWRITE, PENABLE and PADDR continues as normal.

  always @(HaddrMux)
  begin
    case (HaddrMux[29:26])
      `ICBASE :
      begin
        PselICInt  = 1'b1;
        PselUUTInt = 1'b0;
        PselRPCInt = 1'b0;
      end
      `UUTBASE :
      begin
        PselICInt  = 1'b0;
        PselUUTInt = 1'b1;
        PselRPCInt = 1'b0;
      end
      `RPCBASE :
      begin
        PselICInt  = 1'b0;
        PselUUTInt = 1'b0;
        PselRPCInt = 1'b1;
      end
      default :
      begin
        PselICInt  = 1'b0;
        PselUUTInt = 1'b0;
        PselRPCInt = 1'b0;
      end
    endcase
  end

// ---------------------------------------------------------------------
// APB enable generation
// ---------------------------------------------------------------------
// APBEn is set when starting an access on the APB, and is used to
// enable the PSEL, PWRITE and PADDR APB output registers.

  assign APBEn = ((NextState == `ST_READ || NextState == `ST_WRITE ||
                   NextState == `ST_WRITEP) ? 1'b1 :
                 1'b0);

// ---------------------------------------------------------------------
// Registered HWDATA for writes (PWDATA)
// ---------------------------------------------------------------------
// Write wait state allows a register to be used to hold PWDATA.
// Register enabled when PWRITE output is set HIGH.

  assign PWDATAEn = PwriteNext;

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      PWDATA <= 32'h0000_0000;
    else
    begin
      if (PWDATAEn)
        PWDATA <= HWDATA;
    end
  end

// ---------------------------------------------------------------------
// PENABLE generation
// ---------------------------------------------------------------------
// PENABLE output is set HIGH during any of the three ENABLE states.

  assign PenableNext = ((NextState == `ST_RENABLE ||
                         NextState == `ST_WENABLE ||
                         NextState == `ST_WENABLEP) ? 1'b1 :
                       1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      PENABLE <= 1'b0;
    else
      PENABLE <= PenableNext;
  end

// ---------------------------------------------------------------------
// iPSEL generation
// ---------------------------------------------------------------------
// Set outputs with internal values when in READ or WRITE states (APBEn
// HIGH).
// Reset outputs when APB transfer has ended.
// Hold  outputs at all other times.

  always @(APBEn or PselICInt or PselUUTInt or PselRPCInt or
           NextState or iPSELIC or iPSELUUT or iPSELRPC)
  begin
    if ((APBEn))
    begin
      PselICMux  = PselICInt;
      PselUUTMux = PselUUTInt;
      PselRPCMux = PselRPCInt;
    end
    else if ((NextState == `ST_IDLE || NextState == `ST_WWAIT))
    begin
      PselICMux  = 1'b0;
      PselUUTMux = 1'b0;
      PselRPCMux = 1'b0;
    end
    else
    begin
      PselICMux  = iPSELIC;
      PselUUTMux = iPSELUUT;
      PselRPCMux = iPSELRPC;
    end
  end

// Drives PSEL outputs with internal multiplexer versions.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
    begin
      iPSELIC  <= 1'b0;
      iPSELUUT <= 1'b0;
      iPSELRPC <= 1'b0;
    end
    else
    begin
      iPSELIC  <= PselICMux;
      iPSELUUT <= PselUUTMux;
      iPSELRPC <= PselRPCMux;
    end
  end

// ---------------------------------------------------------------------
// Registered HADDR for reads and writes (iPADDR)
// ---------------------------------------------------------------------
// HaddrMux is used, as the generation time of the APB address is
// different for reads and writes, so both the direct and registered
// HADDR input need to be used.
// HaddrMux is captured by an APBEn enabled register to generate
// iPADDR.
// Signal iPADDR is used so that only (PADDRWIDTH - 1) of PADDR is
// driven. iPADDR driven on State Machine change to READ or WRITE, with
// reset to zero.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iPADDR <= 16'h0000;
    else
    begin
      if ((APBEn))
        iPADDR <= HaddrMux[PADDRWIDTH - 1:0];
    end
  end

// ---------------------------------------------------------------------
// PWRITE generation
// ---------------------------------------------------------------------
// PwriteNext is captured by an APBEn enabled register to generate
// PWRITE, and is generated from NextState (set HIGH during a write
// cycle). PWRITE output only changes when APB is accessed.

  assign PwriteNext = ((NextState == `ST_WRITE ||
                        NextState == `ST_WRITEP) ? 1'b1 :
                      1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      PWRITE <= 1'b0;
    else
    begin
      if ((APBEn))
        PWRITE <= PwriteNext;
    end
  end

// ---------------------------------------------------------------------
// APB output drivers
// ---------------------------------------------------------------------
// Drive outputs with internal signals.

  assign PADDR[PADDRWIDTH - 1:0] = iPADDR;

  assign PSELIC  = iPSELIC;
  assign PSELUUT = iPSELUUT;
  assign PSELRPC = iPSELRPC;

// ---------------------------------------------------------------------
// AHB output drivers
// ---------------------------------------------------------------------
// PRDATA is only ever driven during a read, so it can be directly
// copied to HRDATA to reduce the output data delay onto the AHB.

  assign HRDATA = PRDATA;

// Drives the output port with the internal version, and sets it LOW
// at all other times when the module is not selected.

  assign HREADYout = iHREADYout;

// The response will always be OKAY to show that the transfer has been
// performed successfully.

  assign HRESP = `RSP_OKAY;


endmodule

// --============================== End ==============================--
