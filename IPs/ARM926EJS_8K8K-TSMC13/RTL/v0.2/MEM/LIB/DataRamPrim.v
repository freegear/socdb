module DataRamPrim(
   CLK,
   CE,
   WE,
   A,
   D,
   Q
);

  parameter word_depth = 512;
  
  input          CLK;
  input          CE;
  input          WE;
  input  [ 8: 0] A;
  input  [ 7: 0] D;

  output [ 7: 0] Q;

  reg [ 7: 0]  mem [word_depth-1:0];
  reg [ 7: 0]  Qi;

  always @(posedge CLK)
  begin : RamMain

    // read/write activity must be initiated
    if (CE == 1'b1) begin
        if (WE == 1'b1) begin
          mem[A[8:0]] = D;
          Qi = #1 mem[A[8:0]];
        end 
	else begin
            Qi = #1 mem[A[8:0]];
       end
    end

  end // RamMain

  // drive Q outputs
  assign Q = Qi;

endmodule // DataRamPrim

//#
//# Design Assumptions and Timing Issues
//# ====================================
//#

