/************************************************************
   Sub processor control block
  
   file name : sp_ctrl.v
 
   created by gtlee
 
   date : 2006.6.19
 
   note :
        
   history :
 
 ************************************************************/
`timescale 1ns/10ps


module  sp_ctrl
  (
   clk              ,
   rstb             ,
   
   set_addr         ,
   acc_addr         ,
   write            ,
   wdata            ,
   read             ,
   rdata            ,
   run              ,

   bus_addr         ,
   fetch            ,
   restart          ,

   spc_cs           ,
   spc_addr         ,
   spc_read         ,
   spc_write        ,
   spc_dataout      ,
   spc_datain       
   );
   
   parameter                ADDRWIDTH = 16;
   parameter 				DATAWIDTH = 8;

   input 					clk;
   input 					rstb;

   // to APB interface
   input 					set_addr;
   input [ADDRWIDTH-1:0] 	acc_addr;

   input 					write; // assert when PENABLE actived at write
   input [DATAWIDTH-1:0] 	wdata;
   
   input 					read; // assert when PSEL actived at read
   output [DATAWIDTH-1:0] 	rdata;
   
   input 					run;   // sub processor run/stop

   // to/from sub processor
   input [ADDRWIDTH-1:0] 	bus_addr;
   input 					fetch;
   
   output 					restart;
   
   // to memory
   output 					spc_cs;
   output [ADDRWIDTH-1:0] 	spc_addr;
   output 					spc_read;
   output 					spc_write;
   output [DATAWIDTH-1:0] 	spc_dataout;
   input [DATAWIDTH-1:0] 	spc_datain;
   
   //=======================================================
   wire [DATAWIDTH-1:0] 	rdata;
   wire 					restart;
   wire 					spc_cs;
   reg [ADDRWIDTH-1:0] 		spc_addr;
   wire 					spc_read;
   wire 					spc_write;
   wire [DATAWIDTH-1:0] 	spc_dataout;
   
   wire 					rstvec;

   // State Machine
   parameter 				RUN_SM_WIDTH = 3;
   parameter 				RUN_SM_INIT = {{(RUN_SM_WIDTH-1){1'b0}},1'b1};

   parameter 				RUN = 0;
   parameter 				ACC = 1;
   parameter 				WAIT = 2;

   parameter 				ST_RUN = (RUN_SM_INIT << RUN);
   parameter                ST_ACC = (RUN_SM_INIT << ACC);
   parameter 				ST_WAIT = (RUN_SM_INIT << WAIT);
   
   reg [RUN_SM_WIDTH-1:0] 	cs, ns;
      

   //=======================================================

   // auto-increament address
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) spc_addr <= {ADDRWIDTH{1'b0}};
	  else if(set_addr) spc_addr <= acc_addr;
	  else if(write|read) spc_addr <= spc_addr + {{(ADDRWIDTH-1){1'b0}},1'b1};
   end // always
   
   assign          spc_dataout = wdata;
   assign 		   rdata = spc_datain;
   assign 		   spc_write = write;
   assign 		   spc_read = read;

   // sub processor control
   assign 		   rstvec = |bus_addr;
   
   // State machine
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  cs <= ST_ACC;
	  else cs <= ns;
   end

   always@(cs or run or fetch or rstvec) begin
	  case(1'b1)     // synopsys parallel_case
		cs[RUN] :
		  if(run == 1'b0) ns <= ST_ACC;
		  else ns <= ST_RUN;
		cs[ACC] :
		  if(run == 1'b1) ns <= ST_WAIT;
		  else ns <= ST_ACC;
		cs[WAIT] :
		  if(rstvec == 1'b0 && fetch == 1'b1) // get start address
			ns <= ST_RUN;
		  else ns <= ST_WAIT;
		default : ns <= ST_RUN;
	  endcase // case(1'b1)
   end // always@ (cs or run or fetch or rstvec)
   

   assign 		   restart = cs[ACC];
   assign 		   spc_cs = cs[ACC] | cs[WAIT];
   
endmodule // sp_ctrl
