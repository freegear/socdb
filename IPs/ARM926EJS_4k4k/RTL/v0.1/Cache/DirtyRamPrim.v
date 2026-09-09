module DirtyRamPrim(
   CLK,
   CE,
   WE,
   A,
   D,
   Q
);

  parameter word_depth = 32; // 16 valid bits per row/entry
  
  input          CLK;
  input          CE;
  input          WE;
  input  [ 9: 0] A;
  input          D;

  output         Q;

  reg          mem [word_depth-1:0];
  reg          Qi;

  always @(posedge CLK)
  begin : RamMain

    // read/write activity must be initiated
    if (CE == 1'b1) begin
        if (WE == 1'b1) begin
          mem[A[4:0]] = D;
          Qi = #1 mem[A[4:0]];
        end else begin
            Qi = #1 mem[A[4:0]];
        end
    end

  end // RamMain

  // drive Q outputs
  assign Q = Qi;

endmodule // ValidRam128k

//#
//# Design Assumptions and Timing Issues
//# ====================================
//#

