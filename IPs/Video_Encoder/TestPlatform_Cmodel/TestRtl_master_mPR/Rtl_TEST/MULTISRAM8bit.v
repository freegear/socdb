module MULTISRAM8bit(
        data0,
        data1,
        waddr0,
        waddr1,
        raddr,
        we0,we1,
        clk0,clk1,
        q1);

parameter d_width    = 8;
parameter addr_width = 5;
parameter mem_depth  = 32;

input   [7:0] data0, data1;
input   [4:0] waddr0, waddr1, raddr;
input   we0, we1, clk0, clk1;

output  [7:0] q1;

reg [7:0] q1;
reg [7:0] mem [mem_depth-1:0] /* synthesis syn_ramstyle="no_rw_check¡± */; 


always @(posedge clk0)
begin
    if (we0) mem[waddr0] <= data0;
end

always @(posedge clk1)
begin
    //if (we1) mem[waddr1] <= data1;
	q1 = mem[raddr];
end

endmodule
