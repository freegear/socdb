// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech 
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : none.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Bulk block
//  =============================================================================

`timescale 1ns/1ps

module ?NAME?_?NUM?_registered
(
		ACLK         , 
		ARESETn      , 
		INFORMATION_S,
		VALID_S      ,
		READY_S      ,
		INFORMATION_R,
		VALID_R      ,
		READY_R
);

//
// NOTE : Registered Forward Module.
//                  +--------+
// INFORMATION_S => |        | => INFORMATION_R
// VALID_S       => |  this  | => VALID_R
//                  | module |
// READY_S       <= |        | <= READY_R
//                  +--------+
// suffix _S denotes "Sender"
// suffix _R denotes "Receiver"
//
// INFORMATION_S & VALID_S are registered but READY_R is passed through comb. logic to READY_S
//
//

parameter WIDTH  = ?WID?;

input  ACLK;
input  ARESETn;
input  [WIDTH-1:0] INFORMATION_S;
input  VALID_S;
output READY_S;
output [WIDTH-1:0] INFORMATION_R;
output VALID_R;
input  READY_R;

assign  INFORMATION_R = INFORMATION_S;
assign  VALID_R = VALID_S;
assign  READY_S = READY_R;

endmodule
//Code_END
