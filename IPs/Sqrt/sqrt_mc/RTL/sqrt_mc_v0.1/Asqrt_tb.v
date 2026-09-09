/*
 Test bench of quare root.
 
 Project : SQRT
 
 File name : Asqrt_tb.v
 
 creaded by : gltee
 
 created date : 2007.7.14

 notes :


 hitory :
 
 */
`define   CLK_FREQ      10

module Asqrt_tb;
   parameter           WIDTH_RAD_ORG = 28;
   parameter 	       WIDTH_Q = (WIDTH_RAD_ORG/2);

   reg 		       clk;
   reg 		       rstb;

   reg [WIDTH_RAD_ORG-1:0] radicad; // 28bit
   wire [WIDTH_Q-1:0]    quotient;

   reg 					   sqrten; // enable
   wire 				   sqrtend; // end
   
//   integer 				   i;
      
   initial clk <= 0;
   
   always #(`CLK_FREQ/2)  clk <= ~clk;

   initial begin
      rstb = 0;
	  radicad = 1;
	  
      #(`CLK_FREQ * 20) rstb = 1;
   end

   
   always@(posedge clk) begin
       if(sqrtend) begin
		 #2 radicad <= radicad + 1;
      end
   end
   
   always@(posedge clk) begin
	  sqrten <= ~rstb | sqrtend;
   end
   
	  
   sqrt_top     #(28)       sqrt_top
     (
      .clk             ( clk ),
      .rstb            ( rstb ),

	  .sqrten         ( sqrten ),
      .radicad         ( radicad ),

      .q               ( quotient ),
	  .sqrtend        ( sqrtend )
      );

   
   integer    log_file;

   initial log_file = $fopen("sqrt_log.txt");
/*   
   always@(posedge clk) begin
      if(rstb) begin
	 if(rad[27] != 0) begin
	    $display("%h %h",rad[27],quotient);
	    $fdisplay(log_file,"%h %h",rad[27],quotient);
	 end
      end
   end
*/

   // if a quotient is changed, print.
   
   always@(posedge clk) begin
      if(rstb) begin
		 if(radicad[26] != 0 && radicad[27] == 0) begin
			//	       $display("%h %h",radicad,quotient);
			$fdisplay(log_file,"%h %h",radicad,quotient);
	     end // if
	  end // if rstb
   end // always


   // stop condition
   always@(posedge clk) begin
      if(rstb) begin
		 if(radicad[26] < radicad[27]) $stop;
      end
   end // always
   
endmodule // Asqrt_tb
