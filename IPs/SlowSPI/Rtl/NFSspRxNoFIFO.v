module NFSspRxNoFIFO(
			PCLK,
			PRESETn,
			RORIC,
			MS,
            RxFWr, 
            RxFRdPtrInc, 

            SRxFWrData, 
            MRxFWrData,
			RxWrite,
			RNE,
			RORRIS,
            RxFRdData
);

input			PCLK;
input			PRESETn;
input			RORIC;
input			MS;
input			RxFWr;
input			RxFRdPtrInc;
input	[15:0]	SRxFWrData;
input	[15:0]	MRxFWrData;

output			RxWrite;
output			RNE;
output			RORRIS;
output	[15:0]	RxFRdData;

wire  	[15:0]	RxData;

assign RxData = (MS) ? SRxFWrData : MRxFWrData;

reg		DelRxFWr;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	DelRxFWr <= 1'b0;
	else
	DelRxFWr <= RxFWr;
end

wire	RxWrite;
assign RxWrite= RxFWr ^ DelRxFWr;

reg	 [15:0] SPIRxData;
always @(posedge PCLK or negedge PRESETn)
begin	
	if (!PRESETn)
	SPIRxData <= 0;
	else if (RxWrite)
	SPIRxData <= RxData; 
end

reg RNE;
reg	NextRNE;
always @(RNE or RxWrite or RxFRdPtrInc)
begin
	NextRNE = RNE;
	if (RxFRdPtrInc)
	NextRNE = 1'b0;
	else if (RxWrite)
	NextRNE = 1'b1;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	RNE <= 1'b0;
	else 
	RNE <= NextRNE;
end

reg RORRIS;
reg	NextRORRIS;
always @(RORIC or RORRIS or RNE or RxWrite)
begin
	NextRORRIS = RORRIS;
	if (RNE & RxWrite)
	NextRORRIS = 1'b1;
	else if (RORIC)
	NextRORRIS = 1'b0;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	RORRIS <= 0;
	else
	RORRIS <= NextRORRIS;
end

assign RxFRdData = SPIRxData;

endmodule

