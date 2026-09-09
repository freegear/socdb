// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RAMB4_S1.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: 4x1 Block RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps

`celldefine

module RAMB4_S1 (DO, ADDR, DI, EN, CLK, WE, RST);

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

    output [0:0] DO;
    reg d0_out;

    input [11:0] ADDR;
    input [0:0] DI;
    input EN, CLK, WE, RST;

    reg [4095:0] mem;
    reg [8:0] count;

    wire [11:0] addr_int;
    wire [0:0] di_int;
    wire en_int, clk_int, we_int, rst_int;

    tri0 GSR = glbl.GSR;

    always @(GSR)
	if (GSR)
	    begin
		assign d0_out = 0;
	    end
	else
	    begin
		deassign d0_out;
	    end

    buf b_do_out0 (DO[0], d0_out);
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
    buf b_addr_10 (addr_int[10], ADDR[10]);
    buf b_addr_11 (addr_int[11], ADDR[11]);
    buf b_di_0 (di_int[0], DI[0]);
    buf b_en (en_int, EN);
    buf b_clk (clk_int, CLK);
    buf b_we (we_int, WE);
    buf b_rst (rst_int, RST);

    initial
    begin
	for (count = 0; count < 256; count = count + 1)
	begin
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
    end

    always @(posedge clk_int)
    begin
	if (en_int == 1'b1)
	    if (rst_int == 1'b1)
		begin
		    d0_out <= 0;
		end
	    else
		if (we_int == 1'b1)
		    begin
			d0_out <= di_int[0];
		    end
		else
		    begin
			d0_out <= mem[addr_int];
		    end
    end

    always @(posedge clk_int)
    begin
	if (en_int == 1'b1 && we_int == 1'b1)
	    begin
		mem[addr_int] <= di_int[0];
	    end
    end

    specify
	(CLK => DO) = (1, 1);
    endspecify

endmodule

`endcelldefine
