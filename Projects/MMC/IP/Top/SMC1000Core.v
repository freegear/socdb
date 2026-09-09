// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : SMC1000Core.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : SMC1000 Core Top
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module SMC1000Core
(
	XTAL1,
	RESET,
	PSEN,

	// External ROM Interface
	xrom_addr,
	xrom_ce_b,
	xrom_oe_b,
	xrom_dout,
	// Debug UART
	RX_PIN,
	TX_PIN,	

	// 8051 GPIO 
	P0_DIN,
	P0_DOUT,
	P1_DIN,
	P1_DOUT,
	P2_DIN,
	P2_DOUT,
	P3_DIN,
	P3_DOUT,

	// Nand Inferface
	NFDataIn,
	NFDataOut,
	NFDataOutEn,
	CLE,
	ALE,
	nNFCE,
	nNFRE,
	nNFWE,
	RnB,

	// MMC IP  signal
	sel_mmc,
	oe_card_detect,

	// MMC SD Signal
	cmdin,
	cmdout,	
	dtin,
	dtout,
	oe_cmd,
	oe_dt,
	sdclk
	
);

input			XTAL1;
input			RESET;

input			PSEN;
output [15:0]	xrom_addr;
output			xrom_ce_b;
output			xrom_oe_b;
input	[7:0]	xrom_dout;
input			RX_PIN;
output			TX_PIN;

input	[7:0]	P0_DIN;
output	[7:0]	P0_DOUT;
input	[7:0]	P1_DIN;
output	[7:0]	P1_DOUT;
input	[7:0]	P2_DIN;
output	[7:0]	P2_DOUT;
input	[7:0]	P3_DIN;
output	[7:0]	P3_DOUT;

input	[15:0]	NFDataIn;
output	[15:0]	NFDataOut;
output	[1:0]	NFDataOutEn;
output	[1:0]	CLE;
output	[1:0]	ALE;
output	[7:0]	nNFCE;
output	[1:0]	nNFRE;
output	[1:0]	nNFWE;
input	[7:0]	RnB;

// MMC IP  signal
input			sel_mmc;
output			oe_card_detect;

input			cmdin;
output			cmdout;	
input	[7:0]	dtin;
output	[7:0]	dtout;	
output			oe_cmd;
output			oe_dt;	
input			sdclk;

wire	[10:0]	NandRAM_Addr0; 
wire	[10:0]	NandRAM_Addr1;
wire	[7:0]	EXT_SFR_DIN;
wire	[7:0]	EXT_SFR_DOUT;
wire	[7:0]	EXT_SFR_ADDR;
wire			EXT_SFR_WR;

wire	[7:0]	oe_dt;
wire	[40:0]	addr;
wire	[3:0]	be_b;
wire	[1:0]	cs_b;
wire	[31:0]	drd;
wire	[31:0]	dwr;
wire	[9:0]	size;
wire	[127:0]	cid;
wire	[127:0]	csd;
wire	[15:0]	dsr;

wire	[7:0]	ecsd_a;
wire	[31:0]	ecsd_b;
wire	[7:0]	ecsd_c;
wire	[7:0]	ecsd_d;
wire	[7:0]	ecsd_e;
wire	[7:0]	ecsd_f;
wire	[7:0]	ecsd_g;
wire	[7:0]	ecsd_h;
wire	[7:0]	ecsd_i;
wire	[7:0]	ecsd_j;
wire	[7:0]	ecsd_k;
wire	[7:0]	ecsd_l;
wire	[7:0]	ecsd_m;
wire	[7:0]	ecsd_n;
wire	[7:0]	ecsd_o;
wire	[7:0]	ecsd_p;
wire	[7:0]	ecsd_q;
wire	[7:0]	ecsd_r;
wire	[7:0]	ecsd_s;
wire	[127:0]	pwdin;
wire	[7:0]	pwd_len;
wire	[2:0]	rd_thd;
wire	[63:0]	scr;
wire	[31:0]	ocr_mem;
wire	[31:0]	MMCRAM_DATAi;
wire	[31:0]	MMCRAM_DATAo;
wire	[15:0]	xram_addr;
wire	[7:0]	xram_dout;
wire	[7:0]	xram_din;
wire	[7:0]	NandRAM0_DATAo;
wire	[7:0]	NandRAM0_DATAi;
wire	[7:0]	NandRAM1_DATAo;
wire	[7:0]	NandRAM1_DATAi;
wire	[2:0]	DecodeEndCnt0;
wire	[2:0]	DecodeEndCnt1;

wire			xrom_ce_b_1;

wire	[7:0]	iram_addr;
wire			iram_ce_b;
wire			iram_we_b;
wire	[7:0]	iram_dout;
wire	[7:0]	iram_din;


wire	[7:0]	MEM_CTRL_DIN;	
wire	[7:0]	WAP_REG_DIN	;
wire	[7:0]	STATIC_DIN	;	
wire	[7:0]	NAND_DMA0_DIN	;
wire	[7:0]	NAND_DMA1_DIN	;
wire	[7:0]	NAND_CTRL0_DIN	;
wire	[7:0]	NAND_CTRL1_DIN	;
wire	[7:0]	RS_ENC0_DIN	;
wire	[7:0]	RS_ENC1_DIN	;
wire	[7:0]	RS_DEC0_DIN	;
wire	[7:0]	RS_DEC1_DIN	;

wire	[15:0]	NFDataIn0;
wire	[15:0]	NFDataOut0;
wire			NFDataOutEn0;
wire	[15:0]	NFDataIn1;
wire	[15:0]	NFDataOut1;
wire			NFDataOutEn1;
wire	[1:0]	BootCfgPinIn0;
wire	[1:0]	BootCfgPinIn1;

wire			 clk_cpu = XTAL1;
wire			 clk_peri =XTAL1 ;
wire			 clk_wdt = XTAL1;

wire 			RESETn = ~ RESET;
wire			CLK = clk_cpu;

wire	[15:0]	user_init_pc = 16'd0;
wire 	[7:0]	xrom_dout_1;

assign xrom_ce_b = (~xrom_addr[15])& (xrom_ce_b_1);


wire [7:0]	xram32k_dout;
wire [7:0]	memctrl_dout;
wire [15:0]	mem_addr;

wire xram32k_CEn = ~(mem_addr[15] == 1'b1);
wire			mem_ce_b;
wire			mem_oe_b;



//----------------------------------------
// 8051 CPU
//----------------------------------------
core_top uCPU8051(
	.user_init_pc(user_init_pc),
	.user_init_pc_en(1'b0),
	.RESET_pin(RESET),
	.final_all_reset(final_all_reset),
	.final_POR_ext_reset(final_POR_ext_reset),
	.wdt_reset(wdt_reset),
	.xrom_addr(xrom_addr),
	.xrom_ce_b(xrom_ce_b_1),
	.xrom_oe_b(xrom_oe_b),
	.xrom_dout(xrom_dout_1),
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
	.ALE(Cpu_ALE),
	.PSEN(PSEN),
	.P0_DIN(P0_DIN),
	.P0_DOUT(P0_DOUT),
	.P1_DIN(P1_DIN),
	.P1_DOUT(P1_DOUT),
	.P2_DIN(P2_DIN),
	.P2_DOUT(P2_DOUT),
	.P3_DIN(P3_DIN),
	.P3_DOUT(P3_DOUT),

	.INT0_B(MMCTransferEnd), 	// MMC Slave Interrupt
	.INT1_B(TransferEnd1|TransferEnd0),	// DMA Interrupt & Decoder Interrupt
	.INT2(),
	.INT3_B(NandInt0|NandInt1),
	.INT4(),
	`ifdef VER2
	.INT5_B(RSEn_End0 |RSEn_End1),// RS Encoder Interrupt
	`else
	.INT5_B(),// RS Encoder Interrupt
	`endif
	.T0_PIN		(), // Unused
	.T1_PIN		(), // Unused
	.T2_PIN		(),	// Unused
	.T2EX_PIN	(), // Unused
	.T2_OUT		(),	// Unused
	.RX_PIN(RX_PIN),
	.TX_PIN(TX_PIN),
	.PWM1_OUT(),// Unused
	.PWM2_OUT(), // Unused
    .EXT_SFR_DIN(EXT_SFR_DIN), 
	.EXT_SFR_DOUT(EXT_SFR_DOUT), 
	.EXT_SFR_ADDR(EXT_SFR_ADDR), 
	.EXT_SFR_WR(EXT_SFR_WR)
);// CPU



//----------------------------------------
//	RESET Controller
//----------------------------------------
reset_cnt reset_cnt(
	.POR_reset(RESET),
	.ext_reset(RESET),
	.wdt_reset(wdt_reset),
	.final_all_reset(final_all_reset),
	.final_POR_ext_reset(final_POR_ext_reset)
);


//----------------------------------------
//	internal ROM 5K for Boot Code 
//	It is CHIP Level Instance
//----------------------------------------
`ifdef CHIP
XROM5K xrom5k(
	.CK(clk_cpu),
	.A(xrom_addr),
	.CSN(xrom_ce_b),
	.OEN(xrom_oe_b),
	.DOUT(xrom_dout)
);
`endif


//----------------------------------------
//	internal RAM 256B
//----------------------------------------
SSRAM8bit #8 iram256
(
	.CLK  	(clk_cpu), 
	
	.ADDR 	(iram_addr),
	.CEn  	(iram_ce_b),
	.WEn  	(iram_we_b),
	.RDATA	(iram_dout),
	.WDATA	(iram_din)
);

//----------------------------------------
//	Program & Data Memory Joint Logic
//----------------------------------------
addrlatcher addrlatch(
	.RESETn		(RESETn		),
	.CLK		(CLK		),
	.ALE		(Cpu_ALE	),
	.xrom_addr	(xrom_addr	),	
	.xrom_ce_b	(xrom_ce_b_1),
	.xram_ce_b	(xram_ce_b	),
	.xrom_oe_b	(xrom_oe_b	),
	.xram_oe_b	(xram_oe_b	),
	.mem_addr	(mem_addr	),
	.mem_ce_b	(mem_ce_b	),
	.mem_oe_b	(mem_oe_b	)
);


assign xram_dout = (~mem_addr[15])? xrom_dout:
	((mem_addr[14:12] == 3'b000 )|
	(mem_addr[14:12] == 3'b001 )|
	(mem_addr[14:12] == 3'b010 ))? memctrl_dout : xram32k_dout;
assign xrom_dout_1 = (~mem_addr[15])? xrom_dout:
	((mem_addr[14:12] == 3'b000 )|
	(mem_addr[14:12] == 3'b001 )|
	(mem_addr[14:12] == 3'b010 ))? memctrl_dout : xram32k_dout;

//----------------------------------------
// 	Debug Memory 
//----------------------------------------
`ifdef CHIP

`else
SSRAM8bit #15 xram32k 
(
	.CLK  	(clk_cpu), 
	
	.ADDR 	(mem_addr[14:0]), // xrom xram address °øÀ¯
	.CEn  	(xram32k_CEn),
	.WEn  	(xram_we_b),
	.RDATA	(xram32k_dout),
	.WDATA	(xram_din)
);// 0-32k
`endif

`ifdef VER2
// Memory  IF Block
//----------------------------------------
// MMC/SD Slave IP Block
//----------------------------------------
ep560k1 uMMCSlave(
	.cmdin					(cmdin),
	.cmdout					(cmdout),
	.dtin					(dtin),
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
	
	.card_ecc_disabled		(card_ecc_disabled),
	.card_ecc_failed		(card_ecc_failed),
	.cid					(cid),
	.csd					(csd),
	.dsr					(dsr),
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
	.ecsd_r					(ecsd_r),
	.ecsd_s					(ecsd_s),
	.hreset_b				(hreset_b),
	.ocr_mem				(ocr_mem),
	.oe_card_detect			(oe_card_detect),
	.pwdin					(pwdin),
	.pwd_len				(pwd_len),
	.rd_thd					(rd_thd),
	.scr					(scr),
	.sel_mmc				(sel_mmc),// PAD Seltect??
	.sresetm_b				(sresetm_b)
);

//----------------------------------------
// MMC/SD Slave Wrapper Block
//----------------------------------------
MMC_Wrapper uMMCWrapper(
	// MMC Side

	.RESETn				(RESETn),
	.CLK				(CLK),
	.STATIC_CS			(STATIC_CS	),
	.WAP_REG_CS			(WAP_REG_CS	),
	.EXT_SFR_ADDR		(EXT_SFR_ADDR),
	.EXT_SFR_DOUT		(EXT_SFR_DOUT),
	.EXT_SFR_WR			(EXT_SFR_WR	),
	.STATIC_DIN			(STATIC_DIN	),
	.WAP_REG_DIN		(WAP_REG_DIN),

	.sdclk				(sdclk	),
	.hreset_b			(hreset_b),

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
	.scr				(scr		),
	.mmc_beb			(),
	.mmc_rdb			(),
	.mmc_wrb			(),
	.mmc_tsize			(),

	.rdyb				(),
	.err				(),

	.MMCRAM_DATAi		(MMCRAM_DATAi),
	.MMCRAM_DATAo		(MMCRAM_DATAo)
);
`endif
//----------------------------------------
// External SFR Chip Select & Mux Logic
//----------------------------------------
ESFR_MUX uESFR_MUX(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.EXT_SFR_ADDR	(EXT_SFR_ADDR	),
	.EXT_SFR_WR		(EXT_SFR_WR		),
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	),	
	.EXT_SFR_DIN	(EXT_SFR_DIN	),
	
/*	.IOWidthPinIn0	(IOWidthPinIn0	),
	.NandWidthPinIn0(NandWidthPinIn0),
	.BootCfgPinIn0	(BootCfgPinIn0	),
	.OutDtmnPinIn0	(OutDtmnPinIn0	),
	                                
	.IOWidthPinIn1	(IOWidthPinIn1	),
	.NandWidthPinIn1(NandWidthPinIn1),
	.BootCfgPinIn1	(BootCfgPinIn1	),
	.OutDtmnPinIn1	(OutDtmnPinIn1	),
*/
	.MEM_CTRL_DIN	(MEM_CTRL_DIN	),	 
	.WAP_REG_DIN	(WAP_REG_DIN	),
	.STATIC_DIN		(STATIC_DIN		),
	.NAND_DMA0_DIN	(NAND_DMA0_DIN	),
	.NAND_DMA1_DIN	(NAND_DMA1_DIN	),
	.NAND_CTRL0_DIN	(NAND_CTRL0_DIN	),
	.NAND_CTRL1_DIN	(NAND_CTRL1_DIN	),
	.RS_ENC0_DIN	(RS_ENC0_DIN	),
	.RS_ENC1_DIN	(RS_ENC1_DIN	),
	.RS_DEC0_DIN	(RS_DEC0_DIN	),
	.RS_DEC1_DIN	(RS_DEC1_DIN	),
                                    
	.MEM_CTRL_CS	(MEM_CTRL_CS	), 
	.WAP_REG_CS		(WAP_REG_CS		),
	.STATIC_CS		(STATIC_CS		),
	.NAND_DMA0_CS	(NAND_DMA0_CS	),
	.NAND_DMA1_CS	(NAND_DMA1_CS	),
	.NAND_CTRL0_CS	(NAND_CTRL0_CS	),
	.NAND_CTRL1_CS	(NAND_CTRL1_CS	),
	.RS_ENC0_CS		(RS_ENC0_CS		),
	.RS_ENC1_CS		(RS_ENC1_CS		),
	.RS_DEC0_CS		(RS_DEC0_CS		),
	.RS_DEC1_CS		(RS_DEC1_CS		)
);

//----------------------------------------
// Internal Memory Controller
//----------------------------------------
MemCtrlTop uMemCtrl(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.be_b			(be_b			),
	.size			(size			),
	.abort			(abort			),
	.mmc_rdy_b		(mmc_rdy_b		),
	.xram_addr		(xram_addr		),
	.xram_we_b		(xram_we_b		),
	.xram_ce_b		(xram_ce_b		),
	//NMOE,          
	.MD				(memctrl_dout	),
	.FO				(xram_din		),
	
	.CS				(MEM_CTRL_CS	),
	.EXT_SFR_ADDR	(EXT_SFR_ADDR	),
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	),
	.EXT_SFR_WR		(EXT_SFR_WR		),
	.EXT_SFR_DIN	(MEM_CTRL_DIN	),
	
	.NandMode		(NandMode		),

	.MMCRAM_DATAi	(MMCRAM_DATAi	),
	.MMCRAM_DATAo	(MMCRAM_DATAo	),

	.NandRAM_Addr0	(NandRAM_Addr0 ), 
	.NandRAM_Addr1	(NandRAM_Addr1 ),
	.NandRAM_Wen0	(NandRAM_Wen0  ),
	.NandRAM_Wen1	(NandRAM_Wen1  ),
                                   
	.NandRAM0_DATAo	(NandRAM0_DATAo),
	.NandRAM0_DATAi	(NandRAM0_DATAi),
	.NandRAM1_DATAo	(NandRAM1_DATAo),
	.NandRAM1_DATAi	(NandRAM1_DATAi),
                                   
	.MMCTransferEnd	(MMCTransferEnd)	
);// Internal Memory Controller

//----------------------------------------
// 	NAND Pad Mux
//----------------------------------------
NandExtMux uNandExtMux(
	.NandMode		(NandMode	 ),
                                 
	.NFDataIn0		(NFDataIn0	 ),
	.NFDataOut0		(NFDataOut0	 ),
	.NFDataOutEn0	(NFDataOutEn0),
                                 
	.NFDataIn1		(NFDataIn1[7:0]),
	.NFDataOut1		(NFDataOut1[7:0]),
	.NFDataOutEn1	(NFDataOutEn1),
                                 
	.pNFDataIn		(NFDataIn	 ),
	.pNFDataOut		(NFDataOut	 ),
	.pNFDataOutEn	(NFDataOutEn)
);// Nand 16 bit & 8 bit Joint Mux

//----------------------------------------
// 	NAND Controller0
//----------------------------------------
NFTop	uNF_CTRL0(
	.PCLK	    	(CLK),
	.PRESETn     	(RESETn),
	.EXT_SFR_ADDR	(EXT_SFR_ADDR),
	.EXT_SFR_WR  	(EXT_SFR_WR),

	.EXT_SFR_DOUT	(EXT_SFR_DOUT),
	.EXT_SFR_DIN 	(NAND_CTRL0_DIN),
	.CS          	(NAND_CTRL0_CS	),

	.WDATA       	(NandRAM0_DATAo),
	.RDATA       	(NandRAM0_DATAi),
	.We         	(Nand0_WEn),
	.Oe         	(Nand0_REn),

	.NFDMAReqOut 	(NandREQ0),
	.NFINTOut    	(NandInt0),

/*
	.IOWidthPinIn	(IOWidthPinIn0),
	.NandWidthPinIn	(NandWidthPinIn0),
	.BootCfgPinIn	(BootCfgPinIn0),
	.OutDtmnPinIn	(OutDtmnPinIn0),
*/
	.NFDataIn    	(NFDataIn0),
	.NFDataOut   	(NFDataOut0),
	.NFDataOutEn 	(NFDataOutEn0),
	.CLE         	(CLE[0]     ),
	.ALE         	(ALE[0]     ),
	.nNFCE3      	(nNFCE[3]	),
	.nNFCE2      	(nNFCE[2]   ),
	.nNFCE1      	(nNFCE[1]   ),
	.nNFCE0      	(nNFCE[0]   ),
	.nNFRE       	(nNFRE[0]   ),
	.nNFWE       	(nNFWE[0]   ),
	.RnB3        	(RnB[3]     ),
	.RnB2        	(RnB[2]     ),
	.RnB1        	(RnB[1]     ),
	.RnB0       	(RnB[0]     )
);// NAND Controller 0

//----------------------------------------
// 	NAND Controller1
//----------------------------------------
NFTop	uNF_CTRL1(
	.PCLK	    	(CLK),
	.PRESETn     	(RESETn),
	.EXT_SFR_ADDR	(EXT_SFR_ADDR),
	.EXT_SFR_WR  	(EXT_SFR_WR  ),
	
	.EXT_SFR_DOUT	(EXT_SFR_DOUT),
	.EXT_SFR_DIN 	(NAND_CTRL1_DIN),

	.CS          	(NAND_CTRL1_CS),

	.WDATA       	(NandRAM1_DATAo),
	.RDATA       	(NandRAM1_DATAi),
	.We          	(Nand1_WEn),
	.Oe          	(Nand1_REn),

	.NFDMAReqOut 	(NandREQ1),
	.NFINTOut    	(NandInt1),
/*
	.IOWidthPinIn	(IOWidthPinIn1),   
	.NandWidthPinIn	(NandWidthPinIn1),   
	.BootCfgPinIn	(BootCfgPinIn1),   
	.OutDtmnPinIn	(OutDtmnPinIn1),   
*/
	.NFDataIn    	(NFDataIn1),
	.NFDataOut   	(NFDataOut1),
	.NFDataOutEn 	(NFDataOutEn1),
	.CLE         	(CLE[1]    ),
	.ALE         	(ALE[1]    ),
	.nNFCE3      	(nNFCE[7] 	),
	.nNFCE2      	(nNFCE[6] 	),
	.nNFCE1      	(nNFCE[5] 	),
	.nNFCE0      	(nNFCE[4] 	),
	.nNFRE       	(nNFRE[1]  ),
	.nNFWE       	(nNFWE[1]  ),
	.RnB3        	(RnB[7]	  ),
	.RnB2        	(RnB[6]   ),
	.RnB1        	(RnB[5]   ),
	.RnB0        	(RnB[4]   )
); // NAND Controller 1

//----------------------------------------
// 	DMA Controller 1
//----------------------------------------
RSNAND_DMATop uRSNAND_DMA0
(	
	.RESETn			(RESETn		),
	.CLK			(CLK		),
	.CS				(NAND_DMA0_CS),
	.EXT_SFR_DIN	(NAND_DMA0_DIN), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR), 
	.EXT_SFR_WR		(EXT_SFR_WR	),
                                    
	.RSEn_Wait		(RSEn_Wait0	),
	.RSDe_Wait		(RSDe_Wait0	),
	.DecodeEndCnt	(DecodeEndCnt0),
	.SyndProcess	(SyndProcess0),
                                    
	.NandREQ		(NandREQ0	), // Nand DATA request
	.TransferEnd	(TransferEnd0),
	.BigBlk			(BigBlk_0	),
	.SmallBlk		(SmallBlk_0	),
	.SmallBlk2		(SmallBlk2_0),
	.SmallBlk3		(SmallBlk3_0),
                                    
	.Nand_WEn		(Nand0_WEn	),
	.Nand_REn		(Nand0_REn	),
                                    
	.RAM_ADDR		(NandRAM_Addr0),
                                   
	.RAM_WEn		(NandRAM_Wen0),
	.RAM_REn		(),
                                    
	.RSEn_Start		(RSEn_Start0),
	.RSDe_Start		(RSDe_Start0)
);// DMA Controller 0

//----------------------------------------
//	DMA Controller 1
//----------------------------------------
RSNAND_DMATop uRSNAND_DMA1
(	
	.RESETn			(RESETn		),
	.CLK			(CLK		),
	.CS				(NAND_DMA1_CS),
	.EXT_SFR_DIN	(NAND_DMA1_DIN), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR), 
	.EXT_SFR_WR		(EXT_SFR_WR	),
                                    
	.RSEn_Wait		(RSEn_Wait1	),
	.RSDe_Wait		(RSDe_Wait1	),
	.DecodeEndCnt	(DecodeEndCnt1),
	.SyndProcess	(SyndProcess1),
                                    
	.NandREQ		(NandREQ1	), // Nand DATA request
	.TransferEnd	(TransferEnd1),
	.BigBlk			(BigBlk_1	),
	.SmallBlk		(SmallBlk_1	),
	.SmallBlk2		(SmallBlk2_1),
	.SmallBlk3		(SmallBlk3_1),
                                    
	.Nand_WEn		(Nand1_WEn	),
	.Nand_REn		(Nand1_REn	),
                                    
	.RAM_ADDR		(NandRAM_Addr1),
                                   
	.RAM_WEn		(NandRAM_Wen1),
	.RAM_REn		(),
                                    
	.RSEn_Start		(RSEn_Start1),
	.RSDe_Start		(RSDe_Start1)
);// DMA Controller 1

`ifdef VER2
//----------------------------------------
// Reed Solomon Encoder 0
//----------------------------------------
RSEncoderTop uRSEncoder0
(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.CS				(RS_ENC0_CS		),
	.EXT_SFR_DIN	(RS_ENC0_DIN	), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR	), 
	.EXT_SFR_WR		(EXT_SFR_WR		),
//	.NandRAM_DATAo	(NandRAM0_DATAo	),
	.NandRAM_DATAo	({2'b00,NandRAM0_DATAo}),
	.RSEn_Start		(RSEn_Start0	),
	.RSEn_Wait		(RSEn_Wait0		),
	.RSEn_End		(RSEn_End0		) // To Interrupt
);// Reed Solomon Encoder 0

//----------------------------------------
//	Reed Solomon Encoder 1
//----------------------------------------
RSEncoderTop uRSEncoder1
(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.CS				(RS_ENC1_CS		),
	.EXT_SFR_DIN	(RS_ENC1_DIN	), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR	), 
	.EXT_SFR_WR		(EXT_SFR_WR		),
	.NandRAM_DATAo	({2'b00,NandRAM1_DATAo}),
	.RSEn_Start		(RSEn_Start1	),
	.RSEn_Wait		(RSEn_Wait1		),
	.RSEn_End		(RSEn_End1		) // To Interrupt
);// Reed Solomon Encoder 1

//----------------------------------------
//	Reed Solomon Decoder 0
//----------------------------------------
RSDecoderTop uRSDecoder0(
	.RESETn			(RESETn		   ),
	.CLK			(CLK		   ),
	.CS				(RS_DEC0_CS	   ),
	.EXT_SFR_DIN	(RS_DEC0_DIN   ), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT  ), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR  ), 
	.EXT_SFR_WR		(EXT_SFR_WR	   ),
	.NandReadData	(NandRAM0_DATAi),
	.RSDe_Start		(RSDe_Start0   ),
	.RSDe_Wait		(RSDe_Wait0	   ),
	.SyndProcess	(SyndProcess0  ),
	.DecodeEndCnt	(DecodeEndCnt0 ),
                                   
	.BigBlk			(BigBlk_0	   ),
	.SmallBlk		(SmallBlk_0	   ),
	.SmallBlk2		(SmallBlk2_0   ),
	.SmallBlk3		(SmallBlk3_0   )
);// Reed Solomon Decoder 0

//----------------------------------------
//	Reed Solomon Decoder 1
//----------------------------------------
RSDecoderTop uRSDecoder1(
	.RESETn			(RESETn		   ),
	.CLK			(CLK		   ),
	.CS				(RS_DEC1_CS	   ),
	.EXT_SFR_DIN	(RS_DEC1_DIN	), 
	.EXT_SFR_DOUT	(EXT_SFR_DOUT	), 
	.EXT_SFR_ADDR	(EXT_SFR_ADDR	), 
	.EXT_SFR_WR		(EXT_SFR_WR		),
	.NandReadData	(NandRAM1_DATAi),
	.RSDe_Start		(RSDe_Start1   ),
	.RSDe_Wait		(RSDe_Wait1    ),
	.SyndProcess	(SyndProcess1  ),
	.DecodeEndCnt	(DecodeEndCnt1 ),
                                   
	.BigBlk			(BigBlk_1	   ),
	.SmallBlk		(SmallBlk_1	   ),
	.SmallBlk2		(SmallBlk2_1   ),
	.SmallBlk3		(SmallBlk3_1   )
);// Reed Solomon Decoder 1
`endif
endmodule
