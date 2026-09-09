// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB_vic.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : Vectored Interrupt Controller
//  =============================================================================
`timescale 1ns/1ps

module APB_vic(
	// APB interface
	PCLK, 
	PRESETn, 
	PENABLE, 
	PSEL,
	PWRITE, 
	PADDR, 
	PWDATA,
	PRDATA,

	// 32 Interrupt Source Input
	INTERRUPT_SRC,

	// Output to ARM7TDMI
	nFIQ,
	nIRQ,

	// Output to Power Management Unit
	LEVEL_PM,
	POLARITY_PM,
	INTMSK_PM
);

// APB interface
input         PCLK;
input         PRESETn;
input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [6:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

// 32 Interrupt Source Input
input  [31:0] INTERRUPT_SRC;

// Output to ARM7TDMI
output        nFIQ;
output        nIRQ;

// Output to Power Management Unit
output [7:0] LEVEL_PM;
output [7:0] POLARITY_PM;
output [7:0] INTMSK_PM;

`define ADDR_INTCON    5'h00	// INTCON(R/W)   @ 0x00
`define ADDR_INTPND    5'h01	// INTPND(R/W)   @ 0x04
`define ADDR_INTMOD    5'h02	// INTMOD(R/W)   @ 0x08
`define ADDR_INTMSK    5'h03	// INTMSK(R/W)   @ 0x0C
`define ADDR_LEVEL     5'h04	// LEVEL(R/W)    @ 0x10
`define ADDR_I_PSLV0   5'h05	// I_PSLV0(R/W)  @ 0x14
`define ADDR_I_PSLV1   5'h06	// I_PSLV1(R/W)  @ 0x18
`define ADDR_I_PSLV2   5'h07	// I_PSLV2(R/W)  @ 0x1C
`define ADDR_I_PSLV3   5'h08	// I_PSLV2(R/W)  @ 0x20
`define ADDR_I_PMST    5'h09	// I_PMST(R/W)   @ 0x24
`define ADDR_I_CSLV0   5'h0A	// I_CSLV0(R)    @ 0x28
`define ADDR_I_CSLV1   5'h0B	// I_CSLV0(R)    @ 0x2C
`define ADDR_I_CSLV2   5'h0C	// I_CSLV0(R)    @ 0x30
`define ADDR_I_CSLV3   5'h0D	// I_CSLV0(R)    @ 0x34
`define ADDR_I_CMST    5'h0E	// I_CMST(R)     @ 0x38
`define ADDR_I_ISPR    5'h0F	// I_ISPR(R)     @ 0x3C
`define ADDR_I_ISPC    5'h10	// I_ISPC(W)     @ 0x40
`define ADDR_F_PSLV0   5'h11	// F_PSLV0(R/W)  @ 0x44
`define ADDR_F_PSLV1   5'h12	// F_PSLV1(R/W)  @ 0x48
`define ADDR_F_PSLV2   5'h13	// F_PSLV2(R/W)  @ 0x4C
`define ADDR_F_PSLV3   5'h14	// F_PSLV2(R/W)  @ 0x50
`define ADDR_F_PMST    5'h15	// F_PMST(R/W)   @ 0x54
`define ADDR_F_CSLV0   5'h16	// F_CSLV0(R)    @ 0x58
`define ADDR_F_CSLV1   5'h17	// F_CSLV1(R)    @ 0x5C
`define ADDR_F_CSLV2   5'h18	// F_CSLV2(R)    @ 0x60
`define ADDR_F_CSLV3   5'h19	// F_CSLV3(R)    @ 0x64
`define ADDR_F_CMST    5'h1A    // F_CMST(R)     @ 0x68
`define ADDR_F_ISPR    5'h1B	// F_ISPR(R)     @ 0x6C
`define ADDR_F_ISPC    5'h1C	// F_ISPC(W)     @ 0x70
`define ADDR_POLARITY  5'h1D	// POLARITY(R/W) @ 0x74
`define ADDR_I_VECADDR 5'h1E	// I_VECADDR(R)  @ 0x78
`define ADDR_F_VECADDR 5'h1F	// F_VECADDR(R)  @ 0x7C

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

wire        PCLK;
wire        PRESETn;
wire        PENABLE;
wire        PSEL;
wire        PWRITE;
wire [6:2]  PADDR;
wire [31:0] PWDATA;
reg  [31:0] PRDATA;
  
reg  [3:0]  INTCON;
wire        GIE;
wire        nENBIRQ;
wire        nENBFIQ;
assign GIE = INTCON[3];
assign nENBIRQ = INTCON[1];
assign nENBFIQ = INTCON[0];

reg  [31:0] INTPND;
reg  [31:0] INTMOD;
reg  [31:0] INTMSK;
reg  [31:0] LEVEL;
reg  [23:0] I_PSLV0;
reg  [23:0] I_PSLV1;
reg  [23:0] I_PSLV2;
reg  [23:0] I_PSLV3;
reg  [12:0] I_PMST;

reg  [23:0] I_CSLV0;
reg  [23:0] I_CSLV1;
reg  [23:0] I_CSLV2;
reg  [23:0] I_CSLV3;

reg  [7:0]  I_CMST;
reg  [31:0] I_ISPR;
reg  [23:0] F_PSLV0;
reg  [23:0] F_PSLV1;
reg  [23:0] F_PSLV2;
reg  [23:0] F_PSLV3;
reg  [12:0] F_PMST;
reg  [23:0] F_CSLV0;
reg  [23:0] F_CSLV1;
reg  [23:0] F_CSLV2;
reg  [23:0] F_CSLV3;

reg  [7:0]  F_CMST;
reg  [31:0] F_ISPR;
reg  [31:0] POLARITY;
reg  [4:0]  I_VECADDR;
reg  [4:0]  F_VECADDR;

reg         nFIQ;
reg         nIRQ;
  
// Output to Power Management Unit
wire [7:0] LEVEL_PM;
wire [7:0] POLARITY_PM;
wire [7:0] INTMSK_PM;

assign LEVEL_PM = {LEVEL[15:12],LEVEL[3:0]};
assign POLARITY_PM = {POLARITY[15:12],POLARITY[3:0]};
assign INTMSK_PM = {INTMSK[15:12],INTMSK[3:0]};

//
// APB interface part
//

wire APB_WriteEnable;

assign APB_WriteEnable = PSEL & (~PENABLE) & PWRITE;
// Register writing
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		INTCON   <= 4'b1011;
		INTMOD   <= {32{1'b0}};
		INTMSK   <= {32{1'b1}};
		LEVEL    <= {32{1'b0}};
		I_PSLV0  <= 24'hFAC688;
		I_PSLV1  <= 24'hFAC688;
		I_PSLV2  <= 24'hFAC688;
		I_PSLV3  <= 24'hFAC688;
		I_PMST   <= 13'h1FE4;
		F_PSLV0  <= 24'hFAC688;
		F_PSLV1  <= 24'hFAC688;
		F_PSLV2  <= 24'hFAC688;
		F_PSLV3  <= 24'hFAC688;
		F_PMST   <= 13'h1FE4;
		POLARITY <= {32{1'b0}};
	end
	else
	begin
		if(APB_WriteEnable)
		begin
			case (PADDR[6:2])
			`ADDR_INTCON   : INTCON   <= PWDATA[ 3:0];
			// INTPND should be considered differently.
			`ADDR_INTMOD   : INTMOD   <= PWDATA[31:0];
			`ADDR_INTMSK   : INTMSK   <= PWDATA[31:0];
			`ADDR_LEVEL    : LEVEL    <= PWDATA[31:0];
			`ADDR_I_PSLV0  : I_PSLV0  <= PWDATA[23:0];
			`ADDR_I_PSLV1  : I_PSLV1  <= PWDATA[23:0];
			`ADDR_I_PSLV2  : I_PSLV2  <= PWDATA[23:0];
			`ADDR_I_PSLV3  : I_PSLV3  <= PWDATA[23:0];
			`ADDR_I_PMST   : I_PMST   <= PWDATA[12:0];
			// I_CSLV0, I_CSLV1, I_CSLV2, I_CSLV3, I_CMST is Read-Only.
			// I_ISPR is Read-Only.
			// I_ISPC should be considered differently.
			`ADDR_F_PSLV0  : F_PSLV0  <= PWDATA[23:0];
			`ADDR_F_PSLV1  : F_PSLV1  <= PWDATA[23:0];
			`ADDR_F_PSLV2  : F_PSLV2  <= PWDATA[23:0];
			`ADDR_F_PSLV3  : F_PSLV3  <= PWDATA[23:0];
			`ADDR_F_PMST   : F_PMST   <= PWDATA[12:0];
			// F_CSLV0, F_CSLV1, F_CSLV2, F_CSLV3, F_CMST is Read-Only.
			// F_ISPR is Read-Only.
			// F_ISPC should be considered differently.
			`ADDR_POLARITY : POLARITY <= PWDATA[31:0];
			// I_VECADDR, F_VECADDR is Read-Only.
			endcase
		end
	end
end

// Register reading
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA <= 32'h00000000;
	else
	begin
		if(PSEL & (~PENABLE) & (~PWRITE))
		begin
			case (PADDR[6:2])
			`ADDR_INTCON    : PRDATA <= {28'd0, INTCON};
			`ADDR_INTPND    : PRDATA <= INTPND;
			`ADDR_INTMOD    : PRDATA <= INTMOD;
			`ADDR_INTMSK    : PRDATA <= INTMSK;
			`ADDR_LEVEL     : PRDATA <= LEVEL;
			`ADDR_I_PSLV0   : PRDATA <= {8'd0, I_PSLV0};
			`ADDR_I_PSLV1   : PRDATA <= {8'd0, I_PSLV1};
			`ADDR_I_PSLV2   : PRDATA <= {8'd0, I_PSLV2};
			`ADDR_I_PSLV3   : PRDATA <= {8'd0, I_PSLV3};
			`ADDR_I_PMST    : PRDATA <= {19'd0, I_PMST};
			`ADDR_I_CSLV0   : PRDATA <= {8'd0, I_CSLV0};
			`ADDR_I_CSLV1   : PRDATA <= {8'd0, I_CSLV1};
			`ADDR_I_CSLV2   : PRDATA <= {8'd0, I_CSLV2};
			`ADDR_I_CSLV3   : PRDATA <= {8'd0, I_CSLV3};
			`ADDR_I_CMST    : PRDATA <= {19'd0, I_PMST[12:8], I_CMST};
			`ADDR_I_ISPR    : PRDATA <= I_ISPR;
			// I_ISPC is Write Only register
			`ADDR_F_PSLV0   : PRDATA <= {8'd0, F_PSLV0};
			`ADDR_F_PSLV1   : PRDATA <= {8'd0, F_PSLV1};
			`ADDR_F_PSLV2   : PRDATA <= {8'd0, F_PSLV2};
			`ADDR_F_PSLV3   : PRDATA <= {8'd0, F_PSLV3};
			`ADDR_F_PMST    : PRDATA <= {19'd0, F_PMST};
			`ADDR_F_CSLV0   : PRDATA <= {8'd0, F_CSLV0};
			`ADDR_F_CSLV1   : PRDATA <= {8'd0, F_CSLV1};
			`ADDR_F_CSLV2   : PRDATA <= {8'd0, F_CSLV2};
			`ADDR_F_CSLV3   : PRDATA <= {8'd0, F_CSLV3};
			`ADDR_F_CMST    : PRDATA <= {19'd0, F_PMST[12:8], F_CMST};
			`ADDR_F_ISPR    : PRDATA <= F_ISPR;
			// F_ISPC is Write Only register
			`ADDR_POLARITY  : PRDATA <= POLARITY;
			`ADDR_I_VECADDR : PRDATA <= {25'd0, I_VECADDR,2'b00};
			`ADDR_F_VECADDR : PRDATA <= {25'd0, F_VECADDR,2'b00};
			default         : PRDATA <= {32{1'b0}};  // Read as zero default
			endcase
		end
	end
end

//
// Interrupt Processing Part
//

//
// Interrupt input stage : interrupt_src to INTPND
//
reg  [31:0] interrupt_src_ff;
reg  [31:0] interrupt_src_temp;
wire [31:0] edge_detected;
wire [31:0] interrupt_src_polarity_adjusted;
wire [31:0] nextINTPND;

// register
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		interrupt_src_ff <= 32'h00000000;
		interrupt_src_temp <= 32'h00000000;
	end
	else
	begin
		interrupt_src_ff <= INTERRUPT_SRC;
		interrupt_src_temp <= interrupt_src_polarity_adjusted;
	end
end

// interrupt_src_src_polarity_adjusted = (POLARTY) ? ~interrupt_src_ff : interrupt_src_ff
assign interrupt_src_polarity_adjusted = POLARITY^interrupt_src_ff;
// rising edge detect
assign edge_detected=interrupt_src_polarity_adjusted&(~interrupt_src_temp);
// nextINTPND = (level) ? interrupt_src_polarity_adjusted : (INTPND | edge_detected)
assign nextINTPND = (LEVEL & interrupt_src_polarity_adjusted) | ((~LEVEL) & (INTPND | edge_detected));

// INTPND update : Should we consider GIE here?
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		INTPND <= 32'h00000000;
	end
	else
	begin
		if (GIE)
			INTPND <= 32'h00000000;
		else
		begin
			if (APB_WriteEnable)
			begin
				if(PADDR[6:2] == `ADDR_INTPND)
					INTPND <= PWDATA;	// I'm not sure INTPND is writable. It is not recommended to write INTPND directly.
				else if(PADDR[6:2] == `ADDR_I_ISPC || PADDR[6:2] == `ADDR_F_ISPC)
					INTPND <= (~PWDATA) & nextINTPND;
				else
					INTPND <= nextINTPND;
			end
			else
					INTPND <= nextINTPND;
		end
	end
end

//
// Interrupt masking stage : INTPND to irq_pending, fiq_pending
//
wire [31:0] maskedINTPND;
wire [31:0] irq_pending_comb;
wire [31:0] fiq_pending_comb;
reg  [31:0] irq_pending;
reg  [31:0] fiq_pending;

assign maskedINTPND = INTPND & (~INTMSK);
assign irq_pending_comb = maskedINTPND & (~INTMOD);
assign fiq_pending_comb = maskedINTPND & INTMOD;

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		irq_pending <= 32'h00000000;
		fiq_pending <= 32'h00000000;
	end
	else
	begin
		irq_pending <= irq_pending_comb;
		fiq_pending <= fiq_pending_comb;
	end
end

//
// Interrupt arbitration stage : irq_pending(fiq_pending) to I_ISPR(F_ISPR)
//

wire [ 3:0] master_I_ISPR;
wire [31:0] slave_I_ISPR_comb;
reg  [31:0] slave_I_ISPR;
reg  [ 3:0] irq_pending_to_master;
wire [ 3:0] irq_pending_to_master_comb;
wire        FIX_IMST;
wire [ 3:0] FIX_ISLV;

assign FIX_IMST = I_PMST[12];
assign FIX_ISLV = I_PMST[11:8];

wire [ 7:0] next_I_CMST;
wire [23:0] next_I_CSLV0;
wire [23:0] next_I_CSLV1;
wire [23:0] next_I_CSLV2;
wire [23:0] next_I_CSLV3;
//
// Caution : We must update ISPR only when ISPR&INTMSK&INTPND == 0
//         : And if we update ISPR just after clearing INTPND, then ISPR
//           interrupt can be updated with previous value
//           because of arbitration delay.
//           So we must check this out.
//
reg  [1:0] I_ISPR_UpdateState;
`define ISPR_UPDATE_STATE_0	2'b00
`define ISPR_UPDATE_STATE_1	2'b01
`define ISPR_UPDATE_STATE_2	2'b10
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		I_ISPR_UpdateState <= `ISPR_UPDATE_STATE_2;
		I_ISPR <= 32'h00000000;
		I_CMST <= 8'b11100100;
	end
	else
	begin
		if((irq_pending_comb&I_ISPR) == 0)
		begin
			case (I_ISPR_UpdateState)
			`ISPR_UPDATE_STATE_1: I_ISPR_UpdateState <= `ISPR_UPDATE_STATE_0;
			`ISPR_UPDATE_STATE_2: I_ISPR_UpdateState <= `ISPR_UPDATE_STATE_1;
			endcase
		end
		else
			I_ISPR_UpdateState <= `ISPR_UPDATE_STATE_2;

		if ((APB_WriteEnable) && (PADDR[6:2] == `ADDR_I_ISPC))
			I_ISPR <= I_ISPR & (~PWDATA[31:0]);
		else
		begin
			if((irq_pending_comb&I_ISPR) == 0 && I_ISPR_UpdateState == `ISPR_UPDATE_STATE_0)
			begin
				I_ISPR[ 7: 0] <= (master_I_ISPR[0]) ? slave_I_ISPR[ 7: 0] : 8'h00;
				I_ISPR[15: 8] <= (master_I_ISPR[1]) ? slave_I_ISPR[15: 8] : 8'h00;
				I_ISPR[23:16] <= (master_I_ISPR[2]) ? slave_I_ISPR[23:16] : 8'h00;
				I_ISPR[31:24] <= (master_I_ISPR[3]) ? slave_I_ISPR[31:24] : 8'h00;
			end
		end

		if ((APB_WriteEnable) && (PADDR[6:2] == `ADDR_I_PMST))
			I_CMST <= PWDATA[7:0];
		else
		begin
			if((irq_pending_comb&I_ISPR) == 0 && I_ISPR_UpdateState == `ISPR_UPDATE_STATE_0)
				I_CMST <= next_I_CMST;
		end
	end
end

vic_master_arbiter irq_master
	(
	.FIXED_MODE(FIX_IMST),
	.INTPEND(irq_pending_to_master),
	.ISPR_OUT(master_I_ISPR),
	.INTERRUPT_OUT(),
	.PMST(I_PMST[7:0]),
	.CMST(I_CMST[7:0]),
	.NEXTCMST(next_I_CMST[7:0])
	);
	
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		irq_pending_to_master <= 4'b0000;
		slave_I_ISPR <= 32'h00000000;
		I_CSLV0  <= 24'hFAC688;
		I_CSLV1  <= 24'hFAC688;
		I_CSLV2  <= 24'hFAC688;
		I_CSLV3  <= 24'hFAC688;
	end
	else
	begin
		irq_pending_to_master <= irq_pending_to_master_comb;
		slave_I_ISPR <= slave_I_ISPR_comb;
		if (APB_WriteEnable && PADDR[6:2] == `ADDR_I_PSLV0)
			I_CSLV0  <= PWDATA[23:0];
		else if (APB_WriteEnable && PADDR[6:2] == `ADDR_I_PSLV1)
			I_CSLV1  <= PWDATA[23:0];
		else if (APB_WriteEnable && PADDR[6:2] == `ADDR_I_PSLV2)
			I_CSLV2  <= PWDATA[23:0];
		else if (APB_WriteEnable && PADDR[6:2] == `ADDR_I_PSLV3)
			I_CSLV3  <= PWDATA[23:0];
		else
		begin
			I_CSLV0 <= next_I_CSLV0;
			I_CSLV1 <= next_I_CSLV1;
			I_CSLV2 <= next_I_CSLV2;
			I_CSLV3 <= next_I_CSLV3;
		end
	end
end

vic_slave_arbiter irq_slave0
	(
	.FIXED_MODE(FIX_ISLV[0]),
	.INTPEND(irq_pending[7:0]),
	.ISPR_OUT(slave_I_ISPR_comb[7:0]),
	.INTERRUPT_OUT(irq_pending_to_master_comb[0]),
	.PSLV(I_PSLV0),
	.CSLV(I_CSLV0),
	.NEXTCSLV(next_I_CSLV0)
	);

vic_slave_arbiter irq_slave1
	(
	.FIXED_MODE(FIX_ISLV[1]),
	.INTPEND(irq_pending[15:8]),
	.ISPR_OUT(slave_I_ISPR_comb[15:8]),
	.INTERRUPT_OUT(irq_pending_to_master_comb[1]),
	.PSLV(I_PSLV1),
	.CSLV(I_CSLV1),
	.NEXTCSLV(next_I_CSLV1)
	);

vic_slave_arbiter irq_slave2
	(
	.FIXED_MODE(FIX_ISLV[2]),
	.INTPEND(irq_pending[23:16]),
	.ISPR_OUT(slave_I_ISPR_comb[23:16]),
	.INTERRUPT_OUT(irq_pending_to_master_comb[2]),
	.PSLV(I_PSLV2),
	.CSLV(I_CSLV2),
	.NEXTCSLV(next_I_CSLV2)
	);

vic_slave_arbiter irq_slave3
	(
	.FIXED_MODE(FIX_ISLV[3]),
	.INTPEND(irq_pending[31:24]),
	.ISPR_OUT(slave_I_ISPR_comb[31:24]),
	.INTERRUPT_OUT(irq_pending_to_master_comb[3]),
	.PSLV(I_PSLV3),
	.CSLV(I_CSLV3),
	.NEXTCSLV(next_I_CSLV3)
	);
// FIQ
wire [ 3:0] master_F_ISPR;
wire [31:0] slave_F_ISPR_comb;
reg  [31:0] slave_F_ISPR;
reg  [ 3:0] fiq_pending_to_master;
wire [ 3:0] fiq_pending_to_master_comb;
wire        FIX_FMST;
wire [ 3:0] FIX_FSLV;

assign FIX_FMST = F_PMST[12];
assign FIX_FSLV = F_PMST[11:8];

wire [ 7:0] next_F_CMST;
wire [23:0] next_F_CSLV0;
wire [23:0] next_F_CSLV1;
wire [23:0] next_F_CSLV2;
wire [23:0] next_F_CSLV3;
//
// Caution : We must update ISPR only when ISPR&INTMSK&INTPND == 0
//         : And if we update ISPR just after clearing INTPND, then ISPR
//           interrupt can be updated with previous value
//           because of arbitration delay.
//           So we must check this out.
//
reg  [1:0] F_ISPR_UpdateState;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		F_ISPR_UpdateState <= `ISPR_UPDATE_STATE_2;
		F_ISPR <= 32'h00000000;
		F_CMST <= 8'b11100100;
	end
	else
	begin
		if((fiq_pending_comb&F_ISPR) == 0)
		begin
			case (F_ISPR_UpdateState)
			`ISPR_UPDATE_STATE_1: F_ISPR_UpdateState <= `ISPR_UPDATE_STATE_0;
			`ISPR_UPDATE_STATE_2: F_ISPR_UpdateState <= `ISPR_UPDATE_STATE_1;
			endcase
		end
		else
			F_ISPR_UpdateState <= `ISPR_UPDATE_STATE_2;

		if ((APB_WriteEnable) && (PADDR[6:2] == `ADDR_F_ISPC))
			F_ISPR <= F_ISPR & (~PWDATA[31:0]);
		else
		begin
			if((fiq_pending_comb&F_ISPR) == 0 && F_ISPR_UpdateState == `ISPR_UPDATE_STATE_0)
			begin
				F_ISPR[ 7: 0] <= (master_F_ISPR[0]) ? slave_F_ISPR[ 7: 0] : 8'h00;
				F_ISPR[15: 8] <= (master_F_ISPR[1]) ? slave_F_ISPR[15: 8] : 8'h00;
				F_ISPR[23:16] <= (master_F_ISPR[2]) ? slave_F_ISPR[23:16] : 8'h00;
				F_ISPR[31:24] <= (master_F_ISPR[3]) ? slave_F_ISPR[31:24] : 8'h00;
			end
		end

		if ((APB_WriteEnable) && (PADDR[6:2] == `ADDR_F_PMST))
			F_CMST <= PWDATA[7:0];
		else
		begin
			if((fiq_pending_comb&F_ISPR) == 0 && F_ISPR_UpdateState == `ISPR_UPDATE_STATE_0)
				F_CMST <= next_F_CMST;
		end
	end
end

vic_master_arbiter fiq_master
	(
	.FIXED_MODE(FIX_FMST),
	.INTPEND(fiq_pending_to_master),
	.ISPR_OUT(master_F_ISPR),
	.INTERRUPT_OUT(),
	.PMST(F_PMST[7:0]),
	.CMST(F_CMST[7:0]),
	.NEXTCMST(next_F_CMST[7:0])
	);
	
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		fiq_pending_to_master <= 4'b0000;
		slave_F_ISPR <= 32'h00000000;
		F_CSLV0  <= 24'hFAC688;
		F_CSLV1  <= 24'hFAC688;
		F_CSLV2  <= 24'hFAC688;
		F_CSLV3  <= 24'hFAC688;
	end
	else
	begin
		fiq_pending_to_master <= fiq_pending_to_master_comb;
		slave_F_ISPR <= slave_F_ISPR_comb;
		if (APB_WriteEnable && PADDR[6:2] == `ADDR_F_PSLV0)
			F_CSLV0  <= PWDATA[23:0];
		else if (APB_WriteEnable && PADDR[6:2] == `ADDR_F_PSLV1)
			F_CSLV1  <= PWDATA[23:0];
		else if (APB_WriteEnable && PADDR[6:2] == `ADDR_F_PSLV2)
			F_CSLV2  <= PWDATA[23:0];
		else if (APB_WriteEnable && PADDR[6:2] == `ADDR_F_PSLV3)
			F_CSLV3  <= PWDATA[23:0];
		else
		begin
			F_CSLV0 <= next_F_CSLV0;
			F_CSLV1 <= next_F_CSLV1;
			F_CSLV2 <= next_F_CSLV2;
			F_CSLV3 <= next_F_CSLV3;
		end
	end
end

vic_slave_arbiter fiq_slave0
	(
	.FIXED_MODE(FIX_FSLV[0]),
	.INTPEND(fiq_pending[7:0]),
	.ISPR_OUT(slave_F_ISPR_comb[7:0]),
	.INTERRUPT_OUT(fiq_pending_to_master_comb[0]),
	.PSLV(F_PSLV0),
	.CSLV(F_CSLV0),
	.NEXTCSLV(next_F_CSLV0)
	);

vic_slave_arbiter fiq_slave1
	(
	.FIXED_MODE(FIX_FSLV[1]),
	.INTPEND(fiq_pending[15:8]),
	.ISPR_OUT(slave_F_ISPR_comb[15:8]),
	.INTERRUPT_OUT(fiq_pending_to_master_comb[1]),
	.PSLV(F_PSLV1),
	.CSLV(F_CSLV1),
	.NEXTCSLV(next_F_CSLV1)
	);

vic_slave_arbiter fiq_slave2
	(
	.FIXED_MODE(FIX_FSLV[2]),
	.INTPEND(fiq_pending[23:16]),
	.ISPR_OUT(slave_F_ISPR_comb[23:16]),
	.INTERRUPT_OUT(fiq_pending_to_master_comb[2]),
	.PSLV(F_PSLV2),
	.CSLV(F_CSLV2),
	.NEXTCSLV(next_F_CSLV2)
	);

vic_slave_arbiter fiq_slave3
	(
	.FIXED_MODE(FIX_FSLV[3]),
	.INTPEND(fiq_pending[31:24]),
	.ISPR_OUT(slave_F_ISPR_comb[31:24]),
	.INTERRUPT_OUT(fiq_pending_to_master_comb[3]),
	.PSLV(F_PSLV3),
	.CSLV(F_CSLV3),
	.NEXTCSLV(next_F_CSLV3)
	);

//
// Interrupt generation block : I_ISPR(F_ISPR) to nIRQ(nFIQ) and I_VECADDR(F_VECADDR)
//
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		nIRQ <= 1'b1;
		nFIQ <= 1'b1;
		I_VECADDR <= 5'h00;
		F_VECADDR <= 5'h00;
	end
	else
	begin
		if(nENBIRQ|GIE)
			nIRQ <= 1'b1;
		else
			nIRQ <= (I_ISPR == 32'h00000000) ? 1'b1 : 1'b0;

		if(nENBFIQ|GIE)
			nFIQ <= 1'b1;
		else
			nFIQ <= (F_ISPR == 32'h00000000) ? 1'b1 : 1'b0;

`define CASE_OVER_IF 1
`ifdef CASE_OVER_IF
		case (I_ISPR)
		32'h0000_0001 : I_VECADDR <= 5'h00;
		32'h0000_0002 : I_VECADDR <= 5'h01;
		32'h0000_0004 : I_VECADDR <= 5'h02;
		32'h0000_0008 : I_VECADDR <= 5'h03;
		32'h0000_0010 : I_VECADDR <= 5'h04;
		32'h0000_0020 : I_VECADDR <= 5'h05;
		32'h0000_0040 : I_VECADDR <= 5'h06;
		32'h0000_0080 : I_VECADDR <= 5'h07;
		32'h0000_0100 : I_VECADDR <= 5'h08;
		32'h0000_0200 : I_VECADDR <= 5'h09;
		32'h0000_0400 : I_VECADDR <= 5'h0A;
		32'h0000_0800 : I_VECADDR <= 5'h0B;
		32'h0000_1000 : I_VECADDR <= 5'h0C;
		32'h0000_2000 : I_VECADDR <= 5'h0D;
		32'h0000_4000 : I_VECADDR <= 5'h0E;
		32'h0000_8000 : I_VECADDR <= 5'h0F;
		32'h0001_0000 : I_VECADDR <= 5'h10;
		32'h0002_0000 : I_VECADDR <= 5'h11;
		32'h0004_0000 : I_VECADDR <= 5'h12;
		32'h0008_0000 : I_VECADDR <= 5'h13;
		32'h0010_0000 : I_VECADDR <= 5'h14;
		32'h0020_0000 : I_VECADDR <= 5'h15;
		32'h0040_0000 : I_VECADDR <= 5'h16;
		32'h0080_0000 : I_VECADDR <= 5'h17;
		32'h0100_0000 : I_VECADDR <= 5'h18;
		32'h0200_0000 : I_VECADDR <= 5'h19;
		32'h0400_0000 : I_VECADDR <= 5'h1A;
		32'h0800_0000 : I_VECADDR <= 5'h1B;
		32'h1000_0000 : I_VECADDR <= 5'h1C;
		32'h2000_0000 : I_VECADDR <= 5'h1D;
		32'h4000_0000 : I_VECADDR <= 5'h1E;
		32'h8000_0000 : I_VECADDR <= 5'h1F;
		default       : I_VECADDR <= 5'h00;
		endcase

		case (F_ISPR)
		32'h0000_0001 : F_VECADDR <= 5'h00;
		32'h0000_0002 : F_VECADDR <= 5'h01;
		32'h0000_0004 : F_VECADDR <= 5'h02;
		32'h0000_0008 : F_VECADDR <= 5'h03;
		32'h0000_0010 : F_VECADDR <= 5'h04;
		32'h0000_0020 : F_VECADDR <= 5'h05;
		32'h0000_0040 : F_VECADDR <= 5'h06;
		32'h0000_0080 : F_VECADDR <= 5'h07;
		32'h0000_0100 : F_VECADDR <= 5'h08;
		32'h0000_0200 : F_VECADDR <= 5'h09;
		32'h0000_0400 : F_VECADDR <= 5'h0A;
		32'h0000_0800 : F_VECADDR <= 5'h0B;
		32'h0000_1000 : F_VECADDR <= 5'h0C;
		32'h0000_2000 : F_VECADDR <= 5'h0D;
		32'h0000_4000 : F_VECADDR <= 5'h0E;
		32'h0000_8000 : F_VECADDR <= 5'h0F;
		32'h0001_0000 : F_VECADDR <= 5'h10;
		32'h0002_0000 : F_VECADDR <= 5'h11;
		32'h0004_0000 : F_VECADDR <= 5'h12;
		32'h0008_0000 : F_VECADDR <= 5'h13;
		32'h0010_0000 : F_VECADDR <= 5'h14;
		32'h0020_0000 : F_VECADDR <= 5'h15;
		32'h0040_0000 : F_VECADDR <= 5'h16;
		32'h0080_0000 : F_VECADDR <= 5'h17;
		32'h0100_0000 : F_VECADDR <= 5'h18;
		32'h0200_0000 : F_VECADDR <= 5'h19;
		32'h0400_0000 : F_VECADDR <= 5'h1A;
		32'h0800_0000 : F_VECADDR <= 5'h1B;
		32'h1000_0000 : F_VECADDR <= 5'h1C;
		32'h2000_0000 : F_VECADDR <= 5'h1D;
		32'h4000_0000 : F_VECADDR <= 5'h1E;
		32'h8000_0000 : F_VECADDR <= 5'h1F;
		default       : F_VECADDR <= 5'h00;
		endcase
`else
		if(I_ISPR[0]) I_VECADDR <= 5'h00;
		else if(I_ISPR[1]) I_VECADDR <= 5'h01;
		else if(I_ISPR[2]) I_VECADDR <= 5'h02;
		else if(I_ISPR[3]) I_VECADDR <= 5'h03;
		else if(I_ISPR[4]) I_VECADDR <= 5'h04;
		else if(I_ISPR[5]) I_VECADDR <= 5'h05;
		else if(I_ISPR[6]) I_VECADDR <= 5'h06;
		else if(I_ISPR[7]) I_VECADDR <= 5'h07;
		else if(I_ISPR[8]) I_VECADDR <= 5'h08;
		else if(I_ISPR[9]) I_VECADDR <= 5'h09;
		else if(I_ISPR[10]) I_VECADDR <= 5'h0A;
		else if(I_ISPR[11]) I_VECADDR <= 5'h0B;
		else if(I_ISPR[12]) I_VECADDR <= 5'h0C;
		else if(I_ISPR[13]) I_VECADDR <= 5'h0D;
		else if(I_ISPR[14]) I_VECADDR <= 5'h0E;
		else if(I_ISPR[15]) I_VECADDR <= 5'h0F;
		else if(I_ISPR[16]) I_VECADDR <= 5'h10;
		else if(I_ISPR[17]) I_VECADDR <= 5'h11;
		else if(I_ISPR[18]) I_VECADDR <= 5'h12;
		else if(I_ISPR[19]) I_VECADDR <= 5'h13;
		else if(I_ISPR[20]) I_VECADDR <= 5'h14;
		else if(I_ISPR[21]) I_VECADDR <= 5'h15;
		else if(I_ISPR[22]) I_VECADDR <= 5'h16;
		else if(I_ISPR[23]) I_VECADDR <= 5'h17;
		else if(I_ISPR[24]) I_VECADDR <= 5'h18;
		else if(I_ISPR[25]) I_VECADDR <= 5'h19;
		else if(I_ISPR[26]) I_VECADDR <= 5'h1A;
		else if(I_ISPR[27]) I_VECADDR <= 5'h1B;
		else if(I_ISPR[28]) I_VECADDR <= 5'h1C;
		else if(I_ISPR[29]) I_VECADDR <= 5'h1D;
		else if(I_ISPR[30]) I_VECADDR <= 5'h1E;
		else if(I_ISPR[31]) I_VECADDR <= 5'h1F;
		else I_VECADDR <= 5'h00;

		if(F_ISPR[0]) F_VECADDR <= 5'h00;
		else if(F_ISPR[1]) F_VECADDR <= 5'h01;
		else if(F_ISPR[2]) F_VECADDR <= 5'h02;
		else if(F_ISPR[3]) F_VECADDR <= 5'h03;
		else if(F_ISPR[4]) F_VECADDR <= 5'h04;
		else if(F_ISPR[5]) F_VECADDR <= 5'h05;
		else if(F_ISPR[6]) F_VECADDR <= 5'h06;
		else if(F_ISPR[7]) F_VECADDR <= 5'h07;
		else if(F_ISPR[8]) F_VECADDR <= 5'h08;
		else if(F_ISPR[9]) F_VECADDR <= 5'h09;
		else if(F_ISPR[10]) F_VECADDR <= 5'h0A;
		else if(F_ISPR[11]) F_VECADDR <= 5'h0B;
		else if(F_ISPR[12]) F_VECADDR <= 5'h0C;
		else if(F_ISPR[13]) F_VECADDR <= 5'h0D;
		else if(F_ISPR[14]) F_VECADDR <= 5'h0E;
		else if(F_ISPR[15]) F_VECADDR <= 5'h0F;
		else if(F_ISPR[16]) F_VECADDR <= 5'h10;
		else if(F_ISPR[17]) F_VECADDR <= 5'h11;
		else if(F_ISPR[18]) F_VECADDR <= 5'h12;
		else if(F_ISPR[19]) F_VECADDR <= 5'h13;
		else if(F_ISPR[20]) F_VECADDR <= 5'h14;
		else if(F_ISPR[21]) F_VECADDR <= 5'h15;
		else if(F_ISPR[22]) F_VECADDR <= 5'h16;
		else if(F_ISPR[23]) F_VECADDR <= 5'h17;
		else if(F_ISPR[24]) F_VECADDR <= 5'h18;
		else if(F_ISPR[25]) F_VECADDR <= 5'h19;
		else if(F_ISPR[26]) F_VECADDR <= 5'h1A;
		else if(F_ISPR[27]) F_VECADDR <= 5'h1B;
		else if(F_ISPR[28]) F_VECADDR <= 5'h1C;
		else if(F_ISPR[29]) F_VECADDR <= 5'h1D;
		else if(F_ISPR[30]) F_VECADDR <= 5'h1E;
		else if(F_ISPR[31]) F_VECADDR <= 5'h1F;
		else F_VECADDR <= 5'h00;
`endif
	end
end
endmodule
