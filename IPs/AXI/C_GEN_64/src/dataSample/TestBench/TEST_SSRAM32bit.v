// ==============================================================================
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

module ?NAME?_SSRAM32bit 
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
parameter BUS_WID    = 32;
parameter NUM_BYTE   = BUS_WID/8;

input  CLK;
input  [ADDR_WIDTH-1:0] ADDR;
input  CEn;
input  [NUM_BYTE-1:0] WEn;
input  [BUS_WID-1:0] WDATA;
output [BUS_WID-1:0] RDATA;

wire   [ADDR_WIDTH-1:0] wDIFFDATA = (BUS_WID == 32) ? WDATA[BUS_WID-1:2] : WDATA[BUS_WID-1:3];

reg [BUS_WID-1:0] RDATA;

integer i;
always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
        if(WEn == 4'd0)
        begin
            if((ADDR != wDIFFDATA) && (WEn == {NUM_BYTE{1'b0}}))
            begin
	            $display("Write data is not correct(Slave :: ?NAME?)");
                $stop;
            end
        end
        else begin
            if(BUS_WID == 32) begin
                RDATA <= {ADDR, 2'd0};
            end
            else begin
                RDATA <= {ADDR, 3'd0};
            end
        end
	end
end

endmodule
//STATE_END
