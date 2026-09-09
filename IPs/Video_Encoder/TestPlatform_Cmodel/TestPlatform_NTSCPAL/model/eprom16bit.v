`timescale 1ns/10ps
module prom16bit (addr, romdata, oeb, csb);
input [18:0] addr;
input oeb, csb;
output [15:0] romdata;

parameter wid = 16 ; // data width
//parameter size = 524288; // ROM size, 1MB
parameter size = 1048576; // ROM size, 2MB

wire f15, f14, f13, f12, f11, f10, f9, f8;
wire f7, f6, f5, f4, f3, f2, f1, f0;

reg [wid-1:0] fmem[size-1:0];

initial $readmemh ("./rom/program.rom", fmem);

wire doen = ~oeb & ~csb;

assign #7 romdata = (doen) ? { f15, f14, f13, f12, f11, f10, f9, f8,
		               f7, f6, f5, f4, f3, f2, f1, f0 } : 16'bz;

assign { f15, f14, f13, f12, f11, f10, f9, f8,
	 f7, f6, f5, f4, f3, f2, f1, f0} = $getpattern (fmem[addr]);

endmodule
