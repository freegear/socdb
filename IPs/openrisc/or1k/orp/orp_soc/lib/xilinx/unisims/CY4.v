// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/CY4.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: Carry Logic Function

*/

`timescale  100 ps / 10 ps

`celldefine

module CY4 (COUT, COUT0, A0, A1, ADD, B0, B1, C0, C1, C2, C3, C4, C5, C6, C7, CIN );

    parameter cds_action = "ignore";

    output COUT, COUT0;

    input  A0, A1, ADD, B0, B1, C0, C1, C2, C3, C4, C5, C6, C7, CIN;

    // default unconnected input pins to 0
    tri0 A0, A1, ADD, B0, B1, CIN;

	not N1 (INV1_o, B1);		
	not N2 (INV2_o, C0);		
	not N3 (INV3_o, ADD);		
	not N4 (INV4_o, C7);		
	not N5 (INV5_o, B0);		
	not N6 (INV6_o, C6);		
	not N7 (INV7_o, C5);		
	not N8 (INV8_o, C4);		
	not N9 (INV9_o, C3);		
	not N10 (INV10_o, OR4_o);		
	not N11 (INV11_o, OR6_o);		

	or O1 (OR1_o, INV4_o, INV1_o);
	or O2 (OR2_o, AND1_o, AND2_o);
	or O3 (OR3_o, INV4_o, INV5_o);
	or O4 (OR4_o, INV6_o, AND3_o);
	or O5 (OR5_o, AND4_o, AND5_o, AND6_o);
	or O6 (OR6_o, AND7_o, AND8_o);

	and AND1 (AND1_o, C1, INV2_o);
	and AND2 (AND2_o, ADD, C0);
	and AND3 (AND3_o, XOR2_o, C6);
	and AND4 (AND4_o, INV7_o, INV8_o, C7);
	and AND5 (AND5_o, C5, INV8_o, INV3_o);
	and AND6 (AND6_o, C5, C4, A0);
	and AND7 (AND7_o, C2, INV9_o);
	and AND8 (AND8_o, XOR4_o, C3);

	xor X1 (XOR1_o, OR1_o, OR2_o);
	xor X2 (XOR2_o, A1, XOR1_o);
	xor X3 (XOR3_o, OR2_o, OR3_o);
	xor X4 (XOR4_o, XOR3_o, A0);

	bufif0 T1 (BUF1_i, A1, OR4_o);
	bufif0 T2 (BUF1_i, COUT0, INV10_o);
	bufif0 T3 (BUF2_i, OR5_o, OR6_o);
	bufif0 T4 (BUF2_i, CIN, INV11_o);

	// ADD buffers so can use module path delay
	buf BUF1 (COUT, BUF1_i);
	buf BUF2 (COUT0, BUF2_i);

    specify
	(A0	*> COUT)	= (1, 1);
	(A1	*> COUT)	= (1, 1);
	(ADD	*> COUT)	= (1, 1);
	(B0	*> COUT)	= (1, 1);
	(B1	*> COUT)	= (1, 1);
	(CIN	*> COUT)	= (1, 1);
	(C0	*> COUT)	= (1, 1);
	(C1	*> COUT)	= (1, 1);
	(C2	*> COUT)	= (1, 1);
	(C3	*> COUT)	= (1, 1);
	(C4	*> COUT)	= (1, 1);
	(C5	*> COUT)	= (1, 1);
	(C6	*> COUT)	= (1, 1);
	(C7	*> COUT)	= (1, 1);
	(A0	*> COUT0)	= (1, 1);
	(ADD	*> COUT0)	= (1, 1);
	(B0	*> COUT0)	= (1, 1);
	(CIN	*> COUT0)	= (1, 1);
	(C0	*> COUT0)	= (1, 1);
	(C1	*> COUT0)	= (1, 1);
	(C2	*> COUT0)	= (1, 1);
	(C3	*> COUT0)	= (1, 1);
	(C4	*> COUT0)	= (1, 1);
	(C5	*> COUT0)	= (1, 1);
	(C7	*> COUT0)	= (1, 1);
    endspecify

endmodule

`endcelldefine
