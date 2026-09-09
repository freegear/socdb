module MULTISRAM(
        data0,
        data1,
        waddr0,
        waddr1,
        raddr,
        we0,we1,
        clk0,clk1,
        q1);

parameter d_width    = 32;
parameter addr_width = 5;
parameter mem_depth  = 32;

input   [31:0] data0, data1;
input   [4:0] waddr0, waddr1, raddr;
input   we0, we1, clk0, clk1;

output  [31:0] q1;


MULTISRAM8bit sram0
(
        .data0(data0[7:0]),
        .data1(data1[7:0]),
        .waddr0(waddr0),
        .waddr1(waddr1),
        .raddr(raddr),
        .we0(we0),
        .we1(we1),
        .clk0(clk0),
        .clk1(clk1),
        .q1(q1[7:0])
);

MULTISRAM8bit sram1
(
        .data0(data0[15:8]),
        .data1(data1[15:8]),
        .waddr0(waddr0),
        .waddr1(waddr1),
        .raddr(raddr),
        .we0(we0),
        .we1(we1),
        .clk0(clk0),
        .clk1(clk1),
        .q1(q1[15:8])
);

MULTISRAM8bit sram2
(
        .data0(data0[23:16]),
        .data1(data1[23:16]),
        .waddr0(waddr0),
        .waddr1(waddr1),
        .raddr(raddr),
        .we0(we0),
        .we1(we1),
        .clk0(clk0),
        .clk1(clk1),
        .q1(q1[23:16])
);

MULTISRAM8bit sram3
(
        .data0(data0[31:24]),
        .data1(data0[31:24]),
        .waddr0(waddr0),
        .waddr1(waddr1),
        .raddr(raddr),
        .we0(we0),
        .we1(we1),
        .clk0(clk0),
        .clk1(clk1),
        .q1(q1[31:24])
);

endmodule

