// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/DECODE8.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: 8-INPUT Decoder

*/

`timescale  100 ps / 10 ps

`celldefine

module DECODE8 (O, A0, A1, A2, A3, A4, A5, A6, A7 );

    output O;
    wand   O;

    input  A0;
    input  A1;
    input  A2;
    input  A3;
    input  A4;
    input  A5;
    input  A6;
    input  A7;

    WAND1 W0 (.I(A0), .O(O));
    WAND1 W1 (.I(A1), .O(O));
    WAND1 W2 (.I(A2), .O(O));
    WAND1 W3 (.I(A3), .O(O));
    WAND1 W4 (.I(A4), .O(O));
    WAND1 W5 (.I(A5), .O(O));
    WAND1 W6 (.I(A6), .O(O));
    WAND1 W7 (.I(A7), .O(O));

endmodule

`endcelldefine
