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
   frameerror, 
   overrunerror, 
   parityerror, 
   rstb, 
   rxbusy, 
   rxfifocnt, 
   rxfifoempty, 
   txbusy, 
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
   int, 
   loopbacken, 
   parity, 
   rxdmareq, 
   stopbit, 
   swrst, 
   txdmareq, 
   uarten,
   frameerr_clear,
   parityerr_clear,
   overrunerr_clear
);

parameter UART_FIFO_CONFIG = 3'b011;

parameter UART_FIFO_WIDTH = (UART_FIFO_CONFIG == 3'b011) ? 5 : ((UART_FIFO_CONFIG == 3'b010) ? 4 : ((UART_FIFO_CONFIG == 3'b001) ? 3 : 0));


// Internal Declarations

input  [4:2]  PADDR;
input         PENABLE;
input         PSEL;
input  [31:0] PWDATA;
input         PWRITE;
input         bytereceivedb;
input         clk;
input  [7:0]  fifodata_rx;
input         frameerror;
input         overrunerror;
input         parityerror;
input         rstb;
input         rxbusy;
input  [UART_FIFO_WIDTH:0]  rxfifocnt;
input         rxfifoempty;
input         txbusy;
input         txfifo_emptyb;
input         txfifo_fillb;
input         txfifo_fullb;
input  [UART_FIFO_WIDTH:0]  txfifocnt;
output [31:0] PRDATA;
output        baudx16clk;
output        databit;
output [7:0]  fifodata_tx;
output        fifordb;
output        fifowrb;
output        int;
output        loopbacken;
output [1:0]  parity;
output        rxdmareq;
output        stopbit;
output        swrst;
output        txdmareq;
output        uarten;
output        frameerr_clear;
output        parityerr_clear;
output        overrunerr_clear;

wire [4:2] PADDR;
wire PENABLE;
wire PSEL;
wire [31:0] PWDATA;
wire PWRITE;
wire bytereceivedb;
wire clk;
wire [7:0] fifodata_rx;
wire frameerror;
wire overrunerror;
wire parityerror;
wire rstb;
wire rxbusy;
wire [UART_FIFO_WIDTH:0] rxfifocnt;
wire rxfifoempty;
wire txbusy;
wire txfifo_emptyb;
wire txfifo_fillb;
wire txfifo_fullb;
wire [UART_FIFO_WIDTH:0] txfifocnt;
wire [31:0] PRDATA;
wire baudx16clk;
wire databit;
wire [7:0] fifodata_tx;
wire fifordb;
wire fifowrb;
wire int;
wire loopbacken;
wire [1:0] parity;
wire rxdmareq;
wire stopbit;
wire swrst;
wire txdmareq;
wire uarten;

   reg swrst_int ;
   reg uarten_int ;
   reg intgenen_int ;
   reg dmareqen_int ;
   reg [1:0] parity_int    ;
   reg databit_int   ;
   reg stopbit_int   ;
   reg [5:0] txwaterlevel_int ;
   reg [5:0] rxwaterlevel_int;
   reg       timeoutinten_int;
	
   reg [15:0] clkdiv ;
   //reg [15:0] blkdivcnt;

   reg       receivetimeout;
   reg       interrupt_status;

   wire      txdmareq_int ;
   wire      rxdmareq_int;
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
   reg loopbacken_int ;

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
reg txfifo_inten;
reg rxfifo_inten;
   always@(posedge clk or negedge rstb )
     begin
       if ( rstb == 1'b0 )
	 begin
	    uarten_int <= 1'b0;
	    intgenen_int <= 1'b0 ; // enable interrupt generation
	    timeoutinten_int <= 1'b0 ; // Enable timeout interrupt
	    dmareqen_int  <= 1'b0;
	    parity_int <= 2'b00; // parity
	    databit_int <= 1'b0;
	    stopbit_int <= 1'b0;
	    loopbacken_int <= 1'b0;
	    txwaterlevel_int <= 6'b000000;
	    rxwaterlevel_int <= 6'b000000;
		txfifo_inten <= 0;
		rxfifo_inten <= 0;
	 end
       else if( PSEL == 1'b1 && PWRITE == 1'b1 && PENABLE == 1'b1 && PADDR == 3'b000 && PWDATA[28] == 1'b0)
	 begin
	    uarten_int <= PWDATA[31];
	    intgenen_int <= PWDATA[30];
	    timeoutinten_int <= PWDATA[29];
	    dmareqen_int <= PWDATA[27];
	    parity_int    <= PWDATA[26:25];
	    databit_int   <= PWDATA[24];
	    stopbit_int   <= PWDATA[23];
	    loopbacken_int <= PWDATA[22];
		txfifo_inten <= PWDATA[15];
	    txwaterlevel_int  <= PWDATA[13:8];
		rxfifo_inten <= PWDATA[7];
	    rxwaterlevel_int  <= PWDATA[5:0];
	 end
     end
	
   always@(posedge clk or negedge rstb )
     begin
       if ( rstb == 1'b0 )
		swrst_int <= 1'b0 ;
       else if ( PSEL == 1'b1 && PWRITE == 1'b1 && PENABLE == 1'b1 
	                      && PADDR == 3'b000 && PWDATA[28] == 1'b1)
		swrst_int <= 1'b1 ;
       else
		swrst_int <= 1'b0 ;
     end
  
   assign swrst = swrst_int;
   
   assign loopbacken = loopbacken_int;
   assign uarten = uarten_int;
   assign reg_0x0000 = { uarten_int , 	// 31
			 intgenen_int, 	// 30
			 timeoutinten_int, 	// 29
			 1'b0, // software reset // 28
			 dmareqen_int ,	 // 27
			 parity_int,		// 26~5
			 databit_int,		// 24
			 stopbit_int,		// 23
			 loopbacken_int,	// 22
			 6'b000000,		// 21~16
			 txfifo_inten,	// 15
			 1'b0	,		// 14
			 txwaterlevel_int,	// 13~8
			 rxfifo_inten,	// 7
			 1'b0	,		// 6
			 rxwaterlevel_int	// 5~0
			 };

   assign databit = databit_int;
   assign parity  = parity_int ;
   assign stopbit = stopbit_int;

wire [5:0] rxfifocnt_int;
assign rxfifocnt_int = (UART_FIFO_WIDTH == 5) ? rxfifocnt : {{(5-UART_FIFO_WIDTH){1'b0}}, rxfifocnt};
wire [5:0] txfifocnt_int;
assign txfifocnt_int = (UART_FIFO_WIDTH == 5) ? txfifocnt : {{(5-UART_FIFO_WIDTH){1'b0}}, txfifocnt};

   // ------------------------------------------------------------
   // status register
   // 0x0004
reg txfifo_interrupt;
reg rxfifo_interrupt;
   assign reg_0x0004    = 
			  { interrupt_status, // 31
			    UART_FIFO_CONFIG, // 30~28
			    txbusy , // 27
			    rxbusy , // 26
			    parityerror, // 25
			    frameerror, // 24
			    overrunerror , // 23
			    receivetimeout , // 22
			    6'b000000,		// 21~16
			    txfifo_interrupt,  	// 15
			    txdmareq_int, 	// 14
			    txfifocnt_int  , 	// 13~8
			    rxfifo_interrupt, 		// 7
			    rxdmareq_int ,	// 6
			    rxfifocnt_int};	// 5~0

wire txfifo_under_waterlevel;
wire rxfifo_over_waterlevel;
assign txfifo_under_waterlevel = (txfifocnt_int <= txwaterlevel_int) ? 1 : 0 ;
assign rxfifo_over_waterlevel = (rxfifocnt_int > rxwaterlevel_int) ? 1 : 0 ;

assign txdmareq_int = (dmareqen_int == 1'b1 && txfifo_under_waterlevel) ? 1 : 0 ;
assign rxdmareq_int = (dmareqen_int == 1'b1 && rxfifo_over_waterlevel) ? 1 : 0 ;

assign txdmareq = txdmareq_int;
assign rxdmareq = rxdmareq_int;
   
   //------------------------------------------------------------
   // interrupt status
always @ ( posedge clk or negedge rstb )
begin
	if(!rstb)
	begin
		txfifo_interrupt <= 0;
		rxfifo_interrupt <= 0;
	end
	else
	begin
		if(txfifo_inten && txfifo_under_waterlevel)
			txfifo_interrupt <= 1'b1;
		else
			txfifo_interrupt <= 1'b0;

		if(rxfifo_inten && rxfifo_over_waterlevel)
			rxfifo_interrupt <= 1'b1;
		else
			rxfifo_interrupt <= 1'b0;
	end
end

   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  interrupt_status <= 1'b0 ;
	else if ( swrst_int == 1'b1 || intgenen_int == 0 )
	  interrupt_status <= 1'b0 ;
	else if ( parityerror == 1'b1 || frameerror == 1'b1 ||
		  overrunerror == 1'b1 || receivetimeout == 1'b1 ||
			txfifo_interrupt == 1'b1 || rxfifo_interrupt == 1'b1)
	  interrupt_status <= 1'b1 ;
	else
	  interrupt_status <= 1'b0 ;
	
     end

   assign int = interrupt_status;
   

reg frameerr_clear;
reg parityerr_clear;
reg overrunerr_clear;

   always @ ( posedge clk or negedge rstb)
	begin
		if( rstb == 1'b0)
		begin
			frameerr_clear <= 1'b0;
			parityerr_clear <= 1'b0;
			overrunerr_clear <= 1'b0;
		end
		else
		begin
			if (PSEL == 1'b1 && PWRITE == 1'b1 && PENABLE == 1'b1 && PADDR == 3'b001)
			begin
				frameerr_clear <= PWDATA[24];
				parityerr_clear <= PWDATA[25];
				overrunerr_clear <= PWDATA[23];
			end
			else
			begin
				frameerr_clear <= 1'b0;
				parityerr_clear <= 1'b0;
				overrunerr_clear <= 1'b0;
			end
		end
	end
	
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
	else if ( uarten_int == 1'b1 )
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
   assign fifowrb    = ( PWRITE == 1'b1 && PADDR == 3'b011 && PSEL == 1'b1 && PENABLE == 1'b1 )?1'b0:1'b1;
   
   //------------------------------------------------------------------
   // rxfifo read
   // 0x0010
   assign rxfifo_data = fifodata_rx ;

   assign reg_0x0010  = { 24'b000000000000000000000000 , fifodata_rx } ;
	
   assign fifordb     = ( PWRITE == 1'b0 && PADDR == 3'b100 && PSEL == 1'b1 && PENABLE == 1'b1) ? 1'b0 : 1'b1;

   //------------------------------------------------------------------
   // receive timeout count
   // 0014     0001 0100 
   
   always @ ( posedge clk or negedge rstb )
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
	 else if ( swrst_int == 1'b1 || timeoutinten_int == 1'b0 || bytereceivedb == 1'b0 || rxfifoempty == 1'b1 )
	      timeoutcnt_int <= 20'b00000000000000000000;
	 else if ( baudx16clk_int == 1'b1 && timeoutinten_int == 1'b1 )
	      timeoutcnt_int <= timeoutcnt_int + 1;
	 else
	   timeoutcnt_int <= timeoutcnt_int;	 
      end

   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  receivetimeout <= 1'b0;
	else if ( swrst_int == 1'b1 || timeoutinten_int == 1'b0 )
	  receivetimeout <= 1'b0;
	else if ( timeoutcnt_int == timeoutcnt )
	  receivetimeout <= 1'b1 ;
	else
	  receivetimeout <= receivetimeout;
     end // always @ ( posedge clk )
	   
       
endmodule
