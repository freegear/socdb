// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacReqAck2Ch.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Request/Acknowledge processing(2 Channel)
//                     : 2 Channel DMA Request Arbiter.
//  =============================================================================
`timescale 1ns/1ps

module DmacReqAck2Ch (
	ACLK,
	ARESETn,

	DMAReq,		// DMA Request from peripheral
	DMAAck,		// DMA Ack to peripheral
	Start,		// Start signal to DMA Engine
	Ready,		// Ready signal from DMA Engine
	Active,		// Active signal to Register FILE
	Memory2Memory,	// M2M signal form Register FILE
	Enabled		// Enabled signal from Register FILE
);

input        ACLK;
input        ARESETn;

input  [1:0] DMAReq;
output [1:0] DMAAck;
output       Start;
input        Ready;
output [1:0] Active;
input  [1:0] Memory2Memory;
input  [1:0] Enabled;

wire         Start;
reg    [1:0] Active;
reg    [1:0] nextActive;

wire   [1:0] DMAReqInternal;
assign DMAReqInternal = Enabled&(DMAReq|Memory2Memory);

reg          RoundRobinState;
reg          nextRoundRobinState;

always @(RoundRobinState or DMAReqInternal or Active)
begin
	nextRoundRobinState = RoundRobinState;
	nextActive = Active;
	if(RoundRobinState == 0)
	begin
		if(DMAReqInternal[0])	// highest priority
		begin
			nextActive = 2'b01;
			nextRoundRobinState = 1;
		end
		else if(DMAReqInternal[1])
		begin
			nextActive = 2'b10;
			nextRoundRobinState = 1;
		end
		else
			nextActive = 2'b00;
	end
	else
	begin
		if(DMAReqInternal[1])	// highest priority
		begin
			nextActive = 2'b10;
			nextRoundRobinState = 0;
		end
		else if(DMAReqInternal[0])
		begin
			nextActive = 2'b01;
			nextRoundRobinState = 0;
		end
		else
			nextActive = 2'b00;
	end
end

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		Active <= 2'b00;
		RoundRobinState <= 0;
	end
	else
	begin
		if(Ready)
		begin
			RoundRobinState <= nextRoundRobinState;
			Active <= nextActive;
/*
			if(RoundRobinState == 0)
			begin
				if(DMAReqInternal[0])	// highest priority
				begin
					Active <= 2'b01;
					RoundRobinState <= 1;
				end
				else if(DMAReqInternal[1])
				begin
					Active <= 2'b10;
					RoundRobinState <= 1;
				end
				else
					Active <= 2'b00;
			end
			else
			begin
				if(DMAReqInternal[1])	// highest priority
				begin
					Active <= 2'b10;
					RoundRobinState <= 0;
				end
				else if(DMAReqInternal[0])
				begin
					Active <= 2'b01;
					RoundRobinState <= 0;
				end
				else
					Active <= 2'b00;
			end
*/
		end
	end
end

assign Start  = (|(nextActive[1:0] & Enabled[1:0]));	// And with Enabled for elimination error interrupt
wire [1:0] nReady2;
assign nReady2 = {~Ready, ~Ready};
assign DMAAck = nReady2&Active[1:0];

endmodule
