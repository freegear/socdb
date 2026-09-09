
module SEIPApbIf(
				PIA, 
				PIDI, 
				XPOE, 
				XPWE, 
				PIDO, 
				PRDY,
			
				XRSTReg,
				
				ADMCKSel,
				ADMCKDiv,
				ADMCKLoadDiv,
	
				PCLK,
				PRESETB,
    			PSEL, 
    			PENABLE, 
    			PADDR, 
    			PWRITE, 
    			PWDATA, 
				PRDATA,
				PREADY,

				RxDmaErr,
				TxDmaErr,
				RxDmaReq,
				TxDmaReq,
				SEIPInt,
				
				RxFIFOWrite,
                RxFIFOWrData,
				RxFIFOReadCpu,
                RxFIFORdDataCpu,
                RxFIFOFlush,
                RxFIFODataCnt,
                RxFIFOEmpty,
                RxFIFOFull,
 				RxDmaEn,
                RxDmaSize,
                RxDmaReset,

				TxFIFORead,
                TxFIFORdData,
				TxFIFOWriteCpu,
                TxFIFOWrDataCpu,
                TxFIFOFlush,
                TxFIFODataCnt,
                TxFIFOEmpty,
                TxFIFOFull,
 				TxDmaEn,
                TxDmaSize,
                TxDmaReset
);


`include "SEIPPara.v"

output  [10:0]  PIA;
output  [15:0]  PIDI;
output          XPOE, XPWE;
input			PRDY;
input  [15:0]  	PIDO;
output			XRSTReg;

output			ADMCKSel;
output			ADMCKLoadDiv;
output  [4:0]  	ADMCKDiv;

input         	PCLK;
input         	PRESETB;
              	
input  [13:1] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;
output			PREADY;

input			RxDmaErr;
input			TxDmaErr;
input			RxDmaReq;
input			TxDmaReq;
output			SEIPInt;

// PCM RX DMA Interface
output          RxFIFOWrite;
output  [31:0]  RxFIFOWrData;
output          RxFIFOReadCpu;
input   [31:0]  RxFIFORdDataCpu;
output          RxFIFOFlush;
input [RXAW-1:0]RxFIFODataCnt;
input           RxFIFOEmpty;
input           RxFIFOFull;

output          RxDmaEn;
output  [RXAW-1:0]  RxDmaSize;
output          RxDmaReset;

// PCM TX DMA Interface
output          TxFIFORead;
input   [31:0]  TxFIFORdData;
output          TxFIFOWriteCpu;
output  [31:0]  TxFIFOWrDataCpu;
output          TxFIFOFlush;
input [RXAW-1:0]TxFIFODataCnt;
input           TxFIFOEmpty;
input           TxFIFOFull;

output          TxDmaEn;
output  [TXAW-1:0]  TxDmaSize;
output          TxDmaReset;
//------------------------------------------------------------------------------
wire rSelect  =  PSEL & ~PENABLE;
wire rWrite   =  PWRITE;
wire rRead    = ~PWRITE;

reg [31:0] PRDATA;
//------------------------------------------------------------------------------
// MPU Interface
reg [10:0] PIA;
reg [15:0] PIDI;

parameter P_IDLE   = 5'b00001;
parameter P_READ0  = 5'b00010;
parameter P_READ1  = 5'b00100;
parameter P_WRITE0 = 5'b01000;
parameter P_WRITE1 = 5'b10000;

reg [4:0]  CurStP, NxtStP;

wire  tPIdle   = CurStP[0];
wire  tPRead0  = CurStP[1];
wire  tPRead1  = CurStP[2];
wire  tPWrite0 = CurStP[3];
wire  tPWrite1 = CurStP[4];

wire  nPRead0  = NxtStP[1];
wire  nPWrite1 = NxtStP[4];

wire  RegSel = rSelect & ~PADDR[13];

always @(negedge PRESETB or posedge PCLK)
  	if (!PRESETB) 	CurStP <= P_IDLE;
  	else        	CurStP <= NxtStP;

always @(tPIdle or tPRead0 or tPRead1 or tPWrite0 or tPWrite1 or RegSel or rWrite or rRead or PRDY) begin
  	NxtStP = P_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tPIdle  : 	if (RegSel) begin
						if (rWrite)     NxtStP = P_WRITE0;
                    	else if (rRead) NxtStP = P_READ0;
					end
  	  	          	else        		NxtStP = P_IDLE;

  	  	tPRead0 : 	if (PRDY)			NxtStP = P_READ1;
  	  				else				NxtStP = P_READ0;

  	  	tPRead1 : 	if (PRDY)			NxtStP = P_IDLE;
  	  				else				NxtStP = P_READ0;

  	  	tPWrite0 : 	if (PRDY)			NxtStP = P_WRITE1;
  	  				else				NxtStP = P_WRITE0;

  	  	tPWrite1 : 	if (PRDY)			NxtStP = P_IDLE;
  	  				else				NxtStP = P_WRITE1;

  	  	default :               		NxtStP = P_IDLE;
  	endcase
end
//------------------------------------------------------------------------------
assign XPWE = ~(tPWrite1 & PRDY);
assign XPOE = ~((tPRead0 | tPRead1) & PRDY);

always @(negedge PRESETB or posedge PCLK)
  	if (!PRESETB) begin
			PIA  <= 0;
			PIDI <= 0;
	end
  	//else if (RegSel) begin
  	else if (nPWrite1 | nPRead0) begin
			PIA  <= PADDR[11:1];
		if (PADDR[1])
			PIDI <= PWDATA[31:16];
		else	
			PIDI <= PWDATA[15:0];
	end

//assign PRDATA = PADDR[13] ? PRDATADma : PIDO;

//				Reg Ready			DMA Ready
assign PREADY = (PRDY & ~tPRead0) | PADDR[13];
//------------------------------------------------------------------------------
// DMA PCM Interface
wire rRXCONSel 	= rSelect & (PADDR[13:2] == RXCON);
wire rRXSTSSel 	= rSelect & (PADDR[13:2] == RXSTS);
wire rRXDATSel 	= rSelect & (PADDR[13:2] == RXDAT);
wire rTXCONSel 	= rSelect & (PADDR[13:2] == TXCON);
wire rTXSTSSel 	= rSelect & (PADDR[13:2] == TXSTS);
wire rTXDATSel 	= rSelect & (PADDR[13:2] == TXDAT);
wire rXRSTSel 	= rSelect & (PADDR[13:2] == SEIPRST);
wire rCKDSel 	= rSelect & (PADDR[13:2] == SEIPCKD);

wire rRXCONWr	= rRXCONSel & rWrite;
wire rRXSTSWr	= rRXSTSSel & rWrite;
wire rRXDATWr	= rRXDATSel & rWrite;
wire rTXCONWr	= rTXCONSel & rWrite;
wire rTXSTSWr	= rTXSTSSel & rWrite;
wire rTXDATWr	= rTXDATSel & rWrite;
wire rXRSTWr	= rXRSTSel  & rWrite;
wire rCKDWr		= rCKDSel   & rWrite;

wire rRXCONRd	= rRXCONSel & rRead;
wire rRXSTSRd	= rRXSTSSel & rRead;
wire rRXDATRd	= rRXDATSel & rRead;
wire rTXCONRd	= rTXCONSel & rRead;
wire rTXSTSRd	= rTXSTSSel & rRead;
wire rTXDATRd	= rTXDATSel & rRead;
wire rXRSTRd	= rXRSTSel  & rRead;
wire rCKDRd		= rCKDSel   & rRead;

reg  		RxDmaEn;
reg  		RxDmaReqIntEn;
reg  		RxDmaErrIntEn;
reg [RXAW-1:0] 	RxDmaSize;
reg			RxDmaReset;

reg			RxFIFOFlush;
reg			RxFIFOWrite;
reg	[31:0]	RxFIFOWrData;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        RxDmaEn     	<= 0;
        RxDmaReqIntEn   <= 0;
        RxDmaErrIntEn   <= 0;
        RxDmaSize   	<= 3;
	end
	else if (rRXCONWr) begin
	    RxDmaEn     	<= PWDATA[0];
	    RxDmaReqIntEn   <= PWDATA[1];
	    RxDmaErrIntEn   <= PWDATA[2];
	    RxDmaSize   	<= PWDATA[7:4];
	end

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 		RxDmaReset <= 0;
	else if (rRXCONWr) 		RxDmaReset <= PWDATA[31];
	else if	(RxDmaReset)	RxDmaReset <= 0;
	else					RxDmaReset <= RxDmaReset;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 		RxFIFOFlush <= 0;
	else if (rRXCONWr) 		RxFIFOFlush <= PWDATA[30];
	else if	(RxFIFOFlush)	RxFIFOFlush <= 0;
	else					RxFIFOFlush <= RxFIFOFlush;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		RxFIFOWrite	<= 0;
	end
	else begin
		RxFIFOWrite	<= rRXDATWr;
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		RxFIFOWrData	<= 0;
	end
	else if (rRXDATWr) begin
		RxFIFOWrData	<= PWDATA;
	end

reg RxDmaReqSts;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	RxDmaReqSts <= 1'b0;
	else if (rRXSTSWr)	RxDmaReqSts <= 1'b0;
	else if (RxDmaReq)	RxDmaReqSts <= 1'b1;
	else				RxDmaReqSts <= RxDmaReqSts;

reg RxDmaErrSts;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	RxDmaErrSts <= 1'b0;
	else if (rRXSTSWr)	RxDmaErrSts <= 1'b0;
	else if (RxDmaErr)	RxDmaErrSts <= 1'b1;
	else				RxDmaErrSts <= RxDmaErrSts;

reg RxFIFOReadCpu;
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)
		RxFIFOReadCpu	<= 0;
	else 
		RxFIFOReadCpu	<= rRXDATRd;
//------------------------------------------------------------------------------
reg  		TxDmaEn;
reg  		TxDmaReqIntEn;
reg  		TxDmaErrIntEn;
reg [TXAW-1:0] 	TxDmaSize;
reg			TxDmaReset;

reg			TxFIFOFlush;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        TxDmaEn     	<= 0;
        TxDmaReqIntEn   <= 0;
        TxDmaErrIntEn   <= 0;
        TxDmaSize   	<= 4;
	end
	else if (rTXCONWr) begin
	    TxDmaEn     	<= PWDATA[0];
	    TxDmaReqIntEn   <= PWDATA[1];
	    TxDmaErrIntEn   <= PWDATA[2];
	    TxDmaSize   	<= PWDATA[7:4];
	end

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 		TxDmaReset <= 0;
	else if (rTXCONWr) 		TxDmaReset <= PWDATA[31];
	else if	(TxDmaReset)	TxDmaReset <= 0;
	else					TxDmaReset <= TxDmaReset;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 		TxFIFOFlush <= 0;
	else if (rTXCONWr) 		TxFIFOFlush <= PWDATA[30];
	else if	(TxFIFOFlush)	TxFIFOFlush <= 0;
	else					TxFIFOFlush <= TxFIFOFlush;

assign	TxFIFORead = rTXDATRd;

reg TxDmaReqSts;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	TxDmaReqSts <= 1'b0;
	else if (rTXSTSWr)	TxDmaReqSts <= 1'b0;
	else if (TxDmaReq)	TxDmaReqSts <= 1'b1;
	else				TxDmaReqSts <= TxDmaReqSts;

reg TxDmaErrSts;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	TxDmaErrSts <= 1'b0;
	else if (rTXSTSWr)	TxDmaErrSts <= 1'b0;
	else if (TxDmaErr)	TxDmaErrSts <= 1'b1;
	else				TxDmaErrSts <= TxDmaErrSts;

reg [31:0] TxFIFOWrDataCpu;
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		TxFIFOWrDataCpu	<= 0;
	end
	else if (rTXDATWr) begin
		TxFIFOWrDataCpu	<= PWDATA;
	end

reg TxFIFOWriteCpu;
always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)
		TxFIFOWriteCpu	<= 0;
	else 
		TxFIFOWriteCpu	<= rTXDATWr;
//------------------------------------------------------------------------------
wire DmaReqInt = (RxDmaReq & RxDmaReqIntEn) | (TxDmaReq & TxDmaReqIntEn);
wire DmaErrInt = (RxDmaErr & RxDmaErrIntEn) | (TxDmaErr & TxDmaErrIntEn);

reg  SEIPInt;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)
		SEIPInt	<= 0;
	else 
		SEIPInt	<= DmaErrInt | DmaReqInt;
//assign SEIPInt = DmaErrInt | DmaReqInt;
//------------------------------------------------------------------------------
reg XRSTReg;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	XRSTReg <= 1;
	else if (rXRSTWr) 	XRSTReg <= PWDATA[0];

reg ADMCKSel;
reg [4:0] ADMCKDiv;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) begin
			ADMCKSel <= 0;
			ADMCKDiv <= 8;
	end
	else if (rCKDWr) begin
			ADMCKSel <= PWDATA[7];
			ADMCKDiv <= PWDATA[4:0];
	end

reg ADMCKLoadDiv;
always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	ADMCKLoadDiv <= 1;
	else              	ADMCKLoadDiv <= rCKDWr;
//------------------------------------------------------------------------------
always @(negedge PRESETB or posedge PCLK)
	if 	(!PRESETB)		  	  PRDATA <= 32'b0;
	else begin
		if (PADDR[13])
			case(1'b1) // synopsys parallel_case
    	  		rRXCONRd	: PRDATA <= {24'b0, RxDmaSize, 1'b0, RxDmaErrIntEn, RxDmaReqIntEn, RxDmaEn};
    	  		rRXSTSRd	: PRDATA <= {RxFIFOFull, RxFIFOEmpty, RxFIFODataCnt, 1'b0, RxDmaReqSts, RxDmaErrSts, 1'b0};
    	  		rRXDATRd	: PRDATA <= {RxFIFORdDataCpu};
    	  		rTXCONRd	: PRDATA <= {24'b0, TxDmaSize, 1'b0, TxDmaErrIntEn, TxDmaReqIntEn, TxDmaEn};
    	  		rTXSTSRd	: PRDATA <= {TxFIFOFull, TxFIFOEmpty, TxFIFODataCnt, 1'b0, TxDmaReqSts, TxDmaErrSts, 1'b0};
    	  		rTXDATRd	: PRDATA <= {TxFIFORdData};
    	  		rXRSTRd		: PRDATA <= {PRDY, 6'b0, XRSTReg};
    	  		rCKDRd		: PRDATA <= {ADMCKSel, 2'b0, ADMCKDiv};
    	  		default		: PRDATA <= PRDATA;
			endcase
		else
							  PRDATA <= {PIDO, PIDO};
	end
//------------------------------------------------------------------------------
endmodule

