module u_sfr(
		//input
		end_instr,
		clk, 
		rst_p, 
		ld_acc, 
		ld_acc_chd, 
		addr_sfr,
		in_sfr, 
		wr_sfr,
		ld_dpl,
		ld_dph,
		inc_dptr,
		inc_sp,
		dec_sp,
		set_c,
		rst_c,
		cpl_c,
		ld_c,
		set_ac,
		rst_ac,
		set_v,
		rst_v,
		acc_chd,
		in_b,
		ld_b,
		in_cy_bit,
		rmw,
		t0_pin,
		t1_pin,
		int0_pin,
		int1_pin,
		p0_in,
		p1_in,
		p2_in,
		p3_in,
		//int
		reti,
		//output
		out_sfr_a, 
		out_acc_r,
		out_dptr_r,
		out_dimod_r,
		out_sp_r,
		out_psw,
		out_b,
		p0_out,
		p1_out,
		p2_out,
		p3_out,
		txdo,
		rxdi,
		rxdo,
		int_vec,
		en_int
		);
////////INPUT///////////////////////////////////
input 		end_instr;
input 		clk;
input 		rst_p;
input 		ld_acc;
input 		ld_acc_chd;
input[7:0] 	addr_sfr;
input[7:0] 	in_sfr;
input[7:0] 	acc_chd;
input[7:0] 	in_b;
input		wr_sfr;
input		ld_dpl;
input		ld_dph;
input		inc_dptr;
input		inc_sp;
input		dec_sp;
input	 	set_c;
input 		rst_c;
input		cpl_c;
input		ld_c;
input		set_ac;
input		rst_ac;
input		set_v;
input		rst_v;
input		ld_b;
input		in_cy_bit;
input		rmw;
input		t0_pin;
input		t1_pin;
input		int0_pin;
input		int1_pin;
input		rxdi;
input		reti;
input[7:0] 	p0_in;
input[7:0] 	p1_in;
input[7:0] 	p2_in;
input[7:0] 	p3_in;
///////OUTPUT///////////////////////////////////
output[7:0] 	out_sfr_a;
output[7:0] 	out_acc_r;
output[15:0] 	out_dptr_r;
output[7:0] 	out_dimod_r;
output[7:0] 	out_sp_r;
output[7:0]	out_psw;
output[7:0]	out_b;
output[7:0]	p0_out;
output[7:0]	p1_out;
output[7:0]	p2_out;
output[7:0]	p3_out;
output		txdo;
output		rxdo;
output[2:0]	int_vec;
output		en_int;
///////REG//////////////////////////////////////
reg[7:0] 	out_sfr_a;
///////WIRE/////////////////////////////////////
wire		parity;
wire[15:0] 	out_dptr_r;
wire[7:0] 	out_dimod_r;
wire[7:0] 	out_dpl_r;
wire[7:0] 	out_dph_r;
wire[7:0] 	out_sp_r;
wire[7:0] 	out_b;
wire[7:0] 	tcon;
wire[7:0] 	pcon;
wire[7:0] 	tmod;
wire[7:0] 	tl0;
wire[7:0] 	tl1;
wire[7:0] 	th0;
wire[7:0] 	th1;
wire[7:0] 	scon;
wire[7:0] 	sbuf;
wire[7:0] 	ie;
wire[7:0] 	ip;
wire[7:0] 	p0;
wire[7:0] 	p1;
wire[7:0] 	p2;
wire[7:0] 	p3;
wire		tf0;
wire		tf0_sync;
wire		tf1;
wire		tf1_sync;
wire		shift12;
wire            rst_tf0;
wire            rst_tf1;   
wire            set_ie0;
wire            rst_ie0;
wire            set_ie1;
wire            rst_ie1;
wire		disint;
wire		uart_int;
wire[2:0] 	isrc_cur;

assign rst_tf1 = (isrc_cur == 3'b100)? 1'b1 : 1'b0; 
assign rst_ie1 = (isrc_cur == 3'b011)? 1'b1 : 1'b0; 
assign rst_tf0 = (isrc_cur == 3'b010)? 1'b1 : 1'b0; 
assign rst_ie0 = (isrc_cur == 3'b001)? 1'b1 : 1'b0; 

/*----------------------------------------------
--                                            --
-- P0                                         --
--                                            --
----------------------------------------------*/
gpio0 U_port0(
        .clk(clk),
        .rst_p(rst_p),
        .wr(wr_sfr),
        .rmw(rmw),
 	.combus(in_sfr),
        .prt0_addr(addr_sfr),
	.p0_in(p0_in),
        .p0(p0),
	.p0_out(p0_out) 
	 );
/*----------------------------------------------
--                                            --
-- SP                                         --
--                                            --
----------------------------------------------*/
sp U0_sp(
        .clk(clk), 
        .rst_p(rst_p),
        .wr(wr_sfr), 
        .inc_sp(inc_sp), 
        .dec_sp(dec_sp),
        .addr_sp(addr_sfr),
        .in_sp(in_sfr),
        .out_sp(out_sp_r) 
	 );
/*----------------------------------------------
--                                            --
-- DPTR                                       --
--                                            --
----------------------------------------------*/
dptr U1_dptr(
        .clk(clk), 
        .rst_p(rst_p),
        .ld_dpl(ld_dpl),
        .ld_dph(ld_dph), 
	.wr(wr_sfr),
        .inc_dptr(inc_dptr),
        .addr_dptr(addr_sfr),
        .in_dptr(in_sfr),
        .out_dptr(out_dptr_r)
         ); 
assign out_dph_r = out_dptr_r[15:8];
assign out_dpl_r = out_dptr_r[7:0];
/*----------------------------------------------
--                                            --
-- DIMOD(Device Interface Mode)               --
--                                            --
----------------------------------------------*/
dimod U1_dimod(
        .clk(clk), 
        .rst_p(rst_p),
	.wr(wr_sfr),
        .addr_dimod(addr_sfr),
        .in_dimod(in_sfr),
        .out_dimod(out_dimod_r)
         ); 
/*----------------------------------------------
--                                            --
-- TCON                                       --
--                                            --
----------------------------------------------*/
one_shot one_shot_tf0 (
        .clk(clk),
        .rst_p(rst_p),
        .d(tf0),
        .q(tf0_sync)
	);

one_shot one_shot_tf1 (
        .clk(clk),
        .rst_p(rst_p),
        .d(tf1),
        .q(tf1_sync)
	);

tcon U_tcon(
        .clk(clk),
        .rst_p(rst_p),
	.in_tcon(in_sfr),
	.addr_tcon(addr_sfr),
        .wr(wr_sfr),
 	.set_tf0(tf0_sync),
        .rst_tf0(rst_tf0),
        .set_tf1(tf1_sync),
        .rst_tf1(rst_tf1),
        .set_ie0(set_ie0),
        .rst_ie0(rst_ie0),
        .set_ie1(set_ie1),
        .rst_ie1(rst_ie1),
	.out_tcon(tcon)
	);
/*----------------------------------------------
--                                            --
-- TMOD                                       --
--                                            --
----------------------------------------------*/
tmod U_tmod(
        .clk(clk),
        .rst_p(rst_p),
        .wr(wr_sfr),
        .in_tmod(in_sfr),
        .addr_tmod(addr_sfr),
        .out_tmod(tmod)
	 );
/*----------------------------------------------
--                                            --
-- TL0 TL1 TH0 TH1                            --
--                                            --
----------------------------------------------*/
u_tc U12_u_tc(
	//in
        .clk(clk),
        .rst_p(rst_p),
        .wr(wr_sfr),
        .in_tc(in_sfr),
        .addr_tc(addr_sfr),
        .t0_pin(t0_pin),
        .t1_pin(t1_pin),
        .int0_pin(int0_pin),
        .int1_pin(int1_pin),
        .sel_tc0(tmod[2]),
        .sel_tc1(tmod[6]),
        .gate0(tmod[3]),
        .gate1(tmod[7]),
        .tr0(tcon[4]),
        .tr1(tcon[6]),
        .tm0(tmod[1:0]),
        .tm1(tmod[5:4]),
	//out
        .tf0(tf0),
        .tf1(tf1),
        .tl0(tl0),
        .tl1(tl1),
        .th0(th0),
        .th1(th1),
	.shift12(shift12)
	);
/*----------------------------------------------
--                                            --
-- P1                                         --
--                                            --
----------------------------------------------*/
gpio1 U_port1(
        .clk(clk),
        .rst_p(rst_p),
        .wr(wr_sfr),
        .rmw(rmw),
 	.combus(in_sfr),
        .prt1_addr(addr_sfr),
	.p1_in(p1_in),
        .p1(p1),
	.p1_out(p1_out) 
	 );
/*----------------------------------------------
--                                            --
-- SBUF                                       --
-- SCON                                       --
-- PCON                                       --
--                                            --
----------------------------------------------*/
u_uart U_uart(
//////input////////////////////
	.clk(clk),
	.rst_p(rst_p),
    //rxdi//
	.rxdi(rxdi),       
    //sbuf//                     
	.in_sfr(in_sfr),
	.addr_sfr(addr_sfr),
	.wr(wr_sfr),
    //baud rate source//       
	.shift12(shift12),
	.tf1(tf1_sync),
//////output///////////////////
    //txd//
	.txdo(txdo),       
	.rxdo(rxdo),       
    //interrupt//              
	.uart_int(uart_int),
    //subuf output//
	.scon(scon),
	.pcon(pcon), 
	.sbuf(sbuf) 
	);
/*----------------------------------------------
--                                            --
-- P2                                         --
--                                            --
----------------------------------------------*/
gpio2 U_port2(
        .clk(clk),
        .rst_p(rst_p),
        .wr(wr_sfr),
        .rmw(rmw),
 	.combus(in_sfr),
        .prt2_addr(addr_sfr),
	.p2_in(p2_in),
        .p2(p2),
	.p2_out(p2_out) 
	 );
/*----------------------------------------------
--                                            --
-- IE                                         --
--                                            --
----------------------------------------------*/
ie U_ie(
        .clk(clk),
        .rst_p(rst_p),
	.in_ie(in_sfr),
	.addr_ie(addr_sfr),
        .wr(wr_sfr),
	.out_ie(ie)
	);
/*----------------------------------------------
--                                            --
-- P3                                         --
--                                            --
----------------------------------------------*/
gpio3 U_port3(
        .clk(clk),
        .rst_p(rst_p),
        .wr(wr_sfr),
        .rmw(rmw),
 	.combus(in_sfr),
        .prt3_addr(addr_sfr),
	.p3_in(p3_in),
        .p3(p3),
	.p3_out(p3_out) 
	 );
/*----------------------------------------------
--                                            --
-- IP                                         --
--                                            --
----------------------------------------------*/
ip U_ip(
        .clk(clk),
        .rst_p(rst_p),
        .in_ip(in_sfr),
	.addr_ip(addr_sfr),
        .wr(wr_sfr),
	.out_ip(ip)
	);
/*----------------------------------------------
--                                            --
-- PSW                                        --
--                                            --
----------------------------------------------*/
psw U3_psw(    
	// input 
        .clk(clk),
	.rst_p(rst_p),
        .in_psw(in_sfr[7:1]),
	.addr_psw(addr_sfr),
        .wr(wr_sfr),
        .set_c(set_c),
        .rst_c(rst_c),
        .cpl_c(cpl_c),
        .ld_c(ld_c),
        .set_ac(set_ac),
        .rst_ac(rst_ac),
        .set_v(set_v),
        .rst_v(rst_v),
        .parity(parity),
	.in_cy_bit(in_cy_bit),
	// output
        .out_psw(out_psw)
        );
/*----------------------------------------------
--                                            --
-- ACC                                        --
--                                            --
----------------------------------------------*/
acc U2_acc(
	.clk(clk),
	.rst_p(rst_p),
	.ld_acc(ld_acc),
	.ld_acc_chd(ld_acc_chd),
	.wr(wr_sfr),
	.addr_acc(addr_sfr),
	.in_acc(in_sfr),
	.acc_chd(acc_chd),
	.out_acc_r(out_acc_r)
	);

parity_gen U4_parity(
	.p_acc(out_acc_r),
	.parity(parity)
	);
/*----------------------------------------------
--                                            --
-- B                                          --
--                                            --
----------------------------------------------*/
b U4_b(
        .clk(clk),    
        .rst_p(rst_p),    
        .in_dat(in_sfr),
        .in_b(in_b),
        .addr_b(addr_sfr), 
        .wr(wr_sfr),
        .ld_b(ld_b),
        .out_b(out_b)
        );
/*----------------------------------------------
--                                            --
-- iterrutp source detector                   --
--                                            --
----------------------------------------------*/
u_int U27_int(
	//input
       .disint(disint),
       .end_instr(end_instr),
       .ti_ri(uart_int),
       .clk(clk),
       .rst_p(rst_p),
       .ex_int_a(int0_pin),
       .ex_int_b(int1_pin),
       .it_a(tcon[0]),
       .it_b(tcon[2]),
       .tf_a(tcon[5]),
       .tf_b(tcon[7]),
       .ie_j(ie[7]),
       .ie(ie[4:0]),
       .ip(ip[4:0]),
       .ie_a(tcon[1]),
       .ie_b(tcon[3]),
	.reti(reti),
	//output
        .smpl_ex_a(set_ie0),
       .smpl_ex_b(set_ie1),
	.int_vec(int_vec),
	.isrc_cur(isrc_cur),
	.en_int(en_int) 
       );
assign disint =( 
	reti | 
	((addr_sfr == 8'ha8)&(wr_sfr)) | 
	((addr_sfr == 8'hb8)&(wr_sfr))); 
//assign disint = 0;
/*----------------------------------------------
--                                            --
-- sfr mux                                    --
--                                            --
----------------------------------------------*/
always @(
addr_sfr or 
p0 or 
out_sp_r or 
out_dpl_r or 
out_dph_r or 
pcon or 
tcon or 
tmod or 
tl0 or 
tl1 or 
th0 or 
th1 or 
p1 or 
sbuf or 
p2 or 
ie or 
p3 or 
ip or 
out_psw or 
out_acc_r or 
out_b or 
scon
) 
if      (addr_sfr == 8'h80)
	out_sfr_a <= p0;
else if (addr_sfr == 8'h81)
	out_sfr_a <= out_sp_r;
else if (addr_sfr == 8'h82)
	out_sfr_a <= out_dpl_r;
else if (addr_sfr == 8'h83)
	out_sfr_a <= out_dph_r;
else if (addr_sfr == 8'h87)
	out_sfr_a <= pcon;
else if (addr_sfr == 8'h88)
	out_sfr_a <= tcon;
else if (addr_sfr == 8'h89)
	out_sfr_a <= tmod;
else if (addr_sfr == 8'h8a)
	out_sfr_a <= tl0;
else if (addr_sfr == 8'h8b)
	out_sfr_a <= tl1;
else if (addr_sfr == 8'h8c)
	out_sfr_a <= th0;
else if (addr_sfr == 8'h8d)
	out_sfr_a <= th1;
else if (addr_sfr == 8'h90)
	out_sfr_a <= p1;
else if (addr_sfr == 8'h98)
	out_sfr_a <= scon;
else if (addr_sfr == 8'h99)
	out_sfr_a <= sbuf;
else if (addr_sfr == 8'ha0)
	out_sfr_a <= p2;
else if (addr_sfr == 8'ha8)
	out_sfr_a <= ie;
else if (addr_sfr == 8'hb0)
	out_sfr_a <= p3;
else if (addr_sfr == 8'hb8)
	out_sfr_a <= ip;
else if (addr_sfr == 8'hd0)
	out_sfr_a <= out_psw;
else if (addr_sfr == 8'he0)
	out_sfr_a <= out_acc_r;
else if (addr_sfr == 8'hf0)
	out_sfr_a <= out_b;
else out_sfr_a <= 0;
endmodule
