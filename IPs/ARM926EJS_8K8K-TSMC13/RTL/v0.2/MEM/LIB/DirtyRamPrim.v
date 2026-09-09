module DirtyRamPrim(
   CLK,
   CE,
   WE,
   A,
   D,
   Q
);

  parameter word_depth = 64; // 16 valid bits per row/entry
  
  input          CLK;
  input          CE;
  input          WE;
  input  [ 5: 0] A;
  input          D;

  output         Q;

  reg          mem [word_depth-1:0];
  reg          Qi;

  always @(posedge CLK)
  begin : RamMain

    // read/write activity must be initiated
    if (CE == 1'b1) begin
        if (WE == 1'b1) begin
          mem[A[5:0]] = D;
          Qi = #1 mem[A[5:0]];
        end else begin
            Qi = #1 mem[A[5:0]];
        end
    end

  end // RamMain

  // drive Q outputs
  assign Q = Qi;

endmodule // DirtyRamPrim

//#
//# Design Assumptions and Timing Issues
//# ====================================
//#

