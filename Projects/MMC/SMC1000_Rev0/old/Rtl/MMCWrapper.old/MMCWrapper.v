// Special Function Number Parsing Block
module MMCWrapper(
	// MMC Side
	RESETn,
	CLK,
	STATIC_CS,
	WAP_REG_CS,
	bank_addr,
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	STATIC_DIN,
	WAP_REG_DIN,

	sdclk,
	hreset_b,

	abort_b,
	addr,
	ads_b,
	be_b,
	blast_b,
	cs_b,
	drd,
	dwr,
	error,
	rdy_b,
	size,
	wr,

	oe_card_detect,
	sresetm_b,

	card_ecc_disabled,
	card_ecc_failed,
	                                       
	dsr,			
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
	scr,


//	MMC Wrapper Interrurpt
	WRAP_INT,
	ABORT_INT,

//	Memory Interface for MMC RAM
	mmc_beb,
	mmc_rdb,
	mmc_wrb,
	mmc_tsize,

	rdyb,
	err,

	MMCRAM_DATAi,
	MMCRAM_DATAo


);
input			RESETn;
input			CLK;
input			STATIC_CS;
input	[12:0]	WAP_REG_CS;
input	[10:0]	bank_addr;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	STATIC_DIN;
output	[7:0]	WAP_REG_DIN;

 // MMC Side
input			sdclk;
input			hreset_b;
input    		abort_b; // CPU INTERRUPT
input 	[40:0] 	addr;	// CPU Register
input 			ads_b;
input	[3:0]	be_b;
input			blast_b;
input 	[1:0]	cs_b;
output	[31:0]	drd;
input 	[31:0]  dwr;
input			error;
output			rdy_b;
input	[9:0]	size;
input		    wr;

input			oe_card_detect	;
input			sresetm_b;
output			card_ecc_disabled;
output			card_ecc_failed;
	                                       
input	[15:0]	dsr;			
output	[127:0]	pwdin;	
output	[7:0]	pwd_len;
output	[2:0]	rd_thd;
		                                       

output[127:0]	cid;
output[127:0]	csd;
output[7:0]		ecsd_a;
output[31:0]	ecsd_b;
output[7:0]		ecsd_c;
output[7:0]		ecsd_d;
output[7:0]		ecsd_e;
output[7:0]		ecsd_f;
output[7:0]		ecsd_g;
output[7:0]		ecsd_h;
output[7:0]		ecsd_i;
output[7:0]		ecsd_j;
output[7:0]		ecsd_k;
output[7:0]		ecsd_l;
output[7:0]		ecsd_m;
output[7:0]		ecsd_n;
output[7:0]		ecsd_o;
output[7:0]		ecsd_p;
output[7:0]		ecsd_q;
input[7:0]		ecsd_r;
input[7:0]		ecsd_s;
output[31:0]	ocr_mem;
output[63:0]	scr;

output			WRAP_INT;
output			ABORT_INT;

output [3:0]	mmc_beb;
output			mmc_rdb;
output			mmc_wrb;
output	[9:0]	mmc_tsize;
input	rdyb;
input	err;

output	[31:0]		MMCRAM_DATAi;
input	[31:0]		MMCRAM_DATAo;


wire	[3:0]	si_beb;
wire			si_rdb;
wire			si_wrb;
wire	[9:0]	si_size;
wire			si_rdyb;
wire			si_err;
assign mmc_beb = si_beb;
assign mmc_rdb = si_rdb;
assign mmc_wrb = si_wrb;
assign mmc_tsize = si_size;

assign si_rdyb = rdyb;
assign si_err = err;


wire	[127:0]	i_cid;
wire	[127:0]	i_csd;
wire	[7:0]	i_ecsd_a;
wire	[31:0]	i_ecsd_b;
wire	[7:0]	i_ecsd_c;
wire	[7:0]	i_ecsd_d;
wire	[7:0]	i_ecsd_e;
wire	[7:0]	i_ecsd_f;
wire	[7:0]	i_ecsd_g;
wire	[7:0]	i_ecsd_h;
wire	[7:0]	i_ecsd_i;
wire	[7:0]	i_ecsd_j;
wire	[7:0]	i_ecsd_k;
wire	[7:0]	i_ecsd_l;
wire	[7:0]	i_ecsd_m;
wire	[7:0]	i_ecsd_n;
wire	[7:0]	i_ecsd_o;
wire	[7:0]	i_ecsd_p;
wire	[7:0]	i_ecsd_q;
wire	[31:0]	i_ocr_mem;
wire	[63:0]	i_scr;

wire			si_newopb;
wire	[1:0]	si_csb ;  
wire	[40:0]	si_addr ; 
wire	[31:0]	si_wdata ;
wire	[31:0]	si_rdata ;

wire		[127:0]	i_pwdin;	
wire		[7:0]	i_pwd_len;
wire		[2:0]	i_rd_thd;
		                                       
wire		[31:0]	rdata_regval;
wire				NewOpInt;
wire				si_abortb;
//assign		WRAP_INT =~si_newopb; // wropper interrupt (Edge)
assign		WRAP_INT = NewOpInt; // wropper interrupt (Level)
assign		ABORT_INT = ~si_abortb;


mmcwrapper_regif mmcwrapper_regif(
	.RESETn					(RESETn				),
	.CLK					(CLK				),
	.CS						(WAP_REG_CS			),
	.EXT_SFR_DOUT			(EXT_SFR_DOUT		),
	.EXT_SFR_WR				(EXT_SFR_WR			),
	.EXT_SFR_DIN			(WAP_REG_DIN		),
     
	// Further .. Using Sync logic                                          
	.si_newopb				(si_newopb			),
	.NewOpInt				(NewOpInt			),
	.int_clr				(int_clr			),
	.addr					(si_addr[40:0]		),
	.size					(si_size),
	.NORMAL_READ			(NORMAL_READ		),
	.NORMAL_WRITE			(NORMAL_WRITE		),
	.SDREG_READ				(SDREG_READ			),
	.ERA_ST_ADDR			(ERA_ST_ADDR		),
	.ERA_END_ADDR			(ERA_END_ADDR		),
	.ERA_EXE				(ERA_EXE			),
	.PROGRAMMING			(PROGRAMMING		),
	.SET_WR_PROTECT			(SET_WR_PROTECT		),
	.CLR_WR_PROTECT			(CLR_WR_PROTECT		),
	.ARG_FOR_WR_PROTECT		(ARG_FOR_WR_PROTECT	),
	.READ_WR_PROTECT		(READ_WR_PROTECT	),
	.PRE_WRITE_ERASE_BLKCNT	(PRE_WRITE_ERASE_BLKCNT	),
	.CID_WRITE				(CID_WRITE			),
	.FORCE_ERASE			(FORCE_ERASE		),
	.PWD_LENGTH				(PWD_LENGTH			),
	.CARD_PWD				(CARD_PWD			),
	.SWITCH_FUNC_ARG		(SWITCH_FUNC_ARG	),
	.SWITCH_FUNC_STA		(SWITCH_FUNC_STA	),
	.CID_PROG				(CID_PROG			),
	.RW_SPECIAL_BLK			(RW_SPECIAL_BLK		),
	.rdata_regval0			(rdata_regval[7:0]	),
	.rdata_regval1			(rdata_regval[15:8]	),
	.rdata_regval2			(rdata_regval[23:16]),
	.rdata_regval3			(rdata_regval[31:24])
);

cardctrlwrap uMMCCtrlWrap
  (
	.rstb                (RESETn), // ??
	.clk_card            (sdclk),
	.clk_sys             (CLK),
	
	// SD/MMC card interface signals
	.ci_adsb             (ads_b),
	.ci_wr               (wr),
	.ci_blastb           (blast_b),
	.ci_csb              (cs_b),
	.ci_addr             (addr),
	.ci_beb              (be_b),
	.ci_rdata            (drd),
	.ci_wdata            (dwr),
	.ci_error            (error),
	.ci_rdyb             (rdy_b),
	.ci_size             (size),
	.ci_abortb			 (abort_b),

	// SRAM buffer interface signals
	.si_newopb           (si_newopb),
	.si_csb              (si_csb   ),
	.si_abortb		(si_abortb),
	.si_addr             (si_addr  ),
	.si_wr				 (si_wr		),
	.si_size			 (si_size	),
	.si_wdata            (si_wdata ),
	.si_rdata            (si_rdata ),
	.si_beb              (si_beb   ),
	.si_wrb              (si_wrb   ),
	.si_rdb              (si_rdb   ),
	.si_rdyb             (si_rdyb  ),
	.si_err            	 (si_err   )
);   


mmc_parser mmc_parser(
	// MMC Side
	.CLK				(CLK					),
	.RESETn				(RESETn					),
	.addr				(si_addr				),
	.NewOp				(~si_newopb				),
	.cs_b				(si_csb					),
	.wr					(si_wr					),
	.int_clr			(int_clr				),
	
	.si_rdata			(si_rdata				),
	.si_wdata			(si_wdata				),
	
	.rdata_regval		(rdata_regval			), // reg setting value

	.MMCRAM_DATAi		(MMCRAM_DATAi			),
	.MMCRAM_DATAo		(MMCRAM_DATAo			),

	.NORMAL_READ		(NORMAL_READ			),
	.NORMAL_WRITE		(NORMAL_WRITE			),
	.SDREG_READ 		(SDREG_READ 			),
	.ERA_ST_ADDR	 	(ERA_ST_ADDR 			),
	.ERA_END_ADDR		(ERA_END_ADDR			),
	.ERA_EXE			(ERA_EXE				),
	.PROGRAMMING		(PROGRAMMING			),
	.SET_WR_PROTECT		(SET_WR_PROTECT			),
	.CLR_WR_PROTECT		(CLR_WR_PROTECT			),
	.ARG_FOR_WR_PROTECT	(ARG_FOR_WR_PROTECT		),
	.READ_WR_PROTECT	(READ_WR_PROTECT		),
	.PRE_WRITE_ERASE_BLKCNT(PRE_WRITE_ERASE_BLKCNT),
	.CID_WRITE			(CID_WRITE				),
	.FORCE_ERASE		(FORCE_ERASE			),
	.PWD_LENGTH			(PWD_LENGTH				),
	.CARD_PWD			(CARD_PWD				),
	.SWITCH_FUNC_ARG	(SWITCH_FUNC_ARG		),
	.SWITCH_FUNC_STA	(SWITCH_FUNC_STA		),
	.CID_PROG			(CID_PROG				),
	.RW_SPECIAL_BLK		(RW_SPECIAL_BLK			)
);

staticregif staticregif
(
	.RESETn				(RESETn	),
	.CLK				(CLK	),
	                                      
	.CS					(STATIC_CS	),
	.EXT_BK_ADDR		(bank_addr[6:0]),
	.EXT_SFR_DOUT		(EXT_SFR_DOUT),
	.EXT_SFR_WR			(EXT_SFR_WR	),
	.EXT_SFR_DIN		(STATIC_DIN	),

	.card_ecc_disabled	(i_card_ecc_disabled	),
	.card_ecc_failed	(i_card_ecc_failed	),
	                                        
	.dsr				(dsr	),			
//	.hreset_b			(hreset_b), // Software Reset ??
	.pwdin				(i_pwdin	),	
	.pwd_len			(i_pwd_len),
	.rd_thd				(i_rd_thd	),
	                                       
	.cid				(i_cid	),					
	.csd				(i_csd	),				
	.ecsd_a				(i_ecsd_a	),
	.ecsd_b				(i_ecsd_b	),
	.ecsd_c				(i_ecsd_c	),	
	.ecsd_d				(i_ecsd_d	),	
	.ecsd_e				(i_ecsd_e	),
	.ecsd_f				(i_ecsd_f	),
	.ecsd_g				(i_ecsd_g	),
	.ecsd_h				(i_ecsd_h	),
	.ecsd_i				(i_ecsd_i	),
	.ecsd_j				(i_ecsd_j	),
	.ecsd_k				(i_ecsd_k	),
	.ecsd_l				(i_ecsd_l	),
	.ecsd_m				(i_ecsd_m	),
	.ecsd_n				(i_ecsd_n	),
	.ecsd_o				(i_ecsd_o	),
	.ecsd_p				(i_ecsd_p	),
	.ecsd_q				(i_ecsd_q	),
	.ecsd_r				(ecsd_r	),
	.ecsd_s				(ecsd_s	),
	.ocr_mem			(i_ocr_mem),
	.scr				(i_scr	)
);

// sync logic
RegIF_sync RegSync
(
	.hreset_b			(hreset_b),
	.sdclk				(sdclk),
	.card_ecc_disabled	(i_card_ecc_disabled),
	.card_ecc_failed	(i_card_ecc_failed	),

	.pwdin				(i_pwdin),  
	.pwd_len			(i_pwd_len),
	.rd_thd				(i_rd_thd),

	.cid				(i_cid	),					
	.csd				(i_csd	),				
	.ecsd_a				(i_ecsd_a),
	.ecsd_b				(i_ecsd_b),
	.ecsd_c				(i_ecsd_c),
	.ecsd_d				(i_ecsd_d),
	.ecsd_e				(i_ecsd_e),
	.ecsd_f				(i_ecsd_f),
	.ecsd_g				(i_ecsd_g),
	.ecsd_h				(i_ecsd_h),
	.ecsd_i				(i_ecsd_i),
	.ecsd_j				(i_ecsd_j),
	.ecsd_k				(i_ecsd_k),		
	.ecsd_l				(i_ecsd_l),		
	.ecsd_m				(i_ecsd_m),
	.ecsd_n				(i_ecsd_n),
	.ecsd_o				(i_ecsd_o),
	.ecsd_p				(i_ecsd_p),
	.ecsd_q				(i_ecsd_q),
	//.ecsd_r				(i_ecsd_r),
	//.ecsd_s				(i_ecsd_s),
	.ocr_mem			(i_ocr_mem),
	.scr	           	(i_scr	),

	.card_ecc_disabled_sync	(card_ecc_disabled),
	.card_ecc_failed_sync	(card_ecc_failed),
	.pwdin_sync				(pwdin		),
	.pwd_len_sync			(pwd_len	),
	.rd_thd_sync			(rd_thd		),

	.cid_sync	 		(cid	 	),				
	.csd_sync	 		(csd	 	),			
	.ecsd_a_sync 		(ecsd_a 	),
	.ecsd_b_sync 		(ecsd_b 	),
	.ecsd_c_sync 		(ecsd_c 	),
	.ecsd_d_sync 		(ecsd_d 	),
	.ecsd_e_sync 		(ecsd_e 	),
	.ecsd_f_sync 		(ecsd_f 	),
	.ecsd_g_sync 		(ecsd_g 	),
	.ecsd_h_sync 		(ecsd_h 	),
	.ecsd_i_sync 		(ecsd_i 	),
	.ecsd_j_sync 		(ecsd_j 	),
	.ecsd_k_sync 		(ecsd_k 	),
	.ecsd_l_sync 		(ecsd_l 	),
	.ecsd_m_sync 		(ecsd_m 	),
	.ecsd_n_sync 		(ecsd_n 	),
	.ecsd_o_sync 		(ecsd_o 	),
	.ecsd_p_sync 		(ecsd_p 	),
	.ecsd_q_sync 		(ecsd_q 	),
//	.ecsd_r_sync 		(ecsd_r 	),
//	.ecsd_s_sync 		(ecsd_s 	),
	.ocr_mem_sync		(ocr_mem	),
	.scr_sync			(scr		)
);

endmodule
