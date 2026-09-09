// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ROM32X1.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: ROM 32x1

*/

`timescale  100 ps / 10 ps

`celldefine

module ROM32X1 (O, A0, A1, A2, A3, A4);

    parameter cds_action = "ignore";
    parameter INIT = 32'h00000000;

    output O;

    input  A0, A1, A2, A3, A4;

    wire dout;
    wire [4:0] adr;

    reg mem [0:31];
    reg  [5:0] count;

    buf b0 (adr[4], A4);
    buf b1 (adr[3], A3);
    buf b2 (adr[2], A2);
    buf b3 (adr[1], A1);
    buf b4 (adr[0], A0);
    buf b5 (O, dout);

    initial begin
	for(count = 0; count < 32; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A4 => O) = (1, 1);
	(A3 => O) = (1, 1);
	(A2 => O) = (1, 1);
	(A1 => O) = (1, 1);
	(A0 => O) = (1, 1);
    endspecify

endmodule

`endcelldefine
