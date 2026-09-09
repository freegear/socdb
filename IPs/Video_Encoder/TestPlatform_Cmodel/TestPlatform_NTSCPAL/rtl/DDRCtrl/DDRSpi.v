// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : BurstSplitter.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Burst Transfer Splitter for DDR Controller.
//                     : Current DDR Controller supports only subset of AXI.
//                     : It cannot receive Burst Transfer more than length 4.
//                     : With this module, DDR Controller support all AXI.
//  Important Note     : This module doesn't support FIXED burst !!!
//  =============================================================================

`timescale 1ns/1ps

module DDRSpi 
(
//	AXI Interface
		ACLK     , 
		ARESETn  , 
		// Write Address Channel
		AWID_M,
		AWADDR_M ,
		AWLEN_M  ,
//		AWSIZE_M ,
		AWBURST_M,
		AWVALID_M,
		AWREADY_M,

		// Write Data Channel
		WID_M,
		WDATA_M  ,
		WSTRB_M  ,
		WLAST_M  ,
		WVALID_M ,
		WREADY_M ,

		// Write Response Channel
		BID_M,
		BRESP_M  ,
		BVALID_M ,
		BREADY_M ,

		// Read Address Channel
		ARID_M,
		ARADDR_M ,
		ARLEN_M  ,
//		ARSIZE_M ,
		ARBURST_M,
		ARVALID_M,
		ARREADY_M,

		// Read Data Channel
		RID_M,
		RDATA_M  ,
		RRESP_M  ,
		RLAST_M  ,
		RVALID_M ,
		RREADY_M ,

		AWID_S,
		AWADDR_S ,
		AWLEN_S  ,
//		AWSIZE_S ,
		AWBURST_S,
		AWVALID_S,
		AWREADY_S,

		// Write Data Channel
		WID_S,
		WDATA_S  ,
		WSTRB_S  ,
		WLAST_S  ,
		WVALID_S ,
		WREADY_S ,

		// Write Response Channel
		BID_S,
		BRESP_S  ,
		BVALID_S ,
		BREADY_S ,

		// Read Address Channel
		ARID_S,
		ARADDR_S ,
		ARLEN_S  ,
//		ARSIZE_S ,
		ARBURST_S,
		ARVALID_S,
		ARREADY_S,

		// Read Data Channel
		RID_S,
		RDATA_S  ,
		RRESP_S  ,
		RLAST_S  ,
		RVALID_S ,
		RREADY_S
);

parameter RID_WIDTH = 4;
parameter WID_WIDTH = 4;

`define RESP_OKAY	2'b00

`define BURST_FIXED 2'b00
`define BURST_INCR  2'b01
`define BURST_WRAP  2'b10

//
// input/output port
//
input  ACLK;
input  ARESETn;

input  [WID_WIDTH-1:0]  AWID_M;
input  [31:0]           AWADDR_M;
input  [3:0]            AWLEN_M;
//input  [2:0]            AWSIZE_M;
input  [1:0]            AWBURST_M;
input                   AWVALID_M;
output                  AWREADY_M;

input  [WID_WIDTH-1:0]  WID_M;
input  [31:0]           WDATA_M;
input  [3:0]            WSTRB_M;
input                   WLAST_M;
input                   WVALID_M;
output                  WREADY_M;

output [WID_WIDTH-1:0]  BID_M;
output [1:0]            BRESP_M;
output                  BVALID_M;
input                   BREADY_M;

input  [RID_WIDTH-1:0]  ARID_M;
input  [31:0]           ARADDR_M;
input  [3:0]            ARLEN_M;
//input  [2:0]            ARSIZE_M;
input  [1:0]            ARBURST_M;
input                   ARVALID_M;
output                  ARREADY_M;

output [RID_WIDTH-1:0]  RID_M;
output [31:0]           RDATA_M;
output [1:0]            RRESP_M;
output                  RLAST_M;
output                  RVALID_M;
input                   RREADY_M;

output [WID_WIDTH-1:0]  AWID_S;
output [31:0]           AWADDR_S;
output [3:0]            AWLEN_S;
//output [2:0]            AWSIZE_S;
output [1:0]            AWBURST_S;
output                  AWVALID_S;
input                   AWREADY_S;

output [WID_WIDTH-1:0]  WID_S;
output [31:0]           WDATA_S;
output [3:0]            WSTRB_S;
output                  WLAST_S;
output                  WVALID_S;
input                   WREADY_S;

input  [WID_WIDTH-1:0]  BID_S;
input  [1:0]            BRESP_S;
input                   BVALID_S;
output                  BREADY_S;

output [RID_WIDTH-1:0]  ARID_S;
output [31:0]           ARADDR_S;
output [3:0]            ARLEN_S;
//output [2:0]            ARSIZE_S;
output [1:0]            ARBURST_S;
output                  ARVALID_S;
input                   ARREADY_S;

input  [RID_WIDTH-1:0]  RID_S;
input  [31:0]           RDATA_S;
input  [1:0]            RRESP_S;
input                   RLAST_S;
input                   RVALID_S;
output                  RREADY_S;

//
// Connection Method :
//    AXI Master(BUS) should be connected signals with suffix _M.
//    DDR Controller should be connected signals with suffix _S.
//


//
// Read Processing
//

// Read Que : stores ARLEN for RLAST generation
// 2 control signals : RQ_Enque(store ARLEN)
//                     RQ_SubOne(Subtract 1 form first qued ARLEN, if ARLEN == 0, deque it)
// Implemented with shift registers.
reg  [3:0] RQ_WriteIndex;
reg  [3:0] ARLEN_Q_0;
reg  [3:0] ARLEN_Q_1;
reg  [3:0] ARLEN_Q_2;
reg  [3:0] ARLEN_Q_3;
reg  [3:0] ARLEN_Q_4;
reg  [3:0] ARLEN_Q_5;
reg  [3:0] ARLEN_Q_6;
reg  [3:0] ARLEN_Q_7;
wire RQ_Enque;
wire RQ_SubOne;
wire RQ_Full = (RQ_WriteIndex[3] != 1'b0);

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		ARLEN_Q_0  <= 0;
		RQ_WriteIndex <= 0;
	end
	else
	begin
		case({RQ_Enque, RQ_SubOne})
		2'b10:	// Enque only
		begin
			case(RQ_WriteIndex)
			3'b000: ARLEN_Q_0 <= ARLEN_M;
			3'b001: ARLEN_Q_1 <= ARLEN_M;
			3'b010: ARLEN_Q_2 <= ARLEN_M;
			3'b011: ARLEN_Q_3 <= ARLEN_M;
			3'b100: ARLEN_Q_4 <= ARLEN_M;
			3'b101: ARLEN_Q_5 <= ARLEN_M;
			3'b110: ARLEN_Q_6 <= ARLEN_M;
			3'b111: ARLEN_Q_7 <= ARLEN_M;
			endcase
			RQ_WriteIndex <= RQ_WriteIndex + 1;
		end
		2'b01: // SubOne Only
		begin
			if(ARLEN_Q_0 == 0)
			begin
				if(RQ_WriteIndex != 0)
					RQ_WriteIndex <= RQ_WriteIndex - 1;
				ARLEN_Q_0 <= ARLEN_Q_1;
				ARLEN_Q_1 <= ARLEN_Q_2;
				ARLEN_Q_2 <= ARLEN_Q_3;
				ARLEN_Q_3 <= ARLEN_Q_4;
				ARLEN_Q_4 <= ARLEN_Q_5;
				ARLEN_Q_5 <= ARLEN_Q_6;
				ARLEN_Q_6 <= ARLEN_Q_7;
				ARLEN_Q_7 <= 4'b0000;
			end
			else
				ARLEN_Q_0 <= ARLEN_Q_0 - 1'b1;
		end
		2'b11: // Simultaneous Enque/Deque
		begin
			if(ARLEN_Q_0 == 0)
			begin
				ARLEN_Q_0 <= (RQ_WriteIndex[3:0] == 3'b001) ? ARLEN_M : ARLEN_Q_1;
				ARLEN_Q_1 <= (RQ_WriteIndex[3:0] == 3'b010) ? ARLEN_M : ARLEN_Q_2;
				ARLEN_Q_2 <= (RQ_WriteIndex[3:0] == 3'b011) ? ARLEN_M : ARLEN_Q_3;
				ARLEN_Q_3 <= (RQ_WriteIndex[3:0] == 3'b100) ? ARLEN_M : ARLEN_Q_4;
				ARLEN_Q_4 <= (RQ_WriteIndex[3:0] == 3'b101) ? ARLEN_M : ARLEN_Q_5;
				ARLEN_Q_5 <= (RQ_WriteIndex[3:0] == 3'b110) ? ARLEN_M : ARLEN_Q_6;
				ARLEN_Q_6 <= (RQ_WriteIndex[3:0] == 3'b111) ? ARLEN_M : ARLEN_Q_7;
			end
			else
			begin
				if(RQ_WriteIndex == 0)
					ARLEN_Q_0 <= ARLEN_M;
				else
				begin
					ARLEN_Q_0 <= ARLEN_Q_0 - 1;
					case(RQ_WriteIndex)
//					3'b000: ARLEN_Q_0 <= ARLEN_M;
					3'b001: ARLEN_Q_1 <= ARLEN_M;
					3'b010: ARLEN_Q_2 <= ARLEN_M;
					3'b011: ARLEN_Q_3 <= ARLEN_M;
					3'b100: ARLEN_Q_4 <= ARLEN_M;
					3'b101: ARLEN_Q_5 <= ARLEN_M;
					3'b110: ARLEN_Q_6 <= ARLEN_M;
					3'b111: ARLEN_Q_7 <= ARLEN_M;
					endcase
					RQ_WriteIndex <= RQ_WriteIndex + 1'b1;
				end
			end
		end
		endcase
	end
end
assign RQ_SubOne = RVALID_M & RREADY_M;
assign RQ_Enque  = ARVALID_M & ARREADY_M;
// Read Data Channel(pass through except RLAST & RRESP)
assign RVALID_M  = RVALID_S;
assign RID_M     = RID_S;
assign RDATA_M   = RDATA_S;
assign RLAST_M   = (ARLEN_Q_0 == 0);
assign RRESP_M   = `RESP_OKAY;
assign RREADY_S  = RREADY_M;

// Read Address Channel
reg AR_state;	// 0 : idle, 1 : busy
assign ARREADY_M = ((AR_state == 0) && (!RQ_Full)) && ARREADY_S;

wire AR_passthrough = ARVALID_M && ARREADY_M;
reg         ARBURST_reg;
reg  [31:0] ARADDR_reg;
reg  [3:0]  ARLEN_reg;
reg  [3:0]  ARLEN_temp;

wire ARBURST_mux          = (AR_passthrough) ? (ARBURST_M == `BURST_WRAP) : ARBURST_reg;
wire [3:0] ARLEN_remained = (AR_passthrough) ? ARLEN_M : ARLEN_reg;
wire [5:2] ARADDR_mux     = (AR_passthrough) ? ARADDR_M[5:2] : ARADDR_reg[5:2];
wire [3:0] ARLEN_org      = (AR_passthrough) ? ARLEN_M : ARLEN_temp;
wire [3:0] ARLEN_wrap     = (ARLEN_org[3:2] != 2'b00) ? ((ARADDR_mux[5:2] | ARLEN_org[3:0]) - ARADDR_mux[5:2]) & {ARLEN_org[3], 3'b111} : ARLEN_M;
wire [3:0] ARLEN_calc_1   = ((~ARBURST_mux) | (ARLEN_remained < ARLEN_wrap)) ? ARLEN_remained : ARLEN_wrap;
wire [3:0]  ARLEN_calc    = {2'b00, ARLEN_calc_1[1:0]};

wire [2:0] ARLEN_S_plusOne = {1'b0, ARLEN_calc[1:0]} + 1'b1;

reg  [RID_WIDTH-1:0] ARID_reg;
wire [11:2] ARADDR_increased;
assign ARADDR_increased = ARADDR_M[11:2] + ARLEN_S_plusOne;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AR_state <= 0;
	end
	else
	begin
		if(ARVALID_M && ARREADY_M)
		begin
			ARID_reg <= ARID_M;
			ARLEN_temp <= ARLEN_M;
		end

		if(ARVALID_M && ARREADY_M && ARLEN_M[3:2] != 2'b00)
		begin
			ARBURST_reg <= (ARBURST_M == `BURST_WRAP);
			ARADDR_reg[31:12] <= ARADDR_M[31:12];
			if(ARBURST_M == `BURST_WRAP)
			begin
				ARADDR_reg[11:6] <= ARADDR_M[11:6];
				ARADDR_reg[5:2]  <= (ARADDR_increased[5:2] & ARLEN_M) | (ARADDR_M[5:2] & (~ARLEN_M));
			end
			else
				ARADDR_reg[11:2]  <= ARADDR_increased[11:2];

			ARADDR_reg[1:0]  <= ARADDR_M[1:0];
			ARLEN_reg <= ARLEN_M - ARLEN_S_plusOne;
			AR_state <= 1;	// BUSY
		end
		else if(AR_state == 1 && ARVALID_S && ARREADY_S)
		begin

			if(ARBURST_reg)
			begin
				ARADDR_reg[5:2] <= ((ARADDR_reg[5:2] + ARLEN_S_plusOne) & ARLEN_temp) | (ARADDR_reg[5:2] & (~ARLEN_temp));
			end
			else
				ARADDR_reg[11:2] <= ARADDR_reg[11:2] + ARLEN_S_plusOne;
			ARLEN_reg <= ARLEN_reg - ARLEN_S_plusOne;
			if(ARLEN_reg == ARLEN_S)
				AR_state <= 0;
		end
	end
end

assign ARID_S    = (AR_passthrough) ? ARID_M : ARID_reg;
assign ARVALID_S = ((!RQ_Full) && ARVALID_M) | AR_state;
assign ARADDR_S  = (AR_passthrough) ? ARADDR_M : ARADDR_reg;
assign ARLEN_S   = ARLEN_calc;
assign ARBURST_S = (AR_passthrough && ARLEN_M[3:2] == 2'b00) ? ARBURST_M : `BURST_INCR;

//
// Write Processing
//

// Write Que 1 : store AWLEN_S for WLAST generation
// Implemented with shift registers.
reg  [2:0] WQ_WriteIndex;
reg  [3:0] AWLEN_Q_0;
reg  [3:0] AWLEN_Q_1;
reg  [3:0] AWLEN_Q_2;
reg  [3:0] AWLEN_Q_3;
wire WQ_Enque;
wire WQ_SubOne;
wire WQ_Full = (WQ_WriteIndex[2] != 1'b0);

always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AWLEN_Q_0  <= 0;
		WQ_WriteIndex <= 0;
	end
	else
	begin
		case({WQ_Enque, WQ_SubOne})
		2'b10:	// Enque only
		begin
			case(WQ_WriteIndex)
			2'b00: AWLEN_Q_0 <= AWLEN_S;
			2'b01: AWLEN_Q_1 <= AWLEN_S;
			2'b10: AWLEN_Q_2 <= AWLEN_S;
			2'b11: AWLEN_Q_3 <= AWLEN_S;
			endcase
			WQ_WriteIndex <= WQ_WriteIndex + 1;
		end
		2'b01: // SubOne Only
		begin
			if(AWLEN_Q_0 == 0)
			begin
				if(WQ_WriteIndex != 0)
					WQ_WriteIndex <= WQ_WriteIndex - 1;
				AWLEN_Q_0 <= AWLEN_Q_1;
				AWLEN_Q_1 <= AWLEN_Q_2;
				AWLEN_Q_2 <= AWLEN_Q_3;
				AWLEN_Q_3 <= 4'b0000;
			end
			else
				AWLEN_Q_0 <= AWLEN_Q_0 - 1'b1;
		end
		2'b11: // Simultaneous Enque/Deque
		begin
			if(AWLEN_Q_0 == 0)
			begin
				AWLEN_Q_0 <= (WQ_WriteIndex == 2'b01) ? AWLEN_S : AWLEN_Q_1;
				AWLEN_Q_1 <= (WQ_WriteIndex == 2'b10) ? AWLEN_S : AWLEN_Q_2;
				AWLEN_Q_2 <= (WQ_WriteIndex == 2'b11) ? AWLEN_S : AWLEN_Q_3;
			end
			else
			begin
				if(WQ_WriteIndex == 0)
					AWLEN_Q_0 <= AWLEN_M;
				else
				begin
					AWLEN_Q_0 <= AWLEN_Q_0 - 1;
					case(WQ_WriteIndex)
//					3'b000: AWLEN_Q_0 <= AWLEN_M;
					2'b01: AWLEN_Q_1 <= AWLEN_S;
					2'b10: AWLEN_Q_2 <= AWLEN_S;
					2'b11: AWLEN_Q_3 <= AWLEN_S;
					endcase
					WQ_WriteIndex <= WQ_WriteIndex + 1'b1;
				end
			end
		end
		endcase
	end
end
assign WQ_SubOne = WVALID_S & WREADY_S;
assign WQ_Enque  = AWVALID_S & AWREADY_S;

// Write Data Channel(pass through)
assign WID_S    = WID_M;
assign WDATA_S  = WDATA_M;
assign WSTRB_S  = WSTRB_M;
assign WVALID_S = (WQ_WriteIndex != 0) && WVALID_M;	// Do not transfer if Write address transaction is not completed
assign WLAST_S  = (AWLEN_Q_0 == 0);
assign WREADY_M = (WQ_WriteIndex != 0) && WREADY_S;

// Write Que 2 : store transaction counter for masking BVALID_S
// Implemented with shift registers.
reg  [2:0] TQ_WriteIndex;
reg  [2:0] TLEN_Q_0;
reg  [2:0] TLEN_Q_1;
reg  [2:0] TLEN_Q_2;
reg  [2:0] TLEN_Q_3;
wire TQ_Enque;
wire TQ_SubOne;
wire TQ_Full = (TQ_WriteIndex[2] != 1'b0);

wire [2:0] TLEN;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		TLEN_Q_0  <= 0;
		TQ_WriteIndex <= 0;
	end
	else
	begin
		case({TQ_Enque, TQ_SubOne})
		2'b10:	// Enque only
		begin
			case(TQ_WriteIndex)
			2'b00: TLEN_Q_0 <= TLEN;
			2'b01: TLEN_Q_1 <= TLEN;
			2'b10: TLEN_Q_2 <= TLEN;
			2'b11: TLEN_Q_3 <= TLEN;
			endcase
			TQ_WriteIndex <= TQ_WriteIndex + 1;
		end
		2'b01: // SubOne Only
		begin
			if(TLEN_Q_0 == 0)
			begin
				if(TQ_WriteIndex != 0)
					TQ_WriteIndex <= TQ_WriteIndex - 1;
				TLEN_Q_0 <= TLEN_Q_1;
				TLEN_Q_1 <= TLEN_Q_2;
				TLEN_Q_2 <= TLEN_Q_3;
				TLEN_Q_3 <= 4'b0000;
			end
			else
				TLEN_Q_0 <= TLEN_Q_0 - 1'b1;
		end
		2'b11: // Simultaneous Enque/Deque
		begin
			if(TLEN_Q_0 == 0)
			begin
				TLEN_Q_0 <= (TQ_WriteIndex == 2'b01) ? TLEN : TLEN_Q_1;
				TLEN_Q_1 <= (TQ_WriteIndex == 2'b10) ? TLEN : TLEN_Q_2;
				TLEN_Q_2 <= (TQ_WriteIndex == 2'b11) ? TLEN : TLEN_Q_3;
			end
			else
			begin
				if(TQ_WriteIndex == 0)
					TLEN_Q_0 <= TLEN;
				else
				begin
					TLEN_Q_0 <= TLEN_Q_0 - 1;
					case(TQ_WriteIndex)
//					3'b000: ARLEN_Q_0 <= ARLEN_M;
					2'b01: TLEN_Q_1 <= TLEN;
					2'b10: TLEN_Q_2 <= TLEN;
					2'b11: TLEN_Q_3 <= TLEN;
					endcase
					TQ_WriteIndex <= TQ_WriteIndex + 1'b1;
				end
			end
		end
		endcase
	end
end
assign TQ_SubOne = BVALID_S & BREADY_S;
assign TQ_Enque  = AWVALID_M & AWREADY_M;
assign TLEN = (AWBURST_M == `BURST_WRAP && AWLEN_M[3:2] != 2'b00 && (AWADDR_M[3:2] != 2'b00)) ? ({1'b0, AWLEN_M[3:2]} + 1): {1'b0, AWLEN_M[3:2]};

// Write Response Channel(pass through except BVALID masking)
assign BVALID_M = BVALID_S && (TLEN_Q_0 == 0);
assign BID_M    = BID_S;
assign BRESP_M  = `RESP_OKAY;
assign BREADY_S = (TLEN_Q_0 == 0) ? BREADY_M : 1'b1; 

// Read Address Channel
reg AW_state;	// 0 : idle, 1 : busy

wire AW_passthrough = AWVALID_M && AWREADY_M;
reg         AWBURST_reg;
reg  [31:0] AWADDR_reg;
reg  [3:0]  AWLEN_reg;
reg  [3:0]  AWLEN_temp;

wire AWBURST_mux          = (AW_passthrough) ? (AWBURST_M == `BURST_WRAP) : AWBURST_reg;
wire [3:0] AWLEN_remained = (AW_passthrough) ? AWLEN_M : AWLEN_reg;
wire [5:2] AWADDR_mux     = (AW_passthrough) ? AWADDR_M[5:2] : AWADDR_reg[5:2];
wire [3:0] AWLEN_org      = (AW_passthrough) ? AWLEN_M : AWLEN_temp;
wire [3:0] AWLEN_wrap     = (AWLEN_org[3:2] != 2'b00) ? ((AWADDR_mux[5:2] | AWLEN_org[3:0]) - AWADDR_mux[5:2]) & {AWLEN_org[3], 3'b111} : AWLEN_M;
wire [3:0] AWLEN_calc_1   = ((~AWBURST_mux) | (AWLEN_remained < AWLEN_wrap)) ? AWLEN_remained : AWLEN_wrap;
wire [3:0]  AWLEN_calc    = {2'b00, AWLEN_calc_1[1:0]};

wire [2:0] AWLEN_S_plusOne = {1'b0, AWLEN_calc[1:0]} + 1'b1;

reg  [RID_WIDTH-1:0] AWID_reg;
wire [11:2] AWADDR_increased;
assign AWADDR_increased = AWADDR_M[11:2] + AWLEN_S_plusOne;
always @(posedge ACLK or negedge ARESETn)
begin
	if(!ARESETn)
	begin
		AW_state <= 0;
	end
	else
	begin
		if(AWVALID_M && AWREADY_M)
		begin
			AWID_reg <= AWID_M;
			AWLEN_temp <= AWLEN_M;
		end

		if(AWVALID_M && AWREADY_M && AWLEN_M[3:2] != 2'b00)
		begin
			AWBURST_reg <= (AWBURST_M == `BURST_WRAP);
			AWADDR_reg[31:12] <= AWADDR_M[31:12];
			if(AWBURST_M == `BURST_WRAP)
			begin
				AWADDR_reg[11:6] <= AWADDR_M[11:6];
				AWADDR_reg[5:2]  <= (AWADDR_increased[5:2] & AWLEN_M) | (AWADDR_M[5:2] & (~AWLEN_M));
			end
			else
				AWADDR_reg[11:2]  <= AWADDR_increased[11:2];

			AWADDR_reg[1:0]  <= AWADDR_M[1:0];
			AWLEN_reg <= AWLEN_M - AWLEN_S_plusOne;
			AW_state <= 1;	// BUSY
		end
		else if(AW_state == 1 && AWVALID_S && AWREADY_S)
		begin

			if(AWBURST_reg)
			begin
				AWADDR_reg[5:2] <= ((AWADDR_reg[5:2] + AWLEN_S_plusOne) & AWLEN_temp) | (AWADDR_reg[5:2] & (~AWLEN_temp));
			end
			else
				AWADDR_reg[11:2] <= AWADDR_reg[11:2] + AWLEN_S_plusOne;
			AWLEN_reg <= AWLEN_reg - AWLEN_S_plusOne;
			if(AWLEN_reg == AWLEN_S)
				AW_state <= 0;
		end
	end
end

assign AWID_S    = (AW_passthrough) ? AWID_M : AWID_reg;
assign AWREADY_M = ((AW_state == 0) && (!TQ_Full) && (!WQ_Full)) && AWREADY_S;
//assign AWVALID_S = (AW_state == 0) ? ((!TQ_Full) && (!WQ_Full) && AWVALID_M) : (!WQ_Full);
assign AWVALID_S = (((!TQ_Full) && AWVALID_M) | AW_state) && (!WQ_Full);
assign AWADDR_S  = (AW_passthrough) ? AWADDR_M : AWADDR_reg;
assign AWLEN_S   = AWLEN_calc;
assign AWBURST_S = (AW_passthrough && AWLEN_M[3:2] == 2'b00) ? AWBURST_M : `BURST_INCR;

// synopsys translate_off
// Protocol Checker
always @(posedge ACLK)
begin
	if(ARESETn === 1'b1 && ARVALID_S && ARREADY_S)
	begin
		if(ARLEN_S[3:2] !== 2'b00)
		begin
			$display("Burst more than 4 read transaction generated !!!!");
			$stop;
		end
	end
end
always @(posedge ACLK)
begin
	if(ARESETn === 1'b1 && AWVALID_S && AWREADY_S)
	begin
		if(AWLEN_S[3:2] !== 2'b00)
		begin
			$display("Burst more than 4 write transaction generated !!!!");
			$stop;
		end
	end
end
// synopsys translate_on
endmodule
