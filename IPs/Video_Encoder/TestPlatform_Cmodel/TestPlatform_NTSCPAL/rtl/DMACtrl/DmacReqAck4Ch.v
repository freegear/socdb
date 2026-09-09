// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacReqAck4Ch.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : DMA Controler Request/Acknowledge processing(4 Channel)
//                     : 4 Channel DMA Request Arbiter.
//  =============================================================================
`timescale 1ns/1ps

module DmacReqAck4Ch (
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

input  [3:0] DMAReq;
output [3:0] DMAAck;
output       Start;
input        Ready;
output [3:0] Active;
input  [3:0] Memory2Memory;
input  [3:0] Enabled;

wire         Start;
reg    [3:0] Active;
reg    [3:0] nextActive;

wire   [3:0] DMAReqInternal;
assign DMAReqInternal = Enabled&(DMAReq|Memory2Memory);

reg    [1:0] RoundRobinState;
reg    [1:0] nextRoundRobinState;

always @(RoundRobinState or DMAReqInternal or Active)
begin
	nextRoundRobinState = RoundRobinState;
	nextActive = Active;
	case(RoundRobinState)
	2'b00:
	if(DMAReqInternal[0])	// highest priority
		begin
			nextActive = 4'b0001;
			nextRoundRobinState = 2'b01;
		end
		else if(DMAReqInternal[1])
		begin
			nextActive = 4'b0010;
			nextRoundRobinState = 2'b01;
		end
		else if(DMAReqInternal[2])
		begin
			nextActive = 4'b0100;
			nextRoundRobinState = 2'b01;
		end
		else if(DMAReqInternal[3])	// lowest priority
		begin
			nextActive = 4'b1000;
			nextRoundRobinState = 2'b01;
		end
		else
			nextActive = 4'b0000;
	2'b01:
		if(DMAReqInternal[1])	// highest priority
		begin
			nextActive = 4'b0010;
			nextRoundRobinState = 2'b10;
		end
		else if(DMAReqInternal[2])
		begin
			nextActive = 4'b0100;
			nextRoundRobinState = 2'b10;
		end
		else if(DMAReqInternal[3])
		begin
			nextActive = 4'b1000;
			nextRoundRobinState = 2'b10;
		end
		else if(DMAReqInternal[0])	// lowest priority
		begin
			nextActive = 4'b0001;
			nextRoundRobinState = 2'b10;
		end
		else
			nextActive = 4'b0000;
	2'b10:
		if(DMAReqInternal[2])	// highest priority
		begin
			nextActive = 4'b0100;
			nextRoundRobinState = 2'b11;
		end
		else if(DMAReqInternal[3])
		begin
			nextActive = 4'b1000;
			nextRoundRobinState = 2'b11;
		end
		else if(DMAReqInternal[0])
		begin
			nextActive = 4'b0001;
			nextRoundRobinState = 2'b11;
		end
		else if(DMAReqInternal[1])	// lowest priority
		begin
			nextActive = 4'b0010;
			nextRoundRobinState = 2'b11;
		end
		else
			nextActive = 4'b0000;
	2'b11:
		if(DMAReqInternal[3])	// highest priority
		begin
			nextActive = 4'b1000;
			nextRoundRobinState = 2'b00;
		end
		else if(DMAReqInternal[0])
		begin
			nextActive = 4'b0001;
			nextRoundRobinState = 2'b00;
		end
		else if(DMAReqInternal[1])
		begin
			nextActive = 4'b0010;
			nextRoundRobinState = 2'b00;
		end
		else if(DMAReqInternal[2])	// lowest priority
		begin
			nextActive = 4'b0100;
			nextRoundRobinState = 2'b00;
		end
		else
			nextActive = 4'b0000;
	endcase
end
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		Active <= 4'b0000;
		RoundRobinState <= 2'b00;
	end
	else
	begin
		if(Ready)
		begin
			Active <= nextActive;
			RoundRobinState <= nextRoundRobinState;
/*
			case(RoundRobinState)
			2'b00:
				if(DMAReqInternal[0])	// highest priority
				begin
					Active <= 4'b0001;
					RoundRobinState <= 2'b01;
				end
				else if(DMAReqInternal[1])
				begin
					Active <= 4'b0010;
					RoundRobinState <= 2'b01;
				end
				else if(DMAReqInternal[2])
				begin
					Active <= 4'b0100;
					RoundRobinState <= 2'b01;
				end
				else if(DMAReqInternal[3])	// lowest priority
				begin
					Active <= 4'b1000;
					RoundRobinState <= 2'b01;
				end
				else
					Active <= 4'b0000;
			2'b01:
				if(DMAReqInternal[1])	// highest priority
				begin
					Active <= 4'b0010;
					RoundRobinState <= 2'b10;
				end
				else if(DMAReqInternal[2])
				begin
					Active <= 4'b0100;
					RoundRobinState <= 2'b10;
				end
				else if(DMAReqInternal[3])
				begin
					Active <= 4'b1000;
					RoundRobinState <= 2'b10;
				end
				else if(DMAReqInternal[0])	// lowest priority
				begin
					Active <= 4'b0001;
					RoundRobinState <= 2'b10;
				end
				else
					Active <= 4'b0000;
			2'b10:
				if(DMAReqInternal[2])	// highest priority
				begin
					Active <= 4'b0100;
					RoundRobinState <= 2'b11;
				end
				else if(DMAReqInternal[3])
				begin
					Active <= 4'b1000;
					RoundRobinState <= 2'b11;
				end
				else if(DMAReqInternal[0])
				begin
					Active <= 4'b0001;
					RoundRobinState <= 2'b11;
				end
				else if(DMAReqInternal[1])	// lowest priority
				begin
					Active <= 4'b0010;
					RoundRobinState <= 2'b11;
				end
				else
					Active <= 4'b0000;
			2'b11:
				if(DMAReqInternal[3])	// highest priority
				begin
					Active <= 4'b1000;
					RoundRobinState <= 2'b00;
				end
				else if(DMAReqInternal[0])
				begin
					Active <= 4'b0001;
					RoundRobinState <= 2'b00;
				end
				else if(DMAReqInternal[1])
				begin
					Active <= 4'b0010;
					RoundRobinState <= 2'b00;
				end
				else if(DMAReqInternal[2])	// lowest priority
				begin
					Active <= 4'b0100;
					RoundRobinState <= 2'b00;
				end
				else
					Active <= 4'b0000;
			endcase
*/
		end
	end
end

assign Start  = (|(nextActive[3:0] & Enabled[3:0]));	// And with Enabled for elimination error interrupt
wire [3:0] nReady4;
assign nReady4 = {~Ready, ~Ready, ~Ready, ~Ready};
assign DMAAck = nReady4&Active[3:0];

endmodule
