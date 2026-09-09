module ex_int_smpl(
		clk, 
		ex_int, 
		it, 
		rst_p, 
		lint, 
		oie);
/////////////////////////////////////////////////////
input		clk;
input		ex_int; // input external int0, int1
input       it;
input		rst_p;
/////////////////////////////////////////////
output		lint;
wire		lint;
wire 		nex_int;
output 		oie;   // output IE0, IE1
/////////////////////////////////////////////
reg tmp, tmp1;
assign nex_int = ~ex_int;

always @(posedge clk or posedge rst_p)
if (rst_p) tmp <= 0;
else if(it) tmp <= nex_int;

always @(posedge clk or posedge rst_p)
if (rst_p) tmp1 <= 0;
else if(it) tmp1 <= tmp;

assign oie = tmp & ~tmp1;

assign  lint = (!it)? ~ex_int : ex_int; 
		// it:0(level) it:1(edge)

endmodule
