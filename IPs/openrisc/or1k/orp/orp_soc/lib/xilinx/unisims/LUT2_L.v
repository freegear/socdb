// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LUT2_L.v,v 1.1 2002/03/28 20:15:28 lampret Exp $
/*

FUNCTION	: 2-inputs LUT

*/

`timescale  100 ps / 10 ps

`celldefine

module LUT2_L (LO, I0, I1);

    parameter INIT = 4'h0;

    input I0, I1;

    output LO;

    wire out;

    lut2_l_mux4 (out, INIT[3], INIT[2], INIT[1], INIT[0], I1, I0);

    buf b3 (LO, out);

    specify
	(I0 *> LO) = (1, 1);
	(I1 *> LO) = (1, 1);
    endspecify

endmodule

`endcelldefine

primitive lut2_l_mux4 (o, d3, d2, d1, d0, s1, s0);

  output o;
  input d3, d2, d1, d0;
  input s1, s0;

  table

    // d3  d2  d1  d0  s1  s0 : o;

       ?   ?   ?   1   0   0  : 1;
       ?   ?   ?   0   0   0  : 0;
       ?   ?   1   ?   0   1  : 1;
       ?   ?   0   ?   0   1  : 0;
       ?   1   ?   ?   1   0  : 1;
       ?   0   ?   ?   1   0  : 0;
       1   ?   ?   ?   1   1  : 1;
       0   ?   ?   ?   1   1  : 0;

       ?   ?   0   0   0   x  : 0;
       ?   ?   1   1   0   x  : 1;
       0   0   ?   ?   1   x  : 0;
       1   1   ?   ?   1   x  : 1;

       ?   0   ?   0   x   0  : 0;
       ?   1   ?   1   x   0  : 1;
       0   ?   0   ?   x   1  : 0;
       1   ?   1   ?   x   1  : 1;

       0   0   0   0   x   x  : 0;
       1   1   1   1   x   x  : 1;

  endtable

endprimitive
