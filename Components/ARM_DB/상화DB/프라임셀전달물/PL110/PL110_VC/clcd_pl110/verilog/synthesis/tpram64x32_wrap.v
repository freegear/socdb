//----------------------Revision History-------------------------------------------
// 02-Sep-99, 1.0, Sergey Roudnik,  Copy from tp4 and update for new
//                                  functionnality
// 21-Feb-00, 1.1, Sergey Roudnik,  Fix for D/E 15681 : verilog-XL compilation
//                                  fails for new tsmc18 two port rams.
//---------------------------------------------------------------------------------

`timescale 1ns/100fs


`define numAddr 6
`define numOut 32
`define wordDepth 64

module tpram64x32(RCSB, WCSB, WA, RA, WEB, REB, OEB, DO, DI);


input WEB, REB, OEB, RCSB, WCSB;

input [`numAddr-1:0] RA;
wire  [`numAddr-1:0] ra_state,RA;
    
input [`numAddr-1:0] WA;
wire  [`numAddr-1:0] wa_state,WA;

input [`numOut-1:0] DI;
wire  [`numOut-1:0] di_state,DI;
    
output [`numOut-1:0] DO;
wire   [`numOut-1:0] DO,do_state;

wire read_in_error;
wire write_full_in_error;
wire write_located_in_error;
wire [`numAddr-1:0] wa_del;
wire wa_d5;
wire wa_d4;
wire wa_d3;
wire wa_d2;
wire wa_d1;
wire wa_d0;

endmodule

