module I2cClkDiv (CLK, NRST, CCR, ClkEnab, MaClkEnab);

   input       CLK, NRST;
   input [6:0] CCR;
   output      ClkEnab, MaClkEnab;

   reg       ClkEnab, MaClkEnab;
   reg [6:0] Count1;
   reg [3:0] Count2;


// Stage 1 counter
always @(negedge NRST or posedge CLK)
  if (~NRST)
    Count1 <= 0;
  else
    Count1 <= Count1 + 1;

// Stage 1 output control
always @(Count1 or CCR)
  case (CCR[2:0])
    3'o0: ClkEnab = 1;
    3'o1: ClkEnab = Count1[0];
    3'o2: ClkEnab = Count1[1] & Count1[0];
    3'o3: ClkEnab = Count1[2] & Count1[1] & Count1[0];
    3'o4: ClkEnab = Count1[3] & Count1[2] & Count1[1] & Count1[0];
    3'o5: ClkEnab = Count1[4] & Count1[3] & Count1[2] & Count1[1] &
                    Count1[0];
    3'o6: ClkEnab = Count1[5] & Count1[4] & Count1[3] & Count1[2] &
                    Count1[1] & Count1[0];
    3'o7: ClkEnab = Count1[6] & Count1[5] & Count1[4] & Count1[3] &
                    Count1[2] & Count1[1] & Count1[0];
  endcase

// Stage 2 counter
always @(negedge NRST or posedge CLK)
  if (~NRST)
    Count2 <= 0;
  else if (ClkEnab & (Count2 == CCR[6:3]))
    Count2 <= 0;
  else if (ClkEnab)
    Count2 <= Count2 + 1;

// Stage 2 output control
always @(ClkEnab or Count2)
  MaClkEnab = ClkEnab & ~Count2[3] & ~Count2[2] & ~Count2[1] & ~Count2[0];

endmodule
