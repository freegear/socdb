// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DTSDI002Top.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem (EASY)
//                        with File Reader Bus Master and EgMaster.
//  --========================================================================--

`timescale 1ns/1ps
//------------------------------------------------------------------------------
// DTSDI002[ARM7] Address Map
//------------------------------------------------------------------------------
// Full Decoding of the Address Map is performed continuously as a function of
//  HADDR. All unused slots are connected to a Default Slave.

//(Boot mode Low)
// 0x0000_0000 - 0x0010_0000  Internal FLASH               (HSELS0) (SMC alias/Internal Flash) 
// 0x0000_0000 - 0x0010_0000  External SRAM0               (HSELS1_1)

//(Boot mode High )
// 0x0010_0000 - 0x0020_0000  External SRAM0               (HSELS1_0)
// 0x0010_0000 - 0x0020_0000  Internal Flash               (HSELS0)          

// 0x0020_0000 - 0x0010_0000  External SRAM1               (HSELS1_1)
// 0x0030_0000 - 0x0020_0000  External SRAM2               (HSELS1_2)
// 0x0040_0000 - 0x0050_0000  External SRAM3               (HSELS1_3) 
// 0x01F0_0000 - 0x01F4_0000  Internal FLASH mirror        (HSELS0) 
// 0x01FF_0000 - 0x01FF_8000  Internal 24KB SRAM           (HSELS2) 
// 0x01FF_8200 - 0x01FF_8E00  APB                          (HSELS3) 
// 0x0050_0000 - 0x1F00_0000  Reserve1                     (HSELSR) 
// 0x01F4_0000 - 0x01FF_0000  Reserve2                     (HSELSR) 
// 0x01FF_8E00 - 0x0200_0000  Reserve3                     (HSELSR) 
// 0x0200_0000 - 0xFFFF_FFFF  Abort                        (HSELSR) 

// APB address map is:
//
// 0x01FF_8000 - 0x01FF_8100  Internal FLASH Control       (PSELS0) 
// 0x01FF_8100 - 0x01FF_8200  External SRAM Bank Control   (PSELS1) 
// 0x01FF_8200 - 0x01FF_8300 UART                          (PSELS2)  
// 0x01FF_8300 - 0x01FF_8400 I2C0~1                        (PSELS3)
// 0x01FF_8400 - 0x01FF_8500 Timer 0  ~ 7                  (PSELS4)
// 0x01FF_8500 - 0x01FF_8600 PWM   0  ~ 7                  (PSELS5)  
// 0x01FF_8600 - 0x01FF_8700 PWM   8  ~ 15                 (PSELS6)
// 0x01FF_8700 - 0x01FF_8800 PWM   16 ~ 23                 (PSELS7)  
// 0x01FF_8800 - 0x01FF_8900 PWM   24 ~ 31                 (PSELS8) 
// 0x01FF_8900 - 0x01FF_8A00 WDT                           (PSELS9)
// 0x01FF_8A00 - 0x01FF_8B00 GPIO                          (PSELS10)
// 0x01FF_8B00 - 0x01FF_8C00 VIC                           (PSELS11)
// 0x01FF_8C00 - 0x01FF_8D00 ADC IF                        (PSELS12)
// 0x01FF_8D00 - 0x01FF_8E00 Power manager                 (PSELS13)
//------------------------------------------------------------------------------                                                                                                

module DTSDI002Top (
		ARM_RESETi   ,
		ARM_OSCi     ,

  		TEST_MODE    ,
  		BOOT_MODE    ,
		
		I2CSCLi      ,
		I2CSDAi      ,
		I2CSCLo      ,
		I2CSDAo      ,

		ARM_CS       , 
		V5_CS        , 
		ARM_OE       , 
		ARM_WE       , 
		ARM_ADR      ,
		ARM_DATi     , 
		ARM_DATo     ,
		ARM_DOEn     ,

		GpioIn0      ,
		GpioIn1      ,
		GpioIn2      ,
		GpioIn3      ,
		GpioOut0     ,
		GpioOut1     ,
		GpioOut2     ,
		GpioOut3     ,
		GpioEn0      ,
		GpioEn1      ,
		GpioEn2      ,
		GpioEn3      ,

		ToolMode     ,
		FlashSDAo    ,
	
);

// SYSTEM RESET
input         ARM_RESETi;  // System Initialization 1us Held Low

// SYSTEM CLOCK
input         ARM_OSCi;  // OSC. input

// JTAG
/*
input         ARM_TRST;
input         ARM_TMS;
input         ARM_TCK;
input         ARM_TDI;
output        ARM_TDO;
output        nTDOEN;
*/

// TEST MODE
input         TEST_MODE;
output		  ToolMode;
output		  FlashSDAo;

// BOOT MODE
input         BOOT_MODE; 

// I2C
input  [1:0]  I2CSCLi;
input  [1:0]  I2CSDAi;
output [1:0]  I2CSCLo;
output [1:0]  I2CSDAo;

// MEMORY BUS
output        ARM_CS;
output        V5_CS;
output        ARM_OE;
output        ARM_WE;
output [16:0] ARM_ADR;
input  [15:0] ARM_DATi;
output [15:0] ARM_DATo;
output        ARM_DOEn;

// GPIO
input  [7:0]  GpioIn0;
input  [7:0]  GpioIn1;
input  [7:0]  GpioIn2;
input  [7:0]  GpioIn3;
output [7:0]  GpioOut0;
output [7:0]  GpioOut1;
output [7:0]  GpioOut2;
output [7:0]  GpioOut3;
output [7:0]  GpioEn0;
output [7:0]  GpioEn1;
output [7:0]  GpioEn2;
output [7:0]  GpioEn3;

//Analog Input[A/D-Converter]
//input  [7:0]  ADC_IN;
//input         ADC_REF;

//inout 		  FmTvpp;
//inout  [1:0]  FmTtm;

wire	[7:0]	ADC_IN = 8'd0;

//------------------------------------------------------------------------------
// Signal declarations: Test Mode
//------------------------------------------------------------------------------
  wire        BistMode;
  wire        BistFail;
  wire        BistDone;

  wire        ToolMode;

  wire        FlashSCLi;
  wire        FlashSDAi;
  wire        FlashSDAo;
  wire        FlashSDAe;
//assign	BistFail = 1'b0;
//assign	BistDone = 1'b0;

  assign BistMode = TEST_MODE & GpioIn1[0];

//------------------------------------------------------------------------------
// Signal declarations: Common
//------------------------------------------------------------------------------
  wire        TieOffHi1  = 1'b1;
  wire        TieOffLo1  = 1'b0;
  wire [1:0]  TieOffLo2  = 2'b00;
  wire [1:0]  TieOffLo3  = 3'b000;
  wire [3:0]  TieOffLo4  = 4'b0000;
  wire [16:0] TieOffLo16 = {16{1'b0}};
  wire [25:0] TieOffLo26 = {26{1'b0}};
  wire [31:0] TieOffLo32 = {32{1'b0}};

//------------------------------------------------------------------------------
// Signal declarations: AHB Common
//------------------------------------------------------------------------------
  wire          HCLK;
  wire          HRESETn;

//------------------------------------------------------------------------------
// Signal declarations: AHB1
//------------------------------------------------------------------------------
// AHB1 backbone 
  wire [1:0]  HTRANS1;
  wire [31:0] HADDR1;
  wire        HWRITE1;
  wire [2:0]  HSIZE1;
  wire [2:0]  HBURST1;
  wire [3:0]  HPROT1;
  wire [31:0] HWDATA1;
  wire [3:0]  HMASTER1;
  wire [3:0]  HMASTERD1;
  wire        HMASTLOCK1;
  wire [15:0] HSPLIT1;

// Multiplexed slave output signals
  wire [31:0] HRDATA1;
  wire        HREADY1;
  wire [1:0]  HRESP1;

// Slave specific output signals
  wire        HSELS0;
  wire        HSELS1;
  wire        HSELS2;
  wire        HSELS3;
  wire        HSELS4;
  wire        HSELS5;
  wire        HSELS6;
  wire        HSELS7;  
  
  wire [31:0] HRDATA1S0;
  wire        HREADY1S0;
  wire [1:0]  HRESP1S0;
  wire [31:0] HRDATA1S1;
  wire        HREADY1S1;
  wire [1:0]  HRESP1S1;
  wire [31:0] HRDATA1S2;
  wire        HREADY1S2;
  wire [1:0]  HRESP1S2;
  wire [31:0] HRDATA1S3;
  wire        HREADY1S3;
  wire [1:0]  HRESP1S3;
  wire [31:0] HRDATA1S4;
  wire        HREADY1S4;
  wire [1:0]  HRESP1S4;
  wire [31:0] HRDATA1S5;
  wire        HREADY1S5;
  wire [1:0]  HRESP1S5;
  wire [31:0] HRDATA1S6;
  wire        HREADY1S6;
  wire [1:0]  HRESP1S6;
  wire [31:0] HRDATA1S7;
  wire        HREADY1S7;
  wire [1:0]  HRESP1S7;
  wire        HREADY1DefSlv;
  wire [1:0]  HRESP1DefSlv;
  wire        HSEL1DefSlv;

// Master specific signals
  wire        HBUSREQ1M0;
  wire        HLOCK1M0;
  wire        HGRANT1M0;

  wire [31:0] HADDR1M1;
  wire [1:0]  HTRANS1M1;
  wire        HWRITE1M1;
  wire [2:0]  HSIZE1M1;
  wire [2:0]  HBURST1M1;
  wire [3:0]  HPROT1M1;
  wire [31:0] HWDATA1M1;
  wire        HBUSREQ1M1;
  wire        HLOCK1M1;
  wire        HGRANT1M1;

  wire [31:0] HADDR1M2;
  wire [1:0]  HTRANS1M2;
  wire        HWRITE1M2;
  wire [2:0]  HSIZE1M2;
  wire [2:0]  HBURST1M2;
  wire [3:0]  HPROT1M2;
  wire [31:0] HWDATA1M2;
  wire        HBUSREQ1M2;
  wire        HLOCK1M2;
  wire        HGRANT1M2;

  wire [31:0] HADDR1M3;
  wire [1:0]  HTRANS1M3;
  wire        HWRITE1M3;
  wire [2:0]  HSIZE1M3;
  wire [2:0]  HBURST1M3;
  wire [3:0]  HPROT1M3;
  wire [31:0] HWDATA1M3;
  wire        HBUSREQ1M3;
  wire        HLOCK1M3;
  wire        HGRANT1M3;

//------------------------------------------------------------------------------
// Signal declarations: APB
//------------------------------------------------------------------------------
// APB backbone
  wire        PENABLE;
  wire [7:0]  PADDR ;
  wire        PWRITE;
  wire [31:0] PWDATA;
  wire [31:0] PRDATA;

// Slave-select lines
  wire        PSELS0;
  wire        PSELS1;
  wire        PSELS2;
  wire        PSELS3;
  wire        PSELS4;
  wire        PSELS5;
  wire        PSELS6;
  wire        PSELS7;
  wire        PSELS8;
  wire        PSELS9;
  wire        PSELS10;
  wire        PSELS11;
  wire        PSELS12;
  wire        PSELS13;
  wire        PSELS14;
  wire        PSELS15;

// Slave read-data outputs
  wire [31:0] PRDATAS0;
  wire [31:0] PRDATAS1;
  wire [31:0] PRDATAS2;
  wire [31:0] PRDATAS3;
  wire [31:0] PRDATAS4;
  wire [31:0] PRDATAS5;
  wire [31:0] PRDATAS6;
  wire [31:0] PRDATAS7;
  wire [31:0] PRDATAS8;
  wire [31:0] PRDATAS9;
  wire [31:0] PRDATAS10;
  wire [31:0] PRDATAS11;
  wire [31:0] PRDATAS12;
  wire [31:0] PRDATAS13;
  wire [31:0] PRDATAS14;
  wire [31:0] PRDATAS15;

//------------------------------------------------------------------------------
// Signal declarations: System specific
//------------------------------------------------------------------------------
// Sync. Internal SRAM interface
  wire 		  ISMCcsb;
  wire [12:0] ISMCaddr;
  wire [3:0]  ISMCwrb;
  wire 		  ISMCoeb;
  wire [31:0] ISMCdout;
  wire [31:0] ISMCdin;

  wire [3:0]  ESmcCs;
  wire [19:0] ESmcAddr;
  wire [1:0]  ESmcWBe;
  wire [1:0]  ESmcBe;
  wire        ESmcDOe;
  wire [15:0] ESmcDato;

// UART
  wire        nUARTCTS;
  wire        nUARTDCD;
  wire        nUARTDSR;
  wire        nUARTRI;
  wire        UARTTXDMACLR;
  wire        UARTRXDMACLR;
              
  wire        UART_RXD;
  wire        IrDA_RXD;
  
  wire        UARTTX_TOTInt;
  wire        UARTRX_NONInt;

// I2C
  wire  [1:0] I2CInt;
  wire  [1:0] I2CAAS;

//Timer & PWM
  wire  [7:0] TimerOut;
  wire  [7:0] PWM0Out;
  wire  [7:0] PWM1Out;
  wire  [7:0] PWM2Out;
  wire  [7:0] PWM3Out;
  wire  [7:0] TimerTOFInt;//Overflow Interrupt 
  wire  [7:0] TimerTMCInt;//Match Interrupt

  wire  [7:0] TCLK;
  wire  [7:0] TCAP;

// Watchdog interrupt line
  wire        WDOGINT;
  wire        WDOGRESn;
  wire        WDOGRES;
        
//Gpio  
  wire  [7:0] GpioIn0;
  wire  [7:0] GpioIn1;
  wire  [7:0] GpioIn2;
  wire  [7:0] GpioIn3;
  wire  [7:0] GpioEn0;
  wire  [7:0] GpioEn1;
  wire  [7:0] GpioEn2;
  wire  [7:0] GpioEn3;
  wire  [7:0] GpioOut0;
  wire  [7:0] GpioOut1;
  wire  [7:0] GpioOut2;
  wire  [7:0] GpioOut3;

// VIC
  wire [31:0] IntSrc;
  wire [7:0]  EIntLvl;
  wire [7:0]  EIntPol;
  wire [7:0]  EIntMsk;
  wire [7:0]  EInt;

// ADC
  wire        ADCInt;
  wire        DiffModEn;

//Power& Clock Mangement
  wire        SysClkOut;
  wire        UartClkOut;
  wire        UartIntSel;
  wire        AdcClkOut;
  wire        PWMOutEn;
  wire        GIEOutEn;

  wire        nFIQ;
  wire        nIRQ;
  wire        ARMnFIQ;
  wire        ARMnIRQ;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// Drive the AHB clock with the Internal clock input[APB_PowerManager].
  assign HCLK = SysClkOut;

// Common reset controller
  RstCtl uResetCntl (
	.HCLK       	(HCLK),
	.TestMode   	(TEST_MODE),
	.nPOReset   	(ARM_RESETi),
	.WDOGRES    	(WDOGRES),
	.HRESETn    	(HRESETn),
	.WDOGRESn   	(WDOGRESn)
   );

//------------------------------------------------------------------------------
// AHB System 
//------------------------------------------------------------------------------
/* Removed for FPGA test
  A7TDMI uA7TDMI (
	.HCLK       	(HCLK),
	.HRESETn    	(HRESETn),
	
	.HBUSREQM   	(HBUSREQ1M1),
	.HGRANTM    	(HGRANT1M1),
	.HADDRM     	(HADDR1M1),
	.HTRANSM    	(HTRANS1M1),
	.HWRITEM    	(HWRITE1M1),
	.HSIZEM     	(HSIZE1M1),
	.HBURSTM    	(HBURST1M1),
	.HPROTM     	(HPROT1M1),
	.HWDATAM    	(HWDATA1M1),
	.HLOCKM     	(HLOCK1M1),
	
	.HRDATAM    	(HRDATA1),
	.HREADYM    	(HREADY1),
	.HRESPM     	(HRESP1),
	
	.HSELS      	(TieOffLo1),
	.HTRANS1S   	(TieOffLo1),
	.HWRITES    	(TieOffLo1),
	.HWDATAS    	(TieOffLo32),
	.HREADYS    	(TieOffLo1),
	.HRDATAS    	(),
	.HREADYOUTS 	(),
	.HRESPS     	(),
	
	.ARMNFIQ    	(ARMnFIQ),
	.ARMNIRQ    	(ARMnIRQ),
	
	.COMMRX     	(),
	.COMMTX     	(),
	
	.nTRST      	(ARM_TRST),
	.TCK        	(ARM_TCK),
	.TDI        	(ARM_TDI),
	.TMS        	(ARM_TMS),
	.TDO        	(ARM_TDO),
	.nTDOEN     	(nTDOEN)
    );
*/

wire aa = 1'b1;
wire [1:0] bb = 2'd0;

cpu uCPU
  (
    .rstcore  (HRESETn),
    .rstcache (HRESETn),
    .clk      (HCLK), 
    .bigend   (1'b0),
    .hivecs   (1'b0),

    .nfiq     (ARMnFIQ), 
    .nirq     (ARMnIRQ), 

    .hbusreq  (HBUSREQ1M1), 
    .hgrant   (HGRANT1M1),	

    .haddr    (HADDR1M1), 
    .htrans   (HTRANS1M1), 
    .hwrite   (HWRITE1M1), 
    .hsize	  (HSIZE1M1),    
    .hburst   (HBURST1M1),
    .hlock    (HLOCK1M1), 
    .hprot    (HPROT1M1),

    .hready   (HREADY1), 

    .hresp    (HRESP1), 

    .hwdata   (HWDATA1M1), 
    .hrdata   (HRDATA1)
  );

  assign  ARMnFIQ = GIEOutEn ? nFIQ : TieOffHi1;
  assign  ARMnIRQ = GIEOutEn ? nIRQ : TieOffHi1;

//------------------------------------------------------------------------------
// AHB Infrastructure
//------------------------------------------------------------------------------
  Arbiter3 uArbiterBus1 (
	.HCLK        	(HCLK),
	.HRESETn     	(HRESETn),
	             	
	.HTRANS      	(HTRANS1),
	.HBURST      	(HBURST1),
	.HREADY      	(HREADY1),
	.HRESP       	(HRESP1),
	             	
	.HBUSREQM3   	(HBUSREQ1M3),
	.HBUSREQM2   	(HBUSREQ1M2),
	.HBUSREQM1   	(HBUSREQ1M1),
	.HBUSREQM0   	(HBUSREQ1M0),
	             	
	.HLOCKM3     	(HLOCK1M3),
	.HLOCKM2     	(HLOCK1M2),
	.HLOCKM1     	(HLOCK1M1),
	.HLOCKM0     	(HLOCK1M0),
	             	
	.HSPLIT      	(HSPLIT1[3:0]),
	             	
	.HGRANTM3    	(HGRANT1M3),
	.HGRANTM2    	(HGRANT1M2),
	.HGRANTM1    	(HGRANT1M1),
	.HGRANTM0    	(HGRANT1M0),
	             	
	.HMASTER     	(HMASTER1),
	.HMASTERD    	(HMASTERD1),
	.HMASTLOCK   	(HMASTLOCK1)
    );

  assign HBUSREQ1M0 = TieOffLo1;
  assign HBUSREQ1M2 = TieOffLo1;
  assign HBUSREQ1M3 = TieOffLo1;
  
  assign HLOCK1M0   = TieOffLo1;
  assign HLOCK1M2   = TieOffLo1;
  assign HLOCK1M3   = TieOffLo1;
  
  assign HSPLIT1    = TieOffLo16;

  Decoder uDecoder (
 	.HADDR       	(HADDR1[31:0]),
 	.BootMode    	(BOOT_MODE),
 	.HSELS0      	(HSELS0),
 	.HSELS1      	(HSELS1),
 	.HSELS2      	(HSELS2),
 	.HSELS3      	(HSELS3),
 	             	
 	.HSELS1_0    	(HSELS1_0),
 	.HSELS1_1    	(HSELS1_1),
 	.HSELS1_2    	(HSELS1_2),
 	.HSELS1_3    	(HSELS1_3),
 	.HSELSR 	 	(HSEL1DefSlv)
    );

  DefaultSlave uDefaultSlave1 (
	.HCLK        	(HCLK),
	.HRESETn     	(HRESETn),
	             	
	.HTRANS      	(HTRANS1),
	.HSEL        	(HSEL1DefSlv),
	.HREADY      	(HREADY1),
	             	
	.HREADYOUT   	(HREADY1DefSlv),
	.HRESP       	(HRESP1DefSlv)
    );

  MuxM2S uMuxM2S (
	.HMASTER 		(HMASTER1),
	.HMASTERD		(HMASTERD1),
	         		
	.HADDRM1 		(HADDR1M1),
	.HTRANSM1		(HTRANS1M1),
	.HWRITEM1		(HWRITE1M1),
	.HSIZEM1 		(HSIZE1M1),
	.HBURSTM1		(HBURST1M1),
	.HPROTM1 		(HPROT1M1),
	.HWDATAM1		(HWDATA1M1),
	         		
	.HADDRM2 		(HADDR1M2),
	.HTRANSM2		(HTRANS1M2),
	.HWRITEM2		(HWRITE1M2),
	.HSIZEM2 		(HSIZE1M2),
	.HBURSTM2		(HBURST1M2),
	.HPROTM2 		(HPROT1M2),
	.HWDATAM2		(HWDATA1M2),
	         		
	.HADDRM3 		(HADDR1M3),
	.HTRANSM3		(HTRANS1M3),
	.HWRITEM3		(HWRITE1M3),
	.HSIZEM3 		(HSIZE1M3),
	.HBURSTM3		(HBURST1M3),
	.HPROTM3 		(HPROT1M3),
	.HWDATAM3		(HWDATA1M3),
	         		
	.HADDR   		(HADDR1),
	.HTRANS  		(HTRANS1),
	.HWRITE  		(HWRITE1),
	.HSIZE   		(HSIZE1),
	.HBURST  		(HBURST1),
	.HPROT   		(HPROT1),
	.HWDATA  		(HWDATA1)
    );
  
  assign HADDR1M2  = TieOffLo32;
  assign HTRANS1M2 = TieOffLo2;
  assign HWRITE1M2 = TieOffLo1;
  assign HSIZE1M2  = TieOffLo3;
  assign HBURST1M2 = TieOffLo3;
  assign HPROT1M2  = TieOffLo4;
  assign HWDATA1M2 = TieOffLo32;

  assign HADDR1M3  = TieOffLo32;
  assign HTRANS1M3 = TieOffLo2;
  assign HWRITE1M3 = TieOffLo1;
  assign HSIZE1M3  = TieOffLo3;
  assign HBURST1M3 = TieOffLo3;
  assign HPROT1M3  = TieOffLo4;
  assign HWDATA1M3 = TieOffLo32;

//------------------------------------------------------------------------------
// AHB Internal FMC
//------------------------------------------------------------------------------
wire FmTtm2;


/* Removed for FPGA test

 ifmc_top uAHB_IFMC (
	.clk         	(HCLK),
	.apb_clk     	(HCLK),
	.rstb        	(HRESETn),

	.tmode    		(TEST_MODE),
	.scl      		(FlashSCLi),
	.sda_in   		(FlashSDAi),
	.sda_out  		(FlashSDAo),
	.sda_oeb  		(FlashSDAe),
	.tool_mode		(ToolMode),
	  	             	
	.ahb_sel     	(HSELS0),
	.ahb_readyin 	(HREADY1),
	.ahb_trans   	(HTRANS1),
	.ahb_addr    	(HADDR1[17:2]),
	.ahb_write   	(HWRITE1),
	.ahb_size    	(HSIZE1),
	             	
	.ahb_rdata   	(HRDATA1S0),
	.ahb_ready   	(HREADY1S0),
	.ahb_resp    	(HRESP1S0),
	             	
	.apb_enable  	(PENABLE),
	.apb_sel     	(PSELS0),
	.apb_addr    	(PADDR[5:2]),
	.apb_write   	(PWRITE),
	.apb_wdata   	(PWDATA),
	.apb_rdata   	(PRDATAS0),
	
	// Flash memory test pins
	.fmt_en      	(FmTen),
	.fmt_tmr     	(FmTtmr),
	.fmt_vpp     	(FmTvpp),
	.fmt_tm      	({FmTtm2, FmTtm}),
	.fmt_mas1    	(FmTmas1),
	.fmt_ifren   	(FmTifren),
	.fmt_xe      	(FmTxe),
	.fmt_ye      	(FmTye),
	.fmt_erase   	(FmTerase),

   	.fmt_se     	(FmTse),
   	.fmt_nvstr  	(FmTnvstr),
   	.fmt_prog   	(FmTprog),
   	.fmt_xadr   	(FmTxadr),
   	.fmt_yadr   	(FmTyadr),
   	.fmt_din    	(FmTdin),
   	.fmt_dout   	(FmTdout),
   	.fmt_oeb		(FmToeb)
     );
*/


assign	FlashSDAo = 1'b0;
assign	ToolMode = 1'b0;
assign  FmTdout = 32'd0;
assign  FmToeb  = 1'b0;
assign	HRDATA1S0 = 32'd0;
assign 	HREADY1S0 = 1'b1;
assign  HRESP1S0 = 2'd0;
    

  assign FlashSCLi = GpioIn3[6];
  assign FlashSDAi = GpioIn3[7];

//------------------------------------------------------------------------------
// AHB External SMC
//------------------------------------------------------------------------------
   mem_ctrl  uAHB_ESMC ( 
	.clk         	(HCLK),
	.resetx      	(HRESETn),
	             	
	.apb_enable  	(PENABLE),
	.apb_sel     	(PSELS1),
	.apb_addr    	(PADDR[3:2]),
	.apb_write   	(PWRITE),
	.apb_wdata   	(PWDATA),
	.apb_rdata   	(PRDATAS1),	
	             	
	.ahb_sel0    	(HSELS1_0),
	.ahb_sel1    	(HSELS1_1),
	.ahb_sel2    	(HSELS1_2),
	.ahb_sel3    	(HSELS1_3),
	.ahb_addr    	(HADDR1[19:0]),
	.ahb_htrans  	(HTRANS1),
	.ahb_write   	(HWRITE1),
	.ahb_size    	(HSIZE1),
	.ahb_wdata   	(HWDATA1),
	.ahb_rdata   	(HRDATA1S1),
	.ahb_readyin 	(HREADY1),
	.ahb_ready   	(HREADY1S1),
	.ahb_resp    	(HRESP1S1),
	             	
	.ext_csb     	(ESmcCs),
	.ext_adr     	(ESmcAddr), 
	.ext_wbeb    	(ESmcWBe),
	.ext_beb     	(ESmcBe), 
	.ext_web     	(ARM_WE),
	.ext_oeb     	(ARM_OE), 
	.ext_wdata   	(ESmcDato),
	.ext_rdata   	(ARM_DATi),
	.ext_bidoe	 	(ESmcDOe)
   );

  assign V5_CS         = ESmcCs[3]; 
  assign ARM_CS        = ESmcCs[0];
  assign ARM_DOEn      = PWMOutEn ? 1'b0 : ~ESmcDOe;
  assign ARM_ADR[16]   = ESmcAddr[16];
  assign ARM_ADR[15:8] = PWMOutEn ? PWM1Out : ESmcAddr[15:8];
  assign ARM_ADR[7:0]  = ESmcAddr[7:0];
  assign ARM_DATo      = PWMOutEn ? {PWM3Out, PWM2Out} : ESmcDato;

//------------------------------------------------------------------------------
// AHB Internal SMC
//------------------------------------------------------------------------------
  ismc_ahb  uAHB_ISMC (
	.clk         	(HCLK),
	.rstb        	(HRESETn),
	             	
	.ahb_sel     	(HSELS2),
	.ahb_addr    	(HADDR1[14:0]),
	.ahb_htrans  	(HTRANS1),
	.ahb_write   	(HWRITE1),
	.ahb_size    	(HSIZE1),
	.ahb_wdata   	(HWDATA1),
	.ahb_rdata   	(HRDATA1S2),
	.ahb_readyin 	(HREADY1),
	.ahb_ready   	(HREADY1S2),
	.ahb_resp    	(HRESP1S2),
	             	
	.sram_csb    	(ISMCcsb),
	.sram_addr   	(ISMCaddr),
	.sram_wrb    	(ISMCwrb),
	.sram_oeb    	(ISMCoeb),
	.sram_dout   	(ISMCdout),
	.sram_din    	(ISMCdin)
  );


/* modeling modified for FPGA test */
/* 4k syn SRAM */

  Bisted_sram6144x32x8  uAHB_ISRAM24K (
    //.BistMode 		(BistMode),
    .BistMode 		(1'b0),
 	.BistFail 		(BistFail), 
 	.Finish   		(BistDone), 
 	.ErrMap   		(),
 
	.CLK         	(HCLK),
	.Q           	(ISMCdout),
	.CEN         	(ISMCcsb),
	.WEN         	(ISMCwrb),
	.A           	(ISMCaddr),
	.D           	(ISMCdin),
	.OEN         	(ISMCoeb)
  );



  MuxS2M uMuxS2M (
	.HCLK         	(HCLK),
	.HRESETn      	(HRESETn),
	              	
	.HSELS0       	(HSELS0),
	.HSELS1       	(HSELS1),
	.HSELS2       	(HSELS2),
	.HSELS3       	(HSELS3),
	.HSELS4       	(HSELS4),
	.HSELS5       	(HSELS5),
	.HSELS6       	(HSELS6),
	.HSELS7       	(HSELS7),
	.HSELDefault  	(HSEL1DefSlv),
	              	
	.HRDATAS0     	(HRDATA1S0),
	.HREADYS0     	(HREADY1S0),
	.HRESPS0      	(HRESP1S0),
	              	
	.HRDATAS1     	(HRDATA1S1),
	.HREADYS1     	(HREADY1S1),
	.HRESPS1      	(HRESP1S1),
	              	
	.HRDATAS2     	(HRDATA1S2),
	.HREADYS2     	(HREADY1S2),
	.HRESPS2      	(HRESP1S2),
	              	
	.HRDATAS3     	(HRDATA1S3),
	.HREADYS3     	(HREADY1S3),
	.HRESPS3      	(HRESP1S3),
	              	
	.HRDATAS4     	(HRDATA1S4),
	.HREADYS4     	(HREADY1S4),
	.HRESPS4      	(HRESP1S4),
	              	
	.HRDATAS5     	(HRDATA1S5),
	.HREADYS5     	(HREADY1S5),
	.HRESPS5      	(HRESP1S5),
	              	
	.HRDATAS6     	(HRDATA1S6),
	.HREADYS6     	(HREADY1S6),
	.HRESPS6      	(HRESP1S6),
	              	
	.HRDATAS7     	(HRDATA1S7),
	.HREADYS7     	(HREADY1S7),
	.HRESPS7      	(HRESP1S7),
	              	
	.HREADYDefault	(HREADY1DefSlv),
	.HRESPDefault 	(HRESP1DefSlv),
	              	
	.HRDATA       	(HRDATA1),
	.HREADY       	(HREADY1),
	.HRESP        	(HRESP1)
    );

  assign HSELS4 = TieOffLo1;
  assign HSELS5 = TieOffLo1;
  assign HSELS6 = TieOffLo1;
  assign HSELS7 = TieOffLo1;

  assign HRDATA1S4 = TieOffLo32;
  assign HRDATA1S5 = TieOffLo32;
  assign HRDATA1S6 = TieOffLo32;
  assign HRDATA1S7 = TieOffLo32;

  assign HREADY1S4 = TieOffHi1;
  assign HREADY1S5 = TieOffHi1;
  assign HREADY1S6 = TieOffHi1;
  assign HREADY1S7 = TieOffHi1;

  assign HRESP1S4 = TieOffLo2;
  assign HRESP1S5 = TieOffLo2;
  assign HRESP1S6 = TieOffLo2;
  assign HRESP1S7 = TieOffLo2;

  APBif uAPBif (
	.HCLK     		(HCLK),
	.HRESETn  		(HRESETn),
	          		
	.HADDR    		(HADDR1[11:0]),
	.HTRANS   		(HTRANS1),
	.HWRITE   		(HWRITE1),
	.HWDATA   		(HWDATA1),
	.HSEL     		(HSELS3),
	.HREADY   		(HREADY1),
	          		
	.HRDATA   		(HRDATA1S3),
	.HREADYOUT		(HREADY1S3),
	.HRESP    		(HRESP1S3),
	          		
	.PRDATA   		(PRDATA),
	.PWDATA   		(PWDATA),
	.PADDR    		(PADDR),
	.PWRITE   		(PWRITE),
	.PENABLE  		(PENABLE),

	.PSELS0     	(PSELS0),        
	.PSELS1     	(PSELS1),
	.PSELS2     	(PSELS2),
	.PSELS3     	(PSELS3),
	.PSELS4     	(PSELS4),    
	.PSELS5     	(PSELS5),
	.PSELS6     	(PSELS6),
	.PSELS7     	(PSELS7),
	.PSELS8     	(PSELS8),
	.PSELS9     	(PSELS9),
	.PSELS10    	(PSELS10),
	.PSELS11    	(PSELS11),
	.PSELS12    	(PSELS12),
	.PSELS13    	(PSELS13),
	.PSELS14    	(PSELS14),
	.PSELS15    	(PSELS15)
    );

//------------------------------------------------------------------------------
// APB domain 
//------------------------------------------------------------------------------
  MuxP2B uMuxP2B (
	.PSELS0       	(PSELS0),    // Select lines from APB Bridge
	.PSELS1       	(PSELS1),
	.PSELS2       	(PSELS2),
	.PSELS3       	(PSELS3),
	.PSELS4       	(PSELS4),
	.PSELS5       	(PSELS5),
	.PSELS6       	(PSELS6),
	.PSELS7       	(PSELS7),
	.PSELS8       	(PSELS8),
	.PSELS9       	(PSELS9),
	.PSELS10      	(PSELS10),
	.PSELS11      	(PSELS11),
	.PSELS12      	(PSELS12),
	.PSELS13      	(PSELS13),
	.PSELS14      	(PSELS14),
	.PSELS15      	(PSELS15),
	              	
	.PRDATAS0     	(PRDATAS0),  // APB Slave read-data
	.PRDATAS1     	(PRDATAS1),
	.PRDATAS2     	(PRDATAS2),
	.PRDATAS3     	(PRDATAS3),
	.PRDATAS4     	(PRDATAS4),
	.PRDATAS5     	(PRDATAS5),
	.PRDATAS6     	(PRDATAS6),
	.PRDATAS7     	(PRDATAS7),
	.PRDATAS8     	(PRDATAS8),
	.PRDATAS9     	(PRDATAS9),
	.PRDATAS10    	(PRDATAS10),
	.PRDATAS11    	(PRDATAS11),
	.PRDATAS12    	(PRDATAS12),
	.PRDATAS13    	(PRDATAS13),
	.PRDATAS14    	(PRDATAS14),
	.PRDATAS15    	(PRDATAS15),
	              	
	.PRDATA       	(PRDATA)     // To APB Bridge
    );

  assign PRDATAS14 = TieOffLo32;
  assign PRDATAS15 = TieOffLo32;

//------------------------------------------------------------------------------
// APB UART
//------------------------------------------------------------------------------
  Uart uAPB_UART(
	.PCLK         	(HCLK),
	.UARTCLK      	(UartClkOut),
	.PRESETn      	(HRESETn),
	.nUARTRST     	(HRESETn),
	.PSEL         	(PSELS2),
	.PENABLE      	(PENABLE),
	.PWRITE       	(PWRITE),
	.PADDR        	(PADDR[7:2]),
	.PWDATA       	(PWDATA[15:0]),
	.PRDATA       	(PRDATAS2),
	              	
	.nUARTCTS     	(nUARTCTS),
	.nUARTDCD     	(nUARTDCD),
	.nUARTDSR     	(nUARTDSR),
	.nUARTRI      	(nUARTRI),
	.nUARTOut2    	(),
	.nUARTOut1    	(),
	.nUARTRTS     	(),
	.nUARTDTR     	(),
	.UARTTXDMACLR 	(UARTTXDMACLR),
	.UARTRXDMACLR 	(UARTRXDMACLR),
	.UARTTXDMASREQ	(),
	.UARTTXDMABREQ	(),
	.UARTRXDMASREQ	(),
	.UARTRXDMABREQ	(),
	              	
	.UARTRXD      	(UART_RXD),
	.UARTTXD      	(UART_TXD),
	.SIRIN        	(IrDA_RXD),
	.nSIROUT      	(IrDA_TXD),
	              	
	.UARTMSINTR   	(),
	.UARTRXINTR   	(UARTRXINT),
	.UARTTXINTR   	(UARTTXINT),
	.UARTRTINTR   	(),
	.UARTEINTR    	(),
	.UARTINTR     	(UARTINT)
    );

  assign nUARTCTS = TieOffLo1;
  assign nUARTDCD = TieOffLo1;
  assign nUARTDSR = TieOffLo1;
  assign nUARTRI  = TieOffLo1;
  assign UARTTXDMACLR = TieOffLo1;
  assign UARTRXDMACLR = TieOffLo1;

  assign UART_RXD = GpioIn3[7];
  assign IrDA_RXD = GpioIn3[5];

  assign UARTTX_TOTInt = ~UartIntSel ? UARTTXINT : UARTINT;
  assign UARTRX_NONInt = ~UartIntSel ? UARTRXINT : TieOffLo1;

//------------------------------------------------------------------------------
// APB I2C
//------------------------------------------------------------------------------
  I2C uAPB_I2C(
	.Clk          	(HCLK), 
	.nRst         	(HRESETn),
	.PSEL         	(PSELS3), 
	.PENABLE      	(PENABLE), 
	.PADDR        	(PADDR[7:2]), 
	.PWRITE       	(PWRITE), 
	.PWDATA       	(PWDATA[15:0]), 
	.PRDATA       	(PRDATAS3),
	              	
	.I2cInt       	(I2CInt),
	.I2cAAS			(I2CAAS),
	              	
	.ISCL         	(I2CSCLi), 
	.ISDA         	(I2CSDAi), 
	.OSCL         	(I2CSCLo), 
	.OSDA         	(I2CSDAo)
  );

//------------------------------------------------------------------------------
// APB Timer PWM
//------------------------------------------------------------------------------
  TimerPWM uAPB_TimerPWM(
	.PCLK         	(HCLK), 
	.PRESETn      	(HRESETn), 
	.PENABLE      	(PENABLE), 
	.PSELTimer    	(PSELS4), 
	.PSELPWM0     	(PSELS5), 
	.PSELPWM1     	(PSELS6), 
	.PSELPWM2     	(PSELS7), 
	.PSELPWM3     	(PSELS8), 
	.PWRITE       	(PWRITE), 
	.PADDR        	(PADDR[7:2]),
	.PWDATA       	(PWDATA[15:0] ),
	.PRDATATimer  	(PRDATAS4),
	.PRDATAPWM0   	(PRDATAS5),
	.PRDATAPWM1   	(PRDATAS6),
	.PRDATAPWM2   	(PRDATAS7),
	.PRDATAPWM3   	(PRDATAS8),
	              	
	.TCLK         	(TCLK),
	.TCAP         	(TCAP),
	.TimerOut     	(TimerOut),
	.TimerTOFInt  	(TimerTOFInt),
	.TimerTMCInt  	(TimerTMCInt),   
	.PWM0Out      	(PWM0Out),
	.PWM1Out      	(PWM1Out),
	.PWM2Out      	(PWM2Out),
	.PWM3Out      	(PWM3Out)
  );
  
  assign TCLK = GpioIn3;
  assign TCAP = GpioIn1;

//------------------------------------------------------------------------------
// APB WatchDog Timer
//------------------------------------------------------------------------------
  WatchDog uAPB_WDT (
	.PCLK         	(HCLK), 
	.PRESETn      	(HRESETn), 
	.PENABLE      	(PENABLE), 
	.PSEL         	(PSELS9), 
	.PWRITE       	(PWRITE), 
	.PADDR        	(PADDR[7:2]), 
	.PWDATA       	(PWDATA),
	.PRDATA       	(PRDATAS9),
	              	
	.WDOGRESn     	(WDOGRESn),
	.WDOGINT      	(WDOGINT),
	.WDOGRES      	(WDOGRES)
  );

//------------------------------------------------------------------------------
// APB GPIO
//------------------------------------------------------------------------------
  Gpio uAPB_Gpio (
	.PCLK         	(HCLK), 
	.PRESETn      	(HRESETn), 
	.PENABLE      	(PENABLE), 
	.PSEL         	(PSELS10), 
	.PWRITE       	(PWRITE), 
	.PADDR        	(PADDR[7:2]), 
	.PWDATA       	(PWDATA),
	.PRDATA       	(PRDATAS10),

    .BistMode 		(BistMode),
 	.BistFail 		(BistFail), 
 	.BistDone   	(BistDone), 

	.ToolMode		(ToolMode),
	 
	.Tout         	(TimerOut),
	.MEM_ADR      	(ESmcAddr[19:17]),
	.MEM_BE       	(ESmcBe),
	.POUT         	(PWM0Out),
	.UART_TXD     	(UART_TXD),
	.IrDA_TXD     	(IrDA_TXD),
	.MEM_WBE      	(ESmcWBe),
	.MEM_CS       	(ESmcCs[2:1]),
	              	
	.GpioIn0      	(GpioIn0),
	.GpioIn1      	(GpioIn1),
	.GpioIn2      	(GpioIn2),
	.GpioIn3      	(GpioIn3),
	              	
	.GpioEn0      	(GpioEn0), 
	.GpioEn1      	(GpioEn1), 
	.GpioEn2      	(GpioEn2), 
	.GpioEn3      	(GpioEn3), 
	              	
	.GpioOut0     	(GpioOut0),
	.GpioOut1     	(GpioOut1),
	.GpioOut2     	(GpioOut2),
	.GpioOut3     	(GpioOut3)
  );

//------------------------------------------------------------------------------
// APB Vectored Interrupt Controller
//------------------------------------------------------------------------------
  APB_vic uAPB_VIC(
	.PCLK         	(HCLK), 
	.PRESETn      	(HRESETn), 
	.PENABLE      	(PENABLE), 
	.PSEL         	(PSELS11),
	.PWRITE       	(PWRITE), 
	.PADDR        	(PADDR[6:2]), 
	.PWDATA       	(PWDATA),
	.PRDATA       	(PRDATAS11),
	              	
	.INTERRUPT_SRC	(IntSrc),
	              	
	.nFIQ         	(nFIQ),
	.nIRQ         	(nIRQ),
	              	
	.LEVEL_PM     	(EIntLvl),
	.POLARITY_PM  	(EIntPol),
	.INTMSK_PM    	(EIntMsk)
   );
  
  assign IntSrc = {TimerTMCInt[7],
                   TimerTOFInt[7],
                   TimerTMCInt[6],
                   TimerTOFInt[6],
                   TimerTMCInt[5],
                   TimerTOFInt[5],
                   TimerTMCInt[4],
                   TimerTOFInt[4],
                   TimerTMCInt[3],
                   TimerTOFInt[3],
                   UARTTX_TOTInt,
                   UARTRX_NONInt,
                   ADCInt,
                   WDOGINT,
                   I2CAAS[1],
                   I2CInt[1],
                   EInt[7:4], 
                   TimerTMCInt[2],
                   TimerTOFInt[2],
                   TimerTMCInt[1],
                   TimerTOFInt[1],
                   TimerTMCInt[0],
                   TimerTOFInt[0],
                   I2CAAS[0],
                   I2CInt[0],
                   EInt[3:0]};

//------------------------------------------------------------------------------
// APB A/D - Converter Control
//------------------------------------------------------------------------------
  top_adc uAPB_ADC_Ctrl(
	.PCLK         	(HCLK), 
	.PRESETn      	(HRESETn), 
	.PENABLE      	(PENABLE), 
	.PSEL         	(PSELS12), 
	.PWRITE       	(PWRITE), 
	.PADDR        	(PADDR[3:2]),
	.PWDATA       	(PWDATA[15:0]),
	.PRDATA       	(PRDATAS12),
	              	
	.INT_ADC      	(ADCInt),
	.CLK_ADCCLK   	(AdcClkOut),
	              	
/*	              	
	.AVDD         	(),
	.DVDD         	(),
	.AVSS         	(),
	.DVSS         	(),
*/
	              	
	.CH0          	(ADC_IN[0]),
	.CH1          	(ADC_IN[1]),
	.CH2          	(ADC_IN[2]),
	.CH3          	(ADC_IN[3]),
	.CH4          	(ADC_IN[4]),
	.CH5          	(ADC_IN[5]),
	.CH6          	(ADC_IN[6]),
	.CH7          	(ADC_IN[7]),
	.DIFF         	(DiffModEn)
  );

  assign DiffModEn = TieOffLo1;

//------------------------------------------------------------------------------
// APB Power Management
//------------------------------------------------------------------------------
  ClkCtl uAPB_PowerManager (
	.OSC_CLK      	(ARM_OSCi),
	.TestMode      	(TEST_MODE),
	              	
	.EINT         	(EInt),
	.PCLK         	(HCLK),
	.PRESETn      	(HRESETn),
	.PENABLE      	(PENABLE),
	.PSEL         	(PSELS13),
	.PWRITE       	(PWRITE),
	.PADDR        	(PADDR[7:2]),
	.PRDATA       	(PRDATAS13),
	.PWDATA       	(PWDATA),
	              	
	.EIntLvl      	(EIntLvl),
	.EIntPol      	(EIntPol),
	.EIntMsk      	(EIntMsk),
	              	
	.SysClkOut    	(SysClkOut),
	.UartClkOut   	(UartClkOut),
	.GIEOut       	(GIEOutEn),
	.UartIntSel   	(UartIntSel),
	.AdcClkOut    	(AdcClkOut),
	.PWMOutEn	  	 (PWMOutEn)
    );

   assign EInt = GpioIn0;

endmodule
