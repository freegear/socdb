// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RAMB4_S2_S8.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: 4x2x8 Block RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps

`celldefine

module RAMB4_S2_S8 (DOA, DOB, ADDRA, CLKA, DIA, ENA, RSTA, WEA, ADDRB, CLKB, DIB, ENB, RSTB, WEB);

    parameter cds_action = "ignore";

    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    output [1:0] DOA;
    reg [1:0] doa_out;
    wire doa_out0, doa_out1;

    input [10:0] ADDRA;
    input [1:0] DIA;
    input ENA, CLKA, WEA, RSTA;

    output [7:0] DOB;
    reg [7:0] dob_out;
    wire dob_out0, dob_out1, dob_out2, dob_out3, dob_out4, dob_out5, dob_out6, dob_out7;

    input [8:0] ADDRB;
    input [7:0] DIB;
    input ENB, CLKB, WEB, RSTB;

    reg [4095:0] mem;
    reg [8:0] count;

    reg [5:0] mi, mj, ai, aj, bi, bj, ci, cj;

    wire [10:0] addra_int;
    wire [1:0] dia_int;
    wire ena_int, clka_int, wea_int, rsta_int;
    wire [8:0] addrb_int;
    wire [7:0] dib_int;
    wire enb_int, clkb_int, web_int, rstb_int;

    reg recovery_a, recovery_b;
    reg address_collision;

    wire clka_enable = ena_int && wea_int && enb_int && address_collision;
    wire clkb_enable = enb_int && web_int && ena_int && address_collision;
    wire collision = clka_enable || clkb_enable;

    tri0 GSR = glbl.GSR;

    always @(GSR)
	if (GSR) begin
	    assign doa_out = 0;
	end
	else begin
	    deassign doa_out;
	end

    always @(GSR)
	if (GSR) begin
	    assign dob_out = 0;
	end
	else begin
	    deassign dob_out;
	end

    buf b_doa_out0 (doa_out0, doa_out[0]);
    buf b_doa_out1 (doa_out1, doa_out[1]);
    buf b_dob_out0 (dob_out0, dob_out[0]);
    buf b_dob_out1 (dob_out1, dob_out[1]);
    buf b_dob_out2 (dob_out2, dob_out[2]);
    buf b_dob_out3 (dob_out3, dob_out[3]);
    buf b_dob_out4 (dob_out4, dob_out[4]);
    buf b_dob_out5 (dob_out5, dob_out[5]);
    buf b_dob_out6 (dob_out6, dob_out[6]);
    buf b_dob_out7 (dob_out7, dob_out[7]);
    buf b_doa0 (DOA[0], doa_out0);
    buf b_doa1 (DOA[1], doa_out1);
    buf b_dob0 (DOB[0], dob_out0);
    buf b_dob1 (DOB[1], dob_out1);
    buf b_dob2 (DOB[2], dob_out2);
    buf b_dob3 (DOB[3], dob_out3);
    buf b_dob4 (DOB[4], dob_out4);
    buf b_dob5 (DOB[5], dob_out5);
    buf b_dob6 (DOB[6], dob_out6);
    buf b_dob7 (DOB[7], dob_out7);
    buf b_addra_0 (addra_int[0], ADDRA[0]);
    buf b_addra_1 (addra_int[1], ADDRA[1]);
    buf b_addra_2 (addra_int[2], ADDRA[2]);
    buf b_addra_3 (addra_int[3], ADDRA[3]);
    buf b_addra_4 (addra_int[4], ADDRA[4]);
    buf b_addra_5 (addra_int[5], ADDRA[5]);
    buf b_addra_6 (addra_int[6], ADDRA[6]);
    buf b_addra_7 (addra_int[7], ADDRA[7]);
    buf b_addra_8 (addra_int[8], ADDRA[8]);
    buf b_addra_9 (addra_int[9], ADDRA[9]);
    buf b_addra_10 (addra_int[10], ADDRA[10]);
    buf b_dia_0 (dia_int[0], DIA[0]);
    buf b_dia_1 (dia_int[1], DIA[1]);
    buf b_clka (clka_int, CLKA);
    buf b_ena (ena_int, ENA);
    buf b_rsta (rsta_int, RSTA);
    buf b_wea (wea_int, WEA);
    buf b_addrb_0 (addrb_int[0], ADDRB[0]);
    buf b_addrb_1 (addrb_int[1], ADDRB[1]);
    buf b_addrb_2 (addrb_int[2], ADDRB[2]);
    buf b_addrb_3 (addrb_int[3], ADDRB[3]);
    buf b_addrb_4 (addrb_int[4], ADDRB[4]);
    buf b_addrb_5 (addrb_int[5], ADDRB[5]);
    buf b_addrb_6 (addrb_int[6], ADDRB[6]);
    buf b_addrb_7 (addrb_int[7], ADDRB[7]);
    buf b_addrb_8 (addrb_int[8], ADDRB[8]);
    buf b_dib_0 (dib_int[0], DIB[0]);
    buf b_dib_1 (dib_int[1], DIB[1]);
    buf b_dib_2 (dib_int[2], DIB[2]);
    buf b_dib_3 (dib_int[3], DIB[3]);
    buf b_dib_4 (dib_int[4], DIB[4]);
    buf b_dib_5 (dib_int[5], DIB[5]);
    buf b_dib_6 (dib_int[6], DIB[6]);
    buf b_dib_7 (dib_int[7], DIB[7]);
    buf b_clkb (clkb_int, CLKB);
    buf b_enb (enb_int, ENB);
    buf b_rstb (rstb_int, RSTB);
    buf b_web (web_int, WEB);

    initial begin
	for (count = 0; count < 256; count = count + 1) begin
	    mem[count]		  <= INIT_00[count];
	    mem[256 * 1 + count]  <= INIT_01[count];
	    mem[256 * 2 + count]  <= INIT_02[count];
	    mem[256 * 3 + count]  <= INIT_03[count];
	    mem[256 * 4 + count]  <= INIT_04[count];
	    mem[256 * 5 + count]  <= INIT_05[count];
	    mem[256 * 6 + count]  <= INIT_06[count];
	    mem[256 * 7 + count]  <= INIT_07[count];
	    mem[256 * 8 + count]  <= INIT_08[count];
	    mem[256 * 9 + count]  <= INIT_09[count];
	    mem[256 * 10 + count] <= INIT_0A[count];
	    mem[256 * 11 + count] <= INIT_0B[count];
	    mem[256 * 12 + count] <= INIT_0C[count];
	    mem[256 * 13 + count] <= INIT_0D[count];
	    mem[256 * 14 + count] <= INIT_0E[count];
	    mem[256 * 15 + count] <= INIT_0F[count];
	end
	recovery_a <= 0;
	recovery_b <= 0;
    end

    always @(addra_int or addrb_int) begin
	address_collision <= 1'b0;
	for (ci = 0; ci < 2; ci = ci + 1) begin
	    for (cj = 0; cj < 8; cj = cj + 1) begin
		if ((addra_int * 2 + ci) == (addrb_int * 8 + cj)) begin
		    address_collision <= 1'b1;
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (wea_int == 1 && web_int == 1) begin
	    for (mi = 0; mi < 2; mi = mi + 1) begin
		for (mj = 0; mj < 8; mj = mj + 1) begin
		    if ((addra_int * 2 + mi) == (addrb_int * 8 + mj)) begin
			mem[addra_int * 2 + mi] <= 1'bX;
		    end
		end
	    end
	end
	recovery_a <= 0;
	recovery_b <= 0;
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (web_int == 1 && rsta_int == 0) begin
	    for (ai = 0; ai < 2; ai = ai + 1) begin
		for (aj = 0; aj < 8; aj = aj + 1) begin
		    if ((addra_int * 2 + ai) == (addrb_int * 8 + aj)) begin
			doa_out[ai] <= 1'bX;
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (wea_int == 1 && rstb_int == 0) begin
	    for (bi = 0; bi < 2; bi = bi + 1) begin
		for (bj = 0; bj < 8; bj = bj + 1) begin
		    if ((addra_int * 2 + bi) == (addrb_int * 8 + bj)) begin
			dob_out[bj] <= 1'bX;
		    end
		end
	    end
	end
    end

    always @(posedge clka_int) begin
	if (ena_int == 1'b1) begin
	    if (rsta_int == 1'b1) begin
		doa_out[0] <= 0;
		doa_out[1] <= 0;
	    end
	    else if (wea_int == 0) begin
		doa_out[0] <= mem[addra_int * 2 + 0];
		doa_out[1] <= mem[addra_int * 2 + 1];
	    end
	    else begin
		doa_out[0] <= dia_int[0];
		doa_out[1] <= dia_int[1];
	    end
	end
    end

    always @(posedge clka_int) begin
	if (ena_int == 1'b1 && wea_int == 1'b1) begin
	    mem[addra_int * 2 + 0] <= dia_int[0];
	    mem[addra_int * 2 + 1] <= dia_int[1];
	end
    end

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1) begin
	    if (rstb_int == 1'b1) begin
		dob_out[0] <= 0;
		dob_out[1] <= 0;
		dob_out[2] <= 0;
		dob_out[3] <= 0;
		dob_out[4] <= 0;
		dob_out[5] <= 0;
		dob_out[6] <= 0;
		dob_out[7] <= 0;
	    end
	    else if (web_int == 0) begin
		dob_out[0] <= mem[addrb_int * 8 + 0];
		dob_out[1] <= mem[addrb_int * 8 + 1];
		dob_out[2] <= mem[addrb_int * 8 + 2];
		dob_out[3] <= mem[addrb_int * 8 + 3];
		dob_out[4] <= mem[addrb_int * 8 + 4];
		dob_out[5] <= mem[addrb_int * 8 + 5];
		dob_out[6] <= mem[addrb_int * 8 + 6];
		dob_out[7] <= mem[addrb_int * 8 + 7];
	    end
	    else begin
		dob_out[0] <= dib_int[0];
		dob_out[1] <= dib_int[1];
		dob_out[2] <= dib_int[2];
		dob_out[3] <= dib_int[3];
		dob_out[4] <= dib_int[4];
		dob_out[5] <= dib_int[5];
		dob_out[6] <= dib_int[6];
		dob_out[7] <= dib_int[7];
	    end
	end
    end

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1 && web_int == 1'b1) begin
	    mem[addrb_int * 8 + 0] <= dib_int[0];
	    mem[addrb_int * 8 + 1] <= dib_int[1];
	    mem[addrb_int * 8 + 2] <= dib_int[2];
	    mem[addrb_int * 8 + 3] <= dib_int[3];
	    mem[addrb_int * 8 + 4] <= dib_int[4];
	    mem[addrb_int * 8 + 5] <= dib_int[5];
	    mem[addrb_int * 8 + 6] <= dib_int[6];
	    mem[addrb_int * 8 + 7] <= dib_int[7];
	end
    end

    specify
	(CLKA *> DOA) = (1, 1);
	(CLKB *> DOB) = (1, 1);
	$recovery (posedge CLKB, posedge CLKA &&& collision, 1, recovery_b);
	$recovery (posedge CLKA, posedge CLKB &&& collision, 1, recovery_a);
    endspecify

endmodule

`endcelldefine
