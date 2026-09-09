`timescale 1ns/1ps

module USB_DC (CLK, Reset, SuspendM, XcvrSelect, TermSelect, DataBus16_8, OpMode, DataIn, TxValid, TxValidH, TxReady, BISTOn, Reset_IN, END);
  input CLK, Reset_IN, TxReady;
  output Reset, SuspendM, XcvrSelect, TermSelect, DataBus16_8, TxValid, TxValidH, BISTOn;
  output [1:0] OpMode;
  output [15:0] DataIn;
  output END;
  
  reg Reset, SuspendM, XcvrSelect, TermSelect, DataBus16_8, TxValid, TxValidH, BISTOn;
  reg [1:0] OpMode;
  reg [15:0] DataIn;
  reg [3:0] CNT;
  reg END;
 
  always @(posedge CLK or posedge Reset_IN) begin
    if (Reset_IN) begin
      Reset <= 1'b1;
      SuspendM <= 1'b1;
      XcvrSelect <= 1'b0;
      TermSelect <= 1'b0;
      DataBus16_8 <= 1'b1;
      TxValid <= 1'b0;
      TxValidH <= 1'b0;
      BISTOn <= 1'b1;
      OpMode <= 2'b00;
      DataIn <= 16'b0000000000000000;
      CNT <= 4'b0000;
      END <= 1'b0;
    end
    else begin
      Reset <= 1'b0;
      if (CNT == 4'b1111 && !END) begin
        TxValid <= 1'b1;
	TxValidH <= 1'b1;
	if (TxReady) begin
	  DataIn <= DataIn + 16'b0000000000000001;
	  if (DataIn == 16'b0000000000001000) begin
	    TxValid <= 1'b0;
	    TxValidH <= 1'b0;
	    END <= 1'b1;
	  end
	end
      end
      else
        CNT <= CNT + 4'b0001;
    end
  end  
endmodule

