module u_datapath( 
		// input
		ld_apc,
		ld_adptr,
		ld_xrom,
                ld_idat,
                ld_sfr,
                ld_operand2,
		end_instr,
		clk, 
		rst_p, 
		ld_instr,
		inc_pc, 
		inc_pc2, 
		inc_pc3, 
		ld_pc, 
		ld_pcl, 
		ld_pch, 
		ld_acc, 
		ld_acc_chd, 
		sel_addr0,
		sel_addr1,
		in_xrom_a, 
		in_idat_a, 
		in_xdat_a, 
		sel_combus,
		wr_sfr,
		ld_dpl,
		ld_dph,
		inc_dptr,
		sel_xad,
		sel_xaddr_high,
		sel_xaddr_low,
		inc_sp,
		dec_sp,
		ld_latch_acc,
                set_c,
                rst_c,
                cpl_c,
                ld_c,
                set_ac,
                rst_ac,
                set_v,
                rst_v,
		sel_op1,
		sel_op2,
		ld_b,
		en_div,
		sel_pc,
		bit_addr,
		rmw,
		t0_pin,
		t1_pin,
		int0_pin,
		int1_pin,
		rxdi,
		addr_bank_a,
		code,
		sel_bit_dat_out,
     		sel_in_cy_bit,
		p0_in,
		p1_in,
		p2_in,
		p3_in,
		// int
		sel_alu,
		reti,
		// output 
		addr_xrom_a, 
		addr_a,
		msb_a,
		msb_r,
		en_int,
		xaddr_high,
		cy,
		ac,
		ov,
		sel_page_addr,
		out_acc_r, 
		cy_psw,
		combus,
		out_dimod_r,
                in_xrom1_r,
		bit_dat_in_r,
		p0_out,
		p1_out,
		p2_out,
		p3_out,
		txdo,
		rxdo,
		out_xdat,
		out_idat 
		);
////////INPUT///////////////////////////////////
///////CLK RST SIGNAL///////////////////////////
input 		clk; 
input 		rst_p;
///////CONTROL SIGNAL///////////////////////////
input		ld_adptr;
input		ld_apc;
input           ld_xrom;
input           ld_operand2;
input           ld_idat;
input           ld_sfr;
input		end_instr;
input		ld_instr;
input 		inc_pc;
input 		inc_pc2;
input 		inc_pc3;
input 		ld_pc;
input 		ld_pcl;
input 		ld_pch;
input 		ld_acc;
input 		ld_acc_chd;
input 		sel_addr0;
input[2:0]	sel_addr1;
input[3:0]	sel_combus;
input		wr_sfr;
input		ld_dpl;
input		ld_dph;
input		inc_dptr;
input		sel_xad;
input		sel_xaddr_low;
input		inc_sp;
input		dec_sp;
input		ld_latch_acc;
input           set_c;
input           rst_c;
input           cpl_c;
input           ld_c;
input           set_ac;
input           rst_ac;
input           set_v;
input           rst_v;
input[2:0]	sel_op1;
input[2:0]	sel_op2;
input           ld_b;
input           en_div;
input[2:0]	sel_pc;
input		sel_page_addr;
input		bit_addr;
input		rmw;
input		t0_pin;
input		t1_pin;
input		int0_pin;
input		int1_pin;
                //int
input[2:0]	 addr_bank_a;
input[4:0]	 sel_alu;
input[1:0]	 sel_bit_dat_out;
input[2:0]	 sel_in_cy_bit;
input		reti;
input		sel_xaddr_high;
input[7:0]	p0_in;	
input[7:0]      p1_in;
input[7:0]      p2_in;
input[7:0]      p3_in;
//////DATA/////////////////////////////////////
input[7:0] 	in_xrom_a; // INTRUCTION | DATA 
input[7:0]	in_idat_a; // IDATA 
input[7:0]	in_xdat_a; // XDATA 
input		rxdi;
///////OUTPUT///////////////////////////////////
output[7:0]	code; // instruntion 
output[15:0] 	addr_xrom_a;
output[7:0] 	addr_a; 
output	 	msb_a; 
output  	msb_r; 
output		en_int;
output[7:0]	xaddr_high;
output		cy, ac, ov;
output[7:0] 	out_acc_r; 
output		cy_psw;
output[7:0]	combus;
output[7:0]	out_dimod_r;
output[7:0]	in_xrom1_r;
output		bit_dat_in_r;
output[7:0]	p0_out;
output[7:0]	p1_out;
output[7:0]	p2_out;
output[7:0]	p3_out;
output		txdo;
output		rxdo;
output[7:0]	out_idat; // IDATA 
output[7:0]	out_xdat; // XDATA 
///////WIRE/////////////////////////////////////
wire[7:0]	out_psw;
wire[7:0] 	out_sfr_a; 
wire[7:0] 	out_acc_r; 
wire[15:0] 	out_dptr_r; 
wire[15:0] 	out_pc_r; 
wire[7:0]	xaddr_low;
wire[7:0]	out_sp_r;
wire[7:0]	acc_chd;
wire[7:0]	alu_a;
wire[7:0]	in_b;
wire[7:0]	out_b;
wire[15:0]	page_addr_a;
wire[7:0]	xrom;
wire[15:0]	rel_addr_a;
wire[15:0]	in_rel_adder;
wire[7:0] 	addr2_a; 
wire[2:0] 	bit_select; 
wire		bit_dat_in;  //mem => cpu 
wire[2:0] 	int_vec; 
///////REG//////////////////////////////////////
reg[7:0] 	out_sfr_r; 
reg		bit_dat_out; //cpu => mem  
reg[7:0]   	combus;
reg[7:0]   	combus1;
reg[7:0]   	addr2_r;
reg[7:0] 	addr1_a; 
reg[7:0] 	in_idat_r; 
reg[7:0] 	in_idat1_r; 
reg[7:0] 	in_xrom_r; 
reg[7:0] 	in_xrom1_r; 
reg[7:0] 	latch_acc; 
reg[7:0] 	op1; 
reg[7:0] 	op2; 
reg[7:0]	alu_r;
reg[15:0]	in_pc;
reg[7:0] 	addr_a; 
reg      	in_cy_bit; 
reg		bit_dat_in_r;  //mem => cpu 
reg[15:0]	int_vctr; 
reg[7:0]	code; // instruntion 
reg en;
wire msb_a;
wire msb_r;
////////////////////////////////////////////////
assign msb_a = addr2_a[7];

assign msb_r = addr2_r[7];

assign	cy_psw = out_psw[7];

assign	xaddr_high = (sel_xaddr_high)?
		out_dptr_r[15:8]:8'd0;

assign	xaddr_low = (sel_xaddr_low)?
		out_dptr_r[7:0]:in_idat_r;

assign	out_xdat = (sel_xad)?
		xaddr_low:out_acc_r;

assign	out_idat = combus; 

always @(posedge clk or  posedge rst_p)
if (rst_p) code <= 0;
else if (ld_instr) code <= in_xrom_a;

always @(posedge clk or  posedge rst_p)
if (rst_p) in_idat1_r <= 0; 
else in_idat1_r <= in_idat_r; 

///////////ADDRESS organization/////////////////
//addr_a(sel_addr1): address of addrN_a (N>1) 
//addr1_a(sel_addr1): xrom(direct)  
////////////////////////////////////////////////
assign addr2_a = (sel_addr0)? 
{2'b00, out_psw[4:3], addr_bank_a} : addr1_a;  
////////////////////////////////////////////////
always @(addr2_a or bit_addr)
casex ({bit_addr,addr2_a[7]})
2'b0?: addr_a = addr2_a;
2'b10: addr_a = {4'b0010, addr2_a[6:3]};
2'b11: addr_a = {1'b1, addr2_a[6:3], 3'b000};
default:  addr_a = 0;
endcase

assign bit_select = addr2_a[2:0];

assign bit_dat_in = (addr2_a[7] == 1'b1)?
     out_sfr_a[bit_select]:in_idat_a[bit_select];

always @(posedge clk or posedge rst_p)
if(rst_p) bit_dat_in_r <= 0;
else bit_dat_in_r <= bit_dat_in;
/////////////////////////////////////////////////

always @(sel_in_cy_bit or bit_dat_in or cy_psw)      
if 	(sel_in_cy_bit == 3'd0)
	in_cy_bit = cy_psw & bit_dat_in; 
else if (sel_in_cy_bit == 3'd1)
	in_cy_bit = cy_psw & ~bit_dat_in; 
else if (sel_in_cy_bit == 3'd2)
	in_cy_bit = cy_psw | bit_dat_in; 
else if (sel_in_cy_bit == 3'd3)
	in_cy_bit = cy_psw | ~bit_dat_in; 
else if (sel_in_cy_bit == 3'd4)
	in_cy_bit = bit_dat_in; 
else 	in_cy_bit = 0;
////////////////////////////////////////////////
always @(sel_bit_dat_out or bit_dat_in or cy_psw)
if      (sel_bit_dat_out == 2'd0)
	bit_dat_out = 0;
else if (sel_bit_dat_out == 2'd1)
	bit_dat_out = 1;
else if (sel_bit_dat_out == 2'd2)
	bit_dat_out = ~ bit_dat_in;
else if (sel_bit_dat_out == 2'd3)
	bit_dat_out = cy_psw;
else    bit_dat_out = 0; // prevent latch

always @(
	msb_a or
	combus1 or
	bit_addr or
	bit_select or
	in_idat_r   or
	bit_dat_out or
	out_sfr_a
	)
casex ({msb_a,bit_addr,bit_select})
5'b?0???: combus = combus1;
5'b01000: combus 
= {in_idat_r[7:1],bit_dat_out};
5'b01001: combus 
= {in_idat_r[7:2],bit_dat_out, in_idat_r[0]};
5'b01010: combus 
= {in_idat_r[7:3],bit_dat_out, in_idat_r[1:0]};
5'b01011: combus 
= {in_idat_r[7:4],bit_dat_out, in_idat_r[2:0]};
5'b01100: combus 
= {in_idat_r[7:5],bit_dat_out, in_idat_r[3:0]};
5'b01101: combus 
= {in_idat_r[7:6],bit_dat_out, in_idat_r[4:0]};
5'b01110: combus 
= {in_idat_r[7],bit_dat_out, in_idat_r[5:0]};
5'b01111: combus 
= {bit_dat_out,in_idat_r[6:0]};
5'b11000: combus 
= {out_sfr_a[7:1],bit_dat_out};
5'b11001: combus 
= {out_sfr_a[7:2],bit_dat_out, out_sfr_a[0]};
5'b11010: combus 
= {out_sfr_a[7:3],bit_dat_out, out_sfr_a[1:0]};
5'b11011: combus 
= {out_sfr_a[7:4],bit_dat_out, out_sfr_a[2:0]};
5'b11100: combus 
= {out_sfr_a[7:5],bit_dat_out, out_sfr_a[3:0]};
5'b11101: combus 
= {out_sfr_a[7:6],bit_dat_out, out_sfr_a[4:0]};
5'b11110: combus 
= {out_sfr_a[7],bit_dat_out, out_sfr_a[5:0]};
5'b11111: combus 
= {bit_dat_out,out_sfr_a[6:0]};
default:  combus = 0;
endcase
////////////////////////////////////////////////
wire [15:0] a_plus_dptr;
	
assign	a_plus_dptr 
	= {8'b00000000,out_acc_r} + out_dptr_r;
////////////////////////////////////////////////
always @(
	sel_addr1 or 
        in_idat_r or	
	in_xrom_r or
	out_sp_r or 
	addr2_r or
	in_xrom1_r or 
	in_idat1_r or 
      	a_plus_dptr 
	)
if 	(sel_addr1 == 3'd0) 
	addr1_a = in_xrom_r;
else if (sel_addr1 == 3'd1)                
	addr1_a = in_idat_r;
else if (sel_addr1 == 3'd2)
 	addr1_a = out_sp_r;
else if (sel_addr1 == 3'd3)
 	addr1_a = addr2_r;
else if (sel_addr1 == 3'd4)
 	addr1_a = in_xrom1_r;
else if (sel_addr1 == 3'd5)
	addr1_a = in_idat1_r;
else if (sel_addr1 == 3'd6)
	addr1_a = a_plus_dptr;
else    addr1_a = 0;  

sign U4_sign(
	.a(in_xrom_r),
	.b(in_rel_adder)
	); 

assign rel_addr_a = in_rel_adder + out_pc_r;
/////////////PC///////////////////////////////
always @(
	sel_pc or 
	page_addr_a or
	in_xrom_r or
	in_xrom_a or
	in_idat_a or
	in_idat_r or
	combus1 or
	rel_addr_a or
	out_pc_r or
	int_vctr or
        a_plus_dptr //new...
	)
if(sel_pc == 3'd0) 
	in_pc <= page_addr_a;
else if(sel_pc == 3'd1)
 	in_pc <= {in_xrom_r,in_xrom_a}; 
else if(sel_pc == 3'd2)
 	in_pc <= {8'b00000000,combus1}; // ld_pcl
else if(sel_pc == 3'd3)
 	in_pc <= {combus1,8'b00000000}; // ld_pch 
else if(sel_pc == 3'd4)
 	in_pc <= rel_addr_a; 
else if(sel_pc == 3'd5)
	in_pc <= a_plus_dptr;
else if(sel_pc == 3'd6)
	in_pc <= int_vctr;
else 	in_pc <= 0;

pc U0_pc (
	.clk(clk),
	.rst_p(rst_p),
	.ld_pc(ld_pc),
	.ld_pcl(ld_pcl),
	.ld_pch(ld_pch),
	.inc_pc(inc_pc), 
	.in_pc(in_pc),
	.out_pc_r(out_pc_r) 
	);
//////////////////////////////////////////////
reg[15:0]       latch_pc;

always @(posedge clk or  posedge rst_p)
if (rst_p) latch_pc <= 0;
else if (inc_pc2) latch_pc <= out_pc_r + 1;
else if (inc_pc3) latch_pc <= out_pc_r + 2;
else latch_pc <= out_pc_r;
// +1 :always +1 at t0 
//////////////////////////////////////////////

always @(posedge clk or  posedge rst_p)
if (rst_p) in_xrom_r <= 0;
else if (ld_xrom) in_xrom_r <= in_xrom_a;

always @(posedge clk or  posedge rst_p)
if (rst_p) in_xrom1_r <= 0;
else if(ld_operand2) in_xrom1_r <= in_xrom_a;

always @(posedge clk or  posedge rst_p)
if (rst_p) in_idat_r <= 0;
else if (ld_idat) in_idat_r <= in_idat_a; 

always @(posedge clk or  posedge rst_p)
if (rst_p) out_sfr_r <= 0;
else if (ld_sfr) out_sfr_r <= out_sfr_a; 

assign xrom = (sel_page_addr)? in_xrom_a:in_xrom_r; 

page_addr U27_page_addr (
                .pc(out_pc_r[15:11]),
                .code(code[7:5]),
                .xrom(xrom),
                .page_addr_a(page_addr_a)
                );    

wire[15:0]	 a_plus_pc;
assign a_plus_pc = {8'b00000000,out_acc_r} + out_pc_r;

assign	addr_xrom_a = 
	(ld_apc )? 	a_plus_pc: 
	(ld_adptr)? 	a_plus_dptr: 
		  	out_pc_r; 
//int vector
reg[2:0]	int_vec1;
reg[2:0]	int_vec2;
reg[2:0]	int_vec3;

always @(posedge clk) begin
int_vec1 <= int_vec;
int_vec2 <= int_vec1;
int_vec3 <= int_vec2;
end 

always @(int_vec3)
if(int_vec3 == 3'b001) // 1 int_ex0
	int_vctr = 16'b0000000000000011; //3
else if(int_vec3 == 3'b010  )// 2 int_t0 
	int_vctr  = 16'b0000000000001011; //B
else if(int_vec3 == 3'b011)// 3 int_ex1 
	int_vctr = 16'b0000000000010011; //13
else if(int_vec3 == 3'b100 )// 4 int_t1
	int_vctr  = 16'b0000000000011011; //1B
else if(int_vec3 == 3'b101)// 5 int_ser 
	int_vctr  = 16'b0000000000100011; //23
else int_vctr = 0;
//////////////SFR///////////////////////////////
u_sfr U1_sfr (
	// input
	.end_instr(end_instr),
	.clk(clk),
	.rst_p(rst_p),
	.ld_acc(ld_acc),
	.ld_acc_chd(ld_acc_chd),
	.addr_sfr(addr_a),
	.in_sfr(combus), 
	.wr_sfr(wr_sfr),
	.ld_dpl(ld_dpl),
	.ld_dph(ld_dph),
	.inc_dptr(inc_dptr),
	.inc_sp(inc_sp),
	.dec_sp(dec_sp),
	.set_c(set_c),
	.rst_c(rst_c),
	.cpl_c(cpl_c),
	.ld_c(ld_c),
	.set_ac(set_ac),
	.rst_ac(rst_ac),
	.set_v(set_v),
	.rst_v(rst_v),
	.acc_chd(acc_chd), 
	.in_b(in_b),
	.ld_b(ld_b),
	.in_cy_bit(in_cy_bit),
	.rmw(rmw),
	.t0_pin(t0_pin),
	.t1_pin(t1_pin),
	.int0_pin(int0_pin),
	.int1_pin(int1_pin),
	.rxdi(rxdi),
     	//int
	.reti(reti),
	.p0_in(p0_in), 
	.p1_in(p1_in), 
	.p2_in(p2_in), 
	.p3_in(p3_in), 
	// output
	.out_sfr_a(out_sfr_a), 
	.out_acc_r(out_acc_r), 
	.out_dptr_r(out_dptr_r),
	.out_dimod_r(out_dimod_r),
	.out_sp_r(out_sp_r),
	.out_psw(out_psw),  
	.out_b(out_b), 
	.p0_out(p0_out), 
	.p1_out(p1_out), 
	.p2_out(p2_out), 
	.p3_out(p3_out), 
	.txdo(txdo),
	.rxdo(rxdo),
        .int_vec(int_vec),
	.en_int(en_int) 
	);
//////////////ALU///////////////////////////////
always @(
	sel_op1 or
	out_acc_r or
	in_xrom_a or
	in_idat_r or
	out_sfr_a or
	out_sfr_r or
	in_idat_a   
	)
if (sel_op1 == 0) op1 = out_acc_r;
else if(sel_op1 == 3'd1)op1 = in_xrom_a;
else if(sel_op1 == 3'd2)op1 = in_idat_r;
else if(sel_op1 == 3'd3)op1 = out_sfr_a;
else if(sel_op1 == 3'd4)op1 = in_idat_a;
else if(sel_op1 == 3'd5)op1 = out_sfr_r;
else 	op1 = 0;

always @(sel_op2 or
	in_idat_a or
	in_idat_r or
	out_sfr_a or
	out_sfr_r or
	in_xrom_a or
	out_b
	)
if (sel_op2 == 0) op2 = in_idat_a;
else if(sel_op2 == 3'd1)op2 = in_idat_r;
else if(sel_op2 == 3'd2)op2 = out_sfr_a;
else if(sel_op2 == 3'd3)op2 = in_xrom_a;
else if(sel_op2 == 3'd4)op2 = out_b;
else if(sel_op2 == 3'd5)op2 = out_sfr_r;
else	op2 = 0;



u_alu U3_alu(
	//in
	.clk(clk),
	.rst_p(rst_p),
	.en_div(en_div),
	.OP_A(op1),
	.OP_B(op2),
	.SEL(sel_alu),
	.IN_C(out_psw[7]),
	.IN_AC(out_psw[6]),
	//out
	.ALU(alu_a),	
	.CY(cy),
	.AC(ac),
	.OV(ov),
	.IN_B(in_b),
	.acc_chd(acc_chd) 
	);

always @(posedge clk) 
alu_r <= alu_a;
////////////////////////////////////////////////

///////////COMON BUS////////////////////////////
always @(
	sel_combus or 
	out_acc_r or 
	in_idat_a or 
	in_xrom_a or 
	in_xrom_r or 
	out_sfr_a or 
	out_sfr_r or 
	in_idat_r or
	in_xdat_a or 
	latch_acc or
	alu_r or 
	alu_a or
	out_pc_r or 
        latch_pc
	)
	if 	(sel_combus == 0) 
		combus1 = out_acc_r;  
	else if (sel_combus == 4'd1) 
		combus1 = in_idat_a;  
	else if (sel_combus == 4'd2) 
		combus1 = in_xrom_r;  
	else if (sel_combus == 4'd3) 
		combus1 = out_sfr_a;  
	else if (sel_combus == 4'd4) 
		combus1 = in_idat_r;
	else if (sel_combus == 4'd5) 
		combus1 = out_sfr_r;  
	else if (sel_combus == 4'd6) 
		combus1 = in_xdat_a;  
	else if (sel_combus == 4'd7) 
		combus1 = latch_acc;  
	else if (sel_combus == 4'd8) 
		combus1 = alu_r;  
	else if (sel_combus == 4'd9) 
		combus1 = alu_a;  
	else if (sel_combus == 4'd10) 
		combus1 = in_xrom_a;  
	else if (sel_combus == 4'd11) 
		combus1 = latch_pc[7:0];  
	else if (sel_combus == 4'd12) 
		combus1 = latch_pc[15:8];  
	else 	combus1 = 0;  
////////////////////////////////////////////////
always @(posedge clk or posedge rst_p) 
if(rst_p) addr2_r <= 0;
else addr2_r <= addr2_a;     

always @(posedge clk or posedge rst_p) 
if(rst_p) latch_acc <= 0;
else if(ld_latch_acc) latch_acc <= out_acc_r;

endmodule
