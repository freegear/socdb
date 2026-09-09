//
// Verilog Module UART_lib.TxBlock.arch_name
//
// Created:
//          by - Administrator.UNKNOWN (GUNDAM)
//          at - 00:10:15 2006-10-27
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
  
module TxBlock( 
   baudx16clk, 
   clk, 
   databit, 
   fifodata_tx, 
   fifowrb, 
   parity, 
   rstb, 
   stopbit, 
   swrstb, 
   uartenb, 
   txbusyb, 
   txd, 
   txfifo_emptyb, 
   txfifo_fillb, 
   txfifo_fullb, 
   txfifocnt
);


// Internal Declarations

input        baudx16clk;
input        clk;
input        databit;
input  [7:0] fifodata_tx;
input        fifowrb;
input  [1:0] parity;
input        rstb;
input        stopbit;
input        swrstb;
input        uartenb;
output       txbusyb;
output       txd;
output       txfifo_emptyb;
output       txfifo_fillb;
output       txfifo_fullb;
output [5:0] txfifocnt;


wire baudx16clk;
wire clk;
wire databit;
wire [7:0] fifodata_tx;
wire fifowrb;
wire [1:0] parity;
wire rstb;
wire stopbit;
wire swrstb;
wire uartenb;
wire txbusyb;
wire txd;
wire txfifo_emptyb;
wire txfifo_fillb;
wire txfifo_fullb;
wire [5:0] txfifocnt;
   
   reg 	   txclk;
   
   reg [14:0] current_state , next_state;

   parameter  ST_IDLE      = 15'b000000000000001;
   parameter  ST_LOADDATA  = 15'b000000000000010;
   parameter  ST_WAITTXCLK = 15'b000000000000100;
   parameter  ST_START     = 15'b000000000001000;
   parameter  ST_DATA0     = 15'b000000000010000;
   parameter  ST_DATA1     = 15'b000000000100000;
   parameter  ST_DATA2     = 15'b000000001000000;
   parameter  ST_DATA3     = 15'b000000010000000;
   parameter  ST_DATA4     = 15'b000000100000000;
   parameter  ST_DATA5     = 15'b000001000000000;
   parameter  ST_DATA6     = 15'b000010000000000;
   parameter  ST_DATA7     = 15'b000100000000000;
   parameter  ST_PARITYBIT = 15'b001000000000000;
   parameter  ST_STOP0     = 15'b010000000000000;
   parameter  ST_STOP1     = 15'b100000000000000;
   
   
   wire  cst_idle     = current_state[0];
   wire  cst_loaddata = current_state[1];
   wire  cst_waittxclk = current_state[2];
   wire  cst_start    = current_state[3];   
   wire  cst_data0    = current_state[4];
   wire  cst_data1    = current_state[5];
   wire  cst_data2    = current_state[6];
   wire  cst_data3    = current_state[7];
   wire  cst_data4    = current_state[8];
   wire  cst_data5    = current_state[9];
   wire  cst_data6    = current_state[10];
   wire  cst_data7    = current_state[11];
   wire  cst_paritybit = current_state[12];
   wire  cst_stop0    = current_state[13];
   wire  cst_stop1    = current_state[14];


   wire  nst_idle     = next_state[0];
   wire  nst_loaddata = next_state[1];
   wire  nst_waittxclk = next_state[2];
   wire  nst_start    = next_state[3];   
   wire  nst_data0    = next_state[4];
   wire  nst_data1    = next_state[5];
   wire  nst_data2    = next_state[6];
   wire  nst_data3    = next_state[7];
   wire  nst_data4    = next_state[8];
   wire  nst_data5    = next_state[9];
   wire  nst_data6    = next_state[10];
   wire  nst_data7    = next_state[11];
   wire  nst_paritybit = next_state[12];
   wire  nst_stop0    = next_state[13];
   wire  nst_stop1    = next_state[14];
   
       
`define FIFO_DEPTH        8
`define FIFO_COUNT_WIDTH  3
   
   reg [7:0] txfifo [`FIFO_DEPTH - 1:0];
   reg [`FIFO_COUNT_WIDTH   :0] fifocnt;
   reg [`FIFO_COUNT_WIDTH -1:0] fifo_wrpos;
   reg [`FIFO_COUNT_WIDTH -1:0] fifo_rdpos;
   
   reg 			       fifordb ;
   reg [3:0] 		       txdoutsel ;

   parameter 		       TXO_IDLE   = 4'b0001;
   parameter                   TXO_START  = 4'b0010;   
   parameter                   TXO_DATA   = 4'b0100;
   parameter 		       TXO_PARITY = 4'b1000;
		       
   wire 		       shiftout;
   wire			       even_parity;
   wire 		       odd_parity;
   reg  		       parity_int;

   reg [7:0] shiftreg;
   wire [7:0] fifo_dout;
   reg 	     shiftenb;

   reg 	     txbusyb_int;

   assign    txbusyb = txbusyb_int;
   
   reg txd_int ;

   assign txd = txd_int;

   //////////////////////////////////////////////
   // select txd out
   always @ ( txdoutsel or txclk or rstb or shiftout or  parity or even_parity,odd_parity)
     begin
	case ( txdoutsel ) /* synthesis parallel_case full_case */
	  TXO_IDLE  :   txd_int <= 1'b1;	  
	  TXO_START :   txd_int <= 1'b0;	  
	  TXO_DATA  :   txd_int <= shiftout;	  
	  TXO_PARITY:
	                if ( parity == 2'b10 )
			  txd_int <= even_parity;
	                else
			  txd_int <= odd_parity;	  	  
	endcase 
     end

   reg dtxclk ;
   
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  dtxclk <= 1'b0 ;
	else
	  dtxclk <= txclk;	
     end
   
   // Parity generation
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  parity_int <= 1'b0;
	else if ( fifordb == 1'b0 )
	  parity_int <= 1'b0;
	else if ( shiftenb== 1'b0 && dtxclk == 1'b1 )
	  parity_int <= parity_int ^ shiftout;	
     end

   assign odd_parity   = ~parity_int;
   assign even_parity  =  parity_int;

   //////////////////////////////////////////////
   // shift register
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  begin
	     shiftreg <= 8'b00000000;
	     //shiftout <= 1'b1;
	  end
	else
	  begin
	     if ( fifordb  == 1'b0 )
	       begin
		  shiftreg <= fifo_dout;
		  //shiftout <= 1'b1;
	       end 
	     else if ( shiftenb == 1'b0 && txclk == 1'b1 )
	       begin
		  shiftreg <= { shiftreg[7] , shiftreg[7:1]  } ;
		  //shiftout <= shiftreg[7];
	       end
	  end
     end  // end of always

   assign shiftout = shiftreg[0];
   
   //////////////////////////////////////////////
   // State Machine
   //
   //reg paritybit_outb;
   //reg stopbit_outb;
   //reg startbit_outb;
   wire fifo_fillb;
   //reg [4:0] fifo_cnt ;
   
   reg 	txclkcntenb;
   reg  [3:0] txclkcnt;
   
   // txclkcntenb
   always @ ( posedge clk or negedge rstb )
     begin
	if (rstb == 1'b0 )
	  begin
	     txclkcnt <= 4'b0000;
	     txclk    <= 1'b0;
	  end
	else if ( txclkcntenb == 1'b1 || swrstb == 1'b0 )
	  begin
	     txclkcnt <= 4'b0000;
	     txclk <= 1'b0 ;
	  end
	else if ( baudx16clk == 1'b1 )
	  begin
	     txclkcnt <= txclkcnt + 1;
	     txclk    <= ( txclkcnt == 4'b0010 )? 1'b1 : 1'b0;
	  end
	else
	  begin
	     txclkcnt <= txclkcnt ;
	     txclk    <= 1'b0;
	  end
	
     end

   
   // define control
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  begin
	     shiftenb <= 1'b1;
	     //paritybit_outb <= 1'b1;
	     //stopbit_outb   <= 1'b1;
	     //startbit_outb  <= 1'b1;
	     fifordb        <= 1'b1;
	     txdoutsel      <= TXO_IDLE;
	     txclkcntenb    <= 1'b1;
	     txbusyb_int    <= 1'b1;	     
	  end
	else
	  begin
	     case (1'b1) /* synthesis parallel_case full_case */
	       nst_idle:
		     begin
		          shiftenb <= 1'b1;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_IDLE;
			  txclkcntenb    <= 1'b1;
			  txbusyb_int    <= 1'b1;	     
		     end
	       nst_loaddata:
		     begin
		          shiftenb <= 1'b1;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b0;
	                  txdoutsel      <= TXO_IDLE;
			  txclkcntenb    <= 1'b1;
			  txbusyb_int    <= 1'b0;	     
		     end
	       nst_waittxclk:
		     begin
		          shiftenb <= 1'b1;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;	
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_IDLE;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		     end
	       nst_start:
		     begin
		          shiftenb <= 1'b1;	       
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b0;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_START;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		     end
	       
	       nst_data0:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_data1:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_data2:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_data3:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end 
	       nst_data4:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_data5:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_data6:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_data7:
		 begin
		          shiftenb <= 1'b0;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_DATA;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		    end
	       nst_paritybit:
		 begin
		          shiftenb <= 1'b1;
	                  //paritybit_outb <= 1'b0;
	                  //stopbit_outb   <= 1'b1;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_PARITY;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_stop0:
		 begin
		          shiftenb <= 1'b1;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b0;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_IDLE;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	       nst_stop1:
		 begin
		          shiftenb <= 1'b1;
	                  //paritybit_outb <= 1'b1;
	                  //stopbit_outb   <= 1'b0;
	                  //startbit_outb  <= 1'b1;
	                  fifordb        <= 1'b1;
	                  txdoutsel      <= TXO_IDLE;
			  txclkcntenb    <= 1'b0;
			  txbusyb_int    <= 1'b0;	     			
		 end
	     endcase
	  end
	end // end of always


   
   // current state
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  current_state = ST_IDLE;
	else if ( swrstb == 1'b0 )
	  current_state = ST_IDLE;
	else 
	  current_state = next_state;
     end
   
   // next state
   always @ ( clk or txclk or rstb or uartenb or databit or  fifo_fillb or cst_idle or cst_loaddata 
   			  or stopbit or cst_paritybit or cst_waittxclk or cst_start or cst_stop1 or cst_stop0 
			  or cst_data0 or cst_data1 or cst_data2 or cst_data3 or cst_data4 or cst_data5 or cst_data6
			  or cst_data7 or parity)
     begin
	//next_state = ST_IDLE;

	case(1'b1)  /* synthesis parallel_case full_case */
	  cst_idle:
	     if( uartenb == 1'b0 && fifo_fillb == 1'b0 )
	       next_state <= ST_LOADDATA;
	     else
	       next_state <= ST_IDLE;

	  cst_loaddata:
	       next_state <= ST_WAITTXCLK;	  
	  cst_waittxclk:
	       if ( txclk == 1'b1 )
		 next_state <= ST_START;
	       else
		 next_state <= ST_WAITTXCLK;	  
	  cst_start:
	       if ( txclk == 1'b1 )
		 next_state <= ST_DATA0;
	       else
		 next_state <= ST_START;	  
	  cst_data0:
	       if ( txclk == 1'b1 )
		 next_state <= ST_DATA1;
	       else
		 next_state <= ST_DATA0;	  
	  cst_data1: 
	       if ( txclk == 1'b1 )
		 next_state <= ST_DATA2;
	       else
		 next_state <= ST_DATA1;
	  cst_data2: 
	       if ( txclk == 1'b1 )
		 next_state <= ST_DATA3;
	       else
		 next_state <= ST_DATA2;
	  cst_data3: 
	       if ( txclk == 1'b1 )
		 next_state <= ST_DATA4;
	       else
		 next_state <= ST_DATA3;
	  cst_data4: 
	       if ( txclk == 1'b1 )
		 next_state <= ST_DATA5;
	       else
		 next_state <= ST_DATA4;
	  cst_data5: 
	       if ( txclk == 1'b1 )
		 if ( databit == 1'b0 ) 
		   next_state <= ST_DATA7; // data bit 6
	         else
		   next_state <= ST_DATA6; // data bit 7
	       else
		 next_state <= ST_DATA5;
	  cst_data6:
	       if ( txclk == 1'b1 ) 
		 next_state <= ST_DATA7;
	       else
		 next_state <= ST_DATA6;	    
	  cst_data7:
	       if ( txclk == 1'b1 )
		 begin
		    if ( parity == 2'b00 )
		      next_state <= ST_STOP0 ;
		    else
		      next_state <= ST_PARITYBIT;
		 end
	       else
		 next_state <= ST_DATA7;	  
	  cst_paritybit:
	       if ( txclk == 1'b1 )
		 next_state <= ST_STOP0;
	       else
		 next_state <= ST_PARITYBIT;	  
	  cst_stop0:
	       if ( txclk == 1'b1 )
		 begin
		    if ( stopbit == 1'b0 )
		      if ( uartenb == 1'b0 && fifo_fillb == 1'b0 )
			next_state <= ST_LOADDATA;
		      else
			next_state <= ST_IDLE;		    
		    else
		      next_state <= ST_STOP1;
		 end 
	       else
		 next_state <= ST_STOP0;
	  
	  cst_stop1:
	    if ( txclk == 1'b1 )
	      begin
		 if( uartenb == 1'b0 && fifo_fillb == 1'b0 )
		   next_state <= ST_LOADDATA ;
		 else
		   next_state <= ST_IDLE;
	      end
	    else
	      next_state <= ST_STOP1;
	  
	  //default : next_state <= ST_IDLE;
	  
	  endcase
     end

   
   
//////////////////////////////////////////////   
// FIFO counter
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 ) 
	  fifocnt <= 4'h0;
	else if ( swrstb == 1'b0 )
	  fifocnt <= 4'h0;
	else if ( fifowrb == 1'b0 && fifordb == 1'b1)
	  fifocnt <= fifocnt + 1;
	else if ( fifordb == 1'b0 && fifowrb == 1'b1)
	   fifocnt <= fifocnt - 1;
     end

   always @ (posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  fifo_wrpos <= 3'h0 ;
	else if ( swrstb == 1'b0 )
	  fifo_wrpos <= 3'h0 ;
	else if ( fifowrb == 1'b0 )
	  fifo_wrpos <= fifo_wrpos + 1 ;
     end // end of always

   always @ (posedge clk or negedge rstb )
     begin
	if (rstb == 1'b0 )
	  fifo_rdpos <= 3'h0;
	else if ( swrstb  == 1'b0 )
	  fifo_rdpos <= 3'h0 ;
	else if ( fifordb == 1'b0 )
	  fifo_rdpos <= fifo_rdpos + 1;
     end // end of always

   integer    i;
   
    // FIFO Write Data
    always @ ( posedge clk or negedge rstb )
      begin
	 if ( rstb == 1'b0 )
	   for (i=0;i<8;i =i+1)
	     txfifo[i] <= {8{1'b0}};
	 
	 else if ( fifowrb == 1'b0 )
	   txfifo[fifo_wrpos] <= fifodata_tx;

     end // end of always

   assign fifo_dout    = txfifo[fifo_rdpos];
   
   //assign fifo_rd_data = txfifo[fifo_rdpos];
   assign fifo_fillb   = (fifocnt != 4'b0000)?0:1;
   assign fifo_fullb   = (fifocnt == 4'b1000)?0:1;
   assign fifo_emptyb  = (fifocnt == 4'b0000)?0:1;
   
   assign txfifocnt    = { 2'b00 , fifocnt } ;  // [5:0] = [3:0]
   assign txfifo_fillb = fifo_fillb ;
   assign txfifo_fullb = fifo_fullb ;
   assign txfifo_emptyb = fifo_emptyb;
   
endmodule
   
