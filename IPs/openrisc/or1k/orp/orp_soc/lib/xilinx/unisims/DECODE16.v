// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/DECODE16.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: 16-INPUT Decoder

*/

`timescale  100 ps / 10 ps

`celldefine

module DECODE16 (O, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15 );

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
  input  A8;
  input  A9;
  input  A10;
  input  A11;
  input  A12;
  input  A13;
  input  A14;
  input  A15;

  WAND1 W0 (.I(A0), .O(O));
  WAND1 W1 (.I(A1), .O(O));
  WAND1 W2 (.I(A2), .O(O));
  WAND1 W3 (.I(A3), .O(O));
  WAND1 W4 (.I(A4), .O(O));
  WAND1 W5 (.I(A5), .O(O));
  WAND1 W6 (.I(A6), .O(O));
  WAND1 W7 (.I(A7), .O(O));
  WAND1 W8 (.I(A8), .O(O));
  WAND1 W9 (.I(A9), .O(O));
  WAND1 W10 (.I(A10), .O(O));
  WAND1 W11 (.I(A11), .O(O));
  WAND1 W12 (.I(A12), .O(O));
  WAND1 W13 (.I(A13), .O(O));
  WAND1 W14 (.I(A14), .O(O));
  WAND1 W15 (.I(A15), .O(O));

endmodule

`endcelldefine
