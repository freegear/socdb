



module   mon_ready
  (
   clk      ,
   rstb     ,
   ready    ,

   dead     
   );

   input     clk;
   input     rstb;
   input     ready;

   output    dead;


   wire      dead;

   reg [5:0] cnt;

   //---------------------------------------------------

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt <= 0;
	  else if(ready == 1'b1) cnt <= 1'b0;
	  else if(cnt <= 6'd040)  cnt <= cnt + 1;
   end //
   

   assign dead = (cnt >= 6'd040) ? 1'b1 : 1'b0;
   
endmodule // mon_ready


					   