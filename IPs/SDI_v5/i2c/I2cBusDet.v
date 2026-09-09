// Monitors the bus for the following conditions
//    BusBusy     - Bus busy
//    StartDet    - Start condition
//    StopDet     - Stop condition
//    ArbLost     - Arbitration lost
//    Slave7Det   - Own slave address (7-bit address)
//    Slave101Det - Own slave address (first byte of 10-bit address)
//    Slave102Det - Own slave address (second byte of 10-bit address)
//    GEnCallDet  - General call address
//    ExtAddrDet  - The extended addressing code is in the upper 5-bits of the SR

module I2cBusDet (
  CLK, NRST, ClkEnab, IntSCL, IntSDA,
  ReadData, Ack, SlaveAddr, ExtSlaveAddr, GCEnab, Enab, AAK, SampAddr,
  ArbDataEnab, ArbAckEnab, SRClkEnab,
  BusBusy, StartDet, StopDet, ArbLost,
  Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet
  );

  input       CLK, NRST, ClkEnab;
  input       IntSCL, IntSDA, Ack, GCEnab, Enab, AAK, SampAddr;
  input       ArbDataEnab, ArbAckEnab, SRClkEnab;
  input [6:0] SlaveAddr;
  input [7:0] ExtSlaveAddr, ReadData;
  output      BusBusy, StartDet, StopDet, ArbLost;
  output      Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet;

  reg   BusBusy, StartDet, StopDet, ArbLost;
  reg   Slave7Det, Slave101Det, Slave102Det, GenCallDet;
  reg   IntSCLDel, IntSDADel, ExtAddrEnab, ExtAddrDet, NAck;


// Generate delayed versions of input signals
always @(negedge NRST or posedge CLK)
  if (~NRST) begin
    IntSCLDel <= 1;
    IntSDADel <= 1;
  end
  else if (ClkEnab) begin
    IntSCLDel <= IntSCL;
    IntSDADel <= IntSDA;
  end

// Start and Stop condition detectors
always @(negedge NRST or posedge CLK)
  if (~NRST) begin
    StartDet <= 0;
    StopDet <= 0;
  end
  else if (ClkEnab) begin
    StartDet <= IntSCL & IntSCLDel & ~IntSDA & IntSDADel;
    StopDet <= IntSCL & IntSCLDel & IntSDA &  ~IntSDADel;
  end

// Bus busy detector
always @(negedge NRST or posedge CLK)
  if (~NRST)
    BusBusy <= 0;
  else if (ClkEnab) begin
    if (~IntSCL | ~IntSDA)
      BusBusy <= 1;
    else if (StopDet)
      BusBusy <= 0;
  end

// Determine whether extended addressing is being used
always @(SlaveAddr)
  if (SlaveAddr[6:2] == 5'h1E)
    ExtAddrEnab = 1;
  else
    ExtAddrEnab = 0;

// Check for loss of arbitration
always @(negedge NRST or posedge CLK)
  if (~NRST)
    ArbLost <= 0;
  else if (ClkEnab) begin
    if (StartDet)
      ArbLost <= 0;
    else if (SRClkEnab & ~IntSDA &
             ((ArbDataEnab & ReadData[7]) | (ArbAckEnab & ~AAK)))
      ArbLost <= 1;
  end

// Determine whether extended addressing has been received
always @(ReadData)
  if (ReadData[7:3] == 5'h1E)
    ExtAddrDet = 1;
  else
    ExtAddrDet = 0;

// Generate NAck from Ack
always @(Ack)
  NAck = ~Ack;

// Address detectors
always @(negedge NRST or posedge CLK)
  if (~NRST) begin
    Slave7Det <= 0;
    Slave101Det <= 0;
    Slave102Det <= 0;
    GenCallDet <= 0;
  end
  else if (ClkEnab & SampAddr) begin
    Slave7Det <= (ReadData[6:0] == SlaveAddr[6:0]) &
                  Enab & AAK & ~ExtAddrEnab;
    Slave101Det <= (ReadData[6:0] == SlaveAddr[6:0]) &
                    Enab & AAK & ExtAddrEnab;
    Slave102Det <= ({ReadData[6:0],NAck} == ExtSlaveAddr) &
                    Enab & AAK & ExtAddrEnab;
    GenCallDet <= ({ReadData[6:0],NAck} == 8'h00) &
                   GCEnab & Enab & AAK;
  end

endmodule
