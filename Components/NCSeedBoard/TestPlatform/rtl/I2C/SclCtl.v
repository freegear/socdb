module SclCtl (
  CLK, NRST, ClkEnab, MaClkEnab, CntrlEnab, SoftReset, MastMode,
  IFLG, IntSCL, BusClkEnab, ErrCond, GoToIdle, flagrs,
  StartTFer, TxData, enopenab2,
  OSCL, Step, OpClkData, Ready, openab2
  );

  input     CLK, NRST, ClkEnab, MaClkEnab, CntrlEnab, SoftReset, MastMode;
  input     IFLG, IntSCL, BusClkEnab, ErrCond, GoToIdle;
  input     flagrs, StartTFer, TxData, enopenab2;
  output    OSCL, OpClkData, Step, Ready, openab2;

  reg       OSCL, OpClkData, Step, AdvCount, Ready, ClkEnabLatch;
  reg       BusClkEnab_d;
  reg [4:0] Count;
  reg       Enab;
  reg       intscldel;
  reg       openab2;

always @(MastMode or ClkEnab or MaClkEnab) Enab = (MastMode & MaClkEnab) | (~MastMode & ClkEnab);

always @(negedge NRST or posedge CLK)
  if (~NRST)                Count <= 0;
  else if (SoftReset)       Count <= 0;
  else if (flagrs)          Count <= 5'b01111; 
  else if (Enab & AdvCount) Count <= {Count[3:0],~Count[4]};

always @(negedge NRST or posedge CLK) 
  if (~NRST)     intscldel <= 1;
  else if (Enab) intscldel <= IntSCL;

always @(intscldel or Count or StartTFer or enopenab2 or TxData) begin
  openab2 <= (intscldel & Count == 5'b11110 & StartTFer & 
              TxData & enopenab2);
end

always @(Count or CntrlEnab or IFLG or ErrCond or IntSCL or GoToIdle)
  if (Count[0] & ~Count[1])      AdvCount = CntrlEnab & IntSCL;
  else if (Count[3] & ~Count[4]) AdvCount = (~IFLG & ~ErrCond) | GoToIdle;
  else if (Count[1] & ~Count[0]) AdvCount = ~IntSCL | GoToIdle;
  else                           AdvCount = 1;

always @(Count or Enab) Step = ~Count[3] & Count[2] & Enab;

always @(Count or IntSCL or Enab) OpClkData = Count[1] & ~Count[0] & ~IntSCL & Enab;

always @(Count or Enab) Ready = ~Count[1] & Count[0] & Enab;


always @(BusClkEnab or IntSCL or MastMode) begin
  if(~MastMode) BusClkEnab_d <= BusClkEnab & ~IntSCL; 
  else          BusClkEnab_d <= BusClkEnab ; 
end

always @(negedge NRST or posedge CLK)
  if (~NRST)     ClkEnabLatch <= 0;
  else if (Enab) ClkEnabLatch <= BusClkEnab_d | (ClkEnabLatch & Count[3]);

// Output bus clock
always @(negedge NRST or posedge CLK)
  if (~NRST)     OSCL <= 1;
  else if (Enab) OSCL <= ~(Count[3] & ClkEnabLatch);

endmodule
