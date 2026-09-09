/*
     sram interface model
 
     Project : MMC
 
     created by gtlee
 
     date : 2007.6.15
 
     history :
 
     note :
 
 */


module  si_model
  (
   rstb              ,
   clk_sys           ,
   
   si_addr           ,
   si_wdata          ,
   si_rdata          ,
   si_beb            ,
   si_wrb            ,
   si_rdb            ,
   si_rdyb           ,
   si_err            
   );
   parameter               SIADDR_WIDTH = 12;
   
   input 				   rstb;
   input 				   clk_sys;   // clock for the system
   
   // SRAM buffer interface signals
   input [SIADDR_WIDTH-1:0] si_addr;
   input [31:0] 		   si_wdata;
   output [31:0] 		   si_rdata;
   input [3:0] 			   si_beb;
   input 				   si_wrb;
   input 				   si_rdb;
   output 				   si_rdyb;
   output 				   si_err; // for the write protection
   
   //---------------------------------------------------------------
   // internal signals
   reg [1:0] 			   byte_cnt; // word를 byte단위로 나눴을때 byte number
   reg [SIADDR_WIDTH-1:0]  addr;
   reg [23:0] 			   rdata;
   reg 					   wrb;

   reg [2:0] 			   wbeb;
   reg                     beb;
   
   wire [SIADDR_WIDTH-1:0] ram_addr;
   wire [7:0] 			   ram_rdata;
   reg [7:0] 			   ram_wdata;
   
   wire 				   ram_csb;
   wire 				   ram_wrb;
 
   wire [31:0] 			   si_rdata;


   //----------------------------------------------------
   // State Machine
   parameter 			   SI_IDLE = 0;
   parameter               SI_RUN = 1;
   parameter 			   SI_SM_NUM = SI_RUN + 1;

   parameter               SI_SM_INIT = {{(SI_SM_NUM-1){1'b0}},1'b1};

   parameter 			   SI_ST_IDLE = (SI_SM_INIT << SI_IDLE);
   parameter 			   SI_ST_RUN = (SI_SM_INIT << SI_RUN);

   reg [SI_SM_NUM-1:0] 	   si_cs, si_ns;

   // states
   wire 				   si_sm_idle = si_cs[SI_IDLE];
   wire 				   si_sm_run =  si_cs[SI_RUN];
   //


   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) si_cs <= SI_ST_IDLE;
	  else si_cs <= si_ns;
   end

   always@(si_cs or si_rdb or si_wrb or byte_cnt) begin
	  case(1'b1)
		si_cs[SI_IDLE] : begin
		   if(~(si_rdb & si_wrb))
			 si_ns <= SI_ST_RUN;
		   else si_ns <= SI_ST_IDLE;
		end
		si_cs[SI_RUN] : begin
		   if(byte_cnt == 2'h3 && (si_rdb & si_wrb))
			 si_ns <= SI_ST_IDLE;
		   else si_ns <= SI_ST_RUN;
		end
		default : si_ns <= SI_ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (si_cs or si_rdb or si_wrb or byte_cnt)
   
   
   // operation counter
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) byte_cnt <= 2'h0;
	  else if(si_sm_run) begin
		 byte_cnt <= byte_cnt + 2'h1;
	  end
	  else begin // if(si_sm_idle) 
		 if(~(si_rdb & si_wrb))
		   byte_cnt <= byte_cnt + 2'h1;
		 else byte_cnt <= 2'h0;
	  end
   end // always@ (posedge clk_sys or negedge rstb)

   // packing read data
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) rdata <= {24{1'b0}};
	  else if(~si_wrb) rdata <= si_wdata[31:8]; // latch for write
	  else if(wrb & si_sm_run) begin
		 rdata <= {ram_rdata,rdata[23:8]};
	  end
   end // always rdata


   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) addr <= 0;
	  else if(byte_cnt == 2'h0) addr <= {si_addr[SIADDR_WIDTH-1:2],2'h1};
	  else addr <= addr + 1;
   end // always addr


   assign ram_addr = (byte_cnt == 2'h0)?
					 {si_addr[SIADDR_WIDTH-1:2],2'h0} : addr;
   

   always@(ram_addr or si_wdata or rdata) begin
	  case(ram_addr[1:0])
		2'h0 : ram_wdata <= si_wdata[7:0];
		2'h1 : ram_wdata <= rdata[7:0];
		2'h2 : ram_wdata <= rdata[15:8];
		default : ram_wdata <= rdata[23:16];
	  endcase // case(ram_addr[1:0])
   end // always ram_wdata

   // Byte enable
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) wbeb <= 3'h7;
	  else if(~si_wrb) wbeb <= si_beb[3:1];
   end // always wbeb
   
   always@(ram_addr or si_beb or wbeb) begin
	  case(ram_addr[1:0])
		2'h0 : beb <= si_beb[0];
		2'h1 : beb <= wbeb[0];
		2'h2 : beb <= wbeb[1];
		default : beb <= wbeb[2];
	  endcase // case(ram_addr[1:0])
   end // always 
		   
   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) wrb <= 1'b1;
	  else if(byte_cnt == 2'h0) wrb <= si_wrb;
   end // always wrb
   
   assign ram_wrb = ((wrb | (~si_sm_run)) & si_wrb) | beb;

   assign ram_csb = si_wrb & si_rdb & (~si_sm_run);
   
   SSRAM8bit  #(SIADDR_WIDTH)  sram
	 (
	  .CLK     ( clk_sys ), 
	  
	  .ADDR    ( ram_addr ),
	  .CEn     ( ram_csb ),
	  .WEn     ( ram_wrb ),
	  .RDATA   ( ram_rdata ),
	  .WDATA   ( ram_wdata )
	  );


   assign si_rdata = {ram_rdata, rdata};
   assign si_err = 1'b0;
   assign si_rdyb = (si_sm_idle && byte_cnt == 2'h0)? 1'b0 : 1'b1;

   
  
   //-------------------------------------------------------
   reg 	       rdb_dly;

   always@(posedge clk_sys or negedge rstb) begin
	  if(~rstb) rdb_dly <= 1'b1;
	  else if(si_rdyb == 1'b0) rdb_dly <= si_rdb;
   end // always rdb_dly
   


   integer 	   wr_file_ram;
   integer 	   rd_file_ram;

   initial     wr_file_ram = $fopen("wr_file_ram.log");
   initial     rd_file_ram = $fopen("rd_file_ram.log");

   always@(posedge clk_sys or negedge rstb) begin
	  if(si_wrb == 1'b0) begin // at write
		 if(ram_wrb == 1'b0) begin
			$display("Write Operation SRAM");
			
			$display(             "%tns Address : %h Data : %h",$time,si_addr,si_wdata);
			$fdisplay(wr_file_ram,"%tns Address : %h Data : %h",$time,si_addr,si_wdata);
		 end
	  end
	  else begin
		 if(rdb_dly == 1'b0) begin
			$display("Read Operation SRAM");
			
			$display(             "%tns Address : %h Data : %h",$time,si_addr,si_rdata);
			$fdisplay(rd_file_ram,"%tns Address : %h Data : %h",$time,si_addr,si_rdata);
		 end // else: !if(si_wrb == 1'b0)
	  end // else: !if(si_wrb == 1'b0)
   end // always@ (posedge clk_card or negedge rstb)

  

endmodule // si_model

