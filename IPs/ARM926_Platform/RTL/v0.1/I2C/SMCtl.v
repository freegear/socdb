// States
`define C_IDLE         5'h00
`define C_RECV_ADDR    5'h01
`define C_ADDR_RECD    5'h02
`define C_RECV_XADD    5'h03
`define C_S_SEND_DATA  5'h04
`define C_S_DATA_SENT  5'h05
`define C_S_LAST_SENT  5'h06
`define C_S_RECV_DATA  5'h07
`define C_S_DATA_RECD  5'h08
`define C_S_RECV_RS    5'h09
`define C_S_RECV_P     5'h0A
`define C_GENC_RECD    5'h0B
`define C_GC_RECV_DATA 5'h0C
`define C_GC_DATA_RECD 5'h0D
`define C_ARB_LOST     5'h0E
`define C_BUS_ERR      5'h0F
`define C_SEND_S       5'h10
`define C_SEND_RS      5'h11
`define C_SEND_ADDR    5'h12
`define C_ADDR_SENT    5'h13
`define C_SEND_XADD    5'h14
`define C_XADD_SENT    5'h15
`define C_M_SEND_DATA  5'h16
`define C_M_DATA_SENT  5'h17
`define C_M_RECV_DATA  5'h18
`define C_M_DATA_RECD  5'h19
`define C_SEND_P       5'h1A
`define C_P_SR         5'h1B // new state - wait for stop or SR from master


module SMCtl (
  CLK, NRST, ClkEnab, SoftReset, Enab, IFLG, STA, STP, AAK, ReadData0, Ack,
  BusBusy, StartDet, StopDet, ArbLost,
  Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet,
  StartComp, TFerComp, ClearSTP, TFerData, TFerAck,
  SampAddr,
  Status, SRLoad, SendStart, StartTFer, SendStop, SendAck, TxData, NoIFLG,
  ArbDataEnab, ArbAckEnab, BusClkEnab, ErrCond1, ErrCond2, GoToIdle, ReleaseBus, MastMode,
  flagrs
  );

  input        CLK, NRST, ClkEnab, SoftReset, Enab, IFLG, STA, STP, AAK, ReadData0, Ack;
  input        BusBusy,  StartDet, StopDet, ArbLost;
  input        Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet;
  input        StartComp, TFerComp, ClearSTP, TFerData, TFerAck;
  input        SampAddr;
  output [7:3] Status;
  output       SRLoad, SendStart, StartTFer, SendStop, SendAck, TxData, NoIFLG;
  output       ArbDataEnab, ArbAckEnab, BusClkEnab, ErrCond1, ErrCond2,  GoToIdle;
  output       ReleaseBus, MastMode, flagrs;

  reg [4:0] State, NextState;
  reg [7:3] Status;
  reg       SRLoad, SendStart, StartTFer, SendStop, SendAck, ErrCond1, ErrCond2, GoToIdle;
  reg       TxData, DataDir, NoIFLG, ArbDataEnab, ArbAckEnab, BusClkEnab;
  reg       ReleaseBus, MastMode, flagrs;

  reg       p_add; // flag to show if slave device previously addressed 
  reg       Bit8; // R/W bit - used in 10 bit address mode


// Next state
always @(State or IFLG or STA or STP or AAK or StartComp or TFerComp or ClearSTP or
  BusBusy or StartDet or StopDet or Slave7Det or Slave101Det or Slave102Det or
  GenCallDet or ExtAddrDet or ArbLost or DataDir or Enab or Ack or p_add or Bit8 or TFerData)
  case (State)
    `C_IDLE: begin
       if (StartDet & Enab)
         NextState = `C_RECV_ADDR;
       else if (STA & ~BusBusy & Enab)
         NextState = `C_SEND_S;
       else
         NextState = `C_IDLE;
       end
    `C_RECV_ADDR: begin
       if (StartDet | StopDet)
         NextState = `C_BUS_ERR;
       else if (TFerComp & Slave101Det & ~Bit8 ) // R/W bit must be 0 for 10b address
         NextState = `C_RECV_XADD;
       else if(TFerComp & Slave101Det & Bit8 & p_add) // unless previously addressed!!
         NextState = `C_ADDR_RECD; // slave transmitter mode
       else if (TFerComp & Slave7Det)
         NextState = `C_ADDR_RECD;
       else if (TFerComp & GenCallDet)
         NextState = `C_GENC_RECD;
       else if (TFerComp & ArbLost)
         NextState = `C_ARB_LOST;
       else if (TFerComp)
         NextState = `C_IDLE;
       else
         NextState = `C_RECV_ADDR;
       end
    `C_RECV_XADD: begin
       if (StartDet | StopDet)
         NextState = `C_BUS_ERR;
       else if (TFerComp & Slave102Det)
         NextState = `C_ADDR_RECD;
       else if (TFerComp & ArbLost)
         NextState = `C_ARB_LOST;
       else if (TFerComp)
         NextState = `C_IDLE;
       else
         NextState = `C_RECV_XADD;
       end
    `C_ADDR_RECD: begin
       if (~IFLG)
       begin
         if (DataDir)
           NextState = `C_S_RECV_DATA;
         else
           NextState = `C_S_SEND_DATA;
       end
       else
         NextState = `C_ADDR_RECD;
       end
    `C_S_SEND_DATA: begin
        if (StartDet | StopDet)
         NextState = `C_BUS_ERR;
        else if (TFerComp & AAK)
          NextState = `C_S_DATA_SENT;
        else if (TFerComp)
          NextState = `C_S_LAST_SENT;
        else
          NextState = `C_S_SEND_DATA;
        end
    `C_S_DATA_SENT: begin
       if (~IFLG)
       begin
         if (Ack)
           NextState = `C_S_SEND_DATA;
         else
           NextState = `C_P_SR; // wait for SR or Stop (P)
       end
       else
         NextState = `C_S_DATA_SENT;
       end
    `C_S_LAST_SENT: begin
       if (~IFLG)
         NextState = `C_IDLE;
       else
         NextState = `C_S_LAST_SENT;
       end
    `C_P_SR : begin
       if (StartDet)
         NextState = `C_S_RECV_RS;
       else if (StopDet | STP)           
         NextState = `C_S_RECV_P; 
       else
         NextState = `C_P_SR; // stay here unless RS or Stop(P) received!
       end
    `C_S_RECV_DATA: begin
       if (StartDet)
         NextState = `C_S_RECV_RS;
       else if (StopDet | STP)           
         NextState = `C_S_RECV_P; 
       else if (TFerComp)
         NextState = `C_S_DATA_RECD;
       else
         NextState = `C_S_RECV_DATA;
       end
    `C_S_DATA_RECD: begin
       if (~IFLG)
       begin
         if (Ack)
           NextState = `C_S_RECV_DATA;
         else
           NextState = `C_IDLE;
       end
       else
         NextState = `C_S_DATA_RECD;
       end
    `C_S_RECV_RS: begin
       if (~IFLG)
         NextState = `C_RECV_ADDR;
       else
         NextState = `C_S_RECV_RS;
       end
    `C_S_RECV_P: begin
       if (~IFLG)
         NextState = `C_IDLE;
       else
         NextState = `C_S_RECV_P;
       end
    `C_GENC_RECD: begin
       if (~IFLG)
         NextState = `C_GC_RECV_DATA;
       else
         NextState = `C_GENC_RECD;
       end
    `C_GC_RECV_DATA: begin
       if (StartDet)
         NextState = `C_S_RECV_RS;
       else if (StopDet)
         NextState = `C_S_RECV_P;
       else if (TFerComp)
         NextState = `C_GC_DATA_RECD;
       else
         NextState = `C_GC_RECV_DATA;
       end
    `C_GC_DATA_RECD: begin
       if (~IFLG)
       begin
         if (Ack)
           NextState = `C_GC_RECV_DATA;
         else
           NextState = `C_IDLE;
       end
       else
         NextState = `C_GC_DATA_RECD;
       end
    `C_SEND_S: begin
       if (StartComp)
         NextState = `C_SEND_ADDR;
       else
         NextState = `C_SEND_S;
       end
    `C_SEND_RS: begin
       if (StartComp)
         NextState = `C_SEND_ADDR;
       else
         NextState = `C_SEND_RS;
       end
    `C_SEND_ADDR: begin
       if ((StartDet & TFerData) | StopDet) // ensure Master Start is not bus error!
         NextState = `C_BUS_ERR;
       else if (ArbLost)
         NextState = `C_RECV_ADDR;
       else if (TFerComp)
         NextState = `C_ADDR_SENT;
       else
         NextState = `C_SEND_ADDR;
       end
    `C_ADDR_SENT: begin
       if (~IFLG)
       begin
         if (STP)
           NextState = `C_SEND_P;
         else if (STA)
           NextState = `C_SEND_RS;
         else if (ExtAddrDet & DataDir)
           NextState = `C_SEND_XADD;
         else if (DataDir)
           NextState = `C_M_SEND_DATA;
         else
           NextState = `C_M_RECV_DATA;
       end
       else
         NextState = `C_ADDR_SENT;
       end
    `C_SEND_XADD: begin
       if (StartDet | StopDet)
         NextState = `C_BUS_ERR;
       else if (ArbLost)
         NextState = `C_RECV_XADD;
       else if (TFerComp)
         NextState = `C_XADD_SENT;
       else
         NextState = `C_SEND_XADD;
       end
    `C_XADD_SENT: begin
       if (~IFLG)
       begin
         if (STP)
           NextState = `C_SEND_P;
         else if (STA)
           NextState = `C_SEND_RS;
         else if (DataDir)
           NextState = `C_M_SEND_DATA;
         else
           NextState = `C_M_RECV_DATA;
       end
       else
         NextState = `C_XADD_SENT;
       end
    `C_M_SEND_DATA: begin
       if (StartDet | StopDet)
         NextState = `C_BUS_ERR;
       else if (ArbLost)
         NextState = `C_ARB_LOST;
       else if (TFerComp)
         NextState = `C_M_DATA_SENT;
       else
         NextState = `C_M_SEND_DATA;
       end
    `C_M_DATA_SENT: begin
       if (~IFLG)
       begin
         if (STP)
           NextState = `C_SEND_P;
         else if (STA)
           NextState = `C_SEND_RS;
         else
           NextState = `C_M_SEND_DATA;
       end
       else
         NextState = `C_M_DATA_SENT;
       end
    `C_M_RECV_DATA: begin
       if (StartDet | StopDet)
         NextState = `C_BUS_ERR;
       else if (ArbLost)
         NextState = `C_ARB_LOST;
       else if (TFerComp)
         NextState = `C_M_DATA_RECD;
       else
         NextState = `C_M_RECV_DATA;
       end
    `C_M_DATA_RECD: begin
       if (~IFLG)
       begin
         if (STP)
           NextState = `C_SEND_P;
         else if (STA)
           NextState = `C_SEND_RS;
         else
           NextState = `C_M_RECV_DATA;
       end
       else
         NextState = `C_M_DATA_RECD;
       end
    `C_SEND_P: begin
       if (ClearSTP)
         NextState = `C_IDLE;
       else
         NextState = `C_SEND_P;
       end
    `C_ARB_LOST: begin
       if (~IFLG)
         NextState = `C_IDLE;
       else
         NextState = `C_ARB_LOST;
       end
    `C_BUS_ERR: begin
       if (~IFLG & STP)
         NextState = `C_IDLE;
       else
         NextState = `C_BUS_ERR;
       end
    default: NextState = `C_IDLE;
  endcase

// State register
always @(negedge NRST or posedge CLK)
  if (~NRST)          State <= 0;
  else if (SoftReset) State <= `C_IDLE;
  else if (ClkEnab)   State <= NextState;

// Decode send stop condition
always @(State) begin
  SendStart = (State == `C_SEND_S) | (State == `C_SEND_RS);
  SendStop = (State == `C_SEND_P);
end

// Decode load SR condition
always @(State or StartComp or IFLG)
  SRLoad = StartComp |
      (((State == `C_ADDR_SENT) |
        (State == `C_XADD_SENT) |
        (State == `C_ADDR_RECD) |
        (State == `C_M_DATA_SENT) |
        (State == `C_S_DATA_SENT)) & ~IFLG);

// Decode start data transfer
always @(State)
  if ((State == `C_SEND_ADDR) |
       (State == `C_SEND_XADD) |
       (State == `C_RECV_ADDR) |
       (State == `C_RECV_XADD) |
       (State == `C_S_SEND_DATA) |
       (State == `C_S_RECV_DATA) |
       (State == `C_GC_RECV_DATA) |
       (State == `C_M_SEND_DATA) |
       (State == `C_P_SR) |
       (State == `C_M_RECV_DATA))
    StartTFer = 1;
  else
    StartTFer = 0;

// Decode transmit data
always @(State)
  if ((State == `C_SEND_ADDR) |
       (State == `C_SEND_XADD) |
       (State == `C_S_SEND_DATA) |
       (State == `C_M_SEND_DATA))
    TxData = 1;
  else
    TxData = 0;

// Enable arbitration
always @(State or TFerData or TFerAck)
begin
  ArbDataEnab = ((State == `C_SEND_ADDR) |
                 (State == `C_SEND_XADD) |
                 (State == `C_M_SEND_DATA)) & TFerData;
  ArbAckEnab = (State == `C_M_RECV_DATA) & TFerAck;
end

always @(negedge NRST or posedge CLK) begin
  if(~NRST)         Bit8 <= 0;
  else if(SampAddr) Bit8 <= ~Ack; // store sampled value of Bit 8
end

always @(State or TFerAck or Slave7Det or Slave102Det or GenCallDet or Slave101Det or Bit8 or
         p_add)
  if (((State == `C_M_RECV_DATA) |
       (State == `C_S_RECV_DATA) | (State == `C_GC_RECV_DATA) |
      ((State == `C_RECV_ADDR) & (Slave7Det | GenCallDet)) |
      ((State == `C_RECV_ADDR) & (Slave101Det & ~Bit8)) |
      ((State == `C_RECV_ADDR) & (Slave101Det & Bit8 & p_add)) |
      ((State == `C_RECV_XADD) & Slave102Det)) & TFerAck)
    SendAck = 1;
  else
    SendAck = 0;

always @(State or Slave7Det or Slave101Det or Slave102Det or GenCallDet or
         p_add or Bit8)
  NoIFLG = ((State == `C_RECV_ADDR) & (~(Slave7Det | (Slave101Det & p_add & Bit8) | GenCallDet))) |
           ((State == `C_RECV_XADD) & ~Slave102Det) |
           (State == `C_P_SR) |
           (State == `C_IDLE);

always @(State)
  BusClkEnab = (State[4] & State != `C_P_SR) |
         (State == `C_ADDR_RECD) |
         (State == `C_GENC_RECD) |
         (State == `C_S_DATA_RECD) |
         (State == `C_S_DATA_SENT) |
         (State == `C_GC_DATA_RECD) |
         (State == `C_S_LAST_SENT) |
         (State == `C_S_RECV_RS);

always @(NextState)
  ErrCond1 = (NextState == `C_BUS_ERR) | (NextState == `C_ARB_LOST) |
      (NextState == `C_S_RECV_RS) | (NextState == `C_S_RECV_P);


always @(NextState)
  ErrCond2 = (NextState == `C_BUS_ERR) | (NextState == `C_ARB_LOST) |
       (NextState == `C_S_RECV_P);

always @(NextState)
  flagrs = (NextState == `C_S_RECV_RS);

always @(posedge CLK or negedge NRST)
  if (~NRST)
    ReleaseBus <= 0;
  else if (ClkEnab)
    ReleaseBus <= (NextState == `C_BUS_ERR) | (NextState == `C_ARB_LOST);

always @(State)
  GoToIdle = (State == `C_IDLE) | (State == `C_S_RECV_P) |
             (State == `C_BUS_ERR) | (State == `C_ARB_LOST);

always @(posedge CLK or negedge NRST)
  if (~NRST)
    DataDir <= 0;
  else if (((State == `C_SEND_ADDR) | (State == `C_RECV_ADDR)) & TFerComp)
    DataDir <= ~ReadData0;

always @(State)
  MastMode = (State == `C_SEND_S) | (State == `C_SEND_RS) |
             (State == `C_SEND_ADDR) | (State == `C_SEND_XADD) |
             (State == `C_ADDR_SENT) | (State == `C_XADD_SENT) |
             (State == `C_M_SEND_DATA) | (State == `C_M_RECV_DATA) |
             (State == `C_M_DATA_SENT) | (State == `C_M_DATA_RECD) |
             (State == `C_SEND_P);

always @(State or IFLG or ArbLost or DataDir or Ack or AAK)
begin
  Status[7] = ((State == `C_S_DATA_RECD) | (State == `C_S_DATA_SENT) |
               (State == `C_S_RECV_RS) | (State == `C_S_RECV_P) |
               ((State == `C_ADDR_RECD) & ~DataDir) |
               (State == `C_GC_DATA_RECD) |
               (State == `C_S_DATA_SENT) | (State == `C_S_LAST_SENT) |
               (State == `C_XADD_SENT) | ~IFLG);
  Status[6] = (((State == `C_ADDR_SENT) & ~DataDir) |
               (State == `C_XADD_SENT) | (State == `C_M_DATA_RECD) |
               ((State == `C_ADDR_RECD) & DataDir) |
               (State == `C_GENC_RECD) | (State == `C_XADD_SENT) |
               ((State == `C_S_DATA_SENT) & ~Ack) |
               (State == `C_S_LAST_SENT) | ~IFLG);
  Status[5] = (((State == `C_ADDR_SENT) & DataDir & ~Ack) |
               (State == `C_M_DATA_SENT) | (State == `C_ARB_LOST) |
               (State == `C_ADDR_RECD) | ((State == `C_XADD_SENT) & ~DataDir) |
               ((State == `C_ADDR_RECD) & ArbLost) |
               (State == `C_GENC_RECD) | ((State == `C_S_DATA_SENT) & Ack) |
               (State == `C_S_RECV_RS) | (State == `C_S_RECV_P) | ~ IFLG);
  Status[4] = (((State == `C_ADDR_SENT) & DataDir & Ack) | (State == `C_SEND_RS) |
               ((State == `C_M_DATA_SENT) & ~Ack) | (State == `C_ARB_LOST) |
               (State == `C_M_DATA_RECD) | (State == `C_GENC_RECD) |
               (State == `C_GC_DATA_RECD) | ((State == `C_S_DATA_SENT) & Ack) |
               ((State == `C_ADDR_RECD) & ArbLost & ~DataDir) |
               ((State == `C_S_DATA_SENT) & Ack) |
               ((State == `C_XADD_SENT) & DataDir) | ~IFLG);
  Status[3] = ((State == `C_SEND_S) | (State == `C_ARB_LOST) |
               ((State == `C_ADDR_SENT) & DataDir & Ack) |
               ((State == `C_M_DATA_SENT) & Ack) |
               ((State == `C_ADDR_SENT) & ~DataDir & ~Ack) |
               ((State == `C_M_DATA_RECD) & ~AAK) |
               ((State == `C_ADDR_RECD) & ArbLost & DataDir) |
               ((State == `C_GENC_RECD) & ArbLost) |
               ((State == `C_S_DATA_RECD) & ~AAK) |
               ((State == `C_GC_DATA_RECD) & ~AAK) |
               ((State == `C_ADDR_RECD) & ~ArbLost & ~DataDir) |
               ((State == `C_S_DATA_SENT) & Ack) |
               ((State == `C_S_LAST_SENT) & Ack) |
               ((State == `C_XADD_SENT) & ~Ack) | ~IFLG);
end

always @(negedge NRST or posedge CLK) begin
  if(~NRST) p_add <= 0;
  else begin
    if((State == `C_RECV_XADD) & TFerComp & Slave102Det) p_add <= 1;
    else if(State == `C_IDLE) p_add <= 0;
    else p_add <= p_add; //no change
  end
end




endmodule
