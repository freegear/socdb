/*

    Detection Tool Mode 

    file name : ifmc_tool.v
 
    create by gtlee
 
    create date : 2006.3.7
 
    history :
 
    note :
 
 
 */

module  ifmc_tool
  (
   clk           ,
   rstb          ,

   tmode         ,
   scl_lpf       ,

   tool_mode     
   );
   input                clk;
   input 				rstb;

   input 				tmode;
   input 				scl_lpf;

   output 				tool_mode;

   //--------------------------------------------
   // internal signals
   reg 					tool_mode;

   //reg 					scl_dly;

   //wire 				scl_pos;  // positive edge
   //wire 				scl_neg;  // negative edge
   
   reg [5:0] 			cnt;
   
   /*
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) scl_dly <= 1'b0;
	  else scl_dly <= scl_lpf;
   end // always
   
   assign scl_pos = (~scl_dly) & scl_lpf;
   assign scl_neg = scl_dly  & (~scl_lpf);
	*/
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt <= {6{1'b0}};
	  else if(tool_mode) cnt <= {6{1'b1}};
	  else if(tmode & scl_lpf) cnt <= cnt + 6'h01;
	  else cnt <= {6{1'b0}};
   end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) tool_mode <= 1'b0;
	  else if(tmode & scl_lpf & cnt[5])
		tool_mode <= 1'b1;
	  else if(~tmode)
		tool_mode <= 1'b0;
   end  // always
   
endmodule // ifmc_tool
