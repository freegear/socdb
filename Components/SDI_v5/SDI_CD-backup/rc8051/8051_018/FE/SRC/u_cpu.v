module u_cpu(
//INPUT
                clk,
                rst_p,
                //
                //PROGRAM MEM
                //
                in_xrom_a,
                //
		//INTERNAL DATA MEM
		//
                in_idat_a,
		//
                //EXTERNAL DATA MEM
                //
                in_xdat_a,
                //
                //GPIO
                //
                p0_in,
                p1_in,
                p2_in,
                p3_in,
                //
                //SPECIAL FUN P3
                //
                rxdi,
                t0_pin,
                t1_pin,
                int0_pin,
                int1_pin,
//OUTPUT
                //
                //PROGRAM MEM
                //
                addr_xrom_a,
                psen,
                //
                //INTERNAL DATA MEM
                //
		addr_a,
		out_idat,
		wr_idat,
		rd_idat,
		//
                //EXTERNAL DATA MEM
                //
                xaddr_high,
                out_xdat,
                ale,
                //
                //GPIO
                //
                p0_out,
                p1_out,
                p2_out,
                p3_out,
                p0_en,
                p1_en,
                p2_en,
                p3_en,
                //
                //SPECIAL FUN P3
                //
                wr_xdat,
                rd_xdat,
                rxdo,
                txdo,
                xdat_en,
		sel_code_xdat
                );


////////INPUT///////////////////////////////////
input		clk;
input 		rst_p;

input[7:0]      in_xrom_a; // CODE  
input[7:0]      in_idat_a; // IDATA 
input[7:0]      in_xdat_a; // XDATA 

input           t0_pin;
input           t1_pin;
input           int0_pin;
input           int1_pin;
input		rxdi;
input[7:0]	p0_in;		
input[7:0]	p1_in;		
input[7:0]	p2_in;		
input[7:0]	p3_in;	
///////OUTPUT///////////////////////////////////
output[15:0]    addr_xrom_a;
output[7:0]     addr_a; // 8051 all memory addr
output          wr_idat; 
output          rd_idat; 
output          wr_xdat; 
output          rd_xdat; 
output		ale;
output[7:0]	xaddr_high;		
output[7:0]	p0_out;		
output[7:0]	p1_out;		
output[7:0]	p2_out;		
output[7:0]	p3_out;	
output[7:0]	p0_en;		
output[7:0]	p1_en;		
output[7:0]	p2_en;		
output[7:0]	p3_en;	
output		txdo;	
output		rxdo;	
output		psen;	
output[7:0]	out_idat;	
output[7:0]	out_xdat;	
output		xdat_en;
output		sel_code_xdat;
///////WIRE/////////////////////////////////////
wire            end_instr;
wire            ld_acc;
wire            ld_acc_chd;
wire            inc_pc;
wire            inc_pc2;
wire            inc_pc3;
wire   	        ld_pc;
wire[3:0]       sel_combus;
wire            sel_addr;
wire[2:0]       sel_addr1;
wire            wr_idat; 
wire            wr_idat_p; 
wire            rd_idat_p; 
wire            wr_xdat_p; 
wire            rd_xdat_p; 
wire[7:0]       code;
wire            msb_a; //8051 all memory addr
wire            msb_r; //latch 8051 memory addr
wire		ale_neg;
wire		sel_xad;
wire		sel_xaddr_high;      
wire		inc_sp;
wire		dec_sp;
wire		ld_latch_acc;
wire            set_c;
wire            rst_c;
wire            cpl_c;
wire            ld_c;
wire            set_ac;
wire            rst_ac;
wire            set_v;
wire            rst_v;
wire[2:0]	sel_op1;
wire[2:0]	sel_op2;
wire 		cy,ac,ov;
wire[2:0]	sel_pc;
wire		sel_page_addr;
wire[7:0]	out_acc_r;
wire		cy_psw;
wire[7:0]	combus;
wire[7:0]       out_dimod_r;
wire[7:0]	in_xrom1_r;
wire		bit_dat_in;
wire		bit_dat_in_r;
wire		rmw;
wire[4:0]       sel_alu; 
wire[2:0]       addr_bank_a;
wire[1:0]	sel_bit_dat_out;
wire[2:0]	sel_in_cy_bit;
wire		reti;
wire		en_int;
wire		ld_instr; 
wire		sel_addr0;
wire		wr_sfr;
wire		ld_dpl;
wire		ld_dph;
wire		inc_dptr;
wire		sel_xdat;
wire		sel_xaddr_low;
wire		ld_b;
wire		en_div;
wire		bit_addr;
wire[7:0]	p0_out;		
wire[7:0]	p1_out;		
wire[7:0]	p2_out;		
wire[7:0]	p3_out;	
wire		ld_apc;  
wire		ld_adptr;  
wire            ld_pcl, ld_pch, ld_operand2, ld_xrom, ld_idat, ld_sfr;
///////REG//////////////////////////////////////
reg		ale;		
reg		xdat_en;		
////////////////////////////////////////////////

/////////control idat/////////////////////////
//assign wr_idat = wr_idat_p;
assign wr_idat = !wr_idat_p; 
//assign  wr_idat =  wr_idat_p;
assign  rd_idat = !rd_idat_p;
//assign  rd_idat =  rd_idat_p;
/////////control xdat/////////////////////////
assign  wr_xdat = !wr_xdat_p;
//assign 5 wr_xdat =  wr_xdat_p;
assign  rd_xdat = !rd_xdat_p;
//assign 5 rd_xdat =  rd_xdat_p;
//////////////////////////////////////////////
always @(negedge clk or posedge rst_p)
if (rst_p) ale <= 0;
else	ale <= ale_neg;
//////////////////////////////////////////////
always @(negedge clk or posedge rst_p)
if (rst_p)  xdat_en <= 0;
else	xdat_en <= wr_xdat;

assign p0_en = p0_out;
assign p1_en = p1_out;
assign p2_en = p2_out;
assign p3_en = p3_out;

u_con	U0_con (
        // input
    	.code(code),
        .clk(clk),
        .rst_p(rst_p),
        .en_int(en_int),
	.msb_a(msb_a),
	.msb_r(msb_r),
	.cy(cy),
	.ac(ac),
	.ov(ov),
	.out_acc_r(out_acc_r),
	.cy_psw(cy_psw),
	.combus(combus),
	.out_dimod_r(out_dimod_r),
	.in_xrom1_r(in_xrom1_r),
	.bit_dat_in_r(bit_dat_in_r),
        // output
        .ld_instr(ld_instr),
 	.wr_idat(wr_idat_p),
	.rd_idat(rd_idat_p),
        .inc_pc(inc_pc),
        .inc_pc2(inc_pc2),
        .inc_pc3(inc_pc3),
        .ld_pc(ld_pc),
        .ld_pcl(ld_pcl),
        .ld_pch(ld_pch),
        .ld_acc(ld_acc),
        .ld_acc_chd(ld_acc_chd),
        .sel_combus(sel_combus),
        .sel_addr0(sel_addr0),
        .sel_addr1(sel_addr1),
	.wr_sfr(wr_sfr),
        .ld_dpl(ld_dpl),
	.ld_dph(ld_dph),
	.inc_dptr(inc_dptr),
	.wr_xdat(wr_xdat_p),
	.rd_xdat(rd_xdat_p),
	.ale(ale_neg),
	.sel_xad(sel_xdat),
	.sel_xaddr_low(sel_xaddr_low),
	.sel_xaddr_high(sel_xaddr_high), 
	.inc_sp(inc_sp),
	.dec_sp(dec_sp),
	.ld_latch_acc(ld_latch_acc),
        .set_c(set_c),
        .rst_c(rst_c),
        .cpl_c(cpl_c),
        .ld_c(ld_c),
        .set_ac(set_ac),
        .rst_ac(rst_ac),
        .set_v(set_v),
        .rst_v(rst_v), 
	.sel_op1(sel_op1),
	.sel_op2(sel_op2), 
	.ld_b(ld_b), 
	.en_div(en_div),
	.sel_pc(sel_pc),
	.sel_page_addr(sel_page_addr),
	.bit_addr(bit_addr),
	.rmw(rmw),
        //int
	 .sel_alu(sel_alu), 
	 .addr_bank_a(addr_bank_a),
	 .sel_bit_dat_out(sel_bit_dat_out),
	 .sel_in_cy_bit(sel_in_cy_bit),
	.reti(reti),
	.psen(psen),
	.sel_code_xdat(sel_code_xdat),
	.end_instr(end_instr),
        .ld_operand2(ld_operand2),
	.ld_xrom(ld_xrom),
        .ld_idat(ld_idat), 
        .ld_sfr(ld_sfr), 
	.ld_apc(ld_apc),  
	.ld_adptr(ld_adptr)   
        );

u_datapath U1_datapath (
        // input
	.ld_apc(ld_apc),  
	.ld_adptr(ld_adptr),  
	.ld_xrom(ld_xrom),
        .ld_idat(ld_idat), 
        .ld_sfr(ld_sfr), 
        .ld_operand2(ld_operand2),
	.end_instr(end_instr),
        .clk(clk),
        .rst_p(rst_p),
        .ld_instr(ld_instr),
        .inc_pc(inc_pc),
        .inc_pc2(inc_pc2),
        .inc_pc3(inc_pc3),
        .ld_pc(ld_pc),
        .ld_pcl(ld_pcl),
        .ld_pch(ld_pch),
        .ld_acc(ld_acc),
        .ld_acc_chd(ld_acc_chd),
        .sel_addr0(sel_addr0),
        .sel_addr1(sel_addr1),
        .in_xrom_a(in_xrom_a),
        .in_idat_a(in_idat_a),
        .sel_combus(sel_combus),
	.wr_sfr(wr_sfr),
	.ld_dpl(ld_dpl),
	.ld_dph(ld_dph),
        .inc_dptr(inc_dptr),
	.sel_xad(sel_xdat),
	.sel_xaddr_low(sel_xaddr_low),
	.sel_xaddr_high(sel_xaddr_high), 
	.in_xdat_a(in_xdat_a),
	.ld_latch_acc(ld_latch_acc), 
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
	.sel_op1(sel_op1),
	.sel_op2(sel_op2),
	.ld_b(ld_b),
	.en_div(en_div), 
	.sel_pc(sel_pc),
	.sel_page_addr(sel_page_addr), 
	.bit_addr(bit_addr), 
        .p0_in(p0_in),
        .p1_in(p1_in),
        .p2_in(p2_in),
        .p3_in(8'hff),
	.rmw(rmw),
        .t0_pin(t0_pin),
        .t1_pin(t1_pin),
        .int0_pin(int0_pin),
        .int1_pin(int1_pin),
	//int
	.reti(reti),
	.sel_bit_dat_out(sel_bit_dat_out),
	.sel_in_cy_bit(sel_in_cy_bit),
	.rxdi(rxdi),
        // output
	.p0_out(p0_out),
        .p1_out(p1_out),
        .p2_out(p2_out),
        .p3_out(p3_out),
        .addr_xrom_a(addr_xrom_a),
        .addr_a(addr_a),
        .msb_a(msb_a),
	.msb_r(msb_r),
        .en_int(en_int),
	.xaddr_high(xaddr_high),
	.cy(cy),
	.ac(ac),
	.ov(ov), 
	.out_acc_r(out_acc_r),
	.cy_psw(cy_psw), 
	.combus(combus),    
	.out_dimod_r(out_dimod_r),    
	.in_xrom1_r(in_xrom1_r),
	.bit_dat_in_r(bit_dat_in_r),
	.txdo(txdo), 
	.rxdo(rxdo),
        .sel_alu(sel_alu),
	.addr_bank_a(addr_bank_a), 
    	.code(code),
	.out_xdat(out_xdat),
	.out_idat(out_idat) 
        );
endmodule
