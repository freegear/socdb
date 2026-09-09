`timescale 1ns/1ps
module mmc_FeedBackSync (
		nRst,
		SDreset,
		MMC_FBCLK, 
		MMC_CMDIN,
		MMC_DATIN,
		CMDOUT,
		DATOUT,
		nCMDEN,
		nDATEN,
		MMC_CMDOUT,
		MMC_DATOUT,
		CMDIN,
		DATIN,
		MMC_nCMDEN,
		MMC_nDATEN
		);

input		nRst;
input		SDreset;
input		MMC_FBCLK; // FeedBack clock
input		MMC_CMDIN;
input	[7:0]	MMC_DATIN;
input		CMDOUT;
input	[7:0]	DATOUT;
input		nCMDEN;
input		nDATEN;
output		MMC_CMDOUT;
output	[7:0]	MMC_DATOUT;
output		CMDIN;
output	[7:0]	DATIN;
output		MMC_nCMDEN;
output		MMC_nDATEN;

reg		CMDIN;
reg	[7:0]	DATIN;
//reg		MMC_nCMDEN;
//reg		MMC_nDATEN;

assign		MMC_CMDOUT = CMDOUT;
assign		MMC_DATOUT = DATOUT;
assign		MMC_nCMDEN = nCMDEN;
assign		MMC_nDATEN = nDATEN;


always @(posedge MMC_FBCLK or negedge nRst)
begin
	if (!nRst)
		begin
		CMDIN 		<= 1'b1;
		DATIN 		<= 8'b11111111;
//		MMC_nCMDEN 	<= 1'b1;
//		MMC_nDATEN 	<= 1'b1;
		end
	else
	begin
		if (SDreset)
		begin
		CMDIN 		<= 1'b1;
		DATIN 		<= 8'b11111111;
		//MMC_nCMDEN 	<= 1'b1;
		//MMC_nDATEN 	<= 1'b1;
		end
		else
		begin
		CMDIN 		<= MMC_CMDIN;
		DATIN 		<= MMC_DATIN;
//		MMC_nCMDEN 	<= nCMDEN;
//		MMC_nDATEN 	<= nDATEN;
		end
	end
end


endmodule
