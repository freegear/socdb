
//----------------------Revision History--------------------------------------
// 25-Apr-97  1.0  Xavier Duperthuy Copy from dualverilog.mlf 
//                 First backannotatable version.            
//  2-jul-97  1.1  Xavier Duperthuy Fixing Bug #29518
//                 Be sure to run Verilog with option +pathpulse
// 23-Jul-98, 2.0  Domenico Chindamo, Fixed X-handling after customer's finding
//	           Added ovi option, verbose_<X> options
// 24-Sep-98, 3.0, Domenico Chindamo, General remaking
// 20-Oct-98, 4.0, Domenico Chindamo, Compatibility with Polaris-CBS Analyzer
// 16-Feb-99, 4.1, Domenico Chindamo, Compatibility with Polaris-CBS runs
// 16-Mar-99, 4.2, Domenico Chindamo, behavioral model, swapped position
//				      added +define+nobanner option.
// 22-Mar-99, 4.3, Domenico Chindamo, OE does not activate a read cycle.
// 13-Apr-99, 4.4, Domenico Chindamo, for Synopsys, delete add timing arcs.
// 21-May-99, 4.5, Domenico Chindamo, changed instance name to porta/portb.
// 27-May-99, 4.6, Domenico Chindamo, made instance names "pcl dependant".
//----------------------------------------------------------------------------

`timescale 1ns/100fs

`define numAddr 7      
`define numOut 32 
`define wordDepth 128

module pram128x32(A1, A2, CE1, CE2, WEB1, WEB2, OEB1, OEB2, CSB1, CSB2,
	      I1, I2, O1, O2);

input  [`numAddr-1:0] A1, A2;
input  CE1, CE2, CSB1, CSB2, WEB1, WEB2, OEB1, OEB2;
input  [`numOut-1:0] I1, I2;
output [`numOut-1:0] O1, O2;

endmodule
