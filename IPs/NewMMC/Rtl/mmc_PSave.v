// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : mmc_PSave.v
// File Revision       : Ver 3.0 - CT2000 (TSMC)
// Revision History    : 
// 
//  ----------------------------------------------------------------
// Description         : mmc Power Save clock control 
//  ----------------------------------------------------------------
`timescale 1ns/1ps

module mmc_PSave(
	PCLK,
	PRESETn,
	CKPulse,	 	// Prescaled Clock
	CMST,			// Command Start Signal
	ENCLK_REG, 		// User Clock Enable Signal
	ENCLK_FIFO, 	// FIFO protection Clock Enable Signal
	CmdCtrlIdle,	// Present Command state
	BusyChkIdle,
	DatCtrlIdle,	// Present Data state
	PSAVEON		,	// Power Save Mode on 
	ENCLK
);

//Command and Data Tranfer completion -> after 8 MMC_clk -> Clock Down
input 		PCLK;
input 		PRESETn;
input 		CKPulse;
input		CMST;

input 		ENCLK_REG;
input 		ENCLK_FIFO;

input 		CmdCtrlIdle;
input		BusyChkIdle;
input 		DatCtrlIdle;
input		PSAVEON;

output 		ENCLK;

reg [3:0]	PulseCnt; // Eight pulse counter
//reg			PulseCnt; // Eight pulse counter
wire		ENCLK_CNT;
wire		ENCLK_BUSY;
wire		ENCLK;

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	PulseCnt <= 0;	
	else if (CMST)
	PulseCnt <= 0;	
	else if (CmdCtrlIdle & DatCtrlIdle& BusyChkIdle& CKPulse) // state idle & 
	PulseCnt <= PulseCnt+1;
//	PulseCnt <= 1;
	else if (ENCLK_CNT)
	PulseCnt <= PulseCnt;
end

assign ENCLK_CNT = (PulseCnt == 4'b1000)&PSAVEON;
//assign ENCLK_CNT = (PulseCnt)&PSAVEON;

assign ENCLK = (ENCLK_REG)&(ENCLK_FIFO)&(~ENCLK_CNT);

endmodule
