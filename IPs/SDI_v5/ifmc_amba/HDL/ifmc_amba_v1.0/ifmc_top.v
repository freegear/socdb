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
   fmt_erase             
   );

   input 				   clk;
   input 				   apb_clk;
   input 				   rstb;

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
   
   
   //-----------------------------------------
   // internal signals
   
   wire [31:0] 			   ahb_rdata;
   wire 				   ahb_ready;
   wire [1:0] 			   ahb_resp;

   wire [31:0] 			   apb_rdata;

   // interanl signals
   wire [1:0] 			   rdwaitcycle;
   wire 				   info_rd; // for debugging. selcect info or main at read
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

   wire 				   fmt_vpp;
   wire [2:0] 			   fmt_tm;

   // Flash memory test pin mux
   assign 	   fmc_tmr = (fmt_en)? fmt_tmr : 1'b1;
   assign	   fmc_nvstr = (fmt_en)? 1'b0 : fm_nvstr;
   assign      fmc_se = (fmt_en)? 1'b0 : fm_se;
   assign 	   fmc_mas1 = (fmt_en)? fmt_mas1 : fm_mas1;
   assign 	   fmc_ifren = (fmt_en)? fmt_ifren : fm_ifren;
   assign      fmc_xe = (fmt_en)? fmt_xe : fm_xe;
   assign      fmc_ye = (fmt_en)? fmt_ye : fm_ye;
   assign 	   fmc_erase = (fmt_en)? fmt_erase : fm_erase;
   
	 
	 
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
	  .fmr_adr              ( fmr_adr ),
	  .fmr_rd               ( fmr_rd ),
	  .fmr_rdata            ( fmr_rdata ),
	  .fmb_ready            ( fmb_ready ),
	  .fmb_ready_1cb        ( fmb_ready_1cb ),

	  .fm_wrmode            ( fm_wrmode ),
	  .fmw_adr              ( fmw_adr ),
	  .fmw_xe               ( fmw_xe ),
	  .fmw_ye               ( fmw_ye ),
	  .fmw_se               ( fmw_se ),
	  .fmw_erase            ( fmw_erase ),
	  .fmw_mas1             ( fmw_mas1 ),
	  .fmw_prog             ( fmw_prog ),
	  .fmw_nvstr            ( fmw_nvstr ),
	  .fmw_ifren            ( fmw_ifren ),
	  .fmw_din              ( fmw_din ),
	  
	  .hdp                  ( hdp ),
	  .rdp                  ( rdp ),
	  .smart                ( smart )
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

   SFD64KX32M64P4     fmcore
	 (
	  .XADR                ( fm_xadr ),
	  .YADR                ( fm_yadr ),
	  .DIN                 ( fm_din ),
	  .DOUT                ( fm_dout ),
	  .XE                  ( fmc_xe ),
	  .YE                  ( fmc_ye ),
	  .SE                  ( fmc_se ),
	  .ERASE               ( fmc_erase ),
	  .MAS1                ( fmc_mas1 ),
	  .PROG                ( fm_prog ),
	  .NVSTR               ( fmc_nvstr ),
	  .IFREN               ( fmc_ifren ),
	  .TMR                 ( fmc_tmr ),
	  .VPP                 ( fmt_vpp ),
	  .TM                  ( fmt_tm )
	  );

   
endmodule // ifmc_top


