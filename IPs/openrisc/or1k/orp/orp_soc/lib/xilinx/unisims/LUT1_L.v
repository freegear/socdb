// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LUT1_L.v,v 1.1 2002/03/28 20:15:28 lampret Exp $
/*

FUNCTION	: 2-inputs LUT

*/

`timescale  100 ps / 10 ps

`celldefine

module LUT1_L (LO, I0);

    parameter INIT = 2'h0;

    input I0;

    output LO;

    wire out;

    lut1_l_mux2 (out, INIT[1], INIT[0], I0);

    buf b1 (LO, out);

    specify
	(I0 *> LO) = (1, 1);
    endspecify

endmodule

`endcelldefine

primitive lut1_l_mux2 (o, d1, d0, s0);

  output o;
  input d1, d0;
  input s0;

  table

    // d1  d0  s0 : o;

       ?   1   0  : 1;
       ?   0   0  : 0;
       1   ?   1  : 1;
       0   ?   1  : 0;
       0   0   x  : 0;
       1   1   x  : 1;

  endtable

endprimitive
