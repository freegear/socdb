// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SSRAM32bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps
`define TEST

module RA1SH16384x32(
    				CLK, 
`ifdef TEST
					nRST, 
`endif
					CEN, WEN, A, D, Q
);

parameter aw = 14;
parameter dw = 32;

input           CLK;    // Clock
`ifdef TEST
input           nRST;   // Reset
`endif
input           CEN;    // Chip enable input
input   [ 3:0]  WEN;    // Write enable input
input   [aw-1:0]    A;  // address bus inputs
input   [dw-1:0]    D;  // input data bus
output  [dw-1:0]    Q;  // output data bus

reg     [dw/4-1:0]    mem0 [({aw{1'b1}})-1:0];
reg     [dw/4-1:0]    mem1 [({aw{1'b1}})-1:0];
reg     [dw/4-1:0]    mem2 [({aw{1'b1}})-1:0];
reg     [dw/4-1:0]    mem3 [({aw{1'b1}})-1:0];
reg     [dw-1:0] Q;

integer i;

`ifdef TEST
always @(negedge nRST or posedge CLK)
    if (!nRST) begin
        for(i=0;i<16384;i=i+1) begin
			mem0[i] <= 0;
			mem1[i] <= 0;
			mem2[i] <= 0;
			mem3[i] <= 0;
		end
        Q <= 0;
    end
    else begin
        if (!CEN && &WEN)
            Q <= #1 {mem3[A], mem2[A], mem1[A], mem0[A]};
        else if (!CEN && !WEN[0]) begin
            mem0[A] <= #1 D[7:0];
            Q[7:0] <= #1 D[7:0];
        end
        else if (!CEN && !WEN[1]) begin
            mem1[A] <= #1 D[15:8];
            Q[15:8] <= #1 D[15:8];
        end
        else if (!CEN && !WEN[2]) begin
            mem2[A] <= #1 D[23:16];
            Q[23:16] <= #1 D[23:16];
        end
        else if (!CEN && !WEN[3]) begin
            mem3[A] <= #1 D[31:24];
            Q[31:24] <= #1 D[31:24];
        end
    end

always @(negedge nRST or posedge CLK)
    if (!nRST) begin
        for(i=0;i<16384;i=i+1) begin
			mem0[i] <= 0;
		end
	end
    else if (!CEN & ~WEN[0]) begin
			mem0[A] <= #1 D[7:0];
			//Q[ 7:0] <= #1 D[7:0];
	end

always @(negedge nRST or posedge CLK)
    if (!nRST) begin
        for(i=0;i<16384;i=i+1) begin
			mem1[i] <= 0;
		end
	end
    else if (!CEN & ~WEN[1]) begin
			mem1[A] <= #1 D[15:8];
			//Q[15:8] <= #1 D[15:8];
	end

always @(negedge nRST or posedge CLK)
    if (!nRST) begin
        for(i=0;i<16384;i=i+1) begin
			mem2[i] <= 0;
		end
	end
    else if (!CEN & ~WEN[2]) begin
			mem2[A] <= #1 D[23:16];
			//Q[23:16]<= #1 D[23:16];
	end

always @(negedge nRST or posedge CLK)
    if (!nRST) begin
        for(i=0;i<16384;i=i+1) begin
			mem3[i] <= 0;
		end
	end
    else if (!CEN & ~WEN[3]) begin
			mem3[A] <= #1 D[31:24];
			//Q[31:24]<= #1 D[31:24];
	end


always @(negedge nRST or posedge CLK)
    if (!nRST)    
    		Q <= 0;
    else if (!CEN)// && (&WEN))
            Q <= #1 {mem3[A], mem2[A], mem1[A], mem0[A]};
`else
always @(posedge CLK)
	if (!CEN & ~WEN[0]) begin
		mem0[A] <= #1 D[7:0];
		//Q[ 7:0] <= #1 D[7:0];
	end
always @(posedge CLK)
	if (!CEN & ~WEN[1]) begin
		mem1[A] <= #1 D[15:8];
		//Q[15:8] <= #1 D[15:8];
	end
always @(posedge CLK)
	if (!CEN & ~WEN[2]) begin
		mem2[A] <= #1 D[23:16];
		//Q[23:16]<= #1 D[23:16];
	end
always @(posedge CLK)
	if (!CEN & ~WEN[3]) begin
		mem3[A] <= #1 D[31:24];
		//Q[31:24]<= #1 D[31:24];
	end


always @(posedge CLK)
    if (!CEN)// && (&WEN))
        Q <= #1 {mem3[A], mem2[A], mem1[A], mem0[A]};
`endif

endmodule

