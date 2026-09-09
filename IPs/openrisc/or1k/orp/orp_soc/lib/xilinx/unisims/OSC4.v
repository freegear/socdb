// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OSC4.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: OSCILLATOR

*/

`timescale  100 ps / 10 ps

`celldefine

module OSC4 (F8M, F500K, F16K, F490, F15);

    parameter cds_action = "ignore";
    parameter period = 100;

    output F8M, F500K, F16K, F490, F15;

    reg    R8M, R500K, R16K, R490, R15;
    time   T8M, T500K, T16K, T490, T15;

    // time variables are unsigned 32 bit variables
    // so they don't overflow

    buf B1 (F8M,   B8M);
    buf B2 (F500K, B500K);
    buf B3 (F16K,  B16K);
    buf B4 (F490,  B490);
    buf B5 (F15,   B15);

    assign B8M = R8M;
    assign B500K = R500K;
    assign B16K = R16K;
    assign B490 = R490;
    assign B15 = R15;

    initial begin
	T8M   = period * 10 / 2;	// worst case 10 MHz
	T500K = period * 160 / 2;	// worst case 625 KHz
	T16K  = period * 5000 / 2;	// worst case 20 KHz
	T490  = period * 163265 / 2;	// worst case 612.5 Hz
	T15   = period * 5333333 / 2;	// worst case 18.75 Hz
    end

    initial begin
	R8M   = 0;
	R500K = 0;
	R16K  = 0;
	R490  = 0;
	R15   = 0;
    end

  always begin
	#T8M R8M = 1;
	#T8M R8M = 0;
    end

  always begin
	#T500K R500K = 1;
	#T500K R500K = 0;
    end

  always begin
	#T16K R16K = 1;
	#T16K R16K = 0;
    end

  always begin
	#T490 R490 = 1;
	#T490 R490 = 0;
    end

  always begin
	#T15 R15 = 1;
	#T15 R15 = 0;
    end

endmodule

`endcelldefine
