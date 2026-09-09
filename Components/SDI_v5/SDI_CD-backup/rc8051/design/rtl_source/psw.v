//`include "./mux2t1_1.v"
module psw(     
		rst_p, 
		in_psw, 
		clk, 
		addr_psw,
		wr, 
		in_cy_bit,
		set_c, 
		rst_c, 
		cpl_c, 
		ld_c,
	        set_ac, 
		rst_ac, 
		set_v, 
		rst_v, 
		parity, 
		out_psw
		);

/////////////////////in////////////////////////////
input 		rst_p, 
		clk, 
		set_c, 
		rst_c, 
		cpl_c, 
		ld_c, 
		set_ac, 
		rst_ac, 
		set_v, 
		rst_v, 
		parity, 
		wr,
		in_cy_bit;
input[6:0]	in_psw; 
input[7:0]      addr_psw;
/////////////////////out///////////////////////////
output[7:0]	out_psw;
reg[7:0]	out_psw;
wire 		y;

mux2t1_1 u0(
	.a(in_psw[6]), 
	.b(~out_psw[7]), 
	.sel(cpl_c), 
	.c(y)
	);

always @(rst_p or parity) begin: psw0 
	if (rst_p) out_psw[0] <= 0;
	else if (parity) out_psw[0] <= 1;
	else if (!parity) out_psw[0] <= 0; 
end
always @(posedge clk or posedge rst_p) // psw1
if (rst_p) out_psw[1] <= 0;
else if (wr & (addr_psw == 8'hd0))
	out_psw[1] <= in_psw[0];

always @(posedge clk or posedge rst_p) // psw2
if (rst_p) out_psw[2] <= 0;
else if (rst_v) out_psw[2] <= 0;
else if (set_v) out_psw[2] <= 1;
else if (wr & (addr_psw == 8'hd0)) 
	out_psw[2] <= in_psw[1];

always @(posedge clk or posedge rst_p) // psw3
if (rst_p) out_psw[3] <= 0;
else if (wr &  (addr_psw == 8'hd0)) 
	out_psw[3] <= in_psw[2];

always @(posedge clk or posedge rst_p) // psw4
if (rst_p) out_psw[4] <= 0;
else if (wr & (addr_psw == 8'hd0))    
	out_psw[4] <= in_psw[3];

always @(posedge clk or posedge rst_p) // psw5
if (rst_p) out_psw[5] <= 0;
else if (wr & (addr_psw == 8'hd0)) 
	out_psw[5] <= in_psw[4];

always @(posedge clk or posedge rst_p) // psw6
if (rst_p) out_psw[6] <= 0;
else if (rst_ac) out_psw[6] <= 0;
else if (set_ac) out_psw[6] <= 1;
else if (wr & (addr_psw == 8'hd0)) 
	out_psw[6] <= in_psw[5];

always @(posedge clk or posedge rst_p) // psw7
if (rst_p) out_psw[7] <= 0;
else if (rst_c) out_psw[7] <= 0;
else if (set_c) out_psw[7] <= 1;
else if (cpl_c) out_psw[7] <= y;
else if (ld_c) out_psw[7] <= in_cy_bit;
else if (wr & (addr_psw == 8'hd0))      
	out_psw[7] <= y;
endmodule
