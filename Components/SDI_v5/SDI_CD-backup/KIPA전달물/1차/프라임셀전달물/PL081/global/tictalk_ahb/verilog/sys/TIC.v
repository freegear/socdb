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
// File Name              : TIC.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
//
// ---------------------------------------------------------------------
// Purpose :
//           Test Interface Controller (TIC) for the AMBA system
//
// --=================================================================--

`timescale 1ns/1ps

module TIC (HCLK, HRESETn, HREADY, HRESP, HGRANTtic, HADDR, HTRANS,
            HWRITE, HSIZE, HBURST, HPROT, HWDATA, HBUSREQtic, HLOCKtic,
            TESTBUS, TESTREQA, TESTREQB, TESTACK, TicRead);

  input         HCLK;
  input         HRESETn;
  input         HREADY;
  input   [1:0] HRESP;
  input         HGRANTtic;

  output [31:0] HADDR;
  output  [1:0] HTRANS;
  output        HWRITE;
  output  [2:0] HSIZE;
  output  [2:0] HBURST;
  output  [3:0] HPROT;
  output [31:0] HWDATA;
  output        HBUSREQtic;
  output        HLOCKtic;

  input  [31:0] TESTBUS;  // External data bus
  input         TESTREQA; // Test bus request A
  input         TESTREQB; // Test bus request B

  output        TESTACK;  // Test acknowledge
  output        TicRead;  // Drive AHB read data onto TESTBUS

// ---------------------------------------------------------------------
// The TIC is a state machine that provides an AMBA bus master for
// system test. It controls the External Test Bus and AHB data buses
// HRDATA and HWDATA during the application of Test Interface Format
// (TIF) test vectors.
//
// The TIC consists of three main blocks:
//
//   Test Vector State Machine - Uses the TESTREQA and TESTREQB signals
//   to decide which type of vector is being applied on the external
//   TESTBUS.
//
//   Address and Control Registers - Holds values for the address and
//   control signals and includes an address incrementer for burst
//   accesses.
//
//   AMBA Bus Master Interface - Includes the AMBA bus master state
//   machine and the control of the AMBA bus signals.
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// State encoding of the granted state machine
  `define STG_NOT_GRANT  2'b00
  `define STG_GAIN_GRANT 2'b01
  `define STG_GRANT      2'b11
  `define STG_LOSE_GRANT 2'b10

// State encoding of the TIC vector state machine
  `define STV_IDLE       3'b000
  `define STV_START      3'b001
  `define STV_ADDRVEC    3'b010
  `define STV_WRITEVEC   3'b011
  `define STV_READVEC    3'b100
  `define STV_LASTREAD   3'b101
  `define STV_TURNAROUND 3'b110

// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

// HSIZE transfer type signal encoding
  `define SZ_BYTE 3'b000
  `define SZ_HALF 3'b001
  `define SZ_WORD 3'b010

// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
  reg   [1:0] NextGrant;    // Granted state machine
  reg   [1:0] CurrentGrant;
  wire        AddrDrive;    // Address bus drive enable output
  wire        DataDrive;    // Data bus drive enable output

  wire        iTESTACK;     // Internal TESTACK output

  reg         SyncTestReqA; // Synchronised TESTREQA input
  reg   [2:0] NextVect;     // TIC vector state machine
  reg   [2:0] CurrentVect;
  reg   [2:0] LastVect;

  reg  [31:0] IncAddr;      // Incremented address
  wire [31:0] HaddrMux;     // HADDR reg input mux
  wire        HaddrEn;      // HADDR reg enable
  reg  [31:0] iHADDR;       // Internal HADDR reg
  reg   [9:0] HaddrPrev;    // Previous HADDR value

  reg         Bound;        // Detects an incremented address boundary
  reg         BoundReg;     // Registered Bound

  reg         ControlVect;  // Detects a control vector being applied
  reg         ControlSel;   // Selected control vector
  reg         Incrm;        // Incremental control vector setting
  reg         IncrmReg;     // Incremental control vector setting
  reg   [3:0] HprotGen;     // Prot control vect set
  reg   [3:0] iHPROT;       // Registered HprotGen
  reg         HlockGen;     // Lock control vector setting
  reg         iHLOCK;       // Registered iHLOCK
  reg   [1:0] HsizeGen;     // Size control vect set
  reg   [1:0] HsizeInt;     // Registered HsizeGen
  wire  [2:0] iHSIZE;       // Int version of output

  wire        SRNext;       // Input to SplitRetry register
  reg         SplitRetry;   // Indicates a split/retry cycle
  wire        SR1;          // High during first split/retry cycle
  reg         SR2;          // High during second split/retry cycle

  reg   [1:0] iHTRANS;      // Int version of output
  wire  [2:0] Vect;         // Muxed vector state
  wire        iHWRITE;      // Internal HWRITE output
  wire        HwdataEn;     // HWDATA register enable
  reg  [31:0] iHWDATA;      // HWDATA register

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Granted state machine next state logic
// ---------------------------------------------------------------------
// NextGrant only changes when HREADY is HIGH (to show the end of the
// current transfer), and is set according to the values of HGRANT and
// CurrentGrant.

  always @(HRESETn or HREADY or CurrentGrant or HGRANTtic)
  begin
    if (!HRESETn)
      NextGrant = `STG_NOT_GRANT;
    else
      if (HREADY)
        case (CurrentGrant)

          `STG_NOT_GRANT :
            if (HGRANTtic)
              NextGrant = `STG_GAIN_GRANT;
            else
              NextGrant = `STG_NOT_GRANT;

          `STG_GAIN_GRANT :
            if (HGRANTtic)
              NextGrant = `STG_GRANT;
            else
              NextGrant = `STG_LOSE_GRANT;

          `STG_GRANT :
            if (HGRANTtic)
              NextGrant = `STG_GRANT;
            else
              NextGrant = `STG_LOSE_GRANT;

          `STG_LOSE_GRANT :
            if (HGRANTtic)
              NextGrant = `STG_GAIN_GRANT;
            else
              NextGrant = `STG_NOT_GRANT;

          default :
            NextGrant = `STG_NOT_GRANT;

        endcase
      else
        NextGrant = CurrentGrant;
  end

// ---------------------------------------------------------------------
// Granted state machine current state
// ---------------------------------------------------------------------
// Loads the value of NextGrant in on each HCLK

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      CurrentGrant <= `STG_NOT_GRANT;
    else
      CurrentGrant <= NextGrant;
  end

// ---------------------------------------------------------------------
// Address and data enables
// ---------------------------------------------------------------------
// Indicate when the master has control of the address/control and data
// buses.

  assign AddrDrive = ((CurrentGrant == `STG_GAIN_GRANT ||
                       CurrentGrant == `STG_GRANT) ? 1'b1 :
                     1'b0);

  assign DataDrive = ((CurrentGrant == `STG_GRANT ||
                       CurrentGrant == `STG_LOSE_GRANT) ? 1'b1 :
                     1'b0);

// ---------------------------------------------------------------------
// TESTACK generation
// ---------------------------------------------------------------------
// TESTACK is always LOW unless the TIC is granted on the bus, in which
// case the HREADY signal is used to generate TESTACK. During
// split/retry cycles it is also set LOW.

  assign iTESTACK = (SplitRetry == 1'b1 ? 1'b0 :
                    (DataDrive == 1'b1 ? HREADY :
                    1'b0));

// ---------------------------------------------------------------------
// Synchronisation of TESTREQA prior to entering test
// ---------------------------------------------------------------------
// This allows a switch from an internal clock to an external test
// clock prior to test. Once test is entered the system clock should be
// switched to TCLK, hence TESTREQA will be synchronous.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      SyncTestReqA <= 1'b0;
    else
      SyncTestReqA <= TESTREQA;
  end

// ---------------------------------------------------------------------
// TIC vector state machine next state logic
// ---------------------------------------------------------------------
// This state machine tracks which type of test vector is being applied
// according to the TESTREQA and TESTREQB signals. When in test mode
// TESTREQA and TESTREQB are only considered valid when TESTACK is HIGH.

  always @(CurrentVect or SyncTestReqA or iTESTACK or TESTREQA or
           TESTREQB)
  begin
    case (CurrentVect)

      `STV_IDLE :
        if (SyncTestReqA)
        // If any clock switching is required, then the signal that
        // indicates that the clock switch has occured should be used
        // as an extra condition to move to STV_START.
          NextVect = `STV_START;  // Move to START using synchronised
                                  // TESTREQA
        else
          NextVect = `STV_IDLE;

      `STV_START :
        if (!iTESTACK)            // Remain in START until granted the
                                  // bus
          NextVect = `STV_START;
        else if ((TESTREQA && TESTREQB))  // Address
          NextVect = `STV_ADDRVEC;
        else
          NextVect = `STV_START;

      `STV_ADDRVEC :
        if (!iTESTACK)
          NextVect = `STV_ADDRVEC;
        else if ((TESTREQA && TESTREQB))  // Address
          NextVect = `STV_ADDRVEC;
        else if ((TESTREQA && !TESTREQB)) // Write
          NextVect = `STV_WRITEVEC;
        else if ((!TESTREQA && TESTREQB)) // Read
          NextVect = `STV_READVEC;
        else                              // Exit
          NextVect = `STV_IDLE;

      `STV_WRITEVEC :
        if (!iTESTACK)
          NextVect = `STV_WRITEVEC;
        else if ((!TESTREQA && TESTREQB)) // Read
          NextVect = `STV_READVEC;
        else if ((TESTREQA && !TESTREQB)) // Write
          NextVect = `STV_WRITEVEC;
        else                              // Address/Exit
          NextVect = `STV_ADDRVEC;

      `STV_READVEC :
        if (!iTESTACK)
          NextVect = `STV_READVEC;
        else if ((!TESTREQA && TESTREQB)) // Read
          NextVect = `STV_READVEC;
        else                              // Address/Write/Exit
          NextVect = `STV_LASTREAD;

      `STV_LASTREAD :
        if (!iTESTACK)
          NextVect = `STV_LASTREAD;
        else
          NextVect = `STV_TURNAROUND;

      `STV_TURNAROUND :
        if (!iTESTACK)
          NextVect = `STV_TURNAROUND;
        else if ((!TESTREQA && TESTREQB)) // Read
          NextVect = `STV_READVEC;
        else if ((TESTREQA && !TESTREQB)) // Write
          NextVect = `STV_WRITEVEC;
        else                              // Address/Exit
          NextVect = `STV_ADDRVEC;

      default :                           // Others will be never
                                          // reached
        NextVect = `STV_IDLE;

    endcase
  end

// ---------------------------------------------------------------------
// TIC vector state machine current state
// ---------------------------------------------------------------------

  always @( posedge (HCLK) or negedge (HRESETn) )
  begin
    if ((!HRESETn))
      CurrentVect <= `STV_IDLE;
    else
      CurrentVect <= NextVect;
  end

// ---------------------------------------------------------------------
// TIC vector state machine last state
// ---------------------------------------------------------------------
// LastVect is needed to detect control vectors.
// A vector is only consider to be applied when TESTACK is high.

  always @( posedge (HCLK) or negedge (HRESETn) )
  begin
    if ((!HRESETn))
      LastVect <= `STV_IDLE;
    else
    begin
      if (iTESTACK)
        LastVect <= CurrentVect;
    end
  end

// ---------------------------------------------------------------------
// Address incrementer
// ---------------------------------------------------------------------
// Increments the address according to the value of HSIZE.
// The default system only uses byte, halfword and word incrementing,
// but can easily be expanded to work with larger address increments.

  always @(iHSIZE or iHADDR)
  begin
    case (iHSIZE)

      `SZ_BYTE :
      begin                                // Byte increment
        IncAddr[7:0]  = iHADDR[7:0] + 1'b1;
        IncAddr[31:8] = iHADDR[31:8];
      end

      `SZ_HALF :
      begin                                // Halfword increment
        IncAddr[0]    = 1'b0;
        IncAddr[8:1]  = iHADDR[8:1] + 1'b1;
        IncAddr[31:9] = iHADDR[31:9];
      end

      default :
      begin                                // Word increment
        IncAddr[1:0]   = 2'b00;
        IncAddr[9:2]   = iHADDR[9:2] + 1'b1;
        IncAddr[31:10] = iHADDR[31:10];
      end

    endcase
  end

// ---------------------------------------------------------------------
// Address selection and output generation
// ---------------------------------------------------------------------
// The combinatorial output of the mux is used as the HADDR register
// input. The external address input is used during an address vector,
// and the address incrementer is used at all other times.

  assign HaddrMux = (SplitRetry == 1'b1 ?
                    ({IncAddr[31:10], HaddrPrev[9:0]}) :
                    ((CurrentVect == `STV_ADDRVEC ||
                      IncrmReg == 1'b0) ? TESTBUS : IncAddr));

// The address register enable is used to load in a new address value
// from the external test bus during an address vector, from the
// HaddrPrev registers during a split or retry cycle, and from the
// address incrementer during a sequential read or write vector.

  assign HaddrEn = ((HREADY == 1'b1 && ControlSel == 1'b0 &&
                     (CurrentVect == `STV_ADDRVEC ||
                      SplitRetry == 1'b1 ||
                      (IncrmReg == 1'b1 &&
                       (CurrentVect == `STV_READVEC ||
                        CurrentVect == `STV_WRITEVEC)))) ? 1'b1 : 1'b0);

// An enabled register is used to hold the current address value to
// improve the output timing.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      iHADDR <= 32'h0000_0000;
    else
    begin
      if (HaddrEn)
        iHADDR <= HaddrMux;
    end
  end

// Holds the previous address output value for use during a split/retry
// cycle when the address incrementer is being used, as the previous
// address must be used to regenerate the split/retried transfer.
// Only the lowest 10 bits of the address are held - equivalent to the
// bits that can be changed by the address incrementer. The top 12 bits
// will always be the same as for the previous transfer, so do not need
// to be stored.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      HaddrPrev <= 10'b0000000000;
    else
    begin
      if (HREADY)
        HaddrPrev <= iHADDR[9:0];
    end
  end

// ---------------------------------------------------------------------
// Address overflow detection
// ---------------------------------------------------------------------
// This output is set high when the next incremented address will
// overflow, ie. the current address is just before the incrementing
// boundary. A registered version is also used.

  always @(iHSIZE or iHADDR)
  begin
    if (((iHSIZE == `SZ_BYTE && (iHADDR[7:0] == 8'b11111111)) ||
         (iHSIZE == `SZ_HALF && (iHADDR[8:1] == 8'b11111111)) ||
         (iHSIZE == `SZ_WORD && (iHADDR[9:2] == 8'b11111111))))
      Bound = 1'b1;
    else
      Bound = 1'b0;
  end

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      BoundReg <= 1'b0;
    else
    begin
      if (HREADY)
        BoundReg <= Bound;
    end
  end

// ---------------------------------------------------------------------
// Control vector detection
// ---------------------------------------------------------------------
// Used to distinguish between address vectors and control vectors.
// A control vector is detected as the last address vector of a burst
// of at least 2 addresses vectors, when LastVect and CurrentVect are
// both address vectors, and the next vector is a read or a write.

  always @(LastVect or CurrentVect or NextVect)
  begin
    if ((LastVect == `STV_ADDRVEC && CurrentVect == `STV_ADDRVEC &&
         (NextVect == `STV_READVEC || NextVect == `STV_WRITEVEC)))
      ControlVect = 1'b1;
    else
      ControlVect = 1'b0;
  end

// A control vector is only selected for use when bit 0 is set HIGH.
  always @(ControlVect or TESTBUS)
  begin
    if ((ControlVect && TESTBUS[0]))
      ControlSel = 1'b1;
    else
      ControlSel = 1'b0;
  end

// Control vector values are read in from the external test bus during
// a control vector, and the current output values are held at all
// other times.

  always @(ControlSel or TESTBUS or IncrmReg or iHPROT or iHLOCK or
           HsizeInt)
  begin
    case (ControlSel)
      1'b1 :
      begin
        Incrm = TESTBUS[7];
        HprotGen = {TESTBUS[10:9], TESTBUS[6:5]};
        HlockGen = TESTBUS[4];
        HsizeGen = TESTBUS[3:2];
      end
      default :
      begin
        Incrm = IncrmReg;
        HprotGen = iHPROT;
        HlockGen = iHLOCK;
        HsizeGen = HsizeInt;
      end
    endcase
  end

// The default values after reset are:
// IncrmReg = address incrementing disabled
// HPROT    = supervisor access, un-cacheable and un-bufferable
// HLOCK    = unlocked transfer
// HSIZE    = 32-bit transfer (word)

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
    begin
      IncrmReg <= 1'b0;
      iHPROT   <= 4'b0011;
      iHLOCK   <= 1'b0;
      HsizeInt <= 2'b10;
    end
    else
    begin
      IncrmReg <= Incrm;
      iHPROT   <= HprotGen;
      iHLOCK   <= HlockGen;
      HsizeInt <= HsizeGen;
    end
  end

// ---------------------------------------------------------------------
// TicRead generation
// ---------------------------------------------------------------------
// TicRead is active HIGH and controls when the external memory
// interface drives read data from the internal HRDATA bus out on to
// the external TESTBUS. Data is driven out from the rising edge of
// HCLK in the read cycle and remains driven past the end of the
// transfer until the rising edge of clock after the transfer has
// completed. A read or burst of reads will always be followed by a
// Turnaround vector, which prevents bus clash on the external TESTBUS.

  assign TicRead = (DataDrive == 1'b0 ? 1'b0 :
                   (LastVect == `STV_READVEC ? 1'b1 : 1'b0));

// ---------------------------------------------------------------------
// Split/Retry detection
// ---------------------------------------------------------------------
// This section is used to control the operation of the TIC during a
// split/retry cycle initiated by the current slave. If grant is lost
// before the transfer has completed, then the value of SplitRetry is
// held.

  assign SRNext = (((HRESP == `RSP_RETRY || HRESP == `RSP_SPLIT) &&
                    DataDrive == 1'b1) ? 1'b1 :
                  (AddrDrive == 1'b0 ? SplitRetry :
                  1'b0));

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      SplitRetry <= 1'b0;
    else
      SplitRetry <= SRNext;
  end

// SR1 is set HIGH during the HREADY LOW cycle of a split/retry
// response. The registered SR2 is set HIGH during the HREADY HIGH
// cycle of a split/retry response. This is used to remove the
// combinational path from HRESP to HTRANS when driving out an Idle
// during the second cycle of a split/retry.

  assign SR1 = (((HRESP == `RSP_RETRY || HRESP == `RSP_SPLIT) &&
                 DataDrive == 1'b1 && HREADY == 1'b0) ? 1'b1 :
               1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      SR2 <= 1'b0;
    else
      SR2 <= SR1;
  end

// ---------------------------------------------------------------------
// Transfer type (HTRANS) generation
// ---------------------------------------------------------------------
// Only indicate Sequential when an incremented address is going to be
// used. The cases when an incremented address are used are:
//  - a read  followed by a read
//  - a write followed by a write
//  - a write followed by a read.

// An Idle is inserted during the second cycle of a split/retry
// response. A Non-Seqeuntial will always be inserted during the cycle
// after a split/retry response has been received.

  always @(SR2 or SplitRetry or CurrentVect or AddrDrive or DataDrive or
           LastVect or IncrmReg or BoundReg)
  begin
    if (SR2)
      iHTRANS = `TRN_IDLE;
    else if (SplitRetry)
      iHTRANS = `TRN_NONSEQ;
    else
      case (CurrentVect)

        `STV_READVEC,`STV_WRITEVEC :
          if ((AddrDrive && !DataDrive))
            iHTRANS = `TRN_NONSEQ;
          else if (((LastVect == `STV_READVEC ||
                     LastVect == `STV_WRITEVEC) &&
                    IncrmReg && !BoundReg))
            iHTRANS = `TRN_SEQ;
          else
            iHTRANS = `TRN_NONSEQ;

        default :
          iHTRANS = `TRN_IDLE;

      endcase
  end

// ---------------------------------------------------------------------
// iHWRITE generation
// ---------------------------------------------------------------------
// After a split/retry response, the last vector must be used to
// regenerate the previous transfer. The current vector is used at all
// other times.

  assign Vect = (SplitRetry == 1'b1 ? LastVect : CurrentVect);

  assign iHWRITE = (Vect == `STV_WRITEVEC ? 1'b1 : 1'b0);

// ---------------------------------------------------------------------
// Output data bus generation
// ---------------------------------------------------------------------
// HWDATA is driven to TESTBUS during a write cycle, and keeps its
// current value during a split/retry cycle or when the bus is waited.
// Registered to generate correct AHB timing for a write cycle.

  assign HwdataEn = ((HREADY == 1'b1 && CurrentVect == `STV_WRITEVEC &&
                      SplitRetry == 1'b0) ? 1'b1 : 1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      iHWDATA <= 32'h0000_0000;
    else
    begin
      if (HwdataEn)
        iHWDATA <= TESTBUS;
    end
  end

// ---------------------------------------------------------------------
// Bus request generation
// ---------------------------------------------------------------------
// Request access to the bus once the STV_START vector state is entered
// and keep requesting access until the STV_IDLE state is re-entered at
// the end of the test. The TIC does not back off the bus for address
// vectors.

  assign HBUSREQtic = (CurrentVect == `STV_IDLE ? 1'b0 : 1'b1);

// ---------------------------------------------------------------------
// AMBA signals out of module
// ---------------------------------------------------------------------
// Drives the address, control and data outputs with the internally
// generated versions.

  assign iHSIZE = {1'b0 , HsizeInt};  // Generate full HSIZE output

  assign HADDR  = iHADDR;
  assign HTRANS = iHTRANS;
  assign HWRITE = iHWRITE;
  assign HSIZE  = iHSIZE;
  assign HBURST = 3'b001;  // Always incrementing burst of unspecified
                           // length
  assign HPROT  = iHPROT;

  assign HWDATA = iHWDATA;

  assign HLOCKtic = iHLOCK;

// ---------------------------------------------------------------------
// Output driver
// ---------------------------------------------------------------------
// Drives the non-AMBA output with internal version.

  assign TESTACK = iTESTACK;


endmodule

// --============================== End ==============================--
