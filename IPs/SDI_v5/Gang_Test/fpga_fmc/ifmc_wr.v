/***********************************************************
   flash memory write control module of Flash memory controller
  
   Flash erase/programming timing generation.
 
   file name : ifmc_wr.v
 
   created by gtlee
 
   date : 2006.3.3
 
   note :

 ************************************************************/

module    ifmc_wr
  (
   clk               ,
   rstb              ,
   
   fm_rdmode         ,
   
   key_hit           ,
   fmaddr            ,
   fmdata            ,
   fmucon            ,
   
   hdp               ,
   smart             ,
   
   tnvs              ,
   tnvh              ,
   tpgs              ,
   tpgh              ,
   trcv              ,
   tnvh1             ,
   tprog             ,
   terase            ,
   tme               ,
   pscal_value       ,
   
   fm_wrmode         ,
   mx_sel_wr         ,
   clr_fmreg         ,
   
   fmw_adr           ,
   fmw_xe            ,
   fmw_ye            ,
   fmw_se            ,
   fmw_erase         ,
   fmw_mas1          ,
   fmw_prog          ,
   fmw_nvstr         ,
   fmw_ifren         ,
   fmw_din           
   );
   
   input             clk;
   input             rstb;
   
   input 			 fm_rdmode;  // 현재 flash memory를 read하는지 나타냄.
   
   input 			 key_hit;   // key register hit/miss
   input [31:0] 	 fmaddr;
   input [31:0] 	 fmdata;
   input [7:0] 		 fmucon;

   input 			 hdp;
   input [15:0] 	 smart;

   // timing values
   input [15:0] 	 tnvs;
   input [15:0] 	 tnvh;
   input [15:0] 	 tpgs;
   input [15:0] 	 tpgh;
   input [15:0] 	 trcv;
   input [15:0] 	 tnvh1;
   input [15:0] 	 tprog;
   input [31:0] 	 terase;
   input [31:0] 	 tme;
   input [6:0] 		 pscal_value;

   output 			 fm_wrmode;
   output            mx_sel_wr;
   output 			 clr_fmreg;
   
   // Flash Memory Interface signal
   //output [9:0] 	 fm_xadr;
   //output [5:0] 	 fm_yadr;
   output [15:0] 	 fmw_adr;
   output 			 fmw_xe;
   output 			 fmw_ye;
   output 			 fmw_se;
   output 			 fmw_erase;
   output 			 fmw_mas1;
   output 			 fmw_prog;
   output 			 fmw_nvstr;
   output 			 fmw_ifren;
   output [31:0] 	 fmw_din;
   
   //--------------------------------------------------
   wire 			 fm_wrmode; // FM write가 idle상태를 벗어날때.
   wire 			 mx_sel_wr; // FM mux를 write로 선택할 때.
   wire 			 clr_fmreg;

   //reg [9:0] 		 fm_xadr;
   //reg [5:0] 		 fm_yadr;
   reg [15:0] 		 fmw_adr;
   wire 			 fmw_xe;     // address enable
   wire 			 fmw_ye;     // address enable
   wire 			 fmw_se;     // sense amp
   wire 			 fmw_erase;
   wire 			 fmw_mas1;
   wire 			 fmw_prog;
   wire 			 fmw_nvstr;
   reg 				 fmw_ifren;  // information block enable
   wire [31:0] 		 fmw_din;

   // FM control bits
   wire              start_new;
   
   reg [7:0] 		 fmucon_lt; // latched control register.
   
   wire 			 chip_erase;
   wire 			 pg_erase;
   wire 			 program;
   wire 			 opt_prog;
   wire 			 start;
   wire 			 cnt_en;  // en/disbale internal counter. not used.
   
   reg 				 perase_hit; // if 1, erasable.

   reg 				 key_hit_lt; // latched key hit.
   reg 				 operation;
   reg 				 protected;

   wire 			 pscal_rst;
   wire 			 pscal_clk; // output of prescaler ~ 625ns
                                // 16번 count하면 1us
   reg 				 pscal_d1;  // 1 clock delay
   reg 				 pscal_d2;  // 2 clock delay
   reg 				 pscal_d3;  // 3 clock delay
   
   reg [8:0] 		 counter0; // 3 clock뒤에 완전한 결과가 출력. 8bit 단위로 count.
   reg [8:0] 		 counter1;
   reg [7:0] 		 counter2;
   
   wire              cnt0_zero;
   wire 			 cnt_zero;  // counter zero
   

   //----------------------------------------------------
   // State Machine
   
   parameter 		 WR_SM_WIDTH       =   17;
   parameter 		 WR_SM_INIT        =   {{(WR_SM_WIDTH-1){1'b0}},1'b1};
   
   parameter 		 IDLE              =    0;
   parameter 		 START_OP          =    1;
   parameter 		 PRE_TNVS          =    2;
   parameter 		 TNVS              =    3;
   parameter 		 PRE_TPGS          =    4;
   parameter 		 TPGS              =    5;
   parameter 		 PRE_TPROG         =    6;
   parameter 		 TPROG             =    7;
   parameter 		 PRE_TPGH          =    8;
   parameter 		 TPGH              =    9;
   parameter 		 PRE_ERASE         =   10;
   parameter 		 ERASE             =   11;
   parameter 		 PRE_TNVH          =   12;
   parameter 		 TNVH              =   13;
   parameter 		 PRE_TRCV          =   14;
   parameter 		 TRCV              =   15;
   parameter 		 CLR_REG           =   16;

   parameter 		 ST_IDLE           =   (WR_SM_INIT << IDLE);
   parameter 		 ST_START_OP       =   (WR_SM_INIT << START_OP);
   parameter 		 ST_PRE_TNVS       =   (WR_SM_INIT << PRE_TNVS);
   parameter 		 ST_TNVS           =   (WR_SM_INIT << TNVS);
   parameter 		 ST_PRE_TPGS       =   (WR_SM_INIT << PRE_TPGS);
   parameter 		 ST_TPGS           =   (WR_SM_INIT << TPGS);
   parameter 		 ST_PRE_TPROG      =   (WR_SM_INIT << PRE_TPROG);
   parameter 		 ST_TPROG          =   (WR_SM_INIT << TPROG);
   parameter 		 ST_PRE_TPGH       =   (WR_SM_INIT << PRE_TPGH);
   parameter 		 ST_TPGH           =   (WR_SM_INIT << TPGH);
   parameter 		 ST_PRE_ERASE      =   (WR_SM_INIT << PRE_ERASE);
   parameter 		 ST_ERASE          =   (WR_SM_INIT << ERASE);
   parameter 		 ST_PRE_TNVH       =   (WR_SM_INIT << PRE_TNVH);
   parameter 		 ST_TNVH           =   (WR_SM_INIT << TNVH);
   parameter 		 ST_PRE_TRCV       =   (WR_SM_INIT << PRE_TRCV);
   parameter 		 ST_TRCV           =   (WR_SM_INIT << TRCV);
   parameter 		 ST_CLR_REG        =   (WR_SM_INIT << CLR_REG);


   reg [WR_SM_WIDTH-1:0] cs, ns;


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else cs <= ns;
   end

   always@(cs or start or start_new or key_hit_lt or protected or
		   operation or fm_rdmode or cnt_zero or cnt0_zero or
		   chip_erase or pg_erase) begin
	  case ( 1'b1 ) // synopsys parallel_case
		cs[IDLE] :
		  if(start == 1'b1 && start_new == 1'b1) 
			// clr_reg가 반영되기를 기다림.
			// start는 clr_reg보다 2 clock 늦게 변경됨.
			ns <= ST_START_OP;
		  else ns <= ST_IDLE;
		
		cs[START_OP] :
		  if(operation == 1'b0) 
			ns <= ST_CLR_REG;
		  else if(key_hit_lt == 1'b0 || protected == 1'b1)
			ns <= ST_CLR_REG;
		  else if(fm_rdmode == 1'b0)  // not reading
			ns <= ST_PRE_TNVS;
		  else ns <= ST_START_OP;

		cs[PRE_TNVS] : ns <= ST_TNVS;

		cs[TNVS] :
		  if(cnt_zero == 1'b0) // during wait cycle
			ns <= ST_TNVS;
		  else if(chip_erase | pg_erase)
			ns <= ST_PRE_ERASE;
		  else ns <= ST_PRE_TPGS; // program, opt_prog

		// Programming
		cs[PRE_TPGS] : ns <= ST_TPGS;

		cs[TPGS] :
		  if(cnt_zero == 1'b0)  // during wait cycle
			ns <= ST_TPGS;
		  else ns <= ST_PRE_TPROG;

		cs[PRE_TPROG] : ns <= ST_TPROG;

		cs[TPROG] :
		  if(cnt_zero == 1'b0)  // during wait cycle
			ns <= ST_TPROG;
		  else ns <= ST_PRE_TPGH;

		cs[PRE_TPGH] : ns <= ST_TPGH;

		cs[TPGH] : // ns단위.
		  if(cnt0_zero == 1'b0)  // during wait cycle
			ns <= ST_TPGH;
		  else ns <= ST_PRE_TNVH;

		// Erase
		cs[PRE_ERASE] : ns <= ST_ERASE;

		cs[ERASE] :
		  if(cnt_zero == 1'b0)  // during wait cycle
			ns <= ST_ERASE;
		  else ns <= ST_PRE_TNVH;

		// closing
		cs[PRE_TNVH] : ns <= ST_TNVH;

		cs[TNVH] :
		  if(cnt_zero == 1'b0)  // during wait cycle
			ns <= ST_TNVH;
		  else ns <= ST_PRE_TRCV;
		
		cs[PRE_TRCV] : ns <= ST_TRCV;
		
		cs[TRCV] :
		  if(cnt_zero == 1'b0)  // during wait cycle
			ns <= ST_TRCV;
		  else ns <= ST_CLR_REG;
		
		cs[CLR_REG] : ns <= ST_IDLE;

		default : ns <= ST_IDLE;
	  endcase // case( 1'b1 )
   end
   
   // end SM
   //-------------------------------------------------------
   assign     start_new = fmucon[6]; // not used

   // write중 변경되는 것을 방지.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmucon_lt <= 8'h00;
	  else if(cs[IDLE]) fmucon_lt <= fmucon;
   end
   
   assign     chip_erase = fmucon_lt[0];
   assign 	  pg_erase   = fmucon_lt[1];
   assign 	  program    = fmucon_lt[2];
   assign 	  opt_prog   = fmucon_lt[5];
   assign 	  start      = fmucon_lt[6];
   assign 	  cnt_en     = fmucon_lt[7];
   
   // page erase protection hit/miss
   // if 1, erasable
   // no timing.
   //always@(fmaddr or smart or hdp) begin
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) perase_hit <= 1'b1;
	  else if(~hdp) begin  
		 // protection on
		 case(fmaddr[17:15])  // synopsys parallel_case
		   3'h0 : perase_hit <= smart[0];
		   3'h1 : perase_hit <= smart[1];
		   3'h2 : perase_hit <= smart[2];
		   3'h3 : perase_hit <= smart[3];
		   3'h4 : perase_hit <= smart[4];
		   3'h5 : perase_hit <= smart[5];
		   3'h6 : perase_hit <= smart[6];
		   default: perase_hit <= smart[7];
		 endcase // case(fmaddr[17:15])
	  end // if (hdp)
	  else perase_hit <= 1'b1;
   end // always@ (posedge clk or negedge rstb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) protected <= 1'b0;
	  else if(chip_erase)
		  protected <= 1'b0;  
	  else if(pg_erase & ~perase_hit) // sector erase
		protected <= 1'b1;
	  else if(program & ~opt_prog & ~perase_hit ) // data programming
		protected <= 1'b1;
	  else
 		protected <= 1'b0;
   end

   // Start_op stage에서 유효.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)   operation <= 1'b0;
	  else if(chip_erase | pg_erase | program | opt_prog )
		operation <= 1'b1;
	  else operation <= 1'b0;
   end // always@ (posedge clk or negedge rstb)

   
   // key value
   // START_OP stage에서 check.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) key_hit_lt <= 1'b0;
	  else key_hit_lt <= key_hit;
   end

   assign     fm_wrmode = ~cs[IDLE];
   assign     mx_sel_wr = ~(cs[IDLE] | cs[START_OP]);
   assign 	  clr_fmreg = cs[CLR_REG];

   always@(pg_erase or opt_prog or fmaddr) begin
	  if(pg_erase) begin
		 // page erase
         //fm_xadr <= {fmaddr[17:10],3'h0};
		 //fm_yadr <= 6'h00;
		 fmw_adr <= {fmaddr[17:10],2'h0, 6'h00};
	  end
	  else if(opt_prog) begin
		 // information write
		 //fm_xadr <= {7'h00,fmaddr[10:8]};
		 //fm_yadr <= fmaddr[7:2];
		 fmw_adr <= {7'h00,~fmaddr[10:9],fmaddr[8:2]};
	  end
	  else begin
		 //fm_xadr <= fmaddr[17:8];
		 //fm_yadr <= fmaddr[7:2];
		 fmw_adr <= fmaddr[17:2];
	  end
   end // always@ (pg_erase or opt_prog or fmaddr)
   
   assign fmw_xe = ~(cs[IDLE] | cs[START_OP] | cs[CLR_REG] |
					 cs[PRE_TRCV] | cs[TRCV]);
   assign fmw_ye = cs[TPROG];
   assign fmw_se = 1'b0;
   assign fmw_erase = (chip_erase | pg_erase) ?
					   cs[TNVS] | cs[PRE_ERASE] | cs[ERASE] : 1'b0;
   
   assign fmw_mas1 = (chip_erase)?
					  cs[TNVS] | cs[PRE_ERASE] | cs[ERASE] | 
                      cs[PRE_TNVH] | cs[TNVH] : 1'b0;

   assign fmw_prog = (program | opt_prog)? cs[TNVS] | cs[PRE_TPGS] | cs[TPGS] |
		              cs[PRE_TPROG] | cs[TPROG] | cs[PRE_TPGH] |
                      cs[TPGH] : 1'b0;
   
   assign fmw_nvstr = cs[PRE_TPGS] | cs[TPGS] | cs[PRE_TPROG] | 
                     cs[TPROG] | cs[PRE_TPGH] | cs[TPGH] |
                     cs[PRE_ERASE] | cs[ERASE] |
                     cs[PRE_TNVH] | cs[TNVH];
   
   always@(cs or chip_erase or pg_erase or opt_prog) begin
	  if( ~cs[IDLE] ) begin
		 if(chip_erase) fmw_ifren <= 1'b1;
		 else if(pg_erase) fmw_ifren <= 1'b0;
		 else if(opt_prog) fmw_ifren <= 1'b1;
		 else fmw_ifren <= 1'b0;
	  end
	  else fmw_ifren <= 1'b0;   // at no write operation
   end
   
   assign fmw_din = fmdata;
	  
   //-------------------------------------------
   // counter
   assign cnt0_zero = ~(|counter0[7:0]); // for Tpgh
   assign cnt_zero = ~(|{counter2,counter1[7:0],counter0[7:0]}) & pscal_d3;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 counter0 <= 9'h000;
		 counter1 <= 9'h000;
		 counter2 <= 8'h00;
	  end
	  // initialize counter
	  else if( cs[PRE_TNVS] ) begin
		 counter0 <= {1'b0,tnvs[7:0]};
		 counter1 <= {1'b0,tnvs[15:8]};
		 counter2 <= 8'h00;
	  end
	  else if( cs[PRE_TPGS] ) begin
		 counter0 <= {1'b0,tpgs[7:0]};
		 counter1 <= {1'b0,tpgs[15:8]};
		 counter2 <= 8'h00;
	  end
	  else if( cs[PRE_TPROG] ) begin
		 counter0 <= {1'b0,tprog[7:0]};
		 counter1 <= {1'b0,tprog[15:8]};
		 counter2 <= 8'h00;
	  end
	  else if( cs[PRE_TPGH] ) begin
		 counter0 <= {1'b0,tpgh[7:0]};
		 counter1 <= {1'b0,tpgh[15:8]};
		 counter2 <= 8'h00;
	  end
	  else if( cs[PRE_ERASE] ) begin
		 if(chip_erase) begin
			counter0 <= {1'b0,tme[7:0]};
			counter1 <= {1'b0,tme[15:8]};
			counter2 <= {1'b0,tme[23:16]};
		 end
		 else begin
			counter0 <= {1'b0,terase[7:0]};
			counter1 <= {1'b0,terase[15:8]};
			counter2 <= {1'b0,terase[23:16]};
		 end
	  end // if ( cs[PRE_ERASE] )
	  else if( cs[PRE_TNVH] ) begin
		 if(chip_erase) begin
			counter0 <= {1'b0,tnvh1[7:0]};
			counter1 <= {1'b0,tnvh1[15:8]};
			counter2 <= 8'h00;
		 end
		 else begin
			counter0 <= {1'b0,tnvh[7:0]};
			counter1 <= {1'b0,tnvh[15:8]};
			counter2 <= 8'h00;
		 end
	  end // if ( cs[PRE_TNVH] )
	  else if( cs[PRE_TRCV] ) begin
		 counter0 <= {1'b0,trcv[7:0]};
		 counter1 <= {1'b0,trcv[15:8]};
		 counter2 <= 8'h00;
	  end
	  
	  else if( cs[TPGH] ) begin // Tpgh count. system clock을 셈.
		 counter0 <= counter0 + 9'h0ff;
		 counter1 <= counter1 + 9'h0ff;
		 counter2 <= 8'h00;
	  end
	  
	  else if(~cs[IDLE]) begin
		 // count clock 
		 if(pscal_clk) begin
			counter0 <= {1'b0,counter0[7:0]} + 9'h0ff;
			counter1 <= {1'b0,counter1[7:0]} + 9'h0ff;
			counter2 <= counter2 + 8'hff;
		 end
		 else if(pscal_d1)
		   counter1 <= counter1 + {8'h00,counter0[8]};
		 else if(pscal_d2)
		   counter2 <= counter2 + {8'h00,counter1[8]};
	  end // if (~cs[IDLE])
	  else begin
		 counter0 <= 9'h000;
		 counter1 <= 9'h000;
		 counter2 <= 8'h00;
	  end // else: !if(~cs[IDLE])
   end // always@ (posedge clk or negedge rstb)

   assign   pscal_rst = cs[PRE_TNVS] | cs[PRE_TPGS] | cs[PRE_TPROG] |
						cs[PRE_ERASE] |  cs[PRE_TNVH];
   
   ifmc_pscal     pscaler
	 (
	  .clk            ( clk ),
	  .rstb           ( rstb ),
	  
	  .cnt_rst        ( pscal_rst ),
	  .cnt_value      ( pscal_value ),
	  .pscal_clk      ( pscal_clk )
	  );


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 pscal_d1 <= 1'b0;
		 pscal_d2 <= 1'b0;
		 pscal_d3 <= 1'b0;
	  end
	  else begin
		 pscal_d1 <= pscal_clk;
		 pscal_d2 <= pscal_d1;
		 pscal_d3 <= pscal_d2;
	  end
   end // always@ (posedge clk or negedge rstb)
   
   
   //------------------------------------------------------
   // synopsys translate_off

   wire   sm_idle = cs[IDLE];
   wire   sm_start_op = cs[START_OP];
   wire   sm_pre_tnvs = cs[PRE_TNVS];
   wire   sm_tnvs = cs[TNVS];
   wire   sm_pre_tpgs = cs[PRE_TPGS];
   wire   sm_tpgs = cs[TPGS];
   wire   sm_pre_tprog = cs[PRE_TPROG];
   wire   sm_tprog = cs[TPROG];
   wire   sm_pre_tpgh = cs[PRE_TPGH];
   wire   sm_tpgh = cs[TPGH];
   wire   sm_pre_erase = cs[PRE_ERASE];
   wire   sm_erase = cs[ERASE];
   wire   sm_pre_tnvh = cs[PRE_TNVH];
   wire   sm_tnvh = cs[TNVH];
   wire   sm_pre_trcv = cs[PRE_TRCV];
   wire   sm_trcv = cs[TRCV];
   wire   sm_clr_reg = cs[CLR_REG];


   reg [23:0] cnt_num;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt_num <= 0;
	  else if(pscal_d3)
		cnt_num <= {counter2,counter1[7:0],counter0[7:0]};
   end
  
   
   // synopsys translate_on
   //------------------------------------------------------

	  
endmodule // ifmc_wr


