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


module      divider
  (
   clk              ,
   rstb             ,

   diven            ,
   dividend         ,
   divisor          ,

   divend           ,
   q                ,
   r                
   );
   
   parameter          WIDTH_DIVD = 16;
   parameter 		  WIDTH_DIVS = 16;
   parameter 		  WIDTH_RSLT = 16;
   
   parameter 		  LOOP = (WIDTH_RSLT/2 - 1);
   
   input 			  clk;
   input 			  rstb;
   
   input              diven; // divider enable
   input [WIDTH_DIVD-1:0] dividend; // 13bits
   input [WIDTH_DIVS-1:0] divisor;  // 13bits

   output 				  divend; // divider end
   output [WIDTH_RSLT-1:0] q; // quotient
   output [WIDTH_DIVS-1:0] r; // rest
   //======================================================
   reg 					   divend;
   
   reg [WIDTH_RSLT-1:0]  q;
   reg [WIDTH_DIVS-1:0]  r;
   
   // internal signals
//   integer 				 i;
   reg [WIDTH_DIVS-1:0]  lz_cnt; // leading zero counter.
   reg [WIDTH_DIVS-1:0]  divs_sht; // left shifted divisor

   wire [WIDTH_DIVD+3-1:0] divisor_m;
   reg [WIDTH_DIVD+3-1:0] divisor_m1;  // 19bits
   wire [WIDTH_DIVD+3-1:0] divisor_m2;  // 19bits
   reg [WIDTH_DIVD+3-1:0] divisor_m3;  // 19bits

   wire [WIDTH_DIVD+3-1:0] remainder;
   reg [WIDTH_DIVD+2-1:0] dividend_rm;
   
   wire [1:0] 			  q_cmp;
   reg [WIDTH_RSLT-1:0]   q_cmb; // combined quotient 

   reg [LOOP-1:0] 		   loop_cnt; // divider loop counter
      
   //----------------------------------------------------
   // State Machine
   parameter 		  SM_WIDTH = 5;
   parameter 		  SM_INIT = {{(SM_WIDTH-1){1'b0}}, 1'b1};
   
   parameter 		  IDLE = 0;
   parameter 		  PRE  = 1;
   parameter 		  PRES = 2;
   parameter 		  DIV = 3;
   parameter 		  POSTS = 4;
   
   parameter 		  ST_IDLE  = (SM_INIT << IDLE);
   parameter 		  ST_PRE   = (SM_INIT << PRE);
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
		  if(diven) ns <= ST_PRE;
		  else ns <= ST_IDLE;

		cs[PRE] :
		  if(|divisor == 1'b0) ns <= ST_POSTS;
		  else ns <= ST_PRES;
		
		cs[PRES] :
		  ns <= ST_DIV;

		cs[DIV] :
		  if(loop_cnt[LOOP-1] == 1'b1) ns <= ST_POSTS;
		  else ns <= ST_DIV;
		
		cs[POSTS] :
		  ns <= ST_IDLE;

		default : ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or diven or divisor or loop_cnt)
   
   //======================================================
   // shift divisor

   reg [WIDTH_DIVS-1:0]    lz_2; // leading zero with two bits
   reg [WIDTH_DIVS-1:0]    lz_4;
   reg [WIDTH_DIVS-1:0]    lz_8;
   reg [WIDTH_DIVS-1:0]    lz_16;
   always@(divisor) begin
	  lz_2[1:0] <= (divisor[1] == 1'b1) ? 2'b10 : divisor[1:0];
	  lz_2[3:2] <= (divisor[3] == 1'b1) ? 2'b10 : divisor[3:2];
	  lz_2[5:4] <= (divisor[5] == 1'b1) ? 2'b10 : divisor[5:4];
	  lz_2[7:6] <= (divisor[7] == 1'b1) ? 2'b10 : divisor[7:6];
	  lz_2[9:8] <= (divisor[9] == 1'b1) ? 2'b10 : divisor[9:8];
	  lz_2[11:10] <= (divisor[11] == 1'b1) ? 2'b10 : divisor[11:10];
	  lz_2[13:12] <= (divisor[13] == 1'b1) ? 2'b10 : divisor[13:12];
	  lz_2[15:14] <= (divisor[15] == 1'b1) ? 2'b10 : divisor[15:14];
  
/*	  for(i=0;i<WIDTH_DIVS;i=i+2) begin
		 lz_2[i+1:i] <= (divisor[i+1] == 1'b1) ? 2'b10 : divisor[i+1:i];
 	  end // for */
   end // always

   always@(lz_2 or divisor) begin
	  lz_4[3:0] <= (|divisor[3:2] == 1'b1)? 
				   {lz_2[3:2],2'h0} : lz_2[3:0];
	  lz_4[7:4] <= (|divisor[7:6] == 1'b1)? 
				   {lz_2[7:6],2'h0} : lz_2[7:4];
	  lz_4[11:8] <= (|divisor[11:10] == 1'b1)? 
					{lz_2[11:10],2'h0} : lz_2[11:8];
	  lz_4[15:12] <= (|divisor[15:14] == 1'b1)? 
					 {lz_2[15:14],2'h0} : lz_2[15:12];

	  /*
	  for(i=0;i<WIDTH_DIVS;i=i+4) begin
		 lz_4[i+3:0] <= (|divisor[i+3:i+2] == 1'b1)? 
						{lz_2[i+3:i+2],2'h0} : lz_2[i+3:0];
	  end // for
	   */
   end // always
   
   always@(lz_4 or divisor) begin
	  lz_8[7:0] <= (|divisor[7:4] == 1'b1)? 
					 {lz_4[7:4],4'h0} : lz_4[7:0];
	  lz_8[15:8] <= (|divisor[15:12] == 1'b1)? 
						{lz_4[15:12],4'h0} : lz_4[15:8];
	  /*
	  for(i=0;i<WIDTH_DIVS;i=i+8) begin
		 lz_8[i+7:0] <= (|divisor[i+7:i+4] == 1'b1)? 
						{lz_4[i+7:i+4],4'h0} : lz_4[i+7:0];
	  end // for
	   */
   end // always
   
   always@(lz_8 or divisor) begin
	  lz_16[15:0] <= (|divisor[15:8] == 1'b1)? 
					  {lz_8[15:8],8'h00} : lz_8[15:0];

/*	  for(i=0;i<WIDTH_DIVS;i=i+16) begin
		 lz_16[i+15:0] <= (|divisor[i+15:i+8] == 1'b1)? 
						  {lz_8[i+15:i+8],8'h00} : lz_8[i+15:0];
 	  end // for 
 */
   end // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) lz_cnt <= {1'b1,{(WIDTH_DIVS-1){1'b0}}};
	  else if(cs[PRE]) lz_cnt <= lz_16;
   end //always

   //--------------------------------------------------------
   //
   reg [WIDTH_DIVS/4-1:0] lz_num4;
   reg [WIDTH_DIVS-1:0]   divs_s4;
      
   always@(lz_cnt or divisor) begin
	  case(1'b1)    // synopsys parallel_case
		(|lz_cnt[3:0]) : begin
		   divs_s4 <= {divisor[3:0],{(WIDTH_DIVS-4){1'b0}}};
		   lz_num4 <= lz_cnt[3:0];
		end
		(|lz_cnt[7:4]) : begin
		   divs_s4 <= {divisor[7:0],{(WIDTH_DIVS-8){1'b0}}};
		   lz_num4 <= lz_cnt[7:4];
		end
		(|lz_cnt[11:8]) : begin
		   divs_s4 <= {divisor[11:0],{(WIDTH_DIVS-12){1'b0}}};
		   lz_num4 <= lz_cnt[11:8];
		end
		default: begin
		   divs_s4 <= divisor;
		   lz_num4 <= lz_cnt[15:12];
		end
	  endcase // case(1'b1)
   end // always@ (lz_cnt or divisor)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) divs_sht <= {WIDTH_DIVS{1'b0}};
	  else begin
		 case(1'b1)    // synopsys parallel_case
		   lz_num4[0] :
			 divs_sht <= {divs_s4[12:0],{(WIDTH_DIVS-13){1'b0}}};
		   lz_num4[1] :
			 divs_sht <= {divs_s4[13:0],{(WIDTH_DIVS-14){1'b0}}};
		   lz_num4[2] :
			 divs_sht <= {divs_s4[14:0],{(WIDTH_DIVS-15){1'b0}}};
		   default :
			 divs_sht <= divs_s4;
		 endcase // case(1'b1)
	  end // else: !if(~rstb)
   end // always@ (posedge clk or negedge rstb)
   
   //==========================================================

   // mul -1
   assign     divisor_m = {{(WIDTH_DIVD+3-WIDTH_DIVS){1'b1}},{~divs_sht}} + 1;
   
   always@(divisor_m) begin
		 divisor_m1 <= divisor_m;
		 divisor_m3 <= divisor_m + {divisor_m[WIDTH_DIVD+3-2:0],1'b0};
   end // always
   
   assign divisor_m2 = {divisor_m1[WIDTH_DIVD+3-2:0],1'b0};

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) dividend_rm <= {(WIDTH_DIVD+2){1'b0}};
	  else if(cs[PRE])
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
		loop_cnt <= {LOOP{1'b0}}; // non에서 시작.
	  else if(cs[DIV])
		loop_cnt <= {loop_cnt[LOOP-2:0],1'b1};
   end // always
   
   //====================================================
   // Post process
   // shift the results
   
   reg [WIDTH_DIVS-1:0]   q_s4;
   reg [WIDTH_DIVS-1:0]   r_s4;
      
   always@(lz_cnt or q_cmb) begin
	  case(1'b1)    // synopsys parallel_case
		(|lz_cnt[3:0]) : begin
		   q_s4 <= {q_cmb[3:0],{(WIDTH_RSLT-4){1'b0}}};
		end
		(|lz_cnt[7:4]) : begin
		   q_s4 <= {q_cmb[7:0],{(WIDTH_RSLT-8){1'b0}}};
		end
		(|lz_cnt[11:8]) : begin
		   q_s4 <= {q_cmb[11:0],{(WIDTH_RSLT-12){1'b0}}};
		end
		default: begin
		   q_s4 <= q_cmb;
		end
	  endcase // case(1'b1)
   end // always@ (lz_cnt or q_cmb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) q <= {WIDTH_RSLT{1'b0}};
	  else begin
		 case(1'b1)    // synopsys parallel_case
		   lz_num4[0] :
			 q <= {q_s4[12:0],{(WIDTH_RSLT-13){1'b0}}};
		   lz_num4[1] :
			 q <= {q_s4[13:0],{(WIDTH_RSLT-14){1'b0}}};
		   lz_num4[2] :
			 q <= {q_s4[14:0],{(WIDTH_RSLT-15){1'b0}}};
		   default :
			 q <= q_s4;
		 endcase // case(1'b1)
	  end // else: !if(~rstb)
   end // always@ (posedge clk or negedge rstb)

   //--------------------------
   /*
	// shift left
   always@(lz_cnt or dividend_rm) begin
	  case(1'b1)    // synopsys parallel_case
		(|lz_cnt[3:0]) : begin
		   r_s4 <= {dividend_rm[5:2],{(WIDTH_DIVS-12){1'b0}}};
		end
		(|lz_cnt[7:4]) : begin
		   r_s4 <= {dividend_rm[9:2],{(WIDTH_DIVS-8){1'b0}}};
		end
		(|lz_cnt[11:8]) : begin
		   r_s4 <= {dividend_rm[13:2],{(WIDTH_DIVS-4){1'b0}}};
		end
		default: begin
		   r_s4 <= dividend_rm[WIDTH_DIVS+2-1:2];
		end
	  endcase // case(1'b1)
   end // always@ (lz_cnt or dividend_rm)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) r <= {WIDTH_DIVS{1'b0}};
	  else if(cs[DIV]) begin
		 case(1'b1)    // synopsys parallel_case
		   lz_num4[0] :
			 r <= {r_s4[12:0],{(WIDTH_DIVS-13){1'b0}}};
		   lz_num4[1] :
			 r <= {r_s4[13:0],{(WIDTH_DIVS-14){1'b0}}};
		   lz_num4[2] :
			 r <= {r_s4[14:0],{(WIDTH_DIVS-15){1'b0}}};
		   default :
			 r <= r_s4;
		 endcase // case(1'b1)
	  end // else: !if(~rstb)
   end // always@ (posedge clk or negedge rstb)
*/
   // shift right
   always@(lz_cnt or dividend_rm) begin
	  case(1'b1)    // synopsys parallel_case
		(|lz_cnt[3:0]) : begin
		   r_s4 <= {{(WIDTH_DIVS-12){1'b0}},dividend_rm[WIDTH_DIVS+2-1:WIDTH_DIVS+2-1-3]};
		end
		(|lz_cnt[7:4]) : begin
		   r_s4 <= {{(WIDTH_DIVS-8){1'b0}},dividend_rm[WIDTH_DIVS+2-1:WIDTH_DIVS+2-1-7]};
		end
		(|lz_cnt[11:8]) : begin
		   r_s4 <= {{(WIDTH_DIVS-4){1'b0}},dividend_rm[WIDTH_DIVS+2-1:WIDTH_DIVS+2-1-11]};
		end
		default: begin
		   r_s4 <= dividend_rm[WIDTH_DIVS+2-1:2];
		end
	  endcase // case(1'b1)
   end // always@ (lz_cnt or dividend_rm)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) r <= {WIDTH_DIVS{1'b0}};
	  else if(cs[POSTS]) begin
		 case(1'b1)    // synopsys parallel_case
		   lz_num4[0] :
			 r <= {{3{1'b0}},r_s4[WIDTH_DIVS-1:WIDTH_DIVS-1-12]};
		   lz_num4[1] :
			 r <= {{2{1'b0}},r_s4[WIDTH_DIVS-1:WIDTH_DIVS-1-13]};
		   lz_num4[2] :
			 r <= {{1{1'b0}},r_s4[WIDTH_DIVS-1:WIDTH_DIVS-1-14]};
		   default :
			 r <= r_s4;
		 endcase // case(1'b1)
	  end // else: !if(~rstb)
   end // always@ (posedge clk or negedge rstb)

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) divend <= 1'b0;
	  else   	divend <= cs[POSTS];
   end
	 
endmodule // divider


