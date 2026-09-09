// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ROM16X1.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: ROM 16x1

*/

`timescale  100 ps / 10 ps

`celldefine

module ROM16X1 (O, A0, A1, A2, A3);

    parameter cds_action = "ignore";
    parameter INIT = 16'h0000;

    output O;

    input  A0, A1, A2, A3;

    wire [3:0] adr;
    wire dout;

    reg  mem [0:15];
    reg  [4:0] count;

    buf b1 (adr[3], A3);
    buf b2 (adr[2], A2);
    buf b3 (adr[1], A1);
    buf b4 (adr[0], A0);
    buf b5 (O, dout);

    initial begin
	for(count = 0; count < 16; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A3 => O) = (1, 1);
	(A2 => O) = (1, 1);
	(A1 => O) = (1, 1);
	(A0 => O) = (1, 1);
    endspecify

endmodule

`endcelldefine
