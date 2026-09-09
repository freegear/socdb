`define M8051
module SMC1000Core
(
	XTAL1,
	RESET,
	sel_mmc,
);

input		XTAL1;
input		RESET;

input		sel_mmc;



`ifdef M8051
m8051 Cpu (
			.NMOE	(rom_oen),// Program Memory Output Emable, Active Low
			.NMWE	(		),// Program Memory Write Strobe, Active Low
			.DLM	(		),// Download mode, for loading Program Memory
			.ALE	(ALE	),// Address Latch Enable
			.NPSEN	(NPSEN	),// External Program Memory Enable
			.NALEN	(NALEN	),// Bidirectional Control Line for ALE and PSEN
			.NFWE	(reg_wen),// Register File Write Strobe, Active Low
			.NFOE	(reg_oen),// Register File Output Enable, Active Low
			.NSFRWE	(NSFRWE	),// External SFR Write Strobe, Active Low
			.NSFROE	(NSFROE	),// External SFR Output Enable, Active Low
			.IDLE	(	),// Idle Mode clock qualifier.
			.XOFF	(	),// Oscillator disable signal
			.OA		(	),// Output Port 0
			.OB		(	),// Output Port 1
			.OC		(	),// Output Port 2
			.OD		(OD	),// Output Port 3
			.AE		(	),// Bidirectional Control Line for Port 0 Data
			.BE		(	),// Bidirectional Control Line for Port 1 Data 
			.CE		(	),// Bidirectional Control Line for Port 2 Data
			.DE		(	),// Bidirectional Control Line for Port 3 Data
			.FA		(reg_address),// Register File Address Line
			.FO		(reg_datai	),// Register File Data Output
			.M		(rom_address),// Program Memory Address Line
			.NX1	(CLK	),// Clock Input form oscillator
			.NX2	(CLK	),// Clock Input form oscillator, stoppable in idlemode
			.RST	(~RESETn),// Used to reset status flags and set PC to Zero
			.NEA	(NEA	),// Not External Access, Enables the Program counter value onto Port 0 and Port2 pins
			.NESFR	(1'b0	),// Not External SFR Acknoledge, Active Low
			.ALEI	(ALEI	),// ALE input, used to select Download mode
			.PSEI	(PSEI	),// PSEN input, used to select Download mode
			.AI		(AI		),// Input Port 0 
			.BI		(BI		),// Input Port 1
			.CI		(CI		),// Input Port 2
			.DI		(DI		),// Input Port 3
			.FI		(FI		),// Register File Data Input
			.MD		(rom_data) // Program Memory Data Bus
            );

`else

core_top uCPU8051(
	.user_init_pc(user_init_pc),
	.user_init_pc_en(user_init_pc_en),
	.RESET_pin(RESET),
	.final_all_reset(final_all_reset),
	.final_POR_ext_reset(final_POR_ext_reset),
	.wdt_reset(wdt_reset),
	.xrom_addr(xrom_addr),
	.xrom_ce_b(xrom_ce_b),
	.xrom_oe_b(xrom_oe_b),
	.xrom_dout(xrom_dout),
	.xram_addr(xram_addr),
	.xram_din(xram_din),
	.xram_ce_b(xram_ce_b),
	.xram_oe_b(xram_oe_b),
	.xram_we_b(xram_we_b),
	.xram_dout(xram_dout),
	.iram_addr(iram_addr),
	.iram_din(iram_din),
	.iram_ce_b(iram_ce_b),
	.iram_oe_b(iram_oe_b),
	.iram_we_b(iram_we_b),
	.iram_dout(iram_dout),
	.clk_cpu(clk_cpu),
	.clk_peri(clk_peri),
	.clk_wdt(clk_wdt),
	.WDT_RUN(WDT_RUN),
	.pdwn(pdwn),
	.idle(idle),
	.EA(1'b0),
	.ALE(ALE),
	.PSEN(PSEN),
	.P0_DIN(P0_DIN),
	.P0_DOUT(P0_DOUT),
	.P1_DIN(P1_DIN),
	.P1_DOUT(P1_DOUT),
	.P2_DIN(P2_DIN),
	.P2_DOUT(P2_DOUT),
	.P3_DIN(P3_DIN),
	.P3_DOUT(P3_DOUT),
	.INT0_B(INT0_B),
	.INT1_B(INT1_B),
	.INT2(INT2),
	.INT3_B(INT3_B),
	.INT4(INT4),
	.INT5_B(INT5_B),
	.T0_PIN(T0_PIN),
	.T1_PIN(T1_PIN),
	.T2_PIN(T2_PIN),
	.T2EX_PIN(T2EX_PIN),
	.T2_OUT(T2_OUT),
	.RX_PIN(RX_PIN),
	.TX_PIN(TX_PIN),
	.PWM1_OUT(PWM1_OUT), 
	.PWM2_OUT(PWM2_OUT), 
    .EXT_SFR_DIN(EXT_SFR_DIN), 
	.EXT_SFR_DOUT(EXT_SFR_DOUT), 
	.EXT_SFR_ADDR(EXT_SFR_ADDR), 
	.EXT_SFR_WR(EXT_SFR_WR)
);


rst_clock rst_clock(
	.WDT_RUN(WDT_RUN),
	.XTAL1(XTAL1),
	.RESET(RESET),
	.clk_cpu(clk_cpu),
	.clk_peri(clk_peri),
	.clk_wdt(clk_wdt),
	.ext_reset(ext_reset),
	.PDWN(pdwn),
	.IDLE(idle)
);

reset_cnt reset_cnt(
	.POR_reset(RESET),
	.ext_reset(RESET),
	.wdt_reset(wdt_reset),
	.final_all_reset(final_all_reset),
	.final_POR_ext_reset(final_POR_ext_reset)
);

`endif

// Memory

/*
//Register File for Internal Memory
RAM256x8 	DataMemory (
			.Q 		(reg_datao),
			.CLK	(CLK),
			.WEN	(reg_wen),
			.A		(reg_address),
			.D		(reg_datai)
);	
ROM5120x8	ProgramMemory (
			.Q		(rom_data),
			.CLK	(CLK),
			.A		(rom_address)
); // 5K ROM
*/


/*//XROM 64K
XROM64K xrom64k(
.CK(clk_cpu),
.A(xrom_addr),
.CSN(xrom_ce_b),
.OEN(xrom_oe_b),
.DOUT(xrom_dout)
);*/

XROM5K xrom5k(
	.CK(clk_cpu),
	.A(xrom_addr),
	.CSN(xrom_ce_b),
	.OEN(xrom_oe_b),
	.DOUT(xrom_dout)
);


//IRAM 256
wire iram_clk = clk_cpu;
IRAM256 iram256 (
	.CK(iram_clk),
	.CSN(iram_ce_b),
	.WEN(iram_we_b),
	.OEN(iram_oe_b),
	.A(iram_addr),
	.DI(iram_din),
	.DOUT(iram_dout)
);

/*//XRAM 64K
XRAM64K xram64k (
.CK(clk_cpu),
.CSN(xram_ce_b),
.WEN(xram_we_b),
.OEN(xram_oe_b),
.A(xram_addr[13:0]),
.DI(xram_din),
.DOUT(xram_dout)
);*/




// Memory  IF Block

// MMC Block
ep560k1 uMMCSlave(
	.cmdin					(cmd),
	.cmdout					(cmdout),
	.dtin					(dt),
	.dtout					(dtout),
	.oe_cmd					(oe_cmd),
	.oe_dt					(oe_dt),
	.sdclk					(sdclk),
	
	.abort_b				(abort_b),
	.addr					(addr),
	.ads_b					(ads_b),
	.be_b					(be_b),
	.blast_b				(blast_b),
	.cs_b					(cs_b),
	.drd					(drd),
	.dwr					(dwr),
	.error					(error),
	.rdy_b					(rdy_b),
	.size					(size),
	.wr						(wr),
	
	.i0_abort_b				(), // We not Using 
	.i0_addr				(),
	.i0_ads_b				(),
	.i0_be_b				(),
	.i0_blast_b				(),
	.i0_cs_b				(),
	.i0_drd					(),
	.i0_dwr					(),
	.i0_rdy_b				(),
	.i0_size				(),
	.i0_wr					(),
	
	.i1_abort_b				(),
	.i1_addr				(),
	.i1_ads_b				(),
	.i1_be_b				(),
	.i1_blast_b				(),
	.i1_cs_b				(),
	.i1_drd					(),
	.i1_dwr					(),
	.i1_rdy_b				(),
	.i1_size				(),
	.i1_wr					(),
	
	.card_ecc_disabled		(card_ecc_disabled),
	.card_ecc_failed		(card_ecc_failed),
	.cccr_out				(),// N.C.
	.dsr					(dsr),
	.hreset_b				(hreset_b),
	.oe_card_detect			(oe_card_detect),
	.pwdin					(pwdin),
	.pwd_len				(pwd_len),
	.rd_thd					(rd_thd),
	.sdio_crd_rdy			(),// N.C.
	.sel_mmc				(sel_mmc),// PAD Seltect??
	.sd_dev					(2'b01),//SD Memory Select
	.sreseti_b				(), // N.C.
	.sresetm_b				(sresetm_b),
	
	.cccr					(),// N.C.
	.cccr_upper				(),// N.C.
	.cid					(cid),
	.csd					(csd),
	.ecsd_a					(ecsd_a),
	.ecsd_b					(ecsd_b),
	.ecsd_c					(ecsd_c),
	.ecsd_d					(ecsd_d),
	.ecsd_e					(ecsd_e),
	.ecsd_f					(ecsd_f),
	.ecsd_g					(ecsd_g),
	.ecsd_h					(ecsd_h),
	.ecsd_i					(ecsd_i),
	.ecsd_j					(ecsd_j),
	.ecsd_k					(ecsd_k),
	.ecsd_l					(ecsd_l),
	.ecsd_m					(ecsd_m),
	.ecsd_n					(ecsd_n),
	.ecsd_o					(ecsd_o),
	.ecsd_p					(ecsd_p),
	.ecsd_q					(ecsd_q),
	.eps1					(),// N.C.
	.fbr1					(),// N.C.
	.ocr_mem				(ocr_mem),
	.ocr_sdio				(),// N.C.
	.scr					(scr)
);

MMC_Wrapper uMMCWrapper(
	// MMC Side
	.sdclk				(sdclk	),
	.abort_b			(abort_b),
	.addr				(addr	),
	.ads_b				(ads_b	),
	.be_b				(be_b	),
	.blast_b			(blast_b),
	.cs_b				(cs_b	),
	.drd				(drd	),
	.dwr				(dwr	),
	.error				(error	),
	.rdy_b				(rdy_b	),
	.size				(size	),
	.wr					(wr		),
                                            
	.oe_card_detect		(oe_card_detect),
	.sresetm_b			(sresetm_b),
	.card_ecc_disabled	(card_ecc_disabled	),
	.card_ecc_failed	(card_ecc_failed	),

	.dsr				(dsr		),			
	.hreset_b			(hreset_b	),
	.pwdin				(pwdin		),		
	.pwd_len			(pwd_len	),
	.rd_thd				(rd_thd		),

	.cid				(cid		),
	.csd				(csd		),
	.ecsd_a				(ecsd_a		),
	.ecsd_b				(ecsd_b		),
	.ecsd_c				(ecsd_c		),
	.ecsd_d				(ecsd_d		),
	.ecsd_e				(ecsd_e		),
	.ecsd_f				(ecsd_f		),
	.ecsd_g				(ecsd_g		),
	.ecsd_h				(ecsd_h		),
	.ecsd_i				(ecsd_i		),
	.ecsd_j				(ecsd_j		),
	.ecsd_k				(ecsd_k		),
	.ecsd_l				(ecsd_l		),
	.ecsd_m				(ecsd_m		),
	.ecsd_n				(ecsd_n		),
	.ecsd_o				(ecsd_o		),
	.ecsd_p				(ecsd_p		),
	.ecsd_q				(ecsd_q		),
	.ocr_mem			(ocr_mem	),
	.scr				(scr		)
);



MemCtrlTop uMEMCtrl(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.sdclk			(sdclk			),
	.hreset_b		(hreset_b		),
	.blast_b		(blast_b		),
	.be_b			(be_b			),
	.size			(size			),
	.mmc_rdy_b		(mmc_rdy_b		),
	.M				(M				),
	.NMWE			(NMWE			),
	//NMOE,          
	.MD				(MD				),
	.FA	 			(FA	 			),  
	.FO	   			(FO	   			),
	.NSFRWE			(NSFRWE			),
	.NSFROE			(NSFROE			),
	.MEM_FI			(MEM_FI			),
	                                
	.MMCRAM_DATAi	(MMCRAM_DATAi	),
	.MMCRAM_DATAo	(MMCRAM_DATAo	),
                                    
                                    
	.NandREQ		(NandREQ		),
	.NandRW			(NandRW			),
	.NandEnable		(NandEnable		),
	.RSEn_Start		(RSEn_Start		),
	.RSEn_Wait		(RSEn_Wait		),
	.RSDe_Start		(RSDe_Start		),
	.RSDe_Wait		(RSDe_Wait		),
                                    
	.NandWriteData	(NandWriteData	),
	.NandReadData	(NandReadData	)
);


assign NFDATA[7:0] = (NFDataOutEn0)? NFDataOut0 : 8'bzzzzzzzz; // 16bit Mux 추가 할 것
assign NFDATA[15:8] = (NFDataOutEn1)? NFDataOut1 : 8'bzzzzzzzz;
NFTop	uNFTop0(
	.PCLK	    	(CLK),
	.PRESETn    	(RESETn),
	.PADDR      	(),
	.PSEL       	(),
	.PENABLE    	(),
	.PWRITE     	(),
	
	.PWDATA     	(),
	.PRDATA     	(),
	
	.NFDMAReqOut	(NFDMAReq0),
	.NFINTOut   	(NFINT0),
	
	.NFBootPinIn	(1'b0),    
	.IOWidthPinIn	(1'b0),   
	.NandWidthPinIn	(1'b0),   
	.BootCfgPinIn	(2'b00),   
	.OutDtmnPinIn	(1'b0),   

	.NFDataIn    	(NFDATA[7:0]),// NAND IF
	.NFDataOut   	(NFDataOut0),
	.NFDataOutEn 	(NFDataOutEn0),
	.CLE         	(CLE0),
	.ALE         	(ALE0),
	.nNFCE1      	(nNFCE1),
	.nNFCE0      	(nNFCE0),
	.nNFRE       	(nNFRE0),
	.nNFWE       	(nNFWE0),
	.RnB1        	(RnB1),
	.RnB0  			(RnB0)
);


NFTop	uNFTop1(
	.PCLK	    	(CLK),
	.PRESETn    	(RESETn),
	.PADDR      	(),
	.PSEL       	(),
	.PENABLE    	(),
	.PWRITE     	(),
	
	.PWDATA     	(),
	.PRDATA     	(),
	
	.NFDMAReqOut	(NFDMAReq1),
	.NFINTOut   	(NFINT1),
	
	.NFBootPinIn	(1'b0),    
	.IOWidthPinIn	(),   
	.NandWidthPinIn	(1'b0),   
	.BootCfgPinIn	(2'b00),   
	.OutDtmnPinIn	(),   

	.NFDataIn    	(NFDATA[15:8]),// NAND IF
	.NFDataOut   	(NFDatOut1),
	.NFDataOutEn 	(NFDataOutEn1),
	.CLE         	(CLE1),
	.ALE         	(ALE1),
	.nNFCE1      	(nNFCE3),
	.nNFCE0      	(nNFCE2),
	.nNFRE       	(nNFRE1),
	.nNFWE       	(nNFWE1),
	.RnB1        	(RnB3),
	.RnB0  			(RnB2)
);

RSEncoderTop uRSEncoder(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.NandRAM_DATAo	(NandRAM_DATAo	),
	.RSEn_Start		(RSEn_Start		),
	.RSEn_Wait		(RSEn_Wait		),
	.FA				(FA				),
	.FO				(FO				),
	.NSFRWE			(NSFRWE			),
	.NSFROE			(NSFROE			),
	.RSEnc_FI		(RSEnc_FI		),
	.RSEn_End		(RSEn_End		)// RS Interrupt??
);

RSDecoderTop uRSDecoder(
	.RESETn			(RESETn		 ),
	.CLK			(CLK		 ),
	.FA				(FA			 ),
	.FO				(FO			 ),
	.NSFRWE			(NSFRWE		 ),
	.NSFROE			(NSFROE		 ),		
	.RSDec_FI		(RSDec_FI	 ),
	.NandReadData	(NandReadData),
	.RSDe_Start		(RSDe_Start	 ),
	.RSDe_Wait		(RSDe_Wait	 ),
	.NandReadWait	(NandReadWait)
);

endmodule




















