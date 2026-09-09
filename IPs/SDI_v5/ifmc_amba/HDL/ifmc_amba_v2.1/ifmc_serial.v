/*

    Serial Downloader for external input signal

    file name : ifmc_serial.v
 
    create by gtlee
 
    create date : 2006.3.7
 
    history :
 
    note :
 
 
 */

module    ifmc_serial
  (
   clk              ,
   rstb             ,
   
   tmode            ,
   tool_mode        ,
   
   scl              ,
   sda_in           ,
   sda_out          ,
   sda_oeb          , 
   
   fmr_adr          , 
   fmr_rd           ,
   fmr_rdata        ,
   fmb_ready        ,

   fm_wrmode        ,
   fmw_adr          ,
   fmw_xe           ,
   fmw_ye           ,
   fmw_se           ,
   fmw_erase        ,
   fmw_mas1         ,
   fmw_prog         ,
   fmw_nvstr        ,
   fmw_ifren        ,
   fmw_din          ,
   
   hdp              ,
   rdp              ,
   smart          
   );

   input                  clk;
   input 				  rstb;

   // Tool mode signals
   input 				  tmode;  // pad input
   output 				  tool_mode; // tool mode enable

   // serial interface signals
   input 				  scl;
   input 				  sda_in;
   output 				  sda_out;
   output 				  sda_oeb; // SDA output enable
   
   // read control signals
   output [15:0] 		  fmr_adr; // bit 2°¡ lsb
   output 				  fmr_rd;
   input [31:0] 		  fmr_rdata;
   input 				  fmb_ready;

   // write control signals
   output 				  fm_wrmode;
   
   output [15:0] 		  fmw_adr;
   output 				  fmw_xe;
   output 				  fmw_ye;
   output 				  fmw_se;
   output 				  fmw_erase;
   output 				  fmw_mas1;
   output 				  fmw_prog;
   output 				  fmw_nvstr;
   output 				  fmw_ifren;
   output [31:0] 		  fmw_din;

   // Protection Informaion
   input 				  hdp;
   input 				  rdp;
   input [15:0] 		  smart;   


   // Internal signals
   
   wire 				  tool_mode; // tool mode enable
   wire 				  sda_out;
   wire 				  sda_oeb; // SDA output enable
   
   wire [15:0] 			  fmr_adr; // bit 2°¡ lsb
   wire 				  fmr_rd;
   
   wire 				  fm_wrmode;
   
   wire [15:0] 			  fmw_adr;
   wire 				  fmw_xe;
   wire 				  fmw_ye;
   wire 				  fmw_se;
   wire 				  fmw_erase;
   wire 				  fmw_mas1;
   wire 				  fmw_prog;
   wire 				  fmw_nvstr;
   wire 				  fmw_ifren;
   wire [31:0] 			  fmw_din;
   
   wire 				  scl_lpf;
   wire 				  sda_lpf;
   
   wire 				  sst_start;
   wire 				  sst_stop;
   wire 				  sst_ishift; // input latch and shift 
   wire 				  sst_oshift; // output shift
   wire 				  end_sclh;
   
   
   //-------------------------------------------------
   
   ifmc_tool      ifmc_tool
	 (
	  .clk                 ( clk ),
	  .rstb                ( rstb ),
	  
	  .tmode               ( tmode ),
	  .scl_lpf             ( scl_lpf ),
	  
	  .tool_mode           ( tool_mode )
	  );

   ifmc_lpf        scl_in_lpf
	 (
	  .clk                 ( clk ),
	  .rstb                ( rstb ),
	  
	  .in                  ( scl ),
	  .out                 ( scl_lpf )
	  );

   ifmc_lpf        sda_in_lpf
	 (
	  .clk                 ( clk ),
	  .rstb                ( rstb ),
	  
	  .in                  ( sda_in ),
	  .out                 ( sda_lpf )
	  );

   // analysis
   ifmc_ana         ifmc_ana
	 (
	  .clk                   ( clk ),
	  .rstb                  ( rstb ),
	  
	  .tool_mode             ( tool_mode ),
	  .scl_lpf               ( scl_lpf ),
	  .sda_lpf               ( sda_lpf ),
	  
	  .sst_start             ( sst_start ),
	  .sst_stop              ( sst_stop ),
	  .sst_ishift            ( sst_ishift ),
	  .sst_oshift            ( sst_oshift ),
	  .end_sclh              ( end_sclh )
   );



   ifmc_ptsm        ifmc_ptsm
	 (
	  .clk               ( clk ),
	  .rstb              ( rstb ),
	  
	  .scl_lpf           ( scl_lpf ),
	  .sda_lpf           ( sda_lpf ),
	  .sda_out           ( sda_out ),
	  .sda_oeb           ( sda_oeb ),
	  
	  .sst_start         ( sst_start ),
	  .sst_stop          ( sst_stop ),
	  .sst_ishift        ( sst_ishift ),
	  .sst_oshift        ( sst_oshift ),
	  .end_sclh          ( end_sclh ),
	  
	  .fmr_adr           ( fmr_adr ),
	  .fmr_rd            ( fmr_rd ),
	  .fmr_rdata         ( fmr_rdata ),
	  .fmb_ready         ( fmb_ready ),
	  
	  .fm_wrmode         ( fm_wrmode ),
	  .fmw_adr           ( fmw_adr ),
	  .fmw_xe            ( fmw_xe ),
	  .fmw_ye            ( fmw_ye ),
	  .fmw_se            ( fmw_se ),
	  .fmw_erase         ( fmw_erase ),
	  .fmw_mas1          ( fmw_mas1 ),
	  .fmw_prog          ( fmw_prog ),
	  .fmw_nvstr         ( fmw_nvstr ),
	  .fmw_ifren         ( fmw_ifren ),
	  .fmw_din           ( fmw_din ),
	  
	  .hdp               ( hdp ),
	  .rdp               ( rdp ),
	  .smart             ( smart )
	  );

endmodule // ifmc_serial

  