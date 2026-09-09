// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : staticregif.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : static register interface
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module staticregif
(
	RESETn,
	CLK,

	CS,
	EXT_BK_ADDR,
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	EXT_SFR_DIN,

	card_ecc_disabled,
	card_ecc_failed,
	
	dsr,			
//	hreset_b,
	pwdin,	
	pwd_len,
	rd_thd,
	
	cid,					
	csd,				
	ecsd_a,
	ecsd_b,
	ecsd_c,
	ecsd_d,
	ecsd_e,
	ecsd_f,
	ecsd_g,
	ecsd_h,
	ecsd_i,
	ecsd_j,
	ecsd_k,
	ecsd_l,
	ecsd_m,
	ecsd_n,
	ecsd_o,
	ecsd_p,
	ecsd_q,
	ecsd_r,
	ecsd_s,
	ocr_mem,
	scr
);

input			RESETn;
input			CLK;


input			CS;
input	[6:0]	EXT_BK_ADDR;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	EXT_SFR_DIN;

output			card_ecc_disabled;
output			card_ecc_failed;
input	[15:0]	dsr;			
//output			hreset_b;
output	[127:0]	pwdin;	
output	[7:0]	pwd_len;
output	[2:0]	rd_thd;

output	[127:0]	cid;					
output	[127:0]	csd;				
output	[7:0]	ecsd_a;
output	[31:0]	ecsd_b;
output	[7:0]	ecsd_c;
output	[7:0]	ecsd_d;
output	[7:0]	ecsd_e;
output	[7:0]	ecsd_f;
output	[7:0]	ecsd_g;
output	[7:0]	ecsd_h;
output	[7:0]	ecsd_i;
output	[7:0]	ecsd_j;
output	[7:0]	ecsd_k;
output	[7:0]	ecsd_l;
output	[7:0]	ecsd_m;
output	[7:0]	ecsd_n;
output	[7:0]	ecsd_o;
output	[7:0]	ecsd_p;
output	[7:0]	ecsd_q;
input	[7:0]	ecsd_r;
input	[7:0]	ecsd_s;
output	[31:0] 	ocr_mem;	
output	[63:0] 	scr;



reg 		card_ecc_disabled;
reg			card_ecc_failed;
reg	[7:0]	pwdin127_120;
reg	[7:0]	pwdin119_112;
reg [7:0]	pwdin111_104;
reg [7:0]	pwdin103_96;
reg [7:0]	pwdin95_88;
reg [7:0]	pwdin87_80;
reg [7:0]	pwdin79_72;
reg [7:0]	pwdin71_64;
reg [7:0]	pwdin63_56;
reg [7:0]	pwdin55_48;
reg [7:0]	pwdin47_40;
reg [7:0]	pwdin39_32;
reg [7:0]	pwdin31_24;
reg [7:0]	pwdin23_16;
reg [7:0]	pwdin15_8;
reg [7:0]	pwdin7_0;

assign pwdin = {pwdin127_120, pwdin119_112, pwdin111_104,pwdin103_96, 
pwdin95_88, pwdin87_80, pwdin79_72, pwdin71_64, 
pwdin63_56, pwdin55_48, pwdin47_40, pwdin39_32,
pwdin31_24, pwdin23_16, pwdin15_8, pwdin7_0};


reg	[7:0]	pwd_len;
reg	[2:0] 	rd_thd;
reg [7:0]	cid127_120;
reg [7:0]	cid119_112;
reg [7:0]	cid111_104;
reg [7:0]	cid103_96;
reg [7:0]	cid95_88;
reg [7:0]	cid87_80;
reg [7:0]	cid79_72;
reg [7:0]	cid71_64;
reg [7:0]	cid63_56;
reg [7:0]	cid55_48;
reg [7:0]	cid47_40;
reg [7:0]	cid39_32;
reg [7:0]	cid31_24;
reg [7:0]	cid23_16;
reg [7:0]	cid15_8;
reg [7:0]	cid7_0;

assign cid = {cid127_120, cid119_112, cid111_104,cid103_96, 
cid95_88, cid87_80, cid79_72, cid71_64,
cid63_56, cid55_48, cid47_40, cid39_32,
cid31_24, cid23_16, cid15_8,  cid7_0};


reg [7:0]	csd127_120;
reg [7:0]	csd119_112;
reg [7:0]	csd111_104;
reg [7:0]	csd103_96;
reg [7:0]	csd95_88;
reg [7:0]	csd87_80;
reg [7:0]	csd79_72;
reg [7:0]	csd71_64;
reg [7:0]	csd63_56;
reg [7:0]	csd55_48;
reg [7:0]	csd47_40;
reg [7:0]	csd39_32;
reg [7:0]	csd31_24;
reg [7:0]	csd23_16;
reg [7:0]	csd15_8;
reg [7:0]	csd7_0;


assign  csd = {csd127_120,csd119_112,csd111_104,csd103_96,
csd95_88,csd87_80,csd79_72,csd71_64,
csd63_56,csd55_48,csd47_40,csd39_32,
csd31_24,csd23_16,csd15_8,csd7_0};



reg [7:0]	ecsd_a;
reg [7:0]	ecsd_b31_24;
reg [7:0]	ecsd_b23_16;
reg [7:0]	ecsd_b15_8;
reg [7:0]	ecsd_b7_0;

assign 	ecsd_b = {ecsd_b31_24,ecsd_b23_16,ecsd_b15_8, ecsd_b7_0};

reg [7:0]	ecsd_c;
reg [7:0]	ecsd_d;
reg [7:0]	ecsd_e;
reg [7:0]	ecsd_f;
reg [7:0]	ecsd_g;
reg [7:0]	ecsd_h;
reg [7:0]	ecsd_i;
reg [7:0]	ecsd_j;
reg [7:0]	ecsd_k;
reg [7:0]	ecsd_l;
reg [7:0]	ecsd_m;
reg [7:0]	ecsd_n;
reg [7:0]	ecsd_o;
reg [7:0]	ecsd_p;
reg [7:0]	ecsd_q;
//reg [7:0]	ecsd_r;
//reg [7:0]	ecsd_s;

reg [7:0]	ocr_mem31_24;
reg [7:0]	ocr_mem23_16;
reg [7:0]	ocr_mem15_8;
reg [7:0]	ocr_mem7_0;

assign ocr_mem = { ocr_mem31_24, ocr_mem23_16, ocr_mem15_8,	ocr_mem7_0};


reg [7:0]	scr63_56;
reg [7:0]	scr55_48;
reg [7:0]	scr47_40;
reg [7:0]	scr39_32;
reg [7:0]	scr31_24;
reg [7:0]	scr23_16;
reg [7:0]	scr15_8;
reg [7:0]	scr7_0;

assign scr = { scr63_56, scr55_48, scr47_40, scr39_32,
scr31_24, scr23_16, scr15_8, scr7_0};


reg [7:0]	EXT_SFR_DIN;

`define DSR_L_ADDR			7'h61
`define	DSR_H_ADDR			7'h62

`define PWDIN127_120_ADDR	7'h01
`define PWDIN119_112_ADDR	7'h02
`define PWDIN111_104_ADDR	7'h03
`define PWDIN103_96_ADDR 	7'h04
`define PWDIN95_88_ADDR	 	7'h05
`define PWDIN87_80_ADDR	 	7'h06
`define PWDIN79_72_ADDR	 	7'h07
`define PWDIN71_64_ADDR 	7'h09
`define PWDIN63_56_ADDR 	7'h0A
`define PWDIN55_48_ADDR 	7'h0B
`define PWDIN47_40_ADDR 	7'h0C
`define PWDIN39_32_ADDR		7'h0D
`define PWDIN31_24_ADDR		7'h0E
`define PWDIN23_16_ADDR		7'h0F
`define PWDIN15_8_ADDR		7'h11
`define PWDIN7_0_ADDR		7'h12
`define PWD_LEN_ADDR		7'h13

`define RD_THD_ADDR         7'h14

`define CID127_120_ADDR		7'h15
`define CID119_112_ADDR     7'h16
`define CID111_104_ADDR     7'h17
`define CID103_96_ADDR      7'h19
`define CID95_88_ADDR       7'h1A
`define CID87_80_ADDR       7'h1B
`define CID79_72_ADDR       7'h1C
`define CID71_64_ADDR		7'h1D
`define CID63_56_ADDR       7'h1E
`define CID55_48_ADDR       7'h1F
`define CID47_40_ADDR       7'h21
`define CID39_32_ADDR       7'h22
`define CID31_24_ADDR       7'h23
`define CID23_16_ADDR       7'h24
`define CID15_8_ADDR		7'h25
`define CID7_0_ADDR         7'h26

`define CSD127_120_ADDR     7'h27
`define CSD119_112_ADDR     7'h29
`define CSD111_104_ADDR     7'h2A
`define CSD103_96_ADDR      7'h2B
`define CSD95_88_ADDR		7'h2C
`define CSD87_80_ADDR       7'h2D
`define CSD79_72_ADDR       7'h2E
`define CSD71_64_ADDR       7'h2F
`define CSD63_56_ADDR       7'h31
`define CSD55_48_ADDR       7'h32
`define CSD47_40_ADDR       7'h33
`define CSD39_32_ADDR		7'h34
`define CSD31_24_ADDR       7'h35
`define CSD23_16_ADDR       7'h36
`define CSD15_8_ADDR        7'h37
`define CSD7_0_ADDR         7'h39
                                
`define ECSD_A_ADDR		    7'h3A
`define ECSD_B31_24_ADDR	7'h3B
`define ECSD_B23_16_ADDR	7'h3C
`define ECSD_B15_8_ADDR	    7'h3D
`define ECSD_B7_0_ADDR	    7'h3E
`define ECSD_C_ADDR	        7'h3F
`define ECSD_D_ADDR	        7'h41
`define ECSD_E_ADDR		    7'h42
`define ECSD_F_ADDR			7'h43
`define ECSD_G_ADDR		    7'h44
`define ECSD_H_ADDR		    7'h45
`define ECSD_I_ADDR		    7'h46
`define ECSD_J_ADDR		    7'h47
`define ECSD_K_ADDR		    7'h49
`define ECSD_L_ADDR		    7'h4A
`define ECSD_M_ADDR		 	7'h4B
`define ECSD_N_ADDR		    7'h4C
`define ECSD_O_ADDR		    7'h4D
`define ECSD_P_ADDR		    7'h4E
`define ECSD_Q_ADDR		    7'h4F
`define ECSD_R_ADDR		    7'h51
`define ECSD_S_ADDR		    7'h52
                                
`define OCR_MEM31_24_ADDR   7'h53
`define OCR_MEM23_16_ADDR 	7'h54
`define OCR_MEM15_8_ADDR    7'h55
`define OCR_MEM7_0_ADDR	    7'h56
`define SCR63_56_ADDR	    7'h57
`define SCR55_48_ADDR	    7'h59
`define SCR47_40_ADDR	    7'h5A
`define SCR39_32_ADDR	    7'h5B
`define SCR31_24_ADDR		7'h5C
`define SCR23_16_ADDR	    7'h5D
`define SCR15_8_ADDR		7'h5E
`define SCR7_0_ADDR		    7'h5F

wire	pwdin127_120_w; 	
wire	pwdin119_112_w;	
wire	pwdin111_104_w;	
wire	pwdin103_96_w;	
wire	pwdin95_88_w;	
wire	pwdin87_80_w;	
wire	pwdin79_72_w;	
wire	pwdin71_64_w;	
wire	pwdin63_56_w;	
wire	pwdin55_48_w;	
wire	pwdin47_40_w;	
wire	pwdin39_32_w;	
wire	pwdin31_24_w;	
wire	pwdin23_16_w;	
wire	pwdin15_8_w	;	
wire	pwdin7_0_w	;	
wire	pwd_len_w 	;	
wire	rd_thd_w	;	
wire	cid127_120_w;	
wire	cid119_112_w;	
wire	cid111_104_w;	
wire	cid103_96_w	;	
wire	cid95_88_w 	;	
wire	cid87_80_w	;	
wire	cid79_72_w	;	
wire	cid71_64_w	;	
wire	cid63_56_w	;	
wire	cid55_48_w 	;	
wire	cid47_40_w 	;	
wire	cid39_32_w  ;	
wire	cid31_24_w	;	
wire	cid23_16_w 	;	
wire	cid15_8_w	;	
wire	cid7_0_w  	;	
wire	csd127_120_w;	
wire	csd119_112_w;	
wire	csd111_104_w;	
wire	csd103_96_w	;	
wire	csd95_88_w 	;	
wire	csd87_80_w 	;	
wire	csd79_72_w 	;	
wire	csd71_64_w 	;	
wire	csd63_56_w 	;	
wire	csd55_48_w 	;	
wire	csd47_40_w 	;	
wire	csd39_32_w 	;	
wire	csd31_24_w 	;	
wire	csd23_16_w 	;	
wire	csd15_8_w  	;	
wire	csd7_0_w   	;	
wire	ecsd_a_w	;	
wire	ecsd_b31_24_w;	
wire	ecsd_b23_16_w;	
wire	ecsd_b15_8_w;	
wire	ecsd_b7_0_w	;	
wire	ecsd_c_w	;	
wire	ecsd_d_w	;	
wire	ecsd_e_w	;	
wire	ecsd_f_w	;	
wire	ecsd_g_w	;	
wire	ecsd_h_w	;	
wire	ecsd_i_w	;	
wire	ecsd_j_w	;	
wire	ecsd_k_w	;	
wire	ecsd_l_w	;	
wire	ecsd_m_w	;	
wire	ecsd_n_w	;	
wire	ecsd_o_w	;	
wire	ecsd_p_w	;	
wire	ecsd_q_w	;	
//wire	ecsd_r_w	;	
//wire	ecsd_s_w	;	
wire	ocr_mem31_24_w;	
wire	ocr_mem23_16_w;	
wire	ocr_mem15_8_w;	
wire	ocr_mem7_0_w;	
wire	scr63_56_w	;	
wire	scr55_48_w	;	
wire	scr47_40_w	 ;   
wire	scr39_32_w	;	
wire	scr31_24_w	;	
wire	scr23_16_w	;	
wire	scr15_8_w	;	
wire	scr7_0_w	;	
            
wire	dsr_l_r;
wire	dsr_h_r;    
wire	pwdin127_120_r; 	
wire	pwdin119_112_r;	
wire	pwdin111_104_r;	
wire	pwdin103_96_r;	
wire	pwdin95_88_r;	
wire	pwdin87_80_r;	
wire	pwdin79_72_r;	
wire	pwdin71_64_r;	
wire	pwdin63_56_r;	
wire	pwdin55_48_r;	
wire	pwdin47_40_r;	
wire	pwdin39_32_r;	
wire	pwdin31_24_r;	
wire	pwdin23_16_r;	
wire	pwdin15_8_r	;	
wire	pwdin7_0_r	;	
wire	pwd_len_r 	;	
wire	rd_thd_r	;	
wire	cid127_120_r;	
wire	cid119_112_r;	
wire	cid111_104_r;	
wire	cid103_96_r	;	
wire	cid95_88_r 	;	
wire	cid87_80_r	;	
wire	cid79_72_r	;	
wire	cid71_64_r	;	
wire	cid63_56_r	;	
wire	cid55_48_r 	;	
wire	cid47_40_r 	;	
wire	cid39_32_r  ;	
wire	cid31_24_r	;	
wire	cid23_16_r 	;	
wire	cid15_8_r	;	
wire	cid7_0_r  	;	
wire	csd127_120_r;	
wire	csd119_112_r;	
wire	csd111_104_r;	
wire	csd103_96_r	;	
wire	csd95_88_r 	;	
wire	csd87_80_r 	;	
wire	csd79_72_r 	;	
wire	csd71_64_r 	;	
wire	csd63_56_r 	;	
wire	csd55_48_r 	;	
wire	csd47_40_r 	;	
wire	csd39_32_r 	;	
wire	csd31_24_r 	;	
wire	csd23_16_r 	;	
wire	csd15_8_r  	;	
wire	csd7_0_r   	;	
wire	ecsd_a_r	;	
wire	ecsd_b31_24_r;	
wire	ecsd_b23_16_r;	
wire	ecsd_b15_8_r;	
wire	ecsd_b7_0_r	;	
wire	ecsd_c_r	;	
wire	ecsd_d_r	;	
wire	ecsd_e_r	;	
wire	ecsd_f_r	;	
wire	ecsd_g_r	;	
wire	ecsd_h_r	;	
wire	ecsd_i_r	;	
wire	ecsd_j_r	;	
wire	ecsd_k_r	;	
wire	ecsd_l_r	;	
wire	ecsd_m_r	;	
wire	ecsd_n_r	;	
wire	ecsd_o_r	;	
wire	ecsd_p_r	;	
wire	ecsd_q_r	;	
wire	ecsd_r_r	;	
wire	ecsd_s_r	;	
          
wire	ocr_mem31_24_r;	
wire	ocr_mem23_16_r;	
wire	ocr_mem15_8_r;	
wire	ocr_mem7_0_r;	
wire	scr63_56_r	;	
wire	scr55_48_r	;	
wire	scr47_40_r	 ;   
wire	scr39_32_r	;	
wire	scr31_24_r	;	
wire	scr23_16_r	;	
wire	scr15_8_r	;	
wire	scr7_0_r	;	

assign	pwdin127_120_w 	= (EXT_BK_ADDR==`PWDIN127_120_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin119_112_w	= (EXT_BK_ADDR==`PWDIN119_112_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin111_104_w	= (EXT_BK_ADDR==`PWDIN111_104_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin103_96_w	= (EXT_BK_ADDR==`PWDIN103_96_ADDR 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin95_88_w	= (EXT_BK_ADDR==`PWDIN95_88_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin87_80_w	= (EXT_BK_ADDR==`PWDIN87_80_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin79_72_w	= (EXT_BK_ADDR==`PWDIN79_72_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin71_64_w	= (EXT_BK_ADDR==`PWDIN71_64_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin63_56_w	= (EXT_BK_ADDR==`PWDIN63_56_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin55_48_w	= (EXT_BK_ADDR==`PWDIN55_48_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin47_40_w	= (EXT_BK_ADDR==`PWDIN47_40_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin39_32_w	= (EXT_BK_ADDR==`PWDIN39_32_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin31_24_w	= (EXT_BK_ADDR==`PWDIN31_24_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin23_16_w	= (EXT_BK_ADDR==`PWDIN23_16_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin15_8_w		= (EXT_BK_ADDR==`PWDIN15_8_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwdin7_0_w		= (EXT_BK_ADDR==`PWDIN7_0_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	pwd_len_w 		= (EXT_BK_ADDR==`PWD_LEN_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	rd_thd_w		= (EXT_BK_ADDR==`RD_THD_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	cid127_120_w	= (EXT_BK_ADDR==`CID127_120_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	cid119_112_w	= (EXT_BK_ADDR==`CID119_112_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	cid111_104_w	= (EXT_BK_ADDR==`CID111_104_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid103_96_w		= (EXT_BK_ADDR==`CID103_96_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	cid95_88_w 		= (EXT_BK_ADDR==`CID95_88_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid87_80_w		= (EXT_BK_ADDR==`CID87_80_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid79_72_w		= (EXT_BK_ADDR==`CID79_72_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid71_64_w		= (EXT_BK_ADDR==`CID71_64_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid63_56_w		= (EXT_BK_ADDR==`CID63_56_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid55_48_w 		= (EXT_BK_ADDR==`CID55_48_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid47_40_w 		= (EXT_BK_ADDR==`CID47_40_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid39_32_w   	= (EXT_BK_ADDR==`CID39_32_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	cid31_24_w		= (EXT_BK_ADDR==`CID31_24_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	cid23_16_w 		= (EXT_BK_ADDR==`CID23_16_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	cid15_8_w		= (EXT_BK_ADDR==`CID15_8_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	cid7_0_w  		= (EXT_BK_ADDR==`CID7_0_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	csd127_120_w	= (EXT_BK_ADDR==`CSD127_120_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	csd119_112_w	= (EXT_BK_ADDR==`CSD119_112_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	csd111_104_w	= (EXT_BK_ADDR==`CSD111_104_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	csd103_96_w		= (EXT_BK_ADDR==`CSD103_96_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd95_88_w 		= (EXT_BK_ADDR==`CSD95_88_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd87_80_w 		= (EXT_BK_ADDR==`CSD87_80_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd79_72_w 		= (EXT_BK_ADDR==`CSD79_72_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd71_64_w 		= (EXT_BK_ADDR==`CSD71_64_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd63_56_w 		= (EXT_BK_ADDR==`CSD63_56_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd55_48_w 		= (EXT_BK_ADDR==`CSD55_48_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd47_40_w 		= (EXT_BK_ADDR==`CSD47_40_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd39_32_w 		= (EXT_BK_ADDR==`CSD39_32_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd31_24_w 		= (EXT_BK_ADDR==`CSD31_24_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd23_16_w 		= (EXT_BK_ADDR==`CSD23_16_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 	
assign	csd15_8_w  		= (EXT_BK_ADDR==`CSD15_8_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 
assign	csd7_0_w   		= (EXT_BK_ADDR==`CSD7_0_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1); 
assign	ecsd_a_w		= (EXT_BK_ADDR==`ECSD_A_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_b31_24_w	= (EXT_BK_ADDR==`ECSD_B31_24_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_b23_16_w	= (EXT_BK_ADDR==`ECSD_B23_16_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_b15_8_w	= (EXT_BK_ADDR==`ECSD_B15_8_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_b7_0_w		= (EXT_BK_ADDR==`ECSD_B7_0_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_c_w		= (EXT_BK_ADDR==`ECSD_C_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_d_w		= (EXT_BK_ADDR==`ECSD_D_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_e_w		= (EXT_BK_ADDR==`ECSD_E_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	ecsd_f_w		= (EXT_BK_ADDR==`ECSD_F_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);	
assign	ecsd_g_w		= (EXT_BK_ADDR==`ECSD_G_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_h_w		= (EXT_BK_ADDR==`ECSD_H_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_i_w		= (EXT_BK_ADDR==`ECSD_I_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_j_w		= (EXT_BK_ADDR==`ECSD_J_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_k_w		= (EXT_BK_ADDR==`ECSD_K_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_l_w		= (EXT_BK_ADDR==`ECSD_L_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_m_w		= (EXT_BK_ADDR==`ECSD_M_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_n_w		= (EXT_BK_ADDR==`ECSD_N_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_o_w		= (EXT_BK_ADDR==`ECSD_O_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_p_w		= (EXT_BK_ADDR==`ECSD_P_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ecsd_q_w		= (EXT_BK_ADDR==`ECSD_Q_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
//assign	ecsd_r_w		= (EXT_BK_ADDR==`ECSD_R_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
//assign	ecsd_s_w		= (EXT_BK_ADDR==`ECSD_S_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
                                               
assign	ocr_mem31_24_w	= (EXT_BK_ADDR==`OCR_MEM31_24_ADDR ) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ocr_mem23_16_w	= (EXT_BK_ADDR==`OCR_MEM23_16_ADDR ) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ocr_mem15_8_w	= (EXT_BK_ADDR==`OCR_MEM15_8_ADDR  ) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	ocr_mem7_0_w	= (EXT_BK_ADDR==`OCR_MEM7_0_ADDR	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr63_56_w		= (EXT_BK_ADDR==`SCR63_56_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr55_48_w		= (EXT_BK_ADDR==`SCR55_48_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr47_40_w	    = (EXT_BK_ADDR==`SCR47_40_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr39_32_w		= (EXT_BK_ADDR==`SCR39_32_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr31_24_w		= (EXT_BK_ADDR==`SCR31_24_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr23_16_w		= (EXT_BK_ADDR==`SCR23_16_ADDR	 	) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr15_8_w		= (EXT_BK_ADDR==`SCR15_8_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);
assign	scr7_0_w		= (EXT_BK_ADDR==`SCR7_0_ADDR		) & (EXT_SFR_WR==1'b1) & (CS==1'b1);

assign	dsr_l_r		= (EXT_BK_ADDR==`DSR_L_ADDR		 ) ;
assign	dsr_h_r		= (EXT_BK_ADDR==`DSR_H_ADDR		 ) ;

assign	pwdin127_120_r 	= (EXT_BK_ADDR==`PWDIN127_120_ADDR) ;
assign	pwdin119_112_r	= (EXT_BK_ADDR==`PWDIN119_112_ADDR) ;
assign	pwdin111_104_r	= (EXT_BK_ADDR==`PWDIN111_104_ADDR) ;
assign	pwdin103_96_r	= (EXT_BK_ADDR==`PWDIN103_96_ADDR ) ;
assign	pwdin95_88_r	= (EXT_BK_ADDR==`PWDIN95_88_ADDR  ) ;
assign	pwdin87_80_r	= (EXT_BK_ADDR==`PWDIN87_80_ADDR  ) ;
assign	pwdin79_72_r	= (EXT_BK_ADDR==`PWDIN79_72_ADDR  ) ;
assign	pwdin71_64_r	= (EXT_BK_ADDR==`PWDIN71_64_ADDR  ) ;
assign	pwdin63_56_r	= (EXT_BK_ADDR==`PWDIN63_56_ADDR  ) ;
assign	pwdin55_48_r	= (EXT_BK_ADDR==`PWDIN55_48_ADDR  ) ;
assign	pwdin47_40_r	= (EXT_BK_ADDR==`PWDIN47_40_ADDR  ) ;
assign	pwdin39_32_r	= (EXT_BK_ADDR==`PWDIN39_32_ADDR  ) ;
assign	pwdin31_24_r	= (EXT_BK_ADDR==`PWDIN31_24_ADDR  ) ;
assign	pwdin23_16_r	= (EXT_BK_ADDR==`PWDIN23_16_ADDR  ) ;
assign	pwdin15_8_r		= (EXT_BK_ADDR==`PWDIN15_8_ADDR   ) ;
assign	pwdin7_0_r		= (EXT_BK_ADDR==`PWDIN7_0_ADDR    ) ;
assign	pwd_len_r 		= (EXT_BK_ADDR==`PWD_LEN_ADDR     ) ;
assign	rd_thd_r		= (EXT_BK_ADDR==`RD_THD_ADDR      ) ;
assign	cid127_120_r	= (EXT_BK_ADDR==`CID127_120_ADDR  ) ;	
assign	cid119_112_r	= (EXT_BK_ADDR==`CID119_112_ADDR  ) ;	
assign	cid111_104_r	= (EXT_BK_ADDR==`CID111_104_ADDR  ) ;	
assign	cid103_96_r		= (EXT_BK_ADDR==`CID103_96_ADDR   ) ; 	
assign	cid95_88_r 		= (EXT_BK_ADDR==`CID95_88_ADDR	   ) ;	
assign	cid87_80_r		= (EXT_BK_ADDR==`CID87_80_ADDR    ) ;	
assign	cid79_72_r		= (EXT_BK_ADDR==`CID79_72_ADDR    ) ;	
assign	cid71_64_r		= (EXT_BK_ADDR==`CID71_64_ADDR    ) ;	
assign	cid63_56_r		= (EXT_BK_ADDR==`CID63_56_ADDR    ) ;	
assign	cid55_48_r 		= (EXT_BK_ADDR==`CID55_48_ADDR    ) ;	
assign	cid47_40_r 		= (EXT_BK_ADDR==`CID47_40_ADDR    ) ;	
assign	cid39_32_r   	= (EXT_BK_ADDR==`CID39_32_ADDR    ) ;	
assign	cid31_24_r		= (EXT_BK_ADDR==`CID31_24_ADDR    ) ;	
assign	cid23_16_r 		= (EXT_BK_ADDR==`CID23_16_ADDR    ) ;	
assign	cid15_8_r		= (EXT_BK_ADDR==`CID15_8_ADDR     ) ; 	
assign	cid7_0_r  		= (EXT_BK_ADDR==`CID7_0_ADDR      ) ; 	
assign	csd127_120_r	= (EXT_BK_ADDR==`CSD127_120_ADDR  ) ; 	
assign	csd119_112_r	= (EXT_BK_ADDR==`CSD119_112_ADDR  ) ; 	
assign	csd111_104_r	= (EXT_BK_ADDR==`CSD111_104_ADDR  ) ; 	
assign	csd103_96_r		= (EXT_BK_ADDR==`CSD103_96_ADDR   ) ;
assign	csd95_88_r 		= (EXT_BK_ADDR==`CSD95_88_ADDR    ) ;	
assign	csd87_80_r 		= (EXT_BK_ADDR==`CSD87_80_ADDR    ) ;
assign	csd79_72_r 		= (EXT_BK_ADDR==`CSD79_72_ADDR    ) ;
assign	csd71_64_r 		= (EXT_BK_ADDR==`CSD71_64_ADDR    ) ;
assign	csd63_56_r 		= (EXT_BK_ADDR==`CSD63_56_ADDR    ) ;
assign	csd55_48_r 		= (EXT_BK_ADDR==`CSD55_48_ADDR    ) ;
assign	csd47_40_r 		= (EXT_BK_ADDR==`CSD47_40_ADDR    ) ;
assign	csd39_32_r 		= (EXT_BK_ADDR==`CSD39_32_ADDR    ) ; 
assign	csd31_24_r 		= (EXT_BK_ADDR==`CSD31_24_ADDR	   ) ; 	
assign	csd23_16_r 		= (EXT_BK_ADDR==`CSD23_16_ADDR	   ) ; 	
assign	csd15_8_r  		= (EXT_BK_ADDR==`CSD15_8_ADDR	   ) ; 	
assign	csd7_0_r   		= (EXT_BK_ADDR==`CSD7_0_ADDR  	   ) ; 	
assign	ecsd_a_r		= (EXT_BK_ADDR==`ECSD_A_ADDR	   ) ;
assign	ecsd_b31_24_r	= (EXT_BK_ADDR==`ECSD_B31_24_ADDR ) ;
assign	ecsd_b23_16_r	= (EXT_BK_ADDR==`ECSD_B23_16_ADDR ) ;
assign	ecsd_b15_8_r	= (EXT_BK_ADDR==`ECSD_B15_8_ADDR  ) ;
assign	ecsd_b7_0_r		= (EXT_BK_ADDR==`ECSD_B7_0_ADDR   ) ;
assign	ecsd_c_r		= (EXT_BK_ADDR==`ECSD_C_ADDR	   ) ;
assign	ecsd_d_r		= (EXT_BK_ADDR==`ECSD_D_ADDR	   ) ;
assign	ecsd_e_r		= (EXT_BK_ADDR==`ECSD_E_ADDR	   ) ;	
assign	ecsd_f_r		= (EXT_BK_ADDR==`ECSD_F_ADDR	   ) ;	
assign	ecsd_g_r		= (EXT_BK_ADDR==`ECSD_G_ADDR		 ) ;
assign	ecsd_h_r		= (EXT_BK_ADDR==`ECSD_H_ADDR		 ) ;
assign	ecsd_i_r		= (EXT_BK_ADDR==`ECSD_I_ADDR		 ) ;
assign	ecsd_j_r		= (EXT_BK_ADDR==`ECSD_J_ADDR		 ) ;
assign	ecsd_k_r		= (EXT_BK_ADDR==`ECSD_K_ADDR		 ) ;
assign	ecsd_l_r		= (EXT_BK_ADDR==`ECSD_L_ADDR		 ) ;
assign	ecsd_m_r		= (EXT_BK_ADDR==`ECSD_M_ADDR		 ) ;
assign	ecsd_n_r		= (EXT_BK_ADDR==`ECSD_N_ADDR		 ) ;
assign	ecsd_o_r		= (EXT_BK_ADDR==`ECSD_O_ADDR		 ) ;
assign	ecsd_p_r		= (EXT_BK_ADDR==`ECSD_P_ADDR		 ) ;
assign	ecsd_q_r		= (EXT_BK_ADDR==`ECSD_Q_ADDR		 ) ;
assign	ecsd_r_r		= (EXT_BK_ADDR==`ECSD_R_ADDR		 ) ;
assign	ecsd_s_r		= (EXT_BK_ADDR==`ECSD_S_ADDR		 ) ;
                                              
assign	ocr_mem31_24_r	= (EXT_BK_ADDR==`OCR_MEM31_24_ADDR) ;
assign	ocr_mem23_16_r	= (EXT_BK_ADDR==`OCR_MEM23_16_ADDR) ;
assign	ocr_mem15_8_r	= (EXT_BK_ADDR==`OCR_MEM15_8_ADDR ) ;
assign	ocr_mem7_0_r	= (EXT_BK_ADDR==`OCR_MEM7_0_ADDR  );
assign	scr63_56_r		= (EXT_BK_ADDR==`SCR63_56_ADDR	 ) ;
assign	scr55_48_r		= (EXT_BK_ADDR==`SCR55_48_ADDR	 ) ;
assign	scr47_40_r	    = (EXT_BK_ADDR==`SCR47_40_ADDR	 ) ;
assign	scr39_32_r		= (EXT_BK_ADDR==`SCR39_32_ADDR	 ) ;
assign	scr31_24_r		= (EXT_BK_ADDR==`SCR31_24_ADDR	 ) ;
assign	scr23_16_r		= (EXT_BK_ADDR==`SCR23_16_ADDR	 ) ;
assign	scr15_8_r		= (EXT_BK_ADDR==`SCR15_8_ADDR	 ) ;
assign	scr7_0_r		= (EXT_BK_ADDR==`SCR7_0_ADDR	 );
               
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_disabled <= 0;
	else if (rd_thd_w)
	card_ecc_disabled <= EXT_SFR_DOUT[4];
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_failed <= 0;
	else if (rd_thd_w)
	card_ecc_failed <=EXT_SFR_DOUT[3];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin127_120 <= 0;
	else if (pwdin127_120_w)
	pwdin127_120 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin119_112 <= 0;
	else if (pwdin119_112_w)
	pwdin119_112 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin111_104 <= 0;
	else if (pwdin111_104_w)
	pwdin111_104 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin103_96 <= 0;
	else if (pwdin103_96_w)
	pwdin103_96 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin95_88 <= 0;
	else if (pwdin95_88_w)
	pwdin95_88 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin87_80 <= 0;
	else if (pwdin87_80_w)
	pwdin87_80 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin79_72 <= 0;
	else if (pwdin79_72_w)
	pwdin79_72 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin71_64 <= 0;
	else if (pwdin71_64_w)
	pwdin71_64 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin63_56 <= 0;
	else if (pwdin63_56_w)
	pwdin63_56 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin55_48 <= 0;
	else if (pwdin55_48_w)
	pwdin55_48 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin47_40 <= 0;
	else if (pwdin47_40_w)
	pwdin47_40 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin39_32 <= 0;
	else if (pwdin39_32_w)
	pwdin39_32 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin31_24 <= 0;
	else if (pwdin31_24_w)
	pwdin31_24 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin23_16 <= 0;
	else if (pwdin23_16_w)
	pwdin23_16 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin15_8 <= 0;
	else if (pwdin15_8_w)
	pwdin15_8 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin7_0 <= 0;
	else if (pwdin7_0_w)
	pwdin7_0 <= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwd_len <= 0; 
	else if (pwd_len_w)
	pwd_len <= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	rd_thd <= 0; 
	else if (rd_thd_w)
	rd_thd <= EXT_SFR_DOUT[2:0];
end




always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid127_120 <= 0;
	else if (cid127_120_w)
	cid127_120 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid119_112 <= 0;
	else if (cid119_112_w)
	cid119_112 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid111_104 <= 0;
	else if (cid111_104_w)
	cid111_104 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid103_96	<= 0;
	else if (cid103_96_w)
	cid103_96	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid95_88	<= 0;
	else if (cid95_88_w)
	cid95_88	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid87_80	<= 0;
	else if (cid87_80_w)
	cid87_80	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid79_72	<= 0;
	else if (cid79_72_w)
	cid79_72	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid71_64	<= 0;
	else if (cid71_64_w)
	cid71_64	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid63_56	<= 0;
	else if (cid63_56_w)
	cid63_56	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid55_48	<= 0;
	else if (cid55_48_w)
	cid55_48	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid47_40	<= 0;
	else if (cid47_40_w)
	cid47_40	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid39_32	<= 0;
	else if (cid39_32_w)
	cid39_32	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid31_24	<= 0;
	else if (cid31_24_w)
	cid31_24	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid23_16	<= 0;
	else if (cid23_16_w)
	cid23_16	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid15_8		<=	0;
	else if (cid15_8_w)
	cid15_8		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid7_0		<= 0;
	else if (cid7_0_w)
	cid7_0		<= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd127_120	<= 0;
	else if (csd127_120_w)
	csd127_120		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd119_112	<= 0;
	else if (csd119_112_w)
	csd119_112		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd111_104	<= 0;
	else if (csd111_104_w)
	csd111_104		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd103_96	<= 0;
	else if (csd103_96_w)
	csd103_96		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd95_88	<= 0;
	else if (csd95_88_w)
	csd95_88		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd87_80	<= 0;
	else if (csd87_80_w)
	csd87_80		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd79_72	<= 0;
	else if (csd79_72_w)
	csd79_72		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd71_64	<= 0;
	else if (csd71_64_w)
	csd71_64		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd63_56	<= 0;
	else if (csd63_56_w)
	csd63_56		<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd55_48<= 0;
	else if (csd55_48_w)
	csd55_48<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd47_40<= 0;
	else if (csd47_40_w)
	csd47_40<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd39_32<= 0;
	else if (csd39_32_w)
	csd39_32<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd31_24<= 0;
	else if (csd31_24_w)
	csd31_24<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd23_16<= 0;
	else if (csd23_16_w)
	csd23_16<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd15_8	<= 0;
	else if (csd15_8_w)
	csd15_8	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd7_0	<= 0;
	else if (csd7_0_w)
	csd7_0	<= EXT_SFR_DOUT;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_a	<= 0;
	else if (ecsd_a_w)
	ecsd_a	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b31_24	<= 0;
	else if (ecsd_b31_24_w)
	ecsd_b31_24	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b23_16	<= 0;
	else if (ecsd_b23_16_w)
	ecsd_b23_16	<= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b15_8 <= 0;
	else if (ecsd_b15_8_w)
	ecsd_b15_8 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b7_0 <= 0;
	else if (ecsd_b7_0_w)
	ecsd_b7_0 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_c <= 0;
	else if (ecsd_c_w)
	ecsd_c <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_d <= 0;
	else if (ecsd_d_w)
	ecsd_d <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_e <= 0;
	else if (ecsd_e_w)
	ecsd_e <= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_f <= 0;
	else if (ecsd_f_w)
	ecsd_f <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_g <= 0;
	else if (ecsd_g_w)
	ecsd_g <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_h <= 0;
	else if (ecsd_h_w)
	ecsd_h <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_i <= 0;
	else if (ecsd_i_w)
	ecsd_i <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_j <= 0;
	else if (ecsd_j_w)
	ecsd_j <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_k <= 0;
	else if (ecsd_k_w)
	ecsd_k <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_l <= 0;
	else if (ecsd_l_w)
	ecsd_l <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_m <= 0;
	else if (ecsd_m_w)
	ecsd_m <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_n <= 0;
	else if (ecsd_n_w)
	ecsd_n <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_o <= 0;
	else if (ecsd_o_w)
	ecsd_o <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_p <= 0;
	else if (ecsd_p_w)
	ecsd_p <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_q <= 0;
	else if (ecsd_q_w)
	ecsd_q <= EXT_SFR_DOUT; 
end

/*
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_r <= 0;
	else if (ecsd_r_w)
	ecsd_r <= EXT_SFR_DOUT; 
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_s <= 0;
	else if (ecsd_s_w)
	ecsd_s <= EXT_SFR_DOUT; 
end
*/
reg	ecsd_r_sync1;
reg ecsd_s_sync1;
reg	ecsd_r_sync;
reg	ecsd_s_sync;
reg	[15:0]	dsr_sync1;
reg	[15:0]	dsr_sync;

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	ecsd_r_sync1 	<= 0;
	ecsd_s_sync1 	<= 0;
	ecsd_r_sync 	<= 0;
	ecsd_s_sync 	<= 0;
	dsr_sync1 		<= 0;
	dsr_sync		<= 0;
	end
	else
	begin
	ecsd_r_sync1 	<= ecsd_r;
	ecsd_s_sync1 	<= ecsd_s;
	ecsd_r_sync 	<= ecsd_r_sync1;
	ecsd_s_sync 	<= ecsd_s_sync1;
	dsr_sync1 		<= dsr;
	dsr_sync		<= dsr_sync1;

	end
end



always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem31_24 <= 0;
	else if (ocr_mem31_24_w)
	ocr_mem31_24 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem23_16 <= 0;
	else if (ocr_mem23_16_w)
	ocr_mem23_16 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem15_8 <= 0;
	else if (ocr_mem15_8_w)
	ocr_mem15_8 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem7_0 <= 0;
	else if (ocr_mem7_0_w)
	ocr_mem7_0 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr63_56 <= 0;
	else if (scr63_56_w)
	scr63_56 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr55_48 <= 0;
	else if (scr55_48_w)
	scr55_48 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr47_40 <= 0;
	else if (scr47_40_w)
	scr47_40 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr39_32 = 0;
	else if (scr39_32_w)
	scr39_32 = EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr31_24 <= 0;
	else if (scr31_24_w)
	scr31_24 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr23_16 <= 0;
	else if (scr23_16_w)
	scr23_16 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr15_8 <= 0;
	else if (scr15_8_w)
	scr15_8 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr7_0 <= 0;
	else if (scr7_0_w)
	scr7_0 <= EXT_SFR_DOUT;
end

always @(	pwdin127_120 or pwdin119_112 or pwdin111_104 or pwdin103_96 or 
			pwdin95_88 or pwdin87_80 or pwdin79_72 or pwdin71_64 or 
			pwdin63_56 or pwdin55_48 or pwdin47_40 or pwdin39_32 or 
			pwdin31_24 or pwdin23_16 or pwdin15_8 or pwdin7_0 or pwd_len or
			cid127_120 or cid119_112 or cid111_104 or cid103_96 or 
			cid95_88 or cid87_80 or cid79_72 or cid71_64 or 
			cid63_56 or cid55_48 or cid47_40 or cid39_32 or 
			cid31_24 or cid23_16 or cid15_8 or cid7_0 or 
			csd127_120 or csd119_112 or csd111_104 or csd103_96 or 
			csd95_88 or csd87_80 or csd79_72 or csd71_64 or 
			csd63_56 or csd55_48 or csd47_40 or csd39_32 or 
			csd31_24 or csd23_16 or csd15_8 or csd7_0 or 
			ecsd_a or ecsd_b31_24 or ecsd_b23_16 or 
			ecsd_b15_8 or ecsd_b7_0 or ecsd_c or ecsd_d or 
			ecsd_e or ecsd_f or ecsd_g or ecsd_h or ecsd_i or ecsd_j  or 
			ecsd_k or ecsd_l or ecsd_m or ecsd_n or 
			ecsd_o or ecsd_p or ecsd_q or ecsd_r_sync or ecsd_s_sync or 
			ocr_mem31_24 or ocr_mem23_16 or ocr_mem15_8 or ocr_mem7_0 or 
			scr63_56 or scr55_48 or scr47_40 or scr39_32 or scr31_24 or 
			scr23_16 or scr15_8 or scr7_0 or pwdin127_120_r or 
			pwdin119_112_r or pwdin111_104_r or pwdin103_96_r or 
			pwdin95_88_r or pwdin87_80_r or pwdin79_72_r or pwdin71_64_r or 
			pwdin63_56_r or pwdin55_48_r or pwdin47_40_r or pwdin39_32_r or
			pwdin31_24_r or pwdin23_16_r or pwdin15_8_r or pwdin7_0_r or 
			pwd_len_r or rd_thd_r or cid127_120_r   or cid119_112_r or 
			cid111_104_r or cid103_96_r or cid95_88_r or cid87_80_r or 
			cid79_72_r or cid71_64_r or cid63_56_r or cid55_48_r or 
			cid47_40_r or cid39_32_r or cid31_24_r or cid23_16_r or 
			cid15_8_r or cid7_0_r or csd127_120_r or csd119_112_r or 
			csd111_104_r or csd103_96_r or csd95_88_r or csd87_80_r or 
			csd79_72_r or csd71_64_r or csd63_56_r or csd55_48_r or
			csd47_40_r or csd39_32_r or csd31_24_r or csd23_16_r or 
			csd15_8_r or csd7_0_r or ecsd_a_r or ecsd_b31_24_r or 
			ecsd_b23_16_r or ecsd_b15_8_r or ecsd_b7_0_r or 
			ecsd_c_r or ecsd_d_r or ecsd_e_r or ecsd_f_r or 
			ecsd_g_r or ecsd_h_r or ecsd_i_r or ecsd_j_r or 
			ecsd_k_r or ecsd_l_r or ecsd_m_r or ecsd_n_r or 
			ecsd_o_r or ecsd_p_r or ecsd_q_r or ecsd_r_r or 
			ecsd_s_r or ocr_mem31_24_r or ocr_mem23_16_r or
			ocr_mem15_8_r or ocr_mem7_0_r or scr63_56_r or 
			scr55_48_r or scr47_40_r or scr39_32_r or scr31_24_r or 
scr23_16_r or scr15_8_r or scr7_0_r	or card_ecc_disabled or card_ecc_failed or rd_thd or dsr_l_r or dsr_h_r or dsr_sync)
begin
	case (1'b1)
	pwdin127_120_r 	:EXT_SFR_DIN<= pwdin127_120;
	pwdin119_112_r	:EXT_SFR_DIN<= pwdin119_112;
	pwdin111_104_r	:EXT_SFR_DIN<= pwdin111_104;
	pwdin103_96_r	:EXT_SFR_DIN<= pwdin103_96;
	pwdin95_88_r	:EXT_SFR_DIN<= pwdin95_88;
	pwdin87_80_r	:EXT_SFR_DIN<= pwdin87_80;
	pwdin79_72_r	:EXT_SFR_DIN<= pwdin79_72;
	pwdin71_64_r	:EXT_SFR_DIN<= pwdin71_64;
	pwdin63_56_r	:EXT_SFR_DIN<= pwdin63_56;
	pwdin55_48_r	:EXT_SFR_DIN<= pwdin55_48;
	pwdin47_40_r	:EXT_SFR_DIN<= pwdin47_40;
	pwdin39_32_r	:EXT_SFR_DIN<= pwdin39_32;
	pwdin31_24_r	:EXT_SFR_DIN<= pwdin31_24;
	pwdin23_16_r	:EXT_SFR_DIN<= pwdin23_16;
	pwdin15_8_r		:EXT_SFR_DIN<= pwdin15_8;
	pwdin7_0_r		:EXT_SFR_DIN<= pwdin7_0;
	
	pwd_len_r		:EXT_SFR_DIN<= pwd_len;
	
	rd_thd_r		:EXT_SFR_DIN<= {3'b000,card_ecc_disabled,card_ecc_failed,rd_thd };

	cid127_120_r	:EXT_SFR_DIN<= cid127_120;
	cid119_112_r	:EXT_SFR_DIN<= cid119_112;
	cid111_104_r	:EXT_SFR_DIN<= cid111_104;
	cid103_96_r		:EXT_SFR_DIN<= cid103_96;
	cid95_88_r 		:EXT_SFR_DIN<= cid95_88;
	cid87_80_r		:EXT_SFR_DIN<= cid87_80;
	cid79_72_r		:EXT_SFR_DIN<= cid79_72;
	cid71_64_r		:EXT_SFR_DIN<= cid71_64;
	cid63_56_r		:EXT_SFR_DIN<= cid63_56;
	cid55_48_r 		:EXT_SFR_DIN<= cid55_48;
	cid47_40_r 		:EXT_SFR_DIN<= cid47_40;
	cid39_32_r   	:EXT_SFR_DIN<= cid39_32;
	cid31_24_r		:EXT_SFR_DIN<= cid31_24;
	cid23_16_r 		:EXT_SFR_DIN<= cid23_16;
	cid15_8_r		:EXT_SFR_DIN<= cid15_8;
	cid7_0_r  		:EXT_SFR_DIN<= cid7_0;
	csd127_120_r	:EXT_SFR_DIN<= csd127_120;
	csd119_112_r	:EXT_SFR_DIN<= csd119_112;
	csd111_104_r	:EXT_SFR_DIN<= csd111_104;
	csd103_96_r		:EXT_SFR_DIN<= csd103_96;
	csd95_88_r 		:EXT_SFR_DIN<= csd95_88;
	csd87_80_r 		:EXT_SFR_DIN<= csd87_80;
	csd79_72_r 		:EXT_SFR_DIN<= csd79_72;
	csd71_64_r 		:EXT_SFR_DIN<= csd71_64;
	csd63_56_r 		:EXT_SFR_DIN<= csd63_56;
	csd55_48_r 		:EXT_SFR_DIN<= csd55_48;
	csd47_40_r 		:EXT_SFR_DIN<= csd47_40;
	csd39_32_r 		:EXT_SFR_DIN<= csd39_32;
	csd31_24_r 		:EXT_SFR_DIN<= csd31_24;
	csd23_16_r 		:EXT_SFR_DIN<= csd23_16;
	csd15_8_r  		:EXT_SFR_DIN<= csd15_8;
	csd7_0_r   		:EXT_SFR_DIN<= csd7_0;

	ecsd_a_r		:EXT_SFR_DIN<= ecsd_a;
	ecsd_b31_24_r	:EXT_SFR_DIN<= ecsd_b31_24;
	ecsd_b23_16_r	:EXT_SFR_DIN<= ecsd_b23_16;
	ecsd_b15_8_r	:EXT_SFR_DIN<= ecsd_b15_8;
	ecsd_b7_0_r		:EXT_SFR_DIN<= ecsd_b7_0;
	ecsd_c_r		:EXT_SFR_DIN<= ecsd_c;
	ecsd_d_r		:EXT_SFR_DIN<= ecsd_d;
	ecsd_e_r		:EXT_SFR_DIN<= ecsd_e;
	ecsd_f_r		:EXT_SFR_DIN<= ecsd_f;
	ecsd_g_r		:EXT_SFR_DIN<= ecsd_g;
	ecsd_h_r		:EXT_SFR_DIN<= ecsd_h;
	ecsd_i_r		:EXT_SFR_DIN<= ecsd_i;
	ecsd_j_r		:EXT_SFR_DIN<= ecsd_j;
	ecsd_k_r		:EXT_SFR_DIN<= ecsd_k;
	ecsd_l_r		:EXT_SFR_DIN<= ecsd_l;
	ecsd_m_r		:EXT_SFR_DIN<= ecsd_m;
	ecsd_n_r		:EXT_SFR_DIN<= ecsd_n;
	ecsd_o_r		:EXT_SFR_DIN<= ecsd_o;
	ecsd_p_r		:EXT_SFR_DIN<= ecsd_p;
	ecsd_q_r		:EXT_SFR_DIN<= ecsd_q;
	ecsd_r_r		:EXT_SFR_DIN<= ecsd_r_sync;
	ecsd_s_r		:EXT_SFR_DIN<= ecsd_s_sync;

	ocr_mem31_24_r	:EXT_SFR_DIN<= ocr_mem31_24;
	ocr_mem23_16_r	:EXT_SFR_DIN<= ocr_mem23_16;
	ocr_mem15_8_r	:EXT_SFR_DIN<= ocr_mem15_8;
	ocr_mem7_0_r	:EXT_SFR_DIN<= ocr_mem7_0;
	scr63_56_r		:EXT_SFR_DIN<= scr63_56;
	scr55_48_r		:EXT_SFR_DIN<= scr55_48;
	scr47_40_r	    :EXT_SFR_DIN<= scr47_40;
	scr39_32_r		:EXT_SFR_DIN<= scr39_32;
	scr31_24_r		:EXT_SFR_DIN<= scr31_24;
	scr23_16_r		:EXT_SFR_DIN<= scr23_16;
	scr15_8_r		:EXT_SFR_DIN<= scr15_8;
	scr7_0_r		:EXT_SFR_DIN<= scr7_0;
	dsr_l_r			:EXT_SFR_DIN<= dsr_sync[7:0];
	dsr_h_r			:EXT_SFR_DIN<= dsr_sync[15:8];
	default			:EXT_SFR_DIN<= 8'h00;

	endcase
end

endmodule
// sync logic
module RegIF_sync
(
	hreset_b,
	sdclk,
	card_ecc_disabled,
	card_ecc_failed,
	
	pwdin,	
	pwd_len,
	rd_thd,
	
	cid,					
	csd,				
	ecsd_a,
	ecsd_b,
	ecsd_c,
	ecsd_d,
	ecsd_e,
	ecsd_f,
	ecsd_g,
	ecsd_h,
	ecsd_i,
	ecsd_j,
	ecsd_k,
	ecsd_l,
	ecsd_m,
	ecsd_n,
	ecsd_o,
	ecsd_p,
	ecsd_q,
//	ecsd_r,
//	ecsd_s,
	ocr_mem,
	scr,

	card_ecc_disabled_sync,
	card_ecc_failed_sync,
	pwdin_sync,
	pwd_len_sync,
	rd_thd_sync,

	cid_sync	,					
	csd_sync	,				
	ecsd_a_sync ,
	ecsd_b_sync ,
	ecsd_c_sync ,
	ecsd_d_sync ,
	ecsd_e_sync ,
	ecsd_f_sync ,
	ecsd_g_sync ,
	ecsd_h_sync ,
	ecsd_i_sync ,
	ecsd_j_sync ,
	ecsd_k_sync ,
	ecsd_l_sync ,
	ecsd_m_sync ,
	ecsd_n_sync ,
	ecsd_o_sync ,
	ecsd_p_sync ,
	ecsd_q_sync ,
//	ecsd_r_sync ,
//	ecsd_s_sync ,
	ocr_mem_sync,
	scr_sync		
);

input			hreset_b;
input			sdclk;

input			card_ecc_disabled;
input			card_ecc_failed;
input	[127:0]	pwdin;	
input	[7:0]	pwd_len;
input	[2:0]	rd_thd;

input	[127:0]	cid;					
input	[127:0]	csd;				
input	[7:0]	ecsd_a;
input	[31:0]	ecsd_b;
input	[7:0]	ecsd_c;
input	[7:0]	ecsd_d;
input	[7:0]	ecsd_e;
input	[7:0]	ecsd_f;
input	[7:0]	ecsd_g;
input	[7:0]	ecsd_h;
input	[7:0]	ecsd_i;
input	[7:0]	ecsd_j;
input	[7:0]	ecsd_k;
input	[7:0]	ecsd_l;
input	[7:0]	ecsd_m;
input	[7:0]	ecsd_n;
input	[7:0]	ecsd_o;
input	[7:0]	ecsd_p;
input	[7:0]	ecsd_q;
//input	[7:0]	ecsd_r;
//input	[7:0]	ecsd_s;
input	[31:0] 	ocr_mem;	
input	[63:0] 	scr;

output			card_ecc_disabled_sync;
output			card_ecc_failed_sync;

output	[127:0]	pwdin_sync;	
output	[7:0]	pwd_len_sync;
output	[2:0]	rd_thd_sync;


output	[127:0]	cid_sync;	
output	[127:0]	csd_sync;	
output	[7:0]	ecsd_a_sync;
output	[31:0]	ecsd_b_sync;
output	[7:0]	ecsd_c_sync;
output	[7:0]	ecsd_d_sync;
output	[7:0]	ecsd_e_sync;
output	[7:0]	ecsd_f_sync;
output	[7:0]	ecsd_g_sync;
output	[7:0]	ecsd_h_sync;
output	[7:0]	ecsd_i_sync;
output	[7:0]	ecsd_j_sync;
output	[7:0]	ecsd_k_sync;
output	[7:0]	ecsd_l_sync;
output	[7:0]	ecsd_m_sync;
output	[7:0]	ecsd_n_sync;
output	[7:0]	ecsd_o_sync;
output	[7:0]	ecsd_p_sync;
output	[7:0]	ecsd_q_sync;
//output	[7:0]	ecsd_r_sync;
//output	[7:0]	ecsd_s_sync;
output	[31:0] 	ocr_mem_sync;
output	[63:0] 	scr_sync;


reg	card_ecc_disabled_sync;
reg card_ecc_failed_sync;
reg	[127:0]	pwdin_sync;	
reg	[7:0]	pwd_len_sync;
reg	[2:0]	rd_thd_sync;

reg	[127:0]	cid_sync;	
reg	[127:0]	csd_sync;	
reg	[7:0]	ecsd_a_sync;
reg	[31:0]	ecsd_b_sync;
reg	[7:0]	ecsd_c_sync;
reg	[7:0]	ecsd_d_sync;
reg	[7:0]	ecsd_e_sync;
reg	[7:0]	ecsd_f_sync;
reg	[7:0]	ecsd_g_sync;
reg	[7:0]	ecsd_h_sync;
reg	[7:0]	ecsd_i_sync;
reg	[7:0]	ecsd_j_sync;
reg	[7:0]	ecsd_k_sync;
reg	[7:0]	ecsd_l_sync;
reg	[7:0]	ecsd_m_sync;
reg	[7:0]	ecsd_n_sync;
reg	[7:0]	ecsd_o_sync;
reg	[7:0]	ecsd_p_sync;
reg	[7:0]	ecsd_q_sync;
//reg	[7:0]	ecsd_r_sync;
//reg	[7:0]	ecsd_s_sync;
reg	[31:0] 	ocr_mem_sync;
reg	[63:0] 	scr_sync;


reg	card_ecc_disabled_sync1;
reg	card_ecc_failed_sync1;
reg	[127:0]	pwdin_sync1;	
reg	[7:0]	pwd_len_sync1;
reg	[2:0]	rd_thd_sync1;

reg	[127:0]	cid_sync1;	
reg	[127:0]	csd_sync1;	
reg	[7:0]	ecsd_a_sync1;
reg	[31:0]	ecsd_b_sync1;
reg	[7:0]	ecsd_c_sync1;
reg	[7:0]	ecsd_d_sync1;
reg	[7:0]	ecsd_e_sync1;
reg	[7:0]	ecsd_f_sync1;
reg	[7:0]	ecsd_g_sync1;
reg	[7:0]	ecsd_h_sync1;
reg	[7:0]	ecsd_i_sync1;
reg	[7:0]	ecsd_j_sync1;
reg	[7:0]	ecsd_k_sync1;
reg	[7:0]	ecsd_l_sync1;
reg	[7:0]	ecsd_m_sync1;
reg	[7:0]	ecsd_n_sync1;
reg	[7:0]	ecsd_o_sync1;
reg	[7:0]	ecsd_p_sync1;
reg	[7:0]	ecsd_q_sync1;
//reg	[7:0]	ecsd_r_sync1;
//reg	[7:0]	ecsd_s_sync1;
reg	[31:0] 	ocr_mem_sync1;
reg	[63:0] 	scr_sync1;


always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	card_ecc_disabled_sync1 <= 0;
	else
	card_ecc_disabled_sync1 <= card_ecc_disabled;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	card_ecc_disabled_sync <= 0;
	else
	card_ecc_disabled_sync <= card_ecc_disabled_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	card_ecc_failed_sync1 <= 0;
	else
	card_ecc_failed_sync1 <= card_ecc_failed;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	card_ecc_failed_sync <= 0;
	else
	card_ecc_failed_sync <= card_ecc_failed_sync1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	pwdin_sync1 <= 0;
	else
	pwdin_sync1 <= pwdin;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	pwdin_sync <= 0;
	else
	pwdin_sync <= pwdin_sync1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	pwd_len_sync1 <= 0;
	else
	pwd_len_sync1 <= pwd_len;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	pwd_len_sync <= 0;
	else
	pwd_len_sync <= pwd_len_sync1;
end


always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	rd_thd_sync1 <= 0;
	else
	rd_thd_sync1 <= rd_thd;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	rd_thd_sync <= 0;
	else
	rd_thd_sync <= rd_thd_sync1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	cid_sync1 <= 0;
	else
	cid_sync1 <= cid;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	cid_sync <= 0;
	else
	cid_sync <= cid_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	csd_sync1 <= 0;
	else
	csd_sync1 <= csd;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	csd_sync <= 0;
	else
	csd_sync <= csd_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_a_sync1 <= 0;
	else
	ecsd_a_sync1 <= ecsd_a;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_a_sync <= 0;
	else
	ecsd_a_sync <= ecsd_a_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_b_sync1 <= 0;
	else
	ecsd_b_sync1 <= ecsd_b;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_b_sync <= 0;
	else
	ecsd_b_sync <= ecsd_b_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_c_sync1 <= 0;
	else
	ecsd_c_sync1 <= ecsd_c;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_c_sync <= 0;
	else
	ecsd_c_sync <= ecsd_c_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_d_sync1 <= 0;
	else
	ecsd_d_sync1 <= ecsd_d;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_d_sync <= 0;
	else
	ecsd_d_sync <= ecsd_d_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_e_sync1 <= 0;
	else
	ecsd_e_sync1 <= ecsd_e;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_e_sync <= 0;
	else
	ecsd_e_sync <= ecsd_e_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_f_sync1 <= 0;
	else
	ecsd_f_sync1 <= ecsd_f;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_f_sync <= 0;
	else
	ecsd_f_sync <= ecsd_f_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_g_sync1 <= 0;
	else
	ecsd_g_sync1 <= ecsd_g;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_g_sync <= 0;
	else
	ecsd_g_sync <= ecsd_g_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_h_sync1 <= 0;
	else
	ecsd_h_sync1 <= ecsd_h;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_h_sync <= 0;
	else
	ecsd_h_sync <= ecsd_h_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_i_sync1 <= 0;
	else
	ecsd_i_sync1 <= ecsd_i;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_i_sync <= 0;
	else
	ecsd_i_sync <= ecsd_i_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_j_sync1 <= 0;
	else
	ecsd_j_sync1 <= ecsd_j;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_j_sync <= 0;
	else
	ecsd_j_sync <= ecsd_j_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_k_sync1 <= 0;
	else
	ecsd_k_sync1 <= ecsd_k;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_k_sync <= 0;
	else
	ecsd_k_sync <= ecsd_k_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_l_sync1 <= 0;
	else
	ecsd_l_sync1 <= ecsd_l;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_l_sync <= 0;
	else
	ecsd_l_sync <= ecsd_l_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_m_sync1 <= 0;
	else
	ecsd_m_sync1 <= ecsd_m;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_m_sync <= 0;
	else
	ecsd_m_sync <= ecsd_m_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_n_sync1 <= 0;
	else
	ecsd_n_sync1 <= ecsd_n;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_n_sync <= 0;
	else
	ecsd_n_sync <= ecsd_n_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_o_sync1 <= 0;
	else
	ecsd_o_sync1 <= ecsd_o;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_o_sync <= 0;
	else
	ecsd_o_sync <= ecsd_o_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_p_sync1 <= 0;
	else
	ecsd_p_sync1 <= ecsd_p;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_p_sync <= 0;
	else
	ecsd_p_sync <= ecsd_p_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_q_sync1 <= 0;
	else
	ecsd_q_sync1 <= ecsd_q;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_q_sync <= 0;
	else
	ecsd_q_sync <= ecsd_q_sync1;
end

/*always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_r_sync1 <= 0;
	else
	ecsd_r_sync1 <= ecsd_r;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_r_sync <= 0;
	else
	ecsd_r_sync <= ecsd_r_sync1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_s_sync1 <= 0;
	else
	ecsd_s_sync1 <= ecsd_s;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ecsd_s_sync <= 0;
	else
	ecsd_s_sync <= ecsd_s_sync1;
end
*/
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ocr_mem_sync1 <= 0;
	else
	ocr_mem_sync1 <= ocr_mem;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	ocr_mem_sync <= 0;
	else
	ocr_mem_sync <= ocr_mem_sync1;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	scr_sync1 <= 0;
	else
	scr_sync1 <= scr;
end
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	scr_sync <= 0;
	else
	scr_sync <= scr_sync1;
end
endmodule

