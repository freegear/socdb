`timescale 1ns/10ps

module test_USB;
  reg Reset_IN, FREF;
  
  TOP UTOP ( .FREF(FREF), .PADP(PADP), .PADM(PADM), .Reset_IN(Reset_IN), .END(END) );

  initial begin
    $sdf_annotate ("../2_syn/TOP.sdf", UTOP);
    $dumpfile ("test_USB.vcd");
    $dumpvars (0,Reset_IN);
    $dumpvars (0,FREF);
    $dumpvars (0,PADP);
    $dumpvars (0,PADM);
    $dumpvars (0,UTOP.X1.CLK);
    $dumpvars (0,UTOP.X1.CLKP);
    $dumpvars (0,UTOP.X1.RESET);
    $dumpvars (0,UTOP.X1.SUSPENDM);
    $dumpvars (0,UTOP.X1.XCVRSELECT);
    $dumpvars (0,UTOP.X1.TERMSELECT);
    $dumpvars (0,UTOP.X1.DATABUS16_8);
    $dumpvars (0,UTOP.X1.OPMODE);
    $dumpvars (0,UTOP.X1.DATAIN);
    $dumpvars (0,UTOP.X1.TXVALID);
    $dumpvars (0,UTOP.X1.TXVALIDH);
    $dumpvars (0,UTOP.X1.TXREADY);
    $dumpvars (0,UTOP.X1.LINESTATE);
    $dumpvars (0,UTOP.X1.DATAOUT);
    $dumpvars (0,UTOP.X1.RXACTIVE);
    $dumpvars (0,UTOP.X1.RXVALID);
    $dumpvars (0,UTOP.X1.RXVALIDH);
    $dumpvars (0,UTOP.X1.RXERROR);
    $dumpvars (0,UTOP.X1.BISTON);
    $dumpvars (0,UTOP.X1.BISTFAIL);
    $dumpvars (0,UTOP.X1.PLL480);
    
  //reset control//
    #0 Reset_IN <= 1'b1; FREF <= 1'b0;
    #100 Reset_IN <= 1'b0;
  end
  
  always #83 FREF <= !FREF;
  
  always @(posedge END)
    #500 $finish;

 
endmodule
