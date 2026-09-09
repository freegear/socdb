/************************************************************
   Flash memory controller
  
   file name : ifmc_top.v
 
   created by gtlee
 
   date : 2006.3.4
 
   note :

 ************************************************************/


module     ifmc_top
  (
   clk                   ,
   apb_clk               ,
   rstb                  ,
   
   tmode                 ,
   scl                   ,
   sda_in                ,
   sda_out               ,
   sda_oeb               ,
   tool_mode             ,
   
   ahb_sel               ,
   ahb_readyin           ,
   ahb_trans             ,
   ahb_addr              ,
   ahb_write             ,
   ahb_size              ,
   
   ahb_rdata             ,
   ahb_ready             ,
   ahb_resp              ,
   
   apb_enable            ,
   apb_sel               ,
   apb_addr              ,
   apb_write             ,
   apb_wdata             ,
   apb_rdata             ,

   // Flash memory test pins
   fmt_en                ,
   fmt_tmr               ,
   fmt_vpp               ,
   fmt_tm                ,
   fmt_mas1              ,
   fmt_ifren             ,
   fmt_xe                ,
   fmt_ye                ,
   fmt_erase             ,
   
   fmt_se                ,
   fmt_nvstr             ,
   fmt_prog              ,
   fmt_xadr              ,
   fmt_yadr              ,
   fmt_din               ,
   fmt_dout              ,
   fmt_oeb               ,

   sm_idle               ,
   sm_initialize         ,
   sm_get_addr           ,
   sm_addr_dummy         ,
   sm_clr_counter        ,
   sm_get_data           ,
   sm_data_dummy         ,
   sm_stop               ,
   scl_lpf               ,
   sda_lpf				 ,
   fmr_rd				 ,
   rdp
   );

   input 				   clk;
   input 				   apb_clk;
   input 				   rstb;

   input 				   tmode;
   input 				   scl;
   input 				   sda_in;
   output 				   sda_out;
   output 				   sda_oeb;
   output 				   tool_mode;
   
   input 				   ahb_sel;
   input 				   ahb_readyin;
   input [1:0] 			   ahb_trans;
   input [17:2] 		   ahb_addr; // lsb는 bit 2에 해당.
   input 				   ahb_write;
   input [2:0] 			   ahb_size;

   output [31:0] 		   ahb_rdata;
   output 				   ahb_ready;
   output [1:0] 		   ahb_resp;

   // apb
   input 				   apb_enable;
   input 				   apb_sel;
   input [5:2] 			   apb_addr;  // lsb는 bit 2에 해당.
   input 				   apb_write;
   input [31:0] 		   apb_wdata;
   output [31:0] 		   apb_rdata;


   // Flash Memory Test Pin
   input 				   fmt_en;  // flash memory test enable
   input 				   fmt_tmr;
   inout 				   fmt_vpp;
   inout [2:0] 			   fmt_tm;
   input 				   fmt_mas1;
   input 				   fmt_ifren;
   input 				   fmt_xe;
   input 				   fmt_ye;
   input 				   fmt_erase;
   
   input 				   fmt_se;
   input 				   fmt_nvstr;
   input 				   fmt_prog;
   input [9:0] 			   fmt_xadr;
   input [5:0] 			   fmt_yadr;
   input [31:0] 		   fmt_din;
   output [31:0] 		   fmt_dout;
   output 				   fmt_oeb;
   
   // State Machine for FPGA
   output 				   sm_idle;
   output 				   sm_initialize;
   output 				   sm_get_addr;
   output 				   sm_addr_dummy;
   output 				   sm_clr_counter;
   output 				   sm_get_data;
   output 				   sm_data_dummy;
   output 				   sm_stop;
   output 				   scl_lpf;
   output 				   sda_lpf;

   output				   fmr_rd;
   output				   rdp;
   //-----------------------------------------
   // internal signals
   
   wire [31:0] 			   ahb_rdata;
   wire 				   ahb_ready;
   wire [1:0] 			   ahb_resp;

   wire [31:0] 			   apb_rdata;

   // from Bus
   wire [1:0] 			   rdwaitcycle;
   wire 				   info_rd; // for debugging. selcect info or main at read

   wire [15:0] 			   bfmr_adr;
   wire 				   bfmr_rd;

   wire 				   bfm_wrmode;
   wire [15:0] 			   bfmw_adr;
   wire 				   bfmw_xe;
   wire 				   bfmw_ye;
   wire 				   bfmw_se;
   wire 				   bfmw_erase;
   wire 				   bfmw_mas1;
   wire 				   bfmw_prog;
   wire 				   bfmw_nvstr;
   wire 				   bfmw_ifren;
   wire [31:0] 			   bfmw_din;

   // from Serial
   wire 				   tool_mode;
   wire 				   sda_out;
   wire 				   sda_oeb;
   

   wire [15:0] 			   sfmr_adr;
   wire 				   sfmr_rd;

   wire 				   sfm_wrmode;
   wire [15:0] 			   sfmw_adr;
   wire 				   sfmw_xe;
   wire 				   sfmw_ye;
   wire 				   sfmw_se;
   wire 				   sfmw_erase;
   wire 				   sfmw_mas1;
   wire 				   sfmw_prog;
   wire 				   sfmw_nvstr;
   wire 				   sfmw_ifren;
   wire [31:0] 			   sfmw_din;

   //-----------------------------------
   // FMB
   wire [15:0] 			   fmr_adr;
   wire 				   fmr_rd;
   wire [31:0] 			   fmr_rdata;
   wire 				   fmb_ready_1cb;  // no used
   wire 				   fmb_ready;
   

   // FM interface for write
   wire 				   fm_wrmode;
   wire [15:0] 			   fmw_adr;
   wire 				   fmw_xe;
   wire 				   fmw_ye;
   wire 				   fmw_se;
   wire 				   fmw_erase;
   wire 				   fmw_mas1;
   wire 				   fmw_prog;
   wire 				   fmw_nvstr;
   wire 				   fmw_ifren;
   wire [31:0] 			   fmw_din;

   // protection information. from FMB
   wire 				   hdp;
   wire 				   rdp;
   wire [15:0] 			   smart;

   // Flash Memory Core Pin
   wire [9:0] 			   fm_xadr;
   wire [5:0] 			   fm_yadr;
   wire 				   fm_xe;     // address enable
   wire 				   fm_ye;     // address enable
   wire 				   fm_se;     // sense amp
   wire 				   fm_erase;
   wire 				   fm_mas1;
   wire 				   fm_prog;
   wire 				   fm_nvstr;
   wire 				   fm_ifren;  // information block enable
   wire [31:0] 			   fm_din;
   wire [31:0] 			   fm_dout;

   // flash memory pin mux
   wire                    fmc_tmr;
   wire 				   fmc_nvstr;
   wire 				   fmc_se;
   wire 				   fmc_mas1;
   wire 				   fmc_ifren;
   wire 				   fmc_xe;
   wire 				   fmc_ye;
   wire 				   fmc_erase;

   wire 				   fmc_prog;
   wire [9:0] 			   fmc_xadr;
   wire [5:0] 			   fmc_yadr;
   wire [31:0] 			   fmc_din;

   wire [31:0] 			   fmt_dout;
   wire 				   fmt_oeb;
   wire 				   fmt_vpp;
   wire [2:0] 			   fmt_tm;

   // for FPGA
   wire 				  sm_idle;
   wire 				  sm_initialize;
   wire 				  sm_get_addr;
   wire 				  sm_addr_dummy;
   wire 				  sm_clr_counter;
   wire 				  sm_get_data;
   wire 				  sm_data_dummy;
   wire 				  sm_stop;
   wire 				  scl_lpf;
   wire 				  sda_lpf;

   // Flash memory test pin mux
   assign 	   fmc_tmr = (fmt_en)? fmt_tmr : 1'b1;
   assign	   fmc_nvstr = (fmt_en)? fmt_nvstr : fm_nvstr;
   assign      fmc_se = (fmt_en)? fmt_se : fm_se;
   assign 	   fmc_mas1 = (fmt_en)? fmt_mas1 : fm_mas1;
   assign 	   fmc_ifren = (fmt_en)? fmt_ifren : fm_ifren;
   assign      fmc_xe = (fmt_en)? fmt_xe : fm_xe;
   assign      fmc_ye = (fmt_en)? fmt_ye : fm_ye;
   assign 	   fmc_erase = (fmt_en)? fmt_erase : fm_erase;

   assign 	   fmc_prog = (fmt_en)? fmt_prog : fm_prog;
   assign 	   fmc_xadr = (fmt_en)? fmt_xadr : fm_xadr;
   assign 	   fmc_yadr = (fmt_en)? fmt_yadr : fm_yadr;
   assign      fmc_din = (fmt_en)? fmt_din : fm_din;
   assign 	   fmt_dout = fm_dout;
   assign 	   fmt_oeb = (fmt_en)? ~fmt_se : 1'b1;

   // To FMB
   assign 	   fmr_adr = (tool_mode)? sfmr_adr : bfmr_adr;
   assign      fmr_rd  = (tool_mode)? sfmr_rd : bfmr_rd;
   assign 	   fm_wrmode = (tool_mode)? sfm_wrmode : bfm_wrmode;
   assign 	   fmw_adr = (tool_mode)? sfmw_adr : bfmw_adr;
   assign 	   fmw_xe = (tool_mode)? sfmw_xe : bfmw_xe;
   assign 	   fmw_ye = (tool_mode)? sfmw_ye : bfmw_ye;
   assign 	   fmw_se  = (tool_mode)? sfmw_se : bfmw_se;
   assign 	   fmw_erase = (tool_mode)? sfmw_erase : bfmw_erase;
   assign 	   fmw_mas1 = (tool_mode)? sfmw_mas1 : bfmw_mas1;
   assign 	   fmw_prog = (tool_mode)? sfmw_prog : bfmw_prog;
   assign 	   fmw_nvstr = (tool_mode)? sfmw_nvstr : bfmw_nvstr;
   assign 	   fmw_ifren = (tool_mode)? sfmw_ifren : bfmw_ifren;
   assign 	   fmw_din = (tool_mode)? sfmw_din : bfmw_din;


   ifmc_bus       ifmc_bus
	 (
	  .clk                  ( clk ),
	  .apb_clk              ( apb_clk ),
	  .rstb                 ( rstb ),
	  
	  .ahb_sel              ( ahb_sel ),
	  .ahb_readyin          ( ahb_readyin ),
	  .ahb_trans            ( ahb_trans ),
	  .ahb_addr             ( ahb_addr ),
	  .ahb_write            ( ahb_write ),
	  .ahb_size             ( ahb_size ),
	  
	  .ahb_rdata            ( ahb_rdata ),
	  .ahb_ready            ( ahb_ready ),
	  .ahb_resp             ( ahb_resp ),
	  
	  .apb_enable           ( apb_enable ),
	  .apb_sel              ( apb_sel ),
	  .apb_addr             ( apb_addr ),
	  .apb_write            ( apb_write ),
	  .apb_wdata            ( apb_wdata ),
	  .apb_rdata            ( apb_rdata ),

	  .rdwaitcycle          ( rdwaitcycle ),
	  .info_rd              ( info_rd ),
	  .fmr_adr              ( bfmr_adr ),
	  .fmr_rd               ( bfmr_rd ),
	  .fmr_rdata            ( fmr_rdata ),
	  .fmb_ready            ( fmb_ready ),
	  .fmb_ready_1cb        ( fmb_ready_1cb ),

	  .fm_wrmode            ( bfm_wrmode ),
	  .fmw_adr              ( bfmw_adr ),
	  .fmw_xe               ( bfmw_xe ),
	  .fmw_ye               ( bfmw_ye ),
	  .fmw_se               ( bfmw_se ),
	  .fmw_erase            ( bfmw_erase ),
	  .fmw_mas1             ( bfmw_mas1 ),
	  .fmw_prog             ( bfmw_prog ),
	  .fmw_nvstr            ( bfmw_nvstr ),
	  .fmw_ifren            ( bfmw_ifren ),
	  .fmw_din              ( bfmw_din ),
	  
	  .hdp                  ( hdp ),
	  .rdp                  ( rdp ),
	  .smart                ( smart )
	  );

   
   ifmc_serial       ifmc_serial
	 (
	  .clk                  ( clk ),
	  .rstb                 ( rstb ),
	   
	  .tmode                ( tmode ),
	  .tool_mode            ( tool_mode ),
	  
	  .scl                  ( scl ),
	  .sda_in               ( sda_in ),
	  .sda_out              ( sda_out ),
	  .sda_oeb              ( sda_oeb ), 
	  
	  .fmr_adr              ( sfmr_adr ), 
	  .fmr_rd               ( sfmr_rd ),
	  .fmr_rdata            ( fmr_rdata ),
	  .fmb_ready            ( fmb_ready ),

	  .fm_wrmode            ( sfm_wrmode ),
	  .fmw_adr              ( sfmw_adr ),
	  .fmw_xe               ( sfmw_xe ),
	  .fmw_ye               ( sfmw_ye ),
	  .fmw_se               ( sfmw_se ),
	  .fmw_erase            ( sfmw_erase ),
	  .fmw_mas1             ( sfmw_mas1 ),
	  .fmw_prog             ( sfmw_prog ),
	  .fmw_nvstr            ( sfmw_nvstr ),
	  .fmw_ifren            ( sfmw_ifren ),
	  .fmw_din              ( sfmw_din ),
	  
	  .hdp                  ( hdp ),
	  .rdp                  ( rdp ),
	  .smart                ( smart ),
	  
	  .sm_idle              ( sm_idle ),
	  .sm_initialize        ( sm_initialize ),
	  .sm_get_addr          ( sm_get_addr ),
	  .sm_addr_dummy        ( sm_addr_dummy ),
	  .sm_clr_counter       ( sm_clr_counter ),
	  .sm_get_data          ( sm_get_data ),
	  .sm_data_dummy        ( sm_data_dummy ),
	  .sm_stop              ( sm_stop ),
	  .scl_lpf              ( scl_lpf ),
	  .sda_lpf              ( sda_lpf )
 	  );


   ifmc_fmb        fmb
	 (
	  .clk                     ( clk ),
	  .rstb                    ( rstb ),
	  
	  .rdwaitcycle             ( rdwaitcycle ),
	  .info_rd                 ( info_rd ),
	  .fmr_adr                 ( fmr_adr ), 
	  .fmr_rd                  ( fmr_rd ), 
	  .fmr_rdata               ( fmr_rdata ),
	  .ready_1cb               ( fmb_ready_1cb ),
	  .ready                   ( fmb_ready ),
	  
	  .fm_wrmode               ( fm_wrmode ),
	  .fmw_adr                 ( fmw_adr ),
	  .fmw_xe                  ( fmw_xe ),
	  .fmw_ye                  ( fmw_ye ),
	  .fmw_se                  ( fmw_se ),
	  .fmw_erase               ( fmw_erase ),
	  .fmw_mas1                ( fmw_mas1 ),
	  .fmw_prog                ( fmw_prog ),
	  .fmw_nvstr               ( fmw_nvstr ),
	  .fmw_ifren               ( fmw_ifren ),
      .fmw_din                 ( fmw_din ),
	  
	  .hdp                     ( hdp ),
	  .rdp                     ( rdp ),
	  .smart                   ( smart ),
	  
	  .fm_xadr                 ( fm_xadr ),
	  .fm_yadr                 ( fm_yadr ),
	  .fm_xe                   ( fm_xe ),
	  .fm_ye                   ( fm_ye ),
	  .fm_se                   ( fm_se ),
	  .fm_erase                ( fm_erase ),
	  .fm_mas1                 ( fm_mas1 ),
	  .fm_prog                 ( fm_prog ),
	  .fm_nvstr                ( fm_nvstr ),
	  .fm_ifren                ( fm_ifren ),
	  .fm_din                  ( fm_din ),
	  .fm_dout                 ( fm_dout )
	  );

//   SFD64KX32M64P4     fmcore
     fm_shell           fmcore
	 (
	  .clk                 ( clk ),
	  .rstb                ( rstb ),
	  .XADR                ( fmc_xadr ),
	  .YADR                ( fmc_yadr ),
	  .DIN                 ( fmc_din ),
	  .DOUT                ( fm_dout ),
	  .XE                  ( fmc_xe ),
	  .YE                  ( fmc_ye ),
	  .SE                  ( fmc_se ),
	  .ERASE               ( fmc_erase ),
	  .MAS1                ( fmc_mas1 ),
	  .PROG                ( fmc_prog ),
	  .NVSTR               ( fmc_nvstr ),
	  .IFREN               ( fmc_ifren ),
	  .TMR                 ( fmc_tmr ),
	  .VPP                 ( fmt_vpp ),
	  .TM                  ( fmt_tm )
	  );
   
endmodule // ifmc_top


