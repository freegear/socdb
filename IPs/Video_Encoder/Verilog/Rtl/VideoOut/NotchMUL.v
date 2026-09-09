// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : NotchMUL.v
// File Revision       : 0.1
// -------------------------------------------------------------------
// Purpose            : This module is notch filter mul.
// ===================================================================

module NotchMUL(
            MUL134IN,
            MUL142IN,
            MUL307IN,
            MUL38IN,
            MUL39IN,
            MUL455IN,

            MUL134OUT,
            MUL142OUT,
            MUL307OUT,
            MUL38OUT,
            MUL39OUT,
            MUL455OUT
           );

input   [10:0]  MUL134IN;
input   [10:0]  MUL142IN;
input   [10:0]  MUL307IN;
input   [10:0]  MUL38IN;
input   [10:0]  MUL39IN;
input   [10:0]  MUL455IN;

output  [19:0]  MUL134OUT;
output  [19:0]  MUL142OUT;
output  [19:0]  MUL307OUT;
output  [19:0]  MUL38OUT;
output  [19:0]  MUL39OUT;
output  [19:0]  MUL455OUT;

// =======================================================================
// Wire & Reg assign 
// -----------------------------------------------------------------------
wire    [18:0]  tmp0_134;
wire    [15:0]  tmp1_134;
wire    [17:0]  tmp0_142;
wire    [14:0]  tmp1_142;

wire    [17:0]  tmp0_307;
wire    [16:0]  tmp1_307;
wire    [19:0]  tmp2_307;
wire    [22:0]  tmp3_307;

wire    [16:0]  tmp0_38;
wire    [13:0]  tmp1_38;
wire    [17:0]  tmp2_38;

wire    [17:0]  tmp0_39;
wire    [13:0]  tmp1_39;
wire    [18:0]  tmp2_39;

wire    [17:0]  tmp0_455;
wire    [21:0]  tmp1_455;

// =======================================================================
// Multifly 134
// -----------------------------------------------------------------------
assign tmp0_134  = {MUL134IN, 7'd0} - {7'd0, MUL134IN};
assign tmp1_134  = {1'd0, MUL134IN, 4'd0} - {5'd0, MUL134IN};
assign MUL134OUT = {tmp0_134, 1'd0} - {1'd0, tmp1_134, 3'd0};

// =======================================================================
// Multifly 142
// -----------------------------------------------------------------------
assign tmp0_142  = {MUL142IN, 7'd0} - {7'd0, MUL142IN};
assign tmp1_142  = {1'd0, MUL142IN, 3'd0} - {4'd0, MUL142IN};
assign MUL142OUT = {1'd0, tmp0_142, 1'd0} - {1'd0, tmp1_142, 4'd0};

// =======================================================================
// Multifly 307
// -----------------------------------------------------------------------
assign tmp0_307  = {1'd0, MUL307IN, 6'd0} - {7'd0, MUL307IN};
assign tmp1_307  = {1'd0, MUL307IN, 5'd0} - {6'd0, MUL307IN};
assign tmp2_307  = {1'd0, tmp1_307, 2'd0} - {2'd0, tmp0_307};
assign tmp3_307  = {1'd0, tmp2_307, 2'd0} + {5'd0, tmp0_307};
assign MUL307OUT = tmp3_307[19:0];

// =======================================================================
// Multifly 38
// -----------------------------------------------------------------------
assign tmp0_38  = {1'd0, MUL38IN, 5'd0} - {6'd0, MUL38IN};
assign tmp1_38  = {1'd0, MUL38IN, 2'd0} - {3'd0, MUL38IN};
assign tmp2_38  = {tmp0_38, 1'd0} - {1'd0, tmp1_38, 3'd0};
assign MUL38OUT = {2'd0, tmp2_38};

// =======================================================================
// Multifly 39
// -----------------------------------------------------------------------
assign tmp0_39  = {1'd0, MUL39IN, 6'd0} - {7'd0, MUL39IN};
assign tmp1_39  = {1'd0, MUL39IN, 2'd0} - {3'd0, MUL39IN};
assign tmp2_39  = {1'd0, tmp0_39} - {2'd0, tmp1_39, 3'd0};
assign MUL39OUT = {1'd0, tmp2_39};

// =======================================================================
// Multifly 455
// -----------------------------------------------------------------------
assign tmp0_455  = {1'd0, MUL455IN, 6'd0} + {7'd0, MUL455IN};
assign tmp1_455  = {1'd0, tmp0_455, 3'd0} - {4'd0, tmp0_455};
assign MUL455OUT = tmp1_455[19:0];

endmodule
