/*
 
 Compare dividend and divisors.
 
 Project : Divider
 File name : div_cmp.v 
 creaded by : gltee
 created date : 2004.10.15

 notes :

 history :
       2006.7.13  multi-cycle divider·Î ¼öÁ¤.
 
 */

module div_cmp
  (
   
   dividend       ,
   divisor_m1     ,
   divisor_m2     ,
   divisor_m3     ,

   q              ,
   r              
   );
   parameter             WIDTH_DIVD = 24;
   parameter 			 WIDTH_CMP = WIDTH_DIVD + 3; // with sign bit
   
   input [WIDTH_CMP-1:0] dividend;
   input [WIDTH_CMP-1:0] divisor_m1;
   input [WIDTH_CMP-1:0] divisor_m2;
   input [WIDTH_CMP-1:0] divisor_m3;

   output [1:0] 	 q;
   output [WIDTH_CMP-1:0] r;

   //--------------------------------------------
   // internal variables
   wire [WIDTH_CMP-1:0] 	 remainder1;
   wire [WIDTH_CMP-1:0] 	 remainder2;
   wire [WIDTH_CMP-1:0] 	 remainder3;

   reg [1:0] 			 q;
   reg [WIDTH_CMP-1:0] 	 r;
   
   //-------------------------------------------
   // compare
   assign 	 remainder1 = dividend + divisor_m1;
   assign 	 remainder2 = dividend + divisor_m2;
   assign 	 remainder3 = dividend + divisor_m3;

   always@(remainder1 or remainder2 or remainder3 or dividend) begin
      if(remainder3[WIDTH_CMP-1] == 1'b0) begin
		 q <= 2'b11;
		 r <= {remainder3[WIDTH_CMP-3:0],2'b00};
      end // if
      else if(remainder2[WIDTH_CMP-1] == 1'b0) begin
		 q <= 2'b10;
		 r <= {remainder2[WIDTH_CMP-3:0],2'b00};
      end // else if
      else if(remainder1[WIDTH_CMP-1] == 1'b0) begin
		 q <= 2'b01;
		 r <= {remainder1[WIDTH_CMP-3:0],2'b00};
      end //else if
      else begin
		 q <= 2'b00;
		 r <= {dividend[WIDTH_CMP-3:0],2'b00};
      end // else
   end // always
   
endmodule // div_cmp
