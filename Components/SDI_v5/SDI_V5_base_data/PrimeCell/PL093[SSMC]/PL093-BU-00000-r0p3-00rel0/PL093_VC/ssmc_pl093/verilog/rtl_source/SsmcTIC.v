// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTIC.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Test Interface Controller (TIC) for the AMBA system.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTIC (
// Inputs
                HCLK,
                HRESETn,
                HREADYINTIC,
                HRESPTIC,
                HGRANTTIC,
                HRDATATIC,
                TBUSIN,
                SMTESTREQA,
                SMTESTREQB,
                TICBUSGNT,

// Outputs
                HADDRTIC,
                HTRANSTIC,
                HWRITETIC,
                HSIZETIC,
                HBURSTTIC,
                HPROTTIC,
                HWDATATIC,
                HBUSREQTIC,
                HLOCKTIC,
                TBUSOUT,
                SMTESTACK,
                TICBUSREQ,
                TICREAD
               );

// Inputs
input         HCLK;            // AHB Bus Clock
input         HRESETn;         // AHB Bus Reset Signal
input         HREADYINTIC;     // Multiplexed HREADYINTIC input from all
                               // slaves
input   [1:0] HRESPTIC;        // AHB Bus Transfer Response to TIC
input         HGRANTTIC;       // AHB Bus Grant
input  [31:0] HRDATATIC;       // AHB Read Data Input to TIC
input  [31:0] TBUSIN;          // External test vector input data bus
input         SMTESTREQA;      // Test bus request A
input         SMTESTREQB;      // Test bus request B
input         TICBUSGNT;       // Bus grant signal by the DBI to the TIC



// Outputs
output [31:0] HADDRTIC;        // AHB Address output from TIC
output  [1:0] HTRANSTIC;       // AHB Transfer type output from TIC
output        HWRITETIC;       // AHB Transfer Direction output from TIC
output  [2:0] HSIZETIC;        // AHB Transfer Size output from TIC
output  [2:0] HBURSTTIC;       // AHB Burst Type output from TIC
output  [3:0] HPROTTIC;        // AHB Protection control signal
output [31:0] HWDATATIC;       // AHB Write Data output from TIC
output        HBUSREQTIC;      // AHB Bus Request
output        HLOCKTIC;        // AHB signal indicating Locked access to
                               // the Bus
output [31:0] TBUSOUT;         // External test vector output data bus
output        SMTESTACK;       // Test acknowledge
output        TICBUSREQ;       // TIC bus request to DBI
output        TICREAD;         // Drive AHB read data onto TBUSOUT




// Inputs
wire          HCLK;            // AHB Bus Clock
wire          HRESETn;         // AHB Bus Reset Signal
wire          HREADYINTIC;     // Multiplexed HREADYINTIC input from all
                               // slaves
wire    [1:0] HRESPTIC;        // AHB Bus Transfer Response to TIC
wire          HGRANTTIC;       // AHB Bus Grant
wire   [31:0] HRDATATIC;       // AHB Read Data Input to TIC
wire   [31:0] TBUSIN;          // External test vector input data bus
wire          SMTESTREQA;      // Test bus request A
wire          SMTESTREQB;      // Test bus request B
wire          TICBUSGNT;       // Bus grant signal by the DBI to the TIC



// Outputs
wire   [31:0] HADDRTIC;        // AHB Address output from TIC
wire    [1:0] HTRANSTIC;       // AHB Transfer type output from TIC
wire          HWRITETIC;       // AHB Transfer Direction output from TIC
wire    [2:0] HSIZETIC;        // AHB Transfer Size output from TIC
wire    [2:0] HBURSTTIC;       // AHB Burst Type output from TIC
wire    [3:0] HPROTTIC;        // AHB Protection control signal
wire   [31:0] HWDATATIC;       // AHB Write Data output from TIC
wire          HBUSREQTIC;      // AHB Bus Request
wire          HLOCKTIC;        // AHB signal indicating Locked access to
                               // the Bus
wire   [31:0] TBUSOUT;         // External test vector output data bus
wire          SMTESTACK;       // Test acknowledge
wire          TICBUSREQ;       // TIC bus request to DBI
wire          TICREAD;         // Drive AHB read data onto TBUSOUT


// -----------------------------------------------------------------------------
//
//                                   SsmcTIC
//                                   =======
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// The TIC is a state machine that provides an AMBA bus master for system test.
// It controls the External Test Bus and AHB data buses HRDATATIC and HWDATAOUT
// during the application of Test Interface Format (TIF)test vectors.
//
// The TIC consists of three main blocks:
//
// Test Vector State Machine - Uses the SMTESTREQA and SMTESTREQB signals to
// decide which type of vector is being applied on the external TESTBUS.
//
// Address and Control Registers - Holds values for the address and control
// signals and includes an address incrementer for burst accesses.
//
// AMBA Bus Master Interface - Includes the AMBA bus master state machine and
// the control of the AMBA bus signals.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// State encoding of the granted state machine
// -----------------------------------------------------------------------------
`define STG_NOT_GRANT    2'b00
//

`define STG_GAIN_GRANT   2'b01
//

`define STG_GRANT        2'b11
//

`define STG_LOSE_GRANT   2'b10
//

// -----------------------------------------------------------------------------
// State encoding of the TIC vector state machine
// -----------------------------------------------------------------------------

`define STV_IDLE         3'b000
//

`define STV_START        3'b001
//

`define STV_ADDRVEC      3'b010
//

`define STV_WRITEVEC     3'b011
//

`define STV_READVEC      3'b100
//

`define STV_LASTREAD     3'b101
//

`define STV_TURNAROUND   3'b110
//

// -----------------------------------------------------------------------------
// HTRANSTIC transfer type signal encoding
// -----------------------------------------------------------------------------

`define TRN_IDLE         2'b00
//

`define TRN_BUSY         2'b01
//

`define TRN_NONSEQ       2'b10
//

`define TRN_SEQ          2'b11
//

// -----------------------------------------------------------------------------
// HSIZETIC transfer type signal encoding
// -----------------------------------------------------------------------------

`define SZ_BYTE          3'b000
//

`define SZ_HALF          3'b001
//

`define SZ_WORD          3'b010
//

// -----------------------------------------------------------------------------
// HRESPTIC transfer response signal encoding
// -----------------------------------------------------------------------------

`define RSP_OKAY         2'b00
//

`define RSP_ERROR        2'b01
//

`define RSP_RETRY        2'b10
//

`define RSP_SPLIT        2'b11
//

// -----------------------------------------------------------------------------
// Constant for Logic '0'
// -----------------------------------------------------------------------------
`define LOGIC_ZERO       1'b0

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        AddrDrive;
// Address bus drive enable output

wire        DataDrive;
// Data bus drive enable output

wire        iSMTESTACK;
// Internal SMTESTACK output

wire [31:0] HaddrMux;
// HADDRTIC reg input mux

wire        HaddrEn;
// HADDRTIC reg enable

wire  [2:0] iHSIZETIC;
// Int version of output

wire        SRNext;
// Input to SplitRetry register

wire        SR1;
// High during first split/retry cycle

wire  [2:0] Vect;
// Muxed vector state

wire        iHWRITETIC;
// Internal HWRITETIC output

wire        HwdataEn;
// HWDATATIC register enable

wire        iHBUSREQTIC;
// Internal version of HBUSREQTIC

wire        iTICREAD;
// Internal version of TICREAD

// -----------------------------------------------------------------------------
// Zero fill for register reads to return zeros in unused bit positions
// -----------------------------------------------------------------------------
wire [31:0] ZEROFILL;

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [1:0] NextGrant;
// Granted state machine

reg         SyncTestReqA;
// Synchronised SMTESTREQA input

reg   [2:0] NextVect;
// TIC vector state

reg   [2:0] LastVect;
//

reg  [31:0] iHADDRTIC;
// Internal HADDRTIC reg

reg   [9:0] HaddrPrev;
// Previous HADDRTIC value

reg         Bound;
// Detects an incremented address boundary

reg         BoundReg;
// Registered Bound

reg         ControlVect;
// Detects a control vector being applied

reg         ControlSel;
// Selected control vector

reg         Incrm;
// Incremental control vector setting

reg         IncrmReg;
// Registered Incrm

reg   [3:0] HprotGen;
// Prot control vect set

reg   [3:0] iHPROTTIC;
// Registered HprotGen

reg         HlockGen;
// Lock control vector setting

reg         iHLOCK;
// Registered iHLOCK

reg   [1:0] HsizeGen;
// Size control vect set

reg   [1:0] HsizeInt;
// Registered HsizeGen

reg         SR2;
// High during second split/retry cycle

reg   [1:0] iHTRANSTIC;
// Int version of output

reg  [31:0] iHWDATATIC;
// HWDATATIC register

reg   [1:0] CurrentGrant;
//

reg   [2:0] CurrentVect;
// machine

reg  [31:0] IncAddr;
// Incremented address

reg         SplitRetry;
// Indicates a split/retry cycle

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
// Assign ZEROFILL
// -----------------------------------------------------------------------------
assign ZEROFILL         = 32'h00000000;

// -----------------------------------------------------------------------------
// Granted state machine next state logic
// NextGrant only changes when HREADYINTIC is HIGH (to show the end of the
// current transfer), and is set according to the values of HGRANT and
// CurrentGrant.
// -----------------------------------------------------------------------------
always @(HREADYINTIC or CurrentGrant or HGRANTTIC)
begin : p_NextGrantComb
  if (HREADYINTIC == 1'b1)
    begin
      case (CurrentGrant)
        `STG_NOT_GRANT :
          begin
            if (HGRANTTIC == 1'b1)
              begin
                NextGrant        = `STG_GAIN_GRANT;
              end
            else
              begin
                NextGrant        = `STG_NOT_GRANT;
              end
          end

        `STG_GAIN_GRANT :
          begin
            if (HGRANTTIC == 1'b1)
              begin
                NextGrant        = `STG_GRANT;
              end
            else
              begin
                NextGrant        = `STG_LOSE_GRANT;
              end
          end

        `STG_GRANT :
          begin
            if (HGRANTTIC == 1'b1)
              begin
                NextGrant        = `STG_GRANT;
              end
            else
              begin
                NextGrant        = `STG_LOSE_GRANT;
              end
          end

        `STG_LOSE_GRANT :
          begin
            if (HGRANTTIC == 1'b1)
              begin
                NextGrant        = `STG_GAIN_GRANT;
              end
            else
              begin
                NextGrant        = `STG_NOT_GRANT;
              end
          end

        default :
          NextGrant        = `STG_NOT_GRANT;

        endcase
    end
  else
    begin
      NextGrant        = CurrentGrant;
    end
end // p_NextGrantComb

// -----------------------------------------------------------------------------
// Granted state machine current state
// Loads the value of NextGrant in on each HCLK
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_CurrentGrantSeq
  if (HRESETn == 1'b0)
    begin
      CurrentGrant     <= `STG_NOT_GRANT;
    end
  else
    begin
      CurrentGrant     <= NextGrant;
    end
end // p_CurrentGrantSeq

// -----------------------------------------------------------------------------
// Address and data enables
// Indicate when the master has control of the address/control and data buses.
// -----------------------------------------------------------------------------
assign AddrDrive        = (CurrentGrant == `STG_GAIN_GRANT ||
                           CurrentGrant == `STG_GRANT) ? 1'b1 : 1'b0;

assign DataDrive        = (CurrentGrant == `STG_GRANT ||
                           CurrentGrant == `STG_LOSE_GRANT) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// SMTESTACK generation
// SMTESTACK is always LOW unless the TIC is granted on the bus, in which case
// the HREADYINTIC signal is used to generate SMTESTACK. During split/retry
// cycles it is also set LOW.
// -----------------------------------------------------------------------------
assign iSMTESTACK       = (SplitRetry == 1'b1) ? 1'b0                : (
                           (DataDrive == 1'b1 && TICBUSGNT == 1'b1) ?
                           HREADYINTIC : 1'b0);

// -----------------------------------------------------------------------------
// Synchronisation of SMTESTREQA prior to entering test
// This allows a switch from an internal clock to an external test clock prior
// to test. Once test is entered the system clock should be switched to TCLK,
// hence SMTESTREQA will be synchronous.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_SyncTestreqSeq
  if (HRESETn == 1'b0)
    begin
      SyncTestReqA     <= 1'b0;
    end
  else
    begin
      SyncTestReqA     <= SMTESTREQA;
    end
end // p_SyncTestreqSeq

// -----------------------------------------------------------------------------
// TIC vector state machine next state logic
// This state machine tracks which type of test vector is being applied
// according to the SMTESTREQA and SMTESTREQB signals. When in test mode
// SMTESTREQA and SMTESTREQB are only considered valid when SMTESTACK is HIGH.
// -----------------------------------------------------------------------------
always @(CurrentVect or SyncTestReqA or iSMTESTACK or SMTESTREQA or SMTESTREQB)
begin : p_NextVectComb
  case (CurrentVect)

    `STV_IDLE :
      begin
        if (SyncTestReqA == 1'b1)
          begin
// If any clock switching is required, thenthe signal that indicates
// that the clock switch has occured should be used as an extra
// condition to move to `STV_START.
            NextVect         = `STV_START;
// Move to START using synchronised SMTESTREQA
          end
        else
          begin
            NextVect         = `STV_IDLE;
          end
      end

    `STV_START :
      begin 
        if (iSMTESTACK == 1'b0)
          begin
// Remain in START until granted the bus
            NextVect         = `STV_START;
          end
        else if (SMTESTREQA == 1'b1 && SMTESTREQB == 1'b1)
          begin
// Address
            NextVect         = `STV_ADDRVEC;
          end
        else
          begin
            NextVect         = `STV_START;
          end
      end

    `STV_ADDRVEC :
      begin
        if (iSMTESTACK == 1'b0)
          begin
            NextVect         = `STV_ADDRVEC;
          end
        else if (SMTESTREQA == 1'b1 && SMTESTREQB == 1'b1)
          begin
// Address
            NextVect         = `STV_ADDRVEC;
          end
        else if (SMTESTREQA == 1'b1 && SMTESTREQB == 1'b0)
          begin
// Write
            NextVect         = `STV_WRITEVEC;
          end
        else if (SMTESTREQA == 1'b0 && SMTESTREQB == 1'b1)
          begin
// Read
            NextVect         = `STV_READVEC;
          end
        else
          begin
// Exit
            NextVect         = `STV_IDLE;
          end
      end

    `STV_WRITEVEC :
      begin 
        if (iSMTESTACK == 1'b0)
          begin
            NextVect         = `STV_WRITEVEC;
          end
        else if (SMTESTREQA == 1'b0 && SMTESTREQB == 1'b1)
          begin
// Read
            NextVect         = `STV_READVEC;
          end
        else if (SMTESTREQA == 1'b1 && SMTESTREQB == 1'b0)
          begin
// Write
            NextVect         = `STV_WRITEVEC;
          end
        else
          begin
// Address/Exit
            NextVect         = `STV_ADDRVEC;
          end
      end

    `STV_READVEC :
      begin
        if (iSMTESTACK == 1'b0)
          begin
            NextVect         = `STV_READVEC;
          end
        else if (SMTESTREQA == 1'b0 && SMTESTREQB == 1'b1)
          begin
// Read
            NextVect         = `STV_READVEC;
          end
        else
          begin
 // Address or Write or Exit
            NextVect         = `STV_LASTREAD;
          end
      end

    `STV_LASTREAD :
      begin
        if (iSMTESTACK == 1'b0)
          begin
            NextVect         = `STV_LASTREAD;
          end
        else
          begin
            NextVect         = `STV_TURNAROUND;
          end
      end

    `STV_TURNAROUND :
      begin
        if (iSMTESTACK == 1'b0)
          begin
            NextVect         = `STV_TURNAROUND;
          end
        else if (SMTESTREQA == 1'b0 && SMTESTREQB == 1'b1)
          begin
// Read
            NextVect         = `STV_READVEC;
          end
        else if (SMTESTREQA == 1'b1 && SMTESTREQB == 1'b0)
          begin
// Write
            NextVect         = `STV_WRITEVEC;
          end
        else
          begin
// Address/Exit
            NextVect         = `STV_ADDRVEC;
          end
      end
    default :
// Others will be never reached
      NextVect         = `STV_IDLE;

    endcase
end // p_NextVectComb

// -----------------------------------------------------------------------------
// TIC vector state machine current state
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_CurrentVectSeq
  if (HRESETn == 1'b0)
    begin
      CurrentVect      <= `STV_IDLE;
    end
  else
    begin
      CurrentVect      <= NextVect;
    end
end // p_CurrentVectSeq

// -----------------------------------------------------------------------------
// TIC vector state machine last state
// LastVect is needed to detect control vectors.
// A vector is only consider to be applied when SMTESTACK is high.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LastVectSeq
  if (HRESETn == 1'b0)
    begin
      LastVect         <= `STV_IDLE;
    end
  else
    begin
      if (iSMTESTACK == 1'b1)
        begin
          LastVect         <= CurrentVect;
        end
    end
end // p_LastVectSeq

// -----------------------------------------------------------------------------
// Address incrementer
// Increments the address according to the value of HSIZETIC.
// The default system only uses byte, halfword and word incrementing, but can
// easily be expanded to work with larger address increments.
// -----------------------------------------------------------------------------
always @(iHSIZETIC or iHADDRTIC)
begin : p_IncAddrComb
  case (iHSIZETIC)

// Byte increment
    `SZ_BYTE :
      begin
        IncAddr[7:0]     = (iHADDRTIC[7:0]) + 1;
        IncAddr[31:8]    = iHADDRTIC[31:8];
      end

// Halfword increment
    `SZ_HALF :
      begin
        IncAddr[0]       = 1'b0;
        IncAddr[8:1]     = (iHADDRTIC[8:1]) + 1;
        IncAddr[31:9]    = iHADDRTIC[31:9];
      end

// Word increment
    default :
      begin
        IncAddr[1:0]     = 2'b00;
        IncAddr[9:2]     = (iHADDRTIC[9:2]) + 1;
        IncAddr[31:10]   = iHADDRTIC[31:10];
      end
    endcase
end // p_IncAddrComb

// -----------------------------------------------------------------------------
// Address selection and output generation
// The combinatorial output of the mux is used as the HADDRTIC register input.
// The external address input is used during an address vector, and the address
// incrementer is used at all other times.
// -----------------------------------------------------------------------------
assign HaddrMux         = (SRNext == 1'b1) ? ({IncAddr[31:10], HaddrPrev[9:0]})
                        : ((CurrentVect == `STV_ADDRVEC || IncrmReg == 1'b0)
                        ?  TBUSIN : IncAddr);

// -----------------------------------------------------------------------------
// The address register enable is used to load in a new address value from the
// external test bus during an address vector, from the HaddrPrev registers
// during a split or retry cycle, and from the address incrementer during a
// sequential read or write vector.
// -----------------------------------------------------------------------------
assign HaddrEn          = (HREADYINTIC == 1'b1 && ControlSel == 1'b0 &&
                           (CurrentVect == `STV_ADDRVEC || SRNext == 1'b1 ||
                           (IncrmReg == 1'b1 && (CurrentVect ==
                           `STV_READVEC || CurrentVect == `STV_WRITEVEC))))
                           ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// An enabled register is used to hold the current address value to improve the
// output timing.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_iHADDRSeq
  if (HRESETn == 1'b0)
    begin
      iHADDRTIC        <= 32'h00000000;
    end
  else
    begin
      if (HaddrEn == 1'b1)
        begin
          iHADDRTIC        <= HaddrMux;
        end
    end
end // p_iHADDRSeq

// -----------------------------------------------------------------------------
// Holds the previous address output value for use during a split/retry cycle
// when the address incrementer is being used, as the previous address must be
// used to regenerate the split/retried transfer. Only the lowest 10 bits of
// the address are held equivalent to the bits that can be changed by the
// address incrementer. The top 12 bits will always be the same as for the
// previous transfer, so do not need to be stored.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_HaddrPrevSeq
  if (HRESETn == 1'b0)
    begin
      HaddrPrev        <= 10'b0000000000;
    end
  else
    begin
      if (HREADYINTIC == 1'b1)
        begin
          HaddrPrev        <= iHADDRTIC[9:0];
        end
    end
end // p_HaddrPrevSeq

// -----------------------------------------------------------------------------
// Address overflow detection
// This output is set high when the next incremented address will overflow,
// i.e. the current address is just before the incrementing boundary.
// A registered version is also used.
// -----------------------------------------------------------------------------
always @(iHSIZETIC or iHADDRTIC)
begin : p_BoundComb
  if ((iHSIZETIC == `SZ_BYTE && (iHADDRTIC[7:0] == 8'b11111111)) ||
      (iHSIZETIC == `SZ_HALF && (iHADDRTIC[8:1] == 8'b11111111)) ||
      (iHSIZETIC == `SZ_WORD && (iHADDRTIC[9:2] == 8'b11111111)))
    begin
      Bound            = 1'b1;
    end
  else
    begin
      Bound            = 1'b0;
    end
end // p_BoundComb

// -----------------------------------------------------------------------------
// Clocked/ logic for registering the Bound
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_BoundRegSeq
  if (HRESETn == 1'b0)
    begin
      BoundReg         <= 1'b0;
    end
  else
    begin
      if (HREADYINTIC == 1'b1)
        begin
          BoundReg         <= Bound;
        end
    end
end // p_BoundRegSeq

// -----------------------------------------------------------------------------
// Control vector detection
// Used to distinguish between address vectors and control vectors.
// A control vector is detected as the last address vector of a burst of at
// least 2 addresses vectors, when LastVect and CurrentVect are both
// address vectors, and the next vector is a read or a write.
// -----------------------------------------------------------------------------
always @(LastVect or CurrentVect or NextVect)
begin : p_ControlVectComb
  if (LastVect == `STV_ADDRVEC && CurrentVect == `STV_ADDRVEC &&
      (NextVect == `STV_READVEC || NextVect == `STV_WRITEVEC))
    begin
      ControlVect      = 1'b1;
    end
  else
    begin
      ControlVect      = 1'b0;
    end
end // p_ControlVectComb

// -----------------------------------------------------------------------------
// A control vector is only selected for use when bit 0 is set HIGH.
// -----------------------------------------------------------------------------
always @(ControlVect or TBUSIN)
begin : p_ControlSelComb
  if (ControlVect == 1'b1 && TBUSIN[0] == 1'b1)
    begin
      ControlSel       = 1'b1;
    end
  else
    begin
      ControlSel       = 1'b0;
    end
end // p_ControlSelComb

// -----------------------------------------------------------------------------
// Control vector values are read in from the external test bus during
// a control vector, and the current output values are held at all other times.
// -----------------------------------------------------------------------------
always @(ControlSel or TBUSIN or IncrmReg or iHPROTTIC or iHLOCK or HsizeInt or
         TICBUSGNT)
begin : p_ControlComb
  if (ControlSel == 1'b1 && TICBUSGNT == 1'b1)
    begin
      Incrm            = TBUSIN[7];
      HprotGen         = {TBUSIN[10:9], TBUSIN[6:5]};
      HlockGen         = TBUSIN[4];
      HsizeGen         = TBUSIN[3:2];
    end
  else
    begin
      Incrm            = IncrmReg;
      HprotGen         = iHPROTTIC;
      HlockGen         = iHLOCK;
      HsizeGen         = HsizeInt;
    end
end // p_ControlComb

// -----------------------------------------------------------------------------
// The default values after reset are:
// IncrmReg = address incrementing disabled
// HPROTTIC = supervisor access, un-cacheable and un-bufferable
// HLOCK = unlocked transfer
// HSIZETIC = 32-bit transfer (word)
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_ControlSeq
  if (HRESETn == 1'b0)
    begin
      IncrmReg         <= 1'b0;
      iHPROTTIC        <= 4'b0011;
      iHLOCK           <= 1'b0;
      HsizeInt         <= 2'b10;
    end
   else
    begin
      IncrmReg         <= Incrm;
      iHPROTTIC        <= HprotGen;
      iHLOCK           <= HlockGen;
      HsizeInt         <= HsizeGen;
    end
end // p_ControlSeq

// -----------------------------------------------------------------------------
// TICREAD generation
// TICREAD is active HIGH and controls when the external memory interface
// drives read data from the internal HRDATATIC bus out on to the external
// TBUSOUT. Data is driven out from the rising edge of HCLK in the read cycle
// and remains driven past the end of the transfer until the rising edge of
// clock after the transfer has completed. A read or burst of reads will always
// be followed by a Turnaround vector, which prevents bus clash on the external
// TESTBUS.
// -----------------------------------------------------------------------------
assign iTICREAD         = (DataDrive == 1'b0) ? 1'b0                 : (
                           (LastVect == `STV_READVEC) ? 1'b1 : 1'b0);

assign TBUSOUT          = (iTICREAD == 1'b1) ? HRDATATIC              :
                           (ZEROFILL);

// -----------------------------------------------------------------------------
// Split/Retry detection
// This section is used to control the operation of the TIC during a
// split/retry cycle initiated by the current slave. If grant is lost before
// the transfer has completed, thenthe value of SplitRetry is held.
// -----------------------------------------------------------------------------
assign SRNext           = ((HRESPTIC == `RSP_RETRY || HRESPTIC == `RSP_SPLIT)
                           && DataDrive == 1'b1) ? 1'b1               : (
                           AddrDrive == 1'b0 ? SplitRetry : 1'b0);

// -----------------------------------------------------------------------------
// Sequential process for Split/Retry
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_SplitRetrySeq
  if (HRESETn == 1'b0)
    begin
      SplitRetry       <= 1'b0;
    end
  else
    begin
      SplitRetry       <= SRNext;
    end
end // p_SplitRetrySeq

// -----------------------------------------------------------------------------
// SR1 is set HIGH during the HREADYINTIC LOW cycle of a split/retry response.
// Registered SR2 is set HIGH during the HREADYINTIC HIGH cycle of a split/retry
// response. This is used to remove the combinational path from HRESPTIC to
// HTRANSTIC when driving out an Idle during the second cycle of a split/retry.
// -----------------------------------------------------------------------------
assign SR1              = ((HRESPTIC == `RSP_RETRY || HRESPTIC == `RSP_SPLIT)
                           && DataDrive == 1'b1 && HREADYINTIC == 1'b0) ? 1'b1
                           : 1'b0;

// -----------------------------------------------------------------------------
// Sequential process
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_SR2Seq
  if (HRESETn == 1'b0)
    begin
      SR2              <= 1'b0;
    end
  else
    begin
      SR2              <= SR1;
    end
end // p_SR2Seq

// -----------------------------------------------------------------------------
// Transfer type (HTRANSTIC) generation
// Only indicate Sequential when an incremented address is going to be used.
// The cases when an incremented address are used are:
// - a read followed by a read
// - a write followed by a write
// - a write followed by a read

// An Idle is inserted during the second cycle of a split/retry response.
// A Non-Seqeuntial will always be inserted during the cycle after a
// split/retry response has been received.
// -----------------------------------------------------------------------------
always @(SR2 or SplitRetry or CurrentVect or AddrDrive or
         DataDrive or LastVect or IncrmReg or BoundReg)
begin : p_iHTRANSComb
  if (SR2 == 1'b1)
    begin
      iHTRANSTIC       = `TRN_IDLE;
    end
  else if (SplitRetry == 1'b1)
    begin
      iHTRANSTIC       = `TRN_NONSEQ;
    end
  else
    begin
      case (CurrentVect)

        `STV_READVEC :
          begin
            if (AddrDrive == 1'b1 && DataDrive == 1'b0)
              begin
                iHTRANSTIC       = `TRN_NONSEQ;
              end
            else if ((LastVect == CurrentVect) && IncrmReg == 1'b1 &&
                     BoundReg == 1'b0)
              begin
                iHTRANSTIC       = `TRN_SEQ;
              end
            else
              begin
                iHTRANSTIC       = `TRN_NONSEQ;
              end
          end 

        `STV_WRITEVEC :
          begin
            if (AddrDrive == 1'b1 && DataDrive == 1'b0)
              begin
                iHTRANSTIC       = `TRN_NONSEQ;
              end
            else if ((LastVect == CurrentVect) && IncrmReg == 1'b1 &&
                      BoundReg == 1'b0)
              begin
                iHTRANSTIC       = `TRN_SEQ;
              end
            else
              begin
                iHTRANSTIC       = `TRN_NONSEQ;
              end
          end

        default :
          iHTRANSTIC       = `TRN_IDLE;
        endcase
    end
end // p_iHTRANSComb

// -----------------------------------------------------------------------------
// iHWRITETIC generation
// After a split/retry response, the last vector must be used to regenerate the
// previous transfer. The current vector is used at all other times.
// -----------------------------------------------------------------------------
assign Vect             = (SplitRetry == 1'b1) ? LastVect            :
                           CurrentVect;

assign iHWRITETIC       = (Vect == `STV_WRITEVEC) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Output data bus generation
// HWDATATIC is driven from TBUSIN a write cycle, and keeps its current value
// during a split/retry cycle or when the bus is waited.
// Registered to generate correct AHB timing for a write cycle.
// -----------------------------------------------------------------------------
assign HwdataEn         = (HREADYINTIC == 1'b1 && CurrentVect == `STV_WRITEVEC
                           && SplitRetry == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Sequential process for HWDATA bus
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_HWDATASeq
  if (HRESETn == 1'b0)
    begin
      iHWDATATIC       <= 32'h00000000;
    end
    else
    begin
      if (HwdataEn == 1'b1)
        begin
          iHWDATATIC       <= TBUSIN;
        end
    end
end // p_HWDATASeq

// -----------------------------------------------------------------------------
// Bus request generation
// Request access to the bus once the `STV_START vector state is entered and
// keep requesting access until the `STV_IDLE state is re-entered at the end of
// the test. The TIC does not back off the bus for address vectors.
// -----------------------------------------------------------------------------
assign iHBUSREQTIC      = (CurrentVect == `STV_IDLE) ? 1'b0 : 1'b1;

// -----------------------------------------------------------------------------
// AMBA signals out of module
// Drives the address, control and data outputs with the internally generated
// versions.
// -----------------------------------------------------------------------------
assign iHSIZETIC        = {1'b0, HsizeInt};
// Generate full HSIZETIC output
assign HADDRTIC         = iHADDRTIC;
assign HTRANSTIC        = iHTRANSTIC;
assign HWRITETIC        = iHWRITETIC;
assign HSIZETIC         = iHSIZETIC;
assign HBURSTTIC        = 3'b001;
// Always incrementing burst of unspecified length
assign HPROTTIC         = iHPROTTIC;
assign HWDATATIC        = iHWDATATIC;
assign HLOCKTIC         = iHLOCK;

// -----------------------------------------------------------------------------
// Output drivers
// Drives the non-AMBA outputs with internal version.
// -----------------------------------------------------------------------------
assign SMTESTACK        = iSMTESTACK;
assign HBUSREQTIC       = iHBUSREQTIC;
assign TICBUSREQ        = iHBUSREQTIC;
assign TICREAD          = iTICREAD;

endmodule
// --================================== End ==================================--
