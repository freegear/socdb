module StartCtl (
  CLK, NRST, ClkEnab, SoftReset, SendStart, IFLG, Ready, IntSCL,
  ClearSTA, StartComp, AssertDA_S
  );

  input     CLK, NRST, ClkEnab, SoftReset, SendStart, IFLG, Ready, IntSCL;
  output    StartComp, ClearSTA, AssertDA_S;

  reg       StartComp, ClearSTA, AssertDA_S, AdvCount;
  reg [3:0] Count;
  reg	    restart; // restart counter


// counter for Start or Repeated start condition
always @(negedge NRST or posedge CLK)
 if (~NRST)                   Count <= 0;
 else if (SoftReset)          Count <= 0;
 else if(restart)             Count <= 0;
 else if (ClkEnab & AdvCount) Count <= Count + 1; // increment counter

always @(Count or SendStart or IFLG or Ready or IntSCL)
  if (~Count[3] & ~Count[2] & ~Count[1] & ~Count[0]) // count = 0
    AdvCount = SendStart & Ready & IntSCL;
  else if ((~Count[3] & Count[2] & Count[1] & ~Count[0]) |
           (~Count[3] & Count[2] & Count[1] & Count[0]))
    AdvCount = ~IFLG;
  else
    AdvCount = 1;

//generate restart
always @(Count) begin
  if(Count == 4'b1000) restart <= 1;
  else                 restart <= 0;

end

// Output decodes
always @(Count or IFLG) begin
  AssertDA_S = (~Count[3] & Count[2] & ~Count[1] & ~Count[0]) |
               (~Count[3] & Count[2] & ~Count[1] & Count[0]) |
               (~Count[3] & Count[2] & Count[1] & ~Count[0]) |
               (~Count[3] & Count[2] & Count[1] & Count[0]);
  ClearSTA = (~Count[3] & Count[2] & ~Count[1] & Count[0]);
  StartComp = ((~Count[3] & Count[2] & Count[1] & ~Count[0]) |
	      (~Count[3] & Count[2] & Count[1] & Count[0])) & ~IFLG;
end

endmodule
