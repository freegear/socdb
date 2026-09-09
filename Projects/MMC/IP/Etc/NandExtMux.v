module NandExtMux
	(
	NandMode,

	NFDataIn0,
	NFDataOut0,
	NFDataOutEn0,

	NFDataIn1,
	NFDataOut1,
	NFDataOutEn1,

	pNFDataIn,
	pNFDataOut,
	pNFDataOutEn
);

input	NandMode;

output	[15:0]	NFDataIn0;
input	[15:0]	NFDataOut0;
input			NFDataOutEn0;

output	[7:0]	NFDataIn1;
input	[7:0]	NFDataOut1;
input			NFDataOutEn1;


input	[15:0]	pNFDataIn;
output	[15:0]	pNFDataOut;
output	[1:0]	pNFDataOutEn;


// Nand Mode 0 is  8 bit interface 2 controller
// Nand Mode 1 is  16 bit interface 1 controller (NandCon0)

assign NFDataIn0 = (NandMode)? pNFDataIn :({8'd0,pNFDataIn[7:0]}) ;
assign NFDataIn1 = (NandMode)? 8'd0 :pNFDataIn[15:8] ;

assign pNFDataOut = (NandMode)? NFDataOut0: ({NFDataOut1[7:0],NFDataOut0[7:0]});
assign pNFDataOutEn = (NandMode)?({NFDataOutEn0,NFDataOutEn0}):({NFDataOutEn1,NFDataOutEn0});


endmodule
