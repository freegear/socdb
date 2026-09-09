
module sram16bit ( data, addr, wrb_0, wrb_1, rdb, csb );
inout  [15:0] data;
//input  [14:0] addr;
input  [17:0] addr;
input  wrb_0, wrb_1, rdb, csb;
    wire cs_0A, cs_1A;

    sram8bit u0 ( .data(data[7:0]), .addr(addr[17:0]), .we_n(wrb_0), .oe_n(rdb), 
        .cs_n(cs_0A) );
    sram8bit u1 ( .data(data[15:8]), .addr(addr[17:0]), .we_n(wrb_1), .oe_n(rdb), 
        .cs_n(cs_1A) );

    assign cs_0A =  csb;
    assign cs_1A =  csb;
   
endmodule

