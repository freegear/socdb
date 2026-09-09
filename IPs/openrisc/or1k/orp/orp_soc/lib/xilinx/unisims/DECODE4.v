// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/DECODE4.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: 4-INPUT Decoder

*/

`timescale  100 ps / 10 ps

`celldefine

module DECODE4 (O, A0, A1, A2, A3 );

    output O;
    wand   O;

    input  A0;
    input  A1;
    input  A2;
    input  A3;

    WAND1 W0 (.I(A0), .O(O));
    WAND1 W1 (.I(A1), .O(O));
    WAND1 W2 (.I(A2), .O(O));
    WAND1 W3 (.I(A3), .O(O));

endmodule

`endcelldefine
