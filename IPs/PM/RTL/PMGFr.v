
`timescale 1ns/10ps

module PMGFr (
//			TestMode,
//			TestClk,
			i_HCLK,
			i_LCLK,
			i_RSTB,
			i_SEL,
			o_CLK
);

//input		TestMode;
//input		TestClk;
input		i_HCLK;
input		i_LCLK;
input		i_RSTB;
input		i_SEL;
output		o_CLK;

reg	FS_EN0, FS_EN1, FS_SEL;
reg	o_CLK;
wire [1:0] fsel;

//wire HCLK = TestMode ? TestClk : i_HCLK;
//wire LCLK = TestMode ? TestClk : i_LCLK;
wire HCLK = i_HCLK;
wire LCLK = i_LCLK;

always @(posedge HCLK or negedge i_RSTB)
  	if(!i_RSTB)	FS_EN0 <= 1'b0;
  	else		FS_EN0 <= ~(i_SEL | FS_SEL);

always @(posedge LCLK or negedge i_RSTB)
  	if(!i_RSTB)	FS_EN1 <= 1'b1;
  	else		FS_EN1 <= (i_SEL & ~FS_EN0);

always @(posedge HCLK or negedge i_RSTB)
  	if(!i_RSTB)	FS_SEL <= 1'b0;
  	else		FS_SEL <= FS_EN1;

assign	fsel = {FS_EN1, FS_EN0};

always @(HCLK or LCLK or fsel)
	case(fsel) // synopsys parallel_case
	  2'b01   : o_CLK = HCLK;
	  2'b10   : o_CLK = LCLK;
	  default : o_CLK = 1'b1;
	endcase

endmodule
