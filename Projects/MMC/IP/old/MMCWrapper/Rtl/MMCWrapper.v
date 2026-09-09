// Special Function Number Parsing Block
module MMC_Wrapper(
	// MMC Side
	RESETn,
	CLK,
	FA,
	FO,
	NSFRWE,
	NSFROE,
	MMC_FI,
	sdclk,
	hreset_b,
	abort_b,
	addr,
	ads_b,
	be_b,
	blast_b,
	cs_b,
	dwr,
	size,
	wr,

	oe_card_detect,
	sresetm_b,

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
input			NSFRWE;
input			NSFROE;
output	[7:0]	MMC_FI;

 // MMC Side
input			sdclk;
input			hreset_b;
input    		abort_b; // CPU INTERRUPT
input 	[40:0] 	addr;	// CPU Register
input 			ads_b;
input	[3:0]	be_b;
input			blast_b;
input 	[1:0]	cs_b;
input 	[31:0]  dwr;
input	[9:0]	size;
input		    wr;

input			oe_card_detect	;
input			sresetm_b;
output			card_ecc_disabled;
output			card_ecc_failed;
	                                       
input	[15:0]	dsr;			
output			hreset_b;
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
output[31:0]	ocr_mem;
output[63:0]	scr;

mmcwrapper_regif mmcwrapper_regif(
	.RESETn					(RESETn				),
	.CLK					(CLK				),
	.FA						(FA					),
	.FO						(FO					),
	.NSFRWE					(NSFRWE				),
	.NSFROE					(NSFROE				),
	.MMC_FI					(MMC_FI				),
     

	// Further .. Using Sync logic                                          
	.int_clr				(int_clr			),
	.addr					(addr[31:0]			),
	.size					(size				),
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
	.RW_SPECIAL_BLK			(RW_SPECIAL_BLK		)
);

mmc_parser mmc_parser(
	// MMC Side
	.sdclk				(sdclk					),
	.hreset_b			(hreset_b				),
	.addr				(addr					),
	.ads_b				(ads_b					),
	.cs_b				(cs_b					),
	.wr					(wr						),
	.int_clr			(int_clr				),
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
		                                      
		.FA					(FA		),
		.FO					(FO		),
		.NFSRWE				(NFSRWE	),
		.NFSROE				(NFSROE	),
		.MMC_FI				(MMC_FI	),
		                                        
		.card_ecc_disabled	(card_ecc_disabled	),
		.card_ecc_failed	(card_ecc_failed	),
		                                        
		.dsr				(dsr	),			
		.hreset_b			(hreset_b),
		.pwdin				(pwdin	),	
		.pwd_len			(pwd_len),
		.rd_thd				(rd_thd	),
		                                       
		.cid				(cid	),					
		.csd				(csd	),				
		.ecsd_a				(ecsd_a	),
		.ecsd_b				(ecsd_b	),
		.ecsd_c				(ecsd_c	),	
		.ecsd_d				(ecsd_d	),	
		.ecsd_e				(ecsd_e	),
		.ecsd_f				(ecsd_f	),
		.ecsd_g				(ecsd_g	),
		.ecsd_h				(ecsd_h	),
		.ecsd_i				(ecsd_i	),
		.ecsd_j				(ecsd_j	),
		.ecsd_k				(ecsd_k	),
		.ecsd_l				(ecsd_l	),
		.ecsd_m				(ecsd_m	),
		.ecsd_n				(ecsd_n	),
		.ecsd_o				(ecsd_o	),
		.ecsd_p				(ecsd_p	),
		.ecsd_q				(ecsd_q	),
		.ocr_mem			(ocr_mem),
		.scr				(scr	)
);

endmodule
