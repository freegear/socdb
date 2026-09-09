`timescale 1ns/10ps
module prom8bit (addr, romdata, oeb, csb);
input [20:0] addr;
input oeb, csb;
output [7:0] romdata;

parameter wid = 8 ; // data width
//parameter size = 1048576; // ROM size, 1MB
parameter size = 2097152; // ROM size, 2MB

wire f7, f6, f5, f4, f3, f2, f1, f0;

reg [wid-1:0] fmem[size-1:0];

initial $readmemh ("./rom/program.rom", fmem);

wire doen = ~oeb & ~csb;

assign #7 romdata = (doen) ? { f7, f6, f5, f4, f3, f2, f1, f0 } : 8'bz;

assign {f7, f6, f5, f4, f3, f2, f1, f0} = $getpattern (fmem[addr]);

endmodule
