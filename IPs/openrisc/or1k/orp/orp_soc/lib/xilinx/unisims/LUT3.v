// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LUT3.v,v 1.1 2002/03/28 20:15:28 lampret Exp $
/*

FUNCTION	: 3-inputs LUT

*/

`timescale  100 ps / 10 ps

`celldefine

module LUT3 (O, I0, I1, I2);

    parameter INIT = 8'h00;

    input I0, I1, I2;

    output O;

    wire out0, out1, out;

    lut3_mux4 (out1, INIT[7], INIT[6], INIT[5], INIT[4], I1, I0);
    lut3_mux4 (out0, INIT[3], INIT[2], INIT[1], INIT[0], I1, I0);
    lut3_mux4 (out, 1'b0, 1'b0, out1, out0, 1'b0, I2);

    buf b3 (O, out);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine

primitive lut3_mux4 (O, d3, d2, d1, d0, s1, s0);

  output O;
  input d3, d2, d1, d0;
  input s1, s0;

  table

    // d3  d2  d1  d0  s1  s0 : O;

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
