/***********************************************************
   Pre scaler for FMC
  
   calc. base time
 
   file name : ifmc_pscal.v
 
   created by gtlee
 
   date : 2006.3.4
 
   note :
        generate basic clock signal.
 
 ************************************************************/

module  ifmc_pscal
  (
   clk            ,
   rstb           ,

   cnt_rst        ,
   cnt_value      ,
   pscal_clk      
   );
   
   input             clk;
   input             rstb;
   
   input 			 cnt_rst;  // couter reset.
   input [6:0] 		 cnt_value;
   output 			 pscal_clk;

   //------------------------------------------------
   reg 				 pscal_clk;
   
   
   reg [6:0] 		 cnt;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt <= 7'h1f;
	  else if(cnt_rst | ~(|cnt)) cnt <= cnt_value;
	  else cnt <= cnt + 7'h7f;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) pscal_clk <= 1'b0;
	  else if(~(|cnt)) pscal_clk <= 1'b1;
	  else  pscal_clk <= 1'b0;
   end
   
endmodule // ifmc_pscal
