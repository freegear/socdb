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
`define	SIZE	{24{1'b1}}

module VIF_SSRAM32bit 
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

reg	    [31:0] DATA [0:`SIZE];
wire    [31:0] inDATA;

assign  inDATA = DATA[ADDR];

reg FlagReadRam;
integer    DumpRGB;
integer    DumpDATA;

initial
begin
    i = 0;
    FlagReadRam = 0;
    DumpRGB     = $fopen("./Dump/VIFRGB.out");
    DumpDATA    = $fopen("./Dump/VIFDATA.out");
end


always @(posedge CLK)
begin

    if(FlagReadRam == 1'b0 && VideoEncTop.Core.ENABLE == 1'b1) begin
        FlagReadRam = 1'b1;
        if(VideoEncTop.Core.NTSC_PAL == 1'b0) begin
            $display (" NTSC mode read rom \n ");
	        $readmemh ("./input/colorbar_720x480n.rom",DATA);
        end
        else begin
            $display (" PAL mode read rom \n ");
	        $readmemh ("./input/colorbar_720x576n.rom",DATA);
        end
    end

	if(CEn == 1'b0)
	begin
        if(WEn == 4'd0)
        begin
            $fwrite(DumpDATA, "%d %x \n", ADDR, WDATA);
            $fwrite(DumpRGB,  "%x \n", WDATA);
        end
        else
        begin
            RDATA <= inDATA;
        end
	end
end

endmodule
