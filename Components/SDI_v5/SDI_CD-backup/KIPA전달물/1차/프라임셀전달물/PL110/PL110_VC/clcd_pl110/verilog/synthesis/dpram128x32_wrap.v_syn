
//----------------------Revision History--------------------------------------
// 26-Apr-00   1.0   pavlov         Created.
// 21-Jun-00   1.1   pavlov         Enchacments in behavioral part.
// 07-Jul-00   1.2   pmahe          32-bit expression is connected to 1-bit port 
//                                  "numOfPort" of module PCL_NAME_Port instantiation
//                                  + make module name PCL dependant.
//----------------------------------------------------------------------------

`timescale 1ns/100fs


`define numAddr 7          
`define numOut 32 
`define wordDepth 128
module dpram128x32(A1, A2, CE1, CE2, WEB1, WEB2, OEB1, OEB2,
                    CSB1, CSB2,
                    I1, I2, O1, O2);

input [`numAddr-1:0] A1;
wire [`numAddr-1:0] A1;
input CE1,WEB1, OEB1, CSB1;
wire CE1,WEB1, OEB1, CSB1;
input [`numOut-1:0] I1;
output [`numOut-1:0] O1;
wire [`numOut-1:0] I1, O1;
input [`numAddr-1:0] A2;
wire [`numAddr-1:0] A2;
input CE2,WEB2, OEB2, CSB2;
wire CE2,WEB2, OEB2, CSB2;
input [`numOut-1:0] I2;
output [`numOut-1:0] O2;
wire [`numOut-1:0] I2, O2;

endmodule

