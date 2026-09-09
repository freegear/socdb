//
// Verilog Module UART_lib.RxBlock.arch_name
//
// Created:
//          by - Administrator.UNKNOWN (GUNDAM)
//          at - 00:10:56 2006-10-27
//
// using Mentor Graphics HDL Designer(TM) 2004.1 (Build 41)
//

`resetall
`timescale 1ns/10ps
module RxBlock( 
   baudx16clk, 
   clk, 
   databit, 
   fifordb, 
   loopbackenb, 
   parity, 
   rstb, 
   rxd, 
   stopbit, 
   swrstb, 
   txd, 
   uartenb, 
   bytereceivedb, 
   fifodata_rx, 
   frameerrorb, 
   overrunerrorb, 
   parityerrorb, 
   rxbusyb, 
   rxfifocnt
);


// Internal Declarations

input        baudx16clk;
input        clk;
input        databit;
input        fifordb;
input        loopbackenb;
input  [1:0] parity;
input        rstb;
input        rxd;
input        stopbit;
input        swrstb;
input        txd;
input        uartenb;
output       bytereceivedb;
output [7:0] fifodata_rx;
output       frameerrorb;
output       overrunerrorb;
output       parityerrorb;
output       rxbusyb;
output [5:0] rxfifocnt;


wire baudx16clk;
wire clk;
wire databit;
wire fifordb;
wire loopbackenb;
wire [1:0] parity;
wire rstb;
wire rxd;
wire stopbit;
wire swrstb;
wire txd;
wire uartenb;
wire bytereceivedb;
wire [7:0] fifodata_rx;
wire frameerrorb;
wire overrunerrorb;
wire parityerrorb;
wire rxbusyb;
wire [5:0] rxfifocnt;


   reg [17:0] current_state , next_state;
   
   //--------------------------------------------------
   // Define parameter
   parameter ST_IDLE             = 18'b000000000000000001;
   parameter ST_WAIT_STARTBIT    = 18'b000000000000000010;
   parameter ST_DETECT_STARTBIT0 = 18'b000000000000000100;
   parameter ST_DETECT_STARTBIT1 = 18'b000000000000001000;
   parameter ST_DETECT_STARTBIT2 = 18'b000000000000010000;
   parameter ST_GOOD_STARTBIT    = 18'b000000000000100000;   
   parameter ST_DATA0            = 18'b000000000001000000;
   parameter ST_DATA1            = 18'b000000000010000000;
   parameter ST_DATA2            = 18'b000000000100000000;
   parameter ST_DATA3            = 18'b000000001000000000;
   parameter ST_DATA4            = 18'b000000010000000000;
   parameter ST_DATA5            = 18'b000000100000000000;
   parameter ST_DATA6            = 18'b000001000000000000;
   parameter ST_DATA7            = 18'b000010000000000000;
   parameter ST_PARITY           = 18'b000100000000000000;
   parameter ST_STOP0            = 18'b001000000000000000;
   parameter ST_STOP1            = 18'b010000000000000000;
   parameter ST_FIFOWRB          = 18'b100000000000000000;
   //------------------------------------------------------------

   wire      cst_idle = current_state[0];
   wire      cst_wait_startbit = current_state[1];
   wire      cst_detect_startbit0 = current_state[2];
   wire      cst_detect_startbit1 = current_state[3];
   wire      cst_detect_startbit2 = current_state[4];
   wire      cst_good_startbit    = current_state[5];   
   wire      cst_data0 = current_state[6];
   wire      cst_data1 = current_state[7];
   wire      cst_data2 = current_state[8];
   wire      cst_data3 = current_state[9];
   wire      cst_data4 = current_state[10];
   wire      cst_data5 = current_state[11];
   wire      cst_data6 = current_state[12];
   wire      cst_data7 = current_state[13];
   wire      cst_parity = current_state[14];
   wire      cst_stop0 = current_state[15];
   wire      cst_stop1 = current_state[16];
   wire      cst_fifowrb = current_state[17];

   wire      nst_idle = next_state[0];
   wire      nst_wait_startbit = next_state[1];
   wire      nst_detect_startbit0 = next_state[2];
   wire      nst_detect_startbit1 = next_state[3];
   wire      nst_detect_startbit2 = next_state[4];
   wire      nst_good_startbit    = next_state[5];   
   wire      nst_data0 = next_state[6];
   wire      nst_data1 = next_state[7];
   wire      nst_data2 = next_state[8];
   wire      nst_data3 = next_state[9];
   wire      nst_data4 = next_state[10];
   wire      nst_data5 = next_state[11];
   wire      nst_data6 = next_state[12];
   wire      nst_data7 = next_state[13];
   wire      nst_parity = next_state[14];
   wire      nst_stop0 = next_state[15];
   wire      nst_stop1 = next_state[16];
   wire      nst_fifowrb = next_state[17];

   integer   i ; // index parameter
   
   reg        fifowrb;
   reg [2:0]  fifocnt;
   reg [2:0]  fifo_wrpos;
   reg [2:0]  fifo_rdpos;
   reg [7:0]  rxfifo [31:0] ;
   reg [7:0]  rxsftreg ;
   reg        rxclk    ;
   reg        rxsftenb ;
   reg        framechkb ;
   reg        paritychkb  ;
   wire       parityint   ;
   reg        parity_int  ;
//   reg        dataphase   ;
   reg        rxclkenb    ;
   reg [3:0]  rxclkcnt    ;
   reg        dataphaseb  ;
   //reg        setstateb   ;
   reg        rstparityb  ;
   reg        frameerrorb_int ;
   reg        parityerrorb_int ;
   
   reg        overrunerrorb_int ;
   
   reg        rxbusyb_int ;

   // FIFO Read Signal
   reg fifordb_dly ;
   reg fifordb_chk ;
   

   assign     bytereceivedb = fifowrb;
   assign     rxbusyb = rxbusyb_int ;
   


   always @ ( posedge clk or negedge rstb )
    begin
	if ( rstb == 1'b0 )
           begin
		fifordb_dly <= 1'b1 ;
		fifordb_chk <= 1'b1 ;
	   end
	else
	   begin
		fifordb_dly <= fifordb ;

		if ( fifordb_dly == 1'b0 && fifordb == 1'b1 )
			fifordb_chk <= 1'b0;
		else
			fifordb_chk <= 1'b1;
	   end

    end    

   //------------------------------------------------------------
   // FIFO
   // FIFO Counter
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  fifocnt <= 3'b000 ;
	else if ( fifowrb == 1'b0 && fifordb_chk == 1'b1 && fifocnt != 3'b100)
	  fifocnt <= fifocnt + 1;
	else if ( fifowrb == 1'b1 && fifordb_chk == 1'b0 && fifocnt != 3'b000)
	  fifocnt <= fifocnt - 1;
     end

   assign rxfifocnt = fifocnt ; // [5:0] = 
   
   always @ (posedge clk or negedge rstb )
     begin
	if (rstb == 1'b0)
	  overrunerrorb_int <= 1'b1 ;
	else if ( swrstb == 1'b0 )
	  overrunerrorb_int <= 1'b1 ;
	else if ( fifowrb == 1'b0 && fifordb_chk == 1'b1 && fifocnt == 3'b100 )
	  overrunerrorb_int <= 1'b0 ;
	else
	  overrunerrorb_int <= overrunerrorb_int;
     end
   
   assign overrunerrorb = overrunerrorb_int ;
   
   
   //fifo write position
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  fifo_wrpos <= 3'b00 ;
	else if ( fifowrb == 1'b0 )
	  fifo_wrpos <= fifo_wrpos + 1;
     end

   //fifo read position
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  fifo_rdpos <= 3'b000 ;
	else if ( fifordb_chk == 1'b0 )
	  fifo_rdpos <= fifo_rdpos + 1;
     end

   //fifo write data
   always @ ( posedge clk )
     begin
		//if ( rstb == 1'b0 )
		//  for ( i = 0 ; i < 32 ; i=i+1)
		//    rxfifo[i] = { 8{1'b0}};
		//else if (fifowrb == 1'b0 )
        if (fifowrb == 1'b0 )
	    rxfifo[fifo_wrpos] <= rxsftreg ; // fifodata_rx;
     end

   assign fifodata_rx = rxfifo[fifo_rdpos];

   //-------------------------------------------------------------
   // RX lowpass filter
	   parameter            DELAY_TAPS = 6;
	   reg [DELAY_TAPS-1:0] in_dly;
	   reg 			rx_lpfd;  // lowpass filtered rx input.
	   reg [2:0] 			sum;

           wire      rxd_loopback ;

	   assign rxd_loopback = (loopbackenb == 1'b0 )? txd : rxd;

	   always @(posedge clk or negedge rstb) begin
	      if(!rstb) 
		in_dly <= {DELAY_TAPS{1'b1}};
	      else if(baudx16clk) 
		in_dly <= {in_dly[DELAY_TAPS-2:0],rxd_loopback};
	   end // always @ (posedge clk or negedge resetb)

	   always@(in_dly or rxd) begin
		  sum = rxd;
		  for(i=0;i<DELAY_TAPS;i=i+1)
			sum = sum + {2'h0,in_dly[i]};
	   end // always
      
	   always @(posedge clk or negedge rstb) begin
	      if(!rstb) 
		rx_lpfd <= 1'b1;
	      else if(baudx16clk) 
		rx_lpfd <= sum[2];
	   end // always @ (posedge clk or negedge resetb)

   //------------------------------------------------------------
   // shift register
   always @ ( posedge clk or negedge rstb ) begin
	  if ( rstb == 1'b0 )
		rxsftreg <= 8'b00000000;
	  else begin
	     if ( rxsftenb == 1'b0 && rxclk == 1'b1 )
  		   rxsftreg <= { rx_lpfd , rxsftreg[7:1] };
	  end
   end
   
	
   
   //------------------------------------------------------------
   // frame check
   always @ (posedge clk or negedge rstb)
     begin
	if ( rstb == 1'b0 )
	  frameerrorb_int <= 1'b1 ;
	else if ( swrstb == 1'b0 )
	  frameerrorb_int <= 1'b1;
	else if ( rxclk == 1'b1 && framechkb == 1'b0 )
	  if ( rx_lpfd == 1'b0 )
	    frameerrorb_int <= 1'b0;
	  else
	    frameerrorb_int <= frameerrorb ;
     end

   assign frameerrorb = frameerrorb_int;
   
   //------------------------------------------------------------
   // Parity check
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  parityerrorb_int <= 1'b1 ;
	else if ( swrstb == 1'b0 )
	  parityerrorb_int <= 1'b1 ;
	else if ( rxclk == 1'b1 && paritychkb == 1'b0 )
	  if ( rx_lpfd != parityint )
	    parityerrorb_int <= 1'b0;
	  else
	    parityerrorb_int <= parityerrorb_int;
     end // always @ ( posedge clk )
   

   assign parityerrorb = parityerrorb_int ;
   

   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  parity_int <= 1'b0 ;
	else if ( rstparityb == 1'b0 )
	  parity_int <= 1'b0 ;
	else if ( dataphaseb == 1'b0 && rxclk == 1'b1 )
	  parity_int <= parity_int ^ rx_lpfd ;
     end

   assign parityint = ( parity == 2'b10 )? parity_int: !parity_int ;
  

   
   //------------------------------------------------------------
   // rxclock generation
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  begin
	     rxclk <= 1'b0 ;
	     rxclkcnt <= 4'b0000 ;
	  end
	else
	  begin
	     if (rxclkenb == 1'b0 )
	       begin		  
		  if ( baudx16clk == 1'b1 )
		       rxclkcnt <= rxclkcnt + 1 ;

		  if ( rxclkcnt == 4'b0011 && baudx16clk == 1'b1 )
		    rxclk <= 1'b1 ;
		  else
		    rxclk <= 1'b0 ;
		  
	       end
	     else
	       begin
		  rxclkcnt <= 4'b0000;
		  rxclk    <= 1'b0;
	       end // else: !if(rxclkenb == 1'b0)
	  end
	
	  
     end //
   
   //------------------------------------------------------------
   // State Machine
   // Define output
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  begin
	     rxclkenb <= 1'b1 ;
	     rxsftenb <= 1'b1 ;
	     paritychkb <= 1'b1 ; // Parity check
	     framechkb  <= 1'b1 ; // Frame error check
	     fifowrb    <= 1'b1 ; // FIFO Write
	     //setstateb  <= 1'b1 ; // Set Receive State
	     dataphaseb <= 1'b1 ; // Indicate data phase for parity check
	     rstparityb <= 1'b1 ; // Reset parity register
	     rxbusyb_int <= 1'b1 ;	     
	  end // end of if ( rstb == 1'b0 )
	else
	  begin
	     case ( 1'b1 )
	       nst_idle :
		 begin
		    rxclkenb <= 1'b1 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b1 ;	     
		 end
	       
	       nst_wait_startbit :
		 begin
		    rxclkenb <= 1'b1 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b1 ;	     
		 end
	       
	       nst_detect_startbit0 :
		 begin
		    rxclkenb <= 1'b1 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b1 ;	     
		 end
	       
	       nst_detect_startbit1 :
		 begin
		    rxclkenb <= 1'b1 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b1 ;	     
		 end
	       
               nst_detect_startbit2 :
		 begin
		    rxclkenb <= 1'b1 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b0 ; // Reset parity register
		    rxbusyb_int <= 1'b1 ;	     
		 end // case: nst_detect_startbit2
	       nst_good_startbit:
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b1 ;	     
		 end

               nst_data0 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register	
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data1 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check	
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data2 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data3 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data4 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data5 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
	            //setstateb  <= 1'b1 ; // Set Receive State
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data6 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_data7 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b0 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b0 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_parity :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b0 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_stop0 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b0 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_stop1 :
		 begin
		    rxclkenb <= 1'b0 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b0 ; // Frame error check
	            fifowrb    <= 1'b1 ; // FIFO Write
	            //setstateb  <= 1'b1 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
               nst_fifowrb :
		 begin
		    rxclkenb <= 1'b1 ; // Enable RX Clock
	            rxsftenb <= 1'b1 ; // Enable shift rx register
	            paritychkb <= 1'b1 ; // Parity check
	            framechkb  <= 1'b1 ; // Frame error check
	            fifowrb    <= 1'b0 ; // FIFO Write
	            //setstateb  <= 1'b0 ; // Set Receive State
		    dataphaseb <= 1'b1 ; // Indicate data phase for parity check
		    rstparityb <= 1'b1 ; // Reset parity register
		    rxbusyb_int <= 1'b0 ;	     
		 end
	       
	     endcase // case( 1'b1 )
	  end
     end
   
   // current state
   always @ ( posedge clk or negedge rstb )
     begin
	if ( rstb == 1'b0 )
	  current_state = ST_IDLE;
	else
	  current_state = next_state;	
     end // end of always 

   // next state
   always @ ( clk or uartenb or databit or baudx16clk or rx_lpfd or rxclk or parity or
              stopbit or cst_idle or cst_wait_startbit or cst_detect_startbit0 or 
	      cst_detect_startbit1 or cst_detect_startbit2 or cst_good_startbit or
	      cst_data0 or cst_data1 or cst_data2 or cst_data3 or cst_data4 or cst_data5 or
	      cst_data6 or cst_data7 or cst_parity or cst_stop0 or cst_stop1 or cst_fifowrb  )
     begin
	case ( 1'b1 ) /* synthesis parallel_case full_case */
             cst_idle :
	       if ( uartenb == 1'b0 )
		 next_state <= ST_WAIT_STARTBIT;
	       else
		 next_state <= ST_IDLE;
	  
             cst_wait_startbit :
	       if ( baudx16clk == 1'b1 )
		 begin 
		    if ( rx_lpfd == 1'b0 )
		      next_state <= ST_DETECT_STARTBIT0 ;
		    else
		      next_state <= ST_WAIT_STARTBIT ;
		 end
	       else
		 next_state <= ST_WAIT_STARTBIT ;
	  
             cst_detect_startbit0 :
	       if ( baudx16clk == 1'b1 )
		 begin
		    if ( rx_lpfd == 1'b0 )
		      next_state <= ST_DETECT_STARTBIT1;
		    else
		      next_state <= ST_WAIT_STARTBIT; // Error , Bad Start bit
		 end
	       else
		 next_state <= ST_DETECT_STARTBIT0;
		 
             cst_detect_startbit1 :
	       if ( baudx16clk == 1'b1 )
		 begin
		    if ( rx_lpfd == 1'b0 )
		      next_state <= ST_DETECT_STARTBIT2;
		    else
		      next_state <= ST_WAIT_STARTBIT; // Error , Bad Start bit
		 end
	       else
		 next_state <= ST_DETECT_STARTBIT1;
	  
             cst_detect_startbit2 :
	       if ( baudx16clk == 1'b1 )
		 begin
		    if ( rx_lpfd == 1'b0 )
		      next_state <= ST_GOOD_STARTBIT;
		    else
		      next_state <= ST_WAIT_STARTBIT; // Error, bad start bit
		 end
	       else
		 next_state <= ST_DETECT_STARTBIT2;

	     cst_good_startbit:
	       if( rxclk == 1'b1 )
		 next_state <= ST_DATA0 ;
	       else
		 next_state <= ST_GOOD_STARTBIT;
	  
             cst_data0 :
	       if ( rxclk  == 1'b1 )
		 next_state <= ST_DATA1 ;
	       else
		 next_state <= ST_DATA0 ;
             cst_data1 :
	       if ( rxclk  == 1'b1 )
		 next_state <= ST_DATA2 ;
	       else
		 next_state <= ST_DATA1 ;
             cst_data2 :
	       if ( rxclk  == 1'b1 )
		 next_state <= ST_DATA3 ;
	       else
		 next_state <= ST_DATA2 ;
             cst_data3 : 
	       if ( rxclk  == 1'b1 )
		 next_state <= ST_DATA4 ;
	       else
		 next_state <= ST_DATA3 ;
             cst_data4 : 
	       if ( rxclk  == 1'b1 )
		 next_state <= ST_DATA5 ;
	       else
		 next_state <= ST_DATA4 ;
             cst_data5 : 
	       if ( rxclk  == 1'b1 )
		 if ( databit == 1'b0 )
		   next_state <= ST_DATA7 ; // 7 bit data
	         else
		   next_state <= ST_DATA6 ;	  
	       else
		 next_state <= ST_DATA5 ;
             cst_data6 : 
	       if ( rxclk == 1'b1 )
		 next_state <= ST_DATA7 ;
	       else
		 next_state <= ST_DATA6 ;
             cst_data7 :
	       if ( rxclk == 1'b1 )
		 if ( parity == 2'b00 ) // no parity bit
		   if ( stopbit == 1'b0 ) // 1 stop bit
		     next_state <= ST_STOP1 ;
		   else
		     next_state <= ST_STOP0 ;
		 else
		   next_state <= ST_PARITY ; // Parity bit
	       else
		 next_state <= ST_DATA7 ;
	  
             cst_parity :
	       if ( rxclk == 1'b1 )
		 if ( stopbit == 1'b0 )
		   next_state <= ST_STOP1 ;
		 else
		   next_state <= ST_STOP0 ;
	       else
		 next_state <= ST_PARITY;
	  
             cst_stop0 :
	       if ( rxclk == 1'b1 )
		 next_state <= ST_STOP1 ;
	       else
		 next_state <= ST_STOP0 ;
             cst_stop1 :
	       if ( rxclk == 1'b1 )
		 next_state <= ST_FIFOWRB ;
	       else
		 next_state <= ST_STOP1 ;
             cst_fifowrb :
	       if ( uartenb == 1'b1 )
		 next_state <= ST_IDLE ;
	       else
		 next_state <= ST_WAIT_STARTBIT;
	  
	endcase // end of case
     end // end of always


   



   
endmodule
