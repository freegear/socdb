module u_alu(
	en_div,
	clk,
	rst_p, 
	OP_B,   
        OP_A,   
        SEL,    
        IN_C,   
        IN_AC,  
        ALU,    
        CY,     
        AC,     
        OV,     
        IN_B,
        acc_chd 
		);             
     
        input		  en_div;
        input		  clk;
        input		  rst_p;
        input[7:0]        OP_B;  
        input[7:0]        OP_A;  
        input[4:0]        SEL;   
        input             IN_C;  
        input             IN_AC; 
        
	    output[7:0]       ALU;   
        output            CY;    
        output            AC;    
        output            OV;    
        output[7:0]       IN_B; 
        output[7:0]       acc_chd; 
   
        wire      s_AC_ADDC;       
        wire      s_OV_ADDC;       
        wire      s_CY_ADDC;       
        wire      s_CY_RRC;        
        wire      s_CY_RLC;        
        wire      ocy;        
	wire[7:0] s_SET;
	wire[7:0] s_SWAP;
	wire[7:0] s_RRC;
	wire[7:0] s_RR;
	wire[7:0] s_RLC;
	wire[7:0] s_RL;
	wire[7:0] s_INV;
	wire[7:0] s_CLR;
	wire[7:0] s_XOR;
	wire[7:0] s_OR;
	wire[7:0] s_AND;
	wire[3:0] s_sel;
	wire[7:0] oOP_B;
	wire[7:0] s_DA;
	wire[7:0] s_Q;
	wire[7:0] s_R;
	wire[15:0]s_M;
	wire[7:0] s_ADDC;
	
	wire[7:0] s_ram_chd;
	
	assign s_SET = 8'hff;

	swap U2_swap (
		.d(OP_A),
		.q(s_SWAP));

	rrc U3_rrc (
		.d(OP_A),		
		.in_cy(IN_C), 	
		.out_cy(s_CY_RRC),	
		.q(s_RRC));

	rr U4_rr (
		.d(OP_A), 
		.q(s_RR));

	rlc U5_rlc (
		.d(OP_A),			
		.in_cy(IN_C), 	
		.out_cy(s_CY_RLC),	
		.q(s_RLC));

	rl U6_rl (
		.d(OP_A),
	        .q(s_RL));

	assign s_INV = ~ OP_A;
	assign s_CLR = 0;
	assign s_XOR = OP_A ^ OP_B;
	assign s_OR = OP_A | OP_B;
	assign s_AND = OP_A & OP_B;

	da U7_da (
		.d(OP_A),			
	        .ac(IN_AC),		
	        .cy(IN_C),		
	        .q(s_DA));

	div U8_div (
		.clk(clk),
                .rst_p(rst_p),
                .Load(en_div),
                .Dividend(OP_A),
                .Divisor(OP_B),
                .Quotient(s_Q),
                .Remainder(s_R));

/*
	UDIV8x8 U8_div (
		.A(OP_A),
		.B(OP_B),
		.Quotient(s_Q),
		.Remainder(s_R));
*/ 

/*
	mul U9_mul(
		.op1(OP_A),		
		.op2(OP_B),		
		.m(s_M));
*/ 

	wire[2:0]	 MulStage;

	assign MulStage = 3'd5;

	wire     	 enMul;

	assign enMul = (s_sel == 4'd1)? 1 : 0;

	wire[7:0]  data_10h; 
	
        assign  data_10h = 8'h10; 

	DW_mult_pipe U9_DW_mult_pipe(
		.clk(clk),
		.rst_n(~rst_p),
		.en(enMul),
		.tc(1'b0),
		.a(OP_A),
		.b(OP_B),
	//	.b(data_10h),
		.product(s_M));

	sel_arth U10_sel_arth(
		.iop2(OP_B), 
		.icin(IN_C), 
		.sel(SEL[2:0]), 
		.oop2(oOP_B), 
		.ocin(ocy));

	sel_al U11_sel_al(
		.isel(SEL[4:0]), 
		.osel(s_sel));	
        
	adc U12_adc(
		.dataa(OP_A), 
		.datab(oOP_B), 
		.cin(ocy), 
		.ac(s_AC_ADDC), 
		.cout(s_CY_ADDC), 
		.overflow(s_OV_ADDC), 
		.result(s_ADDC));	
       
        xchd U_xchd(
		.in_acc(OP_A),
		.in_ram(OP_B),
		.out_acc(acc_chd),
		.out_ram(s_ram_chd));

	mux16t1_8 U18_sel_alu(
		.a0(s_ADDC), 	
		.a1(s_M[7:0]),    
		.a2(s_Q),    
		.a3(s_DA),    
		.a4(s_AND),    
		.a5(s_OR),    
		.a6(s_XOR),    
		.a7(s_CLR),    
		.a8(s_INV),    
		.a9(s_RL),    
		.b0(s_RLC),    
		.b1(s_RR),    
		.b2(s_RRC),    
		.b3(s_SWAP),    
		.b4(s_SET),    
		.b5(s_ram_chd),    
		.sel(s_sel),   
	        .qq(ALU));

	alu_flag_d_m U19_alu_flag (
		.al(SEL),			
		.m(s_M[15:8]),				
		.r(s_R),				
		.dividor(OP_B),				
		.cy_addc(s_CY_ADDC),		
		.cy_rlc(s_CY_RLC),		
		.cy_rrc(s_CY_RRC),		
		.ac_addc(s_AC_ADDC),		
		.ov_addc(s_OV_ADDC),		
		.cy(CY),			
		.ac(AC),			
		.ov(OV),			
	    	.IN_B(IN_B));
endmodule
