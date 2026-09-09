// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RAM64X2S.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: 64x2 Static RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps

`celldefine

module RAM64X2S (O0, O1, A0, A1, A2, A3, A4, A5, D0, D1, WCLK, WE);

    parameter cds_action = "ignore";

    parameter INIT_00 = 64'h0000000000000000;
    parameter INIT_01 = 64'h0000000000000000;

    output O0, O1;

    input  A0, A1, A2, A3, A4, A5, D0, D1, WCLK, WE;

    reg  mem [128:0];
    reg  [8:0] count;
    wire [5:0] adr;
    wire [1:0] d_in, o_out;
    wire wclk_in, we_in;

    buf b_d0   (d_in[0], D0);
    buf b_d1   (d_in[1], D1);
    buf b_wclk (wclk_in, WCLK);
    buf b_we   (we_in, WE);

    buf b_a5 (adr[5], A5);
    buf b_a4 (adr[4], A4);
    buf b_a3 (adr[3], A3);
    buf b_a2 (adr[2], A2);
    buf b_a1 (adr[1], A1);
    buf b_a0 (adr[0], A0);

    buf b_o0 (O0, o_out[0]);
    buf b_o1 (O1, o_out[1]);

    buf b_o_out0 (o_out[0], mem[adr + 64 * 0]);
    buf b_o_out1 (o_out[1], mem[adr + 64 * 1]);

    initial begin
	for (count = 0; count < 64; count = count + 1) begin
	    mem[count + 64 * 0] <= INIT_00[count];
	    mem[count + 64 * 1] <= INIT_01[count];
	end
    end

    always @(posedge wclk_in) begin
	if (we_in == 1'b1) begin
	    mem[adr + 64 * 0] <= d_in[0];
	    mem[adr + 64 * 1] <= d_in[1];
	end
    end

    specify
	if (WE)
	    (WCLK => O0) = (1, 1);
	if (WE)
	    (WCLK => O1) = (1, 1);

	(A5 => O0) = (1, 1);
	(A4 => O0) = (1, 1);
	(A3 => O0) = (1, 1);
	(A2 => O0) = (1, 1);
	(A1 => O0) = (1, 1);
	(A0 => O0) = (1, 1);
	(A5 => O1) = (1, 1);
	(A4 => O1) = (1, 1);
	(A3 => O1) = (1, 1);
	(A2 => O1) = (1, 1);
	(A1 => O1) = (1, 1);
	(A0 => O1) = (1, 1);
    endspecify

endmodule

`endcelldefine
