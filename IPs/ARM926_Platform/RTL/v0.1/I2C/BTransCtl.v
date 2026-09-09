module BTransCtl (
  CLK, NRST, ClkEnab, SoftReset, StartTFer, ClearTFer, Step, IFLG, IntSCL,
  TFerData, TFerAck, TFerComp, SampAddr , enopenab2
  );

  input   CLK, NRST, ClkEnab, SoftReset;
  input   StartTFer, ClearTFer, Step, IFLG, IntSCL;
  output  TFerData, TFerAck, TFerComp, SampAddr;
  output  enopenab2; 

  reg       TFerData, TFerAck, TFerComp, SampAddr;
  reg [3:0] Count, NextCount;
  reg     enopenab2; 

//generate enopenab2
always @(Count) enopenab2 <= (Count == 0); 

// Counter
always @(negedge NRST or posedge CLK)
  if (~NRST)                    Count <= 0;
  else if (SoftReset)           Count <= 0;
  else if (ClkEnab & ClearTFer) Count <= 0;
  else if (ClkEnab)             Count <= NextCount;

// Counter control
always @(Count or StartTFer or Step or IFLG or IntSCL)
  case (Count)
    4'h0:
      if (StartTFer & ~IntSCL) NextCount = 4'h1;
      else                     NextCount = 4'h0;
    4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8:
      if (Step) NextCount = Count + 1;
      else      NextCount = Count;
    4'h9:
      if (Step) NextCount = 4'hA;
      else      NextCount = 4'h9;
    default:
      if (~IFLG) NextCount = 4'h0;
      else       NextCount = 4'hA;
  endcase

// Output decodes
always @(Count or Step) begin
  if ((Count > 0) & (Count < 9)) TFerData = 1;
  else                           TFerData = 0;

  if (Count == 9)                TFerAck = 1;
  else                           TFerAck = 0;

  if ((Count == 9) & (Step == 1)) TFerComp = 1;
  else                            TFerComp = 0;

  if ((Count == 8) & (Step == 1)) SampAddr = 1;
  else                            SampAddr = 0;
end

endmodule
