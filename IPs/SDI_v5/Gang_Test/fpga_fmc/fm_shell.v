/*
    Shell of sram that is emulated Flash memory
 
    filename : fm_shell.v
 
    date : 2006.3.23
 
    created by : gtlee
 
    history :
 
 
    note :
 
 
 */


module   fm_shell
  (
   clk             ,
   rstb            ,
   XADR            ,
   YADR            ,
   DIN             ,
   DOUT            ,
   XE              ,
   YE              ,
   SE              ,
   ERASE           ,
   MAS1            ,
   PROG            ,
   NVSTR           ,
   IFREN           ,
   TMR             ,
   VPP             ,
   TM              
   );

   //begin parameter
   parameter              numAddrX = 10;
   parameter 			  numAddrY = 6;
   parameter 			  numTM = 3;
   parameter 			  numOut = 32;
   //end parameter
   
   // IO ports
   input 				  clk;
   input 				  rstb;
   
   input 				  XE;
   input 				  YE;
   input 				  SE;
   input 				  ERASE;
   input 				  MAS1;
   input 				  PROG;
   input 				  NVSTR;
   input 				  IFREN;
   input [numAddrX-1:0]   XADR;
   input [numAddrY-1:0]   YADR;
   input [numOut-1:0] 	  DIN;
   output [numOut-1:0] 	  DOUT;
   
   // test mode IO ports
   input 				  TMR;
   inout 				  VPP;
   inout [numTM-1:0] 	  TM;


   //-------------------------------------------------------------
   // 
   wire [numOut-1:0] 	  DOUT;
   wire 				  VPP;
   wire [numTM-1:0] 	  TM;

   
   wire [31:0] 			  data_i;
   wire [31:0] 			  data_o_i; // infor
   wire [31:0] 			  data_o_m; // mass
   wire [15:0] 			  addr;

   reg 					  we_n;
   reg 					  rd_n;
   reg 					  cs_n_m; // mass storage
   reg 					  cs_n_i; // information

   // timer
   reg [23:0] 			  tcnt; // time counter
   wire                   p_min; // min보다 크면 1
   wire 				  p_max; // max보다 크면 1
   //wire 				  e_min; // min보다 크면 1
   //wire 				  e_max; // max보다 크면 1
   

   assign 				  addr = (ERASE)?tcnt[15:0]:{XADR, YADR};
   assign 				  data_i = (ERASE)?{32{1'b1}}:DIN;
   assign 				  DOUT = (IFREN)?data_o_i:data_o_m;

   
   ssram #(13,32) ssram_mass(clk, data_i,data_o_m, addr[12:0], we_n, rd_n, cs_n_m);
   ssram #(9,32)  ssram_info(clk, data_i,data_o_i, addr[8:0], we_n, rd_n, cs_n_i);
//   ssram #(16,32) ssram_mass(clk, data_i,data_o_m, addr[15:0], we_n, rd_n, cs_n_m);
//   ssram #(9,32)  ssram_info(clk, data_i,data_o_i, addr[8:0], we_n, rd_n, cs_n_i);

   
   always@(XE or YE or SE or PROG or ERASE or NVSTR or IFREN or
		   p_min or p_max ) begin
	  if(XE & YE & SE) begin
		 // read sequence
		 cs_n_m <= IFREN;
		 cs_n_i <= ~IFREN;
		 we_n   <= 1'b1;
		 rd_n   <= 1'b0;
	  end // read
	  else if(XE & YE & PROG & NVSTR) begin
		 // word programming
		 // need timing check
		 cs_n_m <= IFREN;
		 cs_n_i <= ~IFREN;
		 rd_n   <= 1'b1;
		 if(p_min & (~p_max))
		   we_n <= 1'b0;
		 else we_n <= 1'b1;
	  end // prog
	  else if(XE & ERASE & NVSTR) begin
		 cs_n_m <= 1'b0;
		 cs_n_i <= ~IFREN;
		 rd_n   <= 1'b1;
		 we_n   <= 1'b0;
	  end // erase
	  else begin
		 cs_n_m <= 1'b1;
		 cs_n_i <= 1'b1;
		 rd_n   <= 1'b1;
		 we_n   <= 1'b1;
	  end // else: !if(XE & ERASE & NVSTR)
   end // always@ (XE or YE or SE or PROG or ERASE or NVSTR or IFREN or...
   
   
   //-----------------------------------------------
   // timing check

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  tcnt <= {24{1'b0}};
	  else if((PROG & YE) | (ERASE & NVSTR))
		tcnt <= tcnt + {{23{1'b0}},1'b1};
	  else  tcnt <= {24{1'b0}};
   end // always

   // at 10Mhz
   assign p_min = (tcnt > 24'h0000C8)?1'b1:1'b0;
   assign p_max = (tcnt > {23'h0000C8,1'b0})?1'b1:1'b0;
    
   
endmodule // fm_shell

