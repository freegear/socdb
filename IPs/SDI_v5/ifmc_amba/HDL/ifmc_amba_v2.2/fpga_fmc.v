/************************************************************
   FPGA Top for Flash memory controller
  
   file name : fpga_fmc.v
 
   created by gtlee
 
   date : 2006.3.30
 
   note :

 ************************************************************/
`timescale 1ns/1ns




module     fpga_fmc
  (
   clk                ,
   rstb               ,

   tmode              ,
   scl                ,
   sda                ,

   tool_mode          ,

   sm_idle            ,
   sm_initialize      ,
   sm_get_addr        ,
   sm_addr_dummy      ,
   sm_clr_counter     ,
   sm_get_data        ,
   sm_data_dummy      ,
   sm_stop            ,
   scl_in             ,
   sda_o            ,
   scl_lpf            ,
   sda_lpf            ,

   sda_oeb			  ,

   clkout             ,
   rstbout			  ,

   fmr_rd			  ,
   rdp	
   );
   
   input               clk;
   input 			   rstb;

   input 			   tmode;
   input 			   scl;
   inout 			   sda;
   
   output 			   tool_mode;
   
   // for FPGA
   output 			   sm_idle;
   output 			   sm_initialize;
   output 			   sm_get_addr;
   output 			   sm_addr_dummy;
   output 			   sm_clr_counter;
   output 			   sm_get_data;
   output 			   sm_data_dummy;
   output 			   sm_stop;

   output   		   scl_in;
   output 			   sda_o;
   output   		   scl_lpf;
   output 			   sda_lpf;
   
   output			   sda_oeb;

   output              clkout;
   output 			   rstbout;
   output			   fmr_rd;
   output			   rdp;
   
   //------------------------------------   
   wire 			   sda;
   wire	 			   sda_in;
   wire 			   sda_out;
   wire 			   sda_oeb;
   
   wire 			   ahb_sel = 0;
   wire 			   ahb_readyin = 0;
   wire [1:0] 		   ahb_trans = 0;
   wire [17:0] 		   ahb_addr = 0;
   wire 			   ahb_write = 0;
   wire [2:0] 		   ahb_size = 0;
   
   wire [31:0] 		   ahb_rdata;
   wire 			   ahb_ready = 0;
   wire [1:0] 		   ahb_resp = 0;
   
   // apb
   wire 			   apb_enable = 0;
   wire 			   apb_sel = 0;
   wire [5:0] 		   apb_addr = 0;
   wire 			   apb_write = 0;
   wire [31:0] 		   apb_wdata = 0;
   wire [31:0] 		   apb_rdata;
   
   
   // Flash Memory Test Pin
   wire 			   fmt_en = 0;  // flash memory test enable
   wire 			   fmt_tmr = 0;
   wire 			   fmt_vpp = 0;
   wire [2:0] 		   fmt_tm = 0;
   wire 			   fmt_mas1 = 0;
   wire 			   fmt_ifren = 0;
   wire 			   fmt_xe = 0;
   wire 			   fmt_ye = 0;
   wire 			   fmt_erase = 0;

   wire 			   fmt_se = 0;
   wire 			   fmt_nvstr = 0;
   wire 			   fmt_prog = 0;
   wire [9:0] 		   fmt_xadr = 0;
   wire [5:0] 		   fmt_yadr = 0;
   wire [31:0] 		   fmt_din = 0;
   wire [31:0] 		   fmt_dout;
   wire 			   fmt_oeb;

   wire	 			   scl_in;
   wire	 			   sda_o;
   wire 			   scl_lpf;
   wire 			   sda_lpf;

   wire 			   clkout;
   wire 			   rstbout;
   
   assign 			   clkout = clk;
   assign 			   rstbout = ~rstb;
   
   
   assign 			   scl_in = scl;
   
   //assign 			   sda = (sda_oeb)?1'bz : sda_out;
   assign			   sda_o = sda_out;	
   assign              sda = (sda_oeb == 1'b0 && sda_out == 1'b0)?1'b0 : 1'bz;
   
   assign 			   sda_in = sda;
 //  always@(posedge clk or negedge rstb) sda_ino <= sda_in;
   

   //-----------------------------------------------------
   ifmc_top    Top
	 (
	  .clk                   ( clk ),
	  .apb_clk               ( clk ),
	  .rstb                  ( rstbout ),

	  .tmode                 ( tmode ),
	  .scl                   ( scl ),
	  .sda_in                ( sda_in ),
	  .sda_out               ( sda_out ),
	  .sda_oeb               ( sda_oeb ),
	  .tool_mode             ( tool_mode ),
	  
	  .ahb_sel               ( ahb_sel ),
	  .ahb_readyin           ( ahb_readyin ),
	  .ahb_trans             ( ahb_trans ),
	  .ahb_addr              ( ahb_addr[17:2] ),
	  .ahb_write             ( ahb_write ),
	  .ahb_size              ( ahb_size ),
	  
	  .ahb_rdata             ( ahb_rdata ),
	  .ahb_ready             ( ahb_ready ),
	  .ahb_resp              ( ahb_resp ),
	  
	  .apb_enable            ( apb_enable ),
	  .apb_sel               ( apb_sel ),
	  .apb_addr              ( apb_addr[5:2] ),
	  .apb_write             ( apb_write ),
	  .apb_wdata             ( apb_wdata ),
	  .apb_rdata             ( apb_rdata ),
	  
	  // Flash memory test pins
	  .fmt_en                ( fmt_en ),
	  .fmt_tmr               ( fmt_tmr ),
	  .fmt_vpp               ( fmt_vpp ),
	  .fmt_tm                ( fmt_tm ),
	  .fmt_mas1              ( fmt_mas1 ),
	  .fmt_ifren             ( fmt_ifren ),
	  .fmt_xe                ( fmt_xe ),
	  .fmt_ye                ( fmt_ye ),
	  .fmt_erase             ( fmt_erase ),

	  .fmt_se                ( fmt_se ),
	  .fmt_nvstr             ( fmt_nvstr ),
	  .fmt_prog              ( fmt_prog ),
	  .fmt_xadr              ( fmt_xadr ),
	  .fmt_yadr              ( fmt_yadr ),
	  .fmt_din               ( fmt_din ),
	  .fmt_dout              ( fmt_dout ),
	  .fmt_oeb               ( fmt_oeb ),

	  .sm_idle               ( sm_idle ),
	  .sm_initialize         ( sm_initialize ),
	  .sm_get_addr           ( sm_get_addr ),
	  .sm_addr_dummy         ( sm_addr_dummy ),
	  .sm_clr_counter        ( sm_clr_counter ),
	  .sm_get_data           ( sm_get_data ),
	  .sm_data_dummy         ( sm_data_dummy ),
	  .sm_stop               ( sm_stop ),
	  .scl_lpf               ( scl_lpf ),
	  .sda_lpf               ( sda_lpf ),
	  .fmr_rd				 ( fmr_rd  ),
	  .rdp    				 ( rdp     )
	  );
   
endmodule // fpga_fmc
