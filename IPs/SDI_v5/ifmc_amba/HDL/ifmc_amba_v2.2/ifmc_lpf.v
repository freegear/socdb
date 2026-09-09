/*

    Low Pass Filter for external input signal

    file name : ifmc_lpf.v
 
    create by gtlee
 
    create date : 2006.3.7
 
    history :
 
    note :
 
 
 */

module   ifmc_lpf
  (
   clk               ,
   rstb              ,

   in                ,
   out
   );
   
   parameter             DELAY_TAPS = 3;
   
   input                 clk;
   input 				 rstb;

   input 				 in;
   output 				 out;
   
   
   //////////////////////////////////////////////////////////
   // input signal low pass filtered 
   
   reg [DELAY_TAPS-1:0]  in_dly;
   reg 					 out;  // lowpass filter output.
   
   always @(posedge clk or negedge rstb) begin
      if(~rstb) in_dly <= {DELAY_TAPS{1'b1}};
      else in_dly <= {in_dly[DELAY_TAPS-2:0],in};
   end // always @ (posedge clk or negedge rstb)
   
   always @(posedge clk or negedge rstb) begin
      if(~rstb)  out <= 1'b1;
      else if((&{in_dly,in}) == 1'b1) out <= 1'b1;
      else if((|{in_dly,in}) == 1'b0) out <= 1'b0;
   end // always @ (posedge clk or negedge rstb)

endmodule // ifmc_lpf

