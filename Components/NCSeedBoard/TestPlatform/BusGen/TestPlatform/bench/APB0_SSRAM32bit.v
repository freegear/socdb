//START
// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Test SSRAM32bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps

module APB0_SSRAM32bit 
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
parameter ADDR_WIDTH = 30;	
        // Memory Address Width : only 32bit test mode support

input  CLK;
input  [ADDR_WIDTH-1:0] ADDR;
input  CEn;
input  [3:0] WEn;
input  [31:0] WDATA;
output [31:0] RDATA;

reg [31:0] RDATA;

integer i;
always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
        if(WEn == 4'd0)
        begin
            if((ADDR != WDATA[31:2]) && (WEn == 4'd0))
            begin
	            $display("Write data is not correct(Slave :: APB0)");
                $stop;
            end
        end
        else
            RDATA <= {ADDR, 2'b00};
	end
end

endmodule
