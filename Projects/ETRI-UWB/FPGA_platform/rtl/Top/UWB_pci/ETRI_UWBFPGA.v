// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : ETRI_UWBFPGA.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : ETRI UWB Top module for FPGA implementaion
// --========================================================================--

`timescale 1ns/1ps
module ETRI_UWBFPGA
  (
   // System Reset & CLK
   nRESET,
   CLK,
   CLK33M,
   CLK100M,

		// Mac Interrupt source
		MacIntSrc,

	    // AHB MASTER0 Interface for MAC (FROM FPGA1)
	    HADDR_M0,
	    HTRANS_M0,
	    HWRITE_M0,
	    HSIZE_M0,
	    HBURST_M0,
	    HPROT_M0,
	    HWDATA_M0,
	    HRDATA_M0,
	    HREADY_OUT_M0,
	    HRESP_M0,
	 
	    // AHB SLAVE0 Interface for MAC (TO FOGA1)
	    HADDR_S0,
	    HTRANS_S0,
	    HWRITE_S0,
	    HSIZE_S0,
	    HBURST_S0,
	    HPROT_S0,
	    HWDATA_S0,
	    HRDATA_S0,
	    HREADY_IN_S0,
	    HRESP_S0,
	 
	    HSEL_S0,
	 
	    // AHB SLAVE1 Interface to MAC (TO FPGA1)
	    HADDR_S1,
	    HTRANS_S1,
	    HWRITE_S1,
	    HSIZE_S1,
	    HBURST_S1,
	    HPROT_S1,
	    HWDATA_S1,
	    HRDATA_S1,
	    HREADY_IN_S1,
	    HRESP_S1,
	 
	    HSEL_S1,

		// BOT Config Pin
		BOOTNAND,	// 0 : NOR(ROM) Boot, 1 : NAND Boot
		BOOTCSSWAP,	// 0 : WaveROM(CS0), RomEmul(CS1), 1 : RomEmul(CS0), WaveROM(CS1)

		// Boot ROM
		ROM_ADDR,
		ROM_DATA,
		ROM_nCS,
		ROM_nOE,

		// DDR
		DDR_CLK,
		DDR_nCLK,
		DDR_CKE,
		DDR_CSB,
		DDR_RASB,
		DDR_CASB,
		DDR_WEB,
		DDR_BADDR,
		DDR_ADDR,
		DDR_DQ,
		DDR_DQM,
		DDR_DQS,

		// UART
		UART_TXD,
		UART_RXD,

		// I2C
        /*
		I2C_SDA,
		I2C_SCL,
		*/
        I2C_SCLi,
        I2C_SDAi,
        I2C_SCLo,
        I2C_SDAo,
        I2C_nSCLEn,
        I2C_nSDAEn,

		// NAND Flash
		NF_IO,
		NF_CLE,
		NF_ALE,
//		NF_nCE1,
		NF_nCE0,
		NF_nRE,
		NF_nWE,
//		NF_RnB1,
		NF_RnB0,

		// ARM ICE
		ARMICE_nSRST,
		ARMICE_nTRST,
		ARMICE_TCK,
		ARMICE_RTCK,
		ARMICE_TMS,
		ARMICE_TDI,
		ARMICE_TDO,

		// GPIO
		GPIO0,
		GPIO1,

		// 7 Segment LED
		SevenSegmentCommon,
		SevenSegmentControl,

		// SPI
		SPI_SDO,
		SPI_SDI,
		SPI_SCK,

		// I2S Controller
        /*
		I2S_MCLK,
		I2S_BCLK,
		I2S_LRCLK,
		I2S_SDOUT,
		I2S_SDIN,
        */
        I2S_MCLK,
        I2S_MCLK_OE,
        I2S_BCLK_O,
        I2S_BCLK_I,
        I2S_BCLK_OE,
        I2S_LRCLK_O,
        I2S_LRCLK_I,
        I2S_LRCLK_OE,
        I2S_SDIN,
        I2S_SDOUT,       

        // PCI
		pci_clk,
		pci_reset,
        adin,
        adout,
        arb_gnt_b,
        arb_req_b,
        cbein_b,
        cbeout_b,
        devselin_b,
        devselout_b,
        framein_b,
        frameout_b,
        gnt_b,
        idsel,
        intaout_b,
        irdyin_b,
        irdyout_b,
        parin,
        parout,
        perrin_b,
        perrout_b,
        reqout_b,
        serrout_b,
        stopin_b,
        stopout_b,
        trdyin_b,
        trdyout_b,
        oe_ad,
        oe_cbe,
        oe_devsel,
        oe_frame,
        oe_irdy,
        oe_par,
        oe_perr,
        oe_req,
        oe_stop,
        oe_trdy,

        PCI_INTAb,
        PCI_INTBb,
        PCI_INTCb,
        PCI_INTDb,


		// Clock Test Out
		CLK200M_Out,
		CLK100M_Out,
		CLK50M_Out

);

parameter CLK_PERIOD = 5;	// 200 MHz for DDR
parameter CLK_HPERIOD = CLK_PERIOD/2;
parameter SDLY   = 2;		// System Delay

input         nRESET;
input         CLK;
input         CLK33M;
output     CLK100M;
 
// Mac Interrupt source
input [ 1:0]  MacIntSrc;
  
// AHB MASTER Interface for MAC (from FPGA1)
input [31:0]  HADDR_M0;
input [ 1:0]  HTRANS_M0;
input         HWRITE_M0;
input [ 2:0]  HSIZE_M0;
input [ 2:0]  HBURST_M0;
input [ 3:0]  HPROT_M0;
input [31:0]  HWDATA_M0;
output[31:0]  HRDATA_M0;
output        HREADY_OUT_M0;
output[ 1:0]  HRESP_M0;

// AHB SLAVE0 Interface for MAC (to FPGA1)
output[31:0]  HADDR_S0;
output[ 1:0]  HTRANS_S0;
output        HWRITE_S0;
output[ 2:0]  HSIZE_S0;
output[ 2:0]  HBURST_S0;
output[ 3:0]  HPROT_S0;
output[31:0]  HWDATA_S0;
input [31:0]  HRDATA_S0;
input         HREADY_IN_S0;
input [ 1:0]  HRESP_S0;

output        HSEL_S0;

// AHB SLAVE1 Interface for MAC (to FPGA1)
output[31:0]  HADDR_S1;
output[ 1:0]  HTRANS_S1;
output        HWRITE_S1;
output[ 2:0]  HSIZE_S1;
output[ 2:0]  HBURST_S1;
output[ 3:0]  HPROT_S1;
output[31:0]  HWDATA_S1;
input [31:0]  HRDATA_S1;
input         HREADY_IN_S1;
input [ 1:0]  HRESP_S1;

output        HSEL_S1;

// Boot mode setting
input         BOOTNAND;	// 0 : NOR(ROM) Boot, 1 : NAND Boot
input         BOOTCSSWAP;

output [19:0] ROM_ADDR;
input  [15:0] ROM_DATA;
output        ROM_nCS;
output        ROM_nOE;

output        DDR_CLK  ;
output        DDR_nCLK ;
output        DDR_CKE  ; // clock enable
output        DDR_CSB  ; // chip select
output        DDR_RASB ; // row address strobe
output        DDR_CASB ; // column address strobe
output        DDR_WEB  ; // write enable
output [1:0]  DDR_BADDR; // bank address
output [12:0] DDR_ADDR ; // address
inout  [15:0] DDR_DQ; // data output
output [1:0]  DDR_DQM;
inout  [1:0]  DDR_DQS;

// UART Only 2 Channel support on FPGA
output [1:0]  UART_TXD;
input  [1:0]  UART_RXD;

// I2C
/*
inout         I2C_SDA;
inout         I2C_SCL;
*/

input         I2C_SCLi;
input         I2C_SDAi;
output        I2C_SCLo;
output        I2C_SDAo;
output        I2C_nSCLEn;
output        I2C_nSDAEn;

// NAND Controller
inout  [7:0]  NF_IO;
output        NF_CLE;
output        NF_ALE;
output        NF_nCE0;
//output        NF_nCE1;
wire          NF_nCE1;
output        NF_nRE;
output        NF_nWE;
input         NF_RnB0;
//input         NF_RnB1;
wire          NF_RnB1;
assign        NF_RnB1 = 1'b1;

// External JTAG signal
inout         ARMICE_nSRST;
input         ARMICE_nTRST;
input         ARMICE_TCK;
output        ARMICE_RTCK;
input         ARMICE_TMS;
input         ARMICE_TDI;
output        ARMICE_TDO;

// GPIO
inout  [31:20] GPIO0;
inout  [ 7:0] GPIO1;

// Seven Segment 
output [ 3:0] SevenSegmentCommon;
output [ 7:0] SevenSegmentControl;

// SPI
output        SPI_SDO;
input         SPI_SDI;
output        SPI_SCK;

// I2S
/*
output        I2S_MCLK;
inout         I2S_BCLK;
inout         I2S_LRCLK;
output        I2S_SDOUT;
input         I2S_SDIN;
*/
output        I2S_MCLK;
output        I2S_MCLK_OE;
output        I2S_BCLK_O;
input         I2S_BCLK_I;
output        I2S_BCLK_OE;
output        I2S_LRCLK_O;
input         I2S_LRCLK_I;
output        I2S_LRCLK_OE;
input         I2S_SDIN;
output        I2S_SDOUT;


// PCI 
output	      pci_clk;
output	      pci_reset;
input[31:0]   adin;
output[31:0]  adout;
output[4:1]   arb_gnt_b;
input[4:1]    arb_req_b;
input[3:0]    cbein_b;
output[3:0]   cbeout_b;
input         devselin_b;
output        devselout_b;
input         framein_b;
output        frameout_b;
input         gnt_b;
input         idsel;
output        intaout_b;
input         irdyin_b;
output        irdyout_b;
input         parin;
output        parout;
input         perrin_b;
output        perrout_b;
output        reqout_b;
output        serrout_b;
input         stopin_b;
output        stopout_b;
input         trdyin_b;
output        trdyout_b;
output        oe_ad;
output        oe_cbe;
output        oe_devsel;
output        oe_frame;
output        oe_irdy;
output        oe_par;
output        oe_perr;
output        oe_req;
output        oe_stop;
output        oe_trdy;

input         PCI_INTAb;
input         PCI_INTBb;
input         PCI_INTCb;
input         PCI_INTDb;


// CLK test
output        CLK200M_Out;
output        CLK100M_Out;
output        CLK50M_Out;

assign pci_clk = CLK33M;
assign pci_reset=nRESET;

// Reset Control
wire  nRESET_nSRST;
wire  nSYSRESET;
assign nRESET_nSRST = nRESET & ARMICE_nSRST;
assign ARMICE_nSRST = (nRESET == 0) ? 1'b0 : 1'bz;

reg [11:0] RESET_CNT;
always @(negedge nRESET_nSRST or posedge CLK)
begin
	if(!nRESET_nSRST)
		RESET_CNT <= 0;
	else if(RESET_CNT[11] == 0)
		RESET_CNT <= RESET_CNT + 1;
end

wire NF_DMADone;
reg ARMnRESET;
always @(negedge nRESET_nSRST or posedge CLK)
begin
	if(!nRESET_nSRST)
		ARMnRESET <= 0;
	else
	begin
		if(~BOOTNAND)
		begin
			if(NF_DMADone == 1)
				ARMnRESET <= 1'b1;
		end
		else
			ARMnRESET <= RESET_CNT[11];
	end
end

assign nSYSRESET = RESET_CNT[11];

wire		 SMC_nOE;
wire [ 3:0]  SMC_nBE  ;
wire [ 3:0]  SMC_nWBE ;
wire [26:0]  SMC_ADDR;
wire [ 8:0]  SMC_nCS;
//reg  [15:0]  SMC_RDATA;
wire [15:0]  SMC_WDATA;
wire         SMC_BIDEN;

wire [12:0]  DDR_ADDR;
wire [1:0]   DDR_BADDR;
wire         DDR_CSB;
wire         DDR_RASB;
wire         DDR_CASB;
wire         DDR_WEB;
wire [1:0]   DDR_DQM;
wire		 DDR_CKE;

wire         #0.5 DDR_DQE;
wire [15:0]  DDR_DQI;
wire [15:0]  DDR_DQO;
wire [1:0]   DDR_DQSO;
wire [1:0]   DDR_DQSI;

wire [3:0]   UART_TXD_4CH;
wire [3:0]   UART_RXD_4CH;

wire        I2C_SCLi;
wire        I2C_SDAi;
wire        I2C_SCLo;
wire        I2C_SDAo;
wire        I2C_nSCLEn;
wire        I2C_nSDAEn;

wire [31:0] GPIO0_OE;
wire [31:0] GPIO0_OUT;
wire [31:0] GPIO1_OE;
wire [31:0] GPIO1_OUT;

wire [ 1:0] I2SInputMux;

// SPI
/*
wire I2S_MCLK_O;
wire I2S_MCLK_OE;
wire I2S_BCLK_O;
wire I2S_BCLK_I;
wire I2S_BCLK_OE;
wire I2S_LRCLK_O;
wire I2S_LRCLK_I;
wire I2S_LRCLK_OE;
*/
wire I2S_SDIN_Muxed;

wire [15:0] NF_DI;
wire [15:0] NF_DO;
wire        NF_DOE;

// SPI
wire        SPInSSOut;       // Serial Frame Output pin
wire        SPIClkOut;       // Serial Clock Output pin
wire        SPITxd;          // SPI Serial Transmit output
wire        SPInOE;          // Output Enable for SPITxd
wire        SPInCTLOE;       // Output Enable for SPIClkOut and SPInSSOut
wire        SPI_nSS;

wire        CLK200M;
wire        CLK100M;
wire        CLK50M;

wire[3:0]   dummy;

// Clock Generator for FPGA
mypll2x PLL(
	.CLKIN_IN(CLK),
	.CLKDV_OUT(CLK50M),
	.CLKIN_IBUFG_OUT(),
	.CLK0_OUT(CLK100M),
	.CLK2X_OUT(CLK200M),
	.LOCKED_OUT()
);

//wire [31:24] GPIO1;
ETRI_UWBCore Core(
	.nRESET(nSYSRESET),
	.ARMnRESET(ARMnRESET),
	.CLK200M(CLK200M),
	.CLK100M(CLK100M),
	.CLK50M(CLK50M),
	.CLK33M(CLK33M),
    
	//Mac Interrupt source
	.MacIntSrc(MacIntSrc),

	// AHB MASTER0 Interface for MAC (FROM FPGA1)
	.HADDR_M0(HADDR_M0),
	.HTRANS_M0(HTRANS_M0),
	.HWRITE_M0(HWRITE_M0),
	.HSIZE_M0(HSIZE_M0),
	.HBURST_M0(HBURST_M0),
	.HPROT_M0(HPROT_M0),
	.HWDATA_M0(HWDATA_M0),
	.HRDATA_M0(HRDATA_M0),
	.HREADY_OUT_M0(HREADY_OUT_M0),
	.HRESP_M0(HRESP_M0),
	
	// AHB SLAVE0 Interface for MAC (TO FOGA1)
	.HADDR_S0(HADDR_S0),
	.HTRANS_S0(HTRANS_S0),
	.HWRITE_S0(HWRITE_S0),
	.HSIZE_S0(HSIZE_S0),
	.HBURST_S0(HBURST_S0),
	.HPROT_S0(HPROT_S0),
	.HWDATA_S0(HWDATA_S0),
	.HRDATA_S0(HRDATA_S0),
	.HREADY_IN_S0(HREADY_IN_S0),
	.HRESP_S0(HRESP_S0),
	
	.HSEL_S0(HSEL_S0),
	
	// AHB SLAVE0 Interface for MAC (TO FOGA1)
	.HADDR_S1(HADDR_S1),
	.HTRANS_S1(HTRANS_S1),
	.HWRITE_S1(HWRITE_S1),
	.HSIZE_S1(HSIZE_S1),
	.HBURST_S1(HBURST_S1),
	.HPROT_S1(HPROT_S1),
	.HWDATA_S1(HWDATA_S1),
	.HRDATA_S1(HRDATA_S1),
	.HREADY_IN_S1(HREADY_IN_S1),
	.HRESP_S1(HRESP_S1),
	
	.HSEL_S1(HSEL_S1),

    .BOOT_WIDTH(2'b01), //16bit ROM boot

	.SMC_ADDR(SMC_ADDR),
//	.SMC_RDATA(SMC_RDATA),
	.SMC_RDATA(ROM_DATA),
	.SMC_WDATA(SMC_WDATA),
	.SMC_nCS(SMC_nCS),
	.SMC_nOE(SMC_nOE),
	.SMC_nWE(SMC_nWE),
	.SMC_nBE(SMC_nBE),
	.SMC_nWBE(SMC_nWBE),
	.SMC_BIDEN(SMC_BIDEN),

	.DDR_CLK(DDR_CLK),
	.DDR_nCLK(DDR_nCLK),
	.DDR_CKE(DDR_CKE),
	.DDR_CSB(DDR_CSB),
	.DDR_RASB(DDR_RASB),
	.DDR_CASB(DDR_CASB),
	.DDR_WEB(DDR_WEB),
	.DDR_BADDR(DDR_BADDR),
	.DDR_ADDR(DDR_ADDR),
	.DDR_DQE(DDR_DQE),
	.DDR_DQI(DDR_DQI),
	.DDR_DQO(DDR_DQO),
	.DDR_DQM(DDR_DQM),
	.DDR_DQSE(DDR_DQSE),
	.DDR_DQSO(DDR_DQSO),
	.DDR_DQSI(DDR_DQSI),
	.DDR_nDQSI(~DDR_DQSI),

	.UART_TXD(UART_TXD_4CH),
	.UART_RXD(UART_RXD_4CH),
	
	.I2C_SCLi(I2C_SCLi),
	.I2C_SDAi(I2C_SDAi),
	.I2C_SCLo(I2C_SCLo),
	.I2C_SDAo(I2C_SDAo),
	.I2C_nSCLEn(I2C_nSCLEn),
	.I2C_nSDAEn(I2C_nSDAEn),

	.I2S_MCLK(I2S_MCLK),
	.I2S_MCLK_OE(I2S_MCLK_OE),
	.I2S_BCLK_O(I2S_BCLK_O),
	.I2S_BCLK_I(I2S_BCLK_I),
	.I2S_BCLK_OE(I2S_BCLK_OE),
	.I2S_LRCLK_O(I2S_LRCLK_O),
	.I2S_LRCLK_I(I2S_LRCLK_I),
	.I2S_LRCLK_OE(I2S_LRCLK_OE),
	.I2S_SDIN(I2S_SDIN),
	.I2S_SDOUT(I2S_SDOUT),

	.NF_Boot(~BOOTNAND),
	.NF_IOWidth(1'b0),		// 8 bit IO
	.NF_Width(1'b0),		// 8 bit IO
	.NF_BootCfg(2'b11),		// What the hell is it?
	.NF_OutDtmn(1'b1),		// What the hell is it?
	.NF_DMADone(NF_DMADone),	// DMA Finishied

	// NAND connection
	.NF_DI(NF_DI),
	.NF_DO(NF_DO),
	.NF_DOE(NF_DOE),
	.NF_CLE(NF_CLE),
	.NF_ALE(NF_ALE),
	.NF_nCE1(NF_nCE1),
	.NF_nCE0(NF_nCE0),
	.NF_nRE(NF_nRE),
	.NF_nWE(NF_nWE),
	.NF_RnB1(NF_RnB1),
	.NF_RnB0(NF_RnB0),

	.GPIO0_IN({GPIO0[31:20], 20'h00000}),
	.GPIO0_OE(GPIO0_OE[31:0]),
	.GPIO0_OUT(GPIO0_OUT[31:0]),

	.GPIO1_IN({24'h000000, GPIO1[7:0]}),
	.GPIO1_OE(GPIO1_OE[31:0]),
	.GPIO1_OUT(GPIO1_OUT[31:0]),

	.SPIRxd(SPI_SDI),
	.SPInSSIn(SPI_nSS),
	.SPIClkIn(SPI_SCK),
	.SPInSSOut(SPInSSOut),
	.SPIClkOut(SPIClkOut),
	.SPITxd(SPITxd),
	.SPInOE(SPInOE),		// Output Enable for SPITxd
	.SPInCTLOE(SPInCTLOE),		// Ouptut Enable for SPIClkOut/SPInSSOut

    .adin       (adin       ),   
    .adout      (adout      ),    
    .arb_gnt_b  ({dummy,arb_gnt_b,HostBridge_gnt}  ),        
    .arb_req_b  ({4'hf,arb_req_b,HostBridge_req}  ),        
    .cbein_b    (cbein_b    ),      
    .cbeout_b   (cbeout_b   ),       
    .devselin_b (devselin_b ),         
    .devselout_b(devselout_b),          
    .framein_b  (framein_b  ),        
    .frameout_b (frameout_b ),         
    .gnt_b      (HostBridge_gnt),    
    .idsel      (idsel      ),    
    .intaout_b  (intaout_b  ),  // Card로 사용될때        
    .irdyin_b   (irdyin_b   ),       
    .irdyout_b  (irdyout_b  ),        
    .parin      (parin      ),    
    .parout     (parout     ),     
    .perrin_b   (perrin_b   ),       
    .perrout_b  (perrout_b  ),        
    .reqout_b   (HostBridge_req),       
    .serrout_b  (serrout_b  ),        
    .stopin_b   (stopin_b   ),       
    .stopout_b  (stopout_b  ),        
    .trdyin_b   (trdyin_b   ),       
    .trdyout_b  (trdyout_b  ),        
    .oe_ad      (oe_ad      ),    
    .oe_cbe     (oe_cbe     ),     
    .oe_devsel  (oe_devsel  ),        
    .oe_frame   (oe_frame   ),       
    .oe_irdy    (oe_irdy    ),      
    .oe_par     (oe_par     ),     
    .oe_perr    (oe_perr    ),      
    .oe_req     (oe_req     ),     
    .oe_stop    (oe_stop    ),      
    .oe_trdy    (oe_trdy    ),      
    
    .PCI_INTAb  (PCI_INTAb  ),
    .PCI_INTBb  (PCI_INTBb  ),
    .PCI_INTCb  (PCI_INTCb  ),
    .PCI_INTDb  (PCI_INTDb  ),


	.ARMICE_nTRST(ARMICE_nTRST),
	.ARMICE_TCK(ARMICE_TCK),
	.ARMICE_RTCK(ARMICE_RTCK),
	.ARMICE_TMS(ARMICE_TMS),
	.ARMICE_TDI(ARMICE_TDI),
	.ARMICE_TDO(ARMICE_TDO)
);

// DDR
tri  [15:0] DDR_DQ;
tri  [1:0]  DDR_DQS;
wire        #0.5 DDR_DQSE;

assign #SDLY DDR_DQ  = DDR_DQE ? DDR_DQO : {16{1'bz}};
assign #CLK_HPERIOD DDR_DQI = DDR_DQ;

assign #SDLY DDR_DQS  = DDR_DQSE ? DDR_DQSO : {2{1'bz}};

`ifdef SIMUL_ONLY		// Do not define this
wire [1:0] DDR_DQS_Delay;
assign DDR_DQS_Delay = DDR_DQS;
assign #CLK_HPERIOD DDR_DQSI = DDR_DQS_Delay;	// Input Pad Delay
`else
wire [1:0] DDR_DQSI_0; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_1; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_2; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_3; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_4; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_5; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_6; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_7; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_8; // synthesis syn_keep=1
wire [1:0] DDR_DQSI_9; // synthesis syn_keep=1

IDELAY #(.IOBDELAY_TYPE("DEFAULT")) delay0 (
		.O(DDR_DQSI_0[0]),
		.C(),
		.CE(),
		.I(DDR_DQS[0]),
		.INC(),
		.RST()
	);
IDELAY #(.IOBDELAY_TYPE("DEFAULT")) delay1 (
		.O(DDR_DQSI_0[1]),
		.C(),
		.CE(),
		.I(DDR_DQS[1]),
		.INC(),
		.RST()
	);
assign DDR_DQSI_1 = ~DDR_DQSI_0;
assign DDR_DQSI_2 = ~DDR_DQSI_1;
assign DDR_DQSI_3 = ~DDR_DQSI_2;
assign DDR_DQSI_4 = ~DDR_DQSI_3;
assign DDR_DQSI_5 = ~DDR_DQSI_4;
assign DDR_DQSI_6 = ~DDR_DQSI_5;
assign DDR_DQSI_7 = ~DDR_DQSI_6;
assign DDR_DQSI_8 = ~DDR_DQSI_7;
assign DDR_DQSI_9 = ~DDR_DQSI_8;
assign #CLK_HPERIOD DDR_DQSI   = ~DDR_DQSI_9;
`endif

assign UART_TXD = {UART_TXD_4CH[2],UART_TXD_4CH[0]};
assign UART_RXD_4CH = { 1'b0, UART_RXD[1],1'b0,UART_RXD[0] };

// I2C 
/*
tri    I2C_SDA;
tri    I2C_SCL;
assign I2C_SDA  = (I2C_nSDAEn == 0) ? I2C_SDAo : 1'bz;
assign I2C_SDAi = I2C_SDA;
assign I2C_SCL  = (I2C_nSCLEn == 0) ? I2C_SCLo : 1'bz;
assign I2C_SCLi = I2C_SCL;
*/


// BOOT ROM
//assign ROM_nCS = ((BOOTCSSWAP == 1) ? SMC_nCS[0] : SMC_nCS[1]);
assign ROM_nCS = SMC_nCS[0];
assign ROM_nOE = SMC_nOE;
assign ROM_ADDR = SMC_ADDR[20:0];


// NAND Flash
tri [7:0] NF_IO;
assign NF_IO = (NF_DOE == 0) ? NF_DO[7:0] : 8'bzzzzzzzz;
assign NF_DI = {8'h00, NF_IO};


// Seven Segment LED
SevenSegment SevenSegment (
	.Clock(CLK50M),
	.nReset(nSYSRESET),

	.DataIn(GPIO0_OUT[15:0]),
	.DotIn(GPIO0_OUT[19:16]),
	.ControlOut(SevenSegmentControl),
	.CommonOut(SevenSegmentCommon)
);

// GPIO
assign GPIO0[20] = (GPIO0_OE[20] == 1) ? GPIO0_OUT[20] : 1'bz;
assign GPIO0[21] = (GPIO0_OE[21] == 1) ? GPIO0_OUT[21] : 1'bz;
assign GPIO0[22] = (GPIO0_OE[22] == 1) ? GPIO0_OUT[22] : 1'bz;
assign GPIO0[23] = (GPIO0_OE[23] == 1) ? GPIO0_OUT[23] : 1'bz;
assign GPIO0[24] = (GPIO0_OE[24] == 1) ? GPIO0_OUT[24] : 1'bz;
assign GPIO0[25] = (GPIO0_OE[25] == 1) ? GPIO0_OUT[25] : 1'bz;
assign GPIO0[26] = (GPIO0_OE[26] == 1) ? GPIO0_OUT[26] : 1'bz;
assign GPIO0[27] = (GPIO0_OE[27] == 1) ? GPIO0_OUT[27] : 1'bz;
assign GPIO0[28] = (GPIO0_OE[28] == 1) ? GPIO0_OUT[28] : 1'bz;
assign GPIO0[29] = (GPIO0_OE[29] == 1) ? GPIO0_OUT[29] : 1'bz;
assign GPIO0[30] = (GPIO0_OE[30] == 1) ? GPIO0_OUT[30] : 1'bz;
assign GPIO0[31] = (GPIO0_OE[31] == 1) ? GPIO0_OUT[31] : 1'bz;

assign GPIO1[0] = (GPIO1_OE[0] == 1) ? GPIO1_OUT[0] : 1'bz;
assign GPIO1[1] = (GPIO1_OE[1] == 1) ? GPIO1_OUT[1] : 1'bz;
assign GPIO1[2] = (GPIO1_OE[2] == 1) ? GPIO1_OUT[2] : 1'bz;
assign GPIO1[3] = (GPIO1_OE[3] == 1) ? GPIO1_OUT[3] : 1'bz;
assign GPIO1[4] = (GPIO1_OE[4] == 1) ? GPIO1_OUT[4] : 1'bz;
assign GPIO1[5] = (GPIO1_OE[5] == 1) ? GPIO1_OUT[5] : 1'bz;
assign GPIO1[6] = (GPIO1_OE[6] == 1) ? GPIO1_OUT[6] : 1'bz;
assign GPIO1[7] = (GPIO1_OE[7] == 1) ? GPIO1_OUT[7] : 1'bz;
/*
assign GPIO1[8] = (GPIO1_OE[8] == 1) ? GPIO1_OUT[8] : 1'bz;
assign GPIO1[9] = (GPIO1_OE[9] == 1) ? GPIO1_OUT[9] : 1'bz;
assign GPIO1[10] = (GPIO1_OE[10] == 1) ? GPIO1_OUT[10] : 1'bz;
assign GPIO1[11] = (GPIO1_OE[11] == 1) ? GPIO1_OUT[11] : 1'bz;
assign GPIO1[12] = (GPIO1_OE[12] == 1) ? GPIO1_OUT[12] : 1'bz;
assign GPIO1[13] = (GPIO1_OE[13] == 1) ? GPIO1_OUT[13] : 1'bz;
assign GPIO1[14] = (GPIO1_OE[14] == 1) ? GPIO1_OUT[14] : 1'bz;
assign GPIO1[15] = (GPIO1_OE[15] == 1) ? GPIO1_OUT[15] : 1'bz;
assign GPIO1[16] = (GPIO1_OE[16] == 1) ? GPIO1_OUT[16] : 1'bz;
assign GPIO1[17] = (GPIO1_OE[17] == 1) ? GPIO1_OUT[17] : 1'bz;
assign GPIO1[18] = (GPIO1_OE[18] == 1) ? GPIO1_OUT[18] : 1'bz;
assign GPIO1[19] = (GPIO1_OE[19] == 1) ? GPIO1_OUT[19] : 1'bz;
assign GPIO1[20] = (GPIO1_OE[20] == 1) ? GPIO1_OUT[20] : 1'bz;
assign GPIO1[21] = (GPIO1_OE[21] == 1) ? GPIO1_OUT[21] : 1'bz;
assign GPIO1[22] = (GPIO1_OE[22] == 1) ? GPIO1_OUT[22] : 1'bz;
assign GPIO1[23] = (GPIO1_OE[23] == 1) ? GPIO1_OUT[23] : 1'bz;
assign GPIO1[24] = (GPIO1_OE[24] == 1) ? GPIO1_OUT[24] : 1'bz;
assign GPIO1[25] = (GPIO1_OE[25] == 1) ? GPIO1_OUT[25] : 1'bz;
assign GPIO1[26] = (GPIO1_OE[26] == 1) ? GPIO1_OUT[26] : 1'bz;
assign GPIO1[27] = (GPIO1_OE[27] == 1) ? GPIO1_OUT[27] : 1'bz;
assign GPIO1[28] = (GPIO1_OE[28] == 1) ? GPIO1_OUT[28] : 1'bz;
assign GPIO1[29] = (GPIO1_OE[29] == 1) ? GPIO1_OUT[29] : 1'bz;
assign GPIO1[30] = (GPIO1_OE[30] == 1) ? GPIO1_OUT[30] : 1'bz;
assign GPIO1[31] = (GPIO1_OE[31] == 1) ? GPIO1_OUT[31] : 1'bz;
assign GPIO1[29] = (GPIO1_OE[29] == 1) ? GPIO1_OUT[29] : 1'bz;
assign GPIO1[30] = (GPIO1_OE[30] == 1) ? GPIO1_OUT[30] : 1'bz;
*/

// I2S BUS Connection
/*
tri    I2S_LRCLK;
tri    I2S_BCLK;
tri    I2S_MCLK;
assign I2S_MCLK  = (I2S_MCLK_OE) ? I2S_MCLK_O : 1'bz;
assign I2S_LRCLK = (I2S_LRCLK_OE) ? I2S_LRCLK_O : 1'bz;
//assign I2S_LRCLK_I = (I2SInputMux == 2'b00) ? I2S_LRCLK : SEP_MLRCK;
assign I2S_LRCLK_I = (I2SInputMux == 2'b00) ? I2S_LRCLK : 1'b0;
assign I2S_BCLK = (I2S_BCLK_OE) ? I2S_BCLK_O : 1'bz;
//assign I2S_BCLK_I = (I2SInputMux == 2'b00) ? I2S_BCLK : SEIP_MSCK;
assign I2S_BCLK_I = (I2SInputMux == 2'b00) ? I2S_BCLK : 1'b0;
//assign I2S_SDIN_Muxed = (I2SInputMux == 2'b00) ? I2S_SDIN : ((I2SInputMux[0] == 0) ? SEIP_SDI1 : SEIP_SDI2);
assign I2S_SDIN_Muxed = (I2SInputMux == 2'b00) ? I2S_SDIN : 1'b0;
*/


// SPI
assign SPI_SDO = (SPInOE == 0) ? SPITxd : 1'bz;
//assign SPI_nSS[0] = (SPInCTLOE[0] == 0) ? SPInSSOut[0] : 1'bz;
//assign SPI_nSS[1] = (SPInCTLOE[1] == 0) ? SPInSSOut[1] : 1'bz;
assign SPI_nSS = 1'b1;
assign SPI_SCK = (SPInCTLOE == 0) ? SPIClkOut : 1'bz;

reg [26:0] CLK200MCnt;
reg [26:0] CLK100MCnt;
reg [26:0] CLK50MCnt;

always @(posedge CLK200M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK200MCnt <= 0;
	else
		CLK200MCnt <= CLK200MCnt + 1;

always @(posedge CLK100M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK100MCnt <= 0;
	else
		CLK100MCnt <= CLK100MCnt + 1;

always @(posedge CLK50M or negedge nSYSRESET)
	if(!nSYSRESET)
		CLK50MCnt <= 0;
	else
		CLK50MCnt <= CLK50MCnt + 1;

assign CLK200M_Out = CLK200MCnt[26];
assign CLK100M_Out = CLK100MCnt[26];
assign CLK50M_Out  = CLK50MCnt[26];

endmodule
