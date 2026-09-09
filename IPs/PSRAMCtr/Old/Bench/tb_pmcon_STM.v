`timescale 1ns/1ps


module tb_pmcon_STM;


reg				PCLK;
reg 			PRESETn;
reg		[31:0]	PWDATA;
reg		[31:0]	PADDR;
reg				Read;
reg				Write;
wire	[31:0]	PSRAMRDATA;
reg		[31:0]	PSRAMWDATA;
reg				Enable;
reg				PowerupSet;
reg				PowerupClr;
reg 	[2:0] 	PageSize;
reg				BurstRMode;
wire			DataRWAvail;
//---------------psram    
wire			CSb;
wire			ZZb;
wire			OEb;
wire			WEb;
wire			UBb;
wire			LBb;

wire	[20:0]	ADDR;
//reg		[15:0]	DATAIN;
wire			nDATAEN;
wire	[15:0]	DATAOUT;

pmcon_STM 	psram_state(
                      	.PCLK			(PCLK		),
                       	.PRESETn		(PRESETn	),
                        .PWDATA			(PWDATA		),
                        .PADDR			(PADDR		),
                        .Read			(Read		),
                        .Write			(Write		),
                        .PSRAMRDATA		(PSRAMRDATA	),
                        .Enable			(Enable		),
                        .PowerupSet		(PowerupSet	),
                        .PowerupClr		(PowerupClr	),
                        .PageSize		(PageSize	),
                        .BurstRMode		(BurstRMode	),
						.DataRAvail		(DataRWAvail),
                //---------------------psram    
                        .CSb			(CSb		),
                        .ZZb			(ZZb		),
                        .OEb			(OEb		),
                        .WEb			(WEb		),
                        .UBb			(UBb		),
                        .LBb			(LBb		),
        
                        .ADDR			(ADDR		),
                        .DATAIN			(DATAIN		),
                        .nDATAEN		(nDATAEN	),
                        .DATAOUT		(DATAOUT	)
                        );

tri 	[15:0]	DATA;
wire	[15:0]	DATAIN;
assign 	DATAIN = DATA;
assign	DATA = nDATAEN ? 16'bzzzzzzzzzzzzzzzz :DATAOUT;

psram32m	PSRAM32 (	
			.Dq	(DATA),
			.Addr	(ADDR), 
			.Ce_n	(CSb), 
			.We_n	(WEb), 
			.Oe_n	(OEb),
			.Lb_n	(LBb), 
			.Ub_n	(UBb), 
			.Zz_n	(ZZb)
		); 






initial
begin
			PRESETn 	= 0;
			PCLK 		= 0;
			PWDATA		= 0;
			PADDR		= 0;
			Enable  	= 0;
			Read 		= 0;
			Write 		= 0;
			PowerupSet 	= 0;
			PowerupClr 	= 0;
			BurstRMode 	= 0;
			PageSize	= 0;
	#50 	PRESETn 	= 1;
end

always
begin
	#5 PCLK = ~PCLK;
end

initial
begin
	#100 	Enable 		= 1;
			PowerupSet	= 1;
	
	# 10 	PowerupSet 	= 0;
	# 100000 PowerupClr	= 1;
	# 10	PowerupClr 	= 0;
			BurstRMode 	= 1;

	#5000	Write		= 1;
			PWDATA		= 32'h11110010;
			PADDR		= 4;
	#10		Write		= 0;

	#5000	Write		= 1;
			PWDATA		= 32'h11110010;
			PADDR		= 6;
	#10		Write		= 0;

	#5000	Write		= 1;
			PWDATA		= 32'h11110010;
			PADDR		= 8;
	#10		Write		= 0;


	#5000	Write		= 1;
			PWDATA		= 32'h11110010;
			PADDR		= 12;
	#10		Write		= 0;

	#5000	Write		= 1;
			PWDATA		= 32'h11110010;
			PADDR		= 16;
	#10		Write		= 0;

	#5000	Write		= 1;
			PWDATA		= 32'h11110010;
			PADDR		= 20;
	#10		Write		= 0;

	#5000	Read		= 1;
			PADDR		= 4;
	# 10	Read		= 0;

	#5000	Read		= 1;
			PADDR		= 6;
	# 10	Read		= 0;


	#5000	Read		= 1;
			PADDR		= 8;
	# 10	Read		= 0;



	#5000	Read		= 1;
			PADDR		= 12;
	# 10	Read		= 0;
	#5000	Read		= 1;
			PADDR		= 16;
	# 10	Read		= 0;

	#5000	Read		= 1;
			PADDR		= 20;
	# 10	Read		= 0;
end

endmodule
