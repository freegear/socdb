// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RAMB16_S9_S9.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: 16x9x9 Block RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps

`celldefine

module RAMB16_S9_S9 (DOA, DOPA, DOB, DOPB, ADDRA, CLKA, DIA, DIPA, ENA, SSRA, WEA, ADDRB, CLKB, DIB, DIPB, ENB, SSRB, WEB);
    parameter cds_action = "ignore";
    parameter INIT_A = 9'h0;
    parameter INIT_B = 9'h0;
    parameter SRVAL_A = 9'h0;
    parameter SRVAL_B = 9'h0;
    parameter WRITE_MODE_A = "WRITE_FIRST";
    parameter WRITE_MODE_B = "WRITE_FIRST";

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
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    output [7:0] DOA;
    output [0:0] DOPA;
    reg [7:0] doa_out;
    reg [0:0] dopa_out;
    wire doa_out0, doa_out1, doa_out2, doa_out3, doa_out4, doa_out5, doa_out6, doa_out7;
    wire dopa0_out;

    input [10:0] ADDRA;
    input [7:0] DIA;
    input [0:0] DIPA;
    input ENA, CLKA, WEA, SSRA;

    output [7:0] DOB;
    output [0:0] DOPB;
    reg [7:0] dob_out;
    reg [0:0] dopb_out;
    wire dob_out0, dob_out1, dob_out2, dob_out3, dob_out4, dob_out5, dob_out6, dob_out7;
    wire dopb0_out;

    input [10:0] ADDRB;
    input [7:0] DIB;
    input [0:0] DIPB;
    input ENB, CLKB, WEB, SSRB;

    reg [18431:0] mem;
    reg [8:0] count;
    reg [1:0] wr_mode_a, wr_mode_b;

    reg [5:0] ci, cj;
    reg [5:0] dmi, dmj, dni, dnj, doi, doj, dai, daj, dbi, dbj, dci, dcj, ddi, ddj;
    reg [5:0] pmi, pmj, pni, pnj, poi, poj, pai, paj, pbi, pbj, pci, pcj, pdi, pdj;

    wire [10:0] addra_int;
    wire [7:0] dia_int;
    wire [0:0] dipa_int;
    wire ena_int, clka_int, wea_int, ssra_int;
    wire [10:0] addrb_int;
    wire [7:0] dib_int;
    wire [0:0] dipb_int;
    wire enb_int, clkb_int, web_int, ssrb_int;

    reg recovery_a, recovery_b;
    reg address_collision;

    wire clka_enable = ena_int && wea_int && enb_int && address_collision;
    wire clkb_enable = enb_int && web_int && ena_int && address_collision;
    wire collision = clka_enable || clkb_enable;

    tri0 GSR = glbl.GSR;

    always @(GSR)
	if (GSR) begin
	    assign doa_out = INIT_A[7:0];
	    assign dopa_out = INIT_A[8:8];
	    assign dob_out = INIT_B[7:0];
	    assign dopb_out = INIT_B[8:8];
	end
	else begin
	    deassign doa_out;
	    deassign dopa_out;
	    deassign dob_out;
	    deassign dopb_out;
	end

    buf b_doa_out0 (doa_out0, doa_out[0]);
    buf b_doa_out1 (doa_out1, doa_out[1]);
    buf b_doa_out2 (doa_out2, doa_out[2]);
    buf b_doa_out3 (doa_out3, doa_out[3]);
    buf b_doa_out4 (doa_out4, doa_out[4]);
    buf b_doa_out5 (doa_out5, doa_out[5]);
    buf b_doa_out6 (doa_out6, doa_out[6]);
    buf b_doa_out7 (doa_out7, doa_out[7]);
    buf b_dopa_out0 (dopa_out0, dopa_out[0]);
    buf b_dob_out0 (dob_out0, dob_out[0]);
    buf b_dob_out1 (dob_out1, dob_out[1]);
    buf b_dob_out2 (dob_out2, dob_out[2]);
    buf b_dob_out3 (dob_out3, dob_out[3]);
    buf b_dob_out4 (dob_out4, dob_out[4]);
    buf b_dob_out5 (dob_out5, dob_out[5]);
    buf b_dob_out6 (dob_out6, dob_out[6]);
    buf b_dob_out7 (dob_out7, dob_out[7]);
    buf b_dopb_out0 (dopb_out0, dopb_out[0]);

    buf b_doa0 (DOA[0], doa_out0);
    buf b_doa1 (DOA[1], doa_out1);
    buf b_doa2 (DOA[2], doa_out2);
    buf b_doa3 (DOA[3], doa_out3);
    buf b_doa4 (DOA[4], doa_out4);
    buf b_doa5 (DOA[5], doa_out5);
    buf b_doa6 (DOA[6], doa_out6);
    buf b_doa7 (DOA[7], doa_out7);
    buf b_dopa0 (DOPA[0], dopa_out0);
    buf b_dob0 (DOB[0], dob_out0);
    buf b_dob1 (DOB[1], dob_out1);
    buf b_dob2 (DOB[2], dob_out2);
    buf b_dob3 (DOB[3], dob_out3);
    buf b_dob4 (DOB[4], dob_out4);
    buf b_dob5 (DOB[5], dob_out5);
    buf b_dob6 (DOB[6], dob_out6);
    buf b_dob7 (DOB[7], dob_out7);
    buf b_dopb0 (DOPB[0], dopb_out0);

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
    buf b_dia_2 (dia_int[2], DIA[2]);
    buf b_dia_3 (dia_int[3], DIA[3]);
    buf b_dia_4 (dia_int[4], DIA[4]);
    buf b_dia_5 (dia_int[5], DIA[5]);
    buf b_dia_6 (dia_int[6], DIA[6]);
    buf b_dia_7 (dia_int[7], DIA[7]);
    buf b_dipa_0 (dipa_int[0], DIPA[0]);
    buf b_ena (ena_int, ENA);
    buf b_clka (clka_int, CLKA);
    buf b_ssra (ssra_int, SSRA);
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
    buf b_addrb_9 (addrb_int[9], ADDRB[9]);
    buf b_addrb_10 (addrb_int[10], ADDRB[10]);
    buf b_dib_0 (dib_int[0], DIB[0]);
    buf b_dib_1 (dib_int[1], DIB[1]);
    buf b_dib_2 (dib_int[2], DIB[2]);
    buf b_dib_3 (dib_int[3], DIB[3]);
    buf b_dib_4 (dib_int[4], DIB[4]);
    buf b_dib_5 (dib_int[5], DIB[5]);
    buf b_dib_6 (dib_int[6], DIB[6]);
    buf b_dib_7 (dib_int[7], DIB[7]);
    buf b_dipb_0 (dipb_int[0], DIPB[0]);
    buf b_enb (enb_int, ENB);
    buf b_clkb (clkb_int, CLKB);
    buf b_ssrb (ssrb_int, SSRB);
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
	    mem[256 * 16 + count] <= INIT_10[count];
	    mem[256 * 17 + count] <= INIT_11[count];
	    mem[256 * 18 + count] <= INIT_12[count];
	    mem[256 * 19 + count] <= INIT_13[count];
	    mem[256 * 20 + count] <= INIT_14[count];
	    mem[256 * 21 + count] <= INIT_15[count];
	    mem[256 * 22 + count] <= INIT_16[count];
	    mem[256 * 23 + count] <= INIT_17[count];
	    mem[256 * 24 + count] <= INIT_18[count];
	    mem[256 * 25 + count] <= INIT_19[count];
	    mem[256 * 26 + count] <= INIT_1A[count];
	    mem[256 * 27 + count] <= INIT_1B[count];
	    mem[256 * 28 + count] <= INIT_1C[count];
	    mem[256 * 29 + count] <= INIT_1D[count];
	    mem[256 * 30 + count] <= INIT_1E[count];
	    mem[256 * 31 + count] <= INIT_1F[count];
	    mem[256 * 32 + count] <= INIT_20[count];
	    mem[256 * 33 + count] <= INIT_21[count];
	    mem[256 * 34 + count] <= INIT_22[count];
	    mem[256 * 35 + count] <= INIT_23[count];
	    mem[256 * 36 + count] <= INIT_24[count];
	    mem[256 * 37 + count] <= INIT_25[count];
	    mem[256 * 38 + count] <= INIT_26[count];
	    mem[256 * 39 + count] <= INIT_27[count];
	    mem[256 * 40 + count] <= INIT_28[count];
	    mem[256 * 41 + count] <= INIT_29[count];
	    mem[256 * 42 + count] <= INIT_2A[count];
	    mem[256 * 43 + count] <= INIT_2B[count];
	    mem[256 * 44 + count] <= INIT_2C[count];
	    mem[256 * 45 + count] <= INIT_2D[count];
	    mem[256 * 46 + count] <= INIT_2E[count];
	    mem[256 * 47 + count] <= INIT_2F[count];
	    mem[256 * 48 + count] <= INIT_30[count];
	    mem[256 * 49 + count] <= INIT_31[count];
	    mem[256 * 50 + count] <= INIT_32[count];
	    mem[256 * 51 + count] <= INIT_33[count];
	    mem[256 * 52 + count] <= INIT_34[count];
	    mem[256 * 53 + count] <= INIT_35[count];
	    mem[256 * 54 + count] <= INIT_36[count];
	    mem[256 * 55 + count] <= INIT_37[count];
	    mem[256 * 56 + count] <= INIT_38[count];
	    mem[256 * 57 + count] <= INIT_39[count];
	    mem[256 * 58 + count] <= INIT_3A[count];
	    mem[256 * 59 + count] <= INIT_3B[count];
	    mem[256 * 60 + count] <= INIT_3C[count];
	    mem[256 * 61 + count] <= INIT_3D[count];
	    mem[256 * 62 + count] <= INIT_3E[count];
	    mem[256 * 63 + count] <= INIT_3F[count];
	    mem[256 * 64 + count] <= INITP_00[count];
	    mem[256 * 65 + count] <= INITP_01[count];
	    mem[256 * 66 + count] <= INITP_02[count];
	    mem[256 * 67 + count] <= INITP_03[count];
	    mem[256 * 68 + count] <= INITP_04[count];
	    mem[256 * 69 + count] <= INITP_05[count];
	    mem[256 * 70 + count] <= INITP_06[count];
	    mem[256 * 71 + count] <= INITP_07[count];
	end
    end

    always @(addra_int or addrb_int) begin
	address_collision <= 1'b0;
	for (ci = 0; ci < 8; ci = ci + 1) begin
	    for (cj = 0; cj < 8; cj = cj + 1) begin
		if ((addra_int * 8 + ci) == (addrb_int * 8 + cj)) begin
		    address_collision <= 1'b1;
		end
	    end
	end
    end

    // Data
    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b01) && (wr_mode_b == 2'b01)) ||
	    ((wr_mode_a != 2'b01) && (wr_mode_b != 2'b01))) begin
	    if (wea_int == 1 && web_int == 1) begin
		for (dmi = 0; dmi < 8; dmi = dmi + 1) begin
		    for (dmj = 0; dmj < 8; dmj = dmj + 1) begin
			if ((addra_int * 8 + dmi) == (addrb_int * 8 + dmj)) begin
			    mem[addra_int * 8 + dmi] <= 1'bX;
			end
		    end
		end
	    end
	end
	recovery_a <= 0;
	recovery_b <= 0;
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b01) && (wr_mode_b != 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
		for (dni = 0; dni < 8; dni = dni + 1) begin
		    for (dnj = 0; dnj < 8; dnj = dnj + 1) begin
			if ((addra_int * 8 + dni) == (addrb_int * 8 + dnj)) begin
			    mem[addra_int * 8 + dni] <= dia_int[dni];
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a != 2'b01) && (wr_mode_b == 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
		for (doi = 0; doi < 8; doi = doi + 1) begin
		    for (doj = 0; doj < 8; doj = doj + 1) begin
			if ((addra_int * 8 + doi) == (addrb_int * 8 + doj)) begin
			    mem[addrb_int * 8 + doj] <= dib_int[doj];
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_b == 2'b00) || (wr_mode_b == 2'b10)) begin
	    if ((wea_int == 0) && (web_int == 1) && (ssra_int == 0)) begin
		for (dai = 0; dai < 8; dai = dai + 1) begin
		    for (daj = 0; daj < 8; daj = daj + 1) begin
			if ((addra_int * 8 + dai) == (addrb_int * 8 + daj)) begin
			    doa_out[dai] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b00) || (wr_mode_a == 2'b10)) begin
	    if ((wea_int == 1) && (web_int == 0) && (ssrb_int == 0)) begin
		for (dbi = 0; dbi < 8; dbi = dbi + 1) begin
		    for (dbj = 0; dbj < 8; dbj = dbj + 1) begin
			if ((addra_int * 8 + dbi) == (addrb_int * 8 + dbj)) begin
			    dob_out[dbj] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    (wr_mode_b == 2'b10) ||
	    ((wr_mode_a == 2'b01) && (wr_mode_b == 2'b00))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssra_int == 0)) begin
		for (dci = 0; dci < 8; dci = dci + 1) begin
		    for (dcj = 0; dcj < 8; dcj = dcj + 1) begin
			if ((addra_int * 8 + dci) == (addrb_int * 8 + dcj)) begin
			    doa_out[dci] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    (wr_mode_a == 2'b10) ||
	    ((wr_mode_a == 2'b00) && (wr_mode_b == 2'b01))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssrb_int == 0)) begin
		for (ddi = 0; ddi < 8; ddi = ddi + 1) begin
		    for (ddj = 0; ddj < 8; ddj = ddj + 1) begin
			if ((addra_int * 8 + ddi) == (addrb_int * 8 + ddj)) begin
			    dob_out[ddj] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    // Parity
    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b01) && (wr_mode_b == 2'b01)) ||
	    ((wr_mode_a != 2'b01) && (wr_mode_b != 2'b01))) begin
	    if (wea_int == 1 && web_int == 1) begin
		for (pmi = 0; pmi < 1; pmi = pmi + 1) begin
		    for (pmj = 0; pmj < 1; pmj = pmj + 1) begin
			if ((addra_int * 1 + pmi) == (addrb_int * 1 + pmj)) begin
			    mem[16384 + addra_int * 1 + pmi] <= 1'bX;
			end
		    end
		end
	    end
	end
	recovery_a <= 0;
	recovery_b <= 0;
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b01) && (wr_mode_b != 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
		for (pni = 0; pni < 1; pni = pni + 1) begin
		    for (pnj = 0; pnj < 1; pnj = pnj + 1) begin
			if ((addra_int * 1 + pni) == (addrb_int * 1 + pnj)) begin
			    mem[16384 + addra_int * 1 + pni] <= dipa_int[pni];
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a != 2'b01) && (wr_mode_b == 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
		for (poi = 0; poi < 1; poi = poi + 1) begin
		    for (poj = 0; poj < 1; poj = poj + 1) begin
			if ((addra_int * 1 + poi) == (addrb_int * 1 + poj)) begin
			    mem[16384 + addrb_int * 1 + poj] <= dipb_int[poj];
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_b == 2'b00) || (wr_mode_b == 2'b10)) begin
	    if ((wea_int == 0) && (web_int == 1) && (ssra_int == 0)) begin
		for (pai = 0; pai < 1; pai = pai + 1) begin
		    for (paj = 0; paj < 1; paj = paj + 1) begin
			if ((addra_int * 1 + pai) == (addrb_int * 1 + paj)) begin
			    dopa_out[pai] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b00) || (wr_mode_a == 2'b10)) begin
	    if ((wea_int == 1) && (web_int == 0) && (ssrb_int == 0)) begin
		for (pbi = 0; pbi < 1; pbi = pbi + 1) begin
		    for (pbj = 0; pbj < 1; pbj = pbj + 1) begin
			if ((addra_int * 1 + pbi) == (addrb_int * 1 + pbj)) begin
			    dopb_out[pbj] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    (wr_mode_b == 2'b10) ||
	    ((wr_mode_a == 2'b01) && (wr_mode_b == 2'b00))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssra_int == 0)) begin
		for (pci = 0; pci < 1; pci = pci + 1) begin
		    for (pcj = 0; pcj < 1; pcj = pcj + 1) begin
			if ((addra_int * 1 + pci) == (addrb_int * 1 + pcj)) begin
			    dopa_out[pci] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    (wr_mode_a == 2'b10) ||
	    ((wr_mode_a == 2'b00) && (wr_mode_b == 2'b01))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssrb_int == 0)) begin
		for (pdi = 0; pdi < 1; pdi = pdi + 1) begin
		    for (pdj = 0; pdj < 1; pdj = pdj + 1) begin
			if ((addra_int * 1 + pdi) == (addrb_int * 1 + pdj)) begin
			    dopb_out[pdj] <= 1'bX;
			end
		    end
		end
	    end
	end
    end

    initial begin
	case (WRITE_MODE_A)
	    "WRITE_FIRST" : wr_mode_a <= 2'b00;
	    "READ_FIRST"  : wr_mode_a <= 2'b01;
	    "NO_CHANGE"   : wr_mode_a <= 2'b10;
	    default       : begin
				$display("Error : WRITE_MODE_A = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE_A);
				$finish;
			    end
	endcase
    end

    initial begin
	case (WRITE_MODE_B)
	    "WRITE_FIRST" : wr_mode_b <= 2'b00;
	    "READ_FIRST"  : wr_mode_b <= 2'b01;
	    "NO_CHANGE"   : wr_mode_b <= 2'b10;
	    default       : begin
				$display("Error : WRITE_MODE_B = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE_B);
				$finish;
			    end
	endcase
    end

    // Port A
    always @(posedge clka_int) begin
	if (ena_int == 1'b1) begin
	    if (ssra_int == 1'b1) begin
		doa_out[0] <= SRVAL_A[0];
		doa_out[1] <= SRVAL_A[1];
		doa_out[2] <= SRVAL_A[2];
		doa_out[3] <= SRVAL_A[3];
		doa_out[4] <= SRVAL_A[4];
		doa_out[5] <= SRVAL_A[5];
		doa_out[6] <= SRVAL_A[6];
		doa_out[7] <= SRVAL_A[7];
		dopa_out[0] <= SRVAL_A[8];
	    end
	    else begin
		if (wea_int == 1'b1) begin
		    if (wr_mode_a == 2'b00) begin
			doa_out[0] <= dia_int[0];
			doa_out[1] <= dia_int[1];
			doa_out[2] <= dia_int[2];
			doa_out[3] <= dia_int[3];
			doa_out[4] <= dia_int[4];
			doa_out[5] <= dia_int[5];
			doa_out[6] <= dia_int[6];
			doa_out[7] <= dia_int[7];
			dopa_out[0] <= dipa_int[0];
		    end
		    else if (wr_mode_a == 2'b01) begin
			doa_out[0] <= mem[addra_int * 8 + 0];
			doa_out[1] <= mem[addra_int * 8 + 1];
			doa_out[2] <= mem[addra_int * 8 + 2];
			doa_out[3] <= mem[addra_int * 8 + 3];
			doa_out[4] <= mem[addra_int * 8 + 4];
			doa_out[5] <= mem[addra_int * 8 + 5];
			doa_out[6] <= mem[addra_int * 8 + 6];
			doa_out[7] <= mem[addra_int * 8 + 7];
			dopa_out[0] <= mem[16384 + addra_int * 1 + 0];
		    end
		    else begin
			doa_out[0] <= doa_out[0];
			doa_out[1] <= doa_out[1];
			doa_out[2] <= doa_out[2];
			doa_out[3] <= doa_out[3];
			doa_out[4] <= doa_out[4];
			doa_out[5] <= doa_out[5];
			doa_out[6] <= doa_out[6];
			doa_out[7] <= doa_out[7];
			dopa_out[0] <= dopa_out[0];
		    end
		end
		else begin
		    doa_out[0] <= mem[addra_int * 8 + 0];
		    doa_out[1] <= mem[addra_int * 8 + 1];
		    doa_out[2] <= mem[addra_int * 8 + 2];
		    doa_out[3] <= mem[addra_int * 8 + 3];
		    doa_out[4] <= mem[addra_int * 8 + 4];
		    doa_out[5] <= mem[addra_int * 8 + 5];
		    doa_out[6] <= mem[addra_int * 8 + 6];
		    doa_out[7] <= mem[addra_int * 8 + 7];
		    dopa_out[0] <= mem[16384 + addra_int * 1 + 0];
		end
	    end
	end
    end

    always @(posedge clka_int) begin
	if (ena_int == 1'b1 && wea_int == 1'b1) begin
	    mem[addra_int * 8 + 0] <= dia_int[0];
	    mem[addra_int * 8 + 1] <= dia_int[1];
	    mem[addra_int * 8 + 2] <= dia_int[2];
	    mem[addra_int * 8 + 3] <= dia_int[3];
	    mem[addra_int * 8 + 4] <= dia_int[4];
	    mem[addra_int * 8 + 5] <= dia_int[5];
	    mem[addra_int * 8 + 6] <= dia_int[6];
	    mem[addra_int * 8 + 7] <= dia_int[7];
	    mem[16384 + addra_int * 1 + 0] <= dipa_int[0];
	end
    end

    // Port B
    always @(posedge clkb_int) begin
	if (enb_int == 1'b1) begin
	    if (ssrb_int == 1'b1) begin
		dob_out[0] <= SRVAL_B[0];
		dob_out[1] <= SRVAL_B[1];
		dob_out[2] <= SRVAL_B[2];
		dob_out[3] <= SRVAL_B[3];
		dob_out[4] <= SRVAL_B[4];
		dob_out[5] <= SRVAL_B[5];
		dob_out[6] <= SRVAL_B[6];
		dob_out[7] <= SRVAL_B[7];
		dopb_out[0] <= SRVAL_B[8];
	    end
	    else begin
		if (web_int == 1'b1) begin
		    if (wr_mode_b == 2'b00) begin
			dob_out[0] <= dib_int[0];
			dob_out[1] <= dib_int[1];
			dob_out[2] <= dib_int[2];
			dob_out[3] <= dib_int[3];
			dob_out[4] <= dib_int[4];
			dob_out[5] <= dib_int[5];
			dob_out[6] <= dib_int[6];
			dob_out[7] <= dib_int[7];
			dopb_out[0] <= dipb_int[0];
		    end
		    else if (wr_mode_b == 2'b01) begin
			dob_out[0] <= mem[addrb_int * 8 + 0];
			dob_out[1] <= mem[addrb_int * 8 + 1];
			dob_out[2] <= mem[addrb_int * 8 + 2];
			dob_out[3] <= mem[addrb_int * 8 + 3];
			dob_out[4] <= mem[addrb_int * 8 + 4];
			dob_out[5] <= mem[addrb_int * 8 + 5];
			dob_out[6] <= mem[addrb_int * 8 + 6];
			dob_out[7] <= mem[addrb_int * 8 + 7];
			dopb_out[0] <= mem[16384 + addrb_int * 1 + 0];
		    end
		    else begin
			dob_out[0] <= dob_out[0];
			dob_out[1] <= dob_out[1];
			dob_out[2] <= dob_out[2];
			dob_out[3] <= dob_out[3];
			dob_out[4] <= dob_out[4];
			dob_out[5] <= dob_out[5];
			dob_out[6] <= dob_out[6];
			dob_out[7] <= dob_out[7];
			dopb_out[0] <= dopb_out[0];
		    end
		end
		else begin
		    dob_out[0] <= mem[addrb_int * 8 + 0];
		    dob_out[1] <= mem[addrb_int * 8 + 1];
		    dob_out[2] <= mem[addrb_int * 8 + 2];
		    dob_out[3] <= mem[addrb_int * 8 + 3];
		    dob_out[4] <= mem[addrb_int * 8 + 4];
		    dob_out[5] <= mem[addrb_int * 8 + 5];
		    dob_out[6] <= mem[addrb_int * 8 + 6];
		    dob_out[7] <= mem[addrb_int * 8 + 7];
		    dopb_out[0] <= mem[16384 + addrb_int * 1 + 0];
		end
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
	    mem[16384 + addrb_int * 1 + 0] <= dipb_int[0];
	end
    end

    specify
	(CLKA *> DOA) = (1, 1);
	(CLKA *> DOPA) = (1, 1);
	(CLKB *> DOB) = (1, 1);
	(CLKB *> DOPB) = (1, 1);
	$recovery (posedge CLKB, posedge CLKA &&& collision, 1, recovery_b);
	$recovery (posedge CLKA, posedge CLKB &&& collision, 1, recovery_a);
    endspecify

endmodule

`endcelldefine
