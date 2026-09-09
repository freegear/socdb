module tcon (
	clk, 
	rst_p, 
	in_tcon,
	addr_tcon, 
	wr,
	set_tf0,
	rst_tf0,
	set_tf1,
	rst_tf1,
	set_ie0,
	rst_ie0,
	set_ie1,
	rst_ie1,
	out_tcon
	);

input           clk;
input           rst_p;
input [7:0]	in_tcon;
input [7:0]	addr_tcon;
input	        wr;
input	        set_tf0;
input	        rst_tf0;
input	        set_tf1;
input	        rst_tf1;
input	        set_ie0;
input	        rst_ie0;
input	        set_ie1;
input	        rst_ie1;

output[7:0]     out_tcon;

reg   [3:0]     tcon;
reg		tcon_tf0;
reg		tcon_tf1;
reg		tcon_ie0;
reg		tcon_ie1;

always @(posedge clk or posedge rst_p) 
if (rst_p) tcon <= 0;
else if (wr == 1'b1 && addr_tcon == 8'h88)       
	tcon <= {in_tcon[6],in_tcon[4],
			in_tcon[2],in_tcon[0]};

//////dis concurr "bitaccess" with "hardware set"////////////
reg set_tf0_d1;
reg set_tf0_d2;
always @(posedge clk or posedge rst_p)
if (rst_p) begin set_tf0_d1 <= 0;
        set_tf0_d2 <= 0;
end else begin set_tf0_d1 <= set_tf0;
        set_tf0_d2 <= set_tf0_d1;
end

always @(posedge clk or posedge rst_p) 
if (rst_p) tcon_tf0 <= 0;

else if (!set_tf0 & !set_tf0_d1 & !set_tf0_d2 & wr & addr_tcon == 8'h88) 
	tcon_tf0 <= in_tcon[5];
else if (set_tf0) tcon_tf0 <= 1'b1;
else if (rst_tf0) tcon_tf0 <= 0;
//////dis concurr "bitaccess" with "hardware set"////////////
reg set_tf1_d1;
reg set_tf1_d2;
always @(posedge clk or posedge rst_p)
if (rst_p) begin set_tf1_d1 <= 0;
        set_tf1_d2 <= 0;
end else begin set_tf1_d1 <= set_tf1;
        set_tf1_d2 <= set_tf1_d1;
end

always @(posedge clk or posedge rst_p) 
if (rst_p) tcon_tf1 <= 0;
else if (!set_tf1 & !set_tf1_d1 & !set_tf1_d2 & wr & addr_tcon == 8'h88) 
	tcon_tf1 <= in_tcon[7];
else if (set_tf1) tcon_tf1 <= 1'b1;
else if (rst_tf1) tcon_tf1 <= 0;
//////dis concurr "bitaccess" with "hardware set"////////////
reg set_ie0_d1;
reg set_ie0_d2;
always @(posedge clk or posedge rst_p)
if (rst_p) begin set_ie0_d1 <= 0;
        set_ie0_d2 <= 0;
end else begin set_ie0_d1 <= set_ie0;
        set_ie0_d2 <= set_ie0_d1;
end

always @(posedge clk or posedge rst_p) 
if (rst_p) tcon_ie0 <= 0;
else if (!set_ie0 & !set_ie0_d1 & !set_ie0_d2 & wr & addr_tcon == 8'h88)
	tcon_ie0 <= in_tcon[1];
else if (set_ie0) tcon_ie0 <= 1'b1;
else if (rst_ie0) tcon_ie0 <= 0;
//////dis concurr "bitaccess" with "hardware set"////////////
reg set_ie1_d1;
reg set_ie1_d2;
always @(posedge clk or posedge rst_p)
if (rst_p) begin set_ie1_d1 <= 0;
        set_ie1_d2 <= 0;
end else begin set_ie1_d1 <= set_ie1;
        set_ie1_d2 <= set_ie1_d1;
end

always @(posedge clk or posedge rst_p) 
if (rst_p) tcon_ie1 <= 0;
else if (!set_ie1 & !set_ie1_d1 & !set_ie1_d2 & wr & addr_tcon == 8'h88)
	tcon_ie1 <= in_tcon[3];
else if (set_ie1) tcon_ie1 <= 1'b1;
else if (rst_ie1) tcon_ie1 <= 0;

assign out_tcon = 
{tcon_tf1,tcon[3],tcon_tf0,tcon[2],
 tcon_ie1,tcon[1],tcon_ie0,tcon[0]}; 
endmodule               
