// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacReqAck1Ch.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Request/Acknowledge processing(1 Channel)
//  =============================================================================
`timescale 1ns/1ps

module DmacReqAck1Ch (
	ACLK,
	ARESETn,

	DMAReq,
	DMAAck,
	Start,
	Ready,
	Active,
	Memory2Memory,
	Enabled
);

input  ACLK;
input  ARESETn;

input  DMAReq;
output DMAAck;
output Start;
input  Ready;
output Active;
input  Memory2Memory;
input  Enabled;

wire   DMAReqInternal;
assign DMAReqInternal = Enabled & (DMAReq | Memory2Memory);

reg    Active;

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
		Active <= 0;
	else if(Ready)
	begin
		if(DMAReqInternal)
			Active <= 1;
		else
			Active <= 0;
	end
end

assign Start  = DMAReqInternal & Enabled;
assign DMAAck = (~Ready)&Active;

endmodule
