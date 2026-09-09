/*
 
 Multi-cycle Divider 
 
 Project : Grahpic Accelerator
 File name : divider.v
 creaded by : gltee
 created date : 2006.7.13

 notes :
      result is 16bits.
      Loop is 8.
 
  */
`timescale 1ns/10ps

module      divider
  (
   clk              ,
   rstb             ,

   diven            ,
   dividend         ,
   divisor          ,
   q_hbit           ,

   divend           ,
   q                
   //r                
   );
   
   parameter          WIDTH_DIVD = 24;
   parameter 		  WIDTH_DIVS = 24;
   parameter 		  WIDTH_RSLT = 24;
   
   parameter 		  LOOP = 4;  //(WIDTH_RSLT/2 - 1);
   
   input 			  clk;
   input 			  rstb;
   
   input              diven; // divider enable
   input [WIDTH_DIVD-1:0] dividend; // 13bits
   input [WIDTH_DIVS-1:0] divisor;  // 13bits
   input [3:0] 			  q_hbit; // 0~11 
   //q_hbit는 루프수 ex> 몫이 16bit필요하면 7을 넣어주면 됨
  
   output 				  divend; // divider end
   output [WIDTH_RSLT-1:0] q; // quotient
   //output [WIDTH_DIVS-1:0] r; // rest
   //======================================================
   wire 				   divend;
   
   wire [WIDTH_RSLT-1:0]   q;
   wire [WIDTH_DIVS-1:0]   r;
   
   // internal signals
//   integer 				 i;

   wire [WIDTH_DIVD+3-1:0] divisor_m;
   reg [WIDTH_DIVD+3-1:0] divisor_m1;  // 19bits
   wire [WIDTH_DIVD+3-1:0] divisor_m2;  // 19bits
   reg [WIDTH_DIVD+3-1:0] divisor_m3;  // 19bits

   wire [WIDTH_DIVD+3-1:0] remainder;
   reg [WIDTH_DIVD+2-1:0] dividend_rm;
   
   wire [1:0] 			  q_cmp;
   reg [WIDTH_RSLT-1:0]   q_cmb; // combined quotient 
      
   reg [LOOP-1:0] 		  loop_cnt; // divider loop counter
      
   //----------------------------------------------------
   // State Machine
   parameter 		  SM_WIDTH = 4;
   parameter 		  SM_INIT = {{(SM_WIDTH-1){1'b0}}, 1'b1};
   
   parameter 		  IDLE = 0;
   parameter 		  PRES = 1;
   parameter 		  DIV = 2;
   parameter 		  POSTS = 3;
   
   parameter 		  ST_IDLE  = (SM_INIT << IDLE);
   parameter 		  ST_PRES  = (SM_INIT << PRES);
   parameter 		  ST_DIV   = (SM_INIT << DIV);
   parameter 		  ST_POSTS = (SM_INIT << POSTS);

   
   reg [SM_WIDTH-1:0] cs,ns;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end

   always@(cs or diven or divisor or loop_cnt) begin
	  case(1'b1)    // synopsys parallel_case
		cs[IDLE] :
		  if(diven) ns <= ST_PRES;
		  else ns <= ST_IDLE;

		cs[PRES] :
		  if(|divisor == 1'b0) ns <= ST_POSTS;
		  else ns <= ST_DIV;
		
		cs[DIV] :
		  if(|loop_cnt == 1'b0) ns <= ST_POSTS;
		  else ns <= ST_DIV;
		
		cs[POSTS] :
		  ns <= ST_IDLE;

		default : ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or diven or divisor or loop_cnt)
   
   //--------------------------------------------------------

   // mul -1
   assign     divisor_m = {{(WIDTH_DIVD+3-WIDTH_DIVS){1'b1}},{~divisor}} + 1;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 divisor_m1 <= {(WIDTH_DIVD+3){1'b0}};
		 divisor_m3 <= {(WIDTH_DIVD+3){1'b0}};
	  end
	  else if(cs[PRES]) begin
		 divisor_m1 <= divisor_m;
		 divisor_m3 <= divisor_m + {divisor_m[WIDTH_DIVD+3-2:0],1'b0};
	  end // else
   end // always
	  
   assign divisor_m2 = {divisor_m1[WIDTH_DIVD+3-2:0],1'b0};
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) dividend_rm <= {(WIDTH_DIVD+2){1'b0}};
	  else if(cs[PRES])
		dividend_rm <= {1'b0,dividend,1'b0};
	  else if(cs[DIV])
		dividend_rm <= remainder[WIDTH_DIVD+2-1:0];
   end // always
   
   
   div_cmp  #(WIDTH_DIVS) div_cmp
     (
      .dividend       ( {1'b0,dividend_rm} ),
      .divisor_m1     ( divisor_m1 ),
      .divisor_m2     ( divisor_m2 ),
      .divisor_m3     ( divisor_m3 ),
      
      .q              ( q_cmp ),
      .r              ( remainder )
      );

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) q_cmb <= {WIDTH_RSLT{1'b0}};
	  else if(cs[PRES])
		q_cmb <= {WIDTH_RSLT{1'b0}};
	  else if(cs[DIV])
		q_cmb <= {q_cmb[WIDTH_RSLT-3:0],q_cmp};
   end // always
   
   // loop counter
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) loop_cnt <= {LOOP{1'b0}};
	  else if(cs[IDLE])
		loop_cnt <= q_hbit;  
	  //{LOOP{1'b0}}; // non에서 시작. old.
	  else if(cs[DIV])
		loop_cnt <= loop_cnt + 4'hf;
	  		//loop_cnt <= {loop_cnt[LOOP-2:0],1'b1};
   end // always
   
   //====================================================
   // Post process
   
   assign 		q = q_cmb;

   assign 		r = dividend_rm[WIDTH_DIVS+2-1:2];
   /*
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  r <= {WIDTH_DIVS{1'b0}};
	  else if(cs[DIV])
 		 r <= remainder[WIDTH_DIVS+2-1:2];
   end // always
	*/
   assign 		divend = cs[POSTS];
	 
endmodule // divider


