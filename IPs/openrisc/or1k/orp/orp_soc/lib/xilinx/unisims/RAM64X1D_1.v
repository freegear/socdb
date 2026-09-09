// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RAM64X1D_1.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: 64x1 Dual Port Static RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps

`celldefine

module RAM64X1D_1 (DPO, SPO, A0, A1, A2, A3, A4, A5, D, DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5, WCLK, WE);

    parameter cds_action = "ignore";

    parameter INIT = 64'h0000000000000000;

    output DPO, SPO;

    input  A0, A1, A2, A3, A4, A5, D, DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5, WCLK, WE;

    reg  mem [63:0];
    reg  [6:0] count;
    wire [5:0] adr;
    wire [5:0] dpr_adr;
    wire d_in, wclk_in, we_in;

    buf b_d    (d_in, D);
    buf b_wclk (wclk_in, WCLK);
    buf b_we   (we_in, WE);

    buf b_a5 (adr[5], A5);
    buf b_a4 (adr[4], A4);
    buf b_a3 (adr[3], A3);
    buf b_a2 (adr[2], A2);
    buf b_a1 (adr[1], A1);
    buf b_a0 (adr[0], A0);

    buf b_d5 (dpr_adr[5], DPRA5);
    buf b_d4 (dpr_adr[4], DPRA4);
    buf b_d3 (dpr_adr[3], DPRA3);
    buf b_d2 (dpr_adr[2], DPRA2);
    buf b_d1 (dpr_adr[1], DPRA1);
    buf b_d0 (dpr_adr[0], DPRA0);

    buf b_spo (SPO, spo_int);
    buf b_dpo (DPO, dpo_int);

    buf b_spo_int (spo_int, mem[adr]);
    buf b_dpo_int (dpo_int, mem[dpr_adr]);

    initial begin
	for (count = 0; count < 64; count = count + 1)
	    mem[count] <= INIT[count];

    end

    always @(negedge wclk_in) begin
	if (we_in == 1'b1)
	    mem[adr] <= d_in;
    end

    specify
	if (WE)
	    (WCLK => SPO) = (1, 1);
	if (WE)
	    (WCLK => DPO) = (1, 1);

	(A5 => SPO) = (1, 1);
	(A4 => SPO) = (1, 1);
	(A3 => SPO) = (1, 1);
	(A2 => SPO) = (1, 1);
	(A1 => SPO) = (1, 1);
	(A0 => SPO) = (1, 1);

	(DPRA5 => DPO) = (1, 1);
	(DPRA4 => DPO) = (1, 1);
	(DPRA3 => DPO) = (1, 1);
	(DPRA2 => DPO) = (1, 1);
	(DPRA1 => DPO) = (1, 1);
	(DPRA0 => DPO) = (1, 1);
    endspecify

endmodule

`endcelldefine
