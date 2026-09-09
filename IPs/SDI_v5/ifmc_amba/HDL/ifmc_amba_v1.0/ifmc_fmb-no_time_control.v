/*
   Flash Memory Block
 
   Protection 기능 포함.
 
   created by gtlee
 
   date : 2006.2.28
 
 
   note :
      Address는 cpu가 출력한 address[17:2]가 mapping된다.
      flash read timing control을 행하지 않음.
 */


module     ifmc_fmb
  (
   clk             ,
   rstb            ,
   
   addr            , 
   csel            , 
   perase          ,
   berase          ,
   prog            , 
   ifren           ,
   wdata           ,
   rdata           ,
   ready           ,
   
   hdp             ,
   rdp             ,
   smart           ,
   
   fm_xadr         ,
   fm_yadr         ,
   fm_xe           ,
   fm_ye           ,
   fm_se           ,
   fm_erase        ,
   fm_mas1         ,
   fm_prog         ,
   fm_nvstr        ,
   fm_ifren        ,
   fm_din          ,
   fm_dout         
   );
   input                 clk;
   input 				 rstb;

   input [15:0] 		 addr;   // ahb_addr[17:2]
   input 				 csel;   // chip select
   input 				 perase; // page erase
   input 				 berase; // both erase
   input 				 prog;   // programming
   input 				 ifren;  // information block enable
   input [31:0] 		 wdata;
   output [31:0] 		 rdata;
   output 				 ready;
   
   // protection information
   output 				 hdp;
   output 				 rdp;
   output [15:0] 		 smart;
   
   // Flash Memory Core Pin
   output [9:0]          fm_xadr;
   output [5:0] 		 fm_yadr;
   output 				 fm_xe;     // address enable
   output 				 fm_ye;     // address enable
   output 				 fm_se;     // sense amp
   output 				 fm_erase;
   output 				 fm_mas1;
   output 				 fm_prog;
   output 				 fm_nvstr;
   output 				 fm_ifren;
   output [31:0] 		 fm_din;
   input [31:0] 		 fm_dout;
   

   //---------------------------------------------------
   // Internal signals
   wire 				 ready;
   reg [31:0] 			 rdata;

   reg 					 hdp; // bit 17
   reg 					 rdp; // bit 27
   reg [15:0] 			 smart;

   reg [9:0] 			 fm_xadr;
   reg [5:0] 			 fm_yadr;
   reg 					 fm_xe;     // address enable
   reg 					 fm_ye;     // address enable
   reg 					 fm_se;
   reg 					 fm_prog;
   reg 					 fm_erase;
   reg 					 fm_mas1;
   reg 					 fm_nvstr;
   reg 					 fm_ifren;
   reg [31:0] 			 fm_din;

   wire 				 op_read;
   wire 				 op_prog;
   wire 				 op_perase;
   wire 				 op_berase;
   
   
   //--------------------------------------------------

   reg [2:0] 			 cnt; // counter
   
   
   // State Machine
`define FMB_SM_WIDTH          9
   
`define START                 0
`define WAIT0                 1
`define WAIT1                 2
`define WAIT2                 3
`define SET_RD_PROT           4
`define WAIT_RD_PROT          5
`define SET_RD_SMART          6
`define WAIT_RD_SMART         7
`define NORMAL                8

`define ST_START              (`FMB_SM_WIDTH'h001<<`START)
`define ST_WAIT0              (`FMB_SM_WIDTH'h001<<`WAIT0)
`define ST_WAIT1              (`FMB_SM_WIDTH'h001<<`WAIT1)
`define ST_WAIT2              (`FMB_SM_WIDTH'h001<<`WAIT2)
`define ST_SET_RD_PROT        (`FMB_SM_WIDTH'h001<<`SET_RD_PROT)
`define ST_WAIT_RD_PROT       (`FMB_SM_WIDTH'h001<<`WAIT_RD_PROT)
`define ST_SET_RD_SMART       (`FMB_SM_WIDTH'h001<<`SET_RD_SMART)
`define ST_WAIT_RD_SMART      (`FMB_SM_WIDTH'h001<<`WAIT_RD_SMART)
`define ST_NORMAL             (`FMB_SM_WIDTH'h001<<`NORMAL)

   reg [FMB_SM_WIDTH-1:0] 			 cs, ns;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= `ST_START;
	  else cs <= ns;
   end

   always@(cs or cnt) begin
	  case(1'b1)  // synopsys parallel_case
		cs[`START] : ns <= `ST_WAIT0;
		
		cs[`WAIT0] : ns <= `ST_WAIT1;

		cs[`WAIT1] : ns <= `ST_WAIT2;

		cs[`WAIT2] : ns <= `ST_SET_RD_PROT;

		cs[`SET_RD_PROT] : ns <= `ST_WAIT_RD_PROT;

		cs[`WAIT_RD_PROT] :
		  if(cnt == 3'b111) ns <= `ST_SET_RD_SMART;
		  else ns <= cs;

		cs[`SET_RD_SMART] : ns <= `ST_WAIT_RD_SMART;

		cs[`WAIT_RD_SMART] :
		  if(cnt == 3'b111) ns <= `ST_NORMAL;
		  else ns <= cs;

		cs[`NORMAL] : ns <= `ST_NORMAL;
		
		default : ns <= `ST_START;
	  endcase // case(1'b1)
   end // always@ (cs or cnt)
   
   //---------------------------------------------------------
   // control signals

   assign       op_read   = csel & ~(perase | berase | prog);
   assign 		op_prog   = csel & prog & ~(perase | berase);
   assign 		op_perase = csel & perase & ~(berase);
   assign 		op_berase = csel & berase;
   
   // Protection Information
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 hdp <= 1'b1;
		 rdp <= 1'b1;
	  end
	  else if(cs[`WAIT_RD_PROT] == 1'b1 && cnt == 3'b111) begin
		 // read after reset
		 hdp <= rdata[17];
		 rdp <= rdata[27];
	  end
	  else if(ifren == 1'b1 && op_prog == 1'b1 && addr == 9'h00F) begin
		 // protection programming
		 hdp <= hdp & wdata[17];
		 rdp <= rdp & wdata[27];
	  end
	  else if(ifren == 1'b1 && (op_perase == 1'b1 || op_berase == 1'b1)) begin
		 // erase information block
		 hdp <= 1'b1;
		 rdp <= 1'b1;
	  end
   end // always@ (posedge clk or negedge rstb)
   
   // Smart Information
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) smart <= {16{1'b1}};
	  else if(cs[`WAIT_RD_SMART] == 1'b1 && cnt == 3'b111) 
		 // read after reset
		 smart <= fm_dout[15:0];
	  else if(ifren == 1'b1 && op_prog == 1'b1 && addr == 9'h00E)
		 // protection programming
		smart <= smart & wdata[15:0];
	  else if(ifren == 1'b1 && (op_perase == 1'b1 || op_berase == 1'b1))
		 // erase information block
		smart <= {16{1'b1}};
   end // always@ (posedge clk or negedge rstb)

   //------------------------------------------------
   // Read timing counter
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt <= 3'h0;
	  else if(cs[`SET_RD_PROT] | cs[`SET_RD_SMART])
		cnt <= 3'h0;
	  else if(~cs[`NORMAL]) cnt <= cnt + 3'h1;
   end
   
   //------------------------------------------------
   //

   assign       ready = cs[`WAIT_RD_SMART];

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rdata <= {32{1'b1}};
	  else rdata <= fm_dout;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fm_din <= {32{1'b1}};
	  else      fm_din = wdata;
   end
   
   // FM address signal
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 fm_xadr <= {10{1'b0}};
		 fm_yadr <= {6{1'b0}};
	  end
	  else if(cs[`SET_RD_PROT]) begin
		 fm_xadr <= {10{1'b0}};
		 fm_yadr <= 6'h0F;
	  end
	  else if(cs[`SET_RD_SMART]) begin
		 fm_xadr <= {10{1'b0}};
		 fm_yadr <= 6'h0E;
	  end
	  else if(cs[`NORMAL]) begin
		 fm_xadr <= addr[15:6];
		 fm_yadr <= addr[5:0];
	  end
   end // always@ (posedge clk or negedge rstb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 sfm_xe <= 1'b0;
		 sfm_ye <= 1'b0;
	  end
	  else if(cs[`SET_RD_PROT] | cs[`SET_RD_SMART]) begin
		 sfm_xe <= 1'b1;
		 sfm_ye <= 1'b1;
	  end
	  else if(cs[`NORMAL]) begin
		 sfm_xe <= csel;
		 sfm_ye <= op_read | op_prog;
	  end
   end // always@ (posedge clk or negedge rstb)


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fm_se <= 1'b0;
	  else if(cs[`NORMAL])
		fm_se <= op_read;
	  else if(cs[`SET_RD_PROT] | cs[`WAIT_RD_PROT] |
			  cs[`SET_RD_SMART] | cs[`WAIT_RD_SMART])
		fm_se <= 1'b1;
   end

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 fm_prog <= 1'b0;
		 fm_erase <= 1'b0;
		 fm_mas1 <= 1'b0;
		 fm_nvstr <= 1'b0;
	  end
	  else if(cs[`NORMAL]) begin
		 if(op_berase) begin  // both erase. simular mass erase
			fm_prog <= 1'b0;
			fm_erase <= 1'b1;
			fm_mas1 <= 1'b1;
			fm_nvstr <= 1'b1;
		 end
		 else if(op_perase) begin  // page erase
			fm_prog <= 1'b0;
			fm_erase <= 1'b1;
			fm_mas1 <= 1'b0;
			fm_nvstr <= 1'b1;
		 end
		 else if(op_prog) begin // word program
			fm_prog <= 1'b1;
			fm_erase <= 1'b0;
			fm_mas1 <= 1'b0;
			fm_nvstr <= 1'b1;
		 end
		 else begin
			fm_prog <= 1'b0;
			fm_erase <= 1'b0;
			fm_mas1 <= 1'b0;
			fm_nvstr <= 1'b0;
		 end
	  end // if (cs[`NORMAL])
	  else begin
		 fm_prog <= 1'b0;
		 fm_erase <= 1'b0;
		 fm_mas1 <= 1'b0;
		 fm_nvstr <= 1'b0;
	  end // else: !if(cs[`NORMAL])
   end // always@ (posedge clk or negedge rstb)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fm_ifren <= 1'b0;
	  else if(cs[`NORMAL]) begin
		 if(op_berase )
		   fm_ifren <= 1'b1;
		 else if(op_perase) 
		   fm_ifren <= 1'b0;
		 else // read and program
		   fm_ifren <= ifren;
	  end
	  else fm_ifren <= 1'b1;
   end // always@ (posedge clk or negedge rstb)
   
   
   //------------------------------------------------------
   // synopsys translate_off

   wire      sm_start = cs[`START];
   wire 	 sm_wait0 = cs[`WAIT0];
   wire 	 sm_wait0 = cs[`WAIT1];
   wire 	 sm_wait0 = cs[`WAIT2];
   wire      sm_set_rd_prot = cs[`SET_RD_PROT];
   wire      sm_wait_rd_prot = cs[`WAIT_RD_PROT];
   wire      sm_set_rd_smart = cs[`SET_RD_SMART];
   wire      sm_wait_rd_smart = cs[`WAIT_RD_SMART];
   wire      sm_normal = cs[`NORMAL];
   
   // synopsys translate_on
   //------------------------------------------------------
   
endmodule // ifmc_fmb
