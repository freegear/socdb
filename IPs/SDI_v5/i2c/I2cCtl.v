
module I2cCtl (
  CLK, NRST, ClkEnab, MaClkEnab, SoftReset,
  IntSCL, Enab, IFLG, STA, STP, AAK, ReadData0, Ack,
  BusBusy, StartDet, StopDet, ArbLost,
  Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet,
  OpClkEnab, OpEnab, AssertDA, SendAck, SetIFLG, ClearSTA, ClearSTP,
  SRLoad, SampAddr, ArbDataEnab, ArbAckEnab,
  Status, OSCL, openab2
  );

  input        CLK, NRST, ClkEnab, MaClkEnab, SoftReset;
  input        IntSCL, Enab, IFLG, STA, STP, AAK, ReadData0, Ack;
  input        BusBusy, StartDet, StopDet, ArbLost;
  input        Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet;
  output       OpClkEnab, OpEnab, AssertDA, SendAck;
  output       SetIFLG, ClearSTA, ClearSTP, SRLoad, SampAddr;
  output       ArbDataEnab, ArbAckEnab, OSCL, openab2;
  output [7:3] Status;

  wire       OSCL;
  wire [7:3] Status;
  reg        OpEnab, CntrlEnab, ClearSTP, SetIFLG, AssertDA, OpClkEnab, ClearTFer;
  wire       OpClkData, Ready, SendAck, ArbDataEnab, ArbAckEnab, GoToIdle;
  wire       ClearSTA, ClearSTP_P, SRLoad, AssertDA_S, AssertDA_P, ReleaseDA;
  wire       StartComp, SendStart, SendStop, StartTFer, TxData, NoIFLG;
  wire       Step, TFerData, TFerAck, TFerComp, SampAddr, BusClkEnab, ErrCond1, ErrCond2;
  wire       ReleaseBus, MastMode, flagrs, enopenab2;

// State machine
SMCtl SMCtl (
  CLK, NRST, ClkEnab, SoftReset, Enab, IFLG, STA, STP, AAK, ReadData0, Ack,
  BusBusy, StartDet, StopDet, ArbLost,
  Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet,
  StartComp, TFerComp, ClearSTP, TFerData, TFerAck,
  SampAddr,
  Status, SRLoad, SendStart, StartTFer, SendStop, SendAck, TxData, NoIFLG,
  ArbDataEnab, ArbAckEnab, BusClkEnab, ErrCond1, ErrCond2, GoToIdle, ReleaseBus, MastMode,
  flagrs
  );

// Clock controller
ClkCtl ClkCtl (
  CLK, NRST, ClkEnab, MaClkEnab, CntrlEnab, SoftReset, MastMode,
  IFLG, IntSCL, BusClkEnab, ErrCond2, GoToIdle, flagrs, StartTFer,
  TxData, enopenab2, 
  OSCL, Step, OpClkData, Ready, openab2
  );

// Start controller
StartCtl StartCtl (
  CLK, NRST, MaClkEnab, SoftReset, SendStart, IFLG, Ready, IntSCL,
  ClearSTA, StartComp, AssertDA_S
  );

// Stop controller
StopCtl StopCtl (
  CLK, NRST, MaClkEnab, SoftReset, SendStop, IntSCL,
  ClearSTP_P, AssertDA_P, ReleaseDA
  );

// Byte Transfer controller
BTransCtl BTransCtl (
  CLK, NRST, ClkEnab, SoftReset, StartTFer, ClearTFer, Step, IFLG, IntSCL,
  TFerData, TFerAck, TFerComp, SampAddr, enopenab2
  );


// Clock enable control
always @(TFerData or TFerAck or ClearSTA)
   CntrlEnab = TFerData | TFerAck | ClearSTA;

// Output clock enable control
always @(OpClkData or ReleaseDA or ReleaseBus)
   OpClkEnab = OpClkData | ReleaseDA | ReleaseBus;

// Output enable control
always @(TFerData or TxData)
   OpEnab = TFerData & TxData;

// Abort transfer when start or stop detected
always @(StartDet or StopDet)
   ClearTFer = StartDet | StopDet;

// Clear STP control
always @(ClearSTP_P or GoToIdle)
  ClearSTP = ClearSTP_P | GoToIdle;

// IFLG control
// ErrCond1 now gated with ClkEnab to prevent IFLG reoccuring after being cleared
always @(ClearSTA or MaClkEnab or TFerComp or NoIFLG or ErrCond1 or ClkEnab)
  SetIFLG = (ClearSTA & MaClkEnab) | (TFerComp & ~NoIFLG) | (ErrCond1 & ClkEnab);


// Assert DA control
always @(AssertDA_S or AssertDA_P)
   AssertDA = AssertDA_S | AssertDA_P;


endmodule
