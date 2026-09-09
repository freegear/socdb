/***********************************************************
   AMBA Bus side of Flash memory controller 
  
   Use Amba
 
   file name : ifmc_bus.v
 
   created by gtlee
 
   date : 2006.3.4
 
   note :
         
 ************************************************************/

module   ifmc_bus
  (
   clk                  ,
   apb_clk              ,
   rstb                 ,
   
   ahb_sel              ,
   ahb_readyin          ,
   ahb_trans            ,
   ahb_addr             ,
   ahb_write            ,
   ahb_size             ,
   
   ahb_rdata            ,
   ahb_ready            ,
   ahb_resp             ,
   
   apb_enable           ,
   apb_sel              ,
   apb_addr             ,
   apb_write            ,
   apb_wdata            ,
   apb_rdata            ,

   rdwaitcycle          ,
   info_rd              ,
   fmr_adr              ,
   fmr_rd               ,
   fmr_rdata            ,
   fmb_ready            ,
   fmb_ready_1cb        ,
   
   fm_wrmode            ,
   fmw_adr              ,
   fmw_xe               ,
   fmw_ye               ,
   fmw_se               ,
   fmw_erase            ,
   fmw_mas1             ,
   fmw_prog             ,
   fmw_nvstr            ,
   fmw_ifren            ,
   fmw_din              ,
   
   hdp                  ,
   rdp                  ,
   smart                
   );
   
   input 				   clk;
   input 				   apb_clk;
   input 				   rstb;

   // ahb
   input 				   ahb_sel;
   input 				   ahb_readyin;
   input [1:0] 			   ahb_trans;
   input [17:2] 		   ahb_addr;
   input 				   ahb_write;
   input [2:0] 			   ahb_size;

   output [31:0] 		   ahb_rdata;
   output 				   ahb_ready;
   output [1:0] 		   ahb_resp;

   // apb
   input 				   apb_enable;
   input 				   apb_sel;
   input [5:2] 			   apb_addr;
   input 				   apb_write;
   input [31:0] 		   apb_wdata;
   output [31:0] 		   apb_rdata;

   // FM interface for read
   output [1:0] 		   rdwaitcycle; // read cycle count.
   output 				   info_rd;
   output [15:0] 		   fmr_adr;
   output 				   fmr_rd;
   input [31:0] 		   fmr_rdata;
   input 				   fmb_ready;
   input 				   fmb_ready_1cb;

   // FM interface for write
   output 				   fm_wrmode;
   
   output [15:0] 		   fmw_adr;
   output 				   fmw_xe;
   output 				   fmw_ye;
   output 				   fmw_se;
   output 				   fmw_erase;
   output 				   fmw_mas1;
   output 				   fmw_prog;
   output 				   fmw_nvstr;
   output 				   fmw_ifren;
   output [31:0] 		   fmw_din;

   // protection information. from FMB
   input 				   hdp;
   input 				   rdp;
   input [15:0] 		   smart;

  
   //----------------------------------------------
   // Internal signals
   // to flash memory write control block
   wire 				   key_hit;   // key register hit/miss
   wire [31:0] 			   fmaddr;
   wire [31:0] 			   fmdata;
   wire [7:0] 			   fmucon;
   wire [1:0] 			   rdwaitcycle; // read cycle count.
   wire 				   info_rd; // select information block or main memory block
   
   wire [15:0] 			   tnvs;
   wire [15:0] 			   tnvh;
   wire [15:0] 			   tpgs;
   wire [15:0] 			   tpgh;
   wire [15:0] 			   trcv;
   wire [15:0] 			   tnvh1;
   wire [15:0] 			   tprog;
   wire [31:0] 			   terase;
   wire [31:0] 			   tme;
   
   wire [6:0] 			   pscal_value;

   // from write control block
   wire 				   fm_wrmode;   // active during erase/program
   wire 				   mx_sel_wr;  // not use
   wire 				   clr_fmreg;  // active when operation is ended.

   // from read control block
   wire 				   fm_rdmode; // from read control block

   wire [15:0] 			   fmr_adr;
   wire 				   fmr_rd;


   
   //-------------------------------------------
   
   ifmc_reg     ifmc_reg
	 (
	  .apb_clk              ( apb_clk ),
	  .apb_rstb             ( rstb ),
	  
	  .apb_enable           ( apb_enable ),
	  .apb_sel              ( apb_sel ),
	  .apb_addr             ( apb_addr ),
	  .apb_write            ( apb_write ),
	  .apb_wdata            ( apb_wdata ),
	  .apb_rdata            ( apb_rdata ),
	  
	  .fm_wrmode            ( fm_wrmode ),
	  .clr_fmreg            ( clr_fmreg ),
	  
	  .hdp                  ( hdp ),
	  .rdp                  ( rdp ),
	  .smart                ( smart ),
	  
	  .key_hit              ( key_hit ),
	  .fmaddr               ( fmaddr ),
	  .fmdata               ( fmdata ),
	  .fmucon               ( fmucon ),
	  .rdwaitcycle          ( rdwaitcycle ),
	  .info_rd              ( info_rd ),
	  
	  .tnvs                 ( tnvs ),
	  .tnvh                 ( tnvh ),
	  .tpgs                 ( tpgs ),
	  .tpgh                 ( tpgh ),
	  .trcv                 ( trcv ),
	  .tnvh1                ( tnvh1 ),
	  .tprog                ( tprog ),
	  .terase               ( terase ),
	  .tme                  ( tme ),
	  
	  .pscal_value          ( pscal_value )
	  );   

   // flash memory write control module
   ifmc_wr     ifmc_wr
	 (
	  .clk               ( clk ),
	  .rstb              ( rstb ),
	  
	  .fm_rdmode         ( fm_rdmode ),
	  
	  .key_hit           ( key_hit ),
	  .fmaddr            ( fmaddr ),
	  .fmdata            ( fmdata ),
	  .fmucon            ( fmucon ),
	  
	  .hdp               ( hdp ),
	  .smart             ( smart ),
	  
	  .tnvs              ( tnvs ),
	  .tnvh              ( tnvh ),
	  .tpgs              ( tpgs ),
	  .tpgh              ( tpgh ),
	  .trcv              ( trcv ),
	  .tnvh1             ( tnvh1 ),
	  .tprog             ( tprog ),
	  .terase            ( terase ),
	  .tme               ( tme ),   
	  .pscal_value       ( pscal_value ),
	  
	  .fm_wrmode          ( fm_wrmode ),
	  .mx_sel_wr         ( mx_sel_wr ),
	  .clr_fmreg         ( clr_fmreg ),
	  
	  .fmw_adr           ( fmw_adr ),
	  .fmw_xe            ( fmw_xe ),
	  .fmw_ye            ( fmw_ye ),
	  .fmw_se            ( fmw_se ),
	  .fmw_erase         ( fmw_erase ),
	  .fmw_mas1          ( fmw_mas1 ),
	  .fmw_prog          ( fmw_prog ),
	  .fmw_nvstr         ( fmw_nvstr ),
	  .fmw_ifren         ( fmw_ifren ),
	  .fmw_din           ( fmw_din )
	  );

   // flash memory read control module
   ifmc_rd     ifmc_rd
	 (
	  .clk                ( clk ),
	  .rstb               ( rstb ),
	  
	  .ahb_sel            ( ahb_sel ),
	  .ahb_readyin        ( ahb_readyin ),
	  .ahb_trans          ( ahb_trans ),
	  .ahb_addr           ( ahb_addr ),
	  .ahb_write          ( ahb_write ),
	  .ahb_size           ( ahb_size ),
	  
	  .ahb_rdata          ( ahb_rdata ),
	  .ahb_ready          ( ahb_ready ),
	  .ahb_resp           ( ahb_resp ),
	  
	  .fm_wrmode          ( fm_wrmode ),
	  .fm_rdmode          ( fm_rdmode ),
	  
	  .fmr_adr            ( fmr_adr ),
	  .fmr_rd             ( fmr_rd ),
	  .fmr_rdata          ( fmr_rdata ),
	  .fmb_ready          ( fmb_ready ),
	  .fmb_ready_1cb      ( fmb_ready_1cb )
	  );

   
endmodule // ifmc_bus

