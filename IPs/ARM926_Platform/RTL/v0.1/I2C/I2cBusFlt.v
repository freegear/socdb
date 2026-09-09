module I2cBusFlt (CLK, NRST, ClkEnab, ISCL, ISDA, IntSCL, IntSDA, SRClkEnab);

  input        CLK, NRST, ClkEnab, ISCL, ISDA;
  output       IntSCL, IntSDA, SRClkEnab;

  reg   IntSCL, IntSDA;
  reg   IntSCLDel, SRClkEnab;


// Latch bus inputs
always @(negedge NRST or posedge CLK)
  if (~NRST) begin
    IntSCL <= 1;
    IntSDA <= 1;
    IntSCLDel <= 1;
  end
  else if (ClkEnab) begin
    IntSCL <= ISCL;
    IntSDA <= ISDA;
    IntSCLDel <= IntSCL;
  end

// Enable input shift register clock on rising edge of IntSCL

always @(IntSCL or IntSCLDel)
  SRClkEnab = IntSCL & ~IntSCLDel;

endmodule
