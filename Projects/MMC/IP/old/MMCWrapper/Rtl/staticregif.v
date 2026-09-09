module staticregif
(
	RESETn,
	CLK,

	FA,
	FO,
	NFSRWE,
	NFSROE,
	MMC_FI,

	card_ecc_disabled,
	card_ecc_failed,
	
	dsr,			
	hreset_b,
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
	ocr_mem,
	scr
);

input			RESETn;
input			CLK;

input	[7:0]	FA;
input	[7:0]	FO;
input			NFSRWE;
input			NFSROE;
output	[7:0]	MMC_FI;

output			card_ecc_disabled;
output			card_ecc_failed;
input	[15:0]	dsr;			
output			hreset_b;
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
reg	[7:0]	pwd_len;
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

reg [7:0]	ecsd_a;
reg [7:0]	ecsd_b31_24;
reg [7:0]	ecsd_b23_16;
reg [7:0]	ecsd_b15_8;
reg [7:0]	ecsd_b7_0;
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

reg [7:0]	ocr_mem31_24;
reg [7:0]	ocr_mem23_16;
reg [7:0]	ocr_mem15_8;
reg [7:0]	ocr_mem7_0;
reg [7:0]	scr63_56;
reg [7:0]	scr55_48;
reg [7:0]	scr47_40;
reg [7:0]	scr39_32;
reg [7:0]	scr31_24;
reg [7:0]	scr23_16;
reg [7:0]	scr15_8;
reg [7:0]	scr7_0;

reg [7:0]	MMC_FI;
reg [7:0]	NextMMC_FI;

`define PWDIN127_120_ADDR	8'b00000000
`define PWDIN119_112_ADDR	8'b00000000
`define PWDIN111_104_ADDR	8'b00000000
`define PWDIN103_96_ADDR 	8'b00000000
`define PWDIN95_88_ADDR	 	8'b00000000 
`define PWDIN87_80_ADDR	 	8'b00000000 
`define PWDIN79_72_ADDR	 	8'b00000000
`define PWDIN71_64_ADDR 	8'b00000000
`define PWDIN63_56_ADDR 	8'b00000000
`define PWDIN55_48_ADDR 	8'b00000000
`define PWDIN47_40_ADDR 	8'b00000000
`define PWDIN39_32_ADDR		8'b00000000 
`define PWDIN31_24_ADDR		8'b00000000 
`define PWDIN23_16_ADDR		8'b00000000	 
`define PWDIN15_8_ADDR		8'b00000000
`define PWDIN7_0_ADDR		8'b00000000	 
`define PWD_LEN_ADDR		8'b00000000
`define PWD_LEN_ADDR		8'b00000000

`define RD_THD_ADDR         8'b00000000

`define CID127_120_ADDR		8'b00000000
`define CID119_112_ADDR     8'b00000000
`define CID111_104_ADDR     8'b00000000
`define CID103_96_ADDR      8'b00000000
`define CID95_88_ADDR       8'b00000000
`define CID87_80_ADDR       8'b00000000
`define CID79_72_ADDR       8'b00000000
`define CID71_64_ADDR		8'b00000000
`define CID63_56_ADDR       8'b00000000
`define CID55_48_ADDR       8'b00000000
`define CID47_40_ADDR       8'b00000000
`define CID39_32_ADDR       8'b00000000
`define CID31_24_ADDR       8'b00000000
`define CID23_16_ADDR       8'b00000000
`define CID15_8_ADDR		8'b00000000
`define CID7_0_ADDR         8'b00000000

`define CSD127_120_ADDR     8'b00000000
`define CSD119_112_ADDR     8'b00000000
`define CSD111_104_ADDR     8'b00000000
`define CSD103_96_ADDR      8'b00000000
`define CSD95_88_ADDR		8'b00000000
`define CSD87_80_ADDR       8'b00000000
`define CSD79_72_ADDR       8'b00000000
`define CSD71_64_ADDR       8'b00000000
`define CSD63_56_ADDR       8'b00000000
`define CSD55_48_ADDR       8'b00000000
`define CSD47_40_ADDR       8'b00000000
`define CSD39_32_ADDR		8'b00000000
`define CSD31_24_ADDR       8'b00000000
`define CSD23_16_ADDR       8'b00000000
`define CSD15_8_ADDR        8'b00000000
`define CSD7_0_ADDR         8'b00000000

`define ECSD_A_ADDR		    8'b00000000
`define ECSD_B31_24_ADDR	8'b00000000 
`define ECSD_B23_16_ADDR	8'b00000000 
`define ECSD_B15_8_ADDR	    8'b00000000
`define ECSD_B7_0_ADDR	    8'b00000000
`define ECSD_C_ADDR	        8'b00000000
`define ECSD_D_ADDR	        8'b00000000
`define ECSD_E_ADDR		    8'b00000000
`define ECSD_F_ADDR			8'b00000000 
`define ECSD_G_ADDR		    8'b00000000
`define ECSD_H_ADDR		    8'b00000000
`define ECSD_I_ADDR		    8'b00000000
`define ECSD_J_ADDR		    8'b00000000
`define ECSD_K_ADDR		    8'b00000000
`define ECSD_L_ADDR		    8'b00000000
`define ECSD_M_ADDR		 	8'b00000000
`define ECSD_N_ADDR		    8'b00000000
`define ECSD_O_ADDR		    8'b00000000
`define ECSD_P_ADDR		    8'b00000000
`define ECSD_Q_ADDR		    8'b00000000

`define OCR_MEM31_24_ADDR   8'b00000000
`define OCR_MEM23_16_ADDR 	8'b00000000
`define OCR_MEM15_8_ADDR    8'b00000000
`define OCR_MEM7_0_ADDR	    8'b00000000
`define SCR63_56_ADDR	    8'b00000000
`define SCR55_48_ADDR	    8'b00000000
`define SCR47_40_ADDR	    8'b00000000
`define SCR39_32_ADDR	    8'b00000000
`define SCR31_24_ADDR		8'b00000000 
`define SCR23_16_ADDR	    8'b00000000
`define SCR15_8_ADDR		8'b00000000 
`define SCR7_0_ADDR		    8'b00000000


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

assign	pwdin127_120_w 	= (FA==`PWDIN127_120_ADDR) & (NFSRWE==0);
assign	pwdin119_112_w	= (FA==`PWDIN119_112_ADDR) & (NFSRWE==0);
assign	pwdin111_104_w	= (FA==`PWDIN111_104_ADDR) & (NFSRWE==0);
assign	pwdin103_96_w	= (FA==`PWDIN103_96_ADDR ) & (NFSRWE==0);
assign	pwdin95_88_w	= (FA==`PWDIN95_88_ADDR	 ) & (NFSRWE==0);
assign	pwdin87_80_w	= (FA==`PWDIN87_80_ADDR	 ) & (NFSRWE==0);
assign	pwdin79_72_w	= (FA==`PWDIN79_72_ADDR	 ) & (NFSRWE==0);
assign	pwdin71_64_w	= (FA==`PWDIN71_64_ADDR	 ) & (NFSRWE==0);
assign	pwdin63_56_w	= (FA==`PWDIN63_56_ADDR	 ) & (NFSRWE==0);
assign	pwdin55_48_w	= (FA==`PWDIN55_48_ADDR	 ) & (NFSRWE==0);
assign	pwdin47_40_w	= (FA==`PWDIN47_40_ADDR	 ) & (NFSRWE==0);
assign	pwdin39_32_w	= (FA==`PWDIN39_32_ADDR	 ) & (NFSRWE==0);
assign	pwdin31_24_w	= (FA==`PWDIN31_24_ADDR	 ) & (NFSRWE==0);
assign	pwdin23_16_w	= (FA==`PWDIN23_16_ADDR	 ) & (NFSRWE==0);
assign	pwdin15_8_w		= (FA==`PWDIN15_8_ADDR	 ) & (NFSRWE==0);
assign	pwdin7_0_w		= (FA==`PWDIN7_0_ADDR	 ) & (NFSRWE==0);
assign	pwd_len_w 		= (FA==`PWD_LEN_ADDR	 ) & (NFSRWE==0);
assign	rd_thd_w		= (FA==`RD_THD_ADDR		 ) & (NFSRWE==0);
assign	cid127_120_w	= (FA==`CID127_120_ADDR	 ) & (NFSRWE==0);
assign	cid119_112_w	= (FA==`CID119_112_ADDR	 ) & (NFSRWE==0);
assign	cid111_104_w	= (FA==`CID111_104_ADDR	 ) & (NFSRWE==0);	
assign	cid103_96_w		= (FA==`CID103_96_ADDR	 ) & (NFSRWE==0); 	
assign	cid95_88_w 		= (FA==`CID95_88_ADDR	 ) & (NFSRWE==0);	
assign	cid87_80_w		= (FA==`CID87_80_ADDR	 ) & (NFSRWE==0);	
assign	cid79_72_w		= (FA==`CID79_72_ADDR	 ) & (NFSRWE==0);	
assign	cid71_64_w		= (FA==`CID71_64_ADDR	 ) & (NFSRWE==0);	
assign	cid63_56_w		= (FA==`CID63_56_ADDR	 ) & (NFSRWE==0);	
assign	cid55_48_w 		= (FA==`CID55_48_ADDR	 ) & (NFSRWE==0);	
assign	cid47_40_w 		= (FA==`CID47_40_ADDR	 ) & (NFSRWE==0);	
assign	cid39_32_w   	= (FA==`CID39_32_ADDR	 ) & (NFSRWE==0);	
assign	cid31_24_w		= (FA==`CID31_24_ADDR	 ) & (NFSRWE==0); 	
assign	cid23_16_w 		= (FA==`CID23_16_ADDR	 ) & (NFSRWE==0); 	
assign	cid15_8_w		= (FA==`CID15_8_ADDR	 ) & (NFSRWE==0); 	
assign	cid7_0_w  		= (FA==`CID7_0_ADDR		 ) & (NFSRWE==0);
assign	csd127_120_w	= (FA==`CSD127_120_ADDR	 ) & (NFSRWE==0);
assign	csd119_112_w	= (FA==`CSD119_112_ADDR	 ) & (NFSRWE==0);	
assign	csd111_104_w	= (FA==`CSD111_104_ADDR	 ) & (NFSRWE==0);	
assign	csd103_96_w		= (FA==`CSD103_96_ADDR	 ) & (NFSRWE==0); 	
assign	csd95_88_w 		= (FA==`CSD95_88_ADDR	 ) & (NFSRWE==0); 	
assign	csd87_80_w 		= (FA==`CSD87_80_ADDR	 ) & (NFSRWE==0); 	
assign	csd79_72_w 		= (FA==`CSD79_72_ADDR	 ) & (NFSRWE==0); 	
assign	csd71_64_w 		= (FA==`CSD71_64_ADDR	 ) & (NFSRWE==0); 	
assign	csd63_56_w 		= (FA==`CSD63_56_ADDR	 ) & (NFSRWE==0); 	
assign	csd55_48_w 		= (FA==`CSD55_48_ADDR	 ) & (NFSRWE==0); 	
assign	csd47_40_w 		= (FA==`CSD47_40_ADDR	 ) & (NFSRWE==0); 	
assign	csd39_32_w 		= (FA==`CSD39_32_ADDR	 ) & (NFSRWE==0); 	
assign	csd31_24_w 		= (FA==`CSD31_24_ADDR	 ) & (NFSRWE==0); 	
assign	csd23_16_w 		= (FA==`CSD23_16_ADDR	 ) & (NFSRWE==0); 	
assign	csd15_8_w  		= (FA==`CSD15_8_ADDR	 ) & (NFSRWE==0); 
assign	csd7_0_w   		= (FA==`CSD7_0_ADDR		 ) & (NFSRWE==0); 
assign	ecsd_a_w		= (FA==`ECSD_A_ADDR		 ) & (NFSRWE==0);
assign	ecsd_b31_24_w	= (FA==`ECSD_B31_24_ADDR	 ) & (NFSRWE==0);
assign	ecsd_b23_16_w	= (FA==`ECSD_B23_16_ADDR	 ) & (NFSRWE==0);
assign	ecsd_b15_8_w	= (FA==`ECSD_B15_8_ADDR	 ) & (NFSRWE==0);
assign	ecsd_b7_0_w		= (FA==`ECSD_B7_0_ADDR	 ) & (NFSRWE==0);
assign	ecsd_c_w		= (FA==`ECSD_C_ADDR		 ) & (NFSRWE==0);
assign	ecsd_d_w		= (FA==`ECSD_D_ADDR		 ) & (NFSRWE==0);
assign	ecsd_e_w		= (FA==`ECSD_E_ADDR		 ) & (NFSRWE==0);	
assign	ecsd_f_w		= (FA==`ECSD_F_ADDR		 ) & (NFSRWE==0);	
assign	ecsd_g_w		= (FA==`ECSD_G_ADDR		 ) & (NFSRWE==0);
assign	ecsd_h_w		= (FA==`ECSD_H_ADDR		 ) & (NFSRWE==0);
assign	ecsd_i_w		= (FA==`ECSD_I_ADDR		 ) & (NFSRWE==0);
assign	ecsd_j_w		= (FA==`ECSD_J_ADDR		 ) & (NFSRWE==0);
assign	ecsd_k_w		= (FA==`ECSD_K_ADDR		 ) & (NFSRWE==0);
assign	ecsd_l_w		= (FA==`ECSD_L_ADDR		 ) & (NFSRWE==0);
assign	ecsd_m_w		= (FA==`ECSD_M_ADDR		 ) & (NFSRWE==0);
assign	ecsd_n_w		= (FA==`ECSD_N_ADDR		 ) & (NFSRWE==0);
assign	ecsd_o_w		= (FA==`ECSD_O_ADDR		 ) & (NFSRWE==0);
assign	ecsd_p_w		= (FA==`ECSD_P_ADDR		 ) & (NFSRWE==0);
assign	ecsd_q_w		= (FA==`ECSD_Q_ADDR		 ) & (NFSRWE==0);
                                               
assign	ocr_mem31_24_w	= (FA==`OCR_MEM31_24_ADDR ) & (NFSRWE==0);
assign	ocr_mem23_16_w	= (FA==`OCR_MEM23_16_ADDR ) & (NFSRWE==0);
assign	ocr_mem15_8_w	= (FA==`OCR_MEM15_8_ADDR  ) & (NFSRWE==0);
assign	ocr_mem7_0_w	= (FA==`OCR_MEM7_0_ADDR	 ) & (NFSRWE==0);
assign	scr63_56_w		= (FA==`SCR63_56_ADDR	 ) & (NFSRWE==0);
assign	scr55_48_w		= (FA==`SCR55_48_ADDR	 ) & (NFSRWE==0);
assign	scr47_40_w	    = (FA==`SCR47_40_ADDR	 ) & (NFSRWE==0);
assign	scr39_32_w		= (FA==`SCR39_32_ADDR	 ) & (NFSRWE==0);
assign	scr31_24_w		= (FA==`SCR31_24_ADDR	 ) & (NFSRWE==0);
assign	scr23_16_w		= (FA==`SCR23_16_ADDR	 ) & (NFSRWE==0);
assign	scr15_8_w		= (FA==`SCR15_8_ADDR		 ) & (NFSRWE==0);
assign	scr7_0_w		= (FA==`SCR7_0_ADDR		 ) & (NFSRWE==0);


assign	pwdin127_120_r 	= (FA==`PWDIN127_120_ADDR) & (NFSROE==0);
assign	pwdin119_112_r	= (FA==`PWDIN119_112_ADDR) & (NFSROE==0);
assign	pwdin111_104_r	= (FA==`PWDIN111_104_ADDR) & (NFSROE==0);
assign	pwdin103_96_r	= (FA==`PWDIN103_96_ADDR ) & (NFSROE==0);
assign	pwdin95_88_r	= (FA==`PWDIN95_88_ADDR  ) & (NFSROE==0);
assign	pwdin87_80_r	= (FA==`PWDIN87_80_ADDR  ) & (NFSROE==0);
assign	pwdin79_72_r	= (FA==`PWDIN79_72_ADDR  ) & (NFSROE==0);
assign	pwdin71_64_r	= (FA==`PWDIN71_64_ADDR  ) & (NFSROE==0);
assign	pwdin63_56_r	= (FA==`PWDIN63_56_ADDR  ) & (NFSROE==0);
assign	pwdin55_48_r	= (FA==`PWDIN55_48_ADDR  ) & (NFSROE==0);
assign	pwdin47_40_r	= (FA==`PWDIN47_40_ADDR  ) & (NFSROE==0);
assign	pwdin39_32_r	= (FA==`PWDIN39_32_ADDR  ) & (NFSROE==0);
assign	pwdin31_24_r	= (FA==`PWDIN31_24_ADDR  ) & (NFSROE==0);
assign	pwdin23_16_r	= (FA==`PWDIN23_16_ADDR  ) & (NFSROE==0);
assign	pwdin15_8_r		= (FA==`PWDIN15_8_ADDR   ) & (NFSROE==0);
assign	pwdin7_0_r		= (FA==`PWDIN7_0_ADDR    ) & (NFSROE==0);
assign	pwd_len_r 		= (FA==`PWD_LEN_ADDR     ) & (NFSROE==0);
assign	rd_thd_r		= (FA==`RD_THD_ADDR      ) & (NFSROE==0);
assign	cid127_120_r	= (FA==`CID127_120_ADDR  ) & (NFSROE==0);	
assign	cid119_112_r	= (FA==`CID119_112_ADDR  ) & (NFSROE==0);	
assign	cid111_104_r	= (FA==`CID111_104_ADDR  ) & (NFSROE==0);	
assign	cid103_96_r		= (FA==`CID103_96_ADDR   ) & (NFSROE==0); 	
assign	cid95_88_r 		= (FA==`CID95_88_ADDR	 ) & (NFSROE==0);	
assign	cid87_80_r		= (FA==`CID87_80_ADDR    ) & (NFSROE==0);	
assign	cid79_72_r		= (FA==`CID79_72_ADDR    ) & (NFSROE==0);	
assign	cid71_64_r		= (FA==`CID71_64_ADDR    ) & (NFSROE==0);	
assign	cid63_56_r		= (FA==`CID63_56_ADDR    ) & (NFSROE==0);	
assign	cid55_48_r 		= (FA==`CID55_48_ADDR    ) & (NFSROE==0);	
assign	cid47_40_r 		= (FA==`CID47_40_ADDR    ) & (NFSROE==0);	
assign	cid39_32_r   	= (FA==`CID39_32_ADDR    ) & (NFSROE==0);	
assign	cid31_24_r		= (FA==`CID31_24_ADDR    ) & (NFSROE==0);	
assign	cid23_16_r 		= (FA==`CID23_16_ADDR    ) & (NFSROE==0);	
assign	cid15_8_r		= (FA==`CID15_8_ADDR     ) & (NFSROE==0); 	
assign	cid7_0_r  		= (FA==`CID7_0_ADDR      ) & (NFSROE==0); 	
assign	csd127_120_r	= (FA==`CSD127_120_ADDR  ) & (NFSROE==0); 	
assign	csd119_112_r	= (FA==`CSD119_112_ADDR  ) & (NFSROE==0); 	
assign	csd111_104_r	= (FA==`CSD111_104_ADDR  ) & (NFSROE==0); 	
assign	csd103_96_r		= (FA==`CSD103_96_ADDR   ) & (NFSROE==0);
assign	csd95_88_r 		= (FA==`CSD95_88_ADDR    ) & (NFSROE==0);	
assign	csd87_80_r 		= (FA==`CSD87_80_ADDR    ) & (NFSROE==0);
assign	csd79_72_r 		= (FA==`CSD79_72_ADDR    ) & (NFSROE==0);
assign	csd71_64_r 		= (FA==`CSD71_64_ADDR    ) & (NFSROE==0);
assign	csd63_56_r 		= (FA==`CSD63_56_ADDR    ) & (NFSROE==0);
assign	csd55_48_r 		= (FA==`CSD55_48_ADDR    ) & (NFSROE==0);
assign	csd47_40_r 		= (FA==`CSD47_40_ADDR    ) & (NFSROE==0);
assign	csd39_32_r 		= (FA==`CSD39_32_ADDR    ) & (NFSROE==0); 
assign	csd31_24_r 		= (FA==`CSD31_24_ADDR	 ) & (NFSROE==0); 	
assign	csd23_16_r 		= (FA==`CSD23_16_ADDR	 ) & (NFSROE==0); 	
assign	csd15_8_r  		= (FA==`CSD15_8_ADDR	 ) & (NFSROE==0); 	
assign	csd7_0_r   		= (FA==`CSD7_0_ADDR  	 ) & (NFSROE==0); 	
assign	ecsd_a_r		= (FA==`ECSD_A_ADDR		 ) & (NFSROE==0);
assign	ecsd_b31_24_r	= (FA==`ECSD_B31_24_ADDR ) & (NFSROE==0);
assign	ecsd_b23_16_r	= (FA==`ECSD_B23_16_ADDR ) & (NFSROE==0);
assign	ecsd_b15_8_r	= (FA==`ECSD_B15_8_ADDR	 ) & (NFSROE==0);
assign	ecsd_b7_0_r		= (FA==`ECSD_B7_0_ADDR	 ) & (NFSROE==0);
assign	ecsd_c_r		= (FA==`ECSD_C_ADDR		 ) & (NFSROE==0);
assign	ecsd_d_r		= (FA==`ECSD_D_ADDR		 ) & (NFSROE==0);
assign	ecsd_e_r		= (FA==`ECSD_E_ADDR		 ) & (NFSROE==0);	
assign	ecsd_f_r		= (FA==`ECSD_F_ADDR		 ) & (NFSROE==0);	
assign	ecsd_g_r		= (FA==`ECSD_G_ADDR		 ) & (NFSROE==0);
assign	ecsd_h_r		= (FA==`ECSD_H_ADDR		 ) & (NFSROE==0);
assign	ecsd_i_r		= (FA==`ECSD_I_ADDR		 ) & (NFSROE==0);
assign	ecsd_j_r		= (FA==`ECSD_J_ADDR		 ) & (NFSROE==0);
assign	ecsd_k_r		= (FA==`ECSD_K_ADDR		 ) & (NFSROE==0);
assign	ecsd_l_r		= (FA==`ECSD_L_ADDR		 ) & (NFSROE==0);
assign	ecsd_m_r		= (FA==`ECSD_M_ADDR		 ) & (NFSROE==0);
assign	ecsd_n_r		= (FA==`ECSD_N_ADDR		 ) & (NFSROE==0);
assign	ecsd_o_r		= (FA==`ECSD_O_ADDR		 ) & (NFSROE==0);
assign	ecsd_p_r		= (FA==`ECSD_P_ADDR		 ) & (NFSROE==0);
assign	ecsd_q_r		= (FA==`ECSD_Q_ADDR		 ) & (NFSROE==0);
                                              
assign	ocr_mem31_24_r	= (FA==`OCR_MEM31_24_ADDR) & (NFSROE==0);
assign	ocr_mem23_16_r	= (FA==`OCR_MEM23_16_ADDR) & (NFSROE==0);
assign	ocr_mem15_8_r	= (FA==`OCR_MEM15_8_ADDR ) & (NFSROE==0);
assign	ocr_mem7_0_r	= (FA==`OCR_MEM7_0_ADDR	 ) & (NFSROE==0);
assign	scr63_56_r		= (FA==`SCR63_56_ADDR	 ) & (NFSROE==0);
assign	scr55_48_r		= (FA==`SCR55_48_ADDR	 ) & (NFSROE==0);
assign	scr47_40_r	    = (FA==`SCR47_40_ADDR	 ) & (NFSROE==0);
assign	scr39_32_r		= (FA==`SCR39_32_ADDR	 ) & (NFSROE==0);
assign	scr31_24_r		= (FA==`SCR31_24_ADDR	 ) & (NFSROE==0);
assign	scr23_16_r		= (FA==`SCR23_16_ADDR	 ) & (NFSROE==0);
assign	scr15_8_r		= (FA==`SCR15_8_ADDR	 ) & (NFSROE==0);
assign	scr7_0_r		= (FA==`SCR7_0_ADDR		 ) & (NFSROE==0);
    /*           
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_disabled;
	else if ()
	card_ecc_disabled;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_failed;
	else if ()
	card_ecc_failed;
end*/
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin127_120 <= 0;
	else if (pwdin127_120_w)
	pwdin127_120 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin119_112 <= 0;
	else if (pwdin119_112_w)
	pwdin119_112 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin111_104 <= 0;
	else if (pwdin111_104_w)
	pwdin111_104 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin103_96 <= 0;
	else if (pwdin103_96_w)
	pwdin103_96 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin95_88 <= 0;
	else if (pwdin95_88_w)
	pwdin95_88 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin87_80 <= 0;
	else if (pwdin87_80_w)
	pwdin87_80 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin79_72 <= 0;
	else if (pwdin79_72_w)
	pwdin79_72 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin71_64 <= 0;
	else if (pwdin71_64_w)
	pwdin71_64 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin63_56 <= 0;
	else if (pwdin71_64_w)
	pwdin63_56 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin55_48 <= 0;
	else if (pwdin55_48_w)
	pwdin55_48 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin47_40 <= 0;
	else if (pwdin47_40_w)
	pwdin47_40 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin39_32 <= 0;
	else if (pwdin39_32_w)
	pwdin39_32 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin31_24 <= 0;
	else if (pwdin31_24_w)
	pwdin31_24 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin23_16 <= 0;
	else if (pwdin23_16_w)
	pwdin23_16 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin15_8 <= 0;
	else if (pwdin15_8_w)
	pwdin15_8 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwdin7_0 <= 0;
	else if (pwdin7_0_w)
	pwdin7_0 <= FO;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	pwd_len <= 0; 
	else if (pwd_len_w)
	pwd_len <= FO;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid127_120 <= 0;
	else if (cid127_120_w)
	cid127_120 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid119_112 <= 0;
	else if (cid119_112_w)
	cid119_112 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid111_104 <= 0;
	else if (cid111_104_w)
	cid111_104 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid103_96	<= 0;
	else if (cid103_96_w)
	cid103_96	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid95_88	<= 0;
	else if (cid95_88_w)
	cid95_88	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid87_80	<= 0;
	else if (cid87_80_w)
	cid87_80	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid79_72	<= 0;
	else if (cid79_72_w)
	cid79_72	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid71_64	<= 0;
	else if (cid71_64_w)
	cid71_64	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid63_56	<= 0;
	else if (cid63_56_w)
	cid63_56	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid55_48	<= 0;
	else if (cid55_48_w)
	cid55_48	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid47_40	<= 0;
	else if (cid47_40_w)
	cid47_40	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid39_32	<= 0;
	else if (cid39_32_w)
	cid39_32	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid31_24	<= 0;
	else if (cid31_24_w)
	cid31_24	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid23_16	<= 0;
	else if (cid23_16_w)
	cid23_16	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid15_8		<=	0;
	else if (cid15_8_w)
	cid15_8		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cid7_0		<= 0;
	else if (cid7_0_w)
	cid7_0		<= FO;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd127_120	<= 0;
	else if (csd127_120_w)
	csd127_120		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd119_112	<= 0;
	else if (csd119_112_w)
	csd119_112		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd111_104	<= 0;
	else if (csd111_104_w)
	csd111_104		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd103_96	<= 0;
	else if (csd103_96_w)
	csd103_96		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd95_88	<= 0;
	else if (csd95_88_w)
	csd95_88		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd87_80	<= 0;
	else if (csd87_80_w)
	csd87_80		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd79_72	<= 0;
	else if (csd79_72_w)
	csd79_72		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd71_64	<= 0;
	else if (csd71_64_w)
	csd71_64		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd63_56	<= 0;
	else if (csd63_56_w)
	csd63_56		<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd55_48<= 0;
	else if (csd55_48_w)
	csd55_48<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd47_40<= 0;
	else if (csd47_40_w)
	csd47_40<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd39_32<= 0;
	else if (csd39_32_w)
	csd39_32<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd31_24<= 0;
	else if (csd31_24_w)
	csd31_24<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd23_16<= 0;
	else if (csd23_16_w)
	csd23_16<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd15_8	<= 0;
	else if (csd15_8_w)
	csd15_8	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	csd7_0	<= 0;
	else if (csd7_0_w)
	csd7_0	<= FO;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_a	<= 0;
	else if (ecsd_a_w)
	ecsd_a	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b31_24	<= 0;
	else if (ecsd_b31_24_w)
	ecsd_b31_24	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b23_16	<= 0;
	else if (ecsd_b23_16_w)
	ecsd_b23_16	<= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b15_8 <= 0;
	else if (ecsd_b15_8_w)
	ecsd_b15_8 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b7_0 <= 0;
	else if (ecsd_b7_0_w)
	ecsd_b7_0 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_c <= 0;
	else if (ecsd_c_w)
	ecsd_c <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_d <= 0;
	else if (ecsd_d_w)
	ecsd_d <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_e <= 0;
	else if (ecsd_e_w)
	ecsd_e <= FO;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_f <= 0;
	else if (ecsd_f_w)
	ecsd_f <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_g <= 0;
	else if (ecsd_g_w)
	ecsd_g <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_h <= 0;
	else if (ecsd_h_w)
	ecsd_h <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_i <= 0;
	else if (ecsd_i_w)
	ecsd_i <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_j <= 0;
	else if (ecsd_j_w)
	ecsd_j <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_k <= 0;
	else if (ecsd_k_w)
	ecsd_k <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_l <= 0;
	else if (ecsd_l_w)
	ecsd_l <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_m <= 0;
	else if (ecsd_m_w)
	ecsd_m <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_n <= 0;
	else if (ecsd_n_w)
	ecsd_n <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_o <= 0;
	else if (ecsd_o_w)
	ecsd_o <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_p <= 0;
	else if (ecsd_p_w)
	ecsd_p <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ecsd_q <= 0;
	else if (ecsd_q_w)
	ecsd_q <= FO; 
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem31_24 <= 0;
	else if (ocr_mem31_24_w)
	ocr_mem31_24 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem23_16 <= 0;
	else if (ocr_mem23_16_w)
	ocr_mem23_16 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem15_8 <= 0;
	else if (ocr_mem15_8_w)
	ocr_mem15_8 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem7_0 <= 0;
	else if (ocr_mem7_0_w)
	ocr_mem7_0 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr63_56 <= 0;
	else if (scr63_56_w)
	scr63_56 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr55_48 <= 0;
	else if (scr55_48_w)
	scr55_48 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr47_40 <= 0;
	else if (scr47_40_w)
	scr47_40 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr39_32 = 0;
	else if (scr39_32_w)
	scr39_32 = FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr31_24 <= 0;
	else if (scr31_24_w)
	scr31_24 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr23_16 <= 0;
	else if (scr23_16_w)
	scr23_16 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr15_8 <= 0;
	else if (scr15_8_w)
	scr15_8 <= FO;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	scr7_0 <= 0;
	else if (scr7_0_w)
	scr7_0 <= FO;
end

always @(MMC_FI or pwdin127_120 or pwdin119_112 or pwdin111_104 or pwdin103_96 or 
pwdin95_88 or pwdin87_80 or pwdin79_72 or pwdin71_64 or pwdin63_56 or pwdin55_48 or 
pwdin47_40 or pwdin39_32 or pwdin31_24 or pwdin23_16 or pwdin15_8 or pwdin7_0 or
cid127_120 or cid119_112 or cid111_104 or cid103_96 or cid95_88 or cid87_80 or 
cid79_72 or cid71_64 or cid63_56 or cid55_48 or cid47_40 or cid39_32 or cid31_24 or 
cid23_16 or cid15_8 or cid7_0 or csd127_120 or csd119_112 or csd111_104 or csd103_96 or 
csd95_88 or csd87_80 or csd79_72 or csd71_64 or csd63_56 or csd55_48 or csd47_40 or 
csd39_32 or csd31_24 or csd23_16 or csd15_8 or csd7_0 or ecsd_a or ecsd_b31_24 or 
ecsd_b23_16 or ecsd_b15_8 or ecsd_b7_0 or ecsd_c or ecsd_d or ecsd_e or ecsd_f or 
ecsd_g or ecsd_h or ecsd_i or ecsd_j  or ecsd_k or ecsd_l or ecsd_m or ecsd_n or 
ecsd_o or ecsd_p or ecsd_q or ocr_mem31_24 or ocr_mem23_16 or ocr_mem15_8 or 
ocr_mem7_0 or scr63_56 or scr55_48 or scr47_40 or scr39_32 or scr31_24 or 
scr23_16 or scr15_8 or scr7_0 or pwdin127_120_r or pwdin119_112_r or pwdin111_104_r or 
pwdin103_96_r or pwdin95_88_r or pwdin87_80_r or pwdin79_72_r or pwdin71_64_r or 
pwdin63_56_r or pwdin55_48_r or pwdin47_40_r or pwdin39_32_r  or pwdin31_24_r or 
pwdin23_16_r or pwdin15_8_r or pwdin7_0_r or cid127_120_r   or cid119_112_r or 
cid111_104_r or cid103_96_r or cid95_88_r or cid87_80_r or cid79_72_r or cid71_64_r or 
cid63_56_r or cid55_48_r or cid47_40_r or cid39_32_r or cid31_24_r or cid23_16_r or 
cid15_8_r or cid7_0_r or csd127_120_r or csd119_112_r or csd111_104_r or csd103_96_r or 
csd95_88_r or csd87_80_r or csd79_72_r or csd71_64_r or csd63_56_r or csd55_48_r or
csd47_40_r or csd39_32_r or csd31_24_r or csd23_16_r or csd15_8_r or csd7_0_r or 
ecsd_a_r or ecsd_b31_24_r or ecsd_b23_16_r or ecsd_b15_8_r or ecsd_b7_0_r or 
ecsd_c_r or ecsd_d_r or ecsd_e_r or ecsd_f_r or ecsd_g_r or ecsd_h_r or 
ecsd_i_r or ecsd_j_r or ecsd_k_r or ecsd_l_r or ecsd_m_r or ecsd_n_r or 
ecsd_o_r or ecsd_p_r or ecsd_q_r or  ocr_mem31_24_r or ocr_mem23_16_r or
ocr_mem15_8_r or ocr_mem7_0_r or scr63_56_r or scr55_48_r or scr47_40_r or 
scr39_32_r or scr31_24_r or scr23_16_r or scr15_8_r or scr7_0_r	)
begin
	NextMMC_FI=MMC_FI;
	case (1'b1)
	pwdin127_120_r 	:NextMMC_FI= pwdin127_120;
	pwdin119_112_r	:NextMMC_FI= pwdin119_112;
	pwdin111_104_r	:NextMMC_FI= pwdin111_104;
	pwdin103_96_r	:NextMMC_FI= pwdin103_96;
	pwdin95_88_r	:NextMMC_FI= pwdin95_88;
	pwdin87_80_r	:NextMMC_FI= pwdin87_80;
	pwdin79_72_r	:NextMMC_FI= pwdin79_72;
	pwdin71_64_r	:NextMMC_FI= pwdin71_64;
	pwdin63_56_r	:NextMMC_FI= pwdin63_56;
	pwdin55_48_r	:NextMMC_FI= pwdin55_48;
	pwdin47_40_r	:NextMMC_FI= pwdin47_40;
	pwdin39_32_r	:NextMMC_FI= pwdin39_32;
	pwdin31_24_r	:NextMMC_FI= pwdin31_24;
	pwdin23_16_r	:NextMMC_FI= pwdin23_16;
	pwdin15_8_r		:NextMMC_FI= pwdin15_8;
	pwdin7_0_r		:NextMMC_FI= pwdin7_0;

	cid127_120_r	:NextMMC_FI= cid127_120;
	cid119_112_r	:NextMMC_FI= cid119_112;
	cid111_104_r	:NextMMC_FI= cid111_104;
	cid103_96_r		:NextMMC_FI= cid103_96;
	cid95_88_r 		:NextMMC_FI= cid95_88;
	cid87_80_r		:NextMMC_FI= cid87_80;
	cid79_72_r		:NextMMC_FI= cid79_72;
	cid71_64_r		:NextMMC_FI= cid71_64;
	cid63_56_r		:NextMMC_FI= cid63_56;
	cid55_48_r 		:NextMMC_FI= cid55_48;
	cid47_40_r 		:NextMMC_FI= cid47_40;
	cid39_32_r   	:NextMMC_FI= cid39_32;
	cid31_24_r		:NextMMC_FI= cid31_24;
	cid23_16_r 		:NextMMC_FI= cid23_16;
	cid15_8_r		:NextMMC_FI= cid15_8;
	cid7_0_r  		:NextMMC_FI= cid7_0;
	csd127_120_r	:NextMMC_FI= csd127_120;
	csd119_112_r	:NextMMC_FI= csd119_112;
	csd111_104_r	:NextMMC_FI= csd111_104;
	csd103_96_r		:NextMMC_FI= csd103_96;
	csd95_88_r 		:NextMMC_FI= csd95_88;
	csd87_80_r 		:NextMMC_FI= csd87_80;
	csd79_72_r 		:NextMMC_FI= csd79_72;
	csd71_64_r 		:NextMMC_FI= csd71_64;
	csd63_56_r 		:NextMMC_FI= csd63_56;
	csd55_48_r 		:NextMMC_FI= csd55_48;
	csd47_40_r 		:NextMMC_FI= csd47_40;
	csd39_32_r 		:NextMMC_FI= csd39_32;
	csd31_24_r 		:NextMMC_FI= csd31_24;
	csd23_16_r 		:NextMMC_FI= csd23_16;
	csd15_8_r  		:NextMMC_FI= csd15_8;
	csd7_0_r   		:NextMMC_FI= csd7_0;

	ecsd_a_r		:NextMMC_FI= ecsd_a;
	ecsd_b31_24_r	:NextMMC_FI= ecsd_b31_24;
	ecsd_b23_16_r	:NextMMC_FI= ecsd_b23_16;
	ecsd_b15_8_r	:NextMMC_FI= ecsd_b15_8;
	ecsd_b7_0_r		:NextMMC_FI= ecsd_b7_0;
	ecsd_c_r		:NextMMC_FI= ecsd_c;
	ecsd_d_r		:NextMMC_FI= ecsd_d;
	ecsd_e_r		:NextMMC_FI= ecsd_e;
	ecsd_f_r		:NextMMC_FI= ecsd_f;
	ecsd_g_r		:NextMMC_FI= ecsd_g;
	ecsd_h_r		:NextMMC_FI= ecsd_h;
	ecsd_i_r		:NextMMC_FI= ecsd_i;
	ecsd_j_r		:NextMMC_FI= ecsd_j;
	ecsd_k_r		:NextMMC_FI= ecsd_k;
	ecsd_l_r		:NextMMC_FI= ecsd_l;
	ecsd_m_r		:NextMMC_FI= ecsd_m;
	ecsd_n_r		:NextMMC_FI= ecsd_n;
	ecsd_o_r		:NextMMC_FI= ecsd_o;
	ecsd_p_r		:NextMMC_FI= ecsd_p;
	ecsd_q_r		:NextMMC_FI= ecsd_q;

	ocr_mem31_24_r	:NextMMC_FI= ocr_mem31_24;
	ocr_mem23_16_r	:NextMMC_FI= ocr_mem23_16;
	ocr_mem15_8_r	:NextMMC_FI= ocr_mem15_8;
	ocr_mem7_0_r	:NextMMC_FI= ocr_mem7_0;
	scr63_56_r		:NextMMC_FI= scr63_56;
	scr55_48_r		:NextMMC_FI= scr55_48;
	scr47_40_r	    :NextMMC_FI= scr47_40;
	scr39_32_r		:NextMMC_FI= scr39_32;
	scr31_24_r		:NextMMC_FI= scr31_24;
	scr23_16_r		:NextMMC_FI= scr23_16;
	scr15_8_r		:NextMMC_FI= scr15_8;
	scr7_0_r		:NextMMC_FI= scr7_0;
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMC_FI <= 0;
	else
	MMC_FI <= NextMMC_FI;
end 
endmodule


// sync logic
/* 
module RegIF_sync
(
	RESETn,
	CLK,
	sdclk,
	card_ecc_disabled,
	card_ecc_failed,
	
	dsr,			
	hreset_b,
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
	ocr_mem,
	scr
);

input			RESETn;
input			CLK;
input			sdclk;

input			card_ecc_disabled;
input			card_ecc_failed;
output	[15:0]	dsr;			
input			hreset_b;
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
input	[31:0] 	ocr_mem;	
input	[63:0] 	scr;



always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_disabled_sync1 <= 0;
	else
	card_ecc_disabled_sync1 <= card_ecc_disabled;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_disabled_sync <= 0;
	else
	card_ecc_disabled_sync <= card_ecc_disabled_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_failed_sync1 <= 0;
	else
	card_ecc_failed_sync1 <= card_ecc_failed;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	card_ecc_failed_sync <= 0;
	else
	card_ecc_failed_sync <= card_ecc_failed_sync1;
end

always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	pwdin_sync1 <= 0;
	else
	pwdin_sync1 <= pwdin;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	pwdin_sync <= 0;
	else
	pwdin_sync <= pwdin_sync1;
end

always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	pwd_len_sync1 <= 0;
	else
	pwd_len_sync1 <= pwd_len;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	pwd_len_sync <= 0;
	else
	pwd_len_sync <= pwd_len_sync1;
end


always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	rd_thd_sync1 <= 0;
	else
	rd_thd_sync1 <= rd_thd;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	rd_thd_sync <= 0;
	else
	rd_thd_sync <= rd_thd_sync1;
end

always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	cid_sync1 <= 0;
	else
	cid_sync1 <= cid;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	cid_sync <= 0;
	else
	cid_sync <= cid_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	csd_sync1 <= 0;
	else
	csd_sync1 <= csd;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	csd_sync <= 0;
	else
	csd_sync <= csd_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_a_sync1 <= 0;
	else
	ecsd_a_sync1 <= ecsd_a;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_a_sync <= 0;
	else
	ecsd_a_sync <= ecsd_a_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b_sync1 <= 0;
	else
	ecsd_b_sync1 <= ecsd_b;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_b_sync <= 0;
	else
	ecsd_b_sync <= ecsd_b_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_c_sync1 <= 0;
	else
	ecsd_c_sync1 <= ecsd_c;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_c_sync <= 0;
	else
	ecsd_c_sync <= ecsd_c_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_d_sync1 <= 0;
	else
	ecsd_d_sync1 <= ecsd_d;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_d_sync <= 0;
	else
	ecsd_d_sync <= ecsd_d_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_e_sync1 <= 0;
	else
	ecsd_e_sync1 <= ecsd_e;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_e_sync <= 0;
	else
	ecsd_e_sync <= ecsd_e_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_f_sync1 <= 0;
	else
	ecsd_f_sync1 <= ecsd_f;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_f_sync <= 0;
	else
	ecsd_f_sync <= ecsd_f_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_g_sync1 <= 0;
	else
	ecsd_g_sync1 <= ecsd_g;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_g_sync <= 0;
	else
	ecsd_g_sync <= ecsd_g_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_h_sync1 <= 0;
	else
	ecsd_h_sync1 <= ecsd_h;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_h_sync <= 0;
	else
	ecsd_h_sync <= ecsd_h_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_i_sync1 <= 0;
	else
	ecsd_i_sync1 <= ecsd_i;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_i_sync <= 0;
	else
	ecsd_i_sync <= ecsd_i_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_j_sync1 <= 0;
	else
	ecsd_j_sync1 <= ecsd_j;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_j_sync <= 0;
	else
	ecsd_j_sync <= ecsd_j_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_k_sync1 <= 0;
	else
	ecsd_k_sync1 <= ecsd_k;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_k_sync <= 0;
	else
	ecsd_k_sync <= ecsd_k_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_l_sync1 <= 0;
	else
	ecsd_l_sync1 <= ecsd_l;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_l_sync <= 0;
	else
	ecsd_l_sync <= ecsd_l_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_m_sync1 <= 0;
	else
	ecsd_m_sync1 <= ecsd_m;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_m_sync <= 0;
	else
	ecsd_m_sync <= ecsd_m_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_n_sync1 <= 0;
	else
	ecsd_n_sync1 <= ecsd_n;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_n_sync <= 0;
	else
	ecsd_n_sync <= ecsd_n_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_o_sync1 <= 0;
	else
	ecsd_o_sync1 <= ecsd_o;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_o_sync <= 0;
	else
	ecsd_o_sync <= ecsd_o_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_p_sync1 <= 0;
	else
	ecsd_p_sync1 <= ecsd_p;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_p_sync <= 0;
	else
	ecsd_p_sync <= ecsd_p_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_q_sync1 <= 0;
	else
	ecsd_q_sync1 <= ecsd_q;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ecsd_q_sync <= 0;
	else
	ecsd_q_sync <= ecsd_q_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem_sync1 <= 0;
	else
	ocr_mem_sync1 <= ocr_mem;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	ocr_mem_sync <= 0;
	else
	ocr_mem_sync <= ocr_mem_sync1;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	scr_sync1 <= 0;
	else
	scr_sync1 <= scr;
end
always @(posedge sdclk or negedge RESETn)
begin
	if (!RESETn)
	scr_sync <= 0;
	else
	scr_sync <= scr_sync1;
end
endmodule
*/
