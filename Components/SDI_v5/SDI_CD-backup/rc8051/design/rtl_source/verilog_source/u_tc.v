module u_tc(
       //in    
        clk,
        rst_p,
        wr,
        in_tc,
        addr_tc,
        t0_pin,
        t1_pin,
        int0_pin,
        int1_pin,
        sel_tc0,
        sel_tc1,
        gate0,
        gate1,
        tr0,
        tr1,
        tm0,
        tm1,
        //out   
        tf0,
        tf1,
        tl0,
        tl1,
        th0,
        th1,
	shift12
	);
//input		 
input		clk;
input		rst_p;
input   	wr;
input[7:0]	in_tc;
input[7:0]	addr_tc;
input   	t0_pin;
input 	   	t1_pin; 
input       	int0_pin;
input       	int1_pin;
input		sel_tc0, sel_tc1;
input		gate0, gate1;
input		tr0, tr1;
input[1:0]	tm0, tm1;
//output
output		tf0, tf1;
output[7:0]	tl0, tl1, th0, th1;
output		shift12;
//////wire////////////////////////////////////////
wire 	       en_tc0;
wire 	       en_tc1;
//////reg/////////////////////////////////////////
reg[7:0]	tl0, tl1, th0, th1;
reg[3:0]	div12;
reg		shift12;
reg		t0_pin_r;
reg		t1_pin_r;
reg		tf1_0, tf0, tf1_1;
/*----------------------------------------------
--                                            --
-- divide clk into clk/12                     --
--                                            --
----------------------------------------------*/
always @(posedge clk or posedge rst_p)
if(rst_p) begin
	div12 <= 0;
	shift12 <= 0;
end else if (div12 == 4'b1011)begin
	div12 <= 0;
	shift12 <= 1;
end else begin
	div12 <= div12 + 1'b1;
	shift12 <= 0;
	end
/*----------------------------------------------
--                                            --
-- register timer pin                         --
--                                            --
----------------------------------------------*/
always @(posedge clk or posedge rst_p)
if(rst_p) begin
	t0_pin_r <= 0;
	t1_pin_r <= 0;
end else begin
	t0_pin_r <= t0_pin;
	t1_pin_r <= t1_pin;
end
/*----------------------------------------------
--                                            --
-- enable timer counter(en_tc)                --
--                                            --
----------------------------------------------*/
assign en_tc0 = (
		tr0 & 
		(!gate0 | !int0_pin) &
		((!sel_tc0 & shift12) | 
		(sel_tc0 & !t0_pin & t0_pin_r))
		);
assign en_tc1 = (
		tr1 & 
		(!gate1 | !int1_pin) &
		((!sel_tc1 & shift12) | 
		(sel_tc1 & !t1_pin & t1_pin_r))
		);
/*----------------------------------------------
--                                            --
-- timer counter0                             --
--                                            --
----------------------------------------------*/
always @(posedge clk or posedge rst_p)
if(rst_p) begin
	tl0 <= 0;
	th0 <= 0;
	tf0 <= 0;
	tf1_0 <= 0;
end else if(	addr_tc == 8'h8a &&
		wr == 1'b1)begin
	tl0 <= in_tc;
	tf0 <= 0;
	tf1_0 <= 0;
end else if(	addr_tc == 8'h8c &&
		wr == 1'b1)begin
	th0 <= in_tc;
	tf0 <= 0;
	tf1_0 <= 0;
end else begin
	case (tm0[1:0])
	///////////mode0//////////////////////
	2'b00: begin
	tf1_0 <= 1'b0;
	if (en_tc0)
          {tf0,th0,tl0[4:0]}
		<={1'b0,th0,tl0[4:0]}+1'b1;
	end
	///////////mode1//////////////////////
	2'b01: begin
	tf1_0 <= 1'b0;
	if (en_tc0)
          {tf0,th0,tl0}
		<={1'b0,th0,tl0}+1'b1;
	end
	///////////mode2//////////////////////
	2'b10: begin
	tf1_0 <= 1'b0;
	if (en_tc0) begin
		if(tl0 == 8'hff)begin
			tf0 <= 1'b1;
			tl0 <= th0;
		end else begin
			tl0 <= tl0 +1'b1;
			tf0 <= 0;
		end
	end	
	end	
	///////////mode3//////////////////////
	2'b11: begin
	if(en_tc0) {tf0,tl0}<={1'b0,tl0}+1'b1;
	if(tr1 == 1'b1 && shift12 == 1'b1) 
		{tf1_0,th0}<={1'b0,tl0}+1'b1;
	end
	endcase
end
/*----------------------------------------------
--                                            --
-- timer counter1                             --
--                                            --
----------------------------------------------*/
always @(posedge clk or posedge rst_p)
if(rst_p) begin
	tl1 <= 0;
	th1 <= 0;
	tf1_1 <= 0;
end else if(	addr_tc == 8'h8b &&
		wr == 1'b1)begin
	tl1 <= in_tc;
	tf1_1 <= 0;
end else if(	addr_tc == 8'h8d &&
		wr == 1'b1)begin
	th1 <= in_tc;
	tf1_1 <= 0;
end else begin
	case (tm1[1:0])
	///////////mode0//////////////////////
	2'b00: begin
	if (en_tc1)
          {tf1_1,th1,tl1[4:0]}
		<={1'b0,th1,tl1[4:0]}+1'b1;
	end
	///////////mode1//////////////////////
	2'b01: begin
	if (en_tc1)
          {tf1_1,th1,tl1}
		<={1'b0,th1,tl1}+1'b1;
	end
	///////////mode2//////////////////////
	2'b10: begin
	if (en_tc1) begin
		if(tl1 == 8'hff)begin
			tf1_1 <= 1'b1;
			tl1 <= th1;
		end else begin
			tl1 <= tl1 +1'b1;
			tf1_1 <= 0;
		end
	end	
	end
	///////////mode3//////////////////////
	/// timer1 is previous state
	/////////////////////////////////////
	endcase	
end

assign tf1 = tf1_0 | tf1_1;





	
endmodule 
