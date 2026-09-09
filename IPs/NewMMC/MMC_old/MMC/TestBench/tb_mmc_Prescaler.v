`timescale 1ns/10ps
module tb_mmc_Prescaler ;

reg 	nRst;
reg 	Clk;
reg [7:0] SDIPRE;
reg	ENCLK;
wire	MCLK;
wire	DIVLeverCo;


initial 
begin
	Clk <= 1'b0;
	nRst <= 1'b0 ;
	SDIPRE <= 8'h01;
	ENCLK <= 1'b1;
	#50 nRst <= 1'b1;
	#1000
	SDIPRE <= 8'h02;
	#100
	ENCLK <= 1'b0;
	#50
	ENCLK <= 1'b1;
	#1000
	SDIPRE <= 8'h10;
	



end

always #5 Clk <= ~Clk ;

mmc_Prescaler Prescaler(
	.nRst(nRst),
	.Clk(Clk),
	.SDIPRE(SDIPRE),
	.ENCLK(ENCLK),
// Outputs
	.MMCICLK(MCLK),
        .DIVlevelCo(DIVlevelCo)
                     );



endmodule
