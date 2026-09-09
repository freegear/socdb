// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : LuMUL.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is luminance filter mul.
// ===================================================================

module LuMUL(
            MUL37IN,
            MULM50IN,
            MULM70IN,
            MUL298IN,
            MUL593IN,

            MUL37OUT,
            MULM50OUT,
            MULM70OUT,
            MUL298OUT,
            MUL593OUT
           );

input   [10:0]  MUL37IN;
input   [10:0]  MULM50IN;
input   [10:0]  MULM70IN;
input   [10:0]  MUL298IN;
input   [10:0]  MUL593IN;

output  [20:0]  MUL37OUT;
output  [20:0]  MULM50OUT;
output  [20:0]  MULM70OUT;
output  [20:0]  MUL298OUT;
output  [20:0]  MUL593OUT;

// =======================================================================
// Multifly 37
// -----------------------------------------------------------------------
wire [15:0] tmp1_37 = {2'd0, MUL37IN, 3'd0} + {5'd0, MUL37IN};
wire [18:0] tmp2_37 = {1'd0, tmp1_37, 2'd0} + {8'd0, MUL37IN};
assign MUL37OUT = {2'd0, tmp2_37};

// =======================================================================
// Multifly -50
// -----------------------------------------------------------------------
wire [17:0] tmp0_50 = {2'd0, MULM50IN, 5'd0} - {7'd0, MULM50IN};
wire [15:0] tmp1_50 = {3'd0, MULM50IN, 2'd0} - {5'd0, MULM50IN};
wire [18:0] tmp2_50 = {tmp0_50,1'd0} - {1'd0, tmp1_50,2'd0};
assign MULM50OUT = -{2'd0, tmp2_50};

// =======================================================================
// Multifly -70
// -----------------------------------------------------------------------
wire [18:0] tmp0_70 = {2'd0, MULM70IN, 6'd0} - {8'd0, MULM70IN};
wire [15:0] tmp1_70 = {2'd0, MULM70IN, 3'd0} - {5'd0, MULM70IN};
wire [19:0] tmp2_70 = {tmp0_70, 1'd0} - {1'd0, tmp1_70, 3'd0};
assign MULM70OUT = -{1'd0,tmp2_70};

// =======================================================================
// Multifly 298
// -----------------------------------------------------------------------
wire [15:0] tmp0_298 = {2'd0, MUL298IN, 3'd0} + {5'd0, MUL298IN};
wire [14:0] tmp1_298 = {1'd0, MUL298IN, 2'd0} + {4'd0, MUL298IN};
wire [20:0] tmp2_298 = {tmp0_298, 5'd0} + {5'd0, tmp1_298, 1'b0};
assign MUL298OUT = tmp2_298;

// =======================================================================
// Multifly 593
// -----------------------------------------------------------------------
wire [15:0] tmp0_593 = {2'd0, MUL593IN, 3'd0} + {5'd0, MUL593IN};
wire [16:0] tmp1_593 = {2'd0, MUL593IN, 4'd0} + {6'd0, MUL593IN};
wire [20:0] tmp2_593 = {tmp0_593[14:0], 6'd0} + {4'd0, tmp1_593};
assign MUL593OUT = tmp2_593;

endmodule
