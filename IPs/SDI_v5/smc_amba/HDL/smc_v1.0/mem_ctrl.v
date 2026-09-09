/******************************************************************
 SMC for SDI V5

 using AHB

 Modified : 2006.2.23

*******************************************************************/

module        mem_ctrl
  ( 
	clk                ,
	resetx             ,  
	
	apb_enable         ,
	apb_sel            ,
	apb_addr           ,
	apb_write          ,
	apb_wdata          ,
	apb_rdata          ,	
	
	ahb_sel0           ,
	ahb_sel1           ,
	ahb_sel2           ,
	ahb_sel3           ,
	ahb_readyin        ,
	ahb_htrans         ,
	ahb_addr           ,
	ahb_write          ,
	ahb_size           ,
	ahb_wdata          ,
	ahb_rdata          ,
	ahb_ready          ,
	ahb_resp           ,

	ext_cs             ,
	ext_adr            ,
	ext_be             ,
	ext_wbe            , 
	ext_we             ,
	ext_oe             ,
	ext_wdata          ,
	ext_rdata          ,
	ext_bidoe      
	);
   
   //-----------------------------------------------------------------
   input 			clk;
   input            resetx; 
   
   input 			apb_enable;
   input 			apb_sel;
   input [3:2] 		apb_addr;
   input 			apb_write;
   input [31:0] 	apb_wdata;
   output [31:0] 	apb_rdata;
   
   input 			ahb_sel0;   // bank 0
   input 			ahb_sel1;   // bank 1
   input 			ahb_sel2;   // bank 2
   input 			ahb_sel3;   // bank 3
   input 			ahb_readyin; // from arbiter
   input [1:0] 		ahb_htrans;
   input [19:0] 	ahb_addr;
   input 			ahb_write;
   input [2:0] 		ahb_size;
   input [31:0] 	ahb_wdata;
   output [31:0] 	ahb_rdata;
   output 			ahb_ready;
   output [1:0] 	ahb_resp;
   
   output [ 3:0] 	ext_cs; 
   output [19:0] 	ext_adr; 
   output [1:0] 	ext_be;
   output [ 1:0] 	ext_wbe; 
   output 			ext_we;
   output 			ext_oe;
   output [15:0] 	ext_wdata;
   input [15:0] 	ext_rdata;
   output 			ext_bidoe; // data bidirection control. 1:out 0:in
   
   //-----------------------------------------------------------------
   wire [31:0] 	   apb_rdata; // from register block

   wire [31:0] 	   ahb_rdata;
   wire 		   ahb_ready;
   wire [1:0] 	   ahb_resp;
   
   reg [ 6:0] 	   burst_src;       // to sram block
   wire [ 1:0] 	   adr_setup;       // to sram block
   wire [ 1:0] 	   cs_setup;        // to sram block 
   wire [ 3:0] 	   acc_cycle;       // to sram block
   wire [ 1:0] 	   cs_hold;         // to sram block
   wire [ 1:0] 	   adr_hold;        // to sram block
   wire 		   dbus_width;      // to sram block 
   wire 		   adr_sft;
   
   wire [17:0] 	   reg_rdata;       // to data_arbiter block

   wire [26:0] 	   str_addr;
   wire 		   smc_sel;
   
   reg 			   tsel;
   reg [3:0] 	   bsel;
   reg 			   twr;
   reg 			   trd;
   reg [2:0] 	   tsize;
   reg [19:0] 	   taddr;
   reg [3:0] 	   tbeb; // AHB에서의 BEB

   wire 		   smc_start;
   
   wire [ 3:0] 	   ext_cs;  // to port
   wire [1:0] 	   ext_be;
   wire [1:0] 	   ext_wbe;  //  8bit write enable
   wire 		   ext_we;   // 16bit write enable
   wire [15:0] 	   ext_wdata;
   wire 		   ext_bidoe; // 1:out 0:in
   
   wire 		   sram_csx;
   wire [26:0] 	   sram_adr;     // to output_control block
   wire [ 3:0] 	   sram_ibex;    // to output_control block
//   wire [3:0] 	   sram_wbex;
   wire 		   sram_wex;
   wire [3:0] 	   sram_bex;
   wire 		   sram_rdx;
   wire 		   sram_latch;
   wire 		   sram_rdyx;
   wire 		   sram_wenx;
   wire 		   sram_idle; // no used
   wire 		   burst_end; // no used
   
   wire [26:0] 	   mem_adr;
   wire 		   mem_rdyx;
   wire [31:0] 	   b2m_data;
   
   
   //-----------------------------------------------------------------
 
   reg_smc          reg_smc
	 (
	  .apb_clk              ( clk ),
	  .apb_rstb             ( resetx ),
	  
	  .apb_enable           ( apb_enable ),
	  .apb_sel              ( apb_sel ),
	  .apb_addr             ( apb_addr ),
	  .apb_write            ( apb_write ),
	  .apb_wdata            ( apb_wdata ),
	  .apb_rdata            ( apb_rdata ),
	  
	  // data phase에도 값이 유지되어야 한다.
	  // latched signal 사용
	  .ahb_write            ( twr ),
	  .ahb_bsel             ( bsel ),
	  
	  .dbus_width           ( dbus_width ),
	  .adr_sft              ( adr_sft ),
	  .adr_setup            ( adr_setup ),
	  .cs_setup             ( cs_setup ),
	  .acc_cycle            ( acc_cycle ),
	  .cs_hold              ( cs_hold ),
	  .adr_hold             ( adr_hold )
	  );

                                            
//--------------------------------------------------------------------------------
   
   
   sram_ctrl            sram_ctrl
	 (
	  .resetx		( resetx    ),        
	  .clk  		( clk       ),          
 
      .sram		    ( smc_start ),   // sram enable       
      .mesb_adr26_0	( str_addr  ),   // from reg block -> combine at the top
      .esb_bex		( tbeb      ),       
      .esb_rdx		( ~trd      ),
      .esb_wrx		( ~twr      ),
      .esb_burst	( 1'b0	    ),   // only no burst
      
      .adr_setup	(adr_setup	),   // from reg block
      .cs_setup		(cs_setup	),   // from reg block. clocks for chip select
      .acc_cycle	(acc_cycle	),     
      .cs_hold		(cs_hold	),       
      .adr_hold		(adr_hold	),      
      .dbus_width	(dbus_width	),
      .adr_sft      ( adr_sft   ),
      .use_bex		( 1'b1      ),       
      .wait_enable	( 1'b0      ),   
      .waitx		( 1'b1      ),         
      .burst_src	( burst_src ),   // from reg block   
	  
      .sram_csx		(sram_csx	),   // to reg block
      .sram_adr		(sram_adr	),      
      .sram_bex		(sram_bex	),      
      .sram_wex		(sram_wex	),      
      .sram_rdx		(sram_rdx	),      
      .sram_ibex	(sram_ibex	),   // low address만들때 사용가능   
      .sram_latch	(sram_latch	),    
      .sram_rdyx	(sram_rdyx	),     
      .sram_wenx	(sram_wenx	),   // last cycle of a memory write
      .sram_idle	(sram_idle	),
	  .burst_end    ( burst_end )
	  );
   
//--------------------------------------------------------------------------------
   output_ctrl               out_ctrl
	 (
      .resetx		( resetx	),        
      .clk	        ( clk		),           
      .sram	        ( 1'b1		),      // no use    
      .reg_rdata	( 18'h00000 ),      // no use
      .reg_rdyx		( 1'b1	),          // no use
      .m2b_data		( {16'h0000, ext_rdata}	),      
      .esb_adr26_2	( 25'h0000000 ),    // no use
      .esb_dout		( ahb_wdata ),
      .sram_adr		(sram_adr	),      
      .sram_ibex	(sram_ibex	),     
      .sram_latch	(sram_latch	),    
      .sram_rdyx	(sram_rdyx	),     
      .sram_wenx	(sram_wenx	),  
	  
      .mem_adr		(mem_adr    ), // sram_adr을 bypass
      .mem_rdyx		(mem_rdyx	),  // reg & mem operation ready. no use 
      .mem_wenx		(mem_wenx	),  // bypass sram_wenx   
      .b2m_data		(b2m_data	),      
      .mem_rdata	(ahb_rdata	)
	  );   

   //-----------------------------------------------------------------
   // Store Operation Command
   assign 		   smc_sel = ahb_sel0 | ahb_sel1 | ahb_sel2 | ahb_sel3;
   
   always@(posedge clk or negedge resetx) begin
	  if(~resetx) begin
		 tsel  <= 1'b0;
		 bsel  <= 4'h0;
		 taddr <= {20{1'b0}};
		 twr   <= 1'b0;
		 trd   <= 1'b0;
		 tsize <= 3'h0;
	  end
	  // ahb_ready는 smc에서만 출력하는 신호.
	  else if( ahb_ready == 1'b1 ) begin
		 tsel  <= (ahb_htrans == 2'h0 || ahb_readyin == 1'b0)? 1'b0 : 1'b1;
		 bsel  <= {ahb_sel3,ahb_sel2,ahb_sel1,ahb_sel0};
		 taddr <= ahb_addr;
		 twr   <= ahb_write;
		 trd   <= ~ahb_write;
		 tsize <= ahb_size;
	  end
   end // always@ (posedge clk or negedge resetx)
   
   assign  smc_start = (tsel == 1'b1 && (|bsel == 1'b1))? 1'b1 : 1'b0;
   
   
   always@(tsize or taddr) begin
	  case (tsize)  //synopsys parallel_case
		3'h0 : begin // 8bit
		   case (taddr[1:0])  //synopsys parallel_case
			 2'b00 :   tbeb <= 4'b1110;
			 2'b01 :   tbeb <= 4'b1101;
			 2'b10 :   tbeb <= 4'b1011;
			 default : tbeb <= 4'b0111;
		   endcase // case(taddr[1:0])
		end
		3'h1 : begin // 16bit
		   if(taddr[1] == 1'b0) tbeb <= 4'b1100;
		   else  tbeb <= 4'b0011;
		end
		default : tbeb <= 4'b0000;
	  endcase // case(tsize)
   end // always@ (tsize or taddr)

   // burst length
   always@( dbus_width or tsize ) begin
	  if(dbus_width == 1'b0) begin // 8bit bus
		 case (tsize)  //synopsys parallel_case
		   3'h0 : burst_src <= 7'h00;  // 1 byte
		   3'h1 : burst_src <= 7'h01;  // 2 byte
		   default : burst_src <= 7'h03; // 4 byte
		 endcase // case(tsize)
	  end
	  else begin // 16bit bus
		 if(tsize[2:1] == 1'b0) burst_src <= 7'h00;
		 else burst_src <= 7'h01;
	  end // else: !if(dbus_width == 1'b0)
   end // always@ ( dbus_width or tsize )
   
   assign     str_addr = {6'h00,taddr};
   
   assign 	  ext_cs = (sram_csx == 1'b0)? bsel : 4'h0;
   assign 	  ext_be = ~sram_bex[1:0];
   assign 	  ext_wbe = (sram_wex) ? 2'b00 : ~(sram_bex[1:0]);
   assign 	  ext_we = ~sram_wex;
   assign     ext_oe = ~(sram_rdx);
   assign 	  ext_adr = mem_adr[19:0];
   assign 	  ext_wdata = b2m_data[15:0];
   assign     ext_bidoe = (sram_csx == 1'b0)? twr : 1'b0;
   
   assign 	  ahb_ready = (smc_start)?~sram_rdyx : 1'b1;
   assign 	  ahb_resp = 2'h0;
   
   
endmodule // mem_ctrl



