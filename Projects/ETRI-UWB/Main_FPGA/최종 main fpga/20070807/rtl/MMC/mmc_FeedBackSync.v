`timescale 1ns/1ps
module mmc_FeedBackSync (
		nRst,
		SDreset,
		MMC_FBCLK, 
		MMC_CMDIN,
		MMC_DATIN,
		CMDIN,
		DATIN
		);

input			nRst;
input			SDreset;
input			MMC_FBCLK; // FeedBack clock
input			MMC_CMDIN;
input	[7:0]	MMC_DATIN;
output			CMDIN;
output	[7:0]	DATIN;

reg				CMDIN;
reg	[7:0]		DATIN;

always @(posedge MMC_FBCLK or negedge nRst)
begin
	if (!nRst)
		begin
		CMDIN 		<= 1'b1;
		DATIN 		<= 8'b11111111;
		end
	else
	begin
		if (SDreset)
			begin
			CMDIN 		<= 1'b1;
			DATIN 		<= 8'b11111111;
			end
		else
			begin
			CMDIN 		<= MMC_CMDIN;
			DATIN 		<= MMC_DATIN;
			end
	end
end


endmodule
