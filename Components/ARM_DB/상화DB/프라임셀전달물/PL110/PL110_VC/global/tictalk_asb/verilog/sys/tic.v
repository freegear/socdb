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
// File Name              : tic.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v6
//
// ---------------------------------------------------------------------
// Purpose : Test Interface Controller for an AMBA system
//
// --=================================================================--

`timescale 1ns/1ps

module tic (BCLK, BnRES, BWAIT, BERROR, BLAST, BD, AGNTtic, AREQtic, 
            BSIZE, BTRAN, BLOK, BPROT, BA, BWRITE, TREQA, TREQB, TACK, 
            TestMode, Ticinen, TicoutLen, Ticouten);
 
  input         BCLK;
  input         BnRES;
  input         BWAIT;
  input         BERROR;
  input         BLAST;
  input  [31:0] BD;
  input         AGNTtic;
  output        AREQtic;
  output  [1:0] BSIZE;
  output  [1:0] BTRAN;
  output        BLOK;
  output  [1:0] BPROT;
  output [31:0] BA;
  output        BWRITE;

  input         TREQA;     // Test bus request A
  input         TREQB;     // Test bus request B
  output        TACK;      // Test acknowledge
  output        TestMode;  // Overide normal operation
  output        Ticinen;   // Drive in write data
  output        TicoutLen; // Latch read data
  output        Ticouten;  // Drive out read data


// ---------------------------------------------------------------------
// The tic is a state machine that provides an AMBA bus master for 
// system test. It controls the External Bus Interface (EBI) to sample 
// or drive the ASB data bus BD during application of Test Interface 
// Format (TIF) test vectors.
//
// The tic consists of four main blocks:
//   Test Vector State Machine - Uses the TREQA and TREQB signals
//     to decide which type of vector is being applied on the
//     external TBUS.
//   Address and Control Registers - Holds values for the address
//     and control signals and includes an address incrementer for
//     burst accesses.
//   External Memory Interface - Generates the four control signals
//     which interface to the external memory interface.
//   AMBA Bus Master Interface - Includes the AMBA bus master
//     state machine and the tri-state control of the AMBA
//     bus signals.
//----------------------------------------------------------------------
 
// ---------------------------------------------------------------------
//  Constant declarations
// ---------------------------------------------------------------------
//  Bus master state machine state encoding

  `define STM_IDLE       3'b000
  `define STM_BUSIDLE    3'b001
  `define STM_HOLD       3'b010
  `define STM_HANDOVER   3'b011
  `define STM_ACTIVE     3'b100
  `define STM_RETRACT    3'b101
 
//  tic vector state machine state encoding

  `define STV_IDLE       3'b000
  `define STV_START      3'b001
  `define STV_ADDRVEC    3'b010
  `define STV_WRITEVEC   3'b011
  `define STV_READVEC    3'b100
  `define STV_TURNAROUND 3'b101
 
// ---------------------------------------------------------------------
//  Signal declarations
// ---------------------------------------------------------------------

  wire [7:0] IncFull;

// Aliases for output signals
  reg        AREQticInt;
  reg  [1:0] BTRANInt;
  reg [31:0] BAInt;
  reg        BWRITEInt;
  reg  [1:0] BSIZEInt;
  reg  [1:0] BPROTInt;
  reg        BLOKInt;
  reg        iTACK;
  reg        iTestMode;
  reg        TicoutLenInt;
  reg        TicoutenInt;
  reg        TicinenInt;

// Test Vector State Machine
  reg        SyncTREQA;
  reg        SyncTREQB;
  reg        RequestBus;
  reg  [2:0] LastVector;
  reg  [2:0] CurrentVector;
  reg  [2:0] NextVector;

// Address and Control Registers
  reg        ControlVector;
  reg        ControlSel;
  reg  [1:0] AddressRegSel;
  reg        Incrm;
  reg        Overflow;
  reg        IncrmReg;
  reg        SeqOnly;
  reg        SeqOnlyReg;
  reg  [1:0] PROTint;
  reg  [1:0] SIZEint;
  reg  [1:0] PROTintReg;
  reg  [1:0] SIZEintReg;
  reg        LOKint;
  reg        LOKintReg;
  reg        WRITEint;
  reg        WRITEintReg;
  reg [31:0] AintReg;
  reg [31:0] Aint;
  reg [31:0] IncAddr;

// AMBA Bus Master Interface
  reg  [1:0] ticTran;
  reg  [1:0] TRANint;
  reg  [2:0] CurrentMasterState;
  reg  [2:0] NextMasterState;
  reg        LBWAIT;
  reg        LBERROR;
  reg        LBLAST;
  reg        GrantedD2;
  reg        BnRESD2;
  reg        Granted;
  reg        DelayedGranted;
  reg        NtranStart;
  reg        DatabusEnable;

// ---------------------------------------------------------------------
//  Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Propogation of internal signals onto outputs
//  Within this design all outputs are generated internally and then
//  assigned to an output pin. The internal signal is named with an 'i'
//  at the end of the signal name, so in general it can be assumed that
//  signali == signal.
//  This allows realistic times delays to be added to all outputs at
//  just one point in the code and also aids making the VHDL and Verilog
//  source look similar.
// ---------------------------------------------------------------------

  assign AREQtic = AREQticInt;
  assign BTRAN = BTRANInt;
  assign BA = BAInt;
  assign BWRITE = BWRITEInt;
  assign BSIZE = BSIZEInt;
  assign BPROT = BPROTInt;
  assign BLOK = BLOKInt;
  assign TACK = iTACK;
  assign TestMode = iTestMode;
  assign TicoutLen = TicoutLenInt;
  assign Ticouten = TicoutenInt;
  assign Ticinen = TicinenInt;

// ---------------------------------------------------------------------
//  tic Vector State Machine
//  This state machine tracks which type of test vector is being applied
//  according to the TREQA and TREQB signals. When in test mode TREQA 
//  and TREQB are only considered valid when TACK is HIGH.
// ---------------------------------------------------------------------

  //  Synchronisation of TREQA and TREQB prior to entering test
  //  This allows a switch from an internal clock to an external
  //  test clock prior to test. Once test is entered the system
  //  clock should be switched to TCLK, hence TREQA and TREQ will
  //  be synchronous.

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if (!BnRES)
    begin
      SyncTREQA <= 1'b0;
      SyncTREQB <= 1'b0;
    end
    else
    begin
      SyncTREQA <= TREQA;
      SyncTREQB <= TREQB;
    end
  end
 
  always @( negedge (BCLK) or negedge (BnRES) )
  begin
    if ((!BnRES))
      CurrentVector <= `STV_IDLE;
    else
      CurrentVector <= NextVector;  //  Falling edge state machine
  end
 
  always @(CurrentVector or SyncTREQA or SyncTREQB or TREQA or TREQB or
           iTACK)
  begin
    case (CurrentVector)
      `STV_IDLE :
        if (SyncTREQA && !SyncTREQB)
          // If any clock switching is required, then the signal
          // that indicates that the clock switch has occured should
          // be used as an extra condition to move to STV_START
          NextVector = `STV_START; // Move to start using synced TREQA/B
        else
          NextVector = `STV_IDLE;
 
      `STV_START :
        if (!iTACK)                  // Remain in STV_START until
          NextVector = `STV_START;   // Granted on the bus
        else if (TREQA && TREQB)
          NextVector = `STV_ADDRVEC; // Wait for Address vector
        else
          NextVector = `STV_START;
 
      `STV_ADDRVEC :
        if (!iTACK)
          NextVector = `STV_ADDRVEC;
        else if (TREQA && TREQB)
          NextVector = `STV_ADDRVEC;
        else if (TREQA && !TREQB)
          NextVector = `STV_WRITEVEC;
        else if (!TREQA && TREQB)
          NextVector = `STV_READVEC;
        else                         // TREQA = '0' and TREQB = '0'
          NextVector = `STV_IDLE;    // Exit from test
 
      `STV_WRITEVEC :
        if (!iTACK)
          NextVector = `STV_WRITEVEC;
        else if (!TREQA && TREQB)
          NextVector = `STV_READVEC;
        else if (TREQA && !TREQB)
          NextVector = `STV_WRITEVEC;
        else
          NextVector = `STV_ADDRVEC;
 
      `STV_READVEC :
        if (!iTACK)
          NextVector = `STV_READVEC;
        else if (!TREQA && TREQB)
          NextVector = `STV_READVEC;
        else                            // Cannot go directly from
          NextVector = `STV_TURNAROUND; //  read to write.
 
      `STV_TURNAROUND :
        if (!iTACK)
          NextVector = `STV_TURNAROUND;
        else if (!TREQA && TREQB)
          NextVector = `STV_READVEC;
        else if (TREQA && !TREQB)
          NextVector = `STV_WRITEVEC;
        else
          NextVector = `STV_ADDRVEC;
 
      default  :                       // Others will be never reached
        NextVector = `STV_IDLE;
    endcase
 
  end
 
  //  LastVector is needed to detect control vectors
  //  A vector is only consider to be applied when TACK is high

  always @( negedge (BCLK) or negedge (BnRES) )
  begin
    if ((!BnRES))
      LastVector <= `STV_IDLE;
    else
      if ((iTACK))
        LastVector <= CurrentVector;
  end
 
  //  Request access to the bus once the STV_START vector state is 
  //  entered and keep requesting access until the STV_IDLE state is 
  //  re-entered at the end of the test. The tic does not back off the 
  //  bus for address vectors as the data bus is used to move the 
  //  address from the external memory interface into the tic address 
  //  registers.

  always @(CurrentVector)
  begin
    if ((CurrentVector == `STV_IDLE))
      RequestBus = 1'b0;
    else
      RequestBus = 1'b1;
 
  end
 
  //  RequestBus must be re-timed to generate the AMBA request signal
  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      AREQticInt <= 1'b0;
    else
      AREQticInt <= RequestBus;
  end
 
  //  TACK is always LOW unless the tic is granted on the bus,
  //  in which case the BWAIT signal is used to generate TACK.
  //  Using 'CurrentMasterState' ensures the test interface is
  //  waited in the case of a Retract from a slave.

  //  If the tic requires more than one cycle for an Address
  //  vector to propagate through the pads, through the external
  //  memory interface and be setup to the address/control
  //  registers then the TACK signal can be modified to signal
  //  that the current cycle has not completed and an additional
  //  cycle of address vector is required.

  always @(CurrentMasterState or LBWAIT)
  begin
    if ((CurrentMasterState == `STM_ACTIVE))
      iTACK = ~ LBWAIT;
    else
      iTACK = 1'b0;
  end
 
// ---------------------------------------------------------------------
//  Address and Control Registers
// ---------------------------------------------------------------------
//  The Address and Control Registers hold values for the address
//  and control signals that are to be used for the bus transfers.
// ---------------------------------------------------------------------
//  Both the address and control registers are constructed using a 
//  falling edge D-type to hold the address/control values, but also 
//  include a transparent latch to allow the adddres/control 
//  information to propogate onto the bus during the address/control 
//  vector.
//  This structure is used to avoid the critical
//  path from BWAIT -> LBWAIT -> TACK -> NextVector -> ControlVector
//
//  If the system is only to be used at low clock frequencies then it
//  is possible to replace the latch/reg structure with a single rising
//  edge D-type.
// ---------------------------------------------------------------------

  //  Control vector detection
  //  Used to distinguish between address vectors and control vectors.

  always @(LastVector or CurrentVector or NextVector)
  begin
    if ((LastVector == `STV_ADDRVEC && CurrentVector == `STV_ADDRVEC &&
         (NextVector == `STV_READVEC || NextVector == `STV_WRITEVEC)))
      ControlVector = 1'b1;
    else
      ControlVector = 1'b0;
  end
 
  always @(BnRES or ControlVector or BD)
  begin
    if (!BnRES)
      ControlSel = 1'b0;
    else if ((ControlVector && BD[0]))
      ControlSel = 1'b1;
    else
      ControlSel = 1'b0;
  end
 
  always @(BCLK or BD or ControlSel or IncrmReg or PROTintReg or 
           LOKintReg or SIZEintReg or SeqOnlyReg)
  begin
    if ((BCLK))
    begin
      if ((ControlSel))
      begin
        SeqOnly = BD[8];
        Incrm = BD[7];
        PROTint = BD[6:5];
        LOKint = BD[4];
        SIZEint = BD[3:2];
      end
      else if ((!ControlSel))
      begin
        SeqOnly = SeqOnlyReg;
        Incrm = IncrmReg;
        PROTint = PROTintReg;
        LOKint = LOKintReg;
        SIZEint = SIZEintReg;
      end
    end
  end
 
  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if ((!BnRES))
    begin
      IncrmReg <= 1'b0;
      PROTintReg <= 2'b11;
      LOKintReg <= 1'b0;
      SIZEintReg <= 2'b10;
      SeqOnlyReg <= 1'b0;
    end
    else
    begin
      IncrmReg <= Incrm;
      PROTintReg <= PROTint;
      LOKintReg <= LOKint;
      SIZEintReg <= SIZEint;
      SeqOnlyReg <= SeqOnly;
    end
  end
 
  //  The write signal is generated from the vector type.
  //  A latch/register combination is required to ensure
  //  the write remains glitch free throughout the transfer.

  always @(BCLK or LBWAIT or NextVector or WRITEintReg)
  begin
    if ((BCLK))
      if ((!LBWAIT && NextVector == `STV_WRITEVEC))
        WRITEint = 1'b1;
      else if ((!LBWAIT && NextVector == `STV_READVEC))
        WRITEint = 1'b0;
      else
        WRITEint = WRITEintReg;
  end
 
  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if ((!BnRES))
      WRITEintReg <= 1'b0;
    else
      WRITEintReg <= WRITEint;
  end
 
  //  There are three different possible sources of address:-
  //      BD  - New address vector from the data bus.
  //                Used when an address vector occurs (which
  //                is not a control vector).
  //      IncAddr - Incremented address for burst transfers
  //                Used for a read which is completeing and
  //                is followed by either another read or a
  //                turnaround vector (which is every case for a read).
  //                and a write which is completeing and is followed
  //                by either another write or a read.
  //      AintReg - Hold current value.
  //                Used for all other cases.

  always @(ControlVector or CurrentVector or CurrentMasterState or 
           LBWAIT or Incrm or NextVector)
  begin
    if ((ControlVector))
      AddressRegSel = 2'b01;                  // AintReg
    else if ((CurrentVector == `STV_ADDRVEC)) // Address and not control
      AddressRegSel = 2'b10;                  // BD
    else if ((CurrentVector == `STV_READVEC))
      if ((CurrentMasterState == `STM_ACTIVE && !LBWAIT && Incrm))
        AddressRegSel = 2'b11;                // IncAddr
      else
        AddressRegSel = 2'b01;                // AintReg
    else if ((CurrentVector == `STV_WRITEVEC))
      if (((CurrentMasterState == `STM_ACTIVE && !LBWAIT && Incrm) &&
           (NextVector == `STV_READVEC || NextVector == `STV_WRITEVEC)))
        AddressRegSel = 2'b11;                // IncAddr
      else
        AddressRegSel = 2'b01;                // AintReg
    else
      AddressRegSel = 2'b01;                  // AintReg
  end
 
  //  A latch is used to hold Aint

  always @(BCLK or BD or IncAddr or AintReg or AddressRegSel)
  begin
    if ((BCLK))
    begin
      if (AddressRegSel == 2'b01)
        Aint = AintReg;
      else if (AddressRegSel == 2'b10)
        Aint = BD;
      else if (AddressRegSel == 2'b11)
        Aint = IncAddr;
    end
  end
 
  //  The address register is used to hold the value which has been
  //  driven onto the bus in the HIGH phase of BCLK.

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if ((!BnRES))
      AintReg <= {32{ 1'b0 }};
    else
      AintReg <= Aint;
  end
 
// ---------------------------------------------------------------------
//  Address Incrementer
//  This section is the tic address incrementer.
//  When the incrementer overflows it simply wraps around to the 
//  original value. The number of bits in the address incrementor 
//  could be variable, but the recommended size is 8 bits, allowing 
//  word bursts upto 1 kbyte boundaries
// ---------------------------------------------------------------------

  always @(AintReg or SIZEint)
  begin
    //  Byte increment
    if ((SIZEint == 2'b00))
    begin
      IncAddr[7:0] = AintReg[7:0] + 1'b1;
      IncAddr[31:8] = AintReg[31:8];
    end
    //  Halfword increment
    else if ((SIZEint == 2'b01))
    begin
      IncAddr[0] = AintReg[0];
      IncAddr[8:1] = AintReg[8:1] + 1'b1;
      IncAddr[31:9] = AintReg[31:9];
    end
    //  Word increment
    else
    begin
      IncAddr[1:0] = AintReg[1:0];
      IncAddr[9:2] = AintReg[9:2] + 1'b1;
      IncAddr[31:10] = AintReg[31:10];
    end
  end
 
//  Overflow detect. When the incrementer overflows the next transfer
//  must be signalled as Non-sequential.

  assign IncFull = {8{ 1'b1 }};
  always @(AintReg or SIZEint or IncFull)
  begin
    if ((SIZEint == 2'b00 && (AintReg[7:0] == IncFull)) ||
        (SIZEint == 2'b01 && (AintReg[8:1] == IncFull)) ||
        (SIZEint == 2'b10 && (AintReg[9:2] == IncFull)))
      Overflow = 1'b1;
    else
      Overflow = 1'b0;
  end
 
// ---------------------------------------------------------------------
//  External Bus Interface Control
//  This section generates the four signals (TestMode, TicoutLen, 
//  Ticouten, Ticinen) that control the external bus interface when it 
//  is being used
//  for tic testing.
//        TestMode  - Overide normal operation
//        TicoutLen - Latch read data, active LOW.
//        Ticouten  - Drive out read data (from BD to TBUS), active LOW.
//        Ticinen   - Drive in write data (from TBUS to BD), active LOW.
// ---------------------------------------------------------------------

  //  Test Mode Generation signal
  //  The TestMode signal indicates that the test interface
  //  believes that it is in the process of testing the system. If the
  //  tic does lose mastership of the bus then TestMode will remain 
  //  asserted as the external tester may still be driving on to the 
  //  TBUS and it is import that the external bus interface does not 
  //  switch back to normal operation.
  //  TestMode is entered when the tic is granted the bus

  always @( negedge (BCLK) or negedge (BnRES) )
  begin
    if ((!BnRES))
      iTestMode <= 1'b0;
    else                    // Falling edge triggered
      if ((!iTestMode && RequestBus && Granted))
        iTestMode <= 1'b1;  //  Enter TestMode
      else if ((iTestMode && NextVector == `STV_IDLE))
        iTestMode <= 1'b0;  //  Exit TestMode
  end
 
  //  Ticouten is active low and controls when the external memory
  //  interface drives read data from the internal BD bus out on to
  //  the external TBUS. Data is driven out from the rising edge of BCLK
  //  in the read cycle and remains driven past the end of the transfer
  //  until the rising edge of clock after the transfer has completed.
  //  A read or burst of reads will always be followed by a Turnaround
  //  vector, which prevents bus clash on the external TBUS.

  always @( posedge (BCLK) or negedge (BnRES) )
  begin
    if ((!BnRES))
      TicoutenInt <= 1'b1;
    else
      if ((CurrentVector == `STV_READVEC))
        TicoutenInt <= 1'b0;
      else
        TicoutenInt <= 1'b1;
  end
 
  //  TicoutLen changes after the falling edge of BCLK, as it
  //  follows the Vector state machine. TicoutLen can glitch
  //  after the falling egde of BCLK, but must be valid before
  //  the rising egde.

  always @(BnRES or CurrentVector)
  begin
    if ((!BnRES))
      TicoutLenInt = 1'b1;
    else if ((CurrentVector == `STV_READVEC))
      TicoutLenInt = 1'b0; // Open output latches on reads
    else
      TicoutLenInt = 1'b1;
  end
 
  //  The TicinEn signal is an active LOW signal that enables the tri-state
  //  bufffers within the external bus interface, so that they can drive
  //  from the external TBUS onto the internal BD data bus.
  //  This signal must go active in two cases, when an Address Vector is
  //  being applied and when a Write Vector is being applied.

  //  It is important that the data bus is not driven when the tic is 
  //  not the bus master, so the 'CurrentMasterState' is used to confirm
  //  that the tic currently owns the bus.
  //  For the Address Vector the data bus is driven throughout the 
  //  entire clock cycle. Data bus clash will not occur as every read 
  //  cycle is followed by a Turnaround vector. In the case when bus 
  //  master handover occurs data bus clash is avoided as the data bus 
  //  is only driven in the ACTIVE state.
  //  For Write vectors the tic must obey the AMBA specification and
  //  therefore the DatabusEnable signal from the AMBA interface section
  //  is used to generate TicinEn

  always @(BnRES or DatabusEnable or CurrentVector or 
           CurrentMasterState)
  begin
    if (!BnRES)
      TicinenInt = 1'b1;
    else if (CurrentMasterState == `STM_ACTIVE)
      if (CurrentVector == `STV_ADDRVEC)
        TicinenInt = 1'b0;
      else if (CurrentVector == `STV_WRITEVEC)
        TicinenInt = ~ DatabusEnable;
      else
        TicinenInt = 1'b1;
    else
      TicinenInt = 1'b1;
  end
 
// ---------------------------------------------------------------------
//  AMBA Bus Interface
//  The AMBA bus interface comprises the following sections:
//    Transfer Type (BTRAN) generation
//    Address and Control Tri-state buffers
//    Data tri-state buffer control
//    Main bus master state machine
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Transfer Type (BTRAN) generation
// ---------------------------------------------------------------------

  //  ticTran indicates the transfer type that the tic would
  //  perform if it was always granted the bus.

  //  Only indicate sequential when an incremented address is going to
  //  be used. The cases when an incremented address are used are:-
  //   o A read which is followed by either another read
  //   o A write which is followed by either another write

  //  Do not need to worry if the tic has lost mastership of the bus
  //  because the STM_HANDOVER state will ensure that the address is
  //  rebroadcast onto the bus before the transfer.

  always @(CurrentVector or NextVector or Incrm or Overflow or SeqOnly)
  begin
    if (NextVector == `STV_READVEC)
      if ((CurrentVector == `STV_READVEC && Incrm && !Overflow))
        ticTran = 2'b11;             // S-TRAN
      else
        ticTran = {1'b1 , SeqOnly};  // N-TRAN or S-TRAN
    else if ((NextVector == `STV_WRITEVEC))
      if (CurrentVector == `STV_WRITEVEC && Incrm && !Overflow)
        ticTran = 2'b11;             // S-TRAN
      else
        ticTran = {1'b1 , SeqOnly};  // N-TRAN or S-TRAN
    else  // NextVector = STV_TURNAROUND, STV_ADDRVEC, STV_START or 
          // STV_IDLE
      ticTran = 2'b00;               // A-TRAN
  end
 
  always @(CurrentMasterState or ticTran)
  begin
    if (CurrentMasterState == `STM_ACTIVE ||
         CurrentMasterState == `STM_BUSIDLE ||
         CurrentMasterState == `STM_HANDOVER)
      TRANint = ticTran;
    else
      TRANint = 2'b00;  //  A-TRAN
  end
 
  always @(AGNTtic or BCLK or TRANint)
  begin
    if (AGNTtic && BCLK)  //  test mode, drive signals
      BTRANInt = TRANint;
    else
      BTRANInt = 2'bzz;
  end
 
// ---------------------------------------------------------------------
//  Address and Control Tri-state buffers
// ---------------------------------------------------------------------

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if (!BnRES)
      DelayedGranted <= 1'b0;
    else
      DelayedGranted <= Granted;  //  to detect turnaround phase for BA
  end
 
  always @(Granted or DelayedGranted or Aint or SIZEint or PROTint or
           WRITEint or LOKint)
  begin
    if (Granted && DelayedGranted) // Test mode,drive signals avoiding 
                                   // first
    begin                          //  clock phase after AGNT
      BAInt = Aint;
      BSIZEInt = SIZEint;
      BPROTInt = PROTint;
      BWRITEInt = WRITEint;
      BLOKInt = LOKint;
    end
    else                           // Not test mode, tristate all
    begin
      BAInt = 32'hzzzz_zzzz;
      BSIZEInt = 2'bzz;
      BPROTInt = 2'bzz;
      BWRITEInt = 1'bz;
      BLOKInt = 1'bz;
    end
 
  end
 
// ---------------------------------------------------------------------
//  Data tri-state buffer control
// ---------------------------------------------------------------------

  //  Data bus is driven during the ACTIVE state of write vectors, 
  //  except for the first BCLK LOW phase of Non-sequential transfers.
  //  NtranStart will go HIGH for the first phase of Non-sequential 
  //  write transfers.

  always @(BCLK or LBWAIT or TRANint or WRITEint)
  begin
    if (BCLK)
      if (!LBWAIT && TRANint == 2'b10 && WRITEint)
        NtranStart = 1'b1;
      else
        NtranStart = 1'b0;
  end
 
  always @(BCLK or CurrentMasterState or CurrentVector or NtranStart)
  begin
    if ((CurrentMasterState == `STM_ACTIVE) &&
        (CurrentVector == `STV_WRITEVEC) && (BCLK || !NtranStart))
      DatabusEnable = 1'b1;
    else
      DatabusEnable = 1'b0;
  end
 
// ---------------------------------------------------------------------
//  Main bus master state machine
// ---------------------------------------------------------------------
// These three latches MUST be non-blocking to function correctly
  always @(BCLK or BWAIT or BLAST or BERROR)
  begin
    if (!BCLK)
    begin
      LBWAIT <= BWAIT;  //  latch slave responses
      LBLAST <= BLAST;
      LBERROR <= BERROR;
    end
  end
 
  //  The granted state machine defaults to not granted during reset, 
  //  but this output may be overridden in the case when the tic ends 
  //  up being the default bus master during reset.

  always @( posedge (BCLK) or negedge (BnRES) )
  begin
    if (!BnRES)          // Default to tic not Granted
      GrantedD2 <= 1'b0;
    else                 // Wait cycle no change
      GrantedD2 <= (((~ BWAIT) & AGNTtic) | (Granted & BWAIT));
  end

  //  This register has been added to remove the glitch on granted when
  //  BnRES goes high, which caused a glitch on all tristate outputs.

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      BnRESD2 <= 1'b0;
    else
      BnRESD2 <= BnRES;
  end
 
  //  Override during reset. (using extended reset signal)
  always @(BnRESD2 or GrantedD2 or AGNTtic)
  begin
    if (!BnRESD2 && AGNTtic)  //  system with tic default
      Granted = 1'b1;
    else
      Granted = GrantedD2;
  end
 
  //  Usually the bus master state machine would have two reset states,
  //  but the tic does not differentiate between STM_IDLE and 
  //  STM_BUSIDLE and driving of Address/Control is generated directly 
  //  from Granted, so a single reset state can be used.

  always @( negedge (BCLK) or negedge (BnRES) )
  begin
    if (!BnRES)
      CurrentMasterState <= `STM_IDLE;
    else
      CurrentMasterState <= NextMasterState;
  end
 
  always @(CurrentMasterState or Granted or RequestBus or LBWAIT or 
           LBLAST or LBERROR)
  begin
    case (CurrentMasterState)
      `STM_IDLE :
        if (Granted & (~ RequestBus))
          NextMasterState = `STM_BUSIDLE;
        else if (Granted & RequestBus)
          NextMasterState = `STM_HANDOVER;
        else if ((~ Granted) & RequestBus)
          NextMasterState = `STM_HOLD;
        else
          NextMasterState = `STM_IDLE; // not GRANTED and not RequestBus
 
      `STM_BUSIDLE :
        if ((~ Granted) & (~ RequestBus))
          NextMasterState = `STM_IDLE;
        else if (Granted & RequestBus)
          NextMasterState = `STM_ACTIVE;
        else if ((~ Granted) & RequestBus)
          NextMasterState = `STM_HOLD;
        else
          NextMasterState = `STM_BUSIDLE; // GRANTED and not RequestBus
 
      `STM_HOLD :
        if (Granted)
          NextMasterState = `STM_HANDOVER;
        else
          NextMasterState = `STM_HOLD;    // not GRANTED
 
      `STM_HANDOVER :
        if (Granted)
          NextMasterState = `STM_ACTIVE;
        else
          NextMasterState = `STM_HOLD;    // not GRANTED
 
      `STM_ACTIVE :
        if ((Granted & LBWAIT & LBLAST & LBERROR))
          NextMasterState = `STM_RETRACT;
        else if ((Granted & LBWAIT))
          NextMasterState = `STM_ACTIVE;
        else if ((Granted & RequestBus))
          NextMasterState = `STM_ACTIVE;
        else if ((Granted))
          NextMasterState = `STM_BUSIDLE;
        else if ((~ Granted) & RequestBus)
          NextMasterState = `STM_HOLD;
        else
          NextMasterState = `STM_IDLE;    // not GRANTED
 
      `STM_RETRACT :
        if (Granted)
          NextMasterState = `STM_HANDOVER;
        else
          NextMasterState = `STM_HOLD;    // not GRANTED
 
      default  :                      // others will be never reached
        NextMasterState = `STM_IDLE;
    endcase
  end
 
endmodule

// --============================== End ==============================--
