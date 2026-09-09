// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/SRL16E.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: 16 bit Shift Register LUT with Clock Enable

*/

`timescale  100 ps / 10 ps

`celldefine

module SRL16E (Q, A0, A1, A2, A3, CE, CLK, D);

    parameter cds_action = "ignore";

    parameter INIT = 16'h0000;

    output Q;

    input  A0, A1, A2, A3, CE, CLK, D;

    reg  [5:0]  count;
    reg  [15:0] data;
    wire [3:0]  addr;
    wire	q_int;

    buf b_a3 (addr[3], A3);
    buf b_a2 (addr[2], A2);
    buf b_a1 (addr[1], A1);
    buf b_a0 (addr[0], A0);

    buf b_q_int (q_int, data[addr]);
    buf b_q (Q, q_int);

    initial
    begin
	while (CLK === 1'bx)
	    #2;
	for (count = 0; count < 16; count = count + 1)
	    data[count] <= INIT[count];
    end

    always @(posedge CLK)
    begin
	if (CE == 1'b1) begin
	    {data[15:0]} <= {data[14:0], D};
	end
    end

    specify
	if (CE)
	    (CLK => Q) = (1, 1);
    endspecify

endmodule

`endcelldefine
