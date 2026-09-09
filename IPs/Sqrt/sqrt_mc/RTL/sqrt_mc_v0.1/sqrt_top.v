/*
 Top module of quare root.
 
 Project : Enhancer
 
 File name : sqrt_top.v
 
 creaded by : gltee
 
 created date : 2005.1.5

 notes :
   total clock is 14.

 hitory :
 
 */

module       sqrt_top
  (
   clk             ,
   rstb            ,

   sqrten         ,
   radicad         ,
   
   q               ,
   sqrtend
   );
   parameter           WIDTH_RAD_ORG = 28;
   parameter           WIDTH_RAD = (WIDTH_RAD_ORG/2);
   parameter 	       WIDTH_Q = (WIDTH_RAD_ORG/2);
   parameter           LOOP = (WIDTH_Q - 1);
   
   // in/out
   input               clk;
   input 			   rstb;

   input 			   sqrten;
   input [WIDTH_RAD_ORG-1:0] radicad; // 28bit   

   output 			   sqrtend;
   output [WIDTH_Q-1:0] q; // 14bit

   //================================================
   // internal signals
   wire 				sqrtend;
   wire [WIDTH_Q-1:0] 	q;
   
   reg [WIDTH_Q-1:0] 	quot; // 14bit
   reg [WIDTH_RAD-1:0] 	rad;
   reg [WIDTH_RAD_ORG-1:0] r;
   
   
   wire [WIDTH_Q-1:0] quotient; // 14bit
   wire [WIDTH_RAD-1:0] radicad_0; // 14bit
   wire [WIDTH_RAD_ORG-1:0] r_org; // 28bit


   reg [LOOP-1 :0] 			loop_cnt;
   

   //=============================================
   sqrt_r2    sqrt_r2
     (
      .quot_bfr           ( quot ),
      .rad_bfr            ( rad ), 
      .r_org_bfr          ( r ),
      
      .quotient           ( quotient ),
      .radicad            ( radicad_0 ),
      .r_org              ( r_org )
      );


   //=============================================
   // State Machine
   parameter 		  SM_WIDTH = 3;
   parameter 		  SM_INIT = {{(SM_WIDTH-1){1'b0}}, 1'b1};
   
   parameter 		  IDLE = 0;
   parameter 		  SQRT = 1;
   parameter 		  POSTS = 2;
   
   parameter 		  ST_IDLE  = (SM_INIT << IDLE);
   parameter 		  ST_SQRT  = (SM_INIT << SQRT);
   parameter 		  ST_POSTS = (SM_INIT << POSTS);

   reg [SM_WIDTH-1:0] cs,ns;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end
   
   always@(cs or sqrten or loop_cnt) begin
	  	  case(1'b1)    // synopsys parallel_case
		cs[IDLE] :
		  if(sqrten) ns <= ST_SQRT;
		  else ns <= ST_IDLE;

		cs[SQRT] :
		  if(loop_cnt[LOOP-1] == 1'b1) ns <= ST_POSTS;
		  else ns <= ST_SQRT;
		
		cs[POSTS] :
		  ns <= ST_IDLE;

		default : ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or loop_cnt)

   
   // initial value
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 quot <= {WIDTH_Q{1'b1}};
		 rad <= {WIDTH_RAD{1'b0}};
		 r <= {WIDTH_RAD{1'b0}};
	  end
	  if(cs[SQRT]) begin
		 quot <= quotient;
		 rad <= radicad_0;
		 r <= r_org;
	  end
	  else if(sqrten) begin
		 quot <= {WIDTH_Q{1'b1}};
		 rad <= {WIDTH_RAD{1'b0}};
		 r <= radicad;
	  end
   end // always@ (posedge clk or negedge rstb)

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) loop_cnt <= {LOOP{1'b0}};
	  else if(cs[IDLE] & sqrten)
		loop_cnt <= {LOOP{1'b0}};
	  else if(cs[SQRT])
		loop_cnt <= {loop_cnt[LOOP-2:0],1'b1};
   end // always
   
   assign       sqrtend = cs[POSTS];
   assign	    q = ~quot;
   
endmodule // sqrt_top
