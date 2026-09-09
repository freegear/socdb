module StopCtl (
  CLK, NRST, ClkEnab, SoftReset, SendStop, IntSCL,
  ClearSTP, AssertDA_P, ReleaseDA
  );

  input     CLK, NRST, ClkEnab, SoftReset, SendStop, IntSCL;
  output    ClearSTP, AssertDA_P, ReleaseDA;

  reg       ClearSTP, AssertDA_P, ReleaseDA;
  reg [3:0] Count, NextCount;
  reg       intscldel; // delayed version of IntScl
  reg       kick_off_stop; // kick off the Stop sequence
  reg       finish_stop; // set counter to finish Stop sequence


// generate delayed version of IntScl
always @(negedge NRST or posedge CLK)
  if (~NRST)        intscldel <= 1;
  else if (ClkEnab) intscldel <= IntSCL;

//generate kick_off_stop
always @(IntSCL or intscldel) begin
  kick_off_stop <= ~IntSCL ; 
  finish_stop <= IntSCL & ~intscldel; 
end


// Counter
always @(negedge NRST or posedge CLK)
  if (~NRST)          Count <= 0;
  else if (SoftReset) Count <= 0;
  else if (ClkEnab)   Count <= NextCount;

// Counter control
always @(Count or SendStop or IntSCL or kick_off_stop or finish_stop)
  if (Count == 4'h0) NextCount = {3'b000,(SendStop & kick_off_stop)};
  else if (Count == 1) NextCount = {2'b00,finish_stop,~finish_stop};
  else if (Count == 4'hB) NextCount = 0;
  else NextCount = Count + 1;

// Output decodes
always @(Count) begin
  AssertDA_P = (Count > 0) && (Count < 4'h8);
  ReleaseDA = (Count == 4'h8);
  ClearSTP = (Count == 4'hB);
end

endmodule
