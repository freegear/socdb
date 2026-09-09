// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RAMB16_S18.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: 16x18 Block RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps

`celldefine

module RAMB16_S18 (DO, DOP, ADDR, DI, DIP, EN, CLK, WE, SSR);

    parameter cds_action = "ignore";
    parameter INIT = 18'h0;
    parameter SRVAL = 18'h0;
    parameter WRITE_MODE = "WRITE_FIRST";

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

    output [15:0] DO;
    output [1:0] DOP;
    reg do0_out, do1_out, do2_out, do3_out, do4_out, do5_out, do6_out, do7_out, do8_out, do9_out, do10_out, do11_out, do12_out, do13_out, do14_out, do15_out;
    reg dop0_out, dop1_out;

    input [9:0] ADDR;
    input [15:0] DI;
    input [1:0] DIP;
    input EN, CLK, WE, SSR;

    reg [18431:0] mem;
    reg [8:0] count;
    reg [1:0] wr_mode;

    wire [9:0] addr_int;
    wire [15:0] di_int;
    wire [1:0] dip_int;
    wire en_int, clk_int, we_int, ssr_int;

    tri0 GSR = glbl.GSR;

    always @(GSR)
	if (GSR) begin
	    assign do0_out = INIT[0];
	    assign do1_out = INIT[1];
	    assign do2_out = INIT[2];
	    assign do3_out = INIT[3];
	    assign do4_out = INIT[4];
	    assign do5_out = INIT[5];
	    assign do6_out = INIT[6];
	    assign do7_out = INIT[7];
	    assign do8_out = INIT[8];
	    assign do9_out = INIT[9];
	    assign do10_out = INIT[10];
	    assign do11_out = INIT[11];
	    assign do12_out = INIT[12];
	    assign do13_out = INIT[13];
	    assign do14_out = INIT[14];
	    assign do15_out = INIT[15];
	    assign dop0_out = INIT[16];
	    assign dop1_out = INIT[17];
	end
	else begin
	    deassign do0_out;
	    deassign do1_out;
	    deassign do2_out;
	    deassign do3_out;
	    deassign do4_out;
	    deassign do5_out;
	    deassign do6_out;
	    deassign do7_out;
	    deassign do8_out;
	    deassign do9_out;
	    deassign do10_out;
	    deassign do11_out;
	    deassign do12_out;
	    deassign do13_out;
	    deassign do14_out;
	    deassign do15_out;
	    deassign dop0_out;
	    deassign dop1_out;
	end

    buf b_do_out0 (DO[0], do0_out);
    buf b_do_out1 (DO[1], do1_out);
    buf b_do_out2 (DO[2], do2_out);
    buf b_do_out3 (DO[3], do3_out);
    buf b_do_out4 (DO[4], do4_out);
    buf b_do_out5 (DO[5], do5_out);
    buf b_do_out6 (DO[6], do6_out);
    buf b_do_out7 (DO[7], do7_out);
    buf b_do_out8 (DO[8], do8_out);
    buf b_do_out9 (DO[9], do9_out);
    buf b_do_out10 (DO[10], do10_out);
    buf b_do_out11 (DO[11], do11_out);
    buf b_do_out12 (DO[12], do12_out);
    buf b_do_out13 (DO[13], do13_out);
    buf b_do_out14 (DO[14], do14_out);
    buf b_do_out15 (DO[15], do15_out);
    buf b_dop_out0 (DOP[0], dop0_out);
    buf b_dop_out1 (DOP[1], dop1_out);
    buf b_addr_0 (addr_int[0], ADDR[0]);
    buf b_addr_1 (addr_int[1], ADDR[1]);
    buf b_addr_2 (addr_int[2], ADDR[2]);
    buf b_addr_3 (addr_int[3], ADDR[3]);
    buf b_addr_4 (addr_int[4], ADDR[4]);
    buf b_addr_5 (addr_int[5], ADDR[5]);
    buf b_addr_6 (addr_int[6], ADDR[6]);
    buf b_addr_7 (addr_int[7], ADDR[7]);
    buf b_addr_8 (addr_int[8], ADDR[8]);
    buf b_addr_9 (addr_int[9], ADDR[9]);
    buf b_di_0 (di_int[0], DI[0]);
    buf b_di_1 (di_int[1], DI[1]);
    buf b_di_2 (di_int[2], DI[2]);
    buf b_di_3 (di_int[3], DI[3]);
    buf b_di_4 (di_int[4], DI[4]);
    buf b_di_5 (di_int[5], DI[5]);
    buf b_di_6 (di_int[6], DI[6]);
    buf b_di_7 (di_int[7], DI[7]);
    buf b_di_8 (di_int[8], DI[8]);
    buf b_di_9 (di_int[9], DI[9]);
    buf b_di_10 (di_int[10], DI[10]);
    buf b_di_11 (di_int[11], DI[11]);
    buf b_di_12 (di_int[12], DI[12]);
    buf b_di_13 (di_int[13], DI[13]);
    buf b_di_14 (di_int[14], DI[14]);
    buf b_di_15 (di_int[15], DI[15]);
    buf b_dip_0 (dip_int[0], DIP[0]);
    buf b_dip_1 (dip_int[1], DIP[1]);
    buf b_en (en_int, EN);
    buf b_clk (clk_int, CLK);
    buf b_we (we_int, WE);
    buf b_ssr (ssr_int, SSR);

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

    initial begin
	case (WRITE_MODE)
	    "WRITE_FIRST" : wr_mode <= 2'b00;
	    "READ_FIRST"  : wr_mode <= 2'b01;
	    "NO_CHANGE"   : wr_mode <= 2'b10;
	    default       : begin
				$display("Error : WRITE_MODE = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE);
				$finish;
			    end
	endcase
    end

    always @(posedge clk_int) begin
	if (en_int == 1'b1) begin
	    if (ssr_int == 1'b1) begin
		do0_out <= SRVAL[0];
		do1_out <= SRVAL[1];
		do2_out <= SRVAL[2];
		do3_out <= SRVAL[3];
		do4_out <= SRVAL[4];
		do5_out <= SRVAL[5];
		do6_out <= SRVAL[6];
		do7_out <= SRVAL[7];
		do8_out <= SRVAL[8];
		do9_out <= SRVAL[9];
		do10_out <= SRVAL[10];
		do11_out <= SRVAL[11];
		do12_out <= SRVAL[12];
		do13_out <= SRVAL[13];
		do14_out <= SRVAL[14];
		do15_out <= SRVAL[15];
		dop0_out <= SRVAL[16];
		dop1_out <= SRVAL[17];
	    end
	    else begin
		if (we_int == 1'b1) begin
		    if (wr_mode == 2'b00) begin
			do0_out <= di_int[0];
			do1_out <= di_int[1];
			do2_out <= di_int[2];
			do3_out <= di_int[3];
			do4_out <= di_int[4];
			do5_out <= di_int[5];
			do6_out <= di_int[6];
			do7_out <= di_int[7];
			do8_out <= di_int[8];
			do9_out <= di_int[9];
			do10_out <= di_int[10];
			do11_out <= di_int[11];
			do12_out <= di_int[12];
			do13_out <= di_int[13];
			do14_out <= di_int[14];
			do15_out <= di_int[15];
			dop0_out <= dip_int[0];
			dop1_out <= dip_int[1];
		    end
		    else if (wr_mode == 2'b01) begin
			do0_out <= mem[addr_int * 16 + 0];
			do1_out <= mem[addr_int * 16 + 1];
			do2_out <= mem[addr_int * 16 + 2];
			do3_out <= mem[addr_int * 16 + 3];
			do4_out <= mem[addr_int * 16 + 4];
			do5_out <= mem[addr_int * 16 + 5];
			do6_out <= mem[addr_int * 16 + 6];
			do7_out <= mem[addr_int * 16 + 7];
			do8_out <= mem[addr_int * 16 + 8];
			do9_out <= mem[addr_int * 16 + 9];
			do10_out <= mem[addr_int * 16 + 10];
			do11_out <= mem[addr_int * 16 + 11];
			do12_out <= mem[addr_int * 16 + 12];
			do13_out <= mem[addr_int * 16 + 13];
			do14_out <= mem[addr_int * 16 + 14];
			do15_out <= mem[addr_int * 16 + 15];
			dop0_out <= mem[16384 + addr_int * 2 + 0];
			dop1_out <= mem[16384 + addr_int * 2 + 1];
		    end
		    else begin
			do0_out <= do0_out;
			do1_out <= do1_out;
			do2_out <= do2_out;
			do3_out <= do3_out;
			do4_out <= do4_out;
			do5_out <= do5_out;
			do6_out <= do6_out;
			do7_out <= do7_out;
			do8_out <= do8_out;
			do9_out <= do9_out;
			do10_out <= do10_out;
			do11_out <= do11_out;
			do12_out <= do12_out;
			do13_out <= do13_out;
			do14_out <= do14_out;
			do15_out <= do15_out;
			dop0_out <= dop0_out;
			dop1_out <= dop1_out;
		    end
		end
		else begin
		    do0_out <= mem[addr_int * 16 + 0];
		    do1_out <= mem[addr_int * 16 + 1];
		    do2_out <= mem[addr_int * 16 + 2];
		    do3_out <= mem[addr_int * 16 + 3];
		    do4_out <= mem[addr_int * 16 + 4];
		    do5_out <= mem[addr_int * 16 + 5];
		    do6_out <= mem[addr_int * 16 + 6];
		    do7_out <= mem[addr_int * 16 + 7];
		    do8_out <= mem[addr_int * 16 + 8];
		    do9_out <= mem[addr_int * 16 + 9];
		    do10_out <= mem[addr_int * 16 + 10];
		    do11_out <= mem[addr_int * 16 + 11];
		    do12_out <= mem[addr_int * 16 + 12];
		    do13_out <= mem[addr_int * 16 + 13];
		    do14_out <= mem[addr_int * 16 + 14];
		    do15_out <= mem[addr_int * 16 + 15];
		    dop0_out <= mem[16384 + addr_int * 2 + 0];
		    dop1_out <= mem[16384 + addr_int * 2 + 1];
		end
	    end
	end
    end

    always @(posedge clk_int) begin
	if (en_int == 1'b1 && we_int == 1'b1) begin
	    mem[addr_int * 16 + 0] <= di_int[0];
	    mem[addr_int * 16 + 1] <= di_int[1];
	    mem[addr_int * 16 + 2] <= di_int[2];
	    mem[addr_int * 16 + 3] <= di_int[3];
	    mem[addr_int * 16 + 4] <= di_int[4];
	    mem[addr_int * 16 + 5] <= di_int[5];
	    mem[addr_int * 16 + 6] <= di_int[6];
	    mem[addr_int * 16 + 7] <= di_int[7];
	    mem[addr_int * 16 + 8] <= di_int[8];
	    mem[addr_int * 16 + 9] <= di_int[9];
	    mem[addr_int * 16 + 10] <= di_int[10];
	    mem[addr_int * 16 + 11] <= di_int[11];
	    mem[addr_int * 16 + 12] <= di_int[12];
	    mem[addr_int * 16 + 13] <= di_int[13];
	    mem[addr_int * 16 + 14] <= di_int[14];
	    mem[addr_int * 16 + 15] <= di_int[15];
	    mem[16384 + addr_int * 2 + 0] <= dip_int[0];
	    mem[16384 + addr_int * 2 + 1] <= dip_int[1];
	end
    end

    specify
	(CLK *> DO) = (1, 1);
	(CLK *> DOP) = (1, 1);
    endspecify

endmodule

`endcelldefine
