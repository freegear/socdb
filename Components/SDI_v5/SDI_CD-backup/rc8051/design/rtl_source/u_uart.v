module u_uart(
//////input////////////////////
        clk,
        rst_p,
    //rxd//
        rxdi,
        rxdo,
    //sbuf//
        in_sfr,
        addr_sfr,
        wr,
    //baud rate source//
        shift12,
        tf1,
//////output///////////////////
    //txd//
        txdo,
    //interrupt//          
        uart_int,
    //subuf output//
        scon,
        pcon,
        sbuf 
);

input		clk;
input		rst_p;
input		rxdi;
//////sbuf////////////////////
input[7:0]	in_sfr;
input[7:0]	addr_sfr;
input		wr;
//////baud rate source/////////
input		shift12;
input		tf1;
//////output///////////////////
output		txdo;
output		rxdo;
output       	uart_int;	
output[7:0]   	scon;
output[7:0]   	pcon;
output[7:0]   	sbuf;
//////reg/////////////////////
reg[7:0]	scon;
reg[7:0]	pcon;
// serial port buffer(transmit) 
reg		txd;
reg[3:0]	trans_cnt;
reg		trans;
reg		trans1;
reg		trans2;
reg		trans3;
reg		rec_sync;
reg[10:0]	sbuf_txd;
reg[7:0]	sbuf_txdat;
reg		tx_done;
// enable trans 
	//transmit
reg	        sc_clk_trans;
reg		smod_clk_trans;
reg	        shift_trans;
	//receive
reg	        sc_clk_rec;
reg		smod_clk_rec;
reg	        shift_rec;
// serial port buffer(receive) 
reg[3:0]	rec_cnt;
reg		receive; 
reg[7:0]	sbuf_rxd;
reg[11:0]	sbuf_rxd_tmp;
reg		rx_done; 
reg		rxdi_r;  
reg[1:0]	rx_same; 
//reg[7:0]	sbuf;
reg		div12; //mode0
reg		shift12_1; //mode0
reg[3:0]	cnt0_4; //mode0
reg[7:0]	cnt1_8;
//reg[7:0]   	sbuf;
//////wire////////////////////
//scon
wire		ren;
wire		tb8;
wire		rb8;
wire		ri;
//pcon
wire		smod;
// serial port buffer(transmit) 
wire		wr_sbuf;
reg	        shift_clk;	
/*----------------------------------------------
--                                            --
-- SCON                                       --
--                                            --
----------------------------------------------*/
assign ren = scon[4];
assign tb8 = scon[3];
assign rb8 = scon[2];
assign ri  = scon[0];

always @(posedge clk or posedge rst_p)
if(rst_p) scon <=  0;
else if (wr == 1'b1 && addr_sfr == 8'h98)
	scon <=  in_sfr;
else if(tx_done)
	scon[1] <=  1'b1; //ti
else if(!rx_done) begin
	if (scon[7:6] == 2'b00) scon[0] <=  1;
	else if (sbuf_rxd_tmp[11] | 
		!(scon[5])) begin
		scon[0] <=  1;
		scon[2] <=  sbuf_rxd_tmp[11];
	end else scon[2] <=  sbuf_rxd_tmp[11];
end
/*----------------------------------------------
--                                            --
-- PCON                                       --
--                                            --
----------------------------------------------*/
assign smod = pcon[7];

always @(posedge clk or posedge rst_p)
if(rst_p) pcon <=  0;
else if (wr == 1'b1 && addr_sfr == 8'h87)
	pcon <=  in_sfr;

/*----------------------------------------------
--                                            --
-- SBUF                                       --
--                                            --
----------------------------------------------*/
assign sbuf = sbuf_rxd;

//
// UART 
//

//
// div12
//
always @(posedge clk or posedge rst_p)
if(rst_p) begin
	div12 <=  0;
	cnt0_4 <=  0;
end  else begin
	cnt0_4 <= cnt0_4 + 1'b1;
	if(	cnt0_4 == 4'd0 ||
		cnt0_4 == 4'd6)
		div12 <= ~div12;
	else if (cnt0_4 == 4'd11)
		cnt0_4 <= 0;	
end


always @(posedge clk or posedge rst_p)
if(rst_p) begin
	cnt1_8 <= 0;
	rec_sync <= 0;
end else  begin
	cnt1_8 <= cnt1_8 + 1'b1;
	if(cnt1_8 == 8'd8) rec_sync <= 1;
	else if(!receive) begin
		rec_sync <= 0;
		cnt1_8<= 0;
	end
end

assign txdo = (scon[7:6] == 2'b00 
		&& shift_clk)?  
	div12:txd;

always @(posedge clk ) trans1 <= trans;
always @(posedge clk ) trans2 <= trans1;
always @(posedge clk ) trans3 <= trans2;

always @(
	receive or 
	trans3 or 
	sbuf_rxd_tmp or 
	sbuf_txd
	)
if (receive) begin
	if(
	sbuf_rxd_tmp != 11'h0ff && 
   	!(sbuf_rxd_tmp[11] == 1'b1 && 
   	sbuf_rxd_tmp[0] == 1'b0)
	) 
		shift_clk = 1;
       	 else  shift_clk = 0;
end else if(trans3) begin
	if(
   	sbuf_txd[10:8] != 3'b001 
	)
		shift_clk = 1; 
	else shift_clk = 0;
end else shift_clk = 0;


assign rxdo = (scon[7:6] == 2'b00)? 
	txd:1'b1;

//
// sync CE for trans data in mode0
//
always @(posedge clk) shift12_1 <= shift12;

assign uart_int = scon[0] | scon[1];	

//
// start trsmitting
//
assign wr_sbuf = (addr_sfr == 8'h99) & (wr);


always @(posedge clk or posedge rst_p)
if (rst_p) begin
	txd <=  0;
	trans_cnt <=  0;
	trans <=  0;
	sbuf_txd  <=  0;
	tx_done <=  0;
//
// serial port buffer(transmit) 
//
end else if (wr_sbuf) begin
	case(scon[7:6])
	2'b00:begin //mode 0
		sbuf_txd <=  {3'b001,in_sfr};
		sbuf_txdat <= in_sfr;
	end
	2'b01:begin //mode 1
		sbuf_txd <=  {2'b01,in_sfr,1'b0};
	end
	default:begin //mode 2,3 
	       sbuf_txd <=  {1'b1,tb8,in_sfr,1'b0};
	end
	endcase
	trans <=  1;
	trans_cnt <=  0;
	tx_done <=  0;
//
// transmitting dat
//
end else if (	
		trans &
		(scon[7:6] == 2'b00) & //mode 0
		shift12_1
		) begin
	if (~|sbuf_txd[10:1]) begin
		trans <= 0;
		tx_done <= 1; 
	end else begin
		{sbuf_txd,txd} <=  {1'b0,sbuf_txd};
		tx_done <=  0;
	end
end else if (	trans &
		(scon[7:6] != 2'b00) &//mode1,2,3
		shift_trans) begin
	trans_cnt <=  trans_cnt + 1'b1;
	if (~|trans_cnt) begin
		if(~|sbuf_txd[10:0])begin
			trans <=  0;
			tx_done <=  1;
			txd <=  1;
		end else begin
			{sbuf_txd,txd} 
			<=  {1'b0,sbuf_txd};
			tx_done <=  0;
		end
	end
end else if (!trans) begin
	txd <=  1;
	tx_done <=  0;
end 
			

always @(tf1 or scon[7:6])
if(scon[7:6]==2'b10) sc_clk_trans = 1;
else  sc_clk_trans = tf1;

always @(posedge clk or posedge rst_p)
if (rst_p) begin
	smod_clk_trans <=  0;
	shift_trans <=  0;
end else if(sc_clk_trans) begin
	if (smod) shift_trans <=  1;
	else begin
		shift_trans <=  smod_clk_trans;
		smod_clk_trans <=  !smod_clk_trans;
	end
end else shift_trans <=  0;


//
// serial port buffer(receive) 
//
always @(posedge clk or posedge rst_p)
if(rst_p) begin	
	rec_cnt <=  0;
	receive <=  0;
	sbuf_rxd <=  0;
	sbuf_rxd_tmp <=  0;
	rx_done <=  1;
	rxdi_r <=  1;
	rx_same <=  0;
	end else if(!rx_done) begin
		receive <=  0;
		rx_done <=  1;
		sbuf_rxd <=  sbuf_rxd_tmp[10:3];
	end else if (	
		rec_sync &
		(scon[7:6] == 2'b00 &//mode0
		shift12
		)) 
		{sbuf_rxd_tmp,rx_done} <=  
			{rxdi,sbuf_rxd_tmp};
	else if (
		receive &
		(scon[7:6] != 2'b00 &//mode1,2,3
			shift_rec)) begin
		rec_cnt <=  rec_cnt + 1'b1;
		case (rec_cnt)
		4'h7: rx_same[0] <=  rxdi;
		4'h8: rx_same[1] <=  rxdi;
		4'h9: {sbuf_rxd_tmp,rx_done} <=  
{(rxdi==rx_same[0]? rxdi:rx_same[1]),sbuf_rxd_tmp};
		endcase
//
// start receiving
//
	end else if(scon[7:6]==2'b00) begin//mode0
		rx_done <=  1;
		if (ren && !ri && !receive) begin
			receive <=  1;
			sbuf_rxd_tmp <=  10'h0ff;
		end
	end else if (ren & shift_rec) begin
		rxdi_r <=  rxdi;
		rx_done <=  1;
		rec_cnt <=  0;
		receive <=  (rxdi_r & !rxdi);
		sbuf_rxd_tmp <=  10'h1ff;
	end else if (!ren) rxdi_r <=  rxdi;
	else rx_done <=  1;

always @(tf1 or scon[7:6])
if(scon[7:6]==2'b10) sc_clk_rec = 1;
else  sc_clk_rec = tf1;

always @(posedge clk or posedge rst_p)
if (rst_p) begin
	smod_clk_rec <=  0;
	shift_rec <=  0;
end else if(sc_clk_rec) begin
	if (smod) shift_rec <=  1;
	else begin
		shift_rec <= smod_clk_rec;
		smod_clk_rec <= !smod_clk_rec;
	end
end else shift_rec <=  0;

endmodule
