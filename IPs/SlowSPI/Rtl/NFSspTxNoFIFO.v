
// No FIFO Mode
module NFSspTxNoFIFO (
			PCLK,
			PRESETn,
			DSSPCLK,
			SPITXDATWr,
			TxFRdPtrInc,
			TxRxBSY,
			PWDATAIn,
			
			TxDataAvlbl,
			SPITXDATRd,
			BSY,
			SPITXOUTDAT
);

	input	PCLK;
	input	PRESETn;
	input [3:0]	DSSPCLK;
	input	SPITXDATWr;
	input	TxFRdPtrInc;
	input	TxRxBSY;
	input	[15:0]	PWDATAIn;

	output	TxDataAvlbl;
	output	SPITXDATRd;
	output	BSY;
	output	[15:0]	SPITXOUTDAT;

reg	[15:0]	SPITXDAT;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		SPITXDAT <= 0;	
	else if (SPITXDATWr)
		SPITXDAT <= PWDATAIn;
end

reg  TxDataAvlbl;
reg	 DelRdPtrInc;

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	DelRdPtrInc <= 1'b0;
	else
	DelRdPtrInc <= TxFRdPtrInc;
end

wire	SPITXDATRd;
assign SPITXDATRd = TxFRdPtrInc ^ DelRdPtrInc;

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	TxDataAvlbl <= 1'b0;
	else if (SPITXDATWr) 
	TxDataAvlbl <= 1'b1;
	else if (SPITXDATRd)
	TxDataAvlbl <= 1'b0;
end

assign BSY = TxDataAvlbl | TxRxBSY;
// WriteData OverWrite Detect
 NFSspTxLJustify uNFSspTxLJustify            (
                        .PCLK            (PCLK),
                        .PRESETn         (PRESETn),
                        .DSSPCLK         (DSSPCLK),
                        .TxFRdData       (SPITXDAT),
                        .TxFRdDataIn     (SPITXOUTDAT)
                       );
endmodule

// --=============================== End =====================================--
