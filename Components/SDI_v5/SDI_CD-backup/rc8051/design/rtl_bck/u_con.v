module u_con(
		// input 
		code,
		clk,
		rst_p,
		en_int,
		msb_a,
		msb_r,
		cy,
		ac,
		ov,
		out_acc_r,
		cy_psw,
		combus,
		out_dimod_r,
		in_xrom1_r,
		bit_dat_in_r,
               	// output
		ld_instr,
	        wr_idat,
                rd_idat, 
		end_instr,
		ld_pc,    
		ld_pcl,    
		ld_pch,    
                ld_acc,   
                ld_acc_chd,   
                inc_pc,   
                inc_pc2,   
                inc_pc3,   
                sel_combus,
		sel_addr0, 
		sel_addr1,
		wr_sfr,
		ld_dpl,
		ld_dph,
		inc_dptr,
		wr_xdat,
		rd_xdat,	
		ale,
		sel_xad,
		sel_xaddr_low,
		sel_xaddr_high,
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
		sel_page_addr,
		bit_addr,
		rmw,
		//int
		sel_alu,
           	addr_bank_a,
		sel_bit_dat_out,
		sel_in_cy_bit,
	        reti,
		psen,
		ld_xrom,
		ld_idat,
		ld_sfr,
		ld_operand2,
		sel_code_xdat,
		ld_adptr,
		ld_apc	
		);
//////////INPUT/////////////////////////////////
input 		clk;
input 		rst_p;
input		en_int;
input    	msb_a;
input   	msb_r;
input		cy, ac, ov;
input[7:0]	out_acc_r;
input		cy_psw;
input[7:0]	combus;
input[7:0]	out_dimod_r;
input[7:0]	in_xrom1_r;
input[7:0]	code;
input		bit_dat_in_r;
//////////OUTPUT////////////////////////////////
output		ld_xrom;
output		ld_operand2;
output		ld_idat;
output		ld_sfr;
output		ld_instr;
output          wr_idat;
output          rd_idat; 
output		end_instr;
output          ld_acc;  
output          ld_acc_chd;  
output          inc_pc;
output          inc_pc2;
output          inc_pc3;
output          ld_pc;
output          ld_pcl;
output          ld_pch;
output[3:0]     sel_combus;
output          sel_addr0;
output[2:0]     sel_addr1;
output		wr_sfr;
output		ld_dpl;
output		ld_dph;
output		inc_dptr;
output		wr_xdat;
output		rd_xdat;
output		ale;
output		sel_xad;
output		sel_xaddr_low;
output		sel_xaddr_high;
output		inc_sp;
output		dec_sp;
output		ld_latch_acc;
output          set_c;
output          rst_c;
output          cpl_c;
output          ld_c;
output          set_ac;
output          rst_ac;
output          set_v;
output          rst_v;
output[2:0]	sel_op1;
output[2:0]	sel_op2; 
output		ld_b;
output		en_div;
output[2:0]     sel_pc;
output		sel_page_addr;
output		bit_addr;
output		rmw;
                //int
output		reti;
output[4:0]     sel_alu;
output[2:0]   	addr_bank_a;
output[1:0]	sel_bit_dat_out;
output[2:0]	sel_in_cy_bit;
output		psen;
output		sel_code_xdat;
output		ld_adptr;
output		ld_apc;
//////////WIRE//////////////////////////////////
// control  signal
wire            sel_addr0;
wire[2:0]       sel_addr1;
wire            ld_pc;
wire            ld_pcl;
wire            ld_pch;
wire            ld_acc;
wire            ld_acc_chd;
wire[3:0]       sel_combus;
wire            wr_idat;
wire            rd_idat;
wire            wr_sfr;
wire            inc_pc;
wire            inc_pc2;
wire            inc_pc3;
wire            ld_dpl;
wire            ld_dph;
wire            inc_dptr;
wire            ld_instr;
wire            wr_xdat;
wire            rd_xdat;
wire            ale;
wire            sel_xad;
wire            sel_xaddr_low;
wire            sel_xaddr_high;
wire            inc_sp;
wire            dec_sp;
wire            ld_latch_acc;
wire            set_c;
wire            rst_c;
wire            cpl_c;
wire            ld_c;
wire            set_ac;
wire            rst_ac;
wire            set_v;
wire            rst_v;
wire[2:0]       sel_op1;
wire[2:0]       sel_op2;
wire            ld_b;
wire            en_div;
wire[2:0]       sel_pc;
wire    	sel_page_addr;
wire            bit_addr;
wire            rmw;
wire            end_instr;
//"i" format instruction set
wire		c_08f;
wire		c_18f;
wire		c_28f;
wire		c_38f;
wire		c_48f;
wire		c_58f;
wire		c_68f;
wire		c_78f;
wire		c_88f;
wire		c_98f;
wire		c_a8f;
wire		c_b8f;
wire		c_c8f;
wire		c_d8f;
wire		c_e8f;
wire		c_f8f;
//"i&j" format instruction set
wire		c_067;
wire		c_167;
wire		c_267;
wire		c_367;
wire		c_467;
wire		c_567;
wire		c_667;
wire		c_767;
wire		c_867;
wire		c_967;
wire		c_a67;
wire		c_b67;
wire		c_c67;
wire		c_d67;
wire		c_e67;
wire		c_f67;
//"i&j&k" format instruction set
wire		c_00;
wire		c_02;
wire		c_03;
wire		c_04;
wire		c_05;
wire		c_10;
wire		c_12;
wire		c_13;
wire		c_14;
wire		c_15;
wire		c_20;
wire		c_22;
wire		c_23;
wire		c_24;
wire		c_25;
wire		c_30;
wire		c_32;
wire		c_33;
wire		c_34;
wire		c_35;
wire		c_40;
wire		c_42;
wire		c_43;
wire		c_44;
wire		c_45;
wire		c_50;
wire		c_52;
wire		c_53;
wire		c_54;
wire		c_55;
wire		c_60;
wire		c_62;
wire		c_63;
wire		c_64;
wire		c_65;
wire		c_70;
wire		c_72;
wire		c_73;
wire		c_74;
wire		c_75;
wire		c_80;
wire		c_82;
wire		c_83;
wire		c_84;
wire		c_85;
wire		c_90;
wire		c_92;
wire		c_93;
wire		c_94;
wire		c_95;
wire		c_a0;
wire		c_a2;
wire		c_a3;
wire		c_a4;
wire		c_a5;
wire		c_b0;
wire		c_b2;
wire		c_b3;
wire		c_b4;
wire		c_b5;
wire		c_c0;
wire		c_c2;
wire		c_c3;
wire		c_c4;
wire		c_c5;
wire		c_d0;
wire		c_d2;
wire		c_d3;
wire		c_d4;
wire		c_d5;
wire		c_e0;
wire		c_e23;
wire		c_e4;
wire		c_e5;
wire		c_f0;
wire		c_f23;
wire		c_f4;
wire		c_f5;
//"i&j&k" format instruction set
wire		c_01_e1;
wire		c_11_f1;
/////////REG////////////////////////////////////
wire[2:0]   	addr_bank_a;
wire[1:0]	sel_bit_dat_out;
wire[2:0]	sel_in_cy_bit;
wire 		start_int_svr;
// timing counter
reg[3:0]	timing_cnt;
//Timing decoder
reg[11:0]	t;
reg[3:0]	t_2;
reg		extend_mux;
reg		extend_rd;
reg		extend_wr;
reg		end_movx;
reg[3:0]	it;
reg             en_itcnt;
wire            en_int1;
//DIMOD decoder
reg[7:0]	d;

//Timing Conunter I
always @(posedge clk or posedge rst_p)
if(rst_p) timing_cnt <= 0;
else if(end_instr | en_itcnt)timing_cnt <= 0;
else timing_cnt <= timing_cnt + 1'b1;

//timing conunter II
always @(posedge clk or posedge rst_p)
if(rst_p) t_2 <= 0;
else if(end_movx) t_2 <= 0;
else if(
	(c_e0  |
        c_e23 |
        c_f0  |
        c_f23)&
	!t[0] 
	) t_2 <= t_2 + 1'b1;

always @(posedge clk or posedge rst_p)
if(rst_p) extend_mux <= 0;
else if(end_movx) extend_mux <= 0;
else if(
	(
	c_e0  |
        c_e23 |
        c_f0  |
        c_f23) &
	(t_2 >= 1)
	) extend_mux <= 1;

always @(posedge clk or posedge rst_p)
if(rst_p) extend_wr <= 0;
else if(end_movx) extend_wr <= 0;
else if(
	(
        c_f0  |
        c_f23) &
	(t_2 >= 1)
	) extend_wr <= 1;

always @(posedge clk or posedge rst_p)
if(rst_p) extend_rd <= 0;
else if(end_movx) extend_rd <= 0;
else if(
	(c_e0  |
        c_e23 |
        c_f0  |
        c_f23) &
	(t_2 >= 1)
	) extend_rd <= 1;

//itiming conunter III
one_shot one_shot_en_int (
        .clk(clk),
        .rst_p(rst_p),
        .d(en_int),
        .q(en_int1)
        );
reg[2:0] itcnt;

always @(rst_p or en_int1 or itcnt)
if(rst_p) en_itcnt <= 0;
else if(en_int1) en_itcnt <= 1;
else if(itcnt > 4) en_itcnt <= 0; 

always @(posedge clk or  posedge rst_p)
if (rst_p) itcnt<= 0;
else if(en_itcnt) itcnt <= itcnt + 1;
else itcnt <= 0;

always @(itcnt)
case(itcnt)
3'b000:	it = 4'b0000;
3'b001:	it = 4'b0001;
3'b010:	it = 4'b0010;
3'b011:	it = 4'b0100;
3'b100:	it = 4'b1000;
default:it = 5'b0000;
endcase

//Timing Decoder
always @(timing_cnt)
case(timing_cnt)
4'b0000: t = 12'b000000000001;
4'b0001: t = 12'b000000000010;
4'b0010: t = 12'b000000000100;
4'b0011: t = 12'b000000001000;
4'b0100: t = 12'b000000010000;
4'b0101: t = 12'b000000100000;
4'b0110: t = 12'b000001000000;
4'b0111: t = 12'b000010000000;
4'b1000: t = 12'b000100000000;
4'b1001: t = 12'b001000000000;
4'b1010: t = 12'b010000000000;
4'b1011: t = 12'b100000000000;
default: t = 12'b000000000000;
endcase

//DIMOD Decoder
always @(out_dimod_r)
case(out_dimod_r[2:0])   // movx machine cycle
3'b000: d = 8'b00000010; //         4 *      chnage (3'd0 <=> 3'd1) --11/30, jaeyoon  
3'b001: d = 8'b00000001; //         3
3'b010: d = 8'b00000100; //         5 
3'b011: d = 8'b00001000; //         9 *
3'b100: d = 8'b00010000; //         10 
3'b101: d = 8'b00100000; //         11
3'b110: d = 8'b01000000; //         12
default: d = 1'b0;
endcase	

wire movx;
assign movx = (
	!t[0] &(
	c_e0 |
        c_e23 |
        c_f0  |
        c_f23
	));

//End MOVX
always @(d or t or movx)
case({movx,d})   			// movx machine cycle
9'b100000001: end_movx = t[2];   //     3
9'b100000010: end_movx = t[3];   //     4 *
9'b100000100: end_movx = t[4];   //     5 
9'b100001000: end_movx = t[8];   //     9 *
9'b100010000: end_movx = t[9];   //     10 
9'b100100000: end_movx = t[10];  //     11
9'b101000000: end_movx = t[11];  //     12
default: end_movx = 1'b0;
endcase	

//"i" format instruction set
assign c_08f = (code[7:3] == 5'b00001)? 1'b1: 1'b0;
assign c_18f = (code[7:3] == 5'b00011)? 1'b1: 1'b0;
assign c_28f = (code[7:3] == 5'b00101)? 1'b1: 1'b0;
assign c_38f = (code[7:3] == 5'b00111)? 1'b1: 1'b0;
assign c_48f = (code[7:3] == 5'b01001)? 1'b1: 1'b0;
assign c_58f = (code[7:3] == 5'b01011)? 1'b1: 1'b0;
assign c_68f = (code[7:3] == 5'b01101)? 1'b1: 1'b0;
assign c_78f = (code[7:3] == 5'b01111)? 1'b1: 1'b0;
assign c_88f = (code[7:3] == 5'b10001)? 1'b1: 1'b0;
assign c_98f = (code[7:3] == 5'b10011)? 1'b1: 1'b0;
assign c_a8f = (code[7:3] == 5'b10101)? 1'b1: 1'b0;
assign c_b8f = (code[7:3] == 5'b10111)? 1'b1: 1'b0;
assign c_c8f = (code[7:3] == 5'b11001)? 1'b1: 1'b0;
assign c_d8f = (code[7:3] == 5'b11011)? 1'b1: 1'b0;
assign c_e8f = (code[7:3] == 5'b11101)? 1'b1: 1'b0;
assign c_f8f = (code[7:3] == 5'b11111)? 1'b1: 1'b0;
//"i&j" format instruction set
assign c_067 = (code[7:1] == 7'b0000011)? 1'b1: 1'b0;
assign c_167 = (code[7:1] == 7'b0001011)? 1'b1: 1'b0;
assign c_267 = (code[7:1] == 7'b0010011)? 1'b1: 1'b0;
assign c_367 = (code[7:1] == 7'b0011011)? 1'b1: 1'b0;
assign c_467 = (code[7:1] == 7'b0100011)? 1'b1: 1'b0;
assign c_567 = (code[7:1] == 7'b0101011)? 1'b1: 1'b0;
assign c_667 = (code[7:1] == 7'b0110011)? 1'b1: 1'b0;
assign c_767 = (code[7:1] == 7'b0111011)? 1'b1: 1'b0;
assign c_867 = (code[7:1] == 7'b1000011)? 1'b1: 1'b0;
assign c_967 = (code[7:1] == 7'b1001011)? 1'b1: 1'b0;
assign c_a67 = (code[7:1] == 7'b1010011)? 1'b1: 1'b0;
assign c_b67 = (code[7:1] == 7'b1011011)? 1'b1: 1'b0;
assign c_c67 = (code[7:1] == 7'b1100011)? 1'b1: 1'b0;
assign c_d67 = (code[7:1] == 7'b1101011)? 1'b1: 1'b0;
assign c_e67 = (code[7:1] == 7'b1110011)? 1'b1: 1'b0;
assign c_f67 = (code[7:1] == 7'b1111011)? 1'b1: 1'b0;
assign c_e23 = (code[7:1] == 7'b1110001)? 1'b1: 1'b0;
assign c_f23 = (code[7:1] == 7'b1111001)? 1'b1: 1'b0;
//"i&j&k" format instruction set
assign c_00 = (code == 8'b00000000)? 1'b1: 1'b0;
assign c_02 = (code == 8'b00000010)? 1'b1: 1'b0;
assign c_03 = (code == 8'b00000011)? 1'b1: 1'b0;
assign c_04 = (code == 8'b00000100)? 1'b1: 1'b0;
assign c_05 = (code == 8'b00000101)? 1'b1: 1'b0;
assign c_10 = (code == 8'b00010000)? 1'b1: 1'b0;
assign c_12 = (code == 8'b00010010)? 1'b1: 1'b0;
assign c_13 = (code == 8'b00010011)? 1'b1: 1'b0;
assign c_14 = (code == 8'b00010100)? 1'b1: 1'b0;
assign c_15 = (code == 8'b00010101)? 1'b1: 1'b0;
assign c_20 = (code == 8'b00100000)? 1'b1: 1'b0;
assign c_22 = (code == 8'b00100010)? 1'b1: 1'b0;
assign c_23 = (code == 8'b00100011)? 1'b1: 1'b0;
assign c_24 = (code == 8'b00100100)? 1'b1: 1'b0;
assign c_25 = (code == 8'b00100101)? 1'b1: 1'b0;
assign c_30 = (code == 8'b00110000)? 1'b1: 1'b0;
assign c_32 = (code == 8'b00110010)? 1'b1: 1'b0;
assign c_33 = (code == 8'b00110011)? 1'b1: 1'b0;
assign c_34 = (code == 8'b00110100)? 1'b1: 1'b0;
assign c_35 = (code == 8'b00110101)? 1'b1: 1'b0;
assign c_40 = (code == 8'b01000000)? 1'b1: 1'b0;
assign c_42 = (code == 8'b01000010)? 1'b1: 1'b0;
assign c_43 = (code == 8'b01000011)? 1'b1: 1'b0;
assign c_44 = (code == 8'b01000100)? 1'b1: 1'b0;
assign c_45 = (code == 8'b01000101)? 1'b1: 1'b0;
assign c_50 = (code == 8'b01010000)? 1'b1: 1'b0;
assign c_52 = (code == 8'b01010010)? 1'b1: 1'b0;
assign c_53 = (code == 8'b01010011)? 1'b1: 1'b0;
assign c_54 = (code == 8'b01010100)? 1'b1: 1'b0;
assign c_55 = (code == 8'b01010101)? 1'b1: 1'b0;
assign c_60 = (code == 8'b01100000)? 1'b1: 1'b0;
assign c_62 = (code == 8'b01100010)? 1'b1: 1'b0;
assign c_63 = (code == 8'b01100011)? 1'b1: 1'b0;
assign c_64 = (code == 8'b01100100)? 1'b1: 1'b0;
assign c_65 = (code == 8'b01100101)? 1'b1: 1'b0;
assign c_70 = (code == 8'b01110000)? 1'b1: 1'b0;
assign c_72 = (code == 8'b01110010)? 1'b1: 1'b0;
assign c_73 = (code == 8'b01110011)? 1'b1: 1'b0;
assign c_74 = (code == 8'b01110100)? 1'b1: 1'b0; 
assign c_75 = (code == 8'b01110101)? 1'b1: 1'b0;
assign c_80 = (code == 8'b10000000)? 1'b1: 1'b0;
assign c_82 = (code == 8'b10000010)? 1'b1: 1'b0;
assign c_83 = (code == 8'b10000011)? 1'b1: 1'b0;
assign c_84 = (code == 8'b10000100)? 1'b1: 1'b0;
assign c_85 = (code == 8'b10000101)? 1'b1: 1'b0;
assign c_90 = (code == 8'b10010000)? 1'b1: 1'b0;
assign c_92 = (code == 8'b10010010)? 1'b1: 1'b0;
assign c_93 = (code == 8'b10010011)? 1'b1: 1'b0;
assign c_94 = (code == 8'b10010100)? 1'b1: 1'b0;
assign c_95 = (code == 8'b10010101)? 1'b1: 1'b0;
assign c_a0 = (code == 8'b10100000)? 1'b1: 1'b0;
assign c_a2 = (code == 8'b10100010)? 1'b1: 1'b0;
assign c_a3 = (code == 8'b10100011)? 1'b1: 1'b0;
assign c_a4 = (code == 8'b10100100)? 1'b1: 1'b0;
assign c_a5 = (code == 8'b10101010)? 1'b1: 1'b0;
assign c_b0 = (code == 8'b10110000)? 1'b1: 1'b0;
assign c_b2 = (code == 8'b10110010)? 1'b1: 1'b0;
assign c_b3 = (code == 8'b10110011)? 1'b1: 1'b0;
assign c_b4 = (code == 8'b10110100)? 1'b1: 1'b0;
assign c_b5 = (code == 8'b10110101)? 1'b1: 1'b0;
assign c_c0 = (code == 8'b11000000)? 1'b1: 1'b0;
assign c_c2 = (code == 8'b11000010)? 1'b1: 1'b0;
assign c_c3 = (code == 8'b11000011)? 1'b1: 1'b0;
assign c_c4 = (code == 8'b11000100)? 1'b1: 1'b0;
assign c_c5 = (code == 8'b11000101)? 1'b1: 1'b0;
assign c_d0 = (code == 8'b11010000)? 1'b1: 1'b0;
assign c_d2 = (code == 8'b11010010)? 1'b1: 1'b0;
assign c_d3 = (code == 8'b11010011)? 1'b1: 1'b0;
assign c_d4 = (code == 8'b11010100)? 1'b1: 1'b0;
assign c_d5 = (code == 8'b11010101)? 1'b1: 1'b0;
assign c_e0 = (code == 8'b11100000)? 1'b1: 1'b0;
assign c_e4 = (code == 8'b11100100)? 1'b1: 1'b0;
assign c_e5 = (code == 8'b11100101)? 1'b1: 1'b0;
assign c_f0 = (code == 8'b11110000)? 1'b1: 1'b0;
assign c_f4 = (code == 8'b11110100)? 1'b1: 1'b0;
assign c_f5 = (code == 8'b11110101)? 1'b1: 1'b0;
//"l" format instruction set
assign c_01_e1 = (code[4:0] == 5'b00001)? 
		1'b1: 1'b0;
assign c_11_f1 = (code[4:0] == 5'b10001)? 
		1'b1: 1'b0;

/*----------------------------------------------
--                                            --
-- control signal                             --
--                                            --
----------------------------------------------*/
assign ld_xrom = 
(t[1] & c_78f)		| 
(t[1] & c_90) 		|
(t[2] & c_90) 		| 
(t[1] & c_e5) 		|
(t[1] & c_a8f)		|  
(t[1] & c_85)           | 
(t[2] & c_85)           |
(t[1] & c_767)          |
(t[1] & c_88f)          |     
(t[2] & c_75) 		| 
(t[1] & c_c5)           |  
(t[1] & c_f5)           | 
(t[1] & c_867)          | 
(t[1] & c_a67)          |  
(t[1] & c_25)           | 
(t[1] & c_35)           | 
(t[1] & c_45)           | 
(t[1] & c_55)           | 
(t[1] & c_65)           | 
(t[1] & c_95)           | 
(t[1] & c_05)           |  
(t[1] & c_15)           |  
(t[1] & c_42)           | 
(t[1] & c_52)           | 
(t[1] & c_62)           | 
(t[1] & c_43)           |  
(t[1] & c_53)           |  
(t[1] & c_63)           |  
(t[1] & c_72)           |  
(t[1] & c_82)           |  
(t[1] & c_92)           |  
(t[1] & c_a2)           |  
(t[1] & c_b2)           |  
(t[1] & c_c2)           |  
(t[1] & c_d2)           |  
(t[1] & c_a0)           |  
(t[1] & c_b0)           |   
(t[1] & c_c0)           |   
(t[1] & c_d0)           |
(t[1] & c_11_f1)        |     
(t[1] & c_12)           |   
(t[1] & c_02)		| 
(t[1] & c_80)		| 
(t[1] & c_60) 		|
(t[1] & c_70)		|
(t[1] & c_40)		|		 
(t[1] & c_50)		|		 		 
(t[1] & c_20)		|	 		 
(t[2] & c_20)		| 		 
(t[1] & c_30)		|	 		 
(t[2] & c_30)		| 		 
(t[2] & c_10)		|		  		 
(t[2] & c_b5) 		| 
(t[2] & c_b4)		| 	 		 
(t[2] & c_b8f)		| 	 		 
(t[2] & c_b67)		| 	 		 
(t[1] & c_d8f)		|		 
(t[2] & c_d5)		 
;
assign  ld_operand2 =     
(t[1] & c_75) 		| 
(t[1] & c_10)		|	 		 
(t[1] & c_b5)		| 	 		 
(t[1] & c_b4)	        |	 	 		 
(t[1] & c_b8f)		| 	 		 
(t[1] & c_b67)		|		 	 		 
(t[1] & c_d5)		 	 		 
;
assign ld_idat =
(t[2] & c_a8f & !msb_a) |  
(t[2] & c_85 & !msb_a)  |   
(t[1] & c_f67)          |  
(t[1] & c_e67)          |   
(t[1] & c_767)          | 
(t[1] & c_88f)          |    
(t[1] & c_c8f)          | 
(t[2] & c_c5 & !msb_a)  |
(t[1] & c_c67)          |     
(t[1] & c_d67)          |   
(t[1] & c_867)          |     
(t[2] & c_867)          |    
(t[1] & c_a67)          | 
(t[2] & c_a67 & !msb_a) | 
(t[1] & c_267)          |  
(t[1] & c_367)          |  
(t[1] & c_467)          |  
(t[1] & c_567)          |  
(t[1] & c_667)          |  
(t[1] & c_967)          |  
(t[1] & c_067)          |  
(t[1] & c_167)          |  
(t[2] & c_b2 & !msb_a)  | 
(t[2] & c_c2 & !msb_a)  | 
(t[2] & c_d2 & !msb_a)  |  
(t[2] & c_92 & !msb_a)  |  
(t[2] & c_72 & !msb_a)  |  
(t[2] & c_82 & !msb_a)  |  
(t[2] & c_a0 & !msb_a)  |  
(t[2] & c_b0 & !msb_a)  |  
(t[2] & c_a2 & !msb_a)  |
(t[1] & c_e23)          | 
(t[1] & c_f23)          | 
(t[2] & c_c0 & !msb_a)  |  
(t[1] & c_d0 & !msb_a)  | 
(t[2] & c_10 & !msb_a)  |  
(t[2] & c_b5 & !msb_a)  | 
(t[1] & c_b8f)  	| 	   
(t[1] & c_b67) 		|  	   
(t[2] & c_b67)   	   
;
assign ld_sfr =
(t[2] & c_a8f & msb_a)  |  
(t[2] & c_85 & msb_a)   | 
(t[2] & c_c5 & msb_a)   | 
(t[2] & c_a67 & msb_a)  |  
(t[2] & c_b2 & msb_a)   | 
(t[2] & c_c2 & msb_a)   | 
(t[2] & c_d2 & msb_a)   |  
(t[2] & c_92 & msb_a)   |  
(t[2] & c_72 & msb_a)   |  
(t[2] & c_82 & msb_a)   |  
(t[2] & c_a0 & msb_a)   |  
(t[2] & c_b0 & msb_a)   |  
(t[2] & c_a2 & msb_a)   |  
(t[2] & c_c0 & msb_a)   | 
(t[1] & c_d0 & msb_a)  	| 
(t[2] & c_10 & msb_a)   |  
(t[2] & c_b5 & msb_a)  
;
assign sel_code_xdat =
~(
c_e23                   |
c_e0                    |
c_f23                   |
c_f0
)
;
assign sel_addr0 =  
(t[2] & c_78f)          | 
(t[1] & c_f8f)          |
(t[1] & c_e8f)          |
(t[3] & c_a8f)          |
(t[1] & c_f67)          |  
(t[1] & c_e67)          |  
(t[1] & c_767)          |  
(t[1] & c_88f)          |     
(t[1] & c_c8f)          | 
(t[2] & c_c8f)          |
(t[1] & c_c67)          |   
(t[1] & c_d67)          | 
(t[1] & c_867)          | 
(t[1] & c_a67)          | 
(t[1] & c_28f)          | 
(t[1] & c_38f)          | 
(t[1] & c_48f)          | 
(t[1] & c_58f)          | 
(t[1] & c_68f)          | 
(t[1] & c_98f)          | 
(t[1] & c_267)          | 
(t[1] & c_367)          | 
(t[1] & c_467)          | 
(t[1] & c_567)          | 
(t[1] & c_667)          | 
(t[1] & c_967)          | 
(t[1] & c_08f)          | 
(t[2] & c_08f)          | 
(t[1] & c_18f)          | 
(t[2] & c_18f)          | 
(t[1] & c_067)          | 
(t[1] & c_167)          |
(t[1] & c_e23)		|
(t[1] & c_b8f)		|   	   
(t[1] & c_b67)   	|   
(t[1] & c_d8f)   	|         
(t[2] & c_d8f)		             
;
assign sel_addr1[0] = 
(t[2] & c_f67)          |
(t[2] & c_e67)          |  
(t[2] & c_767)          |
(t[2] & c_c67)          |    
(t[3] & c_c67)          |  
(t[2] & c_d67)          |    
(t[3] & c_d67)          |   
(t[2] & c_867)          |    
(t[3] & c_a67)          |  
(t[2] & c_267)          |  
(t[2] & c_367)          |  
(t[2] & c_467)          |  
(t[2] & c_567)          |  
(t[2] & c_667)          |  
(t[2] & c_967)          |   
(t[2] & c_067)          |   
(t[3] & c_067)          |   
(t[2] & c_167)          |   
(t[3] & c_167)   	| 
(t[2] & c_b67) 		   	   
;  
assign sel_addr1[1] = 
(t[3] & c_c0)           |   
(t[1] & c_d0)           |   
(t[2] & c_d0)           |
(t[2] & c_11_f1)        |   
(t[3] & c_11_f1)        |   
(t[2] & c_12)           |   
(t[3] & c_12)           |  
it[2]                   |
it[3]                   | 
(t[1] & c_22)           |  
(t[2] & c_22)           |  
(t[1] & c_32)           |   
(t[2] & c_32)  		   
; 
assign sel_addr1[2] = 
(t[3] & c_75)           | 
(t[3] & c_a67)		|  
(t[2] & c_10) 		| // read  bitdat 
(t[3] & c_10) 		| // write bitdat 
(t[2] & c_b5) 		|                  
(t[2] & c_d5)      	|      
(t[3] & c_d5)            
; 
assign ld_pc =  
(t[3] & c_11_f1)        |
(t[2] & c_12)           | 
it[3]             	| 
(t[1] & c_01_e1)        |
(t[2] & c_02) 		| 
(t[2] & c_80)		|  		  
(t[1] & c_73)  	    	|
(t[2] & (out_acc_r == 8'd0) & c_60) 	 | 
(t[2] & (out_acc_r != 8'd0) & c_70) 	 | 
(t[2] & cy_psw & c_40)			 |
(t[2] & !cy_psw & c_50) 		 |
(t[3] & bit_dat_in_r & c_20)	    	 |
(t[3] & bit_dat_in_r & c_10)		 |
(t[3] & !bit_dat_in_r & c_30)		 | 
(t[3] & (out_acc_r != combus) & c_b5)    |
(t[3] & (out_acc_r != in_xrom1_r) & c_b4)| 
(t[3] & (combus != in_xrom1_r) & c_b8f)  |
(t[3] & (combus != in_xrom1_r) & c_b67)  |
(t[2] & (combus != 8'd0) & c_d8f)	 |
(t[3] & (combus != 8'd0) & c_d5)   
;
assign ld_pcl =  
(t[2] & c_22)           |     
(t[2] & c_32)      
;
assign ld_pch = 
(t[1] & c_22)           |     
(t[1] & c_32)      
;
assign ld_acc =  
(t[1] & c_74)           |
(t[1] & c_e8f)          |
(t[2] & c_e5)           |  
(t[2] & c_e67)          |  
(t[3] & c_c8f)          |
(t[2] & c_c5)           |  
(t[2] & c_c67)          | 
(t[1] & c_28f)          | 
(t[1] & c_38f)          | 
(t[1] & c_48f)          | 
(t[1] & c_58f)          | 
(t[1] & c_68f)          | 
(t[1] & c_98f)          |  
(t[2] & c_25)           | 
(t[2] & c_35)           | 
(t[2] & c_45)           | 
(t[2] & c_55)           | 
(t[2] & c_65)           | 
(t[2] & c_95)           |  
(t[2] & c_267)          |   
(t[2] & c_367)          |   
(t[2] & c_467)          |   
(t[2] & c_567)          |   
(t[2] & c_667)          |   
(t[2] & c_967)          | 
(t[1] & c_24)           |    
(t[1] & c_34)           |    
(t[1] & c_44)           |    
(t[1] & c_54)           |    
(t[1] & c_64)           |    
(t[1] & c_94)           |    
(t[1] & c_04)           |    
(t[1] & c_14)           |    
(t[1] & c_d4)           | 
(t[1] & c_e4)           |  
(t[1] & c_f4)           |
(t[1] & c_23)           |  
(t[1] & c_33)           |  
(t[1] & c_03)           |  
(t[1] & c_13)           |  
(t[1] & c_c4)           | 
(t[1] & c_a4)           | 
(t[1] & c_84)		|
(t[2] & c_93)           |   
(t[2] & c_83)           |
(t[3] & c_e23)          |
(t[3] & c_e0)       
;
assign ld_acc_chd = 
(t[2] & c_d67)
;  
assign sel_combus[0] =   
(t[1] & c_e8f)          |
(t[2] & c_e5 & msb_a)   |  
(t[2] & c_e5 & !msb_a)  |
(t[3] & c_85 & msb_r)   |     
(t[3] & c_a8f & msb_r)  |
(t[3] & c_35 & msb_r)   |   
(t[2] & c_e67)          |   
(t[2] & c_c5 & !msb_a)  |  
(t[2] & c_c5 & msb_a)   | 
(t[3] & c_c5)           | 
(t[2] & c_c67)          |     
(t[3] & c_c67)          |     
(t[2] & c_d67)          |      
(t[3] & c_a67 & msb_r)  |  
(t[1] & c_28f)          | 
(t[1] & c_38f)          |  
(t[1] & c_48f)          | 
(t[1] & c_58f)          | 
(t[1] & c_68f)          | 
(t[1] & c_98f)          | 
(t[2] & c_25)           | 
(t[2] & c_35)           | 
(t[2] & c_45)           | 
(t[2] & c_55)           | 
(t[2] & c_65)           | 
(t[2] & c_95)           | 
(t[2] & c_267)          |  
(t[2] & c_367)          |  
(t[2] & c_467)          |  
(t[2] & c_567)          |  
(t[2] & c_667)          |  
(t[2] & c_967)          |   
(t[1] & c_24)           | 
(t[1] & c_34)           | 
(t[1] & c_44)           | 
(t[1] & c_54)           | 
(t[1] & c_64)           | 
(t[1] & c_94)           | 
(t[1] & c_04)           |    
(t[1] & c_14)           |    
(t[1] & c_d4)           | 
(t[1] & c_e4)           | 
(t[1] & c_f4)           | 
(t[1] & c_23)           |  
(t[1] & c_33)           |  
(t[1] & c_03)           | 
(t[1] & c_13)           |  
(t[1] & c_c4)           |    
(t[1] & c_a4)           |   
(t[1] & c_84)          |  
(t[3] & c_b2 & msb_a)   | 
(t[3] & c_c2 & msb_a)   | 
(t[3] & c_d2 & msb_a)   |   
(t[3] & c_92 & msb_a)   |   
(t[3] & c_72 & msb_a)   |  
(t[3] & c_82 & msb_a)   |  
(t[3] & c_a0 & msb_a)   |  
(t[3] & c_b0 & msb_a)   |  
(t[3] & c_a2 & msb_a)   | 
(t[3] & c_c0 & msb_r)   |   
(t[3] & c_d0 & msb_r)   | 
(t[2] & c_11_f1)        | 
(t[2] & c_12)           | 
it[2]                   | 
(t[1] & c_22 & !msb_a)	|    
(t[1] & c_22 & msb_a) 	|  
(t[2] & c_22 & !msb_a)	|    
(t[2] & c_22 & msb_a)   | 
(t[1] & c_32 & !msb_a)	|    
(t[1] & c_32 & msb_a) 	|  
(t[2] & c_32 & !msb_a)	|    
(t[2] & c_32 & msb_a)   |	     
(t[3] & c_b5 & msb_r)     
;
assign sel_combus[1] = 
(t[1] & c_74) 		| 
(t[2] & c_78f) 		|
(t[2] & c_90) 		| 
(t[3] & c_90) 		| 
(t[2] & c_e5 & msb_a) 	| 
(t[2] & c_767) 		|   
(t[3] & c_75) 		| 
(t[2] & c_c5 & msb_a) 	| 
(t[3] & c_c5) 		|   
(t[2] & c_d67) 		|    
(t[3] & c_c67) 		|
(t[1] & c_83) 		|
(t[3] & c_e23) 		|
(t[3] & c_e0) 		|     
(t[2] & c_11_f1)        | 
(t[2] & c_12)           | 
it[2] 			| 
(t[1] & c_22 & msb_a)   | 
(t[2] & c_22 & msb_a)   | 
(t[1] & c_32 & msb_a)   | 
(t[2] & c_32 & msb_a)   | 
(t[2] & c_93)		|             
(t[2] & c_83)             
;
assign sel_combus[2] =       
(t[3] & c_a8f & !msb_r) |  
(t[3] & c_a8f & msb_r)  |   
(t[3] & c_85 & !msb_r)  |  
(t[3] & c_85 & msb_r)   |     
(t[2] & c_88f)          |    
(t[3] & c_c8f)          |  
(t[3] & c_c5)           |   
(t[2] & c_d67)          |    
(t[3] & c_c67)          |      
(t[3] & c_867)          |  
(t[3] & c_a67 & msb_r)  | 
(t[3] & c_a67 & !msb_r) |   
(t[3] & c_b2 & msb_a)   | 
(t[3] & c_c2 & msb_a)   | 
(t[3] & c_d2 & msb_a)   |    
(t[3] & c_92 & msb_a)   |    
(t[3] & c_72 & msb_a)   |  
(t[3] & c_82 & msb_a)   |  
(t[3] & c_a0 & msb_a)   |  
(t[3] & c_b0 & msb_a)   |  
(t[3] & c_a2 & !msb_a)  | 
(t[3] & c_c2 & !msb_a)  | 
(t[3] & c_d2 & !msb_a)  |   
(t[3] & c_92 & !msb_a)  |   
(t[3] & c_72 & !msb_a)  |   
(t[3] & c_82 & !msb_a)  |   
(t[3] & c_a0 & !msb_a)  |   
(t[3] & c_b0 & !msb_a)  |   
(t[3] & c_a2 & !msb_a)  | 
(t[3] & c_e23)          |
(t[3] & c_e0)           |         
(t[3] & c_c0 & msb_r)   | 
(t[3] & c_c0 & !msb_r)  |  
(t[3] & c_d0 & msb_r)   | 
(t[3] & c_d0 & !msb_r)  | 
(t[3] & c_11_f1)        | 
(t[3] & c_12) 		| 
it[3] 		 	|	   
(t[3] & c_b5 & !msb_r)  |     
(t[3] & c_b5 & msb_r)	|     
(t[3] & c_b8f) 		|  	   
(t[3] & c_b67)   	   
; 
assign sel_combus[3] = 
(t[1] & c_74)           | 
(t[3] & c_d67)          |      
(t[1] & c_28f)          | 
(t[1] & c_38f)          | 
(t[1] & c_48f)          | 
(t[1] & c_58f)          | 
(t[1] & c_68f)          | 
(t[1] & c_98f)          |   
(t[2] & c_25)           |   
(t[2] & c_35)           |   
(t[2] & c_45)           |   
(t[2] & c_55)           |   
(t[2] & c_65)           |   
(t[2] & c_95)           |    
(t[2] & c_267)          |   
(t[2] & c_367)          |  
(t[2] & c_467)          |  
(t[2] & c_567)          |  
(t[2] & c_667)          |  
(t[2] & c_967)          |  
(t[1] & c_24)           | 
(t[1] & c_34)           | 
(t[1] & c_44)           | 
(t[1] & c_54)           | 
(t[1] & c_64)           | 
(t[1] & c_94)           |  
(t[1] & c_04)           |    
(t[1] & c_14)           |    
(t[1] & c_d4)           | 
(t[1] & c_e4)           | 
(t[1] & c_f4)           | 
(t[1] & c_23)           |  
(t[1] & c_33)           |  
(t[1] & c_03)           | 
(t[1] & c_13)           | 
(t[1] & c_c4)           | 
(t[2] & c_08f)		|      
(t[2] & c_18f) 		|      
(t[3] & c_05)           |      
(t[3] & c_15)           |       
(t[3] & c_067)          |       
(t[3] & c_167)          |      
(t[3] & c_42)           |  
(t[3] & c_52)           |  
(t[3] & c_62)           |  
(t[3] & c_43)           |  
(t[3] & c_53)           |  
(t[3] & c_63)           |  
(t[1] & c_a4)           |   
(t[1] & c_84)		|  
(t[1] & c_83) 		| 
(t[2] & c_11_f1) 	| 
(t[3] & c_11_f1) 	| 
(t[2] & c_12) 		| 
(t[3] & c_12) 		| 
it[2] 			|
it[3]			|   
(t[2] & c_93)		|	             
(t[2] & c_83)           |  
(t[2] & c_d8f) 		|       
(t[3] & c_d5)                   
;
assign wr_idat  = 
(t[2] & c_78f)          |  
(t[1] & c_f8f)          | 
(t[3] & c_a8f & !msb_a) |   
(t[3] & c_e5 & !msb_a)  | 
(t[3] & c_85 & !msb_a)  |    
(t[2] & c_f67)          | 
(t[2] & c_767)          | 
(t[2] & c_88f & !msb_a) |     
(t[2] & c_c8f) 		| 
(t[3] & c_75 & !msb_a)  |  
(t[3] & c_c5 & !msb_a)  | 
(t[3] & c_c67)          |      
(t[3] & c_d67)          |   
(t[2] & c_f5 & !msb_a)  |  
(t[3] & c_867 & !msb_a) |     
(t[3] & c_a67)          | 
(t[2] & c_08f)          |      
(t[2] & c_18f)          |     
(t[3] & c_05 & !msb_a)  |      
(t[3] & c_15 & !msb_a)  |     
(t[3] & c_067)          |       
(t[3] & c_167)          |      
(t[3] & c_42 & !msb_a)  |       
(t[3] & c_52 & !msb_a)  |      
(t[3] & c_62 & !msb_a)  |      
(t[3] & c_43 & !msb_a)  |      
(t[3] & c_53 & !msb_a)  |      
(t[3] & c_63 & !msb_a)  |      
(t[3] & c_b2 & !msb_a)  | 
(t[3] & c_c2 & !msb_a)  | 
(t[3] & c_d2 & !msb_a)  |   
(t[3] & c_92 & !msb_a)  |   
(t[3] & c_c0 & !msb_a)  | 
(t[3] & c_d0 & !msb_a)  | 
(t[2] & c_11_f1 & !msb_a)| 
(t[3] & c_11_f1 & !msb_a)| 
(t[2] & c_12 & !msb_a)  | 
(t[3] & c_12 & !msb_a)  | 
(it[2] & !msb_a)        |
(it[3] & !msb_a) 	| 
(t[3] & c_10 & !msb_r)  |  
(t[2] & c_d8f)  	|              
(t[3] & c_d5 & !msb_a)        
;
assign wr_sfr =  
(t[3] & c_a8f & msb_a)  |   
(t[3] & c_85 & msb_a)   |  
(t[2] & c_88f & msb_a)  |    
(t[3] & c_75 & msb_a)   | 
(t[3] & c_c5 & msb_a)   |  
(t[2] & c_f5 & msb_a)   | 
(t[3] & c_867 & msb_a)  |     
(t[3] & c_05 & msb_a)   |     
(t[3] & c_15 & msb_a)   |     
(t[3] & c_42 & msb_a)   |      
(t[3] & c_52 & msb_a)   |      
(t[3] & c_62 & msb_a)   |      
(t[3] & c_43 & msb_a)   |       
(t[3] & c_53 & msb_a)   |      
(t[3] & c_63 & msb_a)   |      
(t[3] & c_b2 & msb_a)   | 
(t[3] & c_c2 & msb_a)   | 
(t[3] & c_d2 & msb_a)   |   
(t[3] & c_92 & msb_a)   |   
(t[3] & c_c0 & msb_a)   |  
(t[3] & c_d0 & msb_a)   |  
(t[2] & c_11_f1 & msb_a)| 
(t[3] & c_11_f1 & msb_a)| 
(t[2] & c_12 & msb_a)   | 
(t[3] & c_12 & msb_a)   | 
(it[2] & msb_a)         |
(it[3] & msb_a) 	| 
(t[3] & c_10 & msb_r)   |  
(t[3] & c_d5 & msb_a)         
;
assign rd_idat =      
(t[1] & c_e8f)          |
(t[1] & c_e5 & !msb_a)  |
(t[3] & c_e5 & !msb_a)  |          
(t[2] & c_85 & !msb_a)  |  
(t[1] & c_f67)          |   
(t[1] & c_e67)          | 
(t[1] & c_767)          | 
(t[1] & c_88f & !msb_a) |    
(t[2] & c_c8f) 		| 
(t[2] & c_c5 & !msb_a)  |
(t[1] & c_c67)          |     
(t[2] & c_c67)          |     
(t[1] & c_d67)          |   
(t[2] & c_d67)          | 
(t[1] & c_867)          |   
(t[2] & c_867)          |   
(t[1] & c_28f)          | 
(t[1] & c_38f)          | 
(t[1] & c_48f)          | 
(t[1] & c_58f)          | 
(t[1] & c_68f)          | 
(t[1] & c_98f)          | 
(t[2] & c_25 & !msb_a)  | 
(t[2] & c_35 & !msb_a)  | 
(t[2] & c_45 & !msb_a)  | 
(t[2] & c_55 & !msb_a)  | 
(t[2] & c_65 & !msb_a)  | 
(t[2] & c_95 & !msb_a)  | 
(t[1] & c_267)          |   
(t[1] & c_367)          |  
(t[1] & c_467)          |  
(t[1] & c_567)          |  
(t[1] & c_667)          |  
(t[1] & c_967)          |  
(t[1] & c_08f)          |   
(t[1] & c_18f) 		|  
(t[2] & c_05 & !msb_a)  | 
(t[2] & c_15 & !msb_a)  |  
(t[1] & c_067)          | 
(t[1] & c_167)          | 
(t[1] & c_42 & !msb_a)  |  
(t[1] & c_52 & !msb_a)  |  
(t[1] & c_62 & !msb_a)  |    
(t[2] & c_43 & !msb_a)  |   
(t[2] & c_53 & !msb_a)  |   
(t[2] & c_63 & !msb_a)  |    
(t[2] & c_b2 & !msb_a)  |   
(t[2] & c_c2 & !msb_a)  |   
(t[2] & c_d2 & !msb_a)  |   
(t[2] & c_92 & !msb_a)  |   
(t[2] & c_72 & !msb_a)  |   
(t[2] & c_82 & !msb_a)  |   
(t[2] & c_a0 & !msb_a)  |   
(t[2] & c_b0 & !msb_a)  |   
(t[2] & c_a2 & !msb_a)  |
(t[3] & c_e23) 		|        
(t[2] & c_c0 & !msb_a)  | 
(t[1] & c_d0 & !msb_a)  | 
(t[1] & c_22 & !msb_a)  |  
(t[2] & c_22 & !msb_a)  | 
(t[1] & c_32 & !msb_a)  |  
(t[2] & c_32 & !msb_a)  | 
(t[2] & c_20 & !msb_a)	|  
(t[2] & c_10 & !msb_a)	|  
(t[2] & c_30 & !msb_a)  |  
(t[2] & c_b5 & !msb_a) 	| 
(t[1] & c_c8f)          | 
(t[1] & c_c67)          | 
(t[2] & c_c67)          |  
(t[1] & c_d8f) 		|  
(t[2] & c_d5 & !msb_a)     
;
assign inc_pc = 
(t[0] & !en_itcnt) 	|
(t[1] & c_74) 		| 
(t[1] & c_78f) 		| 
(t[1] & c_90)           |
(t[2] & c_90)           | 
(t[2] & c_e5)           | 
(t[3] & c_a8f)   	|
(t[1] & c_85) 		| 
(t[2] & c_85)  		|
(t[1] & c_767)		|  
(t[1] & c_88f)		|    
(t[1] & c_75) 		| 
(t[2] & c_75) 		| 
(t[1] & c_c5) 		|  
(t[1] & c_f5) 		| 
(t[2] & c_867) 		|   
(t[2] & c_a67) 		| 
(t[1] & c_25)           |   
(t[1] & c_35)           |   
(t[1] & c_45)           |   
(t[1] & c_55)           |   
(t[1] & c_65)           |   
(t[1] & c_95)           |     
(t[1] & c_24)           |     
(t[1] & c_34)           |     
(t[1] & c_44)           |     
(t[1] & c_54)           |     
(t[1] & c_64)           |     
(t[1] & c_94)           |    
(t[1] & c_05)           |    
(t[1] & c_15)           |    
(t[1] & c_42)           |    
(t[1] & c_52)           |    
(t[1] & c_62)           |    
(t[1] & c_43)           |  
(t[1] & c_53)           |  
(t[1] & c_63)           |   
(t[2] & c_43)           |   
(t[2] & c_53)           |   
(t[2] & c_63)           |    
(t[1] & c_72)           |    
(t[1] & c_82)           |    
(t[1] & c_92)           |   
(t[1] & c_a2)           |   
(t[1] & c_b2)           |   
(t[1] & c_c2)           |   
(t[1] & c_d2)           |   
(t[1] & c_a0)           |   
(t[1] & c_b0)           |    
(t[1] & c_c0)           |    
(t[1] & c_d0)           |   
(t[1] & c_11_f1)        | 
(t[3] & c_11_f1)        |  
(t[1] & c_12) 		|  
(t[2] & c_12)  		|   
(t[1] & c_01_e1)        |
(t[1] & c_02)		|
(t[1] & c_80)		|	 		  
(t[1] & c_60)		| 		  
(t[1] & c_70)		|		 		 
(t[1] & c_40)		|		  
(t[1] & c_50)		| 		  
(t[1] & c_20)		| 		  
(t[2] & c_20)		|  		  
(t[1] & c_10)		| 		  
(t[2] & c_10)		|  		  
(t[1] & c_30)		| 		  
(t[2] & c_30)		|	  		  
(t[1] & c_b5)		|  		  
(t[2] & c_b5)		|   		  
(t[1] & c_b4)		|  		  
(t[2] & c_b4)		|   		  
(t[1] & c_b8f)		|  		  
(t[2] & c_b8f)		|   		  
(t[1] & c_b67)		|  		  
(t[2] & c_b67)		|   		  
(t[1] & c_d8f)	        |	
(t[1] & c_d5)		| 		 		 
(t[1] & c_d5)  		|              
(t[2] & c_d5)                
;
assign inc_pc2 = 
(t[1] & c_11_f1)    
;
assign inc_pc3 = 
(t[1] & c_12)    
;
assign ld_dpl =    
(t[3] & c_90)  
; 

assign ld_dph =    
(t[2] & c_90) 
;

assign inc_dptr =  
(t[1] & c_a3) 
;

assign ld_instr = 
(t[0] & !en_itcnt);

assign wr_xdat =    
(extend_wr & c_f0) 	|
(extend_wr & c_f23);

assign rd_xdat =       
(extend_rd & c_e0) 	|
(extend_rd & c_e23);

assign ale =  
(t[1] & c_f23)          |
(t[1] & c_e23)          |
(t[1] & c_f0)		|
(t[1] & c_e0)  
; 
assign sel_xad = 
(t[2] & c_f23)          |
(t[2] & c_e23)          |
(t[2] & c_f0) 		|
(t[2] & c_e0)
;
assign sel_xaddr_low =  
(t[2] & c_e0) 		|
(t[2] & c_f0)
; 
assign sel_xaddr_high =  
(extend_mux & c_e0) 	|
(extend_mux & c_f0) 	|
(extend_mux & c_f23) 	|  
(extend_mux & c_e23)
;
assign inc_sp =
it[0] 			|
it[2] 			|
(t[1] & c_c0) 		|  
(t[1] & c_11_f1) 	|
(t[2] & c_11_f1)	| 
(t[1] & c_12)   	| 
(t[2] & c_12) 
;
assign dec_sp = 
(t[3] & c_d0)           |   
(t[1] & c_22)           |  
(t[2] & c_22)           |  
(t[1] & c_32)           |  
(t[2] & c_32)   
;
assign ld_latch_acc = 
(t[1] & c_c5) 		| 
(t[1] & c_c67)		|      
(t[1] & c_d67)    
;
assign set_c = 
(t[1] & cy & c_28f)     |
(t[1] & cy & c_38f)     |
(t[1] & cy & c_98f)     |
(t[2] & cy & c_25)      |
(t[2] & cy & c_35)      |
(t[2] & cy & c_95)      |
(t[2] & cy & c_267)     |
(t[2] & cy & c_367)     |
(t[2] & cy & c_967)     | 
(t[1] & cy & c_24)      |
(t[1] & cy & c_34)      |
(t[1] & cy & c_94)      |
(t[1] & cy & c_d4)      |
(t[1] & cy & c_33)      |
(t[1] & cy & c_13)      |
(t[1] & cy & c_a4)      |
(t[1] & c_d3)  		|
(t[3] & c_b5 & (out_acc_r < combus))     |
(t[3] & c_b4 & (out_acc_r < in_xrom1_r)) |
(t[3] & c_b8f & (combus < in_xrom1_r))   |
(t[3] & c_b67 & (combus < in_xrom1_r))  
;
assign rst_c = 
(t[1] & !cy & c_28f)    |
(t[1] & !cy & c_38f)    |
(t[1] & !cy & c_98f)    |
(t[2] & !cy & c_25)     |
(t[2] & !cy & c_35)     |
(t[2] & !cy & c_95)     |
(t[2] & !cy & c_267)    |
(t[2] & !cy & c_367)    |
(t[2] & !cy & c_967)    |
(t[1] & !cy & c_24)     |
(t[1] & !cy & c_34)     |
(t[1] & !cy & c_94)     |
(t[1] & !cy & c_d4)     | 
(t[1] & !cy & c_33)     | 
(t[1] & !cy & c_13)     |
(t[1] & !cy & c_a4)     |
(t[1] & c_c3)  		|
(t[3] & c_b5 & (out_acc_r >= combus)) 	  |
(t[3] & c_b4 & (out_acc_r >= in_xrom1_r)) |
(t[3] & c_b8f & (combus >= in_xrom1_r))   |
(t[3] & c_b67 & (combus >= in_xrom1_r))  
;  
assign cpl_c =   
(t[1] & c_b3)
; 
assign ld_c = 
(t[3] & c_72)           |
(t[3] & c_a0)           |
(t[3] & c_82)           |
(t[3] & c_b0)           |
(t[3] & c_a2)  
;
assign set_ac = 
(t[1] & ac & c_28f)     |
(t[1] & ac & c_38f)     |
(t[1] & ac & c_98f)     |
(t[2] & ac & c_25)      |
(t[2] & ac & c_35)      |
(t[2] & ac & c_95)      |
(t[2] & ac & c_267)     |
(t[2] & ac & c_367)     |
(t[2] & ac & c_967)     |  
(t[1] & ac & c_24)      |
(t[1] & ac & c_34)      |
(t[1] & ac & c_94)  
;
assign rst_ac = 
(t[1] & !ac & c_28f)    |
(t[1] & !ac & c_38f)    |
(t[1] & !ac & c_98f)    |
(t[2] & !ac & c_25)     |
(t[2] & !ac & c_35)     |
(t[2] & !ac & c_95)     |
(t[2] & !ac & c_267)    |
(t[2] & !ac & c_367)    |
(t[2] & !ac & c_967)    |
(t[1] & !ac & c_24)     |
(t[1] & !ac & c_34)     |
(t[1] & !ac & c_94)  
;
assign set_v = 
(t[1] & ov & c_28f)     |
(t[1] & ov & c_38f)     |
(t[1] & ov & c_98f)     |
(t[2] & ov & c_25)      |
(t[2] & ov & c_35)      |
(t[2] & ov & c_95)      |
(t[2] & ov & c_267)     |
(t[2] & ov & c_367)     |
(t[2] & ov & c_967)     |
(t[1] & ov & c_24)      |
(t[1] & ov & c_34)      |
(t[1] & ov & c_94)      | 
(t[1] & ov & c_84)      |
(t[1] & ov & c_a4)   
;
assign rst_v =  
(t[1] & !ov & c_28f)    |
(t[1] & !ov & c_38f)    |
(t[1] & !ov & c_98f)    |
(t[2] & !ov & c_25)     |
(t[2] & !ov & c_35)     |
(t[2] & !ov & c_95)     |
(t[2] & !ov & c_267)    |
(t[2] & !ov & c_367)    |
(t[2] & !ov & c_967)    |
(t[1] & !ov & c_24)     |
(t[1] & !ov & c_34)     |
(t[1] & !ov & c_94)     |
(t[1] & !ov & c_84)     |
(t[1] & !ov & c_a4)    
;  
assign sel_op1[0] = 
(t[2] & c_05 & msb_a)   | 
(t[2] & c_15 & msb_a)   |  
(t[2] & c_43)           |  
(t[2] & c_53)           |  
(t[2] & c_63)  		| 
(t[2] & c_d5 & msb_a)      
;   
assign sel_op1[1] =  
(t[2] & c_05 & msb_a)	| 
(t[2] & c_15 & msb_a)	|   
(t[2] & c_d5 & msb_a)   
;  
assign sel_op1[2] = 
(t[1] & c_08f)          | 
(t[1] & c_18f)          | 
(t[2] & c_05 & !msb_a)  | 
(t[2] & c_15 & !msb_a)  | 
(t[2] & c_067) 		|  
(t[2] & c_167)		|
(t[1] & c_d8f)		|            
(t[2] & c_d5 & !msb_a)    
;
assign sel_op2[0] =  
(t[1] & c_24)           |  
(t[1] & c_34)           |  
(t[1] & c_44)           |  
(t[1] & c_54)           |  
(t[1] & c_64)           |  
(t[1] & c_94)     
;
assign sel_op2[1] =   
(t[2] & c_25 & msb_a)   | 
(t[2] & c_35 & msb_a)   | 
(t[2] & c_45 & msb_a)   | 
(t[2] & c_55 & msb_a)   | 
(t[2] & c_65 & msb_a)   | 
(t[2] & c_95 & msb_a)   |  
(t[1] & c_24)           | 
(t[1] & c_34)           |  
(t[1] & c_44)           |  
(t[1] & c_54)           |  
(t[1] & c_64)           |  
(t[1] & c_94)           |
(t[2] & c_42 & msb_a)   | 
(t[2] & c_52 & msb_a)   | 
(t[2] & c_62 & msb_a)   |  
(t[2] & c_43 & msb_a)   |  
(t[2] & c_53 & msb_a)   |  
(t[2] & c_63 & msb_a)   
;
assign sel_op2[2] =    
(t[1] & c_84) 		|
(t[1] & c_a4) 
;  
assign ld_b = 
(t[1] & c_84) 		|
(t[1] & c_a4) 
;
assign en_div = 
(t[1] & c_84) 
;  
assign sel_pc[0] = 
(t[2] & c_12)  		| 
(t[1] & c_22)  		|  
(t[1] & c_32) 		| 
(t[2] & c_02)		| 
(t[1] & c_73) 		  
;
assign sel_pc[1] = 
it[3] 			| 
(t[1] & c_22)   	| 
(t[2] & c_22)   	| 
(t[1] & c_32)   	| 
(t[2] & c_32) 		   
; 
assign sel_pc[2] = 
it[3] 			|
(t[2] & c_80)    	|		  
(t[1] & c_73) 		|		  
(t[2] & c_60)		| 		  
(t[2] & c_70)		|  		  
(t[2] & c_40)		|	  		  
(t[2] & c_50)		|	  		  
(t[3] & c_50)		| 		  
(t[3] & c_20)		|            
(t[3] & c_10)		|            
(t[3] & c_30)		|            
(t[3] & c_b5)		|            
(t[3] & c_b4)		|            
(t[3] & c_b8f)		|            
(t[3] & c_b67)  	|          
(t[2] & c_d8f)	        |	   		  
(t[3] & c_d5)		   		  
; 
assign sel_page_addr =  
(t[1] & c_01_e1) 
;  
assign bit_addr =  
(t[2] & c_10)           |
(t[3] & c_10)           |
(t[2] & c_20)           |
(t[3] & c_20)           |
(t[2] & c_30)           |
(t[3] & c_30)           |
(t[2] & c_72)           |
(t[2] & c_82)           |
(t[2] & c_92)           |
(t[2] & c_a2)           |
(t[2] & c_b2)           |
(t[2] & c_c2)           |
(t[2] & c_d2)           |
(t[2] & c_a0)           |
(t[2] & c_b0)           |
(t[3] & c_72)           |
(t[3] & c_82)           |
(t[3] & c_92)           |
(t[3] & c_a2)           |
(t[3] & c_b2)           |
(t[3] & c_c2)           |
(t[3] & c_d2)           |
(t[3] & c_a0)           |
(t[3] & c_b0)  
;
assign rmw =
c_05                    |
c_10                    |
c_15                    |
c_42                    |
c_43                    |
c_52                    |
c_53                    |
c_62                    |
c_63                    |
c_92                    |
c_b2                    |
c_c2                    |
c_d2                    |
c_d5 
;
assign start_int_svr = 
(it[3] & en_itcnt)
;
assign ld_adptr =
(t[2] & c_93)
;
assign ld_apc =
(t[2] & c_83)
;
assign end_instr = 
(t[1] & c_00) 		|
(t[1] & c_01_e1) 	|
(t[3] & c_02) 		|
(t[1] & c_03) 		|
(t[1] & c_04) 		|
(t[3] & c_05) 		|
(t[3] & c_067) 		|
(t[2] & c_08f) 		|
(t[3] & c_10) 		|
(t[3] & c_11_f1)  	| 
(t[3] & c_12)           |
(t[1] & c_13)           |
(t[1] & c_14)           |
(t[3] & c_15)           |
(t[3] & c_167)          |
(t[2] & c_18f)          |
(t[3] & c_20)           |
(t[2] & c_22)           |
(t[1] & c_23)           |
(t[1] & c_24)           |
(t[2] & c_25)           |
(t[2] & c_267)          |
(t[1] & c_28f)          |
(t[3] & c_30)           |
(t[2] & c_32)           |
(t[1] & c_33)           |
(t[1] & c_34)           |
(t[2] & c_35)           |
(t[2] & c_367)          |
(t[1] & c_38f)          |
(t[2] & c_40)           |
(t[3] & c_42)           |
(t[3] & c_43)           |
(t[1] & c_44)           |
(t[2] & c_45)           |
(t[2] & c_467)          |
(t[1] & c_48f)          |
(t[2] & c_50)           |
(t[3] & c_52)           |
(t[3] & c_53)           |
(t[1] & c_54)           |
(t[2] & c_55)           |
(t[2] & c_567)          |
(t[1] & c_58f)          |
(t[2] & c_60)           |
(t[3] & c_62)           |
(t[3] & c_63)           |
(t[1] & c_64)           |
(t[2] & c_65)           |
(t[2] & c_667)          |
(t[1] & c_68f)          |
(t[2] & c_70)           |
(t[3] & c_72)           |
(t[1] & c_73)           |
(t[1] & c_74)           |
(t[3] & c_75)           |
(t[2] & c_767)          |
(t[2] & c_78f)          |
(t[2] & c_80)           |
(t[3] & c_82)           |
(t[2] & c_83)           |
(t[1] & c_84) 		| 
(t[3] & c_85) 		|
(t[3] & c_867) 		|
(t[2] & c_88f) 		|
(t[3] & c_90)           |
(t[3] & c_92)           |
(t[2] & c_93)           |
(t[1] & c_94)           |
(t[2] & c_95)           |
(t[2] & c_967)          |
(t[1] & c_98f)          |
(t[3] & c_a0)           |
(t[3] & c_a2)           |
(t[1] & c_a3)           |
(t[1] & c_a4)           |
(t[3] & c_a67)          |
(t[3] & c_a8f)          |
(t[3] & c_b0)           |
(t[3] & c_b2)           |
(t[1] & c_d3)           |
(t[3] & c_b4)           |
(t[3] & c_b5)           |
(t[3] & c_b67)          |
(t[3] & c_b8f)          |
(t[3] & c_c0)           |
(t[3] & c_c2)           |
(t[1] & c_c3)           |
(t[1] & c_c4)           |
(t[3] & c_c5)           |
(t[3] & c_c67)          |
(t[3] & c_c8f)          |
(t[3] & c_d0)           |
(t[3] & c_d2)           |
(t[1] & c_b3)           |
(t[1] & c_d4)           |
(t[3] & c_d5)           |
(t[3] & c_d67)          |
(t[2] & c_d8f)          |
(end_movx & c_e0) 	|
(end_movx & c_e23) 	|
(t[1] & c_e4) 		|
(t[2] & c_e5) 		|
(t[2] & c_e67) 		|
(t[1] & c_e8f) 		|
(end_movx & c_f0) 	|
(end_movx & c_f23) 	|
(t[1] & c_f4) 		|
(t[2] & c_f5) 		|
(t[2] & c_f67) 		|
(t[1] & c_f8f); 
                
assign addr_bank_a = (
		c_f23 |
                c_e23 |
                c_b67 |
                c_067 |
                c_167 |
		c_f67 | 
                c_767 |
                c_c67 |
                c_d67 |
                c_e67 |
                c_867 |
                c_967 |
                c_367 |
                c_267 |
                c_467 |
                c_567 |
                c_667 |
                c_a67
		)? 
		{2'b00,code[0]}:code[2:0];

assign sel_in_cy_bit = 
		(c_82) ? 3'd0 : 
                (c_b0) ? 3'd1 :
                (c_72) ? 3'd2 :
                (c_a0) ? 3'd3 :
                (c_a2) ? 3'd4 : 3'd0;

assign sel_bit_dat_out =           
		(c_10 | c_c2) ?	2'd0 : 
	  	(c_d2) ? 2'd1 :
                (c_b2) ? 2'd2 :
                (c_92) ? 2'd3 : 2'd0;

assign sel_alu =
		(c_03)  ? 5'b01111:  
                (c_04)  ? 5'b00011:   
                (c_05)  ? 5'b00011:   
                (c_067) ? 5'b00011:   
                (c_08f) ? 5'b00011:  
                (c_10)  ? 5'B01011:  
                (c_13)  ? 5'B10000:  
                (c_14)  ? 5'b00100:  
                (c_15)  ? 5'b00100:  
                (c_167) ? 5'b00100:  
                (c_18f) ? 5'b00100:  
                (c_23)  ? 5'b01101:  
                (c_24)  ? 5'b00000:  
                (c_25)  ? 5'b00000:  
                (c_267) ? 5'b00000:  
                (c_28f) ? 5'b00000:  
                (c_33)  ? 5'b01110:    
                (c_34)  ? 5'b00001:    
                (c_35)  ? 5'b00001:        
                (c_367) ? 5'b00001:        
                (c_38f) ? 5'b00001:        
                (c_42)  ? 5'b01001:   	  
                (c_43)  ? 5'b01001:       
                (c_44)  ? 5'b01001:        
                (c_45)  ? 5'b01001:        
                (c_467) ? 5'b01001:        
                (c_48f) ? 5'b01001:        
                (c_52)  ? 5'b01000:        
                (c_53)  ? 5'b01000:        
                (c_54)  ? 5'b01000:        
                (c_55)  ? 5'b01000:        
                (c_567) ? 5'b01000:        
                (c_58f) ? 5'b01000:        
                (c_62)  ? 5'b01010:        
                (c_63)  ? 5'b01010:        
                (c_64)  ? 5'b01010:        
                (c_65)  ? 5'b01010:        
                (c_667) ? 5'b01010:        
                (c_68f) ? 5'b01010:        
                (c_72)  ? 5'b01001:        
                (c_82)  ? 5'b01000:        
                (c_84)  ? 5'b00110:        
                (c_94)  ? 5'b00010:        
                (c_95)  ? 5'b00010:        
                (c_967) ? 5'b00010:        
                (c_98f) ? 5'b00010:        
                (c_a0)  ? 5'b01001:        
                (c_a4)  ? 5'b00101:        
                (c_b0)  ? 5'b01000:  
                (c_b2)  ? 5'b01100:  
                (c_c2)  ? 5'b01011:   
                (c_c4)  ? 5'b10001:   
                (c_d2)  ? 5'b10010:  
                (c_d3)  ? 5'b01000:  
                (c_d4)  ? 5'b00111:  
                (c_d5)  ? 5'b00100:  
                (c_d67) ? 5'b10011:  
                (c_d8f) ? 5'b00100:      
                (c_e4)  ? 5'b01011:  
                (c_f4)  ? 5'b01100: 5'd0; 

assign reti = c_32;

assign psen = 0;  

endmodule                      
