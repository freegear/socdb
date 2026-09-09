//
// Verilog Module UART_lib.RegBlk.arch_name
//
// Created:
//          by - Administrator.UNKNOWN (GUNDAM)
//          at - 12:04:08 2006-10-14
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//
 
`resetall
`timescale 1ns/10ps
module RegBlk( 
   PADDR, 
   PENABLE, 
   PSEL, 
   PWDATA, 
   PWRITE, 
   bytereceivedb, 
   clk, 
   fifodata_rx, 
   frameerrorb, 
   overrunerrorb, 
   parityerrorb, 
   rstb, 
   rxbusyb, 
   rxfifocnt, 
   txbusyb, 
   txfifo_emptyb, 
   txfifo_fillb, 
   txfifo_fullb, 
   txfifocnt, 
   PRDATA, 
   baudx16clk, 
   databit, 
   fifodata_tx, 
   fifordb, 
   fifowrb, 
   intb, 
   loopbackenb, 
   parity, 
   rxdmareqb, 
   stopbit, 
   swrstb, 
   txdmareqb, 
   uartenb
);


// Internal Declarations

input  [4:2]  PADDR;
input         PENABLE;
input         PSEL;
input  [31:0] PWDATA;
input         PWRITE;
input         bytereceivedb;
input         clk;
input  [7:0]  fifodata_rx;
input         frameerrorb;
input         overrunerrorb;
input         parityerrorb;
input         rstb;
input         rxbusyb;
input  [5:0]  rxfifocnt;
input         txbusyb;
input         txfifo_emptyb;
input         txfifo_fillb;
input         txfifo_fullb;
input  [5:0]  txfifocnt;
output [31:0] PRDATA;
output        baudx16clk;
output        databit;
output [7:0]  fifodata_tx;
output        fifordb;
output        fifowrb;
output        intb;
output        loopbackenb;
output [1:0]  parity;
output        rxdmareqb;
output        stopbit;
output        swrstb;
output        txdmareqb;
output        uartenb;


wire [4:2] PADDR;
wire PENABLE;
wire PSEL;
wire [31:0] PWDATA;
wire PWRITE;
wire bytereceivedb;
wire clk;
wire [7:0] fifodata_rx;
wire frameerrorb;
wire overrunerrorb;
wire parityerrorb;
wire rstb;
wire rxbusyb;
wire [5:0] rxfifocnt;
wire txbusyb;
wire txfifo_emptyb;
wire txfifo_fillb;
wire txfifo_fullb;
wire [5:0] txfifocnt;
wire [31:0] PRDATA;
wire baudx16clk;
wire databit;
wire [7:0] fifodata_tx;
wire fifordb;
wire fifowrb;
wire intb;
wire loopbackenb;
wire [1:0] parity;
wire rxdmareqb;
wire stopbit;
wire swrstb;
wire txdmareqb;
wire uartenb;

   reg swrstb_int ;
   reg uartenb_int ;
   reg intgenenb_int ;
   reg dmareqenb_int ;
   reg parity_int    ;
   reg databit_int   ;
   reg stopbit_int   ;
   reg [5:0] txwaterlevel_int ;
   reg [5:0] rxwaterlevel_int;
   reg       timeoutintenb_int;
	
   reg [15:0] clkdiv ;
   //reg [15:0] blkdivcnt;

   reg       receivetimeoutb;
   reg       interrupt_status;

   parameter MAX_FIFO_DEPTH = 3'b001 ;

   wire      txdmareqb_int ;
   wire      rxdmareqb_int;
   wire      rxfifo_data;

   //reg dly_1mhz;
   
   reg [19:0] timeoutcnt;
   reg [19:0] timeoutcnt_int;

   reg baudx16clk_int ;
   reg clkdivcnt_msb_dly;
   reg [15:0] clkdivcnt ;
   
   // Register file
   // Register Read
   wire [31:0] reg_0x0000;
   wire [31:0] reg_0x0004;
   wire [31:0] reg_0x0008;
   //wire [31:0] reg_0x000c;
   wire [31:0] reg_0x0010;
   wire [31:0] reg_0x0014;

   //
   reg loopbackenb_int ;

   assign fifodata_tx = PWDATA[7:0];

   reg [31:0] PRDATA_INT;
   assign PRDATA = PRDATA_INT;
	
   always @ ( PADDR or PWRITE or reg_0x0000 or reg_0x0004 or 
		reg_0x0008 or reg_0x0010 or reg_0x0014)
     begin
	case ( PADDR ) 
	  3'b000: PRDATA_INT <= reg_0x0000;

	  // 5'b00001: PRDATA_INT <= reg_0x0004;
	  
	  3'b010: PRDATA_INT <= reg_0x0008;
	  
	  //5'b00011: PRDATA_INT <= reg_0x000c;
	  
	  3'b100: PRDATA_INT <= reg_0x0010;
	  
	  3'b101: PRDATA_INT <= reg_0x0014;
	
	  default : PRDATA_INT <= reg_0x0004;
	endcase // case( PADDR )
     end
   
	  
   //------------------------------------------------------------
   //Master configuration register
   // 0x00
   always@(posedge clk or negedge rstb )
     begin
       if ( rstb == 1'b0 )
	 begin
	    uartenb_int <= 1'b1;
	    intgenenb_int <= 1'b1 ; // enable interrupt generation
	    timeoutintenb_int <= 1'b1 ; // Enable timeout interrupt
	    dmareqenb_int  <= 1'b1;
	    parity_int <= 2'b00; // parity
	    databit_int <= 1'b0;
	    stopbit_int <= 1'b0;
	    loopbackenb_int <= 1'b1;
	    txwaterlevel_int <= 6'b000000;
	    rxwaterlevel_int <= 6'b000000;
	 end
       else if( PSEL == 1'b1 && PWRITE == 1'b1 && PENABLE == 1'b1 && PADDR == 3'b000 &&  && PWDATA[28] == 1'b0)
	 begin
	    uartenb_int <= !PWDATA[31];
	    intgenenb_int <= !PWDATA[30];
	    timeoutintenb_int <= !PWDATA[29];
	    dmareqenb_int <= !PWDATA[27];
	    parity_int    <= PWDATA[26:25];
	    databit_int   <= PWDATA[24];
	    stopbit_int   <= PWDATA[23];
	    loopbackenb_int <= !PWDATA[22];
	    txwaterlevel_int  <= PWDATA[13:8];
	    rxwaterlevel_int  <= PWDATA[5:0];
	 end
     end
	
   always@(posedge clk or negedge rstb )
     begin
       if ( rstb == 1'b0 )
		swrstb_int <= 1'b1 ;
       else if ( PSEL == 1'b1 && PWRITE == 1'b1 && PENABLE == 1'b1 
	                      && PADDR == 3'b000 && PWDATA[28] == 1'b1)
		swrstb_int <= 1'b0 ;
       else
		swrstb_int <= 1'b1 ;
     end
  
   assign swrstb = swrstb_int;
   
   assign loopbackenb = loopbackenb_int;
   assign uartenb = uartenb_int;
   assign reg_0x0000 = { !uartenb_int , 	// 31
			 !intgenenb_int, 	// 30
			 !timeoutintenb_int, 	// 29
			 1'b0, // software reset // 28
			 !dmareqenb_int ,	 // 27
			 parity_int,		// 26~25
			 databit_int,		// 24
			 stopbit_int,		// 23
			 !loopbackenb_int,	// 22
			 8'b00000000,		// 21~14
			 txwaterlevel_int,	// 13~8
			 2'b00	,		// 7~6
			 rxwaterlevel_int	// 5~0
			 };

   assign databit = databit_int;
   assign parity  = parity_int ;
   assign stopbit = stopbit_int;

   // ------------------------------------------------------------
   // status register
   // 0x0004
   assign reg_0x0004    = 
			  { interrupt_status , // 31
			    MAX_FIFO_DEPTH   , // 30~28
			    txbusyb , // 27
			    rxbusyb , // 26
			    parityerrorb , // 25
			    frameerrorb  , // 24
			    overrunerrorb , // 23
			    receivetimeoutb , // 22
			    5'b00000,		// 21~17
			    txfifo_fillb,  	// 16
			    txfifo_fullb,  	// 15
			    txdmareqb_int, 	// 14
			    txfifocnt  , 	// 13~8
			    1'b0 , 		// 7
			    rxdmareqb_int ,	// 6
			    rxfifocnt };	// 5~0

   assign txdmareqb_int = ( dmareqenb_int == 1'b0 &&
			   txfifocnt <= txwaterlevel_int )? 0 : 1 ;
   assign rxdmareqb_int = ( dmareqenb_int == 1'b0 &&
			   rxfifocnt >= rxwaterlevel_int )? 0 : 1 ;

   assign txdmareqb = txdmareqb_int;
   assign rxdmareqb = rxdmareqb_int;
   
   //------------------------------------------------------------
   // interrupt status
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  interrupt_status <= 1'b1 ;
	else if ( swrstb_int == 1'b1 )
	  interrupt_status <= 1'b1 ;
	else if ( parityerrorb == 1'b0 || frameerrorb == 1'b0 ||
		  overrunerrorb == 1'b0 || receivetimeoutb == 1'b0 ||
		  ( dmareqenb_int == 1'b1 && // dmareq is disabled and
		    (
		      txfifocnt <= txwaterlevel_int ||
		      rxfifocnt >= rxwaterlevel_int
		     )
		  ) ||
		  (
			dmareqenb_int == 1'b0 &&
			(
				txfifo_emptyb == 1'b0 ||   // TxFIFO Empty
				rxfifocnt     == 6'b001000 // RxFIFO Full
			)
	          )
		)
	  interrupt_status <= 1'b0 ;
	else
	  interrupt_status <= 1'b1 ;
	
     end

   assign intb = interrupt_status;
   

   // ------------------------------------------------------------
   // clock divide register  0x0008   
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  clkdiv <= 16'b0000000000;
	else if ( PWRITE == 1'b1 && PADDR == 3'b010 && PSEL == 1'b1 && PENABLE == 1'b1)
	  clkdiv <= PWDATA[15:0];
     end

   assign reg_0x0008 = { 16'b0000000000000000 , clkdiv };

   assign baudx16clk = baudx16clk_int;
   
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  begin
	     clkdivcnt <= 16'b0000000000000000;
	     clkdivcnt_msb_dly <= 1'b0;
	     baudx16clk_int <= 1'b0;
	  end
	else if ( uartenb_int == 1'b0 )
	  begin
	    begin
		clkdivcnt <= clkdivcnt + clkdiv;
		clkdivcnt_msb_dly <= clkdivcnt[15];
		if ( clkdivcnt[15] == 1'b1 && clkdivcnt_msb_dly == 1'b0 )
	           baudx16clk_int <= 1'b1;
	        else
	           baudx16clk_int <= 1'b0;
	    end
	  end
     end
   
   //------------------------------------------------------------
   // txfifo write
   // 0x000C
   assign fifodaa_tx = PWDATA[7:0];
   assign fifowrb    = ( PWRITE == 1'b1 && PADDR == 3'b011 && PSEL == 1'b1 && PENABLE == 1'b1 )?1'b0:1'b1;
   
   //------------------------------------------------------------------
   // rxfifo read
   // 0x0010
   assign rxfifo_data = fifodata_rx ;

   assign reg_0x0010  = { 24'b000000000000000000000000 , fifodata_rx } ;
	
   assign fifordb     = ( PWRITE == 1'b0 && PADDR == 3'b100 && PSEL == 1'b1 && PENABLE == 1'b1 )?1'b0:1'b1;

   //------------------------------------------------------------------
   // receive timeout count
   // 0014     0001 0100 
   
   always @ ( posedge clk  or negedge rstb)
     begin
	if ( rstb == 1'b0 )
	  timeoutcnt <= 20'b00000000000000000000;
	else if ( PWRITE == 1'b1 && PADDR == 3'b101 && PSEL == 1'b1 && PENABLE == 1'b1 )
	  timeoutcnt <= PWDATA[19:0];
     end

     assign reg_0x0014 = { 12'b000000000000 , timeoutcnt };
   
   // timeout count
//   always @ ( posedge clk )
//     begin
//	if ( rstb == 1'b0 )
//	  dly_1mhz <= 1'b0;
//	else
//	  dly_1mhz <= CLK1MHZ;
//     end
   

//   assign clk1mhz_int = ( dly_1mhz == 1'b0 && CLK1MHZ == 1'b1 )? 1 : 0 ;

   always @ ( posedge clk or negedge rstb )
      begin
	 if ( rstb == 1'b0 )
	      timeoutcnt_int <= 20'b00000000000000000000;
	 else if ( swrstb_int == 1'b0 || timeoutintenb_int == 1'b1 || bytereceivedb == 1'b0 )
	      timeoutcnt_int <= 20'b00000000000000000000;
	 else if ( baudx16clk_int == 1'b1 && timeoutintenb_int == 1'b0 )
	      timeoutcnt_int <= timeoutcnt_int + 1;
	 else
	   timeoutcnt_int <= timeoutcnt_int;	 
      end

   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  receivetimeoutb <= 1'b1;
	else if ( swrstb_int == 1'b0 || timeoutintenb_int == 1'b1 )
	  receivetimeoutb <= 1'b1;
	else if ( timeoutcnt_int == timeoutcnt )
	  receivetimeoutb <= 1'b0 ;
	else
	  receivetimeoutb <= receivetimeoutb ;
     end // always @ ( posedge clk )
	   
       
endmodule
