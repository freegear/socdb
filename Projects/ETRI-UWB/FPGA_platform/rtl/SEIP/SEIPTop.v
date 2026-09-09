
`timescale 1ns/1ns

module SEIPTop (
				MCK, XRST,
				TE, TI0, TI1, TI2, TI3, TI4, TO0, TO1, TO2, TO3, TO4,

				PSEL, 
    			PENABLE, 
    			PADDR, 
    			PWRITE, 
    			PWDATA, 
				PRDATA,
				PREADY,
				
				EEMA_M, EEMDI_M, EEMDO_M, XEEMWE_M,

				RxDmaRequest, TxDmaRequest, SEIPInt,

				EXMBIH, WEMDI, WEMDO, WEMA, XWEMOC, XWEMWE, 
    			SDI1, SDI2, SCKO, ADMCK, LRCKO,
    			SD2O, SD1O, MLRCK, MSCK

);

`include "SEIPPara.v"

input			MCK, XRST;

input  			TI4, TE, TI0, TI3, TI2, TI1;
output 			TO4, TO0, TO1, TO3, TO2;

input         	PENABLE;
input  	       	PSEL;
input         	PWRITE;
input  	[13:1] 	PADDR;
input  	[31:0] 	PWDATA;
output 	[31:0] 	PRDATA;
output			PREADY;

input   [31:0]	EEMDO_M;
output  [31:0]	EEMDI_M;
output  [15:0]	EEMA_M;
output 	[ 3:0]	XEEMWE_M;

output			RxDmaRequest;
output			TxDmaRequest;
output			SEIPInt;

input   		SDI1, SDI2;
output  		SCKO, ADMCK, LRCKO, SD2O, SD1O, MLRCK, MSCK;

input   [7:0]	WEMDO;
output 	[7:0]	WEMDI;
output 	[23:0]	WEMA;
output 			EXMBIH, XWEMOC, XWEMWE;
//------------------------------------------------------------------------
wire			ADMCKInt;

wire  [10:0]    PIA;
wire  [15:0]    PIDI;
wire     		XPOE, XPWE; 
wire  [31:0]	RXD;
wire  [15:0]	WIMD;
wire  [23:0]	TIMO;
wire  [15:0]	EIMO;
wire  [7:0]		TROMO;
wire  [15:0]	PIDO;
wire  [15:0]	WIMDI;
wire  [15:0]	EEMA;
wire  [15:0]	EEMDI;
reg	  [15:0]	EEMDO;
wire			XEEMWE;
wire  [31:0]	TXD;
wire  [8:0]		WIMA;
wire  [8:0]		TIMA;
wire  [23:0]	TIMI;
wire  [8:0]		TROMA;
wire  [15:0]	EIMDI;
wire  [7:0]		EIMA;

// Register Interface
wire           RxFIFOWrite;
wire  [31:0]   RxFIFOWrData;
wire           RxFIFOReadCpu;
wire  [31:0]   RxFIFORdDataCpu;
wire           RxFIFOFlush;
wire[RXAW-1:0] RxFIFODataCnt;
wire           RxFIFOEmpty;
wire           RxFIFOFull;

wire           RxDmaEn;
wire  [RXAW-1:0]   RxDmaSize;
wire           RxDmaReset;

wire           TxFIFORead;
wire  [31:0]   TxFIFORdData;
wire           TxFIFOWriteCpu;
wire  [31:0]   TxFIFOWrDataCpu;
wire           TxFIFOFlush;
wire[RXAW-1:0] TxFIFODataCnt;
wire           TxFIFOEmpty;
wire           TxFIFOFull;

wire           TxDmaEn;
wire  [TXAW-1:0]   TxDmaSize;
wire           TxDmaReset;
//------------------------------------------------------------------------
// Internal SRAM Mux.
assign EEMA_M   = EEMA[15:1];
									//   Low		High	 Disable
assign XEEMWE_M = ~XEEMWE ? ~EEMA[0] ? 4'b1100 : 4'b0011 : 4'b1111;

assign EEMDI_M  = (EEMA[0]) ? {EEMDI, 16'b0} : {16'b0, EEMDI};

always @(EEMA or EEMDO_M)
	if (EEMA[0]) EEMDO = EEMDO_M[31:16];
	else		 EEMDO = EEMDO_M[15:0];
//------------------------------------------------------------------------
wire	[4:0]	ADMCKDiv;
wire			ADMCKSel;
wire			ADMCKLoadDiv;
//------------------------------------------------------------------------
SEIPApbIf SEIPApbIf(
			.PIA			(PIA),
			.PIDI			(PIDI),
			.PIDO			(PIDO),
			.XPWE			(XPWE),
			.XPOE			(XPOE),
			.PRDY			(PRDY),
        	            	
			.PCLK       	(MCK),
			.PRESETB    	(XRST),
			.XRSTReg    	(XRSTReg),

			.ADMCKSel		(ADMCKSel),
			.ADMCKDiv		(ADMCKDiv),
			.ADMCKLoadDiv	(ADMCKLoadDiv),
        	            	
        	.PSEL    		(PSEL),
        	.PENABLE    	(PENABLE),
        	.PADDR      	(PADDR),
        	.PWRITE     	(PWRITE),
        	.PWDATA     	(PWDATA),
        	.PREADY     	(PREADY),
        	.PRDATA     	(PRDATA),

        	.RxDmaErr		(RxDmaErr),
        	.TxDmaErr		(TxDmaErr),
        	.RxDmaReq		(RxDmaReq),
        	.TxDmaReq		(TxDmaReq),
        	.SEIPInt		(SEIPInt),
        	
			.RxFIFOWrite 	(RxFIFOWrite),
        	.RxFIFOWrData 	(RxFIFOWrData),
			.RxFIFOReadCpu 	(RxFIFOReadCpu),
        	.RxFIFORdDataCpu(RxFIFORdDataCpu),
        	.RxFIFOFlush 	(RxFIFOFlush),
        	.RxFIFODataCnt 	(RxFIFODataCnt),
        	.RxFIFOEmpty 	(RxFIFOEmpty),
        	.RxFIFOFull 	(RxFIFOFull),
        	
        	.RxDmaEn 		(RxDmaEn),
        	.RxDmaSize 		(RxDmaSize),
        	.RxDmaReset 	(RxDmaReset),
        	
			.TxFIFORead 	(TxFIFORead),
        	.TxFIFORdData 	(TxFIFORdData),
			.TxFIFOWriteCpu (TxFIFOWriteCpu),
        	.TxFIFOWrDataCpu(TxFIFOWrDataCpu),
        	.TxFIFOFlush 	(TxFIFOFlush),
        	.TxFIFODataCnt 	(TxFIFODataCnt),
        	.TxFIFOEmpty 	(TxFIFOEmpty),
        	.TxFIFOFull 	(TxFIFOFull),
        	
        	.TxDmaEn 		(TxDmaEn),
        	.TxDmaSize 		(TxDmaSize),
        	.TxDmaReset 	(TxDmaReset)
);
//------------------------------------------------------------------------
SEIPDmaIf SEIPDmaIf(
			.PCLK       	(MCK),
			.PRESETB    	(XRST),
        	
			.RxFIFOWrite 	(RxFIFOWrite),
        	.RxFIFOWrData 	(RxFIFOWrData),
			.RxFIFOReadCpu 	(RxFIFOReadCpu),
        	.RxFIFORdDataCpu(RxFIFORdDataCpu),
        	.RxFIFOFlush 	(RxFIFOFlush),
        	.RxFIFODataCnt 	(RxFIFODataCnt),
        	.RxFIFOEmpty 	(RxFIFOEmpty),
        	.RxFIFOFull 	(RxFIFOFull),
        	
        	.RXSYNC 		(RXSYNC),
        	.RXRDY 			(RXRDY),
        	.RXWE 			(RXWE),
        	.RXD 			(RXD),
        	
        	.RxDmaEn 		(RxDmaEn),
        	.RxDmaSize 		(RxDmaSize),
        	.RxDmaReset 	(RxDmaReset),
        	.RxDmaRequest 	(RxDmaRequest),
        	.RxDmaErr		(RxDmaErr),
        	.RxDmaReq		(RxDmaReq),

			.TxFIFORead 	(TxFIFORead),
        	.TxFIFORdData 	(TxFIFORdData),
			.TxFIFOWriteCpu (TxFIFOWriteCpu),
        	.TxFIFOWrDataCpu(TxFIFOWrDataCpu),
        	.TxFIFOFlush 	(TxFIFOFlush),
        	.TxFIFODataCnt 	(TxFIFODataCnt),
        	.TxFIFOEmpty 	(TxFIFOEmpty),
        	.TxFIFOFull 	(TxFIFOFull),
        	
        	.TXSYNC 		(TXSYNC),
        	.TXRDY 			(TXRDY),
        	.TXRD 			(TXRD),
        	.TXD 			(TXD),
        	
        	.TxDmaEn 		(TxDmaEn),
        	.TxDmaSize 		(TxDmaSize),
        	.TxDmaReset 	(TxDmaReset),
        	.TxDmaRequest 	(TxDmaRequest),
        	.TxDmaReq		(TxDmaReq),
        	.TxDmaErr		(TxDmaErr)
);
//------------------------------------------------------------------------
wire TESTEN = 0;
wire SEIPXRST = TESTEN ? XRST : XRST & XRSTReg;

SEIP SEIP(
// System
			.MCK			(MCK),
			.XRST			(SEIPXRST),
            	
			.TE				(TE),
			.TI0			(TI0),
			.TI1			(TI1),
			.TI2			(TI2),
			.TI3			(TI3),
			.TI4			(TI4),
			.TO0			(TO0),
			.TO1			(TO1),
			.TO2			(TO2),
			.TO3			(TO3),
			.TO4			(TO4),

// MPU Interface
			.PIA			(PIA),
			.PIDI			(PIDI),
			.PIDO			(PIDO),
			.XPWE			(XPWE),
			.XPOE			(XPOE),
			.PRDY			(PRDY),
                        	
// PCM RX               	
			.RXD			(RXD),
			.RXWE			(RXWE),
			.RXRDY			(RXRDY),
			.RXSYNC			(RXSYNC),
                        	
// PCM TX               	
			.TXD			(TXD),
			.TXRD			(TXRD),
			.TXRDY			(TXRDY),
			.TXSYNC			(TXSYNC),
                        	
// I2S Interface        	
			.SD1O			(SD1O),
			.SD2O			(SD2O),
			.LRCKO			(LRCKO),
			.SCKO			(SCKO),
			.ADMCK			(ADMCKInt),
			.SDI1			(SDI1),
			.SDI2			(SDI2),
			.MLRCK			(MLRCK),
			.MSCK			(MSCK),

// Wave-Table ROM Interface
			.WEMA			(WEMA),
			.WEMDO			(WEMDO),
			.WEMDI			(WEMDI),
			.EXMBIH			(EXMBIH),
			.XWEMOC			(XWEMOC),
			.XWEMWE			(XWEMWE),
                        	
// RAM1 Interface       	
			.WIMA			(WIMA),
			.WIMD			(WIMD),
			.WIMDI			(WIMDI),
			.XWIMWE			(XWIMWE),
			.XWIMCE			(XWIMCE),
                        	
// RAM2 Interface       	
			.TIMA			(TIMA),
			.TIMO			(TIMO),
			.TIMI			(TIMI),
			.XTIMWE			(XTIMWE),
			.XTIMCE			(XTIMCE),
                        	
// RAM3 Interface       	
			.EIMA			(EIMA),
			.EIMO			(EIMO),
			.EIMDI			(EIMDI),
			.XEIMWE			(XEIMWE),
			.XEIMCE			(XEIMCE),

// RAM4 Interface
			.EEMA			(EEMA),
			.EEMDO			(EEMDO),
			.EEMDI			(EEMDI),
			.XEEMWE			(XEEMWE),
			.XEEMCE			(XEEMCE),

// ROM Interface
			.TROMA			(TROMA),
			.TROMO			(TROMO),
			.XTROMCE		(XTROMCE)
);
//------------------------------------------------------------------------
// RAM1 Interface
RA1SH512x16 RAM1(
		.CLK		(MCK),
		.A			(WIMA),
		.Q			(WIMD),
		.D			(WIMDI),
		.WEN		(XWIMWE),
		.CEN		(XWIMCE)
);

// RAM2 Interface
RA1SH512x24 RAM2(
		.CLK		(MCK),
		.A			(TIMA),
		.Q			(TIMO),
		.D			(TIMI),
		.WEN		(XTIMWE),
		.CEN		(XTIMCE)
);

// RAM3 Interface
RA1SH256x16 RAM3(
		.CLK		(MCK),
		.A			(EIMA),
		.Q			(EIMO),
		.D			(EIMDI),
		.WEN		(XEIMWE),
		.CEN		(XEIMCE)
);

// ROM Interface
RODSH512x8 ROM(
		.CLK		(MCK),
		.A			(TROMA),
		.Q			(TROMO),
		.CEN		(XTROMCE)
);
//------------------------------------------------------------------------

SEIPCKD CKD (
    	.Clk		(MCK),
    	.nReset		(SEIPXRST),
    	.LoadDiv	(ADMCKLoadDiv),
    	.Div		(ADMCKDiv),
    	.OutClk		(ADMCKReg)
);

assign ADMCK = ADMCKSel ? ADMCKReg : ADMCKInt;

endmodule

module SEIPCKD (Clk, nReset, Div, LoadDiv, OutClk);

   input        Clk;                        // Primary Input Clock
   input        nReset;                     // Primary Reset(Active Low)
   input [4:0]  Div;
   input		LoadDiv;
   output       OutClk;                     // Divided Clock
   
   // ------------------------------------------
   // Module parameters
   // ------------------------------------------
//   parameter           Div      = 2;               // Default division : 2
   parameter    SizeCnt  = 5;               // Default size of division counter

   // ------------------------------------------
   // Internal parameters
   // ------------------------------------------
   // Parameters for even division
   wire [3:0]   EHalfDiv  = Div>>1;      // Half value of even division number
   wire [3:0]   EInitCnt  = EHalfDiv - 1;   // Initial value of even division counter

   // ------------------------------------------
   // Signal declarations
   // ------------------------------------------
   wire                OutClk;                     // Divided clock

   // ------------------------------------------
   // Register declarations
   // ------------------------------------------
   reg                 NextIntOutClk;              // Next state of internal divided clock
   reg                 IntOutClk;                  // Internal divided clock
   reg [SizeCnt-1:0]   NextDivCnt;                 // Next state of division counter
   reg [SizeCnt-1:0]   DivCnt;                     // Division counter

   // -------------------------------------------------------------------
   // SizeCnt bit division counter
   //
   // Division counter is instantiated only when division number is
   // larger than 1.
   // -------------------------------------------------------------------
   always @(EInitCnt or DivCnt)
     begin
       // Division counter for even division number
         if(DivCnt == {SizeCnt{1'b0}})
           NextDivCnt = EInitCnt;
         else
           NextDivCnt = DivCnt - 1;
     end
               
   always @(posedge Clk or negedge nReset) 
       if (!nReset) 
         DivCnt <= {SizeCnt{1'b1}};
       else if (LoadDiv) 
         DivCnt <= EInitCnt;
       else
         DivCnt <= NextDivCnt;

   // -------------------------------------------------------------------
   // Internal divided clock
   //
   //    When the next of division counter is a initial value,
   //    internal divided clock is inverted.
   //    IntOutClk clock always shapes 50% duty clock.
   //
   //                .---.   .---.   .---.   .---.   .---.   .---.   .---
   //                |   |   |   |   |   |   |   |   |   |   |   |   |
   //    Clk      ---*   *---*   *---*   *---*   *---*   *---*   *---*
   //
   //                .-------.       .-------.       .-------.       .---
   //                |       |       |       |       |       |       |
   //    Div = 2  ---*       *-------*       *-------*       *-------*
   //
   //                .---------------.               .---------------.
   //                |               |               |               |
   //    Div = 4  ---*               *---------------*               *---
   //
   // -------------------------------------------------------------------
   always @(EInitCnt or DivCnt or IntOutClk or NextDivCnt)
     begin
       // Even divider
         if(NextDivCnt == EInitCnt)
           NextIntOutClk = ~IntOutClk;
         else
           NextIntOutClk = IntOutClk;
     end
                  
   always @(posedge Clk or negedge nReset) 
     begin
         if (!nReset) 
           IntOutClk <= 1'b0;
         else
           IntOutClk <= NextIntOutClk;
     end

   // -------------------------------------------------------------------
   // Divided clock
   // -------------------------------------------------------------------
   assign OutClk = IntOutClk;

endmodule
