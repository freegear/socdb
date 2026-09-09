module u_int(
		disint,
		end_instr,
		ti_ri,
		clk, 
		rst_p, 
		ex_int_a, 
		ex_int_b, 
		it_a, 
		it_b, 
		tf_a, 
		tf_b, 
		ie_j, 
		ie, 
		ip, 
		ie_a, 
		ie_b, 
		//en_intd_instr, 
		smpl_ex_a, 
		smpl_ex_b,
		int_vec,
		reti,
		isrc_cur,
		en_int 
		); 
input 		clk,
	   	rst_p, 
		ti_ri,
		ex_int_a, 
		ex_int_b, 
		it_a, 
		it_b, 
		tf_a, 
		tf_b, 
		ie_j;
input[4:0] 	ie, ip;
input	 	ie_a, 
		ie_b, 
		disint,
		reti ;
input	end_instr; 
//////////////////////////////////////////////////
output	 	smpl_ex_a,
		smpl_ex_b;
output[2:0]	int_vec;
output[2:0]	isrc_cur;
output	 	en_int; 
	
wire            s_lint_a;
wire            s_lint_b;
wire            s_oie_a;
wire            s_oie_b;
wire[4:0]       s_and_o;
	

ex_int_smpl smpl0  
(
.clk(clk),
.ex_int(ex_int_a), 
.it(it_a), 
.rst_p(rst_p), 
.lint(s_lint_a), 
.oie(s_oie_a));

ex_int_smpl smpl1  
(
.clk(clk), 
.ex_int(ex_int_b), 
.it(it_b), 
.rst_p(rst_p), 
.lint(s_lint_b), 
.oie(s_oie_b));

mux2t1_1 ux0   
(
.a(1'b0), 
.b(s_oie_a), 
.sel(it_a), 
.c(smpl_ex_a));

mux2t1_1 ux1   
(
.a(1'b0), 
.b(s_oie_b), 
.sel(it_b), 
.c(smpl_ex_b));

wire[4:0] int_is =(ie_j)?
{ti_ri,tf_b,ie_b,tf_a,ie_a}:0;

reg[4:0] latch_int;
reg[4:0]  int;
//wire[4:0]  int;
reg		end_instr1;


always @(posedge clk or posedge rst_p)
if(rst_p) end_instr1 <= 0;
else end_instr1 <= end_instr;

always @(int or rst_p or end_instr or reti or int_is)
if(rst_p) latch_int <= 0;
else if(reti) latch_int <= 0;
else if(|int_is) latch_int <= int_is;

always @(end_instr or rst_p or latch_int)
if(rst_p) int <= 0;
else if(end_instr) int <= latch_int; 


//assign int = int_is;


 
priority prio   
(
.disint(disint),
.ie(ie),
.reti(reti),
.clk(clk), 
.rst_p(rst_p),
.int(int),	
.ip(ip),	
.ie7(ie_j),
.int_vec(int_vec),
.isrc_cur(isrc_cur),
.en_int(en_int)	
);			
endmodule 
        
