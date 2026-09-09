/************************************************************
   Register file of Flash memory controller
  
   Flash erase/programming 정보 보관.
 
   file name : ifmc_reg.v
 
   created by gtlee
 
   date : 2006.3.3
 
   note :

 ************************************************************/


module  ifmc_reg
  (
   apb_clk              ,
   apb_rstb             ,
   
   apb_enable           ,
   apb_sel              ,
   apb_addr             ,
   apb_write            ,
   apb_wdata            ,
   apb_rdata            ,
   
   fm_wrmode            ,
   clr_fmreg            ,
   
   hdp                  ,
   rdp                  ,
   smart                ,
   
   key_hit              ,
   fmaddr               ,
   fmdata               ,
   fmucon               ,
   rdwaitcycle          ,
   info_rd              ,
   
   tnvs                 ,
   tnvh                 ,
   tpgs                 ,
   tpgh                 ,
   trcv                 ,
   tnvh1                ,
   tprog                ,
   terase               ,
   tme                  ,
   
   pscal_value            
   );

   input             apb_clk;
   input 			 apb_rstb;

   input 			 apb_enable;
   input 			 apb_sel;
   input [5:2] 		 apb_addr;
   input 			 apb_write;
   input [31:0] 	 apb_wdata;
   output [31:0] 	 apb_rdata;

   input 			 fm_wrmode;   // active during erase/program
   input 			 clr_fmreg;   // active when operation is ended.

   // protection information
   input 			 hdp;
   input 			 rdp;
   input [15:0] 	 smart;
   
   output 			 key_hit;   // key register hit/miss
   output [31:0] 	 fmaddr;
   output [31:0] 	 fmdata;
   output [7:0] 	 fmucon;
   output [1:0] 	 rdwaitcycle;
   output 			 info_rd;
   
   output [15:0] 	 tnvs;
   output [15:0] 	 tnvh;
   output [15:0] 	 tpgs;
   output [15:0] 	 tpgh;
   output [15:0] 	 trcv;
   output [15:0] 	 tnvh1;
   output [15:0] 	 tprog;
   output [31:0] 	 terase;
   output [31:0] 	 tme;

   output [6:0] 	 pscal_value;
   
   //----------------------------------------------------------
   parameter 		 KEY_VALUE  =  32'h5A5A5A5A;
   
   parameter 		 TNVS_US    =  16'h003F;
   parameter 		 TNVH_US    =  16'h003F;
   parameter 		 TPGS_US    =  16'h007E;
   parameter 		 TPGH_NS    =  16'h0003;  // clock count. ns단위.
   parameter 		 TRCV_US    =  16'h000E;
   parameter 		 TNVH1_US   =  16'h04EA;
   parameter 		 TPROG_US   =  16'h00FB;
   parameter 		 TERASE_US  =  32'h0003D090;
   parameter 		 TME_US     =  32'h0003D090;
   
   parameter 		 PSCALE_NS  =  7'h05;
   
   // register file
   wire 			 key_hit;
   reg [31:0] 		 fmkey;
   reg [31:0] 		 fmaddr;
   reg [31:0] 		 fmdata;
   reg [7:0] 		 fmucon;
   reg [1:0] 		 rdwaitcycle;
   reg 				 info_rd;
   
   wire [15:0] 		 tnvs;  // 0 h
   wire [15:0] 		 tnvh;  // 0 l
   wire [15:0] 		 tpgs;  // 1 h
   wire [15:0] 		 tpgh;  // 1 l    // 20ns
   wire [15:0] 		 trcv;  // 2 h
   wire [15:0] 		 tnvh1; // 2 l
   wire [15:0] 		 tprog; // 3 l
   wire [6:0] 		 pscal_value;  // 3 h
   wire [31:0] 		 terase;// 4
   wire [31:0] 		 tme;   // 5

   reg [31:0] 		 treg[0:5];  // timing reg

   wire [31:0] 		 treg_0 = treg[0];
   wire [31:0] 		 treg_1 = treg[1];
   wire [31:0] 		 treg_2 = treg[2];
   wire [31:0] 		 treg_3 = treg[3];
   wire [31:0] 		 treg_4 = treg[4];
   wire [31:0] 		 treg_5 = treg[5];
   
   
   // apb control
   wire 			 reg_wr;
   //wire 			 reg_rd;
   reg [31:0] 		 rdata;
   
   wire [31:0] 		 apb_rdata;

   //----------------------------------------------
   // APB operation
   assign reg_wr = (apb_enable & apb_sel & apb_write);
   //assign reg_rd = (             apb_sel & ~apb_write);

   // apb write
   always@(posedge apb_clk or negedge apb_rstb) begin
	  if(~apb_rstb) begin
		 // reset valuexs
		 fmkey  <= {32{1'b0}};
		 fmaddr <= {32{1'b0}};
		 fmdata <= {32{1'b0}};
		 fmucon <= {8{1'b0}};
		 rdwaitcycle <= 2'h3;
		 info_rd <= 1'b0;
	  end
	  else if(clr_fmreg == 1'b1) begin // clear registers after erase/programming
		 fmkey  <= {32{1'b0}};
		 fmucon <= {8{1'b0}};
	  end
	  else if(reg_wr == 1'b1 && fm_wrmode == 1'b0 && apb_addr[5:4] == 2'b00) begin // write to bank reg
		 case(apb_addr[3:2])   // synopsys parallel_case
		   2'b00 : fmkey <= apb_wdata;
		   2'b01 : fmaddr <= apb_wdata;
		   2'b10 : fmdata <= apb_wdata;
		   default : begin
			  fmucon <= apb_wdata[7:0];
			  rdwaitcycle <= apb_wdata[9:8];
			  info_rd <= apb_wdata[10];
		   end
		 endcase // case(apb_addr[3:2])
	  end
   end // always@ (posedge apb_clk or negedge apb_rstb)

   
   //    write timing registers
   always@(posedge apb_clk or negedge apb_rstb) begin
	  if(~apb_rstb) begin
		 // reset valuexs
		 treg[0] <= {TNVS_US, TNVH_US};
		 treg[1] <= {TPGS_US, TPGH_NS};
		 treg[2] <= {TRCV_US, TNVH1_US};
		 treg[3] <= {9'h000, PSCALE_NS, TPROG_US};
		 treg[4] <= TERASE_US;
		 treg[5] <= TME_US;
	  end
	  else if(reg_wr == 1'b1 && fm_wrmode == 1'b0 && apb_addr[5] == 1'b1) 
		begin // write to bank reg
		   case(apb_addr[4:2])  // synopsys parallel_case
			 3'h0 : treg[0] <= apb_wdata;
			 3'h1 : treg[1] <= apb_wdata;
			 3'h2 : treg[2] <= apb_wdata;
			 3'h3 : treg[3] <= apb_wdata;
			 3'h4 : treg[4] <= apb_wdata;
			 3'h5 : treg[5] <= apb_wdata;
		   endcase // case(apb_addr[4:2])
		end // if (reg_wr == 1'b1 && fm_wrmode == 1'b0 && apb_addr[5] == 1'b1)
   end // always@ (posedge apb_clk or negedge apb_rstb)
   

   // apb read
   always@(posedge apb_clk or negedge apb_rstb) begin
	  if(~apb_rstb) rdata <= {32{1'b0}};
	  else begin
		 if(apb_addr[5] == 1'b0) begin
			case(apb_addr[4:2])   // synopsys parallel_case
			  3'h0 : rdata <= fmkey;
			  3'h1 : rdata <= fmaddr;
			  3'h2 : rdata <= fmdata;
			  3'h3 : rdata <= {{21{1'b0}},info_rd,rdwaitcycle,fmucon};
			  3'h4 : rdata <= {{16{1'b1}},smart};
			  3'h5 : rdata <= {4'h0,rdp,9'h000,hdp,{17{1'b0}}};
			  default : rdata <= {32{1'b0}};
			endcase // case(apb_addr[3:2])
		 end // if (apb_addr[5] == 1'b0)
		 else begin
			if(apb_addr[4] == 1'b0)	
			  rdata <= treg[{1'b0,apb_addr[3:2]}];
			else if(apb_addr[2] == 1'b0)
			  rdata <= treg[4];
			else rdata <= treg[5];
		 end // else: !if(apb_addr[5] == 1'b0)
	  end // else: !if(~apb_rstb)
   end // always@ (posedge apb_clk or negedge apb_rstb)
   
   assign         apb_rdata = rdata;

   assign 		  key_hit = (fmkey == KEY_VALUE)? 1'b1 : 1'b0;
   
   // Mapping Timing register
   assign 		  tnvs = treg_0[31:16];
   assign 		  tnvh = treg_0[15:0];
   assign 		  tpgs = treg_1[31:16];
   assign 		  tpgh = treg_1[15:0];
   assign 		  trcv = treg_2[31:16];
   assign 		  tnvh1 = treg_2[15:0];
   assign 		  tprog = treg_3[15:0];
   assign 		  terase = treg_4;
   assign 		  tme = treg_5;

   assign         pscal_value = treg_3[22:16];
   
endmodule // ifmc_reg


