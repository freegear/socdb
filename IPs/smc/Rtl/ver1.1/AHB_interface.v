// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AHB_interface.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : sram controller
//  =============================================================================
`timescale 1ns/10ps
`define BANK_SIZE 4
module AHB_interface (
	HCLK      ,
	HRESETn   ,
	HADDR     ,
	HTRANS    ,
	HWRITE    ,
	HSIZE     ,
	HWDATA    ,
	HSEL0     ,
	HSEL1	  ,
	HSEL2     ,
	HSEL3     ,
	HREADY_in ,
	HREADY_out,
	HRESP     ,
	HRDATA	  ,
	
	// SRAM_CTRL SIGNAL
	READY	  ,
	RDATA     ,
	ADDR      ,
	WDATA     ,
	WRITE     ,
	READ	  ,
	BANK_SEL  ,
	SRAM_START,
	TRANS_SIZE);
	

input					HCLK      ;
input					HRESETn   ;
input [19:0]			HADDR     ;
input [ 1:0]			HTRANS    ;
input					HWRITE    ;
input [ 2:0]			HSIZE     ;
input [31:0]			HWDATA    ;
input					HSEL0     ;
input					HSEL1	  ;
input		    		HSEL2     ;
input					HSEL3     ;
input					HREADY_in ;
output					HREADY_out;
output[ 1:0]			HRESP     ;
output[31:0]			HRDATA    ;	  

input 					READY	  ;
input [31:0]			RDATA     ;
output[19:0]			ADDR      ;
output[31:0]			WDATA     ;
output					WRITE     ;
output					READ      ;
output[`BANK_SIZE-1:0]	BANK_SEL  ;
output					SRAM_START;
output[ 2:0]			TRANS_SIZE;


wire[`BANK_SIZE-1:0]    b_sel;
reg [`BANK_SIZE-1:0]	BANK_SEL;
reg			SRAM_START;
reg			l_hwrite;

reg [2 :0]	l_hsize;
wire[2 :0]	TRANS_SIZE;

reg [19:0]	l_addr;
reg [19:0]	ADDR;

reg	[1:0] 	l_htrans;

reg [4:0]	ns;
reg [4:0] 	cs;

parameter	IDLE      = 5'b00001;
parameter	R_ADDR    = 5'b00010;
parameter	W_ADDR    = 5'b00100;
parameter	W_DATA    = 5'b01000;
parameter	OPERATION = 5'b10000;


//  ================================================
//			control logic
//  ================================================
assign select = (|b_sel);
assign go_r_addr = select & (|HTRANS) & HREADY_in & HREADY_out & (~HWRITE);
assign go_w_addr = select & (|HTRANS) & HREADY_in & HREADY_out & HWRITE;
assign go_idle   = HREADY_out;//(~select) & HREADY_out;
//  ================================================
//			current_state
//  ================================================
always @(posedge HCLK or negedge HRESETn)
begin
	if(!HRESETn) cs <= IDLE;
	else cs <= ns;
end

//  ================================================
//			next_state
//  ================================================
always @(cs or go_r_addr or go_w_addr or go_idle)
begin
	case(cs)
		IDLE      : begin
			SRAM_START<=1'b0;
			if(go_r_addr) ns<=R_ADDR;
			else if(go_w_addr) ns<=W_ADDR;
			else ns<=IDLE;
		end
		R_ADDR    : begin
			SRAM_START<=1'b1;
			ns<=OPERATION;
		end
		W_ADDR    : begin
			SRAM_START<=1'b1;
			ns<=W_DATA;
		end
		W_DATA    : begin
			SRAM_START<=1'b1;
			ns<=OPERATION;
		end
		OPERATION : begin
			if(go_r_addr & HREADY_in) begin
				ns<=R_ADDR;
				SRAM_START<=1'b0;
			end
			else if(go_w_addr & HREADY_in) begin
				 ns<=W_ADDR;
				SRAM_START<=1'b0;
			end
			else if(go_idle) begin 
				ns<=IDLE;
				SRAM_START<=1'b0;
			end
			else begin
				ns<=OPERATION;	
				SRAM_START<=1'b1;
			end
		end
		default   : begin
			ns<=IDLE;
			SRAM_START<=1'b0;
		end
	endcase
end


//  ================================================
//			output logic
//  ================================================
assign HREADY_out = READY;
assign b_sel = {HSEL3,HSEL2,HSEL1,HSEL0};
assign WRITE = l_hwrite;
assign READ  = ~l_hwrite;
//assign ADDR  = l_addr;
assign TRANS_SIZE = l_hsize;

assign WDATA  = HWDATA;
assign HRDATA = RDATA;
assign HRESP  = 2'b00;

always @(posedge HCLK or negedge HRESETn)
begin
	if(!HRESETn) begin  
		l_addr<=0;
		l_hsize<=0;
		l_htrans<=0;
		l_hwrite<=0;
		BANK_SEL<=0;
	end
	else begin
		if(HREADY_out) begin
			l_addr<=HADDR;
			l_hsize<=HSIZE;
			l_htrans<=HTRANS;	
			l_hwrite<=HWRITE;
			BANK_SEL<=b_sel;
		end
	end
end

always @(l_hsize or l_addr)
begin
	case(l_hsize)
		2'b00   : ADDR <= l_addr;
		2'b01   : ADDR <={l_addr[19:1],1'b0 };
		2'b10	: ADDR <={l_addr[19:2],2'b00};
		default : ADDR <=ADDR; 
	endcase
end
endmodule