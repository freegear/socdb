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
`define     fruit
`define     SIZE 2048*2048*3
module SRCRAM 
(
		CLK     , 

        ADDR    ,
		CEn     ,
		WEn     ,
		RDATA   ,
		WDATA
);

//
// module parameter
//
parameter ADDR_WIDTH = 25;	// Memory Address Width : should be at least 12(4KB)
parameter DATA_WIDTH = 64;
parameter BYTE_NUM = (DATA_WIDTH/8);
    
input  CLK;
input  [ADDR_WIDTH-1:0] ADDR;
input  CEn;
input  [BYTE_NUM-1:0] WEn;
input  [DATA_WIDTH-1:0] WDATA;
output [DATA_WIDTH-1:0] RDATA;

//reg [DATA_WIDTH-1:0] memory[{ADDR_WIDTH{1'b1}}:0];

reg [DATA_WIDTH-1:0] RDATA;

reg[7:0] src_mem[`SIZE:0];

reg[2:0] bpp_type;

initial 
begin
    bpp_type = 4;
    `ifdef fruit
        if(bpp_type==1)      $readmemh("fruit_u555.dat",src_mem);//1555(Unused RGB)16bpp
        else if(bpp_type==2) $readmemh("fruit_565_0.dat",src_mem);//565(RGB)       16bpp_type
        else if(bpp_type==3) $readmemh("fruit_888.dat",src_mem);//888(RGB)         24bpp_type
        else if(bpp_type==4) $readmemh("fruit_u888.dat",src_mem);//unused 888(RGB) 32bpp_type
        else if(bpp_type==5) $readmemh("fruit_8888.dat",src_mem);//8888(ARGB)      32bpp_type
    `else

        if(bpp_type==1)      $readmemh("input_u555.dat",src_mem);//1555(Unused RGB)16bpp
        else if(bpp_type==2) $readmemh("input_565_0.dat",src_mem);//565(RGB)       16bpp_type
        else if(bpp_type==3) $readmemh("input_888.dat",src_mem);//888(RGB)         24bpp_type
        else if(bpp_type==4) $readmemh("input_u888.dat",src_mem);//unused 888(RGB) 32bpp_type
        else if(bpp_type==5) $readmemh("input_8888.dat",src_mem);//8888(ARGB)      32bpp_type

    `endif
end

wire[ADDR_WIDTH-1:0] iaddr;

assign iaddr = {ADDR,3'b000};
always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
		RDATA = {src_mem[iaddr+7],src_mem[iaddr+6],src_mem[iaddr+5],src_mem[iaddr+4],
                 src_mem[iaddr+3],src_mem[iaddr+2],src_mem[iaddr+1],src_mem[iaddr+0] };
	end
end

endmodule
