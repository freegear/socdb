// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LUT4_D.v,v 1.1 2002/03/28 20:15:28 lampret Exp $
/*

FUNCTION	: 4-inputs LUT

*/

`timescale  100 ps / 10 ps

`celldefine

module LUT4_D (LO, O, I0, I1, I2, I3);

    parameter INIT = 16'h0000;

    input I0, I1, I2, I3;

    output LO, O;

    wire out0, out1, out2, out3, out;

    lut4_d_mux4 (out3, INIT[15], INIT[14], INIT[13], INIT[12], I1, I0);
    lut4_d_mux4 (out2, INIT[11], INIT[10], INIT[9], INIT[8], I1, I0);
    lut4_d_mux4 (out1, INIT[7], INIT[6], INIT[5], INIT[4], I1, I0);
    lut4_d_mux4 (out0, INIT[3], INIT[2], INIT[1], INIT[0], I1, I0);
    lut4_d_mux4 (out, out3, out2, out1, out0, I3, I2);

    buf b4 (LO, out);
    buf b5 (O, out);

    specify
	(I0 *> LO) = (1, 1);
	(I1 *> LO) = (1, 1);
	(I2 *> LO) = (1, 1);
	(I3 *> LO) = (1, 1);

	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
	(I3 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine

primitive lut4_d_mux4 (O, d3, d2, d1, d0, s1, s0);

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
