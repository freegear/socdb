module I2cIOShft (
  CLK, NRST, ClkEnab, SoftReset, SRClkEnab, OpClkEnab,
  IntSDA, WriteData, OpEnab, SRLoad, openab2,
  AAK, SendAck, AssertDA, ShiftReg, Ack, OSDA
  );

  input        CLK, NRST, ClkEnab, SoftReset, SRClkEnab, OpClkEnab, IntSDA;
  input  [7:0] WriteData;
  input        OpEnab, SRLoad, AAK, AssertDA, SendAck;
  input        openab2;
  output       Ack, OSDA;
  output [7:0] ShiftReg;

  reg       Ack, NAck, OSDA;
  reg [7:0] ShiftReg;


// Shift register
always @(negedge NRST or posedge CLK)
  if (~NRST) begin
    NAck <= 0;
    ShiftReg <= 0;
  end
  else if (ClkEnab & SRLoad) begin
    NAck <= 1;
    ShiftReg <= WriteData;
  end
  else if (ClkEnab & SRClkEnab) begin
    NAck <= IntSDA;
    ShiftReg <= {ShiftReg[6:0],NAck};
  end

// Output latch
always @(negedge NRST or posedge CLK)
  if (~NRST) OSDA <= 1;
  else if (SoftReset) OSDA <= 1;
  else if (ClkEnab & AssertDA) OSDA <= 0;
  else if (ClkEnab & OpClkEnab) begin
    if (OpEnab | openab2) OSDA <= ShiftReg[7];
    else if (SendAck) OSDA <= ~AAK;
    else OSDA <= 1;
  end

// Ack bit
always @(NAck) Ack = ~NAck;

endmodule
