/*
 Register block for SMC

 Interface : APB
  
 modify : 2006.2.21
 
 note :
     clk을 peri clock으로 교체.
     boot mode에 따라 bank0는 mapping address가 달라진다.
     APB는 항상 32bit single operation mode.
     AHB는 byte단위 access가능, 2 phase mode.
 */
 


module   reg_smc
  (
   apb_clk              ,
   apb_rstb             ,
   
   apb_enable           ,
   apb_sel              ,
   apb_addr             ,
   apb_write            ,
   apb_wdata            ,
   apb_rdata            ,

   ahb_write            ,
   ahb_bsel             ,
   ahb_act              ,
   
   dbus_width           ,
   adr_sft              ,
   adr_setup            ,
   cs_setup             ,
   acc_cycle            ,
   cs_hold              ,
   adr_hold                          
   );

   input           apb_clk;
   input 		   apb_rstb;

   input 		   apb_enable;
   input 		   apb_sel;
   input [3:2] 	   apb_addr;
   input 		   apb_write;
   input [31:0]    apb_wdata;
   output [31:0]   apb_rdata;

   // ahb bus 신호를 바로 갖고 오지 않아야함.
   // latched signal을 사용
   input 		   ahb_write;
   input [3:0] 	   ahb_bsel;
   input 		   ahb_act;
   
   // to sram controller
   output 		   dbus_width;
   output 		   adr_sft;    // address bit shift right 1. bank 0 & 3
   output [1:0]    adr_setup;
   output [1:0]    cs_setup;
   output [3:0]    acc_cycle;
   output [1:0]    cs_hold;
   output [1:0]    adr_hold;    // fixed to 1
   
   //----------------------------------------
   wire 		   dbus_width;
   wire 		   adr_sft;
   wire [1:0] 	   adr_setup;
   wire [1:0] 	   cs_setup;
   wire [3:0] 	   acc_cycle;
   wire [1:0] 	   cs_hold;
   wire [1:0] 	   adr_hold;
   
   reg [31:0] 	   rdata;
   wire [31:0] 	   apb_rdata;
   
   //---------------------------------------
   // internal signals
`define       BANK_REG_WIDTH    22
		  
   wire 		   reg_wr;
   wire 		   reg_rd;
   
   reg [`BANK_REG_WIDTH-1:0] bnkctrl[0:3];
   wire [`BANK_REG_WIDTH-1:0] rd_bnkctrl;
   
   wire [`BANK_REG_WIDTH-1:0] bnkctrl_0;
   wire [`BANK_REG_WIDTH-1:0] bnkctrl_1;
   wire [`BANK_REG_WIDTH-1:0] bnkctrl_2;
   wire [`BANK_REG_WIDTH-1:0] bnkctrl_3;

   reg [`BANK_REG_WIDTH-1:0] sel_bnkctrl;

   reg [`BANK_REG_WIDTH-1:0] bnkctrl_eff[0:3];

   assign		 bnkctrl_0 = bnkctrl_eff[0];
   assign		 bnkctrl_1 = bnkctrl_eff[1];
   assign		 bnkctrl_2 = bnkctrl_eff[2];
   assign		 bnkctrl_3 = bnkctrl_eff[3];
   
   integer       i;
   
   //----------------------------------------------
   // APB operation
   assign reg_wr = (apb_enable & apb_sel & apb_write);
   assign reg_rd = (             apb_sel & ~apb_write);

   
   // write to the bank regiser
   always@(posedge apb_clk or negedge apb_rstb) begin
	  if(~apb_rstb) begin
		 // reset value
		 bnkctrl[0] <= 22'b11_11_1111_11_11_11_1111_11_1_1;
		 bnkctrl[1] <= 22'b10_10_0010_10_01_01_0001_01_0_1;
		 bnkctrl[2] <= 22'b10_10_0010_10_01_01_0001_01_0_1;
		 bnkctrl[3] <= 22'b10_10_0010_10_01_01_0001_01_1_1;
	  end
	  else if(reg_wr == 1'b1) begin // write to bank reg
		 bnkctrl[apb_addr[3:2]] <= {apb_wdata[27:18],apb_wdata[11:0]};
	  end
   end

   // register read operation
   assign   rd_bnkctrl = (reg_rd) ? bnkctrl[apb_addr[3:2]] : {`BANK_REG_WIDTH{1'b0}};
   
   always@(posedge apb_clk or negedge apb_rstb) begin
	  if(~apb_rstb) rdata <= {32{1'b0}};
	  else rdata <= {4'h0,rd_bnkctrl[21:12],6'h00,rd_bnkctrl[11:0]};
   end

   assign apb_rdata = rdata;
      
   //-------------------------------------------
   // Bank selection
   // control register를 유지하기 위해서 FF으로 만듬.

   // bank0 reg : 0x01FF8100
   // bank1 reg : 0x01FF8104
   // bank2 reg : 0x01FF8108
   // bank3 reg : 0x01FF810C


   always@(posedge apb_clk or negedge apb_rstb) begin
	  if(~apb_rstb) begin
		 for(i=0;i<4;i=i+1)
		   bnkctrl_eff[i] <= {`BANK_REG_WIDTH{1'b1}};
	  end
	  else if(~ahb_act) begin
		 for(i=0;i<4;i=i+1)
		   bnkctrl_eff[i] <= bnkctrl[i];
	  end
   end // always
   
   // select sram control signal
   always@(ahb_bsel or bnkctrl_0 or bnkctrl_1 or bnkctrl_2 or bnkctrl_3 ) begin
	  case(ahb_bsel)   // synopsys parallel_case
		4'b0001 : sel_bnkctrl <= bnkctrl_0;
		4'b0010 : sel_bnkctrl <= bnkctrl_1;
		4'b0100 : sel_bnkctrl <= bnkctrl_2;
		default : sel_bnkctrl <= bnkctrl_3;
	  endcase // case(ahb_bsel)
   end
   

   assign    adr_setup  = (ahb_write)? sel_bnkctrl[11:10] : sel_bnkctrl[21:20];
   assign    cs_setup   = (ahb_write)? sel_bnkctrl[9:8] : sel_bnkctrl[19:18];
   assign    acc_cycle  = (ahb_write)? sel_bnkctrl[7:4] : sel_bnkctrl[17:14];
   assign    cs_hold    = (ahb_write)? sel_bnkctrl[3:2] : sel_bnkctrl[13:12];
   assign    adr_sft    = sel_bnkctrl[1];
   assign    dbus_width = sel_bnkctrl[0];
   assign    adr_hold   = 2'h1; // fixed
   
endmodule // reg_smc
