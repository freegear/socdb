/************************************************************
   Test Bench for Flash memory controller
  
   file name : Atb_fmc.v
 
   created by gtlee
 
   date : 2006.3.5
 
   note :

 ************************************************************/
`timescale 1ns/1ns

`define    GANG_ONLY           1
//`define    FMC_ONLY            1


`define     CKP1  7
`define     DLY   2

// FMC registers
`define     FMC_KEY_REG         6'h00
`define     FMC_ADDR_REG        6'h04
`define     FMC_DATA_REG        6'h08
`define     FMC_FMUCON          6'h0C
`define     FMC_FSO             6'h10
`define     FMC_FPO             6'h14
`define     FMC_TNV             6'h20
`define     FMC_TPG             6'h24
`define     FMC_TRCV            6'h28
`define     FMC_TPROG           6'h2C
`define     FMC_TERASE          6'h30
`define     FMC_TME             6'h34



module     Atb_fmc;

   reg                 clk;
   reg 				   rstb;

   wire 			   tmode;
   wire 			   scl;
   wire 			   sda_in;
   wire 			   sda_out;
   wire 			   sda_oeb;
   wire 			   tool_mode;
   
   reg 				   ahb_sel;
   wire 			   ahb_readyin;
   reg [1:0] 		   ahb_trans;
   reg [17:0] 		   ahb_addr;
   reg 				   ahb_write;
   reg [2:0] 		   ahb_size;
   
   wire [31:0] 		   ahb_rdata;
   wire 			   ahb_ready;
   wire [1:0] 		   ahb_resp;
   
   // apb
   reg 				   apb_enable;
   reg 				   apb_sel;
   reg [5:0] 		   apb_addr;
   reg 				   apb_write;
   reg [31:0] 		   apb_wdata;
   wire [31:0] 		   apb_rdata;
   
   
   // Flash Memory Test Pin
   reg 				   fmt_en;  // flash memory test enable
   reg 				   fmt_tmr;
   wire 			   fmt_vpp = 0;
   wire [2:0] 		   fmt_tm = 0;
   reg 				   fmt_mas1;
   reg 				   fmt_ifren;
   reg 				   fmt_xe;
   reg 				   fmt_ye;
   reg 				   fmt_erase;

   reg 				   fmt_se;
   reg 				   fmt_nvstr;
   reg 				   fmt_prog;
   reg [9:0] 		   fmt_xadr;
   reg [5:0] 		   fmt_yadr;
   reg [31:0] 		   fmt_din;
   wire [31:0] 		   fmt_dout;
   wire 			   fmt_oeb;

   reg 				   tstart;   // Gang Test Start
   
   integer 			   fmc_logfile;

   //-----------------------------------------------------
   ifmc_top    Top
	 (
	  .clk                   ( clk ),
	  .apb_clk               ( clk ),
	  .rstb                  ( rstb ),

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
	  .fmt_oeb               ( fmt_oeb )
	  );
   
   
   gang         gang
	 (
	  .clk        ( clk ),
	  .rstb       ( rstb ),
	  
	  .tmode      ( tmode ),
	  .scl        ( scl ),
	  .sda_in     ( sda_in ),
	  .sda_out    ( sda_out ),
	  .tstart     ( tstart )
	  );
   
   //---------------------------------------------------
   
   initial     begin
	  fmc_logfile = $fopen("fmc.log");
	  

	  clk = 1;
	  rstb = 0;
	  tstart = 0;
	  
	  ahb_sel = 0;
//	  ahb_readyin = 1;
	  ahb_trans = 0;
	  ahb_addr = 0;
	  ahb_write = 0;
	  ahb_size = 0;

	  apb_enable = 0;
	  apb_sel = 0;
	  apb_addr = 0;
	  apb_write = 0;
	  apb_wdata = 0;
	  
	  fmt_en = 0;
	  fmt_tmr = 1;
	  fmt_mas1 = 0;
	  fmt_ifren = 0;
	  fmt_xe = 0;
	  fmt_ye = 0;
	  fmt_erase = 0;

	  fmt_se = 0;
      fmt_nvstr = 0;
	  fmt_prog = 0;
      fmt_xadr = 0;
      fmt_yadr = 0;
      fmt_din = 0;
	  
	  repeat(20) @(posedge clk);
	  #`DLY rstb = 1;
   end // initial begin

   always #`CKP1      clk  <= ~clk;

   assign #3 ahb_readyin = ahb_ready;
      
   //-----------------------------------------------
   // Tasks

   //  reg write
   task reg_write;
	  input   [5:0] addr;
	  input   [31:0] data;
	  begin
		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b1;
		 apb_write = 1'b1;
		 apb_addr = addr;
		 apb_wdata = data;
		 
		 @(posedge clk) #`DLY 
		   apb_enable = 1'b1;

		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b0;
		 apb_write = 1'b0;
		 apb_wdata = 0;
		 
		 @(posedge clk) #`DLY;

		 $fdisplay(fmc_logfile,"Register Write --> addr : 0x%X, data : 0x%X",addr,data);
	  end
   endtask // reg_write

   //  reg read
   task reg_read;
	  input   [5:0] addr;
	  begin
		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b1;
		 apb_write = 1'b0;
		 apb_addr = addr;
		 
		 @(posedge clk) #`DLY 
		   apb_enable = 1'b1;

		 $fdisplay(fmc_logfile,"Register Read --> addr : 0x%X, data : 0x%X",addr,apb_rdata);

		 @(posedge clk) #`DLY
		   apb_enable = 1'b0;
		 apb_sel = 1'b0;
		 apb_write = 1'b0;
		 apb_wdata = 0;
		 
		 @(posedge clk) #`DLY;


	  end
   endtask // reg_write

  
   // mem write
   task mem_write;
	  input [19:0] addr;
	  input [2:0] size;
	  input [31:0] data;
	  begin
		 @(posedge clk) #`DLY
		   ahb_sel = 1;
		 ahb_write = 1'b1;
		 ahb_trans = 2'h1;
		 ahb_size = size;
		 
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 
		 wait(ahb_ready);
		 
		 @(posedge clk) #`DLY
		   ahb_sel = 0;
		 ahb_write = 1'b0;
		 ahb_trans = 2'h0;
		 
		 wait(ahb_ready);
		 $fdisplay(fmc_logfile,"Flash Memory Write --> No operation");
	  end
   endtask // mem_write

   // mem read
   task mem_read;
	  input [19:0] addr;
	  input [2:0] size;
	  begin
		 @(posedge clk) #`DLY
		   ahb_sel = 1;
		 ahb_write = 1'b0;
		 ahb_trans = 2'h1;
		 ahb_size = size;
		 
		 if(size == 3'h0)
		   ahb_addr = addr;
		 else if(size == 3'h1)
		   ahb_addr = {addr[19:1],1'b0};
		 else 
		   ahb_addr = {addr[19:2],2'b00};
		 
		 wait(ahb_ready);
		 
		 @(posedge clk) #`DLY
		   ahb_sel = 0;
		 ahb_write = 1'b0;
		 ahb_trans = 2'h0;
		 
		 wait(ahb_ready);
		 $fdisplay(fmc_logfile,"Flash Memory Read --> addr : 0x%X, size : %d, data : 0x%X",
				   addr,size,ahb_rdata);
	  end
   endtask // mem_write

   // flash control display
   always@(posedge Top.fmc_erase) begin
	  if(Top.fmc_ifren == 1'b0)
		$fdisplay(fmc_logfile,"Flash Memory Page Erase --> page : 0x%X",
				  Top.fmc_xadr[9:2]);
	  else
		$fdisplay(fmc_logfile,"Flash Memory Chip Erase ");
   end // always


   always@(posedge Top.fmc_prog) begin
	  if(Top.fmc_ifren == 1'b0)
		$fdisplay(fmc_logfile,"Flash Memory Progam --> addr : 0x%X, data :0x%X",
				  {Top.fmc_xadr,Top.fmc_yadr,2'h0},Top.fmc_din);
	  else
		$fdisplay(fmc_logfile,"Flash Information Progam --> addr : 0x%X, data :0x%X",
				  {Top.fmc_xadr[1:0],Top.fmc_yadr,2'h0},Top.fmc_din);
   end

   //======================================================
   // Simulation Sequence

   initial begin
	  wait(rstb);
	  repeat(10) @(posedge clk);

`ifndef  GANG_ONLY
	  
	  // ¿¬¼Ó 2¹ø read
	  ahb_sel = 1;
	  ahb_write = 1'b0;
	  ahb_trans = 2'h1;
	  ahb_size = 2;
		 
	  ahb_addr = 18'h00004;
	  
	  @(posedge clk) #`DLY
		ahb_addr = 18'h00004;
	  
		 wait(ahb_ready);
		 
	  @(posedge clk) #`DLY
		ahb_sel = 0;
	  ahb_trans = 0;
	  
	  repeat(10) @(posedge clk);

	  //--------------------------------------
	  // register write test
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a);
	  reg_read(`FMC_KEY_REG);
	  reg_write(`FMC_KEY_REG, 32'ha5a5a5a5);
	  reg_read(`FMC_KEY_REG);
	  reg_write(`FMC_ADDR_REG, 32'h3c3c3c3c);
	  reg_read(`FMC_ADDR_REG);
	  reg_write(`FMC_DATA_REG, 32'hc3c3c3c3);
	  reg_read(`FMC_DATA_REG);
	  reg_write(`FMC_FMUCON, 32'h000007a7);
	  reg_read(`FMC_FMUCON);

	  reg_read(`FMC_FSO);
	  reg_read(`FMC_FPO);

	  reg_write(`FMC_TNV, 32'ha5a5a5a5);
	  reg_read(`FMC_TNV);
	  reg_write(`FMC_TPG, 32'h5a5a5a5a);
	  reg_read(`FMC_TPG);
	  reg_write(`FMC_TRCV, 32'ha5a5a5a5);
	  reg_read(`FMC_TRCV);
	  reg_write(`FMC_TPROG, 32'h005a5a5a);
	  reg_read(`FMC_TPROG);
	  reg_write(`FMC_TERASE, 32'ha5a5a5a5);
	  reg_read(`FMC_TERASE);
	  reg_write(`FMC_TME, 32'h5a5a5a5a);
	  reg_read(`FMC_TME);

	  repeat(5) @(posedge clk);

	  reg_write(`FMC_FMUCON, 32'h00000300);
	  reg_read(`FMC_FMUCON);
	  reg_write(`FMC_TNV, 32'h003F003F);
	  reg_read(`FMC_TNV);
	  reg_write(`FMC_TPG, 32'h007F0003);
	  reg_read(`FMC_TPG);
	  reg_write(`FMC_TRCV, 32'h000E04EA);
	  reg_read(`FMC_TRCV);
	  reg_write(`FMC_TPROG, 32'h000500FB);
	  reg_read(`FMC_TPROG);
	  reg_write(`FMC_TERASE, 32'h0003D090);
	  reg_read(`FMC_TERASE);
	  reg_write(`FMC_TME, 32'h0003D090);
	  reg_read(`FMC_TME);

	  //---------------------------------------------------
	  // Chip Erase
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a); // key
	  reg_write(`FMC_FMUCON, {22'h000000,10'b1111001001}); // all erase
	  //$fdisplay(fmc_logfile,"Chip Erased.");

	  reg_read(`FMC_KEY_REG);
	  mem_read(0,2);  // for wait
	  reg_read(`FMC_KEY_REG);
	  
	  // flash memory read
	  repeat(5) @(posedge clk);
	  $fdisplay(fmc_logfile,"\n");
	  mem_read(20'h00000,2);
	  mem_read(20'h00004,2);
	  mem_read(20'h00010,2);

	  mem_read(20'h0a000,2);
	  mem_read(20'h0a004,2);
	  mem_read(20'h0a010,2);
	  
	  //---------------------------------------------------
	  // flash programming. page 0.
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000000);   // address register
	  reg_write(`FMC_DATA_REG, 32'h3a35a5ac);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00000,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000004);   // address register
	  reg_write(`FMC_DATA_REG, 32'h130a5088);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00004,2);  // for wait
	  reg_read(`FMC_KEY_REG);
	  
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000010);   // address register
	  reg_write(`FMC_DATA_REG, 32'h00000000);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00010,2);  // for wait
	  reg_read(`FMC_KEY_REG);

//	  repeat(50000/(2*`CKP1)) @(posedge clk);
//	  mem_read(0,2);
	  repeat(10) @(posedge clk);

	  // flash programming. page 32.
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h0000a000);   // address register
	  reg_write(`FMC_DATA_REG, 32'h12579bdf);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h0a000,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h0000a004);   // address register
	  reg_write(`FMC_DATA_REG, 32'hfdb97531);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h0a004,2);  // for wait
	  reg_read(`FMC_KEY_REG);
	  
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h0000a010);   // address register
	  reg_write(`FMC_DATA_REG, 32'ha3a35a5a);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h0a010,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  repeat(10) @(posedge clk);
	  // flash memory read
	  repeat(5) @(posedge clk);
	  $fdisplay(fmc_logfile,"\n");
	  mem_read(20'h00000,2);
	  mem_read(20'h00004,2);
	  mem_read(20'h00010,2);

	  mem_read(20'h0a000,2);
	  mem_read(20'h0a004,2);
	  mem_read(20'h0a010,2);
	  
	  //---------------------------------------------------
	  // Smart option write
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000E38);   // address register
	  reg_write(`FMC_DATA_REG, 32'hFFFFFFFE);   // data register
	  reg_write(`FMC_FMUCON, {22'h000000,10'b0011101000}); // program information area

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00000,2);  // for wait
	  reg_read(`FMC_KEY_REG);
	  //repeat(50000/(2*`CKP1)) @(posedge clk);

	  // Protection option write
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000E3C);   // address register
	  reg_write(`FMC_DATA_REG, 32'hFFFDFFFF);   // data register
	  reg_write(`FMC_FMUCON, {22'h000000,10'b0011101000}); // program information area

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00000,2);  // for wait
	  reg_read(`FMC_KEY_REG);
	  
	  //repeat(50000/(2*`CKP1)) @(posedge clk);

	  //---------------------------------------------------
	  // read infomation block
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Set Information Memory Block Read Mode");
	  reg_write(6'h0C, {21'h000000,11'b10000000000}); // program information area

	  $fdisplay(fmc_logfile,"Setted Data");
	  //          read smart option
	  reg_read(`FMC_FSO);
	  mem_read({15'h000E,2'b00},2);
	  
	  //          read protection option
	  reg_read(`FMC_FPO);
	  mem_read({15'h000F,2'b00},2);
	  
	  // read main memory block
	  reg_write(6'h0C, {21'h000000,11'b00000000000}); // program information area

	  $fdisplay(fmc_logfile,"Set Main Memory Block Read Mode");


	  //----------------------------------------------------
	  // Flash Programming
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Data no change");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000014);   // address register
	  reg_write(`FMC_DATA_REG, 32'h11112222);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00014,2);  // for wait
	  reg_read(`FMC_KEY_REG);


	  // flash programming. page 32.
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Data change");
	  reg_write(`FMC_KEY_REG,  32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h0000a020);   // address register
	  reg_write(`FMC_DATA_REG, 32'h000ff00f);   // data register
	  reg_write(`FMC_FMUCON,   {22'h000000,10'b0011001100}); // program

	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h0a020,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  
	  //---------------------------------------------------
	  // Page Erase. Page Num 0
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Dont Page Erase");
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h00000000);   // address register
	  reg_write(`FMC_FMUCON, {22'h000000,10'b0011001010}); // program information area
	  
	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h00000,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  //repeat(22000000/(2*`CKP1)) @(posedge clk);

	  // Page Erase. Page Num 32
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Do Page Erase");
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a);   // key 
	  reg_write(`FMC_ADDR_REG, 32'h0000a000);   // address register
	  reg_write(`FMC_FMUCON, {22'h000000,10'b0011001010}); // program information area
	  reg_read(`FMC_KEY_REG);
	  mem_read(20'h0a000,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  //repeat(22000000/(2*`CKP1)) @(posedge clk);

	  // checking erase
	  // flash memory read
	  repeat(5) @(posedge clk);
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Data are Remained");
	  mem_read(20'h00000,2);
	  mem_read(20'h00004,2);
	  mem_read(20'h00010,2);

	  $fdisplay(fmc_logfile,"All Correctly FF");
	  mem_read(20'h0a000,2);
	  mem_read(20'h0a004,2);
	  mem_read(20'h0a010,2);

	  repeat(10) @(posedge clk);

	  //---------------------------------------------------
	  // Chip Erase
	  $fdisplay(fmc_logfile,"\n");
	  reg_write(`FMC_KEY_REG, 32'h5a5a5a5a); // key
	  reg_write(`FMC_FMUCON, {22'h000000,10'b1111001001}); // all erase
	  //$fdisplay(fmc_logfile,"Chip Erased.");

	  reg_read(`FMC_KEY_REG);
	  mem_read(0,2);  // for wait
	  reg_read(`FMC_KEY_REG);

	  //---------------------------------------------------
	  // read infomation block
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"Set Information Memory Block Read Mode");
	  reg_write(6'h0C, {21'h000000,11'b10000000000}); // program information area

	  $fdisplay(fmc_logfile,"All Correctly FF");
	  //          read smart option
	  reg_read(`FMC_FSO);
	  mem_read({15'h000E,2'b00},2);
	  
	  //          read protection option
	  reg_read(`FMC_FPO);
	  mem_read({15'h000F,2'b00},2);
	  
	  // read main memory block
	  reg_write(6'h0C, {21'h000000,11'b00000000000}); // program information area

	  $fdisplay(fmc_logfile,"Set Main Memory Block Read Mode");

	  //---------------------------------------------------
	  // checking erase
	  // flash memory read
	  repeat(5) @(posedge clk);
	  $fdisplay(fmc_logfile,"\n");
	  $fdisplay(fmc_logfile,"All Correctly FF");
	  mem_read(20'h00000,2);
	  mem_read(20'h00004,2);
	  mem_read(20'h00010,2);

	  mem_read(20'h0a000,2);
	  mem_read(20'h0a004,2);
	  mem_read(20'h0a010,2);

	  $display("End Bus Test");

	  repeat(30) @(posedge clk);

`endif
	  
`ifndef   FMC_ONLY
	  // Starting Gang Test
	  tstart = 1;
	  wait(tmode);
	  repeat(30) @(posedge clk);
	  wait(~tmode);
`endif
	 
	  repeat(30) @(posedge clk);
  
	  $display("End Simulation");
	  $stop;
	  
   end
   
endmodule // Atb_fmc

