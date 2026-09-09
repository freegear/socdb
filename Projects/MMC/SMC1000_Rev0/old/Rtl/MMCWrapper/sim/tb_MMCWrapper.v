module tb_MMC_Wrapper;





MMC_Wrapper mmcwrapper(
	// MMC Side
	.RESETn				(RESETn				),
	.CLK				(CLK				),
	.FA					(FA					),
	.FO					(FO					),
	.NSFRWE				(NSFRWE				),  
	.NSFROE				(NSFROE				),
	.MMC_FI				(MMC_FI				),
	.sdclk				(sdclk				),
	.hreset_b			(hreset_b			),
	.abort_b			(abort_b			),
	.addr				(addr				),
	.ads_b				(ads_b				),
	.be_b				(be_b				),
	.blast_b			(blast_b			),
	.cs_b				(cs_b				),
	.dwr				(dwr				),
	.size				(size				),
	.wr					(wr					),
	                                        
	.oe_card_detect		(oe_card_detect		),
	.sresetm_b			(sresetm_b			),
	                                        
	.card_ecc_disabled	(card_ecc_disabled	),
	.card_ecc_failed	(card_ecc_failed	),
	                                                        
	.dsr				(dsr				),			
	.hreset_b			(hreset_b			),
	.pwdin				(pwdin				),		
	.pwd_len			(pwd_len			),
	.rd_thd				(rd_thd				),
		                                                        
	.cid				(cid				),
	.csd				(csd				),
	.ecsd_a				(ecsd_a				),
	.ecsd_b				(ecsd_b				),
	.ecsd_c				(ecsd_c				),
	.ecsd_d				(ecsd_d				),
	.ecsd_e				(ecsd_e				),
	.ecsd_f				(ecsd_f				),
	.ecsd_g				(ecsd_g				),
	.ecsd_h				(ecsd_h				),
	.ecsd_i				(ecsd_i				),
	.ecsd_j				(ecsd_j				),
	.ecsd_k				(ecsd_k				),
	.ecsd_l				(ecsd_l				),
	.ecsd_m				(ecsd_m				),
	.ecsd_n				(ecsd_n				),
	.ecsd_o				(ecsd_o				),
	.ecsd_p				(ecsd_p				),
	.ecsd_q				(ecsd_q				),
	.ocr_mem			(ocr_mem			),
	.scr				(scr				),
);


endmodule
