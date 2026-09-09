// This module is PSRAM controller Setting Register Interface module.

`timescale 1ns/1ps

`define PSRAMCONAddr       	2'b00
`define PSRAMTCONAddr		2'b01
`define PSRAMTOUTAddr		2'b10


module pmcon_REGIF (
		PCLK,
		PRESETn,
		PSEL,
		PENABLE,
		PWRITE,
		PADDR,
		PWDATA,	
		PRDATA,

		Enable,
		PowerupSet,
		PowerupClr,
		PageSize,
		BurstRMode,
		NegCatch,
		PSRAMTCON,		
		PSRAMTOUT		
	);


input 			PCLK	;
input 			PRESETn	;
input 			PSEL	;
input 			PENABLE	;
input 			PWRITE	;
input 	[1:0]	PADDR	;
input 	[31:0]	PWDATA	;
output	[31:0]	PRDATA	;

output		Enable		; // Enable Bit output
output		PowerupSet	;
output		PowerupClr	;
output	[2:0]	PageSize	;
output		BurstRMode	;
output		NegCatch	;
output	[31:0]	PSRAMTCON	;
output	[10:0]	PSRAMTOUT	;

wire	PSRAMCON_w;
wire	PSRAMTCON_w;
wire	PSRAMTOUT_w;
wire	NextPSRAMCON_r;
wire	NextPSRAMTCON_r;
wire	NextPSRAMTOUT_r;

assign	PSRAMCON_w	= (PSEL&PENABLE&PWRITE)&(PADDR==`PSRAMCONAddr);
assign	PSRAMTCON_w 	= (PSEL&PENABLE&PWRITE)&(PADDR==`PSRAMTCONAddr); 
assign	PSRAMTOUT_w 	= (PSEL&PENABLE&PWRITE)&(PADDR==`PSRAMTOUTAddr); 
assign	NextPSRAMCON_r 	= (PSEL&~PENABLE&~PWRITE)&(PADDR==`PSRAMCONAddr);
assign	NextPSRAMTCON_r	= (PSEL&~PENABLE&~PWRITE)&(PADDR==`PSRAMTCONAddr);
assign	NextPSRAMTOUT_r	= (PSEL&~PENABLE&~PWRITE)&(PADDR==`PSRAMTOUTAddr);

reg			Enable;
reg	[2:0]	PageSize; 
reg			BurstRMode;
reg			NegCatch;
reg			PowerupSet;
reg			PowerupClr;

reg [31:0] 	PSRAMTCON;
reg [10:0] 	PSRAMTOUT;

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	Enable   <= 1'b0;
	BurstRMode <= 1'b0;
	PageSize <= 0;
	NegCatch <= 0;
	end
	else if (PSRAMCON_w)
	begin
	Enable <= PWDATA[0];
	BurstRMode <= PWDATA[2];
	PageSize <= PWDATA[5:3];
	NegCatch <= PWDATA[6];
	end
end


wire	nextPowerupSet;
wire	nextPowerupClr;
assign nextPowerupSet = PSRAMCON_w & PWDATA[1];
assign nextPowerupClr = PSRAMCON_w & ~PWDATA[1];

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	PowerupSet = 0;
	PowerupClr = 0;
	end
	else
	begin
	PowerupSet = nextPowerupSet;
	PowerupClr = nextPowerupClr;	
	end
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	PSRAMTCON <= 32'hffffffff;
	else if (PSRAMTCON_w)
	PSRAMTCON <= PWDATA[31:0];
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	PSRAMTOUT <= 11'b11111111111;
	else if (PSRAMTOUT_w)
	PSRAMTOUT <= PWDATA[10:0];
end

// PSRAM Setting Register Read
reg	[31:0] NextPRDATA;
reg	[31:0] PRDATA;

always @(NextPSRAMCON_r or NextPSRAMTCON_r or NextPSRAMTOUT_r or PRDATA or NegCatch or 
	PageSize or BurstRMode or Enable or PSRAMTCON or PSRAMTOUT)
begin
	NextPRDATA <= PRDATA;
	case(1'b1) // synopsys parallel_case full_case
		NextPSRAMCON_r 	: NextPRDATA <= {25'd0 ,NegCatch,PageSize, BurstRMode,1'b0 ,Enable};
		NextPSRAMTCON_r : NextPRDATA <= {PSRAMTCON};
		NextPSRAMTOUT_r : NextPRDATA <= {PSRAMTOUT};
	default : NextPRDATA <= 32'd0;
	endcase
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		PRDATA <= 32'd0;
	else
		PRDATA <= NextPRDATA;
end

endmodule
