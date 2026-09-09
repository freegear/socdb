
//
// ONE_SHOT.v
//
// this module generates a one shot pulse 
// whenever an input goes high from low
//
//          |---|   |---|   |---|   |
// _________|   |___|   |___|   |___|
//
//          |------------------------
//  ________|
//
//          |-------|
//  ________|       |________________
//

module one_shot (
                  rst_p,
                  clk,
                  d,
                  q
                );

input  rst_p;
input  clk;
input  d;
output q;

reg    d_del;

// generate a delay of the input
always @(posedge clk or posedge rst_p)
  if (rst_p) d_del <= 1'b1;
  else d_del <= ~d;

assign q = d & d_del;

endmodule
