/************************************************************
   Sub Processor system Top block.
  
   file name : v8_base_top.v
 
   created by gtlee
 
   date : 2006.6.20
 
   note :
        
   history :
 
 ************************************************************/
`timescale 1ns/10ps

 
module        v8_base_top
  (
   clk              ,
   rstb             ,

   set_addr         ,
   acc_addr         ,

   write            ,
   wdata            ,

   read             ,
   rdata            ,

   run
   );

   parameter                ADDRWIDTH = 16;
   parameter 				CDATAWIDTH = 8;
   parameter 				PDATAWIDTH = 32;
   parameter 				PBE = 4;

   input 					clk;
   input 					rstb;
   
   input 					set_addr;
   input [ADDRWIDTH-1:0] 	acc_addr;

   input 					write; // assert when PENABLE actived at write
   input [CDATAWIDTH-1:0] 	wdata;
   
   input 					read; // assert when PSEL actived at read
   output [CDATAWIDTH-1:0] 	rdata;
   
   input 					run;   // sub processor run/stop
   
   //===================================================
   
   wire [ADDRWIDTH-1:0] 	cpu_addr;
   wire 					cpu_write;
   wire 					cpu_read;
   wire [CDATAWIDTH-1:0] 	cpu_dataout;
   wire [CDATAWIDTH-1:0] 	cpu_datain;
   wire 					cpu_ready;
   wire 					fetch;

   wire [8:1] 				cpu_cycle;
   wire [7:0] 				cpu_opcde;
   wire 					cpu_write_nxt;
   wire [15:0] 				cpu_pc;
   wire [7:0] 				cpu_psr;
   wire 					cpu_sp_oflo;
      
   wire 					mem_cs;
   wire [CDATAWIDTH-1:0] 	mem_dataout;
   wire 					mem_ready;
   
   wire [PDATAWIDTH-1:0] 	p_datain;

   wire 					restart;

   wire 					spc_cs;
   wire [ADDRWIDTH-1:0] 	spc_addr;
   wire 					spc_read;
   wire 					spc_write;
   wire [CDATAWIDTH-1:0] 	spc_datain;
   wire [CDATAWIDTH-1:0] 	spc_dataout;


   wire 					sl_csb;
   wire [ADDRWIDTH-1:0] 	sl_addr;
   wire 					sl_writeb;
   wire 					sl_outenb;
   wire [CDATAWIDTH-1:0] 	sl_dataout;
   wire [CDATAWIDTH-1:0] 	sl_datain;

   wire [31:0] 				mem_out;
   
   //===================================================
   
   v8_top   cpu
	 (
	  .clk              ( clk ),
	  .rst              ( ~rstb ),
	  
	  .clr_pc           ( restart ),
	  .clr_p            ( {4{restart}} ),
	  .datain           ( cpu_datain ),
	  .int              ( 8'h00 ),
	  
	  .ready            ( cpu_ready ),
	  .set_p            ( 4'h0 ),
	  
	  .write            ( cpu_write ),
	  .addr             ( cpu_addr ),
	  .dataout          ( cpu_dataout ),
	  .op_ftch          ( fetch ),
	  .read             ( cpu_read ),
	  
	  .cycle            ( cpu_cycle ),
	  .opcde            ( cpu_opcde ),
	  .write_nxt        ( cpu_write_nxt ),
	  .pc               ( cpu_pc ),
	  .psr              ( cpu_psr ),
	  .sp_oflo          ( cpu_sp_oflo )
   );
   

   sb_bus   bus
	 (
 	  .cpu_addr          ( cpu_addr ),
	  .cpu_datain        ( cpu_datain ),
	  .cpu_dataout       ( cpu_dataout ),
	  .cpu_ready         ( cpu_ready ),
	  
	  .pctrl_ready       ( 1'b1 ),
	  
	  .mem_cs            ( mem_cs ),
	  .mem_dataout       ( mem_dataout ),
	  .mem_ready         ( mem_ready ),
	  
	  .p_be              (  ),
	  .p_datain          ( p_datain ), // to peri
	  
	  .p0_cs             (  ),
	  .p0_dataout        ( 0 ),
	  .p0_ready          ( 1'b1 ),
	  
	  .p1_cs             (  ),
	  .p1_dataout        ( 0 ),
	  .p1_ready          ( 1'b1 ),
	  
	  .p2_cs             (  ),
	  .p2_dataout        ( 0 ),
	  .p2_ready          ( 1'b1 ),
	  
	  .p3_cs             (  ),
	  .p3_dataout        ( 0 ),
	  .p3_ready          ( 1'b1 ),
	  
	  .p4_cs             (  ),
	  .p4_dataout        ( 0 ),
	  .p4_ready          ( 1'b1 ),
	  
	  .p5_cs             (  ),
	  .p5_dataout        ( 0 ),
	  .p5_ready          ( 1'b1 ),
	  
	  .p6_cs             (  ),
	  .p6_dataout        ( 0 ),
	  .p6_ready          ( 1'b1 ),
	  
	  .p7_cs             (  ),
	  .p7_dataout        ( 0 ),
	  .p7_ready          ( 1'b1 )
	  );



   mem_rap   mem_rap
	 (
	  .clk               ( clk ),
	  .rstb              ( rstb ),
	  
	  .bus_cs            ( mem_cs ),
	  .bus_addr          ( cpu_addr ),
	  .bus_read          ( cpu_read ),
	  .bus_write         ( cpu_write ),
	  .bus_datain        ( p_datain[7:0] ),
	  .bus_dataout       ( mem_dataout[CDATAWIDTH-1:0] ),
	  .bus_ready         ( mem_ready ),
	  
	  .spc_cs            ( spc_cs ),
	  .spc_addr          ( spc_addr ),
	  .spc_read          ( spc_read ),
	  .spc_write         ( spc_write ),
	  .spc_dataout       ( spc_datain ), // to spc
	  .spc_datain        ( spc_dataout ), // from spc
	  
	  .sl_csb            ( sl_csb ),
	  .sl_addr           ( sl_addr ),
	  .sl_writeb         ( sl_writeb ),
	  .sl_outenb         ( sl_outenb ),
	  .sl_dataout        ( sl_dataout ),
	  .sl_datain         ( sl_datain ),
	  .sl_ready          ( 1'b1 )
	  );

	  assign             sl_datain = mem_out[CDATAWIDTH-1:0];
	  
	  RA1SH6144x32_8       psram
	  (
	   .Q                ( mem_out ),
	   .CLK              ( clk ), 
	   .CEN              ( sl_csb ),
	   .WEN              ( {4{sl_writeb}} ),
	   .A                ( sl_addr[12:0] ),
	   .D                ( {4{sl_dataout}} ),
	   .OEN              ( sl_outenb )
	   );


	  
	  sp_ctrl        sp_ctrl
	  (
	   .clk              ( clk ),
	   .rstb             ( rstb ),
	   
	   .set_addr         ( set_addr ),
	   .acc_addr         ( acc_addr ),
	   .write            ( write ),
	   .wdata            ( wdata ),
	   .read             ( read ),
	   .rdata            ( rdata ),
	   .run              ( run ),
	   
	   .bus_addr         ( cpu_addr ),
	   .fetch            ( fetch ),
	   .restart          ( restart ),
	   
	   .spc_cs           ( spc_cs ),
	   .spc_addr         ( spc_addr ),
	   .spc_read         ( spc_read ),
	   .spc_write        ( spc_write ),
	   .spc_dataout      ( spc_dataout ), // to memory
	   .spc_datain       ( spc_datain )   // from memory
	   );


	  
endmodule // v8_base_top
