`timescale 1ns/10ps

module TOP (FREF, PADP, PADM, Reset_IN, END);

  input Reset_IN, FREF;
  output END;
  inout PADP, PADM;
    
  wire CLK, PADP, PADM, BISTOn;
  wire Reset, SuspendM, XcvrSelect, TermSelect, DataBus16_8, TxValid, TxValidH;
  wire [15:0] DataOut, DataIn;
  wire [1:0] LineState, OpMode;
  wire TxReady, RxActive, RxValid, RxValidH, RxError, BISTFail;
  
  PUSB20TM X1 (.CLK(CLK), .RESET(Reset), .SUSPENDM(SuspendM), .XCVRSELECT(XcvrSelect), .TERMSELECT(TermSelect), .DATABUS16_8(DataBus16_8), .OPMODE(OpMode), .DATAIN(DataIn), .TXVALID(TxValid), .TXVALIDH(TxValidH), .TXREADY(TxReady), .LINESTATE(LineState), .DATAOUT(DataOut), .RXACTIVE(RxActive), .RXVALID(RxValid), .RXVALIDH(RxValidH), .RXERROR(RxError), .PADP(PADP), .PADM(PADM), .BISTON(BISTOn), .BISTFAIL(BISTFail), .VRES(), .RPU(), .FREF(FREF), .FSEL(2'b10), .PLL480(PLL480), .CLKP());

  USB_DC X2 (.CLK(CLK), .Reset(Reset), .SuspendM(SuspendM), .XcvrSelect(XcvrSelect), .TermSelect(TermSelect), .DataBus16_8(DataBus16_8), .OpMode(OpMode), .DataIn(DataIn), .TxValid(TxValid), .TxValidH(TxValidH), .TxReady(TxReady), .BISTOn(BISTOn), .Reset_IN(Reset_IN), .END(END));
  
endmodule
