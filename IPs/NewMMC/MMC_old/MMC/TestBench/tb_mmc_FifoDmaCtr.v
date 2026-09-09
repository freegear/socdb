
`timescale 1ns/1ps

module  tb_mmc_DataFifo_DMA ;
reg	HCLK;
reg	HRESETn;

reg	FRST;

reg	[1:0]	DataSize;



reg	TxActive;
reg	TxRdPtrInc;
reg	[31:0]	HWData;
reg	TxWriteEn;
reg	RxRdPtrInc;

reg	RxActive;
reg	RxWriteEn;
reg	[31:0]	RxWrData;
// Outputs
wire [1:0] FFfail;
wire	FFfailClr;
wire	TFDET;
wire	TFHalf;
wire	TFEmpty;


wire    RFLast;
wire	RFFull;
wire	RFHalf;
wire   	RFEmpty;
	
wire	RFLastClr;
wire   	RxOverrun;
wire   	RxWrDone;
wire   	RFDET;
wire	[6:0]	FFCNT;
wire	[3:0]	WrPtr;
wire	[3:0]	RdPtr;
wire	[31:0]	FIFOWdata;
wire	FIFOWriteEn;

wire	EnDMA;
	     	
wire	DREQ;
wire	DACK;
wire	DMAINT; 


initial 
begin
	HCLK = 1'b0;
	HRESETn = 1'b0 ;
	#50 HRESETn= 1'b1;
end



always #5 HCLK = ~HCLK ;


initial
begin
	FRST	= 1'b0;
	DataSize =2'b10;
	TxActive = 1'b1;
	RxActive = 1'b0;
	TxRdPtrInc = 1'b0;
	TxWriteEn= 1'b0;
	RxRdPtrInc = 1'b0;

	HWData = 32'h0505AAAA;
	RxWriteEn = 1'b0 ;
	RxWrData = 32'd0;
#100
	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;

	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;

	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;

	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;

	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;

	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;



	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;



	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


	@(posedge HCLK);
	TxWriteEn= 1'b1;
	@(posedge HCLK);
	TxWriteEn= 1'b0;


end




mmc_DataFifo_DMA	DataFifo_DMA(
// Inputs
	.HCLK		(HCLK),
	.HRESETn	(HRESETn),
	.FRST		(FRST), // FIFO reset signal

	.DataSize	(DataSize),
	.TxActive	(TxActive), // Tx fifo enable
	.TxRdPtrInc	(TxRdPtrInc), // Tx의 경우 data state machine은 read pointer를 증가 시킨다.
	.TxWriteEn	(TxWriteEn),
	.RxRdPtrInc	(RxRdPtrInc),

	.HWData		(HWData),

	.RxActive	(RxActive),
	.RxWriteEn	(RxWriteEn),
	.RxWrData	(RxWrData),
// Outputs
	.FFfail		(FFfail),  // 01: fifo fail 10: last transfer fail (overrun underrun)
	.FFfailClr	(FFfailClr),
	.TFDET		(TFDET),   // 0: fifo full 1: 0~63
	.TFHalf		(TFHalf),  // 0: 33~64,  1: 0~32
       	.TFEmpty	(TFEmpty), // 0: 1~64,   1: 0


       	.RFLast		(RFLast),	 //  1: RX FIFO get last data
      	.RFFull		(RFFull),  //  1: 64
       	.RFHalf		(RFHalf),  //  0: 0~31,  1: 32~64
    	.RFEmpty	(RFEmpty),
				
	.RFLastClr	(RFLastClr), //  FIFO LAST DATA READY CLEAR
       	.RxOverrun	(RxOverrun),
       	.RxWrDone	(RxWrDone),
       	.RFDET		(RFDET),
	
      	.FFCNT		(FFCNT),

	.WrPtr		(WrPtr),
	.RdPtr		(RdPtr),
	.FIFOWdata	(FIFOWdata),
	.FIFOWriteEn	(FIFOWriteEn),

	.EnDMA		(EnDMA),
       	
	.DREQ		(DREQ),
        .DACK		(DACK),
       	.DMAINT		(DMAINT) 
		);




endmodule
