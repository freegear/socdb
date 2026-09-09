
`timescale 1ns/10ps

module DDRTop(
    		ARESETB,
    		nPOR,
    		MCLK,
    		nMCLK,
    		ACLK,
    		nACLK,
    		
			AWAddr,
			AWId,
			AWLen,
			AWValid,
			AWReady,
			AWBurst,
    		
    		WLast,
    		WStrb,
    		WData,
    		WValid,
    		WReady,
    		WId,
    		
    		BResp,
    		BValid,
    		BReady,
    		BId,
    		
			ARAddr,
			ARId,
			ARLen,
			ARValid,
			ARReady,
			ARBurst,
    		
    		RData,
    		RValid,
    		RReady,
    		RLast,
    		RId,
    		RResp,
    		
    		SD_CKE,
    		SD_CSB,
    		SD_RASB,
    		SD_CASB,
    		SD_WEB,
    		SD_BADDR,
    		SD_ADDR,
    		SD_DQE,
    		SD_DQI,
    		SD_DQO,
    		SD_DQM,
    		SD_DQSE,
    		SD_DQSO,
    		SD_DQSI,
    		nSD_DQSI,
    		
			PCLK,
			PRESETB,
    		PSEL, 
    		PENABLE, 
    		PADDR, 
    		PWRITE, 
    		PWDATA, 
			PRDATA
);


`include "DDRPara.v"

input    		ARESETB;  // asynchronous reset
input			nPOR;
input			MCLK;
input			nMCLK;
input    		ACLK;
input			nACLK;

// Write Command
input  [31:0]	AWAddr;
input  [ID:0] 	AWId;
input  [BBL:0] 	AWLen;
input	[1:0]	AWBurst;
input			AWValid;
output			AWReady;

// Write Data
input			WLast;
input  [BW:0] 	WStrb;
input  [ID:0] 	WId;
input  [DW:0] 	WData ; // data input
input			WValid;
output			WReady;

// Write Response
output [ID:0] 	BId;
output [1:0]	BResp;
input			BReady;
output			BValid;

// Read Command
input  [31:0]	ARAddr;
input  [ID:0] 	ARId;
input  [BBL:0] 	ARLen;
input	[1:0]	ARBurst;
input			ARValid;
output			ARReady;

// Read Data
input			RReady;
output			RLast;
output          RValid;
output [DW:0] 	RData;
output [ID:0] 	RId;
output [ 1:0]  	RResp;

// Register
input         	PCLK;
input         	PRESETB;
              	
input  [ 7:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

// SDRAM
output    		SD_CKE  ; // clock enable
output    		SD_CSB  ; // chip select
output    		SD_RASB ; // row address strobe
output    		SD_CASB ; // column address strobe
output    		SD_WEB  ; // write enable
output [BAW:0]  SD_BADDR; // bank address
output [RAW:0]  SD_ADDR ; // address
output    		SD_DQE; // dq output enable
input  [MDW:0]	SD_DQI; // data input
output [MDW:0] 	SD_DQO; // data output
output [DMW:0]	SD_DQM;
output			SD_DQSE;
output [DMW:0]	SD_DQSO;
input  [DMW:0]	SD_DQSI;
input  [DMW:0]	nSD_DQSI;
//-------------------------------------------------------------
// Controller
wire [AW:0]		BA_AA;
wire			BA_REQ;
wire [BL:0]   	BA_TT;
wire [ID:0]		BA_ID;
wire			BA_RW;
wire			BA_PM;
wire			SDREnStatus;
wire [ 7:0]		Dly0Sel;
wire [ 7:0]		Dly1Sel;

wire			DiValid;
wire			DoValid;
wire			QueEmp;
wire			QueFul;
wire			QueErr;
wire			RdLast;
wire	[ID:0] 	RdId;
wire			DqsoValid;
wire	[1:0] 	ColAddrSiz;
wire			RdDataInSel;
wire			RdDataPol;
//-------------------------------------------------------------
`ifdef CHIP
wire 			SD_DQSI0_X;
wire 			nSD_DQSI0_X;
wire 			SD_DQSI1_X;
wire 			nSD_DQSI1_X;

wire			SD_DQSI0_DLY0;
wire			SD_DQSI0_DLY1;
wire			SD_DQSI0_DLY2;
wire			SD_DQSI0_DLY3;
wire			SD_DQSI0_DLY4;
wire			SD_DQSI0_DLY5;
wire			SD_DQSI0_DLY6;
wire			SD_DQSI0_DLY7;

wire			nSD_DQSI0_DLY0;
wire			nSD_DQSI0_DLY1;
wire			nSD_DQSI0_DLY2;
wire			nSD_DQSI0_DLY3;
wire			nSD_DQSI0_DLY4;
wire			nSD_DQSI0_DLY5;
wire			nSD_DQSI0_DLY6;
wire			nSD_DQSI0_DLY7;

wire			SD_DQSI1_DLY0;
wire			SD_DQSI1_DLY1;
wire			SD_DQSI1_DLY2;
wire			SD_DQSI1_DLY3;
wire			SD_DQSI1_DLY4;
wire			SD_DQSI1_DLY5;
wire			SD_DQSI1_DLY6;
wire			SD_DQSI1_DLY7;

wire			nSD_DQSI1_DLY0;
wire			nSD_DQSI1_DLY1;
wire			nSD_DQSI1_DLY2;
wire			nSD_DQSI1_DLY3;
wire			nSD_DQSI1_DLY4;
wire			nSD_DQSI1_DLY5;
wire			nSD_DQSI1_DLY6;
wire			nSD_DQSI1_DLY7;

DLY1X1 DQSI0DLY0 ( .A(SD_DQSI[0]), 	  .Y(SD_DQSI0_DLY0) );
DLY1X1 DQSI0DLY1 ( .A(SD_DQSI0_DLY0), .Y(SD_DQSI0_DLY1) );
DLY1X1 DQSI0DLY2 ( .A(SD_DQSI0_DLY1), .Y(SD_DQSI0_DLY2) );
DLY1X1 DQSI0DLY3 ( .A(SD_DQSI0_DLY2), .Y(SD_DQSI0_DLY3) );
DLY1X1 DQSI0DLY4 ( .A(SD_DQSI0_DLY3), .Y(SD_DQSI0_DLY4) );
DLY1X1 DQSI0DLY5 ( .A(SD_DQSI0_DLY4), .Y(SD_DQSI0_DLY5) );
DLY1X1 DQSI0DLY6 ( .A(SD_DQSI0_DLY5), .Y(SD_DQSI0_DLY6) );
DLY1X1 DQSI0DLY7 ( .A(SD_DQSI0_DLY6), .Y(SD_DQSI0_DLY7) );

DLY1X1 nDQSI0DLY0 ( .A(nSD_DQSI[0]),    .Y(nSD_DQSI0_DLY0) );
DLY1X1 nDQSI0DLY1 ( .A(nSD_DQSI0_DLY0), .Y(nSD_DQSI0_DLY1) );
DLY1X1 nDQSI0DLY2 ( .A(nSD_DQSI0_DLY1), .Y(nSD_DQSI0_DLY2) );
DLY1X1 nDQSI0DLY3 ( .A(nSD_DQSI0_DLY2), .Y(nSD_DQSI0_DLY3) );
DLY1X1 nDQSI0DLY4 ( .A(nSD_DQSI0_DLY3), .Y(nSD_DQSI0_DLY4) );
DLY1X1 nDQSI0DLY5 ( .A(nSD_DQSI0_DLY4), .Y(nSD_DQSI0_DLY5) );
DLY1X1 nDQSI0DLY6 ( .A(nSD_DQSI0_DLY5), .Y(nSD_DQSI0_DLY6) );
DLY1X1 nDQSI0DLY7 ( .A(nSD_DQSI0_DLY6), .Y(nSD_DQSI0_DLY7) );

DLY1X1 DQSI1DLY0 ( .A(SD_DQSI[1]), 	  .Y(SD_DQSI1_DLY0) );
DLY1X1 DQSI1DLY1 ( .A(SD_DQSI1_DLY0), .Y(SD_DQSI1_DLY1) );
DLY1X1 DQSI1DLY2 ( .A(SD_DQSI1_DLY1), .Y(SD_DQSI1_DLY2) );
DLY1X1 DQSI1DLY3 ( .A(SD_DQSI1_DLY2), .Y(SD_DQSI1_DLY3) );
DLY1X1 DQSI1DLY4 ( .A(SD_DQSI1_DLY3), .Y(SD_DQSI1_DLY4) );
DLY1X1 DQSI1DLY5 ( .A(SD_DQSI1_DLY4), .Y(SD_DQSI1_DLY5) );
DLY1X1 DQSI1DLY6 ( .A(SD_DQSI1_DLY5), .Y(SD_DQSI1_DLY6) );
DLY1X1 DQSI1DLY7 ( .A(SD_DQSI1_DLY6), .Y(SD_DQSI1_DLY7) );

DLY1X1 nDQSI1DLY0 ( .A(nSD_DQSI[1]),    .Y(nSD_DQSI1_DLY0) );
DLY1X1 nDQSI1DLY1 ( .A(nSD_DQSI1_DLY0), .Y(nSD_DQSI1_DLY1) );
DLY1X1 nDQSI1DLY2 ( .A(nSD_DQSI1_DLY1), .Y(nSD_DQSI1_DLY2) );
DLY1X1 nDQSI1DLY3 ( .A(nSD_DQSI1_DLY2), .Y(nSD_DQSI1_DLY3) );
DLY1X1 nDQSI1DLY4 ( .A(nSD_DQSI1_DLY3), .Y(nSD_DQSI1_DLY4) );
DLY1X1 nDQSI1DLY5 ( .A(nSD_DQSI1_DLY4), .Y(nSD_DQSI1_DLY5) );
DLY1X1 nDQSI1DLY6 ( .A(nSD_DQSI1_DLY5), .Y(nSD_DQSI1_DLY6) );
DLY1X1 nDQSI1DLY7 ( .A(nSD_DQSI1_DLY6), .Y(nSD_DQSI1_DLY7) );

//synopsys dc_script_begin
//set_dont_touch {DQSI0DLY0, DQSI0DLY1, DQSI0DLY2, DQSI0DLY3, DQSI0DLY4, DQSI0DLY5, DQSI0DLY6, DQSI0DLY7}
//set_dont_touch {nDQSI0DLY0, nDQSI0DLY1, nDQSI0DLY2, nDQSI0DLY3, nDQSI0DLY4, nDQSI0DLY5, nDQSI0DLY6, nDQSI0DLY7}
//set_dont_touch {DQSI1DLY0, DQSI1DLY1, DQSI1DLY2, DQSI1DLY3, DQSI1DLY4, DQSI1DLY5, DQSI1DLY6, DQSI1DLY7}
//set_dont_touch {nDQSI1DLY0, nDQSI1DLY1, nDQSI1DLY2, nDQSI1DLY3, nDQSI1DLY4, nDQSI1DLY5, nDQSI1DLY6, nDQSI1DLY7}
//synopsys dc_script_end

// Coarse Delay
wire SD_DQSI0_DLY_C;
wire nSD_DQSI0_DLY_C;
wire SD_DQSI1_DLY_C;
wire nSD_DQSI1_DLY_C;

assign SD_DQSI0_DLY_C = Dly0Sel[7:4] == 0 ? SD_DQSI[0] : 
						Dly0Sel[7:4] == 1 ? SD_DQSI0_DLY0 :
						Dly0Sel[7:4] == 2 ? SD_DQSI0_DLY1 :
						Dly0Sel[7:4] == 3 ? SD_DQSI0_DLY2 :
						Dly0Sel[7:4] == 4 ? SD_DQSI0_DLY3 :
						Dly0Sel[7:4] == 5 ? SD_DQSI0_DLY4 :
						Dly0Sel[7:4] == 6 ? SD_DQSI0_DLY5 :
						Dly0Sel[7:4] == 7 ? SD_DQSI0_DLY6 :
						               		SD_DQSI0_DLY7 ;

assign nSD_DQSI0_DLY_C= Dly0Sel[7:4] == 0 ? nSD_DQSI[0] : 
						Dly0Sel[7:4] == 1 ? nSD_DQSI0_DLY0 :
						Dly0Sel[7:4] == 2 ? nSD_DQSI0_DLY1 :
						Dly0Sel[7:4] == 3 ? nSD_DQSI0_DLY2 :
						Dly0Sel[7:4] == 4 ? nSD_DQSI0_DLY3 :
						Dly0Sel[7:4] == 5 ? nSD_DQSI0_DLY4 :
						Dly0Sel[7:4] == 6 ? nSD_DQSI0_DLY5 :
						Dly0Sel[7:4] == 7 ? nSD_DQSI0_DLY6 :
						               		nSD_DQSI0_DLY7 ;

assign SD_DQSI1_DLY_C =	Dly1Sel[7:4] == 0 ? SD_DQSI[1] : 
						Dly1Sel[7:4] == 1 ? SD_DQSI1_DLY0 :
						Dly1Sel[7:4] == 2 ? SD_DQSI1_DLY1 :
						Dly1Sel[7:4] == 3 ? SD_DQSI1_DLY2 :
						Dly1Sel[7:4] == 4 ? SD_DQSI1_DLY3 :
						Dly1Sel[7:4] == 5 ? SD_DQSI1_DLY4 :
						Dly1Sel[7:4] == 6 ? SD_DQSI1_DLY5 :
						Dly1Sel[7:4] == 7 ? SD_DQSI1_DLY6 :
						               		SD_DQSI1_DLY7 ;

assign nSD_DQSI1_DLY_C= Dly1Sel[7:4] == 0 ? nSD_DQSI[1] : 
						Dly1Sel[7:4] == 1 ? nSD_DQSI1_DLY0 :
						Dly1Sel[7:4] == 2 ? nSD_DQSI1_DLY1 :
						Dly1Sel[7:4] == 3 ? nSD_DQSI1_DLY2 :
						Dly1Sel[7:4] == 4 ? nSD_DQSI1_DLY3 :
						Dly1Sel[7:4] == 5 ? nSD_DQSI1_DLY4 :
						Dly1Sel[7:4] == 6 ? nSD_DQSI1_DLY5 :
						Dly1Sel[7:4] == 7 ? nSD_DQSI1_DLY6 :
						               		nSD_DQSI1_DLY7 ;

// Fine Delay
wire 			SD_DQSI0_BUF_F;
wire 			nSD_DQSI0_BUF_F;
wire 			SD_DQSI1_BUF_F;
wire 			nSD_DQSI1_BUF_F;

wire			SD_DQSI0_BUF0;
wire			SD_DQSI0_BUF1;
wire			SD_DQSI0_BUF2;
wire			SD_DQSI0_BUF3;

wire			nSD_DQSI0_BUF0;
wire			nSD_DQSI0_BUF1;
wire			nSD_DQSI0_BUF2;
wire			nSD_DQSI0_BUF3;

wire			SD_DQSI1_BUF0;
wire			SD_DQSI1_BUF1;
wire			SD_DQSI1_BUF2;
wire			SD_DQSI1_BUF3;

wire			nSD_DQSI1_BUF0;
wire			nSD_DQSI1_BUF1;
wire			nSD_DQSI1_BUF2;
wire			nSD_DQSI1_BUF3;

BUFX2 DQSI0BUF0 ( .A(SD_DQSI0_DLY_C), .Y(SD_DQSI0_BUF0) );
BUFX2 DQSI0BUF1 ( .A(SD_DQSI0_BUF0),  .Y(SD_DQSI0_BUF1) );
BUFX2 DQSI0BUF2 ( .A(SD_DQSI0_BUF1),  .Y(SD_DQSI0_BUF2) );
BUFX2 DQSI0BUF3 ( .A(SD_DQSI0_BUF2),  .Y(SD_DQSI0_BUF3) );

BUFX2 nDQSI0BUF0 ( .A(nSD_DQSI0_DLY_C), .Y(nSD_DQSI0_BUF0) );
BUFX2 nDQSI0BUF1 ( .A(nSD_DQSI0_BUF0),  .Y(nSD_DQSI0_BUF1) );
BUFX2 nDQSI0BUF2 ( .A(nSD_DQSI0_BUF1),  .Y(nSD_DQSI0_BUF2) );
BUFX2 nDQSI0BUF3 ( .A(nSD_DQSI0_BUF2),  .Y(nSD_DQSI0_BUF3) );

BUFX2 DQSI1BUF0 ( .A(SD_DQSI1_DLY_C),.Y(SD_DQSI1_BUF0) );
BUFX2 DQSI1BUF1 ( .A(SD_DQSI1_BUF0), .Y(SD_DQSI1_BUF1) );
BUFX2 DQSI1BUF2 ( .A(SD_DQSI1_BUF1), .Y(SD_DQSI1_BUF2) );
BUFX2 DQSI1BUF3 ( .A(SD_DQSI1_BUF2), .Y(SD_DQSI1_BUF3) );

BUFX2 nDQSI1BUF0 ( .A(nSD_DQSI1_DLY_C), .Y(nSD_DQSI1_BUF0) );
BUFX2 nDQSI1BUF1 ( .A(nSD_DQSI1_BUF0),  .Y(nSD_DQSI1_BUF1) );
BUFX2 nDQSI1BUF2 ( .A(nSD_DQSI1_BUF1),  .Y(nSD_DQSI1_BUF2) );
BUFX2 nDQSI1BUF3 ( .A(nSD_DQSI1_BUF2),  .Y(nSD_DQSI1_BUF3) );

//synopsys dc_script_begin
//set_dont_touch {DQSI0BUF0, DQSI0BUF1, DQSI0BUF2, DQSI0BUF3}
//set_dont_touch {nDQSI0BUF0, nDQSI0BUF1, nDQSI0BUF2, nDQSI0BUF3}
//set_dont_touch {DQSI1BUF0, DQSI1BUF1, DQSI1BUF2, DQSI1BUF3}
//set_dont_touch {nDQSI1BUF0, nDQSI1BUF1, nDQSI1BUF2, nDQSI1BUF3}
//synopsys dc_script_end

assign SD_DQSI0_BUF_F = Dly0Sel[3:1] == 0 ? SD_DQSI0_DLY_C : 
						Dly0Sel[3:1] == 1 ? SD_DQSI0_BUF0 :
						Dly0Sel[3:1] == 2 ? SD_DQSI0_BUF1 :
						Dly0Sel[3:1] == 3 ? SD_DQSI0_BUF2 :
						                    SD_DQSI0_BUF3 ;

assign nSD_DQSI0_BUF_F= Dly0Sel[3:1] == 0 ? nSD_DQSI0_DLY_C : 
						Dly0Sel[3:1] == 1 ? nSD_DQSI0_BUF0 :
						Dly0Sel[3:1] == 2 ? nSD_DQSI0_BUF1 :
						Dly0Sel[3:1] == 3 ? nSD_DQSI0_BUF2 :
						                    nSD_DQSI0_BUF3 ;

assign SD_DQSI1_BUF_F = Dly1Sel[3:1] == 0 ? SD_DQSI1_DLY_C : 
						Dly1Sel[3:1] == 1 ? SD_DQSI1_BUF0 :
						Dly1Sel[3:1] == 2 ? SD_DQSI1_BUF1 :
						Dly1Sel[3:1] == 3 ? SD_DQSI1_BUF2 :
						                    SD_DQSI1_BUF3 ;

assign nSD_DQSI1_BUF_F= Dly1Sel[3:1] == 0 ? nSD_DQSI1_DLY_C : 
						Dly1Sel[3:1] == 1 ? nSD_DQSI1_BUF0 :
						Dly1Sel[3:1] == 2 ? nSD_DQSI1_BUF1 :
						Dly1Sel[3:1] == 3 ? nSD_DQSI1_BUF2 :
						                    nSD_DQSI1_BUF3 ;

assign	SD_DQSI0_X  = Dly0Sel[0] ? SD_DQSI0_BUF_F  : SD_DQSI0_DLY_C;
assign	nSD_DQSI0_X = Dly0Sel[0] ? nSD_DQSI0_BUF_F : nSD_DQSI0_DLY_C;
assign	SD_DQSI1_X  = Dly1Sel[0] ? SD_DQSI1_BUF_F  : SD_DQSI1_DLY_C;
assign	nSD_DQSI1_X = Dly1Sel[0] ? nSD_DQSI1_BUF_F : nSD_DQSI1_DLY_C;

/*
Dqsdelay DQS0DLYBUF (.S(Dly0Sel), .A(SD_DQSI[0]),  .X(SD_DQSI0_X));
Dqsdelay nDQS0DLYBUF(.S(Dly0Sel), .A(nSD_DQSI[0]), .X(nSD_DQSI0_X));
Dqsdelay DQS1DLYBUF (.S(Dly1Sel), .A(SD_DQSI[1]),  .X(SD_DQSI1_X));
Dqsdelay nDQS1DLYBUF(.S(Dly1Sel), .A(nSD_DQSI[1]), .X(nSD_DQSI1_X));
*/
`endif
//-------------------------------------------------------------
wire  [31:0]	AWAddrM;
wire  [ID:0] 	AWIdM;
wire  [BBL:0] 	AWLenM;
wire	[1:0]	AWBurstM;
wire			AWValidM;
wire			AWReadyM;
wire			WLastM;
wire  [BW:0] 	WStrbM;
wire  [ID:0] 	WIdM;
wire  [DW:0] 	WDataM;
wire			WValidM;
wire			WReadyM;
wire [ID:0] 	BIdM;
wire [1:0]		BRespM;
wire			BReadyM;
wire			BValidM;

wire  [31:0]	ARAddrM;
wire  [ID:0] 	ARIdM;
wire  [BBL:0] 	ARLenM;
wire	[1:0]	ARBurstM;
wire			ARValidM;
wire			ARReadyM;
wire			RReadyM;
wire			RLastM;
wire           	RValidM;
wire [DW:0] 	RDataM;
wire [ID:0] 	RIdM;
wire [1:0]		RRespM;
//-------------------------------------------------------------
`ifdef SLICE
wire  [31:0]	AWAddrT;
wire  [ID:0] 	AWIdT;
wire  [BBL:0] 	AWLenT;
wire	[1:0]	AWBurstT;
wire			AWValidT;
wire			AWReadyT;
wire			WLastT;
wire  [BW:0] 	WStrbT;
wire  [ID:0] 	WIdT;
wire  [DW:0] 	WDataT;
wire			WValidT;
wire			WReadyT;
wire [ID:0] 	BIdT;
//wire [1:0]		BRespT;
wire			BReadyT;
wire			BValidT;

wire  [31:0]	ARAddrT;
wire  [ID:0] 	ARIdT;
wire  [BBL:0] 	ARLenT;
wire	[1:0]	ARBurstT;
wire			ARValidT;
wire			ARReadyT;

wire			RReadyT;
wire			RLastT;
wire          	RValidT;
wire [DW:0] 	RDataT;
wire [ID:0] 	RIdT;
//wire [ 1:0]  	RRespT;

DDRRds #(32 + ID+1 + 4 + 2) WCmdSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({AWAddr, AWId, AWLen, AWBurst}),
		.READY_S      	(AWReady),
		.VALID_S      	(AWValid),
		.INFORMATION_R	({AWAddrT, AWIdT, AWLenT, AWBurstT}),
		.READY_R      	(AWReadyT),
		.VALID_R      	(AWValidT)
);

DDRRds #(4 + ID+1 + 32) WDatSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({WStrb, WId, WData}),
		.READY_S      	(WReady),
		.VALID_S      	(WValid),
		.INFORMATION_R	({WStrbT, WIdT, WDataT}),
		.READY_R      	(WReadyT),
		.VALID_R      	(WValidT)
);

//DDRRds #(4 + 2) WRespSlice(
DDRRds #(ID+1) WRespSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		//.INFORMATION_S	({BIdT, BRespT}),
		.INFORMATION_S	({BIdT}),
		.READY_S      	(BReadyT),
		.VALID_S      	(BValidT),
		//.INFORMATION_R	({BId, BResp}),
		.INFORMATION_R	({BId}),
		.READY_R      	(BReady),
		.VALID_R      	(BValid)
);

DDRRds #(32 + ID+1 + 4 + 2) RCmdSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		.INFORMATION_S	({ARAddr, ARId, ARLen, ARBurst}),
		.VALID_S      	(ARValid),
		.READY_S      	(ARReady),
		.INFORMATION_R	({ARAddrT, ARIdT, ARLenT, ARBurstT}),
		.VALID_R      	(ARValidT),
		.READY_R      	(ARReadyT)
);

//DDRRds #(2 + 1 + 32 + 4) RDatSlice(
DDRRds #(1 + 32 + ID+1) RDatSlice(
		.ACLK         	(ACLK), 
		.ARESETn      	(ARESETB), 
		//.INFORMATION_S	({RRespT, RLastT, RDataT, RIdT}),
		.INFORMATION_S	({RLastT, RDataT, RIdT}),
		.VALID_S      	(RValidT),
		.READY_S      	(RReadyT),
		.INFORMATION_R	({RLast, RData, RId}),
		.VALID_R      	(RValid),
		.READY_R      	(RReady)
);
`endif
//-------------------------------------------------------------
// AXI Burst DownSizer Bridge
DDRSpi DDRSpi(
		.ACLK			(ACLK),
		.ARESETn		(ARESETB),

`ifdef SLICE           	
		.AWADDR_M		(AWAddrT),
		.AWLEN_M		(AWLenT),
		.AWVALID_M		(AWValidT),
		.AWREADY_M		(AWReadyT),
		.AWID_M			(AWIdT),
		.AWBURST_M		(AWBurstT),
	                	
		.WLAST_M		(WLastT),
		.WSTRB_M  		(WStrbT),
		.WDATA_M   		(WDataT),
		.WVALID_M		(WValidT),
		.WREADY_M		(WReadyT),
		.WID_M			(WIdT),
                    	
		//.BRESP_M 		(BRespT),
		.BRESP_M 		(BResp),
    	.BVALID_M		(BValidT),
    	.BREADY_M		(BReadyT),
    	.BID_M			(BIdT),
                    	
		.ARADDR_M		(ARAddrT),
		.ARLEN_M		(ARLenT),
		.ARVALID_M		(ARValidT),
		.ARREADY_M		(ARReadyT),
		.ARID_M			(ARIdT),
		.ARBURST_M		(ARBurstT),
                    	
		.RREADY_M		(RReadyT),
		.RVALID_M		(RValidT),
		.RLAST_M		(RLastT),
		.RDATA_M   		(RDataT),
		.RID_M			(RIdT),
		//.RRESP_M		(RRespT),
		.RRESP_M		(RResp),
`else
		.AWADDR_M		(AWAddr),
		.AWLEN_M		(AWLen),
		.AWVALID_M		(AWValid),
		.AWREADY_M		(AWReady),
		.AWID_M			(AWId),
		.AWBURST_M		(AWBurst),
	                	
		.WLAST_M		(WLast),
		.WSTRB_M  		(WStrb),
		.WDATA_M   		(WData),
		.WVALID_M		(WValid),
		.WREADY_M		(WReady),
		.WID_M			(WId),
                    	
		.BRESP_M 		(BResp),
    	.BVALID_M		(BValid),
    	.BREADY_M		(BReady),
    	.BID_M			(BId),

		.ARADDR_M		(ARAddr),
		.ARLEN_M		(ARLen),
		.ARVALID_M		(ARValid),
		.ARREADY_M		(ARReady),
		.ARID_M			(ARId),
		.ARBURST_M		(ARBurst),
                    	
		.RREADY_M		(RReady),
		.RVALID_M		(RValid),
		.RLAST_M		(RLast),
		.RDATA_M   		(RData),
		.RID_M			(RId),
		.RRESP_M		(RResp),
`endif

// Slave    	            	
		.AWADDR_S		(AWAddrM),
		.AWLEN_S		(AWLenM),
		.AWVALID_S		(AWValidM),
		.AWREADY_S		(AWReadyM),
		.AWID_S			(AWIdM),
		.AWBURST_S		(AWBurstM),
	                	
		.WLAST_S		(WLastM),
		.WSTRB_S  		(WStrbM),
		.WDATA_S   		(WDataM),
		.WVALID_S		(WValidM),
		.WREADY_S		(WReadyM),
		.WID_S			(WIdM),
                    	
		.BRESP_S 		(BRespM),
    	.BVALID_S		(BValidM),
    	.BREADY_S		(BReadyM),
    	.BID_S			(BIdM),
                    	
		.ARADDR_S		(ARAddrM),
		.ARLEN_S		(ARLenM),
		.ARVALID_S		(ARValidM),
		.ARREADY_S		(ARReadyM),
		.ARID_S			(ARIdM),
		.ARBURST_S		(ARBurstM),
                    	
		.RREADY_S		(RReadyM),
		.RVALID_S		(RValidM),
		.RLAST_S		(RLastM),
		.RDATA_S   		(RDataM),
		.RID_S			(RIdM),
		.RRESP_S		(RRespM)
);

// AXI Interface
DDRAi DDRAi(
		.MCLK			(MCLK),
		.nMCLK			(nMCLK),
		.ACLK			(ACLK),
		.nACLK			(nACLK),
		.ARESETB		(ARESETB),
		.nPOR			(nPOR),
                    	
		.AWAddr			(AWAddrM[AW+2:2]),
		.AWLen			(AWLenM[BL:0]),
		.AWValid		(AWValidM),
		.AWReady		(AWReadyM),
		.AWId			(AWIdM),
		.AWBurst		(AWBurstM),
	                	
		.WLast			(WLastM),
		.WStrb  		(WStrbM),
		.WData   		(WDataM),
		.WValid			(WValidM),
		.WReady			(WReadyM),
		.WId			(WIdM),
                    	
		.BResp 			(BRespM),
    	.BValid			(BValidM),
    	.BReady			(BReadyM),
    	.BId			(BIdM),
    	            	
		.ARAddr			(ARAddrM[AW+2:2]),
		.ARLen			(ARLenM[BL:0]),
		.ARValid		(ARValidM),
		.ARReady		(ARReadyM),
		.ARId			(ARIdM),
		.ARBurst		(ARBurstM),
                    	
		.RReady			(RReadyM),
		.RValid			(RValidM),
		.RLast			(RLastM),
		.RData   		(RDataM),
		.RId			(RIdM),
		.RResp			(RRespM),
                    	
    	.RQFull			(RQFull),
    	.WQFull			(WQFull),
                    	
		.BA_AA   		(BA_AA),
		.BA_TT   		(BA_TT),
		.BA_REQ  		(BA_REQ),
		.BA_RW   		(BA_RW),
		.BA_ID			(BA_ID),
		.BA_PM			(BA_PM),

		.DiValid		(DiValid),
		.DoValid		(DoValid),
		.QueEmp			(QueEmp),
		.QueFul			(QueFul),
		.QueErr			(QueErr),
		.RdLast			(RdLast),
		.RdId			(RdId),
		.DqsoValid		(DqsoValid),
		.ColAddrSiz		(ColAddrSiz),
		.RdDataInSel	(RdDataInSel),
		.RdDataPol		(RdDataPol),

		.SD_DQE			(SD_DQE),
		.SD_DQI			(SD_DQI), 
		.SD_DQO			(SD_DQO),
		.SD_DQM			(SD_DQM),
		.SD_DQSE		(SD_DQSE),
		.SD_DQSO		(SD_DQSO),
`ifdef CHIP
		.nSD_DQSI0		(nSD_DQSI0_X),
		.nSD_DQSI1		(nSD_DQSI1_X),
		.SD_DQSI0		(SD_DQSI0_X),
		.SD_DQSI1		(SD_DQSI1_X)
`else
		.nSD_DQSI0		(nSD_DQSI[0]),
		.nSD_DQSI1		(nSD_DQSI[1]),
		.SD_DQSI0		(SD_DQSI[0]),
		.SD_DQSI1		(SD_DQSI[1])
`endif
);
//-------------------------------------------------------------
// SDRAM Controller
DDRCtl DDRCtl(
		.ACLK			(ACLK), 
		.nPOR			(nPOR),
		.ARESETB		(ARESETB),
		            	
		.BA_AA   		(BA_AA),
		.BA_TT   		(BA_TT),
		.BA_RW   		(BA_RW),
		.BA_REQ  		(BA_REQ),
		.BA_ID			(BA_ID),
		.BA_PM			(BA_PM),

		.DiValid		(DiValid),
		.DoValid		(DoValid),
		.QueEmp			(QueEmp),
		.QueFul			(QueFul),
		.QueErr			(QueErr),
		.RdLast			(RdLast),
		.RdId			(RdId),
		.DqsoValid		(DqsoValid),
		.ColAddrSiz		(ColAddrSiz),
		.RdDataInSel	(RdDataInSel),
		.RdDataPol		(RdDataPol),
		            	
		.PCLK			(PCLK), 
		.PRESETB		(PRESETB),
		.PENABLE 		(PENABLE), 
		.PSEL    		(PSEL), 
		.PWRITE  		(PWRITE), 
		.PADDR   		(PADDR), 
		.PWDATA  		(PWDATA),
		.PRDATA  		(PRDATA),
                    	
    	.RQFull			(RQFull),
    	.WQFull			(WQFull & WReady), // Write Buff Full & OverWrite
    	.SDREnStatus	(SDREnStatus),
    	.Dly0Sel		(Dly0Sel),
    	.Dly1Sel		(Dly1Sel),
 		            	
		.SD_CSB			(SD_CSB), 
		.SD_RASB		(SD_RASB), 
		.SD_CASB		(SD_CASB), 
		.SD_WEB			(SD_WEB), 
		.SD_CKE			(SD_CKE), 
		.SD_BADDR		(SD_BADDR), 
		.SD_ADDR		(SD_ADDR)
);
//-------------------------------------------------------------
endmodule
