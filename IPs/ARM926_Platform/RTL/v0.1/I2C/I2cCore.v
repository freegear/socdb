
module I2cCore (
           CLK, NRST, 
	       ISCL, ISDA,
  
           CCR, SlaveAddr, ExtSlaveAddr, WriteData,
           Enab, GCEnab, STA, STP, IFLG, AAK, 
           SoftReset,

           Status, ReadData,
           SetIFLG, ClearSTA, ClearSTP,
           OSCL, OSDA
           );


  input       CLK, NRST, ISCL, ISDA;
  input       Enab, GCEnab, STA, STP, IFLG, AAK, SoftReset;
  input [6:0] CCR;
  input [6:0] SlaveAddr;
  input [7:0] ExtSlaveAddr;
  input [7:0] WriteData;

  output       SetIFLG, ClearSTA, ClearSTP;
  output [7:3] Status;
  output [7:0] ReadData;
  output       OSCL, OSDA;

  wire       OSCL, OSDA;
  wire       ClkEnab, MaClkEnab;
  wire       IntSCL, IntSDA, SRClkEnab;
  wire       OpEnab, SRLoad, OpClkEnab, AssertDA, SendAck, Ack;
  wire       SampAddr, ArbDataEnab, ArbAckEnab;
  wire       BusBusy, StartDet, StopDet, ArbLost;
  wire       Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet;
  wire       openab2;
  wire [7:0] ReadData;

// Main control
I2cCtl I2cCtl (
  CLK, NRST, ClkEnab, MaClkEnab, SoftReset,
  IntSCL, Enab, IFLG, STA, STP, AAK, ReadData[0], Ack,
  BusBusy, StartDet, StopDet, ArbLost,
  Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet,
  OpClkEnab, OpEnab, AssertDA, SendAck, SetIFLG, ClearSTA, ClearSTP,
  SRLoad, SampAddr, ArbDataEnab, ArbAckEnab, Status, OSCL, openab2
  );

// I/O shift register
I2cIOShft I2cIOShft (
  CLK, NRST, ClkEnab, SoftReset, SRClkEnab, OpClkEnab,
  IntSDA, WriteData, OpEnab, SRLoad, openab2,
  AAK, SendAck, AssertDA, ReadData, Ack, OSDA
  );

// Bus activity detector
I2cBusDet I2cBusDet (
  CLK, NRST, ClkEnab, IntSCL, IntSDA,
  ReadData, Ack, SlaveAddr, ExtSlaveAddr, GCEnab, Enab, AAK, SampAddr,
  ArbDataEnab, ArbAckEnab, SRClkEnab,
  BusBusy, StartDet, StopDet, ArbLost,
  Slave7Det, Slave101Det, Slave102Det, GenCallDet, ExtAddrDet
  );

// Bus input filter and synchronization
I2cBusFlt I2cBusFlt (CLK, NRST, ClkEnab, ISCL, ISDA, IntSCL, IntSDA, SRClkEnab);

// Clock Divider
I2cClkDiv I2cClkDiv (CLK, NRST, CCR, ClkEnab, MaClkEnab);

endmodule
