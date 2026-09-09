// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : pmcon_Top.v
// File Revision    : 0.1 
//  -----------------------------------------------------------------------------
//  Purpose         : Pseudo SRAM controller Top module
//  =============================================================================

`timescale 1ns/1ps
module pmcon_APBIF
(
	//------------------------------
	// AMBA3APB for momory access
	//------------------------------
	M_PCLK		,
	PRESETn	,
	M_PSEL		,
	M_PENABLE	,
	M_PREADY	,
	
	M_PWSTRB	,
	M_PWRITE	,
	M_PADDR		,
	M_PWDATA	,
	M_PRDATA	,

	//-----------------------------------
	// APB Interface for Register setting
	//-----------------------------------
	R_PCLK		,
	R_PSEL		,
	R_PENABLE	,
	
	R_PWRITE	,
	R_PADDR		,
	R_PWDATA	,
	R_PRDATA	,


	//----------- PSRAM
	CSb		,
	ZZb		,
	OEb		,
	WEb		,
	UBb		,
	LBb		,
	
	ADDR		,
	DATAIN		,
	nDATAEN		,
	DATAOUT

);

parameter ADDRESSWIDTH = 18;
input		M_PCLK	;
input		PRESETn;
input		M_PSEL	;
input		M_PENABLE;
output		M_PREADY;
input		M_PWRITE;

input	[3:0]	M_PWSTRB;
input	[ADDRESSWIDTH:0]	M_PADDR	;
input	[31:0]	M_PWDATA;
output	[31:0]	M_PRDATA;


input		R_PCLK	;
input		R_PSEL	;
input		R_PENABLE;
input		R_PWRITE;
input	[1:0]	R_PADDR	;
input	[31:0]	R_PWDATA;
output	[31:0]	R_PRDATA;


output		CSb;
output		ZZb;
output		OEb;
output		WEb;
output		UBb;
output		LBb;
output	[ADDRESSWIDTH-1:0]	ADDR;
input	[15:0]	DATAIN;
output		nDATAEN;
output	[15:0]	DATAOUT;

wire	[31:0] 	PSRAMRDATA;
//wire	[31:0] 	PSRAMWDATA;
wire	[2:0]	PageSize ; 
wire	[31:0]	PSRAMTCON;
wire	[10:0]	PSRAMTOUT;


pmcon_MEMIF pmcon_MEMIF
	(		
		.PSEL		(M_PSEL	),
		.PENABLE	(M_PENABLE),
		.PREADY		(M_PREADY),
		.PWRITE		(M_PWRITE),
		.PRDATA		(M_PRDATA ),
		//---------
		.DataRWAvail	(DataRWAvail),
		.Read		(Read),
		.Write		(Write),
		.PSRAMRDATA	(PSRAMRDATA)
	);


pmcon_REGIF  pmcon_REGIF
	(
		.PCLK		(R_PCLK	  ),
		.PRESETn	(PRESETn  ),
		.PSEL		(R_PSEL	  ),
		.PENABLE	(R_PENABLE),
		.PWRITE		(R_PWRITE ),
		.PADDR		(R_PADDR  ),
		.PWDATA		(R_PWDATA ),	
		.PRDATA		(R_PRDATA ),
		// register setting output signal
		.Enable		(Enable	  ),
		.PowerupSet	(PowerupSet),
		.PowerupClr	(PowerupClr),
		.PageSize	(PageSize ),
		.NegCatch	(NegCatch),
		.BurstRMode	(BurstRMode),
		.PSRAMTCON	(PSRAMTCON),
		.PSRAMTOUT	(PSRAMTOUT)
	);

pmcon_STM  #(ADDRESSWIDTH)
pmcon_STM
	(
		.PCLK        	(M_PCLK	   ),
		.PRESETn     	(PRESETn ),
		.PSEL			(M_PSEL),
		.PENABLE		(M_PENABLE),
		.PWDATA      	(M_PWDATA  ),
		.PWSTRB			(M_PWSTRB),
		.PADDR       	(M_PADDR   ),
		.Read        	(Read	   ),
		.Write       	(Write	   ),
		.PSRAMRDATA  	(PSRAMRDATA),
		.Enable      	(Enable	   ), 	// register setting value
		.PowerupSet  	(PowerupSet), 	// register setting value
		.PowerupClr  	(PowerupClr), 	// register setting value
		.PageSize    	(PageSize  ), 	// register setting value
		.BurstRMode  	(BurstRMode), 	// register setting value
		.NegCatch		(NegCatch),
		.PSRAMTCON		(PSRAMTCON ),
		.PSRAMTOUT		(PSRAMTOUT ),

        .DataRWAvail  	(DataRWAvail), // APB memory interface for PREADY signal gen

            //---PSRAM_SIGNAL
        .CSb         	(CSb	),
        .ZZb         	(ZZb	),
        .OEb         	(OEb	),
        .WEb         	(WEb	),
        .UBb         	(UBb	),
        .LBb         	(LBb	),

        .ADDR        	(ADDR	),
        .DATAIN      	(DATAIN	),
        .nDATAEN     	(nDATAEN),
        .DATAOUT		(DATAOUT)
	);

endmodule
